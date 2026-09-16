Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3186EC982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D7C6B0092; Wed, 16 Sep 2026 11:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DA16B0093; Wed, 16 Sep 2026 11:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7F76B0095; Wed, 16 Sep 2026 11:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAA586B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:58:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EAE81407C2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:58:37 +0000 (UTC)
X-FDA: 85220083074.05.CBDB5BB
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf19.hostedemail.com (Postfix) with ESMTP id 14CB01A000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:58:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=A5RihjBC;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789574315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjcBGUR39i2CtxsYZA+y8R1kv00jh+PXwHXxQnV1eiQ=;
	b=AkqmGe5XPpPYyIqwM85M5TuNDJ9yFJpbsiuWhAT+3QYOOEYk5AzrXn1UO4h9sosXrV8JdF
	Qqxa1Rhp8OwFGDXjn0y2RSz0YY/x6Mt1NhRLzCZzocLb3dyCPkz10v7KUqYqgRegm3A1eb
	CBr3vyklbg6ybKwSLKTJ4u0gpqykbXI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789574315;
	b=CzHt2a0hv0GfAaVlnYngCZ0eGBun0eC6iXdltOm7LoztMiUOD4uV39IfoJ9QMh9hINTclk
	GUanYx4auPflVFX11s2LrPOVL8D8DFKnO6wy3wm8KHyLGY0/CDFlttM/iS0j2cPq9qg/gE
	m5m0/IEH0ul9QnAaq6jBRsdxQ4LgqYU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=A5RihjBC;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcbe207so9986456d6.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789574314; x=1790179114; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bjcBGUR39i2CtxsYZA+y8R1kv00jh+PXwHXxQnV1eiQ=;
        b=A5RihjBCs1aIZD0m7uXL5sp0VlVf0xSshmlSlW8MAAQW2EM+Cd6R7lNDagFqXDpRUp
         5+97nO37iqW/ZYYO1WVoKs3AkVEtWhvx0SSa36DxIB8nCoRMPccyXr8QfEObg/j9uWXh
         wPWX9Z/cT+lx2EhoGSPci+AiDLvhfbXyhUcL1hh3oIaKIC+JvALKQVs7xO5Z2rNH9K+I
         Z5cYYYBPXzWJ3o2LoXk2CF9f4U7PupH61ckPDOKQqeICxYY0vr3SsQ46o33XIPGDFYGQ
         ZAxeLfFLJ5p0LK7NSvuoHiFZSI+7MztrmAHjnZI2yyhWkKlQJxkoTLpjrzpviJnJcDnl
         lkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789574314; x=1790179114;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bjcBGUR39i2CtxsYZA+y8R1kv00jh+PXwHXxQnV1eiQ=;
        b=Ob7zz2mX04w21c6ol5951VrrDUUOS1BXDaupTVFUmsQR6cTOJGPUyGAGJQ9Fy41Aje
         8Ct5DmUpeeKox6aUB71oykHVgWw3+F0h5ncsSeMTVf5mag5y+ZjBZoafiPdNtuaeoa09
         8JypNlqcwHuBdxfN7B58W28ZaRThCHsd/fSQsYTt+anBIbiBiKs7m+dEM/W9o9dioOWt
         mD6H74r9CwARc9v4Zw55MoPUZ1g3FxRvORwjJp31zihvP1R9beTt55llo1xXvgt0JNy1
         tOEKJOyUw965WRhJ4q/UaHBopZXAjbI1ZOyVRB0FEQfxWPkLS8NtBML/F0hD1BKA78z7
         xblw==
X-Forwarded-Encrypted: i=1; AKwUvByi/HwIgElkjtqFUT1Ap3Aw6jOY6UEipS9txAKtDoueBwMezox1sqKRzonR65JO7Cl+zX+O8QSP0w==@kvack.org
X-Gm-Message-State: AFuF++nSIEsi8YKU+ZxqoP1wIKRxF8KyUTz6N2ul/F/YypF2LL89fWSb
	89OTWfX5jCBbLpT6PymIZ4vWnpF301NdqiKZZVz6EWMm/aiDKFELbTdE8IruVWG/skU=
