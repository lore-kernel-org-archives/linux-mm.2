Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F75CD4F26
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 02:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5782C6B0088; Tue, 23 Jun 2026 22:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A096B008A; Tue, 23 Jun 2026 22:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418226B008C; Tue, 23 Jun 2026 22:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13C106B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:58:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77B07A01DF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:58:12 +0000 (UTC)
X-FDA: 84913297224.02.4B443A1
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10ECB100007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:58:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="I/gzYan9";
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782269890;
	b=zhgI0BI5hRytoRNWGUhkHAjoKzgYu9AwZto8Q6TD207+PnttzxwaW5LKccPZwxTCrhyPMs
	DaLivoOXQ4iBaCwijdwmTh+9QwjcgWxY3ly/YDnRiNAOPNcYKGyrMf2zs9KzE2kV8vW+zY
	zAnjIeFweP/9CTsXcCelej01PmRlUI8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782269890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pumt3ZhtXEP5A7/txAfIN/pYRRHkq0RSi/yjC0QK9o=;
	b=dnuAEHBG9iBmG2sUQMtV9gYDOPtdnzcEa/QEFjMLssFIwQYJyyX+T2OYTmksuhDgtJeu64
	PjOhdTKJRzYpam0WrvUkXyxmVIFWlh3PghECcCC9ViGEg08sgkSMWQtu5VEskYGg4hbaNH
	ZH1T89wk0vU9SOJw4U/l2cPX9CRFMcQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b="I/gzYan9";
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id E1F8640E01B4;
	Wed, 24 Jun 2026 02:58:06 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 8vuomES7BQRE; Wed, 24 Jun 2026 02:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1782269876; bh=5pumt3ZhtXEP5A7/txAfIN/pYRRHkq0RSi/yjC0QK9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I/gzYan9dcc6f59zVNBMGNtm/lLomcAVoGlaPz1ae8J6kyyj6uXQmVNPmUw/MN8Vt
	 p5bGnG2qc2TTMgLuWGwlECt+NhzNaySoj9ZEhew7KRUDjxnqDfZxuzhgYc/lfTMZAQ
	 116Uk+agAeqMxfWbCdPs/kVQX5hosdAi6J/gUW0npNcbdPjy5Ns78UjY0bWUmY6vpz
	 iVsjgcNy9rN0DrpdaREln6E/ZT/O28XkiqTEQEc35HCZcTc0ErbuxgdThqxpwJe9B7
	 EDNMkED9gLY29DO3zk3q7rH5+2duDr2nfOFOdMa/4mIHnMmLddAnIcd2M3HBJSrQWj
	 jPoENq3LRaqRXeEsgQLTCoViLDi0px8FGlQKTs4nBaj3sxkKEo+1eT5Gxb2wB6YWtr
	 HWs4w7x4m38HvzPVUJ39gx/WW+JlvEdp68o1HzFrgpCleOBOPD8cJ3sOiEpb8fr7Wn
	 bhdf9h/R6XvNpMuthunauRLcsrn5zC4MsYHRDn7JnXt4XOiL7EhaOG+cqPFxDU3ZtC
	 cra+nhHpMGujdSjuHpPQfyZ3lniFLRsAlVTKP4OZc05Ja7N/nZIhjrPQZRe+Lnrr/0
	 ZWGgX9lFYYgzNR0TNWSdSFkBWL9zKK4A1ATqi+SmQ1irlJkONoopGICFJqeB47j9Hi
	 xLcF2/yl9isC+GGRCGLjxNYw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2A2E340E0031;
	Wed, 24 Jun 2026 02:57:37 +0000 (UTC)
Date: Tue, 23 Jun 2026 19:57:32 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
Message-ID: <20260624025732.GDajtHnB1Jc21kQnl_@fat_crate.local>
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
 <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
 <20260618170913.GBajQmOQyOiBLqopUl@fat_crate.local>
 <3207a706-354c-4e9d-ba53-dded1abb1842@intel.com>
 <20260618183815.GDajQ7F-bqTHnrakoi@fat_crate.local>
 <87643862-e32e-43c7-8c81-7186f30059ea@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87643862-e32e-43c7-8c81-7186f30059ea@linux.dev>
