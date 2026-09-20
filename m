Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C07EC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782286B00AB; Sun, 20 Sep 2026 03:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759776B00AC; Sun, 20 Sep 2026 03:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696D56B00AD; Sun, 20 Sep 2026 03:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8C06B00AB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:22:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D82DD1A03E5
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:35 +0000 (UTC)
X-FDA: 85233297870.19.309A9B3
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id E994E180003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789888954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o4MqUAjI0+Jsynq231Zf4OsbZXw1ejo51z1pl6S6pK0=;
	b=Qu8GaPv2s3zED72mPhMfBtRijd0SRvXDFxEI0JCG3urFuR/eeYqbNKkp7L+Lb4VxmjvMpB
	lGjNlnEurVSUlZfsMhzkC+DqfoEc8kDT7G9DNyCDeiSOcYM0KEF9vQl/3fpBsUrEv3k5R+
	INBuB04Z4wrDR8O0kOcxf5NUHUOYSQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789888954;
	b=b97gtWfAmbpm8pTehQ/uw1WdErKUmqoXlC844EW5NYAKfBXtjiYY/JgSd3HVCzDITeALzh
	9jdIW4vt8iyU8CVFsefMJxFMzwyoG2zbVCim50gDrA75u4dANx8QaS+/m/mJ4gxr9cBRRI
	8j90i4oRwTgeJLbAUFhxVYtymRvmFn4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.42 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a1c7e6cb72b09bb2;
	Sun, 20 Sep 2026 07:22:32 +0000
X-Mizu-Trace-ID: a1c7e6cb72b09bb2
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	david@kernel.org,
	kunwu.chan@gmail.com,
	baoquan.he@linux.dev,
	gourry@gourry.net,
	riel@surriel.com,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC PATCH 14/17] mm, swap: charge an xswap entry when it gets physical backing
Date: Sun, 20 Sep 2026 15:20:40 +0800
Message-ID: <20260920072043.430390-15-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920072043.430390-1-hebaoquan@kylinos.cn>
References: <20260920072043.430390-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E994E180003
X-Stat-Signature: 47kb1sgoxse7ky44i7xd5t1jmeggkfyk
X-HE-Tag: 1789888953-84521
X-HE-Meta: U2FsdGVkX1+wG6nE8rpD2yewk8KRNygKFS13OoSRT2CZy3wcimP6iFK0840GMC/LExYQBHj2JhQdmbb96714DCChtn8i2w0RpZPzM6NF+fwad52lEVEvS3SBMbS8DxaEgEbp/nd5wkjSB9E03e4Iua0jr0utZKOhNkfEVeV2MXLbIZacGWUDPw/EaTHhD4Tf5PpzwLCDP/fbYVBYoPBawVRkee1SawGdKnYFp71oMITHgZZsGpq9h+HbCSGQ8MRrdVuyjMz9Ro3QJRWM7lMCL/SY92lG9a4I9snVQaxMxUH8K/eIQ3j7ywuRORxqN2Jl7IIk5qudDWDUS1R1okN+5k2wAuz6oQnXVFg1TV8aC2BgsJhmThqST1jpCi1DBoHYTHkmQ68vGzI0z3D1qSvNqpVLQ3DD89MxyPvvs5PenPPh59SW7PO/2xySCcj89RElsNk8K8djDBdYi5XWKmORHPxcu8ySKH3SLqnnxnCwZfUNbCkp2j3RAvn/+aSpGEouYXPkFOr2qrlULW12f6hPAnHOC4nRu0xjT2uZCweTBMpZWOG2q2D5pIwSUv7ibbPndNz7mVku6sjm8dzGE4cWAbHrcE6xMgvhghN+0707V0wyu5ZxEmmwhJjQZwmXKf70J+Iv2fI404R/E1EJ6/Mo+AEWosOVg3GtlD/5RK2pB68zaKTbrqMKdDZMdSeO6qYud7hKOdFCNzO6jPeID3LsqI/1L3uk57pZ6FToPkZAG45bwUJwT0x7XluYqmO9/TMzKDrqfE9AuyA9zVMs5sAyUSG6JD8CAS53Lgz0jlIEPF5bPsQrF0ObBYvIML/9UtrKbvZUqDf00ilvJ5lKtbZkk4l+raTxjGnKNjiMk9xGFGm4y8yifL9Kfc535taWe02oVv07sOet57FShvZBsC9QlslTGaIJHXnT52N+ODqXgYk6r5Y9VUmzOBvdc3P3IzZ5Y5yBwXYr8nYU4Zt7xls
 0bHBFsmT
 otjaffawTnTx+FO5uT4fFSzjCLwMndNXzAUEuWiTko3WiWTknoVIHXrmhnMJCfVTijKnMoaB/UQ0r3fLkWNGAqfhGDQOiPz2RQ/XoO3vvE8FjmkIrCxbFkcCC1vTDPvIGRy3teLOYKalckZvSTtjT8sHMpbDSzmp7pJjlkdJWsMriELfkqNJ8QUEg6gdecEzE/UUcpJsy4ca0QR6YfLs1xcmcU5tOkDjSlY++vrSnY2kcARoeMTw8RECFKJ+8PiHhvgsf1In5zRgjFs9goci7ccOmkXlB6NNLsLMhNS+OE7365MS0616ENbJobBVNHeitAvKEJVqeaM9B8WvnpB5jqOPirfo3mphLoFnXMk/Uyqnf8ixeqLzj2JRvUn9UjaM3fqUI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nhat Pham <nphamcs@gmail.com>

