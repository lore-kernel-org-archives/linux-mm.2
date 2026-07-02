Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E943C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FDC6B01A9; Thu,  2 Jul 2026 21:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C476B01AE; Thu,  2 Jul 2026 21:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57D66B01AA; Thu,  2 Jul 2026 21:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40B646B01A7
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:21:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EEDD1C0EAF
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:54:12 +0000 (UTC)
X-FDA: 84944283144.16.C114980
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9CFE8A000E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:54:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eoAO/iRv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783007650;
	b=fNfU11TNxyMmeZIJKl0mXwVZoF9c5Cfh7K7YyLLbr4UY1Mm3KHevOGgZc+i1ncBC47kvC3
	KYwInFC1l3wEw5jEnzh6uxrWKxYXNRf3yKHNhy5tIwDFPvrxpYYuQew1fVHkNQe574Pf/M
	8WhkdI8vp5h1CTwb0bu9Hpnw6LRvFBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPtnA5Otm5AEo45RKl1pTz5DNKyMcRXjK9BGaXAsRaM=;
	b=iC7erNpXG64xe6W6GUmCYLRD7DVl/mzlJzIaV2LxEIVXyxodkGkCGE1V5DP+cvAw6AIIP3
	F+mgMjCEko20pN/GmoOjv7fje1jS4kxrjsPLNqKB8rXXysKJxUZamCwxMo+oZNFKZGRfXM
	PRpX5291xXd2vwLmUfDNnopw2ggcOIQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eoAO/iRv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 310D5601E3;
	Thu,  2 Jul 2026 15:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9F31F000E9;
	Thu,  2 Jul 2026 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007649;
	bh=RPtnA5Otm5AEo45RKl1pTz5DNKyMcRXjK9BGaXAsRaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eoAO/iRv4NCJmrbvnkUOji7Q9mno40CpmCEx/xHNPIKlF0pSlsgn/0dhJmrhCIqbx
	 +GNiVM9aP/G36x9UjeZZm2heNXer8jFULVW8lAmYAaqHz+KlUSfxRJqCIhGUOQ2i2g
	 saUMCn1ba8Vz5IJZVJkhfsLt2EzZYpJxMLG7moRbOje8b1ydhS0jJgjiZK4jRZPCWw
	 CtGp2ynJoUX359oHbDa4ynJqyt9G3rQH+xntmnbxug2X+sdWGCahVuVkqy7CUM15s7
	 6nDD3348eRhT+1fPtXRUQiCpbJmV+Sjh1mqVDdhU4cJslL4SNZ8GiZCk66KIEooXNH
	 un8bsV222WgAg==
Date: Thu, 2 Jul 2026 18:54:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] mm: numa_memblks: set numa_nodes_parsed in
 numa_add_memblk()
Message-ID: <akaJnPmqCvNQS8fY@kernel.org>
References: <20260628135828.1393120-1-ekffu200098@gmail.com>
 <20260628135828.1393120-2-ekffu200098@gmail.com>
 <178298867638.1436291.11279946475033863942.b4-review@b4>
 <CABFDxMF4B5cYYw5h+JWwBMFfz9XMVZMJdEwwy3ksRysYBTAZGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMF4B5cYYw5h+JWwBMFfz9XMVZMJdEwwy3ksRysYBTAZGw@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9CFE8A000E
