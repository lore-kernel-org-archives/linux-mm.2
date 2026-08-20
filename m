Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29F04C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58F96B00A1; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A6C6B00A3; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A360B6B00A5; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67CBF6B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:55:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9546C011B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:16 +0000 (UTC)
X-FDA: 85121492232.13.5C9B63E
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38FE5C000C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787226915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LRM7qWz88PSwBw2lb447LqN110FZmajRF5TshFNbXu4=;
	b=xHZzyUS/lD3fAYQdg7yz8pqAbPqzMyUy0RCBvzQzstzF7H5hmgd3AhgDrPosjAt+4cKdRz
	YVCVQYYeeAGl5vaq5Z/pnkAU4K52nWto4uMqBSeQ6LkB2fQtgw6zZyz2dhP4g1lYSqZ7Ge
	bQTpZjm7GOQR7oeA6DD5iLFhyUBy6TI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787226915;
	b=W0ISAZavYnU2qiCdfp2ABx+i7LmNeIpxwKBgUN4jGrrXppknC03aO49VYqaE2EhtYXundK
	OXdSo4pD+dQtFdu2bi5wRQ1EAKix3zCvdz9SPO/asRbC2bl1/U6JVQsg7vVPKZm4VrsWX7
	0MJAVTKLXkPlD3ry2Ix8OsBtOJ4d6SE=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hQhgh1V7zzKHMTC
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:54:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id DD5D940592
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:55:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP1 (Coremail) with UTF8SMTPA id cCh0CgAH99Ib64ZqI3IEDA--.64911S6;
	Thu, 20 Aug 2026 19:55:10 +0800 (CST)
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
Subject: [PATCH v2 4/4] mm, swap: Remove unneeded swap_extend_table_try_free() in swap_dup_entries_cluster()
Date: Thu, 20 Aug 2026 19:55:05 +0800
Message-Id: <20260820115505.20027-5-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260820115505.20027-1-shikemeng@huaweicloud.com>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAH99Ib64ZqI3IEDA--.64911S6
X-Coremail-Antispam: 1UD129KBjvdXoWruw1rGrW7uF17KFyDAFWrZrb_yoWDZrb_Ca
	95u3s7JrW5J3WkG3s7t3WIqrWvgrZYqr1Ykr1rtFnaya4UXFWruF17X3srA34Iq390v3s5
	Aa1vvF1SyrZrGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbD8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr
	1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUljgxUUUUU
	=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Stat-Signature: fo7bu4p1ac56gdk6jc9bfuaigyrsbm6t
X-Rspamd-Queue-Id: 38FE5C000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787226913-304837
X-HE-Meta: U2FsdGVkX1+/YbXWYR9lTeVXzYKtoifx1TcE7yiv8RJ8yRXWlKuFNqAx0vGZLtm/HCZYQC2Pp1cmrqszMG1rsp8hkOOQklQ1pIlyhwaV1hCwi4gqK/Ml5jFIZ6lxwVI6cJaE72EdF9Grw1ABivACEuZgk1toho5ybc7PoRC4wS2PstlQ8vaN8frWOEcb0Fy3mxtIw/VVI0E+t9Jgrkzq5P1pHiqIHPbQQuqxGZwv1rGYgtyFzyRUWhwRhgnbpcCmLDPvB0FnrQbULFBEJ4mMBNh+2KXEEnXcbQ1ogLPckdi1RDvrNo2R0CayGWv/JoUj5kgwIEfHwwtnqSNUiAtH8ZSuL8MkE0nBbviKn0O/uayNC6f7kurpk959zM8dC/Ghoi3z5YRly0fjBJ4fkpUcVf2vKsIJ+FMqd+DczVlzVAJlwNy0xNk4G0d6UslPH+8Q+WSWhe7vr2m8ncAAfX47zdAVVSXONy8WIxlUur5+Fza7EVBPGw8wqGbWaGfj9kXD1DZwwJHU7Kvq6PaWKdxVkgO4/plxn9ND2x9bOmotWico8nK5X1qd1wjxyEYpbucDoizO2D2CmIaewfa3txGmdEstLUoyr0gjMDhK2TKs2OnBbFDunS2JN8hNen6qgOtqIxXXiKvDAWfv9wkCCwgVB5pOvMnHRc5Dq0KlR8Wr14/iV1Mkni0EAkf8q4/50wzrHfmZEMmCnK91t5uPMEZqZc+xVD6NhUud3wN0TPNbaYDEUmM7CmUMi1jcnaWgdTQmcLfSESlYrfnhH/2ZpkRvtlU4pGigR7Ps6jCeBqf0u2+DPS+kIaeEm2zDS4BM241OpJJmVq9ic7b7LG3VfLkcxE705xTwXcGAKalmyi7XzGRaPoqq0E1splAcfCVDmqg0G3iGwNZNWPuXU+ifjwlgs/OY7Z3YS9cEZ5/JIV83JTOGzgmiK1aj1Wh2AIQ66KYS+76MSOIp0+JPhvEvMtO
 LKHH81Qi
 jjVB2fa2ZDQqugD+GyTTVB7LhFsfbb4CXAQKKQbkmEwS6/FRTqq5M7ucO2kXPHKYs7PLiEzO1MipG8lS+9RecET92v1/6yFRB9mz7FUImjMOhIvMDWLWBqggm4MVEdJGNr/Yu2hYf1oSB5V3zmRbRnzeK5Kyx3M2Srl42746VSMzfYMtHsfombXb27B7cAZE+djXA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 0475fde0f68de ("mm, swap: avoid leaving unused extend table
after alloc race"), extend table is always allocated when any swap count
reach MAX - 1 and is always freed when swap count decrease to MAX - 1
or MAX - 2 with cluster lock held. So the extend table will always be
freed properly when decrease swap count in __swap_cluster_put_entry().
So swap_extend_table_try_free() outside of __swap_cluster_put_entry()
is unneeded and can be removed.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9f43ab43b927..9f829b008de1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1717,7 +1717,6 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 failed:
 	while (ci_off-- > ci_start)
 		__swap_cluster_put_entry(ci, ci_off);
-	swap_extend_table_try_free(ci);
 	swap_cluster_unlock(ci);
 	return err;
 }
-- 
2.36.1


