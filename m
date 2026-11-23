Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0FA8606A33B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MVgJpTBs
Received: by kanga.kvack.org (Postfix)
	id 1B56C6B05B3; Mon, 23 Nov 2026 03:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E166B05B6; Mon, 23 Nov 2026 03:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D946B05B8; Mon, 23 Nov 2026 03:29:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2E8D6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:29:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 540FDA84C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:29:37 +0000 (UTC)
X-FDA: 85465709994.29.5827080
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4BE33C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:29:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVgJpTBs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795422575;
	b=Uoe+GoYad7GFn7Re0dL+keAYsRNSTtHWw7UpjtzsZhL8ny4wK3SroGoxXQk8NTHtjHnn9O
	xaRHaq0YcBwd/xv4MWDFa/7eUpVMC0Dqfhw5QN9roDujn3mRykZeHd+Xaak3/K/OZLRhOO
	636/eDTKbNPFbnSNfEPi7emPUd6yNdE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795422575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePqjcmyHWkoMuYio/01QmnoxZbnE0eA64Zt9nH58n1g=;
	b=jCyTFspGFNbUvkh0V2HD0k2+i+TDKONwnalS64T4M1ocAWsJ5a63Ux4nDzLBgMAFKKsxHZ
	8c4rRGDZQnQV1wkKdDDgYvFW+cZeYKJDPXq+I/L90QEbdPhS8NlK+CrzsXBLsVrhUtxPDR
	BgsAQ6NtlsSsZG9EZ+wNkX5qdGJlJaQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVgJpTBs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45A5741078;
	Mon, 23 Nov 2026 08:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEB61F000D8;
	Mon, 23 Nov 2026 08:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795422574;
	bh=ePqjcmyHWkoMuYio/01QmnoxZbnE0eA64Zt9nH58n1g=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=MVgJpTBsTlCkkWpoXkU9vA5F9ideD6R5vv2VSFi+IykF4TOf68V2oxS/bkcSzR9gH
	 LVI0RGE2HvjYumzGdojgm9/n2za8z5pfxkq108xs7gdSVgGFsqeSo6Pgqr/3ieAgZf
	 veiTeBa23DxuHTJ31TX/3Optc5jigpGv9MY+Tjrhw1TiDeZKafp12j57Gl/26/Cvdn
	 863VLlzUzuXz6tOgBdMXfSfctGxuC0XY2lSGybY9fegZtpC5MGI1uLXAy7lzIU0huO
	 jsC6c/eTu7sGBuK6NrW7rb7WRJPGokahjyeEsMzLiXNrXelKJp420jqMyxqYFSjxAf
	 9eRBQaFkSncag==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id AB46E1980075;
	Mon, 23 Nov 2026 03:29:31 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 23 Nov 2026 03:29:31 -0500
X-ME-Sender: <xms:avkDa-IYWG4ncSRoUAH1dA-qfM0y5_tpjMW-ec176UoSVUG63QxJRQ>
    <xme:avkDaw94xOmjNlXryDbfiMld1pZ1ObBoDRV53Vbt3sOr3f3Ly6HQvy53x0ZuJj0RW
    9SUL5NEuymJAIfODlxd6uGr6I3Zn8py3CFjbRM2LNtwNAmNdw2hobHD>
X-ME-Proxy-Cause: dmFkZTE7fTGU/MhBvRDWYPrb0xGwjnRp8jRpGk4t9aBr/i8p/gm2x+xxxYtI3gDwryHaF/
    y5cgfPP50N9NSRhMPnuXHhT5SaliDQUqk014oyuB+81L5n5D+q8nnpEcN4YnSDmOZBJ6O5
    l0AP648zhLtKvfUB3TPWGZguBezELuL9zKF1rPMnSdECGmK1TSURkrt4AIQT+B3M1WG+gy
    CQfsRCm82dDfs8+swPl99vQlRE1n9u8Ur3BwTH/AFI5j0mcFMMPAby7UhZ8UIc+zZryso0
    rUqhwYeaXvkwbnmHsfhtwhcVENlMIBqZERcldGm0JP3iKOIdWWeXRukb4AHquSFj+wXKo4
    sPuAm6837fzFoGH9YD4ojl6f0w7UaXcT4jetvdsXqn67XFeeiuFt5gYr9nFO/U6+nt0SCf
    cBSThMtkgy3HwDIo+xQXJHsbwj0Lhwu1/Qpu1QUANPc/B1YOhPgE3B/pavi83OElehQ2jm
    C8jawdxdcIpQUefM/xcMDnCho558u85YAOdtDbmAhg2EPfDWl6vUNKl/XyOV8S8fkKuSSH
    yIC/nPFWQdtgZJ+cQPKko0CaAjYdoOMwn8vrJ0JC5s0GBmfx7JzF3J9hpMfku66LHlbMR3
    AHKOzwVmyk5uWS0z6qL4UvyJ0z9RDLPSFTcPTxmNEmaTx8+YE1Q6Dbz5R+9Q
