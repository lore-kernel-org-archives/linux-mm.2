Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD752CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 10:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F2F6B0005; Wed, 13 May 2026 06:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6616B008A; Wed, 13 May 2026 06:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133896B008C; Wed, 13 May 2026 06:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 036866B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 06:29:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9EA76C28A4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:29:03 +0000 (UTC)
X-FDA: 84762023766.14.8F0CE30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DB4D040008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 10:29:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqTXi24H;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778668142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ht2QQ6l2QMI3jjLbrMSGg7m47Ftunylr0Q1SqunvI3Q=;
	b=gG/d+9QOlcEuPVHwCDjRNo80FD2ik2BLj1GQCIdYyKWDMKAI6h7MGVvoniK+X08/x+ELsN
	pthxjIa14gNoGyBBJ/kDaxKSZR68aZcWYf3TodnfamJ1qsYLvPQ8OAJ85U9dwLMajrIJyE
	nf8be/1YH4JabXggDzvfCYuglec7y/I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oqTXi24H;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778668142; a=rsa-sha256;
	cv=none;
	b=ykAatj13SLrOfvFZoP+EvLR01YWx4zzqti+Y/h9Z4OCUnFXi1kKkXOrxtVI8vBKWUBQWO7
	shg+iK8gzYxMIfFdo1MhYcW22YmHFSVD9K9rmn5crf/+orsY9Si1o7MWojeXsDPPyNzPYb
	4Ui//Kqlb9zgLkhpbm3yct3B4pWvYNs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1B6340A1C;
	Wed, 13 May 2026 10:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F393C2BCB7;
	Wed, 13 May 2026 10:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778668140;
	bh=SMSduI5AnAM9kqchaE8jYdlaOT2npCWPyM5+zGPU3o0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oqTXi24HsgBOAFuKC6Vi/Jw3ToZ3ix8HWddmTwJTDN0Un1xAN5BkYQzXEShkWawTo
	 GbwdlpXAgWvDqvcNS4fj4SamaL21POucJDoSE7gUJ+y6jgqAQeAzM1iOpDyFP3dDYj
	 RbhQq9r3uXj5eja2m/YDTvPvES31K7BtxsHNPpQukkzx1jXDmNwQs88p5AhLbZkYxo
	 WYY1U+LSv7W2Mu8THlmQACiifeBWhl6VW8dk+ILwXNmNO/9dTqLE3RnuJo2ptdVwoS
	 hfHoLk3RKGkwl/5TkgZ09NqeNYyFzaQwl3SN0CdD5rL7XU7NeUhJHKrDEBwv+tCA7/
	 ezv48qxYD1c9Q==
Date: Wed, 13 May 2026 13:28:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Jann Horn <jannh@google.com>, Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Liz Prucka <lizprucka@google.com>,
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 02/15] mm: Make empty_zero_page __ro_after_init
Message-ID: <agRSY-VLLdSqeMT5@kernel.org>
References: <20260427153416.2103979-17-ardb+git@google.com>
 <20260427153416.2103979-19-ardb+git@google.com>
 <CAG48ez1DJ88a0pBCE-Q0VXyDuJgng8zdunb38g4b4JPU88exww@mail.gmail.com>
 <31252c1d-a98d-4635-ab61-ce5b649e256f@app.fastmail.com>
 <CAG48ez2xJwJDgxSH0u2G==9dOQJQxQ7WsQfU14O1H5hEWic1eA@mail.gmail.com>
 <fb5749bb-bc87-4f0b-9ec9-8a1eb7ded3b5@app.fastmail.com>
 <agQ7RMAw51RlNUOj@kernel.org>
 <49d30ffe-b7e1-4b05-89e0-c3fe01348bb6@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49d30ffe-b7e1-4b05-89e0-c3fe01348bb6@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DB4D040008
