Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18907CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AE58E0062; Wed, 29 Oct 2025 06:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBF98E0045; Wed, 29 Oct 2025 06:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAD38E0062; Wed, 29 Oct 2025 06:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE6E8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:31:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAC27BB89A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:31:39 +0000 (UTC)
X-FDA: 84050785518.05.6272AC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 04848100010
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:31:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQHpiMhH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761733898; a=rsa-sha256;
	cv=none;
	b=T4CCk9A/4hi8G5pCIAwg8wcwX2uEobG7TPidDyg2bHPVVHWl1G9aouKCuaqHGwasr0JTs8
	RBwO+V6tDuEAn5kztpNehUF383oIe6rpUmTZefdCNQBUEScMuc+9SZ4KnU7L28qjZoLjCy
	zcoZUQmduCJKI9kDBwRhrEzRy9bzuAA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mQHpiMhH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761733898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTXnL9UXH/iauUvH958Y5ZTz4Dt6IJaJSNAQ122UEVg=;
	b=nDQDgor0xgOxrAdl+n56lFFqY80KA3dMG5iZGsPBif21snyHZNniwIbyqG5TyT/v51+6Sz
	DwpPzIeh2QjtjMdFY2bg52crWOBX62W+ozJ726w4VwMQhV22uLK6s77LFjk6wl2S4N+vMx
	b5N9oDkNrTDsKfBKhNVA/XBFoo6dXZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09C6443A44;
	Wed, 29 Oct 2025 10:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4DAC116D0;
	Wed, 29 Oct 2025 10:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761733896;
	bh=Kk/z5xbjPIxTq926BScJO1YbAE6B21A/nQcvL+Stxjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mQHpiMhHIipyykg71nO9gr0ccOWvAw3jtxADhT6O9/iW0PpIiw/qmz5zVTUW3oo0Y
	 Yq4gg7lmHuk8qvkB8w7kGP3dJ/Es/yfXH9Z/5NpT3GdhmC3rdV4d9InuM6AE6YDHuy
	 66y1CBVkVJ47bCQATzwguaNY0rGy4czAnJJf2Xq0+TNv8MsAXP6t2uwOLwNqTFFpSC
	 b93q4JO88FSbhgGajCQoNTlTc5GzNikQEX4E8U13MGQNOniIiwlNgiHYmZ4xaVekC8
	 PXMEnG8bUYp8VmovluQl1CaebknBe933wtZ0M/W93tFXssHpX/nRz8xuoWt5VU0UOX
	 RCaW/NJFhcGtw==
Date: Wed, 29 Oct 2025 11:31:34 +0100
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
Message-ID: <aQHtBudA4aw4a3gT@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-28-vschneid@redhat.com>
 <aQDoVAs5UZwQo-ds@localhost.localdomain>
 <xhsmh3472qah4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <xhsmh3472qah4.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
