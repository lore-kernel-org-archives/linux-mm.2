Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28FFCCCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB19B6B0092; Fri, 16 Oct 2026 08:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D431E6B0099; Fri, 16 Oct 2026 08:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29CE6B009B; Fri, 16 Oct 2026 08:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9BD6B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:16:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 731181C3956
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:16:56 +0000 (UTC)
X-FDA: 85328388432.05.6AAAAEE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 97C644000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:16:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iYqFMVPx;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792153014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hs/zYeYyTlwZbcwpFmd1/o6e7isHKMyzfUkOn0wt+v0=;
	b=PAwZieq8lxCz6oxR3paz4juPRcx+ipzAXMKR1V45B59vXKVqJMBFOINZi8o/O/lfgPqgfV
	NiwPOJO2OEu1SFe+/QzP5tsOv91V3Cqboao5FGKsF1RPEXMRwBpkkrFm/LsT2YZcX5FVA7
	3gXTUHtn3MRrpU8y6qmp7JkAjHROGWc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iYqFMVPx;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792153014;
	b=CfEB6Tweb7AUjxnMf5P3GU2ASFvEyZYOZBMVnkumlgL7tLbe0GVmqY2Owc6AUnSdfK5MwP
	O+oojooOy+rKC049wVG4P3yUWlO1t+a8zTIlTBlqpxakcXTpzHjruQwBjdB9uTHIUXwbt0
	eyeHFDTVnVQFJ3a7o1XfvSgLm3s3LK0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=hs/zYeYyTlwZbcwpFmd1/o6e7isHKMyzfUkOn0wt+v0=; b=iYqFMVPxOU6BXvoYJcMGA8qB1w
	mR/XZ9XliXYXUyaW9Uz4zN0TuKTsoovBJxIRhvOGn4GsecuzoInOaVIfEkP7PLuztvEb12aD0+ynI
	663unyzNBADtoH8RmGKO8kTc50uaVj52o4BHK/PbWJN78DemAR5gsktfSoitHuWM1/Hbzk8DOY3xq
	ZnLUIKCUZWxZ6dyM6LmnpBtLWZkxqxQvPAYgMJVeamwjscmN6ghLNe2pjK9cH7VBsZ6iL7gWj2i3j
	QNS/rpfylKxwgk4ZG4re6Oq3WnOVL68IVBE+wSPkGKrgqa0MXEX6SHUsSNfUvi3ykELGbjGZS+vRF
	y/QYekVg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgrE-005xT8-19;
	Fri, 16 Oct 2026 12:16:20 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:43 -0700
