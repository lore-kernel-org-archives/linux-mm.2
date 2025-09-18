Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 013B1CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 17:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150768E0130; Thu, 18 Sep 2025 13:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1019B8E00F6; Thu, 18 Sep 2025 13:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B348E0130; Thu, 18 Sep 2025 13:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD3DF8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:46:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79F9A1DE30D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:46:11 +0000 (UTC)
X-FDA: 83903099742.11.0B60B57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCB99120009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:46:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i6Kqz0C2;
	spf=pass (imf29.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758217569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/AjRTzvm1reEs20/D20PYYLijiuc65vTR2O4HLHfPk=;
	b=C0xbhZFO6pIkDio0JF+T7UnZJLhca+FunETFAzgFW44B79lCZRvHDYTs53pS/rVNzyFEi0
	OMnewMaEz94Xm7w0c8tDKjXJDRdVjy35RL19ByddcfOhvRzRD2k+YaUOhuu5KWSUq4AQmb
	YNnUsT7NHyEdPP7nSejJFWLLtC36CCU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758217569; a=rsa-sha256;
	cv=none;
	b=KkGqNusriLo6C4jjhGZPfWp+JZBgarpEdOA0f16+0n2yaEuqzjWx6WwBdfm9BjEenzAoZb
	9ciJzubRSXtrSuvd3sR65VD9D0RcuolySfhESgNRVE0wJAkY9XikiTh7ayNTiCfINMAjuC
	zuCt48aZjQpmXn3wSia5F0Ll62w3XZU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i6Kqz0C2;
	spf=pass (imf29.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B231060207;
	Thu, 18 Sep 2025 17:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C0AC4CEE7;
	Thu, 18 Sep 2025 17:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758217568;
	bh=ZNTo/Y9EyxZmz/6UCc4XPFi8e1W38Mv8YYcq4WlZegE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i6Kqz0C2bMyTxFSdnUrmZXomQZUKN6PrE+wxZtJczj7QbrNhByTVlq1eR7IvDe3Jy
	 Rb0EVjsKlu7+xQR8iunNSXY3VfqUgyGCab6xsnZgBZl67tyBH/axKezDiuJ1cjPL/B
	 9kfaRoWNLZ5V3wySAKqhDPOxfQhGSa1lzggNioVkRAcTy+hqrrr0X7H9JoiHVLVFUo
	 mnNYoLhoteQ9EMMAi0FpYEfUzAKGMHcgiX/jB/qz83MmJDJnFzCuWf1/aH0MsAzimV
	 sIMfY4OB0F6qYHUWlI8mz6IPqJvhYJpjwfv9gUvj1AZPTM7hciQh+uiQLZarv96/8X
	 3zcI3CRc9uH8g==
Date: Thu, 18 Sep 2025 10:45:55 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20250918174555.GA3366400@ax162>
References: <20250918140451.1289454-1-elver@google.com>
 <20250918141511.GA30263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918141511.GA30263@lst.de>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCB99120009
X-Stat-Signature: udxrfojmnga9ijd6qi5ghwm75y8c5uqq
X-Rspam-User: 
X-HE-Tag: 1758217569-560664
X-HE-Meta: U2FsdGVkX181D9weuQziqKnKgWyUrlbvfIheuBlG4nkmeQ0iBa+Vh8BYpqAgNukFAc/jaiHGcqwNdDKkQ81GBnvcFFayBtPZ7suvZQseo5ssNeR0ieSnFpWy759YuCgkHmsFFwQDw3cnuR1EX/9gMLYbCyVJ6LFJDJEhzKbuwsWUoUse12U8iKYjLmDRfc/65TthlRtf2l0oLEY6sZEAw1CZep9QMF4AqLwZPSGEptUvYffFeHOfPyacWwzpzaahNfRrqnFLTrBg/zppT1C493XNotS7v2Jbg+0tYsOn/iOQgLE/3UMmwemK2NFP3T2MVgi+bn9hiupHJDQsrhDiPZbctANTfpbv7IMDp4WRbSJib7N/QKScYbhvr/BU0l6YeSWcH7QIL+1qIOXjSohEZRgay9IxoFHddUsMueF8XfoaSBrjRAimfvu+5YfqTQYiN1qrZeL5P7loCqyYNyt2wohLaOVLKQJVuQWCp24BP1ss10HRCCbiVvJ9PbWy4LP16jb9wKhzEb0jduSud3jb6mQX0VCmzBEcaS5siB9OSJ/BlZFuoUFksH4rrVg9zHhvG6zMi3W8JAUrMZLfs3907S2ie4gWNIJ64tMGNpbKSkgJ6HOgvGK9WBi8lOyoH7vWxo63MMssSTlO3W3sjku1NfZ0CWIQc7fmTUdZpmMwNdHrvl1+wUbOXsjQ4dsRXOgBPh4I+igMjl4ClWeSVxJ9dW/YGsL4g6y+D5p6d60PWA6ruybyZ5x3mtdVK4LJjzm5oX730od+u4k+GFRsqbsCfAQvXqojIRSsFmOxZewAW6htv5NewRQwsoQUBol+YXmdCvASvvi+GMtFFBzFCGhCeUoI/pK4iF8+Pf/+zbiVZKFlgYkIAKj2zLAnfvl00/VSWIJhZATBvkWZUKuG8bYfnH4PnrIRGqOA1tK9uiyZ/XHEqUeZ8rFeS9lUS8wtuVbMvLWHn1EGGycZc9/YDbK
 /UYTDz2k
 NbvIzR8GSmenVDP6FU3jnuSuXMtNay8nB1QKMoDB5Ym+9BOlMchPJ3iVkMO+Nu/176xI4UQ60VDz8sdLtNTuw/jKm6L8kXviZ9K/zPPo7VjMl4MXdjcFwGf28LKOE4KFWJaZddv/12LllWMwPmNfirmnHip4Mv4ylvr/EK2LHWe6DbDkBSE9WbUAXdaUKwXa3fC2YY0f2C+5wUexG+gRVOjlnt7jf0KMjXAzwdR5g0ooXpXuxF+VsEhWzhOojybAyiv7feZoapiPFMywlFzGfNZO4DJfgs24BIQoVBTle6MWX/jkfvtQs5NM6sMYO0OIJj/pbt0Gu9OHRBrSmnH+rVGDC2hUTfQaKi9i/yaD5Ffq7xlOSQjT5bHuBWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 04:15:11PM +0200, Christoph Hellwig wrote:
> On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> > A Clang version that supports `-Wthread-safety-pointer` and the new
> > alias-analysis of capability pointers is required (from this version
> > onwards):
> > 
> > 	https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]
> 
> There's no chance to make say x86 pre-built binaries for that available?

I can use my existing kernel.org LLVM [1] build infrastructure to
generate prebuilt x86 binaries. Just give me a bit to build and upload
them. You may not be the only developer or maintainer who may want to
play with this.

[1]: https://kernel.org/pub/tools/llvm/

Cheers,
Nathan

