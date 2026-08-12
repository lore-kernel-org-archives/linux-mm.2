Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DFA3C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FBE46B0139; Wed, 12 Aug 2026 06:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC0E6B013B; Wed, 12 Aug 2026 06:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59ADD6B013C; Wed, 12 Aug 2026 06:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 303976B0139
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:55:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFF9C80148
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:55:52 +0000 (UTC)
X-FDA: 85092312144.27.F580E8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27F8A100005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:55:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gku0R5S3;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532151;
	b=HuQq8zup7YXVB6ZpB4547mKdsXUtNpbsC6tGkqd8j88V/j5Iz62sNap2fVn5c0RZ149PtB
	ybD4mBWcz1BwEGlvC+qtnqZIVNowKULpfXvQ+5V/oBVyFRSrEKODsw9QDjLNxV3Izy6fec
	rc+POivo3q4p+buwDu4RE8f+wBzJyv8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gku0R5S3;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k5uHhnuuJb6gOsUFCBIoK7kOwlDZPmfwyDZP5sWNWB4=;
	b=eIRU8HTVs4I+cbh5MSFa+19Mi6v74jJPNr85fW6EDdOBCbGob4QPhXSCHmkBqfJYkFpcKm
	r0vERz5BF/xDT18PyLxSq+kLfkUTwW1UL947yRt1kCk46RteE5cgKaxAUHM4c9yMHejQjy
	baYWbkuPMfRZUsosP63o9H7ANyYw5Dc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4E4060A88;
	Wed, 12 Aug 2026 10:55:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980241F000E9;
	Wed, 12 Aug 2026 10:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532150;
	bh=k5uHhnuuJb6gOsUFCBIoK7kOwlDZPmfwyDZP5sWNWB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gku0R5S3IJN7+mHnFfjkJPv+WAk/hMV9qHNEgNq0PdzEpPSfxHvExumlxvpyxecfr
	 xQDTCQy2sDEUtS1WWzJTgPoGKhIk4794lzdica2x0DVZerQZ+G+19WWXIqkWSDbKCZ
	 8Pl7PbZO2DJGfenljfwkam1B2eaq1A0zjuPmN/BEQKyVh8JDpz1ZUe78FyoPSD5S7Z
	 o4Yg9yvA0ni/z2/yBHl1HXbvuNuX9rCWQsqSmx3b6GCzjBfUIe8Sv4QRpE9R+0wgrc
	 SL43KlXNvYs5RgB6W2bU254F8qOOq3nJRSa8me+D4Oi3XlinForUNNdpYVjlGFGGeM
	 6geqmJkwM9XLA==
Date: Wed, 12 Aug 2026 11:55:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Song Hu <husong@kylinos.cn>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Docs/mm: fix THP policy counts in transhuge
Message-ID: <anxRGxcLRplmYr2r@lucifer>
References: <20260812080313.330413-1-husong@kylinos.cn>
 <20260812080313.330413-3-husong@kylinos.cn>
 <anw8ASKdPWW9v86d@lucifer>
 <6e4aae7b-2c71-4109-945c-6481efde3636@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e4aae7b-2c71-4109-945c-6481efde3636@linux.alibaba.com>
