Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC59C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785A26B0095; Thu, 20 Aug 2026 05:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75CD16B009B; Thu, 20 Aug 2026 05:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6503D6B009D; Thu, 20 Aug 2026 05:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44FF96B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:58:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 80D35140718
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:58:08 +0000 (UTC)
X-FDA: 85121197056.17.5D6CD74
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67AAB1C0002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:58:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sfnF2BCp;
	spf=pass (imf18.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787219886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lW4CGRmOw1RAu8rBG0vHR1Pu0LSr5rJIGAdERpyVYbA=;
	b=uLVeNB5FzDhBf6KEv8rE6/CHH20lR9ChXV3jMHlbgCFRNrrjBWu7IvVc5CT9eqUfsKWmqW
	a+mqDEXspuGzXhT6Xk//UHxVixendL7vLHqeG4a3POX0ayOjRh3df0URAxRuz2IB7v9IQn
	L9F5wteGd8vpaRApo9Raf+d4e2Fiu7o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sfnF2BCp;
	spf=pass (imf18.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787219886;
	b=vJ3kM72X1qIsNKToq2UcI/TXypdsZKI1kDBWr+U+PoBp5j8rt2Gx7A30HLTHvuTCjZ0rXK
	4xP+TP/q65Tvtg3JAPZQcpR2pn9nZl+x6cyKUGBjWdzdhslZhubCEGnV7VfP0/xYR3sCgl
	Zk3dnVVi3AvmvKH3rl3jXYM3Vh1afAM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ploZAqY/D2hnRbV7P/iJz6tixE4616igwYG3fSAUDUQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787219884; v=1; x=1787824684;
 b=sfnF2BCped+jyf3PRpPzWg9vqwTDJJt/G77kBAYEimhgBNMrXjAjpD9Y1q39Y7RVJZIgHVDF
 dP3uOTlhH0NWBOeZD26tkFr79yLOS8u50QQQsR79HARIiD5vn/XFm2aNigQbOJgSyK2sBQZDgh4
 YWHkgVFGG3nvg4rNpjKYEpBw=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e22b78b065807185;
	Thu, 20 Aug 2026 09:58:04 +0000
X-Mizu-Trace-ID: e22b78b065807185
X-Migadu-Flow: FLOW_OUT
Message-ID: <f9ab386b-fe45-49ef-8e7a-c8544ef3241a@linux.dev>
Date: Thu, 20 Aug 2026 17:57:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: cui.tao@linux.dev, Yu Kuai <yukuai@fygo.io>,
 Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
 Ming Lei <ming.lei@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Coly Li <colyli@fygo.io>,
 Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon
 <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny
 <iweiny@kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 virtualization@lists.linux.dev, gfs2@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 1/3] blk-cgroup: use a request_queue rhashtable for
 blkg lookup
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260818070641.756747-1-yukuai@kernel.org>
 <20260818070641.756747-2-yukuai@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818070641.756747-2-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67AAB1C0002
X-Stat-Signature: oabw84tg5uuposnodnaep3eu1usdy6r7
X-Rspam-User: 
X-HE-Tag: 1787219886-524510
X-HE-Meta: U2FsdGVkX1+EpQ8cF4vtbpn5u9xmpotSN2uK/Tm+RJ0m6tDYZkGp5OLrtT/FEZQSWGBrlgkfNRdXrn90/YocjhrEtmlwlA6VzKFZQMsYrsNkmIbr5pktTMw7fhGLsutk1ZtnOeMRR+ovUDY6MUPKWEy00glFJ0UWvbmEYREba2fhLgRTutu345dZ60ARvsFjZ4RqWwBGyrY2cg1HQkh9f5VB+y0+sJv0n4j9AW/Y/abAmkHSz+c82FYXOV0BX1vfx8SZnhVhjQdJo1ZcT8c8bx8Tgwy5IFx3RzvXOyNknPEMpu3T2nAixhoRlPA9TlrIIVpmWvdZb1fOHWKKB3OOZdxbPRG/cHzxez0K+/12lCe7BDOpFH8eAFDV26ko5uEOYrrbXbqbPyOjAhy15lT8Y0QUodkw4wz65dsZGQP7IqVE40WprhKYo5LuG75My670zEAHCwG5Ur76nKDqrTqu957xdDpoTa9AQM/gGNGyp0Pg5QOw0VVHqPszZIo6k5lo4R/edRYxJ1CvJGD3yjvOtGkUMyaJSnsd61peoPftfqvte0Da5+moAyOvZVoidrfHGeVqauH0ghHuJtR9/Vd/7Iz8IDdYQgwMjz2P40Ntv3BBDSqLqzDbGp1bA+L/B4Oyp0MXu4pqVDUaYwHz+UMHPLJeoYN7AtK7elKj9wi/dLpGEJOhPhg5MUd6w1+VKFJNZQDau0MU/sZpkhMoK68nUaOeO0XWpTl3pVkKqOfNDLexI0acNu+/+BEXZ1AFH2dkrfo4p9do+ZcA0ckqbMl0jIwu3daXbpk68bCdib14sjVisfFanES+IIXgA3lum32rTwQr0aHl/cKsLSdE+CmqmreIhA2Ph3ksOexyWdWtVpqaaigeexCtXE4wUI2zP057PPAjJuO/9++W5DXTfVwlFPdqOO/ofLDuOL5w/fb59eKBdloinORL7/5dkHXVV1Z+jYCpzZ+F9Y4crdRaLCp
 zKyjtgh7
 tZKV9Qo+ZRifsZX4Ab3SZO8fzLhya8ODVme9RtZLpkiDbhGNRV2wSvr/wVYhrVcj35wRR71xwU1u2Bqrq3W1OcUj+8zbaE4Xj/qcFmhsSV+/ruFxs9lZRq8V6OIVtxf76Sm2nATXZBPzz0sVYzIEw1dbMKv8Mvhe5HtnlRn2HRsoAu+y8EAh/XGOsxUS0kV7YfaeBb6DJ4QKaw0s1NsgtdZd4yPXn3uNViVWpBPfxtJNQAHkwoKrpmah+zd+6or9Qeb0bUOB3O7NZYGVOoeOT0t2ba8xwWgws3Ejch9bTr8cQzQ8H1P+8aSx8hQAU5lcJpDUYG9PwPDQawMe5KxxQt9sP2AAjjdlL/8OF+HBH/MVxC12wDkNuLNm0FN6qOmy/h4rlSVUc0vtEGB7W2bUWL9Tra5PVRlJBfeoBo8paDm6unb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/18 15:06, Yu Kuai 写道:
> blkg lookup currently uses a per-blkcg radix tree keyed by request queue
> ID, plus a lookup hint for the common case. This spreads the queue-local
> blkcg association index across every blkcg and requires radix-tree
> preloading before creating a blkg while holding q->queue_lock.
> 
> Replace the radix tree and lookup hint with a request_queue-owned
> rhashtable keyed by the blkcg CSS ID. Cache the ID in each blkg; the blkg
> holds a CSS reference until after it leaves the hash, so the ID cannot be
> reused while it is hash-visible. The integer key also reduces hashing and
> comparison work relative to a pointer-sized key on 64-bit systems.
> 
> Keep entries until blkg_release() and provide blkg_lookup_any() for callers
> which need to find dying entries. blkg_lookup() filters offline entries so
> existing lookup semantics remain unchanged.
> 
> Keep q->blkg_list for ordered policy and scheduler walks. All current
> walkers are cgroupfs or sysfs slow paths, so they can move to rhashtable
> iteration once the q->queue_lock to q->blkcg_mutex conversion lands.
> Initialize and destroy the hash with request_queue, and remove the
> radix-tree preload paths which are no longer needed.
> 
> blkg_release() removes the hash entry only when the blkg was successfully
> inserted into q->blkg_list; the list_empty case covers allocation or
> creation failure before insertion.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>


