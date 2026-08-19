Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A539DC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB23C6B009B; Wed, 19 Aug 2026 05:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C446B009D; Wed, 19 Aug 2026 05:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9041A6B009E; Wed, 19 Aug 2026 05:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6698A6B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:14:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F01E4804A0
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:14:20 +0000 (UTC)
X-FDA: 85117457880.10.76CF3F8
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2905880002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:14:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787130859;
	b=cDlgSN6WLcTJlXhOVHhAyJADSWPsl9Z5+t1RV/l0EG/nXcIQEnQ32fBhJ+vjxyDvW5P9Vl
	VVW4RRdz4TMQY13DDPJ8d5usKwjqd0+rN+eADL5HwK18v4pgp9ZSfx0v7j1SjsZqOQR4a/
	tNH9Aq8N1N672MHxBYS4i39epF/rKDA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787130859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=vikVYQ/NSLdkHcigun4PvQ4mNMtNVDsmOzMqtAM5NoHOtKcZoyPKiBRMk48mgBPTK55I52
	Hph9qsJ/WJZ2asHFnp57JGjEGv55TT9dKq0ofl5CP2QYlWYVxqMrLp0LtQE4d0Fk6T7jbB
	cigVEN+k1OIM6vshMQZXZkCvNiENCEM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id EAC3068C7B; Wed, 19 Aug 2026 11:14:13 +0200 (CEST)
Date: Wed, 19 Aug 2026 11:14:13 +0200
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
Subject: Re: [RFC PATCH v3 1/3] blk-cgroup: use a request_queue rhashtable
 for blkg lookup
Message-ID: <20260819091413.GB10298@lst.de>
References: <20260818070641.756747-1-yukuai@kernel.org> <20260818070641.756747-2-yukuai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818070641.756747-2-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2905880002
X-Stat-Signature: twogp5ohftci1bsa8q7nzaf9tgg4amu4
X-HE-Tag: 1787130859-227573
X-HE-Meta: U2FsdGVkX1+oPODG8FhrfWnha+WQKweRwLfmDl5IVYg8A7G7Hb3//1/2Ccrf3BzA/7KbWRC55frg5hcIxSPrU1QmOFFUfMNfhwI19vleJ1yUfY/xM9aGwiMgbKQIpuVHphFUwDUlvYS4xImJPPBhSNflTTOWUb2l0A4AcN/iEuLfiZkTyEacLEmgKEHNsSj8FM7iCrsUeQXpBHorqdTXSusLCo7LVsE+4M85HoPpGJ1W2j33Gnuuc5+cFrd1le/rt2ldo8kypViKUvf98q7NrEoxRPKvc6SkzqOPOjGBTggPP4NpkqnEzbtlsDocs6ppCI/4s/x4Ihzws8Sqyv9Q6B5rnY4I2CgH8fwWP7Gq3ie1zQ9yj8sjIghryBJgtbGnK0LshA22Y9KO/04Y24qXQb/2KtmffKbwAo24+6Sk7zvj+C2zqSFMzINAh+0xjYju3jXg4uBgMn6nAU1Til3je1IQKg43K3Hf1iAZ8CzaFuuLzVAtmsCMEO55m7ibp6rYfRuc2ewrsM6ohfBTvp7Zg9uMVUl8yUaFCMhCD7bcwHWv3gdcwgzg/5sD/CkP62eXE77U3C9BhqtknEfE5CMcltEKVh+mtvk3OXvsdooC8UpfEf3STPcE45S0D5xVjwQdCPc3fOkEGLtGPeABEHnNrnCTDdkJvl5UwvW2ObeneK6o1vVcHXs228+pVGquFL2HlNGVfICA9qVei5SEjChzUZ+FEOI6YQV5sz0eOBCjTXrM8PiFF7elGaCztXcLnUrgcABuqwCQm0IS6nKmWifhBOud7RR6hEPcJYtrBZTEMGsYwsGGUwCrEFvoGlA1UsITOF1LjzT4n+Mdw0wh6UOvSiaS4IPsvYmLtXvyHJ7+sopHNeBTEEdeSd8+76xYpn2pyTk0PSvsbd5sZFs2Xra1GJrqMPkcpyywWNJjC2FxzlpuS2AoAJQCMRPtt9hhdHRaUoM8ntZrsF5ycf7tlgr
 jot9TsCd
 fInHHPawQNe/cnMXWhx7qkyTKwt53lHLchDoC5TvtiFSD2R4DA46HZZX0AdDcmEo9QCS7FaiyugaYzN01z0Y09i7+ns58j39iUqYlxJDleAk5rY0V2rP4kC9aXYn1BAc4gW3RoJXEkch/Kmr2pN6D8u05i8covtv1o5/iZKksX60PjI1bQij1EkYuz4BxaGWHNnlFzc2bI5gxlNQ2vwKNx0fjFooSvTaR/2kK2ePXGRuVBQq7yFklUiMCyojQsc7e7roFl+wDa0ePX/mxOkl+8NK8aIYhv6RjOVuL5rGzU6sZhMQTSeGGozAxuLk3UZQZzdFXWzBl0SlMf+w94eMD4yLuTQEtSyNHIdEoIXJiG0W7he6ZxRXYAFYFUhz+2UbSvkCmgJ/1agGyy8efhaSUufJrAHd+l6fQIxZjyvm5b/1vi9sGSe/ZmJQpnP/xpuzD2m85
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


