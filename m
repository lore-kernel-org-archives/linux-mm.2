Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD0FCAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FBD8E000F; Thu,  2 Oct 2025 03:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FFF8E0002; Thu,  2 Oct 2025 03:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F268E000F; Thu,  2 Oct 2025 03:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFB038E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:35:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5113886D9C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:15 +0000 (UTC)
X-FDA: 83952363390.10.91FEEC5
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 756D1C000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:35:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759390513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VRXzbaSJvEeEuAD//MreCCVgmlc+Vr7UAiNsZmiYS+g=;
	b=qHh2S6EgQSm8QqhCFLP6waSX43N4Z5Zmk0PGX+mdzZZWZ6mDPXFGcEb2eah8TVikV3nJzp
	MzI3G3no+uutihsCrFZUaB+0vEDMEuK4Bhd2So19WpL8+Bn+Tnq9RruVZVh+KeNO3LM7t8
	eVUHLQIBPWIGcKHBrmxsfYj9iC1APrc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759390513; a=rsa-sha256;
	cv=none;
	b=QjgQ/bqMQwn7PgeipwxspxTNaU/+9tIx9tKfGMzaXb9yQpOQ5yfqDfmphkes1+jN1gP2Uz
	MAYln6d8YEZObHBZZxEz5VhG4VR37/WatOtpdTf91yhQQ4qavUBlIpI9SZXwWBgm8FAdcy
	d64DhrrAESQr177waS+QVvFyEGuTml0=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso4450805e9.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:35:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759390512; x=1759995312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VRXzbaSJvEeEuAD//MreCCVgmlc+Vr7UAiNsZmiYS+g=;
        b=wB3WKrWJ1n8NuyzAT1G1g+t5M/ra8zHruBUFOEd3FGbtBJAFypLLqiR3Sp3UKSanRw
         S9yN5gZ2w+pIIRnSOkzmV0F0K/uGbAoMIadExqJKQYPWzmuRCTULHrE05QsUD7SmYbge
         2UdkopddzL4rZuxmkeLEmVlv+7gAClDetsuVu84EfOrfyIxkrApdb+UHgsaNw1Fxd06f
         UC8PqY59kxcgqB4jdmbVhtyIdeaw6S4g0TcuR+H0ETn8xYCZ4TUvTIKymKPRxPX6hVAi
         /XODL0niEUgCYash9HUw2OlVBJ8UOuqCuoHd3pcyqBZ9Bh+N4P5KXUrGiT2FUxYw/6+O
         udJw==
X-Forwarded-Encrypted: i=1; AJvYcCXm8O87qLnGLjnFF4Au0pp3dBwktJyMnflQ7hKPUVa1y+Sj6XBQPMfIlM87ADIYJZsPQYm8upDYgA==@kvack.org
X-Gm-Message-State: AOJu0YyecIE8ZQ1SFYwa9+7EFwl/u9QAtjYGCule/cRJ5sUwnsON+4RW
	bpVdHQWYef7VtHN9t5VFeLiiYRR+VS+qUl+IBmWIEg8lfJUdh+QlqlMeHpiVId+5
X-Gm-Gg: ASbGncve2yfLytjj1wWnxmAx4QpuyeVO1+SLDdnzMGjFF7npVwmxk0w7E8kX9rqg4lU
	9C0UehZLZVBjGEg0Y/KRisYuM+coHOY4o83VqB5TcH5wnqZAYHMqAvWzGxCILB90fu70QXpTo5u
	UZy575KD0CIqIUKfdEVMIM9zgK5XV1vHkqbC6iJsPp0gM+ChV3T7PQjJiRghfRmM6vKnf7n8Enz
	DgnsRtOR4Ia7BV7esHseKUHPfSzcPU85/LYyo5jkZiBI4VMocPxtrcHLfLrcBI+OKt544/IIkdf
	GYXmNC2/6gw7sUfgshpDeQQpzitsT9teZBfDMGjLtMTzFbII2DNFly8rr95mKu5vd8rVH2/Ipqf
	2S3yMdoaPfsSxnzTRE47evKIDXrz5SLhonsbP1ao=
X-Google-Smtp-Source: AGHT+IG2jlLDIgDG0wBkYWool7Xk9VaM4c6zOW54Z9lnjZVwUFDfiLKSLmpYXXdi82tG9D7HIgWkzg==
X-Received: by 2002:a05:600c:64ce:b0:46e:32dd:1b1a with SMTP id 5b1f17b1804b1-46e61262498mr50328435e9.7.1759390511979;
        Thu, 02 Oct 2025 00:35:11 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e6a692af6sm17856135e9.21.2025.10.02.00.35.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 00:35:11 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new 1/2] mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
