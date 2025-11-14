Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C515CE8D5B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887958E0008; Fri, 14 Nov 2025 11:59:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837F78E0005; Fri, 14 Nov 2025 11:59:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727358E0008; Fri, 14 Nov 2025 11:59:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DBA38E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:59:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06C8E13B07E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:59:39 +0000 (UTC)
X-FDA: 84109824078.05.9CAAD1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B8B22001E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:59:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBi+hiwo;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z116tVXEe9/MkljJcWwj3SfWixMbIZ/hduWK0XTrkIs=;
	b=z7MlTAv2S776lAhZL/F5kW9tF9oAVWiDp7giy1pd1WihfABkrHw0kDyfqVusfGHQ+wSBDV
	mnzJ6AbZf6MghiL+Pr2O66ZMzeN4yr/KT6AVsB0B8A2YsS788ZvsBZVEjNYlqqIldqYwJ6
	Y6wKcPt/wv2Kf30rsLzKGTH4THQDI38=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBi+hiwo;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139577; a=rsa-sha256;
	cv=none;
	b=sNBAPQ9lPePlnq7QJ1/666HiqqQHpbF4JPe+BLClzxGN/6tlt+kK1SsAZQpLYdccaFpVol
	FcQ5WkxEQP+UoTsT+2jHp49gWlMVTnoLL05gpGndEfhh1B7fNJuMWzWCqbGeEN4inLtIBv
	1gb7Fj3XP8xJmoFjaZlVdWrne1ZdyeA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BF4E43DBD;
	Fri, 14 Nov 2025 16:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4000C4CEF1;
	Fri, 14 Nov 2025 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763139576;
	bh=7cmvOMMRkq7ABj9bLQADRb0yWVUhjMz3dsMaV2GWWsY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kBi+hiwo08/9mOe6EG2q1yq84Ff8LNY2+8836aE5rlJv1D7bXe9pmypkSuifU3fh3
	 euRqZaH2A3RgYi3jrloTypTJDJhUPQeUGuHW82BCUf2KyIzhyYeeb658jkRzdPQltK
	 BoOJ1jIdNh+OuaIDgwTIapMLlHt2quM88bE7z6cU25Q0yZjj0ckknCg4fYq3Sf62Yp
	 JwGmvLddaxWMIQextoL4nvDn5pBlZ3oVE+kUdvU0PafBTjXvBXo5Jt8f6KtG2hRHlk
	 dfH3RoNx5t9DgwYtIVGi0xW0bHL/YKRb+rCXX7J5BvokHxLQWzvi15ewRV65ck05tr
	 6IgfkYlkHBIWw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 05/13] kho: Always expose output FDT in debugfs
