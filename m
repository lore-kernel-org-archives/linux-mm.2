Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D53DC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 01:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A31E6B008A; Sun,  3 Aug 2025 21:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254306B008C; Sun,  3 Aug 2025 21:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 169B96B0092; Sun,  3 Aug 2025 21:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06B946B008A
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 21:17:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A868E811B6
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:17:41 +0000 (UTC)
X-FDA: 83737312722.20.1F025AE
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf21.hostedemail.com (Postfix) with ESMTP id 08F231C0003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 01:17:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754270260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1vG2ZDtamTQndkkTnNe2pJQypADdblD+wCCZXznSZuU=;
	b=SDFqp7cuAm6tlE79W5TuUSSEALAMMZwSv9NfOZjCkb0DcH4DVRTJaMPpL0aDlkpxSGwToQ
	ATKWsbCdCaWMZdlJwx4CId0RgR4FzgwWAcV6IBsi2jDHu5y3dy9HPGdmcwWsKKCM/Pef6U
	gxSp6Jnm7zBUaBqWRMX1DYdpG3tWybM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754270260; a=rsa-sha256;
	cv=none;
	b=JtQlBkIdtjQxjIRMy3+O5iP2oWjHUSDo5M9uikw/NIS7KcXpnWAm7nEgbEPFJPUKGXvHd9
	mPkGtIWsUq58hllfmZIV1SIz0XOENCtraPp9lUVFf/5s+Ws7Y/VPoV8pY4TjQZx1RqdH7v
	2A6hUNL4US+0Tlj9WmKSKQWLOzXDc8g=
X-AuditID: a67dfc5b-669ff7000002311f-35-68900a2f40c4
Date: Mon, 4 Aug 2025 10:17:30 +0900
From: Byungchul Park <byungchul@sk.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH linux-next v3] mm, page_pool: introduce a new page type
 for page pool in page type
Message-ID: <20250804011730.GB39461@system.software.com>
References: <20250729110210.48313-1-byungchul@sk.com>
 <20250802150746.139a71be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250802150746.139a71be@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0yTVxjHc97z3mhodqwwj5AsWE0w1BvOhMdIFrNk8fWDiUFjzLZEuvXN
	2ghoCkVwoqBdtjVCmZeopWqRDBGI1aLcJlIKFnAzGDa0IgLjGkVQKzaFEpVilvntl//zP7/n
	+XBErGrkYkRDRpZszNCmqXkFq5iMvLR6raJYv+5xMBbszmoeqoI5cHmwngN7ZS2C6ZnHArxr
	8iJ43dbOw0SrH0FZaQCDvcvMwhvnLIZR75AAVa5tMFA+xsKtn+swDFk7eCg0hzA0zUwJcLS+
	ggF7Tb4A92uLODg1+zuGuvxBAf5utPPQX/2OgzFPIQudtissvDzdhmGgaDN4HZ9C4M/nCNqc
	dQwEjp/noedcIwM3m3oEONnt4GHYPICgu3WIhdNzv/BQUlCEIBScV04VT3NQcqdf2KyRCnw+
	Xmp9/gJLN648YiTf7buM1GB7IkgOl0mqqUiQLL5uLLkqf+Ull/+EIPU9uMVLHWdDrNTw70ap
	of41IxUem+KlV6O97PaorxXJOjnNkC0b136RqtB7zVZhv5PPcdzrw/mogLMgUaRkAx2Z/NKC
	Ihaw/dUcG2aWrKDBaTcXZp7EU59vBofrUURD3SFiQQoRk6sCHXwSEMKdxURPay4MM2FWEqBd
	E5MLb1XkO1rWUMd/yBfRznMjC35MEqjv7VMm7MQkll5+K4bjCJJEWx4+W6hHk+XUXdvOhHdR
	MijS3uvt3Ic7l9KWCh9bjIjtI63tI63tf60D4UqkMmRkp2sNaRvW6HMzDDlrvt+X7kLzP6o8
	b+6beuS/v8ODiIjUkcrdOqtexWmzM3PTPYiKWB2l/PbIfKTUaXMPysZ9e4ymNDnTg2JFVr1E
	uT5wQKciP2iz5L2yvF82/jdlxIiYfIRjK9078sY1Ly8uWhbqMievKv3xyAFh+bjoLtn0JvGE
	nv3KZB/i+nbHm/5J/qvZZDnaZ7T0bi35xHZwa/nOiN+u+SOvefY6/Ss1W+LYM6nNKRd0+LM/
	NDGzEx1xiaPVW1KSDnVnWdff/WksSRcXHTyccq/5WWmZd5eup/Nz60zC2LiazdRrExOwMVP7
	HnS0DcVNAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfyyUcRzH932+zz3P4+rmIepZ/ru0mkq1Mp/GSuuPntW0/qtZW648dVdH
	upPRT2L9uOFIVi7a6afUsk5xJxp3IpmEVU/icGITIa6bw8hpLf+9P6/P5/X+68Ng30LJSkYV
	lyBo4hRqOSUlpfvC0jZslGYrNw2KEigofUbB08kkeNxjnp9KyhE43d9omKuuRzBR10DBkG0c
	wf0iF4aClnQSfpdOYeivd9Dw1BQJ3Y8GSKi6WoHBoX9HQWb6NIZq9wgNl83FBBSUpdBgK2yU
	wMfyLAncnHqIoSKlh4b2ygIK7M/mJDBgzSSh0fCEhLG8OgzdWRFQb1wOrqZhBHWlFQS4Mgop
	+JRfScCr6k805LYZKehL70bQZnOQkDdzjYI7qVkIpifnK0eynRK489ZOR6znU0WR4m3Do5h/
	+eQrwYtv3hO8xdBF80bTGb6sOIjXiW2YN5Vcp3jT+A2a7/xcRfHvbk+TvKV3G28xTxB8ZtoI
	xf/q7yD3+0dJw2MEtSpR0GzcHi1V1qfr6fhSKsnY3IlTUKpEh7wYjt3KNfyaIT2ZZAO5SWfN
	AqfYNZwourEOMYwfu46rmWZ1SMpg9jnN9XS5aM/NMlbJld3tIzxZxgLXMvRzwfVlj3D3LRXU
	X+7DNeZ/X+jHbBAnzg4Snk7MBnCPZxkP9mJDudovPxbO/dlVXE15A5GNZIZFtmGRbfhvGxEu
	QX6quMRYhUodEqw9qUyOUyUFHz0Va0LzT/PowkyOGTnbd1sRyyD5UtnBGL3SV6JI1CbHWhHH
	YLmf7NCleSSLUSSfFTSnDmvOqAWtFQUwpHyFbM8BIdqXPa5IEE4KQryg+bclGK+VKah2ruZ5
	bmSr9z0yweeDXd87l9NbWdtfvmtHYJGPVYzvsJ94mZcZpba8GNKX7Z1h/I/eszV27bzoOh9p
	tW7x1g2eC3e03q6+9aAyzC1vfm1ekjrkMxpxDE2tXtbVXnWa9u9zQ2jAlTHN9hHK4jwW67hV
	1bRmYunltUmo5GNGiD1YTmqVis1BWKNV/AFarF8GMAMAAA==
