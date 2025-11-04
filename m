Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB620CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25538E00F6; Tue,  4 Nov 2025 02:53:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD82A8E00E7; Tue,  4 Nov 2025 02:53:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C48F8E00F6; Tue,  4 Nov 2025 02:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 879B18E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:53:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FB3CB955C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:53:03 +0000 (UTC)
X-FDA: 84072158646.26.FA8DA4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9F5F3140004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:53:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j4yROKUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762242781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf91WClkVGv56YCT4Cfqj1gBCbg+MyS3l290UhFQwEs=;
	b=U8EJ+2DXul9s5Ow5+7SLuIkAf8LmTekxmniGpOx+xxPSF4x5HotpI3KbJxN+lV17M7yAIX
	IFiorWGnwnWF2ZZIRUGL0uv2vQarRQEZQKGtjCU/HIuBFLNQRdUcb59UgCpSWtwEuf30ld
	8K8YZlCkVCxi2K0yBsD92Qu0hnTF1Qw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762242781; a=rsa-sha256;
	cv=none;
	b=5futIWDIMTaiVLGlc2cRcXD6CGtUxpkwgWiw8+LaObSiV1Yc6+RjdSSnGbLOUieWz38TtJ
	AQHiYd4p4G9SIofts+aHMPV4fjr2aGuW2CRJhSNixAn8nV016ARO5ifRD6ExXR9M4HY2BX
	oqhO05E5Hc+EtvwyBqtIDus/+ReySBQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j4yROKUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C9DC9600B0;
	Tue,  4 Nov 2025 07:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8A2C4CEF7;
	Tue,  4 Nov 2025 07:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762242780;
	bh=lGIbceyVZgdKoxAlgrENOyuI7iqdDhBBFcc98C3lKn0=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=j4yROKUVgRxS9OZJC90/SHA8XCPDVvwVHDTgceh+mCs64FFENtqjNn3VC2cS3YHRS
	 Vh89i49TvVRT0q9eqdMJYy6UnQ4flTEkFee+vNQ+LDBtPs6JzXOg9rqYQ1l4R+DhcE
	 OKQGVXbTY9tU25yQyQP/GPDQop+9ZGgyxC6t3ereLkJQbDn6Ob5K1plMoN0NTftZxP
	 H0zc0vdg/o5PK4tKAehZQ7H8UtwncmtwY6oH+6QVwjaU8ikukGQIRaxvlWW+ISd3QU
	 to0NJLl+MiSLIdyT3IYNIGJSnGwpG80zYDO7P7ohAcYwUyIFI+7D4Iv2WyVwNsWwgM
	 89d6ggsAvvugA==
Date: Tue, 4 Nov 2025 00:52:53 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
cc: Paul Walmsley <pjw@kernel.org>, Deepak Gupta <debug@rivosinc.com>, 
    Andy Chiu <andybnac@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, 
    Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
    Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
    "H. Peter Anvin" <hpa@zytor.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
    Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    Christian Brauner <brauner@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
    Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
    Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
    Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
    Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
    Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
    =?ISO-8859-15?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
    Andreas Hindborg <a.hindborg@kernel.org>, 
    Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
    Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
    richard.henderson@linaro.org, jim.shu@sifive.com, kito.cheng@sifive.com, 
    charlie@rivosinc.com, atishp@rivosinc.com, evan@rivosinc.com, 
    cleger@rivosinc.com, alexghiti@rivosinc.com, samitolvanen@google.com, 
    broonie@kernel.org, rick.p.edgecombe@intel.com, 
    rust-for-linux@vger.kernel.org
Subject: Re: [PATCH v22 17/28] riscv/signal: save and restore of shadow stack
 for signal
