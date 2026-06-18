Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9941DCD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61CF06B008C; Thu, 18 Jun 2026 11:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3F26B0092; Thu, 18 Jun 2026 11:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5296B0095; Thu, 18 Jun 2026 11:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22A2D6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:08:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F5EB40164
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:08:17 +0000 (UTC)
X-FDA: 84893364234.18.6FA0224
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D91F81C000E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:08:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APXAJZyH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADzzepRVWs1vwXTC05UkLfdDEKwQsxVaPIoo0M8ryYM=;
	b=u4e5aDP5eXf1qmeP4hQMXSFL6dR+WycylI2hC+1thl4dkyha3iGEFmGX7rnj7HgWdiLv2n
	Jyz/WxMna7i7tAwNDIWPMsIGkrDzA10bX2h5o51CmrlGdvjqryoFaUnf3C5vfQ6qQvSYJ2
	jdEOC/GWpZn8gxtMdTpq6DnYJ0wfQFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795295;
	b=sfHZjla6g/Sl05SSwSwjXCK4lwS/89ClCM8qn+N2BklndfVOQZcBTIsGTc2oBe+Znka336
	ztsZfhssycqGfffVo5M2V9ktPQPuz7kd9cHV1PPX2faC0giNureyUgYdq4J3/Mcloo9zPs
	mkVbCHM4sXmDmE3KtSOv8JmTO4sl3U4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=APXAJZyH;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D49B60008;
	Thu, 18 Jun 2026 15:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5E31F000E9;
	Thu, 18 Jun 2026 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795295;
	bh=ADzzepRVWs1vwXTC05UkLfdDEKwQsxVaPIoo0M8ryYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APXAJZyHpcW+BxdLSoyVb7v4ZEHR1RrgW3ugOQFYVMEVErvF1fi22XxKELIMNa3i9
	 mnTLYHuchwHCqdJTBBhUMut/nd1TnVuXIqeJ+JGHWmuBOr5MBjnVVFtbEj/EqijHYw
	 Rs64F/MvMZU9ECYGrrP1uQgMlhc8IO4SPoRW9vF5IpBZjOzygrWpSweBAbmUu2lpt5
	 KVI9pUCeLQ2DKxCi6ySH6ODqzxA/JtIc46EMeT/osmjYG57DmHLB6OsmfNsiB+/1Th
	 xLN2iFTrFq+306Tpe15c36vNz5Ibst3rS1BR2MUcXQDtI9BUCB+j/KCvPNtGEEpIF+
	 /5AV10/8DvOHQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/3] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Thu, 18 Jun 2026 08:08:05 -0700
