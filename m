Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5829C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E816B008A; Fri, 18 Sep 2026 03:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF0F6B0096; Fri, 18 Sep 2026 03:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE3F6B0098; Fri, 18 Sep 2026 03:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77A656B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:16:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF5E3160591
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:16:42 +0000 (UTC)
X-FDA: 85226025444.12.D960B91
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf24.hostedemail.com (Postfix) with ESMTP id 12C56180007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:16:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YfOXUVtngDJGC0ksx0qN0Jrf5itr4G85/702cUErCjE=;
	b=X+P/DX01oo3501lO0DQq1tMEXkYdmSn/UunMg8dC5Gzh9aQJ82ZnWXdKC5b/En6/6tV1eG
	ETNTZGX00hLBrpd8E5waQq/RquSxxLIkHZHU/98bG/H5h4GM70b0LFcizvlIwAkGTIjEVO
	qZCuBNkCxufKfWs4+gZIhOfcqktj+ag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715801;
	b=YZzrn/AVjIyE1xMxIDQpwsLfmylp9MbsQwQwwTU+EiBZVpxYhVRjSRuQH+IJ0/CTA/10qb
	Q56cyZX3+W5iV3EfSVUT1MYNAbLE42/0qXuf4Zvd5Hbw6W88LpVGN6VVyBIP5gwFHeRAHV
	zRR9Ao7yMgmYZQofMRHytaXLHKlazPQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 619B168C4E; Fri, 18 Sep 2026 09:16:34 +0200 (CEST)
Date: Fri, 18 Sep 2026 09:16:34 +0200
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
Subject: dm review needed, was: Re: [PATCH v3 2/3] blk-cgroup: store blkcg
 in bio instead of blkg
Message-ID: <20260918071634.GA10884@lst.de>
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-3-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918041744.1526924-3-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: gi913515h75kdup16yygsdxr5tp9ccft
X-Rspam-User: 
X-Rspamd-Queue-Id: 12C56180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789715800-325303
X-HE-Meta: U2FsdGVkX1/TcuMLbxx0R72yR52BYNiRCjQrSAWnXnWCSuIWOSRY34ZSd71nqhQrxo4ufc/1/7Uq0j6qA77n08QYUXoBoQRkfi43DfrpRiqNCvSU0KMmDvc3dOdJMtgoD4gqPelcrB/CMWvfQ8/DjbCfxQo1i68Cgx2Z/BxrW2Ddu6GQkCzumPCVOwBgUyNFaPZfliAKNJE9Dz+X0UysSKKDZ+SEHMpmFqVf+RO0XQ8t+RLxIPuRaSAkTgmPjEQiUamvZuhKdW/KhxPilWfJLGN/NhSvE5U2t/TNwoII6mPiRgcycHGdM6O/OQhGsvPdF47tREtyb9uJU3g4t7dE7DyzeYAr8EafyG5i/XaaDzKkVv2d519d9gxK3FvW4vEu9fgqgFcfp38ohiI9BRE1sKfldVEDaXeoTHSp1tNb2rpbWXEsLyD1+dVRPOpOFM7YdJRkB+JmOzd3Q+c4na0mK0IFWWSQhYOEYsaGamaekGfk3Z4w9X3bJ9fzqirIoy/Hex5zVAe2vFNd5S8s3Y2m+8PBhgeHAJt3C1Fv7DrubTK+Uwd6RAAlDJ3MOlV6djuLrb+GevouvORjHou6dNv9GrCq7VwJoyx2Bl/kzDarvwaRIfvMjQ80RCJgtMf7uJZ6Ft+jySo2qo4EvLa7qrIwize/VxJUIjnFFVj5UndlkdzRQXeLL8/irdFbrl7vUHRdR/UrnVqAiBwecWS4JX3oUufFKzsx4pZd4DDFfFa2x5Kz44RBAMn1xZ9OGFykhd2DlVwQtPBD1lp1NxLD18IaTSTfLC8V0nditVPl7l2w5AwMAkIIo3/tuvWfEDa18VM/A/zMf+PWKNoR7AmYot2GvRpFZknPMDS8BkprPse/KEDefAwjtWj386j49CfOZf9rvG5fN1zaQeJ5aW8qRRZzrnNu2G3PGo+eJhqosKFEgwWJ0HTtSAYd1JmdhmB1dp3LKhsOnEF+bvFzLA+uY7a
 PePK5u+R
 cYOhZdPqfhaDw+9oOIoKX6wn0TY5dc68b3Dq47529K29q6A7SE0xRvbPa2Ca9IRGCxAU22HU5quL+Cu1CAFEGbHPI7BmGkZk1nFfc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:17:43PM +0800, Yu Kuai wrote:
>  static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
>  {
>  	bd->bi_bdev = bio->bi_bdev;
> -	bd->bi_flags = bio->bi_flags;
> +	/*
> +	 * Restoring BIO_BLKG_REF would not recreate its associated reference.
> +	 */
> +	bd->bi_flags = bio->bi_flags & ~(1U << BIO_BLKG_REF);

But do we need to restore the reference?  I have to admit that
this surrounding code is very confusing and I would really like
to have the dm maintainers look over it.

