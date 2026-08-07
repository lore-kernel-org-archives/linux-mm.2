Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BEABC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29C96B00B1; Fri,  7 Aug 2026 16:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB4D6B00B2; Fri,  7 Aug 2026 16:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF2346B00B3; Fri,  7 Aug 2026 16:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFC356B00B1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:22:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CFC71601C1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:22:45 +0000 (UTC)
X-FDA: 85075596690.14.4917C00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1B8E0140005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:22:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oRqyv2OV;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfSM4/6djJ0RX2cidCyfBl3q1rP9l58dQUE9oj8yHrE=;
	b=T3p7SHqFap5IqHlapTiA14kwGZH70YB55uJ7SWDCJJ1WJNy8nLvnZA+d2Cu0DeT+8C+Wln
	QzAr1nbBd0PsmALmq34hskMRzNwuynbWLCSDnVGeNk+Kn3wMbKOjIuIm96S4iKC3NgOmMu
	BMwz6J2pWX+30kteFA9euwNtiNoguxA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134163;
	b=t549GmGDsRN6juef2HmLz12w4VC1uEISmQNChPIgELXJvYulCCgVz4IUKa5cv7yKLZb80y
	TLmDUCA/2lF1R5XRFkhwd5hVnbJtKSQA19rklFDX/Q7DAUc+7eNBxt26IkBSRy1REFe/Er
	npGGnGo98slYtGzZwshDTOaG/4Q5F+U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oRqyv2OV;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82856600B0;
	Fri,  7 Aug 2026 20:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF51D1F000E9;
	Fri,  7 Aug 2026 20:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786134162;
	bh=EfSM4/6djJ0RX2cidCyfBl3q1rP9l58dQUE9oj8yHrE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oRqyv2OV7k8cVASjY6aEdGukkuydgr+mmBv7o65Twwb0+O85VmspSOYLKuxd5w13p
	 kLBXFCVDgSMCqOuRxMKBw4DJbrVfx+xaOnoX/QxhJ2mTF8Wick9wU/vDmq+uJljgpz
	 4/OtruoH2ElTHW4enwYmMshaxRmCeVRdFig22RHg=
Date: Fri, 7 Aug 2026 13:22:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cui.tao@linux.dev, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 0/2] mm, memcg: fix memory.peak reset clobbering
 other fds' watermark
Message-Id: <20260807132241.147c758d2904e00daf28ba4e@linux-foundation.org>
In-Reply-To: <20260807090000.1532495-1-ridong.chen@linux.dev>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8h39q6791fjjciy5kpmgrc94zjqnyogp
X-Rspamd-Queue-Id: 1B8E0140005
X-HE-Tag: 1786134162-213314
X-HE-Meta: U2FsdGVkX1/38CDGBYGPKHGRob3lkZpEudYtUnMDwSWQMcG09s+avYYPBZCIVoEF9NIcZt/0UZn1142hsKhVwb8empR9C19n5FnLNIDr+M9dxA3PkhDa9qiZgnSl4a7USi4l8aT92RW+SRUSe1Dd0GlhveS1jcWAA+au7ycz+3rjcSudrgv5oCUZ5HUlBYz3Wjx8ImUp2puZMfFDGznv+o8URKnEElsO4lIEB/Jk1WL4vcpMMFjxa5eL4sepfD8z8W5a1qJKYqBwHzA2ttkOGfLaIpvdXLhLtozKlX6uY3j1S9eGe9+mYv+Ipy1du51qR64v80mjCiI8DAc5XUDmGJFlBmADYEBbC64FOxQJg7WNQJ9ifTvqq4zD0BCRcH7tAUjw927dDiMHoP+tA+34viLPFmGVmWf8jkIxblpYKZAfqlqP3xdxgMuMbm28SyvssZPS7l4pM20akypwBmUIJJDuZWDkmkYN+gzdQ2m/uF+LFaEhDoixYCqB9DESrdDuCt/HLKwxQpal0L9RldNI6/6FXixXVg/k31/tkjuOB8SblO0uqFUJdU6XGVIocJ/3/N6M274dondsWwv6LMrFybKXMsm5wJky/Se6nkNHGyDLTqylOyc77Xw1LSGDAsfpLH/+9tfBUseLSDuSrjogBVhN3jJbAMVAo38/CNXHF1oyWdRqB8TLXmFHRlclbfMw3NxpQVhnn6Jh55xiUeAZfDw3QfpVxq0UbYEHhYq1w2vqobHckN+kCnAxH40ElBNFJZlHSwvUmsu/OOu6W1rO+ctnnZ8s7DqOs0X+z2RFWAqqaZxtRAQE/P3ph74rGC/Sa2Q+042Zc0Y3evacyBckP2bj/rY5D7d4HDdt2MeLOrmoErZRdfCeffogRvdJbAuOTwRluR71qbRCSu/+GEm5ZQlvr5ctyJKKuEGBO+N8LkTcmFR/y3wXXwB4199UtMzcOnsF62HABVJjVtjxw8g
 CQjhZVRe
 oJtfB9r0j1JB7/NJwpKFKmzqYPn/IpGjtCjoVoSg8wfrzyHv+TNKv9qEr3fBhgQsH906DXfN7WQmQ56zrIELql1VLAShkBZ8pZJzbu549AvlfHx3LDc2lW9JzdB8G77C1Fn+Ltzt+Zbdcehqe0ZbiCJk2ZMt0i3KApWwQX+mvl/jtUJlzEob5RVEYk1QJrebo4TI2JqiVMj5QOssxSz6W9RhLBOJrdvhZZaG5pqjv+ErqyGSBy+BFLCnXvaBZiPUCG856KYigLoGm5gm3Tg1w5PQhCWXF799m+/xcn/CCFnb7R33IrILGAMaLag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Aug 2026 16:59:58 +0800 Ridong <ridong.chen@linux.dev> wrote:

> Two fixes for the per-fd memory.peak / memory.swap.peak handlers added in
> c6f53ed8f213. Each open fd reads back max(its own value, the shared
> local_watermark), and both bugs live in that scheme.

Thanks.

We're missing the preferred description of the worst-case
userspace-visible effects of the bug.  It appears they're quite minor
so I'll assume this series is a post-7.2 thing.

Sashiko might have found a similar race on the writer side:
	https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev

