Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68494F506E1
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 14:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24606B0290; Mon, 16 Mar 2026 10:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDEF6B0295; Mon, 16 Mar 2026 10:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFABF6B0297; Mon, 16 Mar 2026 10:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B06246B0290
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:52:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 686C51602A1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:52:28 +0000 (UTC)
X-FDA: 84552217176.16.EDCF9BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C6DBB160006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:52:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DfW4y7ce;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773672746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjHe2iOqzL91ck24fpCm+amCgHyF9ndcvZKMTH4bccs=;
	b=ewEIFEAyFnpUI74QzDok2noL23gOPM4fsjGmq6KrXjTovwnH/cCIjOdc0TmbGYwFk2xAgf
	hf8jwDJyNx8oqP3PJjuthYr+VdHCwYJbfRSXz/3mXOG3z+Ald5QPCJSPSqo5yNv5+bBUhq
	/M2nQ4doXpCQ4EVF7iMgiub2fGF7Nqg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DfW4y7ce;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773672746; a=rsa-sha256;
	cv=none;
	b=da392CBu+ftBygmyjNmLXVQI348acWuape1IPIcHzPhbEeuBm1eeitFoAauscIy33f5L1r
	Ka/tBC0FCBLBjBsvJosVALvP2xDrmKcRU958HC4DKyz8n/JF4yWfdVraGU78SZCg7FshG1
	jPDceK8YQmPTU1oYrWY+ZB5rA3WahFc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4976A600AD;
	Mon, 16 Mar 2026 14:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74D3C19421;
	Mon, 16 Mar 2026 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773672746;
	bh=nXa/crsZunzyPoYFm5OwusAkjLu41BbPXctb3NCGNNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DfW4y7cetHIXd5DCFdCHyjUkLHw9LwgdUVV78AtJvz8zsz40mkyVR5D1LWvPNsrH0
	 +qB0jmsQut4TQ3jvWrrQu7KYlmwbpEAtY+Prx4Q/y08727ihuYMhjyPgS2TztiWN6E
	 N3W5LLxJyZuv7yYyqJkmU3NrvIw+GPjbCu7OEXHHU3RwNdwrfN9YKWP7nkgWICj4GM
	 ZeBccBEWeQb6OJC8DraTxtFSQA8X+aKoeGZvfc9fIMOfJqumD+/KfRXMPmwdCJDA9E
	 JFw5mlJ+stGcbGNWHWIsmPHu6mJ3ozJX8FBRi3F8AhoezyMCgI6zJiMskCSmCdFM7D
	 rcEHikoXEIVQA==
Date: Mon, 16 Mar 2026 14:52:24 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Message-ID: <abgY3RNYj7WrYYnq@google.com>
References: <20260316140122.339697-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316140122.339697-1-ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: C6DBB160006
X-Rspamd-Server: rspam08
X-Stat-Signature: 64fbkp717wri1paqgrwt86usd4ohw5ne
X-HE-Tag: 1773672746-73607
X-HE-Meta: U2FsdGVkX18wU7Az0TqzItxgOC0TluJCJwzOKB7djO5w04CN6WLiJfJt4fdbB2ikp8ZhDAhnnM6Tenb2cobc7eDddkTZKEQGeTWDeSdnjW4x5R/dU0DZ1fqKRH+gCJC70yMSw9viBTeiUMdnvG6rkl61tuT4bwgk3gZM6iWNLEaiyVO5HcCy3kW7DIaDSD07j9rrgMmfqbaPFxmdwtjmMMdY/YMi3SZ3DWSsHvSSBEZ4yjwDJe46SGC1+zkMiyce8db6gyl4bz7JB9z5InNuOnFPz34AHSSl117UruBJeKDuk3XtyUCXIEaRN/IDJw2Lfe1RVDSRjAnFsk0Xnqh6Q09JhReZksXlnzyB+Cr/3/ZfeqgERGekUHS9npcf/Vykx56FljIumAiLkPh/nhhxeYPsi0PpAlpoHFKcbaDXROxWJp2Im5X4OVhBmjzwGHf6VxnV46MlVlbDpgp8cNR/TjzLqCD1Uet4yRyqXvAr68lnEmu4xgAPQ3DCH/PF1n81HN5DOTTuGlPBJHKy2wmkpNFV/tI5l8V6nycpM/V71ppc1ysX2HuKRH1oe1mZ7fUY9EeSkkPH6QOVCCnnDZcukaBCB/FrqYa+C7fGx0q89iqg587DCivlZR9WY6N8dqGiSzXLx+Qj15FYi6OlyKQZ+Jvvn4CCWKGobsj289sIQmnU+GmTSYgW12tQ9D7i8GQ401+cQDg6BEyBSjHp8pYjChdhORoF6XNwWbwb4089J3rBljz3hkVl0MjmaQSSR3INOSfdTp6YQcGa5bvdtQGS38SpFg+xT2U/MLTay82K3GmRE1qJnjGeXS/2LJoNVH9sKY+FZL055FsFDzimdqlK7ejTMKhdSoVHVdy5ZX/WC1q+p01FVFGHua6TR8k+Gpaj8dPavBvUTacdZsPbfBpJ2onOB56TpIrmCQcdpFNVk5l3IJgd2fXrdfW/W2GD2uhRIeDYMYjP0BkcoTjFTv0
 XfiujkYd
 mftK+ypicjUcUONAWpl9Rn4qa3EDIFkS3KcaAjVtqF3qsy9SwojgIiLQhWzOtisiCmhkYoYpwFnNn0Na3yYQ1dfBunEBVeUCAxaIgEih0vi65Y9VDQWu0lnOg91fxWDByH7NWEuAG1zzwrsa0t/I2oLh7yqH4FMJHVf+LfMUpnOfTfX6JZTCjMeMzj4swYJSsfHSMDROPLges97iWNRACZeakvsA1mg6TyUAvu+eL5ZsVHWJYVYjlnnxavhlsuNBwS07Myoco/2U/k+t/5d0oFTbABd3F7/mh0yprNYW2ZFQV30XEwV985lKNw0znYpoKnzvQ7OoB5FMxK6hiS8pF4hkFUF0Mbc3fNDvr5JbVw2Z7kWvp4gcQk8YH1g==
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

Oh thanks for catching that, not sure how I ended up doing that tbh..

Anyway, LGTM:

Acked-by: Yosry Ahmed <yosry@kernel.org>

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
>  	} else {
>  		sg_init_table(&output, 1);
>  		sg_set_folio(&output, folio, PAGE_SIZE, 0);
> --
> 2.53.0

