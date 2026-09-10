Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44F6C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 03:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796666B008A; Wed,  9 Sep 2026 23:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7471C6B008C; Wed,  9 Sep 2026 23:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D0E6B0092; Wed,  9 Sep 2026 23:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 452976B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 23:43:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 710201A03F1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:43:35 +0000 (UTC)
X-FDA: 85196457990.21.754E067
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id B073940004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:43:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=G4+2eKYL;
	spf=pass (imf04.hostedemail.com: domain of weir@nebusec.ai designates 74.125.227.140 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789011813;
	b=sV2FacFmm4sXVtb4AXb/o8UvN7Yrl8kdRIQ6X2RLTEnzx9NA8bDnVcacH2bqvQS5ABvLiA
	kZuJ6l2gJCqB9yf8X+Cy3EjuEebMyA2KMCzZJX2SjzVTfwIngpTE6iGLV4fRZl4rwWqkvr
	iamFNXVuGyFPeCetdywzMYyRQFiAjy0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=G4+2eKYL;
	spf=pass (imf04.hostedemail.com: domain of weir@nebusec.ai designates 74.125.227.140 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789011813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nJlp1UkIyQbijZqk79bIeYyS07EBb9nqsi5pK4uVRPc=;
	b=ZYbCegANujV8G+FuCkKaIjKB0z2ARuNcdtLPYk/sckSSf1Agwyf8ixzCzEfk63Dr3wjSvq
	WmkHTSe54kIIIp7M6QMfwExAJRaoPhp38a/rR0vGQR36r7v7UtwYxJdfHBo3+K6g/cPk3T
	pnluzqXefz1WygtUx/RO9UDvFjf2kkU=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccc02279so892913a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 20:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789011812; x=1789616612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nJlp1UkIyQbijZqk79bIeYyS07EBb9nqsi5pK4uVRPc=;
        b=G4+2eKYL1YrqDwLQmandfMbYgYV3itZk6MeiMqRdfhZd9fsHIidKOmQlrF1dHnpb3c
         OsxJOITXdKvU4CY+giIR9+RvyuGyhtLGK4+7goprKgaNRwZtn6J6KzL3uk7xh26DF1U0
         te96nbLZexCeVOTap98HvIP3hKMQyUT20ZWc/IRoSj76/o8n4Y9IPpROy6T0s8Ng3a6F
         GUcgsRn5bxpLldt52xWiiIRhRXng0K8tLUXjiGOWqbFrwJTpreF5NjOR9ttNz3ao80az
         23WZiwDRrKwxTJSOiAVOKH1q9T1frbqXL4qy6oPriDPCsTm2dNd6YSRLlvWhsqjDyISE
         AmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789011812; x=1789616612;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nJlp1UkIyQbijZqk79bIeYyS07EBb9nqsi5pK4uVRPc=;
        b=ickUM3DkG7T5pu6lllJX1TwSOTusKFhOLJeyg15eliWLET75rcBRfZ4eWrV6sIZWSJ
         Ne74IHcN/mKkczXwkULcj7RHTgr3xYIf8bPxtoBy5JaEP+MhCwLi1j4ChYvT785vlTwD
         yFVtRvxc+WWSFLvjTTkCsNrBBB8todLwCU/5XtpAoMjnIpnlYhJLnwNpIVUyujdjFlt/
         3wsYomjOB0QYygvFXk4CrMHmuloUKcvzGdXWgB3dKYsd1BJ3dgLq8huN7Fj/Qmi93JB5
         e5ml3tlhaanTfSYvRQ4xaCDTlxc34Yi+/oY3rSuXfIXTu/jLmj2g7g/AKhnlAx3GIeSK
         5sCQ==
X-Gm-Message-State: AFuF++knpz/sSrsZ71M3HsF+ci3RJkabAVJsdL+nszEcGF7PKDTqcNRN
	P9pCtlwjrLpBo/BfkrvURl9uy83eqmHPLAmG0rNEpAHjdX/xPkdZWtzWNDLhFfBF9YhxF+8bYN4
	qxryNypuKHes=
X-Gm-Gg: AYBFou1W6g2d8RrXwqxxlEpjf67e/OyJTa8pbYlakSqQmnY4qfhOPKYQ8bodhIKx2ST
	Sunlz94IJ1HL3lJYSWs7rhAkWUIuAdKe5aIiwyvhSGKUk3pP6Xrza2xV8V27CfNAdUl5Tb0sKRx
	sKDpfjuDaXzeJKt3JqhhiPe0jmnGsl0uWu70yUqJmaBZFfdpwDlyXLPnj+lWG3CxoKYgqP4LUJB
	susqaMR09lB2LtZ0DOhw1h/FQAnSKRZHF9kk+QwNl3weKdh64R+6UynMpIeyQsZkvZ5JOmsERb5
	zox0eLxReNLSef9cKcAXNkr6jIK/tVjDnN0jYMMhhjL3GCEoq6Wl1TyniOomSA400xPXnwP5zrr
	q1QitX8h8241m7e+aiRwkfn/gx6b1NDaVjfH4o51ayoFMSUPrxlgtTiREP6CMF1iKPEbmY7TRcL
	+cFKW+syT0zspWeXZdTwupu2sn4hdrWCdflWOC5fQ/Gy7dkbU8k93lMPbZfJxaQyXFBX1xuOgHd
	qv3UtK1Xg==
X-Received: by 2002:a17:90b:52c6:b0:39b:3510:49e7 with SMTP id 98e67ed59e1d1-39d7063e857mr7318672a91.0.1789011812384;
        Wed, 09 Sep 2026 20:43:32 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d770bc2e1sm2916192a91.1.2026.09.09.20.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 20:43:32 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	notasas@gmail.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH v3 0/1] mm/memory: constrain generic_access_phys() to page boundary
Date: Thu, 10 Sep 2026 11:42:49 +0800
Message-ID: <cover.1788842306.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B073940004
X-Stat-Signature: ehakzx6nwkn3x4g4ic94ho6dnbo1y5dh
X-Rspam-User: 
X-HE-Tag: 1789011813-404910
X-HE-Meta: U2FsdGVkX1/GpV+yvCwc8zU85kCyW7DlxJdPc4U8HV4fsgEN45+JezIVYnKn3rDkPnSSaBuLWGITlnlZc8aPqEBIGXXEe3bEjB6RYVJn4kfgxjgzUq+MQzV1DFWgP2UxGAKura5yJWnjVyj9jgewDEju/woNeimWg03sJOclvmXtAXV05kwxgoFHXhBgs5mUBLX3IJP608hcP/QhA6JW+gkRoYnX/IWDzRx6Tv3mpc91xFllc0yqu8Whn8wd1DzsQxFitKIMDAePGIyO4u0ySx33QVQyffGNETHTXS9yDI85oX1NIrqFo5Bpcblgs1pveu00V0LodhtZx/bMWR95pfVIhpTiAwyvtAcGgmNqguE8QcORhnURwzqXlaGPZcbZ8ipaJnh4qYoCAhVwR+I3CiF8rZgfj9Gz6qkhWJWEtQ+/n+z+m+zwd1EiiD5iAPd1MO5ykK7FnH8gCULRWz+dK88eu82F1QMkB/rz/hbHl5QB1yPEX8TLasLaesL/FBIrPAeH/85oQKYStP2hSu+PPzGIybfroWJ4725IvIClLA9OXereNGibqlvq+zGsA1P95M1mW88r2NE4rihywIcgaFibBdngpqHpJ+fCMdDtx+cPxyYRIVxwVRH0pI8+d1T73JVNpA/CDHG++3gOE94q1W9IhynebC7Wya111fIp1k7lLtT84g/TJW8dD/7NhGKzN1Q0L6SNcd2uqVgG9EWTXn5iiYAxKJaDkkPkVqUQPbVHSjZJ3KI6ONvFs9kQpLYBKSBJS8O/gFIkuGRmosQnX7XDoUBrzh4WGWaNeNrKtYlo/QgwIxx2kjFEpfjeVe6Pgbp5MvOZmngeGBUaL8iSSpf4p4yCONe9j4omppV0MlkZn3fmSqyjfJEa+TmVGbt8LgSU1NYpo+mL6OIQLqtatpLfS1Wk5FcnFhgpzddKx42Q1eqYgVSDhp93Cg7ung32Ov0qTxD6UNrfjsBRy7q
 N0ScZEan
 iglo+WxCD+dbwdG5AIajemWBP4sadOiAhsrxPF2uazTDSrPgcWnK73xkAavfCRc4f4VLXek50gOyFzV1+4QJiss++3QfsuT29xEwHZKq+8t0wqrFBxMGWPTfTT8J+1Qljov8FRmnPMpetLsjeXM3/3IfYUijP0B/oWKc1/hxLOkzt4isSxs60kcOvuRhHhelGIYeL9fepM+c9u5oQnXt5HE2uxsF9hEAiVfZonsXRK+Nomf4wW9Y0LxUZroQsf9WBXiP2uD37rtRx+pnmqMCn4c+KMA5D0JANyg2H5fAqK8jjr5jirt792Zap+E7F4x6UMSm6TcWwXFNkPiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luxiao Xu <rakukuip@gmail.com>

Hi all,

This patch addresses an issue in generic_access_phys() where accessing memory
across page boundaries in PFNMAP VMAs assumes physical pages are contiguous,
which can lead to accessing unintended physical memory or exceeding VMA boundaries.

In v3, we address review feedback from David Hildenbrand on v2:
1. Revert changes to __access_remote_vm(): Capping the access length to
   (PAGE_SIZE - offset) inside generic_access_phys() is completely sufficient,
   as __access_remote_vm() already loops over the requested length and handles
   short transfers.
2. Drop the redundant 'len <= 0' check.
3. Add an explanatory comment clarifying that accesses are limited to one page
   at a time because follow_pfnmap_start() only validates a single PTE.
4. Regarding min() vs min_t(): min_t(int, ...) is retained because len is a
   signed int while PAGE_SIZE is unsigned long ((1UL) << PAGE_SHIFT), which
   triggers a compile-time "signedness error" if plain min() is used.

Thanks for the reviews and guidance.

v2 -> v3:
- Drop modification to __access_remote_vm(); capping in generic_access_phys()
  is sufficient because the caller loop already handles partial transfers
  (David Hildenbrand).
- Drop unnecessary 'len <= 0' check.
- Add comment explaining the single-page limitation (David Hildenbrand).
- v2 Link: https://lore.kernel.org/all/cover.1788531737.git.rakukuip@gmail.com/

v1 -> v2:
- Drop internal multi-page loop in generic_access_phys(); clamp the chunk
  size leveraging the existing caller loop (David Hildenbrand).
- Map only PAGE_SIZE in generic_access_phys().
- Add missing (resource_size_t) cast when checking args.pfn (Andrew Morton).

Luxiao Xu (1):
  mm/memory: constrain generic_access_phys() to page boundary

 mm/memory.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

-- 
2.43.0

