Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8835F606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V2SAuhWs
Received: by kanga.kvack.org (Postfix)
	id 67DEE6B00EF; Tue, 17 Nov 2026 05:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62DE56B05B1; Tue, 17 Nov 2026 05:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D1E6B05B7; Tue, 17 Nov 2026 05:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 247706B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:16:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75BC91202FB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:16:15 +0000 (UTC)
X-FDA: 85444205910.21.CB4D4A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A4DF0A000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:16:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2SAuhWs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794910573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3F7MsaTa0dMzD3OO4ezzHyvu2AXC5WZNHSTj7ej3LU=;
	b=aK5EIbFdkJMAsfH2TiUzpf1sH0BRXAE5KSgPgwe3cFYwkaZ35+TBkKk6Iy72mHUgccd/aH
	HZXVJP5Uv/Ng03XGuyxM7kl90ZhqPPBDe2BiqSwN+7/45syIy4XWpqp74VLVomZz5OTVT6
	kgB2d0ZCJBNpuvI6PfB007Mpzd/k/iA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794910573;
	b=aYeo2x1SAcjcuqrWMxGvgxKu40mNGS9NTQdf6Vu/Z22/goQneyHl1AXZbbQwPzYD6Prqse
	ZBkreE77h2ttNAmkk+OQhlI3u5RFncUXS6ehvNyrVFG2L4H38QZjxAdl0EOM8krT+fhufr
	1PFo55FcMnHZ5hMnyF9MlomAt/3Ftjo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V2SAuhWs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E322A40185;
	Tue, 17 Nov 2026 10:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D7E1F000C4;
	Tue, 17 Nov 2026 10:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794910572;
	bh=l3F7MsaTa0dMzD3OO4ezzHyvu2AXC5WZNHSTj7ej3LU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V2SAuhWs8jAcWpSSEzf+Io5Tcac0gW/AhhhNyfA6nts77Ei3uaIMdN4gRYHnZMPan
	 ftAY8MITi4XIgLRDI+dRH4G2SzzBi75VqPfmylclgxlvpa2ejhLONEH0zRYOi0yqVp
	 Gv4WheQs+UDBnYPyBaDYTF+xqD9O5Ton+drdPueX48pF2nt8BNhSOQ34VTUAa/4FcR
	 36qcNgKZZvIO6BRiC4i8jLr/AYGdpKFlmrJCf2XRGoBRwF7Pw3RvQNGdvsw+kPwXuG
	 swjG0CMWFRVlePqeMq6yGFM5Utu1nfnHaTIF3YOhCX23kWkEtJ+MbUXKFbl4vw5kri
	 s2mpECBMWW/aQ==
Message-ID: <1ad7a1b3-3bea-4cc6-bad9-c400046a6a88@kernel.org>
Date: Tue, 17 Nov 2026 11:16:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory: mark unshare copies dirty to fix MADV_FREE
 data loss
