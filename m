Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2105CC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F976B0149; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100EE6B014B; Thu, 16 Jul 2026 11:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09F36B014A; Thu, 16 Jul 2026 11:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF3CB6B0145
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:12:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B4071A0149
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:49 +0000 (UTC)
X-FDA: 84994606578.12.825645D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id B73A7A0008
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XDBmNdZx;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpVNfPM2loki1/2WSjY19UJOAg4x0MrZ4b63t+Pbr9Q=;
	b=jRipTq2LVxFy/v2ZbPhK6rzvSnqhnU/a4kXrs7ipRBsQOiscvoydW7IIEMzqdvDXWPFpRE
	ul/rq3Vy5YEKoClAlnQp1E71PqUmy0CM97lJVLjztCMKA38YJx+Xkcdan/zOGs/+C389Vv
	5RMfIFNRmiOUXAqX2Jnhstxnnl7/CPc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XDBmNdZx;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205827;
	b=vbaxJ0u0JRufkPIx563SdhPQZzwxZvgYPD8Uu8VzBvsorBdbxG7oF64lgg7rxPecmkfkzS
	SNFX95oSa6iYUFgN/0hufyvILq6UTfml7nYqkPUP9WBVcAYtIwvCExO6BSuFd0Pe7NmE5F
	ORRsq+rLhUXodEMd6hO47K5rmIf0J08=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8487de17abaso156759b3a.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205826; x=1784810626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qpVNfPM2loki1/2WSjY19UJOAg4x0MrZ4b63t+Pbr9Q=;
        b=XDBmNdZx34iHvja7uS8m57IDKD7Mq2+oiyEWRFtoWNK3nnwY0wj1I9DhpSWNG5H79c
         tVUKPeDgEACh4WuAmSJUXMB8CMPsFkWTr1XsQqEqY0TMDTvh/6+OMuS8fk3V695OEM19
         p8M9D6EVglxQpXec2cXUdIWMBRUvSfV7MJYZloDnBge1oSoFrKbUttHy4Gv5yxVPvs6b
         feH5uEmPfAKOd5WhIlv+/ScF8CpIVFBS9XuXOchadu2XYmClXPOCRhIg6q8Ei2bv1VXj
         aXiLJi5g/6xAfV2cZ7tG7klDYHqGAWZpzxgTBQJXhG0ObGBm7ZOMTNw5my4s5vTICUyG
         yufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205826; x=1784810626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qpVNfPM2loki1/2WSjY19UJOAg4x0MrZ4b63t+Pbr9Q=;
        b=Jicto859vvhHxs5rSPTSMN4Nb/MLglX1ODjF4bKnyMoDBnfQyIW/jLkWRglEd1393b
         xQ5y2CBL23UW0zrev3pVfLBvlMrOFFeLjm0bYRpzSiTuWyLUeALGL6+2sy1bRP2noCEt
         1RC7pD5GWyxnrV0JE8gUFA4pnP6rBRxxxmC49NMauIIrLmLOFVzYIy9k/MGrYvItHFbF
         6Q5JS6YMQY3DSkxBC6ZoI5n5q5kfrNQb6SuSMeX96xpI3YTxAdYIn1ArgE4ld91dvJr9
         b0ExWqNm9oRoK3PgBkB6Ioc3O61tyE74O2B50DjhLhUBXPC7SoivZmN92rsSkQU+BHbv
         0Vvw==
X-Forwarded-Encrypted: i=1; AHgh+RovgDH/jLhFd67mqdjoi7o8Pyf/eYdeSVYxuiVAUuEV84s7PxJxWT9wvZO0FcbnOQIHYJ7z/ggXtw==@kvack.org
X-Gm-Message-State: AOJu0Yzwd673aGU/5cO4d+1KMwW17vDnw+f6SjlzMTO9W/I2fI9EOGFd
	ZQMx9Sq3llxZuSNOlvFqa9IA1vFXjPyDJ9IMXHYpHqWjb+k4ZwSQ0aNSiHdsU4vVKIQ=
X-Gm-Gg: AfdE7clTTdU+irgJy39SzxPGBFRPdpyo/FZtReW6qngNKpruXgXhOwxPVmfxgdo421J
	LpwgxsSgo56xoadN+GCvYx5jHghkZgNGcZPexPzp1gUcQ0Of/3zxT89apALeJxerCFA5hN4OlN6
	fH2jcwwFx3rfVuR8HgoMNZqMcGfE7aaHjJCtRLGieKIWb7ttF6HBa2PuLQOlup+D8cqyEBtb7Z0
	83z9sRkZGk6m32nNKosohYssFv0jWwhWZkL+t8zzGHGF5+rvEtjjrOgAR0j+pNYGuSr//IVa9RA
	NKe/jxDmgPxjpPI3gmnpfaD3qN2f+/NnUxWEV0Skbb3PhA892wnHM9MRijFNhjRv3s48MaXOH10
	qG74Ul5HoGlsWC6LWyKIQ5abKxLpHFvbaNZ2M2B/wO4S4NAUdSH3RM1FB9LUR/ASMFBMSPGuNCJ
	x1g1plL2pRxRDBCtJWXgkUdh0=
