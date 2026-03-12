Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C977DFED2C8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2666B0095; Thu, 12 Mar 2026 00:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270506B0096; Thu, 12 Mar 2026 00:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148486B0099; Thu, 12 Mar 2026 00:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03F866B0095
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:16:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B3F213B9DB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:16:24 +0000 (UTC)
X-FDA: 84536099088.24.B3ABC6A
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95225A0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:16:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=jMc+mcfx;
	spf=pass (imf15.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MhwVEJ1jJKHsVGKZZDwnOv+DL99Qt0PgcKelrAIpHWw=;
	b=HrD2d7fr9amvczjskJMcohzRm96V+wPCqL1ZNW1bBEcM9IA1mNTz38ze0FERN3mHmB3vz8
	ZaRUBHEGMzBl3e1As7kcE1iy4NUKV83MkWI2jLf8uSV7+NfOADZxlr1KhwYBd7dLQfDJnq
	S9tAd5JVBhtIMP/l7iiIjPVm5lGPL+E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=jMc+mcfx;
	spf=pass (imf15.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288982; a=rsa-sha256;
	cv=none;
	b=TXvlyKaFAJ90YLQgdGkDw9ShNUmnRybrXmaH4WUIjOtSC8++PIr24RtqdYvpGb6fGgT6Ad
	gldDLh6bhk/HeXJzimXCqz5Qpe8883JW5T3rqOnQrSjxeYKQJQqB4RAgd1hRPKxBPsw6/C
	HtKJzq4s6yyDiGKq8cVjt8GWasnyQZE=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c73c990a96dso161670a12.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773288981; x=1773893781; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhwVEJ1jJKHsVGKZZDwnOv+DL99Qt0PgcKelrAIpHWw=;
        b=jMc+mcfxbZYGxB36yBc5WStKKwiySo8vawqn3JSsJjnlAMyRnTSoWt4J45DQLLsjO5
         6Uypaw1XQyrz8e1ZNqPy07B+00lejN/le2ZhSyKgfgmLu0kgnRvq//h8pHZfWASQI+Mj
         WJFyVGl9gWslnPhvaC9JZw9LZ/Z4BRq8WIsKCtuO3Wyo0FTjV7D1htdDdSGeJOfnM07O
         Dt2fYbInSib0luJjrTyPDXF7JmbZr6AhOa+s2Wz6fTybFD1dI23UhrL/+ebyO9og2AEZ
         2QYm2/ocTr3UAU83u7ltbXzD72/+BZEBCaWqVLWJ4HFOxRyOFvFjDuv9PMVrYUGEd99f
         22cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773288981; x=1773893781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MhwVEJ1jJKHsVGKZZDwnOv+DL99Qt0PgcKelrAIpHWw=;
        b=GYBACFbmtnxZugU1x5OQD9HibqIl6P5twNzFyDXCjwUoMlTrfvurl6sRPEXI0Y5Bns
         XjGrnw1pgJYXx0Lx1Orig7UmJXPL/Bg+kSzczpNSYh69EEChP+z6+Vl37abvXJbD6GyN
         F8csIIqTAyk7al8arfrsKRUJjzhxUkgBAKc8dG+V0ZLmSS8+V5GAWdbUO1/S3TrAUChb
         GGaWRHugPUIyo52XtS1TsS7BPJLe3OIbjSnubEoJT74gisel6ytpHazJcgUuJdx1VmkM
         NIO8s+WAN2WDTOnlFYqWBuLjbuCOK4bPahXLAH5HCoC1Tx66AcfGp2hTpWLVVA6el3Cl
         uKLA==
X-Forwarded-Encrypted: i=1; AJvYcCXf+nJ+9QJ1889D+TyId0EvWfvWYe+axZhtU/S1I392uyM66KUQCv20v/ixnNVSiNZxcHsXsRRhAA==@kvack.org
X-Gm-Message-State: AOJu0Yyywn89EWtMbQNCBhXg+TY2GGeZ0rmwnok7fVr9TQk5JLB1kEmY
	jWE99REeHgjhcVqb2FNQ8h40pT7UpRH4dW/PQj3RbDa8fxK+yBnN+OUvL6o/GHl/IMs=
X-Gm-Gg: ATEYQzxWdLVElhkS7ottFSagG/pPQwkgjg/K5duG77Jg1NdfLzOON7QJS11AW+3tJyO
	tNp4oFdk5eRjUXlrYXUxSGiwiG1j6KsdFEAuM00nArQ9v3FWaX9agB/5PAnC2Y2fGy5sXp7ot85
	+X88Nq70F1qXBD7G6yZfcriufOxncyIIJgvR1JTQAukVkC2SC1hXOXobLv7T4HlGzr9+MNdBCKt
	mLdIeGoqn3GVyEuWz4qYXBkLZ03SnZ9fS2/rgrdkVHRtpdRbiS65ZzypTUngPzR+v34VuJkusB4
	zYZ8C3VaK71YmlZQpNMoSf1mhtHolJzBKi7f2DZaB1y9ncUa60itdmMUZ64wkPUISBzmYai+Rj1
	znBQaAAHRS4jf2poLKVcKiJyc7aLjCgbrnJ5d6lYY9yP3Z0616DtPxaER0qxFL6L7qRKdtnJ+DN
	1RoZ1thT/Zj8ddpyGoUemXdcTLluYz5PhsEKvhYSFpwSPwt8A=
X-Received: by 2002:a05:6a21:38c:b0:398:7c6b:8615 with SMTP id adf61e73a8af0-398c5e58d14mr4512612637.6.1773288981346;
        Wed, 11 Mar 2026 21:16:21 -0700 (PDT)
Received: from [10.54.26.107] ([143.92.118.3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73cdf9f4f3sm3780255a12.25.2026.03.11.21.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 21:16:20 -0700 (PDT)
Message-ID: <26ddcfcf-cdde-436f-860a-4cdf574e51bc@shopee.com>
Date: Thu, 12 Mar 2026 12:16:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 3/4] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@fromorbit.com, roman.gushchin@linux.dev, hannes@cmpxchg.org,
 mhocko@kernel.org, shakeel.butt@linux.dev, zhengqi.arch@bytedance.com,
 muchun.song@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311030235.240953-1-haifeng.xu@shopee.com>
 <20260311030235.240953-4-haifeng.xu@shopee.com>
 <20260311141928.b4291eae43f99a2f6912cd2d@linux-foundation.org>
From: Haifeng Xu <haifeng.xu@shopee.com>
In-Reply-To: <20260311141928.b4291eae43f99a2f6912cd2d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95225A0005
X-Stat-Signature: 9ehut5q1ke3rioddnnc4gz4q9pyyaffq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773288982-876901
X-HE-Meta: U2FsdGVkX1/KdUxbaxVHlpDV/rEYfBgItremjUUfWoxcGBS43ZDSTI6MHnlmDlKFtT0C6aJcmjrI7pk0bCXn3u0lQRF/VQk6b3DL9op2OAVsm3IIrKH9KSQjNG5zdCq4H/ec36NLjCs6kLe9sVLSs9ERNVJca0y/OTb6aj2DiIFq6YUOBlfj5DrMXLsbCrqVpPLlAnsB+bc5Xa5nASVWiJx4TYJjSuAL0xfksUgqa/gMcSv0CxVN7vKMlJb3hHaTbDTRb5EkxkSyLvnHMOfBCUSXRsEcZGYCh+i/68BliasoqjQ5wmjfPzaKQMkpFV97C3zv73eKcZFmrcmRbgy/sY69qckL0W7GpFCtdoFRrel9KMSsjXHV03b0jk48cg3IWNV5qMXFunO2VLutcXoe8xim10x7kM5wy3hAvVCEjI11/IWdCbASQLMWN9zMcQRZGd/h1oiPN9z+5l0KOL2O2A1YW8NRLJct8XGY0DIg7fd89emQ6qKL9ZxazwgskgoriCfl/zVoHu3KmstNK1DWjIKfdrZQPTip0CJw/bKZUo11VZnglI99Jhx/r5F0mH0zHYPp8/eV4k45Z2s7y+6hO8/EFZRL7qTJDX1pbvagA7JT6reCZe9PNJr45HHP+cv/7kJp2sHc95vFJI6DcaHihkiz7oMeSKJhPViIbbNru4dVG7QDJCD6AJESGD+d6Hy0eOahfU4d7WXDO1hr/+DF7ytSHnPtLoaYDrioLx84ZEnXzetu3W0/DazfCTxK1YSZ2MaKZSHHg5piDgQeK9JWMG2BT0D8EPTaEyIsNI2UURui0raYut9Ws/eDVQaOmYHCuE9KEVHFghBmtQjJQNjMDLWqcFp9G6800/GKttt7886FEGbvk+f5m7oRml7STiCif8fQfBuhdvcFR4JIa9o3M9MQI+bI0dJhoTaTQtXZ2i5y+KCLWcA/O6utLg6FLmNAH55Uy3Cl0c8a9FnamYi
 sOYuh8Rd
 ymtkDhKK5o6q4j9StukWorGfeEd8FlYUVPlGX3R/kv0ien/5704FcnMQgd/ZzxryrBlgTFKMe68MMT7ff+aTOqOfYzhG2XZ/k7ktjCrQL9F94h4QHuMtT7lgHnoDAq25OSa14wtQtfJ4qJmM+M/KrmJnNw0lruSpXz74u3PHSqvDqNj0ST2MERWqvFIwZENdLECF5SqGoSAZPipxA/ghSgNvHH7tbY7SoXROjw8Q/T/Sf8B+MXMUbn/5/b3FNgmlVNLgscisW8cJpGYG3CRas6uyLBIYMjznOj6uz2A+YceXCluQigVvMPeLxhbpsAEg9iHv3Il7Gkwl/8Zr6SSWnJU29aIajyOAlgHCB/DOjjqqEWlsEecsV407G+C3+hPtSQKuqNlCv36OYrwoodjxfdE8hvA6oKF7Dwj2Zyx7o92iZFmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/12 05:19, Andrew Morton wrote:
> On Wed, 11 Mar 2026 11:02:34 +0800 Haifeng Xu <haifeng.xu@shopee.com> wrote:
> 
>> When kmem is disabled, memcg slab shrink only call non-slab shrinkers,
>> so just allocates shrinker info for non-slab shrinkers to non-root memcgs.
> 
> What happens if memcg kmem is enabled later on?

cgroup_memory_nokmem is a boot parameter. If memcg kmem is enabled, all things
keep same as before, root and non-root memcgs allocate id from shrinker_idr.