Date: Thu,  2 Oct 2025 15:32:54 +0800
Message-ID: <20251002073255.14867-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251002073255.14867-1-lance.yang@linux.dev>
References: <20251002073255.14867-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 756D1C000B
X-Stat-Signature: arm1764sjq9959rz1dkcmxfjrhmzaf7h
X-HE-Tag: 1759390513-941965
X-HE-Meta: U2FsdGVkX1/BcqruoQu2OhjXDP9nuy+vyH7U6CVW/o6XArVj2Rx3F6nIe+cCoruyKgj7Xh0fUph49HzUhUgeq6dv1g7ravUZV24MS3Z0+G5aeL3C5INNzAcVZZNbiO089hR0pTpcLSI31gM5kD/Ge8kNKhfVKV+nEZUJRaEIuMe5hqP/XUTy7KoFFsv6UU2awsmZzeV0ujQPHTbaWUUe4oV5P0xXBPxyn0UGXHvkWqZi2NPKzbnD/S4u0qe7cxntZGtT179iYtcyECk0MWzC6NJLhfryU/QCsdjjVH4+FFE0pQ0Ik3uSh4M/Jd1T0ln4zp5umSvIyjcg0uZQ+JfpB21CqJAFMDAAKf/qgEV1PHtI8+sISsvRoBvmiw3+ek+zprdWEd8oYpO62Tvat3gH+ZOQ4XF+0p9TECINMN+gcUtV6QCvU5hKF/ZlOs24X8dKCuYdxkXwfLAoF0tdt1jnMRgvlp0ZT+hE8vCZeO2KAb+TcMkjE3ovoLrt06mssthy4KA4lrn3WEsC91rbT3sngvO+8UfI04zJi64WemGxO5I3E9S9BF5htDlsGZTbe0xw1gMTTsKabISytvh75r/69HKIPuAeAW/G+uwbBNLXX5vJ+6l+Ecyab7o16WRkHZx/qJ9o2R70ZuNLobjLawIqlxUQmofmZBkHlqE5chMznKorL094CrgNXcrFdhoCtbrrD/uKMPmSGyjq4059caFflrQXeAdPmGc+98kD39jzbG1Wdu9atOorAQUuKfEdh1Le+GorJZq7hFZNCRrYtfebgWqyXM+OleCqVJtuc4QL3SMGOGHdcFd82vqf77Hli8f1e5yfgKnnj9nizj0hPAxNTASZ3PwFYgGH9MczUyHBMYhzpnGJ4HhtFFLPJCuMOPGqgazFbhne0b+kuwg8dGFyViGsdtDVXOtsYIS8GYdzeEg6RsayLH4b1TXeJLS863DVPLsmOkfRD4PGsxZ+wK6
 T1LoxsS0
 By98ubji8NOi7jNAQ9w2ykNDRSjFRA1YN7s0+An5SeUx0KtFReu8JNS8rpiufVCcRi9fT1h5lGKqP7VvQ3fttiw2Fpilm3T0G2g9mPgP6oRmTDGiidedi265DVgAb4Q9IMXxIAAAl+n26+hNNvzFWjExHr9C5SzSNi6u1xpUoJWiM9XjZ9JdNW2jBa2z3NDI9gBiWyUA81QumYP5D+l1XpSHLRv4+vWgQByIZHEtSd9Bgr2KetqcvVsM9j5BxnBKhjZuca366GEwQJAfaykSMWgwm5I8iBsiv0tCwVHyhWYvnQYtm3mjlbFqYtJdlyg2W+syEj+5EvFnCrEqJl7Q0aBRiAnZZ8VYYtjJGuCXSCddSNYm33WIRRlhsM5m7Ti9Fyy3hZfbvGnpldpQdND184d0UUCYbxj7kON+QCKHN9OI21wr7eTmS8PdOopoTlODSfY0d3h0d5G0hgs9/shHoXwaAIJ7hTZDAjXdRGRKnq7rdoI46CAyRw0djenubH3EjqDl02Q940weu3Czj8kKgdTiiICUiigQFsc/8M+DWlHQ4n6uHNN6u5FJHlBzEATH/dmYl775Kb9PYv6t9FfJP2xzalgN55unthVO0BXgiAKLYm73TnB6tR6PCohJXz4dsy9akCrR+C4LjY6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

As pointed out by Dev, the PTE checks for disjoint conditions in the
scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
and pte_uffd_wp are mutually exclusive.

This patch refactors the loops in both __collapse_huge_page_isolate() and
hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
instead of separate if blocks.

Also, this is a preparatory step to make it easier to merge the
almost-duplicated scanning logic in these two functions, as suggested
by David.

Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f4f57ba69d72..808523f92c7b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -548,8 +548,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || (pte_present(pteval) &&
-				is_zero_pfn(pte_pfn(pteval)))) {
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
@@ -560,12 +559,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out;
 			}
-		}
-		if (!pte_present(pteval)) {
+		} else if (!pte_present(pteval)) {
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			result = SCAN_PTE_UFFD_WP;
 			goto out;
 		}
@@ -1316,8 +1313,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				goto out_unmap;
 			}
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
 			 * PTEs are armed with uffd write protection.
-- 
2.49.0


