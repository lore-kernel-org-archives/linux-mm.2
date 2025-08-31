Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C226CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 02:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57B36B0010; Sat, 30 Aug 2025 22:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07E46B0011; Sat, 30 Aug 2025 22:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D5E6B0012; Sat, 30 Aug 2025 22:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 803E86B0010
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 22:27:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 027A8139F1A
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:27:08 +0000 (UTC)
X-FDA: 83835465378.30.A18C1FE
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 458FA20004
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:27:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DO2BitIY;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756607227; a=rsa-sha256;
	cv=none;
	b=TV+m+wslTzjL2K1NcdpRxPLyf3CEdicLFIZGjNESaJaowpXuaG/r5gXO7qm6P4IrfpXahb
	lxyVKFQFhwpETE/PquGTlgTx7ak5Hcj+cXolC4qmD20pLEfWmfpMePKJ6BwaFIgP2Dhwze
	v3Q2o0AT5Ak7EnGVh5F1J0NTQSlV/mA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DO2BitIY;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756607227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Qx5oAXDKVN11+SqKhk6XnmijMtN6s+BtalzbMhItzec=;
	b=pzheHKAhpkAWexcz2tTlPb14pfipMQxeVkPYciJOTVVXmkxC+W0M55VeW1lNKIgIbdpW5S
	mTUfae5GodpDsy0Kid1lq7Gt4XqjC0AVKuEAGUTT4FzjHQaF/QJfK9fT2GcF6/8qFyM/3l
	tImidQYv2pTaa3aI4IvxX7EjA4n1BHI=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-61cd1046d42so4000573a12.3
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 19:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756607226; x=1757212026; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qx5oAXDKVN11+SqKhk6XnmijMtN6s+BtalzbMhItzec=;
        b=DO2BitIY9Yi9eQJ3kB6h/aZVo6zRtGfJzqPuXH4fYXGMpc218bNlPEwZ8v+Z60pDjt
         SnQPLPdCA7jMQXoG77k4BEin616wssZWU/lrAcLBYQEP1/cr7bL1d7PvemZzhOqw7W/8
         eZGD3fE0FyblvzJ+clokKsRdWZmrCnJCJ5ppQbEGOysMn30NBygZJbCTdZCl/ad3+lGk
         1tysF3ptex1GTFCGpBNHZ3BYrAkJpwtjpblZFbr0VggBhKXmRz7mw/cULK2ysQqrX3Fh
         8g50d0TTOB7+OI5dDzSAA0QeQZaQZGXNU+ftNm5uJ4sAROeqs5a1KDmtIdfiwDRJ8X1S
         JHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756607226; x=1757212026;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qx5oAXDKVN11+SqKhk6XnmijMtN6s+BtalzbMhItzec=;
        b=edE//+7lUm6fPuvKbo2WDFSD+9mArLL/ab91PJ2x3nxRjKdFFpfGkPOB3maUiKNgPV
         eiCXljl4scYeE5p9Ea1L25qTnyHo450t52YqSSz2BDOIVr1TGUXCCPnsc/fiS3eB5EMD
         0bHDFj71RJdZ8x6fD+kDmv/4MbPg+lKmcMb7gAEsdgHNt/ObIR+9EZ38159CNzclxWPP
         fFrbiQRk8UmnOJQ9GzlBOXj8RWYzk4lU5uj+36VOJ9s1vsFhGPJfWrEFVwPa1ThbmDbh
         /dOTZT0K6jZmDDvO6c7xcRCEsZ10GdqvNqJ6VyrFxx70gna9AXkHp8OW+z+QcvKjGhWj
         Jejw==
X-Gm-Message-State: AOJu0YzKMImeIjsixEbMIqySjicGPMmPgAfSj0Fz815bGdRCcWc/JH98
	ayciBbOH0tgDPAHUTJtZKCztXOu5G1Uv6LkRPM7tq/R7yGs3FZYoLwqv
X-Gm-Gg: ASbGncuapG5JsqezwSOctZtf/0c3PooERBeenHh6y1eITVeVX8YPl64podfC3V42Qzj
	zE1U0hEk2fz6WPfYlJ6rs5JAo6PFEwQgTlEZiuDXyKcUsucNrR2E33Qo96cugsVWG6xRBBUUCNJ
	TFayp6iXuwBchrYCZNbhG3GIY6gomtAZXN0pzW6615AGRnKQ2hm1YVLTf+EjQdP9RVnzxGHZtqn
	wj6ydyw3FVJhuNxk0L2ZLLEFnta69yy/it8iBFiDjwhvesO4ww5fCDOBXbhzIgGHSoEnrUakQCF
	GCwup1dqv9VJDJMB8fVrQ5jIBon7iFb53CP75TbGTtdh7nysMdALNQ0ra7Kz2qp5cR5BdfLiPpk
	MTaTRa34o9bvuReL6KugMMiwVZdLedXxWCQVB
