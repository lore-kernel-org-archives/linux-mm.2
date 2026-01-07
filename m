Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 014E4CFD62A
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 13:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC106B0092; Wed,  7 Jan 2026 08:40:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69D86B0093; Wed,  7 Jan 2026 08:40:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D421A6B0095; Wed,  7 Jan 2026 08:40:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C13076B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:40:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69A688B5BF
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:40:18 +0000 (UTC)
X-FDA: 84305276916.21.01B0C59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EBAF38000D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 13:40:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diRQGJsv;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767793217; a=rsa-sha256;
	cv=none;
	b=KFUQPejYdIQXUvsfyHW+UxzPEJb+iDi76jr/JNrlgsXjt4W069RFsj90Ay7bq+g6NkZsqX
	HhhDE4+Ls9PZ623rfFhJZBWN/7glAA/PWlpikom9UDDS5xc4D4j9KXvzFQwyaEzuJUyAV2
	9vpE4k6uBBCKdi/pI8+RyO8BBTHzX1o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=diRQGJsv;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767793217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29sqabfcqsi5EoST1wifog62Bx31GKw74B5QewPDne8=;
	b=6vCmlLysZb/Cp+BH8pKDnBGiCkvXd8uXbelMSc1EK9U/nYVVkrIMedM23VTG3q4Ev/qWl+
	HhsSJvKotBjoU47oNOIH1xWVy1IEesgUBo1kADIGZlGZwJsJOWYenn7qvYqJqi/GRB1gkM
	9ubM9zRvm5d8rqRqIoxD+tdUAN04fag=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4338360007;
	Wed,  7 Jan 2026 13:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16811C19422;
	Wed,  7 Jan 2026 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767793216;
	bh=bkmcM2Tj+34ZMJvuxts6z25Z9OzVU2xOhSRLpeYYIkQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=diRQGJsvp5HsGoG+0YkZ3zhXz9oXYZYA7RFEYuNAaEdA/crlPfbp6TrLhzw8YKTJ2
	 uADNq5sebRFRHGYRsahgEcf8hT9x5a+SXEcivckPucM6V6qqbSe2dhj8WWaztyl4p0
	 5Qxcfq8kISRzJDpCftu37FcGy17tYlvNTVPcDXio6IiAgs/4jD9KgjJyI5n0GnIVch
	 ujhL55zrpwLqhWi7ElfVQcdp3YJ/AzPFIgAN4rbtaYZAga/U0jvvjQEfcJYV9e19l7
	 m5C449W7qboRqkSOZKetJDjzNQg5c3cvcNCVlivDUw/uEURByXNrgsblI4cw/vRAw4
	 0tnDNdL2tAQlw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Alexandre
 Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Nathan
 Chancellor <nathan@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Nicolas Schier
 <nicolas.schier@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
 nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH 0/4] Inline helpers into Rust without full LTO
In-Reply-To: <20260107131822.GD3707837@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <87y0m9har9.fsf@t14s.mail-host-address-is-not-set>
 <QViERQV7XT0BjTfSSyP6vzQc4AYxosyF5TEZ5kRu8AVWjmGCP_5n5V2AV2hjqVza8-jvzyquH3JLJA1zvbRD9w==@protonmail.internalid>
 <20260107123528.GF2393663@noisy.programming.kicks-ass.net>
 <87sechh8id.fsf@t14s.mail-host-address-is-not-set>
 <un386uEr3TEFzLpGCdZg_Tzm63zO7Ze6IZN16Cz79EfWmEI_hZXbBvhG2enZmUXJ6DUnCMNm7QIz-agEYIDr9A==@protonmail.internalid>
 <20260107131822.GD3707837@noisy.programming.kicks-ass.net>
