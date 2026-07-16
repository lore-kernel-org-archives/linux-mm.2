Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E3DC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C8C6B0127; Thu, 16 Jul 2026 11:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4E06B0159; Thu, 16 Jul 2026 11:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4E76B015A; Thu, 16 Jul 2026 11:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A78916B0127
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:14:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 303E7C0133
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:45:01 +0000 (UTC)
X-FDA: 84994609602.11.64E3DA5
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5BAD1180004
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:44:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XkbxuPDZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igNuDXnwdUCT2dm/vIcI/M9kQJ6fMwWaxma7wgKaCpI=;
	b=lS72pCflfclzjWRCKfFyTsMQTLus2JsQLNI5PNB/BgV2LtpFLTk4iYjxQ1+msoJLLQ3Lqt
	MosMohcVstjSh6TkOOwmL8sULQpBLSjLkqST/Ao1hbmpw1rMaxuGZTI+BwxFidPJDS9D3b
	pNiCZy6SwgGG98qxbGuoj/Iut4T4N5c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XkbxuPDZ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205899;
	b=TxVDPCFQ82CWAZORPnpsSvZVHDT3y8jlWf/Z/7jKKOD45K8DlFCJ12DMNo22WakpkCdidh
	DD/2bWwY1yVDiPiyjmtApfVS1TD+78wwnN58xKvU5xCS/8ucVmYjZjO1pbxJao4qb4ZoYU
	dG21FsO+twunclAuS1E2GBTsxaggKi4=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c85b73ffb52so3794464a12.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205898; x=1784810698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=igNuDXnwdUCT2dm/vIcI/M9kQJ6fMwWaxma7wgKaCpI=;
        b=XkbxuPDZzIDTzPKHpibV9if5N+Nu8n8oEsQgzkObnhBK0sO4nwQ+zfpYPDN0mdYZIV
         PrIokJti061SMd7wLTjslpoqHodApg4dkenjuURChVo7jp+3EEk1TKFA43KkE2eoiatz
         Af2qNWuruoSMSWeLLJbA2UIUj02DFSCBydhrJ+oaQWsNgc1wg3wVWmGVc46bQBqb74Fk
         kyR7BZAjgqq+xyY+sAbl3/fAUZN0pg54PKAIRvrAxvpL6F/NB/c+DUNtln5CNXcX9cAF
         rqkcir2rxkFhf63tXRUbhVnHkuPymnTgY2HdWYNIZgdsBHM4RL9+coVBT9P9+2FbKWDX
         Kanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205898; x=1784810698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=igNuDXnwdUCT2dm/vIcI/M9kQJ6fMwWaxma7wgKaCpI=;
        b=D4isLPQctR29KdoTIrgHiW8UmQo4usKX4NcAQ1eCsRcFMXuBQqcqjaqUIjbYpSa0g4
         B/Dtxrq/W1d3V6Iz/i9pGEdy1jRH8Fnp85xTFlA4xWE2MgDS56MkT3g1q/59zd+bIhh6
         B4KXcpgeUfkO7Nr44XQ1TTZLJ85ICTL7y1vMKmA+mbj6u0arIYvKuyvbNkfTc4lLlyyC
         pgTv3Ilc/XzZ2+epudYHtTmTgt7H8Y7nFMGoH491dhWf88r7BEaoaqpHlgwUktvc6u4n
         DeTfXYaI19J1+iTaEbXVG/7EquFqUQ14Xi2M9H/tLPxGFdu9qhlrW0fK6KP28aKMHEbT
         N1RQ==
X-Forwarded-Encrypted: i=1; AHgh+RqJ+/YqHrj6AG+wixhZerJldDGzSnG7JiocRnhOLPurCQmWrDJJfjnh604EcDqw8vsrpUP7PDOKtw==@kvack.org
X-Gm-Message-State: AOJu0YxFMFOErqPhgtNjAUqolsEcw404TIxOAcLCm77KvxM6gZhhZtCK
	w65IXJzQddZ2CBCXPoUZRCcpDtEunqA4a59rs7JhOF4fFHjxAnGbwPWGo3o6hmzcHY6Usmus7s8
	bTjukhV0=
X-Gm-Gg: AfdE7cmEsd5d+pZLlK45uswQpIG/CbDmrWhWmKGu3wXIAkzqn0uUlvlZIBeJ0VRg8X6
	6DgSD2oxK9EFwFQdvcWtDu6zKt6P7fedxchKLUd2cyrEYrB4HZ3Yp+ZoNsKi+dnfsM/j7PV4IsP
	aQwWUA67PIuu/jJrJqGK1t1OgtsFpq3Fm5AI8WFrasCRzEULZ+Nki+xB47mnMS8aiAR3QlqEEVa
	HepJbbzT9DuZBARuoyaD0hfNYdYNoOrrhWb2sdtrWrbxvwMhA+eGl4gE+gkDAz0RTIhEQUgzI4d
	rBrKPX7Ta163aTPUA+PE0naNhISgrsEGcZ3rqWHNkiLzhZwOJ7QlkEotx0od23GQaqeDnTONUp3
	1Wob1oq0IYbP+5Pr9VQoaOq54a/+txq5tZojQrVpMpd30HOBPvP0B8pi0EBIKwBdh1eV5vVEaFg
	90Rzb2tb12vANi1FH0Ft2XkaI=
