Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C10CCCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 04:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9C08E0005; Wed, 22 Oct 2025 00:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA6E8E0002; Wed, 22 Oct 2025 00:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0398E0005; Wed, 22 Oct 2025 00:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4F548E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:39:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5829E119F3B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:39:39 +0000 (UTC)
X-FDA: 84024496878.27.730F3C2
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6CFC8C000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:39:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761107977; a=rsa-sha256;
	cv=none;
	b=PYs3FzsVTVPDOwZc0/7GRLrwn+z7y/A+GReGHu0bBrjHaqeqpuE9Kxb6emqxQiokBP0qMu
	j0CbZxJlNvbwquqRBScIhpQFJr1exAcw8zQQHpsUhBesSqldGDYGA1AK+gYiLVjf41OZ7c
	E3uHfWzTsvqvV8++XF1d0Mf11SN0NdY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761107977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qatNIJci3WKhQ+0+JT0//JgJlcNnKbGMZhbGMbS1LLU=;
	b=gMatsM8fx9JO8BL0dIRuF7eb3OrVKFk893+i4EknNxC9rXYwzsCxlKI6tjo/PgKCvMHrVO
	gZSTxHCLKHnFcX6iuHHU2Sm0k4qx7axRn//Po9oecfvdTbP1wkiaHmMeLTCC4MarVhkAn3
	L7ljgEXUXm7RbAvqvcpd2Y/fuRhyg7o=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 79DC1227A88; Wed, 22 Oct 2025 06:39:30 +0200 (CEST)
Date: Wed, 22 Oct 2025 06:39:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Kundan Kumar <kundan.kumar@samsung.com>, jaegeuk@kernel.org,
	chao@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de,
	ritesh.list@gmail.com, djwong@kernel.org, dave@stgolabs.net,
	wangyufei@vivo.com, linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-ID: <20251022043930.GC2371@lst.de>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com> <20251014120845.2361-1-kundan.kumar@samsung.com> <aPa7xozr7YbZX0W4@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPa7xozr7YbZX0W4@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Stat-Signature: 88cd3ednxh4ghriy3xa9fe99wp7keism
X-Rspamd-Queue-Id: 6CFC8C000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1761107977-6738
X-HE-Meta: U2FsdGVkX199cHazeof5RWUhO9tKuNJKhSAqRIZcDw1uOj2j4BF9Dupg0f2dUrwLx/licZA2DLtkiE+xM8QCieu5Qoff0S5Xam2Bw1kasv30ykYwZ/v36Uw1Fb2M3lNdZXS/wSGprusKfs4PB9bcbGXoKH5M/LZ+ta/eFoOU9AEIYmkWab7zbECpyrVBKX++WroVptJvc+Xewgu+5PC4j8YmUAKbAt8bQT9PRfLa5egmRjtDToWQarViS3sq5IXFFS891pIw75ywkgyUDDwJ5GEPFihLSqHeL7P1ieGDLl3NUbSvgWPDe2oxIH6/cma/RPRzEpr+EoVPCrw7dSknJt8EtpJoM1eWpR1SuwJAF4/iRjhcRpb3F8+Zygbv3lOt9K6q3TZQ+ClsOu2vlIM36I4Q4lLD8TPK5ZQ9S9PKPuMc/k1e3Hblee8O70zV5xm8epoz6zcjFb3ZHuJRCSOA//VrIthWeGrVZwFtra9BxLVEAwBULkJ2JuqJxHN9ne7odrhVARkCutmnhnbPBwtXBtlNGsfk9T60smLDfD12ZWTIRg3a+AYXoAupUDbJyOIir/QPaBWn9mim9X058Qmr34pg+GtZo9c2NCBCjGkIadfr4AjLqFHHN+bJA0lEO/ovP7IqdVaX2RfXVVZLl1YM0qW5sX/2uUBU6jIIFJ31JOahmG1c+jzr4RS8gf+0lhg0UNoTUI0i6jt6Nc1CLnDfU8RwTlEF56eGf6/wfnA1VvXjQO45f11uT9Yoz6NvmdH+Ti3SgpHXQxhyNTIvKoJQ3K5Xnnl5GBMCO8ebZB5ObXr9z/MN4B7Da1Uv+Ya6RZMZJf54TzU7n0Iu3lSqAygLhKJ4fwYvxpUoRyWQa6I2sPXwu/vmz7bdULxourflQksNSloeLQ4VxOpOH6O6ppJgyc6fY27Jjb9EKIvRRC1dvymg9lRL2tXCiPw08wiIttWiHvuXKI3m05mmpIZJ3mv
 uUbJwBS6
 5HtO8sbgnZsWM/pdgnttSxykVV8Uwe+ZvApuNBRsC4+okLE+qcE9+3MUMjsc7yBThy33lJei+Zk36prugvdyWZ03JogbCg7NsX+RZ18cudeyRij1ynohM6VBQe+uFVgaGfYiJrpmC7lZmJqUA0JwrsEFPE5Gvq1tF/Gy/3lOqOfjHtAA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:46:30AM +1100, Dave Chinner wrote:
> Not necessarily. The allocator can (and will) select different AGs
> for an inode as the file grows and the AGs run low on space. Once
> they select a different AG for an inode, they don't tend to return
> to the original AG because allocation targets are based on
> contiguous allocation w.r.t. existing adjacent extents, not the AG
> the inode is located in.

Also, as pointed out in the last discussion of this for the RT
subvolume there is zero relation between the AG the inode is in
and the data placement.


