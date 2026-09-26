Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABDECC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3603A6B008C; Sat, 26 Sep 2026 06:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3397F6B00A2; Sat, 26 Sep 2026 06:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F4F6B00A4; Sat, 26 Sep 2026 06:51:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F3CB26B008C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:51:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 868F4C084E
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:51:19 +0000 (UTC)
X-FDA: 85255596678.25.7049778
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id C95191C0003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:51:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SuwQL3ol;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S3VSL5jcx+g44Lzd252R2CJu0ug8jx5f4c9i60iZqU=;
	b=GlgMKezcjC9xkyQkPbnd63o3wBUlpk7X6lpRd9mL8yihXgEeV5a9jXqTsX+4irCyxcbg8g
	hKrwEQzvN46QK5LrfkHgJNs5vtpWyoG9cw9Ec2QamGmhG8FKIW75/H7sGphNwGY9WDw0vr
	J+r+a0Rz88j5ODrUnwD79HnYbhfBIu8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SuwQL3ol;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419877;
	b=PnQJ50hygUO0TASUKt2oMws2AajY057TPJThvAxWuez6tPig9u8oDBrL0v8o6J/+a4HWCZ
	PPhHAMvkF3MgTpo1O9InLzkqISblR1zvNWK3x/URz9egXLGd7vbElBh6hWY6LerxUduRP2
	C6CEPYBxqAOfXTjn4GGTJLlyCys67S8=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5306abbdccbso17404161cf.1
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790419877; x=1791024677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4S3VSL5jcx+g44Lzd252R2CJu0ug8jx5f4c9i60iZqU=;
        b=SuwQL3ol69t85wE+hvsbNkeI4NdDdAx/LJPIM+GdQX6gCf+sjQAtDJ5RheuO8mJkxD
         BfoTGksUGyag2I+r8QxFsGCgEZuhf7GFFeLKMNjx9PgxRagRSUwBJY6DwXg4NZh2cJFQ
         XjfxYnTQUV+lmGSfwrjCwuQfLwcQ1Y9B34nbY7aXquxMvyPW8nQq5sfBui0sKrB5APto
         cvuPAjcRRHxu4SAEsNBl6e7qeZOxX8BmijleHQGNHAlLauF/3zMKa6CiSxMQ94mqLrWE
         cW2dDWaM0g5FPY7SSnPLWR/aaEFXC//SSLri0bpcSca5h97F0rJvcJFxJ5q0WcWyhA4C
         R3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790419877; x=1791024677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4S3VSL5jcx+g44Lzd252R2CJu0ug8jx5f4c9i60iZqU=;
        b=PPmwCjd4FtuF2tPcdEtw+v5eAhFC9qeEb8cROO6hghpIxs3O6CQvEQ63/XKJghNdJu
         M1ryk5RhDKiMH8RYcKvdwU3kAVSqBr+J9v4nX/ZSPkwBB9ppsgwZMhgDE9AAATUTQr6L
         0W3vwLXevojVcoKFgAlD+XMAhmzHdeR2O8DHAyZuV82Ct2qz1/tI4kq1dbCvBU5hrB5u
         9CCG/GIK/qe19J/MwBxr44scBauBBGKQSzuQp0NPSdgxpev8Mr/kuNqJona9uK3c2ERM
         M9seeJ4u9OlntQ0yDwYK2B9Y1J6X32zO039eibIeANhzIMQLpdpEfl/sQZEsioKxtCCH
         /OUA==
X-Gm-Message-State: AFuF++mttvIbTl/VMc8/iIOhSyq9njxb4Adjntiy0eAel75pOVvVwePn
	CxXZpHiDP2STWTgPqiJ7hBpiSopqt2ILOddhnRS7oaO0y4xKBgOB/2qEm2gLrbOAhnXvguHxU2W
	ES559BhU=
