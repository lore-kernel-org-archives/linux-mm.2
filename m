Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2167DCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46308E00FE; Tue, 26 Aug 2025 15:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7C68E00FB; Tue, 26 Aug 2025 15:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8982B8E00FE; Tue, 26 Aug 2025 15:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA1B8E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:34:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2FF29B8253
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:03 +0000 (UTC)
X-FDA: 83819909166.04.BCEB21A
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F73F100009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jrx05mXf;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
	b=4eyxonYSeUGZDL9VR94DNQZWQ14kRExra01nTs+ILZHKb0Np2hk1Vv8p8DH7lJFdKWXr08
	yhkHURMBBCMeV9CI88QuvU5WUQcOmcvYYXqQ1sEXUD0d0xRK6EdaR9qH/aA/rE0s4OEuCI
	FyxgJusTSchv/oI8LxaXbcrHbQAJ2RA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jrx05mXf;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236841; a=rsa-sha256;
	cv=none;
	b=lg6HqIOwNESKxMFiYsqQaAkAy1IzDgeUaUzVGSwXKJlSVPpThqlBVtmckRHM2OdrqzY9R+
	SEUbRt/teNGhy2RcJRcERwAjEvkU8KY690lDSOkkRrPRw4iMC6A6KKt0jhOGCofES+Xh87
	1CzbSIHCt/P2mEUxDYlKeit5bcqEWdk=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-770d7dafacdso3057670b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236840; x=1756841640; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
        b=jrx05mXflq1piwBH8lYnK+ZKuAEHTux4LzMSIS6V3faWjE2wc2wj1fWjgkTVhHeRfs
         lwIOCGZIAPKolqb0D5A0cQ4NlKw52V1FIUys9R8HPO0u9SGXhIZJ5MBSamQurcfEJ/26
         E+FU6poOljZ2UpWcvZGn0wA8rPQF4pNLPiEm4gMzut3tKxdPpm0mLfHC9yZxgTcazTEg
         wr6bCA2T5xTYVaNgG7cw5uA3uf+e7ZLoupcmv2vUQu5M35SNZHSnVCHHgF+SVdHKgE8f
         HV2aXXeyoFypLuFIJbARtIsYv9Y9LE7iPxJOyjv+Xyk5QG+rHE3Nn1mBKfSSU6bq9oll
         7c0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236840; x=1756841640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tE4h8lAMatl8zOgx47ZsHYZprqFSGIay3bVnFsp5zpE=;
        b=BFwp0PY3Qq0joiA8ffsoV6NCFAmrhIdT+AY2A7R42ct7Mq7XNGaF7cCvHnuRGmCBqM
         OmEb3DObuHK8Az9KPT1XOdjGNjyLuGjJHYbqNqTdqF1NETg8s/pB0c6XaTsqY2Dh0IRF
         MIy2aeijQVESdeYnMDNOAD/lZQ1GpLP7ecP1y0wyt1V3XPgNhwbUWj8w79XIpDdNNd24
         fZCwLExB6418cXCvg/+9I5bXS1w9Qt3TR18sY7K6ds0E5J5DQevicvzzDui708imByM9
         CG9hEly6CwFlrtp+0u0vF2hr53ejSgxHNL1SNmTbeTmsnw4ob0QoGbLFy452cWuJ6u+y
         9tUw==
X-Gm-Message-State: AOJu0YwS2zNnhTfVBFH3jQyAak8cq1CjaHqZEj3i35Gm4i2T9QpE4hqm
	/P7O2ry77sk8lElM3FYygW+ZzU3hOonOgxrcCFD85OEOF1UrP4cP4yeFmuhU8A==
X-Gm-Gg: ASbGncv862atxSmdzTURE451cyR/zRaMME65Zy6yfyZivbOi7khbrVKRiXlpsz07zfP
	bpvtIyWkz6jH/FHurbqSJGg6wH9f1n4R8TTTupIsf+s9pJe6podcJnTKH0LeHB8zxiRsX5aDAnX
	yfdHPHQfNLIxNpqXr+YyWnHhTqFX2dBhJX3YmFHFExcwzh7uuCkPnd1cGID10TZYzYNx43jk/8f
	AE9QQpRfpkh9k7C+8BlGLyMtzfP8mhI4yAhzvSXIVCC3qA9C6JoQv3+xYNQWh3wF/pIJEpAPaqv
	PSEUPZnoenLdAJHmATNueTy9F6KprVeamSyoh+eUFQe55P/ALIhFtilHNdPPUpx2TVidYYLTXOY
	YlDk1eY5xrxt32ZsRY7Rg0A7ao18y0a64H87t4oEdRxWotvPHTG679w==
X-Google-Smtp-Source: AGHT+IEt51Fm84l0Nhom4aT3TpUwGphsXYN6NCk7M5kBdV97xqhaPC/zdbIbDC37KHt+mBDSbo30wg==
X-Received: by 2002:a05:6a20:729a:b0:240:a53:79fc with SMTP id adf61e73a8af0-24340d15c16mr25501499637.29.1756236839809;
        Tue, 26 Aug 2025 12:33:59 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:33:59 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 4/7] riscv: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 12:32:55 -0700
