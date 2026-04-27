Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20ABFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E6B6B009B; Mon, 27 Apr 2026 11:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F4A6B009D; Mon, 27 Apr 2026 11:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E056B009E; Mon, 27 Apr 2026 11:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAE16B009B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:43:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0DEA1A0ADD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:40 +0000 (UTC)
X-FDA: 84704735640.10.ABB7D7C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03BD820017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XNrxH5Of;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3SILvaQgKCGE9QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SILvaQgKCGE9QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etH/ucf0ROVAevEBkHReKesjYkPK8m2/xS+mJi9/Az0=;
	b=ZSr8CiDyCZvcNqtyG3Z2lFy1gud4t8W0Jaf++R+nbWiCeuelA9R4HvPk8ODDMIfElzMP8T
	oBflHk2lGuZxAWOeW3Gj8wgSnCig/c4l3241cv4AqfhD3QoQmVbtr6whhFnOmaEhQqp8zb
	bOkezVSfUzlPN9T2Wkdito826kEHuik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304138; a=rsa-sha256;
	cv=none;
	b=0M21qg9y7cQO8MOEUUYu+Hkzk92gq2YKwV9a4RdO6wPij5HVOocKuM3ewNEzRWFJYJ8L/6
	fL6D0keS4e01Qy6oStaZeBVyPmpEDlKIs7gomRI7SBQPEhm/Z1KGP8FigD3fXFw5FAIq6U
	cpv9g9y6EWOfLbm4VN9ZgTXLQnwPNQw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XNrxH5Of;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3SILvaQgKCGE9QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3SILvaQgKCGE9QCA+FHSFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--ardb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488dcaf2f2fso91346285e9.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304136; x=1777908936; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=etH/ucf0ROVAevEBkHReKesjYkPK8m2/xS+mJi9/Az0=;
        b=XNrxH5OfwJyD/oPo33ZYTDmv5IKR95xQDfIp8GeDkiQf/fBIJo6WkHop8McGiugUvE
         OwhKucxdMQ5ooeUETf6BCB9eEVQ6hMGzLnEFX6FRImzumwlw4rrodEDoK8Kb2NM+9vih
         5QVh4sAVCvRgSBPp8lRbVabVdsJveEKJVPxaaalWxsqXe0qg3T0Ho+5ca4ak3NJ9uunz
         OvI27O5oyJ62WrkHJXre+oxfpZsE6F2afBSyX3YF76wmPVRGMAuaqmmM+3d3IoEZBBz5
         nySYsP6bh24L5FRAvVmW9L/2f/Qvs1RkyAypBHpZeEJfL3X2cCyME9tJgG4gaxyrSDuH
         vHBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304136; x=1777908936;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=etH/ucf0ROVAevEBkHReKesjYkPK8m2/xS+mJi9/Az0=;
        b=QfbeCn+cECZDwmjnDTvdExQDTzPOfqLaWLe3Qh1vdthZ1YPN9Bt5+fnIBTw4zBPnh+
         ZBwJPSJ69UTyz70aiXeNqbJZjHy+vqZtZeWmbQc50SwMYnP4x0APD8/NLjqGeO5Vj14c
         w3F+bdvxVPRiyV+GzfyPlXg3Nfd9C5NgUOUtyfRTJ4fpcY7ATnSU6pbahipEHlJVlkt2
         BSoH49FxMCPn+C7RWa31szf/cmRHeFlBirbs38dMQ57pA0UrI5MkYGigLCFGVWzYRz4F
         tTHzxeyapT/NRW+Kr+V0O/0n+ZNYjFnA4DJlIkuAdN5ywJXYwxJ5iv4pdYDawW3bsKPJ
         WcIw==
X-Forwarded-Encrypted: i=1; AFNElJ+vK44DkqviQEO4A5hQ1KXyWdRoPM/FKkaH0EasZf8vkzoYZf6qqtRdwuPTxF3h/OE0Kh2utXSbjw==@kvack.org
X-Gm-Message-State: AOJu0YzXxMFJasWJhz2UXzZOInx/iqnoj4CT4Dhzh9K9LS9K6XpLWGHs
	GjF1blSSQvFxAdg+YSwH6ydnqJ7sG4BIW6cqw+1kMmNay7wMQEVLvODWZ5n/eYmJ7CXN+GvHmQ=
	=
X-Received: from wmcn9.prod.google.com ([2002:a05:600c:c0c9:b0:485:fb9c:ffa5])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3e0d:b0:489:6c28:dbc6
 with SMTP id 5b1f17b1804b1-4896c28dd4emr454740575e9.31.1777304136468; Mon, 27
 Apr 2026 08:35:36 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:19 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1123; i=ardb@kernel.org;
 h=from:subject; bh=Xui4zHPMyqNAfMojX3d72dmyPg9HBiaeXXlaXljmfJY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN945+SRZJXH5vdEE+o7Yvo32RxfuaV3S/5HSeeLwufe
 mV64bHIjlIWBjEuBlkxRRaB2X/f7Tw9UarWeZYszBxWJpAhDFycAjARpwUM/6tzU1eeXBAlq+Z5
 +VDlfPmd8pIhfj95ZQ8bhFlenPP7LBvD/7yyGqPIczsnJ5sZWSR+cbBZf/Xwp98hlSGvVEzOB0r eZAIA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-19-ardb+git@google.com>
