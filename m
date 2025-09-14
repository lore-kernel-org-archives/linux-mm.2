Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04EBCCAC58E
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 00:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87C16B0008; Sat, 13 Sep 2025 20:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B392E6B000C; Sat, 13 Sep 2025 20:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27366B000D; Sat, 13 Sep 2025 20:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3DA6B0008
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 20:00:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6868139E5C
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 00:00:33 +0000 (UTC)
X-FDA: 83885899146.14.40B2CDD
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 280B040016
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 00:00:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TeE+HJ8R;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757808032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=63ySVId7BonBh9xxB4ni0FSrcrwBdFhhccJRJyFNI/E=;
	b=vD4gthmouAuxaQ/96JY9yOt2mtty/uMV6I+80iTmxOexih3qN6ZBnIOvXwQhCX3qAzTdSl
	/qHk6pj5YDzcvPwRt9d2gB1x/e9RhzOW7mRDx2M0Ebt+P9d5vwXlkBbntSM6e++PYmFqmp
	vDFgvaE7miSWwr+gFocv7cVEFhUSgh0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757808032; a=rsa-sha256;
	cv=none;
	b=EDvZdyPbnbw3axKU/GwXm3ACw59YD30oQGKxG4swR6Bwb1SwOelyQ30Ujo39RF62tppR00
	F3SV4yJ6XK0dsKhaW+JCR5FppXH2Z4GphqjbqdoKf8az4rxllRbmmMq2GVemZLukbAkc9z
	gO2VAyaIF9wq3KxoBPZPzanNGY4Z1Z4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TeE+HJ8R;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-62105d21297so6104534a12.0
        for <linux-mm@kvack.org>; Sat, 13 Sep 2025 17:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757808030; x=1758412830; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=63ySVId7BonBh9xxB4ni0FSrcrwBdFhhccJRJyFNI/E=;
        b=TeE+HJ8R+2jhFUvADXKJJDGYdkJbtc1Im3yWaiGW6zLKQ/F1+Zq5TxQ6mN2FSuOfkQ
         5KwW04HRlfGaX2889dCiigyXGIyiwdFt28g5t3jOB/g0mu00MKtwsB7Il5XJQbCoLZbF
         NSmru32T6i7jnSgPHaYBbsbq9erwlSFdzRe4sbw8iAKYx05yWP5/8t+M9aI6d5jVG3R3
         VgFDMzUi3mp7C5ruEJcajtBLRtor4VMI2RJV/DesIAwHGt7VeESVpp96txQAHvAjjVg0
         JdTev+56t6rua6vaDr4l5AeJ9nnLdJgcPdmsDaXNsOWckOtsnUI0UTY125xRrtIniGfq
         4HHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757808030; x=1758412830;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=63ySVId7BonBh9xxB4ni0FSrcrwBdFhhccJRJyFNI/E=;
        b=HQmdB0xPCQPJ7mI2u1vf8iDy1mzGsaytUnGb+23labwtRWn7JPppWC8U7BGvjFGzhV
         8geI8c885U77u3IpoglLtknc8dQ+awXswmzpeItO5ApqriedD+8TN8x1lygwmaQl2wAZ
         TzuxOY6IxQ90SdtJl1pneH8mLiTzbrAzJqszwnMSI0uECz0dH+fdfhgKpyifjvaZMwUQ
         QEaTSTSrv/91RlYwgKf6cnYUqb+MKJUvOjbTTzq2v/n9lnC1FZ1OkremsipNC147kUhg
         U9fLYtU41QtT5kcrTUVOD6NS5aICisMOei/pNC5AZGIRzwBEUinLiFA06GAWSqL8uRTb
         d/tA==
X-Gm-Message-State: AOJu0YwzgTk0guJTubccDzRCRaYNqd+/9zFaycsExsKuMaPy3LfULcVV
	q+himnjnRmxGAvtGWmo+q22aoNU9HV5/MW8/ELsWXw9/W3a81nNRzqIG
X-Gm-Gg: ASbGncv4NrQofKATgH4Ae5dHpjuuWx5+VXnk9mgSbj8Qr/I/AfLJgJwDlK2uUNaORDD
	q8fsJ75z4uUvNCit26XTz3o1LZGnoF7QyQwFRTAliJsitwYsnorWhXPO5y7yfWWBgmAtxE/cT3u
	4cnExxelceJpNmryrVEgMNe3yhYKFV53gmavl2MnfUu09fxPos4MqEwfkGNcauXRQysXmeqMJ7c
	W942FX++7jMu4ZFw9EdpoVh8J8lbofyGlihc64XC8Zh+eplXl4lsToI2q38CTmbYpkvhzaDZasR
	UR8ovuhorq5j738pewprRVIAgjht1q8PTUcT2idHAKbf4dyAmey7lmVTO+LM1Qs+/IELn950idT
	QDDheQVY98C9eQPXqp3W/qQ==
X-Google-Smtp-Source: AGHT+IGGs1r3yDxIGwV1qt7ugzfNg3uJuZfqgnxhVKGEoePYG7QROkDikUFw33fbDg7dVfh4sJmzyg==
X-Received: by 2002:a05:6402:5290:b0:628:f26d:f4dc with SMTP id 4fb4d7f45d1cf-62ed8304225mr6769075a12.24.1757808030266;
        Sat, 13 Sep 2025 17:00:30 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec33a51fdsm6112400a12.7.2025.09.13.17.00.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 13 Sep 2025 17:00:29 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/mm_slot: make sure slot is the first element of its wrapper structure
