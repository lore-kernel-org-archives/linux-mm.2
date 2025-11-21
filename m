Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B780BCFC518
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 02:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD9F6B0024; Fri, 21 Nov 2025 21:10:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E9A6B0028; Fri, 21 Nov 2025 21:10:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CD56B002A; Fri, 21 Nov 2025 21:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E548D6B0024
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:10:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3A534F24A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:10:13 +0000 (UTC)
X-FDA: 84136613106.09.6CE99DA
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	by imf16.hostedemail.com (Postfix) with ESMTP id 855E8180005
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:10:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=rsg.ci.i.u-tokyo.ac.jp header.s=rs20250326 header.b=T6UqJC+w;
	spf=pass (imf16.hostedemail.com: domain of odaki@rsg.ci.i.u-tokyo.ac.jp designates 49.212.243.89 as permitted sender) smtp.mailfrom=odaki@rsg.ci.i.u-tokyo.ac.jp;
	dmarc=pass (policy=none) header.from=u-tokyo.ac.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763777412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOwpvMbOVze3sOH4sAmyyrWZTqYGTGuc2w4E1cN8WyE=;
	b=tI9jMU76449WITUsPXVCO5f85GZAnRP8MAUmFzmM9Y+2igvmeOtZLY8FfWe5KEEwfZiIwP
	S4CFxxjpM1lLlsVdrQcuFMwbnDn4QvAJAwFhtqYbkq7zjAcY0L71H5T2/5VazjC/71RywV
	lzXEtj/EQorUL9nM8eZzjbO0zQ/tR6g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=rsg.ci.i.u-tokyo.ac.jp header.s=rs20250326 header.b=T6UqJC+w;
	spf=pass (imf16.hostedemail.com: domain of odaki@rsg.ci.i.u-tokyo.ac.jp designates 49.212.243.89 as permitted sender) smtp.mailfrom=odaki@rsg.ci.i.u-tokyo.ac.jp;
	dmarc=pass (policy=none) header.from=u-tokyo.ac.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763777412; a=rsa-sha256;
	cv=none;
	b=dPg0dJ0hELzhhQvPeZIYgC7NHxgGCG0jx1iiHmr/3kuRkqK8Nflzxoj9z7ivud0F9iRIHV
	5AZFr5s9nFkCzsU5xyH1OSPlGARXsOzsHZGfHCyGjBuDs3VCpm0x0I7sSMUene7+696aQi
	2oiFM1uTr5e2LU0QCGOvtBJaKYlks3I=
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 5AL35vRh076878
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 21 Nov 2025 12:05:57 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=UOwpvMbOVze3sOH4sAmyyrWZTqYGTGuc2w4E1cN8WyE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1763694357; v=1;
        b=T6UqJC+wpbBTgXXLx6ZfpEGeEiH0oZg06cnqXIf/55y13pUwGhfquSbZx1UoNVSw
         1OyoXEIpBtapJil3LXLp0koIyAeiIhWc+prRST+W2G4nv5QWBKzLKdz2XcNIKRTX
         sFYyHDzGL8EJrf6MTSrUhBihCDFJotZgvHsD3ucRA06TlSK+h+mEgkWM1qvR6/JJ
         qDAI60t+9eUOHPHpUdQNjGliGlUa8r+4NolvhIrEGkaHPI1XOF9ggpCODzDdhenu
         4AD8X2o5Y17jtH7aeM+/me5JAAcRnLVJKt5FmSVUPKh8j+U60nyyWie2nVazu/vb
         tah1Zys92BbzV+zSqw5e/A==
Message-ID: <cad8a1a4-8eb0-4e18-99cf-e19f23cd8a0c@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 21 Nov 2025 12:05:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka
 <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
 <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
 <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
 <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 855E8180005
