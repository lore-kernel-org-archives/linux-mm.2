Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 012E2606A326
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LX0RjJQJ
Received: by kanga.kvack.org (Postfix)
	id 230CC6B05B4; Sat, 31 Oct 2026 06:55:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209266B05B5; Sat, 31 Oct 2026 06:55:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F536B05B6; Sat, 31 Oct 2026 06:55:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E63516B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:55:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 763F11A06C6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:55:39 +0000 (UTC)
X-FDA: 85382615598.27.3421833
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D8F0D40006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:55:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LX0RjJQJ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793444137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7b46y4s0/zi9X4zHo11yWW6Vbp88X1A148hn2dA9HOA=;
	b=6Fsm4uysdCpRsSag2GgbhdgG/Od6rTTd9H515j576VQgv4aenCPaTSlmIvAM/vI5jVDWEi
	r3RZkUSNE953LLY3RBmJ57bz4QL+19avKDYRblKMPmOIt8WdOUDIKtLSQ07irZV5AH/Ns0
	R8AJ6rl0n5Zx4Os0Db7XjmHewpKgE2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793444137;
	b=6VL6gjEs+HxpMZhoTf3UBIe7xQhXwSqWh2tRA8EgINsuU6eZx1DCTdIiqZx4z0bj5Jlxt2
	N5hVBfh5jQ5dfntR9o1cbc0dcJPIJEvdqhZdg2ZSiYihYnDcH9POibqToVY8FfIhd9pZ21
	FqbqZV5CcthQEHZlWaOx3l/r0Lc/EmU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LX0RjJQJ;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 766CB600C8;
	Sat, 31 Oct 2026 10:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210BC1F00919;
	Sat, 31 Oct 2026 10:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793444137;
	bh=7b46y4s0/zi9X4zHo11yWW6Vbp88X1A148hn2dA9HOA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LX0RjJQJpWdppLt42SNRn7EQV2Ff5N7jMe3itfLCjplO/MRkUZIp3jFNWvcrwA1mQ
	 UcCj6Mk2yZ8lLHHTQDlrfQDnCXDNASSI3GyG08p720TBjS7E7BDx/hdhXgrHg1QsO3
	 LbeRvsMZBc5KtLwSi7wWODzYoqe6aeCx8rzl2jQQSBqaCz+nLmFTtRvNi8zQ4mcSLK
	 IWFp1W844QfHer5jTZdGQvH25z2biHGD6EeJx++6y7oK/Hf2tF4RjSoEn4R3z8Xtnk
	 8m+5hfjRvvOela8b76hyVYCr8+w5vrvKSzquGangM6VzaPOpzRyecLva2TLMDrvoyV
	 b8B8LK0WZHFHg==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, David Hildenbrand <david@kernel.org>, 
 Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Pavithra <pavrampu@linux.ibm.com>
In-Reply-To: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
References: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com>
Subject: Re: [PATCHv2] mm/huge_memory: set the mmu_gather page size in
 zap_huge_pud()
Message-Id: <179344413383.15514.17004105179365165951.b4-ty@b4>
Date: Sat, 31 Oct 2026 11:55:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D8F0D40006
X-Stat-Signature: kc5ic98r7yeimwmjbeai5wbc7u8jdun3
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793444137-679386
X-HE-Meta: U2FsdGVkX19ApC4a9T6ACa3m07yeC9BHgv4wqI7yDKofJw8IWRN2+PeJqvW3vruSXZ3lcuFCiFXYC40JscQlWt8RW/v8i7eJ89QpuDtfBj5KVtT8R0kPJQ+nqXxkJpOcxVLIvLMlf1xuVXCgb7FA0lRDGHG98nuOmXDEXZ4OW+EOuDzZd6B/fmeX0zzSewsm3bqDnp70xUSi2F81GWxIpTfgKQIBtrOISw1iQKa0/cN4cTRjobmShrRaVkWLI+Uy3Mnn3GIm3A6WVYv1QuPbJcPz3g/CSr6zZ34xtfNJK/4PsLUf/Zf2fjLtzqPn+sVoBb43GRs9qQAsFi2ZbJDFUKMMtI/DnCV9TCRfsdehG6ZNos9N9wF4WeAFdnRFtMuy7ukfEf+8sx6MtMUSzJ+fHIjqxqnIIH5q9uyXzlqXl3hYlUrEzrSBo6uE0UzSh6fmSpkGNO3Eb3luMnKZHDkTyL4v5a8ANrM5m8LewxuCldPgoEJ9h/UWhctZUGXs7+4y0t5zn1E7wPOgMDIfgpCtcbnl2Mtv8D4snM2qAcEo2aTn6Zu3d3cUW9YFUrv3Pqgi3h1krv7o362u7Hb57udISAJy10wWZVz6pLkr3Hol9OwvybmR6bxauPVPuSobygvTrGhTkSJH4cl3wVeoLBh9TnhVg0l9sp/4phvfSO/BnlEVH2LRjNBuzg2sRuV+gjpRDEk7+7Kt2Y5B6A4vdYSGwahii3fW9T82cVXXM+dJpp8nht2rm5kkIzV9m3v70hqDRLliHQrpQuYG9Dt271L7yIkcPUJv7ZU+uBGcpTXW0HzJaGL7pLPU20g5NZpYu5Ybc5H44NaxAzihOKHtYrSX8ISEHeOFUGz0jhUqqKiom3hVIP6KJ7gJEF2FUOafL9WFzLoD+WX4/Avd/JJAEOIQBfmZNmBfaoo5G18fYb6W+oLQQN+2J7mfvyO8BOMCNVcu7oWiRvDjgB8wF89p+BP
 W8wf9hCO
 xgK/EjAZoVTBpIHrC9Dk4HS7p4o5A064ToPFPWLI2OfzDUSOPDxvzyuIO+8+a+0g+iu3SaXajpz/CfarpNvukjJ0kokD4Q2PdR2uiTX/N/fpSPtlrsnJ9Fixi7kn/l8QKuuzXUdk4zR7ZkCJ5IVgAuS7TpUoOihX/QY979fPQdlbULVQlQE7NCwbWReufASG6ci9tYMc462JiEAk7DtaQiVMjmnINP2H8yymHDd3ucZq6MaMe+eUMCeEl9ajFe9U6GAI/v1m1koSSyifea85ttd3Xq0H0GxbaaWFhMbi3behuVO/FvjB8zDaxml9yRBZC1lvr9gbBW485jfsyzRkM6ZWKy7UZt8x7G/9XxeKprixYVtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 05:37:36 +0530, Ritesh Harjani (IBM) wrote:
> Unmapping a device-dax mapping with 1G alignment on powerpc radix kernel
> built with CONFIG_DEBUG_VM triggers this warning on every munmap:
> 
>     WARNING: mm/mmu_gather.c:176 at __tlb_remove_folio_pages_size+0x38/0x230
>     NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
>     LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
>     Call Trace:
>      zap_huge_pud+0x170/0x2d0 (unreliable)
>      __zap_vma_range+0x1604/0x1e20
>      unmap_vmas+0xa0/0x1f0
>      unmap_region+0xb0/0x130
>      vms_complete_munmap_vmas+0x120/0x310
>      do_vmi_align_munmap+0x1ec/0x240
>      __vm_munmap+0x148/0x220
>      sys_munmap+0x28/0x40
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
      https://git.kernel.org/mm/core/c/0ba86a16

-- 
Cheers,

David


