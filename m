Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5D8CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5388E8E0005; Wed,  5 Nov 2025 12:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510668E0002; Wed,  5 Nov 2025 12:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D228E0005; Wed,  5 Nov 2025 12:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 336618E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:46:35 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 945D11A044F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:46:34 +0000 (UTC)
X-FDA: 84077283108.23.1C281FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1992C0014
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:46:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7Mf6l0a;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762364792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ml2ENV49YDjBG99uR33VmgiseqTqkLu/oQRDXQnYV0A=;
	b=Q3DrZWhtyyZwwKxMfmN3N1XfsebQZh/BKFgFxr4znKPiY/p7SIqQ4alB9tUYHAmqkBsyA0
	FnbujBirwTB/TGa3Cgl35Imz1IIk/vQr/jCCGBosXfgcH8lQkyP/Hl/apTFY8UaPnyBT38
	mP8216GJ9jKng6YV3LpDaaOfv3fE+W4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762364792; a=rsa-sha256;
	cv=none;
	b=PN19jrYHeX+gur8vEnHkTf6SWzrCjf7XA4BD2/hGwIw1RY9Pjp8glTsLE9q2va/Q+NnQTu
	NkfUHjmCpei2ivSbs4/zDDKMQlYZ9NPr+xaPcvDoRUrJJxTTsRgw+irlJUiBA/3zV9HMft
	mYBQuk8fcgHm7cVqqv1Xhqiis2x//ew=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X7Mf6l0a;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF14441943;
	Wed,  5 Nov 2025 17:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1533CC4CEF5;
	Wed,  5 Nov 2025 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762364791;
	bh=woawi0pKo/kryyYybe6UTBTWMoVsh5qziqijASjnREk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X7Mf6l0akmdIq5iKgqrPQJacdZIwvZNDplWJ7ZFAiTj1m5jo/r4RZiwBnuufL7FJz
	 rvjLuH5kIUsBewW58/KIJ4AtGpjFM65vgcq5Mq40hqFViVaFYaMO3B+3S2DJBgREr8
	 Ydhgli/Ewi5GXUbKU7XplIRtFLKzGALUr+LrfoBKdNnCob1uuo8LERCMDso+bO1Ogb
	 2kFxvq6vNnlZJHsASSZyjiY4DFFHKnlLj9M1sIw8Xs7M5lI6s7rwKH+tP57RLGeYQo
	 I7shlbbDQcR6rzKbVlqZcx0moVDvOcKmF1aICmG6LscQYeQvqFcaYK64Yfrix1vGrk
	 oPe9jn359SAFw==
Date: Wed, 5 Nov 2025 18:46:28 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: Phil Auld <pauld@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rcu@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v6 00/29] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Message-ID: <aQuNdOEmPYkI03my@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <aQDuY3rgOK-L8D04@localhost.localdomain>
 <xhsmhzf9aov51.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
 <aQJLpSYz3jdazzdb@localhost.localdomain>
 <xhsmh8qgk5txe.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xhsmh8qgk5txe.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Stat-Signature: wo5sxybrtqgwhb1iwk5ghxs1xdsusf6u
