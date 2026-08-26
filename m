Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D98B9C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A9E6B00BF; Wed, 26 Aug 2026 05:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD156B00C0; Wed, 26 Aug 2026 05:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976896B00C1; Wed, 26 Aug 2026 05:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63EF56B00BF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4AF21C1848
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:05 +0000 (UTC)
X-FDA: 85142871450.16.205432C
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0C4AC0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jfm8wRUa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3hq-OagsKCHsZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3hq-OagsKCHsZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89L7E0e7HlFcsWgm0DMydejmixwj8/yVJ5vfC8XlboE=;
	b=tqScg1WtTZkykT6SXlobzZD8kLTzgj8HlGqNfAmaxOkFKgvIHWK5DJ6Rgg17JIOnGVh6tV
	XQY1ivQkEdveXCdkSjp84KDp39BhSvQA3y0DBUszM+HL0wUDmf/Ku4naeWva47IQY8+bMd
	d6VBMaxPD+ZaX+23Iwf0WN5pUg4MUPE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735943;
	b=MZbBuISRA81njJJ7uREGwwhhlK3OpRmjVsI5/1ZMeRcGGDVzq75E30MsJ5V4hswjnebTVX
	iLw3Zj/E91m3IpeipMAbqwfw9uUDmC3ANQJi1LTqWGSYmcUHUdFZfmoNKFQP+Zi5iurQRU
	NCXxxP6Wyi9zgX4OPV8NjQMS5ZQI+5U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jfm8wRUa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3hq-OagsKCHsZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3hq-OagsKCHsZbjdqkdxsmffnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cee894b3d8so13670025ad.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735943; x=1788340743; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=89L7E0e7HlFcsWgm0DMydejmixwj8/yVJ5vfC8XlboE=;
        b=jfm8wRUakkCY4LGiZUeUjY7IG6dELgTmKGuUyphim2Hc/5Z8Gy89u7NzejNRMum0LB
         RXWbDRlu/tFQTXhxES6041SJlQ/sdrIc3creYY6X3I9XE4VXMCn9rBE9SySw3wzDmQak
         0V02GO6nWgb+SSKd+jNVN0wigcGs89mmntVcQuK12SxwKRYdL3jezDunmoMOmyiYmYqy
         ALT4nKtWmLI7Lo74WJGRdTl10OYzDv2OBSo4/63Ivi4Zji5oO3K82fkNKKN2QczfQgNH
         0CrjuwadTHtJYQpKG6Ax9AnULMXHDOrtbVOkrYhmgWPgQPpByEdMyVjqeKZeqncsGmjl
         on6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735943; x=1788340743;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=89L7E0e7HlFcsWgm0DMydejmixwj8/yVJ5vfC8XlboE=;
        b=DVP0QtshRnllaJEgUGLIQqREqzK9PXKOkl8TVeZ9lNiZ7r27+//Dca8eBNAwq3MquD
         zF6TqOUNXsrfY11716RuUSJhdZ/OWZRbyk8wP9e3rmxJQ7MG5UEOmq9SyapX78P4RPti
         IcJgkSlJ5NNfxU6SUow0vwhkMR6tY0D6Uh3nCu9r4z/HseIGRkrkweJhMr9pzQcoUv0p
         srTfFOkBmLD9W2PJ3GqMkQFPynDgGjkCQ+zTNhUrcm8x9jaVWx+cXpz1g8y8cIUCWkkg
         TSx6Aqr0QkVtEMLJCe5yZUqWYVT2w73HgJhLSvKZD9x6nmYhjGarNSXufS5J2VTU7CoZ
         6n0Q==
X-Forwarded-Encrypted: i=1; AHgh+RoczgfCQEShvddXv2swkqtfs9SbepAN1bWbM30F4VUdbU0CjfjAKbY0esYG4ovEoBfo8zxrZMM11w==@kvack.org
X-Gm-Message-State: AFuF++lKXE1EXmpIflPWP4Yi32a/3dJ2aaEJhZ+cyIDqAXEKvWEEK2b4
	kUTaBe+g+ZfwB5NdfTETua5HzVHo//KV45jcLeBOf2SG08w5fes/hyihIl8G1PTVFnMMcpZNrss
	JFJ9/TE+b88MdNLFKbIApZUQXyQ==
