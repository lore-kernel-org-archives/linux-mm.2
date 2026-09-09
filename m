Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9177BC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80CCE6B0098; Wed,  9 Sep 2026 05:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4656B0099; Wed,  9 Sep 2026 05:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB0D6B009B; Wed,  9 Sep 2026 05:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5796B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:40:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C08CA0174
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:40:04 +0000 (UTC)
X-FDA: 85193727528.05.DC33D18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id AB4E610000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:40:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LG9fogCJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788946802;
	b=lBTMHiSHJ5HTMcpLAdReTKzdLMXLjkUHLFXbXlo4KRIszuVRmwyoX9XrkW3qyHQDTIj8uq
	Juf65aINYcMAId33EQ9KItC33+ojhUJu/vgTCgV4bZiRgmbouL0XU2qBSf/N+eOFxZmpNW
	hZ2N/P/GOqnA/UzDipqGwU3sbjpt4zk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LG9fogCJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788946802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMMqQ/6cFzgNCXhwLIV8RZZe6VCPK/dmaFD+txXDdZw=;
	b=R1rugiSKgeE2NdmZPveeQ+w0y7BQUB90QHAuZ28fz11ELiPLX7UPeZCEEIoLWrQM0rpktq
	ZmW4yv2GEBsa+/0ULGeZJFAhNQ4G9bn3nj26lDhhzUnA8Rp1oIjWKsFGtqtzd+FGE4ts/R
	F+EWUiuDfNONKvI1zTTQh49ixSJ/FBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7C194135D;
	Wed,  9 Sep 2026 09:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EBA1F00A3A;
	Wed,  9 Sep 2026 09:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788946801;
	bh=wMMqQ/6cFzgNCXhwLIV8RZZe6VCPK/dmaFD+txXDdZw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LG9fogCJD1Eel5hzY6cIvq+iUPU+vT8SA/mq+/7Z9JGK60PfNWfwlnPcFDSBDvDw3
	 U1IsQtI836LtFfRtHckcQUC0OkGvM9AlIzJTE95//hrVMgGF+zhIvH9ZRi2CMXj23R
	 HEoH+syARkJfi5ijQUTy/VdympGtmEtkptUlfkYYEInpnZaTR76L8pVCTRtud4h3Bk
	 l6cEVKfIiwxer5TLTEr85f+qN5pgAodn80wfbn0F8zq9S4l2E5yWA6TrYUValAvUfE
	 T4YaJlYdxfBku4B+rqE8N0x+lqgdkiLzXgMy+hLFvQ047E0YsaxSa/nQKV8pbUyw0M
	 o5tY3aA1OXi5g==
Message-ID: <f57dd255-9468-4280-8a7d-c262147e4645@kernel.org>
Date: Wed, 9 Sep 2026 11:39:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/17] mm/sparse-vmemmap: initialize shared tail
 vmemmap pages on allocation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB4E610000B
X-Stat-Signature: yediwrdtmwsy64z8jxbhfp9gdyuzhm1r
X-HE-Tag: 1788946802-419538
X-HE-Meta: U2FsdGVkX1/ekPlOIgNgLHWX7F8dBp9DUdk9F3JQ3cWP+NJNnqzo5vm7T5ppPyLDD1qerONjO2FNONz7RxofC+kep3BN/gJd/CuO44zAGvmGNnDeXHXzEAVl+L7SwwuPndpHzQbXJTkeaEXdW4aqIYB0ghtz7hAsvNTgMU7y+4Lq/sFOITkOpz/eyIsn7qJNsCQtRrzqJSZqOIEVUTD6Txigcjrx9YhP54nRch4Xoi/esqU7qIzOy+uGRlWQkdjjT/WuvUuAbFMWhZMqA/QoLshZrxDm4BjKwQkt77O2S55JVRbHp02cwaa6D8nV9Lj8hws5mnJsvhCHcOfpqnPQ85BHmB+NLOoCNvtWNpVXlyNFl1nfLrYSdokUCy2zxAfXt51XZcMCniaCrW7G4NDVDtj64h2i8JYx2aaNuo1IBpx5ZacEgPjd54i7s9+m0jBZkCaOp5vZQQao/OYZlukQqBdSML8bLYNFa0lxoxvEloITgune32agSgVGb5enULY/AQDcN3ekXFN32JRAq/Uc+mSKmupmV3n4beWvOogNcG13E90W25uH32xS9cItWrj+QpYi1eHdjtU+fZEdQ+xSgVYrCO5EdOqsWBqUIPKy4mm+U2KA5c8SQoITK8BnbCohKEdDsARR9WuvpcRMd6j9sBpqoCwprHo28a5Br+Ewe6nLu20FSTcId+Q6WoQR9EuSATvC2v4+jX51mnIgy+HtD7ljSxYoyy3UfM7OUhd+oQQx31xrxlPFA0tcwMeuHWfCFwH9AH+v+ylXn7X/n+Ah6rOC2n+q1smx0X8QfMLLX9pNqzWJTmh77gWYSCQ4pglM9eQy1ACzuIHw7x/RJHIsUiGdkM6uQ2Mw5XFnVQ0nYpdWb7orhVpN0By38Lunnm2LRFEUs7HWu8we+FQsmdp/fcoL8Uw/gpwZn/1D3zuXG+ApyDhVbhRl4ewb2JhZ6m8rnMG6mQ6ZVVlLJFJvfx2
 zEhrIgvU
 yAP41NMifM0VDGbyV/Jm5xfKcPJvxlB2bK/rHBbcPDgPv6G82Ji58rR90UczkQILq0CgGcpocppQAvOjmNiqWA5X02F8yyXa7a6aoFXe81pVq9mTWZpqoStl0y8sWRbfjZRGcP0KEhIrHY2BYHOxVYM29jNyIUdBF+ijNhJziNqgOLAEgtP4YzRbvh6W5iBdDz1/Z/3dCAI+3u9kGMYrs2RVRZQCVci64rGmyF4cIk8F5Nw8KEwDt6CvJpSLYuzOhFrHFgfBfuStruaeXS/dkvSn9OT3QOe0ICJr0heVDfrAMQ2pYZJBQFhdIceX7it5sz3axpz8KuS+sv3jranpfKWYODg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:45, Muchun Song wrote:
> The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
> left uninitialized, because memmap_init_range() would later overwrite
> it.  That forced users such as HugeTLB to defer the initialization to
> their own setup paths.
> 
> Now that memmap_init_range() skips shared tail vmemmap pages, initialize
> them immediately in vmemmap_get_tail() with init_compound_tail()
> instead.
> 
> This moves the initialization to the point where the shared tail page is

You are not really moving the initialization? I see a new initialization being
added but none getting removed.

Wouldn't hugetlb_bootmem_struct_page_init() have to be updated as well (as the
comment you are changing indicates) or what am I missing?

--
Cheers,

David

