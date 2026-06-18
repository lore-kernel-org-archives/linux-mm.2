Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89191CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEF36B00D7; Thu, 18 Jun 2026 05:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3968F6B00DA; Thu, 18 Jun 2026 05:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5756B00DB; Thu, 18 Jun 2026 05:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAA5A6B00D7
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:37:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E99EDC2BC6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:52 +0000 (UTC)
X-FDA: 84892491264.02.F3DB39A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 26D722000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WaN5b1+Z;
	spf=pass (imf31.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6un6F2K1+9bVVXAABMFiwJ4ZramfbH6V/AyfeI0rqSk=;
	b=Moh4Ak7qBLva4dEjn6eoHYbFL9faWHXOnUnrc2XhmzfuVOjux/5nHOQ8AQ016CcxKVsXyt
	Lfjvfpl1L2ro83W3A+OpQaeRTfn8O+0igaxQF3n/BllESCWWvnMVedUZfVUzxGrSttt+QB
	UUWiBIv79e94DA6sQ3G9blToFoVLNX0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774510;
	b=ADauN7TLADyt8JWJ7gRwGnxtLEj14vSmgg5oPdBDf+0QswsJk2WURlltknJgQGn9P0V0b2
	Bv9VaKphMiPkzDRNrIrv9e6FayvlN9q+P7KrrBghmyik8D1WfTHmNovwwtPLYO6+q0REDC
	kv+JSokBeh+TiTCIdOVD6FqMk64XlEE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WaN5b1+Z;
	spf=pass (imf31.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774500; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6un6F2K1+9bVVXAABMFiwJ4ZramfbH6V/AyfeI0rqSk=;
	b=WaN5b1+Z3uNzV9MPbLXGGq756PXP4O9h4yfSj+UU8PjgCEE1kSU6uwNtniN1FLgjvDB2w5DLPRzHsxiygGqb/kMORNZnQI39l5G74zPfd0QT7Vikn6hkTnLaUPfPuDmptCXuEiQEREdlyFfgYYkHv19Hr7FSIgZS1crRr/ELT2E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0X56USpv_1781774495;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56USpv_1781774495 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:21:38 +0800
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
Subject: [PATCH v15 1/9] uaccess: add generic fallback version of copy_mc_to_user()
Date: Thu, 18 Jun 2026 17:21:15 +0800
Message-ID: <20260618092124.3901230-2-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26D722000B
X-Rspam-User: 
X-Stat-Signature: no6k13jq5idrptuygcwpxu3nzce5ya4g
X-Rspamd-Server: rspam08
X-HE-Tag: 1781774503-740735
X-HE-Meta: U2FsdGVkX1/D9wOZ2qwP3SJkvq5FCS6W6U0IbEY2h0t0KFhfsdXHHnVkcpU/CXTjkJWLaIUjY6awJCcuFwsUHUD4geY1EcaXt3Z3GZAeEz/NS8p4ev6suARIuQag3TPw90DHHqG0kUPwjL4h66UwpXe5HZzAEdT0nG4/6gPqhIfTwrpRG7Es56JLM/nqvOYgxsMDUqbgDgNa/yXMWrk4eDB2JNTaWuIF0ZY1djkaMdNKTvGjBe6C8c/TbWOG4FJ9HbXzBTfkES3aVmL3vQvmEU/XgFmVOZFOy1LJ1LAKbu8a6Oa9baclm1OlzG5BuhbcOWSy0Ofzmf5jozaTjj0rs06Mxjp8eGZKHNkVwTUXGkCg0kmW5qwIiXRasXC7uk8c09KrV/pExSewZ1A/813PyM3NT7pxfwwWMD+ev/M+g13yo0ATlbaVZ6B151hnuy3czuMPT1QcUZreUditaEmjVVaw6tiwH1cUqd8PERqUN8sH+zosna015cTK+/smr0kvGavk6w3bQHxYihHkRaD0uWO3SsjIrIzWWCqBLwwp0IXLceLWz6qGXPXleGvA4nQA/a6cM1ru4ZLwQTSZGvucADLTvKCmP+C2yHDr91yj8q2TOqCjdNviF5RnKGmJ/b6LHGDZFBGkYYhhrNJPCs6hkIfJJQnA+7Ir2sLfcsSxdPiUsxFi8BbbCDzed/PJL9ajgEF76XObGXYxegcbziaCzcD45uKfKV7YWnFG3LQMr2idGDT9v2uNfGhdyyz2JibcsDqdOr4LhQfvGN/p9IpXIclJ3SZhQy89X53hsdZkV+KFzaTLGlEahyZ1njymM+HH7lBZ7CY716tQP1M5cgMBpXhxsmpN7vFM8tiUyGUInDeXLB6aX4YMrf6m/EINDJS9rzohjrChUyFqwtbzQEcagBRhl9Or7ACEjPfGyHGBm+ELbSEuP8/E6L6QKoPp0MHdStdbRAtx75y7wV5G18n
 fK13FRbT
 Eo/Tmjo+tmvoKf+wQAnXR27Rb/NWmIYFFmcZ6yMpHZLysJ6l324ENJ7oil0fZFgMFSVtYAo+PR/ecx8iS8d/0+6/j6MwAmpb1Jzzr+g7la/3ScJlFL5WlP9Kwo2wHE5EOSWdLz68EnvaumzhDrq3eZMQvN9NYqnE0TpiL0+7WCzPb5Sq5C3MPlwUQBFtuTZ5bHKQUIDhY0Ji1YwXnmTC81AOGUFpkabpuSbLV4+VNm/B+l8pxBGO2EW1PvZ1wfQp7zlRTCvxXs7VpWJZv3q23vR0mKTUefqgjDFGhBPa/+A4eCUftVlWp5AwkXXZ1hKMWv2qEFxDX3XXpkLPoivcEWRVFCjGhrZxCyPMlVq0ebRs+QDuEREMZ8Rq7RAjywkqzmg2RBzmIPAjCTI2RnJ6gm090zhrwf9z5TbG+Ac7MVISn6D86MfDK3qAa3VrZ912oRpnNvUb+kicyhfI=
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
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
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
index 56328601218c..13b4a3a15437 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -250,6 +250,14 @@ copy_mc_to_kernel(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef copy_mc_to_user
+static inline unsigned long __must_check
+copy_mc_to_user(void __user *dst, const void *src, unsigned long cnt)
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


