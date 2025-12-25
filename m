Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DF4E7AD41
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 08:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693506B0092; Thu, 25 Dec 2025 03:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D2E6B0095; Thu, 25 Dec 2025 03:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540316B0096; Thu, 25 Dec 2025 03:22:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40AE06B0092
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:22:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D652514060D
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:29 +0000 (UTC)
X-FDA: 84257301618.08.2FCC681
Received: from sg-1-101.ptr.blmpb.com (sg-1-101.ptr.blmpb.com [118.26.132.101])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79A0480004
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 08:22:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hNdInncA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766650948; a=rsa-sha256;
	cv=none;
	b=dgc6F3wURu/knQf6vhmUscATmdWtu+L09jmIAxCLnL6+zv8/U+A/ZkVnTkYHkKd3pZnsFM
	iE55ho13bkH5Nlr2+cFPsELLSxOjYwuVH3tSAz7bENthXedh4XfgM4Gp3UjOhAapim0NHR
	MCdM4a46z0bXAoMo8CORtdfGPK5xSmc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=hNdInncA;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.101 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766650948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti9W+1CuspxDIvv7pxjazdy7Xiv9t090Z7oTyo6LLN4=;
	b=3fZf4M1zjFldKp6qvemH6iK7Bp0WW+UNAyEbBAn45WlNIGB1EPIVhCsLF8tY+idUXWOPHB
	QG+4gAgtlXbWVjQMhrE1X0qp6Hj+vl0hxZr1mSoa3W9woEsRKhALR7QzYfbh5t8Ur3qe1o
	2WO8u+q3sABSo5kkZf/6aNMnf74z8Ok=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1766650941; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Ti9W+1CuspxDIvv7pxjazdy7Xiv9t090Z7oTyo6LLN4=;
 b=hNdInncA1Uh3h+eS+4jgdIfNkBAccQpVGuQ0/aTFJiT77YjuD34P/sdHW/sZeWS1cji00Y
 uDf7BqSD2S+2zYr862dlZRvIo0XilGGpKDE1mdDOHYNlq2rfshmtMljI8G7C76H6+5h5tz
 66zBkBu/HoxAHz0JeJNihCP0pLvBI+Csbh8WCDhV6+rgxnCl820JnE4LvBnVXOdW2gfTbc
 x/nhVWnbFj1oc+xwsyEXaZa4XWYs5tnSdTjEsoXUoqhClugJz7SyfSe/GJQAywVVEHGoOq
 BoeXUJgILoiBvOG7BxmPc+PdlJuYw94Bq1ElmgKHzRcBgK9aESW9LrdW534T4A==
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251225082059.1632-1-lizhe.67@bytedance.com>
References: <20251225082059.1632-1-lizhe.67@bytedance.com>
X-Original-From: lizhe.67@bytedance.com
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Subject: [PATCH 4/8] mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
Date: Thu, 25 Dec 2025 16:20:55 +0800
Message-Id: <20251225082059.1632-5-lizhe.67@bytedance.com>
Mime-Version: 1.0
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
From: =?utf-8?q?=E6=9D=8E=E5=96=86?= <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2694cf43b+7454a6+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 79A0480004
X-Rspamd-Server: rspam03
X-Stat-Signature: q4pngp6pbtrmowq3kkcuhs7rk83t654p
X-Rspam-User: 
X-HE-Tag: 1766650947-784751
X-HE-Meta: U2FsdGVkX180Vqpek6u36nb57qk5wn9rCyIDd0iblQ+94VzCQt1puHEt8amIEuvlBZuLcZy9+ztVUivWk7PSAd6Ultn29AL3ZzeNl0z0VeWzSllI2anwfS7qhXoeMdIteJJrzwbE3TP75FMA2aUQrytr/vX9Uw3ZtxuZbmdLcA+CPb9zoWYdCCKncuSoJJh5sfc5ok0keB7FDrxmzssMKhXHWRE27JRWqQyL6f9/nj7YcFhdLu0Z2pfg4mA6Ujnp7C8xZMU2KpTX7SIHbp2OVyTCprVFG9QsfY4wQxM+nRRU97yN797IYAzMoptahKS6R3FevlNlbJUi1woNqmusk9dtwSCxzjzsYIXEr9XShXdNCHTFWoT2HbiKqVrypKggrB2GrQxdMaKe2djWmyeDmggRTDzC5q/7/4hyjYKz3mv7yjsQQybUehXkMmQCdAErjzI404qDGllBeTjpuV07Xe3bvi9XdEcJzyyGsD6HYww9x6GpS1b3FZzxkFwvFF8296JQpzWLZn6XDE3YUA2SH5+M6z6KUbgWdaQpt5dextO1QCFHqtJF3+7KVTkQU+AuM5UciRO5dK176dLlMwBn9yYkGjoqLmIWYrpeb9NbtBQ9Q1ZZvwIHXcDptVbHaLcGSNXKt7SNsa1Cd1ydqjEbuyBVNk2tTkRiS2yrf3QhcFj/daCkA3jA3ghM2x3f7w3tWbVqFsJiO/O8MLoD23rUDUwSVZ47U0O+Lj3hbM/vMSuz0G4UH3rUfLD5w5SaSRtSUpOZR69ojBpL0h1GSQaqeBtcAbFjG0QNCPGoVAuzYD+ulyDjgJeorWRI79E5XESgse3Y74pzFVITRFBL8CtpGZMrvzgu9YvnDwhOnoFFTpLZZSijJa5Zs8N9ntOCsGs2scI+Rl6YSfzprM4MViO3DS8va5fpaUiofO6ITFWubWatN3ca611PvbRbzwYbgyfvOVRTtTh2WXY5+rnGnOl
 aX6ZTYis
 MoeKV9tllwAOSgGU/HsfzzbnFLX/bcwoEdQAyWYzyUE9C9DvmiTUXaQJ9nEcWQKH0flxDAewMV2HWOZkwfpf+J8zq8b4Wfkkt4lG8RrYdiffsGfFAasEkPvlwFEMUTswKyEfZthk729QQX/RpEEn0Lw95xe2tXDWHsayBxM4J0F9mcylOJwBBAiGEFyjM53Prt8w4wEL9nYV+KxU+zoW6DIVY57g7ie0rA2NFuri7aU4XNQNEinwNfGnD4HPDP2/sfUpRbwuYr0CeZiDnqM5fiiIBe+vQ8JAAdHmiwYpFzAc6Eyr5KYNBTuzyV0Cx/hPHC+wD7akGC1C96h+rpJmIURWWwntoKQHVFl/9GTbZtbELHspKXfZla5WuOlBgqXqCDpprz8GzLwKDW9E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

