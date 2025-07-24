Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A6CC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048076B02BA; Thu, 24 Jul 2025 09:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B5A6B02BB; Thu, 24 Jul 2025 09:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29956B02BC; Thu, 24 Jul 2025 09:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CFAA56B02BA
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:09:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97CD21403C3
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:09:07 +0000 (UTC)
X-FDA: 83699188734.12.BE41BC9
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf03.hostedemail.com (Postfix) with ESMTP id B622F20018
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:09:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of n.schier@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=n.schier@avm.de;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753362545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ne/XcgrgO/KJ5Vpn5Kmd1KTfFMh8OZxebN5iFuDYEM8=;
	b=zWqfv257DpQ2nbtAxETo5K8YGf0BTWNFraNsi56fin2apn62zGn0c6ROB6IQrNLKM6ZQZ7
	bXDXhJvebqQb3vh6gaSeJ5CBhuuaGuycjjYUSj8bS4g1vehOk5dZPFGNy6dwvcKyUeDipD
	8sEMsFHFCmuzLs2CbOxZtYwkkKuUlEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753362545; a=rsa-sha256;
	cv=none;
	b=M4VOmD5P5n0MKloA8I6DJg50xYgSaS6+cYRECVV865R0MsG7uSybZW0AUjQEy73fll9T7J
	Os2uYyTJXBn695tjMAYn51D4Y2JIHpEBIP7CefKjA8dZx257jIVmqx/iRHTHcokIQ1zsbq
	WlTzDqHAF8Fw8lBZx5qETVU+r+z5y0c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of n.schier@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=n.schier@avm.de;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.53.4)
	(envelope-from <n.schier@avm.de>)
	id 6882306e-1808-7f0000032729-7f00000189dc-1
	for <multiple-recipients>; Thu, 24 Jul 2025 15:09:02 +0200
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Thu, 24 Jul 2025 15:09:02 +0200 (CEST)
Received: from buildd.core.avm.de (buildd-sv-01.avm.de [172.16.0.225])
	by mail-auth.avm.de (Postfix) with ESMTPA id 0973680A49;
	Thu, 24 Jul 2025 15:09:02 +0200 (CEST)
Received: from l-nschier-aarch64.ads.avm.de (unknown [IPv6:fde4:4c1b:acd5:6472::1])
	by buildd.core.avm.de (Postfix) with ESMTPS id 6DAEF184464;
	Thu, 24 Jul 2025 15:09:00 +0200 (CEST)
Date: Thu, 24 Jul 2025 15:08:58 +0200
From: Nicolas Schier <nicolas.schier@linux.dev>
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-hardening@vger.kernel.org, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>,
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
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
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
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	kvm@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, kexec@lists.infradead.org,
	linux-security-module@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v4 4/4] kstack_erase: Support Clang stack depth tracking
Message-ID: <20250724-optimistic-armadillo-of-joviality-e59222@l-nschier-aarch64>
References: <20250724054419.it.405-kees@kernel.org>
 <20250724055029.3623499-4-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20250724055029.3623499-4-kees@kernel.org>
