Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DECC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50F98E0013; Tue,  5 Aug 2025 10:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9D48E0001; Tue,  5 Aug 2025 10:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8F88E0013; Tue,  5 Aug 2025 10:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB6308E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73D89C0200
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:54 +0000 (UTC)
X-FDA: 83742930348.07.29E1E5F
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 84CB3140013
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LHqG0mEH;
	spf=pass (imf09.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754404011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axtwyv1QW9Jl3sEVwduJUxW6lENRlEEn6jAlKX1Xswk=;
	b=6mndKBunIuoIHcNaq5fkkvvzBCVUmPWmCsNhtkVeotTJc8ciej6awtkzvP5sVbscIXMQF3
	6/E89gsgIk5xm54F27nAACufW/vTOnNTvL93DePrur6dMXjHy7IOIrUHgaeFsZXGgrL09T
	7U2Ncem1QOedAMADjdwLG3yfZEyGahw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754404011; a=rsa-sha256;
	cv=none;
	b=kMay20zebML+N3QPNpYMES80A3T2T/QutzR8ytblp67o+QmQKotvdzTfqWOHRe8LKth/2e
	E4u6Z81M29V9ZzoQH1u8CnauBE3dbvnOkQVwkPOrg8Kftmr6Xe9SqsWGlSn0P0o9ZdR0eP
	hio6vLLVZxkFAB3XodmxcPJj4czsgI4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LHqG0mEH;
	spf=pass (imf09.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55b7e35a452so6931475e87.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754404010; x=1755008810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axtwyv1QW9Jl3sEVwduJUxW6lENRlEEn6jAlKX1Xswk=;
        b=LHqG0mEHjiJvdX8mApg+W70P+2USy6sNymVGzhVcW5T8tUpAGSCxE3GCeQInAqp8HV
         xAFD3InqpiHscuPwiBCd17AabowV7CiH/ByVDUh3Vjv+iUeiiDQ1uEKQGdz8uZUfPr1Y
         tY2WGzickK1qfxkeiSDWzHTii2nntm9VsYHIlOwmggXIccHYmORcVU6GKPkCrjmVkw04
         dU9DZ9r49P8+VvoQbTKaZq1a0Ch1B9SbFqgvtL+ffvYU+0MdzqifYNykFEPgtr9kR9yT
         DjsiYUgPfmj6oPEBrpMR0fZ76pTaI1gAhfp/BTLsHttayg9COORQUiiy5ifGdA45fZTr
         Hagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754404010; x=1755008810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=axtwyv1QW9Jl3sEVwduJUxW6lENRlEEn6jAlKX1Xswk=;
        b=ER+zq0gfTDIDoQBKvC7gpixeZ9Z8+VVensrVjpiXlJVUNfdI/lSylHzn+zoRHGplJw
         fcDPr+1MYFIW41d40ciANdk91iVloFEtiL0WsQEO8r621RwldbT6hso3eltQsJmbAwTY
         0dlDmW/kWxriNGRdCr+ilJ3JPkdiJx0/e4G4LHuj44clyglNGqRiE/kKk4HTxtOfYA04
         1UwJ4dzOWnc6NuU4p32XtlttvbLNGgY3VDwyJ+n5y5cGrUv+ZnUos/hGJ4w9IaZVm4Qr
         XKeBcHTorFnreyiMvueU3XCEUNSQk+VXXxzXDgKSWdj2EBL2HQjBQscBanhjS3iqUS1c
         5v4A==
X-Forwarded-Encrypted: i=1; AJvYcCWGHnPhCJ/3ZsZR6Z09jiLXgSxZsg558tDmIDnKoFc4hz3l045d98S77BDE495JZGk2koD15VQC4A==@kvack.org
X-Gm-Message-State: AOJu0YxSYohy1VPMuUkp47+TlXJhGvlIXhestTFd9VjRwI06tjBOZ2NH
	IQJijsXeQfHcR3K3HgEaxa8fCeqIPwIA1ajzzy3sfXoGmK56JVe2dgc4
X-Gm-Gg: ASbGncuK8ffBTK2xDfi/I5VyE/oX8+5G/lkHUy+5TSlQ/JtkdpOKnEpfRCL+nWRMpe+
	lCt5m7f7NF0XSIrVKm3cs+8xxCGlPvSxCr7xU93sWL2m5XGscRRsmnUwoAUqqXBPkWOrPf7mIcj
	zJPDlytpuoYEZdWoG46W4klWoUnlpxtrzseEeXJtt2XQQJYOuaUxgcj+xJyW14X2pNLG9grAeo2
	MpAcC7GhszEuOoDvf+N6sLhU2aqiyi+jn2Gvm2klVkkesC1rnmeLwuQI56/BVFxxzxcxTJc6Wfl
	he08HE/JiWv58W0oH4j9odzloPNZNLkd+TyUGcesqGGaMq9WCLfjUKFLklpi4GqGsF8V5tqVVLD
	EnFmTWl4iqdE9xz41+pvbnd2eEPvPRd/o9dNaAs4yuEmk2ue1KCCBnfzkf5AhtOgZHbdSUQ==
X-Google-Smtp-Source: AGHT+IEuo6xaqIABZcTJ/AY4HFbxdZ3CAT0b3T807lmpaRovzDFMVVkpiUz/KiBR8yrsIvUCLLc9/A==
X-Received: by 2002:a05:6512:3e1d:b0:558:f694:a65e with SMTP id 2adb3069b0e04-55b97b41812mr3194986e87.34.1754404009682;
        Tue, 05 Aug 2025 07:26:49 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:49 -0700 (PDT)
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
Subject: [PATCH v4 9/9] kasan/riscv: call kasan_init_generic in kasan_init
Date: Tue,  5 Aug 2025 19:26:22 +0500
Message-Id: <20250805142622.560992-10-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250805142622.560992-1-snovitoll@gmail.com>
References: <20250805142622.560992-1-snovitoll@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84CB3140013
X-Stat-Signature: fkw4kbxhgarahswgzfxnmmgzhr17u11t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754404011-86211
X-HE-Meta: U2FsdGVkX19vIKm0HZvgnnzZLRlt6lJvEQ7IHUhP5s0nokrqlsTPfuc/w3BgEZsQa3T5KqaNqpfp9CO5J18oCchZOXF7+DT5p3zJJHkcGQKfV+T+V2NbJ4ynl/0Y1reAyMYFID9cx6yRsfH71fBm+qsPrVM+uocpSpnAKcnsHLdFZksggEKeCtxjD0bEDpYx8pM7R+1lqu4Rje8d5ZqZS7Bk+FnZ+JlsdcdBLvwNBko8NT6Swh/26Jo+d2Zhiys2UCiK/Eqy6/fjR/qFL3aeR/VSJOCbbr1AmfNcR4zyWFPMiorAKyCIfNOEI91bTn91UF6Tcnayy/7Ye9Ui68OsbbHxmdxWUkDbe1v5/qhXyP0HY90AppzHseVpI+ekUODjqUp+e4xSGHM7i6SF37w6oB547K5UOWv8xTZPumwfCXT6VSaoDLY0eZxvOUy1TVfFvu1PcFTdkVO6nDKrgxJs/1J16slVmSTRBGCaC4KTTI8QTBUW2c7zeUEdTD/T2IKBZUlNNwXciz1ck3E7PsUj+tTYxt6RCrBKTaOvqp4MCTj9flJNQWFGXU8jtyth+5k1OwnOazlCNQTeg7iadzhxuFMIwGupIt+TQ06JGL20IHToOdK7vfUCIbgT2d1XKll+wm5eYSrKlbiGfPiCR7FSlbQLlJLR5XjO3Zt65RXsxQkwXfKKm5RBBUyULYDHYzL4YmSwzuuS/p01dJXV+tEtY6IMCZoRC6sZod9j1fchntsAEw4y5DOBNLSZSNK5aVoUw47Kq7r6HSEoNLz+1v0HlyGvlwE06zmuZ3KkACU+oiULOG5dXSTFWsC7YzcDOI0sxqgNuOhVp5b96G78LJEycKFXwcZtqylgPlCCL5RL0LDJsLnnKdsaNBmwcbUi+PFhorCb4pWwhSYTL9QRQW7ff9pHhzgquyKGId0dFfm5Rc7eMQ3zAKWSVXwEWlfkKTAjB+fHE81cTtYX6m3RKJA
 4XNfbfjR
 MF4/Z7rskwtzyCaWHUm7NZSjTVTXVbM6iIaF95B3mCUu4vQiLSEKjwZuMF5EuhC6HFI9twQUWFA+JU/4urlWif1EjJYq+OktgaU4Mb+6Yl7Nf/gWRnmdy7b5k7ZQVePy7vJVv/2zJMGI/QRT3QBZ+Ax3Con3MRPDLwyqrrKxlrIPXFojBblUVtzBuHhtzr69TL5oXmoHuU1lEKEVD9y2JbX69D819Fjv9++rpsR//qjoTuYHocSWXCLtoAs+z/NUsskDrOUdyTdZsWkNB7g4SY70BvGE6qRNbSiBM3s/o5NHmmg+Aa/WI9zWU8g/bseL+sRCyvSecyzimIZGU8HRCioDnsnwkQ9wJiPWcRqvHMl3W5/SeZHs012apSqpxStc1MwSxqaQ4YLzQO5KH/1ktHkIw8BSi3eck7xBfsaCRcLz20qfQoXs6XRz8NKdGcsN4ebcQmtfAlTSHdxjfWJc+s6wsJDkRDlQoIw3KzcgL9Xrpwjl4MjF0kPges5Vfx3WcNG5hszDf400ARakJoJyJ16VsXYx6sOTd9BtttBRFvrBtCgEzBKYJqPukrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call kasan_init_generic() which handles Generic KASAN initialization
and prints the banner. Since riscv doesn't select ARCH_DEFER_KASAN,
kasan_enable() will be a no-op, and kasan_enabled() will return
IS_ENABLED(CONFIG_KASAN) for optimal compile-time behavior.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 arch/riscv/mm/kasan_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 41c635d6aca..ba2709b1eec 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -530,6 +530,7 @@ void __init kasan_init(void)
 
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
+	kasan_init_generic();
 
 	csr_write(CSR_SATP, PFN_DOWN(__pa(swapper_pg_dir)) | satp_mode);
 	local_flush_tlb_all();
-- 
2.34.1


