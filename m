Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5F7C44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D5F6B0152; Thu, 16 Jul 2026 11:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD8A6B0153; Thu, 16 Jul 2026 11:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC736B0154; Thu, 16 Jul 2026 11:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19DB46B0152
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:14:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A896EA00CA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:34 +0000 (UTC)
X-FDA: 84994608468.22.B5BF005
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id E56DE1C0005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iXgljuNI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0haKjxFEA+XqfWLiPeMGRklJhvkZG2bsdABvuKjaV0=;
	b=QxVOuDVYW09QGm0viplkA9AILC1rfwwZKc5nIuOUaQEaJAwcSxt0zUPNOwYUnlwtwm/1co
	DbyGGAdbnHD6MQzR0jJJq0PSpZeXNn3Bz0tLublDzwYme6uWly1VSmUEuNcvv77qkOU6fL
	hsxK6PIjSsIWn2h6drhW4DOjBTIRh0o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iXgljuNI;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205872;
	b=CQ0FPGmKY5f/y9/E7d42JEcTyCTuz1fiznUgotMMLYEmoeizef46WHO4Ixrv9gso4Hl9MH
	AE8ew9uJlnYcHSeWQElFlaChFNGDOXwtCzX/xnAb/N8TF5U/wfVgc0pmChcKnDsJ+9NkUY
	kZAi56PY6Y4z23/VBjxJ9e9+QHdjuos=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84a2dcec51cso5131607b3a.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205872; x=1784810672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s0haKjxFEA+XqfWLiPeMGRklJhvkZG2bsdABvuKjaV0=;
        b=iXgljuNIn0PaYCvQ4+34e82pzQM7id5g0PL67+T8XJvGnvRySFlfuZk8K+dcENpit9
         TvY4q7lEHpMUK2IdoUNFtYoO9D7ZPppW4Dy3D7EFGuciy3SEJpHzQEZwInla19AmXCLg
         470aDx7rje8E2u+Q6rS6WEdSUkoFQRIdjLZbSMjv5dFPO4AmF0TtPh2lgBO3Zoh5cAHa
         TToNi/MxLgTByE5AQOosck7f/6v3T3sXDhDE9k2aiT5kJPvmUIRJAI+mEGUDcL8cyUAX
         euoEHzz2ysFkP6WYbS6acDSe9yL1SB8MGO37LtfkjbsDvGN+jNWJk19NLN6kZN7y465c
         vPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205872; x=1784810672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s0haKjxFEA+XqfWLiPeMGRklJhvkZG2bsdABvuKjaV0=;
        b=euGV5XJEMg8+LWMYLVSNi4gvQ2Hw6edexljJXx59/K5JpAcu27tlHJuKrXg3G2wfgK
         CO+WRDXwdLaZUBRNXGdjcb6vlgVs8k1Q/mRkqJ2YuomXYe0Jr5i8yyET9pd9jEZxd/GH
         R+wCZspErvPd7Tj+JWpu/uN9ySztDQCxBFFmu4puDWdJH4I9RDm7jDLDChABRQK9ulsI
         D+nlyAU90pBh6bGitM/Bgr8Rk4sl91/r8+71XKwhOO+r/BTxguoHXLumR2koEVJyCPQd
         /dMXsOG7zzWn1PRgcJ2j29vF2gOX0avdw8mO3X1ZC9RF1OdiSkbq/b+T5i0SC1+3OE8z
         eFHw==
X-Forwarded-Encrypted: i=1; AHgh+RqBrN0gTvuewBar0r9MdxW3S3JCZoy8U3DniSgO27h8khFMna7X1xPEohlZZEwel8MjehCwG/VWlA==@kvack.org
X-Gm-Message-State: AOJu0Yxm4ctNjD1sRrhKA/Xy3Pb1g/SgYB5SRWwNly0kMDi62Cj/r7Dn
	rjWPKO7s7poMAc8ZAxTpd6yKyncx6lFMy/cQSzHKaEi1/Z57k1w0SIVWx7Rh4GEIGPmyyWMXd7n
	L+TCS0Vo=
X-Gm-Gg: AfdE7cmiEjoElMzMzGE9/3GAH9dSwl9ApVkqhHQTicFDe4sEANUwS0ysxHiD36kduqQ
	9RE1ofe06MsEfQxEBDFFbUX5I+2VvY+QVC2hcRgZD3mCHNO/8EAG7nskWYIZM5i1MRnhrKxw5fJ
	3wcwY9Qhkoaj4aBPwMVuEUSRkIVG3l9bEakpeOK0janFV1I8A9G1wXg6lhfIdbPYkIrlV7XMCn/
	s2Ju56FKHPhzMuwIdwffWFoLpYmLbjaRyUxcfZTK7w6IXGbmBCEuv6/eSPgTQDEBo4wG4Vc/Teg
	5CJ38Quj0mY2ng8cqkgRL6CP7TM/bdpTz8rzFBfuLdfFkp7Q7swpVHs92sxBLB0UU/GKGr6/x2y
	Nl+pMAEKh/NfRS7Buw5Xs2vh4e6QxK+LW1tQk1zW3r2xkCRGQAYPNY7ZAoHQXxcDnTkvzsBHPhO
	GpXNO8616ec2kwWRAg3gMwNVbTJ2/YqJquMQ==
