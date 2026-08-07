Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C248BC5AD2B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75656B00E7; Fri,  7 Aug 2026 17:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4AB66B00E9; Fri,  7 Aug 2026 17:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12BC6B00EA; Fri,  7 Aug 2026 17:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD366B00E7
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CAFE1A0165
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:07 +0000 (UTC)
X-FDA: 85075824414.30.6D50F9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 013C11C0007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IlYmzrk2;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139585;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TvNeEHIlJhXedQ+RypNvSHDFKZVXxXxq4VXvERxT1wk=;
	b=I9i7zAOmUEuF5Ee4B47e68OMFEkh4hVjCpZFp7DzKYjvZj1aEsF7C7bB4cShWUzYQ1DPLi
	tN8W2rGiT6X3nS/ECO8+YWeoJyi4HMrQjX71l9dlTEQfKDW9RKfbjUSQGuCEQ4S1O2CWAc
	qcpAiE3lZjjc7Nx4FeVSXbv59uSDaXY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139585;
	b=pSWW49Y3tX9/Dfz1AUIBAXEILe2059ibTs/z0a/ZIp8JKY5PaGuf2QJ3jVMS9txUAT/Ncq
	R3TytLGe6Cjh7LsBQEETVleYt3pfeQ2xOHg8VVYVeC8XKsG3Q7E0rSDh/qduO8Y5Nmsnlm
	2pnDnVa2k9FV7Eqi+yHN7+K2pV4U/2A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IlYmzrk2;
	spf=pass (imf21.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75FF4452A1;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3646CC4AF0D;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=WDKsrZiZJlDXKakS3Ne8GBtkCp6v0E/NVwWuKGbd0VM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IlYmzrk27RXsohQeDwRNay7ZQU+ma58MaqvkUR9EW6lcvx2xUS4XrNIJUwzLTlarT
	 aqPlOvSgc2XFefyozygfmHURJp8Hqjf8Flsz15USr6vMGrKZ+zFqLkcuC0ZrnzP3Zh
	 /EGnI2gpnuhIpOblMaq3ti1l1eSDUHa1F3cM5p9dgLtD5l751WcPmGq9RL64E+/vdW
	 B+UtrKeF+RrKIj0yuqvd6ayBIKXKOitfjCDXSo9LG+iGouurFk1igNwSeRQqJTIbk9
	 c2PNXI+I16j1HLQ29YJKRRZ+qqsVzhTN6Eq3e3NA7L/EUHRsIvg+jbtv5GibwNXTZB
	 uHYMdDzpcfuPA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FD5C5AD2C;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:14 -0700
Subject: [PATCH v10 35/41] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-35-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=3125;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=p2RZydKvg888n0XoOUjxbRa4guxOTSCM2qo+J0sXmYw=;
 b=jhnjesMtPkRy9w4qr83aPYgjzv9dcXLfod9ioti8LuuCqLHmGkcD+pPXy/JArMEhXvYNmQKjh
 s5ce18SW2lFA+PIFSNYHYakT4GaWXk1LNmCYqBn93k3nIj9DmABvRo8
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 013C11C0007
X-Rspam-User: 
X-Stat-Signature: i67dbnb1rddmr1bpsixcshzfewpxysqt
X-HE-Tag: 1786139584-762872
X-HE-Meta: U2FsdGVkX1//0GrHqszao7UodxYoouKh6Dub0F07tdPNtGTYj0eXtqg+8T3auzP66K3/WzJ83oHlNtJWkQa3OmcyoNiF9nC50aXchIt+F8JUK6NLK2mL4KOj0HGJQVr4dDwrBag9btcDTliGu4GKu2woXZgRRhrSa5rHSmJt6xX17gW2YwXPFtJR/R85Y1RK0a+SWGOkUVVYBtXL1KUsi4nvwJk1xmWblwLMxHX+hI66cZ2gQuOYjZCTLTVRapYTdhilQxWsy7P3YT0VFoUAdjqobZ+98y1dH14AfHWD2JfYS7JJXks/56vR8OviUalCp4W7cW89GgfzPJ+xzc8FtPlMWXg125aLIKh1Vdia124tkGeTF/j4pcHCrItvAtgJSXDlnSjxq3q7MPNqG4kMCu49QO3wHTvk3mLybJjU3Gxrqr2DqTzJ6PtGOH4oTwwMhQw6qiL6JFjQ4HvHPLvPrU61jtIa20FX7xoRLEfeJTRcImvzgw8Uo7wWbhFy5K6IHXfha+t7bq2V1mwQzkmJCUQ3WV2xHEFZVAKsPk1uMulV9F9uGE9/+PHCsBkICxFPz7qExVOGdDvyxks3+7EEbvrJAhF8fu61uTzkYg7g9MukvpA6pGGNxpdHbcZG3SMvs8ja2PqBtBrI6gsG+TH8sZDww1yW+pQXNVMUIaXC+B46D5RlvHqz+vN187SRQyWXrAnWqUteoOpYqJPjvSTisUMvQYGhTv2bsmOLcnP6vyh8cztWt30fQTvqgHkct/Gky2fgCOouUdrsLolqGYyUSs20WfbqlCNzeoo8CBCdEA9pZi/GaqUZJ1oNVdTrmpaBuqHWk00X0K6TeppPStgeYx9Bs7bH37KFTiMQ4t9jqeMCH+1YBJBpvwAr8ck7NOyTbuf1S+shw9xSjy19oVXFYRESMuZoNkVvFfVvwgWBUpZN16RanMN1ehrxTz4ofS7eNTwYPSTSX4HWErMOGV4
 yBntj4XA
 aqEGgou0pt7pwRxfjWuNYTBlP44/IX/V+ncsSyYJmPDUleUi0bBB+IEQOUhx6kG0y6fdh0pEInB/RcTqzweX1TGTPFgXwKOw7oLBBtn5p2fRtB237tBsNZ4GBYEeKucDIbZSre3SY3ey0Dvw9lglKsdgV6FYb/oJQEHhxLnvFC9C+v1lVSda9vaePr/LWRhHGZ9FmW5SNp/XBpqd9T0dwhjauRDsiD8XMI96mEEuYwqqdNEvZ7RKKuFw7NOJ5pyD2bC11Fz304OowaTGoTLAySFjemBO3eNVMmKlronBb9n1S9XGXw6M6JXHFsQCvbY5lEU0ez3qVppNmHFHuJo+QWkk3Limxbm3gDH1FE0Kfh9S1yUaH21lTypRpZLVCHQi/2v8P8hZxiDOwpzOjIRKrfoJuNXV2dbSFbgx38NT/yHtmHHxHr4zs4NO80HtR3p4nFEaHH3czObbi7l5qkFqdCiESxYg9Zu9ei8IG7F4qjc6T6yuATR9Z26uWQ/cyOlDfod2dA571KOWu6Cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a selftest to verify that converting a shared guest_memfd page to a
private page fails if the page has an elevated reference count.

When KVM converts a shared page to a private one, it expects the page to
have a reference count equal to the reference counts taken by the
filemap. If another kernel subsystem holds a reference to the page, the
conversion must be aborted.

The test asserts that both bulk and single-page conversion attempts
correctly fail with EAGAIN for the pinned page. After the page is unpinned,
the test verifies that subsequent conversions succeed.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/x86/guest_memfd_conversions_test.c         | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index a972a09c5c6e5..e1c84df0f0596 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -444,6 +444,62 @@ GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
 #undef TEST_STATE_AWAIT
 }
 