X-Received: by 2002:a05:6a00:451c:b0:848:2f74:d8d8 with SMTP id d2e1a72fcca58-8488986dd0bmr19929855b3a.73.1784205826475;
        Thu, 16 Jul 2026 05:43:46 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:43:45 -0700 (PDT)
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
Subject: [PATCH v2 07/15] riscv/mm: preserve Svnapot leaf-size semantics for page-table consumers
Date: Thu, 16 Jul 2026 20:41:42 +0800
Message-Id: <180084b20de76f7ad61641e9b7abe6d103caf5f3.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zshawn17y5a4iodhbf3ziu17j8jswsbo
X-Rspamd-Queue-Id: B73A7A0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784205827-91268
X-HE-Meta: U2FsdGVkX19/VkdCbEc+d4cDN2Z1JFP6GR1S8ZhhI3LgWUO3xQusM0h+NWBE1jwxaw25bZoMrFcSTUGftt0qXr2gxyq6EZUiWouzDqHD17mCSQGW6SnX8i8aEi+Z3cWIwRxrTxEceYD2m+4NC0mr1ldVAWF71EiQYPlPqngzmgBBEk1BkeyXSr4hPazCbLbEZzQIyOnfnEJnlNFLxbZYOAElagfVnKPgeffo58VdFz2QLMRCrazn01XVYLvOuv9317qa1xR3vehG52yK1xDKVcymFPxT1eUsesOSwanU4+dpJ+MS37hgPXZLL9Z3zOvHmishgQSwE3dKahOQXQdT9JU7XuY+8VTvya4motbeUaMfsDvCqqj8dRaahrc53MaXaAtf/wUcuIQ/Y4/BgeDNopqzQ0LLYe/7M9o3q6g+txCXsjgX8Cu+TkbWzYkw2JI3VaNZGA/f5hipht1Am+9rbAlkkdTVzT+6Ykfb0T81PiTWqx95YinLl6LwcHY2u/dvKrV2/TFD96bO8r0oa+TvtZuX1Ipb/tdo2BS6viwraOyAFVRBT1BpeJSFmzGJmNyOQowUfCY5gyHdM1mA16/b6+1Jo3U7+n1oMHpOjpQGgNuB33T5qh0xZpXL4VeyxgHhlUH3QPOW5IXu+r038fK8yj2FH+zyvRvLR30gtqSv+KG2fZXKt3ZEisi4ubFj3YhGFcRG5QkcNt9pOUlQPT8UmlIEgYTo1TCRvS5dtvb8acm1ZDsR081M3EdW2SCHYoq/+S6qZ2ljYgzjVTcSgaAbxM3TB7Jc7eHnuj0/w55o82tYUWsPCvJgXJFMDS7tlWln6V1hd1He9FYFMeFSDYF2U+gxykH+kLUSh3QjYGp5u2lX59uWC6IOE+Aj4ZvSquR/XYIRp1yhIS0S1Zzew6fj7e9U0w5ALDDqvYEASDKfLQNgHBRpna5IsreAiOoBjoKudOph+doF/9Ir7ym6yxv
 WppXaXPD
 6vQhAXaKnlUzP+nvDsO44V4HUA1xMzlr7mETxan5M7Igu77WyPksRKeRXAiK+VBcLfJVMqpRlEsKMEqXuw6o00EfqV/3kOPxbHPs8XEjJtTaFnnGvVdriKnCAp27bi+R3rMkgn0RTZL5s9S9+enYn9LHMYsmU3t9IcyKKPGCu+OmMSEU8Fn8jBTxOKxYQcREA4oVArRHtjaJtT67lY/QWhcfHV5hxXB+El/9X2w8jhnWWFMu5EpGx2mPBNEUomqsELDG/GCWerbwmmi0QZoi1Z1AbEhVvJYhuc2/hbkV58Zw0t2JcQaxtzjtLZ3yHnLZ3+R++
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Svnapot keeps a folded 64KB mapping encoded in the page table, while the
public PTE helpers may expose a logical per-page sub-PTE view to generic
MM users. That logical view is suitable for leaf-style PTE consumers, but
it must not change the effective leaf size reported for the mapping.

Use the original page-table entry for leaf-size queries, so page-table
consumers continue to observe the Svnapot leaf size instead of incorrectly
treating a folded mapping as PAGE_SIZE entries.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index da7ffea0dcd98..e4b9c05014c00 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -580,6 +580,17 @@ static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
 					napot_cont_size(napot_cont_order(pte)) :\
 					PAGE_SIZE)
 
+#define __ptep_leaf_size __ptep_leaf_size
+static inline unsigned long __ptep_leaf_size(pmd_t pmd, pte_t *ptep, pte_t pte)
+{
+	pte_t raw_pte = READ_ONCE(*ptep);
+
+	if (pte_present_napot(raw_pte))
+		return pte_leaf_size(raw_pte);
+
+	return PAGE_SIZE;
+}
+
 void __napotpte_try_fold(struct mm_struct *mm, unsigned long addr,
 			 pte_t *ptep, pte_t pte);
 void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
-- 
2.39.5


