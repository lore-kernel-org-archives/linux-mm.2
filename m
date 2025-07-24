Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE5CC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9058E8E0083; Thu, 24 Jul 2025 09:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6A98E007C; Thu, 24 Jul 2025 09:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5648E0083; Thu, 24 Jul 2025 09:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63AA08E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DA8310FAB0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:48 +0000 (UTC)
X-FDA: 83699308896.21.69C60C5
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42378140002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="SuDS/7IY";
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365406; a=rsa-sha256;
	cv=none;
	b=AhKegIZUR8f1m10LlQdKpzUc69tcBv6U2s5WC0LHx73Sw6aNekC58GPuaPKyovyOWJoVuR
	8PM0Pn8HPvScZtpdfsWV81fjgAqIo0VdbyQiBwHU3ErWPNpy+0zUWBeGJpjfvZ4iZoZPEO
	q0/DiFgUjdx6TF9ExAKKRRxm1Vlg9aE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b="SuDS/7IY";
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAPeYZVy8llrcCGwu3MIGe2nhyxNrtHRlXTr72itWZc=;
	b=Y+sTHglcwFKhca2ReFd6gTa24dy14paKNuopgejYOGMP1oxAsh4Q9wJ/8y9IeVtXk4ha8k
	icpdrI+h+pW7HImiL+QXeCLTgxnU/IY+vi3Go49SMyLTN93hPFyR/eykAXiQqPbOYxuEBk
	If6Q61/+4U5StOn++yQIVgOxp0b9EL4=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so1132139f8f.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365405; x=1753970205; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IAPeYZVy8llrcCGwu3MIGe2nhyxNrtHRlXTr72itWZc=;
        b=SuDS/7IYbOWecgY/jDqpY0BJ9kZ9wAs63Hy1YCnjJC0ibu1PCpBaqSX83U2TbZYVNm
         4gugkTI90HM07Qk++5GajRwB4KASy+UIokleAqJYn5O7W+vIRNbcXnmWYOuTkQHZFBCZ
         8VeGMDJFi9lD9qi8VGQMwh48gIJh3+xZMrARDv3Pr00fiB7E3Fm+ew9yrS4mFxICVRox
         Wl0D+xZYZQQ1d437NZ1K3VF5r99JxVcFjyxJ8gUr2kfq7E5XkYYa1/Kha92YKFq9VrMQ
         VCT0ZiWDKh2pVZdKRLtn0WTeyWFD5N5iWCH32VqtEAxN/hK2IE8qRNsPPEZaaN1/o65e
         oOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365405; x=1753970205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IAPeYZVy8llrcCGwu3MIGe2nhyxNrtHRlXTr72itWZc=;
        b=xFYNDMGitmxHTLh8ryz9c+mMm2oJwT6IgS0oqVfnI4url/7DY2uR2r4Id/ZyMzsuj+
         q/H+C3ine/6Lel6vBHEzgTq13I1XefkNjGAXsJwrplBajF/cSCljTOAyBs6N9sN6x7MX
         FAP6TQmoBEyMLR37U7cHN9jd1UYgCM7/U9RO+xroDb2lpW56gRKNmOvy+HNgGiuMgv4F
         581v/wszRjRHzhzK+wEs2XtqcKPjrRC0/7ruxrrbFFSTq/tmvUcmBD1k1kYhPBsNQ71c
         VkYRExmZhAy24gnjgR1NeDof//nqW7ZBaKxZ2EjvY09v2/Evy03JC4QUR7QlEPIta0hM
         76VA==
X-Forwarded-Encrypted: i=1; AJvYcCXPOp23jlrzVuPo24mof3ZiM3rGg4/k4MV+EavdoVWa1QTXfDJs9VE9dKChhIDPRkgMgub7Ap71MQ==@kvack.org
X-Gm-Message-State: AOJu0YzvvJYOgEDjeQx86NEwSF6Ct9+t0n3pWMgIWLsOAsTmIZQ183yP
	JanSiSvK7+bjus9FZzNTqjnB3B1sp8i5pePbP6qJseTOYkuPxbgq179GQ9Hh9yhchUCOmuSgSF0
	3jzfFvFg=
X-Gm-Gg: ASbGncsnpFnbaN1bAlZHoLUTAte5MkLqOXICatwygUM2jujwaqUagok47XRqYblcamN
	dGGeauOZvzlgUhyudVx8PfmOdDd+a0cezlUbfgUhuGy7kjiBvTDblfUtMkcy/L1BYerjih6/r/7
	GCC0hvB4m9o+b60d6zmYLf5uUYzkQU0MagdrxOdNefELZmd4ayETXiLNObQVFGoZCswkI43Wf3w
	aGF3CoUe8x5HGnxVpIojma8Dh+wzUeO4U6OPAlCDJcRLrxfy9hK8NAzzzwnJr/CJV+vXT3AufOT
	3FgHdco3OQDTs0GYkcUnjTTofwKRbnbIBdT9GljsEFqfm1zhGJYlEIIZVKvt/zGrbR6ovJsnZiv
	N+Unz9qw/FNz1Eks2XUZc3gKnpObYpGkBUd0mTY4vnVFOPdtg5woztvwAShdCFhVnJFcFwLpqXj
	7cKuoUYUYLBexe
