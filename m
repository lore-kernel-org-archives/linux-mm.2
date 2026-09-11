Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C7BC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 03:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DB0A6B0092; Thu, 10 Sep 2026 23:19:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9429C6B0093; Thu, 10 Sep 2026 23:19:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DD486B0095; Thu, 10 Sep 2026 23:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2956B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:19:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C12D8806A7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:19:26 +0000 (UTC)
X-FDA: 85200025932.18.1B17B04
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf17.hostedemail.com (Postfix) with ESMTP id CEBE140003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:19:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TsOzOO6g;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789096765;
	b=xqjYn+2tLNm1UtGgOCFvijnBjCObY/8luD5VDtgOdP5h3iSzUfpuxgq02NYpPtVWX9PWcj
	wjRlQRa667ENXlOyzIh+ZkMzyahRgPxpj6DZ8zNtB7QbDIJ2eTsNWFO/fsWKaZAtrtVLDG
	plDfHGasembxo2zw69qegrU60kHvsMg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TsOzOO6g;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789096765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHye6fXV6O0BwmOSmMkNW8tisA69YmRVUOPP9SEpvNM=;
	b=mERkw2a/2U7bQPelCsJzfdY4ZwTozmjb9EMVMGiVAqOCfN+9arTuMKEhKyJLYxbZauyiio
	9BAtri+dtZhqB+9pa+XdXmsaMTpV50+QQ3X1J/Hs3zKdx3Hg4Bj16v0tZz1gLTmXulbLwz
	Pr5I+/w/N3hoh754/yyuh0juf4IPiec=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789096761; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lHye6fXV6O0BwmOSmMkNW8tisA69YmRVUOPP9SEpvNM=;
	b=TsOzOO6g1o3cbXVRFCH+nDpNjrJT9fzsKuQ0xzluO8j4DTuF1G/62LLdX4GcIGfStujdoWmElrDwqvL1PoYFYCJ483zAMAjPDAQ7ApdC2BiF4dboo5xUfN5bQ5Efti2TAJOKqYGmcZQ9aVJ0wgckC8q1yokqZPZQQ1w6kW4L6QM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XAj1PlA_1789096757;
Received: from 30.178.68.86(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAj1PlA_1789096757 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Sep 2026 11:19:19 +0800
Message-ID: <0b1ddfea-4c1b-4726-8a63-abe44edbea66@linux.alibaba.com>
Date: Fri, 11 Sep 2026 11:19:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults
 with non-blocking gfp
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Xunlei Pang <xlpang@linux.alibaba.com>, "Liam R . Howlett"
 <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Chris Down <chris@chrisdown.name>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
 <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
 <6B46E8DF-679B-4254-A4AF-7B992B0F6460@nvidia.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <6B46E8DF-679B-4254-A4AF-7B992B0F6460@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CEBE140003
X-Stat-Signature: skfbiydujc6csg39zme4fbacptng86zb
X-HE-Tag: 1789096763-248032
X-HE-Meta: U2FsdGVkX1+xhowDzYiepB1r07iSpdHdFBRVR6Ryl//3+ZjkUuOSAaE6+rSTBLlXdaUV1pBNXT570k2vYmODX4zw7MeH96Qn1+grc4jbxRFqkFwPqH/l63qyY4SOJmBcTmFyNCwJbpkMDh3jRUtPVYVqm7/bQ9EVC8WkxCN1bckDrWQyuP0CKrnbjQSBLrMy/pUMn0RnGuzWwiYdunB0SgPwmEbZ2NBWUe8H0UH6cILFfAHaHsM7TexnTtfFyseyz51Av8BzqhDW4E8wTY7a1b86wPD2CsCXGWi9ss+ixWRVAMY5SHQvUxtSU6kWTjtYXB+zeTqyrzged2EDpxRWyQhJAS/jqZKzDgd+GVRYakh+N9kkopEUasxgUDohdvJ0WtHjqroJjHJ981wu2ue2EcApCJj86FavOfPdlSAy2WOGdgj26+MFCvZLVfOHM/JmNXGNAKMeg5MCA4FkFikmFStAYep6rCmZkCllSAe9X1ZPi1yGK2Z1q/5u8LfFYcMZTPa12Wd5EYhi9qrpsaHHmb9DZra4LalXlduXBHjyqzHLcA27oa46AYoYdkxwKWKYvGcoRTxKpuc9KGGz5071PMi11PUy7UexM3iTHaY7/ubmjoIIATtB6ggxXnRFzot/KfJA1fLqT4DDZga6j/TrJ2lEW/9aaNNNaQpPFAEQ5H8MQWMM8qh/LOWoFUSqWhLE/L+iF/eI16dwdonOe/qIEiZnofGSyNKLi9qGVjPPffREnwXM8HOR8ob7ugsGpWI66m2ceCZU+6zU22V0mTPTEfq1i9DtEPwBVqGGgVL5EEHj4IC8RKgJHN0vYyaC7tFiKJk89Bdy3O3rhZcobAKD/4o0O5eaFGEC/qJ7O5InOc7rWN80Cw8ovoddgFPGCTnhUN7Kcj+yfa5DaB+sOqu8xQO8Ft+0e9TaDzvnlPt8E/Dzz3tnuPWA9VpbPJzuovrfXpodXICMyoIdQ7qDklH
 DnLfUdGg
 k3KYmbtUC09uqsGZ/D/5UE+z9aop+wGdrvu7RyIUpaKZwxnyqcrvuLhMXSClItdafDtB0EK9DeiJ0kB86aU8dbsCxc2SgAFb6ugcjLoJXZNYB/Yum62Xkavob5gJqBTr6/mPinUyR2nMMbuf+EytDBtLg2CuSNL1Blxz8nqXtZljyfiwiTr/x8lWWRQ5kyWMXATVCfj7HnNXrVAq0lHQbqkpUG9xiU/MAqWWn7nIDmEsHPw7Mwce+pzRq1gtiBSjd3PcWPxAG+5Z/kwbjWc8idem3R4MQ2ywFlU37vudMwM1ouoM1clN13rONsWcq6ztKRD2h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 11:10 PM, Zi Yan wrote:
> On 3 Sep 2026, at 23:54, Qinyun Tan wrote:
> 
>> Anonymous THP faults happening in a kernel loop that does not return
>> to userspace -- the populate loop of a single mlock() call, or any
>> GUP-driven population -- can drive a memcg's usage from memory.high
>> all the way up to memory.max with zero reclaim and zero penalty
>> sleep.
>>
>> This defeats the containment memory.high is supposed to provide:
>> above high, the documented promise is that "the processes of the
>> cgroup are throttled and put under heavy reclaim pressure", and
>> userspace OOM handlers (oomd, Kubernetes) rely on the high..max
>> buffer as their reaction window.  Only after hitting memory.max does
>> the non-blocking charge fail, THP fall back to 4K, and
> 
> Why not force THP to fall back to 4KB when memory.high is reached?
> If reaching memory.high means the processes are under heavy reclaim
> pressure, I do not think it is reasonable to give any more THP.
> 

Hi Zi Yan,

Thanks for the review.

I think you're right that this is a policy question. Falling back
to 4K at memory.high is also workable -- it would even be simpler,
and the existing fallback machinery would take care of the rest.
I picked settling the debt mainly to keep memory.high a soft limit
for all folio sizes, but I don't feel strongly about it. 

I'd be curious to hear what others think here -- happy to rework the
series either way.

