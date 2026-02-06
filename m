Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C8FCECD9BB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 02:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4016B0089; Thu,  5 Feb 2026 21:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3821D6B008A; Thu,  5 Feb 2026 21:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E286B0092; Thu,  5 Feb 2026 21:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1449C6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:14:35 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7217C24F2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:14:34 +0000 (UTC)
X-FDA: 84412412868.25.FFA3683
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4A7B140002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:14:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HThL3pM+;
	spf=pass (imf09.hostedemail.com: domain of 3h06FaQgKCIwzq8432yAw44w1u.s421y3AD-220Bqs0.47w@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3h06FaQgKCIwzq8432yAw44w1u.s421y3AD-220Bqs0.47w@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770344072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wOMvatFmTNuXEwXOvg3h5CBCiVV90WJG1wSdmd/lsBo=;
	b=xjzFa0qOHwOuEJpyK8xyGnuVlxipJh56jz8jHfXSUoqahJtHuhZ3o0CjFW5lM/2N6pd9Wt
	LaQ9MQmpSmG96vhwr5aerPYBqW3EJK597REEslTRuGKfDzCDSwLhBaimz/TEukEDkOaMwL
	o3Lf03AW6hs9fhfLdq3Hiqh/dNhqPkc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HThL3pM+;
	spf=pass (imf09.hostedemail.com: domain of 3h06FaQgKCIwzq8432yAw44w1u.s421y3AD-220Bqs0.47w@flex--jasonmiu.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3h06FaQgKCIwzq8432yAw44w1u.s421y3AD-220Bqs0.47w@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770344072; a=rsa-sha256;
	cv=none;
	b=yg86rAb70idCPrCck5oUrrFsbbYUWqmNwQ47GS3L0kgNsgDjmdZ7VTu4uB2W6E/ni6h/Rr
	RnNlxfgE8t5kG9oslFCQ/9qNnmTYtc7920OXsPxX+NKMKL2Z8D7snSb+lFhBaq/CmieOxq
	vkIhtND91XCSSKrYMKllQjT+fH1u+Ik=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b708fa4093so1580080eec.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 18:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770344071; x=1770948871; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wOMvatFmTNuXEwXOvg3h5CBCiVV90WJG1wSdmd/lsBo=;
        b=HThL3pM+VyBdC2/lf+DTbkeVIC1NilAVzp8Q/XcOj70VBEtD/7+mSEr8X7PBz4xX7p
         6XJDMAVAZ1rqLpw6V0U14BriW5OcFY8h94w3YrBL4T1rbl8gdBtsN7cDbPS3c6KpBAnp
         oTRgpd0J2dwc288wZXUwwt+3F5Q4iFJCR76g6bO/YBTNu+oa04K5vu2kICyxHzXOD5wC
         3qikq6CbjU5oeKQ9WVOvCtSywLGDHeK73mlXVnlTY4kNGQQ2qcIDXn25ZxTEEiH6HPk5
         r+WotpZu0Ib8EGQjesmSifKaRmlJSmgYivK2P5uw5s6j2xV6RTK8XeL+ZVSXltPTuJ5E
         aWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770344071; x=1770948871;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wOMvatFmTNuXEwXOvg3h5CBCiVV90WJG1wSdmd/lsBo=;
        b=bct62wxDQn7p5KMieBELh7zeyLD4cDPh8TqZC17/IqhKuoGW0nuhYtpF/y4H5iVOfS
         wSQT8qTg8qcWsgrI9HYje9PaWchp7BlYcKYyZzROzJSnykXaHSeSDUVG6KMs5ZkFZwTJ
         jcTXIoiLTZ+kJdSoVcNANf1Ww2oKPeB0FrW9TjAvs/8yuMHl5mBcSwIcimDboCxPoeLS
         lBfUpMimj45YAH0BDhkcumGcOt9RhbGZoQF5xZrME4JnKnIjoJrQKbo036r/YExThI1H
         1QKbujwJaf3x2le8rUck1iZ0HUTGpBSPFyVGQS3Cxkzd/TvCSQbiGpW7k0aHyONWc1zt
         LPKA==
X-Forwarded-Encrypted: i=1; AJvYcCXvyJiJ/MfP17AZdV1Nbsxnf9F64y6RwLAYhHVRml9EfVvzYKutYUKY4FmIBfiSxyx8Foa33a8S8A==@kvack.org
X-Gm-Message-State: AOJu0YxlSNvEDSzIuHevcxrxjoQwQWbjPiyWUbdsG26bvpNt6VAExa7C
	3FQRF3p8TJrf5CPhgt/G/BPjpbAcSNPTk06KbT0W5azI/qqNTNNeGt0S5/xFCaZSqZO8enxfr7R
	mQbGm44huq+COrw==
X-Received: from dybgu5.prod.google.com ([2002:a05:7301:2285:b0:2ae:51e3:c162])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:2d8c:b0:2b7:1c58:dca6 with SMTP id 5a478bee46e88-2b85646d9c4mr658234eec.6.1770344071405;
 Thu, 05 Feb 2026 18:14:31 -0800 (PST)
Date: Thu,  5 Feb 2026 18:14:26 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260206021428.3386442-1-jasonmiu@google.com>
Subject: [PATCH v9 0/2] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4A7B140002
X-Stat-Signature: 65krnhrdhibxc7wyuzqy4nadbdeuabpc
X-Rspam-User: 
X-HE-Tag: 1770344072-176757
X-HE-Meta: U2FsdGVkX18BKRtdUOuIxt1N6xnD0kajWMgmfBETcAIttoPR2yeVq2KkNFQ4f8PT2EbAQR2Eul8Ok4sHmFdpBgPHcBL+jy9qc4qstSfLSMvhW7YP27cOH7ES4TzLBh+60YIrTpUkTSNqVv7tK3La8WdEYAA0paJqJw4IXRIxE/5BDG9pVEbF7RCKUR8TrRkVFks+oKlrSg4OvL9xeV/zaEYAzHz4xIIFCV3bWPaxY/kXS/GZT/wYKjve66apMThEFj+kKYuyvX2f0W2y8HE5ucFcE52lErTbOkv2d+Vvh2Y05yQhwcQtQ0JBClyeR4AXB0CV2cYWR3eE1AInHf7PkiBVrdmZFBgGoJh0UPZOjSFUnx51gsPbTLLxEn9J7kiajYAiIHpDn+dArN5bMWTlOO4XezRUiiLJi9qeHkAW9yYr32wEG+eVmB3xYlQk+Ncc5cBWnv3T2TOA7IkL+Qh7uVrZifRnRIbmCFrasA2THhcGWaZ6fmncPWnaVMo/UxGBEhCiATyyeddiH8UM8OezCYfHjc24jyl39TJkzB+PdKbZXIz65G3dMiwXzz0jLl5r0f5v5Q/yCP+KOMs4hVPzOed2ybDl67ce4xOLWBlb/ddkSsAAetFTEs/Xe1EfLOnkAyIfdR9DYTEYiX81cTIsPXAzOZ7q/HO/BGVoTEa3sqClIscVQV9E2goFCk/VJfGQpThICgnu+KvUJZLadSAoepugR4/zBasoWykf/d2DaRSy21uJS9732abRptrfeOCgm7NA8oQt52ai0xvGmrnHm0kDqvwWtaudrsFkSdboSY3oE1ElCpNzEyEN/QrdzOIQjCHmgDBs5B5krgaIyaNaSBkEI3uXvamlTJw79CCU3myBvMG4DJDMwsBjlvgbTUjpEJqBtcDE2ZLe977n7jA4OmZW4uDjvkMZlkYx7j9iUBRt5Bj8HbUW2zyGK8TbrEhgd9dV7LkdjwbROk4jMjP
 R1oAR4ds
 rzAB4p1TeIk9uxgC2bVhSrbvG7tdZgkJR4Hvt6yFdhuEbpRwn/bdgmkEKA3JXl0iRo7kcXRIM+p9p0IXo3CLYuvXZmMMlIwZgKqlnF6yy7rO5DkRFRi0OH3vlu1aXTe+AXMzahb1qjk6M/fOJKJL+ZgTJnPZEMnI0pudvq/afkQU7djRuofVrts+7SIf4hqNj45YECZFPHrnMAFi4u1A/ED3iqJbRT8W155flDWKc6XkmY10uQrYEbI9CdTpYmzswX5eHsBfwqS0vj9chnEP5sukfashCjl0h/0MTC4b0dstDEiW8wF1woGwbp2EGIVMRJfLCdlg6K6owdJAKY9RYYY+5MQ2z0R16sXM2EUOq/jrF2+qMv38QHoQtiuRSjgIDCmRWdo7n5Fmvb33wYBTwhmZHrovJ4yOCYBF6qkM2BIA3az+gtcWRCDdEplTiivJIjByGurwJDXyGiib+Pt9Kb77H9NUhhKMdQzqgekeJkcJMY100QCDglN+a2Gg6zaDw+ukWEwkKuUZpV1ZuXl/2IZu8dO5cLvN+fndJQw0kXZbbZ4U1gnyIYN0L6XRpRAlksxY3vBD+YRfuV+5a4a2clM1259sY2oTA8jKbNCUnu1tjeJpCqMwUBFpRUHTCNAq3QLK0ISZC9hOdDvw/OwvDFbJEWKCogWnkxN6w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to a radix tree data structure that can be passed
directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmaps where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

This series is broken down into the following patches:

1.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

2.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changelog since v8 [1]:
- A small refactoring of __kho_radix_walk_tree().

[1] https://lore.kernel.org/lkml/20260130005739.3163049-1-jasonmiu@google.com/

---

Jason Miu (2):
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst        |  53 +-
 Documentation/core-api/kho/abi.rst          |   6 +
 Documentation/core-api/kho/index.rst        |  18 +-
 include/linux/kho/abi/kexec_handover.h      | 144 ++++-
 include/linux/kho_radix_tree.h              |  70 ++
 kernel/liveupdate/kexec_handover.c          | 672 ++++++++++----------
 kernel/liveupdate/kexec_handover_debugfs.c  |  23 -
 kernel/liveupdate/kexec_handover_internal.h |   3 -
 kernel/liveupdate/luo_core.c                |  12 +-
 tools/testing/selftests/kho/init.c          |  20 -
 10 files changed, 571 insertions(+), 450 deletions(-)
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: 9845cf73f7db6094c0d8419d6adb848028f4a921
-- 
2.53.0.rc2.204.g2597b5adb4-goog


