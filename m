Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E0CCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9246B00B4; Fri, 12 Sep 2025 11:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298F16B00B6; Fri, 12 Sep 2025 11:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5D86B00B7; Fri, 12 Sep 2025 11:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0951D6B00B4
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C098813BDA0
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:44 +0000 (UTC)
X-FDA: 83880935208.05.3131657
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC083180013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=COQswQD6;
	spf=pass (imf16.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGwNZTJUDbb42i0I/DCBOpee9BSl0Ek2gmsDPeJY6Qk=;
	b=RlPmWxZ5sD3W2Z/GivJykWMMqXo7CzgMVNh/bYGCsNRBg6Zeb5HNSpo59s7M6qR7HCsu4x
	TSK9BKx6M5ItbP96qTwjsyu7c2dcf8639e/Nw7GBxEWbsX0zQKSYr55WV+lVsrY2ukFLkV
	BsYtxH0BiYSePxZ0FtWojorxzQyd7VE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=COQswQD6;
	spf=pass (imf16.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689843; a=rsa-sha256;
	cv=none;
	b=hxqnsJlEb8RnZCy9/MPUOqSYhlfyh+sRMClDB2lS36tdlvHsJkPGBXeDSXfP4Q4pGPFNqi
	n66O1SSs0BQZ41DHxFG8WR80/KY75sHUEVVEmSER0O516mYCRGZD7MbesO3IznzNmLVN6H
	go6Xw5dgfcUjlsoDtusu9oFt2BP6DKw=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71d603b60cbso18644967b3.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689842; x=1758294642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FGwNZTJUDbb42i0I/DCBOpee9BSl0Ek2gmsDPeJY6Qk=;
        b=COQswQD6VlaId+8cIqGz2OyyVAjY1xQ2N8pDdrpzOX3qVz/O8mizTcZIXbMCjO/WRq
         iEpZWRACCTorUQ7GFVq8HhVinW2gpDGLw82TLsgUfmEu2uiID9qO3PmTaqRxW1Od0Osg
         81fsvDiha7fojvUAAk/oH30wJbWseFqP3GhHePLoDyo+u5+OXTuZsWZGB9Yy89QlviIV
         l6ZbChCc68Iz94E1q4mx3L6tgv4cZv2xpRVw4E5ENMgglzVSRY56EVEehg/S69QRTL4S
         GxbIFFA9QEnd8XI8dPfvtOo4P5mjN9zHIhNiFCIa3UDJDJa/oX8lu97L20PYjO0nkgya
         Fc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689842; x=1758294642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FGwNZTJUDbb42i0I/DCBOpee9BSl0Ek2gmsDPeJY6Qk=;
        b=uzULreecUQ8W17SGweOUbfxokJNkqJe51bR7Uy6/kW4ia0xYQwceluRr9hryYU0ZU4
         TUfkXRtXTr+dOCubLM6FH0njHbfjYIQJbUn0+z+DsThXD2vhfRXX38uRuK4YdAM3zuZE
         lDaGmV2kJly8GoUqQZhptSx+bn1pPib5dQKnamcHoI8n24SBG08u3BKZRx8PB06UHi/E
         1BaO/pLBOLjUn5KhBnSimlNZ6RdOC78pafv35j1Wcn+upKWYBROZourFP9C5yArmEWJI
         kdkNKlLSQvzn5THOwwGxSvaGCqTLeklhtLvDYbP2YboEOVOJvz2DgTMdqvTk6noROMrr
         zxBg==
X-Forwarded-Encrypted: i=1; AJvYcCUWp6nIeCELosjmYSleHF1FW8hYlamR2SUgFEFX4nXR3TOUeLCSubbkWEFnI8wCoA3MYhMmS2pjSQ==@kvack.org
X-Gm-Message-State: AOJu0Ywok4juofA9LmjxQ1br+g95Q/ijJyDpRZzAXRbxEdgCl72i/ZNg
	B91zWrLsy7RWQCDpXDIWf1/KwbPiMQZ7+Tyf4DLRcitparrBdMtG0IF5/KPI9a+KSeE=
X-Gm-Gg: ASbGncv33ZsYnOYlk3geNZe1l7+R/0T7VT0gOkQ8UDuj39OBPFy8/SNTxHYYCECUHQy
	toUM9g6zlSTT2Dn7aIlqGhWtB068Hupi9FhFVDi2j7fP27mlDbM33ektbFNrjnEFv3cMv4vKhBK
	+E7YxtDha+dxHPIkvCDeBQwb0expr0BszJgyPmRsdD3nWOkxpI6Z87NqGLnfEkHP4vSPfgkVc+z
	3AjMLp9/udP42t1+mvt5k2BDGKIPZJqrWaEYTUf93tFtgA8PdnxATBYgHh+nmKGvuPi5Lz0I4Kh
	2fAJcNsjH4fr/9gU5ge9b6TVaHk5IcNLTTf3T9doZh1Wf1/NqWmK0GWc7676EeJ+M18wi9aulUk
	1r67RJusRGbsYQi1AXlJBVGQg2l6DBoKF9Ppl68Jlf+Db
X-Google-Smtp-Source: AGHT+IGd4PoJfw4tH37hzUk6PYKHbfiAkto5gdK9xgc2f3TOFApwMRiD1EpUFg4A8D8xg0pKJaYxEg==
X-Received: by 2002:a05:690c:f93:b0:71f:efa8:5881 with SMTP id 00721157ae682-730652db42amr34340137b3.30.1757689841832;
        Fri, 12 Sep 2025 08:10:41 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:41 -0700 (PDT)
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
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 10/16] panic: Have tainted_mask as non-static
Date: Fri, 12 Sep 2025 18:08:49 +0300
Message-ID: <20250912150855.2901211-11-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC083180013
X-Rspamd-Server: rspam05
X-Stat-Signature: pjr8y5er4k3kaq6nyaq73yoe1n6fsb1d
X-Rspam-User: 
X-HE-Tag: 1757689842-505001
X-HE-Meta: U2FsdGVkX1/rkPMHGTU7LaqOCiYaJC70kdzjcfk6XQoN7qt4ZKK6QxeZLZmCDASXMOOmJo/6qOLPF1ibna26lJHBt83HfI+t57wSHSzGwnecOPRXPSf8es8vKWKVpXl05iW7R4ys96czlgAFypv1Lsbetf9wn3GzIzYcI4dw5WiPBoTAkWzbSVdoeZ+gmJronzjXQ1khoXVqkXdHvE9DGdO3Dc2IKGp6d6QnU7XAKdYgxi9mcwZq3B9y8Laz2Bgu4DFOj8E33Wxoe86df1fHlb62qiZ7o0MGHUuWXJtgIo3SL0byLTqCr0HXChAfsUyBcQ5mj0PseSu77XvkTT+V8+19iE8Ic818L50o2RdCOoM4KvRoitZ5SsgJ91h2ABEQ6k27yDPveXAXaRWCD/4Q6mE148En5rUXtQRxQX+et6NyGCQmHAcYgjI4EdNO5aWBaVHyYvRTDm1+s4B3H+p1u93rcghcsprfICZTBsPNFfs0/6rcOg9Ah3rUPhVsehREFiE/JGE/mof2aFcamHKmQMDfd5O34wFIwfD76bPiZ0qLv/H4o+KNVEk9W4kOeRkfS8do4ScIkNz4+ynVRkCOsHIZAys7BrpinRMzbtsMGsHLPoCXrIPrRviGyAfX+xVXGXqxAf8o8KUrukVZ5WK0zcz9LZoYnkmMj9JZ1eT8v5nYUfH88qHiJpiUHKjxSKZ8YTGV7Et0tG3eAuc66xpTUV0lZGgtZRW9fDcakQcffB+A8272h31XC3n5UDErahAnMAm7MFrbrdFSK+5x99Vd6u8ACvDvy2rlTeE4w5CSW0EPZhrH/FYpssqeb2x5Ychzc+1MnOHVYnfdph6ziVGEk9kCXVrboABAcmvgf5llIe4j7tQpMOe0Li73cscVcKeGVBL7eiFLy//ZC8vROLTxhW7eGKx1TQhVlpQsQM2mqwt2mljt2F38e4mDcqvs9LPtVTQkxVk4bVCrDIyXumA
 ai6c/nGk
 KMVfXXxZkA2UzKQC/5cYzNf4uKxgRrI3XxDLXrJ0kSG4m0rxVjlM4t9ybJ35JgnTa93pBKfm0mrXr/sQ5ESXx/35L37J8pekYNxXMY5+Aclvw9j28J4uYo0MY/OLe+HrTzC/D5mOwlxC0drvTXdHEb+AxHAGIn/zVeueluA7gdzYfw+3y7w7cf/6Y5TzLWLUL6oQpe/hcwxg3VtDST++Ha/eiHS/qqt37qZLLwevFJ2N1V90+s4TYg9umpB2PTpNCAVaqSTVCoSmNR5/MNKEv9ZqfGvTmS5uq18bTDGakEy37eQwDJmPUqmZodrCrH1bjNd3V8YJaIzzoJIeGHpkjKU9q5ncEA04GnHBqRLbrhnywe91FA6jRaU/gZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tainted_mask is required for debugging the kernel, and needs to be
accessible for kmemdump into vmcoreinfo.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/panic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index d9c7cd09aeb9..048c33dab98a 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -54,7 +54,7 @@ static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
 #endif /* CONFIG_SMP */
 
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
-static unsigned long tainted_mask =
+unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
 static int pause_on_oops;
 static int pause_on_oops_flag;
-- 
2.43.0


