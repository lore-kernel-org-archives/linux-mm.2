Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A7ED3E788
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 02:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BF16B0005; Wed, 10 Dec 2025 21:56:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC576B0007; Wed, 10 Dec 2025 21:56:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 302406B0008; Wed, 10 Dec 2025 21:56:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 226DB6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 21:56:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFC48BADB2
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:56:53 +0000 (UTC)
X-FDA: 84205677906.14.CE8AF8F
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97248140006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:56:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gNuwpX2j;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765421812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XJniSuLX9UUDqWokOOmuSlzSiliXIsiBq5exgk5Qg70=;
	b=mPU6KGdMd2nhNuhaALLsF1aIFm8fKxL5bn9xVyI+vWSxX0Q4/8307C4z05smfRM1FixVZK
	B+3XdA6SGHXyczXOSqIngetoPRKfIXQdfOl7SKoA7mM8jkuoZDZO0XsLfaKKWn8ZpoR2Go
	bkWrLmZ1AM83lCI0yNmkQnqWt/9GdcQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765421812; a=rsa-sha256;
	cv=none;
	b=vGqrH4oNr4bUJNCNVcQ/nmyUOgZKhps4ePVXbKpNMTYJ2I6XHmpyDfPvCLqf7EpRqW7cz7
	jZQpDYnGYNZv0JiWdyw6dPSjEhZlUBg2fBDCaOxv4ShPwAAkXB89yRKPfBXQ/axiYuYmzR
	S9v9PMuxwMReL7BPd3LgYUoo1U4eYNo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=gNuwpX2j;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b602811a01so57123985a.2
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765421810; x=1766026610; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XJniSuLX9UUDqWokOOmuSlzSiliXIsiBq5exgk5Qg70=;
        b=gNuwpX2jkucpr0ZkKEVZGqXd7X13OcHIZ9C9Lz7CwgFCgM3H9sFb8H+Acl0TNA4yd5
         jI/etsETxkomTCAqWrAUALLWwVyIKi5OM2LIiTCUzkuDvQ1P4uZaXnLuuYlpbfouY2SZ
         RAIZSh8V/xk20ux012wihPTzM1nyGFE6/K1etLZQCfmyQIq80vPpW+/PBA2TTmkPjRDr
         y28DPE3cWNVSPJxb+UuPNbyBQ4dNjohHJ8Cr8T7MBrU7F44+1Huk0lQoW8SrXvvoPxpA
         f2VqNErW07ZxsTipauUigY+XtS+ePiKlRRXwk6efCVDBs6SprD80H+V6tJkIqsCtd4ep
         d5kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765421810; x=1766026610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJniSuLX9UUDqWokOOmuSlzSiliXIsiBq5exgk5Qg70=;
        b=dfuvtVoFKYbcuO7Vr0CIT8N9wWzIrNIb/pUh1nnziLhMImgcpCZCCw1oQBL36OXWbU
         UcawrvRFGQgFaTTA28jpvZNnaCVQrNosHufeTEw3KVl9bLkfByyFCPdzWkCKYRPxojti
         wHzAhcxQO2ZDGoF8beniihmxosWMcfVaZ7qQxhGPAY6dBKVBn0iAqyRwAUFMQ66957O3
         IHQbe0a0wvZmQSrQM4obOyr8o0SvmiIDyU3f0ibArwFHGUk7vYu1bMC0m+9P+dYype/U
         GvyLEfB8MtCEx4So7WIbqMCB3IqV2h38N2fs20aGmpIy7hTkWUaF2mkSprUpFfI/vJto
         To3g==
X-Forwarded-Encrypted: i=1; AJvYcCVFhe3JRTE2GyTR18+cPjDINskl56DkxzyN0TnFDgf8hRzSt6LKfbX2lRrw+ai3iyjFqKv6QsHNZw==@kvack.org
X-Gm-Message-State: AOJu0YzXcYcJsaCTle9QoEyln4vKbvnlUGhY1N49X7XYlnI/b3Iik7xj
	HVIHt5xTUBOxKsKM+U3sBUIcpG1G/b/tjyXUkf64fJDjwfrCcq8KOo6f60vUFFlpDsc=
X-Gm-Gg: ASbGncuQ/5PKm31w8vsR50w9hDBzgjsdgN7TsloVkN5+Ql1weN1k+bZMqIq4r1ljG5e
	oDMehh3sd54Ht6jttIzLGO+YSCdmrZ0X8Okhoyy732oat3nulYfAD89yVmNwef/QFxKrKKx7wR7
	nSpIBYR3tAboLGASq60xLu9cSPbLd+Qv1FLpioRszuj0rhug8KrUyh8MMJp1yDerAAEz82l3Jao
	wK7Ab3W/DFNwqX+xkdHivd9njtHDHYAY3LMvBIUo8PXlBVRGE61jlWxPL1nCwXCg0fS0/fEa9ZE
	qE1mg4PtTatu3ZxU8PWjlwEdQK3hnYtFaXRYxxIOFWp9JiQ5eUTvo/y8uy7XcIdBJI4K5/EjKLs
	+KdM6+3VuezJKJMdDtDDUJC1qMaeGn/pOYufFP8NRKiqupAh0SXBWCWQpbFkKCbxu2GKg0rJS/x
	eGpAfQ+n9cDA==
