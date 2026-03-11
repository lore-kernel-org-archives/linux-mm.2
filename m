Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C91104C001
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 217276B0089; Wed, 11 Mar 2026 06:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4C06B008A; Wed, 11 Mar 2026 06:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6286B008C; Wed, 11 Mar 2026 06:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D68346B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:45:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 694671B896A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:45:59 +0000 (UTC)
X-FDA: 84533452038.03.8BFDE7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id AFA01180009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:45:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpPNZqf5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773225957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7Ch0jEkUeaMt35ROrcluzgUTMynhreVy4fnfUChxBQ=;
	b=AlEI7IcYH2gxFAolqSKLG3Q02umFzg5xS/OmTkjTwNtJKcpkz1sDkIeALAdcTSz2Aw3vKp
	C9SeEej2XVyLooF6BrROQjoEhMI7RGgjxuG9zeK57KmoyqIHis/gNgZJRdTJXFDFCLBi1M
	TJyACCOV7M7TgX8iREiJD4Yo0LH3HkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773225957; a=rsa-sha256;
	cv=none;
	b=kb3bAjap+TG3JGvjFCl9rN86+liWs5sDzYs41jCYWsj5QmL1zjLWolkFVECBP8u3niRD2+
	fHRZ/EC2ZJzNbEnC9YpWVka6IRIzQKKzfC92XhpNpQQofqNgSugFGMv5nHGixCBuGxGQRE
	BjnxAJtdKLPXMY4kvKW5b1x3wle+imI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpPNZqf5;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0392D6013E;
	Wed, 11 Mar 2026 10:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D805CC4CEF7;
	Wed, 11 Mar 2026 10:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773225956;
	bh=IFPP8xL/tyriR55iyTpoF7cQe6VFY5o0GCPBN3AxF4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OpPNZqf52sw1+ys4j6//RMTYfTxUs+fksOxNdTQIvRjACvzEw/MbBmu1rMdts4EfE
	 HR3aF9xIow9QKz1UpWeNS52ACh1bQflI3fU6rOaYeRdKuhUBUYXJA6QAXWG2UPCwoK
	 SIHRj1skIUxdMMEhTPPk0IVqWDgjMBq5Wh0064yVsx9n4ikeQ+WViyZAVXyFLD1EGT
	 UKztsBIdcNz2qc2QVzWnz9ozpRk/veaabyvZqRUPAzS3lyJmhGyB/suJUs7udMtGp9
	 8kB3Bf9fmcoGQNCfExhPW93R7LIiBwsJrP0S4JAwkXtHWYbnpdAgQ5B03jeSUgtdI9
	 1yQ0dYhItV4oA==
Message-ID: <d7f3c613-92f5-4400-812e-a368bee45a41@kernel.org>
Date: Wed, 11 Mar 2026 11:45:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
To: "Boone, Max" <mboone@akamai.com>
Cc: Alex Williamson <alex@shazbot.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Tottenham, Max" <mtottenh@akamai.com>, "Hunt, Joshua" <johunt@akamai.com>,
 "Pelland, Matt" <mpelland@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
 <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
 <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
 <0a652e7e-339e-4f98-b591-7fe5680e2006@kernel.org>
 <6CBB0401-26DD-4EF9-949C-54BEAD3ABA33@akamai.com>
 <5fb9beef-b6fe-401a-aa24-aade48b795d4@kernel.org>
 <0A734214-9E4B-4A65-AFB1-055883639358@akamai.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0A734214-9E4B-4A65-AFB1-055883639358@akamai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 16rkjgm7tg5pcidhn5m56yb5umezd9kb
