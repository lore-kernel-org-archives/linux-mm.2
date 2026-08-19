Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1830BC5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 03:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035B16B008C; Tue, 18 Aug 2026 23:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F28926B0092; Tue, 18 Aug 2026 23:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3EC06B0093; Tue, 18 Aug 2026 23:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C42FC6B008C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 23:27:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A0341C0F93
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:27:00 +0000 (UTC)
X-FDA: 85116582600.03.E579CE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F94340007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:26:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IVOBb5xL;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787110018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZsR5sCGflKVZsWluYOj7yhh9p4oVHlhw6wAcEQCGCw=;
	b=mRcFaYXan3GNnCkUPgbDjVwUk92ejmSBGIGMq6PBHgG0xREybBuEtr2+/vHgm6YBoTyQcy
	AwqByIS3zhcSglPIHeVWGTr/JzA3iROP3ox7YC9okxVhhsIVsEI8FwYNSj0dZYWDgMpnr0
	nD03C5NkxC9nMtfyr9BWCliodl7WEpI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IVOBb5xL;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787110018;
	b=yyy3eDQeA340C+Ks6XUCdOHyLOjV/4G7rxQmLBjDwcqO0Fud0KHHeTWPsHwGZFchUPCY5w
	FDOOP09yp0wffTtxFsQX/wvHsZJY6+/x4QNkehpEc/zEuReugJZl4ugLsa4alFo/Sth3q6
	ui+5NylMkfw8wUG+6424WBvQ1Tu8S+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4ED5438D7;
	Wed, 19 Aug 2026 03:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A191F000E9;
	Wed, 19 Aug 2026 03:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787110017;
	bh=DZsR5sCGflKVZsWluYOj7yhh9p4oVHlhw6wAcEQCGCw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IVOBb5xLR1QWeHHyFIp07pXoOjRkmb5kH1NbLK7HXNbjx7bAtJgGk1uxE1ho3RaSS
	 FZrAX8RDckayMIYgBSLQmXglvM9NPhEy5Yhl5k8WbY0T2gk2Vk4OURTuQq1HqAKe3Y
	 30Wl9nEjJPf16sjghMpQ7nOcEnGDuijTHmFNNX5o=
Date: Tue, 18 Aug 2026 20:26:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Foxie Flakey <foxieflakey@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, Suren
 Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
Message-Id: <20260818202656.f7a248b33f6130d06b4cf83e@linux-foundation.org>
In-Reply-To: <e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com>
References: <e1e0b5f8-c3c6-0537-670b-4397f822f980@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qqsc9hmkkf6pm8jynojymkc7nf1hsyt8
X-Rspamd-Queue-Id: 9F94340007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787110018-589101
X-HE-Meta: U2FsdGVkX19Mp9CffPPl/S3yTYNe3S94zwuIp1GS6Uk+/KK9FQuDQ0Ma2/QctEv2jcungj4gF2JeQS7PHcOUV09Xj0sLYXvHaRVQ0VW2CaybIGViX+p8EhlIlrZJ8qjLNsA6BUhJLvv97hCi/ylzWVNywbfRbz7TxD1ajGwmPhYkkrpFBxt8ho8rqbRNphVYEFyZqr8/R094tP1ZOG7HTL5CHkJpmMQwfTvDeNTOKWtiPwU0q3vty+l8w60SR1meaFjOHN4fguvs0jECXUJ5aJIzO1k5foyN3dGB0aZ/l4gUkRXcXeNDwPJGqrTU5O8aqwb2UmrME13VcAKCRVHRC46TgfwJzptetGfBc8U8BVsiAzREbPzYOebGME7NpgntCVC8DaL4kR27ZVqCU7mb/XXLkfTWBBp3xCGaMrLw0HrEbIheGeyIUAP6WJ1qIQgtKnUSXWSjwYyoYTGRB5SbZMGiIotCAdeMGkkP+TrdnojIDhCLSHRn2f+GyDpljKt9seFS3FboVjNsCHuov8kyfeTNobmoT0yj4f0HpNIcCtMlH4W0WFi1DgqXcUk3CtuRGqTWwPPcLV4X1fBbFzloYZL+IltHSHsgp4OPjBMuBnjpTtKBF2AtYl4onME0Qt9k1tbfOy3yebOAeQzINcfAUl+24Z0ingZZ2ezAeiR8SbnqOwjRmA7sIskSMWh/N3OG7Bcch4XJ5c4wdviigQp3ylST9bp9I8Jm9iAn4PxBCtcrMRfzpa+dUQrMEvIkmJSX3lPGk0OGUaiLTOFv3ymurRIDN/0kHA8VgaAbM/X/c4FomqII1bOwM6Gbikb6jW2hy7otDZBAEiS/mPPpgoxANVI0YaeAwQF1ahbho74a8WfQEX43a+Tsh3DqlMC+ygzTvQZ61Hx2Cn4xGiTrUUUWXHL65MOWxYZnA3g5kpbRKY7zhGwvYXtEhy6Oc5zrq7Wbwo13NQg2kxCpcptqxeG
 BR3Jk/ja
 G4uhzd9bGV6jCVvExoqi6tz3kw7tNItd7uJb1clbYn0emxt9RqKZEEXzHM4zUI/I1UnQhqOOGh1k7FPsGXIv/7Nn9YFsXJINPLGhVL3Uyz/31SQRWiVIJoDo7+itHexaGGtFhMcHXgmU3pHsrKpuHEgboe1Z0oxrP9dupvidRdIoUoNW1MVO7a+AVEIR9463bUsoOzDsDoNf9B9XPiwcVa7in/Ypn338KgqMbs+M+BH88hNjFk3Cky4RyHMUv9puT5N7jbdILbR69V32HvTO70Pz5qDwracjH27TLcAGa55c+6A/VvhRFpfXC/9Elif/Q7iWK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Aug 2026 10:08:24 +0700 (WIB) Foxie Flakey <foxieflakey@gmail.com> wrote:

> 
> During move_pages() operation, when move_pages_ptes() returns EAGAIN,
> the error code is not cleared even after we processed it. This leads
> to a successful retry but then the same pages are retried again due to
> the stale error code. This time move fails because pages are already
> moved, loop is terminated and move_pages() reports a failure.
> Clear the error code once we processes EAGAIN.
> 
> Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> Assisted-by: ChatGPT:GPT-5.6-Luna
> Signed-off-by: Bryan Lim <foxieflakey@gmail.com>

Thanks, Bryan.

More paperwork: the signoff is supposed to match the Author:.  The way
to do this is to add an explicit From: line at start-of-changelog.  If
this is not present, we fall back to the email envelope's From:.

> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2085,8 +2085,10 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  		}
> 
>  		if (err) {
> -			if (err == -EAGAIN)
> +			if (err == -EAGAIN) {
> +				err = 0;
>  				continue;
> +			}
>  			break;
>  		}

I'll queue it, with an adjusted From:, as above.

Could reviewers please advise on whether we should backport this into
-stable kernels?


