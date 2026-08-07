Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6BCC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B966B00B3; Fri,  7 Aug 2026 17:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7236B00B7; Fri,  7 Aug 2026 17:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8686B00BA; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B06EE6B00B3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:52:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 461EB4005F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:54 +0000 (UTC)
X-FDA: 85075823868.18.2A38215
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 45FA11C000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:52:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXaXsEBQ;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139572;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8j4fyOrmDOcACeKi8cbk+/zrbBio8IoIka51ZsCOS4=;
	b=BS9lvu8ebI2z9Oi6tHCwj21xneMw4iafBQngjSt5epgXX447GxjUJ+HupGooUStypEeUgR
	zgYNXB5LJvFWxC/xmdd9f+Yh4DS70Fd27Mw2tW5wkbUSJgB/Vudd8vCrNWD7cqWd6KiZIR
	iAlYkXTAI2uTOf6zh0vGdBtd2XrkILw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXaXsEBQ;
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139572;
	b=WASxE868se84m1CnWDzqNJJgovZMk39nNXtYphKWjWpg/addH9cCWWdu5de+p3wyEeSDLv
	HBsN7gzQSD3e4it3yBVdsDjaxuXMBmAdAf1wFWz9J5XVVul3LEgwVXYhEfEa8oJ4aZdmtB
	oACDQu5+ltCOddOiiK1bUx9TwHavv08=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E29A144FE4;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75A8DC4AF61;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139568;
	bh=Q2oTqLrG2Xi7qOaSJzOIcKifMjGFtSLrE8L5+xB+HSk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jXaXsEBQzt5c6iRg8IbW4KJnhs+5r+44Tb6CuR4D4t1hOC69vcxS4ARag9OiWzUg3
	 Hq1MCcaqydv8q5yplqwOhSa/V0QAt0kFNn/1paxeIVHZQvWmFrAGyli0kCRFh8GYKD
	 chPJFHVxbLwqGOwhCv3woCqW7OhYlsIA6DJtfuDEXStBqaznp3d7fRqfmB5pNmKgnT
	 tB8b+2ldXAtXEf6Ys7apTR9WW0z2zOHhWMPIydlMI9wMAbX3BQ2AfVi3tsxejd97w5
	 vSocERu31Gw31ZhqMZYzmMZvq89WeRhRrVQFGfxUT8pPLRSEXJLES0U12aabuUNWKJ
	 OATo9UsAH/7ug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A39EC5ACD3;
	Fri,  7 Aug 2026 21:52:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:52:47 -0700
