Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCEA9606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81176B05B0; Mon, 26 Oct 2026 05:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59CF6B05B1; Mon, 26 Oct 2026 05:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6ED06B05B2; Mon, 26 Oct 2026 05:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC476B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:04:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38423A82BE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:04:05 +0000 (UTC)
X-FDA: 85364190450.23.5D51D8D
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F4E540002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:04:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Brmqr3VL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793005443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JM0+SvISYIbOGSD5ge2cDEyh3J0IZqqsu8OtCVwpkho=;
	b=T+cnDeKfnNdDGDG6sSfC5lGG0QwPPhi09lZyTElU0ytHhQe7n15poQD5m1tf7rlsd3XZBC
	OWrEeB6sEZSt9/C2ua+yX25VuoZAa6c3yv6c8g+iBIRJA2L5b1T6EoI7nYNGIQb+2WAo8p
	f1ukoeTgsJF14H9WLx12HVZrxu3LZ98=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Brmqr3VL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793005443;
	b=fF1TbSDWhzZmqvcoJWsuViuR6TOhPYN7Ky+OWWH0kqAOa/GduL23JI9WPmo7k4n0ufLUDN
	NqdyAQtQa6/YQ1DilzFBV8din1i5bnXHF+C+bUHJP1168jzyIQF29DORyd4fgpfdO2myaN
	2OY75FKPoKZG0RidM0/fPvS2DlQD/PA=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c46d41f6af3so123285266b.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793005442; x=1793610242; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JM0+SvISYIbOGSD5ge2cDEyh3J0IZqqsu8OtCVwpkho=;
        b=Brmqr3VLQLwEoQfRGrTuaNtRZ6GkDKmMNK3jLX5q+X9YAqz8RZB7Z912cPKlddA/qE
         yUzn7UTT1Ail5tuQDRT+/bEkfAjG9/8BrUrIIkIrDepzr/YBME0bYoHooGtA+Mfp7suc
         A5mgxouMo7WsWHSNrnIfX2vXwLv7nHIznenHKzgddsQTXGf9u2XJ8usFBNciBc6ea445
         xZ0+vu3JeF/FldgjBYFQY+D4VvNt/pLwctfR3YaovWHiMbdjYGqots7IZUcd5f5uoztS
         W/6q4qFN9dz83lQzNCknQGj4WFzs0Bi2WcKPbmJyk8+p/jX9+ElkZX4u+UzW+fKHVSgT
         n69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793005442; x=1793610242;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JM0+SvISYIbOGSD5ge2cDEyh3J0IZqqsu8OtCVwpkho=;
        b=tfCeszzUv+RwoP/DfHkPSyJyh4PmwHIcuLaVJNXpLqu4WauqWkbh0LGmiDcM510Lrv
         2r+cJPyed5Nrj6xa+RgnjYyY6bAk1QlWCdMLnzFH0UQU8ILEh5CPqN4qUrikT9Tpu6KX
         4KLsQ43hslLmjz1QucCzAnMhe/zQvpvkflfQ5pD/50Jb3wNWXXJ8ezxOm4j/2A+GyBoz
         cHmCeWaMG7KNnbp0dspqzukB1HtuV73SrFLeoaavDiy7ImPgAG4eQViCckaapbjycYyn
         kG5e21uhr0dmoORRWYVrdNXf4DMalhveGNEXJ8Pt/ucN7sABGpmlJlHiw3iJbxuc8GBP
         0eBA==
X-Forwarded-Encrypted: i=1; AKwUvBwjJOxQfXufVQ/rBo6/9emnALRz7WYOrwZ48orMT4RbnDJFB0KhwXxqGll3t69eh6mnKWrQvnAsHQ==@kvack.org
X-Gm-Message-State: AFq9FYJtwVBL+2wNOU0qQEqeM9xzt1vaEvKQo56SG1p30OI1Nf9qVpWC
	u+45bfw/FYxohTX7e8tN/gP8HcKm95IY4PVFBF2K1gTKJakRWfGSPcZUtJuOvcgmjkY=
