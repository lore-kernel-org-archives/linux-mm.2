Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D741CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042AB8E0008; Wed, 15 Oct 2025 03:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A148E0002; Wed, 15 Oct 2025 03:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99CE8E0008; Wed, 15 Oct 2025 03:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D98348E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:29:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94E6ABD172
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:29:18 +0000 (UTC)
X-FDA: 83999522796.03.1D41B10
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id 04B8580007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:29:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/jqV4kzoi87kR6CjE870xFxBQep7fEAX3ZGebZY8SQ4=;
	b=2XPz50gzD6AVlWNDdadMEdJLy0iWEvZF2UM2DlO3p/VHmHM41A1BGVE1Z5OjctohmAp5qw
	6HoCav5//hw2U6Ws669cGyWM6GIx9wcH6Aqhz+pbScBdgtCQpb7Vh39wfrDoaOlwJPiESS
	DHfunqE6TEESxdQeFd/7e2RVbyYCLaY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513357; a=rsa-sha256;
	cv=none;
	b=INPu2bCT4xt+RI84/9THYT8SI10QbTS/G26E3yMOINV8vzcOTQTEPnPktHQ/SGoDwO2ZKm
	p77z8Vaptm2CAxUHs+haPVFqdjk1wCoSYEI7C1T1nCRxMwasqw2NcxvE2BZRzhA1ktdO/o
	4FxEbHMgugNIaAY0xdBZjpPm5atK5wM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 66DAC227A88; Wed, 15 Oct 2025 09:29:12 +0200 (CEST)
Date: Wed, 15 Oct 2025 09:29:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu,
	agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com,
	axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 09/16] f2fs: add support in f2fs to handle multiple
 writeback contexts
Message-ID: <20251015072912.GA11294@lst.de>
References: <20251014120845.2361-1-kundan.kumar@samsung.com> <CGME20251014121102epcas5p3280cd3e6bf16a2fb6a7fe483751f07a7@epcas5p3.samsung.com> <20251014120845.2361-10-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014120845.2361-10-kundan.kumar@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 04B8580007
X-Rspamd-Server: rspam03
X-Stat-Signature: 443w5zawkydp15kxuyrtyy8bpx9kmjcg
X-HE-Tag: 1760513356-869932
X-HE-Meta: U2FsdGVkX19yRIPu35sS4wNoAT7Hom3o6jW8YTP8kto+KG+5B1WuJ4q3MAysKXPWQkPByGePSJCYvZz6O2/IS9r2YkxXPPE5J/ed435if32GwMTemJk68FI0AWuplnHz8AN06iPtvsDVZWin6LSKMAgAjnwPbaXjgybaIp7I4PU2mmHO9XNrr2aLkxD4OQu1MWC4kJWacJsSFme1lWsiAYwambNMbtw/XeG5zilpwnLZhm5pv1BJwCzUx7eG0RSIKgV9cGwu4R14tnxxS9uISlaDOrnLrVbDZ0JOEfCBm3SP1hgKpKMrNnbkN0SF2OJm3gBsBqif8r43tMVsqJg97EOzfvgHDWbCpxJV4wg1cvCEvvJmKxOyPwDJ+U6PKcsdbKwEi1rpDRXqaBih56gAiluyS6mg7rxmcJgan+Dp90bX7Qrh1Eyn8FxCWseaD+5qQy4OaLG2+5E/w9VoEXUO2Bs2YnJdMKIhExqmfkXEdqjMnSySez/hE5tOfNkKaVVTP07ATobmZ0BfBXeTAG8MaCU3P1rXDyXWizvn9dNeVEL8YA/Pc5p6n2IyRgaCtoVE7eE1a7i9mInn0Nok1NxQXrrpzoDHfLfYnAT4GvcPiYA3Jz4haoz63bvjBx2BStRbJ9VcFFVoYpht8UM4CLiIvWkb/ouOm9BNiX6oP1aF8CqN4VSp3ksaQVni/VqTRmdpzsSRv6fBJ4VOkIds0Vz+ax6B7++t0ZSH+jP9QDtn9tjiaooUE5DBolb+CvXUSFMLIGac+7Oa2mA3SrTKI6GpLlttybvok9Zh5M4099s7b1XdPP809x62L8I1WzW6MdhWbbra+Azaj5e9plYvheM/BqDkiVUyKPUcfoU3/cknMYkvbboo8zvw7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:38:38PM +0530, Kundan Kumar wrote:
> Add support to handle multiple writeback contexts and check for
> dirty_exceeded across all the writeback contexts.

As said last time, please do a preparation series with all these
cleanups for file systems poking into writeback internals that can
go in ASAP and sets the stage for multithreaded writeback.


