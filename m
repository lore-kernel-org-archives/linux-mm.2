Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E52108B91E
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 03:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583426B009B; Fri, 20 Mar 2026 23:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55A976B009D; Fri, 20 Mar 2026 23:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497586B009E; Fri, 20 Mar 2026 23:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 399996B009B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 23:33:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68BF288E97
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 03:33:15 +0000 (UTC)
X-FDA: 84568649550.05.AE3EC05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A541740009
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 03:33:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="F/fTnCj5";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774063993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fPgrIoYd5zqKQ8h9YXyn6hmQlQubMpQc1nwDgwfwl4=;
	b=u6uJKnyWrAYQJJEjetwyOKdfSHyepao6ngiIEt0LvcM57Vp6yMuxoW2Fe0Sfow2W1AH1uq
	jgsdxvgPdSXRvpEoQgBKrgNqDEDk3rlpcd5KItm2BPIzC5wc1VS1lyboq16eW098LQ74l3
	hEaoiEbAei7/1+PBFrcUWhPKQsMDp1I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="F/fTnCj5";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774063993; a=rsa-sha256;
	cv=none;
	b=ZCdyzkBQoy0A7gGXDaxwvg18q8xbkh3IiUHngUtcTXieWVWS7OpXfHmopQ1Gscqmj/Vk/C
	psOfsA7BYEofXbz1siVa1OHvk27hTM3XQ4mTbjghdopgoj7i8Wg6cCmHsoPk68jso1MQfZ
	YrpCW6fBbqD9wyqnFlejghK5CWmiYEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 959BD442F0;
	Sat, 21 Mar 2026 03:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6E7C19421;
	Sat, 21 Mar 2026 03:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774063992;
	bh=0H1PnBBszZWaRy0uzjJLHXJ7/e/X6YHkIL5fODgjbv0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=F/fTnCj5WQsl5tnZyJZ7DApauCrFpwfHnbnEroK12zlwQdhiMJdRa3U7Kk1CesmJM
	 AVtV8msQ33fSLK6xuHSfCwl7tRFHyMHCDV79/vTf5C/Rwl/dyVc/Er9pLSzu995X3u
	 huM9xEpPYf45BBOwRUtnZ/cGs6fnNbbcVAjnJXQQ=
Date: Fri, 20 Mar 2026 20:33:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-Id: <20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
In-Reply-To: <87tsu9kgv3.fsf@linux.dev>
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	<87tsu9kgv3.fsf@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A541740009
X-Stat-Signature: 595bbyh5ahgr9mpm43ge46fsdd197wfo
X-Rspam-User: 
X-HE-Tag: 1774063993-770409
X-HE-Meta: U2FsdGVkX1+9K+D0FZLAgVCrjFN+c3gUJlI72fcDlD+g8q6gS/FyTvOMeMLfKTbW7cbcapxtqr+IphQ3cIDn26TBOfKeamPekXI+3NhOZOmnDFeBSx6awvh2Vu/ADcf/3ZvmY2ulcGbLskMv3kapzgxfgnQ+U64meCuHJkgpPTGT93xAgK49oVDr2DSBw6K5YopZb1oLkyVibx4kkJNNfopKt8LUcq+x9Jalfx1XztZmh3WjW1y6gN6rpGnNWUGf2t6WKtXDjY2bvGG5pEQKICPsiO2k47ibgNs9oycJeeZxfFLVLwH7yBOT/dl2/ka1WL0VUr3szwWmECb+6RWrUNc3vrTFkFRPilYA1fT6Rkm+fg6P+Bkhpj8VWyTmDmgiKlcoWpFL4tr+8oa3c0wSSanrF5prO4kSBekDN6/+dy8lMKkgbAZxTafrPo5p1ix3Q7ww+aVJLOP3Gy5wcrWEFo1Ha9zeiBjNc4e8bL4qBEpKjMGHqokMvOkgIMYAw0REY9gMElabLfWEWP9UpmHP1OsesVY4iK6L2l9pCDdNnLTrc6E23pLxslOr0SW+7VQAyAJlqHGGWVVwBL/95dnwVvUSSavrggiZgvnDpP3wd/zTdv+fSTmMmX5iK6hBRubhjoMfGTO/sG4waI3mz19haLUigJXlGcN+wZnu2C63304r0IT32UvOhnkfERfuLDyo9PCrHZ7irr/EFR/ZXJAqKTfHsovnOhvWoK/tCEgsCgfsdfSXbkiUlhL2pPvXzye/CXKQtdN7Z/Pc4fFN137IdXxLS+YHUBlCrzwzSa/rCDScjpGer8qg1EeEEJjGb+wtVUwVlRmqbdl+rScNkp8bBtbm+zK++Mm5rF62o27/mN5l7Gt2U0N6b34BbUUf+jpus5caO//DAjKl6c2Zu2LrYX/ZB6T/kEP1Sabu2TFRDyGha3pmu3ertcFFV7mCrp42hRAv2N7kjbYfMwrKOFz
 awt6Q9YD
 /5hUZAgUMrWL9fA44tFWB9eSn8D8aTrc2/yv2pDWVPWk6xdQgQn78byjBqsMiOCBEG+KODE5EtBOd6z6WlSgcVYfAx9KJq22X38+JsibNF6oQR5J85FLULlTVLN6nIw90Dj/hy5fEidaj1VP7hug0QseLnoO7/0lJeL/HjkfT0aPhYxpe1sYwzuQMLuVumKU9vEoVYd8cVTN24zlJ9QKESk3EOkdG2BSSemPs0k8hEyZ4soEjbrBZHECesgp8BCUIpQS4vjZLgmCQ1vVMlofsIwLiKmAPNcVdZn0HuoUlT7414u0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 20:21:04 -0700 Roman Gushchin <roman.gushchin@linux.dev> wrote:

> >
> > Anyway, early days.  I'm thinking that an emailed reply-to-all from
> > Sashiko will help.  Much hinges on how useful submitters find these
> > questions to be - something which I'm paying close attention to...
> 
> For bpf Alexei suggested to always send the review to the author and
> cc the bpf mailing list, but ignore maintainers and other mailing lists
> like lkml to minimize the traffic. It sounds like a good trade off to me.

I'd like to see them.

But I'm figuring it out now - I just let the patchset chill until
Sashiko has looked at it.

> If there are concerns about polluting the mm mailing list,  maybe
> something like a new list like "mm-new" / "mm-early" might work?
> Idk what's the best thing here to do, just throwing some ideas.

Yes, a dedicated list might be the way to go.

> Likely next week I'll be able to send reviews over the email
> and I can send them to whoever we think it's appropriate.

Cool.

A lot of patchsets are "failed to apply".  What is Sashiko trying to
apply MM patches to?  It would take some smarts to apply the v2
patchset when v1 is presently in mm.git?

