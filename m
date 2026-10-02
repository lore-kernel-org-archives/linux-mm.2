Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BD3CA5FE4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD7E6B009B; Fri,  2 Oct 2026 15:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184696B009D; Fri,  2 Oct 2026 15:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C796B009E; Fri,  2 Oct 2026 15:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3E6E6B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:21:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AB18120862
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:21:14 +0000 (UTC)
X-FDA: 85278654468.21.0006505
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B4ECE40004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:21:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBHsSDNp;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6ZufPODuIHzGF3QNb5bOqql0/Xf5uMartGb9nYO4gI=;
	b=USlU5J91J3oG352zL5lB6lvoSFI55RLzJVmzvP9edBEDLG9HTGKwiMdSmzhZoWCwYEcdVq
	yqAa1Uql4xvGzgLjEsXAE6qjxNUA54lazUIXj5Z4qZwNJFNAaXva23hlO5fk3PFA5oVdwc
	YOSoXXP2tDFWm/A8/+o3D0MWt85B+r4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EBHsSDNp;
	spf=pass (imf27.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968872;
	b=A/tJNI3fC3xCWvNFSgzYoRcEYU5Vs44ckStgTkFYqWVdZ987eY1U68DB8nMTegXdNPlhGi
	Eg24kx2pVEPrVCNV5t/KUDk3WUV7zkUsOVmzshh3eq4Lh+o+TS6oByU2hgWLmw5ZCPJs1t
	PXrmzx80TkGN7CoMDP6O+UraPKg19hA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0628E4075F;
	Fri,  2 Oct 2026 19:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D641F00893;
	Fri,  2 Oct 2026 19:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968871;
	bh=y6ZufPODuIHzGF3QNb5bOqql0/Xf5uMartGb9nYO4gI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EBHsSDNp7SJRGlgzs1s4PvOgtoI+WThEUd6L3zusu14fF9Utndhrof2SlWJ0i39Pe
	 9T26TGOv85czWPVV7eDQXIPcm+GnstsRvy7bnniBlBr06sjbs5zVXiUfbAJKt7wFUS
	 IHKxtSWvSyFeWy8eHkFsK0IlLb0Gqvi+Q/IiYy+/gxptoTtALdupBaU0TWhdtgEtOo
	 8jKr/9WKYjKSH3LgPyhy9N7QeycHORIo0YPIWrXdGLHd6ay0+BofOOWNVw9iIp23re
	 X2F1VUs7t7NeY2p3NQsglPI4wW7nGfL2vE4+9mVc7+PQ1RXIjh0q2jnKhtz/utdKvB
	 4mNxoaGwLxrLA==
Date: Fri, 02 Oct 2026 09:21:11 -1000
Message-ID: <ccbcb8e5f806ae1d29164b53551d61ef@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ian@honeycomb.io
Subject: Re: [PATCH v5 2/3] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20261001-wb-dying-cgwb-flush-v5-2-8361eb8c65c6@honeycomb.io>
References: <20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io>
 <20261001-wb-dying-cgwb-flush-v5-2-8361eb8c65c6@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4ECE40004
X-Rspam-User: 
X-Stat-Signature: ghubshwndptqfpstixainjpgysse36kg
X-HE-Tag: 1790968872-315693
X-HE-Meta: U2FsdGVkX1/aXSlI6gdWmI9FeJsL+DrDF38wrjL9S0+LvT+WoWz5lBAZuQ5m0RZMJj9lU0A8KmNB88AuTDUlaN5xTiBDpwBXEe4KpIuhXRJ1GA8WV6CrHM+zRj3Qi9tmS8dh6kMvVnmhKiu0an0kOdNddcNqZYto7rZwQDn95uWpSUn7O9AuBu1mWwzSDrt2MduZvzzawr6iOxvXl/n3QhgGr/pkUTyVaMENppdJKSs2XnY/1ejQYCJ7lQoA99YuaWLginbpPfn1hhc3FQr8QQJMcAkSV3GVNmQr0BFm+3JcCWMxvC/GPp/ZeFvuGqmZW6zPM68Po9fiuZZRfR0lCVPItHjw/DXbcB4yUhHgU/JOaDffxvSQ7fx0LHBYzEmOT7yehG1gFHgg6rRp9ZmXPlZ1ZtF45QkYI8tZHYlBCYKk972cU/or2Di3T2yYEZa/gQ6pcbq+o1RNdcmynGvNvwN/sRe1gAliSA3qTfaHSs1Y/qvKtr5WnOazqo6v2ktMl9VEYEcAKiFzspW3eprtL9Pxgc58l4sHDSfgv4A5MYd8njBkZcXz42Hbnkphd1TO8/xiXHAwpCuOsMnM8AcSKoBhyHCfdHkWfyhnQmqiEAFCcnOOigS1ZIU20P3KZhtkG5K7TU6vh9SoBkX+UtoxJehTLZOWy1BmsQDcoTiqGtTfi9I8U3/B+bo+ITJniyp2hwnqe0CVj8dW1o4aLvR/lpp/yCIWuSqSy/nRBHmRm+IFqfLQc0X/F6Yi429r0WLZrDUVCpENGOv69VC+mmKp4yV8KsktdZb03764YagZhM51te/SUSMUtNzFkrPRDuYV5zI9Q20hVHHhpWp/ci5R39bOlS8Sd/gu9gcfX+MseSLh8w0MHWbgYdIJx1EaI2KF68zodtJToBv2LM11EmyusjOAUznLZxiGbVtdDozG9QaU6A06+0W/fTdnRBP6vNVarhyfnbvYZtNEfqD1wCK
 nOuxEKiK
 A1AZlN2K0G/WOhts3ovbmDE3KM8g9NyImQ2LvTZlpGkeCbPfc1gNavxT99KHJZa/4uvbzpyNF0DjqMym1Tr61BIi222l34LBTgN1IS6j63Wpb5lEM5RDRKe71YpiTRk+dmwJvcNgFLREEuoFz7ERlDWMKwDWF6hwHhfM5uj6r/0CwMQwPzlMH5OppnL/eNPK2quCB7ZyO7tOjNaGcsM2vgy856ATrJoTlSHeYZTbmHEPv4W4Tmyq3CdMhBePbkTiZVdPlnnqSqDgfcrRFh2+0AZxIuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Thu, Oct 01, 2026 at 11:50:20PM +0000, Liz Fong-Jones wrote:
> + * The wb may have been killed and its blkcg association may be stale.  This
> + * is what foreign flushes want: they target the wb that owns the dirty
> + * inodes, which can be a killed one.  Use wb_get_create() to get a wb to
> + * attach inodes to.

The next patch attaches inodes to what this returns. Maybe just say that it
returns the wb in @memcg_css's slot, killed or not?

> + * This function uses css_get() on @memcg_css and thus expects its refcnt
> + * to be positive on invocation.  IOW, rcu_read_lock() protection on
> + * @memcg_css isn't enough.  try_get it before calling this function.

This describes cgwb_create(), so wb_get_create() is where it belongs.

The struct bdi_writeback comment in backing-dev-defs.h and wb_dying()'s
still describe the old lifetime rule. Can you update them too?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun

