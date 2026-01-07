Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0AEFCFD62A
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 13:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE65E6B0092; Wed,  7 Jan 2026 08:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE896B0093; Wed,  7 Jan 2026 08:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7E16B0095; Wed,  7 Jan 2026 08:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD3B96B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:18:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58EDB1602F6
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:18:31 +0000 (UTC)
X-FDA: 84305222022.12.5D3DA36
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 25BB120005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:18:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b7ZiARls;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767791909; a=rsa-sha256;
	cv=none;
	b=H8k2aDZx0htWU3+poFwYPFtCbzGCVrbrncG3ficOLeiB4JogeXCr0LXvk2ngzTedb+ds71
	K4Yxt9Y3/LWsVDosxy9RFR7rXMF1y95Oirv4fdDyTiM0DJNJLtQ3uUBDn1mzYJ5/Wu5any
	CC2vLcejNp27Qg52ecs3FjHqB6Yz/Fk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b7ZiARls;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767791909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejt4fl24yJGg/IPMEl6Jv4QbwGGu9SxvkwuaJgTIHGU=;
	b=07wsSjxJND4Yf1kt6H8tSgatRoqO2O1yfebH6yUMSv8bj/B7rHsxGnt4cL6KclXb9zTI+n
	vbG4cgp2QfVINzfbGmToY6Df0rd5ARm7Wge//R5j2zqNvttUsYuhPq2WUaf8VZmH52OalB
	72LyXD/J8sshfqRXSRrbfRQjs4ifvm8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ejt4fl24yJGg/IPMEl6Jv4QbwGGu9SxvkwuaJgTIHGU=; b=b7ZiARlsXX25ihUCbHGLFmeHdR
	trT2w4kGJe2ey5Dqhi0wkt8c5JQ2I1n6/+6raFF0v/sfQAOTyxcPASnmVgkIm0rPmi3ha6gZU1KyO
	imUU9sU1zgY6jfWzzVZxpU7k5Spiz4HrGK9jCVUYKOKOssBPBX2i35AFt2tq27VaaCJIL9n9q9a3Y
	V7V9La4+LPVZxQxZaTolRTOJlNJ6TfahCZNm4Cw9iT3251v64mUsk8/+kVEQ8+0XGbAf42WwORi3j
	sWGFexDVmSfPMrWJl781rZ4AvY2okDsgDJwwzn+q0MVqnFCYKYZbh4oqpBuDmKVeoucNv1YqYNkkt
	eVzl8k/w==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdTQd-0000000DPqp-1SFY;
	Wed, 07 Jan 2026 13:18:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0DCA830057E; Wed, 07 Jan 2026 14:18:22 +0100 (CET)
Date: Wed, 7 Jan 2026 14:18:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
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
Message-ID: <20260107131822.GD3707837@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <87y0m9har9.fsf@t14s.mail-host-address-is-not-set>
 <QViERQV7XT0BjTfSSyP6vzQc4AYxosyF5TEZ5kRu8AVWjmGCP_5n5V2AV2hjqVza8-jvzyquH3JLJA1zvbRD9w==@protonmail.internalid>
 <20260107123528.GF2393663@noisy.programming.kicks-ass.net>
 <87sechh8id.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sechh8id.fsf@t14s.mail-host-address-is-not-set>
