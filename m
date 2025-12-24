Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EBCE7490B
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 04:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93DA66B0092; Tue, 23 Dec 2025 23:22:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B126B0095; Tue, 23 Dec 2025 23:22:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 773AD6B0092; Tue, 23 Dec 2025 23:22:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66BB46B0092
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:22:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFECB138696
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:25 +0000 (UTC)
X-FDA: 84253067850.23.3B30FFD
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AA6C140011
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VsMU4Z6r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of shu17az@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=shu17az@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766550144; a=rsa-sha256;
	cv=none;
	b=29XZKWs4FJUxfOOm/ZL5hoaJNBEJ6w+1NTuiC+BTkHW/WDIbO5kjoAfmY2tPSWcHiLJxeC
	DNH9wTaTiI9LkYJJJ0wyvMKznGWBqJljoq4ErNRVnjri2pYoEx0TvZ09P30CGGvcVCJuEA
	o+XS42QG9OMW32lIi427/KnrMZZWglY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VsMU4Z6r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of shu17az@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=shu17az@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766550144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojTNko6SbqP+E6WbK+gbYq75ItQHYqDMxABt5GrcXzI=;
	b=4T1Z+hnNIAf7Mk5urPczzczzqFMMe2i831eLxaYyJ+dDS/rOmWL4WLPWHvmfC2H5O5NaBc
	Nv0weFUn4Cx+v0xxkUIr6PAvtBsHNMOKDdLjU/VgYHxQwkqhxWyeKe3yLW2YTZ5UBf5wDr
	MSd5N9xvjEu6GT/7J8s6xX9XKb1dguQ=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a0d67f1877so70573775ad.2
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766550143; x=1767154943; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojTNko6SbqP+E6WbK+gbYq75ItQHYqDMxABt5GrcXzI=;
        b=VsMU4Z6rilSzGlyX+bp4krEhxsATR18AZa7Lht2ISKu4QHz3Cq9lYtF+dclQKexodv
         syS7LwSOo2QDlktOQ46U2a5iwCMpUMjb5CmS8yYkLJErqgnOYMS3O4/Kc/MGDCuU0VO9
         kwv15QP9UuWvoxpTZiIfY04nYwCJeebxLtIFHXpBOy9LPB3tG4QkSZtZ3NTg+3CVUd3P
         p/Mu1L3yBIgTMUF4WSMN5Vr31aGTvGjsaG7tpk8wpgXCr5GSDigYoxcMCeUzsdSPp65l
         f/z1sMf709tcbdqFxhWW/dhTcw48jOE7QBFeFmyxMCNRO3AUMQCguUGisPXTqd1vbmKp
         UyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766550143; x=1767154943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ojTNko6SbqP+E6WbK+gbYq75ItQHYqDMxABt5GrcXzI=;
        b=CH+v/B5Z8ufRqVSIxW6Ou/QfxGIURsS3nU9i141bIu1SFgn1VDn0KAPLfDyVavUhCl
         fsX04ozCiSnAh67d/yWjqWqbsKUEScRd5u1oGjokunZUeuyMQ2ndTZeESD7Z14OClQDL
         UFaYG3LulRE4nhF6zxuA70us/NNUzsv9lbQ3nR2hoKSg/SARH4B/cz4rSGwUK54bNls0
         bVGTqZ6aCqAOUyTpbx+dDkf4+9zwNuQaz6NyTBS2+bGGydrjoznCNm4MYVxSWZvm7LMm
         tEXRwbembVc/qlN1hU37oGfTo11562kCFsVjPsK+7AAX7/ln9iettVwznZBbUaUY2QKY
         99sw==
X-Forwarded-Encrypted: i=1; AJvYcCVeGIpNJyqlkXogwWOD4Oyncg5NQm54nTcsYKkLn00NZJcvwKO8YtrKSTmE8odXLygojV1Nk4GnWQ==@kvack.org
X-Gm-Message-State: AOJu0YwWHEyksgSkYqh+51dzZ0gU7ummvbKOr3l9x5GkFxWhd529emcM
	Vy366dRcX+un9vq0Scz3o/v5HpXA/SUZSsmA95huTWOd9QBBPW7TKM7F
X-Gm-Gg: AY/fxX4Otm72x0rIFqyD96I6QPgxdiKnDw4dYv6jJEWmNL8uAmjxXmg3RdqtrVasBeQ
	cL8qs0I0Zxpx9KBggrkMHLPGj/oFIw6t1SoVeLB+jtzRg8twq7j26jGs8rqTvSgFgYsAkG5xE1x
	QZHuV+bytzE+JJQrRGr6s2QdOcjsUUR24Rbbh73MYwrJzX/bWaFM+SnZXigUcCAG/Cwz6QQVQmZ
	DZO+9bVUjkh0yuvy6E+zEyc651P+TA5o+bjdGY1wYDOwl3FaTapvxlHSxS1v2i0DX7u3Btv9TvL
	n7SvDwM5+KbZ4O6RAuZPCjsZ8nodQKl2GuNvL8aiUQPBjdmVSYRk3MwTXyONqqWw3+cxw9x2TY5
	AL6JWkPUKHAOIvlO74xeqXNVNRyoErwVOOmrIvwmnzZMyfMUotDaTZa04iQ+kaPXrJkFmQYczFJ
	YG
X-Google-Smtp-Source: AGHT+IGmB2OF59M41ORjl8EXcHftJB+6OeJbuGVRaKx7zyjvrQZlxUR8IYdNNeYdGju3hyl4EBODKA==
X-Received: by 2002:a05:7022:220b:b0:11d:e40f:ee69 with SMTP id a92af1059eb24-121722e9112mr19346355c88.36.1766550142874;
        Tue, 23 Dec 2025 20:22:22 -0800 (PST)
