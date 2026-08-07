Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 499C2C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369AE6B008A; Fri,  7 Aug 2026 06:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A6D6B0092; Fri,  7 Aug 2026 06:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231C66B0093; Fri,  7 Aug 2026 06:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2CC86B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:39:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6945DC030C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:39:01 +0000 (UTC)
X-FDA: 85074125682.05.705AC9B
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id C42DC1C0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:38:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K/B1TZEE";
	spf=pass (imf20.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786099139;
	b=cvORq6Sc5Cg4Hjz3I5rQ61Uss29pRG/JImAL/3Z2koe+T/tREWuXHvWG6BK/Gl1k8qF8vB
	4C4EIYXSnq+fdsIU6EDMxicU/FzwFM5ltFtFiKPtOQc9+KTAO+FkCQlDXG4UDPmiPxApGa
	NhWnMdxZXILgxQM86AxFA0osAv1PfUE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="K/B1TZEE";
	spf=pass (imf20.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786099139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IhT9Nbnrmy1FCrntkD6IOlFelDNdobApjep1pMDJx7k=;
	b=RL6YnarKer9MvXgLdPbgExe3q5xQaoa9Xs1ZR2JwyLLj6i605EZGfFiV3awSE1Kj7C97vs
	CBtjrwQxSNRLXNDId+m/nVbTXL8bKBCDpnf3ndz18Ohvw4UQ5DmqUvy1qoP0LviZLVChvC
	W+Iu3j6A77iQxOR5TTUq8E+b8224330=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IhT9Nbnrmy1FCrntkD6IOlFelDNdobApjep1pMDJx7k=;
	b=K/B1TZEEloG3kmATLa01mpjHRXTcYT8OdEuMPA08x4VuWBrroYrXT6NA0bUekvtBpiPO5j
	d3a39YO2i1b2WEXhstvivoHKfRapFZFDDTQ68bYv28/okWZKG0ykMrfKDqI3vj1LeU5hwp
	VCQRU7Y6V/hVnlzk62RoS48vudn7TtY=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org
Cc: guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for virt/phys translation
Date: Fri,  7 Aug 2026 18:37:13 +0800
Message-ID: <20260807103714.33074-4-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-1-dongtai.guo@linux.dev>
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C42DC1C0007
X-Stat-Signature: h95u14aujckwgib1bmr91drohgzt8773
X-Rspam-User: 
X-HE-Tag: 1786099139-84348
X-HE-Meta: U2FsdGVkX1/mnLoVEwhYwFmUQqQ+T+sPpI+dtugWUbaETHUEJV5jSPuW2NEo1tS1opqZhvQlfEGg6ElKivtrYWvQWipMwyKQjh+xiiEJd4QBmeMT7QdrrbNE4QBFrRj/GZ5qNDbEWKPIlvyy4WPDpfDLNd6u6NKXV+yjRA+uxmfGytip6WzGBdTUU6nmshcCd/nAVg/Fl/j3nrZ1mkT694XcxlXnhHmuRCzyfTFExY+4OtgdoiF9+xmqj4OOWBcrFVNhzI2Sm4sGYdqRw2KVrCEWuUQSw8hDcndTTUZMO+YqrwDq32YEvQblG8fBDSHMNNAd7IrOJiGSiRqZo8A8A0PmHmIdlkw/gvGX6C5v/4I2WKznBo+gcTqftILM/aB9MEt7QTNjW4MTCa6xFR4G2BnuC78ESpX7nTUXdlna56bLcWdVcJx/OJ9yabbVu6mXFgLNIA9S+Eietz6HhPb8Kn2spqLDO3P0Opoo/0tYLZbtz9H/TeOhW5SNVhKKxSR5LBlgGGP5djieVPm25y/sngi41Maj8npZB3pT0RBt7yqG9YM7r9g8mnHogaZ2jXPl1c9EmMkvRBV7r5GKvM8OwhhXtzeizUihwEySyTt0+yxpPq/qLudLRj87geQI6vIr6augw+m0bHdzJclr3hkKF5ibBqtmF2FuAY6VuzkatTcmJaIBb4DlcAg6rZu2Adfy7dr7uhEaP4rRNrjq96D7MHt9Amppo+lqoHWTyIVG+HsasjwNSr32aLnxOPBpAZL5XtgVrzqXYz3535FPnMZ2SPPPNajvxgFnxRV/KQdqvc9Ca0Krt7emORLbzZ5kQFX3EtBSMV22+NTf5yx96tC2S6IJ9RSVOr/WVy/ZmzA0tcKS6hekjYeLgDxmdfpfR0tqwgCYzvJz9tujET14fikYME4e0xgSW88Hq58XQWOyVrV7XxQGrvz7/Y0Xc9djKQntaAzuUr+uGprb5RGJwOo
 sR+s+LV4
 HMBXaaUxvDHhGmryPboeu7oYdiYK4PTkjVc5EWtyh96L++RVSEUw867smoVibWgN90Y9H/yYUbpOZYXGr6glRQnUGmBfmmMr0Jz5RwrPIuO7ELE0EKUfVFE6+zU4719mSYiviyYwR7MW+E2OF90fu0yJRpKafz65uC9pQCboNkTXZEXYxooFhp9VuIiWYP8pgUh45OF0xabQO8yjzk/wappjsR3ewxjx8klZzHb0kopm1F1iCxlFoyY7oBJ9slHGQqrLzGkrtTvv7BPsMOzoF/AkPUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

luo_session.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
CONFIG_KFENCE=y, these macros (in arch/loongarch/include/asm/io.h) expand
to offset_in_page() and page_address(), both declared in <linux/mm.h>.

Since luo_session.c only includes <linux/io.h>, the translation unit fails
to build with CONFIG_KFENCE=y:

  asm/io.h: error: implicit declaration of function 'offset_in_page'
  asm/io.h: error: implicit declaration of function 'page_address'

Add the missing include to fix these build errors.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/luo_session.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f38b5b18f3f8..31490ac7b63d 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -94,6 +94,7 @@
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/liveupdate.h>
+#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
-- 
2.53.0


