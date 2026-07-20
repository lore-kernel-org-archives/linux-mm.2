Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D93C44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BD76B008A; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22AD6B008C; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C382F6B0092; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 979B06B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:13:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0C808079A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:52 +0000 (UTC)
X-FDA: 85008290304.12.C8FBF1E
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id B2BBDC0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:13:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784531630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6PLrbNTjdwvc6wH0+CG4IlUr4wDdrc9ncu7Kn5xBFh0=;
	b=lP2bNELvLtUwVgeF25Of1JqI19WVP1X5BfFzGATuP5UCQ9pYn7wVbbJ4eW3Zyiw0Mm4QND
	KdU85jd+Rno10mKqcUQNHcOulWDEGeuF/MPMg18GslT5wzEms/TA5CP4Htolx3kHsKB2eh
	a5DwegFHjIDc66S/mrzhr54jnQZAhaw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784531630;
	b=UlAaQwsqnaJ0qVPSNnbkVccOkI8f9luj1qOr76PYvhCnmiBzuVudqykIxbnShdhxFNkvoE
	9wSUCk2SBpSsx30J2igM9vBRmifclX9SsW/RkcDI9acCNbLnX8JIKTVqIhObnVP12z7Ro8
	avYvl1Db01vsw0FPE6xgaxKun0LWqik=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of shikemeng@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=shikemeng@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h3WvM533TzYQtvV
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id E1F2D40776
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.166.163.161])
	by APP3 (Coremail) with UTF8SMTPA id _Ch0CgAX4qKnyl1qax5+Bw--.27530S4;
	Mon, 20 Jul 2026 15:13:44 +0800 (CST)
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
Subject: [PATCH 2/4] mm, swap: Move setup_swap_clusters_info() after SWP_SOLIDSTATE initialization
Date: Mon, 20 Jul 2026 15:13:40 +0800
Message-Id: <20260720071342.50742-3-shikemeng@huaweicloud.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20260720071342.50742-1-shikemeng@huaweicloud.com>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAX4qKnyl1qax5+Bw--.27530S4
X-Coremail-Antispam: 1UD129KBjvJXoW7urWrJFy7Zr4xZF4DXr18Zrb_yoW8GF4DpF
	n5Kas8Cr4Utr1fWw48Aw1DW34Ygw1FkF4Utay3Xw43uwn7Ar1Igryrt3Z8Zrn8GFn5AFWD
	Ww1xZ3s7uF1q9wUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r1q6r
	43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUTE__UUUUU
	=
X-CM-SenderInfo: 5vklyvpphqwq5kxd4v5lfo033gof0z/
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2BBDC0002
X-Stat-Signature: jd55ogqmzesoqdhnkasqdqwxc7x5dbq6
X-HE-Tag: 1784531629-85433
X-HE-Meta: U2FsdGVkX1/KXB6UWsOUKtani5WZA4anBekTsj6I0vCQ62FQc9k8KfItI0DXFY1n+WYReIAvId5HXKB43VycrDdILI+4zSxEONM3u6X4OZvYVQxlJhHBh0u0I/rBrnNthyTzpq5yDrKoz4hq0KySLXPZ2cGHna5D84vDb2QlHOjKi9w5BOFhiBMuaGzTVDS8aUCZVGVDpve9IQ5w0BkiHSlDTbPOR+WhHpEuBUkumk4ZSM/lRpWwQrKT3gMoY6lMq18dUFfeJyNpmlSGs8UmfUyLCLsEQH5MqqcwM8+lGNXz4Z/pD2xKhn8jw3E3mWnQVZC8aiVC2IN/oSNFm64CIkgvNNx7Mkf6svLNmRu3UtnTnWapxK9AbG8EhoLQhbQnkd/WDbd7weqm+I32BKNpZ35uNQ/480EUP8eMp3Eu1/0+kETzA12uAIVeljVlTfRa3I+U10J17Q+Eu53ayqrKdGszWi81/XhOFaXnmlUBZqg3bImxM/gDttfBjs/ajhdPqARnwcOhiJmAT+LQPneexV6DEHiqTG85jviqzbNvGqIDR3BZPS5OIpQ1FQsJGX9aPDTf9FZuU9OLB+k0DmXBNppSmNlaZhA44pJ3vQf30veJGnYNH9Vpuew/QRDe5kGy4BvdBw96sgE20BkjozKn5pc7aJM2q/7YYcwp8U5SXDDataXrQ/lX7pqSZzqtwRS4asYlGs2Lfwll7Nm8yoq2bBPkEhKEtIDGl2i+cTamciYB+u96QywUd6sUkAIwzUcdb6J5I+7k6uzLkUh0DLV9CiHCA6FIqRb2JfzRcGxn0jCNOinq3HFX2egj4O84osksxb14OGYXNCTpP4MSVOsV/qXrUH4iZ00cG0k9U7E5hvHNjFcfV00f765DK2tGQA1tZk/lsxPh50wwXue2FLKogKUqhApxNZDEEncFN2HCNoCDzIZOKtgahW1WgqcTBv1nRHSKatmVtICpB5ab5ol
 NeQhxnVM
 rP0Bon5N161Is5/RTAY9b5P3Sab3h3MQyCz12BGdPyrwiJs748hJ8DPGB53NwAHmnXwCJD+IsqR5s+uZwQBJFCgFTkojNOuTHsYmEeJgEFi5+GO/Qdp7mVD9I+BKtU6eCpXUTU1yx9NPRH+U=
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
---
 mm/swapfile.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d29062d9c3cd..81c4040912be 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3607,11 +3607,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	maxpages = si->max;
 
-	/* Set up the swap cluster info */
-	error = setup_swap_clusters_info(si, swap_header, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	if (si->bdev && bdev_stable_writes(si->bdev))
 		si->flags |= SWP_STABLE_WRITES;
 
@@ -3625,6 +3620,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		inced_nr_rotate_swap = true;
 	}
 
+	/*
+	 * Set up the swap cluster info. SWP_SOLIDSTATE is used for
+	 * global_cluster allocation
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


