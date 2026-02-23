Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFE0E98DF1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E76D6B009E; Mon, 23 Feb 2026 02:05:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975F76B009D; Mon, 23 Feb 2026 02:05:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894856B009E; Mon, 23 Feb 2026 02:05:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 778D06B009B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:05:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 172275B6A2
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:07 +0000 (UTC)
X-FDA: 84474834654.22.03C4A8A
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 640111C000E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:05:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m88Z+mpf;
	spf=pass (imf21.hostedemail.com: domain of 3H_ybaQsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3H_ybaQsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830305; a=rsa-sha256;
	cv=none;
	b=2Ew3SRtKQ+HzpPVZBklnrfEONl5T3X4oMFBS5I1/fxjdXfsEXK9VsJF0TUc3M0UNpZai3n
	gulP1yDGd3lZVUqlFQRsmoJOpUDza+ayO/UKk5oWm3I5syy7y+E6iVaQbMO17tLNaaINEc
	aFZBh4FuRSmeAFzYciv29gRq2Z/VhFo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m88Z+mpf;
	spf=pass (imf21.hostedemail.com: domain of 3H_ybaQsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3H_ybaQsKCNo68GANHAUPJCCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29bxp0SrERjlT2nttg/iVluHBRhM/KYKZg8jrRhN0Y0=;
	b=dZwc0eD2y1gXvWXTPekBAbWeK1y3pHm64ce3vsHV+ZowvCmiFGSINm+ZO6yYvNorFIuFJ5
	DaPi4/1N+3CGIBcBX03tIg6VIDfsxZhAdUdMp2bKXCMfSKoR0Y8zNbLciRTto37CEPujDB
	YsjAAKBXhp75idH8BsdeoZnUGJ2itW4=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bc535546so4314571a91.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830304; x=1772435104; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=29bxp0SrERjlT2nttg/iVluHBRhM/KYKZg8jrRhN0Y0=;
        b=m88Z+mpfpHW0z63nVHZ+9kS9oABCLG3xu1tsxXWT2lEvqfJQ3lKcFybWOVEbfuMcdN
         6YTzw+q3fq4qgoJjxrl7Li7DVI5Qrtm55+GVr1fK5f8/SaH6ua5BvkW/Eo2gv9kYfdDG
         zl2F9udJLmf9FxC1FEOCSBEWv+v+uIlyVfUgdawJE9yadPZMBeQIzF2T4m3dFwVm3mGo
         JiZtn6/M+8Ex/bqnnhpcPeqzQ4oevF7KrjbxM3BR+KP3ON2extD31irwgKGVlXTX5Jtv
         esa8TGANuYgs+34bA4AU2Kzxjfab3wWBFNloDlmByx14zZWb69rPUpLGPORoSxNFkNry
         raSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830304; x=1772435104;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=29bxp0SrERjlT2nttg/iVluHBRhM/KYKZg8jrRhN0Y0=;
        b=YniPeeHUqkOhETVD2liaCz6t4pueLBjJiRDRa99Bo6tJKbbkNvBtPq9B+rttDAsX+K
         XUbLWP7DwTBE+MofQV94CGNoV8E4ERiHAVA6pOBX/uJcSBO8o0A8aXeWoOTbz8clDJKs
         OhNLMHlfmlDULgrbBiA0XXDrui9Al4jDWZ1v69E0Bd3XxFgERpNbUJI7Sfs2L6K6n6ib
         ymemIu3Bbo61sXwOCmYVfIMSpJHu/JnOeICZH+b9qjeqBxlvIQNhu5nGCTa8z/EoLIfD
         msijOm1tYNoyvhc1u8e0O2opbQqDntzPTs9yM4MI9zNpCzJHEk9ncrjNSexgG7SUntru
         06tQ==
X-Gm-Message-State: AOJu0YwkPbUvyS+DPOGtotUPwUE2FkvVb8O4emtXs78voUVHSD+/JDhw
	6DW/lfJvIhWMIo7O+fanZqVca73gWu3He1Rwh9pda7m5bf2ffpfmBdwjUj0RS+wDHriwkm+2wjd
	HHaUCmkV5yUK0AgOuJkdbX1KWUOuRyJYlWh//MSSSXuXNw+WTfR6QAkDfIqk6ZF7VNdi4eYGKbl
	9hoou3hr1wIHHn7UTp2sbleN9OB6/V3c8NL3dlK1gkmrg04WUmtm+40t+TKA==
X-Received: from pjbtb14.prod.google.com ([2002:a17:90b:53ce:b0:353:3526:238b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2b8c:b0:356:2c7b:c010 with SMTP id 98e67ed59e1d1-358ae812409mr8015127a91.11.1771830303714;
 Sun, 22 Feb 2026 23:05:03 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:42 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <3525199b4a04f0054566abe90eb99cdd5b9939e4.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 09/10] KVM: selftests: Wrap fstat() to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 640111C000E
X-Stat-Signature: 7kxneiqcary5fy3qry5e9yrij8jgwrhn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771830305-38181
X-HE-Meta: U2FsdGVkX194fOeawua6kFXNpI6wkzLgCKX15lYvmP5sL6KdT3gyxHot94ttt/9kh2w5dNoCv4rctKCt/bp9yea9tYtoKnpUFVHEUJXmvPJvh7P8og+RWBSBuSqsbccQMwtVNOVcN0IiOjqwy0+z1GbYedQwackYbyoYtDzp9E6VVhfwDRtHnmCr4p3nPYrnW95dVjrXCVZZSkRC2o3laJuEt3Dpg488O0TmVjGCMS2X1YzXmCzD3y+Cu7E94kwplPBidjLKdtNH7ebThtJmYosu4InT6xlSKKWQj23FSif3NLzmPeEHdRtllVC6eBTr0IRItpRD08PputKfuxHQnkX5bLh7q+1dkhcrK8J33RHmA3u+lbhnXBUUxPde4hkTFAE/I2eDGHjXc2DL8Xb/q5txFleFb632/9zYk2TWIzVRKQnXPJGLZ/TylFCgjlVJBdGLD0k9gfzmBPf3/n9jrDcoaxMdSWMCthjKufgVs4Au1HbfIGBQX2B8T+tzDa9m5dcD9RLMARTbQ8noSZQE+PxZOwxWH67CR/7O4O5bWxNlaz13ARkYoqasj7kLg6AT0OMdAR5EjNIuecUB99KXnJ1Fmj0TctVxNSdOm1qQocuer6tc0oRShLpvw6ff/FuScmmxNU13RAFhu4lAM2rIUlnKzSSVZYtPsJ9Si2QGPuoa8O8jihCjMQIUUTkXk8N8igW4dOnJvpwq98J5lPShLVByiKpsz4/uzPHr5NeCu/j9TWB7Q5FQu2jaazcATKnXxw21oDkCNZmMP2QwdQF/GrugMcyTslZ1NEANw5RePBktYjZ9hjJgD2F/O9kGQjKz+14RkuFg7OllM4Sm1Hc5kwJ2WMA3Ak7yBk35NG2qhiRGjECZ4TFhpRCTX9yKoo+2w3r45hgyVSfv+VHk9i9CasXzRtWb6QhHvpLq8GeMleYOZ2XHb4VR/oDSjmhKIfNwfYNnJ6pXaTIgpudYiPC
 umWPzOrC
 iJs/365Xn5/9iwBCfXM/5B/okYvcfb9R/TgvWmh2dOPWDsteDeslblkiRrRioYrCtMeHbq0m4ll8u866avnq2FXPD86meCvDs7RK0T/3je+osEQkdAQrpE2nNiIolo8XhGmf1MqT90mXpZLZJlF4efT9OPy1REglY4yRl27v8a5tp3OkNp/91e1PXiemmCtILWhPewGRTcv7w27vtYJQ5Mgjd68c5rh0yG/vpQH+NH1tKqQ0IQMfEARnOmdazza944yyNe0cyKdl8JsBqIyr5GoSyurLvo5zQ4I6FtXVKrnH/Onq55H3YeUIN7h967oFCodr0hODqUDl30ebeSaRzoceVq7SHMK7YqhpF3T1MjYLv04KgDzXJWve748e4H3ELmzHGgBW9nH2qur1Fo/0UVYrAy2/s6gOabGNDDzRwlFaxSPHxkFi+YZ7mc5Gm8jbbfyDJ50jBcuRkb904J4MN8Y9UU9OhvvdMzef/Z0Jab65qedWSBZcwuYXE2KMBV8OE8/Zw2iBx72t9+P5KS8QQkvJSd9RE0etVlOT5aEXBsils6GPP1+QPmtDpzP7CxDSHCOufP0N/qkOiLlW9y7TdNpHUXFfT/FGEFhmZ9Nepf4+neoT5j7FaBIx0EL+BHomZ7vBP9u776utfVwoyW1R4prf9VrpWIt10wPES
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 tools/testing/selftests/kvm/guest_memfd_test.c    | 15 +++++----------
 .../testing/selftests/kvm/include/kvm_syscalls.h  |  2 ++
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
2.53.0.345.g96ddfc5eaa-goog


