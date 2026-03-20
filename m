Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57980108B8F3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5A56B0005; Fri, 20 Mar 2026 06:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCBE6B0088; Fri, 20 Mar 2026 06:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3026B0089; Fri, 20 Mar 2026 06:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AFAD6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:54:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40FFA1B5A3A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:54:25 +0000 (UTC)
X-FDA: 84566132490.14.F1044D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AEEED40005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:54:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=puDGrip8;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774004063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RmEAtv/ldq087p5WkUcZ7qAqdrUlxo7rQHQQ5dQe2w=;
	b=Pn+nyS9nUCUPaPrEDb45uDgdJlErqNivgeV9Zp0Vg+yU7b1ZkbLLZCxi1fs85ADHrw8efj
	yHMtLFqA7+Aj7OzYtev9BE5C7QL5R3oG0hlZqHJIcV5fcTK+4aC1DZ2Oe9M46PxartJWKx
	1BdGI7A+3KesPiKdZxrJVAl45zC3XHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774004063; a=rsa-sha256;
	cv=none;
	b=5vxeb9iro6fng3Jwx8AqMGMeYoWadWxeJBaSSjLeF6FDcGBxaHwe/IKJNR7ipVp9S8k0kp
	sHXKH12yE/1XWS13aQNWDWMjU7gxW8uQmFuOnjq8ZEEDRxzSL0XrWr2ebCiF3MGUgV5+Hh
	BRlD3aZsXok/qSb5m4xmQHgUykAz1+A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=puDGrip8;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 271BA60121;
	Fri, 20 Mar 2026 10:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CF4C4CEF7;
	Fri, 20 Mar 2026 10:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774004062;
	bh=mzR61UNh9R3cT6t9lt6D4+h6dYnwMrWPzwC3fr21QQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=puDGrip8pAPBJoPTTd2uEfcusqL/wtbl7pT4dNGzHIkqG79hpvdpSDEHGyhf13eIi
	 wHZiQ2kkkxHAjr7bkvZez5BUiUroLHnlOpDb98F+KIqOgADT/99OLoRbRvBbArIl6Y
	 v0mI1TQjUQjBHWvBWWFj2tT4jSFcqFC/8XGlNaXyn2jKcS4+nU4J/N3TsPsCweNh9w
	 rB9tg/57fKGImFUCpqZVq//h0n1f8uO6xjeisZ1zL7m0E6XSV65tqrOSYoY3yiGvwY
	 niIEj0iLhL52ONPPklHbTp6p1mDcq15He1NtxiRJTcWOrCD5Pml/3T4WVLYngGaXbC
	 GgBLs5R1yVNoA==
Date: Fri, 20 Mar 2026 10:54:18 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain <dev.jain@arm.com>, 
	Luke Yang <luyang@redhat.com>, jhladky@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/mprotect: move softleaf code out of the main
 function
Message-ID: <4621735a-4adf-4683-ab26-6c0baa156dba@lucifer.local>
References: <20260319183108.1105090-1-pfalcato@suse.de>
 <20260319183108.1105090-3-pfalcato@suse.de>
 <f0ccf41d-16ca-404a-bb84-fe038bcfe0b4@kernel.org>
 <ypaiecdbqmma4imr3euccouexs4uecaacjr4aucv4vynz3xbrm@4xa343ivvazy>
 <75ce12ec-b83c-4b5a-8084-6037d602aa75@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75ce12ec-b83c-4b5a-8084-6037d602aa75@kernel.org>
