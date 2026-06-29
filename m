Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74081C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 04:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF296B0005; Mon, 29 Jun 2026 00:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FEA6B0088; Mon, 29 Jun 2026 00:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385D76B008A; Mon, 29 Jun 2026 00:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 075B86B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:49:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 793EE1C6954
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:49:03 +0000 (UTC)
X-FDA: 84931720566.29.DD3DCF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9EC7B18000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:49:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="MgT/g++5";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782708541;
	b=cXxsuHnUJ+6cQWoe+vqA6ZdK3OThY+a5Z4QC5vh38I5/663M17k96F9Sfe2i4u0N2VKjSu
	V+DfSEfG3JodDv6SVBY7isQ4u8XMVnLggEHh4Zv+IWlnMIBCr57UYtCTORBmKa+AACeejs
	rq3vwLEuv2pbejl7V2XDi1dgy0lPjuw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782708541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmnizGxCysKK6WdG3KVzor5R+I/41HYhqEFAWV6pHpY=;
	b=HSmg4bJSV9EJpLNhBTIQrbW1FNjPq1TZPzbuyPJBNTo5zkewXgq96HVSOhqfRTm1N3dO9W
	5TAYGw/i9JJ9aTmgSbb3/0c51dAbRRfKvQhXyaNYcXgiAJ0sRZpisdR4DI+r0jGa4eurpo
	eZDRb9TQWtMeHLTAlnO7xi5+rnk42P4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="MgT/g++5";
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D72C2402CE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACB71F000E9;
	Mon, 29 Jun 2026 04:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708540;
	bh=gmnizGxCysKK6WdG3KVzor5R+I/41HYhqEFAWV6pHpY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MgT/g++5uXB/waAH9DJz9YFhFjYPNtNqoc9mrl9DN5t1cVJ5QcEEaaZq/FF8l7Ypw
	 HwbpH/D7APWdckzktYPNZJ9DdQAV/J5PDSezNXN92gOH2K8LZDY5QCRtd2h/2X7PgR
	 tBob0BV6dKSLzRBlSeWpL+ANRql93PsEZoi/wrgY=
Date: Sun, 28 Jun 2026 21:49:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/6] samples/damon: handle damon_{start,stop}() failures
Message-Id: <20260628214900.243ae17b910c18a4434036d7@linux-foundation.org>
In-Reply-To: <20260628215447.96166-1-sj@kernel.org>
References: <20260628215447.96166-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ai17fzwtxqki8s649kb8iaqmtrgfcpb8
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EC7B18000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782708541-789060
X-HE-Meta: U2FsdGVkX1/Iz5OyyUuXjMnOT3D6pM9/J1o/JoYgafSqujefcZM8M1AEzjWwdLaR+Q0TeTtd2LpF96DCuDQlPeLRjQbb7k5YZqQLFjB7vCWTDNYX7nQVtHt5IwqRc+CeseNhpiTRwHhs8B01AbuFvqgLkycyorccgP2XwQEafuN/C5M6lgl5TQ13znnabN2XktnvunnQIqmJ12g+QNptvXafhbZ8dGIpdiRA2qvMVh7GKgCDZwPnl8HbXq2+9pXSvqMPuzkR16E4JgIKv2ThQGgQHQxfEnSjw4WtXWelv+JEJfp+9mTLs6ZFHbNIwRULqPtJ0pW/KEjW895WpGmGC8rKzyVGBQjGRgZmhHbm50LY9JOGTHNdbC3zh1EViaxoYLsIkF95QM1HGI1SX8gXMiSRR/yZzd2amfAkkPHZyN+ePO3PxxEe76wSt13GtINNA4UpDtf5rmbjizGF1N2l7WfOGWB/ax5UYRes3hIXtp4cLxgKxco35Bx9TIjAOZO0tdBdyCOpgpkzr15DnZG6pR2RDYDqO3asTwx/QNMXKyuV37DCoz9Jg47xSD9tCDamhXdTBF+wL2LSx3Hkx92Ksu5G2zha3qB/AXf1QYYJiGFlMExDNL0tzGxxAMVBw+hoRlnt75fEJt8Uejc3MP8WaRWO/vj6twA0qIQk7Wx77oGnHs6M8psTDgcttXwijqL49khZtm5pnAuiJD6uwCU1gwbzZYVYu89r5JQHoBg+LO24X9mJJjOB5TrW8wlMXVG0+2DNpyXNvYTHDwVZyCkBvX6qrSu3kRyC650Ivkhl1xidlyhb56+EeY9c3w+0fEV+yYTRYelb7omszCqZMrbOxwmwCa3/R5r3F1FwzrqnSSnlJKolrYTX4d1fNIUodV5BSrqFQ1Bnvywmg9sZ1k/BP6l2xKdeaH6n4q5lcRvoC+6G1Su+zCJ45To71AQMZzdMvStsnGVbHH4X9qvsn0+
 WCnHz9bd
 I0TnbYqqKun6264SHqjTbuedyFkSion1Ix8906rtmTG3GfbgY/lEhDTT4x6wvp8FQAv83i0/QZP/alHAZFEC1oUCB3VGaAhI08nhsBBQE0DAAmgZXQSt+5V5tkGNSJTWHzGLzEpCoze6TZqD+F8OcK3Yw/8ACFN6bZjNtAn4gioBZghUORT0KvtAgSNDMxyeoI+OJJuJ9QpReO5YwawQshjJw7NPMBwZLl54sfa/9r4kmySCwr0sKcpMDq3pYE9pah6krBIbCp4Fx5Y8YYzxEAjQhl8H8rh2DdvrKzdAesFyqjY0RBK7R4WY+bvdHXXkZ19oHnEWteNBupS4WHIkj6/Yj+dSJ3WCbEoRb0ZFiN/lzzgnuTLHZDQJZNJ/6NloNvfjk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 14:54:39 -0700 SJ Park <sj@kernel.org> wrote:

> All DAMON sample modules are not correctly handling failures from
> damon_start().  Among those, mtier also has an additional problem for
> handling of damon_stop() failures.  wsse and prcl also have a problem in
> their damon_call() failure handling.  As a result, memory leaks, next
> DAMON operation disruptions, and use-after-free can happen.  Fix those.
> 
> Note that only the damon_start() failure caused issues can reliably be
> reproduced.  Reproducing those issues require the admin permission,
> though.

So it doesn't seem that we need to fast-track all this into 7.2-rcX?

