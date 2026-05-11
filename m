Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB58ACD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190FF6B0088; Mon, 11 May 2026 04:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1426D6B008A; Mon, 11 May 2026 04:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030DA6B008C; Mon, 11 May 2026 04:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E712A6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:16:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1B671C14B9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:16:56 +0000 (UTC)
X-FDA: 84754433232.06.438C6DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA72A80003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:16:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AWKQsPTO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFKVCpdfANeaSu6kSHBhYD+UPh2yOp4x/kxP4frtsbM=;
	b=zlkPGqukSwINbWoEYzZlS4dyTw7hx6U7dx136fARdcuw/nXGDDXGVCLYij9G+KL6Ediidk
	KgpD0M8h+U8x4GkDUoglMPU4XR6jsDa7aLK9iybQ33J7pewAR/37ezoOZCrcsBPwrhNwEM
	SwAVSaqb8XUoJFI02jUVAp54Z1pjsFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487414; a=rsa-sha256;
	cv=none;
	b=dHzuMl257kmXzLMCpIrcwaxKB2cnVbc2zHtiTl0EFd8y+NOZVIfN2OP6QwRmiD0PKRA2id
	UzO6PTIwvUEKxXt9jYZiJg76dRh4gcBnpgGyH1olEdAuPV3LaqD4Tw3AtAyTsnKmd/mq9Z
	q8bAmygxXOkWGFfO8/QHCfVoOmQvbfA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AWKQsPTO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BAA2600C3;
	Mon, 11 May 2026 08:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D822EC2BCB0;
	Mon, 11 May 2026 08:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487414;
	bh=SxUqt7uD6fVUEKRkwZWsVK4iqdIk9wMXj1vmjYOzTzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AWKQsPTOihmweFbrBtoncGSoxFz5BuWlzbjR45E5E0xALIuZ5h616sSVfgxni+dIj
	 AvEGM4+HqWHVaHnLpB19BWuQEnHbPS6GB/w7/n/Rbb9/64axEZogoT2ncT5ne9/he5
	 InzFQd/qI+H8KvHs4nvWjYcBqLqPHmmBCjxog5h5e46mi2oCogFKZAv4lw6gironIN
	 +rv81VuSIzd8PE0BLdDTvWORMPPvFsNmtgYl0Jn324hgSBUHQVJVcyco7rvgwCRTtm
	 v+bCOKoGrd2VrarlVB3IBs6Lwrii+S3RVHFtHNO1JtVOzeOhF3971EkuG9etvL909V
	 N7ndQGvfEfPWQ==
