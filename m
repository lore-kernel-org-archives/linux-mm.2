Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C53C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 06:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F3B6B007B; Wed, 22 Jul 2026 02:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D104D6B0088; Wed, 22 Jul 2026 02:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C269E6B008A; Wed, 22 Jul 2026 02:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 979526B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:19:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B2341203A3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:19:18 +0000 (UTC)
X-FDA: 85015410396.19.1DEB930
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1FB22A0010
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:19:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oiJXS3Rv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784701156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBd1yNpCs6DEPDiy6QcCkhl56XpCygWXGY0ZmzMftW8=;
	b=gcfh1uj6/i4LoMevHstYkAokRRBcRwULEfKV3b+hmw+plS6pej+6x5eqnDULgq4qMLOjQ3
	Exfa9z1ThuD42MQgw1k/bpJo53/zSrV8Bm4E57dv9A2ZWYlvm2ZXuIrpAX0eCpCu2Fh6q0
	EwxJblDmLDIjdzu/LUHTGBdqTLTrm+A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oiJXS3Rv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784701156;
	b=cT+D91FQZC9iXGiOlG0NzEQWjoXjyw0h7oEBm190QwZMhQU5fMcuG2P8l2rCLCNI9pPJto
	Urm7IoJKMowaeNkuMRIEtS4vFhetxv3SM8PWdiA4GZx9TVKeDf4P62XhXngNu4Ngbh9dV0
	2w9YJMcmvThTKySrb7fE811IZZbMI0I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784701150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sBd1yNpCs6DEPDiy6QcCkhl56XpCygWXGY0ZmzMftW8=;
	b=oiJXS3RvBmLpkZ70nE/CNG3Ili7NzzGOWR5nSd9eF7xCldoEix/xiKw9+pfYK9hOcCjz3X
	O4ccwmjZPXzo0kzzBonMYDy5a3aLhVhFyCz+onuvBBKWrbERF2RPPXYSfndNWIAHNquZ+t
	WLcVpTGTZYjXE56y+jkUHpkmCw4XzSY=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	hongfu.li@linux.dev,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [PATCH] mm/memcg: check kzalloc_node() return in memcg1_init()
Date: Wed, 22 Jul 2026 14:18:26 +0800
Message-ID: <20260722061826.43420-1-hongfu.li@linux.dev>
In-Reply-To: <20260721171351.ec213c13afab38b89c14f849@linux-foundation.org>
References: <20260721171351.ec213c13afab38b89c14f849@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FB22A0010
X-Rspam-User: 
X-Stat-Signature: jwo4edn8bonf8y9z4zzbbx4azd693esk
X-HE-Tag: 1784701154-493668
X-HE-Meta: U2FsdGVkX18Cn9Dg3lwOApmEeGimCCY5bV0FsI8MyBQqNb4xpBPSnGYtpEGBm4rKyeuiANc1phPgfkjafCMafCQR+Z9WzywGPLGbXDLl3uiSQnfc8nVsHOMVeCK71vCaxIu9Sw7yiL8i/Dfjml+Ab/fqjHdzaM8GYzBSwiCWm4531mtLvonzL1o9H4WIwmPhW5edXOuXQ73AaXFmcXFd0/rlgSmZ5sSgQ8Kh+fIqwNtHJ2mRTTBYRWnhns4GxAv3+Cta6sJmg7s6wTJA0L4v9N0shHGJvyyN4gQ6Zr1AC0mkV+O/OMPidpL7Y1DsVbbqsRqUrrI/cdk7tQAssnz7gJg8EBvG76uHe6puT7OLdwudZFEYX+9lE0dgjnFuVOod4zMAkrK4E1tmM8lnkgZ2DXocki0toPY6Q38tq1LJUypFa0kZefPX7IOKO6gFrW6eWw/kXKi6YWxu4+AOkMD2lgX/T7WvJNuirLv5btYSOBFbmBO6fR1CF9R++Bv2dxic8tKjI973i882suV962aV5J1dxzcRWd8Q+heXoTm1ZETv1twaSbdeV8XRQ/YNe4WCCNbHUdQj1KbvsciNQv6ymZsH8Q6k/d+TC08zjLyHPJdg0aBJyiXhAWdh/DkP3t7aF0a7+yJGJyTGkfBiOKoBQgpq0YelHMbXVN186olkEKf7ggdgrpfCLsYQo8cgyoSwzl7lxjizZiszOlIXoeYtFzvhYp7uU8dy7q0vyVfzNPztlIVElWFsh8Gu4TU6p3UKD6hI6IACvgWgoGswU4tYGT35dCaFmkVpVRNz6204vzC2FKVG1JmzqRg2uUCmwnq68bjIRldPff532p1kbJVlcNkEzWlxKNTivm9KVRZ7uvKsraiTZkOydhvJElDh8iQp/GYz5C7N3ON5JBmvt5aBYORoizYUrIRYQFL610R+fQnmrlaoxnMhYDbF+rrCAe6PhgfkJLVvtHHox5bMxU/
 YD+g4u6p
 NAXlDJZ8pwF5d9wgUbJvxZOMQPHt4T/BE4d17xpdQ1gtOD0z6p/6erVHzX+BtXPOdkMK78Y8PEO/pycxH807z0TvyEeOq7OOFDgQS5ZwmomTsUNn78y+3phJ3HIIGP2CPfRg/XOO7jAxXXzU7A6bq6hrJg7UsHVxzWNGL7N41izc0xh9hnNOUWjplqC8VmZr+XaIzqNqczygqDcj7UaGZdfeWxLsISKtdLCs65CwgmyayQWVGAU47QxyMYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> > +		if (!rtpn)
> > +			continue;
> >  
> >  		rtpn->rb_root = RB_ROOT;
> >  		rtpn->rb_rightmost = NULL;
> 
> Thanks.  We assume that mamory allocations cannot fail within __init
> code.  Because if they do, the kernel has some ghastly problem and it
> cannot possibly run.

Understood, thanks for the clarification. I'll drop this patch.

Best regards,
Hongfu