X-Google-Smtp-Source: AGHT+IF3rQHPU3OwqTZbiFQkHigAPBLGKp6Im2gpSXgMDXUsDlMkPHG2/gEkDtEQemDq4Eh0qK3RSg==
X-Received: by 2002:a05:620a:1991:b0:8b5:8ba0:b312 with SMTP id af79cd13be357-8ba39f3f2bcmr742067385a.48.1765421810597;
        Wed, 10 Dec 2025 18:56:50 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8bab5d4d944sm104642285a.55.2025.12.10.18.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 18:56:49 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: zswap: delete unused acomp->is_sleepable
Date: Wed, 10 Dec 2025 21:56:45 -0500
Message-ID: <20251211025645.820517-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 97248140006
X-Stat-Signature: upc66iwwgpw81qhehf6pmbnmbihuxogk
X-Rspam-User: 
X-HE-Tag: 1765421811-751223
X-HE-Meta: U2FsdGVkX19GP+uWvHn2Y188AT//YGnPulC8WUftzVlYBzcxLmrMvbtSxX9GCx7U4GLiZwxAjRVmGBVMSqcJkX98HgXGCCvk6B6j4e4AQuxs1hDg6YHYbUOXcTjNlgFsb2I25Cq8cktzNGQpJqIITTsF9NM11NtIq1L3jLkMVYTFUsiN+6IO/QlUUSxTSf+kjOl1YHzKAZlbu2GrUM4Qu8GhgmgpzW8EHhRqyva/Upg+YK1Yj0WiH/EgXT/lf/fyZpBZZgNQ//vS3vqz0l1Qiw1RZ2ZDvPMaaAztA+M2fVMXb6GTzI2xN33bK04vlshfYR0IPVEt02/xEqZrCdDVjK0zT589EwslreT9z+jbFeEilBt3Z/7WstnNGwTIe5N0S7NHijZsLN2Z64C1uF4y9YQ8G+bHFWZa1qbUNT+BDrlvS2Z1WT1pwSKL68hNuG3ylWglH2pyAvw74LKYrgly/fMYgIVLFb4DW/EXW76Xon5niNygbG4eY328WhEzDPAOCyGMH6napX3WxONKDmk7GRLMm+kYtO9FwGFQZJFKoFT52yr1lOhZJgok60RI53yluVPLMV/gVNIn2qu+npUSG0ermx3QDHOxD8nEXk6/lz/YlkqTzMOp6BWsQzJkAZXFTnxLEIdIwoBfuUILOmZ8wLFHNqQH4eGfm5gvISIbbg3jqNcv+Z2xdgFqogMAjKfIbpPnHn9X3jV5aueE7oF8uKPpTQZlKwCwiJSj4b47aWJbVFGzeV8VkJelfPPor2wWp6vc3ISzSgs2Auq7Bp6eabvvvUNluxBTDlPnK3ep3xUfRevpC3+ToJHIY4V4wrXGOFJZsVbcvU9t7lYdHjt9xenQ1JIv4OlObs4LlfP6CKBh+/d2tgIAN84dSLTmqokqwoBiMsYu4xV9hVhqUbP5rCr6yC+oNHlKy3jAzBcIBiP0YMeizmVn99hx/LsobeWfXs8fQuLoeq0PhgmA94G
 qhUA/NxB
 6JKzX/WyfyLwCaWG6OORjBQ1oyjt/DtiX5EOJt9MGA6QmT+h/PL4S8bBddIykf4tatD4nRikryQU1Xb30QsNQv9Z+s9OGkOta49qM0RSXudoKw8aB4g1nHFb3MyXjDoUFPeSMcVwHXVhJ28elDTvEy2YQYBISl2Yucr+daXFRwwwzxUCxd2knYnCMMnVYKFcG6CP61BcFxamTzZggVoCzg6+Vj/xnjOO2v4NRNbGi+Q+JhbfqlGmLfHfLOWhn0H6p9qrt+DEfgwbE8rKZnsEZprerH5Xyl5yVn0/bPTOZULrvco6/WjvfI0SjSKPHpJ0eur23bthFqr8q7Nh6qjngIqLxf1gE1AFf6wB9B4NDPVzggvh4yaGmTvvbXHOETIv9pHebrrdecYbtAm0jYW1IgAKQhim0YXVn+MzojI/me0HEPbU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This hasn't been used since 7d4c9629b74f ("mm: zswap: use object
read/write APIs instead of object mapping APIs"). Drop it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5d0f8b13a958..84797ed4d3f5 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -141,7 +141,6 @@ struct crypto_acomp_ctx {
 	struct crypto_wait wait;
 	u8 *buffer;
 	struct mutex mutex;
-	bool is_sleepable;
 };
 
 /*
@@ -781,7 +780,6 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp_ctx->buffer = buffer;
 	acomp_ctx->acomp = acomp;
-	acomp_ctx->is_sleepable = acomp_is_async(acomp);
 	acomp_ctx->req = req;
 	mutex_unlock(&acomp_ctx->mutex);
 	return 0;
-- 
2.52.0