In-Reply-To: <20251114155358.2884014-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:50 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-6-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 17:59:32 +0100
Message-ID: <mafs0pl9k7dor.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B8B22001E
X-Stat-Signature: 9bp94p3tomw1kryor8mhagagk4gc9use
X-Rspam-User: 
X-HE-Tag: 1763139577-918789
X-HE-Meta: U2FsdGVkX1/glpCkN5rURI8cdkupcZLRgQDkvQkyM8i/k8E/YCcfeozb8DLBKPPO2hyJrDCqLJXyxmyVRnv/ymy782VqjgwihuX2lsuTGyTj+UzKsVClal2jKrn2A+rQdZSccY3hxVZGDi82y5OdbL0mDdjLdIChrbiS0QVwPe0gVp6jPMLf65d1JUO5Bb65v2OZMZueHmv3o8njDQHuIcwv+7FJLIaqIRRBE8IGf9b0J8yMVm7ChetNUOBiOd7X6SFacgCZgL3D3u12TQr1B3QlPkH+gMPj1TCE0lkzvDHP3JJyYDteWoe3K/H3AAi3tYtPhlZsnMYopXIZkGU7lJGenDzTDlhDTdo2WYY8D4dauFlWQF7oPLpieBs4Y7C05omloUa0/zcN6yd0o+0sb04uEhw8dfzVCX9UdYHeQGZgKH7PvTcFlQwBbmyuI0D9lqJMcr6KjrL2Q/TOkF7eLkQnKbVyL3bosDorUphKn739jeBAqmY1SgjSV67onECGxAT/lCcjgzPuUgLuGL4bo2uvkxi+Q0vJZ25yXN/vX8hLVp+PdoBWt8Zf31OxZuvYuj5Fx6a42Qo3oxFT+AJVuyTytu5eXMV/825H+slDXtV/F7lLQQaI5HRba8ChchXEiGSSKOtUfpjH2CPLykillpBFr407BqK3mFJUyKYEQ4ACG/tWgy1poxoKkOE56VL+sbPbeAHptzLaxuN+0Evh6yEdkJAYRig+ln17Vf3h4aCYAFQ4HSpPRHCXcNAHrmumVxoN2Z0MEpWqKD9kXnmUg3RqkDPRwiYIYLkm9LSsG9LfWwI1rybzm1n5Eo1/yp8bRlYp+jqw5mzTcD+aCRTQ0jrlpD3Z0IZSbfG5zZr7nhTKBHjsputlx5hu7BWEYK4lgWRJq+ZLZfeaqa+MXnTIUN7DKjz5q0xjvPgppz/KsgP5unHuSyhDbX1IaQqp/QqzEzxGefT4gukdJsEGI3r
 n0t7I2tb
 +RKV6SvdhFTOZtxTheXDtpD8QAeARhZNlVmlgnPou5ZYBDKXbt6JTjJRZTjSNr/jvywzQIDSzdLjMmX0mWCmZqPJYcsf0tcY9FtGSo6FhiZ8VXzFT2c5auhVF1v/Ywuy/X0LkoPJbtjFGx0qQvYMTexI/6YnQM99kqx766C8xbgtnwZgnbcsCLWtamh/rJRnHvH+abzavNx1oRbDeaFEVINoI+zsgKRQLwv+1EIXRzQf1iqHLDRVKrGVnHcd4VS0TsYaY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, the output FDT is added to debugfs only when KHO is
> finalized and removed when aborted.
>
> There is no need to hide the FDT based on the state. Always expose it
> starting from initialization. This aids the transition toward removing
> the explicit abort functionality and converting KHO to be fully
> stateless.
>
> Also, pre-zero the FDT tree so we do not expose random bits to the
> user and to the next kernel.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 83aca3b4af15..cd8641725343 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1147,8 +1147,6 @@ int kho_abort(void)
>  	__kho_abort();
>  	kho_out.finalized = false;
>  
> -	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
> -
>  	return 0;
>  }
>  
> @@ -1219,9 +1217,6 @@ int kho_finalize(void)
>  
>  	kho_out.finalized = true;
>  
> -	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
> -					 kho_out.fdt, true));
> -
>  	return 0;
>  }
>  
> @@ -1310,7 +1305,7 @@ static __init int kho_init(void)
>  	if (!kho_enable)
>  		return 0;
>  
> -	fdt_page = alloc_page(GFP_KERNEL);
> +	fdt_page = alloc_page(GFP_KERNEL | __GFP_ZERO);

If I read the series right, patch 9 will make this a full FDT with no
subnodes. That makes a lot more sense than a zero page. Thinking out
loud.

For this patch,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>  	if (!fdt_page) {
>  		err = -ENOMEM;
>  		goto err_free_scratch;
> @@ -1344,6 +1339,9 @@ static __init int kho_init(void)
>  			init_cma_reserved_pageblock(pfn_to_page(pfn));
>  	}
>  
> +	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
> +					 kho_out.fdt, true));
> +
>  	return 0;
>  
>  err_free_fdt:

-- 
Regards,
Pratyush Yadav

