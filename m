Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7012CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 16:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C04C8E0008; Thu, 16 Oct 2025 12:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097F28E0002; Thu, 16 Oct 2025 12:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16CF8E0008; Thu, 16 Oct 2025 12:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF61A8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:02:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83594C038A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:02:15 +0000 (UTC)
X-FDA: 84004444230.21.F8E43D7
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 993FF8000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:02:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hib2KEcK;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760630533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1bCIY+Fg4sgbbQh9/xqod7Q4jwfUiWgOzkJiNXMpw0=;
	b=OnpSFsI9Kd04VJqTACXn1S/FXorZMszL2vGH0rsjD3s33KJs0nnb02dBa75prvvrwGq8Ny
	TH13SFUsswzv2ll4BAItb4b4jPEkmkafJObCrOMkUMTtIXfdk8iXaERUSqE+xL3UukwPJs
	FBGWiUZR55ePEASKfpHCQJWxcAvvjP4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760630533; a=rsa-sha256;
	cv=none;
	b=KUkLBgaGTPvIwFkMLhXm19hmbMCdEGWmGIRofgfkq1lf6FSXcxgrGggpcv1nbFRdfCq2QB
	ERaZRd8AQ4CTzXD/ly2K+jQGYKcFBfbhj54pLaRKXZCTlJyeG+GcTC2vs/7GwhVlv1vEJe
	bnOHLxwHw/uCNzW/AWdKSuM0AZh1yCc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hib2KEcK;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 16 Oct 2025 09:02:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760630531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O1bCIY+Fg4sgbbQh9/xqod7Q4jwfUiWgOzkJiNXMpw0=;
	b=Hib2KEcKq2hR8k4Ibve9BxCvscugQVL/Swl4CdjpYofAhCPpTVu108HgiRRCnno8FIVj23
	EzoyVoztcziQTefW9Y3hYfYIEAkWLFBxGW0H9epN1r4aH7NaU/eVAzN4KoVySJK5yp/yaJ
	mj8mf9MN+hq6vmGrYDsdx1qX1/2m55U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Wei Wang <weibunny@meta.com>, netdev@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: net: track network throttling due to memcg memory
 pressure
Message-ID: <pwy7qfx3afnadkjtemftqyrufhhexpw26srxfeilel5uhbywtt@cjvaean56txc>
References: <20251016013116.3093530-1-shakeel.butt@linux.dev>
 <59163049-5487-45b4-a7aa-521b160fdebd@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59163049-5487-45b4-a7aa-521b160fdebd@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: ijb7qgk47b6jpwdmd3ditbejxnxoeaup
X-Rspam-User: 
X-Rspamd-Queue-Id: 993FF8000C
X-HE-Tag: 1760630533-491491
X-HE-Meta: U2FsdGVkX18vUvhTqhtx2R5I+URZvUj1eEdtF23SCVdBuqeINsPIgQ6kdDGJsIZaMYTod9gm3jfUiUltWGAmgn+4pdxzbsJ/TnZb3G3TQKrE8Vzz7wNrkIqavVpmsQlX+/qQCAxkE4aEhAHyeCLeVgrD0HP0wjz5oBQRml9iLM6YeGVBqgBm6JodLdpVMTR8MdKMiyJ/Jh0W3XuDesQ05KzogN/lyYYKuFiGPiPei+Jh0SRT4sJWq2laJfTIYJ4d1gkFc81kax0SMwWSIa87W2BouW59d4jYxvV0aSJ0Jb/3bahehiSXrBz6xSNXi6MXdhNUAZsNpVxFMesq11Q94Ke+KGtX/1nQdGZKok2f97s9i8JxwOrW3JOFTjmyMwXxcAuZFRfRNiYCblxv+MA6sFgRzGG+gs2oiytB1MFoQUE7gBEvLZzfvuCsfIm12Y/cEm5ybtYAU4rKka58GCCTqge6+05NsP/MPcT1Gn/RVqlwYbrpcYC+ClDstb/V+mEG9gNPaeGzzMNIN0wsR4u0xJoTau+01YOzYtN7QIzMK56FNED+I0/B76mpHbke5argOUO5vCh/U43CHfKJs9y7kUDqX3WUtmxm/AmQ6lO/NXq9KntSJO31QQzxfD38qOVwxUibbcu0vRZdKCF5yu+y+0g8EqLT4bBmqK2Vf2+vE3x9ZWu15f5m2sJA/YaT0PCkix4abb/AU9UgV9lZQRT0nEI4RtqZwUJa9LP0wzk/0lv5cAJzX4jsGgYwKUogQol9hKO/L8CWi6FFIRPFnKajKevjOBqNceuBV0fyYR6ZYPnETv7Q34uLI1EUiu5kqY3rLgYBwGF2Wo1oqaZEpL1p+L9J0OExv4DdMhC1NSUoE9W1sl2lew/JrzW9G2KToNwibcYIO3rAmzktWnMq4gKlKPAUtFBBVBPV/+K0ZRhdeZ+dDcuR9sHz1tdM+ecCySASOz4cpmIiEBqiLxxRvsK
 5MkTsJ2m
 VqWlu7mteoXmr/syWagtI4mhx6Ybcq8ZOk0nLYGO8uYsBRI/MByUUgBPFVxvqDZHCwEn8Kv56YUaVk5yCn/01sZAPY0+sqNewDtIABkCHHDD9tBhl6/EwUJ03fNkdOWK7bM3HC+njHI4ZOCuVevxp5m37nf6hrhO5udYfoBZBvHV1SEVCoTtw6qFSEL2TZqg7SmJrHHkiuYjRQNWtSmEl7O0TOCXDWgY7KoGncX/znRrce7CHppFb60Ap4v3RnhuZhWG5PerjX1tL9gs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 12:42:19PM +0200, Daniel Sedlak wrote:
> On 10/16/25 3:31 AM, Shakeel Butt wrote:
> > The kernel can throttle network sockets if the memory cgroup associated
> > with the corresponding socket is under memory pressure. The throttling
> > actions include clamping the transmit window, failing to expand receive
> > or send buffers, aggressively prune out-of-order receive queue, FIN
> > deferred to a retransmitted packet and more. Let's add memcg metric to
> > indicate track such throttling actions.
> > 
> > At the moment memcg memory pressure is defined through vmpressure and in
> > future it may be defined using PSI or we may add more flexible way for
> > the users to define memory pressure, maybe through ebpf. However the
> > potential throttling actions will remain the same, so this newly
> > introduced metric will continue to track throttling actions irrespective
> > of how memcg memory pressure is defined.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Reviewed-by: Daniel Sedlak <daniel.sedlak@cdn77.com>

Thanks.

> 
> I am curious how the future work will unfold. If you need help with future
> developments I can help you, we have hundreds of servers where this
> throttling is happening.

I think first thing I would like to know if this patch is a good start
for your use-case of observability and debugging. What else do you need
for sufficient support for your use-case? I imagine that would be
tracepoints to extract more information on the source of the throttling.
If you don't mind, can you take a stab at that? In the long run, we want
more flexible definition of memcg memory pressure. Let us know of any
requirements you have for that. Thanks again for continuosly pushing
this conversation.

