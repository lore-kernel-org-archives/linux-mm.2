Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B68CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F168E0017; Mon,  6 Oct 2025 10:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01B88E0002; Mon,  6 Oct 2025 10:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0E18E0017; Mon,  6 Oct 2025 10:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9A3A8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:45:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F6CAC0609
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:45:50 +0000 (UTC)
X-FDA: 83967963660.16.1BB51BD
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4CEF100013
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:45:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759761948; a=rsa-sha256;
	cv=none;
	b=jpZABaQcq+BqucOC5hGyZQ+ptgQNXrhMZxC7g9v8v9Xf2/xQeSZ1HdpOEmEK5ChuYXeoQu
	m8bb04uL5nHJBJGLtvZ1A4y0GHzhO8z5x+n7wRF9ESAIBFi4tyStBVjo+Y2uP9PUP597lP
	Yt2+7LXtbi96d3KWuPq9G6ryl9sY4vQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759761948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=mbi97d0rrEhXFPx9xb8HNtK7TcQbHRpYHFxMYmusqFU=;
	b=Dwmp9i6ZTKz5dN0PWWNv4XbpraIAWHFFJXqvrczrT6+pTlJWKbsOSRpZzGlz7BEpnq9neC
	FyqeTaQV6IqiLhm6Ijll+N4ybipuAIxNpmR5SWEI2kXLmp/d+8MNfht10rzZ5rKEhaaZa0
	3GsIjoDtKBYbJ3HnX9e+B/CwQ8SEkJE=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso30025655e9.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759761947; x=1760366747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mbi97d0rrEhXFPx9xb8HNtK7TcQbHRpYHFxMYmusqFU=;
        b=uXX4GE6PJmmq5zgKnxerlFkxIGHDTSSENScpF2nnn8UOrVS1F2kjuj/dH5Voxzct0i
         ICoWXFtWTtedQ5qTZ9sKo1h2SJiqen2kFKZfEK+S1wHN6ouFig64G54c73W8x+QzApHm
         7TirVtdXaJ/2wizHt94BTpWunhlR6H0q8N3fhZRPC0498Xv6GoAnQjXAXYarMCO7Z956
         rJa9C7yrSJ0aI17WAyT/CcrqoVHcjYL1Z/a492lvJa4r5FyYkZ3L7FWiHnKQmugDJy1Z
         B+dy0qE1JCFXmt2DUbBrvt70uE0BA95/6KfFCMbbIcygZGXiDUyXqGLJEu107C9HzNv5
         x0gw==
X-Forwarded-Encrypted: i=1; AJvYcCUlDcmfBI319l7mgm2EeIWiOm61zZ0GDCMMhO1xC9O2E2mJVsIyWsPmsdaynjxwWsIGjHNVNG2EiA==@kvack.org
X-Gm-Message-State: AOJu0YyQLee31OPN92KPTXT6cv24Eohk9xkQQ0Mnx+r1rjGC06ouVy0D
	3J/VgL0Zy98WZh41nfANQ6eCjGXPU909z+zg1VPEZFzaVWjyLqz36UUf
X-Gm-Gg: ASbGncta+tl3/U7Zzz0jnG46BiV40F/sk4dBl08xJKYBiPele+Z3/E7Ow2tKBo6VN0C
	2sB73S+hLXgTnkOTNPtp5gPzBrIanTH12ThZ0yx5jiZp5Cs16FDTHurGoP/gqEOZpofniqJvoWo
	xXZnpZ/na4mABoOnDFbV9o7g8P/GVY2Qi79YeL2zoGPcDuNmy6v6eYbDGqtqTtNA9Vo0gA1jguR
	kgqEvbsdpfUhEbdVLVJT+KsVOUpLgDM7ycDZYMU1UCiqY/TYGpftp7FpbfzO9woRIfIAJEaAnHa
	VLNjQAzQUgeQUYxlxSVW1VqHRhj7Ayr9DrZc4GicoYEyWmXzsckyZ3/nJe8TVjS1D/llfl+DHyr
	TB4jHWJ63UH6SxqO/U+TDqoXEZZ0z6j4jSySeP39Im309W+YxdQ==
X-Google-Smtp-Source: AGHT+IGSXg4krW88X25pKMdWNSxrnvZTh6Q/uva3k1hELeEzxn4ObqIjdy8xV6ZqzGYl24DrHHt6Xw==
X-Received: by 2002:a05:6000:2407:b0:3e4:5717:368e with SMTP id ffacd0b85a97d-4256712a5d1mr8126669f8f.2.1759761946831;
        Mon, 06 Oct 2025 07:45:46 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab8b0sm21242624f8f.18.2025.10.06.07.45.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Oct 2025 07:45:46 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new v2 0/3] mm/khugepaged: refactor and merge PTE scanning logic
