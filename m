Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74067C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE546B02E4; Thu, 24 Jul 2025 09:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61906B02E6; Thu, 24 Jul 2025 09:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4FB46B02E7; Thu, 24 Jul 2025 09:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A36C86B02E4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04DBE803DD
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:42 +0000 (UTC)
X-FDA: 83699308644.05.612FF5B
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 213B9140005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rJ8K8xtR;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJKFOh1t0BpMtsqdCvtkoNZefWX67AppBNjz3MRLfF4=;
	b=MH/4pk83E2+oweikzO7w/lHVBwOcORjPOd9NAd8mfJe2rCYF9pXgcQPta1v3Q5m6NBbTIF
	EkVyBgrPBDyjcjXjnzl4hdHB+YZK0SQl5jS5yMAXRZPK2zkMlJ6MY6eUgIGMxsGO0Hdtep
	Mzm6wkt7YGsWs5ChO6lym/kKpiq3hz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365400; a=rsa-sha256;
	cv=none;
	b=iMVJbj0SpPUWerung/lptVYrbcAyrSa8XpzZWzKPGlD4wfmcniP9sSB1pGXJ1Np8NMf/rl
	/DK2tEiy2ZmYuUd35bx9+jsCglD+T80kcNi49wtwmmrWezl1MX3KFNOK2U8HvxapfMokYi
	wUc/6GojNAP0X1hopSrn76dYY+rGT4s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rJ8K8xtR;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf23.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4561ed868b5so7222115e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365399; x=1753970199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lJKFOh1t0BpMtsqdCvtkoNZefWX67AppBNjz3MRLfF4=;
        b=rJ8K8xtRYl56YPwla8iLhMScraWAjORoR5wgfadFCbOlw1Qaoqc/6gF5WQmcwhYD7h
         mhkfya0R+VcXiaiRH+IMqcPW8aNsMsd/6uefvLMm2OPg982G0NbV9Z5KHLGFiJST2bXt
         S7LXpu3efRG4BO18xy0oTOoGmnYJ0LYwlQwd1GHDq6VUgXsubSRL9kqO2MJKEFexgD8W
         mSlIerQMA6uYoYYal7jLiizbIaCDmzlTt0wwtONyor7LqgUJ4J9bzX0RmbXgJC8SMIDp
         qEnKgj5rGUFIVq4tP21p/YztBPJ3Rj4GljUqxbUDnKBkSx1paX70IkpVtYV4h6+9uxVu
         i5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365399; x=1753970199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lJKFOh1t0BpMtsqdCvtkoNZefWX67AppBNjz3MRLfF4=;
        b=Ttt+ImS6ey7K/DMly1hF5ZhQipcXinUtfLqqBBkFoVc7IU2jVwPO4zpFs48hUGS2jC
         MZDeCRn88H6YMpwQxiKtBmD2xhc3++NBDm52oL0oj3J/ggWZHIocP9B/vrmzfHwDtS+/
         sFPBtKwm63rpddc6JHI4tedIWGZSgLsxh0f94IJoXdpmmGeiX2fkIeyiovpJw8FQD0rP
         7HR+YswrIQLVXuDrAffwOcjGUEAQo1/vZ68WpttacvnzT/eKqvVyCVyecQd4CV5Ibiyq
         WPGRgjoZ6DWJKZ8boI8jNvVR9SlHPFQQoSqQuU0zbtda7OnV42PA8t799hVGQwTkKQip
         9fWw==
X-Forwarded-Encrypted: i=1; AJvYcCVJM8Dnak59AOJObvFqSzizoLJUy5OMyRIh/PDcBF3zHGpZxqCE+PbrH89JBXceNqcsDnzSQi6Kiw==@kvack.org
X-Gm-Message-State: AOJu0YzVxVR+RfVZ4xn2iPl5s5GBYx1TiXg+x6DX8i8hG8MG8oJojIsz
	BHWHcmwHqJnOaqcTTXkaoJ96CK4wNtnkqVi7WddiRK80CxUaGBn2/caQkzmAmommUIs=
X-Gm-Gg: ASbGncvC+YMo/fBdk0HInIBUWn+HqAzrQQ5asvlqTliq+1vEVNEEaZ1Hlici4ZzC5lx
	6mF4djTYcosjwfWVfyEMC03uwiTQ7Xhul4SQGurkBR8JhlpivJtZfF2TITeR7cp1F0xRPhWt2X9
	A9RwDFhpMNcwWFjWaPzW8IXwpejZNve+GGOCdU6h0zy9Wi1z3oysNqVHCtOIcgZk5cEgg2Pf98V
	7jKxe7MRlOvMiNijfjiMQLDZqM756V/DQjyzd1mNO7JPKTdzTXLMaMUgPxyKfgyFm6GY91RRY0i
	eJPzrIiOzEbVCm4oowA7gcJjuFAjWb8Titlov8ntWLiBluJIA7Jht37tSRRrke3rHTehfOIxb4m
	z8297rQCsMt13ZMWxGlb7UVt/X6nEb/IPaqcCPecSOdueeHsBPpJldX/lDYw2jg/V4jH+iX2kv4
	V0KwYRtoPLYf6N
