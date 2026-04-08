Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9501073CB6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437FD6B0089; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374326B0093; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECE96B008C; Wed,  8 Apr 2026 09:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC73C6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72AC7160164
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:42 +0000 (UTC)
X-FDA: 84635481084.15.7F0C529
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C1CA20014
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=yLWV5gHf;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wREz4T78YPhJ9E8L+oiJL2Av2c4hdXIqKWNz/bt2yKQ=;
	b=kyPSvDyg7ZQK45sFq717v5CMR7nrDIL2BbURDjxacNoIKXakO5AE3o9hah7V3TZhYMlLaS
	vswvB3Ht8ozxdREo/6eX9QXWVjDPk0YYkh0tS6B9xuhfnFEDU0ZcqLeMSDVyjW0QK4VgTr
	199D3YNiJe1iMqaVqhzbZvbxFgg4LSI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=yLWV5gHf;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655220; a=rsa-sha256;
	cv=none;
	b=4AKnia8PmFQz5mxHjdrl+CTRfQfMMWlMFyrWn40/CzGuHD13UubT5WzZVuPJWxZI+bRZCC
	SLeZCm/32W4rIKGPEKmKcmdSpj89kD90rLEtultliqfRvvkP581EvimptJdgygY79zylS6
	znL8msJFtUTaH/K8U+Ud/GfgUJLwNgs=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id A7399BE70E;
	Wed, 08 Apr 2026 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655218;
	bh=wREz4T78YPhJ9E8L+oiJL2Av2c4hdXIqKWNz/bt2yKQ=;
	h=From:To:Cc:Subject:Date;
	b=yLWV5gHfWjYCIU9OvQagLVNRrMHUVcUp7LUJ4o9NaYoGrDtnUv8gZwOc2SCEVHgRt
	 GFpgc6az4lCMFLpIpxX58yvDMJP4rq4KMxNhrGGaWKaDXYjkVgg1HrodCzhWXH9+kZ
	 Kl6r7oSAZVX+3OB5Yjtrf1K7kibpLM0nVfNg7Eo8=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [RESEND PATCH v2 0/8] mm: use spinlock guards for zone lock
Date: Wed,  8 Apr 2026 13:33:15 +0000
Message-ID: <cover.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ighnj1xhynpg4b3efgf5gg93sjum7w3b
X-Rspamd-Queue-Id: 8C1CA20014
X-Rspamd-Server: rspam09
X-HE-Tag: 1775655220-340536
X-HE-Meta: U2FsdGVkX1/yHhLsUVki7vnqh396Xcnt25tKFBuiOuc1N3fC3SHu3Hl73vfnpdDnKkdSmNJf4iPI1IsVCQ6q6s8AvV0oxzLdQSuhW13CGtB3rCjOloSSkGpYnkMLK4/wf4eKD5dFbHbMDnFkZs6vA7AEJYECjUczasBqhDjTpYR7zV70PmaibpddqJ9WA8M0P9AgZAIQZJBNihYMx54YyfsKZRcUgYYJ6SU3cZl94FNu+RVKiFutQtUIYOSz0PkgnGpexqPwP/KDp1ZjANcifTVCu73yhad8D65/ApyKQ1R7e3IXEWYR6mS1NyBDyorUaWr9+iS0nkoE48/wxZ7pRcbMaWv6RrQlwthNDckfnKvZvDvzQFS8HoNIpeCXfOnqDzz8MGwncDQuqDlWxzk9axMTZCXHoloe/HfUe6WzrZS+B50K6WcMN8Hw/6oYkzF/FO9QgCR07q3vRirB3r7tbK8op24BIE5WTtW9UhTE1hN5UyGN2GcIs9w+ib9gTCXve6wBoXUs+7iUjjXkfKs48nbCsLktfvEvRuAKUPiDJJuWS7hgsu0f+DQrDfV/GekTAGLJSVjGuOZ7ZkWcKaR+9j04J41NfuIcnQCbS9TMKfP4x7Xr8fWEL/itqyxtjwCGCev6htSxt+4FvE6PzhtgmN2XmBo6euaWu++AaXg1Kt7MhrAGgoTOA9yxHZ6bU3Vai0Ds+xx6Ska1jhkxgY1kcjc1k93iRkrlxDsMIjNQf7Q+tqCNxgPMrLUIhysRBcVop/wEeXjt4vk8X1dkHCJ76obnB237H7evIrzP10Dw4S7pE1GWhb1cGPmHADC2RU67NKnwwio/WJ1QqMcTGtuO8WAqFGGxM8kKb3xwR0ZYqm6KGBTuwFEIehP5z+03HoiNouCAym+r06YHJpPBCgvLjveyyKTPCzi8H5l8hMohC8hLIiHge+1TQsk+dcrUAeMtsY0lDzhaq8Z0sciBAL/
 PxyR3NBm
 jD2PCiBukfreLOoPXmdVPxoy1G5FRsikxqoHT8q9pqILumJfPAE5WBg0cxe4lIaUlOCE3Xsj8xXGr2umQk9kjjQ0sdRYRNjWkFJnKrYZfUXSnICB0OeMks50W+ROkBMsiUaYXFRNlRVezKMX7h2G+AQZ4SedW52aqRBDBL4o87/aaSxD6ei6KBTdvs5+1T0FJGTdmW4WSegX9QM4HYDb1/tipu5Pej9rerMS9mh/ATar61wg3iou/nK65pvX1WShR1jo9A/kfuWajW0DYH3JWaRZ6ouTiFihteQzINBNE46F6riEaKVzMwXZwyc4oxsRbsh0nYZP98qD29yA74JhRLBDkTAwtl7lS4Nsg2aWhmhZp8d8Raz9A72fZfiXfbuOajS94UYhCimwuHwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resending v2 to get feedback from folks who work with this code, as
