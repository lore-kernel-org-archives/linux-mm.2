Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74337CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 07:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50AE6B0005; Wed, 13 May 2026 03:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C007C6B0092; Wed, 13 May 2026 03:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B170E6B0093; Wed, 13 May 2026 03:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A18206B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:46:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1ED091C183B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:46:17 +0000 (UTC)
X-FDA: 84761613594.23.78F1B20
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5142F10000B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:46:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778658375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UZSXOXRAL8kPEhm1dPm7Xpr01V9VYoK5WvLmNfNR94o=;
	b=l5hF5wAmp5Y08s5N5blflsGwh4k78I2hDExczP3BewV7gJbe0jpoWZuLaadVofrdjpBVDA
	yLxyxa74T19OYDFmb/tTAGnn8y0ma3GuUAdJWNSb8hOx+ZcBHZrlus0due/wxFIGEbRSz3
	b+yblkEV4IpYMjxcalEV97aNBzHL2i0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778658375; a=rsa-sha256;
	cv=none;
	b=rltETrtG1DCg0ENjTgTRJUg83xyL4LILU7l/1/xqrI79/ebylR1z3yViKruh31XgwcVleo
	QAz4FY081oum/iT7zPBYJNoNe2MmYuXlhf35y52GnVWmxdsuIjBz25MXteGHogRNCx6VlT
	Dqi22sYRmGCLlf4q+UDmWAihuEuadHg=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E742668C4E; Wed, 13 May 2026 09:46:08 +0200 (CEST)
Date: Wed, 13 May 2026 09:46:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
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
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 09/12] swap: push down setting sis->bdev into
 ->swap_activate
Message-ID: <20260513074608.GA3693@lst.de>
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-10-hch@lst.de> <20260512170846.GJ9555@frogsfrogsfrogs> <20260513055806.GC1236@lst.de> <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acd6428b-a352-4f7b-a349-b2c9e341fd87@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: uykayotjcixog1dbdg8z6gexcko8wwti
X-Rspamd-Queue-Id: 5142F10000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778658375-422622
X-HE-Meta: U2FsdGVkX1939pdAGQgUhf4n1MgFsGwUb45dFPxeaQvoIL1gpvjEDQtTBX8Jap0v1UZ//FsxcTsByQ+pGEJezX1UN/36OUQA/GOcONXZvYFrT7OAS8z6gtBwXWfwGRNb71glolp0InwSRMjEgIpWOZDCimJ+KEqFu0P9g8jXqXcA3CWKiFdfjcfcnDBANulnGltpOwdyd1WtyOMXjmwndMbRkxB3aaUk2CrFNDjsiCRJL720TOdBHrlwG//tnFvI0X9qomMtaV+ZgzU7jCttnFMi1SMFM+g5txkAipZSdLdKGi0G/XIyrsVq1RES6K/g37toaCUJNpmaSFlIgI917bSVk3jK+PC/jHKZyoHy54bVeIQ7ifs6ht5vB0WooJOgsN3VG8mHuMqkQO0Zr/7+4ATAabxJK4WarOItxHBnGm64SOTjwJeRNG3vq+FKurKWKVvA6D1zZvCRjTck94IWJaJ98CX01nxo3HebZLwsEU3GGr52Ze66pHDflsx6nUmd+WbIqCjqkqFcUN3DMel9aOdUrVEVRkcdeP8c0vQ17KN46EdxtK7/2DdNxX5M+iUfkxayMoClFeBRd6iGSayxZ+sGP6RwO9+Ea1FSBJI2OABSNR9ak8eHylSZfxFYZ3y1xaElk8xFMuBsoYcbBA8lq5rGZniWpIrMjPWOqHPiWmoOYzmrOofGG3mCDQ4hQcrIIcOGCrzigUA6veYshW0Dtl5vjwr/havfDwQmAdmt11fz3ZIJONE5KqCD+q9ZSvMs4S1/TZJB3rpza/z2SbFgxEVUXCov9sdWxgMnazKw259FoETfMYyc3h98YjESyNky4OWD4ETx1kvafLUQoyurZWln/gi0HdyJoj9zriH17UdLvVlMv7oQ4/QxXaNDmLG5aT7dgqKnv/fquoGJ5Uw+cqbGJXTd2k0MbgUrv7o0wlAdOlIHvSdEDJ+5VerWFBGycRg34h8KosQUB1USzAy
 7T2fK9D7
 3u+pVWPxAN7H0mmKUYHp54JPNVBXzHxIBK5KIPI6Cp/dPYItUbCEs3GUvRy0WjYFko04uFhucn3RpKOgVUjDuBxfAfljZrf43yNvjNRXFOabL8X6NAQrSfAsoFXdVWWmWuvJJo0SVd5h9J2eadSyYHIMhyeysH+/m1/XTRJFzn2IMHkgqxoJxHDcpwQM7GKWeYK15sGkyb9nerQQon6QpEeTq0vmXpUpiCoBmpDh2D7wxJsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 04:44:53PM +0900, Damien Le Moal wrote:
> Hmmm... With zonefs, swap files can be created on top of conventional zone
> files. So enforcing "no swap on zoned device" here would break that.

We can check that none of the extents fall onto sequential zones instead
of just devices.

I still wonder why you bother with swap to zonefs at all, though.