Subject: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to flag
 an inherited frame
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
In-Reply-To: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2910; i=leitao@debian.org;
 h=from:subject:message-id; bh=trzPDDySfo0Lff8IS/iFzbgv1tlNXlZMtNna1/625YY=;
 b=owEBbAKT/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0pDUt2raq2h2BGabzzQlLagrmznGvKifR2
 MSWKKy6eiuJAjIEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bSo1D/jqX6+As5vTM1sTteLhPkcGdNmot9OvbLjENR8pPZ3NNUfGZ8lI8AP91H1MWjDO3ghWg5R
 poX7nk7hhjxkd7I0kURcw3YD0J99PkqLKmqrCYyAoY5+G6ObsFaslt+ryymjOHphV3cOzX7zu0Z
 GBxKfpLZSdluSxaEW0/8c+Nc8TEGacBo2udAr5OQ8ahm3lSkvUtP0FfRnH2mSTLR5vQfUJRSd+0
 cMWg8PiN9Rjyl6xJrbGfZ16B4w2Crm6xE8ntfZgQb+sX4CU0bTIthauqDffxUINrVWGZUv5h6q6
 Zce+bLneIi/ElTkWbIKmiOtibCvTa28nrkQW+a9fXTt+J1ptINot5SVYCaU4vzRDzlSdkwccFBp
 f4PJB6vCqOH6PhX7ycLGu9K9/b0oqb9OxqDA5mDLmTFio8NztQx4t7mxWOPCurAsqbEAcLtBQZY
 RBrCl2t3LhvAm47v1JJPOgWkak+hHxLyfm+dc4zodmRy5yyXDgDSg6B85WYKULE4IH4yKHup0SG
 xpIGU5rlFRxI7MDiMHGDhQlV2qkBri8Hyozod0QltQhJFy/onE0m3zwppKysBlxrobQZibWgt3H
 P1zE4Zdn7hG7bYqVWMRiam6pbunmFfy23FpUB0TtVRtG7Y3l3/kvReaxuEonbdv0g4UEKOAoTKi
 fl4ri5b/zKNSb
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: 4suz5d9kr1yhwn1bbbrdzkkmuj1zy9xu
X-Rspam-User: 
X-Rspamd-Queue-Id: 97C644000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1792153014-813736
X-HE-Meta: U2FsdGVkX1+T3AaDiH7JB3tqGvrUFxSUbTnqxP7Sa34A+goc1bqb4k4m1dlUrdcrfmT2J1wkGrV2yXFdZP2GxrFv7E65WUPgbaynKEjkmf6oPa/fRvLv4V0zQX6qxeywehbDEJyuF5JDPhyHEnnf/BDyGMZics9MgoydLSxgtacTyJ/rkGi1o/OV1QJEZaCrEvvRHEniVgdL8IIzcL6F8MFD+7p9NtE5DndaOAzu65GWEpCZVrqWuMK8+S6JAKTlGTEY6ysbICZnCbkDSu3ICE2qPZBaHUyl/3FG3bMTcQb/wBIbBc5OMu+DRXpfMAIUUFvoI5OrDIjQCp1dML5MquZVMSC+RmLxvuqjPpkfH+sXv2ogrP2+ACA8Xnxat2mcK64oCaUXfrz692OTg7Hu129v4NkJr+O4kB79uCFaC3N5RVi11kG15zm7miJAQ05nGrOrvidBfobyC09F7TEOYjj96AUxPLvyL+CJjRMLokJw3F/VP6inhufbMCgGFxyQ8D0QWSzlkPs9aeMqnJW41qW9WErwis73Wq6xsMCt9OrX87E1gxu6RpYnuoNxSIZWoqPgciKMNlaMfVqlWWF0tyurqb0RgXA9xzB8aRkSC/zjILmwP3IHKrKmaGqTE5C0D49w4jnJT9u8bQHg35x3Jswlis9SNiyRcMZja83vmpWxIj9xEfMg/OiqtQ3ZeMUrY/JExGvkRX6USZIGJWXvFPWVG116z6vYzVOdKNE56q3+MWt9D00Q7SLYx1Jjosyl+uTO6byL8hl0A3/ZeiL/UpkojR483Opf905KnNR0j3znwTV80CkDJ3WvPn7+Z0YK/PNiy46mx1J0Uzrfv6rHpO1PpNAzhYh+e9M5zfciLg2yyBYSYvlssawzkZxgsEbnDuYaAVVLHu/aU6ChSGMMhEFYi2qdkHx+oSRfZjQc9gIQjwiscq0oYVoElMN8K6dcizQjiihK6OqB0UG2Vun
 LFBvuI0V
 8srO/zBiYl4Cx6MtwcikwnQb7boykmufo0M95vgqOAhJG6oF5IkCq5Kh3pNSsRF93HeJXiN5p589WgbAtdpEH1TgGuLaqVz9LKy0PUMAWnDsoZzUmxRIVS87pmtDnr6Ls3pEKsoFnSf3j7EOuscXBfRvBJm77br7NnAoobb4imuTSg481t3c5hQNWuAZxoqGdjQkJHyIo5tuQzNljdOvvqchgDd39cn7ZJDy0G2mD1CjvoUr23qxZkE+eiKy3XIxU1U5qifBZEXHyycDIGj5jn/ucdzJMimjzH5si1xt1vrZXTbwlYuX/efMUsp/LSPfHSVc0UQnl3ygunsbF5xlmM8bbb4daIh+PGfp0Nuw4hhSTR/gzrsTbNM/eubNVnasBQTHmq+KIPcJZW+lZVrO8mXHwQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A kernel that kexecs inherits the frames its predecessor found
hardware-poisoned. It has to carry them as PG_hwpoison in its own memmap,
so that everything that already understands the flag covers them,
including the kexec segment placement check.

Add a helper that sets the flag and counts the frame in
num_poisoned_pages. It runs while the memmap is initialised, before
memory_dev_init() has run. memblk_nr_poison_inc() divides by
sections_per_block, which memory_dev_init() sets, so the helper
increments num_poisoned_pages itself instead of calling
num_poisoned_pages_inc().

An inherited frame is a hardware failure like any other, so the helper
sets hw_memory_failure. Without it, unpoison_memory() accepts the frame,
clears the flag and drops the last reference, which frees a frame that
is still bad.

The helper also counts the frame as managed, as a frame that fails at
run time stays counted. Memory offlining subtracts every frame of the
block that is not PageOffline, so a frame that was never counted leaves
the managed page count too low after an offline.

The per-node memory failure statistics are not updated. This kernel
handled no failure, it only inherited one.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/internal.h       | 5 +++++
 mm/memory-failure.c | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e11..4bd3bbce86e0ad 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1169,6 +1169,7 @@ void SetPageHWPoisonTakenOff(struct page *page);
 void ClearPageHWPoisonTakenOff(struct page *page);
 bool take_page_off_buddy(struct page *page);
 bool put_page_back_buddy(struct page *page);
+void __init hwpoison_boot_page(struct page *page);
 struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
 void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
 		     struct vm_area_struct *vma, struct list_head *to_kill,
@@ -1181,6 +1182,10 @@ static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, b
 {
 	return -EBUSY;
 }
+
+static inline void hwpoison_boot_page(struct page *page)
+{
+}
 #endif
 
 extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a2ca8df501caee..d0d6b184ee469f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -96,6 +96,14 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
 		memblk_nr_poison_sub(pfn, i);
 }
 
+void __init hwpoison_boot_page(struct page *page)
+{
+	SetPageHWPoison(page);
+	atomic_long_inc(&num_poisoned_pages);
+	hw_memory_failure = true;
+	adjust_managed_page_count(page, 1);
+}
+
 /*
  * Return the first or the last hardware-poisoned online page in [start,
  * start + size), or PHYS_ADDR_MAX if the range is clean.

-- 
2.53.0-Meta


