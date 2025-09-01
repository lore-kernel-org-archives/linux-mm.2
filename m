Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 603F8CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409F98E0026; Mon,  1 Sep 2025 05:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAC18E0002; Mon,  1 Sep 2025 05:19:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D5A8E0026; Mon,  1 Sep 2025 05:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4588E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3342C075D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:36 +0000 (UTC)
X-FDA: 83840133552.05.2981F81
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id C21DF100007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NUR2By64;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQi1DlLk53At+sb7Dxdlwb1wfYNq5fMfR6Ecet/hRlk=;
	b=a5rFQ5HrZvHZFOjoFj1QFF6AVrAUKZNa+nPeIR/1/wF09D8iXIXrV5JWKANsZpUxUqYv+6
	bgYO7mn0fjJZdomtGR0OdtVucimzzavB48uy1Zp0k1X6A0FVlHMpodclIvVgZEtsXL5E1F
	M6zdjAel9r4vXQvb2igq2LXRBy0z3yE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NUR2By64;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718374; a=rsa-sha256;
	cv=none;
	b=gP40dh2p91z8WAhrNwz8dnbA5q3hhPsvnQ5E8HdMU4+jlOCKWV/byVyg2Cy9MVaxFdGOHV
	9kVgat4ziiNUqgmpuw7S9plo28T3WRg8z8oYv7mbKXWsqxzvGKG0c+c7kXFomCrpgCLAqB
	ZwUCVvMo33NMtMU+dC0giCtAsQxaB8c=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b0431c12df3so89346066b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718373; x=1757323173; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQi1DlLk53At+sb7Dxdlwb1wfYNq5fMfR6Ecet/hRlk=;
        b=NUR2By64WT5reimuU3WafyMEzCgQOIXwowSkTAWFy1cpDSkB6e9CtZjCAseAZTSQGp
         87TcDpYLH/amDxJQGkYqyr5rqJlr7yp8CTYQruN622OuttWugOVNVLxBRFxCnqvDgjv2
         cUOVKqFcEnYz18Z10KYS5ExfsUyFaWbVhHtjHM+RdMf3UHUXezP5wxUmv7Pq6pFrrwhd
         C4SDRLK6i1rgwKI3Z/PMv7wMrhkw8vEm41xnPrbRkX6sqlq4K32BJHcCe3gr3ewyNkW/
         TTc6RzQwcNB39yFClIMbxQb3rOFjXHEdNVRtP4yOLlJppFVKkmgZcRCRtml6ihRFb5Fj
         PR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718373; x=1757323173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NQi1DlLk53At+sb7Dxdlwb1wfYNq5fMfR6Ecet/hRlk=;
        b=jRTuBqFnBEPawEowBChUIIItTZDrBN201Do6SlGJyc4LEI0S9ZLM5Y1/R1HnPjS/uz
         /IHoxRMEueu+5EL8R3ypF9BqMMAbyzC3CIsNRptSVi2XK0ek/EZ0BcmdAMbp2l8vVAhL
         HYH38tRl9Eo3rZRTinTEGOW1OMEdJFdjSNx9xT7uwc6Ta8u280snHaNNxWtKq5Z+ynMu
         kZhG2F1ohc17VAEo679Imwhc0AFjrVA4DoUe75fjqaPE7+nDJdlILmd/jLzLAr0p9eeq
         3tn+53cQT/CxkYRjArXhz1F/F9N4zTfSHCpAVzUrn1sSw6p844cs8E+V70sSepwV9dvY
         QYtA==
X-Forwarded-Encrypted: i=1; AJvYcCXUxEhYCuAsFczCShPBic/RGAhn72ac32paN0XvTTtGncABwvKQQa8Nd0F/OIHEa1d/ohsZWTHIGw==@kvack.org
X-Gm-Message-State: AOJu0Yz3jI6fo6S6jzzSolBStTaFRI3EBvPgOlDCRccrFOiq6m5S1kB/
	ymhL5HLwzuzwNiOHuUjp8G1WNDySSX3NqmSv/KU5h8K+gru19yrdwhuV5ShhwkBZ0xs=
X-Gm-Gg: ASbGncuztcSaW3TqXiq+W0K7dI2Y7uxsjKUmJZb/ADN4VO+riUGBbNXqCDZfscIE7ai
	1Ti41hQaPZadNIDuKPD+yv+HdQxHAWG8bps16Xw0REiAQeLHjURNccDCdP/xX2YO5HSMg86Ogu3
	G0EXSKd7jEPtXjdwIyL4WdpPwC7QO+b9frPagQcbN3RbfI4LR8cdI3e5O/m5wvkzAWYRvhREf0K
	3KFsrLEVOsy+ZDICcZ3aDe4nGsn6b0hRTYFVGDIAoYTBoFDSuyv7uQHK1GFZHnv6iCCq476MFGl
	fwiiNUx5pbAMFpxIiQvz6L+qlqbKguKRYmc1CQzFdmFptXRdtifbP2Ptu5JnhzXUvvpdNUNJ4Rf
	v3NuoZ1YYKaSqdS7Lk1jtWZwi4J2atjPwlfLvszfs5vTqGU5PDNaUGyZz2Mg8qbzRFl9ELuYoe1
	myn8Ycj3XdDtTjbMmnaaDOs3LiwFQ8TPG3