X-Gm-Gg: AYBFou3yj4M0Vx7U/+PiWzbVMOLEGVyUcW2v2qkjNi9TflV9aZ3SsdqvBViZA9CvStb
	q/A/Ek+fvIE7c3Lg4LRtq+AkVDUB+I8sLSKvS9ucpGO0eYvjbPQpkFg4PUopSsGm10fNkEz34Lb
	8WBqKd5Pqg1Z+vYeLBaV3X0eYWBe3GGkpxDIjTjNRjxsS3U+ZWDaCtEuhHayif2+lP7RnDL9IW3
	aVb0NPSHAFJYgd0xTko9zAPMRxtLbiDXdXAh41W+7PEozaO/LyujWNrhoXWqsba+/JfIwuWQH+m
	L6Fgy79cH5vmOHscGnsQhyQEspAQugeUqhONraNFeaL0LaYSXIKzQGuYy8e4UBqvgA+SE8t3dCR
	PJsZ/tDOYY5xYJpkoueJgcACt9Z8DI7IBT6clpOTioYVPp/x22oYd8zFVEYryR4adFl0g+NuPe/
	AMFh/qn2ue/ks/t2U7Uub6bh1sZMC6wglG3eSl4D8vf5lzXlfM8J6IsmEPnb8LRURqz8BtmRgUT
	gVTlySO3jeiT2ObGNFjUFSvf0pTYtbKsqVqMQ1pSLqfJw9qSYVcaGTER5ms6AXwYd69h/lDAWuZ
	etyu7xatj7j2Fa8=
X-Received: by 2002:a17:907:6094:b0:c41:6de7:7dee with SMTP id a640c23a62f3a-c46bda6a198mr773866466b.7.1793005441393;
        Mon, 26 Oct 2026 02:04:01 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd8ddasm16802864f8f.48.2026.10.26.02.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:04:01 -0700 (PDT)
Date: Mon, 26 Oct 2026 10:03:58 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to
 page_counter
Message-ID: <at8XfoqWwe9HSL9y@tiehlicka>
References: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3F4E540002
X-Stat-Signature: jdky3j414cp63oy3xcdn4jgnnapojdre
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793005443-447181
X-HE-Meta: U2FsdGVkX1/Yvv3c0TM8qxj5lY8lO4Qc4uuaZxI88K6mfECQgfZkEKQSt9jUwLxUw/s8sqGQQD+TD4lWeVinwP8PwbuLgDuDo4QGx9ITqsF2u/BmqkzjxyFmLMREH+WyDnioCz/mqSywt9jghFBLXDCwV4tSMccrURLYu3HrNiPJmy64ii49sJkSjXC9mabRG/Fc8UlS5kxYglKoO3MdNM8uMQtkmi3xL3K76DArQZ04wOVxkFWyD5KmAd/ZipIFHvyKyEque//LR+bHORy65fLNZDyD4DXl+CiwmnnyqBdGIPq9o4/h7e5nY0IGLQ3lwfvaxBjT7MjCjx4rQerwqa4BuPh3WYD8JB17kheLoZvzTeJTMNyRtuSNxFQ7jDDhtqAs85FcZvFzbPOTI5oMdtsGmnC7Z0+4DkGydUVeK6GYLDmClSR7vm+nmwO+KGzeuUVU/OzxIajrDgWYFbMIhljqZOXOQYtUe7q0u3REBeEqZynYjDgNlkot9jnAvkKwVSts2hJdW+TL7Ku1kPaI9EHd6hrecoTU9ylQSrwzdKW8qxfX3MEPLslNhOTBJ3qzxXQySJWyLWflakwE4iLr4MMp/tBBgB95zzJmeEqaWJxS8UaDPw7d2nObztcs+viPkn+JhcDwMf69u5AARrLVvl2BfCyuSnbDUh2zMUN/yRSmTA+pR3J3t64l8mkhqA7jtO9kL2raCQ34f2slcA2mfjN6zj0vrAJWP0LBF2e2gKSI5PFe4fmYMyOJx6xK6UQo3jP+vU3pHl9YLCzO6M6PasCfE00+NORe3i+mezCx+2B/Vrh53LFKn9d1By3LRSozHfWIjXCkYSXmMeRdjp6IDKdJQi5RuZyrjh0Uf8hfdi8t2X+z4uYlqgql5CGRxClZbTgCaynaNqSS1BLi1260oRb7fvAmNFumE9cxv6UJlpXF4G0+Xlvouue+Opb8iwEGnbA8G7yN8aCQ7d2naj7
 r++SivgS
 oT03PUb+ig8hcn6BW0XBJp7TFD8Xp9R2HZGwePHF4CZBU2Us73ET3NrViD+VeZjGrXPa4jhGWPYAAD3Gz/i2Xp0X3dzLqDeh6SlUDa7NMJb3xzeMzn85Srht0Fnv99fqBUrBV0WKV2wbSBn9C21dZasmKal2Is8qhmmtlvZKgtGktd48fFtmuuBSEMJgGy/0DFLLPqB4+zddsgGZ7lUQVJrpR36vZfzwavQvyelQu1DSrJL6NHVPbdPhzxfItybUXqoSkGxQDAzMSxcAZMjF9161qPapuqY4UbGPhuqo+PWBnUs/tmsMxIi4pVgXNUqwgHR8rNkQt9xvCnZsgtEIr4nClM8Hx34FjGhOmO9wVWXxMfDpEykvygvkCo2dOQPyqenc0qdV/Jaj9DE+VnThXcA7vzCUCzDG05anrjNEr3ho/popM53YcU7d49gaefK0tevqCsHgdS/goQegqOXI3C/isPtw5He781+YW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[Sorry for coming to this really late]

