Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7117ECD5BB5
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 10:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5DD46B0093; Fri, 22 May 2026 06:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D351A6B0095; Fri, 22 May 2026 06:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73546B0096; Fri, 22 May 2026 06:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B70276B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:01:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7922C1404D0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:01:36 +0000 (UTC)
X-FDA: 84794613792.24.400C2B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A4F8D140013
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:01:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuTE1gQM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779444094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUJJoHYpPqVRUhbcG+UWt+HVEM6K0BEVeHttssE5XbE=;
	b=hXinw1s3f+Wz8EHMpp9dTL3RoRApfbtczM02SqjIwQAEgt8sFvlYX3rY7QGqc0MBIaza/6
	NvN2HWbdViOmi9kChx/YP9XLjJe5jnmw4WJbHbIDtc1w9S2TjdZkf0V76IQ2TJC7n6NpxJ
	7rUHR6p1MRYfWoe8SomNjgZec5Gk6Rs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779444094; a=rsa-sha256;
	cv=none;
	b=ZFr1mUMZ2uZwueAzrBBOFRbyAnkpLql0U9wyx+/N8kbRdiBWC73ZIYAXlV847atCGlZGQe
	DwFs739uR+40SC3DAEVZVe2w5ikxH2XjFIfLEAjs4cquwtZQDnjTqRPXNHx9C0Lgkvi3qG
	/edW2r2uv7VaKewULWGvF11aMAvIwL0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuTE1gQM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF44A437CA;
	Fri, 22 May 2026 10:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9161F000E9;
	Fri, 22 May 2026 10:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779444093;
	bh=ZUJJoHYpPqVRUhbcG+UWt+HVEM6K0BEVeHttssE5XbE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=DuTE1gQME7Jx//aKkceOJJnFYFECfnCnzPz6WQ0+Dp1jSLdzAgLScIoL2da/3pkoS
	 0A6vEGBqorCPVj6OCamZ8Tfap/3bnyQX+QmtZGZYeab5qlRw2+vKDqPID9QGVpxLq7
	 fAkTaGwnH25Eid1nQdCkxa0+qwbaG9XTztNh48zJNgAVodlmZKw3AJPnuoto5YaBSi
	 as7U27VbiP6G7JIBlfB9UHDpgqrmCMlnWiimFah3MEIvnkTcLPk+KFFH3eIUn6YIM2
	 yMbsk5vo9eYS0GYxc+yq2QBSOhiM0zrahxQlsLXfMFeVAsL+oJMd1SzAOMET+BPVGu
	 4g0lyvd0Kh0cg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
From: Christian Brauner <brauner@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Tso <tytso@mit.edu>, 
 Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, 
 linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, Akilesh Kailash <akailash@google.com>, 
 Christian Brauner <christian@brauner.io>
In-Reply-To: <20260522035331.GE5937@quark>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com> <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com> <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan> <ag_OVwPF49LSZ7rz@google.com>
 <20260522035331.GE5937@quark>
Date: Fri, 22 May 2026 12:01:29 +0200
Message-Id: <20260522-popkultur-spagat-beziffern-00f57ebc8fca@brauner>
X-Mailer: b4 0.16-dev-05c9c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1901; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1DLZ37kHhU1rHpEQEUMqDeqagX+iutwlVMzplz9dpLo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQJaFa9032xQZB1ooTgrtQMj6mneF33Vt/Y9yTNLOL2p
 qCTQa1fO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbir8bI8LJK6YxQ3bHfec9e
 ue9dfSWkodnjwV+3YsOzy9zq2uxnnmZkuDmb/9RHxd64GRJ/ebK9ktU0E/gn7vSzNhBZq2mq05j
 PDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A4F8D140013
