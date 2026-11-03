Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58345606BA00
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=skz89O6F
Received: by kanga.kvack.org (Postfix)
	id 80E816B05B1; Tue,  3 Nov 2026 09:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6996B05C7; Tue,  3 Nov 2026 09:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBE96B05C8; Tue,  3 Nov 2026 09:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 472B26B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:52:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3F7F14044B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:52:48 +0000 (UTC)
X-FDA: 85394099616.16.193C574
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id E946D40004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:52:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=skz89O6F;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZzVmOOfoRtDvZHpF7qwPdY9qMJ2XRmaKfYRT9GKTJM=;
	b=Ph1HilNt4+POd7vslBFD10SCWX+2AVODQ15X1FzErEb1Mfl4y6HKq4O24QhfxuK5h8RrZ+
	yfoSbacJphGglImusmVA9g9k5EhQWV49kcr9j29FuE8/HgPESG5j13e3/xH8VVPfMy5ve4
	UiuTyX7n10G26Y0jveUvpgtHOwsbML4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=skz89O6F;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717567;
	b=5ds0aYLlO6lAGuakF2k/XTO+Bm5qGj9GdU4wTM1JF8ilYesAglxdLQFNWa4H2TF7xhJPhF
	h988kXD8qiGNdgLpm5K2ZbtSx170cEl7vpEnYwWGFafwVvuhOGTKlznYS6FLIKIPYN+Mmt
	86I5lTWn4P94VR1wAnI5KmXmgG386aM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AZzVmOOfoRtDvZHpF7qwPdY9qMJ2XRmaKfYRT9GKTJM=; b=skz89O6F8mEMMNAlN1u/nqq/Nd
	Am9hqZOCT8D63YyzHpNND8SaYE7BEFaMaPgSN1SXruvzs3jWwVbmwO15MPpWrpfUvhhVI6lh8oCQg
	vihlRywjPlCWqWXryCEux9ucABuQ3flQ4k1vEpsm19EAKcG/SD4lerWSD7aOspiW9J3PLKSqXTVQq
	DaVcLkgntHTCpDCQUzFG6cdwMuE1hupteVUPjtcatFiMXb3p+jprlXmi33oYgyKSVwip16YVuqbxv
	x/1UR+UqZpE0nX22ScRLXLcLFolszfJYW0mhkSyCLlm917oXRyvBenEHMqi97nC02kD7akamLQvu0
	W/ZJbZdQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xOFsD-0000000Ebhh-1pHh;
	Tue, 03 Nov 2026 14:52:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2505B301185; Tue, 03 Nov 2026 15:52:28 +0100 (CET)
Date: Tue, 3 Nov 2026 15:52:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sasha Levin <sashal@kernel.org>, kernel test robot <yi1.lai@intel.com>,
	oe-lkp@lists.linux.dev, kernel test robot <lkp@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>, Gary Guo <gary@garyguo.net>,
	guoren <guoren@kernel.org>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonas Bonn <jonas@southpole.se>, KP Singh <kpsingh@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Rich Felker <dalias@libc.org>, Song Liu <song@kernel.org>,
	Stafford Horne <shorne@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Will Deacon <will@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [linus:master] [atomic] 80047d84ee:
 WARNING:at_include/linux/instrumented.h:#__split_huge_pmd_locked
Message-ID: <20261103145228.GO2668804@noisy.programming.kicks-ass.net>
References: <202611022259.def3e086-lkp@intel.com>
 <20261103122647.GL1813469@noisy.programming.kicks-ass.net>
 <20261103123508.3910990-1-sashal@kernel.org>
 <e69e6690-cfc0-4ea8-83e1-5ad2d98b84d5@app.fastmail.com>
 <846703eb-111c-4376-a0ba-36bd3e13f632@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <846703eb-111c-4376-a0ba-36bd3e13f632@app.fastmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E946D40004
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: w5z5c8jtaxczordxqcswj1gp1tohzgo7
X-HE-Tag: 1793717566-275045
X-HE-Meta: U2FsdGVkX18TcJwc6Eq+z7Vv7J2FIRbX4BUCtugenJR1IlajZw2R2mwttGcDtyjG+A9SoeqJ8jDl89HqwjcF9LIAioyVolSMtvvuExFxnRaBPeOk1NGmOnyaBbvOpZ5gKTS2C92Iq8Fr2UwKRysbqyUQZ+lVYSykEoZdUY4G7es2FC/sIpnwqDsfwPpYlGL+9Z/cJ7eiLlEFnkfCQWWdq50Lc2qkNvO3ZGIIwllEaQIcJQw+2RbOX3FkDm29E23XxH3UmAEwA1egcAIMvfaPAWRSnrn2cPB4gu1b99h2axDfGNMUfCh293W0wPgu/obJSgsYIfgY3TInz28EnIBbdYH3x2RMfnmzvQ/20uInODnLq881j+JstF5w16sBWoAXjFJnopAcP73wY2XDGNyAcDMdy80R3zhD8//+JrW8UzkGCbZ0B2bBuSP/oj851RfNycjuyhjbCdxzqi3lCg1B8vLuidZjPrkbyrPjmNVBsgXbXBLHTt30sd6SmWptapIFyVAatsGZgNmP5xrHXGRMH6JBLXvQZ/OwygLrfeaVuwgh4CviCJeMYDeht7wqlmg4tHgAeM7/40luIbC9pb+a6T17J2+tviY70+1lZoCWryLnQbkLuh+NDla5+jTgQZg1hBPPHHSp3d/hN1YVOh/ReKNfJsZKsCBiANA0sstQ1Eqr3zlDlXqzT9FCUwfZBJs+ecZLDAN+4MhWJE5OaLOSkqDD6u4BzwkDWs4CVmkxKX9Jj3XEUOxoKDF1dIVVJppvK7lKRS/+s3FQCFz7FNEyxyMm1DS+SJKGL2uYbyxmfzBAeOsSGmbocgYnb+43quVVz9SPET2iq3PdFTCKfloOxHp8qHo5htFyw+2anqWb48L2CQHhy3bRhGXAHL+LWhcPaDyw3RikcbTOLTFNC1Z73PwKEe9rYVlyci1ZlGjpVQhkHl7vLvhHrwEWNvzoDHyeYHaeDTo+aBA6hrmpgCk
 6SaNDR59
 6tPXNATlUV/Bxv7oBAJg4MySRLCYqk/e97ibtDo1WytgoJL/Mwggrw+1AX+FNCGARMYr0mzcQfO+BuuUwCFWFO7kvIdbGQPyuTbP9V1zDl4MCGrWWrilcRFvXzeEC7PUvFlzRTfmxSlZ/SsIPIDsBWAf14Z+b/+nE7KpcfP418iHfWQ0ZKJyrXkaZqZ6B1ubt45ptcSyupeTfQFxZLWKAnqENgY/LPd6LQWQv6VN7KciXi2MZMOqNlgfwgRyZAD5T+EDX5PgjXP69RCTaEUyv71w6yZHk8/alsjLj0SrLTIlu2EpBPfxZXTVDR6rl/ICKIVdbFJQ/DigV1uE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 02:41:32PM +0100, Arnd Bergmann wrote:

