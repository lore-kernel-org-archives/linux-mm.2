Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29ACCF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DAB6B008C; Wed, 19 Nov 2025 10:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115E86B0027; Wed, 19 Nov 2025 10:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF796B00BF; Wed, 19 Nov 2025 10:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B60AF6B00BE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00890C0523
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:42 +0000 (UTC)
X-FDA: 84127781766.07.D124D90
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id F0BD080002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ajLqcGlG;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JjJbR05GJTjvP4eC8iuNclWxk1mMm5RuLT4aWNn+uIg=;
	b=16mbh6QPdbPjzRQ3R9lef94a1E7io2E6Kbz+/8sh/0NLSeImhOOcQFHeAlU8LmhznrkesF
	F22X2bcQHp+cGD8s3OmQlrpmBNFYvDRf+7NCqcFjqJW3JVeC+AbzaynaDdctvgYaZCmjQs
	3LCMid34bzIi3H1BWnZo3SS0+AIuELc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567141; a=rsa-sha256;
	cv=none;
	b=W8z6mr9DUyPzh3O7Hu1TwD1wtcVzlVIkmna0PaqB1FeS7Z/rMKUGziv7FX+d1Z2wIGZwnV
	jHauPoscAyttc2TTU2oReH0BWpMk5dK+/NrsPUnr54acvhLNRCEMvNFrnM4jMiwde2oO+r
	MxkRMhHa+/loCot8UDyA5DGNXQf+DVE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ajLqcGlG;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf30.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b2dc17965so5618253f8f.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567139; x=1764171939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JjJbR05GJTjvP4eC8iuNclWxk1mMm5RuLT4aWNn+uIg=;
        b=ajLqcGlGgr3xwVbO7v0+4IzUajNmA7AOXIRjzQ7TxHQC4/L/EynMnMFChExLOab2vM
         rCv2/PzkQsbBfKXSKKweXD6gBi2gGugtJbbodFxKE7Hld1Q+R8yyfL10rUX0wjiIKDRi
         1XVjL3mITUAm8cvy6lgxfDp+NN8jl0Bdc3BBvDZTwr6eKuTu3qPZpeSCPzSLenw2Hqsm
         lJrUuiKQxRdJ+mf7dfxNgoP6eFU4jF3opBU4VvA5jYSxDbpu+bCraFBC5IbMqhIX/GtE
         7nhrLBT0j7OXUqQB0J2g5K7ocvOegmw5MApALcXCQjej3G2lQOiVemJ96sGiuLPgBMzh
         X/8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567139; x=1764171939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JjJbR05GJTjvP4eC8iuNclWxk1mMm5RuLT4aWNn+uIg=;
        b=d1xb7obPjeuYi41bQg/zO+QUGmyECv7RxAQxnahBunxKTrCFzPJnNjhtve5ec9mPyC
         JHtsjSYhr+J3doHact/vYOtWODsHDieZfTZyDxGMkjgMzUIbtf5hLufYzZcUI8x5/d0w
         sUMOzoXiRl0hzTLy+S9gAFecl2G6uhQlonlx6RxlxH9IYSMnry7dFEfOD76B7RH1Pttk
         DrVkQRe1hsnCXWbYtamJEpZiTIz5A1vvASyvO4w5lDRddF0HkruFV2qPpZ2Tx6qh3l+F
         OJuzrUoHNl0xbQCbOrBMnBldH+D1sKx5tOQrmW5Ojqw/DXSO13BpzYNITsARNaqnYK7W
         Oo2g==
X-Forwarded-Encrypted: i=1; AJvYcCVUtQf0gQT1jkHc8hrC0vA12PSkIgNfE8uiVtQft1+DdmLw391cbvnZHj11bOasRRoo5e9qGzOdcg==@kvack.org
X-Gm-Message-State: AOJu0YxEEDHEhpK4LnTuN8vODMYIML53f9hfWIs9RNlnSsmbM31CNbKF
	rwTa9IT6LGwQ+e/WeLMW+YahXNppnC4c0wM5ssyaDbMmEE9J49As0r5bM+xJkNSwXmE=
X-Gm-Gg: ASbGncti3kVULXQBqpruEzn5nDvAcp6QckVDIGglmOCXEbERhgva7iJYNbKDFqp67VX
	Y+LYd3/eh+TrcfvylJ9PtHx17mMEi0BYLWqFuGREZqQuvNAVNHm9PnC6aGfu3YLDAxH7f5trKsi
	aIeqhQ/uTPlMv6goOToBFqE2Mrkggld02uXNqefLh2RtWr62ePXyWHMrfCPq4H6t0cdEDYt6bgR
	lsHUEF4ViK5jcV5+9RmhsEV2+PtkVdnx26QaSF2MI79pDbUItf8e0Z/bHC/OGevNm5l4HRXHMQe
	evJyEZM93J34nVoSVgmn4kR6TMqMPl2FGiueyo6dJM+lRjyvKiJpBQGEfBwIN+c2x/Lc5ybRt1N
	1IF44owjTal8KjgvO1NgV0wfm3hmxjPtWp+tFmzS6APLVsBs4b6ZspKsF1ac4kApkuLvY5xQbSL
	IAyfNa55hVl+qYkCjyZMxavHv2qunRAw==
