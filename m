Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666FBC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3F966B00D2; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16E46B00D3; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07056B00D4; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73D896B00D2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBC48805EE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:54 +0000 (UTC)
X-FDA: 85199513028.02.8C0AEE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D357240002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0Qqx7kW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084553;
	b=AO//WWk+mu9PeC4dE1dXmL9/B0N2IVfXe3Kpfw5hyE1MPz84hMgDKrcySQ/blBSVm6cjVK
	i9O1dzuqUkfdopPSumgYq+fqrTdpnYBGOki2KH/aGXPOObsSZz6M4vx10oSGUiUwRetNfz
	jvkqf+E7QcbuQY21kLa1SzNhvgO8Wlg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0Qqx7kW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084553;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHnkmd8di0Fj7HvKNuBcSA1VEgayipSPMZW7VTItomw=;
	b=WM3CU1dn3vwEzCUyicgEl+bfGEvOwh5o34nPWuv2XcVAgHLhM6zdD7jvAWAw1SMUxKz7mF
	b6rBcWwiTBeHBx6ehfMl1gZ5VNWRE1OXIoIBMt1swH/oFFqOV7WmjwcVuYc37XsJ6IvBS4
	m2YYfiKd446C4kBd/9NPiXOfA+ivC3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 829AA44981;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A5C3C4AF13;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=9/VBXFiPtXwwSkwilV6QPnmo3UfNHlyoXBHTXU6ZEIc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=a0Qqx7kWCVBlj37epmd1cOaOUtUX3KbgsTmb21UffxnHoxg+cN4ojJ1Z0YQKPhJ22
	 L644l+d/1YfKV7w/4CS5ZjbZNlZ9aircdmaU82439g0bLFHAyAlcNQ9MfVdDRZPuu3
	 WIgIsZww9zTOQcsum0LsZHvOs6ct/B46gHCrJTrd+6+tRW88jiiFEHjx3A7NhjqK9D
	 eFHetrV2SD8Q8EoOeBXOwtYuObvVqJfw4KSZkf+jNmf4iB07QrTUG196d0Zb+hdMrH
	 ROVaetwoQuV1ZFBvoQoVpZYV21e/BORB5fnz2KgjUxW6kPDu9ypUuIwIUF6hrbcA5y
	 Qrow1lUG2xviw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B22C88E45;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:02 -0700
Subject: [PATCH v13 36/44] KVM: selftests: Add helpers to pin pages with
 CONFIG_GUP_TEST
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-36-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2739;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ESFxRYNiDxK2Bg/x1Ed6912z9kN1UGHdmxFKSE9Nea4=;
 b=iOR/3JiOZabO9ujUFLcXtm+PIEufsgYutfh5+PdSX6c7HU9mn2NbbzX9dqB+VLtmcsvOHkMsu
 7+jWyEdcc0GC/X9yGQnC4IwttxwDjVG6uWuFbFRoJIOJm0+EwNaRWxC
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D357240002
X-Stat-Signature: pn5w6pq4fg5ore897oc7idjirzxnumck
X-HE-Tag: 1789084552-2249
X-HE-Meta: U2FsdGVkX181dSeb0LYPZ2rsWHZ0v6d6UM7PjiaxqAQNcLDZUxhgVf5O7hKhflgJl14eC9vlKr1kbRkuUTBVkyH5v8qV7VQuR9QKwFerrcpFIMzhQ33OV9BWlB/94CnKXbw5I8CGU2ciMnyOM2oi7kjhP0e9vTDB1Yaen+NcQenhR+CKkizBONGJHIwycab6V2L65c4IxWd4RlVs6c1Lg+1dk9qoGI9Mv/cBrm74w+xNtM8jjsWwnlaytni3lXOdfb1zDWeueFpxol99AHinJFcT/KOvwOffiSA6nes/QwevSOXxTwk9cZCcRJFCP+mrOCz9lEb1OZbu3eurTYVuPVuhaA29UN6d6GWQpo9wQh4YJzE+n9YhB0boC1QA0QCuxMAJWDGQap/p3ssWQtDIHWtrPEr5yzK2Jc6urUYUoCgEEGJ5r9nndgAm6/chytiRsNkv1TYLIY3MSrte1TL97Shp9dCR++Vhsj2SBKdWYKEI+FgoAQT29GgDPfS3/JnA3FrFXJ74VNTCtfRBB2Q9HQw1BKNhf8CZMKYW1SBJQ75zE9+ly7nqpA+fQiQ5g7FPtRidEuQIamTSF7wwgjDklPrPnVJoHe9VkSXvKFUFe4OKGKAZ6mh/CPpPX5e9zjot0aRr6DVjeuK30NISBzS52YpUn6gegEEV4nSQTRb4/RQcMX2A5SKymdhTCTxmCb0jVXMp1AlMxwhEIYTsxSmxXbEgAjvIAXGhmSkZTEjfRdYsn5T5X/qnA4j5lVpg3vqOGZmMLOLMwn1PKhq3wrGAfVi/nftD54l/7Zp0ehD+uF0aOOCv09xtcl4X1Z3zwg4GStgyaQgDIeXhNyt6ZE1iT9C7fVIrg1iMj24JUI34Z4E+L+x8lOnu4MW67mT4ymxWSfv7go2BXZUzpGWfX6feTeIUl2f4w7bwz1AkkxVuepMe0xLzoqpw0UNvXozBWpSsZqWmTx1mWTQKIs9IEZF
 GaYlP2c9
 w0M9ziVGV6DQhoBSzI0CL5kaTim+pvTnHwltHKpwmQ8eUMI6KCx6J0YmzkmGfGiOLg9EqlBv20ZfXakeyD//Psztim2QDl82d8hN2bWsPjn8hopdFmBxCabcnfhp7Lmu+0+qv8HgJdrayEonE94L6N3mgAyrLNkFggyM44odCUKltisoPqdpTej0e/Q4zDxa+36kf7NbMs+PYDyEkx5A0bZeZHtuMZBBqUpde7FnleL/FQzCDcAAWvahE+E+c59MENnWVYCYYk/hgscRZOL/eUTlpY9p1jyy059s4SnnYyJEaGJvk/lqivJgD7OLaFOiUmpJ+hD9Q6y3TIxyza8eNCbM8CgFP6ltHn9nFFFQS5+HKebH/3xPAWa+io2MPLhYxIxW8blr/LgrbtwHLaLtXNtRujjubQxg3Thzkty4FsMZ9FaFMlTeqkWpVnKS9ZG0EuaM7u/PiP1mswaxLDJnEsYnEu3ITUmPnnMi5ALE8AgVMoenWS2tvK1GxHzgpZrGwgKM3gcbIpJQsZHUQfJjLmxY5FQ==
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



