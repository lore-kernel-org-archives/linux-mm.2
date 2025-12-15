Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B680D5B862
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 18:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0946B0088; Mon, 15 Dec 2025 13:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789706B0089; Mon, 15 Dec 2025 13:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688B26B008A; Mon, 15 Dec 2025 13:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC616B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 13:17:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04A57133751
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:17:23 +0000 (UTC)
X-FDA: 84222512808.07.36E2D8E
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id EB52A18000A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:17:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ao3/DWdx";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765822642; a=rsa-sha256;
	cv=none;
	b=AsLI857Ni13zxTFM1VUVi+zziZfhOnVw7C/JKfgHNyokTHtFfJaLnjcuArXYe50eyw+d2J
	ABXo4qpa0tAZuu455RDy/MOTfHuywxtetoUBCKf/ehzKKZzu+C7MNMV6YTOobNyr+kiCrG
	Ay1QakFWp9qHCjtr9TNn7rKMw+I+ktM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ao3/DWdx";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765822642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SDuYcgYt8Iaz1SlD83l9AQG5ZEqQi3Tk0awwVnuArg=;
	b=p+AHkUWY0Rnl8DvrWpEWC/oy8GkxmlBIXTjgfGFOlwhqWl59tVq9TvDbfqXmVcFvqdoEwQ
	y8p9JdrUBzEwBhehauUJZAjbPDCV+1jIMEUDbzE/sXwpmeJO1h74Rl+ERkxvDmLnE7S51x
	RBdb7vw37Sw3xrn7/13wgA+6PspEXfA=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-37b983fbd45so30691631fa.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765822640; x=1766427440; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8SDuYcgYt8Iaz1SlD83l9AQG5ZEqQi3Tk0awwVnuArg=;
        b=Ao3/DWdxqX1oPx/IVflT4nUBRAfOpy6Rr6wEvlNEb7+bn1vI9xnzR/f2e8LIAHAWJH
         pCQYF6fWufedT3rTtXo5sb5CAK+mkWBZAgaXh7BFOIyac9WQ81tlWeVuQsZQ883Ai0ie
         dUnB/5o7Kl77zSJhO1fcHbouFwWqAGQYh7EGFyN31EocFwwwVkBlxrxQ+O0KYiMaCrmK
         pqtkGQne2BQcXHwp5VeVgD6lrAdgb+WH7+YK5+fZSOhxIveH2XlsT68OiWnAcZpvS4aa
         PfzeJ71MBvCGvOqnm+V/CD8wfgSmySmrDv7ds4r7eRI9aZvtZFpNSaM2a7LaRo4bxMHk
         6yrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765822640; x=1766427440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SDuYcgYt8Iaz1SlD83l9AQG5ZEqQi3Tk0awwVnuArg=;
        b=lC7JKKodXA3VzngzOPzACv0AsfJtf7FtK5dg0ZWZWH8+Wcnv03+4Fhz49IL1qLl4hU
         RLPVh1YA+hYgtd7rIjvRABl5ZgQV68wHqI/7U/zGL1QuYxKgIFc+jNF7olIRmkyJSC8F
         ZS+YLWu3ArtrLLTAI3zKth19sNo4cfMyFK2DQYQjj1RCX944aYdK/Non5v+Gkh0hbZlx
         XiWBMoe4v1BbGzc3LRj/5Gnr1WOyidrTCQmcWzoTITzKe4B1SCiMYkr4VQfbjdNxEKWN
         c5pTMTr+7VABeejaiJTPuwnR3FEZN3CPsTlAgdcqqzg9eZooPCE5PRS3bUjPCmZ77mby
         TlNA==
X-Forwarded-Encrypted: i=1; AJvYcCWJZPMwIc7zXRpr1xSpoWqS01KbNSdGlbaFbLSbPnshDCwFCWZT8O0xE4sUcDT7kaytv/a+60TS6w==@kvack.org
X-Gm-Message-State: AOJu0YwqG4hhn0Lroj74YjpYT43cN1O9IiN1fPKNyXPwgyHus/lxMwuX
	UBY1y0I6cmdYphQh7cNT208NU+FDo+GaLcyidOWft/NcVPxqPJsbNEnm
