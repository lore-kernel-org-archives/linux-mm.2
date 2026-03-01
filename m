Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10331FD0055
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 06:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1102E6B0005; Sun,  1 Mar 2026 01:14:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE0F6B0089; Sun,  1 Mar 2026 01:14:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFDAD6B008A; Sun,  1 Mar 2026 01:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC1716B0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:14:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F3D71404EC
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 06:14:54 +0000 (UTC)
X-FDA: 84496480908.12.AF1F3BD
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9B449140007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 06:14:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Btq/pRYc";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772345692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SxXckReq+HlnydNzXLK+XIbpIQhFrUUR6NTgAKyiaM=;
	b=FSI7DCGroAkI6DLjj2p6EXXb7/XqWV7cvcUmfb179BflucEPUdGl+jvsK6kAAWMPdGlwQ9
	FY7i4OnX3IiWYk1M9wjCBSZb/92CU0eM5Gr98V1qDsuOm5LT2o5hY0uKX+KFvWbINSq8nf
	tW7xkAhlYcXm782GtETjwVb5dV8BP2k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772345692; a=rsa-sha256;
	cv=none;
	b=mQDXFF2k9JXuZa0+FW1hE1MFlXpabRp1pxK77FvqOPIvhewe2BlwKXFBWP8wv5B8/UKVp7
	IDKOXJzqN74WsLJvBtgyLicO0UsTG1HyWF1IpUjJYKEiUdlRK+lEfjQKp+7rys6NUMF4Rx
	FUCAayrZ+YzNhwLf/Tq1E0GYLOfzYx4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Btq/pRYc";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-896fd2c5337so36700116d6.2
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772345691; x=1772950491; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8SxXckReq+HlnydNzXLK+XIbpIQhFrUUR6NTgAKyiaM=;
        b=Btq/pRYclXgKDBbRuxYvPPtPNzoLDIaPYhRZIQtVNbkVfI1vtXshNJwrUizCe/RBuC
         OdO/q09JxQK3oyevRnQiw5QrMSggnLzfEwiVI1iIIOZ7aLBiDXCgJzQxas+AI9Ojbkb4
         8lyFUdZy8Gq9af4yCUhD/8z8vSqMPa23eSRxSf4PmcdGiscJffGneaQzOX6sqNQ5Q+Nr
         ciBvt3ItHAdSywiDZ08l7EeiSr0BujfT64KSoU3oTgzZjhYs9ot/eAuGI9e4UEqTWapb
         ZKtcLFTWt9iRIxHHABufUpCzVR+m7RMSLrX9nlgF8ICFlqYuXu+vVOmQRala/tm1Z/WW
         DLlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772345691; x=1772950491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8SxXckReq+HlnydNzXLK+XIbpIQhFrUUR6NTgAKyiaM=;
        b=NYsDA7qtZZMl4QXbcSE14p/Ysv4PQbgDdlboIQ4kPpY6CgZZwDDYu3GIWpEVyrJwvh
         FIHoIm8WrXpDMn8+jswjy70GlSus1T+vEg/u3CiQqbb12GAzkdy6xc5cpPlRoKyI5Kkf
         L1eMeVs6NisHOMND0gt0KKQdwfITzEVbeDF2sfyiYI2cgxx5Wpb36WdjaWJ/yJgcCbmN
         70ADOQNO8DEyIAXJswaiKmjMdPXtlxcrwdsWQISiGfsHt6lg7qfTkAVy2DtNdPeFRSLW
         oLG1bCCjKTYFM2woF6I7qEYU1CgNog011+338WfBjBk9UM8V+BZsFNR4yOvuV8l3M+SD
         OwMw==
X-Forwarded-Encrypted: i=1; AJvYcCU4pIK6S/OjOHTQXj/C52kbaaViv+kDGy/iox0wz3xk9cU9fsO68SIX36An/jO74tu/cxfNf51j0Q==@kvack.org
X-Gm-Message-State: AOJu0YyDhpyEcitdNmFJy4eSg8RhvaCRzXIWccqqhnRPzxzdPoPBa7oR
	bWTL1O621bN72ocKiMP8MkLFBJXneBwjRenoLEnlqwi2kjYnbZuk0iXsFTPs2L+idKA=
X-Gm-Gg: ATEYQzwplJhK/2ksjs5Y4X34HWWwa8K6id5RDu0L3liQTazKcIKASl08wNzjcYKUeDm
	RQ9q5BuZrqEkJNx0MnTs91Ee5MNhrpvmOngm2zyOhRXyC4/yO8cAVL5XUm1ofDCknrHj030TDJy
	rYAllnJfn7rMudHk/FbE4spaWFWG3i0st6z667xqDOVFz1IBONYpjZSJVes1n7d8yRdAFiCEF9G
	CPakeusqz6Wz3oqcX3hjUz53/fO05CZPAInjDt8GJgKpccP1y/DbPSd3Ty5IQrSOCSqZvSIpA+x
	G1iFQh7i3VnAMdmWY1CgXHvXkg2kLOUKgwDugdcJKROreYP6FcORn10xro4nWJwZfc649tlridS
	JcjD7gcHnl3GAFJEsw7T0uSqe16s5lBk6NY53+kQO2yBuxIx/LZSBg8UA+yEAMUh3NPCM8yC9Jx
	XrvkolAkXd9+4gCjucwxHf8rsaHu8qoy3lpWBr/KutHqCbLVB5r1bPV4+jNFP7MU2tVT/F0MawL
	r7wsrrZ3A==
