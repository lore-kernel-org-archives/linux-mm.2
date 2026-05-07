Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F949CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D3B6B00E4; Thu,  7 May 2026 16:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0456B00E6; Thu,  7 May 2026 16:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFB66B00E7; Thu,  7 May 2026 16:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0F6F6B00E4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:34:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A87E88C155
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:40 +0000 (UTC)
X-FDA: 84741777120.25.B2A1D26
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id C12CE1A000C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:34:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="TKcf7ij/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Xff8aQsKCJY02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Xff8aQsKCJY02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778186078; a=rsa-sha256;
	cv=none;
	b=T7iuCnZcIuhRy4E58p9dSo+vw6Q5Eg1/VpMtuDoHJazdhzL46c72ijaD/S/S8GzAHh60vo
	YPZKYwNNSSt6heRnI25CmX7DEsvUgm7P81dt0M+kjklyBDC0FDR7+OCNYVSbH2W75KdY/w
	iVDDjiYktvxzXe44xabLfD2e25JGZW4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="TKcf7ij/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3Xff8aQsKCJY02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Xff8aQsKCJY02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778186078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwdqijLGyLJ4WnaXvFgo9eGiQSeu4QsrqPYNc8/yMrg=;
	b=cCF8OjK3qNKEsYnb7WU0dGhV2FsVJ2O+OOI53rbGsvTzJ7mIPd9BHgc+3F/UH0ETeyzcg6
	pR3CBSS/xWpmIVRW92nHKUVQXeoxHff7XhRHA/0KZ/DaeROhXMDnuAVRGmAh2KLLs7/Mzc
	Qg/RxHk36MpaJYeO/dXxPTHR1a8qAvY=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c82353e8c63so684441a12.3
        for <linux-mm@kvack.org>; Thu, 07 May 2026 13:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778186078; x=1778790878; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FwdqijLGyLJ4WnaXvFgo9eGiQSeu4QsrqPYNc8/yMrg=;
        b=TKcf7ij/9x8Ycdu92jCxT/0EhXOrdoAGPmpSMFKmCM9rmRr898XnenjwLLyvEQrDP7
         3mca5WrIWby/5BncBcQrGuh/X1LjwqB8ST3BWRFzWls+YCk29fibIfq1ctfiuLF66Wb+
         q11BiUDiaQRVeikiSmKUwqVJT0l9yi1rDXklwu+IOKeNLwW0Z+MVTW2INUypE4CWOTmp
         IEysK+gHN7uYmKueV4fSUaLiOy/0wftXCIh5lX82HmLKi6xMhr3jPld69mEUEk37x5Q3
         n29iwBz3VzX3zoMgV1Bh6UvAFJt/DUsYTIyiAggKfxUfX/89qIIWnlKDHKrE4Cflj5cd
         BCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778186078; x=1778790878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FwdqijLGyLJ4WnaXvFgo9eGiQSeu4QsrqPYNc8/yMrg=;
        b=fN5u6sQMHVglvj1zbhaSkRhKQpFWU98bE4N6lTRgel2NrNXtPGvxrTkmGYLU2vDHDL
         eT8E6iWSg+bVCLIyUlUWKgSBMxUlpR5+L10fKQan61wYaC3OacrhiVrXeI7T+3wxF1Ng
         pJrgaSbqHY6TuhfHfbrTDv4mzc+c39aFK3zbEH1vCUTgIrsikhqk75rdg6Oujyg5JaxA
         OR8QQYeL3UVILbb2/A6rnp151+9Ab1pqfL4FZWoBQdfNazw3rcfCyLkCJiCe246KbPmi
         Z0feUbBLGyofBRgr7hFK6KeP19F8yvVGMwXeC9JjEAXrj+lT14AGXkOi57MF96b8iVUh
         O9+g==
X-Forwarded-Encrypted: i=1; AFNElJ/ZkYekNYXlnXYUDG22s606cLpUh110th7hsOlMF7LJ9KEhObOfJAyJmFvAEE8k946CKXbni7yWTA==@kvack.org
X-Gm-Message-State: AOJu0YzzVO0lRVmKnwlq/5PFWEPT2e+pQ/Qzqr0AbBd1xPXv5l0gspUl
	thQ2e4bTKTmkOKVvdSzF8dGLcHoFDsal9ukXy3k89opdxbLDAbONFE7tBtdOJ5mI/i2XRh4k2i9
	oGZB+5G6T2GG9iqehKZe4Yl903A==
X-Received: from pgac15.prod.google.com ([2002:a05:6a02:294f:b0:c79:5ec2:4a68])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:431e:b0:39f:54fb:e465 with SMTP id adf61e73a8af0-3aa5acd7603mr9313570637.50.1778186077180;
 Thu, 07 May 2026 13:34:37 -0700 (PDT)
