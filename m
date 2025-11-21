Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 381B8CFC518
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952626B0011; Fri, 21 Nov 2025 20:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9023D6B002C; Fri, 21 Nov 2025 20:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0C56B002D; Fri, 21 Nov 2025 20:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68DC46B0011
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:48:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1677E13BA2D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:48:51 +0000 (UTC)
X-FDA: 84136559262.09.7ED2F31
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	by imf15.hostedemail.com (Postfix) with ESMTP id F00C7A0004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:48:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=rsg.ci.i.u-tokyo.ac.jp header.s=rs20250326 header.b=vHSHNKgh;
	dmarc=pass (policy=none) header.from=u-tokyo.ac.jp;
	spf=pass (imf15.hostedemail.com: domain of odaki@rsg.ci.i.u-tokyo.ac.jp designates 49.212.243.89 as permitted sender) smtp.mailfrom=odaki@rsg.ci.i.u-tokyo.ac.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763776129; a=rsa-sha256;
	cv=none;
	b=6NhOuj6/7X9zprwZs9y9OJIVc6kMAWMGSTv85je40KrfNzIX55kZjZgVRJowiVQOLlLf5u
	ESltZyW9M6RIeovo7XAeLy1/pDTO3vGaEYTDDw8aCakDtxqkEeQYEXHlkMduvmQyrhf/53
	X7xBCqwvpbHwaRMeWwd0H4xKMQLZ2HQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=rsg.ci.i.u-tokyo.ac.jp header.s=rs20250326 header.b=vHSHNKgh;
	dmarc=pass (policy=none) header.from=u-tokyo.ac.jp;
	spf=pass (imf15.hostedemail.com: domain of odaki@rsg.ci.i.u-tokyo.ac.jp designates 49.212.243.89 as permitted sender) smtp.mailfrom=odaki@rsg.ci.i.u-tokyo.ac.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763776129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAOdUBA8FZjrhCrEg8AmdCO+5X+HIrg8MCmiKLlwwRY=;
	b=hJWe8sDBA9A0yXwm4KEaO0ADeACtNaYLdajJDWpwfTSd/XCQt0YWZoWIyB3wT0Bo/XVgXZ
	YgEgCqLWQUocaAxh8yF9BDSaiLXpMTuPZ1TNxu/shrGubuCMqfqWlYhzvGft3G1QWLQffy
	S9+vu8aWxw0FNFScnCq57ZIInujJj/g=
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 5AL8mY32036333
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 21 Nov 2025 17:48:34 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=qAOdUBA8FZjrhCrEg8AmdCO+5X+HIrg8MCmiKLlwwRY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1763714914; v=1;
        b=vHSHNKghTM1VTEF8ZToXBKdaTk5YdzJeUfkU8LbYuMeChHfHRSS6gHLUcDWb23cc
         XehSdebr+di1jdyVhPwU6DLRfnj+1ovRU6zd2iDrrcwgfq9cyuI+4fhDqQAUnfks
         ZnudsCvna9CaaEGWK+2Qg3B7iPM2xMTSMLmG51xFEqBrhii1ifx9KbnFustWiu46
         KFlEzeyK1gSJ1J6ufx61/VmVONGNjJy3iNc6pX1w97AfUU9xHD6IJbYpTK11MpQ0
         SrTU9auV22Os9yuqs2mR1llVWq22/zUdvQw/mw4t3quFjgwI+e0pReDvch9KKEcq
         uL8Xr/f3gzVzxMC8AnGzgA==
Message-ID: <c6dc4179-b2c8-4991-8bbe-662dd32a31f5@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 21 Nov 2025 17:48:33 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
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
 <cad8a1a4-8eb0-4e18-99cf-e19f23cd8a0c@rsg.ci.i.u-tokyo.ac.jp>
 <9bc7573a-ab70-47c9-b6c2-4269479bedc6@lucifer.local>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <9bc7573a-ab70-47c9-b6c2-4269479bedc6@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F00C7A0004
