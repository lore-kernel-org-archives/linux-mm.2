Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB273CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAEA6B0027; Fri, 29 Aug 2025 14:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344EE6B0029; Fri, 29 Aug 2025 14:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6196B002B; Fri, 29 Aug 2025 14:32:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB366B0027
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD1751408B3
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:15 +0000 (UTC)
X-FDA: 83830639830.25.045485B
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB3E740010
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=d7JhxzYT;
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8c+9yPhPtAEVLLT7PJHB5roc/KfxfndfYXWIZFh5s4U=;
	b=EnbfrRUZ5jEDjjcCeqM6SvytoFbeCo4V8f2qFKSA+zcVULLmI54nP7HcHU84gm4nsfJ6db
	AgH/G8Wo2tWJuAXJbJhyHvw4qAMt3qHcbtHyeY5YHhQmh4vdc/2/d19SeIF6mZp3qxFAoR
	4DXJM2fVwcFJuRywSHuRq/YhemsYnhY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=d7JhxzYT;
	spf=pass (imf12.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492334; a=rsa-sha256;
	cv=none;
	b=kKI/8ACtgapFQf6zhmGAtUSIAp2HGEOvvG8vzUcwGbqA2BxtvdcMY7KPsVbD7NoS4VLdXQ
	Z9ibRBwErxOMX+6WpGryO+un0deP0UUTvxv0vIVoIynF/KQyhkkPufGR7RhA+JvHMguMaL
	vSOkdQV0tC3gxKg+FtA3KEWyKd9JrXw=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-afec5651966so443740066b.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492332; x=1757097132; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8c+9yPhPtAEVLLT7PJHB5roc/KfxfndfYXWIZFh5s4U=;
        b=d7JhxzYTg3b1J8po2jGhBJgeha6Fxh1YYc7Uzh2hmMn+bSD05GNJnd3eOU1VUBr2NX
         TQ5FLHg5Xv3Su8ARskfzDNzmZYjN12K1aoCCIiwOw36jFUXJMTMbH23DoulyzA4+00dT
         59BdHxAD0XRddfmkKUHeXkBd+/VEiMeo8gcW6zv+aQp5pAR1rdx4IYbuOdY268gpqbKp
         aqlxIckoa1gUvfVFGIesDTMpvOoFYIrkT5/Z4R7Q+F9DLwD24galxXU6bbVkM+shPQ+H
         Hv7BTPZfECkw4Pq9nms0m8JUo+BCJ3Vbageh7fJwUHgEFu5I/ASROYxk+o0Og9SkKKYG
         iZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492332; x=1757097132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8c+9yPhPtAEVLLT7PJHB5roc/KfxfndfYXWIZFh5s4U=;
        b=xPtxGhTczkwsO+LRcsrlFrzX+O/JLAUx0HpqCjBUaOkvfTpGhZ/Kws9R4mU8PMVgW0
         iANWCA2YvF9nP5JuOy7f7cLEIfUzZzA1f+iwEFC6lw05E8SO11VjS1XNI28a8q07Z2Fx
         ARotAtGY8AFSahRdDm0fa2Dp3FjS+7JzAvUDK8NeHMo1B+f648km6OE2aUAsluSkUegV
         o4vrNdQ0PHnOZRNR1Zcuydu1ji0EvK78sJPsBmMtKjTHAuvo2UzQ92Yvbt4H3cNK0nva
         6Q2ltqofiDk/cS03pLvDQv2nPGDxcRnR9mumsb+lXd8NvdxCC2cpZpaJHOuYr595iACv
         IlsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZ4GTL95TOcsoZOEi/6LcYAkxw+w39dnYPrzY8PjgAM04+HaqXfyFgHJec5FtPKQcIKFrhhQ65WA==@kvack.org
X-Gm-Message-State: AOJu0Yw4qd8V+mTaCijNib1byj0j/x2tZbJV+Mk2Ax67qDFHb4DU42/e
	tBv30XsCJ6cPiUHKvBcZKCQLUHCVc0tkPI547BFjBYlqseFpnXxdxefVXaFoLynGLto=
X-Gm-Gg: ASbGncsTh3rkn24PGrkSAFfrGU34HHmZ2gIUWcyb2w8AonB23yi67vGNPVuwvLLo/xy
	x13hc/m6pB4ffU9/fSXZD84UG/ee4Psl6IhosKrmZapEZP2zXLx/EgINofmHSFKh8B/dP3hlWUN
	6U32BGcCf5Yc4+PP/adbpwcNSmTz81PLkn3HsXvc4IzoE0LJBhkixBRzpfOnPl4+jQIXoH/eo++
	iJNJ19khia001/GEbhcxDGuq619vZ8DLq8BqKp+wvjjfAEITIVbhv5i4Df7lSRGqDjLesdKLKwA
	MXJt0Nlup5EHCOPOZhq9S+xmAYoUFXxRUuNI/WIwnG7l1r57EbC9MHR1VlfIYprg5ZhS3LBQjDc
	ftaXlzKwTLqiLx5svYx68dt1rVJczXr5RcpGoY7/agIt3dh/JpzMzE5ooUIf/FGIdSzynChBRhP
	Ir7IQj6g+QS/hxF5P3zwriXxD+dcIlrWvDHL33UW0nC8E=
X-Google-Smtp-Source: AGHT+IETmvvQODdVSBHmZD0kjNnIecq6FKhW+BEE2rV4GPi6FJ1MCBfKCh+rA9cR4mQklNhUdrS8iA==
X-Received: by 2002:a17:907:3f9a:b0:afe:d21f:7af0 with SMTP id a640c23a62f3a-afed21f7e3cmr865901466b.14.1756492332358;
        Fri, 29 Aug 2025 11:32:12 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:11 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 06/12] mm/util: add `const` to several pointer parameters
