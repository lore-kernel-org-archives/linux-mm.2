Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82182CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3DE68E000C; Tue, 23 Sep 2025 04:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EAC58E0001; Tue, 23 Sep 2025 04:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2668E000C; Tue, 23 Sep 2025 04:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F05A8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:08:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA2EBC08E2
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:08:41 +0000 (UTC)
X-FDA: 83919788442.28.256BE6D
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id 426CD8000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:08:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=NjWVkt4f;
	spf=pass (imf30.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758614920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eezc9pSQCQApzALMoVtwFT9+N+ozo1hRehESSYFDA9k=;
	b=HmAYU65lRwpAZECFcNCSMdH7cPLPJNA4sOdqR1iIKc3YVvlZrvLU4pafVn5kyjMkSboNhB
	/6ZybS6G1/nrKeIjapRO8SKQx5z/3Bf76uCscGiPbHAjnQY45cPC1arrIDPL7YNLRevxoN
	kmGuLGl83l8vVHvmdXW5tdob6M0hMx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758614920; a=rsa-sha256;
	cv=none;
	b=stIUVBm3QdPoc2/R2j/uphUUbw0fwrmeiUPaUehbKtMpsK5wSFteTcwthb0HsvXTwloFUi
	TsjGugLCE9Ozz44AesEjty2QZkHNM/kQnc5Wt0f6++fPs4GB/PhwPcIFJW96dppuxVAZ6H
	XVXtECC0uFq3CmX0fvJqEtUpVcWn9ec=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=NjWVkt4f;
	spf=pass (imf30.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=eezc9pSQCQApzALMoVtwFT9+N+ozo1hRehESSYFDA9k=;
	b=NjWVkt4fzZ4WqP1pSybS0D7QFEM3e16cxDcVsWEqa8JXYcWCKXFdCa9iGVklM16p/qI+AMoc0
	C1rksFf4KAwZZ9dEkN242V/mmrdpk2Q9lXQQzdZEI7ODnapuo7A7oa3ldPf5tNBADqy4hSkriH7
	Yj6JVRtgK5Yxfd7GtjiXDc0=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cWCC92JSrzYlvnf;
	Tue, 23 Sep 2025 16:03:01 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Sep
 2025 16:03:23 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Sep
 2025 16:03:23 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <yuanchu@google.com>
CC: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>,
	<apopple@nvidia.com>, <axboe@kernel.dk>, <axelrasmussen@google.com>,
	<baohua@kernel.org>, <baolin.wang@linux.alibaba.com>, <byungchul@sk.com>,
	<david@redhat.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<harry.yoo@oracle.com>, <jackmanb@google.com>, <jaewon31.kim@samsung.com>,
	<jiahao1@lixiang.com>, <johannes.thumshirn@wdc.com>,
	<joshua.hahnjy@gmail.com>, <kanchana.p.sridhar@intel.com>, <kas@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-trace-kernel@vger.kernel.org>,
	<liulei.rjpt@vivo.com>, <lorenzo.stoakes@oracle.com>,
	<mathieu.desnoyers@efficios.com>, <matthew.brost@intel.com>,
	<mhiramat@kernel.org>, <mhocko@suse.com>, <mingo@kernel.org>,
	<npache@redhat.com>, <nphamcs@gmail.com>, <peterz@infradead.org>,
	<pmladek@suse.com>, <rakie.kim@sk.com>, <rostedt@goodmis.org>,
	<rppt@kernel.org>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<usamaarif642@gmail.com>, <vbabka@suse.cz>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<yosry.ahmed@linux.dev>, <yu.c.chen@intel.com>, <yuzhao@google.com>,
	<zhengqi.arch@bytedance.com>, <ziy@nvidia.com>
Subject: Re: [RFC PATCH v0] mm/vmscan: Add readahead LRU to improve readahead file page reclamation efficiency
Date: Tue, 23 Sep 2025 16:03:19 +0800
Message-ID: <20250923080319.28520-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAJj2-QHy3rTSPpE5uyu4gW9dWe1E5Q28P_N-VX2Uo+xBFauxdw@mail.gmail.com>
References: <CAJj2-QHy3rTSPpE5uyu4gW9dWe1E5Q28P_N-VX2Uo+xBFauxdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 426CD8000C
X-Stat-Signature: qqnqqwr1d5xzc19h3crxfk9jkffgw7xk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758614918-994088
X-HE-Meta: U2FsdGVkX1/YnR5yguAcV+F7XUh7W3C4T6lMow3/KSdoj4vx2VZK12BiHqiq4FNsqNdEvw12ELwUf/pXCTDjcJ2RpCD3Wj1T1zSuUyouNb8sPnt5aBvP/aIbrXargTrkLDW2QKrGJLB6JfLbyomOrLaipYIFd5qInXZzr9nGcoktoTsSihVtycI7JqpbHU3uCznfLci2b7jTRl8C9SR7arUb6ECDqHdWySWU4gOuHxWH1PdnWd1uXbOLYNhqUUf4n2QnLv9uBckClFPk0FiK2CI74fYokRcaY2wuzr5r0hpyj9Tl+X1vhFjligEvFXIv2GDMjHnhzhOj3qt2FScyIICJ/yPD96mD3l/iRVX9dtnP57gMq969qmzdV9SZdTEVJKnvJkebRAbbdP6jYA7W6Ao2WavyiHmzDOPMkgyEXZuHrdnv49441DsGJs831aEzeqWKA7/Iv7dID55yxCaimnPBa6yEQT6KvbXQTK1rpjp1ouzD+OBTtUz1Kbc18+cw+o0Bdbi8KSaTUNNdEtDUdR6dL+ZNoTHXnxuCDOaje3Qr9rziVDgaXepuDXGH3bAU7i5DnFyX5tcwuBCiyHa10PoEb91B7iTRPcodcPnEg7j85FGK24t95kAoZDEWNKjD1GiEFi4MextBMjzV0SYx26TkhKq7MvdT9IYc/RZGlIEOa3H60r9oMjq/jRkl5k4elfKAUACNMan8oNafcOiOEV77W85+W0Vf6jMRXpCQvtbgvspCj0wZVQfrxhEgbEpSNstzVs5QQzTMKfn4klsEuQ7DrxrqPoRaa64pqZZpme5LWHGzGhUaUEqz5Lh8GsH2bCbBOlghe3LP8k3Ds2GVf0s3j4IP7noev7PF3UGm17pt1arziIDeXTvWHJtNnwK/mVrtxendktHLxQfjp41VOj0JMBFEu816LJjhTeWKbnHJ1LvwaUppR4YDrKAAG0c303V5vMz3CudgN+3Rla4
 JsDC9+eq
 1Xz4KJ4x9c2HvfNcc1u2nC9kBl4M0vkaq2p+mIHKCewPx8VDQFCSp4jK42DvrXR3+fa4/26QEpSX4VSvjD/JvZsITm2hKBHRA0NITvqFpDDEJ8DfgScAEYr9Kr5ZIBFcBVeAVux1qQjHMpm/ImamSgrjgOwKdi29BuwgsyGDsyRN0MbGIc/4420EAzz2rZHOX2kWEPQ5RNYpXoSie1CjcItxcuefnUlAyAbvAzW3Guc30A4zWOgmqnZ5c6Utu8Ux7uGIo61kwxdqjnQD5n7LfP4FoEaGE0MJ1EW3MJNwTfbIA9D7qZGxy/qBF8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 1. Problem Background
> In Android systems, a significant challenge arises during application 
> startup when a large number of private application files are read.
> Approximately 90% of these file pages are loaded into memory via readahead.
> However, about 85% of these pre-read pages are reclaimed without ever being
> accessed, which means only around 15% of the pre-read pages are effectively
> utilized. This results in wasted memory, as unaccessed file pages consume
> valuable memory space, leading to memory thrashing and unnecessary I/O 
> reads.
>  
> 2. Solution Proposal
> Introduce a Readahead LRU to track pages brought in via readahead. During
> memory reclamation, prioritize scanning this LRU to reclaim pages that
> have not been accessed recently. For pages in the Readahead LRU that are
> accessed, move them back to the inactive_file LRU to await subsequent
> reclamation.
>  
> 3. Benefits Data
> In tests involving the cold start of 30 applications:
>   Memory Reclamation Efficiency: The slowpath process saw a reduction of
>   over 30%.

Did you enable MGLRU? If you did, I guess "do not active page" and a separate
LRU would have the same effect, but I didn't find any benefits.

diff --git a/mm/swap.c b/mm/swap.c
index 3632dd061beb..9e87996abbc9 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -504,7 +504,8 @@ void folio_add_lru(struct folio *folio)

        /* see the comment in lru_gen_folio_seq() */
        if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
+           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC) &&
+               !folio_test_readahead_lru(folio))
                folio_set_active(folio);

        folio_batch_add_and_move(folio, lru_add, false);

> 4. Current Issues
> The refault metric for file pages has significantly degraded, increasing
> by about 100%. This is primarily because pages are reclaimed too quickly,
> without sufficient aging.
>  
> 5. Next Steps
> When calculating reclamation propensity, adjust the intensity of
> reclamation from the Readahead LRU. This ensures aging and reclamation
> efficiency while allowing adequate aging time.
> 
> Signed-off-by: Lei Liu <liulei.rjpt@vivo.com>

