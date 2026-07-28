Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0F2DC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E35C6B0095; Tue, 28 Jul 2026 11:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BBF06B00A5; Tue, 28 Jul 2026 11:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1BB6B00A6; Tue, 28 Jul 2026 11:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 602C26B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:59:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D81BA1C0312
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:59:20 +0000 (UTC)
X-FDA: 85038644880.17.1385F5E
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0DD81100002
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:59:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M2WQ8i63;
	spf=pass (imf05.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vBj9dRIN6Udb6VZQQbjYzZIxTaEeXwfaFcu0hXMohA=;
	b=Urm28hmPQ1Twgpc6cCQ+9trOekK5m7EL5Jr1dQqGIElQVhCWswbgV2ROZ4pGmqsfaRgdcI
	ntDCotT7t9eCN2yCVdu6njtHWUBggBFMkr77L1LQhMuXKYQeur6hjoLEFFU7tIUgu7Hztg
	G79I93BU/NHp1xJvOmOAdUDQW00171A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785254359;
	b=2C2xwUWJFVC4FGKxZpz/pzJ31FuwJt4MYsuXsZaKadykXNxqU/Hl1Mdig36AnWrMZIVDJ/
	6p+CuKSYWs4hhEF2SAqS1gdyAsJfHy+ztulwBm+SfO9uTpz4bzSERaLvIndIbTLxs2grli
	HENI6ToSrEMUndjFNlAroIRduOV6MqU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M2WQ8i63;
	spf=pass (imf05.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-848743155bcso2403b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785254358; x=1785859158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0vBj9dRIN6Udb6VZQQbjYzZIxTaEeXwfaFcu0hXMohA=;
        b=M2WQ8i63IpYzf0sSruh5D4DQHV0//4zVYRCIbs9+k+OdnbKPV+ppnTi/qU2/8u9cOW
         m6zm4DZ0ajK+PIJSTktY1HiiwYXnizDzGh90MSP1AMscfW8B+v/Tl5RXUIKdM4M0QhLl
         WInfD1zXlk8ZDAeWtOxwV54k+uKzcgNhYo0bpN5alJBwX+3aTL/WOVbwcs+DQ5ZgvzC8
         28ZY0B3eiZdXdoJQ9nla8RfR6jJYpOBkm7e1Rz/tI9ohYR1sJ3rTbdv/AkXNty3BpQd9
         L0Nnp7APK413VTUhMbTSqkw0+Va6HVPuOlPorj4QpDvQusL6lXzqcdFgt/8Sndcy49Xb
         /GCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785254358; x=1785859158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0vBj9dRIN6Udb6VZQQbjYzZIxTaEeXwfaFcu0hXMohA=;
        b=PRuvAjS7T3jjx8VkOo3YQ+ZuM4eNUC2GudFPxK97GNrPRKwYeTiOEmOd+J7Jh7o04R
         E3qobbr/3Y91kMKPDFfkLgiEy/6OlOtn6uzSHiP/Mp+2hfOrU3NcP4Ja50Cm18ANhRCj
         07kUvxNvDyEkhvuAaz/HZQ4g64wvtfsll68VryUKef07pEL2pOMeWoRtGgrsiBfezAer
         P7NPj2yn7QrylbMPrcIMXiEpev4dsFxj6A0i8tAbGzGxiBIFIQQxIQThhgomwwE338Nq
         +F/h+kJt6Mml+DNAwO4mtIzsu3lBF2lPQNiCfgu0O+9lyszw7nNS5FqcgKsIPRltc3y1
         qsYQ==
X-Forwarded-Encrypted: i=1; AHgh+RoSllYzpGJTaOxg3H/jur/M5OotFq9QQHb+xlkwFj5DDY3zoouqk8klEviOMgWPAP+yfRsWZk1A4A==@kvack.org
X-Gm-Message-State: AOJu0Yzn3p9cX+sl+9Q2AVT1GE3eO1v4g5aWk3Go5PaX1uPMuHy79tc+
	lhn9+D2EYs2xqylcwRoFx6litJU2WFPcFHkzSjiWj40Q3HxDlt4+PzuX
X-Gm-Gg: AR+sD10+sJcv2kF1lTkpPuV7ZsDVHoCgY5TiU6URAi/j9mPJ2i6GkugVcto5uZlYYg1
	B8CNptFOj8NY6a9voKZPqw7K4F6tJ6E2rZVA92qbKqExe1UEHF1s1ARRZK39OtsTHk/WVK9FU2z
	btvSwF7R6UgC9XTgW/fTbR6bW767EA3bxyMDAqrqaTIBin3fnBJIdFV11V682SPTEOs4+dfWMrT
	cl/+js1OT9kwyR8dfzXaz2jxr7EVf805Gbii1AapmSMRZJhIbHKsiN05JGBjs0AlvR7DdgYrX5R
	p3nY7X9X4F+ZRiXqCEpYCYH43VrIHjX7DRNdigwh3o/Mhqe/WRLxWl7pPPUWlmr2pqobugUW4/G
	bfAfM9ytP7FSS6BKfOa8JkIs97IJdjDmSqaYwNSysIAI0hwD52CfwZmLIl51a+tg7lTwm5SKEb5
	BxMl3LTqxiu6Gm6+dZ97Lh+pfwKe6EJmDtP9DtsoZK6VRrZqIuIMYFyUzTQmrHLv8=
X-Received: by 2002:a05:6a00:f0c:b0:848:727f:2c8d with SMTP id d2e1a72fcca58-84e93313298mr3304605b3a.77.1785254357802;
        Tue, 28 Jul 2026 08:59:17 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe2393csm156441b3a.10.2026.07.28.08.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 08:59:17 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/swap: fix stale comment on swap_info_struct::cluster_info
Date: Wed, 29 Jul 2026 00:59:06 +0900
Message-ID: <20260728155907.391820-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260728155907.391820-1-youngjun.park@lge.com>
References: <20260728155907.391820-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0DD81100002
X-Stat-Signature: odn3opgnbs48yeeirfnyxim37itrk9ep
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785254358-928762
X-HE-Meta: U2FsdGVkX18zXQHOy9Z65Ir8G+0YyXpfdm2qMd2QUEUeiEeAlbrQxg4k8XVdN4MX9+SF0lkQxVlcKZEbPHd4GldcyJVESzgzOkxpRwa5LKzFbb93v0Xmdj5z2jcZrnReIYYntbtTPblRUt3a9vhFukivaqNQK1Bvuu+0NmBkzdtjEdCem+smIhJ5rzuysBGAEbMSbleF/yLFCL/AXrA3mPjDZflnQ5BspN+lfgwmsYXrxIBQbCq6TrllXsAsx/PqTq98UrJrOwautYSN63Ij0DkkBB/OYmQN3RZBHjmGq7i4F25tkMqLBV11kExVvXjDtFDNdJ6e4Kx6gSEJTU3uR3oTW9TqhEkLdBR/68cJs4FVO7QtTv9OeFtPYuonlv4mOOD7oqYpx+QRQlb0NwLHelIP67x7wQ0FueIlNxBag3aeKphIYvUsDQX47pD9cWleqAU2rTIncI6jFm6lX2/n4Omzwsfks2h3O8ni9qST+A2PMVSLCCMwuoZoil8LQLnQTlrGsQqZlZA8/qTPPr+xZuF5f2/T39UswgTgZpmRd4IuRfvddnp+/3gMeNzmMjbIeJ6vTwFl4hgbKarRiOkoGBswahcE13tIpUzDsQCIthAiRunN/iEtWXmWyu9Z6q/j42Gc4CSyG7TSPWXQpUGM+hM2i132qOKP2VOJFWE840HTqMDLzGuUpBbSz9q4I68tXXPqormTxVMgyarI7t9ezUvyuHCkmplUixaLWE+ZBxYxB2mRuP01lAk6RaZF+LjYGZsrDehIMrz852vPiqLDHWxcRZUpNUzFk7co2enQ3V/ivyc4Kbp9s+jPnhacfGGj/ctWxkknPs9X3Ji2dlACkHnrq1J3TqyzrWrVoCdohsx9gBdgmsTDNZx/9F10ZcwZqFf/FvsMiIbrXjYKIH/ScEBKOu0mm0z4Qe6BBNrosGdPEAMt4vzjXyNA/gFf1B8O1oZOXAv8aiyi10C9nTO
 e/0ym+/o
 jW3tzIURag6MY2K6Y0nCNACQrS9qvObFK0miRUPttyCh5js7ddsmjN0QNT/LZZgZpY5Rg1K7GX8XtMP2xDmhNfS9iY8xyfcSgDgwfNt/Q9UmWMmE/EjD9x/o9MuqMovrhO4jMkeSz8MFLr2WWh3C6Hh+CB1+HesMbhU7rF2Uo6yIgl/Mho/O0dRYoH/lC97mdwlwcdZ5yebb0ZjWHVebOxLqaI0qnkK2evdhPi1v/GbLNJoZ3HxwruebpWh2QxbbJHUJ2rvLgTrmEGwW2Iqq07yaKZ990SsyJo/1i39EDOro0DQfOhTCrNwwyCeYfTw0G5W9WQIlkoXc00UtYH6fIUwdIperSYH7uDM0W3OgowZkLcCnqBIFNvPXF7HEeatEd4IHuJ8OMmyOwPTsoKg/jHE4C5cA2KCsdvB3BmVl3qK4+zyCddajahw3LicQjsKBM8KNR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Youngjun Park <her0gyugyu@gmail.com>

From: Youngjun Park <youngjun.park@lge.com>

setup_swap_clusters_info() allocates cluster_info for every swap area,
not only for SSDs.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 include/linux/swap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2cb1d29307c5..e12c73891b48 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,7 +246,7 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
-	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+	struct swap_cluster_info *cluster_info; /* one per cluster, on every device */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];
-- 
2.48.1


