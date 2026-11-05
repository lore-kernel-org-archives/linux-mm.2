Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18B03606A33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hlg68ev4
Received: by kanga.kvack.org (Postfix)
	id 054916B05B0; Thu,  5 Nov 2026 09:30:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005506B05B1; Thu,  5 Nov 2026 09:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35C56B05B2; Thu,  5 Nov 2026 09:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE2456B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:30:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37B03C0A2F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:30:05 +0000 (UTC)
X-FDA: 85401299970.21.E1DC5EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 91E272000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:30:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlg68ev4;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793889003;
	b=JnIRRmq9UiQ/ZW2BhnnT01uNntQHNDfC6003CNh7TjUVHe1HS57aoLjPhrjgjCi2lZLJXn
	igS2ahjErM/3XF3uM2vdPnuRktcBgoBziXRD6UmrhIUGvzRc367+vsHzKu/QZK4kzEOoD1
	lxflIzwQGKSsJtgIFjvjtC0i9FVZxr0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hlg68ev4;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793889003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QBN5F5BOBNYgA8RLkTPielNH7SMCn60Of7vIVfmEPko=;
	b=pEpXfrFCxFZI2GV6K3AJXucAGa9EUniJM4GhHqZn/RmnAxMbG8wISFBxoCsVjbVewMNtd6
	KOy5OPsuB0ZKL7OfX7ojqS7Aohf8+2ByfBByoH7hlVBbA0e1309sYJp5KevJomZ7z8i1HK
	Oz/j6sUON0NlQedSMajUOfaoc/ZYb1g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B237B600AA;
	Thu,  5 Nov 2026 14:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF87F1F000C1;
	Thu,  5 Nov 2026 14:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793889002;
	bh=QBN5F5BOBNYgA8RLkTPielNH7SMCn60Of7vIVfmEPko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hlg68ev45M9aQCUBa10+14y+e8dqXHO++KTG1+LuUiU158SYUynD0Eishqwm2z4pp
	 AtnjTu4rRwePPNr15mLDhe7+uQWzQNkjQKHSyvx44Yvqanq0rOTWVMkt6NGPAvCM3J
	 zFFgnX4nA8YjEYm9Qm7cIdDCvyOeLNtnsoouIgiIW90VHPLBMmXypquFsGcE0/dPzE
	 Akszo7FcyBFhbCuRgXulTqFU8SedmiTu125WAgPh9tX3xN+DLsA+5P/nNuVrlhdvGV
	 T1ft5Ph55jM5rSTVMoo7Jh0K+iUHBLyfLPVGUriuZg0u3+Xu4OEQBTePSqYvoN8ZR6
	 dqh78QkFR7BIw==
