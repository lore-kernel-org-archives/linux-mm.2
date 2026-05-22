Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FE5CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48CA36B00A4; Fri, 22 May 2026 10:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464956B00A5; Fri, 22 May 2026 10:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0F16B00AA; Fri, 22 May 2026 10:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 282AE6B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:05:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1CF5161994
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:05:04 +0000 (UTC)
X-FDA: 84795227328.15.C197A25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B8AC018001C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:05:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxNBYUYp;
	spf=pass (imf16.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779458702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Ie8d2ZAmeBfN3v2/FX4Pbrv/H8u5AdvngzMgJa2Mf8=;
	b=nMXsJsJdqycaM6ii2ziQKXpwa3Ch8Dfcz4HrJHe5ThorOyc3CMhqLr6bbrfy57ywe6/iue
	aw0c9bvPwA5LtYauOzFPefuBm7zwfrYJL4ewvOQH2So0LrK2Ot+U+vGsybREFzfPw0yTSK
	ILl8suu3eVEkuRNtENMaX9jmm86ynag=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxNBYUYp;
	spf=pass (imf16.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779458702; a=rsa-sha256;
	cv=none;
	b=MqctTbvHL3KW/ma6uEjuYeU31fKdOmF8Es959bRvdFVOQfFKiHg7VhaUNN5waarvm3ypqm
	UNTfnC7FVj0KCvoHCbKmgaRV+rt9F0OlJBmDMMEfrypmwwt72fCL7mPTweVEQS7q8XlGTj
	dyBDXnobrlCtQgLlrD+O9aRjX4uQLZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B66A5403FF;
	Fri, 22 May 2026 14:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490CD1F000E9;
	Fri, 22 May 2026 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779458701;
	bh=6Ie8d2ZAmeBfN3v2/FX4Pbrv/H8u5AdvngzMgJa2Mf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mxNBYUYpnAWw8vEEAYBoOy4sKcHYDEtI47yZ4w+/tWMhgmVlXSO42ghF4ocDrA/Aa
	 qEOD7hdtIQYl+6j50auuLdIOl4bUcsbtT55PmICGuXR7SyMh2ebncRH9j18harNy5s
	 qlg/hCMCHbwEcgsALFwbKABqFNiMuxZd3EMh9xh0gVby+C5KXSKR84QkV32rnI8LT2
	 0bJ3nVYCp8E/zU5w0An8h/WG1g338+A/m44oNUI74RvF777xYt+qVpBF6hWgaauV0t
	 7bt0Lz1+iQNY/540jiITxZLdfliZjCalbs6kr6IUzf0TtDKSgYbup6xFpsqphGMUf0
	 SoRh5hhyPT4Fw==
Date: Fri, 22 May 2026 14:04:59 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahBii6bk0KbK_NHV@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahBSXyOi9b1jxNkX@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8AC018001C
X-Stat-Signature: qowcd5ow88wp4qncscam6frjfg8z8rum
X-HE-Tag: 1779458702-962586
X-HE-Meta: U2FsdGVkX1/x4YE9QY2lY/nWkJ0VKPuICJB1DnndhFqUxerO8mr9MTUG7czxEJ/itbTmu+D7hAVz8QR96p5iLZV/lnn1Zu/uOP7NDnMOD6yw9ZSLvAws+oH79niTW8RZT73wIPawd46G+1TwlxBm3R/0MfIZSRJW5AZ0juuIPFV18U9aO0fE6daH9YeOmfGx32OgoBsOfsap57nZCs6n2rQe+GONevZjRQNGi4Ym97j9q4hKJYDzKXcqZ8Mjb/gEaO22Bc+PG/3KLx3sBLto6xohB4xJCpct8U1DlMBDaoiu61Gbccm9Lixzxk94zX+LAjSTcV1/QJ+4iP7b/J9BF84o9fBFcozJZV818x6GiRRirGSvXVwxeURQcR9RsyVPR7OJHxtvOH+0SIwFIvhgaUzo1yBipBvEZs3L5XF8wLYVWQ2VbU/HUHOOz9QK1CpI0njjWqwLAj635TkpAs+8+Ev+mWT3gGNluGJ19AsICCFE+NgE22ronbGxlHT+I55tNKPSzUiz+73nEr5ciwecfqmY5d3s9caeZokdGUnl4uERirwSlOLcq+FVqrenHbzq64OpwcKSF18B7/StyzzxxOLsksAW3s1R6BP5Lech9GHLgVLsoqoAJ5yHszrQLm3fxhuoxG7TjSEKBDjxwFG7mXas7v8zTQx0jktNvTmzpEvRne+WERTlqLvZbG9lSkFPkAUNPjdrM/sj40uHiJbfWVjpY4kmlJFrBDEAOQ/+e9qA3qwDEUQsa2+AUwIhimkvRqB7NP9QTx206JLP6TLprVepr0QhMmZ24URsUfx4URQmFnJd5Jw/j7c43nZBwi6f0LPg+fPMDRutPaCp96BNLs5P+jUFuFGxqaUeXj5erlJL7b47Ea14Tf5/uo4oqiAosQcG6KyY7T921C4nW16kESPqCsf03jScKAbwy3Ft8ugKdzDEuVx+J8lFlL8whXw9vTfweR5rLDLt81zPvYZ
 OSs/7KvK
 v162TRTkTFE/PHO54YvT9RmPebpSKnYr9GyK+Qa3+VqF6hfWUtrUmE+PuDmmD3AKqFlsqUkXuDWLN2umFWWaIw1pBE98pFPLHjxQP4PcRe5nqbF0nob6iNvdiCQqlVlsy2LOUvdkaN8BKdcfEf5TM1NGlqV0X1AnwZk/LAu8et12TLkQM4nL2Z2NUA/8vaVVRw2PjS2eZN1a1xoQXjhEiAxdsCQRqc7gxBlDMq7cEzap+6ofq/XAZCrk+rU8fT/v0lKgknH+/8kS2QwsDFxUzECRHKaceMsZ/K9wkuCDPI5kKK/ufnmZwy5QI4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/22, Matthew Wilcox wrote:
> On Fri, May 22, 2026 at 03:59:45AM +0000, Jaegeuk Kim wrote:
> > On 05/21, Matthew Wilcox wrote:
> > > On Thu, May 21, 2026 at 11:57:48AM -0400, Theodore Tso wrote:
> > > > So let me get this straight.  This is a magic xattr interface which is
> > > > not even persisted in the file system, but instead sets a 32-bit
> > > > bitmask in the struct inode which disappears once the inode gets
> > > > flushed from the inode stack.  And it uses a generic xattr name,
> > > > "user.fadvise".
> > > > 
> > > > There's no way in *hell* any other file system is likely to adopt such
> > > > a broken interface, so why didn't you just use an ioctl to set this
> > > > magic f2fs-specific flag?
> > > 
> > > I mean, yes, this API is horrendous.  But it's just another example of
> > > f2fs thinking it's somehow special and not just enabling large folios
> > > like other filesystems do.  This hurts everyone, not just people who use
> > > f2fs.
> > 
> > >From the production viewpoint, I raised a concern on setting large folio by
> > default, since that exhausts lots of high-order pages, which were needed for
> > essential system services and critical apps.
> 
> Random fears or actual data?

This was a quick buddyinfo right after booting the device.

Before:
Node 0, zone   Normal  22684  42284  28704  16901   9515   4566   1854    673    181     36    758

After disabling EROFS large folio:
Node 0, zone   Normal   8486   4732   2175   1161    697    272     82     19      3      1    856

> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

