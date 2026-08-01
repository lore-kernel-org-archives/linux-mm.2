Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C55C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 09:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6DC76B007B; Sat,  1 Aug 2026 05:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0906B0088; Sat,  1 Aug 2026 05:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97E96B008A; Sat,  1 Aug 2026 05:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83EC26B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:55:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BA59A13E5
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:55:06 +0000 (UTC)
X-FDA: 85052242212.29.5B5FC9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BEED7120007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 09:55:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPRYIb37;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785578104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFimMY+66vDtJjjDREKw2RHKWOlJhCZTZ9XRI/dPEZY=;
	b=1YMw1TAtk56iaYBLzPtIqOsA+BK/FMmMKwu3ruSVEprggfq1F3syHDsVom26DvkiYnwKCh
	D0aumLzx91XxgyQF52ABoKuiTswHvbIuyVAH3Sml21HhnEztp/lm4VyfVTG2MeWSiEKEEL
	DMFfO9yp8qDkykg/HVoH6ki4rXuN6hQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785578104;
	b=RJGPaIOKu5fa33owtv3d+6iOi/TsoNsjJFFVv26iXVPbtewKuBrhy9VnLaen5sGpfJeunl
	phgz557EyAG8Zs8dpRq9ZEN7rKK14UiM7R6fXhtO6/YkkB68KOiQoL79KELCZIxp9GUVlz
	3C0svdzB22mHlU94HZaPikxtO1McYAg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPRYIb37;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C7F945612;
	Sat,  1 Aug 2026 09:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1BC1F00AC4;
	Sat,  1 Aug 2026 09:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785578099;
	bh=jFimMY+66vDtJjjDREKw2RHKWOlJhCZTZ9XRI/dPEZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HPRYIb37nDpXpoKf0nvC96ILr5uNUw+B/hJjvV9LMi+JnkzQkvufG/Fk+cvGgb3QJ
	 M7PDMbC9fDWkZy4ahTEfKoJzOdJUQQCAn+Bu34CqdDcfi3xoNoMd4cHGW+Y0h3gfw9
	 WgsY9CWuLtNPAEIUDDA1X8gY2ojh6r1xrSAMVqfKmKRo//X4ggMS/w/r0ILEh4RIHz
	 gl5ODOZgu8A7OPHzRrthTdAp1TTXi4gbvq6oQRAHAI5GhUMP88+hy4GY5aGnN4BzuM
	 NG6FOKIFhJisG59hiVNgEgVTWlrKm91LtRMEGYQ68ejuQYuf+uqG9RHwrS6htGMTlA
	 /NYM4m+FXlpnQ==
Date: Sat, 1 Aug 2026 10:54:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Aristeu Rozanski <aris@ruivo.org>
Subject: Re: [PATCH RFC] mm/gup: batch contiguous pages in follow_page_mask()
 and return them via a pages array
Message-ID: <am2_dWJKZBzwd8EK@lucifer>
References: <20260730035350.1fc95dd8@fangorn>
 <amyUQahYOgov0z8c@lucifer>
 <e969b38ce882b32d041b7279499fddcd00f18b35.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e969b38ce882b32d041b7279499fddcd00f18b35.camel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BEED7120007
