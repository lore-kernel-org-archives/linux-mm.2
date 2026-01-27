Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A71D2FEF9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 23:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B056B0005; Tue, 27 Jan 2026 18:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEC56B0089; Tue, 27 Jan 2026 18:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6D66B008A; Tue, 27 Jan 2026 18:29:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 199D26B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:29:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB3C813AB36
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:29:08 +0000 (UTC)
X-FDA: 84379336776.28.1DBAF15
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id BD9B84000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 23:29:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G7eXHI9G;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769556546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggQbKrh8ZyuooMxE9NUhGxSmgLEA7sxK0OqhmRkzBEY=;
	b=xYNwMmWAYGBGfD6UHR8Zh7NKj/puRlSm4EADzRqLRrmpba0akWLaTcmwbb9FAWDws3WMss
	btOTu+CDoe57KEECfI8+5EorQcbUWgjxdldi5hz3bfZ/P7oub3neajGxUoFolXAgNmg6yG
	T9VQJV1005Il7YD1KYSYWKeO7+MQ++0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G7eXHI9G;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769556546; a=rsa-sha256;
	cv=none;
	b=NG84sdO+nt06n2c9fixXza2rF1d3jazzKwYi7e9nat0sj6QdE4xylGG2Z1ED6Wf/UmwS9K
	HMRZYPBs6ADSJrPQ8qEp5sROO/1wAHq9ODyj00BlvI3tSMkitRxZuQo/JxqfkHOa5PdkxA
	j1nTHF/3xOFsm2jP79dD15dH09Id10A=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0d06cfa93so14955ad.1
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769556545; x=1770161345; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ggQbKrh8ZyuooMxE9NUhGxSmgLEA7sxK0OqhmRkzBEY=;
        b=G7eXHI9G11sGgStrzwFzOwLMct/7J4/ffoxoP0TVs9oCKIFjDieCg6HXCyvOBzkFLw
         +1V0et3x5UeXa7ZBo3HHFs84egjqLiVOVrl7oYNdFoeG6VnD2RjYzaTHX1BTdDKU9eLs
         7cQFesV15uru81V/s/3Oc8dOctKwiCmRMXYaNfQPmQIwQ8CE3urajNE2iO8uuL82zYX7
         JarG3td3UV+7dg8lKVFekrRq4LTIwJbLogDlZqkRL+WuioiDDJRH6wlXmjOH4IbOmwjw
         Q11UxZVwGi5jZGpT0xmcknWQ7cAZF+KOFNO+3RwpeIxWIKRb1g1W/WWfG+HXVgLL8PZx
         2kXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769556545; x=1770161345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ggQbKrh8ZyuooMxE9NUhGxSmgLEA7sxK0OqhmRkzBEY=;
        b=IOnLOS+2NVVi2XypGvieKsJBkj1vDGOFYLHkVa4PplCkOd/NPKaU6fDuorRYjkvU8i
         qgkQtzeCRqDEIfcOuaNEl+wD4hvALPqSsVeQfRSP1Mljegv3yPbo2+jkCaGt0KVM07HS
         bd3jAFjVbD3Lal0105nw6ApjuJO1igEAQwnfpdEX51sxo7+ek4htay1lVJfJ0+0bPBgT
         HZ/sohL3a+6bXg+RBDMw9P+eAyLoqAhIB7Hj+OWacil5dHJZXp6LRVr2WfQLl14Rx+dC
         o/+7c3KDVbMgF8BNs79tXyq5I/0UM4kS3cn9Zet39GianBRWNzWc96r1BdZT0ydbjUGR
         lZWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdtm0A8oDpDflEAGf73OSU814yayqP+J/hEtnjQ4FX65XazRVSkVlX7VpCmA5oe3rFNqk9RXHoxQ==@kvack.org
X-Gm-Message-State: AOJu0YxXIB1b9ESfr/CcYCE1DR1ucpdPP5HTJxLEfiqzziNzNjHg7Rmb
	nxfrJiHbamx73B27dTBhqI1S54OMzq6lfsU+fAd37WdNPksHPXIRSpyZ1RXpP1Qvqw==
