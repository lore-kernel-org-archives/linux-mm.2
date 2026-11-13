Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9FC606BCF6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=DxslJsEK
Received: by kanga.kvack.org (Postfix)
	id 4B2576B00EF; Fri, 13 Nov 2026 14:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 445356B05B0; Fri, 13 Nov 2026 14:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32ACC6B05B1; Fri, 13 Nov 2026 14:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD2A36B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:55:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2968A801F1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:55:46 +0000 (UTC)
X-FDA: 85431151092.29.2261EFC
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 588AFC0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:55:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DxslJsEK;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599744;
	b=38vb2HqczotYIEFqxzmR5bVHhE6Q4SDg8sA8GtzfK91l3uxKyQPk96hoAAwJ43eMmocR8b
	R2cYB1O8f+j0J+bFOaSmVzVf+7EnsXdniiINlVA33T3cVI0AYZQVUSLamQgxgZ/K1TQHoR
	zcUJrX76bqkeDpVsnzO/lQLpWFGos/0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=DxslJsEK;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UeGRg/WkJsGVpuyAFSuDrs2zUW/JrhTUImqKDlhPu/Q=;
	b=y+/x4FpJILQD1AEJzdBM4fgaoaibcokkiO99uf74YCYxULMSj4UAklp5qJg/weBBij2ldp
	ibUNjsF68v7ox2lg+B3yyMexH7ySmr3gEF9Y0tgpyX9cI9ad2Ri4xljEm5yTAF+elo3NzP
	oODgaP/TJlJCbK7yzFpTjraqzhUDVVE=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5365f9a04c5so37027091cf.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794599743; x=1795204543; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UeGRg/WkJsGVpuyAFSuDrs2zUW/JrhTUImqKDlhPu/Q=;
        b=DxslJsEKRnGEhos/GNfdH12Y26naBjGnlx9q4uTjpH909BrSC7HGo9Iz7oMBz9hpMD
         qEGEu0U+qvuJJ/j1lTT6/Z376CYKwDrde8qkkbxteiRAiNnT8Txf1T0XNGfGPOFVg3U1
         I1/0RHNNVHbLr+xnkxJ3D88tC922hVpVNW9wry+lOL2bB7WHkQx25gIt/0U2bz/du0Lv
         4RQVyPmaEETioUUJm8kfZvICZAqbV42jfs9WT9NZIjsxTx2wypzGU7mobHJnnEtiBI6h
         63NJn46oDPa2QifOQC7sjgJ2NK0QugDqOJ5wKlUbfkDxK2cNG7BFN9ej/jBG03CS55y6
         D80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794599743; x=1795204543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UeGRg/WkJsGVpuyAFSuDrs2zUW/JrhTUImqKDlhPu/Q=;
        b=xqb2YBer63VljK2b5zC25IgYaaycAdFDGpghRnPIooUhEaEoczFX9A9XROLl/tNf6D
         d1z3ie9F5raVpPk/0KRDc+Csj20eTUKrh61X5fgPZBAxhbxHXeqQMOGE9ANI/OlTh0PP
         Xs6kCVd2Y0aE8LdPzUdByGOvuRKMUOjDhnG1ISwSBtkaVU/CanGDefShYjTwBIpSr7sM
         4exERGMt2Jf48GIhI70FE46uuAjAoRTAUcnvKRPYon2kIP1P6/uENKhmgATkHXcZDppa
         nvrpit9JV5UhE/4D2k/Rjy9zbCrS953yUirZC5VvEP15hR2eW46dcKZhddUhrFxJ+TDM
         iaFQ==
X-Gm-Message-State: APuU4Z+fpC4hib2yOJpE2gihPfw4lUR4B/En3R4+4j99USoZhNe5gSG5
	TzjV+4DYD5sIhxOgA460VDxqyRP0EWH3Mnj2/KgzRdlGBwRDtvz2XWwREu1LL+C2wGNaapvyy1R
	uZiIZ
X-Gm-Gg: AYBFou0d39gFalk6L4tfz62rduTvZBWFXZ8t4HfqfwttIckejitvSykIc106hEQn2nY
	QFuU3eeBkghk7J6GvBbFTL3cMQGoleFeEDO/b5cRdSjf+/CkqqaPcsTcVOTPnYfMB2sx7rp0EgG
	sI8GtzDedONwbYo6oTbfrcOenswu3iCtjQIMf++ftV0rwARYkmppxV3vfvoU6Y1Eq12yLplnbFl
	hvglEx6TyOu0pf7GNskCy+KDZc63yMCbr4Q+LoiqZdU0zyX+cOaQ/Iblr+WgCvMkA/sWZwq8cil
	Gw9jzQlmjc+kWPhUu45fnd12GFHJ0HVRFSR9NhgSkEG0zlP82TpGVtDIwGLGZfQH8YqA6Q2bR5u
	0TLIM+kqyiaViysWk07F2yhs2m3X2PQQvzmeDx0mkcpr9CXgToHSsJuCFWzAFnGGarCXlS00Kr8
	C5yXHnufgNxd7L5d0WuBB5eGDrqH2HAA4vfYcP9uTybJJqHMEoyXmr3c7e+hMFPcE8x7GQB+m2Y
	ehmtctGADh0y3AoatW5yYe9N/r6INHvA1PFvWWQWZEFXMjQoaomQRbWSmmPNGbQzLZlvgGMS3rq
	QDBo8XWeLZcfmbbHrV2rrxXdQwZOWakg9kLwLOg8YkrvhYPlch+hoa6dCPZXY4i/Re3TotbpgRL
	Rwupdfo3dmn/Ypl8=
