Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0E8CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 06:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A673F6B00A4; Sun, 23 Nov 2025 01:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16886B00A7; Sun, 23 Nov 2025 01:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE2F6B00AA; Sun, 23 Nov 2025 01:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 728166B00A4
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:31:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E8394F81E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:12 +0000 (UTC)
X-FDA: 84140899584.03.2318643
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E34140003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AlQpLPZQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763879470; a=rsa-sha256;
	cv=none;
	b=aChW5vauVS39fID+0lr9g7npJcecRC2f/SPcYVIBYK18IC0zQlCHBtJofX7o3bpljGOLzh
	kjsMt+2CQD2En91AxaB4E81XioCJnHzkuag+BfejtV0lPnIQ9ICJ/9jSdhDmU+ZjpaQEO+
	ljh3nFC286q7MWucPoqdzoNdBtxHqy0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AlQpLPZQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763879470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOD2aQKV3axDn07/bVdfc1LsSZxl6BJ8A2aT5B+TqvY=;
	b=Gy++QpKxTP5RxPv+Xy4jPLJIN1v8Zn5n5bWn5AtjlvnpjjGtb5yRRPaseVr96tt1GGlf8E
	hYn73HjNCRU4qB7osBBYsgdDMsvDxRN266waiqQbjjpGO/zeP/PS0MYMiXaV/cz3k3ncbB
	CtGkv8MQxwc2P3opfAqF9eoIzESAMxA=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b73161849e1so485479466b.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763879469; x=1764484269; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOD2aQKV3axDn07/bVdfc1LsSZxl6BJ8A2aT5B+TqvY=;
        b=AlQpLPZQ0EJD12jw+YfzIB6biUgdHpDIOK9NMC0QoTfnnC97saDAJolxfhmVMpzXkE
         k2Hp9DDAq+T+Mq2e88fnmK+Kvrxrk28PIXiNMb9E6sDzV0gMjYkWQeCMvnr+VU61nbdl
         mg0g5orxXa/jjsjtby7agiCmvGZKfHKYAx4C+e303jMNZyRpRNLLNC1H2e2CepWHb13M
         63U0FXMMS1jrb/OYnm6CkVA28siGEwmGdBiCTVBUxd1OF0qkUh3E1H6Ll1tKN2bt8EfF
         Zko2H4G/41sBL9atx0oFo3IVsdBZ07CBnYpDMHI9S0FqpCeqHo+xKraL4trexj7yZ+Gn
         HbSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763879469; x=1764484269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xOD2aQKV3axDn07/bVdfc1LsSZxl6BJ8A2aT5B+TqvY=;
        b=IR8h7T6qolFipi2tmuRjD3cbzdJdN9WELxGYsbjaYRJCEI1iuVlyFVjt5ckgx48pq/
         /qEUBK3HhKx5U1B3y+mtu9DIjeCG+SuPRLXyM16AxD2n4S1KcIKPQX9wNN1HYOKcgduE
         YKdI2QfB4Lor9B2VuQAkFL8aUTfqynKppOkhGFzIsO+dTiQQkOpDSUHM08nx+ns9lJf3
         qd+wo3iBPXCvDrWKBs+DeV2IVwb+VBEYJYj7xnPu0wUYFedL61HBxScjKUyDPYWoDT5E
         YMwu6WFDc6Gh4DLp1Z4/AjmuHSYwWhUF3JgtL7ImEKaftEVPeBUeIe4Pf1e9DgGQrpCn
         hPgA==
X-Forwarded-Encrypted: i=1; AJvYcCWAygB59RduHcgOtXYbWOLOG/Ulk2gzAP+Fk9LaLW5rMuTRggDGeNlkOdWtYRD4p0cphoy2pZNfCA==@kvack.org
X-Gm-Message-State: AOJu0Yy5edJHr510DJwhzsUU2jBUnWDPqs5KFIdhJL5xlFQeijLKDNiq
	wAobNRtozdOqlKeZsCin1TyAbBLpy+/QcxYaMruzH4NZAgAVaA6U4FNr