X-Rspamd-Server: rspam06
X-Stat-Signature: ka7qy5ycfsi36c774jxb393564fucpoz
X-HE-Tag: 1778668141-506188
X-HE-Meta: U2FsdGVkX18yGq21VnSxnXpncIdZ4/ipThKMyc+WTiYcUFB0ZQqPTr6YFEDoC2mEEFQoSiEn2BpXBWL3ny+iO+Ox99Sxg7NpndAOztT6n41gb53pUHBpupnqGlgm0doyQPx1itG+5cidGkJvmSa7US6TkV2YTrX86qI9sT8mnje9Kg4bPjS5rGh6Xxxmx5I0DKcRp8UCB0jbn87O1MkWbLD6KMXhEO7j9LHIF3aQH9u53otZAGAdDkoD0gWCDpvNunRrBYRnw6sLg2bVQXXExflWTdZBoIWQmHiETjZNNey3GUoU48STF7QogzGC+ogPy3YSF5Q9JTxJ8mY1UBbw+0aIZ1eSe3GDrkcAK/L+GNiSGgboVIzw3XztK119vTFoh4eEoLsSP/Ggk5VM/HtXmoech+p+Xgfj97z66Fud3oShu7CdY4HHvGjVB7RdBOky6kg1KOWdu7vazUXwqna0mudqoGmjZyVyL+0alQ4x54tJJtkS2X+3hS4Pg9dqVV1JccMxeMcgADCC5Nyq9w3dykIjWnzto46ZSaKWokpacwgNN4luK+Lfbf2RFvDXKij6m+KaGgZXozM2xYv9drLIzZ7tr27pMZIvRRxBe2c0Y+Of7PF0iCIiYGY9OUXPnjUMpPxv+J/mE36knr9VTgq+eCa4OGcdoCmcvn2SeFKiW3/KfZ7hW5kMtv2xjuH8rj73VEbV+pOYUSbm2SGvBBk8RnbMjzpT4KiO8AsaOqttTBzcLg7qGplztVAujg5zpX1UdD31Av8jO6chtJXIVD0ghlVVB2cpWJxFAREyyP4E0s3sB/0nEHPtidJoEG9+XIPApdnECCOMzNyWjVBgRrYAcuWqb3Bu6PazEWE2f70HLLgtbJovCSuq1kRQMGNuzRQuwHEqmdsjX4Cmk3jJMKiwftg5oQrUJPWol2Z1ZZgMyp4s43cyaZzXQiT09oabnnleY3vc9ot055OMtOjR+U5
 iB7hW63c
 L6PWUo040TgYUYDlvA8IeWY+abfH/RJ3O0roUR60fj3Cn5IwR+iUWZMBdjX81KaZgZLd+QEmURQ6uX+w8KP53VDzaP64rHBPRFUNRh0C7mkVUAhGIc+3/HkvdX2+eGgPTyvEb9RZn4XmPQyDHH8QLtHPWsJ1h8RaXVhhryJLthaduhMj/XtX72rUENjx4NSyTFEZV+vHVdM076uWymCf7NFLasMie8dk26vzBWIsQhnpDMnMPyHdqUbHFrpEIYsQ7mbAfk44SP0UAXIwywNME5EuhDvKa6b8ohkx1qFTFVs2k8fESJ5dNR/pYa3zVuNlS3S1b6Cv7U61eUrN00P/tIQeNVe4hkd8/4l4tavB1ITsx2W3h8mXYCe/BiJJMtefzKSsoZDxUeUDW8+wnsLDrHZl4jKDRW15OeRHKeqE8V4HyR1fsnzxmY2mym9lfs7mWIKJq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:53:08AM +0200, Ard Biesheuvel wrote:
> 
> On Wed, 13 May 2026, at 10:50, Mike Rapoport wrote:
> > On Tue, May 12, 2026 at 02:56:16PM +0200, Ard Biesheuvel wrote:
> >> On Mon, 11 May 2026, at 16:40, Jann Horn wrote:
> >> > On Mon, May 11, 2026 at 10:59 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> >> >> I think we should simply do something along the lines of the below,
> >> >> considering that the size of a data object tends to correlate with
> >> >> its minimum alignment.
> >> >>
> >> >> I do find it rather puzzling that the compiler emits empty_zero_page
> >> >> *after* zero_page_pfn - ideally, we'd combine the below with
> >> >> -fdata-sections so that the linker sees all individual objects, but
> >> >> I suspect that would create some problems elsewhere.
> >> >>
> >> >>
> >> >> --- a/include/asm-generic/vmlinux.lds.h
> >> >> +++ b/include/asm-generic/vmlinux.lds.h
> >> >> @@ -452,7 +452,7 @@
> >> >>  #define RO_AFTER_INIT_DATA                                   \
> >> >>         . = ALIGN(8);                                         \
> >> >>         __start_ro_after_init = .;                            \
> >> >> -       *(.data..ro_after_init)                               \
> >> >> +       *(SORT_BY_ALIGNMENT(.data..ro_after_init))            \
> >> >
> >> > Oh, neat, I didn't realize that's possible. That seems like a nicer
> >> > approach...
> >> 
> >> Neat but rather ineffective, unfortunately. (I don't see a size
> >> difference with the arm64 defconfig kernel)
> >> 
> >> Given that empty_zero_page only ever gets its address taken, we
> >> might just move it into the linker script if that requires tweaking
> >> anyway. We can just place it at the start of .rodata, which is
> >> already page aligned on most architectures (and will become page
> >> aligned unless EMPTY_ZERO_PAGE is #define'd by the arch linker
> >> script to something else)
> >> 
> >> 
> >> --- a/include/asm-generic/vmlinux.lds.h
> >> +++ b/include/asm-generic/vmlinux.lds.h
> >> @@ -472,6 +472,17 @@
> >>  #endif
> >>  #endif
> >>  
> >> +#ifndef EMPTY_ZERO_PAGE
> >> +#ifndef __HAVE_COLOR_ZERO_PAGE
> >
> > I don't think we want let architectures that don't use colored zero pages
> > redefine it.
> > If it will be really required we can add the ability to redefine
> > EMPTY_ZERO_PAGE later.
> >
> 
> I was actually intending to add use this for arm64 in the next patch. It
> already has a reserved_pg_dir in .rodata which is page-sized (i.e., up
> to 64k in size) and guaranteed to remain all zeroes, so empty_zero_page
> could actually be an alias for that. This is what I had in a previous
> revision, before you turned the empty_zero_page definition into common
> code:

Works for me if from arm64 perspective that's ok :)
 
> https://lore.kernel.org/all/20260320145934.2349881-16-ardb+git@google.com/

-- 
Sincerely yours,
Mike.

