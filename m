Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4087CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422198E0037; Mon, 18 Aug 2025 08:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D2658E0003; Mon, 18 Aug 2025 08:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1DA8E0037; Mon, 18 Aug 2025 08:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 160638E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:27:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B5FD1408F6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:27:56 +0000 (UTC)
X-FDA: 83789804952.16.C245C43
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9E3F48000E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:27:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MXLSNvip;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+skqhizRw6+30lEgRR8mTRkTR/5hsa5rsGuByfmTmA=;
	b=DLSFGgYZwlCN6TJP3+RT5yxlh3D4K9QMx31Y+KvCuhPVY4M/zs0i/CWq5UlbqJNerVcD1Q
	UVzMtDcJ4dYSKSvacivCvc3STis/0pe+Pj4oK/7CkKNNNm1q2AZcNgwMdoXogbPVhUco5u
	cmxPwQiiGtpdbUKGVGeaSCAoNeLiUzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520074; a=rsa-sha256;
	cv=none;
	b=D938eBzZonA9EkdGMcT0CqIwdbqMsI1bE7ALk7mXot7NdmT64SDR0PVEeJmUhgVk84TT3p
	VmSFoxSKXiYWvSz8/yg/csh4vZKBSaX2nta5A7YoWFdb9wGwiBx9FmQTYKv5mcAPFqygjQ
	Ag1bHRv2pATOthynm6+rJRzDFtRgzTo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MXLSNvip;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-244581c3b43so33619445ad.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520073; x=1756124873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+skqhizRw6+30lEgRR8mTRkTR/5hsa5rsGuByfmTmA=;
        b=MXLSNvipAvbnbRoEaGNS3VBUTtHnMRp7zwzng0l0Gph6S4S7K09dZGo7DbqBQU+LBS
         IXMq91ixGmMNsZR2Qn38v55e81CIEixU8yFp2t5rq6lK9u72xwCrnTOEy6/nvdQEejpf
         ImnLK9gPqbEmo6uRt8UI3gjebiarq9naA3zuM45qkVMfmwMt7G3uO14Omt41hrga0/a6
         o+38g6jSDoxRR2HH2xqlq0a23StZKzJQ7XKVYOqY46A+PkRqltL8ceSFeWaqaJv/sy+W
         L2MSEs6mwxq9a+rUZac7VMAq6En44pqv7aOCxtUHamNAmOI1wpyH7g+iyNN5T1anWsxC
         1BJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520073; x=1756124873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+skqhizRw6+30lEgRR8mTRkTR/5hsa5rsGuByfmTmA=;
        b=pFBokllj9dCoqaRA1MxSOPTg/0g2iRX7lezw6weH4Dlu3DgdlLTvYGk/+4NOdRVUkN
         It/LpLhBWrrDQ8PLDUe7h59+epp9xTGWafy/dL9ZEp9G1G3xucxjRsoN6UdCM1Gorjwj
         S4PUdtvprRdH8U/2nNVYKs+hchmMHvmL+yEqSOy+7wb3HJCxrLtevJ3vLnG9zTk6dMon
         14OBiKxcr8uaP8NtBuXJWJp4qp813r9vOBa238oUtBzaY1l5zd3S1WgroP2j/hkvCSna
         FrVlRjQlDV5OJDwIs9ifXNG4duMIM/Kr9a0MuQhhZEmFD1yXXLxDe34t6ltLqC2LOF5/
         ru2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQSUB0qVL5k8oLa51H+9G+IbdOuRlH+8VD6rKzHSqeIGrx/LJt+4iTuK67umiYu/qO/S5Shp1zpQ==@kvack.org
X-Gm-Message-State: AOJu0Yw14de16hGczBGQJ9qYBQ7Og+xYiU/RJ31S/FxVZNqq/9q21CKO
	lB+AI2Y+n75zRXhGMwn3JWcKtdW5UL0CeK1q4U4hUkwAsBAxnvBC1L2z
