Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD9FCCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 01:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E7E8E0005; Mon, 20 Oct 2025 21:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956A88E0002; Mon, 20 Oct 2025 21:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 893298E0005; Mon, 20 Oct 2025 21:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78AC08E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:04:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4648A13A932
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:04:53 +0000 (UTC)
X-FDA: 84020326866.12.9113469
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 71E01100003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:04:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TqylpQ8j;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761008691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/uhNugh/EUyo0G9PtnWbQz5kQB6FYcMFt9ZcmcW3jq8=;
	b=Er4V6WsMaV1BvfQpn5MQaxjusEkmFJbZlpfztIsP4TYA1htQoEe4AjRHlj+3L+9cbXXhGW
	/lezEvW01GAtGXp192Dr91ZSWEGRIyZDCc8wp5GhoQJkIE3BEx1OJVEh5jdSQ0mgLrsw1i
	nO++bgJpDv71lw5xh0r3BKJraVYZQWo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TqylpQ8j;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761008691; a=rsa-sha256;
	cv=none;
	b=8qLuttHU+t7CWNHd09jUXFpTAecCRtkueJsYCIysyEppgxCIZ4HuyL4J7/dgk906yUuvY4
	DUMDFQC5E2/rZxdOSIp+VhFnJ9bLxp/y3oHDLQmthnjIuLXOvD+hgU/ALnlU4CnGDb3Bmx
	Mv5kwrMUekDbCOCfnbtnNUB6NSHA+ag=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761008689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/uhNugh/EUyo0G9PtnWbQz5kQB6FYcMFt9ZcmcW3jq8=;
	b=TqylpQ8jaM+tbH6RZRwPSgDqSyExtn/o1YOdg6CC3a+gfj0xGkpuyk1O6LrMagcfAc88iq
	erQ6AWTHO0yiIyOSjRHExx+Oz54RKFO4QVqX/mKymo0e/bl2mj0+vR7PKMlldkNwXxTDoK
	PaRg2JM/VgIA1BzjEE7euqijCyQ0Pac=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Date: Tue, 21 Oct 2025 09:03:53 +0800
Message-Id: <20251021010353.1187193-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71E01100003
X-Stat-Signature: bucpzf9tkpmfwbr5fu1fdoqeefczmcdc
X-Rspam-User: 
X-HE-Tag: 1761008691-444184
X-HE-Meta: U2FsdGVkX18g5RmUHwMMVtjiBJLW7PSd8Mlv4kJwbiUQ5/XHEAoTl/60pfK4LDumYvFZxI3KiK75JisFQfVNzCgUQost7/jA6rjGNjanmwGI6Stkq5d40PASQSHq2q3hDfY2KKwPhRL4+8Y3w7bOSQspXz8caT545OHWthEgLpy54deBguKEFvY+nhNcs1hvvxTEhh/rO1bYZyMoSV/RzcHsnKwBhx8KHXZqEALozgl9gcuMW8VR8OaoKfxaN+KbZ2ecwOd4wzGdO8MOdBwYSeGOT+L+K9OJLLHpm0KlzkOOPi1pOomekaQPDlOd5QZ2JJsMqFJVyG8U3LHFWTypORuJgXv/Hnzre8jcKlgZtAfxC7HJYXosC1VwiZ33icf19Tr9mkHn9f6jYCIoPDzyH7laphuycXUnPtZzgFfPSFB4uONa57xBgMRbVEdY2fjc/oFuEglLFdF4+caEwOxpvjGmnucaj41rWkoyC5rk5fbouqFPtc2USxDDha8J6vfochcej3FFrDs9/bte08wbYArPFadiOHWShmuiJky/BCkIzLde6zSUxK/wI3q58fT+TCGPLTX8Jr09XIoScgkUOOGXp7Ej6I4r0JDusFTOQu83BkTrJgn++7xCHQ7YSl7GH1XfXhVyX1wdzuyjDonPYcL/EhjdTrQNdlU5Be5JdeccPfbUCL7hUSSSmtNW3+6KwS+HxBUO/nh5qLk/8mmb/S6TGC1XfnKTPQbK69fT7Nic/JixyxqUi302sHs/nfKo4rif+Wq/+rY8jbYFYSZTPyS2MXfUgcBMe1zZvfqK7PHdDWQ3niEwLLgBVTloKLsHhxIGmwvmFbSig0swMVHAz6asn4SFa1Cb0ugfKc+k2qXNZdpaA+Q9XSt+5l4Au5xWqR9+Yk+jrP9M18Kp6MzrwyBhPI1z957peSJPM2TGDy4+5+fW8DJweKKy8ZcyCwLt5ixshvofwXLUTylpsmQ
 TqwVtTxT
 V7SU33EybzMJBEBBPNUbtWEOX9i04rG/CllBvmRv9RKYeXUxnCRSqF4g64cPTLZBiJUqYWtya39zSF0B5+tG0/7J6AoinR+7lj4OfBsNjOWvnPfFW6Yyd077x7pU0PWT8r+90J9cmcXwzzMp1FPTzHMaepeUVR9Tg8Ntn0qX9H9rpuqxCy8rmdnuYPHpcmTxsWqjEwo8FtYJGcht2iylbXOJwXt4FSUg6LnUzddKe8T/Exyz38hsIFPAODqP+xkFmxCy1fgRyCUtfsdDZnjzWu2/3RxmnFUeG5MSlRfc6YZbVhsI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

If two competing threads enter alloc_slab_obj_exts() and one of them
fails to allocate the object extension vector, it might override the
valid slab->obj_exts allocated by the other thread with
OBJEXTS_ALLOC_FAIL. This will cause the thread that lost this race and
expects a valid pointer to dereference a NULL pointer later on.

Update slab->obj_exts atomically using cmpxchg() to avoid
slab->obj_exts overrides by racing threads.

Thanks for Vlastimil and Suren's help with debugging.

Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
Cc: <stable@vger.kernel.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
v3: According to Suren's suggestion, simplify the commit message and the code comments.
    Thanks for Suren.

v2: Incorporate handling for the scenario where, if mark_failed_objexts_alloc wins the race,
    the other process (that previously succeeded in allocation) will lose the race, based on Suren's suggestion.
    Add Suggested-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/slub.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2e4340c75be2..d4403341c9df 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 
 static inline void mark_failed_objexts_alloc(struct slab *slab)
 {
-	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
+	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
 }
 
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
@@ -2136,6 +2136,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
+retry:
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
 	if (new_slab) {
@@ -2145,8 +2146,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * be simply assigned.
 		 */
 		slab->obj_exts = new_exts;
-	} else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
-		   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+	} else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
 		/*
 		 * If the slab is already in use, somebody can allocate and
 		 * assign slabobj_exts in parallel. In this case the existing
@@ -2158,6 +2158,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		else
 			kfree(vec);
 		return 0;
+	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+		/* Retry if a racing thread changed slab->obj_exts from under us. */
+		goto retry;
 	}
 
 	if (allow_spin)
-- 
2.25.1