Date: Thu,  7 May 2026 13:34:24 -0700
In-Reply-To: <cover.1778185936.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <cover.1778185936.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <b9de3cc382f0cda398ee928467147979adf9b06c.1778185936.git.ackerleytng@google.com>
Subject: [POC PATCH 3/5] KVM: selftests: Make guest_code_xsave more friendly
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, aik@amd.com, akpm@linux-foundation.org, 
	andrew.jones@linux.dev, aneesh.kumar@kernel.org, axelrasmussen@google.com, 
	baohua@kernel.org, bhe@redhat.com, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, chrisl@kernel.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	forkloop@google.com, hpa@zytor.com, ira.weiny@intel.com, jgg@ziepe.ca, 
	jmattson@google.com, jthoughton@google.com, kas@kernel.org, 
	kasong@tencent.com, kvm@vger.kernel.org, liam@infradead.org, 
	linux-coco@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, michael.roth@amd.com, 
	mingo@redhat.com, nphamcs@gmail.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, pratyush@kernel.org, qi.zheng@linux.dev, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, shivankg@amd.com, shuah@kernel.org, 
	skhan@linuxfoundation.org, steven.price@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vannapurve@google.com, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, wyihan@google.com, x86@kernel.org, 
	yan.y.zhao@intel.com, youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: kxgz4t57ouqiipokrefh36x3mcu7args
X-Rspam-User: 
X-Rspamd-Queue-Id: C12CE1A000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1778186078-654573
X-HE-Meta: U2FsdGVkX19UXhURWWRSanZ+Fhnhh3yTfBo5m52BKdHQYXf7AlNnDAwrhQ0jIcgwPN5PvvwCFn2AK2cvZZKQbDesCP6Y3nzNKJwmPzBXe7rL/H6THnYHOdbeDKjvlfogogTRVQL76xwPszb7B5DeTUMleP21w1+SoqT+8PPpNA216hLzjZYZGLMT3HTOruKqbbyhcYmicOgtmjTbRkUyHKApwaFZPyA3VDK/QxRbVl3PzVUro6WfdkE82Ooe57BXyHauB3yMaWYKifAetgpsPZ/eFj1CNaAYjT9PJxXFnorGMA50QXj5Ht79LqBwNt6+mxODYL0QfSfJJ3/EdK196oSCg+VjnMGRLvS88qVjGWD6fYwyUpEOHJStFQEjOpX9CpqtKdOQB3+LAaCJK8DTFoM/VD8XKv0HsrgZLXQxas6CUSiAcfP+jPQXMu0Hdev2AHUho3hc9b5j7awPqkjn3HD8cOYkjl9o+kd3Wn4hz8ZOmOGkLGLYKdp4G7XV76qXaWCBI29mujB7cyGyPmIKCpA+DSJMJZRBH0+aVBDddfKzcWG/noHL13LudlqwF+6DnlCNQMtloKntGwfuME2xMW5bZLqTFCFERblaTyct8F+NOYpSFOJHdnoDDDrvOsk5DrrqboPpGYgeO2KNdeqt6a7Nj3zwdfp8ABxD7gXdyaOraH2w86FKXYNt3jKpQsOU2Wv3vYLAZUy+xm42TQluPsILeQ3LwJPOrbgis7KOfDeVD+n/P1NWmVoaHzjbT/P+HbqpUSZMK0fvWYtSion3XK7ZxUoLs76ITMn7E6JBKRHzw2rDi7qew3TcRgVZ+ztVDXOYIoNQfhyPfzZQvk//CGdW4ZVcOhzNkl+a42Caf279MkSGgt3378VHwEtjYeE7OIrxO60dV4jFur5YdAP1NwCyRACHNZAAp0/olTIDU0xVjj+LD3wgbm5KUo70i9ldx5sZWtPFhkfxsAxYIIv
 nGp/UtTa
 /yYoapsM/07i1lPFZ1+UoQueDREUfU+mSHE3rQtRA/X1Mh3BPt2GVT4bbVJEJJ58IZRqa64HuvXzg9flNMzp16jEJbm6FX2ZfUO4hck9T0K+vsxhY8VaiCjZJExHliseRyxJh/WV5VBPVo5YkbGy36prPMsYCw3n1GdqtsIJQv7PrFiejXi1ZK/VR7xvopWGpcs7bR+Jr/KUw59N5OJN0DKKtlSqR0K+pjdBszKHAC3CAH+6z5WUI4LsFGVSfGcyrTdBHZs+xROzPYyYEVWSKlWLBgeOtKLcRmIAkktTqUqfCfxSwWyji1OAaygYd3AS/e13DBkoUjYdMdDXMQz8OQfnB6vfRcDAlflgQazfWxlIEr4BzvJZInAngERMn2fKzK25Y0eFQHDiAvkF+M6VaTZDNy0FeSYY07+ybYaGr0yDnkOxET/vhCDHiTWagtLy8ag3cGmSW75Bps0DvxT4iFe8xhm+J1a90gXdTuAQTuME2aKkEI++pyMtu5RQ04kraAzqoWOLWtT96t+98Pii1E/mVWgeAa0tWDEsjth7IXYnGLoa7s/aNSJLfl8rRqbsQZaNPFUHxKOHosREqzZJeTeU1jFaJr/Q+y8Qc1zqFGxeeeYQcc+jdXfOKTrBq6Ycr5cSU6e2lbXGPwS/fr9ltr8EgfK3hvkUQ/XRHNOT6+aG6KuC+dGRWnIv9AwwXAPOg75JZvS9J42KZz+gjGAZVRjDQm5Jizso7HKcDUJA5oEGiC9h3aGjo+Odh4uv/ZioHGwFlAk2Hc17fa1rICcrLkQ3Ro+Kd86tobnF03OevQqHu36PRz7SuX+xnSA==
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
2.54.0.563.g4f69b47b94-goog


