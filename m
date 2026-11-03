Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F6A2606A339
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BxTAX8VR
Received: by kanga.kvack.org (Postfix)
	id 2673C6B05DB; Tue,  3 Nov 2026 03:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23EDE6B05DC; Tue,  3 Nov 2026 03:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154A06B05DE; Tue,  3 Nov 2026 03:09:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9D9E6B05DB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:09:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88BA41202E9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:49 +0000 (UTC)
X-FDA: 85393084098.03.4FF9BDB
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf26.hostedemail.com (Postfix) with ESMTP id 098A3140008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BxTAX8VR;
	spf=pass (imf26.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf6qC7Z68PAfi/g1Lq1I7GPVQN/ADTRNm3/p9ryG3Ic=;
	b=HNvkJnwrV1pXfxV/R/oPWuo0bRpPvPLWVvqvtJCd3kkAcg66t1HxPg0IX15puGFwa/ofzd
	3K59pL7UYfQ5+kiyQq825W8hMwK6y4eK7dZC6cqpya2c96nv8SkY4olNj75t+aW60WCpjO
	KTkn/nc0B2fv5t7LEGE0kkfppAcXt44=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693387;
	b=U/kyy/9ezDX2vNx+9Coj90clQ9vXDRpCNQ112uiYTIoiSmqNzr8pm6tzUSwmrZHLAqIexy
	mGRoTw6LlxjwEJTC5mvKIvsuQWklrxkYkQDL0S24KG3ua067u1sTQODFra+r72T9xm/rM6
	CGZhTyhfq0VfKKnX4HsUM6ZybWU2cvk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BxTAX8VR;
	spf=pass (imf26.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793693383; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zf6qC7Z68PAfi/g1Lq1I7GPVQN/ADTRNm3/p9ryG3Ic=;
	b=BxTAX8VRtOhWPBzgGjv2raOsIG1CdVFV/Wn+gpsAafgN4CaNxyvOygIqCVReS/hByyiLC5wojvtdu8mdCy4ogC/UGBWUTPmcLtAT8VvDT9LzY1we8ZgAOwOTlxenMPFkvdk9h5y2Z6XJ+MHGD+X5KRGeqh12RqAALHVEl+oitSE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XE27L0Y_1793693381;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE27L0Y_1793693381 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 16:09:42 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH v2 3/5] riscv: Add support for kexec handover (KHO)
Date: Tue,  3 Nov 2026 16:09:24 +0800
Message-ID: <20261103080926.2079-4-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103080926.2079-1-cp0613@linux.alibaba.com>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nzcohym7qhi6yqjjd67547mx7ckgi6dj
X-Rspamd-Queue-Id: 098A3140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793693386-980967
X-HE-Meta: U2FsdGVkX1/8NuNvyaDWMBAoVeYadtH+lLCiDvDuZbW8iq+nvx42DGGxQRYXLfJigjUhI52l7hfkyFkShknAyugI+wuwNxV7x981qQ12ksmyoB8pns7gQ/zSiTVQI/AJqaROw0MRkzXqIHoh8lFEIjDFZ5Nq/49OxK/HmJ0XwYXBRT8ELhUqWq/l6/btcRR+b05h0piPbXhKfMF5lNekRuyMytQgzmMoG3iRbFDsAgxBeUfEqkY+pmGNElnlKtg3ma69keZMZzEWj370Vlj5IEsSzy1WglacfIpFBCG6XrZNIe9L/x4OscYcN4mROiDQ31rdwAiXTRMeeGGilmKEbojYEPQASJgrzgaQtvcqsqTZKjr/L8yCuZz1e/NXjIAYRyvZl5laiCfBEe0V1tVIP6jQoixjFPJGBwzCTf0Yy87kGWC2gknNMTfQ8Zgiz80bpl3AjcCkDkroZF1p1oiqPePoSmJbGeA8ZhzpuTVdVPjEgmhZhovWqr+KGutvJGmQKCBs6CQukGZm2t7aU7G3qDiEe6oCbdkcNVwCnlEwr3Icobf+UbINT/3bFzz7sFPY5zsOdIYUfEOuOAn7H7CMUrmAJcQj2p11x1o2XMikH9Ha+hiPU2/c1enPB21/jJZRdNCt7RYg0gOLsedB7ajreAOSyRt0qQ072f8deN2EtMilIhbXRZpb+qJohO2GBBP8eoIOp5JsUJ0DsUW/CCr/dAX7urrGfs5LkBGEfsjzUE52z4UXA/GpuSGhto4FEwZfjZcPRKCcAnw8WsOTqCv9BTXdG8SCcDgQYJ6A4LbukAx1wfqgxpuzu89i8CZvbshf1tx7ZybZSk3bwaXq+55mUnQv+JyczZKWuAjjfUkgzeRiGUzEo2ZHo7aAcsPhwQP5tcbHNKbvonPIZRiKJ3OaLKZ507c8FbLCwtZR89p21MsXFwx/lrX1soyVhxjsaMthEJGhQJIXLPNAlshjd3T
 z03qYuHO
 BrscLGSZZbYN4GFUfCRbAoSLXYbA3qk/XeCCYavbZFVRrhMZ9Q5wIAI7X8792Yocj3bm0atg9Tw+WjG2885iMf3h98NN2nz+g3jXFApVVlZ3MtpNdYUP2PLmOF/jA5oqvRpJvsHlOIktd7q8Bf5/SeacEVYbSgG9UG/BoiRH/iqxWVRF5obl8iLzdo7xoa1Desp81IYZRQXHVKq2/58Oj53Lie0d5amNCWM3SzPPOesle47FZmEQrAjiRa2vbp/O6VtSG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KHO is architecture independent: the outgoing kernel publishes the
handover FDT and the scratch descriptor array in the /chosen node of
the DTB it builds for the incoming kernel (kho_add_chosen(), reached
from of_kexec_alloc_and_setup_fdt()), and the incoming kernel picks
both up while scanning that node (early_init_dt_check_kho() ->
kho_populate()).

RISC-V already builds that DTB in load_extra_segments() and passes it
to the incoming kernel in a1, so only the architecture symbol is
missing.  Depend on 64BIT to match ARCH_SUPPORTS_KEXEC_FILE, and on
MMU because KEXEC_HANDOVER selects CMA, which depends on MMU.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 arch/riscv/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 435da0713243..e11463a923a3 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
 config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT && MMU
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
-- 
2.50.1