X-Gm-Gg: ASbGncvWqHJ1MfVIsgkgqBxjGY1pvsz4BxMfB8lPztfpahYKnTw9S4ACvDlUEk5UV2y
	cGGcE0zbl62tssTQksLaRVmy5dKU6Efx9/RFesspGQRDU0AwKO93F0W24iOmSaXSxtjkpt+gphY
	tiKkyjkw9/ojdMonXNf/4aIVeXpbWyVO8rmpQ6CqPv9QV36DAAMbK+AwfrlkX7HIMnEygWTMAdr
	f9REygZqBp//Fvyl3haLYVxxqXsv/V/DFP6A3PfJtLEyvqdwiPInKq87xzRUn14daSxiFWoHSBy
	xzq1Hwa5/MDlNHZWnWBkPsfyiZoupF9rYvx1sEKFHS06NhB6HeV+O3Rgx+BwYUYfse/qBNvB1t4
	TXPaICsFssLbJtR1o3PU1aURXk9zmkwX37Ptw97D5N+Nl
X-Google-Smtp-Source: AGHT+IHJgfLfFK4K0WfBuoLmxYaamKTTf8SH/w3sao6ewMfrYn3NMsyzytLmcdtif1DDDCDs+rERsw==
X-Received: by 2002:a17:902:cccb:b0:243:80d:c513 with SMTP id d9443c01a7336-2446d6e444dmr167144865ad.4.1755520073253;
        Mon, 18 Aug 2025 05:27:53 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:27:52 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint() for atomic updates
Date: Mon, 18 Aug 2025 20:26:07 +0800
Message-ID: <20250818122720.434981-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-2-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
 <20250818122720.434981-2-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E3F48000E
X-Stat-Signature: ucot5zw36ixpupftosp68k9nx9qyhgrg
X-Rspam-User: 
X-HE-Tag: 1755520074-481372
X-HE-Meta: U2FsdGVkX19fwGeMI6gA4b8O3YhJABHG3m4aBWNchqt54oWPDSGoWaRxgvYB3gy6zrnarDDFrhYRHczbIR4wGqR29tIQDlzFua30nxduJyI8J09PEfcfuXsG0ZyUYmZHEyxWc8+bjsCnfAkk0aez6irNRfVmBGY8yq5AtPpKOeHSOWQHuVsJV65vTyAyqxOgloBTc5MPjlnFD1/lqYOoaiUKDY1/rmG1v8niImBMvtBtvYFmrWSCZA6NG2c+wOYlkspqnMBpw2uFwHszyIaotB4R6bjgNzyYvd8gCA58POcbVhkHUOuxyHnJ63yZ+dBqa537emSFsDKhI8/CTz2I5YRDbGfxfAwt2SLKuBXARsL854xSkdh8wPWPI//h16Mjd7dRFMASXZ3LRdg6NTThZVa5DboUTlbdVuqWJkwPlMeSFbekQfzCKgMkr4kNkAdyhEJdJWTp6nc0RPKdHcXu79vp/RjCGO0pA3u74PTjoNY8qqPgrsTR+hEh3S4WcIe5R5X67dmA2aM/FAolCGMqmOlFTCB3x7VRF1J3OIs2Mk7lRKtGckbunM7aKp75s/vW3MOR73KYtwyXsO0VnRwgrdj8gkQV9rVaFnsB8yVb/cZfsNwyr6fiIKaEaHFshT9xC3m3C/kI2VCWtv0+1rBtLTccEq+WX03JRdXIJf8/Zy81dWyKSGpBV3/FXtRRtYDnVjC18hmrLhkWZZMq4SUnyl1cMwyQXKSb/o4Uqpa47o8PS+LjnORwbMrj1SRFjkW8dq2HTSr7gxFpvJVs9qGn52Zy8fe5dgzIz6RPap7PYi4YQvPU2O5E0SlLNwJZrgN2QLgBmqsPP8cM5kCB7DVPNEHRD8syp4N6PzYO7tfK7/6UCoV9lwsNcltCGTMA1evWqhW3D5oLsPs1QE1l52CnxLQ4JXGpcbI5W3h6Q46Yntd+U6BFxkkXjlt5Iu2ayrO++R3iKjmdxwWH8EdsX7v
 XNb9aJdM
 mgYYULRBHY7wys1YDx4QhNWMJPcbSPg4fTy3SVH7v0GHAgODMcKzi50cxGK4IIe42v1GUBxYeXWjJoMZJz55yl3qDLyLKVw3dc584jcP+oCvj5ZdauFOjQ+e827LNK2+CNHQ9YMAvIOJXJYxwSW3mIEERDnE2UNXddlQlgUCc681DKDwoNa4w4TnQpLSSZHr6drqU4/svILB3aspfFrDyNTcbQtyucomlNkJrVpQ77dt5gryEvFp3F2Fk1vbJiHtj68hDFvyER1h7IyjZMpgs4Ow8r/KM95ZpBh5bkYhfoQdJ2H1VCJTUXq6zlSRVhJqpvgXguGFZ+kDPZyiJv4ErS3dHUWCCpGhSEFcieR3V57Z1Uxn9a2fVeKsalh6gaFvcg5YY8pXgPs+80S7H9jjODAL3WViAPbjsbb3uY6xd/0B14RupgMrIQyuRJtVgzeD3GeJjh+zM4OTIb9oV6ZI7vkhvDpPHFvxH5v4rJdebu1nSxKxToydSRJWCPr7z8n+T+6FQn/kOwE9aNKuUEQLSvKcLvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add arch_reinstall_hw_breakpoint() to enable atomic context modification
