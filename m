Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A46ECD6DA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 19:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FC1D6B0088; Wed, 11 Feb 2026 14:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AA366B0089; Wed, 11 Feb 2026 14:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A27F6B008A; Wed, 11 Feb 2026 14:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 672BE6B0088
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:52:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05EDE1B3D09
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:48 +0000 (UTC)
X-FDA: 84433223616.01.B4D0FF2
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3EB1080003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:52:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TX/NQLWF";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770839566; a=rsa-sha256;
	cv=none;
	b=rvdcrz3b8JKtKZeKs9YSSkGB0CKuCTXw9fiXT/9PTCODal+Zmnt/X1s8zrXk+5oc/1mwCq
	0Yix6v6BXeeqCa6QEkTYk9DD04IygGzjbD83f3j3CeJi/TZ6M0mmAcyeDLwLgG8F23qXTG
	ttOM/K2H/rpGJuFlEjuDKkA9zVZWCfY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TX/NQLWF";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770839566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DwdVRQZqmcdkGwX+Scl6BVHlEeEKeFsTpXtbTUh4wFU=;
	b=UT/gerJOCOj54SVqTLv5nBMZNuWHLQ03NG3YdrFAbe7g6rXR+TM19NHCMqBf82x7m3X79b
	qqbSVxvbyvjHKcqFA9WWObVsW3TgYjV3kpFtX82KTQXd0+Kic9mV+gh3ZvERW/QywgxKS1
	G6xpdbj5fYFv3VopI6ugKA9XqgbGZqY=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2ba895adfeaso2418357eec.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770839565; x=1771444365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DwdVRQZqmcdkGwX+Scl6BVHlEeEKeFsTpXtbTUh4wFU=;
        b=TX/NQLWFalsqI3Q/lAJEGNgPxEr3hHlUvPUCjg3vTW9liFuVZ8YLhAtjvbrALuMaCu
         +KIR+bxE7Xm8R/1wAgbcLR6rPdD+vGaZXJ+zWfvR2/sbil/2aLiIWnRd46eKaOV8Emi5
         ZLItNC9Blvc5KxRww4WAhZYgf0wltlWP3D8oKKjIbhbBhNXuHV8dvP3pZRbu8MWKykod
         o7BBsTByR9SD8gTD2EECgykUMG+4kBjBlU3X+mFCv7UyuH62xrMxr6vzNQgZ6Fyl5s66
         /kv5t8zqLHO+7NlM6WJpnf2hwIIZiVgRQqWPGcKE7a5Zt0a9s2ymeKEsE5G2qnsmQLpb
         l04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770839565; x=1771444365;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwdVRQZqmcdkGwX+Scl6BVHlEeEKeFsTpXtbTUh4wFU=;
        b=PY/pYbJC9pAYoJxtWLhtVXuaFN31k5JsQqxAkDakjtWFWy4DqNvMYjFIF+3+bQzLBW
         sikNRx1VHJYYaJZwcVI5xAMn527ravbhWOu7ihNA0H05lFtQGYQAmhUQvkMfa2Bs3Vto
         +ICeHQXec1lJQpl3EGR3d2Ys7zRLjNA2UpAm5Z3xuCSizcRCMBLrdwkL8zTrgs8VCfA2
         d8Y9aEUBOvI2L0pUNfo9fMVtxx60YKVIxTZZtgyvm99e1rG0J51EONcMhVFrg62OdUNy
         whTZfEvR8wb6uhUZsCGihcGZXGrourcAmApckzLPgrfNBZbz35OwOzwHSraL4IzCQ+kW
         LDeA==
X-Forwarded-Encrypted: i=1; AJvYcCXj8nk1Mup6AffaUmNNv9TO2ZhDAr27ZpmsuUl7QBaQ9JIGiLhHH4vklPJ/j/JeHLzHP93hg3LU/A==@kvack.org
X-Gm-Message-State: AOJu0YxDR0a+3Ul/GyTY599XiJEKNuOAe/LIwqzPTMey63IAjUYj+3eb
	zS5bWGvIGrhWMwlj2+HfkHTbGiYGzQhlE4LFZQmkJ8wD3WF1dm7MrMtS
X-Gm-Gg: AZuq6aJUFjtCGAb1hum6tKjyBleyuzbrUqaoLpCt77uPjJiqCjBKGUIahcbDD1n1r/i
	+5WYtNS5tzh6Y3fUX5eFEiRVA+MrUF/2CooJvRl3Bjn00q7yHH4Gv4hCKrir+ldWgtmeeNNKy4M
	hflWtlh9mILxZBXTdrOsWHenRMQJvqK99Mh9KvEZy9HoiImD99jTNF/bv/nVMBoEOV1bUJnPd70
	bmsqhZGcoVUTmPn3xz9CFbCrlrhTRTpRP2Gooi048pBZuOTLJLOphy+ZCYptUgV9LXWquPUnP1S
	G0y67caG4moSp6hjm3FGAHaXqxTdSwJVnV5TSqEqHqfp/YnSXTutfZjFTdAwrJLbmMi1puWWukA
	W71tLxpqBX9McvxHAS+3xygiCM/j7Td+R+G99Y46n8ok9NORmoiltCupRtMwObPEsA/CBwpWaHd
	vhleV8IQCqArwU37ql/y+FTnxNFRwAbhS2l0EVLPO94C5o+IADPO6GFvI=
X-Received: by 2002:a05:7300:aca6:b0:2b7:32a6:82bc with SMTP id 5a478bee46e88-2baa806e047mr251899eec.26.1770839564897;
        Wed, 11 Feb 2026 11:52:44 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-2ba9dcfe6b7sm2426463eec.29.2026.02.11.11.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:52:44 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v5 0/4] Convert 64-bit x86/mm/pat to ptdescs
