Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1206FC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF516B00DD; Mon, 21 Sep 2026 06:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198836B00DF; Mon, 21 Sep 2026 06:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFDC6B00E2; Mon, 21 Sep 2026 06:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D877A6B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:09:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 741A980117
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:09:03 +0000 (UTC)
X-FDA: 85237346166.19.0FD8EAB
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B9CA140007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:09:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sCM+RrnA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sCM+RrnA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789985341;
	b=QZ9K6e/rP5p9j3LJnAxRoHJVBYm7bRtljKMqd4nmCEarmTDGVdPewrO8xF3pVHafCUqMJy
	d3QOb9/1bqIhWgg5cBOgRhXPDhliXGCNcPTkRhcnESyfh2zJJwAQkcvMC547hk9XEp8otF
	Pl6DUq32JzYex5KPM/3fnZqy/erm6dw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789985341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdYe3q/HYydnJALeQtLfFhQ0yro6QYjpTg/Ni4WESOc=;
	b=BS5m4vlH+iJQ1nnJvTbKK4GbKfsrQirvd3yvPSigxX776zoQBAyjYioGmDmCZmfFanrlYX
	11MhIj9pLsV3GO3Y+QhtMadUNwkDMu5/nxtH19kwVyozmj7tucS1juAdSdlDbz91pVslkL
	IU3av/gMaToSIQkNymchcIPwFc2KMe4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+zSMGZSSWJCJA7ebt73V2Bw6q7ceKug9tytNSfjsmvM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789985340; v=1; x=1790590140;
 b=sCM+RrnAyM9jG1NDeUwwLkd8W6GMvzluFtks/+7Ntx9WvTOQxQ8UpFSkNLvMnITWjb7xTWgu
 ihmAbq/yEty9eYerrBcrpEWLjQmAi9SIXF5scG8+mk4HYPWiMvyUvJk8RnY4va/jYYD2QGq2g/B
 Vcs2FwOqv9eoF1suLWcTt3iM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id be166c72e3da7435;
	Mon, 21 Sep 2026 10:08:59 +0000
X-Mizu-Trace-ID: be166c72e3da7435
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	joannelkoong@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org,
	kas@kernel.org
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
Date: Mon, 21 Sep 2026 03:08:49 -0700
Message-ID: <20260921100852.2236761-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920162014.4479-1-lance.yang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B9CA140007
X-Stat-Signature: id5k1a16wurihn7qjzbrtjtmgpzhfbzf
X-Rspamd-Server: rspam01
X-HE-Tag: 1789985341-897000
X-HE-Meta: U2FsdGVkX184hMtNg9fIQ+xA7tfW+7qyx5KjxTaDXCfKR3hHfd+4pu3cciFI2+gl/30DDw+1VkFKI8iUNU2hwn50kHakDnfhmv06dLPl+9mCio2UoMFJH3FYWotJ12g7o8BBdUVELlrkm1S6g82l/SZ6uFK+KxoCTs/lEipiMyoie4T2NfrzcseMSw5GvUHtN82mvpWQNvjyXI/2qjStcf30qQ0JyggJlPpyVqlV+09ts5qMN/UYthKXy25cDqx+vCSfdFyc5shQy5r9s5Lr1asn9NHxask5hQTLk6/33hg8Asr5vAXDxCWk4joGWpR2r3E1AYFwstx7I6GkduNYE/tja8+K4X0sSiiOdWvf2q1YMi9yqKywtOZZOfw9EsjXyqTOnvff6mP3HS0qkNaxJ1NYrgFRja5/2RJY2NhGF1Z7X257g9GufB7VzTlIufZnFSObBfTxQD4bOyoKHd6q6w+GlQwoVWLeFmLDgCK2fIbtGp2QkdCDaqowtzPotGUKYJRNQKWAeOZcn8IN9GDaV5SDPbqJl5fW6E2ed36KnCUGvGF9AO5+Gv02ys7sC9WIhOCM22RKkmCV2D9C/f6xGrRotDl04toWrmMIZHxEjpZ6B/Gs+JspoQ1XI4WsTORcr8xzSMepIca1wgNxheP9f6RQ5KUE+v4FvjPKUof3p0EiHxn5xrPPT8oyGg09z0YPYOENqq/rWhxmBVP4QXER1Uy6vEKHzdQgpsTbmApEPZicMB12m5yrC/Jh3FgFblnN2kvhUJOjhamFqXN/9N3YAKP7jGHdtFUjYcGFXxjnadpbuPf/6fuzOhs/rmplRSz2IIy3J2VURnqvp+NgXBhyNm4EP+Pbnfke+gKheI+B0D/oV9vARjacXjuKVKQ5BPKlcTxLpDJDYh5+idbUydW4pBE9H0H3vq0vxcEQQEYXLEZbJ2FRH6r/rK1K//aT9V6RrQdeVtAcpmyHFZy/ofH
 NXnLV1JT
 JJyhPP1RagcX3PmWyl6ITpOpHMxKi3m7TCxsHYNP5DvN9bKvM3uauhLjaO7lVazma3F0Hre3w9ceUI469Sdi8rXWKMXehpAKiwZl/o7Ez6TyjTGYg6yZnHdbd3EE5bgNleOL4bchclnljFFgEG3orU3AgMNptPlvUC51fBa7bnFcruE6Cl5RYJrx/P1dyEAgB9sK2nulK0v/Gr/Ye5UK15Pt7csiJEe30nQRd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 00:20:14 +0800 Lance Yang <lance.yang@linux.dev> wrote:



+Kiryl who is working on khugepaged rework

> 
> On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
> >PMD-sized THPs that are mostly zero-filled are reclaimed under memory
> >pressure by the deferred split shrinker, but this is not done for mTHP
> >folios. At Meta we would like to deploy 2M THP=always on arm64 with 64k
> >base pages, as 2M provides the contpte benefits while the PMD size there
> >(512M) is too big to use. However, 2M THP=always causes memory regressions
> >unless the unused portions of those folios can be broken down and
> >reclaimed.
> >
> >v1 did two things. It scaled khugepaged_max_ptes_none down per folio order and
> >it queued every anonymous mTHP folio. David objected to the scaling since
> >collapse had already rejected proportional scaling as either letting the memory
> >footprint creep or being confusing to reason about. David and Barry separately
> >objected to the queuing, which adds list_lru lock contention on every anonymous
> >fault, and hurts lower-order use cases such as Android's order-2-only
> >configuration. Johannes suggested keeping khugepaged_max_ptes_none absolute and
> >simply not queuing folios that could never exceed it, which addresses both.
> >
> >Read as an absolute count, khugepaged_max_ptes_none also implies the
> >smallest folio that takes part in underused splitting. A 2M folio on 64k
> >base pages is 32 pages, so the knob has to be set below 32 for those to
> >be queued at all, and any folio with no more pages than the value stays off
> >the queue entirely.
> 
> Em ... I'm not sure max_ptes_none should also become the mTHP underused
> threshold ...
> 
> Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> collapse uses 16, while mTHP collapse turns the same value into 0. With
> this series, an order-5 (2 MiB) mTHP enters the deferred split queue
> because it has 32 pages, and is considered underused once more than 16
> pages are zero-filled. So the same knob means 16, 0, and 16 depending on
> where it is used ... That's a bit odd ... no?
> 

I feel like the odd part of it is the 0 in the middle used by mTHP collapse,
not the 16 for checking zero-filled pages?

Kiryl, would your rework allow all values for mTHP collapse or would
it stil only allow HPAGE_PMD_NR = 1 and 0?

> Would a per-order value make more sense here?
> 

I feel like per-order might be too many knobs? What about a percentage
that might apply to all mTHP orders?

> An unset value could preserve the current behavior, while an explicit
> value could control both mTHP collapse and underused splitting. That

Ah are you proposing that mTHP collapse can then take all values from 
0 to mTHP number of pages?
I think one of the inital version of Nicos patches for mTHP collpase
allowed that (hopefully I am not misremembering). Nico, what was the
reason for only allowing 0 and max?

> would also give us a way to leave max_ptes_none as the legacy fallback
> instead of adding more meaning to it :)
> 
> Cheers, Lance

[...] 
 

