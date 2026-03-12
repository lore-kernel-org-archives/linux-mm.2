Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6FE1067058
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2B36B0005; Thu, 12 Mar 2026 12:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17AB66B008A; Thu, 12 Mar 2026 12:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B13F6B008C; Thu, 12 Mar 2026 12:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEF9B6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:02:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4FF3213A7C4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:02:06 +0000 (UTC)
X-FDA: 84537877452.01.DB82197
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 35F53140010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:02:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WVGct7xF;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773331324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qy73+iGNGeECV0rQjpRLn6tiSFKzdH9itGL02lldZDY=;
	b=uNila0Fjwmcedp+00C0D1nw0+Ss8K4kLk+PVLrM42RGFGWkQEo65TD09h5rkb61pDI8k/j
	E7xLEJfqPl7oxdoo6NCPfnc1tdax52U8ufMiT6DMA/PlsQC5i8IsBrw9RYMFqN2KJI4uSO
	Szlu6F++rg1TgY77usHPZodpZN3lj6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773331324; a=rsa-sha256;
	cv=none;
	b=a9mKdu3cc+URpFNKdykl/5th0ZD+9A7Z7ac4V8cb9yTGk2IyrFqI4PWywcSkw3DaSr1bfz
	c47NpmRmUuvZzaf9RiaEcchTIclMnzzXiwDUlX5pvfb+0Ol0/c2DMsZXI6OQCFbWJLOIht
	Jh0SwlF8jYMzMZY9HaLeiYvl+sdEAnI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WVGct7xF;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-79863ab8478so12262957b3.3
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773331323; x=1773936123; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qy73+iGNGeECV0rQjpRLn6tiSFKzdH9itGL02lldZDY=;
        b=WVGct7xFG8U6T1/BWYLQmK+UtFFLyo8Ddc++oKAc/5nxmvP/rp7eVs+oJjdUxxa3x8
         dKqcs78L15y09ngeh1XItLCaimypdTy2Y21Eb92DmJkOLEEI9vpSHwIjDCJvs5uCMZbZ
         V4osu+wpzC1DIIIOPxXv2LNoY4yOukG6nzEYim9sVO6sWQ88aoAwgvkNjNBdrzWvu7QJ
         0TMbqWgnCMrlpZKPTKDYW4iGFsDVLa42+PG4VN9OUU6DwIsG8kugpN3f9Im3WdxrLzp0
         vvP+OJ6LYes7tBV1c1mCieNip2JJIn4DdhZyyzZ9UWUWNTCV050lU/AdHIPipVweg2Ro
         FHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331323; x=1773936123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qy73+iGNGeECV0rQjpRLn6tiSFKzdH9itGL02lldZDY=;
        b=jXsCLVH9tHvRSVmwq4NtrfMZ9MH2SgBUItIj0LjUCEk5Jcp4ucXca6rKwp+1NPb9aM
         IW/WUoHu6GOQuoYZQmZy5wR5M8ZQPIhjj2xAHjPsxNx/gRI8uXxAFzThU09l9wJpci5f
         ffoa7cAq834vOJaXqf6LRXqWJCHVVTgC8ZRyDjDKEMAu0h9Sf4ID4TKUVT1YwpXaKrwC
         Fqa/bBgvzjbUerafGJwNOT7s0rJXtdoJjyE4MeYazGjhdqnr8aJO+8EEZm5jhFSbh9hU
         KRib+OJlAUm+0yp7W17zueMJD1T4Ki7/Ei0LWNHCduTATVMiquszda8bmlnqFB0G5L5y
         SecQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFH/0v9EEEovln7yC1lCX1wjDtD6XkmuhbVXWInB8qs0FWYH8SQoXHaKrXSlgAojWne4yqLDiZjg==@kvack.org
X-Gm-Message-State: AOJu0YzBPkIrLziDeaFnyKueNalDc1xFdYdDu2BliMQk2Th1raYGzqJS
	+FYAd4dlw2MxlC/RxxPWaub/FD8J1Ac0NZTB5ud33zTGgXaTzbV/gCmmilz9xkW7LEk=
