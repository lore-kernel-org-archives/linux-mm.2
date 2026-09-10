Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB939C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8057F6B0096; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7EE6B0093; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CBC56B0095; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 452216B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:54:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D964C1C2311
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:58 +0000 (UTC)
X-FDA: 85197393876.12.D1CB3B6
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf21.hostedemail.com (Postfix) with ESMTP id 03E851C0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:54:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="UDS/rL7w";
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=q0Uwc7DoOoWl6jVbsiR7FzzVVx44shFaIKR15OkfT68=;
	b=KXZajHA6EzlO+yONr8RH9RcVWk28MVreTvWxQskrih3Rwi2m5GTNdblBqZHsBK9Hs46FhO
	qfkfccSwAT/uq8u0m2eXm8ZFei1y0Uf/Rrb8Ad2oTUKPQVF362Zaf8lf9OqJOklKS4gLPn
	Wj1M7FIUztn3KG1GaR2qjF/qDh5IiJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034097;
	b=OULL1dSeWar1oBDP8n2bTDxDr6etk+lEEOPh1x+/LscMG2gsDIaF0jpI5lFAMJhB1E4zNL
	tkFqZjZyUf/4sDDzU+exIyVLLVlldmWMiibeFWNnRDEu7a9jCvJoQPJzjmfkvt977Cbj5C
	xNI3CVMcxF5M69ShzEAI2CSQxMhm1Zo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="UDS/rL7w";
	spf=pass (imf21.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=q0Uwc7DoOoWl6jVbsiR7FzzVVx44shFaIKR15OkfT68=;
	b=UDS/rL7wJIwPrKexyfz1npirmayP+pRCFF4oKZB9MFOLDUx+okqAsQwvA8CcfN4WiFgaT7wUe
	PZtfx69bx02KjpU9ikvRbZTlH+rjZvTkTdYTPOnhYDunPoGdEmENnz1t9Lh9Iwp7VDpxTBC36mJ
	f1cp+/gQkdJZrJuSiHcjPTQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hgXmq5yZ8z12LHh;
	Thu, 10 Sep 2026 17:43:39 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 77DAB40577;
	Thu, 10 Sep 2026 17:54:51 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 17:54:50 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 0/4] mm: zswap: misc optimizations
Date: Thu, 10 Sep 2026 17:54:45 +0800
Message-ID: <20260910095449.715183-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Stat-Signature: 7jteardxakirrprifo14yswwfkbouptg
X-Rspam-User: 
X-Rspamd-Queue-Id: 03E851C0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789034095-308753
X-HE-Meta: U2FsdGVkX18qlUKKxiY++HICSHMv1qsUF31CcXD2aXNsPj4vvGAEXtTxtOAdYE3fdKPUIHwBes6HTY3STT9LGGm3nJNCgizmkIppsi1ClIwqv0hhEpltj0IrXK0Om45OA+dxEbkGGYm6x81I/oMujIohA3WK6amXKlSqqeRqVMoGP2AhcMmyeeI5C0qjIq+UBymvZqMTj+wnD3vW1WnbUMkKA3VxW3YAheod3itbXT6pVDjTghuvsQeNacScnalcu2YScGpO0RAF4TwvuHuOXHbuP4P+UnnsB1hACY5EFCDm8aJEkTlB47v1oSrzZByAsDM1PBEOWZPHs7JnDcsXfJpf/IBxAEuBGAlF1o+Fgx6PqLuN3yMiyJB7qSXxMCQepg09pmwSsyJTEBZ0SxdwS1J95YczurchBIXAI8IpDtSCpEvJqbZrs6qo8CWtRxWy1DjXQmcJItSuntflmn2Sxc4HxqEw9oVfCPn73aRzt1dadfdRyhnbu9eD2mv7zpf2FTg6qzUqHp0s94HvsrY1GYUkMRPD47b4oxqLAmZO5icpBAzkNYWSSFIF8QROPjTwSzGltN3IfhOOcHZnN9TvIT4tV72NnK/e1EGDrp8kJ671EcAtekY0QveoA7W39Z1J7EpIkmrhrss2NQA3zhEtRkIqgMt6Y19TTPH1USE5wXg52Cz1dFp89VSC/0MEBF1uRKMShX7tCEUKYX6uRJkcSKyEufRAC4Zs9p+uXwtbuDdjVNLqxteM1LKg0cR63yCRgZINk3LjGjH2EZnv2dIBroRNR1BweabcpNjNvOYZ8Ocbzi8a2gbEausTz1yZFvFVih0bUR5rkm67oro2WUqWW2ru3GWGJn+OddfThi+5pr8rgh4LL8kNehFm/JhbFm4IObaeMNqPzNiZosfLREmE52nAZAWRqhTRJlqeQZhqXL1rMnL86QT+1TrQZTR2x2Mw5Zp1G6A671dpywaErCH
 71Iyb6sI
 edlKI3HPzzIEIfPAEbwAdAvByYud5BgWDtVNJTzKOWYEqtlYvM19copOp66mRR3aX/wEaX7vbFDmD9iH/wWP0uEJ0xw1eJqRycaVPSHaqc9z3zy+VlxWyTpn10jyYNp2i2SGHIThHCZUGdYaSqA/G/H6eXisqxI4s0+RGH3+JzJ70gIIjQ31v4v1I/TaVM1bl9SJJZoSgkKjXxUCZHBLJUugBNquJNwTXvD8o0V2dbR/eT8ewlEqdCnh2xEHST+dbFnDfoKQxEVU8T31wb/P0mcdLjFX+n1QnfMH8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series cleans up duplication in zswap_invalidate() and adds
fast paths in zswap_store() which now skips redundant xarray lookups,
while swap_range_free() skips needless zswap_invalidate() calls.

v2:
- split patches and refactor zswap_invalidate(), suggested by
  Johannes Weiner
- add patch4 to skip zswap_invalidate() in swap_range_free()

Kefeng Wang (4):
  mm: zswap: pass type and offset to zswap_invalidate() directly
  mm: zswap: reuse zswap_invalidate() in zswap_store() check_old path
  mm: zswap: avoid unnecessary xarray lookup in zswap_store()
  mm: zswap: skip zswap_invalidate() in swap_range_free() when zswap is
    unused

 include/linux/zswap.h |  4 ++--
 mm/swapfile.c         |  6 ++++--
 mm/zswap.c            | 29 +++++++++++++++--------------
 3 files changed, 21 insertions(+), 18 deletions(-)

-- 
2.55.0