X-Stat-Signature: mm34oujstqi5wpzkbgrwmuuxzqy3gjix
X-Rspam-User: 
X-HE-Tag: 1783007650-777151
X-HE-Meta: U2FsdGVkX18PRcl2+PENZ8Z13TOqW8JbJnqdiOu28KtJVuqaYM1cf+CgLaw3ye/5dkeF5MzJPTPWf+8dbaf9DXszd78koN1Q/APWKPtPQkwzlDbnu2yXFGtWIr3blqO1ZtwyV8PST8sS7VZfBVWxRy7q+ryYLsurKJV5iEvX/aLvk97q2NcKLxZ4NBN6nlLFgqYGyin8dm9vYSQPiI3pHjj3YfX7i+/nefMtHvC6pp9P2LEZDGVM3BeGnxyKV0Fs/Qq5t4sLNzCxHuovh9aRkrMmTfLT8wGOjDTIYIkP67LoBZYEfsD5mG4CQA3gEIGaa5FcN3Yxjn+toIkU76mKv5kjx54YaI23ujj0afjOM9G3VM4S7QQ1ktYJb3np/MkZaT5yCt/JsFWLhGhQBdgzfWsk9cUWp1QHlhKQSLix0pYvTqjronLTa/o2h2fNC9fv69SxeUdpdfbBr8TYCNyqyPDt+qXsLwF7rfMvN5jNDX8lszjYX7x3/ZBpxqIgIL51r4PaortrtBvr2nzj+lBddCMopItnyqv1YLsSErM5fszVCEcw4Hr+K4NGcoPouX9qBmc59bHFaOpbPi03wbTLR4X1AE8t570HYeD0jks8TPMHHsuSLF8GYOj0AGgY7Hs6oiHkbEY/swY66e1rHINtNIvNN5T5appry34OIbWxxVSJau2a3bq/L2O4YYB6JfywzefWi57JODreMxlIUYn9XDdQe/QYLgaP65//6mxDqtoAv+sCEcbPL1pZ6oaQbNV5Um/7xyPx7R3kBvW7rRImXC3WiQhLD/+uiKDch7wK7vq6mHFkthJgWm3tBqTGni6elhzKQccjXV1mu472P0PFEoUTa2srMogYKJC8L0Vubm/Qm13kSuq0OojOgbe3DF1b3MQ1Bjj57N1iMqFEaYCCF/OHKnZdXGKT1DuGn34FGN06Ra2YcFdMYA2ymg2p/RCSltZaZ2U9eIuO0kcu9z2
 WRZXYZFN
 Md+z+Ni2GslBKt7HcAB994Ep1UXXq/lMs0kkTrber27t5NEtZiFYt73inhmSrQEgiuXwx8DPPaJF2Brp2xhktdctwk+aV7E5a021C16vrgaZR9511CX66ejT+BiNwpsRqTQ4+1rf32m8fQZMegJp5RbmakP6mWxdyM1Z7kw9uxzmR6XUU24RfwkSrWOnhCAyjUlPTmFA0rmb/1N0cv8x9xHej8QJQJsvftt/MzaK5ScdEnF9Fph8CpegdfQkA6DyTiA0V7PkfLX5h9dmTszGMB9BzjSAnnqV5EJ5oO2OaYq1yylTPbmQnj8ZOD2FT8Ony8GJTadlwmW3pCPo96lixPh/m3esXk7ikNIr6wmTUp8dsL2ADUS2zy8lx3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 10:43:40PM +0900, Sang-Heon Jeon wrote:
> Hi, Mike
> 
> On Thu, Jul 2, 2026 at 7:38 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > > Every existing numa_add_memblk() caller separately marks the new node in
> > > numa_nodes_parsed with node_set(). Set the node in numa_add_memblk() itself
> > > on a successful add, so this no longer depends on each caller.
> > >
> > > numa_add_memblk_to() now returns -EINVAL for an out-of-range node id, so a
> > > zero return implies @nid was valid. No existing caller passes an
> > > invalid one, so existing callers are unaffected.
> > >
> > > The per-caller node_set() calls are removed in later patches.
> > >
> > > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > >
> > > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > > index 3c3c4eac3514..2d92ca38c02a 100644
> > > --- a/mm/numa_memblks.c
> > > +++ b/mm/numa_memblks.c
> > > @@ -135,14 +135,17 @@ EXPORT_SYMBOL(__node_distance);
> > >  static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
> > >                                    struct numa_meminfo *mi)
> > >  {
> > > -     /* ignore zero length blks */
> > > -     if (start == end)
> > > -             return 0;
> > > -
> > >       /* whine about and ignore invalid blks */
> > > -     if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
> > > +     if (nid < 0 || nid >= MAX_NUMNODES) {
> > >               pr_warn("Warning: invalid memblk node %d [mem %#010Lx-%#010Lx]\n",
> > >                       nid, start, end - 1);
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     /* ignore zero length or invalid blks */
> > > +     if (start >= end) {
> > > +             pr_warn("Warning: invalid memblk node size %d [mem %#010Lx-%#010Lx]\n",
> > > +                     nid, start, end - 1);
> >
> > Nit: any reason to put this check here instead of replacing
> >
> >         if (start == end)
> >
> > ?
> 
> Reordering is needed to ensure the following node_set() is not called
> with an invalid nid.
> While doing that, I thought the start == end condition is the same
> kind of invalid blk, so I moved it into the warning block.
> But no strong opinion here though. Should I go back to not printing
> the warning for start == end in v2?

Yeah, please skip the warning in v2.
 
> > --
> > Sincerely yours,
> > Mike.
> >
> 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.

