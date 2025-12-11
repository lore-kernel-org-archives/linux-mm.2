Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 098A0D41C27
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 11:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A776B0005; Thu, 11 Dec 2025 06:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2966B0007; Thu, 11 Dec 2025 06:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220026B0008; Thu, 11 Dec 2025 06:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 143F76B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 06:44:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8574B1A088B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:44:41 +0000 (UTC)
X-FDA: 84207007962.14.FAFAF87
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id D8CCF40004
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 11:44:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uIJmfimn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765453479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Xyvz2EmetVTqNxA3ooND6KrVryVhRTmeDWJ7L8+Veo=;
	b=bcn9RXpeLri1C2gKfoKL9Q1tUPScUrnWlIxg/88ctBEjvmZwTsVwW6DKvsMHMBwCZwgHMa
	Ctn0YJ30WIYy7wtuqcunLiclrb71ZYaB1NdPS9GuLibSnF/xC5toiYPKxx70p2HEcfHriw
	Ay0QgCnm+mHQhp8PHbupCHxRwWh7Vi0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uIJmfimn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf07.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765453479; a=rsa-sha256;
	cv=none;
	b=sRmhRc6n8yXj1YIR1GdAFdAYar9P6YLmyr79X//HDgJS34kM+ieCNqRdOPzepHWJQjxG+X
	OfZumQdjdXEFfIiRfUdWl5V9UWo6DsXPNPBY+vhs4fgBnxK/J0Ccb92E/Uun3OpEYZc0LB
	0FEYZwKESn7LFgdVwDF3pxWSkPAs47I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1Xyvz2EmetVTqNxA3ooND6KrVryVhRTmeDWJ7L8+Veo=; b=uIJmfimnlNHvC/G7x6PPflA13K
	lshdJGbQZ4Hj6U3gBt+qTwrd7U8BHV3bTjJFXW5qDlWjqGZEsKv1RsQk1E0GucLcbJGz3KswikKF3
	FC9DO6iNWOf6K4jpEp8JjNWgtpdSRXEXFrNc2CLESx/naRoQs54Gzizq9ktTzAzRlq9Z5+clz0NEx
	k3OH+xn15/MmfudhJetIFZG31/V4Z7jkj3+XQEqjINgec//KCLdIEKn1mk9FdcfkcSlQqdLKwxrM7
	pm8yeej2PowuoHC6yP98kzuZOludbZHHtNOyU0VV+rXNKI4WmbwiV4TtB8qVZsgsvBZvLZxCpvSrr
	AuH3zvWQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTf60-0000000EBKA-0bcG;
	Thu, 11 Dec 2025 11:44:32 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AF7D630301A; Thu, 11 Dec 2025 12:44:31 +0100 (CET)
Date: Thu, 11 Dec 2025 12:44:31 +0100
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
Subject: Re: [PATCH v4 02/35] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
Message-ID: <20251211114431.GD3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120145835.3833031-4-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120145835.3833031-4-elver@google.com>
X-Rspam-User: 
X-Stat-Signature: tk6neiqr5bq1m1p5xi9cwojw3wod35ny
X-Rspamd-Queue-Id: D8CCF40004
X-Rspamd-Server: rspam06
X-HE-Tag: 1765453479-459003
X-HE-Meta: U2FsdGVkX1/yi8x6UaQfgXs09gcp527y2cnRPFB0EDtxywTyh5QxT65YP3ncjZ8WGQ9Ye+TRAtzCByhtugwEtKypTnyninX1K+RwpHGTkV9i9HgJEXvEbuzs6zEnAuxbivTf6RCmuPjWVA2deKFWvN5i9aCXLwWv3eMoReb7FECMif72ZoG56LY7cLJq7V38/Ue/YRevO+H2zxehDdsgF2dqfapS+Y5wsp+P+NpoNee2YYWEJpZB7JavVyMvbSp7sQiwGCQbbQpyTvHv905H6XfJvGSwWXK8PDl/LWfIiVkXD+2uGff5+ORo7bmYgMymggxKFMaT0BS6/ItF+XdEIUz+gmXwUeUBS/u/IIAB3NZsePlc/49o/Ds7oTlD9eUfsmMpRoH/1CZy/TCoymfKjelAsRCNli9MR73t1Z4lwD0GrYj2l/1h/tF5vMaBYIqL0kPX6NiBeXqpCdZ62KwWf4X20MTXjNF+EgeCUyH+QtpQvhr1a/1Lqgej1TpTCmR0M/CvRuT/TzsY++CZtvyxqfL2NyquhRW1gMqMkmUZlorR+Q5ruZCshav52xBfSn9ib65Kqj5hoVSNDs52GRnfTuCwMQrVFtZvVyO5gOGKYd1HTLt8f8WwWYGeXYctFkADbabMCIitrMGvl61Hwj4nAHvlUGX6jDPbxrZBzFwGvFIArjwoVs1ogha7g/VNIE0bLNNX+EY3VW5JZI8uKIJlbqLeG8Kkoz5Uo5ZIbtyQLqERm1GF8FUt9XP/f27IKGOYyqaLWJBJgGOqPIFLtS8m23IOU/eft+m3j5IeC4PZQzl//8YsbA+3gMMKObyYyR+BWjX/RkW7q/4YV9rc8DSPhrRVXGCNGCHaK4qYVvpKsTgOXtXysMGBlS9P8wDroaSJF6a7UC+J9/o3MiJ3Iyfi/9MsCNhtKB1zuNbLUgRHOLgVRxNyRuFt0W4eM2+5sbJ3eAWDavqq23MuTaG7MW1
 WcSP6VFv
 hZrdOX1gHlqY4W9hyEumUqwobGoSJNHu8j9mFx/rMIfQ81kggYeOj58JeNFTXz4K36Q/d3Mdw4P7wJD51x+GNSVwNxsUqIukPMit9WhgiDCzcGFWdgJTXAgzLI0Q5XeWH9xre/ha6dXgChpNbydtHm1hYax15Zp04HlD2Tvyo0fpE7QlNVFlZwM3n87YHZPpGMXZdoOMPsjFpS00fGuhLYUriR2JMyNWXxlLpwVngsjtzSAM0pQQjkl1+TR4v0nocQ/OhCJ/YAND7+cUHyNQAQYD7mCvQ1YelIe6ppI3u6LtdlgpjRQNKYQBoFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 03:49:04PM +0100, Marco Elver wrote:
> +/**
> + * __guarded_by - struct member and globals attribute, declares variable
> + *                only accessible within active context
> + *
> + * Declares that the struct member or global variable is only accessible within
> + * the context entered by the given context guard. Read operations on the data
> + * require shared access, while write operations require exclusive access.
> + *
> + * .. code-block:: c
> + *
> + *	struct some_state {
> + *		spinlock_t lock;
> + *		long counter __guarded_by(&lock);
> + *	};
> + */
> +# define __guarded_by(...)		__attribute__((guarded_by(__VA_ARGS__)))

I must express pure hatred for this '.. code-block:: c' thing.