Date: Fri, 29 Aug 2025 20:31:53 +0200
Message-ID: <20250829183159.2223948-7-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB3E740010
X-Stat-Signature: gpe9mgjfgh3ua1qopocfwhjmna5qekyp
X-Rspam-User: 
X-HE-Tag: 1756492333-662667
X-HE-Meta: U2FsdGVkX1/whq9vm9YVTs/72SiHhTNGpvssNoEIQcq4MkeRAbhcxb++NKgM9Oj4Wap57x3U90trAVkyj6AeafPPKvXTN6z0Wzsnj60bwD+8N7NfhdfdaOLoE9Xcz/3vV5j73OELDAdPFAjPBaaB9HFsvQdKhbjOFC35JPCAKxP0NvNKCw5MD+xo7zE0/FhIDmQ3Ru5bclvyP3ElNh9B4e+j+mksrElt6Wwo635ik6+SGCUb/CV83quyiK5DS+lJGGMrUD33gIqwXp8cXQpsiB0r5aqfeqgToH43QA6fnjTOVG3xltmmBNZqG1jnmwoxjO4j4ZLuNB3frnh29d0Kf7T6TvQ75jxeJbMh1Z9VR73r7UQBxJNBb3e1Or1IBpl7L4pr9dr3hgIwr19HSjRS7Zxj2vLkjv7Z8AXGIXlZByM0wFa1Uu/Vy67S5m+EybIVltibNMRz9qOigdB1FFZxrE/oWCPZ86yPWzd/LbTjaGoKPW3ANI0DIZFubgMR8pm7R31WjjdChLK5a+1SH7zH81MdzLgpNLNRSkms0XXx+0G/pftEuCUaSBYZFPeys6jyZkDE9pDcF1fDwwQ0LmQie0t7AnUugSMBP3xaw/XNQkXH1LmuZfXH4AmzH+UV6gdLwl8bXGaPSvElYh0e5/imgz1GF27rS9IfhNLJM+Mt+qn3KQa+hmO+oD2fnyS0JgdxTQyerl5FrAJga+4s4AII2VjP/yd0kMG5ANVr/5I8fgKk737T54NGIpx+WN5/pROS6f9fkBacSj0Pp6/xuSLRMLuBxRndr/VY9LJONiqc1PthlTLo59758HhQ31YXLerZBbIZJSlxAF9H370FEcChSmNkkkXbGX4PM+YL4XspLR/v868YkyZ2bwcfMm4gtGoMFnYQtojbJkMqyP4RQ/LjFjEjGP98Ug68wrxNYN/5A5PbwfSfdXoQ0dzaoB7EuCtmf4xsc2N73ROGql2sLAW
 SL33XGBo
 5sgz1cKKMey7kYiivWbad057SIzeOzHfLY4DIpKer1hM8MUQAO2kV3Xpaglvo+/lfLS2ASXx1nNa96pZAen6hQYpfvnwUUn5tHzPHxgoUnd32flpvy/yWFx8xzE8jcPI6JYPPY460y3x13MGonahQfEU+OSXmbcoklmaTDWVPY1CMNznhxEC1BWrv2vzTMqutNo8OfrDo33pCYsvpjOI1pnLsebyVSVaevx6phDmwp0w+LGxNBr5ddzRROgWDrSjjef0bPqK4DbNnKMTLR+6Tyhq+YfY5LscVueu0oAtxDGDbatpGqsC3YqT0zmPGsSZ5uKJ/5Yt4iAPldkk9t38Y6992Dg1B3LedjvzhsJLy23eQRWHgZmIdlZMgxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h      |  6 +++---
 include/linux/pagemap.h |  2 +-
 mm/util.c               | 10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a795deef93eb..48fe838723ed 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -986,7 +986,7 @@ static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false
 static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
