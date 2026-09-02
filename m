Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D8FC624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844516B00EF; Wed,  2 Sep 2026 09:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C476B00F0; Wed,  2 Sep 2026 09:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2E26B00F1; Wed,  2 Sep 2026 09:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B96A6B00EF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:57:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4509A0231
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:57:40 +0000 (UTC)
X-FDA: 85168975080.10.52F51C6
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0A8901C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:57:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Id7j1K2d;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYK9s4U82KWdve9IP4Oc1+xC+XsNRFYBGYpYPqFEM9U=;
	b=ixoR50psb/8mAI1iQQjTXMcG9nCZY4pkkHJnGjaWsPj4BeIsFiFwypqDCRLw7vEolmacuM
	bqMvhk72oP1aQysw1uxvKlHCiJ9zKQkSh8TdHv+0sePTDWa4w1imf4UYfBcFqjRnzfUrIv
	aU7l1x1CrV5p9cKcATc51CZ5SjdajJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357459;
	b=Ybb5L9z7EHTZHsM76xNmKkIk/lrPLTk2e26oXRExFWLUFHOOhK4LeSY1DaSH7YLfid70O1
	BrtcwIGga5x3bUmyetbOLNCsPHKMiISXWNKRzZbfYEZCYeY9D3ra6EdXLhigGwQI7lxE5h
	UA1PjRBXckDMLIsSrPUkexON4H1Hckw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Id7j1K2d;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c0006ea8eso14529541cf.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 06:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788357458; x=1788962258; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rYK9s4U82KWdve9IP4Oc1+xC+XsNRFYBGYpYPqFEM9U=;
        b=Id7j1K2dsf85Yr9PRO+ROSbSxEDz1kTLMAC5r6+2UHaFROwpiqi9y+6HDkT1MIMBUT
         GHnqQv5YsnDeLHIbMtkUynsB326zzxQESUU02O0Ym/g/NBHwYAaVT/0tYhWefGgNdQOl
         ktoYjXf6H0FuvGOE8u4L6hiIxDvbRh0zsiMofMhsgG5Tovx2fp31UfIXRsT7aA+PmM1P
         Z/e073RTXqdY+m9Ys067nMv8AgGSo/irJ3Iift9bHP8xM9yXFnxwA4oOgE4zEQaad631
         wobZ0elmZ6qX609FjvydakXQOIhfSy997LVZaWksoROclrZn7lu3uMFWrT0FJn3dMpii
         VbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788357458; x=1788962258;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rYK9s4U82KWdve9IP4Oc1+xC+XsNRFYBGYpYPqFEM9U=;
        b=MZFDuotpmEjVaFCLJ8Nmk9VJf/euzI1a3gIYjmvEmci8jkq3y3RF4TlP/VsaVpLRk/
         4+pCYQpqDF833tMArirYa0WMRRIATiOZJuSEujQD3Q4nIDZnAlvTVbqrgA+1oTCYsLMQ
         FojHbJyKbr3+0ESM/GBQUroI6L2cVYCTaHHCWwMjHjjXAm3vn+qyBHc2pS38GHHSrUBc
         EdzqB0ZKTrDTRhokkQ/1VBTeAIXpvHNSCm9CLY2GfKd+V/yGkOr4Tt0PG1IsJsIMzp4q
         xTuAZD796qyT1S+yCvGLdozOfszyolbM5olhsIT/Ib03rR7yxbiDtN06kBSexE5//BF7
         zxHg==
X-Forwarded-Encrypted: i=1; AHgh+Ror8DLHn+wQYxrf4kgBaXd+Fd1RHQpSqB/7ZdE9FqUDAp1TK4J/cxuH+NWX1YzJdymgZ6XqusyRmg==@kvack.org
X-Gm-Message-State: AFuF++lRFL0cdT7IiJMlHierrz2zC6pWRKvp2vXAtm+nyT3cgFY5pQvw
	G/X+2cI2NpX8SKz2eV9WPshnVmYm6eT7V5pkBfKfOGRQmmukz4TOQfi5kl6SKJMLCtA=
X-Gm-Gg: AR+sD12yd07VbwVRDqxuqzp0FnhV7uoL+IGumYft1s6U5aEp5ZZGvHwAsXwi+BaC6Hx
	xVrmrPP3yItyeCbBSDHIC7m7uwIMjaEK/VZOemA5mi/Zm29LFwU4+2UZ3+0SL6g8qQOmt1k1dR7
	xfFT+gUVSyqa1gJH5sZ/DZy1FoM7Y9qb+PxiXyN00PlyeM6HZWlv9u5LrSzEihwax5I1EF5+cIh
	FPouaBY/jHYcrDgQHmrlm0XfcW5JZsm7IdoMm/ZI0u5YOSDEqIog6nP5Jhu0UMTKwgrqKzgTzI1
	M3CKzivs8JV0CdQO0H1BsewOc9KJBqKWCCtz+ba3NdCzyCQbBBXjPsHxQJjBfYF956HBrnlTjLZ
	jfOTh/k80b/1iplwdYFmdQezqedLSNXhhDX8r6vt/xlLVskjvZi7RWfXXE8TOLVtakuhanM8w2G
	aqw6StzfJ3CSsAKAiqyEaL98iVCTADrQjLIP9MSJbfVO1UfOEELBW4rDrHLJurHKrXjFHboNpyZ
	cf4PMh7P09/cZ3kLObM5CQPV98PTqqSP2PpB+Tt/hAn
