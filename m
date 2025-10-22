Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CFC9CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 05:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80AB08E0009; Wed, 22 Oct 2025 01:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2B08E0002; Wed, 22 Oct 2025 01:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F908E0009; Wed, 22 Oct 2025 01:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEE98E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:34:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC2855B1CE
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:34:41 +0000 (UTC)
X-FDA: 84024635562.14.75F9E49
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27E7DA0008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:34:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761111280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exc0vXxxryLCp7bACvAzEjAp+33QUmtzL0ZfKM/6Tpk=;
	b=yS6nIhcygpzi56Rn/UZzLooqRslBCBhSqEFTqUGMgrTZAGVF5hIi2dKOwk6Doe/y2HMVEY
	qP9LYhn79ILeR7pUFm9rPiqErgMF+Y2sm6fI1NO4cKl4S+46ymFrwfBfbQfc2kBXWzeRwH
	xsLYd44CW0BdlBHn8tolUWbJvA5m96k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761111280; a=rsa-sha256;
	cv=none;
	b=6Aqtlw1SrtztZ9dhN8Sx1xjrHDc2RGoe1G+cPm+B9OC9lB5VA2e8R6fM9W21S3bVArn2/4
	nhH/i/lyoIUyQMs7SdfMpoq9laLTb20BlU0OZegwQxEMWFfiv5ceZKlSNUAwbEgR066itI
	lIQ9FyDJOPxuQ1IkryafY15zmfK1wAU=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0582A227A88; Wed, 22 Oct 2025 07:34:35 +0200 (CEST)
Date: Wed, 22 Oct 2025 07:34:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: allow file systems to increase the minimum writeback chunk
 size v2
Message-ID: <20251022053434.GA3729@lst.de>
References: <20251017034611.651385-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017034611.651385-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: eaw8dpukiisy9ntcbcbbcusbfnd3kxzb
X-Rspamd-Queue-Id: 27E7DA0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761111279-555724
X-HE-Meta: U2FsdGVkX1+d3Kp7kFyQOmIfNXLaBkqNey6bRVlH5jLxYEVjZnKb3q7AM0U7+eFgQ5gDDvcQi14ZRosTevZvHfl8fD6LYd7pQSIeCzuxrqY5Rd1rV9OomJh4yhNUqZD3mCT8Xs38DMt8+vOIxwL6PFEJQqrTNIPb0y5Z4LscAMVuWq6jTHvs26PSSbye/ptncKBeWvFXH2mWnHhYHQy8LPU1TqymF3LDJcU1d2M92sLNZh4Ea9trUEmJbSgN1MXxrC+sveiQ8fqSgg+CiK/zDClY/X96BEZ4c8QtVHDUB9RRkeeDsBoYAfsyAQOwSqy+LgNUGlm1F1JsqzZy7AXtrStxJssGkVkAPt4R04nODKcW3kACivPrVCe1zZuHiI+jjv71zqSDLahN3BC6qYNnLzqlgafeZtjviDA2wUWVI0IVKLwV9CG09cZF2O7XyAB26KQM0qYasnBp7R6GHon22hYXoYYHFPlyDlc7/bcKXXyFMxju6RB9UHff8IaOdqyjivS3vCvz1Q9Ak/EjgbnXRU6D82mPsqHNxHRBEW7gMkJ9m4y1Ji0uRJ+QnqM8qYIQemy8Nn0WJdHuB9+MX18DioY0IDySW+wD7q6HkgDbdDHS46bYKkSXsFcZeeENRPRPiGZ/jUz8ObeV9gUIzwlfeULUK4EI3Af8+ZdAFB0UCqnKkj/01uh8W+ENxYho01g3P4xELzXQ7e2fuE3XgCevMp04w41Mhl1UXcMtIdYvfMdGHVwsGh0q5vgHh9nD6lOo+Hh9DAE2sKZSeYIMeualLB4cq9SlRIu4WJ61fjkEDPYkn1XBiZd0jXlOw7nf5Z+Jv79iQmzKJHFjvrZVlhRUH1nUr7JXNGWG7ffp9PQ9n5vcVzLMLTKSm1CvxeLtzJG2axVD6TnNVVbWK9BE4mGdbuGdR9m8V19s3rViDzLgmBpBSrOzVyTD+5ISaFnPhrmh7q81wrIrwij8YVVEFKV
 A1r/8PP0
 CwdWKjWW093s+GKZnWl0tpSEgOA8uXe/9HZYgr7zHD1yhfMl9CoXDM4FdkhhUHfYXEt3NPj3EhevkjtB6rxUoATRNMAxe5zj4DfVp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks like everything is reviewed now, can we get this queued up
as it fixes nasty fragmentation for zoned XFS?

It seems like the most recent writeback updates went through the VFS
tree, although -mm has been quite common as well.

On Fri, Oct 17, 2025 at 05:45:46AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 							         
> Add a superblock field that allows the file system to override the
> default size, and set it to the zone size for zoned XFS.
> 
> Changes since v1:
>  - covert the field to a long to match other related writeback code
>  - cap the zone XFS writeback size to the maximum extent size
>  - write an extensive comment about the tradeoffs of setting the value
>  - fix a commit message typo
> 
> Diffstat:
>  fs/fs-writeback.c         |   26 +++++++++-----------------
>  fs/super.c                |    1 +
>  fs/xfs/xfs_zone_alloc.c   |   28 ++++++++++++++++++++++++++--
>  include/linux/fs.h        |    1 +
>  include/linux/writeback.h |    5 +++++
>  5 files changed, 42 insertions(+), 19 deletions(-)
---end quoted text---

