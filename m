Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA74C982E6
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 11:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448A86B0088; Sun, 20 Sep 2026 07:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9B56B008A; Sun, 20 Sep 2026 07:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C30A6B008C; Sun, 20 Sep 2026 07:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F37386B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:22:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 801AAA5584
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 11:22:47 +0000 (UTC)
X-FDA: 85233903174.01.98820E7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 72BE420005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 11:22:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qyauvioD;
	spf=pass (imf31.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789903365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKc++u6+iWK5zTGmcrD8EFqK8FbKYSwkL4lJttuSggc=;
	b=J8e4INTQGW5YuGTra5QnMWGC59AVazWnZHWo8JFsr7GkJLTFdkDAgZBESwcTRO4NtaajMm
	oPDYAZuabOK6LCtwSNmk4S0+2RCvXi8FrXsZpqaJi2lXelnT5s+GmF/jz5p2QJ2ej1VE4n
	Z7+E9cKi/tvRgso0PkMrZGJh/HyK+zE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=qyauvioD;
	spf=pass (imf31.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789903365;
	b=sfNOZXRIdyiLUBZa6j0unIRLjFjZHSppfkLyqYXBO3Pffa5obUozeklh2htkYKmvxZhWo2
	Xv/xeCqA5F7h4dqJk0T3NttDKiAMLzsudCphwCeC8LIhkQpb3J5vLgDZR/xAHNQS+oAH4Q
	VrPn+vLfMm+f6FJ099kqgeac0s8UyqM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BAE5F1650;
	Sun, 20 Sep 2026 04:22:40 -0700 (PDT)
Received: from [10.57.11.6] (unknown [10.57.11.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E7293F59E;
	Sun, 20 Sep 2026 04:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789903364; bh=TTSAmX1wYFJBw0fvvMopxHoUBy5D4DhhdG2PXyYgxwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qyauvioDKvQzThtvSLBGUf00hBG20UnPEJ0clgBhfu9GvSX1Xg/pZH0QLdPzdQrkr
	 Rn/HeZaQOknJwH5vX2OkJANfmSbhrtNUJOSqrFM1awqd5vGcu96O0475S6SDtKKgrj
	 ScCxtmZV4s18MEl9M3NnkqviXS/2pMgmVqrptrYo=
Message-ID: <629e51dc-75ad-4727-b584-293a4081e7c9@arm.com>
Date: Sun, 20 Sep 2026 12:22:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
To: Ackerley Tng <ackerleytng@google.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Cc: amit@infradead.org, aneeshkumar.kizhakeveetil@arm.com,
 ashish.kalra@amd.com, dwmw2@infradead.org, eberman@quicinc.com,
 fvdl@google.com, gshan@redhat.com, jackmanb@google.com, jackyli@google.com,
 jthoughton@google.com, kalyazin@amazon.com, kas@kernel.org,
 kevinloughlin@google.com, liruxin@google.com, michael.day@amd.com,
 michael.roth@amd.com, mike.rapoport@gmail.com, mvaralar@redhat.com,
 pankaj.gupta@amd.com, papaluri@amd.com, patrick.roy@linux.dev,
 Peter Xu <peterx@redhat.com>, pheragu@quicinc.com,
 pkondeti@qti.qualcomm.com, prty@google.com, psalian@google.com,
 qinkun@google.com, seanjc@google.com, shan.gavin@gmail.com,
 shivankg@amd.com, sidtelang@google.com, tabba@google.com,
 tatashin@google.com, vannapurve@google.com, vbabka@suse.com,
 wyihan@google.com
References: <b91dbfae-20f1-4b9f-a25b-4397afae80f9@kernel.org>
 <16ffff40-4ef0-4312-a700-348603f05c0c@kernel.org>
 <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
 <e4bcc676-34d3-45ed-9eda-51c9a60e977f@arm.com>
 <CAEvNRgFAL6qtSiJpQuga_TxWBr2pK=9LoiON+ZARMp0xFA8rPA@mail.gmail.com>
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgFAL6qtSiJpQuga_TxWBr2pK=9LoiON+ZARMp0xFA8rPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9oaetqiksy8oanoz3xki8yn9a614ztc8
X-Rspamd-Queue-Id: 72BE420005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789903365-331651
X-HE-Meta: U2FsdGVkX1+lECKkxXcIP6Safv978LYQPZ7a/De/ma4JAKT3CQG//y47IL5UKT6hYR7yfHH+/xwzri9w49HiG96h2QhouzjdslMInkGJHIjizxvfOW5HTMjx4WfSRLpEZ4Ln7ReROveYsu/NVdauqlEWu7QcyTi+6Ix2GVCutuTROniDtPpmxevMYfiVYU+rgcS1NrHZJ4VQDfhgDypScgJAQsdGsqJPh1XdXjJVxBAbjwhzxA7d4bbQ5Z2pWA1Y6M1Ag9udeMhGamdh2STcXWWzPVm9XyZ7iEzDv2vVf78oH0YfxJsxGHsOMUCBzMwarpqRGp+7WyDqEwZxBmLxqQ1aKUQVbVlKfS3cM/g/WHmHIq2YaYHdhptQylhr/helwynKx5JARs1z8vaHmWAl27+QAOwvNCZ1o6mpigiWa2Ie1K4XgJel3u2QxLBZaEfVU8g4ESuBW0RWJRms1Qw8tcIs32wU4qEG5uLERys50uGOOOU6JvicljQMfU0BwkyhCfaE0DJOVSs7weeaApK8+0IBAgEzaOHlhIr3Q4x15MimQSyPdi669UCGEDuBcky32xVaFQprF7tVp8cKFLuDipWx7JKTdvnZ8i24vdurANynXOJKRSEMJ74HZKLRLCk+d6hKDQ+LENWv0wxH06TDK5yP14NDW+IZ8AsmR8SJ1JOKuIS72NsO7MoEV0N67YFtjNPV1Xv9ZW6iQYT8wpZ0o2a8DRxEGnw36WvqNvCuAP6T2+9aFhZ2D2uYs5Gih6MLUN61OQutGjriQMA6ozV0wPkxcyOptfpUfH5ZS611Ild2BLHr7g3LnVQGj8GzJAW8rQwiozy5xO6VqM+KJxtet1RvIjKFaWPLIBt26TvoJ+S7sWzVSmYLYSQXpT061UmxA9XaSmKtqdpwO2waau5V3omd2TlDX+YrYCsrxFuyboM06+XkBmAhKTOfp2dXiDbDMxHTocZRhPEGmVW1SL7
 MP4tccZ9
 z3Lrb/phCxYNrJwza8j0JF5JIVYgyZhNjBiewMKGijeiHeFfKIofz5kgNDhwllr0QzPot6PNpN4ENAqUSc/K1w4TAw8JvPRPtI2JO+KP1xWN0GhkpZMzUiLmFkVvtUJC91vy5NtNWmmazfEM2NydYGuCLNiftloV4b6O3iMbh072Tz/u/ZUPuX/JlioGtLXsmvtjhk9yqSwqvDMsntNoaZAPQbpYpcdy8xCDBgxVqJ2WdPMF4jEmHD0DHawCK610KLUF5uOQ5StXQ3Hhahfnn8XbFlhMVdzPOdXP6z/Pc42knCILkiz7SoUQFwCt1BVqV7ivoQkx/4o7RyAPbOqz8d94I7IH7eDoKwCVR8ogP1vAJAnoPyfMCdaS+cC0bpMfEpdZE0Fb5CqNJCkTsmGjQexACqiXuwvuhZ6haxsyIzoNW12jzWPVwk0VPG5cF0fJDtyrYMdzoyyhmMck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

On 18/09/2026 17:21, Ackerley Tng wrote:
> Suzuki K Poulose <suzuki.poulose@arm.com> writes:
> 
>>
>> [...snip...]
>>
>>>
>>> RMI_RTT_SET_RIPAS() is actually saying "host permits the conversion from
>>> base to top", it's not telling the RMM what to set it to, this is also
>>> different from SNP.
>>
>> As mentioned above, host knows the requested "RIPAS" from VCPU exit.
>> RMM knows the "RIPAS" from the VCPU object.
>>
>> Now: Privates vs Shared is translated to RIPAS_RAM vs RIPAS_EMPTY
>> in the CCA (well, roughly)
>>
>> RIPAS_RAM implies, the GPA can be mapped into the private address
>> space of the Realm and it is integrity protected. Host cannot
>> replace the GPA with another content (it can unmap and DESTROY
>> the GPA mapping. But unless the Realm consents to replace the
>> GPA, again via SET_RIPAS request).
>>
>>
>>>
>>> Interestingly RMI_RTT_SET_RIPAS() also errors out if the current
>>> shared/private state is different from the one tracked in the vCPU
>>> object in the RMM? Did I get that right? I'm looking at the base_align
>>
>> Correct.
>>
>>> Failure condition, where it says ripas_pre != rec.ripas_value.
>>
>> Please note that, in such cases, RMM needs a deeper page table level
>> and the error is RMI_ERROR_RTT, indicating to the host that:
>> Look I need a deeper level table to satisfy the request.
>>
>> e.g., base = 4K, but walk.level = 2, and ripas_pre="private"
>>
>> i.e. the requested base is mapped at L2 as block with "private" ripas.
>> If you want to convert the "base" to shared, it needs L3 table. The host
>> would follow up with RMI_RTT_CREATE and then retry the request.
>>
>>
>>> If two vCPUs race to convert the same range to shared, both vCPUs would
>>> have rec.ripas_value = private. The first conversion would be fine, but
>>
>> nit: rec.ripas_value = empty (shared)
>>
> 
> Sorry that was a bad mixture of pseudocode and constants on my part.
> 
>>> the second one woul see ripas_pre = shared but rec.ripas_value = private
>>> and would definitely get an error?
>>
>> rec.ripas_value == empty (shared) as per the guest request. And the RMM
>> will find the state is already "shared" and would confirm the success
>> back to host.
>>
> 
> Oh yes, my bad.
> 
> base_align says (rephrased)
> 
>    if (!AddrIsRttLevelAligned(base, walk.level) &&
>        ripas_pre != rec.ripas_value)
>            return RMI_ERROR_RTT
> 
> Is the alignment check to do with another vCPU splitting the record in
> the table?

Nope. The Host doesn't keep track of the levels at which the S2 mapping
is created nor does it track the "RIPAS" of the regions. That check is
making sure that we don't unnecessarily break down "block" mappings.

e.g., Before boot, the host might set RIPAS for certain regions (e.g.,
populated contents.) The Guest (firmware) could at boot then convert
all of the "DRAM" regions to RIPAS_RAM without checking what was
populated (this is anyway available in the Measurement). Thus a
conversion request may encounter regions that are already in the
requested state (RIPAS_RAM in the above case). And thus RMM
can report SUCCESS if it is already in the state.

Otherwise, we now need to split the block mapping to a deeper level
to apply the "state" change to a subset of the "block" range. This
is why we return RMI_ERROR_RTT when the requested RIPAS doesn't
match the "ripas_pre"

Does that help ? Remember that we don't have the concept of "ACCEPT"
in CCA.

Cheers
Suzuki


> 
> Why compare ripas_pre and rec.ripas_value when the level is not aligned?
> 
>>
>>>
>>> And there's no "accept" step in the guest after conversions, which makes
>>> it different from TDX and SNP.
>>
>> Correct, the guest "permitted" the GPA to be made private with unknown
>> contents anyway. RMM guarantees that the "data" is scrubbed when the
>> GPA is made valid. The advantage with this approach is, once the
>> Guest sets the RIPAS_RAM, the host can lazily donate pages at
>> fault time
>>
>>>
>>> Difficulty in using current gmem hooks that SNP uses:
>>>
>>> * .gmem_make_shared() called from conversions doesn't have the vCPU
>>>     context, finding the right vCPU context is expensive.
>>>       * Sean, don't we already iterate vCPUs to find VMSA pages to kick
>>>         the right vCPUs?
>>
>> We could keep a list of VCPUs with pending set-ripas request for e.g.
>> Or before the vCPU enter, we check the state of the region and
>> do the sync with RMM.
>>
>>> * .gmem_make_private at fault time is too late
>>>       * At the next vCPU enter, the RMM would already read it's state to
>>>         report success/failure, and there's no fault in-between for the
>>>         .gmem_make_private to happen.
>>>
>>> At the call Sean suggested mirroring the RMM's tracking in KVM, but that
>>> sounds quite arch-specific and it's like doing arch-specific validation
>>> within KVM.
>>
>> Suzuki
>>
>>
>>>
>>> p.s. Fuad, for pKVM you also mentioned that you'll need to check if the
>>> guest had requested for conversion first? This might be the same/similar
>>> problem.


