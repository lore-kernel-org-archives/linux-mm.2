Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C29DAC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10716B0088; Fri,  4 Sep 2026 11:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8276B008A; Fri,  4 Sep 2026 11:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9D16B008C; Fri,  4 Sep 2026 11:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A88F6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:43:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E62BFA0052
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:43:54 +0000 (UTC)
X-FDA: 85176500388.28.E33AE00
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id B797A40006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:43:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=etpTHB87;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788536633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKmfbONiKhT7CrkzRLhdhFZmjYER1RIKBnciL0qdhTk=;
	b=8HqFYUt0lzLf6NVQBe6D4pAfDXBbDuTKieu4Fj5gR2plLQupvbYSrbsGjBDennGgcbElwu
	XkIEBUBQgsTwFIcHcvIcXypBUJp2ndneCWAP0zK5z6Gh8Clhkd8dazW3NTUZkttxeze7L+
	lMEUAt/7f0fmWga2ueHyYsfnEz5giKo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=etpTHB87;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788536633;
	b=vrrJglkdY7oDcpq2HHNmov5RJHKFbM6ygHRaXkpN+0lGNmjNsdSVO33shz73SIqONkJyJf
	T42KJaCVo6/ZFa+0E2mIVP/bv+mkGR5CjuUiUqqsO/hJaP0MlTJSmQRp2b3hQlEY8IqJgc
	tj6ORSVtYXU9ZggKfpkXOIeL0jo3Z9k=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-66fa996e65bso2225700d50.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 08:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788536632; x=1789141432; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xKmfbONiKhT7CrkzRLhdhFZmjYER1RIKBnciL0qdhTk=;
        b=etpTHB87AZaJ9ENCdXCdjZJC6GSEr0NmROpq8HrjeFAmuZu/Mdh6UsThj0FutBsfAd
         rtBlAMS9XF4nwHvdrbGjw1MRPfT4ALV4EkaF2ASzuitgPEyJu/zq2BMcII3KEGJbODzx
         rX0z5J85ZD3DyoTnx2HPZh38YR8IjGTA9CkWmrzZR5c7ykHy6sq/UmKsHjtnAWJFfbXX
         sBxgo/68Wqxn1QoI6K0ZmvQ4rGdRyz60Oy98qPME83mBwahvgsMg5aZTnjDpWbOvNZUd
         zGyjxUXCNnT1v1ozZ8Wv9oXcz7oeVV+GRNSYibrAnRR/0XWuesT4VsVafwXrlunrX8XT
         CafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788536632; x=1789141432;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xKmfbONiKhT7CrkzRLhdhFZmjYER1RIKBnciL0qdhTk=;
        b=M8lMs/swvKyMbMltEgFoDL3XIVaLi+LL7LhIfpdP71OcNibWO8OZMjY2BmRJ6EagFD
         gTDBpqXXjLnwsFw8gN10/NQ6jiC/lUOrMPBRQSUbYQ/fEDC76bcJmwP91/I42Ye2u68c
         suV4YL9azfbyh+mKpjdg8j9TUfBECGYv4cdFjwpIk0AJF/W3ya1XwsUbWk7JcBNoMNuD
         twqgBXAfIu+IPgGiGhJ7ky5XKb07sw8QL+nyhEWqalkIx2iLdwEuhiEY47PM6SFYqCpM
         dweWVpwWX5r4fS2ysmWCDeU50botxkVAo/OMTPuqGhDGfvRy29Ubof9eM9tftLyTOzFP
         pJ1g==
X-Forwarded-Encrypted: i=1; AKwUvBzsbLSjmBasQy/3f3hIfJy+DFg2eYRWal64EXMz2tu2tqe/Rx4ywwKTi1pZfRaNye0IGf5h96LeUg==@kvack.org
X-Gm-Message-State: AFuF++lT6zhWdlE5aqzAYohQ8RCbrka7H14Uw//pKUTKv/lSbQ13hZAv
	65h83KfQs+72db6Dq6rE9co9pq/yvb8AGXBFTC8sPZKCvD6a+Zxy4B3xg0DOPyD7wkU=
