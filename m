Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD09CCCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426F28E0055; Wed, 15 Oct 2025 12:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDEC8E0005; Wed, 15 Oct 2025 12:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3142C8E0055; Wed, 15 Oct 2025 12:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6A98E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:02:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BFE18160233
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:02:01 +0000 (UTC)
X-FDA: 84000814842.12.B15EC39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0456A100011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:01:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLwXVID7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760544120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4Kk+cUxfYkVZ/UjAkODvwc0aEFN6RQEGhYQTTJ0YTc=;
	b=YgejlngBp66jx59NHeAiRnpObFX6ytPF+DrkR3FlK/wEgA6ug3wnoddRT4nKAjlgGN9FIv
	kdFIEUzcTbJ9dNvAn+Rl0Q/B1HH6FXF5HSXgK6CMIVfNcrHUrKOr5vxk7UFfyWmwVwdfYO
	Vj6t966BhbyBIDyaKxfVK9Zvk03H1ck=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uLwXVID7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760544120; a=rsa-sha256;
	cv=none;
	b=DwVrYaS1GDyJgoicvdoU0QiVtpjwmD+qAshDyoNMS4ns4ahoawqyOgKs1sRv6DMB0UO4mM
	DmYF5lRoT8us5U47s+d9rLMZXfGzCqVeOPm4P9cia452esIMhF9gUnjIouPTaQBJEDgwkt
	wqrObyfIQBoXNL03Pecyfp4s+CrDWvw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 718DB602A4;
	Wed, 15 Oct 2025 16:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EC5C4CEF8;
	Wed, 15 Oct 2025 16:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760544119;
	bh=Ib8plWshjqLsG29fR6AtQ9r2xzraj9E0iv8tvd4lfz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uLwXVID7J6t4Rv9G7dC4W2pXTpcm0X4qDwvtPeJ0mY8cQ0yP0HE4IMGRLMGWOlPuZ
	 n6Xnc0z/SiK6bYdQgEbj/tXlFcK5sXF9cFQ8KvMuyU+2J9G27eBZYH5TuYOLXNIE2J
	 qIzK9ICGR2xvC01O2JWBzcNR98P/Gd9fWPoosuHyDeDjQBm/Ts9WhgMSmvilDztM09
	 BEOF7VNY8WpY7lgu2b/iJnmY753f27HjVDq4ivY/C4yFTCNnupHYOFlb+HIbpKl5iw
	 yNYyxnIaPzZloPbTSEL5+0Nsi5ZDbTj19jYrAGXieKH58h8EBhaSFcjp3XG7P3Lwpt
	 WQ/UoETM0hNeA==