On Wed 21-10-26 15:55:09, Joshua Hahn wrote:
> v6 --> v7
> =========
> - Preserve two cgroup v1 proprerties that previously followed implicitly
>   from sharing a stock:
>   - memory.usage_in_bytes <= memory.memsw.usage_in_bytes
>   - Reclaim does not swap when memory and memsw have equal limits.
> - Wordsmithing commit messages for 4/5 and 5/5 to document the
>   cgroupv1 divergence (bounded) between memory and memsw caused by
>   independent stock.
> 
> INTRODUCTION
> ============
> Memcg keeps a per-CPU stock of precharged pages so that small, frequent
> allocations do not walk the page_counter hierarchy every time.
> Today, the stock implementation is within memcontrol code, even though
> the operation it caches is a page_counter charge. This makes it
> difficult to add new page_counters to a memcg and preserve the fast
> path behavior.
> 
> This matters for future work like my tiered memcg limits series [1]
> which introduces multiple new page_counters to memcg. Without making
> stock a page_counter-level property, it means that every memcg charge
> now goes through multiple page_counter hierarchy walks, instead of
> being able to cache these charges.
> 
> To make future page_counters scalable and performant, move stock from
> mem_cgroup to page_counter so that each page_counter can opt into its
> own per-CPU cache of pre-charged pages.

What does it mean that each counter can opt into its own per-cpu
caching?

> We get an added benefit of simplifying try_charge_memcg(), which now
> has all the stock management handled transparently within the
> page_counter layer.

This is quite a large change and I believe it will be really benefitial
to have some high level design overview in the cover rather than trying to
chase it in respective patches.
Namely, are there any changes to the locking (which is arguably quite
tricky to allow completely lockless fast path)? Also what are
implications to caching at different levels of the hierarchy? An example
of cache propagation up/down the hierarchy during
charge/uncharge/draining would be really useful to wrap ones head around
how this is supposed to work.

> EFFECT ON MEMCG V2 USERS
> ========================
> This series has no functional changes intended for memcg v2 users. We
> preserve all draining, refilling, and (un)charging behavior, including
> the uncharge path's refills / direct uncharges.
> 
> EFFECT ON MEMCG V1 USERS
> ========================
> For memcg v1 users, the decoupling of the memsw and memory stock means
> that each of them now manage their own independent stocks and can lead
> to a different size of precharged cache for each.
> 
> Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
> than or equal to memory.usage_in_bytes, because memsw is a superset of
> memory. With separate stocking, this could have been broken in scenarios
> where the memory stock is bigger than the memsw stock, leading to
> memory usage appearing to be inflated and greater than memsw usage,
> even though the real usage preserves the invariant.

How can this happen when counters are always charged together?

-- 
Michal Hocko
SUSE Labs