Received: from dev.. ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm48542031c88.8.2025.12.23.20.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 20:22:22 -0800 (PST)
From: Shu Anzai <shu17az@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shu Anzai <shu17az@gmail.com>
Subject: [PATCH v2 3/5] mm/damon/tests/core-kunit: add a test case for region merge size limit in damon_test_merge_regions_of()
Date: Wed, 24 Dec 2025 04:21:58 +0000
Message-ID: <20251224042200.2061847-4-shu17az@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224042200.2061847-1-shu17az@gmail.com>
References: <20251224042200.2061847-1-shu17az@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1AA6C140011
X-Rspamd-Server: rspam03
X-Stat-Signature: 4is3yeo6bbr5pqz3pypsqpeeo9wciwwj
X-Rspam-User: 
X-HE-Tag: 1766550143-798397
X-HE-Meta: U2FsdGVkX18S7zxBmZhPkKdV3IS14vJ1Zsj3bXTZXg7p8WHN5bCTSYQ345+uZutmQUVuOIMAHM6hRNhVLF2uJVhMFqOAQ/ol3k0+u+Qv610lpv+y5aPwdf+TqpJEKKuo9zMKnB8Zo9X1ZMf6dUemo8KBZJOKRcfnFtoug7nkt/e+JXiUO/BsKSN4X148w0Vevg7ir14JYfOx7MvZjEbGawsybnpxKkGimiO2spRxAq/rhMJqu+/tPwQgVAGctFQcwkgch6lHJBVbQErxZVBX3SvrDPa8PJsbM7ZFkAG6ZAeU4zBYv5fM16v6G4AYrhye+NJE4lv8BvHyV38/MFl3VCt3gu2H0rj7eUTKbwhNBinE5fgb9KwuL9rDRD0Xn96M183/UN9Ba8AAfoFFYYMuC93xrkJCQsF6GpxGlJ4MS/U+5EZx2/hMHKgCRXBeusXMG6btGsscNHfZrfsFaN4REzkaM8Dy1QbMd1Wr+fejG0mGmFrgiX5jgDA8OaajLhtU4U1dHqcW01WkeEo+UWUCV+8bYgTb4q3LWf4cxWPGnFGPsDmtn886x1JPUuck8dCDAxix6BR4pLLubUla7IldtLvl529yzubz2zq/S6FerlBlm+rEkqMhjG2VknGJ0N0Yw2uPnTf+89tVulaUTqQu/S66uwecdTHJyBXvmUaZUGr6wzSG4kdYNqf8GyoYFrqxDiJZjcet9NqFGVqJX6qULuubEok5+FtIqiB5H88Wb8BrBw+mwLk7UOVXwArTwL6vwtFCysOQa0OCumIhKIEXDMZzI1AeRxt0i2ILaHdjLbtGijJYNT8uOIWFaTsgj/Q3R/+p6OPTXS+aUacaxo63ewPcuYFlrtjqiVqu89mPYmsGtXhkpIUc1xbsWtMtfdJBIo39Nz/uKPVu6e9eRvo14H86fSIUd68eVmseETuxWJRc/5NXvSFKLdTHp21JmhDc3C3mQCpcPyGdPFeV1Ov
 K3SnCcib
 SBz+5T10m/fA9IPux4gGmE8VikjPy/U6khCGDvIp03vVDmHHy44l5jfwEYHOTWxrcdGOYoT0ueHwLdMyw16dVpFJI7KgBckAaFbXMBOnJr28jui+1CX9BmKFoYXXOdF1lw0VgZcQPhFh+4j3rPZ/OEIkzmJ9d2I01S6gOOgxzMp73V/9sro8fTUurcoabvwWrh7JKKLCZ+CShlfS65PLG+wt3uxGIjnnzKIXjBMwadv37+rClskaYsEKTortGDdpUetm6abcqubDTFezSWfD//21lKjMLYe+HHFw6xnX8D5QLdpxn9qvbbkylMl+Ns/mq2JoBomYZzrlSOxhHHzH4M92x343nejs+uolbBaFw56GT5e+3Cpv43NKbWgAxTdCQ33hOsuZMfK1tiHWPcANj1mhgQHl5fm0HWaL7qiGmGWcq9xGZSPkLI3wnY7EEiqh4R3p5JoD3G83Vli0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test case in damon_test_merge_regions_of() to verify that 
two adjacent regions are not merged if the resulting region would 
exceed the specified size limit.

Signed-off-by: Shu Anzai <shu17az@gmail.com>
---
 mm/damon/tests/core-kunit.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 6e301113e103..2eb6f41635a8 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -238,12 +238,12 @@ static void damon_test_merge_regions_of(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184};
-	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230};
-	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2};
+	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 230};
+	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230, 10170};
+	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2, 5};
 
-	unsigned long saddrs[] = {0, 114, 130, 156, 170};
-	unsigned long eaddrs[] = {112, 130, 156, 170, 230};
+	unsigned long saddrs[] = {0, 114, 130, 156, 170, 230};
+	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 10170};
 	int i;
 
 	t = damon_new_target();
@@ -261,9 +261,9 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	}
 
 	damon_merge_regions_of(t, 9, 9999);
-	/* 0-112, 114-130, 130-156, 156-170 */
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
-	for (i = 0; i < 5; i++) {
+	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
+	for (i = 0; i < 6; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
-- 
2.43.0


