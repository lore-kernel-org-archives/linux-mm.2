Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BFEF46446
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254106B0178; Mon, 16 Mar 2026 06:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D73E6B017A; Mon, 16 Mar 2026 06:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9E66B017B; Mon, 16 Mar 2026 06:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F337A6B0178
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:20:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A734B1A0140
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:20:47 +0000 (UTC)
X-FDA: 84551532534.17.A31B747
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0AAE540002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:20:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDAiyRhI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773656446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BP+pwxSDM+lypCOfl0xxp7qZHOt0plST1vb/z1gWzyA=;
	b=qbTDqdU/P0I8mZX0KIOe4MoK4SLVpTZxFyX6eedD3mFu7I/1aZFhe8sdznQisoVbm3g7l3
	GNTE3AkGxmI34/uksuVyWMlk7bv5EoOZYXUWQx3FTCGjxz+mcXaNj/OMTsUyovwK49uUw/
	GWyFjjDFjs2xWUy11MVoSI9tMWZOC6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773656446; a=rsa-sha256;
	cv=none;
	b=oAc36N2MJYbL1Fu4W4aMAGKT6teoAqIVoTun8voac9zDET+fbcKn1PDgmvRxtvAH1HfctN
	dnvvBnWvJ1i9LsVf4bPUxppq4Y76KmGtN5FAhS16aWJp5C+AFKVOIa+QLBxBDZBeeEwx72
	+vzm9DIdoruwb+R950F+QW5/7BtRS3M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDAiyRhI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3FBA419AF;
	Mon, 16 Mar 2026 10:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DBDC19421;
	Mon, 16 Mar 2026 10:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773656444;
	bh=uBu8mLZ+rpt9hHO2zebFJ320GkM1XA33y5mwSl91uXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UDAiyRhIXd16/3n5yLWqFADfP+XReuxaog2CvKttjDc2OI/QYNL4mwF+CIqtaO3Xt
	 nVCnBO2veL3YHcW2M/al3N7NNdtQxG3RK5+PzYo5tgFWUbuZFWefrbgmebUobo/FqX
	 E/7Jvw9UXMob3HhGf9JzB083MJy5xifdVTNGSQRDwUsTi6kWbzYkuEDGBF2AZBIsUu
	 EsisgrMjf/pATcn8oakB9tMAm9J+p2kpQDMFFBWhJesBObIOEijxO7+S/94gcXri5W
	 HwaihjisMgWQuD8/WV5d3I2sSQcn1UBREtld7gk+oOAmDJ3ndKabxfbaj/+Z5VDOrJ
	 jGpDyanxyr9GA==
Date: Mon, 16 Mar 2026 11:20:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: LSF/MM/BPF: 2026: (V)FS: Second Round of Invites Sent
Message-ID: <20260316-gebiss-drehkreuz-1f3f0e7a96df@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260225-aufeinander-kummervoll-1953a06beae9@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260225-aufeinander-kummervoll-1953a06beae9@brauner>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0AAE540002
X-Stat-Signature: ydid59qdu9psegx8fxbj4kzi15c9cmsc
X-Rspam-User: 
X-HE-Tag: 1773656445-650698
X-HE-Meta: U2FsdGVkX19cqJ3YJdWOZFqbhpjpgZXOOLncZgIHi+Ec5BAK4KxOvhZYsbO+526edn8TAtQhKBe63uAnLToAcQ9Ru92umncnRtg2ytOWkJWpZrAAfVB1lCeBywqdo6JfpYfZzuBEUJBswNg55QA7dmy6wN3LRKjkGLT/Ph6IxsbQ/G2EgXkuIRYfc0pNJUB+NrwumastGdz1AC4LBf/CmJkMCC9HmUbzQu9NGzjS+5xFal/jZBs7DSKWDEpJgLYkWrN0v7RWyN2cofrtenx9ScJ3YUPAGVXj6uxrLeaeiePUHA0rV1jbmCgvpe/NVYrA+eyRKTIrrlTFjCjmYuO1cMSIv2lbPPDoNDfrIDHWxbgkGpGmUywvspb7g5jbi/o4njYnVm8K+IiC6EKg8YXvkSbDcP8ffPGETS0kYjM/MraFWxzhxs4ib7NKMNb71T8vg7Y1SlOzN2hQygZLeeUt/aWtRROExzfUVXt346RkRRnQ9Mu8pradajh1zHUPj/o6eKIggZQMUk+tf22ZZGrJ86OBnY+JFCF3PZgnjiGp0gJZjprO3HHnpVn28NwlJF0MeRK6qBWiuQnwQLiG4EOYHNEhBRgPb96V50Wmen2S5wMt/Oa5kJS6XTDCQgdis6RBs3MdxAeYvVtzzb+HClYpvptOcIxwxud9yvp+ckAli8nSCueZV0QzIF1LDuVev6ux4Bqko+22ByWJL3pNUxKMWUwHJ2bfhweqvNykrSZiprAvJqJWKUheqReiu1Ft/OVhUH1iKhYEgl2YhpBBQ24XoFlTC1Xla5L8NDQZ+XrdwUl67US80TPdEKp58KIlSqinracfVPh43/a4BTBOn9if5k5hnz0ze7veMMyApI1DtF2VzNnRMccv0pDjrBMOLhp2mUGlL6Qj3cR35zv32yo33JlFQqoiRkGQAoNqAE/oq8+ymfAo+bGeHBjjjHJ/MYgyk+Oj0mi95bQkUcKZA2y
 6TDgedzw
 urPY0Dz7X7myY1KK1fIdRRxS8xsbgTBl+XzxdQvnugpBgycnAMySH3yH84DGoLiRmux019SKvFomVEeg2Ns09K8SpDi5Dc8GAXX0yUI8v4Ww98KFy/zI7wONQgFLyrxraSIbmBRDsqFJ9hLw4GBJ5WO4t0498/I6t+JtVqSPzwO551LWMOlt7oPYyk1BLa1DmNqmTGRVP4j1HXeZdApDeEJQthrUa2C+mXhxEzvGB3tZEdupqDWb84Af/CZMowDGPKZjfED+QF1nJNbR8gUVMKuv6EfE3mhlYML/X+zdjArBnj0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:52:23PM +0100, Christian Brauner wrote:
> Hey everyone,
> 
> I sent out the first round of invites for the (V)FS track.
> The first batch is also the largest batch. We will send out a set of
> smaller invites later.

Hey everyone,

I sent out the second and last batch of invites for the (V)FS track.
I've also sent out declined invitation notices. In case you have
received neither it is to be treated as a declined invitation at this
point.

Should any attendees be unable to attend because of... events... we may
be able to notify people on the list but it will likely be very short
notice unfortunately.

Thanks!
Christian