X-Stat-Signature: kog4gwbbtwu7krh7u369k8bz46oox7tw
X-HE-Tag: 1763776128-487051
X-HE-Meta: U2FsdGVkX1+9dozAq9/UO63GWYDOlpAxr1MrEODctc9yBRwY7cpIG3DyfWrMeCbscuz+5A73l6YCRTudS6w+/FMJOKgRIuJYW+WlxDSod2W3dZNHV1gfkZfPpKX9+UUAPLbwYt/muY8Y+6GZfFj3swXhRzhmuFnsaBnDLaAbnQmKw8t3W+/ZqWgb9SR34X0IhOHda+0VqBMSVTRZJnfNAVxr6AvO+9mmQXRrFFcBtF3ihxIV/z7qpiV6uDcEtaEAMpjZsO/MoTG9HOert8XTKGBGAfUVGeLkVWFS4KNVlZsz+s6G/RgitU6+LeoBxLheS31e6QkaZIPgHKAR9LVHXoi7C1xBJPGTWKH6wWyopK6SKEAZp0zTJ6pSlpvAbHn+1sJ4YcuPVjsvGCdq3+nJZmCbWEJjad5ci8CYC3c53zuYuSFbcojXNmHtwfuCVZM/YdbIkfmDzIJbwVrldzZqqU04JFaszSuyD7AeIQECWWpdY700BrKMlneJSKO1DnnERdxPsDpIAOA5igiflnfsgQnXhRHf2mmqe/PiLdeHHDyJg9oc9zIHI4kmzNiHc82r5RTJa4NUMrkbwBmN4LwWCb55O3jWmryLdIewtxWpvBLHO775qKXgmHVX/0oN75duPpOi4pu9ppLW7/Ru9ICVZ5+oRi3nYczfo4/4dV0BPtH2I6zbYgSWJSziEDI0mLP1XEUBo5iQ0Ue+6QH6EsCdg7a8r9KXZoKPFxVdg1S19bdt2PFdX0tgrztOu0GgsD8NyrIGr+epgHhZnERwL/LzNk3+HJUzo5l+LtDvKp0WcgiAkx22LRgYIaMiP8iDPQoKvVyo9ppOD6zJM8aAqtOWdEEckuc9z7H5bee17Ke+EWLvQbZ9r6Ny9aplNwwlTcAuimR1K1NzM0s+sYbWxxdjOX14sdvYUnY5xQELh8C53HU5n620uWEjUraPhFtU47uNySDpxnrOoYnJGLJpOeT
 sRvzeuOb
 xVwXADFqKosnGIff3QFbe64DTBeCZb+AZxK3ZkNC04xF56YW0XTeVDJTSjZWoP92RDfRn3yyz1ro/rFkGJvTigH+kPsxUkRY0LWohYyQby5oRnG/lTNfz5Mx05JQ5FZ2XzEQ/55pCofC+tVYeNFrHGcv6KBTI11Qdsgq9HXhPlAuu711MM+rRuqmL1e6L40xl9BqQPLKFWbkKkfjK3VGdqW3OIFCZFPL5Nd8KOkYoA6N9zGCK+JdWmzpniY97jf4CEiYzLCJMG2C5wAlMnut1JT8TgHG608sSaXR0cxPohBj7jPCoKjvJpzAzgW4ogemssT1RTzE2v2oyKZmb9KWsMVBA+2Lue8C1VG2E+imHZF/z/tj4Gg8YG0yVrxPxkDLioa+wCWDP0Ho89EaOajvVzQjBHBAQ72936wKJQ/o8fSjSEvNwBgOskt5rARiSP262IiBLaoY5dvSwMIrY/8gFSyDpZUxUqGVQ+IKBo4D+jLGExFkz7z/Id0hrzi+EAEHAGdWzRpeIxUdB1Vzv1eb9kBb+XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/21 17:03, Lorenzo Stoakes wrote:
