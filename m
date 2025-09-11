Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4686DCAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42438E0008; Thu, 11 Sep 2025 12:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19958E0001; Thu, 11 Sep 2025 12:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956878E0008; Thu, 11 Sep 2025 12:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86C3C8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:20:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B177160288
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:20:24 +0000 (UTC)
X-FDA: 83877481968.11.7E60ED4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5839410000F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:20:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757607622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P4KuZTZsXU0ugaI7cID3g5r9oTH3zieIMz1tYktcbHY=;
	b=IFroz+Rie/ESRlfzS4A1RXBmOPY5734nUCiYbGqImgVS6ZRfSqz4hxp+gvamsxcrMEq5rr
	6eXwEdIEE2KXqzz63yXAtyxAaxaN6jtN8a1Q4PMbHqCMisQAtD4Pl80m03mSrkeMTjesG2
	w2G0hVsFlK/GXuTqJSCcz4NJDLF6s20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757607622; a=rsa-sha256;
	cv=none;
	b=vv3zgaLdzobM1dpXWbLNeZ2sl/IoV9BTeKX//3yq8Ao0cnP8+7lZ9IhnEfHBb27sgcNSC3
	73//Cju2VHkh4+GokNeir+dwcVE0JL8GA6BLDiJwzmiz4ILYyOjDJWEWvGEiChi6lCWQ4b
	69Nw1gcROYV1RdvcEgW67E/EV3WdyC4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D43CB1756;
	Thu, 11 Sep 2025 09:20:12 -0700 (PDT)
