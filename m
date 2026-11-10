Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A810F60A3803
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=D1t0uthG
Received: by kanga.kvack.org (Postfix)
	id 35AAA6B05B7; Tue, 10 Nov 2026 00:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332306B05B8; Tue, 10 Nov 2026 00:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248016B05B9; Tue, 10 Nov 2026 00:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA2126B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:48:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F1CF1A062B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:57 +0000 (UTC)
X-FDA: 85418130714.12.DF9D810
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id A9A4540005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D1t0uthG;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztVA0sUV+JwbT6qi0K19Xf4qSH79z5sTbBuAxuXF9DM=;
	b=YeUm0vvR8RbC43i4Rr5uZUiir6OOvmTSjz5+OzyTAEmpuDYgL0+7ujjQxsWnaCZe9sT+Mk
	5eFiMrTiFTNHfTN/r8CmkrfKBb6j9WiW9bWyk2M8QEsWIRTuEhdCa/qp3gs00tQT1xnmab
	w+p/s4RNhA52JzW4KT7snIh9VxhQoSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289735;
	b=2JGmFLqjV8Pi/ediz2Zf6iKJXkwbSJvSBwNFhXyB+XSjVjza0hMaTbOgKAsGt1mN35X1MZ
	FmS4a6B0BlaP61Y1ZIP3K75WvZS8aYkp3ia6LEADnkkWYFTyZFa8uezcrp5zMxLgGH4pSI
	SceYYlWAlEAxEWBYBzPz9lBNsYuea5Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D1t0uthG;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so745108a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289734; x=1794894534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ztVA0sUV+JwbT6qi0K19Xf4qSH79z5sTbBuAxuXF9DM=;
        b=D1t0uthGSsAop6y3wKrjsIUJtJXVtRjsXTZvMKze6SXDr3306jp2Dnl2hAuJRldd01
         5moN4j//eQGMQ462FkKItCInrQMFoHLM9sOQY4kD+Rb8tujBcxqJk8o3NZwGDDTYW4CH
         fKn4L6vduCFeHhIJ2bmw7k0Q10FhNU7zc5Xeg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289734; x=1794894534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ztVA0sUV+JwbT6qi0K19Xf4qSH79z5sTbBuAxuXF9DM=;
        b=v/LqxBwqRTNA2nbp3HqbIQk1w+qXIRf1Ga8GIZN9Y3sB0A2NxK8k7qsQCDULtpxOcY
         QHXk5yHnDXv4F4LWmauIu6vc5UHKh+wYH3H1PQ9kZ5FAkxoc4zDZqVg8tRRUTcbNy/Oa
         5FtdmSib+L+AqlsdGJtrrvydMqzYrwbQw2R6zidrIFeQDRV+D6p9qWKSFOPji6yfB25Z
         wT4os+IqU+9wZhUyVCCuxOfI+xg2+gMjFvd+kzI0WhP4xB865V3Y/LOVe5U413kpLxvP
         vtZwbGrOU0AkbTaZHvVmUKrp55J1O704iqLTMJ6QqZpbousSK4p6cnFyUjckL/m/owzF
         n29g==
X-Forwarded-Encrypted: i=1; AL+hErHUejJrv5DNH8ICggUk8Hp5/18HKIF8kB0Xg83mWTHtJTh/ZhbV0oGwbmnndOtRPaTn5bePNRoYsw==@kvack.org
X-Gm-Message-State: APuU4Z8ldzzP6/mH+xZYfsJnBQd01luv3bHbUORtpmFvpNtMj1bF2zuH
	KHNIUtFZrHY3eFuU/TOcugp4VkQp/ZFkZCnwkzD4wSJp8bs9mPH52g4xEJZcneWPSQ==
X-Gm-Gg: AYBFou0CfJJcl/2Ss/kWoEBs2U3lLW0+jFxqaEIvw80eepFQ3C7hd2sr5+OCJ5EA/ye
	4sdZksu0zgEtl/Nx5LEjrneAdRJR5tiwcu2sHPviGSsXhD18t3qMVoh4h8MA1v5T6265hg5gyEj
	F9lsj0B1Sc0wNjvwe/hfIXDeC4eRCaq7npuNfS6AkIOYPs4zGuNB+2MymKANKeMXEalxQLV9P+n
	28yjiSE4qRANIszyw7Z8ivHTxwH6gxikIPruBL4n6b3tk8UtuDSIZZFfXbhfNtikCFTFh5GbZA7
	mqNcbIx4ryCtE5+mB5SqZmLxCkh0306oo/nHaGEa21c/M9INmNQpcbd5ScUswjUka9Z1OC1Tvd7
	2h6VWbtqcJ6qEfGrpPAsBY/xZ1PbSZvMIOqY5zMA2nwK4cCcwnUtWQppHmfPoWyz1DJqw7G5oHp
	By58VaJbVLSMA9xPnpxb9U3P5WoRWaRbjZ41aEjTt+5JCwkbhjoNpZnYZjz4t5cMPGqSkIKs7yT
	/ceYtqVF8/jFsPXPraMza9id9Zdrpv7QhNFQ7ofxEJ5GQ1Z7t1J2w4wzbBlJd8lHmCaU2H7vtjc
	Cb+XE6E0ZEzhzTBCqE5Ys9MK8DgWsMq6gWm2Kxwll49R0pIKZQf7f7uqQiTizgdxxETPf44Q16J
	zO0qxtp+vAtGM6cKfUg==
X-Received: by 2002:a17:90b:4a47:b0:3ac:17c:6e89 with SMTP id 98e67ed59e1d1-3b166cd4924mr1684341a91.19.1794289734505;
        Mon, 09 Nov 2026 21:48:54 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:48:54 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 03/11] zsmalloc: return handle from obj_allocated()