X-ME-Proxy: <xmx:a_kDa-9NhQ9kI3oJp2AlSDlBVDpz4pPQrPOhK2GCLZCbRwdlPHgLZg>
    <xmx:a_kDayYqjHFYvwLmzjC7Bxz6kfbcMj_VPBap7exYB7pwyIjSOx7n2A>
    <xmx:a_kDa91wV14rEkNAXi0tyR1l9Zgy7RBqj1wdTBnckY9mPVcXmUz-rg>
    <xmx:a_kDa9YLS1CAnBNP7mtGo64uqdKJB4xhI88klN2KqEntlfdTFkGw6Q>
    <xmx:a_kDa1IdVIC6M_xBH4TTi0-xl7g0cDwxwx_fw8Du3_uDamDzZlU317v->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id F0663F8008E; Mon, 23 Nov 2026 03:29:29 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Mon, 23 Nov 2026 09:29:09 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-mm@kvack.org,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Suren Baghdasaryan" <surenb@google.com>,
 "Kent Overstreet" <kent.overstreet@linux.dev>, "Hao Ge" <hao.ge@linux.dev>
Message-Id: <a3cf3687-54d9-4cc3-907e-f63625aea56b@app.fastmail.com>
In-Reply-To: <20261119170353.1835737-2-ardb+git@google.com>
References: <20261119170353.1835737-2-ardb+git@google.com>
Subject: Re: [PATCH v2] alloc_tag: Use __ prefixed ELF section names
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4BE33C0006
X-Rspam-User:
X-Stat-Signature: ry134h89o5gkshu6b97g1kbw5cfi9qf9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795422575-915923
X-HE-Meta: U2FsdGVkX18iPWgBBYmQwJ+qI4poJqEF2DHzX2rXYNkMXklVsx6vX1QBli9ZXErvDNvSPGeiHS6dfrhiPtmu6uhML5xOsn5wkU0V2ECS2llurncsWdE8B/WBbxoNI+Pez4Ft5weOFnef8o1K3JFVyVzoCTJu1mAT3wf2N78gxNDaF7MeS348C4qwDaBhLtLR0dbCRXx+7HKhWpzKMFi1FURW2g4DEi2iIp08f8gs0oSMVrAY/19JvQgFiMmMf23ff10X0RnwzEtd+zJMbrTwLCorBh0Nc4k8bh6S4o6OJpJN6ZA0wL5md7oniS6kKI7APkCA2mKi0/RdNRquFNS3LLB8+lbREibiFbTBguNqN5M8r8kWlzJs3VozYa07SY+WGuSnEKSSHq2Z3GJW6UDFa34ptXxDe+QfWPdt75QRw7RS0OIRNTc6tyhZiW4TxrfKVDKfGdP+xhx1HzWswAxBWfvU+SIkvwfN3MtzYO2RtYv9mzY60J+b4NLAK4TXe+c+428ynLO9OmKKs+yG09eb7v77Z1fb6V8eG8SPWKiiJFLSOxcNPxuYuG3thQRFMnTOp4L2sn97EvI3DmuCR62h2chFd8b5jAzEoFTSXVoNyEbSFZYOceOn8U0i26D+XxWBvPJ7XaNs71HlG51Z9Y/exO/s5ShiD1uMZXkoAYKcWyrovsOL8H6MjTNQoL/qt0U5MxhzSN4POUXc4EHrhP4qaZlmAiq3bUET4ByPk8Unfg7ryfe/EENMumBUukDoKAvgaGGsS+8iOM3aQwUkPb5oJa7kWvggPUHQPbwAAcitVQ5dCz+rAGcBWn3C+InVrAdsUVLYiVIssuJJ2Uw0h9Hnnz1mj2sfrWCNbadN78DK7QyLh1aOVK2nDtFZHQz/FhmBHFHeSzNhBLlxIqicJ306rD+5AOlntTqcSrPpvcgSyIjiE5XKuiX5ZXmrwwZJU/CjSvQ1F+IQpYwUn5GqESw
 Mc7THdtr
 p1D418QVn0Xo8RxdRIfHJzPzTcphTZqon/xpjN3LUNuq9HDg6/rsW8jsJer1LIhiRkyerlnX3EwXOWZgMiMjCF6QgIIorntU13i4SOkOF/4+TAYwUfz8hvBoWbPbt6dmYCXk/X94g1cxkAFiJ8m+zkk94mtfglplfUlhp47pnMFm727o6/QkGigrJIPAhXMl9tDZRGL5ZQXwiToeWt1hkAwoongJSbnsLOPMF07hwlON/DblNh6QycjNQFoQZPEAgUw5iZ7xEd8cJe8ELbOheTLgTP1zzXm0/Op3fjO024QRSejrRYVX1Cfn16Kj+zHMYA3JeapReTl/vyXQ9qwqxgq9YZlIdoFUJLFePEANaIZfXN6Qx4qTIDMCqzVl4Tr0J5JrBvFDDjpxGMCw+DIUGen5L9PIwKDhoXo9U3x0IZpos+DokvYvBAPdxnvXQSiSRnyR3jbECaHhKnoQ6l392mDpRynSRo28T45+XX96AZNwl5fDpHJBgnyhOYUA+4gMaNY8O7RvuFeHTP1VudENcCjqqQdsSFDT+NgwORlgWESJlfbDOu0dK2JLqEL7++hGTiVzcIci0cuLKdlPKheNZHXknAwRp88gTx0XCG0C1TW4ff+jWoH+TaVGVVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(cc akpm)

