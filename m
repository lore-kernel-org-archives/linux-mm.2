Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F4C606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=DP6Ih9JU
Received: by kanga.kvack.org (Postfix)
	id 0CCC66B05BC; Mon, 26 Oct 2026 09:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E386B05BD; Mon, 26 Oct 2026 09:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED62D6B05BE; Mon, 26 Oct 2026 09:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C62136B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:30:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D861140732
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:30:56 +0000 (UTC)
X-FDA: 85364862912.16.98B7AD3
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf21.hostedemail.com (Postfix) with ESMTP id B02C81C000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:30:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DP6Ih9JU;
	spf=pass (imf21.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4UXRSWdp9L+slM0l5w1zWdkgLQIsp44pt/Clrth68c=;
	b=RM/pEITnTEmM4VSULeUSPG4onTk3Gom4BL8/27Z7D9qXb7M6czcRGjU9XtVoVBz6BFGojM
	K+5BRS91IDzUL2JgulJfntjDsaEa/JNtH6xySxh82lYr+AfQeYGL3JxwpG2eviEC0skHS9
	IxvQ85aGX+deHOzXHvSCqlrGFbP6BLQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DP6Ih9JU;
	spf=pass (imf21.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021454;
	b=c/bsFLctPf3lDDjv3gaGTWsogu80aavaG6QpZW9Y7YLJTz8+xsZcAR69ozDhYOkMCyiKzt
	RqyExLRPCRCphmcWKyZpuwNthBYa5aMSZmgDQEXz4U7Gfe7IPpLvVvGXM50vPSO6xR+7cm
	B72iJOisLmYmJseRdJNPPzxEKmNxOkM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793021448; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=J4UXRSWdp9L+slM0l5w1zWdkgLQIsp44pt/Clrth68c=;
 b=DP6Ih9JUTFHJoJ6beHoY5BaEe7d958V6WxgXvakOnJLZXpVkQEOcM0/N0cKL8kgrOk1NQw
 cdXwr5CfUFsWgpejmChAasJS28yJSGdTRnAIRuPwr0vOkGJI2pPv5vnX7A+D7s4XKE/yMt
 LN7YPQxWeCtsu+Wzgv7ckda0sM1xuuV3AmxVUyZLbQCQaP1vCFcQm2HtQsLCNZJPxDwGjw
 JAnrx9LXT5xkjzKqaIk5+wTtR3KGbOnmfCaa+RBsQ3giDBE8rciRgjP8JhiWM51rv1ed6j
 ZsmD9MbUg1nJgkR3Xg0miLmNUxT1UN1/Z71kuoXZMxFBvevjpwLmA690gREaOQ==
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid PTEs
In-Reply-To: <1c0141e8-3033-4f59-b247-34dee14cbb1f@kernel.org>
Content-Transfer-Encoding: 7bit
To: "David Hildenbrand (Arm)" <david@kernel.org>, <catalin.marinas@arm.com>, 
	<will@kernel.org>, "Ryan Roberts" <Ryan.Roberts@arm.com>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26adf5606+af6419+kvack.org+zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Oct 2026 21:30:08 +0800
Message-Id: <52e7e1f6-3535-474d-9b46-6bb62f96eefc@bytedance.com>
References: <20261013093600.54995-1-zhaogongyi@bytedance.com> <daab2f45-56c2-48ad-a24f-aa4f889e4da2@kernel.org> <e0f60526-bb95-4d39-9a7a-72cdf32ca5b6@bytedance.com> <cc2e3af6-bb56-41b1-9cde-151797c3068d@kernel.org> <3b57c214-6a43-4fc7-a531-fb5eac196465@bytedance.com> <1c0141e8-3033-4f59-b247-34dee14cbb1f@kernel.org>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: <dev.jain@arm.com>, <baolin.wang@linux.alibaba.com>, 
	<lance.yang@linux.dev>, <mark.rutland@arm.com>, 
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>, 
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>, 
	<mhocko@suse.com>, <linux-arm-kernel@lists.infradead.org>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<stable@vger.kernel.org>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B02C81C000D
X-Stat-Signature: kcarnyt5nqxqftcsexbkrqc83s79rbup
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793021453-705654
X-HE-Meta: U2FsdGVkX1+y7EODeqOxo1EWN4pJJ9nEsbwq+RSrXuFpXlpkpIid0NZmBZLMEos6CRJfaW7CGG+vxTu9Fld11f8K/Xp9CumazdtIFACMI8g4I2rSY+tllwcevAHCQg8h8yxL+Jj0pCju1YdklnaHwTEcW7GgwVcLZyRovY6ciA3TB7nsuf/qxzfxbevpv3eiOQTbFmrWGvNEYNYzf/bPu9/TiLt4qCTpRsVrG4QMl3aiXFXi7yu0I42/Y38aFFKijR5dlGlbqaGe9Yj3wwCNxieS5fUmdCdDPKI/hCJHYsGxs7h5QrnJZspHzgs9zK3VgHOUJ3XEmvFNF/yEEqE9g9fJSqct46BMUJwx9k2aGGnhdz/D6NGjI0IIeozJWAnppL2i9XxAEy2CTu25wvIdTcgXofD42C2qYufpJwXmzSobO4IwhNTmUoLonHPoetCgDOEZg/kCZJbnizGYEO47wlwM8SS434ip6EEr6deim/fDiIxE5HLLIGfUkR+fPH3uZjDpRNUKZ3pFRFcZ1e1CQIZCeFRPq4qE621UnlTxs7ryMhrRrt38ujdazTcZVd+HavdTf9n3YvFJwlAAkVXzV47UMAYVluhl2e9q6jH/vatLxQUbMKKdFDAkaKpMAM0Qro+gZVDxL/Fa+y/DvE+1kfdopTSgQzgie6SSQFMQjZFEgAu8eJAJe85kVLrxR0riu+pvItVcCZ4a3WdC07Sybf68JP5mJio9Yc9+fELN9gujWCwmtjCCnrGC0Ur/MMDnI2lK1P8QbT3Q3BLTQizKCYoGrpYlBlCngPTb/KXHyIYaZNs7ODh0WkUr5YRp72L9E9Wv0dfpJC3xpm0BAr1D+IDl3SyD7gJDuwLDn/jKQciGVoKTIWeK3aFXIsd8ZT59DZ82EVBgvXmyTaOZ5DRoFrjJ5KUgNK4cMYbXR8n71hL+wjmsEvDY78hFb37Fk4U/NZJ4hIaZbck22ncwmFt
 7GcFdC1p
 XAXwVENAxDlloDoMm21URHbLgScv9kUpooR01bvqVRvqou2FyyL1jvkF9grUlN7I+efqgJsfefZuGTe4A2WouTVYqxRswl2JvlwlVzHss3btiOD6nAHqqraYtXV3gru2LSyLgceGAFaItlS8q+FqIocU90m1sZzW1e5mA6zwruCo4CT97/lt24wZw8CRh1En06eBXlnb+Yxzm+YePfb3wP/No+hgOp9bRLPmU82yUCZH0+V2vb/XWkFTmAxs4v4J7NtRz5CqV5//GW0bPPhYp6Jq0jHo/lwGQdEnDHeNHx9wRFym/shYlV5tv/uUcYdUWFtLl1szC9idL16Na08569iSMm7pNYdiKOxr7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 8:34 PM, David Hildenbrand (Arm) wrote:
> 
> Can you paste the code here for easy review if that it the right approach?
> 

Hi David,

Sure. Here is the minimal prototype I tested. It leaves
contpte_set_ptes() unchanged, so present-invalid PTEs can retain
PTE_CONT. The pte_present() check excludes swap entries, where the
same bit position can be part of the swap offset.

diff --git a/arch/arm64/include/asm/pgtable.h 
b/arch/arm64/include/asm/pgtable.h
index 6000905a2..2f89959ec 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -185,6 +185,7 @@ static __always_inline bool pte_present(pte_t pte)
   * Returns true if the pte is valid and has the contiguous bit set.
   */
  #define pte_valid_cont(pte)	(pte_valid(pte) && pte_cont(pte))
+#define pte_present_cont(pte)	(pte_present(pte) && pte_cont(pte))
  /*
   * Could the pte be present in the TLB? We must check mm_tlb_flush_pending
   * so that we don't erroneously return false for pages that have been
@@ -1704,7 +1705,7 @@ static __always_inline void 
contpte_try_fold(struct mm_struct *mm,
  static __always_inline void contpte_try_unfold(struct mm_struct *mm,
  				unsigned long addr, pte_t *ptep, pte_t pte)
  {
-	if (unlikely(pte_valid_cont(pte)))
+	if (unlikely(pte_present_cont(pte)))
  		__contpte_try_unfold(mm, addr, ptep, pte);
  }

The diff is against 24a19b953e2a. The runtime tests used the same
changes on an arm64 tree whose base pgtable.h and contpte.c blobs
matched. In a QEMU/KVM guest with KASAN enabled, the guard-marker
reproducer passed 100 iterations, and the fork and PMD-split probes
passed five runs each, without warnings or KASAN reports. The
unmodified kernel failed on the first guard-marker iteration in the
earlier A/B test.

This shows that the reported failure can be prevented by a small
change to the unfold check. As Catalin pointed out, this prototype
does not extend pte_batch_hint() to present-invalid entries or address
the other pte_valid_cont() users. I agree with taking v2 as the current
fix and considering the broader grouping changes separately.

Thanks,
Gongyi

