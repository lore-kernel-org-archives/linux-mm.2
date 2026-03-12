Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35849106ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4896E6B00B4; Thu, 12 Mar 2026 17:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437876B00B5; Thu, 12 Mar 2026 17:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343356B00B6; Thu, 12 Mar 2026 17:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 256FA6B00B4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:42:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C775A1A0448
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:42:09 +0000 (UTC)
X-FDA: 84538734378.17.0FC2F73
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id B4DD580009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:42:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cw+Tl5i7;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773351728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyceMyfiqLdgt3XmH3cZvfSKhUu32FwkvwXjXF/XZck=;
	b=Q3oFOC8VrC6rdBwhZB7ztmDsnL4y2vIjJUC2pljQR5/KujimgjW4PKx3Pr/5wmWKAzGi/E
	/H6zIgOl72ZfmI4EfO78RB1GhGAAXaMY0npVW8o32Aq7pU7fidJDHQzgkmKgQ0M2wXor4I
	iGYVy7SAEp+WTbGJspSKalMSC3f90VY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773351728; a=rsa-sha256;
	cv=none;
	b=cqhjDz3ICCIgRhyjSFjsf7p3aZSL2ykhVceDRfhpJdjPbcRnGkU6EJ6Yx61hNiasNYsmYD
	BME0e7Fi8Emz7HNxv/V1vFCdmGZIwSd/VseSuR56lcUWZd0PZRKDgeBLC9pMsGrM1KpbJU
	KkDmDZJw0E8YD4gO6g1qzaEF8VrHaIo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=cw+Tl5i7;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cd73c4a827so140991085a.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773351726; x=1773956526; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LyceMyfiqLdgt3XmH3cZvfSKhUu32FwkvwXjXF/XZck=;
        b=cw+Tl5i7pTjs0Twu6d4KFWgmYjRkSEEoWjKHWf9GEC8x6R7vEdmgqGOYoZbj/6wmDD
         2862B5eGHVjC+9xkOLTrwTuEmk8NB/vYqKRZzvHiGEngOvWGPVYWLHGjpR5BgIFtwQDq
         FKs8rjFkj5vUSz5Ju1nJfYlBTwtu68sO2Vh77FBjRG7/DaNlSYelcQgc7REsLew3YFAr
         ve4Tm122KVFaLeGsf2kjA3dMTAf9zJboTwKWYAJinW3VY+FVfS99CW6yMvskO4y9aknz
         8/BSTBYwKAFxKxiyPqvKWMoFm5r68RU54MmfGxzQR6fAJAsAT81f1GCDQMFAul70Wruc
         CVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773351726; x=1773956526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LyceMyfiqLdgt3XmH3cZvfSKhUu32FwkvwXjXF/XZck=;
        b=OoieHYKCRY3tqntin0SVD0nkejFsv95vA2/KWlLMdENmRCgPueBSIaXpkHDDL1lbZ8
         eEUJ+ElGNHXioRcDQ+xHe2IcUp/4ZjGvryr6HYQFuUsiGhxxKRtWpjroljvVpHJ9kM2q
         256V9tjEp+aVFwYBfy8553Ay1VWUqcwUlBUdAUpVxjfmgv4t3KQ+8S1ko28W54OZXUm9
         ebqf1XMuDZkMVXMWbYMsQvGbpR0P8yD25JFbqyJwOPPyzsUf2sbNSUlDvdxPuclCN5Tz
         cOvM65QAQ/oPitGCN9g+IGaQBYYfrFAinD7Z+Y1BeOkmnJdPdSmA9fUmfq1MWzygeJZs
         3Q9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW+NRnECov1mayhVBSVteE7yAyOCyTZYqOBn/D07Zt3OMeN6gX5o2p05zNdq3al+ifityczUHttqw==@kvack.org
X-Gm-Message-State: AOJu0YzhG3UFA+nWiQA52sCtqnCvrV1iitswNY78MeUTPSOUnjXctnKW
	yw1Fnn4cRaTzdOTRDpsWoEYThnmlrUd8lqI2Rd3CIJFm5CO4GhQhcsjcYOPXz7HEjM0=
X-Gm-Gg: ATEYQzxwjV8gFOonFhWa/fAbC1418CF0je75zWM2ZAFRFW8Baj36rKfJRyqE2rfdb0i
	pEtzbCTrJQJDqFEtS7ynkKg4AuIo7qWfBl/Vtnxk4A6L7JdvyfDz44GjVQk4QIeBZEhCEv1wXe2
	LRg2lK4MYybcMgV4lcmdp+qgx/FDLUDQPBCPFLhlAIfdAJx+BFC38Ve9aJCs3E1o/a8sjxP1yMJ
	65kYfg3cCNfVCS9XX5nQgMwIpTaK43SvEZ85edZpVoVIteyrn6SMknWzV4m0U+9AOfYaRKGJFf9
	NtOjK/9Jlgx4xhBE2u6Uiw+NWJDMNCar0dQBzGDuORCQtYU1inmvKmk7tc/NXfVJYo+TfjJD0Zl
	WfmYLxHXko7QBFJPfZpLxWZLAQXGQXT4zS+RCBsDjqR0XhLrFXXDlS5RmIrP5PYg/t0pQ4lda1H
	Vw2lDtiW1nVK00WabbJY6NEQ==
X-Received: by 2002:a05:620a:269a:b0:8cd:9b31:23b1 with SMTP id af79cd13be357-8cdb5b1b1ebmr170750085a.53.1773351726619;
        Thu, 12 Mar 2026 14:42:06 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda2151db2sm404907185a.44.2026.03.12.14.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 14:42:05 -0700 (PDT)
