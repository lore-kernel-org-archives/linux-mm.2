Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F940C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255C96B008A; Fri, 25 Sep 2026 16:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207046B008C; Fri, 25 Sep 2026 16:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0806B0092; Fri, 25 Sep 2026 16:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC7136B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:21:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CC64120742
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:21:06 +0000 (UTC)
X-FDA: 85253403732.24.CA88F8F
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B93280008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:21:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iDFy7399;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWHZht3/sG7ZvX5La1aBebgJu63RUAKhR/+jLnkgrMk=;
	b=W/X49ulkpuTqk7zMUuMykgsKC2ncwabSxWaatmAuhzumZOFJ+NEixs3T27Bp4rgr8dRLc5
	BBs0+IYi+vj87wu+iYzdlMISObBDuv4wmwU4AgEju/ISTeeLvBXzK/JHoojz9BshLri3uy
	pukyUH0rxu0YnsaTS8P7nLvlLLrD3MU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367664;
	b=bwg5UJ+HpcrQdQ2IAtyXFf4CSUkBCaobQ13Xq4YwlCvUFyWPtT0z/h7MS2DeSwWNnGvNzq
	0FJw1HhYx/5joU1Quq3ekIC3xAt8GEmuWaDY7wiplVwy8POJbMbbFwb8Mt0735FCXVOG/7
	jT2tvB+F4cbcKuVdQ6rClgoXLLJQIk0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iDFy7399;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0b89592d2so667969a91.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790367663; x=1790972463; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xWHZht3/sG7ZvX5La1aBebgJu63RUAKhR/+jLnkgrMk=;
        b=iDFy7399z7rUy5RO6RozFehyreedigOtxBeovDd2qIEzu6HDddFk9Vzu8fGzCqh+uB
         2tTupFrF5cYB857Y1aNuIxeVJHX6rjHiRxbw4T+k/0IGZgYtacqmz7wzyHpDTRo5fD1a
         hcQYEJnjBTcOKsNN1DcNJ1ujE2jplL+/qOnc4s9phjSKFc2FvFJjJQjrtfva3XjIQCZD
         Pwr6/MPe4hyU5GaAwHGsDF+sc37M9EMjmQqA0UzKssj2UBy9v2QhibUT5WPJiLiu0JNb
         bMVO1XdqFvLlfXvtt4B3NmgRGTImUUP2YavwrD0RqJiwsWO4wS0xcnntAiYhlr7deVTJ
         Wh3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790367663; x=1790972463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xWHZht3/sG7ZvX5La1aBebgJu63RUAKhR/+jLnkgrMk=;
        b=OWyYjfEJO9dM0B6WcON6Y9x3zEk0hkI2KueSd5vfmjjrT2L2NEXrp0oX7MVM1jqB91
         voQuu0vIkl6LnvVpLqT1fDfRSNksZm/Cz0c1Got8bye8/+Y2IGUdeuqcwpxir8xeEmIN
         PrrkoYo0dM4tdF5j6V1OLhWplo6C5Rp3O1ae/0AaQNoP6rPka1qJso2t+gglvw/qy5eo
         O2moH6v3goZV3sZUSa8+3TL8pNDgVvFp38MZtVzqLZvqcn19+T3GzhI+2k67Y7RuYWeV
         lRTRBc04QE5PlaoJq9BzQOYNYtC8C8gKJpvlNVKMGqZPT1e1jzZgHALeJYQSmkya2tfN
         zx+g==
X-Forwarded-Encrypted: i=1; AKwUvBw/Mc3MIM8yzZJpzSpPWz2i7OUIWwvgyRFUnfrv0W+yUWKAMRDerfoE2PdNjskZy0ygHtZlCL7Jdg==@kvack.org
X-Gm-Message-State: AFuF++kpfv6FaJS3OgHVUkuUVmqq+ZPtDpPH961Y6FAl/zidYdFL8y7v
	15WXiqI/5AeAEqahSL8D+GQLLwkLbVnDgpT/KWUAQhrElUAt6MKVOKjN
X-Gm-Gg: AYBFou3TML09AuW2D115VNUpcWtGbbzkzq2g1esSLFzthJUFJTMvKAUZ+B9u6o8Nfkf
	Ni+hfUVJ41sX3FYZZcUgdYS3tLzWvU8CCDs/5mOuJt1DC/im6ITP2aphYtsNBAR+Deqw/2cJxOX
	Znoc2RTrn+1M+HiiVOamaK4ytRG+virm0E5F7PpfI4Gx2gdjaoLqQpUK1aNJriPnIixjGhWfBDC
	bS53q35gB59REm3E1FhujeKmIquoiJDN+iqi+lgJKQ9FzQ3aYAawP7mOwBovxnV1kK2KGCYnzIS
	hHVce4/npojXCXSr1+bHtLCWBbG0750lI81Onpc/evUrMouNeqTvR+b5C4Edk3jsKD2+xxul897
	7U2XZ0gRdetbZFuM+IMV33rpB3nKWduum6iFcy8OludoqWAJcj/bmauavsv68RWA4T3kJd8b/e7
	UES4KVZWj3G3/yW1RGyZxIkxXVFp/+UbvLy7bWNvgQbxkf5olLAbf3uwSsHVYP9qLQlvohrB0Qq
	fcjjTG4X8jg+tx1arvOVrNejcLysaTMs7HojqA07erJuvs7DA==
X-Received: by 2002:a17:90b:518c:b0:3a0:dbfd:1a1f with SMTP id 98e67ed59e1d1-3a0dbfd269bmr214015a91.25.1790367663092;
        Fri, 25 Sep 2026 13:21:03 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99917besm5937983a91.14.2026.09.25.13.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:21:02 -0700 (PDT)
