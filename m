Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1203C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6666B007B; Sat, 25 Jul 2026 13:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287106B0088; Sat, 25 Jul 2026 13:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179656B008A; Sat, 25 Jul 2026 13:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6CCE6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:02:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50986A0390
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:12 +0000 (UTC)
X-FDA: 85027916904.01.A2F71B8
Received: from cmx-mtlrgo002.bell.net (mta-mtl-002.bell.net [209.71.208.12])
	by imf31.hostedemail.com (Postfix) with ESMTP id EDB9F2000F
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bell.net header.s=selector1 header.b=U+AUept7;
	spf=pass (imf31.hostedemail.com: domain of dave.anglin@bell.net designates 209.71.208.12 as permitted sender) smtp.mailfrom=dave.anglin@bell.net;
	dmarc=permerror reason="Multiple policies defined in DNS" header.from=bell.net (policy=permerror)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784998930;
	b=KzRfXBKl7enUvD04b7tj9XbeLWkUmIwnnt2pMFlvvV/dvRMRxpQz2YAzslcXLWxey9Zc9N
	iQHzk67waYSR/r1AwgZIQI+elGK1UL3CACD83qnIr95USUMDaaEkZ4OHb5s2i/cspAjyd0
	oylcaGvxhHUfBfIestk92EPhDqlRfiM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bell.net header.s=selector1 header.b=U+AUept7;
	spf=pass (imf31.hostedemail.com: domain of dave.anglin@bell.net designates 209.71.208.12 as permitted sender) smtp.mailfrom=dave.anglin@bell.net;
	dmarc=permerror reason="Multiple policies defined in DNS" header.from=bell.net (policy=permerror)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784998930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wqzc1rdrD9/zZgtfkeN/lk6lY1WJu6IQP1Gt28locAY=;
	b=oK9S2C2MLJcT7uu6OFAcouVAUZUaQxEHgmTCCHzLzP5WXRnY91LNtVnjcuTU/Lf+ZyHAqE
	DGuSluNAoCDVelV2ElnLuYwURDDrMRdAEU6HOMxwXME0iiHQTuPaA7J2r3D+eyusuM/ySR
	Dmr6/XB6TmOM+p+UBeJESZRkkLH7YN8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bell.net; s=selector1; t=1784998929; 
        bh=Wqzc1rdrD9/zZgtfkeN/lk6lY1WJu6IQP1Gt28locAY=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:From:In-Reply-To:Content-Type;
        b=U+AUept7gbPpeWuUbYktIyhCIiPSrjtryU54pQBdZP4yIGUIGmbYWOhEwY9mCr5S6HsCV7FS7UASCLaftAfhxzAFgu3+e34dogXZP8h4jEr6vDj8KfVyukeA7F8vuQcyfaAXzGz2/4/4V3IM5VhDwVIlbolaqYQIfAdL2bpT5XP7ELyWTMBd+Uun5MDKmFOjKXqNxmA+VIVOIVHGEyqhMp9QKaputfSZFKpUS1uwmK/6fPy7i04s3PBJiFeLWxIxcUm1p2qyW5oSfV8PyvaEgy1Cil4XtEOlwx2cmAr3ynVuf145tFJS/QEsLfzWW3EMgWXT0vw3ckF9iKuE0Ku6bA==
X-RG-SOPHOS: Clean
X-RG-VADE-SC: 0
X-RG-VADE: Clean
X-Originating-IP: [70.26.67.32]
X-RG-Env-Sender: dave.anglin@bell.net
X-RG-Rigid: 69B7AEA70B5C1637
X-RazorGate-Vade: dmFkZTFBL85r2oEp4gvfdK9Qq+Fk279rWqVJnzUbNG9fBvLFR/dedrP8wVgFqykZFUTtnttUvrht+OPOiRl/1oU1X3DnhmkwJ+4FUfJN4YMM1Uvc+FmDjW+MWZJ4A0FjpNpERM53NIjMWcPZhyZQFlG4htjVqZ7TJEV4FI7ta2yH4wzyax6s/4E4T4WCOk4oS7RVnzZ9H7irp28HQyCyZeltVxOz9AOr3uOwK79TyneqiRNx+3a7ieGIx7Rrh1xt7fPNGAbDlI7/re/7tVsLMnTzaM8sIoSYfJrV5YxItpSXdxwsobLjy7j764yoaItE9IWqOZ8nHnzugNBwWYuDikcsYd4ZIeOFwBtFev92vMT/vouaEKz+Ah1vjLT+QwgLhdKduIi9iaJDNNkjELFJJE/yNIszKpKlgjW1HQwxXcm3pFfMYsehZFbAmRqL5QVr4EPAW+cvXuonKobvy9fNczSRBD1tyEDCCz/SgvyoOPUZfFsRv1qGgvtqzStwN7Zbtrj68SxbRBYbLYJaroia6vW6b+bLrsEw/meOFF91HfqL8XVq9KdlPKuyvJg40LZ7ScGPqA+pM8+6XXzL1HD4rQYkQoM2CqPSkFuWO81zqkSvf6vLU4tetFZnIofxXAd0aTEd9y+bczB4IJxuzjc+nVt1JlVepAHkbCONpd6s8mfBgySdAQ
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
Received: from [192.168.2.49] (70.26.67.32) by cmx-mtlrgo002.bell.net (authenticated as dave.anglin@bell.net)
        id 69B7AEA70B5C1637; Sat, 25 Jul 2026 13:00:55 -0400
