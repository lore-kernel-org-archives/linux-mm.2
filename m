Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED4BCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B654E8E0006; Mon, 15 Sep 2025 09:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D5F8E0001; Mon, 15 Sep 2025 09:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52EE8E0006; Mon, 15 Sep 2025 09:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7058E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E49F16066E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:47 +0000 (UTC)
X-FDA: 83891594934.26.420C979
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 725B74000E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jzNpMzwC;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=01E7nmRf8HztmOA44dUgiE9TwdkVxFx1dJ2O2VTJ3K8=;
	b=Dtn0lSNRJ5JxWfBUMCXUVG4PYrrewqEW8NoWjH9RmIhkBnUPF10XS3JZuTMw52CDw1kJGK
	zKk2a+SMFfBoiRjrZ4yVNa+6bjMww2V8Xy15TC6ShVhAster7/fBmRxqll30W3irEJZZkh
	vdvNhhs0//EVNaoR4zTw+8OMuz4a+Z0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943645; a=rsa-sha256;
	cv=none;
	b=P7RS3oMy5bMqJLI7l0KwDclZwd0sgnd2UcMZHGoePmNPiowFwP0sU6qHVAHVKboDu4Jd80
	hsUxUs3BusfCGpKScMjQ1Aq4eta3R0HHl46+KYkMg3W0W5FYsk17ag4Al1lEPQMEBc25Cb
	LycKyU0ZkbUf3ZL8n62MRz88p4Rm+ms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jzNpMzwC;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55f753ec672so4662572e87.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943643; x=1758548443; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=01E7nmRf8HztmOA44dUgiE9TwdkVxFx1dJ2O2VTJ3K8=;
        b=jzNpMzwCFOUNptjmzolz7moJPPFaXB9ILYoJ4/HLH3qPIlwzqcW+XIcHrGb8+yHxG6
         yR5G5i1fBEeOU/bXDeLW99MgKgMXlCWQXSh6oi58OQtwin0izhEmwu8vQjNA1S7P+FFR
         7GeFKFkgcnI/Xoy65xOj2ODARe2/9cICdVqRZgoCZYFcdvb3ybDZdxc84Rpy939hRbAo
         2gNP6Hz6xY1ATXk3r02fEstAEsEC6LCF1/9MZ9hJWdXwHYL3qRrvYBMN3SCsq0AgHo13
         S+TNHOAwsDT2FMCb1hDC8fHYplOI5dZIuoZVsOwStfZzz9J3xq5YKqFP2py0qzV0WXId
         8jZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943643; x=1758548443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=01E7nmRf8HztmOA44dUgiE9TwdkVxFx1dJ2O2VTJ3K8=;
        b=ANMZeS/Egw0sDv5/wYSjsmtcH7BF6Owj+RBvwHg/t7RncmHyn3beGxdgtINwYE4Lom
         7AjJgq82hNjz6IMVTK2uZ2aeERZ7q9et2Zax0uMHkQxOU+muTJ6GyKQLk9UI8/ndWwsT
         Euod2W1SMumUDrQJUfV/7e+7EM7WasMcGRXc+eqqWAQ9xy5fZovcOl8QuA+3DoVphHEt
         g+9dziOVW0k6wEVubbWbVfQrx6/eM9scX4NBgxlaHPLzlZsge0zxPzUxfaAikTB/JABd
         M3Pty94JjP1rnb8HJNWwH72Uy9D/LUPK+x6rBIGB6+6ix0A8816XruOkI2gpSHdD8nvm
         P6PQ==
X-Gm-Message-State: AOJu0YwiQeTOHgfGQfCWGInG+M+BBtlIDe55aNKDDSVESNdSyM7I1e2j
	rOvemIZZHu3RiYnlhAyLyP0bYijWBc9zkAIz9PS/nPG4v2uBoKmdWmxXGt/OwA==
X-Gm-Gg: ASbGncuNAJZ1vbOoCrKldvptSPwkL9fZ0d5vQOSlNDG8v12+87BaZL4xFLVl/RHGsHj
	CjpNU35//T71kSdB4EuhQRFyWtJEdLWnali93ALsBt+TG9T+/EZ9RdajHX4yrSzjY6BZidziPJz
	0Jta1FbjcLXyutYbsD6IMFy/CzwSRbNRYGrDt5nArYyzOpwwhnLl2QBuqdL4RksMFha6cH5XCRb
	L3v7by2fw5RK3Nw40C4J5BJh5JNDsKyUuy7ehABOLj90iSdqj38CqmF7I4SCAZmhfM+ASOthVKk
	ygxJ0gJcD+hv33xNWeb/6iEm6KPQFSQPTkIJkGSjPM96M3N2hDIjS47Ph5KDGDJvfq5P2sGaLlZ
	yIKs/c7Oh/KoEUHLr
X-Google-Smtp-Source: AGHT+IGwZ/j0Rorxt6Yp74VSt409JeQQkH2MPa8G2UTjzOAitflFcIZEoZX3Dx3EJaTBnMdbvTXPXQ==
X-Received: by 2002:a05:6512:2606:b0:572:7e6e:d311 with SMTP id 2adb3069b0e04-5727e6ed5f2mr1776305e87.1.1757943643203;
        Mon, 15 Sep 2025 06:40:43 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:42 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v2 00/10] __vmalloc() and no-block support(v2)
