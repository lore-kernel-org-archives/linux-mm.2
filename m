Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6579CC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7910C6B0098; Thu,  3 Sep 2026 10:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768AE6B0099; Thu,  3 Sep 2026 10:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F926B009B; Thu,  3 Sep 2026 10:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE506B0098
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:29:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE09E160501
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:29:42 +0000 (UTC)
X-FDA: 85172684604.06.A88356C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1034A14000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:29:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AelKzxvN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788445781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uRn6skkiCRR+c6DEQIznpHWiM4x0rvv7bYO7f0wU9A=;
	b=3n6o15aP9JFsWiV1RkZZ0vWRJizORxOTsfFlBUw6lxoTd523C+CtJH4FzHgH9mye4xo4Qj
	mNiUF5ayeQnEAid6sPvmf4suBKycDkSxxGKU1ytGWuV4PTxm7FMBFpXpH2HPLMD7igFPuA
	BujtM/yJ+Ak4ieJsxgfB0SteCJrUEY0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AelKzxvN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788445781;
	b=OycGuEKrjF3laAOOkMECqnsYMoi96hOS6xksALnSMR+4uUsnJDpjFKnj/s9OojsvxAGLEz
	8JjXe2kWQ6YQOdov5kH1i33ISaObyi1zqcir2uNrb3nnQI4h2LCEFhajtdPSGvvYOtIomu
	l8p3WxgIgz3M1XMQPlLMzvGcJDQgsAo=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d9b60c652aso24492155ad.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788445780; x=1789050580; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uRn6skkiCRR+c6DEQIznpHWiM4x0rvv7bYO7f0wU9A=;
        b=AelKzxvNXwnyzhxoUQDf22e1c/9PIRv1sB1zFuElPTlPFpmU+FDsuw/lW8YNUGwjxW
         r6t1Obyhq8XGGNbsfzl/rFpLOMq326MN4tn+4/rO9d8LpXh1P42r4LrRg9KIi2Zjfdzb
         C7PgevKAFH98Ui90k/8lnPmjgDdoaDHVRD9YHgOgLnRyGUG8k2sRAatv0taVfeHNu85A
         3Ow93eKYMUY3RzKwFn9maNGW4hPmOrpsUhh+m7zFVyXhNzf6AxtTAI+uJ1zVFwJIOUtg
         yNVZALEjN37+Ud1lK6o1OpbWQRWs3z60VGTNRp+6GEaKQnedYGMup65gGZ1PUvsxYOAd
         p/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788445780; x=1789050580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8uRn6skkiCRR+c6DEQIznpHWiM4x0rvv7bYO7f0wU9A=;
        b=oiy9+HYMs82wPIlq6K4htkVVWIueN3M7ZMnzNonqotRGJnhCqdNkv5ow8RSz2xM/vX
         sDoievQruwFqGaMbMWQdKTydr0ptEYGM3ev6aevrbq/15v7ug4ijTjC6U7ZvaoRDpd3i
         0NCdhQXIQgLJuuSuifevtj5uYQfyD3tzX9f1G2vftzVdLEkM6dsHIYS8mxkHrNrglA7D
         Yx8HIF2e/qM/NXu039oPUwJlwIXNrLEmSM0bRODALQCFooV7a5zhR+8Rjy5lavjJS2ha
         wPmINPRow5894bGrsarh8WFyLcqXez02rPwjDBgqx5c8FNbQYyvfVXa3dUTWe+FR0Kyr
         bmPQ==
X-Forwarded-Encrypted: i=1; AKwUvBzl4XcLis1myG01kvh2MmPwlZwYcse8HGmg+DZw0lFgu2YNpeIw4hMU7u6Kub/YbBCTrSqKd/JgUA==@kvack.org
X-Gm-Message-State: AFuF++mpiu5J3LmBsZTkWma6wTjJ1w7o7cwtnGRDdcW8iydVKGPBZp6v
	qU0YKpfa6kWo2K//Gueyj3ssUh78or2qUAnyH3gNJK+C775nnODMp/FV
X-Gm-Gg: AYBFou1qq7HaI9d2CSCFbPCUwsi6GXTOJj9nu3CoJP9Px/xIxSMy4GIsq3Z4HQ7bTbw
	RC7R5jI9kcg3QeTZ6iBfKVrsSCqB+cYqQ95+xGz+JTv9hxEiG2NbESmVbPxPHpPWiDF5MsxtKqe
	hlD2Q3WuKb8j2rjwrqAwLueUnjnl5FRkAmg1u22w9frunEMPr2sRtxltjbaHzWTR1AgNOBgap20
	xP6BWO0SN2ucaV0jsWEhKxHR9ri3q0JniVyhvRHYebTf7Q57t8XLwXQEqmVf1SE73UCZgSXxDDG
	tbCJJnd4wU5AFOoL1I92/tj0rVbsL1YNQETpnNpQ4l8EobIc2Bkav0bdJE+HovDHtUR344QNe06
	JpiDoe5flIcv5qUPRBcjReymyBJVeeFgti7YmxmCrnyOQvLtZm8t6M6aOVlFRkfsZ2s47unfgtQ
	aZdoxBMgxehy+xSE5ZZzb7BoDermxmUoNuUcsHJTfVVlM0i0XZbkWGRQUuZfkQ8U6evkopn6e8a
	22DbkqOYFs3m6DU
X-Received: by 2002:a17:902:e545:b0:2d9:6db:9fc2 with SMTP id d9443c01a7336-2daec6240c7mr160309525ad.9.1788445779634;
        Thu, 03 Sep 2026 07:29:39 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafe927928sm11174225ad.33.2026.09.03.07.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:29:39 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] mm: compaction: skip isolating large folios that satisfy the mTHP order
