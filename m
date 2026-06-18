Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D728ACD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC50A6B0088; Thu, 18 Jun 2026 08:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C426B008A; Thu, 18 Jun 2026 08:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2306B008C; Thu, 18 Jun 2026 08:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 933EA6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:35:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A7951C492D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:06:14 +0000 (UTC)
X-FDA: 84892603068.18.A691331
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D9CF20012
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:06:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PVuZDXZr;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781777172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ic2yPlu9WxxvvZRxBvrLjmMOjFkWCzZQ9ebOBQNrJ8=;
	b=VRlbX20Rpx9BRoYuc6zAZoZodEPZHVZXpffTQaHwiB5bClfrSTfNlx2teziV172ihqJSTG
	33VtRGDvzizbAoF3Oc/KOAibuFpq/gUgtm7R8CVCRGBvjGWFdMSgEF+Q/UM1ZVVF4sBhxX
	eyvzV1HrJVv+hVUeN+a9OYdFW4J3ecU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PVuZDXZr;
	spf=pass (imf03.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781777172;
	b=zl7oEommzw6XaTDOVIs7x1GuoIkpP5paVYo8nJTHctTKIpCAzeE/n+iZF1tjdDf13Q7wxZ
	NivxriE5RLrLCKeAs+F/8Cbzh0cT62pFCleqo8sP5hVDa+s8jqHUFX1rj3ulJSp1Nbt7KE
	VUmvKUKltTnYeZz0Ls2Da1eMLy0KFzE=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5ad49da7123so655574e87.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781777171; x=1782381971; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ic2yPlu9WxxvvZRxBvrLjmMOjFkWCzZQ9ebOBQNrJ8=;
        b=PVuZDXZrg48F2ePQIBAWRxPW5EM3muPFa7rw5Rs9F52np2SsbATCuAPmL4+OHz+8kk
         cm4elOMiXm9pYm1dWgmO50RyWdvmelxMGGIkd62w7D46jTD92S0+PBhKDP6z0VZkkDhY
         LMrbYvmRZjwtw9ZsSEx3tNBT7DN6N34s1n0HTbIwEM9Srq24nGk7bLRhnr5ZjXZnVSwo
         RocDRnIVrhmDTZDcqAecXdtj/AOT14TJt+4LJuMP9Z5dg1Ps3TyBWWS42JfvZK2AP4kn
         Z6wgM5+dO+AKfuGOHLRFwPAI4kxp2JhHjr60FasWuWWl1OctCPpnJV02z1sGyPaIo097
         z0RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781777171; x=1782381971;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ic2yPlu9WxxvvZRxBvrLjmMOjFkWCzZQ9ebOBQNrJ8=;
        b=fLWn2yRvby1AgKgRgaN86b9gWh9VJ4W/aGnf168lsCjSYrvqTPojGIuuvYOP5JkNDd
         SfGSsHlXIW1ci0Y10Csqw0nyDkGKHpBTWgcF9SSKQuEW72B9hWagULBtZXUsIUbYbJ/O
         xhMariC50PntpYh0hNQQkFW3rrDPnOCimt06/gkxDFes6pPWoMxxNQbQFiJ6Y5D8sRP/
         Dt0qsy+tVZy7dmJSdQndC4vZL6jHor4s8PMcCvTgO0DhKYTkonIjoGsPawMVDz4WaUV2
         0ngGO3fKyuZIOhgKgYQkJ48kNZ5NLDY/FqLeg0VMRJFVg5ixPikFx4yiawCXE/6xMM8P
         4HVw==
X-Forwarded-Encrypted: i=1; AFNElJ+IzbQNZYAqgyZlBYBw4jd1qttqVetyAkT7b3kX/B1ybHy7ePctxX0Q4yEc8MpSVTR5ms1h2a5MoA==@kvack.org
X-Gm-Message-State: AOJu0Yx9uvL1Rwl48naZ1A+tl2gNbdIPqOUFpTEzOqaI4gOaExPxXE42
	Y9WP3ddQDnWlYOg/XMu2jrvRZKnjJi8ZTvW5aLsD7E1QPAdTINBIyXKR
X-Gm-Gg: AfdE7cnJIgIGu7TA1jFS7ylQCkd0T0JLdqRXpkXTvr/3l6Smgdiiv5PNDxHTQvoN1yD
	YCs300PMuhWIx5gHKApJDO+GtzuE1s5j3m70vl76nuRp7XS1eWkFScmzY1mP9TXEctpFDs5O5NH
	pFV6aa+UE9ismA673gNPoPB8DV3ErcD+1jvyxr8QoPQVyDrVAVUap5xv7Y3+MtzhHf1PBPAGo/Z
	OcHfHQgfi/BZ0CSWoQ2k0syt076uP1kYx+SgA1TFByYM/UJTxqe7fZLkMOaUvq1Bl4ZlsEHS5mM
	KU+TWD8FhsPTK/dHMN8x3tPbD/cTMYt0gsJFK6g2sCuuQVp8uR2AjZrKCP22bnYct2mGDYWVa/O
	PDvmGDv4rdKExheFRV6ujFxNVYPJpYHT+XMQymmjI8G6w94K26suhVdkumQwH3lAzGtUXraFPkA
	TXSb66P0miU0NQskgms/5lyDwRKvt0BEpNWGaofg==
X-Received: by 2002:a05:6512:61d8:10b0:5aa:628b:5892 with SMTP id 2adb3069b0e04-5ad4d4577cemr623663e87.5.1781777169449;
        Thu, 18 Jun 2026 03:06:09 -0700 (PDT)
Received: from pc636 (host-95-203-2-134.mobileonline.telia.com. [95.203.2.134])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad2e1aea92sm5216940e87.63.2026.06.18.03.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 03:06:09 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 18 Jun 2026 12:06:06 +0200
To: Matthew Wilcox <willy@infradead.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Pranjal Arya <pranjal.arya@oss.qualcomm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mostafa Saleh <smostafa@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Shuah Khan <shuah@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Brendan Jackman <jackmanb@google.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Santosh Shukla <santosh.shukla@amd.com>,
	Wyes Karny <wkarny@gmail.com>,
	Sudeep Holla <sudeep.holla@kernel.org>
Subject: Re: [PATCH RFC 00/12] mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
Message-ID: <ajPDDkV7yqWlhPIh@pc636>
References: <20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.qualcomm.com>
 <ai3kkIpaR0aT_6q5@casper.infradead.org>
 <ai_LVreyRWx-RDEd@pc636>
 <ajGQ_WPT3Ra2kPCQ@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajGQ_WPT3Ra2kPCQ@casper.infradead.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D9CF20012
X-Stat-Signature: ifztc4183uic1u3uzjmwsdr4kbffj43m
X-Rspam-User: 
X-HE-Tag: 1781777172-795524
X-HE-Meta: U2FsdGVkX19f0tjPFDcuGoVREiBr7z5T9u/9OvXv1X6B0KzHmVzGoqjvDmNxcLcd6mdEKV5egJ6LyqyB2WrQLWjx972NCFHK4t+GMq194CCKAIfwCtlwBqWJ9JjpMGp5tlFgrhe+ClVUIeo6Rf9axfGPpGrMNaR2styZYOe8yScLfAzgqoNaiP0MeN30Dc0punGihc9ZaTKweRw1dGX9XeunL0D2uBRCju5Sz3ObtHQQvYTLEQD/c0eXP/XGqr4FXYq1LeBt+vhYPjQf3eLFBX+B38K6XcFNbeYDwRnlZde20ROc4aVFj6bZQyd+AGfMA3X4/SeUukdl8tJ/EfgYf/N37mhutPt964dqPqALV+oU+H3+a9TzFK31XJFEYIHdTwee4YerE45tCclG8LLBkmIPpwMw2sLY86eFWjEcrfZ3za+q7Kj4UApu84tWSN1IEbxllMNBfiZtPZuRlGWn6cSC34VF+ZVwANCr6yMgAkg0qupRPNFug4cafJgg7Zm7/2rS7y47D8la7fd1lh+dmlILXa8bohQREsfq1XhJEbIeUEuxB+qHWMMoZVZOgmSohV6WRwx7O8lPHyVVzy/WiOlE/uUVkFX6nd+MSiEkub2yYeESC8cZfKXNp6MCpah3c4t+D363/MWRoKCXqqXvYHVLv7JgJta1RrG4h29Z2bIJnalxld4StCUDLRIZ8vwpmQrROCDtUr07rzD8BKeNpzPU3PkKcF0nJ0djHXUjnkwiEY5hVhsi1inapwjPotJ/9UUcoUmtaBCXtHje7WxAdweUpwyaOIrqofeyZxjSg8snII0lKVirf7Qn3rirs+MBYD/LtNjSd+KjJrGCY2JVRpj0JKHTwLu/x2jCD/a4Cl/861CMbYs5BYXZRJYZmgVr1gmDUWWfwwbuWQPb+I0S8kzoBSEoaKoXPfJnUVjlCPbF9fsujZZ8J/lyhPi8zXLU4BhTPRfXRHK6fHlv1FA
 JjmS2S5Q
 iBk6f7MKs5Ltr4eZ/QAV22b20O+p+RlraUb0RWgc3bYi1XlmvB5MyZ0vEhiGI2RJI0C2So7783elec3oReIo1Q+YqwGvpGF1ZdigdhTn6piB/0sPEfwyQE+hXZcNdCVJ03EKPG6cOswcgsNtJNVpAlZn2AImiSn90lHyClqBHqlMSSitVycmU7K/V76q/qT4zZ9CVkUuuz9Q5i5g6yvnNqZUlUpZ17o9iv7bzncPs++HfcyYBUjFkb8BKk9NRYMmp2HlCRl0fbUe+/E3bnfy59Skl5V51qE9O5TmE09G2p3FcZt0vmka9VMUX2zciyJ9FuBGvwV3xh+Qz5k/nqOVQhjzyeuAObaHzqYBeFEDAq/Vp0bMkD8NgS7BGEmg+mGTgs/ZKphzXpHCc8npRws/pxf1EZUKSxxaDvBNPXd1J/tKJZI9WcwkKnMYWk3nzGVqwP2F32dkI/dmSht6wH4FDl9Ms8Fms7fkasLlk/ExhiGG6rq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 07:07:57PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 15, 2026 at 11:52:22AM +0200, Uladzislau Rezki wrote:
> > On Sun, Jun 14, 2026 at 12:15:28AM +0100, Matthew Wilcox wrote:
> > > What I don't understand is why you maintain a separate "free" tree.
> > > It should not be necessary any more, but maybe you tried removing it
> > > already and found a performance problem?
> >
> > We maintain it in order to split several entities. That prevents
> > interfering between allocated data and vmap-free-space manager.
> > So in that case one context can easily access allocated data, for
> > example vread iterator, etc., whereas another can do an allocation.
> > 
> > So by splitting parts i minimize lock-contention.
> 
> Sure, but there are many ways to reduce lock contention.  One is to not
> take locks at all; the maple tree is RCU-safe, so you can read the tree
> holding only the RCU read lock, as long as you obey the RCU rules.
> 
> Specifically:
>  - Write side has to RCU-free the objects that are stored in the tree
>  - Read side has to trylock the objects it finds (and retry the walk
>    if the trylock fails)
>  - Read side can see a mixture of objects if the tree is changed while
>    it is reading, but for any given index in the tree it is guaranteed
>    to see one of the objects which has been referred to by that index.
>    That is, if the write side overwrites an index that referred to
>    object A with object B, the reader will see either object A or B.
>    It will not see NULL and it will not see any other object.
>  - If the write side stores both object C and object D in the tree,
>    the read side may see neither, both, only C or only D.
>
Some thoughts about it.

Having the tree which is RCU safe is good for sure. We can benefit from
at least in the: vmallocinfo scanning/dumping, possibly in the vread_iter()
when access to /proc/kcore and other places(which i need to check carefully).
But this is for read-only traversal.

Switching to gap-based approach requires quite a bit of refactoring and it
should be a full switch without any hybrid schemes or mixes. I expect that
we remove more code then adding because of some parts will become hidden
like lookups/reserving range/erase, etc which is good.

- replacing free_vmap_area to maple-tree gap based approach;
- rewriting pcpu-allocator which lives in the end of vmalloc space;
- refactoring per-cpu allocator which is also part of vmalloc space;
- vread iterator;
- vmalloc dump path;
- vmap_node logic(use gap-reserve to minimize contention);
- and more...

To me such rewrite makes sense if we end up in something structural not
just because maple tree exists. The criteria i would go with are: at least
same performance level, remove more then add, the design stays at least in
same good shape.

There are some drawback i am thinking of. One of them is maple insert path,
mas_store_gfp()? First we need to find an empty area, then set-range and do
mas_store_gfp() that uses gfp flag for its internal allocation. If we are
under spin-lock sleeping is not possible, using NOWAIT or ATOMIC is not a
case thus we should somehow pre-allocate outside the lock and store the range
without any allocation.

The allocator operation:
 - finds an empty range;
 - publishes VA that blocks that range.

those two have to be serialized among other writes. Otherwise two CPUs can use
same empty range and both try to reserve them. If preallocate outside the lock,
the "alloc" side has to validate that a selected range is still empty and only
then store VA to block the range.

I think it is worth to prototype something to see how it would go. I may be
missing something for sure.

Thank you for your input!

--
Uladzislau Rezki

