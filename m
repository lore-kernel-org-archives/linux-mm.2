Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DAF6D29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED1B6B01FE; Mon, 19 Jan 2026 09:46:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284186B0200; Mon, 19 Jan 2026 09:46:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186A76B0201; Mon, 19 Jan 2026 09:46:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 065766B01FE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:46:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A09F1137FF9
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:46:07 +0000 (UTC)
X-FDA: 84348988374.30.7228AB6
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD1CA1A0009
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:46:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FwLhzSyK;
	spf=pass (imf19.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768833965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fsjvsl9QLRbiT7Kn7hO3fVpNzPEyahcgYF/8T1qgI5c=;
	b=fBTJdXGPuI5qyRkfVwprTp9nINH25Wi6qLmpg/Dq1GcEONNqh2C1TOqu3jtJ2CQkPkEHIU
	401+7dDmRpktY7d2EEy+a+UGUTJXFZzffcQjcuHiPeVz6zjpb8Ld6bSv9Rq3f0Bd1K5b3e
	vDwLN01ohJgIegqU7HGwBALJBIYMfQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768833965; a=rsa-sha256;
	cv=none;
	b=Qu0yOuNsmrv7VpOFRrCMCWO8FggRgwqjky16GqDD0x8LR9CY2wx9MWdalrDlPn3573u33B
	71QRcH+Td1SD4HdHy41AocHe4nZbySHiAMq3sL1LskNHN6uNRDV7j0LL/w8wXD5tIGCvAu
	G56qe8Hgsn5zItA5Pk2IQwBKoRzEN8U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FwLhzSyK;
	spf=pass (imf19.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59b9fee27ccso454716e87.2
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768833964; x=1769438764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fsjvsl9QLRbiT7Kn7hO3fVpNzPEyahcgYF/8T1qgI5c=;
        b=FwLhzSyKAI6HgW8ej6/EgKgcxnm/dV1DepFtxQBNSNBGVj/lAUv9irltsDtYh88bhq
         C7yzzsJfGTFfubJJ75d++RSVEMUSMMwmuvFSs6J94iFM2Jg1r5Lnf9NirMHhJh4jyDvC
         J9Jlg1U19w5slUaR+7BgnuOvE+hZSY0up/CnPqsW+xLkAQaQfYzeLz/spuScdFhmeWT0
         8zf6F5j0dAyb1KcNDSRV+F0BeAlRQ7dT0Wvnt8kWNhj5NQkzqucYT6SZwrP35L9O4iw6
         zxw0n7hWG1r1EsTAyfKMF7Dks7Ilei5tz+AjhO21DcMiLubWnYoallvBCb4ZovZFGCrn
         EGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768833964; x=1769438764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fsjvsl9QLRbiT7Kn7hO3fVpNzPEyahcgYF/8T1qgI5c=;
        b=Du+Epiznc8tzV40WDYHj6Si/yA2ikz00bVfdPdMy72sKgNKp9rpK38L4FirL165eGm
         9Qq30qcVmpih0I7Z/EUUUu8ecdn9PmJ/KdiRt7ng9XtIp4ajgQKlXbxdGj70SMxjfc7T
         GJ6OPbMt5TTKz85Y94ezPaKeqL0II3sFmDIl17f01B73g2OnkECl8pPn8/uql6WVIy83
         CoBMAyby+3DJqw+SP8q+M90kceYsxLIrgEIP12TVNQY2UpVOtxi9i9j0EeQcYZQBedDw
         Ylh8ILeRrZWXtJ8LI1awU2zAUhtcZQhfvn9FHqANl0MKDE/S0uEjMHkU6yQlpAU0iibY
         ZGEg==
X-Forwarded-Encrypted: i=1; AJvYcCU+Ww9CK5ZYnGz3rIDW/T4Fd4JbX0W7uQwSUoUxYOAlqQQby87wAIynWrUEJTsb0WIe+viuOFaVpw==@kvack.org
X-Gm-Message-State: AOJu0YzhkUrvJ1DlgcuoQLtp8XYo8DdiZqZi3Iyhr74uhjOvG+9ks3kc
	4JanK4rHnFzu8CPoVJWqPGWO7P7E4XGKzh5LiHe14lWvxy9RCZzO5ypk
X-Gm-Gg: AY/fxX7YnG7fI9rwpAAfr/+xPLFrg41BTH/hrUjnE2TEddljqbN/TpgoG/xX+92H1gs
	OyFqQ8DrtrSOKbSaNcVgfbTYlTe4qkMzE8bYiThhpm834P0xxcjsGlHeev5jMzgGeDzppzyT+0E
	jMau+t5bNNEzHIXfv7aC9NvTWZuLzKFnASr1D0cR+iBwW/HGTSFxb6lkvha1Tj3Wj2mntQlwTSA
	SkmPGgC7T6SN37GOv87mJ1D1ZJS72AL9n6bH6GOq5gdAxBDVgemT8mG8rzWrMu5B7OlGeRymgv1
	gxeV/rVUJah//I+ZKPWbmCpFPNZ35nWImSIld5Ly+7p5kD1eH0sOLKJ5wJqWnhTck0aO/1rWElh
	86GVMuZ0TmJV4gJn9VlPA7F2+jfScUFad7fDZdSTomhVWp+Cl5th2W0Uhjem0enJE7qCFJDGuk8
	292AD8mNbLXoDdrSsMjmNRvGM=
X-Received: by 2002:ac2:568c:0:b0:59d:a4ed:2309 with SMTP id 2adb3069b0e04-59da4ed238fmr294405e87.1.1768833963843;
        Mon, 19 Jan 2026 06:46:03 -0800 (PST)
Received: from dellarbn.yandex.net ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf33ed36sm3408385e87.18.2026.01.19.06.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 06:46:03 -0800 (PST)
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	Uladzislau Rezki <urezki@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: [PATCH] mm-kasan-fix-kasan-poisoning-in-vrealloc-fix
Date: Mon, 19 Jan 2026 15:45:09 +0100
Message-ID: <20260119144509.32767-1-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
References: <CA+fCnZcFcpbME+a34L49pk2Z-WLbT_L25bSzZFixUiNFevJXzA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD1CA1A0009
X-Rspam-User: 
X-Stat-Signature: wy1qssao1pn6ar54kozeh7mx5qfdetuz
X-HE-Tag: 1768833965-262775
X-HE-Meta: U2FsdGVkX19ev4DAD5oHrYrwYHU+t4npZC9xTW9vAcPOqtca9V2f2gUoS3RHaUyBEtcLz5FyNFGBHguMKGKJtIWxvwGBV+qsez1cOm7upHknwCqyk6HnZE3CAv2HMlcb3C3BqH4rpEdThwd8PeR/81W9spfNm0Usqe7F2jayKvKJFOKGoot8O5wj8C2mNrv6DgpZDkRyGuqiVv95UKFtlchXvyF2mBc6MYSsQIUxkJShA0pGbGCfrgM06qQEXjpeJ07JM5mJqB60nafN3j3sbeSYJiR+poOd+ycn22Hio908Qk+ikmZTwHxTT0ebQO48x1eyqAL4YpttXc6CLcXRY8xTuxdBtQb3TSFfpyiJC5jXoDrkJiDAiDg5L/DmQSjd6pVGclpNys0If54TsB1dW/O6+OALNWw2LWdJ/jLXH/j+AT2CK9FUZz0hr0VfLzzzaKTQjUAhvACJ/EJ3KWfdjS2o7qnu6GSWl63h7umOhCl2OhveVYl3v3fwTd+GP1f656llRdY3Oowt7XhPb5BvqZFi5VZOyuyCfPO0pB5cAHAL00b/6BMS0/pAs+jcEK/aS/hbfBaPRVsjyqu/CVyGvNZahjSCvXBFIxZAfQPb8Z2HL1VC4WsXa/dN5q3QoLYb6JzYYBMcOEEklbIN0T0bFR7UWtrBo0/Lb0q+ujTM4xczvRxYkpENDTudfkw5r4vLHjKldkDwfbnr2AXdA72cfnkt3DnJvXwK66ql43OTkCe1D9Pc8UNC1mz4CCcQCnLXkfNiZHDWO4Q5bB2ioDj254JECe/K57K9PWwha6ElLPKMmTGPwDYIv8Ztp//0hd8pz06n5SFUDapfbMe4AaYfPSfxCIPNolivOYaCLqruUTIKa5GVgfqp22VccT2h6J3tR8udICkyYJviqs9vWRx1WsKbC7QtF/TvLErAsL96qTD3sCkUES9XVn8UV9872JG+e3Ug7JZEDplYzPo86Ox
 IJ6A3v3a
 wuqw2ABS2WG0UQpqeQudsmIDijYynXrOH5CNprnBBcKgAs2qYKVTobdwjx8WJ96ceygYdc3IBvrxpw/mncIbQmbF3T5V2ZR0ggu4G/6NeqyCq/I91CRGzA3eEmMkFLGdp1dPUH1jSAG0C4hl2XudRTIWZy3k6L6+pjHnA2p+Zq85oB2unHCojQYxEz82rLJ+5zONX8A1GikZRBMQrtHAM4iti8m9Lz7phHHDifEx3ZWcnKRUsxJ4tAhWN65i1Zksf6Ek8z3/zu/8fH0UcvPP4AS8o3iHl0r7T05XOiK1U345LucIIpZKKnI0/+BN3aeVj6Q4prS9j1JNB8847183RvrwXV3AjeQQoaVOwIGqFOxfL60xmeTY7nXfohHvGSlN57OfPZYlMwtF6n5y+S0P1y7iFLcPTzNd4Pyw97jzVaMDahKscPDtRHYbdpjlbkXHaBRauNCSUHUF9JGI05eaulhuK+oxy9unS/B5896ru6py+7dy5dbLDL94QsdYVmxSSs0AayyKb6CztMgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move kasan_enabled() check to header function to avoid function call
if kasan disabled via boot cmdline.

Move __kasan_vrealloc() to common.c to fix CONFIG_KASAN_HW_TAGS=y

Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 include/linux/kasan.h | 10 +++++++++-
 mm/kasan/common.c     | 21 +++++++++++++++++++++
 mm/kasan/shadow.c     | 24 ------------------------
 3 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index ff27712dd3c8..338a1921a50a 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -641,9 +641,17 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
 		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
 }
 
-void kasan_vrealloc(const void *start, unsigned long old_size,
+void __kasan_vrealloc(const void *start, unsigned long old_size,
 		unsigned long new_size);
 
+static __always_inline void kasan_vrealloc(const void *start,
+					unsigned long old_size,
+					unsigned long new_size)
+{
+	if (kasan_enabled())
+		__kasan_vrealloc(start, old_size, new_size);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index ed489a14dddf..b7d05c2a6d93 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -606,4 +606,25 @@ void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
 			__kasan_unpoison_vmalloc(addr, size, flags | KASAN_VMALLOC_KEEP_TAG);
 	}
 }
+
+void __kasan_vrealloc(const void *addr, unsigned long old_size,
+		unsigned long new_size)
+{
+	if (new_size < old_size) {
+		kasan_poison_last_granule(addr, new_size);
+
+		new_size = round_up(new_size, KASAN_GRANULE_SIZE);
+		old_size = round_up(old_size, KASAN_GRANULE_SIZE);
+		if (new_size < old_size)
+			__kasan_poison_vmalloc(addr + new_size,
+					old_size - new_size);
+	} else if (new_size > old_size) {
+		old_size = round_down(old_size, KASAN_GRANULE_SIZE);
+		__kasan_unpoison_vmalloc(addr + old_size,
+					new_size - old_size,
+					KASAN_VMALLOC_PROT_NORMAL |
+					KASAN_VMALLOC_VM_ALLOC |
+					KASAN_VMALLOC_KEEP_TAG);
+	}
+}
 #endif
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index e9b6b2d8e651..32fbdf759ea2 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -651,30 +651,6 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
 	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
-void kasan_vrealloc(const void *addr, unsigned long old_size,
-		unsigned long new_size)
-{
-	if (!kasan_enabled())
-		return;
-
-	if (new_size < old_size) {
-		kasan_poison_last_granule(addr, new_size);
-
-		new_size = round_up(new_size, KASAN_GRANULE_SIZE);
-		old_size = round_up(old_size, KASAN_GRANULE_SIZE);
-		if (new_size < old_size)
-			__kasan_poison_vmalloc(addr + new_size,
-					old_size - new_size);
-	} else if (new_size > old_size) {
-		old_size = round_down(old_size, KASAN_GRANULE_SIZE);
-		__kasan_unpoison_vmalloc(addr + old_size,
-					new_size - old_size,
-					KASAN_VMALLOC_PROT_NORMAL |
-					KASAN_VMALLOC_VM_ALLOC |
-					KASAN_VMALLOC_KEEP_TAG);
-	}
-}
-
 #else /* CONFIG_KASAN_VMALLOC */
 
 int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
-- 
2.52.0