Date: Thu, 5 Nov 2026 14:30:00 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Conor Dooley <conor@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 04/10] mm, slab: introduce slab_debug=N
Message-ID: <auyFYsbsMm8qGThW@thinkstation>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-4-0484ce59eabb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-slub_tiny_rework-v3-4-0484ce59eabb@kernel.org>
X-Stat-Signature: pyoyqmib5fcpzxaz7h6ed4t7418u46w3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91E272000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793889003-693028
X-HE-Meta: U2FsdGVkX19CwubmkBM2KsJUmGi9rMQVbdFAvaOYG4sz90ODF4ZwPDwVgIR6Sj0XlaGMs+B5u/l59MBXbqWX2cqWaiYGftKjuq0N8W8uB4raPSyjJyh/E9/y1bqMiOn8nCb9JgWpGoIvzYfKG4P94/wNNZD8SqvI6NLdFOVByN/CeSUn6mAA78Dv/qqMN7939+sclAfE7xYUJ1D+JrnlXlT1ncOEEw09dqAWsphvjGR5VQVTYAHNQxbbRtcjpsfwGITwQwg3e7bvnxKDYmned9GTC7/VDLHIV4IV2iGXg7YK/l0IvtAFmpH4w31uW3F9Wc+sHzCc2T2guqfoYVfz9UP9rVao9ZD3OTDnoseYHdz3vJSMXSu7QHSVPb+WZtGeQW9Re8u3NtVwpZ2qf7NFPrHmgQwawBkEAHQG9vIAEjYBvVrxnU3IG1YPpi3I/70jFPoJ6EXtzHZyFGfA8F9QNL9rXyzXjPBzLO2COmYfdf54w6KtiXYgjSwHJqb4LRTbsrvqgr9ILITfywNScdA9F+EwZ+9aoYB2HMAQsDajWsN2gUNOiRqAkgWaS/uFg2SgGYNm4Tra4eBKiDZd1o1S8D2jyIMtI331vPWDecPGoKC6ZKR8uz6HGv45vakhHZDcNh4WNtoYcMjunmT9ZLEBH4AVJMLdRj1SVAUWe/3VPSnp1N2Fu5BggexPWLpS3V/UNl1+9A/S0zWYUDrKSPglqfKwgadMdXPTx9gAEwfhcRfQ2PaZxLplCs76ntwVMemtkxO513n4tqI3GQFtDBMM7h1kXWFTWPNI9AJxZR8YltaEJQablvBOMLQ27+DtCEN7+4GDc7t7tpdz7/eR6Pq9ZubI+aQTbc4rtMuDgni2OUWredD41wy1ALCXmHdaXfE0GFPn+2EH5o/jihQX1pSXDG3zW7tR4XWeaZ5cukZ6DQF9ZPA3cRieBBoky9gk2DldupwriOrtK8Ch1mZ7Xvv
 o4KCrAyj
 4utDp3k+l5JOefvRN7oxwJvb8qAcJiaFIeRvBHaSdUkHKtGJyAo5lbHBax3tQmXAArAr+b4RtO1ooILBeVoUc2sIT0HJK+vnuyMLyKsc6G2QrEPlLKkhC06oM018YLsh7JEOq0luUVnEvp2pLvAgxhjBcROG1YJYMpLKvDOEF9EN7LLSiqkUL+qIjiTjUfsCQQxLEUWVgEm/mrsLu9m7sqdH4xu40xkYqpY6kQCuAiLPky7R4A0f35EiRCGVRLnjYG0MujZpf86arOQtopReErCr3qKg8VY3P8oHNygzy5D4v11YnUKxfrLC7Vp1aSkoYUi2WwTPiXCgAJQYhnVCjc/75uThcT6KGEWam02fr+0K5L3Y2NWP7ZIg8+wNZISzGEVRBQ0lOvd5mdqDMdVQvLtVW8sCj52WJNXNlDg0qC20DeB4H/cD1HGvafvTyP31cZPVmsVMv97oPkX7xrXyzNjfera4bR/JkOzZheUAeAOhd7yi/RbBEJjSPBGqkZTf7forxKdqeu+71SD9ejqDMMmtuQsH2n5rZ+qx53JuTzr7UkmGeQ/Nj5xGaYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 09:43:53AM +0100, Vlastimil Babka (SUSE) wrote:
> Enabling slab_debug has the side-effect of disabling all percpu caching
> of objects (now via sheaves), which can be sometimes useful for saving
> memory for e.g. kdump kernels. To make this possible without the
> overhead (CPU or memory) of actual debugging options such as poisoning,
> introduce a No-op debug option that only forces the debugging slow paths
> and zero sheaf capacity. The new corresponding slab flag is
> SLAB_DEBUG_NOOP.
> 
> This will also allow reimplementing CONFIG_SLUB_TINY as a boot-time
> option.
> 
> Two details have to be considered, as suggested by Harry Yoo [1].
> 
> - While SLAB_DEBUG_NOOP is part of SLAB_DEBUG_FLAGS, it should not
>   prevent cache merging as it doesn't affect object metadata, and lack
>   of merging would go against the memory footprint reduction. Thus
>   exclude the flag from SLAB_NEVER_MERGE.
> 
>   - However add the flag to SLAB_MERGE_SAME, per sashiko.
> 
> - SLAB_DEBUG_NOOP alone should not request disabling printk pointer
>   hashing. Thus rework the call to hash_pointers_finalize() to not rely
>   on the slub_debug static key state. Instead determine whether the
>   global or per-cache slab_debug options include any flags that are not
>   SLAB_DEBUG_NOOP. This does not change the fact that caches created
>   with explicit debug flags (i.e. slub_kunit tests) later in boot have
>   no effect on pointer hashing, which is determined in
>   kmem_cache_init().
> 
> While documenting the new N option, remove obsolete SLAB references from
> the F option description.
> 
> [1] https://lore.kernel.org/all/arUx56ee_nkxYP_f@thinkstation/
> [2] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=2
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

With the sashiko report to this patch fixed, this looks good to me.
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

One nit comment:

specifying SLAB_DEBUG_FLAGS depends on CONFIG_SLUB_DEBUG, and with this
patchset there is no way to minimize slab memory usage w/o SLUB_DEBUG.
Sounds like it's time to make SLUB_DEBUG unconditional. It's enabled on
all distros listed in kconfigs [1].

I built kernels w/o SLUB_DEBUG and the difference in the kernel
binary was about 40 KiB.

[1] https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=SLUB_DEBUG

-- 
Cheers,
Harry / Hyeonggon