X-Gm-Gg: ASbGncv9sMeBhNZf3yCDiuP1boqAJcPgakhz1CrWUfZl89XQAY68NGHveQgJFNaOq7E
	71nUcZsFDCKixp0hN/3DcfWEwT/iQsygHhArTBDfgz3YW3DEVuQ3ucxnWmMznEQOC3P7yecC3wX
	PU+rKzO1ko7sgDJtYclfWXE9CN8QZRf3iO1432xwnWCx03Bt5pfqraRyiFutb8C09TLigviP9bI
	sVliwbLT9APtR2kHiMJFMizJApJ1kpeYPIfh02pTFMU6A2tGpDz58kYdkQvbLyXrKfKL20NgIJw
	TIumo9oDdxLSn52B+DtmwgSIYR3Hzfkam1jvLZGkpcH/ER5GK/+uhciOP0qSJ2yo5V4aN/dzgIn
	3dJ66uqhBEduriS0iRyuMFsO66oiwSuPvC0qeLnHG5M9QQQ7lUvoKMdF3KEg7lWEpTectkC4N67
	2BCKk1Qk51KMjJcvqbSycJqf2/umhmMBybNI2lGVyCjJl2jnzP76Ti3+tAvaY=
X-Google-Smtp-Source: AGHT+IE187VL3hUExsJspXYDW4wFYmYGutUdJGgD2n+2o5I+ckya4M5kz9tDUBfZuQeW/8hgUO5zZg==
X-Received: by 2002:a17:906:181b:b0:b76:7fe7:ff37 with SMTP id a640c23a62f3a-b767fe8084emr434076066b.18.1763879468635;
        Sat, 22 Nov 2025 22:31:08 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cf0435sm929432866b.4.2025.11.22.22.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 22:31:08 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 1/3] idr: add idr_prealloc_many
Date: Sun, 23 Nov 2025 07:30:52 +0100
Message-ID: <20251123063054.3502938-2-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251123063054.3502938-1-mjguzik@gmail.com>
References: <20251123063054.3502938-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E34140003
X-Stat-Signature: 9fey79mixqttdxb19fd984rf9d99ny5p
X-HE-Tag: 1763879469-80303
X-HE-Meta: U2FsdGVkX19XJpNNYjTFJAr+XPjazzO2TMkQkmlslBgydSvkjNEFbeOZP/aJnmMNwgnTEqkOElqIEy88OY9D5XQUUiZH/9km2bqyzxLdmkBPSbSnXK4bqse8Qy1Yy7BQ5d6vycsm88OGj30SKJMUDu1IZfvK6HszafXg1MNxBvGoXUolLIlj6Q0XpZWqTOFJDF59MUyHH71K3IoZbvFvMYwIYxm4Qv3hqfPWga4lFR4YgyLaiGiBwESVJMqSG3zeFUs4O8BxwIXhqmTQUbnHdvG6RiP+5ku1h0BINTt1vzH9qxV3pjR6BzBgHhAcT92qn+fIdI+VmHbGYbw0bkWf8qT6irbdMqhrKmvBsK8c4ZOEY4t77If4+OMC+wALjDub7am/1Ep2pCYbgrFENwHfGd1SiTcWXGgibJSRC5fX7OJwjw4laL4yDOLGxtSh26QNQvb4JBrQGBBZuY/ZBrJZpa9439HYx05hosvjiADLJpEZF95JRPTDIOmGzrHUg4AKVYZJ+t8g3CWQnVD69tgwLQTozcNBDtVmA72QvnVQ/TqSWFiXkrhKeLoHg/oFHM5k50DxQu8YSRClMSyine3847//J0TgPY4jMLS64KmpWLb26V4m1f6MXsAuoe5f73/pWK4qUtfK7g3rhnGYlcbAZESlRsW7J2b1f5GCOVwATQLNfiwsXcCuGgYD0S27IcmhUikkfrE8CiXNs/Jpa3pokZP3/eSogVBGX+29+4aTqXvlpWpQlYPtCTM1QSamOlgDVb/XIWxWQqp0QFvJnpG0w+5Un0qvDgiU/G5Qq5wfIDWvvBqDWJBQoiRdpRW3rFczrTwL0HNUXcOP8P/Bm0JiAkALYciBn7J38OHgsa2IgzmXoVCbvWTPIWbrFEt6lGNFxk/I5nTW2hGqtnnEHWb0aEMeGbAmjLsUA5Qdnsowxu0B6JnRaSZECpWby0fLhESvGJQpEV4xd3W3P7bHsq7
 PFpv/0Wy
 tXae9FLgV2hKIh+IkQaVfWuziKlfs6MfvTOLXSDi3n5ZGM+Swe5i96qyEasyIbt2sHlGo4PowRcm4FzR1l2NMvLL0GX+g6lFsKxefMG3/4d2h/ndWLnRFk1hcOVbJopy4pIqCUbWiX33xUye3ewicM6gosPpdwClYLoiJYKabS3nLh/FQPYq3GL9i50eZYHOQS8EC+S5QHQhB1EQr1mgMN8PWeucnhfbfbbxAAFrb4Knf4wDUlbajzMzFTqR1zYWByugmIvaNJJ/2ZSdxnpfq55Lw/6dKjcyGfAD+20d01B+iNPQG8KbtXzINtyjoCdXLJl1C+/cEqHGTOFd9BOLl8h2E5ccSkAihIIl3X8jLxNSuKztBfq2rTfBgqM1qSrcSIZmjJvFBcutJEjEa+2gcdJ5SiMrBxH9fm2vPNClkPL45Q8scYlawFWyVwjExQ1TmM151gozEfPJmfjQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