Date: Thu, 12 Mar 2026 17:42:01 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 07/11] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
Message-ID: <abMzKa27khxDLO_D@cmpxchg.org>
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
 <20260311195153.4013476-8-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311195153.4013476-8-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B4DD580009
X-Stat-Signature: 8fm91zntgdrxwop7w94kkk5ntuq4owyn
X-Rspam-User: 
X-HE-Tag: 1773351727-962153
X-HE-Meta: U2FsdGVkX1+NjtAW5WdBUzk1XHXIFTUstB5OQJeIYA2pG9gJbTOWayaludyLy1V/jSo2/87NmsYDnsTnsnjJ5WDrPxmmfHaYOrmT5Uk/P+decmz6NhAPZ5hP3JLLT4lZ8jENjQIKWGvztER5G+ucs+km+D83+l4HS4EVX6g98muWtfJkEhkpoUCNRr5jvYkYmANu+NeMGRT2RvTAhJ1kw8hDzuudhQ2WY7J11Bb9AwGtFI30+AKVfBiuKVI4VUskrEaT/yxXGub/DR2JsoVLoYI5B6/qROg4r1Oq+LRLxTziiMDxkOJKnOgyIlSlg4ioh6iv/BcUGUE22X4jrHtX4v9kmgq0yrOYFoM6FNSFKi76yedkq9MK3Fk6uqAUX44U5ppWXvdXnkSP/Q8er3RTedXYWlJszWa4IbS2vzxIwAXyN10ouVQ3anoZmgsF9GDk/m5wt10YIeyTP3FpA96B+cbCbR+SCbvIMKfGpsJ0DTOdYrwfY9e4CptHe6+PhOxoxmu1GzZRTCVHXuV0xKF2/u3JqLwHvrD2HtduugMIkqlvigBKSeBiluzpWtqhfD0rrhfZVPWKct4lCd/mEUBdUQMN/9mAohSciiBVBI6yBckIS8tsK2zE7lQ76HDTEdzQTBwu5m2IcG7rymUTLS1r2zlFztEbo9wH6OZnxGx/W0uzAs0F2hdYTzno7CZP7cFS4LKhL1bDniwliwBUCpsm4kE+FIh5ZJEMwZJRS5OGtNA7OoUaXdSgyACmOQD2aEa3b0j2eIb7nxxyMuewpRE5SeR3ta1uTZKcJOdPZMfZQVIsZsEIh7g2NCq8SmvzjqnFLPFbMu3E39CJ3mUYnh7L8SyShbZmHXuOV/i0JLw1wCm/h5w5+Y/5xJv1/ImTYNJk5UrNGbkNriTlnz9ltEI349fBoYAM3iR5TeHmR1nmjxSqfCkzxPJGiG0J/sNVZidHFtUX4S7eAHP1NerWa19
 J9w4DTz/
 +6h1lByx0faJdOlRDB8L2VC01byG+ZyikeGwgYBmInwmK2rBE+kUXVOYsdWBewn8hk2b329TgFayDNGQErtGavRe4/ruAqPvrSFapRhCOPGi3PUkwqWY8+QmrpYwROfYkIXFJJ6zfGNX9jPDa66VoaAIDEwEIqwOfJufoA6hBmJ6zNzhd08LM6pidIR27hYk5wqmEwro2touvb8c74VuziOBHeyMnSUSkG/6LHV1aa9Zx9YpMRxzKEEo28T8uw8Ed4Uj3zJJP8+rQ3oOycoVadj3eRJZxlwOLZdVuK9oIlKuK/IiqdUws0/e01yOx3hS95xzSjDoy998cepR3tQMGbju4iA3UuLp6NNpGR6D+8NUulwqx71YbfDeKMCojqpQUpGuKnPCl6bWg6P3mSGvh3NXCcvByM0M4XC89gSiXbklt82QqpMSt1oZMGvZpaGmk6oBtdrkNn2tQcNAWuWPwoiFIIwxEELlT83sj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:51:44PM -0700, Joshua Hahn wrote:
> @@ -1244,6 +1297,8 @@ void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>  	if (objcg) {
>  		WARN_ON_ONCE(!pool->memcg_aware);
>  		zspage->objcgs[obj_idx] = objcg;
> +		obj_cgroup_get(objcg);
> +		zs_charge_objcg(pool, objcg, class->size);
>  	}
>  
>  	if (!ZsHugePage(zspage))

Note that the obj_cgroup_get() reference is for the pointer, not the
charge. I think it all comes out right in the end, but it's a bit
confusing to follow and verify through the series.

IOW, it's better move that obj_cgroup_get() when you add and store
zspage->objcgs[]. If zswap stil has a reference at that point in the
series, then it's fine for there to be two separate obj_cgroup_get()
as well, with later patches deleting the zswap one when its
entry->objcg pointer disappears.

> @@ -711,10 +711,6 @@ static void zswap_entry_free(struct zswap_entry *entry)
>  	zswap_lru_del(&zswap_list_lru, entry, objcg);
>  	zs_free(entry->pool->zs_pool, entry->handle);
>  	zswap_pool_put(entry->pool);
> -	if (objcg) {
> -		obj_cgroup_uncharge_zswap(objcg, entry->length);
> -		obj_cgroup_put(objcg);
> -	}
>  	if (entry->length == PAGE_SIZE)
>  		atomic_long_dec(&zswap_stored_incompressible_pages);
>  	zswap_entry_cache_free(entry);

[ I can see that this was misleading. It was really getting a
  reference for the entry->objcg = objcg a few lines down, hitching a
  ride on that existing `if (objcg)`. ]

