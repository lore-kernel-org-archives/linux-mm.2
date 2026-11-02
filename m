Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B1D606A32F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GjnWdGqX
Received: by kanga.kvack.org (Postfix)
	id 00F696B00EF; Mon,  2 Nov 2026 03:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03A46B05B1; Mon,  2 Nov 2026 03:07:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA4F6B05B2; Mon,  2 Nov 2026 03:07:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B639C6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:07:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1BAAA8439
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:07:45 +0000 (UTC)
X-FDA: 85389450090.22.791C135
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0087316000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:07:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjnWdGqX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793606864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiZ4DeQUDYjmbCPD5lntKv2VNEdfVFuVgdS388kBeCI=;
	b=mqZQ/GcsRRXVe1jG+JtRk337LYuNF4JSFwXKV+jnPZaqmploz7NihSCY08xJm4lqDAJhZH
	YaHvuSaWB3K2pywgkEp8mRpn/XsfUpF5gyH7vvp8FBabuy3P9AxZN0ixTmqD93GeAnkB3H
	3gVSVki33v3ciZvdgZo7vhNNNdibdAM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GjnWdGqX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793606864;
	b=IsObSxkCFGgg88LD8j6u+K2RQuRdVVJe+6SsV1gpMRcaHmZzDw8HcltsywsHetJdDEfaSp
	e0dOzqaVql0tJAvLD1yHmYch2U3TBFIMi9NGjugwyeYlAEC6T/SMPqihM9Xbh/L/QE3hiy
	4YPlYr5vCF+TBopnqAtW6vHpVPB1Yd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF58C43518;
	Mon,  2 Nov 2026 08:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7FA1F00A17;
	Mon,  2 Nov 2026 08:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793606862;
	bh=FiZ4DeQUDYjmbCPD5lntKv2VNEdfVFuVgdS388kBeCI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GjnWdGqXphHcEtf19EwTX2thW34+dQQnTC3HTWDYKgjd2mxbFnBNaSh+4z74u2PpG
	 nmmmXMhrwoW2HtfczRCSxgUeHZio/vertGHaZZXDLL4ZaNcxap5Ujq5kUl1a0grQVi
	 5ofitQHJbEvTmqGH5uhP+WP20fs4Qt4xvKxMOFizMaaY6Nq8F0byWMpt1O3642Np42
	 F737c9hnfKhDFiInYivOJO2Wiq8878SOHGWn9E4CncfhMbctLLEuqLcsTvC+NFTMOM
	 j9q+fU6pecvskCWopPzAPLdOSkuTvtoW9tO6yHaKghEIrJGegOkKS4z6STz4Mqocze
	 lGJ7Cpd5Pl3ng==
Message-ID: <5748cb06-d7bb-4cfa-99cb-ea867fb408ae@kernel.org>
Date: Mon, 2 Nov 2026 09:07:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] MAINTAINERS: MM updates
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Byungchul Park <byungchul@sk.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>,
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>,
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>,
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>,
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>,
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
 <1c46e678-1da8-473d-960e-5aa22d4d7e73@kernel.org>
 <20261101123025.4d8133d5321820f2202c8f1a@linux-foundation.org>
 <1b4d0299-4232-43eb-9229-7d2a2a7ce2fc@kernel.org>
 <20261101231121.1c2be902d925dc2e67388000@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261101231121.1c2be902d925dc2e67388000@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0087316000B
X-Rspam-User: 
X-Stat-Signature: bxy97zh93tt1qckfxiqga43sbd7ei3hf
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793606863-963798
X-HE-Meta: U2FsdGVkX18NbgEIRRg1UE8jXGDA5dhVgLKvEe+/Txhk+orbVhlWirdrHKwQ34NquzO6AZh96C3l93fecPwNHFJpkp3TE3/uUeFbGoYjL3BfZDdAyDYNOc70ketXVzd6VVnp54QjFAJYm1s/6GETyOjN6H2z7ad0QZONkCwBgflfSbM8FMUsYuBEaR8yJSb8EyMc42VCXedUfIR7MLutx/YVkYZnLsqC9HpMk07vmFUkSkYMzKfIDcgB/T8KppGAL/2iQ1LdMgyj5GYmzLuRYYGJFRwiNiff0AxiKhO2JWYgQ4RdLNEiIVWHboIU/FcdO5Co6K4ptb1Bvqj9AhLbq5oWMjVqUWjtKUEJALRtE/Gp1093lycGHd2gjXkpzRuBbptLU68rUYJ4hPV75kp/mTsW6jXW5FpNeUktdY3BcPL+UoIXPcX0YqxEY0R5ASg7eZhrej4fP0WPXsgM5o4yCEi3lky/G/v5a9LJDcmG+EhOjdobK/w+Yr/iiGrKdaOYNdiRKsdLkShnuQfRVhr20fajzhppic/39seij7SAT5c3rB0MLDNAJ41XQ97sK2qpuDYsLZfQnoWi+jhmnokTuQ5gRGX7maBaOxEftwsMP+xo2oJLjJDb0BkYbghnkyMO/L76ekdRFJN6bDoosRY5d//p08FcKkR5veuc+M/dkNzbl616RjTMf+oo97qvB+Euwps9RybVkvVOGReVxXxhNaZjb1i3JdhFkmTSeeaxMEr7KhjCzAQjnD6sT2qLm1M3LM4EhoIefH8eUcrjm+mtpXdRugm/90WGM9/46LLEvLaPMcAV9CggSq+4BbZIffGgu2vTrUGOehh3d6QW8vJRTUKOmgQYBkzVYHDLzGQvMdrWk0dPjcCOeZu6a8sKUJ1PQNZI+Ra4ZIzb1Li0+H4aTsk8WUm6+vikwFlHOc99SeHXdighrfBjo6c/+hTMUsDaTK2xS86SJhJcalJLC1I
 rqUNRcHh
 NwQbVZkz5696V0/7+3X1ohdYoIyNSNSBu39icJD3WySQT073gJxRlt/h/6UNgLZ1otXvcuCh9b4RueRtZQkZYw6qB+wxlAf7e9QTK7AksxjuiDOZMeqKU8q9d5SlddWfpUJGN6vWrnPjbeYz0XvFfs4iECoeOR/rFKoAURLIfHVDWlt/aWSMnhceZsF1z89XSm97D185yPKc4SX+VmOBQBt0BJQXL2NecstsziDdD6m2d4jkTUZsdi6QO/q22dTarylfL+kAhsimZnBvueZkCO7PwEHis83lgt9r0i1WlI0OVYuLbW1Ue9jhqogekcxtCbgtGkzBmmiGHMmJzrhpsg4Qc2SeEbiWdWfDMI7Sj3PQFIAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> 
> The result is presumably not perfect, but much better than before.  Now
> all MM components are contiguous, all mm/ files are accounted for and

I thought my series already handled all mm/ files?

> all obviously-mm include/linux files are accounted for.
> 
> Quite a lot of mm/ files are still under CORE and MISC, which is a copout. 
> Ideally I'd like to eventually get all of them under one or more
> components.

Not sure what you plan there, but please let's not shuffle thing around too much
at once and cause a mess.

> 
> I added one more component: "USER ACCESS", bringing the total to 49.  I
> expect a new CMA will need to be added.

CMA should indeed be a separate one.

> There are quite a lot of files under include/linux which are shared
> between MM and other subsystems.  Many of these should gain a
> co-listing under the relevant MM component(s).  Haven't addressed this
> yet.


Yeah, that needs more thought.


-- 
Cheers,

David

