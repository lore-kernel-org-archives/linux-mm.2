Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73219C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 04:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741066B0099; Tue, 25 Aug 2026 00:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C416B009B; Tue, 25 Aug 2026 00:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631506B009D; Tue, 25 Aug 2026 00:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43F046B0099
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:39:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 481F9140302
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:28 +0000 (UTC)
X-FDA: 85138538016.30.BFE54B0
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67BC7120006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:39:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nxmJRpG9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787632766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWFRj4+Vuu4BIcgt3B0a1nLqz2rP8eB/Ak+39tP9gvs=;
	b=JobEZlr4pejGPJxZyjo5NSIllttwkbb9MQV2yYIOl5jU8Bx3fBYLNtKbi8a5MDh/vEgP9u
	eC9xuGHBt84PW+zOuQH9zKN4buWv7tqAplbVcK8i4c0mLrthGzogIttXLuS6WXdfY3k153
	ZID6O0df8L4qD7FGN2dvIl5wDpLXJaU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nxmJRpG9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787632766;
	b=2vrQ48BlYlnR3P5s9uQrt6yFU49Dt0asgvJ4mRD7gjvngoWM0HhO4hABscgs/7IHnQIjPq
	AkWNxt7vm9C/jhoaXLVqSWYdelp1UY0gCX05YAhbOsjJgTHwW2Tz4/Q7LQbkKihD4nbo7H
	AHJVIfXkLAlXlx1Q1IB/B4eAqS7ZjHQ=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d6f55a7089so1420745ad.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 21:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787632765; x=1788237565; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eWFRj4+Vuu4BIcgt3B0a1nLqz2rP8eB/Ak+39tP9gvs=;
        b=nxmJRpG9jcaMSg//PEg7SrizsAPsM1nBTbH0JL8NV64q1FlDY89S4tZ8yIxHNILLjZ
         I6yr9SSZeQd/Svks6NjKbKUTzSqoo+5LCvPbaFot9dMAJfHAW5JwnPIgvjcqLV5J1h+i
         c2N2YLhcnTalx/FJjgaOLbdCHgnfk3P6OmYEFWUAIkusr1F4FDDMypAdOzLlM67nRP1x
         mQXjtd2SE9fPa7e6m3L88jZHAZnGfOt/AjOMwJEd9UuY9unPKFlY8T9e0gRltDE3kOHV
         rOvPL4cqBvKswPqcbo6Tf4v4sREi6iPkgnwYJAN1j4d5oRVUHolQFjlOoYChbzJDMaZp
         D06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787632765; x=1788237565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eWFRj4+Vuu4BIcgt3B0a1nLqz2rP8eB/Ak+39tP9gvs=;
        b=YfQvInQFPcblwop6swJ2tGwwLmwbRaAhL7CV+JG/k/fEXA/IAXxj4CRAAw89EcB3Ay
         MYqoo3v8Avg+3VyHdtrklxoMe6nMWy2yDWDc8/zZPUYcqxuy/FAQfsmj0E/SIFQlyaJu
         dKHJfwAig3gLaDNW1nFxJmQu3zypqq+4brvTacBQLuXIdbnkXPzjr20zSDu5hjegNX0P
         kLE4gWgCuPuoMDyi999aROZaK2jaMbw8ciappWqnAspmvrfhLvItQXPSseYylo6cnzud
         eFQSQ+Wt0AakQ4adRpKehqp3cf0KUWxkHVvDCsKjWSHO60Msn7xgaEekEFRO/OekiVVV
         ijtQ==
X-Forwarded-Encrypted: i=1; AHgh+RoLEOyTtRm2ohyrz8ObZbv1w3IIDk3RogxratWElTZnhiTG+ObCpn5+3+xUdZc8Pefo761NKprphQ==@kvack.org
X-Gm-Message-State: AFuF++mG1u9OP5w7N+bkysfdUXz1rrVPrdkBctqqjm013XRQlfv2GEUb
	FqSF97cCoRTen+P8rT/Ov+ktZfLEhWs5qqgCf97jUmp1W3y9i40vVJsA
X-Gm-Gg: AR+sD13mR5A/PXwN9WhKcy/w2wiUkAUZMPFZd5MAWcAumEaDMUl06dleNG5EmoGBzMX
	xHUEHl614WvLA6vYrhlzIN0M6xkKTyZ4JTFkG2Ol3SDA5bNIce6rqZRPm5AkmD+CzngczE0R9Ae
	G10+949BnglYM1S29ScrAPHBxtBGQQZxCWtbmAh+8LR45AFjnf95kSrB0EBnNVZ+F5N8RxHfXPf
	iRTOqGEFxKNDirkv4fuzB7Q+W31aafG7cQGKNCRJRxhn2pdgCHgO4d/4GHOMM4d3aW20hKb45hJ
	m/IF9SRefEnUmmOXFC3HD5BU6+71AAF4qduDnV3tVoOk48uwavhW6M86/P0LdXxb2tu1Cc3M3qz
	iiMpY/40l/TOMXELpgVDRgC8B8298fnkX5naLYFi0fNiQuK/cIgW1Ez72ZXKe2q2tgEBymdwpEN
	BdwU/k4cCXGmuPH1BOCN3LPuf+b0ofRX7KNdkrNjYiPlrAIA6oZR1fUHjSsJ2GRPWomI9B1E7w4
	SKygQ==
