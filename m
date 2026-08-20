Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B3FC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E116B00A2; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B726B00A5; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6E836B00A2; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD656B00A3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C33D1A0121
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:17 +0000 (UTC)
X-FDA: 85121492274.27.4CD27FA
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 54F984000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787226915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=YxW048K7oMbWrgSdv5rYKaJRvADRBLV5bOznmgW+0Pc=;
	b=hQXpqV73slPktlIRJkgYX8eHI8334WhUQVbCVOA2J5Iyfg1ItB65MqSR9xBC3HzMB4w0Ta
	3p2GDswvyHxTordnxV8qf7/uRN9LFzbPydE8F67xd5xim6FiGqpV1bz5bkHNSEwYM9Wxka
	twJI4YlqpgiCmavg0h0gilnYxApEw1Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787226915;
	b=au3FiOHJrJ1nOXHXKbT9fzpqWsUsdDRg7Bv8ukwNhEIpmAyK+a8Ya/2TMRXN687YZJJg0O
	2inSRFr1hKcWz6ZiQY1wP6JPw3d9+8befzuPn5fvjbRK1tk62K9cHRHHgKgXzfvW1vjBKG
	P6VlK7Zq5ReMo8Tot5TmwzByISHgh/k=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hQhgt1Hg6zYQtqb
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:54:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id DDE9B4056D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:55:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP1 (Coremail) with UTF8SMTPA id cCh0CgAH99Ib64ZqI3IEDA--.64911S2;
	Thu, 20 Aug 2026 19:55:08 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>
Subject: [PATCH v2 0/4] mm, swap: some random fixes and cleanups
Date: Thu, 20 Aug 2026 19:55:01 +0800
Message-Id: <20260820115505.20027-1-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAH99Ib64ZqI3IEDA--.64911S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtr4Dtry7Zry8KF1rCw4DJwb_yoWxZrg_Wa
	48Zas5J3yjqFyUJFWUKrn3JryfWFWv9F10g3Wftr4fJr1fXr4fWFnrJay5Zw1fWw48Jrn5
	Aa1DZr1rAwsrKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb48FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q
	6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb_Ma5UUUU
	U==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54F984000C
X-Stat-Signature: 6kzjsz771f9dwu94wnogqa89p9sfbq6w
X-Rspam-User: 
X-HE-Tag: 1787226912-741388
X-HE-Meta: U2FsdGVkX1/EPNwcRE968ybSKyHY4LJrvacOpys4nGdCF0BAplgPu6EDKUbiBBJzdU+gd+j9a71Fsw/4RLAxUQnAbOImF+8j2L6XqitsOaW6a+JfAog9TuTOXpoouOhO11fj5ZqaQO3AAEGWkRfoHIohKW64pmIrJmpWwKl6RHk2KVnvgFewBm17Hz9sMfDEU9Bb8wtXrJM2caUjV/thNrIqf8aIXRmrZoiSy8cjPgZBAmMUzCeBK8SjBsWSdYjGFGSxQGvJdS0Dm8UTIJTrWIkcS2niI6HtrQLxYtkwCKLCDWb8LRfP9vinBIBGAwfeYAMyj8NVpjFa9HaaERgsGm2F4jycQ8tE0huo3PNB7d/MfainEHJ+7E67eG8OGpkbXVgFevXD/gqK6k6Cp1oWoTqJTvXGWqvjS9b0fwq2LeWcrUxR302rpnXrwX8GuODdF9f48pu8xguQIcMtasYSRoTI8BitYHchL0Dd5dO+v2Ql3VQ6IbBPeOoysAtfjSCyJk8do8NUvGDpFzZmTOyNLgxoClB/WMjmwDRcXbe/jKk6fvkBZ/tXSBVTJGaQivgVWilwCrqWNkVeiHOy6jKomOu4y7C/qS2qgfHrkIQi3karfoSlikkKS02eZ3023iNdmC+mcOh1JWy+PFzOLP9uvVRxI9Wpewrocx798eOM3ZfVTh5fva0/3qU5o29SKQ9Nc5LO202uVYU/b4UDdh8I/Z7lGjA4XvYSFGoWJ/FXG+tgoiA71Um9Bh4GDlo3T1tm7QfMCxBHtrvghH8wizhlGOLC2eJOv4PkBH8n/FquztJWSW5VKBk0l7tpzYdTLmejA9KylUebAcQ2xA0oL5UCLpVbMVw7G+egj13CL3dFWYur+hdZxfVe/A8ekTNHSzk+/nITFdJCWRQi7s7HXM8QiAFWIoJTv/tZ0BbfQdp45YIZ2+9LzSkv8fn6obrrR16Qhmi30sKKPIsMWIfW6Ss
 KnhK9Lzn
 dqPHKIbIdMSUCL1XFGIEPwW5slRAUGF3LlwECPIEEyTt5+iy5g5EURId81HYsGhkiMNdYU4I2YmBhces=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello all,

This series contains some random fixes and cleanups. More details
can be found in respective patches.

Thanks!

v1->v2:
- Collect RVB from Youngjun nad Youngjun
- Some minor improvements

Kemeng Shi (4):
  mm, swap: Fix potential NULL dereference when trying a sleep table
    allocation
  mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE
    initialization
  mm, swap: return early from swap_extend_table_try_free() on first
    non-zero entry
  mm, swap: Remove unneeded swap_extend_table_try_free() in
    swap_dup_entries_cluster()

 mm/swapfile.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

-- 
2.36.1


