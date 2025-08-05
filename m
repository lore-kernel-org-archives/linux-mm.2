Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CC6C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1BEF8E000E; Tue,  5 Aug 2025 10:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC1F8E0001; Tue,  5 Aug 2025 10:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D128E000E; Tue,  5 Aug 2025 10:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 857278E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 512BA1345A8
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:42 +0000 (UTC)
X-FDA: 83742929844.18.AC10DD4
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 630A420010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G5oVqNF5;
	spf=pass (imf03.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fypRqRD7duJ7p6/XnMiehAY4t+I2qqoeS7XCKLtEaPI=;
	b=B4RCkq3n4sWCw0QL/l5OD3RCdXP2eC6o7ils/tAxC9CN6ElWULe51XNfCxfOKqfpWlIbpy
	Z1cnPGC0EUUh9srcTy/gVLfiCgkrUoA1UsRfgYwso5WesNhtpQBgdXudpXCw2E3r6HkjCP
	WIjBt+Z/EW9WTZLQCW65J7XiQ5Cqacs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G5oVqNF5;
	spf=pass (imf03.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404000; a=rsa-sha256;
	cv=none;
	b=Hxpta2RT85M12onVeYvFm4LEAuhGzzaGk/VJXFTOHBAtjoFP4TVPqXVGgV7Mne0Cj7JxYB
	pIea/ETu7E67Tw9akoMXQ7AxPZuQ8kz9ewhDJKVB/PHhruh6u8O9cZL95VLLuyMtHzNAAL
	HpNF7L/A8oEdD2JjjqIrpzz5K+xkM88=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55b975b459aso4176914e87.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754403999; x=1755008799; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fypRqRD7duJ7p6/XnMiehAY4t+I2qqoeS7XCKLtEaPI=;
        b=G5oVqNF5Fsz8fZyZfpri4YovU2RZ9lu2dTK6lAPTPFM/33LHw5xBey9wOYNfBMAzMD
         4+3GV77wkmviZA/7izy6h/uJafmXVzbdj7ioR7kek3Dfygia9x+3RlrsdJC73VN+Sxd+
         0XTaqgMzxL7C5Lgn/zRvvTGucH3brNrWQ0hWQ4LKLd0YZyDvvaBmnrqwMPVq/KFvoBIG
         xlbKHVcdwWtXigvoUeZB4g/+YC/8kTerIr91f0Aa4ng3GVGRIy5E02ke1WLhIUQEOLRM
         SEfoByMJzr11gTB34/SjHI8ERSIQEcFHhfWDGT6OGmvPDKyn/7+SDmqeoURyQ+PbmsY5
         ivWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403999; x=1755008799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fypRqRD7duJ7p6/XnMiehAY4t+I2qqoeS7XCKLtEaPI=;
        b=ShcPz02lrAkNbfNYQBcNrlavQG294vKMzAG4q7zjiTyl0WG0LkJ54Mu1uO2PkU99q7
         bGLZkDlwhqn31jSMgRyJd/CF/Nm2gdhlqdUIxLlcWAG+BIoovekW1gfdNbeohgNKtyb/
         wt/DNVmQIMURw1J3bJ5t//pSIsSnR+25HbinUuvCq+W2aAeQ7mKVmpLrcyn6d71mj9Lh
         5g+1qX6TVWqyvRCD1pUl42DIm0VsAIqKzYIMyZ6FMGYvAIWIoo49AJWJshztigrrwLUP
         2IHOOvI3oTLeardf9FftcjJsz4vTdDJMK2xrmmQJr6zLt/E7JKAdzAFeSDjIdqq62YtE
         VQkw==
X-Forwarded-Encrypted: i=1; AJvYcCXAJMwondGG/ZnHueP7LDlSjTBA7GKGajkmlhVyo7V5gSgo0zRaJ9fL91PaI2H/DwOL/3fFyfFsxw==@kvack.org
X-Gm-Message-State: AOJu0Yz+BV6uPBGvg25Mu9REX0NiTzYf4JWVIZFHNcWKB13qk2pMM/lP
	igLlWdQctf1HHSiDoroYkSXHv0IodB0dKE5dCoB93zQeXADhcIUmlJQJ
X-Gm-Gg: ASbGncsWNMRQ4imi04jNOcrNqQ8M4QACZlq7fzEdAWPe+h9iB2TWiDucHuUZ8EaX/6V
	yRzr7i6rLMyPOFBl6QFn6mSEHDBsDcvATca1N/LT62cr74pnM4I1a6NkMqCpRihjOVU9+eB9zYG
	mNe70DeoiV2DZbpP6n9/dR3uUNjhUWSzJOH45ULhzbdHfJWo7aZvUW1AHnCHF3StmADTZbWTPqX
	F45Pnu8DOsWMlmc8Zlg2hNWjC6/+30ybV6fhtDBfk1GpfHv14SZHqNzPKImODDptLK4t4txs6ro
	R1uf1p725pByjquSdQVK+TFhQxB/3/YPAZRNaSBDmskkHZD2Pigu2xjeDYFt+58Sdebpff2TPtV
	38qcAWBmsHS79UpmHO3xdw+wAiWs90zSx3PJYzS9nUpniziLwuyTSnEThqipd6d7lqQQvHQ==
X-Google-Smtp-Source: AGHT+IE4tVfY0GDnGQOdh7BehbCQ960f1sYrnnyIro3xm6jwPaApab0fDljnNDBd9SZqMzry0nuyew==
X-Received: by 2002:a05:6512:a8e:b0:55b:5b29:61ef with SMTP id 2adb3069b0e04-55b97b89544mr4329067e87.56.1754403997895;
        Tue, 05 Aug 2025 07:26:37 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:37 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	hca@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	andreyknvl@gmail.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	trishalfonso@google.com,
	davidgow@google.com
Cc: glider@google.com,
	dvyukov@google.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	snovitoll@gmail.com
Subject: [PATCH v4 4/9] kasan/xtensa: call kasan_init_generic in kasan_init
Date: Tue,  5 Aug 2025 19:26:17 +0500
Message-Id: <20250805142622.560992-5-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6xi1313qxkedjscjjyy3szc9kecx19b4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 630A420010
X-Rspam-User: 
X-HE-Tag: 1754404000-398729
X-HE-Meta: U2FsdGVkX1+8sSzKLp/I9nk70Fa0AixXbM5AsCktFxoZbjqac/14qFI5sYoc4n7Au3QAGrg3Nuy5X4ssDLmgr4XTLGbD/DmfI54Bt1sqGuzkdaIu7zOMoKI1zDKkAN+HRVStINI8DN2u3KtD23mSkICiX13/K0CmaR350pp5woUPt+tGQqRcDZgwUHevGZDZ/iR1RyJLq5rtTxpwoh8FfYs7l1jIfDZhSB/Rr5RuznaTiErhjyRuCJwbGd4MRUshQ4p91bXMTxH/+1dtUx2DLmuedxFhfFmKAq2gO3KjLV72j0w1b+oKkM1c7s6x4gFeNP8BosFnaG2GvzEKCaESxD6V9U2e+1EMiYyM/L5cZc/T4lHG7d3SEkqzOUJSNfO08A3E2tU9M6jLdd/7N7pxYa8JqWGVe8M4yWFCm74ofFC++AwpyZkLZ68zpm9aY9juQgQZ64vq9ShfXE8QkfB9dh25MJxDpJagtY8uQsc9xxwlmoK9OWhjp+5CVJ6zKzQXnUqp2RU0czHZSJEP3olu08O8iFCjIdqDpO9HqJ7oKRaK5Ot9PaNU7/UXWkiPm7h/UF7HXvsjtC1cC/L2KOh4QRfLeQ6ip/W3RNLMyyCfSnfN8JSRZPyExdEib3dXLiT5qDyQPmXf6zywExrBucQdxiCyxLjHqz3xQmwBixnBQqNLoeoxYComYLfZYPi0CR1TtW7bK+RMAyxuqTqeHzGFBQtw70t/ik73g/BOW+rDVUKm0CQWnneFRr6hGl8m2eaajJnWGq/29jFU/L62MS0tQ6ls+xpn7yBSNCakvCIAVKHq9PmokajSVA9P60tNmIa4kYBJCyShwkffu+Ypc6M/ExBP7vT801ojGyT5gP3y2k4qirkYXc3fZu6lQgGFeLm6eMRktFDvZMiP7reMWDOo4+cFk1mOjg6QMyrO1msCz5sWwrinqm3wSHb0KnLawtBEj9FFrRCIVds9YXuwWYX
 uyaRoQ9t
 H+EWID1big9S8a91ElpqiKN51gzSZrE33MqE3jeq4AkKQTVenUiGPTGfEJMZ5OCs+3enHnu3XGe+TgmUIC8P2hsDuH3vqGeS9Lld+TdHDj9/gKNkwguNJ89Xy7yidv0ChJzgqIq9bnagnxb+txoymgNdTSKVcFZ9gSEvmMiCsOZC8R+noT7pbR2HczaUcdAZmX1JpielSuGpbonDub0TdeMV96IyBdAbBq614zGIattzXB9/VtYI8bk1UybZrbjAky0VpPTrqm3xROkaDM+THILwp9Z9lZim8zK+sR7sf3nKxPoSrePauADlqxzFRjpKCbzfu6//n7KD5IiDWesQwrYSyZnIyidZzFxPu8PsQsBCNggz3tC9U2bma+gb3/QFEEtXkSVQYVvG7k0wB+5qhPMNLXV/TPZp9sbcq72+daSthkdVKLkTLBiDDD9Q71YTweeDN925gWiF0x82CwK9aBHR9bRv+SjsxDqKHoff9df70IYq/bGVtXCk6P6Sn3RSPek9xTiIqb5iDstelyrGJ3EXhYlzENdC4okLspSStuveGYJASdRl8jdRL/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call kasan_init_generic() which handles Generic KASAN initialization
and prints the banner. Since xtensa doesn't select ARCH_DEFER_KASAN,
kasan_enable() will be a no-op.

Note that arch/xtensa still uses "current" instead of "init_task" pointer
in `current->kasan_depth = 0;` to enable error messages. This is left
unchanged as it cannot be tested.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 arch/xtensa/mm/kasan_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/mm/kasan_init.c b/arch/xtensa/mm/kasan_init.c
index f39c4d83173..0524b9ed5e6 100644
--- a/arch/xtensa/mm/kasan_init.c
+++ b/arch/xtensa/mm/kasan_init.c
@@ -94,5 +94,5 @@ void __init kasan_init(void)
 
 	/* At this point kasan is fully initialized. Enable error messages. */
 	current->kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 }
-- 
2.34.1


