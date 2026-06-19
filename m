Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B15FDCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA606B00B8; Thu, 18 Jun 2026 20:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC8B6B00B9; Thu, 18 Jun 2026 20:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D6B6B00BA; Thu, 18 Jun 2026 20:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C449D6B00B8
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43438A02E5
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:05 +0000 (UTC)
X-FDA: 84894785010.08.D9E2405
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4415A20003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t09WmX41;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829123;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAiA3cPKdl968l3EwQ/DZ/3SwnRK+Tm5bI/TEMdVo8Q=;
	b=3FszUVXWDSv7jzAvn1RKbeq8mcuYICdjAtzHj00QvJk9hwIcaHp32qEfKyhrnoeJaHaam2
	dJTeQLawl98nNcxVVGqtwD2S71W0nlRJgM6cltw5FFLW1C1RrYhhemJGyOe15lcXl0yhQB
	L0UgRBvTSgmo9/xtwlY/qmwClZiODZs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829123;
	b=yH+rqLGVOycOkUvVT33siUmHao7GV4vVL22DNmc1FgDX1EjpukdHy0RTiLkx4g+TjQm1fi
	MmJcS5ZY3PxMHDT5IKdPdYQuYv86bNILThHt+ecXHihIBzM9YSjU+Vri7yx+MeL68Y3hK0
	oBmsN9PO6IKYleOYbjVaPj6l/B9+CGY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t09WmX41;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8155444619;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 507F5C2BD01;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829110;
	bh=JkvclheYVlQtJ9I3iH/etiaf/3XqpA61pAgrrx+kTUI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t09WmX41eda+CqTn15EgAmytgpz7Ua/gEJEnRS1lp61+0Np4HwgpmLPRFEcX3eO4D
	 cEqzfK2eY4lv4eupQo46MR9jvlMH9Ao2F9cx3hvnBDnfI9+LElwm3LEx8a5to8cmtR
	 XRHNJ8lbiIhACll0LSLHFjFLOHQF8nugB00xwiafsSb0lxQ586EisZLHMoheBDcdbQ
	 k2r46Ks4fqtLLB85E0512uJnNa+YSEjAeWxutz0bUVF1JGeW86FSF/m0sF0200+cE1
	 /GkZQif6KJRsyCxNtOV5MhNrhTdwzZ9xCStQxI1fL7t872aqebUMp45QLQhVg3a3R4
	 5r4P5rk+mRBOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4287ECDB461;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:10 -0700
Subject: [PATCH v8 33/46] KVM: selftests: Test conversion precision in
 guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-33-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=4417;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=089n8PdIwc6Nzy+S0Dr0pyuiLBsVGX1VHcRJ4aNhwe0=;
 b=Ol33//zzG7S4Cf0R2tiw/KbaraN9iueOKWcWAH8BqXxv523zdKwhgqX3OG9ABfUSm5N+1xj+t
 jGDWy5zD4fzAs3CICeIJp54yu78eCA2tGonKppYT0+iIUbLFiiI2CMF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 4415A20003
X-Stat-Signature: 78ojnt9rubtqbs7zkdr68u9atqq7z89s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781829123-995323
X-HE-Meta: U2FsdGVkX1++iEMOlz0eFgA6LcvWo3Ue6Gkz4GEdaiD8vrtARYQWGkypKeIgH+0A8dwuI20xg7kj8ALM6l5vdyqFf0uO1JunzLBMIVaXylXubfF8p6jOjpzN5fWoNJmq11GB2U6UL5iaR1eOu8rni+vWk3BxmbhjrwF0HYwokTyTcidVAdqaoJKjxHLQxnqkgim/S3rdwKnkKB0NR0/z1jDapwlK57mMAsv7uka84Q+oOX8KKeZh2+mImRkp7XgP64fFNjCsIgwj6d0fOcwpNkc0PtFyi2ZRinZpKs4cGdJxGaATtS8EHVsqnNtezakG+66jCAiq0nKAxUrb3biH/PdcllOUjn9GApjaxs7+kqXVSZwHTRg8UJVBX7f5HTtm53CmmMvIViBxfrQGsDRhhA7XMKwL84mjXP804nw/O+3aiRwAWMrM7bE3xbJyVpEB9ElxZkOwI3gzvnjMJ0QPn2wFuRTtZeRmMphztB/Xr0cf90MVChncIIZ0FcdfQZf59sFAKCUm6EvmrXxZikK6MCY7ZGcQYzAEGLq7Yp9LHmshbO2yotptd5NqmQ9CPdnijeQean0aol/nj/n7rREU5Mj5ZAwq18YvH/s3wQRABzT1r85XEReCQp8kU25xJBeBoso8d3c7+LJuUs4y5h4D4a9Wz78mUInbmj2NhSJ5ZvAjWHcxv0nhYC6c0BoHWsej3eLmpZOjXk9lyI0JSe//6tXgpVHkXfEsM5UlQPkmwm+3AHFC6Hm4RnbDOOIV6Gih3YfeqzPyGj41c8Vm3o1koGTMOlbU0BK+W7Vvz7O4g3RsvOzzq9/jCozIj2nAUcYrcD+K83KySeQYaaHrXhI0HkT9c1JWppdEUl3n6pHcWxiKWWKEv6bE1LHfv7cWoUePYShQivetNsmhXaYOWdkYmVtuVygUN4tYPZuHZC7xffR29J5MsLei3jGf6gce8ZRH2k24PwsdcqcAkdESwU5
 OiC+xF7B
 g7fGhyfCLIhr8mkB9OUZAo5fqsB1FmcYF52ZCAVqKsoZYTEN5mBsdSOUuT8jTCMStFuUMVPBHWT9nN4lGhNtILPaRd0XQ0HQMz2sw5KV0JCXH/3RzYmL1SpVQ+PvR/NfGJpX+p6iCvR3AbCt3zxuppRoSIX83X3eYBGH3pXgWecTAIrgmQbXyM58rMq5pAb9FeqxlbnGWkF9RDuDFEyauwAPhZhkVRcZI7zPjomRMQHSe12sNESDKKWO+AWJbjiwhFBbouyQnCkl9/ooZHZFFZ7VNfNrWFMIEAv+E7ans3H9pKymBIwif7niesI25xvLW28LhZCVYIjwsZWg9R9/vDHik0NxAmPPmZvNQvQCzVpCOd5ST0xN9jtX3z0dnNDzMze5p7k32RnGE2tvq6GmITTg5oBG8Yog2GP6tEt+n5EVoXH6/7s5RA2ipLTcspqxlocJrigK8wmbiC3LpyKwvCxIkaR6D9+NCddEVpkuJiqcMFwjx+dfT4D3yEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

