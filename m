Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF20EC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43C86B009D; Thu, 20 Aug 2026 07:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4CE6B009F; Thu, 20 Aug 2026 07:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0AF66B00A0; Thu, 20 Aug 2026 07:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A40FD6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:55:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D43D1C00AF
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:16 +0000 (UTC)
X-FDA: 85121492232.21.B84AA95
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8C11C0009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:55:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787226914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0uzpbXOHUTuX4zHqPZ1Nv2bRdLW8r8fSAKBuCmCQglg=;
	b=eNFC2YPoano/vicrBQ7O+Blia4ORgHyP7AiNHps2BEtf45ZE08WipqZR5A3aURYMV5kkNq
	vj/JejaZYOBGQM2qxXiSuDITHLP7pW11gIV5N58JsvrM05JsPM6KCyaeyls2r4GCQHYR+O
	zzzyZ7NADz4SSsMR0BaawdW8D1eLgDs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787226914;
	b=Eo6Son1KWITcSg+5BMraJUczdT6oe8U1ss7aMBYNw1Mvg07nJVWFqbqg1F3JmT98gNAElR
	TmkGG+R56Hl14cgdqneNCwudgsKmUihv6R5LCUjMbRZhQf98JDCTcYcuuL2io/hQ+D11xW
	BLkB9FGpalOJqwiQlwWQFJJENZG2ExY=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hQhgv0TwXzYQtqm
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:54:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C227A4056D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:55:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP1 (Coremail) with UTF8SMTPA id cCh0CgAH99Ib64ZqI3IEDA--.64911S4;
	Thu, 20 Aug 2026 19:55:09 +0800 (CST)
From: Kemeng Shi <shikemeng@huaweicloud.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2 2/4] mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
Date: Thu, 20 Aug 2026 19:55:03 +0800
Message-Id: <20260820115505.20027-3-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260820115505.20027-1-shikemeng@huaweicloud.com>
References: <20260820115505.20027-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAH99Ib64ZqI3IEDA--.64911S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWrJFy7Zr4xur4UXF13Arb_yoW8XryfpF
	n3Was8Cr48Jr1fWw48Zw1UWa4rWwnYkF1UJanxXr43uwn7Jr10gryft3Z8Arn8Grn5AFWq
	gw1Iy34xuF1q9wUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUI1v3UUUUU=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Queue-Id: D8C11C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: ykk6t4oheyi7s44noqfyjgxh1jfd41c5
X-HE-Tag: 1787226912-394303
X-HE-Meta: U2FsdGVkX199MR1kZQCqhQ/r8IMD5L5VTyoYQaPC1RDy4bHGEVsNC5pCzbZTzq7tY4qGzJJ3EmywvaGq89AKEZca1LXSBf7/BH22BIchx/ffcL+PoF+ltLA7lZahUdd8G5VNaGptzCjXkwMtZgg75yrETI2SqzbbHTEOamd5nWR2r9DVkcbWz9gJ2yf2z1TLq0I3TQvJcuj4Jv5BVqh/usVRGisE/o7mo5GwjH9AvfJaYZXY0WL1QBjY0bT/wzKn+VWx4NvXDpQLeFtafbeW85YuVMQbKef1s/v0IVJL7ayBdd96OJTbrGrjtzVZRQGlmjW4ygfem58x0ugcoDW2dcCFBpk8mVaW4VTR/5k37bORDVIKo+jHr1/U67B1GjDf3FQIFHw1mSrl9lNc5VRdZjMPj00fON2XPnKl9Y44gNaNdItSSeLk6sVnolYvqnHazlb/Ug/f4Aa8Dh+9YTOpDmQlMmqknrt7nxnAO+xrHDPkQrDylO2t9j3UqnOpODAMlGDTb62XH2fZbpVr0dJIwepaU5wpPnglKF05/HTSybq8irvIa6IvsxXzz5Hz4crlDycKikck+T4GQc9QCl4CkgLXmFW7xaaK33ypCvs0iXJaVF+kJUBFS02rImIiupDvueaLelZa++LEUgbfW20hqqZdHkL435nYGdMGtCLkwQRSKbPcmPo3cey70Y7LlVepl8bRHBL7eCp0qrE07GLHnB78XdCUO/be5hx+oTf6MZwEJDd/3P3YjSj7T/79JCvRXp7ENNhjrWCJuvuuBxH8DeDaqwzR4/wwidlhQI0RKmvrNtB9dcgEhj6bIhe72O8tPuAGTKfAeCigsbGSuCeCySg9i6RD70D80VdOkKAPvEPSe4zy7lYtM56Bhkm3mDp/pvXurB+mjwp9mKvKzAHIipYvX9X2OL3XiOILwg/EABZmMhO0zF+RQuBnThGs/TvB3fGMIaf4GKdCtzccuPK
 sItBaC9I
 OJcQHZeCrrUGWhVM4basCiJIqjDudR0vXfnQ7lgR5LDyChc+vP+iTTcihO6sLXI1JmgVUyn9Gp79fszKYNKGD2C59BcqVUfHAX+4Kp7nO8E0IO4LwDoI8xMmKnzC5Im3WgRmJ57x1oysDD6xaR9ig9LKJeTqMkFlqf5yS
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
---
 mm/swapfile.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4561c864f806..e9554c28e6eb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3592,11 +3592,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	maxpages = si->max;
 
-	/* Set up the swap cluster info */
-	error = setup_swap_clusters_info(si, swap_header, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3610,6 +3605,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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