X-Stat-Signature: 9bgy7deaocq6ey81g399i9bdbzqbyu33
X-Rspam-User: 
X-HE-Tag: 1763777411-361695
X-HE-Meta: U2FsdGVkX1+qhnSRz27JGPcq7WfINRUhUrW6loV9kTIxU7ermAoGZh/o8LTTNVpqNRwQr1S++nxqCcetut+GYEbUeFIStfWgnlda6uBXilU0j3oQuR1wcuyRc9ks0odpX+3G17h42l31aSPb3mFLCzPjVTE8p5fj/GbuiT/4X9y33dm+4YmietaRIYPRD1yvoDg19D80Bjw4oxD293WdDkkuW7ujxTAhumktK2a5iXMWmS9lCGFncEXq18ukLJvwkEPu9C/TMrm6vm32nDHq/Pqi6wW7pmN0gxqwse534PgFrkCouHkgTln9ozZL8Zl5tZUy4bSbHEyd0opasLrNidtLXvXdOME/ztw6aKjV1NVXW1G44b1oirc3zWPZie44YJK8c48G2LMUwRWZc9wsgovHuXBq1m1WuoJuG8FEqUyW8oJym1k2LEUOwSjnFQ5UoT/rKub1qlsZKsrtXWwAJh76bfGX6da39q6Zzw3aQ4b09JrEpYYDqy+WHkL2+jVDb/bT04YSkYGvrFV0jXbfXzkKxMQYDVpjJfurYzgER8kkS1ouyPl6LC6OPm04IM3dZtdTKhqQfCEuOMa7znXpw8bCrpaaT/cTRfnTG7sbco+kd7RN9eyz10JJH6wkqvM3QlZ3Yb1zWOLCQcAnTQkGpbpTGSgIibgiM9INRYlgNmFfzw0d0TowPuYAYZE1Bl/RbjpVt5eOEZ3ut79aXwPEHsUi58RydaqUrST+ye7/EQh3PuOVPQZTgPAfEkp9F4bW8Edb3xSAzBPoUkzcj4M992B3ohz6BJBZHn4jFz7ycQ7GTgtV/dSAbVAwJQwEcyAeVEYrWgc44eistXJjz0GBP1KXquyJUTsVguB0Vw+Qume/zeR1E7vIvJX0bz5UL9uhSVKkaox/+uJm9Krc3+kWmJKmi4Osxv9ebLL/jH/YmE+PPu1XhJdPF0y/Cu4UEm2tu0AbXBvdK521KnB9YvS
 ZBGngZEH
 xLfayV2/9qWNz0Fj9AIQZ8N+mgIUfoggxwO7ea4PnfkPbTqbWD9tfwMTkO1mxyr0cmPg0pHBf0lfGh1IcR5S8vmJEpFj6Wd5Sfd1OpNVyDXHkr7UM1ryIYQXgAC0y9UkErDcYPKdskJUERXOHYukfv7W2DET1d4aiq/R+//XJPEuOXuQjqp0aBkA+K7N+OeXpF1/X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I'm another QEMU developer who have been discussing the problem 
motivating the mremap() usage.

On 2025/11/20 18:58, Lorenzo Stoakes wrote:
> On Thu, Nov 20, 2025 at 10:49:59AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 11/20/25 10:35, Lorenzo Stoakes wrote:
>>> On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 11/20/25 10:04, Lorenzo Stoakes wrote:
>>>>> Hi Vivek, thanks for the patch.
>>>>>
>>>>> In general though, let's please not make a fundamental change to mremap()
>>>>> behaviour in late -rc6. Late in cycle/during merge window we're really only
>>>>> interested in existing series, series that are less involved than this.
>>>>>
>>>>> On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
>>>>>> When mremap is used to create a new mapping, we should not return
>>>>>> -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
>>>>>> the old VMA would neither be expanded nor shrunk in this case. This
>>>>>
>>>>> I guess you're trying to be succinct here and 'clone' each input VMA using
>>>>> the 0 source size input.
>>>>>
>>>>> However this can't work.
>>>>>
>>>>> This operation is not equivalent to an mmap(). It may seem to be for
>>>>> ordinary mappings but in practice it isn't:
>>>>>
>>>>> (syscall)
>>>>> -> do_mremap()
>>>>> -> mremap_at()
>>>>> -> expand_vma()
>>>>> -> move_vma()
>>>>> -> copy_vma_and_data()
>>>>> -> copy_vma()
>>>>>
>>>>> Essentially copying the properties of the VMA to the new region.
>>>>>
>>>>> But this doesn't work for PFN map.
>>>>>
>>>>> At _no point_ are you invoking the original f_op->mmap or
>>>>> f_op->mmap_prepare handler.
>>>>>
>>>>> And these handles for PFN maps set up page tables, because PFN maps
>>>>> literally do not exist as VMAs which have properties independent of their
>>>>> page tables like this.
>>>>
>>>> vfio-pci is a bit different, though, as it uses
>>>> vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
>>>> insert PFNs, not at mmap time using remap_pfn_range() and friends.
>>>>
>>>> (see vfio_pci_mmap_page_fault() )
>>>
>>> It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
>>> bug there:
>>
>> Yeah, I am all confused about expansion. The example code looks like all it
>> wants to do is move a VM_PFNMAP mapping.
>>
>>           if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
>>               MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
>>               goto err;
>>           }
>>
>> I guess the expansion is because of iov[i].iov_len is bigger than the
>> original VMA?
>>
>> Is that maybe a bug in QEMU or why are we even expanding here?
> 
> We're going from size 0 to iov[i].iov_len, which is saying 'please make a copy
> of this VMA at a new address'.
> 
> There's never any moving, as input size is 0 :)
> 
> It's a cute corner case way of using mremap().
> 
> We're basically asking for a _copy_. But you can't get a copy of a
> VM_DONTEXPAND/VM_PFNMAP because you need to invoke mmap_prepare (or legacy mmap)
> to get something sensible and you are bypassing that on expansion, even if it's
> a 'clone' style expansion.

Apparently fork() copies VM_PFNMAP without invoking mmap_prepare or 
legacy mmap unless VM_DONTCOPY is set, so I wonder if mremap() can use 
the same logic.

Regards,
Akihiko Odaki

