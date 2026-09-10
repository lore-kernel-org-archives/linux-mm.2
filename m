Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D40C88E4A
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE836B00CC; Thu, 10 Sep 2026 19:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28896B00CD; Thu, 10 Sep 2026 19:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D8D6B00CE; Thu, 10 Sep 2026 19:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6396B00CD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFB8B1C2914
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:51 +0000 (UTC)
X-FDA: 85199512902.26.16CDB4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB419180007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D6RqWipp;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084550;
	b=lhgcI2OaGG4EUXm1Nin8RMV4ajoO8JGpeZpxDwnumynWgMoby27KHeAGPEnL3IIrhrsMuy
	HhY6MxZTgWuN85Bi6noJOB8kfBnDksHwP3RGTvQFUV4L4/WwRzlqlJ6XJ6Rim3HjysqMy0
	V2pC4GDNWayuzTjrRQGIgeygaukA35k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D6RqWipp;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084550;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbjcOR8C5I7oCE+Ga2bzUbGMzLq+ds2mgrTx4dfx0DM=;
	b=wzToS1G5xX/ylbrtzXXwJOX3ya7R/BFAJIcryez9utO2se5/eVKKkO5hV9YrEYVDIrAGz7
	9fasfjOUf5UCMNpvgZU9+NfvfrwkU/Z1vlBlqwqbihxZag3eIg/ODnckg59Pb+YLI2OvrW
	i3qU2x4IcePzKa0LZS6DcJaSUi0vjMs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1AA744935;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABC7DC2BCFB;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084539;
	bh=KTT78BrD3yNHTZHd1f41vXgvyjz/MZtvWl0q8c9qaDI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=D6RqWipprbkT7Um9At+bHN0EDgEn5GAUeCDBi1OhfPPLnxwWIxdVIkf9XqOXGqQKW
	 49uiPAKe/OyFtxNTixP6orbQ/IBtCyOADIiXgTNW7PgsdKzgIwkIta2VFUsonzqcGr
	 x4uT2sIRydFrTAQXabIj4csy6OhZ+yvrFkwX9/ff5f2FTrkJm8grtGAr+ivAjviQNZ
	 H96DGAqlMAVmFcvbwr0KA0lbKqyAV1UY86yhx9iyzOLy1DpRukBX+MdgmpzebukLQJ
	 7VbMxUh8PYBiDP+mQmzK04hV9hydhir35s1fD31JkNhBfCaQ+0BaWSGWUQR/VICzqf
	 iVd3R1l/qkDtA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95FECC88E45;
	Thu, 10 Sep 2026 23:55:39 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:55:56 -0700
Subject: [PATCH v13 30/44] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-30-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=1821;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ooNMDyQXwRI+wUeKneWTHpK53DEY6c8VVbqQXQcIHAk=;
 b=TVt8xCsFDZA9FFlAE9ly2eaVCA1I1fkxP5nD/f7o6J6AXps/b0sL+qQ/qDbIfvY0W8EeWwIHj
 1UEeF6Q73YxBtbPX/cKPX+r3WgN/tsiwKxEIXy7vbtb1r2xC1VuU/lX
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB419180007
X-Stat-Signature: mt13s41snf1nbxhrpa3sti944yfnyw7r
X-HE-Tag: 1789084549-138766
X-HE-Meta: U2FsdGVkX1/z9CqWzdrhKCpu+UJz9giaJpX3XilJg3b2n/LGMMjsofCSTCILaPyY5Y0AH4QnM54acZlp26w2tAvHFaYDkERrNkbXBOfm36Smw8zVA3KUppoLqZNYQSyUoBpBAiBSa6ISeHfkTJjnZ0kdqGPWuf9rGxODGEcjR01VvbnYiqy5SSy2Yz8WpgLkPh+fPW4eVMhaemOWoSiXB5ebHUUCOSELwmXl0DV+vUsHwQ1z6o/AwBhZdbaFZkXngCgTrxwecAT5yWkvX7aaY4R2Rag1CDvNN/QD0LmIs/yAhWu9uAGrFTzqEiUh70L2y0NutLgUXTI99fLBX6Hc4SysexP4NaF8dflycCyPEdQvVV+AIpFYfpj7aWmMAW4hAfxQTdBpligUem4mE9W7Cwa3WqYayaHn2pUUqHiEDshK7LTv+ImggCo21/A3hkCu6NrXi6X6FPj2BqiGmRb02aD+jxbVxF9BACUUjUk/oI4+shbhNjl++uAXPDB+9oHIqU7WmQEeYiZYZQ3bx5nJ0mxBlhly60lumSp6a3z0fZwpAvv6kZNmSozzHkQmqpF9WRPGP20L5dC6l8G/Ycv7kqhOmxU/2QoK1KHP3Pr2GzrQEBwMV3yVubuxX5iWsOS7+4ABZQdayBVSWoJa4WXQQAI+dBbrsh7gfywjoZeracFNOOp9Jd4P5gwVkhx5diLd+1DUwmrqNO2kre3M08iREsBYdY7iJdaPPjW1qVxaWZ1Wn+R25CLMIvl6hVOptjUs2OeKbZ7qZTpQTMMkJXXPLWciwJiBT4bqh5lOPjF7c0hgdBNVF06abU0aKHWChKurbc3PkB+nC9Tg0j11yYSUrQ/vxqfv1VyInU7CzuyW56CNOX31XvzdNW8kMKZGWP4ntQhEK7xpxbTooZmDqf05xcmgHSTOUcmw4vG4pBZhfDtExCwhjYhM0OurO0wgT0tgk4CPqCiEPBJvejm+YPg
 7Vuvcb8l
 JHQQhxGYvN+pduVGd29wABQZfn/lbo5mcDxnMiuJ4M/HMqMZmfFw77zRM5pV5bKCbMCIwyFZj18qXHYLaXQ7/EiRTNS1lL8FOpfdJPFhceQyWs+afkatSE666U3iDes+MsrbVWpcrcb8a1+XIFuj81LHsiffII/L2ju6X9cHaokVaNEeO0nV4zkfilJQnmPbEUn/DkHLgs4YA2YE9OuvuDLKzbp73rhjdfknSo2gWs7XzXaf+LC8ro3kFjX4ZadA7cyf/oYmVTmaJfvYTA+WEFbXhgM7uD0uNZxj8O3zyLTNGO+i1GqgBYOhc5WB8yYyIW/g4AaG19dRw4kQFo2OwdXMgCa44AifOB8eX9i2XvrkLGc3D1bAIWZb++mAbWxn3mjjTyQOp30jam6qBnJgonfgUc4rS0+Rgi11wo6pTWLMzrwKxVkajESJhIKfmkMSRtSh+U9JQVEqv25PLxk5L2A0J2iSnMZVjHl2NfHUnctGazwJRufPPtfUt+s8q8sNUrOnXUJc4Y6mgZDBYPabHKgi5Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---
 .../selftests/kvm/x86/guest_memfd_conversions_test.c        | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 77f95d49349ce..4c20d3d8e9349 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -97,6 +97,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
 	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
 
+#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
+	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -188,6 +194,13 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
 	test_convert_to_private(t, 0, 'C', 'E');
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.55.0.1007.g17ff1f9808-goog



