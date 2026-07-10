Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8806EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 07:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551B16B0088; Fri, 10 Jul 2026 03:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502A46B008A; Fri, 10 Jul 2026 03:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419416B008C; Fri, 10 Jul 2026 03:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 229D06B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:14:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 996BAC1FFD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:14:08 +0000 (UTC)
X-FDA: 84972002976.18.EA7A9EB
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F3CFC0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:14:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=dv72agwx;
	spf=pass (imf10.hostedemail.com: domain of hao_zhang_kdev@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=hao_zhang_kdev@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783667647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DTERVdrZLZFLb9jkOolEdmjc6s9xd2WMQrsJO/ruk6U=;
	b=74ElMvG7VcfeQ6zXMNQ+1PNgqq7J3opJvEuVQq8B1G2E/hTu+w7limk43w/1bVqmg2Lbh5
	tAFKVO6KCNheiXRs2o6hBhJCzK+OVX1Ed7pHTzBUF7ssHJYkQhD6cJ5WrANrYHz2YmBMMG
	7gcSjbzlLlhqPzdkv4IunCGMLb5h5Ls=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=dv72agwx;
	spf=pass (imf10.hostedemail.com: domain of hao_zhang_kdev@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=hao_zhang_kdev@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783667647;
	b=0RLer+lHaEt+5Zb6MW8N2Ika8AZTQp0CIp0u/xbEFlIzAZ9GV8UIN9NDhvDb+YnhYTtbPL
	a9Vk6juIpy2WYV+NeNhB9cp+eg0hixiHczed8GTirb2znBATTah+vU+i62EbNiq8cCmfAb
	5Tj23rtj3bD1LCl6xzQXw6lu+ZlVF5A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=DTERVdrZLZFLb9jkOolEdmjc6s9xd2WMQrsJO/ruk6U=;
	b=dv72agwxrtAFTgZrnj+ut2rHvI72aKE5S3EKUfTSuXhGHov3PZDJ9KfS389p/G
	Hjd++Ru6hJJUsYGTdJ4d7BC01ONA/IlLNptlznnvffvGW1teI7MD71Snl95LKNNz
	Ulr/AQI5Loj6Y1dnaOhdt1SykTDGPrW7lD3CRWqeT7XsA=
Received: from zh-pc (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wA3+Yaom1BqiseaIQ--.9100S2;
	Fri, 10 Jul 2026 15:13:46 +0800 (CST)
Date: Fri, 10 Jul 2026 15:13:44 +0800
From: Hao Zhang <hao_zhang_kdev@163.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH] mm: thp: unlock i_mmap before releasing split folios
Message-ID: <20260710071344.GA106129@zh-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-CM-TRANSID:_____wA3+Yaom1BqiseaIQ--.9100S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF18AF4UtFW8WFyfWry7GFg_yoW8tF17pr
	yYgrZxGr4kWrsY9F4xAr1q9r1rGa4Fgay5CFy7tan3Z3Z5X3W7KFW8AFW8X34Utrn3JFW8
	Xr45ZFWkWa4jv3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jAwIDUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pkdrs65kdqwshngh4qqrwthudrp/xtbC+gq-smpQm6oGRAAA30
X-Stat-Signature: omgdtyib3g7mmjbh41wko7uzg9omihqw
X-Rspamd-Queue-Id: 0F3CFC0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783667645-598152
X-HE-Meta: U2FsdGVkX1+Q3lVeACe5cpJx67Tvlx6emjI9pQrYCgCRGgMwR7+lKZIrGJoG9OQkoxiMyUUgkT8prcR0xlN8pjtM+Pp2ioVQ+KefNve+yUUzBLi1j8KNNKsrI3+RUaFGdZgwmBhOdmITd9rAUIxRwGkUXBQqGqkmMFpuSyLSKcKZXYVLfpV7uiVDB9fZbkcnKNxLYUTtjA+kQjtWtO30bf0fCSQg9qRq1q8qG39l3axG2WA7kTTPiKvQZF0OqOj3fGco8J0ge8TubA17FLKal6HNyMu3N4i73TEWarp+N2ZcGKfOtZ+rRtpqRgvIK+pwGevnmu4OxfjSJHbUxcPE9K5B7Z8N6d2kpI3iWTWOWhFFGoqsPF5Fhy6i67zrDbnvTnqK7tNZT+06OH0MnvEYwqX4BzuZh3QgUWHhANBsX56fiI2zqlKm0IQe4yJBw+ovjTe8Ziyw9V4d4NTp1jmqegFF2lYZSmY7/3pVO5PZiBE+65Ffut1LoD/t6r9V2Kgi4w+ZJn8ZFIB47b2N0GmqeHj3BtufZIT3HT17zTSaQMP8/59BNXXD1kjJ15q7wQ8Fa8dIGO+taHDR1GtVD26GGqUFc6seIjX1LuktqvG/0jj39VXc5G213wFlp01pFunwfmqO5ryLyQwSpf72lVY43V/v6Li1Pb6rUgr4W5cThh/6LZ/swGAzZ6vIRQjgjFrkINGd8seWZVhFlUCqBdKFUbW9MudoFEQUCh3EKDgBOkVx5pLEKGX0iMn1el8+A3SWJNFzNF+mj6v8lhiEW/YlYZiRuG0aJDxIC/Wj6hqUYgssRxIYeNkgdkg9i2l+I4w23uiRCtcA1QYj7ROT3AEAR13/mvWAxiI8WmmKN096NoF/8M9UT40gdhu1A0WinipCMAmITmcnbPVOgUk85+kpvXKLGS6HuQQBixq5BoV+ZHfWSqHvt0s35tg0jfcHJmjFZMp/l0jgDSkzxdPU4Hd
 wFHf+la1
 eXE8mKmQPnoatcBvQCbkj3Dxc+9db3Xud/WyMhcBcPYnu4sW9fSBhau4NudgixBW8XX16pUk6yExZkV9M0ZmOY6biYWa01vjKkVedAKc7ZFoctcsp4OqVBguGnaEFmkS6H8dklZK0t1TqtpA8vy4jqVUyLlgApRCW0dDYqNahN9QAdj6W5aIc22Exs93dsX/3pElZ9AwMbQqAiYV8wU1KnhHuoVbS+dpOaNshmHXkxI8+rb2CChf/TxDMzUywh8wsofrbNlCc95/8gc6Kigi76uwT2fMIW8o0cjTTaVLUPa5BiMriCBoVM+cWnFRosdz0swQ61mc9a6Kg2XNCErR+/8cMXHDvUgTiBoHEJGBj/B2IK9FkoikUjfN1zt5JUgf0Vm+O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Zhang <zhanghao1@kylinos.cn>
Date: Thu, 9 Jul 2026 16:30:00 +0800

__folio_split() takes mapping->i_mmap_rwsem while unmapping and
splitting a file-backed large folio. The lock is currently released
only after the split folios that are not returned locked to the caller
have been unlocked and put.

That leaves a lifetime hole. Once the split folios are unlocked and
their references are dropped, inode eviction can make progress through
the final page-cache truncation path. After the folios are removed from
the page cache and the last inode reference is dropped, the inode that
embeds the address_space can be freed after an RCU grace period. A later
i_mmap_unlock_read(mapping) then dereferences mapping->i_mmap_rwsem
from freed memory.

A possible race is:

  CPU0                                    CPU1
  __folio_split()
    i_mmap_lock_read(mapping)
    ...
    remap_page()
    folio_unlock(new_folio)
    free_folio_and_swap_cache(new_folio)
                                          evict inode
                                          truncate_inode_pages_final()
                                          destroy_inode()
                                          call_rcu()
                                          RCU callback frees inode
    i_mmap_unlock_read(mapping)

Release mapping->i_mmap_rwsem after the page-cache and reverse-mapping
work has completed, but before unlocking and putting any of the split
folios. Clear the local mapping pointer after the early unlock so the
common exit path does not unlock it a second time.

Tested with syz-repro on the two available crash logs; neither reproduced
the __folio_split KASAN report on the patched kernel.

Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
---
 mm/huge_memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..fadc067df179 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4109,6 +4109,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	remap_page(folio, 1 << old_order, ttu_flags);
 
+	if (mapping) {
+		i_mmap_unlock_read(mapping);
+		mapping = NULL;
+	}
+
 	/*
 	 * Unlock all after-split folios except the one containing
 	 * @lock_at page. If @folio is not split, it will be kept locked.

base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.15.0


