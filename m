Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC504D358E5
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371086B0088; Thu, 29 Jan 2026 03:42:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F43F6B0089; Thu, 29 Jan 2026 03:42:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2008F6B008A; Thu, 29 Jan 2026 03:42:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCA26B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:42:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA3B216095A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:42:41 +0000 (UTC)
X-FDA: 84384360522.05.24B70C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3389640002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:42:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WPGl94Lh;
	spf=pass (imf12.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769676160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sMdD4LH4lYD68ZQsgvC4Mnrtcefh8C9M3ruYdvsXKg=;
	b=wmrU8tgkBsbdjXJIwLLcPxOfjCFXnmIwa3aPPI1vrxBdqFWP2pF1F5o/9t4+sXKVZ9A7zP
	xpCPiURE/cOQuaD0/YkHOsVfALS2EQ7vQlaFmfJctFwU0HmCiCLAjWdOCU5kTcbnsTfOyE
	sIAqVZtkfWndHnyV9XgVOEjg27bF4lc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769676160; a=rsa-sha256;
	cv=none;
	b=Zi4UtGb4U6Pf8ucxyPyl0nsZrXv4PfJa3p2NEGHAl0wepP8gQVLPrc4OKj1TxT1hBZPk6j
	Y6rNG1RtUzW4BEkVVdU00fkaA508soZWhhqIl4YiqdvmM+lgdLjUDTbAYt1uv4/WnX7ipB
	GIRyz+fTVgF9KykFHv2V7bELCADAmPU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WPGl94Lh;
	spf=pass (imf12.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2321160054;
	Thu, 29 Jan 2026 08:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4C1C4CEF7;
	Thu, 29 Jan 2026 08:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769676158;
	bh=9QMEWB+yM4NRpFfl8KXrYJ8s8e6vKN8iej0DvKpGhcU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=WPGl94Lhk/NCi3lEfZ8z65ulZBNKDA6CREUcGelyPWHfzLrK37HGMuOwr6ymnAWbq
	 zMZw49VV3aaXfUo4RySMTADkUQE8+HOyxLnDUbS9p1QK1M0ZRy5dZoytzUnUWxQCiV
	 JuT7cNRWclddUiuwl9xVh/+NdZ+rP0tENaakniujZDuQet4Cq/5STEjla2SU6a7q9W
	 IS3R+R9rKQilV6AEDsD1IY1uaYb3R1j1y6rd5wzC3bsdxi84+lYX8JX2lPdhLlHGdW
	 /cUwi/rw/43gTiJJkns0weSNlVwB+8yl7oSzYqr3Zf2SXhbeJgLk9oPQYFHNifZxf3
	 yKjt2ycaK4QFQ==
Date: Thu, 29 Jan 2026 01:42:32 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
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
    richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
    kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
    evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
    samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
    rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>, 
    Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
    Valentin Haudiquet <valentin.haudiquet@canonical.com>
Subject: Re: [PATCH v26 10/28] riscv/mm: Implement map_shadow_stack()
 syscall
In-Reply-To: <aXfRPJvoSsOW8AwM@debug.ba.rivosinc.com>
Message-ID: <190df1c1-feb2-ae5d-7fdc-dd0c3d780b21@kernel.org>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com> <20251211-v5_user_cfi_series-v26-10-f0f419e81ac0@rivosinc.com> <aXfRPJvoSsOW8AwM@debug.ba.rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 3389640002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8g6o7eerbmkcn1qerusdhig3dt9c6a9d
X-HE-Tag: 1769676160-269507
X-HE-Meta: U2FsdGVkX1/DlLEf0rUX14rwy7qzCldXctDEPSANhiMmsKa7hpRCcAc+6cE/j8Df2oFdJQSvX0EA/uZfSoPGVroePnqKm4/xddHBbvOC4NHkTSZh4m+XYG++YsbU+yG3wFWIxETn0Bu+XWyuoINe7fqQPZISBsh1+DJmyTZjvOJZI8ZFPbHyjzFV/3MMdTgCOOAgbS24yCnscQWZAc7V75yz1srDluJkk3xwS7ilqy4YPvI3vPL3u6AdLJoAK4oxXDJPAf+zf0Eit26RIo2UbjFfwJLhWF7T5JMNyNfDCp01+ERWkQGfOBJC1WdYEz+2yQ4ywZeaimrT6TYqxwazPa9UM7AIiybuhZ+P78wgrllirKrErnoPHtv5/S8S7aUzaYlTD86E6Sr1m9iJg4UUwBNFE+geuAHfMA/HE8yVo8irPWIM47bRwl5reF9V7Wlz/LM2DdMGmiw4yjKrcOfQKrqxupzIi6vzXuGLOuB7IJ8Z7IqP7fDn0FkwPv+rnAU8VnVcDmU1rpcDhjAYQdrWf996OQ8vD8y8v8JdEIt6CD/lM4BUVyH4LORF+2VTJw6hOTqphwaxfrdwhiV1j67fYX14N8qCDuWjHJ8YZT6z0RB0Up3TSqYPE+VBn3bA0cWEVhI+Gdjc5SOTUelEitI5Gu4D+EOoEJ6G/CL50kZpWb9o8cvZgwHc/yBblBXdefa/S3t9XIhIaAzgIf1z7RrIRS0SoGMkZkxqFPJI3ukFyQK8pZ2HmUy1kVrhMKQTLdm9ZwCpWWLjGLQSJhfqJw6WVcB+tqLggfpJcrPnaQRZ4Yh6n2UVBDdYviCDrEJv1G7YugDM25iLAUGE8ZL6xHBOkE/UFYzUHg1+2zN1CogSz27tWfJoVdOV/l7yolcSQh6tiBKG1UbGRmFLw0tVwTZWago0B5cJtwiLC8e3sclRwmOMsTervwIlTKUM6N93BlkNqumtC2JVnrfahQnTLQt
 D7bueI4J
 zkx68vlc/4WT/aaAAY5wGpGVL8bzhHbAuUw4ozX2oqSWsHNmHFpnbJ+u7OFgPyNQODN/W2ej8aev6/TpPhEJx5xtmPzbprl5xb+pAcAJFqzPhkccvZuk7wULLeJ55FMCJprSVL2DLYor2wRhBQf4/uM/PlR50hYwA32VOZamIcSKbMNAe1Awupl470U3e5v0XjpSVY7PCZGi/+Aadl7wLBheY51WZH+w8ShSBQataW8QNw6KBxx3KB2HQ5egjvDIF+xnz5/NjshYiKGST7vz+8gPT1n7peqEeDzlLuQY1qEvOEl3HzkwSPW8Np8tP4SG/ahonSCCtvR9v2mi4KCzynEtKhPJqIdRXIuy6ouFto3lXYkvgHnkLtvzeQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, 

On Mon, 26 Jan 2026, Deepak Gupta wrote:

> Can you apply following diff on `allocate_shadow_stack` function in this
> patch.
> This fixes the bug that I earlier mentioned. We shouldn't be returning
> location
> to token and instead return base address of shadow stack. Userspace consumer
> should be determining token location itself. This matches the ABI of other
> arches. Sorry for being late on this.
> 
> diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
> index 27b36034ea85..a8530e6afb1e 100644
> --- a/arch/riscv/kernel/usercfi.c
> +++ b/arch/riscv/kernel/usercfi.c
> @@ -232,7 +232,7 @@ static unsigned long allocate_shadow_stack(unsigned long
> addr, unsigned long siz
>  {
>         int flags = MAP_ANONYMOUS | MAP_PRIVATE;
>         struct mm_struct *mm = current->mm;
> -       unsigned long populate, tok_loc = 0;
> +       unsigned long populate;
> 
>         if (addr)
>                 flags |= MAP_FIXED_NOREPLACE;
> @@ -245,13 +245,11 @@ static unsigned long allocate_shadow_stack(unsigned long
> addr, unsigned long siz
>         if (!set_tok || IS_ERR_VALUE(addr))
>                 goto out;
> 
> -       if (create_rstor_token(addr + token_offset, &tok_loc)) {
> +       if (create_rstor_token(addr + token_offset, NULL)) {
>                 vm_munmap(addr, size);
>                 return -EINVAL;
>         }
> 
> -       addr = tok_loc;
> -
>  out:
>         return addr;
>  }

Thanks, this fix has been rolled into the queued patch.  The Reviewed-by:s 
and Tested-by:s have been dropped.


- Paul

