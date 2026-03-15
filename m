Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC35810854B4
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 00:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450A46B0088; Sat, 14 Mar 2026 20:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D44A6B0089; Sat, 14 Mar 2026 20:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E06A6B008A; Sat, 14 Mar 2026 20:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBEE6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:06:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99DE11D356
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:06:11 +0000 (UTC)
X-FDA: 84546354942.05.B9D022B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 032431C000B
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:06:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MY1AnAUx;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773533170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQe6bbx00XXUTJVp+HFB2+CNiEBK4CiUfk7v0T2fU5c=;
	b=hBeaKwecHUwWq0FB1v3DCVxHxK83COQTKAoHgbWRKBw9du++X/B1Er6WWkyvggvCY4Wnms
	FeeW4nL3lShP5ENU0QAxwEHxq4lxO/2NSARqA4G+V0qWY7u04fcwNlbSXh4M2ZPDYwevRx
	bFIA6w29ZKsm7gTl+6DJ0OQn0zQy+Xg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MY1AnAUx;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773533170; a=rsa-sha256;
	cv=none;
	b=d8hXvfsucTt1eLYR4btTCNgLURuMa0ENiMUUzozpT3IGLOSog3ZOdtzbGuPR4d8D60vyIS
	sBvo6qrDhuL/Op9YVtiebRNhykQsiuMUhgAG50lB72Yxk9ZeHM28p+6biznzLTpqDbtNEv
	kB97OHXrh4fZkxxUI6xwynmN1fYUkaw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D18BB41923;
	Sun, 15 Mar 2026 00:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7A9C116C6;
	Sun, 15 Mar 2026 00:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773533168;
	bh=GdqvUN+xl9wN0WxCFWEbxnpwXdl6FS4Z+Q/2gOKzgYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MY1AnAUxfwcQXbJahppa/QPFx5OTh/brWeAoHYP9rwTwng2qRv2gB9kMvjK74eLO1
	 ONC9/gFP/+fVkmffi70Fp6+v1duqh6n9na+awJ4WZvH0TRCtiB2Pni2/xgo4DhLKwX
	 eXz5ISXerrxMLy+fxHAl/DRSaYiocrFyqAdR9IduFyxhtNVbPUUCVRnBp6y6TmafKJ
	 S1S9pWh74towQZ9qeHlYIvVBI8EeRyJYzH694U4TPlGY1WZlLLxcP3Xc/wQxgVVNqT
	 O0P8zcrWdSggXxoYdFgVeNmPk7eD8R9CL45uFcAA+g3pofFyeLR4wSsWcOM3Mxl5q3
	 D3pgpF8xrytDQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	willy@infradead.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	richard.weiyang@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred split queue
Date: Sat, 14 Mar 2026 17:05:54 -0700
Message-ID: <20260315000555.76876-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260314154042.327ba957b1a8c10f64ae0169@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 032431C000B
X-Stat-Signature: hbrmgrqf6iwk4g6i577sxfjfu5xp6983
X-Rspam-User: 
X-HE-Tag: 1773533169-840724
X-HE-Meta: U2FsdGVkX1/+YDgtaZ2S3OdcavZZwzoO2blpXSnE2SlfoBiRUzXTnuyKdpbonB3RwH8gofFASK9DOtI15nI5dZL5XQhSw6yrNzHvmvN1oAqW7j8V0bLZyzeLyG9YkTZgt910SiVy4Fpw36Hf0LGjzB5c38884uCyTmXLX+lwqo9FNRYoNIHt62pXleNfdOtbil5KVC2Wkb7y67DrFLBcg3w6ubt6bkwpL4MO+/jtun4ZNwlqlz7kNblzPdr3l3W6Byr//YdUZ5zDxCJUgZtpy9HfuRG9KW7/n77m5lpFLrb12g8lXe7Nu8QQU3EA3XJoM/Wh2K3pMz4BYhlcUh9ooKRhAJWMHwykHSzZFFYanOXiOw4DRZVFPMvhDRUyzJswc4WXflUqh7TNelMK6Z+kpN8k9b5VW5lx6ZunamoiutXjlTHD5I5eNJWGa5QNYErnaqQlOJZihTvfz7Zj6+kqbRBDnWUa24sdjVIHhU6sDOXPN8XtbvOajc8UlJKBD2CnkppyP3PKuEWAT5Z1e1LBDZ0bSRoFZmI5tLzIrwyuIdPIQxXZZRVmfzTUKfYTM/olTboyiMh688ytqcYAGQZ+75t8XIocaywje5DwGZ+yXKASywNfwHeS65da0vNvIq1dK9C7Jd6DuhybKDzd/WYGjjZ3OVIFi8uYwHKv4N1wVbNmwQH4450SlNsOZMj4Osl9jEcl2MfX3XMRDwtn1GRMrpE+SshMSn58ecMIQN62Y2rVmvpi0JS0DZEtKzDVNKD92q2MM1xujECw7mJ5qEno0OoQCP98WAQ8gtF/H8PzbqRlcX5ZWXxiZWTh066yvnfM+3UHAVfhpp6f6RobXsdw6IG2qcXMP1h13ODnMpgtUTsF9fNvJkjAkaMSMc+M6EGVnsl+AAcEM4lB7q6k+glMLa3Rrs7UGMxXfSzfCrvx8pVXK1w+EuvtmpQTO/wXXllmSHE1DxsKwSUe46nzuF/
 Hbdll62U
 WX6uVFvbcU1gsi4/T7n4T+du6Xjm1+Q52DuSJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 14 Mar 2026 15:40:42 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Mar 2026 13:40:29 +0300 Usama Arif <usama.arif@linux.dev> wrote:
> 
> > 
> > 
> > On 13/03/2026 03:52, Andrew Morton wrote:
> > > On Thu, 12 Mar 2026 17:16:30 -0700 SeongJae Park <sj@kernel.org> wrote:
> > > 
> > >>> By the time migrate_folio_move() runs, partially mapped folios without a
> > >>> pin have already been split by migrate_pages_batch().  So only two cases
> > >>> remain on the deferred list at this point:
> > >>>   1. Partially mapped folios with a pin (split failed).
> > >>>   2. Fully mapped but potentially underused folios.
> > >>> The recorded partially_mapped state is forwarded to deferred_split_folio()
> > >>> so that the destination folio is correctly re-queued in both cases.
> > >>>
> > >>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> > >>> Fixes: dafff3f4c850 ("mm: split underused THPs")
> > >>
> > >> Seems the commit is merged in 6.12.  And I assume the user impact on
> > >> THP-shrinker enabled systems is visible.  If so, should we Cc stable@ ?
> > > 
> > > I think the user impact should be visible to backport, but the
> > > changelog is elusive on details?
> > > 
> > 
> > 
> > The original patches added THPs to deferred_list at fault/collapse, they
> > got removed but not added back to the list after migration.
> > This patch adds them to the deferred_list on migration. The user would
> > not expect the THPs to get removed from deferred_list on migration, so
> > this fixes user expectations.
> 
> Maybe users just won't notice?

My guess of the user-visible consequence was like following.  Because THPs are
removed from the deferred_list, THP shinker cannot split the underutilized THPs
in time.  As a result, users will show less free memory than before.  I believe
I might be wrong and Usama can correct me in the case.


Thanks,
SJ

[...]

