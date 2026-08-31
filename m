Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9BEC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55F976B00BD; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9B56B00C0; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A706B00BF; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 081966B00BD
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86147802D3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:43 +0000 (UTC)
X-FDA: 85159671366.12.55C788E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7FF7B20002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPTQ+t1u;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135941;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=391D77O5sTl7HWhcSg+TE9/TyX8AIQWuTRLSAn+PWQw=;
	b=xU0Xjd1lCvRNBVMw5YdnBDTQHMtowkA6WvercUGzpNDH0JR3vrB1/qjIJb1NsiUiJ2HpaU
	pHiUiUnvdp/txwR+NNRWpDkbRoyGPJb3dS5pKdF50PCxM+i6dTOH92VGjg/1JSyMzkpq4T
	Ul5/s9nHNH5ldmTv4fyVrzs3L2cE3BY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135941;
	b=l0fhNJXV8PErcVl4ryhTS0uFxsUZ9P6q6vz1RYCPY3NOqe4zJ1/e+GWNkjfoLLag58K0p+
	EPI5vbWyyrDqI8oUMl22rYmAnmm1wda9Q/wDz9iFhMHQLCyxzdvMKVeAnEAdILQ5KQiaHO
	o2sz++isCI6VyUVakGJEQRz0yF3ghwY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPTQ+t1u;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDBAD4477F;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 74CBCC4AF0D;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=L5YUbh7/6Cud6VplfoNsOCErNzDbpKzPkXGdi+gnbdU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bPTQ+t1u1KJjMEQTfYicl1vmRbZYLA+VOfQu93BZwsXWbldiwg6PNm30qHe0W10K0
	 XtCa9z6HDK8A5k1txAJpJL58AlHLyAbmczeQ/IpK9XpD6lIr2kzcHefew4QTc5BA88
	 iMDUhwUuI2EL9SEMLGlKffIEEJth7aLvjv2DGcPxEIdq8mDIK4UyFpvM6ZpyWqMrys
	 OvbqhqLr7XXtMTr5UFO7JxdaMUp1M+lcM5bMovKgq/lgGcTFj9M0vUGLOiA6ESK0m7
	 sKIoxphgrKi/QDY1hKD5ebCMyEvYt2uuX6DixiqQZQMIxUZyiKfE6ZyzfJv+zI1FQH
	 JSTusVRdWlHdQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55FB9C624A5;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:38 -0700
Subject: [PATCH v12 37/45] KVM: selftests: Add helpers to pin pages with
 CONFIG_GUP_TEST
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-37-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=2738;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=kIKJvxj0NxcBPACHPOvZ7iTswFnwraQaYm+ccyn/5BU=;
 b=rGCmlwIzORjmkoJ/SJOyYoV95Ir/p5lCBR7+rCAJ4+Z6RA7bgx6OE8YI2QhKLVx8Bf7niBqyg
 E+q8HPCVsK9A9d7RM04XRCGr5I32p1B80Sh8qYZ73BetOSxApsH5i8U
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: tn7jkawyootmsjrpa5bcesnk89m6dts9
X-Rspamd-Queue-Id: 7FF7B20002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135941-116534
X-HE-Meta: U2FsdGVkX18b5uzEfwHFldAdiZ31UpdIJyfVJe+gAWsUoiqgPoBVKMpsy0sOi5IdrqipV06ye5ov5jbp24eFxi8tg+lXvNJIUl3Zvuz97eWVlR3AIQgVIN08DUlDkez5NCldRgpdI/KYeHCM8zfjnQPqevwBZIWiHoZw1ikUN7G999xlAPPxfYx0Y52Zla3O0qb+GFrzhnxSpGzYU/yDbeYqy8+CRV/IMxl9yNH+rAxbmxfTsk5V760HLVR9abXJ7KRSzRDP3N8Was7DoG15V3oxmtx/HQiNft6+bKzzjlfcDPh8u0qppCjzmXRGxflRTg7Ereeu6MOY1YgxQuEgcbgOGTtLQF/ZZ5JwG1bAH9KVvvX+pFX6Yt7UZerALG1QUWPuzpkrl+xN88pnwLuKth/CriJAsS0ShPqfVlmR5rWrY5ec6YbH1tl7RwTrlyrH7nzGQ+a3XzV8h6/pb9kf8/hOqNoi688794Q8f8pexh82DhRcssxT8h6pG21FiAoQChQJOpcjOa+NgJ61RTyo0VLrpdDWCsfdLKBUNebwi8fbXpv0DSO9cIVJA8ywdLkbPTYKHf3WJntrjNR0fBZYv63qeySaOIrJIxWkB/mdWSxK6RYpT8Q6z/h1PXCaT4wvHQuAcG16zmLMT8a2BftP4vBxW1uChDLUGnJd1nVRNHMA3wVNrdObbysUoLOM5Q8hPo/0tZw4TbngxgYwSascTTUylOuAtiY7qGKVuEbVraNaFypNldzQsRrpNwOBFVEu0IX7rbu8N2hyo2gAP8muNBdaFhKN64FGS3pcb8v2A8TF0wjiztP54XazN4ZAp4Km7VA/FpGIbQNknwY5JVDeEVddCS7NePhaZZ+bTE31b5vOz7mhZ/SGcch5EiRYE57ojKgLnV7VYAzQA1bLte4sq+UeZwUxILTmD7EF9IelbRiN/vH0rwGQyrnzmVJAaSOM9uJKVNs/rqUoUZXZ+AV
 CBCmmhIt
 mJ3zN/2dtV2XmMUceDMGM/TJ7tOUtQJxjACCGhHdLXfDPMbzJNKO2yyPvLufncAd+MV9bbtrOgpjIPLJFbBbPV3lTyeSTxLrzygqKw8A/7WD1UYTbZGfg7fKy2gAPoENzg+CcL/1+dKaqp5V1Vr5r2m1X4dgZvEgdFGINiOozh5VvHmRAp0KljkEIBctYpe64+47uUxDw2iY/qoc+VeRVv5r9ehmf1qonxReLAoKZJYftRndpECjR/AY3BNjKohVug1648PG13L/OLa4uv1z32Nuu4WsYZmJfuPmkQ9g+9mN0HPSgrb6ZiBLVqfWBJuuiHCqQtC42ADeUIlhaVKT8Omn6eUBgwaEHGFTI10OlI2S/w5glV0YqarXIzfu+tVFcQeajewG+ZYw/YBHSCjbLA+MHpjzkLYov3rtcZ+0PhJg3ALA1HB1GuKC5QERokfW/dhsN8Fy/1apnqriWUUJwvfp88l88MNiqAun86c//VPHJ4JuNO47Vt84Typt62I4XQU/dceZgTd4SXY297YbmQ6jZjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add helper functions to allow KVM selftests to pin memory using
CONFIG_GUP_TEST. This is useful for creating test scenarios where some page
has an increased refcount, such as when testing guest_memfd in-place
conversion.

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
2.55.0.897.gb25b4bd76c-goog



