Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D5C0E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 00:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B9E6B0088; Tue, 17 Feb 2026 19:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9656B0089; Tue, 17 Feb 2026 19:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126AF6B008A; Tue, 17 Feb 2026 19:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F21836B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:16:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 456B51403A1
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:16:21 +0000 (UTC)
X-FDA: 84455660562.21.051B14B
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf13.hostedemail.com (Postfix) with ESMTP id A95AE2000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:16:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771373779; a=rsa-sha256;
	cv=none;
	b=u8hIhMVBJ0AJUXrtPhxj9F98OCqESblSAnrwT1HL1/Zd+x00QYSeXsd914RCTopLVbiBss
	EwumALUTzpsRdKPdwxjEmIIekaPzEt5nxoVGGvO45erAA0+o09hcBakXJ2NHwmmx8fS0VV
	qp5KzXT9HFQ9hoVgVYr4OnCbW0uuVPA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771373779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ecctfRFqqqU5IDfd4MSEa+PI90gGGEgsBGWlOD5z63A=;
	b=PTCnEqtoQQWjUGOsLC/dFWTair2GpE8tBGAINOZWzGPsK5hHx6eyOuOZC+O5UsImKFvmfL
	QfhqX85697/UhFhssb0WHCjNMO06oFutiDp5vlc50TBEeRn1gn1+iyNWB/cJS7GXhUuw1d
	cKBZ7rcDwI9L2o/EUrUlt4Fz4UUwjbg=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61I0FxLB472134;
	Tue, 17 Feb 2026 18:16:06 -0600
Message-ID: <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>
Date: Wed, 18 Feb 2026 11:15:59 +1100
In-Reply-To: <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Stat-Signature: fgy9mpoknmwnqn1rf1dkqnyu3np7abrs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A95AE2000A
X-HE-Tag: 1771373777-365667
X-HE-Meta: U2FsdGVkX18IU/eX1tCVwX8VlTdGdWyVOpmJpxXU93ZpXbwMzqPGypxMOxXoS5WEuVP6vigSV/AHJp4UQ3zmp4N6l/ojCDqs7jufw9K+UoU/7VPtIFTRXbliLjHPOtNcd7muHpTPfKImGOzo6jKp9BTYTEXrb9SaUjxS/JwU7wQCdnUyLtsVGPm+MAHM1Ex+7OrJTNimrCMMf44RvCitCtMROPEQO55UvrYYo81NUlGzzTHgRaMXmSJ6kOpPZPO1RmCPiNnxbspPPBCWtDwW3DZhG8I0Y0R3TAD04eIdZYjhTYjO2co4JtAwV6NAKaGRWEbx5fQwx0nZQYfA5rwDSnM0xmFG6vzfie1QvBuASHdoIRjqyAoMllqy+/uHj210AXXtBJm3zqzFkBP2VHYx0xfBC8ptDuGmal+RgspcpmG39wqb/WCYV22/I0lzKXXYgpMWOQhpUQAv97uXPPaDDTkhdid8qjvrsWxenDAguMx1ZcZfYcr8ZlzFMYF/zpMDqcCSNXuBfcVfRM4gqX+ATIDc+LiRRHHbLjjDsP8j4YMgi31vgt6IF+dOxDwHBxdXcpmwyVE+T8dFQJvLljGQ5tkI5iNm1Fl0UbjcYmBei8jcMDpZtjzLg3Lz8l4+mDpJANa64RW9TrDuwB4WWgpybyEO2puVes87dam+03V1oH6KtxEW7IdK6iDZUOTCN87BkbK3yPo8PN/hOswPwdn65xHy/1SuwUWeRHNt/iO7Y7gJFb/sqXZLAQDvEIoRUzv9MnXNh1OZfEF9UPsDGNHMyR4k98w+UObWfWv7KUgjHNDFIoAhOdxpytscqlzmKa0TS5uZMrKm3WbTktOQRdDX35klrxKflQOVA+QDDYdyEMAN95I/te814p7aWPrE5ilsGd7LBiiMeOn/T2AM7sxHRmwUbyEPKSgIJUWk+VWrKrvUhKNs0hJkq/xaZ2jnoyJ+lHX45Pemm3c+pW3mf94
 5U4kFvW3
 dZjwqT9WhsD8CQFsA/+HFA6W5UJr4C7K9u7g0doXzintH4g3EycwCUsWn30cdB1n7rR8oxHpv/4nFHhFJ7q1pptI4vx6WOrSeM8prjQ/ajKQdng+C+NBNfNN3dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-02-18 at 08:47 +1100, Benjamin Herrenschmidt wrote:
> There is definitely something fishy going on, though I don't know what,
> as the page is reserved so it should *not* be touched by the deferred
> initialization... Could there be an issue by which we incorrectly go
> look at the head page (which hasn't been initialized) of a *potential*
> compound/huge page ?

So ... not 100% certain but I see this in __free_one_page():


  buddy =3D find_buddy_page_pfn(page, pfn, order, &buddy_pfn);

Then goes do things with the buddy. find_buddy_page_pfn() is
(stripping comments):

static inline unsigned long
__find_buddy_pfn(unsigned long page_pfn, unsigned int order)
{
	return page_pfn ^ (1 << order);
}

static inline struct page *find_buddy_page_pfn(struct page *page,
			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
{
	unsigned long __buddy_pfn =3D __find_buddy_pfn(pfn, order);
	struct page *buddy;

	buddy =3D page + (__buddy_pfn - pfn);
	if (buddy_pfn)
		*buddy_pfn =3D __buddy_pfn;

	if (page_is_buddy(page, buddy, order))
		return buddy;
	return NULL;
}

Now what happens if order is 0, page_pfn is a reserved page whose
"buddy" isn't reserved ... and whose struct page is not initialized
yet due to deferral ?

Unless I'm mistaken, we are going to poke around at uninitialized
struct pages and things can go anywhere from there, can't they ?

Or am I missing a piece of the puzzle ?

Cheers,
Ben.


