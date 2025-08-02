Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01091C87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 18:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF6B6B0088; Sat,  2 Aug 2025 14:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0226B0089; Sat,  2 Aug 2025 14:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0BB6B008A; Sat,  2 Aug 2025 14:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDDF46B0088
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 14:51:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D4BB80C0F
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 18:51:32 +0000 (UTC)
X-FDA: 83732710824.28.5B979B5
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82E3D180007
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 18:51:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oyi1tKQE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754160690; a=rsa-sha256;
	cv=none;
	b=N2c321xxF3lQApn/pWY7/GuAGJeTRouI6tILb+RRdETusabkQ0Atoo864Idg3G7uKzz2zC
	DbFnlNyy21B5Kz/A367EzxAgCXxLWuNDGxn+/dsDRNAMc4SQy0pX4B5tMo1+xPkxTK+5z7
	YgRl+XPL2pmmhsg7s646wLF6LMrRF6Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oyi1tKQE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kees@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754160690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mo3Le9O3U8hfnrveF4r3jDliLyDVPGSJedljFBw9zDo=;
	b=Q+cVfQiVRcRReaf8PApe+a7M2NvzseSd8K8vH5VQkDgS3rk+0sTFZIHJUohkop64qjmyBW
	q+vZzumtPI5GcF8+NUkeKa7CoRJGxSQNuxxxiwsETXyOPNIsXwjp0z5Uccp7cpsANWjajH
	WeDK5tDsX+tzo5pm1sbGNaate5vqv9Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 7793DA4F80C;
	Sat,  2 Aug 2025 18:51:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF55C4CEEF;
	Sat,  2 Aug 2025 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754160689;
	bh=RiGNiHqduvbyMJazTqCXPOWEO6VyqZFkOlYS73wNtV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oyi1tKQEVLy7nKAugvnwDQJY873SOMOmCWXgj1+OMxC1ktxOj29Txp12eod6mIKhJ
	 hGjvqBszSSmM8HSOSCBRxpptYW8hquo6CbEHFq4KKfZBP9WCsPbIqhNYVD1i1W1HWM
	 uf5zMixtyBlO+bB8qDrrzvZpbD5R9P9Wckkqoazai3TI3/tgwfhBW1nSriXqvEA2C6
	 W0XR0PTQzwQN/VZN2SFu+W3qHihc1UqIy4z+KKy+F7lDLY4qx/MB4QeYVaVFgT1rlc
	 bxRM/LYyUg5su5Uq1E7EToDT93T1PrS90jkf/jksSASUybVE3fXimvpCLXXNcPkMiP
	 bUJmMtQ48VNaA==
Date: Sat, 2 Aug 2025 11:51:28 -0700
From: Kees Cook <kees@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Breno Leitao <leitao@debian.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Alexei Starovoitov <ast@kernel.org>, Hou Tao <houtao1@huawei.com>,
	Juergen Gross <jgross@suse.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Eric Biggers <ebiggers@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Yuntao Wang <ytcoode@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Tejun Heo <tj@kernel.org>, Changbin Du <changbin.du@huawei.com>,
	Huang Shijie <shijie@os.amperecomputing.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	"Kirill A. Shutemov" <kas@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Xiongwei Song <xiongwei.song@windriver.com>,
	Xin Li <xin3.li@intel.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>,
	Brijesh Singh <brijesh.singh@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Tony Luck <tony.luck@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	X86-kernel <x86@kernel.org>
Subject: Re: [PATCHv9 04/16] x86/cpu: Defer CR pinning setup until core
 initcall
Message-ID: <202508021149.B4BFF8D1@keescook>
References: <20250707080317.3791624-1-kirill.shutemov@linux.intel.com>
 <20250707080317.3791624-5-kirill.shutemov@linux.intel.com>
 <6075af69-299f-43d2-a3c8-353a2a3b7ee7@intel.com>
 <98a7a91b-3b46-4407-82a7-5f80443b7e00@intel.com>
 <6e768f25-3a1c-48b9-bc53-56877a556a83@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e768f25-3a1c-48b9-bc53-56877a556a83@intel.com>