X-Stat-Signature: pb9nqnybsqzi1tj7ur6zme3xixyewg9p
X-Rspam-User: 
X-Rspamd-Queue-Id: AEEED40005
X-Rspamd-Server: rspam12
X-HE-Tag: 1774004063-649977
X-HE-Meta: U2FsdGVkX194FMGxWano8zVAj5ZH+mb1D2zLTOnOu9F8Zooz5UW0Rw3DBlBgKFmiGSjXuE+k6eM0CLZ2GJMzsq9VIpZayDH/o72eNG/aPtWfRgyjEX04E4cVpZNo4VHCE6MjYGX87XCp+1biuHVdbeqga8U6Qovjk1Bq3j8l2zzMBvuIR9anNx/G2HDl2Cl+yNLdqhzsQXwLOOOiMYdPESzQiWz+E5Tldy9UVB9eMxHxteIhV2/mU3fs0g3b2SgjAHnWzW7wzr3g72fYQtwz7E3yfpsE72Tg1FTW+DJ9nBWOZIkI0Rr8ImUXHoray0WOWntaE1jlFfrteUuciIRrVITKZZI7XkfjWkf4qSDlGi0edV2bqqjSWqvU2fTGnuDpv2bibX7bh/aGB/bKIwcRn77P5jvW6nIuRlhUMk+JnwvZvxk/s9+c6wwUH7RnYZ2IvWpzxFYOXc9bCNecUm1VzV2soT64vQQLhx3xK2U16yTfU4d/Mnozgx/Q1pFpk3NJrGoV8YaD13b2EhDjplO2WOsy4QRP4aq6rIf9woWwuskJilQ0M8qQ7cO+k32xprR4gvXNqFJK+P+yD9KsBjOYAj1Uk3tBWoaYyQeNzCoFzCvEtDTvghbMFEBL33QDGkJz28YsR/oHr3VFU/DsqDlU+QbYGO/7hLO37qfkC5WYGZ7Z5nI/ceN/f9SCuVZyQ7GkvVocEzkxZEkKVTr7X33zPcnjVbcNT56rR/2rg5jy0xySBrQ8V+1PvzRlsVVPnGWv3xC/mj5FGbtI0/M/OAfVEqxFYTbq9xO421wQyKZywEGFOEONtLoN5tUAPqqt4PbNQks4rX1iFx8SA3KFay+/gayd10XLN+SZQYBsU8QdP39s8QolqaJya5gJD3zb6yVFGnwazhzb1P8sBDwq+O16alG/B+lV4+DbI41VOp9tNmJexGNmlbIX5KtvVYAtpaWgH3KVOuJcbfzUtqE47CO
 81xTsb9k
 SN863MfjY2dirBHLa75Ed576i3jL0puXHqZE4NJN6/RrFy7rWMnKcxR32+yzi7Qsa10LwieptVhGg6FziHWowWfRXCWACegT2n7YvsRJC38Uqodt+LBJ6LAhs2ixAf1BimNcYQiquC0Kcu6aUZkCsPN84VWkOgD7xddrgo37fQGBMd5Esm72HFzg47Ctu8FLZRidxlOUjnGCVLMOm/jgsVlv4qRglT80KySIjVrNg+SJawWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07:26AM +0100, David Hildenbrand (Arm) wrote:
> On 3/20/26 11:04, Pedro Falcato wrote:
> > On Thu, Mar 19, 2026 at 10:33:47PM +0100, David Hildenbrand (Arm) wrote:
> >> On 3/19/26 19:31, Pedro Falcato wrote:
> >>> Move softleaf change_pte_range code into a separate function. This makes
> >>> the change_pte_range() function (or where it inlines) a good bit
> >>> smaller. Plus it lessens cognitive load when reading through the
> >>> function.
> >>>
> >>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >>> ---
> >>>  mm/mprotect.c | 128 +++++++++++++++++++++++++++-----------------------
> >>>  1 file changed, 68 insertions(+), 60 deletions(-)
> >>>
> >>> diff --git a/mm/mprotect.c b/mm/mprotect.c
> >>> index 1bd0d4aa07c2..8d4fa38a8a26 100644
> >>> --- a/mm/mprotect.c
> >>> +++ b/mm/mprotect.c
> >>> @@ -211,6 +211,73 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
> >>>  	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
> >>>  }
> >>>
> >>> +static noinline long change_pte_softleaf(struct vm_area_struct *vma,
> >>
> >> Why the noinline? This sounds like something that works good on some
> >> CPUs and bad on others, no?
> >>
> >
> > If you don't like the noinline I can always remove it,
>
> Yes, please. It's easier to argue about __always_inline and constant
> propagation than "this code is too scary big for my CPU so I better do
> an expensive function call if the code is actually needed".

It would make this much more acceptable as a change in general for sure, as it
is already good from a code readability point of view.

Sometimes that and perf align nicely it seems... :)

I do worry about some of these things that might be fine on x86-64, but will
somehow be a total problem on other real architectures (i.e. 64 bit).

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

