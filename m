Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6828CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A7E88E0006; Fri, 17 Oct 2025 16:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831188E0078; Fri, 17 Oct 2025 16:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F0A8E0006; Fri, 17 Oct 2025 16:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 352378E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F26951402D7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:09 +0000 (UTC)
X-FDA: 84008705298.05.B1BF8BF
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 32317C000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1/LVnyxM";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3UqPyaAsKCLERTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3UqPyaAsKCLERTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731988; a=rsa-sha256;
	cv=none;
	b=n/E4sCDNCr24AFHXmc0+3ExjVujDU+tusofjEzEgrB43rCsvz5d8+a8vxq6oowrEPLe6mP
	9Qb4RRXyIEAFInuk9JtwkeHEsbY0TvUuW1NBVgHRvanRhBwlXWhUhkrn6eCxEeDAzAeqtQ
	3Q+Qt0hWgDE3t4WnyLE+ULuggpD2HcM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1/LVnyxM";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3UqPyaAsKCLERTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3UqPyaAsKCLERTbVicVpkeXXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zq46JIno/oLWpmCm/slZY48TlgDXZ3V4yLa6+9x6pNY=;
	b=QwaOuaBUslHlhdWD+vSD9rT+M9JS4ZwTYpmGmGPCkiv9reTsf4UvNAyTnjERN4XH43hhZx
	sFLwJvN98n0OxBeq2TGsj5Gan4tHMRDVZ2Ogz61JvopMuG/sJMpRdF5ezWGA5kykIhqMLL
	3vgCVTOJSGwytAvbY1EtnqQlgaDHLdo=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b60992e3b27so1728270a12.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731987; x=1761336787; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zq46JIno/oLWpmCm/slZY48TlgDXZ3V4yLa6+9x6pNY=;
        b=1/LVnyxMEOl26WeRF/lFLcf4+UwcxKQilxf3gH0uPmYVShumqZWluXprWpKFCQAeha
         4UkCmJ6EiFtNO3wcdm2mRrSgx3JJPRxQyfqE4F6d7nlF+YR10bR3lueE8YpKdZa1MkON
         19c7QF7/20pVueR8K7T3tf7vADTb0DrFPKjAQcYMZ5obuOqVzAS79CqlfpqLKtbLFawR
         ng38O2zak/XEY8cx9vXwDTqSBJ38lL58NHMZ7eWCjBSnOQAcbwopzxRI+0VBbZxIE42T
         aECkybl8++ufva5eNfIpXfFrzWxpDgPX2tq1SflvhnS6g53AjLiYh8sSC94isUdevY/h
         gljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731987; x=1761336787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zq46JIno/oLWpmCm/slZY48TlgDXZ3V4yLa6+9x6pNY=;
        b=QZh06D/TJvVNwjSyOEXGPHZJnb2odBQfxMXKQVbFOVV/5ETFIRJFc0pK/f+JqIXsod
         YF5BqUoYM94Oj74185IQYTcyulAuZDCapztv8C64zyQmF75UJYcQc/hYoPOFlmFUbNKP
         jfGimq7665Fy3Aqdo76/+z174xViY0jk+ey0ccXRALfwUzEIsMMLj63RCR2i1tt2BwCS
         yUnVr0nquA9gAnYh+AA2LnkPsJtPjcExXlR1qkG9pcb4tDoQSTXRm0kipQT1ugSJIYlY
         2hMtKq6BewQGX8pwfa+6vO7oIe41x+U4sTXKOhl8zIC81TTUwDo/gnKqA+8r03G+IZDa
         sQDg==
X-Forwarded-Encrypted: i=1; AJvYcCXckQnnAd+6AuIajQ1dReiB7+ZCXbk1oNfG0gzd/Rv8Zkz8oQvmZSKMJbCzJPmDRCsulePAKoXylg==@kvack.org
X-Gm-Message-State: AOJu0Yy+ahr4ZMz7GM07tH0l1l5ZW61oCtsys8Va5Td4gSZBYgnnAz+A
	iCku2LelvDBs2J+oWYsSjTcENHkozwbn80fR6Tyw+LNnwIypIG0PGOoNsUODP+XEEwPtc9KpZNj
	BuX4D5mGZw+XCBRffswZlj9lvPA==
