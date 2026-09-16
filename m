Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E3DC982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88796B0088; Wed, 16 Sep 2026 11:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38F36B009B; Wed, 16 Sep 2026 11:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E6E6B009D; Wed, 16 Sep 2026 11:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6DBE6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:21:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23464A0782
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:21:58 +0000 (UTC)
X-FDA: 85219990716.26.0411F57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B59140006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:21:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YruKXo64;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789572116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYSmK5y+SZIRTC3GyQbRTqJn7SlfXievVVdd5VGAyTI=;
	b=hMNG6oTfnQaAFlSheLKQzKMY4RuDczb0pSS2N37ygeYzhImr35i3YALDng+wfDEWoMw8ce
	vipp9FA6YwA8nHeLdZ4y0wJUxDm39jaylLENlw273NzEryC+zFO9P1s9rlogaYWKAITQgV
	n+btKppL5H0WOxbkrt5LUawZ/id/Os0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YruKXo64;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789572116;
	b=QskNHQo4Qsc1SJ+wTQJP2Nxt/ZEw0JKLZeqlHoXYJGVxEV7SrPJgAK35HKFlt+IzTNmqQr
	jkRDkJ84f98j5CGzeJygxwNhVWq9NoxR6RSPPoHEJYdRAJH/DIth1Y2aY2QfJNjULdm4d/
	MDS4zMud5/IYfBDLLIZwEcu/BE1mCx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0341860234;
	Wed, 16 Sep 2026 15:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905981F000FF;
	Wed, 16 Sep 2026 15:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572115;
	bh=jYSmK5y+SZIRTC3GyQbRTqJn7SlfXievVVdd5VGAyTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YruKXo64eKDZQFGDDd8CEzuHZHfosdcnkd/01HIK6gfZyUV3aIPITuaF3Bx5IQ1JW
	 vdWSmFv0U0ltztQYw0xb5LedymRs9pTaXO/WBKCOFimTiwzisE4Cvqi2menFkbioZV
	 Ghugtu5MJWJa3Iz0euWc0rEJtKXUpFdeVO46PBYUgLVA5tz2oA8xCZX+Ojj1si0l96
	 xmoJEp/7DMlISrSJGF5+fMyGxd3FfWCSCzXFEI3zqAM8AbquN5MS5SRqXA6Jw9cxmB
	 sulhd9yPZfubs9yJQ3LXvn8uo7eskwHnaRXptcxZ440t2mxx5GnramlMLhMoCJ0Gd4
	 U45HzK/LmW+aQ==
Date: Wed, 16 Sep 2026 16:21:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, jannh@google.com, wangjiexun@tinylab.org, 
	sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqqzpldNskE2RRo-@gremlin>
References: <aqloB0zm3RjJ47m1@gremlin>
 <aql65IhMobL5Al9B@gourry-fedora-PF4VCD3F>
 <aqqTbGMJL86TzDrf@gremlin>
 <aqqbB_nFAOGenDhy@gourry-fedora-PF4VCD3F>
 <aqqjW5dpyznijYLh@gremlin>
 <aqqk89oTigJ9LS2N@gourry-fedora-PF4VCD3F>
 <5437871c-d9ee-49d2-b24f-965c73c29c3e@kernel.org>
 <aqquDtEZL1ndymGN@gourry-fedora-PF4VCD3F>
 <46d923e6-5724-4df6-b0d5-8dda7c547f6e@kernel.org>
 <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqqyhkZqcXDUrzeb@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B59140006
X-Stat-Signature: c3jzt5gbadyz9oiibqjcok6yfs9s67gi
X-Rspam-User: 
X-HE-Tag: 1789572116-607349
X-HE-Meta: U2FsdGVkX19KvV6h5JM220nShccvm4s0yEYxFiYbbCBmEn2z0Zvm+cfP4YGC5UAg0+tEDa10jTg90Q0LeacnnSWpYWhR1m+lnAhzANyDS55H0HS3sX6ca0AH3QR9RfcMvjy6YjM0vw1bx5aKsVvB/A/ToUhsmbqnpG5N/Zx0bErYoE/5i2TQyNLY12F3HsWzfEBGDSAG574ofSECmkeMoT39TM6RTrF4pvD5uxMIFU+UF5oRwlYjJ8sXC8mVn+1LFvJo2k7XFQkCGa/RtE586pnV3gRQ6dgARJFT8Tbz39ieemGn3suJCQQT/XlFBf59AW1qT8pegIue0Yvde6ICmGhyFV8hizkW03Ep7rH4Xsp6HiwGrp6MDVxE+Qjls4aC7O0f9iAIVpLDZxGLboFUz4i8gg+pa6Lvsi+P3dFilFy1Ax9Z9HY/GtADucpf6vH9MtwlWBVqAcO5aakqhI95ds+Awatea4CkGmxkd0bday8kmjXPj4Nh2MAB+yQAxcXeF+IijyI3orDtdO4Tu2LqC9+CbF6VNWEu8yQZrFMa+Y+HcfN6hMSfmB7AKrv+HB435YljgGpyvo1s0hYFZUhE4UCAcRQj5Ae/CgyVeDQriImadsOKlG53bWVongmyDfB8TSxukLLHJw3O+RP6t+ZH/D1mUhrXjtaOFxlb5oDcGwV8dBX1vMAJ18VStZ+n2r/NBc965jzjj7SY7RW4Jo+51sRwh/67XhpIkPPQmbOpxbct5GikRPLKwDthi7mW+GVuL0VHLg8gLrDctM3h1uzt2SpwGphuhNBB4DVlgExifRRIqNHhvOg9n7dxVq2sYZdbhDJ5wEVcacIdzXh6t3bjFovTBJ34P4Gayk1ysoni1sPfmXAWSYD/X/h0RWZCW1ygAy3FFZn442sfBeV+Tri1liE74qPvVg6ilvt/hMbs/mhQhlsL9EDgafM1qlLIefQW0rwdFuN/gD/gUIzzEsG
 BVFWUqMv
 FyaWol4tLIXCZOZKYloDM9q5Rd7N7BuD/JyH7pxn4eIYcks0HPsBqL6U+P1VfZfmP9NAStzrCkk+Cz+6601L4dbHlcYkUouY6sDt5r4IYUo/BHJRUEICbj/8TkZCDT07cMHucFHTrrPmrHwdB1tWOBgsXDKafNF6t62Xq3hBOSfm1azeQjRGYI1/RrmqYQIsPNgUZDxVBjTcwzER8LviNfiivzafGoepmcMzf23gpH5jiHQlX2MsFPhjuCWaznyY+ZzuL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:19:35AM -0400, Gregory Price wrote:
> On Wed, Sep 16, 2026 at 04:59:32PM +0200, David Hildenbrand (Arm) wrote:
> > >>
> > >> I told Brendan exactly that (try stubbing it) and he tried ... and had to give
> > >> up at some point because it just wasn't feasible. ;)
> > >>
> > >
> > > LLM go brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
> >
> > No schlop like that please, I don't want to hate my life

Somebody doesn't realise it's all too late for that :P

Picture Pennywise the clown in a storm drain etc.

> >
>
> You missed this part:
>
> "I'm trying to be careful about not causing a bigger maintenance burden"

Yeah that'll be the hard part :))

>
> I wouldn't do that to you :]

Hmmm... wouldn't you? You want to don't you? ;)

>
> ~Gregory

--
Cheers, Lorenzo

