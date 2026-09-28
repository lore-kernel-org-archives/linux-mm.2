Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857F9CA5FAB
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 23:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B18F6B0088; Mon, 28 Sep 2026 19:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262106B008A; Mon, 28 Sep 2026 19:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103566B008C; Mon, 28 Sep 2026 19:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E95D26B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 19:56:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 763641C273C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:56:16 +0000 (UTC)
X-FDA: 85264832352.17.B5DD770
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C011B20005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:56:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0mtG3IS3;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790639774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NduKmuGz5k+Yl2Dj4XUx7MOPCMJ1dsEeFTs5x7PbkCU=;
	b=4eHaQULcSKFgECF1eWwySmfx7fdctzDHxTb8DHvNn4G2ZVHThyDIsPKCLdnHyONqM98i8p
	dqrgFySSC22xQ3U0ydPhq8lWDUcuEqeYSrvq5ZWDva5FTNuChxt+BqVZpN5FEe83Lsvg6y
	V4ebLry2HcVuHdVxKxXTr5B5IPbwin8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0mtG3IS3;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790639774;
	b=g65SUunR+6seEALeAAxJdpKxQAzlEsXRdQLpYEJhUFxINpddUvsgF3pl7DOoQ4riF0S3QB
	Lk37fv6s94pOERyGgMw/DpM7bqW2NyOtTuQ3VgZX9tB43L5aMnvXMgk/oSPG0orPTYLArp
	x02Cgzn9scRsNkIDzLZmRba9VnAwitI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB27F4391E;
	Mon, 28 Sep 2026 23:56:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F541F000FF;
	Mon, 28 Sep 2026 23:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790639773;
	bh=NduKmuGz5k+Yl2Dj4XUx7MOPCMJ1dsEeFTs5x7PbkCU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0mtG3IS3AjRMlLkBODaCosQqWqMIEqMxHMaiGV2+i4KKWXI63nOdL+oIMrqqRh5sI
	 rnT5XPmaIqHNErbK/3zuzUHkeruyLbjNI4ZgW0BSJV6/xkZNUC5+sp32RrTnT1CdXx
	 LXQfIs/IM2vM+hz/+FTr67ojsO5jGmDveB9Go0GM=
Date: Mon, 28 Sep 2026 16:56:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun
 Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe
 <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin
 <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 ian@honeycomb.io
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
Message-Id: <20260928165612.dca65d7bacfc726508ad7d97@linux-foundation.org>
In-Reply-To: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o9ytptoa1q4of71hccue71ir5enqhtwc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C011B20005
X-HE-Tag: 1790639774-558242
X-HE-Meta: U2FsdGVkX19gsHLBdUJy4WnNyNmXPQPxglGvKDJ3mj+y9DJqUhzFhV+oohate2rQOmxzcbkflcTKcNAC28cs4g3tUSCUC5Y4VNzkmy+O3UT4USRZIasOEBNzQwUeZxelFW+YM9NZcmZDUA83PC0A4o8d1Bxhb3o8RsNy+W3to0+MKJ08mhezRMQ3/ONZcyiPogQh7gidwt7gd9A2OTIIZfQfDGDqnPleOa7BlS7DMQRn4QbBd3jsUEK/KpsyJp1AT1KWGMtJOy5MWuJ3hBqxH/GQ86GLAqLvkzCZUKz2vqB7vgrwPtUtc0LIeeB3F4rkwlEEHLUWC4chadf/4g8/teipkOr/L4ZDBDU93/kpXkbrNQfNQ13SHw27ansZLxaese9RD0RH/0no8yZ7Uolez34wJyK2TUQHipAxoxijIy/PXHIA/zeBZq1D+FrIr8sI/5UgN4vTkjnqi+uy49wFRvCbyBrRa+zUBmyYD6comBjEqTLN52Ylo/5z1pAyu38ceIQs1qiIasxioI2ZdJmXghct8GdOxZojozI1A2UVEwY/K0P1hWP902wuvXC9Vlg9k5sd5VnAvsEWTpMl14WHZwNq9p+8pum31rCOfNrxgJy7KWBZtJwECgXmQos+Zb1y+eAGDZM/mckarnqPpbALBoPClcRdhC1wcKNMKYfPaTMY0w4Ujfnq+HSXLsYTlLhKM02XyO5FsJYbZZFDSWLZlOupsU8eGb9EqlxVYaDu6k3CYy8A/eZjWhTQ7dn0QQhRY8PPg8S1I8YbANN9fdcWV9mQzWeoVJ+Xaia50CyAaYbdO8r5EKSrSxtnJWiUizqoYhwk8PLfyvUnWDoFcKC5XVqfmzQhT4JAXYIQQ9Uf2L7EwvjMOw7QZUtub1JIuzIK3IrFaDPI7gSOzQ3Qg+sFXdb87u8GaV7FcvuHg7LpddWtzLLqRRwRQgzioV3x21jRlNHk0/mIuqI85IYa901
 PG4X7RIM
 We7bfgFPRF149jYPER+Hz0WHMlxQZ+JXstqGnZBIUr7Ba2QPF3rFbiCSqsx5Bw0KQWeVee+DL0VjH/eaq3uj34AkcHTpNgMz2xxKx8Nn+6lowdHacN/omaICGmVLW/XP7pWP1FH71aHBsV6iMprxCpwOp5P1iXS3LqHSImMGabBT0UiXf1RTPxDQNlMVJ35HNmsF1EO35q2KM8r8oNfDzgy/OkKtcCZLGlR46j+90jlxzvrUV8sTeC/PZic5sVZVB+6HtoKKEZ8DV7UCBVzg99wZu2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Sep 2026 22:12:59 +0000 (UTC) Liz Fong-Jones <lizf@honeycomb.io> wrote:

> ---
> At Honeycomb, a container that reads from Kafka and writes columnar
> files to a host volume stalls for 30-60s after each deploy replaces it
> (v6.18). We're increasingly confident this is the cause: the stall
> looks the same as in the reproducer (little CPU use, lag growing
> linearly and then recovering), and the mitigation it predicts, moving
> our final syncfs after the last write, worked in production (below).
> We haven't caught it with probes in production yet.
> 
> ...
>
> Trigger: a cgroup dirties files and is removed while they are still
> dirty; a sibling keeps appending to the same files under a parent memory
> limit. Symptom: cgroup_writeback_by_id() returns -ENOENT and the sibling
> stalls in balance_dirty_pages(). Minimal recipe below; the harness that
> produced the numbers (paced writer, lag per second, MODE=alive control)
> is at https://gist.github.com/lizthegrey/2209d831930588f63076bdc0ac7b78e2.

IMO the above two paragraphs are the most important part of the patch
description yet they're in the throw-away section.  They should be right at
the start of everything.  Thanks for at least including them - many do not.

This is what people want to know!  What problem does this solve?  What
benefit is this to our users?  Downstream people want to know "what
benefit is this to me?".  Maintainers want to know "why should I spend
time on this person's patch rather than the billion others"?

But I keep saying that, to no observable effect, sigh.

