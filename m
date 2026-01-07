Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D50CFD637
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1F36B0092; Wed,  7 Jan 2026 09:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FE86B0093; Wed,  7 Jan 2026 09:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A026B0095; Wed,  7 Jan 2026 09:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E75836B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:01:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DA341603B7
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:01:24 +0000 (UTC)
X-FDA: 84305330088.26.F9608FD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id EBFA71A0020
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:01:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LC6hXQnM;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767794482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBG4aNk5ZWi1L4CNOgmaFLu3BODBNt1dP7Ozcg8ij/Y=;
	b=Jhs6hsxQJC2vhLBffv90iQV5nXhEcjYyelgibPnSpxUeKk0cLJiDfrX/XuQoYfzu/ht8FX
	EzYNqIKdXaQuNH9B6NnH83/39lEXlWzU8VR/uSUQJmFW1weULTB4WppfHd8E0nfovwNcNV
	uVKlp6w8L+GIm3RPeD4zwDIvbcKecs0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LC6hXQnM;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767794482; a=rsa-sha256;
	cv=none;
	b=lMHHzNXahpO1YGbxmjh/CyayjEG4mGMBxjCZGazYCtkbFXKt9aUc8EcnVmRk7EEy3dsidk
	X30qOigkTmYqI01KgO5cF4Nr7Pza1Sqxw7ekvhwnLubNPzYXQygDPQWO1Ik/SZZvoqzSo+
	nMKRa0By7MoJBOACoAGH1cXQW4aDQiQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jBG4aNk5ZWi1L4CNOgmaFLu3BODBNt1dP7Ozcg8ij/Y=; b=LC6hXQnMU/NjNO36FOTRtHoc0b
	/R9ICMbhCZtTHkS35bxXgX721Q6i3pKjMA60pANzb9P4UBUCYzR4bjTJrOFBImGAhb8rVbKgyDlI0
	fyQPiaIyjfN8SJ2QwfTKIRlPROAPEg3zkFuMjX0Ycm0wkAjRZejgQI72gS6yb8OMfoenRm6B8eNUX
	4csrD5Y2QACSnClhFglmySG3XsFDrvWSdXc5HsaLQXQs0FPAGnftGE5h0N9BFd9tugFDLAqVmol/l
	CrsnNeldt1O06d10lUU3N0XPkxb6sYRiAKq/7dtmFgKjLPhzaJPct/a4ZCNqTSThZy/KIG3b3NtYW
	87+tua7Q==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdU68-0000000DSbv-27M6;
	Wed, 07 Jan 2026 14:01:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 70AB730057E; Wed, 07 Jan 2026 15:01:15 +0100 (CET)
Date: Wed, 7 Jan 2026 15:01:15 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH 0/4] Inline helpers into Rust without full LTO
Message-ID: <20260107140115.GE3707837@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <87y0m9har9.fsf@t14s.mail-host-address-is-not-set>
 <QViERQV7XT0BjTfSSyP6vzQc4AYxosyF5TEZ5kRu8AVWjmGCP_5n5V2AV2hjqVza8-jvzyquH3JLJA1zvbRD9w==@protonmail.internalid>
 <20260107123528.GF2393663@noisy.programming.kicks-ass.net>
 <87sechh8id.fsf@t14s.mail-host-address-is-not-set>
 <un386uEr3TEFzLpGCdZg_Tzm63zO7Ze6IZN16Cz79EfWmEI_hZXbBvhG2enZmUXJ6DUnCMNm7QIz-agEYIDr9A==@protonmail.internalid>
 <20260107131822.GD3707837@noisy.programming.kicks-ass.net>
 <87pl7lh77v.fsf@t14s.mail-host-address-is-not-set>
 <CAH5fLgjmjjroRf-eU+4UrTPeq3HJ7QoWoCimBW-Occf_f22ARw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH5fLgjmjjroRf-eU+4UrTPeq3HJ7QoWoCimBW-Occf_f22ARw@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: kxi9yse8szdhdqteh41ne48c1e5dknof
