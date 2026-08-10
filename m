Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 514C9C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498046B0093; Mon, 10 Aug 2026 08:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F116B0095; Mon, 10 Aug 2026 08:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EA26B0096; Mon, 10 Aug 2026 08:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 163336B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:56:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 252911A015B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:56:12 +0000 (UTC)
X-FDA: 85085357784.21.C4B0344
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80D9F40005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:56:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7vr1lga;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366570;
	b=LExhW2qtn+ggK8gAsfR0dkIi1diXkv0V7smFS3ITKu3TjP51Pp4DL5a40Jl4+ot0MwE1I3
	4FnIxm/Gv+oe4puVtSg237wRePmMYeANm7Q+OGWzp54Yz7zHyFejFeHK+i8ZxSCSFi2eif
	kC3+gcY7tx0/bIRUF8ffExQccKO8Mls=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7vr1lga;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPKIlGpvmXcWQjI00VD8/5BTruLNkTRTyS1KnizrheY=;
	b=74bjLXOkz/C7wBqPc2mJKjVjLBm0IgtR+ztOUwq07JI0IO1xEOZ3CGo8eylxBV5tR3EDbm
	s0vAqNMMXEcVKrUDC5slgZMnHdOG7jm8ziwn2vdXiRCh2Ub6kyHt8jQrRLOrvpEMo2rq2V
	FajVMMtoUKXV5ylXKDZlCntU5DHC2K0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C661340659;
	Mon, 10 Aug 2026 12:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6591F000E9;
	Mon, 10 Aug 2026 12:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366569;
	bh=MPKIlGpvmXcWQjI00VD8/5BTruLNkTRTyS1KnizrheY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e7vr1lgaqF30+6dpc+JhFfhBT3urAGCW5BunGeskC4pRhKJPj9hzGXL7RlFivof/I
	 Wsiwf9KmF2ZckCXD1Ep4XDYUDcJNFJxZULN7auMqvBIQnbr7DxR+VlTg24T3QEUlYZ
	 zQ8Y3U/UZjLLhWoltw+0SSfEblcbKHmq+Im2q7nc7I90c47Q76O5Y2o7B3bYv8wlXj
	 3hqParA/XlZ2NMOex/vSfx4Oke9Zhs+F9WuEdlf7+zP5SNtLkR3PyyLsAkGyhJYUw0
	 /3+Q6MXXNyu4orfM9yXs42KeDVJbgyCujPhy0kpfYYfpaSF6HAmrdaaeeRuXozOuYs
	 YghievTvXw3tA==
Date: Mon, 10 Aug 2026 13:55:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] mm/page_io: rename bio_associate_blkg_from_page()
Message-ID: <annKQgxGQvQe04iO@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-4-0899bac3b826@columbia.edu>
 <anYqSDnC2BbJXv1h@casper.infradead.org>
 <612ed1ce-e7a7-410e-9ad7-256e77bc867c@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <612ed1ce-e7a7-410e-9ad7-256e77bc867c@columbia.edu>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80D9F40005
X-Stat-Signature: arni5hw77rigt6p8hx8jtgpgaiefqw46
X-Rspam-User: 
X-HE-Tag: 1786366570-426559
X-HE-Meta: U2FsdGVkX1/JNmT5TXoBX+2qt4NjLjFKBbyqYvhsq3rlVUzBGn3+Eif2dlGXcbjKpvE20lJwP05/bWptbHcufRciVkFcECuH76RKVUj2+sLyidRxmU+wnqhjcH5CYDXJW4RrRQDtqaKcVTduuNIqpR+o8oVZoFt2GV4wmFDTqy5xQZRag5BCxIiPJKtN7MsOnDbIIQZ7TNDfE6Jd0SlA+lhJMA4qUj6yV7NrKT8r0bwyZG8qDu11yET9Dpsuvv1YplNDejzoi6pDmXAidvfBrEg01qDJI2v4AVKaP02xZRb3TLsvnmZen7HgZanAnsiy/IFRJiBnYByZocYhUMDdFqPwr6tobf7ptGYijKJp+z18VyCLM0Rys63m/Jxo3MDkDrtNuJ84N24AkwOrcuZqXUQq1FcQeHNjZj1njlWVqMFsP8dCaISJjzIIRFS3WaB5lljf8xBMv8qieRq8POQ/Br7HwdUKNCUsO/KQRGDiLnOtuRq6dtsc7zmmsrPnrIQO4Y47V4+tiwPQs/B0f5/IPQODFf8kkpOg56G8UOZBGy4SyWfGX7w2Tp9LZSO6UExDQC+RHgnsqTdpnpAUBnrH4Y25lAA8rOyuEAYLUCfHcuh7ziqNPsY4bjpZpNwd41eU2lzrTwtpjYmM2DA7kihZYDu/lk1w11Y5h9bfXp86FZlwLVpPceqxVvZSlg2MjKuO0l8HiOwPm9DzJBzQsZFgCdCFPQqGa0bT4UrEs704CRltgCmF+8N8DpT2oXn3aRvcy+HHaTohCwuOW0TwsPptWfotK3NXP8v8fRyV5fWvdFWVJRDETImXAVdbux4rOoJV2NWkCC4nWQOAOML6AkZJt6JrKxS6DxBGAxVdnSFq0v6yXb/5zaLAbPr93gq1r1m3ALGzxzt7pzvmFGbz+OyEYn/OKAdku0/OTSpCe9xaIQCIVTbF+LaA5UK/8hyaHVI6ppruAnMfi96XcD36LW3
 dT3BK/8z
 MSa1WRHD4XyAprEqZjbo8Kk/GHnDM2IAGjGnDNpgtpAqmHt9Eq8E961cQAgVBt8Kw0yQ/73FjiRyNVYGziKmldgC6Qduhz81qDo0ww7G4VC1QdoQNi38DbBMrhBlIEFNf+7cZhpzWJ2P/b9htSHCdd5E+g7qU3btgngdH5TmzSyliDNLelUEwaq67dbNiwqheKSbXdjC86/XFsarECD5AB3m0Y2v/oAirV78W5nnzor4z6vL/uF/maoIXHFMdi/jNDGkmWojLf93kffMdal3mr/IcktceRLliWUBv9mp4uHJFRPpcC+ucBbx8xL23gji2Ss9VlcjfW+s3b5HSp38YgAb5L5Hk3Pg3T5B1X2osoUqXu6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 10:30:22PM +0300, Tal Zussman wrote:
> On 8/7/26 2:56 PM, Matthew Wilcox wrote:
> > On Thu, Aug 06, 2026 at 06:55:36PM -0400, Tal Zussman wrote:
> >> This function takes a folio. Rename it to
> >> bio_associate_blkg_from_folio() accordingly. While at it, convert the
> >> macro in the !CONFIG_MEMCG || !CONFIG_BLK_CGROUP case to a function.
> >>
> >> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> >
> > Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> >
> >> -static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
> >> +static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
> >
> > It's s shame this isn't const-qualified (after all, we don't modify the folio).
> > That needs folio_memcg_charged() to take a const folio pointer, which it
> > could.  And folio_memcg_blkg_css() and folio_memcg().  That's a followup
> > patch though.
> >
>
> I had the same thought when looking at this and went all the way down the
> callchain to dump_page(). I didn't want to flood the list with patches, but
> happy to send a couple follow-up patches once this is in mm-new.

Churn that achieves good things is OK :) (but of course, I would say that
;)


--
Cheers, Lorenzo

