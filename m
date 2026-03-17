Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E8BEF33833
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 10:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F006B0005; Tue, 17 Mar 2026 06:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16206B0089; Tue, 17 Mar 2026 06:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E543C6B008A; Tue, 17 Mar 2026 06:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D61276B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:01:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 508618C00D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:01:24 +0000 (UTC)
X-FDA: 84555112488.06.E4B687B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4DF6A160005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:01:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D1WMtBq7;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773741682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28V4IVGomItm6re7uKRIK/x7MfEGVvolNlwsk5chBPY=;
	b=q+civ3LDs7Ov5L8hAf1B+wJHGn1PkicWGplCFrV/y6BJLuWKoLIYOl3x1MDd0pXh/Cx4pg
	xIeaMfTddtCaLqkh4iNuyObInlbrjMfncCPPFrfWDnLXEW2DK9Gtv3GyDEHk9CIvtsXobT
	yIVl1Jkdxd32kadTZ5N+c3DFcmbiWPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773741682; a=rsa-sha256;
	cv=none;
	b=7ZKS9PrDFj4HPNmu01cWUzc3ljCoW4BGB6xnKX3gFRUaqHaAL7ZvqaAhIQrryngj9RD1Po
	v2rHucMw+ZoBYxTEIJFyYeZqwApCfEOtknEMTvGWgyueT6JSbul4TB8F6GmSjc5bTt1phv
	qJ37iXnifwZPVHmOTP0wp7XcDnYJ5PI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D1WMtBq7;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 757A840A83;
	Tue, 17 Mar 2026 10:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E566DC4CEF7;
	Tue, 17 Mar 2026 10:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773741681;
	bh=FRX7gMvgokkDLXWJAslMMqJm//JfKxgfgKg3VtyhJC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D1WMtBq7x7nk6P8850l+5YgDNwe/+2HGXRB90PKEnkf2ZdTrezqCoYAqT9/gFM5Cq
	 3QRPK844hptzPiNuibFBLXw+KJyva4jkXqf3GsBbCSlDtpGtmw69tw0Ot93rURVkDQ
	 F1PjH2U6YFJJEujhgsgPLKYy1GQlkBBtHMjJZjEb5ljNGUNk6O/SGq8rruZN6Dp5QT
	 soGamvWwyB7Cb/BFOlZz4DYFFx2HcgdE2T7KCJqMGFgvxVtb8TqjfdfazRuQa3jDsi
	 B3NHJkUFcuITiDLY0gg5+r3xgbBmBAUcoMGY5XqLGc1DeRFOgeiGVZ9uQ8sfaCblhw
	 islPFYdKcwEEQ==
