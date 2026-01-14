Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F39E1D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 679536B00B3; Wed, 14 Jan 2026 06:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646FD6B00B5; Wed, 14 Jan 2026 06:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57A126B00B6; Wed, 14 Jan 2026 06:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 465FC6B00B3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:35:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 086308BB3A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:12 +0000 (UTC)
X-FDA: 84330363264.12.A2C89CF
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 41BD7C0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:35:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y/yBXxCT";
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x6JB5m1zaMYn2/Ai4L76w6jnabp6L6YH+5GHcHxDnBk=;
	b=UEOQbKnTGrbCgp7CNL5pwDPQU6GqARo0dasWkiA8VZEZqi0TGcYQFZvdTlVnDlUK8NRX72
	e8vBdDcs7XGDy+MStdIJoNUhGboOodYcgvCYiZJoGp9bbsgTx0+4Ozm5+IuKChT8t0jBPq
	FoBaC9Eq9/S8xPbTbmbS/yTVERTYzQQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Y/yBXxCT";
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390510; a=rsa-sha256;
	cv=none;
	b=JaPor+0z1ze+Zp5tyqOV7FGBuak8553fv3jpgbOgCijaHmtzuDgjgVwiN0nVa7QT5bbIC0
	mz1GEiLlVKpZ19HQ8RlXP/nb8Qurc69iLoTsEN4WyIEtlVciZPJmRAxvrGIopx6oaxslNg
	WQZUj/UGHiictGkHhG3A9iSvk9zsbK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6JB5m1zaMYn2/Ai4L76w6jnabp6L6YH+5GHcHxDnBk=;
	b=Y/yBXxCTUVdP2n9SBbZyG8Lc/xRQAiUdP5P558HckIsV6pJK0v7HbDoVAJHfNPSTCECRr8
	80RdFRjJXxeM9qTN3JRSTaonKimhQZvOAYTFJCfj17L1M36EYvF0MX+zfe4HOct0bnHKuT
	a4qrZ4wOSs5GKn/GOQdwJ0vKQhDR/mA=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 20/30] mm: zswap: prevent lruvec release in zswap_folio_swapin()
Date: Wed, 14 Jan 2026 19:32:47 +0800
Message-ID: <971b3834f87d6dc87a0634bcca8c45f26907e262.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 1u4x55xbd1n4cyktipm5mri1g51iqrkd
X-Rspamd-Queue-Id: 41BD7C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768390510-691299
X-HE-Meta: U2FsdGVkX1+maaSPtv7QdzQjahSskb6+Opyy/aKp0L3YjcEZ47E0Y2JM2HLvl9xZG4Z9SnWE/iOPDx0vIUjN+n7spbMgC/r3iAyCJ5qlPsWH39HADwe4jJjSTTq2sKtOM6jYjH4ZguBABvc9CkcShOUe/V14MGgfD45ZrZQ90grG24/evchvnW7fHVYnKpyi5NfT3RS5mDqTvCbWdSUcw0nm6PUuHGp98ZO0PgFbo29rkRtxeJEhSUGstSTucdJhrWjwDbr2pLzYnfYeWNHVXhSG/YCPvHjYY7RSAzbqO2HULpmlwEnkPCLlc5UekVK8ed7dturDbsP9w68ozmgjb9GgytjT6c+5VT3kyCHOSCm9AyMxyX74Yqs1anA21ndHM+rZtTsvFb54yZDldfCDvKvNJy30AAwh4zMaqROmh3n8vPDe1cXHM8U+XbHMPAm5cWWl9Z/GZfDNdGbcA8SjB4fZHQ+equmP1kv0j+CBVOQgCNra3pPesvW+Z8z0XOt7/QDEJfRawdZeThcvtOobWGSQQg0mAGPE1LxDXA4oUqpRHoWoVtTIpJQL4I7yIRs/VyeGl1BWYueKRZtsKksUyZePkRm1Z2yG5AONAGAjxnKlRpkN+Eh2ebAonEiWJonyBIKB9GaGTK0vnqTmNtMAgKN14JH635LMv3OwQ8FElUda60Wk1M39DvFghO6QM7UklXerz8p9uVyMH2hMm3/LcjvG0Xn7t6wcipgb0bBofovoeHcfI5xeq6LxwUR0SOVyg9N7KRI3UO+5qejjWpm1OUFJVLlfVcxWFNB30h5FLgbdET8GvcAor5XbthPFS41Sdw0VdKvrR6BvDl+tdk25PGxGaRKi9X15VNUn4W4CkpStfgm0YbABrQA5KJcBHF4pnE1f436FfvRqYB+edVS8q4dGEMKM3UkiyIifpHaa3Pwz8xpbQfKhxBmIJFZJGL1C7wuY3qkOflrIBkXLfX2
 4ZBafd0R
 cHMk/neGltWZ8ZAX6GG3DCfdZ6iB+sHZgrWLLdNzoIU8z4eVeZ6zKNJ+7BsGwHX7p454YyqbDq88q8s2DlucsgzgaRQ6RUOkHkMRnxj7Le3xE2DN/M3MEAwWoyEUTFnraJkBreykbtkb78qmmNUphN3ULutWb838qmhuoazfSjgktWGxqG84Gqht4ilyuotJVKx4u0H3aIWv1+ICLh21rna8V7Lyn1bFS3nKAcZUArb960FZPnShsEBFhvjuyXMafrYFu3yjZye6vMunJTDGmw+qahytciVcQyXxrcr5G5y9bb0P6WhMqPItw+WPijty0rkLHbYOBy/k8FwqYwakXjMnF9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in zswap_folio_swapin().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index cd926e1c03c92..2f410507cbc8b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -663,8 +663,10 @@ void zswap_folio_swapin(struct folio *folio)
 	struct lruvec *lruvec;
 
 	if (folio) {
+		rcu_read_lock();
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_disk_swapins);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.20.1


