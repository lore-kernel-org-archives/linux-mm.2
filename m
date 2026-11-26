Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4929606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N6q86/Uu
Received: by kanga.kvack.org (Postfix)
	id 175BC6B05EB; Thu, 26 Nov 2026 06:19:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D426B05EC; Thu, 26 Nov 2026 06:19:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BA96B05ED; Thu, 26 Nov 2026 06:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA37B6B05EB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:19:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 983391A0F9B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:31 +0000 (UTC)
X-FDA: 85477024542.22.58701C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCBCA120003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N6q86/Uu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691970;
	b=jXo4LsSdCWMajrXBbwCZsIubfs9QXYsajlxA8q/OhKGP/WnOVOabKSXrhFrRC2mCx5vRwv
	GJf1UDFsQfvdadltnQg2D8i0/LKauG2eJ5+c+dzQVrSrr83m5Qdbio/17KHdefqnjLLQnq
	uqsXsOdDvs0MvuPdGBL9/obvZskaui4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cPWUjHIPI7LtCSNqYYvsVdQiH3MUbUDgs7gRvdWWiI=;
	b=4JLHGu1zhr/oIn8okPXiB+X4gFoW/vDZi9MkMVSusUpLHIRhWcPZdZcOQWipOXVnJmXoGF
	KAsL8LqyS5izZ8ChFqc4wSBz5fQToaDmIRD2s4deM+dc/Asu72anm8k9u4YMoZ7LVkpNut
	htonnCo7KDT/4PFoqim7Ex/DGplvUls=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N6q86/Uu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78CFA41794;
	Thu, 26 Nov 2026 11:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38AB1F000C6;
	Thu, 26 Nov 2026 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691968;
	bh=9cPWUjHIPI7LtCSNqYYvsVdQiH3MUbUDgs7gRvdWWiI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N6q86/UuKdbMrBdtERhjhVFw0CbAJ4clSdTmUchWL6RgFVkEFE3mEFyjySuZ/PEVC
	 rUCd6Kq2go9A79rGKv9HgKqGK83C2clZ6aUkNYsA29a1Wo0vuxFjA1XROwrOgbp8xw
	 aOL75eZCeV1YUWJizVWuqhiRYrNriruvGv6qFzQV16MzEVZyn/pOqMpQzhn0BETYu1
	 Pw/fxf1OEmACLN0sONM/NixOOFWiGvIiGavxH1woaBbI73/XNSn75AXasiZb0IIKd0
	 HqmQAy3YxyZej2Z4YIxY5NMru1NNVtgYbxwMHf1zAj+lpMo3vwasqVbinhwzpc4VDC
	 dZfOgF0XejigQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:44 +0200
Subject: [PATCH RFC v2 31/54] mm/pageattr: introduce
 cpa_flush_tlb_kernel_range()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-31-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DCBCA120003
