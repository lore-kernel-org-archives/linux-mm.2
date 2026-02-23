Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37925EA4FBD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 13:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7424D6B0088; Mon, 23 Feb 2026 08:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8EF6B008A; Mon, 23 Feb 2026 08:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613106B008C; Mon, 23 Feb 2026 08:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 511B46B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:23:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B1511C016
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:23:06 +0000 (UTC)
X-FDA: 84475787172.14.C3BD44E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02833180004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 13:23:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dEvta1zV;
	spf=none (imf24.hostedemail.com: domain of BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771852984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvvWd2EKCIClQB6cwqoHfhHaGmmMdEYj+iHNdxTtNmc=;
	b=FggmaL+wEflbjpNcHCQF1mWmcwbXsNsVnI1/0TsCsGTutW6NjbMZTLnbxY6eQMJ6C7r8KO
	dIYzpZKg/m3dqmtZeSZSVdnIxAF4hj1ZJHdADImcH7xfLjnor0/NxxqbvdNmSzk3YD/cmN
	zEUE+5bhH/GLozAENdrgnBh1ELDYXtY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dEvta1zV;
	spf=none (imf24.hostedemail.com: domain of BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+48176073e30864d8fa6b+8219+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771852984; a=rsa-sha256;
	cv=none;
	b=raw7IqHxg5Kn/N+oiHY0PYT7na3MDyW0mYQ7wapQZPToZwa9ZtHd3Ke0+yLtssKfKb5HIp
	Q17kZF917m64q1+HRyoEMRvtGfy4FWliVSoSp/rII+tmB4GIHnNBigjBLUetXPjB8v2crX
	g7U8xyDwyyGLh77WdH/C111A+bl7oyE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=cvvWd2EKCIClQB6cwqoHfhHaGmmMdEYj+iHNdxTtNmc=; b=dEvta1zVLA7zArgNK2X9fR6ma1
	mo5fdO4xGjUzdPNrUPdk/ITtvD5OD81/gV+/bwGBuq7dQY8WppfoQA/6fbQGkM6MtJG0kgLc3X3T/
	1WX9ovq0kFxEAwfXgCIQIxt/2trcbxyYHa6ABGCiWbGL4UFOfT+616mrSqxAbMSv4TgeSdaXEqyMh
	xH/TPv7cK9A4K1Uz8OOZ0JSJaNTguKKvQD4/XXVO8PFlhjhFBYhxRpdXCSyWa4MS1unp3LKHukQzL
	9D1SX62feLPMI6cByd4tJglHp9am9epHESqYj4aSkP5VK6zdNhXaXAOSTT0LxZmClYxeKLNpu8JdJ
	KRhhpdQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuVts-00000000M5H-3vtp;
	Mon, 23 Feb 2026 13:23:00 +0000
Date: Mon, 23 Feb 2026 05:23:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	YoungJun Park <youngjun.park@lge.com>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Flash Friendly Swap
Message-ID: <aZxUtFaVaJbkAM8Z@infradead.org>
References: <aZW0voL4MmnMQlaR@yjaykim-PowerEdge-T330>
 <aZiKQwT7KjWDLspH@infradead.org>
 <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbW6uT5OKDg0RWS3ZBGcppBkz+MREDVXdwSat_qM=Nc5CA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 02833180004
X-Stat-Signature: 4ss9steibmmatcjzre18zz1mbfj4qt3q
X-HE-Tag: 1771852983-56719
X-HE-Meta: U2FsdGVkX18dF4tNU1d9/KDy8LbPEhGYP581Y2alLyX84QxfEdKtfumW9dmcuLupS5uPbdpd2BLdzSxBYZzkn7Q9vhdBPP/gYN4qbQNqp/LhVxVN3GhNFDFP0/32UKK9zrtdefh4/HLQ8CFDOddBQs9XkV5coIDvCAoSG1EsAVDKyyOiotQrFbU1SzMhBDPcplAv2OgOjF/Y2NudRucn6a0LUXKJ15OJ9gPRk21s5SuG7O8jjJLaaMYpyo9J5+bHXgkCGLUjo6HQrxz+AgLFUdCX0F7KHcIRo77broWXTJJ5WI8hziiSwwoepv+iQuyvukwWGDwTkjw2awDCBwOpyCjehYRVwvWa0JnQwCsV5oXqt5+95871lB9yo1ci5qJWxmdnViKT8M7+HOx8pf0q/oMeXcdlmS7rhG1awHrXOdbCyD7oo+6BuPLrid9XkjKfQ0MPBL047O+DaQi63OM4RGRl0KOCrZT2nMEeDC2tHglRMX7TijiabvUWKOaam085fDt8ZlXIYLgW+boBQQzCf8CX0pSlLYNWncWOom+DCo8sbYMN9D5X2ysIHu8noGMCZUL03vqV79OyEggg935xIcO2tJEF6THxEVF6fcvME/7ndv/GM6URcsFw3YB0mPEmnR5vfAqO+zFtbZ2/e9OsYeD6Llcm1gkbvjc2pWZYiTG/KNY7NNliq/dgpOt9TIYJU1aVxHcaMTldTASL2RYTfG3LN73CisjN4VULrF8ZhVO4D7OWHIo4rel5Lm0wFWRvroYgxBRzxZkXOrmEbLXYPu/2b/vTrigUug+FtEyEeWDvxyQ8WcMWjKsyCfVLSe7ZvyO+9jvigWzQSrx6cjf1ITy2wciKUqbhbqpHJ+25R8BwxlPaJcXk7peyt9b4GY7OV0pmgt6M0QwBe1Tnj4HK1lGPTCrhcF46yy2Pb+0T1jAhIJ18cQ1sNT8H0Krh9lLU6WlOyjNDcLEBXMLyRQ1
 tmNMxDmp
 eJivnsj5hMF0JPxh2PLf1oH1M58rt6tYpoDUAQrrx8d7QyHJpD6lBw8UgtbZre00vQL9mBaMM7Tn0CsIYjQkY8P0VtwRXmJpJNsQv7u+ql3KEc9sAVbDEA3b0z8xYQaHtmqkrNGypgBX6n9NPI9XVPHQ0o+m9/2VRbk0F3fQ7mmSUqVAm+tKocvSY2Bf/F34XsXqjBSvm1QHsGKsBa1FBcmo3ZpP9vxHsaXWERInvVlmkE8RDJ+AjnLc6jz8mPmyZ8HzATBvhmDgKF15Hs0KLG4mjfknszzJva4/2E+fVn4xF5My6sY/h+XMKzAAk7PhfMd00NdfPALDtQkck4c5gYeyUY8RTYtMZGwjEx6cNVYvF4v+k43I8IbtjDqmb9V6pYCBgdSA9FxcRQog7eNNSYSUC/Xq6gM5DvNzxfPnZkvG0czq83goNvydQCNCUeyvdEcv2uJGT58KSUVN2HK9QWmkQSwUoTaLhepYwfUTV0t8bgrzbfr/hpfdi5sMf+oS0ohmhdlZizpEwSOI4NE+rgsqX/G9JXjtHSk51KyQP6FQzEz5tgJagcxVYiLStpFlQYAH78332UL9lmtjXUwu14g5rDcRBy6bwbFsi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 03:47:18PM -0800, Chris Li wrote:
> Hi Christoph,
> 
> On Fri, Feb 20, 2026 at 8:22 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > Honestly, I think always writing sequentially when swapping and
> > reclaiming in lumps (I'd call them "zones" :)) is probably the best
> > idea.  Even for the these days unlikely case of swapping to HDD it
> 
> For the flash device with FTL, the location of the data written is
> most likely logical anyway.  The flash devices tend to group the new
> data internally to the same erase block together even when they are
> discontinuous from the block device point of view.

Yes, but that's not the point..

> It is easy to write
> out sequentially when the swap device is mostly empty. That is how the
> cluster allocator does currently any way. However, the tricky part is
> what when some random 4K blocks get swapped in, that will create holes
> on both the swap device and internal write out data. Very quickly the
> free cluster on swap devices will get all used up and that you will
> not be able to write out sequentially any more. The FTL layer
> internally wants to GC those holes to create a large empty erase
> block. I do see where to pick up the next write location can have a
> huge impact on the flash internal GC behavior and write amplification
> factor.

And that is the point.  The FTL will always do a bad job with these work
loads.  You should not do overwrites, and can do much better
optimizations in the MM based on that.  I'm pretty sure YoungJun can
explain all what they did.

> 
> > would do the right thing.  So please no conditional version that need
> 
> I agree. There is another LSF/MM topic related to this, the plug-able
> swap ops backends. I hope that the flash friendly swap layout can
> implement the swap ops framework without conditional versioning nor
> stack block drivers.
> 
> https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/

And it should just be the default block device (and maybe file backed)
swap.


