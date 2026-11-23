Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCD8606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nJRzZN7i
Received: by kanga.kvack.org (Postfix)
	id 6EA716B05BA; Mon, 23 Nov 2026 09:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1C16B05BB; Mon, 23 Nov 2026 09:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7B06B05BC; Mon, 23 Nov 2026 09:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 371F56B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:16:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B68061A08B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:24 +0000 (UTC)
X-FDA: 85466583888.24.9D611E5
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id DAF444000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:16:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nJRzZN7i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443383;
	b=ZQLWsYs4RigvwEuMBcBrmEK3o48KCRh8sniFjFfe+490bUVsXNBfkNxIAY/Xawz/a2QFcz
	XegyVby1/6qxUOa2CAc7sDupOXEsrQyZoe4Sc0ri9A53y9QmujrBae4LJ+hApP9fH61AGy
	QA6WD3g3l7nK1EnvmabC73CVRR5Dg5Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ieYUzrkSoXKds2DyD8v4HVQRsA87EwueP4G/any/Mw=;
	b=ZEMndtGmkVOFAsTOvI7mHUBP0NSRfUdSiDBOyZu9j0i2cZsN8qapmqU3igP6XgNYqCQHMv
	fElnlklsVrikMjBtrKfdm/8bCIqyeEGCiIDIDtQsEzxD9lsLhv2SOMKGgwUDXdLxWaXV/o
	ljRkW5lehgyUJyTDr8x/pNP+BTewcf8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nJRzZN7i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-38644aedba1so4948416eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443382; x=1796048182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ieYUzrkSoXKds2DyD8v4HVQRsA87EwueP4G/any/Mw=;
        b=nJRzZN7isk9hn26QIuz9mpzJByVAqVTQZny2/J3WUJBZeWvXiDgC1PtXRKv/eLEnKa
         pJTLYlDfkqFQehn9aeTzxQ4QrJaTf86+kQRfLPWqaguDOBBF18pBlHen+z0hHyZ88wJg
         TQLNDVqtQBat7p0gjIBzaE+YPOkhdSuBa1XCLX+fVmHte3R9kUh/hLXF7RKKj3VFJRGq
         6/1KLfAz6k0Ricdpv7Kzdv1xKpGBglwKbBjQOVak9DeuM+04+TBZjxP9/O5AxOOLyWZs
         nagyqK9ePpO9Fly0LRJFG6wzGpMM872Rp2rAw4/YO4aJ0avJCFPeMZD/Y1oRUb5nhCA7
         5FDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443382; x=1796048182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ieYUzrkSoXKds2DyD8v4HVQRsA87EwueP4G/any/Mw=;
        b=JzMplL5OzITwpakfnNe8JSY+VE6by1ItlfmI3MuYrRKwF3gq3UAEOMViwCRNYWp+NT
         LUn0CIEBT8B7sN40hIrL7oJl5W+f9olKSP/grZKoytAvwMamf83qHPke2MQt9c2i7bc6
         Nah5OjGxXYD5fFKi4brRc9HZh3YhG7tEK5zhUsyBS3EWpLONTuU2eNBa9qlaWBlkgLwb
         eRw0eKZpfWwJlbBN8H3mNXA76ra6p5wOT6vXvDpVmKdYk7wEOux27ciF3zz1w32SAT4O
         6R2yrioSwWbItINH5DIV0JqvevFlKCdNddLhPkKNy2Zwgyh71OwOcoveS+4SpSXjgsua
         1HlQ==
X-Gm-Message-State: APuU4Z8KS0jj86pAezxHyGKKxXoXxKEIGQJURlZDh6bwXzzjjKRLUn3f
	mA+tTJFDbPrkWsT+J1620oFVuqKtZYlPEsR92l/0MRm1+eIsSZ8M3TASex2HKP21
