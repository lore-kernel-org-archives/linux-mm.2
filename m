Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1ED6606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BgTIjVx8
Received: by kanga.kvack.org (Postfix)
	id AEA3B6B00EF; Mon,  2 Nov 2026 21:33:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A6B6B05B1; Mon,  2 Nov 2026 21:33:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9625D6B05B2; Mon,  2 Nov 2026 21:33:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 703526B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:33:29 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D18D2C02E7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:33:28 +0000 (UTC)
X-FDA: 85392236496.19.B6DC1C9
Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9414140002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:33:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BgTIjVx8;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793673207;
	b=0SyMY3xFRgMf40Ulhnn4z9RH1MeQjwjCUCUu4jeA7jyBEEY0j2Ei3iv8sMi87XYLire9Bd
	ssHqd/j+KI9O6rGok4dNvGOEEslR3x897Dc4ZpGTcaDtGkgZ/PrazEO2+DbsK5pbMTsUxX
	G1UE4zZoPJ7wcTte1nIoOG/z42swBAk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793673207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plPOmmg8Wbucg4dOntyZK89XdF19GIkTemSi8VnEEAM=;
	b=ScHoh3YjfqRczn7f+8Y9ZJEFDW2hf33ZWDOcD70z3NNwP1JRyLpqq5QjL08p1MOybOw6Bz
	mwNoZm8xwmfZW6TMHpwsDMlxM94RRu6Pve3PaR1ZEiGBE95xrzJMlhH/nKPIhxipXf5DD8
	+6UfcSTWyTvfvZc2nEwDAB29DuBM9Ck=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BgTIjVx8;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QEpd6a+5vyb7YKmH2HfXuDiiboBz4CjeIOL7fouBhLE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793673205; v=1; x=1794278005;
 b=BgTIjVx8nAsBtP3F1/GUXtMqw3pw4OJEPGpQ++uutFfQds3NbRcIfmcp3GNAGaLK7RPpjY/S
 yw/Uj5HTzpBk3eyf5tM9Jsqi8rj63sDupbOUjOGiN5/9gjgHzyT+vi9Zyr+9DoBdCp16aZJbRus
 vipK+BIW9Sgzd5Lh3Bd6yy9Q=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 09cae95fccecce83;
	Tue, 03 Nov 2026 02:33:24 +0000
