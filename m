Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581C5CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681436B00AA; Tue, 13 Oct 2026 11:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631DA6B00B6; Tue, 13 Oct 2026 11:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5202E6B00B7; Tue, 13 Oct 2026 11:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D19F6B00AA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:40:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B10F780CE7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:40:07 +0000 (UTC)
X-FDA: 85318014054.13.3030C33
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf04.hostedemail.com (Postfix) with ESMTP id 731B24000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:40:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CbIVFpFz;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791906005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nj1TMhPOMkYB6MWx6yQQPG1mHpG2YJ3gWeRMyW8XpyQ=;
	b=42pgFCbOFtjRygz+BsRslCemT5cXaftzK/qHIhKT906Ye6KXgA6hpKOlnsGHbeSj/vi3EQ
	YaDQWwEo62CuATjFhJg/4U8b1yPgdul6qRXliKWeVIcXyiXkWxvhHTN5nXDw1xIu7/u33f
	grcM71lY9Gm0SMQRj7eLerzLkjPw2cw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CbIVFpFz;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791906005;
	b=0TGVULnqoqdHpIcJOqg8BlUE/mjmvdBKocGwwQsmg62skgvva73blg0v8WdiCppht8/iSi
	Vy6tk7QgmrcfiXGBjfP/7RBqYEp9FSun8jrOK/adQ+UsbIWaK+9RmkHY0WR3ekDEucLw/y
	vOX5jV4LrgArO1S+kim9wI+fbCE5Bmg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wvI3yQEb1pra9snQf3HMPf0AqFlWoLGzhzZcKtUO3i8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791906002; v=1; x=1792510802;
 b=CbIVFpFzbvBZ6HFblwi9Sb2Ng2vo/5CtHr8jdpUpJfyFP0rmHhgvjF6nrCEl3FMJIiJRgIr9
 ZbTVdh9AQTmDCe9FB8/Vz8xt/XXiOxJkF47VA0MZ6d/yz2HAiJ2wybh9QD08SWvhHFaU5MWfNII
 rFg/yXiVkz6lsZ4pqqBAewts=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0335801ba07d6e44;
	Tue, 13 Oct 2026 15:40:02 +0000
X-Mizu-Trace-ID: 0335801ba07d6e44
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: zhaogongyi@bytedance.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	lance.yang@linux.dev,
	mark.rutland@arm.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid PTEs
Date: Tue, 13 Oct 2026 23:39:53 +0800
Message-ID: <20261013153953.77575-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261013093600.54995-1-zhaogongyi@bytedance.com>
References: <20261013093600.54995-1-zhaogongyi@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 731B24000A
X-Stat-Signature: agrfa7g4ndxer1xagfxntfandpzibus3
X-HE-Tag: 1791906005-64668
X-HE-Meta: U2FsdGVkX19l25e09PniXrTUzQTHxv7JISYdMWc23ysnZ1dg8wItbRpb7UhDkTgevhcF06AMaIS0UNyYYlnhH5ro02jFxJcI7r8fTFyg3vVH/Vmomrzare9uwqwsCaTjjqqZ1JJym+OO+11mTQZuRLdqbdrit3IWZH/UA34xbmOT7n0MjNSuD8RLxTyV6sZ5RJeEmkKWQnDn7H5DITTvcP7+RziotvuMGb98c9OleE82v2fo+5RlbF3ALGlTfCs1Viz1SuEk4PKO+jYsdU9Rw8S66nwGBxWd+W9b3WJIaNn09+Gt91sWGiOXvb+SaXNjUM9hogml1NcY7npvl3BTRSKFQwTsNkGSCR13a/NY6ESZ92eZ6q98RK1Tn/QXp5IZfJFTE+eqq0f51iOosphLGWzfl447k5qNIK6/j+fVaCmJiyrRugkCdMUmcNSioGDkoqqaQH6UIHoB4KauMb7ELkgZsFju8KWIp968Nbo1rOmwnllCPEUAemRTx8d8any846Tnqnp6U/1X8zbQWZGCLoRWTZR71undodBb/pypZ132HropKuaQadUzdhY65qJc6mUs2/sxuGPB0iGYeY0xMUSOsmlvn2W8Szoh9BEJJGB3JO/mAqZAPsqLrISb27lTlDgm2qdFxpaXe1x4KjUwmPpvx0eFKdusMNW2zzvUWKIysQlWN4JFdAbPHu7Nq+lG5/FPRTpk9mePCOBgHVIgNo/sP37qhVQtkxas4zU5Dc7dVGk50Lnp9ZJWLjqNxsXnXi9nPkwjryoHUT1Ci6plMGkVu2rzDff9lSgdrlbZVH4MwOBTaVpcz6QKUIMIVERC7/su7q9P2qf16VSIlogt5QIL+HVZF5dbDZBxSxzobhl1Cq2A3iHXnCtBttRy+9zmqngLHGFWMI8d8wwHPYYJbHChAGRVyxTjEBfAneke/DGTfOqRdp1y4bxwOfYBfjlny0K2D+GKcYwWsWep4v4
 8LN5tEDW
 6P7X02gXvkWcCQAZfOaudnMg7OY0Ctv7joix3iwIYk3swcmhp1FiS6y+wL5GKX0FjaPSYgE+Zy5DJzN/r+SqNhjTU4wkJ4aZikbSoWMO253HsO0KnCdUkCFUiw8yYtOttLU7pq/aJC1eeSxKrerVuNxXtDPdMSoXybsVfFnE2/wA6/7Xo6VZJeJRiz5MYbm3l6SkELOkV5mT21XpdQjNsSAM3Vum2KQ4IvSQLRql9e7TVN/tmgZPJFD3/Dqk8MvRtVtGJNvuk94Mwt/Mp3F4YdoXdpxKMMBRBtxPK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Oct 13, 2026 at 05:36:00PM +0800, Zhao Gongyi wrote:
[...]
>
>Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
>Cc: stable@vger.kernel.org
>Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
>---

Good catch! Thanks!

[...]
>diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
>index 0acab179f..851fa2e44 100644
>--- a/arch/arm64/mm/contpte.c
>+++ b/arch/arm64/mm/contpte.c
>@@ -463,6 +463,13 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
> 	if (!mm_is_user(mm))
> 		return __set_ptes(mm, addr, ptep, pte, nr);
> 
>+	/*
>+	 * Keep the producer-side invariant documented in pgtable.h true even
>+	 * if a direct caller passes an invalid descriptor with PTE_CONT set.
>+	 */
>+	if (!pte_valid(pte))
>+		return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);

set_ptes() is the only in-tree caller, and it already clears PTE_CONT
before we get here ... no? Why not fold !pte_valid(pte) into the
!mm_is_user(mm) check below and return __set_ptes() directly?

	if (!mm_is_user(mm) || !pte_valid(pte))
		return __set_ptes(mm, addr, ptep, pte, nr);

If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
rather add a VM_WARN_ON() to catch that. Silently clearing the bit would
hide a caller bug :)

Cheers, Lance

>+
> 	end = addr + (nr << PAGE_SHIFT);
> 	pfn = pte_pfn(pte);
> 	prot = pte_pgprot(pte);
>-- 
>2.39.5 (Apple Git-154)
>