X-Gm-Gg: AY/fxX5GsllXD8Ui2uAW6W2tsESzEtuCMSUqPdVkD2uQOZTeWtZyHKd+Xkmf0DrCZs0
	uDQW1Bz4nUd0Sft2MddVryYRMVYI5uzv+9HOZV5SExh5EaZKr8VLmMDApFgjhyZ8WC4Pm250OAk
	bCBI3G4ACb5E5LevlV4QEozoPICPDt6iBs+LB486jA5mji4Xxd1r3j3iz5c/MMYq+bre4D4UOYd
	4Hgr4tKoj6mJT97bD18jNOsirmeQI6013LkLJXrzyGdBeS2O8VKbZSscG7husE9q0zIH3y5zmX7
	P7u9VQBj8hQLYcTdMb3E3HUyv14IHYltapUOhP2LS1Hq16CaOpDxTlxm3Fnewk6YiBt1InTzvVT
	DjssBa1M+eh8GvAOjwxdmfqJwQifVWk9Zp0OAyLQpl9tR7Kk2Wm1w
X-Google-Smtp-Source: AGHT+IHIpWAWwFf19dyptIqYZHoE61ofRWWM/liv2W0ayoYF4HcpI+iP57FxDb1keetfu/UwgCkMcw==
X-Received: by 2002:a2e:bc81:0:b0:37f:8332:6ae0 with SMTP id 38308e7fff4ca-37fd08a23aemr43667381fa.33.1765822639677;
        Mon, 15 Dec 2025 10:17:19 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37fded7629esm28801271fa.24.2025.12.15.10.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 10:17:19 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 15 Dec 2025 19:17:17 +0100
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/vmalloc: clarify why vmap_range_noflush() might
 sleep
