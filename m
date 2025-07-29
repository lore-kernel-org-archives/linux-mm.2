Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2F9C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECC28E0006; Tue, 29 Jul 2025 05:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4CD8E0001; Tue, 29 Jul 2025 05:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165BF8E0006; Tue, 29 Jul 2025 05:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 03C138E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:35:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 829961DA6F5
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:35:55 +0000 (UTC)
X-FDA: 83716795470.13.25A714F
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E6F540016
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:35:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=SefSK9JI;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="d cWL30Z";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.140 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753781753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//ORI/NIeaAxh1YrBcckAswwPCVYsSmGgDQbyUkZAq8=;
	b=yx+bsUF4vetqWkYMX0pJZFQlHDQyhp7O3sUMCHVbF1X1gZD4Blemr/e7HvlyJZ58gSonBT
	AU2YS6UYk4qB0zWcEkKjKrKxvs0REJZnESLo4wjFRXhbEEoktWdUk90mk6jOV6uNYr0ikD
	6Mv9oD35XMMyrHsfaWFDqr+cJrwHpFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753781753; a=rsa-sha256;
	cv=none;
	b=V5SxCsJVItd2GKwBvSDV+4R8XbX+vreS9a2TRLLuUo4tqnXESvsmHg306wFzyLLgbXRTJL
	fBi7tYMWtOUfgxNP4257rpRJaRgyZRcnU0PP6lXfNzI3znA/HTipgwuN/K61wGvtJ96vMu
	WpYRbgMrC1Hk5AETXRishNVr/kCJWn4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=SefSK9JI;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="d cWL30Z";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.140 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 282E51302005;
	Tue, 29 Jul 2025 05:35:51 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Tue, 29 Jul 2025 05:35:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1753781751;
	 x=1753788951; bh=//ORI/NIeaAxh1YrBcckAswwPCVYsSmGgDQbyUkZAq8=; b=
	SefSK9JIsPyLojssh4E+CqFpbV+Zap40TMGfPWb3aWEWeGFb4g0cGHCAmmDYpOWJ
	S7G69WuBYfrWpj/UCtg8W+VPwYU3GQLija0V8+2lYOBGO4TRSEGu9OI85XNbZUaf
	n3WPbIwb5punMxifW87/BK7JHvwx6wPLyISkqWSo7MSI2u9KRjONLkvZ/AUSV3ZO
	Ahjh79PM/3iHQMMxxK5qgviVacLMQLWeglWmZpgB9lLtCWDN07H58fqKKAy2FrSa
	3FZgbRrVzBIG9YCWMU+BxJxkrjCiWFDhVUXhyoNSoyYFrr+6DuOPmt+tcZSy6i4u
	sUwky5I2FTkrR7Z3qIKcag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1753781751; x=
	1753788951; bh=//ORI/NIeaAxh1YrBcckAswwPCVYsSmGgDQbyUkZAq8=; b=d
	cWL30ZcphojleEZOg49PAdrKftGu1gEZJaryOWTyphxVDz6Sov20aONDwNwlOjWo
	v/KDecN74u5ikT4Jf2NNlGMVepGHR1DLw5nvSPEeuZVEZATLFtoBtozr1lplEG4x
	jAac6+9JGI2hNrPH6+ItB5a6wBIKu0YtfFjp0lskjiZ2gVgRruDWnmGCbx4mtnvs
	kONdETl5GMphdcvCbFJJfgVtef8ito0597cRb0r8dQqywM6mzQt5A1vXNPidP+Ue
	1m6mSFIciFAncnMEPhzjZ91nRSGI96HawMYxKCJIrZ6CARnB5Wj/2EB8gHuxbJd7
	ntKOseLPVaMLuv7cphcKA==
