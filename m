Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B28DCA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 07:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40356B008A; Sun,  4 Oct 2026 03:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF03D6B008C; Sun,  4 Oct 2026 03:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDEEE6B0092; Sun,  4 Oct 2026 03:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B28486B008A
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 03:16:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DD5FA0AA0
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 07:16:50 +0000 (UTC)
X-FDA: 85284086580.24.A9E59B0
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7EEDBA0003
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 07:16:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iaGi/aN/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791098208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yYskKmzxLvnwE/h8QZQoDUu8kWT1A5Av/FLoV5znHig=;
	b=u02EfJwCFqJP+3R+ooFfihZuzmVgPyqxkBjCUqcv7VVUlEziZaYIXncRKc2q6rFwQV45HD
	/WknhoFu9Te+DvaO4885ltgw1O2tvRH74KSyDwoWFddmbKJFOQRn9JcS3WVkDbw5zVfnad
	Bq7zu8jmXHE61lvYbaAWWu6/DQr4jrg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iaGi/aN/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791098208;
	b=XUTq/qmDoyFbTxCjAqMziBkeuOfr5ctt241LU2E+K/ENd7URnVhmcFqe7CY87QwK/8wY0R
	VxkTgonHXhoyMzkmUf0rHmnHys0+PcMoQMTcuwM0LyvT2gTqMQNwJFfk7exFEVFNwDDEHL
	60FTzJIcSrkchzDMAxxYfwgLvbQKNX0=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc73a80ede5so236737a12.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 00:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791098207; x=1791703007; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=yYskKmzxLvnwE/h8QZQoDUu8kWT1A5Av/FLoV5znHig=;
        b=iaGi/aN/UIURIHwGMlYlh5dAlbU9XSFNVx9soY1ZmozfzyC5Na3F/pAtYtl5qsj/cs
         l6eHFgnAmk5D9fcxoUeRtmmPcFhVNG+ezpzDx1AQ57N5gGs4ifxRRQ0kx+YVMgIGwTYW
         R1x0qzG0ns5KXwiqDyzIUsy10M4yN0+39tyExtb04ClWi/9ojVX4jyRQlEcBELmRt26n
         dILOPkgI9cAJVCuhnNDsFWBOtBkH3iXGZMLyP1HlLDQ8wFOH+aLhObS6vGuDdpTug7Mn
         Wi6D9TK5FnxnOtH7BW24fb7K7IaqIXMmN3b/BaerwmlltyzSs0Ny/BruqmLDcbYo3e6h
         935g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791098207; x=1791703007;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yYskKmzxLvnwE/h8QZQoDUu8kWT1A5Av/FLoV5znHig=;
        b=MHqN5c8QcphZ4C7nDhBdnxBelmUEOEDtOpEyA2ywdluRAn3o45MRth74UPd5wRyPts
         kZap7w+owe7Av/Ha+e0ON33RIU/qUrEfJKf0d7JavNvTEB9hgNj4F7BAFHvvYJddsCkG
         1iQmtkzJ30hajeH6VY65x6CaG/Jvt2yyyJBOQRoVzEI2G3xRtMsXRz5ZBGkmovhQvZbn
         mjyZwjfCXUhd7kDqGZORVnBW5rs5aCsnQt5kN130IVDlgm+FMepA6Yy5U5+HK36fX/My
         DX6aoZJaM75xy4cZgtS/dm+h2yRk5be4nLRTO+IdPgVN+MyrS8SPCO3PtIkK/u3MphXy
         /sFA==
X-Forwarded-Encrypted: i=1; AKwUvByTMy/gd2xuzTMG5IX9WslSbI8Ppepj9s9vI/TqRQpdLbORuwUNkEU1tQXBzNneNm4ZH3S9Clm+Kg==@kvack.org
X-Gm-Message-State: AFq9FYLzsenXFmHrDOnlGGWvODnfBLXkaxydo3gUvXoR+iCz4+mxWcnx
	LWstEUzGry8KefADGpvNiFr8szHVn8TLm8pbCDyu8gHNN/MuTTgXD6mr
X-Gm-Gg: AYBFou0AmWfcMwJ27GvzNAttjoN5Tie1iNixwSOCiOwbY2RrBfY6T2pKKcPytgEi051
	coaE2L79jF598VkmtCD3f26ixnhthJVt0NjzzX2zFLc6Q5RugKf4qohskRnpvLHV1mh3/RhKCRy
	3IllxxxZa9fFpU3AGq9J10++iKQhgBx5tViMuKDnQ3ht6J4os9Nw+Dt+mkNo+vPbSWCvzUJ9uT0
	yHTKBRkKhL2yUk/ozc4MgSrGDUrOA3H9BPmzBCC/aB7zVltf8DDXz0BNTnkgHhJDLkTNr/YqUFU
	9UmsgJnzGWQsDg4VMGiddJqsgSSLyvF4o7DdkH+SHilb+G7dNRisFcew1lvStmlpi3VHjHrEFR0
	uCS5ZCvVWMDdT0LtU7WQNyyWHiXXouFh4ii4LqpVxsc2gY7qRTbSpcnSC5VJicjVNVjLQWgdN0t
	AVkd0ekjO8IO9Y2qvH37bdlG138mXr8JPi24FvB3M+boppAT8KeiX7rDx9CjENiVCh9ME=