Andrew suggested.

This series uses spinlock guard for zone lock across several mm
functions to replace explicit lock/unlock patterns with automatic
scope-based cleanup.

This simplifies the control flow by removing 'flags' variables, goto
labels, and redundant unlock calls.

Patches are ordered by decreasing value. The first six patches simplify
the control flow by removing gotos, multiple unlock paths, or 'ret'
variables. The last two are simpler lock/unlock pair conversions that
only remove 'flags' and can be dropped if considered unnecessary churn.

Based on mm-stable.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>

v1 -> v2:

- Andrew Morton raised concerns about binary size increase in v1.
  Peter Zijlstra has since fixed the underlying issue in the guards
  infrastructure in tip [1]. Note: the fix is not yet in mm-stable, so
  it needs to be applied first to reproduce these results. With that
  fix, bloat-o-meter on x86 defconfig shows a net decrease of 49 bytes
  (-0.12%) for page_alloc.o.
- Rebased on mm-stable, since the patch this series depended on was
  dropped from mm-new.
- Converted guard(zone_lock_irqsave)(zone) to
  guard(spinlock_irqsave)(&zone->lock).
- Dropped redundant braces in unreserve_highatomic_pageblock()
  (Steven Rostedt)

v2: https://lore.kernel.org/all/cover.1774627568.git.d@ilvokhin.com/
v1: https://lore.kernel.org/all/cover.1772811429.git.d@ilvokhin.com/

[1]: https://lore.kernel.org/all/20260309164516.GE606826@noisy.programming.kicks-ass.net/

Dmitry Ilvokhin (8):
  mm: use zone lock guard in reserve_highatomic_pageblock()
  mm: use zone lock guard in unset_migratetype_isolate()
  mm: use zone lock guard in unreserve_highatomic_pageblock()
  mm: use zone lock guard in set_migratetype_isolate()
  mm: use zone lock guard in take_page_off_buddy()
  mm: use zone lock guard in put_page_back_buddy()
  mm: use zone lock guard in free_pcppages_bulk()
  mm: use zone lock guard in __offline_isolated_pages()

 mm/page_alloc.c     | 53 ++++++++++++-----------------------
 mm/page_isolation.c | 67 +++++++++++++++++++--------------------------
 2 files changed, 45 insertions(+), 75 deletions(-)

-- 
2.52.0