Message-ID: <4606e13f-6827-45d0-b3b8-6bc26358f7ae@bell.net>
Date: Sat, 25 Jul 2026 13:00:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
To: Helge Deller <deller@gmx.de>, Usama Arif <usama.arif@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
 <amNzLXuwflIZFKtI@casper.infradead.org>
 <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
 <amOEUZlp1BxYh6_t@pedro-suse>
 <fd239383-dcbe-4daf-b337-32facef07076@linux.dev>
 <3e9dece8-4e86-4ce5-bd74-b3ec305f3003@gmx.de>
Content-Language: en-US
From: John David Anglin <dave.anglin@bell.net>
Autocrypt: addr=dave.anglin@bell.net; keydata=
 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
 T70V9SSrl2hiw38vRzsl
In-Reply-To: <3e9dece8-4e86-4ce5-bd74-b3ec305f3003@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9bbop86arztr98sae3x944gaqu3ffhxh
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EDB9F2000F
X-Rspam-User: 
X-HE-Tag: 1784998929-653300
X-HE-Meta: U2FsdGVkX1/doJrws9EUkJgDFoQCUppqENPe9PIWHfBCSm5aafaojmoFVgQPzuc2jiu4JNmB+KeJTDr6wU/pX1pxGpXC0JNezd9B4YOr+QeLDfup/X0Bb9MZc2MxgoJvFT/4y+57wMyzfChxDcFtc5QWsPFCuhG/v0QsCl5oqdt1cjK+meis5FgJO40imRt21qvGVs/TE0rkZM2Z7/ikEhYMzaKDJLEC1MyzHQYPA//S3zKSDKFIrLOQ5cCFPfMdug9zM3fHWmrjAlw5Qpp8Eq0RwjW93AIXRo1u6Ydk5z029Fiyh4G6WPVXtPtE4NfQ2/qd8/yqmPBdNY4d/rvvJCUd+IpPWyzkneKXUwKE+H8h7+Jj7B6VamrxNZwM0OhXSkKHPBO4eEO3crOR3rRXX/KOy8EE27zGACf+YK5l1cF7875rDWdciY67C2bQOOAFyXiNvYRjUrVPcxOWx+aNmszKbYidspgc0tB7JHA2N8AQDuJvdVW+AEgKvvjCFdrTLGOntE9lc9dDyV9GhwF/5qB7y4dpiLWYfRQhDgRxjWuMv5gGFDg7qqW0bEPA9Srqh4fbEgXI1ptVtIPsaTOoiGVnbE6vY62sayPch/8ttyjMYU8d1JOC1oacbyEfXFmcS3wV26RUECuDVtMrSF+sWqZ2wjqOjhojCWOggneaVWdz+GKgFWEZilEo7wkL5hz4gGKasHfBLF5aNr3iOSte0cMovotxTesFXGgr8bLUScKEcNFPCYOBfpZoaCdFBqlxR06gIZ9CslXUPfh9nBqIZhBihPqgwSCHjkXcwP3hcZdPLF7DHrSMVGezCK6uulFLpyNmN3bzQ5bXrY+MOLzBluI2cjmQ0BOHigFWAk1sTWkIxEyAWPRzYVF5lPXs79SJFRrfeWrEDC0Pf2zkUjT/nFOj96+1Nx/sgFSXlYT6LYzh1rA7208tMTV81/uOX9kMTJ+lXbFuGYajtnoeNcY
 JA+ZNXze
 nzmugVfUztGURSzI4aiMw3P3WwDd/gD563An8TY2CQL0/eI73RYT2griGylkC8xypR71/33H78ZdqJ1gsYpfk/15fw+xUF49OcITxbkSEDuN/dd+R4NuwTbFxcJBoSi79pKmZoMvCkFiZ3e0ZNNkM3uzyINXRM/i3YS1077Kww2YmjctXJr045ILvOUIS3WAGf1dlVmIibYYQvltXItKqiwVUCKN8mdJxBt500eJua6YLWOKf2HmbtqAdmDbhgFGcEyA+lRH4NjtncWSoS7njWQzO7I8I8IQpHhZC5Dulb0TqFZgY6xGNtC3gFYVI7hk6OnvKlqqLCEqmukyJyoOBgARXeFl5xShXfI1zcl/0Qzm1F8zi3hK3HKKSrRcmGys3mvY33UsH6aDMLeuOUj+Tn6A6RmpJShh2eW3oCI6sVPelVx60TwFX6u4uQYAgJ7MdIP/by08sSzK6ABOjaIUixFDOT5Oe17CvVS0PBwvA0so2IpzkypQ3lzMGB8Xa0yz8Ein0k/iciKwDHcVjz88k03ct+tz8paX4otZaHMt9dVDmIPzoF2aTkVWfJCrhtfwTJlzvdxy6sSwASY66Cj+6MV7pMy9TVbTIHJPxk+Hu3MyIHBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-25 12:27 p.m., Helge Deller wrote:
