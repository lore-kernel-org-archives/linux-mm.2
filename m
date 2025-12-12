Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA8BD4415D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F1F6B0005; Fri, 12 Dec 2025 04:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8CA6B0006; Fri, 12 Dec 2025 04:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90456B0007; Fri, 12 Dec 2025 04:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B30EF6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:32:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50096B9A16
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:32:13 +0000 (UTC)
X-FDA: 84210302946.25.BD9662A
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9CB92140003
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:32:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DMpgfaqC;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765531931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7N1yRupjJwsCEjdeUujuXdzSn7k5Mwr4a3y236fW66U=;
	b=b3M33v2hZtUGWmCK/if+eXhr3Xq2FyMAodsLySTHxoKn8pAZEM0vwHf7b768MCjxQ9bNt1
	7n9UnCwTQnr6gX0btwEwmDAGvTDT/0sZ2yFq9/wYKH1qPh7IbvjfHVbxMlqpjk9+TX9EHL
	HIXP4tCRunQffmOlD9BCG5Dl/Hd1wmw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765531931; a=rsa-sha256;
	cv=none;
	b=GRKpV1SyImoq6T788dhwhJEd7jQAU8Xje6mRErZ7hXKlczf+ft8MtHKzFFF7mvt27zpXQJ
	YXzOsfIbubhNeLXuDWmG/Cm83yKMhlnvhW/xK3+R0Abp6yS7w21DVWfyrOkGCpMBjYppea
	rjeC38RYifXersu2ArPJkwisoZ6Yh74=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DMpgfaqC;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7N1yRupjJwsCEjdeUujuXdzSn7k5Mwr4a3y236fW66U=; b=DMpgfaqCYynagwlYCabdmyw/Bp
	rUrSWkBegZ7jFRY2i5aeyB3mBsMgEJmvOI0UYVuZszBnKfB9R5n85wNsrF+pa+wV09POIzKpx0Plm
	5ztxDsDOKPs08ziIzR4xEbQLew7usFxnN7+f3OYd+0FRhq3UKr+eIQumIXme//DjvI6A17dnCDjOv
	UErEQ9Ybt3bC0AD21CkKRgFinT24xXYc+0CoUTjQkZa/8/sybPij8mY6g7IEQZKZbws0SII2upGj5
	Pm0cIgInYYSL26iTrbPz5JyXnVLmPXf+7T6z44avAqu0UsbtenM0BV7SHv+qf468Pez8BP7yUSJsv
	h8N4R/2w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTyde-0000000GP06-2F8E;
	Fri, 12 Dec 2025 08:36:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 8C24F30041D; Fri, 12 Dec 2025 10:31:49 +0100 (CET)
Date: Fri, 12 Dec 2025 10:31:49 +0100
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
Message-ID: <20251212093149.GJ3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120145835.3833031-4-elver@google.com>
 <20251211120441.GG3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOyDW7-G5Op5nw722ecPEv=Ys5TPbJnVBB1_WGiM2LeWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNOyDW7-G5Op5nw722ecPEv=Ys5TPbJnVBB1_WGiM2LeWQ@mail.gmail.com>
X-Stat-Signature: 66hzan9smt1ey87h74kegrtatum5e8xe
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9CB92140003
X-Rspam-User: 
X-HE-Tag: 1765531930-477294
X-HE-Meta: U2FsdGVkX19exq7mGreZXzNlHt7/Z+iBioJHrbNIFRCRjfSUSnaZK5ESyhcgHj2/MGA03VkuxQUK3k8dUho9vdFjr1DJhPcfrHAfr8w0ZUdj1sNNrSwJfSwFQFjEFGNDQGz3FVr/Kz8EkQCr238YQm2byAYReGZ5GFBDwtLa+XqIAxq2XVDqYv/fQozouh1hNIlRW2/L4sr5MPOYtPOPP2rCYixsy6XxLWXbO6XjTH7aEoevJ7EcsblXS4sEaF6n67erlL4ARutwsBhZVSS1MguB0VHcfycQ/JWcHMz1PPsesotDn9QjZfl1zoAx2XQ2UQqpFTsTcR/QTdrFdD9/MwX6KXuDKwswqVi+Mm+Sud9AOoldIwsDbHY534ZBuOvWpS0l3vHEtYibfb/BJ6ZFezRWCT+sAIXMAfiaj6D0UoKg1/j9IHCEwoXq5AxRUhYZbK5VBvTRVDV4gLQin471qPKlSoNKAaWKLZMtBzEe6EhAvG1PYBZQenESPsOLAogvBultonvoCCWLWhKaTUENZBnItHil0iGyI2hvTutOX+xZksmACQWZYpPj33u5ImN4zGoO+CSMPSBCHFz8DBWPMsxD4jvsah1M7D0Yu9+fnYIMrNs4LZZQXRTYYqUxSpD81xj4uTjoW7/3hwoeAuKibovP2ZCSl9NzCotoZQHFLFvUQS9rzEBmlqOWLyRdCV2V6UHmJQ4eBb5kSibEAW5Pd7F+H9ROdsgiOeSBzsgT9B7MuBAfoudyaGTT1M+Gf6XyqsvQSiV1Y9h73ynniMcf39CAhOkNE6+QiXSzOijiQIroUT7pom37cgiCA37kVG2cU399JGZ+2wFSGLiHDThUEYcoFqoEh+lEOv1GmTT0BQUxHUIUZAKhuRMfORBgZcw1h1W4kaGhkccybi1O9lq6kix3PHdq6iQ85olEx69qV9FqRUPDbCbgqPoWIythZoHHmn9ELbwK2MhQyEBZO1p
 LuqeYrsU
 D9ou9wrDbuW6K8bPoDyr1B+uM5T9vDC5i/bq7wZ/DlCpZ6XEp7AE0CIvAZ/9V71wL34jHNxhnuaHkLK1AbGgVPAJy503KoYzK0CY81mkBkVNGzPurflN77M2dHoOA5uEiKNYtP9AE4UM6Mr+YxN2WLoHF3NRRjYHa9QvTb2I4YoyZqxk+HzvQbA22f9bSu49EKtF4V0ODGiYq2QUH+kvA6xIKKyuT24nwxVFRlCCkyu3l4CB3h6wj+zQOkj7Q07eIrMTLZp9isrnnXmIIe1CTO9pUSnBPZgVivCMk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 02:12:19PM +0100, Marco Elver wrote:

> What's a better name?

That must be the hardest question in programming; screw this P-vs-NP
debate :-)

> context_lock_struct -> and call it "context lock" rather than "context
> guard"; it might work also for things like RCU, PREEMPT, BH, etc. that
> aren't normal "locks", but could claim they are "context locks".
> 
> context_handle_struct -> "context handle" ...

Both work for me I suppose, although I think I have a slight preference
to the former: 'context_lock_struct'.

One other possibility is wrapping things like so:

#define define_context_struct(name) ... // the big thing

#define define_lock_struct(name) define_context_struct(name)