Received: from [10.57.70.14] (unknown [10.57.70.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 462913F694;
	Thu, 11 Sep 2025 09:20:14 -0700 (PDT)
Message-ID: <076c7f16-fe56-49a8-910e-7d71d3f8f0b4@arm.com>
Date: Thu, 11 Sep 2025 18:20:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm: introduce local state for lazy_mmu sections
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
 Mark Rutland <Mark.Rutland@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-3-kevin.brodsky@arm.com>
 <d23ea683-cca4-4973-88b1-4f6fd9b22314@redhat.com>
 <ca2054ad-b163-4e61-8ec4-6f2e36461628-agordeev@linux.ibm.com>
 <e7acb889-1fe9-4db3-acf4-39f4960e8ccd@redhat.com>
 <2fecfae7-1140-4a23-a352-9fd339fcbae5-agordeev@linux.ibm.com>
 <e521b1f4-3f2b-48cd-9568-b9a4cf4c4830@redhat.com>
 <47ee1df7-1602-4200-af94-475f84ca8d80@arm.com>
 <b2e52967-7ca1-411e-9c66-8d3483624ca7-agordeev@linux.ibm.com>
 <250835cd-f07a-4b8a-bc01-ace24b407efc@arm.com>
 <80be36e5-d6e1-4b37-a1ca-47e92ac21b02-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <80be36e5-d6e1-4b37-a1ca-47e92ac21b02-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5839410000F
X-Stat-Signature: zzfpnkhwgp1gmmf7idi9pec8j9xxux3y
X-Rspam-User: 
X-HE-Tag: 1757607622-396386
X-HE-Meta: U2FsdGVkX199KYj8mm+63G21DPuo+fXdJZFOWwaRRrFvWCKUODtMq1hzo97zjYU44Q9ZOvOBLRbqheMUY+qXKrsI3jwt1VD7i1RDPEAWiqeaXHE6iNczVGD6SuPSsySDSTrR+WtSjtxdQd0p6x96JZqVnT4C/4dkUyEUt899OucyEuoXNBT83frOYvXT+j1Mm2wnP4zJqNShl5dcfotdOW7NTVzM9rM90fMBTnJ07f1tlsyYAKn8SFyBW2+oO1XfodP6sYa5Pm1C8zqRKsDdNo6weKPF06mom8Y3slKI/V1m+F5XnqO+87QfrTVetV3p+5rTizh3nExctKLhSFrs1iLmxxholeot0CMygzWycosq2UUTaL39cpAut1OvtAqIsHLWxSTBTzlkW11KUUVBIiHHKd92USFa2YQq/hihOT4YsPbdCq46pT3Jc+g24RPR6Q5YcVXQcoeH7raFbHiTAc8ho3liIH4MXGizr02wCp6n+eIxFj+LT7rIhiMvGbphpf2v9lUg12f/jCUkUfW18myG5SO7OPjUtDWHfEo0Yv5frxYh1615NnVgN9ApioEviP56sxJJJ8z8WYSt80jzPD/otTnfcPI6zTIm5+7LvMucrkdH1/ENz54Gl9wIbvWqMwiXkuztlZM7aC2hJP+YNByeKt1YJVLe1xbgnP1lDQWnwcRixlo1Ockyf/gIvEp08KOrcNoeR2GWelSo86WcxrieE9qhS/VGq3x0f5rDuTuAcLx/fHQt0lMFwNBVnu6lGgzAM41R5xYXrw6JVfSAyhdhkc+e4VzAAZ5OOdR5sXVlN3aVfpn/D1/ZAoKAKcmCYkOT2pMZ+vQlZYQR0iYjYxAKWvtyq2gug49eq3dVSqSihTTVH4esNI+fxIFe4Ry+adgv1onaBk3NpjwtHAwSkh+bhAsPqDXLMaB6VcGVfAXPYR8ai2CCYghhP0AV94QAipMcO3tTVv/2VeeI6ZK
 4WsweMLz
 UwlEhHjga0Y4slMp5psWRmkrV12aV41WxGUnuD8bXd7yNNcaJTlNfhcXLiM43Kgv+f4bzhJCz64fpYdKeMNUHThvzjMIOIusvSJrz4HxRSlzPFyCWsrgAD/bh04R9rS2/iDo9I9URbvTg1lLqOt96urBfTyTN71fctTe5v8uG6DGoML+ntnlEaYZEikJaVQ7ixElUezUzC4kNxRaWnaGCdYUJ0TdVWUosDerMeRLpYao9Iap7sps0WQGzApTwfE6QDSS6SRgHomyTMJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/09/2025 14:06, Alexander Gordeev wrote:
> On Wed, Sep 10, 2025 at 06:11:54PM +0200, Kevin Brodsky wrote:
>
> Hi Kevin,
>
>> On 09/09/2025 16:38, Alexander Gordeev wrote:
>>>>>>> Would that integrate well with LAZY_MMU_DEFAULT etc?
>>>>>> Hmm... I though the idea is to use LAZY_MMU_* by architectures that
>>>>>> want to use it - at least that is how I read the description above.
>>>>>>
>>>>>> It is only kasan_populate|depopulate_vmalloc_pte() in generic code
>>>>>> that do not follow this pattern, and it looks as a problem to me.
>>>> This discussion also made me realise that this is problematic, as the
>>>> LAZY_MMU_{DEFAULT,NESTED} macros were meant only for architectures'
>>>> convenience, not for generic code (where lazy_mmu_state_t should ideally
>>>> be an opaque type as mentioned above). It almost feels like the kasan
>>>> case deserves a different API, because this is not how enter() and
>>>> leave() are meant to be used. This would mean quite a bit of churn
>>>> though, so maybe just introduce another arch-defined value to pass to
>>>> leave() for such a situation - for instance,
>>>> arch_leave_lazy_mmu_mode(LAZY_MMU_FLUSH)?
>>> What about to adjust the semantics of apply_to_page_range() instead?
>>>
>>> It currently assumes any caller is fine with apply_to_pte_range() to
>>> enter the lazy mode. By contrast, kasan_(de)populate_vmalloc_pte() are
>>> not fine at all and must leave the lazy mode. That literally suggests
>>> the original assumption is incorrect.
>>>
>>> We could change int apply_to_pte_range(..., bool create, ...) to e.g.
>>> apply_to_pte_range(..., unsigned int flags, ...) and introduce a flag
>>> that simply skips entering the lazy mmu mode.
>> This is pretty much what Ryan proposed [1r] some time ago, although for
>> a different purpose (avoiding nesting). There wasn't much appetite for
>> it then, but I agree that this would be a more logical way to go about it.
>>
>> - Kevin
>>
>> [1r]
>> https://lore.kernel.org/all/20250530140446.2387131-4-ryan.roberts@arm.com/
> May be I missing the point, but I read it as an opposition to the whole
> series in general and to the way apply_to_pte_range() would be altered
> in particular:
>
>  static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  				     unsigned long addr, unsigned long end,
>  				     pte_fn_t fn, void *data, bool create,
> -				     pgtbl_mod_mask *mask)
> +				     pgtbl_mod_mask *mask, bool lazy_mmu)
>
> The idea of instructing apply_to_page_range() to skip the lazy mmu mode
> was not countered. Quite opposite, Liam suggested exactly the same:

Yes that's a fair point. It would be sensible to post a new series
trying to eliminate the leave()/enter() calls in mm/kasan as you
suggested. Still I think that it makes sense to define an API to handle
that situation ("pausing" lazy_mmu), as discussed with David H.

- Kevin

>
> <quote>
> Could we do something like the pgtbl_mod_mask or zap_details and pass
> through a struct or one unsigned int for create and lazy_mmu?
>
> These wrappers are terrible for readability and annoying for argument
> lists too.
>
> Could we do something like the pgtbl_mod_mask or zap_details and pass
> through a struct or one unsigned int for create and lazy_mmu?
>
> At least we'd have better self-documenting code in the wrappers.. and if
> we ever need a third boolean, we could avoid multiplying the wrappers
> again.
> <quote>
>
> Thanks!

