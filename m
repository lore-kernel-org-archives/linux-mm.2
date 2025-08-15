Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4142ECA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8EB8E021E; Fri, 15 Aug 2025 19:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D599E8E020B; Fri, 15 Aug 2025 19:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96CF8E021E; Fri, 15 Aug 2025 19:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9E278E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:32:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7830CC02D4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:32:53 +0000 (UTC)
X-FDA: 83780594226.30.5D36E7D
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id DEE8C180004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:32:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VqNZM3WV;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755300772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXLIjULjHIbwG6bxUtOeWzsAAQ+xy0b4gmrNOnGTqG4=;
	b=DLMjfXBaqGJ4btTSgSeRI+pC8YemcR5YZD4UeMvw/xh3wwwVQOqE5St2UF/X7c3LCnRCYl
	TdXswWEy/Dt2r3iDEUmW1ro8lUZW6VJnuaf6+23sFauB78SKDrPobabBWqNFO98BBreCJM
	XSbKe3MORiQiMKrcOGkQ+aQua1tE1ao=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VqNZM3WV;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755300772; a=rsa-sha256;
	cv=none;
	b=RmmoIGd6TNFE6XWTy/+ZVLI07tP9WRAuh9fAGpX3LNvj4L1lgf4mENORsxUOQvLvP3KaLl
	mY+hxpy7upjygmC1OMfw5IAE4xlWYHelwykLxad1QDOI1edZcnDQ4lZe+0Cg8GdTSB9yWf
	7WaPsGCBLbaPt2RtlKFzzp6ha/8vpDM=
Date: Fri, 15 Aug 2025 16:32:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755300769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rXLIjULjHIbwG6bxUtOeWzsAAQ+xy0b4gmrNOnGTqG4=;
	b=VqNZM3WVNHiEwegbdEeOrBiwjv+u9KHv1mwrE2FQPW3BrRaLz3tbXZPdXM33SVSh44czJi
	UaD2eXhYLBJRfn2PbG+xXhnRrI5UT8RtcxsBjT+d2ZEUkl/7n3YD8wkxvW3lEbs0dxeJIg
	10j7dSS/lFi6xMyINEXBJfa4uB79F70=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 net-next 02/10] mptcp: Use tcp_under_memory_pressure()
 in mptcp_epollin_ready().
Message-ID: <j4npjivymessz7rnlc7xvec77k7634b4ldfrd2to5zpcgofci4@5adfxbs3hcl3>
References: <20250815201712.1745332-1-kuniyu@google.com>
 <20250815201712.1745332-3-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815201712.1745332-3-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DEE8C180004
X-Stat-Signature: dej15w7emkgqfwaajpi8drxrepja8qsm
X-Rspam-User: 
X-HE-Tag: 1755300771-272158
X-HE-Meta: U2FsdGVkX1+16Jo6IR+zPUdamarDAxYg3h7JnDQvs1MgpSJ80CauQo18F0OGJQWir2g3maHRXRX36wbeETPbsOZr01UakCjM88iDvYNT9P2r7dAbMppoE9VzOuxZoj25p0JnCqt7oBn/I19xgUjO2MTzBJ5sFgBvkBjVNTq/uS4azhwZ8ccp7+wzr/8PXk3EbdWN/oji1qbPkQtkkJG8aGigENCGpMH5EwiJ1p/Cys8LZ/bTQAC3f0IA4dVv2GorA0aH22CykSdrxgyCR1ZpF74BluaQ+MUNeOGtYnRLy6ToLK9xIvOhlgzFNDVNozpKG66z0hTEtllFk0Wragg4uVTi1boSRJJa6hx3bs42cCtHNPbTcyKNAkca8b+WNSVZKyZKk32FknINASNWk/8zwwKP1wJYH5cZi+Jh+y8Wb98UD0IsgU6AO/JlGlypvtUMVISd0wqnW7tWKQzK6Asp+m8/seNEyDL/ja/viIiuoFQpCKkElASiOgIXP7U68ISRMq3UyRwz2iOLiI2sNSmz7WDIeCBoefLoNKhYXgFKQ1jZbrqUFu1ZhfI9066Uv1iJJkC/Ey70vAbD3/MiWPoOlVsJcXLEfSPn4QIjboed8g8nyho1iZE3U3thSRXcsQ2wtG4doCtnqobj8Ft4GiqOjpaUvcJetWYtV/wUi5ZjAieRogRKdkooFGpKlNyuPuQkFHoZnYD7lmBkiPgCwej1dkbzrykPy5RkP3fAIDBzi8/WtZVGvxyZvAjNkYLqaBofd/Stxa5UkGLU+ojx+rLCEmMttRGKtjo+GHYFrrSh5ylb9uUHQrS1mMOt4/UDAnZzknLWnKbVsXtSW1GxrKQB89v4CootXZSU2ojUoVBQf+GtrXFyi+jHpFzhqfShI+xzsjdYICGl18x0IPHKuYRP5hGDD7PQ2tCW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:16:10PM +0000, Kuniyuki Iwashima wrote:
> Some conditions used in mptcp_epollin_ready() are the same as
> tcp_under_memory_pressure().
> 
> We will modify tcp_under_memory_pressure() in the later patch.
> 
> Let's use tcp_under_memory_pressure() instead.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
 

