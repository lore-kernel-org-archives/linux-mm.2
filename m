Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA663E66892
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0316B00A0; Fri, 19 Dec 2025 16:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E7F6B00A2; Fri, 19 Dec 2025 16:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1903F6B00A4; Fri, 19 Dec 2025 16:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1686B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:01:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04B711A0329
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:01:50 +0000 (UTC)
X-FDA: 84237442422.23.53DC38A
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	by imf28.hostedemail.com (Postfix) with ESMTP id F33F9C0007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:01:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=s9OJBwkd;
	spf=pass (imf28.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766178109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KjTqulqtSqtlYJ8kiScMrzEzgfg45JI8uubNScSnWY=;
	b=EhIcaGCbyQ4oe1Ul2l096MQWMHZp9A7SQu9GkWEy2HYhoavPOlS2lEKN+Jy07IZUCmRcyX
	d+UrSPNE0Po7rRIigg8BQ/y+yW+U6aETIA2gJTzAFARUkekH+U2FXnDNVm69NNUJVKG6Re
	xuKpw06oqqZun+EsGwmVEL1ZoFUJzPY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766178109; a=rsa-sha256;
	cv=none;
	b=CiKy8Emc2oFDmX5adU6WagEfg0/p42khpEZlhM2qpyYVQqwNBXoIZ746hfaEg7xx0hbspe
	oQt9bbK5mDs3hkOp53XdUnBDdXKfj4HVvyMeAw1a0MusI1D/ykYpsrXc/TlEESInNviLAq
	1dMpwPUnuFUSF05DTo+D/Oc6+1yiCJ8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=s9OJBwkd;
	spf=pass (imf28.hostedemail.com: domain of bvanassche@acm.org designates 199.89.1.16 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dY0Mb6PP5zlxr5f;
	Fri, 19 Dec 2025 21:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766178100; x=1768770101; bh=9KjTqulqtSqtlYJ8kiScMrzE
	zgfg45JI8uubNScSnWY=; b=s9OJBwkdhoRjw1wT9W38EQGW90jCfITJQ4Dj5Ydm
	WkQeHjsl/TckZ0nDw8xfVOYGZw5litIkS9f3OXuZwzO3hTtugFky8jXGfceKpZDV
	U1wEoqDkAkOMwveLyjPBCCVL2v2gxTQ7x/fhl18iwptJc48fGOosD/Ijsbi7r/ca
	rtNB5lMYdEKIxVGwaqn1+m/eMvK94sr4xGOge9D31/73d4nxhOva8PPSQvnMQRHF
	+dGUczfKiOfUUVvzbKqIDczdov8eJDoRYazYFGQ2jKTEyiBdQxt7MumMuAFABlVU
	GcwDY+4yUv4P2PoxCQif8fbXLJcwS0c/QHyFDMfcdKDinA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IXqnKxjTN97r; Fri, 19 Dec 2025 21:01:40 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dY0Ly622Wzlxr5b;
	Fri, 19 Dec 2025 21:01:13 +0000 (UTC)
Message-ID: <a62c731f-7ff5-48a0-8700-b62cd163f369@acm.org>
Date: Fri, 19 Dec 2025 13:01:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 21/36] debugfs: Make debugfs_cancellation a context
 lock struct
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
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
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-22-elver@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251219154418.3592607-22-elver@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: et7k6fj7xmw8jhx4axaa4gwjdfgrot9p
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F33F9C0007
X-Rspam-User: 
X-HE-Tag: 1766178108-401532
X-HE-Meta: U2FsdGVkX18Uaw/7bSwG8XttyFqesvOMLsBOFDekAA3d4KGC8xJT8XgExLjzFSTDDvV/noDMCxxy1gKs55FvOfYL9ZVHVnd8TaU7NniTwWSJFjwzdmn5yaeDACRB76uIyov6Sxa+vKk5cRd1fYJx1vE5z1lqrcowvornLqxFm6LhCeIvtmkeD8Cd77skroekB1ozOHeJwQc+5SMLL+W9QCdc7keyF4EtaZbo/NIJQx1Nra0VWkkt7Re6m+KltsjSdr1eZHmsYq1aj8+w9VO/6KzVzDtyUVDu/dykp2MIIh9TviFTWX2D9F4iOGc+NWph1KHY0TGmffFYRDheUapyNSNq1132myDe91drUxOg00I6qijKEe/NY4ojZDoVgVR1/dYmm22sTm82KurmvU6SVIpx0s9m2fyok1LhHhSDa5/27Wnz6fIpEG+2TdWESkHQD9k5UxuQHqBSnP0GeXkcyFw3YUFcJb1QiTVxD0DEY9KTgS9fkqEHq9KHO0Eodpy2MOwHw7xbEeYdA/+j/MG5J3nvglmaQOWJi5j3e1xAa8THLVo3Fr6WsXZvdRlc0lQkHC9MPng1yY2zrgEV4KGP6jQQ8BuB6TF37B5DF+JKqwViGfh+vejbz9kCui3WcN4ADv5Pdt+qe7S3Lck4jpoVZze7mNx8Tv/nTOMKDJLEJZMdON9sza2jb5yPmpW8iVBb+kAG7v0L1uaI3bLCTIMIjQhDhlvwiJDa5Ws+197vFEgncYvuBtrgDzScAuTUKUB/FwkV2G2iDBfAK9fQcgtAVQYmLABjQcL9KJSY331rKloUK10TQhyWnfFLRH/AvPS9O0oNYsQFzg9tQf6cK8d4Nnj9kmEC/Ila/KWj1QRzNaSx3ojhfRkCqKxWohQbsYmpMVMYthDJwFgd7Suk95XuNY8h+ZQJJqvHW5/agRmnOZs6nYcu937nCJy+ppMxpiYE95Y9/GuLmvf5b36wyqa
 5ioOs3Av
 W7P9KerEm6dt3lfwx1ap32+Z67NmNdS2+fJmpt8JtXFuAkXoDdbR4jI/xDsM/StSnXQRHOozh9kJvo5wHvBKkB0NyrQHwZAA5rSFIE48fKKRmIOnfnSil4WTzGLZi/sewWlLFS3de1cH7wH2OhEnWX2Pd4iLXSpubOdI/L2Z9u4cE4vQRTpJj9dDrzXNoXFXzp5iBieyhSaQUjhdi9fHX/sCWZyFMPqa1JPIldwbXpa4qefc22jrGLjLCXdbnmr9KPJIDSOPBRWXcP/EXnl3S5yo9fOjdSA4V0ajM5cXr92P3IuxHpBdWqDwTp6wY8G55yeQkq0j9VuPAUfjbSDc01ONC0fe9GSOK56uzvfiq/HSfN3r4EhZpllV4gLmg3ApibVyQHIa4B11wk8QXeW/dQU+abNpA9P+/rrEXXYkMYOQeRRTN6I69lhnHMuIjCxnSQkL+jW4gw4YbCpo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 7:40 AM, Marco Elver wrote:
> When compiling include/linux/debugfs.h with CONTEXT_ANALYSIS enabled, we
> can see this error:
> 
> ./include/linux/debugfs.h:239:17: error: use of undeclared identifier 'cancellation'
>    239 | void __acquires(cancellation)
> 
> Move the __acquires(..) attribute after the declaration, so that the
> compiler can see the cancellation function argument, as well as making
> struct debugfs_cancellation a real context lock to benefit from Clang's
> context analysis.
> 
> This change is a preparatory change to allow enabling context analysis
> in subsystems that include the above header.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

