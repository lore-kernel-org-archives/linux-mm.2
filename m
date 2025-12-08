Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A089ED3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059026B0010; Mon,  8 Dec 2025 09:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0307E6B0011; Mon,  8 Dec 2025 09:36:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC746B0012; Mon,  8 Dec 2025 09:36:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEE786B0010
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ADEA1DF1AA
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:41 +0000 (UTC)
X-FDA: 84196555002.23.8A978E0
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id BF1D01C0014
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cIYxSIE1;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204599; a=rsa-sha256;
	cv=none;
	b=oY64n+xdji1RpcYblZxxy+K8PhTcqLbWh9n6Yq+/1SdR6EcRhVS3id9zFJP2yh2rn4jWYA
	vXogM0JsicPgIzTjDn3/+LhzYrzMaAkAT3klB0a4hdVm084NqdmSoA6siFn3vRtlyzFba+
	4v5SG2jBwRxVcIHab0sTS6zmOHmYrAk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=stoZDZ2CFYvWJIn2ZzLTFp8IOP/o/mvfuNRGyGS57xU=;
	b=xCP4hIe+kZqHRJdHboPlOk2TWus/8lpNb0kPM38vyRQK1X58WRLPkJkceBPbXiE9ogHBWC
	kjqQeEioON1t8Yc4GgIWJNGmvbBqqRABLPqT1544oofZQUsAmx1BXQvTsaT85t0PElDQ/z
	9iXh8kKlSJAc6IhnYSQJkAtc9O7703c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cIYxSIE1;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so7381291a12.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204598; x=1765809398; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=stoZDZ2CFYvWJIn2ZzLTFp8IOP/o/mvfuNRGyGS57xU=;
        b=cIYxSIE1OGEUHx25+qGzZJ/cCcxJIyhKGJANZ6SmXkWeXXHnqs5Bdjg7bWM9IEDg9H
         iZUiZIbb+2tZ+xAI4Dp+wuh+Y3ErmbVAgSmcxnujwIsdIbxZKfvBb3+6KxEErFDesg9V
         /P0aFAF9JDjxjO43Xgyteav5h+wYDDADDsF/IkM638j23lvgMekdTWeh+Vt1A3OjrGxq
         yZk8KzGmG9DAzTiwUaIQn6c8GRLN/nEOQ/xHMaqAEcoQlz0p88h8XIEXOLG+38iqc4SW
         17NzK9L8qNQxfh8A457VmPW2CuIcUnLipHQlL1pmoPzoP9VcENXEJ4wErsJX6vGPcja0
         yIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204598; x=1765809398;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=stoZDZ2CFYvWJIn2ZzLTFp8IOP/o/mvfuNRGyGS57xU=;
        b=QqsO8zUpjQkSK9x/V2b5jOPwH/VxMZYaEEbpLg47T+DkGDau80Mlh721r9ky6yaO+z
         kiGEorohIVQdNThJQFmScTTxzKwtbAnfV89si0ITUWJgTdSubwUx0AuTjbFlh/MkJKNm
         ewkRXTDdSlzk7b1yxqVkfJBlezvPCj4fCJCdpZIdV6oC8s2Xc5mzWfQqZ4Aqb1+jrstW
         hPLZ2k1OfrnmBOpWvIV1tJbod7NTFtIV2h8lIBLoTl8vF72xfjHm40zOp6DFeTjCRJB9
         4QT02xILIzNDnAPaOMNgy7XGMtKYt0qJPAkyZPkPY7hAU/xra/7e7LgAmAoOL6Beer+V
         kOQA==
X-Gm-Message-State: AOJu0YwzgDWBU1YtG7+NSDy0H4Jk0nqpCz6RYQJJ9Q1irsfpT7hPETpb
	bBWR86qIts8h4UxHHE9m4GO4I0UrZCpQCs47lQXLP8EIayEs6s3EjspV