Date: Mon,  6 Oct 2025 22:43:35 +0800
Message-ID: <20251006144338.96519-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uwp9cnrtkj46fp74omje3o33dachoep4
X-Rspamd-Queue-Id: A4CEF100013
X-Rspamd-Server: rspam09
X-HE-Tag: 1759761948-649483
X-HE-Meta: U2FsdGVkX18a/tO0ss+t3LQVxVd08SgCgaI99ci+fJ2x0sqqJNcOR+H6Vy67aOMSwNOV+YTnIXQ65CLC3XOpJf/VeQJXduuouKGIerHJfhJDZBlaTtbTvJqMHOy5XAUlFiNK85wkEOC3pmzOTITUwtTpaL3JJuhiLJTt0dNEgRfZuozkijzRToKHe7UXTe8DubpqdbWAEghHjj8zjtsLovtH0ry1NhBrJ6M+PWdxtM9wu04wJfIcCHA8kMyb6WM7mpbYta7FPbbAA5/sD8gxlj9fYmpHR2J/P7pkIQFKQc8c/HqnscGaj7nF8bdE00Sof0wa8icmOWNG1hqazJYQPD1vrazuO1r8VNC38CdZfycpUypwC7u+2AfqYQhpWlMviMRXUPtsaAayPajrtMedce2kz6tKvDkWt7fRPEX1Syf66lQD0QEjz5zsUx4+MWEhoo2WQoWgi5KlesoQ9DOvN5aWYXGHcOQWu3OxENUvkO2+LR8DkQSbt4B6+rBofERal8E0n1lMPtZxKkEhPMKmBVl9JejxxYoDfO90uE/XoPC+4QZndlRwah3UjE+jlfpoqJjg4u5epqzhtiJb+3ihSU9ChWC1/Ia7eD86QbdreciiPk6n0rj5Zc575QhJQO1MJbQCR547v0ysJoOwUglC4pIjbsR2MWgSAAF6Kw4457PJV6bHcSL52/kesveAypkMCU7S7EKppW6pWK+bzY43e4/ayrarymX3yUm2kUj5F2kVhQuzEL3uGC0PmfWDXVi4Ux8x46NzoOOQb9wkkcVdMdY6AiSA2s5jYRoqY2K+L7JSYUj8umGY0cpSXBNkgfbQ5xs0NMiIV/lg2Wj8QmkRuL6LF2B7tg4+zEFBFf/5e4mPZrH/BzHZVWizlg1gJm7+1GGWBHTeW+1tlDKe2XlRw6pn9Az0Ec7xyot/zg/SSm6Qouo2oGN6oR4N0rBI+H04elzG6HWrqdQ3fV8Xa2e
 o2AeAAn8
 v/pbjaPwudRBEcwh6PYvQlaZnbcl65nNu5z8DmeOYt6FMF7LzmJrbKvjSnWee+oAfAp/t4yoCjqgJ3cMsY+3YNv6IXYwOATBrSlAeGNyo7Rj2tNiGw0fcY9IXNnf32u4prwIHxARgArGK3Ajgs9Fz4GZ16piZmrzP93FOJPBddOXb7+hRGB934gnSLRiIf5hfKn0RfdEuGygU+N73e8QqvkNisEUn3Mvofa0NbufBrajQSg1cd4iN3GCwo4Hd0o+5Fkkgqim9MC8ZO+T4i3h2pt+JM8TuAV0+1/Xg9hhPdtmKeOqXFgXHLSJnIbTBgCNyqc1rVZWa22DcMUKFCc+mFah3kaR4SDrT20SP0R5DXsF2DqxWNceVBiFlqAJpqrLawo25m3nREodYOyc7W30CzgXrLhmTEtgReLREicHaQmQ2XS8Fl+3eOLYXLfW8gQS9wpR9wzWwSnFi2CJMhKdAHcO1byuOcfljifTH5lGfzEu+/K0E1MfLDiAnI4JO9zut2UP3GsQT5ZpvP+Oh64xYjpqfNBWD0a+jIfJ5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series cleans up the almost-duplicated PTE scanning logic in the
collapse path.

The first one is a preparatory step that refactors both loops to use
a single if-else-if-else-if chain for checking disjoint PTEs.

The second one replaces VM_BUG_ON_FOLIO() with a more graceful
VM_WARN_ON_FOLIO() for handling non-anonymous folios.

The last one then extracts the common logic into a shared helper.

Thanks,
Lance

---
v1 -> v2:
- #01 Update the changelog (per Dev)
- #01 Collect Reviewed-by from Wei, Dev and Zi - thanks!
- #03 Make more of the scanning logic common between scan_pmd() and
      _isolate() (per Dev)
- https://lore.kernel.org/linux-mm/20251002073255.14867-1-lance.yang@linux.dev

Lance Yang (3):
  mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
  mm/khugepaged: use VM_WARN_ON_FOLIO instead of VM_BUG_ON_FOLIO for
    non-anon folios
  mm/khugepaged: merge PTE scanning logic into a new helper

 mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
 1 file changed, 131 insertions(+), 112 deletions(-)

-- 
2.49.0


