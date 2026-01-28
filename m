Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F442D46BFA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 21:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB166B0005; Wed, 28 Jan 2026 16:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A994A6B0089; Wed, 28 Jan 2026 16:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BBD6B008A; Wed, 28 Jan 2026 16:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 861C06B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 16:14:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF86C13BAF6
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:14:18 +0000 (UTC)
X-FDA: 84382625796.18.02F2CD2
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf22.hostedemail.com (Postfix) with ESMTP id DEE12C0010
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 21:14:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J2rGXMNP;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769634857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hv2y5+eHgpdbyVWkOZYtB9y4CpO1vE2yqof3Vkhxaww=;
	b=iY3ZZ7BWS0lZq6HqL0BuGyziacBlCvCDNJonRsGuS0a4glqoC/qm4RVHIekrwJyMLqiK+V
	xpFXl2dwVUk03dxBV+p6IukfIdx3OXgDQMKHLLiz6Aa0eYAOAR7rUKYkr3p8yRwdwoBnXc
	fop7CyrE5/0SzPtR4X4KYfdLuUZnyr4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=J2rGXMNP;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769634857; a=rsa-sha256;
	cv=none;
	b=0UheJWC18V7baMQlUBdj+U5pPvPua6w5ZrdBOQWHyCTsJ7th6j9hYAXXWyCCPJFvvTqveC
	2pUbKPoLAL+0VVRMP50s0/G3LKXR0druZ6Es+3vNniYGvtYQkEFLZV9GMJIzq2K4uUzU5D
	5F9moTl4mP0p5EgAMK7Hr4OiA/XGLOA=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4806dffc64cso1936395e9.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769634855; x=1770239655; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hv2y5+eHgpdbyVWkOZYtB9y4CpO1vE2yqof3Vkhxaww=;
        b=J2rGXMNPra0CYbRmwqSa8qvQiPzd2NEKI6lWobSbzTAS/iHUXA9DI+gQ2t+PvS8iUy
         PxNYI5aZu/N25s/Oa1WM4MlplCajqvAOvlNvL98nOayGUSIelh47uC8l96iUOSQcQe7n
         NhSsFnvcuGeWE8Nduv1TfH1Ni1mfXBEaArmouhatyp4SCvPdjCPnjtRKSkzmHE4UYJiL
         NwGw9nkly+dmDjgNo6keK9OGjt+arwWSTwPA4isY5jysrlHqae0UC5vLdovb+H07MPM6
         4iP1h5zVCCYh8snNKTnjiLCBaHySqfdw2AV1QcIlrET11rACxfeOG962GRBvRLkXf49S
         9Wpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769634855; x=1770239655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hv2y5+eHgpdbyVWkOZYtB9y4CpO1vE2yqof3Vkhxaww=;
        b=dJd1HETcAONgF+tznhylHlSowYXZVYq84UCWcx4frt0Hz9AhweftiwuPc1zMaMtTOT
         2yRbP6roZocnl7ww0mbn7dVNuN5riuRw9Z/WhsIrGvcmC9OOIh6BtQhYczc4f6/7VT/k
         QWHXRjUPz56AApA3Xjl+TZokJN9G+a4sR0yYdUS4V0Y55sxd6GByy6toKROwlkfW7cyy
         yagH4nL8W9ELEUO47pTJe3SyZV5QrCTROhZdGO+9uJt3z6pT29sIs0Z/EfUtVmM52Gyu
         9/zR/GaigTIM6zsElBmp85PDpavnO2/jl1AzI8Pow4NsQy0nCkAFZnswJDHflDqpr7a5
         b7kg==
X-Forwarded-Encrypted: i=1; AJvYcCUmYNukx9o7Ehkh/1YRGPnwWvjcuEwU1Z72edttJe5NBBTMGHKcUNGnOHM4xoKLk0/zNbN/bKB7Sg==@kvack.org
X-Gm-Message-State: AOJu0YwM3nJDXxalnqMtemE+gXJW9YfkGFqevZnh2D630HA064fgzmCF
	QIVAVkU58AYzioGV+csJeFsRZ6JU3Qa1OQdKcfgMq2cRuKuYa5tLcabKHvDAIFrTIyY=
X-Gm-Gg: AZuq6aK9YxDmKWB6ljsxL+2iuMJa/BU75crLwr1t9LlW4bPASs4DxXhOzguY/UttCem
	2/yjAoYL2WMurTKqch/OyyKMRGCawTjARNwpSS3egtIJpxWpfxCAADb1iSfMMGOJtHeNzqe1RhC
	EJ/Ue8meqOzN9HOT7u36Cvj9mmXLvUuFUb0wfDpaP1jURfYGdU7jY435H2FuVNdmfDASxjvAK6X
	NTqxOppNFnBGB06gN/xv43E/HLiXAjmBzCvMgm1LV+K0OoonU/771UbTI1at0uU+ZQoG2ZinpEY
	wtWUbfEREHd1TP9KvyWzXj+KlPxNXJ+xSe+AFqQEFauEa/CO8UyFfl82eVcPuSIYEmPTjsXO1HD
	lElVz3vbaOhA8c3lRBgQEAr+kbiodA9lUpz1N4/Qz8E4RGxAOAVRzLqx/cy471WLZ+7+7Dr3hiR
	TM/6xPeM7hoTSSeqFtz/ab+6Ot
X-Received: by 2002:a05:600c:3b96:b0:47e:e4ff:e2ac with SMTP id 5b1f17b1804b1-48069c60317mr95974885e9.33.1769634855205;
        Wed, 28 Jan 2026 13:14:15 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e1354205sm10054004f8f.41.2026.01.28.13.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 13:14:14 -0800 (PST)
