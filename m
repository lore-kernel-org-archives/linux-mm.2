Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 107B0CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B226B008A; Wed, 13 May 2026 21:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CBBE6B008C; Wed, 13 May 2026 21:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1E16B0092; Wed, 13 May 2026 21:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 523726B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:31:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F68A40223
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:31:39 +0000 (UTC)
X-FDA: 84764298318.27.037BF72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0FC89180009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:31:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QJp2z/0Y";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778722298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O90BZQoXeu34kftJ53DgTCktjsrUsyhmJJ2rR0RhKO0=;
	b=krCTnjR+7+5InMMFfkDnWW7t1B8KU5GEmmCwAgeLSfBQ3HOL7gbgcfdf2bCK6k/UtdG2dI
	Tx46QaZc6gcZuCJmGWrqr97EMssHXL/U4O7sYdHxecy7Jv7CY7dl5/JHucez7z7YG4kBwJ
	pItfwz1qiUzki4oWpcuZGt+3ORyZsfU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QJp2z/0Y";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778722298; a=rsa-sha256;
	cv=none;
	b=ZIjPUyRMhnsqNX0/n1LEnblV7CQVP+ttiRNa1FjbAGAKeDZBtlKyvCsyJnFcwaj48YuE3R
	jQnk7IVRT2sh8yc2tyfu14Wx8bkLRaddB6oMzG9rUVmPuAhFd9caKq+X2q185BBRnm2mY5
	yH2lsaj402g3D0ry+jP82frmv+0PfTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FF5B600AE;
	Thu, 14 May 2026 01:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4E2C19425;
	Thu, 14 May 2026 01:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778722297;
	bh=Cdh+pQ8/afF+yyCKEmvTOqX7gj2JDvxII6ghktFLKBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJp2z/0Yk21FpxoDDBkSAmtkfMAppohy3KdW+srzwW94GoU1vSNBd3qYf/f/eOAgW
	 8sLjnUZMX0/Dwz/YQ67WGw9ppEz1qKCiq4nP1O07QoOTtPPNdotwFe1WMTqFjuefi0
	 oQrJf+7/OF53KVqfGQ5u7J77vMVn/37M4FIy1ZByEeTtV8PT5z9JHb+Ru8mLIMI3xE
	 q5q6v2IniVL20Va2dF7TQKbdozNMOPIpK1+X4TZ/mP/TCh+IyRPz+8dbvtNBCmTR0p
	 547IwCghVQNiuuc/+U35iiM5hG7avbrl1YztJDI21ibuIjY4HBPBMJm2XAfHIVeRhJ
	 s5hcT5V1pPPEw==
From: SeongJae Park <sj@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 03/14] mm: rename uffd-wp PTE accessors to uffd
Date: Wed, 13 May 2026 18:31:27 -0700
Message-ID: <20260514013127.148945-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <dfda2f55e155b17535ea9fb8330d9fa9afe0c0e1.1778254670.git.kas@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FC89180009
X-Stat-Signature: tdoe448j8sud6xaqchxop95qh6amz9d9
X-HE-Tag: 1778722297-188170
X-HE-Meta: U2FsdGVkX18UzeA/e7mmm4nibo2szKEWqvMi3ViwmoEpPUJB5Ue89lAxmQQjKhnPFz+dzX7xY/LZFdrZkWeNt8jsWWz3qU8QocZyYochg+JPUoVUTcSJ2BV4vMecLmpcDOyS/GM+5fpfcb1pjRmrCsLnBd9qt3NKnr9+UEtj5xiU9KbP/NL6YO4vDRVY9a4QHhkyjDMPyOMcWlm30eZ+RTuHiK3fNmUt7TrOsyzyvTK4z3JC2DFaeOnArLjrRigCz5rQpRzSWiBl+vUiIUCsBlSKxVgal0YrPmI3uC9dPXOlbVuL/9UlxtmKuVapuzFY4K+q14RHK+ZnlSKcX9qRjVZ9o6tQUUM80bio7Y/4tQ/vbULgDP/cSqAIT4H1TZlHNtCcuxvCgUeK8+ESrjR4cFZ1iD8XEMsw0AOBddGNQolr2mhVVr7t0uNVWnUmKsritK2IS58ikxbl8e9tn9+wwrTDFKvxvL+CZksm/2xeogczMwK4E5hJVQuSxee27BB6t7MKBvj6Po1rG6lTbUsAzZVxTQD9Ms4ZiYYRNLhwG38KZnMtTjxodyE4G8EY9R/NpQjYZlFEiq1jqMavZa67Yw+GlP/tR+EUIFKL8JfTAI/6Rv548+OhPKkJoE65PA0x7Rjw/hEr63McmVKodmsK4TxpgPFHpT6aKta1Z6F2Wp1e3gvO1PBI3Hr0uYGp/Y7LPpudJUxhEfqBYzbu27qga6cogvAFCwQinyOyI8vOKXsLbg9sZQQrmgogHVsA+p2oojCl04ttTUZFmKVbwnvFxM+RJXZ483+j7Tc/p5iiib1hB9NiVBLWOUOixAY7LAvC0rBYwaijgAsuleBVii4qqJT2eOZhpWseSaYLxe0nYhrOMFMZOqtTI4lJ+MHqz2V+352xqGFHbhoj8m5a+rmB4aanNHy5cDm/gKLPjOMB5V+dcnT1HnHR7WqfVEecbx0DDCP/u9fCPWCjuJx0AnQ
 /Cd8hC6a
 RlVdDbi8s6a4SjIEFdSWxzXmKotcptdfrTOJ1F0L0iaUtGRbr8urF5SOsPtbKD0iFml1n+W2KNXrwpm+dqLZTntIdNWk3gXOVjjdLunAveQDuRqldhRvASH8ggbtgLMi5AhPZmYFUcyA1cnmVvQxo77ls4AxhxFVBxUSuX5FQdrL5zot7sRHXeslqtU0exZcPk4IzwtLOzIqupD5rSYHWcg4I/G5dCh5/6cfA3JlfInVBT+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 16:55:15 +0100 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> Userfaultfd RWP will reuse the uffd-wp PTE bit to mark access-tracking
> PTEs, alongside the write-protected ones it already marks. The bit's
> meaning now depends on the VMA flag (WP or RWP), not on its name.
> 
> Rename the kernel-internal names that describe the bit:
> 
>   - pte/pmd/huge_pte accessors (and swap variants)
>   - pgtable_supports_uffd() capability query
>   - SCAN_PTE_UFFD khugepaged enum
> 
> The ftrace string emitted by mm_khugepaged_scan_pmd for this enum is
> kept as "pte_uffd_wp" so existing trace-based tooling keeps matching.
> 
> Pure mechanical rename -- no behavior change.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: SeongJae Park <sj@kernel.org>

[...]
> @@ -4934,10 +4934,10 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>  		softleaf = softleaf_from_pte(entry);
>  		if (unlikely(softleaf_is_hwpoison(softleaf))) {
>  			if (!userfaultfd_wp(dst_vma))
> -				entry = huge_pte_clear_uffd_wp(entry);
> +				entry = huge_pte_clear_uffd(entry);
>  			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
>  		} else if (unlikely(softleaf_is_migration(softleaf))) {
> -			bool uffd_wp = pte_swp_uffd_wp(entry);
> +			bool uffd_wp = pte_swp_uffd(entry);

Just curious.  Is the variable name intentionally kept to avoid unnecessary
change?


Thanks,
SJ

[...]

