Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0D2C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA3A6B0088; Wed, 26 Aug 2026 09:28:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79AFD6B008C; Wed, 26 Aug 2026 09:28:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1886B0099; Wed, 26 Aug 2026 09:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 470BA6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:28:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C93C11C1861
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:28:50 +0000 (UTC)
X-FDA: 85143500820.26.36CDB02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 24A1540007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:28:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aJwqengn;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787750929;
	b=ZwwNZZqOre3xsMdmvRxqAZvXHShz6qxBpxqrUdqL/fvwc1il+iabxiAqO+UL+u7EwCgP3q
	CwSPMq6Dx7vJPdjkAFbhcCIzaz/UJhuWqtbIEh6udJVnLoAXSBl2PTRdYl0OTdYRvTHcsV
	SbN7mU1ktiqL9XjCLjx9t+1JSMijVnM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787750929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQywvME1XBZPDMnvcuqkj5aII4MPfcDfKqPLaW2AAUY=;
	b=XKTNB5eBVdBHyCfZ9eJvW9Y5/IEyGsRdIM8vWRuqV6wKjDBX4/43Rqs2EdpNnRiDkrl7YA
	G8f0sesxa6x/rr/nZS+ro5Cex71IpF04PRwdfFFiwEgucKDYpNcR4fdyNsUyudFDj/onSS
	WDrdLv/y3uXuW8DUJajduI5oQBhVq+w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aJwqengn;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 477D843462;
	Wed, 26 Aug 2026 13:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6431F000E9;
	Wed, 26 Aug 2026 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787750928;
	bh=iQywvME1XBZPDMnvcuqkj5aII4MPfcDfKqPLaW2AAUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aJwqengn3k3UHyYr5hk5RvhJ18sB/0kW3OMam2evX2+l3YM3LooL4w/KpI/pn1RGX
	 gyDac3KFDpYUC+ecE74X4bfof2GSrfA6CoKJaZl4pA6Po4s1acfBGDIWAkwTr5tfKG
	 9tGOatWmT/dLzGDVyKpcqEtM3snoZBJga9a3wkW0UxY3dajO9ivv38H0ZEoXYuaDxf
	 /QisTFuQHiBhME7KXm7srtWNn9Lp+bNxobGkqp17F7QwvZnAUJKMVSwpy/vgyd1llL
	 MOCEXf73PgzDm8hXdNyqQm6n6nV3yQk+owdAllZqFFUFEqU5fPvdxbMUDnpsm/srUt
	 CIeeW6DwgIuPg==
Date: Wed, 26 Aug 2026 14:28:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <ao7pIIxxpqkJ7b4Y@gremlin>
References: <ao7Nr_FALfP7cTY5@gremlin>
 <20260826124316.80455-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260826124316.80455-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24A1540007
