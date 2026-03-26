Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35FC910AB832
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09F46B0089; Thu, 26 Mar 2026 19:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2366B0093; Thu, 26 Mar 2026 19:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0AD46B0089; Thu, 26 Mar 2026 19:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A3FFA6B0089
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:37:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65EE0160ECF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:07 +0000 (UTC)
X-FDA: 84589827294.03.562AE00
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99338A0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:37:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZIR4es0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3IMPFaQsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3IMPFaQsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568225; a=rsa-sha256;
	cv=none;
	b=huk+0pM3cT1ZIS+WHBC/YrBNdtT5g7XbrvJE/DV++HlkMSYGTM07qiSSdChlHnmFXIoigo
	ZPj2ULlK/YiYhav+IG35UY1eraoOFNYZB1WmxiI+keYyi4zCmKdjJ2JXf0YgHrRTP68/Hj
	Qp5fGEglfNKLpj/OeRxbX5ff15YCVqg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VZIR4es0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3IMPFaQsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3IMPFaQsKCBMtv3xA4xHC6zz77z4x.v75416DG-553Etv3.7Az@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SLjwHN4/NEPHQ5GPdLGfuv8Jy0iItB0IfnGqB+YcFdI=;
	b=iYfvaUgAmvfV44iWd5alO8zoJzlnVRDQJqmcOfB5vVmQ787obHLyb1HurL2D6AKPH6sSyI
	TyebOKXEN825ZcXlBIH2TVXry5a8xLcq1xs66Vfh+hOOhN8A8MU+D9shsImq+YMF9HOclr
	HYTGNobXdFY+Cap8AubHEYpu7BFuv3M=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82c63f85c84so1087297b3a.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568224; x=1775173024; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SLjwHN4/NEPHQ5GPdLGfuv8Jy0iItB0IfnGqB+YcFdI=;
        b=VZIR4es0aw7ZGp3S0kF0uDyuflSYywiQsh2XiAzuE/rdbrjC1zeIr/y/u7REKNA2Qj
         9bUk646YkAMKkVH2xXJ5dOV440VTHOctYT2+6d1U0AYzF3vpP63+mT7YmIpCPIKmedMk
         Yhnero2ccN0eUGGD6KI3KytOaU1ioHoKSTjTkr21yum8Tc5Duk3IJXem7ViLumXX+JnU
         hTEs2/ldr1ISbn3md+rcDtitQbRGJ+qbTayHGzaiyaO8BQDoj576NIBFQBjd++DRrucK
         QIwY/S1AZ7EqC4la7qOwBLE74ETTDa3CFvyBFHl9usVbloEpG1E6xGkpaq59DYunx+vn
         +7bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568224; x=1775173024;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SLjwHN4/NEPHQ5GPdLGfuv8Jy0iItB0IfnGqB+YcFdI=;
        b=OyPSBXSWuKKV3BxbHauFHQd05e8G8kjMPgK77MMW3WbeYdOwpN2XbjmQOIs9s7nO4p
         rjfh3CLhZI5w9fzYbPVAG02s4cUT+O4iObfWTFdsebDmpfnHzFS5GDdrJE4oF2v048ux
         L9FaYq2wcHmWmi9x+em8/l8y6povtN+NAsQ+Db4z/z07l3LMMcuhTTMyaWXQMhjzfoA5
         G8bZJgPzi9sShoNJxR79xvh+Vedp6dxM/zcyW9o6ASTM8ks4JUmblGq+3HgljVQt3mI/
         0xR4e1jB3zmq1Zy9IJME8HJCx4w4o5leZ4iWPcsRkGN7Qg0S/UangVhzFZn3Id6q/NL1
         xhmw==
X-Forwarded-Encrypted: i=1; AJvYcCX/n3OqZf98QD+yYxiuESEQPylrHFKCynDAOr0REHJYnsd8OGOcZSUEXuchX+1A+d5Y5G8OyGZX0Q==@kvack.org
X-Gm-Message-State: AOJu0Yxt/Dli98FTzSHlxye9FqTbnzV4F0cCtQ7xXUSIC+qjbhd4FV2S
	P5Yab/zVi3RbS4C164SMvyyU+nlNa1cUbb/WTLy8Z2j+Vbqdtvzbe9fuLOVFViQR/1+mtc1F6AY
	0TYjV5N55MLiDrDjceFIyscVmMQ==
