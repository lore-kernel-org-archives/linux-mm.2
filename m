Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C701FCFC515
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 01:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C026B0006; Fri, 21 Nov 2025 20:41:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73AA6B0010; Fri, 21 Nov 2025 20:41:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0286B0011; Fri, 21 Nov 2025 20:41:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC3346B0006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:41:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39E7013057A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:41:24 +0000 (UTC)
X-FDA: 84136540488.11.7AEBC76
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	by imf27.hostedemail.com (Postfix) with ESMTP id 462494000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 01:41:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=rsg.ci.i.u-tokyo.ac.jp header.s=rs20250326 header.b=tJWKa5Jq;
	spf=pass (imf27.hostedemail.com: domain of odaki@rsg.ci.i.u-tokyo.ac.jp designates 49.212.243.89 as permitted sender) smtp.mailfrom=odaki@rsg.ci.i.u-tokyo.ac.jp;
	dmarc=pass (policy=none) header.from=u-tokyo.ac.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763775682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbvFIVW4lXzs0g+EYOEeGYBf26Jgl0xz0flv6OQ4R3o=;
	b=e31WFLOZ5Zg0JCztO4mv8i9vw3JZ3llIYrXOQ20mVZgJoJKRFKMUq2MgQyCJ9mMi+S4Xud
	R5hN2Ge4X5Ul6sBQ9fviaaFS1ldr4N3C+hcg8iVgwWFve42kbJO7pie3pcHCkb4oNRKE8X
	XYunbWXLTbR3K1z7kW4GWz76oYwgu/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763775682; a=rsa-sha256;
	cv=none;
	b=W9ZF6BoOZFRg4WT84cu2VBkq/4jUiPoFsGVjdw7QTsA9YHMfE8Zr1wKvu7uHbVNYt0WhSN
	x20WXcaJSuq3PWr73SFjNA7lVXJt7irPOmOhLlOCpELgQthBdfgd2N+nao4znh6rPCJygE
	hd1krdI73TPUVn0qUEkaXwzBheKZLsQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=rsg.ci.i.u-tokyo.ac.jp header.s=rs20250326 header.b=tJWKa5Jq;
	spf=pass (imf27.hostedemail.com: domain of odaki@rsg.ci.i.u-tokyo.ac.jp designates 49.212.243.89 as permitted sender) smtp.mailfrom=odaki@rsg.ci.i.u-tokyo.ac.jp;
	dmarc=pass (policy=none) header.from=u-tokyo.ac.jp
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 5ALAGeVN067190
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 21 Nov 2025 19:16:40 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=fbvFIVW4lXzs0g+EYOEeGYBf26Jgl0xz0flv6OQ4R3o=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1763720200; v=1;
        b=tJWKa5Jq6xibMk5dnQD1IBgZkqZYgXVanhHG7xhBDEHOiOSXD6vYQBx/JxASfFy7
         80GYh6y+xf3JYKcCNPrlgCx0uc6wRScGzy8fjKnf3BWNYf4MEKyMSZilnSI9T2yv
         z7E5xPHAiIAraBEwiiFBaDvtibC+ra4EV/A7hZlD6zmV7UDh9zoN2CX79IcmHb7g
         hyWfycSDMXRL9fLpNSy+fGE9WHzp0HVxlUNhFl6ObJ0Bri8IOCthSFr4eL7+Cnwx
         L/HE+A7sSi2bDaY6UV6bXmZSHMD49/7cnNVwiDthnaZK1xBSuUbuMRz6PnUYhR5b
         WL/zWgyycBnKIoZmvscDTA==
Message-ID: <8b750d6a-fcd0-40ac-9ecd-e827bc517aac@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 21 Nov 2025 19:16:39 +0900
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
 <c6dc4179-b2c8-4991-8bbe-662dd32a31f5@rsg.ci.i.u-tokyo.ac.jp>
 <a752bfd5-92ad-4283-959d-37f39bbe722e@lucifer.local>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <a752bfd5-92ad-4283-959d-37f39bbe722e@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t6gucy3n499u63cy3uuhs7uep6ins69i
