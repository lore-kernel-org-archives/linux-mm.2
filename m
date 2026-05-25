Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 161C2CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7312A6B0098; Mon, 25 May 2026 01:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708F96B0099; Mon, 25 May 2026 01:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61ED26B009B; Mon, 25 May 2026 01:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 514036B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:34:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 001EB1615C6
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:34:57 +0000 (UTC)
X-FDA: 84804828234.15.13A55E3
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 72F67180005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:34:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PoRi9mLv;
	spf=none (imf24.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779687296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SjOlFOCBBZ2U5TlW9/X+d8/c+UE/9CSqg4DdbFuTHrA=;
	b=f5Hqql6WQ4L2d7gOZaCxWPADEcV3wOt3G/UiYqTd+DPtMz4kN2d6gtev7C0tcrzTRqQWPE
	smmfkuPOgC9lEMDiP+sXJmirvPQbhQtag4eR+iHytN+9kfedb7gOEjhGvbLBfLDPbixpiP
	Z4n6ZEBjhpYBV1qQX0ObC0vXCV/0j2k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PoRi9mLv;
	spf=none (imf24.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779687296; a=rsa-sha256;
	cv=none;
	b=H6wePChlcvcfxtKIoJm9lVcCnVpGgs45QOiXLqo656OeaB4yL28TSncFFIw5nrpIt3PtmY
	oB+QB8Jxq7O24tgHxQQTbNF8fw1ouWf5xCmNDNXmACPwqi9Q9nkhjNare+zYHcwcGbC0mg
	GYg1rUDtG/auU85L6JQEWPerPxxn74Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SjOlFOCBBZ2U5TlW9/X+d8/c+UE/9CSqg4DdbFuTHrA=; b=PoRi9mLv+pykgcHYmVN+LtRYwG
	o84cO0GmTfh7sTw5dKv4OPvIhTi4W1vIUduN4gLw3pMAOJl+0eBfGzQOdC8FL55Bc297/BjTtk8Ud
	LI6mJV81v6Rjcnf6Zn0gIuovjWt/YscFFyxZRC1x8zzsXTzUN/VEHmfPFaV3YlKVzL2+hi99YOOQm
	CvD8I9B83nWnR/LHHeuCkU5k4qu8bq0/EbcDn8wddjuk6dxsIDDegfy+OIUOZ1gxosuGGFfXGBDKW
	HHj1G/KwbB3CTTeke2TqJG3zO7g5P3tGR9zSruJKvZTKBnmlzYu4LtTtGsnvzdgOhgU91M7/R92hi
	VyvvcuaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNxm-0000000GKdP-08i4;
	Mon, 25 May 2026 05:34:54 +0000
Date: Sun, 24 May 2026 22:34:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahPffhaOi2CBtWof@infradead.org>
References: <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag9D6_7dttbDGHZ6@casper.infradead.org>
 <ag_UsW_OrlXD9dWX@google.com>
 <ahBSXyOi9b1jxNkX@casper.infradead.org>
 <ahBii6bk0KbK_NHV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahBii6bk0KbK_NHV@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72F67180005
X-Stat-Signature: pqbdn4x7rc8zo9rpodcg3kb7w6uhdzee
X-HE-Tag: 1779687296-844135
X-HE-Meta: U2FsdGVkX1/uIWMoZpjqJo4F7rG/XJgaNMGAxSoQabSIIkYg9mFRriyiAySuaamfhQ7X1KmF+Pg+qt3SCiHxQU7r0RTNJxV1gl9cMA2+n6Yh+Pqs/Lc1FAJPHpEcp/qgYoUczGVg+dfWuPUp6y8jQlW9TjvNguexBWFYf6q+JOqj3AKkarpwpknU/oV0QhEkRYispxpAcuqAJ/A2cRCBBhLz1Rgui0Tsla0CPIbUEthCptSyz7CF9q9W2dNPTtzdQZPAWpbBjQ/rGVU5z5b0SNofdvG4G2iJ9a27qjmJpmuizoT+piIRGrq4H1hfG50XVCPjREHruMHIF63VOEUfgYOfBo/ADKnzvHdUzYmlcsXXGdzwhPQXHqw1Hvmz0HDTAdhnnEKNnP9wnBcTMtZW+mNcMont9eTrPpeP9cqNIDl1aGp9mBpVJDQbG763XqAxlFp6LOyvQaGvnb+CSHcP4Kzob0/+F51s/IwB8R9LHPhEJ2erNOcrnMmorhAUFnhsPPCMbIylCYFsUIZy1opdQ+517mOh/TZYYdlCG1UX3OEjt1KAEUjlIrzuNbAiWTca8mpV+Z2yqQ+llhTH6MyOxFARiAtd3oAp+w8/BXqIU6VP5DgK4pbozrVNijwNM1H2tZw2t0qnNczUatFALBZEbIkERHKGqFv1rgyhd1kyW0o85EfD6vWMzZWX0U/6WwjRw8sSRebuyaCaT2TvmvkjSU2UJ5+IGbIbqDsM36NiaibLOXmUlba76qUu71xCOxMdDwF9R67LvLqjaqyWtvFeP9qfMz+Kz1waxQOXqMgBOF4jRS+IdvGlCR4+5aWwZ+OJC0On3j/itE6gB8z7ID1J0lFafsCrqz7r/g2hvfQiafgiAx713ec01nTF9ayzeGRsKQX4r+8E5sJ/6m/eHVUwJVsh47HYC48yVvGDF7p7+iaZHbh1LPM179cCAC1eAG1EEtm5GAf/9ni18nc3bRE
 rxOBtq6G
 +w/nkUzzFhT6kD31xZLAVsOK68NYVEYRRks3E43NGyy6Z2YVOAp3F/YNuGVjOewsOrzhC8Mi7ZFDQwBx3JdXdVE7YciUFW0DSyJ8Uio9K0gqrouIRMoEz/671xubboNvXPWr5Y1ZwALklaa8+/1fob4JxLRHkPkmFXemMN5QR/Ni0km/tnJtwxqs5ITU8EmLHqD5s68lVXBPVj7if5nSoJE55cmpe4eIEv8UFDmmUyyZSpsFCXuNbkxKbc2kwQPfilpdpMx8TC0bF1kO34fc5YiMN9Tkw3l9Jjsngzucri9WdQ4s922PDAwkmgltAxvHJ7JfePVnlqLh9MW2ara657koZlDhI52xPkErTqT8QG0F6Baq6IpWo55ygMXtR6oiR11XvCsLYeMENdvXAHm0G/qh7lVpOcH3tFTs9+hQIZfafEO13l/vk13Vhk7mFLWCAhCQd7db9T69BtJamZxjIuLOv62b/4NJVVsPBVJx50kuN/q6OOkBgBBTpdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:04:59PM +0000, Jaegeuk Kim wrote:
> This was a quick buddyinfo right after booting the device.
> 
> Before:
> Node 0, zone   Normal  22684  42284  28704  16901   9515   4566   1854    673    181     36    758
> 
> After disabling EROFS large folio:
> Node 0, zone   Normal   8486   4732   2175   1161    697    272     82     19      3      1    856

And what are you trying to say us with that?