Date: Wed, 28 Jan 2026 22:14:13 +0100
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, bingjiao@google.com
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXp8Jeaivfa79L4D@tiehlicka>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com>
 <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
 <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
 <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
 <aXndXPMFK2fhLA4p@tiehlicka>
 <aXobeWtnJVrTmxlV@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXobeWtnJVrTmxlV@gourry-fedora-PF4VCD3F>
X-Stat-Signature: jxisexsrpzf65rcfq1rbz6hby6s4p7tw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DEE12C0010
X-HE-Tag: 1769634856-981946
X-HE-Meta: U2FsdGVkX1+8Z761m8F7aPda+fA/VbVgDtqT1E+dpTJ+RaQAGjyvOXjqk8P/Q7YzuaBd/J9tX52GUaesgEz9xtfy0uF+CJU2oUIx1jZLl6mw2hgA2SXv+fcRZk0ppJWrpPUjtMW8wMO8Fybx+6aJUEyTmIXkpwicJI8SYl5XYgaawv4J4bigNN7whjwi0nL6USXpB7QD6Yu6edMPDcC+PEyW3UR/abvpEfDeFKImRc7VBSHhBwa6GxoM3yUqBKcT78lz0Dar4yE+uIt2vnn1nSDhoAb4YIMSKVb8+jRP2HNYeb3u0r3zJ1SeZ6aWsrEE3Yc3U5C8pBjdFfGrIsE1UtlsGZyFCU+Rr09KONXDeebAmOSnCcyT027ItJMsC3qAbsUzOHjXuH46MU+68dH1V3zUffO7zrdnZquv3csJa+OFMLVA4J15VrRL1hoU/GWjZuCgdSx1TYJz3IGEh7x+jKxZN1dPslaMXbkGT183Q77esl31G+6PAhu572h1ph0881MyjOokRGffiiv1rshoH6aDe9U2URP67Ef6w/swr/oo2y8fbEGRcSQYqDEwAvggDAOxw2/iGkL72aW5oDm7Gsbr3cMjIWeLa8KxABX05/KBswHrDK0xLLxC2gqWNq8OUnwdOIdPwd9oxJTeBp8X70jfbzk3zvN2A5AE60clnNzx0XZbpPKUTsAT4gpxVNI0gi3pgdNTb5m6cYUoPAHUHj3l3YapX+zSxiTsOGElGwUe0330M7zS8j/oC6Nxph/EZCQ2V+1y8oR0IoSHiYutttZeGmaXoWLA+d0vBpIJ+MrmnL7vD7IUioO4e6mDtZqTAfv83ajPlHFjHGhXyvAUXblwH3ZQd+xPpkWFtElXGTXdMS/JU16XajRWfv+26W/58b4uf98D0KucQGGPjeWrgYZWihP/LaDlai76vtmd5n0yQkxehf/z/Q7ADx03XDI2cVhd2aWjmeXQCph5Ik5
 /gflH3lf
 1F0bJCRHsyipFDhhES72rk04IgH/ZHLRMB5DbUUiBvBZMtERJb76tWJawDIlAdOsmh527wSFLvF/wPWmdJmaJqma9BFqz5Ee0QRH0qLFbor5KUcATRCaF/selE8EvrUdS3ropmsECfKeVkMsiQeaPsJuZbELUEcUGuEbgC2FUdEI+r8cFpZwS827P2/rTIAsfbJWk5RlYkVacQW00ZRvzzkhOVMoLHr6PxNKlcubCFLHU0LeYB8DkPEIdTLtJwrQ9EIBs3/b/BBS97JUEwcyPOVQS1gj5S6a4oOlSNobxiMyLCzVM8qTB7suIeWDwc7s9hHlIDjmqsEjhn1jDDyqPpjnTv4Bmlq5ziyDk/7bquV89gOQajI5JviPdBTc7CsPoCM37MutjMl576AmbKGD4phZlSGNHnLUzWZKC66NYhsFiqMioX+1+GLwqdL+P+KSrRQ/B+lvfO5oRyoKywOkTQ9wy8gH3fZDOEc/s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 28-01-26 09:21:45, Gregory Price wrote:
> On Wed, Jan 28, 2026 at 10:56:44AM +0100, Michal Hocko wrote:
> > >                 .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
> > >                         __GFP_NOMEMALLOC | GFP_NOWAIT,
> > >         };
> > 
> > This will trigger kswapd so there will be background reclaim demoting
> > from those lower tiers.
> > 
> 
> given the node is full kswapd will be running, but the above line masks
> ~__GFP_RECLAIM so it's not supposed to trigger either reclaim path.

Yeah, my bad, I haven't looked carefully enough.
 
> > > Any chance you are using hugetlb on this system?  This looks like a
> > > clear bug, but it may not be what you're experiencing.
> > 
> > Hugetlb pages are not sitting on LRU lists so they are not participating
> > in the demotion.
> > 
> 
> I noted in the v4 thread (responded there too) this was the case.
> https://lore.kernel.org/linux-mm/aXksUiwYGwad5JvC@gourry-fedora-PF4VCD3F/
> 
> But since then we found another path through this code that adds
> reclaim back on as well - and i wouldn't be surprised to find more.
> 
> the bigger issue is that this fix can cause inversions in transient
> pressure situations - and in fact the current code will cause inversions
> instead of waiting for reclaim to clear out lower nodes.
> 
> The reality is this code probably needs a proper look and detangling.

Agreed!

> This has been on my back-burner for a while - i've wanted to sink the 
> actual demotion code into memory-tiers.c and provide something like:
> 
> ... mt_demote_folios(src_nid, folio_list)
> {
> 	/* apply some demotion policy here */
> }
> 
> ~Gregory

-- 
Michal Hocko
SUSE Labs

