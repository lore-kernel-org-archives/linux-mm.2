Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666A3CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 12:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68806B009B; Sat, 23 May 2026 08:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF32D6B009D; Sat, 23 May 2026 08:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA136B009E; Sat, 23 May 2026 08:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 853F86B009B
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:11:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4871E120B2E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:20 +0000 (UTC)
X-FDA: 84798569520.14.6DA177E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A71DFC0010
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emz2jnqj;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779538278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1wgwA+Vq+cgG6DenLipxbTjkVMrwQwE1EoJ9iSs0eY=;
	b=GH4N5iKndZlwGgBCTy9RI3jh17EqhnKVO/NyfbQrCdPWEpJk61saXDZte7ViiBhzvVsUad
	Pzzl611C9YqwhdbCLaaDQtaahqZ3NSH/CrNSetvlYU0CF4/JYUA2JQBPAlcmEDjadqQuHZ
	P6tAgFN9M6pPZkJNj0p41BQ30EhOvLY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emz2jnqj;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779538278; a=rsa-sha256;
	cv=none;
	b=CwABpJHsrhP+52WC5uj+vcAHzkd5SEp5Zr0CBZnG+I50pYHUZwV4boGgUHRFez+FzquDmL
	NXDIAfIaaalYk0YPprUT8e3Jc7VqAluP5JzH+otkHThSDke1fO4gVIB9os/GiiwNmjOtGY
	YLvfqRHus20zXK0zzVrYK9Ay1eFknjY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F75460215;
	Sat, 23 May 2026 12:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A08F1F000E9;
	Sat, 23 May 2026 12:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779538277;
	bh=b1wgwA+Vq+cgG6DenLipxbTjkVMrwQwE1EoJ9iSs0eY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=emz2jnqjttKsnlrghDgcd5WlZbWZQl5vO8MV7m6QcVNWYJJsetTutVKdxOYDr1RNf
	 SOxsVBZvg1JRLSLhY98fdzCocFAq7kA0pP4ZAmJHofZbmW6W4gLUv18kQBzh0IWpmP
	 nwDjDGNhkMqDNkK+GtUUS0ODdO8IhwwIYbs7zIGEU78Cq+vCLvr5I50O9+dm9xRNhy
	 s1vcZqpdtOP9poWeMhc/KKy7najXxo1cTBiCzRGqPeYIY7SCK8+jHh6hL/beB8Y989
	 ufbDFxWBjnOAj4waGSwuWbo2F93+N+HYYkmJyDOjKVNp/W507T6OuMJflP/ntvBDXR
	 dlSzNw/LPsk8Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 7/7] mm: use memcpy_streaming() in zone-device
 template copies
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: apopple@nvidia.com, akpm@linux-foundation.org, arnd@arndb.de, 
 bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, 
 mingo@redhat.com, rppt@kernel.org, tglx@kernel.org, kees@kernel.org, 
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org, linux-hardening@vger.kernel.org
In-Reply-To: <20260521040124.10608-8-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
 <20260521040124.10608-8-lizhe.67@bytedance.com>