Date: Sun, 14 Sep 2025 00:00:26 +0000
Message-Id: <20250914000026.17986-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 280B040016
X-Stat-Signature: jz7hmiei676gdhc6fxyyoh5zw1i7ood1
X-Rspam-User: 
X-HE-Tag: 1757808031-948953
X-HE-Meta: U2FsdGVkX1/Jb7WWx63LvZH9Cqp03WU/Ijw8Um/Yfw/t0k4Yyv9eMh8+SbIMui/MteYFLJ8jI/544ivwpIYo7/DVCjtuJQnwUFPTTNJmtwKyOmyQntJTaB/vrc6lqOhU/WNjy0tA+ZUUss++Kf+imJH/zM+nZkUjN+Fq10QtFe4h5vsw5b1iNBHBjsYudthYH8gd4G2EFrhvQh9cdmdkWHB4lJMvDiIwY5VNzBaMdMwLpoT1+lGpPqd6pchLa/GqM+QZO/SBld5h5zN1D0wFxz6j1reo47u2Flq0GAnTI9NKYlJ9rCZJb1mtpn2k9WNGkCrOtDUT2dSqDei9kef7TMFHZ/jxg0q6/2ycgAey9tCNTPEh+gbufj1RoUvkbpfY0n2hycNG33ulazmSdJ4km29DT7dAhyWyQS/DjFv5KsdqZav/QT7ezPGnqQwvqdLt2KVfEdGktF8ai+l2PFc/z6A66CkSf2lUta9uRoVTRxt0gxIR0AGAekJZJp7pnbznrp47BT5C/RTlfzRbGhkthXlAflSmiyxNRlIccT4ZJm+3AfMty4Su9zE8YJfl2tmGKwG4dzzrv5WgaJEMo9aSGXfcVqbV1OKmzJ7L1vO05Z0BTpIoi0J9HRDe1/XgWTP6aAbcKDDXV45pojiviV8BHWEtavdyNYydxi+tJoSOC9GxaQpHOIuf9bjaYrm/MVLVba6UQHqxSlQaResIghfSvzhnaOVm+IaFatS7Ss4rkI1G/9wvM0NegkButNfvzaNASbnchaegGC8QuF5QcyqPRpHxzkygylsrZvRbTduCfFC198l17rRIpFg1du1Yahmd4CR7gAyD4Cy5v+rpqvxS9GzaVoEotOE9/kdJ2a0WF2sAa3qDbkR8uE+lYZYqvBrPSAtOCTXNG8UuLPb9GDR7BUfGm8+KLZWFz/pL9T34M4N7LxC7DUiwEvcjhwqqERV3S5BBBBOqwrEInAc2DVt
 Wr3pPe8d
 EqVBQDuzD9q/Uf9lAwuG2VfRk5k/aGRJVU2jSSOPxuumiJOYDV6CXOJeXzcXNmdOl6NPPbFFGBa10UriCk2mBGjsvs/o29wPunuWMNMczss7+dDf8b2nWiprgVMXSNtfCcF3MXEN0c2bSh/nWYyEFiWlKx3Agg8KOxuOTaMqak8DMp6tRKvgZ6LoM4n3BCjOXUDbbOvdfj12ViHO7tGec900ZX+nny1AQL+8HcC1i++DlZPFdQRKqaFKD+BGKB0k6+wNxJr8v6h8V2BOXl68RprwZwCp9JmP14rumbs9S5/zDXuL9ZBBGSVqO20wA5mlx0N1KUEf2JAnTMiwnhsO4k+JMGKmkRlxfGFaxlUzXpM+k6pLA6UOCkMTeWvNHTNfz5UNdLYHqhPRPwHv3MgDUfTYeyTJ2mXWJTMiDj3/sDhiFNGLGDm+X95BYggSZlnuje9hxK5lvYMCqUU9cP36jV+l5XqFbMIA7fJNDWro9Xp2A5/ISBlEe6fqe+FzS6AYpOY1dmalMu43AXZE5EPD3n/wa3rpZ5FgaVfw0WAcgNek+gtitmOugjM2CkXfnu4GMK/VW3pwqd20N9ly88x5cNAii3XxYWQERGWPuKISOlpLXJ13ZuIhLOYR24EkJtXigFr+J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using mm_slot in ksm/khugepaged, there is code snip like:

	slot = mm_slot_lookup(mm_slots_hash, mm);
	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
	if (mm_slot && ..) {
	}

This is only valid when mm_slot is the first element of its wrapper
structure, otherwise a NULL slot would converted to a mm_slot with
negative value. And current code thinks it is valid and continue.

Current code works since mm_slot is the first element, but make sure it
won't be disturbed.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 mm/khugepaged.c | 5 ++++-
 mm/ksm.c        | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index af5f5c80fe4e..668e74ad33b7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -108,7 +108,7 @@ struct collapse_control {
  * @slot: hash lookup from mm to mm_slot
  */
 struct khugepaged_mm_slot {
-	struct mm_slot slot;
+	struct mm_slot slot;	/* keep it the first element */
 };
 
 /**
@@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	struct vm_area_struct *vma;
 	int progress = 0;
 
+	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slot),
+			"slot should be the first element");
+
 	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
diff --git a/mm/ksm.c b/mm/ksm.c
index 2ef29802a49b..0d486dbdf7d3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -124,7 +124,7 @@ typedef u8 rmap_age_t;
  * @rmap_list: head for this mm_slot's singly-linked list of rmap_items
  */
 struct ksm_mm_slot {
-	struct mm_slot slot;
+	struct mm_slot slot;	/* keep it the first element */
 	struct ksm_rmap_item *rmap_list;
 };
 
@@ -3842,6 +3842,9 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
+	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct ksm_mm_slot, slot),
+			"slot should be the first element");
+
 	/* The correct value depends on page size and endianness */
 	zero_checksum = calc_checksum(ZERO_PAGE(0));
 	/* Default to false for backwards compatibility */
-- 
2.34.1


