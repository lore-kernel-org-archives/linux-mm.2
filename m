Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B660CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 16:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DBB46B0096; Thu, 14 May 2026 12:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2846B0098; Thu, 14 May 2026 12:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF706B0099; Thu, 14 May 2026 12:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE9D6B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:03:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A9A01C1525
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:03:06 +0000 (UTC)
X-FDA: 84766494372.14.AB8884F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 135DE1C001A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 16:03:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o6S03N2V;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778774584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDZUz8Pf9sfIGy/YI5I6Z/8u/tQHNxF4wF1uKMs5jLc=;
	b=2Ky/0eV7/hsTgIvoV8xPTfPY2SMlhUvx9sXIuSYwoxiVsL25dkA56qQOIOZunyWHPx014M
	ufbMSkqWS8oojVi5qYJGc+aY6pEkdNPXrnSqxLta22821ghBnoieeXxIOxJcMlrTKzkzq+
	J72rNSL6s0B0qRHex12+RDsVFKF19Po=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778774584; a=rsa-sha256;
	cv=none;
	b=VaN5VYy+g8V/nqDJ85FdnxTvLnpUdesL1WwP/CP//d6Ox/2pbRFB+Vv0EFg2F3jIKMiCma
	GKD/eF+yXdbwlAZOMGeiab+FZIliVVHePa1J/ry9p+LUTo1GYyTEtk1/DFrIE4F+2sd0p9
	jAdszg0BdyIdJueoF9TwNMTfq6yJLS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o6S03N2V;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFFC643A93;
	Thu, 14 May 2026 16:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E501C2BCB3;
	Thu, 14 May 2026 16:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778774582;
	bh=tR+v929baoKkmWPKVhEbX8jVI0XOU70hiwX9rAM6q5Q=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=o6S03N2Vb6Bnya0M0gTxZaYmBO6u9oCKKJ+dC0bhcbRGf8da6XQ6ApMDwZ4GLuAnQ
	 5aEtaHfeHUspKMuG0lcvEka/YNh4kq05/9phbnoPipiZZlakLSQmzVE7mKlHfdq5ND
	 oIE7xUyKv3f2UdOHmJgwfs2uTP0PlvQNPIirSOJe1nD9de147v1MekZ6gQhdJqOAks
	 RKR07htrwmhV4FRaJLnY6ZaATv+ummWDutTSujcqeeXu0lsySnf5uYgywEybNOSSBT
	 6MNiJnTlWoAvKXF8algc0qFQ6mLt3u33zbsXd+8bGc3SkFKvKPlXCoe4H6UWzLWNC9
	 6sFEa1HPszzYg==
Message-ID: <d28b4a2f-501a-45dc-8589-acc41633e2e3@kernel.org>
Date: Thu, 14 May 2026 18:02:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [mm, slab] 298cdbf5f7:
 will-it-scale.per_process_ops 6.3% regression
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: kernel test robot <oliver.sang@intel.com>,
 "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, Hao Li <hao.li@linux.dev>,
 linux-mm@kvack.org
References: <202605112204.9382cecf-lkp@intel.com>
 <90bf195e-45fb-423c-b686-49be9cadbd11@kernel.org>
 <eda98e7b-67fd-4a36-9d39-3de26827599b@kernel.org>