X-Stat-Signature: j8taim4rm6md7z45j16a3hwf3acszpug
X-HE-Tag: 1787750928-681637
X-HE-Meta: U2FsdGVkX19h95GqMlsMkANbswalBuBxvVOgSTyd6W6Q5zd4jH56tqZERatJqJNmzMdUpAzOpW1oDrsrObzRu5CJkL3Ys9/4+LRcEhWhlahhvc2SzHq76GLmNIhp1vlehrULXBS5NcQkG+qiQ8PoiXP4tvK78d/XXxZwtGQ7Y4tdWDqYxCDWBywIXkTrqwtJAleMe93fPDHIWvDumyXlzTwyVS/MJQobQ6qZWL9D4SW/BAnMhzDoVX1sr0pfYQ/yKc+/+8XIPlTpesLS99era+IXqZNF5zFBE/n6QoER65z4EVPQ0Mag+uHTwhQD3DTqYkAxx4iIg48dDWoZhJ8BI7RGUXkkZDJyuoNwY6jpqAfP9G6asrXd+SfWW9GyMKj4DfMHIGWkvG1MDYrnH5O5pmHNSnsm+Px/gcq/Qlz39eJPBEumpUci4KKw9hCSqcSh9BX8deO8AZ32OJKhcBVm5LQUN1xtfiYH2o/47kuwk/C7Qw6I6l802jE4SpU0naMQ/TgQPKcBs0+9LPHmHEsYUDrRXshfvnQ9sU6du7fByjMIX8RJi80y0Rjidbh9yD0bEThtY6JTSfd1pFxZkbWq3+Im+x+IISRSKq2C20saVUuSUS9evpVeP/pe9l6vl3UusW7m1YO5DtoshaM26xCg/4G2KveJoCuFVa6Irqs4pszMgerbcZey3jEkCKC5k9N6BHkQl7TaIC/nBrYf+3YA2Rrs5x0e6gEWYqq8AbRi8GmFGcSRBfu6WroeKYBFWDZDFoqTYpLarGHdmn8InpNw6zPBjTnBztuetVL9cZmKYPwRPbqozUPwl+Z55sgtH9w0L0eOwXxjcTFZBfZHeI++kkqdTc6JyR701n47iMwxHmDPFoqoHXOajf94NhNQlksKknoee2lwF8qpxny6AcH9pgb2askby2kIUcAvhYVPpwYoLC++JhRhO/S5XjvE9dURxoOqf1mMdPN/UKHq5+/
 Mnzvdxgi
 RZnTtuW5TbxjKh0xmV+Zrz3+aUL6q3Qwt6jWPRLmIUY8Q2uNo7E3R6q7AhAwONDsUAh5JOirwFSAJFhpJwxVIatM22EiaHlKHKVxcPy5Q/jXccEYKOqmc6uC+dZsgTIFwdJICAL6tTxcfhK1h1RgMQsDxqDrR4d49rpH/xUiju+qG7qpXDVMgk3VFqwJCSHCAKemNIxqVtyGwPA5F9KkAOCKV4ugmmkUISsqwvISCHS83h/r5EUYTkFCbHe0viIewJZ9FWLi4HcyKuMnFFVaek5MNdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 08:43:16PM +0800, Lance Yang wrote:
>
> On Wed, Aug 26, 2026 at 12:31:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> >Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
> >
> >	~107,000 words of review across 948 emails (in 279 distinct
> >	threads), counting only prose you actually wrote — quoted text,
> >	signatures and attribution lines stripped. That's a full novel's
> >	worth of review commentary.
> >
> >	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
> >	and your longest single review was 2,404 words (mTHP collapse
> >	support, v12 — the khugepaged/mTHP collapse saga accounts for most
> >	of your top-10 longest reviews).
> >
> >	Estimated review time: roughly 300–500 hours, centred around ~400
> >	(i.e. ~7 hours/week for 14 months).
> >
> >	1,615 THP-related emails in the window: 948 reviews of others'
> >	work, 278 replies on your own THP-touching series threads (~31k
> >	more words responding to review), 382 patch emails, and a handful
> >	of MAINTAINERS bits. Busiest months: March 2026 (131 review
> >	emails), June 2026 (113), August 2026 (111); quietest was December
> >	2025 (5).
> >
> >Think I can be happy with that!
>
> Aw, man ... I totally get needing to step back, but we can't let you
> disappear from THP that easily :) You've put a crazy amount of time
> into it, and your reviews and judgment have made a massive difference.
> We'd miss you badly.

Thanks I appreciate that :)

>
> Could we talk you into staying on as a reviewer for now? Zero pressure to
> keep up with everything or carry the maintainer load. Just hang around,
> jump in whenever you feel like it, and come straight back as a maintainer
> whenever life gives you the room.
>
> Seriously, Lorenzo, THP still needs you. Please stick around!

I'm not going anywhere in terms of upstream kernel - and as David suggested
- I am happy to be pinged on threads where my input would be helpful :)

But in general I'm dropping the R: for now as I feel it wouldn't be quite
correct to keep it, as I can't really give much time at all to THP, and it
wouldn't be fair for me to be listed but remain inactive.

I may very well revisit this in the future, but for the time being I think
this is the best way forwards.

Thanks again for the kind words, much appreciated! :)

>
> Thanks, Lance

--
Cheers, Lorenzo

