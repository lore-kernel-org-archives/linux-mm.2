Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D692DCE7B15
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 14:48:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27ED78E0008; Fri, 14 Nov 2025 09:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22F0A8E0002; Fri, 14 Nov 2025 09:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E648E0008; Fri, 14 Nov 2025 09:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDF778E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:48:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D99512E03F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:48:37 +0000 (UTC)
X-FDA: 84109493874.24.5C48015
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D35501C000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:48:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+e2gG9P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763131716; a=rsa-sha256;
	cv=none;
	b=ABQUmCx79+V8u7yQdvOpA8gwMaPYSFjC5Jk2aHOpe6/cdnET9UhjoCrz3/eu56cTXv2oiE
	DPqL3cHEdD1L3b6fayjIgkpiwpg3hSLCyjyXkCOqfnG2C/FB5MtNWSYORdIa7uBEnWb0Le
	d3ri9Wr/lgBwzQu65sMoeVXhj04Spc4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+e2gG9P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763131716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GURwzyayOj0sjEJsft+c63FAfwa0IlafiwYaGP7XDkE=;
	b=56lV8mYK8TSY5wdcTbK5l0EMFHjzt9Mc8csWrjrfKeQwLDwvaDlEni0z3E/dYjHDmgeuVl
	ohwTnAgNeenEvHMyVixzWY/3xwU80C2x0uVQg6ZYDtOaPJF9D94XY9ESAAqfVcJUQzETfg
	/vuwZ349JjTMKxqdpjM5h9MBHYhkBtY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D624540845;
	Fri, 14 Nov 2025 14:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32328C4CEF8;
	Fri, 14 Nov 2025 14:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763131714;
	bh=xWikcpGmf0wHK8yffg5D29GO53o5QMoIYZYCMXioG+s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=J+e2gG9PoTt8mz/HpWhw2WDLYzf0kgc3hIOjqvveYJScGr1q9ipcdK3TC10KuemQ4
	 IxrHunzT8MZeZlmsFFuryAwCautm0lpWXhqb/6ekOGxkg6FeccVdhXhHCj+27SE+ZH
	 9bhEQXOuGz3aUfAF2bZ5BBkS2s6Yj+KjzoWshNBYB1tEfUDOLffotGA/lUbEXL6XxB
	 NrE05Bi8Dl1+Tf3COS25ciOFyH/llzPkL2UflN9wM7OMj2tKPavSrkgml9+qb8MdCC
	 oLWA5sjY15Jxor7EhQbEbrYH75sSjn5LoP+4saCRf2ozwm/dtMPgvDInorpAkh8BpG
	 eqmHiqHbqpvYQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Mitchell Levy <levymitchell0@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Andrew Morton <akpm@linux-foundation.org>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph
 Lameter <cl@linux.com>, Danilo Krummrich <dakr@kernel.org>, Benno Lossin
 <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>, Viresh Kumar
 <viresh.kumar@linaro.org>
Cc: Tyler Hicks <code@tyhicks.com>, Allen Pais <apais@linux.microsoft.com>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-mm@kvack.org, Mitchell Levy <levymitchell0@gmail.com>
Subject: Re: [PATCH v4 4/9] rust: percpu: introduce a rust API for static
 per-CPU variables
In-Reply-To: <20251105-rust-percpu-v4-4-984b1470adcb@gmail.com>
References: <20251105-rust-percpu-v4-0-984b1470adcb@gmail.com>
 <qnTNWVjAt09EBrHCcZZF0dT5c1s-R5ZYEgxKh7CZq2g9AmrNPsE3I3AtGhovYr8iASOQid3fKrmCgwyEb-2_lA==@protonmail.internalid>
 <20251105-rust-percpu-v4-4-984b1470adcb@gmail.com>
