Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2B1CCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4459A8E0147; Thu, 18 Sep 2025 10:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6C48E013A; Thu, 18 Sep 2025 10:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5798E0147; Thu, 18 Sep 2025 10:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 128358E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:38:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9673B6E43
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:38:15 +0000 (UTC)
X-FDA: 83902626150.02.5FD62E7
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF3B41C0018
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:38:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758206293; a=rsa-sha256;
	cv=none;
	b=tcfUNsc3PbWzV48GgGbWtnDFJXOIfLitY2c1H/Wte81J6E89IqxrsFmlvBMaB6urTGSDQC
	V5fbWHMz0cCb4HJv2uyjUnGmxxWYFSDmx75M16XYTwi7n1S2xpyPPLwUJXcemEvYyt51um
	N9fjvXCeSddbK8B0OI1D8l3T7+7K36E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758206293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ErYq1TN2gNxHsdO/CoNyrv+xOAeKq1mQd5/OAeURC+w=;
	b=gMPIyPnonOLk6TBCvBu1BR9PXy4t9+kqdFgf6L1jB5rPzHTSBGUmvPfhCDJEXoSHlPPDmK
	+nPQDXNntMeupHdLCn2quAvyW2oxgecdF63aZaeMlXDeGfWzfiWc1M5x1i0856JNSmXe61
	OprAkjMrJvO3d1r9trkBf9l1GpQio5s=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 95E65227A88; Thu, 18 Sep 2025 16:38:05 +0200 (CEST)
Date: Thu, 18 Sep 2025 16:38:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Marco Elver <elver@google.com>
Cc: Christoph Hellwig <hch@lst.de>, Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>,
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
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	rcu@vger.kernel.org
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and
 Locking-Analysis
Message-ID: <20250918143805.GA31797@lst.de>
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de> <CANpmjNN8Vx5p+0xZAjHA4s6HaGaEdMf_u1c1jiOf=ZKqYYz9Nw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNN8Vx5p+0xZAjHA4s6HaGaEdMf_u1c1jiOf=ZKqYYz9Nw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF3B41C0018
X-Stat-Signature: nisyerm17hy99xadpggb4xmks1zjzjqy
X-Rspam-User: 
X-HE-Tag: 1758206292-90052
X-HE-Meta: U2FsdGVkX19+yWZGV1jKGnjHOHXEFddT3nEamcMaXQ5P71egooDTn0XLk+onl3flz9DI5lrKX4T+41SKxdw6EwIVkEATqCLRU9206pK3rnRWTvwv/bmFX8wP4xdLYXo/Jk5XWidO/rJx3WSyJ6i+RQ0hRuhJxb7Ywvp8erS2bgKpPOBbCT/4NMJItGOEf9FK1jEnm3ccfZyNnKn8v4AaoyvTF7GlsYgZCoNNXQXK1AztqBrdmUOYlXao1ne/+Kvcve1HwQv4kQdG/DDejf0utYlfP9UmDC/DI2P2O9q3s0RRZCbTITqTSHcVc/Omn2C+7Wg8xP0Lnnr6VNQuHdeugFQNcdDbyKJep9bPD2Ymh+eVZo32I0YjVOW1IsdQ5YyDYlQA2rEMaiNYAzz4CbIpuIxaUJq4Gv5WYpQQq0Ek9QeBjNjqc/JZ9ASXH6gGBQLfSusJS5GW9NSSZCpKAUZkTFBqw7THRHsVmLCJvz7MVywmh80yNPSi5FFxaUdurALet6tid2k32CaPUBi8DYnl2mP6lFsu1cyg1dWKw4Wze8IIBN5+UNM3Agmr7YTk5huqzVPogyYFejlq+cDK1VNJ15G1KbJ5l5u1sjQ7cyKJ+PtCoFW0/gr6GL8e4kzDxVl37tjCoXEQrRnJpeAHWeU+6G1ORFq6+69umqEiy2xFcvxEcg90jiuj6FZ1h3Qtu1zRud9strs732LbITPKRHRBq6WfCbp1RFVdvwPgDY+vTxI3uc9ZKk20X6IZUy+ZOuIH+1qzu9nB7DU+y2LsgveqABqkblUTbswumnAmH1319QHx4Q6CDCg9WdEtCodJkV74wyvKd4MdXZ7GbpAZWlYVKFsOipbUF8CC0r6XiCZj7Xg+7nJfwFAFXh1ky+roSZr01D+sMRDY3NJq+oPmSwqedVNltwSdhg4J6mwNknWtKxuP+zcS7eqlvt50KSETCQPUu54T2n5ggsVTIe37oZ3
 EM2SFHfa
 x0627b7icRRvDRpLvmN/Kmogy8RCogoXyJzs7CHch3MwAnz/h/2DgcYP4ioSp2xQy0hgYazfXxiG1Cu7jTfXcYlfN4nsfae7ldkffN4ZPrbb+1IBAlXm1PtIDPnXIj1FQfSXZKYptuYFX+Lf5lCIR8z7pvj1lKBBLqYWEaXPHZLzoXoZQK77UdWEBtvJ3m6rQYTM50vFJXPSeJTAfFpI177AbPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 04:30:55PM +0200, Marco Elver wrote:
> Not officially, but I can try to build something to share if you prefer.
> Or a script that automatically pulls and builds clang for you - I have
> this old script I just updated to the above commit:
> https://gist.github.com/melver/fe8a5fd9e43e21fab569ee24fc9c6072
> Does that help?

Just kicked it off, I'll see how long this will take on my laptop.
At least the error checking that tells me about dependencies and work
that needs to be done before starting the build is nice so that I
hopefully don't have to restart the build too often.

