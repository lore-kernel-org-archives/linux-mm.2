Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF48ECD98A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 17:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7348F6B0089; Thu,  5 Feb 2026 12:29:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1F06B008A; Thu,  5 Feb 2026 12:29:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F846B0092; Thu,  5 Feb 2026 12:29:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 453C36B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:29:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 004DC160653
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:29:16 +0000 (UTC)
X-FDA: 84411089154.08.6E89667
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 390B2140009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:29:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxWACkGJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770312555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzZvidWsus7OtK4lFAmO2lKtoJo1W0yiwW6FWu0uFdY=;
	b=EUwn35gy6+SYLHt7EaqjbFspkh8JEQSx1RBbq+MV58/jEBoLr1sX7nFLrqAmgHYxTouXzJ
	42N62MtlqeyURhfyi1Hyq3gS0Tj2dOPpdjHugxz8/dvCGyZ2SJ+EDq1PlkYao/Ty/PZ2iH
	6qc1o+wMPGa0vbBmH78+SaWSAJXQdgo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxWACkGJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770312555; a=rsa-sha256;
	cv=none;
	b=ipPaSUU2V2eUbLWRuThDAHUjJmA6fmfxuEAND+KmWkwgkaHYugoiarH4graw7liUe7yGLb
	6TJlxcx0oAygqiFVcRaUN0NSJlCRaaRfkCQfOS6HS8qxB1mRDZGuWie2c9iIenX8C6Fvjv
	TCxkoCrzQeUhkTDLr/sBRQHzmukEarI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DF0660010;
	Thu,  5 Feb 2026 17:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898D0C19421;
	Thu,  5 Feb 2026 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770312554;
	bh=0h6aXl3odpNK6UOPrFIUbCWh+xiPmUDlXpbqQDhrshE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gxWACkGJV7DkZqdSO+Yr0POPlWnhgxybc9tAg6dxFEhlVjQlQtKtTIljdTT0hzq1+
	 h8KjD/VSTs3PLX2jFPkpp7je/j4DVJ107VFASmwRWRQu9HifVKwjMEwB89Ys0I7AXN
	 c4e7RWEYNhNIONgGGL8jGEk5AyQRP93D3O+W7h6musIYXU+WV2OZEHgFg2TUlEH7hU
	 Zv5T98JKbPMN2oOy8HhGH/F4Tc46+No1HTfVOyElgCAKIQP2E2ietHeFJ6qYJT7nvF
	 xt16dahFoksybify+15Y+KDDncnYDnt16EK3DBG4Nz74Q1TpRdXr60fH5nZ4fBsbxd
	 8uR5SZdgstrkw==
Message-ID: <fc60cc71-80eb-4058-8d0a-dbd19a5c10ef@kernel.org>
Date: Thu, 5 Feb 2026 18:29:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
 <d07cbb96-ba30-4dcf-ad14-0479d6a989f2@kernel.org>
 <70be936e-e49d-4485-8d1e-416fdf8f40a4@amd.com>
 <aYR0vqwyFPo3EKAi@thinkstation>
 <ce4334f8-5e54-4dbf-9be0-059279ef1962@kernel.org>
 <aYS8O0phOE41IuEF@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYS8O0phOE41IuEF@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hzzwcq7w5f17akm7pp4hpxt91zn1qhuc
