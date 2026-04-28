Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECF4FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77F96B00BB; Tue, 28 Apr 2026 19:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F776B00BC; Tue, 28 Apr 2026 19:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C655E6B00BD; Tue, 28 Apr 2026 19:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B68F76B00BB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:26:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C82E1C189A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:33 +0000 (UTC)
X-FDA: 84709548546.20.73CA8D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 564C520015
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tuXGvioN;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418731;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUgK6eW6KySlIt9Ced8ntTqleHp81CZ03YdcDeItQp4=;
	b=Sm4WFdc/v6et0enuH9WcIx/64xHzHZPSHZnMXP3UP2dXLsrzqVTNlHVvpoT4r0+YdZum1D
	W4uWhZASj7sB+TQUpv0uZwI81QdTcNIp7ItN/qaNMOdVjiKi19Xh+Odv15zD/o08dv6L7m
	HayGX1wPxzhuwpxQpDP8jQotQSFFeD0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tuXGvioN;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418731; a=rsa-sha256;
	cv=none;
	b=g/VuJKe2adog27kjTpseeu0C9s5u0hIbOm18NKcSvkeKdQiLn1qQDrHELZliBAPXjEOSl3
	hNDGLI1EHHW5vN+bUSThf/IAcH/kx6K9WcSmhgR2PaigTSkK/9o1O5TzbfkQhLmf/5UOf3
	y9juyRaE7JiMpXgzK3g0CROAdA/iUig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6C5B444E6;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B69DC2BCF4;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418719;
	bh=W95IiIrObMcGrhAhPOa1Lzdp+cLl7f0y7x5Z4Hm0jDM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tuXGvioN52WoQt0JOaZJgEyfTYb1wwe1yCUqqeHib62/xvuhEUZ31BqZd44hMhToV
	 6qOrYvQ80z8gHDqsw/freo5a0rQPhmRRZL7wi6NXmfLlO8INMI9TgZSE01FxocsyZh
	 PdgbAqT9LB5AnA4k4rD9AwQcSBbDqJjqxKre+9vst80kxdHbSo9NR4JQVKjpz5/8tu
	 2ZXKwuurxDjsN6bKzHA0WGJAkjcLNVMY+jUQtW1zzPQ9WfgFctAiHu4tjULtMbefBV
	 0erieBB/MVon+2fFpzaSFknk4l6nJhG1DfdxKJmh9IL+obK+cgZZOs2M8Qbq6+2YEa
	 AgDMxdyHPupvw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 727BAFF8875;
	Tue, 28 Apr 2026 23:25:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:22 -0700
Subject: [PATCH RFC v5 27/53] KVM: x86: Bug CoCo VM on page fault before
 finalizing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-27-d8608ccfca22@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1213;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tiTenJm2569v5eEA4Z7Xk+parAwNdRT4spl4m/ukMSc=;
 b=Ddok4n3bkINYasSG44K3iwGimZ3Lx7mZtFodZ99SfqY6+rmIB6rUmN3BUBBQoCmaMltcVCYvA
 9LeCHnRTzRhCqSGRL1TQUNOKoyvJhWw8WcEOLkkGetGbfg7UvhxOVAp
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 564C520015
X-Rspamd-Server: rspam06
X-Stat-Signature: mjgf1ozmyy34x5zb1gqsf3qi6r4js17j
X-HE-Tag: 1777418731-41973
X-HE-Meta: U2FsdGVkX19F0q4mrjfzLPK2a+Im7c2IIl+CtNljKX+SW9BwOWVK2TfUqJjluiwbOuBtm0OFqD5mBaWRk1C8gqZ4QEoJYUeZxUFhIEWvvlV8p4JB2aRZ669bpUn/JiAWniXQzHIe2itNWd7vY9mXv5ws8W8mnGcU3Byod/3aaPlVPdU3P2/vPLBJv0XW6SaqZtZIbspMpNEdPfKG8lNWno0AAdD9J2scjnUwW3yD1bR2of3+s25JuRoYsf3JCF3X1dbEbX14aeiyDebZvJg7Eo2Lz5DPzOh6FAftc806T1DggvFIZeSEXSfUh35dw9kmnjPGkVrnLfH1eueL74qsBpUv2pbdpmb9I4NdMvWCUVXNUUhtFfuRSxCzAYniCI2+9i/P5Nut9e1mYVp3Ltz0oWBFN4Gt80T7I8fIawLqv2JWN5C+Tr5XJ1lmR/tQ7cojQEuCR1JblmUWuhB9qLX9/eMbY7h51Jf4wzl8IEy9XXln30KmkZl/N/wzxmDBHzbj/cGbam57Pd5daiUHJJFi3wdNfPFcD92/NG4pZNWNUCLcC/LANil8GzPcj/NLoF1BrjCKCSHhuiIPD87RAUaSfRIkztowSuHIeK6zjyY3oQR9hjSrwVBGVpWOwk8WuG6PzZQLewrBKrwTBoGMu8FgcptmlgWnHm3yQxLztfGoV+TzLg9c1HjWbYFkKftXKQWMsncYdS2KWNJhUcsL+Gq9cMzMz4nEz86uI0cpY1t2J7uF6JvHg5WOB0GFblzqRK/DGQNivuFdTgL3sbQwHAocWKWrYCp7HOHq4UfUnQW48BK3iHks3RZuF4iF3UrraUvxQeHrct0eXu7P8uM9KlvVe1qs7sTWfWGYYejCicUHS2BN811Bhc94v8Nt2MPHRy1mSLVxrgd9GdyPx7DaB2C3tFs0/ltsu057Q29ENWCMX8uSKPHV7xYlGCxyHtHwV5Hw2zXmOSNZ0LocKt0fXad
 YsQ0TdX3
 hKYdg0RITzsMIMVf5d7vHRTDvIIv8pbQBRjPYoNd073Tc1Dbsguh35xpk/iol7bLkjRGFYEeqb4uZQlO/AuMdXVXajhy/g+XhvrtfXWqfQ71YQ6Cnr4CCL5BKS9J2eSiNhLIvYMS4ZE4anaNHFcmn11Et/HO6MSNGFMohVfNOLfiC70VFQxuvK/vk1+azs5UpJ/TkXUmax3SzTo2nBqQkTEpFD69yD4bEOkmsCzx9EnEjmSeBGVsnKKYjW4q37BlOcNfMXpKr3IV/fisicbh7I7etUoQiED/0O4HhZyhtuxcMh8WHo2BEq5qZbeRt+Dl8Q/3S02jwaTyI3kZLfsLzT/XQQiCeA72JB96W4+UWsQfM1hNMlUGY5AHakikRadZ9IKAJGEElLiEm15/TLp8GCsdM0aq+7TGozI2t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

In-place conversion of guest_memfd memory to private is allowed with the
PRESERVE flag to enable populating guest memory only before CoCo VMs are
finalized.

Allowing CoCo VMs to fault memory could mess up memory contents. Hence, as
a second layer check, bug CoCo VMs if they try to fault in memory from
guest_memfd before the VMs are finalized.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d3da387340a9d..8c5a3d2a7470b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4599,6 +4599,13 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	}
 
+	/* Cannot fault from guest_memfd before CoCo VM is finalized. */
+	if (KVM_BUG_ON(vcpu->kvm->arch.has_protected_state &&
+			       !vcpu->kvm->arch.pre_fault_allowed,
+		       vcpu->kvm)) {
+		return -EFAULT;
+	}
+
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
 			     &fault->refcounted_page, &max_order);
 	if (r) {

-- 
2.54.0.545.g6539524ca2-goog



