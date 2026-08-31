Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B1BC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781D16B009F; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732276B00A0; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F946B00A1; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32AF26B00A0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3D3D1A03CE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:25 +0000 (UTC)
X-FDA: 85159670610.14.48A87D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB26E160006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IvVf4DTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135923;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3+5HCHt+oXdCKF/9eY06pVahbbcE3nK3grFViVvFv8=;
	b=70gwe9VSMu+UHc9UjGdgohyfjJo53s1u068NKMuL81X+KRl+IbkEYeWtucurUDNkOXi5R8
	k0t8+NsVvUbPaQ76K+nC60OQBnC7QkQBDV+TTq41ReCazldv88hHOIqdOQiNeu1nnepdE7
	5IpXIuCUfOgtYd7Jpkto3YY55b00Wrg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IvVf4DTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135923;
	b=6NCv3f9AcZZhdYYEuI+GkACJ3OZCw/LTzjHUyL4NYKlYNx//T5zMpTsuKqsd/6/Rpiv19W
	qKehMouq04IzDP11vAnGoS5oko3SFzCq+o+L86WTHUYn5u3wWr10B63qjbajqq4/XKxQCA
	ALmVc0YerPMrEBgvoaDDJIQqoGgohMc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63A8F60215;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB00FC4DDEF;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=Ohg00gp82JlQ1LRKDAbUvlgWiGhAXe+0uLM4Cvj5Moc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IvVf4DTXCK/sRrZP11cGRQmf093Be3Ab/egCpVqrqnT3+6E2YiQrhMR9W040tD12z
	 Z+9tDaBEABaSlDBG9r48ZFjv8v/11jw7hVOkq5uc4mjao5gu1bII34MZtrhdqsEAaq
	 WG5bvyVLVRDl72ZFUBTzvXOnDamPAUceTx4kdN4AVJXwpdA18IByiOs7Zb09gh/I6y
	 wmTnO/IS+MB7/f6ssZLQs72Zn1byrZFitIv5m1ayisoWr0y4tKVGFBf4BKmrkvX/g/
	 98xuyrOXGu+6NOR+lNY6zQAL3QfVUR0pRSESY/nDSsSDLAepqMhP4BDopsgqAV6l0w
	 EWhzbAoRaiENQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46AAC61DE2;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:34 -0700
Subject: [PATCH v12 33/45] KVM: selftests: Test conversion before
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-33-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=1811;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=a2z3tw2jbxfSjKhbx7xOpPsEYazJcgX/b0bAut8/tlE=;
 b=1diaXiAQiDZHo8GGbJSRZADZP2BnxiXUNSNdhvxA9SOoFSS7qJN/joh4qkuCEdJSeNSQuMZID
 NA4XQacd0AoAj0lKcrfLVuAtJ43ml1DuXWeXTDX5t32XEtHB8qpP56e
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 7tgz5h8tokkhoifywoe5oitmayjpcshq
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB26E160006
X-Rspam-User: 
X-HE-Tag: 1788135923-136599
X-HE-Meta: U2FsdGVkX1+nQupmEaANQ6ku9FZO/t/+ZeD4Rmiru0xVJdKeDO9GKqTnHg/rf1uaeeNp47ZeVeWeWo6eLI1uXcjce0b6zLZR+U4Xgm4RWhJDIQqYInKrq7DIgLswzNjzUj482Zp2alPLAswLSylJxGvw4MICxJ9rsufK0uKYRMOppgjS6WeKlwG8Efsiiq9004fU1lcG9QdqfLEITycbyqKi2HZ9DznW+aX7L41Ae2wZ0p+PrUFALgC3mKJOSnQMh7VBAuK2t/5f5Ki305xzaUxY3a5O5+mi3A0ykzuMs6HgV5rZpI/ZEqBi8/NMgGQ83X699Ze2GYkv5N2EpCds4Qr+pdGnZGajKb2kk7zkxq0beQVWXFpshL70q/qyeKRiO+rABff25ASSLQ/DbIMsNdducCmV0i01GYUqX+TixbnatCGd4OmzBSrwq5fP80hIfIafF56SG8ZTKeZbfNMIcRYOlbDczB/5NMorgTp08IQvpvbOwCKdp5He/19zZc71gL25mNJ+oUEfuTacMM+Rr1iIythuz5Crrgh+0FWPHFLXj4843xg7LYrNXDfGU9mhfIa3YNK/2jtoFaX3HxrKUKSIUGP36S287mipKxYBtu2gPynMNai++GVq3oA7hJPk+m6zYdb9zkDLp0KYlILfC4iEbFSBBKCdMwxj4De1r9d78uFfKvlCsuc+TPtunb+3FBJanmAPxu2WGsI6bCROghe2NIl+N3YB3p7Zs0S25Mnpie/JF/QqF0jU7sEs2tcUuvjEvv9QPMQaLwIpksOl3U6OpRuOAY9ebnsy9qDqwdlIa5D6LUrnwq9xWJY72id/HMWlyF9PJuFc44trObmmbAVeO/AD6JmOhHF4Y4+vOf0G36n4ykmm+fgvsaIbd8zBmaYAZH+YggYqFT+vNh3z5JlstWHJxGUUdaQAVdYFT7pon8v9psnEXGmGbDgs2WyHo04lu8JsA6wBTUcnmUv
 uyU/G0Wa
 CTQYApyfT+7ZzJLkwX8NyB0AgOcceHD59DSzHgMTT8y9BSwZZ/NM7Hlhl9LIMtB/+kmEvJr+PCMXMrMIftblB6u5h74Wiy0GPDpOnbuc6bmeOLmG1R4LzXqcQedqRKoml4LjK5ecGLN5CfsfEsjaB1734IFg/+rh4k8xtd1DBOgyE71YrFCJWnPFRREvT0muiIbQQkj7Huww7EM21bDG14kTH9+Mp34ofOfvIPTpO+9IMJEGSoljbO/EuWFoQXQeuVZQDh0+u5ijWciBEbZRs8ZaYxBmiEw4MWRdn7sss9drJQ971u41B1rN8Y2/fIWAdhL4olgv+q27ox57XlwGyIrldmyAEQMcb3gr07xyonftp2csNcN7d4Iwojfo69R2VHLfxRZ52zNqwTvAGe0X34vCeeLIsGsWe2qSMbfwrXNTS6hWCoIpJNt2K3aBndT8BRkJPjGDUOagf4lMF08E1t6K2ILW97IKTpmp8
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
2.55.0.897.gb25b4bd76c-goog