Message-ID: <20260618150806.4633-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <4cefc3af-67eb-4bde-89f6-8c3ea3c93588@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D91F81C000E
X-Stat-Signature: mze1feohewicoorpc1dfi3c4s9npgf63
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781795295-863436
X-HE-Meta: U2FsdGVkX1/nD8p2SxaICiHzxwdxb1NGu4DiKzE22hqR9kbW6wuox5O6XSDPEsLAf6617CEdJfR6nMLKCAWeMKeiMs/okES6wTMAJ7Tsks7o62Ubjv0pb0DY++Oj6VQi437jLeU32yqWvaXQVWkU6G3PB+wrbu/49cx/HGk2RgDSRAuZVhZnxuJ4CCcqh1625FHD48i1TsmrompN0KWIysNryN8kr3S5fSy6SLQRW6WmIbxhOarFexZbI3pm651uMDbANrGbLOSl3Quc3SAFBBK4KUjXXDrpfBpCBFk6n0tD3e/qz7CricwlaXLL8R9poQc4okCPWvJXLF84RJG98aJr3nnDVOdM8eN/iYQHLJWnx5GGEBXPWxE4Nif+ZMzNhZ/jE6xvmXEboiVC5Tu7IYMAaA3yQLDQStLKikeY5vXnCFXX+CqZ45GYsS4iGfAzEFTqtW2vG//ui/st8yAqCsr8pKkczia9S/HKMVThArBZPZv3M5wSEzNQgoQ0S57kFq2rcJL3n12Z2U/bfBzSjRCs860KL88tnKm99CsyYKHlOov8VuU3CcDSGxFeztZxx0tQ8tgJFyo5GYu8M+RhnFYPgy5qzy1rC+/YlwcEcOSnltrIbrormvF8b5sNRn47G5ekv0Qp/AniPTA+4S4QFmQG4+I888hTxNn/rEEd2gu7W2L3gkTvCzfSRN6sd2LGTuw6bTDRAff/n6y0n+WbGkF8nkSWpCUmlmqptqecCAN+4yCUuTdSlTvvIMS2if2/k0O8VGzcE+voIS5aEROX0UEC4pDcJPlTf9OMaLs4GJoDaqtmbJzQcbmOT98ajt+vbadaGBP9CvftJvMjFZu8yE9i/tyZK7coXmo6BANeHNSiGMAhlPivkbdqL3DG8VWweUkrUjZAfS8pC0r6oW5qLLhXz1Gu+yI6wOVidYYEeu1tkroNM9373buScdF8pJa2CS8xJUVHpjkB3hKG6Ro
 0rZ4suSB
 +aCt8pBr0Y0EORUldoUbxEAyjiG07jcf2TIt8C2sJiJ7vaV0BSh+H6BsGfmdIoByWgk1JK97AXCuYmwtAK4w4Wrpm0K4IQp7zXxzOFAdaFXo+3ujRL1BT3jQUuZ/CswbO7nK+UsDP3X/r4Tmnjx/icCep4aGUZlV9NswMNa8IdKvJkzxijtv1s6xljsjMjIdwkv/8Akpm6BveN5f42kppfjmF7+ZSbk/05ljUa3/Qqzil1ZxxC5KWFFtT0uIrJKHOHw3gawm19DC01t5sqZsiBpE0zsqnk8hLtLB7RyTTwYIlJgoe0h7grYXKSMxxnTx/nVmq2qciIWeyP80eEQ+VO/BDaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 17:59:36 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 6/18/2026 5:57 PM, SeongJae Park wrote:
> > On Thu, 18 Jun 2026 14:51:42 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> Hi SJ,
> >>
> >> On 6/18/2026 3:16 AM, SeongJae Park wrote:
> >>> On Tue, 16 Jun 2026 21:04:52 -0700 SeongJae Park <sj@kernel.org> wrote:
> >>>
> >>>> On Tue, 16 Jun 2026 15:03:15 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> >>>>
> >>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>>>>
> >>>>> This patch introduces a new DAMON module (SAMPLE_DAMON_HPAGE)
> >>>>> which collapses hot regions into huge pages.
> >>>
> >>> As I mentioned on the previous version of this series, this sample module looks
> >>> much better than the initial shape to my humble eyes.  Much smaller and
> >>> simpler.  I really appreciate Asier's efforts on making this.
> >>>
> >>> However... I was asking myself if this module is really needed last night, and
> >>> still got not real good and confident answer.
> >>>
> >>> After all, this is a sample module.  The purpose is to show sample code thhat
> >>> helps people understanding how they can use DAMON API.  Maybe we can argue this
> >>> module can be helpful at understanding how DAMOS quota goal can be used.  But,
> >>> mtier is already showing that.  So I cannot say what new advantage this module
> >>> is really bringing.
> >> You are right, the main goal was to show how this quota goal can be used. 
> >>> Meanwhile, this patch adds ~200 lines of code.  It is a very small and simple
> >>> sample module, but still we should maintain it.  I, to be honest, getting
> >>> little bit concerned about the maintenance overhead now.
> >> I understand your concerns. I know code need maintenance, and DAMON is already
> >> growing significantly.
> >>> So, if Asier has a good reason to add this module that I'm missing, I'd like to
> >>> humbly ask to consider dropping of this module for now.  I'm so sorry for
> >>> raising this concern this late.  But, Asier, may I ask what do you think?
> >> So, are you suggesting to drop the module and upstreaming only the DAMOS quota
> >> goal stuff?> 
> > 
> > Yes, if you don't mind.
> Sure. I will do it a bit later.

Thank you for kindly accepting my humble suggestion, Asier!

> 
> Thanks a lot for your help reviewing the code so far.

I sincerely appreciate your contributions, too.


Thanks,
SJ

[...]

