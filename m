Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56622CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C778E000D; Mon, 22 Sep 2025 13:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34538E0001; Mon, 22 Sep 2025 13:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71838E000D; Mon, 22 Sep 2025 13:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97A488E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:12:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41288B6722
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:12:33 +0000 (UTC)
X-FDA: 83917530186.11.9014D93
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87F72C000F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:12:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758561151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hVd5FYeaOOqCS05QvLLgASbT7Tr3N+hlXgG8BG8Sjtg=;
	b=UOTpNegmvbt5mnNafl5AZ7pn5TrdzSTYWkMfp4q1HPLPPBGsoPp4qBQ+skzt9dJn7qhL8F
	YqSp5xsdlPqhHBEL1H3x17c0gCJI/90GiJITsGX3ynAA8IDN4ztBGglR0nQhrV+LlpOUwI
	WbJLmOAuxGxwVeQ3R9PRG36mHOfkPlE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758561151; a=rsa-sha256;
	cv=none;
	b=6Ms9H1nnZh7v/Dq6CTZMFJjJQ0JCXxu+8dBZ2Tb+LTehsEopJEYLXOGoqzaSwHf8HbsjNF
	wKPdE/mSzbJzDRN0kfEXKwFKgpPqFCg7QhCA3tsXeLLVu6+YSw3UeB31i3TbPTtCbx2n/N
	8Nf1TNUc5Gpcg/Hdj2uHgGldTLMD0vs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6B6BB227AAF; Mon, 22 Sep 2025 19:12:27 +0200 (CEST)
Date: Mon, 22 Sep 2025 19:12:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Nathan Chancellor <nathan@kernel.org>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bill Wendling <morbo@google.com>,
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
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and
 Locking-Analysis
Message-ID: <20250922171227.GB12668@lst.de>
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de> <20250918174555.GA3366400@ax162> <20250919140803.GA23745@lst.de> <a75f7b70-2b72-4bb0-a940-52835f290502@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a75f7b70-2b72-4bb0-a940-52835f290502@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 87F72C000F
X-Stat-Signature: g7en5uw53qkf6uan7g4dc15gadpfcpmw
X-Rspam-User: 
X-HE-Tag: 1758561151-688864
X-HE-Meta: U2FsdGVkX1/2IiFLgCJwb1DdkY1D0mflqGSM+It0k3VQ0/pxFmaGlenyayQG/voMwS+X7IV0g30NzsdlLyO0dSgFsYRtOfa/er2KhkChi4bNW89v0RPyEaVaiyK/bZF7eREfc0Cl0l6oMlB6Pi3E58EPG9zck06iaFX7dggq1oqRyup8+BzWM+m5M5twV4x0sCc9PkF6eu4mTvDEh8Lj1Kex7KYKAjW3Nq2E59dmo4ZgrKxN2c5wAMZwb25PdvrC954lkuGbpmEJt2VEOtR77UwDi0EUPR9n1S9UHoKIJdaW2nhDOPa5TFWx7eIEQ6iDXYcCyAUHZcqqxqJuR9rR/YXNkQmtsjw88aZRrTu7T0qBKR9cncldp70dWQUWw7PJBixdmVRc7XZPxyWKJE7oWQUT2/B0ppNoeFHko/IrhwJXVI24Yx20emFCxQDDnpcJ+nOCK+x6lnDrC81IidegviwTlbcyWGMBZImJYunULp8xv5ui1Er8KOyPQHSPxfZJrOyMVqXH7Of0OQDV8nxdfmPO9H5vzHeHQcPO4H0dOOGzibYMZnAFT9vkAT/VyUtnbWq6501wEIM4H9RY+qPSf2t0AFJvPFRAVzAGYkAJWbMv7d4CG3Fuh2cQXX8C+5PQwnaPpaqqF1oYvsj1SbsScgSLMr6yP7pGPFPfqditFyKHqq5PqDfPaD8vt7w7IzqG53mwAxXaX+h+Vx/i2JxjIbAdVQ6kGlGE0VaIJt1qhHGgn65h/VJ7MlF+qJkw/nyK4N1+PcIWDVzH9jt7K5bmW11SbunyAGLTzoIZVtCSYBc0wRhscAGFIMSYxvXJQIlKt+jZQWcx8VOdPIlbR1ulyn933p+Yyxcc3JShC4LGR2AHgQYOjRDks3ncUMDQ9c3Ob7vSwS3T4Ban9GoDyOs2RiYwNyQDQ7FS1IGssejMfhtTh0dgDC6/ZCFuJwFA7QVaWOd4QIdgerYHOW3mhDA
 GxIb+Jpu
 KpvZ/khRYdlPvKmen5rh0Eb5pg2dKDLBvacZI9GM0/MTqdvo23MOFIabqKDVVjqx1Kc6DVYkMK853twek7Hvjttwq07F8z07qC2vzjNcw4VQ2r7IduCQ03XYhjsf/q/3xfMqFWz0oP+Scv2o5GoQDV6RUdrdQULfh440ZRWxfcEoWcsg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 10:20:37AM -0700, Bart Van Assche wrote:
> locking annotations to kernel code. I ended up annotating multiple XFS
> functions with NO_THREAD_SAFETY_ANALYSIS. Maybe the locking patterns in
> XFS are too complex for compile-time analysis?

If our locking patterns are too complex for analysis, either the code or
the analysis has problems that need addressing.  Potentially both.


