Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9E3606B273
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=mo35XewO
Received: by kanga.kvack.org (Postfix)
	id CF8776B05C4; Tue,  3 Nov 2026 10:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1D56B05C5; Tue,  3 Nov 2026 10:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE80D6B05C6; Tue,  3 Nov 2026 10:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7723B6B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:22 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D61BD1A040D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:21 +0000 (UTC)
X-FDA: 85394164002.03.E02AAEE
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9E5C180004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=mo35XewO;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR930nY0OLfAMXoZyFzjwPE74WxrEfgyHo+tDAm4b7A=;
	b=wAI//A3HpZSljZz/pN+2vcLJ7enoH6D+BkbM7wdpSnRnGieRvyL96tkNrXN+q22viIYRAO
	m+IUPwp8IYTEh958W6B3Rb3UYu89QzfuG72lh9hVuTX15i2dUQL3V8oMI3veNMAM4G8bRJ
	3d0HaQjuj4GvDN/duB+R+MJuPw4GvOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719099;
	b=sEC5adGDSTZRKeHFxPobz2/w0Da8ZnbKmWtdn7a3Xlfyp8OVzb+pb+nDiEnoRGy/KA27qY
	0w5odkAL9Oq9doLTGIdyIghWF5lDLHV8ih2Uko+8RGvkCKK14XUkuNcAOdzZvJTg4HJXvx
	uw2sMAs9+Vvbyqx6R3oyD3+TNljGMis=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=mo35XewO;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.48 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1aefd1bf74aso832442c88.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719099; x=1794323899; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sR930nY0OLfAMXoZyFzjwPE74WxrEfgyHo+tDAm4b7A=;
        b=mo35XewO00JVAZiqAmMtiAnR/oBcqCrPhmqbfYlcuSQgiIz9cOklZHteCfU12aDKYQ
         MSZo6z5UYHQ2eZ9dG/o6j3Xv2kjDccoeDOu9Yf71JTfWg+UK8oEolWu5yvoC0Sntbcoe
         s7MH0fwVWgGP0J1JXQzafy0QH5ZvsmZhe2kto=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719099; x=1794323899;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sR930nY0OLfAMXoZyFzjwPE74WxrEfgyHo+tDAm4b7A=;
        b=TbGwuyhs7vbzFEZKvaKGEdCwNNkipizN92T70iK2nSvEY4fYxEGN9ArBAOE9FQQACJ
         R5/Urybin9q0SAPClOrsO0t+T20Nyr5XBDjYUN/LFpcTcyzC9LtaBkiPk11dYI7Dyd4V
         pdWzC3FZrfCBvkTFQiEAWYG5CIf1RlOj0HTSDC8ZtadvkF577t7lcm2mg/b38QPio/kd
         oReL30XD4znEhhn7QcV4VkF5EU1wBihFMHMzSIjxB9mx/HGT6kqmjILoVl5PbAzCFGkI
         9HhawIktzToFO87QVemWj/q2Tf7Kq8b1Z8bWeL4VKBuG5Qf0dIL2wpNXYkepna09myvL
         pqJg==
X-Forwarded-Encrypted: i=1; AKwUvBz/n0LqvAGQAC9OVUkLV42ye7dxmef8Jwgs2ClWD/+lVut7U4X07rukW3jayClEpKLBnVGyS/1pxA==@kvack.org
X-Gm-Message-State: APuU4Z+R4n+MMW5T3IxGW4V/Cg1g0vWghqJ1sKjh4DYW60g8ac79q+lV
	i+5zjfcZrsCddjYetbebW/fcXsuJuje9VygDMZWzZHDeXVIXMFPAN6+IVD5chHzwLYo=
X-Gm-Gg: AYBFou2R7h2xJCTtYWTB2MCUiuF043m8wyh1u1opNXYV8Ar/D3QArNqRmb2UGYHX22o
	sxgvT9PA4MkMNdEeq3zith09dX83rMiXVgzATUpf4/E1Jp2SwjY+b4k7EYHFstoXYY7cNuR8uZ/
	yvNEa8JbagtiFXOay4QelarF8oyWolxt4GlENce60JibDd2p2uigDwixTUTraLyzKiA7M1Fn1+P
	WKwH1zbzaFrGjsYq9KS96WWudFQgl9uLnvOKFhabhMm1tYhY4qhtWoiq5oo2/WqdXpjP7N3Jtto
	U1w5FNPR1eranxWScxWZZuci6rruhy2YJ8bCfrvW7wL1gqWkr3WMfJ3AiIZfnIefs008JPFGLc2
	jCP4vKHUiFRKqlnDJQKk1kXBA30bZ0SqDJpXn9HhSPFVE7ZAMR/wsxl88p0BkVROfh8IjblmsTk
	QJhDv1a2JMbLZstQxGqrqMOkGfMltiJWrFBKQWrp2DwospH2qMI4cn/qhu6D/fvOobZ5qfuOsSw
	EgPlFZ1X47dg78ObQExJTSVxoLwgzr6hqTqWwZ4pdKdCkltb/5wmTtYS5QNp0qekq0QcWv3ErWE
	O+FKkMxz1A9T54SaQUaIFoZO7KSv8MaKsGAg18gqViZMiTaDljvxQbBz4UBC47U/Gbna3lT+y4m
	0nv/pFfZ4QQgtdCc98ncKv+K7FgFvFhzprWKfERXq4GTRZxvfIH2ZTsPx1t87wwjCYAPWj3ySZE
	PFwnwOLsDE+vo70dXpPg==
