Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CE8D25032
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 00:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66FF6B008C; Sun, 11 Jan 2026 19:49:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCD06B0092; Sun, 11 Jan 2026 19:49:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA026B0093; Sun, 11 Jan 2026 19:49:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72FF26B008C
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:49:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23F84D2007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:35 +0000 (UTC)
X-FDA: 84321478710.30.9379786
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5033C40006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:49:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aMsTYD9v;
	spf=pass (imf01.hostedemail.com: domain of 3HEVkaQgKCIkwvn3vBn0t11tyr.p1zyv07A-zzx8npx.14t@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HEVkaQgKCIkwvn3vBn0t11tyr.p1zyv07A-zzx8npx.14t@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768178973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOfkfgub/NaDAEiuWC6wAGOFEvU0NuNfiux/MMIfgrM=;
	b=rUauzynlV5FtUIjChz1YC+G125F7QNcSXHXv1UL6xmx54ulTNHVvU0p+2lLMHwWia+VARp
	51IeJ/TlPiFl2DuBvHtiTsDbT9qMr52dcK3WJNrx0MnLNnnAOsdpXtBAIU5qf+XkaWQSAG
	C4D1CczlGk4C2htoRixv5BPmVD4BDXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768178973; a=rsa-sha256;
	cv=none;
	b=PiOON/p/pWhvIWv+z/N+v3UbqKN2ATcIixX8CnGnrMHoBLWmV5/aCEsnoCy4qQy88vtZMh
	4e+t9HcevIdpUjuqUGno3zUyq2pZRYQ2DOKgAsLYkZVLMrZyfP3r9q+ZLKZeiy03QcT22A
	m7WohJBsz/rRNtc3IWkOC2+f3Ayd1IY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aMsTYD9v;
	spf=pass (imf01.hostedemail.com: domain of 3HEVkaQgKCIkwvn3vBn0t11tyr.p1zyv07A-zzx8npx.14t@flex--jiaqiyan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3HEVkaQgKCIkwvn3vBn0t11tyr.p1zyv07A-zzx8npx.14t@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-81f5381d17dso412342b3a.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 16:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768178972; x=1768783772; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tOfkfgub/NaDAEiuWC6wAGOFEvU0NuNfiux/MMIfgrM=;
        b=aMsTYD9vRZSmWb9N/49G8OgVhQsXR4kvj10euSsMtA7q4OllW/sUCm3abKLyKc9BXr
         eazIwBlJnvzX6Tn9vd27ULmM0BDytu2WEwhn1sE8iB8SZKfD0ax3Sb7wd8+kQv5d8IHk
         My0BkF0usQc0ea53HIWxZxlq1qzFrHai5Ka9v6zCO0qTu89vYJLgKgFZioZL3Rw2fKB5
         sgn0n4GQQZZScg5G5dJopk/YUShrCOknILmiRHxEPvMSMz6dJzonZzcjehF513ulAkZz
         JPrTXBIjEdhHSP9XLIGAYrEx3+5Hg0XnLSXksQlTmwoOhTq+M998vRJFtTy61ybW64iN
         OGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768178972; x=1768783772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOfkfgub/NaDAEiuWC6wAGOFEvU0NuNfiux/MMIfgrM=;
        b=eddCty88XEfnGEZLHV+wWlCbKA9kzeYan4kYmJE5AcGzljhw2ZCx+2KA2Mfk4owhC4
         X1pIr/X+JtXzAT1fv8yvJqm3NS7JvIR3aHAYAbwqJRHYC+TdqQaaVi/1/iW93yqJRAPS
         TbLdhVEWh7+02lkFsF9JeVt6zkeYb85QcZv5FhCwvS/ct0IMi1e3ZgI4VCJCX6s4ZJEM
         nROP1BIfeMO28wxrk1up9vk9wsQ8/MpYAvxXDkCep5JvPrm1LhiWpuZ5eEhm4mOgW7Vd
         qFBEa6CsL7HDwb/CMYH/Yzx24kp3E1dqNaXWDVoWlSDX2euG1qn4+aUHclq1qXWw8vhW
         KsiA==
X-Forwarded-Encrypted: i=1; AJvYcCXV0qCiqFTaIuVdTwhN0SCgB9VWqzv2ryg2QINpSMKgqhO7+xVNMdFcWLgqARnNt6Ffs3TU1fSB5w==@kvack.org
X-Gm-Message-State: AOJu0YzWL6c5WitvJZWRv0j8I/ytUUwG8aZ+Ylb5a2LIpU9lJ/rmIplD
	pjOEgOpBgvVhozN3O36dMzXZCDZiSwR6H5nqv9EeJZWIi+ONBxlePhVkwUyL2MTocfHVl8UYCM2
	DlMRwz0hMarxcVg==
X-Google-Smtp-Source: AGHT+IE3mm0jWQWNZBJBvrBw2R/8R6/gLaYBFwhcilPPZzp5OWEiyGaY2M5Ofj7hXuABGa1C9diKGvBO24qNGg==
X-Received: from pfib20.prod.google.com ([2002:aa7:8114:0:b0:7b0:bc2e:9595])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4516:b0:81f:50b1:51fc with SMTP id d2e1a72fcca58-81f50b171b3mr2334123b3a.10.1768178972099;
 Sun, 11 Jan 2026 16:49:32 -0800 (PST)
Date: Mon, 12 Jan 2026 00:49:23 +0000
In-Reply-To: <20260112004923.888429-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260112004923.888429-4-jiaqiyan@google.com>
Subject: [PATCH v3 3/3] mm/memory-failure: refactor page_handle_poison()
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5033C40006
X-Rspam-User: 
X-Stat-Signature: nt54qfssu6e93fch3sxn5eaben58hnbm
X-HE-Tag: 1768178973-297497
X-HE-Meta: U2FsdGVkX19X3GmatSm/OtXbWp5q8pgU9Qe8ayYcS2AyJRye+nvtDIg4IT+n+DVi/ejEUcRRRXidyhTUYWFTZLLgIxuDanz4Kk5XkxgcdqBUVRrqy+gLT8OF00CH0nmvHxdAkDXmRCVvPmDF1gIdNJXJ24uUycjYJyYr7MHxC3wh89lgB0Cry39/YgMPyB+382nI+lQYUxFK6YMiQNakkIADwhV0VSZ1ANfJoVLpyvQWgaHwPFhgZ/I9YZzaqfHuo6AAuRlWc4+NRG3o4XAWfnmfOEqyQsYIZf0VChVSJMCIdvsYataH6WWHOu3MPwdxc4D01UChXJ/qIni+mtgq0ODggzUyc+jrjTcyLlnTNEDjhl4/ZsPqQCV7+wVS0o7g/GYWxlNotAvqA7q9Vds+byNFPepkc4XST5kITfWQSERAQZC/ecZuJ6FKnT/1S6r8Mn9oObWax4L4sbVpOHQi7/qAiu/3SbDXJ4Nhc1A6bdxFTYuPSKhdthXZq7jsKJLG7cVcp7GDjYCpWIWq/6N54C3QIAwkK1DINHDMao2N/T9C0Tjb4hf0NSSPlnc64zTHotIvLa+9sFb9vunQVu99XNYc8t0YMhs//6qDzQBktl4aatl7tzmfWpKRDwzIg+mzAbOgJN2IxmqrpbkuWqprIezIdyhfoJdPubiwA0htUr3phqYcisVDO5InexGQPl38A3ILDUUoZ1TC+o3JqaA0xDd0BAGphOikfQxSpv12ZDRwGHY7bR3Y2/Z4OisOM+JmTXEDxbQ1R0GJ/z0jV8IFn+2jBJygZkwZsUq1jvw4LbIFJOkKinNL6BK8si1/9CidnooyobbPqlbnD9KtxAhe4QGpIfNY6ty2NOz31/mQH7AEa65PNvwbI/rKdThx8LtuihpYxvJcroG34yXx5AHyCjTTM4OrHtmWFtU8gypQqI87I0yjTCbLgax/W5Nx5ZxhMt4S5LYvHieOf2BJfCZ
 LG4sKlLb
 kvkCtiW+473w2hP15UPLFjyY+6wMp00Rxbx6RGC0Z31OkNfEFngZtLxRh93rnRumoiXhdkZDYjc6bqCKKbUdKfAYBniRd+WNgjDvoEcXzMszLDXiWI6SbeLmgtocJC4cNwJYJ/32vLM5kc80pDYDt23admdpfUJzhUBg9rJkR1wXOiNLQph1tcTeYyooorJs3EpofvM330DmEpfvdAHY4EHKSticLMzLdl+KFFy0hceji7J8SGueZwubxu7J+umoE6nJq9sxsZozRuuKyYYK5FP0ZOJ5u01WduZkhm0/HenJfeIupE6ESL3JEw3MTaAG20d6dTDG/E3SKF4FfkyUR/TG0j6rKcrozTUHjLEIvmpFHx442hSRkemIWX/5O/51mOTzfiBHKtnef3APHc4KVtbv6QltwLRBtjBdiE5ea2Z0OFY0jMd2NsKnwojt45l3GweslPJDiikCMHDDGatnYJeA6pYBbol9U3ATUhBvxkrWfBbYJkLlc+Yxa9xzvXJAJLDCG31UbXpKaKJ+2QSp157lCTaLIE6lTj0/wrrn90GqNw23xKXVikuypFoLQngw/Z/BRlYk1Doihs0ESypJPYgejSqIjC04r9tAigwblJ3gfR1TUT2bZhcHUO33s4Dy/juhG4GACKFp/HGo5KihtnsDq4clncUZng+gQKxFscQWLtcO3eflQ9oiKDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that HWPoison page(s) within HugeTLB page will be rejected by
buddy allocator during dissolve_free_hugetlb_folio(), there is no
need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
succeeded returns false, making caller think page_handl_poion() failed.

On the other hand, for hardware corrupted pages in buddy allocator,
take_page_off_buddy() is still a must-have.

Given hugepage and free buddy page should be treated differently,
refactor page_handle_poison() and __page_handle_poison():

- __page_handle_poison() is unwind into page_handle_poison().

- Callers of page_handle_poison() also need to explicitly tell if
  page is HugeTLB hugepage or free buddy page.

- Add helper hugepage_handle_poison() for several existing HugeTLB
  specific callsites.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/memory-failure.c | 84 ++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 43 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d204de6c9792a..1fdaee1e48bb8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -162,54 +162,48 @@ static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
 
 static DEFINE_MUTEX(pfn_space_lock);
 
-/*
- * Return values:
- *   1:   the page is dissolved (if needed) and taken off from buddy,
- *   0:   the page is dissolved (if needed) and not taken off from buddy,
- *   < 0: failed to dissolve.
+/**
+ * Handle the HugeTLB hugepage that @page belongs to. Return values:
+ *   = 0: the hugepage is free hugepage and is dissolved.
+ *   < 0: hugepage is in-use or failed to dissolve.
  */
-static int __page_handle_poison(struct page *page)
+static int hugepage_handle_poison(struct page *page)
 {
-	int ret;
+	return dissolve_free_hugetlb_folio(page_folio(page));
+}
+
+/**
+ * Helper at the end of handling @page having hardware errors.
+ * @huge: @page is part of a HugeTLB hugepage.
+ * @free: @page is free buddy page.
+ * @release: memory-failure module should release a pending refcount.
+ */
+static bool page_handle_poison(struct page *page, bool huge, bool free,
+			       bool release)
+{
+	int ret = 0;
 
 	/*
-	 * zone_pcp_disable() can't be used here. It will
-	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
-	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
-	 * optimization is enabled. This will break current lock dependency
-	 * chain and leads to deadlock.
-	 * Disabling pcp before dissolving the page was a deterministic
-	 * approach because we made sure that those pages cannot end up in any
-	 * PCP list. Draining PCP lists expels those pages to the buddy system,
-	 * but nothing guarantees that those pages do not get back to a PCP
-	 * queue if we need to refill those.
+	 * Buddy allocator will exclude the HWPoison page after hugepage
+	 * is successfully dissolved.
 	 */
-	ret = dissolve_free_hugetlb_folio(page_folio(page));
-	if (!ret) {
+	if (huge)
+		ret = hugepage_handle_poison(page);
+
+	if (free) {
 		drain_all_pages(page_zone(page));
-		ret = take_page_off_buddy(page);
+		ret = take_page_off_buddy(page) ? 0 : -1;
 	}
 
-	return ret;
-}
-
-static bool page_handle_poison(struct page *page, bool hugepage_or_freepage, bool release)
-{
-	if (hugepage_or_freepage) {
+	if ((huge || free) && ret < 0)
 		/*
-		 * Doing this check for free pages is also fine since
-		 * dissolve_free_hugetlb_folio() returns 0 for non-hugetlb folios as well.
+		 * We could fail to take off the target page from buddy
+		 * for example due to racy page allocation, but that's
+		 * acceptable because soft-offlined page is not broken
+		 * and if someone really want to use it, they should
+		 * take it.
 		 */
-		if (__page_handle_poison(page) <= 0)
-			/*
-			 * We could fail to take off the target page from buddy
-			 * for example due to racy page allocation, but that's
-			 * acceptable because soft-offlined page is not broken
-			 * and if someone really want to use it, they should
-			 * take it.
-			 */
-			return false;
-	}
+		return false;
 
 	SetPageHWPoison(page);
 	if (release)
@@ -1174,7 +1168,7 @@ static int me_huge_page(struct page_state *ps, struct page *p)
 		 * subpages.
 		 */
 		folio_put(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (!hugepage_handle_poison(p)) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		} else {
@@ -2067,7 +2061,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	 */
 	if (res == 0) {
 		folio_unlock(folio);
-		if (__page_handle_poison(p) > 0) {
+		if (!hugepage_handle_poison(p)) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
 		} else {
@@ -2815,7 +2809,7 @@ static int soft_offline_in_use_page(struct page *page)
 
 	if (ret) {
 		pr_info("%#lx: invalidated\n", pfn);
-		page_handle_poison(page, false, true);
+		page_handle_poison(page, false, false, true);
 		return 0;
 	}
 
@@ -2836,7 +2830,7 @@ static int soft_offline_in_use_page(struct page *page)
 		if (!ret) {
 			bool release = !huge;
 
-			if (!page_handle_poison(page, huge, release))
+			if (!page_handle_poison(page, huge, false, release))
 				ret = -EBUSY;
 		} else {
 			if (!list_empty(&pagelist))
@@ -2884,6 +2878,8 @@ int soft_offline_page(unsigned long pfn, int flags)
 {
 	int ret;
 	bool try_again = true;
+	bool huge;
+	bool free;
 	struct page *page;
 
 	if (!pfn_valid(pfn)) {
@@ -2929,7 +2925,9 @@ int soft_offline_page(unsigned long pfn, int flags)
 	if (ret > 0) {
 		ret = soft_offline_in_use_page(page);
 	} else if (ret == 0) {
-		if (!page_handle_poison(page, true, false)) {
+		huge = folio_test_hugetlb(page_folio(page));
+		free = is_free_buddy_page(page);
+		if (!page_handle_poison(page, huge, free, false)) {
 			if (try_again) {
 				try_again = false;
 				flags &= ~MF_COUNT_INCREASED;
-- 
2.52.0.457.g6b5491de43-goog