X-Gm-Gg: AZFdTZcuv3Y3gLwNwurxot/SbL1PjUVCUKK17T++1CJL5FijktXeukUbC4M3Z9Qv7c8
	dOd9OhvbRRMdk10uB6koeCcdrjormVTzvepoJNeOzHuiFNRGyyvKqGe+4rf4OBzsJrseb2ETo8W
	AXfC5VP4jCauQ6dsDZt6Ptl5keUf7TnO4Xf50AwrV85gLhHNQQ8bErqUxzPHkqbDJG7+zOSqzt/
	LdA44Gs7YKT46SxT4I/VntkG7LIthKbRPYr1bH+H06Lq8HhXoxc0VszQfjQrw3Ac6FLmSo0d7Lp
	xHDJbtP4yIAud/NCuWA4RzHu/0UFqMZU9OadJTnT1mdzHwC6sqlOt1NkzM3CjuwNUnd4Xa0aMvk
	R0ReRzHqDPMJW5niRc55XRR23mbg1nnrIeCoKNb6Yos+EcLtItNHuy24d9qIwDqu64rVVqGUXn6
	0lrQ3SEeHcpxv9Q9QKj8kpERNs7AHn4pCUsQ1cLm/GpnuvywiedhpJ+VtSR5xmmBpzJG6QnWvh1
	DB0gXnINceLIASHTfeMfF+QLhvx6Cmm+kyPRIfU7w7PpX4KnoypeI+AWo/HEneEkh3kDaDYY6W0
	1GGXojrZoAz+MvrpDobcHXFWv28324SIqRlxmBmdHynL2lRIUtvrtGGhDD00mn4THdYS
X-Received: by 2002:a05:7300:8282:b0:385:af7b:d788 with SMTP id 5a478bee46e88-385af7bda3emr10635445eec.2.1795443381369;
        Mon, 23 Nov 2026 06:16:21 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567daaf70sm38349861eec.28.2026.11.23.06.16.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:16:21 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 02/19] mm/swap: clean up hibernation error handling
Date: Mon, 23 Nov 2026 22:16:12 +0800
Message-ID: <3e8d55101602d5ec982ae636eaf5eb4dcaad3ba8.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DAF444000C
X-Stat-Signature: cecmx9cbkgexm1qd8y7e1ezm153otqps
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795443382-894874
X-HE-Meta: U2FsdGVkX1+NcB5j6dSHNaNxQl5u7vTwADTeNc/qoHnlpzZ7GMIE4n5992a54BwJw37XuydBrqS5TgU5NASnMENljADqrLmcqBQHL2+xBuJmubsQUB1Z7VpQ7178dR+7g1t6r7SNBp3tpOnC6Jl36Bm8nb6u49EBqMzAf/ZlmaskM+sD+P/5+YVgvMOd2TOWoMeeMUIG513HsOk2tEDgegZg5MKArDr2CWr+HRBzXHM57mkGYyHEdGWZXOBb+VgajiLhr41X6tkW2A3PZacMbhjg/OhuJXh/SZNdvpAdQv292EqJXlfqYG4wjb8GX3v0MrPRvFrdCnwG0a18xpKFc6s5ZKTBSOV6kPegt5z1npYaQKOfdQJ67aUirP31672e+SqiQTZ6q2zoXDSTbKHpAACA4u8ficweAqjjJc6kEuDAdMPy0D+WSqeVp0ZE35FwkvuN6ayyTzZTsQ9CRZpzhyLuIc0qaTQacfJAUD42zs28Q+HxVORZuesNyyHkuhVC8BkZbyhVujE7C4s3idnbM4pHiJJgkuSNx+ms9KQV66unevASHn3jHuR2K//xiCJKvNxGAAwr/DzmzFSFajgJTpCEKoXSZvzW5yRvYHR1OHN2ee0bQq43DeiVR9gQn20a2yt62ruxEuOCZsGMMF5KUAOfmSThOvMKaSHTpfmfBI3yO5+IZ1bXovLq5lt+9pE2bxsx8RQX6g9DszLX7C624yxFVqh1y0A6gmZWUwUg6TM+pSToxmOZ7yWZxyMqheNB9Ymg+Nq3HvXvu9K89MFkAPYcyKuIvlfIpuYE+ng2w9LAKf6kqMMtTlJ5mAAE5H3XXNCiF+DqKYbAfhmh8ywa1vnKjRI5dMvNBWQieNJpx5MpNRkWkqu86tCrNT2DXkZ7OaLU1zC9J2X5Fy/MPbZLLiEcHLvSl7vYqOotzhwsFYYiwDLQPC/JC5ZIAyDtHOF1mtkPU3lb0Cuy64z/myE
 1RegvnXs
 SeM3/Qi66sZesTof2qBaNFce99xrMEy0PD4Iqtkt3Xz64AvyhrCfdmtnx5MvHHie+ef7YkaI5+XDFQlgGdfEHPTPtjNvnDycJ68nzb8jFuJrU7w4ehLIq904ZEvOj2trHXBmu9DpO3BpJM48Rzv6zdmV9upJiBrUkah0PqphNCI14m9VbskILFFCUtCgBEOH6WS5oa7wCyQ0H3O2U6o+cJ4qdvBx3N+hvICLQkD+4UYxgPJQG5RlQltOI4MXeBWMnjOKgBoLsGeMvC7uykA7DDeEVjNTcaApO0VkzcQbt+60ITFm+qqxzd7d0nTTKEdwLime2dWLe3RB+UknMB6wt8iUPB7IOh4E94Qy6WKeu+51dAWZ7FK6KAJiwCD/7HWzNkl0xqs+1E97Lats+2mQALkRgU12WLBLpZPr46AULsij9S6WUIxIK0TzCnDpaWy89pJkMWQXY9y1Xxdx5VaidBT9Rj2Hn2osvCyptvuQOWbmh9eOa+DL8uaI7ZYlQX7M2iQ4LJVZ1ktVZAiktjzt76cXw0taSMFcCMrbNJk+4/psfvUSimIcCpr4ci0qRjsKwOckuAKbrSync7PONkQENMRWZnEbGi7DSTYy7Azk4EXiIxfEHcUC0+LboKYO3aZMSsMqJl2r4n5nNodjcwzrO2e1qoeSyljjwvbc+zuq165QJ0w1vTmY7z+JzDEQo/KxTsSw+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Restructure the error paths in pin_hibernation_swap_type() using a