> On Fri, Nov 21, 2025 at 12:05:56PM +0900, Akihiko Odaki wrote:
>> Hi,
>>
>> I'm another QEMU developer who have been discussing the problem motivating
>> the mremap() usage.
>>
> 
> Hmm for some reason this mail hasn't appeared at lore how strange.
> 
>> On 2025/11/20 18:58, Lorenzo Stoakes wrote:
>>> On Thu, Nov 20, 2025 at 10:49:59AM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 11/20/25 10:35, Lorenzo Stoakes wrote:
>>>>> On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>> On 11/20/25 10:04, Lorenzo Stoakes wrote:
>>>>>>> Hi Vivek, thanks for the patch.
>>>>>>>
>>>>>>> In general though, let's please not make a fundamental change to mremap()
>>>>>>> behaviour in late -rc6. Late in cycle/during merge window we're really only
>>>>>>> interested in existing series, series that are less involved than this.
>>>>>>>
>>>>>>> On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
>>>>>>>> When mremap is used to create a new mapping, we should not return
>>>>>>>> -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
>>>>>>>> the old VMA would neither be expanded nor shrunk in this case. This
>>>>>>>
>>>>>>> I guess you're trying to be succinct here and 'clone' each input VMA using
>>>>>>> the 0 source size input.
>>>>>>>
>>>>>>> However this can't work.
>>>>>>>
>>>>>>> This operation is not equivalent to an mmap(). It may seem to be for
>>>>>>> ordinary mappings but in practice it isn't:
>>>>>>>
>>>>>>> (syscall)
>>>>>>> -> do_mremap()
>>>>>>> -> mremap_at()
>>>>>>> -> expand_vma()
>>>>>>> -> move_vma()
>>>>>>> -> copy_vma_and_data()
>>>>>>> -> copy_vma()
>>>>>>>
>>>>>>> Essentially copying the properties of the VMA to the new region.
>>>>>>>
>>>>>>> But this doesn't work for PFN map.
>>>>>>>
>>>>>>> At _no point_ are you invoking the original f_op->mmap or
>>>>>>> f_op->mmap_prepare handler.
>>>>>>>
>>>>>>> And these handles for PFN maps set up page tables, because PFN maps
>>>>>>> literally do not exist as VMAs which have properties independent of their
>>>>>>> page tables like this.
>>>>>>
>>>>>> vfio-pci is a bit different, though, as it uses
>>>>>> vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
>>>>>> insert PFNs, not at mmap time using remap_pfn_range() and friends.
>>>>>>
>>>>>> (see vfio_pci_mmap_page_fault() )
>>>>>
>>>>> It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
>>>>> bug there:
>>>>
>>>> Yeah, I am all confused about expansion. The example code looks like all it
>>>> wants to do is move a VM_PFNMAP mapping.
>>>>
>>>>            if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
>>>>                MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
>>>>                goto err;
>>>>            }
>>>>
>>>> I guess the expansion is because of iov[i].iov_len is bigger than the
>>>> original VMA?
>>>>
>>>> Is that maybe a bug in QEMU or why are we even expanding here?
>>>
>>> We're going from size 0 to iov[i].iov_len, which is saying 'please make a copy
>>> of this VMA at a new address'.
>>>
>>> There's never any moving, as input size is 0 :)
>>>
>>> It's a cute corner case way of using mremap().
>>>
>>> We're basically asking for a _copy_. But you can't get a copy of a
>>> VM_DONTEXPAND/VM_PFNMAP because you need to invoke mmap_prepare (or legacy mmap)
>>> to get something sensible and you are bypassing that on expansion, even if it's
>>> a 'clone' style expansion.
>>
>> Apparently fork() copies VM_PFNMAP without invoking mmap_prepare or legacy
>> mmap unless VM_DONTCOPY is set, so I wonder if mremap() can use the same
>> logic.
> 
> It's because it's literally copying page tables in the exact same range exactly
> as they are to the exact same virtual address.
> 
> You're asking for a _brand new mapping_ of effectively _any size whatsoever_ at
> a _new virtual address_ while _retaining the original mapping_.
> 
> Also note that you're copying the VMA exactly as-is with _all internal private
> metadata_ duplicated, but now in another process.
> 
> It's entirely different.
> 
> For better or for worse (*ahem*) we've given huge flexibility to drivers to do
> what they want with this stuff. Which means -literally anything- might be stored
> in page tables, whcih means there might be alignment requirements for the
> mapping, which means that page tables may be established in .mmap,
> .mmap_prepare, which means that internal state might be tied to the VMA that is
> only correctly set up in .mmap[_prepare], etc. etc.
> 
> So yes - if we exactly duplicate this with everything virtual, metadata being
> _exactly the same_ in a _brand new process_ - with the driver _knowing_ that a
> fork might happen (and setting VM_DONTCOPY in cases where it doesn't want it) -
> then we're good.
> 
> But that's something very different from 'allow arbitrary copies of the VMA'.
> 
> In terms of mremap() this is very simply an expansion and we won't be supporting
> this kind of operation there sorry.
> 
> I may go work on an idea to allow this behaviour via a new approach, but it
> won't be in mremap().
> 
> Note that I replied to Vivek with some ideas as to how to do this in userland
> (thanks to David for suggesting btw forgot to say ;) so you _should_ be able to
> get what you need here without needing mremap() to do something different.

I understand that the logic to copy page table cannot be borrowed from 
fork(), but I thought that copy_vma_and_data() could be extended to 
support this scenario.

If I understand it correctly, it does almost what we want; copying a VMA 
and page table with a new size. It also calls vma->vm_ops->mremap to let 
drivers know the new VMA. However it doesn't copy the page table if 
old_len == 0 and clears the old page table entries, which prevents using 
the function to copy VM_PFNMAP.

So my idea is simple: change copy_vma_and_data() to copy the page table 
without clearing the old page table entries if !old_len && 
(vma->vm_flags & VM_PFNMAP).

Of course we still need to respect VM_DONTEXPAND so it should be also 
checked that the new VMA is a subset of the old one.

Can this work?

Regards,
Akihiko Odaki

