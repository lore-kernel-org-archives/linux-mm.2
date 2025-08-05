Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78C92C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7995F8E0011; Tue,  5 Aug 2025 10:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749E48E0001; Tue,  5 Aug 2025 10:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611F58E0011; Tue,  5 Aug 2025 10:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6A38E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2E461A0313
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:48 +0000 (UTC)
X-FDA: 83742930096.28.AB31AA1
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 030DBA0002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eRbeDkab;
	spf=pass (imf25.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lUgc2mQ1RFMODut/DxjH0e3nH7UxMqXiDg2xTFsSSw=;
	b=XQAjB+mod+9rwBXZnfsaphJIngrgpsXdCzPEaszvBwGGxisXBE1PfDFSEtvtkIUd+AIUDm
	nsgB4q1aQ753mo0Z4fvLuwtLAPrye+EAlavV0ptv09JPMJtOMj6SJf7zKJTgN7NaD0bJTF
	MTXMk5BT7ukxhWBWu4Obeh8jm6G2OIg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404007; a=rsa-sha256;
	cv=none;
	b=BMV20uagMOnLbNrPOXddxBOVu2IStfoX6fpqw5XCJ+6yZcn6S3xL6oI8AtZZ1t3WRZpXj/
	rHJ4m2WFvfTKtdHUpQDIAOVdqlUOPuXyUFjxIRbH9gYB5f1S8CgDe00u3TfoV6RnxMZ4ko
	Fk/yo/UEZ7z6pZRiqUPI5XpyjAfXJq4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eRbeDkab;
	spf=pass (imf25.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55b733911b3so6124929e87.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754404005; x=1755008805; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4lUgc2mQ1RFMODut/DxjH0e3nH7UxMqXiDg2xTFsSSw=;
        b=eRbeDkabIKQ4V87aSMNpp5ErpEj+GXajSh/KeAfI8eapZ2BPBL/gFHhXKjZvpWABfp
         okQDDQkao4fdFxN3fDw1tFYuOAdtu0xSdUXdsRX3QMemg11iAJ+JwUN636hSA8CQL9B+
         dyhDFPDMemVvhPoLR8MshFpFanx642CjG380jzfdBfrXb+OIieZ2KjYe/KMPRby543tH
         UHZ1MZ2/WS8Uxq6n4NipaKNKEH+fzm4g67jmDh96VOpkcw9MJ83FJicVZXg0YMp1b0D2
         rNbNOZGm5aB03j2MQHsMhG4VyD9S8xokejjl94HDA4ZM0RgZY2YWm50KjU6ov+p0/sQB
         fSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404005; x=1755008805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4lUgc2mQ1RFMODut/DxjH0e3nH7UxMqXiDg2xTFsSSw=;
        b=tM8ITiRvmBZbAniveGkqCaXg3+tQMdev8Ese8Y+kx6ySkM7LfvziXSoeK/71AjTj9c
         vklVIIKYFW9+J185a6vbiUMKuG+saQ2RdWLfuzIlPy0lgAhhEMvYiw62tDkMozgGqPSZ
         A5he2srZNo2Svj/L8dxXne1sxwp0IaBt1asmLJ/Jt5cTr3jTcftqWbJnslER5q8nP8Om
         N9M94KsVs5nwLY42dh5B7IOKUuuiUcw4LZEciCJS1FFZ+yzHa6ROET3zTnserCZL6wJA
         CvjWPSwZHSQwBXMT/kTnBPjSV2ElE3ZL3eZKXuAY3EB3O1aa9aWowFaGtwGwf1b8S8fB
         +EXA==
X-Forwarded-Encrypted: i=1; AJvYcCWflTL/Gmz9K0C0UGqiub+mY8h4gB4rO2FhBkJoLoWDXOOPEf4MNTxrVT5SBaGyiKvMGyV9BLVcxg==@kvack.org
X-Gm-Message-State: AOJu0YyqFQw/iZvK912GPCYC200ODB5X6rE26qNKf67rqW/BzsByXdbx
	gLrT3luZhfyfJA6/9V1OIJeoWhh0gjeYkFwM6nC6K4XQQg2+c2f6WZUYG6DrYppdgE4=
X-Gm-Gg: ASbGnctQH6OtKioSuQ39Qc7nwpma+EJ+NQGAsYntL7spl64gM3O8xUH7dRv3fu+f9Dz
	dqjBZUm5LkPXoX5qt/bGQWo13p9EcefUxrf/YqFfcQymt+aA8OHZaApwUmy7a5sbpvBd8GVC2Yc
	sHpazFDne1dmxdy50FkpKfgFRFgwx3eVeFVrVSojdi0STZCHlchrOeOCa5wxAEtuOoxX3xfT9Ge
	Yu2b0xPDGYO782OF+eEAv4JUXdPKlCRZ80CpLXy0fiuSxDAhOHUUBp1MUfQWxHzk6YuKwV2o4jN
	DuozpHUGsXoN42dXLqRhyGgzU3yGC7Yjp8hV7yj+HnazUiNyvYTIjrKVBGT6u3LnyRa686EFeQf
	PwEfRQ/GT4kQPlTRWH3cqRR/LRkfyfeRB1MwB3Z3xS4Yv1h1v73DdeHUM6x6Dap2oyTcwPwobng
	ovtTS6
X-Google-Smtp-Source: AGHT+IEfdK6xUGSau1shbIGz1OserWC83V4+ELanbWHlOwkRpBjVR9Bm+3vZR0IX6iJXBqrfn1b6mA==
X-Received: by 2002:a05:6512:3c97:b0:55b:8277:22a2 with SMTP id 2adb3069b0e04-55b97ac64ccmr3140519e87.21.1754404005154;
        Tue, 05 Aug 2025 07:26:45 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:44 -0700 (PDT)
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
Subject: [PATCH v4 7/9] kasan/x86: call kasan_init_generic in kasan_init
Date: Tue,  5 Aug 2025 19:26:20 +0500
Message-Id: <20250805142622.560992-8-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 030DBA0002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: zzzxz8eib5hqojina8fs1dmm6gdj1ry9
X-HE-Tag: 1754404006-800653
X-HE-Meta: U2FsdGVkX1+tYkKlR/MN7lZvh6aTfN38Yymk0tKql89z4Z4zbOhiftFpI7Y1lX2nxEEtHsY8oTp+S5Vi36v2srWCPV7FLtFuHmgH9hr1CfiTXX52hwvlr+uwik+dDPbNCj5vpIkuPpVMNAhde7PC8u8FLF+ZRdijrkQtdvNsedLXG9qDg265a+79ts8bOyOpuhsl2bVkHFg5vS8ZyCfsqbSAcsOdfqGNVoeHuHAJrlhcb5sDIwXZfQf1AbB9Sik0c8/dYSy3wcHSU5Wb3m6T/slOZRi3lm/diIrLzp1BTvDN0Xz2cm7Vui9+Ro6hk2hyOMGQY8sc9MLCIhTKsmZ/UUtdp9l/I+tfj9JopndTNpSdIV9Q8vDSFz7AIJ3y9HD9RiJvjF8KPgC+eQLepJUezLFi2+JiiDc7HG9Tv2R4noUdexvrZxyWXKFO2CQKLOPelOE9qxSkjYCpPQcJ162UleCNr8kdEHNj39UFZZkrBG0hayJAVccADleGDQmQd7mfr64KwrQObgD4hTT9nGTwKzB3MvoJyeoKuHC83UjC+QMZC6kCa/QcHMXz1jFbAD9RXlHYh6Ogp/1OJd9rgaOsN615aqP2qXvj/q+zRWSSN7O5YoLYKxsViNzX8eKou3osNTbKRRWV0T8OLRThKzeErw4t80H07rl1FvckYcZR+VZAd8AZvbYkjb1etDqMPEeg+oehQJ086KOVXeaOJpItnCj+1cZ4moHLawy0hCTQ+zMDeWjKHv+hbEm4oqwc9wx6OWyp/uZH5nN/O9rUTS5da1fQoCe0qOxrovcTXPYgtKvSD++xfkUNDvOX0GWbTaFNbPhpYzpaaUcg7JwtIjnZn18WDUWJdIcUHh/ILI+FLRd4lQ6RbNcpq207ZMf2uSoAbuwZwWNF/6nEX9+0sHzayuAZmdBqLcHzu/4SMxDbp14cX7LOUksmMdgyNvbOogQayGCWRtUdgUUCEXXjoEq
 ANAucUjd
 RJUp5zJ4UmR9XAE3wbUjPZOLALud8mrbKTJX1vGOT8VUJ+5nhkJ8gJT7R5eeNTOGcV6gBWbb1n0tyEJUTJJ4CMlhD6wNtrrg/mtAPzvIK9A+gu9HWdYo8/I+sDJBisYLmDgKUbQZS1mOgjuoACo7hB/9xa3MafrmVERzs+JsgFXMIHjA3Zr5GxunKUaUvuNkYc3YdCPPofkxSdYDDALZ8MXYtwc4poLuvoiIZpubO46/GLREA+Dzz2KhjnepcPD6dN2VDY+DFOyHAPC7svZTEsBgTnGYVThjpdNGd7UKH98RyFswUe7etXeGhfWcMoEdxn5O0EiR8vNzZFstOGj8mhJlszMZLzmFN7gDC2pKpORe0C0WvKJzTPz0bB2hJZUB7Eg9WyqHtg6dDm2G3vuAytdwvH8N6G2UzrYM80QYQZAHgNyO5GtApR6CgwxykLlMP46aCgHZ/AbyIxalXossfi1Eins5bTRXasnKLYfNHL5deS6sL0iDNyKVkcaDpSQoCkp5fPVb5f5JjfEsd2U4J4NUKXUNNoMCEcA2J+GGphv7v2U7l9s2xtq8e6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call kasan_init_generic() which handles Generic KASAN initialization
and prints the banner. Since x86 doesn't select ARCH_DEFER_KASAN,
kasan_enable() will be a no-op, and kasan_enabled() will return
IS_ENABLED(CONFIG_KASAN) for optimal compile-time behavior.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 arch/x86/mm/kasan_init_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/kasan_init_64.c b/arch/x86/mm/kasan_init_64.c
index 0539efd0d21..998b6010d6d 100644
--- a/arch/x86/mm/kasan_init_64.c
+++ b/arch/x86/mm/kasan_init_64.c
@@ -451,5 +451,5 @@ void __init kasan_init(void)
 	__flush_tlb_all();
 
 	init_task.kasan_depth = 0;
-	pr_info("KernelAddressSanitizer initialized\n");
+	kasan_init_generic();
 }
-- 
2.34.1


