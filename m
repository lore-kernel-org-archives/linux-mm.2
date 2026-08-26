Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11ADBC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE0A6B00C4; Wed, 26 Aug 2026 05:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D472A6B00C5; Wed, 26 Aug 2026 05:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B99DA6B00C6; Wed, 26 Aug 2026 05:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 843E26B00C4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 068EAA372B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:14 +0000 (UTC)
X-FDA: 85142871828.05.7FB33E6
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id 372464000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YwuDdPJ2;
	spf=pass (imf01.hostedemail.com: domain of 3jq-OagsKCIMhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3jq-OagsKCIMhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735952;
	b=gQJJqxa0A9Zrp14vytSMFNefyhft4wpguAB6kf5aXe6q0G1qBWiuXuVzj1f8a11aOCmAgt
	QL7uGb9HTZPhCn1fx0ZmEIbBUeYXoLY2qqBOr/NKZuUOrlgkfEpH60Ypt1Bgn47dy2Nskp
	YqALUoc/HWuOmuCZeT8LWF3yk4D6rAs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YwuDdPJ2;
	spf=pass (imf01.hostedemail.com: domain of 3jq-OagsKCIMhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3jq-OagsKCIMhjrlysl50unnvvnsl.jvtspu14-ttr2hjr.vyn@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7znZB4+fu5SSeJJtVXjdDiNwNEk+mtdzszQFSpw4D4=;
	b=ehrKVJ57AF9BcIwyMSQYbDX4UbpxX7YxbOX+uVk8/tc2H88GmzkSXg/kfCnCBY83q0oabC
	CFENDE9XW3Ko/mnOiBtLfbH+V9Q7cSOL5E50AXBvTLc9gw7m2f3EKpf/sB8L0o7EWDt3OD
	ULk94lZIe4yS2uXgnYMAfsdh62CwJtU=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d04908139bso12136775ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735951; x=1788340751; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L7znZB4+fu5SSeJJtVXjdDiNwNEk+mtdzszQFSpw4D4=;
        b=YwuDdPJ2yUUG90w7oGLabbUuWnbHwWeJDe7BQn/GWVSJwzX2RXQvRwfokq/7jd0QX3
         qORcZxnZyhgapIYcnbCrXakrqPvFX08RXLij+/azawQSOMwsJSpy5w/3MbFBRUcCz7uZ
         JJJoPpjR4rzhX3eAii4wFAKr9qAk4WEBXh+c6wvRrMexYBULO/YoOkZcwcTyxcQ92bYP
         oyqGexf4MmEX9Z+ed4jC9lutOVX2zmlD15N58lmCoZ8yiDNRC+wCjrCafHK2RcuuG0u1
         4pOuIOJwWPuAHD8V261xJ6Me9Qo5bXyHDNzRjVMZJ7ukbCxtOaOoSWVmuiDV1iUJv85u
         DCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735951; x=1788340751;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L7znZB4+fu5SSeJJtVXjdDiNwNEk+mtdzszQFSpw4D4=;
        b=NQYiO1Lu0dBvcvYehxWvolLte8ouyVEKKPPuctEmkWahCU28bgCSI+6hw+v3QIJelX
         Jyk1FxcwG8rC31d7QkrZ0XfVwntg00LTKkrMWbCiZv31V2biZQU27rUwsrp3rPaUbXcj
         u0ubcj+quTc+O0Sb8wMZ7LjH+bH06NaYPWNU9HWDXe0dyuBjFGei27u0+ZNSCsLuuPt8
         4yJAz6Rv9nHAs4K6FpvQeeXxg2Ufjf9bz7d7wRwqmth4zG9RnuUsy/0u0qVkz2JTg8Ak
         vtPqTuAflk52BaQde9pV23GT7h9DcXKidj27w38QNvfhXP+KomOcw3tid4HmQqlivpFT
         SBrQ==
X-Forwarded-Encrypted: i=1; AHgh+RrI5/xjVckVJ/mIJSiUte06A5Xl4daXB+E+++ePfPN9yZZAZm3CsNBGGy6EQxxaCRCGX3iY7BfDAA==@kvack.org
X-Gm-Message-State: AFuF++ky2o+2jcSlc5+ZtyLKANKmc78/HGNbNRiipbfykzH9i0opgJGq
	Cszpxl2qqoqNWw4iXipfzxKftaYEbGG33iEVIa0MRIFxvZEd/TIEdZ57rdjBG5+c/Xp8bR0TQ1I
	OHYLkDOebknjUH0kJutAu9X7onA==
X-Received: from plbkb13.prod.google.com ([2002:a17:903:338d:b0:2d3:768a:b66c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e550:b0:2ca:1479:d9dc with SMTP id d9443c01a7336-2d707b64aecmr85060725ad.12.1787735950795;
 Wed, 26 Aug 2026 02:19:10 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:35 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2738;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=oKhUk7AQ/XVnJUDFQGQ0T3PCQ/fs9vSttvSiNTvu8TA=; b=E3s7CyKmuQ7u5Mqr0j0RmOVbgjxJwnqa6vu50TWR1xpcdjjO+0Nj9vghzwKHhtDd1aD8uPwMQ
 5K1FBJ/M+TkCu5I+2+SMQWquWdJ3o1KIoWaNX0et7JTlybJ0RWLUVFk
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-37-0a15d8a799aa@google.com>
Subject: [PATCH v11 37/46] KVM: selftests: Add helpers to pin pages with CONFIG_GUP_TEST
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 6ewwxxpd7abyki7jhywsuant77sue8kq
X-Rspamd-Queue-Id: 372464000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1787735952-995160
X-HE-Meta: U2FsdGVkX1+uDWqJ2tkbnPNaeWfvr/nlmy57q0Q2L6PKUKPrVBcXdnnWuCMtPNFYeOZsm8mdXZclVfFsCzfRkBk0KNlNWkgYC62MeYxa9lDbs4lypK6eAtATIfVUZ88ovSMxcVzc8lPCTOG9N4xu0RFEL58br5YxMjaj8iQhUXr+K2eMXWl0sjp8t6Rx+dvd/7Y5GEGWJnvO5hZvRbsB9fYRtAMA29dlBRy5RAd8ht0oYbiaiqm22/E6T0r2Z7Kj+zSji8IpGaAMD42wCyP8Lq0nSYcqthkAvRKAL7Y6QKXdqOuuQDUi823kO8chOQhfputTvf+/tffAYp3xh3HQgdAhSAqtZaWsWZI0RIwuKWyOsSIiqg6VML1+6tP3wEOeoi5tjemeWea7gxkbBxhds6upQT5zvyHf4A77gv0+Vv3hg3tM9gj3p/ioPh10zJT9ia0+wHJZAiRPNYwHogdy3HkWWSIxfaUduW1Dmdu0Q9hNA6pyTTRhmjLgeu3EQQENA9AgXqbWCUHontM6rrJnQFuRIWJrOL8z1J+RleKfNEG+RJt9IQOv7Ix3X+mOTwgqXwAuTVHyP4c5GUZeHo9ZkA+Rkiw70SgLqkKUQGY4tPGmQBZbnR3MGoIJtylDOGinK77naht3EPGRzfokrXjlk/lcsXXWXnZMYH5fJqLTgUx/AfgKRfs1dUz1lIYm4PmV2VVCKcibQvm5FXh/88tHyOeiIK2x4gBP73MiseG/D77qF8Vp/pT7Ru3H5328dfaSGgBdClMCaomQAOa7QtMmlco6qWjEPQ96g34KGnkEe3CBjMkFxq1KQw0eenpCdPQsFx6dNhBrUCB0rwbtAWZbZGRnRPlrcJynaLG1HBuvq/lWK9FNhHi+sqSHfpRC8dQcNewC7qFhfKmCHDmWWM4vVRNHs0BbrdhVpid4xALi4xCP7XNx06Dfa99EITiR3hyrtNXLbfwMZpMaWdZpXek
 6g2SHtkb
 8iuPjv+RtJujp9dvfTYO/tg0sspNrwRwnw9Cmk13gHCp5yAA7KuMUuFb4iBjcwkajJtXOZf9nTC+atVPv/Nd+SYRfDLCdPCbj20cU2oyxykpn5DkNpwhaISV4B4dAkVv5yAIBUPCt4OvZVb+3XX61wnxYr8ISoZ+9fBFM4f+lHzpRjLYCISN8IkAe8JyYJxv+bU2grPorosd9MTKwdssMRo3yaZ9fG1XkgFuJ8VBukD/zEXT1neeL0BN3Gl9qjeXwi+7rp8rOybLtHHTAlpc5uXmU2Iclrk4On75/QsH3RUQRUrbV8fgXkR7mk12do+oxEgOAcnV+Q1nl+GHvu0YwqUZx1Xorr6Ozu3UkeroO+G6U0XmHapE0vGs6Bz1/RCcisaWKsjuX1uYSljVnkrYERUh9U2zrAGsZcwjXtKVTnZslfFYHriKmyzNQar10vDmIRS8A44go0XXEZXzqWwcgufjaYZG7nahqKiDieByaxdrq3UgsnG/+A+fhT6Y0imcl2mskVl+vfaHLYelQMTZQdZbJrku7xdev2XzynWPGRLPRs14ZqqpCKne12mJTDtO/XUC0llRc4rrJcwcJyoLZhQJ/3figsbNJWCunaoJQTWQS9f3++lRTgN9A74+Ge8tXSpyh0Y1zRwjLk1Y1Z7ikovOEBizo1nBc4zmCjUb9zLu6YkC/0XqdqXMzP+Vh1fd8Z49u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.55.0.887.g758fc8c411-goog


