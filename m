Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05E23C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933B86B00BA; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90AFA6B00BB; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ACBE6B00BC; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51C876B00BA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF6841C0DEE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:24 +0000 (UTC)
X-FDA: 85039945368.17.3A26654
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 04CC140003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OR7QxTZe;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285323;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2u7ocU56NIX50UzDNxhWu/TAU1TsaJcHs/roJM14eaA=;
	b=1l67BcOkrM+ywdjq9M3uK2ChuI+mwOVmk0+N6Z1IdJL8P7mKr3HrczGJyzmfRy+CNhzF8p
	wNMAr95OXm+15G3DAS4CMC8ajE4lEhlzj9+Ig2wyDZjJOWg0vE4WYH6en0sS627jQA842y
	fQo9s/txRDOQjqt2FSq9kKHLT4nsnoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285323;
	b=vqwq3LzUx8pBqt8ucaMpcrqFIxdNrh8/jtYaEINL+1BBVyl/C1HItPFSknaK/gnfaAVtZz
	O9vafVmwE72lClq2ioPo3qstF1aG7qK3TSHLvR2j/Ac9MDrk7j4z9+2S7WMzlb8kftYd4h
	Cy57P6ctOa/R+D0prSTH4AlnpoAp3ok=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OR7QxTZe;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E6C2145302;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7211C2BCFD;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=ee+k0gLRIeOZJUzHjO+ZbWO7XbmvclzhozNvKeyrbGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OR7QxTZeB8cLZAL8piDxH5E3w3Py9EtcLMUC4/KODO6/KDSA+wUidbU5Yk/nPck1Y
	 qFUCfQL2+qh9Ub4gruqAJyB8FifZCZ1zXaInhnFfymvxpFdXMTyUws0dYVN0ZI5ZV0
	 JILKrluTFgUhkuDMOHYaj9k+4MxEnT7aPLfR5JTb/IFfwKNhYKvqfeW1ET7cRGkloE
	 BodlBBGdV5EwVf/FWpQmygM0I2yNISlyzOPJJzo6QjzmJadBFq+64BlR4wUgn2c4aP
	 zjJ67Gdw8qjh3IlHzgT3Utv/AOvaceW72M+mgAuahl4U9bojhzOeH71ihdInSqmhFQ
	 ZzX3/1CK/U2MQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A088C54F52;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:33 -0700
Subject: [PATCH v9 34/41] KVM: selftests: Add helpers to pin pages with
 CONFIG_GUP_TEST
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-34-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2727;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=fMGRLXRDe9ewbqPURje2qeKCNAQagU823U8K9a0Ohls=;
 b=M0kLKLw+slgjihad6M2qkRHDlEJzV5uijRgDG/1KOFYV34CKq+mVkd2roLDanEtYk9Q1949d6
 YIoh1s1Ou5oDCLYuiAW1u5k5SqByblCRE089lYADsuuVCxWin4B8Tro
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 04CC140003
X-Stat-Signature: k5utopjtzr4x3hmujuid7q8z7oqdt4fn
X-HE-Tag: 1785285322-925476
X-HE-Meta: U2FsdGVkX1/SCsHceYFx6AHngrTn+IwNBb3LrZDjz/MmMbbK4RJvWCfnWPam+YtBQReywmHdnR/Sgq/Lt6xhcedzBfYkZob0cQRcn+mELPIHNPnFV6Yy7VgkUeZXbBlMVjY8TXRoOE3taS6FKCzc7EciSIrsNTSi0KbiOWxdPE6fIjank6Qgdsjqyv6agFvv/aVOevubDKrAknuNHNgXaciNn9CouxuA9KpBD4/v2x1JZKp/Vl44hnB4n88SY7zVWwuVvKhjwKfa4CzSY5arFm80p9G3hTBSV8UK91XLc72JCtfH5xmSqK+D457TpdxRbboApOZgeEkiw21o0LjvDAxcj+rBkKTOoakQCwGSX9M+NTSAHWLIPfu9Xo1MUKG8YNPMJzjNC1R9XWUVqSY1r0+Cad8XSq3R6aMvPsZEfn0E1iDKG1xoCbXOyCj46XSnQxvpx4eW0SLeD/DEis7RDVr0PKcrrRXiv0sPzADWQowK4e39siEcy7ZZmFREQa95JLRa3Kw4PVtZmw7CKsH6POL9NOmgsZBz+fOM9I42i5wNyS0DxPRNlh+pWayBnvoJaZpp86r4q9DBwMoJdUFy6CuHYuubVGXkOh0XfwmYE8VWwsWbj3IpNnaeLF2Oh9VtVoXOWODG84HJroPmY8UJwkdj22Mo6zXAx12zmQFueCIJ4PyPrJGOOdhAe3+9SwpkXjcU71bUAty3U2p/RkLEA7KI3tSwp83aEGJmnlRHY0SCMF3H5pQmG1LUmvXvMYjg5jYFzckQT60DVkxUgGQX5PNaH1W0JjsRI9IneE8ve6AaB7IOOkXiizA++41qBFAvYIWH1e9VadDpqeqKEfc31392JclY4jDRmsNd8QMMGqlj7/9XIwNHBcfTK599F4NxfSwAmAEHYy45WMxPxlHnso6z/JG/71aYgugwEpVv838JDxQdnpjxS46ZwXIh7ZuigNrRmkWwembstvnAoit
 ipsDCUSe
 H4o8h5GaaIWJyhPI3j1Z5byl7uH0snplzRXV84Bz+jJPBGlIZNFQ/e9VfKY9eBJ7m8A05dz4twPlym7nQFcX6tlKFzpdavIY8obuwnil62m0dfFnv1eiIl4rcjDwwtcfTs46bsvQ5x8BU5tvjDaf1kRkLUQMoATJC29cJjPi5BztlwqENWgUylecSAQT7ZwMDHgS19hBJQGWuAH/gg5+LX6zHCjh4Z1lpBjOKF+f1KIRTEDS9b130UfV4pBDLA4PCePjdcLr+tDubZnDstEBe5W4TaPN80osv+Jj7C8ERuRP2pNSYQcLC9isHRYtUAGTQ1hUzIo+e6PfJZdaY1p2+Zz19j6bLTRSt/f6K63WaAbCM3jMNkY/Ono1nVj3Ewd1ggBr7TnMraHdulxuVvXpou0aS39GMb4moIuxYQW0swsyave4nD9fMwpkY+OX5E54SLegY2ScD6pH6wEAnzGPNh+5GyRPzmitHtq2I/C9QX9Cb6UTPG9D0w/ZnxzNYB+sWnIfUgE32bZO+gLmx/6E7Qo43B/koAg9iAkLu+mfZrDxXQPj2+OV1A+Nq6+lyIIyCC4iw
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
index 626c960b4bb82..b726e49a3cfcf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1197,6 +1197,9 @@ static inline int pin_self_to_any_cpu(void)
 	return pin_task_to_any_cpu(pthread_self());
 }
 
+void pin_pages(void *vaddr, uint64_t size);
+void unpin_pages(void);
+
 void kvm_print_vcpu_pinning_help(void);
 void kvm_parse_vcpu_pinning(const char *pcpus_string, u32 vcpu_to_pcpu[],
 			    int nr_vcpus);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e706669596947..ae0d7ff13f9f5 100644
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
2.55.0.508.g3f0d502094-goog