X-Received: by 2002:a05:7022:b903:b0:17a:a3d4:8b17 with SMTP id a92af1059eb24-1ac5ac4f0aemr16822717c88.12.1793719098430;
        Tue, 03 Nov 2026 07:18:18 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac19c6b969sm42657488c88.14.2026.11.03.07.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:18:17 -0800 (PST)
Date: Tue, 3 Nov 2026 23:18:15 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>, David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Shuah Khan <shuah@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 3/8] selftests/mm: Test that the seal on system mappings
 is enforced
Message-ID: <cff8df45bfedfe7dbd3aca9416923c27be2a4a3e.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam06
X-Stat-Signature: 4e37id4dpx71jw5k5dr8zf16qxibt8yn
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: E9E5C180004
X-Rspam-User: 
X-HE-Tag: 1793719099-875723
X-HE-Meta: U2FsdGVkX19MJ3PGNdZ8vadbyG2fhSSaC22GuVC4QYkJ67yKIQjVJ+jddM8GNRsI3X6/Gy0gmWNlWyw9uTRfUJcne9s8+dfEtIKfX/9syw8ufEsOt9Dw0fuXKrrjSkh4uQSMRM4xNyiHWRlANtmPOwdhUle8fwo2ApbCwyzq78kw1z3rz+Vl8tVJ3Dr5UCTpDMSC9Be631fSM8XQFzGvUaBmOwpqEIJeyKZpV2YHC2yhwab3hwoTuCmzwfBPZzZhnUB8sX/xwjXDsRYsEaFwileee0Dz+aqB0CE4afHzOVXmrbeHLVjWsmHmueHyrdiF680y22dEXGfMq7+bGYWJV/DdIqATWoIwwNyH1/70ZQRfhe+aS8l4yw78FYTu8trPn438aHjvI6yIWh3utJ2rz75ACkfrZHHcvhZmCNHRFWEQuXLTL1qmuYC+ERL0ukvKV9ijhCXScWPDlirvMT84PCHlPd/fZ6dArMAEqbtR5jHsZM7tBBYzCE3aOownaYfdTp6ODoNNJbMeky3MWnnhUlVMWoFLUZd11AECyJdaXktunt6xHsSG6oTw7cb9mC3V4I2tN5XHBHw3c6LljTJE4oqcaXV5OoHae1xeyZF+E32zumQruA8TxPsPoddAtExfe3M/8yufRADozYxYkpmaYaMWfpLH2bVsW7odyKOwvclaDa3GRz0AVhUf9BBjeEFzI/2/Mlc1s1iayf9gjzd6wlnYjv8/FF4lhQnZ0cioxF5E+1mX5g95NGS3ZIMNm8J8a4/9upUv7EX0+zK1lJz+rGHtRdlLWhrOLjaXT2Z+ihzkpQM3UgyTl25nOPIBYVXvJSCVEZAZ9r7xGGjqOVEiYDzvRTHttfzgrLfOjwE7x1H3ntk8aoC0IDfgiXoLUdUeFHrAX4+DLfDsb2+fNbd/ML4v1DddtTYnXV6qPpFztmJmWbSmCVS6z5vYGIHU+vHrj1om3sgG6tvwZF/g98Z
 cz7nR36f
 z2vb4xZnt7V1kg6BQ3Bpp4XTi1eAVg9a22UnTplUYNw26NhOD6eZrgVuW0Pv2jLByn8zYe4Rqo4d2aOIAYGvRTlJlsK/pxKdBoAK3gmekSeU+xOPgAyfGin3LYCrxvCFTMaj50ZodBozQa48TzP+lV05cFHmglVbQNWyZLzi2XZRpNZ1yyyTYaH+PTzglqufqFcZDN7qprrxOnihP+a1ebicCuU92tHnSjWpJfMdEslzOt2nNWGDDBMN1WrmzJpY3/xrM3Q/2zsdhx0GidI/TbwIScwQoL+j97EPVd2ntCnDIy+Xa+xgeVDTbaafCDP75UNnpvrT9Z+L+KYc0YzQwgni3v7pcMH/TWY9t5YxPGM9zKekGdSvwkKRFkhHmRxakFosbFstCrmtW1r0yfryaGvJhWvoxFTXu1zgTCYDQ+rHYKpNgTIB1DDrarbOtIWZSJFzYsbDoK2jNJNH1YbbK2DTikw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sysmap_is_sealed checks that system mappings are marked as sealed in
