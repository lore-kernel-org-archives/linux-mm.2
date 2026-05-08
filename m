Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49FE3CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 06:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B202C6B0108; Fri,  8 May 2026 02:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8276B010A; Fri,  8 May 2026 02:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34E36B010B; Fri,  8 May 2026 02:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93B606B0108
	for <linux-mm@kvack.org>; Fri,  8 May 2026 02:19:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 371D01A0759
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:38 +0000 (UTC)
X-FDA: 84743251236.30.DE00D49
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 55F9E40009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 06:19:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FWJn2qRt;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778221176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQGzo7BAtPBBp7UrgMr8aErap5KHDpu3IcptfAdP3BM=;
	b=Pqgf1FoA8U3yfJUYfEWvsk3ABUQ1FYd2iuX/mVOs1jIGTq2VSqGXYJsMCyBlYfr8z4Ei0P
	SKrkxJab22t3/4iXoassrZvO62FfLdtNr0+Zh9wkRYXT5FDN9VEb9wcVANMEDIVddVyGV6
	gF7BjQNv4waNvrVzwpTTXxsK4flW5WI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FWJn2qRt;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778221176; a=rsa-sha256;
	cv=none;
	b=nwPFoC8ou4OzyDxgGSvxX0j5+oz6GW3q0x6au4vSd+NaAIHllX4KETtso85KgJY+YQb0yS
	0gZQPfv+ztN+MsOzj9NxxRB5ifNNagez75IgbmlwOn80kaZWHN/QQkjjsezha5B3y7oFps
	DQwruQjfz4N8dF+fanI6to2+J21RlZQ=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-83975e992e1so809816b3a.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 23:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778221175; x=1778825975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQGzo7BAtPBBp7UrgMr8aErap5KHDpu3IcptfAdP3BM=;
        b=FWJn2qRtCrhYsesAZF6bFQlfSmscOdm3BDXZH3o1EugJxW3txONn9sUUQBTHvYxEuJ
         vMolt/XMJV2vf38R0Bpo9oqZDi8NQLCsaoljeogcgsznbBDRVNv1Pt/qzkJyPPXJIFDj
         s8kJp8dCTirS2G/IAGRJF2Bve5AkV2Yz1ArXWydPoBzvHaJHGFhUtDpLYhjlEIZ8zv4O
         FgQTpZiqpUXdiLD7UEslWCZWVl4jQJV562L5GwIDZS2Jk9ba1+CqG3L9cdo+dmu1qucH
         6PZYOxnSkYgi0KMcU/px6GKukEjSmcyZLul4XX0kYpixgc5mn2uGlzRhoc4Y4c7ASMhc
         fxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778221175; x=1778825975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HQGzo7BAtPBBp7UrgMr8aErap5KHDpu3IcptfAdP3BM=;
        b=qqfPu1RFLTj9V7ovGq1IN5s/PMilQ45JVVA85ewWjQC/e7NEXW6LgbnmBgSzePbs4x
         k8u71MtdHZiVdlrei/LllZW7vt84jB3PH5nw/DSPfDqRjkI9rMrEsk0Spekh8R/k5T1h
         hHT5O5uh5KohfK25r0pucyrmC/zQ9CdMqOwlxqbcHCYmuwGWf1Tnaazjd3M6M8I0ZNy4
         rPAb/gj+zisXp82mT8LxYwYy2QHzlB21PzHX9LVigN7phKeGLz9Fjcc21XEqLf90Uhpq
         ZD8bqNbeaFBPMSnRX98f4EuBC+Pa8TCg8k9Bsxv9PGbOqsY1FBrqUF+oaJCBVEfRnSZf
         mNjg==
X-Forwarded-Encrypted: i=1; AFNElJ/0NOquAw09c6gbU7WqsBZCyVqkT0pPo3ME5YEnmpc4VM5NdEKRPd9SB1Ay0OXIKkCTUdsE2cEG4g==@kvack.org
X-Gm-Message-State: AOJu0Yx1i3Oxc6a79vn4cHTubqAUn5cpKKAw/R4WA7peSEFHwN+eyxO7
	UxVLCPE8FXKQ97mNpr18dpaB7ffbusduWn3LM4+9J7stnuRiPLEJeT/m
