Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E45AC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892706B0095; Thu,  6 Aug 2026 07:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8424A6B0096; Thu,  6 Aug 2026 07:14:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735926B0098; Thu,  6 Aug 2026 07:14:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFA696B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:14:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76B7F1206CA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:14:56 +0000 (UTC)
X-FDA: 85070587392.09.596E131
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D988D1C000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:14:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQyMWSPd;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786014894;
	b=8fTHM5XCLkjuVNNLsKMDNZSeuUf1wJbzvBJNyU2NN6/ysjIzD+GecQAj7g/NZsymJGiDGu
	w2hgrnB79zIEBAdbpqMNWdEhvfLUfoEaTOuBbQCSATNkiGcF6ingf5kYqqGzjmQnylh+p8
	ubmTjpbVxdYuod9Tss6vZyYY0rvYyX0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQyMWSPd;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786014894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/ReBsEWVSG7DT1p1R8bGGZpfItCvJ0rC/y80hPOREMk=;
	b=SQGUORJ9YbfeVZeV6KUJPoaCwApOmSOtc+RXWbKp/3u6cozq8fkuljBMx46AZbBjxl8ExJ
	Ih10j/5YzJQd5gK1VL+8+DyCVDchO1UdrHDy59sdPed46L8/6SfURxnxIVNGmR+dYhg9Ta
	egs1l/xhBUFJmeLlLsFBiyJx+tgfNA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F86060A64;
	Thu,  6 Aug 2026 11:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B461F000E9;
	Thu,  6 Aug 2026 11:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786014893;
	bh=/ReBsEWVSG7DT1p1R8bGGZpfItCvJ0rC/y80hPOREMk=;
	h=From:Date:Subject:To:Cc;
	b=jQyMWSPdN8zYU//8DYxtWuBisX9smWBUzKzW2ArdiF57JwZmkgdajyinpngwNbGCN
	 kBzl/1rNf5fL0HuBdB/E+gpSHpomi2VtuR8Srncm3SRN6O0XA10Uk5SjU2bCHVget6
	 zv3qL9F0Wd50bATdZzeyXmWgIq9or8l0z09utQmu9iybj9wtrqP6vOD0t+h5nQy2O5
	 cPAhy20joWxhJZaCnkUNB0CT60qc6a3r5ALz3PJ6PbWjzU2jIwPy0yWdJrc47sueX1
	 os0Ns96+7TmhI61rSctiEaeGOHwZ+ePOoKuIwYV4CT0A1N50i9Tt8VZvVulTe68OYM
	 ytnyxEnZKbcAw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 06 Aug 2026 13:14:38 +0200
Subject: [PATCH] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-try_to_split_thp_page-v1-1-a259e3387e38@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJ5sdGoC/yXMUQqDMBBF0a3IfFdIrYq6lSIhxolOEQ2ZsSji3
 pvq54H37gGMgZChSQ4I+CWmZY54PhKwo5kHTKmPhkxlpapUmUrYtSya/USiZfTamzgyr6J2eV/
 ZWjmIXx/Q0XZ13+1tXrsPWvnH4Dx/wlbVQnkAAAA=
