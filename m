Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147CBCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7128A8E0074; Wed, 17 Sep 2025 17:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA6E8E006B; Wed, 17 Sep 2025 17:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627408E0074; Wed, 17 Sep 2025 17:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0168E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:10:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC8E11A06BA
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:10:12 +0000 (UTC)
X-FDA: 83899985064.20.2344F3C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3AE28180008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:10:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=C8jYwmOY;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758143411;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4zCJt6toGovk2j2NYp2jgoQbUCVgHY4TcWg2PTIc63E=;
	b=Fh8nJQAGkIf8D6jT+lGCTJBP6pf/BCKqIURg7bihJ3tmHI9V63TqOturJSca4DoRS0CIGS
	CJXcrAqoJubESMQ+E03VtwiB2ipxTeeoTX2EaZ0/sGqhmYjQLl4+902ehR4Lvev2sSfmlu
	ZQ4hwyW1rK/piLkpRnSWWsN29CtoJ58=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=C8jYwmOY;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758143411; a=rsa-sha256;
	cv=none;
	b=43TLkvxFvY4Qcd5D2j/GQ+L59f4h79GWNBzbszZUofNbwqaQ6JdAXMHWnKduGRTsvdPQ8A
	Cqjk7fQ8YO2WOABR8KWg7PZA/HzS9bxKGbo2uS5/Ky8hSqIeGHBFFFfVq5w3IPvHT/A8N0
	UAJChnICmQXFw9gifGn8cWNFNuDgFG0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=4zCJt6toGovk2j2NYp2jgoQbUCVgHY4TcWg2PTIc63E=; b=C8jYwmOYevWbVc6pf7aTmx8bBK
	ZKVs/QU3wTUQhsll2PGahlaXKDvDiZjDPuBKP+nl2ilLTquFNbNkaBwA7l6y7kD0pRBCEKgu17Z9c
	Zj/WuauoJxZrG+v+0RkolMxZb0YzY4BtuoiLaMieXsVhnTfO2nvmCwyg4QaG3lMFkkUf+K+bNOBdo
	gb4pt2DK+NkKXEBPGrnIgzEeHid/W12ivCUcnXuZn/wDnQiP8Uzpm566RJcZjwjsJFj+EVCGmv+be
	lEp4cjlG/tAQIj6pbYOymDA2XQWSsfyXgBkFWYp0UT7LpYvtNY+vz5GCSqsQLmIsPgIyVEucMogS9
	zJhAVV+g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyzPl-00000008YoM-1TR8;
	Wed, 17 Sep 2025 21:10:09 +0000
Date: Wed, 17 Sep 2025 22:10:09 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <20250917211009.GE39973@ZenIV>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV>
 <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV>
 <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
X-Rspamd-Queue-Id: 3AE28180008
X-Rspamd-Server: rspam05
X-Stat-Signature: 93fd4obsxdej1mzxuxdzg6kertijgcdx
X-Rspam-User: 
X-HE-Tag: 1758143411-939912
X-HE-Meta: U2FsdGVkX1/KwTbBQKSxwnS0f8/AeDmWGEMBeb42425CTEuVtHDkDcJdAsQ63q/tbab9CaLFtuBqqjtOaNdn8CEmD72z/ZnuP8lqr/XBWCwVJ6r40VvPzW7r4UKKcJbAcRC4s3a5bOvSwfuq7o90PxGsXu8eNbPrrbKC37dt5OyDrnOFftJp3plcHpjuk8I7Jgb1qdsSKM+QlZe+DUOUbJf1h+sdCZyb+B7c8KJ4+cN5CRkwuU6FfyTw3125wwYEbNGR626aSTSbkoym1FUftFYaNfJDFuh6JWoNOHLFmAuauIJ12kf60mJPsZ8Sy9nRkS1fapfQwI0szH1bdvxN7MJ1fUa/q5NowcGgdQ5VQAbD5RS1YFf1bmW2MTuOKCtwtxFiBtfV1gtJQzRoFPG4QD3rLuSCG9Gfh9KOIn6Av/COT7l9VOvD9q/YW9Yr1256k4XgPJSeNUX9wJCgWXxM1FT2H7kuFyJZhuT6xd9LHjU0zNP+tzh7PgD6Z9BEELmq+auruxhwF49OAV5lTDpQM7hbNZapAabdynFDDCOuXBt1IXfj+Ah7tOPAESuFw8IAmiLJ5VxZKA5azBxkbxhZ8PYWdI6WqhnV5Rdb8yWEqEBgjMND2a+jtDmJSQXcZt17c+bbYEi5gerLjIwXzrlaY2f27WwZtm5uq0I/HyjkHnkYgastk0uKNrE92cn1bXM4QOcNvj1yznh3Ivowe3yb/uxZajtKD1HQQ4lkYQgra4hnxHPcsQRcQ0bVtdpTzsBgEUaUHS42Q2fPpKH+6FiLVDXpqefK5K/CUuBDUj4+3TNC67onGM/8ui7IjYqMZ7+qwe2d/Yf+glGe2eMaZEBy7OFALCsh/QjuX/7SiBOYLFHqERzFn51VALj0mnCZ8bubz5k7S2UnAJUDrRwFM3ZDz89ZrLhde+dvEZVq2t7CRLGcVWhtvRV1DuR/Zh8sUvyJ3Egd6Ccmu55qhb0bHKd
 vPHLs0Mu
 8a0SBQgfhjaMQKVa39uXBlMq7VyiWLnP1i+Z9Ll2xRM5iDdmbsaRvJ29sfzUBCEdlCIgopg7zUKLNt09e0uHdBUUkBon9c/d61TvgaHkG/TAtu29Z2KPdepbw722ub3G+mq6pniSj/ms4YOFjIGlLnOpeiImWtiQ4Y+47EwFDhz15fYmQCWN4FSywTHAQpQbeJWV40BY+SvJ6ksM6o3ScNv6FGVElP3TZAzhcsttRcOXdfL53EJ+PbEBgzA3bYcBaVCBaRpuZXADtmOemPHsOh7oe3teKd2Sxb/LKLuQm6hDs7dHUWBHKxDClUVD6AYdm9sYAIXFfsyRqeJ9sJ2zlNagzbeLXaGdgjATO++0kl39OXKxNI8xJ//LorzMZ+/bcatYZUGuKgJoZaGYmxTIJCKJD7wOo5uK0ZWky3ycOpYaMEs1Up5edQl3a1UkHmYFqFKAKmDeCDcqKHnFSIrP+WFvTmc2bW0N6NsgKPaQyDnficadiZhqaARKxOHunW3z4ZUYW1PwV+2jaba4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:36:48PM +0200, Max Kellermann wrote:
> On Wed, Sep 17, 2025 at 10:34 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > Suppose two threads do umount() on two different filesystems.  The first
> > one to flush picks *everything* you've delayed and starts handling that.
> > The second sees nothing to do and proceeds to taking the filesystem
> > it's unmounting apart, right under the nose of the first thread doing
> > work on both filesystems...
> 
> Each filesystem (struct ceph_fs_client) has its own inode_wq.

Yes, but
	 if (llist_add(&ci->async_llist, &delayed_ceph_iput_list))                                                               
		 schedule_delayed_work(&delayed_ceph_iput_work, 1);                                                              
won't have anything to do with that.

