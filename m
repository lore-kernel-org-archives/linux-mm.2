Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9E7C87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 16:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C186B0096; Fri,  8 Aug 2025 12:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113D06B0099; Fri,  8 Aug 2025 12:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0501C6B009A; Fri,  8 Aug 2025 12:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAF576B0096
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:56:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F04C58AE7
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:56:32 +0000 (UTC)
X-FDA: 83754193824.10.532C7BC
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9261620011
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:56:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IJc33oXE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754672190; a=rsa-sha256;
	cv=none;
	b=iCOu336aAxzXg3S32hnX5pG1ke882k3GINr8nD0qAxr+OTK9QHTMrgHCxmdR8Mar+vdJdc
	SvyrwHYm2MkD5/k6w00ZBjtGQTgddqDNNSH2ZlxIOdMdElOHsx1uSAnY5PgXRTyq+AtB1U
	b7a7wPAQy0uJV1HlH2Kt5cWbPJFaF/A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IJc33oXE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754672190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7LBLfDTvzbGx3yFmcXI/cuVRKB9os7wxht5tPJbty3k=;
	b=XAffaZpWW0XQbo8CZ7zM+ntGMoV76pMhmqlOoFXvMEeIbORrNLOzgWfvDlwTQn3VELB3Bh
	HQF/2Oxdzv06lYSXai+pT4d2MwLNYgqXz13Byexicj3qJ4TpL8zKMZEXJ1Oci0BawQi37a
	UPpNFFkOZAgCvZibP6e5TUcTU5tbCfs=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55b8736b1d6so2414928e87.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 09:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754672189; x=1755276989; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7LBLfDTvzbGx3yFmcXI/cuVRKB9os7wxht5tPJbty3k=;
        b=IJc33oXEpkXdQt8VEGbMENcc3ON33b6HQd5Gf0YkINSC35ng93i+ZM1IrcjOZnA3Ea
         2h3zMf6H0h1T8rh4Qn95+ctoAMeb8iUVTLIeBzzHoYgcPa0A0Vi+Knara3Ggnj5/I7gt
         TgTioRQWmlaq36INHL2Ir2yg6iJGIF96i1QPh+yyfuyTDSmkKFgAfLKT4VVYhAm/WB/y
         EpIZChEmIq7o3+20Nlm1DRdJxM6FI4OLVJrM5NOZ37u9zLi9Ezd/q3Kgg1RCW+rfH+mW
         xB63XASzoRoULZj4gUd7waN2qoCpcS8kPMb3vLvbuM5rcr4G0HT/vitm4n6nkCSP/PsY
         yF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672189; x=1755276989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7LBLfDTvzbGx3yFmcXI/cuVRKB9os7wxht5tPJbty3k=;
        b=YFFUX1J8wWxW1mkKYWOJknjIjm4pse8ZXbsBIvZ1YRek5MlWLqloQ0gKsSJlVi8kcM
         yi8p5pDts0mDiOVbZXfdEsTfZ2yGIsNVqTYs3S15K61QuNU3y/6IlOrJx47mOmxp68XB
         zoWuLfOinA2Bh3uon0P+MnyMD/ZA5w3z0KMWt778w6uozLVMCNkjGCEKFQQxjNTTRuna
         gAtP8F1+/PPm5IKwPtZiGo+ABDptULgOCvPG/t0DgvsN/NCiiQeTIVT3pYrF3T62BvBJ
         h+50WclSuu4GUtn3+PVwmtbb98GwMHD2Zqn/4Wn7EdPTzuyw7Xd1FOCZuV2tBp5hopqe
         9GTQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0N5J0fLPcyQvSSmJRaQeAGI/rJHYXid54N94egJs8KziCuN3sv8XXlPDSngrm3E6STMchr0Hs7w==@kvack.org
X-Gm-Message-State: AOJu0YyYMwp2zApH1q4SaCcPf7i1qr+dsan6WKRdDxRYsAOklgkDxrJ4
	hc/GCD9NwhjS/VQeNxVd6OoE7lP8NvjYQdddHQ8TOpj6AnXNcVkl3oJ3
