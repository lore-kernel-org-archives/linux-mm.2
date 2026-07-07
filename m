Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D3BC44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1C96B00A0; Tue,  7 Jul 2026 19:51:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017496B00A1; Tue,  7 Jul 2026 19:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD36B6B00A2; Tue,  7 Jul 2026 19:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0F6C6B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:51:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C9FE8FA87
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:51:49 +0000 (UTC)
X-FDA: 84963630738.12.9DA18A4
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 49C184000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:51:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qzZd2m9U;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783468307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjoZ3kU3AvUL0LV6smVKBwxGmvcLVEM8ZIL8h6Quy60=;
	b=s9R2i4fByeTczA7hG1eOGnRFASK7TeXjVrkJoiJEMojiOxcmX3b28RVdfnxwlETU8fh/9E
	1HWG3zi54Iq+f7iUrIX7jKtlsI5OEwWqiyE2ZgA1VaGBzzLnNOLCV5ZZQ/DSjwFBNx4LqA
	6At0TPO2UAhV3lR8cnjlcXTori1L6Os=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qzZd2m9U;
	spf=pass (imf07.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783468307;
	b=Uu1NumIQY4eL3z3BDyVHDEP3sbBRupl+TUNxvVe13fK9dlI82InxjNfn1iZm4Z7MfNmIEY
	42ti/P4MHJ/aQOuSoHqMpJOl+4vMLhvKiaAsOwe3b1Sry3CPy3TWRZHAl0GzeAZRiNDqWX
	37+JCHhuFXa1E6lE2qKZoDdoWREJGJc=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc97653887so1276455ad.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 16:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783468306; x=1784073106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NjoZ3kU3AvUL0LV6smVKBwxGmvcLVEM8ZIL8h6Quy60=;
        b=qzZd2m9U8xnH0od4sOHmeu2K+MX1uKqMZg5KAve0fYMh5ywpPqnQTn2zhLg0jVRSDF
         iKX4ZeWv8zzWIu29sVIUIIAC3lr72wznfJ6x5Rp8xjiHVnFCUpuKU2YG3szAXtCxK8JC
         k9qvSXacC0cgjtTC9vuImtXwyMzaKNFvsMIl+Sa6zi40D50b9q6SeiUXb6VfTFsbVaIE
         CjJNQdJ6qpkh+bybPH6ywL+0CCVd1UFh8W9IRDD9PVeK8vVaMCqfeRuQ9SuG0H+w1sOa
         JtED/vZYxVCvumwCVR2PgOMs1UB1CNEbxMrkH8MCCFDy3Gwa1fYS78troqywVbuzlL2g
         ncjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783468306; x=1784073106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NjoZ3kU3AvUL0LV6smVKBwxGmvcLVEM8ZIL8h6Quy60=;
        b=ZMRDZGGKbOc6qH+FouOYtTmGWc4THve5rrqbsxFer6Gyhl9LAzLamq14yosl058Uln
         epkkOSIYD5osran3y6vzgq6kp+4T5/KLocRjL6FrqTM0RDpKhIIHjm05/h+0d9wGdyeO
         OkPWnyWBMwQyeBeBWfPO5wyFowO2jPhum46qOjg7aYvyVlxYhSxvsGnsNp3ajIS8gU70
         KthaIEBuXlikFHryeVYK7V4NywuRDlcNqb5wnqbOlCRQB+bopHEjaWRmx55FmoV0LOtH
         6z8aS6nBtGDFV6kaXNKkA3H23nQ0/cPVKO1qFUC8zpUmdVreeALZQgb5Q6OEsP2OfoHu
         rJfg==
X-Forwarded-Encrypted: i=1; AHgh+RpIjaRd8JH0faWbVIEQB5xOa7LdP5TW17oMAP+eOY2BoMRunwpmcWu1iXhrnYvo0Ayb0CAlDYJsXQ==@kvack.org
X-Gm-Message-State: AOJu0YwSldvibfYGA8+rD9cd/gayNjGj8SknmugldeCmEOzTyoK3OCv4
	syOa2msPsrshdbFdVv30R8EdxKDmItF4I6utnwq6N/ypLd2JeAtqHlDI
X-Gm-Gg: AfdE7clnP3tlY/dPRasCoxWZ50TlI/adr2Qf3JZ6AdWk8S5VZQASna36t1VaHV9Udou
	+gCGG52eYMyq7mu3vrYX7oOixLo5AahG+FTZmkqpzXr1cqn1girQdw1HpmqKAyZq0gtewVVV+rJ
	2z1dvleeYB+QpkZc1XtoIA3VIKqND6ZER7CIrTz2JB7algGHzV02oVQ/C65xADiyBsEk7y+r0lp
	5AEJUoLVYgQFQtrmWTh8DJGYOJqG7JW65pS3prYxw1zPPM6Vk3bnZIrwZjyR6mVoQ5F9U7pUtaX
	Z9Ne8SUPBtnDql6Wle0nmMTVrSPq1E2kDLCMTAsNTC5jzqw3hIZqE1xjFBI0d7VSEisYyxFMiS4
	v8T6UZQv05sBc+MZfDlwe/IA1zx514k92efiGj2s820xxkfRGDYqjOZSW7RKscDf4WmDT+xpBJz
	gAqYoAMivOPCKGWzTcVESzFQmiE/FkwfSPlLJaMhnZsNFNqJ4yzNnI0NlZk5X04+1GeMqPPW2rT
	VPiyKJmsSKK+6BHhw==
X-Received: by 2002:a17:903:2286:b0:2c9:97a8:afe8 with SMTP id d9443c01a7336-2ccea3d8697mr1162125ad.43.1783468306055;
        Tue, 07 Jul 2026 16:51:46 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb877sm18937045ad.14.2026.07.07.16.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 16:51:45 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 0322B148F31E; Wed,  8 Jul 2026 08:51:45 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH 2/2] mm: nommu: fix error handling on vma_iter_prealloc() failure