On Thu, 19 Nov 2026, at 18:03, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> The compiler will emit static relocations related to a section .foo into
> a separate section called .rela.foo, i.e., it just appends the section
> name to the string ".rela"
>
> When section names start with . or __, this results in section names
> that are correctly matched by the various pattern rules in the various
> linker scripts across the tree.
>
> Without any such leading delimiter, it may lead to spurious warnings
> such as
>
>   >> ld: warning: orphan section `.relaalloc_tags' from `init/main.o' 
> being placed in section `.rela.dyn'
>      ld: warning: dot moved backwards before `.rela.dyn'
>      ld: .tmp_vmlinux1: section `.rela.dyn' can't be allocated in 
> segment 1
>
> Fix this by renaming the section to __alloc_tags. While at it, tweak the
> headers so that the definition appears only a single time.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Hao Ge <hao.ge@linux.dev>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> v2: stringify NAME correctly in definition of SECTION_START()/_STOP()
>


Suren kindly gave

Acked-by: Suren Baghdasaryan <surenb@google.com>

on the v1 provided that the NAME stringification was corrected [0]

Andrew, is this something you might pick up? Thanks.

Re Sashiko review: I've only observed the issue with patches
that are under development, so I don't think this needs a
cc:stable at this point.


[0] https://lore.kernel.org/all/20261118132719.632451-2-ardb+git@google.com/

>  include/asm-generic/codetag.lds.h | 14 +++++++++-----
>  include/linux/alloc_tag.h         | 11 ++++++-----
>  mm/alloc_tag.c                    |  6 +++---
>  3 files changed, 18 insertions(+), 13 deletions(-)
>
> diff --git a/include/asm-generic/codetag.lds.h 
> b/include/asm-generic/codetag.lds.h
> index 4948e5d4e9d9..443e3a8fa60b 100644
> --- a/include/asm-generic/codetag.lds.h
> +++ b/include/asm-generic/codetag.lds.h
> @@ -2,6 +2,10 @@
>  #ifndef __ASM_GENERIC_CODETAG_LDS_H
>  #define __ASM_GENERIC_CODETAG_LDS_H
> 
> +#include <linux/compiler_types.h>
> +
> +#define ALLOC_TAG_SECTION_NAME	__alloc_tags
> +
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>  #define IF_MEM_ALLOC_PROFILING(...) __VA_ARGS__
>  #else
> @@ -10,15 +14,15 @@
> 
>  #define SECTION_WITH_BOUNDARIES(_name)	\
>  	. = ALIGN(8);			\
> -	__start_##_name = .;		\
> +	__PASTE(__start_, _name) = .;	\
>  	KEEP(*(_name))			\
> -	__stop_##_name = .;
> +	__PASTE(__stop_, _name) = .;
> 
>  #define CODETAG_SECTIONS()		\
> -	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(alloc_tags))
> +	IF_MEM_ALLOC_PROFILING(SECTION_WITH_BOUNDARIES(ALLOC_TAG_SECTION_NAME))
> 
>  #define MOD_SEPARATE_CODETAG_SECTION(_name)	\
> -	.codetag.##_name 0 : {			\
> +	.codetag._name 0 : {			\
>  		SECTION_WITH_BOUNDARIES(_name)	\
>  	}
> 
> @@ -28,6 +32,6 @@
>   * unload them individually once unused.
>   */
>  #define MOD_SEPARATE_CODETAG_SECTIONS()		\
> -	IF_MEM_ALLOC_PROFILING(MOD_SEPARATE_CODETAG_SECTION(alloc_tags))
> +	IF_MEM_ALLOC_PROFILING(MOD_SEPARATE_CODETAG_SECTION(ALLOC_TAG_SECTION_NAME))
> 
>  #endif /* __ASM_GENERIC_CODETAG_LDS_H */
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 7f2d80a59792..0703592a3302 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -15,6 +15,9 @@
>  #include <linux/static_key.h>
>  #include <linux/irqflags.h>
> 
> +/* for ALLOC_TAG_SECTION_NAME */
> +#include <asm-generic/codetag.lds.h>
> +
>  struct alloc_tag_counters {
>  	u64 bytes;
>  	u64 calls;
> @@ -74,8 +77,6 @@ static inline void set_codetag_empty(union codetag_ref *ref)
> 
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
> 
> -#define ALLOC_TAG_SECTION_NAME	"alloc_tags"
> -
>  struct codetag_bytes {
>  	struct codetag *ct;
>  	s64 bytes;
> @@ -98,7 +99,7 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
> 
>  #define DEFINE_ALLOC_TAG(_alloc_tag)						\
>  	static struct alloc_tag _alloc_tag __used __aligned(8)			\
> -	__section(ALLOC_TAG_SECTION_NAME) = {					\
> +	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
>  		.ct = CODE_TAG_INIT,						\
>  		.counters = &_shared_alloc_tag };
> 
> @@ -108,7 +109,7 @@ DECLARE_PER_CPU(struct alloc_tag_counters, 
> _shared_alloc_tag);
> 
>  #define DEFINE_ALLOC_TAG(_alloc_tag)						\
>  	static struct alloc_tag _alloc_tag __used __aligned(8)			\
> -	__section(ALLOC_TAG_SECTION_NAME) = {					\
> +	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
>  		.ct = CODE_TAG_INIT,						\
>  		.counters = NULL };
> 
> @@ -117,7 +118,7 @@ DECLARE_PER_CPU(struct alloc_tag_counters, 
> _shared_alloc_tag);
>  #define DEFINE_ALLOC_TAG(_alloc_tag)						\
>  	static DEFINE_PER_CPU(struct alloc_tag_counters, _alloc_tag_cntr);	\
>  	static struct alloc_tag _alloc_tag __used __aligned(8)			\
> -	__section(ALLOC_TAG_SECTION_NAME) = {					\
> +	__section(__stringify(ALLOC_TAG_SECTION_NAME)) = {			\
>  		.ct = CODE_TAG_INIT,						\
>  		.counters = &_alloc_tag_cntr };
> 
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 82e2c3448dcf..cce88ded2b06 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -23,8 +23,8 @@
> 
>  #define ALLOCINFO_FILE_NAME		"allocinfo"
>  #define MODULE_ALLOC_TAG_VMAP_SIZE	(100000UL * sizeof(struct alloc_tag))
> -#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX NAME)
> -#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX NAME)
> +#define SECTION_START(NAME)		(CODETAG_SECTION_START_PREFIX __stringify(NAME))
> +#define SECTION_STOP(NAME)		(CODETAG_SECTION_STOP_PREFIX __stringify(NAME))
> 
>  #ifdef CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT
>  static bool mem_profiling_support = true;
> @@ -1322,7 +1322,7 @@ static inline void sysctl_init(void) {}
>  static int __init alloc_tag_init(void)
>  {
>  	const struct codetag_type_desc desc = {
> -		.section		= ALLOC_TAG_SECTION_NAME,
> +		.section		= __stringify(ALLOC_TAG_SECTION_NAME),
>  		.tag_size		= sizeof(struct alloc_tag),
>  #ifdef CONFIG_MODULES
>  		.needs_section_mem	= needs_section_mem,
> -- 
> 2.56.1.708.g77570a6a1d-goog

