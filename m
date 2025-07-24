Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6336C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695146B02E2; Thu, 24 Jul 2025 09:56:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646D66B02E4; Thu, 24 Jul 2025 09:56:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F046B02E5; Thu, 24 Jul 2025 09:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6AF6B02E2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBDB6112D0D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:40 +0000 (UTC)
X-FDA: 83699308560.21.8A9416B
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0974E80002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=q+BeN0nk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365399; a=rsa-sha256;
	cv=none;
	b=KsgD4pIuMS0yr1Ei67609MnoY1BK7DN7HMpW1vv2v5mNxyHGisaxoTqM1uEXe0HrgEOblv
	U/LWlXDuhsTyFo8tJekPSrf+l4PNVgcvCkPrPXDNkibpbhDkkVq8CHmvJJtmCcoyuCch1S
	F3VFlsiYVsaHRw1DNgXIGu9Hl+IKy2o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=q+BeN0nk;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=phPxbutaSa2cHj8lQiAqRNXIpOiUr1sfgJg1sLmhr6Q=;
	b=QWDeIesJWm/9y/4ojCoq19QmFFcN52Lp7E8SyGiXI00VKmKTLNh/vE7SeJbuYHzP4pojMt
	mQhrdbfrRkM+m8JDZAQplw9NcC5lxmTF2VZVfNx+I9k6utPQWxXw3lnNarnqB9TIewVxuU
	mkJnd7d4ded+IPSMH9CPRBK2fII5Hzw=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4561ed868b5so7221855e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365398; x=1753970198; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phPxbutaSa2cHj8lQiAqRNXIpOiUr1sfgJg1sLmhr6Q=;
        b=q+BeN0nkYxEPcIZBqux/bUxBB4tm3LnOC7nr7bbHHmkKvTjU1ydrsdILwlFhHMUsAu
         riouYDZLIcYIq62HssMhBK5NvpQQArJCFprzwZybZHbOwsJo+uZp5r/LsJscr49MVOvD
         TCS2Zx0kO7EsLrVCXidi7v+m/Mn5DfbTTJWoEVau1fan2aLGOofchB8INZlBl0J8ngKS
         oC0LxK/qTG8jKOAwkIvgOJejP8XO5oXdX2Br7auMcEm01ppZIfLay44C3rJgaSugN5Yd
         D5NuuIH8owazs/TH46ADEYsFHXO3dK/AKwlWDyHEGqLlC2DwwovcsRaRCXw7ysDkR7PA
         zwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365398; x=1753970198;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phPxbutaSa2cHj8lQiAqRNXIpOiUr1sfgJg1sLmhr6Q=;
        b=cpCJRaymcddyYzzQFBQS+Ue7LeweoZlTRlj3rClfnrjzqZVKW5gIYR9DSeMh5nqyZR
         Zpgi0jg9QeneyOLYyRt1S2X2HqiBkWLjqphLWp5SKTv5wgu3o6g96ECFHrktwvGWlzgE
         gpnYRFz/u0+ANZMcIfpcKBg2iGabOyKd/eG9D37ybjuDbI6RiBcSu2xrzZ3Cj9E4yBtm
         978mPBWHOrbH7BGxe50d5NMoR4pmrYpM+sFfASQ/iacmcaungY0ZLpXz8nCVvxzX2y3L
         MCSnaxkZT4f9FF9B/igXOnP9RWzr+nfvJQMvG1V3IDOcNli3P3OyEZy5gGRKQmtrLunJ
         OB+Q==
X-Forwarded-Encrypted: i=1; AJvYcCViEzIYpAsfIJ3G3Bkk2l+ukHsOxC/TH3goVMQXNSii7VL/FDHTx3pdvZJT/XjSUwNWFv2cxgCuYw==@kvack.org
X-Gm-Message-State: AOJu0Yytqm/Q5ImG/0mmeu2h+UBmWuXMKaEnO8czkM6M1+jTrIsOi8Km
	g7WKSUvWc8hdrI9Omnn9mfc9LeYs1RIGplUg2hCM1xbGmGn8NuNEQ+X+bqr4nv1szBk=
X-Gm-Gg: ASbGncu6KNX5K/EqxfvpXw1OzAXku86X081P0GycllYTatH1TOqVmlWtBVhBDkQ6Rx+
	5N8isfE/CgHcV/He08IORkolk5XP0y95ddxq9/echFVI43jmTQAzWrThCwC1Bf9SEXT5Nc7QiGD
	dlpP9D5UP0Y6FFSTOhhwdug/PHKwxHfCe6JW+OO3qcwe8eavAJt5GOumrIcMWHN/9pDkQJRuA99
	PFEkMdUISxpUzAmlbgFZHLGNn+klOaRu3+PvqlRZ80ITTRCepOC3UzysYeAB6CTEARZhzdzemtZ
	8VmjHcldWaj0HZWPQD4TAdqAiBMEg1kd37rc4jjKHUZQs5fO1ybmGwCqgekq5WOfJMbxEqwAYkz
	9aVvxP7wy40anbC1aKdRWoZ7NYfanP8zpwdvESaCPMejLyOe+Q5agIseMi3p1r9FSQLIwRKg3/d
	YQG6yeXyu0xWHV
