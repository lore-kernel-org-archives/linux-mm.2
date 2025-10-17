Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADFECCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D1D8E0075; Fri, 17 Oct 2025 16:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D878E0006; Fri, 17 Oct 2025 16:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859558E0075; Fri, 17 Oct 2025 16:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71D988E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4604F1DF826
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:08 +0000 (UTC)
X-FDA: 84008705256.08.8A5CC2E
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82E37C0007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wTt8DodF;
	spf=pass (imf28.hostedemail.com: domain of 3UaPyaAsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3UaPyaAsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDnbSa/T9rbLxdB+UQ48e1HAUASVlE84N9T/ACVvI5o=;
	b=crMwIcr/m5ac6nAy1uDRWVHuzTYGpiulWrh2D9N5H4HTrKXKPYEgNzOrlBL1Kn9TubK2ts
	m5knPMxyQhFagDGAsrlYHfq6HcPEA/ZqM/qiwAgCEXnVSOgl5SOnlM9W6CCxROK1Z/+ufo
	3s/tCTS9tatPULAlNpLJcYHeM1PLxI4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731986; a=rsa-sha256;
	cv=none;
	b=ZFUzb5HYBaUV1J5cOyFVquAE/mpB8bp6VJjEECNaNi5MHCvxV7BEFfExTISCemJkhM7K9+
	7bTMVQi+zjHzZLUodghhuPE7qU5V/tMS9gegWBVN5soqysWuml7TBmxSXhkoqvVIKrmKgy
	BUCiJFNjToE5uu0a/D2qjQnf0C47ZjM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wTt8DodF;
	spf=pass (imf28.hostedemail.com: domain of 3UaPyaAsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3UaPyaAsKCLAQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-26985173d8eso53275045ad.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731985; x=1761336785; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mDnbSa/T9rbLxdB+UQ48e1HAUASVlE84N9T/ACVvI5o=;
        b=wTt8DodFhdYnbk5b9pmnBNCSK71HtgZoEMDO2T233Qf9N6sWuQhcXWZVSVbrNtijKV
         5el7s9vngOvKyaNcISQ3PKrOtKg0i8NYsuIJqM5wn9A9eIJng6hMOdYabZqjM9QntDV7
         NdEMQjjYEZGc37dyt8UdNuri4qRIBSz8TaTHm6Jn0snZu7DbhUjDGvOwOS/fQw5tBgbG
         KQzh7V/CMTJV2ckzAW8xEKxKcXrjtCWmRDs6TUvlkpdBV3IGhdsObTN7JjCsme+/eBnr
         ySrZePcDKJiELambWdD5gIXl/ph6d6kqA+BMi2zOXcVWPM57lAKI7d6v5rRgEtHM8K+J
         t6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731985; x=1761336785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mDnbSa/T9rbLxdB+UQ48e1HAUASVlE84N9T/ACVvI5o=;
        b=A1cCbPrUb3vI9mgsroyRs92Lnfqgvvk2BRiSypTz/vpm7XqX4OkorZPRt9nIxSx6RI
         77D5VJMD2AcBX/piLG17ROyMnS9H3EVBZuw/OJ9t8lTFbbZXUBYDfG/ZVcT5agO+fzwo
         CmAMqvZpfMufRIHSVUcVsVf2ZUhBkYLOxbW5zGDVJUnZ1jMLtVcPNBG6MsyxrGzowQUF
         1U7LSSJS12Gu2NNolLXrQrBQ+qs0l/vzpOEQ8SkPqjtGXUkb2NdGy+WQlcGqY8Jez6HG
         AweFr90Jyr2PU5Mtg7IEtG7tzy4zF4K09ou0X3M0WE9yNVsPT9hNSosEwh5Q99VN/N8P
         vntA==
X-Forwarded-Encrypted: i=1; AJvYcCW4gg521NJu6rzEFPALjkOujfvmGnRwc9hVH1YUnSWDYe52e5SNHfq7EMYBB/ykOukrfqH9koHOkw==@kvack.org
X-Gm-Message-State: AOJu0YyenDxuAcN7l6WxRHxH5diy4JCZnvi+JR9UaJQk+hLmZWsrBsSA
	sfMaytSWMMrYUcmUUFkc/C104yoz0vcr1XdUYZSHtWr8+crLDiY3DW+jN5mKmIKuddpDoaqM9Q5
	Er13Q07CrG/IwFymmIi9ZgG8/Zg==
X-Google-Smtp-Source: AGHT+IGK/mdDuG3ZSGIyaVntdExFllUnbaBOt/fbdQU/VGroSYt3OxnCk4b4pKyuwZyAug/4lKin+lC/nqf3X5a2jw==
X-Received: from plrt13.prod.google.com ([2002:a17:902:b20d:b0:267:fa7d:b637])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:15c7:b0:288:e2ec:edfd with SMTP id d9443c01a7336-290c9c93ce2mr47503675ad.10.1760731985255;
 Fri, 17 Oct 2025 13:13:05 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:03 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <ab6491c3eac047b8c0fd4cbfcb021e6327124203.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 22/37] KVM: selftests: guest_memfd: Test conversion
 before allocation
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: tki4wu77d4uhwmtmqzm5bzra3tgcukiu
X-Rspam-User: 
X-Rspamd-Queue-Id: 82E37C0007
X-HE-Tag: 1760731986-371983
X-HE-Meta: U2FsdGVkX1+zPYmzSAsv6VfCpoLn/6MOgCRlJeyDjqG5PM5zpFfrNampGIXuqkahL7QTGHfkCRQmsFr05l37OGJl5+Z7PEdnzZ6ihCGiQFNealedgTQT4xoFpOE7w3sMJjBx0x4lq5n5mNfOsIvKgpN9mRtti1dw7BQ5udjzjw53biEhR1VWVuBE0D2cZpxJQTKPueT9myxDPJ+fSm8BQ+EYVo7pC/dcvbHZlDIXjGBPFHoIxyuLhEkg09aXhajsJD7XsEUlZKloYBMjV4tzlutOj8eqx0E8TckeQcq47WzMiYeVm7P/t/eWiMwY1wA2XeKHFYj6kUH/WNh6yOhZDamyIuX1bcOM66TIUA4tDCrPJ+vre+YolNIZ++gdyBc0o3oDb6WoHbheuXAFI9uSlEddkQUG5b6khz9gqPxlJ86H7PpB5tWQZaRENVI3XxeNrt2jHbu/lDCOvRVjDYXl445EPtfAay9D6p8RqCKs5mnoEN3xOivLXNIa4ag9a2M0upTLEfzVPfyq3NdR0kZtKHoFTqo7Gz4sMvFmS5r1S+xwrcI32ppcISoHoWX2M+GnC36kwSDLW9sY1L4vMHy+ZqhrCubvWK+ssJnhd3NItUUoI3r97JCFNvrHnkvwve2XnUXabvjn3mLQ95ndMwWH9R7V3iTl1eC1fcD7azZaj68AcfnrQFfcNayqLiagtLtoS3QxRNfJPjEGYsODz0VKa8+LjScboLfURUMJnDS+txO7gqxtjmmgf5zJPBHuxzlsxt7l+GCZN8ZuQTk30U+PsyQs4z0WDpGUofmTkwaRsJy8cz/s2mj1I3bri41WFigLGItsWfKECKcM0o4Ut8XUooh6pMcVVv7IG2U2c6Lk/ORNZr3EJvomM4lNzWL/p4sa341ujIxc/+0S/B+BRP0EShDcscR3v2NH99qEd0SRIfi3KOJj7qe7gl9C3Uy+4In+CLLf1PkAeleRQMTQasc
 OU1s9TCI
 83U07CjCPXMOU601wv7RGjnhs6w+zHQLIou1Q2tMgxOGlww6FJIcmjrcIsdLk5qisuEyfnwfu8AkK4KjyuzzyPHOrMpnMRxrDV68Yeli7KD3UAE8Fn6ndCyJBQ8w6MolStLR2qvP7H8ibNq4QnqNi7HJgzi+gZ1y7iDQVGMvdDLN9GuSrmGzVmEcKbNdj7lMYrFPHXB/T70gkQcQW3+qXh4HbHNSbi2xHYXNL7LxncZJqiVTNzCRUde3JYdDTKiwZgpo4TDR76Paeim31hWHLNE5u4TK2NHHMCFOptvzgYDE2jAOBPaTS65BxmwqyErFuCmTQ/RRZJi4APc9NxfOYvzlpaOMYejYOhZ4TRob5rJzR1s99RVnF6NtxDEk3kHEOb9FOIa33K5lbZ/ql/JOjMnjmDLRR/tswHxswu2F4MpO8hGdja7I2IieXFm2O7IMfUQ5ZVX2MYuIRo9sWHrt6ijN4Ftw7skbr2/iks6AQPNgmRP1Z8upGxcajHzjsLfyOaeoKST5mikRrNihIPoJeB8t7qPe0jVkLep98Lega6Y0EkBhkHmgFsEYALG+b0l5j0Cy5A5WTdbukR5lm3+p5xfW6VXcSBgjP/qUObhnCJSVSGLxnuKDurwsxJg2JlwTNhyOKO35Pcq1busQoq3+s/+4arWgIh85bfJq55i7wLnZZvRoDpH7S4B52vSpKFto6n+dY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two test cases to the guest_memfd conversions selftest to cover
the scenario where a conversion is requested before any memory has been
allocated in the guest_memfd region.

The KVM_MEMORY_CONVERT_GUEST ioctl can be called on a memory region at any
time. If the guest has not yet faulted in any pages for that region, the
kernel must record the conversion request and apply the requested state
when the pages are eventually allocated.

The new tests cover both conversion directions.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 54e7deec992d4..3b222009227c3 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -263,6 +263,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 	}
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
2.51.0.858.gf9c4a03a3a-goog


