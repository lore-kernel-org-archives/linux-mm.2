Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5E81C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DD26B00F4; Tue, 30 Jun 2026 10:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6086B00F5; Tue, 30 Jun 2026 10:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 733666B00F7; Tue, 30 Jun 2026 10:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1F36B00F4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:36:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE6F74050E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:36:25 +0000 (UTC)
X-FDA: 84936829530.16.030FDE3
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4174A180007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:36:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZzwbwkFp;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782830184;
	b=jPozAx8l8IxG+LF97fVI2B1+OkTrn/vDatHHXFR4HC4yHktEjlTLIjyW3MExEWGHd3kk6P
	pYWcS0nSLUoSE2OBjcthctgpzTii26TxF+BEEfOGX4rjJVafixlZhcHrW/gxOvx1aA8ts+
	BhMDsW5PN+9eW6cG2XKGGhqumm7x0mc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782830184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Gu1YYGiqIdROtQye1IY072sGhuVqKZsHDPchTxbwsQ=;
	b=ZcVI58wORxA7OVmyxNF/vFnCvUFLh2qO4c+m0fJ9hfFQjdNqQouwyZB9aypyTzptKA4dXB
	TWdlXchfxFwCY+KmtMdvMQMbDByfjXgl7ts0oS4EQZXZRKd7b7WwBqYKidRv8fe6BgV6pr
	Sn4TVPXZb3mEtRb7e8IjydEPH+3vcw0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZzwbwkFp;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 30 Jun 2026 07:35:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782830181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Gu1YYGiqIdROtQye1IY072sGhuVqKZsHDPchTxbwsQ=;
	b=ZzwbwkFpv1U7oHJEHHDRMYM4sjirdts8KnG/JMXdeONgqiJveFwY6ZbC/hAY/YswG7KpC+
	1hpbiXyY6TLm9qeSviAeXy2QqR9hy5VcNvrXKfY+QEfUpmlSJDb74jij7d3TdzH2SQBWVw
	NOcHWx9uHPCCOYe7YTjYrOvNVvUViXs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
Message-ID: <akPSjsbjl-UAcdI8@linux.dev>
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4174A180007
X-Stat-Signature: cerzitx3f48xq7c7qq3cka7foa58nize
X-HE-Tag: 1782830183-619150
X-HE-Meta: U2FsdGVkX1+ndCr7U0MifyHsglHdDOyN1v9k2D+17Zd0GXgN07M8LvxG5TK/4WOMPtsOhEnqyYAfBOImQ7bfaCorSI70++MrBrBekZu/a0facN25BB3uzfYlCn4dFsWHfaIo4CaiCk/uxcHZZtMp88shNjDiUHTguoU1C+P2Ixwr+S7Oh4hRiH8zg+LVIKH3RfemjdjNkGLItWS/t/Ebn4UoFoVEUOv/n13HlOS4iJBcBkhwyh8d11vRPgvjJdydV1w5Dw5HGjGjsytnU4yOhuBmUwXqrf902gCEDdjOBg5Ww7rmCMwzfO2YK2SZOPC0LH5sRen+34YkXDxzl6ECC5Vr4i8aGjCv4VBuEXDVhyM06WPRrLNCKyg3IDYocL1M3Mry6ovhlyMQFzUP3PHDCYwZPRfQNhJQUtTDRIICFeIgy1uYIcX9pMZzhh24lD95mQCwjeFehoYRhvCsFL6mSd9gICb6EC72Kn5nC+SKC0IbT6V5t+JFcQRo4bUSg4v2yUhQfdP3x3N9lRvR2F8V8DCJ/U8wpVxsIXFM6DLx9RcvEEOFQ0zjNjvXIWdbi/c54QCS/kLcbJOphnv1h1nq/2wL9PhOeDjN3YVhIVa9p6izWE2EdYc2KeQv+CQigwgoJ9uKJ82q6I99TGePULZOIXOgJNSvhpea+DiWt72WFTPVEtSPWLwk7laq6r047orNBLXSJ7cvQZWdWWb+0S6jBNaIHdRdLWJIBIfhmsiNJ/UWwftgPmpXJZyF/uMPe9wx4aDVTmivaAYqcVTaLkx6GMdVtbazeVDxjQk2Qrh2zOtLfbr5nMeMeHEJp7ZYBlDXae8RrYwsGRCh70hThAnzBUC/wJnhu5NEN/DR8wkn7IoPUXnwbG5uK2TzznVQ60pIP0BnbaUxv5g7Z6MozhUwxx2ebI4s1Ph8Wu2PYK+T8+KYxTjeKdO+QEQljEQnx+UkE25mXlrW6hLgQkWNaaR
 kOvq59xx
 Pl0yYzXKHNMooci4VcVH9FH7eZ7G9K8hWHEFZpG0HgrVJzHvL8naMUt0m5+giqFqUhES5esTmJ5ik01gtIWmFG9hcpDvH3Cc4VBArlF8YqNsUr1BUqOUTEyaknxfAv5JdMwhCaOB05UV/EpGzvXPrli9jKohnQN6WMZ5iSTzbNzf8Tvt4uDjJX9EZWNTcstJVkYs1s3VzWYtfAgZ1xXWvD0JjLwN1OOsSpLjfe7rwLgckusU6EujwX8vYNT9fbkclLjwlDBBzT8r7cUftUMBer0umbf//sv9WLWaebazRJcMf5sGWvgctfLLno23HsHPH7m+uVDhwxQCsRmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 04:03:30PM +0900, Harry Yoo wrote:
