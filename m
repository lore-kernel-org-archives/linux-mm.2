Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A7EC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AAAB6B008C; Thu, 17 Sep 2026 23:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6541F6B0092; Thu, 17 Sep 2026 23:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A436B0093; Thu, 17 Sep 2026 23:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C35C6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:58:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 870E6C0519
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:56 +0000 (UTC)
X-FDA: 85225527072.15.CFD2C48
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf26.hostedemail.com (Postfix) with ESMTP id 03787140002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GrvVkPxf;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703935;
	b=BhhMFLrc0X0zOfTMXvqv+D000vUcScFd42uGQdDGvPnUKmIyUYozuNAxRaDvpbXTEXp32t
	U2UWzuig9IoWCvuExgFBJYEv/tGJx6UPFNxIw3CKt5GhKdU7fwGQXrlDp14UdU6DydpOFi
	QHAo5COkrILxsn3RgLX0QvwCWSWN/mM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GrvVkPxf;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NP5OzPya8rOoaZGJQaokuW0ZH+2iZDJtaFBx3BRmKL4=;
	b=qbquJ76HCTthef53Ijj2o+t9LVLQ637RKi3qIQJKQ+xqTtZPVRpkwXi2PcdpoDqHsgwsCs
	aqcRV92vVHtMAkgZoav3PV16HzwHxwtJtNXuprBtjkUckhJRRmUss+/WjlNiQpW29vr0Up
	1BiewB6JFEA0bJyqyp8nLXgkhDeCum0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703930; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=NP5OzPya8rOoaZGJQaokuW0ZH+2iZDJtaFBx3BRmKL4=;
	b=GrvVkPxfDy8WwBczLWspMdMA32frYawtP1Q3WwSgQHeE97ZeK5oW3S2mkhzqfnARfT6P36gh4OmIfLYrumjiMWqRjMYe8fPkR9sN2ZbdUA+53Uk9vSBbYzWJIApSqa3uGKhcDeg+P+xRVNoCtJy6+uxfEu5jUldK8RgAvTEosfA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9uK4L_1789703928;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9uK4L_1789703928 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:48 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] mm: khugepaged: remove outdated comments and check for shmem
Date: Fri, 18 Sep 2026 11:58:32 +0800
Message-ID: <12bac4614aa4b37490e92051d484f4f2cb215076.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 03787140002
X-Rspam-User: 
X-Stat-Signature: 1wmd4kzfmqqjh58zg7xkfygbzqphcrjr
X-HE-Tag: 1789703932-172265
X-HE-Meta: U2FsdGVkX197R+o8TjsHSs7v4KdK6j1QUz2RvlbPD/3qBUT9yq81sAiWGYKA3ixwCuSeKej44V6obPmXNjO3LobYm9hSyUxrnupHMF5iPcVaFdPak4rk2NLT84V6+tC54kbue5nJ4bWSYFShUIYwuy+DE2IWU13KRvEWsUsiSG0h03oxfkdNcJfICz50hP8t9C0Jk5vujaOVxyLj0XZ3G3qAGefhfAaeaCD9nparoXuP+gTrg/kqkfWzxpjzokYmT/CrgZ8GjbcfjK4njxT8Znorbbkebzolole92zcHASy9EJN8QrbOHjOX7I6BZyt7udZc3moNAG/LgFi4tnWq7mNNyktFaerUykv2u6O9lpgYgpZ9w0OrjxV5Mma+SwX/1NMS95U3FEd8nNdyQbdyyy/eRxgZTlZFDHgdFTF5ywOJSLRxxVSpMHqNWKfT0AFNi8pKqVdVXJ5Jnk5ZKAzeBw4Dsqbna0HToPDZGZUDNuOaBfV9jT9oAf0ndaTSLo+uuZXnNUAuuPBZxid1r8cY4nfJG7hkExcDqr1qVPOviWAch4l8OTqXwM2fH4Plms9lxwaNhMs0oNndpdLihbd8ly3pRE0RvSDbqV3fihp/yJU1BkTsc3qvkm7gy4h4nhQBGv+61lsUoHdvzfoGSA99Jbf2fcUAqTOoW9Ak8u9XGze4zMkTbuP5grb56qn0ZwGuQwCVfXngg9wgz/7Kr5JhDGvTlQ12KKmtDDIvD0JrJeFTbSC4qycack4cQY0/+j58FlM7TzyNBtjBgkR7Vc3W27F5ipGCHCI7UuEVvUW0WYMu4i5qBdxwW0Xc7+onji2VZpWiBiO7RxwwOeua0yGXKwoBawkoDBIsh++QNuDebfFuOcJuGuFXqTP7Jmm4M7INW2xzhc/vTRTbfalaaAWOpYkNRgtXytOauTLb1SywmN4Pyrtm2F6BfLoONbwHbBmMqEkfUmhb9Yk8Tf2hPaC
 oJqlWXgO
 XW7cJr5m0bPi2khBeL0iNUruSzC28vJ9PmEC0xpTmY38KYpwerHe34bTmY2DyY8UaGpJmLI76OfZX5/ATT2wBPWn90lilQcJWUceC21w/wRFSb6+fmHUJs+FXL9FGAFd0LS/hOBO0A5/+oqLF/iB/nk0EIG2TQQ5VkrCIlz9UukLlU13EAZU5rC9INUpZMZ0pCD1SqTp3GKg9RomNzuEKc01PA5Ue3hEXy87eikNvZCeC5hMnEI/iQMJKOTzaPEeKM2NW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit eb92d97f7e6a ("Revert 'tmpfs: don't enable large folios if
not supported'"), all shmem mounts can support large folios unconditionally,
so drop the outdated comments and the check for shmem in collapse_file().

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a3a9e4d93b46..21d75f5b4b4d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2192,12 +2192,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	bool is_shmem = shmem_file(file);
 
 	/*
-	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
-	 *
-	 * TODO: once shmem always calls mapping_set_large_folios() on its
-	 * mapping, the shmem check can be removed.
+	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem.
 	 */
-	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
+	VM_WARN_ON_ONCE(!mapping_pmd_folio_support(mapping));
 	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
 
 	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
-- 
2.47.3


