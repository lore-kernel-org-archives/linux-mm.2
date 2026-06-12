Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFE5CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 09:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6636B0005; Fri, 12 Jun 2026 05:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60576B0088; Fri, 12 Jun 2026 05:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C282D6B008C; Fri, 12 Jun 2026 05:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF1A96B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:59:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B0DE1C2E01
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:59:29 +0000 (UTC)
X-FDA: 84870813258.29.6D1716D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8083E1A000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:59:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STdivhBR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781258367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyfQhJDr0ZUeHVCkGcfPOj7+bIdM3McE9qOrpu4jQqY=;
	b=OJJxceJmnfU/tmJvkrxsbgjFQMXA9UKetSf2gKTBNNpExqW9MyRmGwLGu1hllrzhxPrDD2
	qkOPD4LiZpduE2w+9/IzfeDxHiKzZMk8Chz1pbHWxTlVzn28BpkxMfeimFGJBYmlTKLsyw
	MaoLYRnsYXp7wFNMTeZ1Q+I9d6HGi8U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STdivhBR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781258367;
	b=kbkArNFXuJmt1Y+y67OdtF2CptnSHGOXSvYxw+TGGXoLvMlDk1CwODb62TsVGtaJWInPQH
	Dc3xvB2PXIqOzFmdDDc+jDEHlnKj25V5itRDYZSRA7hbxkzwBW0pLepcqAy5yJbfBntoAx
	ZGa/wAehIg34pQoJMx002iUCDyaUxdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5CF840533;
	Fri, 12 Jun 2026 09:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162581F000E9;
	Fri, 12 Jun 2026 09:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781258366;
	bh=FyfQhJDr0ZUeHVCkGcfPOj7+bIdM3McE9qOrpu4jQqY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=STdivhBRretl36rmEOAV6Bqo7gg/u3Q9MHcGjma8Tt/VRgGPo5waxl/z1/QcjN4l4
	 RqQGQVWHLcagbNQIBX46mdyK5M+3TPq7GnsAADq/XomCJ2smU7MTp1EP7/6YLMdcsv
	 amxAVvF9tI5fifQeK+wB6LaYoGmP2K95gxavkts73LGK8f9n/gr+9h5m+m1fl/r8eE
	 RguJ3C8I1pbTeplwHL0o3MLxXLnoDhTvRMEIs9JZSCFNwSJKJnXFkUPFSKldba6kBI
	 A6YPaaw0fZALQ1vug6Y0Vv2RwN+TmWnS1rWz+z34PIkJu006/TEY6UE0HZOU3YG/Kr
	 jpJ/s88dNz65g==
Message-ID: <0546df1f-616c-44b5-8a1c-f96d5f33d8e6@kernel.org>
Date: Fri, 12 Jun 2026 11:59:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
 <aiuX6SRATJoaq-jH@fedora>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <aiuX6SRATJoaq-jH@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8083E1A000A
X-Rspam-User: 
X-Stat-Signature: 6ifpmgkcmfmt4wab9jim9rjfmbg3j51k
X-Rspamd-Server: rspam09
X-HE-Tag: 1781258367-562274
X-HE-Meta: U2FsdGVkX1+/iFUYJT+cPSI34mRhS3eKoh703U/WwRhzksJWiKjj8oykqTWyvAMOYGcpSYmsJmZStF2u6spQM/epvK2mLVwVV3vd24GQ7TA37Zn974GvmVS5E7PO5mlPlmmqfRLK+ENj1BVX+4IMjq34rrJ/+QZGoZRqHGt0fj06H0wJ+b1GJ/ML9neqOF4pJSkvHlLq0r0pPiQXex1HMRNqOMeHAPMoJk45cto+aQhTJZ3n5AX7ovDrY4S5PwXEI0b/Xqmut0i9DJf67jrXSbBXmJwcLLajOazDonM4Fxvm4YUkBxhmYCYZ52c4j079SG29TOJdV133WXZmYOv9hiTMO1FzAyT72agUPw9cydsRU/Z8s9UmZTSrKKuFG+rzVfeUHwbniUaRmFo70qkc/jnE8IMnGotoCxbNibfwqED4g7bs4/O3A6JNJCsVPKmxiNAg8vJ91dqVBJ5C1ilXJAew8B1XuiLKDRTLVj9KTZpUauVAycJfAcz5tSo/1QbUbofkn92PwH8SX5PxwlABehjoa/BAtpKgMnkodhG+XaASZ1BjUYnW9Da4y3ttHxte0TlLtWkaQtfB7w07uscV7lTr5aouObZZXvJmW6CGtEbd0w64GpSBIxt0oSkZygyNpLBDOSf6xcYmRosvkrZDD1ICQlB2haZiJW6jFU4IC52dQSyYIDpYU5ynYyfVXrtVZEjfsHqHe/rWSnISS/kDfM2zvjstTF1gam4SF6KFx80oKyVQXSgI7p9v2Uxpw8oiP8woFumn7BcJfwcsPdAsLBLgFJVQIk9iFgc79sVofAF4ZykUPoB2jYym/1nLkFjAdZFL81vQ9aUVipbyCjiuRwG5Ab5vTIOdLEPjiM3lMEzcKzbkD0IlvJC+cDg6I0MbMwdIg7miXd7ZdSjgi+qcVMgc10SqTCIb5EJo9ounyW/iiBPNhA+RctSXZy4YpaBtt1mUKnbLh5kEpGAlJkM
 J5rhkIv/
 CPiLolEOCuSTJ2/pJt4XuyXCnL1peRYT8mu4yerMCEvw6tdORqcy94vrlCdhljv57cKljzgajN/V6ciE0OrTH7qtsN0YYgqxD7IC11n7VdBv9NSzIG6gUuBuX7B6uQkapp42WNBuTI4tOlJX4vtuk5X+7A/kPql5kuXwjL9xS8nS/Ar+Zq0YO91+1LXQlU9VPvt7GFbdTRfjklhh96+FC4BqlVNato8ImEVXDa6tObpc28h2r3LbDnVhvhxEZY57eV9+NetNAtSRcKT33BOw2Hyn4y3rPq6lGy+FD9SM4Cc5Z97k18b0o5WQJOGzr6i6Uz2mOfbGQHMIRyC/f6SQkkXS+Bre5vlvxhklANmp4qBwzjNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 07:26, Hao Li wrote:
> On Wed, Jun 10, 2026 at 05:40:10PM +0200, Vlastimil Babka (SUSE) wrote:
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -3378,9 +3378,10 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
>>  }
>>  
>>  /* Allocate and initialize a slab without building its freelist. */
>> -static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>> +static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
>> +				  unsigned int alloc_flags, int node)
>>  {
>> -	bool allow_spin = gfpflags_allow_spinning(flags);
>> +	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
> 
> nit: allow_spin doesn't depend on `flags` now, so it seems we can delete the
> comments:
> 
> /*
>  * __GFP_RECLAIM could be cleared on the first allocation attempt,
>  * so pass allow_spin flag directly.
>  */

Right, deleted.

> Otherwise, looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Thanks!