To: Daniel Wade <danjwade95@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117100622.807-1-danjwade95@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117100622.807-1-danjwade95@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4DF0A000A
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 4uaxyhupeisdimk1j14i846cou5d3175
X-Rspam-User: 
X-HE-Tag: 1794910573-762281
X-HE-Meta: U2FsdGVkX18EQ8I7YnoDFqbo355/ZuMMWRqYSKOiXhUcVrQYd5Y/a4bI4qbtqIVr1hDLakQYzaK3F7EFCQBFbX16Adxs4v+8vELYT4/hPDhqQi/Wmpnkb0fX6djRJtHxPxQFP8aeFsjSUzsLw6eQZk7w3xoi0Bbkolhg1H6mLO610WJwNg5oP1hdxhfINepdhr/TUd095xLobjVrKPdbWsBWGatk+qi0ikW9frwyzh6I48g5U70C0bARbWsVyxoTlW+E8917ZTwW+4zVKEbbzG5BSezenh/CaMLtFXX6FYMvMbB7rPzXn+EhpGd4ASzk1Kgc9C8kiRGu3ytI+9svZrii0IVYs1QyYZAsOmeLTloA3Y/V1ujmeM79WCjbvTNJA+XSHzoYh3OIvtdGKeXRm1cj/1y4FCOn12KxWFpPwJmgxaN7MgSIu2SdB2NJ0mL2aZ+KeYcb377wzUM2Eh2L6zxpwPSyEJVaYzOTj52OEMY1O5Wywttuay8YUPdwmfFJt62dafzNYCMC2SP1iOEyGbglGZW1c07xFTjU5M64KrEAT9pA9LpODGC6M6CwhXJLsns6HoQ9kByIMf+ANqDWIObSEtdl6vaJT+qIjVyfBdQLcumpnHKyiSrb+yeSMC3BbYZYBTak2ArPo4BDudn4KLP302B4DUOUxy3yXvLgmpAodrL1cuGws3rSz77PVXroQmtkmSv6MR+6YZncH9UY60sE73wSe3rLIMNWvi5K1gf12bbnrXxgCzW1G4i6PWQLVRaldvxVwML40/kMS6k7K+PPsqVuvPkzUhUWOB1XfAp7ePnuPPo+ycGglmoRxCvFKMhdBKYUk8jqDQmV/nBr0I7eF6en11F7fADlN4pBJGVbzWaJdOawP1uCC+k3X9g3ZAOa6Z974xbCYBcQYbwX+dnms4qyNCDBA4hwvKjHR0iswVRMGUTnOr8WMuMl8l+2qBC33Kn92U3mfYVIfI6
 a+8Y8IGM
 OsyqYmsU0Bg0vli2b9bzWBAghQ5TZhaFtaLdTIYxpJNaNMsrLl5L25KPqVMCIYJCCsCE6ZWwjzNKn1Nadg19T7JIvQM1lpLtxhFZ0b7ExhgI7rS0BZiCV6W0e24Sigsi5J7+t2S8x28fkUGyZygzRqKa2uBL793NIQrJYEi8e8C+/BEQuog77pDIBoF7kbSoS9IL7a7sITghzJeqBkqMkY71Vv9R8WKiwT56esVepEv/u0bnCv9p6lkQLMpVQsd5DkvbRqqkhLr8u7u76tLujD6CTihB+kZpQingrBDTAiPelwtQ+4LXaAOYoikhD7eHVtMlnkSDL3qTDxbJ14dLDc1qx+mKzzLrOUzxY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 11:06, Daniel Wade wrote:

Please don't send out stuff that fast, especially when the discussion is not
over yet.

> wp_page_copy() only calls pte_mkdirty() for write faults, so the copy it
> makes for FAULT_FLAG_UNSHARE comes out clean. Nothing marks the folio
> dirty either and there is no swap entry.
> 
> Unshare faults come from R/O GUP pins, like process_vm_readv() on a page
> shared with a child. If the process forks after the pin is gone,
> MADV_FREE in one of them marks the folio lazyfree and reclaim frees it.
> The other process then reads zeroes.
> 
> Mark the copy's PTE dirty. pte_mkdirty() also sets soft-dirty on x86, so
> take soft-dirty from the old PTE in both directions.
> 
> Side effect: smaps and numa_maps count an unshare copy as Private_Dirty
> or Shared_Dirty rather than _Clean.

numa_maps still doesn't expose Private_Dirty or Shared_Dirty. So this should
probably be be

Side effect: smaps counts an unshare copy as Private_Dirty
or Shared_Dirty, and numa_maps indicates it as dirty.

> 
> Fixes: c89357e27f20 ("mm: support GUP-triggered unsharing of anonymous pages")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Wade <danjwade95@gmail.com>
> ---
> v2: set the PTE dirty instead of the folio, as David suggested. No atomic,
> and the dirty bit then also survives in the other mappings.
> v1: https://lore.kernel.org/all/20261116111245.28871-1-danjwade95@gmail.com/
> 
> Tested on mainline b3dfbde62cf1, x86-64 with KASAN and PROVE_LOCKING, as
> uid 65534. The test gives an unshare copy to a child, has the parent
> MADV_FREE it and a control page it alone maps, then waits for reclaim.
> Without the patch all 4096 bytes come back wrong in the child; with it the
> child's page is intact and the control page is still discarded. Same on
> v6.12.117.
> 
>  mm/memory.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ec3d9d99ccee..113b305854d5 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4130,8 +4130,11 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
>  		entry = folio_mk_pte(new_folio, vma->vm_page_prot);
>  		entry = pte_sw_mkyoung(entry);
>  		if (unlikely(unshare)) {
> +			entry = pte_mkdirty(entry);
>  			if (pte_soft_dirty(vmf->orig_pte))
>  				entry = pte_mksoft_dirty(entry);
> +			else
> +				entry = pte_clear_soft_dirty(entry);
>  			if (pte_uffd(vmf->orig_pte)) {
>  				entry = pte_mkuffd(entry);
>  				if (userfaultfd_rwp(vma))

Apart from that LGTM

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>


I'll wait for more review before picking this up.

-- 
Cheers,

David

