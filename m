Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A866CCD4F49
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 04:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBF78E0007; Thu, 13 Nov 2025 23:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BBA8E0002; Thu, 13 Nov 2025 23:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E468E0007; Thu, 13 Nov 2025 23:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6EF48E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:38:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67EA257D13
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:38:28 +0000 (UTC)
X-FDA: 84107956296.30.01B1647
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9217010000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:38:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D3U+OeK9;
	spf=pass (imf14.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763095106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/KGUOKaMgQGk1AtOrPMAFhEklPPuCbyLaBZCVybPbFQ=;
	b=Zvd9e+onoDA7oriuxVRCX/b4luEBI6kRH6J53gJFai9w9CYsgVWRjBiUBq5cPg/uFQuJUQ
	a37Fx7c98U+5k65btjvv6wUL9Xnck+VuyULJoZszwQHrPkbZTjt4smyNKHWSwzbgO0dW1L
	nJkftTAzqbY8JSfAcnD6sbw2IBjywcs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D3U+OeK9;
	spf=pass (imf14.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763095106; a=rsa-sha256;
	cv=none;
	b=mbACeYvXT3pJZNhBIi4klmAk9KgLDUoSvizPLkrAktqiNEYEw3SEszTaVMYD2CJj7UyrfE
	KSwVf82fNj5WZeaKnIPDET4ePzJnu35YCuaxZpW7AeXsQxD4wz1KvZMIEsWEkZyGUNcK5j
	/b42NKpWfiG++0w/nUJNqGc7PMgSkZ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 267B741B14;
	Fri, 14 Nov 2025 04:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D54CC4AF09;
	Fri, 14 Nov 2025 04:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763095105;
	bh=nHpuwrB2PqWoFYl7cIf1QtHauh5mGZ3uTev/Ldhcw+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D3U+OeK9GhqfWF0+J2jd+muy8AARO4qDhP50T8K6+Ixjl7OYP08hLGOSjvEgNxOBJ
	 S2GLkZXFLi/O9NjK1ipo/SNFyF/x2q+MTldVC8dPMtD+AzPiMHugVxJM95DcCbrvhf
	 w+P4TONQUjEMO29loLzdZvpX463OkL/mVZC1yaEqf8ktr2zjE4sZ+5mY+avsykTA+K
	 YA5I/rS3IC+TdNYYZ7Ei3wdD0P6JsEmLKcGpkSPlRUNbHgBaj0L7XpDuh3mccUNosD
	 JdIkdst85rXaaJZP3s8sX9A0Gu6//cXcUYjCevnXiDhCSLjMa0X/U4YWXnNUEkL3Gn
	 Gdnc8kbREu9lw==
Date: Thu, 13 Nov 2025 21:38:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	rcu@vger.kernel.org
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
Message-ID: <20251114043812.GC2566209@ax162>
References: <20250918140451.1289454-1-elver@google.com>
 <CAHk-=wgd-Wcp0GpYaQnU7S9ci+FvFmaNw1gm75mzf0ZWdNLxvw@mail.gmail.com>
 <aMx4-B_WAtX2aiKx@elver.google.com>
 <CAHk-=wgQO7c0zc8_VwaVSzG3fEVFFcjWzVBKM4jYjv8UiD2dkg@mail.gmail.com>
 <aM0eAk12fWsr9ZnV@elver.google.com>
 <CANpmjNNoKiFEW2VfGM7rdak7O8__U3S+Esub9yM=9Tq=02d_ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNNoKiFEW2VfGM7rdak7O8__U3S+Esub9yM=9Tq=02d_ag@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9217010000C
X-Stat-Signature: ijm7t7mso31g79pdqdutjhgqg6s5y6gy
X-Rspam-User: 
X-HE-Tag: 1763095106-681380
X-HE-Meta: U2FsdGVkX1/CWLFaaJxLM+f4yt537Sf9kWRhjhaKTHgUBmxA4jObOkWqVapov4xHm7JDY7etQsB+4k63GZkb+StuYlDjmMqrasHl+mtezbu13WLjCQZex60NpYcwdC6wfFRntqr4wy9BJW2A4ESTJicM3i+p9i8BqBDgiT7OgfP1gL6Q9ak1S4Cc6J7WlyRP8LZmM7FPI576rNPbxMeVC5s2DWgvfZxSs4YfRE0wCag6mlbuIf0T5Ibj4/kafoGJnf2AtCGVSYP3HmThaSk4/S5GA9vwSzay0X/aFEAm1IKAJaTlfnJdWcNZs8WEJFMq/mutNxjR9FsP61m2uKh7s5qc2w+i93ohpSD6v8POGuff65goSWSGp+C2iYSy1nR09o577ScZ4NA94g6mY19St6h6i9KTzJ7lvOe0NnsUf4FxU36eo0sK405PfTGQ1tXJa92ywWcSoPM9gu84kPgXc8e+r9mKmsJ6mrWitmtP8loS2IA50WEE+t1O/pHV32S5KmE7yoW+rBErPiJmYkrH+xkpqZAgzC8uy8DhW8zhRc3CpN3R6xduO88nzuBM18kFbk49YeRd9y3lN7KVRZcZ43cW5L0fyi3sivl1RVg7DMy7BcFNm1A7X/VjDiOKZg+tW611kySxZVVhY/uGvG8ZLqeXuzAcliO4H+swEQZS8zwv9byk6resHfdtbVD4hmN3XqQO3CT9IRsyd/7zlDCbQ63xOqzMTjbnZcOlEgTQS8u6www2HbL2jxEGenhr8Yk/CVmQLwLcvNzPfhjVu+ILaCU+zecdbLj/878wYGnbWpgkSbt/7O0SVGP7ZjCfqtuMwFc4LUy0Okva4xnVbJbLNl9zSYn3M6TLv+MwIi/pci8I4ZIvnrTxkqx8QlTNThNN9Q/sTmnXYUY0fLJXeMc4AvNSvj57QACGEMhbAxNT2J+24Gzjj56K/1+X1N0zzM2+Zj96X9oPl2UftV4hgLR
 nFJpgYAW
 Rq2GUOMHfg5AzfE7vxpZZ/LV1+/ctCpDN3V0QVzpZYktPKOmCcnd9wX0kvmYNhPtNFisoMdNM+9/txfhILnJztP6OLrs3hTUoXkqn5Eu2hEUxkbWsSWBrv4X8KjT0B7SSpBYiWH3cjzradnk8xomTAXWSGwBOZYX8madceqKFrQpMdJSNVtt65qdS/PqBWuyTdFZg7Q5j7bYvizj/kwYGEjKAh2DD+bsw/OJ95L4u87Nas+M2+cNX9P9vNEiNj1xPbuuHrOgipomd2OzsbAnkZyNLewMXhDxthm+E+67e8DhKLrzbSc4G0uec5z0lfYhHAdUQFiU2tqMJe+s/Ps1ZhdF2GDNpm49uCFlufQE83Qo4kNCoIQk2SOuLrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 03:30:08PM +0100, Marco Elver wrote:
> On Fri, 19 Sept 2025 at 11:10, Marco Elver <elver@google.com> wrote:
> [..]
> > I went with "context guard" to refer to the objects themselves, as that
> > doesn't look too odd. It does match the concept of "guard" in
> > <linux/cleanup.h>.
> >
> > See second attempt below.
> [..]
> 
> I finally got around baking this into a renamed series, that now calls
> it "Context Analysis" - here's a preview:
> https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=ctx-analysis/dev
> 
> As for when we should give this v4 another try: I'm 50/50 on sending
> this now vs. waiting for final Clang 22 to be released (~March 2026).
> 
> Preferences?

For the record, I can continue to upload clang snapshots for testing and
validating this plus the sooner this hits a tree that goes into -next,
the sooner the ClangBuiltLinux infrastructure can start testing it. I
assume there will not need to be many compiler side fixes but if
__counted_by has shown us anything, it is that getting this stuff
deployed and into the hands of people who want to use it is the only
real way to find corner cases to address. No strong objection from me if
you want to wait for clang-22 to actually be released though for more
access.

Cheers,
Nathan

