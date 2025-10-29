Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17056CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675FE8E007C; Wed, 29 Oct 2025 10:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64E648E0045; Wed, 29 Oct 2025 10:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5639A8E007C; Wed, 29 Oct 2025 10:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41DEA8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:53:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E06A9140814
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:53:04 +0000 (UTC)
X-FDA: 84051444288.04.F7E46DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 44F3020007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:53:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NbRDLF5b;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVrVIr57b6fMWh3pA4LxJ9hZO8cVb5LaT8DX+ge7ENU=;
	b=E3ZN91Tuboj3WBjB58SCRgNu6TMkvyVgGs1b5e6IFiVeDamu0bNUW8MD0uDD0Efv4AwCwU
	Me3/aiCMqic/U+lrFn6b6sl/z1v8HaCaO8TW/ULK57oYcTsJUTT40SC7IWg0qynyolrWCF
	SwQVdk9jD9CTvuX7/umZfWs44fNsTrQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NbRDLF5b;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749583; a=rsa-sha256;
	cv=none;
	b=fWHG5CwontmyCXLHOUxtGNmF2HY54Yi/aQpQlB7MCBbUH1evf10R8KfCAXfAqVp51hkQDY
	AlicGMYb8WsVXr7IEJc6a1Rgytrs5v/3AbpPn12ODKVrVymgNEbT/1MtXrpnIk3MsTsiop
	YzcWMYRjnUXDVod5hPHPsVmkQh4gRNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12E3741728;
	Wed, 29 Oct 2025 14:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C64C19423;
	Wed, 29 Oct 2025 14:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761749581;
	bh=DycaBBkGuqgEIP5677gSgx8QDJGofxkMNPMcP3M730o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NbRDLF5bQ+u4J4hiySQAVpBuc86Gn1rrbceqZEKYNWpKF9yoAhVdLiG/Nu9SRzin5
	 ddwOS2DAvBL0w6K59co5lqXWGrpHXdyA3+e94n4XKlatrRRprHxYDEy/DFtpqcJYjz
	 jGBmveuocLom0Tr99M8s/YfJisMETw3u7WfPV8VPmObP73KGTMrcXJF2ZKhuh5kL4K
	 FNZiQ5jjE+Qy5WcINDDA3sOHLfgNQyF9ljeM8CBlvKWvkNPOMLvSsJkY31UBeqPnRr
	 epdow2onJrow0Coha3Tk5/8X8R1mpOEWDHWRuB0t8h2sykd3/evOgK+UEPDUs1Kui5
	 FM7cF5Ys9ZgFA==
Date: Wed, 29 Oct 2025 15:52:58 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Nicolas Saenz Julienne <nsaenzju@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [PATCH v6 23/29] context-tracking: Introduce work deferral
 infrastructure
Message-ID: <aQIqSq2FWyHg0Y3p@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-24-vschneid@redhat.com>
 <aQDMfu0tzecFzoGr@localhost.localdomain>
 <xhsmh5xbyqas1.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xhsmh5xbyqas1.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44F3020007