> 
> 
> On 6/30/26 3:12 PM, Vlastimil Babka (SUSE) wrote:
> > On 6/30/26 07:29, Suren Baghdasaryan wrote:
> >> On Mon, Jun 29, 2026 at 9:42 PM Harry Yoo <harry@kernel.org> wrote:
> >>>
> >>>
> >>>
> >>> On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
> >>>> On Mon, Jun 29, 2026 at 9:38 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >>>>>
> >>>
> >>> Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TYPE or
> >>> SLAB_BUCKETS approach.
> >>>
> >>>>> Yes, it's worth backporting, so we can merge Shakeel's change as is
> >>>
> >>> Right.
> >>>
> >>>>> and then once Vlastimil's patch is merged we can implement the new
> >>>
> >>> Vlastimil's patch has already landed mainline, by the way :)
> >>
> >> Nice! I suggest posting Shakeel's patch CC'ing stable for backports
> >> and then following up with the fix using KMALLOC_TYPE. Vlastimil,
> >> WDYT?
> > 
> > Sounded like a plan, but then I realized I misunderstood the amount of the
> > wastage. E.g. on my system kmalloc-8k with 4 objects per slab would have
> > obj_ext size of 64, but now it's 16k? That's ridiculous.
> 
> Right.

Yeah I should have given more thought on wastage.

> 
> ...which is why I was assuming either the KMALLOC_TYPE or SLAB_BUCKETS
> approach would be backported as a follow-up. Err, should have
> communicated clearly, apologies.

Harry, do you want to take a stab at prototyping these? If these look simple
enough, we can request backports of this.

> 
> > I think it will> even self-amplify to some extent? kmalloc-8 would
> have 512 objects per slab,
> > so its obj_ext is 8k. It will not recursively create an obj_ext for the> obj_ext, but other 8k allocation in the same kmalloc-8k slab could then
> > trigger it, right?
> 
> True, assuming that by 'self-amplifying' you meant this patch creates
> more kmalloc-8k objects, and also now kmalloc-8k wastes memory memory.
> 

I am not sure I understand what self-amplifying means here. Shouldn't 8k
allocations served by the same kmalloc-8k slab will share the obj_exts array?

> > We could say it's for a debugging feature, but also it's running in
> > production fleets (and Android?), so probably not that easy to dismiss.
> 
> I think a key factor is when it's enabled in production.
> 
> kconfigs says Android selects MEM_ALLOC_PROFILING, but not
> MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
> 
> I assumed that turning it on by default in the entire fleet
> would be bit hard to justify... (please correct me,
> if it's not the case)

Actually we have memory profiling enabled by default across Meta fleet. So, the
issue is very real. At the moment, we are seeing this issue on a specific
type of machine and we have disabled memory profiling for those machines.

Internally we did discuss to simply disable memory allocation profiling for
kmalloc-normal caches but to me that was a big hammer and thus suggested the
current approach.


