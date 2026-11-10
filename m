Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEE860A3813
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=U5tw4vne
Received: by kanga.kvack.org (Postfix)
	id B72C86B05C0; Tue, 10 Nov 2026 00:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21586B05C2; Tue, 10 Nov 2026 00:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12EB6B05C1; Tue, 10 Nov 2026 00:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FECE6B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4F5FC07DD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:11 +0000 (UTC)
X-FDA: 85418131302.25.051E92F
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1323D20002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=U5tw4vne;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sa1P5bQLdexkX29DaU8SK96x8pyq0qViW8lSam/JRYQ=;
	b=l/0+PUroAoIJfw3IKAuOdynTu7dh/QEq11tsUBusbmSALyzj0AEbfNzBatYqchGcL5zArw
	lW+uDDTRg1fm25o+1HZwe7bYUpLhSiiYKxdZOnzT/jZgTgyTIr6EKaDg9w1ENRb11vdkLb
	UzV1qlIHCUkrje8nV7k47L86lUMFNmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289750;
	b=Z7UUdQBLjwgbrJnqAHFnigpLOyeRpj4H4f1hQTyw5sGhQtF9hNM/qySTan2LUfhpaJ3eIL
	8n4lPKgKsbAIVW//v6kN+rxJiDZh24VlCwV7nYiuCAIvxk1RY6EtCknVn6OqHs4MWpYrAK
	hPMxvaXzOvYP58rERolnYCeTPr2Jjs4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=U5tw4vne;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b4c8b51b58so1167172b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289749; x=1794894549; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sa1P5bQLdexkX29DaU8SK96x8pyq0qViW8lSam/JRYQ=;
        b=U5tw4vneHW2eJO8qoncIERc/16Lr/TeCxvJitu3kPp33vqv3pof4XzafOf44iDq/MP
         z6iJLDkL3IdvMFU4PoxE5IBQ1BtxP1Ci/cKz/tXrqjnimhuh+o06jOF/LhghA+/B5Pux
         ngp1F1t+2jJH2u+X1OsJEjIq5pbuQqLGiDUaM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289749; x=1794894549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sa1P5bQLdexkX29DaU8SK96x8pyq0qViW8lSam/JRYQ=;
        b=JBnveodgFOZ8TkMvhNnf+ccl/LQZH8wd2KTSzX7Z143fMy2RGEEkncy3V7EEAG9Rcv
         Tm4OE/WuvA/GIUibxI8OttLS2EyQHINDz7e5OdichK06PQFGPH/awFBUmM1qh+ivzBqb
         BY6CfjtzHStlbHnAwU54stqk8z7SUpj3gdv03xzA/bfqRdmBScUY9BYyRrWcYXWV+27s
         eQtC6mNQ5+EcpmiarUeNttNtBwRPcWJXEl+xsi9u9g3wqCE9YViAlr65XYFqvyBEH+by
         zBSKePmoqRaxK5GhkWxikxeAt/eGMM/lLvYVs+WWl+wDvSspO96+5p91Vz2PIXal+y2+
         oqag==
X-Forwarded-Encrypted: i=1; AL+hErFMsydzjSONqsHvbCz41sGxrDFW+zlm5u1eYcEDVv9PA2X0kwPqli/sfUvAcM1KVEykuky6y/ho5Q==@kvack.org
X-Gm-Message-State: APuU4Z+UNmZehBuQjpHRdyeB80YoEoAtYJi9pdBTe7lQUTy6dKcorIn5
	kgnddQpNCGC3OHbT6r4kGY2a/ZZJmGiQst/y4rDavn0ncQ6hVNcJyaBIBfETBvRYxw==