X-Rspam-User: 
X-Rspamd-Queue-Id: 462494000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763775681-662226
X-HE-Meta: U2FsdGVkX1/SIqIpJA9g8+8rrol8iQKlqY7CuyRV4/tuYB7DD/qKHRuyvU8wGC430TLhMhTUvTUcorRThSwfYqWBHZqxjeXppZvpYewzO2GwmTJW9TGOUEHBhJHbLNvTeE7yNLg8l+nUwf0MEw8U6gk9GW663qlCy0a0gxsZ3BqnD9e6QXerBpV1BDD342B4etScuqeTYfdIutyEwWC0TqsxNU1uyz6kAjl/J07wsYC4ssqeZX6z3SHxQK1AMGevrynEhfTeVL1eOcNAyH2gIJ9aZKX24NzwwkoKVIHhwz6oEMqE8HO064eodosFvyRNY9erxqYGXCKvpH828uDVwvT+mDXb33ZSYPrfMeItePyKV0h5gAEQi6rRpUz1dtCpkZCZfjpoo4dx57L4yv3VrrtwdcmK4a09u6eCGmOi3JMNg/eQF7SN9XoDJgXPpahwSRcGcggrXKRZbu7Fzfxiy9NDPLeXBo3ItmXKcyqoDG0C9rLQaeuM5k6dKhKf/J/LiPyvzVLUbg5m9tExkCVthflkm3LqJtFrQ4kqxOtP3L7zO52GlsgkezkvP+766gSt5xFSssO+TPQ2nAdYCn3jcp5eMUytSULtCer1ya7zAZSOZ5MCYFlJqxvx7bD4UOFt5CtJeglYLZXSpeQitCAVpEiUI6bY8DcWN8Kt6C/cbg+/BDCvXitlo+8xutuSvCt7VhiAKwIMLAmdyZ30dOKNzHzDWcndajdpO0dUC2no0SN6P126qzdgSuGa1i8hhYLqsbtGOIRyUH1QNtu+zprbAabk/UdcrFlsDcp1Qzmd2wuVPADNJgX5C9Dgz3OQXAMcRmkpBUzOZTj1MkqdiIBWZidEzAYPovocI2wbgchOeqGZfjdi7EQqq0KWw+KkXolE3n9J7CF76L0oGKKQyv31Wojkc88ymlzbDQlh4l35EuwN5b55b9k22m01H/8/bQrbnMtMfGh+W1Pk8hdX7W5
 /uNRi54U
 oQRahPTUNjtN2cY8R+VQZN+KCjQQq8/11W5nrsbrSGwv7pwAjfowTM1Rhao2RspJxGakHGRk7fcOIuN7UoQyFCGklrjDhHY0+P3pH/gPL+5t0lO9kbqcIKUZThLFHbOXaTsHA9TU/I5JmZuMi3z2FG5hsDHY/KOuQzRHSJTmodPgh1skv2M5EccIiYwGlQf5YGmf5pwo1EuvmWTsp8NIKW/LYe/ub/5VrwteYpjf7i6lUGkHiv6ZUDAZYeeXyvUXPO9rx38HIwG8PuHM2AxzQsOdjY4kP+GGno5w839VM21+bs+hlIbDfc0BfTx+IK6HfDd7KDvyW4DnnOEU/fSOaa6su5IE7GjWB5GU+XNb7tL68C+L2wEGSAbnvPO1ELlpCLhLeN/aI3fIVUc3oMTcuEJoZ9uaWGij8g7QkcQDVwOGaA0fTZ7UaiklivEBf7gZIcSEWSoer6NtHs/wtN/ZbgtC6ACarHIy51Mitac2T6FJOE7Los5jvy9H/1sQ2NbxJqI+Abmj8baxmYYbpWR6KkjoohQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/11/21 18:10, Lorenzo Stoakes wrote:
