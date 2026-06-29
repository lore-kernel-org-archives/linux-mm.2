Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF9BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDAC6B012D; Mon, 29 Jun 2026 12:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF486B012E; Mon, 29 Jun 2026 12:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D326B0130; Mon, 29 Jun 2026 12:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7636B012D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:54:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7AB61A01C3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:54:01 +0000 (UTC)
X-FDA: 84933547482.25.D4855F2
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2BDA81A000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:54:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qw3bbxsl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782752040;
	b=Um3MHbImqY3wX1QRFY5AgCx1e5SlNWFsh5D+vGBeCY2oRa7PWuxp/sYBSTUGuMCZz10I2w
	42Y1z34LcLO5+0d2fMOlrOpkZ7t+w17KgTFjclGKBT+CYGtBhc8YXjxSIInAEhHfjCMYSk
	b1adddMvWBgQlfWtnoOoq15WSzNy+qs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782752040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=467nTLX0LnAbWRx2UyG//0H8fEY44fM4VWbD3i/nXkM=;
	b=BxJnyi2vJcVdxqKAHlwL7xdDoR6AcH5xtR0smVc169PSM6HBuA1+oXL4PA283PbKLOZwOG
	tRqWSsQDHXXaM76PKIZm3AYjITxPC8BlAueqxlyJiV926kZl7trytSOEQww+T5j8XqdD8c
	+gM07grMghO5p/4tGHHxgIs2yYs0Cfc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qw3bbxsl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of igorpetindev@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=igorpetindev@gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aebba706b3so877329e87.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782752038; x=1783356838; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=467nTLX0LnAbWRx2UyG//0H8fEY44fM4VWbD3i/nXkM=;
        b=qw3bbxslbxzsymTcKvEVdeVoWzfCKuHpvfEmss3d8udjIlnIOvR1Dk2mn0mSATe1t8
         bc6UBy8d5MyhY9NqboMb6OJUvzVzpV2FAtUhB2UTq2lSdHQelEkvsqv6zL2qEn2ugL/x
         +mN5QABC7kPSBVEc5hOCsLeg1mWVFuGg10oyny/dyxoxPjqnwTVDr5BFcy4MR8gHNjlS
         tsPZEql/mDaYpzFLtoJMZS8ww3P/0ALVegE3YRecxX12EB7cX2kT4EHrjls4UBqo6cv9
         /jfH0Cs0ocVRqcppNNY1frINseSq44K/uVx8Qkdz/Z9czfWvWT5Irqlf4V6P4+NdH7Rx
         D2mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782752038; x=1783356838;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=467nTLX0LnAbWRx2UyG//0H8fEY44fM4VWbD3i/nXkM=;
        b=HYLa1TuC8gEjVslQlHfDsdFd1qAEwHhBULkYY4PfrkFTV36vxk6nbk5NZAFhLS99Nr
         oIf4YNmQ5cInhMvtILMoAadY3GjFCGMFpR1QHllNcHKTXSWASKmB0zK4bolRB7+8yFlT
         b2b8af1PvXBMH7JRiqGKnB0G4hKzQ/pGk0R8VMvMtvQ6jCAAs1+tl9oMZBP4iHxKWUEI
         jn7V1iddZ4T6Ly3e2taZ+PVpNYMccNzcbsWuRqmoChAsoSBckVIm9J+Wap1gTGmHhZT4
         9WM8m4g+FjayZIm09DB9ph30/0IQlYVnM4cDi08ghCCMrO4gAaXW971gN/4aACQM5A57
         UrVA==
X-Forwarded-Encrypted: i=1; AHgh+RqR0GJpuOqEt9Iog8P9DGvClr6jtKF27qnogKDbVbMTw931uw1/YZVElVYbgwOgLqjMxXinTmlm8Q==@kvack.org
X-Gm-Message-State: AOJu0Yz4wF/R4CjYrlNiIHvbpQ83wA6u3ItNFtR4EfTVyYAhOPcuagcX
	SIioUDVuSJYKmdN0ozhqX8ZsEDFMRrN9CsKejAP3kT3J9eEpESnyAWj0
X-Gm-Gg: AfdE7cmq4hz+Pg1OEDCbog1JyFOu3yR0Ua8AjV/K7DHPCKK041XjIcz6S3AyXWZF6au
	PZcsVoYxBtpCvEUcVoFPuctyeQKti20TbljdF8CbAjWSf1SG+z5rUH9bXRdcq+9tKlTqhTpmDVU
	UsHFTSkjh1jgk5Sfv/XN+c4ubDjJlt/3U+0JeCpfBQOHWTNkKsZVmI/c/MRH8Vde08urHSUTHo2
	y4JMwDAkQ8q6s2tKQ58293sMqC6A4PrhenQXao72ZZWL48lauOPDt5EktmyHiW+0PL2ic3OZs+x
	s4NAllFr0BvVWm8j7QFRGBJUBzmgjIG5stDeQJpOFGEJQ6tT2VEahKB42yxEc5ibBgK2Oa51w7M
	Qr5owd/f1XZfnOIkTFOu/MOqdbR9i6m7EhIUvIJLvNVRxsC4/iVImFVjHGMr1vQJcmXf2fSF4sj
	DEUD6Hzue7opl6Wdq5A7+jIhBjpMdb9QJtqjEjTQpyigwHO4f86q+idV1CejVriP/hxWCiQ/wGt
	PKrLdh/cCo2fgXewA==
