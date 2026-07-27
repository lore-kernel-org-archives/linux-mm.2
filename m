Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014B4C5321C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 11:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0096B00BE; Mon, 27 Jul 2026 07:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29D46B00BF; Mon, 27 Jul 2026 07:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2576B00C0; Mon, 27 Jul 2026 07:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8456E6B00BE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:25:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BE991406D7
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:25:39 +0000 (UTC)
X-FDA: 85034326398.20.5E795AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4F7C918000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:25:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gURdEEhE;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785151537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=08+hT4LC6IqwRNx8zMGRqwSU5ng6RkaDJeOtLNkTdSU=;
	b=pUeUDJlDWKcUOBdqxMPQ0yJ+qHl1FY0YQGqWwksm3ORm3Jme3ErofxOAU4DJhUiTUWqNwB
	wXqFuNz2UxMJZKMzocytTDdzbWOn7jwyekuV4NwHSIgiYTRCF5sIessCkprdPWmY2nK2v2
	+LN9kWEqegBxf0xC7+Aiym4uQywKs1s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785151537;
	b=MFrxB9ZQZpI5aFejs44XBDyO5mgOB6mrwo4UxvkcZ/wfq86ruK/sQ/0TzS508xqdHvpyJm
	gZf6n901MijJlPvn4O3Pt0p4bxi9O8EO2/mU7VYFRn4gWGRTSr5VLCox4ryV+mqy0uH0qY
	cO6Yj3exkqeErgxWk7t5812G8Yd4ppA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gURdEEhE;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C907F60A79;
	Mon, 27 Jul 2026 11:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2042B1F00A3D;
	Mon, 27 Jul 2026 11:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785151536;
	bh=08+hT4LC6IqwRNx8zMGRqwSU5ng6RkaDJeOtLNkTdSU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gURdEEhEMWvzjd7vCRhS6YHmdHjStShU1vGvpoiQFhv3EIePzPg0zaS2IVVaVfL0A
	 9sLrb3O8GAXBsYHsgtmSMBkzFlidv2ecDqzVqJNV4gxjCm4tB5XZEtqieHbUu7joyq
	 R+X8k/H7b1DwQYwB+hJuSsEIZzHRhVVFwwq7/SFYnJm00U2OBTo4AHX6RBD4kJ3y7F
	 /2qYLedwNCmXRc0KWDfgVx4+k6uIilb2wNPFkmp1pcnnLBOMzE20vmeHketJokrJfI
	 lMnupykmxG7Y5JbVe153paj0CXj6WyGW8X0iWfjeG6ql1OUh+IkUrPbLlEs2tCZzWm
	 HEIZ9/i7+Nn0w==
Date: Mon, 27 Jul 2026 12:25:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	"Denis V. Lunev" <den@virtuozzo.com>, stable@vger.kernel.org, 
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, 
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>
Subject: Re: [REGRESSION]: [PATCH mm-hotfixes v5 3/5] x86/mm/pat: acquire
 init_mm read lock on attribute change to avoid UAF
Message-ID: <amc_24CTvgPj8VV1@lucifer>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
 <20260717-series-vmap-race-fix-v5-3-606a0ac6d3e5@kernel.org>
 <80993b70-352f-4069-84c7-39a04c061e98@intel.com>
 <amIEC1qDW3kfeuHd@lucifer>
 <15f365d9-b5b9-4dc1-b24c-1b6f9363e9b1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15f365d9-b5b9-4dc1-b24c-1b6f9363e9b1@intel.com>
