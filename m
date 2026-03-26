Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484DA10AB827
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 21:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9876B0005; Thu, 26 Mar 2026 17:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AAB96B0089; Thu, 26 Mar 2026 17:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172A96B008A; Thu, 26 Mar 2026 17:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 015B16B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:13:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F1975D0A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:13:23 +0000 (UTC)
X-FDA: 84589465086.07.EBBE5F8
Received: from flow-b1-smtp.messagingengine.com (flow-b1-smtp.messagingengine.com [202.12.124.136])
	by imf07.hostedemail.com (Postfix) with ESMTP id 78FCE40009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:13:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=h6asKu9U;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="O XCrFmp";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774559601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pjb3URkbbR01eXdGvkmTKg9j6MWjYnJLhpcHkswgr8=;
	b=nGeGUtzM+6db4VTL6H/yDXcFRJoe3bJ0IrLwbFIMluV1j7W1d796DPvrJ4Y9P2aO3GsGoY
	2s8dkYfxW3Uu5lakave4mMS9wPElttcIF1CclWCr+YOFHpY/qC0gYP1WWBsZypMdOGZtw0
	nO+/TzV2Xjyq30eAEgajD2YAqBONUPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774559601; a=rsa-sha256;
	cv=none;
	b=PYrBTKpUp6B1JnyFCAlhBCwXWZdtzEPvd/WufUGU11olqWcULRQl9YJkts3RFXRrghK9G5
	s9iNM9QPsqfC3lfu0KJERWWXI9d8Wp9dUbykPmk7zd9rjTOEhK1aqMkYL4vCZOdE8YOj8D
	o8yajOGllcv1P1UcOZbC8NK+GD4faTg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=h6asKu9U;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="O XCrFmp";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.136 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id F135613000B5;
	Thu, 26 Mar 2026 17:13:18 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Thu, 26 Mar 2026 17:13:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1774559598;
	 x=1774566798; bh=6pjb3URkbbR01eXdGvkmTKg9j6MWjYnJLhpcHkswgr8=; b=
	h6asKu9Uks25ifOvsWbdAJZSoSzdSq9ur05qS8lnhn9V/7eSdAB2i7oILTnWk05h
	a1Bd7UiTH53pYCRbXfVFE7SEv1wQWMNzz4DQi9QvV1PDSBcx/dwPX2MtAshG6h9s
	uNvT/JNFfEKe59zeVqppgigdwUzitymd/Yh/E2tFdqDDeqv4j+G/9aGkQh6Fe+s5
	midsXRlD2K/MuIyiAFPpc2orO7JtJLzKRjCAs7k/miWaYl7rwmoPqaM+8FnMGApS
	yTq/OCHm/mm0DAuonaZ6+v92mbvkTMkShEEMhNkCWquTmCcLIuq6HvzhGZdBaatc
	UOByiv+8LC9UuODYhXbuYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774559598; x=
	1774566798; bh=6pjb3URkbbR01eXdGvkmTKg9j6MWjYnJLhpcHkswgr8=; b=O
	XCrFmp0xOx34V+/K+8Az+IxDwAi0L+d5/ghlz5sW2+v5K5TS/Lmw18CzE2aWaDD1
	lUCrX1ge/MGkGOijz4Gid3J3VilT7GgYu5MrTH1NSW4+cRxywYAXIV9CywX9qOsi
	iXHdqq7t3yAqpK/xcBjDu1Fw2LvYf5SdkPS07TRs94A7pp5MplN7/hvYHpF2nGWk
	7VUmVMTVHMmIfYxvn1VT4X+9KSDvLPyocrwABTjv9Hwa2D1w/OdJiewf0PANvYUE
	om86o69UMnG81/maqi5puEjUwhYy/jWqIWYka2xfUupH1/auvrOn0cFXjmEkRFzP
	h8zv2fuqgRd/pV4lc+zKw==