X-Change-ID: 20260806-try_to_split_thp_page-a359f4d8c90f
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Luis Chamberlain <mcgrof@kernel.org>, Li Youhong <liyouhong@kylinos.cn>, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D988D1C000A
X-Stat-Signature: so4xxgqfcwpsj7rfk66ue4ts5hbrp8sq
X-Rspam-User: 
X-HE-Tag: 1786014894-512249
X-HE-Meta: U2FsdGVkX18DssBTIkqjTvba9WLYlymuoZMLwY4RAsYZXn6XUcigZ4Iu+MlwM32CMD8kiYpLeGpG60Akilbb1ad3onN+W+cA1K/KovxakUgjbGp9K+Vzx7fRu91sisNtZMziWjV39JVpFIP6Ioa7TizydBaXQEbiXF7LbO10+GX11XV6eLAQ4cGt9qY/64Le+rFyyIT3WyfZsbD0Zl3s5c195jYVz+df9N72FnXo7az+v7phuZ+VbHGEty71iVdrCH267PIvUgn5hOQrLqTjtjnU27GhEMjvF40ex2EtfiwNSzwmWkc5BuC4Kmv4g79fcEHBBtEpqD03T3e3L1/ySF0eMWQQnhSKnSeJIveys+8uDbB2Rb4YJboiHmMndCqJolsEHKh52aPQqob/7U1LgjeXXJeK1NFKu8uIR0PFNBAai1zjHmZnfobPjQI3itZ3gtrPsUSpgAUHgJJUHX4R/peSes1MKD23a2/cZ7NSEWy7df3nbDd/aHE31KgtGylZvq5CMiyaxukeN2Mwm+EC+p8ENZMpaW1Hq3OyJX7dZ8eANZJtNkbpE6A95ehEJp5xOZK8Ww9TWiejBi88v+Jv6JpKm/AuUTI7j16xA+JsZBDHNgCVBS7f2az4OeKdiiLu9YACMYavFpO3S/oFGp06zdu1dHOEwIh+6fFaEZGWXHD8QaTtd2kLuVCAwzUIMkfa/XHJ/NaeW6sydN2G9iyi6YBdJqtUdW/FbqFtucLkY7zn9VC1zcm8rmbvFTonRqpNSruINxOQLMYpFi9ovJCC1iv/fgiQb/95OYXI6Tj/BVJO/m3kH6SB1vLgkhbqxzoBJtNNbK5GNsmQHozBgQHZH2jNFhtcbJ44cb7nM91rMWTdexNbbXRkEiqG3FMbM7YqvMlzmto6ZZMhJx9CYC93MEcCrj7egUJquhda0XBhfAKi1bYq0M6SCooUkOM5UwZ3mE935rVeY80g0E5Vh2U
 1PGHZ/nO
 tZsFi3P5KI1gr5KYGshBMOY1xWnDmAP10/gPf1tBCNETTWmh2cnrcyHBe2DB60pDDqEE0ffs4f8OIapRWLSQVZEPeyjGTQvzCj7UtFTIRTRDfRs/oNBXv087xA6HhXcFUJ7HHhzwnNYKaPQJh6Ma4B4r8RFKQbBMQ3u3AqRT5quDOXZgQ4SgYXcZ1cHH31RU/LWx475YQotDpDZpcLaqJ6awtjyDHo6oENz1J4atkYANWHauwcRrM97cHqjJde6KYQlfPvHuXzak2zlwa4XO8s+c8rtGnn9nz/FQR5c9cCslzMXnXFJJ1hMy/a86ZCWZeewM5fc+evpkK62g/eDjbDUsmyYknK7dyE3OWhKM1k6pPR9w4ufp7Oc9nYtlyvhDSRScmh9Y23O9QUHc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hwpoison code can end up calling min_order_for_split() without holding
the folio lock. There isn't really something that would prevent
concurrent folio split. Consequently folio->mapping can get set to
NULL after checking for "!folio->mapping", and if the compiler
reloads folio->mapping, mapping_min_folio_order() would try to
dereference NULL.

While very unlikely to happen in practice, let's just enforce that
min_order_for_split() is called with the folio lock held. We can
significantly cleanup the calling hwpoison code, and just get rid
of try_to_split_thp_page() to hold the folio lock for a bit longer.

Just work on folios now, which further cleans up the code. We just
have to be careful about doing the page_folio() after splitting, which
we have to do already either way. Do not change the way we split for
now, this needs more thought and should be done separately.

Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
would currently have leaked a folio reference.

In folio_split(), document and assert that we need the folio lock.
Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.

The folio->mapping problem was identified by Sashiko, and Li Youhong
reported it by sending a proposal fix.

