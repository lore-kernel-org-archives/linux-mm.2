Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B7EE75452
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 12:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655036B0005; Wed, 24 Dec 2025 07:51:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 602836B0088; Wed, 24 Dec 2025 07:51:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50ED96B008A; Wed, 24 Dec 2025 07:51:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E39A6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:51:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E68F2B6D4A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:51:49 +0000 (UTC)
X-FDA: 84254351538.16.9893C3C
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1227420004
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:51:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EteAKAVd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766580708; a=rsa-sha256;
	cv=none;
	b=PguJ5QEA3vdga6AyaHx0YggVuhQYga11u/EoHkygp9hSkBoocuzUijWhuWkHXzu+GvLNbO
	10ZCRSQibZjZ3V9KUCy6g12l+Jf0BLRyQoyLOLVaclUI3TS0SNLEn0dJcJRZHknkhKlBy/
	O09dh/AiW9Nhh3w+zHX2onGReKQ2lh0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EteAKAVd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766580708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRieSzag4iGvTpHtsvUWdbRPgpJbX/fu/qtI6sKweRY=;
	b=7fsMRvryXFBLFYCH9UA+6ilXhLfgpzWeJuykPCiJGZGSJhQCrzFwZkyR03mwwBQ2ElKL7O
	axlXFaa/DMnSGA56mJsmGBheNXH+WEbBGUgO2j+Bj2b9EhSLDYs8R7B93jizTE8J7Vikv2
	ea4RdjGVbuN1OvnItNIAt5EgmXiTox8=
Date: Wed, 24 Dec 2025 20:51:14 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766580706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CRieSzag4iGvTpHtsvUWdbRPgpJbX/fu/qtI6sKweRY=;
	b=EteAKAVdI7AaeZsXkJZGXiC3GWcpQiwTLbqswnYduANuzhfYdjxwZQKi4oP+gB4Vzitol2
	O7KMR4XxCVMZTxVGxznHE21MLxneFymlmh1m7rJjkbAK7KljziRMR7WY7Rv+DtYOsLt8e7
	fijf2EakFJ1TPwarLAZkgATZvprtb+U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@gentwo.org, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, 
	surenb@google.com, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: [PATCH] slub: clarify object field layout comments
Message-ID: <z7d52kjvlzxohbly42flhtebqc7knfvilierrjr4r5776rxhgy@lcqmkcpzklse>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
 <20251222110843.980347-8-harry.yoo@oracle.com>
 <graryni6wadpi3ytfq7zimj2kbmm7dumxvhxtzmxndrv5s2y67@ju4cdnsmos6e>
 <aUq1x_BowqYpHZAQ@hyeyoo>
 <zex6wgdlxk5vgwm7ou657fdmi27xnxihdndlszfa2chghamfuz@grhtfqw7gm7o>
 <aUrCXYdziRWP9PfV@hyeyoo>
 <c6owr44jdncf7q5zqgq4wn4pm57ai4cd3upauwmwszopuddf5g@52mkqbe2m27j>
 <aUt_1uDe05diks7b@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUt_1uDe05diks7b@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1227420004
X-Stat-Signature: 6mukx1o7ox4a978qu4m5hgzyyhwwtzgt
X-Rspam-User: 
X-HE-Tag: 1766580707-494811
X-HE-Meta: U2FsdGVkX18pAFUkaIZS0cHlnGpFC6f6o1t1GWiUoqB0sLd0vcZJo82M5LItrlXDxbTzCztghEpEQB/4iuFSqVOu80RdAEemIdrKMkXt4FNwQKTogn8Sz55qmBFszxvOQ48kaGHHoK1AOcWUasak9qXq9p6VUXuVwoNj/HZs6H285dkak9xhzddxcyVZ4TdsF+44oIkEp9jYmLzB9apk6Aqr1TIASFUYiY91gQ17tSn1WZFgFaCk79VEVQvMyd2KQzmM2TQWRdRNempcVlfat2t+4fXLe7baRCxlvG45r/9iHU6aXkcej7AB7dLbV4rDJodQYAW2YOJKBJ44JIO9fuRHx1l1gRsWNJKuvcaaw+/8JC1rU9MGVxcuaOm25THb6fDsRWrPFOHi+AadiY1blGSKF2NMqcrIwrn8znwgqCz+9MpgxYUTJZoFo8UXSf5zkZnEK25Ehgl6l9vSq06mWRBWd2MtDvvbCuHXrm57BIkdLDz3I1AeO2lPVmNzrDTK3PLVC+bRsUPNh/CIYL6hrXHx3/lo3BtC78TH6CpwhLGYjbPnD1xxr3EYShvb+pN8gLstg7vMQPP9H1KlmvXYX/lElhUpO4KEY1DkcezOkyDzpEvvdFHQFUPO3UrCghuOWpIfJgPxXCS8QzoQfeV5hf2UyK93ZfuB1+w+XG4rwZab69Q7pDDQrWay9kyheHV0sKZCOD4XwXIOzTbb48iKqcBGPKQP2a4EplqKRAoZSNbgdLm9v/Wa1MqL3++3892qf+5qmu5F7duggXUxbfdOdznZrnvm7K58h+ocrZm7Okpzf5oO9yH+q5LpInp40+KGcgSvWJ/bo1SyPtRh6L2BBVhRgjW++6Lex2D0Eep+lVf9JnjRukob5xs4SYpUM0FeLSKeq6DTbkNqHm8zzCzt5EKpPeEe9njNyaAEhzwOZtWAyRU4YKb9LaiDaWLPNcqDuWSDPFk1UHc76mKdZPc
 gsISFFlb
 9+G0taajIkqrWe/B+68LxMJy25SHHjRL6wgTIP6TIJpJMfAGUn8Y7YAEfvf1YWb73hmImxadEcED3wyVlkYn3ghsaKlfWOkBZOB4maaA9mmkm+uZxZRDT/5288D63dbzh7hQsrvghEGMLMropBbTT6nultcHsY2RWL8KHhoX/tdj+0MkkxdnPVPZLLYRa7pJ0X6gQGdWMS7vElqjhuAPdjXxrwtCy3uU+a0GqliL+FbrtfNOxU6AT1kwaJVfq7w+w7yivR/bcKtojwwqGn0JwBG/1eFooXKfAnkPskzxkD2qege8=
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
Signed-off-by: Hao Li <hao.li@linux.dev>
---
Hi Harry, this patch adds more detailed object layout documentation. Let
me know if you have any comments.

 mm/slub.c | 92 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 39 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a94c64f56504..138e9d13540d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1211,44 +1211,58 @@ check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
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
+ * Object field layout:
+ *
+ * [Left redzone padding] (if SLAB_RED_ZONE)
+ *   - Field size: s->red_left_pad
+ *   - Filled with 0xbb (SLUB_RED_INACTIVE) for inactive objects and
+ *     0xcc (SLUB_RED_ACTIVE) for objects in use when SLAB_RED_ZONE.
+ *
+ * [Object bytes]
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
+ * If slabcaches are merged then the object_size and inuse boundaries are
+ * mostly ignored. Therefore no slab options that rely on these boundaries
  * may be used with merged slabcaches.
  */
-
 static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 {
 	unsigned long off = get_info_end(s);	/* The end of info */
@@ -7103,9 +7117,9 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 
 
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