X-Gm-Gg: AZuq6aK/wLxiRGZR1t7omYqH9RK1mG6oC9NrBGO0ZGU7AVxXfO8kPtfU817Vt2yOutQ
	FEKWrnoph7oDypgbV/fblbNBjNq2Pf+kvfU4CG58ZQHl+QLxRRwVI03hE20VgvHRk95HCPCyHuF
	IInP1NLvUKCpLq964k92+VsWqMd4jJ8dvXtAxm49P/Wbmk4Np66VMSUk7VwzBfvhUm/Ln0SdF8x
	EfgezPwxVTvi9nqL0xqpYm5VCI54TOcTozlCPQ/QDIjDTf+p6pmRchXHVcLMA9L6c/oMwL/S/lR
	frQmc4WjheybpQjLq96V3OplToZxdDCr25w/qFD69jdYCloCGCTpuRoXX7t/Plx8G64h+K9VIJk
	5eASXUziZyYJ6324Utl5PoE6TIpjrjCrQoOwAEXjrTiordrfwLwNdD4Xtk+0txIfVnagdkhADGO
	+9FQ5hEcQGcVKXCMr58I6oBs1811Nne4JQbx/i94QcrX5GsmlTBQ==
X-Received: by 2002:a17:902:fc4c:b0:2a1:3cdc:771f with SMTP id d9443c01a7336-2a870b97452mr3881485ad.20.1769556545254;
        Tue, 27 Jan 2026 15:29:05 -0800 (PST)
