Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C056EC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90966B009F; Thu, 20 Aug 2026 05:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68CD6B00A0; Thu, 20 Aug 2026 05:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D6E6B00A1; Thu, 20 Aug 2026 05:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2DA6B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:59:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 272A6A01DB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:59:14 +0000 (UTC)
X-FDA: 85121199828.23.C2416B6
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CDC01C0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:59:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vqfL6IYG;
	spf=pass (imf18.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787219952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HK4TsdXsgwo/6J3xTGj7SDTw+psf9lHqOngnihbBBqs=;
	b=acLW38bXZ16NbpD3bKNfy+4ukpohb8qrwT4afAuL0jUpRmXrG6zC1YLBbhuilzOGGEVUIc
	X1MQ7wmmA6C0Y+0IBYeStYvbCJlKVD79cEolCHdaLPNN36Y4Cqf6XRrxqzBMKHn/ceoiqO
	lBhnJTaadfgwA4kzgvtA4kBEy6TvYM0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vqfL6IYG;
	spf=pass (imf18.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787219952;
	b=NdIQM8500SxXUyRBOchVcGdKxFY1Y41Q6IEMS5gre42E3l8Cutou3yJnXmww8llmG5pEzH
	TdXBe9SMlRABcRWJ+O/osSROP7yx8DqiBmxqJDrXnvJ0MB2HV7IiiuAW0ogGIBSOTdHH+h
	bVyjAh9NQJW9Esj54FkMRSABgv8Gwg8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ibyIE9gKf2iOY1+mVf6oD4UPNPJ9RqEZuDFV5F2gXBk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787219950; v=1; x=1787824750;
 b=vqfL6IYG5bmPmIHZ93WmL/Wq/O1RN2hPCoTZ0Zdnyb3zDniktYfWdkZSzBh82ifiQFP19I5v
 zH8xlDuZPucwGWdi/Qd/VZsLQ2F6NZXLZmRhtyOKSNBIIGssxHrH1yYNCUEH1gBrIoNWJuqGyYU
 j/ddxJNgNFD1Mo3If6Orz2xg=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.110.173] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e22ed27fc468e85d;
	Thu, 20 Aug 2026 09:59:10 +0000
X-Mizu-Trace-ID: e22ed27fc468e85d
X-Migadu-Flow: FLOW_OUT
Message-ID: <7b2733a4-71d2-43bb-b319-1ca8defba17e@linux.dev>
Date: Thu, 20 Aug 2026 17:58:58 +0800
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
Subject: Re: [RFC PATCH v3 3/3] blk-cgroup: move async bio punt state to blkcg
To: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
References: <20260818070641.756747-1-yukuai@kernel.org>
 <20260818070641.756747-4-yukuai@kernel.org>
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260818070641.756747-4-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zhnn6p85dr7sbxkyjfjhowahhiqx4jn6
X-Rspamd-Queue-Id: 2CDC01C0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787219951-420451
X-HE-Meta: U2FsdGVkX1/RStNSP3dBynocHmi//yr2biiolO+Nw/Qq2d2Nu6D5v98YshRi1FubMNkwEmIYbM+BwWQxz8bScFMlw6tRlf+/R8au3PDtHzm46MVMtwOCWvydwjOpnputmvKon9bxRrvJFB4c2qb01RvoGO7h8R675OxCoxIRt9Pw2fQ9SOtfDKKtFm2LnBIcdc78B0GEPm7iOQNmVFvhiwEDxFHfuWiwZMKon51IDIwViB9m5aoMsmoJugZtjrghGnBvbneAxAgThLxzIVDfHVJXXIj8Qs3uizvEKAzHT7JydE2UFqIjNdoiFYZgmhy49BE6vFx6R1a9ZEWk3E5LPaM+YMYoBVmWTg0tATrjPlvxa7lJVwivFWb7D6dV0sWeCAmKWH+fHyg6L25ISXuny33B8vtGbGac4pGnflM4On43EPdb/7ZJb6w0hxeNyUleUL2/l3QnDiH6TKU1b24x+y18/PJfNDNDk5BWvHRzvMm7x5pntorqbrOYY+98fNGsuJ+aGxE3nhqg/1R+ByjZKu2VvhV+E0yxIlOm7952UFXxSTrJoF6IuYmvdGo3RApyywI3NKc5ob4B2lfgnuypH0KQpkgDu9WLmdSv4YRbfPovTCOH4jbG1wvIYP61AtYZPZnY6HGMSIEXclVO7TsSKQV/8SkXU4DOeNowiZXROvsb+kS/0jFub2U9z92ORvAd56evAMLmJcZq1eH7a8ktlmjYMOsEFfwQOB4Wn0pmXjyvWKrOFVaqGklSCHQL26SIM9tcCuja0yFjS2sDe4sPDPFw7j5BciYBWxzonEVLOXNmvfG/nosQtumwQ1lYc+jE8+0faVEuDfVEpjtCkeCXjkLd+TNokTeZosxOnZKZvyfd1kR437mEqTyIzFpuPKlRt4xLkV35Y7H8FTCyhDXMUgJXWB5en6nD8kD2+Ae5vCd51oqBm4ub1ZDKnYnCdk1IfVr7UChNqnqB38r7YO+
 Tmjl1MSa
 A2C37O6NLk/9izPch+wfjosAW3nj+S1wHEcFN0olk49J2ZsRZ+fJyMMgtxs+LRYWu385kGsCDb7nVrmwP9w3JcyvtnokMobyRArZ32nlb/siTSNvEMF3RSOCu+xvYhehq1b5JW1MwYW3OE9AyZhSilCTQtdSTBx3h4EyOLbetqu5/sgqEU8Zx22oZ+CXj/x6Avw41XduhTeNGbMaXrOKMX9Qqi2GIndxeCzepyumoz6akYXqSFprVXHGgcGx9owe3CkTwYVF7c0gM54oW3i3yVDoA/9aVZyN87xA8sCYmREe8LE6/ku4FC6s8Eqk01lWKP0z6R2E1eWDudX7txM8+N84qUsT3WoAmKwZ4c7Dt+SPrCi8mZepz0gaQr/p6G/WUTDyC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/18 15:06, Yu Kuai 写道:
> blkcg_punt_bio_submit() currently queues punted bios on blkg->async_bios,
> so it has to call bio_blkg() to find or create a queue-local blkg.  Bios
> now carry and pin the blkcg css, so punted bio lifetime no longer needs to
> be anchored by a blkg.
> 
> Keeping the punt state in blkg can instantiate a blkg even when no blkcg
> policy is enabled, just to bounce submission from a shared kthread.  Move
> async_bio_lock, async_bios and async_bio_work to struct blkcg, and queue
> punted bios on bio_blkcg() for non-root cgroups.  Root or unassociated bios
> are submitted directly.
> 
> This preserves the priority-inversion avoidance while preventing
> blkcg_punt_bio_submit() from creating blkgs that are not needed by any
> policy.

Reviewed-by: Tao Cui <cuitao@kylinos.cn>