X-Google-Smtp-Source: AGHT+IH5BJhRk96TYnQheCz4kMoEb798UIqHjGpro1uj3IPOuzj2UHqou7p2evmbnRgTw9WnBmZqkw==
X-Received: by 2002:a17:907:72c8:b0:b04:39af:bee7 with SMTP id a640c23a62f3a-b0439afd503mr119373166b.26.1756718373122;
        Mon, 01 Sep 2025 02:19:33 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:32 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 05/12] mm/oom_kill: add const to pointer parameter for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:08 +0200
Message-ID: <20250901091916.3002082-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9m9uohrumppnft3i4mzsd437wxqhpabg
X-Rspam-User: 
X-Rspamd-Queue-Id: C21DF100007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756718374-108796
X-HE-Meta: U2FsdGVkX1+Q5lVcO0aCfLiiJ5jSuHFZFl4TUWyqEUQpuQDbhBQw2AbVqpzMa9pUw+3smIdU7WAn852/zRv90NS1K8zdsMK8GJ0Oed+gKHPRYyO1krgJotB508yBj2abI6aUR+fwXscEgoKL0Olc1N7pk43cgqzNcnlk8dHOgRbmhahpSl2NhBbI60Yor0qYGQIMd+aslFYIcbAslXSaVbxYTAwtbMW8VCcOAw6Hvc0EaR/SqsgDcNDAMgmkfSgQ8ISzEWeuud13hpXRSmLRdC7oqNWNKOYnPA9zf8qxnKZ4GhSq1FdrZm/Z2W5YG/O2r8U2ak69b4K8pPYf8pmLpWyqWS4Dm/JfP3BcJ8yBWGY4yvYygetDwsQJ31vwnglV70CQIWpy3M5TvBV3pML5qgSB2HE36clPrWFXFLiHfVBzzuPm9d6Ixg7MWJ8CnGLkBG1DtSKHM1MGBvptrmDQ6WXglnAZba5sYXwLBLmGjX02JWWXgq2QWrfd5stlCrBssaT/5fF7KTqhPtOHHaKPPNcY/QNsOT7DmWa35SjQogsSI0dAhYyAcMtJJstTg5CF1kwhsS06RcKx4RG47HpqaeeLG4y2pPMnYVbk9hRUVu2xMH/7U8H7xJDWT6cxTm9KHgzH4U6+4ZTif5qwXq2JAr3ARSCqkeSfkA4lk2WuJrbIGhwJrD/QXM/ybZdEbv0nDDLQTjyf9/xjCh0/8kLYZL5tcJtF7+t0rrT8bb0U5jotHhOPz1286d2G60RtC9n9QyV20py/cEIS759ly6c7cx8Q1GThKBhsB6k6mWjhSyh/ff/rnVf4x2ipYUnYEuarEVY5wmeLvep7zHg7V1OnUFm0YVvUkTbeTbr6QIDi1IuYnx+EzHcZqawXyagY5HwdfmFHa2jYXB7mSgmbFNhZUz95umBxQDb7M2iLw+kraklZqs/KfseGhIES9zn3ELcUc/F1W4JAQMRWa+Fmbmb
 aWCnf/b9
 YIphD3mgV7MEqDYpQ8A4amZKlW1b4l4MMssbAAE9j8cgRFnXWnBW8zi0Lnr5yfo68rCWwvvwfFXTddKj4ru3HpF9Y4om4ues5kTBQ4RaxDFPcMcgpddJbwImoSbTeMTipiazHEHUXi2VYh2uSxmyb9NFW5XnRpGTkB7v5d34WwtAxZwHJrBqCM55wq0AyoEj9r1REO46ZQuguoXXl8+XoUzyhTA/U3sPqjcGSuucQkGxuMx8IysLF93Fo+qqx0vntXo+oqFijdBvedg/i8oLWOlL/NLRVMiWgAD9lwgExpj+cesLUXGb2N2zFLX0V0rL+MdtmIuvzX9W6eiJoRNJ6fbifbHx3kevg2OP9uulmMSz3fxYUbi1TZSMduy4eqdY84Yeeh8lVYWD8NlgI0G5zEqaoK/ju+l6ogEieO7ZcZKYtVRWb1jQ0MQuLfGMEV5hjdQu+pGH0Hev6HcMSqaEW9VdDCdSWsIGZ5/HMM5CfThO7gvE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to task_struct and mm_struct pointer
parameters in the OOM killer code that do not modify the referenced
memory, improving type safety and enabling compiler optimizations.

Functions improved:
- process_shares_mm()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h | 2 +-
 mm/oom_kill.c      | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 18deb14cb1f5..f70c6b4d5f80 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3840,7 +3840,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
 }
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
-extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
+bool process_shares_mm(const struct task_struct *p, const struct mm_struct *mm);
 
 void drop_slab(void);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 17650f0b516e..2620b32a8eba 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -490,7 +490,8 @@ static bool oom_killer_disabled __read_mostly;
  * task's threads: if one of those is using this mm then this task was also
  * using it.
  */
-bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+bool process_shares_mm(const struct task_struct *const p,
+		       const struct mm_struct *const mm)
 {
 	struct task_struct *t;
 
-- 
2.47.2