X-ME-Sender: <xms:bKHFaS1M2gDWqgSSjr5TTWzG-0MpiTpD6ijnhoWWMcY4y66zpocZYA>
    <xme:bKHFaf6wbZjHiirlgQKu81zSxSJGhzT7vY8geF5gvIGBuYCkhLC37Y23WHblY5xQ7
    dxjJ-ftXhETnPmcdwb7w0yJtIxQdqKZdkpht41Z4pLBOsy7HKWqS2E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdekgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepgedvpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehmrghrkhdrrhhuthhlrghnugesrghrmhdrtghomhdprhgtphhtth
    hopehrohgsihhnrdhmuhhrphhhhiesrghrmhdrtghomhdprhgtphhtthhopehlihhnuhig
    segrrhhmlhhinhhugidrohhrghdruhhkpdhrtghpthhtoheprghnthhonhdrihhvrghnoh
    hvsegtrghmsghrihgughgvghhrvgihshdrtghomhdprhgtphhtthhopegurghnihgvlhdr
    rghlmhgvihgurgestgholhhlrggsohhrrgdrtghomhdprhgtphhtthhopegurghvihguse
    gurghvihgughhofidrnhgvthdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgv
    thdprhgtphhtthhopegrsgguihgvlhdrjhgrnhhulhhguhgvsehgmhgrihhlrdgtohhmpd
    hrtghpthhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:bKHFacD0ra2IKewOzV85-guaMKbD70dENWsy-p75QsHo1Yk0z9Nn_g>
    <xmx:bKHFaathmkCZaZCL5hDPhlvL3BEdEuWC-JUBLqLCWV9m_v1HsxUVmg>
    <xmx:bKHFaWue742_u7hiwisJ5WxIf99QUzzi0Dr0SkABQDBOjBgU5pdtxg>
    <xmx:bKHFaeX3iXr1bIB49LOaucusKHBGCI8-g5rftWB0rU1MNmzYPTijsg>
    <xmx:bqHFaY1IWjdkzpMo1o5XFVQetaAAt7u7flqJ1LRde5SJaQlj3ZPuM0gR>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B95A4700065; Thu, 26 Mar 2026 17:13:16 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AUJnWW6OA6Vc
Date: Thu, 26 Mar 2026 22:12:24 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Miguel Ojeda" <ojeda@kernel.org>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Robin Murphy" <robin.murphy@arm.com>, "Danilo Krummrich" <dakr@kernel.org>,
 "Abdiel Janulgue" <abdiel.janulgue@gmail.com>,
 "Daniel Almeida" <daniel.almeida@collabora.com>,
 "Andreas Hindborg" <a.hindborg@kernel.org>, "Christoph Hellwig" <hch@lst.de>
Cc: iommu@lists.linux.dev, driver-core@lists.linux.dev, acourbot@nvidia.com,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Alice Ryhl" <aliceryhl@google.com>,
 "Anton Ivanov" <anton.ivanov@cambridgegreys.com>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "David Gow" <david@davidgow.net>,
 "Gary Guo" <gary@garyguo.net>,
 "Johannes Berg" <johannes@sipsolutions.net>,
 "Justin Stitt" <justinstitt@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-um@lists.infradead.org, "Russell King" <linux@armlinux.org.uk>,
 llvm@lists.linux.dev, "Benno Lossin" <lossin@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, mmaurer@google.com,
 "Bill Wendling" <morbo@google.com>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Nicolas Schier" <nicolas.schier@linux.dev>,
 "Nicolas Schier" <nsc@kernel.org>,
 "Peter Zijlstra" <peterz@infradead.org>,
 "Richard Weinberger" <richard@nod.at>, rust-for-linux@vger.kernel.org,
 "Trevor Gross" <tmgross@umich.edu>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Will Deacon" <will@kernel.org>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>