X-Rspamd-Queue-Id: 27F8A100005
X-Rspam-User: 
X-Stat-Signature: pyf1ifb3ukge87jptycsqxr3knw4ptue
X-Rspamd-Server: rspam06
X-HE-Tag: 1786532150-948630
X-HE-Meta: U2FsdGVkX1/tB+F7X+pJTqHRvl96GIX2R6m6LEfBQWSz6bL8GultIY6gIm6XpL5grgfr7s8zAXGoCKG5MAzZ/j1N+Y3JFsZblxcEjaJsy3JgI5oiOQhaNQDtFKFc8mLP12UmYqI6qaX/H3ynevufvA7b9S8GhMvZz72HRDQWMnmiqcwLcd1NJ8yNXJ/A/fC+9TCflrvPKGgVs5kqA2ts8KAOGNdbqsCJx+oXLO37UpDa3dFg7O7mJIhGNSrnQdhVA9p9kY0LZduvNWnQo+Aa+A2VrVw6MtCwutllE7txjBYL8wv8ZND4v7CAJQHQg4Cf2RfnzV4eT0XOe3Ua3tB8H+/dZ2zYOE5694Oja/by6ut7EnNtYxmI2PJRakix9ywvRWTbuT5lIwVC9dlSLUpdUujINdTNpWaLzwGOvPjX+KhS6hRvPkv5fDEbThJ9vSsQ04WFk06WBlSIZdHWg2poynN7MYcB0g83DaCl7zUKGC69+MWoxSsKx8mA4fnniOq0RaLErb5ICcd0fNTSDIfwQWZsbqMAafKV5OkO9yTb8foyGOqJsJhoQpFocMdmOaMKqC/WIFBwjF5yToxuAVgmfm5vZa0td6/kTkS1taLVuXN4HEVNFP0Z0kU4SKX/c1xIFv3RKwDvycfvSi8V/b3iCbbf0XnzFGhNCeS0OwX/QL1Cp+vjm/loIl0OV4gqUwsdRUlxOBRY9ggiTYOrIVzpV8oU1yeEvXqxNARK2l1XOyvdLQo6pdRGmxarRSBtT+EUNsjAnU7liPXYLgH571oBUbQxbwNQibHg6oK0WRFHFgOyrb5CrAxdADA0fulLvdYxw7fDPShM90LszuFQRXS+65AQS2u/ivtnd3UvA7NaGJ1biys0xwLQ5lkPRQCpJpfrqnNwZuYTB35oTUMsD8LJo4d4PUazmFEYQ1d4izxFtUntpYczcridPptYzNNAVOyIhZ1liHF19QL7De7mWma
 E0a+b26A
 EGZ/LP35yBLNehd/4CRWmf+v9jlUjqE1xen26zgfK2ua4l8GAoCnAEhfjNJJoGolXXZf9xJf4DOI380C+SyWHQ57BSBV/4W2bRK3shPvLGEbKbBQRkxNyBG4+LQXPFyCIk9hYICXNk7uvQavGTg72E3RsdsQ4J5ZnRgdGnH3xaR7eHIeh0ueVrcJtfq3y9+EbjiKl0FWVXdWGrlWj4H+8LvSMEuzj2qJJmvnNJz7AM71YHKGtft7pgGkPyFtRBrLKRdig
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 06:52:30PM +0800, Baolin Wang wrote:
>
>
> On 8/12/26 5:27 PM, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Aug 12, 2026 at 04:03:13PM +0800, Song Hu wrote:
> > > transhuge.rst claims seven policies for transparent_hugepage_shmem= and
> > > four for transparent_hugepage_tmpfs=.  Both boot parameters are parsed by
> > > shmem_parse_huge(), which accepts six: always, within_size, advise, never,
> > > deny and force.  The "four" applies only to the per-mount huge= option
> > > (shmem_param_enums_huge).  Fix both counts to six.
> > >
> > > Signed-off-by: Song Hu <husong@kylinos.cn>
> > > ---
> > >   Documentation/admin-guide/mm/transhuge.rst | 6 +++---
> > >   1 file changed, 3 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> > > index b187d618452f..72e944f49da5 100644
> > > --- a/Documentation/admin-guide/mm/transhuge.rst
> > > +++ b/Documentation/admin-guide/mm/transhuge.rst
> > > @@ -389,14 +389,14 @@ is not defined within a valid ``thp_anon``, its policy will default to
> > >   Similarly to ``transparent_hugepage``, you can control the hugepage
> > >   allocation policy for the internal shmem mount by using the kernel parameter
> > >   ``transparent_hugepage_shmem=<policy>``, where ``<policy>`` is one of the
> > > -seven valid policies for shmem (``always``, ``within_size``, ``advise``,
> > > +six valid policies for shmem (``always``, ``within_size``, ``advise``,
> > >   ``never``, ``deny``, and ``force``).
> >
> > I'm not sure we really want to advertise 'special' testing modes like this,
> > sorry. These are not modes anybody should be using in practice especially at
> > kernel boot. We should probably stop people doing that...!
>
> Yes, 'deny' and 'force' are testing-only configurations and really shouldn't
> be exposed via the kernel command line. I'll clean them up.

Thanks!

--
Cheers, Lorenzo

