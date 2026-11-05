Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368CA606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=guQbtF2j
Received: by kanga.kvack.org (Postfix)
	id 6062A6B05B1; Thu,  5 Nov 2026 03:00:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7486B05B2; Thu,  5 Nov 2026 03:00:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4926B05B3; Thu,  5 Nov 2026 03:00:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 322476B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:00:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF9F9A097E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:00:00 +0000 (UTC)
X-FDA: 85400316960.10.1305DB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2AFE740003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:59:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guQbtF2j;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793865599;
	b=ixPk/75Cuxac7NnujAYo/1sGoNW0m5sKkGCZu0VGy1L1FUgXwp2jVZ2GH6II5WLMUhHjCi
	bkKKRo7erbGOQi62l3rw5x6OGV8WGEkLl5v9gS7WE3tvrisL9mOl386VJJVnmog5k7hiTQ
	zUyRfS/wN2hmzxigPyYlp4TcjWgeQuE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guQbtF2j;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793865599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3t/AZZXgpUUBPoN/8EcWLM6aSitZao8sMvkUu7sQcw=;
	b=aVxW0Q63hWwItqt6rmIh26CTRildI4i2YJVrXYhBVYxXuM3UT/ZaK7px68psjc9hB+QTat
	gu4N1TFLbSP3nwW0E7gSAOZWop9xxEfdRd5TRLbgcO/u9R8SKWusMInq3tlH+pVFOoLGPL
	I5pPlBguGDd5cFy/VgxkWls9pr4Vn6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BB6C43B86;
	Thu,  5 Nov 2026 07:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425191F0093A;
	Thu,  5 Nov 2026 07:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793865598;
	bh=b3t/AZZXgpUUBPoN/8EcWLM6aSitZao8sMvkUu7sQcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=guQbtF2jldVKgx4ac787ghXRGdDM4Ye6jRjYUwcllIkG+O5epTzarqTG/si+Dq7cd
	 8SAQXX3JwughkvqUx9Ef6WOTuPu9qLF3Qyqyf+MPL0zMS+bKGmlqJ8zmyzBmZqD3vF
	 dEt4/oPS7+PqkIpO9cQ2jJSEsfB3Kp4ifdiqTxmcNuNuT1pIexCUI/Ft441pXEgt4s
	 ltwwL3cFcpsnoAa45emlUhoxiDyKEHWddO+SR1XkpvsE8z9U9ysIjcLz9ege4L4IUV
	 ZGHcgwYNvLUFYWrREJXvQ3Ph63X2uBayjKz3okeaKiP2/QLBfaDLvop+6MMV6CpbQr
	 hdR+Mx+Mq+T3w==
Date: Thu, 5 Nov 2026 09:59:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Alexander Graf <graf@amazon.com>, Tony Luck <tony.luck@intel.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org
Subject: Re: [PATCH v2] memblock: don't allocate new reserve_mem regions on a
 KHO boot