X-Stat-Signature: p9hpbqf9mk975tmfs49jb8nb7aykktnt
X-Rspamd-Queue-Id: 04848100010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761733897-88143
X-HE-Meta: U2FsdGVkX1+laRumYajQGYd180Zla+CkEgcJHsdCQMu9Lk8KG+PzS7boG7wy3qFiRLkhKI5dt2QQLIupc+soCgf1VE5HBkXBCYDOmEss1nfKjqL3mxrY00KPOvM0dM2PIfbDQ+XhyAOssd+BxFgrTRaol0rT89RtIig1lMTUvlOiCagZ+d6P9TpBvQHWaXIjgJqmo8w+Drg4eyOeubEiiie8GQN1sP2Yu6KckHefapn5nF4YX9FBN6NApnN9UVY3zFDQcWMnR+cFZquZkFTT9Mpez+69LGbRSfJRv6pm/TAsyK7FLCVxhUP6NkL4hPY4VxtRC/F6p2+Nt8PhsPI5BVXlajwJ8ewHSFaNzSA1Yc1MlIwWh7ZteYc72g+ifQyI92VWlmjN8E0mphyzl5zp8GOdPgiSTzwlSyhw3+328Y/+lrguAWAZ6SB+yT15TsXuaQNpejVaUVpgUxDXJZpKlcuL7KYY9suibSmwFhAJ/fD/huT6ans1HNcsd9TcePCCIUSPNh7SzEPNUksFjOydkWlPA9SvJ39a2pHc93zcXDqATyBMHW0VnYEZv1weGInFu+UdyextZYpE5koTrjrrpeY2Di7ry4N0rM+ajfzmN48paS8swTttzkzXg0BaxzwM3kfcSZ4blANhtIei0xjwJ8Zf7g5J66CDlXLWXQcfURI+cz3r6RNm0PFlUVt86iSezc95UccXvKKYmb63aSolpJGrluCBpmNFJDC7kdlgOJp0FFr6PL0dm32RK/7k2TXqtWbKMP5W9uq+dWNqcSlGUkuVdkPk+X+zb31aITxZ2T+2LdXZ+A+l6rvbwJfb6ezlWeXxTaPGDyegTikBnBIo8O0boUXRH9YbOCbJusObOK3iThvZDzXSS41nQXK9K9kJLgyjAW2jrl/UWUyswFQt9ixYIrHW/MFzWWwN2ykL/uc4b+h7ly6b9S4nn1ctulGrOL6Rb7fXnS2V/hfBnEp
 uqf847Zr
 PMw6M4iWe2UnfhcA0AKyLdDNwTQUWTRzavMSzQ5xAGUoNh/u8805o8HBifD7Lnjlvmogbe6bTHqwlaFaVJ/tUueAYSXArf2tEP0PPq3cazPAko7UzwpIJ5I1ckVqwX1JoKkMYyDXzTusB+KoW9Km2xxN6QyYBTWwSgaZx5qFZFLGnKjaVbHYHtB7rTeUyLTW8rlJJb08WIxUw8clEPA/adNufjDJYgCM94BJsazF1cHUn7jQKfgwtXhfcqhJqsrSJx73Hr2TIMEkV//KtGa7dq6pL2Te0bCnIYRaNl5rUIG8nHK2ooXD0oM7WCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Oct 29, 2025 at 11:16:23AM +0100, Valentin Schneider a écrit :
> On 28/10/25 16:59, Frederic Weisbecker wrote:
> > Le Fri, Oct 10, 2025 at 05:38:37PM +0200, Valentin Schneider a écrit :
> >> @@ -171,8 +172,27 @@ For 32-bit we have the following conventions - kernel is built with
> >>      andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
> >>  .endm
> >>
> >> -.macro COALESCE_TLBI
> >> +.macro COALESCE_TLBI scratch_reg:req
> >>  #ifdef CONFIG_COALESCE_TLBI
> >> +	/* No point in doing this for housekeeping CPUs */
> >> +	movslq  PER_CPU_VAR(cpu_number), \scratch_reg
> >> +	bt	\scratch_reg, tick_nohz_full_mask(%rip)
> >> +	jnc	.Lend_tlbi_\@
> >
> > I assume it's not possible to have a static call/branch to
> > take care of all this ?
> >
> 
> I think technically yes, but that would have to be a per-cpu patchable
> location, which would mean something like each CPU having its own copy of
> that text page... Unless there's some existing way to statically optimize
> 
>   if (cpumask_test_cpu(smp_processor_id(), mask))
> 
> where @mask is a boot-time constant (i.e. the nohz_full mask).

Or just check housekeeping_overriden static key before everything. This one is
enabled only if either nohz_full, isolcpus or cpuset isolated partition (well,
it's on the way for the last one) are running, but those are all niche, which
means you spare 99.999% kernel usecases.

Thanks.

> 
> > Thanks.
> >
> > --
> > Frederic Weisbecker
> > SUSE Labs
> 
> 

-- 
Frederic Weisbecker
SUSE Labs

