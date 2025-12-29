Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F87FE8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 12:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439646B0088; Mon, 29 Dec 2025 07:25:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E02C6B0089; Mon, 29 Dec 2025 07:25:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBCB6B008A; Mon, 29 Dec 2025 07:25:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C70D6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:25:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF1E559CC4
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:25:07 +0000 (UTC)
X-FDA: 84272428254.09.0E2D016
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id CC5B0A0003
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 12:25:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fgRPatP5;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767011106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rgD96VXLpwPca73tk8XcXo8AuLjoIr0us/dYXAVju8I=;
	b=zciuvOdDUGFg3U95PXIFu3ZOi3+oo6Ql89+Z/1ivSMZQIlPvZY7HN/XEbtIrN/VJMCyH4C
	CwO2oFVAfUQFyIGqoEMRgbPnSramwEJ9UUXWVd85b2Ev3sdEymSTwlayoNNYkaZo9yYmMs
	ejh37SfzjhpCD+G3J5VQifiRZMmFEb4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fgRPatP5;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767011106; a=rsa-sha256;
	cv=none;
	b=3cw0WUV03G//LPdZCyjym3oERzSgMulIdGh1Nc3PozUqvEXXHAU8WUd/r56UqS5D+f0zIU
	r44kHR0by6WnaYvclyZtqjBpFRzZvGqhum/2kBA5Eg8U1kk/0jKKJUcUXkt9ML/9SWsPef
	+wZubG7YRo2o6ClHkAHjevt9nDjyNew=
Date: Mon, 29 Dec 2025 20:24:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767011103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=rgD96VXLpwPca73tk8XcXo8AuLjoIr0us/dYXAVju8I=;
	b=fgRPatP5VKCbyIM9xkP9bbGPhYmZYLjlEp2Dl61XOrRtgEixli4mCxGdHcTCzbFgnGtU8h
	mWo4UghuiuNUo1Y40HSQUB5dxgNFNW13tWBTkoT1a+T7eYZhEXJ5XoTyaDrhlgHvp8G3/C
	GMqEFZSXcws4CC2UkxGZhG5tbAdYCIY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: vbabka@suse.cz, akpm@linux-foundation.org, harry.yoo@oracle.com, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, hao.li@linux.dev
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>
Subject: [PATCH v2] slub: clarify object field layout comments
Message-ID: <20251229122415.192377-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: id5r9s6oow9cohpbd8qe7yjb9u1gjtk5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CC5B0A0003
X-HE-Tag: 1767011105-164652
X-HE-Meta: U2FsdGVkX18xemJA/B59IvDO2RUp7I+VPS1UKSG8nzBKG2EYCt0fbjFt79xBDwdWDB17MecT8Ez4Vj4qBeNyrXBfnuAW6Iths7x1HN9+ia9oEZysSCBUSR7A0riF1RGV0kWnqlj9YNNmVJoT4kxOR/F5N+24mGJ+rZnMugFnCKuxmQqsUadtNo+zRYAI5MXUocM2JnB5LsnRODGVancfSJWjqjnPx++FLBYtXCNXJGY7s5UISKM5wh18l86CZ6quIeQJsOU/DLLhc2cY6UTuBBPaB/xzG5X+Fi5WT+S435BPY8t1EZwya2Runm6ex1VjS7acPWfkoOTMo186pPDN1ZFLVKkaRSu8TkuaEEozL/+o5uexxhtq9ajnwqmKZP02iKKAkjfEbUj/wJ8TeYLSa4QBRb7PTuMqD2UsJqmU+6GpPd03kbU2hc0/4/OfYPjIf9PmJ++/NAA5DNGJRVrxN1UX+Ku6l4o1M0vLgPbw6IbHUuvc7oEIrzw4V9iRVbnaX5mRL6/es6/WqEx5KBtXyvAzp9Y1MpkKD09GlxUUpvPXaI6P7CPPs0pSd3zIZpOkUK9XoiNpa2WFAi7TUYuI+jGCTD7F5DMdDYsr4SiqX2Tl/JU75ITYFXAfgPeAPFxY8FgVAJWzIHVMc0XA3JsrwRyVMm65cRSudkPx02Js6C1vGt4z55N60UTFtAgnXIxBLx9zQw4MTvu8r8bXWyQuII7xfIU71p2rNTz36CUIoLcXMVwLsrHJI2mzIPnASvTtfQrsb8Kghc4a0AsjQMfy6CFISUGpUz0o5OyDACyQENNAnP6QUGO5vC2P2tOc6ImQg1hz46ilOxHHjyrhPYn9TmtmKbeTYxIiDRDHE+38LhEKFkgEg7tuM1tboak4v4uOQZnwZko+nhC5c54niQ5n7TKQ+sd0xPMgDCZpQRcVop8zktsgbbQVDgidNYWAkeshxgMI4+wSSoB0mUO8n7G
 T4lwPdER
 DJcfTl/VdBWwRZq8UeRuDBVcqIPOmIWZSmvxiurZjW/Ne+4+Je+Pzqqi55b7Qq6ESkFHFaKST0gEfT10ckm7n2rSWmW6Uph724XqDnCHkkYPC6FH1EBijjRbGP5Jek21hI22HnXpFsVt6BblXkfkN+sKP4Nq9lloXuFL5tJcnQRRgo4CZVtf7W+Ye79aALnY9Tyx9rNcoad+GVx9cV6QSJtqxc/8b89TUr4PMJGwFPlQeFaSQNxE/8AdKVgCcj2jX1zGbatnUUMH16ym3JjGXSeIVrDyhiyQglzCO5OQbiTEM+AIyjzX3G9ytgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comments above check_pad_bytes() document the field layout of a
