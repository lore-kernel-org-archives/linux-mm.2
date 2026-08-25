Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EE5AC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A686B00CE; Tue, 25 Aug 2026 06:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4146B00CF; Tue, 25 Aug 2026 06:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5FC6B00D0; Tue, 25 Aug 2026 06:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41F5F6B00CE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:51:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3C70C0389
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:51:54 +0000 (UTC)
X-FDA: 85139476548.20.ED2D7FB
Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9ED6D20002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:51:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U2Rh0scN;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787655113;
	b=cTwTyP7B92KXtuAv+DLWqjqbQm5Lr8ERaf48V8DTESQ4DUTPUb3c9bdqFFoWAef/i0QAl/
	HdxVXVT724FuwnKdyasqvxKjiiOVtzz9MS7Vofwl67N1y6GP1cYD3j0Pum7F5J6FXGsrnN
	N2HbuWC9L5yubSDGMgOubW6XlcuTRkw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U2Rh0scN;
	spf=pass (imf31.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787655113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdkDvLUUuVg9gB2EomGx4vsYuQpqiMTx/DSjJe4vLaM=;
	b=6Q7l1OAWm8xi2Tm54moCprRHryiBFp5Kc27UE3oCRg4XlAvC2kBvbWkTur02qyGjUZjpX4
	xea1Nkcq+e3rc/7yZPeYHZiedi0R7830NOdiGHbvcgriJuBLcTIZ8/U+IGipEoqnocIXm+
	+4xh+4EY70nJa+tkhe8tBgpEDcaUzO8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1kptbS9Xxr7JsUyG7MV7yG3aF8sPPAp67Bzvk/FeIxQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787655111; v=1; x=1788259911;
 b=U2Rh0scNWwHQJKif0nwLMAYvE7V4kc1flkm5K5HnO3s1O0qRowArnVHTNaeF5YHVQXkHyfpU
 qGu86avCqGIZAyD2ba4IlPyo6hIzprZvWYPyw8aR2PSgWQyetFC+6Hv3k3NBetsb+58TNxpTtqe
 GlRdZ8nIEeHgZip2T4qWZc/g=
X-Envelope-To: linux-mm@kvack.org
Received: from [100.82.85.74] (101.71.133.200)
	by smtp.migadu.com with ESMTPS id a8ec164d6dcd91e4;
	Tue, 25 Aug 2026 10:51:51 +0000
X-Mizu-Trace-ID: a8ec164d6dcd91e4
X-Migadu-Flow: FLOW_OUT
Message-ID: <3a3d0eb3-8350-4786-b5fa-bbde9d83abeb@linux.dev>
Date: Tue, 25 Aug 2026 18:51:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/17] mm/mm_init: factor out pfn_to_zone()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-7-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260825084608.47437-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9ED6D20002
X-Rspam-User: 
X-Stat-Signature: 73hdeqx8ak6z5whkzy7zgx4chx8jeopy
X-Rspamd-Server: rspam06
X-HE-Tag: 1787655112-883970
X-HE-Meta: U2FsdGVkX18LuhhnFMhXwCln4TRPPkPPCoxRi9jugKn/DU001kvLcsjcSpS4kFVcUVmbEYOi8rkNLbafkyRPFNRqMWDE3ygbaiX/6tk5EkiSy3pVXRZF0bXJdWWRecQ6JJnQDsqrK+s4I6jIzvL44AQAkDTutsIMv37c0qyWfXIJ/DNdiCYsxAEqOYE+6cOXG6FnmcNitTSna55O4Bzk+Hb2+57mxT+8rhOt/4OmBMzUhhO18NYu/XG+WMBPBn1VXxjPkjHf/vfBpTP8RMkcL9X6EXtFlW+07mpNqvo9fuGdSflxXNZG+gZ1hUYcuj0F5HwRRTTxvJanbxiY/U5t/TcU70n2rnUExb1GahNxcMzCBXBVlSmVWiVcViiTv2VM8m4uF+/njjizsWT6nbfgnJL0I2eBYbxbfBlHnn2KJmEYPOk2rTkzCHrEsyFd7i5gTlSN0gLK2ru9agIpxjVxeHjWSu/e5lhtnqrUW3Puo/FqyUDJLYMqQGqBeH9Pm1R96pZqs8TxzEalo9D1W5pQh4rK4CWP8MNWqkHJU4iuN5yGrv+UvS3gjYo3vKFBVpK5vnAmGaxOyqal2o5w4mNzsCIgQgHXQqnx6HWVyK/N4ghojv0fm2q8YI+EfMM9bztzcuiT7QInTBcO/fnVSrURZNnwD50t7PyRiG/bcCb+O/PEXVatX5i1kscF3eo6z40Dndq2lcdh5e/R0kKGvET6EiTL7LzomeMuV9iabRGY3oS+7pwO0wAcAKiuj1v4Fh4iiRdsgHO9cLTmO0juukwg0/p5SRwRJLuUc9LYWd9y3owNeRvZfeC/3chIpDPmrO/WmqVH53f0/2WIYFvfJK0JPBjljSGFr7G49WJEt2QJKTrQ2afSSBM/kez08rUz2h47QV15/kAfQoPWb9JzKTr3J/B/79QKkaPnagvsuqKnNSskVxyyMOAgHn8cfW0mR79/UAJS1dtFv9UKdFDHEue
 3e1137aB
 WIWcvKfPdBeYSP5fo+pBpydkZnsmcKsF9u1J5lyyZm5rmJ64ync0W7JbrSopCYTBEgfqCqcl/Ib54x+CCb1r9QI+sdxOwp6Y3fLcysEaHWHuGlUTQOOtjHj3/K6GTL0E3Cu4qOvjHDdQjmD9TMgssp3Q6nPj0Od5EQs3qCxK6Ntuv70CpULTC0uAXrfMdns9znWspgreV5uLSSXq36+LGv6/5o3G+NCZ0MGRbDGjS8l1yLB0VlFh68o2UWzIR+IduIgqdpGw0zsecnM6hpcj/p4fzUVtFq8K4kLapxKMdflh7T95SO640atsCXaihJbBbQkTFdUS9c6XSwFiSwtbP8cU+bw3CRV5zsBZnWHgbMZD7riQI0Gdv+ZAydTcaS8tZq6spTWidG8VirCSSqFvgPsj6HQKSHhWveChWqXwh39QW64EmS8QUCH2n2ncoBp/6yvnH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/25/26 4:45 PM, Muchun Song wrote:
> pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
> __init_deferred_page().
> 
> Move it to mm_init.c, declare it in mm/mm_init.h, and reuse it from
> __init_deferred_page() and HugeTLB early vmemmap initialization instead
> of open-coding the zone walk there.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


