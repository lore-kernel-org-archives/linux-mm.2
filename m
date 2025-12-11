Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65071D41C09
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 09:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B766B0005; Thu, 11 Dec 2025 04:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C6F6B0007; Thu, 11 Dec 2025 04:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721E66B0008; Thu, 11 Dec 2025 04:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 616DC6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:55:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5DFB135171
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:55:46 +0000 (UTC)
X-FDA: 84206733492.01.354ADF0
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 16A7CC0002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 09:55:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=E3bZKCI1;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765446945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WhymY9DTx4lwYH2yf2+tZtBM6CKMmmYYDOh50+lOZo=;
	b=RSSg5J8V0jAT4KZaeqJv/+76Pbw/m6wf0Cp287gLt9eA7eiee62vFTeMApw0310TGHMGXu
	f8w8WHRlly8uWUC3xRaokWyqcwJymir+zGPOtVpGvkGpmdgQeQJA8Ug7bzrRb/zIuNPXg9
	9Qw+Zjs0c/LEI+3ualTOG5eax+CjFyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765446945; a=rsa-sha256;
	cv=none;
	b=d58nIJ/YmjQ/kzKuR3wgkxQbEjWdNLJ3mU6TKKMzk15E4gf/1Hj40barMPNqjl6XB9QzOu
	ujck4R3KmvEfVYlgqL2vDStR5/05WtoOCo4li6PmnNkIDBgNvWpW0ozOfcn+cj73Vr8mNi
	6MNhRNACxNEd2QtpSLwMIc4eGJQxbc0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=E3bZKCI1;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6WhymY9DTx4lwYH2yf2+tZtBM6CKMmmYYDOh50+lOZo=; b=E3bZKCI1ZZXvnG0+gAKKjTRe88
	LDQhz432e77NUYPNQQnmOHIWVO75MWPvr+x9ii68maqX/F62HbYRmLDcK9GnRB3g2hCqIlCL1j90u
	m956FTwbPf8++wE5dZatnhW5YgU7HRVcZYJvhtfJkX7EGXEyA/vhdvAxzQDui+P7LA/NobcKpZEWn
	mCV2u3O0fxZKBdjE8/9IO7ypAIf+PQI4Y+d+TeggMyq3EiRF7Ltrowsn0AY9bpVjEHVBe3MnLCr82
	uMOArrHQRtzlLPKJrj4S4qkLHV2+GWAHKrDfPnPMJXuULb9wLKbzCe1Ukoo7LCvMNsrowOCD1pN5C
	/h/oVIJA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTcWn-0000000Eibk-2SDe;
	Thu, 11 Dec 2025 09:00:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DB9BD300566; Thu, 11 Dec 2025 10:55:16 +0100 (CET)
Date: Thu, 11 Dec 2025 10:55:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
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
	linux-sparse@vger.kernel.org, linux-wireless@vger.kernel.org,
	llvm@lists.linux.dev, rcu@vger.kernel.org
Subject: Re: [PATCH v4 06/35] cleanup: Basic compatibility with context
 analysis