X-ME-Sender: <xms:85WIaMSdGeQUGSWiZhLdfx2lJ2mSTS7IehTipzI8wt2v51LJCX16QQ>
    <xme:85WIaJxgTNOs5oElfHTSY2AEYjlrQwVHJZaKe-7EAi0lzxzNaEeVgBrJT6vSi8wjW
    LT2PNORziXGfT5G4H8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdelgeejudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeehtddpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepugifmhifsegrmh
    griihonhdrtghordhukhdprhgtphhtthhopehgrhgrfhesrghmrgiiohhnrdgtohhmpdhr
    tghpthhtohephhhouhifvghnlhhonhhgrdhhfihlsegrnhhtghhrohhuphdrtghomhdprh
    gtphhtthhopegrnhhshhhumhgrnhdrkhhhrghnughurghlsegrrhhmrdgtohhmpdhrtghp
    thhtoheptggrthgrlhhinhdrmhgrrhhinhgrshesrghrmhdrtghomhdprhgtphhtthhope
    hjrghmvghsrdhmohhrshgvsegrrhhmrdgtohhmpdhrtghpthhtoheprhhmkhdokhgvrhhn
    vghlsegrrhhmlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepuhhsrghmrgdrrghrih
    hfsegshihtvggurghntggvrdgtohhm
X-ME-Proxy: <xmx:85WIaBg7DA5uE80TwTiALrCzrej-0WgEHArKmquSwrXZjnU_QkHjTA>
    <xmx:85WIaDuZyOtGTHzz9bt_zPfC2qi8OrDyaJph1YM8cz3Q2pyWkFKbIA>
    <xmx:85WIaJInB3n0SkqGw796UfROaiDbKXXRWu3O7x2Xa33TjPnJPwVAIw>
    <xmx:85WIaOrnoUdsZpkoMcDfVOZN4XnTcRVptWOuf5XhqRCWibFXNKnQJQ>
    <xmx:9pWIaGmo_XxnnYEJX4gT9GDpjIrX6lXqryh7rr9LZTo_B0167GYZAeVZ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9F298700065; Tue, 29 Jul 2025 05:35:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: Tf1c1d2456aa020de
Date: Tue, 29 Jul 2025 11:34:57 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Kees Cook" <kees@kernel.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Mike Rapoport" <rppt@kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>,
 "Vitaly Kuznetsov" <vkuznets@redhat.com>,
 "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
 "Hans de Goede" <hdegoede@redhat.com>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "Rafael J . Wysocki" <rafael@kernel.org>, "Len Brown" <lenb@kernel.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Michal Wilczynski" <michal.wilczynski@intel.com>,
 "Juergen Gross" <jgross@suse.com>,
 "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 "Roger Pau Monne" <roger.pau@citrix.com>,
 "David Woodhouse" <dwmw@amazon.co.uk>,
 "Usama Arif" <usama.arif@bytedance.com>,
 "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Thomas Huth" <thuth@redhat.com>, "Brian Gerst" <brgerst@gmail.com>,
 kvm@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
 platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, "Will Deacon" <will@kernel.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
 "Gavin Shan" <gshan@redhat.com>,
 "Russell King" <rmk+kernel@armlinux.org.uk>,
 "James Morse" <james.morse@arm.com>,
 "Oza Pawandeep" <quic_poza@quicinc.com>,
 "Anshuman Khandual" <anshuman.khandual@arm.com>,
 "Hans de Goede" <hansg@kernel.org>,
 "Kirill A. Shutemov" <kas@kernel.org>, "Marco Elver" <elver@google.com>,
 "Andrey Konovalov" <andreyknvl@gmail.com>,
 "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Luis Chamberlain" <mcgrof@kernel.org>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nicolas Schier" <nicolas.schier@linux.dev>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Andy Lutomirski" <luto@kernel.org>, "Baoquan He" <bhe@redhat.com>,
 "Alexander Graf" <graf@amazon.com>,
 "Changyuan Lyu" <changyuanl@google.com>,
 "Paul Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>,
 "Jan Beulich" <jbeulich@suse.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 "Bibo Mao" <maobibo@loongson.cn>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com,
 linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
 kexec@lists.infradead.org, linux-security-module@vger.kernel.org,
 llvm@lists.linux.dev
