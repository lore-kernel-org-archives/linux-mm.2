Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5ABCD583B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211E16B0005; Wed,  7 Jan 2026 06:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2826B0099; Wed,  7 Jan 2026 06:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7FF6B009B; Wed,  7 Jan 2026 06:33:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00A946B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:33:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9095C1AA78D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:44 +0000 (UTC)
X-FDA: 84304957968.13.D765E3C
Received: from sg-1-104.ptr.blmpb.com (sg-1-104.ptr.blmpb.com [118.26.132.104])
	by imf07.hostedemail.com (Postfix) with ESMTP id BADE340009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LSj7EPj1;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48A1SUtf1ORNjWppsSz9G1ylK0g/Qvc7EmDbh0wqBLU=;
	b=BDIgeW5ZyAJC4cGobzZeAN3XO0btv0zTxHUPaejzwl8Q37qE1gX9RLRt9+KNbSggN5Kj2U
	Jn1lYh6xEguFeKOmT5yYfL3ouY7+4QNR27+7Yr4cjTJRHmaJfuaL8o0wmrZLpO2xhHQQxF
	k/x+4/ZSIo5DLP5IImRO8PJYk/C93yU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LSj7EPj1;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.104 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785622; a=rsa-sha256;
	cv=none;
	b=WcwcdolZjWWRfhnFxi+IBNPO2wgl/nZA46mXKMxDL+Vpfpqlx1EAsusPmduhX4GgLJuTIe
	P3v6Cdxo8FMfdHu0mlLASgBCVYCl6KG5plRDSbrni8O6khuOzmZKfI4VIRiLd02b5FIHbe
	YQUr/QhnDbQzVYuRJhQRIAtkUB+6F/8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785614; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=48A1SUtf1ORNjWppsSz9G1ylK0g/Qvc7EmDbh0wqBLU=;
 b=LSj7EPj1dCLZ+sfneb0GVu0gZQpr3IIyd8YOREsORjmHlDBHSow0RVF/PVEcAsodoQ7sz1
 rrstyoyxomnnHcQpVrOEuw/FbT5yZGqkNeopGqWloXyBoF6c960KDIYKUm5bi1qhdoQxso
 N0Lg2HW+q3PRfM+CLpvo0jPFuj7v9eEgAmNFGWfdD8fF/TTj5rpjBbUG921TxamHzLT594
 JQsBTo9dlj2Cf8rTN5wpbQRKY61a9ghgoNsWfn4NfX6JB4zsoW3u89aC6Y8eVV3Ionslra
 dglBCasLULfGWaYEBJnZ+JFV6y/emc/68pbd3ukBN2t58UCGx705VQXOXTR3pw==
Date: Wed,  7 Jan 2026 19:31:26 +0800
Content-Transfer-Encoding: quoted-printable
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Message-Id: <20260107113130.37231-5-lizhe.67@bytedance.com>
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v2 4/8] mm/hugetlb: introduce per-node sysfs interface "zeroable_hugepages"
X-Lms-Return-Path: <lba+2695e448c+6aa885+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: k6s7qtus8gaam6jizhkrod5ydgj7pz7e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BADE340009
X-HE-Tag: 1767785621-354686
X-HE-Meta: U2FsdGVkX18c7kqrqM6DXgvfnEwgS3Jy0x51hA/X5lbixE5P19hyjPGcVF7StDFW9VdpLjMdQ7ZlNPIlVSS8zkvZcWI2QvuiT/7W4DKJHn+2JeCbUcXeXKi9Mj1BvbKtMrmYvR0BDs+xA6r3DGrgpb8t0PCs6RQ46d5tS3IJOVmX7lFDwMRtJgldQGSTupFpnLqmS+KERB1bYZ0+88QWJLzAKv+GH/rvlhDhXQ2ct3EK+4PwcGgSTUnW6ws2C49NSI3H4m1EHEgVrV3z9j0tIZskwjHYCI0aFDsT7ZNEaAasNe7MmJZQm81HIQC0AR3tQKQGxtoOeD1I/ztA7wazvmYBaf1g9Aq20AddfEGPxtCXXLnhuYr7YgDzEzrKOAgSeetPMoeYyn6p+VRfC56phCjPR1cWjcP0nIa8PeLOXHbfp03GPolQFHoUC6hpxUi03ZMdO0o73JnhkSw1D3QIsifYhauzOTKuQR06NjE5lxCjbroGvqXjTqh74+/ni2TVsg+lzOmMvghLaLReAZPOBiuu8osp6p+f4schn/gEq3C3e1G8rAD7sXwML79kQRQXevdbbmF7fte4SVjTGFcnSJGPeI67seTO2xal8MNH4ngJs8neJzqtQ+Y8zwQMp9WD7bHrOeVxF/BHtRARZVKhxriVnEr8ICWMhWlGZIBgxpAXYm/R+giEhpMmRM7qny527ZzK0HDGp2bHhqULK2OvtJYGCviXA+oUbeQyQlJZ3fLiRGkzcfKaWbBHetb1JpXq4kMMO9jhL3gFRZ8ChSIG42Y3LVlNg93KICdmiUZRXVlMWlL6HqphPQNUHfbAmB5ItBRyPETwDUWkYXpfTYJjylGFxHbznvxP9X9flAnentmxLKXdR/YboTinYwdyX/O4OTmpXabjdwchZF2U/VPUJ1xqPLnhM/fO71pqzre/F3nzLMKtck/lepW9cchA0wmFtK6AkRtc1LAIMKYYTR2
 Y0+6+eK9
 J/YQgEi5Cnzi4XtPimctDCwA+VhRMKtrcesJZOtj59/Brtsmc8kb50OCz7wXNH39cPoHvn3M9mQsWWXjPvUfd8AIt0KZtQ9afbqr6uhjiq2b+jnO0djNNO3MlA7X5fHKEQulmiYsBrrHGnMMB5wYMhd0qoXk3rmY7GiIqvSA3poO3m4U6hYpuBvlTqS5qPVTF+m64/OfC9RBRYLkw26n18l8wH+rkULh8EmNUTAt9zm0Y2RasMVEbHklUCN6DPAEJJsOPWdZRiL632DzuAdAwWfvBkgXOuKzgimLy2uQD/21m4VXqwCA2IUG8HiRDcnQoR2PO3Id8a+7Zt7/xf3j9X7JJHxO7NJOtVLUhr9jV/ezEFe8tcSdLa+i/Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fresh hugetlb pages are zeroed out when they are faulted in,
