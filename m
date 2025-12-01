Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84E3D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B1E6B00A3; Mon,  1 Dec 2025 13:25:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B71B6B00A8; Mon,  1 Dec 2025 13:25:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7C56B00A5; Mon,  1 Dec 2025 13:25:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBF436B00A3
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:25:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B18988F3B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:25:24 +0000 (UTC)
X-FDA: 84171729768.28.18D5C86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id B660FC000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:25:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RabA16VC;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764613522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YE84AsnF87hBPAT9sOtZ6Vc0Zzgq5gzKkPpAoliDuOU=;
	b=sFhkf2XfoRgjS7fNiFdeJ25KkCRQj+qZ9hIfYxc4A6TT9JWGsPLpfDDLBqqCcGzu/4aX1x
	e0tF7MAQbUeIltsxihMn1DefPT0BuJCepFjRqUIy4F/DCSEowHLMCIL1K+KFNRJ95KZcaZ
	JXxkT2PXwCipgldZ55rSw16wInuL9eQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764613522; a=rsa-sha256;
	cv=none;
	b=I58sw37RSMdZ60NOBszm4WXm0SUPJIkHMU+Tt2gJNxC0TsHpDyDD+beMG2PzPnAuC9j+Wk
	9XYQgGD2u4CMgpayTiFRZ06FhMpDCd5RglCmBqmy6tdOmcDKpg4kJBa0LTfMJ9iboG9M6N
	AJt77Vtx3qOtzRKZyrsBwVac3mh8C4s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RabA16VC;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BDA2C437F0;
	Mon,  1 Dec 2025 18:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90772C4CEF1;
	Mon,  1 Dec 2025 18:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764613521;
	bh=khqEBoJRowkwUJTwMe9ReTa1LRGCK/TU2C8qzxrybG4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RabA16VCKP6L+2WEQBSIDW73cSIljxTxuwmPsge6Zhu7EnptXBylzvB9GrDZN4Jtf
	 +b47dj7o98fk1f6so++CJ3YgZOBlqpKetJ0MKf5CdhYvzcVCJyMtjK8p9lInKSvomp
	 0vg8eRa3cR+oQNsL4zFrvCvoHhS4U1ECNf67YkdFoF8yaOPJpX1DGhl9RwsPOwumJs
	 yyORlI8U0uNXsY03vRWr+XIyd7oSVp+xtd2L6K8YFRyeusIevJZWjQR4Qp8FG84x80
	 jYw/9xLnU23lx/8f25ic/QUmY7UwwA7FC9fW8rddwKL8Jkk8D60qBaTC8UoPhYCoZw
	 A8b9UPATUZEPg==
Message-ID: <2b82fb9f-338e-47e9-bd14-3bdb392dfcbf@kernel.org>
Date: Mon, 1 Dec 2025 19:25:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: "Pratik R. Sampat" <prsampat@amd.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev,
 linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <14df1d99-7df0-4982-8029-e66dfb140399@amd.com>
 <dy65eupwalp5wsljetlto27l6tjjvoygeotjd3n7mk7zjc4dma@jf4hzsy6rtcd>
 <27c06cf2-7500-4875-bd22-f55571fb85f9@kernel.org>
 <c8926ced-3ef3-4c11-9d04-00db388887c5@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <c8926ced-3ef3-4c11-9d04-00db388887c5@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B660FC000B
