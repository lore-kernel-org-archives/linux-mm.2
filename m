Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C85C5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2FD6B00E5; Fri,  7 Aug 2026 17:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163EF6B00E7; Fri,  7 Aug 2026 17:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B5E6B00E8; Fri,  7 Aug 2026 17:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA5876B00E5
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53B3712015C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:06 +0000 (UTC)
X-FDA: 85075824372.17.C795287
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FAD0A000B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HmySTGsR;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139584;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzqyr8Bqzylq5ycJZPTK7rEDfxof/tindt7JeSANBq4=;
	b=ym7/Cw1P1eaGszMoq9LNYujovOR/otAOPvntWC2Ajvkkl93ttdrnF9Q2xQ4ohOQYK35JQW
	I6yELIC+Q23jm/zj8MEHF5XQTJ0OkQJtX0LTQRXcnurFybvQMHFtL5faLU6RC11N4qwFYA
	/9FY6+gDi8nfYIZ/UV93wxv4xaogJlI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HmySTGsR;
	spf=pass (imf15.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139584;
	b=Mj44PZhGue9k5pfseWR//L3UKFdCNFwvAlyl6OJsrj/luzzi5O/T7zOvtkYJIbInSoXQRE
	CgUrH6iZq8ctYRxxn5tuUJat5g0hezgixVC0S8/TzkZgdP1xlnLOugLQ9ZRHy0UUjWX8ny
	ie0Sg7XcWy4lPQC3lKVwlSQ3Mt/cNXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6315E4528C;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D01DC4AF16;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=ja9kgTXKp8MbX00Y/A8nmdYFnNNk9zdQafFLcm0bclI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HmySTGsRTcnihovYOPx1lxO/Ls40k2h2IAJ8TQlBfnR9z2KNBGwixBjawbcMG0bNe
	 Nd2Hvy+1nGRU1kOymNzytkzJWDQMCeNg5uavp1EM4X9GcP7g4cjMkxhRPslm8uk2NZ
	 oPUN3j52wuvWdDdzzs9+nfsWSqNAVZ7wk38M3BcCcku/aQ4KqKobwO1jaruiRKUPOM
	 2f3VGcaML/YTvl7V3xS9mKZwPp6nEkB22BmmBCNKGE+wsZdLv3bD1Ja4QzBUEsXPYt
	 rH4eObflxWbB6/dWi+63V/R81A9ClRBtmQag1sxc3Lku8ndkJq+uyZ+k1JA0YzxXVp
	 Dz3lMN6HSmDyQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01091C5ACDC;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:13 -0700
Subject: [PATCH v10 34/41] KVM: selftests: Add helpers to pin pages with
 CONFIG_GUP_TEST
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-34-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2727;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hcW1DlqCdnSzmI45o3LcgBosQ7tTRCZf45DfrB9G7us=;
 b=D/7W5Lg+H24nvcVwXqYHutKeJIxMyV63gfZOGX1T6+gdFLZZ9D28ih82o1BmY8o8nFoq89D/n
 K2P0seUgnSjCPz3zEhqVM2qdMNqrM3HR/dEYV4zwyHiGOF6w0Es1Ifb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FAD0A000B
X-Stat-Signature: msy46p3kwzwficjpcw6ureuz35nb7qfy
X-HE-Tag: 1786139584-714224
X-HE-Meta: U2FsdGVkX19QPcYetLvkaQxtIKakIJSn5DCa+g7UlcpgEjt4ZFxcnwv988hA3dQejZuHeNTIhbtg4+ffKaBagcmtDi7XDTlQVYzSBIDMvDHKWmPPub8z/TzKFYdwDr8DONDV2gthkEGF1n5ZwtMH4T3xd2WRBzG0Fs55aZmCANjs4MmV+A5lMWPU1ytRBLzD4mDMQk/FL90ZD++MsrVVVK3jqNaLnxVqnje0ZVH5tA+DwOhlCVd722sQCWWsyBmpjWiZgT9fUmZPAtN3kq3GambmK4oQezcGFpmPibXtvHeI1CNxI+hWeHV8ZpTtyhd8NnKD5bYqM/t4CXgEFKHR/hTAdr1Dzue6poSCjaWrCtmm8AkoVUtV+CKZ8Oar91QjStytkX2gihQPqG1COlhsTiVARKRRm84/Y6eobgINTDSMF1NC206QYWo8pDZn+pq909xITDtq0rlaVAEh6Y5FdAJVrbWHjlNCDBS0kmHPqkZ/73kMXBNj1ZlFlCQsSQ/6vrQ1QZSIJ1I9LTO0hBA1TPRftcHbkMFHr52XO/s+jCFUKP5UDl/JMpZeBTBNCy+F0pecA0V67lP0zZCZoIcuSRME5wjA/gpIbLL9jevqGtqH9ZP52iUVMpVsmfu8TPWsdCK8IHxK74mcXpOgIekP7IZhzL9SMwJvt6XCJiFhswW3QWsv3J9nTM/cjXann8AVEyR54ibsG+Yv7DyOCivsNqR+YiMk6Pf8jfnfeqp/1BcrF7vAmpYMKtSkhsNNgP4HycL9BxOiIMdz5ITyb1D8zSxj6ls8o7xRocPps/FVUau2tNwEQlXgMM8DcRvC4HaDAnFzD+NFkW1/4Eltfx/rZULa+o672wmC4KMNyQsYn3vyH3uIGp+fev4xbtdfo3bhrU6mOxpu/yPAGAV9hEskvPoh/51BudOATKw1Qdyc3H7lXqWcsFl3CmeZ0aBdXYMx8MmB9CfyaS+Awrcza9n
 ueWnLtp4
 iHr0m8CEMNgvloTHJ6oRCIf6mpmTwAvQcgRMEt66iMzzXH1Z8kgYSs/wJ7aonv5UBSKfWwUxT7XToB6sXN3rpyKxNM6+dAXW3b/GMz30AV+8LNnWPO+vO8gqojfFYKnpQ8HxV3vnpx+3ClJar/mRWfxcKctaw+rrLRg3gDDBYUBXEvPNin6RvcmTHXzVN9Q6XGwwgEjQffn4AI09qiN4NQdPc4yyGR+4v0Lpgwqhg8S5V90Qu02g0lIRR/o05+a33Pf0cem5AFoNjWyFb/ugIHWLfig57Ro4fJ+fPXEGAmt4ba40djPbOcr93m0kOSf5lsBa3nj5r4U/jeozfwAcFU1Qm3xsnw7ECNsdYpOJM4VJW9SgeBeb6AX2y0SSsVjGBZOCSrsXJAm3zcEmNmknKdNBam9h57ic5B7U9u/rEUlCd6sIQ22XFl/OUwLtvfPROwRmb4Tyh+B/C7mhNyhQvBezuLhDLF0pBeMecTQQek+fUhca3naOsx977QJRHmcYP5NLbR0cxXWIomTR8dUjDWF0X5rG1GzsSfat8Hjp53cHP3v9Yx+wQU4ZI7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add helper functions to allow KVM selftests to pin memory using
CONFIG_GUP_TEST. This is useful for testing scenarios where some page has
an increased refcount. such as in guest_memfd in-place conversion tests.

The helpers open /sys/kernel/debug/gup_test and invoke the
PIN_LONGTERM_TEST_START and PIN_LONGTERM_TEST_STOP ioctls. Since this
functionality depends on the kernel being built with CONFIG_GUP_TEST,
provide stub implementations that trigger a test failure if the
configuration is missing.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 575032e9791d2..3cfe243d7c8b0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1206,6 +1206,9 @@ static inline int pin_self_to_any_cpu(void)
 	return pin_task_to_any_cpu(pthread_self());
 }
 