X-Google-Smtp-Source: AGHT+IFBpfszojCM9BH8+214LoTonUL/68z7rgbLH3wV7lPKq/S6zSGoTIX7zNxB5lRzwaUzCOOn2w==
X-Received: by 2002:a05:600c:3ba0:b0:456:8eb:a35c with SMTP id 5b1f17b1804b1-4586ef5cdb4mr25803445e9.31.1753365398629;
        Thu, 24 Jul 2025 06:56:38 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:38 -0700 (PDT)
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
Subject: [RFC][PATCH v2 18/29] mm/percpu: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:01 +0300
Message-ID: <20250724135512.518487-19-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 213B9140005
X-Stat-Signature: 173n5dw7jn8aya59eqxyi4c1a6r3d57d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753365399-934332
X-HE-Meta: U2FsdGVkX1+MSIDuw2yzoTAhOncZLUA1dCC0tLmpHUlnaz5nnUGl9n8PNYxFSRASIVO7wl+bthJWZtr5NIVNvH47vk9GnFpK+Ui+zXmc+FyZVhpQ6Wng/FUcSgV1dp5sP0zvJBaFm4HjWwz8xm1tUIJO5kHQzfLWdyxY38gXFObt65xEsTOvJkAaA4u02CoxptChiEjEmiWOAj+kq/IEkvj/sqJK0ouP5m5nIw56QnBJrDGuDdH+/2jpZvInFvOVso1dbdbLgc/1Pu9j13XzppNsDDB5cdrg5a21Gyyath+ncE1yRsG9m8odyxF1kzrsUCoU2rgboXsHiSP9rZF9Ql1R+/QHrhPS1xgxKKAlpg1qNU4XKMHdAvrMDLdk44IYCCAjbYLH/m1dNau6Zi+l3O+LzRGUdRYY0utpQwqUnmWP3HUH+PXLj9MAQt/2v2U+WGCfmbD6pX5PzI2hs7jXatYAuxstIgutAEjfcj7Lx8xGVV2I2BlmjU8E2u30x+3zFJ/6fQw128CsoWaZjD4v9eUPbONuo1jfC4WNebvjPpkcpOybG3NmqCe+IGJd07EfBsM0xKqMzK5YDCRm06i9e35f5yHWdrT1ztfWW/4+JVYYQ0oxFZLdwXXWzGf3uRgv66t0wqntGkVLTu1n+wkGQ3yKIjMxzqCp2owDaibp9uwCWWTh7UJ9VJqscT/axma6hGo0HLM4l8e8OK+Wm9OSVKJgRFYieGoKDQJVRr2qavN0VqHKje1gbdmbnOZX2XoB3+XDtrwjyL7WlQ6A3XlKf6P6Ea/bjXxtmQgqBpP1gKvBEVoGCu6XUsgSBrC4JsgIJq/tBCyoXlXJceo5MY0bH7iw+7VM4gLo5MtFrrMBUHRDk49CkBors/0te6VAASBcSwOjTRZKiyXSNgihQL1FopKP/ST5SRuCC5S72vnhHwsQx6TGS1eJel2TNvYgI61BB6NGxy3+cAvaun4r8js
 diSHqcGf
 E/V/CaXuss8NzpyWoHmiyRrFrniP8vLIlpCpEtZzGiEQY78iMohpvA0qNBwxH4tlUhrm2A+MVmvLyoPFiFKV3e81614lnoLMMm2WtnOIeJj3s2yuX45/yukLyjc4xldRf/YM3spzyKU9Z9xV51jVIW2wZOdg8FTTsAe9k8kEdYvVvnlMDEaF2KthjkyhRCKUfzvCS1Vy+vc3FL6/EU2sEVQk78nSnzDo6OUgc3KGzd+FLmHycKu88JTzbpVMh7aTUGExRJw25rcFwuTrQcdmCf6jO540aqPUDI/lLk1WL1S05pJTthNzEBpoIMBTUaZ8gyjiWrWVZph6JhElHRcroRB9MaWaEj06EOzDN+1d0Dk5mIqGWZQuKv4XTvyeP9i+zDJUwSxVHaF5kSnaNO6Enefd/mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - __per_cpu_offset

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/percpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index d9cbaee92b60..0cfe4d7818e9 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -87,6 +87,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/memcontrol.h>
+#include <linux/kmemdump.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -3342,6 +3343,8 @@ void __init setup_per_cpu_areas(void)
 
 #endif	/* CONFIG_SMP */
 
+KMEMDUMP_VAR_CORE(__per_cpu_offset, sizeof(__per_cpu_offset));
+
 /*
  * pcpu_nr_pages - calculate total number of populated backing pages
  *
-- 
2.43.0


