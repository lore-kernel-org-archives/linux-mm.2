Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD9BC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF4456B007B; Mon, 10 Aug 2026 08:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4906B008A; Mon, 10 Aug 2026 08:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA0F6B008C; Mon, 10 Aug 2026 08:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2BB6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:19:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0FD8140131
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:19:39 +0000 (UTC)
X-FDA: 85085265678.15.FF6EEF2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 56DEE20005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:19:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fx3B4nGm;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364378;
	b=6hUeTjVvqHRI5LI2pTib+qDdtK6V/gCyCL6nHZOnoI13U0vcI7lvyT+TRG3qGMmib110id
	LJLMiOO/lC7ghMGzxzTHcc6F+A38N2pyqzc9PURCKAVozUaKBTOuqUqki1dEEwUmGAQqch
	bGkmuJi4IhVWe8t05Ovv9Mgj2+Ka3O8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fx3B4nGm;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/Pw86YCt5PogCXqzDBsAcUpdrMFyTr7McP0WMQnfGo=;
	b=zlO3cgR0dXgCg5RC0eEwR2ZJlbdtCUunoJIJt+yq5lFpT5FzFvv9LNBp6iGUezDmHTDPPT
	dK7KCQlk/6SL1DVJtyTvPp28egPbabZeIQNZxZtdLTOvRffp4iId/hlxv6jn68UArCd+Fn
	WLXOSoVaMGIOezwMe5BstFc58ecoLeE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c/Pw86YCt5PogCXqzDBsAcUpdrMFyTr7McP0WMQnfGo=; b=fx3B4nGmwKDfd8ozZL004I0DB0
	jwjXO1/RrOicNejnDx1r+5Lfsw1fLjHdYtoNoy+S/wRxlp9iYSUyxC7HNbhtlk6XtgYs7vq5qs8WU
	sjR9pCpm9XM2QHYiwSgWqcZhSJI07FmFM+yx5diV3JgI/FsXwz/bsXj9B+yudBiIu2RGEaSUZ6KsP
	l9OiT9aHpxVQEriHfzTeuxIK+ThrtP9iqszMrOaXddkwXz72S4kWYySAygIsM4x8wcMG9BIX/VeRz
	mJIa69TczJNUUIGjHQg5SFYr2OZ94jXuyHj9t3cp7S37UjsspYwm19n5ACbUHvG3h/C0RsyokPe3W
	FdPoEUWg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtOyO-002kE1-0b;
	Mon, 10 Aug 2026 12:19:20 +0000
Date: Mon, 10 Aug 2026 05:19:14 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v4] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <annBaxudb5hcpSuU@gmail.com>
References: <20260807-kexec_posioned-v4-1-70d57f14625d@debian.org>
 <anmb9FHMEMygENiO@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anmb9FHMEMygENiO@thinkstation>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56DEE20005