In-Reply-To: <eda98e7b-67fd-4a36-9d39-3de26827599b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 135DE1C001A
X-Rspam-User: 
X-Stat-Signature: ho4pg5pa6cc3us3dnkg3g7rtti4y6w6u
X-HE-Tag: 1778774583-812212
X-HE-Meta: U2FsdGVkX18OZ+TdysIbP7noBrejWlC1kiKS68j+of2VGEnoO/8Ls7je+ilwXD7S/CYaXJ1wUEGY2SseceNUeKqLSDDi7p2gQPFj3v7QYfI8bZxCKOdeUoVDFBeTMotCrauukmvLhfE7mCf/5PyQX/4UuQQgwxrFcKUYzht/g/krPuhh7vAowKB1zalmAulE9mPvQqTDodXQBEv2JHWKJbjfd3CNqlIR57tg4lqkOaYc9QIOw0y5QXEUvxs7koM3goKEqbKSMeDZvdXfsTdYJs6bdrU1y4X6wW7KC19yG+vLn5z/ysZEZ3zx24squqmcylc8aMTEN7QNS9E32kp2MC7lpXBtYaEH0KyjajL/AOLaCRIGsaia+syeri/WOdecnyShSAs0teA574VwPsHVuXxvEgEO64vN3lcSY6lAt2AlQtxKItt0y8tu8gc2q+LRnOCY+15gza6ffuTtinuE8tPfmJopBWXOAdwOLvkblrONsORveH+HnDrpmtzlanmY0x/M8Inpm/RS0fsYLVAFiJKdeR7ee3h9eSU3hF5BABa++4Xd7JQL84k82ObHXp2YkPf5MNQ9PNyRq3QBgRRUDC6oRqrHRRUR81sDvFLxSgVfUY1RfZ8PT6tt5VCJbXutAevBxDJGxZd6PxwdCN4zAdgfxV4+s7JYMKi/zgSSIO9zku4io3B/m6YIvRpRrXnt+t35pBDzQLNdV3DGhEgaioEISLj+ePw+HLbfVW4ReYJAQi8+kvIYrPPmVFLyPoBRlg9c73I7odcbgYb/dBDX0Yn6gEH0L7LHcHXocgw6pAbI89lrpQut+oiROGlxtGfDDeJyNfQHgUrrVeYvwU8dL95LzcqPLM3Nmtd+Cw30nGURA3zyVoO8kQu39hIzCUG/8RKmygvumBEXftPJWEqyc09UQFjAPMLLJpgtwM46K0NSiBncASJEYb7vFRU6DzVRF+E3cAQU0PoFSX2XNUg
 v35+18qH
 6a29tFbSWKVYJ6s0HamY95WRxHnBRYYZt67qFItBggUf0fDz3GLZzxAeUEbRQM7F7guG6TJP9amrF8bGsV+AmsZGDjGVb96zgV9WebYi5lSdzLVQ0IybDt3e4mmbhOsi/6aMVo2w0P/EP4J7N8o+7dRHY7LwlVzzRAWSkYVj/HKvBbCaE7+OXuBTC+j724SF2CpnhXxonPYOsRwbw1BRPHEFUbb6TGr9zTqyMXSMftErko1Ix2pATOv3P1byceLE9UMXkblvjHdn6tWWjSRJ/cay1SPc+53+ag9oZd8vCFJX+h2eaQsg/U1C0Ou+rX4QYUrvuGyaGq7pwu4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 18:00, Vlastimil Babka (SUSE) wrote:
> On 5/14/26 16:45, Vlastimil Babka (SUSE) wrote:
>> On 5/11/26 16:45, kernel test robot wrote:
>>> 
>>> 
>>> Hello,
>>> 
>>> kernel test robot noticed a 6.3% regression of will-it-scale.per_process_ops on:
>> 
>> Yay for an optimization that was supposed to have no tradeoffs :)
> 
> Does this help? I don't expect much, but perhaps...

And a separate measurement with this on top of the previous one, plase?
It's just that __slab_free() would have been adding to tail so let's try it
too.
 
From 8fba1377797478a945d97ad6163021d95ac7665c Mon Sep 17 00:00:00 2001
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 14 May 2026 18:00:52 +0200
Subject: [PATCH] mm, slab: ADD_TO_TAIL in __refill_objects_node

---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0cc6c88f11e3..35e574e94538 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7193,7 +7193,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
 
 			list_del(&slab->slab_list);
-			add_partial(n, slab, ADD_TO_HEAD);
+			add_partial(n, slab, ADD_TO_TAIL);
 		}
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
-- 
2.54.0