Date: Mon, 15 Sep 2025 15:40:30 +0200
Message-ID: <20250915134041.151462-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 725B74000E
X-Stat-Signature: fa3ih18zp7btqdx6gs6qmh5rwcuw3rof
X-Rspam-User: 
X-HE-Tag: 1757943645-623925
X-HE-Meta: U2FsdGVkX1+w6vOtPzr67rnz6rYwYtrOl09CQVi+JI+x17Hdh3bS0qMzhAxo33TZCdS0Vnl1Xfj9Plaf/GpNbNoJ4XX8aawpQ4FlungK5AhFvXffce5eIo920k6MoiYWKbgezgMPQZpGu5kZKDKO1qoOVv2Hyi6yE0vwqvODbq3YWQ+A9DtKUeUF4XJg3Saf9uFLmiYN4OMq1J507Vetfmt6nIvDEPpEZdeNVnZBipnZOjB3svWCSV9sWqPxVvUqo6Vc64/C8BNhIsbbr2g8j++Pg5bMLtBvu6lKdhjP4WBvsWIvPjvnMfOJPcK24ldBNI+TFiJmHpalc/8/t3iCm9ubXDqU0hJtbcyFfieJRVYI9N/I1Lo6mf9lS5M0cJWV7wW2MKmCIBsRxo7cr6nx7tTGt1dGQEYrD9B6Gba3o49nMyDUow495iC1eXLVp9QWvDo8cEsJDFzWGu2iKMVavLRQbvManit7oBZczMT0ZgICo7eLYkbCHT5uaM0PGluemawc/yawVbFRsoQD+DN+0ISZcgTqB4zHyCmlSg9ImrTS8g6wKJX7pKO2XzPew3tVlAV5gVAtgUavZBxkfmJ15e+iwm2w3Nc2+D+axV+HC0vPAQQvFRMy/4AmVka9Rcq64uaNkg4l0LjHwB2rdAOY9wRuiS1MUn+EUiohDOx6ia4vvPLV14JjXOkAGIfQ/CyY27PEZtH+RMZxf5lTcBBpx/1V89Job3tqEvGzYrrGrVVBupfQ7COJmfSvy0a/u9PhWwAQQMRs0Be/6fh+n9zFWS0RtL0ERFUWJkwLzwlNgciVCSjxET/ZZ2ZRNLyT+lkjBW++M3A/QK1yNU2ylUyTmM+F1/xuZxpPGIV5TJHo3Kkeq3jy+qyaicnzZrftmgrHoT7+4r21RtnIY1MdaWWbJThkngFIXnz4hVhPAqhdIMMyYFHNMRkZH9t2Rwyzuc0FnCaCuShJFsDCUhvRc7/
 BIlEoWFQ
 4aMixDhnCMB/r+Kg3zaTJNT/sSft6Q/3Bg0S94PiIFXUTN7KFDdR0Yf9SWFIglhW2itpyNTC0rtBxfUSgQBBnAgyLyIZ/eF4ZI2XTNhV5zpH3SNdl7xRwPXSgaCW76AdZr16JKgZEv0rY2eIGmPk73qMDMcs/spZQSa1OZIXfpemOfoCHxYEJqQsXyeEUBQNsF/4DpYeEptmNAEUX++iei3I9rj2cbpBc5jfLCT1vxqgfqwFmPeBwEeCcaI+aP4bxwj+zAzmVUxn5GP+FmKcFj7K9xLCv5rWK3XC0eX9J+NlakUbIALmurtts2mMSU2wQpGDIAC3yJRO6o/2ZknxXITkuWQvutNu7yImOD31gO5v5UqGAUqXd7Hi6Vn3cZqCN77T2sXz8UVVKOwlHdrVjNwcnNAluPaHOuyZ+xOooGlxr7XMXM5zVR4Spy5Ar2YWcJTpI50/Bydb5aoo6+SnaQSk2zjsCh/+tz9EecR3+KDauCbjJl8wtDvCm0GAElbJOBp/q7JyInBssSgftwXUT+yILy8TigZ0UdzN0zfJMM7WR2CQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v2, i do not count RFC version. It is based on Linux 6.17-rc6.

https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/
https://lkml.org/lkml/2025/8/7/332

It makes __vmalloc() to support non-blocking flags such as GFP_ATOMIC
and GFP_NOWAIT, vmalloc_huge() is not supported yet.

v1 -> v2:
 - plumb gfp to KMSAN for its internal allocations;
 - update documentation of __vmalloc_node_range();
 - Instead if dropping direct reclaim flag, check PF_MEMALLOC in might_alloc();
 - dropped "mm/vmalloc: Remove cond_resched() in vm_area_alloc_pages()"
   patch and keep cond_resched() points. Need more investigation before
   dropping them.

Uladzislau Rezki (Sony) (10):
  lib/test_vmalloc: add no_block_alloc_test case
  lib/test_vmalloc: Remove xfail condition check
  mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
  mm/vmalloc: Avoid cond_resched() when blocking is not permitted
  mm/vmalloc: Defer freeing partly initialized vm_struct
  mm/vmalloc: Handle non-blocking GFP in __vmalloc_area_node()
  mm/kasan: Support non-blocking GFP in kasan_populate_vmalloc()
  kmsan: Remove hard-coded GFP_KERNEL flags
  mm: Skip might_alloc() warnings when PF_MEMALLOC is set
  mm/vmalloc: Update __vmalloc_node_range() documentation

 include/linux/kmsan.h    |   6 +-
 include/linux/sched/mm.h |   3 +-
 include/linux/vmalloc.h  |   8 +-
 lib/test_vmalloc.c       |  28 ++++++-
 mm/internal.h            |   4 +-
 mm/kasan/shadow.c        |  12 +--
 mm/kmsan/shadow.c        |   6 +-
 mm/percpu-vm.c           |   2 +-
 mm/vmalloc.c             | 158 ++++++++++++++++++++++++++++++---------
 9 files changed, 169 insertions(+), 58 deletions(-)

-- 
2.47.3


