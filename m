Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78919C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 08:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F14E16B0092; Fri,  1 Aug 2025 04:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED106B0093; Fri,  1 Aug 2025 04:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29F66B0096; Fri,  1 Aug 2025 04:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D208B6B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:54:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 804161A12DC
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:54:58 +0000 (UTC)
X-FDA: 83727578676.25.AF06723
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id E6B68C0002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:54:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1Paj78w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754038497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=y3AB98eeKucxvuyx0BTmR/h9RGShiBxVhNzuqMeHWSo=;
	b=ifz45Q9PciZI18rXnB2kKUeJ9Cem8Q10klXWcwlRmes9royNFbKe4UneUePe+IG9DWjnzV
	oIkUi+RvlPbgxhrisad69nkgt01wuTOl8/2/oXVfdYzSvaPDqI/LSamHCIuI25IGidkaL1
	GTf7/hONPqCJ11297vv22lf/eCo90vE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754038497; a=rsa-sha256;
	cv=none;
	b=J++yV0VzrrVZ5vIENVXlXKfRjXX3SRbHzV4HsnFL8bel+nmcclUsOcYo+Yn7241lw4XMrM
	cKrgD1TdjM1WEfpGQv7c+4Nv0wdNK4WY4vwgVqYU77iOgNUqQAwwviR223xPdxOMXCyJXe
	NDq0zv1EgDm5wbfo0mlgVubNOkZPkS0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1Paj78w;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae361e8ec32so341800266b.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 01:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754038495; x=1754643295; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y3AB98eeKucxvuyx0BTmR/h9RGShiBxVhNzuqMeHWSo=;
        b=O1Paj78wFQUmC64mQUqbTsHwYw5ThxxkuNdcmsdhl0JoLbwhEEnnAesTglfwOfjX4W
         SMbicPhPFrWu+N0O2JYY1r7DyjX2ghbJXGM+i23Uf1hEkrE1jFbgMXiItUp4W3zoCOK+
         sng7K6QvoTvhJfbrZcFasjqk8/SLRYOCP8UIEWpBdiaQ7kjlRx3ZWL9POwKDrdmWqfM8
         NmyFOFkoHK0CvEZedG98Z13CsnqV3bXXu/z5Zx5aX72bNqVIhdefd0EQD+NvHKOIzlaR
         cosdPrVddTe0gJqw75mwtEiSb7j2uJ3HLPjOYoxwLqSKwE+heGXzIkVEln7EUEBqpNR0
         mz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754038495; x=1754643295;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3AB98eeKucxvuyx0BTmR/h9RGShiBxVhNzuqMeHWSo=;
        b=M2G70Vb+uzMrbwWksZKnhs9o4DJUmnfQxnTCmNw+Ck6xcJcVBxvaXCsSQWDgmmZ8Dk
         r13ZqJFFYrateC3HnUxS97QV7GHmH0XOaR84f5oqNes/rPFb5oZAeKVHMTWVyz7isRxN
         g6YmUFPvlfsilAuSNhqSxpzJrLfneZIrrT4l3FFFQuwsWnfsG0LEOWPARHFFMlJN0wxm
         vSnNjUpbLn9Uc8cqhkgOldAb4hBdA3vNmDS5GZb3Fb/B5xlrKVTdzOAuFI/+iAc8Tx7B
         L1twfpkQTh+0spz1lbMYo/eAgMP6QRo9ymDqkBd0F7fQiN2axIY7+d37Oi269b7ov2Uj
         6yvQ==
X-Gm-Message-State: AOJu0YxnOgSY4FWk7Yg2DvNixrRw5DIpkLfAS6d4TQb5695EyUVoKWv8
	OopfE5eNLCRNnY8YqqCxs3U4lwapfxtONXf2ztASi/CIG/lXyvixUIF9
X-Gm-Gg: ASbGncsz1b8XuLssi/UgR8Z0JPYs3gPhn98hyxQw2fFsfKGocQAelsQ1R84E+3fkgn6
	VhRJojCSXz3DPzPgD/MSh21TCjQjGNODXbAW1NqdOaR8wu5EU0gLDCRuyn72KPNdDVj2cld4SDH
	7nnoleAOrDA8UDVMoVUG3gHG2KeK48MMcYd01n/HKJuiMaHIzM3DH0Gf+H6JIW96qGItQxppvI8
	kaEMGzVyMGiMDET7hA+dffKPUXbjWOc1awjqQJsMxOzS8o2BAE57rn1K2YxM+IFkIghzlCXt92j
	PAepgdG/uiFnLRK1gsdAn9uEKhQ953Tf388Nh62dSMFX4hebmYwj/jgakBI7Hf2qFBm8DD+Ph8y
	ui/2k66nZZNPChYkUZH3glw==
