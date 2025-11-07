Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A594CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 13:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8448E0008; Fri,  7 Nov 2025 08:22:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA01F8E0002; Fri,  7 Nov 2025 08:22:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DD638E0008; Fri,  7 Nov 2025 08:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6A88E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:22:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C2DE140489
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:22:19 +0000 (UTC)
X-FDA: 84083874798.17.90D82FB
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 257B9160008
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 13:22:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fbp2B3oO;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762521737; a=rsa-sha256;
	cv=none;
	b=CLHz9JRICpWSdd7pMh7G+JSw7KlkOfTibOzROhX0hEV/b/3dX2P+PUjMV23uQnvV+qoc9f
	KpPujywBIFFoBuV4C+U0IHf1cL3Vq8e0MtKPjXtum7n1vzDMsmfjijYCNI/XfN8t3I0Irc
	Z5D3Vto6NS/e4i9D4V6YVWsovm1xTQs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fbp2B3oO;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762521737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BW73tny/rNjGjbXRK/CCOTxvH5raxzJjwlFOSIFvCv4=;
	b=rSKoOFn6c1SZfZUrUI/3Jrm/uzDS82zxxKdQgDvvZI7sC5WWYcRcKh98mnPTHBtLfLl1ai
	F1VZTywUIoL1335lKvieh1DIbwy/FEZsvfloHQTWz6U97QwT98Tg82NZQ6gmKkDcyfux87
	QNLzJh9RxPKwAn3bfCsen+UjrQWyd0k=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b72dad1b713so11549366b.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 05:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762521735; x=1763126535; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BW73tny/rNjGjbXRK/CCOTxvH5raxzJjwlFOSIFvCv4=;
        b=fbp2B3oOXXUUR18/uZuqQx5F0hJcmN6a41R8lTt4bPraULjwDDYI7o3DuCPwAvZRkq
         QtnDWTjEV3s86w4HHQQ9gKHAlN8dHTkuPzU4ALY4XPI/baGNikdBqqD4qweE+DcTubb5
         j2U7CtiF7EVOwIhCZWGJuRjiay6DGCKHFZmrdHGZNS6D/J/hiDHs/3T07QQ5k4Is+EFg
         A2yQAdwAntphhL/IHfivHdaPEwmFaZ0pa8ODDX4gKF9x/KPvWNgdvRAhTvdvY92wf2Kv
         uclA4WQSVrw+oZXLZhfF9QvSuN5oPs3WdlLOy3MRV8UuY/wiHiUOzX/4pWHC33cLoiyH
         rS2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762521735; x=1763126535;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BW73tny/rNjGjbXRK/CCOTxvH5raxzJjwlFOSIFvCv4=;
        b=m5feOzfsz/NuevNb4Vw5WCDMt6y4jI+ON97jBSeXOcYmOXXZiqBDQHUlEX/WzSSNzY
         AeXp0oVj118eC+Jiiyuj5MxyOI4HdoXbcdpJW20bTB2kJtPekBzSWJAs202KoSG9imRo
         hewIvpsCoNIGiIAn4KnfnDUtBRXwmUm12RIFfu/iXf/cvRTMazNy+SFVuMITOdDwpGAP
         ktfQ22frIz2/uxaExkoQtnfekPwdwlATwuZYzeZtedWJ2o2H9933f8Qiq4r3xiJB7Vaa
         zVu4W+/gTbRi1s4PXG39vuXjP4WCP1TNMDQfSY/v5fDkYoQCaNJTX7VDXW17+TOh+gu6
         4hiQ==
X-Gm-Message-State: AOJu0YzK1nUQjWppyGq9rrd91Z7CzTV9w1+RkMLncMmVoqsXRTIRsxpV
	FX9vMlCKyNTDHmFm5B92kHsvK5J2NY1ZUQVxH/fJaWVMHJaWZag98rHz4D7YZqj7MZ4=
