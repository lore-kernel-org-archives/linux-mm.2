Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE13CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 17:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 341C48E0007; Fri, 19 Sep 2025 13:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3197B8E0002; Fri, 19 Sep 2025 13:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256698E0007; Fri, 19 Sep 2025 13:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15D838E0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:21:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B27B8C0706
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:21:29 +0000 (UTC)
X-FDA: 83906666298.11.C190486
Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	by imf30.hostedemail.com (Postfix) with ESMTP id CA30D80012
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:21:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="L8/5f0d8";
	spf=pass (imf30.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758302488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlBMZtQYmssvvNlMdIFNyVIKCykDzp91ay9FSX4ijvY=;
	b=gAkJq8O2JX0sZD+ZRpbRKVGb5KjP+9WTBR1EFU+7CdRK7TmjD0zrivWjP73EazzPYz5ysA
	l9V+opf7TXriWfBXjb5blpqhgb9sD8xvgWetguR8xTUoUQ/8V4r4t2GM1i8jTpcuYPP3S6
	jI5qsvuBJnPM4K8fwdt4BDU4B2FeK4o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b="L8/5f0d8";
	spf=pass (imf30.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.6 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758302488; a=rsa-sha256;
	cv=none;
	b=pN/r64Lxh8VVcOzLNM7jFt8EL4ZEWQJ6LOt/P6s4kFspcFo2W9PGQW9zUhGN8ayDddkZPP
	LN3rKb/GHWHXfi6i2oTAWiuPgf8WgnS+flPZLq2OyGz9wDRCUbM/0MoRRqesq+2XlGGIE+
	RZvBzJo12FHtt/xs3oBTtCylpJKyc2Y=
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cSznL5LKTzlgqVk;
	Fri, 19 Sep 2025 17:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758302479; x=1760894480; bh=KlBMZtQYmssvvNlMdIFNyVIK
	CykDzp91ay9FSX4ijvY=; b=L8/5f0d8/kPyXoJ7DoiyeGUMePzHeJ+yVVI7oEG7
	Y/g8nB7VZYf4pFB/HQcbU/WwOQ2kjYtYvAhsnrLL0quWX4GMl7aH01WO641cHC/M
	raSDU+8jQepUsqDl4DUTQF8dqtrahKmiJGLWao6jTYvwwlimGXdXMzTsblCck8Ol
	NvqBph9rN6BI19OaJVWn4FT33f19effNIdudp6goRn7YKrbmHqM/4d8zunz/tWEG
	UIL7ER/Wq2UJWgV6cMKzIZC7kqgMp0Y3EbzWN7cmkfJ4gcT1npp8XTK/9ii53vdh
	99kxBiXmt1tlBKTOOth6OWvTsiMhLf/YOO7XCKUtlMWxxQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id OCIV4NH48gVh; Fri, 19 Sep 2025 17:21:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cSzmX4zj3zlgqW0;
	Fri, 19 Sep 2025 17:20:43 +0000 (UTC)
Message-ID: <a75f7b70-2b72-4bb0-a940-52835f290502@acm.org>
Date: Fri, 19 Sep 2025 10:20:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
To: Christoph Hellwig <hch@lst.de>, Nathan Chancellor <nathan@kernel.org>
Cc: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
 Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Bill Wendling <morbo@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Dumazet <edumazet@google.com>, Frederic Weisbecker
 <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>,
 Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>,
 Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland
 <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Miguel Ojeda <ojeda@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
 Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>,
 kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org,
 llvm@lists.linux.dev, rcu@vger.kernel.org
References: <20250918140451.1289454-1-elver@google.com>
 <20250918141511.GA30263@lst.de> <20250918174555.GA3366400@ax162>
 <20250919140803.GA23745@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250919140803.GA23745@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA30D80012
X-Stat-Signature: 3kiyd8kqgbe86zciur4bwot7xebfq9sk
X-HE-Tag: 1758302487-186304
X-HE-Meta: U2FsdGVkX18Tf9LuIpNGK9lLtgK9OArz1avEKuicK43F9ONVKwbKZs7hHKPseho/aCp0fo2yM81+xHMNBBw445VMvCF9BVNCXfyjotQUKnszMrqWxvlZhV/aPRU4h1es/KLNMET8oIAgkWptNRpw5pZlCne2RxCF3UguS/qsajjLTMrnooaf31P6pY+METmgP36Y09yWWjNUVZ/9jgs5CCJPyFrYFlRmarpWzXr1IYtuUFrcn2/cDI84iUCce7Cg3ZyotcCIzwlFaP9d/iiPWtW6K0JfSMWlcDHEmuwJO/kAymJXhnoj3zTg3Waibs+i6bExJHywePtdKIbC4MDSiWKuEtXuPGf5LFWVzb0SaZmPIjIhbpaxm1ss3RdJMo4TGR1XqqbdQwTkCIyg3SLiH6Wy0WVBeV38GjcHHcjj4e5POrVI/R0q36DLr+cRTvzYATXbKDrcLhpzTZ0U0aToSRdP7B9Et+im7Qzj0WzjShDlvIpm9N9NsvdywAca2iQuVzVWkNBqMnKt3a6H3OY8ZT6/m2CGBDnOgaUa/MYURUwQsRbEB3GdvHfZ5fyXFMPdqOJij7TTuFZzkg+MvJn0tsa2z3gXWDJK69JOPPkTvciDrOfJNQ7g/lDIVrZEs3WaqL91EZ6U6Dgsie6zPE/EOpIpu75w5z3I9aDQT8WC2XBRp14NfeGTlb3ihPSah9Vo6K7WGlyKA6KBAqpVGuVmjGGFeWVtB1wCok/986QQ0fLDtf/qjqKJWsVOLk4+PAYY5lD6g73eAmnPZWx5N61lHZWgAqGBnkwX7D1TiI1u+zkNS9jhSfykVFUP4YANzcANB5MA+MFRWu+37f5sRct34dOMHERDlNMNRCL/oGjRg/JGT+opKcromVyXbkb7VYmCv1/HlS7BlufsUaCCmY38GKlqkqR49nv7y5IR3eHHA+rnkrNurTyOof7K1sqRs5NheIJt1BJG6Kzk2fXuMGo
 Q8p1ReTS
 a51mct1e+o18h6IqYg5xT964RWJybmwf6Ah5mKDN6cIzYLnbzqrNXCqhk/vzTSxGF77Cks7GshUyFI6yJsOdDRSXXl9Wq3FRnhVvstB7R2WDpDQJbGFQia5AjD3U4WWzHLcf5qfx4NZ3jvH+CkkbvnlOG+AMnAPdcU4ZtKHzlmy7Np6pmxJuQgeIvkeEnDUhW/cS4LZURTgd42Uz5AL2kWO2FaXkqDqEvZelgw2NLwj9QUJ3tTjil5XhhEmiIFjon9ixqZxbRKVcVNDU3j9zDV5BtdtoNvTTPL9rNsrgSWvtYbq9kRyIVWsVfjdCP2w66kiC0q8Lm3snuiD+1ztpyMgTZ28ZyKKvyc9/x1AKSD+5sXE8XpSkzjm6gpIE+YlLFfhHKJOpn/JpaV73ZN3WvF96jPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/25 7:08 AM, Christoph Hellwig wrote:
> 3) Wrappers that take multiple locks conditionally
> 
> We have helpers that take different locks in the same object based on the
> arguments like xfs_ilock() or those that take the same lock and a variable
> number of objects like xfs_dqlockn based on input and sorting.  The
> first are just historic and we might want to kill them, but the
> sorting of objects to acquire locks in order thing is a pattern in
> various places including the VFS, so we'll need some way to annotate it.

Hi Christoph,

As you probably remember some time ago I took a look myself at adding
locking annotations to kernel code. I ended up annotating multiple XFS
functions with NO_THREAD_SAFETY_ANALYSIS. Maybe the locking patterns in
XFS are too complex for compile-time analysis? See also the XFS changes
in 
https://lore.kernel.org/lkml/20250206175114.1974171-33-bvanassche@acm.org/.

Thanks,

Bart.