X-Stat-Signature: 965xb4ax1bqaswzs8mpy8kcqfif4tch9
X-Rspam-User: 
X-HE-Tag: 1779444094-293726
X-HE-Meta: U2FsdGVkX19gcBKlJ1+3v3azwXOiM79+ccGhIyN/VtrARDz9CVpFWuTwwG3J+p53YAQDs13I8nxT3769Hx725vdjne8dl3XNPggQUf+LfWKOO2ARCRNSj4ZhABC2WeG5oVUjAxxuEialjXmS9WxjUR7eZgHyF6JAYodnz1xvxt4Vp8CHdajJAkG81v5vEmE48UHTbpCf00t70GIbKPfgH7i/QSkUDFRcD+ZAprYXhs0wMslaenCJwDiHqcwCe71GyTHg2h+fTnkfM2TCtj2s7orrt/k59WrGmSnby8s2VjV3GokYVaJX+3hk1CFJgLS5yJOOn+bv9afU39iDjYeWYwhHqx7tljd1me6aWuP6eS6WWpESE5gwWyhkXPVC4DF2814xuG0hq3AhquKrrKB8qoK3vNQM109kKyHB7aN2mhds3jamUPPTzL8JKPa6a5eH0qvQKvEGMq6YelNL6xdN9by/kwT5PSuq4Y2+Q+rrANRtyWbRF2bK3c14xhE1Zt2R+o8CYTBYIoAVI2Dpi/qlWXGfRlk6Ow4M4YI7hdZF9qw9nwb6qvJItcwtkbifiDRUStc+NZ9JqCoWeho5EKd+U7JJGxCNBoiXEYrXO7R/N1YV4jB6HrOkAYZzo/43PQRooOWvyvoJzYF5nUgSop6S+alqpQXReF1QYGtSyI5EB1sD6wQg+p9grooZDKPIL482DYgV12IvLT6Mlli5Ja0kUoYMh2GWJnvAPuShj+N2L3gEqkmQd5FQ1Zr1NeOzmfWSuL7i9RN9ReX0KZhWcdk1B52QsirrO3urdrtGP5TKwWjujNGMsXbXhZPwo8MCQ0hL/PcH9QtvrSTWiezU+UiOguqGS7sHGngOLFoWQKqWS+Dtw9ncVfglnbRj/oKzK2j6Noi9Fpk+Me5ZoYqJhOVr7ZV5kJy6TQ1uZUNPvYMLO/ZPn66Xlm/3Dm0oaprUHppY2SXXbRR7I+MYmNi8qqQ
 A39qrBg0
 LNPL+3xGFq3izF4HSDJ4qFc2q15sNKMDMlQJcQXx8wekiENFiECUU7ojm+tfA2S65Ssc28hXcZB2hRoyY0qrKNBw6RgUTC8A6JpBQJuoq2L+JfspqKkRl75Y+M3n1Ge/nkP41tsSBRtJzveF5LgXKN8U4GIOGoqdQrOmnnXp9LYzaperu0ZdN4/r60MY+hNmIObnGbtVaiE1GVKC4f0tmeEF81VqGC3fNUuMg5SRYBg68Y2dX0Wdqh191WkzSrKv+Z0FKJD8RA8Ysnu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-21 22:53 -0500, Eric Biggers wrote:
> On Fri, May 22, 2026 at 03:32:39AM +0000, Jaegeuk Kim wrote:
> > On 05/21, Theodore Tso wrote:
> > > On Thu, May 21, 2026 at 01:51:08AM -0700, Christoph Hellwig wrote:
> > > > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > > > patch.  There's no justification for why f2fs is so special that it
> > > > > needs this.  What the hell is going on?  You know this is not the way to
> > > > > get code merged into Linux.
> > > > 
> > > > None of this got properly answers, and this broken interface now landed
> > > > in linux-next. IT is offloading a user.* xattr which is free-form
> > > > user data with semantics that are weird to say it very nicely.
> > > > 
> > > > All this was done against the advice in the mailing list discussion.
> > > 
> > > So let me get this straight.  This is a magic xattr interface which is
> > > not even persisted in the file system, but instead sets a 32-bit
> > > bitmask in the struct inode which disappears once the inode gets
> > > flushed from the inode stack.  And it uses a generic xattr name,
> > > "user.fadvise".
> > > 
> > > There's no way in *hell* any other file system is likely to adopt such
> > > a broken interface, so why didn't you just use an ioctl to set this
> > > magic f2fs-specific flag?
> > 
> > I went this route because Android heavily restricts ioctl() permissions
> > and we needed broader access for this to work within the framework.
> 
> It's straightforward (2 lines I think) to update Android's SELinux
> policy to allow an ioctl in all domains.  So that doesn't seem like a
> reason to not use an ioctl.  In fact this is actually a reason *to* use
> an ioctl, as it shows that ioctls can be allowed/denied independently as
> needed, whereas xattrs just use the file write permission.

Thank you, I very much agree.


