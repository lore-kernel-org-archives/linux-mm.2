Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55776CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 07:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784026B00B8; Mon, 25 Aug 2025 03:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734D16B00B9; Mon, 25 Aug 2025 03:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AA16B00BA; Mon, 25 Aug 2025 03:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2176B00B8
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:05:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CEA78140145
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:05:36 +0000 (UTC)
X-FDA: 83814394272.17.C453A7A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf27.hostedemail.com (Postfix) with ESMTP id 95E3940015
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:05:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756105533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=TZXXifyDr9BAp7QsmFc5eooWIMVzHQn76/bQkaRcJcM=;
	b=wqdOzgM/c8edq25cFW5nBDd98nTGBFOLnOzy99vsRqWamCQm1Mvbztqjyhhg9z7YIsQpys
	/NH8dVxXRFIDSPnjVdMkhriqYHznuzFiszeauySWxEXHX4LApFLU8Kwbhu5PmRs2CtmEkQ
	Tk5VmfqweGGHKOYY7S4+MyFxMYl/dBM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756105533; a=rsa-sha256;
	cv=none;
	b=NrJBXXp4Pcmn4Vq6BurpGJh5wjK/bAaijEjSL5cQMjFjoHoaOW2qXydAGCV2f9pNVGPU/D
	kwDba6xmR4pS0OQdqKuoQU49hDy0ptuuVqVzChFFhr5TpGXz4AsI0tP4yjEB1uSKSg1Fiu
	Ea+wR4RNSz42vn5KnCzhKYI/0mMF4gE=
X-UUID: e081920c818111f0b29709d653e92f7d-20250825
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:7d8eca56-ff57-4f03-8ded-6c0353a63a2f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.45,REQID:7d8eca56-ff57-4f03-8ded-6c0353a63a2f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6493067,CLOUDID:9ff914008b892f7ca5abcadc87568ea8,BulkI
	D:250818030025RUDYOSC2,BulkQuantity:5,Recheck:0,SF:17|19|24|44|66|78|80|83
	|102|841|850,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bul
	k:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,
	TF_CID_SPAM_ULS
X-UUID: e081920c818111f0b29709d653e92f7d-20250825
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1051094516; Mon, 25 Aug 2025 15:05:26 +0800
From: liuqiqi@kylinos.cn
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm:fix duplicate accounting of free pages in should_reclaim_retry()
Date: Mon, 25 Aug 2025 15:05:05 +0800
Message-Id: <20250825070505.407367-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 95E3940015
X-Stat-Signature: dkn43er741awr65q3s3tai9u9ii5k5ok
X-Rspam-User: 
X-HE-Tag: 1756105532-69611
X-HE-Meta: U2FsdGVkX1+BCQni8e4gBeifPSCfIwXmWhovqKMGbY+H9SLn+chMYabDIKSD8Nt0Q2N4JxXtKjfaoRWz2lufb0QJqL8MTtVRTXk/KnMgMoJkalTZDmmUMm8/maTe1WsoUjTqhZb5acC2Mm+nPvVuZAwbWKDeRFS9hFolqciHnK/MMwO8bGXdKMX3I5DKZQCI50VgP4ZRYVmsnVLykY7zoswJ5I2FpoTKup3Hqg+LXzrXTz3KQ807Rw6YmAMhdvogzv0+GBDX81XEwjBF1MFCVYxyWvqYi0K4w4SaPXj97EmKqvNUYbJgvPl5tFppM6qAe0JuKexfowvON8TZID8h12zYvYw9Zsw4EkDzPSFijLBDzIAQWyg+/gk8Mx75yEWpuaOh+n7j8/7JepY3p88CqWtjyi3ldJEHE3kX0yEDU0VJQlIJDmB4COU2DZLz5y1Jx+A1sZbAMoXtB/8peHduWvlw/sf11ABdtTOieeXFo6XAPKjXm0Fo6A+L0jDPU5O7EZTdyUiOYwIkhcpVFEnxkyq07iS9D5fRVPz9vOAKflBCS5704NP1XhA8DDOOtc7Gf2Opteq3/YWIEUDWr8eM3fPo+GeEdeoezbMKrr78Utjg5wNgY0UfUuvd2UUb81iTvg+bAbW0VaARNon+gmyQyVfKC6LXKpdtSkq2WN73lQWcYtQ77BzSWhAz1q1rk5xziidpkqU1Q0DSBjJIxYwqswzF1NJ3/dEsgVcIDraDjU9Y1xnwUQiQ7a9JRVaxfdNI7ri89tyOCBzhIlezWKwqWdYJXPh+b89bw9MfF1byvplwnwQDYv1Fhq0id+iCtALUmb84VF7FSTMwUN18STDOrRlM2Sgd69v4EldZ+2FT95cpY2h1RgZt5qvnVmY0MgxWbSdTcwLdgKMH45l1CKvkKLDtpWev0HWjxAzfq89RnAua99g1SnSRBYfoc4sVm5t00zdBsEVOAG5yVEIFFSt
 4LLX6oi5
 byO41jlzVTW3ABkn8yzvfzqwrLkpBu5sRXj2QqrNzwdn+MzoIgJJTHqjopcpD9evV7U+ZiQB2XiP1na4Hef52xKfkUGf4kxz6No5ZZSB5hFq0q1Oc324w8qIeKO5fLZwZD0Vuuwc450on3i3gWUjLPy5iQBPdZfRTBWKu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Duplicate accounting of free pages in should_reclaim_retry() effects:
The number of retry in the __alloc_pages_slowpath() function has increased.
The execution time of the kswapd process has increased.

static inline struct page * 
__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
                                                struct alloc_context *ac)
{
	......
retry:
	/*
	 * Deal with possible cpuset update races or zonelist updates to avoid
	 * infinite retries.
	 */
	......
        if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
                                 did_some_progress > 0, &no_progress_loops))
                goto retry;

The test program: continuously allocates 1k-sized memory through kmalloc(); 
counts the number of retry and the execution time of the kswapd process;
the test results also confirm this.

> Thanks. Does this have any significant runtime effects?

> In the zone_reclaimable_pages() function, if the page counts for
> NR_ZONE_INACTIVE_FILE, NR_ZONE_ACTIVE_FILE, NR_ZONE_INACTIVE_ANON,
> and NR_ZONE_ACTIVE_ANON are all zero,
> the function returns the number of free pages as the result.
>
> In this case, when should_reclaim_retry() calculates reclaimable pages,
> it will inadvertently double-count the free pages in its accounting.
>
> static inline bool
> should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>                      struct alloc_context *ac, int alloc_flags,
>                      bool did_some_progress, int *no_progress_loops)
> {
>         ...
>                 available = reclaimable = zone_reclaimable_pages(zone);
>                 available += zone_page_state_snapshot(zone, NR_FREE_PAGES);

https://lore.kernel.org/all/20250817120016.8dcc091c5b7114d6993a29ae@linux-foundation.org/

---
Best Regards

