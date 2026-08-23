Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38425C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7376B00A1; Sun, 23 Aug 2026 15:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598256B00A2; Sun, 23 Aug 2026 15:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AEFA6B00A3; Sun, 23 Aug 2026 15:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10B0E6B00A1
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:41:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 635D212037C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:22 +0000 (UTC)
X-FDA: 85133553204.16.88B43A0
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf14.hostedemail.com (Postfix) with ESMTP id 92116100005
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R8Fv4Jfb;
	spf=pass (imf14.hostedemail.com: domain of 330yLagYKCAIy0kjcpiqqing.eqonkpwz-oomxcem.qti@flex--wyihan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=330yLagYKCAIy0kjcpiqqing.eqonkpwz-oomxcem.qti@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyxwXzW/e6yZkOmQq00SGFMBQuYBpdvqua93AJie1gM=;
	b=YZ8VuPO8QtVOXnUP8xpnljP9iazrLkqxnDNN/VF1oiF3M5KQwfRW0Syx83vpm/VzBDfj3L
	Jl7JQ6pxBwA8zMjCOmrn5qsPUxlBhktH6BuZk/qO2IK3BCYizB9YsVwEaQTGcoOLAAdMJc
	tGSsQRt5I9fl2kHwd+XlKzLmAnXHe9w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R8Fv4Jfb;
	spf=pass (imf14.hostedemail.com: domain of 330yLagYKCAIy0kjcpiqqing.eqonkpwz-oomxcem.qti@flex--wyihan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=330yLagYKCAIy0kjcpiqqing.eqonkpwz-oomxcem.qti@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514080;
	b=tTnF2okAYBGG7oyIe5Rstm7l6jd47ae3kci2eBxvtbahKk1EeZ0NqdUy8rOfFeK/WgOVb5
	1jn2U5cfTL09y8sMMZ8lLBplPdEPlIjYZGby2HcOCKS7HTB2++DfEK9BueXikQBdj6GJ+u
	di0BcXdgiGQhsIPczx4fRBxBWpOxIRY=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cec4226c70so35546435ad.1
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787514079; x=1788118879; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KyxwXzW/e6yZkOmQq00SGFMBQuYBpdvqua93AJie1gM=;
        b=R8Fv4JfbY5l2xoIwYObDSH5Rpuxs1MMFXSWk73eDAtw/JS45mg9swm1CEKhLmwtkf6
         GCDsZ8WyWhLBOxGGr/q8cCxR1pqg8JAb9nIBu8WKyKSl7EkUmTWBO9nzNbluJfj6yE3p
         ulK+IhmW4lwoc5E6RDyOcwcU4GhLIQReu4IH4ulz7E7RdVMHwf3kilwtXidtrLGstTW9
         4mTw009Adql8Vy3x6x8mLUKP195LAxcuTK1LYXZ7wNB4Lh92iqa/mQeVtdO4VBQo7M84
         YpmAFWoRuthb2kBIGuV11oMY1LNFaW3zDPbogFnl6ZSF00wuj5T89KbcOp2TrnzYAGi/
         xdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514079; x=1788118879;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KyxwXzW/e6yZkOmQq00SGFMBQuYBpdvqua93AJie1gM=;
        b=s+MgXUvQX1EVxaaPDEJAWBzG6s8Ddx6nJtYIdG41rCbxB/jSIV/ipbT8O25v4Mlx6D
         Xxk5ep72+aOsMceLtDwFFZqtFBMNbVBlPRHF6ghXYa/GmiFst7k9TkNZZgKk462ltTsf
         tc40rOlaALjODR1K5iBd/cBTCTDpB3b656eWG1w87+pJouTW5t8utTg8IYBvqDOVVoVg
         hTpawsEVH8Lx+0McB3uKYyO5KBjlGXl70rrVedDAr3SiBnmyf4vwO7pmvlIYUgeHv1pn
         HPoRcRWXCTf/1tgljzyBooYVzT9JkUz7+OoKNEGDUf5wUAyKmp1LEar9ViPubNZKiBq3
         zMJw==
X-Forwarded-Encrypted: i=1; AHgh+Rq4m+hoRCVY4fIimzoskGBcfY5j8lgpM+PnW6Cj+NfLRVsODN7L31GvHVb1d99vmQcFHwzoamjyeQ==@kvack.org
X-Gm-Message-State: AFuF++l16laDCAMgau0NYb5WWk7noaeZ2JVRL1/bezxbqsJQVhUXakmT
	xlnfWzQknQOoA6XPqzS9l5OKZu7YyGnZnF/tmvChUL9xTS6L+r4PRUyIu0NLIbVGqNNgjbTNVXJ
	mwhXOVA==
X-Received: from plho9.prod.google.com ([2002:a17:903:23c9:b0:2c9:a5a0:a677])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f693:b0:2d3:7c58:b0e1
 with SMTP id d9443c01a7336-2d64a9a6dadmr341194815ad.0.1787514079265; Sun, 23
 Aug 2026 12:41:19 -0700 (PDT)
Date: Sun, 23 Aug 2026 19:40:58 +0000
In-Reply-To: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
Mime-Version: 1.0
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787514072; l=5373;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=6H/urXyqo0R+eZVEoqxfnPvxrvulOJIGV7ZBXfbSyS8=; b=cfUM1tjzhEk88mj+/xQKY18Tt+IgfKj4f4BWzGxytwJR3RDp3E/1P4wLOfG3mtNtrmLJ7RP7q
 DWeg3JebmrBC9/hzRqFcen3nbsG48on5ZN3oWRga2CjGRq3Ol71dSNW
X-Mailer: b4 0.14.3
Message-ID: <20260823-memory-failure-mf-delayed-fix-v5-5-d97a5703e45a@google.com>
Subject: [PATCH v5 5/5] mm: selftests: Add shmem into memory failure test
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92116100005
X-Stat-Signature: wdhn1mn6nmo5w481s7547upkmyxf9s3z
X-Rspam-User: 
X-HE-Tag: 1787514080-977342
X-HE-Meta: U2FsdGVkX1+WE1MGx+feSb0we8Kbap5AyytRcZpRT40AH+8oLiz5K3HKENARVU+1IybP9RpWRY3iiP8dBaoxoNtUfXmjYaEQ9zU2ggRCp4QcWTcLzY4hkKNc6SLOf24l2N6y57KgagFrPzIcJ9kn7Q7oHCTdYUsMIa2nRsHCIQSibmMKplkxkf8u3tkG7b1utVoAWVAFK0GVLK2m667jm6/yTEYQ3+G+CXo6Zj6dTxcXHbGOP8SqZvnArNNLhSY9WsxOH5c+HJPc/7upmBtyOLnFCqPwHrpeu5F+fp/BZuGr6iYfFumCmXU/5r51ehn0QSCYPwDfXSxEjPIMjW7WrOLTTlztqob7D7TKxxNS01c0UT+DWJtG+Pzu4xytOwUITwYqTe7yV3f9cejg8nCjXkznTKKEH4wlpu0ii8m1tCBvm7zbGnRHwpAu+CBFoRMGcKacS+OBRGQZ+Q2jXPMDWn/DtlolsOEW1/kTPrN8Zqkpz3bd9Pw1UShC8zg0q1lfzhLikgB/i/QFyRLeZ6FfYx2vued1emLUMzZr8XZURnh1nCeH4DnGw7hnrKCGyYoouxlgQUZ1EnFwBJnGVabfD7P7meV96JxuYBOKyCE4C992mBrC/lwslg9JPbHIWN+BXaU7WnqQ3cVxiVnUfj0dOgXleJw20xqmsH0YIhmzdkLo+HkQ3jQNtFw0dDHf70Hu3cRD5RDI+jwbwKjFbhLrVs6ZqTKgZ4hg6URjV21HTitILiiT9hyEPpp94+jhkLahNmUj+pYyDA93EuWtCrHqF6zexDASUoXnVPxrHYbMAsfNYRBfTWaBGA9S+DCUBNfyAVQIkm4MviCjrP9elfJXh3kUxvdm5Ux8y50dHDLZ1Skbm+5uLxGz8lSPg3qDdPBCUN6PcGsBPxmc+LqbJ0WMZ+mI6cY/nLFD+ZE3LCA5AGoRTo6EbESVVaiuSTNyMXvplovksVr8YXloeNgAMMQ
 hyguZpXf
 siw5grukSv8hOzGU5sOQptBf7F1lWWtlMsno0zeiQBNFPFAAzP3/lNIdMK7fkHctBmDYi65p2a8wb8/klzZMmdB8HaALFt01/sJXxG1rFId5KhiFSAsPnrGYuX2bsgBAAmXJcHcCflT6YKjPjwtNTeqTN78HW6Rb6zsCJtcFXQfT18Kwh8G0kOtot9KQAa++iO0fudRNJN0qTxHdRnGHXLlLzK+C6NHfFwgXbiMppiLSXjJfyopu0QNdoLoqj6XycZUIk/X7vhk1H2r+o+BNEm2Z3w5o5C8BMK1QZGEEgXe0gwDEzCurShPzDHWSxBS2TsNL0DRav+w4unvx+L3XD00fMZcNGUjDehM/P6oxmSrbnBi59UnXYPzlI4FCQc3WXBjzmt/ry1Z2WUr7aWDhpFcWtfJ2SzSYBW8V4mfHReokRvOrWhq3xJmPVTq91PoY9rnVc+nC6LHpEyVlRn9yeZ19Y75FE7irV2e2ArMiQJ6Upvb52iuo7y5HNKqkH8c8Q24BWYrqghw7ltC6sp2ckXz0iAhDkUfK5o8kmRHHSD0yZWwSGU15F07O2UYvjU+PCTOA8OuM6sTEtLzjSDLNzWv7QWc0nPfa+eb2Ev++oml1c8sLAx0MUg67dvD6TL/qZi4VyIoHz4zaDGt0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a shmem memory failure selftest to test the shmem memory failure is
correct after modifying shmem return value.

Specifically, test the expected behavior under various scenarios
combining page dirtiness (dirty vs clean) and failure types (hard vs
soft):
+ Dirty + Hard: Trigger a SIGBUS on injection, and trigger another
  SIGBUS when reading the page again.
+ Dirty + Soft: No SIGBUS is triggered, and the original value can be
  read successfully.
+ Clean + Hard: No SIGBUS is triggered on injection, but trigger a
  SIGBUS when trying to read the page again.
+ Clean + Soft: No SIGBUS is triggered, and the page can be read
  successfully.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 tools/testing/selftests/mm/memory-failure.c | 118 +++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
index 1a5a32e22cce..5b26f0c44664 100644
--- a/tools/testing/selftests/mm/memory-failure.c
+++ b/tools/testing/selftests/mm/memory-failure.c
@@ -20,6 +20,10 @@
 
 #include "vm_util.h"
 
+#ifndef fallthrough
+# define fallthrough __attribute__((__fallthrough__))
+#endif
+
 enum inject_type {
 	MADV_HARD,
 	MADV_SOFT,
@@ -29,9 +33,14 @@ enum result_type {
 	MADV_HARD_ANON,
 	MADV_HARD_CLEAN_PAGECACHE,
 	MADV_HARD_DIRTY_PAGECACHE,
+	MADV_HARD_CLEAN_SHMEM,
+	MADV_HARD_DIRTY_SHMEM,
 	MADV_SOFT_ANON,
 	MADV_SOFT_CLEAN_PAGECACHE,
 	MADV_SOFT_DIRTY_PAGECACHE,
+	MADV_SOFT_CLEAN_SHMEM,
+	MADV_SOFT_DIRTY_SHMEM,
+	READ_ERROR,
 };
 
 static jmp_buf signal_jmp_buf;
@@ -157,17 +166,22 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
 	case MADV_HARD_CLEAN_PAGECACHE:
 	case MADV_SOFT_CLEAN_PAGECACHE:
 	case MADV_SOFT_DIRTY_PAGECACHE:
-		/* It is not expected to receive a SIGBUS signal. */
-		ASSERT_EQ(setjmp, 0);
-
+	case MADV_SOFT_DIRTY_SHMEM:
 		/* The page content should remain unchanged. */
 		ASSERT_TRUE(check_memory(vaddr, self->page_size));
+		fallthrough;
+	case MADV_HARD_CLEAN_SHMEM:
+	case MADV_SOFT_CLEAN_SHMEM:
+		/* It is not expected to receive a SIGBUS signal. */
+		ASSERT_EQ(setjmp, 0);
 
 		/* The backing pfn of addr should have changed. */
 		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
 		break;
 	case MADV_HARD_ANON:
 	case MADV_HARD_DIRTY_PAGECACHE:
+	case MADV_HARD_DIRTY_SHMEM:
+	case READ_ERROR:
 		/* The SIGBUS signal should have been received. */
 		ASSERT_EQ(setjmp, 1);
 
@@ -263,6 +277,20 @@ static int prepare_file(const char *fname, unsigned long size)
 	return fd;
 }
 
+static int prepare_shmem(const char *fname, unsigned long size)
+{
+	int fd;
+
+	fd = memfd_create(fname, 0);
+	if (fd < 0)
+		return -1;
+	if (ftruncate(fd, size) < 0) {
+		close(fd);
+		return -1;
+	}
+	return fd;
+}
+
 /* Borrowed from mm/gup_longterm.c. */
 static int get_fs_type(int fd)
 {
@@ -355,4 +383,88 @@ TEST_F(memory_failure, dirty_pagecache)
 	ASSERT_EQ(close(fd), 0);
 }
 
+TEST_F(memory_failure, dirty_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	memset(addr, 0xce, self->page_size);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!ret && !self->injection_attempted) {
+		self->injection_attempted = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+	}
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		check(_metadata, self, addr, MADV_SOFT_DIRTY_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
+TEST_F(memory_failure, clean_shmem)
+{
+	int fd;
+	char *addr;
+	int ret;
+
+	fd = prepare_shmem("shmem-file", self->page_size);
+	if (fd < 0)
+		SKIP(return, "failed to open test shmem-file.\n");
+
+	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
+		    MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		close(fd);
+		SKIP(return, "mmap failed, not enough memory.\n");
+	}
+	FORCE_READ(*addr);
+
+	prepare(_metadata, self, addr);
+
+	ret = sigsetjmp(signal_jmp_buf, 1);
+	if (!ret && !self->injection_attempted) {
+		self->injection_attempted = true;
+		ASSERT_EQ(variant->inject(self, addr), 0);
+	}
+
+	if (variant->type == MADV_HARD) {
+		check(_metadata, self, addr, MADV_HARD_CLEAN_SHMEM, ret);
+		ret = sigsetjmp(signal_jmp_buf, 1);
+		if (ret == 0)
+			FORCE_READ(*addr);
+		check(_metadata, self, addr, READ_ERROR, ret);
+	} else {
+		/* Test the address accessability without check_memory(). */
+		FORCE_READ(*addr);
+		check(_metadata, self, addr, MADV_SOFT_CLEAN_SHMEM, ret);
+	}
+
+	ASSERT_EQ(munmap(addr, self->page_size), 0);
+
+	ASSERT_EQ(close(fd), 0);
+}
+
 TEST_HARNESS_MAIN

-- 
2.55.0.766.g2966f0265a-goog