X-Received: by 2002:a17:90b:3ec1:b0:39e:6a81:f34b with SMTP id 98e67ed59e1d1-3a7873dc91amr3372842a91.37.1791098207091;
        Sun, 04 Oct 2026 00:16:47 -0700 (PDT)
Received: from 027.. ([223.215.74.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d65d85csm5609608a91.4.2026.10.04.00.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 00:16:45 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org
Cc: urezki@gmail.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: [PATCH v2] mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
Date: Sun,  4 Oct 2026 15:16:39 +0800
Message-Id: <20261004071639.119857-1-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: uatfzi8a1cxfrewkfnqiusn615obq4e1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EEDBA0003
X-HE-Tag: 1791098208-809661
X-HE-Meta: U2FsdGVkX188VznC/a0CVEBse81poHVzCWwJjVKtRQjWdeNPEWCujuDWRMmPwlfJimUn8U2VJlLxh51/bnX0G6zFV7T548bJMQRkvEDLbxn3IrWMGI892+UHtlsO5mSsygvtndvsElgeUe7sCX64gzD72pCuyMTkf7N4CZRpdjCKIHoITmNV8KjEpWKgK8kbCN6ykKp7xSZQnJRxAxqm+QAS/oeC6r7Jma3bdM8Fr6+X1dGZDKxXSpPd5zbdGyPodg3jKGfGJKnIKaBChTOIqs/N+/Vngqm70VtnZgFWhV1g0LH2kfHxfCuV2MnS+HqVcRhDe66f3pWcBaXbLqDsNOmiWEDRZPwYQym0vD8L3yHnoRn3QVd6ChZwuARIG9sAenmZ/m1+4yqxNr+tLiP3JSiGynxn/VAK5DXdULQp2uJ5bQm0NHRD1srD+TlW9GmJfVIOgOVcDv1ySsOYXLi101fPLoECom+yz2LpCSwaonQcX/4A3gbLOc0768XJIolgtqREwrV/49tmaMkAGLlSHfvf0m66Tuh0UoOB+ZywicOkfCu2CDaLX3J33SUIeYhnnATIUbvjUQZoGva0NLoKN2Tw6yyQGSv6QUiGX/eKKvOZ+rpwEzW8s0GPym6oHqAR72KjsnXeHwq1ZUAUS90ZHm8PNpBsFpCujPi24lsq/1+ye95LiOrPviDp3xTACCClXHy5i02Q/XGqlm68FV8/pgKE3/C0sfV9O5oumjKBNF8cVGigJzKUC/00TPb/rFzba7ybuyehQ+havmB2Ddz464QhpFAy7JCgopDCUUnv4FtehC5US2P+H//rb+g0vAPnpXKWr8xNuWnG7LSow1hqEqrsdujZBqnsqRFRVDsKo8EvNh8Sqb04sSBQuCQCSgWpBb4M9edbOIzMHZBmlWgyUmRzGG6tGBOkuosoxqOx+C1P+sWYtDjbVUVoJofuVxDo80uuIXblY/yF+Jgo63W
 MvbbR8LJ
 i0pr85Pp/9OIEP+/RFrcIv60q/sbOnFbyq7iyOBFBWdK8VVF8BSc90lDfqJo9vmdkz/TDer0KOgS/zdXTzU3y8siVo8mhhsSJiNgPdTsbX/H4MudMi3f4k2GXg/Sajv9IzR+5Tw0jIcNPMktWbF8vJXxkf+qwzOVMalYx3u3uUfQAnt50oOe6zKovlwlEaWsd3Ur7eedyP39t3juxz5PQE15fo4WbYai86q/eooerMSej9sEDvTwmFPg1IzRD7xWQ3CYOPZdP1jBNqHsG8aqcLQ8354BumI/5rhyFCdtFlwOdYeOYlOod7RU5pMj/j7C3AXmDyZJiMbNm4nBTFxWDPhfS2U14FxypKSkM5fZ+cUfxzG+DHY4ru2bgklLDvaeZGQNk8bA3QFoVegF1A6TZCjVmUBBuiZAE4CZobpsrae9eUvEW0jzL/OdP7tPa7NE9pL8sMtP67qI5npDD72nILKW392mN9AGWYI6gUJdV8uwcBw2+Gtr3TLwOWZ9zjuGWFwMJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wen Jiang <jiangwen6@xiaomi.com>

__vmap_pages_range_noflush() currently only warns when page_shift is
smaller than PAGE_SHIFT, then continues with the invalid shift. Return
-EINVAL instead so the bogus argument is caught immediately.

Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
Changes since v1:
- Use jiangwen6@xiaomi.com for both the author and Signed-off-by.

 mm/vmalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..838c8e0ccfe9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -684,7 +684,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
 
-	WARN_ON(page_shift < PAGE_SHIFT);
+	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
+		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
 			page_shift == PAGE_SHIFT)
-- 
2.34.1