X-Gm-Gg: AYBFou3ilsjqQSKlHs3veYL/VGMw8dmii0q9Q50s0X6IWjn/Vj02s6FjV60lGmSpIz7
	V7RjYgui8LIIgBUTcvfDTqtChybDv0YEgPsVebEBVZUICVsR61DozfGQY0mcsy5+L5+cHqNzbpt
	jjyuUMc7wCIHZPXCzSb4Atq4lzAek7cpPLGt0lSZRXnBje1PZ7/38N67Ib4pYaIi6lbT8EFgD6t
	KWGPpyDfjKZfTagnAzoQSn+/r8TBVsRQL0wlA0RvOU4Twpbf0rOVfLFFUBYf7PEmjbMQ0ktHsUx
	3x+obySMeIOr+zLjrhq789/b1XTMEsvO9Cbdu3oXUfCtHvtNl9i90dz1os4GXdyEXwqWGSEZ5K0
	NaSFPfPR3G3/wRSoo3ADLQjxLeAZxokCTUl5PDrbluxOrJwKOBjMR2sVPFsqtL7gkHMwOAJqbUU
	StSwL1DVGGhrgeyXCro7urGaHUXTXDchNBR8L+
X-Received: by 2002:a05:690e:4419:b0:66f:c1be:84d6 with SMTP id 956f58d0204a3-66fc1bf5087mr550972d50.68.1788536631738;
        Fri, 04 Sep 2026 08:43:51 -0700 (PDT)
