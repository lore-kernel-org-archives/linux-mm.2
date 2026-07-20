Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66EBC44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EEB6B008C; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15B96B0093; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C956B0095; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58A6B6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:13:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD48740733
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:53 +0000 (UTC)
X-FDA: 85008290346.06.BCDEEA0
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8568D4000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531631;
	b=kKUPeOx/4/1siHRXY79HOkELGEhPpzgmTHjYZYdloL5kxxxDy96oEVrF2BnsIxkZzhyJRS
	qH4hUZGA+H4qy4RtuMll65bH21aujGE6yUq+6Jv2MFsSE6br07gHRrRabPekV8UHeULfX9
	arz0KNV8KFE6oeHouWsDzFUEcZwXuK8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UV36aYiEX6KBPmVYffX62ISYXMfEOTbscL7CJY7VHZY=;
	b=J/zf8pOkiGHpefK7wK/xgEnJDb7Hj+9U1xVpmpkyzThS5Y+SFpCpUPQjXfKHd9etDQswVo
	86wvtmS3QtZLtSh3kWvGdgF3nhr51X6SWatE83zHgq6AV4h/TuF4Nth/Il3LKw+3qcxCLI
	zW9g3mVgkAFPHvhYqXLh8dvQRTmnyP8=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h3Wv52KPYzKHLxq
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 6566740776
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgAX4qKnyl1qax5+Bw--.27530S5;
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
Subject: [PATCH 3/4] mm, swap: return early from swap_extend_table_try_free() on first non-zero entry
Date: Mon, 20 Jul 2026 15:13:41 +0800
Message-Id: <20260720071342.50742-4-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260720071342.50742-1-shikemeng@huaweicloud.com>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAX4qKnyl1qax5+Bw--.27530S5
X-Coremail-Antispam: 1UD129KBjvdXoWrtw1Dur1rAF1rKr1UCryDZFb_yoWDGrg_Aa
	48Zws7JFWYqr1kX39rta47Xr4fKr4fK3Z5WFyktFy2yry5X3y5uFnrXF1DAw48Ka10yFyf
	Aw1qvr17Kw47tjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb6AFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_GF
	yl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWU
	JVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7V
	AKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1sYFtUUUUU=
	=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspamd-Queue-Id: 8568D4000D
X-Rspam-User: 
X-Stat-Signature: 1ejsaznh9utf88abh9qcntpyj3g4opxc
X-Rspamd-Server: rspam03
X-HE-Tag: 1784531629-53957
X-HE-Meta: U2FsdGVkX1/vTbuGxGEFxHCtS0sXFCS6LdLoigbaD76ljHw5TNqGMlTJychFwfcCASyGcPBJEeHpFUTJYPgu5EvSeapFih2WqoMskoDdf2RCwLhKy+Vsr74YYNxpWZaiWYC1M0wdMqD2Yx47XcnSqO8zYHEnR7alsDHn4UPnvU6X2QQRuzvQueZpxER7NnTkdvUXleRIsAEc1pgI6zONNvFe8F9cBBK96ZoY3WSt2lZssdDCXFZW0SMo/RJswbHPBPMZxRJ4YSoGYg4rrcebOhIPAFO2pcgsO8ikU2kXpTgIXCrYIuJSF1eHnrN9luuBA3T4O8G0YqE0mpLFWc9gIJhCEXua4Iel/mHSVNDf//MNR+xarRIToMz9dh/29boDg264D6MbRUpYqrdB5nRZnUR4L1GqWVNAjC0oP13RTk+Tiy9DmW3xjadJEZCCs3oYfqbawPd8s53Xm3q4c2F3Pu6mXCx+K7sH5CLqYx26NGXC4GpVENDvAu8YJFdMNBfDVD8KWfN6Q2lvDDDI1il/JlElAW8X7UWndc6M7CGK1RQXKMMek8FeFv3JwgSc4iSz26tuQGrEvRV+P+nwlleAHcNw+VApDDXZzNcoWDiWeoS6CiQsKbk4OP1sLfZTbv2Wd4MJDZNByXPglMhH/TrH9hG+Wpzd3sdD1T2vnG9VPanDYG9QcPuxQ3EJOf8TBG5GtGnq2/rdBlnsZNtGbcIfyqMDVjDJBx/KNa/mhvOUcx+9L0YmUs4rl7xKT9LGyH3V35hIz1I2SXvNSYzF+NyUZPY9s9h+sqOCdwDGJeBjfqOwhc4V0X9NeMrFaYiLlR/iEOngJF75HtkMef1Het4yVdiUJtPF0LYy5+kH+K7HqhnPh8adAdGuaviBpHIxUTgcQddD/8r/T7XcuoM3kGUIBAOiKuqUkS7a1Pxx2QfKUlXk+JNRecWmryf1kPRunqZXAtLu8wOORuRseXbGdRp
 yatFOfIy
 OeqF1Zo6VjgmS2NBkbA90lTZBf2YdQXY0rxt+nj9VSVfBmciNyiYbJfuiAIrlRrUlGlo1XP8up7dqBiih+6o1qCEHsYmCohG85TKe/fl+Vp5AAYeMNpTxMeS150Vyl/mlfZ3k5F2w975TV24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Return immediately when the first non-zero swap count is found as
any non-zero swap count prevents freeing extend_table and further
iteration is pointless.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
---
 mm/swapfile.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 81c4040912be..3fcbd10c6353 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1530,20 +1530,17 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 static void swap_extend_table_try_free(struct swap_cluster_info *ci)
 {
 	unsigned long i;
-	bool can_free = true;
 
 	if (!ci->extend_table)
 		return;
 
 	for (i = 0; i < SWAPFILE_CLUSTER; i++) {
 		if (ci->extend_table[i])
-			can_free = false;
+			return;
 	}
 
-	if (can_free) {
-		kfree(ci->extend_table);
-		ci->extend_table = NULL;
-	}
+	kfree(ci->extend_table);
+	ci->extend_table = NULL;
 }
 
 /* Decrease the swap count of one slot, without freeing it */
-- 
2.36.1


