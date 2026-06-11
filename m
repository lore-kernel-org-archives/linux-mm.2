Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A45DDCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 16:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA2C6B00A9; Thu, 11 Jun 2026 12:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1996B00AB; Thu, 11 Jun 2026 12:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE88A6B00AC; Thu, 11 Jun 2026 12:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF4C06B00A9
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:37:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A02B120783
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:37:25 +0000 (UTC)
X-FDA: 84868187250.30.F880F8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6B99040004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 16:37:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPqKVI7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781195843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQBib1VsAzlYorWOyjFbpOR4CJ/YC0cjrLSbb74DjF0=;
	b=PJbtrqpGDOSvYnUGe8J4i/5/q8CCf7epqn10gWx2VA6iK0NkX/NeCW+xA97d8So134BMCM
	+d9cPZ5D+Nwv+oiJmu1/gxmUDqOjMX/TiyBo2+eS0SmigFhsh3HeoyU6bz3Q7+yBWawkd9
	YDWbALtk4p0AFZQoLM+x+T/hYMGxfM0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YPqKVI7T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781195843;
	b=njYAZdSKR8UvOV/VWNgUqFuHaMJLarigMEouKnJElyPdLf7xmXhkFKsCI+t1vdNX/tJqRy
	/zHVix3u8jqRhgZmrg0yknDD3V9bO8Zf2ygDaWTJCaEGIW2sm+BVnpjUHfDN/QMuePWexK
	wYoUEX0WS4YitHiDlqKaP4TasMjW9ww=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A7A74353A;
	Thu, 11 Jun 2026 16:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C081F00893;
	Thu, 11 Jun 2026 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781195842;
	bh=KQBib1VsAzlYorWOyjFbpOR4CJ/YC0cjrLSbb74DjF0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YPqKVI7T54I7X0z7db2P0pkwgtlgSotue8EuNyxIeEdfPbnmla2HXzb9/l6g8uTKI
	 A+BUzA5ep4mCpPRN3mCkJyae3Dr4ZalAPFtE9g91OpmYbCQrioVqHkDSf7hAOklG/2
	 /WgJmupLkZRfQRuNua4Mohi6MkfVQu4f8A/gtWLiPxOGGTJjwZFlCy0w2Vdk0b8PAG
	 bDJWYiiRne0yFSxex7rZ9fIoCauSch327g7pm4GCcjaATjbgHH+ShhHfX8ywBG8vZs
	 5C9S/ZSrld0RQWr2R8ECgNOf3Duz1FUwbMmZ+++Bggc3Vh+sT6krASx8cptrrl6BMD
	 f2jkavqmju5cA==
Message-ID: <4cf98483-ae35-4ad0-8f77-5a46194eb65f@kernel.org>
Date: Thu, 11 Jun 2026 18:37:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/16] mm/slab: do not init any kfence objects on
 allocation
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org>
 <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
 <159d1e20-5b21-4329-ac9a-f7a5cb0fd56a@kernel.org>
 <e71bfc13-c233-4f85-a6ec-76327d3c6510@kernel.org>
 <74adf668-78c2-4989-a6c6-c6ec7bd68855@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <74adf668-78c2-4989-a6c6-c6ec7bd68855@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6B99040004