X-Received: from plwg14.prod.google.com ([2002:a17:902:f74e:b0:2d5:9dd2:5fc6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2283:b0:2d6:fed1:7127 with SMTP id d9443c01a7336-2d70779678cmr89516245ad.0.1787735942070;
 Wed, 26 Aug 2026 02:19:02 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:30 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=4642;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=7w+gDb7QtZnkDWq+h4HUO3ST/UY633rHaNS6m39pYVY=; b=r4t4S/JNI5hvSCE0TK199jmMLi6mPSfRkQixeoALxuEBJ2SPvehHkS7r4ESdRDawsAmTdhPMz
 yre4PD9BkhTCsEfVE6Y3A1ngu0fOF/kQZRDMogw2uXeBID6J4beusMe
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-32-0a15d8a799aa@google.com>
Subject: [PATCH v11 32/46] KVM: selftests: Test conversion precision in guest_memfd
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D0C4AC0002
X-Stat-Signature: p7h8cijbbmdp949h7hobg5kx7s4wnews
X-Rspam-User: 
X-HE-Tag: 1787735943-665233
X-HE-Meta: U2FsdGVkX1/ELMUX57a5FNyxwgj8nf5mEXCX/ZQa2QcXehjNIY5o8i+MafykUhX9lLEX6yfRZoFcTLhbOkOBOC6mpkNktK66t4Yn+CV0NGWLmMw3zDn+u5esvF+gBcLrN1UBr9ZXbWx0HTledfKJLdSIH9W1kNi6ih8tuBTYrZSNfU+42EtIcBCAzU9oAk+VQMvpHeh4got/nTGF4/RhAY+5zLc6MGezoj7pbG8owdBQFWokPgLjGihuZeyKCpZflSPMFZ1pHEKvqufeRuO2c1fkFX0fW08Z2BdUv1VrFq40aEjWHW/fR31qW6mmfaSUFbWODEK8cl8uF3qMXw4RLuDl4f8syFM6Buj8Wva+96b+R9mboOeidk7vQLA81jHqwrWpw4/KtuTk4uguedyOqqUtWt7ItuUhU+8Ep1TbkcRupA9kFF0qtJ6PPtFEymoPRpo7r637y3JuM/8pdkOtP0LD9AtK8juxQPDoJBPF+p5P7hUwGG6SatDxyARm9jjgrlkxxcalyfQaCXyk9gnFRImu3rZOAcq8c7M5Y+41nxxUXN1Zdk9oLGkg9dYnpit46RFYSIfKkCZBs+fJvNC70V0DQjrCCM+1VLYgp1mPfk5UUsl3mYDfFJx4MJR4UheMvEcBxXZ4u3gyp03/qF6Be7V5c/z+at5lqRT7BqUTZfaiqP5bwC3w2BR6Fy8aLb42Z+3hT5umx3fsB9NkeDUb4pU4xE/lRJfmvdWlDrvk4uSn9108y1Eib8VuhG/XySf5T0ahuLe5zmUVkNMy/sJMbfbwtaL2+k7WKhV3Fdk0ldJRZZoBKdsTmFEHrfjHhDDdt8zi5H72WhI4tUrTijUYnOdjn0ZWJzADzmjuRZjqWDNsdEWMd9pr9MNRTiva2XuoRUEM/Jsle9AdEHlOh1lP4HiktUNh0s0+jPlZDe344c/1fMAUHj/ztpWMsuAf2Z8Ridy1CvjW78/1NRSzyth
 tlGKvPXj
 vV8TSb+ut2KohpZzhvtjgZM6UGgFdcf8OosrjRTOSgn5NDbAupgcdSKDgGURzh2gouwm460WYdwttlwxdaFzj0HWooSZZWyJaH817jzPwqnXKJlU3nmP0ENDybyqxbBLUdB8CG9/GcYlLe5uj9KRmob1cH96BZMMw+icb23LmdjrdDbxVGuIWkivC6BqYWVbGPC06Nou43Wk+yWuEPPWQcxdYoEN3QWPAmoc5xpRnWXNofhDapvQP+s+5BMBNfK3WkORqz2kjhYA7tmhpAoAbGOw/FRTQjKPIVfW6ih6Hry/UGqzTx/BCA88e6CRycUu0NgDCZw1SRzSXH7svVq0OCOzWQPDioU1XygykNDoL3M70FTaPGK5qMJRfsdaQ+p3aWQd9lbG3sGq7XOoH3KbLYgNPVBG4JH1mFZIzmTAooAtob9l0qizMevrYWHwR8dyV7vehyRylpLyLlpmJJpmtCRVB/3I8UgFyytge9kZu43PuZz0ENt7zC0kPe1QkFbB2AcvvF9WGzd5mFIIoeXg8LzpEwdmAWTKhuGB3sa11d47/A/6fPkekcAcsziBW9qPwMZimZ1IFV4sCec5ho4MeTVJc4ciBScPJfIsLb3F9vq46yO/hLpgEgSPgzttBvpR1Y4fS0XbftJvDTab5H44M5y6sWINsdGTlLg57CoH67Ya7AF1xQSOesFCW7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing guest_memfd conversion tests only use single-page memory
regions. This provides no coverage for multi-page guest_memfd objects,
specifically whether KVM correctly handles the page index for conversion
operations. An incorrect implementation could, for example, always operate
on the first page regardless of the index provided.

Add a new test case to verify that conversions between private and shared
memory correctly target the specified page within a multi-page guest_memfd.

This test also verifies the precision of memory conversions by converting a
single page and then iterating through all other pages to ensure they
remain in their original state.

To support this test, add a new GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED
macro that handles setting up and tearing down the VM for each page
iteration. The teardown logic is adjusted to prevent a double-free in this
new scenario.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>

---

v10: Update macro GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED to avoid
     potential macro argument reuse
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 67 ++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 4c20d3d8e9349..a8d89df53e46d 100644
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
@@ -103,6 +108,30 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
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
+	const int nr = (__nr_pages);						\
+	int i;									\
+										\
+	for (i = 0; i < nr; ++i) {						\
+		gmem_conversions_do_setup(self, nr, flags);			\
+		__gmem_conversions_multipage_##test(self, nr, i);		\
+		gmem_conversions_do_teardown(self);				\
+	}									\
+}										\
+static void __gmem_conversions_multipage_##test(test_data_t *t, int nr_pages,	\
+						const int test_page)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -201,6 +230,44 @@ GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
 	test_convert_to_shared(t, 0, 'C', 'D', 'E');
 }
 
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
+{
+	int i;
+
+	/* Get a char that varies with both i and n. */
+#define combine(x, n) (((x) << 4) + (n))
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
2.55.0.887.g758fc8c411-goog


