Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E8A6C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 12:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819C76B0089; Tue, 29 Jul 2025 08:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CC756B008A; Tue, 29 Jul 2025 08:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6914C6B008C; Tue, 29 Jul 2025 08:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5353B6B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:38:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 876B580526
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:38:50 +0000 (UTC)
X-FDA: 83717256420.22.F9C6E7E
Received: from mailgw02.mediatek.com (mailgw02.mediatek.com [216.200.240.185])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9C6CAC000B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:38:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=qbE5D2Xd;
	spf=pass (imf10.hostedemail.com: domain of akash.tyagi@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=akash.tyagi@mediatek.com;
	dmarc=pass (policy=quarantine) header.from=mediatek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753792728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4od4AUhUIJ9k4ABCwmJJPjKIu1r4CKovbv8tn3vh+5w=;
	b=uMJn7CJIXYY1n1enwR2Vp3p5MDDrsRGEmivcDvy+4qepxqjCzaFoJ2okSxtIvFyFexc6W/
	PwqRCxS0j0tcmaUewf/ZmKpKJUVi7BgY0wwzrQpkKHhIXHHYB6RcHocPq8C8XoPzoarok1
	rYdZfT9CE9TaiOVgNAV5+6O+FYgm6GQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=mediatek.com header.s=dk header.b=qbE5D2Xd;
	spf=pass (imf10.hostedemail.com: domain of akash.tyagi@mediatek.com designates 216.200.240.185 as permitted sender) smtp.mailfrom=akash.tyagi@mediatek.com;
	dmarc=pass (policy=quarantine) header.from=mediatek.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753792728; a=rsa-sha256;
	cv=none;
	b=QemgFsY5M6yetq/iTxqKcJS02AwyJDkK5Syf+vW4EDo+N4m9BsjkH7EabQka9TKpPhxCJQ
	7J18UtMeu4i6I9dWHw+GBTDVIcU3zp25HIm3K+kg/zr7lsFQZkOmHcw+QBZHDKlGna0EmG
	izef21Fd85cLSqNdkZehJNsKql9wFzU=
X-UUID: f50f37f66c7811f09eb0dd999d3936bf-20250729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=4od4AUhUIJ9k4ABCwmJJPjKIu1r4CKovbv8tn3vh+5w=;
	b=qbE5D2XdyLNDczPmYh2YidkP5mp4jHowmclyhsVB8WN4oUW6g56KvPF0ZfDg3grfT5qAawGbVmRoSL4mVM/LthSHptTW3zzCfGmK63uKlna3/qE3QGkeTgYfo8/cvfrlTy0MK8ThVP2egqI+B2d9FO1uxxCb03QH8g3KuJ5QPDI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:0460c782-9602-4915-85b2-d14337220ef3,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:cd6f5e50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OS
	I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f50f37f66c7811f09eb0dd999d3936bf-20250729
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <akash.tyagi@mediatek.com>)
	(musrelay.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1946173411; Tue, 29 Jul 2025 05:38:41 -0700
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 29 Jul 2025 20:38:37 +0800
Received: from mtisdccf01.mediatek.inc (10.18.1.155) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 29 Jul 2025 20:38:35 +0800
From: akash.tyagi <akash.tyagi@mediatek.com>
To: <ziy@nvidia.com>, <david@redhat.com>, <surenb@google.com>
CC: <akash.tyagi@mediatek.com>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
	<matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-mediatek@lists.infradead.org>,
	<wsd_upstream@mediatek.com>, <chinwen.chang@mediatek.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
Date: Tue, 29 Jul 2025 18:00:28 +0530
Message-ID: <20250729123028.1224786-1-akash.tyagi@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <E70C1648-DDAB-4027-AB07-1C19B10C6AEF@nvidia.com>
References: <E70C1648-DDAB-4027-AB07-1C19B10C6AEF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C6CAC000B
X-Rspamd-Server: rspam06
X-Stat-Signature: m4t1rqxztenhy8roy116ijkauoqddupe
X-HE-Tag: 1753792727-341273
X-HE-Meta: U2FsdGVkX1+pAWE7lItASiDnj0m+as5WBI4N4B7DVqiAQBEkYBg9TDJXTFqi2PfNi3Dq7uGjfb8Cre8P8Cy04uQYU7vfnXqZMgjTSR5a8iwUo9kL4MSzlBiNTWTKZFqNhY4Y+veBYI1buAkCyc6WiMC4anS4EDQMw3yTRDIb/fq4Ok9u4aEm4OKtjxRUgSJWbkeppjA5CwpCZ01E3IW2OXdlhCr0VLIexj/xx15af1LjVhDK+6130K6CuokMqvZBG3mobx/wuYWOxY8SvdHlby1L6YTpkrRS8Z8sp0GOmj6f5DafI8WnB458TIvWHT5jFWx+SZ6tShAJx/NQElvPkf3X1gMgVHxRP7JWvrytBpKmqe7TwIGeDufxsDjYhwHSmScv4lCGAdoJbVLP+mZdVkDa07veEu7h480GXC2zdnwwzjFzb2BNzAaricpZQh0DDSZBlrvn/7aLxYLgre9oSDrX9A15Dn73ZTPD1lnk3bXn54Vfn3JpN8IiI1usHS8enhLmVksfDbpNl9RHpyHEGzobXTcpzA4jjurKbcscx75ql4+a3B2pDCA9akR5KJfqGbw/6yIWfpoUXYQEimYkWIec42AaZpAgEkH2a8EGJCRcYrpbtyLVLgSCdQSJCGUeiq5x0PHqu2fRXYJQC6MlIjzaYQ8u56JHlfSi2gQoKRyxdmnHSMdGvPhXmXdGZA1GvJyUwdY2ePQnnxy3e17luzphw8ABqPSKBVYSnManwtue3Fp6GVp+ki5LuHQFdVNJhXUdK72OpBY6I2jeJYBChv34sAHieSb4V4oSu1Th0rWXd7XTtRMSb3nHUvZyxCmz0KAMl+L4iNOk86UhSh5anrgYEdEtHLvUxk//og9jQ6erESJ1DNjKQCgPgDktS9t8DGZR2oIj18M7efniAyrUn+4KMvviCUYEVrslXugfYB6PXS2GXfZMRUF361BbDOz2pKV4SXuvQX+0w6ZEjBi
 whI9LSmM
 JzqjS/18zEvFQs4NoIOdVjhQY9zCp7MofygzjrBWFFLxjKf03hqbPekmMuyS/r7BVI/zaKnFIy6MDU9eYQnFlyhRHfRlcslRaSXJW+YQq7/RDM0nGpg86uYs1OcgxeWAyq038Ci1ccSU/rKBvwWMX7QW0qfx3E2eI6OdTV6MvAjz7kj45lNQWiSecNGnY5gw365XijlGhsdeyOgtbdnQBdCOnFsjdmtq5dxL20EkcnubFRitB7RIzO339EhXazLfjpx5aprRPjhVHRFVMkYmgj7qx6AnsEwfUunjLsbnOryMCN1ijuBs/O+vh1tpsMuxR9Vf/dF+hbuBdmhVfucqrHAm85FB1jWti5Qvc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 at 10:27, Zi Yan <ziy@nvidia.com> wrote:
> But there is this known problem that CMA can fail temporarily due to
> short-term pinnings. See the "reliable CMA" work (don't remember the exact name).
> I think you mean Guaranteed CMA[1].
>
> [1] https://lore.kernel.org/linux-mm/CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com/
>
> Best Regards,
> Yan, Zi


Hi,

Yes, the issue I described is actually related to Guaranteed CMA[1].

I have rewritten our problem statement to address concerns more specifically related to the Android common kernels.

Problem statement:
Android Common kernels usually have an out-of-tree patch to prevent file-backed page allocated from CMA.
It allows some allocations which have lower chance of being pinned to use CMA to improve CMA utilization controlled by a flag __GFP_CMA.
https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/


Additionally, android kernels create cma pcp list for pages less than PAGE_ALLOC_COSTLY_ORDER, but not for THP pages.

This way we noticed some UNMOVABLE allocation also occured from CMA via pcplist as for THP there is pcp either for movable or UNMOVABLE/RECLAIMABLE but not for CMA.
so we moved CMA pages to movable for THP.

		movable = migratetype == MIGRATE_MOVABLE;
#ifdef CONFIG_CMA
		movable |= migratetype == MIGRATE_CMA;
#endif

		return NR_LOWORDER_PCP_LISTS + movable;
		
		

Now, this way we fixes the issue where CMA pages wrongly placed in UNMOVABLE PCP. 
But now if there is a GFP_MOVABLE allocation (even without __GFP_CMA) (which android kernel maintains out-of-tree patch as share above), might pull that CMA page from the PCP.
This breaks the intended use case of the above patch, which is to allow only allocations that use the __GFP_CMA flag.

To address this, we have proposed introducing a CMA PCP for THP pages as well.

I would appreciate your review and feedback on whether this is a feasible approach for adding a new PCP in Android common kernel perspective becuase Because having many MIGRATE_CMA pages 
in the THP lists could cause several performance issues.


Best Regards,
Akash Tyagi

