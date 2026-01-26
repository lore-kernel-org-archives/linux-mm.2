Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F744D19519
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 20:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD986B0088; Mon, 26 Jan 2026 15:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380F16B0089; Mon, 26 Jan 2026 15:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255D46B008A; Mon, 26 Jan 2026 15:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1FA6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:40:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE0DB5B866
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:40:34 +0000 (UTC)
X-FDA: 84375283188.01.A917B0A
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf28.hostedemail.com (Postfix) with ESMTP id CDC1BC0010
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:40:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=gCOblnzH;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769460033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUBpOm0QvKE2389W2MiwDwXvLMg/CnIs37/EZYwRaJU=;
	b=BmyJkMp8FKSEkx4S4jF242sn3OLfTpDG0knIOR51C5t3nzvRqlXAVs1PJwUvpaT7mg7KmS
	bgY7VdVRrjJz+PGJDM6L18gjTvLv0U02eRljylxssP0UnG+i4s4eB8Fgy0E6ADCItZm/oG
	egiQzYgm6m44kbhO5SiD7e9q8YWrYl8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=gCOblnzH;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769460033; a=rsa-sha256;
	cv=none;
	b=qrsMn1E9+YdNNIWScIoR/knNZ/IsuaTDraYj6ND47RrY6RTWJJYiW3J8xUfMpC2emQirQZ
	pK83s+nMpRUaZUaui8ggAKCnK5+N0saVQTtFC0x4Y6moyu/gT3bEVGQFYFxYWtz7TchGzq
	3tuMgG2I9HBE+skOh7/M4CVf/Vi5jig=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b751c8b6beso1205564eec.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1769460031; x=1770064831; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EUBpOm0QvKE2389W2MiwDwXvLMg/CnIs37/EZYwRaJU=;
        b=gCOblnzHIFppUvTFc6VHpmEWgoefmVYLjqkK8zhxbmfpNB8XvLaIkEdGMMGU5a7s4J
         GxzDntO6gpHo/aSeS9z9A/iW+OxlfoJlwJEbysWLpbdRER/U/etnP2+/U+baIh/toIco
         cGucwancN6owwCETUq2fSkUkXss6cc9VDrmbwwnZGjQGY+5BfL4H/dcycIFS1cYTNGv1
         uDQdjQq1vRgtPXFnIhG5jigaGn4OqSC3LDnv52VBxmy9hlgsrOwz+tNaxZ37UOZaWQgK
         Zbwb9DTmZZb8uk1QsqUjdwwMdHcMLDdB+dUIdEMT2AjP7OT6e8i/WmGQStD8QKmQyjpm
         QZ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769460031; x=1770064831;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EUBpOm0QvKE2389W2MiwDwXvLMg/CnIs37/EZYwRaJU=;
        b=kghMLMu45OsnSVY41Sx3wcB+KszuxYeyAFT1UQK6ZY+NU9XkgP0PFxoesx4pAtPdoM
         lMchK2XKty4cidXMxdDxGNDpxTbFEhVEuG9Sg3VoJFWZq9VjvcVliMbj9j1H2ncqxgtD
         ZC/CBla0LQsyjrJDTrqZ6dSD2hJXXU1kmEvSZEh5ukmmvT84D2wQ1lOjDVb9T8omhonJ
         mxiG5YA6wZ7Q1i7vHa6J1yxa5ceu5bH2SsEtLxwwrbsJSaXHI4d59TrkEcXmCCXRVZTu
         S/reN36su5ASzYWTsJMGHHO7m2OZbXxdxThvgzUOH7ZcCB7Ll5+RaG25YQp5PEDUI0lY
         FbmQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/v3TdGlNHPv78um3ITN3GtGUHtEPfDtazRQezneo+KjcF2xAJUptsI2PixhSlQSRl8qbMdvgTOQ==@kvack.org
X-Gm-Message-State: AOJu0YzAVzEvS5Gm6VuH59IHTh1+uQlZ80VQfHjg7rEs+c7CwCdYwybF
	bnsoMkqe0o6lr3pwRKIXg0qrp1YQUzCJOB62mvNJR9yox9UwpAy0+ropraKia83GYlE=
