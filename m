Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E55FC53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 04:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3386B0093; Wed, 29 Jul 2026 00:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27A7D6B0095; Wed, 29 Jul 2026 00:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A7A66B0096; Wed, 29 Jul 2026 00:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE5396B0093
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:58:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 604461A05C8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:58:01 +0000 (UTC)
X-FDA: 85040607162.14.8AF1E05
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 893FA100007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 04:57:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UZ12UwoB;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785301079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GX6ZQNuH3dxPli3WpAJMtLnJrmTWVzHw28ifTrGxnhc=;
	b=15w1tnqu731C+QrlgiMpRepm4PGRV91DbTx29Ug/qPV8dkee2WZrwpSeuSpXFG6gjbeoEq
	xp9ht+UKnsVMrWoCnsFLEEbpIdfAIXnfRhNya+wOfevZlXijtxc7+79wIv5nmgWUNALFQc
	AHid0lPVhl7/tJg8Z5cXhw3kCQEgKPg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UZ12UwoB;
	spf=pass (imf05.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785301079;
	b=51cM3MqRaQ0onFi5kV+20nyomJ8ZTvvbJHp91bf3pHnSOk/T2VaTmzebw66phaC6YcjWWr
	rm60Vrxts7q696UxJeTtPSfXVBoBlWLnEevpqkfJj5brv52vM+hP8lpWrkJOIUZ91agDdh
	HeMWCLwWaGl2VmK6Zqu3+xS7zcl/7Yk=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84a2c90e383so1379217b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785301078; x=1785905878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GX6ZQNuH3dxPli3WpAJMtLnJrmTWVzHw28ifTrGxnhc=;
        b=UZ12UwoBCAaO5VvH7EFH5hffLLnlVYFhcx2EzIXLCf6fhAv0uPyyPCUIdNi2KXDIu/
         N0HFoTVudgpEaP0IEBGdSNttYa1S9lkgq/YY1BLcvj0zwsNbwSV1LF1LV/+ry3Pdgprt
         gzyb+ffwX5Cfzl5LjIswqEj4QTXZkJoIQMEzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785301078; x=1785905878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GX6ZQNuH3dxPli3WpAJMtLnJrmTWVzHw28ifTrGxnhc=;
        b=HFq3GFAsbgGIu14s7omUfP1G2/KEW2tYx/T/HD+9dtzJK/7VUv1fMOzWjKsRWHviuj
         w9CRS1ZZ9Fbq+s8xb2QtSy0EZ5yVzg57sFFc/emWNPuWVfywzDrCCw7N6jI16m4WNgcr
         32H92uIiKy/SB1p+gk+xCmLePrLtc4NtjZw8+tKoh5Jy6J1n+Nlo5JNhHbxTv/Bkmqt9
         vef6dzwsa1hQcL/VCeK3ndc5gGhqtNmrOftHoHusm9ppoyP+Nl8Z5/XDAs1rfLLgd0Bo
         S9MsE19l1opbA1v/eDUne+uz35KXMiSmwXeK74G9taf/csphTcuaEpvTDMyh2mZqj98Q
         5qbw==
X-Forwarded-Encrypted: i=1; AHgh+RpaAExy9iighrV20TovoefTvBWlJHTqkbVxkTbaRlUTYaAhot69R8WHxWSD0ANkBf7QnBUVM0zcRA==@kvack.org
X-Gm-Message-State: AOJu0YzJErnLy8qYkyMrKEuTkaNNzJuWN/bo37ySGDSjCc2n72aW+zyN
	KkDT254VOmV9XVQq1q1eHrUAnH+Uq/QCQaLm5JjUxX+tVlTH6xI6S3cU9avmSV0JTw==
X-Gm-Gg: AR+sD12enjBg8jlDxTc7KkczlCPoWcyehZ7Emk0ML2/0NMT9EDFOIIZbDjYKahJAahU
	AoqwvQSOMIjrNYBoB3y7F7AnWAt0VGRSPN265/0XrEXnPl3iaeLhF/bYArHNGsVKGZDM+0flb+P
	FsW/3kc0IWKRHosBE9J0/piQhGTDxy8G7tcsiFYdwvGI8aPNiUZpOlKAllZtH79KcxDjt2WAANA
	e/4zANN2RWSUpUiuhvnCwHHoKHGVSAB08iKK293lBQxKbgnYJ+Ye/ehV6xzDddwL11rnFqwQavT
	uNM9Bd40PRE1fmQAMK8+f1Ki10F6BZtIx7MCfsI1FOD0xf0QKDmd+5CqJeNOY4KX8N95c4iy14V
	f8o7B4OIonv6+N9jIDrWdSzLputZVYCG18V2zjdUtz3U5a0J6aq2RT80TM3eI+tJg9Ge61B5nFn
	NBs5pEjDwnJgplA1oOaUMZiBDs8tss4r3YUu0OYbt41MqVl65AEB6WycW6cSeWgH8590W+gEX2Q
	QI7cAn02+zxMi1B+YebL5MUfyWvCmBhQaYZ/EsFVvLUYDnZGMg=
X-Received: by 2002:a05:6a21:494:b0:3c4:2c6a:6143 with SMTP id adf61e73a8af0-3c8e47d990emr911497637.33.1785301078465;
        Tue, 28 Jul 2026 21:57:58 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:65c1:52a3:f6d3:37dc])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba63c743sm335183a12.26.2026.07.28.21.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 21:57:57 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] zram: validate deflate params
