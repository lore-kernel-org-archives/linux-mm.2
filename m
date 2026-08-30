Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0893C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED296B0096; Sun, 30 Aug 2026 03:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E7E6B0098; Sun, 30 Aug 2026 03:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF406B0099; Sun, 30 Aug 2026 03:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C42AF6B0096
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:48:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56D22160253
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:03 +0000 (UTC)
X-FDA: 85157157246.18.90AFBD2
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf08.hostedemail.com (Postfix) with ESMTP id 29271160006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:48:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HqsumBeM;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FocyO/JDmM2QVifCnhzs+yu9qHtqhqqws4KGMnNgkMY=;
	b=AcvlCtFUNPdl8tJGbcMiEMHotDeVVbIHyxQ6l68O9OsSOO32+5dYOMx3WpXqb5EB3AfyHU
	xttL35OM6TmJcXabowa07RAvUyxcfRqHg35+1h/TVB3wSxSZBTw3SDO3aKn4Vm4wq1l3cy
	SfWyYfdrtbNwSrqii61wsRVyEmGsfLs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HqsumBeM;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076081;
	b=xhRhiMvcHSHMLvjNt27KchugmjGfZsRC2o06sMlT0IUyy7pXK5yGxyIrEDEzGSfRC66kSI
	I1KuoKELu0w/O9Xr1ZUOnaJJiY9DntB7xEWr7JYjOVZCfrx4VT4Lrzgn1xiBzph1pmFt9U
	bo4mekzZej7D5Z8Wh51xGC8YcPCgRLA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sSUo0d8E6BWyoxCIKSh8oJBYJiXLVVUVNPEG+Z60ppw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788076077; v=1; x=1788680877;
 b=HqsumBeMu8gUKQc240wHUOprGRLXsxzduQu04+kr7FaAHlgwWfYr6/0ZeFh3hcfNgou0fWqF
 ddjzCUV1uLbKHiOZjp0/33vk1q7xqJwB7oNb+wfBICy6RI567FObiwnJIDiftdjNa/Hx6gBe7oP
 XXvRxnMTipyLTuGIouA7YlEc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ee9797414e8e0c9f;
	Sun, 30 Aug 2026 07:47:57 +0000
