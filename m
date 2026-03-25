Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98F2FEA80C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 05:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A0B6B0005; Wed, 25 Mar 2026 01:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBAF96B0089; Wed, 25 Mar 2026 01:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1016B008A; Wed, 25 Mar 2026 01:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB7F6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:54:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8528160765
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:54:34 +0000 (UTC)
X-FDA: 84583520868.17.54FE4AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E36DA120010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:54:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SnazHkGq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774418073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiXY63tJjy9L4MluCV3BfIPA3OSvQI3bzGr1siz23CE=;
	b=YF6qQG2SiyQtfF5XoE+wtvdX0u0/JqIZf8abUT+fRRIvX77MTjNiEUMBR11SLTqzsGAMoG
	sQ6AMR/clKXRHQZuXQo+hHWzGdRe0UDiwpzOSCcz1nJFTuhXMnoiUsQ/vR3tcCr/CMX5S/
	JLQIiETlAqmoebYL5544DJ43Tv37WK8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774418073; a=rsa-sha256;
	cv=none;
	b=vQZUqfK2X0nCefeYUCPKy1y38mUnW6zP2OVQ1a/AXhKi2DaHNw1fp1lguawRdZS0uE6TsH
	x+Kp89jb4MGnASAGikqWSn1HJqbYEzWDOjJfCpTvQMy+fvfzXP7fVQsUK741wbd5SzRlRP
	47MHJKbo109UU9GO687LyPncGzx1Fdo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SnazHkGq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4D8940A9E;
	Wed, 25 Mar 2026 05:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED01C2BC9E;
	Wed, 25 Mar 2026 05:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774418071;
	bh=O/DfGMV6h20F3xTRLWmaiDK6+ZYFTVfswpqJcM3DDoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SnazHkGq6JmwGnlOGiQaBskU5RHp/1iNU/1a3S6AkzwzEDTXeA8kCn51+5lNh/LLN
	 zBoNzooBearz88PpiLmylZT1bYoza/Q7vPkXg4wPDvnQju4FBJw+3BIO2JbsR2/Cad
	 ovyrtEVZt0oJak+N7WJiKVITecyl2JgLZ3ZXGmIb+rWwceEYFv6mIXa6pk1T0yShAB
	 roDL3I1xpHQUS8GtNWy++GhUlWcI+KPsZBkWlxwLcMIrFNSDB3CWhgybTwFn6y3YMS
	 E3udvhQkkE+6kKZoqPUKufcVmDPKN6ylBlgEIiojIEtZyWIlQi+5eFsPEq5HLtYgsv
	 mw2sTzshWW67w==
Date: Wed, 25 Mar 2026 14:54:29 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dmitry Vyukov <dvyukov@google.com>,
	rcu@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab,rcu: disable KVFREE_RCU_BATCHED for strict grace
 period
Message-ID: <acN4lWXD4IbvVxWi@hyeyoo>
References: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
X-Rspamd-Queue-Id: E36DA120010
X-Stat-Signature: pj5k4trdnem3x5366y4ooyi3st6hm9ow
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774418072-37398
X-HE-Meta: U2FsdGVkX18egfli17ToQ50cH0bxowTQevX4xSEbW+6yM/OC1OPbGZprtRvF4p2fvrzF6hNYyAnIsV3v54uOalzNCkVzb98fNlsHMDcSh4TPcYjBVnp0x6vViwCCNii3vJnxkM7ebeg8nh6ZhE33tAXsl/DEhtQzAmQr2ReCfrnkOoxBm5vbJznAakB3u3Q8NnXRYhO9Odj22oPjttaN8aWMqPdZ+cs+YnaQ99SZGsfdJBmljGWpZcZhNYzc3IjTIeFJlkTNs3mE2XvgWF8JF7cuf35+wLkRpp3KvS3arCp1wqmQ1ALZ3KkbNJqURMPxVsqSojY9uLNiwD3oHKy8Bgbc98vvvBE/qazwOxBtZ0371+J+UjAMWDMTiuhRlB5ZHw69OEOPoHHOiB3yEUDl0pkfinJwDqoVgDfYJS42+FdRIHeHDXIVTTTES6qTOvqfWW0eoGC/I/41kRBvmmnR66FiVuL6DgtbkG1VG6gqhAJSD57gJfLl1Ke0SOF8vz1G+/hfd+jzhruLy6UQeynXjlg5gbarCzm0Mzb4p5w5FKuzeH79Em9+EVsucLbOzmVSOW27bnekU0zvmZ1hznkZ5h2ej8/8SF4Al9EDEvIskHGUjum+n/cJtqeDXAz4EnRqY5BNIsH7UliYGvVKjaMHxW/Eh4iAfkvY47pLkU0+MG20tKqcywN3BRRPviHFhrYpd8/HRXwCOYDYPntOxr5XQQmn8i5QORlWE113Lab63tfaJUKesDgTU/1UVzr4tXPe70SLOYBMxwpMa6Nqj9C6qrEN9t06V64kkQJt6R/HQfa8ZxhyzlxmliEjU0sNBuEQTvY0ziIgHe1HgqY1618wPkOeQJYV2VcoYOgVfBnYxrvvAXFpwJ071Mu2h3zV/b5pEXPSiFk2segdh2OTDX1NmgrxO1gXkpA4cNveXCBeaGFVSu0XfqCQLohDu1hCSg0YuQgFWJpv+rIgSRFcpS1
 vrUv/VYz
 TsztrWg7ym3bG6nc3s8ijQ+94gNAY7WgxXzGwipLCtO42yzrmwsIpxM/0eERQNedP5UXPRN/gDywOyP7aSzYQsu7RaZlK/vzgDMU4332XHoLAVQL1B5PgUD+ZoU2YdTvqjx+EUMy2fR8BZ8WfyqsnG9fZ/xZc19nLVOJxHiZ4nxlW92R/fzYVogmWlcTl6MC6aj4PoXla6G0CUH58zHWDZyd0mzEApLDVLM+4onJo4lsaZtTPuUf2Xi3mSKSsm8V9cl91ySOluJtmmYgZNXpHgVZWMGUxL40NPHqOOIKmtlmtFXoAOFdMf70fJnHmUF2bSf6BAxVT2VdRixLAZP0twsf81Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 10:35:12PM +0100, Jann Horn wrote:
> Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
> so that kernel fuzzers have an easier time finding use-after-free involving
> kfree_rcu().
> 
> The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
> callbacks and free objects as soon as possible (at a large performance
> cost) so that kernel fuzzers and such have an easier time detecting
> use-after-free bugs in objects with RCU lifetime.
> 
> CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
> RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
> expedite; for example, the following testcase doesn't trigger a KASAN splat
> when CONFIG_KVFREE_RCU_BATCHED is enabled:
> ```
> struct foo_struct {
>   struct rcu_head rcu;
>   int a;
> };
> struct foo_struct *foo = kmalloc(sizeof(*foo),
>     GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> 
> pr_info("%s: calling kfree_rcu()\n", __func__);
> kfree_rcu(foo, rcu);
> msleep(10);
> pr_info("%s: start UAF access\n", __func__);
> READ_ONCE(foo->a);
> pr_info("%s: end UAF access\n", __func__);
> ```
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---

Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