X-Gm-Gg: AYBFou3igLFgACL+CgkFtiOhjyQlDTBvDA6AyEAPGOYcWCOuYNUxx9uWXvl/N4CZV+A
	/z5I50aPIAgjcWWATmxUmFBM/Bc7b/V+A9WWjq5G/1fveNHztp9AKhAKD9RLuqr4iGX3LB31njo
	bSlk6AUoX1HeocLn7HxNaEUTQPM57aljU2ZXHow9PPUlZGQt0EeYWtSaddMB0HKjAoPafyu4brd
	BN9fSLZpw7DVivsEXImgOavUDyTZgWBSzpis/nI87+5yOAjQ7DtBc+X9ZvRj9w1ntZD6uQ9fh/P
	7SzLwSSWgLwmUoZ7cuPjPyGYjwdQztJb4oplnHu/OZq7nxVLtK1P43ZIbfAFgOqdPHG59tRXW4G
	dmkRfRuC5Vc1wvuppNh/cP0/jcv5Yelkn+PN/GLbyUBUtat4LPwTp+SqM1w7RjqXJtdwLiW28+f
	9QLLkiJt+f/s9h/5fZZVAF9Za5/XVuuQ+VVM7UVvxvklJyqgZqTSt1LgPMgpqeEKQN6uMQtvsiK
	f9kgln6jvPpHMtTzr/1oJe5XobFO3BacPPkLHjITRUwDtWPneUQND1S/hn9n6iTGRK0kZSbfBUo
	/6ZbfTWmoqyxt/7HDKYwd2SXpF9tWIxTWm2v99tYL3c7bl0ZtPPyaUJMbJccf3dlm+kwNE3j94R
	4H29GghvIVl/ixJfs0g==
X-Received: by 2002:a05:6a20:3c8f:b0:3e2:2d44:fc65 with SMTP id adf61e73a8af0-3f18f2aef8amr1472830637.37.1794289749035;
        Mon, 09 Nov 2026 21:49:09 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:49:08 -0800 (PST)
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
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 08/11] zsmalloc: encode 1-based obj_idx so valid obj is never 0
Date: Tue, 10 Nov 2026 14:48:13 +0900
Message-ID: <20261110054836.1515030-9-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1323D20002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: n9r7nz1niurqiztr4mm4c1n8j3fw1epi
X-Rspam-User: 
X-HE-Tag: 1794289749-65182
X-HE-Meta: U2FsdGVkX19Qru+AwnM2FHoSrPZhbcA+o79AaYxJaphlBGxIYv1MRpWisANRCcSawKT/QBGX74sEBGw4JJfXPxei/WugHogi8GzNDIEK9NPyr218liWu8zjXYPUWEnYspjyk1sd4AnETa4khVTwrG+y4QIYUY7MNNqz79RTubMGuTgSD4wn4ngNBdL/qkJlr1/QUGzvPx4L5K1B4AFYla06uaH3iDRd2mL1GK6cM903cSSvtwlJX1P0ca0lLSrqZ6U8MBaN0L9Q/HjtFTgkKCmSBmNnPFnBAHwR+sEJggjYVEaOYB3WijvJQzKGcwouY730MgvNnBETuS/JdUWUpnLO8q14p9YZuBB9IAwtPE2zojFodfMlgVnYCldlNHCZKE8639YhaJM1r+p+WH6A6JgUVYkg88OpO+gQvbL6ExO0iBj97HRtNC9KJT8otToXpBNQiVUTSboaM+o8bVMPCTyywEQ1mGX1dDLfCjyzv0/hTw9Mi0S9/s1oiSIQHoRp4mrM7bgTfhFwcu2/YiBsZxbYDkPcfRJ/L2ZTFATmbCG+Z05FAwdj968bLPT+hFHj/uT/S6hQYE9EBzXrE8bqenw3W6QL9hq5dLFFi7Gb+y3l5vHHp6AQG8GKOiZB/1qhEaGO7hXqqj6u0ilg7WFl6mzOFb5Yw5+rK2Pu5y27wnlE1sMT5/TmdPQYku9QWwzv/AFatrdEybZdke+KDNiggumjfSynlIIqCpg8dJAF5zGlGRPaCPo8h83bET+CwgJmyut9LdPHY/ed3qzCso00T1XFboUl8rUZdyhESHnXoQqCVuuZcNhOOPR0TseVEZIprYoiGipTcHDOucf6+Ri3WAab8EWQsOmTxI9DZIGvk1ziuMUd2qWUpdNnV71JO7CUkbpeNo5QqTx0Y44Oc0EMUGiFs3RYln5v2KAzswSCS1ps1ImRFqeg5OXg2Vg53/KDlafS9MLZ45kwmvvZyzUA
 Gc5bHFMv
 w0Usezypi5ucZ3bMySvb43QVCzzVxdecd5OlRsRPwMqMfyvnK/1eO2UpzbbmNTMcn+gBV1bWkXOB1/GRQ3XC0BE7gld7e5fDO7xYrFsKXUvnOlFaHIQ/8HZYDUpcFKZ8uf9Kp+7p++W+k3eU4h6RIAbQlKCCaFuVc1xf3Uk5ACYfzo7mONI3gyhPyXM+l9R6WhKyZJwAZxfhimesSQsH0IoRWbT/eaV9sk70KudNAR+ol0iOZo70x5JMuL4juEypp/EY4uTLv/DW1zfHaK1nmqRBBoTFPQ1RvSPuG35Nd4nr4RyLOhb3kRmiGop80kXNp9lNDEFT9qfcN5s58YuVeBbFyOzoU/sbRHGlnt9EAxABD+1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The next patch embeds struct zs_handle into zram and zswap entries,
