Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012E3C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D8F6B008A; Thu, 10 Sep 2026 10:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232E66B0093; Thu, 10 Sep 2026 10:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1489B6B0095; Thu, 10 Sep 2026 10:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E90236B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:05:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70DE012051F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:05:47 +0000 (UTC)
X-FDA: 85198025934.02.06E4AF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 953E9140012
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:05:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGpYPw3z;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049145;
	b=zwkTT8Y0tVxl7mt/ArpzwNvI43vs2rJxlC/7XyKfmsPiRxQU0jNz1S3k5ZejyzmWOQRDn2
	pK2aH7ezrev5NjpD2AMiyRQkyvJ0BrPGc9raDCBNRCp9psJJ/cDOjkKK/MA08aI4H+PDrS
	66akzsmwK6phLfYc7HRhV8LllJ05S4o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGpYPw3z;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HpY/0qr1NmSJmaEjfxtlR2WtShxMgTAWgjuD+oZDOjg=;
	b=JV3SV9p4OtQgfCuRjGMXqqctSMRBSrClUtrTacaGokOVuFLUytGXkOf/shC4kenuK+3PoA
	K7WG/Exvi/pbkhZn0a43u8YyFWoHTTwdnTXwRcrIt6AKTTXcoG4dq4L3l7oNJ9SDoxjVQG
	PRjB8/Xk8RuO5VZnfopYmTBJYAImzQM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1F654365F;
	Thu, 10 Sep 2026 14:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885AF1F00898;
	Thu, 10 Sep 2026 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049144;
	bh=HpY/0qr1NmSJmaEjfxtlR2WtShxMgTAWgjuD+oZDOjg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CGpYPw3zqBXNmNmA9nnlmU0xXRzgHMea+gRGS9PR09mQpB7WK6Ti0Gu0r8PIshKd8
	 tj2Arc7mmoBkKdeCgkiId7UyWjO9G+eUcJnDTDBUja0fkPKDdozGja+MTDzSCKD7mx
	 ZQrwI8PFlfPymduhXGGwsaSxd4lbtbwaJ2NneYRVxPgb3JINq53ezzfp/Jv2KdwWDW
	 +Rn1VGv7Ciw5xIV03BbXHPtfz5W5V0n35VGX61F0KO1lRNDqekEcxNy0q6C3Vut9Na
	 QBoCGageiJ6XRJFlhNSZCgbZvOjyTNuZ4TEnJ+Lo4Ef085NsYhvZ1KHMrLrJzlI0ok
	 UmzzUzvg7pXMg==
Message-ID: <6285ebc9-fee5-4f51-9ce6-b840f9dba65a@kernel.org>
Date: Thu, 10 Sep 2026 16:05:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, pbonzini@redhat.com,
 seanjc@google.com, akpm@linux-foundation.org, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 shuah@kernel.org
References: <20260902194657.79075-1-gourry@gourry.net>
 <9b67424d-70e5-442b-9ec7-22b1d3db12f4@kernel.org>
 <aqKzIO3DD66Dhkdw@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKzIO3DD66Dhkdw@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 953E9140012
