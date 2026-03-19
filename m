Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC17109192F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AB866B04B5; Thu, 19 Mar 2026 19:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437DC6B04B7; Thu, 19 Mar 2026 19:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8ED6B04B9; Thu, 19 Mar 2026 19:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146626B04B5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9FA014076F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:05 +0000 (UTC)
X-FDA: 84564410490.19.04E9BA7
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id DF63F4000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pUGxjnfA;
	spf=pass (imf04.hostedemail.com: domain of 3Noe8aQYKCIsBDxwp2v33v0t.r310x29C-11zAprz.36v@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Noe8aQYKCIsBDxwp2v33v0t.r310x29C-11zAprz.36v@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLN80hi+wV7RsIDgwy/tRG94iKBvpQ4g3gjUbQ44niY=;
	b=PahRVMU9JGbsgfFtdzFTjZ0bs33f6LyacPQ18ImxYT2xLfnWA/sy3JMmhhEVcyzF1bbuwI
	t6jjhSujlQVZbwotfoMwJH10J9N4UUC1NlwVZYnU6FJum0F5lj5nMKnmlJJLnKbAN+SVjH
	6Qms5oOOdRIf6GNwLYWTsprl5rnnGR4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pUGxjnfA;
	spf=pass (imf04.hostedemail.com: domain of 3Noe8aQYKCIsBDxwp2v33v0t.r310x29C-11zAprz.36v@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Noe8aQYKCIsBDxwp2v33v0t.r310x29C-11zAprz.36v@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963063; a=rsa-sha256;
	cv=none;
	b=V+wNV+O6icwVLlxW0gEnx7FGhQ++UMa+hHTYG6pQGpg1bu1JJ0LNfriegDjL3inLbOJDPp
	FAsuJ2GlGfGzMjOa3zIE04Cd0rlWNeBHGmqq79rA/5nNfYDs3j8dMPRwBRQyhhLwi2i2rp
	1VDYZuKVBy+uk4b1BNE0rHknPF7pvhA=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b630b4d8d52so18745a12.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963063; x=1774567863; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dLN80hi+wV7RsIDgwy/tRG94iKBvpQ4g3gjUbQ44niY=;
        b=pUGxjnfAr4MosZM/Tce/ld1UY0zfuOwDF9sEBwOqaxyZC51OURqA44pffsR5qXwxhH
         vp+J+X44cqiuc2ZtVzqB2RkXONtk5uvMBwak1vz3oaoPdDhofRtdCs0s06of3jsEGL/D
         l2c+6t9rIQSz+AQ/yPtJNzriTHwVnSXvFBykjnNLW4S0FjcAeBdTOY2xFN5bT0WBr3qw
         F8/uvnZN63fuGxkO1vUHmEozIa07oUfoCpejoXwn+5Ng76Tyel4ekDcY4vA65HEMNNga
         MkwcWK4MAmFHtWStQsAge5EqgnKVzR6nA+mFuRbLYypZUPTMelwqM2j8ZD7CqfFhELHi
         JPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963063; x=1774567863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dLN80hi+wV7RsIDgwy/tRG94iKBvpQ4g3gjUbQ44niY=;
        b=F2vojhCvgUwuh5dMCBIudLS5P60Kx8Op1m8SZLb6zjs0StK55TLBNumrixuUGB8qMx
         lW6/S6uw/IDYd+xPM/DEJmQIrAjo74lukTHq/XmLPnoByWxr7CFUcHmz/81sBSd5qo7H
         zPZ7U+7gtVIY2jMrLeqHuqx46Ah7gyL670vAj9e5k+UEos7nJt+QBHkFawIlV0MuYJaf
         n9GTHeSF27U8B9xvJjklwwWgbTYrvL0DBsJLQ+Id5yFs3lESGWW4/D61UhR5A88K/yQR
         87lC0J/G8A14KU+Sj7BgmNERswN6QETEuOXkeVgFy5R3Pkdcx84DbCBFVeOBlj2Aj31Z
         YYMg==
X-Forwarded-Encrypted: i=1; AJvYcCX7/ny2+uaPRuipHAZz4Sa0begCOCIDawqcD23bu3iNdnlR9YsJJTP/HsmRqxykaRvu+IgK1kRASw==@kvack.org
X-Gm-Message-State: AOJu0YwZ8zQopu1OXsPD/bq0GoqfZVxpjD//TZn9YuIt830/6Sjf0VGC
	tW5RHkMCw3xkDPPOBS4bvw93A2zEuIRcmQY5M30oEnTB7Y9bhpTufI/GsY9HT8dbcDGn6rH8hCG
	zu0Z4lQ==
X-Received: from pgab123.prod.google.com ([2002:a63:3481:0:b0:c73:9919:c4f8])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d81:b0:398:8546:c3fc
 with SMTP id adf61e73a8af0-39bce9b7e6emr924394637.7.1773963062623; Thu, 19
 Mar 2026 16:31:02 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:32 +0000
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Mime-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=5121;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=XqXOZx8bRJ+MW3QLKZ9eLemXOW8pkkhqg+4Xehhhu34=; b=nez3ePfz2DyHfRD1EU96GSlzQoAPO6925YzKCLhpMi6Z7BSIWwpw9+JzE9uSu8N4PKdbla1ke
 3gFKoffsCYJChdWiQqNpWcqhpXJunH0VukcDhLctTtRU/LD9KRdsv3T
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-5-92c596402a7a@google.com>
Subject: [PATCH RFC v2 5/7] mm: selftests: Add shmem memory failure test
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: DF63F4000C
X-Stat-Signature: g1akazxe13hppypbzje7k66ua9tbx4yc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773963063-660907
X-HE-Meta: U2FsdGVkX18R+OIv5r6RAhs7pQax2/4xl/P8Yp1vpgoZF8av+Jgh04HiJlGiJQ5BA/7uWPAXje5VW1TdWTUYewXGCDSMTcjwQ8bqw3t1lnj49X7OKUmUlTCGL3QKqzUC2i9CIW+o/5ZBfW6+PX5AzoUfyiOw2JjRo3dyI34Pvd5Elh3NagLbTuG4zJ6vD0tIcftpXs4PEYPrNktJTalyY8QjTHQlo+6o4y7gdqlPcdjDM9j0P1EEaKZaTgIUI7cOjC2U5BST4G/zeanbrSPmXfwRV9tTEh5O3kZM/+R7p9UH4Dsl8MV1vucif53c7c9sNQW1o1+cXzVAhWEDWgsoQc+qnjitbt/zUB1OhBcwjw7O+/qSWD88ItKF8ErPGEjSCh/QUyCeMP5koLpEFqCgjCubip8COLJSRHjUFP8dEop/KyPXqz1E8SCsy2YNXQIcDA2cqYRgfzLrRR+tZOCQ6IJWeYBZeqDxLiUQWnDjBj0niWysWbm/poOx06mymAwJJR03+qfBzYElgWd4S7t+nwX5eDYhl1odVCb68VdIuAgiatQuz6NcyIeienivDJQqHOrI1JuZNLEl5mlycBDZBDWirYhAQd2j3W6LgsAOShGn//B5iD29fv2v94rwM6sfPVNqit4FJrAzmRSPKjLtqT02b2e0a602ZaotcuVFClUnQZ0A1095CLg4WgXHjVFzK7rsLbFgeECHVX0bWKn5mJxaNAcunxo+UCBuOYg1o3y6h38sg1XoNfhH43xtOJoM0sWkGggrBB1ml1FfetVxdp41vYC67wJ8KWeG9tDwjRb+yWZjji+CaqRaCU4wUZ0InAkKfrn1O0myhGXnLpVaEez4Z0rbEi+8mFePBk7GgSY4pCa64VwGY8XaoRkvi9BhmhZWTY0pMmwE7nuDG0UThTt0UHFB2NTL6aAuRMqMTbhbXivcMEZ1kdVTAe7InVx7JNKIqWafDsel50qpMY7
 s9o+GW+E
 7qI456iAAsjkgVr93VPbsBSQ1yAFktcc/VxQ643q2RiLA0zprjT9LO99MUPmVgPN5Vv7qbbTj+bf2nm1VeEPTWOI7dMYqXTiwR5caJhHq83nZHRi839/IA53Mz4W1vlhEVEuEAql+8F5Cq+BoHsDzR/+RsIXZP9YLwU6mDVou4I9Jk4OQAHHFLelOcQjVJOi6UfKN4gSaicrcKYrTKlFag1gjny/pBCXCT96aq4BPj54co7hCG9f0SIhlj1bcwVtoOY3h4UL+ruuGebl+t0pD/9qg8Rve6+NptrTTz4rCP5eP1mw0hFoRMTNaYfY9Xbpdf8qCEWmJaxybR9JwVSMdUQGXvh8TgaXv+XadeA6PBzXHoSgu+PBi8kOOU7U4HaYFHLI7AByQr1Dw8V8nLa+iwIpzHc0bT7t0egvHZVMfPXDPc9tPxC/xur+E+l/ng1qAaux0FCGDG9VuZ5SIGf6OtqhwSnj51JaL2RUox1VK9DIsVYSQOPHbefQm9Jg3f1KSpzBhgDyQeC9cf4KUxxMMJKxsY8kwdElJw9htoeXg8skoolrtZ8VrCPKN/EAzAcE+Now7iGOlut2jHIv/qSXXZ8DyYxDl7gNy/HBQydFMpuFoijP7n+yxfIenYKS/Idvuq24QhAgkn7KoBaHH04jFDwAXfsvZ70tJyuAyHiMyi2/lpq69Q1FGYRaaPqzjQJyiQVaFvmG0oo2Aokg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a shmem memory failure selftest to test the shmem memory failure is
correct after modifying shmem return value.

Test that
+ madvise() call returns 0 at the first time
+ trigger a SIGBUS when the poisoned shmem page is fault-in again.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 tools/testing/selftests/mm/Makefile                |  3 +
 tools/testing/selftests/mm/run_vmtests.sh          |  1 +
 .../selftests/mm/shmem_memory_failure_test.c       | 98 ++++++++++++++++++++++
 3 files changed, 102 insertions(+)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf52..ac033851c9eb 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -72,6 +72,7 @@ TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
+TEST_GEN_FILES += shmem_memory_failure_test
 ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
 TEST_GEN_FILES += memfd_secret
 endif
@@ -259,6 +260,8 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
+$(OUTPUT)/shmem_memory_failure_test: CFLAGS += -I$(top_srcdir)/tools/include
+
 local_config.mk local_config.h: check_config.sh
 	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index afdcfd0d7cef..58fb959a7936 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -402,6 +402,7 @@ CATEGORY="hugetlb" run_test ./hugetlb-soft-offline
 echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
 echo "$enable_soft_offline" > /proc/sys/vm/enable_soft_offline
 CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
+CATEGORY="mmap" run_test ./shmem_memory_failure_test
 fi
 
 if [ $VADDR64 -ne 0 ]; then
diff --git a/tools/testing/selftests/mm/shmem_memory_failure_test.c b/tools/testing/selftests/mm/shmem_memory_failure_test.c
new file mode 100644
index 000000000000..44752024a7fc
--- /dev/null
+++ b/tools/testing/selftests/mm/shmem_memory_failure_test.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This test makes sure when memory failure happens, shmem can handle
+ * successfully.
+ */
+#include <linux/compiler.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <errno.h>
+#include "kselftest.h"
+#include "vm_util.h"
+
+static sigjmp_buf sigbuf;
+
+static void signal_handler(int sig, siginfo_t *info, void *ucontext)
+{
+	siglongjmp(sigbuf, 1);
+}
+
+static void set_signal_handler(int sig, void (*handler)(int, siginfo_t *, void *))
+{
+	struct sigaction sa = {};
+
+	sa.sa_sigaction = handler;
+	sa.sa_flags = SA_SIGINFO;
+	sigemptyset(&sa.sa_mask);
+	if (sigaction(sig, &sa, NULL) == -1)
+		ksft_exit_fail_msg("Failed to set SIGBUS handler: %s\n", strerror(errno));
+}
+
+static unsigned long addr_to_pfn(char *addr)
+{
+	int pagemap_fd;
+	unsigned long pfn;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_msg("Failed to open /proc/self/pagemap: %s\n", strerror(errno));
+	pfn = pagemap_get_pfn(pagemap_fd, addr);
+	close(pagemap_fd);
+
+	return pfn;
+}
+
+static void test_shmem_memory_failure(size_t total_size, size_t page_size)
+{
+	unsigned long memory_failure_pfn;
+	char *memory_failure_mem;
+	char *memory_failure_addr;
+	int fd;
+
+	fd = memfd_create("shmem_hwpoison_test", 0);
+	if (fd < 0)
+		ksft_exit_skip("memfd_create failed: %s\n", strerror(errno));
+
+	if (ftruncate(fd, total_size) < 0)
+		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
+
+	memory_failure_mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (memory_failure_mem == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed: %s\n", strerror(errno));
+	memory_failure_addr = memory_failure_mem + page_size;
+	READ_ONCE(memory_failure_addr[0]);
+	memory_failure_pfn = addr_to_pfn(memory_failure_addr);
+
+	if (madvise(memory_failure_addr, page_size, MADV_HWPOISON) != 0)
+		ksft_exit_fail_msg("MADV_HWPOISON failed: %s\n", strerror(errno));
+
+	if (sigsetjmp(sigbuf, 1) == 0) {
+		READ_ONCE(memory_failure_addr[0]);
+		ksft_test_result_fail("Read from poisoned page should have triggered SIGBUS\n");
+	} else {
+		ksft_test_result_pass("SIGBUS triggered as expected on poisoned page\n");
+	}
+
+	munmap(memory_failure_mem, total_size);
+	close(fd);
+	if (unpoison_memory(memory_failure_pfn) < 0)
+		ksft_exit_fail_msg("unpoison_memory failed: %s\n", strerror(errno));
+}
+
+int main(int argc, char *argv[])
+{
+	const size_t pagesize = getpagesize();
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	set_signal_handler(SIGBUS, signal_handler);
+	test_shmem_memory_failure(pagesize * 4, pagesize);
+	ksft_finished();
+}

-- 
2.53.0.959.g497ff81fa9-goog