Message-ID: <aUBQrR5QlzOBB36r@milan>
References: <20251215-b4-vmalloc-might_alloc-v3-1-92dd8e406868@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215-b4-vmalloc-might_alloc-v3-1-92dd8e406868@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EB52A18000A
X-Stat-Signature: iia741ukag3inmnr563hbr6qa9y9r1jk
X-HE-Tag: 1765822641-815806
X-HE-Meta: U2FsdGVkX19/22sDFVmMVQ/woHosrm9yjsWTCY0POiaD9GrRVPfql5wbpFGdsI/LXxMxj0to+31P5APFQVqmgt7083XpoYQzQGqApp+5j//kykNVXsNYvEvdyGrJyPs7vH96sioZ5hT72RZng6zLAi7WAFnto2xz6A/pRmODLLbhYix2BnAJovaS0nZtPjztTU6I5kY7YlJDRuy44w1plTdeb06QCn2tYk3ypGFWJVVe3/iXqxyxpTk+muQpGm6aPrH6MpMDiZb0u8JpwCZfmxhdLexPCdMukhwiGpHdHYmdPTnH1z8W7Jl4sRQrwoaANEiouMu2YEbAVShCzKLVFO2tBpklMrk/TPVxAg6tYQzVqSmOgzHQGOnvmIKpVxOhgs0vPjzMgL6Ey55IND3EwVYkl94hoYSHLJTa1PX9xFi4J12OKd0rZn0zy5clntqiwpnD9i+DQg1PFOcWJyr8EbAj8L90y3CE5xMsB+5izvp6WVavReS/5l7BBkNc9enKC1sePuVE2HqJA6mXncx1h9YUBiebH1FYKxR2fOT1vIv7wpNhhCibvz+L8aw270N5AIZdZw/8vlADRNpL3no1DRL63wsbfVpwxbG7EdX1u/W3a7BezwZUlHxJ2Vfn28zowNkTbXUkkFDiHQ+8fVNYIJoEo/vZ/Pf64m4PX+7eLvH7yG/mWzKYMXAMDL9tP9HU6yNfaPNTsi0PDqNMp37ji0ZjnstJUD5YNnuNsAR2/Y04eZje8njKw1gG4ZaZTh9lSIu5UAVtC+DgXgEpn7dN/KbPwft3YCK9kY0hBeXly/NSIN/9NUXKx/rr1TVeG9JWnzwydoch2VrgrqSIT3AsMqFKLdMl1ReHhUTbKq6tRouF4wMNSFj2kQOEwtIkPTmjtShvrBD5Ed9ua8q2rZFsicU8Ofhg8w3qnniv7ty0jA1mqMwgspo7ytS0fVVwOve8XD8R8WsV2X2AYYDaqY5
 c63Zj7De
 lCsE1u1DoK4VtbuBLwZ/euDs6bq5zf4QDJJvlIDRVGbhZX2UZR6tWOFU7otyKm1/G4cAATZZK6Q6dPgqGHBED1tLfQD/YXutTCjzfHN4+oNL7ax0Qy9ri0YEFtV+ygTPzhzo8eM9itT3OnhZjWmosAWLBRu4Z/H8hk0xD+LfuDp/UYb39DHg9r3qAtj0QCYgBcA8GDzyzfoHIfPuoin8cDv3lwXtg5jk2Ye3pTJr5Xkv08XtvhAheSAc2SiRmYIFhDmIXa5MFMsF6vUnyxBI7SNgkdPFmriQ+YK+7e37HlfZEYOEh6xM5YWXH1Siy01puaCsuuxlmGuXKuq+alb57GP+eHFqd+3SDtNUDJFBSrIS2RvJ5uWAMxep3wj5dctWq0tftoC914bibYZDqky7A/w+nmhLzzIUGFeOVveaKE3UpBafpJmJCL8M2hNCqIoquSTPi1fwYjcvW9oeDjS7n7olHvh+Tofd40j4ALAcBa86dOLEdlmkBvSJnd847FgPbAVMusATFCr9iJkP39YwAFSe95vc40gVhIk7c2CVNqEgOHp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 10:40:25AM +0000, Brendan Jackman wrote:
> The only reason vmap_range_noflush() can sleep is because of pagetable
> allocations.
> 
> The actual allocation mechanism is arch-specific so might_alloc()
> doesn't work here (what GFP flags would be used?). Hence, just add a
> comment.
> 
> Also note that this might do a TLB shootdown. This is not actually
> sleeping but it requires IRQs on for x86, and might_sleep() incidentally
> serves to detect violations of that too.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
> Applies to mm-new.
> 
> Changes in v3:
> - Added note about TLB shootdowns and x86.
> - Since the comment no longer fit on one line anyway, also be a bit more
>   verbose in general.
> - Link to v2: https://lore.kernel.org/r/20251209-b4-vmalloc-might_alloc-v2-1-2462ba26ead1@google.com
> 
> Changes in v2:
> - Switched from might_alloc() to keeping might_sleep() + comment
> - Link to v1: https://lore.kernel.org/r/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com
> ---
>  mm/vmalloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c548167d6123f6ec66bf798f20eec..be4e5f2566a4490d45de29568df538b7c8515b01 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -305,6 +305,11 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	int err;
>  	pgtbl_mod_mask mask = 0;
>  
> +	/*
> +	 * Might allocate pagetables (for most archs a more precise annotation
> +	 * would be might_alloc(GFP_PGTABLE_KERNEL)). Also might shootdown TLB
> +	 * (requires IRQs enabled on x86).
> +	 */
>  	might_sleep();
>  	BUG_ON(addr >= end);
>  
> 
> ---
> base-commit: d0a24447990a9d8212bfb3a692d59efa74ce9f86
> change-id: 20251208-b4-vmalloc-might_alloc-754a791e4e10
> 
> Best regards,
> -- 
> Brendan Jackman <jackmanb@google.com>
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

