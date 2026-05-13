Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEBEDCD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235D56B00AE; Wed, 13 May 2026 13:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C1B6B00AF; Wed, 13 May 2026 13:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1227A6B00B0; Wed, 13 May 2026 13:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 005A16B00AE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:14:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94D59403D0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:14:24 +0000 (UTC)
X-FDA: 84763045248.30.26FED77
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1CCE140002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:14:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dHe3obEr;
	spf=pass (imf23.hostedemail.com: domain of 3bLEEaggKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3bLEEaggKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778692462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55kMhwW1WRb8keUcZYpGwz3Iws6aBnbO5gEnqVKvWQc=;
	b=MOVufcsqrdyBDC2yqVsNZiDYW4X4HnZesjhT2QrIrYZjO6yR/x9suuJ7VejN/Uzoe71uEK
	vSXF/wxDjg3eh2jzHTssTygySBfmNw5AUa6JXsHmeTWumfs2jegGVwi8m+JVf3QRoLKNmX
	DOYsSmF5AuXuO5ADRieic52ZC6VrJO4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778692462; a=rsa-sha256;
	cv=none;
	b=VFAUDfshlzB4zpBPsfCopeBUXcZtut+m8iPtRbUgwGVSsDkyFkSscS0DxygXUewf2PTcK6
	h7aguT/g56yujHLo/+j13hj/w+r5fg1R/ZYPlpZ0aA9JLIu9H7Xt4Ga8lF9cPMimPO+UFT
	DWdjPdG9QRfhNQ7fLNZjvIwJI8xDakk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dHe3obEr;
	spf=pass (imf23.hostedemail.com: domain of 3bLEEaggKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3bLEEaggKCDkeVXfhViWbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fd61d252cso1483425e9.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 10:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778692461; x=1779297261; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=55kMhwW1WRb8keUcZYpGwz3Iws6aBnbO5gEnqVKvWQc=;
        b=dHe3obErc323xdzqYRinE9DbOq/JaHalGvNaRrPUPgrDZ0n13Ayh4EksCy/QljGbOG
         rRQoch33ZdELi97sbDDq5rmgyBGugGx/QbJMHVEA5FNYh4KQ4cfgEUCb6BQYvedbpJS8
         NclU7IvnrLiGZixJH3jev4EarZdXRxsFRSBPrhTcd8dCMaTP0DpL25MxnFgrw+ofb0CH
         bBz8RNBWQQOtp5KpPM58gXxmY2MVkzqvo+GxLScjeNT2ASNFMnFRRj5P1mwlqe790fe2
         8rQdjhcfgiTmgmYkp26ZV6tPvirWTIdT1vkzlkLfcf0Qcsqliu2svni5jXiYhQh9jjVd
         1wKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778692461; x=1779297261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=55kMhwW1WRb8keUcZYpGwz3Iws6aBnbO5gEnqVKvWQc=;
        b=hUoCgHmvs5aOq7qSuU+7LomChROGKdBGRHmTkPODs7IkRjB+Mj6X0x5seoOBKofUwc
         PEWyuyPy3GGjp18TTA6Q+x95GV+HqRrsRBjvJ4aN8vltJZVpMGLp3mzLq8i0qg7uhwXJ
         511TGmvFVH8Lncf5wzIatezC42jvz6G+SoWpwAe/67cAap9RHyqeVwDBCSGI2aYK+7XK
         c3Ti1pk2eHAxJzjoQuSVB3yrJ0UkMWekgmQ+nqBNZbLmFw7NlRaR+PeB+DNuXybLak/v
         FLfI6GidsbjPU+LO47iWsDNFGMhA14uqg3sHVI30gX1IKEEmmY7fI0sPF/9WMbpNH3Ba
         h8Lg==
X-Forwarded-Encrypted: i=1; AFNElJ8BO1gOwJY5ut7Pu9qZ+0YBLvJ7GdC1SjSYRL4I67qkIh40/G7T9erxKj2EICmnjXF4YpVBpoNaCA==@kvack.org
X-Gm-Message-State: AOJu0YwyYsJxCYPlNhAFxUTqe1l4VGCGHg0vB/geOS1MWTlE2qhE/xEc
	r+BId8AMCofnLUjO3iMKkKga9RrH5kZcBbG0qpKhgJWHuOEpaW3pe0AKKQ82hxA2QZQIke7eEFh
	9klzVmwbs+KpyFw==
X-Received: from wmdi29.prod.google.com ([2002:a05:600c:291d:b0:485:3a14:a74e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3109:b0:485:46fd:7887 with SMTP id 5b1f17b1804b1-48fce9ef234mr53663625e9.13.1778692460978;
 Wed, 13 May 2026 10:14:20 -0700 (PDT)
Date: Wed, 13 May 2026 17:14:20 +0000
In-Reply-To: <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com> <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F>
X-Mailer: aerc 0.21.0
Message-ID: <DIHPURUMTESI.1LP37OYJN1N31@google.com>
Subject: Re: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
From: Brendan Jackman <jackmanb@google.com>
To: Gregory Price <gourry@gourry.net>, Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1CCE140002
X-Rspam-User: 
X-Stat-Signature: 1bfu413sqjtkd9qiaiir66rjy1wnmuey
X-HE-Tag: 1778692462-617969
X-HE-Meta: U2FsdGVkX1+H657qiC3n7W6gMNkXshTQoEJNLqWRupeT/ijY/FYgreLLheYe0n6fExiLoYSnX+KTUbgaPzf8mhScfZfGxxyKxPcd/dcMcrM9UfWBKxPmdys6WPk7UmYS19NToTqTuV6kgzWbqj0igLdPNLI8FmcRhk5dbj2/Th9w9K8HnTE/viKRyt19cTT3mHRTAVsO1Fe0NqTntHZV3qTXEY1ekDXIMHEfBIJd2VD3b4EWcl+sFAG5LkBRmv1eomiA/PEKCeh2+GQEbTwMb/LcjEgm8bCN9bQj4gVnjC6VXKH2+J7n9lGqt/h54Qsb15lnMrimBY3uvievP42CTA4sHwv4R67J4a3QixpYt+/T4O5kBQNMueJBKE9iD74O5netixv1rZGYEgFAlAPsuwj7CzgzPHYlZEaAE4nvTXLRPQhpC7pyN7tLrTWm5ZR2vd06S6Nw2SLhpIkhBtu/bnSMoK8y4Rs69gGFPEYm2BhWFsiNW28Q9H0wsa4PwycgWSNNEacJv1VFGstA6iiPVt5TmNWjj9L570hSfA+acGiPQljuzX+LtSL3VxvzAkWpPxfnPkIi3m8KIC2g3qAGlH1zdBUbsdLdAfuEWIwKvFa6cwTVdirt1ZpvzhBNVeKzw0fTfKk179r77nkorYxM6GO9t1cyCMJI3oUNkPW3zvlXgBOxoQZPGIdo/lyD5tYuLLTE/nvwzI20PnY4n5hhngqakT1rH/Yn/HumJDHth9DJ8GRU6MghYmI0I97l0OfxdHY/ixEPZ8hPdHr+7P+ptMnKPm2GHSd+2XP0Z+3Glpg0UuXCQsG/fm0BghQxoqDuYjFe0LOFVgPr33FhlD71C9mR56BiVxTI4nm1N+4psFHXx1h6AmoPOtY/EBP1gELwIcQ+U/xIuy4RcgNbT0CWmyLvaBScC82nqzoneBZ2L3zmimgjh8n/XP2sm5fTAbNTeDhpGn8zaMtPcXKZIZR
 yavf72ia
 tE/K0EJb9d6aiISQnDP/JVugp6S689VdH4XYfvb1W7cdEMMQyJ0CCgvOV9MafVN9JNUFKrXUunvsuy114a+hdrWdm9G8uviQl7gIxb36VxvUdoMWo1NNUFvFmpcpfWOIy3OFmkqG4ZEsx5taYsDUJV/9Q97jOCU7KEcKJT/Du/v8m+46wIuvKTQz6u8ceIlnx2YIpf7LD+ulNqpxZ+i57SPXvLc7A8M4ajibD+SDA27cs4ufVbo5PdVS7Q4U+8TesdGzdcVQx+HlXhvmChVIXm07KN5LDD51G4V00dqypNmAvRTpvT1LMABAzzYe2OA4k51Eo0o05CjaE2BPY2w994mrZ2NjAafW7PXyw+cVHESOkQoEiHumz5n89+PVF5R+O0rg9QIqB9TchR/ZSDioJQRiFG1aarTtdXyrR+BCj7vnPwm3IYzIxdJZvUigiVFXq0hVXbqZHBBo7Pv6aFmO0b0GyKw8kGW4fwwU8/DlpKPdwqOvBjUC1ByIjbJDkqEOhFdfbhdD3sojTFL3N/hDvVxMpu77fVCgHn/0kQQx8UgyA1aOJ4eY5qS2qG+72BetKZdhIV8ceRXdSx4OG3sOX1b66LAyTDwI2wmhxq5o4dfVeLBQ/DtI6vmsla1qkrlI1iY2WngZs7A9NpxDu1XJkEEwkTaYJG+ZqT2Olaltn5lEkY5s7OOBCNPmOGbfiZReo2+SnXzmyh49xyhPbcajgUfASUmbZLb6rOAl72G49PAHYDHjBCeiSLC5n7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 13, 2026 at 4:17 PM UTC, Gregory Price wrote:
> On Fri, Mar 20, 2026 at 06:23:24PM +0000, Brendan Jackman wrote:
>> 
>> Because of these ambitious usecases, it's core to this proposal that the
>> feature
>> overloading the concept of a migratetype, this extension is done by
>> adding a new concept on top of migratetype: the _freetype_. A freetype
>> is basically just a migratetype plus some flags, and it replaces
>> migratetypes wherever the latter is currently used as to index free
>> pages.
>>
>
> I'm a bit confused why the need for additional level of indirection
> instead of just adding a new migratetype.  You still end up increasing
> the migratetype matrix, just with a new dimension.
>
> (apologies if this was covered in prior work or discussions, just now
>  plugging myself into the series).
>
> Why not simply have an unmapped migratetype, for example, and on steal
> you convert it to movable or whatever the preference is? 

Because the fact that only one migratetype currently supports being
unmapped is a temporary happenstance of the guest_memfd usecase. In
general, this needs to support having unmapped variants of ~arbitrary
migratetypes.

>> .:::: Hacky bits: simplistic secretmem integration
>> 
>> The secretmem integration leaves the mmain optimisations on the table;
>> the security-required flushes of the mermap areas are implemented via
>> distinct tlb_flush_mm() calls. It should be possible to amortize the
>> mermap TLB flushes completely into the normal VMA flushing. However, as
>> far as I know there is no performance-sensitive usecase for secretmem.
>> So, I've just implemented the minimal adoption. This will at least avoid
>> fragmentation of the direct map, even if it doesn't reduce TLB flushing.
>> If anyone knows of a workload that might benefit from dropping that
>> flushing, let me know!
>
> Crossing a couple streams here, I wonder if there's some mechanisms
> introduced by MST's latest multi-zeroing-avoidance [1] code that might
> help deal with the problem here.
>
> MST wired up an optional user_addr into the buddy that allows us to sink
> the zeroing step for folio_zero_user (or folio_user_zero or whatever)
> into the post_alloc_hook - which includes some cache flushing.
>
> That conveniently gives you what you need for a TLB flush AND an
> indicator that the allocation is intended for userland.
>
> Unless I'm fundamentally misunderstanding something, the pattern at least
> seems similar.

Yeah, I actually only noticed that yesterday due to your posts on that
thread! I need to investigate it further. My assumption has always been
that this isn't a general solution because we don't always _have_ a user
address (e.g. for guest_memfd it's important that we can populate the
memory via write(), so there's no user address), but it's pretty likely
I'm missing something there.

> In that sense, does this just become a post_alloc_hook that unmaps the
> memory after zeroing and allocation?
>
> I get the intent is to have the majority of memory unmapped by default,
> and then steal those blocks and map them as the kernel requires more
> memory, but I wonder if it's cleaner to do it the other way and simply
> have the buddy unmap on alloc after zeroing, and remap on free.

That would be cleaner indeed, but the key question here isn't about the
default state of memory here, it's about batching.

The reason we need to do it at the block granularity is that a TLB flush
every time we allocate one of these pages is a performance nonstarter -
that's actually the entire point of this series. If you can afford a TLB
flush per allocation then you don't need __GFP_UNMAPPED for the
guest_memfd usecase, the existing direct map removal series [0] is
already fine.

[0] https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/

> Seems like the free path would be trivial, check if the page is in the
> direct map and if not, remap it and move on.  Entirely hidden from
> existing users.
>
> So, maybe a stupid question:  Was the opposite mechanism considered
> (unmap on alloc sunk into the buddy), and if so was it rejected for some
> other reason?

Hopefully my prev paragraph explained that it's not viable anyway, but:
if we _did_ do the [un]mapping on a per-allocation basis, the
disadvantage of unmap-on-alloc is just that we expect most pages in the
system to be unmapped. So the majority of map-unmap cycles are pointless
(map on free, but we're probably gonna unmap again on allloc).

Cheers,
Brendan