X-Rspam-User: 
X-Stat-Signature: 9xi9rrb356c9qua53rhwcb6igfeonix5
X-HE-Tag: 1789049145-782608
X-HE-Meta: U2FsdGVkX19WRPobeevkXA4mVkDXTCEuJIda72QDGkkWgOCWQ2pqBFIMWXu5jAXLEwbv/CG4jC+V0qM7wurPJ4RhwEW8wSek3VDjOL+35AHEdhJDh0JuJiDCjFhyHED2aLHDbym79QWs4n0czdVcwTMtYP8peMd7K5S+9ZIpt4jCw5agf49IMXZQybU5TBqEabqUbeC89mstHVi8greL0lR09wI4wrO2PPCJBd2elUsFgrVyMg5N43KshtpejLhX0eeJ/nZpFBeUVFHmqSvUTHbs98JbkNQ7EdrktZVYlcd1fCBEH0/8yYTZjiieEuptG5obWaeR1bnrIACo2AK9845MiVs8AU0HTdmGG5GxIdxWgSUj15DPqQgkn6TxLIPC1a8czHFZaZSFdx/5tdwxeylMxs9sUmUN2/NtpX9S3stiatOX4k/BQ2jgsRpKfE7/QYFmO+SQ+sE9ssNL/BfJo9O8xwvvMNKGkt1sJKUXqgVuv4hLKslZ1b+bJkw+8zcS8YhFqRvK8AcnLYhcKJaNKQidgji0yfaAYnMI7S9gvJ8Wt4LVpont3CHg3gDsCyM6MlzYztguoaKniQICY9ur5Yjm6oVD6iHC+6dD6ajnk32ekhSjfhZe7QgJtC7VgXFo45/azV8z6LTz9JPQ04qFDivQXHtYaDAwgKEj9XDrIpaMuI3aVN3NaA+wch2iMOsh95mtVfbcl0tN+rNjRrpfu/rnolBJLmV2AGFhKQTF/sxxr6z6pdyEx5lI+yqfST/KyofdBWIkWBypZp48QcI2jTvGuDMiewBqaGl6isgKg3WDjOjccyD5xe4Nje4MLANHL5npgnBjTv55yWTg+SXbU6/w2KR300MfEaxIbFrCucTF9QdJpTEUEaw/Xk7a2LayVrQIIpPofvQNSgAuTzSd3tqjAdmwAHL3HaupRHkkoJAgitMQ8dxYgXu5kbQVqJ/LBdyTOdsdjfQZIHU4HQy
 wKQq2HAB
 ioCOioEWjF17VfuxS0/HiyGrQ3C3NxbsPD4AYjCrW1/4Q6rC4UT7uHmlLVgBSGna0JSDFyjhJwFnzxl5xzHZTFrBI/iHHIOBJZgLBJaUXtB1UZUHI3i1f2G2VaJA6ZaEwA04A9/0EQm1fMWEPc4GqsEu+XnpBotUNB8nCSIccVn/CqBZCiDDeXTsoV30F7SkP4VHjW32Lxjo5aBrp+2m0PnLE4emBkjfbUif6Es+0LCD50kIZB+V1ktlskXqkQxMvAivb1V8GlHwLZIDyh0loqVH7w1E/OHW1uh44v3YHRZLPmj40twK7rzl1CC4aak/auZfhbKNI1ZAGz9Agf/crqq3TdirxvE+NtuH7PCjrlnAELa4gfAo0kkZxr4JsFO35j2UQB3572jyu/uzyuyUdlune+GvJaeUnBH6AcmLqqMKdGnXyxyj1wRjTSP9mzBtiBjv2nCm4UwtxwIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 15:40, Gregory Price wrote:
> On Thu, Sep 10, 2026 at 01:30:04PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/2/26 21:46, Gregory Price wrote:
>>> guest_memfd allocates its folios through a per-inode shared mempolicy.
>>>
>>> Today that policy can only be set after the fact, with mbind() on a host
>>> mmap of the fd. That requires the fd to be mappable, and it cannot reach
>>> folios that are only ever guest-faulted. Neither holds for a
>>> non-mappable (confidential) guest_memfd.
>>
>> That looks like an investment into a mechanism we will soon consider legacy, so
>> I am not convinced this is the right approach?
>>
> 
> Hm, I think i've missed recent work in this space / this context.
> Any suggested reading here? Don't want to eat too much of your time.

So the big development happening right now is in-place conversion (having shared
and private pages managed in guest_memfd):

https://lore.kernel.org/r/20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com


The final series where we added mempolicy support should be:

https://lore.kernel.org/linux-mm/20250827175247.83322-2-shivankg@amd.com/

(I think you are aware of that, you commented on some)

See my other reply regarding the use of GUEST_MEMFD_FLAG_MMAP on private-only
guest_memfd.

-- 
Cheers,

David

