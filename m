Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E252CCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423998E0007; Wed, 15 Oct 2025 02:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAF38E0003; Wed, 15 Oct 2025 02:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337B28E0007; Wed, 15 Oct 2025 02:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5AA8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:27:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDF0A1A0B1E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:37 +0000 (UTC)
X-FDA: 83999367354.06.456E5C1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id A5FBD20009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:27:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qcD8JhUe;
	spf=none (imf13.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bf9tiNbfU41flJV3errjkwpyui3XNhOh03t9EHC+1tw=;
	b=DsvghpNGQvL7vas/SpWRTO8v/iUxptdIEinp1J8CGX+s57ov2H/YpmUfbGetdAEGlT8v0A
	o5uKZokszzYBVjkdZPxBMKHV1Mw4qSZlFyhamIVKAZgv0fiqy3OXeLy/ZcXoFZNwCr9JE9
	WoID1sL4Hx7stmks4cbicO7OxXfL8ZI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qcD8JhUe;
	spf=none (imf13.hostedemail.com: domain of BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bc6a97f86abb080b148e+8088+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509656; a=rsa-sha256;
	cv=none;
	b=PRqifer6uSPF4YzjUkxoxMDtN8HmRDzXdlu2bZ3x7ezzyYD9nxYpzczwB3i1869XOUH6bD
	QHXWgKg6GsEiw2SVtnGnuFYWF0GbtpRfMukL5pg5M0a8Tt8F9C3oxd0Y4h4JS9iSA3WSfo
	oFtpfv4y+E9nWrK7PCQ46VToiDvnjUE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Bf9tiNbfU41flJV3errjkwpyui3XNhOh03t9EHC+1tw=; b=qcD8JhUebCykZtn7+GYefOSj1l
	Fk5fCmxpfp8tCPOpE2BefBuilykQh94zlJ1sy93Gb6kddayF9ygtJndyvHDWERMhBTsozes4sMdoE
	/aGoYwSg+o7RxDZSfgmT1qYH/Q/h90eOmiZMtgQ25K494BkEukE8JxeiGY2z+khvvGOSUXTHbgSve
	5fAYNj6FrAwTHfnb4ORv7OSp/B1kqOKs+FObozjVhpa3ZMFZUb7es4pfVK9fH+62CBAgIJY1ZOKPD
	N7wz5N/92jglQPEbN72PQ5Eb4E0q0dImWNw8+N4M/lxtsFdhyWzKOxL4ZAUDhWD+ni6jlwiFljFfW
	G7p2sp2g==;
Received: from [38.87.93.141] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8uyy-00000000bCg-26Jk;
	Wed, 15 Oct 2025 06:27:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	willy@infradead.org,
	dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: allow file systems to increase the minimum writeback chunk size
Date: Wed, 15 Oct 2025 15:27:13 +0900
Message-ID: <20251015062728.60104-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5FBD20009
X-Stat-Signature: gtfiyws4k35ridrpo3u68umpoyefzyda
X-Rspam-User: 
X-HE-Tag: 1760509655-241123
X-HE-Meta: U2FsdGVkX1/fSYrPHvWZDJ+mvGckOOnsr9JifAxWZP1m6GfHn9EsUcVvmzebV3oawHy9amSSwYTrklPhZK+KKASFAWRwAkZpiRQtpMJlfRAER+ECiMh0Z7+Mn2ejKLpm7ce22UKgY5Cs3CNgNsarZI4IMX7Z7ykaj1wIyQrdgdsiuwvHlz8ODlXicZUOk+WW5MHamhoTxUGy6kbBFituPDVdoS5QbXkkiwZkC/wypK5zBgY2UF4hMJ3AvghScTvpsPiDdO+3Qo45X8L+Tost0SclX5ypCd9v3uyJ8dpK44KUJlgirhZCUm2XJ5A8N+1Av5XqCNSXNvv0LWyKi2dTMceDlIfF8tk6xanPOPfy4jcWgZ5yWdsbH6fe/q4MzL4YrQWBVnTAVVE3JNYB12mxsCmSxbe1RJNoVJntQrA0cV8e6LeltbFHl5AdKfjo3Wm8g8z1T9rGnwpTkXyCaeI6RYmXzLkxZFV2ePorupJ/+6RImw9lBqA4Or95UVh0xNhCcM3OkRVYGPYQeELEVXQoM0afgijJOL+h47XTg5bDS0QfBtAko9hN0CkSEi4kSjKWuZVcCPBWI253xEbxkiKOLO9xE8LCwbYElKeL3bcYcYkzXg5wyX4DWHccpjHefC5ziwgyM9D2NyxvSs+1bsL0KcnNEsAVMYOsyWGpWuyE0YvwxnjnOFdbSxdtgwsuwZR/3J6DdZOcapTelxsw16u+m+oVAkfk8d5UPUA3kVIcm2cePJy6K9kouxy3NJ+R9NDCAsW+hwRXcQrYpBF6+IqNRSwTu0Fw7PhLruM0HoPWB1JKo23p/yphZWwj5Mg3ACqvxVNcLGH8aBJjhRLYeJpLQNIJEfWr2JDXNSz0dArBgCQsHQgmZXL07DyHMt+dcM3Ex3sA+OWumLCHP5Pmai+BEFg08YhqzA80Tf+Vlc9lktx5sT8yFgdMMp9Ddnhpv9ekz+NzAqOeJSkk2dfi1wr
 s1X0w6wE
 s9ULagbTmQTimTkka+UXTwnwfx1a5Nsulxinsftfo1BpjT5IzSqkb4jnG/YNvFR1QzdWqKiDJt2NgB0uxLXSkHBW9lzEz68+dz4bsqAuh4r3LwkRkozMgUB9ZW9EeF9pWxzUEU2d/J91AYCoOCDDhLpy+IR/Vi47OOs/ptgNbSFi0U8FaaeIHnzi/abue6wSEQP5B5W5No4fqZg3fgJz6sJNQHuBVZt6S87xoKuJjVvUL759auEp2ZxbRS0PcQhk4H8x86Kueww0JqTIGZEpcqC6vW+9vNc7O6XDJWK67aX2Whj9r+gX9khadgvc238r345zfcCZnMYsNq1Imxm2VF5wtkbfb4muRbnnSCGQAHTEIPjrGofx5VPPr2uuEy+Jovr3hwnwiQ5HZfHa36fCDVBpGBFMe6ZMuNNIQCKQ05lBmVqLdDIVyEXG2pf7Zpq41ALbkqpFlgh99s1nhhWn5lcbMBFkgS05uevCfukMfg3VZ+blfh7WqclaNIgNgSc5V19BKgxDCy0QT7GDIhkwT3veJ4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

The relatively low minimal writeback size of 4MiB leads means that
written back inodes on rotational media are switched a lot.  Besides
introducing additional seeks, this also can lead to extreme file
fragmentation on zoned devices when a lot of files are cached relative
to the available writeback bandwidth.
							         
Add a superblock field that allows the file system to override the
default size, and set it to the zone size for zoned XFS.

Diffstat:
 b/fs/fs-writeback.c         |   14 +++++---------
 b/fs/super.c                |    1 +
 b/fs/xfs/xfs_zone_alloc.c   |    7 +++++--
 b/include/linux/fs.h        |    1 +
 b/include/linux/writeback.h |    5 +++++
 fs/fs-writeback.c           |   14 +++++---------
 6 files changed, 22 insertions(+), 20 deletions(-)

