Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297D3C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E986B0096; Wed,  2 Sep 2026 09:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11666B009D; Wed,  2 Sep 2026 09:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27196B00A1; Wed,  2 Sep 2026 09:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3F796B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:49:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66934A01F5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:49:39 +0000 (UTC)
X-FDA: 85168954878.15.0B56FD1
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9AC1E1A0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:49:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788356977;
	b=KEGyhLqfq572LAq3leVGQ3z6/9fR99HR/Yx4XqWa59RTOOe4XLQN6T9TNwCb1NYI8QO/7b
	gkkzeQZ0OeCl9tRV+Cl2pn/KPqdOGqR5RSafwpVxKGQE2ELDCKJR+bT+i178bnXl0mckEN
	bQh/5jLIFCJBcgcNvmCk6nm6btAxO4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788356977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=wjxrPza3g+vnlgfW5yS2nLZrVxmMHovB03kiLwdp0Md7hYf2dTRBB1mR3bM55bxgaVW499
	YaRYcYDQIKae0uaxm9Dxd8MolDClAs2I9Zb1E+YiXZKb5Mi7BAsvhKm0PUd6FlFgC1sCJv
	E2XBoznHth6d47Dvcsud0aV4/lHjA8k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf19.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 83AAF68BEB; Wed,  2 Sep 2026 15:49:30 +0200 (CEST)
Date: Wed, 2 Sep 2026 15:49:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-ID: <20260902134930.GA22560@lst.de>
References: <20260823133045.970199-1-yukuai@kernel.org> <20260823133045.970199-3-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823133045.970199-3-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9AC1E1A0003
X-Stat-Signature: khf7q46jumosd4d7ejt8knofcd4k1j87
X-HE-Tag: 1788356977-129063
X-HE-Meta: U2FsdGVkX18tX6ax375jLdi8jwFHx3SMhfD9DdsbzJxHpLk3cMHHwLPMUw1I6+9lhT2ZnhAf+3njBWYZi7lcYEs5X2a+2Hjat4rVy32OZ9Z1T/dUzMoKuEWKRzQelh30WieBgsxkTrhJuXRIcxgTwAnGLI/wXgMb3NvFxzRW/aye6coqY1OLnZREfHfAO+FvpTTWfDsBOJXG0ka23GYUFqa8Zdw4beJYfsGHy3uYM/pXY9aalpwnbh9VR1tkJjfPX7tZQZJaTqqNRlT+rZY77J2qtmZjYOy33sqZQ+qZxAtIpvhn0byIeRtRRNFVei50R9mN0+0P7WTm1b/7Zv9NQXdzGixV93GVRNn4/51yk1zirNQSmePZnEUIkSBo/S0CsKXlyc/65j8MAgO1ETh/xHijSyQ8AX5e3oXNHJYK7ZflIsQI3aOl7pdlLBybRv8UKnGYew6YMGGtym9lwZN6zAHzvmkU+wNn7PMLIcRpoHBZ42l7es0Eo5Aax80bBnYgRtIskmS0bMcMyylfWaKtCjVe8RG2CDT4tUjnkGLgI0g49JSsLJaKKqZ7MeTvZxMKgVGYaQV8iM+A4g26UWU0Fi/fR+9AJzJJBDcRJg8EinbiE/j4Letcyoyg4oM6pBs4ICbavegAtdd35wEJ0Gg10s7O3UFHZEugF8X0/i07mkPKmSdCCm+r8SXt5bXW9gxDdnNpdfERzuvavXMfgSJIS1dYdZUbKvlTUlBxF3nWeeAaxkwiNYKz6VEvgBIDm/PiyPHCFWmqIYkEevPdkpesAEnACoEOFCEGUHJt1p9Ir001tx1G04zLVyXmPTLb6dp7xVhB4R03dBEExcLmDIyYt9iDBVDetW9d7GrA1wH6pW4J6EK8rw2p1zFpkPEK+Iqk1Ciyb73fjK8yPm8GWIE0jTvj++a3I/+wAkkvKIMK1xJunZaVh9/sJn2ixqHk7x4n7K88T+hzJlXuSor6BPl
 cl1czqSK
 WTFr+13/OSVdLYEQyla9dCylu1Qj/bq++5tUjqdnCzNTv8Uc5i915FLmcGq8RG0FPnVBtyJlFILz5/I/3qq8hvRlduwa0iQQfRffmlTme38t+KfpcJKCDNBjW0iUQC1zPuE/tg4g03QvqUQsCrjN8kgWVhBWTK1rP6PIf15c9tzlMRJVyPiki2b+xNmAW1o21mvc1N8ZzVEOsfJ/V9m3H2GCs0Ij+FvRuiCC+fU9MfGapiZwd5C1YkTcNIQcDZl4YNEuyzrHcqdREI44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


