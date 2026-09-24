Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF33C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450136B008C; Thu, 24 Sep 2026 11:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4001C6B0092; Thu, 24 Sep 2026 11:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8C46B0099; Thu, 24 Sep 2026 11:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07DA36B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:32:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91146803BC
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:32:39 +0000 (UTC)
X-FDA: 85249048038.19.73437DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA1F04000F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:32:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hg4n58kr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790263957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tp54T1Ky+sYrkKZngcDc+33ltudUbUl+mxqhtBF8KeU=;
	b=nXu6IqtnjQhmtpzcjQLpZ6em+h0az3nTv7qFLB1DaGmdoXpDU4BISxVKFTSZrn7L+0Q7fB
	9QXvIeACq4o6uKHVWWxnSxTPpAJp1YeQE+8ZzoEVGPuMCFuTi94RVw4OjqoTuyr8EbHrIx
	854LHUdOcmu9p9CqoOTwtCmv/vGbJtQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hg4n58kr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790263957;
	b=pEF9Dbohkif1vmq0Nrl+hHfmid1Jx16ogwIuFZBwFh2nkillXpkLeUkCZY7+dtOPc13mmh
	NfQteSxRfGQfrvTDZruMqpgAbX1vfhYuVNSDSYqU1XQ1DgT16ejD1rbKm5o1Xij734hMuW
	vSiiTV13+QMKht34Q49sgAPTJiE9TqM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A43DD4082F;
	Thu, 24 Sep 2026 15:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081C01F000FF;
	Thu, 24 Sep 2026 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263956;
	bh=Tp54T1Ky+sYrkKZngcDc+33ltudUbUl+mxqhtBF8KeU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hg4n58kr9CttSBeBe2vfr/Et9VbEL8MqbZpXHJ0iiBzc4hhByg3+16A1POnInnQX8
	 cJHOIa1g0xiybET9Pia85SthvEICDSRl9C4Zdda37DziAECqHjqCaHArGGnIAkEvOa
	 faZ0d1SEgd5dl33T2wObXW0Oy1bulzKVIEs3gav9zbV4S8vJ36EFduALALooYn+hoS
	 PucgzMknkfWIgwVRs8uYRuCn+/KhnIfZ8S22nrjXbCDtJJGfkBo0B4sXzPcbZyzHSo
	 0OTJIUlfRNtv51E8vmwaRvxToByyj8dMObojWQzSnCKgp87UE7EwMf9Yepur01Rnkk
	 CiGTvFVGMNtgQ==
