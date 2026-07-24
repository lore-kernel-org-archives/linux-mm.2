Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 265F9C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90AF6B0099; Thu, 23 Jul 2026 22:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68966B009D; Thu, 23 Jul 2026 22:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6346B009E; Thu, 23 Jul 2026 22:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 918C96B0099
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:30:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19A6F1201BA
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:23 +0000 (UTC)
X-FDA: 85022091126.06.2D98EA6
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1896A140004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:30:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=VEpWfQTO;
	spf=pass (imf23.hostedemail.com: domain of gouhao@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784860221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFjFFaXMkLzxoExHNfOEPPaBXmUVyvwpIJWfb32uFmU=;
	b=gctcTe3X7E6xbmIFe1F44qpVjlB+qVB5ho4AcKoyzyB2djAiPjUs7sDsQxBsefIzgsxCaf
	AseiChqEYYh0maQbjev85ouS0mioiGfq/haah9e/yvHABsoybjxl8IHwWCesQ7hxRFfos+
	MaJFBLkb/Ij3TJhbMnqiJTokYbvr82M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784860221;
	b=zNCVLva4UlR4qfllhYw1QU2V9qDVAist6PT8p63x9FQJ1HEu8f6HnB6jDm1cM1oCRAcevy
	Dn2FaaMYMLR4w5ivB9GQdQMq4VaFokC31w/XC+6RFKXdTRUsILNQJ9xgKDs1Mu5gpjV6go
	K/G24rj90pm6YbGNH/4sYnTUDQsASEI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=VEpWfQTO;
	spf=pass (imf23.hostedemail.com: domain of gouhao@uniontech.com designates 18.132.163.193 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784860159;
	bh=nFjFFaXMkLzxoExHNfOEPPaBXmUVyvwpIJWfb32uFmU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=VEpWfQTOL9zLFbyFogjNmCQMlKaiv1ch5DwkSrh7BZ+2RGOKv9qZ7NQ96vbvWgZmY
	 KwQNpO8VjSAxaUait8NuD9BWwrJ1h3vH+OgEytvIu6MQ1/hxpbQjl0nsQJY4UcPi9c
	 xu9ZTSK/V3GsC9xazytGPIPjuS5mw3UeNUlk2aLo=
X-QQ-mid: zesmtpip4t1784860151te3c12dad
X-QQ-Originating-IP: Q0VsYdJjns2x4KkOcgSLM6b/xTyYuD8mV2X7QLUMAvc=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Jul 2026 10:29:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9743323694755543151
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
Subject: [PATCH v2 3/6] powerpc/xive: fix use-after-free of xive_ipis
Date: Fri, 24 Jul 2026 10:28:48 +0800
Message-Id: <20260724022851.466017-4-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: N4WhQbLQyIqSPgzBttvoGSM0rHIoDOFdOVlvtNsNl44gq9z78OzWrIQn
	6gTUsLCO36PpNFC0aA0PRmQnKvNci4ZQCuiVBpPbpXXISn8zdTFbgp3vKkE6ZTbobi1ogUE
	jATLyFsKHyR0ky86uD5CPeWt4gVZ3ayOK4w0Nv73iUfhXxwuohHPDR2QOkSXwKafi+gdb0h
	1X4BV8pTOicrYDaJjzUgKGlx9or5UZcU1K8SNsa37VetUCDaiU/d0CaIbuy97xGqFr6CB6E
	AzCoAY4qG7oHl+WKxvsj95cwOvTv9qDVxkL1IkZQlh4KXHmp7spDG/qS6tfu3WZLbS24DEG
	tBZ0fLHQFzaigA4CKBN/BkwdiKDNV98VH7swM35UHPCb05m6mI/yyjP4yw9ISxU5M5aMw1i
	LRcTYcQ0Kb+ZQoqRhYWH+ANL/sT0mwXjNj4ct1K1VFbmWCTYtJKNQWU5mKh9BSdaMUXlzm1
	gjUQ2XdDE7+xTon2+AW+culXQWK+nKPYFKsZS2gAnwEz3hhqW0eHlpqFezzWzc/n9T+BW1F
	USfm8IEoAt9mMb3IGT6KEBGnnH/BbAS4m+tUQwNFxKwNwcOSW5cLXvGeVL+V2FszAciqtqv
	a+67zkvAWR2kxz2PyFSIDwZ0kdKlk+5jxO3QPySjDh3+fGncTY5QZC+UiYStS1SQ4dpxPxS
	VyCPuwluLgsOqTnob3KzueH755NsrSdey9aMQ9lvEtiv9JKZQp5/lXQhcmlWoA7lVxGNEgL
	ozyPBRAVhe+T3Sh/Fu5CP5xqCW9BhWPbBZ5qOxwwHpyLTiScNYfgEXrYLFSBbrJDGuJuXpR
	p1dRHRV+4fDuKy1kQCxQjKypoZA5aVe+ujIKuDbZENUKLEelQ3eCqBx6RxgMulVxp5Q2QhM
	G2hZkRtPGSrsZoLO0m85p1NxOqKy85Elc0TYzaN71kA87lyWHSzO4PhGwn2psCCPI4lLFTi
	rtNDeat6HTyZApeULdkEsXOeFnRiftQ7ErQ61jheOn7erktHgbKaShSSlZSvNp3fZgmvkmC
	bCJ7UCKhsIkqyX9n66pXkL+khsHQYr8jD+XbN2EiDOf9A1pSEOnRcnwcItIRM=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1896A140004
X-Stat-Signature: 5o3587eew3yeqsqwdik65z8r79isxmn7
X-HE-Tag: 1784860219-322282
X-HE-Meta: U2FsdGVkX18BHSZkN3ofhX7l3MAUDaLO5iqus5JaBDvBDFQn7iTwA29K4iKfBnNVd+bcx7sHzPRlrf4KZRLpBJgbXx4/cxWhrmdCVgase0QJpp1fIojgtAYHhR8eogQ0SU+zxgcAbjP6gKVxzjE9wT+n2pQeVRnhifSYXEhx+wuoI3hCLGtMk75kohHiE/C8F2nLNdc2qlEtrgKiBqbUwRyKEPA4tv8F8bcOLVSfviaiucd9Dv/CfUFtLQP7wTpnpAE/7LDv+kmIz6efc/luk/58k4ngPHA51d4MaR5GzzmxRBHyLwx/0lJFOYHHkVAiDUXGR5sh8VXPMndwuWSSf77YRrtN5V262/mGskuyn74V2Wk7oKznB7bhbbPpsXGS8Mggoq9DxrrFl+8NBul3Q2UoglsKfa2MuMzidJRCLTdvTpWwoxh396RMgiONId4qMt1tnRFc99w27iDQ4EA25Zrg70G6a3AyCnVJjJd2iOtFrBe4kN23KqVgpOjRJAzfndMIUUa/EMWgJRijztORVUABGUV+2/33HYcx5noJ+I27rExqnGjeqL7MXqzwv4QkSBNYfhmagcVDVgJFSc9J9ox9yoDauAV+UYdEeTSg70G71ctiRsioC7ClJ8Xl12OKeJrIptHpqkewi5GUwnP2RgF3gxy3jLIojrfej2pGEhPpTy49yssxrFTFnajXcF0BC2f/F5urA4szGLLXAJqjDoYVGRzSCG20rGDd/e+BIXM0i2iXJvXb2S5Fca40hzOMD6Oqk87rGv+M4DyHzv6hoBMuAqLGcAkIGVV63Ccs+qvlBf6uGxreZwqh5/5heT5Uekt/vbMcqdBjXi4J0rI0oIsnoECRWeRchXZdCf7o3VWtL/d9JkTxHzNlmEaVM0dZR8omkK+cxK2lgyZpch9syTsMqh6Nkjwb37zBixe9QpieU2o6Pe/xtl+KAJzGxtfuOret/YuuQXct/1gIZ26
 ng1m6i4f
 Ts+24bn5HUTa4+yfPebhrhY3w2ObdarSjDDL/cUTXw+0mHDZvidzx1uGq9u61kn06htiO5R4K1h9g694oxSwZ9wssRzZG3jMQBTqJuUTDjGQqaUG+zHDOf2pQlKeDLHrDjMpH7X74VqFApT/VVZeUAF8kJ0yy1meoI6XolYHfF18rolwfOS0LGMMOO1ooJSAuseBD8jGlZM2AIKm8WKrrS34ZBlWys2lhp5R7wAMlTDDeSeyh7gAyGh//WQVvKaSfiPUQ0J+p00KU2XVJhj/a2WCN5eYFKMRZshB6zb26cc3Fdutu3ZSuIbTpzp7qK9lYw1I9C7OyHcJ9nHacVZuR17/SIC2P3xML3bLrxzXL0NT1q5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When irq_domain_alloc_irqs() fails in xive_init_ipis(), the error
path frees the global xive_ipis array via kfree().  However,
xive_smp_probe() ignores the error return and proceeds to call
xive_setup_cpu_ipi(), which dereferences the already-freed xive_ipis
pointer, resulting in a use-after-free.

Propagate the error from xive_init_ipis() through xive_smp_probe()
and check it in both pnv_smp_probe() and pSeries_smp_probe() so that
IPI setup is aborted cleanly on failure.

Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
---
 arch/powerpc/platforms/powernv/smp.c | 8 +++++---
 arch/powerpc/platforms/pseries/smp.c | 8 +++++---
 arch/powerpc/sysdev/xive/common.c    | 6 +++++-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 8f41ef364fc6f..b1201dbafcaf6 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -332,10 +332,12 @@ static void pnv_cause_ipi(int cpu)
 
 static void __init pnv_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	if (cpu_has_feature(CPU_FTR_DBELL)) {
 		ic_cause_ipi = smp_ops->cause_ipi;
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index db99725e752bd..14cd0634eeca8 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -194,10 +194,12 @@ static int pseries_cause_nmi_ipi(int cpu)
 
 static __init void pSeries_smp_probe(void)
 {
-	if (xive_enabled())
-		xive_smp_probe();
-	else
+	if (xive_enabled()) {
+		if (xive_smp_probe() < 0)
+			return;
+	} else {
 		xics_smp_probe();
+	}
 
 	/* No doorbell facility, must use the interrupt controller for IPIs */
 	if (!cpu_has_feature(CPU_FTR_DBELL))
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index f9a1229cede73..bb6ce07c1699e 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1256,10 +1256,14 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 
 int __init xive_smp_probe(void)
 {
+	int ret;
+
 	smp_ops->cause_ipi = xive_cause_ipi;
 
 	/* Register the IPI */
-	xive_init_ipis();
+	ret = xive_init_ipis();
+	if (ret < 0)
+		return ret;
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
-- 
2.20.1