single object. Rewrite them to improve clarity and precision.

Also update an outdated comment in calculate_sizes().

Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Hao Li <hao.li@linux.dev>
---
Changes from v1:
[Left redzone padding]: Clarify that the left redzone immediately
precedes each object.
[Object bytes]: Clarify that the object starts at the address immediately
after the left redzone.

 mm/slub.c | 96 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 40 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..fa08c932db70 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1211,44 +1211,60 @@ check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
 }
 
 /*
- * Object layout:
- *
- * object address
- * 	Bytes of the object to be managed.
- * 	If the freepointer may overlay the object then the free
- *	pointer is at the middle of the object.
- *
- * 	Poisoning uses 0x6b (POISON_FREE) and the last byte is
- * 	0xa5 (POISON_END)
- *
- * object + s->object_size
- * 	Padding to reach word boundary. This is also used for Redzoning.
- * 	Padding is extended by another word if Redzoning is enabled and
- * 	object_size == inuse.
- *
- * 	We fill with 0xbb (SLUB_RED_INACTIVE) for inactive objects and with
- * 	0xcc (SLUB_RED_ACTIVE) for objects in use.
- *
- * object + s->inuse
- * 	Meta data starts here.
- *
- * 	A. Free pointer (if we cannot overwrite object on free)
- * 	B. Tracking data for SLAB_STORE_USER
- *	C. Original request size for kmalloc object (SLAB_STORE_USER enabled)
- *	D. Padding to reach required alignment boundary or at minimum
- * 		one word if debugging is on to be able to detect writes
- * 		before the word boundary.
- *
- *	Padding is done using 0x5a (POISON_INUSE)
- *
- * object + s->size
- * 	Nothing is used beyond s->size.
- *
- * If slabcaches are merged then the object_size and inuse boundaries are mostly
- * ignored. And therefore no slab options that rely on these boundaries
- * may be used with merged slabcaches.
+ * Object field layout:
+ *
+ * [Left redzone padding] (if SLAB_RED_ZONE)
+ *   - Field size: s->red_left_pad
+ *   - Immediately precedes each object when SLAB_RED_ZONE is set.
+ *   - Filled with 0xbb (SLUB_RED_INACTIVE) for inactive objects and
+ *     0xcc (SLUB_RED_ACTIVE) for objects in use when SLAB_RED_ZONE.
+ *
+ * [Object bytes] (object address starts here)
+ *   - Field size: s->object_size
+ *   - Object payload bytes.
+ *   - If the freepointer may overlap the object, it is stored inside
+ *     the object (typically near the middle).
+ *   - Poisoning uses 0x6b (POISON_FREE) and the last byte is
+ *     0xa5 (POISON_END) when __OBJECT_POISON is enabled.
+ *
+ * [Word-align padding] (right redzone when SLAB_RED_ZONE is set)
+ *   - Field size: s->inuse - s->object_size
+ *   - If redzoning is enabled and ALIGN(size, sizeof(void *)) adds no
+ *     padding, explicitly extend by one word so the right redzone is
+ *     non-empty.
+ *   - Filled with 0xbb (SLUB_RED_INACTIVE) for inactive objects and
+ *     0xcc (SLUB_RED_ACTIVE) for objects in use when SLAB_RED_ZONE.
+ *
+ * [Metadata starts at object + s->inuse]
+ *   - A. freelist pointer (if freeptr_outside_object)
+ *   - B. alloc tracking (SLAB_STORE_USER)
+ *   - C. free tracking (SLAB_STORE_USER)
+ *   - D. original request size (SLAB_KMALLOC && SLAB_STORE_USER)
+ *   - E. KASAN metadata (if enabled)
+ *
+ * [Mandatory padding] (if CONFIG_SLUB_DEBUG && SLAB_RED_ZONE)
+ *   - One mandatory debug word to guarantee a minimum poisoned gap
+ *     between metadata and the next object, independent of alignment.
+ *   - Filled with 0x5a (POISON_INUSE) when SLAB_POISON is set.
+ * [Final alignment padding]
+ *   - Any bytes added by ALIGN(size, s->align) to reach s->size.
+ *   - Filled with 0x5a (POISON_INUSE) when SLAB_POISON is set.
+ *
+ * Notes:
+ * - Redzones are filled by init_object() with SLUB_RED_ACTIVE/INACTIVE.
+ * - Object contents are poisoned with POISON_FREE/END when __OBJECT_POISON.
+ * - The trailing padding is pre-filled with POISON_INUSE by
+ *   setup_slab_debug() when SLAB_POISON is set, and is validated by
+ *   check_pad_bytes().
+ * - The first object pointer is slab_address(slab) +
+ *   (s->red_left_pad if redzoning); subsequent objects are reached by
+ *   adding s->size each time.
+ *
+ * If a slab cache flag relies on specific metadata to exist at a fixed
+ * offset, the flag must be included in SLAB_NEVER_MERGE to prevent merging.
+ * Otherwise, the cache would misbehave as s->object_size and s->inuse are
+ * adjusted during cache merging (see __kmem_cache_alias()).
  */
-
 static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 {
 	unsigned long off = get_info_end(s);	/* The end of info */
@@ -7103,9 +7119,9 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 
 
 	/*
-	 * If we are Redzoning then check if there is some space between the
-	 * end of the object and the free pointer. If not then add an
-	 * additional word to have some bytes to store Redzone information.
+	 * If we are Redzoning and there is no space between the end of the
+	 * object and the following fields, add one word so the right Redzone
+	 * is non-empty.
 	 */
 	if ((flags & SLAB_RED_ZONE) && size == s->object_size)
 		size += sizeof(void *);
-- 
2.50.1