Fresh hugetlb pages are zeroed out when they are faulted in,
just like with all other page types. This can take up a good
amount of time for larger page sizes (e.g. around 40 milliseconds
for a 1G page on a recent AMD-based system).

This normally isn't a problem, since hugetlb pages are typically
mapped by the application for a long time, and the initial delay
when touching them isn't much of an issue.

However, there are some use cases where a large number of hugetlb
pages are touched when an application (such as a VM backed by
these pages) starts. For 256 1G pages and 40ms per page, this would
take 10 seconds, a noticeable delay.

This patch adds a new zeroable_hugepages interface under each
/sys/devices/system/node/node*/hugepages/hugepages-***kB directory.
Reading it returns the number of huge folios of the corresponding size
on that node that are eligible for pre-zeroing. The interface also
accepts an integer x in the range [0, max], enabling user space to
request that x huge pages be zeroed on demand.

Exporting this interface offers the following advantages:

(1) User space gains full control over when zeroing is triggered,
enabling it to minimize the impact on both CPU and cache utilization.

(2) Applications can spawn as many zeroing processes as they need,
enabling concurrent background zeroing.

(3) By binding the process to specific CPUs, users can confine zeroing
threads to cores that do not run latency-critical tasks, eliminating
interference.

(4) A zeroing process can be interrupted at any time through standard
signal mechanisms, allowing immediate cancellation.

(5) The CPU consumption incurred by zeroing can be throttled and contained
with cgroups, ensuring that the cost is not borne system-wide.

On an AMD Milan platform, each 1 GB huge-page fault is shortened by at
least 25628 us (figure inherited from the test results cited herein[1]).

