Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C577CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 14:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CD08005A; Mon, 27 Oct 2025 10:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989D08000A; Mon, 27 Oct 2025 10:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767668005A; Mon, 27 Oct 2025 10:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6056A8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 10:03:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01DE11DDD89
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:10 +0000 (UTC)
X-FDA: 84044060982.06.E174DC3
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf10.hostedemail.com (Postfix) with ESMTP id 980ECC0013
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:03:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KKes2zCN;
	spf=pass (imf10.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761573789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skT01swcwscnrABmfNzvfcVy552sDhR1HXvQJoW73Zc=;
	b=xFHbxwLXi5YUUCCZT+roq75rXtfpBLQdfSgkjfoMj8YSTPvfOmVj9RIiygbKLNs4KN/8AM
	bdcKGsTi5TcnbZ2gyE0GdhuWk+c5PFuv0Dc9t6huHRQ4gaYHQG6q4Ltwg0LXeYat4BJEIy
	kGtbew/X+P9tEpHO42i30bMrXYSrLrU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KKes2zCN;
	spf=pass (imf10.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761573789; a=rsa-sha256;
	cv=none;
	b=TYJlx7khVK0fEBdS3tTTlp//kl3u95f+7/ufJxr8UCQuGqGBwsBmCa5M3MrEtpqfwpg7KO
	NDOwh03GBifgZCgxMw15yHCJr2UzTRs55go0bURKq7tOKs+CituxEnQg7zX5D36pppwPIT
	jDv+wnPJHGuWjChf9fCyQMp17qyk4ag=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=skT01swcwscnrABmfNzvfcVy552sDhR1HXvQJoW73Zc=;
	b=KKes2zCNnXquaxMSEaw4Qt+Vor+rZlmTdwMNmSWUFbYdgpEHaW3K0x3f7xGQhmEiG7vAdHI2r
	YcGWXVqxQmHSsmylD3DWdBgRZqto3seOnIv1RYYOpdkhrLCOcXF7QlY8Iv3hBswtq2TtB6hx3AR
	xwHbnOhLykF15V72hPpdP58=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cwFZ23xt8z12LKJ;
	Mon, 27 Oct 2025 22:02:18 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id C9CBF140203;
	Mon, 27 Oct 2025 22:02:56 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 27 Oct
 2025 22:02:56 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<jannh@google.com>, <pfalcato@suse.de>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: [RFC PATCH 2/3] mm/mincore: Use can_pte_batch_count() in mincore_pte_range() for pte batch mincore_pte_range()
Date: Mon, 27 Oct 2025 22:03:14 +0800
Message-ID: <20251027140315.907864-3-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251027140315.907864-1-zhangqilong3@huawei.com>
References: <20251027140315.907864-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 980ECC0013
X-Stat-Signature: xrp7br3k8ic85uoan9domas556ya9t8h
X-Rspam-User: 
X-HE-Tag: 1761573788-82354
X-HE-Meta: U2FsdGVkX1+MWyHUfNbPEgAAkukVv1uzToUunXE/3EJQFPc1MoNUkQfSk++IVD/C46DOYlfkNxGpCpLCl/19RI5Xbb5YUkCWRizna4WOVexD5yiydw5xofJ1hjBQS227O11EcsgreKwYggP8KgcB0TNB+AktE/8o5b5aVTw+/AiEIRH9hth4bbtOWp+plIn/uH2VN13irHGR33D/9tDlC1fHO0FD7laovGbX8f2EYEwPo8Q6UIBk+g4NbfQwwvynwLdPRDQlgFHsP44z3Mwc6VLHTkS9pE3lWb26K2OVxhW34kctzRW1JbSnoYG257CnavyFzokKJyP8aNJ52bXXGI/W3AhaZxvsKFSmZ7elzjhG/yd4AuenJC1KKZYykWxo90NFOgblaoM2SLY4uHblkIBDNEjWDqHrYdIMaSsftt2pz4tZ6M6ITgL/GE52u33V8F6drklEw14ngcZewywuMRgRp752zny3ENBl+Fjz6K0VbG17qIyit/PYDdR/RA2jj2JQoSQ9NkMwN7HP+dNz3bxA4FERyU4igJnOiN/STD17zGvyQAl71Q7dykFBdNMSCKYGL30e49GdkBgJAJx0iqdkEOaE0SNn4MBu9XWC4z6HseigKDJYtdYyoLsvAtAyNppItZs041umiRMoIvgX+nw6dzG2CyXppHkcwuwlNoHh66m84RLnPeTSgrQ6h4ZdDNjFIXuUXqcRdHoHMJDwdfbN/08y4yRFxvt3XQ9IGQGq7NDn5cR9avyF7iD0NZup8Z7xtRH+nddO7WXu/1UQ405m8iyu22YxqvWHIiN6lnOheUWX7b17ORoIMpaw9x9T0b+cDnuxwsF4xhWN6OCdbk9DP/ZiBhZOxBwF1zJtTuxnOwq0V9D7jVceoD7JKNjDG/VUYwsmiz3Qmi4MhmklcIc0x4BQ1kJOQKhNw8KppWue/CGOxwQvecoRMY+SgahboQgPspfYFjb68Q2cXbh
 KOEhZAB8
 JNDJuCa49lDejtJtqn8AIhjewkpXDk2sw814+P3I5/0cttlvbbKng0nnqsiRkJEr1+DhsclECqpz/TUQyQ8OCOQ4A63F/3cfzwSy/Ww1xVzwqCgKjp+cvGI8OH1J0mfTvQxMKsjl+V7IEnJvZNYzziOLMgYvKoVuFbv+kywp8CQ9lb2p1Md1rcFdFhyEY5OwfdLjFbifDr4c/9+ZUvCG90DgEbrrc7bOkXwdfg+VOmYxjiRYUCrvAZ17A/LdEQqfx5EoVQ5HHVOFdq4FWQ3mswgQB2lqcBoTCEqU26gnwzQRuktRahqt5e4mOHwouL4VbeHrhxUcbQMPSUUby/GXmKhxm4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In current mincore_pte_range(), if pte_batch_hint() return one
pte, it's not efficient, just call new added can_pte_batch_count().

In ARM64 qemu, with 8 CPUs, 32G memory, a simple test demo like:
1. mmap 1G anon memory
2. write 1G data by 4k step
3. mincore the mmaped 1G memory
4. get the time consumed by mincore

Tested the following cases:
 - 4k, disabled all hugepage setting.
 - 64k mTHP, only enable 64k hugepage setting.

Before

Case status | Consumed time (us)  |
----------------------------------|
4k          | 7356                |
64k mTHP    | 3670                |

Pathed:

Case status | Consumed time (us)  |
----------------------------------|
4k          | 4419                |
64k mTHP    | 3061                |

The result is evident and demonstrate a significant improvement in
the pte batch. While verification within a single environment may
have inherent randomness. there is a high probability of achieving
positive effects.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 mm/mincore.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 8ec4719370e1..2cc5d276d1cd 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -178,18 +178,14 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		/* We need to do cache lookup too for pte markers */
 		if (pte_none_mostly(pte))
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
 						 vma, vec);
 		else if (pte_present(pte)) {
-			unsigned int batch = pte_batch_hint(ptep, pte);
-
-			if (batch > 1) {
-				unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
-
-				step = min_t(unsigned int, batch, max_nr);
-			}
+			unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
 
+			step = can_pte_batch_count(vma, ptep, &pte,
+						   max_nr, 0);
 			for (i = 0; i < step; i++)
 				vec[i] = 1;
 		} else { /* pte is a swap entry */
 			*vec = mincore_swap(pte_to_swp_entry(pte), false);
 		}
-- 
2.43.0