X-Rspam-User: 
X-Rspamd-Queue-Id: C1992C0014
X-Rspamd-Server: rspam01
X-HE-Tag: 1762364792-428073
X-HE-Meta: U2FsdGVkX1/DtRd5PtmUan9h5sgerlx1LsPQ2kfmfa+/DP7RidQDcZbtwxYr3rsB7eeGoYNgbes/qeF8MjQ54pXOWUnjwYgJm6m17Mh13OEo6XDvzT6aI0sFvhQJwSUMJPycxsWwYxD+HLyKgUKVosWKxPP0AM8TiY/XPQ4IDpQFPkoTO0xWSaZBODe/T8KTms6xnIgXwX0/9vc1FGI4/xCNP+RPFrvB5UkabaQU5qE0LKk8jhbRDOLXM4gh26yVgpgxebY8vWNj7w6fcuMuVj1M13bb+1NQlCnnGx6BnQk7ZATuk+TaGIJYfe0zPk5F3EJZv5doYr4SI1B68jeCBc8mNDWpQtV5Nps/kZJyhra/GJTO3pV74W6fsF34Z7fhyC1r1DpcLWJCnz4Itp8ID1IFRKPS5CXidAK/uA9YyNRK5WHgz/kxWuvLHTVtYY6WgSlzd5GmHwRyeDeT8eRkyw5Aq3vqTG6y7ZxkFL0T2Wi5iZUC5nKV81V6rBQGfREW5oNGFMegGD6XmADBDgUfGNkVih+M1kHCcO3UsxIkdz6Yr66i0YQGnyMDvPgGjUpDGNyBesZyYpvtTW8eq4hzObdZPqo92CRti2yyXFqUHayWQSSIhqnKAqGTu8VRdOZSZ/w3fXkr0aYd7g3x3310QnbGcQDDe7ExdHNLrGNCxDtAZzt/Fr8NoUSYObEgMgWA1koxyl7S3+J1ylc5EGcXcgPdkl+0vGWwO7y6X1bkrbrUB+L+Ww7qLXn4ciEFxhLQpdQ4LR0vj0F1i1qLDZ6WuzdEgF7o5XkMAXG83e6qYdIJcY5O24P7Aw0Kbhiq5qFiEnjWfuhYMtsu7ZaGf26WHDydin98UFo8AlnGZ6z/XAoL4wp3MSUPGl/dKW1G5ofKHsMGqq0Fai1S4mZMtyA5o5Fy2byETshKCPJzV5HK+rPrX5XsQFrMeqEKAOeACBQxjKLetkXTpt6H73FLixN
 GyZQBIXT
 BpcHaOUIX8RuTP37cyfCB2F6iQr5yvYL3HX7AX2siX9DcjR2GBTNQHgYFjfDmhR2ACOUuQ/4N0SjS3DCfHPqPGsdKku/Tt8Qv6wXWqbRTS1hqO+26F/tCtefQm+pAZUsDYSPzXc1w0hZUGoSTtCyMLH6OhQHoKwLK4ay3n2OaCRj9tGnAOi+wK7l/Ir0RYjI4bo66PoIHoJ9/vZHg1AwI2ck/LujcSd1QQc40SpqVHpZVlxAvw9Pm1VmH6oHc3/2VN93HD8uI/IiMHANy9OzLUCtNgZlyKELpaiQ7zXfVftv5kbeuFD9jrdFuldPjA3vCx6qL4e8HQ0PoYSjimwmHq4fbeUit3B9rYMAgH0F7HtXikVfzhhG5LkAOrjFFmaaXGni1yxMTmbQSCpqgiSkVNkawtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Nov 05, 2025 at 05:24:29PM +0100, Valentin Schneider a écrit :
> On 29/10/25 18:15, Frederic Weisbecker wrote:
> > Le Wed, Oct 29, 2025 at 11:32:58AM +0100, Valentin Schneider a écrit :
> >> I need to have a think about that one; one pain point I see is the context
> >> tracking work has to be NMI safe since e.g. an NMI can take us out of
> >> userspace. Another is that NOHZ-full CPUs need to be special cased in the
> >> stop machine queueing / completion.
> >>
> >> /me goes fetch a new notebook
> >
> > Something like the below (untested) ?
> >
> 
> Some minor nits below but otherwise that looks promising.
> 
> One problem I'm having however is reasoning about the danger zone; what
> forbidden actions could a NO_HZ_FULL CPU take when entering the kernel
> while take_cpu_down() is happening?
> 
> I'm actually not familiar with why we actually use stop_machine() for CPU
> hotplug; I see things like CPUHP_AP_SMPCFD_DYING::smpcfd_dying_cpu() or
> CPUHP_AP_TICK_DYING::tick_cpu_dying() expect other CPUs to be patiently
> spinning in multi_cpu_stop(), and I *think* nothing in the entry code up to
> context_tracking entry would disrupt that, but it's not a small thing to
> reason about.
> 
> AFAICT we need to reason about every .teardown callback from
> CPUHP_TEARDOWN_CPU to CPUHP_AP_OFFLINE and their explicit & implicit
> dependencies on other CPUs being STOP'd.

You're raising a very interesting question. The initial point of stop_machine()
is to synchronize this:

    set_cpu_online(cpu, 0)
    migrate timers;
    migrate hrtimers;
    flush IPIs;
    etc...

against this pattern:

    preempt_disable()
    if (cpu_online(cpu))
        queue something; // could be timer, IPI, etc...
    preempt_enable()

There have been attempts:

      https://lore.kernel.org/all/20241218171531.2217275-1-costa.shul@redhat.com/

And really it should be fine to just do:

    set_cpu_online(cpu, 0)
    synchronize_rcu()
    migrate / flush stuff

Probably we should try that instead of the busy loop I proposed
which only papers over the problem.

Of course there are other assumptions. For example the tick
timekeeper is migrated easily knowing that all online CPUs are
not idle (cf: tick_cpu_dying()). So I expect a few traps, with RCU
for example and indeed all these hotplug callbacks must be audited
one by one.

I'm not entirely unfamiliar with many of them. Let me see what I can do...

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

