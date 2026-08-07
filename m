Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2420C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3116B00DF; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1651C6B00E1; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079296B00E2; Fri,  7 Aug 2026 17:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D055A6B00DF
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F4C8C01E3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:04 +0000 (UTC)
X-FDA: 85075824288.12.6045CF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5765F20013
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jzy6weCn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139582;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ud+z6cEdsVxEDIcktMyMhMCeW//49oTIeeB0XPKIsNQ=;
	b=IgGJYyrQmbKOabElcc9N98SWK27UyQCgKpTJNBDien/DsEht3Gf3uhp7QnUS+YFOiewXWU
	vMirMbBX0CUcoHz0MUK+sBJsEtx0oB44WuF+Dg861kMfYMnp6SSNw6/B+1T3TABIk1lMIZ
	XfmRvVLhAPiUKwii4dxofKYS1UXR5NQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jzy6weCn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139582;
	b=54bMXnN2RdOzVvQcBKdVMsJYQLO2hCtLFMEvLPESQ8qK/qwVjgW7PYNLLqNcIbA56gdCbr
	SmrWovU3AT3kUVI/D08i+da2R+A+QRUSE0YIAlQruuAq7eRxfDItynUHgnFJttsLv5Wprk
	HqPlI/7deB6NmzxOtz6KO8/jWFnVOLk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAD9C45225;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9BDBC2BCFA;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139570;
	bh=Ln1q4lrUFSS7gDCcKwE6OZVftGE9/TNryYAIM2J5wnI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jzy6weCnau8/ZPn3XJqi4uaeI+Q1Hm62NugnCwW6WTvM7Fi8ZiGJwkF2A02QXp4US
	 WbexHUgr7Nd9eF+4Z6wL2AYZ4Xl5SXgWv0mXStn6yj3wufNBSRSmwQlNmnEmt5gucw
	 mZfF9BKeZ0oXWwQkspnJlXoI44zZUL6Q652KQSpdppYCcUWsdgnB05l9esvS7qUlCc
	 ldKb5xLOLxHO5g++2gOY0bRD7bbi5kfO0a3ix8sopy6++/ucidnN9nqn2gAoApbrXH
	 1KOAlKLAeHwzUSk8YY0OKAx2gL/U1jtI17ajL4XQ1I5j/QJAhdsR9t4lffyUxuhHKa
	 RTm6oXTmr4MEQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C13C5ACDC;
	Fri,  7 Aug 2026 21:52:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:09 -0700
Subject: [PATCH v10 30/41] KVM: selftests: Test conversion before
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-30-2fc18ee6d3ba@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=1811;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=YLPoH+UlheGSVuHIZ6ZrndN59zMim3d1nQPb0wA2LUM=;
 b=zXNVVrQca7C/rG0DVKGmySDl4WfQ3H+varJkKdEvpVYCzZgQHY5/P94gJtrqaORmxh7CShczi
 9eNLXP9D7pSBkKjGIE5nv39nqskjscM9o1njNUpPLYwvn++RAQRFE6J
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5765F20013
X-Stat-Signature: 1fsywjnfhzqj8teqbdjcpi4jymxs7bd8
X-Rspam-User: 
X-HE-Tag: 1786139582-903408
X-HE-Meta: U2FsdGVkX1/zKEeMjBpJYd07wCuv30a7krqQQ2800ldE3j4mNs8nYzTqe9ekqvz7uisDiJJoWdwcJ4XdTRUMJfnsda6LV4/UIZ8snzvbS5b3GZfxpg+TDM/QJhk7F8Xrtn9BZ3e0IUOL5zfA+YCgHMMvB4h3TEov1+AUmAPdfaWXEz023UVcPKUIED0vIh4BE44zB9PayECB346tcmBlNyKhU4UJz84MYjiCPuIb/YDCrK/aCaLlPcWSIdPtQecm+7Xb1HYGumdonZQxjIAiFF6uqnNM/Z2QNM9wr6GhrJPgT/qI4p2Ihmog5MaEx84OnDL8sF4AdkOcSGhHlllkwn2gQiJQWRsOQJDsXgT3VhTDcljBLOXM5XW6O13m60jxwQQVZetznRHCeL0eZg/lO2g8roDe0ztwsIvad9ObynsP+ymtyyKUbEBKKXwJ9UI5L4N2NYhS18ua+waOui3RgZrynkCIcNU03tue5VIKuUV7zaNTtqgXv2tSxKCl4ZkU33sLw/a54P44h8Sp9w5JRCJ1NXtU59OZzAhDiEqpV1VGf8UioltrER/9hDjGwbSVpcu0fljSJ7fle9b9HuN2HFeO+grWjqIBNpFpXv0Xe8dR4Q03QEByrACO1H0A5pg9+3E/h8JMb1UeppAgxLwnQW1D6yfvg5GgToBBZKlfA+cO//rmU3n7Tk2iicXY5taOGHcm9MAEjG8SYipNkhg1sCEpYNNSlo+nBXW1ZxvmWBR+9TMLeL1gCPzLEbjFNl+YRbdCUgrSFITE3YCa7dDiwBHYhNCdmruVj+lPSFiECMt2vFs9+v4mIeMozec/7uvna+QsD8ZKWYHy10Wisd+zZSiwTeaCFtENYgNVhHqbRFoMMRE3C8oxslB2fNYHWb6mvJYnMVa+MMGzHQ7STCmTevdnk3TucJsElxZHokf16+Z6nMwX9g36voSD9KVQWY2ZgzqO28jGPr5qlsHTqHF
 UEEhjC2P
 W9DI9Cq3G/9DfZCXK/HQTRJvPmHM9Ne+MbLIbWj7EZMU0M91Y0qdsXNadmn9Xfy6w3OJOKAanM+NqxNPqFfQqRB2Ki6H0rhE5kq+WFJlOTY2xO52mBBFjJDisaF7KheOgawR9+eh4L9eHTFtuJfrgzCdnZhZ9/oAdmYkJqezbfwSqT5Ls6OdmIwkF5W9GGjAZK26rz4r5afE8roMDCs4EtfB1L30oTRO9JWsP/wYXq7nBcS8bSodMtZYAil/rLnDOq1sTm38UYOKs2Aax5+ZJZc2yNYyKq8TAoVt1btK9a2xNNDfxrqwOkifJtSFTcYqmZ8OrXGoaF1xMOKkIMM8Zz7z6xCIhE3B0kZ8IY7QHQ4hiXiCPTVDmSj9WdreETLfcLO2Wncevp6FGDTV0CkfST+DddOE45GbZY26NZJI3f9Q+PMNRBJ8tUO+3RzUZf7OVz9D55jT8l4AvULktKBvV0W7Z36mirARpMGcjDhOc6E5uXoX3HhPIoNf+ZkWuRzJ8VQrTI9hValGGWkc=
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
2.55.0.654.g21b8a5bc05-goog