X-Stat-Signature: azq66jxfpe1ojs9zxxmyhc974hki9ugz
X-HE-Tag: 1764613522-983159
X-HE-Meta: U2FsdGVkX18izW+AhwlpzdHVUJKXXQh2kSuPD+Iqx/RSobES4BuqQ4C1tdbz+9LxkI495gI3EWfzbSRfCphykaZ8LKtep/rkatIx7+ffEzJC3GtR822Qlg8OOKaWeCqAKFVSTTxj7YOdW5L4MYzd9ZPxzpFR0n6ZoudYJyzPZi3kVg7JX8INlPnvkdDzqMUHkaWNy1BPesT2rUtC5co/+tZUb4gdrhALZ4Z5ZvCTjJ5IlTIL7xznpJHJ+OFb9aLOBkixhDZU2m4uDxxk47DlSZGDZBMkqBJthzOh+IAZBW/tO4R3L7nVJpIt2vOXoaZpCY+RmMh3OnR1MDNJfKGwu4ZgBRRF5P6u/YGuWuriE6AYOD2GdDZ7htpYgvHFXqVZ1S6BqbVfPTLjag75pNlNR23Ahwd4VWrnOccDOmtchXz7oY1h8alYPN8+auBAIRWrszr0woRZreGWhI4zDahPYj56SyvxyJxQLq2t36Tj3V1v4F1Gtw4zLfMkKfmOZgMKxwxC7TpTtoG6L0SexNsfT/5nYVMlNIo3hFq46wFh6TdxYFjXL+dgT9PLQGuSmkLGoVDbb1aGQsoTU3tHiqtDY6uiokd9d6nU51tUlTrUT/xo1o3mhyxCMiJ8yS1ob1UCtZ0VZJwhml+88gyP+X8fNVM1wsNIeKwhaPdbyX9QbxB6h2jZo/CxHo3B3oMffIfPH7oAZP7YkaWu/d5zRoMEZM9F/pIY1RCAIBxih0/Vsur+rxZ4tsbGBxje1lC3iMnC8UUX1GRlQ0q7cs+C1/I4X5vxYYvr9VVqca9U/d0PEdhRjmzS8KLyaCItu0aKfIieEt2MSUGDZS9HaQruBBFiIG5NKwi2GwEOz5ebTiDmUmbo4GRGV00oeLm+nqUZXvGx9KPphc88jIYIUznFd3MAugKDS5NHwTOqa+rZTHFbbBAL2+iiFW/bBdHxSUBgsL2ncM9/fyvCL6EfzBVQZiH
 iIUTbLVr
 2mCGSIszrERkU6NAyHGb29G/N2+YYSNTjaZQP4VufOmupfdaytQDRkEQEZkymI+iUxOMdj2nfWsgr1yUgEvnWaObj1tbcz8WMBLXmSxt5ntGHAF4uXQtURMedpJbaQP0ncByGMSN5ZqaY5HwqPtvMcoatAuLmw/H8frKUK4wDLiruPg7GGNPan3lazBtxOuwnQnTjvU1Td9V1CJ/3iwpMf0g5XVySUJJPhImknRlUAEPqZ5CDY3ZexnOFE20Ljd1AXSOB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 18:15, Pratik R. Sampat wrote:
> Hi David,
> 
> On 11/28/25 3:34 AM, David Hildenbrand (Red Hat) wrote:
>> On 11/27/25 18:40, Kiryl Shutsemau wrote:
>>> On Wed, Nov 26, 2025 at 04:27:29PM -0600, Pratik R. Sampat wrote:
>>>>
>>>>
>>>> On 11/26/25 5:12 AM, Kiryl Shutsemau wrote:
>>>>> On Tue, Nov 25, 2025 at 11:57:51AM -0600, Pratik R. Sampat wrote:
>>>>>> The unaccepted memory structure currently only supports accepting memory
>>>>>> present at boot time. The unaccepted table uses a fixed-size bitmap
>>>>>> reserved in memblock based on the initial memory layout, preventing
>>>>>> dynamic addition of memory ranges after boot. This causes guest
>>>>>> termination when memory is hot-added in a secure virtual machine due to
>>>>>> accessing pages that have not transitioned to private before use.
>>>>>
>>>>> How does the hot-pluggable memory look in EFI memory map? I thought
>>>>> hot-pluggable ranges suppose to be declared thare. The cleanest solution
>>>>> would be to have hot-pluggable and unaccepted indicated in EFI memory,
>>>>> so we can size bitmap accordingly upfront.
>>>>>
>>>>
>>>> I'm not quite sure if I fully understand. Do you mean to refer to the
>>>> EFI_MEMORY_HOT_PLUGGABLE attribute that is used for cold plugged boot
>>>> memory? If so, wouldn't it still be desirable to increase the size of
>>>> the bitmap to what was marked as hotpluggable initially?
>>>
>>> I just don't understand how hotpluggable memory presented in EFI memory
>>> map in presence of unaccepted memory. If not-yet-plugged memory marked
>>> as unaccepted we can preallocate bitmap upfront and make unaccepted
>>> memory transparent wrt hotplug.
>>>
>>> BTW, isn't virtio-mem a more attractive target to support than HW-style
>>> hotplug?
>>
>> I would have thought so as well, such that we can just let virtio-mem take care of any acceptance before actually using hotplugged memory (exposing it to the buddy).
>>
>> Likely there is desire to support other hypervisors?
> 
> That's true. We are certainly thinking about how the RAM discard manager
> should look like with multiple states to allow guest_memfd and
> virtio-mem to work together.
> 

Right, there is the QEMU side of it as well.

> Since both paths in Linux eventually converge around
> add_memory_resource(), based on some light hacking in QEMU I could see
> similar hotplug behavior for virtio-mem as well.

For virtio-mem it would not be add_memory_resource().

Whenever we would be plugging memory we would be accepting it, and when 
we would be unplugging memory we would unaccept it.

That is, acceptance does not happen at add_memory_resource() time, but 
when virtio-mem asks the device to transition a device block from 
unplugged<->plugged.

That also means that kexec is not a concern, because the device block 
state will reflect whether memory was accepted or not.

So far the theory :)

So it will be very different to DIMM-based hotplug handling.

-- 
Cheers

David

