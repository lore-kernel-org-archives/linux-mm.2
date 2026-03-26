Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FFE10AB82D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450026B00CB; Thu, 26 Mar 2026 18:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4017C6B00CD; Thu, 26 Mar 2026 18:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DE956B00CE; Thu, 26 Mar 2026 18:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0552D6B00CB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C15DD5CA04
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:26 +0000 (UTC)
X-FDA: 84589646652.17.71DE3EE
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id E576BA000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="k7BmLC0/";
	spf=pass (imf15.hostedemail.com: domain of 3U7LFaQsKCCQACKERLEYTNGGOOGLE.COMLINUX-MMKVACK.ORG@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3U7LFaQsKCCQACKERLEYTNGGOOGLE.COMLINUX-MMKVACK.ORG@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563925; a=rsa-sha256;
	cv=none;
	b=A1HnC4tu3lDMecQPIJmTApnGpqN8UQl7jeon9RvCeWaxDVelipeCDvjkIJj3VntnHHLuof
	8ph77tTFUmGRLFBY1B6ppl1lA81EUIqWz3io6Cf+UnbnjxjK4j4urAXZWHGSdgbwwsGkwZ
	LP4GRwZrqD4FZdXUeyGczoQ2qlbcips=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1xYMD/ygmI2J6L6yZT+C265xiVpI/P15LX3jXqm3Xk=;
	b=xkfwcrjIQpaq5ip6AUpX6zhsaYWJg1Ql4tEJ4QcBxChTtVpakjNwEv+M/6pay61iTzpuAk
	067gbzbqUKMRV1kbOM399mN5kQ6BunaOAgCnKOPwBAptOnh18kC5zROLUaAqSLTWj5a4/K
	9aPKTj5tmYZNBayzSbfYvRTQCL3X4mc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="k7BmLC0/";
	spf=pass (imf15.hostedemail.com: domain of 3U7LFaQsKCCQACKERLEYTNGGOOGLE.COMLINUX-MMKVACK.ORG@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3U7LFaQsKCCQACKERLEYTNGGOOGLE.COMLINUX-MMKVACK.ORG@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7423ba5342so2999657a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563924; x=1775168724; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E1xYMD/ygmI2J6L6yZT+C265xiVpI/P15LX3jXqm3Xk=;
        b=k7BmLC0/dlvjICON/QncYoh/uexDrbotwFBOCnQsUOPYLJ1lAqzxosSKCqtK+06Ok6
         f2S4rF3XDsGPgjWhRsi7GG8YjSVbSR3pjNiK+zpubqqqa4dKE2cXBUwxxGGolPtezI5w
         7TUZDiVZZU4Xfgyf1lfKgrYkV7g2Bc+DtSawXbwBvVYsb6/gHtVO1f/OrqZSJfoelkyD
         JOmpaghzwBqh+/vxfFkdSx0QErNgFh4BIQBCSSYtJ5YyuiDRr6w2VpnkiVhyK55gE34B
         cUwbWISYonFb7wgsL4sIYj6oGoQsTx8WcXFVNJR1x8ca0JnGlG8p3RaAG/5BA900aCXB
         kZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563924; x=1775168724;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1xYMD/ygmI2J6L6yZT+C265xiVpI/P15LX3jXqm3Xk=;
        b=NUKZ6IzVupEYzko+FFStVrgEGIrRJUdspMF6alqwDuzULF6NAsC7ZFzVNl1PDV4ADx
         6lejpEjNcQly6yDLsAV6GcRTqiycU8mfc/CCrwzTHE2DddZ7ONakAjonEzGRDxzgILhR
         ZEN4ltcwSkeL0aOBgYcnYVi8qTobyf9rHsH3lg5ZhOmOSZGeQ/Uc/WEnPddBZuYBBnO1
         LILtmpbC0m/kHYN4rZ16l6H2fr/UqZNHpQoKnMQZIBf1H1pjsv5adyybrr1RvoZ+guyF
         YDZbG7aJb17zHo78jCpgD8Sazb8w9/loxFB/q4zLD2eEXRpFAj5Yk8F6YdcJLFdx4JIw
         4RxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQVGfyh9MGY446hYpkpVoihzyxgE22VV/tPlzGz/cOXke3pjffcFy5y7F3jwaVQmX812BBQKH47g==@kvack.org
X-Gm-Message-State: AOJu0YxoZWsnuMLxy+z5D3rEaMmaBsFPJU3i1uC7CIanxJpA2TWEZsyI
	OTIqH4XyrFbnoy6mCmrq597u4WyhxLNXTy5FWwI+ERFj2u6oeSOWQNJc1kgmspNwvmBueNfU+Y6
	mVmtjvU0+23B/riFeja+MHeXT4A==
X-Received: from pfbfo22.prod.google.com ([2002:a05:6a00:6016:b0:82c:6863:427a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:348b:b0:829:6f37:158a with SMTP id d2e1a72fcca58-82c95c036cdmr167633b3a.18.1774563923362;
 Thu, 26 Mar 2026 15:25:23 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:38 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=2257;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=oHklOacZgiD0w5i2dlS6G3/6wCT4tptcmpz8kawfH5k=; b=t7NZE6MbqQDRWbQsWbc0txg2U4p4153wpJM1gp3EaoANwnq92WnqbVCOltBJBXIrWcw+W5+GI
 jF48qJjsPNLBWBTO1mypfrEwWyywX8S14Vetlu9iUQQtlDVpnf415F4
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-29-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 29/44] KVM: selftests: Convert with allocated folios in
 different layouts
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E576BA000F
X-Stat-Signature: 5me1su166byoozr4rneqg4gqam1maq6h
X-HE-Tag: 1774563924-946532
X-HE-Meta: U2FsdGVkX1+VnDlVj1A005Kk17vguTcuvLNW4pJhztHRL+QFJeECG6iVwK7CAd1z9NsjhFiKUcbDw09AYIcT+tz1sfz8qckJ1RmcKo/1CYmgQlaWEIaTi8Ig7IJszRpgSlWvXWF+t1NpM5r6ztKwvGU18aEsJoFJSc5uIkzPyMuqzKjDLAtebBFfouXaNan9YEFnmPIOzDJuZW77Mv1vHh0Lmk1M0Fi3Z+BRq2lKisY1kX25YCVF6V4o0j1XJp4PqC0a1Y9Bi/EUtZvfbJq+oDBUI7Q002Assc6gfR36uJWmEzD81OeLR6747Q0hzOHpYskA9a16WGTVmi6yrEDyk49ZFpTHvCrkyw6tqdGG+1kraqFHH3gHErbgFFY7iXv2iEKWwsflXOgWfWoSq+XExL+OOibXgmDszp8vkNJ77IHn9F2dc1NHEZmk+QKZPcd/9ZYYGm7viIDJZ0+YspoJAOxSldCacDv0r8DcJ9oprYP7p19nGn+B0asJoAbutWd3JLfe+2WrZ+a3AkwxLB6uhgSpAZeqxzP/r1dw1axLO9FWv5qAYMfQBcBPbd8JR+zkDju/AEbcIDk6CjebMCWoBun4NuFzgqQ08/PB0yoC1llZSsWv90/ADyJlcoVMSIM6UHJeiUlk31GMBbDOLSebOB2HwQnM1ia7d/ac1V3pejxk2FC9YvQ34G2kjDWhMFeo7cPTmBGmiUfXh+m3Mow8gBIY4xHSeHKZTXzV6EbA1RMgIgTpLsu7ccxBDmFEMk9RFK2UjJBmS/KxyYJYj/gWzAwaSL/OmogdZ58Nyy5z9VA5kwDHERXTYHxX2im9kCERu0mQzNlpPbkSChCG27u5gYwzZhT9neT0s7ol3CBfXnAvZOAJ63WUqS+F+6hWpRmo9YUMwPEh4Qe8s1hsf2F3NO/lf0nbaRoxHAiOr6+A67nF+GyqBGLXbrFcRJ7vZ7WC5Bz8cThRUsmbIuaaLV3
 NQ+Tic9c
 BQgesXjvieBzhSXwZ75v7u2mlPLy+nLTNOk4YBNckdNAEQKUW0+KzCSE8ojouPbFExjypHOjU0FrNnU93TqpObg4SD+653ZK1jejPZ+3+j7uLBUH4YREyeMZpipJuUGu3ZxqCRnsEbz2oM5yq+eZXgYfrGS3jTgtp6n6CI8bSVADgMmvM5VhUEv7vrp4LS1LzvTYQZYWx2Ga0oSQPoLHamFvqMXg/+EwxGkKlSSGasIFu1dAKs1RtsLhTpeHqJ0Xqc9WLFo2UjdLXaELpaJwupOyYDcGUKKnFCfOJlIlIta4R38BNAl+ZoSwTWUVn3l58DJTLqwjY0EcfAtG1At6Ok2ZhZvqN0Ctehrxowt404knCpEhw4VZeuRqmsUmv3Doup/HzgvOpP4BTQQCmtF4axvoQLON9awt+mrAkBlIIyTz/6F6WjAwcRpTHDZPpJGjfuZxChelNy/VDg1GDp4MzaEWZAXrFx5laim/IEphssUkLxJHj8AOxEgzGm136dK+s2YRxsJol9QNqB9W8Qu9kGZITmIMZUOQo4NnNeAJWsmwI1quDmngJd/SLEj6gh5juRblrVTK0ITL9BQyyN7M51pcmfTE+t+/2o8kXhKMJ/izlMBZLxSeOfeJ23Gg8NW9nfgyD8np/4esVVUB81do6CJ0VhZNgJO+tiy1mBdEql8lNfYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a guest_memfd selftest to verify that memory conversions work
correctly with allocated folios in different layouts.

By iterating through which pages are initially faulted, the test covers
various layouts of contiguous allocated and unallocated regions, exercising
conversion with different range layouts.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 1198c9c914318..8f09671505b32 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -289,6 +289,37 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
 	test_convert_to_shared(t, 0, 0, 'A', 'B');
 }
 
+/*
+ * Test that when some of the folios in the conversion range are allocated,
+ * conversion requests are handled correctly in guest_memfd.  Vary the ranges
+ * allocated before conversion, using test_page, to cover various layouts of
+ * contiguous allocated and unallocated regions.
+ */
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
+{
+	const int second_page_to_fault = 4;
+	int i;
+
+	/*
+	 * Fault 2 of the pages to test filemap range operations except when
+	 * test_page == second_page_to_fault.
+	 */
+	host_do_rmw(t->mem, test_page, 0, 'A');
+	if (test_page != second_page_to_fault)
+		host_do_rmw(t->mem, second_page_to_fault, 0, 'A');
+
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size,
+			 KVM_SET_MEMORY_ATTRIBUTES2_PRESERVE);
+	for (i = 0; i < nr_pages; ++i) {
+		char expected = (i == test_page || i == second_page_to_fault) ? 'A' : 0;
+
+		test_private(t, i, expected, 'B');
+	}
+
+	for (i = 0; i < nr_pages; ++i)
+		test_convert_to_shared(t, i, 'B', 'C', 'D');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.53.0.1018.g2bb0e51243-goog


