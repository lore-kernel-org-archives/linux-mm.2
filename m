Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E76C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 17:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8682F6B0088; Fri,  4 Sep 2026 13:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F726B008A; Fri,  4 Sep 2026 13:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C506B008C; Fri,  4 Sep 2026 13:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CCA16B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:59:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4A42A3C2C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:59:06 +0000 (UTC)
X-FDA: 85176841092.26.CFAC5F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4873540007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 17:59:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPOBtn1c;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788544745;
	b=ieUHelgDeIoDz0i4YSWLkGm7Jj8nKPQCi6y7HFjzBLrlDh5Pyx61lImKpsoVdVLx+TpmRn
	ml9TjRvPHzHQJXYDlO8cQJLMvSU0BaPuvh16etUnJkn5zUdEUtgj492NMft8skaths+/pO
	Norl1tEqEhzF9JhfEnW5/A7xh4HZ7vs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788544745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6ArXo6WN8PvPgPtAAXF4NzFTbDGY4aiKUWgOgxvNuM=;
	b=O3lJy1su1+CZAikhm/AELoIjnPfrIOwlwiPeqGPnIjbqZvgmJXE7pzYvvtSsChXNAdJ/+v
	DV3lPZ3Nw1DH/Gckch2pdkvRG6n9pscrCHr/PpXb/ToDYNd4VqpGDbfwnC6jb40xtDUi5/
	DhqMk43BQIfFxbCCQWtgiu7wsgEh12M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPOBtn1c;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F2A7407E9;
	Fri,  4 Sep 2026 17:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E751F00A3D;
	Fri,  4 Sep 2026 17:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788544744;
	bh=b6ArXo6WN8PvPgPtAAXF4NzFTbDGY4aiKUWgOgxvNuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OPOBtn1cMPiS2z56TibMNLsw69HPhvNZKpRpX/c18p46ev6yMmvMxDeK0aGo21TYM
	 +C5LC6y2guL994NwehkNdcY1rYbXFFsc3uFvhcF6uO7pmCzCtRnb06ckMu8Z5hLRYP
	 872RE8xxhBipuoHPk2Tgku18MfXcULfSCU0tognVlxGR+Nmw0qQrmkB5ZoKuhIAt0Z
	 9jGI9wXnVdBcuLCzzi5zCtw/hD/8v/EhGp4uTGhYub1ePbM8NsevJhQC6+efQ939BJ
	 o9o0tt/ey5ZyfUe2lR/XG0EbU0SdQ2RRcH2lj8C2yH1hgfPVboGipf02wL7xf/mNvL
	 FIk31M4I7a7FQ==
Date: Fri, 4 Sep 2026 18:58:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apsGuHKcdAd8QwgE@gremlin>
References: <20260831234339.280376-1-stevensd@google.com>
 <aprp6GXv8poXXad9@gremlin>
 <CAOiLmNEPw_cPE0QM1Q7CbNC8owW94PvejKo71Hb7DF=QKNN4Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOiLmNEPw_cPE0QM1Q7CbNC8owW94PvejKo71Hb7DF=QKNN4Lg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4873540007
X-Stat-Signature: z91ak8b7pgkm5oexyiggguip4o9jiffi
X-HE-Tag: 1788544745-840529
X-HE-Meta: U2FsdGVkX18j8idKeqyUrz0H2FnroutjXj8+M18YUZTElN2WTTFNtRzbvo0MupmQdJiR+dlZecNSUxlfElgM/hM4UhbhzAMUIAsNNN4MpciVPN5SlkDZhz5xi1skDS35Hef1ypwk6wvTyB4E/eR6gTfypL3ZdOQ2yXzwZaiKB6tqXqVRuG2JwjKpJRTdXp4HA6urwogTCkgSl4CQQSomX+SABb5QSjuWRa/c4uoKMOPHgIZYqY7/iosvpQPD8mzE4DC8x8jlmuMUOer8LyMHieepvxq/23ujR1uAzgldipyNLztzFd8lsUERG6cGwKyv6vpuGolKsbHGamxo6EbOFF32ZU79/l4t2gm8DXPSbI4cxVJC4QfU/Cz7rIJDu6UqfYFsiwiRnt8TMyaIceQ5mKQ4DmaSZgt66f55LwjZG3G8srk3l5Bj3AG00Jx2PKRnUnWOMS9CLntt5qYzZy08nmJ+WyRkfTU7JF2nFsHiuvEOUQzYlrmOG70x9mUA8M7YXH5uPxn6dg7ZT6eG/at/gPyuFUKBs6hYGWCs7Lax+7cZ2+x5R3eUQJzWkx9bryXS3OMDGigmu9A8mP4arUQ7egV625JbHWbrYunGrROA3qtTgX520Ul6Zzv5tEeBAntwOui7dy26HO6L6rSVxjf5UGY0lVvN6JrWMIQhK0MR3komlDauuMLUePy4dz1CIBArsJwBCNNjrMGMKi070C9sAL4oDhhZtuNFWiBPm9uwU+IRaqwy+XCzLBFuE8gS9i7HQ5sued4XAWT22vMf/powf7HIZbOIo+ivfB3CZUOTZS6Y4ba6JsqAwI76VTMC1bttpylK9S0LwilurlZxcjrKYx3iCWgVkeQtWD6Imy2YlBW5FukvOBoiDv6UiT+QRGDd5A1LYTbmas2YJ27wxWeGvDdc6Ls9zxGUjcBJ+zzb59pnC3IEKl90kbpqdpvp9ZVIJcVrcBRKmNxWKyk99Ol
 ZR37MTn7
 2tzdl+MW/GSvwi64rcHbK9qeDAnRUol8T2PNV/jKcLdRpaOw8Z4JEdwpv9Ahurb0vxHxzMYqqw8HoN8Z6L2DGxljz2dKlQRFJ8R5AviYpiruktg/o4G7OjDPnFoBg5AFLIsNu7ER+7YV9wSO1OMztnYe6yFdBd/G8DQm8kdWceXnPQRVj3tXeszJhY9XrDw7/XrVFlK8f1iQs0qRbU7JpfekubJ63feELYADaD8/YEfR33O7SQAhOxQ+YplKNxEFPgFt7jyOLpREIAkTxm1n3o4131RLQ/zScMTIDDryTJP+6DbtSSqtTjgK6+MK5wia9QMCIX1CAMd7qk1NKaOZXp5VZaoRKheiYY2gMcXG9zJ1yZq/R8+jLZEOunw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 10:33:32AM -0700, David Stevens wrote:
> On Fri, Sep 4, 2026 at 9:25 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > > Memcg charging can be done from any context, but calling schedule_work()
> > > isn't safe from an NMI. If memory.high is breached from a context where
> > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > >
> > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > Signed-off-by: David Stevens <stevensd@google.com>
> >
> > This is in mm-unstable and breaks the build for me :)
> >
> > In general - please don't rely on implicit header includes, if you're using
> > functions from a header that's not included, add the include because your local
> > config might happen to import it but another one might be broken.
>
> Sorry about that, I'll be sure to be more careful in the future. I've
> sent out a v2 with the missing includes.

Thanks!

The kernel headers are a real mess so it's entirely understandable :>) (I think
Matthew is doing some work to improve things on this, or at least some of them).

>
> -David

--
Cheers, Lorenzo