X-Rspam-User: 
X-Rspamd-Queue-Id: EBFA71A0020
X-HE-Tag: 1767794481-832124
X-HE-Meta: U2FsdGVkX1/uY+hD8F/ragW3/9bzeGQdzZwgFNlF6I5Ewc0zeusGZVyOpoC27Qosh8znljv7IJW8RV4WG3K9KeWzLkYwaSfuBB7IPHHX8uQAfORU8gVte96su1dtNkFg/i3gwnEIkDRwc043MIUXonV/8NGl+sMJDlIFFtrx/ZSUe0JpNklg3KHDZT/qVrowU3EV1DMHL1lLFkKoXXeoFu9xkbV06yb/tPZ2sywiQglD7nz+hdW9TGb2BjrkefYKf0cl1tj/2PM0oRJFiXAMXhDePuuRDDd9+GKzt7DQp7S3/2R5yPWROM4gHR6NwcHo+YHXO18ZcGHwlFQ66OBNU2XpsH2DxLtOJzltogPoNRfaz1+j/jYEW2lINHqWL0BVbxAJY5zOWTlHd2PutItyb2+Pn7aLvfLBFuAQEVp3U2O5ZBJpgMpkM2kTsYQxo9vDetRfQE60DkQVv6YRHpgMfVpN+c9tAJwe9mql2kPiAXhOXOYemAqCni6AanIkZ3rcx0KtLKlEwFAoDB0PDwPqgqFftpjr8WC0zMHH+jhaOYVzBHxtJDrMiCfzN/zjiIQIsI0Jf1oIF0lAla9a5qXHtmABal+LSrZsCaISP/AQ/6Jr76huDxuo4HKI7D2NZdus8/YH8wHT52xqBxP340WWOHxPHWybc0GhT0kBfcKd4KSUKVA+HEUPK/batHtvuEND84yvNGrhSHjca/1bKrRreDhW+9Bph8Glu05GaKfUi2/EYfGkGSlgxGejYpvtJCLVR0b7w9WzzV0AQtKU7fRehBqtF8Qv7VVjOQLsTPr8RrDWPXgxSFGOgir4jFuzKRpiEyuU+xpUGVLmYCDWdH5IFrbdTYxsYfuBOWESOjk2nyX8YW6PaCm2ZPJLBYe/OTokg0EYvvFW7iHjODH8M8Tsp3n9Fb6YNmGaAJt9eNE/p018WuA6sSm3nzM5adAYJDZ6IuZe0ydGZBQE5eZUMS6
 d0BG45tr
 Ma0FkPuH/3TPPPYRzMfbh7AePrMNa9bBlEQ9BmPylck9x99bhiE27CoEeBd73f4+LV5z6g53+H7Ta5cMo/FLuNw6o+/mi00vhE5DNIGWDDk34OrEwHQlbJ4bykPOR3Y4oExVmwDG4+N/sd8lOB8ztId7cS0DDy4+Y0PqxQeYQVLnsMHUIEw8oZ6D5APyAxbz3JempUmmmafY+j6Q+fqReNp3RuRqdgsJ9rWwdnFrBMC1a4lDb9fGN8Xps7l9AbXhtgj+1uld0YRKqFsfDJUfOzVcCR0+n+3mGR2gqcXUVmdZSG12rWGQH0EvNDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:42:25PM +0100, Alice Ryhl wrote:

> With this option, helpers.bc gets linked into every Rust object file
> separately (and symbols are internalized). We might want a separate
> .bc file depending on whether the Rust object files is part of the
> core kernel or a .ko file.

Right, building it twice, once with and once with -DMODULE owuldn't be
the end of the world I suppose :-)

Also, I ran across Eurydice during the x-mas break, would it not be
possible to compile all the .rs muck to C using that and then building
the whole lot like 'normal'?