X-Mizu-Trace-ID: 09cae95fccecce83
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 10:33:19 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>, kasong@tencent.com
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, muchun.song@linux.dev,
	ridong.chen@linux.dev, sj@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	ljs@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, baolin.wang@linux.alibaba.com,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, kees@kernel.org,
	peterz@infradead.org, jannh@google.com, pfalcato@suse.de,
	hughd@google.com, pasha.tatashin@soleen.com, pratyush@kernel.org,
	willy@infradead.org, jack@suse.cz, ziy@nvidia.com, riel@surriel.com,
	harry@kernel.org, apopple@nvidia.com, nico.pache@linux.dev,
	ryan.roberts@arm.com, dev.jain@arm.com, usama.arif@linux.dev,
	kas@kernel.org, matthew.brost@intel.com, jhubbard@nvidia.com,
	peterx@redhat.com, will@kernel.org, aneesh.kumar@kernel.org,
	npiggin@gmail.com, osalvador@suse.de, minchan@kernel.org,
	xu.xin@linux.dev, chengming.zhou@linux.dev, chrisl@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, youngjun.park@lge.com,
	gourry@gourry.net, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	ying.huang@linux.alibaba.com, jgg@ziepe.ca, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, josef@toxicpanda.com,
	stable@vger.kernel.org, usama.anjum@arm.com
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
Message-ID: <aulH7zeGrjIvF8Hs@fedora>
References: <6FACF8FF-F943-45C8-BDFD-3AFB5C060E0A@linux.dev>
 <20261031055838.60138-1-lance.yang@linux.dev>
 <a704d458-ad60-43bf-a0ce-3b128b218d88@kernel.org>
 <CAGsJ_4wjGjDoFPz3qWHqW8WTv31AkR_zrY14ON0dLbTZNsohWQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wjGjDoFPz3qWHqW8WTv31AkR_zrY14ON0dLbTZNsohWQ@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: a11qb1itne4e4mbzaw7oep9k88ki3tug
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9414140002
X-HE-Tag: 1793673206-885502
X-HE-Meta: U2FsdGVkX1+Dbj7t7v+AK8m3/L0DeIHVBntYSQYCeDP9DlQGXqahblRsljQzPd+znrgWVwXAGi4bPXYe5ngTnyFXE6S7Qr3ztky/PoxdQSLSK8dlrV+rgPTo0lpCScTXzssW/ORvDnswMrXqxYVw1UvBc7Wmw+vpWLuO1U5eLTyBFoPh6BgmJ3rxt+CjHdhNoPMjcOncBUmrXQeJ0gGECDIRfDRT3VPFbp/RoamRsOk25o2/RjYJ83ceDO83MSmFOXqB2xjcDG1BYaeV9M2CAgFI/Ucg0Umm6jSw5diFy72Ljo5XwvSOKCC4tdiTDPA5FDexACqMGddUQg2w9KmDuT6VzETizuS94XUGhx2vvi4cZCDIqTt8WtGXjlMuSWq/R7DEIyWuPoHGwI5o+1ZCzqvR2x0qiiFf3LhUYf4kg3vk/7P6qijtabDMGhBsG4dI+gMiriCOUmioAbTZyLx+LvJ/rrK8Plg1f4oGFkEqAbqpAl4vg7qzHaNwDbG61j/0aN0hYcx8//yZow/xYNS6WYxZF4W9k9dKxYm7AYk78hEvdvD4rrFsL16SfqmXGsBNhXkHEN8dT/viekBbHeNwPV9RRWEDQzIHd2oJN0Taz50wXtdW1ZRSllAUXHHGQLRv4bw70BnPFsUtj3HtA1u+AluREztm69a3JoXqIYr9kAoF2xfJKMKJ2PReA0mVKAC0qJBqQMSqELajGvtsD1FkmdRHSiNDrsiNADqRWJ+fgOTDWGFd9RwFB6rkt3/K/P9W81jHGMawU7nLGPLkBoNVXbE6eRmh8h4/LRHjIewJ6Hy9mn+srDAoZmZOcpcTdL9sAx0cVdxsZKrws2k+XOjqUonLblCTi5+4BdBMmRm8v+3KT4oVrJQdignMZvmfazYFDzCS3GVRskyUW6JFSCYa4pCAGneBjMifHIkoBBNTU/Qp+Ydd1HRLoAFurGYdYCz63Vn1OMTMFvvCHVwODtX
 vHzh8cxV
 dmg4zQXcawizzLHtIqZAcWY9SE9dXWV6J0zr2mRLCvTDUQo+qRul6M2PNXml3v+OEm+wre4meMMbM+CSG3/d/Ucff0SG1E6XAP7aMFNu8EvdJygb509p2JG7Ngqdo5nfSue2f2/TOdXkbIKeoX5vfFfHaVGiaOUXLXk6smQeTtnEkKUVcHVGT1l4jv+Z3HxfUqLGO3Xmf+JcP1RJgit8suz5KUbGcWGruwyTITkxozOC94s0hD4vISt8Fa9fs0Hg4BkXP61A9IRBLs7osojPnrRKAZY6iiRiv3hqKNCfZJBU2IkVXAoTuHcRbr57mlo2iIIptMRQl7RF5yVSUaqSV1ARbhDoQzVDCnUE9FAJYahcx0RLjvVfLnt2P1GN3i0gxuARqbCBIrZS1hhpw7SL09R83RRaCSI+6eaAMOiITFhn+BMTkb3ZsKE0ZPjOmZzKEffX5xBwSkK+WVb8TB0G2SyjGJMv4dJXSuD2I/tD81w6YkLhS1OL6FIop9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/03/26 at 04:11am, Barry Song wrote:
> On Sat, Oct 31, 2026 at 5:42 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/31/26 06:58, Lance Yang wrote:
> > >
> > > On Sat, Oct 31, 2026 at 09:46:37AM +0800, Muchun Song wrote:
> > >>
> > >>
> > >>>
> > >>>
> > >>>
> > >>> Agreed. FWIW, I think Barry Song and Kairui Song would be good candidates
> > >>> for the maintainer role.
> > >>
> > >> +1
> > >>
> > >> It would be great if they could take this over.
> > >
> > > +1 from me too ;)
> > >
> > > They both have been really active on MGLRU and doing great work for quite
> > > a while. No doubt they'll continue to do so :D
> >
> > Fully agreed, we really need some people familiar with this code to help
> > maintain it, and Kairu and Barry have most experience on this.

Agree. Kairui and Barry have done so much to review and contribute
patches to MGLRU. The nomination is well deserved.

> 
> Thanks to Ridong, Muchun, Lance, and David for all the
> kind words. Your encouragement is truly inspiring!
> 
> >
> > Just a note that I also don't want to pressure into such a role (which comes
> > with responsibility).
> 
> It would be a great pleasure to work for the MGLRU
> community.
> 
> Over the past few months, we've seen many active
> contributors join the MGLRU effort. It feels like MGLRU
> has never been this popular. I'm really glad to see the
> community growing.
> 
> I may have missed someone, but besides Kairui and me, I'd
> like to mention Baoquan, Baolin, Hui Zhu, Ridong, Kunwu,
> Maxim, T.J., Siddharth, Xiang Liu, Bingfang Guo, Shakeel,
> Zicheng, and many others.

Thanks for the recognition, Barry. MGLRU has always been on my to-do
list, I will come back to catch up to review and post queued MGLRU
patches after my xswap patches are posted.

> 
> It's great to see so many people contributing to MGLRU!
> 
> Best,
> Barry

