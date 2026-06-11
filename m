Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55ED6CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43046B0005; Thu, 11 Jun 2026 14:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F43A6B0088; Thu, 11 Jun 2026 14:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E25E6B008C; Thu, 11 Jun 2026 14:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2DF6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:11:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E9901C3637
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:11:17 +0000 (UTC)
X-FDA: 84868423794.16.76B94DD
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 53C474000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:11:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kfbMmHPj;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781201475;
	b=o5KERrgOTy0P5iH6PKhL4zy5USV8I2Aghg+ZVCRflrrHXtKdp/Ypl+AsB24kKrYqC07Muu
	79RBhLusZ64vB8CdGv41bHgockGY1J0kqEA+5lSaRLnkHUFlP3ef66dDOU/XYhi9PGgrHu
	oEv6T0mksCZ4RaH6rSBzbgVPuxQXj+Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kfbMmHPj;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781201475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Al+T4TqZrJR/gkQ535/4FcHdaEp07L/uvQinYQpHI+s=;
	b=yKAoHtzoYmy6Cp9wASaWioTh7GJTMD625GllpaFh/vas3NMrnEwSLXGNafxXahY1cUTSHW
	0HuwOj4u/lWXcofwI+HnUsy0ZuyIOSKBQn3jRtOxCxnj1fh1FbzW9E2TusDM4OmuJTIxwW
	j3ITKnYmbt8N9QikAFjcjn+je0IdVrY=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-91591f19c30so21355485a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781201474; x=1781806274; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Al+T4TqZrJR/gkQ535/4FcHdaEp07L/uvQinYQpHI+s=;
        b=kfbMmHPjA5U7XznnqPnXzwgZ5zWtohWKzAUmU6XOjWorgfvh081RsFpfdwnOOkmuMR
         6s9ZSlrZ4vha7+NFOQKnY9jFNo4L2BLXCxrQrZ1z++A+MGLW3l7iTKuEKsTUen2YJOvP
         m+iwedmGwZmfPPadrvSqaJO6nYPIm+FdqEvCphxd6e4Q0GKG689Xor591d7qSW+Xdh35
         S2LjRbhduo/FyowgAUMOq9yRqTegoTtjr6R8HHa1ajovFt6HGTwiENdIX9J8YA6JLkki
         CVbXih6EPxFCyoIucOVWwLHYLdvFjkglf3xwrRwxZfqKt2JNZpcl2MCgjb2XeSyV/mPs
         wiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781201474; x=1781806274;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Al+T4TqZrJR/gkQ535/4FcHdaEp07L/uvQinYQpHI+s=;
        b=bg3e84p7CaDcKqsfyP9a5V4MQ7Ex2zp+4qHbWIW6mkaWAVxOvqTDZ9HZ2uhR1bCIdZ
         H985jcbooRlPE+paklpKYmygqj/rx+z/O2Y4UAMuWz++fNm0h4phenGChVOnft613FP1
         weAFZS6XtCJwOwo2RYoD68ft6Bv+rv9lBViwpeCP68loyQqapSKUsUKH/4ntyuDYaYi4
         639Xn5b6YFrbRZIjZ/EJ0GaKghtj259ZX0G6p4k2s7bUAwgjmZ2AyCnjA55fXKqrF4Bj
         gEg6+bijhvZ2Oh6HfMOSmm59Ua7dPFODr88FHjDLY+7TOwemejenlycZ7lNBmTwjq2P4
         y2fQ==
X-Forwarded-Encrypted: i=1; AFNElJ/nuobMqjqziKNwJ4p3op5cPlyHSaxO+iNFiW/UqfAyGIqpvBmPU0048Tlcmjw5d7bO2XVvVI922w==@kvack.org
X-Gm-Message-State: AOJu0Yyg1IqY5xPriPnVmGhVGXR0rI9Ho3Jzu9mYAlLJ/72KsxcPnKQn
	gS+akJh72YKBODU9Q9K5sUnGYBtTjZn9UgAGjUIsYVUyQNlmwdwwPd2XPAR74ynz7AS9G/96lqa
	si+Ue
X-Gm-Gg: Acq92OHiS6sBRvm9wuShxjjEKW5SOlspomOExkh+UBqhiBARRU0nTNBhAk31cdP3w6j
	IIVa5PZg0q4GKNeECPLxy4Mxb26DtKzeVe4I7z5WP7QVXXBylkSgDyunDmet+Mtw4JxzfSVpqGI
	aywSbQpKZRVP1ToV6E3F8Hhf1eCnsp3LSqjL0KgJq19H58hlsCUVddypZLF6A7+qrC1mmAJtcOa
	BOYOIlpMXR6jKvrA7o2bJlv4afK5HNzmPJKm1f+15aNvEeHuuYalzbINLJDsHlgw5cYdqk0mKmO
	IwazahU3tzlEyCFDaGnP0E7f/CgX6niZHrae2Em7aLdVN8L+ISl6WBPFoNScqteYTCTeZwfnMw6
	CFpGRti3sWuEnKx1pZdCW8fy1fwjaIC/oOKjnkjG9IBVbhjlc0DJQzbHHxv8Vji18UZOrDEGNkt
	jkzSmYpWTg07u220famFYCZWJaff9RkJ6S9Jw/9K9ZAqmwfd+rogs=
X-Received: by 2002:a05:620a:618b:b0:915:eec4:1ec5 with SMTP id af79cd13be357-9160b085ac2mr603129085a.51.1781201474374;
        Thu, 11 Jun 2026 11:11:14 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9160b038ee9sm248553485a.40.2026.06.11.11.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 11:11:13 -0700 (PDT)
Date: Thu, 11 Jun 2026 18:11:13 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, 
	Tarun Sahu <tarunsahu@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