X-Mizu-Trace-ID: ee9797414e8e0c9f
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 0/3] mm: reject zone device folios in more folio walkers
Date: Sun, 30 Aug 2026 15:47:51 +0800
Message-Id: <20260830074751.25370-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <c2577ec5-acf6-466b-ba66-0b3bcabbef7d@linux.dev>
References: <c2577ec5-acf6-466b-ba66-0b3bcabbef7d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nc4x5riot4wogerrq7dibo4omhjsrukc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 29271160006
X-Rspam-User: 
X-HE-Tag: 1788076080-59747
X-HE-Meta: U2FsdGVkX186QlxA81N9rnl6LfYL2ZIvWRgpjgZ+zDVhZG3Mk58INxr6sIJ65oUdPrnMmfwOUsnyN7Rk29s7UG6d/6S0g5k2n3ymOSsnzA351G+WP3JtlkwKbeLU/PkIdBNTPeDfwxYMjx1E/LfVqamr8Tt9UFyaxnmKSrYXqNDu/x2V7D45A58PZnAogJCt8soaSQaU4MbGsNEEuS/nBm2XWpUxfDeYl93h3EaPLNrPRLvLN7/T+6SUVhUJPGuJQk6XXjwNwRKCvDSEbG8nRxDeMHbyz0HwBL7RllnHED/qPJxnyMkNgE8Z4hhum6Kna5oj0uBjoFHf6mgsTvUvjWwvVLLjjWxSjyDw6XjRnTDpgg1rG9TLuyVTseE9taJZNf2EuDqtGekCwGKQQAeQJMZHU9erUvFxqI0mNwzXWqGUV8b8l7SCN7sshy2iGpnZDA0+EHuWRbvaB/UNnxZipdGl8VDzwqWfPsvXbjJd2Cs/SZ534aqJPTCySRefOFVO4I+ZqRc75taqxVynLRQs9g3yLtkMSJ/J4NZiWvBO+8P43t7STO7gFFIB8dsvC8sB/HUf4wxJOhVAMz6yz8zdGrjKvDLZSHUBX/VwjmiUqPvVENGadSqLYgqNfCiSKRsW8IRYqN8yBGIA9lj27RqMOyck4dovKlTWKu8+bIHnx6tGDJLxWt2oShgcAk3pfiub2R+n1NUehoNMyvCsQ8+nCCmzlMs/yZVfGe/uPYxaKjTBAXT0rICVwOuWkVRcP1is4hBgVQ4kjkc167lHWTswP6igDwn6X/F1ZbQqhHGBCAwOZZ18qhzE7NwbHnpkg8IDWzyOT4cMFjTluALJC+3qX71/vPVZW/0cd9yMT52fP83C9hKlhA6itOaWiK5vd2gBxdYDryBgqSvQiU7iAnq/7X1Iwe9ZoDr/9N6TLXDClcDKDBjEdoxebGTdtKCloXNbVRB1DYU7exNjuMlGniE
 S+DS097g
 YEvA/bOvyVdjjHQo2N7DlsPNpa1kkhh9RdAv73F26Rk9kWJUYc0z339TKQRuGRN6C3MqqAe4YrUaDBjvPos/HsJyI6esGjsN2FvNWZ4CA86Wl1g0Cl2/2441eKJwWBRoTa12ImZQatC/Kvz0uGkBT+L8iKc9srzW24xUgAs+/AD9r6Gyq6hhowqc5jLLe3tTaVAV73JPqmc5XgAIzVKbpFMMdlXzVBejz+yLgGQMZkqPlrb6/0ImCpvOgeL27OuZ3wceUd1tAppALX+J7VGP38voe0iDeJC6LoiFedY0+AYh+88KAzOwwFFwuAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Aug 30, 2026 at 01:18:24PM +0800, Lance Yang wrote:
>
>
>On 2026/8/30 08:18, Andrew Morton wrote:
>> On Tue, 18 Aug 2026 12:31:43 +0800 Lance Yang <lance.yang@linux.dev> wrote:
>> 
>>>
>>> On Mon, Aug 17, 2026 at 06:08:07PM -0400, Gregory Price wrote:
>>>> Several LRU-oriented mm walkers resolve the folio backing a PMD entry
>>>> (or a physical pfn) and then reclaim, age, migrate, or lazyfree it
>>>> without ever checking for ZONE_DEVICE memory.
>>>>
>>>> This series adds missing folio_is_zone_device() rejections, matching
>>>> the checks that comparable walkers already perform.
>>>>
>>>> - mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
>>>>   only filters device-private entries (which are non-present).
>>>>
>>>>   A present zone device PMD (e.g. device-coherent) would still reach the
>>>>   folio and be lazyfreed / aged / paged out. Add an explicit check.
>>>>
>>>> - mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
>>>>   (e.g. device-coherent) and queue it for migration.
>>>>
>>>> No crash reproducer - this is a correctness/hardening cleanup found by
>>>> inspection. All checks are placed after the folio is resolved and before
>>>> it is acted upon, on paths that already hold the relevant page-table lock,
>>>> so no locking or refcount changes are involved.
>>>
>>> Cool!
>>>
>>> Gave the whole series a spin on x86_64 QEMU with a PMD-mapped
>>> device-coherent THP. Without these patches, partial MADV_FREE and
>>> MADV_COLD reliably hit a kernel panic in remove_migration_pte(), while
>>> mbind(MPOL_MF_MOVE | MPOL_MF_STRICT) returned -EIO.
>>>
>>> With v2, all three worked fine, PMD mapping stayed intact, and data
>>> checked out :)
>>>
>>> Note that both kernels used the same small change to the in-kernel HMM
>>> test driver, allowing its coherent device memory to be allocated as 2 MB
>>> folios so the PMD-mapped test case could be exercised.
>>>
>>> Tested-by: Lance Yang <lance.yang@linux.dev>
>> 
>> Thanks Lance, you're so diligent.
>> 
>> I'm wondering what to do here.  Gregory told us
>> 
>> : No crash reproducer - this is a correctness/hardening cleanup found by
>> : inspection. All checks are placed after the folio is resolved and before
>> : it is acted upon, on paths that already hold the relevant page-table lock,
>> : so no locking or refcount changes are involved.
>> 
>> And you had to tweak the hmm-test driver to reproduce the bug(s).
>> 
>> So when do we push this series out to -stable?  As a hair-on-fire
>> hotfix, or as a leisurely next-merge-window thing?
>
>Thanks, Andrew :) Yeah, I'd say next merge window should be fine :)
>
>The crash is real once the mapping exists, but I had to tweak test_hmm
>to create that PMD-mapped device-coherent folio, and I couldn't find
>any in-tree production driver doing that today.
>
>So no need to rush this one, I guess.