Message-ID: <auw3dtAMp4CjNwY2@kernel.org>
References: <20261104204235.9066-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104204235.9066-1-azpijr@gmail.com>
X-Stat-Signature: ju7y5rrtwcxde63ifayaszagqbjsyk3b
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2AFE740003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793865599-7434
X-HE-Meta: U2FsdGVkX184ZU5/QiQRJn1igBgU9VDla7auEfkbRIB9RAGBpg5hTrasvd1bHYdZTj/17Nbcwwq8jhO1xAeUnr3anu3LEjzka8DEhH9tNMxc6tLQhVIJnScEQlCq0ekfuOQgd5tNs2SgquwnqpsxNXgop4Fl8x7dNyiZHGlPDf1iDiNbZQrm241oYRPymyIknrhwZxj5wzOHcevQ6y4rvUHkr+I3Oc3fFsJpp36B6OQ9Ngw1x5iXmbjAiEJjhpzlXrGEg0EOvKO278su7m1a7vvxRrz1WVVIVpO9qY/SW0TH8cHwaCqh/uH3hye97QZXP620qRueKGV7csbqwMk6Fs1gOuINfnPu+hCwAU8P0z8ac0leTohlbCNz57h4An2xTlimybrp1+Fu288TX6UrcnohEF8HCt6su5QmDMQdJLS3mhPZFYGtQYDryE6KXmjFZO9i6zd4Mt/5cZ4CziaQjl+xoQxbel+PyRs0VCATpUSEllZCKG/Ds1at4M4uMpg8C5UYF2Dj95bGB+tLlScjnShpXghplSUpA9bMkXoisQS/w4jUbSssoJIyR6zmj1imL9gy0kLO/uF3f9LfWpMLjtlKk2B/Jr49PvJGDkNJ3PpdQDja4CYTtIrUlg3m0dX5O/fpUpLtbY5l+8j9JN6IiVHFHGb5DDlsCDerd/tTDNT/vsHZWYb5p2WnvNfUBl8qKShayb9lkN/InoHpf8NvzGk9vQVwM9ZqudIhC0DtYxBwNJJx17xRHpXTKdoPf5VyGofuD1wDlNLQ2LVWYYAaTiAjX9L5V04Q5y8ehbojxfe0XvrlDU3Cr53AHnmwvgFgZHwk2swlD7NbtqwT8aBO7/tkaUOKH/GN6KAyrIywTcqcGeB+/i2ijQM1wB+fC5c0UlUvGNwwGAR+LefQpXQN45G0j182pcVygItjSXnvedQYBAtQwIkauKSnHyVZsyZB5FtDtw3rae96xZrkmht
 +Mzzxbez
 RxsL2NKXswWbfmA1sVH16KSSlq2fbgw/ZRIVbIhk8QQ1zjtI6MPRxv+Un1y58/OcfNQO0NiL3Vd2H2HuTC6tl/y+DJoOO85kkQ/JMhjtyWzSJJEzgN8QRWr8Fp0K801O5bdvyqUyJwniRugUJ+q4eWtpgW2ACfaA62Q9yNCWrQOKtQ5anZZuA3k6SLXQVz3VRZN8n72HuVGAI3gNttDELLFSp+e/fJju5FvYwiyBYj6vgVbnfqMRzVlTzIsXq8YPSEeMzguQLFtRbWL81wK6EXog8VSRrxoJ517yAojFlJOkyEi7eNoEQja7pXCIeJfmM9CQ3Zkn9QFQCVrbDrywqLUMDtNKqR22zUbpb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 09:42:17PM +0100, Jose A. Perez de Azpillaga wrote:
> On a KHO boot, a reserve_mem region that can't be revived is allocated
> from KHO_NOPRSRV memory, which includes the bootmem the next kernel
> boots out of. With CONFIG_KEXEC_HANDOVER_DEBUG, preserving the region
> then fails:
> 
>   WARNING: kernel/liveupdate/kexec_handover.c:1245 at kho_preserve_pages+0x168/0x180
>   failed to prepare memblock FDT for KHO: -22
> 
> Without it, the next kernel puts its memmap on top of the region and
> the ramoops records in it are lost.
> 
> There is no use case for adding regions across a live update, so fail
> instead of allocating, and drop the TODO.
> 
> Fixes: f99230780211 ("memblock: add KHO support for reserve_mem")
> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
> Changes in v2:
> - fail on a KHO boot instead of allocating outside bootmem, as agreed
>   with Pratyush [1]. this drops v1's patch 1.
> - not an RFC anymore.
> - based on v7.4-rc1.
> 
> v1: https://lore.kernel.org/all/20261021211058.83483-3-azpijr@gmail.com/
> 
> [1] https://lore.kernel.org/all/2vxzfqxglrg6.fsf@kernel.org/
> 
>  mm/memblock.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index a450092a80fb..e325e0542c9a 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2827,7 +2827,16 @@ static int __init reserve_mem(char *p)
>  	if (reserve_mem_kho_revive(name, size, align))
>  		return 1;
>  
> -	/* TODO: Allocation must be outside of KHO_NOPRSRV region */
> +	/*
> +	 * On a KHO boot memblock only allocates from KHO_NOPRSRV memory here,
> +	 * which includes the bootmem the next kernel boots out of. Only regions
> +	 * handed over by the previous kernel are supported.
> +	 */
> +	if (is_kho_boot()) {

This breaks memblock tests, please add a stub there.

> +		pr_err("reserve_mem: can't allocate \"%s\" on a KHO boot\n", name);
> +		return -EOPNOTSUPP;
> +	}
> +
>  	start = memblock_phys_alloc(size, align);
>  	if (!start) {
>  		pr_err("reserve_mem: memblock allocation failed\n");
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
> -- 
> 2.56.0
> 

-- 
Sincerely yours,
Mike.