X-Received: by 2002:ac8:5748:0:b0:52f:f59f:2b2a with SMTP id d75a77b69052e-53036d15de7mr52617031cf.32.1788357458008;
        Wed, 02 Sep 2026 06:57:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530331dd0c0sm19014241cf.19.2026.09.02.06.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 06:57:37 -0700 (PDT)
Date: Wed, 2 Sep 2026 09:57:35 -0400
From: Gregory Price <gourry@gourry.net>
To: Liu Jing <liujing@cmss.chinamobile.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mempolicy: fix div-by-zero in
 alloc_pages_bulk_weighted_interleave
Message-ID: <apgqvt8iIt-a6j2Q@gourry-fedora-PF4VCD3F>
References: <20260902090412.16445-1-liujing@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902090412.16445-1-liujing@cmss.chinamobile.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A8901C0002
X-Stat-Signature: cg6gukeib749tw3bnwoiis6hug4k6ocf
X-Rspam-User: 
X-HE-Tag: 1788357458-66671
X-HE-Meta: U2FsdGVkX18sOF+28R+dABJsOB3f1GMOBKyNQOb53fMFfky7ylSA+qUlwo3rhHFIkcjF/PFXbYVomEgwVWxCaWKEHX4m2f3Y7cyWxd6wZWPBqInk2VJaVMv0l+8o8zWXn7vNDkBHMoMBuC02uzrNCASvmbDhHdU6xWwXkN3ooVN7nPizMdcMq2/YCYcQhJn8T8F/1vDz9KsoaHaX7BuxExLL09EfaERW6nC7JWyPZ9DFX1u3vdjF4eUfOF2dsAnyYjoeTfes7Bac8ISo7tGu8d9OKi7GJWuLcoCWMyMhTrqsZqu2n0b3QXKon+bEJjpaqSMZImQRREoXYK/h+VwDK5dxDW7JukDnaS5iftEo9hW2Zf163EUSlE7UVchMdUadYTaJzW54m1YCYKc8rbidl/OcE5HLJO/fSECiL4XKZs8mG3BFrocjvW2+o0JRvs2uy2YaV6FCoL5EfNNE8BByfwDdGxoPe/aJVXJ5+4c7ly06k00hEViL30S+g0kEEEkVLMrzovDzxQKBfLzvYwqHHYEqA0gbU+UjLZZUbhEB0a1qRMeNDmChcVa90bKZprKfXS60yk1b55sP0iSPKjH3NwVXeQvgWt6UhJV3kUCTflee9RjhFQX08XKLEWG5Hv2hAFfiQVFzdahp1LSlcLPxxkslco4Fdgg7quRz70FBj6ZpL8nAupd56PYFGKpTysZy049jcY6i5AdfjN94Tz48CV2OB2dHdgKPYjQhR8K72Xz3gSFbXxYg2FJfvGop1wid8FgEifmx5XzjKTRcMykwMY7KrLali3IFuAS2CuCXXmel8DDN+FAQgGu6jiEihImiCrDQvcLyDTdrcqyiOofSm4mjG3RGn/liiYvrgmeOo0b2zMk5hIYlVovpyJ9icF4jbcXP/ax7ClwkTdrFEyEJVtqWUgDyrlaAqPvyxcJ6nL2czzK81JsbHixZz/P/Zf/P6kjL5uW4hgiZ/ZBhIdA
 82pvzK3h
 BFsUxkMQvjyqayBhV6FwPaWePFWXdxURvWA85uKFQeXBV41wFK6KihxfnCCCbU44grfd5c4ZMTiT7BqGyeeenFoIOVxkHIcSgrnTZ99XymcaiOntAF+k/pCHdAETosTInAotmFvsIOtx/Ta0/4yQuQK3QkElrj4s7L+7ax63UL6nkw8c0KHCgofZ/jWdZWooXS7pXv+5TuscCm3k1Xj4b+lUrtQKRdKf+oRHqcX5STegPQkkZ4pnU1y0/Io3Ddg71TAnQB7sTQnwFuyKmWH6V6pxQ/E+n06kN9KOskZJGEoTKtFJqqGtuUc2ykC0VEFSlmWlLid7JxoHsQongMKcc0DBMb1sNgvrUrqg5ueLnLkVxAYnd1V/CMFAn6IYUZZkYsLZm6u2BEtOTDBnkW2K7LXS8UHPRt/Him8kecN+UbvFRynuYpWXVraBDYzjHz/WUa0rD4dyBv96WKNrjAU+cZNPr4qLYMDkefGZA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 05:04:12PM +0800, Liu Jing wrote:
> In alloc_pages_bulk_weighted_interleave(), if the iw_table contains
> all-zero weights for every node in the policy nodemask, weight_total
> sums to zero. The subsequent "rem_pages / weight_total" and
> "rem_pages % weight_total" trigger a divide-by-zero panic.
> 

weights can't be zero and we just fixed the rebind race

> The function already guards against !nnodes but not against a zero
> weight_total. Add the missing check, freeing the locally allocated
> weights buffer before returning.
> 
> Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
> ---
>  mm/mempolicy.c | 5 +++++
>  1 file changed, 5 insertion(+), 0 deletion(-)
> 
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2697,6 +2697,11 @@
>  	/* calculate total, detect system default usage */
>  	for_each_node_mask(node, nodes)
>  		weight_total += weights[node];
> +
> +	if (!weight_total) {
> +		kfree(weights);
> +		return total_allocated;
> +	}
>  
>  	/*
>  	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
> 
> --
> 2.43.0
> 
> 

