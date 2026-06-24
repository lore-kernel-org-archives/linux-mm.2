Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8C5CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 15:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298B76B00B7; Wed, 24 Jun 2026 11:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2713F6B00BB; Wed, 24 Jun 2026 11:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160986B00BC; Wed, 24 Jun 2026 11:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE57E6B00B7
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:11:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 616041203AB
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:11:17 +0000 (UTC)
X-FDA: 84915144594.03.A0563FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A860B40002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 15:11:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAgONeGZ;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313875;
	b=X8HiDadZZar0iHjvmKAPA67bCMmfd3RH5CqH7Qokp3XE2I9CSUjcanBnXVB69wwBGpmAXn
	EBxgWQavYm8lJVo3Pc6mFzghsF8RPWwoM+8/4esAsx+NlT/eyi9H9I9BbLPZ8UjC4qboo1
	j3Z0PGh+/kIshEkHoMfv3nYr00LOeOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WJfoGRd+NAOfw8c5h3qeDmnmfSaUjJK87qUlIYi3+E=;
	b=Ggm/ORMABukrmD371qXvjhTnMoR/RPK/+sq3+WXj/WhvrGLeOSfY/j2jRJWvmtmy/ev8Ji
	H0OhvJ6FmPUe6V7yrucX9wI5D1GdYu5D/2RtATAs1CyF83Vok0dyr1VCzFBUSyPjqYwRYc
	OK9qy31DBXVasuQL/0LAufw5SNnesHc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fAgONeGZ;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF735408A5;
	Wed, 24 Jun 2026 15:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3904C1F000E9;
	Wed, 24 Jun 2026 15:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782313874;
	bh=+WJfoGRd+NAOfw8c5h3qeDmnmfSaUjJK87qUlIYi3+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fAgONeGZaWn22E5+FjUE+WnnUF2s1EHj7SSaT1IWyGLrDVmmDBZTrScDLDdnpTLM8
	 BqXe1YZSsknnWhOhTTNs7kBK8/ovaC7Ro2k/GvmeSobEd6BBfPxPyQqD79jTtg5CXH
	 wQG54Yh0PExA7xH8tzX8MBGt4cfx8ZmZ1vpfnElBD1yV0IM9QxBAED/x7E/LTN0lMO
	 XUyFNhUqMrykFfDrJTSljiilpYZ1rLDcl2pQOktLE7OakpBA+t2ZjG6hs567lxhpXe
	 rQRnnNh2YLY+Xq6LWZebUWAFCjImA1dFIOi7pV+4L9h93ZE040cRNuKw5xIzf/g0IS
	 a2vFp+LHWpGdw==
Date: Wed, 24 Jun 2026 16:11:03 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Brendan Jackman <jackmanb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 11/13] alloc_tag: Move to mm/
Message-ID: <ajvzfXkKoCXAxg59@lucifer>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-11-31f31367d420@google.com>
 <ajrA4wiAKTdiraEO@lucifer>
 <CAJuCfpHqvLVnycuufO6Kf3S_RSFjyDRUnTGDyu3VW0kQ90tiHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHqvLVnycuufO6Kf3S_RSFjyDRUnTGDyu3VW0kQ90tiHQ@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: haq3ki1cwd63nya8hxn67oqf46okg17h
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A860B40002
X-HE-Tag: 1782313875-261627
X-HE-Meta: U2FsdGVkX1+pqv/NKmgKEUfv7y+ywXrS31OClX3fgDCjVh3v7VEANivjbAUh9PXb8fMrgzpMCJrP5mgEl9aroQPQBZWhOh/tiCs9P1qN4pDa1tXsiClMZQx1yYW63iRT3Y5bcebAOoqcvuvILXHZ/xiI7UYpbgepHK9P6y0I75IsFk5MijqeCKE47cZxWJAu1j6DwlSOZ+l9goNv4Q0HNObv3Ig4O47IBiG+/X55zz9O9TfTRFv2HhzUJklwk4908O9DfMj/BySu8n0Eb+tFOtOJ7NPzqoYUTztSCyrCHtImO705BbJt0nrnmY5yTesO4YRs5dyszkHXUDDss4mZIQNW4mqz2Scki5eRlgUvZ558EInzoQBy4W3vw4bZ7uSr91o1d/LXLf83SCEIhm5gFZo+cV6qT1q5Hgd3rvdXF1hYgnaABpm7E2o2KmSK4801E1Uh8u3ofQPy4/3M/NT1r0ml8AYmrtPcX4/ul54XEoeQU3TQriecu8grtjL2Qux5rDOmJrfDnPXp1p7RkOYPjEDNb3oQCzEz4sqju6lvNWRuFju1zz6mfj+dy33V7I6DvKtp0i+RMNylDXpIiW1wjoxBzrhpEUpSAJNJlSOYjD/YzxCqzBipxX1ZYwslH9jNfzVYbjqqdPr2V2lPcOtXt4Xt4M57HhnStpl8aus6eWu1dV00/Ij63gSR018P2M73n0laIZnLEkwXbvan+nN0k0OTsKSXdXhPprtC0MoIRUykuttnUKw2gLdUzK1FupVWcORidHZN7Ksus6rgQrcO1GHM9laYK2tbJ8OO2L3dtVXKn2ldx0+8zTZIVWUjLjqDpwf9bpy873ILlnNXGDwMT1b71dXkgAqBYQx49TNp/Vsex/B6g4FBnBgY/IqhCj+2FTI4Tv27SGrxlbsZkKOwknYiUKX75JucQZjLLlD8i3EPSzLO7znZkYQDEE1d+DXyFAle4YJpE+XUcoqgQ41
 YeDtilVW
 ZROxd8hDz3YeTAtj01MuKBpTOD5aLsoier85ImurYPO6V35ZfjMhyXNdGxWIEBo6P4yOFZcJiej8s7YZYSLcil7ekRpR6yhBfzxz0RJkPoXGi0d5q3lhMrsGFX77MxJDQfGO23MOTNykkRMn+ybmWr83abFClxv5KydUim8vkhwDIZviqESC7wwGGN8HKhnh8idV/zxKSFDlX0nh9Danw5HYztuF6w3z5XrDVUvwNAQ5maned6ydvVYjbZH/0OyUUxB497Z3q10ALUfujYXqkmE7eXUdf1ATQNWMWhcy7r/KNyzZ3GWjNNt+nRvnyrAeHPDTPiP/z7MJxAcgul7pch1FDjw1lYKlUCXD24zDAn0MIvysbX+ctinx57ZfSPQ8nn7raaOVxy04d47l5CZHz6mik48QIxF2hQu+k6/OOXRhgvhXzszoga6SQ75bqTYBIW+Yn8s2cH/I0kQq8ywHaxLzCbTKbXlVnSQnd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 04:48:04PM -0700, Suren Baghdasaryan wrote:
> On Tue, Jun 23, 2026 at 10:29 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Mon, Jun 22, 2026 at 10:01:38AM +0000, Brendan Jackman wrote:
> > > This is logically mm code. Moving to mm/ allows access to mm/internal.h
> > >
> > > Signed-off-by: Brendan Jackman <jackmanb@google.com>
> >
> > Sorry to be a pain, but I feel that this change should be dealt with separately
> > perhaps as a pre-requisite to this series.
>
> I know you have an idea for some cleanup. Let's wait for your patch
> and then rebase this series over it. In the meantime I'll start
> reviewing the rest.

Thanks!

Cheers, Lorenzo

