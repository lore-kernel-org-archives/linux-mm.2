Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FCEFD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 17:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C818F6B00A9; Wed, 25 Feb 2026 12:06:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2EC46B00AC; Wed, 25 Feb 2026 12:06:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BD66B00AE; Wed, 25 Feb 2026 12:06:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A05446B00A9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:06:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D25D5A1A4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:06:48 +0000 (UTC)
X-FDA: 84483608496.01.1DD4583
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5D53F140019
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:06:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X035a8hT;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772039206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMK2L/UhVRAe7lEsp8URB6RkTXODu73U0cxlBFOHU6M=;
	b=DRcj70abzzjAxqbu+PNmpq1HX+wc86Z2Fmw1vf9wxSRx+5DSBC7sqNNuGK/lgMLwOxrDHD
	Et6PYq8igIbSJjeEVudSJOkx0uDGszbAp6Iw3lSjbCeXDap8nyg+dDCjmW1OkBeeWyKrqW
	R6H3ShITd9o7TaxF8VRMj4eInXS7axs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X035a8hT;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772039206; a=rsa-sha256;
	cv=none;
	b=xK2bWctUUAHgwuE3cWg2//9azVn6rODdV+qUfXJn+eEBE2H4k7W+fTSeRAaBayFPMZMW4B
	YNmxTekdBXjW/ayaELKd3SsndkPLeCUo2MmQ23ITH6Z2+FZmYOjK2JOPXVBeZj3E839Tbi
	4v41xlELdMQ/8MTQCKUpDQ5fcWkBKC4=
Date: Wed, 25 Feb 2026 09:06:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772039203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMK2L/UhVRAe7lEsp8URB6RkTXODu73U0cxlBFOHU6M=;
	b=X035a8hTxsKugHSn2WtvAHXbu/0JLbIYatHwUUcXmjkR62WusmyvkEmLYsEPHcoQSddz1x
	RiSQ+tGr/krV1c7bzXMRoSCmijUQ7S3OYAh9Pc4PrSwkRd6l18bg7dri1JltcPIv5LXRTd
	gMie22jGGtJFjgKcLpBAYBlF5kYBWTA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
Message-ID: <aZ8r15oUuF-3PN-u@linux.dev>
References: <20260225002434.2953895-1-axelrasmussen@google.com>
 <aZ8dasxUYuuWF9M1@casper.infradead.org>
 <6b5e14a9-751d-4a0d-9d53-b45a0ee5a4ed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b5e14a9-751d-4a0d-9d53-b45a0ee5a4ed@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D53F140019
X-Rspamd-Server: rspam02
X-Stat-Signature: bg474m5dg8sz9e6sdpfdpaxdyze9htr5
X-HE-Tag: 1772039206-586098
X-HE-Meta: U2FsdGVkX1/IK9gIfrasRT2AC6l4QkFi9xuiw+tHxgdRNjFAENOHnoVxgvbQFMGyhdUcTVrpoTo+2ocvyvmD9NaYGUK5csOleCUPhvvSio8HLLLNxOlVGx4Vx3wpLf5V6TOnovhB6acjGwxwL1bTzo6MufKNsl+uLyv+c9PpHjK9rkJR6lT1iU79zyx2Gu24fEL/vfviPDy9bZOQXTRNO2SmWytuLFNXfj8CrDSFiw6kul8q+b5vOPFBq/iYieKK0GjE3aYterA8oKyuYoKxFWP4hLA/UlqvjcTDWjZyhtZLCq/EIaXBQSv+hM5fYLURMiYW8ZJP5Gkw+B6oklbqE6GTZiQD0WW0/K6gltw36kZh6mvTIVtxj4KBc0GNNXO6tcY3H/q1Yw9QhelGyI3DYMdnQe728kfPtZXJKYQrFjUbqcQGZ0nPyB8ed1fhM2ZRdjVgQa6fwoqY5amLtM84zLz/AYdM+8DwVAC/0z6DCLQvrFtaC48QrCJNZjwgSe7DlVhVZhCp/pEckLrxEqx1rXQvOKVdWtyvL16xlUWgSqLgTkZgtEIbqqkTuhD+OA5uI0L3yvvKLTCMwDQ8pKzEInjKmexkfIHjMexetjfksTHjtg1J5K5u2VzcUPjiYJ5IsYcQwNLVkXb9cXZAJpKtchuS5l1Fw/5jbuXPIKbIoqoOj3DjKeYxxXpOhqXS6+6DjJgd5ri9L92RfedMPaRBirTyRoqBTp6Qa3am0pDzmsrVjp/srNPIhQ5jkYClQsjkXrN6AfDPHT277TFDsORVPtlatbiVrkjpFphCRUvpm559sZv74nD6kKQPdBh/NvZn1dFyGDwHypSqjYUJx4uDU2/WoGjGavRhTb8EZRYjB+eLqTRWBzPpWqbr3vcGAD7CfA/n5tDGzSbyDQOzZ7/woHi56w9A/bY4emvWKhjm+aU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+memcg maintainers

On Wed, Feb 25, 2026 at 05:08:28PM +0100, David Hildenbrand (Arm) wrote:
> On 2/25/26 17:03, Matthew Wilcox wrote:
> > On Tue, Feb 24, 2026 at 04:24:34PM -0800, Axel Rasmussen wrote:
> >> This change swapped out mod_node_page_state for lruvec_stat_add_folio.
> >> But, these two APIs are not interchangeable: the lruvec version also
> >> increments memcg stats, in addition to "global" pgdat stats.
> >>
> >> So after this change, the "pagetables" memcg stat in memory.stat always
> >> yields "0", which is a userspace visible regression.
> >>
> >> I tried to look for a refactor where we add a variant of
> >> lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
> >> folio, to try to adhere to the spirit of the original patch. But at the
> >> end of the day this just means we have to call
> >> folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
> >> accomplish much.
> > 
> > Thank you!  I hadn't been able to get a straight answer on this before.
> > 
> > You're right that there's no good function to call, but that just means
> > we need to make one.  The principle here is that (eventually) different
> > memdescs don't need to know about each other.  Obviously we're not there
> > yet, but we can start disentangling them by not casting ptdescs back to
> > folios (even though they're created that way).
> > 
> > Here's three patches smooshed together; I have them separately and I'll
> > post them soon.
> 
> Should we just apply + backport the revert for now and re-do it based on
> the revert?

Yes please.

