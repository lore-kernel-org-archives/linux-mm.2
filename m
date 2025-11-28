Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86AB7CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 08:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B516B0026; Fri, 28 Nov 2025 03:10:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A053C6B002A; Fri, 28 Nov 2025 03:10:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCCE6B002E; Fri, 28 Nov 2025 03:10:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7844A6B0026
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:10:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 126348975A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:10:22 +0000 (UTC)
X-FDA: 84159293484.10.11B3C4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4513A1C0003
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:10:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Acs3hkuX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764317420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPUgLyrLVRPj+xDkCuG45E1AHTojdinwpaoVaApco/k=;
	b=Kd+V1JXhX9LZKNBtzV6J2LgN21tKJYfQ61sp8qOI68XIK/qh7Mgl4yV56hhGKX/EM6mn1J
	mnu1AF5IX/t9Jy4Yx9JcqxiRw7qUWig+Aq6BtlSmhGBXj+gtx4c+zRRzhO8tUv3ZNJF+jQ
	U4xRhVQLz8A1L+MT5DrjWWpqJGMI7hE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Acs3hkuX;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764317420; a=rsa-sha256;
	cv=none;
	b=YkGhrOvvgte8cJObRpRv3er3ETfTAWd3NT7YC+OQ/KhSoe5qsf9B9pjxC4mRoLbX//ECbK
	eKtmUA1aV5e1NTE7pB4M2V/cLTYKhccBa5XsMQaQK/NhcqLnxj/fe9zWx6gv9Fc6RQP+GZ
	Yy+osRBVJuMEzgTOfFtBDYeRuqWBkC4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 385D84398D;
	Fri, 28 Nov 2025 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1CAC4CEF1;
	Fri, 28 Nov 2025 08:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764317419;
	bh=sEqqBSoUyz9ZEJQFOk2T8A74KM+YnuZfci4BtVr6KfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Acs3hkuXdCqFgVhHJMvRY+qHQTFITwID5SUPmsy2EZPng4pGzKN/RwGoIPtq7Csog
	 kRMk5eLXzUeLRhKYT+C4IsU0trN+bSCIIXbnTHiZm5rgn77yqc3emDcfe0xs4P0sM0
	 NRwoQGKd7UO+1vVJAdpgcZZBhs5k4l5ItS3YbnXnLXYIMNgWiz0WFrEF53iHMlcb3q
	 NBIdVzsNN1V3EMIvvdT8avUxZSof98aMgjmyjPs93ZHib70dexoa08ZdDeQ/7KRwFO
	 y4NYyBJogBtdlCfkZ7L8Klm0JcS0X0HrujvwgRYiMD9UjlZlPz/DNSETrxAdNPXvqn
	 eDW80vtgeIWqA==
Message-ID: <a3bb0e8e-72c9-4a9c-b347-e899ae29b289@kernel.org>
Date: Fri, 28 Nov 2025 09:10:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] powerpc/pseries/cmm: two smaller fixes
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20251021100606.148294-1-david@redhat.com>
 <557b5500-412a-4d26-8c4b-147c9a00d5fd@kernel.org>
 <87zf86n3vq.ritesh.list@gmail.com>
 <3cc7d401-c77c-4ac8-abb8-c264fbd9aaf0@kernel.org>
 <87y0nqmwaz.ritesh.list@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87y0nqmwaz.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4513A1C0003
