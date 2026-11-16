Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6584606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=pyS4iHQs
Received: by kanga.kvack.org (Postfix)
	id BAC866B05B5; Mon, 16 Nov 2026 13:19:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84876B05B6; Mon, 16 Nov 2026 13:19:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2676B05B7; Mon, 16 Nov 2026 13:19:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 892286B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:19:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08723C0200
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:19:54 +0000 (UTC)
X-FDA: 85441795908.17.6301A9B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D3F31C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:19:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pyS4iHQs;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853192;
	b=wjvPzRavo2nzNzUtB4CJyGuAx+/v/broNrfgL+5flvvuENV1x882+j7qT6RWB5rewEpSvr
	HlMhQlp3/EODiBqJ0gzko6O72ydRnviMKDwg5Ukgc3yZw0v68h+GQ2p7YnKclIgq2lv7b6
	cz9PadEkfn1kBWR74lUs8wRrI2wWgiE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pyS4iHQs;
	spf=pass (imf18.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3OaimYL9k1G6LS1mBgzQVa/tv/0aRmfS2iYV6WufZ8=;
	b=XS46DplEUUZD9xnAmKI+9AEY9AwS3J/562s+eQTactJE7pCrlDw/JtRcEz91YG8FCq7KAR
	cTH/52Z8zecyuWUvs0v4PfpFMyE3mnlkJMxSR9NO6JH7kLoOplPhmMa6/d4Ze34SGG7yFf
	x27pVL9ZJgJllbkp6ECy2GX4mK3/G4A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N3OaimYL9k1G6LS1mBgzQVa/tv/0aRmfS2iYV6WufZ8=; b=pyS4iHQsYBlpVL5Wiy/LAPlUuW
	hUlhWSGDvmWqMSdcn5Uw4R8M3wvOiUHGK5ZRc+lAGLDSFYg8bjwMb9RlQut8zHL12ugEI7ZbB+cAh
	D6sndl7Il9aP3iPHhK6zUBvCvPB1avmPrSaIo+AC6U+l+rTlLb9S7DVRWus9DUyHEgsCdfcPOozdm
	7HHytR7E0MRyvJKwNhLdSC4pl+wrvBRiBCJzcMaA8n6DlLfwsDBQnkBLlWyiK33/3Rdj13yH/do0y
	K4d3IXahESUj4S4xLv/vF1ZRr0eS8q/xUQO/svTw0ilbGw3XZ39taI9VIgRZ9DKs6WwRNqm3aFwZ2
	litlaUHA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xT1J0-00000003Vzm-35rs;
	Mon, 16 Nov 2026 18:19:50 +0000
Date: Mon, 16 Nov 2026 13:19:49 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Dmitry Safonov <0x7f454c46@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: correctly uncharge accountable VMAs in error
 path
Message-ID: <yki3kpqx4bhek4zit2txtt7z2crfropbamcvnciornj5dp4eu2@45qlnjuowq5d>
References: <20261019-other-mremap-charge-leak-v1-1-d94477fe6545@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-other-mremap-charge-leak-v1-1-d94477fe6545@kernel.org>
X-Stat-Signature: otszq886ehgazkot7e5yc9ry3eqrw1aw
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D3F31C0004
X-Rspam-User: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794853191-785702
X-HE-Meta: U2FsdGVkX19R6eND6Sds4g89sWHSqZwuvBpeAXM8v2LDd3ZRll+cWDyS8+BuLuagGIVVmImx9yApWcxlxUqZm15o6YwHoNNDTAMlIpcUnr6MO+9x5Ru+tFLK6z95g8jK6h3WGQducWsmXffjzwbOrNOeszkzP1VLSJnc6qUaK7R1OJThldUnq2K1JdcJELZ37G28ltjw8o/6OQ/KdaV4kL+NMBv4DzfUXq/lQFcDU6rcV2wBT/U30Y9zRw2D5BhutcDAHqNirV8v3R3TVm+cPeePPEvuGRx0Qni5T7S/RkblGbQWdOqBJ5uuUVGaDCBPJtqgP+6mmhWtd2A2nd9HYHDH5AeeCO8HOjSMHvStLq4trow+yMttIaeThKWA9e0IE1BSVJG7Hzl6sKG/xLig8s9bZA23eoOKhJRuLK2OZf7ns463APe0QuGh2SGc55Fs7nGHVAYQAIyvTDsCl0LhWS9c/C8fgKBTnSPr9b87HZD1UUgdh9z0z9xDnrz+eNU5VfZy7wZwcdfOVck/yQypglPoTIvvXHwF05z4HLWCniGZXj/HGEJvT2odHSB+M6h66YI4uL4gnzox+zqUI7Vo0MbyEyR2JXWm4rta3GJoiUv7D7VwHBVN6ZbNjyaCG2Khtop9fMZ+8sAHhSaL1h185svBjIUcfIMYQ8Ozb52CBcvpqlhNeyFC9g2Ye/uflXdtBaURC3VIQMpC7cllm557xE9PtI0RD44OclzPrCvkepVqtr4fsqJKNB+VmNT9RhcK3yxui2vhOanIRIZpTrCEPigaWj1yegoU5GujUh63Fv6fIjOeBhHTB2jnKMoPoCS8l3e2GLb5NxJv3SopgWAkzSuHkf1Z9kDSG9AhMqdrdYIw/P4yP2brr5JFdAHfzu9RwLcl6tlpu6ApVwzQrVbpcwbT07FF0+mfQprWMZsNx/1jLvgauZT8pUgKwPMJkhSX6hhfKdybrCnPBdt8EY7
 9x9DB0QP
 cBBT5V1I8qeNRcOUrsG8/dfvSS8sBm7aCQqe8SQnhz46ziWuPdPLhKm/2kM9k7HXeqHVvjuoHVreS455/ht2kXx8bc4rNG+QX12+aLNoQXcwHUA+N9oSyJtcfNT+AqSBs7DH/Rzwf7W8s7xkp0hGilDL+JiMEDh6L+loU3fAkiEQJGz65MMnwi7xnAkQ5bKnEfqjF56VmV4mZK6qIvAh254CWWCqM7+a0BvCP6O4SUuh/uMrspor4aD4Lv66uZT36ucGQFyu9ygOHTZvbAsSnBuJifNb33GJ7OjV2kzReBUtSR3V1kvioT49wB+0sz+593tzYYBTZIAiwknZcbZldti8BS+RqeLkkWzzlfDbofr8nl3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/10/19 04:57PM, Lorenzo Stoakes (ARM) wrote:
> The mremap error path is a fragile and unwieldy beast - it reverses the
> page table move then updates vma_remap_struct state to swap VMA, length and
> address between old and new VMAs in copy_vma_and_data().
> 
> If the mremap() operation didn't specify MREMAP_DONTUNMAP then its caller,
> move_vma(), invokes unmap_source_vma(), which unmaps the new VMA rather
> than the old one.
> 
> For accountable VMAs when MREMAP_DONTUNMAP is not specified,
> unmap_source_vma() unsets VMA_ACCOUNT_BIT during this unmap in order that
> only the delta of a VMA expansion is charged (performed by
> vrm_calc_charge() earlier).
> 
> Therefore nothing uncharges the expanded VMA size, and there is a permanent
> leak in global Committed_AS.
> 
> Resolve the issue by uncharging when MREMAP_DONTUNMAP is not specified.
> 
> Fixes: fdbef6149135 ("mm/mremap: don't account pages in vma_to_resize()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
> Issue was found when I had local AI check the other mremap() fix from today - it
> raised that this pre-existing issue was present.
> ---
>  mm/mremap.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 6970783fc445..1620006028c4 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1338,6 +1338,20 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
>  		pmc_revert.need_rmap_locks = true;
>  		move_page_tables(&pmc_revert);
>  
> +		/*
> +		 * When copy_vma_and_data() returns, the new VMA will be
> +		 * unmapped rather than the old one.
> +		 *
> +		 * When an accountable move is being performed, this unmapping
> +		 * will not uncharge any expansion, so do that now.
> +		 *
> +		 * A move is accountable if the VMA is accountable and
> +		 * MREMAP_DONTUNMAP is not specified, so only do so if the
> +		 * latter is true.
> +		 */
> +		if (!(vrm->flags & MREMAP_DONTUNMAP))
> +			vrm_uncharge(vrm);
> +
>  		vrm->vma = new_vma;
>  		vrm->old_len = vrm->new_len;
>  		vrm->addr = vrm->new_addr;
> 
> ---
> base-commit: 4dbe24720eb3811563cd56b35d87ddf3f9beed2a
> change-id: 20261019-other-mremap-charge-leak-b426336c0299
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