+static void test_convert_to_private_fails(test_data_t *t, u64 pgoff,
+					  size_t nr_pages,
+					  u64 expected_error_offset)
+{
+	/* +1 to make it anything but expected_error_offset. */
+	u64 error_offset = expected_error_offset + 1;
+	u64 offset = pgoff * page_size;
+	int ret;
+
+	do {
+		ret = __gmem_set_private(t->gmem_fd, offset,
+					 nr_pages * page_size, &error_offset);
+	} while (ret == -1 && errno == EINTR);
+	TEST_ASSERT(ret == -1 && errno == EAGAIN,
+		    "Wanted EAGAIN on page %lu, got %d (ret = %d)", pgoff,
+		    errno, ret);
+	TEST_ASSERT_EQ(error_offset, expected_error_offset);
+}
+
+GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(elevated_refcount, 4)
+{
+	int i;
+
+	pin_pages(t->mem + test_page * page_size, page_size);
+
+	for (i = 0; i < nr_pages; i++)
+		test_shared(t, i, 0, 'A', 'B');
+
+	/*
+	 * Converting in bulk should fail as long any page in the range has
+	 * unexpected refcounts.
+	 */
+	test_convert_to_private_fails(t, 0, nr_pages, test_page * page_size);
+
+	for (i = 0; i < nr_pages; i++) {
+		/*
+		 * Converting page-wise should also fail as long any page in the
+		 * range has unexpected refcounts.
+		 */
+		if (i == test_page)
+			test_convert_to_private_fails(t, i, 1, test_page * page_size);
+		else
+			test_convert_to_private(t, i, 'B', 'C');
+	}
+
+	unpin_pages();
+
+	gmem_set_private(t->gmem_fd, 0, nr_pages * page_size);
+
+	for (i = 0; i < nr_pages; i++) {
+		char expected = i == test_page ? 'B' : 'C';
+
+		test_private(t, i, expected, 'D');
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.654.g21b8a5bc05-goog