In-Reply-To: <d442965b-8716-4f89-be88-bc62459af712@infradead.org>
Message-ID: <febe1a8a-a68b-1af8-a9d5-1b5f510ecab3@kernel.org>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com> <20251023-v5_user_cfi_series-v22-17-1935270f7636@rivosinc.com> <a8f469b8-5750-dfec-2390-09bad4515f99@kernel.org> <d442965b-8716-4f89-be88-bc62459af712@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 3aw85zw5gtyqp6x8uzsm55thgacxuct6
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F5F3140004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762242781-23725
X-HE-Meta: U2FsdGVkX19k01iisjzks31he/V8fUL59PKfuh68ghBEhoRD1ckEQFHIt2Srbl9VpTnn5NFA93pZAVWV3zzIEG93Sj3Flisu2tBJ/UDYSxwRswC2Z7fZJCrFjES7ntn05efbcm0jB4e7UEaoemn68bm8BEG1fJT5Ag/POcOW6X0mYLi7i/9F+zdmn9hzjZz6Q9fdixXcTivy4oy+ix5x2gBJIkDjoO2dNtE4xUVE3SAd+gZTndQ5H5nyXfu+U5wckofcOZy8o6xlnOswBVrJN1qY04NHuOd4f1PKy4FsH4ejDj+0oD5Yv2jk+Pl1bfAHYycDJJDsj0E169EoX4AKmoxdw389m96vRY4Z+2V8IYhOzrkVmJzXFLgkJaU/cpSH7JSdY0FaSSz17LdDAmGeYgb4OICrzTxvJc7s79caQtdlOzZreIBcyA7F7mus93OfeEuMrmr1M9TWUCl4NO5CV4lG5PeOEIwP81fg2/pBuGHm7D/UM+J909VfLi6RdQtLbUasDPIZ0dS2Ssl0s2zkPsvDhcePSu09S3rblHd1iS2Rq+6DvgdInIBSeJbez3IPrNmKFuNogT2AuoL6vG95JrfKlaAUqL93JjpZM79D1+lE63EBZix8IbDFfYSssAXMpjCAObmPs33oW8RkgnkBgDvF+uTbyb6T1SC2Wcj+wgRtjHZTjhQPyVJElFg0Pns23jVN62wI1ZBk2AucUszKveF2AlcZM/DBAnklJyBK7Aq0YLitYXbFg3IwyMvDDopqpcz+/XeUitpOY6NieK5uOmGs8oFExzv9bUNzzPWV/q9ZMqTs8y5slO5R+RNtgHxOIqF1nS4MfZDUx1sLeGgKLjFik/X0uFWdb44eNGGDxrBsUJwqFySby6g6mXi3yMhwd9OgwwNIjlihrMvumKw3OQgqkatfd15PTpTgzcJAQswmnBP3WjvnjA07fUuF5WQSvHx8B8svxvuRA8f+yUf
 U8bAahd3
 qto3TJ1vHLoLfj1EmlIQmQ9Rkn5JSINxSVU0y2tvavjBAQVP2X/u2t4jb9CJ9EYe88Vl/LzQvesH0b02fo3v+uiWO8LCQPFkpv8IDNnVq3KKg5C2opsILGDFHE4/0EyK4aR5jMGtk4mBvOauXKto4gdEIAyiHBpTPDlZDLuaBhIqfLSbQq5dY4DtsjVeDXTY/xcNnhy9ji+OURQxc53bf8TxIHSjQ1Vl8/qXHc+HhuruAXL/Iy59nDcVB9GuejRmOfbJ62a2BJ+eFkLk4vbGJ8yf1JViQ9vU6IMZmTLz/WAQi8d7tMPgKum2IyEAjHzUY9+eDXluMz2VRdYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Randy,

On Fri, 31 Oct 2025, Randy Dunlap wrote:

> 
> On 10/31/25 1:07 PM, Paul Walmsley wrote:
> > On Thu, 23 Oct 2025, Deepak Gupta via B4 Relay wrote:
> > 
> >> Save shadow stack pointer in sigcontext structure while delivering signal.
> >> Restore shadow stack pointer from sigcontext on sigreturn.
> 
> > This patch causes some 'checkpatch.pl --strict' messages:
> > 
> > CHECK: Comparison to NULL could be written "!saved_shstk_ptr"
> > #271: FILE: arch/riscv/kernel/usercfi.c:186:
> > +	if (saved_shstk_ptr == NULL)
> > 
> > CHECK: Lines should not end with a '('
> > #300: FILE: arch/riscv/kernel/usercfi.c:215:
> > +		pr_info_ratelimited(
> > 
> > I've fixed them up here in the event that v22 goes in, but please do the 
> > same on your side in case a new version is needed.
> 
> Is checkpatch.pl --strict the norm for arch/riscv/ ?

I run it on every patch I review.  I usually implement the formatting 
recommendations, in the interest of keeping the codebase formatted in a 
standard way across submitters.

> If there are enough arch/riscv/-specific patch expectations,
> maybe they could be documented in Documentation/process/maintainer-riscv.rst
> (a new file).

It never occurred to me as being arch/riscv specific, in the sense that, 
if --strict wasn't more broadly useful across the entire kernel tree, then 
we should just remove it from checkpatch.pl entirely.  In other words, 
probably everyone should use it.  There are false positive warnings, of 
course, including at least one with this patch set; but then again, there 
are regular false positive warnings with non-strict checkpatch (also with 
this patch set).

In any case, thanks for the suggestion, and will consider.


- Paul