An xswap entry is recorded but not charged at allocation.  Charge
memcg->swap when the entry takes a physical backend slot, in
xswap_backend_alloc(), and uncharge it when the backend is released.

memory.swap.current therefore still counts the pages that do reach the
disk, and memory.swap.max is still enforced on them.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 627f2cab8077..f848c6edc6e7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -79,6 +79,11 @@ static void xswap_free_phys_slot(struct swap_info_struct *si,
 static void xswap_release_slot_backend(struct swap_info_struct *si,
 				       struct swap_cluster_info *ci,
 				       unsigned int slot);
+static struct mem_cgroup *xswap_entry_memcg(struct swap_cluster_info *ci,
+					    unsigned long off);
+static void xswap_backend_uncharge(swp_entry_t entry, unsigned int nr);
+static void __xswap_backend_unlink(swp_entry_t entry, swp_entry_t phys,
+				   unsigned int order);
 
 static int xswap_create(int prio);
 static int xswap_destroy(int type);
@@ -3169,6 +3174,8 @@ static void xswap_release_slot_backend(struct swap_info_struct *si,
 	psi = swap_type_to_info(swp_type(phys));
 	if (psi)
 		xswap_free_phys_slot(psi, entry, phys);
+
+	xswap_backend_uncharge(entry, 1);
 }
 
 /*
@@ -4359,6 +4366,7 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg = NULL;
 	unsigned long nr = 1UL << order;
 	unsigned long off = swp_offset(entry);
 	swp_entry_t phys;
@@ -4369,6 +4377,21 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
 	if (!phys.val)
 		return phys;
 
+	/*
+	 * The xswap entry was only recorded at allocation, so charge the
+	 * physical swap here.  On failure, drop the physical run without
+	 * uncharging it.
+	 */
+	ci = swap_cluster_lock(si, off);
+	if (ci) {
+		memcg = xswap_entry_memcg(ci, off);
+		swap_cluster_unlock(ci);
+	}
+	if (mem_cgroup_swap_charge(memcg, nr)) {
+		__xswap_backend_unlink(entry, phys, order);
+		return (swp_entry_t){};
+	}
+
 	/* One IO reads a large folio, so its range has to be contiguous. */
 	VM_WARN_ON_ONCE(swp_offset(phys) % nr);
 	VM_WARN_ON_ONCE(off % SWAPFILE_CLUSTER + nr > SWAPFILE_CLUSTER);
@@ -4400,8 +4423,34 @@ swp_entry_t xswap_backend_alloc(swp_entry_t entry, unsigned int order)
 	return phys;
 }
 
-/* Undo xswap_backend_alloc(): the zswap copy is still in place. */
-void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
+/* The memcg that owns an xswap entry, pinned by its recorded ID. */
+static struct mem_cgroup *xswap_entry_memcg(struct swap_cluster_info *ci,
+					    unsigned long off)
+{
+	unsigned short id = __swap_cgroup_get(ci, off % SWAPFILE_CLUSTER);
+
+	return id ? mem_cgroup_from_private_id(id) : NULL;
+}
+
+static void xswap_backend_uncharge(swp_entry_t entry, unsigned int nr)
+{
+	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	struct swap_cluster_info *ci;
+	struct mem_cgroup *memcg = NULL;
+	unsigned long off = swp_offset(entry);
+
+	ci = swap_cluster_lock(si, off);
+	if (ci) {
+		memcg = xswap_entry_memcg(ci, off);
+		swap_cluster_unlock(ci);
+	}
+	if (memcg)
+		mem_cgroup_swap_uncharge(memcg, nr);
+}
+
+/* Drop the physical run and the reverse mapping, without any charging. */
+static void __xswap_backend_unlink(swp_entry_t entry, swp_entry_t phys,
+				   unsigned int order)
 {
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 	struct swap_info_struct *psi = swap_type_to_info(swp_type(phys));
@@ -4430,6 +4479,13 @@ void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
 	}
 }
 
+/* Undo xswap_backend_alloc(): the zswap copy is still in place. */
+void xswap_backend_free(swp_entry_t entry, swp_entry_t phys, unsigned int order)
+{
+	__xswap_backend_unlink(entry, phys, order);
+	xswap_backend_uncharge(entry, 1UL << order);
+}
+
 static int xswap_map_clusters(struct swap_info_struct *si,
 			      unsigned long start_idx, unsigned long nr)
 {
-- 
2.54.0