X-Gm-Gg: AYBFou1e9w3wF5IDev+VMQUP9dPiwFT5PLvKpSSOphg+42gte1sgp3bja/zxfSxK1Ab
	6Dly5nWv3d1CZbCJXUpYa1gt/rC3utcQBYi3Sf+wMAjS6UZKK2ALjtuw4a4RYZLTYU8ZrtUmpCB
	oMXACi3ujqWpbszqCjQAABvl6DsUX2deUPe3LCFSozQRESiieIIKUX4SAMTOn7qgHrX9+JeZ5SZ
	q8/IireyGroIGQDznxNmQwE65rTmQk3+/yyIEftuQP+p09/1Dm7PboaTEkxLEag9G01N14PYrQs
	aqZcH7xQSRjL1pFoZCGN1IMuTH7ljlmFKTC1BAa52iRz36jHS9W+3cbQX+4cpK7KEl/QVKPKExN
	YCvIVMVpkU9zu4k5ykyr8vf6oF7Ikqxypw6EUNoyxiSTtVAav9ybb25jNUp8WB/IXLL6ub48fOV
	blvXQThRMKlntX3rF4mLP+P4LgdBy3mrq1frB4ZPoMWdXXtF3/xdPw7JUEUPHfV3HfqJE6Glfo3
	KohXVF58MAeFFNlFfgxU/L7ZeWEzm4WLIPGqQGjtWcMzU64tmiFU+oP8w71
X-Received: by 2002:a05:622a:2295:b0:531:1e10:acfe with SMTP id d75a77b69052e-5330b5b9d4fmr87128541cf.10.1790419877016;
        Sat, 26 Sep 2026 03:51:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53322422063sm15060361cf.28.2026.09.26.03.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 03:51:16 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range
Date: Sat, 26 Sep 2026 06:51:10 -0400
Message-ID: <20260926105110.2156652-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926105110.2156652-1-gourry@gourry.net>
References: <20260926105110.2156652-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fd8st45jqfzyq95h4qpus1gb5n6iqj8q
X-Rspamd-Queue-Id: C95191C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790419877-776107
X-HE-Meta: U2FsdGVkX1/Lv5koCphQJpp0E9IykwYA14U7VYubPd3dKJ++VfHM+QimT469OmlJDhosZsf23qC85wVVcjwAKJomt4KNw35OG/ggQsODASfEflK+R4gqn1GUMGnCCcAcI9dTxi0hVhx7MuPE0TOgKewFKl8UVVCtJEA2Ge78PRPXq9jv3IdGdtv2ifpvqDv3ppv8n15pbp+Ek7QzP+1GcgmIC7/H+ynWpvmkE/HXkV3qFnbCZF+3kH24Oms0Tq/pN11x86cZESNw1yIz8WOs32IsEAnT6HZ+afRHXv3SlRgKunoG14SXdJ5V4+llpYLh4L1FmaNyl6SQTxvvUQVazprXNug7O5pGHmiI0qVr3KjFpChOVJi/xHqUBryJgElkdDojo59kbROMSgWLv+jwXmOE/YgAosN99x8Mw0XTmDCFzCDLVU8zW1b5ZUuPUxj5bIbNz+WKjMRX21a3wGuH7it0mKEOqNJm5pIk8X0uwHMkpLXh8TlZpm8zmzV4quiZ961D/Twz36k6p1LDCiu54kkp7rpmb6OpHqmiwThgluBoZL9DAdwbn76P7t78c+JkmrmPyCYhwOoU1Jxv7tvUSzn8lwtLb55k0ihCn0rDnZ4FNUH5SpjZINkgH5cEpjfFKkoRs29J+lUCQL7Snftx0F7tlhQOZJIqZnECVSAG0vZy8H44JV0ud56FDRDnh/jv7LJSNy0P8FtJ+AuVUk97k+Pzatn+HYWqnuQ+miVJSg90xwmjmh9TH+BhMSR8unpE5jZvqbK+icd0C3X3/Phd1q6twpnbb3oPNrZVUcRhp+sbUM7fM3FnB6ZuZvjxp0AfZdXG6tC7V0yY+6wfsow7E4SjVyYv3Kjer/iM1ksH43dxYcQ3BbzkFGswjdFPbI6zgxPqc6cluKy8FQv/FgbY6zTiWHhsolm2EMcZrf+FGEpfFBKs60dAziPLvmAI/jHWx3LMlIgsUOuySwzrzdo
 feQuUN5K
 O4QyAEtXOTZuFBd3X3sfxhzv2YwclFd1juD7g/k87O6s43bJG72UTH2CtGJ3/NTE5kpsgvGo74vn6cqHCaGTrCirFiURiB6wcoi9H6ZlYmLDzPRC/t8vq27rAyAWNfLnVpiAU6J3cjlgJGUbWrs3Tsjr1UNRFg5fxQKyMpqy1rJDsxEJZjgRIBqJ154RVfVw7IFeojD0zy4RO9eq76zyDGRs8vj78jejZt67+9wWJKAdGbXeSIJ22Y2915+MZ0wlX61iN5hok6YZsKeQVi+C9A3nQ+7M91it+k9w55pcaVkQZbJjmm9x3H6BdkS+kiDTZHvy6RXhnjXQhTIIPjg2HQ5pTYoOK+z08yIJD2/R95BTad4QgqO0CB25PtZ7s8CUPv3XV/6cWOu/IHlRga9FzHaeg0gCsza/JkOa8ncuGvyOYDcXIjoNgOeUp4/zroKVvkC9YtxpMVq0lXkwQXC/t66Uo94x8PJN7A4WocSzZaOTW+/9UNmzQ+WE2i7r8pur7Mg7EgFUX67yzZ9yvKUzKGeaXvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap a VM_MIXEDMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - mshv_vtl_low does this, and needs CAP_SYS_ADMIN
