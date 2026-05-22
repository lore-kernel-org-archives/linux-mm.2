Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE505CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 03:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB96E6B0093; Thu, 21 May 2026 23:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A406B0095; Thu, 21 May 2026 23:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F9A6B0096; Thu, 21 May 2026 23:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7AF26B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:32:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57C8C1C1F35
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:32:44 +0000 (UTC)
X-FDA: 84793633848.09.F2E2674
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B5DA1C0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:32:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XU/IlB9S";
	spf=pass (imf18.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779420762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGFAvI18BKBe3vm3c5WorkCHjUcjWwmCPrmYoSAlc2s=;
	b=snDzDJLDAPdB8ML/lmM5hHuYTr0shvCftXYPZW4d5IYQdlqyYG+xEisqDNTS22A2arKUjw
	V6GT0aByEzaFZSZFEni0qNnUSGrPOyJNlNHb2bZ6eJAJvJfZcCXkjluzIcXdYe0ycfOoH/
	aBQddV2vneC5tEJ335J5ly7symTi+BM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XU/IlB9S";
	spf=pass (imf18.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779420762; a=rsa-sha256;
	cv=none;
	b=H25KqN92O1KxIZWYp2EzdW9Z1XnJC1WBXONhnTgECbmN8kq0Lw7S8BweOkC3XknldNJlbL
	cKRR8rNexH+jg4Ert1FSO+A/43dw90gBcUqqoR+BLuNRcD7FZqtl8myt2OjD1E87h+1QTI
	t0TZeyYyd6gVIBL71kmTxKCDy87wyFM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94E2140851;
	Fri, 22 May 2026 03:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240291F000E9;
	Fri, 22 May 2026 03:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779420761;
	bh=CGFAvI18BKBe3vm3c5WorkCHjUcjWwmCPrmYoSAlc2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XU/IlB9SH9nlFWYU/EiIad/OZNWTJfz8uzGq441tNsdlZHlxAhPQwtA2NOjDRpp9S
	 jsCQvoPHpW/b2EqxF4z9HctvBw2zcUUMvy0PL79CW7tF6sSr9KaxQilTtBvSpuNzqm
	 LQb87xxVBr99WUX4SXHuRN9DK8q+KFJ//Sw7qV26y3Fn9lfiqnc2QNNAuAppqwkISa
	 IzKvOiT+uSEDGkJ0H1/ydXDs9FselwOycC80O8y436kSj8vTfb/9oUcRB5YSJcxjNT
	 MqyLv9+oWkNXUQUAOs44eSNwTfA+PX8Cm5Fx7teBgjoWyybo8QhspPJkMRersifqVP
	 doyNr89pmQCpQ==
Date: Fri, 22 May 2026 03:32:39 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ag_OVwPF49LSZ7rz@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260521155748.GA79343@macsyma-wired.lan>
X-Stat-Signature: yetbfttfnsnhp7h7mjuqmquw9rqwa9f5
X-Rspamd-Queue-Id: 9B5DA1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779420762-39482
X-HE-Meta: U2FsdGVkX192R4L3s9Geb0r75SmBT0XPCJ+h6vniWRCXY2HYJLCm12bVbGDo+IzwLaQMhoPpmrAGh57S8ctGiS6kYy5WBpN2qLkTYOZzrpFVAISWvfiXeO0pSEwKcDpVuSL3sZzvxpRpZ0dULlB8xEnbaDwnUz/YZCbxHasSE8LDL4PUqqeJ7CBIvqlftCT1m5Ovh1yc2L1pZs36qpbB+xKk6LQ7reX0qc8VwawdpBbQ8GrnffxTSPAzbwCO2Pblv99X6wFZCxZArwfj3fxPsfPgnaWRYr0NsILUeQuldAU6Ja3Jl+hnOuV89+37zeH83LFLN9eeU831ntKmLIEEkQxstkkH/bxeN8BHeqyCDGBgbGZ0toMbwei0ELNfHvJTCt79zLpYdS4p4NZRMQxjUmF0wfNTvJxwhGd6amjR71pc3k7l1/LkKFoukzHG2Jlkcu6jsq5LOSDggMRCBpQbs8Cyg+sr58wAIr9bDXPzV64v1EdEepkEWP9KzNpey6XW95WU6yvPmnN1P+JYl0VEoWAGYniNI1qogTQUYcHMRwrHABsqQSdCQYNOBA/mGvM4KSp4vwd8haBYBDK4mUYBbD5eySseMMowaEZeCN8k0v/wNhClpri3oBAuScnQLWjyivyCGzy1txxPFgGx2W1I/1TvXdqXv5l1Whbz4sqD4tQ236pyuxPElAiU4cmUQIoAuIEcIpIdlZID4PuPq5864ahqCtQuEWNPiH612tqkt0EXm0fSuwW4VKFaSve3JDuuLVqxO4/1dixMp0kdq5Z2BvV1cQYOC4n9Hdtz/b9r5gLUzBUXA5gF28ROLWlyIRAORlP/M1pAZWsXw63tZjGH+SRSe0eC7Mn4S7wwDO/cy4EOIVIYTdlhUR7uL2SG0JJ1qlX4HR+/5untFBrPYYYcT6tRhdKcOPLtPqi2p1PY2OQDacOWd/Ea9Zon7fZLEC0md1pDgNyfMd/nL1Jo+2X
 FwS/iGfw
 1P2xWBdU7poIgn3sCjl25Cy7OQNJManr8AQavjX+YAfov7yXtgIwTr8XtK1HXvhqDFtvBOElSIaBOx2QyoxSwNKRJnP58N1Ztj7MIjOwl6fvbC9x3NJIDfNo6vyLQCuWgopaOpIJ7leu8/0xPcnWwHtZtY9Fmb9CEcV00KdctStZYdQtSHcu9ZmpRrnvupj8l/By6imygQXGPx2qU1Oyz+j5HCLK98r7enaRWMFPC7+3J3JrlY6UkziyOi4kDwXRnBZ4qmudk6DUJb3qpsM+Ux4fK+MZyKNDQ7XOykXNSOHttJMgEXSvgSji5Vl1Ze/CzTXTSvIJ6irga4Nc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/21, Theodore Tso wrote:
> On Thu, May 21, 2026 at 01:51:08AM -0700, Christoph Hellwig wrote:
> > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > patch.  There's no justification for why f2fs is so special that it
> > > needs this.  What the hell is going on?  You know this is not the way to
> > > get code merged into Linux.
> > 
> > None of this got properly answers, and this broken interface now landed
> > in linux-next. IT is offloading a user.* xattr which is free-form
> > user data with semantics that are weird to say it very nicely.
> > 
> > All this was done against the advice in the mailing list discussion.
> 
> So let me get this straight.  This is a magic xattr interface which is
> not even persisted in the file system, but instead sets a 32-bit
> bitmask in the struct inode which disappears once the inode gets
> flushed from the inode stack.  And it uses a generic xattr name,
> "user.fadvise".
> 
> There's no way in *hell* any other file system is likely to adopt such
> a broken interface, so why didn't you just use an ioctl to set this
> magic f2fs-specific flag?

I went this route because Android heavily restricts ioctl() permissions
and we needed broader access for this to work within the framework. It’s
definitely a pragmatic choice just to get it running in production.

If ioctl() is a right way for upstream, I'm happy to change this patch. By
the way, I really don't understand why all the messages are so offensive,
even without trying to understand the problem or guiding right directions.

> 
> > I think at some point we just need to stop taking f2fs updates likes
> > this.
> 
> Well, that's ultiamtely up to Linus.  I'll say that if I were Linus
> (and I'm glad I'm not :-), and I saw this in a pull request, I'd
> reject it out of hand.  But whether it's worth making a huge fuss and
> asking escalating this mess to Linus, we probably should get a bit
> more community consensus before taking such a drastic step.

Could I also raise a quick concern regarding the phrasing/wording used
in the communications?

> 
> Christian, since you're one of the VFS maintaienrs, what's your
> opinion about escalating this to Linus?
> 
> 					- Ted
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

