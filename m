Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF47CDC19C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E2A6B0095; Tue,  6 Jan 2026 08:22:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2FC6B0096; Tue,  6 Jan 2026 08:22:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C9F6B0098; Tue,  6 Jan 2026 08:22:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E250D6B0095
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:22:53 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFA33B9F23
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:22:53 +0000 (UTC)
X-FDA: 84301604226.28.E06BF69
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	by imf23.hostedemail.com (Postfix) with ESMTP id E204214000F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:22:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of penguin-kernel@I-love.SAKURA.ne.jp designates 202.181.97.72 as permitted sender) smtp.mailfrom=penguin-kernel@I-love.SAKURA.ne.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767705772; a=rsa-sha256;
	cv=none;
	b=yMwoIC+YJq3Ns1DAiZ5OxDLKRMp2KXOHrgEZ1uA5SrfVy6jGwaO3WbdsvZYz0dcXH96qOv
	wAEo7LApV/ANqNlRBox3sghvZ63GVfyb+9SipMMXEqMDgQHc0BVl1ezwgjEyJihnGdrDMx
	zn9tw5kIQvMwyZjSUCAgsBKthIRs6Gw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of penguin-kernel@I-love.SAKURA.ne.jp designates 202.181.97.72 as permitted sender) smtp.mailfrom=penguin-kernel@I-love.SAKURA.ne.jp;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767705772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0/XcQ4MyKbdRtIFVSuEfvR9IygVIY0KqI25WDHpKpc=;
	b=BHWzMhmC9DiWebZZHPyExa3e956IzWt40sRU+k4SyyAG8TjJBHgHpbenbpcyZ5OGndz85P
	Yj/F5ychmjiHwpSczJ7UVyXrngGhGc81wKz6S1ezI5xdxv0OR3OU4qhA8xVWCa6kr0TINB
	0arqfWpyd0UeBG+M/E1zvbKlJMR5JHk=
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 606DLekF006168;
	Tue, 6 Jan 2026 22:21:40 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 606DLdft006165
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 22:21:39 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <993d381a-c24e-41d2-a0be-c1b0b5d8cbe9@I-love.SAKURA.ne.jp>
Date: Tue, 6 Jan 2026 22:21:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/36] cleanup: Basic compatibility with context
 analysis
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>,
        Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
        Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Justin Stitt
 <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Mark Rutland
 <mark.rutland@arm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
        Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
        kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
        linux-wireless@vger.kernel.org, llvm@lists.linux.dev,
        rcu@vger.kernel.org
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-7-elver@google.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20251219154418.3592607-7-elver@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Anti-Virus-Server: fsav101.rs.sakura.ne.jp
X-Virus-Status: clean
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E204214000F
X-Stat-Signature: xpwtmdpwk6azb4nzddxqc6nzjfdgo7my
X-Rspam-User: 
X-HE-Tag: 1767705770-287992
X-HE-Meta: U2FsdGVkX189UbD8U6RdLKUqNoihK8aMiCKghl64QF+EZlilVjfqsGLQ9ux8l8Q/jEB3KxaehkTGKy3JQJ0zxKkf15nRz1Z3vP4ScWWT7c+HLxLDYEJwTxO73rMV6o1huUi/M06CL89G/PPuEC6bkVf4aV8qoavXFST/CXJWlJAYJy+/lVT1pL0lVJTDpVe3GEdDOqn2ErCV8CKaJNRF4q8RL/YXGKBp+vYN1ndyd7xSuL5uqHiTllxdNkUmx9+PFIn3hPZxGkKH1jmDj5hM3LiQtuKH7B1TCh1my+9iYfeeTrA3TfX2WrJnf1zlNEJ6pz1sgWRW+YW3QVGucBzMGmjJ3aDws9jnS9Rp8NCntsN7utQVkN9hNNZ5pNdoRnFW2rppM3UEWWTt1ruDw+1J0CEEyc5VBlZV9ADRzJa8TOer/2kvvMIy8WJYJbyqBC/8aNfyYYp5+BASXOeVpbofbcbjTUvhuI2Jm1neO6AUb++PAYsNql9C27C2VUr/Xm0/RcWfmZUxWKOgu+crayvSJHMD75JpXHosRy5YtVW95ttLY1eaDm16/vn7GhWSGGmNWR+CNKv/nccwmv97EQqeNU6hTwwSQz6jTeK6CpS4GW/3JmwRYOrLbyK+TNXHt1rj6VbffvFeaq0xzJ30qUBH8LlYDomgX4ojjsQM7ml7wcnPEE2d9ZZGrjYfvzqinZlm0XpwWdaMCrmlqo4wKkrUdZF6r7OQCC8kiRUHV7Tbky4YXttoy0VAy/2vwvKwO2JWH+FlxS/UCsIBEmylGZqScw21Q2W94fhHtLlV4fQ9JZosi+Ks2H6hWqAzM/S+4w6eAq6z01kJzGRoyLCS4EiOwqmN96os6xbQxTz1ieIiPtuzzxTeyXJX9dVI61NQbrIgUeEFbp3delWbDIwNAzLQNEms4jzE25ALAwmDoGb3nurRV+8Ij2XtXC2v8cC+sM6sEvSUh6FF6FJXm4FF9y4
 GuSPbf0N
 aeX56rbvNSu+5nswtmdLaz2lms0RWxi9rWN0ObiuGMPvt+ey9f9dg2M92sdTPH8ZTZrVELgrsy07QfhNs+X2zjB/vZHxp6VZlqRFk75F2QQU5QspvjP94O599Ew5Px0KBYmaOHmB7nM85DfBn5v85SMq6Qp5Q/uWVr1Gt3SnDHRhxYFcQKO9CjeGiIy6WQTohKaiCbLN6Gt1CoNppguDtWeQQ/V+BgbLOuylUW4oAs/A+Q3VU49R50cYWoIIx+3gOLcI7OP+kdyCUTouRbDXJ6UlY6Qc8LWC7G5uJvECAGPnm+kaS0L1yIdb1DS0eQ0czZcQK2QPnYl0idODyKEZSc3xUFqNHTElc57Okk0kWm8dhVmc+2OZ5fAgkXb9GmmGEpbricldKDppYWRgO7iiK4S+O0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/20 0:39, Marco Elver wrote:
> Introduce basic compatibility with cleanup.h infrastructure.

Can Compiler-Based Context- and Locking-Analysis work with conditional guards
(unlock only if lock succeeded) ?

I consider that replacing mutex_lock() with mutex_lock_killable() helps reducing
frequency of hung tasks under heavy load where many processes are preempted waiting
for the same mutex to become available (e.g.
https://syzkaller.appspot.com/bug?extid=8f41dccfb6c03cc36fd6 ).

But e.g. commit f49573f2f53e ("tty: use lock guard()s in tty_io") already replaced
plain mutex_lock()/mutex_unlock() with plain guard(mutex). If I propose a patch for
replacing mutex_lock() with mutex_lock_killable(), can I use conditional guards?
(Would be yes if Compiler-Based Context- and Locking-Analysis can work, would be no
 if Compiler-Based Context- and Locking-Analysis cannot work) ?