X-Gm-Gg: AZuq6aK6tkhry+pcYd0cltBiv9Gc1OUw9oaBu/hnPOFPFRpiPKi7LMllpN0bbdys+Qb
	MRRbYrdoEfZnQFC3c5oaO3Dec4ZnchQD45FkDIvwcIRfS/fzJr7JYvCE7JI0OdOT0IkXYWGbQcC
	WFm1BNPWCjLx6HJBDYZdxkK+HOO1o2hdu+P6C/aTDjycLHpTZ4n4RJ2EtUO1n6Qca4cimj0jOCP
	UpEHYx1b4YDAETHRCmUfPTycPyFzQktIRlriug13POLVtEdzrCaprJwi4daUvj4ZlCo24V8xe5Y
	23d0GAsCee8D4wm2dvt+L+pN7YdQUnKr4pB4EZRpejyiueyJ5w/dkxy0fspvMa6UIQ27Ml9hdl5
	WIBwtgSXU9XteKQwfOZxmVhGN6NTfKM86cU0iiPS5EJ58+THX5vF99GdHVKvYDVXOXmsDC52LLu
	zWZStMIjoDm++zrlyeEP8AUmmON8jdREE=
X-Received: by 2002:a05:693c:6218:b0:2ae:5a2e:de70 with SMTP id 5a478bee46e88-2b7638d6573mr2604064eec.8.1769460031398;
        Mon, 26 Jan 2026 12:40:31 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73aa03fd0sm15037214eec.23.2026.01.26.12.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 12:40:30 -0800 (PST)
Date: Mon, 26 Jan 2026 12:40:28 -0800
From: Deepak Gupta <debug@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com,
	richard.henderson@linaro.org, jim.shu@sifive.com,
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
	atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
	alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org,
	rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
	Zong Li <zong.li@sifive.com>,
	Andreas Korb <andreas.korb@aisec.fraunhofer.de>,
	Valentin Haudiquet <valentin.haudiquet@canonical.com>
Subject: Re: [PATCH v26 10/28] riscv/mm: Implement map_shadow_stack() syscall
Message-ID: <aXfRPJvoSsOW8AwM@debug.ba.rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
 <20251211-v5_user_cfi_series-v26-10-f0f419e81ac0@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251211-v5_user_cfi_series-v26-10-f0f419e81ac0@rivosinc.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CDC1BC0010
X-Stat-Signature: ffhji8w8cc14majqq3mx3ddo5fm86m6f
X-Rspam-User: 
X-HE-Tag: 1769460032-229341
X-HE-Meta: U2FsdGVkX189r1gntKXhYkDFhsBavp4Lc0z+iEax0JiSqXOrEugl5+EeGN5hj2bRZ8O7Xshc1LBrNyNG/TNlrLexvvUf/BiXHKbmkJx4UhFDJDaeI6gtMl4xH4q12yZ2bnPAXusq6g9TJWuNXtzEIGXBags+yQJGDPsvw4farHGZK5kdK2RCXUFcli1o4WxYEPGS1yT9JwY1FVlZzDOynPIHICrMRg3GkXJLxMgt3V9kgH34OC/Zs6f4ruIvEP4jZaoiTw/ePohvsGrmRRZ/CF52A2CuPKcz3bykBCqyT0HXrBwcYr/zurih1eapybNHtShkJkjV2kWviU3TzjWquGxC2xwCtePwSXjkDlm5y4Pc9Zzk4eEp3qQXrotTkZsLGtyMrJVvPkvHags8cPL+i4zg5nr3LaUnGPrUvFx88juQ7QdVpLi6NbG66UuhvW8eLDbaOvr+GEs0i13ZNj1k+Wh9k4SQAER1qqTH4ALWOJfuf7MFSHjDE3Eu4Mon9bjyU9sV2D6uijWEPX2JT1UDdtRz+c3WEgWqdjnKqLtMWAzqJD3AahA28qunN0yQjcgH78uWlmxxI+u31hxSaauPOjXrEK5WsvC6sYMYXCjtb+Z0Rad/bj59NAoQ/153gvfOvg/qFETJlA403iXypKQBRlhlPMYy0OsScIUMUeKPs1fe8J/UYsM+8AKn0a53G0/XmlIK3d8RTQmo1sNNxAYbbuCtWuZVpWsnFo165zzy6ZNEKRLpGVx8+bdN9PSQeRORbHoWyik/f5UVJwyMWU/np5v2xg1QEegcw6RC+7fuEUX54bNsChHXjOrnuXp+ZX0bAtXD6cSrWdZ4yhGGftv1nyM2JiH6KLTDcLG0sfnoLwrYN2f6TaqVRqrNM9RHfUipRY+9X3X7TenuTnshE3yyhgEltTC5x1P3UgOlBI8J03KAZuYh5lPIqa+2qYHlzfE7Z/HbI6iyBYw7PGNwSRz
 J79nwwcM
 T9kA5p7sbZSJ334H9EQGwJptoMW0CTwNCUG/AyJg6KqPwEOUg9j+ZasERnzKK4O5xhY73X3JdpLPbHsYfDESSlEi0NhtZTj8aEqMkdohM8J4g4LKVEApy7ofQZSOmQINa/LVetK8xACNSLECW9vtjbCKh1tBnIILVtCqGnRcGTsWNCLrtZIHYPB4qwrJBeT5PTT8E5L9C52Huvn9909zQ5InQx5O1XEAoyLU5wd5oysI1ddOkCALBkPTDpGGA3U+z7fmIU5uMvFjM08US4ROJJUpI5GeslcgZOKtiMjjKC3WyQob4GxaIywQs5jGEbRwIRySYEoXTXlwJE6xXxq0/r1oCBvuzCTGh16DGirQ9VhqFyaveJ2Z3mu2NPOiJG/XlorP7aT01/sgiH9e2mULxA5Qt2q2yXw545eqxouMcTSMsQ5+JpkjmKEq+Fs0FxLYP6KJHnten7b+04vt4S6sqMsMaHgrdavkH8xh/9umfkDXjjbTXfrl87XyKShJmeEY8M+v/iZU9PhtSY1OEShq6XHGjxv6l1jWg4k78w2j/U/ToDVmNTRK5dJCJowZRuaQDgir6a8ZR05Z8RzqkdM3H9PC3wJ6vkb3EME0l1N9m/tiRWoMGjdcSdWKw7ZXkGSGNIPI2iNRfEBPg6Cs9jVkEP0ilEiApEbQ1oUjyOYBuEuZll17LXnSh+KX5jGH8aKVrpvNsRp5iZQgcYck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Paul/Zong,