Message-ID: <20250826193258.902608-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826193258.902608-1-vishal.moola@gmail.com>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F73F100009
X-Rspam-User: 
X-Stat-Signature: sunnibi8nusbuc77jgzcr4eh66ubmgqp
X-Rspamd-Server: rspam09
X-HE-Tag: 1756236841-913434
X-HE-Meta: U2FsdGVkX19iaOeQWAWaHxmeJl0xlVL2vfM2tSJX+PNqE0Ohl1TLBKGjb0MxYKlgeypDuVND8v0NPJO0sSw7+9JD3TWNJQh084KJSryAd3EWxsHAk+zAOBfLB6BDLloWfbSOLrOwipa3RgVw2X7th/SN/2xf1ODdZdQB4sMaNmnP9UvYOGj+7ddtOLveyH7dmV9Hj64n/1dss1XAgwNXmnxN3PntgH9yKutZvfiw5kkFGgaqhnIYJ+VDMINB3ibHmMr+0ihjzn/pSgXu23vCXJ8RxlyCBSibs93Osxyfuh6XLa4XUjkVQnp+PeOoKo6WGNQ9gjTlwFYK+QEQqtdaeI8/PeYmHgYhU0y/ZCFdelXONUucRJPYGFi4B2mh7UVqdOXasIWzhdN7MEWd+SxgOt9bsX46C8mThCPFSrLtCP/sBc9X2b7LIQDgn5OTV14eNxw1nWGFD0JpzNHuvQTDBcCAgptQhsjr0fin0RNftP2DJZyAtP5r/mI1/3oI/3dymHeBTE/Lhit8A3b3OiJS74edZPn/DjpLIPf2dt7UKIrS/AJHgfxvC/DAnAV5YIpecVWt7s/3yMnVVvtFOedqUVElWIpPTsgV7Asr+xHI8KLTMEss5WhT/8ZHU4kmQifsFF11Py0XZ5NVIGDiMpS2sDtTCdd/4ybLi/7JTrfzs3nttr3cqoQyEoX64PfdhGLQMdeUKO4i8ekQ+r2Qrg8KngMCieWFkJ/dUNSC5TAmXMc07UzVPOPie5TmbeWVr/Ui5HuGEelG5H2hQiqqFqq1/YLZ0PDhrpVh244y7qUyLt8TIyzzr6mXiWzlhKlxoa4oc+0N+kWR+w3OuIOpss0OK1CR+d6gAnF0+ZlyTLpriOTOXC29CGmWRs1Ie5qmoB8LRr3XRO9k2hbIadTNmngkG+fvwxVLF5I6CqWQG+/8SSrTKE2qtoTgJSb0iMU3w09W1LHvFPu1i5OLRLD1xEQ
 mPAQ5IzU
 tr8ZYY0T4qg9H0qynMUzUhMZ4lBtaDaowzyEfWY5pecQ18ajvSL+S8dh/lSU3fmprqd2Dzms6JHC+VtlFzd1BTcBoEHWqano24UpVcsPCmdQya1SHSawomNvjjgvHvCc8WuW2+6nlb2CHg3RNQVH5lMGvhh3JvjQyTFw3uLXOTu2Q5hPPPBmEFqhX+nMqDWa3IgAGUY+MZTnI+IFxfqkIlZZyRig7LhTN+GQNwYya1x8dZztGkq74lbXDnJFjb421GLHdGI2wS7fuTj63NF2GDB1Y8z0eM+NmEzkmL5VpojP8viOnup3nmtjEhRgvmwSU+DcPaYxb4GOdI8T0rYkBulygEQjouRB8Ko6l/rqCYVnunt+sFebEOfefnOUrnZu7X+dSQNCZc6d0oNVvXyrzBOIUoe5AYXgiNOXKOqUuMOKUaZ4fVAGhCdB3lCRlplLyV9AR0Tn5aVI7chGcH2UhnCBMjsxohe0NgkOeEgJX4QWdeYyYozKiq0068YSRtLRQPJ+FOms1t7OpS67d7c1/bqzdnwdyX7JYJmBKbfg7iP9PymzGXh+oAIwEGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/riscv/mm/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 15683ae13fa5..1056c11d3251 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1624,7 +1624,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 	if (PageReserved(page))
 		free_reserved_page(page);
 	else
-		free_pages((unsigned long)page_address(page), 0);
+		__free_pages(page, 0);
 	p4d_clear(p4d);
 }
 
@@ -1646,7 +1646,7 @@ static void __meminit free_vmemmap_storage(struct page *page, size_t size,
 		return;
 	}
 
-	free_pages((unsigned long)page_address(page), order);
+	__free_pages(page, order);
 }
 
 static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, unsigned long end,
-- 
2.51.0


