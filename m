Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880DECA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295126B0111; Tue, 19 Aug 2025 09:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C7D6B0127; Tue, 19 Aug 2025 09:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182DF6B0128; Tue, 19 Aug 2025 09:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 078B56B0111
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:50:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B205A5A230
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:50:22 +0000 (UTC)
X-FDA: 83793641484.02.3656448
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D7CD1C0008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:50:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N09qe7qf;
	spf=pass (imf20.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i9TJ4yjgH6QJU6NhC4uJmmFxWtgzYAcw2NPkZcqPt60=;
	b=YFmNy78Ks8PU9X243ef4HYRkl7M9vJlcvJJ/UEurSEtLxYEqxFPHI6umXF75m0Cr6hk4Xy
	Rs/GYclpEY4E6gOpL3QrHtGLhxbjbZ8Im4ZZxHbhy2tapE6F91pspBGYKCFD26NHVl+cZt
	uaMqN8/tpYEqM5+6XzJH4uqdy/L86uE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=N09qe7qf;
	spf=pass (imf20.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611420; a=rsa-sha256;
	cv=none;
	b=8IVY3jjonjAsZ4/Uux5437Wl7SA3N3y8LRjYvzYRpqlsab6TsdLfV1MGXZn3qquIcfCIw5
	e+7t3jex5+22wpQ/SusykTxG6ixPPtQYpHIUmiancum+urZXxnfLjDsu7W3POJTbkW8nVZ
	4uPSSG9AJjijkTVNHy8T0xUwIOsIiXI=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2445827be70so58663825ad.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755611418; x=1756216218; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i9TJ4yjgH6QJU6NhC4uJmmFxWtgzYAcw2NPkZcqPt60=;
        b=N09qe7qfhQaMXTBnjXVlJIL/BXg0PV1bdu6JGsbJpSt7phnRFsUDY5JQIp9k9sgOiM
         rLGfLBt6nYGyC9XuPPe9C5KQFgOZwyiEI3UGmR9rfBdGh4I2/46txWvMcErvEUctDYpX
         KNZUxHaiw6D0S4s6LeTWSbR0o2FaAiIUCTJzAINaOuDzOpxfWPctAr861bOHJITArEfQ
         ufGT9LecLOKBgzbjBrOLclJq+Uxc5l7udRV/LrgklDyZVJc8lNnuUjjGBBYKGEyXe7Kd
         wxtOoYt+0xsuXlXm9iNEt2FnkS/GcBxfbNVA+pd88lrZDNdQ1sxxTZ13kg8Ea/B92rcK
         gd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755611418; x=1756216218;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9TJ4yjgH6QJU6NhC4uJmmFxWtgzYAcw2NPkZcqPt60=;
        b=LNfkwjaWDerSFevmDxyNOqS7NPSA++WUj5yqrCVgQsoDIw0l7hIUS/WvHLLUbYKZTC
         X/q6mFeDCdDf2TA4PoL+fiAlyaa7I1ftT5D6kBFsyfqha8eT20jjSmq0W/lvcnm2jK7L
         nQ/VUQqEoZMm2+iqtpSSTSGpuQuvNHLIK4sPpYSfmlanIi5CpWkSbZD1byLKg83AnFmL
         FqFFbSNuz0mliSdFAQh07sTAMqHELAXecNT+sO8SY41rebLJB4BMg1gx882vrqEYZGUH
         W8tjVLb1wQRs7fFQpBefG9ixSfkGIbD3z7PvqN/KWu2TfHw2tO6jlLTZ3XR5QShm5bSL
         Qi7g==
X-Forwarded-Encrypted: i=1; AJvYcCXSE6+9sTJqJneuBEgYJKp/7s0NOLHqtIlWc9tQXkwuE4LeIudGIgvM92n9JGBe+9p/AYql4Iouqw==@kvack.org
X-Gm-Message-State: AOJu0YyS4PEscbiQkC4LdWdzZs2XfTPJIsTlqUnevMFr40DCf1ko+Ma5
	ZUJh90evwfGWiYrhbv6wI0eBN8X+6rg7xL2vds7V76Ef7Y5985+dXkjWS7cJ/soYACc=
X-Gm-Gg: ASbGnct3ZzJiCFbLBTWNZY3hvdggfUikILgap+HeU0MZM10MIpFzl5ZvYAOx9jP2YV4
	zznkD8G1i0j0K9Vxk8km9vm4QbFTO1ABqrSXyv3yA3yBxAF12IN+dltiCIwLNArp2T26cxQTQj0
	IgVTuXkj7uuSgHcW76oyu2F8RvZKC9qmkMV1ABiKnFCb/xd2qzfJEPUrfXCKlsw9yG8hY7ky8WC
	CHZFf8DAKXs2nTW1eWmqh9GaehGu0e/XClM10NqLUJz9Pzx91pFPB/utSBaVaT49LLu0sxxwkC+
	42JmnNpPRgo86IVcHfbVkDUVyGqG5KxER9iJVIXweKDB49C5J0dD4KHgFp90P9ZAEs+02Kv0sGd
	OP0JRVk7smbqOzCSOGdSj81ZinEB5uv6SU2g0eThIX8pWfh4/0uwiRCua
X-Google-Smtp-Source: AGHT+IHZy0Y4108SytN6YUHUMh4gN5FYzipiyPM05e4guHvSQuE82DjG6I5AZlKeM5wR3Grwk8hS5w==
X-Received: by 2002:a17:903:2282:b0:240:a504:cb84 with SMTP id d9443c01a7336-245e047bbe2mr35948055ad.30.1755611417766;
        Tue, 19 Aug 2025 06:50:17 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d5533c4sm109937815ad.140.2025.08.19.06.50.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 19 Aug 2025 06:50:17 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	linux-mm@kvack.org
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH 0/2] riscv: introduce percpu.h
Date: Tue, 19 Aug 2025 21:50:05 +0800
Message-Id: <20250819135007.85646-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D7CD1C0008
X-Stat-Signature: 9pa9d99exwqx75ga9dmyqfkr1wijt8we
X-Rspam-User: 
X-HE-Tag: 1755611419-489651
X-HE-Meta: U2FsdGVkX1+1eSr9Xu1pUZpzHptC0LrhNur4JQXc8OIMNbP57DJ9mnGHNVsRuunRVxejWTTLB930pXUJMN68QCnp9O2cXEfnu0pFb89GN+z4hljgcQZtEhYtgp/jwfDMwmKyikt372jEJEGXbmBSDxgsZShGqyJnAtWNEeyRXa8e1Uyq/5I4uFy1ROkpHBydNZwQ6vBUJUzOMXv7/qJ99dPOgW/wBXUNWxv4q+8XSD9L6a9sksa5Drm4qSjLvlPnZBztKDg5aqD+vVgt3KAjdGwZ8/zQIPLk2CnI8POpjLltXF2P9CU0EU1KD7Dv9I8/Go7R31zEtVjjwD6kApgcwfiQeG4JWtYRA2Nh5wKrC8OGhl12RF0JmX3fKtbIb+ju5/lEIkSV1JSZGwgkfBq5abjKhQJ2okzMkHlXUqZOUFyjEiUwca5UsJYYo9QTbduPdKDiJR9uLAgnATWxrkRu3Qf1fJiGPN/vb/wb9UKPzrif0DMHWMWisuy8xb2+oYdWtcbnyb68eO8lwPKpZZwaMAfyyPqCFRZb4SmQyLb0Fo2gvATuycYhf+kVtCGahmFzHqQRB9EtfNODz4pcL6HI8Xp0JvaJC50+HYl0KuRhQmSvDhtQF7wV0r5vmzm68zx2J/RTRdcY8KSHvS3URYyUEoTZsKk1N5q498A/zbgrjCT6Mvw41u0E91KyQYVEqJtiOVBsw8v3GKT0gDkTSyZSJCKwdHPso/20oB+zKHiiLVpNqK819ne7jnMojGsNHzwFFsEaUnixM7pvXz25aCv+nh3Yos1y7My9hZh/XtLxHCyzD43gZIS3MVNIW4NHDtzZIzgHBYV9/upCjNb0dvfpntHOwkNDzv86h6dwjvzlJ8zMjKqi0+q3kL2qJWwmBpQTSFF7vZf4J9nImghAxxm5Z+nPLPTodprGnTmFodPhfxfggNceu//IFVoQbbFJAk/icKUJhNqeZGrGaDUAquD
 S2BhkOCQ
 XAFVFdi/0mBV+V7cH8T3AkVfglbZymoeHGsB6tTf189DhVYhYg1l86PIYrhLZ8HWBmp5SDtEXhkeEEa5wYQMSUR0GWjuCLa/hjiuTQjCUdk49l/g96y2xqHn/4vBa7XIdM/p5KcXffYWXyY/GX9lKcuk6zSSlHFT+meZ2lbQwO2bjtjV3f72v8sf6+EJ85Eqcs78cB24QpaS1Xmu+vDSC1Rv9NbmgYn3a5xMR8ydZ9smDaWJeXNU0KblIjBAXSqEAstKYWHYtzql/wvxJdUAlhnQBkyQvQG3TJC/xZ4cFCBj/PjgeyatRTNMZf7Sz/HppPexjyU48+uafsit0b3zTTgH0lhKSEwemjoxC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current per-CPU operations rely on generic code using raw_local_irq_save(),
which incurs significant overhead. This patch optimizes 32/64-bit paths with
RISC-V atomic instructions, reducing overhead.

RISC-V lacks lr/sc.b/h support; without ZABHA, emulating 8/16-bit operations
via lr/sc.w would require complex mask logic. However, data shows 8/16-bit
per-CPU operations are extremely rare (single-digit counts in boot and
hackbench tests). Thus, we let 8/16-bit ops fall back to the generic
implementation, avoiding unnecessary complexity. 32/64-bit ops use direct
atomic instructions for performance.

Yunhui Cui (2):
  riscv: remove irqflags.h inclusion in asm/bitops.h
  riscv: introduce percpu.h into include/asm

 arch/riscv/include/asm/bitops.h |   1 -
 arch/riscv/include/asm/percpu.h | 138 ++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/percpu.h

-- 
2.39.5