X-Stat-Signature: m8twz7up5zmrzq8qoa9q68yboqrxa1ju
X-Rspam-User: 
X-HE-Tag: 1761749583-608519
X-HE-Meta: U2FsdGVkX1+V58wNCqIa6DsWg3VuGrDRRujsTeMr1JQLWlayrLhQSlwassNv1NJNnybhQTwm5Zr4c26zr4FeusWlB9lUt6VUii9K+DrAeHgG/XZUMDLkIuBcoKdbQQ9lQLlMxGp3ZyWI5rC+tfQ5PKWkxMWpHKZqYYT1FEIJmwQrXqGK23RvFwc1HS1tUTe+2gDQpgb7NB5P0EQJShygWKu3BXRslY1eyJ8SCuGdygpx25LbTPdfT6bzavumpF4fKj5knQwmPv+FpDsj3/dOt9h4SioC83SOj7mcbvotAN+xfew34KjQu9yIIoj6qVpcDfLbSlB6nMmbYN28ZyeiZxPLnkFbRDmEiHXvVxgfz+IGj9JK5VwJrvnke8tW0BAfl/daA6BwcMDHjAWcLyIvp+sYLdps9xykV8k+4l6MoLFjLVR+f3VQtJREkVQIaR/FXmLgafXeWiExxAiuzhUxaUbmyUxupaVgCXEL4ArTOg/NSnuloIC76hiRJMNpyCiVCeVkofy9jnqkonvKN0B0fB/XACB20XTpJ5BfSz19PYU/qbm8H2KZd/WtJfih9sVvFOMEKF2y690B1L86ha2YZjBsMdXvwA+qWcZESCo6IS/wcYZyxG2fkDooRG0qBlMtziDt7DBHkhXkLme1vzXqcn0rAdGYQmdxwjp0k/XRQ/tBH/RBSvm0ppfey+vG3yvofKWzhSb8HOgil1+abxNk4LR0JuFZ1KQR+Kdyvcgu3GuqMOOBMrqAdOfmuEfYoLyeEwg2zWcrA6T+f0fDwiRas9VlEFJS2Pn4UlzYRE9L/yD1KQ6gX8fhsCiph267y5sBiCtCSaKetTx2OuSFOrA3Qpb3vfUWIZCCBzHrTyjZ5PtGKmizxxouIMZncXUNu1nkZVPsiRf8P0vkwRRJs5Fcy3lK1SmsDkoF2nOuYNx0HuW2ryYGxzG5Y93AdJIbR8TU28KO6erP4raAVrPu5Ri
 b0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Oct 29, 2025 at 11:09:50AM +0100, Valentin Schneider a écrit :
> On 28/10/25 15:00, Frederic Weisbecker wrote:
> > Le Fri, Oct 10, 2025 at 05:38:33PM +0200, Valentin Schneider a écrit :
> >> +	old = atomic_read(&ct->state);
> >> +
> >> +	/*
> >> +	 * The work bit must only be set if the target CPU is not executing
> >> +	 * in kernelspace.
> >> +	 * CT_RCU_WATCHING is used as a proxy for that - if the bit is set, we
> >> +	 * know for sure the CPU is executing in the kernel whether that be in
> >> +	 * NMI, IRQ or process context.
> >> +	 * Set CT_RCU_WATCHING here and let the cmpxchg do the check for us;
> >> +	 * the state could change between the atomic_read() and the cmpxchg().
> >> +	 */
> >> +	old |= CT_RCU_WATCHING;
> >
> > Most of the time, the task should be either idle or in userspace. I'm still not
> > sure why you start with a bet that the CPU is in the kernel with RCU watching.
> >
> 
> Right I think I got that the wrong way around when I switched to using
> CT_RCU_WATCHING vs CT_STATE_KERNEL. That wants to be
> 
>   old &= ~CT_RCU_WATCHING;
> 
> i.e. bet the CPU is NOHZ-idle, if it's not the cmpxchg fails and we don't
> store the work bit.

Right.

> 
> >> +	/*
> >> +	 * Try setting the work until either
> >> +	 * - the target CPU has entered kernelspace
> >> +	 * - the work has been set
> >> +	 */
> >> +	do {
> >> +		ret = atomic_try_cmpxchg(&ct->state, &old, old | (work << CT_WORK_START));
> >> +	} while (!ret && !(old & CT_RCU_WATCHING));
> >
> > So this applies blindly to idle as well, right? It should work but note that
> > idle entry code before RCU watches is also fragile.
> >
> 
> Yeah I remember losing some hair trying to grok the idle entry situation;
> we could keep this purely NOHZ_FULL and have the deferral condition be:
> 
>   (ct->state & CT_STATE_USER) && !(ct->state & CT_RCU_WATCHING)

Well, after all what works for NOHZ_FULL should also work for idle. It's
preceded by entry code as well (or rather __cpuidle).

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

