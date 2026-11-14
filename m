Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2200606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pS70f9pq
Received: by kanga.kvack.org (Postfix)
	id BF6FA6B05B2; Sat, 14 Nov 2026 09:49:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA75C6B05B3; Sat, 14 Nov 2026 09:49:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F686B05B4; Sat, 14 Nov 2026 09:49:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2566B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:49:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09F4A1A0403
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:23 +0000 (UTC)
X-FDA: 85434007806.03.CA9D517
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4911940005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:49:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pS70f9pq;
	spf=pass (imf11.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667761;
	b=w615/eOpJsBpdz01M8USENsased+d5TS3aPHwqTn1JAbr0VXX5yoGkSCVd2olZIPB1QUE4
	xpKHp7V4Wv+wcBh5zefZhbXoSvFPajWZXwFV6WeihfFXtl0+ljcQrwLz4xLhudKM/5ya5V
	Tqo64qTLq3RSWGbEz8AHjKDRUiZp4rU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pS70f9pq;
	spf=pass (imf11.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2/DBpmjNNHeB2wLGkpV5YarrevGow3+qZX583Pk5bw=;
	b=pGSqcGILHCsoXyx2ZBLpiwhvFK9VMLwirC4FdGF/rIKsz899OCfQGp/J7FspqZ01hb4Rj8
	HlSqd+HMmRYLZHusKDCHW0BZzRtYinZeUKu09+zW5HRQSME2KgeOWCy0dDuq2asAUKMWSZ
	GreGxfmt2y3617JNS7n9Gqhp45EjhAw=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cdba1bbde0bso673610a12.2
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667760; x=1795272560; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y2/DBpmjNNHeB2wLGkpV5YarrevGow3+qZX583Pk5bw=;
        b=pS70f9pqIYlwFmhX01J0hzNiqKLrQkiddmu5XT69Pos38E/9GtS6wXUZlL+76KEESY
         FVIX8OGugVl+e3UiPBYoyBB6CU/biSFMKmUG8+TSxd0347lVL/iOKo7/YhWo64USSG9H
         e5tR9uMh0bUAQYXWQj7T0tZ7qFt6hB+t44kdovoV+fb9+vmG7ptb12+PM72O9k2SfRKz
         s/VNx65w+tcTdLs7bJ+IRTaZ9vbwsJuIOUZCaA7tKOpZzNfXeYqETcmJYMVT7cZdV5FX
         6tsfOn7hR2eqLgHJ+Re9ca0r0G9liLTNs0x7Kh0xoIbLBK1Y45Klnc0WUt5B0V58EEZn
         n4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667760; x=1795272560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y2/DBpmjNNHeB2wLGkpV5YarrevGow3+qZX583Pk5bw=;
        b=wS3SK/yaBlTAtx2VazK1p5VtalHXchFw6UG0Asiqi8XSRHhI3tEJpLL7wnkPQ4l7r8
         jLTHKueKJB9UoKkIW7tqv7Yr/UPkhhcS6cK3P7egBgNWM0L4/6VJVltxrJiOKU0QhHNf
         e6JC7jXd3HgSHVCmDAl28UXxH0uTcP6j0OCKJzpZVinrkZSYEYXmYZGWM3oyDHFUarFU
         OVwCmBZ2n4eZbTySj8FoizRMcn+irjlXv5LBPMn5k5saY2Z/xO6syRyBLRFWnkXxQ2MR
         lLQ00cV0uHS/a4kcj2Ykqfi19YyC7Jqps8bQWXFNsQWWtXhweTr+KHyxNAQYBOYnKCLC
         veQQ==
X-Gm-Message-State: APuU4Z+rntC+yW8AmsZcOUrNERAlpmYobavU9hJXlTLJfSVavRa0uIgD
	1el5UrgSoJlCP8Y5WWYNsUNBbP01GPRAx3Zm3u9vc0Z06A8M5Q7uRmXax4RvNg==
X-Gm-Gg: AYBFou2EUEwL6LwveIf9Yj30gYCfezpokMsjS2vpEtsow4IFzGPtkau8R9tVEmShRoU
	koWgd47x/OdSj2SD5gacexAPQf+dDQpGjaE0tTvXSkZAyX+O9M6Oi5baT4KHH9tlSIAxidJyLBf
	EP33aaxG66jkGw06RcvqpqUosA08yCKKLNVmoj0Uz+NXuNFC/XM9oYu0loEYmaMrizgzoculSU2
	KRAOHibXpZETrjtVV+YgWKnrzngEzawtXwmhGj5Ott9MRrsbwRZlQEhjqNGvaSD+KuCmHZl+Lhh
	GyQAr616biHJ27vBBXfssq4G1MjQ9UTqXbTz+72qLGcXIOOnZSUMlLDT2R6jaTAlKGm24r8M2TG
	2KboePMe7nu27SfXeUvz+T7TPlojIrlLY8Gk/EzEPM1gjhZciKXN0PdjyYhI67MDAPemJYFvdFc
	VT0VUSFHz9SgxXFgPwceObf13enPosCOVHIAoF1y7LxS355j8xr0/MS/8gI6KzrVCC8AfWQz/iW
	WkFrHebKO6PV9YrxX+tEEoiFZ2XA519FNiXWPm8v3+bmn6Z5sAQoCtYj61SVs6uGuyLckRwSKVL
	fEIZMdfW8kEkZyRqssO67+uTvzrpG3+P44W+SW6Qt1xXWdr8v/hfy6Jb3cokOgw2eBtk4A5kGly
	fbt3t97ZXfkT0MA==
X-Received: by 2002:a17:90a:c88b:b0:3ac:8897:7ba5 with SMTP id 98e67ed59e1d1-3b1b0ba890emr5889521a91.59.1794667760115;
        Sat, 14 Nov 2026 06:49:20 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d0fdbdsm14353082a91.10.2026.11.14.06.49.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:49:19 -0800 (PST)
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
Subject: [RFC PATCH v4 02/18] mm/swap: clean up hibernation error handling
Date: Sat, 14 Nov 2026 22:49:09 +0800
Message-ID: <2951eed4feabbf1a72dbcaedfc011782d9885604.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4911940005
X-Stat-Signature: 1qg5gyppxaitgfcfrfmrhx35ri38yd3o
X-Rspam-User: 
X-HE-Tag: 1794667761-219321
X-HE-Meta: U2FsdGVkX19uzYtsWJiWZlkO8OmBc7z4khT+kfoT8FM99rKcCZ5yVH2U903m2T+/nxKljt7wyqLtGmDntWcVPVWgzT6+N3I+xM7/J7CwwTYYbqrJ7nUqZlGDmjrHd2Kl4CCMcQ2k373e/JkhB+2peaZi+tkMCCqtfXwEBXaBz2dR2jxinsL4k89iKOH10EbhR0c6+CgQHt1oceTYV3f8RSq/5AM5SxWjmpbPdEgPDlmzvUC1vyUStKRSjwB2OcPC+faTCry7Vhwzui1jDNk1mkjP9kMtESCkRGA5gT8oNFVOYjtaWO6u2gwSF5mwDSnlsLMwnLeDaUhnfpvxxOMoHsBOdX1y/0zikEHqyM5fHLVNQCsrNOCCPBGFhuV288IVHFlczSNAca6bILt17SA8A+ZOEBxdrBn6jWDVvgVvzcC253yQfmy2clkdQO+Ux6yHNw5iSxdncch5sHLrZ7gcA4wL7iXD1B7Q4Vc4EotV2RCMC2xE3oY4iQtm+c2ZJdqeza+prZI3zTA8KY8y76z419B9cbhflYKuHePRPeDYV/C+gW+MNRZusgKvKwvWHy0ygX29TuqFO00GC6+K4rKSKJSOHrtNUi4vd7IB/icanF+orCjEd0OUOzHj7ZkKuO1F8OED2JVuSaSkJeNXt3DYruc9gzCRKiMlW3E4ABIissyr7dGvjTmm177K+piuvuZm7gUtBZbJWKxO+CF4u87E/2uASMbo2ZghwTqMjM2RYSG+5nNFYS1yHwy9GVD9TdAYICUhtuOhjvKaYG8Kb72/U6huKdjwW6J2994kv2obfmLZ9gvUh38f//CnUur3oJqM8SfEhYOGBdIi9PwvBo400yJ7EcgxvmUdngB7T4ZY3QPm1eH0JOmK7Ss0Codoc+EejKRVZi97ioTKm43amGWpooduIl4iRwU/7hE4NutUVy+1J+QfMTvfrnKYQgJoDuKasDfo9YiORdjDV+eSwPF
 yZes67G+
 W4hAA93dls6+F7b7oHvf50SUWt6ow4DqTDQt+YOsZQRoB3tzAuxXERnr3auKDPt1XYdYDeAk5uIDTOPqrEb9kdIN02cfNlYH6RGw5WRj6UIWPOxXdnz0UGStGUHXYuIlSWdNvHZQ8YW+sL1bDMgQ8qMFAxIYHbk7pK67oM3VFiFlfYugGLtMi0by8wXZvg/11MuDW8lHv46NKDxi16+lFp6y6F099iXWobJM7WsQoaoEUtZAmwG8vTwny17N9WV+Xg2gjcTOuPi98IySYTHhXs9C3ihYvCfXyvqbPiQLcHsMFToA2o9gzPAUa6TJSjsw5fy6opyZFB7zwNH6gaCUh/yMekyKAt0wrLd70ley7CIztTDKwuQscqm2z9h9l7PtJa/ApRUbpCIQU1ErDo4oEMtsjN0HjSRTG/xozlDdkz+Qi4krWPfQE+1gwDpM1KhaWMWpRhdRFh1jP8SatQHB/sCewJA27YOMi2P45n70bGzbUH2249HKBMzQFus5yWMotbUI6oEmoc88K0aj0T4473Fu1uwYbezZj2e5PHtw8yAk0KPbnGDL3a8DF471u2DYIQ/eB7qBpnrZEh5Hq8pXqh8DkjA==
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
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c41c4d26a7e6..c69a924acb74 100644
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