X-Received: from pfblm12.prod.google.com ([2002:a05:6a00:3c8c:b0:829:7245:b797])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:aa04:b0:824:a8f2:7de7 with SMTP id d2e1a72fcca58-82c960a6bcdmr260470b3a.60.1774568224072;
 Thu, 26 Mar 2026 16:37:04 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:36:41 -0700
In-Reply-To: <cover.1774568083.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com> <cover.1774568083.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <fd0d2a694fb71dbcb69a9af7f92474e1896b3f48.1774568083.git.ackerleytng@google.com>
Subject: [POC PATCH 3/6] KVM: selftests: Make guest_code_xsave more friendly
From: Ackerley Tng <ackerleytng@google.com>
To: ackerleytng@google.com
Cc: aik@amd.com, akpm@linux-foundation.org, andrew.jones@linux.dev, 
	aneesh.kumar@kernel.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, chrisl@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, forkloop@google.com, 
	hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, jmattson@google.com, 
	jroedel@suse.de, jthoughton@google.com, kasong@tencent.com, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, rostedt@goodmis.org, 
	seanjc@google.com, shikemeng@huaweicloud.com, shivankg@amd.com, 
	shuah@kernel.org, skhan@linuxfoundation.org, steven.price@arm.com, 
	suzuki.poulose@arm.com, tabba@google.com, tglx@kernel.org, 
	vannapurve@google.com, vbabka@kernel.org, weixugc@google.com, 
	willy@infradead.org, wyihan@google.com, x86@kernel.org, yan.y.zhao@intel.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 99338A0005
