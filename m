Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 873A3C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE546B00B8; Sun, 30 Aug 2026 20:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86026B00B9; Sun, 30 Aug 2026 20:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9CC36B00BA; Sun, 30 Aug 2026 20:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AADC66B00B8
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BFED1403C0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:39 +0000 (UTC)
X-FDA: 85159671198.08.B1A53D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39B21A0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwCr2oa7;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135937;
	b=OhwZZBUnitLEhJt6J7YL7LGJLuKbuob/802dpWwH1t4SBfb9jVfpzik1ip3TTeJ2BPp3lA
	PqvBMjqC/HocUZ6KvqSP06GYawko/qjdtR70N4xWi0z0m//eapK8DWMpnuDY2+OYYbFyJg
	dgO2hLnwaCjJSBGaQZZekvLeeSxPYEE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135937;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+kEhxynUlIii7TpihlQFGIJOGoryr6nU84GPni4FuDw=;
	b=Hwreqq0sDAC3DtyaZlS1Z3o1frBA16p5k1u15kXLwlqcw4DmAWw56wN+RYHBaUQpKe9DH5
	0SAcfT3lS0FzWNNWmoV7MODt7wVs6xUSCUhZ3l3MgDD5ai5v5UEF15vYl21fdam72Ygcic
	ad+Pkg/QEGR1Lvv1vCFWK+acqG0CCdE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwCr2oa7;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 158EB4492C;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B88DCC4AF12;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135922;
	bh=aioaJipFuIL/IiIdVQFffSKoyIBWlO7RRAfxqr7t6Iw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bwCr2oa7MjlpgIMpV5IMn9nVmbWDuUJe7pUJAIw28LiCU8XTplP9coJMkzRy/HYLo
	 CXcANtrVxycZ1OndPF3O1tgaoMPmf35RbkSYRIkmUsXbZ0aG2Y05pMxQLkpAvb4qLL
	 YUBYsTraIXqKXm+MFYsAxYwUZWalf8QihktRBhcfOOezNC478boEf/7Wq7cXR46pFz
	 glCQq8LjvVNB3LPOpay7qLZeAqSavDaus9VfvomlFK6TqcKWecUUr7egUzX3soHeON
	 Te3G9X7umUDRyuwE0zLCQUiscYX8GnS3dCu9SRys8mVENhd6KHIkt0PoS2suL3KzkC
	 vhHTBvBRXoQ0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBAEC61DFD;
	Mon, 31 Aug 2026 00:25:22 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:32 -0700
Subject: [PATCH v12 31/45] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-31-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=1820;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xYw2zR0sil2DMulPFsHrm+Fn54xO5rySrIonHJxlHdY=;
 b=biTv8DxdIPMmqKcaPDRSer+ZFsb/kdS9KwcKlME5qJy2Ary24lqI1vc+9urmZBiMg6+4afZzv
 nQji3gwfMF3DpmlvEhLSIM3IyNefcJ6PMRkzuv4bmBVy8WRbZwgmZPS
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 39B21A0002
X-Stat-Signature: crkynueiigs3tyewokomxbco3131bwgz
X-HE-Tag: 1788135937-407532
X-HE-Meta: U2FsdGVkX18/AS59tAs07D1P57iZscLUFcpmsE4KSFawKRuAUUjsRbHz2xC3A3tpMIYg0tU7ud43wr819dUvt5p25/Vs9j851LhogllZE3V04IrbwdOrOdQDZO3ftZ9i3CVkedLkJnaDWn22kNAHCZhdIPPWdssmF1/7lXFXV6sFqn4FvH8uF5SG8qaQr0WVKhuk2/ND3vmO3fynYBFkQFRNJRyvh9KD/Zm47VpoFrmoG7d97vYurBOr6tCW/jpCO9nf+l9g2PbggRuDDO7iCUCGrnP0LMYSmRn+Z0Mb2xpbzqK2A56+hscQVjEIKX0jd1h1r/r0rwNOD0gB2WrezkktcqeoF0p1YQetBOlr3M2PVnIJuL83i/BicolF9xpXcPszFXYqF2eRJ9QCLLbL3oa+8Y5cDTGELhl/Oxq22wLVfVSBXqam4rhcFwe87E0wFYXciLZgAZOknQarW8PASj45hnum91MwLP0Z0v67eK7poXEhRrqniG1PhLT3ndOWcUwCnhBcwcQ00fzY63kro0E2lxzbHeycx90lSEfUUsZ/HtuUlGxo7PygQ/3CvtKdeQzYkb/fUmET8rHCoOsfm8k2QTdgC86pEoHWjwgIaLGg8y9tX/lx3SFWvCYeQNW48X6O2xwg2BAOZDJNxd/i9O2FpxzfsZUH4RHC5of2b8zNV23LhTWKFenDS2gzP+CK/TPxUOaUF0RfLrzu68jCnuIDI36MRKZ9o0MTKybRiEooSYUsLCxfvQV4V1pvLWwFziuwM2fkiVOHoC5rz0l52cvm3w3ozoIa+7yJIR0zntwAM+aMKCbt1ppgASis3luLBAY84otu+VVu64MWY+SZyrB9sbUjmbrsM3fi7ypoNB9vBV790fPczlG08VYOzE5fwk4l2TNf7dsfALWmI1fEz8FdkMzovF6+aGAZKO9jJOfMGlIOrVzCIL/jrcj0s+8mpU7zOZ0QE2HUaXsTrZX
 URb/RpWL
 IF3SkUsI7tj3vVQj1sNZO9jcPDKXZsTv3wsL9/l3CYtYcaancena1mLAjhEllqK6iO4V4YaFUZkqb6Ksvkw6Qk3XognmtiTeeLVO9jiej57eqjHeKN5rC1qUuAx7Lypd9cr9Q1Qd3SgDoH9vdWxgmIpWziJjTFOY9o2/3zStQ8oHcn07UUKEbE3WQ90pcFvFy3zXgwxvp6/9kAx8dTm/G3irWYWJDP2wC7+cYvhgp5wn7rPL2puv/ciXk1s1iMR+35OLOPCKh1y5VgtjGPyWj9PMyD7Ms6nNOt3SE+k9zIoSiXfcoPTt8Q+lUeBTZuaIZhvMsfsnWmuSyFkqG0LiClgEeaydDBIRk4ae+86hL96Ee3Ote4ozYXSMiTjSVSFNTmISku6QfkBcF5vhq+9DJBLQKhwYC1WRSAaoejFGyWPsFfNPCTMDPh0eHXszA/SQgrqyfNH6Km+EU6pPXip2GoVYDSSdPmpsaosbasUIyU/ZrChJOG/7UG1oNe4FQMXZmp8Vrj/qsLrzRhmIp7+MGxNm6jQ==
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
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
2.55.0.897.gb25b4bd76c-goog



