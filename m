Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FE1CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13328E000D; Mon, 15 Sep 2025 09:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EAA8E0001; Mon, 15 Sep 2025 09:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B648B8E000D; Mon, 15 Sep 2025 09:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A71B68E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:40:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79B7811A650
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:49 +0000 (UTC)
X-FDA: 83891595018.24.BA99807
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9C1FD20012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:40:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eU11aaiv;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757943647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OV1e2VNq+22/ypAjT1R5Vw3M7LwIDx8IopA7Om2mhzY=;
	b=n9mCk6/WizDwRb2/z/H83NBWZmoQmLyg4TM/XD9S343qsBneA+hb8F3N9Xx46Cr3tjsAMu
	Z8ynZHepKfLq02FlJdQz4FXm40nx505KGvAQ2OxQ1/kicttltnKZD3Pw4cs7xNbDHnyBwD
	k/aHwcASxi0efpto1/kBsvE5I8Uj/qw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eU11aaiv;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757943647; a=rsa-sha256;
	cv=none;
	b=epILx6xYdLO7TW60UWBDFdArtWea+nLe5sqUvb1MtEICCthrlVannzvd9eeI/xhKHJ6ufm
	abOYWsxffJUnNnYLwB11P/irtnW5ahW/Gs0i/69/QZSfGD4NFt8DevtPe1bA5/oMtG5/M7
	bobYnnaRLLZoohcm3ykeShFIXSOKm4g=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f6b0049fbso4875405e87.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757943646; x=1758548446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OV1e2VNq+22/ypAjT1R5Vw3M7LwIDx8IopA7Om2mhzY=;
        b=eU11aaivh1VNrxYX+PrSkcY4Lt2vrQayycFWStgDQBLE4OybFu1NEJVr7k8zQsWw0w
         kyNh/mxu3p4MydGAPkY41SClJnKZUhEwb3ixcBQhc6L/IIMXhVaPCCV8oEsxF2MoB6Ob
         xHEUP5iFexKGYUKnWvROaRWGPKdJujSRyeMmV6sPqmBzzMuVA5Y+JP3QsZZr6UtyPR8B
         X9zMymeh0Y/v7y/rknE/kw11G4sUI6jI+cSBf8/tPDTTz1hkhQEpqqXnIm+LpZbkw8IR
         YstY3iCcAy+a6cH0kB7SV3s5fHeui8tdD6yDHXC9DUESA9ImmNWKbn648dfqpq5xQprQ
         JR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757943646; x=1758548446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OV1e2VNq+22/ypAjT1R5Vw3M7LwIDx8IopA7Om2mhzY=;
        b=OzQZxmQiPWe/X+NQ2nJ5jgfSWCHqJxRyuMNTfK9ZzZfgWEoACOPpCosTU1BMbq4Z+o
         yYhxO0t9Qcsi7woSsQ4VZTREGdJfvGgpPA494f8Pal/nHVrkE0sBELvOz1QYgX6AhJ1u
         TZBI2u4t7EZuYlc86cQEQBSakI160jEm+1jtHe9AxL12a2yYxzi9tscsdZj0YQ4CVlz3
         bVJC9sd24afkBeCeNQbIiSd/pCU/ItM2Y6kzZRtzLQz1iYi2ezixh0oKEXD4UbuaEFDc
         iGpJlcU7+5JDTJxEMFPwv8uiY73BuMS55BNDh2F8KnQbnI38lPDVTLakbh5CBqF9LS4Y
         aUuA==
X-Gm-Message-State: AOJu0YwUDRWLN7nACLa637X17I4c6XotKkeA44HIFDfBj9Nqnw/XlDEU
	Z//rXWhwlIDekEIgMFc6mxvdsyoK7rGJcRWMfHarZKlR9p9CXubQDTQcBNKEKw==
X-Gm-Gg: ASbGncsW3kLqgkuoU0sAQ7l4uAzJNztH4GXts8ysyxV9FiUf3MShB/E5QjynOp3/VsY
	arpsv1yzkzup7SiPjpnm9j/UIJgCKuo8gT57ApqGtzgCIjua/DpmxSuSz51tEzSqYuXpK1EjTbA
	IuzWyxAGJtEinf19+4rvA1wtkagvS4+KtmEndx//1bj7zZrRFVmtAf1B2azmYWRsSYD5evFiQZ+
	nP7SFAHUU9vF7e995kjrMfpk10qbH9n5GGQGMmRyJG/YXJYsofpkbVoQ/Ct27TGNc1R1obrkDcr
	4dD3qqpStS+TqkDqadxlM1nQdkSPkysF1ZumGjpMEKjR8BgXH6T3HGc2Qvo/UlFpLr5QxzL3JtO
	fMICWJ9ehWv0llR/pj/1RfJKwjic=
X-Google-Smtp-Source: AGHT+IFMl/8ikQKbN8g7KTI8lfUmWOfTByEM9LJHJSKPa4fW2Bo+fguqUFOHKb+MoWYZ1jAerIJ9wg==
X-Received: by 2002:a05:6512:61cf:20b0:560:9993:f14d with SMTP id 2adb3069b0e04-5704a3e6909mr3838025e87.3.1757943645704;
        Mon, 15 Sep 2025 06:40:45 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-573c8330e54sm1150719e87.63.2025.09.15.06.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 06:40:45 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v2 03/10] mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
