Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEEE4C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F21F6B00D0; Wed, 12 Aug 2026 06:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A33E6B00D5; Wed, 12 Aug 2026 06:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745856B00D6; Wed, 12 Aug 2026 06:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300896B00D0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:53:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 085C8A2627
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:53:41 +0000 (UTC)
X-FDA: 85092306642.07.B36D563
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3E8371A0003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:53:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ly4CUQnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXZlzOuY/uy1o248+wftTfTU0BBVnB9g4KF61gQIq4U=;
	b=Hya5fbvdWTiR8JIpJfM8K5Y9LvH8JsQJBXUjfZtPl3SJ97jViSbXl8nIka/ZUBuxComirB
	2WUp+YoT5v2Ms/E/w1J7OHy0hS93v38qgYJWJRzJlTcAtrZxWiLWjtWPc/o/DR/bJWfHvX
	du0RRyp/Gn2MDbnHL5iU7OxEL0OwBk0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ly4CUQnF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532019;
	b=jwIN7sfByopAqwrYC1vg5+e+BhmOBMO8tJfph9rMw79Ei73TF9ZUHf3QMvKqFGC+YjZoWc
	UX3L3mjLI0MJygmr9kLaOGCYlnm2jzLSOhNP/5eWAIbNfguK8IDtXkqTkPltlUJhcdLGP7
	0bFs1tPyd5PTFXn7w+yK+IJPUdAtaGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1EDD4088B;
	Wed, 12 Aug 2026 10:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09D91F000E9;
	Wed, 12 Aug 2026 10:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532017;
	bh=JXZlzOuY/uy1o248+wftTfTU0BBVnB9g4KF61gQIq4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ly4CUQnF4WPmq1Mhu8Kr+P4sUNWjV2IYRUGBPHfIAbpvmRdn83NQIV/7X0LsVOl40
	 IKpG4hN2dIrYQKdKFL9U+zjwn2IW1d6bCDyR//4ixcB9vrTBGENBCQeJiZi9sb3NL6
	 jhhdFgJthPsBw7/WCi2vsyxO2U/WOEyDxEH+l5Je8MLTlY1b/DAzE9RNM2cthE64Jq
	 Ybqko9zoyxiMYL6BfGw8wCw9oHWd8PUouFqrChhttH5iPwCt4hiwOTAPFc9mMZEqyW
	 IdtjmKupXqO7ClxEdvIXiPkmtPfAmizsYUVXMbv3394yOGr36Y1pZ8oIpAwVAWW8UR
	 3x1BMoS0HfDcQ==
Message-ID: <69c86172-9175-46cc-895e-9ecd449332cd@kernel.org>
Date: Wed, 12 Aug 2026 12:53:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/41] KVM: guest_memfd: Stub in ability to enable
 in-place shared<=>private conversion
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-7-2fc18ee6d3ba@google.com>
 <ed483d25-d908-4248-b8c7-862dd35dc6d4@kernel.org>
 <annnrGR1noVuBkCc@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <annnrGR1noVuBkCc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E8371A0003
