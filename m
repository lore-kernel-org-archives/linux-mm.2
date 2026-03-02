Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B03EDEB362E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6436B0005; Mon,  2 Mar 2026 14:18:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07E6C6B0088; Mon,  2 Mar 2026 14:18:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCDE6B0089; Mon,  2 Mar 2026 14:18:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9AEC6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:18:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8ECC71B7331
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:18:35 +0000 (UTC)
X-FDA: 84502084590.30.4AF8C9A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3E18C000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:18:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QSLTKX8E;
	spf=pass (imf10.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772479114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jtDyJ1DNghVCC4Cyf0GGPlWwN5ZBkZX1JdKXeNO+zdQ=;
	b=LlqtkOz6SHM68x/5Zg0V1UCNjKSV/9Ym97hWXVKS/9TJCs8o3oZ7YXG73dQVVJKI8GZf+F
	kPsoi4k9LNho/09iVQ2GhZ0geSnBVn9QZbV5pvYLVV+zxOzWdU5R2X6VkT8lEY9kaQZX0Y
	FH6sI/Z36tbS4l8z1rGiwTn3/YTzKj0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QSLTKX8E;
	spf=pass (imf10.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772479114; a=rsa-sha256;
	cv=none;
	b=nmsBjaurZblGorxOUzi/YA/lwe9ncmGHs4llnfhTqzXBwFZU1Ha3arJP5sPtgRsFtMU3yi
	DV1cyQ3/YuIhgvRw11crafEBzkliDcdSrpsIAu0i1cQZ6rCc+9b58nPR5YM7A57O6OEuJj
	RtnHmh4s145d7b4yLLKkp4NK5m1NvOY=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ae523d54d2so9565ad.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772479113; x=1773083913; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtDyJ1DNghVCC4Cyf0GGPlWwN5ZBkZX1JdKXeNO+zdQ=;
        b=QSLTKX8E9nP4J+DYKf5A41XO3UVHFTN4ZmkvXLuzFgMY8q247Ej6v8Lj/B4aECfZA/
         X2A3fcyy2zg7qkQA0JjfcoIqKu/GpGka2QLTkFU/PLwcBrgTh1aZ/J5/M6H9zgDeJDKL
         yFVpt11LD/05s8U8tNQM0p17FNCy4GCIHenTgnBbsaVCGmmjVOeb6goXLqSGYVTpRQc0
         dvnyqdLogjo39+bkyFSZfhxKJPeof4p002yVUgqjcgAwvebKh3T329nK/I2C1XRM/IxX
         1EM/LmZMBJyYCTLHs3C0r9L4Y5sMLeQ+G6dC1oZdF9cGBSgl/vnNdtjU/lUQ06pHTzMh
         LzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772479113; x=1773083913;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtDyJ1DNghVCC4Cyf0GGPlWwN5ZBkZX1JdKXeNO+zdQ=;
        b=SmK3vQqSZgLyA5KZQb0VxeoiS1jJD2qHUX30zEVLVt7yr7SiG4VYRxE4yfCWhzIthh
         HJwXx4JlwdLYBPi3QWKexpNepCQ1oXCUgVqRRDnyP+f4+bwQavecS9PpdjeE8XcN84fj
         v6KtPK1/7eUAtmGYhWS+sMqGKjAWjEEXXuX5y9I8thp6eiuTEeW6hF2QgbLMZujf1qaK
         wJ4EboB3A5hIHECjja+a1QFCtLTW28fX4Q6R/HrxXKCoaY7tuo5mwApyKymFL84IHfXD
         d/u6tynnGfcriHKmo4DkU1xfPzswQQsbW6l74JtNgC3Xt4WDNoEPWXIrgx8SbZilSHzN
         qsIQ==
X-Gm-Message-State: AOJu0Yx/y5h63uTBPu2nYEMPcHlAy3bAHXiwhzx8ueDN7FK/3vwThbVD
	DaYKWiThPn8i0L25X8bHPEYxQg+LnT+9t80IqzFOWXLiyRkYcPca7YO7uK159JL6UA==
X-Gm-Gg: ATEYQzyg7X0apkii5qhdvqiMdcqzHKniyyKPwPImhRaOsJb89tZ2cb30bzQk17JPjzK
	vq2G8+qpmmCLYFc2Qo4xcgkfGftb3d0q1SQLxy3AbCGHUkc68thIsrvjkM9SUGbf1lXb1zJKxBc
	IpRmLMMDc4Hiu2jC/jeqQrg6hBawBGKaG8f0DoimthpeuNoPcNH2TRHBxRRD1FOKxgT27AHz9v0
	kvnztwqX2YuwefM6kPsUoMlAKPNz1vvMOv5tgJRH4NWDDRp2B17Q2pDLjoqizcsTBSTBLYQiAOV
	VVBx81kTmpZjWB8VbyAJroYZAnuVfvTY25OfUhw8NtEFTnGslL1OHvR8drSHJEYEs8Gt21tiEda
	E4Ddo4hM8l6kgtNu2jEssyISiiD39tHg1oOgnRbdVsEMPBiYpNSdynj66qA+AZbCbHykRQfetG7
	78EZp/NL8ae26AGqQOL+6EPEbAO91BX3N3maWxgRbKufxQY0dNwLvaqgD4PDbJhXY1BjN36ilVy
	CA=
X-Received: by 2002:a17:902:c94d:b0:2ae:57e6:616a with SMTP id d9443c01a7336-2ae57e66a09mr2293425ad.2.1772479112254;
        Mon, 02 Mar 2026 11:18:32 -0800 (PST)
Received: from google.com (206.238.125.34.bc.googleusercontent.com. [34.125.238.206])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b48f4sm146719015ad.13.2026.03.02.11.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:18:31 -0800 (PST)
Date: Mon, 2 Mar 2026 19:18:26 +0000
From: Bing Jiao <bingjiao@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: restore allowed mask in alloc_demote_folio()
Message-ID: <aaXigujRj2llz1xc@google.com>
References: <20260302070351.3465439-1-bingjiao@google.com>
 <98480065-e988-477f-ba37-f9521e4aecbb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98480065-e988-477f-ba37-f9521e4aecbb@kernel.org>
X-Rspamd-Queue-Id: E3E18C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: zis9ot3ddygurhanzmja7xendmdb4mh4
X-Rspam-User: 
X-HE-Tag: 1772479113-375749
X-HE-Meta: U2FsdGVkX19tmshR16yzTizjU2OGP/p5vxN0ItDOnd5bO03WpN65DlGl2s00Ox0hRtYr8W7Z96FwmHa5wxpxqWa/nGc0Y8UVQUqLjLn5NvBw5M/2WDWTYnVFa6u79Ng272OPyRLayNk795WIaUKnf+BDYdvi3q08NJ+ga4lTl0XQrJRlGzO/ObK8umwBckHXXu6qkyPJ7Hy3Go5K6lmuSs/IPw499RINyqynBY+F9HwSpqnpUjjVZrAIk2gVFAjtfzgNB47WgA3PbFCcAmcPktUGv1kktsgWfHesCGQHJn3ncoX9FVQtyOZgrwrbQOPzwCPjcV8WsF+xUuudguGL8Ox9u4q2lopU7ndqqyB0gS5JW/bEBFu0jKzWFMzHhCyDxUXA8RvmJsyAtNePAJgMyYHagYU5bltQeb3c7xX5WV46b6L7I75+HzvJeYzLYsciExIC1La4FvfLcEsdt4WrNwYq0zPBF7SPFxVEHnUaJz+2m8xxlOIY2wxjZbsUjOjGZZ6KXK1GJjQwpxWijpGTtdPcGSrqKfKhW8wvD77lref1xH419Np+IRl/7pE7yKvL6+7ZPuF4AwEKK0Ct2Ct3btGuMVOtDsiKrzn658ClAHZBKYtOfvAllnOnT7H1nXmHfXeCs0g7CrfF/edd+tz0Hc8CZaZkSFv+q9xIhZjUce7ADWE8mb1kqYhtFuDKSQPzm6yeiHUTvKLVPiuPY0WjBX6UUV5F4qG0asqS1uK74HPjIxbCCKIaLkGfXDSMxao1JfHJ6bOUzNKQ8UFgP8HHuLogr34VmCEa4yplx5GJme6xI+mwfdHjelPQ6PlV/o5/6OrJKvItrbG7tmCeiN5YHv3ASwcFxqRLFKzDInDizUqm+sXLhRG8G7EgIbt7sROZmDmv/fAzA2ZrcablvF7/KeYXKxTq6aeGU7d7LxqERUT5sYPxZkelTRlG/gBG17a+cvpTk9SNcT50Yj4MxX/
 fn7WlFMZ
 abV/91fATzp9LN+OkEFmpVKgOOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 09:00:07AM +0100, David Hildenbrand (Arm) wrote:
> On 3/2/26 08:03, Bing Jiao wrote:
> > In alloc_demote_folio(), mtc->nmask is set to NULL for the first
> > allocation. If that succeeds, it returns without restoring mtc->nmask
> > to allowed_mask. For subsequent allocations from the migrate_pages()
> > batch, mtc->nmask will be NULL. If the target node then becomes full,
> > the fallback allocation will use nmask = NULL, allocating from any
> > node allowed by the task cpuset, which for kswapd is all nodes.
> >
> > To address this issue, restore the mtc->nmask to its original allowed
> > nodemask after the first allocation.
> >
>
> That would be
>
> Fixes: 320080272892 ("mm/demotion: demote pages according to allocation fallback order")
>
> ?

Thanks for pointing it out. Will add it in the new patch.

> > Signed-off-by: Bing Jiao <bingjiao@google.com>
> > ---
> >  mm/vmscan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index cbffc0a27824..b42abd17aee7 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -985,11 +985,11 @@ static struct folio *alloc_demote_folio(struct folio *src,
> >  	mtc->nmask = NULL;
> >  	mtc->gfp_mask |= __GFP_THISNODE;
> >  	dst = alloc_migration_target(src, (unsigned long)mtc);
> > +	mtc->nmask = allowed_mask;
> >  	if (dst)
> >  		return dst;
> >
> >  	mtc->gfp_mask &= ~__GFP_THISNODE;
> > -	mtc->nmask = allowed_mask;
> >
> >  	return alloc_migration_target(src, (unsigned long)mtc);
> >  }
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >
>
> Maybe we should just not touch the original mtc?
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index de62225b381a..f07716e5389e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -985,9 +985,9 @@ static void folio_check_dirty_writeback(struct folio *folio,
>  static struct folio *alloc_demote_folio(struct folio *src,
>                 unsigned long private)
>  {
> +       struct migration_target_control *mtc, target_nid_mtc;
>         struct folio *dst;
>         nodemask_t *allowed_mask;
> -       struct migration_target_control *mtc;
>
>         mtc = (struct migration_target_control *)private;
>
> @@ -1001,15 +1001,12 @@ static struct folio *alloc_demote_folio(struct folio *src,
>          * a demotion of cold pages from the target memtier. This can result
>          * in the kernel placing hot pages in slower(lower) memory tiers.
>          */
> -       mtc->nmask = NULL;
> -       mtc->gfp_mask |= __GFP_THISNODE;
> -       dst = alloc_migration_target(src, (unsigned long)mtc);
> +       target_nid_mtc = *mtc;
> +       target_nid_mtc.nmask = NULL;
> +       target_nid_mtc.gfp_mask |= __GFP_THISNODE;
> +       dst = alloc_migration_target(src, (unsigned long)&target_nid_mtc);
>         if (dst)
>                 return dst;
> -
> -       mtc->gfp_mask &= ~__GFP_THISNODE;
> -       mtc->nmask = allowed_mask;
> -
>         return alloc_migration_target(src, (unsigned long)mtc);
>  }
>
>
>
> --
> Cheers,
>
> David

Thank you for the suggestion, David.

I agree that not touching the original mtc is a better. It makes
the distinction between the two allocation attempts much clearer
and avoids the side-effect bug. Will update it then.

Best,
Bing

