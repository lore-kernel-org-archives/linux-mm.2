Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DCD3CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 12:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3826B0093; Fri, 22 May 2026 08:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784F06B0095; Fri, 22 May 2026 08:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A356B0096; Fri, 22 May 2026 08:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57CCB6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:56:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E611B8F8FE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:56:08 +0000 (UTC)
X-FDA: 84795053616.15.A673E6C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7400240002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:56:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="XvONFtj/";
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779454567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJRt9Lpuwesly2s9mn+jBQgZQVuZWSioljyp5VarGsg=;
	b=cxr00gk21ywiiIV2TVMwx/9HO4SaiYfUvuWVf68+06ofEXLmsEIj3uTxT2SN8FIhj5vU0W
	HhUjHgBgA7e2IYI2wG2nFL5m9WdJdqvHfVkKL5qnwNSFyKYks3hqzDX5cgBSkljXeYebHd
	JfPgC23RsGurt0Ew7RlalEhuoiIvuEI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="XvONFtj/";
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779454567; a=rsa-sha256;
	cv=none;
	b=RcxDzhmfbBi24QIo8roai3MqhD3CNoe38ZYL5VZ5WDcqMc4dEWXDYZDvhv1TaUyq8/TNtc
	5JLKL//ogCIQj+sa2NkiD8WICufpUqKLJ9nWWjHRf48fL67PEANkUSU0peNpKmXhhOsDoi
	cefqN9QN8eCX4aGcJ/lpG96pL+3GDwU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GJRt9Lpuwesly2s9mn+jBQgZQVuZWSioljyp5VarGsg=; b=XvONFtj/OYXrdj+0CGgw20dTEG
	RY2jeN/WZcKK38rmHxiRjUt+SntpeA8EPhwp2eWQWftIp/acL8AUxIddJ+0Qpiy+TLiwpATROeCSo
	Fs8dFNF5pwkTnR8BnpYnT1ogZ2D4SQiq/XJ/cQlURwpKK+ui/LLoaO9oOVEQE/K2K3XuLXS3K9dTC
	Zw4aVVXiNdo4g11gW8T3dKmIDul5g8DUK/ZAhtr+ArwedNMhdliuq3YawrBCctxlDVIeoH478fdCF
	3c5teZhzX197GPxz/qNKg4LapdHnk4Ok9Nta/gHolWI0GTNkbg16dMhpolPgBSuplVd/zsQQPhcqZ
	hutvFDhg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQPPz-0000000A6hF-37gM;
	Fri, 22 May 2026 12:55:59 +0000
Date: Fri, 22 May 2026 13:55:59 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org, Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ahBSXyOi9b1jxNkX@casper.infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag_UsW_OrlXD9dWX@google.com>
X-Stat-Signature: 9ycnk6qoo5fd8ce7opbye14uc7zy8pnh
X-Rspamd-Queue-Id: 7400240002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779454566-84055
X-HE-Meta: U2FsdGVkX19QJ1rR/Wsu9MpzMwPdQewjiK+BOdA9IjlFQu7hXjPzJ3dCDPaDnjecZPuXdynBzc6UFAorqCHw7L7rC/XC7G3azHf47Z+GdF2UYkL9G22rWwH7I5D4++Vt2+r2u94H2RkpGVt9qu4Vp2AzfpHV5naIVmftALvqODfiVNpZrZIQOaoC7ABcmF29oZOVRU4j3nyQ+8uxqKY/GANnLZOSQnPTtxpcZPfMPn05zYeIB7PTKyH3ukXc5oVO0rbCwCm/aYix2zzm7sp4tNjaA0dT4fZgkASi4o0XuOPjI14NPJ9sTKiL/oJQx3sy1et6s+Ovyp3pbXT4fARtHHJnFJQuV3nB9OvySs0DwV3JuN2RHBGltD4JmcKjbVK3pn8n0JKbyHRNxXB7lVQPZ763N4YzjJ6dlTHz7M/jfN3DGg0FZddYkxV3B7lH7CUSfUYJKPiXH5H0wt5gywQYujSUk02EURVpsg+ud00CTFhY+v4ZvFcAYL4kTQqWllImWdPqWeGoFS5Bdbhy4Cae++MfJj50INTD29rbXR95ppfSaXE1Jrk0S8EO+LGijamHAYnToRUvAy2TMp4JSpuuI0tEc2NBIdHLtLhhJC4fIe9hzs3Cie8orndxaY5J6xWm47rrlmIxOqopHDlsTZevJgwtX9Vb7lcbDE281Q8+X7JmnNcYHkmArHN95gDwFrNVx/JpYyu3uDZAU4e7ZqX1FIhAnYGKpKpT1W2WgTbh8KEZOQnn3k3IQG1weGr7lHxwLSpqpPTOex91jni/MAHayu1KIOEMqiqs9O9iFCdZk8RxtvGf5/MnfsvsCdlijc6WcBJAmWiGEwfN7eeDTniR3H/asT7rYuFgUWZuHYuV2Y+jisO8T2PYbsSRUUM/k4E+EELFc6bEQhxlOTaqgPnXAGfQiGR+HhUMkp6VzJ1Z+cU8B3PTxw/ZijoayI7hqlTQG/XOyRQtT2Kcr1sBetN
 DlQBKtE1
 i+Nq8l4W+6mj2+q0oj3KEuClUOGjt5nilbo9zqrPfmZRpNSt2RMhfSwPs26IruB2MVvLr1jAsUgBmSy2Tv4f3ena5l0G7acCWg83zmjI3H1Ftf1WptfITfu7kt/TXPtzHPCRatHtGaxweVaLyttUEG+IAW4nT6MT2luP2rwrg0B9JWqZ90p47pR0vL6pyYkWPC6OJB7TbU60TUlcq6fOFvxkgX2JKAPJO/oDuVUcpq4EBpz/V2hZmeN7F2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 03:59:45AM +0000, Jaegeuk Kim wrote:
> On 05/21, Matthew Wilcox wrote:
> > On Thu, May 21, 2026 at 11:57:48AM -0400, Theodore Tso wrote:
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
> > I mean, yes, this API is horrendous.  But it's just another example of
> > f2fs thinking it's somehow special and not just enabling large folios
> > like other filesystems do.  This hurts everyone, not just people who use
> > f2fs.
> 
> >From the production viewpoint, I raised a concern on setting large folio by
> default, since that exhausts lots of high-order pages, which were needed for
> essential system services and critical apps.

Random fears or actual data?