This likely does not really warrant CCing stable, but I expect little
conflicts when doing the backport, so let's just CC stable because of
the refcount leak.

Reported-by: Li Youhong <liyouhong@kylinos.cn>
Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
v4 of the last fixing attempts:

https://lore.kernel.org/r/20260806031958.677935-1-dayou5941@163.com
---
 mm/huge_memory.c    |  4 ++++
 mm/memory-failure.c | 56 ++++++++++++++++++-----------------------------------
 2 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9b1f3b24f7e0d..a00df56a68b57 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4362,10 +4362,14 @@ int folio_split(struct folio *folio, unsigned int new_order,
  * If a file-backed folio is truncated, 0 will be returned. Any subsequent
  * split attempt should get -EBUSY from split checking code.
  *
+ * Context: @folio must be locked.
+ *
  * Return: @folio's minimum order for split
  */
 unsigned int min_order_for_split(struct folio *folio)
 {
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	if (folio_test_anon(folio))
 		return 0;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e2..f4f3f1fc9eaff 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1705,26 +1705,6 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 	return page_action(ps, p, pfn);
 }
 
-/*
- * When 'release' is 'false', it means that if thp split has failed,
- * there is still more to do, hence the page refcount we took earlier
- * is still needed.
- */
-static int try_to_split_thp_page(struct page *page, unsigned int new_order,
-		bool release)
-{
-	int ret;
-
-	lock_page(page);
-	ret = split_huge_page_to_order(page, new_order);
-	unlock_page(page);
-
-	if (ret && release)
-		put_page(page);
-
-	return ret;
-}
-
 static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
 		struct address_space *mapping, pgoff_t index, int flags)
 {
@@ -2509,9 +2489,6 @@ int memory_failure(unsigned long pfn, int flags)
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
-		int err;
-
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2526,24 +2503,25 @@ int memory_failure(unsigned long pfn, int flags)
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+
+		folio_lock(folio);
+		split_huge_page_to_order(p, min_order_for_split(folio));
+		folio = page_folio(p);
+		folio_unlock(folio);
+
 		/*
 		 * If splitting a folio to order-0 fails, kill the process.
 		 * Split the folio regardless to minimize unusable pages.
 		 * Because the memory failure code cannot handle large
 		 * folios, this split is always treated as if it failed.
 		 */
-		if (err || new_order) {
-			/* get folio again in case the original one is split */
-			folio = page_folio(p);
+		if (folio_test_large(folio)) {
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
-			put_page(p);
+			folio_put(folio);
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
 			goto unlock_mutex;
 		}
-		VM_BUG_ON_PAGE(!page_count(p), p);
-		folio = page_folio(p);
 	}
 
 	/*
@@ -2861,9 +2839,8 @@ static int soft_offline_in_use_page(struct page *page)
 		.reason = MR_MEMORY_FAILURE,
 	};
 
+	folio_lock(folio);
 	if (!huge && folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
-
 		/*
 		 * If new_order (target split order) is not 0, do not split the
 		 * folio at all to retain the still accessible large folio.
@@ -2871,15 +2848,20 @@ static int soft_offline_in_use_page(struct page *page)
 		 * preferred, split it to non-zero new_order like it is done in
 		 * memory_failure().
 		 */
-		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
-						       /* release= */ true)) {
+		if (!min_order_for_split(folio))
+			ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;
+		else
+			ret = -EBUSY;
+		folio = page_folio(page);
+
+		if (ret) {
+			folio_unlock(folio);
+			folio_put(folio);
 			pr_info("%#lx: thp split failed\n", pfn);
-			return -EBUSY;
+			return ret;
 		}
-		folio = page_folio(page);
 	}
 
-	folio_lock(folio);
 	if (!huge)
 		folio_wait_writeback(folio);
 	if (PageHWPoison(page)) {

---

base-commit: e5492213654050379e78ec6f9acfd6c9fe00f334

change-id: 20260806-try_to_split_thp_page-a359f4d8c90f

--

Cheers,

David