Date: Wed,  8 Jul 2026 08:51:37 +0900
Message-ID: <20260707235137.498738-2-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707235137.498738-1-thehajime@gmail.com>
References: <20260707235137.498738-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9bt38dt6k1kz1qayfuwisidno97bj54b
X-Rspamd-Queue-Id: 49C184000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783468307-645229
X-HE-Meta: U2FsdGVkX1/qarjwGRPVAXE4JdB8L1LO68c1lqiC+Laqu74Qj5yXBXTV5zOUFnxWLodcXyf+F4gzQ0GLdFNEUxG/xR3iGFlbYT80Jgp+4S9u1GCNuc/b30vXyxZNiaCjdFhZ3BG9akYIF5AX+87afNX6DRjU6IEqDKoaWmgxN3+qJgPdDAetF3R1tduH6oBULYqmeEktToDeFLumr/VwZOW37mMARiR78zK/WBwBYDmAwaKJvsWeOAVQWDFdChsMqW5c6lKHB3bcjCtGEXdrm1/3qT7wQxaiwLuIktHyjegpdWXeTB7qF0iz0IxKdCt547wQSCqSy1c/NpbeQaKfnVoCYmwjr9+Bp3aieHEHMHGjX2DGd5d7cil9vz76E+/eqDhWwOefRjTyLwIEwsWRTpC6dHNCR21Vs+SG2Ua3aSBUyOrLHQwfZq2yRla3/kwrd5tUt5ZNZR3hPL2C3QW5CLs2XrarZGOp3Pa9yVCRSo5Y35TP3+viLYF8gPXrsYG/1c+h4raRTeLFUG2xU/CUoX+BF+4vcFKieemprnnnTC2Nyg3pB9F7OArcyQ30U2CHt9ohBfD+9QOAMhtD/E8lfgqKnt+cbb00tmxnaF432cyU6Lf8HYX21Cnre07R2PbFTDeXeGFv4gi6X3repC3/TF/FRNcoVbP2qJroa05udltuJ5Vl6o3i99r4WXTbcfFlwaEOcNbDd10ji4a5I/dCrMaHgW4bEBFu0TwbWq9XQ4yKqsMtpbWmwpsAfpvYIx6+ZiIWsLRfqzVrmhUU0VM6JHvFFe9ltA1LYxOlYJJj0QZnf/Rot1VpwuwgW5hACyrrfA2br3YU6aRlPGnCa/+RRsZ6bqJa13KuUQ5P1Pny5tTOvSLA0CjHsZN6yYF1n4PKibPoLeo+XH3xTaQE6OzznhkUbJMKRilzgP57sEV0EKglGjCDbe7J1XHW/Vc1H9veoqFiannsHVGLRglG4cf
 zmn4ej24
 +RNJqYTbXHWeEzFahgR7rQIjYSOiKoAqWiGa1lh/f60pqp8V3w+p1U5EYoibJqmIJbh37dEFHzuiL6tdJNLo+3VeumGtlkd61OfB5SbEvSXvmVVimR/vE+SAh/jUOydMVJz5DmuyCxK2SHV4ir2K1dUAWlbccfKVai5c8FugfaltHBA2eAHUDoaBEf0nmuG/GN8M0C8lM/fcVxMwTDmWC4sWh6a9IpjUiCkK/mx5cSmz5+xiDiNi5zuRtBom/rBvX1iQkOyPsAAtV0B//v0/zWeSVJCsVdWF2TmEHaycTvwWPyec6GZRFT4yGfDYJiqzbdY0YIKy+EEU69e1fyBs5uYxYHevhu1aoRng/eBHwcHeB9u5TrZ996G63L23MEfg1TkcN7r2IDTvZxFybZLvjJniqFpUDjNJpRWNeiVUV0mRM0naisIJeoZpONPlWalPy/C30SW0GqZhDb/ebNHJ0X47ofG/qLKtN78NG5aQVp8KVpKr2jtgYHF4gZJpj/PGIA8AsPmm2kUh226Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If do_mmap() finds an existing overlapping shared region, it increments
