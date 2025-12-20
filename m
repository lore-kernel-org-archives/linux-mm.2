Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B1E3E668B4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 13:33:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99AC56B0088; Sat, 20 Dec 2025 08:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973B06B0089; Sat, 20 Dec 2025 08:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA196B008A; Sat, 20 Dec 2025 08:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 799E86B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 08:33:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F01459931
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 13:33:35 +0000 (UTC)
X-FDA: 84239941590.30.16C9589
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id C8BF31A0015
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 13:33:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JRF85bcV;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766237613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sd8MF34DcKU450XHBOHX76rfibz+4ayylz6CA0Z+S7s=;
	b=ThVZ+6XA8zth9UDnDHL9gKbEkgSycrIR6nuneF9znPI8I4Kgm3UYn5VjSjBx99lklWjTya
	mCupyOCZs23qXanNi6+L4f2qg8V3ZsiK/eS4KbiJQqXok+ZY21CvCxGmCy7evLCm18md04
	mqp50YkRdOSFhEzw7844f5zJe34zHgI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=JRF85bcV;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766237613; a=rsa-sha256;
	cv=none;
	b=WNCLjeBpXwworWFWjXR84TMUO/xQELIQ37xKwJVf8jsnjxBq3Mfv3PbiBKdk9HLzuC3/3S
	tIPlxNPecgULcBs7pU5HIN6zGquu0bMPD/KzzsX6tMl6tuoKgEuCun1OjjGsNNeezQsStK
	4SrTucUyBRXhpvwpkzFvllayZHkbuJQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=sd8MF34DcKU450XHBOHX76rfibz+4ayylz6CA0Z+S7s=; b=JRF85bcVfuUAbdlqGNRlYDFj2X
	MBZkp9kK6+DWxZ52qXPI17aJHnxE/PD7M59fMz0XlJkLJw11Z17OWWZbt5mZH1ys+rOn3Z1KDVB6S
	pu4iTEanoYUavMKRG903o1dahMZ0gDpPnnVx7+/+hgxgbEKW50uF8kBQ4HY+A+nfVPf7NwCSjB9tQ
	XFVRPahMmUPfQxml3WuS3Qv3Gc4CPdqRroheFVCf5xskR0ix6PWdP9YZCg3meap4C/doiZ3x74vL0
	lUxDktQDZJqJIqf19QBR8eASqGGVYD+WDF8aIslzL0CNI572PyCVjjutiJoMAXmXAHHze0S35TE0X
	1Sb5xwug==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWwDb-0000000CS0m-1fEQ;
	Sat, 20 Dec 2025 12:37:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0441C30057E; Sat, 20 Dec 2025 14:33:07 +0100 (CET)
Date: Sat, 20 Dec 2025 14:33:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Marco Elver <elver@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v5 02/36] compiler-context-analysis: Add infrastructure
 for Context Analysis with Clang
Message-ID: <20251220133307.GR3707891@noisy.programming.kicks-ass.net>
References: <20251219154418.3592607-1-elver@google.com>
 <20251219154418.3592607-3-elver@google.com>
 <97e832b7-04a9-49cb-973a-bf9870c21c2f@acm.org>
 <CANpmjNM=4baTiSWGOiSWLfQV2YqMt6qkdV__uj+QtD4zAY8Weg@mail.gmail.com>
 <2f0c27eb-eca5-4a7f-8035-71c6b0c84e30@acm.org>
 <aUWjfxQ1fIZdxd-C@elver.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUWjfxQ1fIZdxd-C@elver.google.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 7589qy6rubsngj893u13ome9n1176iit
X-Rspam-User: 
X-Rspamd-Queue-Id: C8BF31A0015
X-HE-Tag: 1766237612-128033
X-HE-Meta: U2FsdGVkX1+kxIcp4K+h6+S7v6NHfrhhD/psrG5176krH3G7LpYxWk1zrJRcgB9ED7rlK76E+0HIC+YOdcJ1VnJmaiuXeZy/GdQZjIfLF6RpqiTx652A8gkEV0io6SvzJO5LglmL6mPCDrLjN+FNlLnhIvFMXvHgOaM8e0Ji36s3McHMlSkmbW6e5wP+Kdk3qpmp7yiHHO22Tc77DLO3bC6RwxEhtDexsy9eGo3hFo1COQ8a2Q3JynQyRdzGDhOW+IML4fysRbAO7ILq/spdljNxIQlRAr/EZMZG33JW4kTbd3GvPr0RKUhk3eOD1HHc6oB/CoYsImfaR6JdwBp+YIYlEtT29GoLlPG7o1UFmHjG/JFyfI/paz83r0UY4L6tDvog8BQbS7yrEPhlXgR3xzzJgnvvLVbg4koKcS5Zi/DnpJIoVigA5mrp+vFJp2ZB1c3MOE1M/hm+w0USBPQDk0FblSZ/pCd+7/Z/C2BbTSCZWD/Q5IaRzUOZ2WnjDC7eHh/iP76gXk3qr0sBXMot7xCM/BSHTlmtoBAmO/FlCPTy6nm6bmJBZglUwIK7vLovqvquUnr37o5kxvE9hoY/dO026ZkxA3WFN5XMrhpyiwC7b+qapjNrjU2w7PMJRfzM1sAVm6nJDjCY3lRIBdDH6ki2v44WljCUKwDZiZCUB3gDGY/tbmU/QFZd9cu3UgomMwLUF7r4pTavXVFHr8URN1Qbqoh4jN6SfuTEDYC20njpJtw1xFbhJe/W+wqDygZqx2LsaiWX0IJ8yix6a8DBMtBMPK+YpawGjgGSDmr6+BX4rozpQsRrqakU/Zpsicufrry2P9nMfxjxROMbrN2xN15+jdfLrZAsOH/JKsP1J2/kzAA4gjHMlWoW7PGIEnXymBZK5FRmmsh3R7yH9yRPmvzAkyFWdF62yfiV6vM1t0M93ROethFCUkGYarCTtv4EMJ3cYNYbk9sYpfnRSkD
 TJULvsRJ
 doJxFzifA/qX2g2aikzOYQ36ipNfCOsce3BqasWxVb4n44GS176dTi2lFdpbSvQTw7ieG/m+jdWT9mJIuahkZPV9lRhkrzaSt/A5DYNyA18CVGPISyXGtsKu1FNfGhVjnTbffayl+Gex8xSlYSt4zfqiAXIxYiCAD5jGDjpKPHTaPBc0eGHAT4XUDo4tUwk/P6a/bYBa9FaQKEQYHOCUdXCrpS9f9V1HxizFxLnD0qfiRFPHLyCJ2Y7ULyZ3fcVDmiAOxckAv2iCRXgGzGSTHDoKrZd4BVpBUk1Bk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:11:59PM +0100, Marco Elver wrote:

> > Many kernel developers are used to look up the definition of a data
> > structure either by using ctags, etags or a similar tool or by using
> > grep and a pattern like "${struct_name} {\$". Breaking the tools kernel
> > developer use today to look up data structure definitions might cause
> > considerable frustration and hence shouldn't be done lightly.

Its a simple matter of adding a regex to scripts/tags.sh :-) Also clangd
language server sees right through it as is. So all 'modern' stuff using
that will have no problems.


