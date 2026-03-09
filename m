Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 804E2EFCD78
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 09:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6EF6B0092; Mon,  9 Mar 2026 05:54:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BEAC6B0093; Mon,  9 Mar 2026 05:54:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2BF6B0095; Mon,  9 Mar 2026 05:54:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD2A6B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 05:54:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20AC5C4017
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:20 +0000 (UTC)
X-FDA: 84526064280.08.4907084
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id 365CE80004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:54:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tp9alRrK;
	spf=pass (imf30.hostedemail.com: domain of 3yJiuaQsKCAkjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3yJiuaQsKCAkjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773050058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6X2ZyGf4duGXbwGrp5sOhQZ4KKFdJaMZm2rOVj/sk3w=;
	b=S57pD3vQOVOHtaNdOX6mHDP7R/twt/wTGMRdAaUiL3U753ICD5J2rU3kUlq/iF1qUguJNv
	TWjEEL0LVGCbcl8ZGf+9Webj3x9LssmsaXTArACBmh38uBe2CBBDr6CKiEesOLgEK26Gwt
	zvI6qu7talWrmdMOrIX3k7jZYcOKklo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Tp9alRrK;
	spf=pass (imf30.hostedemail.com: domain of 3yJiuaQsKCAkjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3yJiuaQsKCAkjltn0un72wppxxpun.lxvurw36-vvt4jlt.x0p@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773050058; a=rsa-sha256;
	cv=none;
	b=lm55hzqKxBQLJYe0jaZFvHkAT19L4dUrL+0Oj3F2/pfiqDBQ1n7aonIULi/NOjtNdQJD9N
	ajSIrHs3ZHvzMEO6FRMMZYf65Hc3BJ6TC0qkpjW+YEpcpUsVKsqXHB1tbrkws6fIwUXwD2
	E/x5eGphcdBldk6Fbo+TcUzRTYkJeCs=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae5031c6c5so385905515ad.3
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 02:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773050057; x=1773654857; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6X2ZyGf4duGXbwGrp5sOhQZ4KKFdJaMZm2rOVj/sk3w=;
        b=Tp9alRrKahuTVZQppsmNX0np0XVa3ip3oFbfKxFQQierGCevl8tumqHeoJNTmupGwX
         Gf4wm6r1+ZsitwpSFORKX6HrEXUB1Dx4c7GxTuX/vfbhCMMD8Jna1qurhTbYzQtb/YQ+
         GH37Aix8RonHQuTdpNhwru4ZBzaibSbtIx1E00g1r9l0XMuYXnAhyzJUeVi9OYRkhx56
         OthX+8OjoBd9L9KKBj7u7EslKSO6AxhDkZV4pxwE4GxIWNcckM5H/e6Dz0qqXg4GX3px
         eEap3k7wIc+KAUjqmMH5HY17tEagU0+7crk2QRv8dZwPUXkR6q++2TA/hqFOFyDehmMd
         6yEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773050057; x=1773654857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6X2ZyGf4duGXbwGrp5sOhQZ4KKFdJaMZm2rOVj/sk3w=;
        b=kx5m/r45F7SuntBf/xsfa2ibKHCysHfOxJ1XOazp/OeR+mvNxX/hB7Qz76QDngx8hL
         /VEZmpkB7FhlR4hqegtsMYQMOM0Ctx0l8xXrWiCRi48KK6HhkUBf//+/4x55/RhPgIPu
         /fpFF0B5r6OFaoHHBtzNKrh+pOmX9Ig7k7SdEMxtetXUOD5cnGYSHFwUYCCfAg8qNlkI
         RECUvQySqa9osKoLV4DSo6mhVMx0VTfHIbCjAZ270UxKQn9NBe4O57b2HBwDNid/U2ve
         e7jMToCGg+qQ2vn8sQe37i3gkzJfvTfXU2k7LtpGLScXds1jk2tPtKxX1E824eIT4+zE
         lsTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsM0gvX/iFsbhTgM+o+w2xARoxrsdDrZLureS1YJEz1UMhV8eRm8Hpg8gX53a9FZK41/j5f0uEJw==@kvack.org
X-Gm-Message-State: AOJu0YxDheUUgT0mq9KHXsT+EkEdonQp/U+2T8oXr5VU90QCuF5RJ+3h
	SQw0Gyq7eeqc+kmwEeONylJ76/HGdXx46i7ssfX4c7Ny9hjdGkg4HruyK+qKE3eTtG+nuwRn9S/
	6FJ2Z3uDmzw89aGB720zxsAanyA==
X-Received: from pliy13.prod.google.com ([2002:a17:903:3d0d:b0:2ae:3f26:a1c3])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e890:b0:2ae:7f49:8e37 with SMTP id d9443c01a7336-2ae82416de1mr112118785ad.11.1773050056826;
 Mon, 09 Mar 2026 02:54:16 -0700 (PDT)
Date: Mon, 09 Mar 2026 09:53:54 +0000
In-Reply-To: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773050050; l=3039;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=yeoFRB0x0cYTGtPfHobeqkFPIXI/Si+Y5++BAFhp31U=; b=/7QaGGXJvObuh04yNGHeLFEneGC6nTgx3TASDbD9523g5EzCojJdSnNh5/P0oXkbUD04qd+mq
 7mGm6etCRziCzsqHuyNkqm2bt1BC9Gf7zUKg1q8Pm9Ood8vplQeG6EK
X-Mailer: b4 0.14.3
Message-ID: <20260309-gmem-st-blocks-v3-3-815f03d9653e@google.com>
Subject: [PATCH RFC v3 3/4] KVM: selftests: Wrap fstat() to assert success
From: Ackerley Tng <ackerleytng@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	seanjc@google.com, rientjes@google.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, fvdl@google.com, jthoughton@google.com, 
	vannapurve@google.com, shivankg@amd.com, michael.roth@amd.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 1os7bgu9iwwoe37or97fdgtiyj7pyk7i
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 365CE80004
X-HE-Tag: 1773050058-949977
X-HE-Meta: U2FsdGVkX1+DpSoTIVijaC9cFLxgXSzWa5LVXBhZSdgRXyTxhdoN4f5YObMnhb+ixRSK/Gr/NZ4AlrgHvqdZdbtAaYHOU57TTExnLSnv/3MBlmhs+HWnRShQvU3NtHKwoE64mVsb2zdstqWsiu4lNK0sglVdoeb1AAGfnMGxfLO+bEFbsgpcZ4yC/K4AJleBkjWT3IMztscywCtufnnbChw2ZpG4UJTRsiUkCd3yQ+Cc/VBx/9Di8uAx6x9Apf9OsB5d5YB1c1ej+rwJnaL/4q349v0SrOCq+EB1WZiXgTnTN4g4alU0TsSQaEAOnFrNiecca+3Rfv3kmVxPzCRKIn4YDnSFJvxsjLz3DaMjmU38T9LJXYlH1mqOlwIacFLCW52HiMFPvhpO4P0o+weVQ/BRsEp3lw7Z+JizU+psDUW570CM8SGto+KPiKwFckJPXlfTVNu5UbOvE300YH2F/1+GXed99w1j9/Y1WGKS0dD3LpYckiZICHaPpViYAAmEiUpOC1ZWtLUWdv1Kti1H25AQ8lFISnQZ53n7Et0NgM2S+lfqtXTY8+yHEjf1ytznvrCY1gyy0dg0f+6e2s0Sj66Tty/Iaa1uaWm/ROuJAm0pCF77Kjwt3A+fWx8idft2/1+PLyVjJjlWdUR1EMDoExgJhwvDkd0VjtSCZHB/sXnKsmRW9dKCwCY7px6CT/OsQlgew191n2YS3Qd8oiZ2sI4fOhBwFcT2+LHQzyoZQ1Hw7tWvlehscYcDJEShu4f1we8oirQw/r/7goPeXir8ncIAlQIuoLip5nJihUN4qjgGsdMj/iqyqBFsovQ8QdiIZ1ggGcGBmL3XUldqmqICZluoGR7DGXzrB0cXr43sh+9Bx0HrQ+lf5qa9+Bqi+pbUBDzDRf4dDpvA4DcHc8SkO+uspxh6ae1AIOrR0COhtlYcC89nhDcW1X4ATKOlLBnbpzlhjlLuL5L07mXFS4z
 urxwd/Qy
 ic9K7GXfy/ZTzrHzv08mLF5aawtpYc455i6PUNNBE88W1hXEqOuaFSeAvHJ46YZEnguiGBPu4PaOhJj6k19Ls7ssQZQCQDN2JbIIOw3lWYF3YyiQVnkNJ73jp5ZkEetVXXwle2Vc9bdLAuZuBCKj/XHsQHJR+EBM9IOohkQ/9fCNtyEYmoewnKERbpDZr9UgQiV0JR7Md0tjgkcO4raJN8yV8iAYTk/C0MuVnBUe+vkShj7Asliri74Oeu89BXV8Y3aAqc3Ir4zgOTCL3sTsTrwktJXfsmJ9NpmOGa/Ew1Mknux2xf+7xpOcxEi3GeCSEyEAA3HSE72B0nt8IZYoAY4xxADC5B71aZO8kTR1r3iITxmzpVqi3d1BAizcgqHAzPYRcAeYtCIxl/z/8Jdmsslrkhv89SiGl+M+NTRs738MQgCToy/1NCsCd3bTUiKw4T7a6TnEKGLy5tgjyGrVM0Xv3dd/v7Rdt9JOCPDmEVyZSa+1WFQtJEgbhwzLokAWE5efkGHFrFD54i4dsdFiTuQbUo2gzxRv2ksGp3J1byGRQIaKI5JXQRqe+XUg0b3Y7mFbeYd9dq3VNiQk2IKjx18buxJd9YNeIBZetiAPeMNhjkHJU/pT8ckMZshB17HpRMFSrwvgrDKMDOjXMb5mDOBoNNj9dSiH128dgFGxxfaXmKKQ=
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
index ec7644aae999d..638906298ed73 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -270,10 +270,8 @@ static void test_mmap_not_supported(int fd, size_t total_size)
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
@@ -361,25 +359,22 @@ static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
 
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
index 843c9904c46f6..2266c06347f5d 100644
--- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
+++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
@@ -2,6 +2,7 @@
 #ifndef SELFTEST_KVM_SYSCALLS_H
 #define SELFTEST_KVM_SYSCALLS_H
 
+#include <sys/stat.h>
 #include <sys/syscall.h>
 
 #define MAP_ARGS0(m,...)
@@ -78,5 +79,6 @@ __KVM_SYSCALL_DEFINE(close, 1, int, fd);
 __KVM_SYSCALL_DEFINE(fallocate, 4, int, fd, int, mode, loff_t, offset, loff_t, len);
 __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
 __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advice);
+__KVM_SYSCALL_DEFINE(fstat, 2, int, fd, struct stat *, buf);
 
 #endif /* SELFTEST_KVM_SYSCALLS_H */

-- 
2.53.0.473.g4a7958ca14-goog


