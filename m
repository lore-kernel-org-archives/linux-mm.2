Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFF43FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E41E6B0005; Mon, 27 Apr 2026 05:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA7E6B0088; Mon, 27 Apr 2026 05:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7996B008A; Mon, 27 Apr 2026 05:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F37A26B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:43:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B2D41205BD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:43:24 +0000 (UTC)
X-FDA: 84703847928.05.5F9C2F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE31F140003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:43:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k74S5hzf;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777283002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R3JpP4lu9ceK7UdgoK6uOSVjfE3i0xWPKgaPktgLFLY=;
	b=lAWx+p8bSCFRZeSmD7fiua4a2v0R57Iojc47TJDKnwycJqD7jEGuvYS2Xk01T0/hK8mjJk
	HRa9nmFpgPhNpT7RP1OHu3KRgVsYbf8pbJQvGTVLY5kJGLB714/pezt/oMwSAxq2T/LEGL
	2sBzBWbHEL/0aKMN7XFZYfFYwOI3xC4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k74S5hzf;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777283002; a=rsa-sha256;
	cv=none;
	b=eD5jfQN4bEtNmlBVWrLj39xuS/SeW50y4P9FyVjGVSfJ+fkolguFFgap6xQoXCO8DtxMkh
	6557Eo7MeVpPP+CNybE6wDA1Yo24FuCrH2/CzsOlVHqV/MR9gKJ/6/HvvEjmss2omqg0Rg
	O+UM/UXokus/+jx7W0xxJ6b8dZ+we+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6D3941679;
	Mon, 27 Apr 2026 09:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E88AC19425;
	Mon, 27 Apr 2026 09:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777283001;
	bh=uYDUaTJzF/pUuA6b7DSfsIRpVqOMe/C6UQqNO2jGuWw=;
	h=From:Date:Subject:To:Cc:From;
	b=k74S5hzfzxe+HjkPTufokzY8q2dcT2d7XHQRY7GqrllYqWu7VQ8xJkm0fOTlX/J92
	 Wvx9wF6mVz/AzCfOJaNtG8GJ+QZTjanV1cX1+TifmDM2adPzjpB3ztZPZNk95KGSx1
	 ZK1twQ+v9TSBP+ojv1Nv/0k84tfIcxkPU4mBnT1ErMFC/v6y7TSXBjMcjcvqbsJdiO
	 Z3ycfSTHSAftyBS8+6+Tn2g8SyfGVC8vc4FU0tv2jPwPis9diTArhIuJKrOCN0NxK7
	 8Fd+H2SGgl6/bcQlLRWDtWDbjzyrdWr2SAjZ7++7980AY0PW7uya+aXk+XH2gFnXoY
	 rU+wqqrGQoAnw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Apr 2026 11:42:57 +0200
Subject: [PATCH RFC v2] mm, slab: add an optimistic
 __slab_try_return_freelist()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260427-b4-refill-optimistic-return-v2-1-1672467a792d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKAv72kC/42OQQrCMBREr1L+2kgTg6IrQfAAbqWLJv1pv8akJ
 GlRSu9uWi/gcobHm5kgYiCMcComCDhSJO9yEJsCdFe7Fhk1OYMoxb6UgjMlWUBD1jLfJ3pRTKR
 zk4bgmJGy2amD1FoeIRv6hXyv9jvcrheofmUc1AN1WrwL1mWJD5/1w8hX+K+5kTPOhDSlMprX2
 pjzE4NDu/WhhWqe5y97yE423gAAAA==
