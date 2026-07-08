Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A530C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA9166B00AE; Wed,  8 Jul 2026 04:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A876B00AF; Wed,  8 Jul 2026 04:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71CB6B00B0; Wed,  8 Jul 2026 04:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7FD56B00AE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:26:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C8141C81EA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:26:34 +0000 (UTC)
X-FDA: 84964927908.17.42D1774
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8FBF6100003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:26:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDbBrbjk;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783499192;
	b=NDKxDu0swCrdHn+y+i+espD3y6dLbyP+FGlcUf+0tfPXiIwnSxpRx8Ca7JCXjm47QMbS/8
	gFFXR4+4KQkRDQuGpYYVuHAMhinHGehrGUd7QOXfJJOwH8vLCNPsggoJYvHuvPu5QISGqh
	Eb+Ss4T9f904zHrDvGkjPiMiaVzhXKM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDbBrbjk;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783499192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfIXZqSgSsUZkySMKxA7SKZcwl2Zc6IkJcaMTw/YlhY=;
	b=h3QIq2Z3pp9WaljBqi1FZCaAN9Dq62wMcFyLXIHiDV9+72h1mnv1pma44IOTJ6mJQoxZlk
	DQvwQS28JvRdRf/P1BNYfC7KF0yG879tA/4IR07txUqC781k2ImP8FmzxMhXdSAjWzGWys
	3P29SSooSdhfGzbvtzAT91wfy35MdsM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C195941475;
	Wed,  8 Jul 2026 08:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0731F00A3A;
	Wed,  8 Jul 2026 08:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783499191;
	bh=KfIXZqSgSsUZkySMKxA7SKZcwl2Zc6IkJcaMTw/YlhY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PDbBrbjkPqdVS5TD0vAimCfeEp4blPivZriBE2HX7XOgXGaecJZzeftn4t1gYCotr
	 5E6eDrdYBo/GmEX8RK2v/RQVfYsmyy6nXiGDXFTSudi7JSNSsl4ojeIhdeDGinlvpG
	 x6UQHphDexQbaiVQpmGW839TpNkCGA5W1JMz2kvXArr4esBX3VTINld1V360zcGRU/
	 ITdXfNUJ3yxcteVsj1F4XfypLdJb5KNkkN0An3Wn44niXV7CQfSVddpg8gWIH9Emla
	 FVeXYahfi2eoj6Bpn7t3vT0XK6O2mjtrRjQuWG53acrfbthLXqAGinGGaXinBzKtic
	 sSxE11kH+/Ijw==
Date: Wed, 8 Jul 2026 09:26:18 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Sourav Panda <souravpanda@google.com>, muchun.song@linux.dev, osalvador@suse.de, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm/hugetlb: Dynamic, NUMA-aware HugePage Cache &
 Free Page Reporting
Message-ID: <ak4JiBcvi29sYx0v@lucifer>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <9624988a-366e-4884-9408-3f3b88c27290@kernel.org>
 <20260707062428-mutt-send-email-mst@kernel.org>
 <b9a48d89-74f1-43d4-b7bb-be988b6855c9@kernel.org>
 <akzZr2jfJ0J8zox4@lucifer>
 <20260707095843-mutt-send-email-mst@kernel.org>
 <ak0xWgpJPSaNWPsl@lucifer>
 <20260707152755-mutt-send-email-mst@kernel.org>
 <f9bad4b3-93ee-4daf-84d5-97f6ca305240@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9bad4b3-93ee-4daf-84d5-97f6ca305240@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8FBF6100003