X-Gm-Gg: ASbGncuYNugaIoDp6vI8jvDxfsuMiMR2cj8nYw/1RoQGoGEyCTcUHDeZ+X23D/91fK5
	5NIQPfqNEW7XarNZcg/cTlwEWY6+0BqoBRxmOKj5QWSoYuUCd4iTBfVtqXMghNPya2MvW31+lDy
	uCdY+ksmoozJtT6ntKb8dP1KC5bQGszDOdAyW04kMEHnlAPewtJAZQRMdlAA7gLlL1LGlsQ0LF1
	mP7Q1LNYFUziG+MeKVYyuY4gdlqCHuJQBlN9rte2E8VKRnFeTUtBv+bXrdkZ+1mIEkzC+xSa7nJ
	gdcSnC5GRT0r4ZahTgkRm0WCxUownLRAFD33AOYz79RcPXt7sg2hrWZM51UcfEuyqON481BjeDN
	KydckMJX62ZsQyo+O5YVN4oxEgauqFY/+L+a/cX03jqGlWWoNog==
X-Google-Smtp-Source: AGHT+IFdThAy+vd4lzX1BCpXC1ZlUiH5NrUOgca2mq23ylMZkZXKQZwttX8IRO0lbgeUS7mg2X1dzA==
X-Received: by 2002:a05:6512:3a81:b0:55b:82cd:71ff with SMTP id 2adb3069b0e04-55cc010e021mr1064169e87.37.1754672188569;
        Fri, 08 Aug 2025 09:56:28 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88cabb8asm3154101e87.145.2025.08.08.09.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 09:56:27 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 18:56:25 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] mm: Drop __GFP_DIRECT_RECLAIM flag if PF_MEMALLOC is
 set
Message-ID: <aJYsOe3nxP6Nuwsz@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-9-urezki@gmail.com>
 <aJSU3O-pUnTnl_wP@tiehlicka>
 <aJX3zbr8QsIs1LOw@pc636>
 <aJYGpPoaZwYZZ3Ze@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJYGpPoaZwYZZ3Ze@tiehlicka>
X-Stat-Signature: jp1c939814s6h1ktnwdzmyziw9rngyde
X-Rspam-User: 
X-Rspamd-Queue-Id: 9261620011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754672190-435472
X-HE-Meta: U2FsdGVkX1+oa6tGnvn6Jmkmstt0Egz+ue5jwbTOM66dNpFe5XElJFiY3RBhSn+sH8J4EL/m8Zv/2ZgDZu0TJwGlmrt0uNpDPuMh5pTxjB/Zbz83wEaCDVu1q+QaIwXzTJk+NPFGe20w8unBvxUteyGVPtV2N45pgP27pfyeNG3WAB5pJKt1A2nkYhQibeUMKRuaASLFZrJEnc3B+mmCyRmk6VFAECWkvjTdsq2PAmpgXbLlsfwlntyqhxqX1sKvFT+ICjkOftQw1ALe6qF81PzTAuQNwr5sjqDAqT/7n279102sG1oy+x6LiMPYkfKosLWk/P6Mh7ENvfYx5REDikShFYbwooJaRvGvFL+KHZ/EJh7NtlRPrEddeeIvfHTxMS1yowYYkZARVn6WoPPU8lROzH9p3MX8z1OZ6ZShGUHjpePTAJVo2a6ooRnIl1T9HMhQmeI23eZd3ZZE8ovwNuDaCt94I8r20eQuyc3stDtHLcwjzFVPwUqJdvNzAtiCS8FURH2rzvVN8//87MzaWetBkAIXFZ3XWQdBfo0RdEifTNF/c9jiNoeWTu6skf461PGUhvJp6LGsuECBTmzIM0JqsFxvkl+dvbL2xQDId1rAqKKTbSrKYwQ/2Wy+U0dTeCpVkpLgdi7HTUG326BEmLQthLOGpC0Cw9g4lF2yT2JS0PCPd+UWbOru7RDMO7Rp8ciqfRfbZIRb/pEhNcISfrPIIwVgxYg35TiwdkgpWCKITzHBCeVqckel5qnB4AaVkVMHFugQxbpFzB1m8dTzPP9op3JYENb1XlNQ2GpzMgmlJOSE1YLYq12+t+1Kms96WudGi2F5JDW1tL5yMCzvbrPm8s/+XSkQVDbsBbS1ueQ9a89jWCvd4JvWtEmHtbfrG3RXpHWF9sDgMF82MqDPUm1X2okQ2M50e54TIev/pStJwh1pS9NYprd03/IZ0i7s+8L+H/6djgoX+NkSfbX
 OkPQCnmJ
 gJivZkqiu/JZjVmQNyQzxYzMq6C85xU7xo7aIPsNKzAcqguklF5IMzTYxTe9b3TIjHNC6+9FkYz7tpH84ap/zZQcTT4Q2ARsUS2ZlAb32/a6D/ZSOWgrx586p8GIO+zqg1okACZfrF+gGbbR3A6AipeVbEaNNFgsCFSg62Io1CL1EROjFSf++gEmeaFWEFIiXHus+LGkJesoU2HWEZX7ZXLkms1lYAtyXDlOShBYNipqu9ghETIWtDhmHsK1CDhTa6h1t2MzzfjKZ1qP2MgJFCZj4wViezn/4YWa4ro1xOgmXGgCcZlZoGP8FZYM9yxSRDRli5xOSJA7Z2ujv/HG/3KLY8tKg6NVTS8BAO1ZwwhQzBqDlvEnh2JvNK3IMwnfFYRrW4TUCdmn9WJe1Of4iSs5YNsNTV0Tr/yDND3L7vrie+HUWEyur0AjjtqDS2Z1WWtWgRW9t52V/hnTvbf8s3VUWClOb3Q1q2YZq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 04:16:04PM +0200, Michal Hocko wrote:
