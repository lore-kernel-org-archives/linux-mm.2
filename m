Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAC7CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 19:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17B138E0069; Fri, 31 Oct 2025 15:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1532F8E0068; Fri, 31 Oct 2025 15:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041C28E0069; Fri, 31 Oct 2025 15:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E684A8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:22:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8621712B481
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:22:34 +0000 (UTC)
X-FDA: 84059381028.16.8789BE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC7A140006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:22:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5HDCi2R;
	spf=pass (imf27.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761938553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2LEFnR2ecaVONbAGeO40gzBPDzisS6XOB4pC2kjujc=;
	b=MF9o8ZfRJtN5tNh6JVNN0MYRMRc6BYzOjCCOxtdOEJH+F2YnGd8/KFo8XoDrqw4n2kDt1t
	rLd5wW/XX0nzhGm+xnF98T+kc+QnbBMM9/a+P8Stg9guyGEGoX5kbt6gd6TzNxU/mS+x7e
	xPMoAxyjH+8NuKRQtwJe7we1iPtE4Qg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5HDCi2R;
	spf=pass (imf27.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761938553; a=rsa-sha256;
	cv=none;
	b=tv9gn+UKMoFdU0QIx8yxUjNMwLeBbQ62noDS9D4nGLEMKmotHiCGCMtP7QRC+fyszgGI8C
	L2sfjOnUp8iC7JP58gfj+iW4zB3vixxSTYcMCdfD5Z3OVknjGqwQ53w89TwZ19/xjpBy9b
	ISl2xwOjCUHcbx+588nzZ5YbkqhI81w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AC17419AE;
	Fri, 31 Oct 2025 19:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1DEC4CEE7;
	Fri, 31 Oct 2025 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761938551;
	bh=aRO45gf5CfHW1/jbUbbLGsRCxWY7tHk3cFfnDvNsB6Y=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=M5HDCi2R/696KAq+LQQDeEnnFTStWNLkXYwKUiU9FxJS0+SMep8pWFlpbWtMhCEDE
	 3IqSttDBCsW639HgoIfXNDa5Rl5R2Eg3DPtIMGmbvxRmY4i0JiGYkRMvEIB/UsEAF/
	 CpSxsd8YDaLo7qB+j1Vd4dXbW9wlxIEkOBpLnql/SBO5QE8BsCAMM0NgYXNNpBc0uG
	 74Srbaun1zMez0S5J737hSGvZAiklmcFqDN9evPXeLKPQOTt4EkImzO1RV9Ab3ErMe
	 U7GPDkqCNG4vnEozILb4d3SSdHavGo7+IHCu1Lfn9KlyQUdgHAk2dJZMnL8zRIQzci
	 moNGNmIxIROuQ==
Date: Fri, 31 Oct 2025 13:22:23 -0600 (MDT)
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
    rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>
Subject: Re: [PATCH v22 03/28] riscv: zicfiss / zicfilp enumeration
In-Reply-To: <20251023-v5_user_cfi_series-v22-3-1d53ce35d8fd@rivosinc.com>
Message-ID: <9230fa65-6b8e-ebf6-f215-b3a3bb7357d9@kernel.org>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com> <20251023-v5_user_cfi_series-v22-3-1d53ce35d8fd@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: CC7A140006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tg38sgsjh6jqabw4wt4a671h5inxmzwg
X-HE-Tag: 1761938552-849306
X-HE-Meta: U2FsdGVkX1+ZVPL6e4HpkHok9qg+aIyIU2WwWl1YSZR7RBpgmwvq8NvbEVodfcGJ0Ne/eZpr7GYjQPmo+HSMTocQnBVUoAY6ge30UreyF7NSM6cmVmIm+1U2XxJf5+l/IL9IL3kgCFyKj543/1sJt09SPtmkNajyczzgLYx3eNj4jXe5S4DjVIqKELHzXofzGBOOhlp+x8H+y5ypNda5d/IiDhqwuVaNsZ2wTl2ZEAOwbGxcXUnooXqBJOSGGnsRyliWQKDye80SE3VfDzvBRNsKwCCCXjF979Z19NkDyec5W6UV6YofDXxlq99C/CpmdTovpB5j0ScVggy3tV0nzqdk8mPvzI42dM+HmKaIqHxGNFAZss/N+2hQOMzunOeYuXtIpXcHsCO3T13izI2QjdaJpkuLsTInSaxb6HikxpcDrT2Ia0HMp0ncMzfGJkjO96ODSmV34hNighxHKxVMhNN7cPBfmrL5VPVpHxF5GCcTdg+p9elrK/075zwC/Tr72cfJCYintZmH8VnNuJa3PQ6Yq6VbO0ciTVmBNJIzi5SSA7OqNoP6EsFC8OV9ArocC7w3yLxUR70Mk5NckeB/gfz9V1ZEI6k3jQGBxBH80xGPstN/9TPMnNOBKKWiCGtmj6DQeMsAQ2kDLnJsRMaxz6rqPGcQyBEsJmCR8Th7fplVdPEDK43YKRqptHm7Yi4uUol/an7VHX0hJAkUfqy91BM1xUvpnq2k0R7cioFf/OME/X2Jn6RH4rAEUvFtRHo9e4rt2i4NSPVOaE/Mo5BmheXhd5v6LCcWXv5k5Sa0t5mseq/xoUyGMZsRChkKodcqJVaxeHRKquKkRw3zekslgRhAxQ5DfPVE+wWg6f+eRwWbj05azacwJ4/68w39+KPYIJbkzlgO4gcgC6bRDYcN1IzcEIJrardIgxWcR1H2R3wPBnjf4vHhM86ooo+qvh26M2/zysGkNeapQ+yQUTF
 X6OSSAI+
 fEZ07gGJvHjTaCb6w/XVSu3qDwbMFpWsgIccHLL9tWMKM5e9mlai5oeCLuOFcNmlZHpKWFkhx4gRfmmkNpYpOK4MpzvBF09ajKJW93L+kRl5D0iYhPv9mdjHfvAioCPGhGdxUCQuT/Cj48WYQtTt0t3MKroI4KUKe5VhS7BT9eV0tBhOyzo4HXg4ElRofDud7wVCRt9qu8/J/TPHZR+/LNyosgpZM/1KWgOnfTJ7EQ4D0xtQ355Ho4y+dtTzr9Rq5HTNFWh2jcJ/Vc4OSTDSvTrzo4/H4Dt5YiZFNmbsmc7/bKDUsPGsZnVG8zBe79YIl0OSCkzpK737fXZs5jh30omjcUgDvVhM0AGm6n90Ih2+nmrDrQQ+6ciyhdoPMR/sIYV7KGdtFm6Z9rFdvo6OOwL4XmMQgUiu17LZSwC1j4ptJuhHWr3+SU7QaHgKj63SuIYlU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025, Deepak Gupta wrote:

> This patch adds support for detecting zicfiss and zicfilp. zicfiss and
> zicfilp stands for unprivleged integer spec extension for shadow stack
> and branch tracking on indirect branches, respectively.
> 
> This patch looks for zicfiss and zicfilp in device tree and accordinlgy
> lights up bit in cpu feature bitmap. Furthermore this patch adds detection
> utility functions to return whether shadow stack or landing pads are
> supported by cpu.
> 
> Reviewed-by: Zong Li <zong.li@sifive.com>
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>

This patch introduces some 'checkpatch.pl --strict' messages:

CHECK: Alignment should match open parenthesis
#68: FILE: arch/riscv/kernel/cpufeature.c:278:
+static int riscv_cfilp_validate(const struct riscv_isa_ext_data *data,
+			      const unsigned long *isa_bitmap)

CHECK: Alignment should match open parenthesis
#77: FILE: arch/riscv/kernel/cpufeature.c:287:
+static int riscv_cfiss_validate(const struct riscv_isa_ext_data *data,
+			      const unsigned long *isa_bitmap)


I'll fix them up here in the event that v22 goes in, but please do the 
same on your side in case a new version is needed.  


thanks,

- Paul 