Message-Id: <7ad8bdf9-5eff-4443-ad15-c05355d793d1@app.fastmail.com>
In-Reply-To: <20260322194616.89847-1-ojeda@kernel.org>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260322194616.89847-1-ojeda@kernel.org>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 78FCE40009
X-Stat-Signature: pnhd8e5cnw9tttji3iyz57boembnq8qa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774559601-432028
X-HE-Meta: U2FsdGVkX19BeJctSX+S04agnn4W/wIQOvkRcNX0Ggqx3ofFMBxTpORQgUSvfrrcPxXziIPVLeAgGXWpUkFbSQpNANZj4fNnPpT4+T+t0DhS0BwtB1gWU7xzdhKxNDX9WTLqmxnz97lEpsSQts2Y37nOi7XStnjytTNthAowPbuEONzlsbfgZvld5VTiT+7OviBgO05T2aQC2JEMe3ULXl8PUJ9KRwkdRQg8vKVoyU0feSCMvFZMaMbuhNSpSTO/QVI8sBXi5Hw+2Sijq0SjMMydpAcU30EpNsITYamI9BtfoC1AUfd8NJq1DR96AjpSFs8K+hC0JmoXx3nh0Th69ovrMujfq1peqaHDokpd8H/m5RJ9NusQqEQn4ZRkLMpeVgVDKqBXrGKCsw7jo+S5VrbyD806JqJZGrqEXb5jzhmV9tcgJ6bmNA+KjlgiBHk1dnu6OsSwkM/WwtYIwSYnNGHO4BiQ1f0X6V4RCTkSsOy9KGdz6maPku/wz7SVVKraxB74toX3ZRNUb3dMPGiVgSqqrPPtkz3fndrbnOODNWKmhEUzUIOAGf+eIq9HakGN8iamueWptRqyTzxrN3CB/QB55gWywZfPNEwZHFb4609rgnT9mvFJzzcjd+UzmAJOMco+YcungdWRwB3XNanOmcT7T/mEOmi1HUMXUeNvxCin27a4tekLt8xONCvZBGZQFMwz8KzyNHBfd+AyKvrYzC4Hg0QQVmRroikTY8qdktHGhmWA7s0bKOLROrzLBLsr1TtQ/5VSjofcOHbYg+HAWJMEN9CthZ/c/0MnKhUZ9PNH0YrzATf/zx9WxM0eec20wt+Qe7YI+J86k2LeKqnH2Aiq/2MphLLaolq3813m/wOy1yjbgUDgjVnTug9wQ/RUPcQw7hF8sNI+SBAisTFkvdvbag6yS9vCd8/qRy0oZ/s4Epyr9qEERf8FeIE1Fn7rW6+7cr13k95I+uEF6q7
 0+jksi0X
 OCzcpZyethzQlsk9KA2tqm7t1kcpobPpoDzz3Nt2G+n6PbSVcYCu8V/LX60iWwzM2rasynBInotzwq6BbitWSZxomqBK5f5RI5h1T9ZvWETtBBddY0WyNOsdhKl7oide+NTzIJqZNVUvksvl++md859u3jsxjMs4Uwh8iP4r6IGgb8+NlT6rH5yub2UOq4dBHmb3QzxuncLfKksA/Egd2oMrbUW1gIJAVp9p99K+ehwig38NWFDmM0BiewERyHPyj3UmED2rzGO/IGOAeSNPGqX/kWznezdZdwXebTrlLXjs0+CcxTU2z8JW3Op/BaHoa2tljMryGlFkGj1kS6eBq0h8ClZycKlWhs1uo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 22, 2026, at 20:46, Miguel Ojeda wrote:
> On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
>>
>       BINDGEN rust/bindings/bindings_generated.rs - due to target 
> missing
>     In file included from rust/helpers/helpers.c:59:
>     rust/helpers/dma.c:17:2: warning: static function 'dma_free_attrs' 
> is used in an inline function with external linkage [-Wstatic-in-inline]
>        17 |         dma_free_attrs(dev, size, cpu_addr, dma_handle, 
> attrs);
>           |         ^
>     rust/helpers/dma.c:12:1: note: use 'static' to give inline function 
> 'rust_helper_dma_free_attrs' internal linkage
>        12 | __rust_helper void rust_helper_dma_free_attrs(struct device 
> *dev, size_t size,
>           | ^
>           | static
>
> For some reason, `dma_free_attrs` is not marked `inline` in
> `include/linux/dma-mapping.h` to begin with, unlike the rest.
>
> Unless I am missing something and there is a reason for that, it looks
> like it has just been missing since it was added in commit ed6ccf10f24b
> ("dma-mapping: properly stub out the DMA API for !CONFIG_HAS_DMA").
>
> Do you want a patch?

I have an older patch to drop CONFIG_NO_DMA entirely, which 
may be better here, since we know that nobody cares about the
empty stubs.

The only targets that 'select NO_DMA' today are m68k (sun3
and dragonball), sh2 and um, which are some of the targets
that don't have any DMA masters, but there is little downside
of enabling the DMA mapping interfaces on those as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 11835eb59d94..19fb556357fc 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -38,7 +38,6 @@ config M68K
 	select MMU_GATHER_NO_RANGE if MMU
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
-	select NO_DMA if !MMU && !COLDFIRE
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND3
 	select UACCESS_MEMCPY if !MMU
diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index c9a7e602d8a4..adc50396b87d 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -38,7 +38,6 @@ config SUN3
 	depends on MMU
 	select HAVE_ARCH_PFN_VALID
 	select LEGACY_TIMER_TICK
-	select NO_DMA
 	select M68020
 	help
 	  This option enables support for the Sun 3 series of workstations
@@ -558,4 +557,4 @@ config COLDFIRE_COHERENT_DMA
 config M68K_NONCOHERENT_DMA
 	bool
 	default y
-	depends on HAS_DMA && !COLDFIRE_COHERENT_DMA
+	depends on HAS_DMA && !COLDFIRE_COHERENT_DMA && !SUN3
diff --git a/arch/m68k/include/asm/pgtable_mm.h b/arch/m68k/include/asm/pgtable_mm.h
index 7501ff030c63..d095ae6c19f9 100644
--- a/arch/m68k/include/asm/pgtable_mm.h
+++ b/arch/m68k/include/asm/pgtable_mm.h
@@ -159,8 +159,10 @@ static inline void update_mmu_cache_range(struct vm_fault *vmf,
 	    ? (__pgprot((pgprot_val(prot) & _CACHEMASK040) | _PAGE_NOCACHE_S))	\
 	    : (prot)))
 
