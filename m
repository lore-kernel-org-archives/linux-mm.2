Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFD0C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76F876B009F; Mon, 20 Jul 2026 11:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720C46B00A1; Mon, 20 Jul 2026 11:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D846B00A2; Mon, 20 Jul 2026 11:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1466B009F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:09:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFA2C1C0165
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:09:30 +0000 (UTC)
X-FDA: 85009488900.04.F91471D
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0ABB44000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:09:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kSEW56gy;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784560169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gIaMa0p8G4f7glb1Lz6VEdYbpo7o2b5ERWXtcoXZflI=;
	b=1dGR67oMS64tCMp4R8dxI1OXvUHUTZinko5kfCR/RTDOoGRVH8W1aT5xvH9wlJMWsC2Cq4
	ShO53wrC4/Mny2PWAJubLHtG0II1YRjNLoXxA229iBleEfq4u2aUe68EE8FGHnSburn3f5
	pr9O3vNT6i96zs71NMDwokYra8vNzxY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kSEW56gy;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784560169;
	b=NVydciPqFmClWcyRzij8KlXr+glXvilRXgkqA/D/4jatlc0aBC7RoWvvL48VanEqycbZUS
	3/kZIiODJbGNiVQXVe5+4sT6b5muZMlF0QxSR3yc6o26yk8oEfslLfg13AxbjA5LUIuV96
	VErWB7Yhu84JuHwwUJIbF6rsc2RVN1M=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84864086bfeso10855192b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784560168; x=1785164968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gIaMa0p8G4f7glb1Lz6VEdYbpo7o2b5ERWXtcoXZflI=;
        b=kSEW56gy5IS+CoGG4rUOZCUtIbAUAJRXHlMacLmh9hi8U/u2fnaKag5ffaa1MxBYU3
         hOtP/ygzi6gEwpgQiPkSzPpNvhb92qVUtsKs8V4jqTC3FghqOFqsWRp10iKHYRG2XsUl
         Z6BqoxipwNI8BWWPinEMv5tzwVcfXaX3lJTQxXND2LV4xOCYHFksEvvrJ12pRqADqX/c
         WlVBMSpCkkpVMpYRKfPpjHHMOqF0ObY1CqWSSOZl+lJdiTGRyfp4CcPeKEfvhles5ekq
         /BanNekMgeucJQVNalm2SJhFKPDvu4ovPAMaU98ChQyYHtboLFkuNKNcznCbWT/U6Mkt
         NIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784560168; x=1785164968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gIaMa0p8G4f7glb1Lz6VEdYbpo7o2b5ERWXtcoXZflI=;
        b=KNf6AmWAJa2EBBYKgrz+/KAicIU3eyjRNXBXaD5kyJ+77xQtjdMbUk6ak4CmNVClre
         O6enEKFXr59N6fDXQr7KMnHlHLKYXg6azYCzlmaw0gFy5+jdwoeBHgf9ZKWdOJyrM9Wo
         vLo1Rtf2ZPrMoKhtHbwH3HAsyvolFTLtpPB5aPMOLR1iUB5/gb0m2/84EHs7nYVRvgx+
         fpIc8aBk9SGgHaq5wQguFoRqHanAY0FjRYeoSW4VVTfLca5uW67NdjxWYIU3KoMNGX8l
         MfhfxQbBpugRMWGVJVN7981PStp0rXl5D8YI81udeWefQ1znHLqS36x3pOSsZ7Iy4Whk
         9RRA==
X-Forwarded-Encrypted: i=1; AHgh+RpodlWaDPSVRFfcwEkxkHPIxsRo3VTLyHxZROSMWEcAAghN6e/QKnPtosdLu9Jsqj4Ie/bJwXl1Lw==@kvack.org
X-Gm-Message-State: AOJu0YwVeGF0A0vfS0cfiMIBcMjaTbbPLwRroF7zGAhWulH62rtWEJY/
	oM0Lu77B4ZE3d2HNfcc3n5PzLa4JGoUopWiiisbUOvAQw6Smn8DYB6rOu0Ywwn8H
X-Gm-Gg: AfdE7ckrv/ghX7KKOoPNpESos7xcHNxL0s/FRUV6qUYcwHVgDk6X/Bo7oTivdMBiq13
	LrZtxXW8oL7Og44CfbhU0a/t8wwU2mHrIGWngP6N6tNt8yCq70aR0CoiO1zvtvaAG0jeyb29lpV
	i3SiJuOtzxyD0G+zrwJfIxPfq76ww4Of9elAJv9N3lCG4OUCZe9vTVnGauuHuysFWQubmqczYsR
	omKWyQic93czV92JqKxY6MShBbKVIzMq6E+0jMW0zQzGazZDW+mg9D34TgHdXJrhlgM5x0VvRAr
	UoxhVCGq2oP+9ZBsxxG9BrIo+NQJ85JX+zMDh57h440TSK+9bfslmVAt+hjXXQtCDBPN7MIsDKh
	f5e680ChrlgVJmpLsZjcA8IlbnZMjGMsvOLpRXQbaZVIH1QjlFYXucglIVl+UKR8yhvw7gR6jiw
	IW5O7KvEU=
