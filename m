Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D2EC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 08:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B10B8E0002; Tue, 29 Jul 2025 04:28:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861F18E0001; Tue, 29 Jul 2025 04:28:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750518E0002; Tue, 29 Jul 2025 04:28:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 650718E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 04:28:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6F0E56A24
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:28:44 +0000 (UTC)
X-FDA: 83716626168.19.18B4EB6
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id 39BAA40007
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:28:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKsDX+KR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753777723; a=rsa-sha256;
	cv=none;
	b=xvaacoJ0LYUB1/67m5dUmWdnmWyFIfGP4lzoR8SBWhdEf9HVyEk817PldFg+j2dFbQVzik
	O6Q4qM3xXImUwE5IHOS6pLYXxPhIP6uffXAZTkBuxKNxF/ihQmz4iKPeg2+EF0ny07Ye5A
	94of3ibInbZo/T9o4cFu1mtUTDGNONk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKsDX+KR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753777723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n85pmn0u6Z+c4iXgUXsS+36jAK4nq/BZyup+CKlkXI4=;
	b=QQtx3HTgsOxz9Izi5+0ck2znXxyovgvTfTbjPu1doXIyC8ex/g38/YLPfyKBVE591hcYL9
	JND8epQo+wxLDrawott9qT4BrhURqHvJxyW81RD5ZPAD787TjkkGMEKQkPOcw0GqzpQRzx
	uN0AUNPsjn3n3L5aSONg8l5JcX/fUOs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 90E9A5C5B7A;
	Tue, 29 Jul 2025 08:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D23CC4CEEF;
	Tue, 29 Jul 2025 08:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753777721;
	bh=P+RKJolWrlScvE03/wuLDUcQEOrpyiH5p1dHdVtXVqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XKsDX+KRLzAFuf1kLKdAmDj9dggFsRzjLIQ05RDsi+xPOxdHLALkhNkurvUosgFfb
	 ftJlhmN/pjoAT4/au8qTUftIBkqDaJhrJ9SmRZi3Ve7JVy7Eg31DCCYSekcyfaaJNQ
	 JbMb4DIBM9PPiwPI8OZcRcytRu3/nqoGHVDzvP77YimImLNlQUbkZujH5O0JN2T+nM
	 BtsmRo4XDjlCw0KnWSDM6rk+MZk6QP0uSqf7QW3w7lmJVVGYAkgz4EWZXggXy7tATT
	 HSfQX1ig9jgw3cwDIYjp+vOlzwygxMw47ojEswZF9ZVaUkapQqAqU4ht2sNRBTvD+l
	 uIGHhOPpyE+nA==
Date: Tue, 29 Jul 2025 11:28:14 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Roger Pau Monne <roger.pau@citrix.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Usama Arif <usama.arif@bytedance.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Huth <thuth@redhat.com>, Brian Gerst <brgerst@gmail.com>,
	kvm@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Hans de Goede <hansg@kernel.org>,
	"Kirill A. Shutemov" <kas@kernel.org>,
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
	linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com,
	linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
	kexec@lists.infradead.org, linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v4 2/4] x86: Handle KCOV __init vs inline mismatches
Message-ID: <aIiGHmw8IJb9vsM5@kernel.org>
References: <20250724054419.it.405-kees@kernel.org>
 <20250724055029.3623499-2-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724055029.3623499-2-kees@kernel.org>
