Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97773D5E156
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 13:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919A56B0005; Tue, 16 Dec 2025 08:41:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899936B0089; Tue, 16 Dec 2025 08:41:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784D96B008A; Tue, 16 Dec 2025 08:41:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FBED6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:41:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E352EC06AC
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:41:46 +0000 (UTC)
X-FDA: 84225447012.27.54CBCF8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 701A9180012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:41:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dMWulvkE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765892505; a=rsa-sha256;
	cv=none;
	b=3aLRxHQ1tDs9JQaLqgidxVr/R8qRXLhke8f+ds1NKwER290/yAvgiTkl+vqTlTizHt42Lw
	zBuQNBcCsIbtMlCFbIbs0XhmZCJigKgR3t7KdvetN4enjG1nautW8aeovlHEgspL793SZg
	ZR3DHl28vBya3wzq46fVVsTcik1hZrs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dMWulvkE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765892505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3682UGOf9mvj955UPR/gJlxWjdDq8XctSWFz2A093u0=;
	b=Km6T6pzMkuHey8xzOUOlc0XnDn8iMB4/yJ+ilEPT3HM0kH8zIaCDQKWGidClOlGc+gYF+6
	bvUvxFzhMlufGgx1nenLLTTY8bjt55Mxmk+n/1BcOdMsIojUi+OHt1C8AF52ZNjGqRCe3a
	oDluCb2LAkG9D4ufyJCWq3RjjtdAdpc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3682UGOf9mvj955UPR/gJlxWjdDq8XctSWFz2A093u0=; b=dMWulvkEtlHRfwLzo+fiUy1Rul
	jjpm7Nh2E3i0jPKr9HMflOZdHLmzPwGROrRfy+9DA6rqyFyOwg/sOMcHP7z1I0KSJNIkPWJ2wBtvb
	Ab5EX9vtW7XFPbI4t8avQsSZnbwYHlc3xLHwv/1NtPJCLFIMM2yoqbJX0EIdSz3yYrDjgMHG9FMBZ
	xuG4HBparMxFnq8+KjCFyLlfRplAa3ifZIAEXjq5tFbyaU1w/zO0idGO9PQS93MnJhQKxuk3vQX6n
	NUXzHndpgSJ6+YIVw3RTr17Z6URMVucWjRkhg5YJiyV6sn66SBQExl7rk/IIt4FKVR/iMv9woMrvX
	bcL7MGng==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVVIn-00000003LNo-2njp;
	Tue, 16 Dec 2025 13:41:21 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0582B30029E; Tue, 16 Dec 2025 14:41:20 +0100 (CET)
Date: Tue, 16 Dec 2025 14:41:19 +0100
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
Message-ID: <20251216134119.GU3707837@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <20251216123211.GT3707837@noisy.programming.kicks-ass.net>
 <aUFdRzx1dxRx1Uqa@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUFdRzx1dxRx1Uqa@elver.google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 701A9180012
X-Stat-Signature: ko6bgykd8mrdr41pa5mpuu4sfy6mgi91
X-Rspam-User: 
X-HE-Tag: 1765892504-523148
X-HE-Meta: U2FsdGVkX19iBqvDKwaRaQFlHFo7fdd9sotaQcTnJBvN/UH2vip567y28KZgjxCz+Ye/2glZqksBfTkiDeKeIkiCNWyI4gs7euAk/b1+732DWCZyRfKu+RJ8Af7dtmAM6eEA0EEbyVaatYrtP+U5lEfn0ew7A8M3nDrD7c+xklujiBrkpgxalTO9MhpOtjv0Cz/hivwNQ2A/d5+IOZUzazRqpqxdGDioskBc5J9vr3W3A1Tp9iUb/2pz+199tdf0Ws3i6BOQHzECkBdfIzR+ylb72XAEUEx1UYij3siE8ReEjBofDVERmXH3tZLa59UiQgDtcOJfgl/UY8e9SJL7qUAkIiMJIC6DmWfkWoOzFkHHpw3OD+G5Esk124o5vb137eZBtgvSUqWLTCaEkRaOCrlGgvz+I7Qq/BVZwQzeh9n1uTNSMWCSjsRBBZ7dFuhnPqza620n1N8VJKGNIS0wntLhKeV/O0SHyEJWMV2866dQERQ0/yORJmtvfN2qgINcsE0JbHge7ut0PZv0vd9SYff97dG8DHS2a9PsEtzSjm3oGMCKzX02sEqXYJsOly7LzQxX0sX9j4mBGaGZOMc4pUowEu8UXzuhn41axAkv+Ny9l0eTrCG+dd8qWJMY/btyKskU4gco8KW/UPL+sn2ZaxzGktjGrIcYWDt8hmirGiih9EFURHeSJ9F00BtNDNjxVfXvWcbfW8EHpSv5EP2wGs26c6bKr6DTPw97B1jIZ7L7KCwmxLQWWF52Rb36dGomfvSIEJwl6LHljnadWhN78JaFbK/lc7miDJMqGM6hA5J0iJ+xLc9aA0bBK2EzyxLZwT3TPfMpIyKnbjbKa5dXJMS7EsDMIUS4XOUuLT7uyKOVZ4VnAcQAY57GWM1N0qk0wgKxqqEG68Zwnle/gdGYrkxs+MTjZHrZp4ugUNhkPMbpT4bcfLrUY4wpEDHCehLMJ8kl3/7X1jk8OvK/T8C
 LVWvm8G3
 xZsQS3u2kBHgnfgvk3Z3ZwCQtassN39e5FdB5eFw+sa2NZXNrLkfdDXoFytvTPcIvDspUTfMLuaTV17KMSoaKobyBRW1PTuF+2naxFXGgu3+2ZsSWK7cvb7oCgyt4VPh5EQ4I2dYZdbukedCAkrSkV4vxwhD5M6hhnxT301fiC3tBzLEyWWGAOPP+nGRd12HT4UrMzmzdcSSn4NGCzi+Z6zCUR/4eCWOsDJvQxlrPG6zozeNk2RfGMLP+12GVzvnRdjGZwMyPaGOXpu3znmYo0dFLRnSq9agNzLKfb4K1UmB3KZRqiLfA/LFgow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 02:23:19PM +0100, Marco Elver wrote:

> > Also, why do we need this second variable with cleanup; can't the
> > existing __scoped_seqlock_cleanup() get the __releases_shared()
> > attribute?
> 
> The existing __scoped_seqlock_cleanup() receives &_s (struct ss_tmp *),
> and we can't refer to the _seqlock from __scoped_seqlock_cleanup(). Even
> if I create a member seqlock_t* ss_tmp::seqlock and initialize it with
> _seqlock, the compiler can't track that the member would be an alias of
> _seqlock. The function __scoped_seqlock_next() does receive _seqlock to
> effectively release it executes for every loop, so there'd be a "lock
> imbalance" in the compiler's eyes.
> 
> So having the direct alias (even if we cast it to make it work in the
> single-statement multi-definition, the compiler doesn't care) is
> required for it to work.

Right -- it just clicked while I was walking outside. Without actual
inlining it cannot see through the constructor and track the variable :/

OK, let me stare at this more.

