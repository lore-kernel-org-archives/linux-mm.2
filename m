Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359DACD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E386B0088; Mon, 18 May 2026 04:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545036B0092; Mon, 18 May 2026 04:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A046B0088; Mon, 18 May 2026 04:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 30D3F6B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:50:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94E16120821
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:13 +0000 (UTC)
X-FDA: 84779918706.18.12CC936
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id 421A7C0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:50:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vb7dZ+EU;
	spf=pass (imf28.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779094211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snbZ8y+F0BUU/EmaB78zaC79H5axWqPJEhlqfbfpDD4=;
	b=zZjTIAJRtcoUkhkIutg2gZvf9oyreNsYc8w92pwVxWTvZE5+s0I0/eeZJJsUwWZVUXDVPn
	dD1NywRsM/z7lS1OswoQmyZk/eaUy5NBXpuitzYWXNgSmc+Y6UJ8fvgovs8koJrze3Mdu3
	/wFTg9/a8r6b48Ckl2opHtz8mxvz2bI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=vb7dZ+EU;
	spf=pass (imf28.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779094211; a=rsa-sha256;
	cv=none;
	b=y+ESOtRWrA03pZuqfaGzJyARzp7sy0fJz027aav+h/pTEMJw48OLEzjHhx5a3k0So/0dJ9
	FTv7FnkB/72NG4ngLMBi/fvoGhuTcQemejgVk/GLMa0gZf4PDPx25dG8EpUqgxmpZhpxNX
	0IBmIu6/McLf/g8YnH8L36o2GQaXlzc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779094207; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=snbZ8y+F0BUU/EmaB78zaC79H5axWqPJEhlqfbfpDD4=;
	b=vb7dZ+EUUb+OmE4O892sEDz/o5wXBHyKSiVHovmevuT4WHHDNBRDOUrx15Jrc1FmnxUx9FrzbQyg78uWmpN/DiYloDHBXg9D8XTOIAz5q0DnOexFxfUgF5CFpBNiWTsm7SpxABxPsHS87uX0gLMgvqc+h3HvMnuZCZUPC3Wn6FU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X3647I9_1779094202;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X3647I9_1779094202 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 16:50:04 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v14 1/8] uaccess: add generic fallback version of copy_mc_to_user()
Date: Mon, 18 May 2026 16:49:45 +0800
Message-ID: <20260518084956.2538442-2-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 421A7C0002
X-Rspam-User: 
X-Stat-Signature: xqjytqj1agcngjass4js4x53xmfw1for
X-HE-Tag: 1779094210-684646
X-HE-Meta: U2FsdGVkX18zWS1S7DnjJ2ATx0rZGUBSavQ3CV2q0WyBLMXWSGbXWJBaLJwVM2DsxaWtSgcoPB+iOiIpKxlE34ZqU20Sj5DlrBA0oYsoOKi9pAUzfRg0ToKEpMEhJEjbcRSD7MCZC7U3N3Sx/f2ixo0/FHEE753kkm/WFUDWYkBAL7rirK0wdNNOmImKx6y3gV3UomzoVdvb3hGymtaBQTEfyiJbQ+siRD0SW7Ym5HrfmuPFjnbqTk/i0yZ5/y090WjI65e+tB/XwoGvXYHdmpoCL46HPClr/KksYl9BHYtqzsWz4u3/u5A3FD0FhNtjun14E6GuJeHinU5Q9xngwSEzyEbFwU2sqyN9HkawFBN+ESQOwRO57DumGSjuGrkJBW9PusuRZXlMkR6yOj5RrCICCVFyHr83+9WEc95CxtXvtgCzTnyywXWGw4zLUE/tzMhDWCh0RTCwjvPBC5hRMjrjTbg0EArpDOwmDcFnDJmqPBU9jJUySoC4AuCPVD8fJK7VA8kjrwAI/GSWWxm52AVa5YJX9HsPCIi5KjmDXxYCcm3CUMsBfuTV8RHSrYaL60ikz310D3tJTGLaAJ8BSwESBwklsE8kSODChI+LM/nLo2RJmNg0FuLeo1EncKgZi+gHeKF+SLgmNfKmWt2MUrOYW1eiXqrCScH3axdJpmu4HAd7R6hOuJ3+kSDtxCNlcgo+uV2Y/SiGoeX0pHe1+IgwaITMSKISuklgn/HAvOltNnHipe4SMyhrlJhd9XCsxgPH5s9KQFDqmgC4rxO7IiXYZz1KLmM2FFRXCKEL5M4yo0gf/S9yu9xhVfSdSMiSb4V4xCFa1WF4mHSCPjJporVJc//0qAf+VINHRQCQae7L35+B8TFPiGNGOz8DS4UsAM1CQWa+L+GUmNl5as6tL0yeLayiDEB83cpR48TQqfY6QGnGNSPzrNzriEQIF8Fr/qsAoMHaC8mIVWl66of
 7EtfaLFB
 1rJMz+8xCap0n39S7YlpdHYvAd7/p7JsXIsXL0bInMZ7VrHFhi8MnKlwEMfD+ShawvPDGQdrGV9B7ntaTRML0Mtu7+hoy1qRikLPQ28guGb7ZWrGHlYQqet+/kj6s6P/YHN1/vqRZXKItdJyHz/WAFAKSxAP5YOTK+IAR5bEm8IylxNLApuvB9L5ezlzLo4o+la6jns+np3iiKJHulvqkP436GSbcRIrtzZoXdqa9cO9ri5avQnAyGg9yOxmGvIk9wwVGXvvtr9zM5HGi25OcIGN7PxbmsPp4yQgLGXVXUzu1D/EZyHcfLpSP8DcVdh9ZhA/c4d7mseuUxGV+AKlrNdAEalcOOG4Ie83jUD6sFYgVtq0DAkVRHPj/R1lMKzLuBRJdQABkBkjNjigwrCoUoq0OcNz+qW+MoIZ/2Mcs4OBe7yYxIgcH3qdIRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tong Tiangen <tongtiangen@huawei.com>

x86/powerpc has it's implementation of copy_mc_to_user(), we add generic
fallback in include/linux/uaccess.h prepare for other architechures to
enable CONFIG_ARCH_HAS_COPY_MC.

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 arch/powerpc/include/asm/uaccess.h | 1 +
 arch/x86/include/asm/uaccess.h     | 1 +
 include/linux/uaccess.h            | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index e98c628e3899..073de098d45a 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -432,6 +432,7 @@ copy_mc_to_user(void __user *to, const void *from, unsigned long n)
 
 	return n;
 }
+#define copy_mc_to_user copy_mc_to_user
 #endif
 
 extern size_t copy_from_user_flushcache(void *dst, const void __user *src, size_t size);
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 3a0dd3c2b233..308b0854d1d5 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -496,6 +496,7 @@ copy_mc_to_kernel(void *to, const void *from, unsigned len);
 
 unsigned long __must_check
 copy_mc_to_user(void __user *to, const void *from, unsigned len);
+#define copy_mc_to_user copy_mc_to_user
 #endif
 
 /*
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 56328601218c..c53a65394f80 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -250,6 +250,14 @@ copy_mc_to_kernel(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef copy_mc_to_user
+static inline unsigned long __must_check
+copy_mc_to_user(void *dst, const void *src, size_t cnt)
+{
+	return copy_to_user(dst, src, cnt);
+}
+#endif
+
 static __always_inline void pagefault_disabled_inc(void)
 {
 	current->pagefault_disabled++;
-- 
2.39.3


