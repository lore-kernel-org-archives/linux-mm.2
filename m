Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3F9CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 19:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB098E0005; Tue, 23 Sep 2025 15:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95BC18E0001; Tue, 23 Sep 2025 15:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A388E0005; Tue, 23 Sep 2025 15:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC238E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:49:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C925313B4FC
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 19:49:29 +0000 (UTC)
X-FDA: 83921554458.03.33A3C71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 43A8F40005
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 19:49:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvIaGTqH;
	spf=pass (imf11.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758656968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gv2WzZ+nMC2bdsHIbBsKOEQPNt5h99Cw1wDY0M9npo=;
	b=1kQ7fpVnWpI54/NRC3LWxwDee7VvzYpWvtqG3PtLL3lS/AnNg1vN6Os2gdUGC3GUPSyYDT
	Lt+wShvRAomGDrI+7SU0QlIUktHSnn0GYaPPGqMlxUQ3VycNOq24k/6WLT/rGAQDavBs4I
	7d+yFLacE08IkJGjXPQJr0CcPGpO2EM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758656968; a=rsa-sha256;
	cv=none;
	b=qAjmHQcNAkfpxCWr329aiPyyL6pIis8jgGxDgtiMo+EhIZzuEvTVtXVuSPwdCVCflOjoQB
	zaYUbkxjA26Iwhv1dKsCvAA0qLykZ3KvntKKcvyY/9OmEaAyeZ78viHKuJzgEf0NSjMH7x
	OVqPxi+u4U7gm8FpsTfO0mCchyMfHsc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvIaGTqH;
	spf=pass (imf11.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41C246025A;
	Tue, 23 Sep 2025 19:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0DAC4CEF5;
	Tue, 23 Sep 2025 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758656966;
	bh=7gv2WzZ+nMC2bdsHIbBsKOEQPNt5h99Cw1wDY0M9npo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PvIaGTqHdNU7Q1p9iQCyi7SI8rzgs+Fd2F62Wvt4e7U9M5ZbQ8qxnT0LiSPe4PKVR
	 gehyR0Rm0ghRXneZ4tzjafcgpCRITUKyHFvb6JN4O9cuxWgjIBHK2hM2MF5Y/HqnMX
	 n3nuIsdb1r2D9GFRjzSab+/uI7K6xmpOdsNRSsCVySBQ9n2ybIX4gsztX3PGvijcvT
	 Sp/fUhAnCreO1LjGnNn/IXq6su5QDyv6TUFvnwV57AFOt5ZY8qGMFKUOL3RBXFtVX+
	 bbjgLfFkLzJt+rxjoewVtxndm0w4xC2WwbySLCvFHwFbb5zcONvgE0SDuPCi7+lbEf
	 evcKd6295D9ag==
Date: Tue, 23 Sep 2025 12:49:15 -0700
From: Nathan Chancellor <nathan@kernel.org>
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
Message-ID: <20250923194915.GA2127565@ax162>
References: <20250918140451.1289454-1-elver@google.com>
 <20250918141511.GA30263@lst.de>
 <20250918174555.GA3366400@ax162>
 <20250919140803.GA23745@lst.de>
 <20250919140954.GA24160@lst.de>
 <aNEX46WJh2IWhVUc@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNEX46WJh2IWhVUc@elver.google.com>
X-Stat-Signature: k45qxkqtjeeju9icx6hd9yuazace7xi3
X-Rspamd-Queue-Id: 43A8F40005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758656968-759536
X-HE-Meta: U2FsdGVkX1+MkiY5a4WdCY+mewuhfQN3p4bSPYiT1GPFeL56uqbndDDzOFuhYoF35Rix3gYX0+CCaxN1dAe3LAh23ICiDJ+KduiP8qZAVfI29MIaEEalzySFqSWMbl+Dqs9Wu9WsgxNtp6hz6qjk4jaCuiasBP92HV+SVKHjJz1+N6MyVkZ3e7YN/voWMKJALdFeOD6ZekvTfV5JnzPNbRNWJevklSKSDvDYwu9/pkF/PpoVSltzUb91R7pszpQ31NFfcJVU8eoy3xCo1qtZIc68YUlC/v2ytRn996hC5SV79OxmNyHX/kJvbTsBmNcqdMjWddUC1mIiIJtiOMjM5eeCfv+5foONoLH09mGTnz+xeJe9wdQXwXXZDFGCvyqUhFXYMAhABc2qdyHCMjZJ9Yrr3nmOKicjGAxui+yjS3dVHJ/UP19ho/VNc/gjrunIGoSTYm627XC+7yhbfQfLnjSVYhtzkaC2oqpu26xGA+7VCbz5aDsH3S7JmoV4sh37QYDj07C2e06o84uLvOOwLvA+wrK5vbTrC/Ug5gBUx4weTg1IC/+QbD/xmKJfL/UwNHdo54TOR8v6YXFz+rxEMgPawrEjEEHBpwgUt28QejDG9qwjKlA/3gL49laeORXVKJ9f+hWQhu2NeNSAuJ6VFRia0g0ACgapsur/dL8uQyTrraLAKLLhuD2NGl/0KUdKBIR1V3JjP89sZ+rsX3VYeVmWdvY4kXXyWFeZeVIklbsskjMfTL/sSzJtUgGYe4fTnZ/mEvKQYlFJOcO2B2aSlBcet7Cgf50gK3UGubOfSKDAvs1/OlUuSf1GFrN7fzaXLxB5YeP41IpRQbq8BswowGBw94glyeFxuKrD6JSsX9OP6sgKOs417QQ/qo0asXvrrne7HjKn/xTCxm65TRM7ZvuIVb7N3KLKuSah53go/Uxrjt4OlQSrkXcInSaivDbBkg7J1ZA4XutqXMXqpUy
 dEU/lCFE
 XISfBBYARSC6F404QpX/IZrpq7L6ri0wONZQ5byM8a2MWAMhKtYVaPmNGGvbLPEwgHLDOB9Yt4aflWl3OIPrOPKCf+Ccpk+OTSOlBUs28YLdri3m+bqmNhOEjcOxOSZ7KCuHH80T7hUpNgjXmsg1ufXNqzq72CBoggxoWrL5oksKTmdF8HFy1aUx7Sq3Een6IFWMAWo6orsRIrSVUJ6oiEMDxgzdXMBHt9BPi6X89wGH4RhmJmZhCW3E+I+kzdjpwwtDJI1XNh075pF9P+8hrlHL8YJs5OLZTayp9lJwBd4d9xMydPLDqt6QIu4bgj7PYoeyAvT/jkicdPg9MRxQZ7AX2s/mImATDb7YFc8LjtzDug1Atvhzr1pybsY9V+NBrnVt8spo7rJ03pRHu+KtTnAl2zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 11:33:23AM +0200, Marco Elver wrote:
> [1] https://github.com/llvm/llvm-project/pull/159921

Now that this is merged, I have pushed an updated snapshot for x86_64:

https://mirrors.edge.kernel.org/pub/tools/llvm/files/prerelease/llvm-22.0.0-ca2e8fc928ad103f46ca9f827e147c43db3a5c47-20250923-185804-x86_64.tar.xz

Cheers,
Nathan

