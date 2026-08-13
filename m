Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F091FC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 21:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63F66B02B1; Thu, 13 Aug 2026 17:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D2D6B02B9; Thu, 13 Aug 2026 17:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92AAB6B02BA; Thu, 13 Aug 2026 17:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 646926B02B1
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:14:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF412A0207
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:14:43 +0000 (UTC)
X-FDA: 85097500446.26.ABB1205
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B2258000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:14:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=saARL5v4;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786655682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zv8XNPPnogz1ZNcPTTHKlL3eOQfFAul6AyRfbh+2H44=;
	b=xHWV6oeHvqLj0LfQo1QeZiUDnJqxTSDE4Hkemi6zY+auywrvIDXeQUq5Rum+cCdp0Z5aE3
	3BDc5bWwN0MjQN8UJw3S7DgBY0TihwJvDAPohrLkeJ0wug+cV6pzY6xGbJp+Pg9h/OSYvI
	kXPrVma3ckCWjy+Q8oMYptyg76paidQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=saARL5v4;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786655682;
	b=1roQEzjKB+wG+e5K/1K1DCu6WOHVByy1vK8BJVtRuYlJFA9h3Aj6kNga+6pyXguAJAwpuf
	AF/kjzhgj8Y57m+NyGEVZLaazkNNUu7CCEcvkNr3EndiXqB6lxzcg/Hno1mbDVKEIhJerx
	roR1grcthNJH99bXrPgWy4ocrOwC9Hk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBAD543A2D;
	Thu, 13 Aug 2026 21:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82CB1F00A3A;
	Thu, 13 Aug 2026 21:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786655680;
	bh=Zv8XNPPnogz1ZNcPTTHKlL3eOQfFAul6AyRfbh+2H44=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=saARL5v4kGMd9JPRCdo7DRPiaXl+AYA0sfiASbrxxdgeQkhxqLvek3OBNSb7Y3uQi
	 8B48y76uiDEivcAGe62Si6IuKSf3Hz5I59Kr//8h8MU0izqN7LXemB4GxhOkbr+opZ
	 /+NHy5evybPIolX6JX56Xl7mUGaxJe6Mcn021Zqo=
Date: Thu, 13 Aug 2026 14:14:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Subject: Re: mm.git review status at 7.2-rc7
Message-Id: <20260813141440.2010c9d9c34a24ae453a9ba4@linux-foundation.org>
In-Reply-To: <an0F5e6I7OJWTCLa@casper.infradead.org>
References: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
	<6023e19e-32b1-4110-b9ce-5063f7976108@kernel.org>
	<4535a2ca-d145-48b7-aacb-027e9ba258c1@kernel.org>
	<an0F5e6I7OJWTCLa@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2B2258000F
X-Stat-Signature: zose3n3ecpeygktb7wa3und3zne8ampi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786655682-289787
X-HE-Meta: U2FsdGVkX198g2fYxQiv+aTdTniLJSpqAaQNgmbGFplGpWccsDMiNsKVvZAqL7G/F4CHFNsNFowDjfp1yTQ3X3v7soFl4yUttxgOJ7soFEpl9cWg1xdJ0h/H4Lb5JFCZSVGezUeGbP36X6syz2aEQQyplsTSTX4Yg57KaB6NQ6ZNn5EamM3oMMIgnwsPsrO4wQ3WN5L1e9HVwhtZTmvER7c2GV+ud0MeEnL4al3f3SVpefPXeqHY2Dk5favxwci5UmAyp030uy9sg7iTMVtomgCUSJSttqF4924v+5elsKnxOST5q+Ta97EhdrUO9/7Gujl6KqJNl8A/9Vj/znJ5leEy/2dLapFJq9ELza0zcB39xEzMuDW6kk189zyVW59ZxgG+8uSb8mS1AXcDoT32ErBOmvjeIvGa/27r6nlZcDhgfJQdefjQx+Yj1rWF5rTmqWbW63mHlANH9jkOVDw/tfzxTUTR1KNZbffnVPjq1QTu0qUg2X7sCAXuZfVq8O9MJ9eHyvZoDYUQT+MjqiaxTs215zkg+wQrNwIZ3AzHPAYZHeg7KOOszkwS0soHgGvUxSuHUK7dDVD316Vj54UlHSceY82niyXyno7r0E+0XdyJyA4KWiq+eXQnFOiFSOsmJ6kneJRUkJOKcSFC2vFonCfZLjEXiukApWLh9fpktjo/nY8UrOM2TV7vjiECv3S6efXeaDwiI0j4hdehV4wob41CdWKoj+kJEvZFB5FWXaJPfoCXxHsji2h3KktKOy2avhXPngZYLxRGG8EmmvThnHl92ULuaQsek0Mvh9qvnpryhi4F7ImlBfDIu14Kp+KAs3rHin/XRyl7+sQOAc8wnoDuuejTTjLRZQZ8CQzu8/gxl7IkYUPYCxs0bODYe49hIMJqWQWbdUDnQE3PUOYXDiJggRm3EYm9kYhmL1xpOQ1h11s5ppEG6h9X8J8oVlPo5kcYk4+aCPyLFPaOkFC
 NsrTl2mq
 DmPDJJ0FgZfiq17wRjVNWcV+qjNTZEPJmWrFM+Ph7ZbHZ9Yuo2ILH6eXQKBl9PslkPo3sLe9zMKO3gDZLxe+ofRvILCa+qtNeFbo7Banb84DvqqvxSWJ/aO6t2Y32mVvG7kz3aVH66qEIP/FJ+hHpjBD9s0N7x6LN9I0grUjgQWi8ip6To8Dg7lmWCpL278RdqXuUuv9HdNFqqsFcXwPJaF31xtMEipoEOh2d5vT958/Ki2h4sc/tYDLEN/53b4lY50ICIoPk1Ez123rvwfh2HTBXOda30WHn40ptpnJz/FfloIT7bERktHLHHbD6Cc/h9zcx5+sE6Ip6XzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Aug 2026 00:46:45 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Wed, Aug 12, 2026 at 10:37:13AM +0200, David Hildenbrand (Arm) wrote:
> > > We really need more maple_tree reviewers.
> > > 
> > >> Lorenzo Stoakes (ARM) <ljs@kernel.org> (6 total)
> > >>     "mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic"
> > >>         Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org
> > > 
> > > I want to review that. I am still not convinced that we really need that right
> > > now. The fix was the important bit.
> > 
> > Oh, good, we fast-tracked an unreviewed cleanup as a stable fix upstream.
> > 
> > What is happening.

Yes, the fix should have been tested, sent and merged as a standalone
thing.  But I'm reluctant to split a series because that results in
merging code which the author didn't test.

> Meanwhile a well-reviewed series which includes bugfixes is apparently
> not even being considered for this merge window because I spent a lot of
> time figuring out what Sashiko was concerned about?
> 
> https://lore.kernel.org/linux-mm/20260805210557.1118966-1-willy@infradead.org/
> 
> This was originally posted 5 weeks ago (ie when rc2 was current), so I
> don't understand why it's not being considered.  It's been tested by the
> people most likely to uncover bugs in it.  It's not going to get any
> realistic testing in -next because most people use neither hugetlb nor
> hwpoison.

Sorry, this simply fell through a crack.  Happens sometimes - poke me!


