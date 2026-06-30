Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 129F7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF54D6B00C3; Mon, 29 Jun 2026 22:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6016B00C4; Mon, 29 Jun 2026 22:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A974D6B00C5; Mon, 29 Jun 2026 22:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD1F6B00C3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:31:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA37A8D29D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:31:02 +0000 (UTC)
X-FDA: 84935001564.10.1358411
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 218E04000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:31:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iy6tI7kn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782786661;
	b=hc1d2BpBUZnWAt8Kyo+PnVP12zZNSy2ZkuKN243jmGMs4WJqYOPJe+njwcRZSN0CIfYqCn
	TK7+7/tu7DxLJIaERjiIwq6opm3mTW/kHcELHrECY+8Mi+fi6rxC32yZhYIUXYfmPHuCKr
	Ly7uDbs7Y06xsPfPSyfl2+GbaUwAu58=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782786661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbR3UdRqFNJnR9UD31Nfq5nT1QTRhAajYqk/CATaIzw=;
	b=3rU8oZzsLDSiJJsyZRKlUfbT92PoY+HgXrR8/K9lmP8XKYVlAWYIEcfGMt3lQUIPLgWQtt
	2LSX3KPMpRG2nmfncS/1ToT8kgEQek4+lqvnm3PdXm+dXYL2eDsV40JxBaCVCcCRpz3ZqQ
	N2kTgdAaSp1nZOyY8Tqjajh9A6hdo84=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iy6tI7kn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 361B54030D;
	Tue, 30 Jun 2026 02:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7398A1F000E9;
	Tue, 30 Jun 2026 02:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782786660;
	bh=GbR3UdRqFNJnR9UD31Nfq5nT1QTRhAajYqk/CATaIzw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=iy6tI7knK+LFetvQngQtlx01BusxlQItmdkz4xEmd6PyQWogDs+Oc8+Cw4XZvMS9P
	 P1qyQfN8FIjpUZ59CtztedB2i8NpKpRsBjFCe+gF/GmwHovY2PaHRsH3bosQpa0AcR
	 J1VAulYSGOosfbMfYs28KfBpO9zkktIUHrp5irJt/OeQHTGyLrcLIE9VaPMedxFJnK
	 pKQAAnKxzJMAAgR+15e1u2LdHjxJWIHfDhvRc9xEDq09/WdTvClR+DmgB1c3vZH4kH
	 XxApP7xgYVcN672K4pbnymHpmdjZFjREa5e4j7g+FmziHXPpSqch/GSj8BaiyWLVrS
	 9nWkFUerjfz1A==
Message-ID: <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
Date: Tue, 30 Jun 2026 11:30:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org>
 <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org>
 <akCJRTnmA2um3CIy@linux.dev> <akCSftF6mrsKsz1V@linux.dev>
 <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org>
 <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 218E04000B
X-Stat-Signature: kjg113rcqy5rns5ayn5ekfosyis4eor4
X-HE-Tag: 1782786660-441565
X-HE-Meta: U2FsdGVkX1/IRf4lvvHOq62kmVp+IuVptCYb3pTsBsZvMZZ0+/+hNbtMjEJCJvuewqfRUfgJoJxFtgX0bSMfnmFdAGRChMXjGCTcUZE3U5O8BSt6jN2iRa5YzEFYlEUdp6P5gl7NVuNJODKV5jUtGxjMBvRfVlsdFZDJsHnLXCFR4caoeOhGM/QNOEQ6TpFSwJJxGon2cMbyuz/mxFEXsmvhzmhMHngdm3G/Oiz6oX3rd+wdIb+OaiAflNaEX4RtRzu5saNa0m2c2zW+guiQTAcPk55vnGs2uRleF3FLE9Q+bedSp0XyeWMNswiLKib8lqXlMUGKGDkPEmX9DDyPR4DuqIa+7Wowo9L0eAdLAMPCIPiAYZErHTTQWM46Ek8IznCbqiv7KAv6WMtbIgZzq5jV3a1RDIqcqQak8TJ2MajVjle8TDLoDltGuYBlZ4YeMR1oRu0q4xpXWV+qFn7W+k3N0bbwBmMYzucECTiF2CDRT5Jh+pTVpzBihX+8cD7uuPyPS2bSMb+6b7bChReuRU5bA1Oe2Q5S/uM5QP83r1xc5u8WV8W2rWoZNu7j6hvKeVds2dq3t35S3P63pMHwQAP+bBq+0O3ZRsmZfV8wyKpQHpTY3AYRBPfxo9k0WVbWNEJh560SokqvO9CmMj3AYszeqPc1K0xqvCPK3o9syEoDqyPVITgqIYSTnFLTzKuk5Wu/IFpEXa2uKP8Kb4acisw05XNjDXOQOpHgY+8BqR39XysyOdHSElfMs0A8S9l9lSKhwEAJJmYNf0gM+k0naU1Q+bNL+qlEc90QGJOzzvr7GdUgM+orNgi8uw0iJ4WfCPlOffkXjh1685RBihSPHGLdRThi3ITnAvYyM0LrD3O0MjpjvuZnlk0eMfRD6tQlOvPOgmirv+iHZGAsk7pZt968yamUZaH2JXTk/h3zNN0F6/m9ZuE3sZ2XUUzlRvNmTP1gbzaP6nONkwhl1eW
 IJUkBzSH
 QpK5SQeX+NOAI1KDXEiwrvWRbxyvoVm8zZrNKpW99jju89p1ODgTPodmWdhDJGRS5T0agU2lkeDwIBIfL+bq9Cqm7GHux+gG5NavDKKBpt+8fk6JEwiSXSPeUhZejc+osIyR5XB/uVtfWkLTZ2lK7n+bbbtoUswOyt27a5K4Qq3w8Z4Qoc6HV0Loer/ijVpaeZOrjcpu2V9hJoyUGo/iiJvJdJcslDKDp5xF2c6hEoSH1/5wKAW6Dr1krdaZnv8T1ubrv5Fsj5H7a2M3N7H1D96kBeSmNCzZ6LvpC1MjODLFf7JcwdVAywS1MsVdAK5cpbyVnXFjRxvZ2EwHzYVi6pG/OoEgn/mH/EbNJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/29/26 1:28 PM, Suren Baghdasaryan wrote:
