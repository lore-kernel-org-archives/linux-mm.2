Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F89EF3706
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27F5C6B008C; Mon,  9 Mar 2026 04:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D776B0092; Mon,  9 Mar 2026 04:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FF56B0093; Mon,  9 Mar 2026 04:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F40306B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:06:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A257D1B941C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:06:31 +0000 (UTC)
X-FDA: 84525792582.27.6A5EB23
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42792120005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:06:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/zHX531";
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773043590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+FqI0gHA031QQBMAtt9J8dHkFUnPoZqRMUQFOrt22u8=;
	b=sxtRtTPxNwUCEvrp+8nEsOge01cg8dwDXIJODjk8mdbewvuBMTgle0HZzpS1yp73qQBHDJ
	1SyyDAv2N91D4QY4ymsLTIO62DFlr1r1tbd1J8VKnrKDvAnkJQc3EYJnK8kfib6QwaDikX
	fprSONOi4Y1HDVYFwGBUIR+SdYvmGug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773043590; a=rsa-sha256;
	cv=none;
	b=7iExwV4/CRwiTfTk8iMt4oilZkb+dPltA53O6QdlMfotJmHhHuiY0z+YQWgdfdpXtFAkiU
	nXrQm3Q2CKWSxnOi+x9JFaf/xx4VHajZH6nv8YTs+U7X46jaGBW0tq1OwTBXD3C+ytOCWZ
	A8g9++docIvxWx89yQcStcRzI3cGtlk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/zHX531";
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773043584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+FqI0gHA031QQBMAtt9J8dHkFUnPoZqRMUQFOrt22u8=;
	b=M/zHX531aYs9dkvPc46Rnm+wa2XLzC7x0M7Tob0MInfGZICR0HI23cv6nLNX13Ea1lQixy
	ixR3pWpSVVFubOendXpGNvSFOdP5A91RBRjjTX2XwjOqkCKf5546ZPrAiWl99+wN7RISLg
	s8yE95KjPAAm/w3Pw/TXCfqErv7rIV8=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2 0/2] mm/swap: enhance swap cluster allocation checks
Date: Mon,  9 Mar 2026 16:05:40 +0800
Message-ID: <cover.1773040982.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: k6cuna7j69c4yd5fm741xun3qz81k1ij
X-Rspam-User: 
X-Rspamd-Queue-Id: 42792120005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773043588-786915
X-HE-Meta: U2FsdGVkX18708aGMKBRmWDrE61saRNp+tPp3noXCE+cR5adjcb0EAjsibOl+Ys8mxQsjzZJfm9fPBd4lnQIaVdNtRjBg2pXMFdL86hcrVvetFGy+jkwH/omOP2DL2tZaQG1CIT6Vs/Cr2MKha6GxBlrrAEyje7Lg1TLbFiWFx5pJYOw4+xoXpyEaCBpjDnQ/K2TOC8pNBuLysgdP3j30vb70NGYUxKqT0CtR3B1Yi6uEsDbyJ5G2jfSZBDcI143vAkQB+3cPiX6BkI+lmZG+Bp7Ynq/IOS8NV6r+wVdw+WRJu4akbcva0jORdphynKp6nW8a8XK5K75h0yDAZo8+zhi+b7Du9+/j11HkPyuIgdXxJ0KhTOrZhAxgoQwrMRXbwdcOQ6eEqLPXl2PupcpXAjPneiB2YNiILtK1BU6q2S5nGibSyFVUKf9RdPtZaJnP/zS6zdoNg2A8KUG3vCuWK/jsU7WZkkTnZcf7SaXIQdPzEh7HxPZiA6y/HZowDx5bXagwK707jUPap2CTPlE6VtbuvGgqbCl+JxtTEyTvpOoZHvKXZvWdSmUd8e47NgJrX+m0fLns6jc2ESyXEX/6wd5G9egQkTCgj5VVfoRqPTafFUVkb+HQUyJzE5JObvFFxWEZdsoXcIYnB8pCmz/mH5xHU6J/tQ/ZpBI4oWVjwhp+HrY/ZMS/vSeje3hllpleg1sUQh8O+j9/3rI0DXzBsV7UBHuMuC8xkdbYWJNf2MGfAgRsNV0B9uxlZu5543C+YO0z7HKUuCPNADL7osvMrSU/+K0oLzo0JbeeRipeSWTbqkIgKmrX8IiE9hs16YnyHc06RVyI465xJaXDQ+mCfs3+4+YS7Z8M0z49EIkdMi1fXi9mhbZa+NegyYpOj5OR8zx3Qrd7wNITzaPUqefaHPl/SKr9I+8q6Uqr9BJn+gH4ZWCok03IDGMEsTT8A2pdZs7Zw0CRXeHn4/qgvb
 r79xwfpD
 FJd407wIN+JdBDXqH/QZgYvP6IqPFuk4kZ7OFs7ED+PX1DI4VIbZMle2NVXYL1xy3gZWfZd6fL2xodRXcuRHUCM+qyO6qZQ8KS2+0RvKsaXKvMBzXjV4C85dQ186ugnFBg0sgJRhub54zPHW5eplApyUC8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

This series enhances safety and debugging for swap cluster allocation
paths in mm/swapfile.c.

Patch 1 adds a VM_WARN_ON in isolate_lock_cluster() to verify that
full clusters (which should already have allocated tables) are not
processed by swap_cluster_alloc_table().

Patch 2 adds lockdep_assert_held for si->global_cluster_lock on non-SSD
devices and adjusts the assertion order to match the actual lock
acquisition sequence.

Changelog:
v2:
According to the comments of YoungJun Park, Kairui Song and Chris Li,
change acquire locks in swap_reclaim_work() to adds a VM_WARN_ON in
isolate_lock_cluster().
According to the comments of YoungJun Park, add code in patch 2 to Change
the order of lockdep_assert_held() to match the actual lock acquisition
order.

Hui Zhu (2):
  mm/swap: Add VM_WARN_ON to isolate_lock_cluster()
  mm/swap: Add lockdep for si->global_cluster_lock in
    swap_cluster_alloc_table()

 mm/swapfile.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
2.43.0


