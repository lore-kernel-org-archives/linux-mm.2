Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB45CCFA05
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 22:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9534B8E0005; Thu,  6 Nov 2025 17:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92BE28E0003; Thu,  6 Nov 2025 17:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840EA8E0005; Thu,  6 Nov 2025 17:06:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E90E8E0003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 17:06:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA3B386F94
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:06:42 +0000 (UTC)
X-FDA: 84081567444.21.5D08E0B
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2618B14000A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:06:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="A/tNvTdd";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762466801; a=rsa-sha256;
	cv=none;
	b=mB/YNZOiTYKrfmOJDi7MgHlKg1iEH/g09gWAr1tpf6tGcn+XLikXq/BR6JhkTMYmRx6A2f
	KkCqfuIEzdqvuRrhE3XzxE8iUqsHAJaeS2+11cFRJGsTEUPVWG0lQ20fljGV3Psl0YYBrd
	XzwlYow4GijPpdQhGgao4LEh2kETL6M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="A/tNvTdd";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762466801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Tx61RuKbwaGoy8WCkWWJa+EGKVyM66y7AQYoEIU/68k=;
	b=1L2yPLVF5go6k+A0NX9YsCLjiqx3MK1LSOC/Y9vRDKSvM/IZ4mkGP5uDUTiCCBHCDyWO3q
	NKO2ySnqGXwZMxqk2tktUdv8euxkSaYvXluVM5LhBTYLE0RuA1e1vD2pU5KN65Wi6LoK88
	jYqHfBRSgWu8MkAjYWuJKXvA8swxnNw=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63e336b1ac4so194546d50.1
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 14:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762466800; x=1763071600; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tx61RuKbwaGoy8WCkWWJa+EGKVyM66y7AQYoEIU/68k=;
        b=A/tNvTddHGNzjikbUn4SoM3f0fVtZuyQlT4nmOhFl3tTJ6NJCLCROU7D1/BjkJ7Q/D
         jgV6p9nmkgQro0RRaSa2QnyuoAf66RHZLnWU8ut5KFoakH7rmo7DKwkYXn8yKfuYdlIs
         KPdL1aLGR2Aw4P8f4Fj4JaTn0h4MjQIXk1Ui44wuT1DLf9MM1y5wDlC5kuA0n4WKyATg
         S3Zt45vd5BKWODC3E+V8LXBATwJ3KAggRz1C6iLYKe4LAyb0aFJkfwVqcJkbNpN7EiPy
         jx9YjGWoOzBAv+luCQicnw1WAZkZx8LrgkJPlaQEpNuyjmEDH/uNsaimsG2R8djGieGL
         /wQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762466800; x=1763071600;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tx61RuKbwaGoy8WCkWWJa+EGKVyM66y7AQYoEIU/68k=;
        b=AzAemZSMIPvbJiF7GCPYJet8BWo9dr/VAYDfh7dMa4RhsCAABgPmL/UUJBE/7ypSd0
         kaMDz7Wzjo+JEmT4F3G3TTLw0aoKTZzVqXJ593oFtFP4yNO1OQHvlAthn9rHB4EQ54TC
         m6MLEqRfDZ+Ez5M6QVlomYDy7bsJyxkEfQBpo8xInSSZzmwu882AzZCk+FGzupZGnFpd
         TDrdmZcJSNiqV8kx6c9zz5f/rlspz62Pxl0b7efCHTMOCfDnUlvTkCkW5tNaDk57upRT
         G3xAWl0dge7Bm0mTyFU8cp64LygYh9XZ+8aLl5wl3nkIG5D1bL4lrdtHbxUF9u4B98Xv
         0SnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwpmNr2jvggAxt5YzvpumRsSVpOoj2QOTjNd0gVcsJUjgKI55hNy48Vwsj4XDBBeJGbvBIaDejxA==@kvack.org
X-Gm-Message-State: AOJu0YzI3gJfijiaJpIfuzDf+2iWWIeJLszZWVuMz7Tzc0XxhkHTRHIM
	8UEjGwnI1F6D1bBc04F7Rw4jPiK64DGKTuf5BT9PHaArgULQNKBC4pqDBJtr31myhXU=
X-Gm-Gg: ASbGncvEiFlkkHowDir5Tsu5krEhxc8OwFng6tZJQSQ9xCT1M8fTd34qH0xQ22swwsS
	ZOxH12MOKuubRH/DOOglcEc44oD32Hijy5dEZYottbj0v1W0hujpAxMsf5xOkU8ZlJAsYZd1DbU
	YiAeCfsBVbg85y6okjsPH0XwhB4ZwN9hHJ0MWIG8E64vvert/S1nZjSo0xROc4SG/sZdIx/Lyam
	Rxn4j4aO5UZVwM3u0vWBbhETO/2JpyIUggPVT3rfbWBPFQY2/8V1vCPd0eWRWVqbw0HkeJwKYOM
	ObFqPgF1U0WI4bKVjFaovnywYPU+gIM15O2nJ/c3O1X23+98CraQa/mz5/iwqAMRl5OxHZgNMwf
	pbDnn4FB9at188rbkWbuR6tQG0S4/xlAwV8yfRERdf9tABqfqozzrDMpuZRjrISkWjsETYYfhyt
	FMCnPuOKFbDR0m9jSy28XITHJUpWWmHkkct1UMt+soWevgVG1NyzblNAa/0F5StQ==
