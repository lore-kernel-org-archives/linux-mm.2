Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67307D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 05:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE4166B000A; Mon, 15 Dec 2025 00:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB2C6B000C; Mon, 15 Dec 2025 00:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2506B000D; Mon, 15 Dec 2025 00:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ADF266B000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:47:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 55E8B14032E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:47:42 +0000 (UTC)
X-FDA: 84220623564.07.B0040A3
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74E0B180002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:47:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WCGxQT9c;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765777660; a=rsa-sha256;
	cv=none;
	b=ffosP7eVHzMZLatY2f7F1YQREB8H/UPL35Q0KYHzsGklrAXFeUEoZk5DsPfPCqg7oUlQ0s
	2GUGO8DDxb5fy0MyByDobfo0LEig2rNUW1mooVhqrxuxX5//4/DVbNpHw5FNipmxbEB12j
	TdzU9oCUp6L2MGss1YS9wi7izgLbEX8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WCGxQT9c;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf24.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765777660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4bgQIWtnTguUUfAUeAsZ365C0z4iWE0GTuA5IhKscc=;
	b=tO2jK4L7E++QPFDORyE1PG0hGURWgSGNn6Vg7W1refcmTsZUD8ptWQT45mmptr2ehAkRA8
	+P9OFJOfFU2c24zVlmB8o6cWQzTvJAODfmPRQkwUGR7xnQEqDc2HdJYkuLtR6cxYfSzpJ4
	94S3BVMhWYZBeGeaJ6vp1miPAd2/i3k=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0c09bb78cso6878475ad.0
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 21:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1765777659; x=1766382459; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U4bgQIWtnTguUUfAUeAsZ365C0z4iWE0GTuA5IhKscc=;
        b=WCGxQT9c2ufeybjiy7t/6+sUJpfAYdulPtYhjVV3BCLfhPwjhquHPVV9QUICJjK6ZJ
         FQmsKfap+x+PvU1titif10oymSKnmaTyNL6UtluPP3sfVSvb2E5X39leaf+2aWZtq2Ia
         Zc7YdipOYr5rfDzibdV50//E+GbBPWgvdPvpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765777659; x=1766382459;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U4bgQIWtnTguUUfAUeAsZ365C0z4iWE0GTuA5IhKscc=;
        b=tSdxfSFK4moWIO+WdaurmDGkQRLQf220uBiIq/nipY0t3mTByoymenNuBL4WkR+Buw
         YuSxXEqamm0EdzBkRaS96BXW/sqXXr8K8Psn282HqVO/d/Dlww0btPGK56MZPAWRY4AP
         2AF/fz6RovLcIArE3M5Iaeb0PWPr2Bx8xcNXzbtOUd/uUTDYWH3GM+7XHnGO5rEGSFbj
         6ty80JONARhYgaVaS7Ftk3gNF7cajVrsBICCE7KIZVTduRWIWamzkXBAmMBrfLB/Kllv
         T3HL57z+SBLLUIMb09BLhhoyA5X5BdOu0lTx1VN6EE6bjQAl8zaLb+jX6+FbTtyAo8g/
         xsQg==
X-Forwarded-Encrypted: i=1; AJvYcCV0gK/n/OXtnNbv4VWXZAFb/iaBuaGfxS6MQ2eM6ZbGCD7JYegBOZA+39tKJsft3MAWwe7Oj+DrzA==@kvack.org
X-Gm-Message-State: AOJu0YzWTBVpigCBj8DXU3hw8EWu/hmq80RcPeZsljW7w3KGTaySJQvs
	XcVloRu+bUcsR7JzK1Owl5obTpiLZu6EdkPgcYNuY+ZnuclmY/MDuTfTrFIlqyDwHg==
X-Gm-Gg: AY/fxX4INQxwMOzrYM3XuVUYoYOxP2ZiaT2mTGk45cDrU3SY7dTkFho/Ir7udtMPmr7
	ilUTKnKtE2amFt5mRxo5I8sosfcHIeJ5YUGRE3bO8erORyGsLbEa8TOkevXO873d9SqI3fAVjrz
	qbAbGqQj7xsIeT3zJRCnGoeZCKL1hDe/mu/kf0tJkcgMDrl9pV2nEe/JU2Qu85KvDZKTojRm6d5
	I76I7GIp1GIkTKPLu4rkUayg0M1vWFUDas69SKpxhJglWz9vdmjWymEdeqnA0vZByOXKi7zkLg+
	NkZAqdLl+h3DaQDPYTaEKF6hHtLoAAe8ECCmQ5UJtNvFhRqLmJIJsKoheMstFQEYrJuFS+exzLN
	jj8jOvrNmfuhpWfmvbTAoWCBRWOuGjiwXQUQbSmLTZq12Iev10p7pZ9mQ27w/tElPg2oLYONJSc
	QYBXhzZTZLi4q/4cZvALpGDXVjAk12WSW77vhJD4xGkMcdhZ6CNBthsmQao5Bvk6bNr1sDZdZvL
	g==
