Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CE3CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 470A58E000A; Thu,  4 Sep 2025 02:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447B68E0002; Thu,  4 Sep 2025 02:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384B68E000A; Thu,  4 Sep 2025 02:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27ED98E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:38:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD2721A09BF
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:38:44 +0000 (UTC)
X-FDA: 83850614568.17.B642927
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69B5D40007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:38:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TEEa2VkP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2XVkscTs+i5+vJ4MKvvhrBrD/Sub/SqyCqSzizvVaI=;
	b=KGq5IZuaaCR9myAmzNJZwkmmA043lWkc+Rx9F6Xk+dmaHXjANL+Hryf8YhHdAN4JSegMet
	5sEplMsI4h45M0N0tUBM8IlWi7uctgFJuJEL7PmcCHDEkq07l1/hRrsDNtbMzBVB+Kjj2p
	WNqIWRbIY91KBsxkO1aHD7dy2BR8qNo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967923; a=rsa-sha256;
	cv=none;
	b=a8W8rd5ngQmedz32RgGA5S4cwFr0S3wSxYviuPeEvzDhD9enYY6ZCHGo4cU5eoRNkL8GPo
	FdepNaQu4mNytESvvFkRSf0qK5H7tcNj1kd9LbiAb0frGzjt3NWEwMYQaHQeEe4+A+xHkD
	fIAQFbGnR/QSuy5g9rfR1Ud26khQTz4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TEEa2VkP;
	spf=none (imf11.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V2XVkscTs+i5+vJ4MKvvhrBrD/Sub/SqyCqSzizvVaI=; b=TEEa2VkPTiHLXKQrgzL4vG3QGH
	gaGelYhttVsACG0Oxs7GvaX1pKbt9vf/ogJSTh7jCe67bdXmvGAHLL6R4TFru0IQdfxzjaygKBkoi
	cPZ/vInmWvN9w3pJ7k8u6s/D9pCM4SgicC975q5p7GW+kKYCn2g3HuN7TjzB9wiTFrIuprW0p9JKE
	vo0OLncH+axpSmIImS0pJdSIq220xc0FDW/rXZ4IYrNblbUOwgFe4ZP3sgP80fEJPUsTceVC+OXPK
	bV2LTSSXu4+XsieyC/CIOaJ03D7WvHybOtbqZfsRXxZl628Yys0i72q+o17rgodLPRr6Cro4dYAtt
	b/sNSGRQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uu3c9-0000000EDik-0fUS;
	Thu, 04 Sep 2025 06:38:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E43A63002BF; Thu, 04 Sep 2025 08:38:32 +0200 (CEST)
Date: Thu, 4 Sep 2025 08:38:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/18] x86/hw_breakpoint: introduce
 arch_reinstall_hw_breakpoint() for atomic context
