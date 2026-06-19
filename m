Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1761DCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5146B00B9; Thu, 18 Jun 2026 20:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F086B00BA; Thu, 18 Jun 2026 20:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE466B00BB; Thu, 18 Jun 2026 20:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6490A6B00B9
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF4801402CB
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:05 +0000 (UTC)
X-FDA: 84894785010.22.8062C01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C1BC6140003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t/5Idczf";
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829123;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leD8PyzRUl2CStDGgeENk264Yfx38yMCDcVJ4kHAKlE=;
	b=598EJtw/YMPNsEi+y4KUBKDT6IvxkG/G3+WX7dzjdbajFw9/de/DexIWYaIi0bUQoiOzBY
	D71jw0hGKZZGCukPlt+h8mi3oBiA5jCTgl1Xi/2y0uuZwgf6reau4zC43ipc7rraUpN7z5
	4fZirgYkG+UOZUzdrQl3Ai18c3RGHTI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829123;
	b=I+CA0zUMCKafb050zoY0rafa4TUxDoIugD0ngDLChP3UOg2g9OQqZlg56f1WBkBBSRxUUH
	m9JaxBYreC68CWIkl/Hs04u/3dtj/9K1lJbtTULt0nT/wNrvWQBWEvWtiLnADXwW9UheB7
	XoN//MI/LlSk9EcB/1L4rEGD6YpGpYQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="t/5Idczf";
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A92ED42B5E;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B7C3C4AF4D;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829110;
	bh=xPyzK49WZf0CIwxDAHudvIqZ/3nAqDBibfoOo2l0jfE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t/5IdczftYk9jeqhXiEqzxCE9jvUxQ63q2rDAUEJkqiQ4CWlemHpzXgUcIK625mvy
	 Bo7wC7JMSdOGQnSisSft4uhAnU/GKYIaVakFWgf2IB6BEPnc4ZWiNIE97CEkd0NPjL
	 vTgzQ0hKBvJw8UYzoeCQMJnxDZL7kXUBuSFGfUzuTGgX9O8IV5E9mgOd3n1MvKsE/u
	 kimuasXUJFN9uEhS2i0l5ohXBdUwkaIcKWFYYkoIh4uDT0JrgQOf4Tc+Za+gKq77Qw
	 6ynusieytXte6xTh5i0E/9aqmQLOQSWodX6QWiMb3y7Ga8ET9R894QxKC2ga4PtqUE
	 Wjy3IIN+3H33w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A1ACD98FA;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:11 -0700
Subject: [PATCH v8 34/46] KVM: selftests: Test conversion before allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-34-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=1727;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1gIVFOsUf3NbwySE5dAcTPkBOt++oB8gtEbJkV7YoRE=;
 b=d10xHjeCTZKFuhb+RIPuLUOxnSuzvI4PMPRbJhle+VguTcLQJNXlLIM0ACwewWhLz0z94tBz0
 tJ6u2lQ6oGOBhYYIuem0eyw9JasQDs9VM5JsK8Jxq7kI+iuV4n7tMgi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1BC6140003
X-Stat-Signature: f13s45uobodpc4kcsxhnmpj3hrcnaxub
X-HE-Tag: 1781829123-216366
X-HE-Meta: U2FsdGVkX19O3iZlGIiEQW2EngOXgqO/iypO2Y51S3opnbSjoG06BxJ+M+Js9g4Z2K9m8FU7aTtJSJyUWw1SJLKBu99ZNqp6lj4OMdmrdY9e6QrNojzAWOTlpK2fCml4yXfSAGLwoGqpgRoU6n4U8D5hDqFN5DfV8kIqiDj8WQAnz1yhFu48Er0J4jx6eJ1Km1UtrdJK+XleXzqoHX3Iv4GKkDO4yDnxB1yH2tSLJwi+aEMTjM3H5z8FPZx/m4wai2TrUbY7J7LicDVprKumDWIDg92YE1WCiTFOYAjIyOu9/IGW8XhkC/5kGfOqXzC7MKwaylDK9H20oP+l0e6js2Ovh8xFLvBuCVekgmLB8+Q5Ibj5Ap9xkFoWe3RR1fHzxCReTD55LcsTKGlaOuW55SQadXq0pdxzRQIw8CV965AUGV/NGyXtYVilPjiphM53caXdPTk53iDEYEwrwxsmdDHhvRDMW3duMXC81Mv6pXapTyFIs5sbminJCqLMimPASarcxw3t2kxLcPolhCUd4IBR6HWKB71s+X2fBw4oSe4xKby9EMj7P/uSDzboyFKfwBkTtIBAvcXA8IB3WheB1GO7owhBKXUD+YvY5bMDH3gDS4MRInskkxy+ISwe8R/NxjwF9bu4yNgr/FAte/ZCdFkp7iH+/W1hyuHhhZyaLLBY6QcIozt6a9Xxp5OLMimQEAUn9upqToZ+OnVxDz96TJTOBmV1rOXerPeAb2ZX3L0M3zv0O331Eb/UHP/brT1o8bpXMbfiGbwa6jMhjGq6r3PkMWbLTmFJIS2tTolDRNZ9tIubHF0lqhAZCc/85Vr2nBBqmWYh554C9iRvWiqVdTKxyp4hP9pxB85xddpleZ8EcnChw5eIQUG6uzUBohtdhzAJF7//eeQHStcHdAiocqmzAORRygNgomWqZuWHGMl+tlNCqtPbdvId4vdZjGMonJcsAXEV2UT79wsRwBp
 F+X7Uvxh
 u2H05uiRpY6H2C+uy896mFA1O0M6SGThUBbeAIxVE9aucZGItBzX/tP+LbROXaev9vCEpWiPziTiFM3Vx0270ToTCN65edYwcba+w0aBKSsJApevQuUSiEg8avZ6vWvPMW18jeF/0ESSSIcGHIgWCCp0XqPR5Vc66TsDLb8dPahtlTuaGh0lqKyNwTUNxl1NPOqsyfs6S04RW4ibvaSguotL53p4thG3Cv64AsQRk1m8XNLzJDjNYAQK/n/phdM/ZRE4N7EHRr8Me/HhvoEb6sRp8p0sSPqNSkuaHHAjnecUJ38KhBuE+whPXTku5/EzFtzIhWnSyYH9E8uKJ3uGziuDBsbxnUIvaREfVAJWjNgx4S7tSNDvtQmcB6kCNgPJH/IWCYkbml+1v9zCcJewuQ0a9dQp4p5a4G4jPGcn7rfa0d9WwTplvZ2ilJ8HOZzl5iz69YYHoQIYpyyuEZSwAWV0+bYJVTfEcyOjUuBO4lOlLCXY=
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



