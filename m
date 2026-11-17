Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C306C60A380E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BS7nG2iP
Received: by kanga.kvack.org (Postfix)
	id D41A46B05B5; Tue, 17 Nov 2026 04:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2556B05B6; Tue, 17 Nov 2026 04:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08F76B05B7; Tue, 17 Nov 2026 04:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9831D6B05B5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:43:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B1AF4031A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:43:46 +0000 (UTC)
X-FDA: 85444124052.20.F6545DB
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6644F4000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:43:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BS7nG2iP;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Sqv/SgQ08rWFoJUPpiruSJD4TJXVLiHEu5SvhVq+K60=;
	b=j/1I59tfgzwKhVVnKmGNauqcdqLPO2pW51Nf9rjmD1mv6GbcNt2YHSY6LnyRHJUWmQgOGm
	oIGdPAHTUERwL+5KHxMQ4xu+1ws4PmGMJub6yo8bfoZVRnrxqceWGMwHToWK2TBByqjNjd
	ItwkuVg78n3nhSfU/R+lPSGU5dJW7d8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908624;
	b=PPOpac7UJpu8XTsAqWlEGcVMbcJJ+5wgv5PoWor0P6vhD6sDlkl7lCigcSQDk+CVCDBZzR
	eEimW6FyDQ/pYHHbKZIpkXfEsaGm8V0C9YnF7Y/cDSMuK7VUd1Uf/bfHU+AX9JyR2uKrAw
	sQJO/RctH/4S09bHEZ896tp9hBX/jJY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BS7nG2iP;
	spf=pass (imf27.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so30470375e9.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794908623; x=1795513423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sqv/SgQ08rWFoJUPpiruSJD4TJXVLiHEu5SvhVq+K60=;
        b=BS7nG2iP4AxR/6cV2yx9M0IbWaSt5WKrhxB7Ns3N9tVL7cz0Ud5JPFLjR2SmmMaKDg
         FC3xRf5kNCmqD3rRaHcNQ/p+tuV9Gilb56l417uRLcj+99rj+rMyTFtJO9ztdIrmuxjn
         /cpei+PhL4SV4tlDGL0YQ2pQfLqHOdhoZDb3H/lDtp+4Y6vrxicTlezSm+feyyvur4Kx
         Ovk6j6WThUKvwLhTBHP5p+KrSwoC1lmGFi3dk4q0xzRvEUZfT33DLtxePW35FBaCOwOH
         xk2MsWH6WWmtlPH3mHhuhzFZ1sydWyPJBVJrQAY9EvQAivO8uEKP0g1z1EmGoeKocAOe
         OfxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794908623; x=1795513423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sqv/SgQ08rWFoJUPpiruSJD4TJXVLiHEu5SvhVq+K60=;
        b=y547CAvRD0t+n5N3BvAy1PadRaVyOEnLK2LHFiuX966MrhfOXdPhBvIMvoDyEM/i8o
         97xLoIZZBVMSAQ4wvPOnllNuHvpGXBkui4Enkn7IbuOMCtVdBW9j+C2tijJvLeEjRK9/
         woz5ckMqxfgsKQvR5FALRBWabffRWJVFgU5bIw49EHaVO6tsqaRS1C9S18NazFDvRsev
         9Zfjtz/mzkr0N3i3GUXyFmCIGyNHiqL/VGFwZqD4nALhRCN0nn9mHOafNSSrRkGrBtgQ
         1a6yHXH6i6abQ1dDXkydIljtpj5pxEdECcHeXwJgutF9suvy5mlaCu6RLst4+6HN/bwT
         9Ccw==
X-Forwarded-Encrypted: i=1; AL+hErH+KddS6mthgmwI+IQ7MMYlu6Rr9AJ4D05dnuW7TKjTblisbdTssDRGKFdzLS/SM8uc9pVHRlvODQ==@kvack.org
X-Gm-Message-State: APuU4Z9dAOh46vZ2D0a+HD4g7W/SQPB3VM6YpcIJh23Oq9vyo5qHuPIU
	bSqlwkao1GBh8ijjGDAudfERwudDnG0WPMqp+xwzBQ5q5CuwVZE2OBCq
X-Gm-Gg: AYBFou0kQeMNtVyOoFXLH3fjew1vi3x+65/rZmJNzaH/7rB2WME4IbZHaGyIJOEmWk2
	34XoDU8mluuzaLXUty2aZmVOg1q3dMzbfbx2MQZByaL2E0akhoY/bmnXgJ6JKkUM/kpPovBxO5p
	eZbIRe2Go/C7SSAWNXpepyzc7AJKp8LmXOuDUQ/F5+q30xuO4TYQWz5NthVCxvsSCb6+zhUVL/5
	R3BhpS4+zJ5MyJ/gREL4qlLZDuWUFK4NNdGUUh4oHWoK8cBOn7pVqzPvrF+vgnFze0ndOaNneb5
	s80lO7H5CKakdGfiZBPPLNPh4/8u6DLBOw37s4ZoF9Tm7PPopFwsKygQqsDflJFgpC3p5RqoLfg
	5XvmkH5j2iQl55fVgewpCRBJiG3X/c7vJ3e5zj6RpR82VK9QYPRpjHhbbkf7gItNsg8JsNiNr6I
	A1hY1uaMPuQTqCDNMgI7Z1he8cjyhy/pxZsiFLkejf30FNVQa9pe9K4Vr46sJDoQVxGMbIKY8jk
	i5Z63wyDQsyD4P5JDRKqNiNQkSZXsy8G2PGqnzA+VK8likNBEJAvXZ9R0oQEvpWAV9eDFxz20C0
	hiOhlLzMLorVLNi68lNzgh1PT6eLLD9cyi1ARwieQIxRVOwwRyDwOMORpcndN4uJaFmoZRVDsPw
	4YH5mRZ3svtm97uY0XZ8kmvWzE3Bc6tQe9rA=
X-Received: by 2002:a05:600c:1c0e:b0:4bb:68e5:b952 with SMTP id 5b1f17b1804b1-4bb68e5bb4amr205720385e9.16.1794908622593;
        Tue, 17 Nov 2026 01:43:42 -0800 (PST)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7ad96096sm16212925e9.9.2026.11.17.01.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:43:41 -0800 (PST)
From: David Carlier <devnexen@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Aveline Noir <jm5905938@gmail.com>,
	David Carlier <devnexen@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/damon/stat: avoid 32-bit overflow in idle time milliseconds
Date: Tue, 17 Nov 2026 09:43:22 +0000
Message-ID: <20261117094339.30978-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ws7i1ffgjay1ajj4yw9iarx8fx4yz8o
X-Rspam-User: 
X-Rspamd-Queue-Id: 6644F4000E
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794908624-909235
X-HE-Meta: U2FsdGVkX1/AoZzGP4c2claMxHIrm0gy7ZTG0J1Q87jYFe3XTKqeGSZwR/jlzGQ45LAbpFCEUS/yr1bi2RGe4gTzVCtQMebSJlXpRES0nnSmVUrrlVto9zANcEBs5n3x5RI2kuSKxeBqwUgHir0eOuZWgID8G6JZvfsXq2oJaXHz6rEi7GHhUc4Vp+0ApOnT8jqn6+8PTUacVC2Nzk0eydzhKR+g7o8CltbKNq7spn0IFDD5PINv+9QQvaRRTyJOR9z7Jm1mAg/+vt5VU3xIw2CIqPBSxUx/qp7WHI5lLLQVNhWpCQmg3FjBD7+bdPDTUv9uJEmu0bHgorXnbn9ctnE6/vucZBoBSEE89QAZbvmpUiCxGthb8XQu8n0toBrzFKIz6qiDuXLZCwfz1J62cgayynCLGjp5FD8+fCSAsa1Ae52gxAEYBgWeFMJqn81f+17xnkbOUOPy75ElmQSaw+QlStdoNtRv23i3LSCTd92NcH+nJsxnzWVzmKwbWUHNFmp9SHvs70YVEnKQ5eGnYVWgv2Puuychvvg5m76cwXXo0rIR/mCLEZ5iZjyXD5662TdGxURBoOd27IXvr5F6uT6mFqnfCRSH0to2sSMzUEbov02U1Mhrj6o1IcPJTpYkboePBSrwD2q2L+jmkyWinsfMVBTjohTYIetRi8cCN6ViuT1bDBCIeIsGaflKUEyBhPfNYpowOuyHw3e1P+/we18sHCep1ZMNn1WlX0BYyGhzRU7coPjNP2x+RyZe+yk6lIfnsz56vZYNSO6w6d3uJcbPiEyj06409owhKaTu1ojmeKyeikmcH1CB+dTjp79FnyGMfhNm3Qxys8x19QMU1LYUW/RonuxaQEH2hTUVKc7brf3n/uWyImSqjhLoGPoiKEse+z90RznfZt1JhOf+Uwy+iAtPFir0Z1jieuVJv+fOFslSHbexMrHNaYxaj8jjR2GW1UU0ofrFWeX/kGx
 gCInCWkN
 6/6yFMli7Wse2eVYugM3a/+WIM1c7uMlHFvYT/aXd0RD2vu+CKXDGotayAoEbNCO823FibzkI2xHiTj8XHPYgShSxNMA0Tmd1DWkcgJ5mgVQLoNCoF3JMojHxOLpr2T3ebOHXZXCsmF/hM0sUMRgLRTXEDj31g+B0FbP9NgiOddLcnnyVohsKINwLem19WqLb9nJ8qYbN5nrnQ44F/FuABghwCxPwianNI3AMoJ3FBQi5FFh/R2P4DfYQkwEoqBSgDYmvwrAYvGXzmikuNWYzZm6HyrfFUH7OKa6nK3pyuvYK/2jK8cD4IihJ3yQJq0Vgm8FQhz2J3gXJ4KCSE504umsNcFCz7i+/mOq24j2VBodJbezrsQFgbOOHhyOghqs4CQtEBPfOPwvfkHvwsd2iQZ7ZB8KtPOPEvn9CUS7i7fjgO+/Ea9tahUWhCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 32-bit, the region idle time in microseconds is computed in a long
before the division to milliseconds. It wraps once a region has been
idle for about 36 minutes regardless of the intervals, so the cold end
of memory_idle_ms_percentiles reports wrong values with flipped signs.

Do the multiplication in 64 bits and divide with div_s64() so the sign
of recently accessed regions is kept.

Fixes: e5d2585d9e85 ("mm/damon/stat: calculate and expose idle time percentiles")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
---
Ref: https://lore.kernel.org/20261115173343.82437-1-sj@kernel.org
 mm/damon/stat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 6e05a2b067f2..f2387aee675d 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -130,8 +130,8 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 		percentile = div64_ul((u64)accounted_bytes * 100, total_sz);
 		while (next_percentile <= percentile)
 			memory_idle_ms_percentiles[next_percentile++] =
-				damon_stat_idletime(region) *
-				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
+				div_s64((s64)damon_stat_idletime(region) *
+				c->attrs.aggr_interval, USEC_PER_MSEC);
 	}
 	kfree(sorted_regions);
 }
-- 
2.55.0


