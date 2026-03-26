Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F019310AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B55426B00C9; Thu, 26 Mar 2026 18:25:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91556B00CB; Thu, 26 Mar 2026 18:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92EB16B00CC; Thu, 26 Mar 2026 18:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68ACE6B00C9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32D2D8C5CC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:25 +0000 (UTC)
X-FDA: 84589646610.24.612B39B
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5602E80004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="R8hv/M22";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3UbLFaQsKCCI8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3UbLFaQsKCCI8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMzauqzu1N0T+RdZOJts60YeEjJTRcPELOzUqUrSMzA=;
	b=FGE2bvGTrGTzUfTJ4XRCd3xsJvDbaylKDNCCgPIhudhlkzLsLgxP4Z2M93ZZrEdVLfqXWm
	Sw1neRaecSfwu4dgg3HxBpy/aAC6wtpjWD/pbmjto+b9+v66+aJ8859I6v0LelTqN75TY7
	tuotLKcvW1+gOXMR5qrUqtp2X8cjST4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563923; a=rsa-sha256;
	cv=none;
	b=VqOCSvOu9+auHXG50YOmy/8ajn7hS+OVU3cbktzjL/YHgkLsN/Hbn6LTjBl8YbmNP9vwn+
	bMioR42Borw/uxUG+fghiELlMw/GBzOyJgunVz3E6dMX5n0/pIh57xCK62AiceMhPPJPoQ
	j0VzgIDm8tdxEIRf788INv6cBo3hP9I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="R8hv/M22";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3UbLFaQsKCCI8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3UbLFaQsKCCI8AICPJCWRLEEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7423ba5342so2999627a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563922; x=1775168722; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMzauqzu1N0T+RdZOJts60YeEjJTRcPELOzUqUrSMzA=;
        b=R8hv/M22abEUbtPAhJKX2sS8LEzWNxnKG9icgYYhQt2Udep2aZBOCHpOJTWWwMygE5
         +IAvoRNAXH4ELiEi+KsFqUgyPvm2y/Wl/D3m+RUxWD/KEAMnC3sGD/hZCChlfcGVAFCV
         5JL7aBFalGH9dcHXgjDTx/RrfSNTdcRN0djiBZVruzN0e5meDvT9ZM1m8FkjaNZNIBdx
         tILzZQmtJ/JWG/hQb461KkACjN8vms0zTlW/H3N9Uukd/QGIwqpuo0grl9ZJwak5E3y5
         Pr1SpOTKkIZAFu1/sdxVkzlmzn/6bWeSiu1EukzdcdzmAdjiBBtsC4a997eEWZjM/j4W
         EY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563922; x=1775168722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMzauqzu1N0T+RdZOJts60YeEjJTRcPELOzUqUrSMzA=;
        b=WG/tUf4d0TvpKHxzYTLxB9jbkEAwln+LejpD8plZCNsLUkGfzf+BF9iyslww7wHZ87
         0P09EXTtLSgp6tuJ7FvW+RCmzoTO+HC7DTQsCsjlwmKWlf21kDQGxs70QBUZoGnBRqDP
         KY8qDzKqRc2pM3q+iB6LgPMJh0RsR9TiSZtRbBhMB5Ej2b0zBW9o1j1U4dB2c3qc/2/h
         Wat67sj7ug0M+z+jh3eYuxOIZGOuaekFpElESkrQUM/Lema7oS4jxgiwDY4oU9Ubstqb
         iqOCYcugwtj2/tfn6lOzNUkoC6+LlCazZyuokFPs3xlUPaQbdAb3zrIxsAUePPSxRAfi
         AXKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdnzxbtrHQ5eOCfpCVq0B5hlcegr1Y1Gv83ZieHhNEqkLA3Z+4/oZ9wPMqBFypUku/PJKTAUq2rw==@kvack.org
X-Gm-Message-State: AOJu0YwbKob7/wcnXLRlJAo8IRxCxP3OYOmrSoU/3rFYX09oCBsvcTDx
	UIJXsijuWdrFLWWb7XaNGtjLIXvrbXKTsD6RWr8bvuk0WsyoPZBw+C3LO0BcvJY7ONMr+q7trEs
	G35VgmfqeWv02XP4ihkMUGQYX4g==