X-Received: by 2002:a05:622a:258e:b0:533:2c5b:d668 with SMTP id d75a77b69052e-55ac8894504mr59124981cf.30.1794599743447;
        Fri, 13 Nov 2026 11:55:43 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0a231dcsm25486351cf.13.2026.11.13.11.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 11:55:42 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	bp@alien8.de,
	rppt@kernel.org,
	stable@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH] mm/hmm: reject shadow-stack mappings
Date: Fri, 13 Nov 2026 14:55:36 -0500
Message-ID: <20261113195536.2660763-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p7hjt3acay3ysrhict8prjakwxguq9ho
X-Rspamd-Queue-Id: 588AFC0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794599744-639209
X-HE-Meta: U2FsdGVkX19O4z8LtAaN0o5uD9cYBeQMvxSJqac+Q4PZi9UZ66wgyO4NRCxiSlRExQbQYvyyyctBsJcvWwxQdz1D/tfgK1/Uk+dos5t9VD0zMpuskcJQ5ol7IaNpHOFlsBFcPUrdvN1hD5PQYtZrdmQkEHszZoTu4XfpbA4cJlLUSwVvJ2k4lRVbGmdPlsBBjEhy+6dCSjvuezOeNDRjDpyzWlq/wqJ5uuFEKsGxzDvcCHomuGAN+G7VV992f5mnTramXywhtxnf6bWiuZbKxgbEsQ1isQo7ueiy7xsb1pH9M0KwEwuh54IQ3eTts2tcmcqBA7IFh9rJKJgbLtSgRDQMwrx/vQ2m65C36W3Q0LopBQ2G3awavSYd/D87kJy3YvONezHQ5OEJPPJZHRE5DsgvGMvMBMBQ0thF/VcYU/E6BvKGWB7fjFEppERBdSRPWXi+ZKuitsIwvij4T8j2vaoXBratPKrRu5BLvKNJx6+TVwgbwNkuyr1jPuZcGkFkV0YHbFp/6c3riffJ6VNNw4lOfg4eIm16WMh3kSsKgeDQc9w85y/WihM345BE5A906ALCMZJVrG+LBOpJpJLt3r3ZqbvKMZ94PKY4fuJFKu4ifhRYRCCnSGuXUQdCeyAvDamA4vxwKuBbRqOeaDYcS3XxGxG2pLgz5t+OpVEVJCXUKp9ZLQusflg9mpcAnyN/KjnyoLCS/eU/bBDmrEru0InnKbP5z6s2KBo+/AyqzLKQwjWYkrKluaYbTGZ22subMvFF2D6UjGkZqsEudqJGyR/GMIeOF4Uh68r+OnlhyZ+PhgmjJXStEOZXtWby5davsy+YTlD+s1pxjv1GuuSox49k6LMt9Rwz15AT9UxM4LTelS0DCybCMQPJaZv6wgTQ0X4tENL8Kea61KS2gd0oAs9bUvc7beyU3DOC9/tZjOmhaV8uCFep1IHDoB6mezFXapFqW7gXeO9BCjDrhoX
 RhWWGSaE
 EJsBQ0TaWj4gV2yMB0Te0bN3a03rzE0rjkkIr48E3f0AwfS5Fd1kJ1oJ7FZdAlnMEaYEZl1PPWweB4hPfSLrVPVpaOY+n+92LXvbG9HluETktMcyXoE3q8Rds0yVWRkyOqSzZjlyYaB0zVh2rVG0L0UQYNk+agMl1IPFwhz6XgzLEXJbFIXUEZYhz3fyG80oce1sCATtlnG+5Qc4mvqTft74mbAar18xYgCSFz78gGjaT4DZV/1XdD8jlz1PfcFODbNqA6ucp6Kn1NDmsC7B5OV0HNIGdKm+t5Uf/OJlO71+NjTT3Fhfmb4JmINd4SdZVeFgG6mNukE/WMuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

HMM can grant ordinary device write access to a userspace shadow stack.
On x86, pte_write() is true for a shadow-stack PTE, so a populated page
can be returned with HMM_PFN_WRITE without taking a CPU write fault.

Nouveau translates that flag into a writable GPU mapping.

Reject shadow-stack VMAs in hmm_vma_walk_test(). Use the existing
unsupported-range handling: a requested fault returns -EFAULT, while a
snapshot records HMM_PFN_ERROR.

Link: https://lore.kernel.org/linux-mm/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/
Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Cc: stable@vger.kernel.org
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/hmm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..fa61ca59d927 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -596,6 +596,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct vm_area_struct *vma = walk->vma;
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
+	    !vma_test_single_mask(vma, VMA_SHADOW_STACK) &&
 	    vma->vm_flags & VM_READ)
 		return 0;
 
@@ -607,6 +608,8 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	 * allow write access either. HMM does not support architectures that
 	 * allow write without read.
 	 *
+	 * Devices must not gain ordinary write access to shadow stacks.
+	 *
 	 * If a fault is requested for an unsupported range then it is a hard
 	 * failure.
 	 */
-- 
2.56.0


