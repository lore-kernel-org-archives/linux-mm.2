Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE87DC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 12:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52406B0088; Sat, 29 Aug 2026 08:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03AD6B008A; Sat, 29 Aug 2026 08:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19A46B008C; Sat, 29 Aug 2026 08:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95E2C6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:30:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22EFB80116
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:30:56 +0000 (UTC)
X-FDA: 85154241312.27.32CCBA9
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3ADEC140008
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:30:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBNR41D6;
	spf=pass (imf09.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788006654;
	b=ivn/v52PWQ5ign4QbBOLKr/XLUb5AlghxrfSXTtxbcxr0vvVAlYK8VHm/Cu+lQ8ozieNkI
	k6ge5fTQaGYJPOExuNmdm073irZ6ELCqCchlmbc/DjbAhs1/SU1i8rcK4Bq/uLp4r1WAQK
	Y9EwDmIIXPeyzn5oixArw0TGPrKJaJQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tBNR41D6;
	spf=pass (imf09.hostedemail.com: domain of qwjhust@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=qwjhust@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788006654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fr4WGpkpz0g/RZv8ki2EXdEf5V5M5mLF4YRCrDVH0E=;
	b=VcDiJrc+Su+DBDkD1Y5G4FTxLteTIVL8F24RfjxfNx122i+rOvg5gV81bTLEQSmSaAEred
	RwDkpMvr+iLbNZ1IQfvVlxGCi3Tk+zY5kxZ0TQ6oqjWbJMaNhvixxzJgu9e4IhJ7j8SdSS
	bs6t1eRLLE7Wi6p6z4vGJvB3ZdqkdIs=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-396b3d0df94so1876230a91.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 05:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788006653; x=1788611453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5fr4WGpkpz0g/RZv8ki2EXdEf5V5M5mLF4YRCrDVH0E=;
        b=tBNR41D6IDW4fiXlVlQw8kM9D3xSiTFToVsWcPxD9VwqLLXPnuBrvXlJ3on0JzTYI0
         IYZhny5KQQii55AdfBDN72dkE53PBjyAY8+hP3tUH6yH1JJVChwJk66GG+JOxSXUXMJ3
         3qRA151ol66jL0xnEiaTX9TyzVIRefiAr/3Xw+Fba1rUAKAAU/10NGDfsnpsnG/pCKZL
         5uz/oZoiISVNqglG8PQIMYRHZ1wwFw+Z6a8xeOmDlfrEnVjzsYR0OTOx7zvQnG/2AyX9
         Rf8M1lp3rCk1GGon4CilmGnOuSVmua8cswEaLsH/PpPhZ5PTsNTJRJ4cRFzTHdtTePxI
         YK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788006653; x=1788611453;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5fr4WGpkpz0g/RZv8ki2EXdEf5V5M5mLF4YRCrDVH0E=;
        b=IK2plb0vWBiU72Yc/5SLq9aibUzC3JQl+77MqXSqjBMePzlqMl7LLzKRbrY5pynFw7
         NwEQRxiN0C7Tfy5Xfc/+32JYqTXPP18l6j9t636yG11Dzq56Nu2TmsTJZnNKXZrwg2Fc
         totBQxuyr4l/uhN5VJK5lchBLm2GyRVqajTm3y0LSAxmpEY1W4570EsIq8JZF9Ea0RdT
         5MhyBUNWnl5JivMBhT+rDgkrr99XRW4k4FDc2rZxTYzZfvWrGoBFfVfAsIJ3k/O+QVYK
         sV+6bRabooU8QzPWP+2cZ8tAZFZF1jkZT2hX14kTE+1mSVAUluyVRcsEj/Ufk8zCnCL1
         7Egg==
X-Forwarded-Encrypted: i=1; AKwUvBzbg4oq62VpAgch4o1pyYf2hi42BtH2Sl5U2XMMJQO29Cww/nzMnz3Nm1mzeQ7rbO4X+m/ODU7VfA==@kvack.org
X-Gm-Message-State: AFuF++lzPvG0kWTHi3FeMxBoHAK2Nz/9ANfo42VNG1d+hV0BqWcRxpWZ
	p3LiHBNn4oM8i1aClO4b79Bwh9YGeQWun5ToTrWNGrMSW+Rn5AMSFJ7g
X-Gm-Gg: AYBFou3vjYTzrTNtAlpVETchBArBnbhH1cWEPNYoRvGnc7L61nhCw/Saza55GMiVx6F
	CnByKe9Atsc6mb7yBetsk/uH9pug5kp5DgQ+7aCz5EeHoD3Av7ctgc+KA7hp+XdIqbgXiCFcAYz
	Bv+q0d2D6v9mdHrvx32/R2zurF1rs4S5wSpBHaEND5uOKrUKUmyXwQfZV07/qloarCFOX8+XPJR
	RxQ3WT2hq0/A9/qThSyhAvuDSWJf9ox302lb7M8s4nRhRNMyaoJ+tdhNbqVAFx7VOS7pGVcSw6f
	MZFVNOgHybPR1vYHZt4nXyI2rsmvSYgnONgswyyDDuZJSXdnfTR3EQBIUIC+aHazTmVTzkgjSA9
	EBNXyl6BPjsvUSDSQXPp59uNmS71zd5hhWU/X03+SOUTIEt+u9vRu5RMN4fgAVO+G7Pz4xsHUEr
	wiFWPBBJr0kFkW57NSdmwz79L4zLrJILH6vo5Vt4JbD18w/kdnkaz4d6wtb470lhH8zNflbW3xL
	WJLiJtRGg4P0KvhD4O4Sg==
X-Received: by 2002:a17:90b:50cf:b0:36d:9e0b:3801 with SMTP id 98e67ed59e1d1-396d0ed78e5mr24088912a91.8.1788006652964;
        Sat, 29 Aug 2026 05:30:52 -0700 (PDT)
Received: from qiwenjie-ThinkCentre-M760t.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398b18b4074sm2596059a91.12.2026.08.29.05.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 05:30:52 -0700 (PDT)
From: Wenjie Qi <qwjhust@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baohua@kernel.org,
	axboe@kernel.dk,
	trond.myklebust@hammerspace.com,
	qiwenjie@xiaomi.com,
	qwjhust@gmail.com
Subject: [PATCH v2] mm: filemap: retain mapped dropbehind folios
Date: Sat, 29 Aug 2026 20:30:47 +0800
Message-ID: <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i8btn6t5awhxqpmg7wtado7rinybgucx
X-Rspamd-Queue-Id: 3ADEC140008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788006654-878181
X-HE-Meta: U2FsdGVkX18NiQuaW0nnD35EtFfly+A3+RUkxRFrAQmwGv3SngLu7UuUoF2wTtjatIdHRA2ZP6oSYJ+LuTy9I4noxA9IfD2mV4Fcea574NYsG1kOvCS1lUNaZyzjnFeoXSoz9fd0+dW3zNVPViqFtZfWHX7uRsO+u/7njWBVts32KpQs6IZnz+yd1eDzCmheZ/UQGkUfq/wIk1OFEQjG6AzUDTGjHtinX1PiyZisD0XOKtTkkpXke1K5JarXORTeQQ5XseGmKQklBBbDLrEFn89Y+LCFYTq1R5v2vlPcXxwiSdno0KgACTiceys2fE27tOgwdcWmJSr96z8ihVPgLMV8PMRaz1dmE0Cda8FOuDrPTFG0u8sn8efMsQT0O6LN02gHdqvA6Pc2HbZ5kIjDWSEDlXEYKpiKzk/ZqJv8g57YtmtnGS4Zl2PGU7AYTssHjjXkX+iX30fPkZV6scwPFOfXcSB+Ry6WxUPEDySd8nWmhZwY1AuV/R6X7LmHpucTZFolFrj4cEOK+iMyvyuj4jh43ksrKjtRew/O2hoWe7RXDbw0QlAZHYwzRk3L6r2w9PYBs3+k//d9zEQaDi50D6kwHfqn1/pbTNudhPCUn22pBFV1Cvp6IHXSGcfNy2qg7Nmc1TNn6FIUvRRqDO9S6qjSr9OeBIA9StrmfhjqKtTVFwPAoKfQSEdNpH836IEhbQJEN3KyTtMAwfmmvZue8stI59eRM75ofKEA4Bs/mKsGDhxFK7aScViBhIAbH9F4ayJhr6K785yLcgU4B2gVgzRhSR5lVd1hgej6Y+W3dY9cy0mrsQKksz+4AQGEq9JtqXcVYyZfCljLbSUWNYQpmnRNv297t7lgC+NHXOscejjrgpPkYHYbI0CaNkVqb1v+tWpokFbVw1i733/hoPQ0cANOUEJfvajhs5cgXXEpwVl4nLAOHvVrQjGM/hMbxFWO086IccxBcSd+I76AHAd
 Ol1rfRwP
 O03/LPg7/ArkTmSg4y0Y4++zAQN4VLjYg1wDONaiaI8bvD6F7NC8g6V9aTQMgKTAScr4cM7ge0ucFc1+nKilIRCJT1/hYCQd86IEaneDoDHpdly41oeVXIidQ+n/Ui52DO5pRvVjQuhXiMhA1n/WDGJcXvStP0OX7vB3TwR9dnmDRMOhcTwMTR3Glx65FxXTxZFawi5wTkSd4LHXO0i1bQJ72HODd8ZVt7XEbUUogZRm/oDtxp5HV9b6YqoPKtrArqKA5jzKUrcEehd5oLjYG+18gZmkdzSi6evlLlChIZ96BWuGR/M/pBrFnBsyKKPgfqhVESYMJLlZl+78ZSlx5Y0xoj6b23Ld7wnHpxZgX7rc5e7/FTspjO6Mldg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenjie Qi <qiwenjie@xiaomi.com>

Fault-around can map ready dropbehind folios without going through the
normal page-cache lookup that clears dropbehind. A mapping represents a
competing cached user, so retain the folio instead of forcibly unmapping it
when writeback completes.

Unmapped dropbehind folios continue through the existing invalidation path.

Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
---
Changes since v1:
- Retain mapped folios instead of adding a stricter context predicate.
- Remove the private helper and RCU include.

 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..00fd89cf6f55 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1616,7 +1616,7 @@ static void filemap_end_dropbehind(struct folio *folio)
 		return;
 	if (!folio_test_clear_dropbehind(folio))
 		return;
-	if (mapping)
+	if (mapping && !folio_mapped(folio))
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 
-- 
2.43.0


