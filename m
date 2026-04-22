Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51FEDF55811
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 11:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6086B0088; Wed, 22 Apr 2026 07:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 186D46B008A; Wed, 22 Apr 2026 07:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D366B008C; Wed, 22 Apr 2026 07:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDEEC6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:55:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99C56E0AEA
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:55:16 +0000 (UTC)
X-FDA: 84686036232.15.1FE6377
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id AF15A1C000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:55:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRdMFE2X;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776858914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVT6PUBvlrSlkgVNYnD4o+D0CyXq0iYQhuirtic4qzY=;
	b=vr8W/Ra6G81E3jJf+bXl9inH1lxFkA6JvxWnQIHoZBTqLWCGn3OFbr352MDps6L7lCaURl
	0j5m4sVGwLGKuvQss9QaRKULSgNLZBl0YY7hrMxjpwAcvEreg08wo+QdomtZNHKBMfzGon
	zNnKKZRPj39ENQKPTw1RyfKJfJ8MnI8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fRdMFE2X;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776858914; a=rsa-sha256;
	cv=none;
	b=O3u1R/OAzj7s1g+x8xYAX3ffscEx38Kj6O6yCDLnfpKhGHojon5/CTambQCfoGsCy1uO/R
	sYYV0MvPkVrBXF3w8shDKxvm3TU21CzRoGuqewJU5PKLbXnwtv4ALfsQbMVRYm2xoP4OQE
	E1VBkvxVc40d6zbWqRoAv+OXzk5uhMo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C02343923;
	Wed, 22 Apr 2026 11:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69895C19425;
	Wed, 22 Apr 2026 11:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776858913;
	bh=NJvKjIc3nDJaSnPBx7jL/EpOwFk0jj67nkap1w9Xvlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fRdMFE2X09fOjI8K3IqnzPuBh6O5Hq5hYxUkrp+S2czRWSKcpx9ivjikTv15rhz/r
	 3il9KkG42HH6ZO0gv0GiFEaX39A/IGlmBtJYPCks62D9U8xbYM2+tCIzBhL+l6toob
	 8OmrCJzO3STCgCzSbBlTGOq1FNPhWmWOSLFkzVQhb8aWxJ02dXfLJMSTixfBtw0kRc
	 Wzcl6NJGf6EV3dmMvyrGg2hK6aMN8luhvgIpL7kYN/AGnzvTS8ETdt3zGlxpOrAV99
	 l2d1275DZy4xnnPrCxcK1ali3JJKAi5FmjRRw/mQmrYBXdpdN0Fz1rKhvoGs/wmqeV
	 ZFVM34QrkWm0g==
Message-ID: <d0510c1f-4930-4424-97b1-b9c9028eddb5@kernel.org>
Date: Wed, 22 Apr 2026 13:55:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm, slab: add an optimistic
 __slab_try_return_freelist()
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org>
 <qfxtirtpoxcuzhnohm7cbo62z3ob3tiknlss6xenjlrjossmpu@pp4wwry3jad4>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <qfxtirtpoxcuzhnohm7cbo62z3ob3tiknlss6xenjlrjossmpu@pp4wwry3jad4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF15A1C000C
X-Stat-Signature: sbaaf8qpnseq6piyw3ctnxkhro3my8ny
X-Rspam-User: 
X-HE-Tag: 1776858914-226069
X-HE-Meta: U2FsdGVkX1/HA8hJUtxkdHZsKkS2dDLJiLCSwmN1YZfGYvSLlCepbnt2oa2cJg2sONEII+i/S42kQ1Mtiu1ZfkcWS0lilBKcCWUZGfWZwFK4pjI4IH3WS0Z0CwuOeXm3XCSl70zRkvq4ak0o5my3Dpl/EsYLP+PQiEgoR4BySuEHC7bCYyaB0XD0Bd+Z84VIlrxfB/kLNGwjmn8xtQ/N4oZD+Xv8JdO9arltF294wyO50OAMMgQ5iDal6iNffKTN2Iow64Nr378B+uCJF5ILisuzZxHPPpZLbPugUwzDZLYR1ixbLMEvvZJD19scU1KggdMSup+9UaJovoJG99mAhMeNgRHm9uVGh8YhBB58hdPs6UdnHo0Glu0CTrEKet+21hJQHKDpkAIG8vCNTMBGnuPf7hqAc4+tPKUyPPBLrEptTEEK7jmihuftvU9gOrgpJYvR7OW+iz4chzuK/aar4Wq/d2XbX7MDRDmmM09TNONXQj2fhjvjM+u8megYX/77HgsOnsIi0t3vOzQ9g3IxnGmMSM2Ur9PmZCstS2PNl6+3yXSXANLkXU5ldp/lX6c7a5aWv06J/TyrhmoGfNlgEDjWloyKktdM31XXjlrJPETuhpMKDk7gD4Yo94D+Pj8smSGjI2E0f91RxDs3/Crj52+do1k33Ml5tjJuEwRgGVMYuClnaJ8LlqBzJhhBNOss1LIfhtPiCx7FT5R82WtCJFSCRSijgR3qDXEH49D6icUXvDkBKKJr9Vxu69q6BPJwYqRHyTpOqFC0+3aSg7qVKAv5SlfgQMQLxm+67heAMPQrRFum6AtZm1ECW0h/3ufqDZ4N2aKSLDPklr95p87vqEESR+iTKK3NG+NFEMO3KHRX+FaPJeb0D17gAOJGkKgvGk8oZacIiYoB8JE+cGTmKPiZo93UrEJTEhJK8QFw9uccgpHONl2IggTT7q5SqUKjdr72iSlHA8CPXypA7BY
 5+9Rw8i1
 C1mJ1N7TZtQN6YEMRIwIZ6VCIqXPJr2Vtf2ZkHYcPQt8J7fQhmXYlm4EXcbnTaNRFC5KMi6aGjEc7DvuvR65UZOWtd0OansYbLRMM/GthTscrISJ6Pjpo1AqG+3kDCkYdijdKrgNA2XSufn5o47NL8tMpVqdAMnnlkhwf95WJI2XyiIrhaaRm7tMvGIuszURHwlRofDaIXmLskCF/Web2larf8OoKsEA+u5+e5GDYf/AG58O2OEM6Yd4GhEJk4YBahCUbKMJZvyuuO1zmrpiWUTIUxadMaXPniuAx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 09:09, Hao Li wrote:
