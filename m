Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9075C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1486B00BE; Wed,  2 Sep 2026 17:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92116B00C0; Wed,  2 Sep 2026 17:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980CE6B00C2; Wed,  2 Sep 2026 17:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 778DE6B00BE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:40:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDC3916035B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:40:42 +0000 (UTC)
X-FDA: 85170141924.20.325E90B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28131140008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:40:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7+3HApt;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788385241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+6wgjs25er8JUpTPTCJznKS9xjOBsRH1FzmXw7IFy0=;
	b=TRfTz8k6/Bz5Y2tIYyDKNJRfZEsDUBVr37dJUbi4qsrkuYTBIjpUUB1p5A8oNspHOEErwp
	MC1VeI2U3Acey1KnIpPrgTj1awso59RuCGWo0cO3giq2noaLRBsXUISZGsLktLSaf5jg0U
	SqP0ZIw/UCrPsdF1qtEPitHayqTtsYQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7+3HApt;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788385241;
	b=Dh+zxHfZGPhwy5RNnhtTcCfKd7qq1gQ8pgSpGnze53FQSCMv7IezbFaiP0m6Lja7m+xGey
	nVn0RwS1Rw7HTrUkfj3s1+pDK+uazACwUIxKZyP8xmCP0SIJekoAQhrhB0LhfccE0M30LC
	s8rpw11NqTI80WoXtb5es0NQ58zAEn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58FDE42D52;
	Wed,  2 Sep 2026 21:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88881F000E9;
	Wed,  2 Sep 2026 21:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788385240;
	bh=K+6wgjs25er8JUpTPTCJznKS9xjOBsRH1FzmXw7IFy0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p7+3HAptQoBy2YYTOS9pHN7GZaH/ozxVGuy+2xZ9Bf+W/uxMohWNOwt+rSUg7vzWg
	 l6Vh9rdrWMaNbR55AbDN5U4LyJS4G/TP5iovSG1jMK2xBkTB7RTyiJ+5VxsXDt2jtL
	 n7+WqVSXBcOLErC26vRXJtRtzScRUmqM5tM9Aspk=
Date: Wed, 2 Sep 2026 14:40:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: Liu Jing <liujing@cmss.chinamobile.com>, david@kernel.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mempolicy: fix div-by-zero in
 alloc_pages_bulk_weighted_interleave
Message-Id: <20260902144039.2824b7589e87dd185c92d67a@linux-foundation.org>
In-Reply-To: <apgqvt8iIt-a6j2Q@gourry-fedora-PF4VCD3F>
References: <20260902090412.16445-1-liujing@cmss.chinamobile.com>
	<apgqvt8iIt-a6j2Q@gourry-fedora-PF4VCD3F>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 14pwk6qxg9i8fboyf1woh7ciq546sdwo
X-Rspamd-Queue-Id: 28131140008
X-HE-Tag: 1788385241-703808
X-HE-Meta: U2FsdGVkX1++Hod1k4z7o8+ynpZTB4uBtgWrBiu5CF3SFYM/tIRf+5I0lVevsi7kd/Ag5lV0wM85DvIec2P+03gGxjppzd9cGPe52+sPdzOEahB0OLIRLy1Xl1QEipqV5eNX5Wtq8ESV+hNL86xOybT52x7XauFBeT+P26RqY7XJqiqxwE035Ov32LXU5NNMdBXjYQqF1R48F3AMO2tEJAet0mioTO8xJVN0J36MQmtwo195mkWvGODGWqnNO2b87mtaI/7uGZlM4KFBHBbCVmZsVHqLJAzUlXL8KX85Qb+IElPbN7YhPzx+4cL/Vp67SLiFkEkPKXL0PZ72F+fhCkHvqmrRylMzzQu/uk9Qom+Z9V4rMEdH6N+rvtdy253IxSDaZngItP/WnVmbslGx+WihZw3H5wKEcHXmsb64j29C0SqL7F8If6beZC4ka58ji2EwWfdEGMZuJXHFzIBNRk4ztQHYORk/xSK5YMOlWmrpEmiKE1CsnlcOw0eP++hQ1kJ3ysQsNSQ9aAo0i+JlpRoi+kiPAWbJEQ2Sg/NG4rf0N6M+jt8PQcg2iwKt28O3WMtc/V+E1goCA42Poul9K+bP0Wvp4tLXMtjrKsS4S5LGuyq08P5FK6Z6ndMCa7ZC+loxbiqWmVYtiAoNC9nmCrs/ePFaCK+FVFBqdRGYOf4XytmaVud5IvuiQS8voFtNgRS3H34nx3w4Kt/h9WOiZKyJQHVFON0e3T07MFiLaunp0bjmJNgGkfaoXz7NJFQLtdc2LN2DmfaI+caod3f3WEaMASiCAHwt8lquJmokc5f9+8KqMq+t+g3nCLpXVI6D9f0M/VxTkCs7BCYWHS/mQ3aQ5/0XkydOudvyD/9oqBCnV7Q96wrnwKAKggRW9lV7c3/dICeZFe74JclMr3DojxRA167KUD8GcbHeiQb/7oJhCX4nXMMYrkKbo5OUDu7u96Nj4ub0XdQg/zoC0BT
 uxhcb9j1
 Lihv4zvXKfHm+wKv6qrubb6aFyVUyjuy5ZBP/RJU9nUmNadf9BXZJFuxRSx1qIQ2JJIU2qwgtZ50+sZ7LSgrcBPow6MjE7W5nUAj3ulfQTJHzVp3B40WtZp1kKQvuBA3zoNYQXWNRs0yfSvene8XYboEFgCsg7vUHUMG8Z3QhdplwcIzg4ThaP1Gon4HGb9wwlMdrCoXyilWH4JN04AwxzerXUR/UjqkS4niobB/2YjKHckRopXlyVSWbO8sYtHCR6trCvwC8pKSyeGQTWhoKnbaBpF5t/2Gb2XVh1H7paLY6cU2TfZz/IRS0NlIdnoQK3SejHsNZSj341RmDNb7DnC2niGKfy3zY5TGCCqoxx4FuthBkbKLlvgZGL74asm9TfZMlZqtrPu+tnppDH/UG2DSmmyA0j51fKmENSzarfzxmZG5sYwWLm5zB3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 09:57:35 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Wed, Sep 02, 2026 at 05:04:12PM +0800, Liu Jing wrote:
> > In alloc_pages_bulk_weighted_interleave(), if the iw_table contains
> > all-zero weights for every node in the policy nodemask, weight_total
> > sums to zero. The subsequent "rem_pages / weight_total" and
> > "rem_pages % weight_total" trigger a divide-by-zero panic.
> > 
> 
> weights can't be zero and we just fixed the rebind race

So if the caller passes in me->weight==0 then we consider that caller
to be buggy.

In which case a div-by-zero is a perfectly acceptable way of reporting
this bug, no code changes needed,

