Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2913FC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153C96B0095; Wed,  9 Sep 2026 06:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CA26B009B; Wed,  9 Sep 2026 06:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068A26B009D; Wed,  9 Sep 2026 06:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3ED96B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:44:31 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2638D1C08E0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:44:31 +0000 (UTC)
X-FDA: 85193889942.28.F3083A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87E2740009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:44:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GECD5HUu;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788950669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ef4yzVRUuSluKii/qI9TSB0cz48W9UzC0JbMj/d/8ig=;
	b=qjdwn1yF1ENWzmQSAQD1PEbtu3oyoyeJYjJvV755x0h5TGsj6NLacjCp3zH8wi5InmS38X
	nDHu2LvfivSRRZxefmvFmeuzGYklOwguEvenF4qrjTtHdm6Ay5Vo1LU8dCt6BFaoP4jj4W
	SxHvI7zqMep+DEG9UlQmBgcv4/5jxx4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GECD5HUu;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788950669;
	b=rmUPGLjF7u20uCHCb0QIYnS/3mG78H/d3Lg05v003FiPnp+Sms4wg+rjUrAjXSqb7lW+Dj
	HuHOGGhhebzkDMd8DrBtfc2YhQIzcj2F6EvgwpKrlDDo+HJ6Lvns4Xgwe9h3LC0/Fzrp5J
	kO3FdiBo2lyElNzBOZEGUK/q1eBuzzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4D6C43CFB;
	Wed,  9 Sep 2026 10:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321E41F00A3A;
	Wed,  9 Sep 2026 10:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788950668;
	bh=ef4yzVRUuSluKii/qI9TSB0cz48W9UzC0JbMj/d/8ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GECD5HUuvyNPXSw8KxwDdR1M8oKieYZqowA+LyZhHjKs3R0SCxAM5Axsm54iyjjKL
	 5splZb7VgD1a7o/JfmeW8EDWuuKTtfAPBQiLIm74uAt5u5pxHt1HDaOVcjpnqEllrQ
	 WOb7Nv60XAQ3V9Q5Jd+FH1zxH9+uKrBTh3FKl263U7nH1vGc8KKJkrHpAyLtl1FW2Q
	 hKX5hjtnox9BYevBBumPAfo3AEkmqqYnsN2NOiQD+rqELqmFcJbs4+KNoG+WJ6rPAg
	 Ty3e8aYmZc1mn2XypmXtyAdQwm7MQFMT+/WS3sQritV4rG4RwqPP2mYBmsTm/SLVTk
	 ao3vr5oyYMozw==
Date: Wed, 9 Sep 2026 13:44:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] docs/mm: describe set_memory() and set_direct_map() APIs
Message-ID: <aqE4hFXS0YHZKLEy@kernel.org>
References: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
 <e173c341-eeb0-4361-9729-9b996c3db42e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e173c341-eeb0-4361-9729-9b996c3db42e@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87E2740009