X-Stat-Signature: pwczcciye3r1z1pumrikodcz5twtmtk8
X-HE-Tag: 1783499192-280748
X-HE-Meta: U2FsdGVkX19cgT5RiQ/hWQo/wUmUT4O5rcJNeFmQ92UOb8EzMfttnxUPPc9vxLoQyHUfOJwxxqZ+6y5rQ4LSpruoYeU7HvpVTq/XDgnkX+CD/JoezGpa1qNC3RrVXvwfA6gAeA98z3IJwFkYERHad5tguNpmmgaxAOe7eVuL5EUju0Uj2NfdPzJsJV/ee5tWV7Pbljy7pOGe4zmiSUcLiMZ2WuSvL26eqpmZQXw8x1+h+xvZ4SluiLOtJnIdIYkd/5ELvzchHYD78qP7uAJIBZvO5+BWodgMApHb4Rd9b2VBPDDiUCWQya6QG6v4JY4KenXGMpJ6DoOScinGYlS7n7jiX2CRqXhrAJkqPSVjSy+OlQDpTsZTsL3bjkoF+/l8mtBp0WRN7ZpMUB9IhsiZWg+2rz5+P7s3V2nW24JhNEASGsshLPd7LXH1H48E118Ud5iTnPqyVg1AaB4wqwvtqKiHpWb8/11bsIntaXgfy/1oIP5G7GgiI5EhmjHelygSanPCJyyFefjuaCt+FYiQTC5tEJuJ48ObACrlQhRUi9j6VTWyNIq/YStCW8/mzjhlWqT4CPy8QjOtXXxog3ZSkU2Xrv28RstD9YUqxOox11ueW+3ugR6MxoexUet5tlxzQl6lwCvZL9JMoQuqVZ/9h8dTemU28fnG7Bvmvwev70HIG9R5c3L1Vw9X+shtv0CpMP0q8FFjRRT/mmCG96R0VVH5CxaqzT3UFwH4vHkwyQRo2pgQ4ATDovQT4Yimd7vhQmqiJ1MNVWyztTQsjFcMipGsAkqLC1AopzxslRylvEGCMVOfMps0ZU5OrM85U8p4beSdbPdnbajXjlTdO0UbzQDglatWHY63eo2Uk8crrYH/eGyQ0O58jPcYDm8cYoiQnEhwaMlxzCxZAYBdYHCzhn+6d+s9YnkERByPgXnU1Lqd7zHzCl3aTMLqhynmw6oau8y3dM/obMSFFshX7up
 V4rnC9yl
 pbU/np/PB+iCHzhoqy4mNS7uPiGKGhRAs3Os9IDdjwxkDml2+tt7geWjMxlNAF9EdsQSlfZ7hImTQUT4RQb2PtVmNY44N6G1pfLb44HH6fM1pOWkvCQz42pqC+YEe9sIUadhWgh84QnG1qv4pElYDyOnmGxtHJt8YDdzXNU5M+1W3VDzXHFDi+vCItaQOJhD3sTyYXVLNZJ31qWfFhyFy8OAoaapARFH/5F3MOtI+ed7jEFOiyQLPvxoR0TWE6lCLs+2m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 09:46:14PM +0200, David Hildenbrand (Arm) wrote:
> On 7/7/26 21:32, Michael S. Tsirkin wrote:
> > On Tue, Jul 07, 2026 at 07:46:28PM +0100, Lorenzo Stoakes wrote:
> >> On Tue, Jul 07, 2026 at 10:01:55AM -0400, Michael S. Tsirkin wrote:
> >>>
> >>> Fair enough.
> >>>
> >>>
> >>> Lorenzo, do you know *how* you want it reworked? Could you write it up
> >>> at a high level?
> >>> Because if not, it's not really practical to make it the asking price.
> >>
> >> Michael, you're an experienced maintainer, I'm surprised I have to tell you that
> >> the burden for that lands on the submitter.
> >
> > Oh sure, "fix bugs A,B,C before you add to this mess" is a classic way
> > to actually not end up with even more of a mess.  But I usually do try
> > to be explicit of what are specific issues I want submitter to address.
> > I don't really feel figuring that out lands on the submitter.
>
> Sometimes it's certainly easier. With things like hugetlb there often just isn't
> a feasible way to integrate it nicely into core-mm. It's just too special.

Yeah exactly :) once you reach a certain level of 'specialness' it is more like
pointing at a flaming trash pile and crying ;)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