X-Gm-Gg: ASbGncsC/fgvsmiDIRdBhamEAolIP899j16xi3pfVWOEC0HFLZI9mP7oEQCVLVXd9Cg
	5LZ4embKy5a/Q02jwQDuGuIRCb59rB41h2/6xX6Rw4zcphJZMDPhGW0OL2ZF0ld10jvjRCFClvS
	dd0oAivzy+7JubiqcinPd5BfbC3ud0DOr8mq4cBC+jOgOCDr1NTbOJ72Hgin9v+p6ffIIseZYLi
	BRYXHByWuYrumFqyI3lc8Zuwr2aGj3YdeRvRr9Pw5fWUfNpCQ03KgHrl4ZpxcP9BC3iC8xMj2Ai
	fr4rpoFZMBvIQt14kF0tJELgPuZiOPAcvUY86gI0oMvuWxPCetv93knLJAJ5VyNMo99n0CRNjeH
	IDGE/PCvtjW5EsefguPC2fBqNdSJkgsx0vis8D/ezeVFziQE+GcKxaXq5SvSMy2wBiTN6z7CKQQ
	WqVEmDOpp7cO5cUg7oF/SvvD9Y
X-Google-Smtp-Source: AGHT+IH+ShbDcZE+qh4SZkqFEhzUdrx2v7L/xU+R5lqvkQSu+xhB2RSlNKbrKOFBDGQaTsFsa5ikmw==
X-Received: by 2002:a17:907:971b:b0:b4a:ed12:ce51 with SMTP id a640c23a62f3a-b72c096d5b2mr296847766b.23.1762521735393;
        Fri, 07 Nov 2025 05:22:15 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf312271sm239966466b.19.2025.11.07.05.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 05:22:15 -0800 (PST)
Date: Fri, 7 Nov 2025 14:22:14 +0100
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
Message-ID: <aQ3yhmsT2NHeNwLi@tiehlicka>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
 <aO4Y35l12Cav-xr4@tiehlicka>
 <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
 <aPEGDwiA_LhuLZmX@tiehlicka>
 <46df65477e0580d350e6e14fea5e68aee6a2832b@linux.dev>
 <aPE84XfToVH4eAbs@tiehlicka>
 <db4d9e73e6a70033da561ed88aef32c1ebe411dd@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db4d9e73e6a70033da561ed88aef32c1ebe411dd@linux.dev>
