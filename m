Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E833F357DB
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C47F6B0098; Wed, 25 Feb 2026 02:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784F56B0099; Wed, 25 Feb 2026 02:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630056B009B; Wed, 25 Feb 2026 02:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 506F86B0098
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:20:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA2728B63E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:55 +0000 (UTC)
X-FDA: 84482132070.09.E33ED2B
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 207E68000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:20:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O+37i4tr;
	spf=pass (imf30.hostedemail.com: domain of 31KKeaQsKCOcJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=31KKeaQsKCOcJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772004054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lmqeDy1YGPO6heAH4dtg7V9yIhQw7gZPhshB9Ud1SBU=;
	b=NFFqgTXwSMvx83Esq+USgspvuntwIwXjTfv5liia/q0MNSPGOTIvyXnDB0+eQQJDzYY4S4
	6AsTVH2Pas183058+Y/R+F9At2Cac+vgVMT4SmxIS3tKuKlXcMhtQ2JN9izSXmqlWNn5jp
	zGl0d52OepGK5oo0rUHa0HwFAy4ujog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772004054; a=rsa-sha256;
	cv=none;
	b=Fg4TeQG1blWHPzdlnOAyWQ4wYu4nnXpL1HuQOHWYrcZABn2nhf9QZ7yrEh1ZJPZYlhXVwt
	CWLytoCufo85EJkcplAhbVrds031jfvt1+PTQuUsc2L2Xx1StoVEagT4c3diFN1QJrX4YK
	SwYWyOf1YCbEO/KfxbcmFtaf0gx2o6E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=O+37i4tr;
	spf=pass (imf30.hostedemail.com: domain of 31KKeaQsKCOcJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=31KKeaQsKCOcJLTNaUNhcWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e1dab2328so26256103a12.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772004053; x=1772608853; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lmqeDy1YGPO6heAH4dtg7V9yIhQw7gZPhshB9Ud1SBU=;
        b=O+37i4trvJbkR/JuU45/zSete1/OvfyXNR5T54KSCwBCCOItAFVuOS8alhlsL9CZTK
         Sg2ip7rUxfgqXoM2gKHuFXVe2dvyDEPDDFuZxxbzEDARZi6CtW03idnaVNpVXhEFfbW/
         yAl0CD4PGB+EtxFgo5tmp0GH65Ctgm396sLaxawUvaz6wfOpb8aFJDOgCYq3bRJtmZfc
         Ell26g97eCsMLMoLzEzAU75DiF6cXyzunu401xsfxpg46hSsbly2rbYoN4OClAVXyWab
         9dMof5MPrxL797bMPAYUgxK90k2fwIZW8boVJD1b3yVItkDzGptLkirzAP8Dmzz7vzhS
         KqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772004053; x=1772608853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmqeDy1YGPO6heAH4dtg7V9yIhQw7gZPhshB9Ud1SBU=;
        b=S40dsUzwvYGETfWdGLe8qVzAvBnX2ThNA+d8FTzmfhUYgoK/iM7gq5aTksM8qdeyTD
         3G2G3inyzFDbUHZ8fvdQo5NukRQgH4dZKZXNVYlFJKE+neLTS1qt5hEc/zbnyvWPR8z2
         0jSkD9vy9K952KSDp6Sdu65i5980ytMF3xiWTL2qk1JLLUQ9keRJT/hEq2ZVGpfDzijn
         NRmDZ5QSvAPg2JlxBh9bMtbbenNxhai6CWP5lzDaqTftjXiXkstwGuzd/zfsDxNjVoTc
         coN9mf9YeUAYlgFYrHVsWnjB7Q0CtnxbHtw2YVteFQJyVDaHAi9/xtleayEDozhdjHkw
         tW/A==
X-Forwarded-Encrypted: i=1; AJvYcCU0/WZNfO5TDgq4dwKRHviSIaWEbm2q0W5Jg72qcy3f0vNMaa4+5N/XjtiC8wm5pCFVLcoVp7fECA==@kvack.org
X-Gm-Message-State: AOJu0Yw4PxC1sGmrXSqs/H5+t4pZOUHkfFQju+B3M7IYrxkNRbda9SqX
	fSHvJQTl4SLjzPglpx6dD1TI5oWeJLp++WEkPSMWshomw4aBnWXMvcQ+NTUTp+CstvqRN5ZsDBu
	QbnMITZhhzo9ntazetsy84qUvbw==
X-Received: from pgbfp5.prod.google.com ([2002:a05:6a02:2ce5:b0:c0e:c1b4:51a5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7f89:b0:394:58eb:48fa with SMTP id adf61e73a8af0-39545dc0482mr14694770637.6.1772004052747;
 Tue, 24 Feb 2026 23:20:52 -0800 (PST)
Date: Wed, 25 Feb 2026 07:20:40 +0000
In-Reply-To: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
Mime-Version: 1.0
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772004043; l=3022;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=41+6neAL0d27ks2wQws7sEuDZgQjzT5nG62AnxD5qpc=; b=Qf0H2UQ2mVaGwE9fmA4IWjbnRJGJ7WGDq8UI2QM5uIsOM4kNu9y1rdgzh53H+jjev44oOi+/r
 kT+aePH4Im8Br8uVg3C6xnPFChAqWmmulNjoE70K9V+ksKWXjrvsGjL
X-Mailer: b4 0.14.3
Message-ID: <20260225-gmem-st-blocks-v2-5-87d7098119a9@google.com>
Subject: [PATCH RFC v2 5/6] KVM: selftests: Wrap fstat() to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 207E68000D
X-Stat-Signature: nmw61b8azbjbtztoxtrainft8gipwq6q
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772004053-327019
X-HE-Meta: U2FsdGVkX19wX1DwToVwW/o2qR6uxQk4mTmcTyD/ppcN+By4J0r4Zxmk1mBv1qoBZ/Diao81LSiQGVoAt3/7lIQDRrFfOATvccT5eRWRzosKKsXhLMWpxxY41KHe9qVmxrH6/NTymY/L7qAE7ViiqDExMxm3/R8m0RjMjv7mh10g0APQLJxpIBNkOHWBAL2OosJVQmk3PRhn+2hVV5+enucqtxltTfx+qIJXGQ1OoOEGQ91R9LF6IExYmlILJhl/wvXXDuTOqys68JZAhVMjBgyWZCZkTtDb98wmkd0YkPV4PmL45QGr6pSJZS5rrq8bc76nuwwFDCV2RLtOP01JMyxBnR6+CpCXu8oxA+1JA3r8MxUBLmnJwNkG8LASHswgqRi02VLJyms7K509LFrEIwH7wy3r40gdJQaQYR3/cCX0mnmnQpRO/8L/HumA16/zK/DxNxCusx/ZJqnWZeEvrAJB5ZahGiFAAdq60Ezk8E8rYCFqpmCzSKarRHk/TI+B3Sg1N43gB6ek5EebOjsvajg/h0GLBjBdvI8uGAqZtpQAMPEX8WFIDC0ESafTX6VPbTBM6B11OzOXdbRFoFVpDWCYswlSwdPQnqOVsp8woV09BOn4fdFdJTRbrlcfx7KzF+hHuRObv9++42OQbRSF++1HZj2rLX7GWPtb8SixPhzumey2DpOAbljH1ngyC4poz8BgqEKoBcRkq+zAOyq/0Kik3WbR/U+2mmaeqje9fEIcmBdTkkC8xEajzShWrkYBRNjI72bJSBXtMzbZ2gffUEQwRECk0IS+JULmgp11WiFUNNB+xVI6raMgJJVF1rdA/HTmDXCZ3hokykxPyOgS4+6WNlNhBgORiNyYxYGFN6/uithsaXSyB/SfT4ofttNUlZ6VWUG9zoZlzIQLdXzLcV3Xfu1IdXwqSxbIBeTLjru/PH1uJIhnFiKhMqbFN9FcCu09JWQctuPxHOwEsLp
 xzMf2EMf
 99BhH50tjopVCe9V9iml2OpkwN/+P62XgMYsnMKJk7hc5P6+BBcI5XD9Voy6Nj2QZjYml8GDQqynNBSGM4iGH3buZTvVu2dUeqBnoli6gEriGYnB+Xg5DUOB3ym58OfTlX/8b3bFg9hKopbEWbWPcm2IYI9qZidn525AYMn2n77Ck9NzRlxFFxfKUgg7hneyHjca0Fl7/21toVXm0dFhVxwzEewqO9arkyzVi2U1Evk/+RKCVlMEXO20Dvt0pWO8ls4wb/PlZi/33QDjUS4FlIOartpG4ClyiCKL0fGfRa2bEi9VA1sYVskaU+EI4KUA9R6pV+pfRHHRy8vfrcF6FliS5RruA2YlLDpgHNqbZg7XfqhYDaJD1HgZT3jANwwWy9wyB5dEhhpsOJiuIMmLUkin/D8m6NYchgboNIO1EcbKtOxkIGxMyYGOzlYMOUYNQjbb8MjH7YQvtmjFlUmUaCjEr+to3vUD3E+eVBkn9Bw5VSE7MhxIirRLcObEBSrwiJwa5PEr8Y9fmiItwvrJ9fg4wzlRt2olAknpMNKKUONwmMaNa7uQuTQIANpwp97Th1A/d5PwmOAY/MKloSe0/tHbIY8pLZ2O/F8KiiPI+nbPCME40TdTZCLdStiNCzu7DxiPdODtQ734m04aSWfh7yIFuMlt72xZU0r9U7G4/doIi/Dg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend kvm_syscalls.h to wrap fstat() to assert success. This will be used
in the next patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c     | 15 +++++----------
 tools/testing/selftests/kvm/include/kvm_syscalls.h |  2 ++
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..81387f06e770a 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -212,10 +212,8 @@ static void test_mmap_not_supported(int fd, size_t total_size)
 static void test_file_size(int fd, size_t total_size)
 {
 	struct stat sb;
-	int ret;
 
-	ret = fstat(fd, &sb);
-	TEST_ASSERT(!ret, "fstat should succeed");
+	kvm_fstat(fd, &sb);
 	TEST_ASSERT_EQ(sb.st_size, total_size);
 	TEST_ASSERT_EQ(sb.st_blksize, page_size);
 }
@@ -303,25 +301,22 @@ static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
 
 static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 {
-	int fd1, fd2, ret;
+	int fd1, fd2;
 	struct stat st1, st2;
 
 	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
 	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
 
-	ret = fstat(fd1, &st1);
-	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	kvm_fstat(fd1, &st1);
 	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
 
 	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
 	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
 
-	ret = fstat(fd2, &st2);
-	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	kvm_fstat(fd2, &st2);
 	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
 
-	ret = fstat(fd1, &st1);
-	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	kvm_fstat(fd1, &st1);
 	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
 	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
 
diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
index d4e613162bba9..3f039c34e12e0 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_SYSCALLS_H
 #define SELFTEST_KVM_SYSCALLS_H
 
+#include <sys/stat.h>
 #include <sys/syscall.h>
 
 #define MAP_ARGS0(m,...)
@@ -77,5 +78,6 @@ __KVM_SYSCALL_DEFINE(munmap, 2, void *, mem, size_t, size);
 __KVM_SYSCALL_DEFINE(close, 1, int, fd);
 __KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
 __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
+__KVM_SYSCALL_DEFINE(fstat, 2, int, fd, struct stat *, buf);
 
 #endif /* SELFTEST_KVM_SYSCALLS_H */

-- 
2.53.0.414.gf7e9f6c205-goog