> On Fri 08-08-25 15:12:45, Uladzislau Rezki wrote:
> > On Thu, Aug 07, 2025 at 01:58:20PM +0200, Michal Hocko wrote:
> > > On Thu 07-08-25 09:58:10, Uladzislau Rezki wrote:
> > > > The memory allocator already avoids reclaim when PF_MEMALLOC is set.
> > > > Clear __GFP_DIRECT_RECLAIM explicitly to suppress might_alloc() warnings
> > > > to make more correct behavior.
> > > 
> > > Rather than chaning the gfp mask would it make more sense to update
> > > might_alloc instead?
> > > 
> > Hm.. I was thinking about it but decided to drop the __GFP_DIRECT_RECLAIM
> > instead just to guarantee a no-reclaim behaviour, as it is written now to
> > the flag.
> > 
> > >From the other hand after this patch we would have some unneeded/dead
> > checks(if i do not missing anything). For example:
> > 
> > [1]
> >     WARN_ON_ONCE(!can_direct_reclaim);
> >     /*
> >      * PF_MEMALLOC request from this context is rather bizarre
> >      * because we cannot reclaim anything and only can loop waiting
> >      * for somebody to do a work for us.
> >      */
> >     WARN_ON_ONCE(current->flags & PF_MEMALLOC);
> > [2]
> >     /* no reclaim without waiting on it */
> >     if (!(gfp_mask & __GFP_DIRECT_RECLAIM))
> >         return false;
> > 
> >     /* this guy won't enter reclaim */
> >     if (current->flags & PF_MEMALLOC)
> >         return false;
> > 
> > [3]
> >     /* Caller is not willing to reclaim, we can't balance anything */
> >     if (!can_direct_reclaim)
> >         goto nopage;
> > 
> >     /* Avoid recursion of direct reclaim */
> >     if (current->flags & PF_MEMALLOC)
> >         goto nopage;
> > etc.
> > 
> > But, yes, might_alloc() can be modified also.
> 
> I do not have a _strong_ preference but my slight preference would be to
> deal with this in might_alloc. Not sure what other think.
> 
No problem, that i can easily switch to.

--
Uladzisau Rezki

