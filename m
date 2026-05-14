Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF73CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:42:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E74D6B0099; Thu, 14 May 2026 05:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898316B009B; Thu, 14 May 2026 05:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5AC6B009D; Thu, 14 May 2026 05:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF106B0099
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:42:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DA4D1404F4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:42:17 +0000 (UTC)
X-FDA: 84765534714.07.FABDA2D
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3FAAC40007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:42:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Id8IsFzN;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6f7VCuNqJSNbGtIB9f0dkJuFICST/hbl5c+UwAGsc0=;
	b=4IIQQww7YC8o9iCRI5wEttzpvzZ+XOtKOg6ZN00VPRHQkcFJfhGx0Ubep/aYGbdYd6NJ7g
	HxzAOPz4VuTEjZrwu2T1wVHf+rvb4gCrUtcQYAbnrglDeBD+EK0iZTFcwts2DIVNQfgfBF
	qM1IUOa1efgKSMLDDTfiyPh3qxkFl5E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Id8IsFzN;
	spf=pass (imf11.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751735; a=rsa-sha256;
	cv=none;
	b=p2IqM3EmNmhPRodZtYsOzbGIOGVAEyVfhrNJqLd4hlUg7U7YHEuMKdx3p7SjskQCiyynd1
	4xia6/ZWJT0mgMk785DaQwDQ+x6SqLfsttu5Ovai1J6x16DtVq37fU7ZAaHATjKdiQyI2y
	g5luuqcxq/xuevcL1VXvLZt/Y8JMGmo=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c82a6278a4cso2037986a12.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 02:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778751734; x=1779356534; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t6f7VCuNqJSNbGtIB9f0dkJuFICST/hbl5c+UwAGsc0=;
        b=Id8IsFzNHwLl9qiSeb4ubi0/mOl5OqKgAWEqUgC9lKhqseconI2r8HtKBXphSaHeNk
         Gy5zJ6ZG4dunHSpyIimMlAA/UVIDvD1YJWxR7Scr5OLgcFg0Zw1YYrfWTTn1Z9NmX8bV
         1noFvg1Pjk7sv0h8jPMIQhguEqzlxJNnpGzMfo/4evWSit/wmN7LpcCt/BwfpYOrl0h7
         RxhNwep0IFzqrt6wW0ilv5o/ABjmDUhuOCLYj6oIj7Pii6Ln58sfOcSc9HAD1zMUc4RG
         bX34f1mmfFyJsXir51fN7h5Esj8VOULx/BNgnTPGPkpkQOfCoX5tQu1civs1x0hwVJZq
         SQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778751734; x=1779356534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t6f7VCuNqJSNbGtIB9f0dkJuFICST/hbl5c+UwAGsc0=;
        b=U45JdaF0c0XRtOS8fKLUvtULv9eKH0rGkdWzVd23205M99nZrFCqiBTyf/07TdMDrH
         RQOnUVUDpuJUZgKg1lW+xxDhCM2f1BGAZ6G2xuV6OoE5wneYTnMJUbEB+3YIKbVFNf1C
         S/MkK590WF765ihW7/vmnhON+PpmjYhuGBST+2tMirZ6t44dGIw+yhf4L9w0ESd2NLM5
         kh68J6RkrGF2qsxwWTH3quFkChrdXpPnhlkQ4y6qNbGIgNdj0Rbk/eOpwliGxL2G9sTK
         GE5iDFL3nT5+oiqG3X3HNDQQ/p25TKtR8Jx/0byTpWUPyfwtH7bvEVTHzMLFfHJdvzCR
         GzSA==
X-Gm-Message-State: AOJu0Yync+tMgXHA1raEuY5pfhDXhINYY+upb9FBJA9xbpIIhbFIq5Nq
	/KFLdSqx45VGY0q1uj77FQdTKu/0dNbThKH9+WiPFkDHyDrr5ld5KIA8JUJrJMo14/o=
X-Gm-Gg: Acq92OEZviHuxH+ZPLt3+FjtD1N6rPsB5W+sH6rDXtiIkTHPWTXtGww/55zt2/tlYA1
	N2I6adYkt8oqFaiya5FjtcDDcqLV9gs/K+LOb4U4ccx8ln/s12pbtLsXXAFg95R3KI2bFgNfCqH
	opniy5kKfH/WPsTIKx/TjjVLEX2/W/kJNRzR6V/M09f8DoiIOwLn4LIpYsuPTbFhfZQWeuedXmf
	jSM1JmaIYOvCMlhopFn37/j64eEDyEK3SsG17MXCE9qjKa+LXoQvF/VMKVJFcTd49cq0P+2wiJk
	V3Fz133o32MMZL2tkojhmbkpvAF7KS0Qt/pyyVi7r8MvrNTcANI33Z6T23uv/Dqy6kxNjAUG9bU
	3wjhSVoIyj9WTEqnxT7URUjLo/g+I/Gm7amEKLh98JT3MfA7F3sWTcBParjEQZlP7QZ5WpYlVps
	46p+wkjEhKKpd9TShRZFwG6NZORKyBjGUuSnCi/98VnUeqX0h3xdnR37Fe
X-Received: by 2002:a05:6a20:7354:b0:39f:3ca8:a33b with SMTP id adf61e73a8af0-3afad844bf8mr7760924637.17.1778751733927;
        Thu, 14 May 2026 02:42:13 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb114a70sm2351244a12.22.2026.05.14.02.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 02:42:13 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v2 7/7] mm/vmalloc: Stop scanning for compound pages after encountering small pages in vmap
