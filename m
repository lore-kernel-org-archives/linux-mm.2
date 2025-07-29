Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174D2C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA726B0092; Tue, 29 Jul 2025 04:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1C66B0093; Tue, 29 Jul 2025 04:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0A76B0096; Tue, 29 Jul 2025 04:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84E5A6B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:11:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38D0C113B7B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:11:15 +0000 (UTC)
X-FDA: 83716582110.01.4FDE7FC
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E3D14000F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:11:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F+W04S5x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of will@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753776673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9JlasXi5thdYj6KfusHycPKdfl+LKE1gmMwQIgNpXY=;
	b=US6BpFvm5dfYcdcZklIDnCPeN3RZtz6NHDnHifLkUvBfnF4/U4ywFVBRZZwQGTnC8HTfTX
	T2wbkOokqfgVJYIGnUBWKzHr8DqpU2SOKKO+PzhbHTmMmZXAJtMYFXvZnwFe62cvn68UiQ
	jv55Yi0wI4IhMmG8xjkQHXZ4iQ0mcCM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753776673; a=rsa-sha256;
	cv=none;
	b=wkkMfyhr8NKWFjqWU2qXgMy0dPre3rZLJdk3te334KVZH6C7DZE92eFWiG9sizhIQILvbs
	0Wm6rrvY7Mia6c85aL7HwSHv2p9u6pm2gWDXxbLkYxzw4retSX4mO3OFHuj3VxjZFJpekr
	EU5fq6ULEqaP0+KQ+UtIVOnqWCUvIeU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F+W04S5x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of will@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=will@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 26C8FA54A2F;
	Tue, 29 Jul 2025 08:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46400C4CEEF;
	Tue, 29 Jul 2025 08:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753776671;
	bh=cWVIex8ZD7iLHUiFYdl7hALOOKwBmGPA9Eu9Lq5/ve4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+W04S5xBBcVSjTJ0lwCukWF0CUJoPlRJ5apOHIjcIp4Ir2h0WEtBfOZPNq9j6UIw
	 6fZP5IdfM5f5vLEjByzE5d1D4q0ntoXIKt1ZlaptYaMMJ/RbpgOJ4vi8j7m1REK/WE
	 cJzV6oM57CeEOUeuFXbdpRKe9ommavUNv3horhLZRAO6muGJhtumt9y36tBBk8z1p0
	 RcW8XEWXTvj+vpzKEBs29ORzEbWanrDmwe68O6LcUhBYBhNbsg7nJAYdHkL7mym1rZ
	 WuxIc0wxhAbBVU5BUD51GFHFqvaCN7R5JBhhYX7ZtWmQVYAe4Cx4MWw9LPH9S4UYr+
	 4hpI//0VngcyA==
Date: Tue, 29 Jul 2025 09:10:55 +0100
From: Will Deacon <will@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Roger Pau Monne <roger.pau@citrix.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Usama Arif <usama.arif@bytedance.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Huth <thuth@redhat.com>, Brian Gerst <brgerst@gmail.com>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jan Beulich <jbeulich@suse.com>, Boqun Feng <boqun.feng@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, kasan-dev@googlegroups.com,
	linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
	kexec@lists.infradead.org, linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v4 1/4] arm64: Handle KCOV __init vs inline mismatches
Message-ID: <aIiCD5V1MaI3ORqA@willie-the-truck>
References: <20250724054419.it.405-kees@kernel.org>
 <20250724055029.3623499-1-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724055029.3623499-1-kees@kernel.org>