X-Stat-Signature: deh51eadydkqpkfxfkedwp1jwtka5igf
X-Rspam-User: 
X-HE-Tag: 1786364378-219738
X-HE-Meta: U2FsdGVkX19pxmUn5Lc2LKeYg5dXugL5c/4dY9BTk6Xbc746G/3pxZ901w9JB8D6lsAgL5n+AgMOtvYpsxyPkq/LKY2dT0EGSWaMYuMUAb3eYSyzeWkHOn9QU2GSNlsuZzeu0kQ44My8oUJZ1wt/NEvYNeyob7ABsbfp52hvvddIxB9hWq8aMJn56AeuvDLGaYhIgXabPdFfEdE+z3RHtW6Ujs8+A5WpBgIj3F5TVl5erXqHuNtqwF7HegVlGb7w3eb8hnNSYAH4xKUMIxi/FzwVxEjHk3a9ozB11Jyfrd91xCOACnnn/jPfUE4r2hr1DreQAFFcb4cI6JN/6dbvgkB2PeTvTnjpa7pbGfCH/CWwFQwMzpA94swsaPMg3tuBXewaO53R9oFPPHpLcPsGoWiBmkZvPNyvuYnkUz5nAMnsEvWlrUy0cBbQx2DEQ+Yo51ko2ISd8R5kPAA/jB0MgzEz4wi3F77q0ufoW5cxySclEeH4TwT2nBZwWj43q1a4eq2SejiSIFxpGvSFdOI8yp+vIGWj2jMwf0QlGdiK7fIsPErLj0ZKQtd3gXqD52h4uYSEj8iqXNG4F8GvIWTOBvMgeS03NfZlNGkfFc9cswK77f7DjDCnTDWNEQAAOGBbmpGh9AHOH0YPwG2XYxc8GaD1yspauXDGeqXw50U/QypDGbWcSdPCtEB+wwR/lHWaMYUkmlieQEos/Qlbo9Opjij17S97YU4AFp7RqcDprrWfM9FTGuCPnG57eRNH3tIDHpVCYNVx9CXRZCUq+t2v9E0yCSzrdfw8tdVMbkI9yh0E1cT2Nrp/PauaFo6t7wcLNeGAtqqncbIkWyqRXiwdBgyLX8j0mJpz8kXwPsJRQhkNmDY9XIXUFBwHn8FnvLND1CZHGnOkSXjvO34Kr82sxtDd4uU/O3knMZM8PYGFLwFO+x2GdUjlYBLaxyMWEKgtq34NkiOyJ+crAzlhbvF
 Vc8Zn+9w
 3lANVdJMRe9hsOzsYLzZo3/GCP1O/vi8OIw92RXgSgmCOxjitqA1vkVtkm4t+zbgtJROnuYiX2qLi0DC9yrLQJXNLDn5uIaEBhf1Ol5PdUipNYr8nCi6G84sl5wj+FziG8wm4c07ABGyHJEOIfI4Zz70gx80wVD2mwqJj0BzHljjDsEnNPknXVTRY/sFa6DhQj9Mmcigr0FaUBcxGT/+xPX+15pU1CtdBmpjL/8IRFi4bNL25UIJlsVecc+U24KQ5gCIilLvph4PxGad/wKolHUjVyHI4tNgxw+QrRYDK8nS71sGJOgyqk9VCvn5KhJ3B2MNXX5hULxB9JIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:49:16AM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 07, 2026 at 07:05:09AM -0700, Breno Leitao wrote:
> > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > index dc770b9a6d053..e097e980b1439 100644
> > --- a/kernel/kexec_core.c
> > +++ b/kernel/kexec_core.c
> > @@ -212,6 +212,16 @@ int sanity_check_segment_list(struct kimage *image)
> >  	}
> >  #endif
> >  
> > +	/*
> > +	 * Reject destinations that land on hardware-poisoned memory: the
> > +	 * relocation copy would machine-check on the bad frame.
> > +	 */
> > +	for (i = 0; i < nr_segments; i++) {
> > +		if (range_first_hwpoison(image->segment[i].mem,
> > +					 image->segment[i].memsz) != PHYS_ADDR_MAX)
> > +			return -EADDRNOTAVAIL;
> 
> Other -EADDRNOTAVAIL usage indicate error on user side. But this is not
> a user fault. Maybe -EHWPOISON instead.

Ack!

> > +		if (!PageHWPoison(page))
> > +			/* page is good, let's go to the next one */
> > +			continue;
> 
> If you don't care about re-using clean part of poisoned hugetlb folio,
> use is_page_hwpoison(page).
> 
> This would do:
> 
> 		if (!page || !is_page_hwpoison(page))
> 			continue;
> 
> You would spin a bit on the same folio, but shouldn't be a big deal.

right, it will spin a bit more when there is a poisoned page in the
hugetlbfs folio, but it keep the code simpler, which might be a good
trade-off.

Let me update it and respin,
--breno