X-Rspamd-Queue-Id: 82E3D180007
X-Stat-Signature: 9y6oy5cps5nqzupyk8u5d57q7wsenqpd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754160690-200135
X-HE-Meta: U2FsdGVkX18CXrDx/tIq0Jp4RRwSKQqX4q/CNdGJxh5nGyo5ovMLA+Wy3Q/Hb/IHF10yJcp/dW2q/TW5UpcnxtRzJSbs1IOzL4c/L63oAPfpr9Qni7D12QzTHse+L+bk8Cek+Ha2wbA56CIGYGPgTlvahrwxKmJjVkKC8mPZ7/wXrdPuagK+ItPuATWxItAZ3+a6w7mhOlI1VIM3CRXRONZUP+iaoiZ8wKfUpC5CxdFzG5408oi6E+mP+K0EPfJBt4jr+vQ0u9YsfPCLDjz01u74LM42mB5CWX6eWWD8pG8a4jXGCEiDsmSPpp0QriS4UgalHSsCAWjVImC5gejukQK2+WerZToSrbdufd6qY+Zq/bYdx9RSvMFjAyS27VyWsolQSYYAYu+4t1x0RJJlFj+wkEZNgYwwkIvQ17T2KYFi5USsaYpD5aVMkB4s0tOtDxh0KmtaH7obisV9sqWtB8FVLQs0Wcz8mVp6RWtruFJzsugBrKgxyEDAqtKSvDXBgKg7aC0qMyVLd7DyUkbWrPzuDAeIjpzBbrpku975z27+6iCBw0pDcS430/o53R3kidLmiNHZQG/8JaJi4TV0wJTzQ+/KfkLMbQhLRk1T4mP9UPGlGmuxzzQFOVxpsXNTdyk99HXOtFqg5w9txSva3BtS9jlNM3QyG0BJCFuTTk8aw2dgHXfoQ0js1+/GeMFXYy6Ws29Yfh9SPfAa5/v7HgfEEFZAHQmky0i1PpoEcDqr0NbKkcJR6y35yCQziXuGdEndXWgNiYPQ/fRn5HeX5gfEqWcsrVCTpPQKDcCCxH71XsrdqIf//gn7WmjJ8VJCZAu4nkBHyYSkDpZhBwCw5lVSbCPR6n5rD4HBill0tIDDrnwLfM1o4al33YR8g9vRLYIrWnzmq+D4XVtVhTCI/lU18+vxLxZ91XEbeLqmLqKNmS4wjc8feNLTaY2C8a6MiwSDDpcn6ALP8htqZ+y
 Qod0PsjM
 zj/Fa4gb+jzQ90ZGASXaxiziLdPn1hpO1QPLzrWmhQ/+3phqod3zIXfeu5dMjr+OK+jYGO/lDtO2WWwMcDvz04X2Qc/g3V2zBvFQNVoeB98nbylRsUN0IEtdwR8KrLIQUjORRsdpKcpJZ6Wu91QQ2pcWWRGWg4//3PApZRDvGGONgRiNAZG67rJ7FCL9oydJzSPtxcSgZigEz7j/L3ZPTzZ8XUVZas8fu4YPLxhaWFR9f1BZ6BMehcggRbijA7d3wg1Ydu6o7U/GUbr7z1Tl+u/JFtzsPE/3IoUdW3NnhoqcUcGOOjYyaBd+Upab7DJxJzEOoc0PiwQY/rpk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 05:01:37PM -0700, Dave Hansen wrote:
> On 7/31/25 16:45, Sohil Mehta wrote:
> > On 7/9/2025 10:00 AM, Dave Hansen wrote:
> >> On 7/7/25 01:03, Kirill A. Shutemov wrote:
> >>> Instead of moving setup_cr_pinning() below efi_enter_virtual_mode() in
> >>> arch_cpu_finalize_init(), defer it until core initcall.
> >> What are the side effects of this move? Are there other benefits? What
> >> are the risks?
> >>
> > Picking this up from Kirill.. Reevaluating this, core_initcall() seems
> > too late for setup_cr_pinning().
> > 
> > We need to have CR pinning completed, and the associated static key
> > enabled before AP bring up. start_secondary()->cr4_init() depends on the
> > cr_pinning static key to initialize CR4 for APs.
> 
> Sure, if you leave cr4_init() completely as-is.
> 
> 'cr4_pinned_bits' should be set by the boot CPU. Secondary CPUs should
> also read 'cr4_pinned_bits' when setting up their own cr4's,
> unconditionally, independent of 'cr_pinning'.
> 
> The thing I think we should change is the pinning _enforcement_. The
> easiest way to do that is to remove the static_branch_likely() in
> cr4_init() and then delay flipping the static branch until just before
> userspace starts.

Yeah, this is fine from my perspective. The goal with the pinning was
about keeping things safe in the face of an attack from userspace that
managed to get at MSR values and keeping them from being trivially
changed.

-- 
Kees Cook