[1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com/T/#t

Co-developed-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb_sysfs.c | 120 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 79ece91406bf..8c3e433209c3 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -352,6 +352,125 @@ struct node_hstate {
 };
 static struct node_hstate node_hstates[MAX_NUMNODES];
 
+static ssize_t zeroable_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long free_huge_pages_zero;
+	int nid;
+
+	h = kobj_to_hstate(kobj, &nid);
+	if (WARN_ON(nid == NUMA_NO_NODE))
+		return -EPERM;
+
+	free_huge_pages_zero = h->free_huge_pages_node[nid] -
+			       h->free_huge_pages_zero_node[nid];
+
+	return sprintf(buf, "%lu\n", free_huge_pages_zero);
+}
+
+static inline bool zero_should_abort(struct hstate *h, int nid)
+{
+	return (h->free_huge_pages_zero_node[nid] ==
+		h->free_huge_pages_node[nid]) ||
+		list_empty(&h->hugepage_freelists[nid]);
+}
+
+static void zero_free_hugepages_nid(struct hstate *h,
+				   int nid, unsigned int nr_zero)
+{
+	struct list_head *freelist = &h->hugepage_freelists[nid];
+	unsigned int nr_zerod = 0;
+	struct folio *folio;
+
+	if (zero_should_abort(h, nid))
+		return;
+
+	spin_lock_irq(&hugetlb_lock);
+
+	while (nr_zerod < nr_zero) {
+
+		if (zero_should_abort(h, nid) || fatal_signal_pending(current))
+			break;
+
+		freelist = freelist->prev;
+		if (unlikely(list_is_head(freelist, &h->hugepage_freelists[nid])))
+			break;
+		folio = list_entry(freelist, struct folio, lru);
+
+		if (folio_test_hugetlb_zeroed(folio) ||
+		    folio_test_hugetlb_zeroing(folio))
+			continue;
+
+		folio_set_hugetlb_zeroing(folio);
+
+		/*
+		 * Incrementing this here is a bit of a fib, since
+		 * the page hasn't been cleared yet (it will be done
+		 * immediately after dropping the lock below). But
+		 * it keeps the count consistent with the overall
+		 * free count in case the page gets taken off the
+		 * freelist while we're working on it.
+		 */
+		h->free_huge_pages_zero_node[nid]++;
+		spin_unlock_irq(&hugetlb_lock);
+
+		/*
+		 * HWPoison pages may show up on the freelist.
+		 * Don't try to zero it out, but do set the flag
+		 * and counts, so that we don't consider it again.
+		 */
+		if (!folio_test_hwpoison(folio))
+			folio_zero_user(folio, 0);
+
+		cond_resched();
+
+		spin_lock_irq(&hugetlb_lock);
+		folio_set_hugetlb_zeroed(folio);
+		folio_clear_hugetlb_zeroing(folio);
+
+		/*
+		 * If the page is still on the free list, move
+		 * it to the head.
+		 */
+		if (folio_test_hugetlb_freed(folio))
+			list_move(&folio->lru, &h->hugepage_freelists[nid]);
+
+		/*
+		 * If someone was waiting for the zero to
+		 * finish, wake them up.
+		 */
+		if (waitqueue_active(&h->dqzero_wait[nid]))
+			wake_up(&h->dqzero_wait[nid]);
+		nr_zerod++;
+		freelist = &h->hugepage_freelists[nid];
+	}
+	spin_unlock_irq(&hugetlb_lock);
+}
+
+static ssize_t zeroable_hugepages_store(struct kobject *kobj,
+	       struct kobj_attribute *attr, const char *buf, size_t len)
+{
+	unsigned int nr_zero;
+	struct hstate *h;
+	int err;
+	int nid;
+
+	if (!strcmp(buf, "max") || !strcmp(buf, "max\n")) {
+		nr_zero = UINT_MAX;
+	} else {
+		err = kstrtouint(buf, 10, &nr_zero);
+		if (err)
+			return err;
+	}
+	h = kobj_to_hstate(kobj, &nid);
+
+	zero_free_hugepages_nid(h, nid, nr_zero);
+
+	return len;
+}
+HSTATE_ATTR(zeroable_hugepages);
+
 /*
  * A subset of global hstate attributes for node devices
  */
@@ -359,6 +478,7 @@ static struct attribute *per_node_hstate_attrs[] = {
 	&nr_hugepages_attr.attr,
 	&free_hugepages_attr.attr,
 	&surplus_hugepages_attr.attr,
+	&zeroable_hugepages_attr.attr,
 	NULL,
 };
 
-- 
2.20.1