X-Gm-Gg: ASbGncuq6yxk3VjwLPkI0tJAKqM5T2tKnMx2a5wvwWdBfevvxABkjGJ+p0hL3fy0urk
	Ql4eZYKnvAvBiQVo0ZuyruT05BMxqqd5+I0AOd5mjV5HuhNaGSqMyn0rzoEnofNe9S8xw0o/4T7
	KLXXsXS6jwQIP0hlxjrjQSIji0NWfMwrusN8TWYhK9XPuW0j0dejGOFpYDaAZzlPncK/EHyPHhF
	PqMmoDi8wlhlO48+xF/hO/X1ir/mZURbk/9TbYxKtUin2VjgYecoxHsj8naTdin1f76tZitGcOj
	3CTd58nwiym6Y4txBIwlrzobXJ2VmHtjh7mUKn/ySH7plzyBePHJ4wL0wgEMGGdbMa2n/Jz+dWq
	I1rSFlq0vqnbunSIPmfHESlqyrAjhnmyvk2g2CKk3M+DPPNTonu6KWcBm5SYF4xB+P1g9PvVSSl
	OONwQ5q8KtL7dvhWePFqSz
X-Google-Smtp-Source: AGHT+IGlYd62RhZ5QkV7nyqgtC8U76AlVL3dc/W/+wrfwRNviibKmkRQcu3teX4tCL2KMQp6Sp+Quw==
X-Received: by 2002:a05:6402:909:b0:643:1659:758a with SMTP id 4fb4d7f45d1cf-6491ade5415mr6210591a12.28.1765204597964;
        Mon, 08 Dec 2025 06:36:37 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b4121f07sm11249779a12.28.2025.12.08.06.36.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:37 -0800 (PST)
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
Subject: [RFC Patch  07/11] mm/huge_memory: separate uniform/non uniform split logic in __split_unmapped_folio()
Date: Mon,  8 Dec 2025 14:36:12 +0000
Message-Id: <20251208143616.20797-8-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: BF1D01C0014
X-Stat-Signature: dg3j98t4twkt6si98muu1xzwqkbfj9zs
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765204599-564345
X-HE-Meta: U2FsdGVkX198k2nhGlcR3brM9AH5IdQFhBkHsGXezlPF+i4lS5V65N3ZcVYrTAwEA2xP0HgPNU1Yi6P4/nFzsG/+YzMxwCrsR2d210e5HyR59hBEqH462XPYcp2kIGNA11A9wz1RHOsYRTnCqhb5HyTUNYvZqk3E1/XQVvHyQ329MsWPIW3RMFgEWhdRHcblGohpmTeeiXMdZTdAWBQO5s7/pziQ3Jv5GY5R2uKo8suN78XrZyjxavvm95F1Z9PAm6wCnRWAuhLbjCVqd6rIFXMne9kdXl0JrrmW7cn9YfaGLcbyNp/jsXnROXueYE/qwVTylsPKsme5CxZp7//uYb+iUKJK/r/4bEEx0rVBc+rOhkNb4GBkjkcCAaGPwy3w72fyDwC+clmwjqxbZtB1mCGlcMIbdyBjc5LFiNOXmNR+Ph5OI5YOKEvq5gE7XV5L8Xq1N+wX9oJPgMJuBDy6tUayl1qEGIzaEKyU+UqTTSTCL8SNcotrGRbSe3p+jooV8pim4jwTT5CIxNdq6dtTsNfxXlihxjNZ8Epp4R4w3UHxqSkS4/ZIzlNyH70ynMxT3qMawxVbzNw+d0l90KdBzexWRFsT2mr+ZVG5WDrlnR3NwEZHtjGad+e2qmkt+Y2WWjiSAdCm8W8IfggpjRaJh9J3lGmtksBrRy3y5/bFsz3+BJ5dMbiXhZb8M+kG0ZjdMWT6a+rGc6HBzLbIuSnv4WKwuC8F1tBlB5DnHE+zCY6BV3FuiwbGN9MhGVwkD2xghpgjX+2hQN00RpEndjiyXtW6Tg3Pm7gi/kPEvhIHEsJwZ+sPDQ7BC6aMCOMJv6Y4tQlT+Tm2QFD4B9fg2gf2ZHGItEtty9IEUZEaKfeOU/EoQlWjAQPewCXzcExB2OW16GfO75vtyJbHyzHievuQ1AyNsT+QcsqxFaLtfzhaJsBiIIbKplRHT6amNIRj4/cGHnZmF06kExee8AF1Wme
 V78myh3D
 e3gDNCCfExHzZ1H4kvU6a8ZYHIZDmWvpwYXu9Ajl9JRC3m9Fw6KtUl+EVlsaV5CIAPjQD9nTAhdm0/QA0z+/hYok22GOwioaYbrINLCkORsSVJKD0WkZu8LT8G/fY13/WwSs3tjEPBzQ4yiLhXksLv1rxykyiYyDjcNAcG7bzeeWfUcTuiHtp47C14H5liwKYVVqPfhlxooV3TT2ovzXBILdOw6xlKsMrshxIp5xLzpN8BKh+fLTAOTo24Ven4VS+Sf9W+aamkyDMk5sWP5yizSRt6NS1DDM3qljeGcpfSs1k+p+l5+s8tY7YnNFQlUlo7Cg7vzvL/1x15ssoL8uVsW3PqDZrO0vfGyNkPCG2y/ZKuyXm0aln0rxPSpCe4JbPHWKWzetNdQZhdRnGA0gPhxgOhLCB/2Rl3ODcckOsuZZTHSGzyDFTlJGfhrqOIw4o0XCoWxzyWGqkKCzJjDkhhnlOOzHPbPbm2OwawMhU4r8wgh4ANfvs0qK2v/bgICVDasP7Vwz8zZo1c65VVerU24ZwfaQg3EzGNW09txF9VqnTmKlY3SyNUiSfNUAu9cJ1InfIoQxBGKUEkBO9oZSftH1zho3RU9SbNTMxPpjvvoxU/4KuRWTg8wkINGp7t6etjP95MbV7oiV5bIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