-int vma_is_stack_for_current(struct vm_area_struct *vma);
+int vma_is_stack_for_current(const struct vm_area_struct *vma);
 
 /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
 #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
@@ -2585,7 +2585,7 @@ void folio_add_pin(struct folio *folio);
 
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim);
+			const struct task_struct *task, bool bypass_rlim);
 
 struct kvec;
 struct page *get_dump_page(unsigned long addr, int *locked);
@@ -3348,7 +3348,7 @@ void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
 	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
 
 /* mmap.c */
-extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
+extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 87411e7f2dba..eb50e0124cd0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -549,7 +549,7 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
 #endif
 }
 
-struct address_space *folio_mapping(struct folio *);
+struct address_space *folio_mapping(const struct folio *);
 
 /**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
diff --git a/mm/util.c b/mm/util.c
index d235b74f7aff..241d2eaf26ca 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -315,7 +315,7 @@ void *memdup_user_nul(const void __user *src, size_t len)
 EXPORT_SYMBOL(memdup_user_nul);
 
 /* Check if the vma is being used as a stack by this task */
-int vma_is_stack_for_current(struct vm_area_struct *vma)
+int vma_is_stack_for_current(const struct vm_area_struct *vma)
 {
 	struct task_struct * __maybe_unused t = current;
 
@@ -410,7 +410,7 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static int mmap_is_legacy(struct rlimit *rlim_stack)
+static int mmap_is_legacy(const struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
@@ -504,7 +504,7 @@ EXPORT_SYMBOL_IF_KUNIT(arch_pick_mmap_layout);
  * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
  */
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim)
+			const struct task_struct *task, bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
 	int ret = 0;
@@ -688,7 +688,7 @@ struct anon_vma *folio_anon_vma(const struct folio *folio)
  * You can call this for folios which aren't in the swap cache or page
  * cache and it will return NULL.
  */
-struct address_space *folio_mapping(struct folio *folio)
+struct address_space *folio_mapping(const struct folio *folio)
 {
 	struct address_space *mapping;
 
@@ -926,7 +926,7 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
+int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	long allowed;
 	unsigned long bytes_failed;
-- 
2.47.2