X-Rspamd-Server: rspam07
X-Stat-Signature: ej8zb3eewpmqrajptz1d6anpds6m7x7g
X-HE-Tag: 1786532019-5820
X-HE-Meta: U2FsdGVkX1+Gxa76Twm8hweqd13poSW4gFcihUdY4HVs8c5Doilq2UgSUlre2vZCzR9njM/LQs2e3bl9TLQUz7LSv5d76H27mH9hYsxmdA74yKb21fu7+rsjODy7sRL7B8NlOKVgltfGULAgPE3R3R2QQ7vUezknVwGuKw/pmrnAT0eBI9fcObgsnzvvgr1qmEvp51gZ9pOyeis7lv8gRYquux/QAwP7nN4DVYX07GUip29oeXqoiNUq6qYT25O5lA9TdXnT25oRS/3X6hbFTyyBidGwvTsH59eEm/7kSYRL2gQyRZnW+kgjZJ/xS5mECJLyluj+/XQH0b6EY9rBYN9+/+9hMz2NBiPGETHrJUFv5sAIvfCFry8Li0Mno+KDj64HDoB4TyJUgM4Wgd2bm+rLHbKqDSPjisRyHIGJ/wNrWLDs1wE1184r9M2UpViQM17KUqvSd7VqTMWpvjFax+UnDxAT5V29OqVVc7oOvvwsDQucCRehHqXtc13PRhamOnD2dGPuRSFOO8q06fxbQvA1FRjiMGsHpCEObjMWvFWWIMsSw37cf0gSleuGuIYB3MFAKlOxwcf7XDwB+j+ARsfJJcKDRA6J+yidWU0wzKu9U38SfXOg2KHpOlRWVfId20xVsVsypd+GjoanMLNStUERiN3Tzz5ib0uKLmreGs85YwBy7vcoPvifHotUqeSH6Jy6Z5yoPvGweIybCfg8cTmMM7JfsEnBhgdf9noKytwzJr/Ro1RjFo3rPGk0eOpMuZwtQS/ETGeNNkBLPuCfkfKeWWaX7XpZ57ffmnWONRU3ijWbW8weoLVIkABsbWXVI1HIg3keP1I9YjcVtAgRu27dIJuXrUvkES2h5WA/CPRi8JsmjST2Ae0FHAiu8FE2hiLAuPdokGcc6/zAXjLEZxbiWJ4oVc1mDgratbmoPAOy7sdfxrqtTz9bRzM3fTVa+UJNzL170WmA7xuxx/G
 kvCpfSLy
 5RJNMFSEZ33QS0IUNrz3YzL9Nvdr7Ad4U/vpRMwr0OPx3tEkjJtjJV8DGTOGPc7tgKiHIUh8uJyk37RzH/5VJSkPTHr8pGT8JA60N+TpLESR5P8zeUhQDUBAjGGADZQNiIZLsLMP0EDuoMs5MnBYeY/tPW//QvXIIcdnl81kF9kOcxd0aVQDRUfE+ogEmWAONlRLQqQR+DR7OtMTqycn2H0O+EgWSyF6aMO73ovAp4f7DTQQl3WyZp+atQ0V2zySYkuuRpOxRI6ygxV8D+s3q/+/KyuUgOD40kExDxeTtd8hiiHmH6FiweNLlZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 17:01, Sean Christopherson wrote:
> On Mon, Aug 10, 2026, David Hildenbrand (Arm) wrote:
>> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 65fbce46b63f4..9477ecebbbced 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -2580,6 +2580,8 @@ static inline bool kvm_vm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>  #endif  /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
>>>  
>>>  #ifdef kvm_arch_has_private_mem
>>> +extern bool gmem_in_place_conversion;
>>
>> Is there a "supports/has/enable" in there? And should we call it "kvm_gmem" for
>> completeness?
> 
> It's kinda stupid and definitely more than a bit inconsistent, but overall I think
> I actually like "gmem_in_place_conversion" the best.
> 
> gmem_has_in_place_conversion and gmem_supports_in_place_conversion are misleading
> because it's not just that guest_memfd has/supports in-place conversion, it's that
> that KVM is tracking PRIVATE in guest_memfd and so in-place conversion is the only
> option.
> 
> On the other hand, while gmem_in_place_conversion_enabled is better, it's not
> quite accurate either because userspace isn't strictly required to do in-place
> conversion.
> 
> As for a kvm_ prefix, IMO gmem_ is sufficient for a namespace, and not having kvm_
> is consistent with most module params in KVM.

Maybe we should have a helper function instead of accessing the module parameter
directly, then the gmem_in_place_conversion could just stay file-local and
kvm_gmem_in_place_conversion() would be used by other code that wants to obtain
the value.

Instead of the

#define mem_in_place_conversion false

We'd have

#define kvm_gmem_in_place_conversion()	false

just a thought ...

-- 
Cheers,

David