Date: Wed, 11 Feb 2026 11:52:29 -0800
Message-ID: <20260211195233.368497-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3EB1080003
X-Stat-Signature: c7xzy47dnsyhspgztxcu9p34md7ycuok
X-HE-Tag: 1770839566-629456
X-HE-Meta: U2FsdGVkX19luyONJbpUSuezsxLTVfboUFC3qk319xesDuyb4UdmZFnGKHOXAfu0BB91mMDkTl16NB+CnTp+xgAFybmWejt7X2z4S9KyXpMoLMU3Ds+5oUP4U9kbVO1LeAuXQWhRtozFY1w9GGmOmG8sdjDs2aIr9usLph9N3Yfj3nvYCGSUdixwakKWDjk/Cztjpz/42zkSKucvcTjut0x3kiuauCGO/3fpLi/r37l1Jyr5UERNB7WNR3soitq10cF4LuIJTAIhUTcPiCoD0OooSG/BC/HptHSWeoK/eOgKDiOmm0bJY2g9zQvOkfLmvQ7Nnmh2R1ilcs8yT0z9WqfuQkYw7evgcMxFDf5FWqzABY+gXN5lRcbPy0WguX58jt7POeCI9n43CJOKXfryv0XidtF6K4ozXlOD6PfvxiJUFJpoTKTJ2pCspRdzlFNXTf0RQjTUmenZMFjHmdn2R0fX7hAU0fxTF1WmMnPdNLK7HJdKQ+FbKeuba0wOoJRj/g0vwdwPhpjgc74y/vZ+txXcJ5lQDliB1Ll6KiTIQ2AGAgCBlU5GnRYFzJLIB6IG/d2IJQemToljm/vjGI5jOot6DSH+jmKVgL88IWRK5eO8bERjEgCR8aYohEuIodYqfwSxdSFEvFvUBPpTZzjKm1QEBSvxLR+UCJB+v5dHU2sODR9ehRE2d/z0gK6idSA30bvyT3qk2qSdkpekblqLgHhemOzAlqfvWyZSpQQ+9qBbH2Ntd6JbX3WXDkWXgwW6zThIZ95pV8fanjKIIORoBy8gWaEtew2Auo0NOdTlyN9dHARtbaXOCGiKUT8/4IvHX75hX0PTq85w14jPsm0+8nrv8whmPqyQot98zNMo+Y2o5bNa0aGkGbOID5D2kPOVJVl9Odg6AYSEbm9Kw5ZYLU9DtEGbNt39dYAn0s+rntZvT0mQIn9bv4RpN7TOKqqnv1zl/zwcT9a7V3/dkgp
 IXRWuux0
 Hq31xbX+9tvMtQAn0k7tpgxkb7udWrOxrSJkzUxIGbdP2BHA5RsppMtFe4Az3J/Gbvm9+9mSeiKFgv/nwhW1YxNPTl1FQhGkYdFR7s/H6mdK2GUh192VmZVrwRzea4mdVePx0lVFRluNOGJDjWAgzP/9crd6MzEl5FAwPYfyNgjMxTsEnVXf3uARF3nE1m3Sfw4/ztDCcZKbJUZ68bWWlPg3YgXvdkfs93/m6IgAlR4gRZIm7VmRBSRjkGAeCftvcfqHjP17UqAINpdnovGk1khh3oNz2fqEoIjzzXqN+xtC5c92kUmLsMx5vtP6Jq3MsmuXVVk5Ldc4s9Wb9xqYwj59Q6l9tvjLyR40mIs8RHWbabEZM8jwzZMBCeVkx2ItgqTHN9fOlHH51G6SHiCPnMxT2tTttBusnEZG18zHeWfVuWLZVmiayfYKM1s6xJ1u6U0O5kqoIj/PMcdt/KuUJBFnEwpIWzHmotuaB7zPox+U7lKSxr85Q3Dikui7NRNSGKP8VxHrfbEEgTa4WWaCVrbG8Va2euxIbzirxZJF8eUdqLMMUtwW/Nnqtu8dUdKSi9DDdR8lq6ZDsGMfEkinQ7gZB81cbZvTVfHDCB1Yux2C+r+5JdGma29VlSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

x86/mm/pat should be using ptdescs. One line has already been
converted to pagetable_free(), while the allocation sites use
get_free_pages(). This causes issues separately allocating ptdescs
from struct page.

The first patch introduces new ptdesc apis that operate on addresses.
These are like get_free_pages() and free_pages() helper functions.

The remaining patches convert the allocation/free sites to use ptdescs. In
the short term, this helps enable Matthew's work to allocate frozen
pagetables[1]. And in the long term, this will help us cleanly split
ptdesc allocations from struct page[2].

The pgd_list should also be using ptdescs (for 32bit in this file). This
can be done in a different patchset since there's other users of pgd_list
that still need to be converted.

[1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
[2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/

------

Based on current mm-new.

v5:
  - Return a void pointer instead of unsigned long in allocation
  - More imperative voice in commit logs

Vishal Moola (Oracle) (4):
  mm: Add address apis for ptdescs
  x86/mm/pat: Convert pte code to use ptdescs
  x86/mm/pat: Convert pmd code to use ptdescs
  x86/mm/pat: Convert split_large_page() to use ptdescs

 arch/x86/mm/pat/set_memory.c | 49 ++++++++++++++++++------------------
 include/linux/mm.h           |  4 +++
 mm/memory.c                  | 34 +++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 24 deletions(-)

-- 
2.52.0