X-Received: from pfjf18.prod.google.com ([2002:a05:6a00:22d2:b0:82c:8530:819b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:23c8:b0:82a:805a:7cc with SMTP id d2e1a72fcca58-82c959d4be3mr154865b3a.4.1774563921606;
 Thu, 26 Mar 2026 15:25:21 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:37 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=1702;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6GHfy5Gjl/zAQ6e2mdyS+8IkN1+t3F2076IrLeNAKh4=; b=c0+/tVHHCj0rRhXtP95bZmzyVS99cg5m742QeRGaOCMuqdCrbTR5SGdXnoc6pcKSp6OoBARjg
 dKSpjzbhP3OC/hursTJC8G2V8dCdYgi2xvh0GxAAJepAlmCgB5i/jZU
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-28-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 28/44] KVM: selftests: Test conversion before allocation
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
X-Rspamd-Queue-Id: 5602E80004
X-Stat-Signature: 5yrirwhc4yer9t8mc41whfe7c13it4hn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774563923-599826
X-HE-Meta: U2FsdGVkX19blbAslOqWIcUG/kOihDGea2b0tSMb1AhjiUz+3n1Zy3DYpmJH7tiyW/woDXchmI+lDeTEQqp39oC3lmbqeS4oQJ8GfDhS3Ai3nTZItJqMKnuXCkY7R2KGk56UhxaU/yn26N6neEjxwUDtX28iKF017C82WvvTVZJhIUU8d2i4b9oDfx8ZquWR1jXEjaVJEsu0uRjX0CcmxRPKNrdM7po/I6bu3Nn8MKX6IJ+2RSaGPaiFnlCvQlBW1t1++BAvRp7O7GGKW6vOfbZnv1cbG2z3m57cG8iaEfe4musYqFSBW3wDwmKLk0HGKprjfS+7qeUYazCnHAmqUU1AQID41J+igZ0EtFtxCZM96CbGiwl9w1n8FmNYZfOxp/xOMPaWUDowfWc3jAN8cVwXqI6MJXrSI+zEosQSwZWjWuJUomQfFl3fXak7+cxULLdeBaJ+z5SS5O4AdvlLQr2OvrG/qxjLc3x0fmGoUHVgcYbzxRQUAwkvl0bh8MrhoH7bZwM5WzYYvNqNkIM7JzesvMxwjcsLVDTKaEN6VWtO41elsbupHuAfiDnZqkPBC2tRUGLOpb0eJHrsadpxidKJxtye/mAu3hcB7mF+Eo+BTBTpNc8F1OvRrSGJzJ7DXIjUG8cUyUGVcP1xHxIb7d3FirivLQdz3DnHKMScoIsefOjZ3/fbZRGIVtoou/IV5yWybk7cI8uHk7fL1vISAaK1UPw3J5CWP+shye0B1RTf2JZAVLlxBkjlPXWR73Xv/7zTlfBa2ZNK+y29AA8y94Fg72k65DU1jv7577jxWsUs8C4NjFFoAw1zKwla7ZCLwHMJ1lKGBGm6Ex2yF+VGw639nYdD94IoJk181sE0hEwWmJpTR+/Oj3uQgzW3aJf8UpY28BCoM7mZnyKtKlGezixwyI/M2T0zdoi0TsrGIzk2upr5A31c8xAnuOiYzWtw4x8RBL8vbnUn3GV4P3I
 0Cnw6rOb
 20vhORJHd41dUrsvw8qAwmKtgOzA4S8/grNbKxzHldFqXJOAU4uAbcK2PZf+PwcqZScpbuukjRObI1LPQcF3HkWEkxYDNn932czWqvtE0H3fZkYsvdNC/+6YbeaABzYienvjSOB5x1fmChE7eOfUkQbf+tk7hIAzmtKnlRhmaNOZVdtTAj9CEdGrIHToE58p7rEcCNQzTv90FwFGGLeAb/A4mf6G4Y3FEWCR6oN4C7/hXuaB6KIir0v4IItzwxAFQbZ5di7oH8BcKjr5WzXkDkNvgK5crh1bv4uqzGhDi1nA5bg4/ChB3Y7PbzezebsETBC5yPpSY+ByC10VuX0uki2s24o+TmjXAVzb0PSYS/nTMlrs6ewKjzDIWiZ/X8NWTrnT5B+LLW5Ym1m/I9VjqKRNpLR1LxEMkkUpFk3UggrFZw0ignrst6P3wdMSCfgBPY9yLN7dO1s0a/9I9WnvTndiCSOf6uX1dKrN+4a7IXLRLvVnyrZIqMPf8oN4NU7wDWxCUuWMFMmp+JwC6f8SuxD2uJYR0m2LGXYp6kUq9RI10v17d0cvH/T7BScVHsu7zHKkeNg9xah4zPf9TvVn8JEtImsWBsHOxZsQXcNz80Fam3pLiLiFz6aviFJzJ++esoWH3KQ9UneMECp7gQd95xsr4B1bM7bTC3/c6m8/YTuEIwjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two test cases to the guest_memfd conversions selftest to cover
the scenario where a conversion is requested before any memory has been
allocated in the guest_memfd region.

The KVM_SET_MEMORY_ATTRIBUTES2 ioctl can be called on a memory region at
any time. If the guest had not yet faulted in any pages for that region,
the kernel must record the conversion request and apply the requested state
when the pages are eventually allocated.

The new tests cover both conversion directions.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_conversions_test.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 3388f06bc51db..1198c9c914318 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -275,6 +275,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 #undef f
 }
 
+/*
+ * Test that even if there are no folios yet, conversion requests are recorded
+ * in guest_memfd.
+ */
+GMEM_CONVERSION_TEST_INIT_SHARED(before_allocation_shared)
+{
+	test_convert_to_private(t, 0, 0, 'A');
+}
+
+GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
+{
+	test_convert_to_shared(t, 0, 0, 'A', 'B');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.53.0.1018.g2bb0e51243-goog