X-Received: by 2002:a17:902:da86:b0:2d5:cb05:49d9 with SMTP id d9443c01a7336-2d670bd7471mr388769855ad.5.1787632765279;
        Mon, 24 Aug 2026 21:39:25 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d6f726e222sm502155ad.19.2026.08.24.21.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 21:39:25 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH 3/4] mm: compaction: don't skip proactive compaction for non-costly mTHP
Date: Tue, 25 Aug 2026 12:38:32 +0800
Message-Id: <20260825043833.2659350-4-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: znns1hw6ncuq56pus9qxqhywu5giu8y6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 67BC7120006
X-HE-Tag: 1787632766-351707
X-HE-Meta: U2FsdGVkX19kfojVlgAi/sBv9NCtQe/V22nYkZVI5XIKcEeFAhec6NdBOp4s25AJT5E+Xa78twMU/hUT3mfsd4+5+Cy31mVmX0ZQ5F6MkoKI9UCVgT/tYEPirtWEfIWiP37W62DQzDdH9duvDmA3SP9P4ClT5pRq8NduktM7+/1AxtiVxkOlQ23vwrwQ4uZGne+mWQNlJH+x8y6uK/7T/fdMYUhSVYZ8tTY0tM202GPC8nfYNc9PgLNIsSRtLO1azD63oLioUsy2jEH5ZuSBnEAlAmGNRsHT+IOhw09mmpLtV5kKsBp3fLEVQ1D+cceb4Vtij4cil7+qV6qLk1oxlFkMUUMVKJXcSDnUFxK6qGK0+GXu4M/gW57JwyqUN6B+myYiIy/dh5qP3iZY2Yy7e05Duz7eIUsilhIuCcAmTIQa4Yo5Si3IS/52qbZfVaufNzD3LBGJynNnWRJa2Imoevb1XuuNn7iAs0rkkK5AmU8StTmOkt+Jzt+lpyIG2mageaSddJ4VkySO5P3d4TEnLAFc8eHTRRxMWSuW19trIe1YlMyYroxQDVFdGF6reUXGSzKX/foh00/SYwzCFb7n9Gcc+5GPWwkbuoD1syTLb8XdnKDFJKv4K4kQrWC1psnsPwa5uH35D2V3b/WhNvWy4xknUzJENqW7kSWhACWuDATQJjDvhBtzZgPztm9p7VmeXIht1z5fT/AgOpAAXuB/wWnJYcPftbZGD5XyWOjbDYHwgS+TY70ZzP34R4Fap/c0t++zdWgNfVSw7mq6zw8ZmpcvcJuddyfdMjIjUWma9zcOU5X/pCS1rI2duQnaK9rGaX31myIymn6MtetFpVtfyeXB95skdNupetkJaRZIGzCCJFLHbjx7Qm7jiLgllDtJ99FhZeVnq+YUYcMfYkLQbXANjwzu+dScypbsqeuKS3p7NR3AQM7RmhCfslJ0gEYtw+9M+7UqPDRU5lgVHS8
 wBPWgv4D
 8/rA63Kg3SwWkk/y68KsNvBofMBitEFTfcwQnDOjVGvsGhRadDTwxCfGsNVIqkWHW0I4kj1VORLpoYRRMDneNPE1P20zyBkGwiQs3MwqXZK85gGHALOTF9gCXmgyXcDtj883tL7Q2Otwu/xHyJCvCzX7diSFw+NehfQGWJsnEFCMgzIjKEpIdPsgoJRP1QrBbcwQUrVYZ9wycswpsxO3otyyv6I8GK/obfFPc8C1x7j//RgyFjOhbIIEMQpfppFX+F1qD57KcBl0BuqNq+lgKhEycrYBqzDd0u3q56FFSFmOIyywk8tTZSiUe8x++YPxY42ZItMQGRS1M5z/YaH+Q7SrhK1g00MMHqabLEiriM1F+ybng7zA/G3ylNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the minimum always-enabled mTHP order is below
PAGE_ALLOC_COSTLY_ORDER, do not skip proactive compaction even if kswapd
is running. For these non-costly mTHP orders, kswapd reclaim alone may
not produce the contiguous free blocks needed, so proactive compaction
should proceed concurrently to ensure mTHP allocation success.

Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
---
 mm/compaction.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index a15ed2576562..15b92475562a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2323,9 +2323,10 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 	if (cc->proactive_compaction) {
 		int score, wmark_low;
 		pg_data_t *pgdat;
+		bool costly = compact_hpage_order() > PAGE_ALLOC_COSTLY_ORDER;
 
 		pgdat = cc->zone->zone_pgdat;
-		if (kswapd_is_running(pgdat))
+		if (costly && kswapd_is_running(pgdat))
 			return COMPACT_PARTIAL_SKIPPED;
 
 		score = fragmentation_score_zone(cc->zone, compact_hpage_order());
-- 
2.34.1