> On Sun, Jun 28, 2026 at 8:57 PM Harry Yoo <harry@kernel.org> wrote:
>>> I think adding a new KMALLOC_TYPE would be the cleanest way to fix
>>> this recursion problem once and for all. This size bumping and the
>>> special case of SLUB_TINY are quite confusing.
>>
>> As mentioned by Vlsatimil, in the long term, using SLAB_BUCKETS
>> infrastructure would be more straightforward than new KMALLOC_TYPE
>> because (I think) the kmalloc type is decided purely based on GFP
>> flags and we need to somehow work around that. SLAB_BUCKETS provides
>> a nice abstraction to do this.
>>
>> Luckily, SLAB_BUCKETS is introduced in v6.11.
>> Unfortunately, SLAB_BUCKETS is optional.
>>
>>> We could define that> new KMALLOC_TYPE only if memory allocation profiling or SLUB_TINY are
>>> enabled to avoid new caches when not needed. Does not seem too complex
>>> but maybe I'm missing something? WDYT?
>>
>> I think we need some enhancements to achieve that with SLAB_BUCKETS
>>
>> 1. Rename SLAB_BUCKETS to SLAB_BUCKETS_HARDENING
>>     (w/ SLAB_BUCKETS being a transitional config for _HARDENING)
>>
>> 2. Make the SLAB_BUCKETS infrastructure unconditional,
>>     but the decision is made at runtime:
>>
>>     1) actually creating a kmem_buckets vs.
>>     2) falling back to kmalloc.
>>
>> 3. kmem_buckets_create() creates kmem_buckets only when
>>     SLAB_BUCKETS_HARDENING is enabled.
>>
>> 4. SLUB decides (not) to create kmem_buckets for internal use
>>     during the boot process. Use the kmem_buckets for obj_exts
>>     array allocation.
>>
>> Side note: this would unconditionally add the kmem_buckets parameter to
>> the kmalloc slowpath. Probably it'd be worth introducing a dedicated
>> entrypoint for kmem_buckets instead.
> 
> Yeah, this sounds quite complex.

I think it's not that complex, but quite some churn, yeah :)

> Maybe we could use the new> kmalloc_flags() introduced by Vlastimil 
 > in [1] to avoid using GFP
> flags to indicate that we want to use this new KMALLOC_TYPE? That
> seems simpler,

That indeed would be smaller changes.

> though it's not backportable because kmalloc_flags() is> brand new.

Right, I didn't seriously consider that option as I was (mistakenly) 
assuming you or Shakeel would want to backport it.

> [1] https://lore.kernel.org/all/20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org/
> 
>>
>>> If it is more complex than I imaging then I'm fine with Shakeel's
>>> approach as a temporary fix.
>>
>> Since above requires quite some changes, I'd say let's proeed with
>> the fix (since it's one line of code change that fixes a bug),
>> and then see how we can make SLAB_BUCKETS changes as minimal
>> as possible for backporting?
> 
> I was thinking Shakeel's approach for backports and
> kmalloc_flags()+KMALLOC_TYPE going forward.

Oh, I misread it then.
I was assuming it's critical enough to bother backporting.

> Just throwing this as an> option. I haven't looked closely into 
 > SLAB_BUCKETS yet, so that might
> be indeed a better direction.
-- 
Cheers,
Harry / Hyeonggon


