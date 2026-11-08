Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C23606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=si+Zl1vD
Received: by kanga.kvack.org (Postfix)
	id 3C8D46B05B0; Sun,  8 Nov 2026 03:55:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A786B05B1; Sun,  8 Nov 2026 03:55:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290436B05B3; Sun,  8 Nov 2026 03:55:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2086B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:55:05 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F27D80465
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:55:04 +0000 (UTC)
X-FDA: 85411342128.23.3F9A393
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6BA57160003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:55:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=si+Zl1vD;
	spf=pass (imf08.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V6FT4KAZBmJIi4It1KRfQsBThfynsYK7WB3H1EWORGY=;
	b=uY4UuE0r/htzizq1VanAKZmncC1IJBeHnMqZLaftY/hsvrCA0Jnlzcda8opw6Qf83hahvG
	na9YYRNeSUQAY3Z1wdCi/wp+1UFdaKAJA3iNrZU6OzvkHPcM+baI01FXXGo9sZ2oqHmbOo
	hXwr2zdeNA3Bw0uE1/x/zKNHz+18tGM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=si+Zl1vD;
	spf=pass (imf08.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128102;
	b=LmrWpU1yr7ipMl6qmcF6Fr1DLZFwx41gx8mJK5J0Rz4mtcTLrwsdf+dJbLejun19R016xJ
	NpGL8GB6jEaHBRbexFk1cFOxJya9qjFHDguHHwtdfwA7i8JI4VqvSbrBWV8u+6lSnNlRLY
	eZxyT7ve5RTWXQW2TXYBqN+eFwArcwc=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a5720b0a57so211745e9.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 00:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794128101; x=1794732901; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V6FT4KAZBmJIi4It1KRfQsBThfynsYK7WB3H1EWORGY=;
        b=si+Zl1vD9UBcj9O2M3pV0T9+D4o1e2mYxUafPl0F2IPeEiCuClYD+d5i6a4eMtgAof
         RAMryyf593pF41lBqyJhLVDJ1uejms1KhveIMboRUB7ZMvkNG1WsqsQyJci6RZyBwmqz
         MFcx14aM+cftbNGvRUIiO2tfpyZwKKG4R+8zT78C7ncJ2Af8W8mnSyr1xRekO6d/3pTo
         1Yf4Al114M9DKV+Nyeicu48RN9EuDTg/eAiZaUPHZuFNqmSK4eBhopBrlJncGWO1RbTv
         L2TbqBSVPtpxb+7JMfj2DjeM25atN06YZKC8Hj2mbRFiBdEQJvLP0fFqPODtX/NW3m+L
         nzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794128101; x=1794732901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V6FT4KAZBmJIi4It1KRfQsBThfynsYK7WB3H1EWORGY=;
        b=uCZVzzGivDs5sw4ZJw3De5mFmKlYQ3RvuFQzP8KHGmOLVfHBh/J0SCTH2EaexSEni1
         I9N1tsYmUnh2n4q2+82OMniFR+AMp9lQwwXpiBrOaLr95vXLOvhkuxBXfRZ9n9ORIdh7
         gldVITa1rRggvosY85BE3wcbQ/5zTyX2QRASCRxLYDCKOvy/cJyXhAb//OyHGS1J+Zit
         Hcqo9bGBq95Ewb724Z/K/8zl8jcu6T7TN/masXmdzDbqO+uF0Okln6GyZYyjDQgIjeaJ
         MiM06nnVclNlrAS4LTRQ/bsKvtKA1HDHBsRDkVnB369dmEYWOaWl9cZKtKURbfYQ+viJ
         QQng==
X-Gm-Message-State: APuU4Z9qcQk7Bq6vY7EC4R95dzJLH2yTrKlfKJZbagQgqtBWD0Uv8n8g
	2GpJ3yqOxKHwbXFw9FryUl49nBZwmSqts7juWdn4CLyn6hzuld3rQpSJ
X-Gm-Gg: AYBFou0EwbTDeGW6iZwbV9X0vpZhA4mvgVHlB9WkkdEKcTDPj+MQ/Aj5jFGwkET9Wf/
	VZn5eVc1hcUZE61eT53fpDmSdR2AznK52ytpdXT4p2j4C0kiu8BnOSGBG5vHChrGd5iY3eLbUpy
	tNzbCgQD44l9GrFBYsemIgOOUZFyEudFQEBOew3VdTRhRDtTLAYUffLDlFXtyGhDzKT9dqT1TYT
	udDqBQjFRCe+IqZtmYr7Gf7Wt/VALcXS/553I4cZtfosdd12JJvoznabXd40DWFtpSv8FkkChXB
	sbtsRUbfpv31DA3MQrXln2btWzLaxsLrBtf8I2vlATBmCXgNLi2hb+oB4yipWw5aH6R0RD006Ed
	nIcpFZiq2cAxrFOEHw4IwrLnJASdBQcIgTqXdVjBnkhau+/7OIUFRJcqwClLHrouzmEXJNCj1RU
	F7Cnd8D+V3O0+5+NZEZruHH15XTKojjytZe9LZKWSDUVVi06ilBatlv+hWc7h2IWbpZ4kn3vvha
	H9uIF1bUVdspqAFljmXjTm1jnDLYZn8Sx9fOveucBuhqCiRk3xJfRh3IxRFMY5YyPPUL0UDrYaJ
	UGXPtWZec2HT3plO2NSno+aSvXroMnQFoaB/I0h6cSO4CBK/QgviygyjzEiUB8YBMpE=
X-Received: by 2002:a05:600c:4504:b0:4a2:526b:d40f with SMTP id 5b1f17b1804b1-4b943f76422mr18343555e9.0.1794128100763;
        Sun, 08 Nov 2026 00:55:00 -0800 (PST)
Received: from localhost.localdomain ([2a06:c701:475e:f800:9c3f:1631:3855:dec8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7e32ad610sm322985835e9.3.2026.11.08.00.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 00:55:00 -0800 (PST)
From: Avi Weiss <thnkslprpt@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	joannelkoong@gmail.com
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v2] mm/page-writeback: avoid unnecessary strictlimit background wakeups
Date: Sun,  8 Nov 2026 10:54:57 +0200
Message-ID: <20261108085456.2093096-2-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x8nzyem7e8jjcqx1ca6k5i4cc89qhcuk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6BA57160003
X-HE-Tag: 1794128102-647487
X-HE-Meta: U2FsdGVkX1+4mHqi/DbTPJh2oVLARWSakl9ROChMSbtFsdTb27ztwzvGLb0o1jx77Y2WtRFxOFT0nYr9JXC8Rup+BM6PbJUNtEcxDhTGb6pFwwEEda0FD9/Lm/hfkgN3Myfi6EpIuomZM2uqyHACcPXYaa4ZvXWFuwAElz5hM0TL4wZRFQKyeX2gLsRwcf4SXGlztYlH2Lu4vva1ZVUgB439z5NXupXEV8PLQAJfMhmaomEMh33CKJ8g70rszyqvz2K8va0PdgB6oFA+Ethee9HCWrpWeTxCRFA7cQnCVxAP02J/Kapg2wvMgjsSWOsUniC1keTL6vyLle8wiux+uCvdcSp5VaA5NP3UkuvlIHZc4aOzLpNAgy1hTUXfQuAltWYkI4NUlGExg/yXzpI1VePTFCl+dDr1+62xEDKpMPuzxRrzfpaDMk62zEBRGKLZsU7+ileNlrfaK9phttxNv9Bvhhe2zqCmgooJcLOUw6nSjApoSYdtxKGGahr+NlVJOCAiQX3apS9XEjNt0JLY9O+KAInTVh/FxnPZQ1frBYZEA6GK2IEBA7CkIwJNki6w7dFg3q2B1NYMOlUjXQq/SIeHrBot+2ygCEVO8XCr6b+LAf2B6b/3JjoWmqjpak3Mfb8Pn8xunMZG7vNi6DTkhvH8OcqpXF/pPMKO7nIjcS7nvsyLzjRF9ps69uvrJJ+GzjHw7TXbHf9hgvrtKXzLqwZPwUBh8emsxXolPqvuLuwDSeEDMoDnk2ykuGMV2/+z1CJWzfJHX1pz9DJ5KDpkvkQjblAJap4+KxLLWaCaQMvSgjdDX6h9Hlwxe0iIREfIYSlZEWx4ISmKFF9bvZ5iPYjgDZ0p5+6pHMyM7nUQl5tNUiFoAAz2SmYhymzZBtpdtvllDHel/aGLsVJS94F4JmHI961znCa876AgNBy1rkx8VBcqnZ+mPqRrdOap4EUCPI/l9+miDCi/4PYN3o6
 f7T+Pk1x
 L0cbaWZoZJZyGW4hJtEA6RXkX6ePet/3BpcbYNSzmPQbtlALbEVYWWHw6ls2wxoH9ddFLtDuiUUh2eRdFSyLzss8+MTU7J70AlbMMi98ksU32LoUP9aXzcEVjjH3jb27L11g4XtdiwbdegHbSKbAZrFPFCyJpi0FBTi6QLeDccp+2QszVkiPrT+1R1cBRenm9RhKaSGfqtahViZxabKwmpTO2JrLzbhzDelxRjqy7MbEURtKTm5s3MO+TwZ1+qdPlRQ71xRQXgQCQU+UWZhKguMNDEiRDmPf37pmnPJWl1sGleyRyFGxTeIPwV4WppWZukpglBZYAvwLrdhyeDYOuMFzdTDMAG01mUeKiG5YigM7PDID5Xe9+RTjnApyr9BCYOEsRYt3lnq1W/ym8TmH7NQhrvY5NxwdF3k3zPKQBo5jiH4lV1FONeBMlENQrTiE1kcVm7Y0V5h/wSxGuy9B9ZujQpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

balance_dirty_pages() includes pages under writeback in
gdtc->wb_dirty when checking the per-wb background threshold for
strictlimit BDIs. However, wb_over_bg_thresh() only considers
reclaimable dirty pages when deciding whether to start more
background writeback.

This can repeatedly wake the background worker even when there are
too few dirty pages to write. In a 15-second FUSE writeback test,
background wakeup requests dropped from 2657 to 682 (74% drop),
while writeback_start events remained nearly unchanged at 99 and 98.

Check wb_over_bg_thresh() before starting background writeback through
the strictlimit condition. Leave the global background threshold
check and the wakeup required for dirty throttling unchanged.

Fixes: 0437906841d0 ("mm: start background writeback based on per-wb threshold for strictlimit BDIs")
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---

v2:
- explain the preliminary strictlimit threshold check

v1: https://lore.kernel.org/r/20261031070515.3042848-2-thnkslprpt@gmail.com

 mm/page-writeback.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 499a35473e4f..0529b4a7e99c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1824,9 +1824,15 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
 			balance_domain_limits(mdtc, strictlimit);
 		}
 
+		/*
+		 * gdtc->wb_dirty includes pages under writeback, so use it as
+		 * a cheap preliminary check before wb_over_bg_thresh() decides
+		 * whether background writeback is needed.
+		 */
 		if (!writeback_in_progress(wb) &&
 		    (nr_dirty > gdtc->bg_thresh ||
-		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
+		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh &&
+		      wb_over_bg_thresh(wb))))
 			wb_start_background_writeback(wb);
 
 		/*

base-commit: 36aad21d50d1af3f6954bb0c988257a908202477
-- 
2.43.0


