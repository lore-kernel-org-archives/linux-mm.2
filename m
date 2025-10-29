Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578BFCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F07F8E007A; Wed, 29 Oct 2025 10:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2368E0045; Wed, 29 Oct 2025 10:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891228E007A; Wed, 29 Oct 2025 10:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 726C18E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:49:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E1BE140814
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:49:09 +0000 (UTC)
X-FDA: 84051434418.08.08FC52D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 807E5100010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:49:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlja5Mq4;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4c969Ew16GaJeZGLcqILIvlzS8wxu70yq5/8cQrC1U=;
	b=CaNowG0JY3Lf/v8U6Vd1sHm8FSVX1EyPwZ9ZlbOlL8jI/8yJmW4rEGe0TtuFZSnUI+fGsF
	+IZnXidAbSZXcsIMm5TkitCVeD1c9IelYb7RoszrnFBlQBsMcRNq9mbpfjE80OoxgKT6hG
	XktvZ7+jMRBy3w5FHaL5AWfYOrHX/y0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlja5Mq4;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749347; a=rsa-sha256;
	cv=none;
	b=0Jpp4y/HDr9SQYg8XjF1l3G3uo1QtQy+Y969WlvvAG2JIri5b+orx+Fix/OV/l0X0vXpPM
	RN/zVqe7DllmBhhJZ6TbugWiEqep31dqSJuA78mzcEuxjMeNJTwLQ4QMQflB0Tl/04/kIK
	UUWClRG95T2YhUwKoH9jYYv9koZWSgI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A44E661E65;
	Wed, 29 Oct 2025 14:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA588C4CEF7;
	Wed, 29 Oct 2025 14:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761749346;
	bh=HxTqJgI/0X/CEmspyZav8h3FXPWX3qB1qsKFzsoN4as=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tlja5Mq4eRWp697QA/xQ+7a9KJbcnrMdob9cxsXt9OIQA755+bFzbNzRv16bZ4K7i
	 B9LDftZXKO7gStpMqGdXCVrWsVQ+ROKQ4K+QvkxPz38VTj++u90ce6yRHNCsPSi5pD
	 v/JhE3LMKbYoWFWsQEzSVXb3Hm7XB2z8+8xOj7ZC7Xvnlx4rEDqU8ejlyTgLe/T9R2
	 3vUJArOhgOLb46RZqe+pCWQx7olKyL6EJb+OqaocNuhbMh3d/KGFm/ek9z7wlrO99H
	 rF7V3yVMeDSwqgzEw1be+gsJR70/J/KwRrqpNcrj62az9WVQF5F5bIT1qWPQ84EK24
	 yw1IH2IxbPQpw==
Date: Wed, 29 Oct 2025 15:49:03 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
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
Subject: Re: [RFC PATCH v6 27/29] x86/mm/pti: Implement a TLB flush
 immediately after a switch to kernel CR3
Message-ID: <aQIpXyX-z8ltB1i5@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-28-vschneid@redhat.com>
 <aQDoVAs5UZwQo-ds@localhost.localdomain>
 <xhsmh3472qah4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQHtBudA4aw4a3gT@localhost.localdomain>
 <xhsmhwm4dpzh4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xhsmhwm4dpzh4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Stat-Signature: rfpx6t7ju77rj7nmio593zx1nkx7jt3r
