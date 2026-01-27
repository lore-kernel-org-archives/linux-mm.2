Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3C7D25959
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3356B0088; Tue, 27 Jan 2026 02:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26C76B0089; Tue, 27 Jan 2026 02:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C323F6B008A; Tue, 27 Jan 2026 02:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2FF56B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:23:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65B6E13BED2
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:23:41 +0000 (UTC)
X-FDA: 84376903842.10.756325E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A2A92180007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:23:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G4bBJQeU;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769498619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LS8aWoAwuUZfXKGJJtyYD5Ry6YFS4Hs0JmhcUrHlK/s=;
	b=7Yiv1rzHVmpnIlGojfxBnkrCljY0x6RKoy7fXTMMPHZcX+TRz6RZyTYHK3SH4R0NoTfLfd
	CF9Acs4lnK3lvrQpvGRDgDEMwfEIs/4uBeZWO/8jG/JYdeIW9rdoPUVdjM7c1ItoLZu09O
	itaWvAKOx1poBO9nZV2lAxmaMJUPIec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G4bBJQeU;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769498619; a=rsa-sha256;
	cv=none;
	b=NsWU0CXYUB7bT6x7PE4Gj1JD618uJYDLV1OIyOwMhPyFMgW44i+NnN9rxBGzLZxNy3HVPr
	XFICkGY0DO5NlGGx/WjqXhf0Q+9vTxfVH1L3E/jEKG92Uaai43fCzgMVog+NRvgL2qhA/8
	mZEjBbBt6QL65v+fnBORE8qXslY2xP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 942BF43F89;
	Tue, 27 Jan 2026 07:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0FDC116C6;
	Tue, 27 Jan 2026 07:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769498618;
	bh=wKc6TL0A4RPyPSsNR6BFVNJfOo7cACM6wopJvwkAz0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G4bBJQeU/o9hOCFqmG0i2rEDHAXUQpCc0MJKYS6Y5c/RUILsdmi8lxJVvxAa+Cjl6
	 L0Fkyp58vRmqs9H7LMt7ccQ+bhA0PGlobSQELyJcEpBhrnS9bcNhXDAOOySeHifhwh
	 oDWSNMFxC1W1odL6Lv2avlJWJDfi1sEh9IgV+zqZAH3hKAD3zzoNijv8EfZST1APKh
	 c2cbZvdVdf5wtPe+E+4Sg4BWBhIc1AJn5O9Dhz9u3+/MsiLxHi5Mjd/fPCSoZe7Vip
	 X5DbMcjA5hw0brxwPZ8L7gLZpTpER20rkSCVGNiFynFI/cjdd9wpJkSWViWwE4dk4b
	 6AzxEMzqK1u9w==
Date: Tue, 27 Jan 2026 09:23:30 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com,
	riel@surriel.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v5 1/4] kho: add size parameter to kho_add_subtree()
Message-ID: <aXhn8ieKtj3T3FCc@kernel.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
 <20260126-kho-v5-1-7cd0f69ab204@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126-kho-v5-1-7cd0f69ab204@debian.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2A92180007