> On Tue, Apr 21, 2026 at 04:49:52PM +0200, Vlastimil Babka (SUSE) wrote:
>> When we end up returning extraneous objects during refill to a slab
>> where we just did a get_freelist_nofreeze(), it is likely no other CPU
>> has freed objects to it meanwhile. We can then reattach the remainder of
>> the freelist without having to walk the (potentially cache cold)
>> freelist to to find its tail to connect slab->freelist to it.
> 
> this approach is clever!

Thanks!

> 
> I was just brainstorming a bit here: what if we only try calling
> slab_update_freelist without grabbing the lock or touching the partial list at
> all?
> Instead, we could just toss the slab right back into pc.slabs. That way,
> we can let the downstream logic for handling "leftover slabs" take care of this
> slab together. It could save us a whole lock/unlock pair.

Great suggestion, thanks! Indeed it should not be necessary to reattach the
freelist and return the slab to the partial list at the same moment, AFAICS.
Makes the code simpler. Here's a pre-v2:

From 6f56844b79fcca5d1dd4203b879af7daa11d09e5 Mon Sep 17 00:00:00 2001
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 21 Apr 2026 16:28:01 +0200
Subject: [PATCH RFC] mm, slab: add an optimistic __slab_try_return_freelist()

When we end up returning extraneous objects during refill to a slab
where we just did a get_freelist_nofreeze(), it is likely no other CPU
has freed objects to it meanwhile. We can then reattach the remainder of
the freelist without having to walk the (potentially cache cold)
freelist to to find its tail to connect slab->freelist to it.

Add a __slab_try_return_freelist() function that does that. As suggested
by Hao Li, it doesn't need to also return the slab to the partial list,
because there's code in __refill_objects_node() that already does that
for any slabs where we don't detach the freelist.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 35b6cd0efc3b..95e4289671b3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -373,6 +373,8 @@ enum stat_item {
 	SHEAF_PREFILL_OVERSIZE,	/* Allocation of oversize sheaf for prefill */
 	SHEAF_RETURN_FAST,	/* Sheaf return reattached spare sheaf */
 	SHEAF_RETURN_SLOW,	/* Sheaf return could not reattach spare */
+	REFILL_RETURN_FAST,
+	REFILL_RETURN_SLOW,
 	NR_SLUB_STAT_ITEMS
 };
 
@@ -4323,7 +4325,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
  * Assumes this is performed only for caches without debugging so we
  * don't need to worry about adding the slab to the full list.
  */
-static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab,
+					  unsigned int *count)
 {
 	struct freelist_counters old, new;
 
@@ -4339,6 +4342,7 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
 
 	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
 
+	*count = old.objects - old.inuse;
 	return old.freelist;
 }
 
@@ -5502,6 +5506,35 @@ static noinline void free_to_partial_list(
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
+	stat(s, REFILL_RETURN_FAST);
+	return true;
+}
+
 /*
  * Slow path handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
@@ -7113,34 +7146,42 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 
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
+			stat(s, REFILL_RETURN_SLOW);
 		}
 
 		if (refilled >= max)
@@ -9366,6 +9407,8 @@ STAT_ATTR(SHEAF_PREFILL_SLOW, sheaf_prefill_slow);
 STAT_ATTR(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize);
 STAT_ATTR(SHEAF_RETURN_FAST, sheaf_return_fast);
 STAT_ATTR(SHEAF_RETURN_SLOW, sheaf_return_slow);
+STAT_ATTR(REFILL_RETURN_FAST, refill_return_fast);
+STAT_ATTR(REFILL_RETURN_SLOW, refill_return_slow);
 #endif	/* CONFIG_SLUB_STATS */
 
 #ifdef CONFIG_KFENCE
@@ -9454,6 +9497,8 @@ static const struct attribute *const slab_attrs[] = {
 	&sheaf_prefill_oversize_attr.attr,
 	&sheaf_return_fast_attr.attr,
 	&sheaf_return_slow_attr.attr,
+	&refill_return_fast_attr.attr,
+	&refill_return_slow_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,
-- 
2.53.0