X-CFilter-Loop: Reflected
X-Stat-Signature: 3buyfrti5tbnf45hp5h5ti87mxzqan78
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08F231C0003
X-Rspam-User: 
X-HE-Tag: 1754270258-944909
X-HE-Meta: U2FsdGVkX1+q5BVdCvb7192BXcmr8VUHmx06w1zomvjfOQuhnbMQ+cdKdrvX7xWX7WlJ13799OyXpK95ktMimxriM/YgMX3MTBD4G4POfU84EzcVTwvsFPNC2yjk9TaHWK/lOazrCT8XF/KuN3sCY8Lbtx7uw5lbn2is3G5EQJmi7JmcsO0hOb/2ijKVo0crhQP1ItVnkho6Enwqgpm9HZytcLV4B/Sc18i+nwaWsqKargG4PmQDqt1XRCMurmC+iEdshLXvSUV8eFIy4SxOqpCzjeJdbRxdw+jWflg0Jnl/697VfZxEasIZahgPxJ9i79ROyG9T3JeHWlu+/jEWeK4TZK7I9RdEcjAajxczSgmVqLIU14b90LwmwmoFUI1tMiSLRmqHfKQuGjAOq0+3mW4Dj8NsHNKl2z8HbHX9x8b7HCJDT9lfwoJFLz4Cg34eAlzHLAqYnrzO1i7xSuXkMRn68zD3srPHZlcBtnbBcsKomRGVEDsxDb8NqgLlVTRSV3qmUYhfYV2L76dH2Oe3ZkCiytdTmdIYcbqr4lTY498jUZsejnQiUoRRTBjLQZL7lkjHkEsDGYatl/ha05m3H/WUjJl2eBFTFGdIkHgnojtR+RYq3+S3isP/s0YA7o9WClijgHNeXSlvEZHeaed+htagxEnYCNUyA9f6ixFTz8ggFPdG+wiFZseToE1Y5qGHPzP+CxF57kLDjhLyaFobkSEmx+EmRmIum8th14nOj/4byG/LN12FJ4jwt0ffTDWj5uB8riZK084MmEq/mc5qRv7ab412K8fNGt6n/NhH6YgKNsoCEYrRxoBJpnPp/4jmFzKPifFuZ1txZdjiF8Ligh1IF2Kah+/PAdS3E0LDzMWk9HrNkflG7AqCCcp2YACpH8aUkB+6Zoit0zgiPcvijRBDldHToOAI31cZd59CveXsNsm8kAxbw3m7QxI7ZtlARwQDmqgUkDZkXd4dvmw
 6AXUQwSJ
 noqgR9fXm1GHYPKmhHRssnwiS697r+CW/dcEYruEmsk1VBe4nEUaCp7CBx6XPEMWHuHcILv/aA8Whjfua8QMAjBrzuRjisbTKrJjlIS4yUaZYkG8lNp8ZKc6tVLlEREV8AqWjDKSTl1fKYDPxRz1W/WBn2jl+St5RBvGkHmGhlNp/MPu0raFZ4IG/iXUKhxjbTvPw0Z8pELZZVYhsouiGFEjtMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 02, 2025 at 03:07:46PM +1000, Stephen Rothwell wrote:
> Hi,
> 
> On Tue, 29 Jul 2025 20:02:10 +0900 Byungchul Park <byungchul@sk.com> wrote:
> >
> > Changes from v2:
> > 	1. Rebase on linux-next as of Jul 29.
> 
> Why are you basing development work in linux-next.  That is a
> constantly rebasing tree.  Please base your work on some stable tree.

Sorry about the confusing.  I misunderstood how to work for patches
based on linux-next.

However, basing on linux-next is still required for this work since more
than one subsystem is involved, and asked by David Hildenbrand:

   https://lore.kernel.org/all/20250728105701.GA21732@system.software.com/

I will base on linux-next and work aiming at either network or mm tree.

	Byungchul

> -- 
> Cheers,
> Stephen Rothwell



