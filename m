Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E79F483D7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25F06B0005; Mon, 23 Mar 2026 14:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6D46B0088; Mon, 23 Mar 2026 14:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DECFE6B008A; Mon, 23 Mar 2026 14:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC46B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:57:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67C80140CCC
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:57:46 +0000 (UTC)
X-FDA: 84578236932.03.6951F2A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id CF2591C000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:57:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VoyXQGIO;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774292264; a=rsa-sha256;
	cv=none;
	b=8GThNbmdvK94VyCiPnQp8zll2NEFhy9GFRxPkQ5J2vuiiUAKBQochf0StvyJDkVBPUxfGK
	yKkT/rH8xIVwr/ca4B83/eFneu6x6PqFLrvcPnazqXB/BBbx2tpyP9neD86/kkwzMsUmJB
	njqhIam+3HvW128ORtBkGvfkRA//ISM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774292264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGqvBokwlQB1Y/uYMahiXGhIsZdEjFgL1tMnTCpwV94=;
	b=QpYE6EbTgKpunzDu1fQ+dm7FkDvYGnpiuTU53yxioRwod4JKrn8OE72D+MLn3h9vJ2kGjI
	J6y9Uo/kTS5rX1Yo0QBhSUhEN9PNhS/4M3gm3D0K14ir42VI+9cBmPZ88mD60YSml7K1CV
	qnKwWxtMJmuBuS1YLO09JS/e7cpw8LE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VoyXQGIO;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AGqvBokwlQB1Y/uYMahiXGhIsZdEjFgL1tMnTCpwV94=; b=VoyXQGIOWMvBUFFKdo38tpq+Gg
	0tIRYVjohRz4OtcDSA0fj4OcatKcnyJnYECt/iWZrreMTMFoMT9rhGayxw8vhFOG2OcjUAjY18RMw
	7cjX9sl1l2jO66NTKy33+d7TTN1zTfnYx42ANJ/ZNiP/VN4b4HDXav0tnKgfGDtgalwx1aiqYW2DI
	UMOMNS9ntQmpq/v+f3gl/s4XiAmdD4AwStIen1bGyUhMn3BbrAc5APWdD4NFrp+onfI4zMGPd+bxW
	7EJx1X6zGSQlOhxgAppRRFkeimC2yTC9fVw0HEotoOnxBe22fa3Jb9JQb11ZXa9+zEk1vjoS9vHKy
	4Bpuv4Iw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4kSx-0000000CiAc-3HtH;
	Mon, 23 Mar 2026 18:57:31 +0000
Date: Mon, 23 Mar 2026 18:57:31 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: rename PAGE_ migration flags to FOLIO_MF_
Message-ID: <acGNG1T-4UBdvgYB@casper.infradead.org>
References: <20260323141935.389232-3-shivankg@amd.com>
 <acFSTlF0epHIrA5v@casper.infradead.org>
 <a6f19c86-4c6a-48c8-9dc6-26f66bb6dd88@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6f19c86-4c6a-48c8-9dc6-26f66bb6dd88@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF2591C000C
X-Stat-Signature: en3stui6bhetop8eazuntgiig8enhxng
X-HE-Tag: 1774292263-13616
X-HE-Meta: U2FsdGVkX1/4Dux/OBeVwK2ImlFukrQmjnruSRBx1W9539H2p3l078X6wjSNwBLej/p158+Z+T4q046jvG1L75WtkcREVcCn0gaxoh6NtwTkWwm0Yu1B0XjsnEzPhjKuoW8OfRgE5rKodHVzgc2FeaIPMBjON9392GvRj8QH7A2nP8irFXAOx404As1MLuFZamB+Z5rHlbi+vQrAf9AxrBjO4krIBhZ+U1xSWgubYSKKEwBMSoElB1KBa5nmxQBw8BCv3SaKUvX6LX+L648Cu5gFro1pFHfSTIil1BuUMIBSojR2x3zHzXR7CgDuKxX2k67+TkjQF9v6xwSQCgQTmIkv6wNz1pXTJeHpGlmqbPiWUDQBRstNfsVo4xX04KnRBmoBItEficoDibUW9qrheaZpuuF3K4l4JHR/N0lStrWPKy4zYUq0k88axQyrFfFhbemZgcbZfMOiKqLSgNYKR+n/+YmDfWlLWpjiIb12aiVfU28A/sxYATS9GKlVolELfC2jZGKtZIhqInWpdqftNVQmtwzi/EEEXxtxEg1mElN7KpPiglzbh45ExKfxqJhkQ1X0prqIOB/g5Y/gjqqkPqHwK1ZEDCl93bEjGT6XH9xRs1BbiSSvLO8SlWaH4kcs80v2ZAQ3uMXBvWuja5wy9w9Ju1U0AXWm6c7cDQXRA1lkoVVuTDYv8IYdhoVBCBvjHQjEPegsSVYcmJua1iuvmpuGe7HuG1q53zOKBDYZeuawoh/rbQxKsxRj22WlRYW0B8me+yCrwIhQy5owaUmveqyQ0kxGLyTvwTztieOjUQ5JPbaYAUOrBXjumPNN6m9IZW3WaYglC0p0+JlAy20BzwakPnXmjw7QSepmDb4CoDmIQ6kNdHnctFJ8VO0Yu22Yrn2zKQ8mv10FZ46y1FOsFxB9tc3XT8HMIruRBxI3YMNR0Eyn2yQKEs0JcnQ3ApDpeBkpZzrubV0GLNM3xXn
 XIC5YJdg
 I+qGRz1W+cWQ1tP0guDVahGHH690ZCiYqlW/vO3xg03Dpu3fZrH6vCPevzAhPsVCHxZrMIaGYKrYLJlXjRvzx3Sgri+aEiBzcgZbseJjeOJnsQ9b/RKqSOtKJHscoI7MuV96qmiwQgkZA8U3OE31O2NB7cSL97kpxqbFgg8qo/NlJV6j0mw2n5i78KTPpvV6N4oyBXZyzmSHNhzEXBh26Qm4XKq7IClbecTYBO8Z6Kp64hxe4hrorjCSIF6F1bVsQWUYZpgi7cPWMbeefsF7D411HDJE7bYvWi1PTlSRfA3LMrP17wC/wTUE6SiHtGPDPxzk/NCxsmr3lH0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 04:36:38PM +0100, David Hildenbrand (Arm) wrote:
> On 3/23/26 15:46, Matthew Wilcox wrote:
> >>  	if (folio_test_mlocked(src))
> >> -		old_page_state |= PAGE_WAS_MLOCKED;
> >> +		old_folio_state |= FOLIO_MF_WAS_MLOCKED;
> > 
> > I mean, this doesn't make sense any more.  PAGE_WAS_MLOCKED is a
> > sentence that means something.  FOLIO_MF_WAS_MLOCKED doesn't ... unless
> > you imagine Samuel L Jackson saying it ...
> 
> :)
> 
> PAGE_WAS_MLOCKED was suboptimal given that the names overlap with things
> like PAGE_SHARED or even PAGE_IS_PRESENT.

PAGE_SHARED (and friends) are misnamed because really they're PTE flags,
not page flags.  Then PAGE_IS_* form a namespace for pagemap, which I
think is fine.  These are PAGE_WAS, so a distinct namespace already.

> So using some prefix to indicate that these flag belong logically
> together makes sense. Even if it's not a beautiful sentence.

FOLIO_WAS_ seems like a fine namespace.  Especially since it's local to
this file.

