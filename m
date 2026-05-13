Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAEACD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100866B008A; Wed, 13 May 2026 01:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0F76B008C; Wed, 13 May 2026 01:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1536B0093; Wed, 13 May 2026 01:58:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D90FB6B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:58:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 953E38E0C3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:58:11 +0000 (UTC)
X-FDA: 84761341182.19.96F99CA
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf17.hostedemail.com (Postfix) with ESMTP id DB91E40006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:58:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778651890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Jiz10ZDYj4IBN0PjLt8n74QKlzPqxshMpcaZgQjE+0=;
	b=OQ5EqeuEKl+sd03VjHkV5xL4QLxlAs68qzsnuJ3mgrXePxJyTzGXvm2PtxpQbAIKUZNORk
	taPHYfZTUBaqSSxfYPHb8adCe153t/h+lWwit2xVNfYXxGB16N1HkD808lusI5MEiH4kAc
	xNm+HuvRoiOGnKftmY45ueP8tXApJi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778651890; a=rsa-sha256;
	cv=none;
	b=O2nhC/QCOyPjqXGH0mtUVDuqOi4bYPpRYvPI4Hb9skyHO3wYYkgq+1q99kjH81HNtjC9qc
	toLubO0f2581EpCUg/gTqZH16cARVMwSRAtDqd/QOaJVS5dpSiys/7QEyW+P3RkfersFoq
	9p9ulxSW3xi0XgrWdHTDDbcenXdJFZY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54A9368BEB; Wed, 13 May 2026 07:58:06 +0200 (CEST)
Date: Wed, 13 May 2026 07:58:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
Message-ID: <20260513055806.GC1236@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-10-hch@lst.de> <20260512170846.GJ9555@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260512170846.GJ9555@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: DB91E40006
X-Rspamd-Server: rspam04
X-Stat-Signature: ykah7osu7qdnnj9urhsbpnp3kttgo83d
X-HE-Tag: 1778651889-953276
X-HE-Meta: U2FsdGVkX1+dRKdN9da7vbTW/ni/ae60zaTCZ4O3dZJDsfkJ12IYlTZ5G9ERRNl09kUk7MNwgBWlOYmbakVPvW8e24P0W0fTKDt1GZ+3MBvYBofY1ZWj1yoEXRalNTxDEaixKyXWtjH7eSANiX5OhLjnZXqRKeKiCUylrZgCzC866FgKR94oXQpm7XnnTjsLoTZPKV3Gyp62OMueG/mBSh5go51wQ7wbn5VoFYIqYztKW+wtTXkqyC2QOx6OjYFGNcfavS/dMaeLuYKDAZ9pG4YaJWpKyHwY0HTypSWIUSfvK6SrhGbG/Q0dOs4ACnvBlVa+QQPmC5SI7EHFg5mjjOG8dzFhiy2FGPFnN8WRL4kjkkR0pDYkwMTMUjTnszVnxeWshrWOBt+6zl39K4B25CPngzCLJfSzYXUKC3A1d1+BsUH+/bZ1iuKfTxz82uV5cXMHVobUWGC/6aD9n5r18PAzx8s9MJ+lDEs9bkvAB8XMnUbo2Nq4UK36jK+kE1zE/cyNTEV2lYjBuitymoGN3SgJ76ON2E4A/xlN1npVV88dXhzHXQ82jm8EZ4EdVJnUCdYlkgGMtwgCovBfSB+9WHiLTThHSmH+YKS0FSqLSklVpf9NlBvoH8W/fyeDrczn9rmm/HEysz1yoT7O8Fyq10Wi8/mjnNPiUvI3J6BRa0H0r9Vw6z6L9w5SY4Cm1yUzqgY1r7Q8JMJMU8vJFus24ySY4sYdpNGpODwm/cZffpVknXLiVP/evW3rgpyzxDC1n0SHOeon1slhG+wb1aKGG6tr6WuWqv6DNne2CAIv/wnNXcKyIjCor+KXSLYv8ICzsaOHUmQwb1ByTaFCKDPoxazkxxF7RYMR9qxOkJxtdxTnf62qPTST3ADZTf6Bl6PMfw80LP5YclyzFHRAor/V8/6QPSO7V7vbmGtNYavqfCPJEn6Z8Jhcbd2uSGwF9FCIcvAwY+oJJ9fCe6hBF85
 ekES7k+d
 WMeyf1aLlFetbTmd3irCf8MvLs4rj3k1AGYs6hfuYzc2uJDNtNCnBS6kgJJjXpGi65yWA4e8Nd4c7d/IdATnL5AkCtHj1B1TAkX/Bl3t9uAZYkqPuA/Fq5ecbbng4OneMKmbYtgtUJYWjbvOWJBdKHA50MizLSGLSCIs6KF2vdVnA8dGGlvc9KVGmhkT49VSxCR+NPrHPdZiP9vgKEd8pKdDoiBJWqATFc/nqTtjMr1ynYbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 10:08:46AM -0700, Darrick J. Wong wrote:
> > +	/* Only one bdev per swap file for now. */
> > +	if (!sis->bdev)
> > +		sis->bdev = bdev;
> > +	else if (bdev != sis->bdev)
> > +		return -EINVAL;
> 
> Should this return error if the bdev is zoned?  AFAICT XFS and zonefs
> already guard against this, but other fses might be more naïve.

Yes, now that the bdev is passed down to add_swap_extent we could
consolidate the check here.