Date: Sat, 26 Sep 2026 04:20:51 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbUA-XwLBsty34_@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <arbGo3QTYlUD5cVW@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arbGo3QTYlUD5cVW@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B93280008
X-Stat-Signature: cqbszfdubouaet6pqx7x6h1jmchibiax
X-HE-Tag: 1790367664-493732
X-HE-Meta: U2FsdGVkX1++E38pz1qHJiBhXt2R2q/cFD+p2Z8oxETRPjJaXQ4AgqDnmnVwrriUZc326Zqv0ATXosOGdBhl/wZADGCZsZyrS3snKZz3dRqsF7Sxrfj9oBVe11rRXlVSarT9kpPOOOKfR7bkuZScvZtM1oIOk9jP0P4Ygc0exeIos70DW7+ZmeZYLOX5AFej2U87vOQykRdPBGIoGk/ZVViM+dOY7bMkROHMMcy/oS9BlJrrZrzQwisZApJtgduJmFfCz6r4NNIxI2PFkHECOJ8M5+dgm9nl8/NJtbTEdkOZ7sPLty68cI6TMIc10+OX1O/N4Kv8X4hVVeSVviw3k6j46W2PJCNTSVP4NqE+beSoyxQe7nun6W/HA0fpV5FdtdqaoMIgRVbyCTvZJtUPDOEm6lmFjJ62NIHHZ37rfCGxcblWwsql3dHKL0XmO/h+gvKF2gpn2xCZS6lKtmV5cQkvubHOZJNr5g0QRusy4EKIw5qQXUYjsLk0NfitOiG9/iX6aSu9DgLY94jbFqDlSzCH/b3uAofmvcEkZp2lpm5wOvNBxy/P+wUijheO5vM2+1l4m35CLfycBTiUACjGbMDrjDBnPlqJvu/gewSF5jEC1wnsmSTmcLmq9w+moTIDTtxP8e6lUX1Hlq/BjJznOcjii4TvxvCGIP7Knegva6rCJTWAG371Yp7Dy0sytx3E3LRl55IQyM5kHnJlm1KP9U1t66khhTn1xpfOQAQf3qMV8ilNYaiVOvln8h6Zg/HK5VcLeSg7nf7HGyRxcyUeWGfcFMdZHbmoQt2NQukLy21ZtOpJ7xhl1tJ9Un7vuz4CpxqpPFaUca4/VGJLnTBYDeFQDv8ciSArRAXaSFgs0qZuWSTgbSmUliqfxXJghkX6OnjwWDBqa4W4wOJO/7zRNExhwTRf3S6tJTO710aUTSMD0+pDK+U8gmM3c5GiZrHIxbGnDBnIhaGCpwqCFOb
 eq/8LRH1
 bi6E0Xj1Om0cH+cq5FdyGHK7xdtEVPD7X5xGGogkjh0WdwYdqe7pmFo0F1YcfLoVk4jtRxvDzXX63XsA8u9HuAX9AFhl67IGNF69JgIfDg8mc1OHlWgUFE3Biuqj6XPlJUmZjawE9pklIsHiqQov8OEDeCfZFrOZfqe6qJNkWRlXESSQJp/Vwc5YcM/uVTQbMSYNe/bDGseQg3h4FGD4FXdY5goru8FuoQdWFM0X1+E6SckUW0G1TQGmZMrZHYAVBQJVSTwtpMSDangX4Syja9ROqCYyf3Ye0vr6qr2wZcl+ZmyDUonhJjhkIokJ4ng+al+Lri5/SijyVvnIrdzZRHusCFBDvy7SKSf4d+fuaZc6ncFmXk1+GmKG6KuMxYKL0jvuzwxE6Dx/rhkZTSWFAJy6wsovUufkc93VOBjOAIgGSOPh850+SfySrbQgYthhcylSaRwX1fYZsU583mOHsqHpEkhFk7+2Aeslperm5Xnk18t4qcIFntY1XSkeBk9lPVHJ5gT/caxoIaA7q3PSiGX2Zi0OmbGF7DVrjNh2mcX1lnWiCd+etF159g1Xi25HNUz2nqpTQbjtgiI6IvdMSL8ZE+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 12:36:46PM +0800, Shakeel Butt wrote:
> On Fri, Sep 25, 2026 at 09:15:17PM +0800, Kairui Song wrote:
> [...]
> 
> Thanks Kairui for very clear description of what you want and looking for.
> After reading your email, I think you want memsw support in v2. Currently you
> somehow are implementing memsw using memory.current and memory.swap.current.
> (I am assuming you need to subtract swapcache to avoid double counting.)
> To conclude, you want to use vswap (the aim is it to default) but you still want
> your way to implementing memsw keep working.
> 
> Please correct me if I missed something.
> 
> I am wondering if you really want memsw, why not propose memsw. Someone from
> tencent proposed memsw [1] previously, so why not continue that effort? I am
> pretty sure folks from Google (people who actually work on prodkernel there)
> will be happy to collaborate with you on that.

Hi Shakeel,

Right, I believe it is still being proposes as you can see there are some
previous progress, year that work need updated, let me try to do something
about it.

> 
> [1] https://lore.kernel.org/20250319064148.774406-1-jingxiangzeng.cas@gmail.com/
> 
> Setting aside the memsw conversation, I think we should go back to the actual
> vswap conversation and list down what we agree on and where we still need
> discussion and decision. (I will take a stab at it and start a separate thread
> but still on this email and will use AI for the summary.)

Right, the things here is that I think it's not hard to see that
memory.current / memory.swap and memsw (if in V2) is tangled with each
other so I'm hope we won't create blocker for the future.