X-Change-ID: 20260421-b4-refill-optimistic-return-f44d3b74cc49
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5215; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=uYDUaTJzF/pUuA6b7DSfsIRpVqOMe/C6UQqNO2jGuWw=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWS+19/8V6P/v7fE0gNmEe5JGRc17B4eOZwuci9Kv+fDn
 DeGt05WdTL6szAwcjBYiimyVO8+4Sg6U9ljmofvR5hBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKnea8r+v8DC0NWwI2z+ys8VmVfkRYTLqvtKjz1WS7s/2U9Xau+blRNKjunoJ0S
 JZrsarTy5o8D//5d3z/cLby4J3S7b/zWMK6NtRq/NOtm9rnsnXLabfuOuYWagsvN9gxV8C342FZ
 ZwL5b4GrHDJcLr4v2TrJen35vy+MPZk3EJ6R1Lpt1zUtm+UvbClmIN/8tzprruui1YcyMoc+equ
 dGT70ZIXN97onRlL/+Ry8XL5/KvnuFjJ3xLi+VZ6PWyxovnox5f6vWUq/+c7NYQdbEtbneMeOvJ
 N3uPhT/qm6XpOfn3o20Zos8OBjtvKInzXjj3shjzbXa3vH37w1XYFSRWhR1ZXXRRtbiCUTa156W
 q17XnPQA=
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE31F140003
X-Stat-Signature: rzsb86jkkddoxy77btaq5zm4aear3tyo
X-HE-Tag: 1777283002-420370
X-HE-Meta: U2FsdGVkX19jeEMNicrlAyndzqVKbycuRUutWA6b8nBA8j8F/F3xM/svM7a6tM1DVXWIbT/yL/wDMnN3uoqN8RXYu1kT3pItk11LzrbxujXxiTquBW0kHciaE6wcMK0dxjKON0j3GWQsmytEk6OY0QTHjUrjWvfpGpqEdEGV682yxBflN8BpbFIwUYJx8rBhNUZtNSbz7Z1ZYcF/D9aXTpCntoqShyPgwT4XgEvGJ8Ywbw7WPB/4XPv9mA48AJYJEDOmzg5d1JNfXqQx70pvSNG/uHRNt07PG4OFr6QDcx5fjdx7pVlt6VLmWt4SXdopOZsCZo09EQeUeuJa6q5cd3KvEFSvYGJLSqEx+/SVttfcy+Tung6aQk9xp5QYKFJAHf53KPJOOwHB4FWWnyNCovmsjkI5WFsgWxEpdkfub2hYYxeXdNWMjpfbpqZ4i6xaECdnFdgcqAZeKTWN9fJ1jEa6doSIwB3WePF4UFKaNw35rNyhBNILPg9H8MFWjI8wwp8AYcKdzqQZo1mhNjjYulYO/yJB+qwkOjxU0fug1F0rk3w/DHZPJqG+k4OkSU/I4rNRfGA2EsjtT25fk6LJkpVCemYT/vgNTrXARQaK5+sxzRs9BrzGb6MnbwosDJyYRVaFgfdCwgGGTrWQADqpe5ZNsqM7fVjwC0AiQ++fBBbZ/teZp6tUL6v3hv6n0vhKo3/koKMN5H7OA9A0PxP31lRnZU+wuPAgfjvyc+3IOx3PjKpzgOXe4YEYmdUJkIrVxW5L1J1Kr3BF/cuprvWakQrT0QsDV9xyQmlj4X0w6fj8z1PXyeJiWXDBed3ThqxCPvRmDEiET+35zuaArMLkDwbtg3lvYUMa4iV0BHcz1cCR3/+ehnfpZMBBEbqAntChLetQOJ4SRq3452ZEImNuM8E6jaCpFaXWTuVZyW6z7S+4LTfJlmO6wqGFG5so0ieClozOSqRCZ7WnN8GHJvF
 OzR+L+GQ
 FZ1EtEwzjXAbwTODvefCX/vCVWu4MWyObZw1mgGhP+RsUB1fmuf5Dr/YYSWQgFyzPkHOSlcSQu9+fIiPUYO4hpc63JRjVLdvPV5medps596+cEqECj2ykDF8ZxOe4QXnikXsIFTvPFYT/2CTi52v21b3OiTtzQFrvRH1IDF1NK47fynL/NRdmY4Wgm9cECjLqRNxVjVUXm+aqMFRl8s2z9At5IWJJArhIf3/EYIAewDzKEOYKqKkgR7UlUt6xxCQmSuRPaMmumWdctiAmSvlWMbFxXBbnnIhTYpKJbd92NORjqJzsP+Sn+KqlKLgd/Pm4sOiGc+1iJFGKcZuhy9iTu/apR2jM85rGSYqdx4L0GIA2Zi+1+xyR3Gr62w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we end up returning extraneous objects during refill to a slab
