Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF48CD98D7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABD9E6B0096; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94746B0095; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAA16B0099; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88F8C6B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:01:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C8B01C35D5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:57 +0000 (UTC)
X-FDA: 84867644274.25.3182050
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id E88E840016
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=udezktQm;
	spf=pass (imf11.hostedemail.com: domain of 3wbEqagcKCCgEFEVREWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abarnas.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3wbEqagcKCCgEFEVREWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfzQDEt1pCJotSzJosKxmaJLh3FzpNGs30nqV1AQIaw=;
	b=q4bj+EsqSvVsgw4wRL4tggco5fPgU8pJaIMOeM8NJh42LWe4loncLJaJfbcitquYGsdmXd
	36BSC+f+A7+OiZtbT5etrveTiHPfWPq4RKLcOWEbUostKhpiwlbBRpUuvt2UlJ7x38Ibvo
	sw0q+leppUgZgegUJJ3KoZGqTtzE13c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=udezktQm;
	spf=pass (imf11.hostedemail.com: domain of 3wbEqagcKCCgEFEVREWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abarnas.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3wbEqagcKCCgEFEVREWKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abarnas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182915;
	b=o4HeSLwMIOW6o7WwAUru2ID1fNW77gkKPY6oPSdf9aPbn6lEa5Ob/hRkyc2B4PyVj0xVar
	aZl2vgN0eHk06PZFnL2Uu/DTyU+9uBseHl5oz51qwrDWTqa06y8XGr1fV3Y+CledLf68Y0
	wI2iMS0HWHq1K97JGiP7ZZDDCYLszCw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490bfd70b0fso79983525e9.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781182913; x=1781787713; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XfzQDEt1pCJotSzJosKxmaJLh3FzpNGs30nqV1AQIaw=;
        b=udezktQmlfMFcLxg9GFXq/o5oYZGK1bfyiDmg10ynrp3UJIMqqgfnXX4lAYbeN5vzm
         hNvx+SLNc5uJU1QMwD3O/d2lbx9w6oqbAzw1qWroF7LKSYs9bTLBSfjD8ycbuWgNZXSq
         MT557AQjeTymD/VZnCXuZekjQCwyJjqbj8PbP94jSH15rCtlOeW79gV3vXPIf6bmTMRS
         5NvfeOXJinySyZnuHJ9a9r0HG2ESDx1jlGmU50Z27wf96EzU9VFGE8dul3xvwLH1v2fG
         3JBvatQDDEzkcQ8qNz094CT0OYYo/QHg4GaLahV1rMOuR5x3srWjVo58PY50OIK48AQr
         hj2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781182913; x=1781787713;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XfzQDEt1pCJotSzJosKxmaJLh3FzpNGs30nqV1AQIaw=;
        b=gd3u8ImcxkhHuaEhh+xMl6+oYExVXFgHZ109jhsClWXln0dIss1Drar/uc/keci1mk
         K0AKEGwvlGGOglvDznbQ9GZvguoM/sWfcpjn4nj+a1mI5HnJLRbeHRI3BcfZgDkCCVf+
         l3QPsYlNFLc8SVW0H55v3a8BZYLRgYOf9INwaZA0HkqvfMDxv0C3rnfm0naNRWvjjBFu
         6X44hxvZxaHC6IwOxvDo86S/By5RKKWivAyqINWI9ES/Mf/zVgIVF/BNFcfEWIT3I9bF
         snWjiJZ4A+kTzew80QjX/P4NWcWV/ZUj8z1Ghp6/YxkgJ8Awl9TQkcR3oyY0arl1g9bz
         ZHFg==
X-Gm-Message-State: AOJu0YwNNDfknxt/VKqKF1LbZFbvpT0HHxNBe9o5Wles+4bhZxYeWjdY
	a4GSa6KbxaIMF/yUTiVLDAwz7jTP2rEIU6nebWbaUio9ZqKnblP8IhRKmrraW1717OCKaEUQ96t
	WOzO1gLvgCw==
X-Received: from wmbev16.prod.google.com ([2002:a05:600c:8010:b0:490:48f7:e94])
 (user=abarnas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:e547:20b0:490:b58b:a8ca
 with SMTP id 5b1f17b1804b1-490e5639e96mr25676555e9.27.1781182913390; Thu, 11
 Jun 2026 06:01:53 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:01:42 +0000
In-Reply-To: <20260611130144.1385343-1-abarnas@google.com>
Mime-Version: 1.0
References: <20260611130144.1385343-1-abarnas@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260611130144.1385343-5-abarnas@google.com>
Subject: [RFC PATCH 4/6] arm64: mm: add helper to fill execmem with trapping instructions
From: "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E88E840016
X-Stat-Signature: hdzdezwecmsqu8phfzgij1yyr8zua1us
X-Rspam-User: 
X-HE-Tag: 1781182914-29503
X-HE-Meta: U2FsdGVkX1/zzfXmn1LY6Nb11puffocSB153de7+PzOKDEUVF4evpf4r4Xm0xbnBgERRj/yWGc10UrnrQNeVJFNhvQWtg8XA9YqzcMePhpIB8PySTreQWZqASRlWnTBrvJBwaqrz5AAMbV1tP/LmzdCcHbPT1AYzlVQXI77xOYAC7XBsX6HVUnuGh7++bL1KzxboorvEIuworyEKqHlvYwmBLLI4fNtHYX7VQbnJTQZmwUaStAzvtxN7NW3soxoM3L73EGVNUws7feLGKPFjCSBaCmCThc3KP0WcUjJckjyEcF0V1blBa9NYjzCWhIBynH+x+znAyskJofX4KWqsukYesUrkIqYjj9iFt+iNBAfibiq42aG0/+3gX6HCEapBaouAoWy6SPj92Netuy8kZ1gV5Y7uWdlCxdqGSpdzzbqlV/T1I2MzQ6A9bEpBrC7Q25Ziz7WRLM7wrKFO1sEdPid6vx/ZyaMzmVKr+lta7BlgX1TbClVL//D8Y9gLGK90/aulFScI+IL4mEatwh2jM4OgP6svEnFL3vl1KzspFtqt4E6w9AnOaSN+AUqJGMsG4Dn8znZ9xnhNvf0GjK8VpWQFTDm38hKhyJzRaSsVjf+KANOUZ4WQ8zywPwAogqbO9o2KTlyfh7L2jhRzD4qu2WFVegNElnlMsHMx7lcVScopQsvYh6CQRI41Exstpw28Y0lUtAjfNRn3u762PbbkQGeaT/pqzRD9O1Lq1SJ7DSAqYnqR/BjX+bB7O6R3kzp2lnEoCrWldZqQj258nfr/nnP4ShKlA4Pzsl2CZkISZ+WaKcZSCU9RMoVyRmxVkOU6o6LfUxO9GtFDnl4fvpQzQxQKff+I+I4JhyE1BSySpY16e+PwsA5Y/hj5X5uwbE8H3dyWrBpj5GoBaqbUUzpRWZB1GvIRcWSv0Dvyo1VdnXJctJ4qWUe9aF+q9+A7ic7jY+X57YuVbGLShbDH9Me
 hd6fNtk5
 lXelbnOpR4GFxzpG0MmNkDp2tpb/dMuMhrPsG1YSTkeyCKsStX2wlDN7zp46MYagVDHmnR8vGOd8i/7Bk8m6yRXddo7tM6pWwZHzNr2akpBymzU+ULOu/yb3BoyVwDzR0TjciHnZMP92pvXeeNnnMD0I5Bjcius42dRcGfG2XlZ0JGRzQyUCUqKmz8YZsW1md/LTgTc+WSOjDSO9GyWKS4ZvD9n6l9t74n+9jWFoUtZg3ZMPK3w+lOv622oQ4eQH4krjSN6G2bx9atmKo1P6e1NeBGQ39Cvrd6Cm9E6TSMcN+40/T1j7zbdrL3UBoc/dOGhCxgaVxeLVQDxdFLnvAwdc4HKF6dg29xoaETrxzWYAhge+vgoolHi0cjo974hrPCsJ2TeM8GHpdsn97p9SVtJqNB+ZBqWlfJ+TgXJ6B54BLjnzODTn/u08ILJQ7sU9clfbaBbxozlxGU6W3UvsMUcOgPCrtd3l504hN/j+s8T7+NgG0PHMBckINn+K17oDspnIP35coF6rFi1Zk+VgyLAdgNcBd276949HdPFbyHDHxtdZkO/cAamck9t3lfwLx+58JYYt+uTZtWsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the architecture-specific execmem_fill_trapping_insns() helper
to poison executable memory regions.

When CONFIG_ARCH_HAS_EXECMEM_ROX is enabled, the execmem subsystem
requires a way to fill unused or freed executable memory with
architecture-specific trapping instructions. This implementation fills
the specified region with AARCH64_BREAK_FAULT instructions and flushes
the icache to ensure the traps are immediately visible to execution.

Signed-off-by: Adrian Barna=C5=9B <abarnas@google.com>
---
 arch/arm64/mm/init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index c673a9a839dd..71aa745e0bef 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -408,6 +408,20 @@ void dump_mem_limit(void)
 }
=20
 #ifdef CONFIG_EXECMEM
+
+#ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
+void execmem_fill_trapping_insns(void *ptr, size_t size)
+{
+	int nr_inst =3D size / AARCH64_INSN_SIZE;
+	__le32 *updptr =3D ptr;
+
+	for (int i =3D 0; i < nr_inst; i++)
+		updptr[i] =3D cpu_to_le32(AARCH64_BREAK_FAULT);
+
+	flush_icache_range((unsigned long)ptr, (unsigned long)ptr + size);
+}
+#endif
+
 static u64 module_direct_base __ro_after_init =3D 0;
 static u64 module_plt_base __ro_after_init =3D 0;
=20
--=20
2.54.0.1136.gdb2ca164c4-goog