X-Stat-Signature: posbjeuq8jj1wbwr4nagync1wgo19dsw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F7C918000C
X-HE-Tag: 1785151537-236502
X-HE-Meta: U2FsdGVkX1/I6ASnQa+t9xYrfLLklKPdFtDnM6gRGVdUUMlrmBFTdK9kqqHXFzuIxWH3fU7wXcHrRN9pfDyqfYmDFTFg0lrk7boLC7POG128scJo2HfowFz3H93keO5zjeIfR/eUsYpyRTN0kmMvLzJtuHKXzhDpfnFkd8hrQDPA+Wwq2aPeSb/su/2/0TYQzgyQHoyt4pqvGJLpTaLXuCbbLOA15MtvcKKZDSUFsx8hLYkt9f8LfaZGhZJgZSEGiIkewsVPbj1NRzr2dRmCQM9ldCZXPqjDpYa+tNtogWTvNJAuf80LzoeVD7Q35PGw5N3oaeY68o/bG+BLfgryN8yqYGrp8b13Ka5ZdVDZG2X4qjTDcx6SzRqNvsNdsGJtleF27n9F3jVMPGbKgs3A7J9MIUgg50rXaOU5TcOuEvZ5lpVzczONDh4eSlqfPSz/dFRNgnvHZKlO89CJ2Sllh8wQ2BQ+Ao01qdgARKJ4iYCSZ6CHYgOSGQGs/XPezrQ9nqbMcw/XMJuQOK6gywmXbL5j2GVY/9IpgN3k12TXkqgya+Tum6DqTNl6e/wBWZ4pjmUHd9uyAy2v1nzpjDiliSvvPGVAqN1iN4v2nhUQ42rFpyQ6pdQfSshl5+I8i5SkSAR2wFZcTvKvVPPhNSwdy4KvQvy3D12o6RMjamfG32YhTib0BqwdCB9wa3V1NS9pjubwegq7dYu/UPhMgN5nrGR4d0WSYCIalpx+mnLeUHKziHr4utuCF4w8eFaNm7gQdwIpbGF7H4YERQnATsEyOpGIaIV75TGYLb98OfgDmkIKMmH7TU27dMKC8cKXnYMmVH7v9qwhUocxAZuF/H3GCfbaUz6jPrIxv2T6SJxPybz8rOVjAYI+daN2zWLBv6sg4GaOuM+rkHVgawI5jS5bv/f2i3IKDEN7QtwgdacpbcctRmZmRuNygtembMM4D0CSn1tznZ3rCC168ogAWIu
 /j2f6rcP
 61hrHtyELQqnxe3U8uu7pNHS1RJdFpW3zWGtUW0yUWyCRcdHxMUYoR0qP0gok137Pq1dYGlP+1n99h1nFI6iCwG5g857yKvZAfuSV2tJfihqLStx2f+0fE5bpsm9VmnLl2CKxYMpD22K/gmcSytw0vlQTRXeuaq+2LJgePwf8k4rPCAMmZ93bE4MdEUWkhFPvN6iA5690QojXRnqEUWMy3BKC+EtTrEqZA2Hk4eiSAoqnoSRzwPNRiTFwB2hFGGJIgcAoGNNPv3PQLbEZgjOOQUMmxKoGkNYzUsfOmktWUCDcJbqL0bpjWTZL6+uAi8Gr72jnlxzEIOeutXaBoYNwalSlVr+XCoQC6TYY4iTazrg9C7Jcj2Wnr77Qtov5dX/jncSPjXjaGqKeJNGHjXTl4LGzV15/9pmg9msOvwWRZw9VIx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:30:57PM +0530, Borah, Chaitanya Kumar wrote:
>
>
> On 7/23/2026 7:48 PM, Lorenzo Stoakes (ARM) wrote:
> > Thanks for the report!
> >
> > A small note - it'd be useful for you to clearly point
> > out the revision of next to make our life a bit easier :)
> >
>
> Ack.
>

Thanks! :)

> > (another small note - running scripts/decode_stacktrace.sh would be hugely
> > useful as these offsets aren't so useful unless I have the exact kernel
> > binary you have with debug symbols :)
> >
>
> We have not been asked for that yet but we can surely provide it if it
> becomes absolutely necessary for debugging.
>

It would be SUPER useful if it's not too difficult to implement, thanks :)

> Thank you for sending the fixes.
>
> CI looks good now.
>
> https://intel-gfx-ci.01.org/tree/linux-next/combined-alt.html?

Great thanks!

Cheers, Lorenzo

