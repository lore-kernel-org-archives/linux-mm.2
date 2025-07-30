Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A7FC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47546B0089; Wed, 30 Jul 2025 09:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE846B0095; Wed, 30 Jul 2025 09:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BDB26B0096; Wed, 30 Jul 2025 09:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 891EF6B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:57:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B3E1111D2F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:57:31 +0000 (UTC)
X-FDA: 83721083502.06.6919185
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83DB1100002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:57:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IlcCrv2I;
	spf=pass (imf05.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753883849; a=rsa-sha256;
	cv=none;
	b=GC+noneOqdDyx0w5OoULoRXkxIVoknQUB7ektVOEe/yOPFkhkfnmIpt9yS4i4wiBp1FTtI
	ktCmp4TxWxlJBaVeTvmNMFEshT+iwuDuHwmUccs9fde5khl2ocRrtpIBOrghR3yXuPKqXW
	CnRzOslkgZAkty3yVdk1UbmrIbu0xZs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IlcCrv2I;
	spf=pass (imf05.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753883849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/ZAJTYul7gHAUvwAv/CfnEhGKz8hFQkatFQsbjYEu8=;
	b=PFd43Or/iOhu/i9SIlaHp7ifVPEFEoAcc4ziT+PlW36gZd0r+0/Z7BTnkRtk644I1c+hyq
	TzEg4SlhKJcuUcrGh0GHdb2ouAjQFSFze/vmcf47/cqZ1GyqO5VeG9BDmr62iKmyvLhLJT
	gh05v1m89Gvh1pGb4CLCiS8V6wU2qOU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23ED54626A;
	Wed, 30 Jul 2025 13:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680CAC4CEE3;
	Wed, 30 Jul 2025 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753883848;
	bh=JA07ZI7KstV+Tv5KxzbLM2UL0i9UfNUTw3ZAdpaDeHE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IlcCrv2IwsieOCCkD0nyxBFZTqN8qBdFPnXa36F9WnZopnckl2WvGCoEiiDhS2ryY
	 hYRyqomh352HnUtEUQsWSZI9YKJGw4xlR+q2NhzKU/0RWOUuMdllNjgK+3v6OtXVB4
	 QQwYmLneRmQp/iionec/qXW6TFheSEA3S8YGlSE8vxG0kdLQeBHPE0icTmc+OHG3gJ
	 vLwhMgQ2paCpyxbQ9bc5E2viSDAaRpbrm9NeB/hN0wHjgnqtwGmJeLtHDO9MczebED
	 eA+r1/RJ1uGbGsm4tYR9f1VHAJ1HyOLTB3BHyQM+95bjEhCwTr1peZ0GrwLxUuOTnP
	 VODxAkHvqe/Gg==
Date: Wed, 30 Jul 2025 22:57:22 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Namhyung Kim <namhyung@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/2] tracing: Have eprobes have their own config
 option
Message-Id: <20250730225722.c88d2dbd3dfa07310de7edd4@kernel.org>
In-Reply-To: <20250730091727.7b3a8b96@gandalf.local.home>
References: <20250729161912.056641407@kernel.org>
	<202507301452.JPAcMvT0-lkp@intel.com>
	<20250730191101.7e6203f21b94c3f932fa8348@kernel.org>
	<20250730091727.7b3a8b96@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83DB1100002
X-Stat-Signature: 5dqbtx8hrz3k4mwaca49d643mc314fjx
X-HE-Tag: 1753883849-99513
X-HE-Meta: U2FsdGVkX18qoJKZOyWMwEtkstKQFii8dmZGV8dMZgaNQVYL4DTd/7tFJE4x5mXAPf3gt7v01TKc/i1xYvsOcxTWsaGTER8OhFQL8JBElVApx4ZYkGt+3LGnDZ9zCHrAM2wknuLEudz7uNrULlmn/LPQXcRdJVn84aG9Eskyn7HcKW8xdaPP5EMfw4Jw12UL8tSrBZR69Up+ydBJvg1n7TZwT5pKBjtHzAC/cv6prj/2ytnutT8MN+qPR0E6Al8PfHhL8XKqw3VK3c9RKe+vXQhoEXlNtaGKP4PGyphoqMW2bhcTAy5jnXuaTt/ZE9AZ8DJ2JacuF2PYS0mOuCU5LdKdEL94Ph1LRKw8thsPor14YcWUnpmDwWD0gQPewGD6WSp+0DWrmL8xP38+XF/WMgbPmE9GndSSvszZitZaerXRL/QlzjSNkJN6KR30r6owNzh5oQnxyB3EAYL/zo8DcFPVBLF5L6eprJVsz1G4M6dV3HErjfuY8JEYjuE96DbpePSNQU7d4fJQbvxLTA1/+oU0/nuz8EggLKa0e4ek7mmVo9a3U3iG578sJI5LKLby8Duznmo7qU38N/UOoR9a8mBeHDQH9sQ3gWDF57vugKqnpVj6pmC54J5On0OfjlGlEH09N50Pm5RdRaivvWjBT7pievuwPa5qYM+rHvTCy8h8NO2tJ57M9ePZByicfOcPWXdrcXx4/06ucKYFe8puhJIB2behYbmlGo2BZ3McZC2o5o+Th76F1z+H7wI0E7bxkeet/TR5ilTR1oyW0P11dc+WCtqtjLqa8GhH7RFej1kdOU7t45QDexASbhP18Ay8KqJeakmxquFF8/cQR4BC2nsGb6VIfF0nXK4MZOqd5biCDtfuihaxXu6+H+KWvDs81fo40a5BBBhpN2sjsrQnQ8AbVEtHuh3BcMjvsdrzJA2EebXYqw542uFg3yo9Pe1Iy457XoYZxv/kdNWGl1V
 fNvaD2Xk
 kC+emkpokXY4sKHwAngVTLjk8/LtBKlHKG4/t0dsRfyI7pDCObWTMNQceOOUtEmFSAb7iVu0SzwxocXfBsFyrsAmVRLmdcVmF83oPfk8iOJ/8pUUBRrDKW+d8AzhBT2bfqpevtY/DhuPYdOJAtcS7MnjUbowcFC4NK35T/oOtwZ+UUhW8JC+P//z7FS/78Saof7EQk1wEB4BBV+d/jPetEH4VOwHYZTKYUHMy/r59urCX42PRSceFz+Fi0tHCTSMxqkX7xtTB38KaVpaloWwo7q4ZBGr+Ov3l91pGGNramuiTLxwKU36m/lcKFvkgVAF+BNmoUhJsoCfHua0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 09:17:27 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 30 Jul 2025 19:11:01 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
> 
> > Interesting, this find another issue. Since this is provided by
> > CONFIG_PROBE_EVENTS, we need to fix CONFIG_PROBE_EVENTS depending
> > on HAVE_REGS_AND_STACK_ACCESS_API.
> > 
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index a3f35c7d83b6..cd239240b0ef 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -792,6 +792,7 @@ config DYNAMIC_EVENTS
> >         def_bool n
> >  
> >  config PROBE_EVENTS
> > +       depends on HAVE_REGS_AND_STACK_ACCESS_API
> >         def_bool n
> >  
> >  config BPF_KPROBE_OVERRIDE
> 
> OK, I'll send a v2.
> 
> Did you want to take this in the tracing pull request?
> 
> I see you already did the probe pull request.

Ah, I thought this was for the next one... (but I think it is a kind of bugfix?)

Thank you,

> 
> -- Steve


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

