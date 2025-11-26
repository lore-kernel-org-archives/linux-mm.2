Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21DAD10376
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 04:21:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A976B0011; Tue, 25 Nov 2025 23:21:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DBE96B0012; Tue, 25 Nov 2025 23:21:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0216B0022; Tue, 25 Nov 2025 23:21:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F4186B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 23:21:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D199812E0BA
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:21:03 +0000 (UTC)
X-FDA: 84151458006.11.1BE36BD
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96FAA4000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:21:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764130861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zHsr6J1E1lBR0ALPVAGqZvDHByA64kvupgJGyMohLPs=;
	b=0gjqVl1dO59fzxVmk98r6f/LkHLDGIys6Z/Q7o32ukY7MIzHyTIyLnnB1WQcWZBlNRNaQy
	yeHoHV/t3xiyhYLKBeYvislRxHXQE80eh4vSgKg+aMfkm66WUwh+/dIAwjj2V69UyNhGHa
	5QctP/43jMLVrDxMywaO+E8GB1gMhXY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764130861; a=rsa-sha256;
	cv=none;
	b=B04MgzQ6qBvl8JkBop4Ig56gtFX81HqV/XMQGh6NRBqaJjphtP3+3qGIdLVMXN/ah8skY4
	f+7KppuJT6Spxst0+wlQmiF6d6dwyeKwNSgrN3P2OB8rQeVd9so7MjzrY39zj0dMRonQmh
	I37bADgo6EIpnDvnVV3dVybPixhaBKM=
X-AuditID: a67dfc5b-c2dff70000001609-fe-692680265a1c
Date: Wed, 26 Nov 2025 13:20:49 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
	almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] netmem, devmem, tcp: access pp fields
 through @desc in net_iov
Message-ID: <20251126042049.GA67399@system.software.com>
References: <20251121040047.71921-1-byungchul@sk.com>
 <20251121040047.71921-2-byungchul@sk.com>
 <20251124184729.7e365941@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124184729.7e365941@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec95d3Ycjk7T6lVBaqmFkJdIeKnoggTnoxkEJWErD+7kNm1T
	m0Gxymh5zRTRabUiUuesmKJOy3SmNbM5M2OFqYhmZWn3tInmZlHffjz/C/8PD01KvsNAmlel
	c2qVTCGlRFD00ffGpjBdGB9ln4vBtbNaXDXaLMBz5kkCV5oaAa59XUjhyr5siL/f+UXi2y3n
	CWxtmQT4fVkdhSe6x4R45NYbiO9daCLxWOFjCk+fd0DsbCwQYEdnDYWbdKNCPNBSSeFh86IA
	2w01EOuH7kPcbVyNfzz5APBgeQuBrw8l4medYxBXnCkA2D275K/oGhbuCmYbal4S7IuyIsi6
	2noI1mp4LWSNlgy2vjqcHXiawVpMFynW8uWykLU2fyXY/HPTFPt54hVkZ9oGKbbX+FDIfrUE
	x604KNqexCn4TE4dueOwSJ7nrBak2Unt24J+gQ6MEzmAphGzBfU74nOAjxd7jSVCD0MmFE3l
	tZMeppgNyOWa87I/E4Ky68uhh0kmX4AqbFoP+zFHkLnY5M2KGYxq80aW/CJawugB+jZbQywL
	K5G9fPxPOBy5Ft55N5BMEKpaoD1nHyYa3c/t8dpXMetRe+MjwtODmCIatdZbyeWhAaij2gUv
	AcbwX63hv1rDv1ojIE1AwqsylTJesSVCnqXitRFHU5UWsPQMt07NJzSDL859NsDQQOorvjsf
	yksEskxNltIGEE1K/cV1BSG8RJwkyzrJqVMT1RkKTmMDQTSUrhFv/nEiScIky9K5FI5L49R/
	VYL2CdSBwI6hs59ih1VRm3Y0IL3ixtbF8St9+x1+5tKF+PScwZL+vFb11DXLIWV1ckpcglZf
	krY3K6jNPnAA7nRfFQesvVmcsW5mPmFq96T7Z2y3RA5Pj+RufJ76y/SA1R0v63p7etuerttU
	DG/tdvYf63CHxMTlAlp5pCtS27SrLrFUJIUauSw6nFRrZL8B14M6GAgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsXC5WfdrKvWoJZp0HxKwWL1jwqL5Q92sFr8
	XPOcyWLOqm2MFqvv9rNZzDnfwmLxdf0vZot1u1qZLHbues5o8WrGWjaLp8cesVvcX/aMxWJP
	+3Zmi0f9J9gs3rWeY7E4PPckq8WFbX2sFucOr2Sz2N7wgN3i8q45bBb31vxntTg5ayWLRced
	vSwWxxaIWXw7/YbR4urMXUwWC+/EW1w6/IjFYnZjH6PF7x9A9bOP3mN3kPfYsvImk8e1GRNZ
	PG7sO8XksXPWXXaPBZtKPTav0PK4fLbUY9OqTjaPTZ8msXvs3PGZyaO3+R2bx8ent1g83u+7
	yuax+MUHJo8zC46we3zeJBcgEMVlk5Kak1mWWqRvl8CV0XNhBWvBSeaKF30XWRsYnzB1MXJy
	SAiYSJxZMIUdxGYRUJV43XOAGcRmE1CXuHHjJ5gtIqAi0bJ5JguIzSzQyyox+1AFiC0skCSx
	ZvIqsF5eAQuJ1T33geq5OIQEOhglvvxYyQSREJQ4OfMJVLOWxI1/L4HiHEC2tMTyfxwgYU4B
	Q4m93afAykUFlCUObDvONIGRdxaS7llIumchdC9gZF7FKJKZV5abmJljqlecnVGZl1mhl5yf
	u4kRGOnLav9M3MH45bL7IUYBDkYlHt4Nf1QzhVgTy4orcw8xSnAwK4nwru1TyRTiTUmsrEot
	yo8vKs1JLT7EKM3BoiTO6xWemiAkkJ5YkpqdmlqQWgSTZeLglGpglHmvcp7v7va8Im0jT6fi
	fzqmWr1G76aqpH19uumk0UeG3W7bj82wleDwTLyu8La3cH6hd4jFjZJDr/xvr5BdHNTam7I/
	OiytNUrza3CWaWV0drjy4ozptU9jT8T8MyqNzFtaPN1W98R87TL1zw+uRy+x779T/vVSktKG
	E/sjJF3Mc7dc8ApUYinOSDTUYi4qTgQAqP+FDPACAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 96FAA4000A
