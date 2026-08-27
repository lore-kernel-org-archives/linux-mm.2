Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E83CC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A156B0092; Thu, 27 Aug 2026 04:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551526B0095; Thu, 27 Aug 2026 04:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F6B6B0096; Thu, 27 Aug 2026 04:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30B6E6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:06:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B58BE120382
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:06:50 +0000 (UTC)
X-FDA: 85146318180.18.7E5B84E
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id 61A991A0007
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:06:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YSfrzoIv;
	spf=pass (imf19.hostedemail.com: domain of yuehaibing@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=yuehaibing@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787818009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iqJEGxzt/5Md+xChD1VBbpbC9+3Knut6ftXuGJ5kJuw=;
	b=UKDcXZcuSl5/ji+aqIPR54lVT0MP/lt96hPS5icq0BA8qZHrpZfH7uPjPzeqE7aqCAGGrZ
	VsylzhiqCqKsFYU8o3PohrYBQYF1v3NU/h74W7k5yw1eHUX57a+pm89OtluN11nm8F9kOh
	HP7lCVsh0bBJQolmiN5TxUbcbvc8o5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787818009;
	b=EEG+x3UlXP5XskbFk23v5UcDV2kFR10Tpxf6msFFRU5kAV2uG2qvgVaEwJKv+ClrsBjJ9O
	6HKfQUjqrtbMJF1EbKgL1baczUJwye7SxLzWogXq3CocZ9j11dk0fXkhzEugAXDrNnlNmb
	vrJv1RRzZlYI5pTuY6SLn96cCqohbYw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=YSfrzoIv;
	spf=pass (imf19.hostedemail.com: domain of yuehaibing@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=yuehaibing@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iqJEGxzt/5Md+xChD1VBbpbC9+3Knut6ftXuGJ5kJuw=;
	b=YSfrzoIvlCPYebNJfeCnPgUuoNU29ch67w2ddM8IcF2HJXxbPV3FpyKWY1JOFtoEklHPMem6F
	onBgmKK1OzuZuC+MmyRSYmHSC9fM9H+iJ8xvfJ/s9lI0hWwSlwDbEWtB0zucyvIAEAP1FmDT8fx
	f90JjgwrAs1WnGgPQFYXdD0=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hVv2z2mw3z1K9Ws;
	Thu, 27 Aug 2026 15:55:55 +0800 (CST)
Received: from kwepemk100014.china.huawei.com (unknown [7.202.194.62])
	by mail.maildlp.com (Postfix) with ESMTPS id BBF99402AB;
	Thu, 27 Aug 2026 16:06:41 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemk100014.china.huawei.com
 (7.202.194.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 16:06:41 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <akpm@linux-foundation.org>, <chrisl@kernel.org>, <kasong@tencent.com>,
	<shikemeng@huaweicloud.com>, <nphamcs@gmail.com>, <baoquan.he@linux.dev>,
	<baohua@kernel.org>, <youngjun.park@lge.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] mm/swap: Remove unused declaration swapcache_clear()
Date: Thu, 27 Aug 2026 16:27:22 +0800
Message-ID: <20260827082722.1809702-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.128]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk100014.china.huawei.com (7.202.194.62)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61A991A0007
X-Stat-Signature: ouoangojn4quiix9mndgkax7wson1raz
X-HE-Tag: 1787818007-582680
X-HE-Meta: U2FsdGVkX19qqvaWJ7KI78BMopAF1HkpVYZt55ZW8DrOLU7ZZCS9dZ+1SP06AxVOIgQAVKLtkOBOdNC0B6+zwcfqmnOeAxQ6ld7aYN/RAP35wsawuzov/hxL3ieiDID+uVf+4k6gklqV+g+iWSF4PX2o7i+JqQfkWeTPpzC1KT6DLOYQwV7B6ay8a6ohLdn3zoXAyWgfoLmmtB9G23ZJfTAwlWr4sqNjUvadlDm9PsQ7NfwLCQyVzavzY1bfhQKP3w2Fnh1yL0rEletgyNug6bgZwtFhtW8YuvdDVLc39XN3+cHXRgx9j9Hlv94wFU+D6bKvy1gQbIIy5ZlBBnCOD0yXPF7m4x1eorLVvHvlFdKrxYI4Y63GfCxs8ke3vn4M872/nxyYVab2oIrIhzuInuTgYVjiuC79htdoJl9x7ybL45dURkEuox9b4V1qrU2h/3r5gdIO2PIHEEnyEYU9k0rtByN6ZTrRRPfYk/1NAe7jwpUkQgp3tEQ8aejaykTzgJ5osKKfU7KQnLk0kG0Or26j5f5QawuxoqMRyaMVv/N+V+6RwUCYWWixxjfArHP+ARs2jmSCan5D0o+0iYXOVuRDuNnCaJaKB5nfo4hefnD8jBiYRp5td+mIjX2/G/kKs40rS9tmJ6GFXPWdrx92mwpF/KR2jbVZR2GgeOO3+M+GcVeigAFQ6JuwG0gsBVRL8lWIhwvk9dRMNCyjIHpEPeaf/fKzzTNHp21uIT/sSynf3YGBob4ebOo1EwmWnYdtwgwpWPGMg9auOkW8Udx3pPfMDKx6H3zZ76KdjCoAuscBfYTRuyuPr5gaX59NCNiWf0UvszZwLnd92yDUHpifKr8++3T8SZMf1JGXff6STBJt2a32bO0hPmylgxFTbJMTsmi+cYWoXA9mpgttkOlhUSLx5bOIZ+Wi8y0BPMsoUgu1H9fL+BUq1Rv1uwG4jkjKuvkIJ/YWJQUDjuDigAn
 W7aOzKBh
 Cg3vbz/KSvqMIja2K4Y5+ckc7i1ssuCr7iPAdJEK8/ZJT+vt4Yh9ji2cvvuNVBDNksEdIAU0VHOs0ZaSt2VzjitwNm2d/UzrfavJuYjZaer56x/LDni1ONUJPtvqhmCnZ8PzPUhuolVOAZ1r2/egrvW4UebGt91d/AoHeEc4twu37aITvnYE7BXnHS6e+PXyHcji83OFKLWVWm96phOQkioYCa1xWgq0qe0XnD5c5ZhpKU9H7W4BfccUvXBcEbLYXC67AeIyEqTDUhLIpzSlhpgvaosmqq32Qh/QPRpOCmpxqTxsS98o5iF00P7w6G83+2T6wY3+HGfM/tutGnZa4EAVDCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit c246d236b18b ("mm/shmem: never bypass the swap cache for
SWP_SYNCHRONOUS_IO") removed the implementations but leave this.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 mm/swap.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/swap.h b/mm/swap.h
index d077e5893a42..29060a305443 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -344,7 +344,6 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
 
 void show_swap_cache_info(void);
-void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
 struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t entry,
 		gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long addr);
 struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
-- 
2.34.1


