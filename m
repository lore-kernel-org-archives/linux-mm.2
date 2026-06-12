Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D476CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9459A6B0092; Fri, 12 Jun 2026 11:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4F56B0093; Fri, 12 Jun 2026 11:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3F96B0095; Fri, 12 Jun 2026 11:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6B76B0092
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:41:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B7021A018D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:41:46 +0000 (UTC)
X-FDA: 84871675812.11.6487337
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4FB6016000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:41:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SJy7Yj8j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of iamsharduld@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=iamsharduld@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781278904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lMSNFcJBymbDQ1FfS4jB1HE+wy0VFeTfT8KyQHMfM+0=;
	b=pPlgm/EKwwbB4Gj51pa2XwH+xk2elgsFqgiyiLpW3ovtyUqc8IV2gZNc4gt3m97tz/7F1C
	Mhb7tmbMgMTJ5+taxTq94xXwGF2nnxvu8CJTHG0LNMwm1JfLuEmEOHQTQ7HBmlwo5uTqm4
	UYVcR/k1WitTZ/yYhl58Ck4yB9bwfgw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SJy7Yj8j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of iamsharduld@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=iamsharduld@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781278904;
	b=dNY5ONwtMJsCijg9yrYdtXpyY5Pg7Bj+SBpVKtVTKpo1wCyurhgpc3MOYgzi0WKecJtZYw
	D2Zhh0W09AMh3dkV49Dj8l3giRPEYI2CmKbBL/Wkdg+oxZ5VfJps0mkw12QiT8DEau26I9
	5rAocqxHWLfhroP0UNFmK77aBJiqeIU=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c0c35980fdso10870145ad.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 08:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781278903; x=1781883703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lMSNFcJBymbDQ1FfS4jB1HE+wy0VFeTfT8KyQHMfM+0=;
        b=SJy7Yj8jWcE5/WqezO7yWiJflA4PqEH9Otr1vl6qPnf1YDWehB8bkctJV7oMzwYjqG
         oDzJAFKstNdbPrfTOk6Wm3jmY84NMJa2HFZqAUYp5uGTI1QwIisupBI7ngA9NsmHGlBr
         TM2LaDNz9UV2zpiZB9RcezPfedu/C/bKDLRghjLTz7ES2+BxbvwbmGgppbaXC5UonEmz
         eqjnvVvtxbARtJaYkWV8ywqmBYBBFpoASdfKq1E02c7/7JgpnBn+ferT5uRqgdJvAZ6u
         u5cu52f00TlHwhbKSI4/Ty4eSXx0IK7OqdSFp1voG0gW+g5nFizJmipJnCQCeHc/9r4y
         VurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781278903; x=1781883703;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lMSNFcJBymbDQ1FfS4jB1HE+wy0VFeTfT8KyQHMfM+0=;
        b=hAZoNe7rU+j5a1YGkAU6Yll83bf5EL4ZbT/XtaQKqo4XTBaJE3ubXdfnWaU5tVbTe5
         XQh7YMB5NqzhZciOKiYgDFGcZGFpa93NgJtRngAi5pwwQyrfXDyDZAC6anOYHtNhf8z3
         tG4zsqhER8b4UJQvDzKBPjDsJTPXiHehiUmAKsi9zP9v3qzHtha0wvXCTjyp/ScIsMBj
         5olZrjz7o7+f8ygwAVolmL91FaS8WFU8s+USODB2Zha/inC00vWtCPftqL6fDt3ehpqi
         7joLgyRDWnX9G9BRyXosHBMFb0aFioE/q4KGxYmwTlkUYDZrsv2gJEbhmpRL3ROLVtwt
         IPng==
X-Forwarded-Encrypted: i=1; AFNElJ99lZnnlJfezIBEoVW/3G5tmCQJukdmfMlfk7tmhdRBcnY++kuMy4jLB9z0Ki/Sa8eP9ypAFNlYJw==@kvack.org
X-Gm-Message-State: AOJu0YxwSebCXFHnRUg1q9HqwK/awYeDYS7Hai/VPg8yLwr+3mbsiqnC
	dbhVYjL23KTsmQFCLS9oPiGE/X2wq4yCYrSD5aTyKZexYRHRVA1x7PVZ
X-Gm-Gg: Acq92OERlkJpFx/EHGwp5xYhW4kEk3PglBzhqWEqvL/sEX2FNONtw6KHUmPDXDR3bbi
	J7ZlZEltXNq8g1JadMhra+srhLa0aj9swi3H1WTfXvxyT0/9mUdpeILVA/7ioP48SlkmCjtVi+V
	jUTHbZyqrIfiSiCdY1VJeH3Majb14FQ/lQHFwf9FF4OEaasZewollaIOpMBO7RmXIPak4vZA4EW
	dW/JvTadM01/voptFRfoaJCbjLeFDnvRBfZJ+9DF2D/8CC577i2aJeJYg1tZVn3T4NBPPOdhvTY
	HFbLmJ4CNRplekwbK8t6mQH7dja9ucNdZLp0C3O4gSQ1xyR4bc3qOZpbAcDPy737b3XrTyQ4TzB
	3x1I1Q8DrEvdMjikO8VN6/h3orTcfHUowZdQWQ7Aq62veI+2tZ8B2gbBvFNj6Qq0RzMx4+6jzPD
	JaDOQT/6WlCXwmOHfSwkpmQslSsEUz8FhNznnwfVB9IuAPPJnn3To/xcBhROjIqsxx25+wTop6+
	aXSVvo=