Date: Thu,  3 Sep 2026 22:29:23 +0800
Message-Id: <20260903142923.4108729-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260825043833.2659350-3-zhangbo56@xiaomi.com>
References: <20260825043833.2659350-3-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1034A14000E
X-Stat-Signature: hjt53g3b1wo11tsuceyj8ofaa1qfxfpd
X-Rspam-User: 
X-HE-Tag: 1788445780-37587
X-HE-Meta: U2FsdGVkX19hyMDIQuNI96vOjHWuxoxTBnD0Gu5g1zNWLpDM/oL0Fe7xIHic+Jm8i/f/n19qJD+0elWtZvkXsUsyDqqHZKv5HV22gxqVyfYmjXjKsQY7MarhFNGyKzfIiZNyIEKldTvsuxZWadjn9bjE5q6QXAGGaDe6/oMQhaHfqsnsDWbWz0cb4804JerQsCt5FcnxhT8j+HNANHb1LTUYrSgf2fU7jKaLaQEyeTPwin4hPrkbUdq64OydRp4KNgDpEl120G+kw8jma+9AmwO2jfdMfr1706iSqiAb3nPa5XC4NXpp/yVb3AOLPF4sE8TsWh72hklaOZpsjgqYVuR3qavpDKaS5kV05rWkJj+otenqSDivkxci0njpe53CFLdXkYqGfDYSLgwjRyauzjApmYqq448nsRJHGSNSlPdFjG+ToDDPEjc+61462gLTPe64GDiMhUIYJOfj7h95ZQ9pxgix7IgSzfobBpyK67m9wO6iHMDNl8li5DYK75r7JH+xMaTQgzg1wtWrru17sXWd2h1HWFQN0WzTQrI7KAvp1jeBBlQTUMlLrxJGcIOotLcsw+BQ5Khr4hstpRl6M4pgv4+luA4csWd87sOcAuL3ILoRHwvUwgZ6sazPqvfB91Da79+EqJgeCRPBzIenIUi1rBzSyTL/VMXs2UNBLFAoh9UeNFV23u08Qrc1v9l8GmCcgA6TVKe1v+/uNbJDtuzl9cO7n7mo1hNThSkXTK9i4PYhRmrRArC/st4Z2Kdoo72qN/7/Ey5ZmqWUu7fyamRUOx/ZmYmZDn3yZXLQY0qcvxZ6ejoSrYi8E2nW9ve/vOj3neowkfAzw9pMdZOMaamrim6Cso3HQNF8vBT2Yw5Ch8VeKHAk/nTukepLYklvccvlsf7MnKB8P3VdKOAlOExAQqkP3S2NkFl6RRB6QOjwXdAt85xGGpYsDaLCe6iNN9njSogaXxt1mOcqIao
 fheaybYP
 xqcjNnn5K2O6fSDC16tTSeVfQjnsFbB1ptgam33uAdy3zV3WngwK1eiyZYlGskDs+ODM9OP5amyXqPtEKw1kgbBzMwg1FdeqkkuEjmXTisn9bHezjK2dQ3GMNAcIPVr7c6sKxvYVPOj/x0jr+b1YrDCcZT6W/vrZJGn64vPu3/qYHsSx+9Q3Iz0yNj1cuwt5UwaIjpM4Y0Qkb0jvDRISRy+iVD7KC+VV6wLRWfAmLto4QHdCoZ7s/pNM7beMUmv3J/hW553MSU0pyln3Gy4YcEV5oxg4x1sAuBXueKV0RWNgsIYfsBLU6ZuKZFV8HUYAxnNRQrgPTQ7yPSwpEBFd2yrSUim1G9dC176t6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review. Replying to the two points below.

1) Build breakage when CONFIG_TRANSPARENT_HUGEPAGE is disabled

Sashiko says

"huge_anon_orders_always is only declared in include/linux/huge_mm.h under
CONFIG_TRANSPARENT_HUGEPAGE. Without an #else fallback stub, any kernel
build configured with CONFIG_COMPACTION=y and CONFIG_TRANSPARENT_HUGEPAGE=n
might fail with an undeclared identifier error."

Correct. In v2 the huge_anon_orders_always access is confined to
compact_hpage_order() and guarded by #ifdef CONFIG_TRANSPARENT_HUGEPAGE,
so this call site no longer references it directly.

2) Skipping isolation harms manual compaction and HugeTLB pool resizing

Sashiko says

"If smaller mTHPs (like order-2) are enabled, compact_hpage_order() will
return 2. This logic will then unconditionally return true for any folio of
order 2 or higher, skipping its isolation. Could this cause administrative
commands or automated HugeTLB pool resizing scripts to inexplicably fail to
allocate large contiguous memory blocks ...?"

To clarify the intent first: when mTHP is enabled the proactive compaction
target is compact_hpage_order() (e.g. order-2), so folios already at or
above that order need not be isolated - migrating smaller fragments is
enough to assemble the target block, and isolating larger folios is just
wasted work.

That said, the problem you describe is real: compact_hpage_order() is
derived from huge_anon_orders_always, so it also affects manual
`echo 1 > compact_memory` and HugeTLB pool resizing, which legitimately
want to form order-9/order-11 blocks.

This comes back to a question I raised in the cover letter: what is the
right way to determine the compaction target order? Deriving it from
huge_anon_orders_always is convenient but conflates mTHP proactive
compaction with these other callers. An alternative would be a dedicated
knob (e.g. a sysctl compaction target order). I haven't settled on the
right approach and would welcome opinions.

Bo

