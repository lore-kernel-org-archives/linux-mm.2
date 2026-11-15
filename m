Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFC4B606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 07:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtr6zl5v
Received: by kanga.kvack.org (Postfix)
	id 0B2606B05B1; Sun, 15 Nov 2026 02:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063896B05B2; Sun, 15 Nov 2026 02:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94756B05B3; Sun, 15 Nov 2026 02:41:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA4F86B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:41:35 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43AB8405E1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:41:35 +0000 (UTC)
X-FDA: 85436558550.06.0912A8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB07240006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:41:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mtr6zl5v;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794728493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iy1yWZA87o4ANy6mo1o5HnWu61B5w2dWNIFuaUYI9SA=;
	b=cSfFBUHbx8sLlk5OU7WkQX3CnGWRkuMgyTid+u/vjNtHX48JxHlBzBnIVNR2+le+Gxwm54
	KHiwz1AFUIEutzQGIy2w0WgxjCbykyrG+QjT4xh9qsSckuWIskCMnuVzZusvI7tzfr5lc9
	CfRVW7oc00WoPGVNe5fz7VgMX8dIGS8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mtr6zl5v;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794728493;
	b=gAZECgjsQ/wEXErDOCqFtEwsRxEtgIBE+JDINGzZz6U6wqaszD8xRTGtd7cCY5/0Dh0Q3N
	c5+QqtgOx20VJS+QcHA56VoVZqiyppmxcnSkxvWeN5mQ0RcO7an+tQq7ZhQoCDhTNUrAqb
	9cC8nBFxcaaW8Gdnc5T1rhnZuzJZmL4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8483A4578E;
	Sun, 15 Nov 2026 07:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C611F000C4;
	Sun, 15 Nov 2026 07:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794728492;
	bh=Iy1yWZA87o4ANy6mo1o5HnWu61B5w2dWNIFuaUYI9SA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mtr6zl5vtZdcMhU8RYT7ZO+1iF5+jlryoLi8lH5M08/CZQnDAAO59t/I/SXIeMokj
	 D8O5zC4oWfHlcEtTEMSzcUjhTUNLZlOJJ2k5vK8gJjk6SsKFZ5vozS8JTlTS9Ifhkv
	 U5Sus+GSUTIzd7TfdQjhj7McNwnq9sr9BLbEuVxVYZsU/ygfZT4oy2f2SBiTEHPLua
	 vch01kbM2vnWyvBTPcJsKLm7sYPaOHo6erW57kCViR16cZLCjdkwOGexOzVj8slfx3
	 i/yaFJZCVN30fAwRjNn3tjbgl21wPCEY7XutedIZaelaEMkxgmvKXnG6NYa3fKHTSY
	 hTt6MKV/s1yAQ==
Date: Sun, 15 Nov 2026 09:41:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/execmem: check execmem_restore_rox() failure in
 execmem_cache_free()