smaps, but not that the seal is actually enforced. The rest of this
series changes how system mappings get sealed, so let's make sure that
is covered first.

Add tests that munmap(), mremap() and mprotect() of [vdso] fail with
EPERM when it's sealed, and succeed when it isn't.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/mm/sysmap_is_sealed.c | 101 ++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/tools/testing/selftests/mm/sysmap_is_sealed.c b/tools/testing/selftests/mm/sysmap_is_sealed.c
index d5ab2b0d8ca7..bfa140e01d8a 100644
--- a/tools/testing/selftests/mm/sysmap_is_sealed.c
+++ b/tools/testing/selftests/mm/sysmap_is_sealed.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <stdbool.h>
 #include <sys/auxv.h>
+#include <sys/mman.h>
 
 #include "kselftest.h"
 #include "kselftest_harness.h"
@@ -138,4 +139,104 @@ TEST_F(basic, check_sealed)
 		mapping_is_sealed(variant->name, self->maps));
 };
 
+static void *find_vdso(struct procmap_fd *procmap, size_t *size)
+{
+	void *vdso = (void *)getauxval(AT_SYSINFO_EHDR);
+
+	if (!vdso || !find_vma_procmap(procmap, vdso))
+		return NULL;
+	*size = procmap->query.vma_end - procmap->query.vma_start;
+	return (void *)(uintptr_t)procmap->query.vma_start;
+}
+
+/*
+ * When [vdso] isn't sealed, these leave libc with a vDSO which it can't use,
+ * which is fine since each test runs in its own child. Skip if AT_SYSINFO
+ * is set, since libc may also use the vDSO for syscalls.
+ */
+TEST(vdso_munmap)
+{
+	struct procmap_fd procmap;
+	bool sealed;
+	size_t size;
+	void *vdso;
+	int ret;
+
+	ASSERT_EQ(0, open_self_procmap(&procmap));
+	vdso = find_vdso(&procmap, &size);
+	if (!vdso)
+		SKIP(return, "could not find the mapping, [vdso]");
+	sealed = check_vmflag_sealed(vdso);
+	if (!sealed && getauxval(AT_SYSINFO))
+		SKIP(return, "libc makes syscalls through the vDSO");
+
+	ret = munmap(vdso, size);
+	if (sealed) {
+		EXPECT_EQ(-1, ret);
+		EXPECT_EQ(EPERM, errno);
+	} else {
+		EXPECT_EQ(0, ret);
+	}
+	EXPECT_EQ(sealed, find_vma_procmap(&procmap, vdso));
+	close_procmap(&procmap);
+}
+
+TEST(vdso_mremap)
+{
+	struct procmap_fd procmap;
+	void *vdso, *dst, *ret;
+	bool sealed;
+	size_t size;
+
+	ASSERT_EQ(0, open_self_procmap(&procmap));
+	vdso = find_vdso(&procmap, &size);
+	if (!vdso)
+		SKIP(return, "could not find the mapping, [vdso]");
+	sealed = check_vmflag_sealed(vdso);
+	if (!sealed && getauxval(AT_SYSINFO))
+		SKIP(return, "libc makes syscalls through the vDSO");
+
+	dst = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(MAP_FAILED, dst);
+
+	ret = mremap(vdso, size, size, MREMAP_MAYMOVE | MREMAP_FIXED, dst);
+	if (sealed) {
+		EXPECT_EQ(MAP_FAILED, ret);
+		EXPECT_EQ(EPERM, errno);
+	} else {
+		EXPECT_EQ(dst, ret);
+	}
+	EXPECT_EQ(sealed, find_vma_procmap(&procmap, vdso));
+	close_procmap(&procmap);
+}
+
+TEST(vdso_mprotect)
+{
+	struct procmap_fd procmap;
+	bool sealed;
+	size_t size;
+	void *vdso;
+	int ret;
+
+	ASSERT_EQ(0, open_self_procmap(&procmap));
+	vdso = find_vdso(&procmap, &size);
+	if (!vdso)
+		SKIP(return, "could not find the mapping, [vdso]");
+	sealed = check_vmflag_sealed(vdso);
+	if (!sealed && getauxval(AT_SYSINFO))
+		SKIP(return, "libc makes syscalls through the vDSO");
+
+	ret = mprotect(vdso, size, PROT_READ | PROT_WRITE);
+	if (sealed) {
+		EXPECT_EQ(-1, ret);
+		EXPECT_EQ(EPERM, errno);
+	} else {
+		EXPECT_EQ(0, ret);
+	}
+	ASSERT_TRUE(find_vma_procmap(&procmap, vdso));
+	EXPECT_EQ(sealed,
+		  !(procmap.query.vma_flags & PROCMAP_QUERY_VMA_WRITABLE));
+	close_procmap(&procmap);
+}
+
 TEST_HARNESS_MAIN
-- 
2.54.0