X-Received: by 2002:a05:6a20:e615:b0:3c0:9c19:6590 with SMTP id adf61e73a8af0-3c3576c37f6mr12235735637.74.1784205871769;
        Thu, 16 Jul 2026 05:44:31 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.44.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:31 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 12/15] arm64: mm: avoid contpte A/D aggregation in fast-GUP
Date: Thu, 16 Jul 2026 20:41:47 +0800
Message-Id: <92fbae3247b4bf0d7989ba20a8763ecb836d0279.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6opzjpdr4fjgymnx9unmqquhjhaawcit
X-Rspamd-Queue-Id: E56DE1C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784205872-492084
X-HE-Meta: U2FsdGVkX1/5H/hefwO5EZr2aXe1663fB+q2IVR0rL1ZFv7ITX2EZWfjug42YLroCUdQo+vUx74YVJsdRukURtI1XK1xxaSTFFHZHSmwApk6u3svXVqQZ6QHtsDqnrEURoLYZKIO+IqhEQZUBhjePLfI3JLppas6O8SG8JR5d+26/M8runhHwLyKSQQ7j+rw9lVIwxzqr3xou6CYd+NAfPhVGjveCRFGFG9MBU64iLm0/6KaEL2mkzL5avbfRUKZKcc7+FBA4hppcOar1s2A1ZSeKbLhP6YDYsONWM0jaRj2wAdiYNrjmny6iFGiOU6ICGJfQ+H2jqMPXEfcEYTRRvuVEY9GaVwwY0iSSJ5FqXHmhVR3RwBvouwMLjZANsWxL6q55q1m89KL9zmtMrsZfjPUa29ftMjZrUgqdcLy3b5f8bQcUWuCDcyoUor3wqYZ54BiZaEtcNy86vDKGeCi/TSTWDFfUgRwi2kxA08mhyVjn9q9Ck1eRxTL7ErKyMfEHX7/R5WvDIGdjo/e16+zkUifKKZKXKdhZ3U6dqEvtXVQMPXXhRaC+js1Aa/ol0XuC1YkJ/kBHS8w4oIsTQ5OlOxnpvq386KMEjKq0vhRoyKImwHyaayC7GA7fALiMyLoiszN+nldNQ6X6vgXanCvVN6+5s+XHj1d1lpnrkMa5PH+5xw/eVX8nb9B9BhbBcRY7oL9yxG3NIHYmM5V0qpW4B5jspMFMT+pk3aRISse2QYGECpT9MJOW32+EeMSvEUNGAywDLdw130QNpBduZSKla67nowN+4YPm5P0WwC5P2H/6sjED1qAg99JA3ej4IPNJVQgDdRl492m8blQRIiqJfSLaYhrDC6JYgqoxmkni3iSkRXqB93hNLVQvQiyD+jIutVv8WatiqxMiRn7Zv2xO/aIUcYZa3ik996sI4KLhjvA3pkuQd08v9DNydHz/F6UvN5Osxyo+J8ye436eME
 ntsh+S8F
 AaHI8z1i91OF54CDU9bGWojSLfCsfY3a0uD8DYju3RN3VCXDIdVr4G6KuxT5CwPpsG71lfSiim569g+Jb7GywbGEsQoJHmUuq7uBgKG7UjUXNbCD+VnWIT4CjCFCa1/HlFSPYwhKkYjh+IGZDQbW9NYwsamOJ+b/opNXgh/ofZVq1nT3yIHjuUb6g0HWC8uPiLPL3IUPHm4rweL1NMy3zkRF9RfjgQDFnFF0duvthFP1kw1DKBuku2B+jgY85S5uR+a66F7WOPNwOCKUUQwy6bAKz/HdcPF7iwqOCWlzs5lSaE54FwybpLLnjDClz80qi8e7O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fast-GUP only needs the PTE state for the current virtual address and
revalidates the raw PTE after pinning the page. It does not consume the
contpte block-wide accessed/dirty aggregation provided by the public
lockless getter.

Override the fast-GUP PTE helpers to use the raw PTE for the current
entry and raw revalidation. Keep the public ptep_get_lockless() semantics
unchanged for other lockless users.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/arm64/include/asm/pgtable.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 018781a1fcbee..d1e08dce9f7c5 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1760,6 +1760,22 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
 	return contpte_ptep_get_lockless(ptep);
 }
 
+#define gup_ptep_get_lockless gup_ptep_get_lockless
+static inline pte_t gup_ptep_get_lockless(pte_t *ptep, pte_t *rawp)
+{
+	pte_t pte = __ptep_get(ptep);
+
+	*rawp = pte;
+
+	return pte;
+}
+
+#define gup_ptep_revalidate gup_ptep_revalidate
+static inline bool gup_ptep_revalidate(pte_t *ptep, pte_t raw_pte)
+{
+	return pte_val(raw_pte) == pte_val(__ptep_get(ptep));
+}
+
 static inline void set_pte(pte_t *ptep, pte_t pte)
 {
 	/*
-- 
2.39.5


