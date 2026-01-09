Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 891E6D232E4
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 06:02:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E876B0088; Fri,  9 Jan 2026 01:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F034D6B0089; Fri,  9 Jan 2026 01:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34CA6B008A; Fri,  9 Jan 2026 01:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2DD96B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 01:02:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADBCC1AADBF
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:02:58 +0000 (UTC)
X-FDA: 84311382036.20.173204E
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf03.hostedemail.com (Postfix) with ESMTP id C200A2000D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 06:02:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767938577; a=rsa-sha256;
	cv=none;
	b=Ucb6FAKs/bly/sWkB7EENKyjdJK+hD6MNCXu8gnh0hwhxpJ+Jk1tVKCy72mtnqUq5I2i72
	DxvEXdbhhjz81wwnDO/K/Ps2T9XIVZQcg3O20tyHkbI7qWc1YuMx07dnBNUm2UFXn07dm/
	AbhyEaKTsA55tw+ektG9wvzFCyNgjHc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767938577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQfXs8VjntxqHKn2pUykiLAuOBoS2lNpJ5R6Oq6f6/M=;
	b=ejQnaSLLhmdizswHXBZ5myUd+ZsVdFdp80omZceOOtnaJ8bbYE808e0q25KpACmTaQ/FFQ
	5IgpZrr9UG/ZjdGyi9jwR/OGYi8QdK8cI2eJ1r27j3XpUk51BkhpXNMkUTG9pIbSulEb2I
	t5PEvvhUkjIzMinqgwrl0++WA/OM1YU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5106967373; Fri,  9 Jan 2026 07:02:49 +0100 (CET)
Date: Fri, 9 Jan 2026 07:02:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: Marco Elver <elver@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
	Dmitry Vyukov <dvyukov@google.com>,
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
Subject: Re: [PATCH v5 10/36] locking/mutex: Support Clang's context
 analysis
Message-ID: <20260109060249.GA5259@lst.de>
References: <20251219154418.3592607-1-elver@google.com> <20251219154418.3592607-11-elver@google.com> <57062131-e79e-42c2-aa0b-8f931cb8cac2@acm.org> <aWA9P3_oI7JFTdkC@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWA9P3_oI7JFTdkC@elver.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C200A2000D
X-Stat-Signature: xohsm6oob7dr7uqi8expg4ca6kf3sxig
X-Rspam-User: 
X-HE-Tag: 1767938576-472024
X-HE-Meta: U2FsdGVkX185M/RYdyv/Hsj/VxVwv5zb7+ylVnFFRibdqKjcnIV4QzUTeGLNyRuO9p/QHXcnYJjwpwqih/v+TNIw0Yq/0DFAPkX7LoNyQpJcnxXHRTbZ5eA/Z3A+zILDDHGKu8DPAziDDrjVn6Qr/tvg5REoUUe0KQ9JaNygxhP45DD7+icu5UQJIsnM7zWjPbd19pRNo5ciRELD/uA3uV6kZhcpL8E9mDQeRq7ZkY+G1+Y9u7omOSJR2EUhxepeQ5+8182+CRca+wnka8H5AwDJ+L2XQ6SJhHmL0J4ERs8CVSZkQaj914t4L6RDf0Jr0EkA3Y8pYSJ3u8ny318xe6wiEyeD++oz7aHRIsZ+JN+JcItF9DuynTRmEYyRyo1tYcq4ey5SowbKbwP6YNpxTIKBxoxQ2EduuRms5sbaKFnwxO7E2bhUcmHkNT+0+PYul8mgNcjFwY7NzbVKpZ+OX8ZT7Q2gQZ4+B6ZG3Bdc2aBf889cVAi13Rw17bkbnr7FPexszD2pHkUgoosr8Cvcraj8l5YO3BXgEeGwHwScilhGIuMD792ciGiguB4LeKwuQ8/Grfy6O9heN/yfJXee+m/A890Xft4JDjsObZRYRywkEwuXP8Ooyx2byO5Glfb0FB+uyBIasIfnUdQ8RcHfPCm1cxIrjMcLSjta57MNNw2n3KE3zWrzz7ogEGBCiZMDSLnpfYvKZhkExhdv2Wba2mulP76+NeRjxdcK43guiWRw7X9NW528QV+Jy0sHRcDAVxgej+czk+a6cbIfKqoMjS6LbzdAtN116LQahgNHzqNKbcMwrjGr6hYQcX24odtBF+EHmQWw8iT14n3lsItR1YIrt2HnpTUTLTdF7qfWVBCQBD7u5wI85q9/w4e2+7cNmdGFvIXlylOyFjLzFdlBvqJPLBFBchKAKeTPbr1WJ0KrRavp1UjJXbXj91jF0c45CPiSvhQt/7dcxIINy97
 NfFLsbOe
 8LIKUYmDmTGg3hRkVfuGx5uWwV4FoN5Nm+sGrvoLrNjSKb2RIv+fEEQh6VjINCuEI1zpBuY5yCCjN2MNJz2OkI43HX0FPj6uzAseOOnZgozRfWEXRMtAUH8YAIAulOXbXUQGDTfnHlmLrZcqgnZxNUGD3xfjcIv6A1Nn14NagvDs9QedBmwTn2g6v5lthf6DPmlZ4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 12:26:55AM +0100, Marco Elver wrote:
> Probably the most idiomatic option is to just factor out construction.
> Clearly separating complex object construction from use also helps
> readability regardless, esp. where concurrency is involved. We could
> document such advice somewhere.

Initializing and locking a mutex (or spinlock, or other primitive) is a
not too unusual pattern, often used when inserting an object into a
hash table or other lookup data structure.  So supporting it without
creating pointless wrapper functions would be really useful.  One thing
that would be nice to have and probably help here is to have lock
initializers that create the lock in a held state.


