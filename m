Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F141062870
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413BA6B0005; Wed, 11 Mar 2026 07:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 397176B0089; Wed, 11 Mar 2026 07:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A396B008A; Wed, 11 Mar 2026 07:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 024916B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:59:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 860F11BC7F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:59:52 +0000 (UTC)
X-FDA: 84533638224.04.1182617
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDD0E10000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:59:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MccQFE2M;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773230390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avFdgyEmxp+APIC/ua1v84vQo5qGvtsR9s+DnHlViA8=;
	b=FiVzJBhl66ycBSHNFUbc5RvA44Qtr9mH/qlnA0SJTTF7UN3LgjhLFVTSI7ocQWwqv4x20C
	9YeZ3AseWDCcTQcbMLzmsOGFCEPX0Cst8ArmXwG/M2iAehHCEccBfRGffqPPnGSsxIK9dC
	MBcpoO/0VRJi2bmnYOKenEqcF8cOCqo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MccQFE2M;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773230390; a=rsa-sha256;
	cv=none;
	b=zLxgo2pQxIU+7PyaThQE1JqHPuKtmYfQ/b35fEtNhnSppFlhZBmw9lu+fzGYcvTu9t7Oym
	yRB8SkYTVkyAZWAFGXZJhtyHAApQFv8jrcJFNPZ/jKcvLY6X8OrBDykhIxhFADdcB6eo3D
	ILKkmFDdYYBJ5ryxwDX+6scasragVLQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24A3260145;
	Wed, 11 Mar 2026 11:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC756C4CEF7;
	Wed, 11 Mar 2026 11:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773230389;
	bh=7L05EWimhuh0T0G4AbugcywDE/W3b5BIQqPB/jlupZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MccQFE2MB47oXOOb4mvYNYBpxTNQR8cze+E2vn7aD2JdRxlDSq3tnJm4uKmDlR4T6
	 5jPIeiV1/VylKk2qCrMJGpOH37F69pZS2Hwl2Zn1K84UC89TmwfLM9H6Ksqhp1g3Op
	 805z8YgcDJknSteio4hG1NxOzCW3e4iXA6dDdiICRLOdDbew+9c5Il2eLEiX5foq3Z
	 hAuGezC4BWpfzlMpKOanpQtGKiIuNo9l3zIIJ0dojxN0Vhb0sOU6BZ2k6eHqzjb2Dj
	 xCu389Z1OELcl9epnnGEcoewycabonntx2VEiuSjazqeuOeFd52N4zQ/aNTHIdg0Qg
	 QyH+HM8rnE3cw==
Message-ID: <6624bc37-8a2a-4718-bd03-32382dd28d67@kernel.org>
Date: Wed, 11 Mar 2026 12:59:45 +0100
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
 <d7f3c613-92f5-4400-812e-a368bee45a41@kernel.org>
 <928CF80F-7436-42ED-9791-F63E3D699CBE@akamai.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <928CF80F-7436-42ED-9791-F63E3D699CBE@akamai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CDD0E10000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 3nweneqqurdpws5j113kueinu4h3pcir
