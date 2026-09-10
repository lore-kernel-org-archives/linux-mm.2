Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E19AFC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:36:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D99B46B0095; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25C66B0096; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3B96B0099; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE356B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:36:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11027A0526
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:36:01 +0000 (UTC)
X-FDA: 85197799722.01.DAE9652
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf14.hostedemail.com (Postfix) with ESMTP id 048AA100006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:35:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iF89AELZ;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XkD/1BG8+6O0G6Oo2TT9jJvHLu4XPTSYc4fLGsChLu4=;
	b=4S06SYzZld25yg4WWfiIcYX/ZPsDrXxL7Uwxm+Zw8OByxQYJ976tKdSTlz6e+nrYa9ilXZ
	C2qay+mgpI7xwb02OpnukJgORvrnHcMzX7tWptt3bUDms6OyDiZSe5uBwATFvjjoDPRKUg
	wvUkds6ZVy8f3w989lCaNepP2HQhOJk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iF89AELZ;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043759;
	b=keeKfOVTWe8Y2l/XqhB/7aswzVH53FiQ2vLJBDLZ+LB5iqgYtBZoz6kGMIIWLHGR+EnDD4
	oclxhg5Yy9xqM0lRlmQwChD0d3o6YmvVAg1vJxbaQnri80LlZmKITCVT9GqPU8c+QaKnP9
	poXOPuhFuvUeUAf8YoQq8EX05d8bhug=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XkD/1BG8+6O0G6Oo2TT9jJvHLu4XPTSYc4fLGsChLu4=;
	b=iF89AELZtwKGe+wRQrKJK48RAgL+bi7RdIPVyKwwEG44IPQGJXMtL1AcIPhSTAZPpCh12y5Q9
	BG42ZOBnYhV4Txawrffi6Z3aC6tgWoumSj8xN3oiwp8NA0NynbJ93GJZGLRKgfuIYM92OwT/v6C
	pPfJ1DPNouzkQrYkgg/bXyY=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hgcLB1pHyzpSvD;
	Thu, 10 Sep 2026 20:24:18 +0800 (CST)
Received: from kwepemk300003.china.huawei.com (unknown [7.202.195.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B6CB4057F;
	Thu, 10 Sep 2026 20:35:53 +0800 (CST)
Received: from ubuntu (10.50.87.83) by kwepemk300003.china.huawei.com
 (7.202.195.93) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 20:35:52 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, Chengming Zhou <chengming.zhou@linux.dev>, Johannes
 Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Nhat Pham
	<nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v3 0/3] mm: zswap: optimize zswap invalidate and store
Date: Thu, 10 Sep 2026 20:35:41 +0800
Message-ID: <20260910123544.818146-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk300003.china.huawei.com (7.202.195.93)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 048AA100006
X-Stat-Signature: xwfw5j6zgc8fscw3n74ufkeq9tab6ayp
X-Rspam-User: 
X-HE-Tag: 1789043757-935506
X-HE-Meta: U2FsdGVkX1/oDw3Wg8ieks3ER05qO8E62u0RZAu1swKO692dK+Zrp+iNC1QCaC+4FhU9ry/JhQcsHVav6bVy7lfs50zpqWPeearSb0joU6/3ijVzUmHUyRqUzGxyxDn772upscKTm9thTzemh6sdSyO2cR+RG0By0X69a0Q7lcI+pMFyVtXp83J52xU4dTXuby4QT/XpalfLv1ue14eq2Ca7WkkDB5QdRIxPfXsrFd0Mo/XsISLBjWVBLiUbU6hgcQPAOFNVQQmQ0/2XgXVxRjW/D9sWEE+nz8uVylpCEKdxbjqIYsSRA6T1jSPntFjclRqPTTWtatm6SdTWqKQpK9qk6h3/ZH/fVZCdmvdxlzsv04KueSHMzEvfkB+d151JiaBtSczUSMYqzP3oTvCBj1Y2M+ysu+Bn6dt0/2RoTGFDElKK3h2Xs7PhBs5a/ZGlMnKmrF6kEbvc37QQR1cSUrdJGQSw8quoCRvgUP/4zuuJtqK2nCXxcNKVWV2RSD5qw0oaESCix01kGPbX3ta74ubdPnJmH3YtHmyrKewLaZ8Fp+Wc/0Q+4PBCFagvOgesPQpaA1bvG5pn+To0b5cbIXGctzRdVXcTU1U9ZZ7AB0GbKgj+JsVTGTaV+TX+hK3w8GFNDtugSnJPR8wSEv+tEh2i2BXQ3VZNNRaV3+4hcUcxOglWd7suhTzLEINuR+urgw9LIuS39O6weuwmgrB/ri861W9cgrM96rhuF0dWlqBbZO3OaIXz/O0ePUqqzPn00MbIOB2XofsnOQLW/sNcvSwIR4nqB8ew2nRqLpZRlQRy7ch6YQgO2U+Sf7g/bXe/cH2QhukGF3f75QpP7a9YjvxnQKsNLMLv5XqlGh/HNoIawmDmeM9kmSqa2uSzSif35GCzRKiC13v0b/iVuceoJZI9A5YHNhzrVz+hxMoyNEuDwL0259QpLNga7oVGepNVLKwdxdY1st/3NsCEqn8
 iYbV8GzB
 rCWvOSoZVjP5pCJgrlULbqOXThZ7kjegiILUy8TicxmN4XLHa8oysTatOKPgnrPeP6lArEVPxUjkqmqiVdg8f0mjEmeXYG32ZpkVZ/0UmUjIGMXz98rNmbHdKkgJlfTnAKyTIrENZ0zM8g6MTBYc8nEpop3M1nPaVpx8Fj7x4R0rL5LSsilK/R6GsJF8mtHi03HecIxn0s1xolNP9egckYLyJbz727UtI7W5LIkUzYUXXtVEObF3EwbaJ5Wiaas7HPVRHX3ju/ua4jtw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series range-ifies zswap_invalidate() to skip xarray lookups
when zswap is unused, and reuses it in zswap_store() to eliminate
redundant per-slot lookups and open-coded logic.

v3:
- make zswap_invalidate() to take nr_entries and add
  zswap_never_enabled() into it
- since all patches refreshed, so no ACK/RB added

v2:
- split patches and refactor zswap_invalidate(), suggested by
  Johannes Weiner
- add patch4 to skip zswap_invalidate() in swap_range_free()

Kefeng Wang (3):
  mm: zswap: convert zswap_invalidate() to take a range
  mm: zswap: skip xarray walk in zswap_invalidate() when zswap is unused
  mm: zswap: reuse zswap_invalidate() in zswap_store()

 include/linux/zswap.h |  8 ++++++--
 mm/swapfile.c         |  4 +---
 mm/zswap.c            | 45 ++++++++++++++++++++++---------------------
 3 files changed, 30 insertions(+), 27 deletions(-)

-- 
2.55.0


