Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33211C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F11F6B00C2; Wed, 26 Aug 2026 05:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753E06B00C3; Wed, 26 Aug 2026 05:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B586B00C4; Wed, 26 Aug 2026 05:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3696B00C2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B490DA36EF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:10 +0000 (UTC)
X-FDA: 85142871660.19.87B21D5
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf17.hostedemail.com (Postfix) with ESMTP id E4F1E40007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q+q9hZyb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3i6-OagsKCIAegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3i6-OagsKCIAegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ik/B5ZuTpzm8Db9Vos6QAKILR9bvsScWDRJqqgLCjsk=;
	b=q7/tygF4wkEzCoe15k/16zFlcGbADjvaiRTf/7dbZujmz1+DeDXpV3bu9rib7EC2HKnjg/
	g0JegtzV0ySQ0+fSeuPVOPPQwWvBOXTE7zgxJueF+3weey+OxCXGwIK5zd82u0Fv8GboRf
	SxxoW9yssLYPzCtCFHMCLDcHqW/2CSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735948;
	b=Ucr/2udwPqF3Anvn8IJJrJ203Wvs2XCM6efFjalBoCgHFkbQ1on2ESSS2eV5IYdoK/0pM/
	hdT9mngRsDp3X3ugA7LDFbcuNiZOszczEgVRr478zXMmdyaQo401S2+N+uPN1c+dxhuwOS
	Ds7HNKeXbkv7f94wOH80fvk5pgzNDXw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q+q9hZyb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3i6-OagsKCIAegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3i6-OagsKCIAegoivpi2xrkksskpi.gsqpmry1-qqozego.svk@flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cf7dd9fd91so10184585ad.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735948; x=1788340748; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ik/B5ZuTpzm8Db9Vos6QAKILR9bvsScWDRJqqgLCjsk=;
        b=Q+q9hZybjkoq6hrxzQL3zsAPCstcd0ogZDYO3AH46cxVcc5u6YH7lxBv7r5XBvU8KO
         87u9+r0rMT6ng4ouWvxSephbeWm4V1zhDfG9AU78fEX0JMn0IXDHQipKo0ShI1fjdlSu
         /smO5dzND5nUTsNayNBbXO5LeKi34XnXUnYxVEIWzQ6pie0mvSd7plwIqNY4/2ZGcR/P
         h3hXGoMleLaTKW86FT0TZNukHND8hC7dfekpnhLXdcuC/URJIBwZszpp1reXnAm+Jsp9
         8H3WkjMHQSKBF6XUewahYT0qQ1Lx89OOTxpBL6EHVY7YFUBNRq30iInoa8xgoebtoACr
         CkEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735948; x=1788340748;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ik/B5ZuTpzm8Db9Vos6QAKILR9bvsScWDRJqqgLCjsk=;
        b=tUhbAQvpNqh4ANu0fQEu+yy+qssP8BitVKY6G2x9yyREaMTkiIDljbn0Bg8GYvzctQ
         C1my+mjBGPAfNsExAFz5WZGpYNx82eZul+/VhqHy0DFNOvC6cT+WmwGEHMrlF1RyohNx
         dpVu7Vql4CmaBtjqqL7v7BisKqHVIYvrrE0jo/MWEriyBnbPKJgMXInARJsrq36dn75G
         8ukmlZsDd4+asSXf9OzYPRKyAblZ5pXR2kI6T67xDGDA4bx4bXCSUauGx7/vWUwxSq26
         ZOXbKU5PJ7z+IlC4mHVrZimsTTmZto1aSMWO//jaothjJSSA+vYly7yZ805d/d5PXbkR
         azZA==
X-Forwarded-Encrypted: i=1; AHgh+RrLODzxJs71N2+lKCmVKvzE5O9i44MyFliyiKKeBf1cgGCYX67EsytLh/Ttj6oRtgHR9ab6y7nmDg==@kvack.org
X-Gm-Message-State: AFuF++khbA4RqM18pgsbg9mjuGfHwl9CA0ljVeE7CL5TCj+0nBc5T+cD
	SMdZ3b9rk9QV5SdPc0uMBHS49ea5fAVcPwo96Vr0LZdznnETzvlHhBlghRBkbORYs9jR3JGVeu8
	yJQNe5nK5oW7hJtsuVkNXXABNQw==