Date: Wed, 15 Oct 2025 09:01:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: set s_min_writeback_pages for zoned file systems
Message-ID: <20251015160158.GA6188@frogsfrogsfrogs>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-4-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0456A100011
X-Rspamd-Server: rspam03
X-Stat-Signature: 6xq94u984noxtt6ijy6kw3zm1mn1peur
X-HE-Tag: 1760544119-322140
X-HE-Meta: U2FsdGVkX1/31QAhscqcCmEJI+tqZvCaHFMVdJ3/mRr/J9WKqp1VgkHSHXc5bwrg45Gw43F9DQ2rRkdbW5VXMCVE/Yaq6UDRmE2LwXnZkWR9s1s9NR5o4IhTvCnBZcOnCPPjq6dqOn2x80WoRGLQSQZzJbVl+zLswjhxB2EZhCRsOabqRPLTOLO0LJyXgpXbycd5Vgs9AwbLnzelSI/M3S2Q1WC4920NAsfB8sB4Zkt/5iPieNyVdXZMO3NGKw2DPJn3KnXjNdRX+jyKXwhJqqxMpT3ktwChSf7/EL5nAugsChWYB/i2tFdx4Gw1Bae4T9zvK/I3bMr4s6G0Bh+xnFKixfZ6swDOCsHAS9kYsDmEZ92+7uGbJyKHSUj+Z8ayhXAug/3DNSY1SC/K0Ut7SMPO71oCZ9mBxGkPFA4Zwf/k8o6UAfLSdq7Kb3M7hdtkp7/APR+YDIpYxCdiTEyomq7iFQgcBHHmezVkAdfzTBwulPE7OddlpD5Q5i8/SBxZ4+zEFxe7x9yYav+kcSAEIZzdOgAaRHjtuEtMNkJX1mEpxS8YfMtcqG0pb851y1kmXU9DotSzBT/UhlL0lUWSe9LVQE5yy6CSpJtKHnfXBenfXvkkBKeJUQEy76uds7GTdSTtFDho7G3F3Q7M8IsT92067nTYDbmfiOI9ObPHlLY93siT+NPQ4APQKhDbX1dtv2alz2+WQWMrSVxzL7A7Rz9tboQl9mIJATdqK5eQRRReqnj1KF8ezZmK2PQOrauQ8BpfPW4ApnfA0p37SjsldQJB5WqwciZe6Tq/+k7y7Cd9GBxfvd0VsUZIczbr3GHgIpB3YoehPvlawnW+dbYqmKT/aSn02TFSy9rqOvCS855jsv6gKJ+w/rMXElQ8F/aYcYjaJzZHkqL3rb2vb85Pp1zg/4AQ5mZGtdV3/ly5M491o8oo/IZNkAkr/wkqq5k30A3ttK0/t1RXcNkwT62
 xcyLUhDd
 WrIr4q4GWw1rYvRtIG5R1pPB6cGQXlDcAKUqawY0OZJH6sjWlkZNKuizqrdXeFel2ExPqlVbfnjsSZ2YushqW2W+wi6m0PIon4FMkhysRMLIAdNytomkolFoTD8FFKiQcd6CZ45qCQTjL+6LxhrpRuGCazC1FR22EtCwZFqvphK2+6EhxSQP74fT1VD6fDTIpTOw4Jy29iavVzmyoe10vJf9f2E1E/y66kZjldu/ejugxGYhEZTclJSGm9wIfUHpNQlXhxZtOwRAE6MBm5EsJ0DAPk9ORzyEe2ULkqE2hRk7xIRhn0kDvUpjc2Xaezss+BBx7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:27:16PM +0900, Christoph Hellwig wrote:
> Set s_min_writeback_pages to the zone size, so that writeback always
> writes up to a full zone.  This ensures that writeback does not add
> spurious file fragmentation when writing back a large number of
> files that are larger than the zone size.
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_alloc.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 1147bacb2da8..0f4e460fd3ea 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -1215,6 +1215,7 @@ xfs_mount_zones(
>  		.mp		= mp,
>  	};
>  	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
> +	xfs_extlen_t		zone_blocks = mp->m_groups[XG_TYPE_RTG].blocks;
>  	int			error;
>  
>  	if (!bt) {
> @@ -1245,10 +1246,12 @@ xfs_mount_zones(
>  		return -ENOMEM;
>  
>  	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
> -		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
> -		 mp->m_max_open_zones);
> +		 mp->m_sb.sb_rgcount, zone_blocks, mp->m_max_open_zones);
>  	trace_xfs_zones_mount(mp);
>  
> +	mp->m_super->s_min_writeback_pages =
> +		XFS_FSB_TO_B(mp, zone_blocks) >> PAGE_SHIFT;

Hmm.  The maximum rtgroup (and hence zone) size is 2^31-1 blocks.
That quantity is casted to int64_t by FSB_TO_B, then shifted down by
PAGE_SHIFT.  So I think there's no chance of an overflow here,
especially if s_min_writeback_pages becomes type long.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
>  	if (bdev_is_zoned(bt->bt_bdev)) {
>  		error = blkdev_report_zones(bt->bt_bdev,
>  				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
> -- 
> 2.47.3
> 
> 