Message-ID: <avliJ2K24YJYvxXe@kernel.org>
References: <20261115004704544fuMEkcx0F4A1sNBAzz46-@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004704544fuMEkcx0F4A1sNBAzz46-@zte.com.cn>
X-Stat-Signature: tcyu5zj1q9bestdgf67q8j1166esrq97
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AB07240006
X-HE-Tag: 1794728493-114494
X-HE-Meta: U2FsdGVkX1+8S3je7JnEQyPrS6sKOZVfZ0ZJ8JC2WZ48hLdDMvVHXBcuz8yOgYsUtOncvIdpC7rm6kIhUMDE9JfX74simYoAX+2UaDZc8yrtFLFz9dPqfvZfdKZ+CrZHvwyxOM60luXvhFsy67YgbDNZ/u79vgkwFS/3eHCb6CZ6NogurSw1bKvnA4cl9ZuYqAWyP+BsoiRTBNHY7d90OXrPx9/oa9eUXiv2YqHPgLedUsmismeOprOYodeGzPmczfafECIxbHRn+EdzCPPUhYi4BMpMV7yPQo2PxZUKEVqoxegjeeYPtwDzw/H2pM1icjd25k9JR9YMEu2WXyS0+npfCrTBfeXgFhWJs0tgvfsqCPK//vD4LjvJCBiZ99XpS6odvQ/F1hTE/LT7skcPngL6GqW6f5kqXPrRiHp45yuGFecB4Pvrpo6bsGPyJ+dE6TjdOlG9Y6Kkx5LugrJKgzxo49UYv9FGRa/dcty4ryWHrnTvu8Zpb5kEKptmrCKW5ueiCL5l6Q4IiGHQ4/nE98an9obgTVXyo41bnEK2TWzznjz2ULyPfvg99aPTPxU1Zuq7AgB98UINYBKls7Ep9VZZCTdvzFgSew7sqXz2GCNTS8S8wH+RZHakeeN3K0ukQOh00EHx9h2lCUbnjJz/499naQxG5UEITQtAa8VRdtkL2Q3EGpr5uKGfloYAyflVixP+r1ZZ5g9zX5yr4o/2Q31hwqRy2bCWCYV1UkwUTnmnae2g1tX/ypYD5wv9+A2sVVBwQ0um05BMvq/MyN6RfFLfDfkCRMmJLnnCm0u8YkBBWP7U4HDoqwAjLhKT6zbhqfDQOi03QljfrIM/3toH4fLg+3UvX/MTgoCbZVm4vV+2AHCb3dEFvzbgXPsNuSq77fQd6KTRmhpeHFVhUW2BUkepDSSUu3TafyuiRCmOyMh19uKzEnkXAgZggSw0PMEPWNmoVI5HsHNUVw4tz05
 Uubfn5+Y
 P/Fct5XllemquUvuFVksLAd8fTmD74ptUiM2UDR0OhV3a1FexsvtaAacU4ZSaYkvXWI8UESSIVZfa+sBENrQznIOIpNgDRZeV3+2Q+4yQybj/4DG9UefrtjANsTh60RKJzBC/6QtXq5jqYppYsyVQ84VLAZPDncgecLEAJAmlmJluTSYjoc0O9OENeORH/GZ8oJ9S7/AC6IkZI+0sxsVI2YhekYXRbTV+xyzLDa1E35kwKmf/W+k9JFJGZlhndukVAAcl3Sz5XoSB1W7jPiJBvURhP/fcCzdYW8hrvWR3pet6thu4nnFwCfOEAX3MVC10G2IN61sPCq6BPk+CvkLUlZas4I+PhrgcPsDhzMX2sWbENMjOc+jOaGbw/09N9LYk+wde
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:47:04AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
> 
> mm/execmem: check execmem_restore_rox() failure in execmem_cache_free()
> 
> __execmem_cache_free() checks execmem_force_rw(), but ignores the
> matching execmem_restore_rox() result before adding the block to the
> free ROX cache. A failed restore can leave permissions only partially
> updated, so a later cache allocation can return memory that is not ROX.
> The cache allocation path does not reapply permissions.
> 
> Check the restore result and return the error. The existing callers keep
> failed frees pending and retry them through delayed work. This prevents
> a block whose ROX restoration failed from entering the free cache, and
> matches the error handling in execmem_vmalloc_rox().
> 
> Fixes: 187fd8521dd8 ("execmem: rework execmem_cache_free()")
> Cc: stable@vger.kernel.org # 6.17
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> ---
> Build-tested mm/execmem.o with W=1 and CONFIG_ARCH_HAS_EXECMEM_ROX=y
> on x86_64. The pending-free error path was reviewed statically.
> No natural CPA restore failure or BPF execution fault was reproduced.
 
Yes, because it cannot happen.
 
>  mm/execmem.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 349cadd874863a8b82052470e3b0e7b0df2e0ba7..4a48e9f445a02f783ca4dd501559cded54892dd8 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -351,7 +351,9 @@ static int __execmem_cache_free(struct ma_state *mas, void *ptr, gfp_t gfp_mask)
>  		return err;
>  
>  	execmem_fill_trapping_insns(ptr, size);
> -	execmem_restore_rox(ptr, size);
> +	err = execmem_restore_rox(ptr, size);
> +	if (err)
> +		return err;
>  
>  	err = execmem_cache_add_locked(ptr, size, gfp_mask);
>  	if (err)
> 
> base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
> -- 
> 2.43.0

-- 
Sincerely yours,
Mike.

