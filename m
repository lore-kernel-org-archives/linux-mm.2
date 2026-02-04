Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D60EEA7940
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FE26B0088; Wed,  4 Feb 2026 13:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0416B0089; Wed,  4 Feb 2026 13:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4DD6B0092; Wed,  4 Feb 2026 13:54:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC14D6B0088
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:54:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C26613A4AF
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:54:33 +0000 (UTC)
X-FDA: 84407675226.10.D801B8C
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8A99C20009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:54:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nqFzAhD6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770231271; a=rsa-sha256;
	cv=none;
	b=0KlJ/YLq/KVfBOhtCFi5KoSjf9KRZ6BAsknqkO4y+4cqMhDpNqjmaqbBzPRFvuUNfOq6P1
	r1/pMTb1REVtFJOcVrSQKPeBWTtAiS93IUg2yRtcB2088lbhcGpi87ljmBmD47PpN3Yyyu
	8xZtKIR5NrBUVYd0Q7xzBjNdRltJ8eo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nqFzAhD6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770231271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2zTo0FAGH6BqbSJJE97beJY63pZ655zRoBlwuo1Yp8=;
	b=kaF+qEe0IQkFEhf6l98E6ohaoysxLeLOkIUaTG7SzgHebykZ8OLBsg3fv/35IrZ8ymAAEy
	Vq/twX7UILbipqX6HTP2tQtds7u6O1XFHwmRZYCggY74UuguTnoGFIcQ3zGGVHClnnP2wz
	WCN9CbpH1ZisveKq7Lg6Ajb0ASGFx80=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c6d7e466ec3so14997a12.2
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 10:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770231270; x=1770836070; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2zTo0FAGH6BqbSJJE97beJY63pZ655zRoBlwuo1Yp8=;
        b=nqFzAhD6DCVTEdkmaaBrXCZe+op9r4JT5O7STSGS/BcZnnYiTMqEPimCe2AaJ9svrz
         wTVwpDrkqt5pdbIZ1zH+VU+bhXFDHhaMFbq9IloXB+RK8VO80l5lZ2vO/8zRoFDoPzCZ
         BzDE3R/eYvt2nHcZKCSWWv9HjzlfhprF4+aOovBzqdIOVitRKlHAJhsy1TDsFeDUXIri
         T05fONP7VINLdirDQWlJ1O9slRF61XE4jn35EbUxBGHKizJPartZYg2gam0DlzxuuaHr
         AxKf2CWaD+7VIM3xRpJOCXrgC22hsZ4Am9dErYJKa6hJBLtvg94PacOraohUEwjtMIIQ
         Xybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770231270; x=1770836070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P2zTo0FAGH6BqbSJJE97beJY63pZ655zRoBlwuo1Yp8=;
        b=uAmgl1Jbot/M4941lkDCIYjOxEmEcxFKhc4UZyDqN19WnZQilmU/kbyMTJ5K7pfZ5e
         hOXkHk2Vo8xKDVBJYFeO0k/6rb2iR+z1g99EwmfU27uvbKafVT1cmDV4xvSMUM7a4aRq
         4M1ojXub5IGq+66Bz6sutshLTP+tG6u4rHZ42/I4nIDP6s6y1gohbQ1bh859UVqtlkci
         pq0jk+MPrywmCicd2VikzMXkeon3p6oph9/PLntwVwGJ6TIQmG9fLkp8l/FvIo0/BUjZ
         6vOy3/jVKSjL9RpEbn0rw5ZsbRGytrDwe6mi1ghUOzPpAv62oE8x9j06Dz7BYHPmdNpU
         u1BA==
X-Forwarded-Encrypted: i=1; AJvYcCV8hiu/IEs8D6n7e0pYRmT7x/yjIXLCETSHckXYjGfzvGw0rTPjZUicAlfM76qRGtQK5GodoWbtuA==@kvack.org
X-Gm-Message-State: AOJu0Yyx+tFm9fVU0onDaPui2Z/TS3mQ6iOzdEbYlc6BZ5K0bhjlXZ2d
	TVMQ1nxPkuS+d3G7fZqz2+nV3acKV82p7tugbh+9zlIWWJkNFXStkaLQ
X-Gm-Gg: AZuq6aIIafYhmgLFzBzlV1fkmNkSjDHZ/Vih30QLU47puHPMZkiezME54ouPvmoeJe/
	fTegj/NwxzJIagEHuHRPTJPCLcyMO4RrOn+GFElfl6QoenSNHbDnDMsgvOlyStJPDTPtWdYZ7Z0
	oVO9IuTmB+Z/fqqUgbkwDiwnvRjpcFmgORh19q6IkqSfDijlWEDq1Yj+lLWMfVxIpTK5h/fjeib
	n859qIiooRf0jM5fbZ0n+W7MyemyQPN6pNXZ6P9ubeoPUmN3zqei78hNmiWEPdw5j4N8QeBVQNw
	QmeCmBuob416NscRr74G+oQ1UXGvukAgLpIYafv7jotRksz3z8hExb4aYFTV4j5iBjKAoTSnhUx
	LjL0Pvu7k3wFVxvVZX2u9pS9QmwSa32RSwd8x0CT7LURq6yYe9gJEcqgkq/kbd5PCS1/QLq47rz
	VjBIubyruWJHoMuZgpCVm1FrGygw==
