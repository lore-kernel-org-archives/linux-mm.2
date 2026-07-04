Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1106DC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 09:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4A76B00B7; Sat,  4 Jul 2026 05:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455B26B00B9; Sat,  4 Jul 2026 05:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349AE6B00B7; Sat,  4 Jul 2026 05:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E764C6B00B7
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 05:20:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 513A91A045A
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:30 +0000 (UTC)
X-FDA: 84950548620.25.FBEB1D2
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 84F8940003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 09:20:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aes0NBVL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783156828;
	b=RuqPacFANyY7unS9F4LKqVwlsR+kTCZMi/zKqyiEKgdp8Otfy/TgqbJYsgITqWj6of03oZ
	WNukbjuSP0Jok5nVkJV69duXZnpK/nL/KUOXXj7DIwueBmIw95By4pXqNK0gWNAo0op2lL
	wYVfOIxwjm+iShKa5Lu3eQIw+L+DKZQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aes0NBVL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783156828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFAUfYNjyqQtZGhCyYmSegkGRUrEtRa1P/qRb66SC24=;
	b=WHxEGAVnJaOomFlu1KctVdMOSTh2e0K7BTU+liWVLdJbxBtPCFQtY5qIvOvNhgQy7JCt6r
	UPTpHAM2AQRVH/ZewnMtg0O+/evl49Zo6G9MZvf3bLRqNpk2bDXId3XlT4+UaBLnavaT0W
	53INPM0DiwFiu2f7LfBsMybL+PQS8zk=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aeb17c2564so1279863e87.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 02:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783156827; x=1783761627; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFAUfYNjyqQtZGhCyYmSegkGRUrEtRa1P/qRb66SC24=;
        b=aes0NBVLxM/PRQT5vO8tdttnr3IAB4w1/KhXRmc6OdkESz0g8ERTguhg1KdIWNttBC
         1838omDnTjiXbq0K9TuCqRcPSCiINHRygbXhpOPG4opHZp//2BQe2qk8KcnQdDbPtvyv
         fVrPx6gM0Vlo3iOkVOvR/TOHYhUMfoLGxfOLTzfiw/VeMnM5eaeYaytH9fTlPoWv/QqU
         0Gkyu8c7SqSLeCbucmRXj89bpdOYiYCWdLWQtlu0QLMNoJ5GVop0lE3hpSAIjjGv5OSC
         g3W8UCQFeGQSjBlCICLPi4NIeNQkklh0jsew8rqQOXf3wS8ml1o5nvqa1pnH+/EZbB2I
         042w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783156827; x=1783761627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gFAUfYNjyqQtZGhCyYmSegkGRUrEtRa1P/qRb66SC24=;
        b=Psvr9rvVhlU6oK7bNTYZwFEnFYFn8ebROUToRmRhZ0diKwmRZcM0T4Dc1zww/btNze
         VEfqIG2Lwb7mTiGuzzr5xiqS7vgQno3DQzk+PdV8OcC7pEOrXtB7OfdhBi/E/Pn7wdlt
         Rjp2wQ/+Zg70lHmKP3O4pDn4ymWX69IBJjy6uQBhASAf7Tp4TKq+jYbLe96xvbqlrbEC
         ttcbm7HVsF0nrDNRqsju7Eis2QdTTQvRLdh8BTUquBHciyRBehSPdl03Vbm82UBKAk1K
         BAddQ/aR+gGVaohdpizIOIVQeNsc3Eg+tyYvc61ul/1yG5BpN2mluaN1SKSwbD7ebqNA
         kxwQ==
X-Forwarded-Encrypted: i=1; AHgh+RqkI8fnXzkv7YmEdDimd/O3lVIoYoqR/moE9tPU8ZTxWLyxfy1FlMgR/b/gfWe/tNZdfaupiIasOg==@kvack.org
X-Gm-Message-State: AOJu0YyuC1DAW0N1KMwqVn81CdJ8wYcE223U4chDeK0Uo7Q/A95bSoKL
	J42j85y9ySDckKThCha2RLadU/P2YyodlLi9HqaWt6tLyo593NIzE1OX
X-Gm-Gg: AfdE7cnjTgqJ4LhSrXIRJIZLw82SXRfB1zQRc+Lg739j+Vwpk/G9OKUcyitglS14I9S
	6InAJY7f5yWhjmbxGuO3dEcdR/VMkv5J/xnVXx2RbT/LE3IZFlGLBpliIcp9Q8hoqbMhEswNdNm
	t7bUYmBnsnhPEq3ZqRZQC/HzqJWFMV6zEzcJxUixVWeioQheUCUeobtS6D4wb9p6c8gVKt+4ek4
	RsB1vutWQxw4BrQXJOEmgThZgiwTEgRPaZEJXQeKV9qffqzRUu1NHRatZwj0mQRmGwltjzqsNtP
	ZxR8yhnb5wCg5zjJUV8XvQUR+ZI1ZgvcYwUxZf5p2Gwwxn8t45DQG+PkHcu1zQfKtApB0G52YzO
	ueBJA1nB6vC0ut0YVIRNkrItZyrWAi0wA2igDCBL+pragE0twl6itpsqXJbzGsfBXdZjb+SBzE/
	oYrJd7tqfezCqdjGzrZNtNuOVTC5hcdmk33kR79dGMs0aP6j/YGnwZJx0PQR5WnUU4wGKiw/xac
	lkHpXw=
