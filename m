Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56F74C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 08:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2516B6B02F6; Fri, 14 Aug 2026 04:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2116B02F8; Fri, 14 Aug 2026 04:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A21D6B02F9; Fri, 14 Aug 2026 04:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8A686B02F6
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 04:15:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B71D1A03CF
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:15:42 +0000 (UTC)
X-FDA: 85099166124.18.7E6B22A
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf13.hostedemail.com (Postfix) with ESMTP id B62A020006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:15:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786695340;
	b=KVp58pDjs8F4jhZnwNU5db8HETAsbI5e8dDwEbTkV0kaOlJJULn4teK+RkfdCqedrR+O7C
	IoZ2RBbvK/pZsqSIhr18QKZFJklgBofxbCZqf+1sQlelLJ809yoOouj/00BDGf6i8AsKxZ
	UGDwf04OzATaorWEf4p6JWxruKBlfrY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf13.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786695340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D+WQ4ckGHfGCONk1SGK3euQRm25rVmYQjqqQidri3Vw=;
	b=YYZ+Hszb2+U553jivn90s+9MydU/0dWkryiSwEgFW2O0xMhml62/a8HKV4vuLVQ6MNsO1s
	httrNgsSMDn+VDTz/r0ZaPw1KVISEutIihQIjw6PBM690/4JAIxsGXpKGP2fdMPswbaKcN
	URubGqAJq9spaHII3LV//NEyU+ZZY8U=
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDE7568B05; Fri, 14 Aug 2026 10:15:31 +0200 (CEST)
Date: Fri, 14 Aug 2026 10:15:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: yukuai@fygo.io
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
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
Subject: Re: [RFC PATCH v2 2/4] blk-cgroup: use a request_queue rhashtable
 for blkg lookup
Message-ID: <20260814081531.GA13546@lst.de>
References: <20260811064744.1139446-1-yukuai@kernel.org> <20260811064744.1139446-3-yukuai@kernel.org> <20260814071232.GA9784@lst.de> <f7350050-062a-4ced-9396-05ac33ac3e60@fnnas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7350050-062a-4ced-9396-05ac33ac3e60@fnnas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: B62A020006
X-Rspam-User: 
X-Stat-Signature: jezxmpiuf56t1n6rzwu39bh6qf1mq7cb
X-Rspamd-Server: rspam06
X-HE-Tag: 1786695340-643075
X-HE-Meta: U2FsdGVkX1/1/HnQrwjh4QfsaeR0LHVlMqD5k60mkcEEmCFS+lncRCZ1qCk+4HbvtYW0MAJmH1SS72E06q17i8id56JGxR4Xr1tMVFVxGV9IOSQsi/xtWl1/sFqElNUf7ZnTQVY/e9r70vJhEQqtxaNIJkWPlrotE050bFk4Q2L+y/br9+lcqfuCFsiev192mKiNOKq0bM91Duiwj9m9tGGiaSXC5yghigjHUioiGN/k8CTSupjD0Um+Ft6GKrmZQkccpXjkZYPHZH35ewTohfyHqPkVIiYandMD2dwXjfihaRQM6aeSaqfwTCyAsD1pluYB4glcT4OhVjeUS/8m7kJ5JOwZKEpj2fuMq8uXMjSDX+B01b1v9CD+Be3zDJf55MRSlSqiNMcY68opKZN4McimhhNfff/6EfyK+WXVjLBNtWB0NuKMf0MKDwGbW9wmT399B4ZuFNhLa/KezIyiEyl6zN2MS/30DVJdqdkN3AGWN+E0FG3FIW8V7wxfuTXgChZiwSogerI4AsWhgyOVbcclcha2s/oWRsyZjW3dQVUHSXMQzlcQzPurql+JlLtBrBKEwzElXcrFa6/VDV3bvTGvR1kKDTFgwyr+/K+RvvsK07gwUtP7v7Y6SFkYvSaP/fDfwCWsjrMbBzCoDXCY9OsHONmOf9TaBISIhl5kHjF27lqPfIH/7zOPk78tfCGeA6gSc27ugBqHo+9e4coRMgQKx37hqK3Kr4xId35gdNbGDkqmDTXL1OItkHNyYDkJKwm33YjWJJUouD2eoKmf1/jps1XmVTNtxp1fnwT2uUQKpwVW2L0Dde8wobjzVkYeRgwxyLhNZuDHVSdoqxsphpn820LsZf54YSPIysWWIew3u/7D3pfbzC6XkedvNeHDn1WqeMotSWbCjNo44G6FcZfDNf57EBqDplnkZrL/h6O/l5JNwohY041kg77ZlWJ4kMaRFgl0YYxdQG8kryt
 73p7lxka
 Zi5KX8PZyoJJg4YXuS2dBNWzYbcJdMcXtZs36xkxpAJhUt8V6L+ctiT3vih8QM/kIKxWK9M3AeES9lvjJweJ2a/xujpWnU2vBpZWkCl65Khy9ZgM/owOmjPDKbt5sGAAR0GWxlRcmk1LHRStRuvB1ihUZIGK3xLdALj3t07UkY/7sS25PKALru09Su2V8Cf9VUjfb9j/KK7XoinHQfEMRsnZelk1mKu5K6qHyMnXUhEDJPwnBtXLImn9riQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 03:50:04PM +0800, Yu Kuai wrote:
> > Are these fast path operations?  Otherwise we can walk all rhashtable
> > entries without an extra list, but it might be slower.
> 
> All users are from sysfs/cgroupfs API, I think they can be considered slow path,
> however currently spinlock is held in these procedures, I think it's better to
> convert them to blkg_lookup based iterate after spinlock is converted to the
> blkcg_mutex.

Sounds good.  Maybe put that into the commit log?

> > Please add must_hold and/or lockdep annotations for this instead of just
> > a comment.
> >
> > Also maybe mention that this does not acquire a reference and the caller
> > must already hold one?
> 
> Perhaps it's more accurate that the blkg is pinned by IO or caller already
> hold one?

Sounds good.