X-Google-Smtp-Source: AGHT+IEZvVijCkEAJRKnUy7ymqg6G12dNVURbl0z8Gf3KQzAlruU3kdFR92+1c9LGnwkKpRrDoTHA28pQbr5qtGv5A==
X-Received: from pjbds19.prod.google.com ([2002:a17:90b:8d3:b0:33b:51fe:1a84])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:158a:b0:2ff:3752:8388 with SMTP id adf61e73a8af0-334a86108f0mr6621028637.32.1760731986801;
 Fri, 17 Oct 2025 13:13:06 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:04 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <2b96afca4f21b82fdce307d6385a6978b78b31f7.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 23/37] KVM: selftests: guest_memfd: Convert with
 allocated folios in different layouts
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
X-Stat-Signature: 314ohxgk1s4wcaaghua8aa9a5iudsdjt
X-Rspamd-Queue-Id: 32317C000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760731987-355386
X-HE-Meta: U2FsdGVkX19P/9VWGNLZhR0rDwUuHnZ3wEB1TXr/Dg+Ezna3ua/i5QRRkVwqRBMu5StWjQU4+koDzugxLAcHxHs2w/Fre3mJ+nvp56mPLHiaZyazfLr1kWW3GQvhQ8terQQU6pQ5zUniy3mKHFfPNe0yaVVTQr+7McQE6HISOwbAtvUfn/mDuqRQnvrAQICXu3nvJPD6rsK4Tzf7UFE3JQNOZcbZEcmUnGwimvlTk2bAlvIAoyKnbaZTdKIQlGMv3VI2sXSUtIU8jyG8DH8EbJT6uPeH5mioV59+M3oZYdTFg23UvD5sEiBNZa0hjqL1Z7ImsbD+xMWdWlDGr+i8rOIcDuk52PDQ/S6AJhGYpFSIo+rROaqqnxbfJemdEgogGtc6XlbqrruzcSExQd3O/f6BXKzBL60Hu5J+2IYOhsXJdeEyp2sgj23YxrWULGdI1EAQy3/n3NMIhlZCZTzA3rwVUXuoyO9ny1eQMUYB7hgmSnsj8LwbZrw5S49+N8u8mONcz2wNsOJuDNjPvGqvBIorxztrwv2NKWQvdi1Od5Q9GVzX8xKyC5dD2nyUh7TNL49bfZNx7O+PM9Mz0J6Uq626pG9fBVM6D241uVnSHNciPeebYh4ov3aya/inIb7pMvOwMYl7U0QjttEBJ0o+E80Jrq9Ei3Is9w6dO0W9BM0FoqZn4OafyXu2hzc7Zl3UWIxeT7Df4A8tW6jXqJEmaEdRPeqJAppUg4hCiWYOjdQlQUo3cEiiA5f8z3RAOcn0IefI8r8e85CnxtV7lZl/DuK4W5+bqmgdqSPCTU2DF/343hF2au7JQA6ghM5ULaQQxVcHJnI22beXW9y7fOyjrwIYKAXnE2DEIOLjcQmimA+mxM7f+XWIbrA8JkLlA4h3xl59emAIYyoKAEIunNkwCZkGwQvx8iPP+duElskUyf4Om1XmBko/bBXnPaUOvntfqG6Q2JX6WZh+85FGUdr
 G5fgowTG
 +0goagiV/xwMjOU3s4ysAkQPW57kcIpNy8GuPBjgSfAXvrwOojmm2jOVZgxl9kVWWj/8jl73ZLrGOujgsF5KI3OJNnYGgws26vzpWkVj/7IBgEyh8mA98euO/VfcpgYTYFCYuL/VTe7Dsg347PxbIuB8mu0XcVtunGNAJ/XRFVH0Pts592PlLu76H5+iz+t83Ai4dzmuklUOHcLgC1Fj4L1UN5WliDkXhElOyY89v2wdSo6xNPihCxmWH4UYd/maU+nulPTRlC3yUEn9tJv9c3P2fVQ55YkqO96szSfK8pgmj2SAeb8qjmfRjwsLh2y0/aFh2jBSi5EYvhaht3WY65FnjEaq4mOScQqln6zb4l6EsWk4SCRhNiq2LLONJUV3NNFqKRuoNgeBxWNDxgAytCMNkkAbNRnd7KwgZc1e0FaWKss4E9TJqiBMYWTKcmvv1pp9vxZGv4hX63m8D6+bmTMcBfAi4fq5jpvrO/E8hcRi3fu/q4bz90oVSf5O7zYapOAiUp0Q8MCyR87m1+DI0JVHulZLam1wpoWXpRY1lCvB/caXI9rEzCsBpr28Br7AEphJf/Kq3+eXBsfzt+t/yJcmkNW6JozGFIj0yum7PZsaz+FWlOSFVyty9Jm/a25/URVE3stX0dpK7SUmVU+zXuNzHmgnGkC+1NqyWdFB2URXaqW1SxRnQYnck2LMyVhpv7cxG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 .../kvm/guest_memfd_conversions_test.c        | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 3b222009227c3..b42b1b27cb727 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -277,6 +277,36 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
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
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
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
2.51.0.858.gf9c4a03a3a-goog


