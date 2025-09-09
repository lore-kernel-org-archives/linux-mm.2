Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE289CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 08:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6878E0011; Tue,  9 Sep 2025 04:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276848E0001; Tue,  9 Sep 2025 04:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165238E0011; Tue,  9 Sep 2025 04:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0AB78E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:00:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EA6285F11
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:00:25 +0000 (UTC)
X-FDA: 83868964410.09.5DFC5B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB035A001B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:00:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ob+6CPee;
	spf=pass (imf15.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757404823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+Qe6JGkrtPesYVOl9Dp97PHNytIu6mN82AgKRIRK/w=;
	b=sYlBtHgH4aRvEYQzfT9h34a/+c/KlYtewMtxG0g8ZD4n4+0fK8U5r06q3Az6KOjakEHPPc
	KSLvcesLvO7LZdDIMjzYz8Pis3UGMaHsoAjfTmEm9F0IfJfE7Z1AqYPqMSlOjfMaK7t85X
	e1dHQPU0xsz6/TV/7Mk/Zk79YoERtLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757404823; a=rsa-sha256;
	cv=none;
	b=rDgDB5WBLX8VXRJq8DFUeXpmYBHW1QZSPDpdPnl2CWNbd4YHqLdg09ESbiv56noqQvBXCo
	u0SBmKIUpFT/pu8fDK3taRiz2zChJxpKTOgwPqqsWBvGT/r1gvgAxek+kaH2Tda+eTpjg/
	RxMDrU2/e+ElJ3AKQtq512iZ1CpDy8A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ob+6CPee;
	spf=pass (imf15.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 432BF44CD6;
	Tue,  9 Sep 2025 08:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9383C4CEF5;
	Tue,  9 Sep 2025 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757404822;
	bh=K7GblolWpH5vXVt7lV0OwPq0/5beVmtAVKdl40YTYVI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ob+6CPeeInY7cEDDkLJkolERb1xruKi8RF2xolA3kA3KbGl+f1j4eHFnnB/FIpA3E
	 WGSSxLBq9AL+Wncf73XRrwALw7eckgNr6JjvUF/IYXphwn/PH4Z/3WZ69YK1XiTCr1
	 BEhynHQs4Ez+Plfb9/qgPBdgEGgHVpgkrWZPkDqZx0yFBAmGM5eE99BN9sDa8XnzpF
	 D0e+MpU4dMGo+o9G3tzQlFjPaPe/V0swBQ/SLNMmi3wjUaIViKYaMGc2oLmiPee/xH
	 vSpdnsRsjhYHXpQS3b0rTUNV0xNxrRdZt2js02hBb+vnDWkCxL/HoDjGbuFh0b59xF
	 G8ujjvYOmi+oQ==
Date: Tue, 9 Sep 2025 17:00:17 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 "Naveen N . Rao" <naveen@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, "Liang, Kan" <kan.liang@linux.intel.com>, David
 Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-perf-users@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/18] x86/hw_breakpoint: introduce
 arch_reinstall_hw_breakpoint() for atomic context
Message-Id: <20250909170017.dae27d8be77f9ec634e0d56c@kernel.org>
In-Reply-To: <aL5ns7h1NaoD9LPg@mdev>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
	<20250904002126.1514566-6-wangjinchao600@gmail.com>
	<20250904063832.GT4067720@noisy.programming.kicks-ass.net>
	<aL5ns7h1NaoD9LPg@mdev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BB035A001B
X-Stat-Signature: 9zx9pqr4p44w869mj48wxy1r6ggmcbfo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757404823-326834
X-HE-Meta: U2FsdGVkX19NH5viitLqh82RKfR/22Lmt/jCwb7uswbqN0WPcxwrdMjUcfcva8TwMZuStK89bMl29SnzSjp2OGdhH/UVEayt9jr7AC5evsEyaBWjPZVAzqLqdoJaAw81el98RTVnUbd+Gk6JzeNmNy2AVpn4Xn4drK6PIqIsUVf6HvSB7zTNnxtH+LylNQhfKvDkRZgfMGGgNDPVdlzXKd90SX7G42G0D8BYlRiJDMyBHfGM6N9uer0jB6Rvmh1GVniHdEvgsN/EiNEbpgnyyv0wM7IoQxcvH6Ivqft5vvyecQntP9ZZJzGn1LytFg7qD0DhtZX58o7T3fLO5hIQDSu5XQqPC+mZXR81Hsimts78UNrVrcKALNCDvIKSqBRcNT+Kpb1agt6OioODjZEFIKdXzFEXsTbSTJpiPk8nTcrfK6xFP4630WQX/x74BTxeSOydroUgrdrtCnJDuV0erghtvXRT3OlbbbyrZiFzckrQLaZ5GSi8JUhqY/Ilaz6u0hXljU1wyvalmkr+AqxrlZgZevzSowkMJknsMSQtduzC9SkMl0ZqCKo/96i5+HsyCM1oLBiRvWszOBz2wuRRzLdWT5APptnHDy+bdko5St6uNpDx6CEH6xr2YghGF/xOnFAS89Vn3T/h96Fh3BX0sDmL65Ld33qtkwOPXP3vSaxT1EJMtAlW+w1gmFUM8NbtWKiWHMmvwMuq8ADiW4GFHkqzmlrE5ug/CaTqBiZjEqm1HdEIM+HWQjmNjOcKd18l6hSTBYP0c9+mrlyh7lgBVcSHec6JRlAtj5QctneuvQ6PeITiP8cqH9Vgb0mej0YZJklmCr3MBzTwRw9nYB0AfMnzj8+MZCHl0Sm0n+n0bxVQNdGFVJs9eNDh6M2GTZYZPgAumt0n3HMVFE6kueQ7nafAY5mKHUTgF6QvUYgZEyq56HiLw4UQEN4p8O5+0NM6+Fe88NrPEwMJ7m9aEBN
 gl3h2wxU
 PLIPS4azUpjkmA/5n0KaV6sdBet1d1d81WSXtj7AcfIpU/6ZPgPLyf0YxxJxe9iy+9y2x6MFNaD5sKtV+I9lyfKn3VjVw7ojVaAcNLdt3lC8Cb06swsmHbtPfXvEdLdbDazEf0aQJZSQEJWdeoB/YOhtzhioYB7jbHsoQY+qMPBDyRRA/1OumCUa5Q2J+942EzV/0e+APOYG01y76Reas6olDXCp6UWAn5yNajXk1toKmg9aOFyTLr+v9/W1aJkhujkQfWVUnPtsOhZ6EwKH1cwyjO0k0zySGW3Nh60emIfRm66/AXZxxN+AM0QX9rEn9fN/3Xm4S8M11a2hafGN9LZ2YOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025 13:20:51 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> On Thu, Sep 04, 2025 at 08:38:32AM +0200, Peter Zijlstra wrote:
> > On Thu, Sep 04, 2025 at 08:21:02AM +0800, Jinchao Wang wrote:
> > > Introduce arch_reinstall_hw_breakpoint() to update hardware breakpoint
> > > parameters (address, length, type) without freeing and reallocating the
> > > debug register slot.
> > > 
> > > This allows atomic updates in contexts where memory allocation is not
> > > permitted, such as kprobe handlers.
> > > 
> > > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> > > ---
> > >  arch/x86/include/asm/hw_breakpoint.h |  1 +
> > >  arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
> > >  2 files changed, 51 insertions(+)
> > > 
> > > diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
> > > index 0bc931cd0698..bb7c70ad22fe 100644
> > > --- a/arch/x86/include/asm/hw_breakpoint.h
> > > +++ b/arch/x86/include/asm/hw_breakpoint.h
> > > @@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
> > >  
> > >  
> > >  int arch_install_hw_breakpoint(struct perf_event *bp);
> > > +int arch_reinstall_hw_breakpoint(struct perf_event *bp);
> > >  void arch_uninstall_hw_breakpoint(struct perf_event *bp);
> > >  void hw_breakpoint_pmu_read(struct perf_event *bp);
> > >  void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
> > > diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
> > > index b01644c949b2..89135229ed21 100644
> > > --- a/arch/x86/kernel/hw_breakpoint.c
> > > +++ b/arch/x86/kernel/hw_breakpoint.c
> > > @@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
> > >  	return 0;
> > >  }
> > >  
> > > +/*
> > > + * Reinstall a hardware breakpoint on the current CPU.
> > > + *
> > > + * This function is used to re-establish a perf counter hardware breakpoint.
> > > + * It finds the debug address register slot previously allocated for the
> > > + * breakpoint and re-enables it by writing the address to the debug register
> > > + * and setting the corresponding bits in the debug control register (DR7).
> > > + *
> > > + * It is expected that the breakpoint's event context lock is already held
> > > + * and interrupts are disabled, ensuring atomicity and safety from other
> > > + * event handlers.
> > > + */
> > > +int arch_reinstall_hw_breakpoint(struct perf_event *bp)
> > > +{
> > > +	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> > > +	unsigned long *dr7;
> > > +	int i;
> > > +
> > > +	lockdep_assert_irqs_disabled();
> > > +
> > > +	for (i = 0; i < HBP_NUM; i++) {
> > > +		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
> > > +
> > > +		if (*slot == bp)
> > > +			break;
> > > +	}
> > > +
> > > +	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
> > > +		return -EINVAL;
> > > +
> > > +	set_debugreg(info->address, i);
> > > +	__this_cpu_write(cpu_debugreg[i], info->address);
> > > +
> > > +	dr7 = this_cpu_ptr(&cpu_dr7);
> > > +	*dr7 |= encode_dr7(i, info->len, info->type);
> > > +
> > > +	/*
> > > +	 * Ensure we first write cpu_dr7 before we set the DR7 register.
> > > +	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
> > > +	 */
> > > +	barrier();
> > > +
> > > +	set_debugreg(*dr7, 7);
> > > +	if (info->mask)
> > > +		amd_set_dr_addr_mask(info->mask, i);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
> > 
> > Yeah, I think not. For one this is an almost verbatim copy of
> > arch_install_hw_breakpoint() with zero re-use. Surely you've been taught
> > better?
> I introduced this to modify bp_addr in atomic context in my RFC series.
> I thought it was clearer to split the introduction and refactor.
> And then It was used in the wprobe series, so I left it as introduced
> in the RFC series.
> 
> I agree your suggestion is right. I am willing to refactor after wprobe.

I'm OK to refactor it to reuse arch_install_hw_breakpoint().
My point is to have CONFIG_HAVE_REINSTALL_HW_BREAKPOINT so that
we can easily implement the dependency for other features which
requires this feature in Kconfig level.

> > And why would we want to export guts like this?
> I wanted to introduce a real-time stack corruption debugging tool,
> which needs a helper to change bp_addr in atomic context (kprobe handler).
> And wprobe needs it also.

I agree with Peter, it should not expose the architecture
dependent code directly. Instead, we need a wrapper.

Thank you,

-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

