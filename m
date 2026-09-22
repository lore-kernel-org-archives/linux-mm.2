Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0290C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D78B6B00A2; Tue, 22 Sep 2026 04:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960BF6B00A4; Tue, 22 Sep 2026 04:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8524A6B00A5; Tue, 22 Sep 2026 04:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56B086B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:18:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C360D403E2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:18:34 +0000 (UTC)
X-FDA: 85240696548.26.407EF46
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	by imf19.hostedemail.com (Postfix) with ESMTP id AEBC81A0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:18:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="olw5uo/x";
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790065113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+XGnBzqs7O2W4lk2MRSsmNS7PIMyk+FriX30BhA4JU=;
	b=SlGh//foql/7WlceNMDYUB2Qex/SdPQM63ChjN4J5Si1OjD+wWSjn+WiBZ/14XGjNAgpNk
	WDe/pUqj8zsDVm3DBapSm5AvVACWHfVP90tpwUTLKrASV/dWwFuSf+0lcGmXpXMl2x4Oz2
	KgAJ2kUjRyPMHPYvuqpaVRkb9d1XeNQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790065113;
	b=8FFbj3btAjxU2nLLWmb4GdKqENqNVKKr5A4fwgkxvZKS3sWFF7r6sygiWC/aX8o9J0Qkm4
	10b3ZGiAsKteQDUPLP4jaWOqSZNBfqta7Kz8HFEziPm27jSF/6+kQPYq3Zprnd8kiSliob
	rKzsEww0vzhfjGQVK2GFYciExN+yIDY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="olw5uo/x";
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ktrAUhwI64L505wDOUN7xl4hGLDxMuKT/wuyW3WOSV0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790065111; v=1; x=1790669911;
 b=olw5uo/xTuL790U0/Ix6xE0wzHpk+VQfuSsgTd/1mtedkVS1AVWgJL5mCLlsiXq6kjiYXe62
 0V3wS+Derk4bcykMysUPCq64KNLTu1vxWwkK2P2CPxOD4iM9hXvDg/4oJyXAJpbtCGPzXEqg+JG
 Kop9OnLTFuNWkgpVdJqppNuw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9f6078236310b3ef;
	Tue, 22 Sep 2026 08:18:31 +0000
X-Mizu-Trace-ID: 9f6078236310b3ef
X-Migadu-Flow: FLOW_OUT
Message-ID: <b7932a94-32cb-4717-bcb3-d1982fc4f270@linux.dev>
Date: Tue, 22 Sep 2026 16:18:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] mm/sparse-vmemmap: open-code
 vmemmap_populate_address()
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260913083734.86802-1-songmuchun@bytedance.com>
 <20260913083734.86802-7-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260913083734.86802-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n5dxf1npkqa8knwcgxeoh7frp6ajbpfy
X-Rspamd-Queue-Id: AEBC81A0002
X-HE-Tag: 1790065112-568230
X-HE-Meta: U2FsdGVkX1+K5yuToPoQqB6ENk5jrh28Npd+DLpepi5RPaOv+PsL4/fX+HNVJowHYrJhZH5YaCYUuvZT+RJ5dFX6S8fNqkX3nJzVINTJylmwKcFSjPcNCHAhp5cHCkB6LYfAntmSq6GLigPuJAuRkDIvGN279cT3BdFnfqlZmrcsmjaaMrOiKNxHwujZdu5cVN5Hgg9rfAnP6Cv7nMf8Hxp+VbOoiQN1RAB88qxfa9fXHqNIVIj4m2cJIrvKJ59Y59QPsiH3aGMHrrqKhU7KJdJ7uTG/wP43l3jNyy149B345LXv4XKg/L5lQTPFyxMm/+c9RE522WmlHdRObhBthVW0ucJgUwIrp9O0xELHmEZcCsKOl4gXy438pqo3rVNF/aQLcP2/7z7LNw9u/7qbb8uE6TPxZz/cCTd6AgLfoFIgZ3cObf6DCxXaJXjB3FUz5oLVTsnvun9SENZ49gBEhc+yh7saMyH9pe6yyvG6lbDUQTybFbqLHDzegFvTUO5Yav/4p+BJHHnOVe0SUOBmGU++iURUPesmvoFqJTWnyUsLTBUHiLF4EAPWx6sMKMCIFerCoXi9ASi+nR1IiMBE16zgeMid8lsoQ45abKfDuXFfRN5uN1xcDPkiqPSi15FBJcXmLxKmSWXmOAQtWhHCl5Ja9vpYfMxcUu1+9RDo2xYTAqA4nK2EhkbC+TAos541alK6MHB2rh2domdRci41hkO12bgOWmri/NDbiGUuVJRv2zcfm8huLibljNrvHA5lW+Ri5BlbZFK0Q9WvB6DE4ExCpx9RSpDZZQd/5QStiMbMD1BnkrpW3fbbFhWQmVAdPmqmzkoVQen0aS+OCaM8Ek9lXizznW4PADFbySarR88DiEEu49DYyG71DquYIee5nleUdalU5yecho3eeZMCa16Z2VvJ9MUJK11KcxfMbBotVdZCFp5xHQWbOxSauua0cCwkHBuGxWaxrrKER5p
 aXavKRMJ
 Raa20wT0XNxT7mfoBzxtVcVcuJhwrr6au1jnni3Q8NIJ92xLPcWAkkJCIlWp8MCy0cr1s+7Cho10fvStJvbcoUH2YYhMJHRv8GRGe/is7uKulXVnWalgDY/Z/6gwatYcsapKHxT6SmUzKYmeNFcXPhjKarjMk2lTBZ17GUFf5pMRajT7jCaZbbtxk8fhm1tB2aW9YuzgbR3s5f62NQJpQBcB+P/we+3meuQUfAVtxWvt+x0xxmg1s/ztyg6YIOVpjfjygtNCWbr3jsV5+wapLarcMl5oDfOzYhPm7hUDX0i5BEbWTUSdUSuTthTfpYFMQUKfbYM1Rksad+frjwg/obIUrLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/26 4:37 PM, Muchun Song wrote:
> vmemmap_populate_address() no longer has any callers that need the
> returned PTE.  Its only remaining user, vmemmap_populate_range(), only
> checks whether population succeeded.
> 
> Open-code vmemmap_populate_address() directly in
> vmemmap_populate_basepages(), remove the now-redundant range helper,
> and return -ENOMEM directly on failure.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse-vmemmap.c | 54 ++++++++++++++-------------------------------
>   1 file changed, 17 insertions(+), 37 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