X-Stat-Signature: tb3s8nifnxb7gf7ddsman6rinaqx9wfh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774568225-422053
X-HE-Meta: U2FsdGVkX1/9tGVUE1FL6KQEXprDd0W3VkgBdpanyU/hJFf5vhwjo5syXosOIMvebqzPiqPQLmYr7SVg1fvRgWj+CVUbR6S8lGNwM79t0gaVTltMl82Wj6Tg+mu2x+QXXyutLbtwoKRMOF4+uDuhO/78aTm9/gvUdQ3NZdeIqAjOP6MfOh4EFtObPRveoRtBrPasPJLN1my1j5Ur4U/1HEUV4jTI8yFw0wqFXWFqoLVxHP57iXfSh7BQB4UtrJ/KFQ836/USDftGekiRqJFPtaO/obC3GKpjKVQtevGYd+H/XlWAhNlKaN/EXeZnvtBTRrg28u4axTuVWdnxwzzry9tN7aw1eN4r3lNaYhU769JTpr8YF8QeOP9Vs8Ite8HZWR4bXzZ44iFCrt5WXWxSGSsqjyrcETj4rU8WJDB2zbPd/Jsx9Gatsp21WWRZywkuBcyUuEZH9bq/5W03JC+N88Hoy8qysbJGNLyxYANtZcpT1sxTt65zhA5/OyCchARspx2cHLnOYjFHzYSQw3L504bz8O+f7EH3lZi6Y0pKAB0beD9JdqNy/bW0Z8KR2jfemGwTpGyU/BwEeUpV53/IugF4jbgX0XhJ5G088hG2/f1ITCCyF1Feis80L4bARhjtUlZ/zbJYPNVe5o2WFlIJzk6GxgWBaJrQEbGpiwU2+RnrWeAocIidZxBh7GcY7R8VWT0LAQ0+cQ6GTs+O5TyW8YYdtKbDZTz6PyDKwEwWgzvdMOkkZLADn1XRG0G3HWVFMPzy9/otI5ZffuppRibA5dsX0HWmgSqt7wP4YEdiXzdWz+8q5htNgPwif2KZWQ8SG/q7QqAbyZBRDyPXmIGSPMEQ69TGAiVYhD7pYQUnZpuMF+vhHeu7ywg73m6zM8hVhUc5RV/EVlXs4mtSTtgzmpND4xQ8aU9RLs0EIYIjsBXB/EiIHN1BSy42C4/Nt2w9F5JG/tvfPswaVs6Zz+h
 Xwlaw6f/
 FYkeFh/NUTzRGN70ITPTFsRgEAz1d0ZYoO/dIXZb4seMxAMGQvQPpPAXNzjVAiZKaSI0CXEz2yEo8eg0XGi5bFaVYfa6v4JnGLfrSDeQ3/ulKbQ90P/WmEmRpHKFkwvY51vQQI6Ig5jNdnu+hy18GTttX+28Hfeo51PlU3vdg1CsmpoqxBzcoCJ/N1RG/y7UrOzun9ULMKhCqDxG/eVv8ZxNUeaFTTW6kR4+Hl5j8pgBOrLPtew28WuRjk8aW7tpb5gpDoLXs4kwq8Y9tsdebC5PKhG0awbhQaOFt7RCIGGCoChxuCrugIEGL4Vv/Br0Gakj4mYlytTxbRRwJ3IFyeMa4lTdymRUNLJgbfGbVgb+YBd/Gkf3A9sFJAymKj/c+LqKf02aC2BYJAv2kQa7vI5MQgABii13x11Gyiw1GegvfQEV9a7SOJ2yF9rRzhHqezr8AS17wMP3fH9SOMxB02uVIWJCpalJfe1krlOf+/ONSCztOicBIzKN+4OyuLJqodUe0bj9EUvJborc/HtmwmPX10/tRBu1kXp+o4RBh13lO4/GVth7wMs0tVkMF4sGCFKaSVE7wwaezBw72GU78aXvWZz9TCbCEgXZQ0SDqyVBh/xI7e2gUXAPaxqj9r0hwIgSEd7ukzw18mq3+qfmdICI0+DYM5kLrJNYC9IkkriU1PBhKLlkJp/EK3+OwirvQg2V4Ia0opMiy/0XV8e2mFwel3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The original implementation of guest_code_xsave makes a jmp to
guest_sev_es_code in inline assembly. When code that uses guest_sev_es_code
is removed, guest_sev_es_code will be optimized out, leading to a linking
error since guest_code_xsave still tries to jmp to guest_sev_es_code.

Rewrite guest_code_xsave() to instead make a call, in C, to
guest_sev_es_code(), so that usage of guest_sev_es_code() is made known to
the compiler.

This rewriting also gives a name to the xsave inline assembly, improving
readability.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/sev_smoke_test.c        | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/sev_smoke_test.c b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
index 8bd37a476f159..7e69da01cecf4 100644
--- a/tools/testing/selftests/kvm/x86/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86/sev_smoke_test.c
@@ -80,13 +80,23 @@ static void guest_sev_code(void)
 	GUEST_DONE();
 }
 
-/* Stash state passed via VMSA before any compiled code runs.  */
-extern void guest_code_xsave(void);
-asm("guest_code_xsave:\n"
-    "mov $" __stringify(XFEATURE_MASK_X87_AVX) ", %eax\n"
-    "xor %edx, %edx\n"
-    "xsave (%rdi)\n"
-    "jmp guest_sev_es_code");
+static void xsave_all_registers(void *addr)
+{
+	__asm__ __volatile__(
+		"mov $" __stringify(XFEATURE_MASK_X87_AVX) ", %eax\n"
+		"xor %edx, %edx\n"
+		"xsave (%0)"
+		:
+		: "r"(addr)
+		: "eax", "edx", "memory"
+	 );
+}
+
+static void guest_code_xsave(void *vmsa_gva)
+{
+	xsave_all_registers(vmsa_gva);
+	guest_sev_es_code();
+}
 
 static void compare_xsave(u8 *from_host, u8 *from_guest)
 {
-- 
2.53.0.1018.g2bb0e51243-goog