---
 include/linux/idr.h |  1 +
 lib/radix-tree.c    | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 789e23e67444..c9aeae695442 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -110,6 +110,7 @@ static inline void idr_set_cursor(struct idr *idr, unsigned int val)
 #define idr_unlock_irqrestore(idr, flags) \
 				xa_unlock_irqrestore(&(idr)->idr_rt, flags)
 
+void idr_preload_many(int nr, gfp_t gfp_mask);
 void idr_preload(gfp_t gfp_mask);
 
 int idr_alloc(struct idr *, void *ptr, int start, int end, gfp_t);
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b..2e71024e5323 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1459,6 +1459,22 @@ int radix_tree_tagged(const struct radix_tree_root *root, unsigned int tag)
 }
 EXPORT_SYMBOL(radix_tree_tagged);
 
+/**
+ * idr_preload_many - preload for idr_alloc()
+ * @gfp_mask: allocation mask to use for preloading
+ * @nr: how many calls to preload for
+ *
+ * Preallocate memory to use for n calls to idr_alloc().  This function
+ * returns with preemption disabled.  It will be enabled by idr_preload_end().
+ */
+void idr_preload_many(int nr, gfp_t gfp_mask)
+{
+	WARN_ON_ONCE(!nr);
+	if (__radix_tree_preload(gfp_mask, nr * IDR_PRELOAD_SIZE))
+		local_lock(&radix_tree_preloads.lock);
+}
+EXPORT_SYMBOL(idr_preload_many);
+
 /**
  * idr_preload - preload for idr_alloc()
  * @gfp_mask: allocation mask to use for preloading
@@ -1468,8 +1484,7 @@ EXPORT_SYMBOL(radix_tree_tagged);
  */
 void idr_preload(gfp_t gfp_mask)
 {
-	if (__radix_tree_preload(gfp_mask, IDR_PRELOAD_SIZE))
-		local_lock(&radix_tree_preloads.lock);
+	idr_preload_many(1, gfp_mask);
 }
 EXPORT_SYMBOL(idr_preload);
 
-- 
2.48.1


