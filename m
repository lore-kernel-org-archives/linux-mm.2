Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B23606A898
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P0Is9jPV
Received: by kanga.kvack.org (Postfix)
	id B52A76B05B5; Sat, 14 Nov 2026 10:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B03D06B05B6; Sat, 14 Nov 2026 10:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2526B05B7; Sat, 14 Nov 2026 10:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1CA6B05B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:06:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0082A0422
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:06:27 +0000 (UTC)
X-FDA: 85434050814.26.5B19860
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0EC9C20005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:06:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0Is9jPV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794668786;
	b=J7HXZUFSdx1XXV7iDngQyWkDIq7rWNB7HXGJFyO/89LYxtc16NCpxjub59Kvz8J2e0ngpW
	eawZg1uWxP8NjS+XHHpYOkOTs2Z5XI2YtDPde9/gvvAgNITZ9N46ylBAe0tb02Aoh+FS6W
	UQi/0UV1b7afFaQawHWNbX5/3ILxT4U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794668786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPlumqmMy/TS1Z79coN07+eLGMuUh+Q2c2xpM92oPK0=;
	b=dxhoY10Oa80gBMz3kql+Qc74zDdzN12YbabIg2ANnb8XcSoOmPmanHLdcOjcXSlVD6mTNx
	y7KkhGTSU0bjUqya14AVIbYjRKs+daER4G4mg5rkFG0eFo6p9tGIkPQ6Ea7aVWnwX/EaST
	mAhEa2PvsVnZ0oymWtQanQlYT6/0tc8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P0Is9jPV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8700C623AF;
	Sat, 14 Nov 2026 15:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6AD1F000C4;
	Sat, 14 Nov 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794668785;
	bh=gPlumqmMy/TS1Z79coN07+eLGMuUh+Q2c2xpM92oPK0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P0Is9jPV8V7EDDghiT7VHrcFj3kSnB2meK+9wfamwMFQSt9LC1mUTxr5pIy4aCWjl
	 pUfToTL5MPmVsnD3O+F7PPlzn8jMCoGMZJIumApN1DSrXX/QfvlXXAcKCOTGhphiCJ
	 gz7m5t5dJPvSdi0pAeGOuCZ+CEr6MssBiKI7mJZtn6ke7VIQFVo1496Mzl80WprPrx
	 up4FYVNdJpTDA7k9o96nSoiAwrF4+sI2jAC5aUq4n4s8NjKJXcQhbitYc3umOlG/9Q
	 Gp/DgP2lI2Q5BuTlnfBssN8YNcekQlJ3iZ++tGmeU5bUmVUmGC4FzSv06zKhN24mUc
	 lBOGKo6oysySA==