Subject: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 03BD820017
X-Rspamd-Server: rspam04
X-Stat-Signature: 95sag3wbwmxpjewwogccpenzj8zb6wby
X-HE-Tag: 1777304137-509176
X-HE-Meta: U2FsdGVkX182QaAgBuqV6SfYmVP1nTWByED9YB5sYtE34yG94Kbw66QPzp7QEnO2X3aSfLaCBkhI4epGUwktM19oTr3JyF28mjPB6AcFSF+yC2LXUS5MGhsQTwdBJBmcOZRdiKySNk+j4b6fxr4TP1Adecp+jUzRkTGYsvBy0v/yQ4BHWE91zdIyQbOtQjUVE3HRSv4WoVrfy5qYvQ4h0gyuzMjx5wOChgmjBb4gNTvjpQPiRsh3tnBExE5QvIF2iA85o/pS54Ahy5blYZ8FvNZ9Mo65mjBGbqsDImepaO5oNfkzz+IGQGpEXWAR2a4dKxQPEub4i1gmNXymRn7cs5aUvnBxZVBpu4OVwUaInhBX08lXQKlfyUkLF6glLUS48GmgA1EI2DbjU7J4zvgds7e7a8OSjBh+naoud6CC2W2YYXsr4aBE8FbOze2SWJjqWAm0KRosguyVXmycGYTjBcKwx7wnkWQuSIERI18m024dJgcmgkQeYPU1LTPCdXSeMpk1SHQNeJpFEK+3oiwnIWmy7cBWmNDtKSlH/1jSht1J3GESL4pp/vU3Y0A4e5fU3cKH/CFzynvBvXXrfeenXASuFgfMfaMB0jiy5dPKhhXqDdRHh4SzZhvGG7eVJLf4vT+8xt4ay9S+aMkBM5ftVuNCITuLnKcGvDmPTfcAlJyN2hWpNuFHF6ohH0G0ikji5etURACwiW50IHBai6IXo8Q+pp5TAwjarXc32tjtkDmS9MwhjjhW6A4N1UrBkJ3u2NuRsrN2XTswRfdA3+kXVHCEbFCURk4c2NCVZJ5V8rio6x+Ak7oek5Dz7zUhE1DMYVPONcb3fsN9mWe2zpUBVlBAmPZrnBDRElTOdP7Nav6bY5qvNp3saz4Xd8bM6TsLCWRlj1Sb1vICMICdcX53D/+eyHQ2qMixOwWgA7lmkEyax9Qm1O1HHwHQ3ApvrPJ8V6+7zbUWC94ElAtmUPV
 w+bvSjBM
 pbjzQl26ovvv3CU2AFiarvavQhkBKEqitM1rfBoxbYXIi4JIQHR9burADo/ixVNabhN7tlnnILfSlNpaisImLfpSaPT2zK3xI0YNsNMX/bz8lrALAkTd/nIlbvnEeNX53LRPygZnPuQk/cqpuvGrM5ydgdZPGuySuMGMI7Eh8N7fM/1fqzmhUdYvdAU/TB6O54SRaN9m3YHtr1R9363sadbTUqmHMxCc6R6NXBaqIx6tcVzVf/351IyAmc0tO5+KaBm6fAbt8bVcNKGgZrFu2zd8roShbfrW93Ix6O0wBXdDBsJVM94meyf5IAGRuQ1VwGdle46vwoCY9pKqv7i5HTywXxD/KOP0o8XSGHq/OmGU5/pkaKd710yHhfEj5aR4NDUhnK/dYLUeyRq6dFdhoOfXZmCjmTxBjUqeSqN0JyV6X+zQ6gqobRJhdupKeMWuf84GCgF529dGsXymMAYkm87n8OPZMfUSMiwPifnoQVY5UU8M4DR27QHokOolk2x0GEdzO9hxEYT+MyCPVlkTv1ln5TbWoknsCJsN3lQ7WUx5mvZd/tuOIphm+RDNBF3ecR3KaXghBZqH/vORS41a0X+ySlSuvfdjGE5EA7lON3zvIkQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The empty zero page is used to back any kernel or user space mapping
that is supposed to remain cleared, and so the page itself is never
supposed to be modified.

So make it __ro_after_init rather than __page_aligned_bss: on most
architectures, this ensures that both the kernel's mapping of it and any
aliases that are accessible via the kernel direct (linear) map are
mapped read-only, and cannot be used (inadvertently or maliciously) to
corrupt the contents of the zero page.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..6ca01ed2a5a4 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
 EXPORT_SYMBOL(zero_page_pfn);
 
 #ifndef __HAVE_COLOR_ZERO_PAGE
-uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
+uint8_t empty_zero_page[PAGE_SIZE] __ro_after_init __aligned(PAGE_SIZE);
 EXPORT_SYMBOL(empty_zero_page);
 
 struct page *__zero_page __ro_after_init;
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


