Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E9DDFAD3E6
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 01:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408696B0005; Wed, 22 Apr 2026 21:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B8F76B008A; Wed, 22 Apr 2026 21:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF3C6B008C; Wed, 22 Apr 2026 21:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBFD6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:08:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BBF51403EF
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:08:52 +0000 (UTC)
X-FDA: 84688036104.22.F447608
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 990BA180004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:08:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D9UVNgCJ;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776906530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pI+g120kEemqAU+sR9GigLZxDiiz924ot+1RnRU07EM=;
	b=yTWj4LMvZ3iyvVzJrlbU42blauEdEz3CvWeTghWeYZHQUrnQs4exj6v0S0Fggn1LC4UWgb
	i3T0VLf9CUw9pRKKslw0BXBZyZPYrGgpmJdCBDIFNWQBomHccf+0H8mZfMOXs8uCfk71S0
	NNMKHGzqF6tMs1nQ3h+JD2xGSa4EZgM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D9UVNgCJ;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776906530; a=rsa-sha256;
	cv=none;
	b=z22Xe8ifZMqtzk3WsnE3yaEqaRdGucZIxIh3tyJB+I8rPbKLVVh1FXgAxY0kWNJmR5XUWN
	VnTkiDyyZMlStVtQfKhuFzQtFHOACB8+81uJWKyrKW4UPFVS4vP3jHD2OHxxnDvnQ0L4O+
	OKvLzH5YqQf1cIkqhmQ1iMIFk60o31Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DEC641AEF;
	Thu, 23 Apr 2026 01:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08A5C2BCB2;
	Thu, 23 Apr 2026 01:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776906529;
	bh=eM7I+z11rvz3UT8atgEe1MBPkEiQna5s0ErFx4g2s9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D9UVNgCJ0cLMPrZuVc38yYovvZZJAYFz6SSYgXByaedaAsv/HkddogoZqdKeWVAZK
	 7TSOt9gbCNoY/DoNtxW2MfJxhwB65t14eX094IaBtK5IMJ8RGo2YDl7GTk537eDuKZ
	 jPU+NZTpTZ72mLsDkiUOMkmzOOb7yLdA2t0sPWbw7KrF8bX8/RgP636UJOFnKwDNM1
	 hSoMYksqqIJNAWbCzM6JzX4IHui8Q7ip1SiZwGfjW92x1tuNOxwwyXoNTaIw2AZmyF
	 LOTq/usjn9dBX+nzYlJv3u3ARJvpA1eBWXsw6NeFFQl2ETBnBA/YlzjKTqpObC0HEe
	 +f9aH9iRyCfxg==
Date: Thu, 23 Apr 2026 10:08:47 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <aelxH--hZkCahPv6@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aejeVK0J_jHSfVhD@milan>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 990BA180004
X-Stat-Signature: 5k51pubip4xsqua6tkrnm4muut9jn1wr
X-Rspam-User: 
X-HE-Tag: 1776906530-978045
X-HE-Meta: U2FsdGVkX191tzUVpazNzp2A8dYitmsj6JSGVpX+CZGAWhUuF3eppQQnsgY5uI/ThiJ7LRfMH9o6TwxHEgf1NESDRCQsIQFLP3u+EXRkatcwefW5K1/x4GtqGxf8VpmhKBLun0JLSXSEtqX2xDY9s3MDiYXO9Muqtf2XstFM50Pn3yetgYecd8V8rG0R3PxHkDn9GXfQq6ctBvEBiL8+d+zirP8IUyRHGXK57h+1LfWJ1g0TrrUPdD5vQPdlXwv22i6jzcZqxA8GwNRZOOeil5LCdmKrlt7KHxZvlCms5xwngw9Apf5mpII36oXdS27oQSnxsRG+VArczozj6elYiVavPtXToSkKYD0j8DDC5d/Qh/bzuDGtOkWFfGqQAJj6kZGCmBZlK38jxVkGJEFfduNmD2dZlvmP42bVb+EwTRLV8Kh3pL9THvN+mI0CdCwaLXa4Myx+x+TMxBr0z42+IWQbM/R5tbxXWDNhTpf8abIKsb7g2ZVC/NxTZwbpjDpf83678AJvkwWu5nYB70FnM6lJEn8Z2Ruwa+UX8xGiiTBHyFPNvs/sZ+9SMZr5vLum6hpjugue+PCqulpLhWLrTZ2lI4Suu2iWxASCfIV2YLZhOONVckzOK5KZowYiq3ZG6WzWRTL4XYwz0ivxcRf2Nf4yX2mJEkXljnLL88jFmB3lZWcQhqzpQFQupc4wVm5xR3X57YyaLb05v0R/xucos4n1fHiqCEwl9Cvy2g4SR6GKX/0LWxiBiPNtZvfvtq1IEXP7chkx0QdvgAALryT9tCtq/xGKIHFgxI8cUlcFisimlbY8Lhxj8i/ybq8nJyUw81uY2p8IwEf5r4C8yaPdbcCs2BqEtWuIpoF3ZfTIY6DbcbfSxhR3S6UuZ7kdu44hfoZ+JGJC2jXB0oe3h7kb5WQuHSdTsHf1jj4rjs0BNcsh9o+MBO8AAwRht2jrClmz8mOTjrPkLjB+lnlamHU
 6/IAKc1K
 j//vakVWIPNDgNvAHYIjCJ6Z+Hekk7A1fFKuV9WHBD4ksE5CPHW+2Je9/GwUoc2b9+QI9srbvwIGn7WxTFmwydhFCFdAqlulPQGWMEEGFbkL32Vy5vpu+LYzLfz/Sgga3xo9K37B/dDi4EmOTcf2+1mVh2suV6dgh1nB+I7znvNAg6U5LApRmsxD01S3juav4dGwt9ke7C/sWzkgSIq7Qoa8eAqMX06/3adRjAalXbw0NSshLxg602IgT2hHS8yVBAjVaamkdDBF0JVCqklpBmSPyhYFn82nHQ9hLyrosGxEJTiqmoK9c+IomWFNU+RV1Ocop6EjvjzwSa/qNkt2t4jfZvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> On Thu, Apr 16, 2026 at 06:10:18PM +0900, Harry Yoo (Oracle) wrote:
> As discussed or noted earlier, having third argument and check the
> entire path with "if (allow_spin)" is not optimal and is not good
> approach. I do not think it this would be a good fit for mainline.

I understand that this pattern is pretty uncommon and adds complexity.
But there is a reason why we're doing this. As Alexei pointed out
earlier, even rare spikes of irq_work hurt performance [1]; that can be
avoided in most cases where the lock is not in use. That's why buddy [2]
and slab [3] accepted this pattern despite the added complexity?

[1] https://lore.kernel.org/linux-mm/CAADnVQKk_Bgi0bc-td_3pVpHYXR3CpC3R8rg-NHwdLEDiQSeNg@mail.gmail.com
[2] https://lore.kernel.org/linux-mm/20250222024427.30294-1-alexei.starovoitov@gmail.com 
[3] https://lore.kernel.org/linux-mm/20250909010007.1660-1-alexei.starovoitov@gmail.com

> I think a better option is to add a separate kvfree_rcu_nmi() helper,
> or similar, and avoid complicating the generic implementation. Otherwise,
> the common path risks becoming harder to maintain.

It's unfortunate that I didn't provide performance data to justify
adding complexity. I can try, but apparently you're not talking
about that.

Rather, you seem to be arguing that you're against this pattern
no matter what the benefits are?

I'm confused.

-- 
Cheers,
Harry / Hyeonggon