Date: Wed, 29 Jul 2026 13:57:36 +0900
Message-ID: <20260729045745.775973-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729045745.775973-1-senozhatsky@chromium.org>
References: <20260729045745.775973-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 893FA100007
X-Stat-Signature: fccqk986tajqek5zooqwxtgnpx6e88u5
X-HE-Tag: 1785301079-206916
X-HE-Meta: U2FsdGVkX18uMdnx4Zcbxb9PCwAtEa1l4kGbGeYe7uKuSRqlFwy3SywmHNMk/gUIzN/pi1UZMH3Vnw00S9Bknml2JlB6G1L3KcwGgcIb6VkCs4wElxAvTkRcwYn+FMqdtRxj+0LFfHXRN1XunTMqKHFIbc0cLEPZy8vEhIA04m5faIansa3UlmX2R+kJqcSWjtwdhnZUDOEHw9Vk46SxsDFX9JbnsdIXmnoFBA5g4R54Dugh4Lo3niSn/OxKPNuzoYNMe3733B9AqKsCI1t00yqVqKxcCmwof1bJM/e1S8L/3UvYaBZY2HVf9qSxJHmVfD1GWaXJ5cFCIucHYOi1dMq+t5x4hBsdPuTTtK3CyrQ08N9F8wkCe3KmHVJlyYpb3SVAmKrTxn7/fZxogoIoC1TRRpK2l/8B4+PXdfxxc581hKarYPoGxvbO7xGTAWluQQ/vlT3LqwmzB7fmPliTeUcmXPRdR3S/XpKTrKCQMq0GjSvLw3ER7JuRNZxlfkVF1mDNL3rxqPK6FDXYEjzwH1VKy3cli+QdZMoF918ijZ6/sKzVKk/s46U7i0KZaA3d182Uko3KQqB1x2OblOBLieSwwfJ+UM4+IEgKYErmO/CXcRH/P0yjfrpfIEVfgew4j5pl6lyBr4C0YLih2Ms8EF+QfwKULaY9i76d90HztDiHuybLMxQJRW/wIEcuzmRcVI7UMq2NvrvJl9j0Wa6nfFClffyMu8dYhIzfSzlPM8WT7DIlsniiYF68ltxdQyf6tLZemYfu1W3qBP8uSTeWbyDrxqIgE3/rYQcg3Ij4+kEeA+XNaYD34Y+8Ipkz4aCwq9iCMtmFu1HWqRmIzKXKuC25tipIK1644rl4uAr0y8Nb6iwBUKrdVrhpOIZ+innWBp8h4kG8OcgSVs442G1DyZCxKv3bv/7dLgSUBhYnAXTkMaVoFRKKUyn4fA8l6KqgmYkCFDpyo2lg9fn5O1A
 sjmEdcsI
 BGwwkn/HMh5/hXZHH7zLoFPois9+T7Qb03m7bZ4vQJVJnn8v9Rz/Oo8Qhek9uMaQk1K79mmbw5WPqSYPc/TJDR//apjFU30kR4J04rADaWy9nyixmi7CdoGgCv9izXtfKIwKcWSuXGK4DazP6U7j6SJNmVOSVCtTJVi2lycFMr52y7jRBjZIDdQgk9ojNgAWmcP49Jsf7yXwla18sRMgavZkDNfGDfy8gfz7wD1XyykRcVnv89U69S7avirmP3f/dI/v3i7fcJm7nwVAY5taV7/e12Ni7lfiI4IaZlrsGuLKchJWHANJpFqDSX5LUxHQV8+tO2pzd3GUk9Hg7d0BDw/UP2h3lcepQ6B6TRP2EyDg6UQolw+hDxixc3+RXsfTZe7HArPmZ/hC/KarlU0yMEDBM7D8W+6TxTb8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We must validate user-supplied deflate winbits before we
pass it to zlib_deflate_workspacesize(), which triggers
BUG_ON() if winbits value is outside of valid ranges.

Fixes: dc75a0d93bd5 ("zram: support deflate-specific params")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_deflate.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/backend_deflate.c b/drivers/block/zram/backend_deflate.c
index f92a52a720d1..b3f7d08b49d9 100644
--- a/drivers/block/zram/backend_deflate.c
+++ b/drivers/block/zram/backend_deflate.c
@@ -24,8 +24,16 @@ static int deflate_setup_params(struct zcomp_params *params)
 {
 	if (params->level == ZCOMP_PARAM_NOT_SET)
 		params->level = Z_DEFAULT_COMPRESSION;
-	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET)
+	if (params->deflate.winbits == ZCOMP_PARAM_NOT_SET) {
 		params->deflate.winbits = DEFLATE_DEF_WINBITS;
+	} else {
+		s32 wb = params->deflate.winbits;
+
+		if ((wb < -15 || wb > -9) && (wb < 9 || wb > 15)) {
+			pr_err("invalid deflate winbits: %d\n", wb);
+			return -EINVAL;
+		}
+	}
 
 	return 0;
 }
-- 
2.55.0.508.g3f0d502094-goog


