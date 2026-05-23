Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052DDCD5BB4
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 03:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4286B0092; Fri, 22 May 2026 23:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BC26B0095; Fri, 22 May 2026 23:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8456B0096; Fri, 22 May 2026 23:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 094546B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 23:04:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81F02161AB8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:04:29 +0000 (UTC)
X-FDA: 84797191458.29.3ED977A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C74CC1C0004
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:04:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OxZ7qaYn;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779505467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1x2JISrh3Dwe6yIGZekHdj6EEzaS+4fu9X7G9pxG8Q=;
	b=r3DWeEGjhZLoprPAyvv3NcX+uwzcKc9BDnX9r3VYH0rV4nG9/LFPpKZLbwvtGtJ567ymo5
	WQyzPXG8iCJQ4IQfbJsNqtLnGXh0TlbzQEwa6dvJoJBUR6RjnKpPGJvGfmi7gNmznU2oFF
	nMLrLA/aWVJVZaQ2gjcx1yGx93RbEaQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OxZ7qaYn;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779505467; a=rsa-sha256;
	cv=none;
	b=3cWqxR8t8qSL+KmejkIHbr6yILvcjQqXzHPA+VckWNfW4mNoUvpSCLC7Up+Mu6I67hrOJc
	Zt6UvGxenyUZCI3wl1r1MI/PKNrhCbjV3Ax03B+diGSBudHUcJEfX0CFy0Hluk2oorxrtZ
	NIIoL+4XeGgXfluukAdsWYLGCOv1vms=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B6B5B43EC0;
	Sat, 23 May 2026 03:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599211F000E9;
	Sat, 23 May 2026 03:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779505466;
	bh=r1x2JISrh3Dwe6yIGZekHdj6EEzaS+4fu9X7G9pxG8Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OxZ7qaYnJ3G9EpzMz5UXmxo3kCKStC7WPBDIL8oB/xs1EBJ1BCroi4HZZsPChJTXO
	 9ADKjy5bbQik2UUrVHKcsIpO8yHt/bSSHP5duWj9N74L755ZP0oJFICWBlQvJT3wkv
	 MjvJ0QaFdWG+SLE6r0+0iE8O0LpnolE4ur+Oabls=
Date: Fri, 22 May 2026 20:04:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Message-Id: <20260522200425.cbfdd84587a528faefe63ede@linux-foundation.org>
In-Reply-To: <4cc3db44-66da-47f0-815a-4322d0d3df96@easystack.cn>
References: <20260520075641.1931080-1-zhen.ni@easystack.cn>
	<20260521172057.84537783b60ff9cd0abadf76@linux-foundation.org>
	<4cc3db44-66da-47f0-815a-4322d0d3df96@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xpx84zyjfnc8q4du6e3opp9u4fgfxjwo
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C74CC1C0004
X-Rspam-User: 
X-HE-Tag: 1779505467-478272
X-HE-Meta: U2FsdGVkX19WHNFpEKGxGWS8fO5SyLLJXPVxuDc8+52gsW6fooKK2OpgQJIsI/Rt5fsHGL0tN0i9yKcR5rfXG18NGO7iL9YleBLmtGqcPIXZ5/9/0EWrcSmd/CujsBFwGzyIjMcPk6LXkm+4LpztQ9PVzCZ5KaQ/rF2TDaQAATFg3C6KiR4rpBaMNMn+UVIXyouvJvY2u8dhRg3UXPCakkn0Gfb9Jyn93U/aUPDcsCiUO+OHpYyGfB87DYWsUNnB0m8XudJtW64YlWifCdizD9VFAN1YskhV6dBha050Lfu98nEyZ0mbBQ6rpXuoIZxY0FooUlBO8UbQ/HeHRzGJcDZEmbmlSF/d2BAQN0emyCuQO7DoRalP6WQ4ED32ifdMwjj9odPQVhv0upVYcKy9sR19CL//uh6y2UMnXjdy77UscHcensz19kkRrQo5hGbIoRD63kLvyDsUnpXwaHTH2sVKrvRbdiRcacWQqV32ZCgfLoryOEMcTPROm6IiblKWVH3duGimJqPQ64uA/+cr5Z8bTZkM0wlA6S3wJV4kDuOZqbAqomUrPjdvkWFIH9XOeucKjjedf1CYfy0NuzVdeN63tDg0+XRlSLMTZ8/6GPRYsUdkDzp7bQyMSrGFum5X3osHIfEV5Ogr+hlmKIKu8lLd9xKmzdAhz4AMpsfgN8ioKjo3PnCTUbPDk+8mx4iMBZsqW1i9U0xuZcHwF0Q/s9quh5VghT5aaIu4Y3+Lwobd5a3MCsPMQ3DlfAqoX7kKRPURP0Vpx8z9zWrH24trotR07SzPAYWQpCDMXNXzgfbV+RMQpSZdaj+6YcWkQ0NW8pUeqF25iaaT7LbNost8C5CrflYt5xpUDupiY2UQn/355waDniCPb7obBqw4gfoXOioAVBCOz2Gc1zj/M9+nywqsHuVZLv4DUukSptyKLLCbgQmoUzkVZCYMm2YtolFBMDASDN/5k4GmNJz3nvD
 nJAfBMTk
 3gSC3Lj4aCqWxmXvUOH7pasMNqX+MhEzO4E1k10NFKylXaFtJk7u4cNznUtjw0ECSqXTfAyykAqYikGXrjvj0vZCMAOXKrC87vnJbqyTRnKk2kWcvKYw8YfjSy7PZcSpFn/A09YHfnYgig2t5zcD7XtuCpUe6PnwN7YTPVwF7+zFQT5G0We6/05xR3nsghaStB6pd4op1QH6ZAYBlSTaECC/OSL8cQoCBuXxdD/uk3zi6aQlVi6T6H2tTdQBMVJAqlHgR0xUNwnuO1lRI+fP5zQpzrfr6ngIhvH6l603hEZwNtO1CuFF4IRX4DEBnPU3Ba5SJ3AqXxuli6TVCZojiZoKDYIaB1tuTh5GJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 16:39:34 +0800 "zhen.ni" <zhen.ni@easystack.cn> wrote:

> > Thanks.  AI review appears to have found a bunch of new things to
> > complain about.  Can you please check?
> > 
> > 	https://sashiko.dev/#/patchset/20260515091942.1535677-1-zhen.ni@easystack.cn
> > 
> > I'm interested in learning how much of this is accurate, and how useful
> > you're finding that review to be?
> > 
> > 
> > 
> 
> Thanks. This is a response to review feedback on patch 1/4
> (mm/page_owner: add print_mode filter).

Great, thanks for the detailed accounting.  It sounds like the AI review
was helpful for this patchset.