Date: Tue, 10 Nov 2026 14:48:08 +0900
Message-ID: <20261110054836.1515030-4-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9A4540005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 385y76akad3mczcuagpz7mmca1x9c6f7
X-Rspam-User: 
X-HE-Tag: 1794289735-424445
X-HE-Meta: U2FsdGVkX197AsCAH9ZESqSqxEtDSH9+uih7AmwltnV5iOYuJttITZArR7Bf2wJX40MUcUmM0qb2dCHs8BwiC/0cg4ltQ0ozE0PbdAFVaqIfa93HgJDfhclK/jAIwFIMAxG26cqHhn3WV86MnOV4IVho7pbCrcwW5muflYj8pt07PeOqu7gyrECnmaQVVNJieZ609d32Be6GICQPXZ7+HbLN08CJJT5ki/iWzzfQDhjEoMY3RG66HobyEjOIXeGbIMAC8xdug7sQ8D2sWzDsC1rQjSls2VefIbtZr/rHDDdB+feWYRw8XwBuL1IYNbMJ1JmLJy8AFMoTURlI8x1R30XdSZ4Bu/rP4U/OeKgqVcc+eI3NERO76cMuEauT2fx/9x5St2zW3vL09cN25dy5yh4WFc9E6IRhfgHrh8ZsIpzedtyaKX2Vtw61t6OT5mOVPnZc02+CaQ4pCkiWUw5D8d5+81omFFM0xjchEwP30kr31HTraLjpHl+OeWFmQEcOVDnIq1RT89uRBk6cgU7zH9CZexlpohbUpi8E2GReuw3QJtZA9IAZxTz65KknypJavIeSSxdaGRrRJSj9QY7wSWmPlGlg9Gfaw2K8gATztxsRRMVP4s78H0sKIXJ9zjnbtkmMW8WxRCoUeqUG/0J188xlIfVRVVTMvImAMyfpAoI+0H08oj0hDJ8AorJfxrWnwMNvnd93BPmYUH86uq9oOzmTImiNF3Kcf38Ua6pS5pio77ARgsysuQXhGdJQFaTa9h4igiTnf+LLf+vOflnLXJ0h/0Jc+uxkfm9cis9UZVmEeZaJPs4Q71qj65BE387STKep/ckvI/G41MpldTkyj6XuLzTAYSPgORRQibhsX3g2boaWZ9G4CBTWe1qTkCT+WPdEoTZFPCtxjDc4guGG3e6vbi4a+QaFZhGg+BW+ebXIutgn6k+zKg/3I/KXEexILYYzvPYRvAhAGMGmlKx
 0NnKlihS
 M5Fyw14XfRRtXBx26bEnfU06DS/ERNwKBL3ohL8RR3YLTNq2O4KLaMs7MENU1Yt3CdGLUeU3JKS6+XqyWj8xeg0WSDdBGB6m/KzzJ1TccWb3XAcJcSGJ5hMTcVR6y7tOUVAvxVLypnUXKVM8Mo3RZnuj8S1Qk0ZYmU9BK23UbKcmoiHxDu5DEUdUMgdAo0X8w9UVbdKTLhuSlVTikAI9jGtq7dBMRLAQciRsT8tz1SV3mUs5cAJEkZ/J91IHNOAiZcfDLvnDHoQOeJ8WEPnVxeeepXRWnMUYTWh0vfUkqrsPFcABba8QbKhVWgQIS2IsNyfQoGOdLbCJa7yzDwLqqkVzts1ltcZTxgqplrdwUQc7pTHspdDC1tquWA7HZ7eBOFXtH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allocated handles are valid kernel addresses and never 0, so let
obj_allocated() return the handle directly (or 0 if unallocated)
instead of returning a bool.

No functional change.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 7ef80e0da626..dab71f582103 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -822,8 +822,7 @@ static unsigned long handle_to_obj(unsigned long handle)
 	return READ_ONCE(*(unsigned long *)handle);
 }
 
-static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
-				 unsigned long *phandle)
+static inline unsigned long obj_allocated(struct zpdesc *zpdesc, void *obj)
 {
 	unsigned long handle;
 	struct zspage *zspage = get_zspage(zpdesc);
@@ -836,11 +835,10 @@ static inline bool obj_allocated(struct zpdesc *zpdesc, void *obj,
 		handle = *(unsigned long *)obj;
 
 	if (!(handle & OBJ_ALLOCATED_TAG))
-		return false;
+		return 0;
 
 	/* Clear all tags before returning the handle */
-	*phandle = handle & ~OBJ_TAG_MASK;
-	return true;
+	return handle & ~OBJ_TAG_MASK;
 }
 
 static void reset_zpdesc(struct zpdesc *zpdesc)
@@ -1571,7 +1569,8 @@ static unsigned long find_alloced_obj(struct size_class *class,
 	offset += class->size * index;
 
 	while (offset < PAGE_SIZE) {
-		if (obj_allocated(zpdesc, addr + offset, &handle))
+		handle = obj_allocated(zpdesc, addr + offset);
+		if (handle)
 			break;
 
 		offset += class->size;
@@ -1824,8 +1823,8 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;
 					addr += class->size) {
-		if (obj_allocated(zpdesc, addr, &handle)) {
-
+		handle = obj_allocated(zpdesc, addr);
+		if (handle) {
 			old_obj = handle_to_obj(handle);
 			obj_to_location(old_obj, &dummy, &obj_idx);
 			new_obj = location_to_obj(newzpdesc, obj_idx,
-- 
2.56.0.506.g506a7eabc5-goog


