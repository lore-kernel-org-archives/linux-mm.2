Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D16DEC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 17:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3786B0088; Sat, 27 Jun 2026 13:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155726B0096; Sat, 27 Jun 2026 13:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39CA6B0098; Sat, 27 Jun 2026 13:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5FDF6B0088
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:01:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DB94A015B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:01:09 +0000 (UTC)
X-FDA: 84926307858.16.2065EE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B236520009
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:01:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PesMaXNu;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782579667;
	b=WU4/iNhSPZK8WvsA6dAhxEWYCQKUyWvaKdd9BN9wUDHfpuxkdI3NMJwgYbRdg218pKYdPD
	yaTAGAzygd2A6eez6qIqXMmqzZ+iCFhFrP8GBg+mXuizyn7hDPF/u8h3yDY8luR2OOSo/E
	M7J9HSJQ51ejMzxu1+mmXzANCl7n1nY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782579667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hEn2zn5pWhG25VPBcYCkS7+7B1NjobplNjZ+d8XjyHk=;
	b=Z7Z2oquOcVjW4pJmDuhS4PCmqWkQmN4ZTLglervlpM6sz4XWXPrnbrYYOcptDtEK/J4L2P
	aw/szgb4YNCCWIpfffYybOI4psuXjq3nS1n9R32vhc7hXKgneXLlvYFkDn62NcxrcglkLv
	R0pfPXDko7G81Y/FUOKWkCUuQssm2dM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PesMaXNu;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF83342A61;
	Sat, 27 Jun 2026 17:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E9F1F000E9;
	Sat, 27 Jun 2026 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782579666;
	bh=hEn2zn5pWhG25VPBcYCkS7+7B1NjobplNjZ+d8XjyHk=;
	h=From:To:Cc:Subject:Date;
	b=PesMaXNupjJJGZuvo+yqSgEunZs+pIOijrjAHoAz5KrDeHs0eigW5qDmImhC3o89x
	 3b05rCW3a4MZW5+hrLKEXgTaI6tudKUTTVvihDNtu3HdxuR1GuIj2Mzxgr6RiY1SWh
	 MsmNSEeCYz2UitAgd6o8IWpfmoVHW0ELS1mJAMEDeDOzBRoNaW4L14iN1um4STbEmJ
	 Rm6tlfZuBEb4TplCTLPpgBz2BYti0F6F65IB9CEOdRVIlh1MPC7NU+uakrRCaYMKC2
	 vxE+vucgP/CpLxAX0vYqKHLzaVSul7ngSaIxty8mvzcKvekNwYDXW7dmjT+X5k3KoU
	 FpI7CLVly3dqw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [RFC PATCH] mm/damon/core: validate ranges in damon_set_regions()
Date: Sat, 27 Jun 2026 10:00:56 -0700
Message-ID: <20260627170057.1867-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j8m8myabsn13o8msfhr8zy9n876uo4rk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B236520009
X-HE-Tag: 1782579667-285207
X-HE-Meta: U2FsdGVkX1+SaaG93ko6dowqZlBOHORbFDF9DmHO1zpInVO4wYof+4VsEH+sHOfB4XPGBWiZTZ4xhp1F0yDpEpjtEIAlViko2uNfd3y4h6+2WqnxwlbJvlthOP02y+oIP1vSUVq0yU0MvK17ZxDuojkPceSNC6qo45jyAYiegbTbUnCMKS+Fm/12FSHrFRQXdY8wND+KeRMz7xTlner9pUAmvzKfRYpvb4h5MwpbKCOlDgeh6d+f1EDBFXm2BVuCXEe/ij8FlRZLncr5yz9dXyvqfaoHao6zzqiNmErDG8PH5aY+xi9EGg/Rhad8ykyIsvP9/bDWdh6fbjgS/W5htifWm8hGZX8tZenIZRPwTTYdawZhbLlcpE++I3IdbQzUD+q3rNJluXfnCSroza0n/pjeJDcoiGURP9o1dCAcmN+WlJ6ODjVUGqcmYa1XwPAXhMj8Ome6ikqvWoJ4h4HIGUCSkx+pEjEbrH/VFLbCz2XpXm0Wj0E3Xmg1jEP6Yd0ADzeilIHlR0EPqwzjCD6XPDsFZPDZ4etwDVQl7+548bqSPVMAk1qJnj717qsU/SUNZFKGOS2AECofSbJnk82nCX698T2Hvxac2fdaZW7oBxifGv2K2RBLO9DXu9ZiKhxYkK4BYc8/bZ5EwiaAx1WaRETKNmLXhfjZnUYA9VqmTZ7HhmLna6DYju33NbvtV+EcXHrHnrU+jbX7RkjKfd2Kww/7C61N+elGsSQnib3sb/Ir90Fvl3zxmen1taKl82ZmHnE/n9jWmkey/8MTPwzcx6pdX4eEc04KauRpUk3/zbFBlPz9TVdmrHCrnF7b1f9anCSA7fWRPnbxEOXsRNpGnUootQ3+91zop9blcr4g7ibDjFFAChiHzfSPYPSN3fDFNJ78+hjk6Kk+Y4DuJvG/szvCxBjuXuR5yFsXpr0HoIKcU1+dnuT+Uabp6X5uqc6OJPqzqhdu637qPBG9RGB
 KXvx+ly8
 KiWg8S+4mC4icqJ45Ozq8qkgdCelQbpwzACgD0MSif1eOaIBfh/frDMXC3rwUgJmzOX8pBxwu+ObgRa6DY7IFVCi/16H9HSzgwuRu+JJxAWbxF+oeuVZLzdvhHoR1ZCXEclw5nONzrwKjJGkc7kcF2acs83a5F6PbRLDE0vYFPcXdQoTLMdH+W8VhCnf+MO/1tJ+Q5MkoxZgoYxxxBzMQcLArRwZHp8cQuWx9BjhcV+x9Y2BErvu8m5nz+Yz8aOaZx/Z45vc/1uWhQd2p6g+LsvP/nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core logic assumes zero length regions don't exist.  However, a
few DAMON API callers including DAMON_SYSFS, DAMON_RECLAIM and
DAMON_LRU_SORT allow users to set empty monitoring target regions.  This
could result in WARN_ONCE() on CONFIG_DAMON_DEBUG_SANITY enabled kernel,
and divide-by-zero from damon_merge_two_regions().

For example, the WANR_ONCE() can be triggered like below.

    # grep DAMON_DEBUG_SANITY /boot/config-$(uname -r)
    # CONFIG_DAMON_DEBUG_SANITY=y
    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/targets/0/regions/0/start
    # echo 0 > contexts/0/targets/0/regions/0/end
    # echo commit > state
    # dmesg
    [....]
    [   73.705780] ------------[ cut here ]------------
    [   73.707552] start 0 >= end 0
    [   73.708452] WARNING: mm/damon/core.c:359 at damon_new_region+0x6e/0x80, CPU#1: kdamond.0/758
    [...]

Disallow empty region user inputs by updating the validation logic.

Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e4b9affc5b06..b3100d7fa5596 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -358,6 +358,11 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 	unsigned int i;
 	int err;
 
+	for (i = 0; i < nr_ranges; i++) {
+		if (ranges[i].start >= ranges[i].end)
+			return -EINVAL;
+	}
+
 	/* Remove regions which are not in the new ranges */
 	damon_for_each_region_safe(r, next, t) {
 		for (i = 0; i < nr_ranges; i++) {

base-commit: f5cde2d41633df3fb1965efa00bfa827ca41836c
-- 
2.47.3