X-Rspamd-Server: rspam11
X-Stat-Signature: 7rrixwwdumditgyxud9fnzxtpx9bq9je
X-HE-Tag: 1764130860-647291
X-HE-Meta: U2FsdGVkX19fLuHbQC2pRycN2b06z6OrQoLlooEszypIgWY5kud3oCMxJRPEdLZAdLNZp/d+P5cdpemIqnNVZMztETSTzgg0g4GZByKpVLBqtGh2YduU/yn1AA356wvaCdu5xQazF/Ga72ZiH8/PRjMwY5uSBdf8CKQmjspdhv1QKC44zmnwKj3tGu2cTrhbsuIyYMJ8CrdT4XFuOhJ54wuqmwMgA7aq15ym+RC62l0RKrK9zLEsSXVtWBTjeNGdwNqUDgRBOe45e3tyEh+CebkXPUnUCTC5tTk7bnzUjif+dUjBduNU0e56xYvr4A7TSpUyBJp+BlGZemCG2SIMAxir4gnQnpZ5dMxkOP3Cbc5KCL0PI7ZgYifkjS8Uu6g5ydALgPsuaIx7OpV3eUKUo8NnvclW7DgnG566fOzHn8Sf9yQqrKdpE1Ap69dCUKEP9vyTzUQIhSNByDjSZwSWjj4116gI4kq9JPKE0kd3jLCFbANIfDagXI5cbOb3Vq8xAC2iyWw0erNu+BB6t/hUZe1iE2eUhsWmw6FNSEFh//IwN4Qa9uUGn+Lle4TfspLn8gM+3dwR7+KoXeHGknDLZjn2jVgEJ11Uo16BhdpzpoaOJi25QkP3QguKsfgqNv5mi/dpRI7K0vzcsyL1gcDAAgTencNwry0kwTslPR+6w+L1+2uXNBXOoX0rnurlmV5j7XzBIb4xAE29xN0ZuGrEg7JQPV++zRnphtHR8SIiTOrXvcrAdmB9QFv1ix+zruvnSzatIx89/lyVHvcN3orIF8i0T+9y3lSbIyQa0kCM+JxpHO6FsntJwE2iXqE5sfr/T6bYiQMJcR67v7uS8VezZTGe2qRxDileVEUmelZTTuODz4KLCJ1dNA7NDnMa0TzJsT711jiQx9d/2xOzY+fnlU+/qWpopvt98rZ/3RI/lRDNW4SkUNfuxLOh38rc2JOE3TiOo+aHvgwUBLsjutU
 4KPdBxfd
 b/6yrGB4K8oKWRwdP/30xm/ZpJ0s016jg5wL9HZ5dALYslCdCwuCZqHj6apiB1BNvY5DN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 06:47:29PM -0800, Jakub Kicinski wrote:
> On Fri, 21 Nov 2025 13:00:46 +0900 Byungchul Park wrote:
> > Convert all the legacy code directly accessing the pp fields in net_iov
> > to access them through @desc in net_iov.
> 
> Please repost just this patch. The last one needs to come after the
> merge window, when io-uring and net core changes converge in one tree.

Sure, I will.  Thanks.

	Byungchul
> --
> pw-bot: cr

