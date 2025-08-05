Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE7CC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 13:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CB36B007B; Tue,  5 Aug 2025 09:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D4D6B009F; Tue,  5 Aug 2025 09:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333F26B0088; Tue,  5 Aug 2025 09:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0FC8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:19:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0A56B9E71
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:19:11 +0000 (UTC)
X-FDA: 83742759702.03.D449112
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf18.hostedemail.com (Postfix) with ESMTP id 794491C0008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:19:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf18.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754399950; a=rsa-sha256;
	cv=none;
	b=IiI+03wkI4AgGXknYKrs1a50Kw4RQjrDfhYvVy2h4NlF1B99Guv+EGAgUGXb2kFywQ42U5
	kO+XIoCaapVpLItsYpjbf6pmhbs6Zd2912GsZo3Vqo0kYtEPFI3JkKe+HPo9nIJkYCVW46
	UL1txhwXaUGMZB14FoFGwzY+MxsCChw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf18.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754399950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=axos84GHu49IulaLRNOyyv1w4Fbl9rO0cx51hp3HYw0=;
	b=1cYX0og7nVUzpLDGvlpsPyF63dKf/JYcnwgAEuys6YPo/ICQ+EuWzRTVy3KS/Y/Af/d14e
	pE2vAFURz7LGR/bdWnKNtjH+CXjI9leMnBrqihD22apnyOpeO7V1ECqW2JD3U+DdE+Ck7U
	GwfWVQoD6Lgd00cmizjeUL21cAgruyU=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4bxDT02JhkzYl4n0;
	Tue,  5 Aug 2025 21:16:04 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Aug
 2025 21:19:05 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Aug
 2025 21:19:04 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mingo@redhat.com>, <npache@redhat.com>, <peterz@infradead.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [[PATCH v2] 2/2] futex: Only delay OOM reaper for processes using robust futex
Date: Tue, 5 Aug 2025 21:19:00 +0800
Message-ID: <20250805131900.17075-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aJChI-LMwmuWEwpH@tiehlicka>
References: <aJChI-LMwmuWEwpH@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 794491C0008
X-Stat-Signature: m1rbgy4r8ejcuk3msitoxgnpsekkbte7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754399949-4435
X-HE-Meta: U2FsdGVkX1+UvOPWBU7INZknrtYAobBNlmgpo1p1Vl5GBsq+VodMCBVwDQH+uI/Ly56xGxWPH0ZLV8tEhaUWRlV/DSqTXd9T8uWJuSdY+rhZ5fSD0rHXEKWVU/dmW3J9ZJ9b/rxjJDyI5cmQ3a0zHsUbDXN2e+zo+ObEV2PX5j4xp/yWrBPfUbh1e+YrJ3yRMpRbaPAB8ARx04lmGE1gfapD1JceePDJpIjGMA/fBhrH36pX+9l4o+Ebe3qmqCDCHEvR2IDDAHBanZlW9pUwrm+uX2DG1W3RKPnyhKS2+QYdbsW4UKkhNQuEiWjNIU+5SGtzefaQdT8TiY15FdjfkHHlHqVb6XdOp0f03putwC4/qPzpSYoa5Tq6KaC4myAbs2Geg5JKPmolzph1OMd7hE6GavnKcZnk5Qq59kupUR790ijEXhdC6OInSgE8a44c7NUIIy0OaEQ64/Is/ABUnQygbsXGu8lnBhJdMVLvUKig8fX6n9zhzKDBMa8NRyJmCasuNt3sRn78nEoMnbfnqsaNcJTuha84nrNc0Bc9xQnAnG/bMDcFUmSQdvjUk6JrnOVUkXYtd8ENdL0J1/gM8HK6rqdvsqbTBj+7obBJ+3HMQ8pBCGi/pgrNImWXellhsN/KVat6IEjMX6ApcbwYmcjxdLU8Jo4aAkuAEBjP2PMMwLZjD4cIktY8eym66FCuFUQrUf4a4UcXWTNPS4TdSxsmsTZ7biJk+1S1AbWikcArl7+Y+yFeTniBzFHPGgAQqhu4CRdkiinfQJtsvzvbaXjq6359X4pk9OjwNycvnwmr4bKnP4xt5fFQr7jY5P3203UKoVWRLGiz9Jyf7iOsXP0jno18GdxmtE8Fa3o4IcZfeB4t70+OA5OIoIWrZKxlpefZkvT7edQpyZ2btS/nS2PObTKr2qN3kmyqzdGDu30Kv1mKebXkHk6n5bKukosFivtbFK4ad2vQSJqSfbf
 Ye/VVvdE
 IMqdAUZMrOODvRjtmRsMtINvutmfS6/uixv++x3mTY7tOPtxmrhajWip7OjRz1BHpYWJaGPpGYU79U71MPkIy2+ebH+6tHzyQd1pFTskcLCHYvnyYSSNZQ4sdW/D+NqufZV4jFiSX2yITHkJo/mb+sASSXMh6jE4lzXVr+ZpsvH3x5ff7zm0GWoQK30RcMID9DfSHbZ1MaJVK+vyLdCNme68FFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000391, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Mon 04-08-25 19:50:37, zhongjinji wrote:
>> >On Fri 01-08-25 23:36:49, zhongjinji@honor.com wrote:
>> >> From: zhongjinji <zhongjinji@honor.com>
>> >> 
>> >> After merging the patch
>> >> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
>> >> the OOM reaper runs less frequently because many processes exit within 2 seconds.
>> >> 
>> >> However, when a process is killed, timely handling by the OOM reaper allows
>> >> its memory to be freed faster.
>> >> 
>> >> Since relatively few processes use robust futex, delaying the OOM reaper for
>> >> all processes is undesirable, as many killed processes cannot release memory
>> >> more quickly.
>> >
>> >Could you elaborate more about why this is really needed? OOM should be
>> >a very slow path. Why do you care about this potential improvement in
>> >that situation? In other words what is the usecase?
>> 
>> Well, We are using the cgroup v1 freezer. When a frozen process is
>> killed, it cannot exit immediately and is blocked in __refrigerator until
>> it is thawed. When the process cannot be thawed in time, it will result in 
>> increased system memory pressure.
>
>This is an important information to be part of the changelog! It is also

sorry, I will update those infos in next version.

>important to note why don't you care about processes that have robust
>mutexes. Is this purely a probabilistic improvement because those are
>less common?

Yes, My device runs Android. I added a log in futex_cleanup when a
process has a robust list, But I have never seen any process on Android
having robust mutexes.

>TBH I find this to be really hackish and justification based on cgroup
>v1 (which is considered legacy) doesn't make it particularly appealing.

It seems hackish to check the robust_list during the oom kill, and it
is also hard to see the relationship between the robust_list and the 
OOM killer from this change. However, it is indeed a simple way to
decide whether to delay the oom reaper.
Would it be better to use a function name like unreap_before_exit or
unreap_before_all_exit instead of check_robust_futex?