Date: Thu, 14 May 2026 17:41:08 +0800
Message-Id: <20260514094108.2016201-8-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FAAC40007
X-Rspamd-Server: rspam06
X-Stat-Signature: a7tz4djyaw95f8oxa3yw61zusfd9yck5
X-HE-Tag: 1778751735-120337
X-HE-Meta: U2FsdGVkX1/gt9ZLZjBcgW4rHswPBcHWfPDvTDrWQK6W2tH8TeIPBSR39mCAXQuxpRAMzvDzfaCp3IZOqYvm04SwZFbQd9jUR5YWCLwvwSu2fT/lrEh4Im0+wod5M+CBwppiz+fBhvMe6cddHOgdTOvk1su7zjPkHIhvg9mpba4A02shVFv1YudatdWhNLdWzql4GVWKnwa9RejANVv1j5w8hXjijz21UVY/qs8QkxeK6UFhLE/Wg1BFmtZaXY8dhqda3Bn+GFf4xaE7VjQ3bN2neEBURj/XNwDmx+gglPWCySrWwrnTi5MiTiS822jJN31HCFCkiWgIe1Z7R9npFnfZEytURafjPXxrz/a4eXGm0Ri/HFzvnYMF7TZnfc7M7CcrA7BRL9LyNNEsoGRmTNDrNfIO+bUnPE/PIzu4ZSwwTKvv8DFtZY67h55RvONN/Y4DL/wutJl+OV7OU/8h4dPOMkczv7jdtea/29jw5tbkkuW0JLj/andQKX2MQZM7jfGNP/38Ii+JUhwyxm0sPdkPJh3oTCp5vJ2q9+8kujb+Ft1z39F7YOcMZT524DkJpp9zLnm9Ve7KWW/6h1M+dxujdA53ry/xeByAKknEbvEExtkiIcshuLiHCYYXg+Q8DiOdLhhH8dBrBeHD735mqb83vJIFZnGOZ8LlQQ8zxcXjdVGIXnRMAvKju7CwpPabt3kbrZA3JFdViVUjBK/L1sym3mLFfQrC08cxYS0p2nZTSFXiIUXcCe9l/m4jl0n+6NsIQPTogNhlhZRclGqJV37I5oTDyju60OZEQq8CZ0JBTwW89ikm6w0Re92HS3szaaVHqFE1JR/Zs4e4DB/LGF0UbUvUHodwg0NThlctfCYMvCJ8z/EN6Ye5kULdh6qpg1rTKmpesArdbf0Eg0F9kuylLsY3KT6UWwCdKcW6Tc4pdI6xjsZZWLfJ/PoH4G/ZcjGHItrgDxrfbCtXlHQ
 CRiTL9wx
 onhJKHZCDinBR112exxv0BCDc/babgGHLiWwI5SibTojzqdXHnznw1WExXo4AjPE42SSeVYIKZR68BvP16/eEj81VV4my3P+lD4cTD3aW4IA6V4Yx4C6P4ouTYah1wI5/KQ8aD5lVF7cAO3NiK+HminNfMl53jHIzmRFjE9/a8lplWEj8cyIL2LSrb+9Q8I4+UFdYE3sfQc8oBzyv1xCDDSO1624DAmJxHI95cYRA5Ym7agHPFqN8FNIZoUOkUKsRHKCAJXcz8Egvqz/5oPPbk/RH2iscDmBfDJFO2PAiFiH/DRgVlA59U1L1JjNId1+O+rTPIdCa9KjINnEjb6fkoDh6du2JdNMO7TZAI1DUwxJjpnY9QtaZsIOZbGJ8aJJpjrl3jRKOzVbI9jw3k8mC2bGTdERXPcmQIRiXo+mY24Kd07XPhF78qLQaOusVMS2J8puTB57rETBG7OscnMWfFvRj4OD81Z8aNzMHsADvI4u29XL2RqRea45NivW87qF/FlT7GhZU76ZA0PCtKSHTT5loHKpZu3QxcExweopEx3R5HSe7aZZqiTVARzTJncLkrsTE4ju7Yw34W73KqAONVDm2N72TAKhsUQyhsLAKaRD66Y4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Users typically allocate memory in descending orders, e.g.
8 → 4 → 0. Once an order-0 page is encountered, subsequent
pages are likely to also be order-0, so we stop scanning
for compound pages at that point.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b3389c8f1..60579bfbf 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3576,6 +3576,12 @@ static int __vmap_huge(unsigned long addr, unsigned long end,
 			map_addr = addr;
 			idx = i;
 		}
+		/*
+		 * Once small pages are encountered, the remaining pages
+		 * are likely small as well
+		 */
+		if (shift == PAGE_SHIFT)
+			break;
 
 		addr += 1UL << shift;
 		i += 1U << (shift - PAGE_SHIFT);
-- 
2.34.1