X-Stat-Signature: rf9xkx3gm18oerc7u5iuioj7rjifz3iz
X-Rspamd-Queue-Id: 5E3D14000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753776673-28953
X-HE-Meta: U2FsdGVkX1+daB1BZdAEGDpeRWlRD/TFlRWyW5HiiKge47G5HxfGVf0D/v8KBR1DOezk5D57o6IWw+mNKhtALS50iqbgw8N0jR8Gihl5WArb/7QIcwOdxLnJMUNnMfMMWQo9UuASM19reRJRfMrDNt4pOs74PWBVJ61LdLelkfZDCElZcnIoOYxv782t6AjZbJN67d/UOJDbKL/D+MwGF5uBIIex9YvS7i2wa6cwOrqVv83IsJYNimYpCBmVENbDBziTwD/7pYep2YyKF1BFhoAkrwwi1EDo/f8IPHBCLXvaF7B7Q5iC8O2u1wyOjEx9pYKaC9hZ1SHuiaHjRu9w+UQijrCMNzc9MSibcLO/cVN13W+iP332HTHAryBW1qAG38jaTUEN1bKrXAUjnjNfQEh6BawlEO64oiN/sTbcDe9bqC+X29h76VRLZDUSv2YdI7HG/aeRS8QS/rY581kvoiOdNxt8xBwt+fGLUncIFohf8cXs68pWnnHu8Q5PvSWBi2HbMxmTaYk9FzsqH7ztLdiZwxKpN8E9w/zz0q5V+tbBRj0NbO3+1/lqMFbviIdwXL5JBLBpsVOEv2gkFPwIoivXl5SrZ7cSHZ7gfR/6DDkQUFOGL48Derh2zQn0W8sL3bdCMyfQ+ZfzExJev9NObZRA5yqjVWaf4pIGBSEZWaXqvsaDMx/vcpBTXGzmVjPcenfsgTf+WG+zoKsxEJg6BQUH0dlq1876QrTqJmBuSyE6hqtCYH1nl7aIHe1nZDDNKT4B2cdtaCtNHneZUSmSzg0ve2mbWlE/VhrGPqo+62W7j6Kq+j2KKB7KhpLKNDhWFE2Q3rRdEicUOC5a18eYwEn8dH16O4yatSht2rz+qXVo2SwpJAJ5ywlsYpwa2cDhqpOsnHPTZCck3pjyaoFmu+s25z8/RajtDfOTrokhgJ/Wey+6nZq1GBuHzd08MAbuxmnSlGFj5bDgfZMCkEm
 NJbeXxPc
 90sAWG9HEigroxOTeq41Ihr8GGobr7ZftcSoJV2BlXzXtlKSZQt60noraX+HFAyKE+yY7bYu5aRu9pi79w77gbJ5wCLg85exrLZjucPK3bP9fgOWK4/6OC721XUAcfnkH+7JzOKW8bnlaoLvNDlRDTLrx5Bxwxi5nbY9RER43X4OprwG16IAl977Du32+Puu2e2syxvA8VEOA8sdqd6iHdstWOj4GfOrIRjnvFfyU2R4JgU4mYCbxhk5A5vKl7amSEHNuXGDDAST9WHp1EBBkNLBWaZnscWpVqtAOY5tao90iZfNsJjsgZSLxKasKhPmBccH2tAKuYfNlqHtJONswsNm+ac3dsSsrgh6mV6cBqMIvmrctKFQDryZtF13TdZsA9HWi1pMyZ/9NUaF6lPgqUTvMop8lySUlaxEKbJTsMxmbH1M22TFyuW5EPfx3TObPxN5TqD9MaqKpMrai896QtGGB7hL3euLfIy2Z0cLR+g2+VVVRU4atieIqOwg+y5pOUGdOEUktScTwThCsmu3q5XRmv8ZPQX3+/OIBfNmEEMXuuUv02dA74/+cYalv/eIEUchZGWQrdxH0NX+FSi9AM35w3EzNyHOoxJh/7kzDzpGmX0oED+1jFDgkfP1fuewyWn5ZHzNtkYNwkMvDSEcRG3qppiPmOBN6YGk65bE8qzxd3/5WLEMSrjZCnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:50:25PM -0700, Kees Cook wrote:
> GCC appears to have kind of fragile inlining heuristics, in the
> sense that it can change whether or not it inlines something based on
> optimizations. It looks like the kcov instrumentation being added (or in
> this case, removed) from a function changes the optimization results,
> and some functions marked "inline" are _not_ inlined. In that case,
> we end up with __init code calling a function not marked __init, and we
> get the build warnings I'm trying to eliminate in the coming patch that
> adds __no_sanitize_coverage to __init functions:
> 
> WARNING: modpost: vmlinux: section mismatch in reference: acpi_get_enable_method+0x1c (section: .text.unlikely) -> acpi_psci_present (section: .init.text)
> 
> This problem is somewhat fragile (though using either __always_inline
> or __init will deterministically solve it), but we've tripped over
> this before with GCC and the solution has usually been to just use
> __always_inline and move on.
> 
> For arm64 this requires forcing one ACPI function to be inlined with
> __always_inline.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Will Deacon <will@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> Cc: James Morse <james.morse@arm.com>
> Cc: Oza Pawandeep <quic_poza@quicinc.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: <linux-arm-kernel@lists.infradead.org>
> ---
>  arch/arm64/include/asm/acpi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index a407f9cd549e..c07a58b96329 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -150,7 +150,7 @@ acpi_set_mailbox_entry(int cpu, struct acpi_madt_generic_interrupt *processor)
>  {}
>  #endif
>  
> -static inline const char *acpi_get_enable_method(int cpu)
> +static __always_inline const char *acpi_get_enable_method(int cpu)
>  {
>  	if (acpi_psci_present())
>  		return "psci";

Thanks for improving the commit message:

Acked-by: Will Deacon <will@kernel.org>

Will

