Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910F3CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7238E001E; Tue, 11 Nov 2025 13:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D878A8E001B; Tue, 11 Nov 2025 13:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E3A8E001E; Tue, 11 Nov 2025 13:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B286A8E001B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:58:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7157C129CCB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:58:46 +0000 (UTC)
X-FDA: 84099237852.20.FA77374
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id BC42C1A0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:58:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CAmFJeGW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762887524; a=rsa-sha256;
	cv=none;
	b=WXKxeLOOqfOtbaACxCjNyZOUiXVi3aKhWvSmGvsnJh+89vcy6pmz0WCzgV+4kgtNGS0XBG
	s7Y/OOd9AJnS6AR+WgEotCfvQBjl/EASfCNdLZ9ZtvAhsrWx6rXIlwUNDL37q98bFH4YLn
	4qqYgieYaTfIQUMi/f01AfWg+8T5uRw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CAmFJeGW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762887524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGVQvQg8MiLEgx1G3pQPBT8+hmFVeqeHvps6Z7l8J/w=;
	b=Wx1US0x2vC0cfPBqZZs5lefr7IdGdk8COQQ6GsRdf1vEpoK3395k4VefSarqYr33RptSqq
	Kv7WRbkTNKhpbJfXI4Yg6vQFQPBO4kxImK+VfgV39oBz1X7ypWpIvX9xPpOCT4dHTfiWD/
	3ja79pFEKFnoarccVY6CObrQjbVrouM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762887520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AGVQvQg8MiLEgx1G3pQPBT8+hmFVeqeHvps6Z7l8J/w=;
	b=CAmFJeGWCZJN57MY4gwWybs2dREiErDYue/5FkpwaTUcKoSHRYBd+iwgP58+4Ya76HjQaQ
	aTh8usMbQC2DeyEzHeLKJQBPTjn/lvHDdqglejQE+XTtesJbXwIgdjEyyGCRDD9nauKniU
	urGosVTQFZPdErlV2MyeoZQoQWc4vRc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Harry Yoo <harry.yoo@oracle.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  Vlastimil Babka <vbabka@suse.cz>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 2/4] memcg: remove __mod_lruvec_kmem_state
In-Reply-To: <20251110232008.1352063-3-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Mon, 10 Nov 2025 15:20:06 -0800")
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
	<20251110232008.1352063-3-shakeel.butt@linux.dev>
Date: Tue, 11 Nov 2025 10:58:30 -0800
Message-ID: <87qzu4s8fd.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BC42C1A0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 53ze43umwk4jqd4pcqi48xcb4rif1mea
X-Rspam-User: 
X-HE-Tag: 1762887524-733139
X-HE-Meta: U2FsdGVkX1+ONyOKoR4Fs/tcm04VGxDAjVepr3gdNpSF4IAX7De0q0FLAIlalRPWVfzgyaXlj+n5Y1IDU3vAH9X78lbtIXpb9eTpttQxBb9kh0Gsk8TKdEwO+sZmqd2KhmCjnrkMJ/5loczEyyKaKLn7v3UOodAhb3iansFlpBAd7/8Up9X4uBZEO0bSuiJ9fWXCyMQN3q7TfQCKJcl9JD41kRJTon7a36ddYOKS1G5tiELhe4OPE1IZZ+q16tDRIGSzvIOE9rN7t3n0vR8Oo3MTWa90eMJu3JLWJYMxo7RM92ZI2UUbsxN5FQTbM1WIk/VuNFmiR2HvlMmcz4kSXaDcWMLf4b/ec9X4Mg6tVmU0w6RQ6C6rWFjjgv/zYr2cmtls6OpOtch4kaymAtatQVHn/3gcf5bkq+dSLMTYHk5Le2usM2LABN2vclGE6xNyKyLshuulyyYoQeV1yeJVNsw7lnFIeQlEWCMNziUZvllYX1VcYntoHu6u7GMk2fjs0ksqDigVZy8oRc6K9kWdVR3tDnjKcw/dCY8Eu1twoNILzZjtEU7ZRcntYsG/q7bdDFDGCna/iJQZF1J56cd4etF3zP9Bj60aORCvgkmiBbBcDQueaI8Fmsh5zX6bbFjxs03042hhTItEpLDLjDaqpo6RZew92MYkdWwjh7vpMUcYTCB5OSUStGfnIxUlR1YZS0v+c1xe6JBBLQ/5MUQJKbuLzeJ+yYFlj60rm02i+I8bJfDd9OSAh9OCkmIq4VEzL+h/2l72izz2GUnZgatQoDs84CTrOUgiBpyltCdHx6cYxVfeChVjoyguZTFZ4vYfo0fDQPNpAgBxSoeK3iG2u85x9FThCGI06yd5VJI/JHoC7uCFY/tYWbGhAsf0sTI90PYffint1xjs4UPD6/iB4y3ZcPpnRd8H5tR8gId6fY27cSJcrr8qI6S/01+hp1giXiLrrNe+gjxCQ+JjfTm
 ZIPcsWIk
 FEtANSH2vE+e+ShnnoW1gPmS7gs0lkyVoo9W1B/ZAyzk/Wa0vOkIMdjR11pi8S0iBqCzLuQEmZHFpiW1/ubVHNzF8WldvxJudtLZ/2XwRq6j2jx/Vdb/1R1PC49gyKY1Vw9x+H/x9Bjo8NUKY1eC5fEUV3ePzVenjMPOIcCiPPlJcu1AFf9xGLF+x2F9FEQStgVDL3ea8Cll/AOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> The __mod_lruvec_kmem_state is already safe against irqs, so there is no
> need to have a separate interface (i.e. mod_lruvec_kmem_state) which
> wraps calls to it with irq disabling and reenabling. Let's rename
> __mod_lruvec_kmem_state to mod_lruvec_kmem_state.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

