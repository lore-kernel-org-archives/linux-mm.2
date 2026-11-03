Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAC6606A330
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E346B05B1; Tue,  3 Nov 2026 04:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05466B05B4; Tue,  3 Nov 2026 04:03:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C417F6B05B8; Tue,  3 Nov 2026 04:03:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0FA96B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:03:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3174CA7DB7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:03:30 +0000 (UTC)
X-FDA: 85393219380.16.147524D
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf05.hostedemail.com (Postfix) with ESMTP id 76142100008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:03:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793696608;
	b=PRsoUiGCo378f6CLg5nSCuywl61sfGw7jKpa4V//JN33KzLpNM7GS8s+QwLfqMiDW1WVzg
	e07Ge1PmSEnzTDVoRIiaxG3Ijy/DBMjj+lhK3b0yG9bkW4r5PeqkMHSZ9h4hmpM9G1jnQA
	VOg6ROEqEQ24yMUff4KRmzlzTvJ97QQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793696608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GHGz850caSwjJKS3oE56h9NFkxUphg5/vIJAawh3jok=;
	b=M9yta2Xn34W8bhWP91KplYC5hdVLAemcQIHhuBTOlet6BXP5ZTFYNgPDoiiahhZSwgMRc+
	j6QT5MGaR4MzENPiLllQ8QgoPUyzfRhuQQUBxOyAwVfe9gmIKMiOElHdidreimxhWE4pxT
	E+0GzqjJCScYKTeORbMi6QFIzrJBRhE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5881F68B05; Tue,  3 Nov 2026 10:03:23 +0100 (CET)
Date: Tue, 3 Nov 2026 10:03:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a
 shutdown
Message-ID: <20261103090323.GA5314@lst.de>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org> <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org> <20261103054155.GB1559@lst.de> <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: ngtpd9x36insxfepmh48mmy5q7dhzdet
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 76142100008
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793696608-897062
X-HE-Meta: U2FsdGVkX1+GI4XIB4P60iQDu7jg+sfDtXgEeogDBK7na6goGwUvN8DuKUiQxJanzUGc4eFInJYZc4DFLgKVtRHdhhvVHCByDQRYk3YQeOGk8+r8jp68nmlJ3JaaeLm6jsZXRMyVmbcwIWLThCQJVbz4IlNgJC1chL+MoYVNrDSvEv5QcGr6+bsSkv2IwgY+VdWxph+O/nduVuZA2MHVWgxhsVBD7PzWwuagq1VfwhESQb4Gw3KP6A/zV9vmKEnCjGDvtNeKHz62wC+rNNA7QKMf03R0spuHYR5Uf7FXzucongg6K2d88mW7L1tF3lVffBFo0pZMc8PVtDeSPt13Ef6kl1fIIJ5UwAN52r7EC28brzcKbhOL7a4pZhQZhCTXNHwbHr/LH67uzaohk085JduuQ24bROwuiFayTC05mdpYMrLdqP8Q4K5pRN2xhO07OeVJWXcZqjkaB/pNOkVnhefw4FHlcuRpe6/Qxl2YG+U1WFbhZC0Wc45ELAIM/9PSw8Lon75BQrOOjaDvIloyJSGCnaXPYrz8HWpNZ2QkquHFmlGQD9Th6xX4EOBaMvk3axC8WEjk1tVpBj/60YlkjHs+PmVdbAkPRepqRE7t65oFOuQSJBw/Xsw//4IRLD8Um9ehapzfN+TWSzRJbnq4SMh7J6tadp6hM0URwul2yE9ihoJO7abWkR2hIo/NGxFOGYioFVfGNNsPcfI3jZ4S9RVHS2wwad38N6KNfEioVZcONwWLIMYlLuXoZQOeFA49g+YwHSGiqCdf8eirQ7RtWEfdHOAyqImKTSOaHMV70sK+JThfv0qiys8MX+jTXDtVjGYX1kNMAiz4RDGnD/UCwvIUHArLvP9yU6PKHLlzKw0Gv1w7cUvmpW8v3Ev2dUF5TvN2kqqlCFC5/2e2KWdX8t4gBsdAkIUDSu/r8/csTqcfwsquuj1Lt3wnzzuSymhW902hufUrOa0ZDqjXYQL
 NBU0bZNj
 s7bflgbK2uEQ/eOmkoStZ1N3r5TzjxnipThUwCMVGp5fotK8iXkmyZF71eWz7KlAQtoX7qq0+iXp10VfR2HxpIoge4i7MIOarJF+faeGxdNeCx18qMKGmke62bavb7IpLZ+8eOUL8sKv/m24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 09:41:58AM +0100, Christian Brauner wrote:
> On Tue, Nov 03, 2026 at 06:41:55AM +0100, Christoph Hellwig wrote:
> > Btw, if my previous reply wasn't clear:  please add the test for this
> > to xfstests where they actually get run regularly and not the kernel
> > selftests which for file systems are basically unused.
> > 
> > Bonus points for having generic tests instead of purely file system
> > specific ones.
> 
> I can drop the tests from this series but xfstests for this will be a
> follow-up.

I'd much prefer to have one canonical place for the tests over having
them in two places.