X-Gm-Gg: AeBDieswsI7Igh/l1GM1cmz+PnqhlfayRz2PKWj360bB0i+P67hmYwwmQj5iEfD4rMm
	+GE/uercm6uEQIEI7dNx1X7YK7joiAzc5jmQBmDxJ3uGXgubwZ47c2hxGawmvSf1v5zPpm0doUL
	agO8/O5UOfR/OKaTt91QgzppLDjYPuj5SBHldNyBHHiJ8ogxOfa8XHVRg0wkWDESVLkYopBOHx9
	okv59mbCHkFej0eiDyWWdNHSRLDKxUST2HPa0HIktk129YcjWvW2+GsCAvU9116AZmkszRhAsIB
	GqXbHqs1F4vPb/WhmSqx3bKSvuQ78cAfC/Tw5fBQgS6GQom2jxSJ+KqWIx70LAvwuTSIjwqexzW
	qcgShiehBjWxWUb2sm5S51uPlqJobSNvYsVsOyg3qtOcubB5IbON5Csb2ejL+uFzO1MQ2D7FFui
	BxboZ+VP2ZJmHND+IbgW9DWY1NT6Aq78l6jlZQAB29T0WtZt5o
X-Received: by 2002:a05:6a00:2e90:b0:82f:b0:28f0 with SMTP id d2e1a72fcca58-83a5d96f560mr11390545b3a.34.1778221174987;
        Thu, 07 May 2026 23:19:34 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965a3e3ecsm11308452b3a.19.2026.05.07.23.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 23:19:34 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
X-Google-Original-From: Wenchao Hao <haowenchao@xiaomi.com>
To: Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <21cnbao@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Minchan Kim <minchan@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [RFC PATCH 3/3] mm/zsmalloc: drop class lock before freeing zspage
Date: Fri,  8 May 2026 14:19:10 +0800
Message-Id: <20260508061910.3882831-4-haowenchao@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260508061910.3882831-1-haowenchao@xiaomi.com>
References: <20260508061910.3882831-1-haowenchao@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 55F9E40009
X-Rspamd-Server: rspam06
X-Stat-Signature: mg9k8n38uaoqarn4qwa8rnsouhzxeb3z
X-HE-Tag: 1778221176-726664
X-HE-Meta: U2FsdGVkX1/P88hMdde6I8X8FoGSd1p7a7Bu7hSlpzUP6V+GSUR2tg64bcqOmnPLMU6Y8zhFjDnPcshjVgueSQ8Yld3OlcT8swtcGNhpXSmHX0De7Wj2SEyAfSp+aae9/9hR3euhQDhmW1wmK+lpbgMYvw4PmDE/Bi9ayVyTJgmkr6IuUDmBit+P04gDc98wKbDZbqaj1BbrnPOFV4o4hMlY6lPNmeLGF3PQuZvCDs3RT7YObE2/QvQqIF8kU3oTQmi7Mf8vhalYGR7AWPCjQLojRZ8toXnlmj3mGySnx/JmgYHQYFnTwvzfImu8aF64PrBccG7qbAJ6g5H1dHu+n7sjy6Klvxry8DGEaxNG3nwYhdlGK4UEnn0irGpdTawCwT2/W1WzFykOAxhm3uycxcxUJ6Cte+/iMff63LRIzcEYbE8UaRk4na5IA98RooQUWkSh5A5zYN3uaxO7AsTNkhZ1SofXYl/utf+PtkxNnNRw+L7Nmj++cp5nJB32UkA50HotoORcL1gydAZ0IrYKmSWTUgh/Tc5mSEpo1ugGrVZWgfc5T/WQobJUKrIBZh8vRUgwTi29kl61Ut4HQfH79lFtzDOimSDH01WbYEusRQJMi/VXVMoBC5VCnPMK/R59wvIm+AaIpAXGvrLnfJuNWxBRK9fHZnDmpg0nn0D6btiEWB8xP88JRzPKqgCxeu8frbgQ4IHZS/BJzMeWZmpJhgq3GrSIB3RmTGZemw0kDKgih4Cr2SoNpjKhh+hZRkkWCQkQWmDGppqcxtUOZrHp5wIo99Pbk1vRPJlRwOg3fnTzxaZXNU+2+kIFYMddfxs8AU1zByfZsviRujv9MqrCjkAaBKRmx219bWupfnoSG+zYcPy8nmjMeONcvur3iF2n5AZFTg15A997pYPmaWROG1+0NfFTBLEJnSQdIU9pJjrs0d9aoqgrx7gx9SM/ZUc5zF9Baw36B0+84dxUCFW
 wYI+O77l
 ZUctPiIh12Q7m0Zo7NyvjEswfUDx15pXmlV76DXqn02maRf4BBseLqnrKEJKgJ0Iq0T6wvr4aIhhbs2AFvj6dAQj/99hwF6ufJOsvTLjXqZX918Gq5giVKu1YcdbQt/RGOGIBgUxtMJ6+yAUljowoA06WjviZPtu3hyczxEDKR0Nu3mTBmJtwGARrSzxH3fJzJY1nGGZGFl7T0Jsb3zf37jGcqAOk1wt/Nbq/yMtzkzaHZ1y3Wc3yia4TIrHPgPfCEUdcFRxEpj8DFpbZxa8Is1AiV5D5fiehUYId+ow7x7SedV36VcNe+Iy5ApITVt2Sd4W3UIBRzgsvpuBuDaXcJ+hBNbjuUxWD9Z4w010uuAOmbHU66QaNNAdX8mDbYjy+70uNdeCnHh2dGhhJvEJ3AqrmdbPZaehi6syjxJPpScIM5WLDADkk5O7Y3dvcG96heRXN9vvACpY7iRc1eBB0Ya+t0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Currently in zs_free(), the class->lock is held until the zspage is