goto out pattern to avoid repeated spin_unlock() calls and simplify
the return flow.  Also simplify unpin_hibernation_swap_type() by
making the si NULL check inline, and clean up find_first_swap() to
avoid an early return inside the loop.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c06f9f532e74..0ae901296731 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2331,21 +2331,18 @@ static int __find_hibernation_swap_type(dev_t device, sector_t offset)
  */
 int pin_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
+	int ret;
 	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
+	ret = __find_hibernation_swap_type(device, offset);
+	if (ret < 0)
+		goto out;
 
-	type = __find_hibernation_swap_type(device, offset);
-	if (type < 0) {
-		spin_unlock(&swap_lock);
-		return type;
-	}
-
-	si = swap_type_to_info(type);
+	si = swap_type_to_info(ret);
 	if (WARN_ON_ONCE(!si)) {
-		spin_unlock(&swap_lock);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	/*
@@ -2354,14 +2351,15 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
 	 * the same session.
 	 */
 	if (WARN_ON_ONCE(si->flags & SWP_HIBERNATION)) {
-		spin_unlock(&swap_lock);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	si->flags |= SWP_HIBERNATION;
 
+out:
 	spin_unlock(&swap_lock);
-	return type;
+	return ret;
 }
 
 /**
@@ -2441,11 +2439,8 @@ void unpin_hibernation_swap_type(int type)
 
 	spin_lock(&swap_lock);
 	si = swap_type_to_info(type);
-	if (!si) {
-		spin_unlock(&swap_lock);
-		return;
-	}
-	si->flags &= ~SWP_HIBERNATION;
+	if (si)
+		si->flags &= ~SWP_HIBERNATION;
 	spin_unlock(&swap_lock);
 }
 
@@ -2480,7 +2475,7 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type;
+	int type, ret = -ENODEV;
 
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
@@ -2489,11 +2484,11 @@ int find_first_swap(dev_t *device)
 		if (!(sis->flags & SWP_WRITEOK))
 			continue;
 		*device = sis->bdev->bd_dev;
-		spin_unlock(&swap_lock);
-		return type;
+		ret = type;
+		break;
 	}
 	spin_unlock(&swap_lock);
-	return -ENODEV;
+	return ret;
 }
 
 /*