Message-ID: <20250904063832.GT4067720@noisy.programming.kicks-ass.net>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-6-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-6-wangjinchao600@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69B5D40007
X-Stat-Signature: bbpq1zkbsm5diwa1diugq39jatg53dm9
X-HE-Tag: 1756967921-238344
X-HE-Meta: U2FsdGVkX1/c/cv7MCoxGM1eq2pqNwlZM5y68F29RBuEyR18HOM3jNtj28w2Dqh7CAHRbf04Hko0XP4q+rXFPqW+afxn0PO6yYin+tq0lDkIJzYbw3loDfFHEq5a2w5xWlWPiFdHV7A8Faxsp8ggscwqBY465IxaynTGPDM0jam3J9C9FfXjPBONKfNfWi1iSi5t5bvHOiOTHvOFv3Bqpikf1UDffm/fruBBtEq2wZil4/o3U219iIBoCwh/cWkVasAopacsTd7q6/AuJMND5XBQem/5V1+7HZVGHs8U2E2BF0Ni2hEFhym1zay/VaZxXSXVY23BNq2Wc1aNxc0kGmIig2XzdZhzqC9+oxhdy1j6QTc04YZKtShawHLTQoLXM2d4Ql1Z9t+xvTQ6hWCsliwCidtRHNV8zskQBKSRNoVrgk31ryxxRc50bL6ZVloB1N7iloblQl2T+WQ2TL//H0AmTJbInacDZboPkh/wr2judl6oecTlCcTQ3C4aa8tLVbfthpxrcckyAJ4oORrIYOkLncHPQ6Ukusiwt3vVS22QSsxSkAQanKKKh3i8H6gHGQ3aRnEfc/o/EMIx4ATFvSPm4jOFGjd8LVSxRdsSgIJFEYta6dG3Zitx+koiuuGSvRVyYQEQuQZW3D2rQg5qeFd6GLn+txgouluHUO3EOi1Z2QnCTLIHFUMt4fLf6VLai0VMh7+HPpOwJtHhWOjv1TVw/R04eGImWJ3MRhCmG0KAB1U7CYeK7RYdhUKUMYIzf4WZ34hF8EEj+kphlU97Ha6VtxmRLS/pHcr8vMWZ7/VHf5G2+D84CLh+rKgneuV9VuRTU+ivLNGCfWvH5OqKFSjZXlIsn8DK7TLSpmusTJ6JW1LtO1dQ0h8MwsE7lb+BJQeHKVtjWgl/1dhLTFjFsaQg13pjVoOvCtAdfR8vowICXR+KUb2tCKw+lq63+r1vUxdTYhl1TQNwleAKLtw
 53JT9gqT
 NOpRuNN+jkmpZnmI6KB9fE58N73zb/n9+E2xdS10XoOlQf0fxNCCj1QpP9EVc6QA68gdCJBo06MqIcQIjnYemXS2GeJkL/13rO3DaxdC+jDoYimYWe8aFBA8uZ2TJAV+bZcZaB1HNZMj9I3oTCIEc8fZGwpBwXIGR2PQcY8Mvftf+AfE7Jr/UfDCfXtQLfbcBJv6cBPSbrX+SIyKlcHyl9eu2cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:21:02AM +0800, Jinchao Wang wrote:
> Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
> parameters (address, length, type) without freeing and reallocating the
> debug register slot.
> 
> This allows atomic updates in contexts where memory allocation is not
> permitted, such as kprobe handlers.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  arch/x86/include/asm/hw_breakpoint.h |  1 +
>  arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
> index 0bc931cd0698..bb7c70ad22fe 100644
> --- a/arch/x86/include/asm/hw_breakpoint.h
> +++ b/arch/x86/include/asm/hw_breakpoint.h
> @@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
>  
>  
>  int arch_install_hw_breakpoint(struct perf_event *bp);
> +int arch_reinstall_hw_breakpoint(struct perf_event *bp);
>  void arch_uninstall_hw_breakpoint(struct perf_event *bp);
>  void hw_breakpoint_pmu_read(struct perf_event *bp);
>  void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> index b01644c949b2..89135229ed21 100644
> --- a/arch/x86/kernel/hw_breakpoint.c
> +++ b/arch/x86/kernel/hw_breakpoint.c
> @@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
>  	return 0;
>  }
>  
> +/*
> + * Reinstall a hardware breakpoint on the current CPU.
> + *
> + * This function is used to re-establish a perf counter hardware breakpoint.
> + * It finds the debug address register slot previously allocated for the
> + * breakpoint and re-enables it by writing the address to the debug register
> + * and setting the corresponding bits in the debug control register (DR7).
> + *
> + * It is expected that the breakpoint's event context lock is already held
> + * and interrupts are disabled, ensuring atomicity and safety from other
> + * event handlers.
> + */
> +int arch_reinstall_hw_breakpoint(struct perf_event *bp)
> +{
> +	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> +	unsigned long *dr7;
> +	int i;
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	for (i = 0; i < HBP_NUM; i++) {
> +		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
> +
> +		if (*slot == bp)
> +			break;
> +	}
> +
> +	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
> +		return -EINVAL;
> +
> +	set_debugreg(info->address, i);
> +	__this_cpu_write(cpu_debugreg[i], info->address);
> +
> +	dr7 = this_cpu_ptr(&cpu_dr7);
> +	*dr7 |= encode_dr7(i, info->len, info->type);
> +
> +	/*
> +	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> +	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> +	 */
> +	barrier();
> +
> +	set_debugreg(*dr7, 7);
> +	if (info->mask)
> +		amd_set_dr_addr_mask(info->mask, i);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);

Yeah, I think not. For one this is an almost verbatim copy of
arch_install_hw_breakpoint() with zero re-use. Surely you've been taught
better?

And why would we want to export guts like this?