X-Google-Smtp-Source: AGHT+IEyhedKwAlBM3EiuchJNsF2kJSsWS7yZo6BNIFhuE+C/7ka0URI4Q7HQ+TXxvH0Bkqj0xsuVQ==
X-Received: by 2002:a05:6000:2c11:b0:429:cd3f:f43b with SMTP id ffacd0b85a97d-42b5933e404mr19233459f8f.4.1763567139371;
        Wed, 19 Nov 2025 07:45:39 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:39 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 13/26] mm/init-mm: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:14 +0200
Message-ID: <20251119154427.1033475-14-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: atms3yutiu7x4hqrjqxmojnmnshfmyg1
X-Rspam-User: 
X-Rspamd-Queue-Id: F0BD080002
X-Rspamd-Server: rspam10
X-HE-Tag: 1763567140-195650
X-HE-Meta: U2FsdGVkX1/vZjWMKgqwhU1WystAGdvurnlm8cxUR31qf9RFwcKR+DFfrNIWiUGw05pNcT0TDOunBei17trYh3ALbIsymKvtPA2LdGtU2lNFB4JoBGfTEq1WSaDLYN2lm41Jav+5Pfh+kl0kZFkju1jdd5M16V6n8FRPiM7G6SbcI3Tx9yWFfVG19UfeHkqrttasBXCilW9YziUUX35t4gEA1oUVZ3u7lHTaKr9niu8w0pugbEJYlGfIPDxsECX/qDsEayuFcPZpdPe2sHHoxRfjQ1eQZ6oI097ckVwo3EC7uPc0Cf2dWE5kt6yxaJQMengJKHnSSQwVDNcXOXXmEh4Wn/Cd4e9SNtX8BFiAiBqHdqg93ilFbvExhuw4rZCvpDOH1mJqwpto+t+niYzjX9V3z8PPkQiWh/AcPRYDL2vndMe2IoagKID06ZnUP+uaA5yAfT3CkCYFLaeatmwSU7onemPYwHLESqoIHKg+W2bniff2qsqhjOCpW9EYRsP5ex0uEuAXUSYNeBbz7/9hXq+NxrqpxAf99kTzjGb11evJ5rbJR8536ArJbQ7aV2lSS02DHH9eNkMH3NoT086tmtmh67NAAHlxSdhIXpJNoBFhBAbUAjEXi1BZcROrHebd+aX3AyIqoH+0cQ1e7+u74nUk49wNrXrcUAMyyp11n/Xq/NSKy5ji4lnUDhYe9RTTKsH2LzGSI2K3JhcQGKOOhmdufU4VLjw0tUD1W9R3eLp6arbcfcE8KZPTX1Uz1Z+QGUgrP/VvpoROm0/+37YT7wA8dVEIWdSBYjBWYJ7gFDP6+tF5c8b/beWfVbmxnAu2TGqybcPSQ7zFDwyLO4O5vLPhylvy1nFi+Jd6Zv5ra4sicPrjqst2LIOx/dTKPhCQpwaPw2Huy1Ttn2J2jCtaj5NWc/DD6L9k98tiZGDt87Ggon15oAsvAAkSkq1f411IDMLvRVXvYLdakoMaQkM
 VbU9fxq6
 xHo4YQ4hXRFKvFTsOM/fJq/sz1r1wNSic60aEoqCMPFfcCUfKjWX115UgAqEQEJNifztrdtNLv7NvbxxDBRrDFRcGE3MAvhVaeaav8CDWlhYZnpu2S4BGUmmPmI6RYFiZXhM0x2ItNS2c2/UIKmZhb68S8iFO//bkJJuTN4D98RxoA/t3eePxkqs69Axo2dD10V1va2luXGwJhb0BcMNdDwgio4Bs5mSLC30W7hXlun+4XIm73Rkt5NM48rmmVJBO3zCrDAcGJ/YmjR0hTHxGV7Zcy5ATnN8pzuPaltseYJOjawH6a5T2eP6l6ByCetqmfwSVBrwQqcGt/sEI8unu6Kz7ptSGi2FOCoAviSZVn2fB9wQZEAzF9Z17TyQ1p313XTPp6rZmC/3jExtzVplt9EmHbrXG+LYyRy+0wN/D9QnHEXria7NyjmIm0DaX/0fEXCCV0BGhituC2u8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - init_mm
 - swapper_pg_dir
 - _sinittext
 - _einittext
 - _end
 - _text
 - _stext
 - _etext

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/init-mm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4600e7605cab..6931549bb7a2 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -7,6 +7,7 @@
 #include <linux/cpumask.h>
 #include <linux/mman.h>
 #include <linux/pgtable.h>
+#include <linux/meminspect.h>
 
 #include <linux/atomic.h>
 #include <linux/user_namespace.h>
@@ -19,6 +20,13 @@
 
 const struct vm_operations_struct vma_dummy_vm_ops;
 
+MEMINSPECT_AREA_ENTRY(_sinittext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_einittext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_end, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_text, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_stext, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(_etext, sizeof(void *));
+
 /*
  * For dynamically allocated mm_structs, there is a dynamically sized cpumask
  * at the end of the structure, the size of which depends on the maximum CPU
@@ -48,6 +56,9 @@ struct mm_struct init_mm = {
 	INIT_MM_CONTEXT(init_mm)
 };
 
+MEMINSPECT_SIMPLE_ENTRY(init_mm);
+MEMINSPECT_AREA_ENTRY(swapper_pg_dir, sizeof(void *));
+
 void setup_initial_init_mm(void *start_code, void *end_code,
 			   void *end_data, void *brk)
 {
-- 
2.43.0