X-Rspamd-Queue-Id: 807E5100010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761749347-923734
X-HE-Meta: U2FsdGVkX1/wkuPPve/vQuuR8WPV6rEyx2jrUViz08BZG7p2eO4Fe1uV06qakMwx39V4SfpvJ6ri+on/tERfp388POTQ5ggFTQKP12c/DLviEJjJp34eTd/o56cNcbxUGYEnoHn9LnC3mEfLmj5ek/bRAMcPpHDCd/xg6lhJM0X02T9Ah3WFc6kF++idcQLD8ulrDBgqQW7Briudk90CiLjJBqB2cJt/OoL3Gy5ufCNeBjvKhUQHQc0SZx+AmVPi2wYVL7IEKlSxUfi+ghVijcDm2byyK+JEQR1NBfU6uLfJ9nghCJT9f+5jH5cJ+4Ke5xdwH9xGaQZVHg6oki7xKO06VAz+GisaI96BuPnBPsXVjh7lzucy0WHdLaKyPwiQTat2GjC7KkjxhUw8DrDaVcdv5lQOnoUtqOZyj/aeVU8WkIW3KgnUuQ4xGckU64EGCX4bOr+fMwnX21wJbWOk61fSfXCO1E5v4ZQcZOkZJW28MaoVuvJVMjkstM8MNpyBL9sEXahXNDpqz7676B9zAIpNvwePqCsDixJjiD2He/s7GxK9TbcZZa0mInGP02CM1n9v1gt3USX/YRe6pqcNC9re+ujVt3Fw6MQQkjcQeEeKTY6kOJWNmSBtpDIKuoviYCU9cPXi+iJtPq7v8jg3qeEltkEgHHSo5/8pApGU7janYos7cL9MXepx06jdw27Z4BgTWGGT/kXNoIn70+siCYaHzdeU1OUoKetlewu809LDpfQ8gsrGHZqXnB34c3OsknZwnKYekHe2ZLBIkUKnjTX4AS9YetdaUyyFGmgu07jbTcIphoSlpRFxWlmIyOUtx8kCGjBo6ycCx3RH911mZ4DwqMVMk2lQRzusq3cstDoYuGarJcoaUSaVcGAgVxrF50JWQxwoXiOErnrPaImSZ9hx9hiNxpZcPov5Txz4IKedxyR4M/DYi6Ah8//Y7VxH9sNbKKeRNctp0VGSxwu
 E+Dk3QI3
 71EoQZebFtk1ox2SZzqTfimi8aGpOvLHpC0DTix3kDcLLsHqvh7fWPuM8u2ESEnJYoLWxG+sGnp4LfAgf3HNris0IilF1bnC3FlR69OO6qHtP0/sQuUPF4nBhcgoQYCLW0dnL1BApe5aNupFbfZaFnUk4E8ixJXcaWJvHjRSCb2wjCNe4KD5drGuDzkg6oMfXS1Bq9oCY1pibh7IVdGiZw3u9jRdhlJpnF9beBhKPfcjY9kn7XbvwOpE6WwdOmGaEdBl8DVquH6j8AhS8UqzY7KNyITdxr5cUDORi8vnz/Jjer3d6TXYrC4iVcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Oct 29, 2025 at 03:13:59PM +0100, Valentin Schneider a écrit :
> On 29/10/25 11:31, Frederic Weisbecker wrote:
> > Le Wed, Oct 29, 2025 at 11:16:23AM +0100, Valentin Schneider a écrit :
> >> On 28/10/25 16:59, Frederic Weisbecker wrote:
> >> > Le Fri, Oct 10, 2025 at 05:38:37PM +0200, Valentin Schneider a écrit :
> >> >> @@ -171,8 +172,27 @@ For 32-bit we have the following conventions - kernel is built with
> >> >>      andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
> >> >>  .endm
> >> >>
> >> >> -.macro COALESCE_TLBI
> >> >> +.macro COALESCE_TLBI scratch_reg:req
> >> >>  #ifdef CONFIG_COALESCE_TLBI
> >> >> +	/* No point in doing this for housekeeping CPUs */
> >> >> +	movslq  PER_CPU_VAR(cpu_number), \scratch_reg
> >> >> +	bt	\scratch_reg, tick_nohz_full_mask(%rip)
> >> >> +	jnc	.Lend_tlbi_\@
> >> >
> >> > I assume it's not possible to have a static call/branch to
> >> > take care of all this ?
> >> >
> >>
> >> I think technically yes, but that would have to be a per-cpu patchable
> >> location, which would mean something like each CPU having its own copy of
> >> that text page... Unless there's some existing way to statically optimize
> >>
> >>   if (cpumask_test_cpu(smp_processor_id(), mask))
> >>
> >> where @mask is a boot-time constant (i.e. the nohz_full mask).
> >
> > Or just check housekeeping_overriden static key before everything. This one is
> > enabled only if either nohz_full, isolcpus or cpuset isolated partition (well,
> > it's on the way for the last one) are running, but those are all niche, which
> > means you spare 99.999% kernel usecases.
> >
> 
> Oh right, if NOHZ_FULL is actually in use.
> 
> Yeah that housekeeping key could do since, at least for the cmdline
> approach, it's set during start_kernel(). I need to have a think about the
> runtime cpuset case.

You can ignore the runtime thing and simply check the static key before reading
the housekeeping mask. For now nohz_full is only enabled by cmdline.

> Given we have ALTERNATIVE's in there I assume something like a
> boot-time-driven static key could do, but I haven't found out yet if and
> how that can be shoved in an ASM file.

Right, I thought I had seen static keys in ASM already but I can't find it
anymore. arch/x86/include/asm/jump_label.h is full of reusable magic
though.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