Date: Mon, 15 Sep 2025 15:40:33 +0200
Message-ID: <20250915134041.151462-4-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915134041.151462-1-urezki@gmail.com>
References: <20250915134041.151462-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C1FD20012
X-Stat-Signature: 1cxrueq1555kfu81e4yppkqnu337n374
X-HE-Tag: 1757943647-554080
X-HE-Meta: U2FsdGVkX18j20CHOok5cBVDBwNGZ2QE7KCy615jl3rU4KfaA0kcasz2N8kOlK9X/X80AV1X36Dvs1F+2Ndbw/JNFrB2+iRRnxrrjUu6KN2+wRwVBr7Pz43Un2FQUyqyvfgIVGBnOSj12GJf5gbds7PZE6qQmFsIC2L3zBr0YDKOxHDqKcRvzuYmy6N11nKm1nRjcQiKE11i9O5Dd/D3rN+L5a9TvipA2XCat0Sw/5tbtge/wdA8/oQDaNsO4A6jinIArAx8Jxj4jhc8sRn/gBvOVpAKx5K0490KnslfD82oULXTc/2ft0n5W+ZRNI0cgV5URYvw83clJ6ZU7dtKgCI1YWCCud1JRzSKNRMuPWOHrJNDT1ny8k28J+DJ79AhLL0wydXFbi498s120R18hZvaNegbPQ+d8iYxk/xYCxV+Xag4p0+r/IlU85VZ4E5LnmfknixinpjEYsqr20z80PIdopA9otoZPuX5fUuJyGh95dWG0/vHaX822D7vOwksDtLQV/FaVauajjZEpvIKSzPJXLOoNmnb0WNqzN2bAVr72Hqzn+LGZyZ0rDNpC7Zha0SWTg0WVUcHwgV48BnZym+mogUwtHeloc627KRhg1ETqz5NWCDK+ybFu7+aH5YL8W2FSiMW6yVd2q13wQtmplGcVxwKrDqN28WyOeIXpPcPGelw/MgTxPudjTbJoTAEnPj9aX0QYNkiJgYwsJx2QcAPhOSezxwg7ZSTA/dY1YRVpAGNzE6ldTSk5kGZhOYSH4LElBs1nWW7crqsC+/TDW22lgtTNGaGM02Kqz4cCRbO599A7PXkQ2u3IoCl7GUmgUhxBDcv6laDpfvPoP8Psbx0WMbpDhjLGDFl93nPa5GAlGmGb8lwMONrl69ciXhEhTFv2zIhtfDSVJe20KBv8opjbcSe40c5XiBKC2mZtTLcmKCGHoaaEvmVd6oi5ui0uBLHBwV1DjmGCXaKplw
 ZwszbXWd
 g/zdBJWeuKJaji3tTr6bBsk5Sya+jL6kiV+gH1e3iyyViVdiaExc368EyjPIl94FkuTxOdXPaVW08AcP8mSIZOm7npEqFIYBvZRaFFopkkU95KeBrcUGrFQRvC3h7v4EUye8ORTe1UchOQwrYOj6umbcdGdkseZkUt9sTbPqZN3p6Uw0kmJ/OzO5NEorvZiF7bMLaBnjd9DCNy8iRTHuIWySdkLbe4ZIdlFpJ8VQ6Dw2LEujeH8kU857KeH3mpKFF//b42cu3ETaPPp60M7uxapdu1hVLPuxDZIHj5t6DtUsu9DGIdB0BB3Y0UaRH36fBdccaiXh/xxDo8Nq3zMbOjylHGnQljT8htxHfVg4I+8fJsbDreNWX62ZqkR0d6/iTGylddasOM1gw0k12CS4PL54oLGmHGRfBVDQSZ+HSbKJfbjnh12OeF51z30GjqlwJ0Q67myyGUnY1Ut5ZFUiiGe5doGMc9swqNZOPhszhhWHCOno=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_vmap_area() currently assumes that sleeping is allowed during
allocation. This is not true for callers which pass non-blocking
GFP flags, such as GFP_ATOMIC or GFP_NOWAIT.

This patch adds logic to detect whether the given gfp_mask permits
blocking. It avoids invoking might_sleep() or falling back to reclaim
path if blocking is not allowed.

This makes alloc_vmap_area() safer for use in non-sleeping contexts,
where previously it could hit unexpected sleeps, trigger warnings.

It is a preparation and adjustment step to later allow both GFP_ATOMIC
and GFP_NOWAIT allocations in this series.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2..49a0f81930a8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2017,6 +2017,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	unsigned long freed;
 	unsigned long addr;
 	unsigned int vn_id;
+	bool allow_block;
 	int purged = 0;
 	int ret;
 
@@ -2028,7 +2029,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 
 	/* Only reclaim behaviour flags are relevant. */
 	gfp_mask = gfp_mask & GFP_RECLAIM_MASK;
-	might_sleep();
+	allow_block = gfpflags_allow_blocking(gfp_mask);
+	might_sleep_if(allow_block);
 
 	/*
 	 * If a VA is obtained from a global heap(if it fails here)
@@ -2065,8 +2067,16 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	 * If an allocation fails, the error value is
 	 * returned. Therefore trigger the overflow path.
 	 */
-	if (IS_ERR_VALUE(addr))
-		goto overflow;
+	if (IS_ERR_VALUE(addr)) {
+		if (allow_block)
+			goto overflow;
+
+		/*
+		 * We can not trigger any reclaim logic because
+		 * sleeping is not allowed, thus fail an allocation.
+		 */
+		goto out_free_va;
+	}
 
 	va->va_start = addr;
 	va->va_end = addr + size;
@@ -2116,6 +2126,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
 				size, vstart, vend);
 
+out_free_va:
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
 }
-- 
2.47.3


