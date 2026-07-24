Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA5C6C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1E16B0092; Thu, 23 Jul 2026 22:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81466B0095; Thu, 23 Jul 2026 22:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4456B0096; Thu, 23 Jul 2026 22:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67ABF6B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:30:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC3B5C01A9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:09 +0000 (UTC)
X-FDA: 85022090538.19.23AE800
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf19.hostedemail.com (Postfix) with ESMTP id 183A61A0006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=i5eHHhsH;
	spf=pass (imf19.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXOSjewrugfoFYAviBCdTNIHqggVZlJ3YZl/fwlFoCA=;
	b=Y7fY9AQOnowxJCst1E7guinTnapqLG+aje8u8OnU6jcnmoqRxtopKrLFnquo71KBM/3Ykw
	eI1SdeoIlCykkam8Vh5p7e6/mxA8l8CbgrpqQHXeDOYvLOyPkK7PbcjHiw1gd7SkuV+6W8
	fT/b8PAnpff0NMUt4AxmRlgAO+/fRzI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=i5eHHhsH;
	spf=pass (imf19.hostedemail.com: domain of gouhao@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860207;
	b=VtIM9c7Jr6vrcDbe1deOOjRNtrcIrmxfLj0nuIJdh672X65/nf/nAtq1WFdPK4raD4C1tE
	vsy0491nTMqJenOfMJ6eKF/jq/Ef74Q0UPDhm6E2jaGQqMGzavcANOkvjTE92b5GyQsHSQ
	Y/lAVyrho08ca22tNl2ATjEKoJ22hTw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860154;
	bh=HXOSjewrugfoFYAviBCdTNIHqggVZlJ3YZl/fwlFoCA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=i5eHHhsHHpRZ0lSujb0HJstrwVUkYb7+cVuSksG1vsmtoOSLgnWMJNncKh4Jq/oaB
	 E5iamDL0pJ6SgoQ2IaLnL4bNnexSndtCdpGO8WSkkcKgIAzDcT/kRZj4JU819Ny3W4
	 Xlr1iEGiM/7AybrJrPCfiUzK321A4T9nXkI/EQjU=
X-QQ-mid: zesmtpip4t1784860146t7ae6cf1f
X-QQ-Originating-IP: wWBgv0NV/7CKCdcjUMM5igbrbPg1ViC8PwqJvYK5y/c=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:03 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4050712520101716894
EX-QQ-RecipientCnt: 26
From: Gou Hao <gouhao@uniontech.com>
To: maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	bharat@chelsio.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	gouhao@uniontech.com,
	namcao@linutronix.de,
	ynorov@nvidia.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH v2 2/6] powerpc/xive: add error return value to xive_smp_probe()
Date: Fri, 24 Jul 2026 10:28:47 +0800
Message-Id: <20260724022851.466017-3-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NjvKFBGFVoSK9xgt87HbcH8Z1kiv7SvOxVi9E9HTxW16wON0oiLoRDhR
	K9cpYkRkKAhYVveaNf1KXAiaq/mlZ31D3ZJywgLf0uFbssx8e0jE4Czgvn/cmi3Plgie1cp
	JR36G//kRbDr6Hzk6hV7dV/o7lOatPmd3hG4kxSOWylS6e2Jo2iKe+R4g0qLvVL2xozERNy
	ixetEfJFYVD2jK2JnBf/ez8s+ONaXhZ0WN0CkDrsv4aouXTt3L+pOGKWulmNYItV3udYlST
	6z2vDC5BNgXaqHcQ3GmS937wkCcHq2rbiD0zLHSH9c/TsrTJw1v6D7FsO2Dx2c0hHRw7+da
	uILzYcB8ALLYix09oRoSAWU4oikpl/Dw8tyUp1lW7C7NvAjIxm5YtQVbTSVBLThuSfUBNk/
	e3Zl+75dYXZZKsL/II9yNKH+EOsgdb9a/YwmVVSXGA5JT6b3tYjmYY3WWNTA63qVwMzAnu3
	tV0iYXo9kDwXeQpS5dTjfJVPpM+HlppWucCq5EWcFmTwlMri9cFb+8rYenUXfInPBFqnsFy
	qahPGA1wKLwTBy21U44edK7QR5o+bRPKZBrt1w8zAKhLaOxkuiHNw8xqaAYNQkSoFVUrGRO
	bJ+G45c9bpfy+zU6TxKtK48lW/ZPwhmOUARp9UXmg0EJeDYcTarmyM8tG93YoYvPDnJ4TJL
	9CP8VZUtXbTlAXX1jpWIeZ2Qlr/JWywphq2ihhlnuPKJXcRUih+8WCwW40cWJiIWzlWOskv
	i6T8io3pTSpYg7ReYHGi0MNZlLrRN/ivCaV92YxVtGljdNDDtCrKzSAU7GeJuDDTLq6pzD5
	CDHH2hZMc4bcSZwIWK6hSzq+BerIdxWGv5HPbM41+oK0Tn2Mz4xxORhiihowBU7SIxoy012
	OvRw18xTBe3nUs10qNpbIwukYZf5ZELlGPeKV6Nrwt4ZHv4G+XSSGODB0KCENJJYdQ4i5OG
	mi/09LZSYk3zPokU8beAKnPI9gFZpDh07YHr+qcNXFmGRYzvftAtWd4KlZ4fTy6zhjHoRfn
	hlFemawWJgeDLuVd4JslrCQGu+ebbJ3eEIVAHi9BN2YMJtbOco
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 183A61A0006
X-Stat-Signature: 8oh7s8m1pkniun66jtckg9h9mj7rjach
X-HE-Tag: 1784860205-598182
X-HE-Meta: U2FsdGVkX1/ULAi9HeNbge9jRmGjJOxPW6XjYgNtFvmVxdww605+Prw1/R99FM7HBSQeBcp8fMaCZOsodZkK2DYLhItWj1HwIa8HdAStaNl0y5sTp/qz0M9lwApg0FewBNGycZSAT2IsHGwr0A3V3FZuBYQ/49Bo1WxrMOC5sYiooDsrVP1Lx3THGUemmqoCSV7VUzexa5zUdRPS3MXLJ4WXZfIkjhCaIoCff4qe2OEpXCvCrjKt7Oe3ZBtM+AW4PFBoHwbpKBZ+cpLp2UW64JNdJ3TbYY4j3974Qr/MSY5+1khbxKbL/sprh2M1AO1C4SGMvvoz7kM+QWmwwgpS85buTVpfvpivXrsBvcZCtkzdtejYlaX+PUka6IZVRzuHTWKOQrsw24Ul7i94PvThM9JsyKyVzXWbBDbjuOFGK/Njjt0Cx5XFDjLLwjayxGy3ehZHtr7hnQBZVDNSuU+3peSlvwS82Ody9e08c2Le+2M+r28CL/dn+JpVR8zePrPwyxxkaGsD7rXsJ2wAwOAMlQthTGC/G/ec1flnTC3z4tN2FEYyUud//hggpQkAtT85d6M5pgQBTtPYyqGdULvaEJ6sVPym5khdNbivKTSzk7+S3Z0JtpbxaNQwn0R9mscQYi0HnISLf8AtJP4/o0b/YnrSUD+cmXaiCry1deK4Hy59D45Hku3R3hZf6EiX2VaAs1TZErKe6DFqRhL64cFLblFpTKEeVHlr24fcrWqNaAEt/GyIElbfSPhXVDr1ZWYbZrtf96dXEZoM1AnamdMTMnNo4qZbxeM8RHmkqh6viPiuQEEnlfdzZ5iI+SJYB76ZCOMgv5qOoAwIHnDPp9WOGkXs7fXfD4bc0EUJNRVmtEO29omgN9n5XaMWCRIVjXJeiUuEVkBF/kpooeb4+IKm3WUX+HguGPJglOXRno75OBXEZGHxUxgtgg3b2HUvV+DKyVD5bUCayFtXEiHF9BW
 kPg5pfIV
 2bds3H+Xvbste9QboMlflC3u+kO+8lnnzJYO+cahi0P61YOTXTPbauEKL5HAo0PwbUGJKWgZEMtyFXGLSmnU7BS/CDYrHCCXAzB5LZ6S2pm/M5dbfN7LlfElCCTP4sROAwr4sMYHhVksW6pvyNdGZ4BPhbXG4JMQxLtRcDwgnkYn1NWqq3fsbeE+9UQOCGqFY1eKSyglPJVbfxlg2o/uRoyawW6bJOLgbhvDZ1Ss6aFE5QitXhYGM8TbFRBOkPimRODJyG6IgvLtDT6rBCtopbHrc4BjhNHVTx9AurgJAq9D8lbek4zEKYKkxOe6nIrefnvgwnbOZxLMMB6RjRKrxZlYn7OL5PNY0K4dhNgWhUUZZ4es1db7xRMxWAkcYdrej5/AZhVB7xupr5+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xive_smp_probe() calls xive_init_ipis() which can fail, but its
return value is currently ignored.  Change xive_smp_probe() to
return int so that errors can be propagated to callers.

This is a preparatory patch for the next one.

No functional change yet; the return value is always 0 at this point.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 arch/powerpc/include/asm/xive.h   | 4 ++--
 arch/powerpc/sysdev/xive/common.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/xive.h b/arch/powerpc/include/asm/xive.h
index efb0f5effcc69..4e3e3358993c0 100644
--- a/arch/powerpc/include/asm/xive.h
+++ b/arch/powerpc/include/asm/xive.h
@@ -91,7 +91,7 @@ static inline bool xive_enabled(void) { return __xive_enabled; }
 
 bool xive_spapr_init(void);
 bool xive_native_init(void);
-void xive_smp_probe(void);
+int xive_smp_probe(void);
 int  xive_smp_prepare_cpu(unsigned int cpu);
 void xive_smp_setup_cpu(void);
 void xive_smp_disable_cpu(void);
@@ -153,7 +153,7 @@ static inline bool xive_enabled(void) { return false; }
 
 static inline bool xive_spapr_init(void) { return false; }
 static inline bool xive_native_init(void) { return false; }
-static inline void xive_smp_probe(void) { }
+static inline int xive_smp_probe(void) { return -EINVAL; }
 static inline int  xive_smp_prepare_cpu(unsigned int cpu) { return -EINVAL; }
 static inline void xive_smp_setup_cpu(void) { }
 static inline void xive_smp_disable_cpu(void) { }
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index f2904a5c2b7bf..f9a1229cede73 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1254,7 +1254,7 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 	xive_ops->put_ipi(cpu, xc);
 }
 
-void __init xive_smp_probe(void)
+int __init xive_smp_probe(void)
 {
 	smp_ops->cause_ipi = xive_cause_ipi;
 
@@ -1263,6 +1263,8 @@ void __init xive_smp_probe(void)
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
-- 
2.20.1