> On Fri, Nov 21, 2025 at 05:48:33PM +0900, Akihiko Odaki wrote:
>>
>>
>> On 2025/11/21 17:03, Lorenzo Stoakes wrote:
>>> On Fri, Nov 21, 2025 at 12:05:56PM +0900, Akihiko Odaki wrote:
>>>> Hi,
>>>>
>>>> I'm another QEMU developer who have been discussing the problem motivating
>>>> the mremap() usage.
>>>>
>>>
>>> Hmm for some reason this mail hasn't appeared at lore how strange.
>>>
>>>> On 2025/11/20 18:58, Lorenzo Stoakes wrote:
>>>>> On Thu, Nov 20, 2025 at 10:49:59AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>> On 11/20/25 10:35, Lorenzo Stoakes wrote:
>>>>>>> On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>>>> On 11/20/25 10:04, Lorenzo Stoakes wrote:
>>>>>>>>> Hi Vivek, thanks for the patch.
>>>>>>>>>
>>>>>>>>> In general though, let's please not make a fundamental change to mremap()
>>>>>>>>> behaviour in late -rc6. Late in cycle/during merge window we're really only
>>>>>>>>> interested in existing series, series that are less involved than this.
>>>>>>>>>
>>>>>>>>> On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
>>>>>>>>>> When mremap is used to create a new mapping, we should not return
>>>>>>>>>> -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
>>>>>>>>>> the old VMA would neither be expanded nor shrunk in this case. This
>>>>>>>>>
>>>>>>>>> I guess you're trying to be succinct here and 'clone' each input VMA using
>>>>>>>>> the 0 source size input.
>>>>>>>>>
>>>>>>>>> However this can't work.
>>>>>>>>>
>>>>>>>>> This operation is not equivalent to an mmap(). It may seem to be for
>>>>>>>>> ordinary mappings but in practice it isn't:
>>>>>>>>>
>>>>>>>>> (syscall)
>>>>>>>>> -> do_mremap()
>>>>>>>>> -> mremap_at()
>>>>>>>>> -> expand_vma()
>>>>>>>>> -> move_vma()
>>>>>>>>> -> copy_vma_and_data()
>>>>>>>>> -> copy_vma()
>>>>>>>>>
>>>>>>>>> Essentially copying the properties of the VMA to the new region.
>>>>>>>>>
>>>>>>>>> But this doesn't work for PFN map.
>>>>>>>>>
>>>>>>>>> At _no point_ are you invoking the original f_op->mmap or
>>>>>>>>> f_op->mmap_prepare handler.
>>>>>>>>>
>>>>>>>>> And these handles for PFN maps set up page tables, because PFN maps
>>>>>>>>> literally do not exist as VMAs which have properties independent of their
>>>>>>>>> page tables like this.
>>>>>>>>
>>>>>>>> vfio-pci is a bit different, though, as it uses
>>>>>>>> vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
>>>>>>>> insert PFNs, not at mmap time using remap_pfn_range() and friends.
>>>>>>>>
>>>>>>>> (see vfio_pci_mmap_page_fault() )
>>>>>>>
>>>>>>> It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
>>>>>>> bug there:
>>>>>>
>>>>>> Yeah, I am all confused about expansion. The example code looks like all it
>>>>>> wants to do is move a VM_PFNMAP mapping.
>>>>>>
>>>>>>             if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
>>>>>>                 MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
>>>>>>                 goto err;
>>>>>>             }
>>>>>>
>>>>>> I guess the expansion is because of iov[i].iov_len is bigger than the
>>>>>> original VMA?
>>>>>>
>>>>>> Is that maybe a bug in QEMU or why are we even expanding here?
>>>>>
>>>>> We're going from size 0 to iov[i].iov_len, which is saying 'please make a copy
>>>>> of this VMA at a new address'.
>>>>>
>>>>> There's never any moving, as input size is 0 :)
>>>>>
>>>>> It's a cute corner case way of using mremap().
>>>>>
>>>>> We're basically asking for a _copy_. But you can't get a copy of a
>>>>> VM_DONTEXPAND/VM_PFNMAP because you need to invoke mmap_prepare (or legacy mmap)
>>>>> to get something sensible and you are bypassing that on expansion, even if it's
>>>>> a 'clone' style expansion.
>>>>
>>>> Apparently fork() copies VM_PFNMAP without invoking mmap_prepare or legacy
>>>> mmap unless VM_DONTCOPY is set, so I wonder if mremap() can use the same
>>>> logic.
>>>
>>> It's because it's literally copying page tables in the exact same range exactly
>>> as they are to the exact same virtual address.
>>>
>>> You're asking for a _brand new mapping_ of effectively _any size whatsoever_ at
>>> a _new virtual address_ while _retaining the original mapping_.
>>>
>>> Also note that you're copying the VMA exactly as-is with _all internal private
>>> metadata_ duplicated, but now in another process.
>>>
>>> It's entirely different.
>>>
>>> For better or for worse (*ahem*) we've given huge flexibility to drivers to do
>>> what they want with this stuff. Which means -literally anything- might be stored
>>> in page tables, whcih means there might be alignment requirements for the
>>> mapping, which means that page tables may be established in .mmap,
>>> .mmap_prepare, which means that internal state might be tied to the VMA that is
>>> only correctly set up in .mmap[_prepare], etc. etc.
>>>
>>> So yes - if we exactly duplicate this with everything virtual, metadata being
>>> _exactly the same_ in a _brand new process_ - with the driver _knowing_ that a
>>> fork might happen (and setting VM_DONTCOPY in cases where it doesn't want it) -
>>> then we're good.
>>>
>>> But that's something very different from 'allow arbitrary copies of the VMA'.
>>>
>>> In terms of mremap() this is very simply an expansion and we won't be supporting
>>> this kind of operation there sorry.
>>>
>>> I may go work on an idea to allow this behaviour via a new approach, but it
>>> won't be in mremap().
>>>
>>> Note that I replied to Vivek with some ideas as to how to do this in userland
>>> (thanks to David for suggesting btw forgot to say ;) so you _should_ be able to
>>> get what you need here without needing mremap() to do something different.
>>
>> I understand that the logic to copy page table cannot be borrowed from
>> fork(), but I thought that copy_vma_and_data() could be extended to support
>> this scenario.
>>
>> If I understand it correctly, it does almost what we want; copying a VMA and
>> page table with a new size. It also calls vma->vm_ops->mremap to let drivers
>> know the new VMA. However it doesn't copy the page table if old_len == 0 and
>> clears the old page table entries, which prevents using the function to copy
>> VM_PFNMAP.
> 
> It doesn't almost do what we want at all. All the drivers known VM_PFNMAP and
> VM_DONTEXPAND will _not_ be mremap()'d so unless you have a time machine I don't
> know about we can't in any way take the existence of this callback to be
> meaningful here :)