X-Google-Smtp-Source: AGHT+IE11O24u0tms2LfFyxN8pzbR53soXNrbtbLeno8ALixj998fuXTqYMIWsbeqsHnubUB+/vITw==
X-Received: by 2002:a17:907:3ea0:b0:ae0:b3cd:b7f8 with SMTP id a640c23a62f3a-af8fda3d2dbmr1218378666b.40.1754038494834;
        Fri, 01 Aug 2025 01:54:54 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0a1bf9sm255151466b.31.2025.08.01.01.54.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Aug 2025 01:54:54 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH] selftests/mm: link with thp_settings when necessary
Date: Fri,  1 Aug 2025 08:54:44 +0000
Message-Id: <20250801085444.27182-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: thx9nnjpw3k6zc93757cn1xbzo9ikb5t
X-Rspamd-Queue-Id: E6B68C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754038496-683601
X-HE-Meta: U2FsdGVkX1/uBuqChMZpXE8CXdLY3RgNI6DCkgVaYXrs0i91MYxqVi59O9FXwTbZJmENuC3tRTWJF9HOk9hMKNv+XvAHHB0LWy7FtpwjIwNoBzcsAsiArvRs/PTENu+QQYx+Bwgw3cyUYwUCjFuSwk8UurpqcW5N7BmtGJiYXtRm9n5PtGwMM0tE18rmU68PIo7ho6Dheos4VWDytoXaXUH0ZSxnRDnZvgyS7rUdPEuR6cTb6M4n4rSPQwF6zzUnCxosvknebn8Ky17eyPYimRziJoY35MpUFqQ9ejyeYN5qHKxu+DMewUjLWVv8ZexDNRvfwahlZRL8nHVv5cAkp7biYUvRitZSC7X3uqkdp6TgMAdxnrHlhtjfxaDsb6xfvX7HvWncSr7yZRLxuh4+gjKWGEEJQTZP/+M5cYwGqTLO4ov/goII1uTTbggAJqf4UeIdJI2UrnrgJ1eq5mRYQIhcy5nVw7OuZEH3oKATvR15JK4mA0VRfz6gZg9pclm6uyZPheB1s9KYj9roc+K0oLm+mJOsacLlk90gsxEESSfsxDgOrJ2d/vt9WanErqwus+tce6QPBc5Jg8Bumn2WRkKoiIR5rLU/ooRN4eumPGkmAKyhd9uWLVy2IiHsmholQhT1V/0Ps6KQgVIJFWArFWHc2V6wrvemLWHyU6D48W84co5b8FjqSBMOOHwN9ka/f71fmD16CkCQlZyJg9NROdKMY3ntEXxCM/EYeKd9No4DNNviDfRKDWuKm0aEeH5PRW1WziGelx8Aw7UO4nDtkWvmkvmHdH1XcJOcUW3Zifpam1H6b7z71EHDXzdORH0bn7VXSD6YrZDJtZupwcZAeoGu5OicR91KZpbN1pka519fHg5xQyo4oWSvWy7L9JBQi0Z4VqJxI7FMU8aCQerHWKFaPAbVOPBB/q6AAy55CPido6MKaS4xJhnYY+F+6zTdWnrmmpBY82UUSiAFRXl
 JwioSbA9
 zndJkNfYm3Cng6xgvpunmrSLKB246MJZGJmN61D6aAQRZOwn4hneQFykaM6hJWoL5Rlzc8Y41zxFxoGshF0AN173rg9JxoS1n+XJHV87mefl4gD1FmcO4dELPOIIMgMDtARyaCDz9BtX80EXk29YUOYLm9JXugx4faRmjKQyCv3t1ASiOfZoLID/iW68Ev3I+z+XLpbQ6Q95k1dqytitsywbs+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently all test cases are linked with thp_settings, while only 6
out of 50+ targets rely on it.

Instead of making thp_settings as a common dependency, link it only
when necessary.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
---
 tools/testing/selftests/mm/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d4f19f87053b..eea4881c918a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -158,14 +158,19 @@ TEST_FILES += write_hugetlb_memory.sh
 
 include ../lib.mk
 
-$(TEST_GEN_PROGS): vm_util.c thp_settings.c
-$(TEST_GEN_FILES): vm_util.c thp_settings.c
+$(TEST_GEN_PROGS): vm_util.c
+$(TEST_GEN_FILES): vm_util.c
 
 $(OUTPUT)/uffd-stress: uffd-common.c
 $(OUTPUT)/uffd-unit-tests: uffd-common.c
-$(OUTPUT)/uffd-wp-mremap: uffd-common.c
+$(OUTPUT)/uffd-wp-mremap: uffd-common.c thp_settings.c
 $(OUTPUT)/protection_keys: pkey_util.c
 $(OUTPUT)/pkey_sighandler_tests: pkey_util.c
+$(OUTPUT)/cow: thp_settings.c
+$(OUTPUT)/migration: thp_settings.c
+$(OUTPUT)/khugepaged: thp_settings.c
+$(OUTPUT)/ksm_tests: thp_settings.c
+$(OUTPUT)/soft-dirty: thp_settings.c
 
 ifeq ($(ARCH),x86_64)
 BINARIES_32 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_32))
-- 
2.34.1


