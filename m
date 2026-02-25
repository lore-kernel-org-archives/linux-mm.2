Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FB4F4BB9F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691FE6B00B9; Wed, 25 Feb 2026 06:05:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6669B6B00BA; Wed, 25 Feb 2026 06:05:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513CD6B00BB; Wed, 25 Feb 2026 06:05:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4E36B00B9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E8D341A0550
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:32 +0000 (UTC)
X-FDA: 84482698104.27.EA42D88
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 31471140015
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kplBmSnN;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmnNCbfSwbXJVlcc7ToRrddmEn5JYiYLNZaSrZR850Y=;
	b=onCXlimzz/Tf3+OKPKSOMEfGCSjpzhNLNm5TM7tblr5nmeJuX+t6uJcQFNXbNnjue4F9sk
	Nlf2svmxFJZjzePJzgKnrIqBVOYexmo/eLOYe9BN8Rwwa5CDkDzNGKoAb/z/S3nS5ikND7
	m4KtBI+OsMNFp+OLBOwzaIOU3oYUJ4A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kplBmSnN;
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017531; a=rsa-sha256;
	cv=none;
	b=yPBYIm8GAmPQ/EtqLVdGKkwODIdjB2/4tEI+jQvQkPCg+954ymQJ5loGFnVWudnyiC8TIa
	fBvD9CZFWU+Se7c4vO4Yz5E/fHFdu07zs8nabWzPnrxOr2gyRuUUiiANB6A6ffV+3VD3Jq
	ImThCoUv7QSHneecyqVDHyEs/lW34Y8=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ab077e3f32so26162685ad.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017530; x=1772622330; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmnNCbfSwbXJVlcc7ToRrddmEn5JYiYLNZaSrZR850Y=;
        b=kplBmSnNtIwpoKCClZJH2XAJrgiL+ZhcaUQvfea75i70jORd8HR/5wmqhe4FPG+/Vd
         qGxdAIa0NG96uNTx6fi6aSd3gxvYk0E233CIFZDiJD57jNnPxh+6wl0UUYxjJ+e8XHdn
         AuP2rmpfAprGKw83aoaFpcoV3tsvDQBjLHDuh0cyLFmehIYoY45s6tmBJm8tp7XB9ZS+
         15khWa88gkAbCWYidEywovI9863FO/OARUkrxpt2UO14vRLfDum+sYXdpJotVsyeQ1F3
         had8N9VG1q9sQMqPX5M5SD1O6tSkoIQ8rpibXCHYPKg2dgZ3MPBbpIvRIRDvpEkXqXRv
         8x0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017530; x=1772622330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MmnNCbfSwbXJVlcc7ToRrddmEn5JYiYLNZaSrZR850Y=;
        b=HuYSXnFxzI2Z8KYcxR5q6fede1TZqQff61Rwe9Kdii1/nlgcJVSBMLESJRY4zqFzi+
         vuCxPss4lHaeez0pz4ZBpCWu91Jd5AeP7KOF214HO+Fyg8SO2EWMwnLJ3Cn8dOV+f1eJ
         O6dhmCbYxztRJOdacr2opP6Q59uZytIQ1M3upQ7aULNZQgE1+U4sHqZwdP/hHAhCgmZ2
         /MWLhuiRKkGRwFuMBuy0oTdRZObGv0Nh9WYWNdPxE/zDZ+t9CoTLyL3OWQ0nBCIZc7e7
         Xfyx3jLKShZVRHFQmdlkqoeyRSfG/FPyRzjaCOUfplVP4z4UxlrNLyNpCdfqIecByuWk
         vZLw==
X-Gm-Message-State: AOJu0YwMsT2V9GFMgnlcWg5tPSUC2nR7vqSWBUscklhP9K+ib/wK5ppb
	Md24fN88gMpE6E5PGgqma/eGac+0bIsKSxVlRxc76NxrB1UvYH34+B1z
X-Gm-Gg: ATEYQzxrnq6S6kwXcpBIu9mJ+lee+cmNDy4r6h9vVwpF+66cpXWIrL3/uEj+upLayaq
	NaF4mA6B0fdsLlC47xXDVsUVJaGamnU6Yxrmx5DAoghDSeTEIS4YiiefTonaopDP94Xjs4lUveE
	eVzYUQSrdbJAo8fJQU5wjCsRtzSFQtwsXwXyDP4nb9G76qNgrUfEZ9mUw5J0pi7xlLyLR7rdb51
	O5Xku/zLKsIH3q4pkoHjuZaD/Vu17qsnRW7TyODoEw0pNKKCPznnxesXUPPa9gaTSVFXJHp+E9v
	eTrVn3KVrxDYnmpXoK+VsKI8OBFi+7u/uXI0Cmnf6E08bdfGkPl+hgkPj9d+QssMiTOfCK+b58n
	/bBmB9ldjUDj2m8AzAJgeEbhBQCubXRCNLVKb9i+e6aFwNKvALPa+hOpE+M2D6tyHoEBy03lBPB
	4VkiuFCwrlkW3mslfGSTVyl2JS9TIqnSQ=
X-Received: by 2002:a17:903:3c0c:b0:2a0:8e35:969d with SMTP id d9443c01a7336-2add13bda24mr20779715ad.39.1772017530108;
        Wed, 25 Feb 2026 03:05:30 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:05:29 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 10/10] powerpc: Add MMU_FTRS_POSSIBLE & MMU_FTRS_ALWAYS