Message-ID: <a8aeeec5-5913-4b1c-80d0-ff49928d34d7@kernel.org>
Date: Mon, 11 May 2026 10:16:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] mm/rmap: enable batch unmapping of anonymous
 folios
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-10-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260506094504.2588857-10-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA72A80003
X-Stat-Signature: qorig3drpyuonxr76qwqnbrwa89x78qa
X-Rspam-User: 
X-HE-Tag: 1778487414-544858
X-HE-Meta: U2FsdGVkX19Q1H2AHJr2EhfhetjxL0GyX+LLkKnGhtHcLnglkLd/iZtDLqaCR+MrbxIRAIB49TEG/Rn1gqajnKBYrr1ii/n9Jv9fgAENW+qBiIciolw4R1ex9VoTxHuVIHywmBM1d7OXXpS2WGTH1FpkRG3w7QxHhwU3B/+fAuFpKScJneB+TGu+/p24srl2m7AwLZAMBH3KC7y4ixq63PeKRHafmVNwPYgA7fEs9Ai1sbiq+mhL2yAEL0XmEpGBMkm5yk//3z2e6mP+NWq/pcvHvTl+5o/ObJy5hkKJC2CVsdqqv3BnDPmPlAqqGwmnt0CpxkumGFRaUU+XUUs2eXQLGkHJC9iDs4XmVtYtPjl0jJvIRv2TRLBJFq1Uh13j1NatJeu55nMBhPwdFbZHBENYrk5Gzx4jrzyKEKgL7h0BLRzJUEEshQcZJxvWw3RZug1Zxl1NDaIfhxgNtD+fuMRgSBgZ13+AoJLEAxoZCdSCOjxB+pw7s0N/rhPSq1GDc9kvhVTuLsozwGjjgJCqg68NKckHUH2JC4Ljk4a5jKWLvYbCqM8TgJ361FgOUER0w4K5/mPUpFPj5Ks7lWAKkXx9s/r2rxEtVbHW4+c3zyG67dbS0IW7zTaAmxdNjBhYu2zoMX0ZD58K/votz9xYvrm06hc502+/MVd+uwP3lNMyYXKqPbHvG5TTdwDIGMqpkY09e8SdOGayGWRWtKGtp5cfm5vk4RVYWbopmC84qywI8Q6aK8C02DSd/Y+xaGo9bVyYXZYSOQsqmnYs+vcPqxkc+10HIx2o3qdR1TrTxZlfVRkADBnT6P0liFVerFYOp7VWdcU47SSfmRkcwjk1iv+s4iFmn3pWW8/2fGJ7lyjawuwUdKcL9pi9GuclYeyPiSkkS04SLeuAp3WjUXWBK/K+DXu1K7dPLLadbaFsLunMYII6ds/Akx/yfX/ZI7Ld1LrD9UdJzBEhXmWWlr4
 0agD5RJk
 ocV3nw797qA9+ATwSZGR5yutCWj1aymjEmzdRQprp/+soH6APNhP845q2P//NZ7PenIi0F5ukqtP2yAMMq7fTVfMlduRd/0yI4u52bkDzTCwJjJhYcQMPpaTSWUa36WD/ViC3Nla/SqIrPvZTk5rvYlFguyWHRBiKinDaHPCpsicLNpmeJ7Cp971nI/kg4ieaUH0EUtp9MElHEGl4sgJVIvEdU9gMVhpyQSjytDAcwXzyTAWEpqOiz4MAL1HYINXavNcH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/6/26 11:45, Dev Jain wrote:
> Enable batch clearing of ptes, and batch swap setting of ptes for anon
> folio unmapping.
> 
> Processing all ptes of a large folio in one go helps us batch across
> atomics (add_mm_counter etc), barriers (in the function
> __folio_try_share_anon_rmap), repeated calls to page_vma_mapped_walk(),
> to name a few. In general, batching helps us to execute similar code
> together, making the execution of the program more memory and
> CPU friendly.
> 
> On arm64-contpte, batching also helps us avoid redundant ptep_get() calls
> and TLB flushes while breaking the contpte mapping.
> 
> The handling of anon-exclusivity is very similar to commit cac1db8c3aad
> ("mm: optimize mprotect() by PTE batching"). Since folio_unmap_pte_batch()
> won't look at the bits of the underlying page, we need to process
> sub-batches of ptes pointing to pages which are same w.r.t exclusivity,
> and batch set only those ptes to swap ptes in one go. Hence export
> page_anon_exclusive_sub_batch() to internal.h and reuse it.
> 
> arch_unmap_one() is only defined for sparc64; I am not comfortable
> regarding the nuances between retrieving the pfn from pte_pfn() or from
> (paddr = pte_val(oldpte) & _PAGE_PADDR_4V).
> 
> (And, pte_next_pfn() can't even be called from arch_unmap_one() because
> that file does not include pgtable.h) So just disable the
> "sparc64-anon-swapbacked" case for now.
> 
> We need to take care of rmap accounting (folio_remove_rmap_ptes) and
> reference accounting (folio_put_refs) when anon folio unmap succeeds.
> In case we partially batch the large folio and fail, we need to correctly
> do the accounting for pages which were successfully unmapped. So, put
> this accounting code in __unmap_anon_folio() itself, instead of doing
> some horrible goto jumping at the callsite of unmap_anon_folio().
> 
> Add a comment at relevant places to say that we are on a device-exclusive
> entry and not a present entry.
> 
> If the batch length is less than the number of pages in the folio, then
> we must skip over this batch.
> 
> The page_vma_mapped_walk API ensures this - check_pte() will return true
> only if any of [pvmw->pfn, pvmw->pfn + nr_pages) is mapped by the pte.
> There is no pfn underlying a swap pte, so check_pte returns false and we
> keep skipping until we hit a present pte, which is where we want to start
> unmapping from next.
> 

This patch is doing too much. Please separate the cleanups (e.g., moving stuff
into helpers -- that likely should have a ttu_ prefix) from the real deal.


-- 
Cheers,

David

