Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3482CD98E2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBABA6B00D5; Thu, 18 Jun 2026 05:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92996B00D7; Thu, 18 Jun 2026 05:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA91B6B00D8; Thu, 18 Jun 2026 05:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAB236B00D5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:35:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF02D1C4BCF
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:19:01 +0000 (UTC)
X-FDA: 84892484082.25.04E20FF
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82B31C0004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:18:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="W2yO/Mw1";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/sZ73Azok0J4GtDexU4YrmhCQdZ0STaJkzfrXiPb/A=;
	b=2kws0PsDzsboEWWDc51ce5cNbzXMUZB9cUgR6eJdr6dS/TGraLe/ITDgqgw3m+3o43sziG
	rP69zHNitExXiil2BojbwAoPuvX7qJyq6RdvlnckBb6etD0eC20C8cC/ZM6k5l31gZeaJ2
	1F7Q1ILSny0ly7VfmJOwkw7vEZfhlTs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774339;
	b=zS3e5JOpXBiftEI5ohbqGiiQ0cw+AB2/Im/73AS/luAL/ro4Pl/XqLa3Sn0ebQcz9b2+7b
	VtQSlKLNFJ13KPhHDSRnMH16FJq58U6KYUHplcR6PEiWFroZ16+oLILsy5O9LhkazJUFeT
	xoGmBF0F2R7mffLv0MTNG1WI2lTuOjs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="W2yO/Mw1";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-462627cd5daso34788f8f.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 02:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781774338; x=1782379138; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3/sZ73Azok0J4GtDexU4YrmhCQdZ0STaJkzfrXiPb/A=;
        b=W2yO/Mw1n1LTD3XxpuAOkdS+UHz/MUSaY3VLyfJbvHiwMUFHRr8CWPHJRHlBdafmqj
         0oZVksa5KVf+BdqOj/yAhpS4Gf0t4I0lJ91uYMdAVbYPG7c9RqXhzGt9CvMqw/hW/A+8
         jNlbB/D5jAfEPJpXT9OdpeVjEmDeMpRlRXlTuAQhOIUG0hs5wEA6cYlIWBe/IEU7JcWL
         blB8RQCo/4B0PMJqwWuGX6uKsCH+PKqNqfiQUCAagB/U5NEakzQRsj6jmY73fLnB+neA
         hMbbsHHb19ImPBUU6X+43OaRNVN4NLGWnz1EmIoi+kPNfo26NfGkUa02NFcvbJTIRrP0
         bpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781774338; x=1782379138;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3/sZ73Azok0J4GtDexU4YrmhCQdZ0STaJkzfrXiPb/A=;
        b=cQKNpBGAWa9MKI7K6OiQzn+mFBxk6i2mZoUlvgqdP62nuXr7XidU/nW8tRRtIy2pC7
         4WWfvgvLDydd93AWqRkehGf5wv6oXnFYZMPqEOPUtZLDvEpHlI2YO4dsPnWkAsl9gN48
         0M8AVxWlJY2s555WaggjkkG0WR5lH+fn61Tc1HQqU7JSurOyQ4y8CxV6BhvCst04MyxV
         Sla0Zfh5Jl0MJWmmDpGsL3Ku2bhysKgaXL0aAX3Qo7z/sEIaf+8LDx5nJtUkxhW3+8BY
         bD+7VBwwJL9jvI9rpZ7/HytRnKGExDXdvtLV34+mPu5os6i61wnB79p9ATMb9X4mGUCH
         3rnA==
X-Forwarded-Encrypted: i=1; AFNElJ8wTRgz3fQBSBKGs/Wsm8qc09KrFwfFcRynGZUtSv301uJeKyEN5vjoUktxSH9hDCuW6ED8wHxLwA==@kvack.org
X-Gm-Message-State: AOJu0Yw5b3FXdqnQ9NRFUSkiou+aI88Dpqd31pbrxCrKtE8bFFVTOJxx
	6LuISmGNeLBdsxh71BWbykddvcRd1NCz46vGoRrYVDPBo792IqvfaCLytjNSRK28MKg=
X-Gm-Gg: Acq92OHE3iaGq99f+og65SM8EmvC9jJBx8nRIj3zkRnffWGM64ZoFdQqqF8FUjAsivw
	r+xcW+PZ+rfxVf6aSrS/oNSfK4/9iFwUKI9D6/qfN1GCZij/dEkLkwU6EPyvRdoRA15TG2MccvT
	9KOHyZQ1cmLdfxrpM6+M+hED4NldUzAQ20jJ2ErEapAh35WaSV7mYw7p13uWSLR0pfnLBxUb5M6
	mFQmftyQjr3mEoH8W8OTx9Rh+c4plTw/BhzSVItSvH+m3AmUuxbkNbj/l+4QW0Fy0ZYPn2/sxgg
	FnkRmmbfeowV81y57gDofMdsxqMrPv3t7B5jJCWzKhuDetnjZ9AfJTtEB7dSR4+KwTgdjGSCjOX
	R0wclcyQB6/3Boz68+3A+xXe8d9cHdJgmq+1csfIw3eEyMgrlWQgGA7zzIZyl13wV4XFvWEL7lJ
	7SkRjlWsMssG0nI1VS7w==
X-Received: by 2002:a05:600c:3b18:b0:492:37b7:6071 with SMTP id 5b1f17b1804b1-49238230e23mr22505245e9.2.1781774337736;
        Thu, 18 Jun 2026 02:18:57 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa97a07sm393533975e9.14.2026.06.18.02.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 02:18:57 -0700 (PDT)
