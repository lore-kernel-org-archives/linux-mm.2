Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6C8CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768DE8E0082; Wed, 15 Oct 2025 14:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719528E006F; Wed, 15 Oct 2025 14:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F058E0082; Wed, 15 Oct 2025 14:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 526A88E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:26:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02C0857021
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:26:40 +0000 (UTC)
X-FDA: 84001179402.26.2E50415
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3029920011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:26:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VryohoR7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnr93v3DZbINrWDJ19P+8n2apC5wb+Y2uBcsyCCn+Ck=;
	b=D5rzIKk951GX2OAd3JZni30KspxZf2uQLN9NPHuVqHCyv0U+9lE/IUYvXTgoeHuYlhZPaE
	nQbo8AQJRjDFnuIHjRrKSiktwa6bTRO/OLuqzZKYAIbsReiiJyzqr/refK3/l+DRU0kC60
	5j5HGhcAuuMiDAfCOhxQmD8jIa7NCtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552799; a=rsa-sha256;
	cv=none;
	b=qccOhEAV0L8XKRDXtgDiLz9gjxTY70VHKVV06UNWi6dYKEX/nG+dBChpsesjZZY7Abqum3
	LASE1ceLl0TnEwJoRIa56D2ZwkxvMXwfXGXwqEIVcKl6AbmLMwBIf1h4M3lV/dVvn0rmQg
	R3GNzNj49jHWe8RQVuivnM6AsCxpZk0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VryohoR7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 15 Oct 2025 11:26:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760552796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dnr93v3DZbINrWDJ19P+8n2apC5wb+Y2uBcsyCCn+Ck=;
	b=VryohoR7UVW+CNLoKRwZEs3zNRn9GvrYMXHCOTsZ3RcnaWxYe9LiI5i3eZg9c4v3RnZcpq
	jAxwjSMDB3bZTSXfoZa3yYC/L1KyXk4uYi9KaW+/pIoKRq5gRt34pJxsVvtzmXMEeJCV1a
	oLjb01YD3ChA4d5Q2LUsAr6FzHLYTss=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Barry Song <21cnbao@gmail.com>, 
	netdev@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Jonathan Corbet <corbet@lwn.net>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Yunsheng Lin <linyunsheng@huawei.com>, 
	Huacai Zhou <zhouhuacai@oppo.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Harry Yoo <harry.yoo@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <yr6mhjt2dq5mvkdsswbure5qqrofqbguvcln77zmxd43bomlyk@uidixnfu4mla>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <aO37Od0VxOGmWCjm@tiehlicka>
 <qztimgoebp5ecdmvvgro6sdsng6r7t3pnddg7ddlxagaom73ge@a5wta5ym7enu>
 <aO5o548uQAuBcw0P@tiehlicka>
 <itljl2e4rwbblmnhe2vucmsvxzbu42x5foszf4y5b63evbitpj@qsxj3amwhts3>
 <aO89YYhEJ-GDPWFg@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO89YYhEJ-GDPWFg@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3029920011
