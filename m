Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821E5606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YuRcQirF
Received: by kanga.kvack.org (Postfix)
	id 9496C6B05DE; Tue, 27 Oct 2026 10:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FAE46B05DF; Tue, 27 Oct 2026 10:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838536B05E1; Tue, 27 Oct 2026 10:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE496B05DE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:23:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8ACA6160A6F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:23:45 +0000 (UTC)
X-FDA: 85368624810.02.8607541
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE87520006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:23:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YuRcQirF;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793111023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRAq9FfSqjqKfqwoQMFQDgBK7w2lxGvz5g71khIm8Ew=;
	b=UUnoFDle6bmHI+tJpzXdSi7IccLgfloBZV+frHDzhEU2sJs1DD5FUn7YBPogW1iKHK0HZ0
	ALN38Qu0cOs8UisjtTDxIKOvbj6tfNmXwNpX2+KmUqlpvD5QxJuwv1x6+2dSm/Z6oc+TdF
	DxFHL5exvvs0mq+J9XaAalJxcJFZGnA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YuRcQirF;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793111023;
	b=U2SPv/sHKKZAh/jbXhBKeztt6aCsNQ5PnjOZJmzI3Rnl7HWVJidqFQwEB5xXH2jHRMxgX5
	EIS6tbqnemkTJEmMRqBcq9YqG3hm8NSKWOo2BkAuIyV5BcZ1HFH5H4qA2dC0KEtGGU/43l
	lcvkQ2g2o+uK1CPx/aJbmKLEBf4Ka6Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E3A840E0B;
	Tue, 27 Oct 2026 14:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85151F01825;
	Tue, 27 Oct 2026 14:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793111022;
	bh=fRAq9FfSqjqKfqwoQMFQDgBK7w2lxGvz5g71khIm8Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuRcQirFUbcIvtq3qtGR8tQ/R072ZaSixMh4qFnJsDaBjAWUV9VzJ0g1HGPlx7iji
	 GzW0LuocbO3K331zn0i/3amTYhKSafAIvzAfGJuDy5ptFWs8L8PHQDBShyl8fe0/Ue
	 +FTXNU1dBNijDA0nJFsRxN66u/9bfOCZYkFNPbru1x66TtFTUTkTRezbjUuNZ9t3JP
	 xPgBMn9N9XywTS+yoILwyI2SXNdnIGtXGOxoKuHLpV4lhvG6YCbJke9fAudKNKraM+
	 d7jSpzwb4tzHgXe/Q9z1DYO8PKr202ggjPbv8n9IiLmAt7t8oqCQjgH71kgPs5IHYU
	 TJ8HOww8V3NIw==
From: SJ Park <sj@kernel.org>
To: DaeMyung Kang <charsyam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Subject: Re: [RFC PATCH 0/3] mm/damon: fix overflows in score and ratio calculations
Date: Tue, 27 Oct 2026 07:23:34 -0700
Message-ID: <20261027142335.153506-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027135932.2301646-1-charsyam@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE87520006
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1875qi97sg6nnt3qwnwdhjwj9ao1di4x
X-HE-Tag: 1793111023-332490
X-HE-Meta: U2FsdGVkX1886AWJz1vdiAC6FDVJ5yjkAVTf0yF8RQSWt33brs5at8u1R9rB+1SFCHGJzMX6+f7ATKMcQZNHulOn/UHSXrhjnCQ3ydoYB64TIINJEODwzAY30llkWOmHoPNX+sHrPY0DYVhvkN4CaHWNbt59W5NJC9Vdf5sopKeFNPO4t2u3oxj9NUvNgEFNQOm0Pf2eN9SrQMWkfbYZps/w6wKj+Hi8ZKYLzESu7/f/mRgYkBGU7bR8L9JzoGKx4lBwx6V06Z0uZbuGflSYwDtnUcyhemxwpKR0coFSig3V9QzklbjTeUM/4UmAQw7CVxM/TdFeasxn3xCs2xpk0Z5FIdWl4DmzsFP02l8aOeaVEnVNpn0DjTgaaLyy6W5YZY9B4Evvg5OaE1dMSxx9q6oi+wFvmwmBZHSece88w0K9o+7VzWDQGiArU3JNcJ9dTKuKkUozX3ZWza5vnPK42lDO0o175dMeMx2i/q/d44AYKIbvo9OHbKyTAc4SPvONuI6uvSjOGAGiU9CldTj+vBpr9kbqpXWWsDfpQmz43UuiO5x+yKhuiDmUyCH/tq42rj5FWXWvWJml8oYmwbCZcFMGcPuzec/BSy+20dVa5uxFPzKCdPimzi8yQ3gNMEtTlo2+mnHvvM8z79E/u67B342niqVricZiTagjochZXsJPd1gygv5mNEdm4d/h+kzpznXzWzjLt1ta/vzpho7PAiv89ETKgvVY+G+KTwXV5iAiGmd6Moc+wrT4rfciTM9HpvnKVeA1htnbB5CGGSWtsJwrFl+GYuOFAUE6etRxlpJu888qXiS2EvvKLSR//zaoIP3Og37zj+HAJmEMu/rfLKpYY/vip/FxrE7oJGAgoIfjKcVWeyaXz9hU9ajr1/z/3Y6u4fUl4ksEflhuUnrYLa30XPDp3sWj1A8DAdQJLhkVlvz9S9kvT4qoNmFA3f1nPUr0knHLexAmY98YSvz
 rWHPPkNh
 nH2UiHbUxjnO3qD88li5Wk6RfUTvZ5BB/DmIzggUYu6pPJA4sV3/9X1aHL+wcwJPaSGRh2cdp3DleVUomZ+wcBN3mcK9jjAK1vK1ZIDIMt/KLuTclrZZsAQCyMn/3AVUHMfZuHb9/C1NWPllePc7h2OMMB6kdiGrBaWcLcezrltTC5Bl7/5x30jBey+LZYe35I/tkd1Xt7QTCBTvqK9qBRSf3ou4dPptS1k04OJTK7xF4tsZcz6RbdTvXXygAv6vwJv3J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello DaeMyung,


Thank you for this patch series.

However, I prefer reviewing only single patch series per sender at a time.  A
discussion on your other patch series [1] is ongoing.  So I will skip reviewing
this series.  Please don't post other new patch series before the ongoing
discussion is completed.

[1] https://lore.kernel.org/20261027035431.1007584-1-charsyam@gmail.com


Thanks,
SJ

[...]

