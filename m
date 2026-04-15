Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511C9F433CC
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 23:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406276B0005; Wed, 15 Apr 2026 19:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDC36B0088; Wed, 15 Apr 2026 19:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320936B008A; Wed, 15 Apr 2026 19:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 242686B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 19:49:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FF651403AD
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:49:53 +0000 (UTC)
X-FDA: 84662435466.28.03C832E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 19884180002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:49:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ge9Qbkzs;
	spf=pass (imf24.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776296992; a=rsa-sha256;
	cv=none;
	b=gSr7M1Jq/jYmRMPj+IkYmxnH4MXhxB+VQ7zdw6nxCDzevWu5DMGGCervwzl/umKHxsGiHn
	6AImyU3Z2FNjOSX3SREUC4SSIAQWj0xF76AGhVSaJ/urqP/dxDYihbEPk0U11PiKgPYudl
	zJfFGXH0n39FMXl1a5z3nOLF0lFa5eo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ge9Qbkzs;
	spf=pass (imf24.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776296992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjhMg+XTJ8vD1knZMk0780PDEOcpk7IUgKgH5FGYA44=;
	b=eTMdwMRstRtYXmc6PK2U4P+BLfCYGBNrcm93l5nc1li6a53OWFgQ3f+TD43AdJUAnZ+DGb
	rwHqWVfC0BrM/kp4+boHjAUiZkQaEZ771l2c7TVBln3Xme3VIRbYGJJhfFHffrSrEbSoGK
	jOslBK+WlE1iZihjYeWrbDHcKsUh2MU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 44C9960120;
	Wed, 15 Apr 2026 23:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FA5C19424;
	Wed, 15 Apr 2026 23:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776296991;
	bh=bhzPcr54kj93Lar47tpSoGS//g7BeP0fXCsSgCGIxx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ge9QbkzscZBvCjcBhgKDz2GqrcXm/RrpTicTJ1C2AxNrzFCS+cW8ACjvA07sMrKqC
	 xczyLQTyKLi34rLkm0xjlzT2PHoDxArNE0y3v6NHbmv8nEVa5BTRhUTBUb07fCTh82
	 Q4xApYXqDybkAxwRJDqeViTN8mLxeZ5xw7bMwla0ea4V1SVp18q7wo7MQ1+kL2AvkV
	 vliMPs6Hvdt97hstZPQ3/HWpfeCPidYKckDGF/xGw5r1yT4fTBoXvrL/ShTbuJUbcq
	 6EdGABII3cr46jiuv2XfvazrXocFUOk3aNhbgl6MU74pARV3gd5SXMf/zoQHSHSjfM
	 6Akb1rdBni93Q==
Date: Wed, 15 Apr 2026 16:49:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <20260415234950.GC114184@frogsfrogsfrogs>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <aeAK8mFxzgMOepmZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeAK8mFxzgMOepmZ@google.com>
X-Rspamd-Queue-Id: 19884180002
X-Stat-Signature: h9zdeyi3z71ge8wesg8koc5eiypxxtbt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776296991-395262
X-HE-Meta: U2FsdGVkX1+HgiMupvPigXngudadJnkg4DDldqxRQPUjZJ0MsUw4OoA9Sr1UtuT1iWLW3QaWIdmJqGR50KMvYm604v3aJJD344hmS9qXTVf7cZCeNWRsRICmTeJTfoQhA290AOzhtzY4pZ3wZtxB38tkjJa+MjR2y5YC9wCP7VRbY6LkhQFozU88u6OwMb+f5ItihAF9A064XB9hYFcdTyurd3Qdyu0/H7CWmaXOEG8k2OI8xn8/3UfHcUorW+Z+BJyobTSLzY82cpWsYtd/PrzC6LdoU4kpFU8fgC3I784qoigUcwaB9nkZHvtPsWJN9Cj45ifMDaHHbcfx3tAn8/7Hffl3N9Pc3kJKqDWgGBjxnA7z4X+4ug6LUEX3JMtvpX1nS+qe0vof5mRxOgcXTi3N6gcqeveIPunz+wT5FoA+RQT5Cl4Kiy88ak6pzvE/obyNSAyqD2z3nxjSjf5V39R0uG/Rg0fcq74tWNFpU0DEG1qvrW/PZfP7fKaE0Jy1Vsv6NsoodzMvqKghWioOOfnIhBsPHzVgmilxFvMtl2dpTzN4HKSXIcmRqmbz3AQQ2PXxk6wwBqn9y0pGMr2wa3t0DEGZuzi+B3Cb2n2bHY3gQNqlx2Y4IaiFSo0PJ/aDW86Axh8KAfI0EGkkFyoGgbVpLJS9SNLzyaB10JXSySHt9t96pJEVgi8aIUkSP0rpzrBWnagZy+OxXADVTtL7f6ntbq4HvnfQa5auNUeC2GpWfycXNemcquJXra9np9CF6GaPobTaq3E1x9OUW5CTwsCCey4j/ivc/3myUls2Py2hg6ZEOqF9WuH4+ICTjakgD8+FkhpJJ0/mJ/qXZB6hjvK2tdoCDQ1Ezdqi2mWN45irZd2gXA8+p4kOga+ZRfdyuF9IQkLunB03aAkR2KpCPirKDO4NaN+X/6qSmjv1eRPUIy9Ma59Bx4bg1QBinhCSJqvBgutOSW3RjHvyNAu
 z3xzUaml
 3RbRIOrbqQguw2yXXGptoDeNvC2MdRTMYOtvtnf2i0pR5tplXwRMwKq2DEoNF1xiC8ijVUDNyaYjDgTZhPj3pN0mP8/Fa4mbc5HtzGvG+ciwUByOZ6Z3tJcUcksoiU5D7E9Q08IlEetwkrRf8aErNFghCZ6NBum+bKGM1LzS1+UGJqkjwmwg4MS2aCvDDhhPt/IRay0DodV8GvIeclXVCd3G4rZNIhtwZrIXS7l28FUysMALTgdctscNvww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 10:02:26PM +0000, Jaegeuk Kim wrote:
> On 04/15, Matthew Wilcox wrote:
> > On Wed, Apr 15, 2026 at 04:44:04PM +0000, Jaegeuk Kim wrote:
> > > On 04/14, Christoph Hellwig wrote:
> > > > Please add the relevant mailing lists when adding new user interfaces.
> > > > 
> > > > And I'm not sure hacks working around the proper large folio
> > > > implementation are something that should be merged upstream.
> > > 
> > > Cc'ed linux-api and linux-fsdevel onto the patch thread with a proposal that
> > > I'm not sure it's acceptable or not. 
> > 
> > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > patch.  There's no justification for why f2fs is so special that it
> > needs this.  What the hell is going on?  You know this is not the way to
> > get code merged into Linux.
> 
> I added two ideas in that email. Have you even tried to understand?

You want to establish "user.fadvise" as an extended attribute containing
a bitmask.  The sole bit defined in that attribute means "use large
folios", but you also have to change the file mode and set the IMMUTABLE
bit for it to actually do anything.

Meanwhile, you can't actually persist any of the fadvise(2) advice
flags, so the xattr name doesn't even make sense.  Maybe you meant to
call it "user.madvise" since the closest thing I can think of is
MADV_HUGEPAGE?

I've understood enough.  YUCK.

--D

