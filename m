Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31142C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 03:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A856B0005; Mon, 13 Jul 2026 23:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0142E6B0088; Mon, 13 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46096B008A; Mon, 13 Jul 2026 23:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B1E586B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:16:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 149D61C00FF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:16:24 +0000 (UTC)
X-FDA: 84985919088.07.A81F332
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 63EC8140004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:16:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i5IrMgf+;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783998982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNQ3cvHxuHE4isS2+7t6ZlfquRgdiYmjN4YpiQXlf1A=;
	b=8maGol6VSWKxVm2Muea9icB3N8FeBxztPc/GkfApcYX9Ke0D6WZY0pXzw1zTqd1tEPZT3g
	PzAQBFUBMyBs4WrR8OhL4hsheDKHIz3mnNzhF/7a2ieQJSw+HQUv7ywmcl7DsiTGsuUMU8
	On1STWOZ8PFl8vP2FzMQ/CYaXm+G+Qg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i5IrMgf+;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783998982;
	b=km1SmfUWK/GtLWWc4S0IPRzNsZQgjs1vzMBSwk6AE/TLtsFTIBTeGm5ulnCUBkChkdg75o
	xu3CAH50BFT9U438CRU3uyOa1RnTuAeyITuSKv+lnmIdKvBgheY8qcR/lZijNwFK/cBvni
	MF1ftQf1MEsUrDE2OD15hDDqqx1Fn9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C056760103;
	Tue, 14 Jul 2026 03:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1F01F000E9;
	Tue, 14 Jul 2026 03:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783998981;
	bh=dNQ3cvHxuHE4isS2+7t6ZlfquRgdiYmjN4YpiQXlf1A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i5IrMgf+jWZ3QJrlbp0biQqPoZxd7IMDJsS2CtdnHkkGui16rgS9KB+i5c8KNy59U
	 vuy6MOn6d0sC/3liO9Hbbi4ETiYWh6222URBJw/SedmGJoX0OXPu1LZ338khz5t9Z5
	 VBd08WmbfoER/WPPPwf3BpeAdDzNUK/AL9VRkxVA=
Date: Mon, 13 Jul 2026 20:16:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/9] mm/page_owner: misc cleanups
Message-Id: <20260713201620.1481535c63be9a408fbd7e4e@linux-foundation.org>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 63EC8140004
X-Stat-Signature: pcfzyscsewj38yhtbs5peosgxjgp4yxd
X-Rspam-User: 
X-HE-Tag: 1783998982-810922
X-HE-Meta: U2FsdGVkX1+GMfOaXfqsAzobrKDnFLvE/zjTrVJvqz6dOO9ZmWXABRaUNOubiClbQeFCvUsBB14RwL1mFAXabywj3cD2w/WjQnJj8TOAgngS4MWPURK3vjYoA4ngQ+03YjsbOr0TqqyBvCldo7XJN6+1Q/BNhMmTfbKKISgrLmvWm2taTWwITOVbUmLmFjPYw9yKKjvVHMPn1tlfw9TdjZnGAwvhMf/NEW1X0tx+sRJOmKVTyQ4gbpFCU4U5D+A0qqrKUSDy70ZwEyp0X4kItiRmv9dFuwPSafm9BEaFgzDvO/Qs8ALwB83r2p2OEU+cupbGTOal3axRJ0nrCgD3PrIFeitBPWTayDvrX4WIIuUzBNtj0j9Rcb/ZMf3r6ktV81WoUb8y2ag7Gu2LQhc15PUNPdTHDzUH9fPK3vry9ZIdnUp3o/gHyqUkt7uOA8jIBe3kls+vM9WHgfcS/dqKouQhSpU2zX7ysdVwQ98MAyt2RV0AvH+DPsOOW+y31Tuhy8jEh8DxH+OBWqAkNW3IfrpzT8fnbl1/uDL2o9joFy1A0zN2EDWZY2aOjj4FSE8xHQlzwxk2ZLY1pmXdLmjQXEH+clVzwB0WwWsScXRXLdVr+99cOeyfZlGSPQow1pP52EMBE2M7RtBWRswC8BPoAzr41pUc0VEHRxkL6fSMM5TEkfU4YyiZ9QfEuhrZzNQrHaml0NTtsTNQJAV1WCDdJX5g86DrJDrWCk247ztiAydc0s37TNasDsCg9Q76VhJoOosVMlgjJL7GgAJYQjAmIKwXpZNfbJRN55DsP6KqrPXLPiv0FBbyVgO8r7Z/aywD0VmaE1KBJFi6kd6nLaXTLqNLzH9OeUmoAhh3I9gL09+FjnnCC73aoO6suYNVSOaWFBm2GfIwj09+UmABsSEZV4RIDmp0ITgmVMSSAv+i13dHgM6c1J9Oda/7xOQUE/v/NrfZiJwIwXyMS4fk1ec
 eCto15eA
 vkvc9c5P3V5IzLQipjazPcZyAyV0zDUSkAv7ZQLtxFPBLzBReg4Cjtu7fXamvsCo1FeIt83grou30vh/T/XVX5yf8Nkt/Ujvdlbj4CwBawj4t/UETW+px4bY/wgjkDu1RPmv0OyaYFdnODBQkkNGJ1t9qeckwN0/NjOFUH++aMJ+Uk4gvpKudmsAVSD0w6Co8wqBaQcm4s0DB1WUcb7HJzcEj1zFk7UuVZbyNEo0pk+uqZsiX8XnmihSxLtmEEt5JrYcC4KPjCvOsFpVZn3toheNdcUlif+4IY/l9TptoeQy6s6Kv7Kf6WvdZgjPjFYRziH14
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 09:50:59 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> This series collects a few cleanups for mm/page_owner.c that have been
> accumulated while reading through the file.  There is no functional
> change -- the goal is to make the code easier to read and maintain.

