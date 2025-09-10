Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69405CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1DE8E001F; Wed, 10 Sep 2025 12:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA0C8E0005; Wed, 10 Sep 2025 12:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6828E001F; Wed, 10 Sep 2025 12:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1D68E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:02:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 359C2A5427
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:02:02 +0000 (UTC)
X-FDA: 83873806884.30.6478FFE
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5B892C0021
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:02:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r9+Hfggx;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/afnfpJ1dm+2ZpXwedw1BE9/QEgEwYCYpGOT6Wej8o=;
	b=Jfo08aLaW4fDzQpaSiOtXWjAEfNIjbBR0AwOKEvA1hVzGYSO4mMdTT1Ynzx6bwTy9K+IXr
	g6xC2CiZxXs+iSrq9Tl2JRL2OwMYgqLPan9hkMAqZAGH/NHXBpFbq/8arm5JeMF6WnHQm7
	FTrAkOOjzCVvkmuumwvezV8wLz/PdS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520120; a=rsa-sha256;
	cv=none;
	b=gpwkLFpodGt3PM8n+Zvpw/J8bmsfE4xY+NuV8MFCPr59SZYTtT1bP4g55jaT4+Vxdz48Y8
	KW8Vln0tUOOBx5/Xe/HVTzSUmi048HxrM6L6aiFWdzuC09BsEItEGuTEYdeV+BTmV939vP
	8GwL4w1vfx4LLhhGQv7Tim+qfXToQQA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r9+Hfggx;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b5fb2f7295so40715181cf.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1757520119; x=1758124919; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j/afnfpJ1dm+2ZpXwedw1BE9/QEgEwYCYpGOT6Wej8o=;
        b=r9+HfggxjlgEfzc67dbgMA3jGiXR05vrwbkx0f0lDPG1JPbBXX2GOAoYokdnPJbjmt
         fISYug0aA+0kHQUJTpRPo0R2zZDwUKNBjwwq6FPn4sCBECtHjgx9lJdvAzi8zdjhe30k
         2dT9OVmk7VPkKNdepY1aBv81kb3bDpuJy/O1wTE4gueJimLrSu7YBegBEiHxQL8wGsXs
         RuhNxE2RfCk7heSuGnPcbwJES/8c7pRjMkkVMakumuIh5Sf9dlVF91Ly2uhnskrMkIBw
         z7Sm/IhxLjIS5YFUFqJqfzxbEyjvH+mJ2ALdo3/fdke9MdeIl5yWOJqfJAisK33+0NyA
         alCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520119; x=1758124919;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j/afnfpJ1dm+2ZpXwedw1BE9/QEgEwYCYpGOT6Wej8o=;
        b=LtcvlzU2HIAvsgeei9dyv2YPK9bxUTWMeeN34RoSIBh/t+Ov3JmJ5lJsKtU7xz4noc
         /swuqn8Cr+dSdtbyx1R/ETQFTY2AA6T5hFR4EQOkuFdShilfUyey3fQxJvDhxgcx23Gv
         z2otw87UIzri344KIC1uKiHSk/PiFKrqGfKQeDsOhWBuamXmJLsmrdbnbt9SyPukX5WZ
         zKO/OIN1qQNj+144G/VhJ9imoUhGolwmWmUgIlK7D+SYzU8qB2Sqr2Sz/Mmj2xHFHe4A
         EO7mIfzWmjj/gZx++PIzzdQBc/R3zC4564OAlYAv4sbAYFtRLjgi8G0SLP6GDf/n3uxF
         uIZA==
X-Forwarded-Encrypted: i=1; AJvYcCWBfpHHPfkBtPCULTQ3jEX8iBKHIL+VB2A79d08vsj/q3yuLfs3Eh47PFiqo20pwa+AT6oIXKoWzg==@kvack.org
X-Gm-Message-State: AOJu0YwkXPlYTRkPrJ1J3k6X9NrjihF4pRLVJUw3dJwdTGix1FoJcdLg
	lHqHANLKw8zuQ46s7Ww79B365ZCBKHsp8OaD1yPwEp1aaDhQknAqUtxEtoUh7ib5RLw=
X-Gm-Gg: ASbGncsl/RvsYpOHmyfGxIGPdj1JVDY1Tf3aEmbPKq1FFrQmNDuH9XNk0MgagaF2xir
	xuKLYwpsJ34TwX+q/gZzAiegQZwiWJHs+FLefpLqEu2s+DNWppKkZlFUJBDsr/Ye0BU9RnTYbvR
	CypQEeAn6SwSWNwgvE18j202bDYmyHkzlJdjDKAFspnzWmf0MN+ZsPGaSdNoCTBFHYkZV9jFO/v
	08ykSr3/dLEfpOoePhlvxatse2pQois/XOPgCyMr/I6+AOgZex7qjK3RtREnlXe9VqvGtd3V+A4
	7R5NNQwWpHACQfkEP4MWHDiWSfb5yxT6J2SCVSZySn3hfkbvkwxo7+QjxjFK5mcd7IHA84ojNgI
	JelTcAG9/VN1K7FUHA40=
