Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0132CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7419D6B00BA; Thu, 18 Jun 2026 20:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA2C6B00BB; Thu, 18 Jun 2026 20:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5442A6B00BC; Thu, 18 Jun 2026 20:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19AE06B00BA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82405140146
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:06 +0000 (UTC)
X-FDA: 84894785052.01.438C5A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97D60180002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQA+w28p;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829124;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFaSO3im0CD5pnTsV/WG2zE8r3yZ/m02PL0J9db/Rc0=;
	b=rMtm2cWROQOE5NyxakzKLIghp3dcY5vgXzoX7b2waqHh+g4Ed9MbooCDZLyGjHUKalS7FQ
	csnOTyGCloS5TG+KmJvhfNTSt156fkgA/r0APAzkIG2uBXd6w+ElPVfpoV6Ci+LovFbPqE
	Zgk+qNq3W75vVEpsbxYefBqoLr7J11I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQA+w28p;
	spf=pass (imf24.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829124;
	b=RF4uIh25f21hViV3eWUajBAxg9lVdHjq+GvhQGV6/0nZJo2Jvh4n/yXCX2L6Oc+FRR/tPb
	I/We1ShbLni95MXKKLSU4Qq+AnZ3q4hTmPr9SeH4A9OXt2/8WDvKr3gAiD3qx06a/7ugJs
	zuAS5MYBSKpM0GH8DnEpWduHIpNqZCc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFE6A44DAC;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7ACE9C4AF0F;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829110;
	bh=dTjvdbldo6HKcpb1OVxxxBSBTPhC9ZG8R90oBObq0WE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PQA+w28p4YnJlJvePg3QGiEXL9kSdUqaoXOi+UNbVWrQEFZX08cr47rJH+9Kxzs1W
	 xMzzPizpzVa4CfxhT0J8pKdqZJawnF2t74ect6zqfadfCBm7lZ1DpHCE/vaWuAbb2h
	 8pmYRGiavCb7eLTGNMYA+8vI9KX8zNCzh/nfTIhe2Xs/rLvhgZNQX6voT7Df7Z2/sJ
	 v2pEaUlSrU8ZhpjTPhVRLP+Ezhe8aNjV/8DtdITz3GVI8ieb8g6o87bAcL6EgHCOq4
	 paVq0uCP1jSXo+0BKRfvZjobrSZNP1Cwxqe6ZQU3lA2d05s0BWU9kb9sG7AS6Wp6wU
	 EYjb/gQDcMijg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F071CDB464;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:12 -0700
Subject: [PATCH v8 35/46] KVM: selftests: Convert with allocated folios in
 different layouts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-35-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2233;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YB4MHWioMUMOBpaWhCcoyCgc6wLuvVO37S+IBwb9CKM=;
 b=uDlxhnYV+YZ0oFV4bZE5+6ERknddzJH9VyO8hwGfyeiMiR2/Nz9B2wZrjnFmwJdooJMnrwTRF
 gyNJQjqOB83AUiB/WIBt7GV9w4CsJtjV6zH1i4IUiFcXA7ve0FOgMkg
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 97D60180002
X-Rspam-User: 
X-Stat-Signature: btt7x7diwc3r3dgxtxcp3iy7sipwnpza
X-HE-Tag: 1781829124-375173
X-HE-Meta: U2FsdGVkX19PyVkNWKyvLJ0Pcuv0Hwd6+jKd7uM0FxKtqGs3Zqy7qfzIvMiTQN+if46t5joS7QQprbUHlJHB9Eu3kKmU4NFowkJO3HhyP4+L1yiYAHw3LsK2iuba3AAW4RcLpJvEqpUZHvEUDZTB3X9BSKrZDaHyWv7dPr2dGDYa0ChzC09F0WYFjBz5/W2tN09n5W9a7cJC04Xt6JYOmqr8nJyHOKe7tJ+KrcJGJX969cg27XaCwXZEuK5/VAGr7QjP4ZN+KeUYl7jhd0CIxaOVHSxe3gYX0qwra2S7R4S0dbuwcT2X1WlM7fGC1JpPErp6FZ5xQcB2k1Sl6j93sm0U43v+61Aosqw/RuXqjViEn2n/POVDELlBiUiWamUFO5jjolufrjSVFHZ84gVeGOx19bAEzb57toVmP2NL84FS8csjbuysP0aV7RVYz68MEsk/vAkyMKXG/jOXe/W53/48cl31F5yyCtmzJoBKvxLsz2EljqYkrXJTrh3c/CFLj1nj5eaXOQ32aDYMZsGVK8nqLUExXJ2ItfqhXv4XrBowdPrJZyvUJ97U9H63K2UJ/ZfS3one8efsdpaOPk+sfK8XodJSdXHC2uIU2J+lhUsaK+Vyx1g+pgV49i4nD8yngQVy/kEnEjYs3lBzvyEBihtxyiVUn1/t1EucoN4NaPsnPQY6z97MWcuW7uBnOCM++OrdSuDG0KWfPVsFNUjmCsjx/GBGxoSmHuFJ400kwsVSPM2Ptu/gT7bo2rc3WSK2pcDuCQVBcKWmniIiCLjHRy7dxU7aeNY75WkbYD/AWxN4R/ogrZbPvl+NyHGGLih1ZCTEGrFfW38axFnQdioMu/BjKvgxTlc+ggPloTZenJ2fyAa9vf/JUFSgnjnJC8xazkter7/xaaQ2j5+E3kZNLOj9KDsSUEcja7/+ipbgNQk4FmYLv5XALqgjuuEOPYRsupY/DhVRiLXqQ3RUBCV
 5qfMS2E1
 hiCbserMYYundrlPJjR+NlZ9Ry1pzbKoQ9HxeHgDzHearCG6moKQBycqk4q6/sz2Snjs19Xqd6m+V3YvovaoXDvkKuCybLIu/VjNtlSLKjiph5Qqqdh4C7HzCI5lgEzpOrXpVq0y7UYbPI625q2d8EXIpBWueNBM18/Cv6pb02qfTyhJbS5NyRFDfYMRNONxxFLO2zdgLJJ/fPPrEP3JHKcrYJtPtH4RTfxhIJVuFv7B6osMDotTE9Y7WukLnwZzouRzD6wMN4I67J7kK4jxUJ2tlGocHwzyqZMCWoqo0C4sdW6isezUz+484CAPihWhhHQE+zXV4dSX3YG/SbCDUFR9HpBhST4Xvq8wDUuG+Yxx9KSKY6yz3VJ8RCmbWV8r5R9XDlPHGpAJqL8kOX6kmCMrlZtDIhaPageNMzybL916Z2j/0iF4nzNi37C2XmpUJjRgkQhOjkib/uHU=
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