X-Received: by 2002:a05:6a21:7318:b0:3bf:a881:4094 with SMTP id adf61e73a8af0-3c36c35d245mr7182183637.50.1784205898111;
        Thu, 16 Jul 2026 05:44:58 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.44.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:44:57 -0700 (PDT)
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
Subject: [PATCH v2 15/15] riscv: mm: Request large exec folios for Svnapot
Date: Thu, 16 Jul 2026 20:41:50 +0800
Message-Id: <88438f09b79ceab1548aff17384814b7f699a43d.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r63aimi7j7h4t7cqfj8ezwbbmiwhajyu
X-Rspamd-Queue-Id: 5BAD1180004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784205899-821526
X-HE-Meta: U2FsdGVkX1+wuP9D8oL8JDJVDVpl6z3gkDqmeiu6dcKriWQfWeDqB6dUtRq1QbVgKATnIf04avStHouh94gZPjkobhYvNEGUqKK11TYImkwSCqL9pmn/hveYvh9WoPwgWWSYcOiTupGAfOby3zcrEKArvyiakrzF3YRILzaQKF0bUFmKa4pqNzarOiYAjDXb0Vt68annCSt/sHQrdQUxJNsNODi89KF02imMY8R7F76qKw532PaXAHmMRkG3LEae+U9p96GP7UmMcjeC7koafNDjEHhN38X8+Yu0BOTwdYyJWtJmBLAhFYAuR+Ps/gAhfwWCA52bU/r2ZeTG6vqp8Nz/J1HXLNdIIDULnE/4ZQf7GbKjd9Wa4leN/P6jBZa3q8pxj4Me+0Cf1N12H5M7C2ZNysV8wDO9D6wlXbEBVjsIcAI/8iKsEXBwDhynHi7lJYdf7d7ffnrghgImbIJ37AYChDwmigs4JEc/+Le+NySuCiUGY6axd51E7cEaKSI7b6dxDzfYuntle9jszXujRK/0HHt3Me8FCDBwkNn1qiOsiKZ6isMnYg0US+B1qWpAGJro1J+YS5pj/u7gvYOQWGYc3kjCC8LXtJZvnB2mV/u5rhe6Db1BY7OJ/rLmN0JVHxFn9k7UG8ypjQQmNu8f5hTPCl3jr7fDB4ABuEYCRW6DjQQLyKOVpDDofGx5z9vvAUkZSo4q58ZgFWsR2TPDY+Tj/n/KNd4c4/3umjny9CqdMM0CQL8g5j5nLFbllQk0WjP5JisRW6vc2pUwaRjxKW/uZ/HZyTEQ1JUK3J6YDHi8GrpsPzheAeX++oo+qXJiJ5VBDTuw3AVTvsK1f3qTgtcibb4ZVCpnYvz/rkh811dMEx7AjbTZHB84Slo6e3ZRdXSdFPsRN7KegJBFWxkjnNcZu8UkOMrkytz9jLUKAnaXpJLy9HpystbZ8OQLPyvGyVKzWZUwerfJKP7e3p3
 BgkAjvHh
 p+SEJN4Me4K3iGmm1Pt7kEAs2+Y+Af6vy1CgCjYMA3pHjYuCTxfRGEqaksz5hsGGMf4UPsRuUWic2rCr6tddJrFR0huPPLhWThKHL/oOBtnEJTsClU0f/PvdLjjngIwcd2PDAbzvss9trT7dzK5QlFBqa8UA2DhIyatFa9zAGaTqAz8fomdqdgtPsIxvkGeqCoO6fNmd2Wlk1Jy2gNWUWOHxH+HXps3zg/hcahlpmSIfZ/jdkySzGmMYAH1pSc60/kuG5+4bMEFleLLKh5exvh5VyvqXM9LdwHAv+q/4NURG14RgWoZ2t8rPgPbaFH8wO8zB4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Svnapot MM support in this series allows generic MM paths to operate
on folded 64KB executable mappings while preserving a per-page public PTE
view. To benefit from that more often, executable file-backed mappings
should be faulted in with a folio size that can be folded into a Svnapot
range.

Request 64KB executable folios when Svnapot is available, so executable
text mappings are more likely to be installed as folded Svnapot blocks
and benefit from lower iTLB pressure. Keep the default order-0 behavior
when Svnapot is unavailable.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index b546e6614c558..6801ba135c483 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -296,6 +296,14 @@ static __always_inline bool has_svnapot(void)
 	return riscv_has_extension_likely(RISCV_ISA_EXT_SVNAPOT);
 }
 
+/*
+ * Request executable file-backed mappings to be read into 64KB folios when
+ * Svnapot is available. A naturally aligned 64KB folio can be folded into a
+ * Svnapot PTE range, reducing iTLB pressure for executable text.
+ */
+#define exec_folio_order() \
+	(has_svnapot() ? NAPOT_CONT64KB_ORDER : 0)
+
 static inline unsigned long pte_napot(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_NAPOT;
-- 
2.39.5


