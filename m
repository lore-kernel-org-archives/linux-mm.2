Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B87CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84996B0096; Thu, 21 May 2026 03:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35056B009F; Thu, 21 May 2026 03:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886B66B00A3; Thu, 21 May 2026 03:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1D26B009F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:18:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5ECBC10B1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:23 +0000 (UTC)
X-FDA: 84790573686.26.53354C7
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57AFE4000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:18:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=etH6b9Zu;
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lDIPRhu4eC69IHX//CJMd4ihavt8RgvIqQIf1iXGap8=;
	b=lS0MXSbYJxhFWurYYVYntThQN25qM+zmhKnpuWy8FzEUOQGjSUUzZZUvxJ9pczBu+7Rs/Q
	N4EGQ+h1C9HTOY7nnaWcmCBB9tBmV4erd3Yr6fuVp68icOfE5PQww2Pa3Ifhdhy3H/VycG
	Q1hz399deo/SSrTg13HhUnkEQc8dW00=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=etH6b9Zu;
	spf=pass (imf27.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779347902; a=rsa-sha256;
	cv=none;
	b=jshCvBCYaiiAsu3S3INgIniCRU1WLfMAJqHxee+nGgvbOJ8XyyVV7R6SOb8JmN4tnxq6Dc
	98L25M/ezrwB5Vc2KLzKeHQSm4JUUkeEtVZ3ViLYeKMxSMfnT8YvTrLYg8hDvzWfDa1n1c
	E/foDeVZD8jncTAkEqtrepJ5JSG3XUw=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 04328D092B;
	Thu, 21 May 2026 07:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779347901;
	bh=lDIPRhu4eC69IHX//CJMd4ihavt8RgvIqQIf1iXGap8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etH6b9ZuDhqX5Sc5pXZJL0mvSO27yOgyFftApBQDRLpChk0d76J/dnjr9Me92J7s/
	 ZJKGaD44Ap9wM7bVcPGgw4E281DFuplUA3GHeDd8MZtjlQNmb8BgD1KF11wYyDYbZJ
	 iR8eQxFuk+u4YlwUZ/kmzMnnQhVm73DDT+RmYKNA=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 2/4] genirq: Move NULL check into irqdesc_lock guard unlock expression
Date: Thu, 21 May 2026 07:18:02 +0000
Message-ID: <2b4e1f690f12c8fb58f286846037c0f6d9656c46.1779286416.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779286416.git.d@ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57AFE4000C
X-Stat-Signature: ufois1ym68yqiwrnpuu7q5bkohaug9pg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779347902-754984
X-HE-Meta: U2FsdGVkX19EBy0XuRd5RUYbEd+h/7j55KkiESrkPVU/bNEqOVzTPH+Y5NgNBvKzMTJt5sFQcCIHXUU2BgTWDx836CArT4tYcO9awAbxza6nbTMDvmSRbulNhNHc7vz7GSXE0RD+pkQAAFpOG/+cpgnJ4SITr3OuzpKXgESoa5UTZzPcH0frr/pGoifoOb/J8M5X+MHieL1QPomg5H9g1Tdc2+8NcmCggLrl5rqe3KsQd6zGvGbILyb53/6bc4EvZS+eGfH4wTyG580Ml/2q5m80yR73BpFrGBvn0F3hZ422cnn4W1O/lyQEb36Ck1aMfcUzU+KRn1VzY97uolrx0RG8psMc05eoB6Ozo6LDJlor1v8ZVTeMPWQuXEtAJIJGUeqNe2xO/tg023svqL7ce+wd0eJ75/b48w4QewKNVsBVHlmHkT2/LFr/pdA3aA/yg9JWqsoN8nZlingn2aNzWgmAftA/yjuthq66tpbCKqlkjEH4yOs6HCMtn9zjAjbhhlKlvxXWSyZY0WW5NYSrrI1cHoLihSRNlGVCsljxfpYbQTDgF3uEtYMdXnK1zUKSkyBRrilP6XghvQ+afuPRmfsWO/VGx3eKZ2mSdNUQ8RN1lKmgc/o8q6yZTxZk2aFSA88M2v0ED46JGShIiqx61z0oOpVQ24agYyscmBal17zr3xuIKb3/I+Joo7H+3kCB1C6rESCmz50YI8Xxnw2Fn00dZAwyQ17/zKXKuBV6AWjrxGEkBaXcnfDuOOEo5rLQBhF8YT6Ewbhsv8ZCOkEV9NZWHPpv8qNqD8R6eJve/xA5lyBFDaWbyGhzl+L51ql8aY1Vo1iNm5zcnxb/W9ofBm1ll7LlsxDXy87jAiwvN12Ps1KO1DbuOqJ+M08L6x3520BsvyGCXKWBEprNuXea4n2sDfePTn87J0ntSxERhsAWFmJehUFtSAFkwnSTs0hz7/WQH/9ftQxfX13poXl
 SRjnMDQU
 nAojQr+5ucYV9x0hBjEZ5w6aFsAcQyr4h/h6NEUhDN6yP1Z++nb/XcDy8IJCaYNxUV2fJoiPfwLzqYFviwB+fh8jKfcrD02kuR6CywNDC8HuH7H23KRgvfc5Ac9MRLS7TDTkV3qnRToZ0/vyTU/Uhf2oArUh1T9Vu1pV4EqJo4SObD1zsGRqdHl2lSn2mT1eRTtyqVZFvxiApj7UNjqx+gatkj1b7kcJxsAbH5TRnxwGgJDNsouJHhla81hyQD7AlmbDLm8J7bEPYR/ZhvF+yyc/SEIBT6Fec7DGqC6EPPpBuxaystXMEyvDJmTnQPi1uoyV8UVKQ4DXWYvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

irqdesc_lock uses __DEFINE_UNLOCK_GUARD() directly with a custom
constructor that can set .lock to NULL.

In preparation for removing the NULL check from __DEFINE_UNLOCK_GUARD(),
move the NULL check into the irqdesc_lock unlock expression, making the
NULL handling explicit at the call site.

No functional change.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 kernel/irq/internals.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 9412e57056f5..347cb333b9fe 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -171,7 +171,7 @@ void __irq_put_desc_unlock(struct irq_desc *desc, unsigned long flags, bool bus)
 
 __DEFINE_CLASS_IS_CONDITIONAL(irqdesc_lock, true);
 __DEFINE_UNLOCK_GUARD(irqdesc_lock, struct irq_desc,
-		      __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
+		      if (_T->lock) __irq_put_desc_unlock(_T->lock, _T->flags, _T->bus),
 		      unsigned long flags; bool bus);
 
 static inline class_irqdesc_lock_t class_irqdesc_lock_constructor(unsigned int irq, bool bus,
-- 
2.53.0-Meta