where we just did a get_freelist_nofreeze(), it is likely no other CPU
has freed objects to it meanwhile. We can then reattach the remainder of
the freelist without having to walk the (potentially cache cold)
freelist for finding its tail to connect slab->freelist to it.

Add a __slab_try_return_freelist() function that does that. As suggested
by Hao Li, it doesn't need to also return the slab to the partial list,
because there's code in __refill_objects_node() that already does that
for any slabs where we don't detach the freelist in the first place.

Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Optimizes the current refill leftover handling in a way that should have
no downsides, so we have a better baseline for any further changes (e.g.
spilling or caching the leftover) that involve some tradeoffs.

Git version here:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/refill-optimistic-return

It's based on slab/for-7.2/perf with "mm/slub: defer freelist
construction until after bulk allocation from a new slab".
---
Changes in v2:
- rebase to slab/for-7.2/perf, drop RFC
- simplify to reuse the existing reattaching to partial list (Hao Li)
- Add R-b from Hao Li, thanks!
- drop the stat items - they serverd to verify the optimistic path was
  succeeding, but are too detailed for mainline
- Link to v1: https://patch.msgid.link/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org
---
 mm/slub.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3c4843834147..c770374490dd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4323,7 +4323,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
  * Assumes this is performed only for caches without debugging so we
  * don't need to worry about adding the slab to the full list.
  */
-static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab,
+					  unsigned int *count)
 {
 	struct freelist_counters old, new;
 
@@ -4339,6 +4340,7 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
 
 	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
 
+	*count = old.objects - old.inuse;
 	return old.freelist;
 }
 
@@ -5502,6 +5504,34 @@ static noinline void free_to_partial_list(
 	}
 }
 
+/*
+ * Try returning (remainder of) the freelist that we just detached from the
+ * slab.  Optimistically assume the slab is still full, so we don't need to find
+ * the tail of the detached freelist.
+ *
+ * Fail if the slab isn't full anymore due to a cocurrent free.
+ */
+static bool __slab_try_return_freelist(struct kmem_cache *s, struct slab *slab,
+				       void *head, int cnt)
+{
+	struct freelist_counters old, new;
+
+	old.freelist = slab->freelist;
+	old.counters = slab->counters;
+
+	if (old.freelist)
+		return false;
+
+	new.freelist = head;
+	new.counters = old.counters;
+	new.inuse -= cnt;
+
+	if (!slab_update_freelist(s, slab, &old, &new, "__slab_try_return_freelist"))
+		return false;
+
+	return true;
+}
+
 /*
  * Slow path handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
@@ -7113,34 +7143,41 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 
 	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
 
+		unsigned int count;
+
 		list_del(&slab->slab_list);
 
-		object = get_freelist_nofreeze(s, slab);
+		object = get_freelist_nofreeze(s, slab, &count);
 
-		while (object && refilled < max) {
+		while (count && refilled < max) {
 			p[refilled] = object;
 			object = get_freepointer(s, object);
 			maybe_wipe_obj_freeptr(s, p[refilled]);
 
 			refilled++;
+			count--;
 		}
 
 		/*
 		 * Freelist had more objects than we can accommodate, we need to
-		 * free them back. We can treat it like a detached freelist, just
-		 * need to find the tail object.
+		 * free them back. First we try to be optimistic and assume the
+		 * slab is stil full since we just detached its freelist.
+		 * Otherwise we must need to find the tail object.
 		 */
-		if (unlikely(object)) {
+		if (unlikely(count)) {
 			void *head = object;
 			void *tail;
-			int cnt = 0;
+
+			if (__slab_try_return_freelist(s, slab, head, count)) {
+				list_add(&slab->slab_list, &pc.slabs);
+				break;
+			}
 
 			do {
 				tail = object;
-				cnt++;
 				object = get_freepointer(s, object);
 			} while (object);
-			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
+			__slab_free(s, slab, head, tail, count, _RET_IP_);
 		}
 
 		if (refilled >= max)

---
base-commit: 8952728641305ebcd03e80f79b8d31bb41d6d95f
change-id: 20260421-b4-refill-optimistic-return-f44d3b74cc49

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>


