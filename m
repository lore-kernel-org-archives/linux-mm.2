Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D109D6ACE6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE8676B0088; Thu, 18 Dec 2025 06:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96356B0089; Thu, 18 Dec 2025 06:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AA66B008A; Thu, 18 Dec 2025 06:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C30886B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:23:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7749B140E6C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:23:38 +0000 (UTC)
X-FDA: 84232356516.09.FFFCA59
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28942140005
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:23:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=MMhSvlZ1;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766057016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWs/FMKLopR8GlxWJLTbeh62Yklb02RoamS4e6t082k=;
	b=E9d+qpOrw+9AkCqwRInkjnJElef5LT5v6mPDkNTX3fJVxZ3kIySg0JLrYGDi6d4bf13KwW
	Cucy6MBOCgOGeNyxgnwaX5pDjTWpDav+MkwjmVh5ai2Lx6pwdCQ7xazPd7D9gcp06HFRle
	s9XDHnl4zKXvA32hQlGBzoZHTl7q054=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=MMhSvlZ1;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766057016; a=rsa-sha256;
	cv=none;
	b=i+xrsQVys2wtzfCgLVOwq1sS/J2qL6t6HMQMv0Ha/nkC6avDTmrLwcployBBdeO8qFqOo4
	Ac1pwIi+X29tNr5Zqa1kBaWUzD73loiRtfgkMl44W8YJwHpN/imcV4mW1KZo3AFA82PV7U
	zmfvg4Das059OM1xVnY/jEUHAi/B47Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WWs/FMKLopR8GlxWJLTbeh62Yklb02RoamS4e6t082k=; b=MMhSvlZ1U0lhTWOGU4FNuxYI3Z
	GRAr+CdcUkTNZseY0omR8YLKLA1QJlpPz1h86m2c3EhJzJB5yGJ/CygiILJOK+qNvILaFDFwhuAw3
	EJQbrqkHxY/iK3OjSwLrw+rUQdfX56nRe6Db43U9YpR6ybFZf3B6r2x30ztvg5jS67xA/pUoZXDVb
	C+Mdp/HiC6X/EPz8pwEx4Ulki1zvOIk/I0ObPrwEXdFYBvYpYS2o6qvadq5aCBujtL64qu3Wyq7WI
	LhK84HnA/xPWUkY0PFgKtEEIwQVN91FdDzOSntpHWyeqHY7S9olXkJWkJuT/Mc2wTOwAluJ2qhhEs
	CwoFBrow==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWBEi-00000008e0m-01ZP;
	Thu, 18 Dec 2025 10:27:56 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DCB0D300578; Thu, 18 Dec 2025 12:23:08 +0100 (CET)
Date: Thu, 18 Dec 2025 12:23:08 +0100
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
Message-ID: <20251218112308.GU3911114@noisy.programming.kicks-ass.net>
References: <20251120151033.3840508-7-elver@google.com>
 <20251211121659.GH3911114@noisy.programming.kicks-ass.net>
 <CANpmjNOmAYFj518rH0FdPp=cqK8EeKEgh1ok_zFUwHU5Fu92=w@mail.gmail.com>
 <20251212094352.GL3911114@noisy.programming.kicks-ass.net>
 <CANpmjNP=s33L6LgYWHygEuLtWTq-s2n4yFDvvGcF3HjbGH+hqw@mail.gmail.com>
 <20251212110928.GP3911114@noisy.programming.kicks-ass.net>
 <aUAPbFJSv0alh_ix@elver.google.com>
 <CANpmjNNm-kbTw46Wh1BJudynHOeLn-Oxew8VuAnCppvV_WtyBw@mail.gmail.com>
 <aUE77hgJa58waFOy@elver.google.com>
 <aUGBff8Oko5O8EsP@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUGBff8Oko5O8EsP@elver.google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 28942140005
X-Stat-Signature: ykuf6ioausiybcc4g69twe1uhuj7jf8a
X-Rspam-User: 
X-HE-Tag: 1766057015-331112
X-HE-Meta: U2FsdGVkX19J5AQoQCoYsLaepuopRbIsDdo2xnWieiYWZrI1xhpxpuJdD4f1Mkg47suZcEwRPOUTvAT1/eNLTz/47Wsu1O+hH5+RFwHD1z8u8nWA2PVmCNI7Dc5fgD1M9jF6tfi8PWEqxKsZHHgxacx6eqmmpzBMvDpCd7TlYWmfNPk3BdHQVW3P5heGX2AkycNwTTc51GERMpFue/LE6g0TgVraSAsMYQy82ba8Q6ZBHHp5nS1LPBq7fWi7rS0plnHYb3jAGQNphX8u996RPyfpuTLRhR333GK55JO9Qqh+as9tmCIV9jK2yOxcs62/90viW5TEhWT/7I6NRz3yZj34EeZvKuVmpcrGnsHy3AQaUpGrZvM2UmcO3cFz5itBemLnGu6SFhNYIygXXZKfvszlOFrJk8R8zRgmRbbxUTtSe70OPEwvslk4tyDMaTScBxwzwQzRgervLtOTHXS7nmz55CkWyEmnJeHazLCkHW/RahLOmMBo3z7kTthi2kESNYxgkuoaheVCKo6+5OVcGazftAjX4M2bhsvXU+OJXGtxbe40EHnyN1l4N5uc2wqJGF7WHZhoFGmIbIzQuKYXGzzVpazT54a6m0xSZIXtNHjDbe+ZrHirG2WNoX3ZTttdkyzRSi4VF6UZDJgrfTRc7vXGXLAjQMr+qroLm6ej51PVDtyCpbebDtduzbL1NJpqZV/dNv1I4zqxtMGHonfawLr8VllK2hXiInjRBBrSt4g3bEVhb7t6LXwPQixS9fIqFaSs2a+Mmb/vl3ATFqc0QnDMqCoV6DpscyPAlpX9f8EZ825v8qed6UyOmU+eWAFmnQtAo6/wRyMSZsbIeYhbqt5ZPBq5DBAtNds4XFAmr17vA9L6qqTg21r+qzwRmNxEQYtCVCZvNt9pu/uBgLqIx7lqjw+LyoOjPEQLxTG99kMXFDpAisAy33io1blMkbGitvb0l+1LuC8NqZwOHse
 BUsUD1MT
 Ur8M9toYaMlwKRLnxI1mzwTYBXSBiyCY6esqwkVDpfQ8twjiHs4sVtC+dGInZJKAduetfuvOfh9AlCOLHrPM4tDX58KXkEXFhVMmiFz8GEvrcuejN9SnyGDRo5hWqIgbQJHMeN5W8a6+WFfPnhp/CdDrH27X057ObiTPDF3NBazwRjqXde1X1fV8Wu3xGNvxu7GcgG5K32TfWu8VFJGiU/5yb/E3Q1gzodSxaxkuanrVQj+ULN8amSUGtan7pET5H/H/IMxFSRhVSrivomMG9gYf55S2ojnxfICGevs71U/VvxrlX51Ob0DDo5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 04:57:49PM +0100, Marco Elver wrote:

> Below is the preview of the complete changes to make the lock guards
> work properly.

Right. Not pretty but it works.

I did spend a few hours yesterday trying out various thing that don't
work -- as I'm sure you did too -- but could not come up with something
saner.

So yeah, lets just do this.