Subject: [PATCH v10 08/41] KVM: Consolidate private memory and guest_memfd
 ifdeffery in kvm_host.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-8-2fc18ee6d3ba@google.com>
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
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=2484;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=EV0WfoRp32ZTbW1sABDnt+s70i5+mhToqmVJyPng6P8=;
 b=evXG47pZgMj9SONAGK9U8n3Y7iXSwtapV2A8gESBHNoFe8YGA8Ic3MslrdR+Qamtbl/TxWRkU
 PNjX+iUA4KbDtEXk/s6+aQLD0zdWkRncid+9TmGEcBbUWPcbkAF3EXs
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45FA11C000C
X-Stat-Signature: 6kzdb8trqyew1n3q119ioy66et79ffja
X-HE-Tag: 1786139572-312066
X-HE-Meta: U2FsdGVkX1+i/aMyoKQ84piPX46h1hKD/2BqhfRO79eUzSXRe93tYq7t/XjYsvA/xF4CV4nVuNWhF7ZoCVDewL+piZa4Fk2WgXTdLwMz37s/7WwZOXXtF3owVyEez2bHhSBaL/zsf31HOLvRkMuxcPAzF4bQw4ITcy2V+3ZqGxVAildPTWhiln7MM5SMCx6xPmqrqmXVEvJxXKE7VxoHq8hk8O3ZoGZbWwmYcYugz82VQ7EPDw2noPFdWTfI3l8Byfg0IITodUieFs1SeVDduF8baVaD9g1R7sYObtmG/bar07GzPGZK08ny2hDR7NoFYeIJWPQraGRuCD2G5e8hrkySvsMojh7vaIPQps7F978EZed3Ke2+LFWHU55fDcywPZALfPSRzdsIpyyjR640hOdPQVllZy1ALTpuzZbBWhwDXlhRcAZKo3RUouMPP2JMvaNN/+DnMWICS2zWp5oQEnrHzSs2YoSYXu+Qf6uFgBL7DX/uyc10JHFi96WMOaNOCCI87Uhm6GQ6O3sJctLPst3RnjGlKTaMgSJEIBUhJ6FLVEYCoIwGZiqByfo+uGYrAq+rZppG35MoIWos3S0bw8CFVxsXImmSA+U7GmSy7KgKByegZFHEL9rjtk8lDSPjhPr2X/F99yyuJ5bnXH4E3ixu5xzEyHSK8iXKxrX3atpN1C7KBG3mvRg6K10uTwTIYy1w4BYksQf1pz1xYPdLU5UK/i/IpFbuYAECQVA+bbetGaFJvjeMWyainyVdGNPE/flR3QTeJD5seyTqp7aUFeXCEere3aqlohqCtUbFmSphtYQsRc6DWMMDmSZpdou8eMnSuvb+FZ6TTA3rWBDJv/CJ05PVqt/ZyDgSwbk8qWUT182bMY8K5L5xe9ExJBZUVe83JV65TkFK6lHwER8KZcoIK3BdQJL8rEID2lBLtzTZlqDikDt4uK1cdJ/UtVrAciUhNcFC2lT2lbd7php
 rM0HOU3E
 X+yE644G2oR9cfKWP1SR2ti5Db/OIvak100G33JvqRIC3RmoLi1zIkvKMnsK8oprGjcDVW3kZkoNEuf2ALSkfXVabh7SNSgvkvNoscKfqtj/r4lJW5AEuloH0K4CQv51slBucODHbWp4+rWBs/X97VYPosniB7X3XiuVo5vCRW9caZOHqgGOahfWYZgoCObmtaqIyNSZlDPJQJbuWc0iUjS2+9L2HlmZabNFBio2SCsg3hTe9P65MFNPWJcJIhRgF6p4lf2xS7QCAlIEFDFXavISAKQ/vGW9bA1P8X7TIzs9RwIhTtu2AK/d6NNIEThuONhsS45T9jfbhj5dfDSCuCQ6FZWVR4biKZASzTdoc3FbQvoUluBM64iB4D+7ZCqElIH9+M1LsGHk+pHbE4Sq7BJRB2ffokjBkB3xIpe5sXIE+kW4YNkFWGWYCd2riACMuIYSpsydUKAQKvGUzP53XWuBRikx5QLGF4XOkvZ6VX8Q2482OPIXstxmNngrW5ZzGk08pk+c1m2JmcemQ91YhdqYGABOG13YPKgbMEGM+D/bUvZNhg5PDFD7HIXdZ7QZ6j8/kDjQNLaSFJ/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Move the kvm_arch_has_private_mem() stub and a few guest_memfd function
definitions/declarations "down" in kvm_host.h to utilize existing #ifdefs,
and so that related code is clustered together.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9477ecebbbced..dfdb3c97a7ac9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,27 +722,6 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
 }
 #endif
 
-#ifndef kvm_arch_has_private_mem
-static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
-{
-	return false;
-}
-#endif
-
-#ifdef CONFIG_KVM_GUEST_MEMFD
-bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
-
-static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
-{
-	u64 flags = GUEST_MEMFD_FLAG_MMAP;
-
-	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
-		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
-
-	return flags;
-}
-#endif
-
 #ifndef kvm_arch_has_readonly_mem
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
 {
@@ -2592,6 +2571,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #else
 #define gmem_in_place_conversion false
 
+static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
+{
+	return false;
+}
+
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return false;
@@ -2600,6 +2584,17 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_gmem_is_private(struct kvm *kvm, gfn_t gfn);
+bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+
+static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
+{
+	u64 flags = GUEST_MEMFD_FLAG_MMAP;
+
+	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
+		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	return flags;
+}
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,

-- 
2.55.0.654.g21b8a5bc05-goog