X-Gm-Gg: ATEYQzzpT6zM9Y1gsV/yUvA+joOpJMA2qmiC9FY29YrpsE8fjtMDPX9sLz5Rn/ykcEQ
	PkR+V4Sj5RtxNJflPPw8STJqeXfLhvraKTC77XzfLi7Xe3237bSEyiKY1UKqNhCBmrGfqQXAViP
	EseakBdiOuUjVBIHf81RioTAHG4ac3HnM7Tguv2cYqtyJxBa633SnHPUuOkL41z/rhPJo3jPjdc
	/u5nG/CkIr4JokNzF38i+xucGTlzktGs3Z+9kdhYZHWDIzNsheS296zdgzU/EMlE+WNihqHlIrT
	dBLwJMzsqcfg43vlJPXrCvvaXNvZDUZJjIHxr/5GEx3lgqykWJw8zWwdWGd/8u4i3IrkJWNrqD4
	u6ASMxAeIajRLgwbrAK39yroMsFjH+yaUSPzVnfBojlukZBZbB1Cb5Bk+G+pW+9OapsoxhOLPr+
	gXvTHnU1H4uqhLcmWYjMBW7XOw2rg+7b+lAhgYQl1KrgmCV5t1e/cIhzJwfeoljoJxyt8kxlqKB
	gcX8a+5yw==
X-Received: by 2002:a05:690c:6389:b0:796:45d4:9e2d with SMTP id 00721157ae682-79a1c1dce28mr556267b3.53.1773331321722;
        Thu, 12 Mar 2026 09:02:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65d2160asm37260386d6.52.2026.03.12.09.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 09:02:01 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:01:57 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org,
	alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, apopple@nvidia.com,
	byungchul@sk.com, joshua.hahnjy@gmail.com, matthew.brost@intel.com,
	rakie.kim@sk.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Bing Jiao <bingjiao@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH 3/4] mm: Fix demotion gfp by clearing GFP_RECLAIM after
 setting GFP_TRANSHUGE
Message-ID: <abLjdSC1DOIyTnPa@gourry-fedora-PF4VCD3F>
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-4-alex@ghiti.fr>
 <abGsagHIieEobFbB@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abGsagHIieEobFbB@cmpxchg.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 35F53140010
