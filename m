Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB82CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 17:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B499D8E00FD; Tue, 14 Oct 2025 13:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21038E0090; Tue, 14 Oct 2025 13:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5D9D8E00FD; Tue, 14 Oct 2025 13:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 945478E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:22:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51CE31A09C7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:22:15 +0000 (UTC)
X-FDA: 83997388230.15.DBCC152
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id 69E6AA001D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:22:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ccWhHIt4;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760462533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cg4fC44QRmMTn//flsfSUL5Po+sm8kLX2ptgHHTDiPc=;
	b=LUNwL2fXmypT3fLj+mWig7BigTXkmeiP2sTlk2K912CyJolQNN3Sogou6YGD5+vLD1ABQh
	TVVAupVnxM2doiIR3EbWEvmGWMTIfwebYySPSNbPfEiYeb0DuBZaTTHplayGUEzrgusaec
	uwzPqzmObTydcxtNk6EuqPIjDFMvMHw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ccWhHIt4;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760462533; a=rsa-sha256;
	cv=none;
	b=CwgFNJl+V3u9cH8GqsY+70Z5vMpd4ThMa74NQxwOB8K8Q7+Pg3Eh4c+jP4Z+sXxG/AAyp6
	5XSEsG56oOGuRA+GDuSsjfUR8ptbu0Wl/oHRIjlBDbQeoA7HolzXiYOuzxOB92J/OnubuO
	5OMde02WyhW0lkcCGIlmQp7Kd+jO/gE=
Date: Tue, 14 Oct 2025 10:22:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760462530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Cg4fC44QRmMTn//flsfSUL5Po+sm8kLX2ptgHHTDiPc=;
	b=ccWhHIt4pfhdqLBvm86UNLCPqVwotniakgd1KLzdMa4mEaDDXZa3SVbdCXvsr+Oht9/BL/
	DjynZHkqkitOVmyOYVrh9olLI++RKQNNRdO7p9RD6Okyq4D+8/EidPPqB0NAU5V4YlxLn6
	OdX9Z2MHL7otwLGo3/7m/xBzDQWKAeU=
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
Message-ID: <itljl2e4rwbblmnhe2vucmsvxzbu42x5foszf4y5b63evbitpj@qsxj3amwhts3>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <aO37Od0VxOGmWCjm@tiehlicka>
 <qztimgoebp5ecdmvvgro6sdsng6r7t3pnddg7ddlxagaom73ge@a5wta5ym7enu>
 <aO5o548uQAuBcw0P@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO5o548uQAuBcw0P@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ccsmyzw1zgmi1y7n59e55eeh8b87z77z
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69E6AA001D
X-HE-Tag: 1760462533-114615
X-HE-Meta: U2FsdGVkX19TCCnjJDePPeo/yPrs18J4/u7+AMp0Z25bNHuckpz6HN7Z1UNb1eHSlR7OrG8vCOdpqWrJCTru2oHmqM0pcou5WAOZ+VT6idKw9CynynGBWuW7cv7agEUEeb0lyLFDVuH48FoEGDRkkqTU7vo2SAz9LrB6S7f3sUxLNPFNWpVEhyI6KKqqM5Vu9qQNG5ISUsrgOQnkkKT4ZGZr93C3Po1wSN75v8qigEuvoeJMpz4aaNrxZX+tnTDSUWmDm/GZ8L8s3T7mRNkQym6Fsn3L0mnhUT2bj4rlls9D/TUqHuiDXyWLhrQXTyi/SvG9wn5PPyKT2pVcoTZyquZeduvbKou3ZiDjaDUVmrHOraEj4dzD5JpfqRUnW7TsHjzd26iu2eAUX2hnV3ApkJHt2FMF6DA+b9ay8tUMHjH8SqIBSNoaFBsnuN8I+2cRDaah3blBEUkruEJDQb3mviaCQgDuHLN1MOZfT9RwL2A0SSDDQ3Z1fu+UN8/KGFeHLlNv1/HgyDk/jRo1AlIMxglsgi2SmY9h05qvUlvulfvYaFn/I+gmx1QdeER3iGXIRWQ2YXhXxD6vygxjUPskR42Io6t2ZwmH8iqa9LsyMZEJV0ztSGZookAzLBtSAyclWTYK4JTSmmaSN61+mV6QwwCtxKGSKUBDLqEuYgCATILlrWX/w4DrlJV+VlLek492gypuDDXJvCFA9YeM701as9mZ+vngUAvEdcno98hZnGKUjk7qYkxlQ+W7OrsiePonsrWC0Qm71uY+YpKEUkGlpAdn67Y/c0Syh2vV/DmDCnlQOzxxWeOAN0HshAMQqSgVCNaanOUI7eEWHBii67OR0orq4vDBj0o4Gz591v3Z27uUbroHkwvaqi55Xk1x3cEA3tL8Et0qcv960yGVr5hYKi+8oiUOFJjI25dppN0l4kJqqACb+IzFXPcFlR+/aGvmjQac1p9fnGiKPT9nFvd
 Ad8tvxw/
 BfAjFYJ37I60puCP/JuYHK9MOBP46XnyfJkT5cMsrKldGO2onHW+MdXbnmdJQe7t+4z6mSmhjrNDUNOU/a6MVqsccOayfYT1066F6wYukvj4qeWS+YyoGl560YoyQlBIi+V44Wo+n8ODKEvZ7Bg7oA+0WN3n0u0IWyPuB/JtDkYLhpo2UXbBPzOxBvYJY0vuSqKeVLGbpw5iOArp0KNFCBnLizRn+I3EiLfeDYu173xSPtOAD5K4pdNqBUDqEcnlyzNmZ9OcEoed7QX8vnzMOxER0tAt6u+iUyw5x1GG8quuGUWI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:14:47PM +0200, Michal Hocko wrote:
> On Tue 14-10-25 07:27:06, Shakeel Butt wrote:
> > On Tue, Oct 14, 2025 at 09:26:49AM +0200, Michal Hocko wrote:
> > > On Mon 13-10-25 20:30:13, Vlastimil Babka wrote:
> > > > On 10/13/25 12:16, Barry Song wrote:
> > > > > From: Barry Song <v-songbaohua@oppo.com>
> > > [...]
> > > > I wonder if we should either:
> > > > 
> > > > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > > > determine it precisely.
> > > 
> > > As said in other reply I do not think this is a good fit for this
> > > specific case as it is all or nothing approach. Soon enough we discover
> > > that "no effort to reclaim/compact" hurts other usecases. So I do not
> > > think we need a dedicated flag for this specific case. We need a way to
> > > tell kswapd/kcompactd how much to try instead.
> > 
> > To me this new floag is to decouple two orthogonal requests i.e. no lock
> > semantic and don't wakeup kswapd. At the moment the lack of kswapd gfp
> > flag convey the semantics of no lock. This can lead to unintended usage
> > of no lock semantics by users which for whatever reason don't want to
> > wakeup kswapd.
> 
> I would argue that callers should have no business into saying whether
> the MM should wake up kswapd or not. The flag name currently suggests
> that but that is mostly for historic reasons. A random page allocator
> user shouldn't really care about this low level detail, really.

I agree but unless we somehow enforce/warn for such cases, there will be
users doing this. A simple grep shows kmsan is doing this. I worry there
might be users who are manually setting up gfp flags for their
allocations and not providing kswapd flag explicitly. Finding such cases
with grep is not easy.