X-Gm-Gg: AYBFou2caJQW5LEAlolhbrExPKv+EZ3wUDbzVzZI7cmxukfvqBfw5nQnOZ7MykuvTT8
	LC93bEJdPvop0SSdfPWsqSNSAcDuqkX1FxQlQIjtg8WMpzQnDo45Nih46j2HBs5tTMOokt8Yj5t
	jtOUfdOSC/WumRaTBqucPNtag4wbKrt1z7ery5IPvU04avAOyl+wM4ku4OM3KLeH1foiVHEkTXa
	tDJ7H+lAyayQq/3HyNcQqe6AkyoKeev0tG0I4j1pvqpXD/Ghvgd/oB/2QJ7HDBckmrh3y5m8MbP
	oNLw2WNYubGXgYEWmUDXwoSOL4O453ajoUtQYbn0/4ejRjJa5LURDIK+29jVtTGZtuoNCrwRWWl
	inDj72brZ9aG7Q6rU+mPdP1fG9Uynls7koyHcMFqNXpaf6oxHCI3z6kcsOuhssPcvZNFlvWf/Qx
	fAbrhtcVdMoEZrAEK8ReBXwy22lS+HQdFjXqLln755QxzHFY4QCoS3oTOSkcUvrLppWoqfFg==
X-Received: by 2002:a05:6214:1248:b0:90e:96d1:40d3 with SMTP id 6a1803df08f44-9123d7a5b32mr54271566d6.20.1789574313980;
        Wed, 16 Sep 2026 08:58:33 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123be609dcsm28537916d6.15.2026.09.16.08.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:58:32 -0700 (PDT)
Date: Wed, 16 Sep 2026 11:58:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <aqq8pWI0u1IZNWHT@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 14CB01A000B
X-Stat-Signature: 6dai1eh89yb4hi3nh66mu9g38z7qezca
X-Rspam-User: 
X-HE-Tag: 1789574314-124273
X-HE-Meta: U2FsdGVkX19ggf1SrNordWxxggLhO78eXAgK4Hq9dCcL3hix9XoFeuM49XMFO6svG4iOklS6LpebU2niBkIAQAtd+y2Sagb90/Ht8bE6EWbt8jslYvAXzkT2KY7QxyXXDPSNi9CqDqDOG4QSphOI+j6EN6jWfN4a9NNHJ7GU+vKHKg5WwI85jt/aL+lK4WiaLR63V6h3ZFjZKh9phVse6YIII53+4du9bjLNk0wRE1XE4KaSbEx4k7RPGFta/NZ8tzUgcv26yz0FRxYpsfeUCOlnPywgmR23Gv4GZ5MnP8eE9wThJ2BauDTw38T9c00INclmag7GL7eg90BHH9NEGGOa1iyDEGFPJWz2EQp37UpREQ8BkejDqN5ftxFVUrrlJApqrYhYhLDUHDtzFJ7YYAUR5e0eostuEzFF7H0HbTHqPcJ26axUI9XxJjBpZv2vaxg+o0ktrnDwXomIoJnKZX/SIzowrbjIbI0JHsEh6XTSld+Yofwgwfwi51/kGyLlkNhOMqi58OjVcnjyqTlfunaaR1aSsXdwcgru/KAm0FMaO3u1ERegJ8TaOyUp/2ehnZa892Zs7AYYLaOlZPj+wi3ddrXjul9eXVC92qxOmEagG/4OOJs1QumwzWQkBeYD2Tit0+v+5l+srMQQ5r4t/b7bHa2+PnRx8cXcf4dIuufUuP1Vyi8Sbbg2lMxlL2qvCsAwi/VArdFpZOUgE/Zk6glHfaUUihxhkvgLC6puopUkSMct5FymHVESdcBTsl6SOtdV5Wc08qfrQ5h6sk5Cp1iDHzj2PUt8CpaSodLuHLrMuIRui1DMYwgxHaoZyCmnETEeF8MYKFsQUSjCZeigHYOG7jnuTQhsD4Zpzzit5D6ZCvtL84VGc/zKJdvJM5MboIF2qyyISc+LbauwrQnTa00GeggVk1+u4RJKeAE3sI6VeBkyWqz+Fyw3KMs8sn6cIifQznPwikFxNzWGcWu
 0HdXOvcM
 GF6fyNqe9Dbx5/p4jRjT3zl7dVFM0FVYKqEsJ+K/aV7ehRfN94mW8+kPRswCI7Eh64hhULbDCa8oTlLuhWRVhrdwvwXq23fqeaZrya4qLmUMaWODTkmMJDqyqOSAHn/VmHP9CUA0HLl0qs3bu1iU3myzEinOMWau204IMNxhc/w4ufmh5yvjedlDy3Q9K6cFjumzrzA6onx3yzB3d9eWlFX9FHGfngEdoFuIYErcEXrLDHETocUYNlLmuJtoXYQyIRDY+uH0LcjNFR3Qo364tocuPgVXZuvgkwAQweg+qrWaZfdL8eNqTkajGN+JptL+3Jn6099NFOjxSGq/AjTTd6YDJpPj8NLclzhsidMd2xY6nGSz85c4dqoBEXWnyohPhyKlk1LCz95Sl5wjiZ+3ekTgA8WsaW281cxT8Mzq0vbvCsnoZz8vNsXazvbHHN84g2SSyygYkB6IBNCd/RRnTbcofmQN3scw2eIQVtZbucZRopM/BvJnABKdf/3q7QX3X0bSfij4ZQG0aZNL6EK2UOfjDlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 01:24:31PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/11/26 17:59, Johannes Weiner wrote:
