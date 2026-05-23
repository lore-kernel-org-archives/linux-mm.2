Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23F60CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCCC56B00A4; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8376B00A5; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59FC6B00A6; Fri, 22 May 2026 20:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948B26B00A4
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D79F92B7E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:09 +0000 (UTC)
X-FDA: 84796772298.09.A074A7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 838B81A0004
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Va64V7bb;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495487; a=rsa-sha256;
	cv=none;
	b=C5japGsQEKi5q1ZfbrjLRZHRbTv8uYumtBVv2XvPTsR4zZAOop4S6YYNop6oJEm5ly0ezN
	0HiMnfwwjUNO1LCrKaSiW8RJ6GWkgKkuuHW3OetgAPw2mNdv7Ne8HgwkBI9SGOLEVVPuiL
	/yH8KlJQvbXR6dVBRfFdhJ2+/5gXwcs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Va64V7bb;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495487;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lq0iBmeaUcVwtEIsDX1jvnzHaCu9CI6I2GfvMIh4yps=;
	b=DC7+dJIoDVH0qlxkUhJMW4WoE+tjlSFFvPggo+Qz0aRuR87RWMwjI26oyYyVcC/rjZYiML
	CRGK03O8XuIm0PN7IAJgdvMoFPp3fNDpUYvJtm60XxLD03pzaj2nXoNM4jjxsh/fUuEf4K
	ZmpjlTXTFE9wUh/M5nRgGcLB/pcXmz8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9911B602DD;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFD4EC4DDEB;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=Q8lbBPgRJXNA5L+vYUPh8gDXblwem5U0MuYJZNaNPQA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Va64V7bbtTOXTUzda3rgNurGvGKuRBMTA+gr3mT9LdMk9Ht6w9EunT8hyT4z5cc4e
	 yUBhtNtl9VHeDtaKrAUubVoftZIwZLe67nGkf2S6nS95zY+/cWH7POSS9A6y63GaBr
	 Wt6SzQ0utNYp3lEjxVMBQ0soOHRxRvG2tB6qr62EgWZ0jgVTnPwZthf8xty84GfzdE
	 PEgq/StfH8rzO0RciFYBNYkAxJOrRu6kyx1BYqEfWR1EQ92OecA3yPyeeVJO2k0jiG
	 9MEm32mC3kf+840aBTZDN/CsFZdM5ZjLX9p5UvKrHQzFK0F0XU2xbi7il2SRFZ+TMR
	 FS46iQbsv/6wQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA67BCD4F3D;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:12 -0700
Subject: [PATCH v7 30/42] KVM: selftests: Test conversion before allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-30-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1723;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=JzD5LvrkFUmev9w80enRAiy18v+nCMDdHoBY5OqWDOk=;
 b=j8dqrAIEN9jtQXXFjBc8OtJrWmx1kgYpbYnu0fzv43AGafhPF+EiRAyx5upLVbp2dvCtb11Kn
 kEVF6RBRakKBTSKKxfagcmaP7irU9b622tcnj0AWbsQHWWQwnaBD7P/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 838B81A0004
X-Rspamd-Server: rspam03
X-Stat-Signature: yrcs8hck8fwe95b3wita7o94gq5tjiag
X-HE-Tag: 1779495487-91699
X-HE-Meta: U2FsdGVkX18cjZI7sy0MoUSYegrguy8rWteyjgyED2L5sUs+8zgNQBy+7mE9z+hx9UNIWZmMjmiu8LICWt5ffOHbY66fsK7+tXX5QOmMPMJlFusB9fgNRL1VposvCjFKh0mzr2VEhez+zuQ+BgbnQSqjsTHC8I2hVQX2w7vf58MSHmR4oGnJqYKkEcdMJhwac8eZ1g+OzZ1ywNP23Scz9vi+4J36bFVgKtfxhJZFc5rjNKpljirat5bhA9M74UVr/A8sqy65qVaF0EbQQ0rdW3F41Ky+RFlixoIBcVOU7wFEEehIhm9M/J26gw0X4RuB2kUm7bEkS5qKhlVqgBHVTM+yIFlYvhxPT/Qjnl5EUxzZsf6fqVQFVXmCfAfv483zWBQRQzd5M6k/qYS2NhmTxQ1nnx8JfFyRLlsfNQd5oML8uEGgitc7z6v3fCcU228qq8X/rht18Od0wv4/MXVEJraICf2qPF8MKJW/aqOzJeX6tgRh/XP9WhO2BLujImdR0pB5xGBI3IYKokNncqPG6jEcAvmSElV+n6Vil9ti9M/Ypu4E/mGeBvXeTsToqHHX3BCZoGQCPUGazR7E6BKv3cV2ZztUy+rwZ7yEfxQ1smKbkk10xeJ7ESWVziwOuGMGx+xsCcqVOazuoh1JnMVQ0572jpUD7MX5lnSD+yxscX0nwIu+DoOe+UHHNQXrXTHKy1hhmvR9IMYzADIa28Di1A7UxRBB1Iqz1VuQ0WtSWBsYRwbIUKraTJ+AaeUVOl5kBV2HVEKKhSCiEaCBZbIb6paOTiYPZl9L0V8cAqhdvGc4qbsUE6L/AezSnPZoA+FPGLgxitpvTcUtWEBaIPzfX0j19wL4S0GxVmXDI0vInkpSGSNvrkuHkdU6v+dz0m44uWnsHKYSQxcXOoPTEHW0hhlzKA2SMle9cLwEWYPCaM+Ykgjaz+qLHszmlF3AVlK05NN71tRDSychQj4kX6z
 O6g3afEL
 OguWqeJHpm7T089KmxRPXzYB+LZc9RkpkBwnPnHO8W9T6P/153qdc+S88V8y1pM0Odb/D0u2z7YQOMPl9jWkMtFJTtiklM683FxodhjG1A1i9mucZLabx55jEJS5O1RLjMMH5gqZkGUswH2LkcxNFSICA7FRXZp3ZxjTrCGYDGLT2e4jsSi7KZ82GQryGxmzacWrmhfNbczfSPaKD6Hun9hOayhK0MdLR3CdGg4ZNehAiMjIkRBxtChCDodZ80tomspn+Miw7atjsL0Z7x1dOe2i/ILtde2+3WHbiAScpoCyRva7GHkcecs5zPY1YQWzN0eLKTrGpNRnd0PCdVenyNg/rfWoJ8No68ZMi2HBzQFD17aatpajomrUAFpiOvsNS5FTQHZ5yK3koYOimZMgvLSRCKcFR7m1D8K9WI60Dgig/niscsDb7/EthkNXhgMNIkncHFwyi9p0DQoA=
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
2.54.0.794.g4f17f83d09-goog