and a handle is considered allocated when its obj is not 0.  But obj
can be 0: object 0 of a zspage whose first page is PFN 0 encodes to
0, and some platforms do give PFN 0 to the page allocator.

Store obj_idx + 1 in obj, so that a valid obj is never 0, and adjust
ZS_MIN_ALLOC_SIZE so that the largest index still fits.  Unlike a
separate tag bit, this doesn't take any bits from obj.  zsmalloc did
the same before handles moved to handle_cachep, see
commit 67296874eb1c ("staging: zsmalloc: Ensure handle is never 0 on
success").

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 3a6a7253fd01..aa436df0cc4d 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -61,7 +61,8 @@
  * Object location (<PFN>, <obj_idx>) is encoded as
  * a single (unsigned long) handle value.
  *
- * Note that object index <obj_idx> starts from 0.
+ * Note that object index <obj_idx> starts from 0, and is encoded as
+ * <obj_idx> + 1 so that a valid encoded obj value is never 0.
  *
  * This is made more complicated by various memory models and PAE.
  */
@@ -169,9 +170,6 @@
 static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
 	      "zsmalloc: ZS_MIN_ALLOC_SIZE would exceed ZS_MAX_ALLOC_SIZE");
 
-/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
-#define ZS_MIN_ALLOC_SIZE \
-	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
 /* each chunk includes extra space to keep handle */
 #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
 
@@ -189,6 +187,11 @@ static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
+#define _ZS_MIN_ALLOC_RAW \
+	DIV_ROUND_UP(ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT, ZS_OBJ_IDX_MASK)
+#define ZS_MIN_ALLOC_SIZE \
+	MIN(ZS_MAX_ALLOC_SIZE, \
+	    MAX(32UL, ALIGN(_ZS_MIN_ALLOC_RAW, ZS_SIZE_CLASS_DELTA)))
 #define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE, \
 				      ZS_SIZE_CLASS_DELTA) + 1)
 
@@ -794,8 +797,10 @@ static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
 static void obj_to_location(unsigned long obj, struct zpdesc **zpdesc,
 				unsigned int *obj_idx)
 {
+	VM_WARN_ON_ONCE(!(obj & ZS_OBJ_IDX_MASK));
+
 	*zpdesc = pfn_zpdesc(obj >> ZS_OBJ_PFN_SHIFT);
-	*obj_idx = (obj & ZS_OBJ_IDX_MASK);
+	*obj_idx = (obj & ZS_OBJ_IDX_MASK) - 1;
 }
 
 static void obj_to_zpdesc(unsigned long obj, struct zpdesc **zpdesc)
@@ -814,9 +819,11 @@ static unsigned long location_to_obj(struct zpdesc *zpdesc, unsigned int obj_idx
 {
 	unsigned long obj;
 
+	VM_WARN_ON_ONCE(obj_idx + 1 > ZS_OBJ_IDX_MASK);
+
 	obj  = zpdesc_pfn(zpdesc) << ZS_OBJ_PFN_SHIFT;
 	obj |= (unsigned long)(class_idx & ZS_OBJ_CLASS_MASK) << ZS_OBJ_IDX_BITS;
-	obj |= obj_idx & ZS_OBJ_IDX_MASK;
+	obj |= (obj_idx + 1) & ZS_OBJ_IDX_MASK;
 
 	return obj;
 }
-- 
2.56.0.506.g506a7eabc5-goog


