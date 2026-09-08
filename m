Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7276FC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847116B008A; Mon,  7 Sep 2026 21:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1476B0098; Mon,  7 Sep 2026 21:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 699456B0099; Mon,  7 Sep 2026 21:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 430D66B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:28:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D079DA0372
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:28:38 +0000 (UTC)
X-FDA: 85188860316.19.F1349C6
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE794100002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:28:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AJRoT++H;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf05.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788830917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVulFbo+Xlb+gZYwWyf9RSx+niLz2941rDVq59YkMVQ=;
	b=rhxEbPixqyfoI9omv/dsskM4OzM5PQsWlUE7OhvunjiMgrGI1bYBx0dPQ2vdF814tVCQ7/
	9FvTBml7Mvt9V34mPni/3rPJuI0dyex4K681HK64+7t1fdss6HaagpyZqfNNP70cXMDF64
	VrwhnoFbEoCiaZ+Fe5M93vbcU8jemIg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=AJRoT++H;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf05.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788830917;
	b=41eq6f5Cwx4cbhw6FjQX5FkksF9aZuZdGWIrZnYvI7nOQUjG98LcecFeAVllaTgJUfabpp
	OG4PbkANICyyjE4Io/ABhY70K0xrVxMvLdSr2Po/QrZK+gKVVdvgsg6iNiCKUddlyqLtiC
	x2hoMX5r3aev4m1t8OcPi+6YS+VHJsg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=gV
	ulFbo+Xlb+gZYwWyf9RSx+niLz2941rDVq59YkMVQ=; b=AJRoT++HQHMkq5tNQ7
	dleQ8IpE0khpIpVfe+qVCxpGlN0IFUMStRrP886MnYVaVahTvaSGZqhJ/WU3YEpL
	sIoph7KGyTNVHCMxqbkTuTrMnr7kfwIZWGvosrAbnNca4RzD9MDjbuuggwckOk5X
	uUSOJz7euUeSHaIJIghxm4iLE=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wBX5g6wZJ9qrohVBQ--.12557S2;
	Tue, 08 Sep 2026 09:28:18 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: yosry@kernel.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	stable@vger.kernel.org,
	xialonglong2025@163.com,
	xialonglong@kylinos.cn,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2] mm/zswap: publish the initial pool with list_add_rcu()
Date: Tue,  8 Sep 2026 09:28:01 +0800
Message-ID: <20260908012801.1864430-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAO9r8zMhs_DQGah6mRfh2=Q_9WU4tm7SsWWGguUt4h7mXiOFRg@mail.gmail.com>
References: <CAO9r8zMhs_DQGah6mRfh2=Q_9WU4tm7SsWWGguUt4h7mXiOFRg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBX5g6wZJ9qrohVBQ--.12557S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFykuFWUCFy7JFWDtryfCrg_yoW8CF43pF
	WfWr9xKFWUXr92yrWDJ3Wj9rn5tw4DJF4fKr1UGF4xZwn5Cr1ay34ftr9Yqas2v3ykC3yU
	WrWkZw17Jr1YkFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piPCztUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3BPHwGqfZLOE7QAA3D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 37adexnu1kr7wgopgb57jiubeftxgaob