just like with all other page types. This can take up a good
amount of time for larger page sizes (e.g. around 250
milliseconds for a 1G page on a Skylake machine).

This normally isn't a problem, since hugetlb pages are typically
mapped by the application for a long time, and the initial delay
when touching them isn't much of an issue.

However, there are some use cases where a large number of hugetlb
pages are touched when an application starts (such as a VM backed
by these pages), rendering the launch noticeably slow.

On an Skylake platform running v6.19-rc2, faulting in 64 =C3=97 1 GB huge
pages takes about 16 seconds, roughly 250 ms per page. Even with
Ankur's optimizations[2], the time drops only to ~13 seconds,
~200 ms per page, still a noticeable delay.

To accelerate the above scenario, this patch exports a per-node,
read-write "zeroable_hugepages" sysfs interface for every hugepage size.
This interface reports how many hugepages on that node can currently
be pre-zeroed and allows user space to request that any integer
number in the range [0, max] be zeroed in a single operation.

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

Tested on the same Skylake platform as above, when the 64 GiB of memory
was pre-zeroed in advance by the pre-zeroing mechanism, the faulting
latency test completed in negligible time.

[1]: https://lore.kernel.org/linux-mm/202412030519.W14yll4e-lkp@intel.com/T=
/#t

Co-developed-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb_sysfs.c | 124 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 79ece91406bf..68a7372d3378 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -352,6 +352,129 @@ struct node_hstate {
 };
 static struct node_hstate node_hstates[MAX_NUMNODES];
=20
+static ssize_t zeroable_hugepages_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *buf)
+{
+	struct hstate *h;
+	unsigned long free_huge_pages_zero;
+	int nid;
+
+	h =3D kobj_to_hstate(kobj, &nid);
+	if (WARN_ON(nid =3D=3D NUMA_NO_NODE))
+		return -EPERM;
+
+	free_huge_pages_zero =3D h->free_huge_pages_node[nid] -
+			       h->free_huge_pages_zero_node[nid];
+
+	return sprintf(buf, "%lu\n", free_huge_pages_zero);
+}
+
+static inline bool zero_should_abort(struct hstate *h, int nid)
+{
+	return (h->free_huge_pages_zero_node[nid] =3D=3D
+		h->free_huge_pages_node[nid]) ||
+		list_empty(&h->hugepage_freelists[nid]);
+}
+
+static void zero_free_hugepages_nid(struct hstate *h,
+				   int nid, unsigned int nr_zero)
+{
+	struct list_head *freelist =3D &h->hugepage_freelists[nid];
+	unsigned int nr_zeroed =3D 0;
+	struct folio *folio;
+
+	if (zero_should_abort(h, nid))
+		return;
+
+	spin_lock_irq(&hugetlb_lock);
+
+	while (nr_zeroed < nr_zero) {
+
+		if (zero_should_abort(h, nid) || fatal_signal_pending(current))
+			break;
+
+		freelist =3D freelist->prev;
+		folio =3D list_entry(freelist, struct folio, lru);
+
+		if (folio_test_hugetlb_zeroed(folio))
+			break;
+
+		if (folio_test_hugetlb_zeroing(folio)) {
+			if (unlikely(freelist->prev =3D=3D
+				     &h->hugepage_freelists[nid]))
+				break;
+			continue;
+		}
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
+		nr_zeroed++;
+		freelist =3D &h->hugepage_freelists[nid];
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
+		nr_zero =3D UINT_MAX;
+	} else {
+		err =3D kstrtouint(buf, 10, &nr_zero);
+		if (err)
+			return err;
+	}
+	h =3D kobj_to_hstate(kobj, &nid);
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
@@ -359,6 +482,7 @@ static struct attribute *per_node_hstate_attrs[] =3D {
 	&nr_hugepages_attr.attr,
 	&free_hugepages_attr.attr,
 	&surplus_hugepages_attr.attr,
+	&zeroable_hugepages_attr.attr,
 	NULL,
 };
=20
--=20
2.20.1