completely freed and the counters are updated. However, freeing pages back
to the buddy allocator requires acquiring the zone lock.

Under heavy memory pressure, zone lock contention can be severe. When this
happens, the CPU holding the class->lock will stall waiting for the zone
lock, thereby blocking all other CPUs attempting to acquire the same
class->lock.

This patch shrinks the critical section of the class->lock to reduce lock
contention. By moving the actual page freeing process outside the
class->lock, we can improve the concurrency performance of zs_free().

Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
performing zs_free() operations, the execution time is reduced by 20%.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
---
 mm/zsmalloc.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 47ec0414ce9e..4b01fb215b19 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -880,13 +880,10 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
-static void __free_zspage(struct zs_pool *pool, struct size_class *class,
-				struct zspage *zspage)
+static inline void __free_zspage_lockless(struct zs_pool *pool, struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
 
-	assert_spin_locked(&class->lock);
-
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
@@ -902,7 +899,13 @@ static void __free_zspage(struct zs_pool *pool, struct size_class *class,
 	} while (zpdesc != NULL);
 
 	cache_free_zspage(zspage);
+}
 
+static void __free_zspage(struct zs_pool *pool, struct size_class *class,
+				struct zspage *zspage)
+{
+	assert_spin_locked(&class->lock);
+	__free_zspage_lockless(pool, zspage);
 	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
@@ -1467,6 +1470,7 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	unsigned long obj;
 	struct size_class *class;
 	int fullness;
+	struct zspage *zspage_to_free = NULL;
 
 	if (IS_ERR_OR_NULL((void *)handle))
 		return;
@@ -1502,10 +1506,22 @@ void zs_free(struct zs_pool *pool, unsigned long handle)
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
-	if (fullness == ZS_INUSE_RATIO_0)
-		free_zspage(pool, class, zspage);
+	if (fullness == ZS_INUSE_RATIO_0) {
+		if (trylock_zspage(zspage)) {
+			remove_zspage(class, zspage);
+			class_stat_sub(class, ZS_OBJS_ALLOCATED,
+				class->objs_per_zspage);
+			zspage_to_free = zspage;
+		} else
+			kick_deferred_free(pool);
+	}
 
 	spin_unlock(&class->lock);
+
+	if (likely(zspage_to_free)) {
+		__free_zspage_lockless(pool, zspage_to_free);
+		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
+	}
 	cache_free_handle(handle);
 }
 EXPORT_SYMBOL_GPL(zs_free);
-- 
2.34.1