X-Stat-Signature: hjeumq8shnr3kp131wkm1tgzkwmnk634
X-Rspam-User: 
X-HE-Tag: 1769498619-34548
X-HE-Meta: U2FsdGVkX18xj4a3fy9ZjAkbkXzThKY4v0Fsf4v5hIbNnZn3dWIlAyovT6mhJ45ybilxOkJjTws8gVGTymI8e3HYUp4xmB3yTVGMqQP824my0Xjpdu3wq7R8KQqlLEEvTs3M5DAisw6vsUSIMSEe584kDZV3FX1nRTYfXmVqzY9RmQ61sivqfqSfsx296HrP7G/E0SWlih1O+YHuvrgIj5COLarm4iOzGzJ1d4X9jJfc0ZdrEJLViiwoA7XibltWvJz6bj5lkBS7JFf+SVOxe9wD+P31FvNIqyT0IrHwADt4jBBYMNd8idyQC14TCO77UgjY0vEDM5UZE7ozyTkk7mnFTzwi3NzQsWceW4rGP/odLUMtoPqSecJj5ANKOYk/bPpB8pTaU1TrkRFQenNt0B0AD1q0KIxmwkrsso4pxyPOGJyY7/z7spVi2fCC9pQD0Wv/FIELtp8dmn/uVANVACyAtJWNq5UhsuUP7BDjEzfc79nlwQlRWoBRpZEEfYc+oX0PVSkxX2oztnqp6peIMOkQCUWlDrqaEtm4zMTp73KHOlGcLS7gXxR8foaDWeFCuG+IY2vsZavwqwQE+q9qSibTHbd2Vkh6//81AQOIicgip62oDCxjtGFXyr771fsD+MEoyv44OKdGoUOmnNmu+hJTo+pVzDndn+pUQnqMivVvl5f1MDUjaaeAWHURMMfTmqrIHd58MRjcgiOCpcb19Z/YiSG0tDbV3LMjtoLdX57IaQVMCPZ0sXsTD05XAMLpTu0rwNuW6rwp3DXtIIaf1gOGEiO7UsXahmNl3RP5RAqgPo834PEHX7epIaDKWqtsii6tk8KdIJqPhZHD7+kcMSeoATMTd059xEXGk4k4zYRqftZYugFx063jlTUBs8rbg4Io4PqfW0GOaODBPG52Z/RrGC6Yibt26CHnOWU4qwkU0JQ78OAQDf5MSlflGdha+j5LoIVA7Uyo/3orvCv
 oh3r72Hw
 uBe0kQXHY27sXTX0dLK+oIhDaq4+E9ZN+FwQqCdqNzS37XovOFHJP3yXCLlR5MepSKaird/YHj1SH1wkH0SZelb4JG4vsB7DAw9Jr3/mlwQKSwHF8AOaB2K+mIA+tl5xgXAM0UfVXDnUMIC5F0XEFzAUcuP5evH1lrfeT3J018hHGRsZsaxlotEE5+shwkvoQG7z6L7vofYL4I8/pRmVNbskPxRZQGLEc1JdrMTtxn9CJWZ0GAFyWbeAMq/OY7RSqmygYgNDO4/s8qkpad64v8yWSpI+Ml70tDtjqdxqH0wqukF1lA+2aGTLtoeHQCVteYOGP+plLQEGNWs0Y5NQwfrM8XVWgf9vvZ00a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 08:07:23AM -0800, Breno Leitao wrote:
> kho_add_subtree() assumes the fdt argument is always an FDT and calls
> fdt_totalsize() on it in the debugfs code path. This assumption will
> break if a caller passes arbitrary data instead of an FDT.
> 
> When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
> calls __kho_debugfs_fdt_add(), which executes:
> 
>     f->wrapper.size = fdt_totalsize(fdt);
> 
> Fix this by adding an explicit size parameter to kho_add_subtree() so
> callers specify the blob size. This allows subtrees to contain
> arbitrary data formats, not just FDTs. Update all callers:
> 
>   - memblock.c: use fdt_totalsize(fdt)
>   - luo_core.c: use fdt_totalsize(fdt_out)
>   - test_kho.c: use fdt_totalsize()
>   - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)
> 
> Also update kho_in_debugfs_init() to compute sizes using fdt_totalsize()
> for the root and sub-FDTs it processes, since these are known to be
> actual FDT blobs.
> 
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/kexec_handover.h              |  4 ++--
>  kernel/liveupdate/kexec_handover.c          |  8 +++++---
>  kernel/liveupdate/kexec_handover_debugfs.c  | 15 +++++++++------
>  kernel/liveupdate/kexec_handover_internal.h |  5 +++--
>  kernel/liveupdate/luo_core.c                |  3 ++-
>  lib/test_kho.c                              |  3 ++-
>  mm/memblock.c                               |  2 +-
>  7 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index ac4129d1d7416..abb1d324f42d0 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -32,7 +32,7 @@ void kho_restore_free(void *mem);
>  struct folio *kho_restore_folio(phys_addr_t phys);
>  struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
>  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
> -int kho_add_subtree(const char *name, void *fdt);
> +int kho_add_subtree(const char *name, void *fdt, size_t size);

I'd rename 'void *fdt' to 'void *blob' to make it clearer that subtree isn't
necessary an FDT.
And s/fdt/blob/ in debugfs function names.
All this could be a separate cleanup.


-- 
Sincerely yours,
Mike.