X-Received: by 2002:a05:6214:230b:b0:899:ac2b:6ddc with SMTP id 6a1803df08f44-899d1e6e8c9mr125086616d6.62.1772345691490;
        Sat, 28 Feb 2026 22:14:51 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7376732sm77099556d6.24.2026.02.28.22.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Feb 2026 22:14:51 -0800 (PST)
Date: Sun, 1 Mar 2026 01:14:48 -0500
From: Gregory Price <gourry@gourry.net>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCH] mm: bail out when the PMD has been set in bloom filter
Message-ID: <aaPZWOJOS0cnbIix@gourry-fedora-PF4VCD3F>
References: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B449140007
X-Stat-Signature: ud711baft8j71fgpmxiw8r6s7mzmddfq
X-Rspam-User: 
X-HE-Tag: 1772345692-562815
X-HE-Meta: U2FsdGVkX1+vhtfuK179MHho5dLAMjMjC8s8rqTuXvXc0eNG33UFc+Y0e0bHjOZyHX0cMRtYijiDCAynvJua14r6ha7fFEcrz7vIq3In5KFONmEocRsFqdkY/s2O79gEJERzEKvuLhD/TyZtRpV53BY5WuQvNjwWuPJ7KN5me+SPMdYMFOMn9vAaSOJfHJ+7qVNXavvMV++waheiy16d5kK/KuU6IiNLRIzRo+COgHEBSzCiUgDBCLZfwrhkuf7hUaQQwtOzzDV91zZl3SzLMLhSLWWr29KsLRenyWwv8ivL813vKeRFCE/URFkEzVNwmaEyzxjtO94/DTGC+NFVWj6WnrihLWwnTmiZ9ERB4Vmex/5MmmsuVzb7G2pQ2ROJ/BfLBJUQJwnc2+lNvUZkcv7aWE7WvOgaV+0DGY7cVYCHUDpkV1OmRuCq+QcpYlxWuwsxgavor4RxZhVhscJjDEaUIkjFl8jQogH5pfl/38CqxAYk9WxN8Zf1M2RDObMIiQAELn4M6GgJfzypjxJguEEdb7I1FfnySNV/bJ6OhdiTFmi3FqMh3C+RD3fM/JhhIj4THppie/x3i2NfXLp/95yFXDP+ba5B5V0nKm9CJKGfED4waguvBHN8D3HWrgyuI8lJV7Fve/RITZPWPB9JjrYSc5fkZ5BpVQ0YprEMybLg1CbMkM+Pf6J2VbNHt+1jAbLqZ4ENo6ZGXhrhu/qCI5Tsq64dwQ65N9mUWanq+SWvdDUZ5UFd+q96XTpFnv7V6VuR3kC9Q8Rtt66Qhwhy6AkQtigzyPfTwGPuL+VV3PM//U9DUxk188f5lnb3UCK+vlCCBLWZEgP0GB9f0jLsaMt+F57OuIA0rHjvqiTZGGx4Z2B7s3/FxQUeiYM9iA/bApNwTU0ymkSDVR47cRFz2udpqmNuthO8JcS+YMpXnOpW/QOWO5A9o7jqN/anQPweieJR7AYCpg4k8CSZQpC
 6pASL8JK
 B5NDJ4WkusecEai6PFLye5lkSpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 03:52:50PM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> There are two reasons to have the recorded PMD bail out from doing
> the following iteration
> 1. It is worth of doing such a trade off thing in terms of reclaiming
> efficiency as test_bloom_filter only consume 20~30 instructions in modern
> processors(25 instructions in ARM64).
> 2. The PMD needs to accumulate young pages until aging happens while the
> new arrived folio reference checking under current max_seq refuse to do so
> which will affect carrying hot PMDs to new generation.
> 

Can you explain what the intended *effect* of this patch is?

Why does the PMD need to accumulate young pages?
Why does this patch help that?
How does this affect carrying hot PMDs to the new generation?

What concrete behavior did you see before this patch, and how does
this patch change that behavior?

What is the user-facing effects before / after this patch?

Is this fixing a bug or a tweak to the MGLRU heuristics?

~Gregory

> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9d900be478ea..e50e98291d0d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4227,6 +4227,10 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>  	/* avoid taking the LRU lock under the PTL when possible */
>  	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
>  
> +	/* may the pmd has been set in bloom filter */
> +	if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
> +		return true;
> +
>  	start = max(addr & PMD_MASK, vma->vm_start);
>  	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
>  
> -- 
> 2.25.1
> 