X-Stat-Signature: zypbtoypa9t1bogkmympfyoay9z33pjq
X-Rspam-User: 
X-HE-Tag: 1788950669-625363
X-HE-Meta: U2FsdGVkX1/bm9B+DRlBhJSNpc8VUZGTJCR+3eYT4ACicH61lyXLwB2QhTlLZHFXT3h0lHASqh5i1AC/WSYQWuCKr5cYTkAFiq3GMmjoXPC+o7dNHLVWO7yLoNEdldCDrF66vVrHHenUUnQaiH1UeoPrr0wJyODRfhydI2Y5W+sm7H3ePxBgM+OU/7g+2eXE/ILsjffdp3L15P5ILdnSxXmGevicE7YjmDDNHHVDFl3IXpUfdVHfhVpjElLPzNgc5oW6qV9QMi75+Wbul7tgyVt2qjI6hTgxmwQATvztinbC4s8gEWOFUMiIZNR45xMnKFFDolc0koHhordCr9M3yO8hVOE/S7KInSjck6OCXvgKULb2Y8Qnv4P1GkSmuXc8Sikh50hu0AsIe1azN2s76rK4uEQBGkCCtVfHvHemSw+ocShsFTEQzr/mswQw1YLzpsobefHN8OjiijKk94QOx+GTLnfbigx7JT7fSBj3QfpNle05njTewh9r02xrG7K9JDcD3sCX3ZuKrUjwWGsBH9TYWatwhJsjBfSBr0pizYWU8Lv+9X/EAU2QmTDSoot5GpSbMR94wxLqWHrTBCe7btOisMukoPGRURxO2lyor0x45ulQ/XhS7bFOsiMDQaipOaInkCekURuWOWa0idKOca4fqSJ8TjWOYoAGnhFTmQViIxRtoo/s2kXaN6tDoipmlUOp3GgPsUj+7WTiG9Fr7XMdR07ZYu4HJWvyy9Lkpc6fbK+tiWsH4iDntjwOCcpvMoIcUYFIky8U2Vc/MN5TMf4VKZJdNA2QM2uzoMxRQpg2zzrC3Q+9p7UmTOJ/HusbXcEmi+sT6zCpxTcozrRuAkI9ETAz7OGfOa0FUCIoOVaEzbnW6ScA8F6jzO8uG0owShNcOSMNqzlqq3iKQvUvxN3wjgXptOIx6BsXasj73aY/5YNWBz4l4LChbWAcVxPIjJBpR8mG8sHRvgWPP3c
 UnvNU1nu
 8opx8gMjYBxrmIzaInJryMXW/V1pRaBMnvEED7RuLPmB8jih0cFI425nPmsRHdB/qkcIATRcxoM43xR1WauHbbKNhHnKUcmH2rwHiyjWRtXvVFsqIvznrxwqAcc+0Opul1j+0OSreNOM3xl8+pQnfDKRCehXeCEqZrYkc+53/GNJ3PJMTZUpEUnBsi32zQD3EGRJbZ8rge0TNJyAzh8DdXEgUwWAY+s8pb223ylxLdThMzi1yT24rWU8H0jQQDrNQjKqFBJwZqIcfchQ9xbZ82zVX3Mr59neK7VqDS/D2Urv9CHozJzEjzUxyAQVYQ02e+vWdWYlwFsw2goiEivTtEJpXnA/FS2sx5dr3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 12:30:01PM +0200, David Hildenbrand (Arm) wrote:
> On 9/9/26 11:45, Mike Rapoport (Microsoft) wrote:
> > The set_memory() and set_direct_map() APIs change permissions of existing
> > kernel mappings, but their semantics are only described by the code, and
> > that code differs from architecture to architecture.
> > 
> > Add Documentation/mm/kernel-page-tables.rst that briefly describes what the
> > kernel page tables consist of, defines the semantics both APIs have in
> > common, including the parts that are easy to get wrong, and lists the
> > differences between the architecture implementations.
> > 
> > Add kernel-doc comments for the generic set_memory() and set_direct_map()
> > stubs and link them into Documentation/core-api/mm-api.rst.
> > 
> > Assisted-by: copilot:claude-opus
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> > The semantics of set_memory() and set_direct_map() are currently described
> > only by the code, and the code differs from architecture to architecture.
> > 
> > Document what these APIs actually promise, what they merely hint at, and how
> > the architectures disagree.
> > 
> > The discussions that prompted this:
> > 
> > https://lore.kernel.org/all/a98df077-3e97-4eea-8bfe-470bad9ff9e0@kernel.org
> > https://lore.kernel.org/all/5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com
> > ---
> >  Documentation/core-api/mm-api.rst       |   9 +
> >  Documentation/mm/index.rst              |   1 +
> >  Documentation/mm/kernel-page-tables.rst | 402 ++++++++++++++++++++++++++++++++
> 
> Before I read any of this, how much did you review and edit whatever the LLM
> came up with?

I never send something I don't like :)
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