X-Google-Smtp-Source: AGHT+IEzG7rA7SjcU5/IexjXqSf6MXBAUKpIcrbkFM4DkAzOo8wQtcA8euIhs0yEfuaDr3L1GJYTKw==
X-Received: by 2002:a05:600d:d:b0:456:207e:fd83 with SMTP id 5b1f17b1804b1-45869ea827amr55222245e9.4.1753365397698;
        Thu, 24 Jul 2025 06:56:37 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:37 -0700 (PDT)
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
Subject: [RFC][PATCH v2 17/29] mm/swapfile: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:00 +0300
Message-ID: <20250724135512.518487-18-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0974E80002
X-Stat-Signature: onhesu1yr41gbp4iet9y1o1t8y33yemh
X-HE-Tag: 1753365398-963099
X-HE-Meta: U2FsdGVkX1/9Gkfb3NNo2rhixsiTyrDHHNEYoN1zqJ5/kAzFK3WuONpqdxd8H7jJ1kI33zRHJ8qxF3nE6Wz6DRRxytz/kKLWImhixL9SvD5YGRTPHqw9sv5oUfdq4HIO5Q5lQ3zYrA+cPaFcaYwoLvrbWZYFW0/6BkNzhkyGU6nE3seItDFPK/D3CaAaNhICG6I916LujNR25WfBCyyEaGwXJYjd8M5u/0iTF+lWS9cH3QVbnLudJBWoRovbK3yjcmRmwj8RNLGm95c45utVaO0gehZTMJHiwSf6LB5EbUh1fUoWSYI+c9qdyE44INN2KFoUzQx0wgi2XcGQbgGSiJNnwht5dv37yw+HYJQpPu+rpTnIFbPG7s8rhbvcomPwNmgNWmHcJLk6a+rGj8sLzSRnE8b4BwFRK0iAEe+s35QIWT0RQpO567VeyZthu6aDL1CRw4wW+7pZUzOOs5dQSlvz9OOudf/noboxghMV09eGOBz7iuHe/7mWEk2ty9dcisT3DE/WPsMRyeSmGcUVtq7wGU0U0SQiiW4NMSQeuB5Zp4mLRK/xMsc9Sbi63I+xinHyR6bAAzLDLnaBPhhCwu+vnJdorjNsgzfpUaHb4fyV2bc2nnXZwlZ2/SX7iapVdYU5LAoKUb9XsKVu1NZb+4jc7MJqfepHf6c+p+cYnIlNhtvIcI6DHvzo72S42GZWO4Q0sxAxnSzLwivFw91zTtcUMrzsWdEVHuTpecEkBCHLa+Oq/5D2QQ5TD6Rxbb4GmaDxZhECk1DKPxWtSer/3eICAh7461+N20xwZrZOZ0KacHzYLCSqPK+onscL3SBewICp5ipIA/EbJdqfoh5Loa3Bgg4YsYYJ+7HkM0f1jYXQkdep8NfJOs4eZ6ugW/3sNJstf6aJtuh6oLNXNTyLrps1qRd87Jg4jqiAr88wP0mFJqmQXLu7CiIefYfuX/Nj1SIFtnD+sqccJNEocGK
 UEEXuz1Q
 2U+2be2ntLK7TSvRV+dGpLTDOF5gnnYjzxpfD5ClLnIWHV2LgWlT/1evE5IIArq6Gwbfs/ez2XeKGTpaND0GMc7xczGNo214SrSWXoqiwEcfS90Xp9Uw6yuTUNebFA91LSrIeFAjUrQtY6XkMOVsM5Yaqwu61JDhZmYN7/m1OW8Ep4wsW29R6DnOWsPqRfnulGQB8MyPo6UHhAperDXtZ3accdfziL2U5pULXkhyj491VwL4scwC2sgwpOMaSFvRiWDxx/+JNUr8bryTREzV6W7YDQ/bZDxlyGLYyoAHIIw5K9NUfniJqQq726ai03UYIhdlfziV4Qgk4kbq4jmCVN9juPMoC76CPE09fgiSMKL1PTSmKXej9uNE2Za78z4uANkRL8BJ+hoZG26Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - nr_swapfiles

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/swapfile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b4f3cc712580..ac5a2307a278 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/kmemdump.h>
 
 #include <asm/tlbflush.h>
 #include <linux/swapops.h>
@@ -64,6 +65,7 @@ static inline void unlock_cluster(struct swap_cluster_info *ci);
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
+KMEMDUMP_VAR_CORE(nr_swapfiles, sizeof(nr_swapfiles));
 atomic_long_t nr_swap_pages;
 /*
  * Some modules use swappable objects and may try to swap them out under
-- 
2.43.0