X-Received: by 2002:a05:6a21:4d07:b0:35f:46d3:f28e with SMTP id adf61e73a8af0-39372406eedmr4085977637.43.1770231270357;
        Wed, 04 Feb 2026 10:54:30 -0800 (PST)
Received: from chandna.localdomain ([106.222.233.39])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6c82f2c1fesm3128562a12.7.2026.02.04.10.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 10:54:29 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	david@kernel.org,
	sj@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH v5 1/2] mm/vmscan: use %pe to print error pointers
Date: Thu,  5 Feb 2026 00:24:07 +0530
Message-ID: <80a6643657a60e75ddf48b4869b3e7fdc101f855.1770230135.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1770230135.git.chandna.sahil@gmail.com>
References: <cover.1770230135.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A99C20009
X-Stat-Signature: xgbo7c8azyrpb4smzjkqcmy1p4n89q6y
X-HE-Tag: 1770231271-674231
X-HE-Meta: U2FsdGVkX19dMb0NOPCBcrDACP03j1kX6k03NyY9yG1sBnuBDMUti3zekA/H48GamrNJw5pVMQ4Oii84Y4UPl2w1v58Vdlioe+mZtnXmIeKrmzpPXPovJjsMxzKJLgH0cY9ugHqcoXS2ckXdIU0MxPUWMi+NLfy38daOKkBqI7T8wNkiFaXRfaiF9Ijy4tV9unifVJyv/GY3bHj0C0Fulvz3NhE1ysCPCbzw/8vjd4drIcOBx3KgsNjwT8I2vb6LY1S7qGA4wwAPvflJWPbmkPdyFgUiKbofo2YsGgYADSPI0gazUALkZToFv6BtvzJBxTUifEDwh2XY5c2f2TsLvzGaG+uaOHdlyO/NfEKCBhgpsL3GSU8io25Hy6dQ834QIwtHVi61heDyBIMrybIR5lzhE/HwrSsZcAwySXFRkE54C/GgsOhaxHLPQoAraeiOY2JtyxaGL+6zWdJ2Frdu9q1G5pNmlubVA2sRBSbf6A/V34k0I2ofETkwF50nJSSrtRgR3EsfMVn4czqANwGnWvL13/AkWgngluwfbcWfaAf0EEcpUsnNy2PQDY7FGRjOgvd8rhZnhziDtCi5s4qxHZmpRgFhH23DmyYJwf32lEI+nSZjIer1C6Jv1XJEFPL8mo/Gj8EHv89Hk9BBgmeMl3pvJA+Hkk3qgHkazUgLhj+2k6EnU51zqbCVPv24Q2kdy09Kyx7LmweEEbTwysYVq9ES4ty/nkw2JYoDdoMUMfDD/O35er/gUo3EQ550OyCcGKlTrkTNk6h5H3FtjtBQqS6xCAA29jlYNCNzEZ6buJEIs4Qd+QnX+KybFL6AAA4EOCsa7kpB53PVhefesHbr3J5wA9hndLVPmuobC3gIgSRS86BltMW5V+tCfY5XfCzRXfvinYlKpmNb6z2BSCByp4bi6SGCot3nbw1kO0xemFrddz6o9uy7gpvS3LmMK66mqq2IBYD+LmxJwBPu26t
 KhL25rIh
 24r18d88jpliKc0lzwr9681mXsKLxUSbNXGsRZ+ygoaDRH+HTQT38epaxuKWvMi/ouJOFqdr1+1OyHExtogEBZJRV7KGREjAd5pxljBB5U9ObEsjkU0l8SIsZvcyYBzel1OzTNt39CFOIuxW3i82R3inblXMQJt1ewhuj82SWkSk0a6bzDLRq3UYJLltzF9WWXCqpJL0TguqxIQCzJsAbwoZng75EbvqchreuCuTatES0Zv7rY7EcmzcJfJ5Quw/2hi2gZKMQmZwvHYVX12wZ0+YK3LTM07zrOn0yxAgG2NV4JBl90JLER/IGSO4r4HetyiixzK4VxVBpXrPEIjRrjzCYf5i9kFzLdwSw7srHkvV5Y/TXlDIiE58hM4A96NC63cG4wFd/Ja/SBXjK4rr72SnKsjwox5A/ZbXn15gCczz1/TRXsNGwD9BYxrS+XJNY+OTXjtF8X59sWhRZA8Mza5UM+juHHxQTCpFpXvzxwa2JZ+DKWBmX6QYoZD2Zkx7ZxO+XW2jHThUNUYE6awzMHKsfp8PwRRlxULv/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
changes since v2:
- Add Acked-by tag
link to v2: https://lore.kernel.org/all/64e15c6b2ce86d7824f54e9e001b6f5b44af48b8.1763796152.git.chandna.sahil@gmail.com/
link to v3: https://lore.kernel.org/all/db049e564cafcb0913bee930d6a577ea43044f5b.1764177933.git.chandna.sahil@gmail.com/
link to v4: https://lore.kernel.org/all/2c842a64fddeb0fe0cac087783aaedd97edc3191.1764312627.git.chandna.sahil@gmail.com/
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 01d3364fe506..44e4fcd6463c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7479,8 +7479,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d,ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d, ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
-- 
2.50.1