Message-ID: <7c6e733e-a464-404d-8b69-607eaede0c5c@kernel.org>
Date: Sat, 14 Nov 2026 16:06:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pagewalk: document missing struct members
To: =?UTF-8?Q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0EC9C20005
X-Rspamd-Server: rspam12
X-Stat-Signature: f761qzyn9axjgoazfkn46iry3fhxkdxb
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794668785-98561
X-HE-Meta: U2FsdGVkX18hMsAKwZZpBJk1w8AfAsNHzEGdJhJca/o/GDLyfvKZHEkdB6ZyjqyaGUiH0ZDJYgO8qGip067DOKBq3YN+PpD+9Ptk9cPY/fu9DxwUYR28vIKbL6RP7l12HquZ2jknF9O+7/lCntEIINwYQGXrc4SiYzqRfYoR8YdsvidkrOLEBf/kuNcMO1P9HJIer1p5vTtqVFj8tpLg+aqgGsSHtXuglGP2ncugCDwvBpyi+YP9l8/q54HD37bNf+wZ5eUm0pRQ020yfVvECzLmAZbonxDYm75WLGUWFxizA1pMHrfHyiE61x3rgEOX3Z9NaI0w7BLObbv/MbcvzFDB+FykFHqf8WWE1zgc7jAi9W0JabbOXqJOmF9XxWwNq3aUtGoiTw4G9uacvcnor05vuYGl+8JxM6L6fJpj96sdiXeQXNWdbdsXE3e6+sk07K/rXU/Lcw1a0An/R6d1gvVLv29NsjFcKrl1VpEDfkJPWeCAph9V7fMrKhTO4O6erglAu0VcLQocYcgQC6oB4bOzgPNjrAwbtPLel0htp33AsJ5wSVDNDI3LNe8GYohvH75UszS/UwMlbGHBg4DmBRfTMPXeourR3E5ue1JXylZpGDWuvkw6922DoB7QaikK525BWGWeqBaM1/B8w2/ZfsYw//xhJwZsGaFCi4SpZ5YUcjtJFgQvJPhIA5cAEDa4aZJumgqpVKdCqjfx5UEqr99Ze+zojwh9tjlXzacC/UKIO4Cai4RWlprTR/kupvBvi3G2ANUiH8VnEMAecq27HoJN3CQ5n5uQRH5QaqeiQrPEw8jQ0ZzkBPQpiEaAHE/Jr9vn4mVIQcTCfFozaqHqWcKdi3jRLBb2d2oe4WiRza3z6jzw5ygnDRr0DYV2HtoHNG7A8FRFtlgZArdHu9ww1yqgIQrupS22xKwdpQ/8VV2s6W6rrtvrjyzME4CsL0nPGGfizWFhTeeOPWl9sbL
 9Tf4tblY
 cu2Wics4lxWLkB2ekg/BLTAdBOCTyGHugDhO+/OuyXUvVocluQMjJ841xMsstAJfw61Up1Ug0RtGkVO9XTH8pqKsldPk9qmaYdzL/uckoDNIov37d3LjX1L7oSCXvS1tSu6rjPTp8owg+9lBg4jirYQaIkXq8OLnCFGHR38eX66v7lOurDOWQC3eBuOQYGEhn29RxMFzc9nKwIFTiHYXv9MK7ARyMtD64DS8jlLyJARr/yYSCYiQc4AWCJnvjFIOprRNi1ePp+8r8mI39diH70Hw4Zp+GbQcfk1OqMelwPVLopGwvIItCzoCQhdp+Xnhw+fa3tCgfVMMhCOjeaCwoRf/jAouoZUzU/fA8x7AHvYk6dmA8pWu+ZkFQCVje77+1mhDbwcmPnL66/xKsU+DefUainzqP/vVwv3uVLccb+vc8B/pw83tsUKfyoaCV1mSxCssqJYBO+61W0mEICP+Lw78j2JwaIPUapgP1NhOkBsIoDn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 01:44, Oscar Alejandro Sánchez Lucero wrote:
> Add missing kernel-doc entries for @walk_lock in struct mm_walk_ops, and
> for @ptep, @pudp, @pmdp, and @vma in struct folio_walk. Also fix @pte,
> @pud, and @pmd descriptions to state they hold entry values, not pointers.
> 
> Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>
> ---
>  include/linux/pagewalk.h | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index b41d7265c01b..978714d5e32f 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -63,6 +63,8 @@ enum page_walk_lock {
>   *                      install. If allocations fail, the walk is aborted. This
>   *                      operation is only available for userland memory. Not
>   *                      usable for hugetlb ranges.
> + * @walk_lock:          locking requirement during the page walk (see
> + *                      enum page_walk_lock).
>   *
>   * p?d_entry callbacks are called even if those levels are folded on a
>   * particular architecture/configuration.
> @@ -161,10 +163,14 @@ enum folio_walk_level {
>   * struct folio_walk - folio_walk_start() / folio_walk_end() data
>   * @page:	exact folio page referenced (if applicable)
>   * @level:	page table level identifying the entry type
> - * @pte:	pointer to the page table entry (FW_LEVEL_PTE).
> - * @pmd:	pointer to the page table entry (FW_LEVEL_PMD).
> - * @pud:	pointer to the page table entry (FW_LEVEL_PUD).
> - * @ptl:	pointer to the page table lock.
> + * @ptep:	pointer to the page table entry (FW_LEVEL_PTE).
> + * @pudp:	pointer to the page table entry (FW_LEVEL_PUD).
> + * @pmdp:	pointer to the page table entry (FW_LEVEL_PMD).
> + * @pte:	page table entry value (FW_LEVEL_PTE).
> + * @pud:	page table entry value (FW_LEVEL_PUD).
> + * @pmd:	page table entry value (FW_LEVEL_PMD).
> + * @vma:	pointer to the VMA (for internal use only).
> + * @ptl:	pointer to the page table lock (for internal use only).

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