Correct me if I'm wrong, but looking at check_prep_vma(), VM_PFNMAP is 
checked only if MREMAP_DONTUNMAP is set or expansion is requested.

So it is already possible to move and shrink VM_PFNMAP, and if you need 
to e.g., assert alignment requirements or synchronize metadata.

That said...

> 
>>
>> So my idea is simple: change copy_vma_and_data() to copy the page table
>> without clearing the old page table entries if !old_len && (vma->vm_flags &
>> VM_PFNMAP).
> 
> No, absolutely not.
> 
> I already went over the reasons, but to highlight:
> 
> - There may be alignment requirements that are no longer fulfilled.
> 
> - There may be metadata associated with the VMA that no longer exists in the
>    copied VMA.
> 
> - There may be some requirement that only one mapping exists at a time of the
>    given range.

Obviously what I suggested goes against "the only one mapping exists at 
a time" so, taking that into account, I agree that it will not work.

> 
> And who knows what else.
> 
> we give drivers a great deal of freedom to do what they want with these
> callbacks. We've built in the assumption that:
> 
> - VM_PFNMAP means .mmap[_prepare] will _always_ be called for any new mapping.
> - VM_DONTEXPAND means that we will _never_ mremap() in a way that _copies_ the
>    VMA.
> 
> Now these semantics are non-obvious and may be inconvenient, but that ship has
> sailed, and trying to do something different now is broken.
> 
> I don't particularly fancy auditing every single driver for this behaviour
> (inevitably missing some) either. I am already having to do this for .mmap in my
> .mmap_prepare work and that was... already an 'interesting' addition to my
> workload :)
> 
> Also to be clear, as perhaps I've not been quite firm enough - I will NAK any
> patch that tries to bolt on more 'special behaviour' to mremap().
> 
> It already has enough of that, if we had that time machine I mentioned I would
> never have allowed this ridiculous 'cute' mremap(ptr, 0, new_size, ...)
> behaviour.
> 
> Note that we explicitly disallow it for anon mappings, so there's already
> non-obvious caveats on top of caveats on top of caveats.
> 
> There will be absolutely no more of this :)
> 
>>
>> Of course we still need to respect VM_DONTEXPAND so it should be also
>> checked that the new VMA is a subset of the old one.
> 
> Yeah no, sorry.
> 
>>
>> Can this work?
> 
> Nope, but I + David already suggested a way forward that should work - just
> mmap() something new utilising the existing fd.
> 
> You could even explicit try to do this only when the mremap()-clone behaviour
> fails.
> 
> I leave exploring the details of this to you guys ;)
> 
>>
>> Regards,
>> Akihiko Odaki
> 
> Like I said, I may look into adding some _new_ kernel functionality that gives
> you what you want. I will cc you and Vivek if/when I put something forward.

Thank you.

Regards,
Akihiko Odaki