X-Rspam-User: 
X-Rspamd-Queue-Id: AFA01180009
X-Rspamd-Server: rspam12
X-HE-Tag: 1773225957-877029
X-HE-Meta: U2FsdGVkX19aImH3wpqvNabFzF5Fxkmlg4HdLzzJTqqfT/vjCJFLWanr4FkgsHrnCA9I78DtsnO/bc91q8YOUFraLI0vAXqqEDPfqFy55K+8SUA6BMVc3YTuIRhADYfqrnGsbViAU39MamLJVzb0HqdH0btEAs5qQpKXD58bzaeIWv2qYZnenVMnYDM48XxJiCo0MFmIYhylVgE8fD4MEU6fvefisij9PPLptWeD+R4ZXdXm1iUV3ie/ikJFIcgGAM0QHO6cr4ie/vYHzEv5ecbjX04uCDpAvpPOUHTmX2WPqaP0o27yUG+nFjo2ZrpDPsm4N/Ihk84SCxLUB1s6MMBuycctNu85YCp1vaPbvGo9HkXAmjlvHd/j9HyQPO1ctvheMPvMxiAC4pjCm6FGWeSHy4hSTIiewHL5b1ZE2V9Zb8QBn5jwQ/yDD0GXLzVaH+rnh8drhtMYC8dlktCdWrsWmeRMDWgPhL0b4/Oyq5H+9ehU0g4Gi4jzY9DBCG2BSQY2TCrXT+Z4gDLNuku3C7jeJfj5eWD8SBOZnjQS3zoElNyJv7qHqTcb2JH9XJ/CclKG0kfDp+Z7HV//sSH5OVZiEA/SPlB5ggWhTmPQHE8hydZQIjwNtaZW/TmFb2joEp7DdGBZyyr8bEp7ydwIOmSuEm3SMPLtiTqll4Gi9mr5p7dTKCBgxTCgJQ2n8mskOUUm0IZLUt8WACLk5Pc3zP4lezLFCtj8IhrsildbnVDZe3WUuAwI3Pp9eZbj/C/Q/3jdTuRBixgHgQNwi9xpVQSRIywUirgfU5lhXnuB0S+LQ9id7YYY1gKAt/30V7riBzAMgtv6+iR2XeQsZaofFBiYIAVoeIwmubuiN+IDUfaUfwzqe91UXGnLhK5BoNNI/E33nwB6DFCAkhfBff5ehC0HsU1qKBVZ2yF+B81pb9sncnoenhxDpyhQML693m9eJ55kc+Q809DppphOOhm
 qOVwkvBN
 yEeKn1d0XqBIeSpRmjGdDaJhFxwAhxucv9DHz/VVovH811snCK5OtnMAoyyJJypClXQzWomgI0HLaKJs8V9QEmsYMBjRw/1mwbomkwphjsZIlai/6xHEXRzaqvfHYCHZHU/i8xLQSJIeI2Y2NjqnC364FukI4LxPOZhPl8K3MKHk9AGzGET6oOwg2QI5/GpnraVrdZXoxmBoxAQ70PNmB6QLESxNeZlGIO9P8FANGLMwlRO4yx8ePPa3JTSZ+GX3bll39GC+CqU3r/0Yi3sTtT8Vwftej8L28SmgXvTDO5WB40B8/H6tGacQMoHZINzsOT1XRFBhf1mMGm+DfY9hc4l5Q5U0WDLeNxc8U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 11:34, Boone, Max wrote:
> 
> 
>> On Mar 11, 2026, at 10:59 AM, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> !-------------------------------------------------------------------|
>>  This Message Is From an External Sender
>>  This message came from outside your organization.
>> |-------------------------------------------------------------------!
>>
>>> The -EINVAL originates from:
>>>
>>> vfio_dma_do_map -> vfio_pin_map_dma -> vfio_pin_pages_remote
>>> -> vaddr_get_pfns -> pin_user_pages_remote (mm/gup.c)
>>>
>>> Possibly that’s also the origin of the concurrent PUD modification that requires
>>> the retry in the walker in this patch.
>>
>> We'd have to find out why we manage to trigger a -EINVAL here. I don't
>> see how anything that this patch does could trigger that. So maybe a
>> problem in user space? (calling it on unsupported VMAs?).
>>
> 
> It looks like I was mistaken the EINVAL being from pin_user_pages_remote, 
> rather it originates from:
> 
> vfio_dma_do_map
>   -> vfio_pin_map_dma
>     -> vfio_pin_pages_remote
>       -> vaddr_get_pfns
>         -> follow_fault_pfn
>           -> follow_pfnmap_start (mm/memory.c)
> 
> In vfio_iommu_type1.c, follow_fault_pfn first checks whether follow_pfnmap_start
> returns an error; if it does, it calls fixup_user_fault to fault the mapping in and then 
> retries follow_pfnmap_start to obtain the PFN.
> 
> Sounds to me that the walker is likely re-splitting the PUD entry between 
> the fixup_user_fault and follow_pfnmap_start calls?

Could be. IIRC, there are also scenarios where handle_mm_fault() just
returns success even though nothing was faulted in (e.g., when it
detects some races).

The code in follow_fault_pfn() should likely be updated to handle more
than one attempt. That's also what GUP does.

Likely, follow_fault_pfn() was never taught about PFNMAP mappings that
can be faulted+zapped (in the past they were always static).

If you turn that into a (possibly) endless loop, does the problem go away?

-- 
Cheers,

David

