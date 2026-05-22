Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD57CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285BD6B009D; Fri, 22 May 2026 10:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2639D6B00A5; Fri, 22 May 2026 10:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B9D6B00A6; Fri, 22 May 2026 10:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 04ECE6B009D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:23:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5E791618FF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:23:43 +0000 (UTC)
X-FDA: 84795274326.16.92C3A0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0CB9B10000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:23:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaWqHuSX;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4b73HeUFL1BJFb9tKUFnj3I3fQCi1XJtQNXmwPghYI8=;
	b=vMi6/Q542o1pz+JmCNLK/tiMzClk8x2LCVKE97rkuOj0NOMyxodNrkECFmk2ZHgy7D5kwg
	O5zMhxWqergDjStkzpbJaCrmRD/ja5actr26bcYp8n9e8+bJ76VFY612J4pQJNxIsvXSd9
	1QABkiidbbGhvSrF7Ru2ytt72u9Owkk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaWqHuSX;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459822; a=rsa-sha256;
	cv=none;
	b=LKVhIy7iuQe6sS2p/UKn5d3wcMFxt8GVymLo7tNLqGzxY05Yj2oeEFypy3b8XY/enfXoLp
	JZkP5d4hMq5Yywlm0C5YWAusKmS9QDyU0ONRk/YwhIFe7xi2/zBMPLQCQA5Nu4iwJagHvJ
	MQeqVtmOCWRcHXnFNJvuEmbr6QNN/p4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 378AF40725;
	Fri, 22 May 2026 14:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D471F00A3D;
	Fri, 22 May 2026 14:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779459821;
	bh=4b73HeUFL1BJFb9tKUFnj3I3fQCi1XJtQNXmwPghYI8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IaWqHuSXUgpMe4/lDFIwXOEhByFwpTQJaGOyoVuTTXq7iBljnkVbkJHrK3k1w1z8a
	 iWq1g9DpzaWmI8n5ccngszzrJqVorI6HR8jmW0wmeDAMfMu3rO8d+QFbcbZwbbYap7
	 MZYSPhnjKzv2J6o2oA1R2rsn+ob2bQdl4Od5BvSDe87J+19Ke/4pngaa+9xZ3Hh6yS
	 nkOMARNQXcCIGZyVXflVbpThl6fFscdog6OXvf64ecEJvNNJIi6dgfsA6MWA3PgLaP
	 30jl0Zrrvyngu8BjJh4T52YzUbi6H/TyRO5aMRfjXxiaqps/bFyAizuyxsT3okgZRG
	 gZJwDS9T7TjaQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 22 May 2026 16:23:20 +0200
Subject: [PATCH v3 1/2] mm, slab: add an optimistic
 __slab_try_return_freelist()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-b4-refill-optimistic-return-v3-1-2ba78ec1c6ed@kernel.org>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