+void pin_pages(void *vaddr, uint64_t size);
+void unpin_pages(void);
+
 void kvm_print_vcpu_pinning_help(void);
 void kvm_parse_vcpu_pinning(const char *pcpus_string, u32 vcpu_to_pcpu[],
 			    int nr_vcpus);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index cd468b2bb8343..b1456ed76e27e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -19,6 +19,8 @@
 #include <unistd.h>
 #include <linux/kernel.h>
 
+#include "../../../../../mm/gup_test.h"
+
 #define KVM_UTIL_MIN_PFN	2
 
 u32 kvm_random_seed;
@@ -645,6 +647,29 @@ int __pin_task_to_cpu(pthread_t task, int cpu)
 	return pthread_setaffinity_np(task, sizeof(cpuset), &cpuset);
 }
 
+static int gup_test_fd = -1;
+
+void pin_pages(void *vaddr, uint64_t size)
+{
+	const struct pin_longterm_test args = {
+		.addr = (uint64_t)vaddr,
+		.size = size,
+		.flags = PIN_LONGTERM_TEST_FLAG_USE_WRITE,
+	};
+
+	gup_test_fd = __open_path_or_exit("/sys/kernel/debug/gup_test", O_RDWR,
+					  "Is CONFIG_GUP_TEST enabled?");
+
+	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_START, &args), 0);
+}
+
+void unpin_pages(void)
+{
+	TEST_ASSERT_EQ(ioctl(gup_test_fd, PIN_LONGTERM_TEST_STOP), 0);
+
+	kvm_free_fd(gup_test_fd);
+}
+
 static u32 parse_pcpu(const char *cpu_str, const cpu_set_t *allowed_mask)
 {
 	u32 pcpu = atoi_non_negative("CPU number", cpu_str);

-- 
2.55.0.654.g21b8a5bc05-goog



