Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 976F7D1951A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 21:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791896B0088; Mon, 26 Jan 2026 16:36:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F4A6B0089; Mon, 26 Jan 2026 16:36:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6955C6B008A; Mon, 26 Jan 2026 16:36:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58E466B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:36:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 095B8D3A98
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:36:19 +0000 (UTC)
X-FDA: 84375423720.18.F011B0B
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3BC7A1A0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:36:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=J6iAAvmt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769463378; a=rsa-sha256;
	cv=none;
	b=HkS67vym2A+IyK3aVgb2orN2hpEYwy+GT5X6+PsEjfkP45VyFWbJw7Mu9U8gEccoCB9xc3
	xJ8p2cg879369a4/QUcSghcAem4wKMUtTYYI88lLxFJ3no34FAeNC/Bbe0hgy3ikbUMgpe
	sK2CfrEpJvdAH4FyoXZiQyS5wUYwaiA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=J6iAAvmt;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769463378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IDX9AjD0dwjrQefXov9k2MtCld60dtQxGUUAV2j1WjI=;
	b=VP+6CrmLcIEOngMs8V9yl7m8VnvIwFOrtQpwEuCxX0QFbiIcK1YpumgZzWn0wBCQlma0qZ
	An+a65xrNEqtYXjNOsd33+t79G5mtUU6G8q3pJc8C62U2JuaFmhNKXJwNov6W7U7pw5S+O
	QIc16SLoBuNBM+8aOep36Fd/XZQaYvI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IDX9AjD0dwjrQefXov9k2MtCld60dtQxGUUAV2j1WjI=; b=J6iAAvmtrgFJs9ze2z/3mvNozn
	PZeYeQkBMpOoy6bARHpR02WAfbtaa7iTf6HiFwZskZHm4oN6foztXD1WXqeuhwHMSXWyJAFJbhTD5
	qQ1+R5XWwGM3j+QSkNI1Q+zMTANXKoioCJJ8PtGwpUGGIcze5nZNWEXu1YR5X4maU7pfNt0Anyji+
	GXAcVEho74qSXcSeKj2Ko+V9+LTubj1o43do861nH82B/ld1Fn3lt07jwKJr3drbI6UK0q+LPwinM
	WYBkEgblZCF12DZiFoTwjzgiGipNv2h33OJAsRML39oXnwDKn1Bq0tULsElknva+RF0gidO6QOh3u
	4kZob4og==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkUFZ-00000005tyU-07kL;
	Mon, 26 Jan 2026 21:35:57 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 41718300756; Mon, 26 Jan 2026 22:35:56 +0100 (CET)
Date: Mon, 26 Jan 2026 22:35:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Marco Elver <elver@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [PATCH v5 15/36] srcu: Support Clang's context analysis
Message-ID: <20260126213556.GQ171111@noisy.programming.kicks-ass.net>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-16-elver@google.com>
 <dd65bb7b-0dac-437a-a370-38efeb4737ba@acm.org>
 <aXez9fSxdfu5-Boo@elver.google.com>
 <8c1bbab4-4615-4518-b773-a006d1402b8b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c1bbab4-4615-4518-b773-a006d1402b8b@acm.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3BC7A1A0002
X-Stat-Signature: miyb8hjjy861z46ypiaorkimy8azz9su
X-HE-Tag: 1769463377-485615
X-HE-Meta: U2FsdGVkX18f8g/1doI2ZtHLbx0RbA5vc6/FfIjzr40v6/a/3EeNQQHuM7/+Jhd0vrBxya0h21PoSB3jedqJqVL/HyT+SR1Q24LHQ1++mKHI9jIQrMtEELZp4e/ZT7uqmqUlEbsoYtDydidpKLQdGd8ltlYetFxmKXE6cyWxcTCUV/Pc99eNnIiP72F3oUNXXksMDyauhIC19FpwARlJO5KTd74jsJKdVNPhzOIP7gifgQQIRTelWp03J6FqlYJtTNMcGf0chMDpx8i8z+BbSWBmNOax84TpeNwQ705GmRnUFqRpt9oRacQDBU8Wqk/ik5b2mMu3Ejwntjevd3HNCM7g0KNp+MjJnAFDVcsvnvrghcacF9PMsbhWKiLGCkV4LWsnlaV7OAWuj5sey6iD5GqD6U8YU8CQWJY4Nn6g3K/6uWWPeo+WUruNKbldqsiJWARSHKTHVu0yEEkwxFrxEGoH5+p/t1pXwTH1ZtDCycB+qg4t80NsYOSMVs0EU/+vYj5Mo8eoDjHbTTyo2M+eiOuOx9/6tmPC9XSHbvD/Y87d/ZLVrXWr1LE8bMiilXv3tBGe+73wP17eh6j2VoSdhAF+0h0o2R0B9E+TXWIg6df/RH6CvRXNHB/pmTiUD6q0ploIjG1U8kSuj+0D4sOahzGL8qyweqxNe0wueKKnbaYDsaXbxhqWVXJlmQMSHXC6v3wpSfUQCp0XBMBZUAjTG6FnLftf8VY6pPyJMfXOiGZqPNkDIACYPB1tWZliYs43AXhKYz1pYxEg8JL4f9aTZWEOWENT1FJDBjpKZDSTaYbm7RL7sYdj0cMs0TuAanJV5JXirCqeYmjFwp7sQw+zb2fKehV3q4parCJUfeufuqsaDhF1REkYDn1TZSCczY+DESN7iEz6G48TbZGFL/61/5eNxmw1X+BOlejmso0FyEKwOfDe0SU7bVB7tTThTo5IOmdmN6YKsQMDJuTGhzt
 v3Saa2JW
 8yRcmJVdjk0rCWH3/j5mNyv7g5Rck1PEHSGcQNtrWRnzXyNCfpyNjlNfCaTULkjU3HNiNn1Ust5IeIw9wMcNYsEpG8jDz1/G7kGivG+flNqoL7BdebcXSqh8Mz5tqyZkANus5bOK1w5ywXxEchGDEIK/lh6wk2MLQSXgD/Mht092fQY0Kb0ULFKzQCh2Xj/U2OY1FtrZOyVQEQOh04MKBwoKe+3sK6ChweeaoGsrLpavchr4HHPBP7rVnZj+4jV1AiyO9IA1CVCCwdvPRvgdoimD9BN1OYtL1U9rAkiErgh/G/kpLsWej/vSfog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 10:54:56AM -0800, Bart Van Assche wrote:

> Has it ever been considered to add support in the clang compiler for a
> variant of __must_hold() that expresses that one of two capabilities
> must be held by the caller? I think that would remove the need to
> annotate SRCU update-side code with __acquire_shared(ssp) and
> __release_shared(ssp).

Right, I think I've asked for logical operators like that. Although I
think it was in the __guarded_by() clause rather than the __must_hold().
Both || and && would be nice to have ;-)

Specifically, I think I asked for something like:

        cpumask_t       cpus_allowed __guarded_by(pi_lock && rq->__lock)
                                     __guarded_shared_by(pi_lock || rq->__lock);


I think Marco's suggestion was to use 'fake' locks to mimic those
semantics.