X-Rspamd-Server: rspam02
X-Stat-Signature: kgcbfpcc38my5s88aarzko4sbm3ctikz
X-Rspam-User: 
X-HE-Tag: 1764317420-789436
X-HE-Meta: U2FsdGVkX18yLkcWoJXylTEt+ybqA94uvrUQJhSc6i35FYISHr2ulRZG3jsxROuyYUMbA+pzx87WyScUBjigu3uzZhocBKRRMaG/nMjsZx6P3n67k0jmt29cXsOgtFW7lMBWbLWqwFvPHtpuxm5y14k+a2lywzAbmnJZR/UPOI/zTN8zBb02J/vJfjdZj7aMgFGA1EJ28S0+jRXI3HbP7vvU2oDPpK/EX9a4qD0Kbi1m0kbz/wpkRZ05QiNIMEdPjUJwjxuO/DuZm9QEjzWKox1SqhsyxXI/zieXXb3lnModewhJkCZCG+yXN6h/V75WqLU2UjJssHNVPOekCEvYoXXKCMNIoxrZV3FiC5m3L5gBIm+gkBtJiVuPJGWKTWzgOyDKAVQkyoXiQOoTLDRxuQSUvYei/xcsgNw0MzdaQKJhw5xBBAvThEOsi3438oZATer0GpML6vSs5OvUpacSEVLCqWOU8RW4idCiwFIbczQ8zP4DVnkUvF/imPAeYv/y5lMgEvmJoHW1A0pqOfeORdVCgS+dMNJ4n0dJR4nOB7G5o18N19eev33dTBWpV3dlSO/ZHf+ST+FgnwqclbOD+g33KYocVI7rnwYiJDqomlTph1kFpjxhiOvTjZXcxJ7aPIZW5FzhDETydjqvQsFIOHJ1tjtuwxmIYH3CpwxGiI9Mrz+Oy81/UmgiXvkzwsaZgTP01GCUVIrahZpPUs5mgQgmIHXkF7GEcseoO+9lZFs+jKDa7z0jxfKusTOLFMi6Kj17xlvmq3Wp3yicS67LGIrN5hiRQ8yugU+PW+E1JqXEcoaDQtBR64wxLNXRuMghuldr/zJtBV0brXCBItCVU7w2VXFMl/8kcILhZD3MX8MGsx0Dx6G38rUp7QgAcXBnfBEYvH783lEcyfn71sGkwM6rtcw8thT+rINnmDjdr88UZ+vmTCnnkyTZmAXjKIaQnkOzxdg58Ml860RToRj
 BNukgIrF
 UmiyqgBUgL1YNGeKGvf6/vImHUDa58OekOfEpZ8hzQV8/fREwmYyIESu2GBgUCurouAg+aMBra3cbyj6yXpJs44IS2xV/n86Cm2upgFD9/6uoChZ4lPVAq/JnaFmzIZCXNgmjM7wCfp8V5UXhnRY8QzcCsarjoEMqDZlBIZHBOYYeb9m9DTOtbO/gFnT/yKA+4G4wy+/JThW+lBvdyGiY1gRGCcxMhPx1d6jccjSter9DF6a9FBF9NIVGA1zH+HIdeEKft7Zl6an00uiXF909AkdZ6IOkDIO4uAk6cQynetPiEtNz8/1RXDk/SRiCYUSMoBDNjlI8ixZdDdn8UsIiN7ZyEv7Keyk+3mN0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 08:49, Ritesh Harjani (IBM) wrote:
> "David Hildenbrand (Red Hat)" <david@kernel.org> writes:
> 
>> On 11/28/25 06:05, Ritesh Harjani (IBM) wrote:
>>> "David Hildenbrand (Red Hat)" <david@kernel.org> writes:
>>>
>>>> On 10/21/25 12:06, David Hildenbrand wrote:
>>>>> Two smaller fixes identified while doing a bigger rework.
>>>>>
>>>>> Compile-tested only as I don't have an easy way to test right now.
>>>>>
>>>>> I would prefer for these patches to go through the MM tree as I will
>>>>> be sending out a bigger version soon that is based on this series --
>>>>> I split of the fixes from the other stuff.
>>>>>
>>>>
>>>> Ping,
>>>>
>>>> I tried to get CMM running again (using the simulation mode I introduced
>>>> a while back), but so far my attempts to get a reasonable powernv VM
>>>> booted in QEMU failed :(
>>>>
>>>> (e.g., Fedora qcow2 images use xfs, but the open powernv loader is based
>>>> on a 5.10 kernel without some mystical XFS feature ...)
>>>>
>>>
>>
>> Hi Ritesh,
>>
>>> Sorry, I missed seeing this earlier.
>>>
>>> Do you have the link to simulation mode which you are referring above
>>> please? So far I didn't find the support of this beyond Linux LPAR
>>> (pseries), but maybe I missed it.
>>
>> When I did a rework of the CMM balloon in 2019, I needed a way to test
>> it. So I added
>>
>> commit b1713975c31ae20ecc40fd00191ee3fa51445d4a
>> Author: David Hildenbrand <david@kernel.org>
>> Date:   Thu Oct 31 15:29:31 2019 +0100
>>
>>       powerpc/pseries/cmm: Simulation mode
> 
> aah right. I should have looked closely. I was thinking you meant
> somewhere in Qemu, so I was only looking there.
> 
>>       
>>       Let's allow to test the implementation without needing HW support.
>>       When "simulate=1" is specified when loading the module, we bypass all
>>       HW checks and HW calls. The sysfs file "simulate_loan_target_kb" can
>>       be used to simulate HW requests.
>>       
>>       The simualtion mode can be activated using:
>>         modprobe cmm debug=1 simulate=1
>>       
>>       And the requested loan target can be changed using:
>>         echo X > /sys/devices/system/cmm/cmm0/simulate_loan_target_kb
>>
>>
>> I allows for bypassing the absence of FW_FEATURE_CMO.
>>
> 
> Right. Let me give it a try first with pseries Qemu. Otherwise I have an
> access to pseries LPAR too. I can verify it there.

Ah, now I realize my problem: I tried with Fedora 43 in a powerpc VM but 
the modprobe didn't do anything.

Looking again:

# grep CONFIG_CMM /boot/config-6.17.1-300.fc43.ppc64le
CONFIG_CMM=y

So modprob'ing won't do as the module is built in.

Anyhow, compiling a kernel inside a QEMU VM might take a while, so if 
you can beat me to it I wouldn't be mad :)


Re powernv vs. powerpc: yeah, it's confusing. For some reason I thought 
I tested it in the days on powernv. Maybe that's simply because I was 
only able to get my hands on such a machine. Looking again, it should 
indeed be able to be simulated on a simple powerpc VM.

-- 
Cheers

David

