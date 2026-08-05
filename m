Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E578C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528EE6B009F; Wed,  5 Aug 2026 12:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFCD6B00A0; Wed,  5 Aug 2026 12:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DA16B00A1; Wed,  5 Aug 2026 12:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 246396B009F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:29:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFA5B804E4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:29:53 +0000 (UTC)
X-FDA: 85067752266.23.9CE5A15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 201DA1C000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:29:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/g+aw9Z";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785947392;
	b=sqM4VVoRT0+7sZyF8pft1tTOoRYRMv9SDxPMlr2KeCpRvKR10b89jb9keMJxp+MqSPUf+B
	IBF4Zjf0i17d7OuQj9/sWv4uFaOH1SquYyRah5VF662og+bZNttuHlE3P5NpVgXcmTmTYR
	2+m32RouAnhnP1OmtRTUa0f7D7Niai0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/g+aw9Z";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785947392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9L2N9YRxda5Bh032maEDALi7aTeAmsvta3X79RfQpo=;
	b=h4p5zmTKIeTtUGGvnLnnecrGGG2VJ/uh/xddqOmDqGkbA9FSnZmntN0YZC9LAz+zJ+pO68
	DRDz9BD6PA7PDlycluBhjXqS8wsFHN4uVO74AUmXQBA+lvgd1Wim56VRcQaBRb/b+SkTb8
	1b4pkDkySEdVMkOSLc3uNii5VaRmhOA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B86C60A8A;
	Wed,  5 Aug 2026 16:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6435B1F000E9;
	Wed,  5 Aug 2026 16:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785947391;
	bh=q9L2N9YRxda5Bh032maEDALi7aTeAmsvta3X79RfQpo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U/g+aw9Z6Bn8DJHf76ODlG6+nfC79yTIBLBiI6tvVxfuoykLHCMXCju2F8BwJHTU6
	 pj9UX58lBg8TJ+DraHlbBlPtclIhJtbxPvzUBHuBXROx/CSCt+dSsx1EDsW/z7WTu1
	 nD2XAYmaxsP2aOkXPgGsC31tRHp8vNRdgkDAD4xbGutpCPeSVzHxghNp/nNbBL6ifw
	 x8Qi8jlSJCm3ixVH4WyTDgoQOIW9CRkQ44/qjSzCa/uKz+oGJpWyMYZrl2E6DUQd2X
	 FjOE/7kO/lFz75YYlxRutFq+mhqiFdmnKBIb3ooCR9wyBEoYVCKqZWOydYGIye4S/h
	 i4bxMBl/smNzw==
Date: Wed, 5 Aug 2026 17:29:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP
 policy check
Message-ID: <anNkjl0qNHK47WTD@lucifer>
References: <20260805055544.1568534-1-clg@redhat.com>
 <20260805121524.GM27883@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260805121524.GM27883@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 201DA1C000B
X-Stat-Signature: 9itttt5ntuu1ozkofgj5w48a3hh91m9i
X-Rspam-User: 
X-HE-Tag: 1785947391-987097
X-HE-Meta: U2FsdGVkX1/G4zU81zjRqGMhrDbEtO8JVjSi5+41jQUYEWB3Rr3ks+sBm3iyQYU1BL2bnAYTg259Oy1qRoXfq89r2PpL60LeFbq8+dFL4dRc1bv5rPaN2OGL3vy0nW1HEzjZ72KnZwTBTBqI1GwQOAAfz9471nvMDGocjv7jVAu+wzAp4z/8buiQI1CfQwnMzeEThCnhZnUTZhTnPos8sn/QbbSu2qjPk9pqx4epZRnDENAguUCX+dvG7iQhYSRzqGn6nZQAisZxwsWtTrm4nTWrz4tpGLGkjV4Li6ZBjCGzpKBczIRRc08EsmqMFmXFFYu6FDGm7thHIXGRNjJlIicGG/Mrz0TVPI6LG1oJE0lCVDKndKmi+xC22dDCo4ist/buaqfYm5ximMkbUhT17DMqG2WAclbh1RIzIEkSBvs/Q7meJyohZRDSVWvelp6lssIaO0vxBpoeDddd/xiYKVJ2kDnYHwteLHqKeumyrJeQV3b6Tm10Y8WLwQBgRxpdbsXn4zeiyTpz1PTqZSNXGwmPRzr0Yta6LA0CeaDMacLITGzqiXZ5xx2mfyFfsjMFTS73t9yU4yQorOggGRk1lGXTkr/wrkt8V4kz2+NxfLUv2XCCulFZe1QOnHk+8zqU5iDC1JvvKRrWDYe0FBUreF1PkYg8meK9lrWn66O4KVAxd2tNOaKAKbqJsQhH4o3PdbVrL6gs/VjXDXIdAU9lmILKfqAtpvc8eUESBx1KlWtdXvVFsqQMYXSFNIo8u2kepYqGqSfTgFpQZnyCZ4byjAyVQPqaCZTNdDRTC1BBCOfqkJCClCqoqWA+VmTw/CgRL9CuktUDXnEkbCXrB5K8h1Tz/l5wNEFpW6RimbVb85ndMCDenMqpPVwRinIS0EjXm2cNJ97bFNC19CaEf7seCfPFyjXChddALprYTSUPw847576uVMfDjqG/t4sAyugYO8ve6H3S1ibUfQD7ZX5
 TFIu56mQ
 03h8Pwa0z0GtghJQMvsbgHRB56f0E8PbqxIlScqUqSAF2JeUb3iT6zVg+geq9xj96Ma8etAU3BA/5Lox7aMO2L+maYKZTzHsJ23lpdGQtcXynfNWCB3FXhuSPV4gFhHQVLTHqIhC9qx3zuo+EJr7oqI/XOhnxrM2IAJoee3NZzu/WVEzDOcnqYiyCenutOtj33py6AxTrtNPHlKxTKVR6AuZZM/UPn/Jjld3zrFi2eZgKcjvn3/8vEQRVKnk+/te4REaLja6cavd/jHCcjvWunUNWQciNztMg3ygahAReqhuIMmVInP8mHPDiYxOiTfVGo6ngC1ifbRPxKi6UFnQVHRQEwkNLMVFWM35g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 09:15:24AM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 05, 2026 at 07:55:40AM +0200, Cédric Le Goater wrote:
>
> > The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
> > page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
> > with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
> > severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.
>
> Broadly upstream we expect people to use iommufd and dmabuf for these
> configurations to avoid all this nonsense overhead. :\

Point taken on that :) but I think it's generally reasonable in line with the
huge PFN map changes to do something like I suggested.

>
> Jason

--
Cheers, Lorenzo

