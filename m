Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B6BD2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 09:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186726B00A2; Sun, 11 Jan 2026 04:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132B26B00A4; Sun, 11 Jan 2026 04:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068D26B00A6; Sun, 11 Jan 2026 04:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9CF36B00A2
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 04:15:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C6CED0514
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:15:54 +0000 (UTC)
X-FDA: 84319125828.29.B17A810
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D149100008
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 09:15:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lsr9LR2N;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768122953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fbzqWdcF51JtPEvQIeHCnpWympvt37ttBdZXcx9254=;
	b=sjmCdQJb+axuWL2Yzu2uegBZ+6MIR9FpFYJlV+V3UDm+aIbINGjKARvnebhFDDec1K8rkI
	7B/xLNrK40EDj/Ga/1hst7lQSSJs1F59MMLP/y/1OkrWF/fyhQamVkyeoKnOcq5qQuiMK6
	hIgmo8cAhUzpa90VvLDdMGOH8ssa9nY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lsr9LR2N;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768122953; a=rsa-sha256;
	cv=none;
	b=VokQeFaKXc378SVGWhKrWNwCsoF4KgJYXwE9LSIUowtxA/gz686fMjiRy/V0Zh51D6s6F3
	X4i+GDeNpuemG/tdQiTyiZP64TGfJ62e7mxyaXsbLU8DpmCCcN3DldoliWFSCVDcnEximd
	Bcd8jSri/zQ53vfTTHD+SNTvuel8Go0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D1CC60010;
	Sun, 11 Jan 2026 09:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F55C4CEF7;
	Sun, 11 Jan 2026 09:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768122952;
	bh=vbjMLCeL3E+BHAcw3z0Wl59L/POsMXdRm2kpQ2ZLdPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lsr9LR2N2FZerJj9NxhVyb8CKoocbQ4PsJb8ZyWN2YPB3kWpaXMb86ocEufEXhGEK
	 k9//Ye9LO4LjLBOjH7/5/K4fk9yeBBbYftmk8GBWNtORRRgYhGw7yxjroz08xlEOuo
	 JsBdU60gmxDi1es+TjOmlV05LpdBMb3NL5eSExPdsbZqC18lq28V838E3S8Eh2mNTB
	 KYC8pWwXuO5CNhdg/svh/fGQJwqDN+OiOpQnx+N8OS4fkHXbQ2wZAMJgthss4NLD9I
	 UFYrnfmWqPcMuljZgF/kCUPaA/YZ6U5vLiKlYv0ux+dsduTDztQ+f5KoMKyF6uSGH3
	 ueDPvvST0BGtA==
Date: Sun, 11 Jan 2026 11:15:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>, linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/early_ioremap: Print the starting physical address in
 __early_ioremap()
Message-ID: <aWNqQd3CVx8Z_KFB@kernel.org>
References: <aa2d44c34f44c31b50285b7592ed4fd78d6f59ba.1767965415.git.houwenlong.hwl@antgroup.com>
 <20260110155721.84af2e403badeeb29c7734e3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110155721.84af2e403badeeb29c7734e3@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: c1cu3qnb6gebfq1qi1nax5yd36w1fb57