X-Received: by 2002:a05:6a00:170b:b0:848:4b49:27fb with SMTP id d2e1a72fcca58-84c294edfa7mr14233298b3a.78.1784560167816;
        Mon, 20 Jul 2026 08:09:27 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2adcd3dcsm5938032b3a.24.2026.07.20.08.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:09:27 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/mm_init: remove redundant memset in free_area_init()
Date: Tue, 21 Jul 2026 00:09:13 +0900
Message-ID: <20260720150915.756749-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ABB44000B
X-Rspamd-Server: rspam01
X-Stat-Signature: fmfmfekqfbpxtqky7tokabzzzrxp74i3
X-HE-Tag: 1784560168-926171
X-HE-Meta: U2FsdGVkX18z3U0yJvlG+VSmpeVSWwW5vUMsL6Cvckc6gV3FEkE5tFnrZiFa5P6qLFEve9LvMUB5RSJA1eL5rCeShF6TJMbljTHvy9SY8UMGrvHEyyi+cHJvKS1j5Up2/T2oQZD6ZHonJHA4Yn6wiOJr22bCuNq32vb/VZLqZ3ECOUH/OXEmdiu3pXp8uZJm6WIqKE8kJ9/+XigbPG57NZCfNDOUXTQuqzcxgB7cRZBiWC3d9i/cEOjkWi5mqMRs5sPYuS7FBNwpn7HUm2xTkmJuSHMOWBftPK55/+4XEUaVsSvarWfDGlly+A4S+6WbBzG5ep5Y5XVF1hy9wTObU3uosuTAtQmyGEm+hrQ/duuC2d0RQoQnsJ8T3Y9e0CtVRH7ckvctdIvmMwD50u8DJJDdb73E1/sxleF7/qzLeuGzGaXAIlv/zprKbc8SjjweKDzKuAgQMTU7xoS8Qo4K34HPAhcbGutZkWS2mPIJe85YCAbesHzDUoxrzMCUN2slXIgxk5gX0zs7qmULran6YEDp//+AakqzmQEq6Gtz8ykMpOm0W+a1tifoL2RWEQq0RvhHIPXlYL3D2IteECur0PGuBKOlutmVFX5doMrMfxJrRLGfnuhNc/SFFvHQxbytO2KjQPlwv4oMRZYDf3NEGTwFyM/kgIniMpj80as2/TOXq8jeK7HoNxCI3ZOEMvuetN+8FIyJUG/xxY1O4oBHxTDIsagr3p7EbF/O5dWD8FEEbRUbTC5rvtbXWrRw1Hn6Zd2kTupXe8CCqrcXWwEmOdw6f6W8b5ZLOaOXPcQgrfPKag1fFUtKUGkCBr4zjP6eytTryCpb+9hmxwUlf3+f+qBxWJ1CF6wJJyZfeQtIVTaPIzWpMv8Uv8rv9C3xboNSWUgZI9eSB4N3aQzCFH2AZoj7IZ2mBfZ70B3BCDpIu2VfFgLkkM2M2AL6PA1WO5LXGYUuxjSZ7JdMIYoxelh
 TbxaEgjD
 IyGqfvIIaKWbxgFD1j07OPflVhsKnSnK5It0isimrU2sspsqAIanyY6NYM1uYw4W5rE12E5YuV7Ojaza9/feq40idvMHz+udhTqRLX828ZYpuDw0sqJDsr/KM18CQUBtfL0rEQY9mexhgT1oPXd0vE+kQdIbZvVosFnnOafNSxUmu3P6WZIEXgggnnXyDgxkGM0/3WyvFbHPLh//Ug419+XOUcFe8F8ga9r5v4MYVwJVLZLkbcCoNb7s0u1BFrq4b0nWWXR6KpcZN+jRGMduk9KmAlMy/0qbdvijfbozEEvIAgRBEnfjvAUhKnr5lzO9Ut4jJscbiL4YwD2lS4B3L5f5sb6pputhQ7VmkvcZSr5nYCIYOh+B2ozgXLvZ5TCiFc+oHXs29Hrp6kv9zaSnLhwzrRIVs5Ey2bT6DpB8yrCFEnm7IyISBlyQApOamCr7s7vHIRAwAI7ubDro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zone_movable_pfn is zero-initialized and only set by
find_zone_movable_pfns_for_nodes(), which runs once during boot right
after the memset, so the memset has no effect.

Remove redundant memset. No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 711f821f7b3c..144bb4042942 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1844,7 +1844,6 @@ static void __init free_area_init(void)
 	}
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
-	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-- 
2.43.0