The existing guest_memfd conversion tests only use single-page memory
regions. This provides no coverage for multi-page guest_memfd objects,
specifically whether KVM correctly handles the page index for conversion
operations. An incorrect implementation could, for example, always operate
on the first page regardless of the index provided.

Add a new test case to verify that conversions between private and shared
memory correctly target the specified page within a multi-page guest_memfd.

This test also verifies the precision of memory conversions by converting a
single page an then iterating through all other pages ensure they remain in
their original state.

To support this test, add a new GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED
macro that handles setting up and tearing down the VM for each page
iteration. The teardown logic is adjusted to prevent a double-free in this
new scenario.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 66 ++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 5b070d3374eae..8e17d5c08aeb8 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -61,8 +61,13 @@ static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
 
 static void gmem_conversions_do_teardown(test_data_t *t)
 {
+	/* Use NULL to avoid second free in FIXTURE_TEARDOWN (multipage tests). */
+	if (!t->vcpu)
+		return;
+
 	/* No need to close gmem_fd, it's owned by the VM structure. */
 	kvm_vm_free(t->vcpu->vm);
+	t->vcpu = NULL;
 }
 
 FIXTURE_TEARDOWN(gmem_conversions)
@@ -101,6 +106,29 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
 	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
 
+/*
+ * Repeats test over nr_pages in a guest_memfd of size nr_pages, providing each
+ * test iteration with test_page, the index of the page under test in
+ * guest_memfd. test_page takes values 0..(nr_pages - 1) inclusive.
+ */
+#define GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(test, __nr_pages)		\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page);		\
+										\
+TEST_F(gmem_conversions, test)							\
+{										\
+	const u64 flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED; \
+	int i;									\
+										\
+	for (i = 0; i < __nr_pages; ++i) {					\
+		gmem_conversions_do_setup(self, __nr_pages, flags);		\
+		__gmem_conversions_multipage_##test(self, __nr_pages, i);	\
+		gmem_conversions_do_teardown(self);				\
+	}									\
+}										\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -199,6 +227,44 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 	test_convert_to_shared(t, 0, 'C', 'D', 'E');
 }
 
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
+{
+	int i;
+
+	/* Get a char that varies with both i and n. */
+#define combine(x, n) ((x << 4) + (n))
+#define i_(n) (combine(i, n))
+#define t_(n) (combine(test_page, n))
+
+	/*
+	 * Start with the highest index, to catch any errors when, perhaps, the
+	 * first page is returned even for the last index.
+	 */
+	for (i = nr_pages - 1; i >= 0; --i)
+		test_shared(t, i, 0, i_(0), i_(2));
+
+	test_convert_to_private(t, test_page, t_(2), t_(3));
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (i == test_page)
+			test_private(t, test_page, t_(3), t_(4));
+		else
+			test_shared(t, i, i_(2), i_(3), i_(4));
+	}
+
+	test_convert_to_shared(t, test_page, t_(4), t_(5), t_(6));
+
+	for (i = 0; i < nr_pages; ++i) {
+		char expected = i == test_page ? t_(6) : i_(4);
+
+		test_shared(t, i, expected, i_(7), i_(8));
+	}
+
+#undef t_
+#undef i_
+#undef combine
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



