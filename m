Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDFDFFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5122F6B00AD; Tue, 28 Apr 2026 19:26:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA346B00B0; Tue, 28 Apr 2026 19:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404466B00B3; Tue, 28 Apr 2026 19:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1A86B00AD
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:26:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F0AD16050C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:38 +0000 (UTC)
X-FDA: 84709548756.06.AF4F53E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6953B2000A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMDuQVTR;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418736;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRClgkzf2CuHhF5z13e4Vf6otreulkUZimuoWvd54dA=;
	b=rIYUoVE1HsAwmlFtpXMryLu2XvkEs9lLtMlJ4VHysyWP062dHp5v2fcsU0+WSxlF2+5GAN
	tlg/1EVDWj5ece8dO1z2F6TMMsBd2MgqNO4Nvz4vMlM+XEcD/cZw2/omfbrXCb+mI7F4Zc
	tSR9Sby/rDtdWmA+UaaFG8It3EDvk+U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMDuQVTR;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418736; a=rsa-sha256;
	cv=none;
	b=rjLpR3IbFewvfZWHtM/Yx5qfzw+IhHURJf4WrKModGogz1s9eyxCokpdMB+krp9Z36YS+E
	iLxgje4bN+xE85ZB4+P2tPHGoMU+SnhToj0dKa+pu9HV+Q6vrJTQXvK0h6Nc0d+8qWoqFh
	SI/cmgVYKNIy9ZmEqHGzk/ece5Md4xg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C6D044AE3;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52E90C2BCAF;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=0SjVPRO4Z/23E55mrkb6GG4DyIoejAGIeB+G9ojCMgc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KMDuQVTRFq/SjweNl+dvCcuHqLllfpg1Cr+EnV8PVzJwQ6pehIj6k8BkRJFB5u8o9
	 7KSwraOttoyGZEElJJSyxx9pqYKnvWLbQw01FGpP5KFyGEO0oCWj1ACGhKVQSDd4cE
	 zGx0Ep/hyVNIV5Uxg9tBcmb64ULO69hlO9Sn9QywAf55LJ+wyx1l7HhvLh6k7zyt8p
	 8rgUJ5otQHKdYpgUwMhQohH9x77tO+PB5cfd8Eo9/OYDMEDzepuSQiXiMDapB2rfFJ
	 gWVUIOWvNuPrdgmHA3jbJJXmCmvIYRSQYI5MYNJRJHuXX5MoIPaT7O9zaKpSX7WaWw
	 /ZyJ++DcE+qDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CC5CCF9E3;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:32 -0700
Subject: [PATCH RFC v5 37/53] KVM: selftests: Test conversion before
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-37-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1717;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=R2wZQC9Rl/28rBzV/KkPj9FBUgmPcyYP86nHAFudBWE=;
 b=/i2LTbFszjp0Vo39iGn4dfkVeMzGR59QOCC/Arn1GW2lpZqVsU0x6gH9VKriOoBrPoXdYRE2e
 cgcVK1Qnf3cAUEzP1oidALyBhLnBWMewTJ966oSkktFmtf2mzBC7ON4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 6953B2000A
X-Rspamd-Server: rspam06
X-Stat-Signature: 8zj5gnj1eorc68ayh789nx8ocwjzccai
X-HE-Tag: 1777418736-218633
X-HE-Meta: U2FsdGVkX18HQvRQwQ5Z8mqYMQ9IoWo/8x48v5vgXv6TxHOSf35+fJHNknNWrRFy/RecB/b7mTyOJ/burG8iwDPLyw7tAso2M7rsyWyq8c7I/Fvwu0iGwVJOugQNiIrk6P8gk7gt96f+w6f2FIFfgf1VrTObh6KpQw9PVitHyhStrGLyWaqIHVPHub64osIke1K5PMIVbi5zy7aZmjoMIRjdSi2J+ty1+EIHZll1n01RUYVCOQiWFb648iU6vQ0iLzz60ihE0nVUTRrMzbLaqmZwKSACkBFkuFmLCzY6/drNvwTdSEkBNmLk9oOyShQTD7KxP4eAUE1kZ6dnqU3TJZbFnxKdEJScpTgVu25PBs03UOkwICIj8E62tt9ED1eBwxkF5DZdCU1vV4HAVroLj00FgB3nL2FOUltOsoi8nuJBy4WdzhEB5g0V6nkchB1eMeJsVlW+ihAdSBB3Py25Q3sqEJRf/gv8E3fgCl5jIN87DwozeVH6u8LNKYW8jTEh2BTIV99tPQMPNrYchNoS5VYE+8rzHNXjBhIJrnVfW3YO0HjNE32DTV2c14xYMi6uHaM0/pghRKSO9cvYnN/VV+ZkpiekhvD/P0qlKnGg+jrD913VEs9sHy7HazF3SeGrbXTfok79AeyDn02pffOsvIDZnNWPtPRmtaV/V3OBmwIZFxK6UVJ6R3Xqcl/jtzEiRiuuvkyCWdN2rB2zaY6eE3y502Tu6y9P5MXX6xSstcQjsGldvNVFN0NrLUpIENCJ5dg1inj7Af0/3jpGIp2yF+/z/Bng6Hc818lHXJMv9KtLaPo0HFiRkmU6izPDl0XnuLFr5DZCutU2StQrjYcZAKHrcApkL6uLFpnAqoszhWovYzKBYHcA4ToypX2lZCCdSnHH5hMqJ3U53TsimJ5bbyp6f8mowBZpAWySsImznietRspcOvZIx/I2nqNp9iP4Xt0OPmP1qvZoBnp/P8w
 IT6W8Q63
 lAmM1JHKafZmyuUImZ1K7uuUwOgSIgRY3AH+jH6HEj6cvaDFUTb5Vx2Cazdv28QxynCddu8Toyhe1V/LxPHLvmvFdWMEC7Q46LiAnbFtT6E8aSsb4ZC6WEsQZFdzXnUrIMids8lGf7VEKEE5hg00S/l72zxgI8f9607dt+itwqpwjs7mZX6XUHFHqnnZYNsEE40X98iS4QfzoItQyL1gLBahQj9jhhHKeDPrQIcSK18wt7NLsPJmc7wnDZu0qhjXubdUV1aEPOm68M91KQHrMp5Q5r25lhTgCFYE0dWsSxFg4AW176L84WyjdxKsJ6M0I2o6N6e5rEa7w11Ig41PLLoQlJ6KhBXj4Ach8b/OuIheL80R8XaZoLy2V572qI3DxBpdq9Saxj2sWJeQjGqgpBxxqONoxGNqfXySjyFuEC5G6Yr3JbmDlnjItuh7DDe1vTSVbObyocwu2Vb4=
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
index 25f463bc9da52..92b18373a17f1 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -275,6 +275,20 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(indexing, 4)
 #undef f
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
2.54.0.545.g6539524ca2-goog