Thanks, I updated mm.git's mm-unstable branch to this version of the
patchset.

> v6:
>  - Patch 3: drop unnecessary 'extern' from __folio_set_owner_migrate_reason()
>    declaration in page_owner.h; Adjust the indentation; add Reviewed-by from 
>    Lorenzo Stoakes.
>  - Patch 8: clarify commit message wording; add Reviewed-by from Zi Yan and
>    Vlastimil Babka.
>  - Patch 9: rename patch to cover both TOCTOU fixes; also replace
>    page_memcg_check(page) with extracting objcg from the memcg_data snapshot
>    to fix a second TOCTOU issue; add early return for the MEMCG_DATA_OBJEXTS
>    (slab) case.
>  - Link: https://lore.kernel.org/all/20260701061101.344679-1-ye.liu@linux.dev/

Here's how v6 altered mm.git:


 include/linux/hugetlb.h    |    4 ++--
 include/linux/migrate.h    |    6 +++---
 include/linux/page_owner.h |    2 +-
 mm/page_owner.c            |    8 ++++++--
 4 files changed, 12 insertions(+), 8 deletions(-)

--- a/include/linux/hugetlb.h~b
+++ a/include/linux/hugetlb.h
@@ -155,7 +155,7 @@ bool folio_isolate_hugetlb(struct folio
 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
 void folio_putback_hugetlb(struct folio *folio);
 void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
-			enum migrate_reason reason);
+		enum migrate_reason reason);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
 u32 hugetlb_fault_mutex_hash(struct address_space *mapping, pgoff_t idx);
@@ -425,7 +425,7 @@ static inline void folio_putback_hugetlb
 }
 
 static inline void move_hugetlb_state(struct folio *old_folio,
-					struct folio *new_folio, enum migrate_reason reason)
+		struct folio *new_folio, enum migrate_reason reason)
 {
 }
 
--- a/include/linux/migrate.h~b
+++ a/include/linux/migrate.h
@@ -57,9 +57,9 @@ void putback_movable_pages(struct list_h
 int migrate_folio(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode);
 int migrate_pages(struct list_head *l, new_folio_t new, free_folio_t free,
-		  unsigned long private, enum migrate_mode mode,
-		  enum migrate_reason reason,
-		  unsigned int *ret_succeeded);
+		unsigned long private, enum migrate_mode mode,
+		enum migrate_reason reason,
+		unsigned int *ret_succeeded);
 struct folio *alloc_migration_target(struct folio *src, unsigned long private);
 bool isolate_movable_ops_page(struct page *page, isolate_mode_t mode);
 bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
--- a/include/linux/page_owner.h~b
+++ a/include/linux/page_owner.h
@@ -15,7 +15,7 @@ extern void __set_page_owner(struct page
 extern void __split_page_owner(struct page *page, int old_order,
 			int new_order);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
-extern void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason);
+void __folio_set_owner_migrate_reason(struct folio *folio, enum migrate_reason reason);
 extern void __dump_page_owner(const struct page *page);
 extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone);
--- a/mm/page_owner.c~b
+++ a/mm/page_owner.c
@@ -540,6 +540,7 @@ static inline int print_page_owner_memcg
 					 struct page *page)
 {
 	unsigned long memcg_data;
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 	bool online;
 	char name[80];
@@ -549,11 +550,14 @@ static inline int print_page_owner_memcg
 	if (!memcg_data || PageTail(page))
 		goto out_unlock;
 
-	if (memcg_data & MEMCG_DATA_OBJEXTS)
+	if (memcg_data & MEMCG_DATA_OBJEXTS) {
 		ret += scnprintf(kbuf + ret, count - ret,
 				"Slab cache page\n");
+		goto out_unlock;
+	}
 
-	memcg = page_memcg_check(page);
+	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
+	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
 	if (!memcg)
 		goto out_unlock;
 
_


