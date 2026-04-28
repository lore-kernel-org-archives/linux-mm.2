Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38311FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54FE6B008A; Tue, 28 Apr 2026 19:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05F56B00C2; Tue, 28 Apr 2026 19:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5046B00C3; Tue, 28 Apr 2026 19:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDB06B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:39:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 158D3121148
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:36 +0000 (UTC)
X-FDA: 84709568832.06.50BD33D
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id 17DFDA000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:33:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h6Fad7fg;
	spf=pass (imf25.hostedemail.com: domain of 3zEPxaQsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zEPxaQsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777419214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEO36girPr+drwE77RQ8xryHhyT8L0VbpSDbMsS1X7s=;
	b=joAKoRSHlW1v6lRVy8N9PHl/zFX7HuBYwh9m/mi7UVRFBKC0w3rvemJ7kYrJuUSPIaBRSO
	yEdWhnDjOQOpwSvRS13/ES6Ajjrmgm/MCz5An1H4hgSQTdVu6q7SQZ7+BUzaxLTfqnQThv
	fb/Efmx5tYrEbPGiEr+4mMFdMTe6wtw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h6Fad7fg;
	spf=pass (imf25.hostedemail.com: domain of 3zEPxaQsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3zEPxaQsKCG8NPXReYRlgaTTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777419214; a=rsa-sha256;
	cv=none;
	b=lbaHXQbzrEI5awt39aRKOaVc0dXxbBV2882i+5z1EgZp/I9rO3QhWEWWKEk6pn/F2Q6LPh
	pzIZ3EtMfcoOtTdmdOBTLi9gGFUQ/PlNVEL4qQLe0hIELm8QvUvKqcjL2kRQ78FNkJsDiQ
	50P1JaPkdF/SfMundT1TP5cuNF3ZiBE=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82fbceb0181so7064504b3a.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777419213; x=1778024013; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MEO36girPr+drwE77RQ8xryHhyT8L0VbpSDbMsS1X7s=;
        b=h6Fad7fg8H0Roy+9fP6rwatxfPhU6dzagVytFuvGnAQrTaxqXKS4gYLNVWrks5fUUR
         KDS8/quGEMdLJafShkoamNKOfWW3dc0NJAAGcBlReyjX1LXcjZBcqOdGWTPiOZ4npnv2
         jcLzInrBDCfvJUKFbLnsE4xpDjBCVUJYEjQP45M3BFqzseE40Uws6f7QO3HQr8irKxcw
         8VcNPKo0m9k21HSgLMeqMexb7FMSSGSQoMGPxI5dwTccC4d6OWZ5+ppK/56f8TjoR1h+
         QI8ugZANiNE7bAFD24nG4jDRFTC7E0Octs1APg6ycVhopYSqJ7njYsSg0z2jPl5OJPNu
         KkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777419213; x=1778024013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEO36girPr+drwE77RQ8xryHhyT8L0VbpSDbMsS1X7s=;
        b=W5Mjf72PFQECsH7w/eLT1Amy2xhNmbRcEVmZnn1epctBn4RnWXwWmdaeJJHrWW+8cR
         rea2f7sY7x43D5QNoXqEwUZud54OSz4WON9dQfH+fopp0vVYGV/eJvZCSahDNBPZXIJw
         lsOs7IFa3O/LiGlAHMr+I9M68c5tAU5ZafqQBabtRFTgO9Loqbaxze3Y/zsSQDbL9S2+
         cXlGukVmiEFN4qNeTzsiP3N+ecpwVsWAjm8TBoh5WEhRTH2/aj4PWzG+3Mub44hZwCEd
         vIQbHlDs85zbAGNwCN2lZb96FPv63eJITBI2U2NTxV9H5hQb3T+bwfOV2Em4b1NdBVZs
         Yi7w==
X-Forwarded-Encrypted: i=1; AFNElJ/vuHEubP1/IxI6f0LIdOUOuwEhwfcZTjinoRAzR6c1ETJXT2ZJTv/jmAmdTas2GEt7vZ5KyVyRMg==@kvack.org
X-Gm-Message-State: AOJu0YxmUzvyl1VsgmcrUqU//nIMPsXiiIPQXMDprRsfhnrXpAYAATw2
	nipw4t1I6lqGq2Vzu8mPwHaEvhDXKfbi32W42SbkQ8jZHGH+EIeAx1ow5mtwFGvlETK6GwlDbcH
	mpgjXdJI1kEG2QcZukJVUvPOQbQ==
X-Received: from pfoo12.prod.google.com ([2002:a05:6a00:1a0c:b0:82f:bc93:4ae2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1993:b0:82f:120:fd6f with SMTP id d2e1a72fcca58-834dd919817mr4905304b3a.0.1777419212551;
 Tue, 28 Apr 2026 16:33:32 -0700 (PDT)
Date: Tue, 28 Apr 2026 16:33:23 -0700
In-Reply-To: <cover.1777418884.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com> <cover.1777418884.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <8c0dc96e0776bdcffc4d2e1a9d7336f106289a48.1777418884.git.ackerleytng@google.com>
Subject: [POC PATCH 3/6] KVM: selftests: Make guest_code_xsave more friendly
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17DFDA000A
X-Stat-Signature: b4xyhpszyz8ksfq94wp17g479ybn9sz7
X-HE-Tag: 1777419213-455403
X-HE-Meta: U2FsdGVkX1+4oKIjU5LhwBc5PhEOhUZ4vxBgYwhCSwrtPZBUBVL6g79z2zuM9fDozubg9zKfewvTfibqnP25PvDNaGRGWOJkWkTMNY4vvzPOLataVrSmkhAFRMhD03VOVRU99M8P5Dk4LxQDMUUt82SpnAG+yBNNcNjZmgM5H/J1fmA0ZpZ8amDOFshj55lO2KlIe1LJjSzdJn4q9Zf8Bfdmu28W+xOvnwk/RXGCtQc5rQuH4rzCpKVbF2sI/eq7dBvPktTnQQWIDvGKproZ3NS/Je2edugGqXicu1opb84T3P5Si3TckOr+J/sqC+rA2kWo6ucz1XjZmyzKHCnHFswWpar/y7/CPHNybR9gKiyDVAUaKn3Hj1XtdPwo7UgbHBvtI28fMSTo/YCn2pKSoG/Z+FGnvAnqvDBoo6KRVl9JvtYxWbcmpSIqKQHnid/+spAuCIM7qS1+0YDngkFVFKxnwTPtiOyIKSJ4iLwN/huLgaHAkFKnXjQjHgQTvN2gdPYCQOk4W5M17UObIfyWpkqdsKy1u6M2jgHMQolsvamJsQElEyi5seRayCwMV/jU7bK7c2XGh/JkAeSFIEs7VY7X6iO6VIlrLPMaaWp0hrOq4DL7kXxcM9EK95FJKAF7MZo2oj49STEsPRkrW/IsO9rP0s74C65COm0Uj8xT1NSwaacQmZEZtfZv5zBb0hbLz+eIUziU/w2oHeN6g0RH38UZLBGCpdkqwmlnURx58K30quZyWWKB0mSDydAVYkSc2ylnBNsICqg6ekmN9rFZgL+mAVvp7RdlHZnDRevC2O++0e1xN6y9FOVpagn1cpr2svv3agGds+Sgta7l2jzYVd60yVMyw74OmroMGZA/fDquE/01dTzG6kmlIZ/9aLjHC5P0M5lSO2m21xTPBqvoWLj/Mr1dbYhlpQ90nbhK8ywQ5lSDyCJNaZB9hy8tfbNzgGrWYCL0r1mRUiXagtv
 ednGHbtD
 7b2Fn6iCHHeXmnSGLOh58Pfx/GZ/Da0ivhdlcLVIWSYYuOSmEuoV8jNxPfISygzCXITyQhZ8OBlBX/kEb/Qvq7+0VLOA0sU7eSkqs5MWTnUihQtmIOrP5LQSKKD3q2NzrIjk17DAkDoa7ZB3elFMRiQAwm95vgWSU837tynSmWlhIWF/2tuUh/4jSGEHP9vWowIRtajg9NWLkoI8woAOhIJas/y6Fv9NhtUlVlCiiXWjSjaydjC8ZPLc3U3q8FUf+1cSUw9pVhbmGz/VmMzS4KBdWseLkkYP7fQ7wmLT9IFcY+XdfYqtyu0NAhZzL6V9kmhWGVRQe7vEafcnp7CgKPIHDNhrgjC0FWRMBOXgWUJbPPMP9kmGCpK7A277l18OhN1YlbfnJFwHz0CKJQMiuo567irYKJU+qPDO/2hZlm+tg0uB2WK7OSnkE9NKNS2UXUT9TVOPaeU/boEtllBUc9aJFPCo/mP3yW24D08IzjOcc1uYHXmpB3xlBwws0Aw1jpZzOdy5c/1xVK/Oll7U3fD4kxritoE+sBIowaDKaee3yWgE2QPmlNuaqcLsb6YeE1YuYJ2BkWRdGytyv6wOza+6jsbvjvlR97h3H7JH/2wWMHBZmZQfMQLc0GyOa3hQx0nWGd6vXqBrxhbjKu2G5ZcYO3EdEDDPTdxXA7WZFz7Ng4PP+p78CCeumr8BGEt6K6VQ3/ipp20eYuseAuSirYch1ZOCgJ8etwg3MPG2jD0qc5JEz08jm/MjZDTAxumKI+uHbmTGwmzXAgpw/7rLJAKIbySnPI80hUsFrqSSp090WGDKb2oHpvWagQA==
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
index 1a49ee3915864..8b859adf4cf6f 100644
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
2.54.0.545.g6539524ca2-goog