BTW, noticed that the ZONE_DEVICE split handling only covers
device-private folios, so device-coherent folios aren't supported ...

The call chains are:

split_folio()
  -> __folio_split()
    -> folio_check_splittable()
    -> __folio_freeze_and_split_unmapped()

migrate_vma_pages()
  -> __migrate_device_pages()
    -> migrate_vma_split_unmapped_folio()
      -> folio_split_unmapped()
        -> __folio_freeze_and_split_unmapped()

And I added the device-coherent check to folio_check_splittable() and
folio_split_unmapped(). See below. They can go away once device-coherent
folio splitting is supported :)

If folks think it's worth having, I can send it as a follow-up :)

---8<---
Subject: [PATCH] mm/huge_memory: don't split device-coherent folios

From: Lance Yang <lance.yang@linux.dev>

The ZONE_DEVICE split handling only covers device-private folios.
Device-coherent folios are not supported.

The call chains are:

split_folio()
  -> __folio_split()
    -> folio_check_splittable()
    -> __folio_freeze_and_split_unmapped()

migrate_vma_pages()
  -> __migrate_device_pages()
    -> migrate_vma_split_unmapped_folio()
      -> folio_split_unmapped()
        -> __folio_freeze_and_split_unmapped()

Reject device-coherent folios in folio_check_splittable() and
folio_split_unmapped().

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/huge_memory.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa983..a5dd38e9a8de 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3937,6 +3937,10 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (!folio->mapping && !folio_test_anon(folio))
 		return -EBUSY;

+	/* TODO: Support splitting device-coherent folios. */
+	if (folio_is_device_coherent(folio))
+		return -EOPNOTSUPP;
+
 	/* order-1 is not supported for anonymous THP. */
 	if (folio_test_anon(folio) && new_order == 1)
 		return -EINVAL;
@@ -4354,15 +4358,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  *
  * anon_vma_lock is not required to be held, mmap_read_lock() or
  * mmap_write_lock() should be held. @folio is expected to be locked by the
- * caller. device-private and non device-private folios are supported along
+ * caller. device-private and non-ZONE_DEVICE folios are supported along
  * with folios that are in the swapcache. @folio should also be unmapped and
  * isolated from LRU (if applicable)
  *
  * Upon return, the folio is not remapped, split folios are not added to LRU,
  * free_folio_and_swap_cache() is not called, and new folios remain locked.
  *
- * Return: 0 on success, -EAGAIN if the folio cannot be split (e.g., due to
- *         insufficient reference count or extra pins).
+ * Return: 0 on success, -EOPNOTSUPP for device-coherent folios, or -EAGAIN if
+ *         the folio cannot be split (e.g., due to insufficient reference
+ *         count or extra pins).
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
@@ -4373,6 +4378,9 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);

+	if (folio_is_device_coherent(folio))
+		return -EOPNOTSUPP;
+
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;

--

Cheers, Lance