Organization: AVM GmbH
X-purgate-ID: 149429::1753362542-BED92A7D-5329B415/0/0
X-purgate-type: clean
X-purgate-size: 870
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B622F20018
X-Stat-Signature: 36nhjyxynye6533649d4t91tiucpufqm
X-Rspam-User: 
X-HE-Tag: 1753362544-950083
X-HE-Meta: U2FsdGVkX1/se5Zotpvdh2ESayVvImPX5qOfGDMiLzXLOOnvXII0WWmf81iqIfwXBp5MUvxVQsUzTSYMnxRyRTx0ER1E+Jp+eeetkvYiG6jSfhheqsAYMEM0H9qbcHRMysHTQ1GhvYoCDKEiAHs0JCs1eWoRDE9Qp+hbbS0fZq7SNFviBom9//LNP9NrzZRt+E/yEfeQPemq2d7pvRZR5YUqoAaApCZY3PwZsikrRcw+fewM/Mt9IG059BL0T9OlWQIYXj79VNBxSYW5rDkUsUcHrTO9JqTKsDmQStsE6B1XhtrbKGC6yAsMfJQaa0IubB8fPYnRPrj3vYIG1Eq/VfIZ2GCB5lfnvonErjiyDSgEOe/SwwUqRgswvqED23ccJn27gMf8hcriH+dAmm0HwUwan82EuFWWk2FToiVIA/YhxHAQX31CIyialuT/PffsZTHpWnWuRFcIgb1fwvD4FpL1wpe2CZODpcstzDMd3+FVv3PKUictGop3OYaaym11DrrFmYb8B6pW08PmWQ0QnRvnE/Id+NOF8OS2ikw5ErrB4xxPpqnCQhfJv4HzW1VXJYWPTQZ/6MmzMwHNecj007muSHIYc9BaPWLI3ta9PSCNZ6zq4XLGDo79Ke/hDJ8cNOecX6Lwl38OoCgCDqP3F0R+OtWRcvH2QICcxd7pasJNdFJcLUjniwH5S5nh/epGJ/uy3CFDGvrdELLqfldzYkqrKMkAnmcpQ4cGwn/Q55/RDfRoWlgZFDDiwVwvxvs8Tm62gfD1lM7Qs67bPw2aetxKw5JGJobvO4WhRzQ8HqFCAOR7vm9zRi86YoxF4/Uo/3ioFrJjSSa3uDy5rfpSLgC15sU3DgoSaxJuye2sXakVNd9tJ5nqWXZV3NMZOXbI+AbkWAFBt5Q4SaU4w1eZBjseFjW1EIYAbpzW7Bl7ENHiJzOXArAPm5mpKUG/UOWaHqUhKdTVEyVIEbC2yU7
 ugQaEq1I
 YMA32d63zIaku3HfPn42L8x0ePSbN50SsSg6uQC7xP4Vaz3A79zXvl0TSWs7DHgI2bfe7A5cZ2W1W4am9oghmodImbmdISuORc9igsGB8J+JuEYQQ9+F3L0M2xW3EBbd8TKAH8ouqa3OXnCg9iOQD1yRJ4sDYLgzc/vNi5zHEOkCEXjbYIpVCIt1hM6XwiK/wUQ/HofDciJHfL+SGQ678pjFFxfk3E0pJrB8hrRTWUo4im/GIYiA2eV+u1zczx71jUCQCAaKJJ8d+JeRkI4ECqTT2ighlxedKMUcyDcus4TriSWcNBWcG3C4vl8R4qWQSYBcB/v1MqryXP4rSWrK6pDlPTvrzVG7DNnstffxGeViO3V8Y8s5Oqp1ZB8TT/lq+JmL9K9Y+v1EfO9Ms+tovgjwVFBwwaXMVMvR0sJnfVfgzmc/ficU3R4W8fSs2X2jwKETO5Syb3YRII2N3fT3XT97JK9/fsbh5jABa7T5h9kfx5e2ODZrEmftEeztghEKOhJ67pXt7mQvJnNQnkkNgZ8gGRxKEDL3x/sOjYbhY0dIa89PcG9gP90qGXvbJe9HSNtfdee9ITDFqf9eVrJ5p4x+Xk3cpBhEfM26qkUjOpANDxB/DqPdgvyCBGo2dP315UPj+/s1+qC1+Ut4pODaiwwVapIsRtR+JT+pB1tmcS2AHENgY85mokd8sSDVt2pGSEjdtYIxNNyiAxZBABqh5X+HqESk9s+RfaJLlGc8BqCruI8969gq7ANyUv+iuG8teILbViVgyyJTxtYIoacis0MoPhPbDW+R++qoOGSO3c3xkwVjxZ7PZolBRRSlWb1D2b422iAQCMIYTTUMNpTNXDN51Uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:50:28PM -0700, Kees Cook wrote:
> Wire up CONFIG_KSTACK_ERASE to Clang 21's new stack depth tracking
> callback[1] option.
>=20
> Link: https://clang.llvm.org/docs/SanitizerCoverage.html#tracing-stack-de=
pth [1]
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nicolas Schier <nicolas.schier@linux.dev>
> Cc: Marco Elver <elver@google.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: <linux-kbuild@vger.kernel.org>
> Cc: <kasan-dev@googlegroups.com>
> Cc: <linux-hardening@vger.kernel.org>
> ---

Acked-by: Nicolas Schier <n.schier@avm.de>