X-Received: by 2002:a17:903:2985:b0:2c1:564b:4f47 with SMTP id d9443c01a7336-2c412840ae4mr41665205ad.26.1781278902981;
        Fri, 12 Jun 2026 08:41:42 -0700 (PDT)
Received: from shardul-ThinkPad-P16s-Gen-4-AMD.tail792e28.ts.net ([2401:4900:1c17:d4b4:80cb:f14b:59ec:7cab])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm24559555ad.7.2026.06.12.08.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 08:41:42 -0700 (PDT)
From: Shardul Deshpande <iamsharduld@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Docs/mm/damon/design: fix a typo in the Address Unit section
Date: Fri, 12 Jun 2026 21:10:54 +0530
Message-ID: <20260612154054.720363-1-iamsharduld@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4FB6016000C
X-Stat-Signature: zqqxca8r53z7hcsbmctuwoux7hd9f95f
X-HE-Tag: 1781278904-66806
X-HE-Meta: U2FsdGVkX1/15RD5XLtzH2dCFU8pafaD5Uj5AxmFtQ/pFB6T5EvJYbdbWrjp6I63JZwxMXQGtVfxXbJJZyrrsSBIcpcynpReOCvNEtW78MWcxEo6YgEw4hQq0YpE2WlLIPIm6QulPXPA3fEiYeCMBK04QmBdm/RBpiOkAzdpjLD5qXAtWYyLoBOZ/xWwtV+28o7+1F9bZspAopTxyzgnbwhFkeaHiO2sWCPUSRwJrVmFCpgqT1pjLkrAcLFBA0LXXae0gOjrfnJ50fPvFXzZlCuN3L/4w6p9DXgVknUpTu8xRtr7RqnCZigK/YOwM+pWbx6wrio/ptgmvzmrANsh2VMVOctCEEUyJtA8bIW4OPqDKQOZ+qTtgGhE+is8+W9cvFZg16JrbJiFVJADfibc8o5+OsRHMWpmGNH8q9iDBGiZPhgNKPi+sUkq8ePjxgRO60AqZ8cQKaexcHCNAn45VskUg7cmG+Ly1aXoAGlDV4wPMWEifK3R21+mOnOT1/+vUP2qh68CNMR2W0OQyu1iGw68aUQI8HbowPEAeOuPqrdfaj4FprvhSTbC92ko4WAU6l1G7gDCoveyWYjThBC9Khakna0Ynq7MzCtPAIG7uHSa6ot1QPvdj1SPdR2sh0geiksrf7IqNSEYcQ8bqjeRazbCc/y5K0j02XCG0V27fbE6TfwJquk/IwifFq4gsgXisc+sukvF3KBHmxr3OyYqvUrWwWk8t6psFuDLDu4bpP397summ9dnq0rSZVUD589ABfvUeJAu9fbl5SKlJKp+ixHLvhhlrtBGA1uJtfZSJZLqvx0TKAVwSgKJoUVYDYgsj/7QqqIBD2OfXirAbzaxRLjIYiVFi8NxFO/4VIvQwrAancfWEn/l0HI9OP21cdpXCVdZs+Z0/rzWpX7/KqeDx8kgyaITfQGnuTSkOV5vRx5mdRwvspPj5PLgv7gzmK1lOMz6R1KtZ2MnOm01dl6
 9a7vgcd0
 0qe2lHMOka0J+mfxR0wFeS6E+fpVjeuPPqgiwXcxbTS7GgrwlxBfvrAZi2GZlGztveNGVgln6Jc8xzCx4obQS5KSVZpIYRXClOk3pJNTDEa2N7I24a4qgpJ8wgAvOvLqKrGwRSCtOBbkGoBRwIpNAoU9d85MRXJs+4zBVr5rMf8poojERg7WW/jgw+25XveU1KohRhQSBOQWenPC8acH1yaEEIvA31Rh9v39sB2lKv5L7aoxZxfP5vawhhGnHwhXAMDatHnM+zyuHK3Tjlx9jjD6eBctTUEQ2IxhSZNrfVXkQnadqE9MMPMh9Y6shaiSUgvnXznTRjmeSEeUmluHbUY1tAyPLDia2/YvfYMTfUvjMfj8PVaK+DULBUVpRhegUBdZjJ3IhnkkMXPYRUybTDcy7M7Tl6ZSb42BMEp4oIlPzFaI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "Address Unit" section misspelled the C type that the DAMON core
layer uses for monitoring target address ranges.  Correct it to read
"unsigned long".

Signed-off-by: Shardul Deshpande <iamsharduld@gmail.com>
---
 Documentation/mm/damon/design.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bd..899ac9c69 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -140,7 +140,7 @@ as Idle page tracking does.
 Address Unit
 ------------
 
-DAMON core layer uses ``unsinged long`` type for monitoring target address
+DAMON core layer uses ``unsigned long`` type for monitoring target address
 ranges.  In some cases, the address space for a given operations set could be
 too large to be handled with the type.  ARM (32-bit) with large physical
 address extension is an example.  For such cases, a per-operations set
-- 
2.43.0


