Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599E5C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838686B0088; Thu,  7 Aug 2025 08:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8FB6B009A; Thu,  7 Aug 2025 08:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D78F6B00D0; Thu,  7 Aug 2025 08:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADD46B0088
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:28:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D967137352
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:28:53 +0000 (UTC)
X-FDA: 83749890546.03.75D29A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F04FA000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:28:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QfRz8/lo";
	spf=pass (imf25.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754569731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:dkim-signature;
	bh=FS8LDzpDJlqPdTLqVGQK4lqYAcLt0fX/OvZqXi8lDqQ=;
	b=ZmWo8QrHWtCXKN/0FTImbJkEjBrbCKbHiYXbS5i4uMaFFBTfFeIcqAk1XDcucfTuIdXRY0
	Mp1gZoTyXLDqfuPczukm/oORMJbyCZOMRJ4GeBWMp05snEI1jJ5evdJT/AnkPxBu7kfhWC
	SHlqRxIpMBq0R2q0ciHISdz7VwpgUx8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QfRz8/lo";
	spf=pass (imf25.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754569731; a=rsa-sha256;
	cv=none;
	b=I+guTYt0cgOO4sJELgeBkdQwgFBk8s0K/uXEkby/gbANWdRMAgzhOOFr9nPJyT2hau1KaU
	vcTvAdITNJMbgJs9IcIDMHB82mHNPIhwb1gisLZ4+7vK7B5VrE6pd3B6rYgkeyR8emmK2t
	8ySwTOr+FnMxIFiMm9zpLEvgej+E+Ac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2F4B4130B;
	Thu,  7 Aug 2025 12:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB578C4CEEB;
	Thu,  7 Aug 2025 12:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754569729;
	bh=kUH5cN8R6K2VxLTJzE/eGBwS7eFdgy3gZa8/khg7FMc=;
	h=Date:From:List-Id:To:Cc:Subject:References:In-Reply-To:From;
	b=QfRz8/lokPQVbrBLQdFUg7Zb/pO83LwtQj6QWEu50ZIIRiNZFCedBiyH1vPKdZCmn
	 sd6EpNnPi3l2PXkuxCii2LHjBXBHhb8dMe7F02R3uXDPg+W0NEArdn2LzuNZWk4n4C
	 /Sx0iu7o5KWBtcGI3LpmP5Ug+gPg6/SSSMluaZMDVq7o8iEupbbo1t+inLw6H7xOEs
	 jqbuylhW2q93qMf3JwvCe+wxRi2FEEeMt64N6gLqFXR4huwOVfenuJMDp6TjvScCLC
	 7UWGcPsoYmI5swp1B3/noAXrQ9FI+wP3dI6JCb6TOGkWKhf2Oy8Cic2ZCTYFeNZEkL
	 7GwpI5SHcfNkg==
Date: Thu, 7 Aug 2025 13:28:36 +0100
From: Mark Brown <broonie@kernel.org>
List-Id: <linux-riscv.lore.kernel.org>
To: patchwork-bot+linux-riscv@kernel.org
Cc: Deepak Gupta <debug@rivosinc.com>, linux-riscv@lists.infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
	lorenzo.stoakes@oracle.com, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, conor@kernel.org,
	robh@kernel.org, krzk+dt@kernel.org, arnd@arndb.de,
	brauner@kernel.org, peterz@infradead.org, oleg@redhat.com,
	ebiederm@xmission.com, kees@kernel.org, corbet@lwn.net,
	shuah@kernel.org, jannh@google.com, conor+dt@kernel.org,
	ojeda@kernel.org, alex.gaynor@gmail.com, boqun.feng@gmail.com,
	gary@garyguo.net, bjorn3_gh@protonmail.com, a.hindborg@kernel.org,
	aliceryhl@google.com, tmgross@umich.edu, lossin@kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
	alexghiti@rivosinc.com, samitolvanen@google.com,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	zong.li@sifive.com, david@redhat.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Message-ID: <db4eb976-693c-426c-a867-66cadd3dd7d8@sirena.org.uk>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
 <175450053775.2863135.11568399057706626223.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8Jovl+rM+g+rY2Z6"
Content-Disposition: inline
In-Reply-To: <175450053775.2863135.11568399057706626223.git-patchwork-notify@kernel.org>
X-Cookie: Real Users hate Real Programmers.
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F04FA000E
X-Rspamd-Server: rspam06
X-Stat-Signature: ozm3q1kdsg76acqno7pru144y3njridk
X-HE-Bulk: true
X-HE-Tag: 1754569731-434494
X-HE-Meta: U2FsdGVkX18sKr1J+L3M0gdqmFVIvEi7Bz047wmJv6uWuGVUj8ebYiu5zAP/QcRwCQKpGtC17cY4zzkD8EPBryYWtJALzxtQ4NGikhEWc2JgOuh1+6KpaVSvN2xpZyIzU9cdIyhiL4Yp88KM9ZXmgv55OVYcDINBbwAU6EeTUHBcscRvV2nlGcnhIdY4SQXxbKDum0zhBgVqHUn0ZfCsjsL0xIS381LuerIlOvyIJB19CqS+h3503dlgpp6/t/inblbG3R0ASZlAsW0haxY/2Nt05EbANm9oQLKeQ12Aw2gEVaFu3LYxN/2kd7uUwKrgihvTVr+SWxJrRx49yW0tES3n5bjTYK31MDUkcrCgni4Mi/nqe380mRStz58NY8DNpzJJcjuRaTlv1CEjZ4/IormqTBnGIeOpZqcEqa40gkogkFfoLEM+XE5pxzRYrP3MT5ieYspGERqgOnT6HbarmWQywRmyMehYAgBrWH0zB48QN1GcIMQ2mfi79T9nkcPsMD3sDi1EHdIGBAGct+QtNBTLHLEyDsYFInoexc9oBa/1l4M5KnQEkLZ6G8stOPi4CpkJ1itv1KaKd/aSDfh5PmTIKQBaY7UXFzMdpjPuN7e1XfZXEfug3iXvHC39eiady6CKpPPEJNGRwmQ0kPBXHmaw9ot5TE8EBWD/Vl+9b8srDaxDYjhdlvvAcJ21fcQm/QBkov3g107FwS/LuWUZno+4PiAYBGoJudIBhk1DSd7N9Jcwy7GLlJvoQRoaWbY8lRc5PDGQK7ED7B4H5qzQeTKGw084XSqzUFPdJVPVEj/2A5YTGQcfcNa5jBgM3Cw9YOwSDNZN8ePpViD1JOy8gF6WxClzIyFRuwGoJ/BulcxoKdRfOKNdUz9EYcBV9R6hxuDufFNQFlGnFJlM8f8H+FxlJsyjfqqlJk0ugLv8xXuiTwenFFEogC74i2b/8ZF4Pe+SUFn+QhSG/8mb2Bw
 mc2Gtltj
 IFEgOEi/SRlJgb2qXeHxoFBleF2cFuh4YylGTjM4OZONj0WA+LfLq2XM57m/En1mnmJ2xoclY/xYgZY20A+1ZZcUVQdK4B4qbuRiVVXw6b7XVf9IS8RqK3JU5rG4ai+8YMYh/tO9K+iEbHSuyEZkqmCKBYcffAoPDUBSEEVCA/35WX0+PzcKQgoK7QxW8X8n0J+8ts9EXmbJ+LurBj5MeyGGuud6oF6L01Ldv8z501+q6N2RMB5SD9o4trL4xfEZ/kLNNGajAXtVFA5CtULruSsfrrdbB67sBxq4LdLnAgFHGbsVdmJQDhX1ihADqKUWAFNOVAsGHw8JHT/1aQWnX5CWpF+tIhTbXom8CapxKN6umqecq/DUuOBPhP7pwaqmxrsrA3Fk0svuvAIQCahcvc2cHimwSIfwRw5seXUov15ymcBFVzVV7rBKrOfOKgll+DUT7mQgh0DWCTVfRv696M1zmah7fgqOyjIiLg8SmHYZDSbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--8Jovl+rM+g+rY2Z6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2025 at 05:15:37PM +0000, patchwork-bot+linux-riscv@kernel.org wrote:

> This series was applied to riscv/linux.git (for-next)
> by Alexandre Ghiti <alexghiti@rivosinc.com>:

>   - [v19,11/27] riscv/shstk: If needed allocate a new shadow stack on clone
>     https://git.kernel.org/riscv/c/9c72a71321a6
>   - [v19,12/27] riscv: Implements arch agnostic shadow stack prctls
>     https://git.kernel.org/riscv/c/52eff0ab5f8e

Congratulations Deepak!  Do you have an update for my clone3() shadow
stack series that I could roll in for when I repost that after the merge
window, and/or instructions for how to run this stuff for RISC-V on some
emulated platform?

--8Jovl+rM+g+rY2Z6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiUm/QACgkQJNaLcl1U
h9BDYgf/Ty4Hzzi0OZOuIjqMAO+hAw56Z5Cp+NT+3TWGYWAJtxuukMORT3mrkWI4
+lKrRIDqhecWHSZ3jeKvFjPvxTcPu/kwjG7GsseqGj7HJGoOufVlruKUj79xtdKS
4V/WwyvqakZ4h3F0zy+bCyIrkBkQNbC3TTJVey1+4t0WNSj2uK4ZXespwXt+omY7
MOsfSOj3AY1ueunPYkofK1g6VWYe4HSldfLRvwJMeUadPJ49XFhfpi41NsqdfhBB
I8rdBWPSCS47tFoalL0R2oB+Dp78k8LmZhqKIRpPwAhMHIg3sI/kBMK4neka58L2
d0MPk00RRPiLdsDKGHuaAWzwtLHXaA==
=viF/
-----END PGP SIGNATURE-----

--8Jovl+rM+g+rY2Z6--