X-Google-Smtp-Source: AGHT+IE/tOxCaZJgBIx1z77DRVJHCm2c/RVz26viacIOb6VPqsOvedK5J5brFqoj/rS9r4t912qyvQ==
X-Received: by 2002:a05:6000:2482:b0:3a4:e1f5:41f4 with SMTP id ffacd0b85a97d-3b771356cacmr1929316f8f.17.1753365404772;
        Thu, 24 Jul 2025 06:56:44 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:44 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 25/29] kmemdump: Add additional symbols to the coreimage
Date: Thu, 24 Jul 2025 16:55:08 +0300
Message-ID: <20250724135512.518487-26-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42378140002
X-Stat-Signature: yw1y1upmzzpmk5x1pnqhdasfiey8hhqm
X-Rspam-User: 
X-HE-Tag: 1753365406-996417
X-HE-Meta: U2FsdGVkX1+1hEqBLE4p7ZgvKskjO/HSSuG0d7+kR/ZIU4E0IyHz1dqR38slr4Z+Ykb75HUJ0Uz07eYDtXau/+0pCJE1p9uFNRbS8dC3X2heVK8sUJ/zGElTRMlsoqx2OcS4UscFCmX8LnzJrfPCTVV2yamQyUcLW5AJZTxBLcPVV88FbBSShupotBLLCSjtoEi5Mb7bt+EXLk8WO1XrqVoU+o6kpqpGQxEjylxqT/e5/N90ZtBryXqqpwvvjkCanm2hiGJo8a44i0yW/fnsP1FCFFt4f7h21Qi8qfMeAL6k2LFNnsDJFb9u7sYbf6RP5lwYdRGy+RHNPyQ3I2I/+10l69XAQcC8gVMydQZMQiQHIOduPVjTmkAMDy1pI7McO3fv8aZrzoSSAqOfaZfrGMTYzb/7naE92ZnThVRQi48Tzha3WEEMr1+a6vLpHuCXwHhDxRtkV65yaG6+ISq2ReKeZFPb7yCFw2644Jonoqz8nre1OZnjdONIx4guesNbSLP1HJu6bZooJwrfZLI5qmUzKW4/5NzZnVnGUla/jhwI90SYDDmAIy7mEgXFrxYOouaDlOECjSZtOFrrBsiIAKCF2VcCNd0D6jOKWI+YY727JeKQWsijUYd0eAGt+nVEkPXeV01/vb9VHruNpYUPiFj9RHE7lhb8GEnutyL6oYl1oxCZ3h4AIFBd+6Xpy7h3pQyg1/PP/+wb1b7N0amm2xQUzzra2D1G6Z3OZyHOvmD0oJWk4PItg+p4I0SlJg8xonP67R51F/Rb6EYC8ZsQ8y1JmjmfODIaiZDlIy6w2T+Ez7uLj9YzelHYsseTXyMqXN4azRFS/kghohVcb2KA3GxPc+LkcqvllZfQ/3eOVh3ytibjGCiKNZpZxPnAHovOpUBvi5LHyGfSrj0o/yEsi7hHbUcZXcoFoGIu+AmXjm9wtSpZ/oiZuCMOg9/nQvRUhXN/Xy/NRXdAV/TLGjh
 xkW5NmBk
 haSO1bgw8WaswwOzTnsaleySHDGCMe+qSlcGnwTVJhU2BSXuaVu7znUvnqFFOV7u1hJCYGB9UN2g08fY2VFd3AiLXqsFguXnLiaa+NMsd/rLVseSS5+d0ZK5EQztRri9bdlY25pHZA/+/eefrVySvCzm2T5c+tOChoigjECBbpFRuvrC2ia3q1d01T66qsCLEvIBXdlsemc8LsxujEn3KJtvKDOs1LTyFowKYf/1p+ULqwsfc5+fBVnRHoot5exJqAxOAj0xEs7/E++GIXjJhtcZSsg83mspFkOVaIbQfBffgchtwqOFK4fnTDcOlmtoil1/2VGqLOXD2rpAavNQYPOn3FonszM0JAlh38snwHMzfiCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add additional symbols which are required by specific platforms
firmware for dumping an image.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 include/linux/kmemdump.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/kmemdump.h b/include/linux/kmemdump.h
index 7933915c2c78..94493297d643 100644
--- a/include/linux/kmemdump.h
+++ b/include/linux/kmemdump.h
@@ -35,6 +35,22 @@ enum kmemdump_uid {
 	KMEMDUMP_ID_COREIMAGE_high_memory,
 	KMEMDUMP_ID_COREIMAGE_init_mm,
 	KMEMDUMP_ID_COREIMAGE_init_mm_pgd,
+	KMEMDUMP_ID_COREIMAGE__sinittext,
+	KMEMDUMP_ID_COREIMAGE__einittext,
+	KMEMDUMP_ID_COREIMAGE__end,
+	KMEMDUMP_ID_COREIMAGE__text,
+	KMEMDUMP_ID_COREIMAGE__stext,
+	KMEMDUMP_ID_COREIMAGE__etext,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_num_syms,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_relative_base,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_offsets,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_names,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_token_table,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_token_index,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_markers,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_seqs_of_names,
+	KMEMDUMP_ID_COREIMAGE_swapper_pg_dir,
+	KMEMDUMP_ID_COREIMAGE_init_uts_ns_name,
 	KMEMDUMP_ID_USER_START,
 	KMEMDUMP_ID_USER_END,
 	KMEMDUMP_ID_NO_ID,
-- 
2.43.0


