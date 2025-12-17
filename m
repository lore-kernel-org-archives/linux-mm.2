Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B1FD68BC1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 967476B0005; Wed, 17 Dec 2025 17:18:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914356B0089; Wed, 17 Dec 2025 17:18:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817636B008A; Wed, 17 Dec 2025 17:18:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70DD86B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:18:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03DBAC0C2F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:18:44 +0000 (UTC)
X-FDA: 84230378610.05.AEBC6AB
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 083C240008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:18:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="XqA9S3X/";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766009923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bXcbwNkeZlIMBZPQNBardsHsUWb/8fu2HEpQ4xgxp4E=;
	b=38DVhbZDlHFU8aDwOahL7SV0K3gsEEF6VhuIvminr4vdp3zKgP1DUubPbJXzWueIP9LRSk
	QpYQ5S+KAra6ORAkVfR9PwtdCxh8UQitvrtvpSTA5QRyFJBYxypZ00JgOoMNHzxZogcv6d
	0TpEEOLGwChwOdDQdA++DWQwUWRuYsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766009923; a=rsa-sha256;
	cv=none;
	b=X6Hant9TwMf+gYUQMeS0xLOol0PaUROSaPY7hopjv68beZvHfJZOaiuFkI9A+Vh/OUGD9v
	cUDiwexiLe3JKjHC+ljRNNQnOIU2rtCkQEa8uZAO77nqPtBZfxVMDdbRQw9wwfTRKM1gSV
	OQSXT/GTBm8CJtysfQVENDU7uGu4BQo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="XqA9S3X/";
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-88a32bf0248so110936d6.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766009922; x=1766614722; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bXcbwNkeZlIMBZPQNBardsHsUWb/8fu2HEpQ4xgxp4E=;
        b=XqA9S3X/BbmFyoK6NY0gVQt0/cSnkIxLo9MhHHQco0gePaxFf6VV+OrD0RkqIV3Sd6
         mZEBXUL0ewwiAnAHmHRS8fX/2kHz3T+OVWskPaPR+chuh32OVTI05wFe5u3XkVek04Ku
         6nzrsr/hnj1xeloKLd6KH0fy/YeuiH0A0gMz71UE7W2VOum0QTUXcRGpJHvKT7/nTOA3
         /Zzutx8pc3y4ficH12I6flXB4YhhOFJcC/KALZErSQlBzrbinZEWRUuznVri904RGcMp
         vUXSqt3TaLJS3ZN+g/vN+JqAKIJiNNrfggzO1AJaEOOhkXoblM0m8O2oMGCQyy8sJOpu
         EjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766009922; x=1766614722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bXcbwNkeZlIMBZPQNBardsHsUWb/8fu2HEpQ4xgxp4E=;
        b=Mr9A4Cy15v58Q8A62MyK7ITmKspMox+G6BnzXpyBzLTJ6o/Wn0MBZV41JZmQ3ATV1D
         8+SwsIDJiBxxJi+Lx5bvUiL87haulNVPE9pvnJQHLyYu/vM/9MSLW+TZ4h5kfJG+6uVg
         dcoFXUfqOVZnBkrDWikzwiOxiBFz6S5chkQ6uBYF6sm+pA6iPFnFqPQxy5LCBEINwZYE
         pS8eD6bESPJ/Rle4/VeqR24dLQA/jA1UblpQ14n64t9t74FdJZfAy9UyxwBA+NvwH730
         +g8IFK0wcGM87oaaE3BhuDIjt0eHoXf9Q3x1VLXjreRe4zm9QcuDVUvrT7fkmS+YYlKF
         0Y7g==
X-Forwarded-Encrypted: i=1; AJvYcCXHzmQloBOKzpqQ3Qd5nIUhNV6KXQaVduul27ENay7HujQ7knyQf2OdXYGHpR00J8q/7BGOv0Gl/Q==@kvack.org
X-Gm-Message-State: AOJu0YxTy2VZCzQpVb1pIx5839Nn9QBkMI1esgWscIjW1B8mK5PLUZAW
	BtjHiEthkT7zwMn7OWo2uKoipsZ9IYkgZPCJXz0mUaOnMbGCn2fitFOm8i3xiouNGbc=
X-Gm-Gg: AY/fxX5zi3gvAH2LJ58aPyNYcVRZo+W6SEPj+AtCBEYVYkZHDDLLH7+M0ttugdS9U5B
	6m0khhAHrVxHkdzXRKOoWbKrqs9soaaxbUYXejZ12z1R4Kf/A4tt9ZbmWdiPMrA6gXTS2yf4TKY
	o1xxRsJezNVW+nY7IUn5LAZPZi/odtwkkNlPJp0jdcCtv5/9oHOgCiEQRMJpJ1Xcjxahxq6bSUE
	wQ2S2Zo09M6GVhi2tG6Jtu/7V932un+DxGDZLYXdCS2QezsqdyEN2nIy5JDz/Vw9GFzkCgVcc5t
	Kq/Kth13qH0oLxFcREo4eNMao6oVkj1xtuIxA12fuvv1Jt1ukbP3q7572rxPR7AkgkRIlTBo9Y6
	ApJYUH2vuF+Q2bkH1zUR8SjzpdBDvQbvCPCluiIfUenuQ6HZf6hLdi88I3Jef4AGkya12GqtcEI
	8nWFWpuUc/BQ==