Message-Id: <f8bcf5ce-8b8b-4555-a210-14e1974eac92@app.fastmail.com>
In-Reply-To: <20250724055029.3623499-2-kees@kernel.org>
References: <20250724054419.it.405-kees@kernel.org>
 <20250724055029.3623499-2-kees@kernel.org>
Subject: Re: [PATCH v4 2/4] x86: Handle KCOV __init vs inline mismatches
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5E6F540016
X-Stat-Signature: bbbi4e4iw4ueru9fybzdj71cdma7dcnp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753781753-397282
X-HE-Meta: U2FsdGVkX197XZkXESLyjN6R4/KWyoeZ4+UJXQR9ojjT897plvrKR/pskwhB+m54q1q/PuVms94/1929XeuFmzJpgzichiFWSMcpJb3IiRcp+Dbkefq7uDfKLzdKsvU3cHseNzWWdrR6fDtM5A+U5koqvAD69EnGq/LIUORrDxQJxabrXh8CkEtanmkF1/opY7sv4BvrMoLft+RkQLIoNrBSkDASgwO5hTMsGkIik0PZoc11OA+wXkMQXTkL+ujnwumnkh+ncn+/39RcqsXgLLqUx8SzHwWzgsjelvR4RmtGlDNCy8jLjZupxDLjTxinHzlRxmaJ7fDrP6p+h81B/SxbFmREaHp5ZiyrMRfSxG4c/B0+Fo0PbKknj6F8su9k1RrlPIfLPvdFbw0PyvytzKQTrua5Xx19OSsANz8C/onT10H0asFuN+Axv32ojKSo9TVRInJPQ/Q2PhsNZayWSSpmruJSeUgkxRzP4D9rq4MTq5yPE6+pflOrUCHpJrwFlpZLJR2YIelfJj5TPWPzTu7oJ4maq4fXRX9vFx5UFxGh2+i7lV+mkSqOnZuDK0A0l7s8OkO8rS0AHWyR6Y8vFbaKG7vbqkarzuYpOsMGUax3L4al26iWXt+0/xcU5CQ+c/LBGHj1eSFw+NTjp1nxVHtmI+JQosST88SQpTE8X2kObPL7eVnyKV5jtPJU5L5AizZcqSoDgPqYkrHUnysGDw/euvrClLtgqR1wEQmsqxKtOdoscjfgJOUExti08NDcT/h8cj6WvGCD/ml5eAiPDZuRCx9md10G0XQbe7kzXroNFL0lYi2FwhiO2fl0fxAwa14QaihOtDN8fSUAoWE3iohkgfTfyOLvtpsPofFzInc3hDjEnAeLsP4GfpeenEyxgZQ9uuL5ab61eYTfA7XpHzuZCTBgNObr6ICdeHyf8c2U/8YMaiBAkB626ThjlRDeqW8aVoY3Fnro/F3pOta
 X+9KNL5J
 oJ5aojfK+39AAkV2hvhBN+rE47Ra+F7L1uQlkmSSGzTzBJjjL+8DkxeLwpI5/Q+ZaRyR6KQ88QSOFUw7G55EW3cJmfwgdfFpQNgxdyxrflfeDWHcD6d7IdkFm5OfNxKF8YPRxjbto+od264hYCm36Va9EYgI5Vbo/P64vh9fB4rEzIROuOkJYs/CtDx4vASNPYa4msNVEA3+0UWZQin1nmORc3lQ9ncPt0QSTos4Ghv5l0A4uH6ihLsKT0+ivnHLzxDn4Hrh3nUSk5cMrbtM+Odf2OYfkydz6QICdNvFlzpYD+iD9h9+BC9xvWzM/aQTD0y9yXMFEnxS/PPROVgt1q4l+XQA9k1m6T0v2XqXv9/w4lRtPL3/eOLyD+rfxKcAFwiEy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025, at 07:50, Kees Cook wrote:
