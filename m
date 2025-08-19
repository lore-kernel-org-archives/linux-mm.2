Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A6ECA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7C88E002D; Tue, 19 Aug 2025 14:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F288E000F; Tue, 19 Aug 2025 14:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCE98E002D; Tue, 19 Aug 2025 14:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C55B8E000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:02:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52918C01A6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:02:28 +0000 (UTC)
X-FDA: 83794276776.07.718A12F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9571D18000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:02:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XNCInYtI;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755626546; a=rsa-sha256;
	cv=none;
	b=fomcW/h6o8KQ4cuOvZKpXHl4TzIXFFn7/uZLJ4n2OyL9AKo1m2NbK13jgUXBTCMOy/e9ST
	6LbvagUKAHmQ2CK85BYP96kt1nOR+A1mGZeRwgEtPz6RuXn7OSrmmV8sxezp/JyKcxmGjf
	U7rJ0Bx9Nz/+4XGPrF6ZmLHkJPy6hJM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XNCInYtI;
	spf=pass (imf24.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755626546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGIDJOgINFoo9BYDC2rBfmqLidPkGt5zS3esaydb1is=;
	b=hcpHf8uzjq1/84E7EaoeUi1uo6BRY/Oxfhgk/rjJ7WQGQcsHNqbWml+y4CDF+f8kRe1XXr
	ya5aPFcuhVOp/78Y1Whp75vrwuUd1FwdsKHhyxFpaQaGQ4djw5tlwrVO35ArCqFgczoRW/
	IfzXEspIntHhhvOqNKy+I1yggarEV+I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75C72416EA;
	Tue, 19 Aug 2025 18:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E20C4CEF1;
	Tue, 19 Aug 2025 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755626545;
	bh=ak2Xhr1RaizJ7hP18FRRrylp/o33W9xGB14X86TRAXA=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=XNCInYtId3bXC20r07LGhKSEb4Xo2g9bb+CKZRKeB/ncexFguTuv543XvoIFo3YHW
	 mTn0eGDlXOsbD9ixI/YKztZGtPis3BdfO23DP6m8lkxlQtAI3X5sAjaQJqYWoHjvHz
	 Jtem84nNJfAUIdsWw4/MosFCX7FAAX+d1r8UKJWiRrQOOskyOVeL+WuQH0f8YbqLdK
	 Ki1AcOd7OCrRqOmgxqsjmQUgzqr09j2XM70Gy73jTi5ktnpJ4O3yphIFjxIeaLPmzu
	 pn4nHycxW2kiAemfoATBI5owYG/ACr3g/3T8321lXKGJfvJov3muf5upZdIOeB9SJX
	 rYaQWgIoFYLag==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 20:02:20 +0200
Message-Id: <DC6LO2MHWMQH.2L6R1C0PK0FPX@kernel.org>
Subject: Re: [PATCH] rust: alloc: add ARCH_KMALLOC_MINALIGN to bindgen
 blocklist
Cc: <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>, "Thorsten
 Leemhuis" <linux@leemhuis.info>
To: <lorenzo.stoakes@oracle.com>, <vbabka@suse.cz>,
 <Liam.Howlett@oracle.com>, <urezki@gmail.com>, <ojeda@kernel.org>,
 <alex.gaynor@gmail.com>, <boqun.feng@gmail.com>, <gary@garyguo.net>,
 <bjorn3_gh@protonmail.com>, <lossin@kernel.org>, <a.hindborg@kernel.org>,
 <aliceryhl@google.com>, <tmgross@umich.edu>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250818180923.192042-1-dakr@kernel.org>
In-Reply-To: <20250818180923.192042-1-dakr@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9571D18000F
X-Stat-Signature: em7g68r91iudr1ctir4monwojdt1pie3
X-Rspam-User: 
X-HE-Tag: 1755626546-516495
X-HE-Meta: U2FsdGVkX1+Ib/RhwLMPtVpbLsa6FAW3P8i55Yw1zuf9aD+8Ne9akITtDBXpejdWYXE5HBoGl5h6sviG0JtmUhpDakI/7EQjGJ8HmJsIccuoLon4GzxW/XW3HGMsgPm0jlnBqzVrTzOPu2W+KDMtkntxhxrRe+0UVBOnTkctIl94Bj0oONsvMt2n1GxF1H9qLyDdnD2gmXxMRCiJ/iYEMBTWEsG4pK3CTlrMvQ0e9hDBWvrGBm+ZZyLpBn96b7tJzUp+4L6iSncKnRrLshTWLbnejVa2nFV2Dq4WomwJdk6820KP2URLuip81/IThjfUhnGjNNmGB8gPltEDGHcMUE2eqfi8aG7smJTSel+k13YcnEBi+XD1XU5GCDTCYCq81KbcLl3kSH5k5NyWRUpIwLnc7cgui02EF+8wmJhJ0Eu9U+/n3XoqlmjqM4/wORlB3U3klBZGw0YkYTyumSJskVV4iGMlforXG66iCl9S6gQN0KwqtQL8CCDCJ0ALZa1NASVRCVQFJI0S/IC++QHuf9WbUBBzVfYWmaZWFDqfhyE4HLq/fgFCSThDAVRmTaugeQ0ON3cxzILKXHq2uk8EbUgOCp9R1TxjFwM16cXWMpo03WgCglAOY3nBstKA01TQnULDhBQGqHk1A0DpF1YDyL9UhUjnqyBFR0FMUpJsIGkAhtLt7TgZBLbqsmO1Et+1iIO2a8LT+qjQu2n3DrRkgy9qudPOiZfGs2xgrvMKrHN9HoxBqwIwo2e3doWDpm/Z0of1boX71rGn7r42kWkUyLE37Ytfh6pejkCWHKO2Pz4X4d9O4pL0Db6jjqPgzhn9g4M/Uchb8j4MbL6JFwDCLY/Di5HKcrpH9HBzdKYJvczcwsOknvBb/2SZ9VtqtAO0dLdXkuRf2BBXuRmS6230z7UNvAly+Qm+VfE2HoGPVtpjfo8qDAUI8g4hBAVtZJIj9QPQcs+7XJVfEnW65XW
 uuT20sss
 ao+iRQPLfeZ4tFrBFdaOuoh+BbV3HwdSizrK4Ij5hQiqVkBgxuPPdAbwCnSUQD4nC9E8sq+d1KApQiaEjiljcJeENywXb2fy7ClajUF1SNAMH/QX0sb+Wi+VamEONIVhHy4GKPFG83oC7f+ES4qFS2jSR+QVUXNk2WmFfn/7/mVepmo1n0mLzCTkOUmg/gCTTjgkhkB49VZ31ZeTMlmCiXtMO6cIx8SpluVh0XvX5HxPjuuBH0sWI3z/x6pQahAZ+6CUqYRomnW9gOxPPJlyHJ7Pp/6BKX5U4wt1EMIGf/LG48Mx9hA1thloKzdCQa1/5Rtd/Xt7PuBraooEdSxxEbHD5GgVCS2DT1fmo3SL4vNAOcNzkFmfUXzETKWTmj0jqgQQSm0A7aSt5JC8p+sPx4h88InUFSsNDyNQ7c+aYkR18dDjigOf+TgC+ZGZZqHLvDqHoRhNfM/W4V1JcBVrmUbSZARrP54obzt3E2oyiYdOtt64=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 18, 2025 at 8:08 PM CEST, Danilo Krummrich wrote:
> For some architectures, such as X86_64, ARCH_KMALLOC_MINALIGN is not
> resolvable for bindgen. E.g. due to being defined as
> __alignof__(unsigned long long).
>
> Hence, we have to create a rust helper, i.e. let the C compiler evaluate
> the expression and store it in a const.
>
> However, if for other architectures, such as arm64,
> ARCH_KMALLOC_MINALIGN does evaluate to something that can be directly
> processed by bindgen, we end up with multiple definitions of
> ARCH_KMALLOC_MINALIGN in the generated bindings.
>
> 	error[E0428]: the name `ARCH_KMALLOC_MINALIGN` is defined multiple times
> 	      --> /builddir/build/BUILD/kernel-6.17.0-build/kernel-next-20250818=
/linux-6.17.0-0.0.next.20250818.423.vanilla.fc44.aarch64/rust/bindings/bind=
ings_generated.rs:134545:1
> 	       |
> 	9622   | pub const ARCH_KMALLOC_MINALIGN: u32 =3D 8;
> 	       | ----------------------------------------- previous definition o=
f the value `ARCH_KMALLOC_MINALIGN` here
> 	...
> 	134545 | pub const ARCH_KMALLOC_MINALIGN: usize =3D 8;
> 	       | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `ARCH_KMALLOC_MINAL=
IGN` redefined here
> 	       |
> 	       =3D note: `ARCH_KMALLOC_MINALIGN` must be defined only once in th=
e value namespace of this module
>
> To fix this up, add ARCH_KMALLOC_MINALIGN to the blocklist of bindgen,
> such that we always only generate the symbol from the rust helper.
>
> Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> Closes: https://lore.kernel.org/all/8aa05f08-ef6e-4dfe-9453-beaab7b3cb98@=
leemhuis.info/
> Fixes: 1b1a946dc2b5 ("rust: alloc: specify the minimum alignment of each =
allocator")
> Signed-off-by: Danilo Krummrich <dakr@kernel.org>

Applied to alloc-next, thanks!