Received: from localhost ([2603:7001:f100:501::2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040664741sm23243936d6.22.2026.09.04.08.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 08:43:51 -0700 (PDT)
Date: Fri, 4 Sep 2026 11:43:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nimrod Oren <noren@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Hugh Dickins <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Message-ID: <20260904154346.GB6641@cmpxchg.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org>
 <aphS2TancJAZLND7@gremlin>
 <20260902183752.GP3004@cmpxchg.org>
 <aplzo5Jsb6f1MdaM@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aplzo5Jsb6f1MdaM@gremlin>
X-Stat-Signature: kjtkkkn5k8guxtd767uxfsh7xq4ac7cs
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B797A40006
X-Rspam-User: 
X-HE-Tag: 1788536632-874786
X-HE-Meta: U2FsdGVkX1/DUUvnrHTrdgJog+OO6dKDEWJHx2qjT6AlRwE6JkatmBq/61LDxGxuW2QjAe19X/OLTJjaw9Ut3yfiT/fyVJLOMDPdb8Ve5Lznmg67nqpQV/Bm3xx/71JrmXrDHqlxDaIbOonFdo9etloVb1YGkkjGR+hc8ETvfWJdBSAx8x8G6ZNkjFZT2iu0SOGj0CFIVOZ7MvgnvkFRGFSu3uQjfbfOGaPxXUoQepMu0DlM7DtUbMBYz/fFYSI/WLy79BmAYI0rHOql8XTN7bdOwGb1bt9iywWm9MGmfE3IwyINVsrBTYYaY1nVgjJId+J3vwtN/Ow9uLlwQxK5xu1QqeypyD7dVdizwntVqigW8cdVyDNfyoM3tArgZHEpCmXO6tvHXNsdjs7s4O+uVQHk6TJ9mSTcgbEtxXvWjOBhriaQ3bJ0SRjcncJ4ybK6PkAYXv87HxtyFZTtWMxUarsNuDpxOqqqtfmlUHvICqgBqmfQl0E7G3r1stabMpdr8X2vidr/ZjZpdCIbjWo7c6Xh/dAWgU7a5rQu4g5i87PRpJMytASlTJy6vDCXxHXTY15XHCntIytleYPLeGFG8PpoeR6WkvHWoQUzm3dw0AlLALhG/b7zwW9dfJQMVkZiKuhoMdPd6Dneaovclph3dQOfz9cjSpQulnZ+KmKNFc9ba3gQKQ32eI4X+Tx6qNaEAufaqeE/YD9kArFdV8TZNcVDwNVaIZpzvbzTcNzMI9XY48V5zHhSvYnl4yq7yL4oxfcshi9+/I751aQvTEQzrJHc2PlAwQ6LodxavIsjv4EUCOi1TCTZmELnVDmzeH2g1nfuKwK4P1WHo1G+A7LDIM7DSgzWcS/DBVzqjsN9Bmv2x3dAsGV7b063eMQjh2LE4Xgb2SoyFoiKgpuk3UDg7BrvcXBlNmobO4VRfJmtafxKqVNtsnj00OrD8DH1iTF857Z5c31lUvOK0rdSe4K
 XOiydH4v
 4xXdZLOrcpHHm2T+EEboFsXNnKDRG26pe6WQiOKORo6oflydkuWJhAqPQLkUBJqc7AxVXUNHo/cac4yagyL0JiZZO07RcdCiyz6+6V2m68zHATQDP+Ft5JC8Wa/4yqCI5dEJU+IafKPImp+JLnu5S1UmXqPiZdbuVmwujk2xA29QZ1shZD1I+ht+AiVE6Kf7FLhJai94SJheft5b0cNMq80iHEtln5WoXfMdEJMj6fhy3Nm4CdM74tw/fwyn7C/GMPFaq4UAK3wkQLUCuNURR8ibDJ6KOczlpfwQzw3CBh94/cHh1sXT+UrT70cpqefXPyrRX2ER8yUMnMnE2+OrvHVEz9S4t9JFmwNh3nCEynss8gD8I55WvS/E65Hn5QEgY8YSOPPuTZlAOHvHA0oeJm3kwkUwwG/JLuxMHZkRiySB+Nu4HAg4tss0ioPpiPe0NYwqogc25QjDBTn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 04:46:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> Looking over the sub-thread (correct me if I'm wrong) the issues seem to be:
> 
> - 512 MB pageblocks become unmoveable quicker than expected
> 
> - When trying to convert a pageblock in try_to_claim_block() 256 MiB is required
>   to be of the desired migratetype, and this is difficult to achieve vs. 1 MiB
>   (yes clearly :)
> 
> - AI training checkpointing was a problematic workload - big latency spikes and
>   timeouts. Tonnes of unmoveable memory, order-0 allocations falling back to
>   MIGRATE_MOVABLE (ugh), exhibiting try_to_claim_block() symptoms above.
> 
> I hear all of this, and to be clear - this kind of real-world data, at scale, is
> the kind of thing we should base decisions on more than anything else.
> 
> Reality > theory every time (and the more you look into the kernel you more you
> realise it's a tower of heuristics anyway, especially in classical reclaim :)
> 
> I guess what you're trying to say here is the only way in these circumstances to
> make headway would be to have more memory reserved.
> 
> But is that the right conclusion? Aren't you still screwed once those reserves
> are chomped up?
> 
> Or are you saying the increased watermark levels gets you effective
> kcompactd/kswapd sooner?

+1 Exactly! The watermarks sit on top of that reserve. Both background
reclaim and direct reclaim are thresholded such that there are always
a few pageblocks worth of free space for the allocator to choose from,
thus reducing the risk of fallbacks and block poisoning.

> The TL;DR for me is - you have a workload that's broken already with larger
> pageblock size - maybe you could test that with/without this patch and see if it
> really does help?
> 
> Anyway it seems to me all of this is essentially a (valid!) critique of
> assumptions backed into the page allocator code.

This part I don't quite follow. Why is the page allocator doing
anything wrong here?

You tell it your largest routine allocation size. It groups smaller
allocations by their ability to move into buckets of this size,
coordinates a headroom of buckets for non-violating placements, and
ensures reclaim kicks in when that headroom depletes.

You're giving it a very large bucket size and are not happy with the
headroom that commands.

[ I'll reply to the other points in your email later. ]