X-Rspamd-Queue-Id: 25BB120005
X-Rspamd-Server: rspam03
X-Stat-Signature: anh8ffu3uqjb77ee4nu5ct7s3yoqrayn
X-Rspam-User: 
X-HE-Tag: 1767791908-608944
X-HE-Meta: U2FsdGVkX1+EQFTNPgvoQy2UU8hiFFwIzRWxv0sulFmQlYaSq/6hcyvfObwhEUUedl1NoL2SRPdKoxvuuiULU4CSwIFHpgv3rDAM+CmfWhpo4naFL1wGT+advn6P/1jNxbTdk+zQkQLmKiVM0eEWvDmVwwUzBA10tvJQDi+kaImUPgF++oZ7h1pRrFjaFVnB+tQZxNEJVoJplwKlx6Qk86jBb8HzVKBswDzNCVsUfForm7L5sRGdiMhtXeFQgkJXjMtB4wOa0YXR/iRp5JXEqxn94ou6HuNeNhIR91+MYEhwC3Jbo1/PVzzCtgA61pfuWC8l3Wja4hX98baBikk+18rk+i4XL74pqywScQRiHxZ+FfuuMs30kuIHsxFhy9WlXD2T2F8OCZJc21TgLHz+jJlT7Gvg60F9lBUv+2GxcJGbCCxmh3cACc0w71819yxYadrGKDIwNVNejpZxF64hPf3cekvfwmmavPrWJkfqD0ubilmpT7ITUuDuNz2RD8BDpePOXkynLJhZFpn6iskYz6etNFE8zOcBBoLHpjDj7+hAjWMpGG90k4Ir1Vdzt0BBeYu5/rN+rsK9ih+utwOPsQef3jVNAkwNtRLkY2u+KM323a7xB3bURNSQB8/dROH1pedjf9sFLF6CMJNewTBl8vmJgPHdOVwJPBRJZhiVZVY6bHn7hHwh2APm23irb8jaTnTFhVAfkJev9BZ642YCjRebc9Y4XKZZfjein17hh12PiH8MvGeybWMLxAG2n5VUHZaNac8RwEdLWPFzEZZ6nidVomJLvkh0l4mRo+Reh/df5oyJZWlCtPCJq0+NhCSzw3sUW5de1K5yirnw1Kzp0tr9N15BDja89E8W6DmEr08z5Ejmbt0/wjrpjrpHf9geWuynB7wJAJOpcm4FO/1oE4eRfn+aQ35ZBQyQoBP0q3W859zf+gHrGe7GSzS7t/JHtCk1Ya3l60ngnEC12G9
 yGCwf6uP
 u56yxAnPXMTRAi6hibxem5XtkTT5/HRMX4tmPwcpeqJCWs0+qBq9NXBgyhI/3XerCcB5Sw4LABVg8rFcuNt+gzQnoTyT4rM/uXzPSDE4Rs5SFxUqkuFAvbAz9JzPcRnCPmOxuZ+qwGX2zQD4P1uIfY1ZDlivXUEzPJCUS0rIyYo8SxE9l5rN78TZzwrFn0maDWi4O8n92vtJ3hKhBa9MLQlNEKClFFEXw9KbOWKJWCzneFmmwiIBzzQq6B9BJURQitUDeXdXtmVF0xGRgmNDmsoo6zBD2+w/UotGxHLurJCTgG69G/MUoRBzbrApCYIddhoRwysm53b0FHwJUmIkBEJ9P1Akwmy9xoDSnHo343OzihHxStuteO7T7K8Y4jF+67c/8sQvawFjynf8UG0oLhQzO8eTAiYe5Zz3P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:12:10PM +0100, Andreas Hindborg wrote:
> "Peter Zijlstra" <peterz@infradead.org> writes:
> 
> > On Wed, Jan 07, 2026 at 01:23:38PM +0100, Andreas Hindborg wrote:
> >> Hi Alice,
> >>
> >> Alice Ryhl <aliceryhl@google.com> writes:
> >>
> >> > Currently the only way for Rust code to call a static inline function is
> >> > to go through a helper in rust/helpers/. This introduces performance
> >> > costs due to additional function calls and also clutters backtraces and
> >> > flame graphs with helper symbols.
> >> >
> >> > To get rid of these helper symbols, provide functionality to inline
> >> > helpers into Rust using llvm-link. This option complements full LTO, by
> >> > being much cheaper and avoiding incompatibility with BTF.
> >> >
> >> > I ran a microbenchmark showing the benefit of this. All the benchmark
> >> > does is call refcount_inc() in a loop. This was chosen since refcounting
> >> > is quite hot in Binder. The results are that Rust spends 6.35 ns per
> >> > call vs 5.73 ns per call in C. When enabling this option, the two
> >> > languages become equally fast, and disassembly confirms the exact same
> >> > machine code is used (in particular there is no call to
> >> > rust_helper_refcount_inc). Benchmarking Binder also results in an
> >> > improvement from this change.
> >> >
> >> > This patch is complementary to:
> >> > https://lore.kernel.org/all/20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com/
> >> >
> >> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> >>
> >> I get the following modpost errors when building with this applied on top
> >> of v6.19-rc4:
> >>
> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/drm/nova/nova.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/nova-core/nova_core.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/block/rnull/rnull_mod.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_minimal.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_misc_device.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_print.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_dma.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_pci.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_platform.ko] undefined!
> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_faux.ko] undefined!
> >
> > Looks like it used the wrong static_call_mod() version, was MODULE
> > defined?
> 
> CONFIG_MODULES=y, yes
> 
> I built without the patch first, then applied the series, enabled the
> option via menuconfig and ran the build. I thought maybe some dependency
> check is messed up so I retried the build from a clean state. Same
> result.

No, I mean -DMODULE. Note how the quiet_cmd_bindgen target has -DMODULE,
but the new quiet_cmd_rust_helper target does not.