X-Stat-Signature: d4htpp8j9obgp9g3m3w3ecc19c1grbiu
X-Rspam-User: 
X-HE-Tag: 1773331324-262385
X-HE-Meta: U2FsdGVkX1/qi/DUvJmgFcjTs/tHcxo0G2p/UdEAx1+dHHCeV13dnxR3PLc94B8T4bvmk3N8/jKdC7sdpGD4xwnUy9NhX4OIpXJKDX6RzccAow3rD1CPi3mtmWb1pFRiCvEjxhwA5Iv5moRni3MQWBM/xgSLSGVuhA7F9h44qAUjEs5TfriiceJ+feIlh8qi7ARcotZeqk0IrEJG4d4CekzBuk5iAbvsCJ8fqz5qcIYwE7EzGjZMs7/y5sO0ckNobVgZihK52jOYP0KZs1tZw8o2A93BwMGFdUjXll+KdktTtT2GrKAfh+VyXOfJ93AklXhX6OE+Y/EH50qhpy4ViqpV5aqNZCqVtOrBSgG+uNnkNq1DyM123NHlKRgsp3OKs1TFux8bvLI0UfUUEJcl+4i8ZSImbuXpuoNjaskuzlJnsVOSRAj+FhOXVSwkgnELtJgrvc3kGKNj/HPAkz2vCdfe4fIlGU/IJnhGxV14BY2XgBMuC71Tjj80t/zBQdwZSnu4OXoxsaVloWQViYd9h2S62avcv14/DinySUJt3kTAWKqP/eZ4sh8rcpyQzN+wQ4VmNwI6Kq7a8z6ZKzPul+ExFag8MOAXgJgPnlzuOglbDO2pAYwByNESV+zaaBmtY1K93TgaXfvOrnx4x5Nck5Cwch4clPkJ8xAbn0DJEfZ3vNLvtYTx9cpWiD7zHs2D4KTFdSz41iPDXFnydNYCxJCorJaMjrYDB78JgCfjTToKAFXgtpBQwo0OyybJSyJ53ZF6Q/Y7h0u9Il877p2SRIZw6wSVEC3V73iNREOuB/+njPnkUhxzTGOCD4FSLKKJPgeyezdywZZdC51upEz7rJMPOwGAo384q5e8KdS4USs1EuUmQm8hmbkuNQSCFr2H/UZXpLr+7i3CT80Vtu6Rk9Og1BjGZH1Hs9VEeRNmSnWh0w439z4N6rFft/tBCs2V6ersZ9Sa6DqqxIHG7dm
 +8/1O3hM
 fkKmHOB+TFnacZ6uFkHxd3+Mig2F6wO8hT9uLs+rVs61uO41IDmGYfec9zVMMgYOoPf0JWufjCuTVkJDlwyHuOQ4qHFNghNMxatiD/B24/OxZcsNUNDV45DyyEU8a+zS4xo0xLsd3UmTGgswpLRq9iLIwFugVawkim5RzpEaBxzoFVt+S7NQVfisf4Mruh83M1+BGnFodgHaNLpmk1tThwG/5CgRZ9FO0LvmOB1NJbW3+LXJ8b/Plw7i+OoIOI8ZGrcQtkqrOMPpQw+b/vXMzzd461uxJARa08J2/j9EPcXBEcf/WWQ8IOTZPy9VkcQ18MdolTedeFONtz4YIuUqEEpoRmm3N0wf8QJG2SLiXPRn+4uBqWUUrUip/A5VLzvEMZ1GVee4w2OrF9MqHOTtKim1l/yj1J399Uzomtzd7uRmjSXI6kzNOmxPWhJz/b+PNtH4GvJ+sXzcGU0tRqBTRVrSUN14gBW6g2qepovwatasIZzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 01:54:50PM -0400, Johannes Weiner wrote:
> On Wed, Mar 11, 2026 at 12:02:42PM +0100, Alexandre Ghiti wrote:
> > GFP_TRANSHUGE sets __GFP_DIRECT_RECLAIM so we must clear GFP_RECLAIM
> > after, not before.
> > 
> > Reported-by: Bing Jiao <bingjiao@google.com>
> > Closes: https://lore.kernel.org/linux-mm/aXlKOxGGI9zne8sl@google.com/
> > Fixes: 9933a0c8a539 ("mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> > ---
> >  mm/migrate.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 2c3d489ecf51..ee533a4d38db 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -2190,12 +2190,12 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
> >  	}
> >  
> >  	if (folio_test_large(src)) {
> > +		gfp_mask |= GFP_TRANSHUGE;
> >  		/*
> >  		 * clear __GFP_RECLAIM to make the migration callback
> >  		 * consistent with regular THP allocations.
> >  		 */
> >  		gfp_mask &= ~__GFP_RECLAIM;
> > -		gfp_mask |= GFP_TRANSHUGE;
> 
> I don't think this is right.
> 
> The Fixes: did it this way to disable kswapd for THP allocations,
> while still allowing the customary direct reclaim. Maybe a better
> comment would have been: /* GFP_TRANSHUGE has its own reclaim policy */
> 

The bigger issue how many times we see this particular flag getting
masked and apparently added back in at multiple layers. We saw two
or three paths (some unreachable) that can twiddle RECLAIM flags in
the stack for demotion (which is in reclaim already, so do the flags
matter?).

It makes it difficult to reason about what the GFP flags actually
are at any given point.

But yeah I wasn't sure to make of this code, it could be as you
suggested just a bad comment.

~Gregory