Received: from google.com (130.15.125.34.bc.googleusercontent.com. [34.125.15.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b417394sm4031265ad.42.2026.01.27.15.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 15:29:04 -0800 (PST)
Date: Tue, 27 Jan 2026 23:28:59 +0000
From: Bing Jiao <bingjiao@google.com>
To: Gregory Price <gourry@gourry.net>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com
Subject: Re: [PATCH v3 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
Message-ID: <aXlKOxGGI9zne8sl@google.com>
References: <20260108101535.50696-1-akinobu.mita@gmail.com>
 <20260108101535.50696-4-akinobu.mita@gmail.com>
 <aWEn2ODG0gyej0Xr@gourry-fedora-PF4VCD3F>
 <CAC5umyhoMi_J_Ford2M_1fB-qCuPEDopAK1OF=AisZyDZ8duJQ@mail.gmail.com>
 <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXkfBF5bdnTZ7t7e@gourry-fedora-PF4VCD3F>
X-Stat-Signature: 7srg9pidwui5gxp1ketaikfxkzhro8ad
X-Rspamd-Queue-Id: BD9B84000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769556546-384554
X-HE-Meta: U2FsdGVkX1/AXKCdhBc3JfmLji59I88BTkcyfbdjM/T+X6+SYKEsxtGnH2fUv649gXDuvoeVF/gJ/J6CPHAuEMPvdwQxOCaIkw8FYvXXMoNjmULojCqDM/4F7CScOPPLnyp3hOKxzi0/K+m0W2dPblIiUpJ7J+YOffjSXwLB47XepH95Fewi6HGP0oQIRnrZfyqnXQ8WWRMSy5FTjLQogZ91FJpVYF3mjaTCZq7cPau2hlN7iXlGPxVGAm3BHZIL5Nrz+ibQISso1lmkFxOyYPuJe4ETSu408LqIOlcTuRmV1WboXAA8a8RWZP6dkLhPzMtZsA48Bcgx5oPcZKDQuKq2ji/c43ZXKnZcdXL1S8mRB8aie1MmFTqugI57KTab8Ni6ydxRfqIVUZaArz33lFgPL9rv17MdoDIzPG0p9xiqU+2dB6XPuBTsG63QZsn3gQoQ1DDkDLUy9bEXtWL9eOgnW7XtRG+wuL+7TWM7tOWChSxyG4ZGwv08M1SqaE4xL0fgH28qaXRrhjBhlVAdcc6x3ByuBB4uBcx+m6MJBXkKVI+LIUiHcs107Uf3XU8ChMkAvLl7bw00zkyssWQE3Jfvgv4NX1FTftMXI6fe0t+g6ErlraMCVsnsp/Q/ATAWlxcqIPW5Q9l8z4QAJu3YhNox3nA3iGESIGOoLG43M2M85bkgj4bmapI+5/I2CaWYNGD3rym7lS4lz/E369KMfeR7Hc2i5Zq6J9gKuZdYHTuRp5Z7xPawn5fjfytkRzZ4fVw5y/vlw7lFHD70SmYaheWjw7WdHebHNfL8XdchZDffE1PNMFbREmISpo3StO6QGjHdWDO/4oRRiz5wChTTS/k8yJxtfitWsYVtfGEAJlpVvTrTX+EeizrP0Fh2lf5DZsZTlQUCtWwgTc7uYyasK8vM6Va/nX3VRHfGFJaxxzzYpjFq/R/1DaEHDfRthFQqNhd8nGe96syb21e5hXU
 f+owyDdr
 AC+QuMCao/ZvaNCSivYx+buVErVwiIvq17vyC+MBRFDfGeylYKkv6GPaDKQVDeOqpCBTtXJrLrZVC32tDE/qQ+Kygt90dNBDbN/7mSupLFPzPpC9oHb5xbupPz9rtgtoPxH2PXgJbe4Y+RZGYUzBO1lK1NO7TI3X4XO7iwYd0MGvjgNdUDsSPxjkAIns1YSLc8h5E2SGmO7Nkj4Po5Pv9st1c3FAndkeTb98TZGX5FCaxc73eSjv3PVtHzQKX36n3SYef5DeEUzWA/9308AG7QxmENpfZPvc/iD6pJobzFTKMgsbCxEoFA19mHf3E7+lkToi9s48juNJMZ5lVQK3jVN4I3DtIDqV37oMT5qAIqPxjpD966UyU83r7yWM0UVHWElZ1eMiegj6URpR0FWNfRU2Nt4Nff1cJshtvRB45MfkkzV7cCGZ0KkBmqig+D/2HUdG2sxTM6W9uf9zCGfGDTNDFecToAezhHB9epfmgwtDYBj+CqdswYZFDxmZ/NNxbzh0cYu6JXeQ5eb1OpNQsgNzPmwHNy/pOjU8LwxBHlYqaSE4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 03:24:36PM -0500, Gregory Price wrote:
> On Sat, Jan 10, 2026 at 10:55:02PM +0900, Akinobu Mita wrote:
> > Since can_reclaim_anon_pages() checks whether there is free space on the swap
> > device before checking with can_demote(), I think the negative impact of this
> > change will be small. However, since I have not been able to confirm the
> > behavior when a swap device is available, I would like to correctly understand
> > the impact.
>
> Something else is going on here
>
> See demote_folio_list and alloc_demote_folio
>
> static unsigned int demote_folio_list(struct list_head *demote_folios,
>                                       struct pglist_data *pgdat,
>                                       struct mem_cgroup *memcg)
> {
>         struct migration_target_control mtc = {
>                  */
>                 .gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
>                         __GFP_NOMEMALLOC | GFP_NOWAIT,
>         };
> }
>
> static struct folio *alloc_demote_folio(struct folio *src,
>                 unsigned long private)
> {
> 	/* Only attempt to demote to the preferred node */
>         mtc->nmask = NULL;
>         mtc->gfp_mask |= __GFP_THISNODE;
>         dst = alloc_migration_target(src, (unsigned long)mtc);
>         if (dst)
>                 return dst;
>
> 	/* Now attempt to demote to any node in the lower tier */
>         mtc->gfp_mask &= ~__GFP_THISNODE;
>         mtc->nmask = allowed_mask;
>         return alloc_migration_target(src, (unsigned long)mtc);
> }
>
>
> /*
> * %__GFP_RECLAIM is shorthand to allow/forbid both direct and kswapd reclaim.
> */
>
>
> You basically shouldn't be hitting any reclaim behavior at all, and if
> the target nodes are actually under various watermarks, you should be
> getting allocation failures and quick-outs from the demotion logic.

Hi, Gregory, hope you are doing well.

I observed that during the allocation of a large folio,
alloc_migration_target() cleans __GFP_RECLAIM but subsequently applies
GFP_TRANSHUGE. Given that GFP_TRANSHUGE includes __GFP_DIRECT_RECLAIM,
I am wondering if this triggers a form of reclamation that should be
avoided during demotion.

struct folio *alloc_migration_target(struct folio *src, unsigned long private)
...
	if (folio_test_large(src)) {
		/*
		 * clear __GFP_RECLAIM to make the migration callback
		 * consistent with regular THP allocations.
		 */
		gfp_mask &= ~__GFP_RECLAIM;
		gfp_mask |= GFP_TRANSHUGE;
		order = folio_order(src);
	}

#define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)

Best,
Bing