X-Stat-Signature: nu7tq9ek4ccrtkmfyrbr6fmwea8rgdm7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691969-171011
X-HE-Meta: U2FsdGVkX18PUssK5aT+fwnFJA99xw/zu8HCnyiKgK5pstSnsaNpDexBhgl8UISdn4/Jr11JxSyYAjY5/+Ux/xZfq0j2JT4JhwR+D3WYqT0AMA1WObaKdo7tXcFP7O5W5281F26UFPRQPlIG5IRlnFwHI8vkXJHlD2SfouhIVrfm5Pne0WMtmH3FaP7z+uhLPHZ8eSIIElPRTDh4SBCSFFacGgGnb/JDHy/ZoE6We8L/sU7ECT74Al7fVAdTjxXFPU0GtJ/P5aSFntO4yrhr8KhPkNRpQX9aq1dKeb2gJoo2TMhXA/X1uSUrI4R/VPUuZyYjOObUIovqvs2sWQymddOg6iBMyNCbkld6tMZVAqSJe4U/MMEG2iKJTrXaQZz9q5yLShGhzNGVw4+5QPGg4hV9Xj93fZRFICaeiVq2V8Jm8ZfhhfszgAbJ8q74T7kn/tLTbj/90qWL2hDN2uigVZJB/oodrPG4n7AhL5+wDLP5T/pOBfo/T2d2rxAarbr+z1V+2G5DoRuqFpqoPFUMaUXVWHVSFX/kn4A18wsMN9IbO1qHD224ZW3HfhvPxs6ezIiZewSJKv6emX3BQNlWbMfilwI8UaS9cse0mrcT0SpG3f8xmU19jzaSdxq02xIeov2AUpPZaw/7MWq/kMwrL/CdXyjxXeb/dHwle0DnyCv0AWSFfLqa3a2LWEkE7gIknT1wyneXkXVVsagHSiEdJzYuhrAXXiS1xHKG/vKwxuHGyNspDXUmqktZjYbXKO2M5QcS0f2NetJqaK7sYq0XDfaprV6I8WR9AhoAPBJD6mijWXB4MFCS4QQbCR98rd90a1TVw5/xnUslPs/tXFigCcMmRFBLMtWbrh2IMWh8TPgIWeUkd2QX/mPEiCxO0vmBP5sNDcXmalMbrJCxATccon/zUeAkP1LUw+gMs8b3a9aItA2x/fnkyyHR8B0LLmTdHv2NhLMmFxhF5Ki/bCq
 +8enM8Qd
 isdOufwP+nk/VN+clvolzCSamH0U87ZtWO3N29kLgh+HHynx/NwPyozOyl80y1+cb2h2Mkv+mdxiQatPvmPvyMEETmm3pf+3G81KYsm2HHBvOrKBWqRmBVse/ZM74W0Udm/fzAcn0JcMuUrt01ix7T2bnibrCPp3qIdSJHyk5efVmAcWCY6/l8RlagcBvTCu1j5vNrEbAUBMyIoomoTSYFTU5rVsB79dX3dR3bEK4aFL+bv06XxuZYmJTSG3dWMf6AR3QRVgMUaK7yhszPZZil7hwqTahezSI61ZMqj45zYVBBSavT+4C+oEC0DJxWW/pju4SaRCeyuYIp3jlrZKYoA+7X2KWoM1eoQ8nUKBcWVJk7RkyusaXlIpasiPzIyhJWmXLeZCuuFVamvSoNcXyxNXrAxTVQLNIbbUI47aujRKBSCtgq9ZzIT7E1oUu/D3u6Ild3XGndWssQnAip9HRKaMgXuojrRaYi9+Go7KhilTHdGby4fYnYnXxwEcjugrzf4qbj1dvVr4WHf8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Many architectures that implement set_memory_*() APIs flush the TLB after a
page table update with flush_tlb_kernel_range() for the range of the
request.

Add cpa_flush_tlb_kernel_range() helper for their arch_cpa_flush() hooks.

When to flush and whether to flush more than the request stays up to the
architecture.

LoongArch, ARM, powerpc, riscv and arm64 will use it when they switch to
the CPA core.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/pageattr.h | 1 +
 mm/pageattr.c            | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/pageattr.h b/include/linux/pageattr.h
index 25f04e61ee85..091408ad328f 100644
--- a/include/linux/pageattr.h
+++ b/include/linux/pageattr.h
@@ -65,6 +65,7 @@ static inline unsigned long cpa_addr(struct cpa_data *cpa, unsigned long idx)
 
 int cpa_process_fault(struct cpa_data *cpa);
 int cpa_change_alias(struct cpa_data *cpa, struct cpa_data *alias);
+void cpa_flush_tlb_kernel_range(struct cpa_data *cpa);
 
 int change_page_attr(struct cpa_data *cpa);
 
diff --git a/mm/pageattr.c b/mm/pageattr.c
index dcece32ebad2..852e0989dac9 100644
--- a/mm/pageattr.c
+++ b/mm/pageattr.c
@@ -14,6 +14,8 @@
 #include <linux/vmalloc.h>
 #include <linux/set_memory.h>
 
+#include <asm/tlbflush.h>
+
 /*
  * Serialize CPA using cpa_lock so that:
  * - concurrent requests don't split or change the same large mapping at the
@@ -482,6 +484,12 @@ int change_page_attr_noflush(struct cpa_data *cpa)
 	return ret;
 }
 
+void cpa_flush_tlb_kernel_range(struct cpa_data *cpa)
+{
+	flush_tlb_kernel_range(cpa->addr,
+			       cpa->addr + cpa->numpages * PAGE_SIZE);
+}
+
 int cpa_change_alias(struct cpa_data *cpa, struct cpa_data *alias)
 {
 	int ret;

-- 
2.53.0