Message-ID: <65f68f41-226f-43ae-8bfc-b9a321bfe5fe@suse.com>
Date: Thu, 18 Jun 2026 11:18:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm/slabinfo: fix total_objects attribute name
Content-Language: en-US
To: Yichong Chen <chenyichong@uniontech.com>, akpm@linux-foundation.org,
 Harry Yoo <harry.yoo@oracle.com>
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
 Hao Li <hao.li@linux.dev>
References: <96556748872BB47E+20260612071359.649946-1-chenyichong@uniontech.com>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <96556748872BB47E+20260612071359.649946-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 82B31C0004
X-Rspam-User: 
X-Stat-Signature: nw5qcohydf6n1wb4nhj9br8j4nehf71d
X-Rspamd-Server: rspam08
X-HE-Tag: 1781774339-789451
X-HE-Meta: U2FsdGVkX18xzjgjpQqnQOUCcqZ/+uJSaJERzGiPteoJHbjtZj4/Lo3etSHEMftQ15Apa16/obzlkBeZ1jbRa4RlqKSxb5xy4w8ur56dcRClvFXPZctaWplaKgDHWtfpqyRetI4if9MoCrlS5t59BnzHRe15juUrw8May4nR8hSqZCPOZWS6mTl8yd9HPniPE1XxjBgMyQVeV/OOqUo5DBxGtilFTImTgJ0ea5oUr9F4M3D/aqrTUSTclbPs5qiNdS9Mwe+A5EspVyMeZjzmlHVpq+COe0Uo6BcFzQmngUIioUODG0h51VBPZ1vZbZVYCN71CkQVVPXDo98ugv/9ztmWAzl/K2PYqLe/GsOjv9Vq6uSqnDXSncwf2m4LBTlkbzmwaStLCbliv0CKXhCGXwyvWkGyxwKQ+XEAQZed+NENYQjTv3JBdqmxvPb1fqeNc4MlsoEoYUQdLGEtR+3yslPjFpRnGMpPPrxC9t5SvYNbiQUbU2t6fF9iNv73po0RNeO6maqfPBGONeUaWXjp5WLNgI5oGFjRj/PRgd+Gfk/Xl8lcy8CVLuW5/CTjQBr0sf2Z2X+8F31rMwU75RIucW3u0/Mk0NE1wEdtHTMeUEV0CAvA3m6Nfccmv2CTIbcv4j2zy6ToW7NRiWidT8YtstOBofFGqco1WTuYIgooEbKCXBDFH1PTT5RyjZWImSh87QLF+FvKCmiD93ddMV1NsWchW+P0HNxoz+ywY9CzvNY4+MOTfNKhIarEbxMjzs8naN8W0U3+cWxBeis4oFRAA6ZDmCpYlW3XgEpO15xggER681IKyWfuH/k7tZnQ/t6UWJNdjYqABs9ncM0P8XoSeKU8PVzVu29eS7GrM8tWLhGkfS0EFBjqvcL/h8S4o95Hu1KsP3AjBuv4ETfLsBRjLiG9ZzWD6ZiwRixKCmoXTj/7HI6PlXEPPLcHJ/aakj4QN71uBA7zEUkgZHeY6hG
 h5qgRDEb
 r/Fib6xQfbCHcNwt6LhfvftR1GPKHgsCorjWIOOF2trJU9BgsifXp7xZKzrT5o5cGLYQ1fXDzGG7U4ENUT5Zzdexv/ZDIfy7mCUo2eDCumZwguNCrsnYeGpsgYnL4snB2QIVhWGjpUo3JEwRxnmI88SAQMZSvbCoifCtAbVK6fOJJ7/NIiCD2zl112Jt/7Za6gUOVOByO8sHt75R7EJmQ+Fjnba61qGQBuLPr6aYaLqfoQ/ryXxTKcYlFVX8hqGdgguvjd4tios97FaIhbb0L02YotqKSkkKJaWJulGWh5NVlO4VA8DZBaXb162eDBObQh4Ylh2W9wQUccrcfkLqg/ZmY43upEuxleHGrr8R4B4hhMKxvSj6XLt2E2LUQGfZ/yvU1wQCFwOX8kInRhe45ZZdm/RzVBwYYFpyMcdpQ2/hIB+kzPFlRHCdW2w2asGUzVqdfF39OYDY+yS34NLTF0QgRgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 09:13, Yichong Chen wrote:
> SLUB exports the total_objects sysfs attribute, but slabinfo tries to read
> objects_total. As a result, the lookup fails and the field remains zero.
> 
> Use the correct attribute name and rename the corresponding structure
> member to match.
> 
> Fixes: 205ab99dd103 ("slub: Update statistics handling for variable order slabs")

Huh, it has never worked correctly, since 2008.
Applied to slab/for-next, thanks!

> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
>  tools/mm/slabinfo.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 54c7265ab52d..f4077746d6df 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -33,7 +33,7 @@ struct slabinfo {
>  	unsigned int hwcache_align, object_size, objs_per_slab;
>  	unsigned int sanity_checks, slab_size, store_user, trace;
>  	int order, poison, reclaim_account, red_zone;
> -	unsigned long partial, objects, slabs, objects_partial, objects_total;
> +	unsigned long partial, objects, slabs, objects_partial, total_objects;
>  	unsigned long alloc_fastpath, alloc_slowpath;
>  	unsigned long free_fastpath, free_slowpath;
>  	unsigned long free_frozen, free_add_partial, free_remove_partial;
> @@ -1263,7 +1263,7 @@ static void read_slab_dir(void)
>  			slab->object_size = get_obj("object_size");
>  			slab->objects = get_obj("objects");
>  			slab->objects_partial = get_obj("objects_partial");
> -			slab->objects_total = get_obj("objects_total");
> +			slab->total_objects = get_obj("total_objects");
>  			slab->objs_per_slab = get_obj("objs_per_slab");
>  			slab->order = get_obj("order");
>  			slab->partial = get_obj("partial");


