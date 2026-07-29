Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC936C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AED06B00B8; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7108E6B00B9; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589126B00BA; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1838C6B00B8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADCA1A193B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:23 +0000 (UTC)
X-FDA: 85039945326.14.012407F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD0D680005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PVKmK3h8;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285321;
	b=z+02DlzI9PNgYucJyiqdq9fOn89Z9UiOvBvpV1Uq7cYNmBiBUirBq/DNe0KHmpqFK5pY19
	/3KvSu/LTX3n1xkalfD7i1k1GMys1FG2dnqS0BX/pXpsxbBi+GrBJVLzI8UcxmkUXG3m2W
	PqOtZCADrEDhMhzd0wgnAu1T917wHEk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PVKmK3h8;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285321;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIjO/J5qkE8ZF6VvyKjpdxlslOArgK+YxoV+3YfG6RU=;
	b=BXrZ7v8uIxH/zNVmu16JV0lTF64zITYg34gdSx0cSlEtqLiQRfUTEE3tnj4BYgDAMhGaY5
	pkJNa0bgOTzNrUgVGY0KAQQVhcZdtIOLLh6j6DnZzg9Ju2sBnsF4HlX4+b+bXfOx31hHf9
	wHPWqUhYZ7GXwGNF1QknTdQF1T/MAmg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B777B452DA;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C314C2BCFA;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=JuvEz0loFWZO3vqfVPsRy+gK5FqXHMStrsT//a/BlPQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PVKmK3h8AhJJ/sN2Ox6bhekGJ7AJqkGZln4Rg8L4vt6srUHmyPXPxbo917zd6zmcA
	 GeocWYxfn2V6nDJvu3w2Om/W6Lq/6Acgpc7D7+KhTSsb3cuIhI/gb8xFFixhYHw8pt
	 cs71cG2s5i2fzMfJ5HNpff9LHQ6+s56HvzaLJX+iRtUABa0pTqI8c/tJmsWcZXBIm8
	 +KROeWv8r0fNFStR45ckg8ZdHAcAz22ASFrw3U5+C5vr55coSGejzMg47RECOX+ZBL
	 a3Xd3JdLoH092mAE5cfaIvBTd8J4QT5L/k6BoAWBksZ6M+bJD7/wiHC+k518JBaiQk
	 3FwuTAWdDENXQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438BFC54F57;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:30 -0700
Subject: [PATCH v9 31/41] KVM: selftests: Convert with allocated folios in
 different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-31-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2317;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=WkLey8yQx3OGBDsexWHIgLsjEWvinSfVroxJ6rEhjbc=;
 b=DxC7wo6syGL1l+hjAxnlA0vq/Et0LhjDJCn9Td2x88Y0/BEPYBx2DhTTNHHadlbIOsu06bHJJ
 CNCZM6SfCX6BRcPelx+Rd5Dj8joB5XKxSDDG0O2BWR0EVr8M9hy77vi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: mubnxj5kfcg5arm7qbat5537gmqbwbfo
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD0D680005
X-Rspam-User: 
X-HE-Tag: 1785285321-89318
X-HE-Meta: U2FsdGVkX19mJ0rDrM2eFKsFsSPTgOU+Rs2Vy4r1Cq8Zw4BjYdflQ8mJaj3jftKT/ImPWCUrKxm0tnbVt4T59XlGTVLnNq0XwEnkzOLekSiLd5n1636Fx67h8gBZj9kN7NAhovV8WzXAGU6C/rf4nAxmeHumFRi8B1+j9lqt/fBGR+r9mS2dSgEGuAj4g/zTq23FqDdHebqzM5nWjqc3TZPWwLdWbyCsLUQT0z7D+Kx1GictK2zYFengGms5oSSOlqZRbyEL/uYdZAhtQnej0Wpd2cHcQpMxU/gC0T5LceTnh2ktZaZcksDiQVAAa6BNAbBL4+5pgThI/c5OpnyPTZJoZiEEUqiKq91e6Afna/3WyWjMYe06ona7VAxmZ8JXEv1pC63dHvGHPFy6UK5Njb35MBoRqbTYCLsmNNeAaV80j+k3jMJ10JhxSmRMcFUlUOkZUYiZJl0TkS/q7Tm7rPgajtp96Pi2jZGqlz6qKu1jC+JwMgd7jlbDggs2R9ZdSkDkQBVT2Nzc+Hqaz1FqKzdueqZQZMqgTKzw3kEeVxjX+SmKs/RHitwIyl75J+Rhwr/V8t3patGpT+NNIEMaAyv+64X3ErUN4ln4Dps2c1TgPmwfpCspQY0UsP2paixil+sp2s+43wr7ekGZ5oEDgxt6heijwrpOMM37mSOlGlkAnezH/yLzkk+ibo/AHM28eYUpApiDNP80qYr/2aJADWOxlyo9c3h7ZeXbnp3UJYP41Q9iMzQmmjPD6jEpyRpzaWsW8HO6PGsYo+3V+g2G1wxzE/5hxbi6YlNL9lA0iaq4TnxT6uM1ZfoSEcsl9S8RB2+SkZi8xq5oKBuFOhFUyiLII3HgLhtK9h0Sl2KQrk2lg6p0XS7fFLAmHr/uoOFehsRRwCvT5IsOX/wvZIxPkg9o4AkxFUNOqXKIIw+OOfVTW7H6bPH8dwL+9nFycCIcWUlIcKYOnjQny86OHbh
 IpVCtX/O
 L99/TUQLsGNKSs4Nj65nZrqgFQAmTXA1tjX797kLV6z8PyKQZPfKSogV8As8RF7rmOp7LUewdvLYMIfDWvXlrXJ16KzYh08x26s27m25akUuiJdaf/eqtNwH87dUHNVh1kMq5dJEgS+Jd3ptXLtmez6CvmtSw3GMlhdSYccuf0qprCpA7VCSn3g2f11j86SzFEfRwBMM+/kkn5oeNhXMQ8rwVwVkIu6hQmvinlUMPpUE9WKje+0BgEBZ0+fDkT3SF5bfQcoqTA2qVAHHuU4ak0abaUFV+2yhnHsrmDb3QAsai83J0AqyS2p3JhXJMrnexOSSKfA76HnxtL1czVNHRAXqfoIMoxHsP5DY0bz3E7z9WF7JdJqHuClogR7duEFpveeIdPg5MXc9ivDb2D+alYyPKQJ2TOrgCW3QEFSeFUB8scHkK99779MwA9UoxM5wwIkbPWfnJAMKStMxrzC9hEONG8s43PgC5YeE5IAZxLLXxn/CMZoEsh0m1WdYB/zJVYvxjGkM4PjF68r4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a guest_memfd selftest to verify that memory conversions work
correctly with allocated folios in different layouts.

By iterating through which pages are initially faulted, the test covers
various layouts of contiguous allocated and unallocated regions, exercising
conversion with different range layouts.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index b43ac196330f1..0b024fb7227f0 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -279,6 +279,36 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(before_allocation_private)
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
2.55.0.508.g3f0d502094-goog



