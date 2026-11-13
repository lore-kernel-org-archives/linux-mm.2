Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A039606B5F9
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhOiuVjo
Received: by kanga.kvack.org (Postfix)
	id 0CBCA6B05BB; Fri, 13 Nov 2026 11:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064626B05BC; Fri, 13 Nov 2026 11:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E719E6B05BD; Fri, 13 Nov 2026 11:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C33066B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:22:14 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56238160366
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:22:14 +0000 (UTC)
X-FDA: 85430612988.01.1A870AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA8BF40009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:22:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhOiuVjo;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794586932;
	b=HHYtinYfBFIRsyKYfHt7TyhcaVIZwhcl/HJVNCiDmN+dvEzlQf7AAw0UyvYLpdNu79qT8d
	ym3UZZxvweryL/faQ/LBrVAXM/gwAqe0+FtDmdjLfjluTSmypQWPaJlPMS1jY1p7i06x19
	PeKNKB1v5Dy/o3pIsPs8SsuQlhM0Mjg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhOiuVjo;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794586932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xRhj/gyeHWvM7uP+DX2CEqlmuVU0a73t7C3sKCpydc=;
	b=WS8a3vrvnJm3Spny5mfXDiQv66iOreruTKpDffqcD737kpIH7rmK9gqNQOIFtDn54w7/xF
	CUZTnVXIn/VxCD5fKWf5N64XHCzwsdlfIX7bc8IlalIAHTkNa5XS1ZTTp7of+nXparh7Nm
	W4edc99/702pUXn3eeUqQLEZoB0/LkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A27062900;
	Fri, 13 Nov 2026 16:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02ED71F000C4;
	Fri, 13 Nov 2026 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794586931;
	bh=/xRhj/gyeHWvM7uP+DX2CEqlmuVU0a73t7C3sKCpydc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mhOiuVjoFen0ouPOH42GO7BtOtPX2CYPVaHQAv929yshJqki53U8U0ZPai4Wt7Ssw
	 AAsdXJpS1uPUq6bkESvXH4k92/y/apApWNi3VPCYTPfkgSwZW2zNAsS6Otpen6Q8IH
	 coJ0jy3q/uArOBnKfZWn7IrNrFNdVGV69/ap6tLfGs9xqbTUuI4ymF+Olpf275r9J6
	 l6nUSQJ8q7Llht2/2OMP2LMuPDu4zuVDwBvRu6cQDQX3Ll9vkC3vv0y51MPlVMaGYZ
	 4c5/kdbFVNWcVGkXpJMmXpV7q8Mp7pZZGDABQQ+GYoLZ/39W9bcoVztQbeycYENrq/
	 tkt7PN4Edskeg==
Date: Fri, 13 Nov 2026 18:22:04 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Frank van der Linden <fvdl@google.com>,
	Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Oscar Salvador <osalvador@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/cma: simplify cma_declare_contiguous_multi()
Message-ID: <avc5LNF6rExATD3z@kernel.org>
References: <20261112-cma-multi-v3-1-663407328e0a@kernel.org>
 <20261112223851.d441a97711d43f91a25ffa87@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112223851.d441a97711d43f91a25ffa87@linux-foundation.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA8BF40009