> FWIW, I checked the other architectures that may be affected:
> 
> - 32-bit arm has transparent hugepages and a 64-bit pmd_t with lpae,
>   but that type has natural alignment, and pmd_populate is a
>   simple assignment.
> 
> - arc has transparent hugepages and a 32-bit pmd_t but a 64-bit
>   pte_t that is not naturally aligned. It probably should be
>   aligned, even though I don't see any actual bugs
> 
> - sh has a 64-bit pmd_t on sh4a CPUs that is not naturally
>   aligned and probably should be, but there are no transparent
>   hugepages.
> 
> All other 32-bit targets don't use transparent hugepages
> or 64-bit pmd_t. 
> 
> We probably only need to align p?d_t though, not p?dval_t.
> How about the version below?
> 
>     Arnd
> 
> diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
> index 9720fe6b2c24..af5303459d56 100644
> --- a/arch/arc/include/asm/page.h
> +++ b/arch/arc/include/asm/page.h
> @@ -65,7 +65,7 @@ typedef struct {
>  
>  typedef struct {
>  #ifdef CONFIG_ARC_HAS_PAE40
> -	unsigned long long pte;
> +	unsigned long long pte __aligned(8);
>  #else
>  	unsigned long pte;
>  #endif
> diff --git a/arch/sh/include/asm/pgtable-3level.h b/arch/sh/include/asm/pgtable-3level.h
> index d1ce73f3bd85..6d5e2e3248f2 100644
> --- a/arch/sh/include/asm/pgtable-3level.h
> +++ b/arch/sh/include/asm/pgtable-3level.h
> @@ -33,7 +33,7 @@ typedef union {
>  		unsigned long pmd_low;
>  		unsigned long pmd_high;
>  	};
> -	unsigned long long pmd;
> +	unsigned long long pmd __aligned(8);
>  } pmd_t;
>  #define pmd_val(x)	((x).pmd)
>  #define __pmd(x)	((pmd_t) { .pmd = (x) } )
> diff --git a/arch/x86/include/asm/pgtable-3level_types.h b/arch/x86/include/asm/pgtable-3level_types.h
> index 580b09bf6a45..061283293341 100644
> --- a/arch/x86/include/asm/pgtable-3level_types.h
> +++ b/arch/x86/include/asm/pgtable-3level_types.h
> @@ -16,14 +16,14 @@ typedef union {
>  	struct {
>  		unsigned long pte_low, pte_high;
>  	};
> -	pteval_t pte;
> +	pteval_t pte __aligned(8);
>  } pte_t;
>  
>  typedef union {
>  	struct {
>  		unsigned long pmd_low, pmd_high;
>  	};
> -	pmdval_t pmd;
> +	pmdval_t pmd __aligned(8);
>  } pmd_t;
>  #endif	/* !__ASSEMBLER__ */
>  
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 2ec250ba467e..5c028b3f59c4 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -292,7 +292,7 @@ enum page_cache_mode {
>  
>  typedef struct pgprot { pgprotval_t pgprot; } pgprot_t;
>  
> -typedef struct { pgdval_t pgd; } pgd_t;
> +typedef struct { pgdval_t pgd __aligned(sizeof(pgdval_t)); } pgd_t;
>  
>  static inline pgprot_t pgprot_nx(pgprot_t prot)
>  {

This doesn't cover all of p?d_t, does it?