Date: Tue, 17 Mar 2026 10:01:19 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mateusz Guzik <mjguzik@gmail.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Message-ID: <a4973bb0-9286-4b49-9e53-656eec2e9d93@lucifer.local>
References: <20260316140122.339697-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316140122.339697-1-ljs@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DF6A160005
X-Stat-Signature: fhu6uhak48fpoxoi4kgoy8oginkcu8si
X-Rspam-User: 
X-HE-Tag: 1773741682-501700
X-HE-Meta: U2FsdGVkX18upH62FNh+ukLLq507UAGSmn0+okNHZFCKIR6punp8ypNDzi/e3KSQfPuqD0tyvZySBf1Ufa9vI4WtuD0oWW1J5FPkFa1CK+7GOZy+dt/ACE54ffMtbWCigk3NwtPLJwZW0k5Ur/ZE1dyQ5vZwGG/Ke8I7bRycQzYv5Yso0Q6LToIPcc7PNJ2AaDL1pkd2VAJdQNnkvZrR+JPraG0SoRl5kHEutCEsTQFJ0MoxpXKWWxyzVsykzCteXrJPAVaBQYlXb02RmfbbyFXxMMMVfBEUjjkU2YgSpj8HLxxD0gVIXE9dvyOs5BDcy/V++KO3dTJAtNlLG+kOUg703Q5e+zqnksIL80/s4yuamdg7WsMvNE5XzroEauwCIB+qB23ESseODJFP9fHdlezSzzrpp+J76VXutkA0zVcnL7wTpDsCLWxo6lR58/W3r7EcTU2Hx5DE9Datdwwr/CegRM3i751YBXiKgTFLVLHscw+EdvTz0qXi09rw4E76LO6/O79iw+Vs/vrQ+DsUg10/Vy4uJsjRUkqNnM5LwM9/BFrlBr8HCg9WALIqOj8zmnL+Ou60i1zRaOtKdhZyEh5vrDcJ6bXjA9fkHAnk4CaFe+vK1CMiY+AFPeDnbQ+xGlvRV0r4eS8Gheew6249/6S3vMG9ZCu7L5KjKmhiRNi31o2zTFF7+oGHhPE7NC8yGQKnml4JtH1UhcyNdOOU+I1beKkJd7Ko4ARGE9U5OAciWVlebyZ+7f36bKDODn+bXiiKxzLdzoZAph8nm8mdeRdge7hlmkjWCQdMvhB62184Vv4mU6w6n7ccOT0yaZF8lb92c6urhJN/wOLFyFgQJuQpeDOMNObVH5ZiBNm9VY0eLyh0Obay5wwOsgE5mKJTGgBXbfO1DkmWt98GWCsVbY+mBXrBvmKVma8VA31CBkzsC9r/TAUWNMoOnpro30ZImDeqeKLSeqM1Q+5+fWc
 9DJINm5g
 Giu9r3rJwFKpMX7E5cSW4tR8QvX0f06b3k1ukh+/jCvEqjHiTLKQ8hGI/28srxmGRvfDSxrA5BgT3LIVAnghD+kG180MNz2Sla+M8GR9uojkEOf18i/wDnbwF4i+9jtPnU0l0WGiOihltwm51fPF2a6daaSW1hkGf4XsHwWhIDH2o4kdYNSNh08tTfZFIXCv2q0hjKSXCwP921JuzWURf9m5W3NujdrEHKJR7oQ861GPNXxckOHbC+haBp/mAmO2jH9VIdP+RhyweYJfe+hYFw0Kmi/7dHG9QkvRSWww4I+kkuDYJoVw3uFLHGKHIy1r57KYI8RFNTfk30zlSOSSHwjx6/XEoOmSWP4aiiLagZyPQdBqyrtjaSRQCVtGzFAsY6k0CRQmXGgtkpHF6/NZ9CSNspyd1OF38o6IIkoOpZoB/l+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 02:01:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
> zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
> data for uncompressed pages.
>
> In doing so, it mapped kernel memory locally for 32-bit kernels using
> kmap_local_folio(), however it never unmapped this memory.
>
> This resulted in the linked syzbot report where a BUG_ON() is triggered due
> to leaking the kmap slot.
>
> This patch fixes the issue by explicitly unmapping the established kmap.
>
> Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
> Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/zswap.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index e6ec3295bdb0..499520f65ff0 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -942,9 +942,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>
>  	/* zswap entries of length PAGE_SIZE are not compressed. */
>  	if (entry->length == PAGE_SIZE) {
> +		void *dst;
> +
>  		WARN_ON_ONCE(input->length != PAGE_SIZE);
> -		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
> +
> +		dst = kmap_local_folio(folio, 0);
> +		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
>  		dlen = PAGE_SIZE;
> +		kunmap_local(dst);

FYI to address (in advance) the AI review from [0] which a couple people made me
aware of - we don't need a flush_dcache_folio() here, because the folio is not
yet accessible by userspace, so we can't have virtual aliasing of the folio's
physical address on VIVT architectures.

Examining call paths:

zswap_writeback_entry() -> only calls zswap_decompress() if allocated
-> zswap_decompress()

swap_vma_readahead() -> only calls swap_read_folio() if allocated
swap_cluster_readahead() -> only calls swap_read_folio() if allocated
read_swap_cache_async() ->  only calls swap_read_folio() if allocated
do_swap_page() -> called in path where folio allocated
shmem_swap_alloc_folio() -> as name implies, allocated folio
-> swap_read_folio()
-> zswap_load()
-> zswap_decompress()

So actually no longer doing this is a de-pessimisation ;)

[0]:https://sashiko.dev/#/patchset/20260316140122.339697-1-ljs%40kernel.org

>  	} else {
>  		sg_init_table(&output, 1);
>  		sg_set_folio(&output, folio, PAGE_SIZE, 0);
> --
> 2.53.0

Cheers, Lorenzo