In-Reply-To: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5302; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=4r4E8fF8xlQ2gCDGhw11J9DZ3L6ugESsDuH1k5p0Uwc=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWQJpD1Ku5u7zqSOO09x126BR3/k6jPvtQpVcZWV93Z53
 8pv8VDtZPRnYWDkYLAUU2Sp3n3CUXSmssc0D9+PMINYmUCmSIs0MAABCwNfbmJeqZGOkZ6ptqGe
 IZChY8TAxSkAU13Syv6/4MLRy/3pejvmnVy5gF2SZeaR2Oov/Tvu+9jnrTHSyJeyNHETbPoYe6n
 xkY7Pu7X8U46lLc7XDhFVLH5/XH3hJxUfccG2cr64+SULO5cIM8zj8eb4EHxFl2H7ggqmaZzsWX
 n3rLbZRy0+vLNV1DKUZQ/LTd7+OaqiZ1UKeVyvBy7NvOCdt+HXikOHw/ZUxkjlPHyhv4NPYEEQr
 7Kf9/y98w4Hv1op7VN9Sz5lI+8GqTeCt6ZcL/V8+rpUxNNX++65r5sjlj9SWbLnsMi3rn/R2YnP
 +5mlCmOniqXE8iycmHB0laOCCUPxY2bxAoXFEe9vKXQkCF/tOi519My785omRfuPlG1LkAk+cOB
 /yEQA
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: p1z3611qpo9ie87ia4yg9ajeqo5xcp97
X-Rspamd-Queue-Id: 0CB9B10000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779459821-489413
X-HE-Meta: U2FsdGVkX1+Jkbp8xDvQldgMy3SQyud01ujlBTpzVcM3pKGFfaP/dxUOXWmgl/x+sv5ZwwQ7HiwD3+W9Tr5N43nd8uTGrQ0PYyO9MSso8sTcmuv5xWRERIjjSTDER5+M//8nDJy1eB3PXHHQWdQZo4MINGjtF801EsCbBgp2UIvgy1ASwFXmA1mPWFa2BSGvPdZamLCp93HAgnAHQ4Tx7cGQ+D5Si92K74aEB6ne5Ky1PyBeEXY3OKsIp5wbNHN2NrFUEmPm0jNoYLjWMB93VFdm8hwjjpytg7h5O1/pmvp47U6w5Hk79B5iCdnK7LslnGCdlAvAgGIo3LfS5uh+w/omoTdxuQ3tdooK5pmd0bGSe6JVCEfbimy+XPwhRm93iRatimei92Ed9dxolwle8X+WGJQ2ohXjs2WB3FXgi9zLeQNz2b2KgXXvimQznnOKCMHtEzidBqc1Ga2OWw2QnADkZi0lqvldcFQACcNgLg4tiq6gXDEn1rb8DAp+v/dsXLSl/uXy2dAUqzwiQp6mFDzycBRaMtK5IHNAPgLnf8ag0EwnCnVzslYsl1+e3NdUlnvM8O4K7XNAuMyXT4Dv5OMZxAfquU9fONq0egGMmBr5ptHuHLhVXvPXjdNrVO9lvnBb3mFaY/4I0Hz5cqCTwupsK74/9gxRD10y2EvexeDfBZmLhaoi5ymrOEAcYWbS7aJjZpio91ZUjw69ffN1Yw79RcSasUY11QR3PKvFb7JKd09PuyBhjRvJ+y+q5GpajjQmq4jIfKijki4cMlR9g/Px3WLFkh3xpu7XBPehKZeQvqX3lpyrLnYjdvxoHtfuXCsIiPvwjVbaSqpFq2p+xM8K6e4C4c/U9hZRX/kG/nI+jGeNCa3M6XVKHs99+cn1MpHfMUmbJLZoD4ZMjzxF0G7yQj+6c8MHxvNMBx5f1stH51tXdZjXG7dixHc8M6ftJJ/ZFZaLGy/IWOYwQPm
 dfGClOh6
 gGX9SOxeNDvPgWh2XHQZDbrSuvL7+cf7n+Od4h7t09h0152cJQ9DQjMpSmEMT4NaLjzjxP1Z0KU+a5N90khyRvVRE/qCK9MIPyPX84w4lQovt0TwLCU4kppVNjj7OuAMV4GGj30tpXqy+wXV42/EGWinYLzhWd1mpgKyPHZ7yX4En7KW0/Jh1YDGjFXq/TcdZreSEDhswFvecy+fpLARoVSEptInX+zN/Wy0ccqmnWPYNfziHniDwDJD4aMyi6LPAyb8FNSlTKG6Ljl8Ga5BEBCPQcQjPJ16n9wJY58zJNNzWtnhy9RCE7B9KDQ==
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
for any slabs where we don't detach the freelist in the first place. So
we just put the slab back to the pc.slabs list. It's no longer likely
that the list will be empty now, so remove the unlikely() annotation.

However, also change that code to add to the tail of the partial list
instead of head to match what __slab_free() did and avoid a regression,
that was reported for the earlier version by the kernel test robot [1].
This change will also affect slabs which were grabbed from the partial
list and not refilled from even partially, but those should be much more
rare than a partial refill.

[1] https://lore.kernel.org/all/202605112204.9382cecf-lkp@intel.com/

Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 11 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a7bd929bcb26..5816fcfc7a90 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4326,7 +4326,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
  * Assumes this is performed only for caches without debugging so we
  * don't need to worry about adding the slab to the full list.
  */
-static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab,
+					  unsigned int *count)
 {
 	struct freelist_counters old, new;
 
@@ -4342,6 +4343,7 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
 
 	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
 
+	*count = old.objects - old.inuse;
 	return old.freelist;
 }
 
@@ -5509,6 +5511,34 @@ static noinline void free_to_partial_list(
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
@@ -7120,41 +7150,48 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 
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
 			break;
 	}
 
-	if (unlikely(!list_empty(&pc.slabs))) {
+	if (!list_empty(&pc.slabs)) {
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
@@ -7163,7 +7200,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 				continue;
 
 			list_del(&slab->slab_list);
-			add_partial(n, slab, ADD_TO_HEAD);
+			add_partial(n, slab, ADD_TO_TAIL);
 		}
 
 		spin_unlock_irqrestore(&n->list_lock, flags);

-- 
2.54.0