to open - then:

  madvise(p, PMD_SIZE, MADV_PAGEOUT);

With a stand-in module for the driver:

  BUG: unable to handle page fault for address: fffff587c0000008
  RIP: 0010:madvise_cold_or_pageout_pte_range+0x410/0x9b0
   walk_pgd_range+0x52b/0xaf0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_vma_unsafe+0x8e/0x120
   madvise_pageout+0xb2/0x180
   madvise_vma_behavior+0x46b/0xa90
   do_madvise+0x108/0x190
   __x64_sys_madvise+0x26/0x30

Nothing validates the pfn on the way in:

  can_madv_lru_vma()     rejects VM_PFNMAP, but not VM_MIXEDMAP
  can_fault()            *pfn = vmf->pgoff & ~(mask >> PAGE_SHIFT);
  vmf_insert_pfn_pmd()   no pfn_valid() check
  pmd_folio()            pfn_to_page() -> unpopulated vmemmap

Even with a valid pfn the path is wrong.  The mapping carries no rmap, so
folio_maybe_mapped_shared() sees mapcount 0, and the walker goes on to
folio_deactivate(), or folio_isolate_lru() plus reclaim_pages(), against a
folio this mapping does not own.

Use vm_normal_folio_pmd() and skip on NULL, as the PTE half of this same
walker already does with vm_normal_folio().  This also filters the huge
zero PMD, so its separate check is no longer needed.

Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Cc: stable@vger.kernel.org # v6.19+
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 mm/madvise.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 61e15d9502ca..85ab9bc76e06 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -395,16 +395,15 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			return 0;
 
 		orig_pmd = *pmd;
-		if (is_huge_zero_pmd(orig_pmd))
-			goto huge_unlock;
-
 		if (unlikely(!pmd_present(orig_pmd))) {
 			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
-		folio = pmd_folio(orig_pmd);
+		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+		if (!folio)
+			goto huge_unlock;
 
 		if (folio_is_zone_device(folio))
 			goto huge_unlock;
-- 
2.55.0