X-Stat-Signature: 6bkbaucbnnt1huoxof9azdcjoci4kq4p
X-Rspam-User: 
X-HE-Tag: 1781195843-475758
X-HE-Meta: U2FsdGVkX1+jALM1iIKPPweVDLr8t9SFE/heZ+hHtm8U3mFPKDyHsTNKKPaFkgU/UczVqPT29u/VLWb0GPEGrSNvyAUh+mdjZ91MNLZxaeuBLjttp9Lmirk58KrA04gbHb4VVb/DcMI1SIIzyTl1YEm2Ey+D7fsUUsGiVTDG7XvhnvNKVPI2hUWouETo6F9FjLVAEXFAzIWxmE+hU81FwXc9vLvhyqZi0XGYhFced9ku4jWvYRCpZWy0M/wHuDVurSMCT65cYlzKbKyzy6jjYZzhU+p51jNyRrgicm0DjZga4mjVEDxKNE+kdQHatvyCX9Gcu5X3WkBr4TQnCihzLIGUc710uiWmz2jHUkqQisbuoXcbJMwr3WYsmPRM5e3tZd2p2ehAG7JJMDdzp33DpqqyHbhFUqx4dT38E68bIt6ZmrqDt5OzmXgNOHsyYJdWUjTsyC4qDV8+OQ75CUPFwHyhBsbRvVeDiOJYOqd9wEp4Ci+EpvFsgCbWrqpYeTa2N8Aqoejwadu4aijeIawEb8y3JyHwGF1SUROp4PSsObDka5+DLOkglrGOIRbrVevHWZBIegzDS3+eCygls2rADBtIT5rwS1qOD8zSL+sm/MO5jmgbtWT+fSfAjsxaDjKUre5mPktTxHCp2wp5uEkTOuUVtXuKOOm2viK9zUkMVYJvDHXUl8Osm4e39EkS0urGYVefcN4C/n9CkR6+kN9oiT09rklupbVcSGhj1tTVmRnth3dJzOSJoIfQoLHe4gUSiRoS6gFobMXxD9h39JYQp1bhzXTUztpmUn78wBZAosAmFbUzFe1hE8m8h6Pi372k+nnZYTRqnaV4Po95jSBYf+xrnPpVNuixJv1WRvoNanA5k3ggqCgJHwDSbOeJ+j6UUzhU2/4hBYHC24MEgO5DCHGl3/fC2WqqkXyC8935icyB6MCURayiKe/bg1P9cWO36TMWr6z2QmuJrAD/rzU
 Q7J43u5I
 hgrBQdRo1CZ3x7IsAag1Hg1DP091CNttHqxwnptFisoZ96BFDCAmDFLu+5242FZuiLnCtish7fFHNr9LpKoIU/g2QNgVjdJZb1ni2APoAVRn3JuK9EeBmUh6xDib43y5Cdufw2weCEQ7PMjAl7puVMF8u8YLtHUWhFBy+UmK1bbcrftaxKKasQ1qAJI7MD7oaTDhD4iuztPs4baC+wme2TxgJUtefi0Dm67pvcZ3UlVBc1AjaF5SWkVj+451m6ZnN4ZPMVftFhydTKuowu3EkY54Qak6NO0hnX/7QawL6jmq0nkKYhRwI5Kk2DbvBmZpQjNJyHsdThrjJRjJ5VR1+PPyQypfBpNVRhtJ/qm9Vytk6MCwb8sS9pxeELg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 17:11, Harry Yoo wrote:
> 
>> From 3a1c4398ce9f361a4e6f4d9946eab6237eea89c2 Mon Sep 17 00:00:00 2001
>> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
>> Date: Wed, 10 Jun 2026 17:40:04 +0200
>> Subject: [PATCH] mm/slab: do not init any kfence objects on allocation
>> 
>> When init (zeroing) on allocation is requested, for kmalloc() we
>> generally have to zero the full object size even if a smaller size is
>> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.
>> 
>> When we end up allocating a kfence object, kfence perfoms the zeroing on
> 
> nit: perfoms -> performs

Fixed.

>> its own because has its own redzone beyond the requested size. Thus
>> slab_post_alloc_hook() has an 'init' parameter which has to be evaluated
>> in all callers (via slab_want_init_on_alloc()) and should be false for
>> kfence allocations.
>> 
>> For kfence allocations in slab_alloc_node() this is achieved by subtly
>> skipping over the slab_want_init_on_alloc() call. Other callers (i.e.
>> kmem_cache_alloc_bulk_noprof()) however evaluate it unconditionally even
>> if they do end up with a kfence allocation. This is only subtly not a
>> problem, as those are not kmalloc allocations and thus the "requested
>> size" equals s->object_size and thus it cannot interfere with kfence's
>> redzone. There's just a unnecessary double zeroing (in both kfence and
>> slab_post_alloc_hook()), but it's all very fragile and contradicts the
>> comment in kfence_guarded_alloc().
>> 
>> Remove this subtlety and simplify the code by eliminating the init
>> parameter from slab_post_alloc_hook() and make it call
>> slab_want_init_on_alloc() itself. Instead add a is_kfence_address()
>> check before performing the memset, which will start doing the right
>> thing for all callers of slab_post_alloc_hook().
>> 
>> This potentially adds overhead of the is_kfence_address() check to
>> allocation hotpath, but that one is designed to be as small as possible,
>> and it's only evaluated if zeroing is about to happen. This means (aside
>> from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
>> zeroing itself comes with an overhead likely larger than the added
>> check.
> 
>> While at it, refactor the handling of evaluating when KASAN does the
>> init instead of SLUB, with no intended functional changes. A
>> non-functional change is that we don't pass kasan_init as true to
>> kasan_slab_alloc() if kasan has no integrated init, but then the value
>> is ignored anyway, so it's theoretically more correct.
> 
> Right.
> 
>> Thanks to Harry Yoo for the initial refactoring attempt, and for updated
>> comments that are used here.
> 
> No problem ;)
> 
>> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

> Thanks!
> 


