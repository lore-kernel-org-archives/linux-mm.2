Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91118D3B7F4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059236B0008; Mon,  8 Dec 2025 09:36:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030D86B000A; Mon,  8 Dec 2025 09:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E726B000C; Mon,  8 Dec 2025 09:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C99DE6B000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DD8DB69EE
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:37 +0000 (UTC)
X-FDA: 84196554834.11.7C95A4A
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id B74851C0013
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bevnguv3;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204595; a=rsa-sha256;
	cv=none;
	b=WdKjfL0qdnYoD4UdP/S3ymFZDKqCrqQ0II/BnPLJUNmcWhuKP1mTc0VbGjVKtdUi8CwKDT
	MztfhVtnwykDGAHOJsrC1gAuYiWsjLnuDipvXSgUNGj+1he5o0eOitI9G7tQFWdS9fjA6m
	buzePavGaBQcLK7oBRDY6jo19EXV0Gw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bevnguv3;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=p/M8esfuwmZfK/sZC4szejFvMuneTJg0v9yn8+19sBk=;
	b=7FJPSMPXdsMFTgEaQqs53GXkesYZU8HYDxsjBQYEoCl3oCAqZTQaXefGFcPpwfbT1xeTtp
	NWbweizveKiQu8H5x/bIpnsqdjc503H7mlJfyJSr3y/lY0yhxBA3lDGpuX0dNYRcXrQ1C8
	dIIpo5NUqOfCyJwdgTavwQxBj6cd0oo=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b73a9592fb8so1038950166b.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204594; x=1765809394; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p/M8esfuwmZfK/sZC4szejFvMuneTJg0v9yn8+19sBk=;
        b=bevnguv3d7X2ca+75eiLmiqLAQuIc/a6w1385Yv0ZnQS2SFRlCvi/9Aj2a1Mx1MbPZ
         jeTT5ayyOWvci5O3Bizsw23THvzP/5k8WUtzG8inGhqIhSZDAMyhIMBj9xWKYxKETsg6
         hzCAlnH/K6/WbTTXXhqeDGfdTtLBjoMP3QGHh7yHi9QKCTs6Q8uiKX4kCjQqDtIYGGbZ
         BNMlPhOpnw+GC7MkylrFfEZU84eMKmqp5PLKsGi4cUkSqRQBDRFc/0FgvoEywZol7Vbn
         baK1xGnw2WeHak6teOloME/UzLxCRy4WftRJARxw6DukH22Q59X/N4v5HTfGAMDAhw4P
         TxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204594; x=1765809394;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/M8esfuwmZfK/sZC4szejFvMuneTJg0v9yn8+19sBk=;
        b=AWuhoffqBHFqq8iKhtciWmMjcQIHoj+ILGc2iNBuaFP32/ulvAdtrzZCkxE0xnk2/6
         fpYyiUFLNfxdqp/2iTWvHsQT+yAGWsKlkzONgRWQmzh0WMej0oAdP85UlDFVX1UeCo5S
         VrqoFgFJfP3Gvq84s2r00HoWslYsTMclS9eUX12cdcSfU5wjbtmU3hPcp1ZBVpr9GO9S
         mOlu3qjqTCyVHoyFGgavBMZ4G23k4G6H+IAYY+5Wyrr/CeciZhMI3bWcnvNUvd0Kr/Vv
         D0reQwVIQyRTz9Dmljv1WkHON2zOo/rLJ2PUkMrpbpuuHdxH5qDT4qtjB7aSxNh9Gsl8
         a98A==
X-Gm-Message-State: AOJu0YyAl1LJJS5qHXq17YX7dEoW8GEJqTNAt4y2Gcz1AHg0EO11+jLq
	py8WwAJpB2AIuEdsxosjzQvEtK4y4vbYR34dcf06R0t42ZQ5A3v3ZFgm
X-Gm-Gg: ASbGncsmwp9/hdQUQzxgDeQBzoUghz6j3JOOcVT0UwvNNc0Gyb/pFyFD+v4q/xb6xTL
	s5SP8pT+esT+Cmp3JD0e10OFnOllFXqiIc4Z0Ua4tq8qeOjT0lnBaFf+uNUFaMTrjm007ABqrpq
	ZhiatHtLc1F3nzsoPC9VWxp2pyq52HuC1Ul1Jx//EpZpQZApS10MojdqzeViR8WOhfWuFVXInfs
	mDh6IZvAsx3fKtdN7LnySQRgTEcE2UL0CslDLxWxCwEMmoQBbPIRY1laa8iiiyI7XNEUvZFCymz
	Ws+t3cTrzA/yJGwNC6d6xXrfl6D0SO5Tc99BAz5/xq2CjrFq0YHYOLg2xAX6Ands+JHAQQoOTO9
	MexGdZH9tZ8fDCtgtz7RUy+oZPq70xjLY4nARHQ4O+UZkiG/FPunUd94T/xcg2+kw6yv7uXMk2Y
	lO8GiiEvJ18Q==
X-Google-Smtp-Source: AGHT+IEJ7lNREOg66o8Y85ef/Iu0IU/h2dpGAcPgN6UloNDqrv8GkUMCyBjc9sHnZ5fk7zu1GOj4ew==
X-Received: by 2002:a17:907:9485:b0:b79:eba9:83b4 with SMTP id a640c23a62f3a-b7a2398a7fbmr1034642666b.6.1765204594207;
        Mon, 08 Dec 2025 06:36:34 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f49d1c4bsm1106738266b.55.2025.12.08.06.36.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:33 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  02/11] mm/huge_memory: remove split_folio_to_list_to_order() helper