X-Rspamd-Queue-Id: 39BAA40007
X-Stat-Signature: din9hz4ghx3mdiz94ejjegtkkmae6zjg
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753777723-201652
X-HE-Meta: U2FsdGVkX1+67XrBv5+88aQ9jCqIG7+R9bbodUmnvWsGpCqLQaG2LpH8VqirFM4vPe+mvNzLx5JEmoX0yfJ5DKZN7Z0vMq6ZPqQZBflkBldyOlGYuH5QoarkmIFfC8fZMrMNDRBNCzWa57IqW+S6eiY2QbftjFfkL2sFCmLS8+tFzesHbYxlU0Cj6Y9T+YdTfg4J3zJKGhZdOSsSJXHE/5MAnCR3ah4iONsI+QWSh1ijDAl7KtjG5zgcdSx+xde72ft0knbaxmCMpYnW0h43zXT+DvzSPqOaMr5F+ZJZo7folHRi5uVNcNpe44teS8mA3GVqEOKROgVLQDIhaq3lhVkkVmcB4oVooa8hrpVSdZtkB2oWU0h47sFBTuKKVMdREXuE7+xGD2jA3mm66cc/KsSo5UjLpPLUS1T0ByNWYrKryHsobvD7M3QPsN6CE0Bpe6cO8RUIXgaBwCSVXP2pVdxqNsMkRvS5oksA5gT76SxLaKi2O20vf45NG8+kGfGgcJqbu08ZqLJhsQxSrnTvLZ37sw/lE1r38NUxKu9pHnXfaimv4U3qUB2JL1fI6QyOW0D4bNRQWt3NWYHtqWNLCESHcd6CJ2yP0je68rLrc/QeR3i/ZRf0ay40bMSV2b6KWUXrpjyu99vrLlEAR+oQg8rHxjO1C1Z7n+EqCcs8VmW1Etek4dvh+1baAwb4mcke1MvI+6zieAjFZuNQpnjcarQRbBAyQZMa90XW1/doxS9QQLL0crwYJt45BRfF9y6YEdMTBEfVhFG1ewL0pISVPY2dC/Eq+LoEhgclzRht82yAC1ivyGDePKrYdD8IVGwZAYACn3Dvxaestmad2Fr/ZALEG+auwlKMNtw3wnHaowRiRpLrqjS+rELQzJC23T5jx6pYZN8ZQ5TW5GoQsX5KMYf3eKVRh8oCL+5HmiqeEgghiRoHoDXI9Gfq6ktzT+JC9dAbm15mLtn/vbSZnz7
 5gvFIqYf
 a+mASeEr7K3/ppDA+2pCtuAjxZts8DpiJWM+L43r32Yn9jvZUYA8l/j/v7NeJAtBpj9xe14yNQKf108ObqOKgb8V7ruHXCDbYU68PAea9Qc0xqqOpZtos62rT1vKE2+Ic7v3lcuGMHLJedXfnjhhh/thb6U9tVgrObGsglMfE02vJsEFccN62oIcXbr6zJIBfM7kUbmz9zgWI233f7W5pd4WvLgU3V8BARW1N2c6kYys5SGO2L0Yw7821L30t1n9iL3QuuXONyq4hWkTmW8b8Alg9V7j2NrB3moBu41v9sMu4dluRlRuGZo1zurUshFfvyYOACN01JX7lRO7umUMn6dc7ZTtqvnxwUngs1kgxfFSXwmtmEMl3dswZ/T8uEysjt5rM4uAqVDiwwGpO/n8/0b1pmWufklml/Lr0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:50:26PM -0700, Kees Cook wrote:
> GCC appears to have kind of fragile inlining heuristics, in the
> sense that it can change whether or not it inlines something based on
> optimizations. It looks like the kcov instrumentation being added (or in
> this case, removed) from a function changes the optimization results,
> and some functions marked "inline" are _not_ inlined. In that case,
> we end up with __init code calling a function not marked __init, and we
> get the build warnings I'm trying to eliminate in the coming patch that
> adds __no_sanitize_coverage to __init functions:
> 
> WARNING: modpost: vmlinux: section mismatch in reference: xbc_exit+0x8 (section: .text.unlikely) -> _xbc_exit (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: real_mode_size_needed+0x15 (section: .text.unlikely) -> real_mode_blob_end (section: .init.data)
> WARNING: modpost: vmlinux: section mismatch in reference: __set_percpu_decrypted+0x16 (section: .text.unlikely) -> early_set_memory_decrypted (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: memblock_alloc_from+0x26 (section: .text.unlikely) -> memblock_alloc_try_nid (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: acpi_arch_set_root_pointer+0xc (section: .text.unlikely) -> x86_init (section: .init.data)
> WARNING: modpost: vmlinux: section mismatch in reference: acpi_arch_get_root_pointer+0x8 (section: .text.unlikely) -> x86_init (section: .init.data)
> WARNING: modpost: vmlinux: section mismatch in reference: efi_config_table_is_usable+0x16 (section: .text.unlikely) -> xen_efi_config_table_is_usable (section: .init.text)
> 
> This problem is somewhat fragile (though using either __always_inline
> or __init will deterministically solve it), but we've tripped over
> this before with GCC and the solution has usually been to just use
> __always_inline and move on.
> 
> For x86 this means forcing several functions to be inline with
> __always_inline.
> 
> Signed-off-by: Kees Cook <kees@kernel.org>

For memblock bit:

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

