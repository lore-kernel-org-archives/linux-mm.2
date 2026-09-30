Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7934CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 20:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6396B0088; Wed, 30 Sep 2026 16:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CA96B008A; Wed, 30 Sep 2026 16:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BD316B008C; Wed, 30 Sep 2026 16:03:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70FAE6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:03:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47B1CC0196
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:03:04 +0000 (UTC)
X-FDA: 85271502288.06.342B3A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 584A5160006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:03:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ExlvIxdb;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790798582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u08t18FaZZ/JoItkaTytwkoDNv5W489UK9Ej3SaW7sM=;
	b=m395YzsHCjgLYDui+O9htpLaBRDgcLVJFOYNy2zphF7sXqPzlZ3lPSxEUqUpdsbTaBcFJu
	ejfo5DmsL722hB/N3PXO1QOEgRP8zowzzzt32NdCPq6sjqxOPePSzKoglGMziXlWpDmAEr
	jI5R4RBnDkXJ/q9rXYhzerBfFzcBtuE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ExlvIxdb;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790798582;
	b=m8GEeZ2AzsqS9rCEiIoBs8ePOzWzhwvV6y9hd6/9pB9t3QhK/TJwSSyOIoOHcSpcJW26AF
	M48KccnBZagaYn9Uh8cVY5+RacvUigCbaEenF9BoypW5Xd+O0vrEZM7yZ2ZXBSdhz3jAr5
	KmQuKv7fgEzmsoVMvq+54rl2QgmpPpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CF7D601F0;
	Wed, 30 Sep 2026 20:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1381F000FF;
	Wed, 30 Sep 2026 20:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790798580;
	bh=u08t18FaZZ/JoItkaTytwkoDNv5W489UK9Ej3SaW7sM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ExlvIxdbN8JjqNmq7VsmSrsVUc6pxFiLPpW5EV0yT5cQhwrumhMEM2DrYiSKwxFRB
	 V0Ji2JQN3kuDi4RDUu8ZXgrmY/sbD74AO6RjhEG3qSGzjUDpJ5VTWQMmcxmI6c07ZZ
	 uQFr429+DI/V4CQzuFxFOwzlTC6jfTnwaB51VOlE=
Date: Wed, 30 Sep 2026 13:02:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>, Harry Yoo
 <harry@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-Id: <20260930130259.8d7d967f4a38afa34e051145@linux-foundation.org>
In-Reply-To: <ar0AiPWwfcZtksPu@thinkstation>
References: <20260929174553.175333-1-kirill@shutemov.name>
	<20260929125816.5a846a62943eeaf63725b525@linux-foundation.org>
	<ar0AiPWwfcZtksPu@thinkstation>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f8jk8idqndw6w47h77qxjt4bxyxj3ske
X-Rspamd-Queue-Id: 584A5160006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790798582-38563
X-HE-Meta: U2FsdGVkX1+d1Bt0nK+0ctZhn7jpRIr78OviTqj4QsVgCPayQpRs5Fd4ZyYiRLDFY82T72LxyFZhN8JP1ml5u+Fy7hXa0jaF1C0WDCqaJbvPV63FEDCj0d7S3jqTVpun7eo9tAsWkUJ5swZIx5iAKLQd5UN2Cz6W+u42pMr/T+swUeKCTJ0sKas3fK6YS93EJ0axgHEnGJ2gEga4unY4mtMNzh90Dr2GCrCByyjpT2bXaQDCieTbB2kU+9ClR1kVGdrv0aX6534gtblLVtzkorE4TS4tZfArf2W9xRrvgNdivFYdRqqgR/9WWyjjDvOsl62jKKy/DChSbG3GFE5Fd//zfak2FTne8Ni7p6N/IgmlI/nUGg5gXZ2L2ACAQ/pJdeKYkNbixBB/CIU1cbtRnVKIRLExoqFYxaIppgWt1ryCmj3T4uSeuUU5kK9wXmIjl8Ky23QYQ6J3nT63Dt+ooYy7TGadYTxBfpTfTGRgWtuuS/i/3c8vHpIuaZcS7qurLsXP0ltjijLJhO8Cs5spp8eOHLjc+EA06cFdhVwsJNXR8Ld36lGMg2PAxOmWouDEEk4XGht/q1d8arIWgsYnPZdEp8wV/IOYlC8ZRNAU2GnuuCWWeAXMf0zpzcGvLLTddfLaHYYMuIBinhb40EpcNRT9S/63FnyAQsxIGRM2vLHrZLgkfW3Nui9Ln3S2NIy0QEGSdX2uJAvvAzQJEBLUhi5YSAg9UeBbIYRa+Su7PUFQbLiyzmoerTErpQ8pjqCSnh5K+Ye6FXZfPzFkbpSeUUR//E6CCcEhDMNnFIZLmZqi6vJNhtHBS5boDJN76cSaTA7I58UGngmFs3iWiUNi+2c+ERn6E0IgkHTXI7jVElWjfn54PNY3dnuB2o/F0NEuGzs6NtqvlkVJSv53SiwUtEHlS1gCjLowoHeqFam2FBXmFAju664Ims0NhH7rob2an1XerqbtbGcaY1cNOQt
 iUoHADuL
 y3AL14FKAxURBb1fRa+NopntbRcb/2uhv4d0DWAQODvs/M2y9b4FUu+Qz3G6BVXZcjXUlEHYQ+KxUBCcyujsvBj8/BZa//8qH6gQBMcSFrOo+c0Bn3/5kcG/ePAgbvO1tBbVQUiJ8jb/VOEUYvCqCB+MB93j8adPdf4eRikqMXOzuq9OAbz6OLbfNJpkRI2GWLyxXZrT5dQmTZ/7DQf+ZQzz/d+QoBt+d+YAkBllRwFNx+Q7GY7tbmGO5AWG/DGyF3NJTvREXC1cLNx3UsTKJnBScTJoTAlkDD2MXHu2d1uoqbXQ7+KbrFrYo6XQuCke4/rgV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sep 2026 13:35:01 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> On Tue, Sep 29, 2026 at 12:58:16PM -0700, Andrew Morton wrote:
> > On Tue, 29 Sep 2026 18:45:51 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> > 
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > > 
> > > Since commit 7e8756d7ad22 ("mm: page_alloc: fix non-movable reclaim
> > > storm in defrag_mode"), direct reclaim and compaction for non-movable
> > > requests under defrag_mode run at pageblock_order, to produce the whole
> > > blocks that ALLOC_NOFRAGMENT needs. The retry decisions that follow
> > > still use the request order. An order-0 request can therefore retry
> > > indefinitely without ever reaching the ALLOC_NOFRAGMENT fallback:
> > 
> > 7e8756d7ad22 is new in 7.3-rcX, so no cc:stable needed.
> 
> The commit itself has cc:stable. And it is in 6.18.50 and 7.2.4.
> The fix needs to follow it there.

doh.

> We are running 7.1 with 7e8756d7ad22 backported. We found defrag mode
> crucial if we want to use large folios in page cache.
> 
> But nobody besides us seems to test it :/
> 
> Can we make it default pretty please? :P

Send a patch ;)