Can you apply following diff on `allocate_shadow_stack` function in this patch.
This fixes the bug that I earlier mentioned. We shouldn't be returning location
to token and instead return base address of shadow stack. Userspace consumer
should be determining token location itself. This matches the ABI of other
arches. Sorry for being late on this.

diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 27b36034ea85..a8530e6afb1e 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -232,7 +232,7 @@ static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long siz
  {
         int flags = MAP_ANONYMOUS | MAP_PRIVATE;
         struct mm_struct *mm = current->mm;
-       unsigned long populate, tok_loc = 0;
+       unsigned long populate;

         if (addr)
                 flags |= MAP_FIXED_NOREPLACE;
@@ -245,13 +245,11 @@ static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long siz
         if (!set_tok || IS_ERR_VALUE(addr))
                 goto out;

-       if (create_rstor_token(addr + token_offset, &tok_loc)) {
+       if (create_rstor_token(addr + token_offset, NULL)) {
                 vm_munmap(addr, size);
                 return -EINVAL;
         }

-       addr = tok_loc;
-
  out:
         return addr;
  }

On Thu, Dec 11, 2025 at 09:20:43AM -0800, Deepak Gupta via B4 Relay wrote:
>From: Deepak Gupta <debug@rivosinc.com>
>
>As discussed extensively in the changelog for the addition of this
>syscall on x86 ("x86/shstk: Introduce map_shadow_stack syscall") the
>existing mmap() and madvise() syscalls do not map entirely well onto the
>security requirements for shadow stack memory since they lead to windows
>where memory is allocated but not yet protected or stacks which are not
>properly and safely initialised. Instead a new syscall map_shadow_stack()
>has been defined which allocates and initialises a shadow stack page.
>
>This patch implements this syscall for riscv. riscv doesn't require token
>to be setup by kernel because user mode can do that by itself. However to
>provide compatibility and portability with other architectues, user mode
>can specify token set flag.
>
>Reviewed-by: Zong Li <zong.li@sifive.com>
>Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
>Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
>Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>---
> arch/riscv/kernel/Makefile  |   1 +
> arch/riscv/kernel/usercfi.c | 142 ++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 143 insertions(+)
>
>diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
>index f60fce69b725..2d0e0dcedbd3 100644
>--- a/arch/riscv/kernel/Makefile
>+++ b/arch/riscv/kernel/Makefile
>@@ -125,3 +125,4 @@ obj-$(CONFIG_ACPI)		+= acpi.o
> obj-$(CONFIG_ACPI_NUMA)	+= acpi_numa.o
>
> obj-$(CONFIG_GENERIC_CPU_VULNERABILITIES) += bugs.o
>+obj-$(CONFIG_RISCV_USER_CFI) += usercfi.o
>diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
>new file mode 100644
>index 000000000000..251c3faccbf8
>--- /dev/null
>+++ b/arch/riscv/kernel/usercfi.c
>@@ -0,0 +1,142 @@
>+// SPDX-License-Identifier: GPL-2.0
>+/*
>+ * Copyright (C) 2024 Rivos, Inc.
>+ * Deepak Gupta <debug@rivosinc.com>
>+ */
>+
>+#include <linux/sched.h>
>+#include <linux/bitops.h>
>+#include <linux/types.h>
>+#include <linux/mm.h>
>+#include <linux/mman.h>
>+#include <linux/uaccess.h>
>+#include <linux/sizes.h>
>+#include <linux/user.h>
>+#include <linux/syscalls.h>
>+#include <linux/prctl.h>
>+#include <asm/csr.h>
>+#include <asm/usercfi.h>
>+
>+#define SHSTK_ENTRY_SIZE sizeof(void *)
>+
>+/*
>+ * Writes on shadow stack can either be `sspush` or `ssamoswap`. `sspush` can happen
>+ * implicitly on current shadow stack pointed to by CSR_SSP. `ssamoswap` takes pointer to
>+ * shadow stack. To keep it simple, we plan to use `ssamoswap` to perform writes on shadow
>+ * stack.
>+ */
>+static noinline unsigned long amo_user_shstk(unsigned long *addr, unsigned long val)
>+{
>+	/*
>+	 * Never expect -1 on shadow stack. Expect return addresses and zero
>+	 */
>+	unsigned long swap = -1;
>+
>+	__enable_user_access();
>+	asm goto(".option push\n"
>+		".option arch, +zicfiss\n"
>+		"1: ssamoswap.d %[swap], %[val], %[addr]\n"
>+		_ASM_EXTABLE(1b, %l[fault])
>+		".option pop\n"
>+		: [swap] "=r" (swap), [addr] "+A" (*addr)
>+		: [val] "r" (val)
>+		: "memory"
>+		: fault
>+		);
>+	__disable_user_access();
>+	return swap;
>+fault:
>+	__disable_user_access();
>+	return -1;
>+}
>+
>+/*
>+ * Create a restore token on the shadow stack.  A token is always XLEN wide
>+ * and aligned to XLEN.
>+ */
>+static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
>+{
>+	unsigned long addr;
>+
>+	/* Token must be aligned */
>+	if (!IS_ALIGNED(ssp, SHSTK_ENTRY_SIZE))
>+		return -EINVAL;
>+
>+	/* On RISC-V we're constructing token to be function of address itself */
>+	addr = ssp - SHSTK_ENTRY_SIZE;
>+
>+	if (amo_user_shstk((unsigned long __user *)addr, (unsigned long)ssp) == -1)
>+		return -EFAULT;
>+
>+	if (token_addr)
>+		*token_addr = addr;
>+
>+	return 0;
>+}
>+
>+static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
>+					   unsigned long token_offset, bool set_tok)
>+{
>+	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
>+	struct mm_struct *mm = current->mm;
>+	unsigned long populate, tok_loc = 0;
>+
>+	if (addr)
>+		flags |= MAP_FIXED_NOREPLACE;
>+
>+	mmap_write_lock(mm);
>+	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
>+		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
>+	mmap_write_unlock(mm);
>+
>+	if (!set_tok || IS_ERR_VALUE(addr))
>+		goto out;
>+
>+	if (create_rstor_token(addr + token_offset, &tok_loc)) {
>+		vm_munmap(addr, size);
>+		return -EINVAL;
>+	}
>+
>+	addr = tok_loc;
>+
>+out:
>+	return addr;
>+}
>+
>+SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsigned int, flags)
>+{
>+	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
>+	unsigned long aligned_size = 0;
>+
>+	if (!cpu_supports_shadow_stack())
>+		return -EOPNOTSUPP;
>+
>+	/* Anything other than set token should result in invalid param */
>+	if (flags & ~SHADOW_STACK_SET_TOKEN)
>+		return -EINVAL;
>+
>+	/*
>+	 * Unlike other architectures, on RISC-V, SSP pointer is held in CSR_SSP and is available
>+	 * CSR in all modes. CSR accesses are performed using 12bit index programmed in instruction
>+	 * itself. This provides static property on register programming and writes to CSR can't
>+	 * be unintentional from programmer's perspective. As long as programmer has guarded areas
>+	 * which perform writes to CSR_SSP properly, shadow stack pivoting is not possible. Since
>+	 * CSR_SSP is writeable by user mode, it itself can setup a shadow stack token subsequent
>+	 * to allocation. Although in order to provide portablity with other architecture (because
>+	 * `map_shadow_stack` is arch agnostic syscall), RISC-V will follow expectation of a token
>+	 * flag in flags and if provided in flags, setup a token at the base.
>+	 */
>+
>+	/* If there isn't space for a token */
>+	if (set_tok && size < SHSTK_ENTRY_SIZE)
>+		return -ENOSPC;
>+
>+	if (addr && (addr & (PAGE_SIZE - 1)))
>+		return -EINVAL;
>+
>+	aligned_size = PAGE_ALIGN(size);
>+	if (aligned_size < size)
>+		return -EOVERFLOW;
>+
>+	return allocate_shadow_stack(addr, aligned_size, size, set_tok);
>+}
>
>-- 
>2.43.0
>
>