its usage, sets region to this existing pregion, and jumps to share:

	region = pregion;
	result = start;
	goto share;

When vma_iter_prealloc() fails and jumps to error_vma_iter_prealloc, the
error path unconditionally frees the region:

error:
	...
	if (region->vm_file)
		fput(region->vm_file);
	kmem_cache_free(vm_region_jar, region);

This potentially leaves a dangling pointer in nommu_region_tree and
causes RB-tree corruption.

Additionally, when establishing a new private mapping, do_mmap_private()
allocates physical pages and assigns them to region->vm_start:

	base = alloc_pages_exact(total << PAGE_SHIFT, GFP_KERNEL);
	...
	region->vm_start = (unsigned long) base;

If we later fail at vma_iter_prealloc() and jump to
error_vma_iter_prealloc, the region struct is freed, but the backing
physical memory doesn't seem to be freed via free_page_series().

This commit fixes those issues, discovered Sashiko, linked below.

Link: https://sashiko.dev/#/patchset/c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 mm/nommu.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index ad619611e83f..24bd8c529c2a 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1222,9 +1222,16 @@ unsigned long do_mmap(struct file *file,
 	up_write(&nommu_region_sem);
 error:
 	vma_iter_free(&vmi);
-	if (region->vm_file)
-		fput(region->vm_file);
-	kmem_cache_free(vm_region_jar, region);
+
+	/* if the error was from shared mapping/existing region, don't free the region  */
+	if (region->vm_usage == 1) {
+		if (region->vm_file)
+			fput(region->vm_file);
+		kmem_cache_free(vm_region_jar, region);
+
+	} else
+		region->vm_usage--;
+
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vm_area_free(vma);
@@ -1240,6 +1247,11 @@ unsigned long do_mmap(struct file *file,
 	up_write(&nommu_region_sem);
 	pr_warn("Failed vma_iter_prealloc()\n");
 	ret = -ENOMEM;
+
+	/* in case that the region is allocated via do_mmap_private() */
+	if ((region->vm_usage == 1) &&
+	    (!file || !(vma->vm_flags & VM_SHARED)))
+		free_page_series(region->vm_start, region->vm_top);
 	goto error;
 
 error_getting_vma:
-- 
2.43.0