+#ifndef CONFIG_SUN3
 pgprot_t pgprot_dmacoherent(pgprot_t prot);
 #define pgprot_dmacoherent(prot)	pgprot_dmacoherent(prot)
+#endif
 
 #endif /* CONFIG_COLDFIRE */
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/m68k/kernel/dma.c b/arch/m68k/kernel/dma.c
index 16063783aa80..c52584e024af 100644
--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -8,7 +8,7 @@
 #include <linux/kernel.h>
 #include <asm/cacheflush.h>
 
-#ifndef CONFIG_COLDFIRE
+#if !defined(CONFIG_COLDFIRE) && !defined(CONFIG_SUN3)
 void arch_dma_prep_coherent(struct page *page, size_t size)
 {
 	cache_push(page_to_phys(page), size);
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index d5795067befa..e246f295ec48 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -63,7 +63,6 @@ config SUPERH
 	select LOCK_MM_AND_FIND_VMA
 	select MODULES_USE_ELF_RELA
 	select NEED_SG_DMA_LENGTH
-	select NO_DMA if !MMU && !DMA_COHERENT
 	select NO_GENERIC_PCI_IOPORT_MAP if PCI
 	select OLD_SIGACTION
 	select OLD_SIGSUSPEND
@@ -133,10 +132,10 @@ config SWAP_IO_SPACE
 	bool
 
 config DMA_COHERENT
-	bool
+	def_bool !MMU
 
 config DMA_NONCOHERENT
-	def_bool !NO_DMA && !DMA_COHERENT
+	def_bool !DMA_COHERENT
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select DMA_DIRECT_REMAP
diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index 098cda44db22..dd3428a49614 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -25,7 +25,6 @@ config UML
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_PAGE_SIZE_4KB
-	select NO_DMA if !UML_DMA_EMULATION
 	select OF_EARLY_FLATTREE if OF
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 677c51ab7510..a96a22f857f1 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -138,7 +138,6 @@ static inline void debug_dma_map_single(struct device *dev, const void *addr,
 }
 #endif /* CONFIG_DMA_API_DEBUG */
 
-#ifdef CONFIG_HAS_DMA
 static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	debug_dma_mapping_error(dev, dma_addr);
@@ -200,146 +199,6 @@ void *dma_vmap_noncontiguous(struct device *dev, size_t size,
 void dma_vunmap_noncontiguous(struct device *dev, void *vaddr);
 int dma_mmap_noncontiguous(struct device *dev, struct vm_area_struct *vma,
 		size_t size, struct sg_table *sgt);
-#else /* CONFIG_HAS_DMA */
-static inline dma_addr_t dma_map_page_attrs(struct device *dev,
-		struct page *page, size_t offset, size_t size,
-		enum dma_data_direction dir, unsigned long attrs)
-{
-	return DMA_MAPPING_ERROR;
-}
-static inline void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr,
-		size_t size, enum dma_data_direction dir, unsigned long attrs)
-{
-}
-static inline dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys,
-		size_t size, enum dma_data_direction dir, unsigned long attrs)
-{
-	return DMA_MAPPING_ERROR;
-}
-static inline void dma_unmap_phys(struct device *dev, dma_addr_t addr,
-		size_t size, enum dma_data_direction dir, unsigned long attrs)
-{
-}
-static inline unsigned int dma_map_sg_attrs(struct device *dev,
-		struct scatterlist *sg, int nents, enum dma_data_direction dir,
-		unsigned long attrs)
-{
-	return 0;
-}
-static inline void dma_unmap_sg_attrs(struct device *dev,
-		struct scatterlist *sg, int nents, enum dma_data_direction dir,
-		unsigned long attrs)
-{
-}
-static inline int dma_map_sgtable(struct device *dev, struct sg_table *sgt,
-		enum dma_data_direction dir, unsigned long attrs)
-{
-	return -EOPNOTSUPP;
-}
-static inline dma_addr_t dma_map_resource(struct device *dev,
-		phys_addr_t phys_addr, size_t size, enum dma_data_direction dir,
-		unsigned long attrs)
-{
-	return DMA_MAPPING_ERROR;
-}
-static inline void dma_unmap_resource(struct device *dev, dma_addr_t addr,
-		size_t size, enum dma_data_direction dir, unsigned long attrs)
-{
-}
-static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return -ENOMEM;
-}
-static inline void *dma_alloc_attrs(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t flag, unsigned long attrs)
-{
-	return NULL;
-}
-static inline void dma_free_attrs(struct device *dev, size_t size,
-		void *cpu_addr, dma_addr_t dma_handle, unsigned long attrs)
-{
-}
-static inline void *dmam_alloc_attrs(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp, unsigned long attrs)
-{
-	return NULL;
-}
-static inline void dmam_free_coherent(struct device *dev, size_t size,
-		void *vaddr, dma_addr_t dma_handle)
-{
-}
-static inline int dma_get_sgtable_attrs(struct device *dev,
-		struct sg_table *sgt, void *cpu_addr, dma_addr_t dma_addr,
-		size_t size, unsigned long attrs)
-{
-	return -ENXIO;
-}
-static inline int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
-		void *cpu_addr, dma_addr_t dma_addr, size_t size,
-		unsigned long attrs)
-{
-	return -ENXIO;
-}
-static inline bool dma_can_mmap(struct device *dev)
-{
-	return false;
-}
-static inline bool dma_pci_p2pdma_supported(struct device *dev)
-{
-	return false;
-}
-static inline int dma_set_mask(struct device *dev, u64 mask)
-{
-	return -EIO;
-}
-static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
-{
-	return -EIO;
-}
-static inline u64 dma_get_required_mask(struct device *dev)
-{
-	return 0;
-}
-static inline bool dma_addressing_limited(struct device *dev)
-{
-	return false;
-}
-static inline size_t dma_max_mapping_size(struct device *dev)
-{
-	return 0;
-}
-static inline size_t dma_opt_mapping_size(struct device *dev)
-{
-	return 0;
-}
-static inline unsigned long dma_get_merge_boundary(struct device *dev)
-{
-	return 0;
-}
-static inline struct sg_table *dma_alloc_noncontiguous(struct device *dev,
-		size_t size, enum dma_data_direction dir, gfp_t gfp,
-		unsigned long attrs)
-{
-	return NULL;
-}
-static inline void dma_free_noncontiguous(struct device *dev, size_t size,
-		struct sg_table *sgt, enum dma_data_direction dir)
-{
-}
-static inline void *dma_vmap_noncontiguous(struct device *dev, size_t size,
-		struct sg_table *sgt)
-{
-	return NULL;
-}
-static inline void dma_vunmap_noncontiguous(struct device *dev, void *vaddr)
-{
-}
-static inline int dma_mmap_noncontiguous(struct device *dev,
-		struct vm_area_struct *vma, size_t size, struct sg_table *sgt)
-{
-	return -EINVAL;
-}
-#endif /* CONFIG_HAS_DMA */
 
 #ifdef CONFIG_IOMMU_DMA
 /**
diff --git a/kernel/dma/Kconfig b/kernel/dma/Kconfig
index 0748091339f7..228a3566d344 100644
--- a/kernel/dma/Kconfig
+++ b/kernel/dma/Kconfig
@@ -1,12 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-config NO_DMA
-	bool
-
 config HAS_DMA
-	bool
-	depends on !NO_DMA
-	default y
+	def_bool y
 
 config DMA_OPS_HELPERS
 	bool