X-Google-Smtp-Source: AGHT+IH1pv7Qw3Bz8dzGDa2+eo2pIwyjJURHPjoe4mHOqDp2Z8Kt8ofVXUXNMGs7j6q5q25WElVfKA==
X-Received: by 2002:a17:903:38c5:b0:299:daf0:e044 with SMTP id d9443c01a7336-29f24e6f768mr110715045ad.18.1765777659360;
        Sun, 14 Dec 2025 21:47:39 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:88fa:c762:fe19:6db7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a0bb39db53sm36391945ad.11.2025.12.14.21.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 21:47:39 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 3/3] zram: trivial fix of recompress_slot() coding styles
Date: Mon, 15 Dec 2025 14:47:13 +0900
Message-ID: <ff3254847dbdc6fbd2e3fed53c572a261d60b7b6.1765775954.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
In-Reply-To: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
References: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74E0B180002
X-Stat-Signature: mqp5ysmtff5egu7mnigp4sy6e8uajcd8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765777660-528505
X-HE-Meta: U2FsdGVkX1/UKioZWHrcYTgUfgtlfRz0p0pNjI6dm9g30vp1KQVh6LuQcblg9acDNzkRuTnV310giE/rKe8aOcHLr9SvkXaiUv3Le4WY8ynlSOtmhp/WzbBvwnaJtv6va2oi5kbQ0zCJcq1YppDYXif5ho3LGME7u4GNJcjmBM5itjHRDgWaTvTOG63RMKbVcHM8xwqnlCooTczI1uW4YVI7gXu9fAigB6AEwDbqIB1KcETcGdrze06727QW3qNHrBfKLgbYJHXgYatIL2Jnu5QasCCAhbof4wUoKISwW9/gSsa+XZBirbYt/yI/fF4G8pmgNcuhTqNlesomZ3d9xOFxXnzlJrEnqu0opfchsuK8+JtoLunmmoSlWooPoZHxostUCOOR/BuZxddxxF4t3hllAwZwIv6LwCaDmZTyjepcpf27jjUJrYHVXqnuu7dvtU+ciUCMlN8HGVMbL3kDIysCfPGfUo60N1NjlrTHz6xcg2AJ+rd2DlaI/opgdPdHqR2vQTnXBefxhl1bQCX7yGsvQz5P4lBrTF/wtNU13Y9dEhVBy0iK1KBmjb+q6dRAKnG1FKgKB4uwp+bBmldiUEC+L4sBh669AuDm7HQtC1isjtoBcL/l9ecms1vlIXiboewymDVOzWxSgXSKP9d+Np/wZ5JK/JPIclv+4fVLvqos0ycwhXj2/+BrJFX0U/tCjR6gOTblkSWldFkq/9VcNImJ7aqd2bRR+k5BwajLqQXrDBLgbtwKw5T8SUIyDX0oHIhNUIBXyoJIrQuklzR27pa1E0+mdLsR/n9e8QxHFjMsD7YCpjnVlhkaKaawDISAkegRqABe24WiB2RH2g0ZhSgAcsW9gHnA/3bAY+n4H58s4VJUg16igUiZWbiWGDIMsv4Y4ju1jjGBO9J5Ksk+62exWtd+P4EHb3E40Q2E+NEv4CRH6YIlrsRvowQOF4AiH4ssIia8eeTqXzfBFb4
 kyc4+hfi
 eh7SG4KKZmyefnx7e9EM29Hep92IhQ9YXsh5aeRfSLnme3/QdUZhx7eRvWyh+SQz9DDV7mxGuQimtMPTijy9EoRdYX1WOW5OPyAupiRDLs9xSUiL94/5Dn9OSu46mbcsbHKcKdW/+8HbcjlR5mUSdgRdhyvkX2kQZI+6CLaSf9N284py5TFxD5as1P2Mo2zWYzZ+X1/yvbKlsSsWol7weUKaBt22r75Lueo1DXLIh5n6PYCUmyaZwji+82CmPlTiwjiqfgE7Dt+jTjJu2IGabmvrLrp/eu45vJoQy046ZB2vpOKM0DUOnalRCucFoU2YN5cLNTGf6H9uiBASz1OPlHlFUBrcjoyo45CXi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A minor fixup of 80-cols breakage in recompress_slot()
comment and zs_malloc() call.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index f00f3d22d5e3..634848f45e9b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2517,14 +2517,15 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	 * avoid direct reclaim.  Allocation error is not fatal since
 	 * we still have the old object in the mem_pool.
 	 *
-	 * XXX: technically, the node we really want here is the node that holds
-	 * the original compressed data. But that would require us to modify
-	 * zsmalloc API to return this information. For now, we will make do with
-	 * the node of the page allocated for recompression.
+	 * XXX: technically, the node we really want here is the node that
+	 * holds the original compressed data. But that would require us to
+	 * modify zsmalloc API to return this information. For now, we will
+	 * make do with the node of the page allocated for recompression.
 	 */
 	handle_new = zs_malloc(zram->mem_pool, comp_len_new,
 			       GFP_NOIO | __GFP_NOWARN |
-			       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
+			       __GFP_HIGHMEM | __GFP_MOVABLE,
+			       page_to_nid(page));
 	if (IS_ERR_VALUE(handle_new)) {
 		zcomp_stream_put(zstrm);
 		return PTR_ERR((void *)handle_new);
-- 
2.52.0.239.gd5f0c6e74e-goog