X-Rspamd-Queue-Id: EE794100002
X-HE-Tag: 1788830915-827149
X-HE-Meta: U2FsdGVkX19x3Xajlndig/7vCkCiFbwHGgSShYFgNFfmOohsxs+ia8ymuIKPgELSIjIRsF5/PKBupWZ8IzMnD9uiMGbjLpJT8wH1/JKIiPWSnLGpZpQDhMZWUcBevJL7vijMnjM+lrBefkF4Wt6k+reMGa2x+ZCobfLdxadj8JbhMq31ENtG2/dUeRPYXCoSKgOAVDw4inWFzI/mjSJyVH0ZEabZIUTxNzGIgZrKUz8dT+B++Ui306OWtWZRScHO7xwMLqDXBFxcYQxtJr3cVou+05fBZx9/I8YxBm+KDD7WR2XBb6Q7zKmXKmdmVKbtiGWLygQE06jHshiF57OIeKhrNqphs/EPhIqMshAhQvl8BOT+FKHYwmRkEK1P5CezfhiVz5w16e2enbYBWl//WDw092OD4WHGNdxq2G0ui3riiYqVImTmmxhh0Ed8TTu/9enyhci4AlB0CLDPAoZH1EAOYveaddBqxYCf9mgO+FEPN3L+viXsOItp3JicB8JoFR+3qi3wr2Ryd1+O8Jear2iL7wJPhvtFye7vWA4kf+9VOjLU20KcA2rmzWdkZRcitSFt8FfPACFaZu2jFzReZDMuBdySA9a7NPM7ZZ3IjkFT/ikEq+029VCGTDJLPhGS1e/YWZD/G+Jnf9T9UKbYyLkAPcG7ng9W7f+uRwsSXwPX8v45IOUlI97pPEDnnQ7x84au1EQ/lrMbKBqFm88fqS4zWcLIuB80eqQeNBxBeUomgzNtODcbKPqoSaMrfkZbS8HvjUEmiYzuVqeFy9vGtX99bzrkVwSzXAe5onRaaVQKkGgihAE039TistK3asoz/rkUCXFDM0ZCq6725dd1NjDInDa8pVS/P5PZbo09Xq1J6MeeEVK7hTQPQNKdVNVELnQ519InhOaMdLdRGuVizDTcez31Se5a1s1UJW/j3kKLNQr3OPr/0z/QOIWF5niUqy/4/INwPfuS+NcmaEG
 Cfrt3LkX
 9Wj+p3TbzwpvI+FIiV9KEUsPugr7T9cZiX33K8UjNAfIiGOkGW0jXqB42iGFFU2APzXkn/zUdTujYgA87rXryMkzc0s/nAdkA0HgUOXrEoBi4eX4Y08AeXm9CrQulzVweInWz/vJKcnydUTH0NcJATEA8V6muvhdxCFPzs/dtUs2P57hkaFJ/0I3adP6rHHMmtoHwTOkuIpOO3EnO5naL6HJJ042NtsATLx8BEmiuP7Ba7llEXKHmb1G9z7Lh5Fvt6arAn8RUt1tE3JtOqwrMdJ2r2Jnhp9EIBhH4uiRobSUt3DBif9hpgXiQat+4xTEu/O6oL7IdE4JcC0x7HNgEdxyXP+7rhAvMDv81poD8cXQFK30VnOcbN2zFG5wcRhbl7BNPIaEdjf8rwdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

zswap_setup() publishes the pool on the zswap_pools list with a
plain list_add(), but the list is walked by concurrent RCU readers
holding nothing but rcu_read_lock() through zswap_total_pages(), e.g.
/proc/meminfo and the shrinker count path.

    CPU 0 (writer)                          CPU 1 (reader)
    --------------                          --------------
    zswap_pool_create():
      pool->zs_pool = zs_create_pool(); (1)
    list_add() -> __list_add():
      WRITE_ONCE(zswap_pools.next,
          &pool->list);                (2)   zswap_total_pages():
                                                pool = READ_ONCE(     (a)
                                                    zswap_pools.next);
                                                zs_get_total_pages(   (b)
                                                    pool->zs_pool);

If (2) becomes visible to CPU 1 before (1), CPU 1 finds the pool at
(a) but dereferences a wild pointer at (b). Publish the node with
list_add_rcu().

Fixes: 91cdcd8d624bf ("mm: zswap: optimize zswap pool size tracking")
Cc: stable@vger.kernel.org
Assisted-by: Zcode:GLM-5.3
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260906133601.3563324-1-xialonglong2025%40163.com
Acked-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
Changes in v2:
- Add Reported-by: and Link: trailers pointing at the Sashiko report,
  as suggested by Yosry Ahmed.
- Collect Acked-by from Yosry Ahmed.

No code changes since v1.

 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..cb5a0855fd2a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1803,7 +1803,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {
-- 
2.43.0