Message-ID: <e7f48cc6-be21-4ab1-91a0-df0e3a6ec0b5@kernel.org>
Date: Thu, 24 Sep 2026 17:32:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] mm: allow shared folios to be promoted to a fast
 tier
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org,
 shy828301@gmail.com, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-3-gourry@gourry.net>
 <f0cd5c54-deca-42e7-bc85-1838dfa917f3@kernel.org>
 <arUtcPIw_FaUSPv4@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arUtcPIw_FaUSPv4@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1i7bkoq3xmx9uwcw56c4e47u3ckig59q
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA1F04000F
X-HE-Tag: 1790263957-554739
X-HE-Meta: U2FsdGVkX1+02UsaN80n0CxJkqNcqZquIzU288SZ5qX1BviAIFnsm9sDx/SYMWfGRf9oR4XhwHhMi/Hg+pQmzJ84vGLAoTqewWb4cY8oLhRu2H+pJNE/0222l3NC3KrGxHkVUEpNXN979dlY8LqwLTYofJyzTwCcW2RxjCtzV6FNI4i9n3eHjwbIpt4Rfu12en/ipgsGKNoAI+12UIdtSBe49gWj7iIphx9HGXdPMYrkUsJeb5rchvtqoNGwIgsuEBtKmyzp8+dt2d1mh2mbUzslmXI/99chFlQ0ULYmTRXXDsfSfwqPIVWyFGv6dSHVLA520bSHyx41/rGmFk6WSlAPLD6C3BBHgSjalH42+lI+KhNC82yGl/dgVnHb3ECubYBpjSmKapZFnW9GjMnjOmy4F18m8gvP0A8vr4TJiMIiXSFZyCtaVeft8/+blNpCOdLbVj62SreLPP62WhIcZkgF/2MzGl8gxHFAstm74XB3X0PLuPivU60WqBb6crWBZPr1CZc2ozHGpmIBJTG2JjPjH2jNYKtNguheog/+tTi+lbA/S26Xo2fmnnqR5WwhUZQhIUhWc1ULc1fLctffSGgLJ+vWFodsPM+BZfCK1aitzYMYaa4GGxb3fcPwUi68QL8IexbIme1FAUGa8PIIHb+dbkZ3tcrdwpWbwZ1nVtzCZ3+X4Qaa0pnvpbo4yysCJUS/FSoQPwfXXm/VsZxvuu3NlqVZM27R7Op0Rq+0AaT9MdzlwgEdZtuAqtluBHJmEuIMI0fWPrCVFgVeaPokPV5eTaObH4IhX6A3SIhmDbnkcDUQxJe+9gbBh90UhoW/AAXoI1ijWHQ8XdyXx3Bu99XttjDqKoThywVxg39ic7PUzZFC2otHJYyThkowLmRrF9MNubTtt+oo5cCO7jBlvEBAZ0btMLS7FXUbtPCWpV68bgf60CUQDuuPRgxfgW7HdSUv56DMkNLjR8Ct72A
 wrWJobw8
 GVx8RBgAlU/mFRjiX15u95wBqiKpyOo5wBw7ZbGhtUMh0qOqMFpmFgsMHCgcqS1s/BN3D8BeBHZA9ryQAbXZSznoGRV7QhBAFrCQXuCXj1XF04IdplgKMjbki8JUOH7IwjKfridwqdmiiBkBEnkk29WezcKKhcpj+HDdPNGUITGJfyZ9M8mJXMtsVC++wFxWpH7I4ldYXhQsr56xm89UUqFCII2TgsSkmSYClt2XI0h6DFfISaR6I6R5Jhih39c/haZkCLaFtCMdQ6E6TwCViVtlx5Ki9T9mReKt8gWEBMyqgtrnvNQBTfrVcAlHGbIxd/8NH7UKRZkQUtMbnzAzSyZFOgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 16:07, Gregory Price wrote:
> On Thu, Sep 24, 2026 at 01:59:15PM +0200, David Hildenbrand (Arm) wrote:
>> I wonder if a better name would just make the comment above (about memory
>> tiering) implicit and make more sense of the sysctl_numa_balancing_mode &
>> NUMA_BALANCING_MEMORY_TIERING) check.
>>
>> 	folio_promotable()
>>
>> 	folio_is_promotable()
>>
>> 	folio_numa_promotable()
>>
>> etc.
>>
>> because that seems to be what we really test with both things combined.
>>
> 
> maybe:  folio_numab_promotable() ?

Works for me if "numab" means numa balancing :)

> 
>>> -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
>>> +		if ((vma->vm_flags & VM_EXEC) &&
>>> +		    folio_maybe_mapped_shared(folio) &&
>>> +		    (!folio_in_lowtier(folio) || !node_is_toptier(node)))
>>>  			return -EACCES;
>>>  
>>>  		/*
>>
>> Sashiko has some comment about anonymous shared COW folios. I think it has a
>> point, but didn't look too closely.
>>
> 
> its tl;dr:
> 
> `skipping this check means those folios could end up freely migrating east-west
>  between slow tiers`
> 
> Which cannot happen (we only migrate to top tier, numab will never
> migrate *to* a slow tier).
> 
> basically false-positive

False-positive? From Sashiko? I am shocked!

-- 
Cheers,

David