Date: Sat, 23 May 2026 15:10:52 +0300
Message-Id: <177953825222.3959652.3741865801916579097.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A71DFC0010
X-Stat-Signature: a7qkstm8n4qya6ibgirjmgsj6brw1ec1
X-HE-Tag: 1779538278-865675
X-HE-Meta: U2FsdGVkX1/uOPJ+HlEMnvJ/JbBpIJ745QzG+0bH1TQ4LGR2BOxmDh4l3KSWQ++ZMSPnsqaRmTUZXHvzC8c1CB5lvF2TIqSgV6L/7a66RtKOxP18RS/heV8xCKLQ/O5U66/aZ9dnjknc1+44Lpm6p8+yzXq/InsxtdW8QSe42Fnk9uw/22+tsYOekIyubJ9GqWN08wK2mBAz+K6EwKrASAUnbWvT4K+Asd2hcc2Fx3EmCWqsuaMIsqwz7m9BdYHo+hF4kE6XnDoJ7COnFzcWskePlG9whNWDS2k3epZAbbgd5C8IMzhbDHV70fDPiryYzjXIdLZousjtY8QK9LTINTwVFozzbFuSIwMIJx6v5L4UA4Vy75PvxD0O30EWD3UX798RKszqNH8lQ2DJUY9H9KfgS7Qzsgz1/6sLgQG+4xcE2xokkh7OAw5DGeuf9fXyGYuUIpDHWGSXlLZB5MSW33eU/9ToNQQ3OXXeuK0e6ZCqb8N+zaIjPfLNd+cM7tkxh6MTr76FwM5m4b0E0Wz6Cbu5ZuJXWEecDoTinZHzSw7CZBiWL2KEFQMSF3PBpnMHkv/72Qbzx3HBsRxsO4QC0h7e7TrElYdGwMTX8VEkEB1tDiIbX2mKxKF66zbfmPdQVn+2oxz92bktvGP/NIZbhtrabwHE+dXiXGxxLHaDrdo/puwSGEGd1oz+KnS1MWw1ymAW5QSxxAADC4nTL6I6cPro9wFDBBEw3YIBhGz5jLyDL4AQ5e75aorhJILK77f/71nC9yS69f1jbuOAv0fmF+xmQFfldwEvY3sTbetNRYOJmG6yATaEDcrsQl+Yhuwg+CSWTYLYeCXSZdYivrdgT/RljlFyBLqOGFT4eFKkXWKWXC3AXTRpHyFdOgCI8UWKPQsyEWLtNbBOQk0qHGoAQvc6bM0M5e7DZIgYbliIXBIF3MyENqV3vx5BmKD7Z8NJhRSl7SJS6IEFa/Deb0C
 NHuDAyXm
 MHFIfzrGNkW4XuVetALb7UWAtvCiqVJzgeZhF+TFPh0swRgej5917usef7n3f7zTOVKi3jY4umOx351QXUGmrafr9u5WBYdKdDULdPEXGnPGdAdCAnwwY0bltnpPqufX1GypHcVd0h5WPw66w/SWP6wim+jg/mIGVgXbYcJhxl83lcJQdrA7T52XSQ2IY/Sm+u4ty8p+W6zYmT4vTWRu6PtyX3Y9DC2UyeCDtm8uOorH3DbK+auSdeOqGO4j6D3IAsJzITQphWTMb+y1+0aHic7QJroZe4zOFmjpR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 12:01:24 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 17a84d4cda01..08feb24795b8 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1075,13 +1075,15 @@ static void __ref zone_device_page_init_slow(struct page *page,
> [ ... skip 12 lines ... ]
>  	 */
> -	return !page_ref_tracepoint_active(page_ref_set) &&
> -		IS_ALIGNED(sizeof(struct page), sizeof(u64));
> +	return !IS_ENABLED(CONFIG_KASAN) && !IS_ENABLED(CONFIG_KMSAN) &&
> +	       !page_ref_tracepoint_active(page_ref_set) &&
> +	       IS_ALIGNED(sizeof(struct page), sizeof(u64));

Oh, can we rewrite it as a sequence of

	if (cond)
		return false;
	...

	return true;

I believe the compilers would generate the same code.

> @@ -1104,30 +1106,42 @@ static inline void zone_device_template_tail_page_init(struct page *template,
> [ ... skip 10 lines ... ]
> + * copying it into @page.
>   */
> -static inline void zone_device_page_init_finish(struct page *page,
> -							unsigned long pfn)
> +static inline void zone_device_page_update_template(struct page *template,
> +						    unsigned long pfn)

Two tabs for indentation here from the first patch this function
appears please.

Why do we need the intermediate step of _init_finish() if we later
change it to _update_template()?

> [ ... skip 30 lines ... ]
> +		memcpy(page, template, sizeof(*page));
> +	else
> +		memcpy_streaming(page, template, sizeof(*page));
>  
> -	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
> -		dst[i] = src[i];

If you replace this with memcpy, what's the point for doing the loop in
intermediate patches?

-- 
Sincerely yours,
Mike.