> On 7/24/26 17:48, Usama Arif wrote:
>>
>>
>> On 24/07/2026 16:32, Pedro Falcato wrote:
>>> On Fri, Jul 24, 2026 at 04:03:44PM +0100, Usama Arif wrote:
>>>>
>>>>
>>>> On 24/07/2026 15:14, Matthew Wilcox wrote:
>>>>> On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
>>>>>>
>>>>>>
>>>>>> On 24/07/2026 11:20, Pedro Falcato wrote:
>>>>>>> ptep_get() does not need write access to the PTE.
>>>>>>>
>>>>>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>>>>>> ---
>>>>>>>   arch/parisc/include/asm/pgtable.h | 2 +-
>>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>> hmm I think you might break build bisectibility if
>>>>>> you separate out the patches, you should squash patch 3 and 4,
>>>>>> with patch 1.
>>>>>
>>>>> I don't see how this breaks bisectability.  Can you elaborate on what
>>>>> you think would break?
>>>>
>>>> Patch 1 does:
>>>>
>>>> -static inline pte_t ptep_get_lockless(pte_t *ptep)
>>>> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>>>>   {
>>>>       return ptep_get(ptep);
>>>>   }
>>>>
>>>>
>>>> ptep_get() takes a non-const arg till patch 3 for example for parsic.
>>>> I don't think you can pass a const variable to non const function arg?
>>>>
>>>> So parsic won't compile in patch 1 and 2, powerprc wont compile
>>>> for patches 1, 2 and 3..
>>>
>>> Aha, yes, nice catch! I'll have to rethink that. Maybe squashing the patches
>>> would be the cleanest way forward.
>>>
>>
>> Yes, squashing is the simplest way forward.
>>
>>> FWIW, the vast majority of architectures aren't doing funny things on
>>> ptep_get(). E.g PA-RISC, loongarch only define these so they can use it in
>>> their own asm/pgtable.h. I'd really like to delete these but I can't tell
>>> if they are *actually* required.
>>>
>>
>> Ah maybe there is something in git history on why it was needed?
>>
>> If not, hopefully someone from the arch lists could clarify..
> I tried to remove ptep_get() and ptep_test_and_clear_young() from
> arch/parisc/include/asm/pgtable.h, but this then triggers compile errors:
> 
>  CC      arch/parisc/kernel/asm-offsets.s
> In file included from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/mm.h:31,
>                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pid_namespace.h:7,
>                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/ptrace.h:10,
>                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/arch/parisc/kernel/asm-offsets.c:21:
> /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h: In function ‘clear_young_dirty_ptes’:
> /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h:683:25: error: implicit declaration of function ‘ptep_test_and_clear_young’;
> did you mean ‘pmdp_test_and_clear_young’? [-Wimplicit-function-declaration]
>   683 |                         ptep_test_and_clear_young(vma, addr, ptep);
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
>       |                         pmdp_test_and_clear_young
> 
> So, I think the answer is, that the local copy of ptep_get() is used in the parisc implementation of
> ptep_test_and_clear_young() function.
> 
> Switching to the default include/linux/pgtable.h seems not easy doable....

Did you remove define for __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG in parisc version of pgtable.h?

Dave
-- 
John David Anglin  dave.anglin@bell.net

