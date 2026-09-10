Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA45C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E636B00CE; Thu, 10 Sep 2026 19:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17446B00CF; Thu, 10 Sep 2026 19:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05A36B00D0; Thu, 10 Sep 2026 19:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8186D6B00CE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F084240215
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:52 +0000 (UTC)
X-FDA: 85199512944.03.548BBAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E39131C0008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWWgBS3i;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084551;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvJrjJm+qujTZ1aPI1Wqvy8W0omcrULg2zGLRvrpKfQ=;
	b=lIROeLoouPwmuZzXBAGR5ssNbQKZDyLYxjAkXBC4fuTZtEYc4UIlDJPXp6xzoP2ACQvewr
	JuJC/TW4mpA6wO4sYrc+/+WQOoZHJQgKfOoBugo0y/H2NXUGmKU4XYec4wol8L6TCUPoCX
	jzuR/ZgAlpjCo/oe+/d5AvVsiAZq1Sc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084551;
	b=lzWrFbiiJmbZyurzVqD5xK/tA002sJvwUHZ0NP/DahHBFiIuDWUA9jYneKI1meY0JJ9b2t
	njakL2O0onR9CWOk8IAHmwEmFBYVLbmNtnqIgIZSidqVlZTWjtKQB8czuizXTzLhktATxE
	IcmvrLM7SMt4/PeEmY4AtmIXvqZ+/0M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rWWgBS3i;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 272FD44956;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02859C2BCFA;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=IbvsCeECqLpAFLA4lW2aKkT7BsDLcy8ynt0OyYVtkDU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rWWgBS3iHSd06REJIMRGF4K/NYNMx/SSZIpA16hC8kr/9siZYFlcI6dmtFjir7vNd
	 kAyZKfKUIAtTFq75CdS+FFjtQPAgWNbBZQl8PeR9tOWsmR9oDIFMzg07p9WDFRo8PS
	 67Ou6gNc878Uuwr2Aj0NMi7zphCqQXD0rMHWdlzFJSSB5a9wcwXtfzy4oHDrWMZ8hL
	 je4tsVlFB60rJ8IMmDmAwhqX9rbXQfgK4TzbThSCH6wdVrfG0IU5+8oA8inx4o1tKj
	 recdineZDRIaJ9S8/MShtwnhNsALcIoc0TLA1r8F/jy+Pn5kcnrLIbp28fxtgYNULF
	 2fcTTGwK8n/zQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28C0C88E4C;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:58 -0700
Subject: [PATCH v13 32/44] KVM: selftests: Test conversion before
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-32-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=1812;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=98GD8e5loqEnXNVFPjaeOasgv+hm0t7FDCQbewQpebI=;
 b=n2YWnfFCUr/68G9CJiIyjPa+YiRgiDobEcV20zejrZ3jz0tklSJMSvQm+CRKttBAvNjajh/S+
 xM1eV9OODsEBbzk78S7e3dwOiEOZnLFdXCpQbWG1k641W/Y7yG0/5zb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6y68zg4weyyfyd74xcqi9btyqxdx64ak
X-Rspamd-Queue-Id: E39131C0008
X-HE-Tag: 1789084550-829507
X-HE-Meta: U2FsdGVkX1+DsNNMzA4ax7XlaKUsCEqAdGsOgMdOqhROXXYgg5sBt7y4WuR0GRx8oCkKSZ+40mToKxMuyGNdhhTzDdgDd9YjSkJgaNxZ867ua/kl4dsrCg9L7rvsAFF03nLBR1zMJmkF8p3C/GWnibgoCZgqTIIR2+uKYv0U/nh7xH5ynnI3q9zZmhdkS4EI8sWNQ11qvSKfXsqKNxemL3N9jUuI7KLF/MWUGxSHEGvT8dhXhv0v3/p8i42QygZ1lmgWtH4NvI2fi2N7mEleGosCYBRe1SVcLr3Z7jKFaUyye8yw+7K1S3ZE3sXsm9s984ywKrKMgDxlGcQHDVfB+34tp0WrR1pcfG5iJJ3f/Uxnjx+DMWVAdlqZexLzJsunu9C4yJb6zpprVLeBhosOZKLfTvghd89tSaRExpTKJNgP9Ca3E2Ro0km/cy2j5RY04wuQgyW9X2D2Aj0kO2SyTccuuKdNP+NiL6u32UZut113trVO+g+6aYtVBHp8EmRCpn+w12h+EoRtNTH3AtNBSXlWRsqLIZ4vHvqAZo4RPq/SoKCysyEkZe3B7KXflCkUTZOTguTfOxREWVFCZO0zIbcNuw+l1RObuszPkyeQp5rFGTSALBInjs8/VofGmVaymFCCRQmWnKBEILL2ubt8EwJMJJXcIOHwSpDQKjEqHH9+kUAF0OCl20zTCsNDiUm9hAOLPSWiu0Q8ZU2aD/ynZQUhiQMSNqAZooN3qfgg/KG4axtljzDQpBV+xbK7dnww2z9Tt0KEcLcUNva0Kjd0ItjvQUG0sQRrnIY0x1xzPcalP2ID/K2517SjfumR7y2ICUDO1W+CdV/SZ8N2BpRDVv/enflw+rdll937DyoVDwUVS1dCgxr0ifGHHvBKiNCWyQDbVuRcItvmsSn3MzacTuagHfMewP7LbMOB2JzP4wgqnZXQyDNOuprsHhBm/Qc6Un5m8pqm6amcM4xFG0g
 jSwyaU88
 r/2OlotyqYBdSu9lTstet0vRDbQdGgesIIq4xHQnkRa0xTnOQwDftf34hxMBuPHP5xlmIFwEbE2b7miYbLjAmibQiBGOw37mJmh8KOb+zkwgSP68TVhkeGKO8q1dFhzDFqUvaWsnwy48rL/abRMgUaYcpuWM21IJndxQcg++3ZiPtPfBvjcrdKStrptaOIJB1Bzca1NopO+g/mUYglJEygkGi8e4oHq2639pu9e/y63Vmdce2hSO4fH6TVmsXQxCuYyuui9LIVY7RBPSZ53wcBbcxMiyhgeP3Spp3Y+Vt80FCJPTWhm9slHtoUy2vkGIl+tdRf+2HBD6+8vuOo3Mxpu9ckg5EbC6lnSkS+XoG1jcdzrWONBSN4lXTBc75eO6PBCFtNmeED0zAmlzqONKOMs452IwJmiGfTIk+v1x52UeVPNG+bsna94eq93y2fy/mYO+D/5Jp6pK41eoUcsjj4k+n6quLO/rVbW/9
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
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index a8d89df53e46d..f46f1530a94b9 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -268,6 +268,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
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
2.55.0.1007.g17ff1f9808-goog



