Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE192C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 16:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD31D6B00C0; Mon,  6 Jul 2026 12:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA466B00C4; Mon,  6 Jul 2026 12:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1326B00C5; Mon,  6 Jul 2026 12:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 789596B00C0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:38:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 000C1A018A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:38:50 +0000 (UTC)
X-FDA: 84958910820.28.AC77B83
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4435780004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:38:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ggjsNDMQ;
	spf=pass (imf30.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783355929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEi1MjXj+z1W6jRPKa6Or+XS7xlVkfSz1SFMtHSjLrM=;
	b=1789Q4L199FqGJT017EjH3X+/kVuW3+UkAOZFb2QxvbfeO1B9BUdGcAJAToKelCucbw4Y1
	iOXAQvOn89sSJGTQxnbrl4XAl///H64Cs1OEbGf2RO4jXSDgS89xmNrCw+l/Ynp5gY9kWW
	qmyjxVDYhJDg9GzoQYvAr4gEP4UNVp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783355929;
	b=6Fbd4ejMHGYR9jwm+Iy+P2MMboXMznJ6tyTZDAl29yhw8e0K0Lr3SeELIAYZSFdfyKdpHR
	GYxauY5pcGLOxzsRC5a8DhZ6MjBOrl4FSVD2acj99R3c7NvCuIDilj8SBKSHYZPai58UrA
	T0vKi6qdOH4sl2NDcwanPvL14yoZ39Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ggjsNDMQ;
	spf=pass (imf30.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso17774865ad.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 09:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783355928; x=1783960728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KEi1MjXj+z1W6jRPKa6Or+XS7xlVkfSz1SFMtHSjLrM=;
        b=ggjsNDMQ9Tzade53UA15IWm2iEvC6Qxupk9VoCmKIHG9CsFxzFSChgnWPxFiY1zOVS
         Q294EPRXCduGfp7zcGW22l3nrPrdOfK0p2U2ogy6nDAIg32WxB1T5ex/68zQk9PY0VT3
         NoSEbndmykWD0Ppg9mSeEdV6BeIhVaahfduhk/OO1Ab4sv9qX+YHorLdtKUsMOhkSqIn
         MU4JxpS1M4wOCFa4bsmtDICq4FU05kg9EnlOsJTEk7rC2fiVK57mdjYLc2SdwfMqcMGk
         u/J5cRmtvICpA+Y2aSeNfaQvVrYKLTVTp/4dIvJfAG3M8RQXxrpGK1xTGgQTG15qG9C7
         Qm4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783355928; x=1783960728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KEi1MjXj+z1W6jRPKa6Or+XS7xlVkfSz1SFMtHSjLrM=;
        b=VBTjLq6JnPzeWBq9iVV8wR010q6NaKhX6FQXaY9QtI4iqs2wx4fiA7pzIhunG/RKEc
         aiFD3Ure+131rmy2AWgrdyj891c4Magel9zYESvMMuiErSo5XyhMt3xr3SC7RnU/9Ice
         45+6QcrI4lRK4quqDggZTcL8UGY1pyhMxU9w8RRPjOvscoOMlBdgMCBi4OOlCs5/ezDP
         li42eOTeHZfOTN5zCWLJ+baWPnY9lFXr7l3DP8qtIXE2fgsirrhmT6z7DRmCSdnF5a1a
         TBfBOW+HE9y/Dnm000TePwCwr58AqySqWqB23N28XGNm483AzD7OnriVs0tvRuVEw4yx
         GHRA==
X-Gm-Message-State: AOJu0YyUdvdoej/ZJ8iXEokVzQ/QZ9dcv7RRHRTh9SQvuPwIzjk5z2qx
	Vs6Et8IkltFMZWx/mDlO3ZivMG+DN3APnoQ3ltW7X0MRUsMmH3jq5k37
X-Gm-Gg: AfdE7cnc0Y9yfYCZjir9lHHO4CpZHNKRHMzxOxNszoJca4ZSk4jcy1MjRSQaksh62VV
	b9KCJ2ASSEDtrA5CGEo1bnO3vgPkLTXXxZHaPK6sofhxGpWbpMW8wcQNA6NAeU+yN+0aPXvOH8V
	O2Jj6iJ0+jKjxNPM7YmN3l7CNa0zKLKU5sFeg6TOA0Nk9XIgEbIkUUizIvfFLuhYSGBVlPu5qcY
	RvB9qcanm1q61gNhX688mSykOBz84vzKllFXpuYEOcR+Oa/YS3yMFKHWvnODT/PjkAcqecWH/QM
	6aXJ4lXyvbBIVLHaTS0Doz912eiRcac/qbRdAgxL+IV3qG6paNXtr3OlAxAE71qKL3Nqwpo5aLc
	UkEeBJaQ/7AJHRSTjHoL/TxErvAj0AOdvuRYVdDX525ea4IdoWkyhn74QibfssXjY09IPUlieYz
	VKNNA1krM=
X-Received: by 2002:a17:903:37c3:b0:2c9:854c:a45c with SMTP id d9443c01a7336-2ccbf04371amr14923415ad.34.1783355928162;
        Mon, 06 Jul 2026 09:38:48 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7893a8dsm53103305ad.73.2026.07.06.09.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 09:38:47 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Rich Felker <dalias@libc.org>,
	x86@kernel.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH v2 1/5] x86/setup: remove unreachable memblock_reserve() return value check
Date: Tue,  7 Jul 2026 01:37:49 +0900
Message-ID: <20260706163753.193875-2-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706163753.193875-1-ekffu200098@gmail.com>
References: <20260706163753.193875-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4435780004
X-Stat-Signature: hnt93yfx3ytj1sg7rkt5wof5xbgdu1xi
X-HE-Tag: 1783355929-831444
X-HE-Meta: U2FsdGVkX18n8/EK4jVJN0qhs2wGg1w3G9wZrrrdGe075AJQkPAeS8csRakWeONvGsiVFI2sLN2tMfY83IUmQoI/9mjy01RbYYosoNNMR6+D3Ch6spHBq/n8/8CNrrncrRERggFwkefRkyOrZ0nFkIW07rlfYgiw5nUq3lAqI4DPepeHOCq9lVsmzvgFk47FOu5dHm/at5an32i60GoFHVs7cjy10Ifs4fGxNlmLzXuWQD3ud8nvS8NfPpzFH/bmda28xG6UmDQlqZqb3r+5E47dHnCgK7pCAh0z73hbjZcKD/NELrWHiRC79InWVPwiFYBq11rTX5PI/T2kz6Zuo0JIczjOw9eU3cwdCuyV3mI+3l/CkkD9U6+fKDz0aWYeqYbr1kKTE1LFdJyX7lhr4nDdTUt1azG8ijVRS+C3YdCSZUlPin/nq184sUiDUIS3ULkFSww9sVAOKQWySBu6Wzl3Iw28fbuE0VkodPdQxdsNFk2pr86qWrTA3vQh/JKFaFNihME3yTSQ5suHNbSWvXSaHvB7+N26NaKCoyP7PeV2MAwQgV+YJdPiFJfeVuOPam8O5DTiOnKhxR35l6pTm5ayOs5ZQy2+xv5q9/wKHwB/Em5TvTaOUh3fCsaYk9PtAK0ky7knHQt5/9zhZOj4cAR5CuREXipSRt2JaNE2bD6yEw/antzoWrMGFhVCAfyQoQ8DQiaTgdYtaROj5Lvqn4pSLBXF0Dm4xv+GlyPLMcPDYmrkuZuXA0bRMWRUmdqiQVv+k3qHGDWiwkSG7WY8woien0Z1bgcJBdILkGbwXkD+aVpTfFgQtRbIagS0B1HVaTejgSV2GeFnCvghJ4ckZeRDcZSk1j5z+CJS6eP+ysMqcyqdZS7RftYRNzBBItXRv3tiYVHh69FISIHwKgkUPCq6rIEN/NHY5Eku6bNaUcjP3GVNARHRVz6dkfcO73+VZGRNOyWEBdkalSgh8Jx
 prGJ/YpT
 jiJ6o5FiSRbmggo0Gc6tNHLdmv+q9Z3kq4bSCpIfNOu6h4+Z6h8R69y7c95UHUpR9U/jLYh/uNERkU3RwoAnWzN+X2ur87XeKqX31QbCPjNNl0EZlHHbecDsW6r/+djy9bydH3ytK+0gzbd8K1jkbKmPUK8+1eP3VumI7nVT8TtB71FB/QsSpwfkr1t4EsliMggFaAFk4ibqzAroiBw7/1WSvopOiLvb2JaQVKUwPqzAzdVOT3uSY+5OvHRAcCsTEgaqNnGl6OjDd64tgAGhkGe7q9AK7pSjyJ7d0tqNiWYPMs+aB2m7Yqdomm1enyakg9/hS34D2w5AL2SQ6WsM29zO+Vor5XqbwD7jiEez5O6Fd997c/hO/JjYFoaUPy+OHM1DJ5SsiGfHK2CrYxxzTkzdn2lFLqVVQPJsbNJRJFhmiYuA+mWsU4oNOUwYgXUZ5s2mzYAYlaqHia5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

trim_snb_memory() runs from early_reserve_memory() in setup_arch(), before
e820__memblock_setup() calls memblock_allow_resize(). At that point
memblock_reserve() either succeeds or panics, never returning an error.

Therefore the return value check is unreachable, so remove it and the
related logic.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/x86/kernel/setup.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 46882ce79c3a..f9395bc632ca 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -742,11 +742,8 @@ static void __init trim_snb_memory(void)
 	 * setup_arch(), so there is no need to reserve it here.
 	 */
 
-	for (i = 0; i < ARRAY_SIZE(bad_pages); i++) {
-		if (memblock_reserve(bad_pages[i], PAGE_SIZE))
-			printk(KERN_WARNING "failed to reserve 0x%08lx\n",
-			       bad_pages[i]);
-	}
+	for (i = 0; i < ARRAY_SIZE(bad_pages); i++)
+		memblock_reserve(bad_pages[i], PAGE_SIZE);
 }
 
 static void __init trim_bios_range(void)
-- 
2.43.0