X-Stat-Signature: 8qhyj66uat9whb56s3t5nd6r9xpy4jmi
X-HE-Tag: 1785578104-983879
X-HE-Meta: U2FsdGVkX19KpmgphUKsKgv1xE43VYPsl+SIwh1RX2VskGOinAwI9cnkuyWDpF/X3Bk9yQrFoYj1qkouOD7bsuyKyL3qcYgVEb9gLtkVqO4nZojTSONGXkHm/XwaTsf9BLO8L0Br0jtZQz6HGRBmiaWWHGlESMxegODMRYSfoRIaH7VOHJgQt4sZmrXVUTme6tKVwybpC0Zct2z29IBBdwLduem3Qe+c8+KXrD6SB3ifwOTXWXKQgIo0NCF7V+cJmPzYizUv/1z+kybTCUTxuF+XtVylhlhsykNlWoauw32yn+2f26j1A6FjdZ5yw746UfekcPNQKutIgLWt0Ea7L4KFKBC/qOE5/vwele0tXaY3ve8KU7afy74ilodDRTlppQmAR4MrqCAyun7WiYRnw0793yGQgGProX0UzSE932HuDg04dmPt/UxR1mL7/84XSjRQ5UIwsfLc7GNSPGWTjS+G2n3aYFDynsyZuZVAp2s7AWJGA6+6wnVvPLkGqNwgAy3nOx3CZTw47Kq5Ug2k5ccwVNZlpHyz6D5/1n5EI7t5Kle1evA7Dfh9XeHl5sVeb3D7l/CfKENwz77LxB6Hmu980WtNXcclk7YYn5Ru9Bs1DSjA7JT6u0fhIhxCSa0tQ34xGJECjwlqGAeckkcPpU40ovZtyn+Ut/bYIj0B0Zj+QJFXv9cdF/jhUrjCK/BXtL8gsFcA5FuNZGvvbmQu8Br3OvxntFaOMdLsexb0yC7OI5plrA2aML80B8pMoI87kwrjIsvLsLHabStdxudmaosiiguFVss4uszU9SnfruT/wvVGZ2r8v0FZVd0W2vmvc89qCExpOfMxgJVKQ3UjTOQHsg0AqFJzMpwx7kAGJEYsRdCdfHscS7f4DKoTJOAD4mD9WEaOJguLtwavrhNc7j/8rw4vi8jbBIK5IYJHq/+0vZd5y6dRBi2TXZV6SguXsObYSnbW4XEkd/IvDLx
 8xcMv5ur
 D39byyZq7GSRmUgq8v+dRp0Px4DBVYhaJ4Hve4gPxYSZN8gUKthD1hpWTVBqytfGLyJWZShH+msQQzM7hxVfdy6un40gjf4w2tGgrWdUAGyhkMuW5wxUwAV79/vovJshXMDmF2xD4VXajnlUQuzUwZtLMEgQRfPqR7FYQDzTQV3q4TIIma73dqdZ499gaR7Sl4aVzQCsHAApE8l3zjDe1GXgvEi7fBR4bRjRsrhfF0esxotADbVqqQw0UBLjcB+MA417EWqtV2zrYv9hTqZ7TzYYe8pcucTlvtt/2qDFsHIOWiq9XDvZ6HNcYJEEPo+hHBXrE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 02:32:58PM -0400, Rik van Riel wrote:
> On Fri, 2026-07-31 at 13:33 +0100, Lorenzo Stoakes (ARM) wrote:
> > >  mm/gup.c | 539 +++++++++++++++++++++++++++++++++------------------
> > > ----
> >
> > OK it seems the message isn't really getting through...
> >
> > You really have to spend at least some time filtering this LLM-
> > generated
> > stuff.
> >
> I spent a fair amount of time cleaning up the code
> and comments. Arguably the new code is cleaner than
> the old code was.

Thanks for doing a human pass but it LLM's habits really carried through
here. In general:

- No walls of text please - fewer words are better, clarity is king.

- Don't write the code in English as a comment/commit msg - redudant and
  distracting.

- Sensible patch separation obviously please.

- Write as elegant/reasonable code as possible. If the code you touch was
  some horrible mega-function, take the time to refactor it. Pay down
  technical debt.

These are all things LLMs are extremely bad at (even fable). So they need
to be done by a human.

>
> However, I do agree this patch is too big. That won't
> happen again.
>
> > Nobody's got time for walls of text and giant changes like this.
> >
>
> I had no idea how to split it up when I made it,
> but have found a few ways now.
>
> I've split up the patch into a series of 5 now:
> 1) mm/gup: convert follow_page_mask() to return a long
> 2) mm/gup: split follow_page_pte_commit() out of follow_page_pte()
> 3) mm/gup: add gup_fill_pages() and use it
> 4) mm/gup: return a huge page's full count from follow_page_mask()
> 5) mm/gup: walk multiple PTEs per follow_page_pte() call
>
> The changelogs naturally got shorter with things
> split up this way.

OK I guess we'll see on respin about the comments.

>
> > And at least use a reasonable model - sonnet isn't intended for
> > kernel
> > development is it?
>
> Also, I have found that while Opus tends to make fewer
> mistakes than Sonnet, they both produce unreadable LLM
> output when left alone.

Unfortunately based on your recent submissions I don't agree.

In general, even with fable, I've found that the code it generates is
nowhere near kernel quality.

I'd suggest using the generated code as guidance only and the LLM for
checking things rather than making things.

>
> In order for them to produce code that is at least a
> good starting point for editing, they need to follow
> rules.
>
> Once you apply the rules, Opus and Sonnet do not
> produce results that are all that different from
> each other.
>
> I just added a few new rules, so the tooling won't
> even let me create too-large patches any more.

I mean, sure, but what's needed here is human Rik :)

>
>
> Whenever you see me, or somebody else, produce
> something wrong, either with or without an LLM,
> please yell at me, so I can add the proper rules
> to kernel-style (creation side), or review-prompts
> (review side), so those things get caught
> automatically in the future, and not sent to the
> list.

Well as you can tell I'm not afraid to - well I wouldn't say yell, more
civilised than that - protest :)

In general, again, the human layer is what's needed here not more rules
IMO.

Reviewer/submitter asymmetry was already a huge problem, AI slop makes it
critical and means people repeatedly submitting things that look like that
will get rejected out of hand.

Let's try to avoid that here :)

>
> --
> All Rights Reversed.

--
Cheers, Lorenzo

