Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A12FECCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 23:51:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C868E000D; Sun,  2 Nov 2025 18:51:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D408E0002; Sun,  2 Nov 2025 18:51:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453D18E000D; Sun,  2 Nov 2025 18:51:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26F4F8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 18:51:20 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F3B44ACE4
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 23:51:19 +0000 (UTC)
X-FDA: 84067315878.16.84873BB
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 90AAA40009
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 23:51:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=none (imf12.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762127478; a=rsa-sha256;
	cv=none;
	b=b7Evhq7iS7Q5TBxX5fI0Px5mHb6+3tanbnLPG+DKT3YwhiWMa84WAwOyfLUNc48yPMYQFh
	SOZHf4olALBpbl6aBivz1IyLYlm4YjCFKqGw1XtKMbWvnQUvzLMedcGM5RK8AvBxE2dV08
	Z4vkRtS0zKOqL9um/swJ7W31mVqIZF0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=none (imf12.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762127478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIf2hY7FwaBY2+Fr7FY6ebpj6s2G4BBXggRzToDgqkg=;
	b=b7H552hyhc4hfEueqAqePOuRryG4zd+bFoAoMwBmEb/WrluZleQ0sLNkRafaML4aA1Ved9
	e2Hfp0um85IQjJ0Hh3ZjHEAsYgvsqcQqAOy9ERKhzg/V78AQKh0poGe7wW2kcfxPg6fzbq
	WJ3dCKOELBsJryb4L8DQHa0opTgT1nY=
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id DDB6592009D; Mon,  3 Nov 2025 00:51:12 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id CF26F92009B;
	Sun,  2 Nov 2025 23:51:12 +0000 (GMT)
Date: Sun, 2 Nov 2025 23:51:12 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Paul Walmsley <pjw@kernel.org>
cc: Deepak Gupta <debug@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>, 
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
    =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
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
    rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>
Subject: Re: [PATCH v22 10/28] riscv/mm: Implement map_shadow_stack()
 syscall
In-Reply-To: <020e2f6e-9c1b-648e-3017-31eb8a89c493@kernel.org>
Message-ID: <alpine.DEB.2.21.2511022341110.1185@angie.orcam.me.uk>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com> <20251023-v5_user_cfi_series-v22-10-1935270f7636@rivosinc.com> <020e2f6e-9c1b-648e-3017-31eb8a89c493@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 4kj3gfq4zcd573jhwx4s3zmn3txp3368
X-Rspamd-Queue-Id: 90AAA40009
X-Rspamd-Server: rspam09
X-HE-Tag: 1762127477-678585
X-HE-Meta: U2FsdGVkX1+qlSKZKzi3drUVu2UvC2g0Vx8c8yL2URpISCqbgp9XW8e9CWj7s7Y2bqNi9dB1H+oXwaEdrn7ccK7btF1gXUqQ10Kn5Dlsy6dbfYInrk1VA5Sv5Bx3NEVV62qF5wWWgtCRTwvc77jfAcbxQ4S54wKWsaZpwrB2D7QeFxw6o5S3PsU7VS2pwJq5R/S8DtIfEh75/ZSBkc9WLpfo0v9+krHHs69sS4G6p3r1cRGdayb3ua9q7+J0lGCYAkOpKuLZBDNvTQa2HAfgL/A+xbdf6/EebZMpNSMWysyiOET+qzbZPfcR4+oE4h/5N5T6ngEUFLYwdWp0FdwPSuhjfruiZ9zxb5muNdK28fTglTpwggof24Eea3i02jvL17X3rnMcCGXrI4qSMU2R+MHKjK8RJWo4G/++chmg9PutyEBDu6AyEXkICO0W3OQ5CwmSCLUZKkipeprmdqnq5e0uXoziH6GM8IuTQNVumyhswOz6bN2pbkGnP4SQBhKDAW3cAZODSooBVQA83qdza8zlQHp0PkxJmEddEDmLUCkauqJYH3iIw/VwYYZxGElIPHv0RWBpYNvU1MHffRTLi4tO5+fq7WLelsFpdpSVph4M1qUoFLJCkPm1qV41D1gsWZKz0T6hzQNtOcAhLoICdsjPM7k9XaaoLaQ1FqTBWb9iBsBeO1nkJUo13eBMP0YdfBSH7HDSdeizdH6Cc4suB4GCxAcvQNYuVaX84wjrvqButfVqUqfERlZwBHGw4APNQAWSJCrbyZE8ssyrqIiZegV/AyHMrhvauXXEf4bemXbU4ldEhyIN5ZAT6RFyUEsjQfnh4pramosthGo9mY6tDDMyVz/ALgh9G1qPz/yaD+sU5kyJhAJxRZJIbL3ioaPLIvJ+SXTOfMyp8DppSNcOR3c+b8PtywMU1mT3OdS/LvP+dbllY+FoVuofHgdS2Vixb4Lv2rU3H8dJ1/hcDk2
 zlc20bzF
 VA8tgr6fl50ZxkAddEcC3Ug+ZjO1dT79euKN3SG2Z/joAhXoC98+iLP2/IxS6An43Xvzs2mVANAYd0UUkA9o/GeN06GJF7ooY6sT764X9Aj3DPmRhrm5vZqCBw/+z3bHblbPqGLBuoqY14u0/wIxTQ5RgmLNnSIWk28IRAvWPkC5TkdCo6oWTzZ9tl4YEMtTDdB6XoUYDqbe8NmJGyCVBk5aH7UnZP/LL6u2AkW/oLxCaBpYV75deNwz0IK0wbcibcJAGu2ato+Cf/Vea6iU5tvAhaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Oct 2025, Paul Walmsley wrote:

> This patch introduces a 'checkpatch.pl --strict' message:
> 
> CHECK: Lines should not end with a '('
> #78: FILE: arch/riscv/kernel/usercfi.c:36:
> +	asm goto(
> 
> I'll fix it up here in the event that v22 goes in, but please do the same 
> on your side in case a new version is needed.

 I think this warning is silly for `asm' statements.  It's been common for 
decades to do this to format multi-line `asm' statements, just because it 
makes them so much more readable.  We have roughly two thousand instances 
in our tree already and I would use this style for new code in the parts I 
maintain as well.

 Now having trailing `);' on a separate line is another matter.

  Maciej

