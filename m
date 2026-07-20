Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44B8C44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07A246B0093; Mon, 20 Jul 2026 03:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0038D6B0095; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82816B0096; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACCF36B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32926A0FE9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:54 +0000 (UTC)
X-FDA: 85008290388.20.E7DF53F
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4FD2A4000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pIhmi5yybX0+Z17oaXCunzkOy6HxyIiCIqArkySVkpw=;
	b=B+dEDteCeuVEKlN02p6RRS/th64fBI1ZRCnBuBxwB1KcAVoOO+UL7wR+26KneQ88Swgux2
	C2ORQhZ6Kbx9XH+eJbe72BG+IeGxTeuF9Qchp3JzKorUkDY4HWCEdM2SMV3UEL6F5leMk6
	616rd2EQeeRZAhXPpyxFSNKRQhqsEHM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531632;
	b=Z/Eis6L1kno/7H+RD6axMiIGrIb+cZg2I4BgOyrtNxJ+uHlYUWg+YnxiHBLKsLNLJzMK4f
	rSf8vitxFewBZYnERTxymbe8Sxb9KqtcMK+UqZA4Ny6hy5n8gIOF+twHY7oEHrNQHC8g/n
	RR2fi8dzRSaxyQXxsVRSixxUYof2a98=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h3WvN4gf0zYQtvB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D71EA40776
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgAX4qKnyl1qax5+Bw--.27530S6;
	Mon, 20 Jul 2026 15:13:45 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mm, swap: Remove unneeded swap_extend_table_try_free() in swap_dup_entries_cluster()
Date: Mon, 20 Jul 2026 15:13:42 +0800
Message-Id: <20260720071342.50742-5-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260720071342.50742-1-shikemeng@huaweicloud.com>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAX4qKnyl1qax5+Bw--.27530S6
X-Coremail-Antispam: 1UD129KBjvdXoWruw1rGrW7uF17KFyDAFWrZrb_yoWDGrX_Wa
	95A34kJF45Ja1DG3s7t3WIqr4vgrZYqr15Cr1rJFnIya4UXFWrur17X3srAw1Iqa90v3s5
	Ga1vvF1Sy39xGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbDkFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw
	0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1zpBDUU
	UUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FD2A4000C
X-Stat-Signature: x4kh1qee5wwqa1f5bpcztruwgjez4qqx
X-HE-Tag: 1784531629-62139
X-HE-Meta: U2FsdGVkX18GQy6ak/8/jInySOsTJ66dncuVPu6uzUcwiEdOcMSFIuiLTScaIgCEsdXp76UFiI/05UnhfhI9Xm+2lbAPZOAgAZHL95EhSYh6ADwHuZyjIkGc4Ryuzi2VYw6Fgo3abZRAb9gnNmt7aIntygtjH7uiqi6qN+x7FG2HF4JVl1fvgfLjR+WHtjSt42hzEQHbJRdZ+JXV8rKFWOzcKbn0Nt5d1Ig8PdihcNMZDSCDiMAwBZnHwZSmI4pbULXYaMS74NvNY6u8bzyOfFIOJT+3h7VoEdXGD4GuNZC2lYYe7A/GNqfIyrd75Jdt+MUl+Ct/1Gf5hqHAljqJcXShbB5/Rga/xDB7vYe2uz0Lc6i2gubT1w2E3axMYII9h0aqhEoFhaQ58ew6gwzjXcjCT4tP879JGRtEYitWH8P/kUGmTOlE48yPAZsNmREWKqbqaG797BFMNYDvFCOp2V+Y7LGED+UkELHWv1i8DccmN8l7m+iIpE4/P0S7JKZUVXdeapANitYPla/dxl6i2QEoXC5oafDz0Jhl/7hAWutxa7YuOvWXkBPZn099h63cWKp03j+yVRYSsdpfaHxNJIL/t3j1/ik+jUwdW86jM1ziHqVZLLuHVt2wzFuIGGA2YqjWSxqfyVigwKdiPkjTVDuX7qdyWPHFxLcWXENJPp1GvLjpzf8SuLe4EOl6WWGljpCS/KOYoNiX7Xm5kpqd6SIQgkmcZPOBOaDE03eh5v+fbAX31QkEghdtd1WjTCbD79IiiSvaWWAaYo1Ee/nmIPn/IO8NqAz4mUYryRvGP2+8JwhGRECymX4gV50BGCN+JMrzkvscTUC4zJIzgkjOgAul0EVNBSnoGeM2r0ahTyu25Ssc9VGnqW3TnPVsV31wGspbhva0cK6fUcrqMiZLSfNl7BVuel3PmKNZH50C7AcqSB+i1cdzGVKqJRBnDFdyApfrog4o9A0EpsNwvBG
 VnKy2zMg
 4vtriJaM+j++OGtnXGz+BBpJWdWO8nviKgx9Hd7Ke5/se6eUrs01JdgzbJWtBGn+aoXF8iz+6WOtR7gC/slnMY/nulLG1tfn9GaZd5laE+Xut6+oyFOcmPZ5XLyI7hBaaWrSJonL277nDBfTA/xVlaxWkNFNno3DiKbnw
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
---
 mm/swapfile.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3fcbd10c6353..fc9f16bc2e4e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1732,7 +1732,6 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 failed:
 	while (ci_off-- > ci_start)
 		__swap_cluster_put_entry(ci, ci_off);
-	swap_extend_table_try_free(ci);
 	swap_cluster_unlock(ci);
 	return err;
 }
-- 
2.36.1


