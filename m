Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AAEC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F508E0047; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7518E0046; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CDA8E0047; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F02038E0046
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:50:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8F551306BF
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:33 +0000 (UTC)
X-FDA: 83698083546.27.130419D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 07D59140006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d0/TMlHJ";
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753336232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C2VkXjr1vmtMoAwGuzNgZ6GgP6+IF/LpC6JdENa6i7Q=;
	b=50/EIfhfydv4QOuPZTKwTpKvwdI/Ermprz8Pa2S/znEuYcniPSnDyPxVRI9x4v85a0B8v+
	Qv5JUyyhvndROkAlBfgNJDjGgBR26RvF/DpsUihCIZjqQTXEFIeLbu+0lLc2Guu2vIa4CX
	yoRZZAfZP3rdocWqSlLQ4QbT+nl6XnQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d0/TMlHJ";
	spf=pass (imf09.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753336232; a=rsa-sha256;
	cv=none;
	b=yFv7OA1p/hVFibFvt2m2p4PR52sZZwZWGoiJaedKXY8FN1my6Ye2UY9wTvQpRXQWELD6Ro
	nuIwq7RhYYjAAl5pFjcAaXaNYExQayEy1OuGJGOgDxlS5e971V0qwTqEFMMBlHn1KZrRw4
	gzd2UdyRIL0CnIj/WuQHpxp12P5nXv0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A584B46522;
	Thu, 24 Jul 2025 05:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED8DC4CEF1;
	Thu, 24 Jul 2025 05:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753336230;
	bh=XE3wpC5OKAVRvxdPiqi/2WsaLPvDes1ay28krOB8Nyg=;
	h=From:To:Cc:Subject:Date:From;
	b=d0/TMlHJD3g/KJWGAgQ/f/vsSu6dz+U/wQhw7RJ+hpjI1X/Sb0vKcWNoCHtrHbwiT
	 fH44GGf8Ya+PkaTReniUuYLdOVN2Z7VZtAILtvfvcjiAgUuEzQ5NtxiABxovHh0dhh
	 CjjXTbcKODbX01+IxIuANaBudNKSlp4sTNUtj/Dm700M2Xeul+T3LNAq2Cwpvn93hM
	 3mtHpKM4dxgJplW4BiyL41PLzD8gk1AUnlrUjfa7EyvQF15EPpx30bWI4LoLGEpTl8
	 AnYSr9DuaqtX57N9wGYm/6ZnjhE8O4TTw5SsPmlN/kayzZrdvOKdlCPjUMa8a9ErZI
	 bpYkRhkl38Olg==
From: Kees Cook <kees@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Roger Pau Monne <roger.pau@citrix.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Usama Arif <usama.arif@bytedance.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Huth <thuth@redhat.com>,
	Brian Gerst <brgerst@gmail.com>,
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
	Andy Lutomirski <luto@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jan Beulich <jbeulich@suse.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	kvm@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-kbuild@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v4 0/4] stackleak: Support Clang stack depth tracking