Message-ID: <20251211095516.GO3707837@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16A7CC0002
X-Stat-Signature: 6qags6rx9e1q6n9s7s6y7tkqbgd6eqsn
X-Rspam-User: 
X-HE-Tag: 1765446942-630794
X-HE-Meta: U2FsdGVkX1/1kdPp+afmqYgO+rg6Jnz3lEDRi8H0wrqUw9JeJUnpK4/H1XGBogA2rmR/6P3N+e+vABH755ArQ8kLOHE/jqUj9HMacj/Kzn0OeGFAeSrfrEsgAUj/mBbQzc40RH/pRqxoXfax81LFMZPC+aPk6+Gb1Xm1y/Epmm815wLbdKmHMfNPv+GufNf04EJJhVP4NvvENGhjZxiKpkBwIs/p95+iGFe3pVClaJ14w45LXUgDieeIva4fZ05p+DLm8U+DfK9apdJcXzcZHoxKZz4S+DRqAgg/4vuxoL0/0dVf5ui9UydcFU6ccOjjpgPszKjpa37zLiGo8C749PvRvBX/CAhogNVJuebo+HidAHZcFUYdmhL4RBpAn3SYnOtPrmZsr2W13JBSPieG1+EPghp78FwpBWR9xLixf+9w1A+1dsOlw+aBevpoXne5wQ1WTx+MtrDpPQz0OlSplL2DpuneI3qpRwAZ8JMsgHPwnxKH7jJq7maoprtcSATOf4hWiEkFkk0nQuTTbWsKHUD7fdViN+xwU0n0ctYIUA/EM18LX4XLJ9LhjTtVRSdPcgbE8GZRF6448vMNEYOikiWXaK0KPENWxxqzSN83Vrc3rFtC/zL0XX4s5XvNZNIQ12km7M7fjxldxmRiF0U82b1b2pw8al2+GqKTsvDlNIQ+HZNP4IFZc8Qjlz3DZhyEjGnPZDwl0RcGukX3H5GiwBQKBuLzc+2yo6sRsnCcqF5sD/AtTyaG/X0bWfi3MAURDwpiCqYDYY3jNp7Bk7d0jU2YMiY441UB/BFDn3Po2htm65lBdubfXXjWt4mS06N5sK/jBNWYRR8vKzVJPwggMEIogQqBSt0pRWS0TF6FPO3CawyhLo7fmwppIHeXRVqcJQhaUtT+awnAbiUb3L7FgEEUEjQkrZC07k0QaA29zt/h+Zvuqzdr0mt7zdqf6Gcy+rxWPLR1h9s/3zggNAx
 qyJkYsf5
 1O4kW4phBXpfMTtCZkmJkE5+IqHUcOkdw/1hyMHtDq5oprE8DWptWhUr1iPUFk+ZpRVLC54OZlbLtQ9o/awCdiI7gx0ZZv0l7DCLyiC3aUrpR3pXDum45MHZHndZ4daN1gBpKkdgHCIbyKIOqedfMytAiPeinLk0aIX0gzU6OeRJ56cb+5huFDwn3cO6uiSOxbWdBr0WL1TGCx9c79M8b62WsZ1iNnMmuZLevUG5ethuoKon6w3/YVx9bFSkSQVR88AVW5tgNxCF9m70Hz/v1IaY5opxqJztS+a3uzvV4mCVoVWtkKNP5nIdEDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 04:09:31PM +0100, Marco Elver wrote:
> Introduce basic compatibility with cleanup.h infrastructure: introduce
> DECLARE_LOCK_GUARD_*_ATTRS() helpers to add attributes to constructors
> and destructors respectively.
> 
> Note: Due to the scoped cleanup helpers used for lock guards wrapping
> acquire and release around their own constructors/destructors that store
> pointers to the passed locks in a separate struct, we currently cannot
> accurately annotate *destructors* which lock was released. While it's
> possible to annotate the constructor to say which lock was acquired,
> that alone would result in false positives claiming the lock was not
> released on function return.
> 
> Instead, to avoid false positives, we can claim that the constructor
> "assumes" that the taken lock is held via __assumes_ctx_guard().
> 
> This will ensure we can still benefit from the analysis where scoped
> guards are used to protect access to guarded variables, while avoiding
> false positives. The only downside are false negatives where we might
> accidentally lock the same lock again:
> 
> 	raw_spin_lock(&my_lock);
> 	...
> 	guard(raw_spinlock)(&my_lock);  // no warning
> 
> Arguably, lockdep will immediately catch issues like this.
> 
> While Clang's analysis supports scoped guards in C++ [1], there's no way
> to apply this to C right now. Better support for Linux's scoped guard
> design could be added in future if deemed critical.

Moo, so the alias analysis didn't help here?

