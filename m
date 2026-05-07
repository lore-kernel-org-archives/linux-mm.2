Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127D7CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505866B00B4; Thu,  7 May 2026 16:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DD696B00B5; Thu,  7 May 2026 16:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCEE6B00B6; Thu,  7 May 2026 16:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EC946B00B4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 006161C1352
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:06 +0000 (UTC)
X-FDA: 84741747972.22.71367E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E053C20010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/K7RHi5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185385;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSOctkq9bWv6pqZGOfWHYiYTtRP+OxhK/0hr6fqboew=;
	b=e9lHtdLGXOvxtjxmpRQpWf94rN2gAU7KajWEeJ9E1o4EOqHt/g5eZg+EQEV2xS9/GP8aZA
	+c6MSqjnOHSL1+cr7Bs/n6VZdE5LNb0ttBVnwiSCtf3K7w9vUkk/jxxeuC5lqq6L9guweu
	WxxBiDtpEE9QkviCTLGH7GlqfBcv9js=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185385; a=rsa-sha256;
	cv=none;
	b=jv/sztMdOidvR6Pz+Z6Koix3jTOj4yAVz3LI+he8T40Wa6Oe0JI61RyJb7EGG8/s0vxHFI
	MVLQKy027TA2PABrLq3cRyez6gJBkmFf1p32OZ2lbxL1+B//wgXKbFFJnq2+HXhH6Th35+
	6K+7iZIXadwxMW8Iy6JOtAmTbzs6r10=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/K7RHi5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93C974485F;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41542C2BD01;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185372;
	bh=Ctl8LwaLnr/OTXceYfya2O8mxa3KG6YV+FdrGwdyshc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=s/K7RHi5B4vpdcgHWOGGkeSDQM+BsZwKqUjXZ3jvWLnY2ah8YmsFlREccnjYsSBWg
	 BwY+drufiEhVHvT6PvhAgpwnslhFOlXUOhPWdPTDbSFpeksxSKo+dr3nrlKE96LpzZ
	 D/fZ0zMWU6kduZJHnzjtidrdahh0GXF3Hp+1YIt6+nrnzA/wFfg0prkFd5DATaE7Pm
	 kCu7z9lao9AlzHY4t0t8uT8LO7OC/5pUBXARlWeojPB+zJTI9n9y+huYlPYhccf0ZX
	 Clz8i2TbZY8i42BwPLvjXh9apZNAJARfNvihb407nHa564Vpc68ziBesZbMcDbPS77
	 3eTMTUmxJJBXA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CC1CD343F;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:50 -0700
Subject: [PATCH v6 31/43] KVM: selftests: Test conversion before allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-31-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=1723;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OyXyh1ixUh2ZY4WAr+ejokPldknD91VDLY3vqQgQkvY=;
 b=9ybnPEdWlj8EkbdCjLea15qkkMkKqQxpTbdc6FnqoCXQHwbSCBqpO+I6EFjmiVbfWhZ+I4C5E
 wfdaKlof+BzBRp3la+YQOj6z2M3w8669nht/EvE7kN977GYttX5cxgu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E053C20010
X-Stat-Signature: xo83akpxtt6bhw7w8po8uhx5odbmsrk9
X-Rspam-User: 
X-HE-Tag: 1778185384-204963
X-HE-Meta: U2FsdGVkX19XFTAEPKI6PFJpUad/8aLSTbgvcf9oivx5B1bYZotvFUhiCRnagNYXHrtAJ7b2Ey/FT4PCXYfqnKYfOxbMPhGgGmWj2i0vLyGR5OQ8okBQ9TwA3k/IwWv2B7ipSATiDp2V6nT2Olh1htHJ+Jne3dx9hxZaaX0DlDDC0gjq5dRI31SpBQWc1RYr17RBFcP2/JReZmWB1xb/ZpYgwaJaLTMiURWX7FmnRijDuvAL8ygDjQmR0iXB/GEwkIo2N5QjAxFMUYH0UL6IsTOfnW6vw8GXmQGxAMR6zgd/MxkgqMhoupe7cYkmnk8ObI1YZF/PDOXO8XXLEH0wy1H+jpWCZYPH1SpFXlbTJdHBX6XkBM0BzVQkN7+JfaNwCJgZoa6cC4dzCN0rdjoK79a0/Wr6o7CRiu7QY0CDPhJOSmQgg/0AosUN/zK9UmRV4OfIl3WptFNHUpvlx9wCcG9KZlF64CHIwYjDoNXZCpU/V1LUu66bMqPaPvubQx7I6vxWxkWIEkSputKCvhq6cVKyUq02cTygxcwal7POnxcn5Jimm3WAI/cJr3mGmSAf9NPMzXcsZo42+VHCQk9dpql7S5saO79gLfC93z18anhXULOZBoG0eUVMTVaQpiFZ/Kt9wa5OSiAcB42sxbJPohoOftarWQWxuLPqcS42nMXoubdmUWOivQu6tjM5De5ZaWZXt0QO+1H4M8qpLm3KAMbinZV4KlsDmL0oULD72DcDr3BXrWwZr24jxCzfK53ozUHBlUkKU4pd3eaVXSl7HX6fXA8p6NEDffUZ2muG8UrhuBEvFAPM1N6dX5WBFIfjPnfiy4Pe17jsofqB9/AYvdEXSqFoWcgICS7rdeZomOeKiCceghnlisws/oBcH0OWwrTeKxyjHs50MQPUa1TQ3fkAo9v9YxRZRV8aaw7Xeb3yIHqkEtts1GZ/DmrxW9p6Caplhu+xxR1tU8oHBTL
 cn2KOfo8
 PxAhX1/uZyRqAT8O8yJgIvXeQwUIh8Y8bJTBqRt2sLTLpdgrO+i1Tv2eOUgf+52SCgbAUvG2sceoWa3dy587SKDcOVUqhcMGjvcmzzzUgSnxD+940MaCSKHqFvB1Wvh1obS/kX8XQf50cw+eSyt7tdXwKarQREq4K3Eyux4+lQXMpFtED8MQWykAUlHm+KOMaoE1p+djdls3XvKrppxnERhEc/63wabDtWTw7iyh4DObRpRu5AnVqH+B4Shj/e2ds50C8uPQrd5E6yLrLwsEKHrvTiFkpH5h5iv8xAn4QrTn78R105yQqGz16IITBcuu2onzleKgLDZ6MkmAyDj2P2KwzZMMQDpFjevx12Ao0/+g2RZDNg1rr5auX/eMHUO0ggTUlRsFmNR3nR28dk/ikdnjh9nTB7x0yxALveKhzdCdFAEZM2Z7H7DkFIv+JoZjTL326krhKmfb5lkI=
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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c       | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 0cf1351e0e29d..20abfdca1e030 100644
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
2.54.0.563.g4f69b47b94-goog