X-Google-Smtp-Source: AGHT+IEbyZ3CyxYgGJMLSh8rMnJR+LBiZyLUDpUrBs2zL1yi+A/d0cUDNA5K5afagLqiMYLBA96mhg==
X-Received: by 2002:a05:690e:1904:b0:63f:7c9d:d378 with SMTP id 956f58d0204a3-640b53db770mr3942118d50.5.1762466799959;
        Thu, 06 Nov 2025 14:06:39 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787b1421493sm11743027b3.25.2025.11.06.14.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 14:06:39 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	pratyush@kernel.org
Subject: [PATCH] lib/test_kho: Check if KHO is enabled
Date: Thu,  6 Nov 2025 17:06:35 -0500
Message-ID: <20251106220635.2608494-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2618B14000A
X-Stat-Signature: fthapur4r14p8spa3cfz6cq4z5jycswf
X-Rspam-User: 
X-HE-Tag: 1762466800-809298
X-HE-Meta: U2FsdGVkX1+9LmFgwIPZnCiFIwHCpelZqTAyPMK3tB3gSj8+Rd7b5VTzs73WchV9u+TelTmEeqBXKUbnzgzK82iMyiV2/eH+H6qK8s2UhI4BJ2O3shaV5O7BsOIFVHkJbz3VA3oQ6vDjwy36ejJym28pCPLR1UMNcUE3kvUlRUvPGo84Jze2Gp5556uSE0bKPX6o4bgkm6DJ57tJux3n7wqC4vdGhG22pzYX+C2CnVOo+Q5GnZhcSM/D947WwSJ0MCwi+5+kJqJ3JD00pmhPSMgGdw1SoioTd4u30KM5YwssSprH2rl2JDo7vLaig7RHKsbahL6lzqSr87vT9H/FR4pcXUIGJYj6L5U4PmiP0nQgMBx2worj6hizKJPtpqogCAB120/1z6OSSjiGihxHFq0lgEFsx8QPg/w7Bnk7/+MkXI07u2DVb0sDVLWpO85zIEsb2Si4frUq4eyre60mrrpQSMlcvCupGlQuDQLbvjeZiyYUFJWPD7SVw19MCx2Z+8wKPQTVBcokBzF+gRe2pdVShPN4koui/hGTzD1WHgu1GXQiMu/ycKXOGt4f7vD7fFxQg/uNfEVvvRNm4HLCEM63ILvGqvS2NlX5NDgLNBHrnTTO6Z68NwHxPwbXvTG0sWtP8g3zHEF7k9BZLgEFShC7J+e91v2UnNO6gYXezVita1BKGV5tVY3e0vSx15naNWpVVeo2DeoksWf/J1M2cW8u9eAwEZLXXIhSOOoEMPeTVKgy3QiBrxob3+lOBkrOb3Zl71ddgh9YZe1CWUC9rmvwChfkcwwAXb6FqIEXntPLZTF+zQltTGHmE6CJnNT255M882pkQQXWWFchFyeWssfyWtY03N3PdpWWQQtrm5JfRxDbUvyFI4hpjQmMV5P3AlcQCY48ZpKArQ+2zf/CEXDT/xjEJuF3hAjNpMnrC5KILY/aWxxYeUbf/2/xMeU40zWtnJnhR+BanI6xmQC
 0dc+lAxp
 YZ/BooAqcggl/PGd/MvtG7OPcFVX0czU7TwxfM1i2CPFjxSIALq/Ym5inEHPITardyCyJbdt0iNbt9IoWghJ4aw2KdeNuO3sfvlnlv7Q854ekdg7T/I2F834DEqJk8jg2Kul/DD8PIUZpHYNXcQCcjX+wHpO7D1FStPmqXVeYLBCW7qGHbm22ZJfuTyh6GTYXsiGC2aBIQDDrM+7ZS2sKsN8aV7LI32slN/AgTkFqMMjcrWh9W0azJPNyUaf4+lQW/nIirFAfR4q9sTUC4U3LW+ks3P5xYeSuLUmZekoHtumTOv0uz6aGTLyQy2iHfBxvLV5By0+KGk1TQWdiRFv779WHARZVpuMkoYlmAeyUMR5iu/goa8viNlGxv2pdOCWOhC+6e/ndKuvprwhrqGjesnQ4QT+tOERGaZzl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We must check whether KHO is enabled prior to issuing KHO commands,
otherwise KHO internal data structures are not initialized.

Fixes: b753522bed0b ("kho: add test for kexec handover")

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202511061629.e242724-lkp@intel.com

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 lib/test_kho.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index 025ea251a186..85b60d87a50a 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -315,6 +315,9 @@ static int __init kho_test_init(void)
 	phys_addr_t fdt_phys;
 	int err;
 
+	if (!kho_is_enabled())
+		return 0;
+
 	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
 	if (!err)
 		return kho_test_restore(fdt_phys);
-- 
2.51.2.1041.gc1ab5b90ca-goog