X-Rspamd-Server: rspam02
X-Stat-Signature: 1o7qsenaezthyhqi7huhmzxphqyyk4k1
X-HE-Tag: 1760552798-607509
X-HE-Meta: U2FsdGVkX19uL5zYh5ti5Zs9GXQXFDhBuGCtWNxz/jxWZ34RlmsL0AYgItnhRCX8WGL1QYSXzelTGxjonTOP03eFWvIt+g1rSWfpS+G1+8BHOeSX2q/Jh3Cq/3M3bWlA318WsIMYu92yorvgPTXSHQvQQGq622e5hkI/hxZrHkCfkBpXbgqkbnVcTdKQLrXGe/30LD01Ql3ZNigveC7eJi82P2p1MR5FYourCu78UlcmLvOBL6ougBwHifTfOQQcpilX8WKngyyFk7jbVSKn5Kr6QS5c2at8hJFOFeqRxVwh4tx+CRTTbCiLGBbgnfGvi8IDF3A5fDOaOzJmsIO+s+pVaBUVyATd4JTlo5G+Efe3jpVHHiwGoHbYsOuepK7C5aidJKPrXbDuzD5vdMVaxD+mnwpcbIS6r+kmJ/J3ZCWuiI4PmJvSiYO3fjeixORcECcI11jFN+7Ar6Jge7C4V/ww3p7M46JTugWk/RzmLKkwol9NItBRz/nQnoEUAaU2U0EguL/GiZM02G9urNXScNf/uwXN+laZ8yk4aRnJdAcKWJ4i0B8A/FQRgppkDdOWi2ywmg0v0pf0vbQ3v3ltni0Ck9ulgCkRSyAq69sm8WfOOeo5omp0nDTGUBrpza94PZpSIeSbBttDNXxbakO2whUm1xcIrVFJCmphhxAu+R4OWEUeU7eRSQRzqNsGaiPbKfneo7586XKoMrFDPPEQ9kqGIp3pvt+Ihac0cOmMsFFhWfTz5OOE8Iq5UowQaG6umH6emwt7qprdtoc2j536AAF3d7NV5Ei5Nsx30D0JQzZw9MoDhhRCMMqZV/Qt+JFDIVhVMFJQ5+MTdNh+BokUYm6ahw/ydA6J9mQPQ71Ccv4iIw6ybuI9GvNTS4lmxbadR+icUC3OG0zACu9aZnilXOZqcAeq/viBWFqdAMsSsP1BlnTB5ec8KeZIZFAYaI33cja/5eI7EXVoQE/SoZ9
 nfTBV2RC
 vkI7bNunVt/ldYI482UrbGRne4BncyeOBqkHzBHWNAmd2oMSomazSayjGcXTbBa5p0wDUqRvhoDJ1iHCT3PLa6gxdXgV/9nH3+gv1xOVzPpSqcbk1FTEdjCRI1CkMJGQN7P/f4RiWzqqiiho5excl3RxlL1uML6mOB4fFyLxnp/MYmhVaT+0f3+pVKPSGpJLHHHR8rl2k4Onv8YgtlHGuEAMZQXKohorGmZMvuQ0+RfbqIrvw4ZnDJQhCerTA9ryrhqfeR60+C5hdPIwemJkMzEARv8l1snxg1aeNgSvDlDqlVt8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 08:21:21AM +0200, Michal Hocko wrote:
> On Tue 14-10-25 10:22:03, Shakeel Butt wrote:
> > On Tue, Oct 14, 2025 at 05:14:47PM +0200, Michal Hocko wrote:
> > > On Tue 14-10-25 07:27:06, Shakeel Butt wrote:
> > > > On Tue, Oct 14, 2025 at 09:26:49AM +0200, Michal Hocko wrote:
> > > > > On Mon 13-10-25 20:30:13, Vlastimil Babka wrote:
> > > > > > On 10/13/25 12:16, Barry Song wrote:
> > > > > > > From: Barry Song <v-songbaohua@oppo.com>
> > > > > [...]
> > > > > > I wonder if we should either:
> > > > > > 
> > > > > > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > > > > > determine it precisely.
> > > > > 
> > > > > As said in other reply I do not think this is a good fit for this
> > > > > specific case as it is all or nothing approach. Soon enough we discover
> > > > > that "no effort to reclaim/compact" hurts other usecases. So I do not
> > > > > think we need a dedicated flag for this specific case. We need a way to
> > > > > tell kswapd/kcompactd how much to try instead.
> > > > 
> > > > To me this new floag is to decouple two orthogonal requests i.e. no lock
> > > > semantic and don't wakeup kswapd. At the moment the lack of kswapd gfp
> > > > flag convey the semantics of no lock. This can lead to unintended usage
> > > > of no lock semantics by users which for whatever reason don't want to
> > > > wakeup kswapd.
> > > 
> > > I would argue that callers should have no business into saying whether
> > > the MM should wake up kswapd or not. The flag name currently suggests
> > > that but that is mostly for historic reasons. A random page allocator
> > > user shouldn't really care about this low level detail, really.
> > 
> > I agree but unless we somehow enforce/warn for such cases, there will be
> > users doing this. A simple grep shows kmsan is doing this. I worry there
> > might be users who are manually setting up gfp flags for their
> > allocations and not providing kswapd flag explicitly. Finding such cases
> > with grep is not easy.
> 
> You are right but this is inherent problem of our gfp interface. It is
> too late to have a defensive interface I am afraid.

I am not really asking to overhaul the whole gfp interface but rather
not introduce one more case which can easily be misused. Anyways, this
conversation is orthogonal to the original email and I am fine with wait
and see approach here for now. 