X-Rspamd-Queue-Id: 257B9160008
X-Rspamd-Server: rspam07
X-Stat-Signature: ps8p7o6dgxttay8js8u4rreoawu69m7f
X-Rspam-User: 
X-HE-Tag: 1762521736-377194
X-HE-Meta: U2FsdGVkX18pUR5hZ3HltJ8pUImI1b9PSM1sIcEa5UEAr6/wKlu/6VPVk6M62sxFSFB6wNC8bTF0qzrMk209u9wOeYZa37CAf5MHi/MLC8dRfuvRqFX6nxaTWR6U+bpzbG8jHi3vVTYpIX3n4iXXHOUlTE98o9JfyLAaLN4t5YLnJMjoUdMEDJ1N1pDoLfTX3aVhSoumGpTsvhu8rja7BeO8MXHlFSjmT8vY35Z+6zv02UG7zj+Q+BqC5M1i/PlNFWyzY1fO2HmDIq44j85gBwMcQFmX03rQLYgcw2JxXFVdfJaR8esnZZgwh46xaaLHZNfsCcyyHoYV8X4RkWstBneI11k2neSu5sOPrNgtvHDtV1TiksswttGtYhGNAP9o8YYj39lFf3z5qxpCXS4VH3Aao4pUa34fSElg38MjLEjRZXeWINlwaBaxOiGElQrhXbtbNHuWROSG8LSssJWW1iTa7+SxFbfCGtsMrAV/jnXIEjl1WiTABxkAB4lTyR9an6b6cLGakjd7mQfC5S5mPgAofpNYqj0eTAbEY1/L3lmFnV0BUcvqbGdFFp7aorj/+YVlq6ren7vq1mPk2rKKi45PYbGhAu3LD40ZxUjoklGXC4QxwaNQhzkcgfikKQLxiyfXzeaGc4PksYT6ssYMCN0uGmcaTGTPDQn/ahV7mVRj9cETvDb/x9VL5+Okflf/oS99kzi59QKm29BA+36MiENFrwKS4dStZ+ia5fzmzL9nKKPmR97UgUtLj5JW5tbdyoj6lSqA9WCjIAQ7t72TGDgWboT7zLsvuTpaPGZGkUj/N46JOLA1YJtA/yHobwMhMx3vlMufOlrBxh/NNsBBCVX98bS3v8dVxyb+BuqlBhj51rcKQ+G5kleDwZ5VI5qeycZ6t09JPaLxPsQGTh8kNESb4ZaUBIaQJCYmZCfWGL+xwhqVuFSLLfiUycsrVPfFUE04hropWzktk7ruTqK
 cfP4yzgH
 eSdGodEO5PPIaoP722AsLQnszbLw93OyW15KGFaFaGJX/j4rzVOn2Cph2ShvAmRg8AETvo8IicYPNx8FCX2y2nmTU43Ekkw+KVyOGbMaD96Ue7ZPR8WwUTYJlaxZKAg/BoBP2/stOh0zoqajrhPEPo5+iNSN4tV/MZeiTTTQ+bnH3fUAifWHTj3WysNe8uELOF0VsZQzpwz0idF7684Z33HbfiakReJnKialh4DeM0qHMCGfeKx0VYJ/69Xwn/HLOotER950mHdKaoINd57F0lP8wPJR+jESpS0wC9BqvCQD/4lZsz34e4s/UFTqyLuA9k+ZC9pmXyHJWyKKMotOzkhO1WJEXR4VKBSt4b+RanDnry8TFZFxImY7ADQYyhE2apTErDj2Dmo2VFZfYrnFdvXQ1z2UIdkq3vqZeaiTjzFa515tANoQiPHVYPuQNNX/9U1v1gF7Vqn8RazpmUsQGKEGfWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for late reply.

On Mon 20-10-25 10:11:23, Jiayuan Chen wrote:
[...]
> To provide more context about our specific setup:
> 
> 1. The memory.low values set on host pods are actually quite large,
>    some pods are set to 10GB, others to 20GB, etc.
> 2. Since most pods have memory limits configured, each time kswapd
>    is woken up, if a pod's memory usage hasn't exceeded its own
>    memory.low, its memory won't be reclaimed.
> 3. When applications start up, rapidly consume memory, or experience
>    network traffic bursts, the kernel reaches steal_suitable_fallback(),
>    which sets watermark_boost and subsequently wakes kswapd.
> 4. In the core logic of kswapd thread (balance_pgdat()), when reclaim is
>    triggered by watermark_boost, the maximum priority is 10. Higher priority
>    values mean less aggressive LRU scanning, which can result in no pages
>    being reclaimed during a single scan cycle:
> 
> if (nr_boost_reclaim && sc.priority == DEF_PRIORITY - 2)
>     raise_priority = false;
> 
> 5. This eventually causes pgdat->kswapd_failures to continuously accumulate,
>    exceeding MAX_RECLAIM_RETRIES, and consequently kswapd stops working.
>    At this point, the system's available memory is still significantly above
>    the high watermark—it's inappropriate for kswapd to stop under these
>    conditions.
> 
> The final observable issue is that a brief period of rapid memory allocation
> causes kswapd to stop running, ultimately triggering direct reclaim and
> making the applications unresponsive.

This to me sounds like something to be addressed in the watermark
boosting code. I do not think we should be breaching low limit for that
(opportunistic) reclaim.

-- 
Michal Hocko
SUSE Labs