X-Stat-Signature: xihanojhgoyno98n671j5h37dwxiucyn
X-Rspam-User: 
X-HE-Tag: 1794586932-17194
X-HE-Meta: U2FsdGVkX19D2B5CK8hUk3y/RDQuhRpIEBLB2jNL7CxNo9eJywbN8LjfWqB+ON2AynPK9ghfHD77cBbOCrwtuOvtsxOqF8q+R0ue00C91JcddfLnQtvvBGP9/z95asm9QSVTaDahDuimD6rIbhrbK8HgyblCMR2Bi4+Q9gnhgC049QFHr90/SjXluYvTisdy0nzeNGEgdEkYF1dc9qYwTyxNd+U914zlcxQ4NODAjpElm3yhkz5AHrmFglffBZufQmRMIwV9YfwUZx0cGGpuJCicv9NI+Ddsh0jyeYP0FXJ+I5Ed9NwxxySMac3nnaMVyDTKlboTTGr5lAdjkjDrWlBivJtw/3H1jqwa11copiWbMZabCFInLF1q+ovxLCWTpmBkxW0FHYUnHGZZhzSb/tze74lhfd94x4R3qXzk2CCozj82KhjHq4KQFkQ2kLNyUYaR22hjlJGI4CK/iQFqS6ty1WNaNHgg8/cA0dFCQQqjX5IT5Cy79NX0hGb7XSpTEdPjV0P6vbPtJ2dle9x79vkRzvUx2ECy6dKvvYNARIcUUcaPxhi/e5W6YY7JCbzMZs8/0gqSETRF+N6xbRl5y3Aozsf9+2IGN05gplHRwIKWmXoqHseQHvpKsukFJEqljVObHWFjFpjRq4qrTwuIo9saQo4sKkaS/afiN+5J6gJMk7y4oYHq5kI39sMn0KsA9e+w1aIhFBqlxLsGUwFYLSXDTJmAZZk+pI89DhV2EhVdDJviI0TEkiRzSZ7oX0eQjyVu4V88limWuzfkMdq8HJwlzkzGjs45NiKXbrd/kIiOdNLNoVtAn4cuE05Qa6d3pSmaoUCO598nKzbYkiAF/4qaKv+sGvOaB8C6adRAkESU32NA2S6bd/6IjSr9B/qOGVWvz0omptA41WAkXQ76BhLUNT/yuXVgTfBtn1nnJB1r6RT6/rZdWBRH0+bSfdJokLN6ZBThL7Xxa1j+M4O
 Z+PJ/EPp
 GGWnngcVBzsn8EcRe7UWTJ15Nz7TK4gbKPA6XggaB744cb3QPINxkrM+2QZRMdN2lCLSqyUnLxJE2eQ1t1Y2Tx+o+dETjMbUF143Nc/6E81YRZ1ScAe4usg+WXVt9gDEtnA9OcQC1fc3RO1jkCvRvGB2mtMovW00KLJlwrL4ZA/EO1Z/Ib/e9u+uLrmIj/SqTV+sNouF09JYtc9xFMv4V11n/ZFZPWmmu519nZ5X9USF39v8aYj9fbabCO4PX81HDEzoMaECV8l1MrWewOxTHJXOsBeTsJSew9F82j7iIcG3ZPmjyLxM1PK5Sd4Kcx1zYMP7mk9yraU92ccgS6q20yxrVQm3b+xu9B+m2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 10:38:51PM -0800, Andrew Morton wrote:
> On Thu, 12 Nov 2026 10:16:57 +0200 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> > When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> > single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> > largest free ranges above 4G, reserves them in memblock and adds them to
> > cma->ranges.
> > 
> > The list and subsequently cma->ranges are supposed to be sorted in the
> > order of base addresses of the "allocated" ranges.
> > 
> > This implementation has two bugs:
> > 
> > * The allocation may fail even when there is enough free memory because
> >   list_insert_sorted() sorts the list in the wrong order.
> > 
> >   When the list is full, the largest range is evicted rather than the
> >   smallest, the final list is not sorted by address, and the smallest
> >   ranges are used first.
> > 
> > * the function may report success while it reserved less memory than
> >   requested because sizesum accounts for ranges that were skipped.
> > 
> > And overall it is a lot of list management and open coded range
> > selection for no real gain.
> > 
> > Replace the current code with a loop that finds the largest free range
> > above 4G, reserves as much of it as needed and repeats until the entire
> > area is reserved or CMA_MAX_RANGES ranges are used.
> > 
> > After successful alocation sort the cma->ranges by their base address.
> > 
> > The new code scans free memory once for every range rather than once
> > for all ranges, so it is slightly slower, but it is way simpler and more
> > robust.
> 
> Thanks.
> 
> >  mm/cma.c | 269 +++++++++++++++++++--------------------------------------------
> >  1 file changed, 81 insertions(+), 188 deletions(-)
> 
> Win.
> 
> 
> Ivy's 2-patch series
> https://lore.kernel.org/cover.1792032699.git.skunkolee@gmail.com
> carried cc:stable but "No kernel-level reproducer was produced and
> nothing was tested beyond compiling; the examples in the commit
> messages come from a userspace copy of the helper and the selection
> loop, written from the source.".  And my LLM's web trawl couldn't find
> reports of anyone hitting this.
> 
> So I'm thinking next-merge-window, no cc:stable.

Yes, and there will be v4, sigh


-- 
Sincerely yours,
Mike.