By utilizing the newly introduced __split_folio_and_update_stats()
helper function, we can now clearly separate the logic for uniform and
non-uniform folio splitting within __split_unmapped_folio().

This refactoring greatly simplifies the code by creating two distinct
execution paths:

    * Uniform Split: Directly calls __split_folio_and_update_stats()
      once to achieve the @new_order in a single operation.

    * Non-Uniform Split: Continues to use a loop to iteratively split
      the folio to a single lower order at a time, eventually reaching
      the @new_order.

This separation improves code clarity and maintainability.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
---
 mm/huge_memory.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7160254ce76c..dbb4b86e7d6d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3634,14 +3634,20 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
-	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
 	int split_order;
 
+	/* For uniform split, folio is split to new_order directly. */
+	if (split_type == SPLIT_TYPE_UNIFORM) {
+		if (mapping)
+			xas_split(xas, folio, old_order);
+		__split_folio_and_update_stats(folio, old_order, new_order);
+		return 0;
+	}
+
 	/*
-	 * split to new_order one order at a time. For uniform split,
-	 * folio is split to new_order directly.
+	 * For non-uniform, split to new_order one order at a time.
 	 */
-	for (split_order = start_order;
+	for (split_order = old_order - 1;
 	     split_order >= new_order;
 	     split_order--) {
 		/* order-1 anonymous folio is not supported */
@@ -3654,21 +3660,16 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
 			 */
-			if (split_type == SPLIT_TYPE_UNIFORM)
-				xas_split(xas, folio, old_order);
-			else {
-				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
-				if (xas_error(xas))
-					return xas_error(xas);
-			}
+			xas_set_order(xas, folio->index, split_order);
+			xas_try_split(xas, folio, old_order);
+			if (xas_error(xas))
+				return xas_error(xas);
 		}
 
 		__split_folio_and_update_stats(folio, old_order, split_order);
 		/*
-		 * If uniform split, the process is complete.
-		 * If non-uniform, continue splitting the folio at @split_at
-		 * as long as the next @split_order is >= @new_order.
+		 * Continue splitting the folio at @split_at as long as the
+		 * next @split_order is >= @new_order.
 		 */
 		folio = page_folio(split_at);
 		old_order = split_order;
-- 
2.34.1


