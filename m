Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC584D4662B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19AB26B0005; Thu, 15 Jan 2026 16:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172AB6B008C; Thu, 15 Jan 2026 16:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9F56B0095; Thu, 15 Jan 2026 16:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC4C86B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:59:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0C94C1A97
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:59:47 +0000 (UTC)
X-FDA: 84335566014.28.35941DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA4ED40013
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:59:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N/q4xual";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768514386; a=rsa-sha256;
	cv=none;
	b=er/T2gga54St+gJnegihXyGTfQsIMIJtAd03wPlEdtISekAJDKrVld14JaHoXY+KM1vM/J
	W1zq/Hy1qLEK7GEw2HkmB8V96xsG4V7+1qdqmm1gsHa0W9GXdRF0kvT+uldjLdL1qqjF/b
	q5yGQf/q/3zf+0Xs9/zeGRFNeryzpYM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N/q4xual";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768514385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2CZQFbE0Ein0moABkbgF1EXx8+kwPukVTbP7/HuBzc=;
	b=AWFjQWb9QZLXwnt20sAthRBi8vZ/UPHM7qpiojP7pzLkjYvsfnlZZJzKGGy+RHvEE1y3Au
	MpolesCP1NHn+YztYFROivvOxKIsVWwmUQ2NwLHoRjMMoF3MUAJ2RCI0BCy6YYfRm5b94C
	3V7nO7timKswv4OfiveeBpC6WTpNAPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1536403D6;
	Thu, 15 Jan 2026 21:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B054C116D0;
	Thu, 15 Jan 2026 21:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768514384;
	bh=8jlcVgdHaP7bz8GH5lHbtaAvk0c1AbsLQUU1eMGngws=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N/q4xualLsWaXEUvD6XSf0/r7zOO/Ano8FQ+Ffzu6ZAErp8MilSxrSLi+umQr5F21
	 sKQ6kBEe/R4g9DtdXLCNPGJ1rxlteINTAtT+hqKE3fZIQWBY8qO1TgRWg8bVldrhKc
	 01ZTY7URoJFmQNMdSHbSZn+/n2XkxPNBYc6pXTl4=
Date: Thu, 15 Jan 2026 13:59:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/hugetlb: Remove unnecessary if condition
Message-Id: <20260115135942.843342c483b44232b599a61f@linux-foundation.org>
In-Reply-To: <20260115211053.1406264-1-joshua.hahnjy@gmail.com>
References: <a63c7a84-99d9-40c6-93cc-6c6fd46c4333@kernel.org>
	<20260115211053.1406264-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CA4ED40013
X-Stat-Signature: qy83g3e1nk3o1k6ye7ayx5yaj7u7rd7o
X-Rspam-User: 
X-HE-Tag: 1768514385-688408
X-HE-Meta: U2FsdGVkX1+bHlrXu0oWZp/bUJquKf54l30L3VBFqImz30ucTPryW/mHiE94+zbQRZZgMpufWhe9/+ZB88fPjpQY/7qLxHc6sa597y6LmWBeKNkOheSYeJNnyhyHErk6qCywRvBR4r5wTUSdiYGzThhkJHe+13ECd/7Ymfb26DqfnIyZDYhV7Wh1t0+K59QFLnIjSH5Ubwz/VmydK7z4suP2rxlsaRfES2g6FOpsICC1gf9h2IrghBW3E872OUSvUdapyjrLtatJcURpeKtqtemcPyESFAYVTFlYiq9+zSIyCNgC7fALhaSmy/aoBUic8HJ/tBFGiez3SThrXkJrvyOg8eZwZlPXsNF3IWZlgHcoU26mgd7J2z9OPGH7++g4T5GqPV01cKGMXvjBSYcWq7Y0BYUqyzHCcf+95yIhNR3dvlm+1AF/Cr8CntFvLUaXnZxZavi9DtS2jg8TwhwNB1qqejeVkX752F9s+LLoaQJJiZxXRlfXLqdD31JA9Cu4IG6JbmJ/7Qbpxg0dyHx3pd0V+abD0z8GwmVs6UNg+666VfKajdNbExKuptdVYGv7iMGCAb9zDOUlZxkVt8NPuofv9cZN6BhV0/YgXYkt6kVEyod/Qbk32RDLzUTmhfQknha9iNl5FSbmhzd6u9FTuz7XEGi305IflSIfo38n1stiUSj6HVAcUEetNF3aNKY7Ar4fceCPdix1gTHvFIh+jWwgI+tK96rmWKxux8Aj7Ry1MqiVxwMXELSytFUQYGvt1ONbclgx101g9lR4/9RkqjQfLIpaS1bFY9L3ld+k8k6rME4LG0GlJL5bXpVlens+0XHSntbmDqc5XfmcBiBH17UgW7m+C/9GIV+un5NP62EXYJvn9FQipLdjp/iXOD0lLchHeU39SGJfJSrtYTCEkDSaxT0safdhQ2Vp2sfDxLzPiuN8OzuzrXW27uW99ED56VZRdTrHVn3LqrGug9b
 w/ZxL0WE
 ntlcZvalDSpbnNBV7fZX8vQc6oC8W8+LR9dz3ea58FXOyes2OFBp4zl3XTp+FTzhLZt6YY7VnvPs+u2r0IZJJwJQ9W2MwbfBj+leMN0A3BNeDoMyf/PZWxxDz7VM7ipgL1AFj0EyV//qP8WFLdgrMkc3D7knPIJ8uxZMmhfrhUgQz2bV6jWAyAmGBu8IQhYogb79ZSZhAFfIGJc8iKORwLiq3cXHhcdhWMzoRSGlf27MTRdrTUoh+QUdgfQnVuhTcRWTHu17ge43HA87fdhkU9UD0eqx6TevIh0Ax8Chw5mQYegWN/TO9kbs1xypF3ghGm8QV8HzGMTe6LBOAqIiweQLhYrovovCyboTC7FdzISqLK/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 16:10:51 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> > > -				spin_unlock_irq(&hugetlb_lock);
> > > -			}
> > > +			spin_lock_irq(&hugetlb_lock);
> > > +			hugetlb_cgroup_uncharge_folio_rsvd(
> > > +			    hstate_index(h), pages_per_huge_page(h),
> > > +			    folio);
> > > +			spin_unlock_irq(&hugetlb_lock);
> > >   		}
> > >   	}
> > >   
> > 
> > MAP_CHG_NEEDED = 1
> > 
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 
> Thank you David, I agree it's helpful to include MAP_CHG_NEEDED != 0.

Oh.

> Will add in the v2! Have a great day : -)

While in there, this:

> > > +			hugetlb_cgroup_uncharge_folio_rsvd(
> > > +			    hstate_index(h), pages_per_huge_page(h),
> > > +			    folio);

contains now-less-needed 80-column party tricks.