Date: Wed, 25 Feb 2026 16:34:31 +0530
Message-ID: <c57b1c00145a2db1a1b4feec94cfc2917e4877af.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9z78h98ppwkmx496zm33nfhfeozqxpx5
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 31471140015
X-HE-Tag: 1772017531-971134
X-HE-Meta: U2FsdGVkX1/+CoJp1PFCaptqwpRO356YJC3VkYdrEVDVVN2EdvRlZISVtl4g7K1zXWiKviRksBe14VL+vQZQawtBTYbe+rhNtIqkjc6RnB0KtGx6FlT5DC6OYVUrJBRS8AQ62pfwD5YfOux7k4FdLEhW8ED7CeXlCOl6l5NrERc5jRm9PuPdygXGi5RxvON7lMMJpvQM5iayH9au64QLVU4Znw2/x0FvzMXIcUwysQDW7UmG4wGm8QjcJQQ5BMJfLrwK9EqHL95Dwkf5gRVr6Rk4ZLzcQF0MeTe5uwD5fbjaJKoHbybQkaKhdI70lnwexBgGRsz8Zh+HIXS6X3yxYEG3qw/OPTXnFwOEb+LPVZ6G1m9yanz5Qn4WPFygGC2+28aqFYUHpLhieH/wUDs5sVDy7jUMKQ0oKfaBGJArlUFjk61CPcX2L2eMEni2/XdTgcIyOIiv2STZTLJ3x0Ia6c0ze2eRREENuqlWLPoljjdhHh2/B7FpAzhHAaghJElhlNIALr8teJZSNcwa1RrCW/+ZMM5CVL2j3UbMR6vvYccXu7Qqw2sHB+W10uDz8Kl63Cvklm6uaJ2XPmJo1HVz0SWBKjzzjw8J1cRlelVZXuAx5ehHiWbHFwP2hD62D7llCe0aPuKQLDieDPl1DQ8YcLe07ta55f+FxfdTLz5j3QpO5AAZloAEt6m70mJr9yZy6p9DkwtYx8vZXtypxqLDzbYulsPgblJ0FFfbR2PqZkxj8EdW6Zdrh0CdAuPkEH9X07NC9PdmJhiJnCh8zUTYt64TdktpPD2LBsSm9MFTLxbGRiTtp2ETVgA2oytFO6OLF0RD4uVFysY5h7jRGIrjMzZl97tGr1QcKBCeGtyXSHNPesld/5IYpdTlrSRI4fTR5FBaYpTJ9p4qZn58uX2OcDmNIyOJM1DO4kE4dEvJqHPJSn7eaDoI9jZqhxmrdrktY4PESJfMtKTTDjG84dY
 Z0LWVI98
 cNHI4VM5vBOTHcRO3O4ygkWl/5lrPZwenE2rIe/BRuAx8F/IkuGbCpvCZGJadNzY3QCcAnJd6JruQV2fdBrJKa5CfJMbHU7eHHtA8rJxicg0iuph765FjUaS0hgap11QiX9r00WYcu/3WH+RC7cv+OS9FyZ602QX40WIWvVsNNBKpcLibJoRSoDIK2pqF/ATi795gimhKsy/Fwfx5sgjIYMZSjjWJi/edq4emcJl/Bk46LbB7dVL/mkVCNiuvDjIiAfQzmmbIwosCr5dnZd1meRYx3epSKOqtB1kQhJ01B56hndVQJWPYdoOo9xKS9W1YaRXq5ARFoLiS6xI0dCHD+iHKd8b6QCw5dV+o/Ot3yrDCTUVisow2F8WSueZfSpVbiQ1ZpookPYSiV44Q6m3WUJog9JsEWqvCEGNVUezU7OP8PSPECoT7V6sHQErxnEl09dXgeypGK5ISjBmVjuHUP2nZc0IW2laIMbuXPOwqKOKrGlpXQSNo7PKQM0+ZDn+XOZvjqu7UxWZ9Z6K+5VcrmCbw5wKHqK/56or844qnQcHPGpR3yy6w4Qy8+Z0VrJ8fBOBVCEiIhrc8UDOAWAY3BJv4CaRVNR6uoxtgV+beC6M37/JOIDJaG2I9EFUYn9t9W0gFB3E8S21L3bM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to CPU_FTRS_[POSSIBLE|ALWAYS], let's also print
MMU_FTRS_[ALWAYS|ALWAYS]. This has some useful data to capture during
bootup.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/kernel/setup-common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index cb5b73adc250..002b312eb7e9 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -866,6 +866,10 @@ static __init void print_system_info(void)
 		cur_cpu_spec->cpu_user_features,
 		cur_cpu_spec->cpu_user_features2);
 	pr_info("mmu_features      = 0x%08x\n", cur_cpu_spec->mmu_features);
+	pr_info("  possible        = 0x%016lx\n",
+		(unsigned long)MMU_FTRS_POSSIBLE);
+	pr_info("  always          = 0x%016lx\n",
+		(unsigned long)MMU_FTRS_ALWAYS);
 #ifdef CONFIG_PPC64
 	pr_info("firmware_features = 0x%016lx\n", powerpc_firmware_features);
 #ifdef CONFIG_PPC_BOOK3S
--
2.53.0


