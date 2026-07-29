Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBF5C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A546B00B7; Tue, 28 Jul 2026 20:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFEDC6B00B8; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14656B00B9; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA3C76B00B8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61955A0069
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:23 +0000 (UTC)
X-FDA: 85039945326.22.2E6254B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 769A840006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jomT2LBT;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285321;
	b=LdiT1jMyz7lVu+L6g4NLE2yCPr8Ayf1YfLyaRVcnsbJUV+wFnNrxKjAkA/MqMhVC/7Ic+e
	CqdIHONthicAxk8eE5/BjMADRtOc8HpxFHVk6WLKw8E+mfGW69bu3kQXurus7q6oeBrppj
	4HpUjB/m5srtarYSG6Ar1u9ui+cFqlE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jomT2LBT;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285321;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNmcB7ct5/wNtXalgkk5zQkYG6qTi1GY8ThMC/Dmq30=;
	b=TXgTqIeF+VnWhed4X5WqKacXlfkqGzwyJ/KrsJjjp5FKZk9XYVmXgsSOSQz9Wa2zw75hht
	0J3AWl3s+pKWwzNueRwK47u/6hsw3t6kFtnNn6YtNWtHdIgzmzTOrOulGxE50aGXjLzZUs
	k1vcDG441aP6xzxKvHD9KM4EDFbFjEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B090D452D7;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BCE9C2BCC9;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285310;
	bh=t0GU2FqFKCuOib2d6Ruhhddol6SB7vDEVb8Qsk6L8f4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jomT2LBT1idArPrZoQUXg9UsL6VhjivlD1AlivwOypFrRboXIbZk7G+j9iI1FyKOW
	 LhteUBKmd9CLTVAuOHnXWjFqfTCuJarYAfFX6s948wiEGhD7LEoQ5FVa2OYF30C85/
	 SZIc8sebFyeeZK3i0x+z8LRySJPcQKgeaLfepE2DySyXk/NeWDwhCJyOg6wowh2h1K
	 FPLl4Lq62Uu2rMtS1xM2dGdL5chWFvxtqmqmZ7pn6Ccum0zGHnviEfXR6w2c0WFFY9
	 5vfxzQ9LpW5jwEvNqcLJ2XxYdOfDzigCsj3coRAPzyyBu585v5tRFM5kDQFPHHRELx
	 ZdUZPXzcy4+TQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2E7C54F5C;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:29 -0700
Subject: [PATCH v9 30/41] KVM: selftests: Test conversion before allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-30-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=1811;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=v57ryBr6oGCJe5TYqs1IH2knV8ELwerTsyk3LnOgbLI=;
 b=gb8EUCRkrJJZH9HkkV49i3gxNXf/AJDTq+z4Z9mytNPAiDk4M9c4F7yZ4c4FQmhSN5+iQK6wN
 ecwqOUSu0wUC3xeLENFyHwv/QmckwTLkUQHa/ApCaEzazqfAeZ/XasS
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 769A840006
X-Stat-Signature: iohuc4wtsbhnexb746rspm5ersga1mrh
X-Rspam-User: 
X-HE-Tag: 1785285321-349509
X-HE-Meta: U2FsdGVkX18QOR5ckSMS56MGqqfY7eSJJl5PKq8g4+cEDvT6rbsOT+//LQu31KBNGL9xnJUfipwMomQAKNHb8uR5x8OWxUV+ZkJxE1dj7vvfaBRiGQeWtFbz7tGvgpLxVXjmPOQbzAQZBkThAM/3TbGBobFhlQ71Uli41bOrgiM2p+eHsosg5B5c01RG/Wbob/cd/DfvEIVkSjYkIo/nMvi1vRhK5Phr7gzr8ZZhpAvDQ9TFWPLQ5hEENS9yXLxHRxT+Pp8LXe2ILI2TLdlgu2DHukCIonVOFuFlQS1wgtcCDJ94GPxy9S9lfHzNxNObvw4VzGJXGk2CwRzTf+lS23QRRk+bT3BQqAgrURW27Of3vx03M7N5j3bec3dFkN39QajH5OSs4W83ZVSB5PROqMkixFZDPUc/4Ger2hS56+R8JSW24h7PgRlMEeTQi+Tth5A0+rYefqK64UTNHp2QuReoxRBFxoA8kxCVuP1foS94MRK8V/xOMek3zcJM+1Doihhj2Z5c7ksSPVGPLmH35ziUqeNCFit/DvpJSDG6Yjm2D9dkRdOwKlGE2XBU0BmBiyjrMG/KVs8FVgBXBBgEfvjszXBH+pnf/k5eL382sZRr4L3l0mVJco7tyn65TdTNoXttRHd8LXKDpn69t64DsvisH+Xit7s0AKh5o+EEYTktntAYpQSysgyj6ihvFhuAzWxjA0JIYYovBvk21/OjibWtik+hy1AnBC0ZIxOterA6OY/NOr5bKlDMz92tLJTH8AUc+keqZ2UdWn27QGblwT0dTb19mQmvp42JdWDUXNzI/WPTN5K8b8TlYylaFqN+BNv8FZGut0IqGmZXOA718Pr+2tiejHzX2Qz9ihvGx3DHvDYyMgFAcnnEWM67FIKGlAZJjJgK6rX8m9D77gxCMytrgVr2PTjury8NEp/vdCXWOWw6Ad1Y4OGUA8sbS5rbkeG3+xRXyOPnC+vGg+x
 ceYlTqkb
 bY0iyzAEJgzc/w00fCvZSFnow7+QSFzxugT8dSRaQ0CmTgKAiTl7fXTSvLx6va7zZaH4TROXUgS1rgtFOcasJ7PQTdXJ8oS1Ryb7HS8VVziYZb9RqCyT84n0HwG5LaN3UEeFLYkJttwU773sRSaYhNT+baMJhi540iOUDucW3c05PnWl5vS7hC8QWfmetUiJOzv8jB42JPLHMVuXHxs6aVm+NsEufm1WnSJXSTHv5SdUwJitwPINNqOsPiTr5HXXc+7QzhIwe0sjplqU/oprWjqXC0BbaH49E9eqoatqic2PtocfXr5447DX/4JIvPNqbURXI76BZtw3StS7VcS+YFcbBjxY8vQ5Ojdz0KszKWO0Vlt12VWvqo4DZMnqwSwcuWN/f4G9g6+Y53O7Tlp7OFewC7CmYKvWGneQRxbPBwxXnW8FzmRqgNcaddFPZQj8W+9AuuN0KhkzjgMg03G4rOcx2ce0XVxiSlfxyPdHdROpeh/9a3PhLhy1kE7gE29okwaxb2XR5gzWdlpw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add two test cases to the guest_memfd conversions selftest to cover
the scenario where a conversion is requested before any memory has been
allocated in the guest_memfd region.

The KVM_SET_MEMORY_ATTRIBUTES2 ioctl can be called on a memory region at
any time. If the guest had not yet faulted in any pages for that region,
the kernel must record the conversion request and apply the requested state
when the pages are eventually allocated.

The new tests cover both conversion directions.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 8e17d5c08aeb8..b43ac196330f1 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -265,6 +265,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 #undef combine
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
2.55.0.508.g3f0d502094-goog



