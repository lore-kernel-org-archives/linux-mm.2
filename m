Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A190CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A568E0141; Thu, 18 Sep 2025 10:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B6F8E013A; Thu, 18 Sep 2025 10:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A128E0141; Thu, 18 Sep 2025 10:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8448E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:15:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42FA81401D4
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:15:21 +0000 (UTC)
X-FDA: 83902568442.29.5AF681A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id CE1D1A002D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:15:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=khXb/ArQuyu0wy6xtQhmAnwTxUmi7GFWHE031JjnAKA=;
	b=CCCiLtzG7vGlvKwgh5V4oDz2dq2DaSFGCO+i3J2ks+6hn8tCY3iX0ANHWzhVLs3bb6Ljy1
	4a2RGdzb5y2PtlvVT7RnWT1SgBLnfMlPS4gNEVqrxsGsZYpd6mg1lqpWq2qeb8gBwKcH9g
	pS94tWydA2QWSLCe4fdHeX9+0YpuV1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204919; a=rsa-sha256;
	cv=none;
	b=H37EnjXXMJ62jzp+tKQyfohJpD06Ro7P2uXi6hzRyCNMzRhNfrm6znbIsvD+oAEIbnBZUY
	O4mWOlbzI3miUX3e3FRvFDZ+P/rKqftWUdjFpuIiapmRrSqmGUXeByYMZHBGsEknZWdHc1
	9Z7MfGbOJ+tWsS2n+c9YqCnQis41jhA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3F714227A88; Thu, 18 Sep 2025 16:15:11 +0200 (CEST)
Date: Thu, 18 Sep 2025 16:15:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
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
	Nathan Chancellor <nathan@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
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
Message-ID: <20250918141511.GA30263@lst.de>
References: <20250918140451.1289454-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE1D1A002D
X-Stat-Signature: phxwuch5x368d44w7d1o1534b9kp9nui
X-Rspam-User: 
X-HE-Tag: 1758204918-748169
X-HE-Meta: U2FsdGVkX19pJQR0W94OQotG16N++3SAJGGJORdRKEFDdgZt28Iz4+vKxPQKcFB9Yat+k3bY/9QSZYXfT5+FV+n78r6mtUeGI8E1DuMyspJziHiCbCK3DBvWuDTbJ8rxrbRGeHCRLTNDZfdeN6M9RMTOFc1DP30eYdELcIoS2GpGdbH1DMMEfUfDqT+z5qAWWuJGiHse3LrXMeQeF7+H3PL9u+Gj7VCKYU7wtt4D/k8RjABEnLTvhUIEA/cn08sncfxB3EkEbju8F+eLtmPiJ14hWChNby33vDqXoJaT+/4zbwYw2nftI7tav/i/v5fD9kLW0HS1h+aM4uVcb6C0RQ/sp5i8YI2Rr/cq6OWRyT9YbopJ5IlpbYc+0YqvJQrGB7DlaOlwdK5AU1OXmRlAAKuA5CTNOP4VmC/ftE4uYTRJ6MuWUMlE6q1BQnqhwECK0zRMp12wT1eq9JBrUSO5TPROPlQFn5DU7okv7VQ87YoMMOB2i6Os7l3ZHBHK6YmNcknSXue4TC4qgDDFmETLFvUZ5NNiLTncMca+Xdoq7pAfNJxPkMQDwLlYWM3uhjtzBwE92Pv0xnZ3AoGOYt3qydGzl+3G6QHfpFOv5JgaDAdCbNYFIVvg4BdTdGPtrmHkue/EMMS00Zit4AGIFlLNfDZ10dCrD1KmScOADPmMJIEV1WwR+giu6rBfg6M7Ll2NDjyaz+pHYXs4oHLieuRwjWNEpU00HULqmuatcA7NWIVQQvQNDWUnLZq4bsSPXORhqET7vSDtFm23/RyHeStPpHPfyLWPcY2sQlf9wFdCaVAi2gqQkPzkA3Si0boWjCg8bpFYzO5tJn+6cGzqMzqq3PsEESHAbDx4Xg/bl/jgCwqZqjNib1OQx/msT+e+un8zA/207GxR3hRWZVwn3yGJImCB4PaLT6bcczD+MmdXBJDEGobShMfZjGphDE1RmRGPHrVTZwCGtKONlTPjolC
 qpbdmD+q
 P13c6goCEy0djcCbzfwRHJtxqByFzmcUH9gZEZlJGXNS6fcMyRsuOKiRcSdY4ndjZcTx68bMvziLRjb0KXAF6jxcootMXSkN9sagSuYvgF6PS3GBnOlxz4LpvlkDBTftiHJ2RFOPCVxASJ9Nv2Onpi9vmwldOnV1FpoETOQj2mJ4MzNUXjhkGI34L2QfjJgcz8zDwA0dhCumuarFhYnsfN4A1fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> A Clang version that supports `-Wthread-safety-pointer` and the new
> alias-analysis of capability pointers is required (from this version
> onwards):
> 
> 	https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]

There's no chance to make say x86 pre-built binaries for that available?


