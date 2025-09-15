Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9ECCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282F38E0003; Mon, 15 Sep 2025 12:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AD28E0001; Mon, 15 Sep 2025 12:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1979D8E0003; Mon, 15 Sep 2025 12:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0772D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:11:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFEDB11A947
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:11:23 +0000 (UTC)
X-FDA: 83891974446.24.47369E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id F0F21A0007
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:11:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0Lw7dm+;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757952682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39kSYvOEmua0LoxQ7LmRaKJGcrhZgHXmVU2b+XiZ54c=;
	b=4CyOvioaxvIkvscRvcxlonvrLbkIojvQPKLrv/XH4zrNIQbbhxm48KFvvu3BXmiD+9Ih0D
	HhM6mpjDUy/+SvGLkaiL8FiBZ59jLzqx2lWfL0FoWL+lHBhtofVjlFjqolfnO9j8E2tUwU
	g31bw8XoacHsXHRgPMdAVV11g98CWjk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757952682; a=rsa-sha256;
	cv=none;
	b=tA/5U68Ovv0zyv9gJIooGWV3ZdvQN/Ho6WeU4eoLNnTiJlGCRj906A3DBFObSg8NIs+88c
	Hlh7nyG/JwaxEai1unsfnNCoRLoO2iXQU88aHF4hN/0lk/K5BoY38nVDQf9GKKEFxSA5bX
	ligfH7n+8nhedlT+X4MrB7CVHe7IXJ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0Lw7dm+;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B7ED41866;
	Mon, 15 Sep 2025 16:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2521C4CEFA;
	Mon, 15 Sep 2025 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757952680;
	bh=HIvRsMJVPNoUvvqUEpteOLKzrNYK7pX2CMDYd4CRrSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o0Lw7dm+WDNqh8UKtgSTrRp1KEGb1+HzQ25D4x3Qlj1zY0y+wipo4fB8Ut2CDs2Kt
	 EO504uFug0dUTpMEOA1YXEr1kOvaK7TM+zIB6iX9Pesk0ENVyuV/l/QR6C7yl28g0F
	 DzZWd4AH4VUK9GRcDdbvRb83Yk25ik7CisUQLJDDV6pT/Uir6R7B7a/RmEqsT0KjDr
	 T+BMOqi0YSOW5RLQ6B25Gbm/IYwjC0uhlhNW+1nAhV1W02NEjCDc0+GFOPRkKyXs7d
	 ROxvsJAhIAUu99ziG6QNm1/eYdnihmAeW60wrWqK+Gd0DQzapA/1ZH4yF+Wh0g3fCF
	 6exIA62+ATVwQ==
Date: Mon, 15 Sep 2025 19:11:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aMg6oK6gaUfU9ol2@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <20250908141423.GJ616306@nvidia.com>
 <aMgcHWxsEWnKzzcN@kernel.org>
 <20250915143730.GK1024672@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915143730.GK1024672@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0F21A0007
X-Stat-Signature: rgqewmxtuxhra1ooxjja6cz4bpdmri5g
X-Rspam-User: 
X-HE-Tag: 1757952681-913222
X-HE-Meta: U2FsdGVkX18bc85Ubu1AvUwdNC+WnOfTBdxrm4g4IW6JSRWNiF/Vefv5l61jrHTtI5Agbnv6cHk/AltRh655RwkS5SUyEw/GgMZbezqm49gl00bbGVx1JEFcvvWdYYvVbnY2qE8NYUS4FoB8dXc3Tsel8LVlSgXkjMZHhSOYqcyUPVrL4/8rDD2h+SIotRNEnvSceNXbjgilQwLhthk34NVC5mz2tLY9xXs/sZ3aKPTg2sOEUALe+zSrS+dR4s1jtcAUOLfmhcFEPP8sS7QMRUSg74USljlb0AAgoaynHJGSLLoiBfRGVEnkO/1xdlmHiVngfRUS/Q9mnFQlQLA/btEpjLDcuD248Me76Xc8OMT78AfTCeCFX9N2xFK6pYNfD591KCFAIAvqUJCy2LCLvQc6gfVvtENpfklkR/+K7npAHZ3VNFIL6eFrKnFX77UHYzagbHWFXIduQBQEZPNMb2qypyGtPq4BNRiF/+wHWqvvJi8FQn5IXVjgl4hLZ2u54hLPm2kddtFDRG0JwPGPlF6BSZsBLlj8vlaxUTkn1TFaDbs69j4FU5e930VLTYqy9LWwuvyLwOyNY0pFNR4Umy0JD9q1+3roSLfP3PHu0OlfNjGvhb70JiY0+aEH1hcBxHAmdAOs40LKBkJITwiFeTfigFXiC6KbsmEkQRJzf5K8kEmuDGXatzp3S4K3+70Tminn5GYThKVTKc2sImMZq8c5iH+1t24Smd6zyu3TT/3j8wXDGbL3ird6v+ih52XZlTqDoIVBsTtjQ+HOO69lb1W75ukWp8UGHsc3LGjhGmbfSNH6c95hHmwNP38N/umiLAu8TWQAZnIC9jRuv7AG1nGAPPHffN6fr8utD3YiG8jALIffGCMsqwheIqMBVZhpbDC9WZRYFSGcv1kmgVOmlIIQrrJrA2MEntjWUwl3O2ekzPGfQQ6RGOu5XNFsEAb9wARqqWaAcxzBcAyhAHI
 ejyrXgEK
 yem+5xckOMHM+aelZkVQDwUsF/n6b1kL37pBHS249lDaiwPeqpC5ODLejWmbAUxytYiSVNmVxbPOBoK7UjvJ+FeNvKbf2tbI53VfYlyFwgs0KP7Zj4zRbgrvs/5U7cXq2Kb6knyV4Ukoby+EBxeNv0HuhCcOtUrQAOm8Pf87QKV1tum0IAgmIdhudZUdosoC86SGEcJxjineJFROX+3p6oHjp3G1+LORU9Ez5GSrDKHMBcAXMhtmOvorRXQjj8cuJWjIy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 11:37:30AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 15, 2025 at 05:01:01PM +0300, Mike Rapoport wrote:
> > > kzalloc() cannot be preserved, the only thing we support today is
> > > alloc_page(), so this code pattern shouldn't exist.
> >  
> > kzalloc(PAGE_SIZE) can be preserved, it's page aligned and we don't have to
> > restore it into a slab cache. But this maybe indeed confusing for those who
> > copy paste the code, so I'll change it.
> 
> It really isn't. The kzalloc should be returning frozen pages for that
> allocation and the restoration will not put frozen pages back.

But we don't care here, we free that page immediately to buddy on
restoration.
 
> Jason

-- 
Sincerely yours,
Mike.