Date: Wed, 23 Jul 2025 22:50:24 -0700
Message-Id: <20250724054419.it.405-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1439; i=kees@kernel.org; h=from:subject:message-id; bh=XE3wpC5OKAVRvxdPiqi/2WsaLPvDes1ay28krOB8Nyg=; b=owGbwMvMwCVmps19z/KJym7G02pJDBmNJxc5mZrpNj5K4tORy/7TeZXhw9upF18pr/M4P+mO0 qJ1Zxv/dZSyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAExkx3ZGhj3Lo9RPfd61sO3K 6ZOX39cZ7GLmn/6vehbf2xvW83qXM01nZOhJWph/qli05kP325oNd1z3S2krH/3OsOnxZQ05w52 HynkB
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 07D59140006
X-Rspamd-Server: rspam06
X-Stat-Signature: g65c7bf57y3t1xbz8nhfh7fq6pmh8nqw
X-HE-Tag: 1753336231-372088
X-HE-Meta: U2FsdGVkX18dyxRQwIjZenG96GGzBR7SygWK2pTaULyepA73e2DDW0x7yYSv9MuMJC9gP+sIA6HkOyNda1v3BkR1qOXIEan1+FVG9HGfHw22czR68ep11Lsgi8/DgBVr14CESgiZ3MDDxJk9ea+MAManCRvuzSfZzK0OprD3swDM+THBH8ftFBcY/2oIS71f+NjJED2oMF2lj4qAvDoW4vHmtLH7JyWl4/xcalMZjz/kQHeuOJq6yW20+zcu3WzYm/XeEoFKWiZnAYORlfMQPvCX/1cVo0bu0YCO43iLHuYP59/1B7FljbujIItezhxJjxdoNPrPnbcFt2dSM27kBRmmaQDuMzxENoxgwSeDq39MgtEVPClc0fwVrWkbpX0dpxVveTnziAOmoazKNjRj2xUxKVIy3wkqrmSXfJLXxAZcXzbOarnDgSa6xbNfKx6OWfahXhDAklWI1iYXyqMpLSz/s0VKop/t6lQLwKuUhvg0Lqig2TP4x3GZwDHC74jQaH00UxeJQWEl1DGcw5efKC1/esFBBQ/EuqKWe6I/fn35wyzWQdjAs6Lqs8e64rpEjIkPK5sUnQx+B+Z+5edRTLY9z66an90V5xyh1uwewYuPBvANLhNUIsXyUTdUdQ/FuwVnVNdl51yYYzoEsrudlKS+q6t0h2lRTZcplaaRzv5npMkema88wBbKJobQVS0Clb9SkskDy++VpFyZKEqcVEp3ZxTARPzN0iWBlPYiid/xyy/5HqMlWbwgkdmTvjvrNQ0XCAPe82Pqc8m5+aq4N0mraH09hyujZdwrwF9xB/Xue9LlNxZFns9GB8DSv/9jmwaxy7uzKiTq6mloEONGExcgErIhWUIMwr/sZNonTUNsekDbLAdPW6jXnVnOxhK4E0p689DYGd/zWWy/DI2BSx1jLf9bdeYbPzOH7Lcke17F9Adqp+e8HhMBu2RS1WOnm52hWgGPoVHyXEFE3dD
 dHfAde6x
 QUdwpeOYnRnEPuZOOBdfaSw4XTAYEvbnoiYIFWLwuAyoLsigUw94BKPtviPCJmnJ9n6KjxLy0wHHmEfRuCFgSHG3avoHP5gteIdq11CP5gObIqplbqk+pGh+6wXXuTeMtOR2tLEH+4fBKenXbLDYzPp+1ZwrrRZwNAHBsLA36Mod+sUC9g0Dfan+MB+5rFR6R1QQd+Rmr9asN+Rf+8zdw9DhpgUVTyARzD1AK3SuWueMrGk8I+m/bgf2XT+c1A8ZkNoOzDQZBPDRVK/cYxmmYg8/KOYhIZWtso595kVAhU4lU9ETtEiBvj1GmYClINRXM1c7ks1s41zHxZs6oLStBEqiyDBQrt9DGZZLUo2P7ZpWAMik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 v4:
  - rebase on for-next/hardening tree (took subset of v3 patches)
  - improve commit logs for x86 and arm64 changes (Mike, Will, Ard)
 v3: https://lore.kernel.org/lkml/20250717231756.make.423-kees@kernel.org/
 v2: https://lore.kernel.org/lkml/20250523043251.it.550-kees@kernel.org/
 v1: https://lore.kernel.org/lkml/20250507180852.work.231-kees@kernel.org/

Hi,

These are the remaining changes needed to support Clang stack depth
tracking for kstack_erase (nee stackleak).

Thanks!

-Kees

Kees Cook (4):
  arm64: Handle KCOV __init vs inline mismatches
  x86: Handle KCOV __init vs inline mismatches
  init.h: Disable sanitizer coverage for __init and __head
  kstack_erase: Support Clang stack depth tracking

 security/Kconfig.hardening      | 5 ++++-
 scripts/Makefile.kstack_erase   | 6 ++++++
 arch/arm64/include/asm/acpi.h   | 2 +-
 arch/x86/include/asm/acpi.h     | 4 ++--
 arch/x86/include/asm/init.h     | 2 +-
 arch/x86/include/asm/realmode.h | 2 +-
 include/linux/acpi.h            | 4 ++--
 include/linux/bootconfig.h      | 2 +-
 include/linux/efi.h             | 2 +-
 include/linux/init.h            | 4 +++-
 include/linux/memblock.h        | 2 +-
 include/linux/smp.h             | 2 +-
 arch/x86/kernel/kvm.c           | 2 +-
 arch/x86/mm/init_64.c           | 2 +-
 kernel/kexec_handover.c         | 4 ++--
 15 files changed, 28 insertions(+), 17 deletions(-)

-- 
2.34.1


