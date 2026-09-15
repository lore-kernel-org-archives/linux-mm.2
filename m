Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BEDC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0142E6B0092; Tue, 15 Sep 2026 02:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0326B0093; Tue, 15 Sep 2026 02:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7FCE6B0095; Tue, 15 Sep 2026 02:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADB6D6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:49:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 321A1C0344
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:49:59 +0000 (UTC)
X-FDA: 85215071718.08.550E2C8
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C33AC0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:49:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789454997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FggKGm/WFFE+x9D20ACL+L6UR50221e54Tgo0ZGVRhU=;
	b=DLHI+M0mHnzT1NRgPxYTD83OJiQ7I3PmoCweiqQ/1c9HswKLpZAd/Jp7TmldIzp53Ph9cT
	K2td7BioK2KpkqF62XmzttZbM8t1N6XQRahvE2TVVuj3MK4Kah3qz0e3zpApAFO2YDTWMe
	kyMTq26in0f2hn/e192XA5hCEjJLiP4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789454997;
	b=6WpEUaqNgx+bE36DVGnmaKRsW+mtRDGKqf4xd23hv3Zt8G8t/GeCNohOEnwRxPe+F93GjY
	+5roDnDrkff7TtBfeqRg62gdT/qdEnKLX0dGkJor7iDcZeBMrKbValIKZhSjGp068lbZeB
	beebiON3vme6jPu1h4CJZtMCUkLOljg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf22.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB37468C4E; Tue, 15 Sep 2026 08:49:50 +0200 (CEST)
Date: Tue, 15 Sep 2026 08:49:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-ID: <20260915064950.GA13417@lst.de>
References: <cover.1789237876.git.yukuai@fygo.io> <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef547fdb7a6c8e39a25a1b9473c444f24a0f03be.1789237876.git.yukuai@fygo.io>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C33AC0004
X-Stat-Signature: dinrkf9p46pau1m3iko1jwoxmppxcda7
X-Rspam-User: 
X-HE-Tag: 1789454997-193071
X-HE-Meta: U2FsdGVkX1+MjXWbiuph5MW4DUFP9hjRYMnuwAHsLTyoBHoY9q+IeQ9abojkqH6WTrasceh+cSXzQXzF9Mu3sUS5v8fvNocdgiLbjXm18cJSXdzpEi79xpMlliUWJlHdZM6GFXN3VBIrsnqBVNfvl6J1J6sXcaJiiG7tZGsfsC8HgBdWa1xZoK/fpM3m+re3RRV/AcGoGEqVyH6vC23ZBiGS6shLDlN4OBsE1JL5NbwNYldS3Zvo995ZejhyPCSNevb9IBrSNqKMZVHxADSqxw1kSTnYXjtMZ2aaJpQb9MERdix2gs1poWN189vyDV6IKfuwQAf3Z80SPuCRNmeY2pIf8DXgQD0ux3xZNg3IawTPZHXRcigqv/wmBs6I0M5uEbSvV2uMKRzoPIgnVCoMMfkYM0zGn9cM6BDkcqTNliGUTrQhd7KtL40XnZ2jhsTzJ2+6CzMtzgoCvYLbQjc0bPhTEO0qesKCq0mcy7SP4AUooY7ocyL5kZBT6EI5nT31I05ff+5L3qCwcNZoiMPDUJzxJBGTwg2bNV87RhxsMA6eyfr509tBGQq5RbqRZsTsVo6gbGMMY68dgqptCldxmwzdsKhya7jCIXvCGR8kVb18LsA9WFACE1th+qxwiVzkChp2zj5+nldcJKhNVxClYmYZh2liP+O+GP4MP8Ow+NnGgVF0dudIChkHI0B25yjgA5wc54pzyGGOhu36dwQiWqAtRSsM150E7hUzadA1rf4Q1xONBFbSVVbkHu36ZTFbWkvYCTE4Rk2PlFl9pXhz1vGvSZnkr0iUyp9aOQDOKbXcOLOHMqwKwxdjoKp1tR8tZgEurOwgDSvtvacz5xsxuw83RbnTLR+arAuDUhcL8xMXMYoX+RZN8+QYHrxKqmryb9iYDOgabwC7Pymj4DG/PedyF0gjr8Fjon0MXrD9v+MU80FfLirU9TDXYEiaVvPSUJg3X0V8nmxzWPDa1oi
 rC+inT3q
 D+0NvlmXd6Ze/THXOftSri8Mwwq59CtWe2GGWKUiH79RYe8aDnxxdVOu815EzaPRAv4wWebACdQA4HLMb2dCgszRmFTf8ig76Q/v1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 13, 2026 at 02:54:39PM +0800, Yu Kuai wrote:
> @@ -6243,10 +6245,17 @@ static void bfq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>  	bool idle_timer_disabled = false;
>  	blk_opf_t cmd_flags;
>  	LIST_HEAD(free);
>  
>  #ifdef CONFIG_BFQ_GROUP_IOSCHED
> +	/*
> +	 * Pin the blkg used to look up bfqg.  If this is the first IO for
> +	 * the blkcg on this queue, create the bfqg before holding bfqd->lock.
> +	 */
> +	if (rq->bio && !bio_flagged(rq->bio, BIO_BLKG_REF))
> +		bio_blkg(rq->bio);

Can rq->bio be NULL here?  flush or empty passthrough request should
never enter the scheuler.

>  	if (!cgroup_subsys_on_dfl(io_cgrp_subsys) && rq->bio)
>  		bfqg_stats_update_legacy_io(q, rq);

But I guess given that the code below checks it, we should at least
be consistent, so I guess it is better to keep it for now.

>  
>  static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
>  {
>  	bd->bi_bdev = bio->bi_bdev;
> -	bd->bi_flags = bio->bi_flags;
> +	/* Restoring an ownership bit cannot recreate the associated reference. */
> +	bd->bi_flags = bio->bi_flags & ~(1U << BIO_BLKG_REF);

I have a bit of a hard time parsing this, the line also is overly
long.