> GCC appears to have kind of fragile inlining heuristics, in the
> sense that it can change whether or not it inlines something based on
> optimizations. It looks like the kcov instrumentation being added (or in
> this case, removed) from a function changes the optimization results,
> and some functions marked "inline" are _not_ inlined. In that case,
> we end up with __init code calling a function not marked __init, and we
> get the build warnings I'm trying to eliminate in the coming patch that
> adds __no_sanitize_coverage to __init functions:
>
> WARNING: modpost: vmlinux: section mismatch in reference: xbc_exit+0x8 
> (section: .text.unlikely) -> _xbc_exit (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: 
> real_mode_size_needed+0x15 (section: .text.unlikely) -> 
> real_mode_blob_end (section: .init.data)
> WARNING: modpost: vmlinux: section mismatch in reference: 
> __set_percpu_decrypted+0x16 (section: .text.unlikely) -> 
> early_set_memory_decrypted (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: 
> memblock_alloc_from+0x26 (section: .text.unlikely) -> 
> memblock_alloc_try_nid (section: .init.text)
> WARNING: modpost: vmlinux: section mismatch in reference: 
> acpi_arch_set_root_pointer+0xc (section: .text.unlikely) -> x86_init 
> (section: .init.data)
> WARNING: modpost: vmlinux: section mismatch in reference: 
> acpi_arch_get_root_pointer+0x8 (section: .text.unlikely) -> x86_init 
> (section: .init.data)
> WARNING: modpost: vmlinux: section mismatch in reference: 
> efi_config_table_is_usable+0x16 (section: .text.unlikely) -> 
> xen_efi_config_table_is_usable (section: .init.text)
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

Acked-by: Arnd Bergmann <arnd@arndb.de>

In my randconfig tests, I got these ones as well:

WARNING: modpost: vmlinux: section mismatch in reference: early_page_ext_enabled+0x14 (section: .text.unlikely) -> early_
page_ext (section: .init.data)
x86_64-linux-ld: lm75.c:(.text+0xd25): undefined reference to `i3c_device_do_priv_xfers'

And one more with a private patch of mine.

These are the fixups that make it build for arm/arm64/x86
randconfigs for me, so you could fold them as well in
as well. I have already sent the i3c patch for upstream
but not the page_ext.h patch.

--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -57,7 +57,7 @@ extern bool early_page_ext;
 extern unsigned long page_ext_size;
 extern void pgdat_page_ext_init(struct pglist_data *pgdat);
 
-static inline bool early_page_ext_enabled(void)
+static __always_inline bool early_page_ext_enabled(void)
 {
        return early_page_ext;
 }
@@ -189,7 +189,7 @@ static inline struct page_ext *page_ext_iter_get(const struct page_ext_iter *ite
 #else /* !CONFIG_PAGE_EXTENSION */
 struct page_ext;
 
-static inline bool early_page_ext_enabled(void)
+static __always_inline bool early_page_ext_enabled(void)
 {
        return false;
 }
--- a/include/linux/i3c/device.h
+++ b/include/linux/i3c/device.h
@@ -245,7 +245,7 @@ void i3c_driver_unregister(struct i3c_driver *drv);
  *
  * Return: 0 if both registrations succeeds, a negative error code otherwise.
  */
-static inline int i3c_i2c_driver_register(struct i3c_driver *i3cdrv,
+static __always_inline int i3c_i2c_driver_register(struct i3c_driver *i3cdrv,
                                          struct i2c_driver *i2cdrv)
 {
        int ret;
@@ -270,7 +270,7 @@ static inline int i3c_i2c_driver_register(struct i3c_driver *i3cdrv,
  * Note that when CONFIG_I3C is not enabled, this function only unregisters the
  * @i2cdrv.
  */
-static inline void i3c_i2c_driver_unregister(struct i3c_driver *i3cdrv,
+static __always_inline void i3c_i2c_driver_unregister(struct i3c_driver *i3cdrv,
                                             struct i2c_driver *i2cdrv)
 {
        if (IS_ENABLED(CONFIG_I3C))

As I understand, the underlying problem is less gcc inlining
being fragile, but more that gcc does not inline functions
when they have different __no_sanitize_coverage attributes.

      Arnd

