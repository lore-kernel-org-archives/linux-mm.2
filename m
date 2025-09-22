Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1357BCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58EF38E0005; Mon, 22 Sep 2025 13:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566B38E0001; Mon, 22 Sep 2025 13:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2CA8E0005; Mon, 22 Sep 2025 13:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3578E8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:11:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C03205678B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:11:47 +0000 (UTC)
X-FDA: 83917528254.23.9A11148
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf01.hostedemail.com (Postfix) with ESMTP id AFB034000E
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:11:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758561106; a=rsa-sha256;
	cv=none;
	b=Lbz/TUVABp7xXS9Zfk9vNjdb7CsP0pXrkw1UhiTo3I4IGnjjABoH91kJkjdeQuPmCZhlQR
	WNyxFscpAf1DrdppF9AOyiDSe5/MsJ9fdGtd0DXorFP4IdefccfNCG8j/5mdjjsiVfargf
	hyC2YDcOaV9wJ69Z799jj/+F9jXLavA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf01.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758561106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AzW1D6cu4bgVFbuNUR4Gt+p4oEdRJ1ELKVbXdnqrKQk=;
	b=mknTzX8BiNoRawZGbQIpuoBxESrCc0VeBY4I/TcI5/q5HuWIlIgGibkVQznheHuLTcb8Ry
	r68TLXJvMEJv0gA51908LfyIh82ErDzMiXqoYIikyosRPFgEIJDPURwS79qXS11tOXykkf
	dXjhfNtWz29KjT9/I7ME/6US/6gws3w=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 11211227AAF; Mon, 22 Sep 2025 19:11:37 +0200 (CEST)
Date: Mon, 22 Sep 2025 19:11:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Marco Elver <elver@google.com>
Cc: Christoph Hellwig <hch@lst.de>, Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
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
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and
 Locking-Analysis
Message-ID: <20250922171136.GA12668@lst.de>
References: <20250918140451.1289454-1-elver@google.com> <20250918141511.GA30263@lst.de> <20250918174555.GA3366400@ax162> <20250919140803.GA23745@lst.de> <20250919140954.GA24160@lst.de> <aNEX46WJh2IWhVUc@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNEX46WJh2IWhVUc@elver.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFB034000E
X-Stat-Signature: e8fpe6taoqzpzqy54fycxhxmt3sczs95
X-Rspam-User: 
X-HE-Tag: 1758561105-134040
X-HE-Meta: U2FsdGVkX1+QVazGfq/kSe9/Eb7uIP2VL8RF+k1c+CFF450HSarmEtQE+bhEh2ntW5tWgoB+1O1hN3xtr+ZNiap4w/3FFnh2NAMIeuKljaIY/3Ed+vB+g3ghuJiLyDswYtBp1C4PyGFHtBSkkf+uTJWC7CBEQ7j16SGU4prqOqClJJtfgcyWr8oLgdEeaDZXmbuM41Vz6HFtSGgc9lLo9VZh3h0WrzG15yqXSPzQ2wDIjKlBO3VwfY6DRrOtagvbl3/Bnamji4qAoBIexOlquAflaLyJ5udDERk8ooa0gWC8Xx3kRB2pK3r7bSz/UvqqKBAi9CIM17RdNxioF/Ve6C3ipvt3IM0hFXhKD9qgZY6lnOvoqeeE4I+oMY3ZNwSankebEI6Q0TlIvDQGrl7oUfWtck+9VJtuuJ/X+kCTpy34MzrdYea6OWCowwcu5DmHSvx4LL6dFJpeLR5PMJhFXd98sO4xiKS495/CHVK8Ng5difQDQCw8I1ThaIkUjZSxIStEQ1e076UlIIS0pHeL92yAR2jVkvIs3wYkNCBFH9yM5+JPOeGu4DEK+7FMPcfFJGBMf+puNgbTE6YnSKhdCRMaZGqci7qJ814U6+qelVkMi29SvhRwUv7+WsGNskmIYBYpJ+tEr27wkiEYcG1sH19FRdXZpEKduE5BVZ7W6cj7RzIbg0l2PrBiqSWTI14Bx/qYS61IPoqbs4h4m3mi0MYOZDLQIX80N4VrijKHnbBCeWPwSIQgjghq9i9jQCGEwCq78zRiHDB/AgVKpD5xYrHDg3TeCZFjafsAukFaqzMb1F5013g3u+UncMVqr3poCblCqQ+zmeHaworQrY9oQ98f4MkxbJYlIFpphld9na5QPJLwt6kblAK7ac4gbERYy0lM+b+WYYO0CdI7Hvq4X2NYxXed2pq3bo4+z+t+dqIhvJH8e2VEKaGsnAzvJKZ4rxt/C1hP4NZ7aua9kgR
 b6g4ZnnC
 tZL0ONpU760Y1xTADxmdcGcvMRNDIf9QI23C3RCM6P9tXe0eYAuYtHzG09Mxrs1UnRrGVr+7oMy3v1YsN5tB9yqSavlYnqxuFsRn5MUuFIEw+sxLh6XR5ERpEsRfpItceHaRgfw5Cfx6TPtpsWn7CS076Tfv64dMpXK41FvQbw76zQG6E4od9fyOPfqj3qi5BV9e8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 11:33:23AM +0200, Marco Elver wrote:
> I gave this a try, and with the below patch and the Clang fix [1],
> fs/xfs compiles cleanly. I think the fundamental limitation are the
> conditional locking wrappers. I suspect it's possible to do better than
> disabling the analysis here, by overapproximating the lock set taken
> (like you did elsewhere), so that at least the callers are checked, but
> when I tried it showed lots of callers need annotating as well, so I
> gave up at that point. Still, it might be better than no checking at
> all.

I guess this at least allows us to work with the analysis, even if it 
drops coverage for one of the most important locks.  I guess you also
have CONFIG_XFS_QUOTA disabled as that would lead to similar warnings,
and also currently has the lock the object on return if it's not a
NULL return case?  I now have a local series to remove that instance,
but I've seen that pattern elsewhere in the kernel code.

Besides the conditional locking these two also do another thing that
is nasty to the analysis, the locked state can be attached to a
transaction and unlocked at transaction commit.  Not sure how to best
model that.

> [1] https://github.com/llvm/llvm-project/pull/159921

Thanks for all the work!