X-Received: from plbkt4.prod.google.com ([2002:a17:903:884:b0:2d5:e7d8:3c3b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4c3:b0:2b2:67ca:5ff9 with SMTP id d9443c01a7336-2d707803e2bmr78547545ad.0.1787735947278;
 Wed, 26 Aug 2026 02:19:07 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:33 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=2066;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hllAZwlWW+ih1BmS23q9euXZautp6FkTBIIgcqLkrqc=; b=qsiVu/whfm9O8+e9PDF2qnZWi29DuDjd8KVnXJuUZNQ15/zioWZ2WGZ+Gc5d2n0THQKCtwyLF
 S93gEjTSxmiDnf4G6GH5/pNYzc3coo+pUgB7Mig8s+PQSoK8gbUsyxb
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-35-0a15d8a799aa@google.com>
Subject: [PATCH v11 35/46] KVM: selftests: Test that truncation does not
 change shared/private status
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
X-Rspamd-Queue-Id: E4F1E40007
X-Stat-Signature: 9wbded18q34bn39z4gafq335n1hnd1oh
X-Rspam-User: 
X-HE-Tag: 1787735948-945661
X-HE-Meta: U2FsdGVkX1+pdQgDd8/jqwJl4Qq56buOsPUJghDZw1pZKayyxWiFu/+Tvxd2tDSl2FZ9G7/l9J1pwEKfteRIkqtWw5X80UFs4z80b3eTpF9egxmf0Lb0Piex/J2oFxrXjAdRYv+G7re1W8vMBlmH9LYKXldZj5y3xS+BsjdBd5hPIMXfNlWfBLA9SOdkrm4k/b2fr0CEeHQUqVgCF86Xx2SpIMp94t+1okd4Hw64FQEWoQN6wratyeKT60KPjXUVPV76BnuRNN1E20xmXRCifBfOVRYG9r69RfhaaF872EUqUOwLTCE9fKC0JF51DMA0EexEICAVNsy7zS3cKJy4+z5YW4VwmPwGXB7kL4v8nGx3NNTdGS3mNH4AszTxt6FTMxPYucADgfpaBVPanMvmcdrQRj4wC7tXPSHNEgZMarRLy0Q+FO/G+jYb0eeeQtqhXwcwQuhJB9aS/wa0JFezNNcec4BCTdago4tpHNfs/cB8lEQkEEy7CO6GDcYnWVPLdvCf3rivfKc7p07WIE2e3cpIInDnzwMmjdp/uIfbYD4MS6IaAzJayBwBLVaQ2kahZRC4QkZKz6MuPx+n2KLPIYpe407+gL9WTMjhANt9vKUfACD9tuNXc9a9wNagqsfnlWklA9ORere64tVfRi9cC95QdaycjaLJ4WAAy4Tk2ph5M3KH78jl8y7yx4dC4BGsBhIuLqsL7BIbhO3jzkgGQyTe1w13cCE2IfheC6MkpXjPqW1fpHX4m6h479YxOVt+jXh4u2raSfQKbtqEgxVdZwZA0JSCYwvYtkqmSznuUC9DNDKi7G9GokrmXs952eYElN7roWDkYGTMsrCRSv4KZaWwBRXbLTDKjrseejYY0Hj8IJypz8NUThMF/8BsCOxwUl5Znv5lAWvUD0kYqHogm3o4xt5rz0oE5fX+y1NMwLIQ8KFCWDaAWXvmiyPOt9AdJno5xOzRBKs11uQPsGA
 TfyvToK7
 J8QcHzaKfwfD/gGaH9tyN0S1hMlAfM3PtOjIakm4WCoghtVqo+JpOEL1P/aZwU/45V8c+1+WmmEr5IQML+k53/T8t3/ThrngxMqpvoLSqi9fHxAACi0lQ4/+KUhgALDfv+DByoGUDU+IMpqjcKkOWZ5QFfD7CsZ6HpgSpRbgpiHN0xk0jjYXIt+FuXaCyKf0ixJYDinr/CXPJ0sZkcF5IpypXq2kRoIaP/ogOOE4WjPF0bsj69Dy3MUnd+Mqzypey3Kloagi2TSyGm9l92K0ob3LV/npurVNM1EXDXDZv8DM8NolaxqrnJidAcdEAJNNNeMsbYnELpwEGNzu1zqO5nL7HeGR8EoR3+b450L+/7LHeU+Ebz55JuwVM51+nYLM0Bjs2i9G7yr+5dr+SAntlaCyj6npJ/qGXSl0aYdiWWKXzfb44VWEcJiKPXiXJ8ndBxlXmzF/wBi0Dtica7Pah5TEYWDkRS+AWDZA/EAkAwbRy2GDA4ZvmqSCbkXX734Z3kWIpBhUhvgVNR0/NB2aNIWQkeJap5E9kwP1/kNGBNQwbotl57OXEVlx1YL8tZ6Id8RTLU/c+vOQMI+oVwZ7Cs0U6MMq0V4+5SQi6lY8B6C8OF7BobcRovVfAlePIBrDNZp9AWZrgIRBxvck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test to verify that deallocating a page in a guest memfd region via
fallocate() with FALLOC_FL_PUNCH_HOLE does not alter the shared or private
status of the corresponding memory range.

When a page backing a guest memfd mapping is deallocated, e.g., by punching
a hole or truncating the file, and then subsequently faulted back in, the
new page must inherit the correct shared/private status tracked by
guest_memfd.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index acdff2d154046..b7a54d2a90928 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -10,6 +10,7 @@
 #include <linux/sizes.h>
 
 #include "kvm_util.h"
+#include "kvm_syscalls.h"
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
@@ -312,6 +313,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
 		test_convert_to_shared(t, i, 'B', 'C', 'D');
 }
 
+/* Truncation should not affect shared/private status. */
+GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
+{
+	host_do_rmw(t->mem, 0, 0, 'A');
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	host_do_rmw(t->mem, 0, 0, 'A');
+
+	test_convert_to_private(t, 0, 'A', 'B');
+
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	test_private(t, 0, 0, 'A');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.887.g758fc8c411-goog