X-Rspamd-Queue-Id: 390B2140009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770312555-450946
X-HE-Meta: U2FsdGVkX1+bsRuaTSICmfFdlbFAFfkuDSAVCGXOFEv2ZLLd/eeMYaJoI5K7NJnC7jYBuTPaJjs/Gibxmlmcj+ieB2qV3tjjF/TQSl9nz4WfZp+YkZvlIN3cBMrJzNPp6NzSPOWk7JrZKp5NYlyph0RKZLggvpWBI/WTDNCCscJb3Q0X46QmXQ18Ztb00xGC/hJSw/syChJ+oqbXdhEf9a0z1svFOkaLg0Un9OxiwAILwHtG18acYnPBNFtakE8588mDDbKspcZrTpkBe0WEj4hHUtFUdwV8wQq5MFKcNPu2Awu4XA1z5dEogsJHuiB86ksS27JayHPZEsLJkCrZCfxkspPkWMyLMbQOQJBnO7Z/04IokkayDUl/AaT5E57pn6Ds53KwrwzDvixaokS3PuPyGzSP8iXIVLk+aCsDDgJGm3n3O6yoiyaODbETlI+DrdGNDLxwV+CBgbn+daoXRWCmweiCBoJND6YSPdAzwTINEzeUwN+H9vn5M2LZgzmgi6Ge5f2EoMyp+c+tDYRPS9R72uHFuGAM5ElcYrjvemRKDC7Ix4H2GgaPV99VxHmP87BJgRfErpdDsDStprIu6gxx7KsjZ6CyQGXqIWOiAS1V5SqiS3SASbgU4G6gBfxdIEseqG4kq0BsGPWs6mibjH+lJ0bXmm8M/Ch/KgmmPxS4eIky1NwjxPe4K0IpyHMfnrbuMaLePCZTIVNTPzoaylBRiYLrtTsUUWMPnZc1EbUHPamBy8OKj12Lu66vs2g/i4O/y7BHAuv2TaNpgor57nF9VCsOpxCfeBISe3UmwfReR2XLNRbDfPyDXcZwCBoy5pId/qDqmNEkQRyOfUwUaMR9Tjor3xoJvYVE7mYd9rUxPBMSlWa/i6MHnlrjfnrTQdA2CkhsBEYqQIGYZ+V/jfHhJfDvHua+Ss7sZHtzSxiMl04Q8VjWfpBTddiaA8jqXoVPErkPjuecB4XEuzF
 DBQrpe1u
 Y8FLdhxXNAmlJcaahiQWnmBtqUbzT3P2WLgEwg62kbYRyYcsUOt4E09OtL23Sf5wslgaRPAT4dnsXR70cx+j0LBoZj+oVAscwKjkNkyetHZmeolv2m+lTFqCDb21R+FOUUbOOsRoKNdIB6qczNb4qB1z6utYbLw3RuxC89Xkas7r1eNNGzeFo5mSlxR2RWa3g7RjRKNDVMEHbpvJZTX8tecpuPi2F3271ELetdnD63JDfvW84HT4cSMGL1Rmm+ngqmnPvQY2KbKLV0BiDlX1YbIPvwFXlgCfnvjFt0m7qtSS3RiHIwnyluHLZXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 17:08, Kiryl Shutsemau wrote:
> On Thu, Feb 05, 2026 at 04:48:13PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/5/26 11:48, Kiryl Shutsemau wrote:
>>>
>>> You are calling arch_accept_memory() on every memory allocation if the
>>> memory is not represented in the bitmap. Hard NAK.
>>
>> In which scenarios would we not have memory represented in the bitmap?
>> Guests with <4 GiB? (how does kexec work?) Anything else?
> 
> We create the bitmap that covers all unaccepted memory.

Good! :)

> 
> What memory is unaccepted is up to BIOS. Current implementation of edk2
> accepts the memory in the first 4G range of physical address space. It
> means we won't have bitmap for this range (unaccepted->phys_base >= 4G).

Ah, okay, this comes from the BIOS.

> 
> If the whole VM is smaller than 4G we won't have the bitmap at all.
> 
> We can allocate bitmap for all possible memory. Maybe upto max_possible_pfn?
> But we might not know the value in EFI stub. It costs 4k per 64GiB of
> physical address space.

That's what I would do. 4k per 64GiB sounds reasonable.

> 
> Ideally, we want to know on boot:
> 
>   - what memory ranges are unaccepted - we have it;
>   - what memory range can be removed or added after boot - we don't have it

The SRAT describes memory ranges where we can see hotplug memory. Is 
that too late? We calculate max_possible_pfn based on that.

(don't ask me about special CXL windows and how they are advertised :) )

-- 
Cheers,

David