of hardware breakpoint parameters without deallocating and reallocating
the breakpoint slot.

The existing arch_install_hw_breakpoint() allocates a new debug register
slot, while arch_uninstall_hw_breakpoint() deallocates it. However, some
use cases require modifying breakpoint parameters (address, length, type)
atomically without losing the allocated slot, particularly when operating
in atomic contexts where allocation might fail or be unavailable.

This is particularly useful for debugging tools like kstackwatch that
need to dynamically update breakpoint targets in atomic contexts while
maintaining consistent hardware state.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 arch/x86/include/asm/hw_breakpoint.h |  1 +
 arch/x86/kernel/hw_breakpoint.c      | 50 ++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..bb7c70ad22fe 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -59,6 +59,7 @@ extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
 
 
 int arch_install_hw_breakpoint(struct perf_event *bp);
+int arch_reinstall_hw_breakpoint(struct perf_event *bp);
 void arch_uninstall_hw_breakpoint(struct perf_event *bp);
 void hw_breakpoint_pmu_read(struct perf_event *bp);
 void hw_breakpoint_pmu_unthrottle(struct perf_event *bp);
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..89135229ed21 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -132,6 +132,56 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 	return 0;
 }
 
+/*
+ * Reinstall a hardware breakpoint on the current CPU.
+ *
+ * This function is used to re-establish a perf counter hardware breakpoint.
+ * It finds the debug address register slot previously allocated for the
+ * breakpoint and re-enables it by writing the address to the debug register
+ * and setting the corresponding bits in the debug control register (DR7).
+ *
+ * It is expected that the breakpoint's event context lock is already held
+ * and interrupts are disabled, ensuring atomicity and safety from other
+ * event handlers.
+ */
+int arch_reinstall_hw_breakpoint(struct perf_event *bp)
+{
+	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
+	unsigned long *dr7;
+	int i;
+
+	lockdep_assert_irqs_disabled();
+
+	for (i = 0; i < HBP_NUM; i++) {
+		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+
+		if (*slot == bp)
+			break;
+	}
+
+	if (WARN_ONCE(i == HBP_NUM, "Can't find a matching breakpoint slot"))
+		return -EINVAL;
+
+	set_debugreg(info->address, i);
+	__this_cpu_write(cpu_debugreg[i], info->address);
+
+	dr7 = this_cpu_ptr(&cpu_dr7);
+	*dr7 |= encode_dr7(i, info->len, info->type);
+
+	/*
+	 * Ensure we first write cpu_dr7 before we set the DR7 register.
+	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	barrier();
+
+	set_debugreg(*dr7, 7);
+	if (info->mask)
+		amd_set_dr_addr_mask(info->mask, i);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(arch_reinstall_hw_breakpoint);
+
 /*
  * Uninstall the breakpoint contained in the given counter.
  *
-- 
2.43.0


