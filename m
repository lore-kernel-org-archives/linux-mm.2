Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23DEDC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4156B013D; Thu, 23 Jul 2026 04:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254F76B013F; Thu, 23 Jul 2026 04:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11EF56B0140; Thu, 23 Jul 2026 04:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA0E76B013D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:18:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 670DB1C08D3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:46 +0000 (UTC)
X-FDA: 85019340252.01.97484B5
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf26.hostedemail.com (Postfix) with ESMTP id 24F83140005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:18:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=hk7n3pPw;
	spf=pass (imf26.hostedemail.com: domain of gouhao@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/ih3PE8BMb0rsQpbXEWQtv8rMoC5z+b1JH5VZrcmKA=;
	b=fB3JkVI20j0zXVrHFVcwN0vxKvHu8TLOnSjX4SqvhEoumJ4sWGI6Sa/u6R33vJAocmyQ67
	gmQt3vbu6ZCqxt38soubgBWKKnwgr/D4uf/gXz7dCR3LBX0Xtys30rAfGnIdnPsbWL2IZW
	H04BPDDPDB2lnpI8jup09YjdvCt9yjU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794724;
	b=ClqaanRKi/yK071OuVrxTq9JzOErtF7zenSM61V7IhsSMjR6UAewWzXICKPse6mHB/bpDQ
	YJaytuG5qSrw7Iu0o5NoXjg5/YOLC2iwgiQk1k/ipbfYGPTGOCDJII7ICm4ymQKfyIvA9V
	ks1AMdMaZJdYtJyQAnS4GznpH56UbLE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=hk7n3pPw;
	spf=pass (imf26.hostedemail.com: domain of gouhao@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784794720;
	bh=M/ih3PE8BMb0rsQpbXEWQtv8rMoC5z+b1JH5VZrcmKA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=hk7n3pPwAN9KuUUdocqRwbnB3W5JY5i5bcapJ7QK7+mT0lK66wXSmDOMBMrs759l+
	 Uh7EiW8laIctNOtBTXt8O//atB5fN+fmGrzXpSHp86/Wl/uzPHZ4c2z+epCgRj8CT5
	 kPn+78IkkgEgDhvFXUmj+RuHf7XByi/+/whZZfMs=
X-QQ-mid: zesmtpip2t1784794703tfaa1232e
X-QQ-Originating-IP: Vy8SA80zHSIgO+PkAaA5Jfe2lJklerHx6qvJlapt3Sk=
Received: from localhost.localdomain ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 16:18:20 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6715730035353289087
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
	ynorov@nvidia.com,
	namcao@linutronix.de,
	mkchauras@gmail.com,
	sshegde@linux.ibm.com,
	nilay@linux.ibm.com,
	kees@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	linux-mm@kvack.org,
	gouhaojake@163.com,
	kernel@uniontech.com
Subject: [PATCH 1/4] powerpc/xive: remove dead NULL check after GFP_NOFAIL allocation
Date: Thu, 23 Jul 2026 16:18:10 +0800
Message-Id: <20260723081813.176792-2-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260723081813.176792-1-gouhao@uniontech.com>
References: <20260723081813.176792-1-gouhao@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: NUygYfydBsqcKiQsQ0e9gbXp0sc0WtHJ+NdLLpUStJ/DwoXh91QCh7kY
	i2z1kaXotEG4ICdM82i6SPNVsHgs3GzhCJV8UIOpGyAm8x6G70En2hlZQrTt/rcQY6sqg4L
	0De2IuEvLYnCzKqKzfcrfPG96pvHKrdc0XtrvwwVQ5MMEYeCou2fXiwwClxzm7DT/buoz81
	tTRPkNhNtkPIHW5BMNukb4EA13u4NHC/Zg9bXc3hL/Vic7hnK7woCrKBLK7tAYIvJ5VTtDx
	pO6GxN+41H6M3EnSM/U8ZyT0KpApme5npj3eddxywPqi8NMAyO1jjNHGquYMBOmy2msg3OI
	6xyrYGwdgz9blu3cmNcB6SOZjADfD8plUiFc4tbgcgpJIJy2KTsWlhmHdL55eUUFfcaYcRs
	lGtxUOq4gui5sBySUeO6Ujr3dyGGD4M4zLWUzpBsBtb6OpoU08ldr1q2usdXCWhmW3Ncdr4
	Km4QVxLXvO7QrN/nDIA0tDwxIO371I+ZOOQE0TvihRXmZjur3g6MIwoeiWvB13ypKjneRq7
	vceBHA1NwYjEM+2/DVlzlv7Y4wEFvkRZwmUwhpBWQeh0K1YXGqavV0gsfXyvkGXE30k22CA
	MQY7xf3sIc85PXpTu0FqLypLUd5OM4J+PZUyQkwmvJq/Z7O9fW4UXDED3qv1r9u0ZHQj52d
	tXv1oOmaU4eqWI+TCphSobCcueBY0LCqFNd0QjQ9EakejyngrDsAtSf8HM/7r5LUYPAF/MY
	5S1XA38fE/NgIIk/m5tWJQWzOXDzAMALbgUGj66UL3lhgbSX47ekjDRhCzBvo0J1gCzfmwD
	yXXaAb0zrI+148gI7+aDw4YRhSNUxwknkAZtTGV5bvnYJJL5C/upEoW922wBpbWpImL9jjB
	SLftgbu8VhNTjR+puxbLD/NZYOMdsJHSiCkq5E1MWRAEB47hHLhj23lQMWetZbCnboFzNNX
	AJ7Ng1v/qM8Bdu6DKUr+/5+SCudpSLL7oBQyAiLKHFb2PyoLMIIMDLDkPRAzpnum6+sOCA5
	xZDS1YziocR73kTxmFKu9/gJWMQBX/VCbgsJLeRuzYTcgb2IU2
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24F83140005
X-Stat-Signature: xpz8ruywxha1c66pxuy1audd4ad6x64y
X-Rspam-User: 
X-HE-Tag: 1784794722-272881
X-HE-Meta: U2FsdGVkX1+Pr3V5tzlF1JhfE4JNc9mo86voA/Uz3DhoenTdNXqcFyZB3BUUZMlzVBono39A73RNvGf5KAHwhct6jMUHdDfziSvf8xAnD+xHf7q8TDaXrghpt1lx/2brbjEWCPbU2FeOnvIy92oL2MQW480cFCI1mk/7l3wQYEoVBw64p6nKegnCjgd2JpzPltx36zthITQNMa6T2Et9WOAwTCc+TkCsFvq7lTKWkNUz4zduWyoAM/ioRuYz2eI9UDNisYgzMEFc3Rk7iVa1BryO+bMidtN4VExn0JhcIBlT0x9USMkzBJQIHWuWPRQ+mrTW5EJ6Hn4VX0xlYovqDXU8Ys20/pev1p4I5PpGSUeJNGUrJlqbxLcDw5szmtavYVPGt3RXvG5RdG8/1Fzj7wQ5VfyRxv3as3qedX2Xw3w53hm1pbe5FqR9r6g7icUMzguKI2/DXQ208f1jgmufNGME9pVqEKzGHg5Coxlw/44Wx+7SS2GMev35Km5QM3F0+Mc5azLdBWN7nD8iAItf8jIs9EHpLFuS5uiek3ziPxbd7iA1q9Jf3q7ggb3j1O4bt1HY2sRRf19w6o5zcxXvpcXbk09lKPIjYsGgt2z8ft30XFtf6vAvONCZc1qebrrzjCHTryjsiXRIevxnsjJBDTm5mtoXib8DcoH0jd93vFeCIR18a68qZ7jet+oKl8oTrfuQuBj56mP0Z3s5yB7YeCRg/Ea0mCWMBrIVmZJJ671pA1GWvqc+uW2JQcnmaudpP+JJ/ZWn/Ge2S38q5IWU07kmSl2/qL5ezF6kZtWiSKWDWV5QPYWnnJY9bo1FXGtZGEiZK8xR5LVdYPSL8Zf7LWGQ7e6imPhIGmn6mwT2VrT+zN0XjVTgzo7aABBxDo8C7bRn/ghswRt/ebDTzL8zWs5mzfhL+ELjps/ChxKUFjJZFXQ9c8MfB+3+SMtrIoPnWsZMNrR3ddHJAZP7Hvj
 +zgRKdHE
 zXcaa/fq9cBUEcAQigP5IkHnWVrjAA+HQ7BMYKtrDV092LFZNiiaBhr3QpiIpQj/YsgRyj4q0JIOuOgiUjFb0SS/hdaj+ikYVLTwQIA953HdunVoOYsaXpzKalILTOO3REiHwyUGMxEliCmpn7Aef7IbAuzmhEHA86bkSp07MFZGJH4E+7JGxdlEc72NsK76jxZ5PTipYNZbFc5hzreoDxA1RWG/HBc+uGzPmp+sUKH5BfmvhfXmfPKRJuCMTp6R0oXm7/9ImoPne71qGaiJyk/pFfLv/svmriDGj5Kg/nj5KHI/rn51ARQs+QiZRCjfrW6ZuIo90n3Ni75pHL5lm6bdt8LGD56Km8gnhGQ8/ShyWzDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL check is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
---
 arch/powerpc/sysdev/xive/common.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index dadd1f46ec93..79d7854259cb 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
 
 	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
 				 GFP_KERNEL | __GFP_NOFAIL);
-	if (!xive_ipis)
-		goto out_free_domain;
-
 	for_each_node(node) {
 		struct xive_ipi_desc *xid = &xive_ipis[node];
 		struct xive_ipi_alloc_info info = { node };
-- 
2.20.1


