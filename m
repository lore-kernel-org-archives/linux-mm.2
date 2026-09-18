Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5302C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA7F6B008A; Fri, 18 Sep 2026 05:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2836B0092; Fri, 18 Sep 2026 05:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD8736B0093; Fri, 18 Sep 2026 05:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB466B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:28:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25F49A0609
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:28:30 +0000 (UTC)
X-FDA: 85226357580.21.8788342
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E4F21C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:28:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rcg1C6WL;
	spf=pass (imf20.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723708;
	b=Yz2BghgTnxaSPoQOvlj3OWrtKB1ahhHs3jEOEcqJWhWyMVdRP4HgVgYz/VBvUeq0dITDEL
	xL/wZv6ftFOOnAEOoR5AWUkKesxOeX/3wDXGtP9vOzC4BY/A3PJ4jt0g5xG9Xn9UVnH4Fs
	csJHpVj4OMopGo5/KwtYmopnt7XtUjE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Rcg1C6WL;
	spf=pass (imf20.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7p0U3kSOrjrFx6F7E9kpOU9KjzgEY7JwcdJBUD5FygU=;
	b=EtL+naSfjqU7FxE8ZvPDtXZ6VGrKgBSeUJ+0iYHuyeIAq+zlCfcM8TrKviIzPAP5wj+Nhi
	jJ9Rl0AMBOyud85V3cBNtDhWs5x12G8YY5fqKD+cUuojG9/dO5Q4P829o5PEpDBLFCCYnM
	OwmyotocfgMQDqDFL8VjAW67C2SX37k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B660B168F;
	Fri, 18 Sep 2026 02:28:23 -0700 (PDT)
Received: from [10.57.6.197] (unknown [10.57.6.197])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0778B3F882;
	Fri, 18 Sep 2026 02:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789723707; bh=tYBKHE4ggx852HXzautUQ93L8BJ69LAKf0vSTSY3Zo8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rcg1C6WLOQm/5oo/BvAUOmKYpTngHeRnN/Wrbv8cgqaO273ngaLlEPZVUiY115TCz
	 iRCnYWbt8YnZbtQqSyzay55dfo9ZEZ81lfuKErsswRk/rF9+HLWrWK5S7QWxnxhP7W
	 T7j6lKfS0qPE2XNX/WK7hv9ul8/vPZBgyu5PrQ3k=
Message-ID: <e4bcc676-34d3-45ed-9eda-51c9a60e977f@arm.com>
Date: Fri, 18 Sep 2026 10:28:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2026-09-17
Content-Language: en-GB
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
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <CAEvNRgGW_VHmT82q+bUqHh_5G2Z9sUF1jJOTiVN4Z8_cA9A50g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E4F21C0003
X-Stat-Signature: zi9idc7umo3skfzus7g37tyccfytu5rx
X-HE-Tag: 1789723708-440262
X-HE-Meta: U2FsdGVkX19VagCv7uflFPFrkqMZkKN0ZYXmJoVc3D9MwfePLV5BFsOJRtI3M8HOVqSoXN3OehynwsfuEVgoZgLtkRIMDX4mxz03p6fI6f87QE6L/EDRXXHLxRycHsJr/sH6AzZvk2oylIQvQ3KqCQ1yaUy05x6WPDvjAiHjnFwTnKPtKj7HvmEThCWlDT1dU2dPV6yxoHnGLRsU7jj/D7Xo+WHdVmQRCxNlU3kd9G+UIGfhi59xN3cojHXjDtScrDd1ikSxrVpA2Hk55PpStKZ5YmkpZoPRzPtyb41KxLop0eWBJz0ArjNPFbcsDeT5kFGksN4JTWVFxc3yHJ2U14F7OFXoDhPAjm8WhCw7sN9sZbHpP1GU+45kcSj5ZzqjjMNm02ZmdkhDJeneLjPu7ltUYqv1TqUNek0HLUU7362NBmTi0JLre1LbJnYaIkpgvJ45dwdIcOKZafH+nqTaluTGx5cIVpwsPz7h8cnPYW+rMJuRV2SGhT73pA3pDZ6g9rgzQbodd0Q5QUs01DBnTVxmiSqfs7rgvwjbjYvEvIOc2GTsXLwAOeXKX9EqwTtMUZIkInI4t2Hssk0HJ2Rsapy6/0g3gXKNTUl7k8lLDvRP/DIWgcdaWkUTDJyAhvJku4tlV4JU9HQ5kNLsAz2L4PzdiifeqNImejLAxg3kLDF9zTPlpeq0jBS7DL/Gyhdu57HPiQ0Q4lieK3kdY9rngVsdRjc2A7CnpDEa21OCsKYNk/YBkyoznFb7yZ6N/p6uIjxCtV1WVz0UiKzmvf1YeI3tFRi9gK/T5INJIt5yEdep/GVNOFMZpO55kEuuy117m+NhEpryYd36y8SiYUouoDuvwJNpzxcRJ+SWnpp/EXoObQvINAwVeCf4gA80B3Sps1QXGCdS+CDMRByNNwIfQsVohF/7QS6qyCdCiBJ37DO3h8xdfQrnJu6VaFfrRAT+aWfsXMmNQDbUtABtO9w
 xX1SSh4o
 juJzl8rHKUhIaN8tzgHkTWHP/e6uVgbefoI6MnwOA8xg1Lp//ERvUOG+kD7XrZ2moAUGuBKFWiXhvCtJ8UbtoT/iDGHINfQMe3Jy8NrhrytAiShsH5SJf++P+gmQZnd4dY4ByhoP9IVL9pPu3KgKpHD2SvxMKgKgKBGOqcxTaPqzE0wOkSxmIxiFmIyzbTBUvPGvmevZ6VGZ9890WLtVVN6/jQ1eVitu7mwQ6DLKEn82ejFQTS8/30Mz6WsgaMEzlcVaQazlK8pomU8P+XzD2h7xNic0+X2ZAtpBZJetr58jw8KIeZLrng4ROTfepFByInyGyY+YlRx9H1UhtryJdcrf7pb6cXSJcZ60/Rov6hXj4+dNBI7uk6OIYFXbiz9WNeIsVcgaW0R9ofT07ByRwB2kozpGZW4yo9HSzKQd8YU1VVco=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley

Thanks for the writeup, my responses in-line.

On 17/09/2026 19:41, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 9/16/26 17:11, David Hildenbrand (Arm) wrote:
>>> Hi,
>>>
>>> Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
>>> 2026-09-16 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.
>>
>> Sorry, tomorrow (17) of course :(
>>
>> --
>> Cheers,
>>
>> David
> 
> I'd like to try and restate the conversion problem we discussed today to
> understand better :)
> 
> CCA's conversion protocol is:
> 
> 1. Guest tells RMM to convert a GPA range
> 2. RMM notes down, in a vCPU object within the RMM, the conversion range
> 3. On re-entering the guest, RMM tells the guest if the conversion
>     progress, something like:
>       + success, GPA start to GPA end was converted or
>       + failed, (with some error?)
> 4. Guest can
>       + Be happy that whatever it requested is fulfilled
>       + Retry to finish the parts that wasn't yet converted or
>       + Be sad that it failed and figure it out.
> 

Correct.

> I looked more into it and I'm surprised that what I was thinking of as
> "tell RMM to mark shared" isn't even correct.
> 
> RMI_RTT_SET_RIPAS() takes these parameters: rd (the realm), rec_ptr (the
> vCPU), base (GPA start) and top (GPA after, or base + size).
> 
> RMI_RTT_SET_RIPAS doesn't even take anything about shared or private!

This was deliberately removed because :

1. Host knows the original request from the VCPU exit.
2. RMM caches the request (range, ripas) in the VCPU object
3. Host confirms to the RMM, complete the RIPAS transition by
    RMI_RTT_SET_RIPAS(), with the values it received from the VCPU exit.
4. RMM matches the range provided by the host to match with the VCPU
    cached request and performs the "ripas" transition as per the
    request from Realm.


> 
> RMI_RTT_SET_RIPAS() is actually saying "host permits the conversion from
> base to top", it's not telling the RMM what to set it to, this is also
> different from SNP.

As mentioned above, host knows the requested "RIPAS" from VCPU exit.
RMM knows the "RIPAS" from the VCPU object.

Now: Privates vs Shared is translated to RIPAS_RAM vs RIPAS_EMPTY
in the CCA (well, roughly)

RIPAS_RAM implies, the GPA can be mapped into the private address
space of the Realm and it is integrity protected. Host cannot
replace the GPA with another content (it can unmap and DESTROY
the GPA mapping. But unless the Realm consents to replace the
GPA, again via SET_RIPAS request).


> 
> Interestingly RMI_RTT_SET_RIPAS() also errors out if the current
> shared/private state is different from the one tracked in the vCPU
> object in the RMM? Did I get that right? I'm looking at the base_align

Correct.

> Failure condition, where it says ripas_pre != rec.ripas_value.

Please note that, in such cases, RMM needs a deeper page table level
and the error is RMI_ERROR_RTT, indicating to the host that:
Look I need a deeper level table to satisfy the request.

e.g., base = 4K, but walk.level = 2, and ripas_pre="private"

i.e. the requested base is mapped at L2 as block with "private" ripas.
If you want to convert the "base" to shared, it needs L3 table. The host
would follow up with RMI_RTT_CREATE and then retry the request.


> If two vCPUs race to convert the same range to shared, both vCPUs would
> have rec.ripas_value = private. The first conversion would be fine, but

nit: rec.ripas_value = empty (shared)


> the second one woul see ripas_pre = shared but rec.ripas_value = private
> and would definitely get an error?

rec.ripas_value == empty (shared) as per the guest request. And the RMM
will find the state is already "shared" and would confirm the success
back to host.


> 
> And there's no "accept" step in the guest after conversions, which makes
> it different from TDX and SNP.

Correct, the guest "permitted" the GPA to be made private with unknown
contents anyway. RMM guarantees that the "data" is scrubbed when the
GPA is made valid. The advantage with this approach is, once the
Guest sets the RIPAS_RAM, the host can lazily donate pages at
fault time

> 
> Difficulty in using current gmem hooks that SNP uses:
> 
> * .gmem_make_shared() called from conversions doesn't have the vCPU
>    context, finding the right vCPU context is expensive.
>      * Sean, don't we already iterate vCPUs to find VMSA pages to kick
>        the right vCPUs?

We could keep a list of VCPUs with pending set-ripas request for e.g.
Or before the vCPU enter, we check the state of the region and
do the sync with RMM.

> * .gmem_make_private at fault time is too late
>      * At the next vCPU enter, the RMM would already read it's state to
>        report success/failure, and there's no fault in-between for the
>        .gmem_make_private to happen.
> 
> At the call Sean suggested mirroring the RMM's tracking in KVM, but that
> sounds quite arch-specific and it's like doing arch-specific validation
> within KVM.

Suzuki


> 
> p.s. Fuad, for pKVM you also mentioned that you'll need to check if the
> guest had requested for conversion first? This might be the same/similar
> problem.


