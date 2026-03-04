Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C2EEF8FE2
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B406B0093; Wed,  4 Mar 2026 08:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE9676B008C; Wed,  4 Mar 2026 08:19:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1CC6B0093; Wed,  4 Mar 2026 08:19:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD7746B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:19:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BAF11405C4
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:19:25 +0000 (UTC)
X-FDA: 84508437090.27.8056054
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5719480012;
	Wed,  4 Mar 2026 13:19:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fXnxO9o7;
	spf=none (imf02.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772630363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMZH0WK1C4n56ljgVGIRCSTXXXU1JGue2xDQdEq2XRs=;
	b=qeh0acjokl+q3PWZhwwT0TlaIHlriBlKvNinNKbVY30SPcVergpBJOl9rUilBkNvj64j0F
	O5e+Ineisr7i0F2Yv0eKK0KSTjEGpM8WqOPjgsEY4gakgpjobfT+cwv21GCPS/re9ESNKi
	MCHrhRnXnzHx59cbrogZjSWzhOJOMAg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=fXnxO9o7;
	spf=none (imf02.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772630363; a=rsa-sha256;
	cv=none;
	b=kz7U74fd2JlOasL9f5w0K9lS6ppq92Cf3UKlzuN1+iFgEGvvQXnc8Ukl20ji/f/0QQG/md
	H5KoZEXoihzPc0j9WiFxPCzrEF0tFcaSiSnM+GS1zKAB3tvzTeVX0gDzoKYUIoMtd4wMzz
	KWll8lnPvEV0dYkUW0UIJcL5em8nTSE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TMZH0WK1C4n56ljgVGIRCSTXXXU1JGue2xDQdEq2XRs=; b=fXnxO9o7WLxug4TIjrZkzTMZ/7
	kWI6q60pGsZahi56N7QcRB3pg9gAxK6wALzpGHemg4FYrGsHq62k5MoFGDhZEi4xgD6Kx7xSPLtoM
	Glap+HyhSQ2J382UBlQA7YYTYGcDhYf3GiA7Y/uhRlIFNUpmgNmaq9l8Bl+aVyD/I2xf5PvPEgpaw
	ECRXXVFOwQd6rD7mAyXQAqbU117UDT2fcOTutKd8u/3TVim1cLSWLNKOt6LJ+5BB9OEfh+DyCUX0n
	I2PK3ww6WzbbfHyzzZeOjXAhHnKz/0aS6UebU2c0DVagKj5Bqrvh1cnBmZbkg3H2ekPUsC4dcFimK
	4tdwNMgQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxm8B-0000000HEtk-3ses;
	Wed, 04 Mar 2026 13:19:15 +0000
Date: Wed, 4 Mar 2026 05:19:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 18/32] fs: Provide operation for fetching
 mapping_metadata_bhs
Message-ID: <aagxU5f1AI3y0wrw@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-50-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-50-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 5719480012
X-Rspamd-Server: rspam07
X-Stat-Signature: sa3r9nprrr3dfxzqnbst63b5b8k11frc
X-Rspam-User: 
X-HE-Tag: 1772630362-757465
X-HE-Meta: U2FsdGVkX1/IP4CNGHIzu/pcI2p2k6/9PrIYsPV2UqeKc9NOQIccUxobRo52O6a3XaKzWZ+3R7EfjCOAURk1odMkz/H4YZONG5hMF+nNIDCgdhQfAUC99an4NjgjKKangcn2dHAt5gnDSHOh3RdaEf0GLhju17nk6nwaZlLVlIXwXq8ANuGR0XutgE+KLkEX1PHjDyY8FBcYMMOzmNzFG0xGzpRIs6P2G6kJOXl96CcwmkNRYym0oRta1XFaqRZbsP3Ooa0tEmpUTELJkxEzVP3rDF+7FqH2MzNRYB8zF8ESxFC58MrLmuHK7nTUbQ7J3jOlcK6Mi5b0j8ie6KUM04bzJ+R/7NDjUO7KSamssOYTf3DRiZ5YmKjvZmJxwdFRuI2CDm3l4qcN1gkk1wd2sdu6iEK5ENPipYmmF++MbMLq0uREhkJUrlvt7U/ELvS0ZhSdbVTecL205/9E5yX4JQwRuqhOrCB5FVSqWiQGvOzOc1jS8gvZ4Jz6tXYucR11phbeiW4TRUGHRQX96+AgcFA3Ssnl/6ibCjOBXUQx36lIrrjuklsOSVhSDGdNhMD70LmkXD9kA06WJWj7ZdvAGALo4DyDNZLr8wwoIhFLYyqiT2CenVQ4GfCq9HTIO4ICGNmyvbpFyQWZ4y+gquly49RfSYPJYBqUrSJPLbKVpXwi7MqPHSHmjevIjrYRm+ObBxepxMf/XUmBVVr1ZvjZke+soogteOUCRl+4DfEjBYQ+nVj2fTWh7JICbuGyiLhU5Vqczi7LiMA4QXni7WoTAaXChP4+VWZDW7OfT51B6NKPuhcp5f+e21LzxKRcUuU8KLCGZDqE35hy0Ou9aoBVTdqHIwV4BcSsc9k8TV2i2pE1+6/i08BNsj5R1SeLZE8Dx+N4KR1mca4SegCLrCe/b7rI/JQmkyNLBCTud/BlyUyhNvNQmzmxKec7Mr2Bxw/PQwhMZzMs+1yjbwm2ffX
 HIFrB8q1
 4xzxcHOpxIoOaIA30148DDMvFcadLQPklaCfwiQrNZVa1iLtsXrq713Uy36tmA3A8WxMscxaSj+9wdkUyxBo58EA4SG5Ss9W+O+nyDEb0BEc+R/V+2dZRoW+f7T1GfsLcFBeUhQFPELobON9EA9BLUfIKwpK1FrkdpH0IcdG14YswHx3y+0ZfwWWdN7vaXLQT20WTLHsyT6KdGycVl44fgOyHs9PuvV93KNaZZjWPjsZbUvty3Ph5kwjltcn6/mTg5TrtUJW+ADzgKS0yoi5507jvny8L9ewpPdbBThXRhWSq1IvwRVeodSY4XbkQmnZYKIw2bPJv0FfGkZ3AG2jAHzyExcPlN4nUMzIr7BAdNymkOi2yLSKC36GrbX8o/Xs0ishP4TjkA7gl+mCWiK0DV+5SNL9TuSvAuCoeLKCqC+phwMyeIWk+hWMTVzIk/kX7+38YPAO5ObzR2AsUS+xwfHA6iVT6dF0ifwceL4BaW+YpKH4MkNRmNoHUirhV5GR6vQ3qWfA8ZS0dn4mSObCRTCa16/HWKJVpHt+8QUFWIFkwNy3vle9q0KwWTUbdWDLSiYhzFKP2YfFKsFAqA5IfnSLCyOCOG23o59eEn6C4QZFLL3zDVyfE74YNww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:07AM +0100, Jan Kara wrote:
> When we move mapping_metadata_bhs to fs-private part of an inode the
> generic code will need a way to get to this struct from general struct
> inode. Add inode operation for this similarly to operation for grabbing
> offset_ctx.

Do we even need this?  With your previous cleanups almost all of the
places that need the buffers list are called more or less directly
from the file systems.  Can we take it all the way and just pass the
mapping_metadata_bhs to those functions?