X-Stat-Signature: e59ybo73a34349fgixe3fygkh5o3ybek
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10ECB100007
X-HE-Tag: 1782269889-317629
X-HE-Meta: U2FsdGVkX1//7mdTbR6NJLNysFLLzm0KPJFCZDB5yWP0BPovwZ0kTrILBwlkdkm9vgU9XnzSes/poEdPJO5RaPCuFvj9KYa33PIcYQsPtzZLnLJTwRnp2qGafttxEkbJC6AGFlmznVk+1ueO8G03wy/hRlaaz4H2Yvo/fH/bFdZdvEmsBdtdRECopTNP4/FAaYa2GJgKo8AzF3sQkWpoFggNqdCNEZu9IiPw1CB96osbwg/rI2DD3IuI+k+uoX48KbS5QKLBQGP5CvBvmg+h6Dx+4elr9E7GhajuPfr/NjE7mY3eQYfAAAZ7My4B6iGsRjBoMH/LqOaz38XV1bs1S1Vc6FBvnYhcGg74DIiVTxfxyOPbGnQ3Q9k4Ph+X1U4+sB2NwDa9ZfU30nVHQ8mA60I5DGiyH2pK7rVRsQIK0ELLADUG2BrkPIOsaPGkvYQJ2G4Hy8/97zQrLb7HvCHpJ+Z2/EFLbkZI4GlmiCd4co78YqJg6NGik2/nJub75oWCUOxJTciI1vir2kDEu9Ky7Q2zk+vrx7U4SAMrb624dTkbSjTGj7/321oj/3IiS+c3sQlcUtvHS2KFZ/PHghtlI13tvbQHzLIU837E28Y3co2+nC9fu00uQVZ/xmAkoab/sS0x8QvWfCJkA3WoKZVCQoZJ6tjNMzMnCpukGQPE+up2IpJHf7iF5DXumZLW+jZrO4NFhdyg4e8otVXdgPYODZAjQYU5jB/XG9XdtnxPvCKtOk+4p1suUmrrXCLslIjvfFfjlgXztBOJDfo4/WLzkVfElEQHIwsR3Xwic1YHH74/7zQtxCgUrv/8VireYMJE52B4jD1HZElZttgZBieAt75WeBHyAud8kL+uBXaYbACoGWUAfc+InkyRnA6ibGE5rA4hqbAMRQyF7bSjifUrPVcJ+dQBkf2tRkXSKOWBpGxG/LK15vmwspvtrtux81rudoVu6i7rkWrjDANTzWw
 0b5mWMKc
 0KNjtGZ4/a6sAlYHyVOGa/Xe3canfA4bcAjOiZMtEVSRp6umgbqMeTowM+/PpiqAN3F9y3Cx1qMHrilauRDhbURIrThLguiZrpm9x9WbfaB3ocdP234V7BrBqaZtsTAjVd9T4q80GojQg0SabmncBQptsG3VsMC9Yzx4gYN4D7NZfYOGlTC8kXmjSkIkA0xRdWCvkWP12d/PDVQHIieSW1z8jcImpCHCWw8TS+X7X4D+eyFUw3Na7hSwcb53P2VQE2kPacJVciyjTVPYHdbEYFCU17I5dA2o5r6h5nn3skKvdccy1BIyuaXkVaVmb9AlR+b+1XddQkEv0k97g3mwdLGupYmA9DnR4Z0xcASm7qTre8bPDdP3nRyWBnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 05:29:12PM -0700, Ihor Solodrai wrote:
> On 6/18/26 11:38 AM, Borislav Petkov wrote:
> > On Thu, Jun 18, 2026 at 11:12:09AM -0700, Dave Hansen wrote:
> >> On 6/18/26 10:09, Borislav Petkov wrote:
> >>> On Wed, Jun 17, 2026 at 03:13:33PM -0700, Ihor Solodrai wrote:
> >>>> So my question to maintainers is what approach seems best?
> >>> The CPUID stuff is being rewritten currently and it should address your issue
> >>> too. If not, then we need to rewrite it better.
> >>>
> >>> Can you reproduce with this set applied ontop:
> >>>
> >>> https://lore.kernel.org/r/20260528153923.403473-1-darwi@linutronix.de
> >>
> >> Thinking about this a bit more... If Ahmed's series does fix this, I
> >> think it will be accidental. It still uses identify_cpu() and also does
> >> a memset() of the new c->cpuid structure in addition to the old
> >> c->x86_capability structure.
> >>
> >> I'm not knocking Ahmed's series by any means. It just probably won't fix
> >> this issue.
> >>
> >> In a perfect world early_identify_cpu() and identify_cpu() would either
> >> get consolidated into one thing. Or at least become two discrete things
> >> that initialize two completely disjoint sets of data. That way,
> >> identify_cpu() wouldn't memset() anything.
> >>
> >> Isn't that the _real_ fix? Instead of trying to hide the inconsistency
> >> when good data is blown away, we stop blowing it away in the first place?
> > 
> > early_ is only on the BSP and you want to scan all CPUs.
> > 
> > AFAIR, the last time I was looking at how we scan the CPUID leafs, we do have
> > cases where there's blips in time when cap bits get disappeared to be
> > rescanned again. The toggling of MSR bits which control feature flags is one
> > thing that comes to mind.
> > 
> > But I'm with you on the consolidation approach. I think this is what we should
> 
> Hello Dave, Boris. Thank you for the input.
> 
> I tried a slight refactoring of the identify_cpu() machinery to
> eliminate the memset(x86_capability) from the boot cpu, and it fixes
> the splat that I reported.
> 
> identify_cpu() is split into two parts:
>   * identify_cpu_scan() - the top part, up to and including the
>     generic_identify() call
>   * identify_cpu() proper with the rest, no memset here
> 
> Then (gated on x86_64) identify_boot_cpu() *skips* the
> identify_cpu_scan() call, only executing the bottom part of current
> identify_cpu(). We can do that because boot cpu already did the _scan
> part in early_identify_cpu(), when interrupts are still disabled.
> 
> One caveat: get_model_name() is moved from generic_identify() into
> identify_cpu(), otherwise it wouldn't be called on boot cpu. Same for
> c->loops_per_jiffy = loops_per_jiffy; - it's moved to the "bottom"
> identify_cpu().
> 
> The behavior for secondary cpus is unchanged: identify_secondary_cpu()
> calls identify_cpu_scan() then immediately identify_cpu().
> 
> Please take a look at the diff below and let me know if this is a good
> way to proceed. I don't know exactly what I'm doing, so concerns and
> corrections are welcome.
> 
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index a4268c47f2bc..4a655109cacf 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1978,8 +1978,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
>  
>  	get_cpu_address_sizes(c);
>  
> -	get_model_name(c); /* Default name */
> -
>  	/*
>  	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
>  	 * systems that run Linux at CPL > 0 may or may not have the
> @@ -1999,13 +1997,12 @@ static void generic_identify(struct cpuinfo_x86 *c)
>  }
>  
>  /*
> - * This does the hard work of actually picking apart the CPU stuff...
> + * Rebuild capability set from CPUID and re-apply the forced-cap overrides
> + * through generic_identify(). This *should* run with interrupts off, otherwise
> + * an interrupt handler might see the capability bits cleared.

And yet it doesn't run with IRQs off. So that comment doesn't need to be here.
The point of the whole exercise is to not disable ugly interrupts in that path
at all.

>   */
> -static void identify_cpu(struct cpuinfo_x86 *c)
> +static void identify_cpu_scan(struct cpuinfo_x86 *c)
>  {
> -	int i;
> -
> -	c->loops_per_jiffy = loops_per_jiffy;
>  	c->x86_cache_size = 0;
>  	c->x86_vendor = X86_VENDOR_UNKNOWN;
>  	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
> @@ -2028,6 +2025,19 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>  #endif
>  
>  	generic_identify(c);
> +}
> +
> +/*
> + * This is safe to run with interrupts on.
> + * The boot CPU can run just this from arch_cpu_finalize_init(), because
> + * the scan part already happened in early_identify_cpu().
> + */
> +static void identify_cpu(struct cpuinfo_x86 *c)
> +{
> +	int i;
> +
> +	c->loops_per_jiffy = loops_per_jiffy;
> +	get_model_name(c); /* Default name */
>  
>  	cpu_parse_topology(c);
>  
> @@ -2154,6 +2164,17 @@ void enable_sep_cpu(void)
>  
>  static __init void identify_boot_cpu(void)
>  {
> +	/*
> +	 * The boot CPU's capabilities were already scanned by early_identify_cpu().
> +	 * Here identify_cpu() only finalizes them.
> +	 *
> +	 * 32-bit still needs the full scan here: it sets X86_BUG_ESPFIX (via
> +	 * generic_identify()) and the no-CPUID cpuid_level default, which the early
> +	 * path does not.
> +	 */
> +#ifndef CONFIG_X86_64
> +	identify_cpu_scan(&boot_cpu_data);
> +#endif
>  	identify_cpu(&boot_cpu_data);
>  	if (HAS_KERNEL_IBT && cpu_feature_enabled(X86_FEATURE_IBT))
>  		pr_info("CET detected: Indirect Branch Tracking enabled\n");
> @@ -2178,6 +2199,7 @@ void identify_secondary_cpu(unsigned int cpu)
>  		*c = boot_cpu_data;
>  	c->cpu_index = cpu;
>  
> +	identify_cpu_scan(c);
>  	identify_cpu(c);
>  #ifdef CONFIG_X86_32
>  	enable_sep_cpu();
> -- 

Ok, thanks for that, that's a good first try. I did poke at it a bit and
here's what I think should happen:

1. The part which initializes struct cpuinfo_x86 up and including the memsets
   should be one function called init_cpu_info() or so.

2. Then, generic_identify() should be merged into identify_cpu() basically
   turning the latter into a single function which does a generic CPU
   identification both on the BSP and on the APs.

3. #ifdef CONFIG_X86_32
        enable_sep_cpu();
#endif 
	that gunk should be stuck into a function called identify_cpu_32() and
	you'll have at the beginning of it

	if (!IS_ENABLED(CONFIG_X86_32))
		return;

   and then you call that function both in identify_boot_cpu() and
   identify_secondary_cpu(). This way you streamline the paths and drop all
   that ugly ifdeffery.

4. When you do 3. above, you should be able to move this gunk

	#ifdef CONFIG_X86_32
        set_cpu_bug(c, X86_BUG_ESPFIX);
	#endif

to it too. And now everything is nicely encapsulated and straight-forward.

5. The above will allow you to have the init_cpu_info() only on 32-bit.

Oh and, looking at the ifdeffery on identify_cpu():

	#ifdef CONFIG_X86_64
	        c->x86_clflush_size = 64;
	        c->x86_phys_bits = 36;
	        c->x86_virt_bits = 48;
	#else

you could probably add a identify_cpu_64() too. Or maybe the init parts should
be called separately init_cpu_info_32() and init_cpu_info_64(). You probably
need to see how it looks like when you write it.

Oh, and each 1., 2., ...step above is a single patch. This'll make the review
very easy too.

How does that sound? Willing to give it a try? :-)

If not, I could try to find some time and do it myself but I thought you might
be willing to try it...

:-)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