X-Rspam-User: 
X-HE-Tag: 1773230390-295073
X-HE-Meta: U2FsdGVkX18L/acaoWM7XGMTxuCpKQZ4KWqQC0bDzKCxqdIIn5UmdEOEbJX6U+bBe5m6OLn5qmQF5EBWCVX2JXZWyWOIJcm0NKZ+VJVNhERQHr9drDI4t2T0iQzHsE2GSBqpQ16cSsJL1CSGvFR0JKgFALRDHuB/i0OO7PPR0MUjgoR2TTusOnmhvZn3jPD4/WGCh9ao/QUjmoS0LZ/IcTkoq2fubJsQYC+oAqOqX/4oI1/OwNTn/GcBqL0YO1ZiaZjpnN1BIY4tR/PcqaCN81FfyK4ci0fy0Bn2DfwNp+aZ8j518FAWnEz2SsuFVBVuRcfM/STsrAEJahyGL1p6hJKNUVm3Ub9JQpuBXzw1gDmqydEz58QNH7dYuiHk/VW14dtuw1b3DLNx7iFGdo/EWDICQ6KzKdMkDszA0vHlRCgnLzzgYNq8sPxPBmMv+SWirnYBiqzNh0gJdkkIa0asMQ8rAphB9oR8p1oNPDtPS3hF1PBSl0ZAjh38T1+n1lHx0ZlksMP2QpxWpVu+1lcrJJnko7Ud2+iEz1zfKXJnO45a8HL1Xm+gZGJTDBjOmX4E6FLlz8cLOosu6A3DWpofx+X/7dXfSGr/J8z420Q+edD1KheStNbHvNNkPvhOqW7iIogZ8F52Pn3CsbXvZq4T9KURei+sbKJvVN3W1jasMsEXC/sQpF1SZnJ/tiInrYqgAVwG/SuKvPhuYw88v84W+2ISALj921WYDZQGQWAvba06197a/KNo5eG5+GRrrrGAwISCkbHg2oLM1OEmiGQ+b4pNSsMKfNxFgP4oeVAg9Ovus9sUHDZU3jR/YwQZ5sPG2cvRlW0xeeo7dpv2bvvVvG8sVRyugFktsnNJGq0VjrogZrgy9qczX/B0nI3ycy3QPoF/pvyFXJq0nKH2j324zcKgkl+2Qha0R4tvpoodL/dVvVLOgT2aTnB4hY+EAPVevxi88yUZPp8QOiXPKSz
 NllVB+EY
 G4Mbc0WmOPy0mzkVSKHgkZDJI801l9vPPSLucVrSNs/ec2zeHKJ6cwQCCwZ23htZxF1cNJBHf/nXfQBPt/qTKzLhWgGTc7QLgLjO2A2SUApVuCXqQnv6kr4bbnb/jnQ1hhdnkMQPemWsHnZkfcOaXoJnGmcMD04ZUEZ2tPGF25Pc/3mojHN0kMKZYftbSlowlik+ZZ0BWq1ggLtrF1VQlZtqUnqR84FMH0Jv/iZKWQFvmogxVJg4vlUX0SIUzfJuT3etZvIxNmgAzlRRYlS3I02W4J4cyN92gaZaDNrnVv8vD+9C1nuw+fso4hQZTbsXHS6+W7vknssTexLyYjwVqacCzRWHUCxQtGUVq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 12:14, Boone, Max wrote:
> 
> 
>> On Mar 11, 2026, at 11:45 AM, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> The code in follow_fault_pfn() should likely be updated to handle more
>> than one attempt. That's also what GUP does.
>>
>> Likely, follow_fault_pfn() was never taught about PFNMAP mappings that
>> can be faulted+zapped (in the past they were always static).
>>
>> If you turn that into a (possibly) endless loop, does the problem go away?
> 
> Yep, was just trying that - with this change the problem goes away:
> 
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -532,7 +532,7 @@ static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct *mm,
> 
>                 ret = follow_pfnmap_start(&args);
>                 if (ret)
> -                       return ret;
> +                       return -EAGAIN;
>         }

Looks like follow_pfnmap_start() only ever returns -EINVAL: for invalid
parameters (unexpected) and non-present entries.

Returning -ENOENT when there is no actual entry would be clearer. Then
you could just translate -ENOENT to -EAGAIN.

But just always using -EAGAIN should be fine here I guess.

> 
>         if (write_fault && !args.writable)
> 
> —
> 
> I’ll propose that with the VFIO folks when I get the patch for mm/pagewalk.c ready and will refer
> to that patch, or would it be better to propose two commits under the same cover letter?

Probably be best to send two separate patches. One MM fix and one vfio
fix. :)

> 
> I can have a look at follow_fault_pfn but this problem is my first time diving into linux mm
> so that will probably take a while (and some reading up on my end).
No worries, just let me know if you have any questions.

-- 
Cheers,

David

