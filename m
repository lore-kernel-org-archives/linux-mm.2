Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E31C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174B06B0088; Tue, 14 Jul 2026 10:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126076B00A6; Tue, 14 Jul 2026 10:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E166B00AA; Tue, 14 Jul 2026 10:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C79836B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:19:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5161E1603D5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:19:38 +0000 (UTC)
X-FDA: 84987590436.07.6730E17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A798C40009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:19:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xro6Eb+r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOlbLc2qaG2QBOOhEn3n4/8lPPbfM5YgeFxaZ9vpRVo=;
	b=n+cL0qQSV/brPuVo1cK1OmvwPs5knIgOrnxgitJB02MzKXANkFdHFaw7EYjCAkWfoJm/LI
	xG4oJJgkSmChXy9zoyXQsN85yapthqltLNIrOxZO6p/Oi3IXkHY66VzAoIxekyEvz90cs6
	YqIyWEnyqztUX9HmbJUQySCFW6xNlyg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xro6Eb+r;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038776;
	b=TKhiYqjKy6Pr9oGxFdzzZqBW2z2rpU115PjyMVi/dTeh7LyJQeTXaj74G6Hr6PjAMoemp+
	9uiecjsE7NCXNlZBTeUrcPbvR5JhGKCvAILjKMZr/TLM/3tb80/orrJ7TsvauGN/UZVUtl
	hy3A/gC6kofja+Zg5fmQBTDB87MB7ng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 276DA60103;
	Tue, 14 Jul 2026 14:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997CD1F000E9;
	Tue, 14 Jul 2026 14:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784038775;
	bh=LOlbLc2qaG2QBOOhEn3n4/8lPPbfM5YgeFxaZ9vpRVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xro6Eb+rUE86RnbMJWxBwPCOXOCMH7r4XuDwCdsV1tSubc3JLvla0Aph2hDvOG2XV
	 M16+614h4x+Rn93ddAavC52RQAbBuiruOpohnIw0hBH//qTpW896P6JOsbKETHNn4O
	 xhwGZDPoS4n+kJdTT3m4P43Jj3SVT6u7xxyczirbqGY4CqjURmAuUBwTb7VabhPR9f
	 xjHxXlmc9c93vyEbj5LYWhCubJRoMePbGaqsO2ZNmkmXAptpzxBLw/dhznTFRivcxN
	 kDEqlZksN/p0gkc8mgeFCKeekhTd/owc8JmoiQQFH4rQmnmGymKTBe1fhyrwEYDUZc
	 nCMjFuz/H3WIg==
From: SJ Park <sj@kernel.org>
To: Jiahui Zhang <jiahuitry@outlook.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Honggyu Kim <honggyu.kim@sk.com>
Subject: Re: [PATCH v2] mm/damon/ops-common: prevent migration fallback to non-target nodes
Date: Tue, 14 Jul 2026 07:19:26 -0700
Message-ID: <20260714141927.100207-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To:  <MN2PR02MB665479119535A1235D69F125B5F92@MN2PR02MB6654.namprd02.prod.outlook.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A798C40009
X-Stat-Signature: tbepf4da3rbmkd6kpo36oqxux9u4rsrh
X-Rspam-User: 
X-HE-Tag: 1784038776-248902
X-HE-Meta: U2FsdGVkX19814V3biqlutCA+lW5xFSGKJhJiLw/Ljfd/Tb8kDgRGODZeHsdNAh464M3Xy5m/rtDH0MbvpRyH+daokQRPmVusN0Rdx1EgCpOwLELeOoUV9YNSnWRbynFxcw6wON5Tz68tBoluW/tNTQJ+joMPzrCGJ9pV9uLUO1vQprIbFCquT0YAxwaSVVfL8C1+Gl88LOOkZzn8o1sSnT4tr6gVMGmk0zuRff0GTOQmwKGScch0vaFzOz6rvTm54IAfJP1pKCQDQEcHvdV0xYfdk0gC1dJP0ciYvCAMxjBuaqLrhtsHoDkobM/sovC3gn2SXVCa8xj7sWB2eAaQuzwoEse/7cALL9xTlW9jIZWVJ2/UioDMTZqQR9G3LmDAGyE3c5LvqEtOOomazmsCYW6ofFCb0CbEaUhnGqHVPdQ4seAMbNTqHDQ9AT+KUk0FS/xNF7JMWbWXmxA5GTCqQgwZHEiFiw3MphyA/JljAvVhLkPMMd5/7W1pjP75LOf4DalT0G+0bQXmGOKOPBpnHq4AG0lt1C/EYQz8D9TqoyDcRr7s25V1+gI1oZxC8R8I7hh6aV47u12NDhgYvfiTG9WpHx1H6sNVOUq9N5/C64PrTw2m3jHQzaQzOW4gnApkRO5V5FskHYIh2fC5PhIZPh2sE86FVMLTnBgN7V0TZaupqddOHtmNij9KTTnbXqvVdrLQn5UZxOKCI0F6bNyIYipl1OeDCdoujsOTa3qKbpyCsvgN5xatPChPEibXoJmbyM+CThVh2alxNRKLX4rpbSIMs/aWK0wkLTjluihklNyu8urbWxuxprqFfIUanw9cWRVOezVCUQ7VAwoHuemjoVHCvUje4Bh3EpiXJJLf9exHL1/ssT0bIMW3Sbp8LczSY6SWrgWYv/mXMT5iHgdFx2WvWJdiYKSEEBqdDd9qT39L04eED9tQrQVY/T/Zug2P83R4ME8CFVfqJbTp00
 gG2rCEaK
 JfTdnpGg4RlQSXZH8LAQGVEOp91OvEey+5iEAsxehgXPrFzitmj8tW62hdQ/8b/ofur0vCtBy3HmW3L219+zQurYFBH8n6VnBBNZ6nSgdtOdttEy1o27AhozTJbZPtyDEmiOjQNtp/MI00zbzNoSm4bFRVXfn3cQEvdE3oGoeaNByzESygwrpv+Bf8fG95iAQEaA9yX5tctfssXGBk2nm6HG5nuz3t5iBEsKeYKIicIvXvWdvbNzML6MgAVd4YlX08oCF418Kc6Pu+9Ut251QHgnCOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 03:38:17 -0700 Jiahui Zhang <jiahuitry@outlook.com> wrote:

> DAMOS_MIGRATE_{HOT,COLD} passes a target NUMA node to migrate_pages().
> But alloc_migration_target() only treats mtc->nid as a preferred node
> unless __GFP_THISNODE is set.  Hence target allocation can fall back
> to another node, and migrate_pages() can report success without placing
> the folio on the requested target node.
[...]

All make sense to me.  Thank you for kindly revisioning with the clarification
of the motivation, Jiahui!

> Signed-off-by: Jiahui Zhang <jiahuitry@outlook.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

