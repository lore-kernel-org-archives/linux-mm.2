Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C549D19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8646B0005; Mon, 26 Jan 2026 13:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C1D6B0089; Mon, 26 Jan 2026 13:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 824796B008A; Mon, 26 Jan 2026 13:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7168E6B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:55:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18D5713BB23
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:55:21 +0000 (UTC)
X-FDA: 84375018042.25.CEDEBC3
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1095A40007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:55:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=4b+R0ix5;
	spf=pass (imf07.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769453719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrmRnMiS7e8oDqS8sJHadbKNaRE4y8/9HerN9jURAnw=;
	b=FgYJwnAw5hYylGEmrV7KmhNAI/UnvhYycZWIQ5UQcK/I6O+nJvwkSHsY63v7RdXROVTdtY
	gFOvhCaEH/aR9pKw/OySoaMCLo4EXQxbrI6G/zZvuOoQmLEE9EORnWZAvs5wL93kJzIQl2
	Ou198uPdFURiqL4a4DNqjUsjzufHTKE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=4b+R0ix5;
	spf=pass (imf07.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769453719; a=rsa-sha256;
	cv=none;
	b=SnERUcSR0gVl6e8R6qQX8vA13ju/IJeGwyHDlB/NLbLqkzlv8+EBAh6mshVhIo7UiuhVna
	Vrajxi5bMjLw68W7AjBiCsOp25tXDyl1JAb8bluWvEQwfY9L/S/3DM8Q6yfzYoWNq1l4+p
	KDbfkAgFl1yjOamik1qI4jR99jJ8aRU=
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f0Hm56kBhzlgyGr;
	Mon, 26 Jan 2026 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769453709; x=1772045710; bh=lrmRnMiS7e8oDqS8sJHadbKN
	aRE4y8/9HerN9jURAnw=; b=4b+R0ix5+Os0UdymHVdPefR75pAjuePHzZSBDv1T
	PhKFA4FAC8OQc9TuXgMxSrv6ALYLM26zsK043txlRzxnGUh1OQAsqSN0foShyawt
	pgoA82i8a3e56Az+c5yQ/FRzJRlVVV9ONPOmo5QZvE0Q0R6BZlDabDdSvqRaIrWq
	5qv/o/SAv+5/3fRLam45SzREjjV6pc62GFn6nBiQJg3JMywlrNKvmQ7VlMyrTxAH
	T23+3S/pU978iX4yw8ahY2EFo/8Xq0lczgH+hEk7oD3ExiVmcFff0tai2SlH7PR7
	9U/uiA5vPsPPUdDSnrYljSKcp1+NnDZMaTuY+V/YB+pCTQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vhOvcRL97NLm; Mon, 26 Jan 2026 18:55:09 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f0Hlj4MJNzlh1T6;
	Mon, 26 Jan 2026 18:54:57 +0000 (UTC)
Message-ID: <8c1bbab4-4615-4518-b773-a006d1402b8b@acm.org>
Date: Mon, 26 Jan 2026 10:54:56 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/36] srcu: Support Clang's context analysis
To: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>,
 Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Triplett <josh@joshtriplett.org>, Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-16-elver@google.com>
 <dd65bb7b-0dac-437a-a370-38efeb4737ba@acm.org>
 <aXez9fSxdfu5-Boo@elver.google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aXez9fSxdfu5-Boo@elver.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bepzuhoz3karkiwpa6uzeew43pbgb7uz
X-Rspamd-Queue-Id: 1095A40007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769453718-502169
X-HE-Meta: U2FsdGVkX18bOrkffV1Jgnl2tWFsCktixvXn3EPl9sj1KiGGON89g56h7UH481m4K2CpWq8RpmORNu5cpFV61O15hZGPXLfbWmwI0z+dQMs2uT67RnTb+JYqk9b3MTOzxUJ6H5fOwsBohl7YrdA7mEYUNGcLnXngdEYqyJOt5lkG1yhb0Djh5FdjaxWH+21LILjpeHxRUNCjlKEV6KcBrfQ3tw0paX1w57eH3YQcGqeuiCGRc3MJIrfik2DAo4cxqvDZMp342t1xD0Zi8LnOSHPKJ1FoTtXiZv4oCdO/83UcfbcU0ZSZGN+RC22Jdh6N3hWPQxZmXl58dGeTGCGoiy2aDvQ4jFQM/kSdjUPBkTV6xm0Cf8HmRvPHVIRJcwmWsJ+YGYhZVhfTTVVSRulJJXoE5X+iJCPtPkOZZQYdd3kvTwMUQ+uDARe+Z/1b2hvpdL0q7lyJcQKMrJrunB3w6gtozqP4p21g1JGWSGraPp/cYi/M46h1Pr53rXXiVeSQ9DVLs+Lc0VVXIJSf9o1oVF6jdYSQQcYDFBpWodiAo/c9oTdcb0TFMs7bDpp7ZeZZ4JvsI5fGSICaGwYwh0STh7yG8mHuSKuUO2TX1GAk6IVO++BaJqcnS7Kl/sLfCdwQDARsh9uGIgiy4Icj7Yvw/PJrF1VTenePBkRDOT4Nn6tmG+k9Mtqhjsna7ZLCAhO33Gt51/NEktly/t8uIWFVyHCdlj3AA+w9EAwWp0Jp+AreOzWt2av/+nIFD1/kcodtsTG+s2m+9kNfiTI6tsoxIv6khQk4506DtzCEKBen9BP+4P0M7Z5+ZN7kZov046ePVJpARXTVMORo0I+OIRq7yaxSwVIriuFrJVahTlAawsWQMc6Iv5i9OeY47p/5H8sz6N5BdqAr2j1cZHYrB8dgc06SNnLsO23i7zWzXDoNqF561/Vy831jcgSR3yDNqJArgDtj/oZBadigOxx7ZOM
 XjORCCSG
 iTNc0PoEL5o6Njz2IaaOiBsBVBBSQJNzZmhqc/Rw0chBFBxVMjlE1lsIEOGbR+hX2RpibjD+d0Bx8l9fdPnFYgnoWHUKAbhBMpXLbxIuxZLFVX+ahTJ6WIZa1z+sabMe0kmRYm7rFp0tjGIiZn+HQkBtaDtKkb3BPMVVQtauB6yDnDD36Kyy24dtEcdE8dhcbrisdbaOD00SdNxsePrKkE+GsdcTYxuipQzIXxFbF9ac/wpCs0kSnsR2cPin632EFSNb848abRKOIgVxLh/zfcMzmVygvHr+9Fs417MpfZ4DIaxjK7T85sm7tsv60ZwCYwoUJSP8QIJTZVsRTu/DrHRexiQIE9XDzmqbCxnjCgD145wQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 10:35 AM, Marco Elver wrote:
> That being said, I don't think it's wrong to write e.g.:
> 
> 	spin_lock(&updater_lock);
> 	__acquire_shared(ssp);
> 	...
> 	// writes happen through rcu_assign_pointer()
> 	// reads can happen through srcu_dereference_check()
> 	...
> 	__release_shared(ssp);
> 	spin_unlock(&updater_lock);
> 
> , given holding the updater lock implies reader access.
> 
> And given the analysis is opt-in (CONTEXT_ANALYSIS := y), I think
> it's a manageable problem.

I'd like to make context-analysis mandatory for the entire kernel tree.

> If you have a different idea how we can solve this, please let us know.
> 
> One final note, usage of srcu_dereference_check() is rare enough:
> 
> 	arch/x86/kvm/hyperv.c:	irq_rt = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
> 	arch/x86/kvm/x86.c:	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
> 	arch/x86/kvm/x86.c:	kfree(srcu_dereference_check(kvm->arch.pmu_event_filter, &kvm->srcu, 1));
> 	drivers/gpio/gpiolib.c:	label = srcu_dereference_check(desc->label, &desc->gdev->desc_srcu,
> 	drivers/hv/mshv_irq.c:	girq_tbl = srcu_dereference_check(partition->pt_girq_tbl,
> 	drivers/hwtracing/stm/core.c:	link = srcu_dereference_check(src->link, &stm_source_srcu, 1);
> 	drivers/infiniband/hw/hfi1/user_sdma.c:	pq = srcu_dereference_check(fd->pq, &fd->pq_srcu,
> 	fs/quota/dquot.c:			struct dquot *dquot = srcu_dereference_check(
> 	fs/quota/dquot.c:				struct dquot *dquot = srcu_dereference_check(
> 	fs/quota/dquot.c:		put[cnt] = srcu_dereference_check(dquots[cnt], &dquot_srcu,
> 	fs/quota/dquot.c:		transfer_from[cnt] = srcu_dereference_check(dquots[cnt],
> 	include/linux/kvm_host.h:	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
> 	virt/kvm/irqchip.c:	irq_rt = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
> 
> , that I think it's easy enough to annotate these places with the above
> suggestions in case you're trying out global enablement.

Has it ever been considered to add support in the clang compiler for a
variant of __must_hold() that expresses that one of two capabilities
must be held by the caller? I think that would remove the need to
annotate SRCU update-side code with __acquire_shared(ssp) and
__release_shared(ssp).

Thanks,

Bart.