Date: Fri, 14 Nov 2025 15:48:05 +0100
Message-ID: <87pl9k3c2i.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D35501C000C
X-Stat-Signature: 4i7th3umkz4rmea6nzygs1xs9sxt6ntp
X-Rspam-User: 
X-HE-Tag: 1763131715-937353
X-HE-Meta: U2FsdGVkX1+aRvM3eTm6t5/kwjz9cVszUHisbwI57dc2Wmx+gL5KrjpQvSKffqhjagi52gsaurvd5PJo/gFW0ihC+qWgdgojwJscOIOu30M2GDoeZudBak6QlQsL/zuEPs7zpY20XeExTjnjMqakw/KlG58YgezB1W5611fSTgxiCMvPhi6aMExoy1GPVUG2gdBqbKK6n7mpI2kf5l32cPotfat8sGTwhPCnod1G/Lj1spqkbCXq/arSS1NB6hPP4MYcvUiqAJnblN0RnG2+IdH6md6KdIVrU2Ur9m1UnMhGBQ96OzjxdUuUFqNVLUfx5+qwYXLJ9q7k3Ie7SPcGrZ2Ltzx6C9FzzX6oUt8xJkB2ZrRAldJXQcor91D2LwQD1mwwGTTkP/LAQxNGgA/3SpQnayhLP2SiX/UMHR3tDY44FfYC/pqWOoKGuEkrOaXFqP/A9r3yQhAe419hf1gRFtwlpqPg67xdpgeu+Q6UayvrBhWepdc9JdWgXEt1ZOvp8R7PiHmK6zX3ZqTCu1YRyH+vJaf5CaCA5l2VD/1oxg3Laby12WrSSmJbn4vVUC3/zahy/oDpi7Na3r+iJtYGVKLidfnLYBOcF9O7zU1K2O7eDwAKx3dPhn2nF94qZzlKcEbn6sJOjcF6tSKHdWDIpspQPBtvtfhKWLY3OwZLOIJSVkRwleBEbnGcl0rMJAvef4dTeGSDMjOQy5av0oh3CnatV2xdZRZdkJinRyYW7cwilZpZcldaBaJWvG9QSN1Za8e7kQD04rxW1B86XV27DznCdOqymSnHK+Zypu0WxHMZz0e52w9C8b3iRoIj7dltdQ8mEuqrGIiLsTrM2/rP1GUYiDcyWL5UGS+dbDrDHW+barELBQDv6JlflSdfLC5+PAOvK7m+Ck/J0/opIoVJP5aS3HgpPMYmInlKuBBQd4d2xR7G2Kz0KW/zx8sSTLNTVPcsbe6qLk11dGMKqF4
 MDhcZRsu
 1IH7Z7nsJlpDRJ9SicvmQCFuJjGCeJgyuAY5AizyARXbUDvA+rRk8XpuNk1sd6zBQ49aMC9/NACWILpbrGNdZWLEJOafrw5uGJiWxT5PW2kvhVB7p63yyPM85AqTIGJaTT6xt1BieJYwiG/Q7ISx0oTrJN/K81I4BNH/nkWt50S+pKoxOQGQ0n/ALlIx9tz1rXn9iBg3zm5FWKOCmx59/+8UB9sQcrbPsz8DH89S5paidOmOUkZioIs2cG0nLuU1SVxxVqSyVQcdFND6vLJWho5N6RXonHcDFNUyw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mitchell,

"Mitchell Levy" <levymitchell0@gmail.com> writes:

> Per-CPU variables are an important tool for reducing lock contention,
> especially in systems with many processors. They also provide a
> convenient way to handle data that are logically associated with a
> particular CPU (e.g., the currently running task).
>
> Therefore, add a Rust API to make use of statically-allocated per-CPU
> variables. Add a RAII `CpuGuard` type for disabling CPU preemption.
> Introduce unifying abstractions that can be reused for a Rust API for
> dynamically-allocated per-CPU variables.
>
> Co-developed-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>

I had to do the following change to make the doctests build when
applying to v6.18-rc5:

commit 47fc7e30ab0fbcc7262b846286b4bae5124d858e
Author: Andreas Hindborg <a.hindborg@kernel.org>
Date:   Fri Nov 14 15:43:47 2025 +0100

    fixup! LIST: [PATCH v4 4/9] rust: percpu: introduce a rust API for static per-CPU variables

diff --git a/rust/kernel/percpu/static_.rs b/rust/kernel/percpu/static_.rs
index 418fc2fa06f20..bf053e260f0c5 100644
--- a/rust/kernel/percpu/static_.rs
+++ b/rust/kernel/percpu/static_.rs
@@ -162,7 +162,7 @@ pub unsafe trait PerCpuSyncMarkerType {
 /// # Example
 /// ```
 /// use kernel::define_per_cpu;
-/// use kernel::percpu::StaticPerCpuSymbol;
+/// use kernel::percpu::{PerCpuSyncMarkerType, StaticPerCpuSymbol};
 ///
 /// define_per_cpu!(pub MY_PERCPU: u64 = 0);
 /// ```



Best regards,
Andreas Hindborg