X-Received: by 2002:a05:6512:3e26:b0:5ae:b9e6:afac with SMTP id 2adb3069b0e04-5aebdbac01cmr25716e87.23.1782752038072;
        Mon, 29 Jun 2026 09:53:58 -0700 (PDT)
Received: from debian.localdomain (95-25-158-125.broadband.corbina.ru. [95.25.158.125])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad69551195sm5957139e87.27.2026.06.29.09.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:53:57 -0700 (PDT)
From: IgorpetinDev <igorpetindev@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	IgorpetinDev <igorpetindev@gmail.com>
Subject: [PATCH] mm/damon/vaddr: remove redundant RCU lock
Date: Mon, 29 Jun 2026 19:53:49 +0300
Message-ID: <20260629165349.4260-1-igorpetindev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BDA81A000E
X-Rspam-User: 
X-Stat-Signature: gydxtmmnjgerytcbu5htm75eg8g943pd
X-HE-Tag: 1782752039-367887
X-HE-Meta: U2FsdGVkX19SkXPPTptIaQBAV2IVyNC1L7gE6ugkGnAt/a4sSC0tPE++7/LqqlzHg/7LXzV+HHRUWT3lELgslHec68aw0JZpyEvrIMZv4hS5v7ozkWmJxGw+p/CVxkrzmyW6RYEdPxM+AVrr+iuGnzCsZ12bsQmIzwRYEheGBH0cYEmt/KksUi4pKTVbnhCaebC5hKVtPNUrf7/ZcYf8AK1ZXX+WbLWBgyBkffhwC+MjbcFxIJuq+CDQgqJj0LkLcRIyV8w73IV2CLcO68M9DtmGN9tsCdJJkf58e8aVBHC2dbQZ0dfWDzR5d4oa5JoICGs9nK1/oKcUsQg9vJNWglLBHXXdw36ewRXc6q2GpfK8gxrsLG+BYX/3NbGOsnLsuB8VILLp070R0/rwBjorrI67ufIK6et/GREFXEsbk15eWt4Atkdh1lr2GAdMJ178xEoDTrNzqsIwl8SeobUR5arc7yFfTpGQrmzuQJium1Lefa3InxtzZBnD+e0jpIdK85/qA5sXQejrCaBSqscSqNl7fIAweP2nQPJYuTWHZBPaVV8/0eYDsUYctHn01n+45uLMhc011NzVvVgQZFS8aGub9wSm453foU/DWoULysGNYuCy+2uiDmF+hqT5QnfvwblK2+z6DQDZk+d6XazPlJWmotXuP3NZblyghUIO45oLy3tvNhXkVqca4NoJ39HGtr5MH/syisyvIBOn1MD5mBhYLaioVUi34G0+rcdy1o/aiegMqJlKdZNXlNAJQ7rJLRdadfqe7wMx8/P6XENabTITQ5aKdpGT4ZoiCenvn2IXV4kaquSNuGWWb3txqm+fBUibCpVTt2dn8IIV/vCrRqezHuWfP1jQRkRs5PLG0zSnwtM51BKcQGEWpx1CiYXml/tRMWvswXTSevGJot+YgntxSQzZ+b++kXKHgPrnhB18VAYA1XL0WydVmv723g7dzxukO1n+J2s/xXMqK7O
 AKQ3zfeK
 87BkVpHyOMjS1RgDahlmYUZXb3Yy0UnBII+s/yw1QNE57Wc+7VdYpA4i3lK/IZLEaLGcETuNWZoNTO74aRD4Zll5T6ZIZscyaFRFRvAa6hVeIC9ln+rMVHlgHLfi1hUP7cx8eefd0sT1lEsm6c7AbX7Zvqap5y6hqnF1LdOSMjy5l9+QlpEMjOOD6zhjzhAxKGrFcS2I4/KXHiiShKc69pwyuV2N6n2A7Bbjih17yHvsQv/zTlD/WzObWQAt49FgoFwKFlAq9PptnvwE52PVDbW1coSVCPaTNJoZSxDPyfXQcuTKp7tyryqzK70ec8RLMRDkMFn5SEIcVNpcf4jfoNGosR0tedAzdWPlbbIKn6b+mfGfp78KiAClIbCbgr12IP5ahtKn/AwFlYd+GaO9e+PhOdSmejqaokUQP16z729wUrwQUNyrfG4iUZb4SG3nnshXAoJIBSkvk7IZtklFO85O9Gxg4o/5IfSc4Rq3Ddb27utBOmxUIuLfw0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__damon_va_three_regions() is called only by damon_va_three_regions(),
which already holds mmap_read_lock(). Since mmap_read_lock() is held,
the maple tree and VMA list are protected from concurrent changes.
Remove the unnecessary rcu_read_lock() and rcu_read_unlock() calls.

Signed-off-by: IgorpetinDev <igorpetindev@gmail.com>
---
 mm/damon/vaddr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d27147603..345b89b5d 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -84,7 +84,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 	 * If this is too slow, it can be optimised to examine the maple
 	 * tree gaps.
 	 */
-	rcu_read_lock();
 	for_each_vma(vmi, vma) {
 		unsigned long gap;
 
@@ -105,7 +104,6 @@ static int __damon_va_three_regions(struct mm_struct *mm,
 next:
 		prev = vma;
 	}
-	rcu_read_unlock();
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
 		return -EINVAL;
-- 
2.47.3