Date: Mon,  8 Dec 2025 14:36:07 +0000
Message-Id: <20251208143616.20797-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: B74851C0013
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: jb6n86dr3j1g88d86nngspo3cufjycwn
X-HE-Tag: 1765204595-579975
X-HE-Meta: U2FsdGVkX1/GX/pCimfYmK2OuZgzc9GX4SbLcMbWkWAtzkBRL+sAIC49ogDmUWUXYSvpYjMjKxlWA2vlcIZvm57KW/17ZWNefsHW3os1G2PxaLW4kPkgIa2I8QH3KRrrgkvPUl6Xth9H/yB2qfoYmsVIYw3xF0Up44qgEVAX7hspf657kecuNwVFXyISppuWrQLyiHAA6BDU/vtl1vUJIPkHrg6OG8sQHRxQgVmb0UNcRV70EIIfetToHXb9EKXyI1JToh4LNqzl6zv81puosHJGllfHZ4mtzXzJ1VxrjCwTXufjBFtRjLy74SG5GFhS9wb5SAa/5XhwrposocMsX4kEbQNKv6g27afEsLcwv7zKvSLLFqWIZFdfQTQ98KCZPufho9APRO2hgUOtxNcUaIUAIhgoTBe1EYsViNMUWT06XKPcytftUV0jtvvvIMLMoSZVCyASytJr/7S1EBZubGEhZJq9SoSHO/9Hp/uCZSblBvzSrrhMjMI+rjSWQOjpzl3+nbLekTUkQ6A+5JM3lYPV8QlCT1rANKu74Fps/HwOcYTcBPCczgp3eH1BW7lunRSPTs1szz4VXPMF94+Gj48zQNKkgYyEX2Pg2T0XXmV7s8RxELlI+vjZoy7wGFGkaCX+04wnFYCylKcMLwjo9GoHaZk+DKFOwvFK2fa7wAAKsjn2aVw99Kfuek2dLCD2abiQgY4YU/HbVpXHN0JyqL1S4MFl1R6fwuxrK7H+4te7Fdq3n7jAW8nyKyV8dcH75llxEk7l1/AXZm0wNmlR3QP52U2q4Y9DUxcaxd4h6ZcOdCVZg6EpCb+WB55TwR4fu3VE90FUCFwo5zsCdJ0j45q9Pb6/Q9M0KCA467+prXjiy90tvgXf4E0a7OxWQFuswywoio6TU2TmZ5i6w5YawzjyT/I5+vwkWfPftZ/XgSh6v6aAQFoX7wrMRAIqXJ/LsI0jh7etjYimOO8BGIh
 7qdV80py
 YJpsrsUR2EEUUNjjzSGLQJ+zXiCXPdynDP5juFBrJfTW2xoI1pSDkjG3xdTUTBbTnqrJoWHRrWVOO+3eGnN7NJuvsc+xrEXIK0FQ8LkXGQ+Na5rolPSCmgvkVGHEyGJfPGr/51UT+2k2rsfNwndvWvKoLzwMjJFGgifQUGhlLvUWmFhu7RECl4ZdQbI79DE0eVAEtImnb+DnrDHsR3SvSeCem0eww2fONOKv6zf0SJnfpYWbO2zoFUyIEoSDQNa4ubHVaQZw7NHF2L+ir7QmUomSFf/Wgw1VdX/rZ/A/EnpAQV8Koyd6O5uHgPDxIapHuPaB/UkMY3YjRMArWiU4+ORqddqC5tF0BoGMEx+3nzZYs54YsP7pCkGDNrWGr3ty/n5TLyv4u/QVK+188Ai4jnXI1s7tMs+xdZy+ITda6z67bEkUCGO5kF3CNeM0zDU8e/eu7EwCVjNFM0HMGxrnN5dYUq5RTY6EZlZ93kL36N5S3viZ+A4bYXc920oTbWGOouYU5XbUUQsVjBM3Jj5NP7fDbwD85+tKpTLXS5FDB2h5MwwQkrxUJf3QuRcny+GkLUADrasKQ3S79gRsO0EERvko4M7H1wuzZZUwZKkHB5lqA8s1G3QvWcf8qTgzPs63cJhhs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function split_folio_to_list_to_order() serves only as a simple
wrapper around split_huge_page_to_list_to_order(), and is exclusively
called from split_folio_to_order().

To reduce API clutter and streamline the code, this commit removes the
redundant split_folio_to_list_to_order() wrapper. The caller
(split_folio_to_order()) is updated to directly invoke
split_huge_page_to_list_to_order().

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 21162493a0a0..977e513feed7 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -771,15 +771,9 @@ static inline bool pmd_is_huge(pmd_t pmd)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline int split_folio_to_list_to_order(struct folio *folio,
-		struct list_head *list, int new_order)
-{
-	return split_huge_page_to_list_to_order(&folio->page, list, new_order);
-}
-
 static inline int split_folio_to_order(struct folio *folio, int new_order)
 {
-	return split_folio_to_list_to_order(folio, NULL, new_order);
+	return split_huge_page_to_list_to_order(&folio->page, NULL, new_order);
 }
 
 /**
-- 
2.34.1