X-Google-Smtp-Source: AGHT+IFytWxI65pFxb5OOUKBPPF2arzO2Er1TjGaTK1hyE5BuNsItzgl4tbugdmOVSzDn4Aay1Kk8Q==
X-Received: by 2002:a05:622a:17ce:b0:4b5:f800:49ce with SMTP id d75a77b69052e-4b5f858d84emr193745801cf.71.1757520118956;
        Wed, 10 Sep 2025 09:01:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::3:1704])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b61ba6edbesm26958781cf.4.2025.09.10.09.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 09:01:58 -0700 (PDT)
Date: Wed, 10 Sep 2025 12:01:56 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, dave@stgolabs.net, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMGbpDJhOx7wHqpo@casper.infradead.org>
X-Rspamd-Queue-Id: 5B892C0021
X-Stat-Signature: rtphbzcs5gtky58uh8qm1kxz97zih3gc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757520120-370971
X-HE-Meta: U2FsdGVkX18D/BCpAmOV0spZrJ7FEAeLQgts06LC/68gZsjKKYyoMGEfi0luy6841hYiRRCGVdnSrJec3y6H76B52iCjekl96Hs1OBwxGvQ/vQoWNoVd3vqfQnSTTxFBX1fwHwLnOA1txF6qeucfmQfgVVfpRHMu3bzQxVBE8i8uodfVL3fPvz0mKjL1OR0CFwn0CnrmXnPMH7DhP0pZKcP8XjyWmHEa7IW8484lscThf8fnt2XiwoaThdSA8OcP+Syq9bsO1sUcXkL2hl5ntjokyrywFDd8i2fpRvdpS0b9/gmzth8lsrjPcfYaWD7N/VUUVOCWqMvzhdaQjNi5Lug1aIQhMo7ZF7M5ltuaUORXLrJbxUqaBhi2PevBzDvluYljNlOjeSkR0M1SbkR17glzvNcXDJ06LYlWO/XaldJ1T59giITz52rMGxhjFLmASeDdAU94D3x4/kTLnKH+b8hFYyGjluO+YukRNEHDb/d5Yl8Y6q813Guy9WcsZlXPOAGo+qKMiwyp4rv0e9CgRwhiN/EkpKJGGggRdlbz2Y6W+jHd1Dw/fz2nDIAu6NqBEQfs9wSi/6vavx78JJ8tz0gmxe1BSm6bxwvXKENk2JRBjc4Rn6PJI2Z512rM1UCq5XR9UIohRYhHmUavq/wbY/JuZK54VhkN6wIpcWvzmzsxD8kVja1443HnvvGh8rsYCb35u/BxxHUSbGvLKwvrOhb5egkFodXuCruswePrTiGKQVe2oLQ6iJBxcZ7lwtS3QAyCL/4HHpQCYI5Sl2fW8ZRR6pwAspouLqg9FyxU5Va6Ca571hSYpw/TcRfcxAgiFCX97KSTB7ykNHbuxaAf0oNr9Yzyj4QqbNu5LHtRZa75fk1cusCrY0A2JyT1n7wH/3dkbjatCHWK6HmA+oPZxcDCgqSiescEWyl1nOMEiKkfwtm1o9I39rPKgDAKrR+Ervx/zc6jMlrfEW7H9eb
 KSQT4VlW
 MZRZxRfm8PcZYSQbn/9tVzp/22HG/10mrzxmlIqETqK8Kvm2eTJ3n7yjqxYYFq8ghgnX1S8KArP212tIyAFZXJ2H6B8NgRftzcUnw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 04:39:16PM +0100, Matthew Wilcox wrote:
> On Wed, Sep 10, 2025 at 08:16:45PM +0530, Bharata B Rao wrote:
> > This patchset introduces a new subsystem for hot page tracking
> > and promotion (pghot) that consolidates memory access information
> > from various sources and enables centralized promotion of hot
> > pages across memory tiers.
> 
> Just to be clear, I continue to believe this is a terrible idea and we
> should not do this.  If systems will be built with CXL (and given the
> horrendous performance, I cannot see why they would be), the kernel
> should not be migrating memory around like this.

I've been considered this problem from the opposite approach since LSFMM.

Rather than decide how to move stuff around, what if instead we just
decide not to ever put certain classes of memory on CXL.  Right now, so
long as CXL is in the page allocator, it's the wild west - any page can
end up anywhere.

I have enough data now from ZONE_MOVABLE-only CXL deployments on real
workloads to show local CXL expansion is valuable and performant enough
to be worth deploying - but the key piece for me is that ZONE_MOVABLE
disallows GFP_KERNEL.  For example: this keeps SLAB meta-data out of 
CXL, but allows any given user-driven page allocation (including page
cache, file, and anon mappings) to land there.

I'm hoping to share some of this data in the coming months.

I've yet to see any strong indication that a complex hotness/movement
system is warranted (yet) - but that may simply be because we have
local cards with no switching involved. So far LRU-based promotion and
demotion has been sufficient.

It seems the closer to random-access the access pattern, the less
valuable ANY movement is. Which should be intuitive.  But, having
CXL beats touching disk every day of the week.

So I've become conflicted on this work - but only because I haven't seen
the data to suggest such complexity is warranted.

~Gregory