X-Rspamd-Queue-Id: 0D149100008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768122952-228554
X-HE-Meta: U2FsdGVkX1+ZMZTnz23FNtVJyUR+Wx87Oi9LyH+BvhC4yCI5IicTJDCx7wQnR875vDwRHK3LQ/ZjWO5u4CvvK200mE/RXYPoon0nkKaw9Jk7QSzMgSascOLGZwl0ewwGzdLsnkKjoOvIAIIq6ZHT1aVHJndGirkcDvPAhSXoUZZeOLuo9jPHaX7s4Vw49ix1TLHZVz0xex8PpyrI3hwSOBqRd8u+Oefmny4ehFOMdMKqCLwTh0JiNdn6XAh5PjYpGMJb33NlKwoVJ/Bv1PbeYXWO802kN09Vzf/QXajjwCPrOSt8gx4Z6RmViGF2Gw0kdlwUTM6n61P5QhNLJbGMC7TXxlND6mRJZh8Mlodjxifa1gTh9I1w8TrlOm5Ghw6LRs1rionOy+eewnnpyQzK3mUCQmnDpbX9mXk4LJQhpJpg3pFrVNopFvh1AeHnh2XAM9a89HNIfdjKp7qiv7xSoGfVCsCayNntJEfq6JwoE3IJrps0qmCMFlBbh2eGuIb57J9xKYXBoKXOMZGXC0hnUq/Z8+QGTjvY1GqF9a4iFk/7gFReum5qYPnExCuJLNox9RHlvxR/BLaVmpfjWAkiJ7IccMKyl0sgZoY3lvWgfOZH586bpTBFsfzFqyuju1xDaTvkPJymrhTieo/Aa0PosJy1GuOWqlGP45rCNXLlSKzM0Fptnye3VKk61tvvCJ59yRCY01WbILkyyyxOa+vUI0A7slpVdw3cTa43mcL9xPW3qxibqvXLfvvQ0L4IkNLq9KDCvxUEd8mavV2a6K6St3f53CWSddYaDvP95hibV/I04Tgn588F7LBJSpbe46UpcXtuIVXQqc52Pk+1NlfTa6ye6YGVOPIOx2mBbGfVBJRwN+A1QRZh68iWAbHRH8vmlO729UHg6jSYVjb3OJpcwPBodofzWJSbQcTvnXV09tmUcaF1ufzxcOwVWSpzcJf2mh6Htx9m10cbxVKvoKp
 YxL1yWsg
 by20X9rqzd1AckwD2S5q0950DmLgcPGOOa6HLh5oXldxBHps9hKDv+y35VV0ew6CJ/I7efHcW6oMqbBxkZwDwP6PJpL/3kiwhsB61bWZX1O8JUbBcElb6XGvtEwapXCjtLxBs9YjjaHfWceoOagHu0X+MRisteU1az/LraOkPJw4LZiHFpEiPorfDplBfTlomqKfmzEZ3JiiX0OJAc8qeF8EOcwaGueEojM4IFN90KbMy0nN96Z6Yeaf3Sra0GbWl2VjnsR2tfqFVmNXMkHIr1kIFIUgegu+tlq8y6Dt8ncK817dbz3cfq4ZUUZaGrGHvZixvMS1fvj3NGCGTeT0z0aOa7v/1Y6UcnOyl8rHANzdUn5eOguj5tx1vzvS6cKKi0em9UV19eCdXQ4dIda54mAgyuBjosBgEufDT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 03:57:21PM -0800, Andrew Morton wrote:
> On Fri,  9 Jan 2026 21:31:51 +0800 Hou Wenlong <houwenlong.hwl@antgroup.com> wrote:
> 
> > The debug WARN() printing occurs after the while loop, so the
> > 'phys_addr' reflects the last physical address rather than the actual
> > starting physical address, which is not useful for debugging. To
> > simplify, the WARN() statement could be moved up before the loop instead
> > of introducing a new variable to record the original 'phys_addr' value.
> > Additionally, swap the print order of 'slot_virt[slot]' and 'offset', as
> > this will enhance output readability.
> > 
> 
> yep, thanks.
> 
> > --- a/mm/early_ioremap.c
> > +++ b/mm/early_ioremap.c
> > @@ -139,6 +139,9 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
> >  	if (WARN_ON(nrpages > NR_FIX_BTMAPS))
> >  		return NULL;
> >  
> > +	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> > +	     __func__, &phys_addr, size, slot, slot_virt[slot], offset);
> > +
> >  	/*
> >  	 * Ok, go for it..
> >  	 */
> > @@ -152,8 +155,6 @@ __early_ioremap(resource_size_t phys_addr, unsigned long size, pgprot_t prot)
> >  		--idx;
> >  		--nrpages;
> >  	}
> > -	WARN(early_ioremap_debug, "%s(%pa, %08lx) [%d] => %08lx + %08lx\n",
> > -	     __func__, &phys_addr, size, slot, offset, slot_virt[slot]);
> 
> It's strange that this code uses WARN when nothing is wrong.  The rest
> of the function uses WARN appropriately.  But that's off-topic!

It seems an historic thing. A nice cleanup would be to replace
WARN(early_ioremap_debug) with pr_warn() + dump_stack().
 
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> 

-- 
Sincerely yours,
Mike.

