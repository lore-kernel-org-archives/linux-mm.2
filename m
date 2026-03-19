Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18D5108E1DC
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 10:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 219F76B0465; Thu, 19 Mar 2026 06:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CAC56B0466; Thu, 19 Mar 2026 06:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E12D6B0467; Thu, 19 Mar 2026 06:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F11B26B0465
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:34:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93AA8B9A60
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:34:16 +0000 (UTC)
X-FDA: 84562452912.22.594204A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EF3F18000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:34:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cYgSjJVF;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773916455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpf2NMEsLRoQYNyfe9wI7o00wiEATJc7CYv+xD+d7Po=;
	b=5rhfXFKf/64x60wbtQ9BIoY8X3i/hKdiAri/vyZqoEdFI2Qy7ausc0zBLNfhGgTeDv5A6u
	vmziqEWSsBLfQBCJSjD+r07ztWIN2kVBLSp7b6E2X8N+H835lujvgYXvp6qSUChbktgPhZ
	QvQZ2XuYe8JXDRbc+7FYAqycDuFZX3E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773916455; a=rsa-sha256;
	cv=none;
	b=uHclIhrIM5b3+raDV5JI300USDX6jUhzPRi0sBxic/qY9twu/RbBywVuixHSdnJwMH7ECn
	TCeoa8MvOka9HU+yW6L5d9PKgUkml/gEjSD74bjQ4+MQNuknfDJ8GZJgRqnnCXasEA7RXG
	jLezPdbbohpKXAy7H5G/DkLZTlZyJ7U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cYgSjJVF;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1470341A50;
	Thu, 19 Mar 2026 10:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B3AC19424;
	Thu, 19 Mar 2026 10:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773916453;
	bh=bcO/u+MyK71qo4yhuNipEu+Gh8suWmnzoZK0JR8XvrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cYgSjJVFBejJRHR6UcTbig0OqMw/oFJJ5iT6cEmyIkg/jSAUfliaaVdPE/w37UVe8
	 gUdZw/MVwq/cRkFd61ztr2xtqVDsIbnlHOFPcmu8AiaDTXVJsDIIlEt+1B4ti7sNhS
	 J+e6VnMRopr++2EpGrtoGYCaasGgpnBuXckG3DMpZIfHqmWpuxCkBSuEKVJPHFw2n4
	 L0aYjpHxkhN3dlELdvsrY47qULaE2yp+/pIyCPwkNQYFabp9HOtzh+hIn7oBcZS3cl
	 uvTY9Q1bAsbyU+Rdo/QZWpofBevIk+zHzsHlGPTaQW5tCQhJuK3oqB74d3KJexQ0Fy
	 NA+lfnOvOLGjw==
Date: Thu, 19 Mar 2026 10:34:10 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/huge_memory: simplify vma_is_specal_huge()
Message-ID: <11293efc-8c97-476f-9b65-8576c63e3275@lucifer.local>
References: <cover.1773865827.git.ljs@kernel.org>
 <84712e37721c557f887e4a405759be31a4961100.1773865827.git.ljs@kernel.org>
 <5ce0932d-e8d7-4f0b-acb2-12be43a035e1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ce0932d-e8d7-4f0b-acb2-12be43a035e1@kernel.org>
X-Stat-Signature: jerwqip8cek3sbranb9w9uyimodzsxa7
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EF3F18000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773916454-68212
X-HE-Meta: U2FsdGVkX19DHx/VC9Y/L1X1wBkTV17SHfpIX38cuRvtK45aW4Kdo8504aga76W8MVn+ps6148MhemQQazhdFNktpAqrr6hrdgbOxpLFqlHL8jyb2xzUSFIHnnToO8xQyJ5PvFRR3eJREfd3Gqltg+6q2XXuAYto0jyy3LsfAWRsFm0okx9icn7iJKITyAz0Glz78h5Be7IfxQCe+UBwOKyN2ewI5cf19+vv4HNIDCEW7ccXJM1eaHAHBgsw86O0qDDLrXTlMKppp3lko/vINx9Em6+771kw5ZdIJAP7UztsrUKvvSTKn6Ksr8oyDklJ2puflTo/UHVx4efqvuScgaHU5JKZP5IQxAdEQ5xdOJq14HOLUBo/YbmT1Trug5UaXri6mBh2WY47q7oAfYpGdWe1gI1XKcqTNfb/88pp0g/utHNWXPe/ewa0jHRncP5fYbLsRoRTvXKMEV5GsUjVQRvjjKoTlLNVO1gfF/HWAZE/Uo273QGJZ53elQKz3QseEeydz2AifXVcyZbW1JhaeGXgWqXddE1f8iIEgtVWwGhtSOj6C/UyGg4Z4gMhUWHPa9qfnuoMcGwaM9xLDPy4Fal4epXE0M6y1i5gNBAZG/vUxX8fzOyt8VYnRAzN80pKRwIWdW2NPKAkTHNZbz4AJfIzXTxt/IUKGFigOu3lrfd61VqYXAd0ZBHzh9JN3Z1E/MkT2j80t+95kaeR08yjqIZv2VSn5lTVTEOCBGznfSdUjHNebbkN5jHTUT8Kzbdho8I6Im0ykhmswZftjdDC47FjHC3p4GDKFBh8MEFa7hub3rtT9Z38Z8tHBXBWDQIsIO+jd8YNw9WLQ4PIrqLf2kvVxJe7GT9L9tCOpXjjipGESVFsOjt8rwRg3Gk/TMb8U2QUAhftiqWB0+FpVWxzQSAT6pXzlZnb8gXMzpUfN6aMxfB446ARuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 09:45:31PM +0100, David Hildenbrand (Arm) wrote:
> > +++ b/mm/huge_memory.c
> > @@ -100,6 +100,14 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> >  }
> >
> > +/* If returns true, we are unable to access the VMA's folios. */
> > +static bool vma_is_special_huge(struct vm_area_struct *vma)
> > +{
> > +	if (vma_is_dax(vma))
> > +		return false;
> > +	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
> > +}
>
> I was hoping that we could make this whole code look more like PTE code
> by using vm_normal_page_pmd() ... :)

Could that be a follow up?

I did want to do something where we get the folio and use that to figure things
out, but there's a lot of special cases esp. around DAX that make that tricky.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