X-Google-Smtp-Source: AGHT+IGfcvjO3j3fIFIuIdn+jDiKXtrzcTeW6OXMfOiNJFGbP+eAQpnIa5i6CJs+MOMzNMFoo3pbGQ==
X-Received: by 2002:a05:6402:3228:b0:61c:cbac:f6c with SMTP id 4fb4d7f45d1cf-61d26c33cc1mr4121687a12.23.1756607225676;
        Sat, 30 Aug 2025 19:27:05 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc4bbc6bsm4495215a12.29.2025.08.30.19.27.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Aug 2025 19:27:04 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2] selftests/mm: check content to see whether mremap corrupt data
Date: Sun, 31 Aug 2025 02:27:01 +0000
Message-Id: <20250831022701.2595-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 458FA20004
X-Stat-Signature: x49jxikof35zwoqsrg4awy5rnqrw6fp1
X-Rspam-User: 
X-HE-Tag: 1756607227-277837
X-HE-Meta: U2FsdGVkX1+v3LbYLC7hO6NowO1TroH316tzBxfVDEkSpLcr7tTphTcsUyiraOcMgFLJ+waHLViOOBcEY+YejSCckjthuXmV4NJCu7WNpTT7E0AeRRpJ1sl9Ktkzj9bkcQtNTh+Vx0vWQJNxasFb1B1AMEZZ6XefDmIFV8XOH3xst9jAPsSAY3mg9Xqv6jF4tWwtELMQd62flKD2znF5P/S4uWgJvTyJf2lBW60TookERt0gBy/nJmHw3sGchBk0uiSA4mM0oDKJTvcS2R3scs/zwZ4ZY3QGFyW/AeBdxEEZV/QDIRaSpbLLPQVZ+ksrf+gPWD08yPLbb1a5DP51Enqy3ASfXSbwwjqKGq1HmX3dQvNG7kNkZ0MSq7Iwkv2vuZB9GNxoDPTyNO3z5h/Kr8BI3ajBGPhk8fEFyc6gsr9JWhRMQwuF+PgelZWHv57mJTS5O0XgJj0OWc3BWjgozRZ/LnPoB46Z9IBGsIFNZdDTvkPgxy8dBExXf3ywPRzytov9jSiDgsLql2IOdJCKSKcm7FX87xv79WLLpzf/gJgCtil/1DxzN5ZJdTrdSF1Ywh36YfzKyTCJ7npENEa7h259ptKj27SDpMRNPHQLSMyM5gBXktP6e3dTjE/atoyp7zY7hVhIIjJjTvQtt3vBHfyJTb7UQxvtdCsAJqWevWt6MTt1HbVDUUZk41LYm9p1g0owlHkwjOX1QStwSnuocmLvOYukW2aVFg3wha3vFJXd9m7jAIx/lEt95g55gk3GHg1nP3EwYKX4OtATSHnJj0VMTT5fc/ZPj5FNGjdmAKe2puswsrBkiJ4SFv/R33Cc5PMlsVmIsvd2LwIMAmuMDItisdDV+QoSOYQeSN1SuvzPStMqzhE0RaovJWgdZs1p9iA2Nfdxb2qxUKlKcLfOkX7WqIlv7W9iO0n8Xc2q4mXfzr92H2vkKe+G+rSmLxzC29sStY6auYWD1a6ofZu
 TIMVC601
 tJKumSmEPFAwFdXqxemgRRMA3+h/fnkWbbWPuM/c6qwLadG5RC6P7rdWm8DKaIwBQy8wrZ9PDdDKg5Q372hBQRTO2Cj7zHOpYkxzK9+5i0d1dRb5m/rJQQKUSioHY1UJiloK5N+KOTffXDgbLeLMnekNTx/jttj8Vcj3gTlqQpOorMomPpdVQIenEXQLT3EYoK/sEMV5v8A3e/h5JPXmVDg0V2KF/dbAeH/bgwXj2D5uEjdXBQrHy5QiO8EfznQc73O/TueQf6tmPYWxteT59dmR4GNgqzlz8n7o1QxrTqX50t15gz6Q7srpGrlKlPO0i1rcIKbaPDgD1DDBK9P9A149n1qah1rXVqAqgvTXOa8AnOvA9qVjc1NIUx8VnfmRS6OYdcMIrrzKzL83UEvDb7FxtI1FE/Prqmd/kjxmD0Wqq7VhA1t8mtRGJ9h+QWmOOS0rIv0P80aHfdnCfZ6SGvrqC9D+VVSurYEmalIs665dQjFJrWI5zvZCuAq1kFYQv6qicRNbMtrBT1xU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After mremap(), add a check on content to see whether mremap corrupt
data.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

---
v2: add check on content instead of just test backed folio
---
 tools/testing/selftests/mm/split_huge_page_test.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 10ae65ea032f..229b6dcabece 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -423,10 +423,14 @@ static void split_pte_mapped_thp(void)
 
 	/* smap does not show THPs after mremap, use kpageflags instead */
 	thp_size = 0;
-	for (i = 0; i < pagesize * 4; i++)
+	for (i = 0; i < pagesize * 4; i++) {
+		if (pte_mapped[i] != (char)i)
+			ksft_exit_fail_msg("%ld byte corrupted\n", i);
+
 		if (i % pagesize == 0 &&
 		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpageflags_fd))
 			thp_size++;
+	}
 
 	if (thp_size != 4)
 		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
-- 
2.34.1


