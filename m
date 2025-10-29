Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D6A4CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 06:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F89B8E0035; Wed, 29 Oct 2025 02:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CFE18E0015; Wed, 29 Oct 2025 02:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E64B8E0035; Wed, 29 Oct 2025 02:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DEBA8E0015
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 02:09:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E0A9C5A1C7
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:09:35 +0000 (UTC)
X-FDA: 84050125110.15.E198E5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 26B2E1A0007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:09:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jv8axgsk;
	spf=pass (imf19.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761718174; a=rsa-sha256;
	cv=none;
	b=w4aMWOwiukm2nyLmMBnOJseYMFKyDV54dnYNOhqB6rumyp9m+1vqemtPyS+Uqs3bNmoLBQ
	16wVSMEjRg/Ivv9IiDMWYY4MWlhKuTaZvmEu3A9xJ4sArSlq/ticR02vIhd+S3a5QHgzJw
	yiYl/HnVzet0I2lV2f0ohITixbZggj0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jv8axgsk;
	spf=pass (imf19.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761718174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2S7P56jzAj0RQfiBXUJ1E/mSO50DPnJhIS/kgymulE=;
	b=NpkTMxOXLfHsOKfYI6THhPRGKR0Ts0dZpvEbxms5FI2sMTNUW2polcIc5n3ulmIT9CkEqx
	ZKtXISmYBb8SScw2s5m2rtmDjL2X/BTk6hs16Gxqbeh4jWtK0S9kZBim0t8QHR5AVfv/jW
	QbDmj9jsr4aY6NmpciNjyq9FDXuiNgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5256C605CC;
	Wed, 29 Oct 2025 06:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AD4C4CEF7;
	Wed, 29 Oct 2025 06:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761718173;
	bh=KhUCwoEAjcKURljQn6Z5eULKXiBUNQeiGlQ0+eSZ1+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jv8axgsk0a3r/K6s7anKOkdMHyoV9M9ohNLW6Pl1/bQB2ujsqML/NoQhhejBmqaK3
	 86Xp9WXDrWll1/0uizzBMXVWnxjT6M1yQXWhR/dtFAgXer1cs0/+gCJokbdV+U+R7j
	 rh+bSqMZejs5VHCLhtFXE+64+ISmcgtS1QgL9x108T5fFxUd17eLyFDWoTYmrq7fm/
	 VeqiahI9+MlKVwQ85vBqNlyTiOFo7DuhfqFp7iQWb7Tzt1SRshl6CLVMWIgK5bNXru
	 C3dGfWC2R7UhQIz7c+PDEO0phQxrW7dVvcP9VhkDolbrbTYJpovNOzg2NZKZDgxt/m
	 /E7EbpFdhc1wg==
Date: Tue, 28 Oct 2025 23:09:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu,
	agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, amir73il@gmail.com, axboe@kernel.dk,
	ritesh.list@gmail.com, dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-ID: <20251029060932.GS4015566@frogsfrogsfrogs>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
 <20251014120845.2361-1-kundan.kumar@samsung.com>
 <aPa7xozr7YbZX0W4@dread.disaster.area>
 <20251022043930.GC2371@lst.de>
 <e51e4fb9-01f7-4273-a363-fc1c2c61954b@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e51e4fb9-01f7-4273-a363-fc1c2c61954b@samsung.com>
X-Rspam-User: 
X-Stat-Signature: u99o7cjg9qnowuerghobu1xi3gmsncig
X-Rspamd-Queue-Id: 26B2E1A0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761718174-67139
X-HE-Meta: U2FsdGVkX1/ipY6QgPO3aajvAdGhzSU9scGUR/eTHlx3JhtvoVIUEA5q+sgitAMUmOAsx5SyIGdGH25G1CcDQsnUpn0AM4zwVfa5WPLfWH00H9xgGLCV9WvQPWo3DDCxc4+XEU8iTkiB9TGoRTekm23fXUU+2UU1XIrKiF6IB8B0nwnSqyU8NnlPxUYF3qvu3U38q91IGBUTwE+J16ce4z/ia1m2sLBJy0EkMew19EQM/NobTpCE5KdtWctX57YhtChgGM08UNx9bqBkrZ1fQ/ChkHkTnS7ut29e9fbZkDSkGZ+jnLk3ghzipkPzTAkrs2roQVFdBgUBgG5dHEi7IualfRUIWMUBtBmEcPqhWGExQtOG9h5gioeKob7e7qdFuf1dLcqvPzO0BF75P44fN+XHV5Rkk1y3rYduOq7FjvkIPfOCZLDkTQVHl6bbHIiFb99UTJqQmAf4iMyFlFvFxJ4I6U+VztoQ4awq7kxidn+KTsmC+SVaEba5dTUPQ3rofGLuls3xs05+2KfdRFq0oMMNonXfjLoNQkad1eM0Mi6zekU2DGhJ/jiSG5RzzsKw2vVfuil1EuYkhFxZGyTp5AO5RSHNxpJGvI8CuIkc8JPTJYKKBfAfTVXostm8O2yt0yDt42jfvFFu8MJAYd6ooHOVYq2k9KuAyItMKtS2T6lP2XVmtEj0xuSEojDUUHKmjJTrDflOiDi65A3T+hc++uB0DEemC+VUOsw289Ehq4ESXO0jXVNNdwWx7t5rnJUKQuyJV4FywTW51Fg2ex+Sw53TUtjirYEgCC4IzNFQiZneCBU7GjRf0+YBFTVqlpC9wVdeB1zDFNjpjDvt3DJRx4QwN7c+499FP/Fv9+Y6ZUdJgjqnGa9+P0xS7d16BU7lGzW7ggn+Bm+1TP5BhOkbv+dhg/NBna98jEPRX8pQc1qJwWu627U8z1NPWBaNShev50pRTyONNe1RWrNigTV
 aEpc7nHD
 1oRFubJHXhxNQYztkEjfu7OWax5Jhy0cHbiXRJSwOPSiVxM53UtnOjLiiq3zAkTYT20llAEqz+sPDsbMcCmK5i2L6wokeJUcOP68tWErJHgPdkdSVx+lkKqwED99/sg+wTe48oVXTr/xdWtGOHtKTYOCaewKEZ7fXUAaSclw9S51/ikN7eI69FiEyI/h4WEuTM4+GZodHpzdqjeXOLC2kbg48EHBRl7AZMjr60Ro2+mAAypVKjQ8DEUFLFdWdiA4VAU0lBkK7CVVAsEhrmb5Iy68erD7cZmdE+rXtvm+xy0J+s0ABKPbzmbhQBkO3WQUYn39w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:35:21AM +0530, Kundan Kumar wrote:
> On 10/22/2025 10:09 AM, Christoph Hellwig wrote:
> > On Tue, Oct 21, 2025 at 09:46:30AM +1100, Dave Chinner wrote:
> >> Not necessarily. The allocator can (and will) select different AGs
> >> for an inode as the file grows and the AGs run low on space. Once
> >> they select a different AG for an inode, they don't tend to return
> >> to the original AG because allocation targets are based on
> >> contiguous allocation w.r.t. existing adjacent extents, not the AG
> >> the inode is located in.
> > 
> > Also, as pointed out in the last discussion of this for the RT
> > subvolume there is zero relation between the AG the inode is in
> > and the data placement.
> > 
> > 
> I evaluated the effect of parallel writeback on realtime inodes and
> observed no improvement in IOPS. We can limit writes for realtime
> inodes to utilize a single default (0) writeback context. Do you
> see it differently?

Was that with or without rtgroups?  metadir/rtgroups aren't enabled by
default yet so you'd have to select that manually with mkfs.xfs -m
metadir=1.

(and you might still not see much change because of what hch said)

--D