X-Received: by 2002:a05:6512:3ba7:b0:5ae:c10a:22ad with SMTP id 2adb3069b0e04-5aed5088002mr448424e87.20.1783156826964;
        Sat, 04 Jul 2026 02:20:26 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aed13770fbsm1149063e87.30.2026.07.04.02.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 02:20:26 -0700 (PDT)
From: Igor Putko <igorpetindev@gmail.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Igor Putko <igorpetindev@gmail.com>
Subject: [PATCH 2/3] kasan: common: use ALIGN_DOWN macro for stack alignment
Date: Sat,  4 Jul 2026 12:20:06 +0300
Message-ID: <20260704092007.3483-3-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704092007.3483-1-igorpetindev@gmail.com>
References: <20260704092007.3483-1-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84F8940003
X-Rspam-User: 
X-Stat-Signature: uaekrbn536gyahtu8o74g1s85frkrync
X-Rspamd-Server: rspam03
X-HE-Tag: 1783156828-579095
X-HE-Meta: U2FsdGVkX1+BENia3nVOT9T0wlVqfGK3I+G4Rr+awVvLCgPFnMpf5oUfFc/+o6gg6qHA4MYiPoWIreUNzWAHLmy1F8IV/GKZEsR9RikcIcKJ/Bd93uXxCeIi0cqtncpKFhx2g8TKAClYTuoKZTyVznk56BDBFnERZ84oFhwv638lKafBClzt1Gb62YPofLyGz8qoBr5aeJPJ27GWcHEfxeCae9yt322mJQOTINvmkT8iRlMVWt/r+T7DBKDEEfiF+R35WzeDLiJ1n6lz6sIoG0pvpEGdewO40RDlH/JL/q8SDTqXSwG4RuTtDlTvD44jdWp1mbhXDRTWCDZeBCT1X6HAirRf4FBZgpkE2vSwLB+4jILxv7phCnunCdEPi63VEfQsEwohGsO9DfzoNGAEw8runIl5ODgM28fCZqu+NVPia59k0oX5aoerQy4xGPJpNKbeAV4QK+FhQGkXmp2PNF+bROOPoBg+PwnlpC3xCMTddOVs3RrHcy6+dQ7haq6JOc/qLIvZu7e00mpYrNdEsTraX1tFrsnTLoFfdIU98QBjQDkmrt2rSbDuIXI3lbdFllnkzuAbrFad38OGdPs/NgB/kvd1GuLIuj+d3A4saQqPiQtKggMYVXH0U51//z0MtknklmC+rTRwlPTl3yBIwOYlNhQPJ/KYhZzLSfxNg+bFnfAOp/v/tR0xba2/Q4y0fcerPk1qgRCMrKUN1pl1SUnrGcHuNftBshbL7St7xCwuIgm5ykKm1UpCzQYx67fM4vWgPpH+XDmUCKLzI152Ycan116PNcQSUSQz65537704Ma4HZJqFeCIrVg65GvgYedmSkSMA71HHM0oXbjJ949DJNd/mi3svTKIcx+BJPDxYe4fl9++n0y1JO3gSXn+fnaLc0mGbyCCc5qgaig6r7pQ3/rsrFOTj+FOiKMxa9XyDiJUz8farNju33Li3HJx3F8bAF9hayZpeH9KBD8z
 y03R5o88
 tBzbuufjT1vQ/7vhowLjZXJ0q5Vv7rssD7lQSi+pdOl4n4zhJkdvrqbM6lEZ2X+HgdqO93cnErCunvH2/7+11U7IzpjUvRAxB0XWFwmn+PBNoze3mb7Yh7JjwsPvSZ2jKmqdQw4NzvftYjvyKE6tlHyv+vZ4fyq1sHlHtQ7lGIn9MBQaU5kWKVTLwpOIMBEoxh1/zlkwcaPbE5Y9H2nwUOdFTN+rfZck82uvyVtjycSrKtQPNmLt1R/9tjgTqhmO9nMigbrqTwdFl9mrB4dliotoaVBKaq3tfIa4M1H/T0L4Gdn0oXlItHuJcSnXSjJiW9mKuodqRKahdyPmnh5qlNpyO6WxSrL4op3Y8Q+KsML3VEAtpnB/uk7lW1VmyJVJJzGpFWN1aQp/C1DST0gIcRAIWaToAsGGJ4hGredsQlGdEwdAnisBOXQ84dR5BlM8/qBZNaBxq/KouETPoeO896Q5P9D5DuhoLi3xa5H/4bgLpiqPYrAisJ4y+J8pLSDmwKz6i2JWdfKP+SR3dBAM00ND8q9UkkVBeO8/FI1xgmY1uU82JQqbrI8K02O0BK1J5xHABF8SeKhGv6QP8jbrlyI/7RxhXjImOS7evOOLxg0oKqXKExBTkV8mmNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the manual bitwise alignment logic in
kasan_unpoison_task_stack_below() with the
standard ALIGN_DOWN macro. This improves code
readability and conforms to standard kernel idioms.

Signed-off-by: Igor Putko <igorpetindev@gmail.com>
---
 mm/kasan/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 34aa0fdce..5faf73c8f 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -119,7 +119,7 @@ asmlinkage void kasan_unpoison_task_stack_below(const void *watermark)
 	 * because this function is called by early resume code which hasn't
 	 * yet set up the percpu register (%gs).
 	 */
-	void *base = (void *)((unsigned long)watermark & ~(THREAD_SIZE - 1));
+	void *base = (void *)ALIGN_DOWN((unsigned long)watermark, THREAD_SIZE);
 
 	kasan_unpoison(base, watermark - base, false);
 }
-- 
2.47.3