> > The access to
> > MIGRATE_HIGHATOMIC that it points out is in itself too generous. This
> > seems like a real but separate bug. It will allow GFP_TRANSHUGE_LIGHT
> > into the highatomic reserves as well, for example.
> 
> I don't follow this part. For ALLOC_HIGHATOMIC you need __GFP_HIGH in
> alloc_flags_nonblocking(). So GFP_TRANSHUGE_LIGHT won't get the access, no?

rmqueue_buddy() has this:

			/*
			 * If the allocation fails, allow OOM handling and
			 * order-0 (atomic) allocs access to HIGHATOMIC
			 * reserves as failing now is worse than failing a
			 * high-order atomic allocation in the future.
			 */
			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);

It says "atomic", but it's checking only ALLOC_NON_BLOCK, which is
broader than GFP_ATOMIC. alloc_flags_nonblocking();

	if (gfp_mask & __GFP_DIRECT_RECLAIM)
		return 0;

	if (gfp_mask & __GFP_NOMEMALLOC)
		return 0;

	alloc_flags |= ALLOC_NON_BLOCK;

	if (order > 0 && (gfp_mask & __GFP_HIGH))
		alloc_flags |= ALLOC_HIGHATOMIC;

So this can apply to random !direct_reclaim requests, no?

I have to correct myself on GFP_TRANSHUGE_LIGHT because it happens to
include __GFP_NOMEMALLOC, and so won't actually get ALLOC_NON_BLOCK.

But what about random GFP_NOWAIT and & ~__GFP_DIRECT_RECLAIM sites?
Those explicitly don't get watermark exemptions already, and weren't
the intent of the rmqueue_buddy() exemption above.

Something like this?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..c79cc7aa4dff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3246,7 +3246,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			 * reserves as failing now is worse than failing a
 			 * high-order atomic allocation in the future.
 			 */
-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && ((alloc_flags & ALLOC_OOM) ||
+				      ((alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC)))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
 
 			if (!page) {
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..11714ddca254 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -60,6 +60,9 @@
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
 
+/* Flag combination from GFP_ATOMIC */
+#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
+
 /*
  * Structure for holding the mostly immutable allocation parameters passed
  * between functions involved in allocations, including the alloc_pages*

> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> concerns can be dismissed and then indeed v4 is the better version.

It looks like a real issue to me, but one that already exists
independent of Salvatore's change.

