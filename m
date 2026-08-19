Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EC6C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B9E6B0092; Wed, 19 Aug 2026 05:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEBDB6B00A0; Wed, 19 Aug 2026 05:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA5A6B00A1; Wed, 19 Aug 2026 05:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 885FB6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:15:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EFE51C1127
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:15:25 +0000 (UTC)
X-FDA: 85117460610.20.75CC9DC
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5D76C20006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:15:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf31.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787130923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Xnw1hiwaJo83TJqfcWhD8VeUt43Ja9eq+4r4K95bK01oos/tt3nI46Q0puVKafUwDATcXu
	V+PUn/FusbXlZInsMuwSCTjQUeRW8f5rASQyJ5m8w87DyFEn2OPjyLPGw+tHjABoE/KdBa
	LT2i92OzJWjNaQ+w7csd3cf+W1GCMzw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787130923;
	b=MpzDfm2uwELiGw2v11mbvQqblbyiKPuuixlbFW4hL3OPpZjrglyiht7nJL9UVU7tsigIMo
	z7q5xYNt8Q916S/XyuuljdhzcdyO67mHxwIYOqREHK+HM4JnfbDk6v10ikQIqrNJN0GFgP
	9uELfV/zqi0WYJeQRlbaVnZzIW0F/gc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf31.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B105F68C7B; Wed, 19 Aug 2026 11:15:18 +0200 (CEST)
Date: Wed, 19 Aug 2026 11:15:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Yu Kuai <yukuai@fygo.io>, Christoph Hellwig <hch@lst.de>,
	Tao Cui <cui.tao@linux.dev>, Jan Kara <jack@suse.cz>,
	Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
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
Subject: Re: [RFC PATCH v3 3/3] blk-cgroup: move async bio punt state to
 blkcg
Message-ID: <20260819091517.GD10298@lst.de>
References: <20260818070641.756747-1-yukuai@kernel.org> <20260818070641.756747-4-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818070641.756747-4-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Stat-Signature: nszrm3xa35yj89f4oe7i7fbag8yiga37
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D76C20006
X-HE-Tag: 1787130923-654344
X-HE-Meta: U2FsdGVkX18ap427fl8DZZaV9y2wTxEIV0dD5GPNn/0AWjeV1z4BOvMNT7tnXCPAuCF/ecyEc+jBMW1gu8Lg+SDyDJ7xmCWpLBiCwZLcfLBbg/E/ArqU+62KlkhuybWM2VkAOKoKSsyN045Uduf1ZGnMoLrHVd6EXhLn/Ge59KKa9rqStgAH8fHd+LxJn1JyfQw882VF8qjSawcvqS4/B4bXQwkyHAt7ZqCl54QTSvENuzNcrHyY0vvLj9zQr+nxaDJlqJZ92GvhuKgZb7PUxB7SgHWYwzF7HCxNEQ3xwIodoHeFVIEofULDrPIGNeBTohHndqAUX6v6aybygXM2kJqpxfMR3PIQUWSmuUFFph7vH1aB6A4KiJwY/cpSicY56YRmIMtW1FjtAelX1LKGY4ECkreN6xA7/WUnbJXW4FdwHD2NK8uIoyLKVa8nwV4mdYQtADAxOi6WbYuTRRDsqgg2L/ACHPZmNFivoSHLN8uuiK7Nkv7ZXU4vdTgYVts1Yj9A4MAjJx2qt+N2ENNWFdEvox91TkdpsNh++x/R+3vdR0enTytLKrn7fz0x2qyzcXLoRyaNueEQ8Hihu/V25T5uhWWLwu91NR5pxJO9R3G+LLtugh65IcevhvkRHRMNDSEd8nikMwZSISFW+S4S6kQSMHwkcqyGMTtRHlODDqiqRTqdCcdZimoP6PD4aSQg3umVS/GnLssuxpj8nLgRrHZsP1r2OyJiUYNFa3dPOipmaBzDo4nT7OZvcvL47pWXl/rS4ew2Cuq5+EjoXg+peduomOSiHbYA/86QApMv7Pya1GBn3eyAccm8LpJZ/GnxpXU8yDePENAU8Zm7MIa4tD9xY2o6LSaSmuIsmCQSF3gC1aHahNWvQgp8vJq/3/TL6L5giRosLZlCLADXvEMW35DIu86VPcoLrvWF5Xa0W1HSiAgoZnGKZMre1eUDRja3iJyHoH7jlpkhjstRhJT
 NMPVNaZj
 chV4+8BC+pDU3MXkntEqKGHuPMhsqueL31vzxqX4MZokv/5BDxe0RVf8adjaF589G9+K5BroiDGcC6Uj8tUI1Er0CLsCcT861SOkr1BPXk8MuJK5+j/UViET3xYgDNwdbCQJIV/F4fw8JYFifxMmosvniurRpi9Pga1GpxKzor0Ac2l2wlCSW1JcE77MQ2qwUr9M8/+ssdwfn/mjuUBnXw/nW8Yee/aXQ8/1BDELAp0gR49VY+Mqgl46gxP8KPZIJP6Ls0s1qmpGc40RUJT0skRb1z5Ck+jr7/ubKybr8BkDhaJnK8CDQRyuKSsFrn1F67Cynn6RvZcS27TVacRJyGMspXZfAWbD9eHUUDtdNnXNYgOdTGLHgggpArPS2GBaabxfHh0HV19tzDN+nHaEpSKVZNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