X-Google-Smtp-Source: AGHT+IG1f7aReTFQRW4F2M0CyUDBY2Hjp5SXYzk7s/J18pLYnuhEkDgo3DdJ4s8MQTcbTc1pUU5ITw==
X-Received: by 2002:a0c:edc3:0:b0:884:6f86:e096 with SMTP id 6a1803df08f44-8887e7a0854mr204953976d6.34.1766009921932;
        Wed, 17 Dec 2025 14:18:41 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c6089aecesm4698286d6.32.2025.12.17.14.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:18:41 -0800 (PST)
Date: Wed, 17 Dec 2025 17:18:40 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 14/28] mm: mglru: prevent memory cgroup release in
 mglru
Message-ID: <aUMsQPjBtYtVWjwf@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <ab60b720d6aef1069038bc4c52d371fb57eaa6e8.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab60b720d6aef1069038bc4c52d371fb57eaa6e8.1765956025.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: s9iqy63x5kzhiyqxyht4385km6foj8zm
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 083C240008
X-Rspam-User: 
X-HE-Tag: 1766009922-950668
X-HE-Meta: U2FsdGVkX18Ii/C/prMCJrvEqNOjgtN0nsP9jSH86rlY8JIunXzFCQjYaZqo2njpA1/HfcEJWBmOfvr1IO530ZaA2OCNuWK4+BA4T0AHNJl5gYWFLIz1viBL5TopwS6q2T95cPc91afAQHFEe23El722SLww+9Es3+SvK64Tdh7+i1PbZbw+V+7+BLR/G8CYzZ64hhY2XP7yRS3jbUQUwhEtafR5Yc2kl15t7edM9N/jNfbIW8NtX60FnBLJTN07krrCo7IO6lcla1XJzxcYEdiO0CC0NGx4xbP6f01Dp8M2smzzkuo8i1/kIGvHnzkn99dLgYFadwL+5vU2XdgxppArUUKDUfHVaTcQhCRaStT5ga80Emy8dHKNr/zpdL9mDKRVrIeTo6qr9SvJRLZUs99IOO2gOOJFlD1N+1VKiXKP6arGdzzMz2CeNcbBFZATMwpf5T/jy7LOPd/v9pOglZf2qV+nM8lY7unfLVTKY/Cdcphn67eqmDkrNr+RXb/Bo8B7H0PtlH8G9U3bx7eO/dA4iO+JzeCtyO8l+CD6vFdeH+tRM//crLgbR4q9aku0htQZTWHnS5h0uaxnenKEtrvyTNfvTT2urvMHu9u+WE3XT3tU1IAeN52mSLYfTc9YrpAkXa10FizT+CUcUYMtBFxXnHbygFht8k9uNcV+pVx493uLB1/omi6qP748EvdPHMvR2f9D4qduURyyiVITsV18VvjjB8VGGArKm5z++6IaNaeqgvzIP6zt2/HW0o6nM3XdeytUcAN1XbP+simqeuQB0xPbtwxOblnGnGczGS48DOesIj+oz8dZVY4GUtOyCxr/PzDILKI60/6uG7XxUkX/M3KOgZLYeg8jScU6LQCp0PUggACXI7Bw+llzc/RoTrshNEuD1IkRMW/Aro4xymR8e0cEVS00/dTfmHOT/lJ2FovvZQUnqmrlEhJFbKFZlGN7tKUXCasTkWAKe1h
 nK7SO3i/
 6aAM4vvT77fwdIPZWMvlpeRY1h1EUem2Kw/cFhW3oeV7ZXLgGIWhQ5NZHRYYD484KkoOxwbybt5PpYv6dsgOgQgLKvAxOl2B/WcbGaq6ZFXCKW8tdmaymA08QZ2VP4KPCslFyNOoyWqb6P5w/f1WW1fiFkm8Ta/pu8Z5LhHgMoRueGn8CMUEmrgQq0Jh4bu69evbMJ0GlVt73M8MLCtaegwwtRxLtG02kGyb0lO+IzO0S9pAzXPU17liYvWTC5tzTY15UwRfMHx/Jz2zEF36z22pbMIHmnqXlbz9KHlXwJZwkrwKcb0f+Zq66KnHkN4eygKd5sUz0KEFLw5AjngD8AGTTM3z2BeWVR+/Unj0lyXJ2ISCzTT/5a6Mnx1CJVhe39SZ3Ruv2FJDj+61BL7xxGWyDpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:38PM +0800, Qi Zheng wrote:
> @@ -4242,6 +4244,13 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>  		}
>  	}
>  
> +	rcu_read_lock();
> +	memcg = folio_memcg(folio);
> +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
> +	gen = lru_gen_from_seq(max_seq);
> +	mm_state = get_mm_state(lruvec);
> +
>  	arch_enter_lazy_mmu_mode();
>  
>  	pte -= (addr - start) / PAGE_SIZE;
> @@ -4282,6 +4291,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>  	if (mm_state && suitable_to_scan(i, young))
>  		update_bloom_filter(mm_state, max_seq, pvmw->pmd);
>  
> +	rcu_read_unlock();
> +
>  	return true;

This seems a bit long to be holding the rcu lock. Maybe do a get and a
put instead?

