Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AEEC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 09:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2807B6B00A2; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A406B00A0; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120BE6B00A1; Mon,  7 Sep 2026 05:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E96896B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 05:14:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D6591206F3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:08 +0000 (UTC)
X-FDA: 85186404576.01.A3089A2
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5A99A0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:14:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788772446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CM+uIJM9aWfKS4NWExJ7GhZWrUMFFv1jycA9SBfZeTU=;
	b=j7Zz1IwPjNuC4CrJTXu+2SH4Yg1WJZLx/EYzxHWNJznbXYwuCgSf9JjCnmoJ9QRxv7NllP
	llQ9jCGkI1a636eRoaScmlb1qqeanzVOb1vR9mNBGdmJ6qBuovC3fpTo3w7eRoLnGvA4R4
	ZMCm3XesB5L/rUZtmkOx6RSLPlRjYzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788772446;
	b=wq2O4hUCWMU/Jp8Gxzt1ZzfZ8huJ8I9m3Swr/fkW7DvGFK0XJT8GoE+QAaXYbXfdzEgMUM
	2eg9+8hGuRrzTsq9khuZtQQuy+5ShaQbasDT8+gdOt0v2ZXwEubJRjqIJVvIpCrcUZUKJC
	E5qNeulOSD0pclyRL/vAAUtiBT6yMKo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hdhDs341NzKHPbP
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:13:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 627B24057D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:14:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgCnZbNWgJ5qMElGBA--.7816S4;
	Mon, 07 Sep 2026 17:14:01 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Luiz Capitulino <luizcap@redhat.com>,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 2/4] mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
Date: Mon,  7 Sep 2026 17:13:54 +0800
Message-Id: <20260907091356.53026-3-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260907091356.53026-1-shikemeng@huaweicloud.com>
References: <20260907091356.53026-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnZbNWgJ5qMElGBA--.7816S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWrJFy7Zr4xur1kKw1ftFb_yoW8XFy3p3
	Z5Gas8Cw48JF1fWa18Zw1UW34rWwn5KF4UJF4avr43uwn7Jr10gryrt3Z8Ar1DGrn5AFWD
	Ww1I934xuF1Y9wUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
	ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcV
	C2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kfnx
	nUUI43ZEXa7VUj5Ef7UUUUU==
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E5A99A0004
X-Stat-Signature: zr3uz7mqx4ixr1f5q1t5osnkkg7oeidg
X-HE-Tag: 1788772444-859496
X-HE-Meta: U2FsdGVkX1/MVJjpehpQmjjwWx+gwoLG1ZDtR4viz4FngJkUx5+/6kwnOMSMqsqtSXCN5YWb95MgzZTalP07X/geA6+n4rbyPrfJ7qxo5qoWNYrzfwZaw38a4DBbxCJDIL78k5Xkimz5AMUxiXu4FZapquDTJQT/HIwbUARoDbhbv54uEFx4ple0UOYcjKH5L4SwWD7Ew1F2B5eDOAz2pheMgvHU/jsb5zNjSB2ce6zRAlsL3eh1zKxdVWAGeRtxKx/KUwrQWVjIaKGzIKVbTyzCa6cv0ONCAi4HNu8Iqe0ep9cid+8mUiFh1MmWhggv7ady2wG7/s9/LNSiTEHgWCR3IeUILmAxV0oU8v/wI8kWe23Avny5/F79VzjNiBDu4Yks1Nsauf5ovx9A43n3LFs3MoliVrkCOAkyA1Cic28wBH2xYdSFxo4sbkiYUmQvUV9MsoHPOlfM3joyy7UKxBEB4HjSwMtYETAIJ9T6a2vyOUWF7aDlYmcOwAv/cy3G0vgEwQXPC/jblx9EDV397qe8wZdigJQ9dEh38YJtKFIL8qwjIh315vtofbmMugSQgGX6Vm18lfOI2pkVqjFLMVIaQbeWj+cBpsMiizKrz0d5vhp7c8/0ravYBdasrCcdAn7wddMlNr9+tSR3o0Fao+IfbgDu58Hzq0E5+FvjDt+jKAjbKm46A6PERken0oWIC0XJDeroWGdktd9ZyuD9ErG/FWcFb31deW02gLbaCvos/hxjKE9LqPEkQzW7I733M9z2IpfHdGg51KLi+u1uEYz3CZtlfv4ae750h8es81q+BaF4burY2QN5poLTEOrOUB8daa6sPSEAkN5p7bDOruP30JMCfnHUqvnCfiX3TrccnH+Ax3/rTEsOWFWANnKV+FhaqTWhPStUVSK5HUhuU68O/6bRYUXCG0vq1l3IiCRZ+KQ8UP4sw/L+RlycwNh7RNVoZ/RwMMAcqdR/NUO
 /DJ9GInX
 q399TuAXuC51LBAJoUKxgf89m2Futvig8P1MiCAbJj9hLxraKDGiBLrCJWNPV8UDHkSoNAfHAWIY8DzAQIGSaG+fB+zeSTuJX82hktA+UsYr0LN2/VpF8pQeWQizg555JV16EqlYrNrOhVpon7nQi/RCwM0itGK4phs0L8347FmfZdEeFELD1FdghCmRTbzDjUXgB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In setup_swap_clusters_info(), SWP_SOLIDSTATE is used to decide
global_cluster allocation. Move setup_swap_clusters_info() after
SWP_SOLIDSTATE initialization to avoid unneeded global_cluster
allocation.

Fixes: 451c6326105b2 ("mm, swap: clean up swapon process and locking")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
Acked-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 45b6154f85ad..767d83d89d0b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3731,11 +3731,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	maxpages = si->max;
 
-	/* Set up the swap cluster info */
-	error = setup_swap_clusters_info(si, swap_header, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3749,6 +3744,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		inced_nr_rotate_swap = true;
 	}
 
+	/*
+	 * Set up the swap cluster info after SWP_ flags handling as
+	 * setup_swap_clusters_info() checks SWP_SOLIDSTATE.
+	 */
+	error = setup_swap_clusters_info(si, swap_header, maxpages);
+	if (error)
+		goto bad_swap_unlock_inode;
+
 	if ((swap_flags & SWAP_FLAG_DISCARD) &&
 	    si->bdev && bdev_max_discard_sectors(si->bdev)) {
 		/*
-- 
2.36.1


