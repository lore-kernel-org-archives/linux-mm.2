Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB5BC61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC386B00BE; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CE56B00BF; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F63E6B00C0; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 489E06B00BE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5CF31A03CC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:43 +0000 (UTC)
X-FDA: 85159671366.30.945AEB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EE0F620003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VMgK7Pod;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135942;
	b=CnpprfL3QQpkZo1bvgUhOwr6jN3TadzcWLyCaxdxJyB1Mz6qjbSzMO326b41nH76+4DZA3
	y1c6kwKyKOzxA7SADIEXVESW3RR1rmHuSUHVO1kNjT/rYZtzPNLcbKkRNKCnoR/fii0pD8
	DrzsRQeHk1EtDwUtmiSr/GlqviW7JI8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VMgK7Pod;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135942;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7Fr4dUX6kmrUNjIObpTBsRNEK3imbXEck1pfH1qH6s=;
	b=6Sw61U4ygqi4tYaEG1vqOXe9w9Uq3XKlacfQ2wtG8sYPC/R1X5kQNy+waDfR5Q/lSqxqGj
	JKV25PKfDWslMjrB5jmFWr6nVAyQ5+mIvPtVLCbFxfCi6VGNTu9ABpswm1RegJOYfss6rA
	j/hFq0/u0xdE/hq9ory3Enowwey8rzk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1ECC44789;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86D82C2BCFD;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=O2ZOrSXnl5WNaoxX9Izw0ZuqjNjEJYMBQDu9NefBE4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VMgK7PodQ4QUM3aZ/tkqaqvCeR1qILhFNUs90KQSNnouXI2p7Z7VtvfyD11A2V10l
	 02KvmNS6INKTPvVBKEb6+aN0TWqoqYsLWQ6VixcHsGxR8Kq8u5ySUS4Fk3ImQJ+BL5
	 N38jzh8BZgOlkeTM3qmzhE3Nszg2NVfTWPfww5ITdf1lLG0++zBSfyBao5wYUk0B0G
	 eRIeKfuPbFl7+cXlxzQT81WZ/z6Us7fAVoPfJCgXZjCzemRWKNvji8h+JryXaDdVVC
	 kBY0gSSsl/zvyLqzTjvW14EtlDSYmR5BN46xH28GKcFbRGyU47Pmx/B/Dzi+YIJPLk
	 oTqkRfqDeIGVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0ABC61DFD;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:39 -0700
Subject: [PATCH v12 38/45] KVM: selftests: Test conversion with elevated
 page refcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-38-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=3125;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bdq0ORBWbWV6e+1Lwjwn03V1TzR8SfWSd/UMLobub+U=;
 b=NnP1BZbu0N94uPpRBk5CPXpMs+ccxDq0jjhSkfmKYKGqoRwJkG0Eihwb83HjkVPFK2YhDypLb
 uOdQzcWiUHlA8CmSmJnSj3ENMc7Qo9hZ3K2a+vP+fDkSUwboGAXmkC+
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE0F620003
X-Stat-Signature: 4s33bqoi6h33onwoa785kqcgy9nbith6
X-HE-Tag: 1788135941-377435
X-HE-Meta: U2FsdGVkX19XR8wtnz4T7umw9SnRr5hR8khCrwLUqzap0YdLiVL34snzRmwGeInB6XNHIVY4TimiakiCci5u/hTubZtCboLAFaA/39Akb65jW6BFPSQgVzniKRkJcI9LJuJmbVIZjUISOs5P/K1MEIrA9FjQ58GkiVeDbXV8fk+GAQaqqumY4bGrWnLhrRbcB62pkE/Wpea8R2pAVd+vkt6R4vzkfB0/WUcnt0gDCuD7zopqPzKw1B5r3GCIu1jh/Zc1XLwpEk/CB8i9Ou0mDIWR+1MnU5WRxH77V7XsqKPXlT4zTOcwrQXBR0gq7f+5lL+rLvkqvYK8ivOfQPh3GQHaYoSLGpH6kfXJ7aJ36dI7VnboBkeJ5jPKLAzMIqGM1HqdITUKcM1Vst/Kzo/thG6tzGgxlegaiadQCwMO8bJ+Hq/2NavhKB64qBsw0VoI2sMF6BOCmWXMrS7wf1StkbEwpj6Wich9HIFzvaJ3z6DuJtBtQrIrm1vrSnGZIhM+2MJJ/Ud1ykCsHwIS4+kVrHf5EdtsRT6AatxOWhitujkLl49QsgRyrIUCqSS0vry0LuXUyvaCT0OMlyoXoWjwPUx5ca7paRIdv46zVEREzwY7yFSosU6ULkrsKQ253jSu1Gp56EDO6TAdhiu/0gEkbb6/ecVDnN5uANsVMEP+LULvtsDVHtuZH9zG0/VmXQ/KQgvcD5/WN+0DpE3AT2GQV8x+XVOkGNujkdTpJHFudB65PBdMvdyjN64QUMZeg7UBxvCcTMrq3hdr6jDgliIJZ07TKWkxVbklroo6PErxVL4/oF+85EZ36bQB0OqhvMFV4Dgcz6EzQRGfgTv9HJ57xg2nq8qmNoO4S1FTOgm9MTcY/NH8KzD00ogO8ZMUEgOz9UsK5opPRI37a1Ss/kuC9iFWFhTCgMBKLzca3Rk1c03tAnjvZjDjMdczQQrFkHmC6W1JoHzh5P7RE2KXggQ
 JnEgYDad
 Mie2qllq0/NSdJuEhuMMZzPKFOlwCk19W5d4vjD3mWRTX3CpmFiVSlPB86oz7t5WEsVs/TjOIaYZPo+wmdiPFIv5a23ZGN519/XZ7xYWIvm8Vsb3uwtg6UHtvCMr0IwPCmq4GkZlLRtIX1ht5cy9ta1xDafHzzDiCKq4Eq7WawFGufXfpTGh3ilVcPedxNGr6+RuAwVAX4HK1QXmijZw7pl2vApiU21N7OqJ2wGkcu3fYGM+E0UdFu6wu65yzLUEEX3z6FdrOPR4WYJhGYDeljU4t3u5KRc1TuIqH39L6G9TccxqPQFDFNeOcwLkjEbW0VEOKa6GORcqu0BfTB6eacRiJ2BhJQ9QW6JSs0SwEmr/mTh/2SgNnJzQXLGQnPNTY0kumFfaLfMbPKU8GgmorhjNo/xamNj7ZlOjpbyf9GvnZ5NMa0iXEKgONBWEWMR2r2PErmlcGimpUor3o5swCZ5D09XP6j/BGtN5q
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
2.55.0.897.gb25b4bd76c-goog