Date: Wed, 07 Jan 2026 14:40:04 +0100
Message-ID: <87pl7lh77v.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: EBAF38000D
X-Rspamd-Server: rspam04
X-Stat-Signature: 1sf6p96orn51fbp95p4nsh86irh7mchg
X-HE-Tag: 1767793216-102998
X-HE-Meta: U2FsdGVkX1/iQICqsx70YWQ7oCxD+7EjGTHJA5OwnK3LEq4LXcmOpDkSrrjxCGvF99lCQ68zynntTufxqpOVTHLjgIwMQ3vNmejEP1pJhK79GKD+NODj5+RUU2LEj+Nsa/sKA3TDVdUwOdWBGSCCRyuXyBaNKGar6WXna5rMPdDlc/yNrt7RMH2AlBmG+q9onCxRt3aAv5u1J1czioYJ/GlARCe3BBFnbNSryyi0AKpA4r2YAyW6aWFFgr3ulCCwUe8S6j+4kHLC5CTaNKsVeRrS4rd11hRMToBG51KD/kqGzbDWN7jxBChNMOlvFuSKWZ+Q2EF391xVzKZiGHna2Zk1EIuATv2m+mSYyRHhNQx0125jardu3t5eijO2ZKHqMKEKEWfht8Ios7zc6eEDzL4U5Z7u+W4QGsOtv1lAj+F4YVmhgCswdeIV86ovGGzckLkfKMvx0Qwsnl3sFf8GhGxLyyk9pH0sY40snlztBkpRdKMZ4N2/t/VKVSrga1UoZGDdtcyyCAvEcxAixrqzzUmGvcUbOZPB+yOO2DCa97gZeHLTQdJBapB9fF5Nt3MiCnRYtulMU9AQK1k2HXSIjFlTQ0T8ZNqffw3MG3qPzRuoJN4nE8FtnyDgofLK6ME4NPFV48EoJ70fHkzYPts2weemsOyFhfK47yqIZRhvHCwseuz5miw7nmoiYTx5UIJLPswWKZiOE68P0rk14nJPOG68v/kK72W6Z/48S/t1R7MDMztbsTFU29J6y8++3Nia0Null9V07XNeUMrR/yECyKEjyvVW3dEHYi95FQprD7ITP0mBlpuYp9nIZ9tXyQ6kRKW827JbghEoA2nvpZgtMu2c/Rm6Mo6f5OlyS17L+PVzAqkS4seWbW+mxROgLgtT99FIrMQtq7MbfFdnEofMj7eP1GU0h4AKM5yLikc+vok4bfiA0Xv0jytz90cgzvkW8kW4N8JpcSDDGCAFLSS
 Zvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Peter Zijlstra" <peterz@infradead.org> writes:

> On Wed, Jan 07, 2026 at 02:12:10PM +0100, Andreas Hindborg wrote:
>> "Peter Zijlstra" <peterz@infradead.org> writes:
>>
>> > On Wed, Jan 07, 2026 at 01:23:38PM +0100, Andreas Hindborg wrote:
>> >> Hi Alice,
>> >>
>> >> Alice Ryhl <aliceryhl@google.com> writes:
>> >>
>> >> > Currently the only way for Rust code to call a static inline function is
>> >> > to go through a helper in rust/helpers/. This introduces performance
>> >> > costs due to additional function calls and also clutters backtraces and
>> >> > flame graphs with helper symbols.
>> >> >
>> >> > To get rid of these helper symbols, provide functionality to inline
>> >> > helpers into Rust using llvm-link. This option complements full LTO, by
>> >> > being much cheaper and avoiding incompatibility with BTF.
>> >> >
>> >> > I ran a microbenchmark showing the benefit of this. All the benchmark
>> >> > does is call refcount_inc() in a loop. This was chosen since refcounting
>> >> > is quite hot in Binder. The results are that Rust spends 6.35 ns per
>> >> > call vs 5.73 ns per call in C. When enabling this option, the two
>> >> > languages become equally fast, and disassembly confirms the exact same
>> >> > machine code is used (in particular there is no call to
>> >> > rust_helper_refcount_inc). Benchmarking Binder also results in an
>> >> > improvement from this change.
>> >> >
>> >> > This patch is complementary to:
>> >> > https://lore.kernel.org/all/20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com/
>> >> >
>> >> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> >>
>> >> I get the following modpost errors when building with this applied on top
>> >> of v6.19-rc4:
>> >>
>> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/drm/nova/nova.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/nova-core/nova_core.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [drivers/block/rnull/rnull_mod.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_minimal.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_misc_device.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_print.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_dma.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_pci.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_platform.ko] undefined!
>> >> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_faux.ko] undefined!
>> >
>> > Looks like it used the wrong static_call_mod() version, was MODULE
>> > defined?
>>
>> CONFIG_MODULES=y, yes
>>
>> I built without the patch first, then applied the series, enabled the
>> option via menuconfig and ran the build. I thought maybe some dependency
>> check is messed up so I retried the build from a clean state. Same
>> result.
>
> No, I mean -DMODULE. Note how the quiet_cmd_bindgen target has -DMODULE,
> but the new quiet_cmd_rust_helper target does not.

Ah, that did the trick, thanks!

  diff --git a/rust/Makefile b/rust/Makefile
  index 5365d53b6cf96..08d3dc1038cf5 100644
  --- a/rust/Makefile
  +++ b/rust/Makefile
  @@ -483,7 +483,7 @@ $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers/helpers.c FORCE

  quiet_cmd_rust_helper = HELPER  $@
        cmd_rust_helper = \
  -	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) -c -g0 $< -emit-llvm -o $@
  +	$(CC) $(filter-out $(CFLAGS_REMOVE_helpers/helpers.o), $(c_flags)) -DMODULE -c -g0 $< -emit-llvm -o $@

  $(obj)/helpers/helpers.bc: $(obj)/helpers/helpers.c FORCE
    +$(call if_changed_dep,rust_helper)

Is -DMOUDLE always appropriate to pass to the helpers? The helpers are
also inlined into non module code.

Best regards,
Andreas Hindborg



