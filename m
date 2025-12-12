Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2299FD44149
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 09:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F406B0006; Fri, 12 Dec 2025 04:33:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0296B0007; Fri, 12 Dec 2025 04:33:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DECF6B0008; Fri, 12 Dec 2025 04:33:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A24A6B0006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 04:33:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F205B14047C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:33:58 +0000 (UTC)
X-FDA: 84210307356.01.541BB6B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1664A40004
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 09:33:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gP5FiKEc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765532037; a=rsa-sha256;
	cv=none;
	b=XZxbnF9xlrQHKB5TliwqZ+cWC7i355AnMdVS3QiR4rOfrE5gEpcvRQIXfJjq5zaTnNo/rI
	4lh90OJNUu3Pc9+HSJ3yfzTe5ISRzhVhj20lrhBxYH9HX+fx4Ws5NSaYw6IqXy/49OzoD2
	aq/YrCAR2bYShxj00SMtYy2VtrpFYeo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gP5FiKEc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765532037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQbWCtHdrI7qQ4N4sW7tS14xKqY+Ou7bmuq3drTQLtI=;
	b=xJcH8QT+Nv3oLuZgykWwKMFWmKm3OSPeIjez95sx9nZnAbv5KOZ/ze6CevL4QTJTRY5aC0
	bib/VFTWABulYZkboZyjUJbhYatliUT9azMv7D1lQGYZTEbgorCFj/Wg5NAG5crDI1OKI+
	Tbt4M2lZaPFjNdnq7l3eLftV31qHSko=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pQbWCtHdrI7qQ4N4sW7tS14xKqY+Ou7bmuq3drTQLtI=; b=gP5FiKEcmRnzQyUehVXnsV1XLo
	4CcGaKrOQoiMISbVTofuAAzhJZgdbdZphc6+x1ybUzVkZ9ZIq+GUIyAW0RXaobcGzp3FoJSN6rFWv
	0yhVMGdMzV2vtNMeuYgu5t8Zyu42infVTLpV1cfat8gOQ0liRPhAl4eLgDj43ybPYnnQcKV+ONTXe
	Y/AKRBnafep3f9UBI2BEeoF+Qa7g1+EVNns6zvQakSyTIOu7q6cost+mJYrwRrG47Eqfq4pu7TD3X
	n20VKo6HKyEjEjh14xxcfmEYEjGZ4QZ5QEkUMmF28XCiymvyS8qAbpHBDAWhL6ziTxLJdrPEApNBc
	jWFa+7Rg==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTzWw-0000000FU4K-0MV6;
	Fri, 12 Dec 2025 09:33:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 08ED630041D; Fri, 12 Dec 2025 10:33:40 +0100 (CET)
Date: Fri, 12 Dec 2025 10:33:39 +0100
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
Subject: Re: [PATCH v4 16/35] kref: Add context-analysis annotations
Message-ID: <20251212093339.GK3911114@noisy.programming.kicks-ass.net>
References: <20251120145835.3833031-2-elver@google.com>
 <20251120151033.3840508-7-elver@google.com>
 <20251120151033.3840508-17-elver@google.com>
 <20251211122636.GI3911114@noisy.programming.kicks-ass.net>
 <CANpmjNN+zafzhvUBBmjyy+TL1ecqJUHQNRX3bo9fBJi2nFUt=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNN+zafzhvUBBmjyy+TL1ecqJUHQNRX3bo9fBJi2nFUt=A@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1664A40004
X-Stat-Signature: 4snsdt66fk8captdmtm8yzt6zbs41gjw
X-Rspam-User: 
X-HE-Tag: 1765532036-504841
X-HE-Meta: U2FsdGVkX18cxbXFEwOWBBjrl4XZiwiRf7Ekslm0S1Zn2yeacyZq8aBBto/V2/NLVC1OC+fUH5nrpX03H+0z9PiKNsFFFcejAVirnyftHmiNG/QveyPvLF2eMQNG9CocZS7/XfTM86ZvXEeG/6DfO7F5LkA41lNPMBZvkePPW6SmEVSwJUBFyxmVcmh3/WaA6AwPiOwQp/VMobmKOiswWwBIhnCqPGGAm8omtIB8Ll1bsOAq4HpW27heIvhbxdrTPgjC0kzy9cFhauo55TaG4vivCub7+xD6oZpx24PVeI5oNt0ZHZoHgHls+BKS/8KC94oqvbgPwE/lF9lP/gHu8Y9Sh6HQglgpey04tCAFLdlhgbWAfxou85qLCtmTQLHroBxaeCLgUGCBwzpYOYFRx6gjdyf+bm712XrqKgWllka9LFOUc/Kqdx3WNmkbNzJOt7VkDnzyzulbQ4tHD+WkDRYIlh2nDBJK9fEDNYVEnyA/F45y8C0rn1jhGlbRWIVVDNrtp7Uvg3ZNL0UAONllIi83Vm0nE/bf+lvkOArRLuMu6G981XZasf9HfMq0w1NgqH5F0/GGcT39m55oKfUoP6qaT3UR12jplDbNf1YGdZJZ5g+VZj5iGCeOxmw4dfI5wSzTRdZ6a5gPkBVmkbp4D3An+k8VUcnp6mDigrLUjvbfOJIEd82aZhZiQT4q4Y1VkiwJODO+ay8C0qiBl2VRBBdqirqZ/z6oePTg1H4L/2SJ5k9/3ObxUBSngoBH4Zzqv0X0SCFKGLCOTMOsrBcKZBsDe1v5UEx0sVdi5DlODmSNHqwCdGiOvDEGE/f8H8sQoFXArS2hHRHbwHFyDKcif6ohwwUI98Ng9tMlZnBU3aWd1xTLvsETbPN8PM9ZXx/id1YVr5qAh9COBV3tqEiM4B6rB/j15ss/9zqByAIbTYub73ssQOfEkIpTV4uK1AeAQphHzXz68NN6/HsbFnY
 0Qtq7a7Z
 bA++WIN/IiM6EAZuQn20m9imZPHCE3q1RF7xt5H127Uvn2aZNjKelLUVDDT/GVUUFIe3uUINH7Z4MWVhGrTnomk1lKWOXL27roJjovHbm4n9BLVMhW8uNMHTsORia9yiWuTRusLhYeN4mkWjrVT/KWgGhx/YugmfPjQSbFyABCXCMifaRyvJhd2ReyUVfaDMThes2noO4kfyUT+zJpgpanVYjOgstVDHK9ilALQPFuzXm00cmeYAVDa0/Q0P2s/nBBgHsClrr8RIUMLKqAU+mpowEsiYZ93OyPUxuHqPIUio6RqaEZ5doOixMMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 02:54:06PM +0100, Marco Elver wrote:

> Wrappers will need their own annotations; for this kind of static
> analysis (built-in warning diagnostic), inferring things like
> __cond_acquires(true, lock) is far too complex (requires
> intra-procedural control-flow analysis), and would likely be
> incomplete too.
> 
> It might also be reasonable to argue that the explicit annotation is
> good for documentation.
> 
> Aside: There's other static analysis tooling, like clang-analyzer that
> can afford to do more complex flow-sensitive intra-procedural
> analysis. But that has its own limitations, requires separate
> invocation, and is pretty slow in comparison.

I was sorta hoping that (perhaps only for __always_inline) the thing
would indeed do an early inline pass on the AST such that these cases
would not in fact require inter-procedural analysis.

