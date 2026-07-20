Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758A4C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6C76B00A0; Mon, 20 Jul 2026 11:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776946B00A3; Mon, 20 Jul 2026 11:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 666246B00A9; Mon, 20 Jul 2026 11:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4576A6B00A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:34:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB6631A01F3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:08 +0000 (UTC)
X-FDA: 85009550976.03.89B5C30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 20C7DC0016
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+LOaHZK;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784561647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLXVycmgEZJPqqHtGAfdNJOQIM3j4a/vYkoSH+ybPfw=;
	b=EXEvRWomQZY/3hHlXJGV4o/GTNIi1J1hTBeYTsj1JoF8ES4FOyRhQs5IxyHDwzzAIZ4nLJ
	SFZptBFbedyBOilPurXOQYBCGa4zrgAo5Lk6kPu/hFfnPW/jVSyspg9+DdqClmVrDJVv9K
	+anNZ783W6hbgpmAl5wvGjDyLmX9c6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784561647;
	b=F3QM2CZLRTWtBdIGlx82PuCIFC7qtHIdIX3IGtKl0xJmiIc8uIyk15QSxgInZAuSmCHLtw
	7S5zgeT8rvlYIpdtwtkm9M3SZEeljNDic49Zdg7VDOYb8Equ7RRNsce4rlkqpvrdZqWy9Q
	z4UDmEE9XCBtnghbpUsvfU06AFR8uRE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e+LOaHZK;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C32343A75;
	Mon, 20 Jul 2026 15:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCDF1F00A3D;
	Mon, 20 Jul 2026 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784561646;
	bh=fLXVycmgEZJPqqHtGAfdNJOQIM3j4a/vYkoSH+ybPfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+LOaHZKDhTxNgMaDo+M/kz+mmnSqjwJYNcRec6vJuwyVRgVOvL6tVG+0CzKHePuO
	 qVZaFze9tKOTQAX2PTa8uePlHc9b3BSyto6zJhW8HAMtXwJ+JjgpXlPJ5D97ydcIW4
	 BHLySIYGn7tjxAZaiLz4l1lbXN/tH6V/NqTsUQVgx17+Eu+jDnDVyAcdpdvCJp7ciz
	 iIUuhq45ncEwKr7/vLJYVCCMdPXqxsDWDOMZIF8qoW5CBbk30k0SdFnA1T4GrUQn6B
	 lPMPExoewJ+MjMNWl4VJKJFZWKzYKthHD/psBaL4BtX+vp/svUHex0t27nWnIfjFwp
	 heEyQMb/SOTYQ==
From: SJ Park <sj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	yikai@z1k.dev
Subject: Re: [PATCH] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Date: Mon, 20 Jul 2026 08:33:57 -0700
Message-ID: <20260720153358.83836-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <2026072053-silliness-slacked-8997@gregkh>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20C7DC0016
X-Stat-Signature: w3dx18rb91zsieinjzka7faewm1b9rw1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784561646-269875
X-HE-Meta: U2FsdGVkX1+o/pV3MaiRmWcPVKskA8kQUCBnO7yQFPiO7HUpGsiuMMxMKYDwBc51vEq8MCoX7XJ62VhzUD8uXuBwG63U8Tb1f+0z13R/B0fdF2lbPx43yQ9Kguit4Mr4eOY1R5FVgJd/+/0gpBp/nYkvWutAutjY6ABYDtQ+nwMQwRKc3Vv5aRTV899ETDX8uQ8Sho1GmI8pkt19Hx0ryTYiWM4yZrc8R/bWCTcaHJKqgIUNCA8Nz7FpMStGTE+1cxBl8W5JnhIqShRn65HyErW7C1+8RadSyrM3BCGy/a0fO31GqLPYAQoT+SQ4fW/qxBDY1Kof/T0Oio/w3eYT/fKTX+43ec+MbjsGJWdq4IrRF8lc/H+CUHzE12f4n42VETnelMqujBG/eEjly0LgSPdC4Fjh7BoGPnYWHV/Y8Xing66PqA1xABWAQ2K90jTshkrzN/RE1PgiszSwni8HFfafOY8aXcjfZz/MBZ1ExGPcAOCcAWTzftRUVDfYBAsai1Tti1atvnfvWPvUzX4nq7ilWgxRKwVAMPxPlXhXrJVEa5P24gPeNDm+aa6RMGvH3aheAlnUcnfGc3pBSue3y1YmU+n7DUd++7Z55MPUcpr0mac6ecUufFibFgrXDEFdlM2Otxz8cjRDGL7v0Xq8ExZgtGC8P79ACf/ACwqqZ0mkDcapAhEAmAsq1zzlZnxuMi/VTGIqZD0OCZzQD94GqrZrX86qrqQuubvmpRVI1uEpwhFbAzQbk/LMA7U9j8FYCb8ArH20fStM1bWhzW4zqpE8EZTQTz3u1/8yEIJcNi3lSyRHKhj/UxCF5/LbktKLEHKmzaQAcGcbXVh9pjruRl5AVzQHYkcgnZaSl2Jtde3ZRnvFlU4i7JnS8q9VxfyAunLsJYBJhbnG8hMQxeRGlv1wpfH93EwITwYoOL7ppYFDudpLve4uPMNrU2jTQVVxiOIeQ4BcM8VstWdUnmw
 e4v7TGRJ
 mpWloc1fI0Vxfk+1Qv2vZg7EToLuLtmyf8cAkIOh9G9eNdNKTuxlQ3w8R4GWP2g78SwCFM74mA13k6qpOBAjSuP389vaRMhZA2Zu/bOVksYlyRhOa1NyO1xHK9160MpKZ9gJ2rklXxSDMUUS5KKOgzyJZiRfO7Ni3ML0aLcQ0sIssImckltZ+ScWFJUGOwV0skB1wyAC+uxa3Qn7JY9BDgy0XQ0pSpmjo/cHYvw5Riwqdjqnj6yOZuBlvTooBc01srwD+OMa6cP53WktKaGcYKhndRd4uDjJZu/kAmwCWNjLFmyOhytKj7nsY/BQHv+thzc/1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 13:53:10 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, Jul 20, 2026 at 07:02:32PM +0800, Liew Rui Yan wrote:
> > Hi Greg,
> > 
> > On Mon, 20 Jul 2026 11:59:03 +0200, Greg KH wrote:
> > 
> > > Why is this a stable-only patch?  Did something go wrong with the
> > > backport of this commit that is not in the upstream version?

You are correct.  The typo was introduced by a mistake during the porting.  The
upstream commit (64a140afa5ed) doesn't have the typo.  This patch fixes the
typo.

> > 
> > Sorry for the confusion!
> > 
> > This is a stable-only patch because this specific function was removed
> > in mainline starting from v6.2.

It is true the function is removed in the mainline.  But that's not the reason
why we need this patch applied to only 6.1.  The reason is that the porting
introduced a bug.

> > 
> > Therefore, this bug only affects v6.1.176 and v6.1.177 stable branches.
> > Mainline does not have this function anymore.
> > 
> >     $ git tag --contains 2f54908fae21
> >     v6.1.176
> >     v6.1.177
> > 
> > Let me know if you want me to resend with this explanation
> > explicitly noted in the commit message.
> 
> Why can't we just take the same commits that are upstream that prevent
> this issue from happening?

We can't do so because the typo is only in the stable kernel.


Thanks,
SJ

[...]