Message-ID: <air5ho0LOIEKVzRG@plex>
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
 <aiqso7rkpX6oMer7@kernel.org>
 <2vxzmrx1qjuf.fsf@kernel.org>
 <airGIioUmTtU9326@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <airGIioUmTtU9326@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53C474000D
X-Rspam-User: 
X-Stat-Signature: 4epb7uprfftpwzbici5yu67ehosz86o7
X-HE-Tag: 1781201475-878610
X-HE-Meta: U2FsdGVkX1/MTTkx3Z516nhR2lbXAYVSv4a3Wf7dNP31YyyTIKvAYjB/7+W3VnKznkcu43ddKxjlNr8yACSFTeoBr+mQjcXGO9cCu+RiM1oHyuywzcb6Yvlv8nB5H3OgNc+zvWWe8dLOpemcQnElRPt8vOAGcqDKz/f5oPMIgFvCuu67fddds05/m1XPG5xxYlHbNgnZTnyhJxC6N0e8fxXL8TWdAH1uX+8QQvg7IoHwXI1SXTfXDt5FXunWKUEWbvYry1QHyhGaYkTotLeeOm/7+R2zy6Stv/QzJBnai9Ju+qEvTuGccOanLZ4QP3f1q/4GnY0pzeGa0CANvImO3RTjUfrK2Dx58o7JDcj1u9aOlF8ZdiuB9i1dkxXbNkV131e9Z6U7/JfE0j2AXCidN8/DzMms3KLtuj7N7/Ce7P/TCMGzRx0IWlNI8MUrIzUY49zEdnCJJKIFJkeXdCCYNvHz8g4NAutRMJXfRRZVo/iwKSKdNuhuw7S59k7XNAmNsdzTmBloKpj2vtVxpasvvlm2+vQ8YVcNk33S2M2b605fuqkmPAkNUDsLMQIuwwd3YCbGGbbOHSWMEeKV+m5T8B0+6axRt5uuumoYD9lCqFgEHXXxDvN4QxJjzbLGycXClDAbEdK2fVmueQQnNl4ku3tjXsRrr0ot3KVxNwFHS2hJvN1yeqZdirlpag7vgH7cqhf46C2+nNDvVT0hRknPzMLoMfQCh1wXQhzLhG8fQAYFKE8I0QXN9wXPEL0Dlfxr763sLpkQYf54dG7APjg6XQ5iTWZ8k5zU2smq6rZNoUZWBUjREPuCfRCdmIm7QDdHLg3BRvMm3OHNpktRldorC9JP8nl/T5sep+aJy4JerXiHHOcLlsn9LPnH2RjfaHDGKnNQNO2jRdKV7ijUMTvJKdSFN9rXU6yfVfsahVovrIll6Y328tRwFXp7RR8qKFBLMV23XX99eHT/0iyhzn5
 aieqExRs
 /XzWZ/YwBRXpu938kqj0qnqlTPkDKIK5idi0wNSHc1uS3JM26ErZDpy+UpkZj7voZTaETkfUbWsLZuzepAkFylLdOMwyS+U5CCAJTD/g0uHbpiKqkWBhhvugfSOQjnvBtptLVDNAq/gRDmDREqz+Q1GESEuk8mpNr1fPv8zUnc0K59isyXYOi2OoqkjmugfmcjgS4Z9k56Ra3p+rvc2n0BACENqBQdSj0GvT5jQbPUEgvt5yFaP1iKu3Wap66TsTQfqFvnPWEkXN+Gp7h5aCT9lf6eCA1MUnQ5pbqXD1hOaLEEUx7J1FH1qgbdHH3nJzgKJJLzKVfXMxW0ysd0rznvVT4XtYKPz45xTiEAogVLZDa2yOo9K/8V5t8tUu0W3VJIT8L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-11 17:28, Mike Rapoport wrote:
> On Thu, Jun 11, 2026 at 03:37:12PM +0200, Pratyush Yadav wrote:
> > On Thu, Jun 11 2026, Mike Rapoport wrote:
> > 
> > > On Thu, Jun 11, 2026 at 10:30:03AM +0000, Tarun Sahu wrote:
> > >> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
> > >> on args->serialized_data before checking if the physical address is valid.
> > >> Since physical address 0 does not map to virtual NULL (due to direct
> > >> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
> > >> catching a missing serialized_data, leading to unsafe dereferences later.
> > >> 
> > >> Validate that args->serialized_data is non-zero before calling
> > >> phys_to_virt().
> > >> 
> > >> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> > >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> > >> ---
> > >>  mm/memfd_luo.c | 10 ++++++----
> > >>  1 file changed, 6 insertions(+), 4 deletions(-)
> > >> 
> > >> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> > >> index 59de210bee5f..10f3983b0060 100644
> > >> --- a/mm/memfd_luo.c
> > >> +++ b/mm/memfd_luo.c
> > >> @@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
> > >>  	if (args->retrieve_status)
> > >>  		return;
> > >>  
> > >> -	ser = phys_to_virt(args->serialized_data);
> > >> -	if (!ser)
> > >> +	if (!args->serialized_data)
> > >
> > > We really should make args->serialized_data a KHOSER_PTR
> > 
> > Hmm, that would also be a good idea. I suppose then it would be a better
> > to directly convert to using KHOSER_PTR() instead of this patch?
> 
> Makes sense.

I think we should systematically cover all  phys_to_virt  conversions 
and add  KOSHER_PTR() , instead of an ad-hoc approach of adding it as we 
go. So, let's take this patch and do a series where we properly convert 
everything and provide guidance for others to use going forward.

Pasha

>  
> > -- 
> > Regards,
> > Pratyush Yadav
> 
> -- 
> Sincerely yours,
> Mike.

