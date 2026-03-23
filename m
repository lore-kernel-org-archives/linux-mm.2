Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606DEF483D6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56FF6B0005; Mon, 23 Mar 2026 12:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07EF6B0088; Mon, 23 Mar 2026 12:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F66A6B0095; Mon, 23 Mar 2026 12:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A50E6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:35:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2D151A0C76
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:35:50 +0000 (UTC)
X-FDA: 84577879260.14.B7B8E72
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA98640012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:35:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Pb2YyXQ7;
	spf=pass (imf27.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774283749; a=rsa-sha256;
	cv=none;
	b=BNxqq8whc4TfOxqpFogNID7swrEVI8/Db4CzXD6oEvKJS6JteJB0iO9ZttJrCxmLGIknuU
	jE33MJDTtDBgX4QvMIMPcqySYVv1jok9LOkFYDYOm2wHGdnqFMe8WoO1IBcalZ6TzW9TfW
	HMk5mYOy19un8KEpwTu+z8Wv6ITBKVU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774283749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=au/DBt4TsnTCso1YPGCkQuN+bqByYyQKJLWa66VyrXc=;
	b=XurzoEaC5HzA3bCoAR7/cGKYyYxzUgk4Fu6ZDYZr9J4uDqdDWNLNKDw+s284IlkBmVIIa8
	+6ZZr/jW0wZrxcFX9WQPBSNoJa1nbPuwHkD+SXmurXdc7jkTIukQaWlM6jk8iiQ2ZFTXu3
	noEDV8ZPRs7ANGfB55K4jC61Xx8z6v0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Pb2YyXQ7;
	spf=pass (imf27.hostedemail.com: domain of carges@cloudflare.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-467166cb638so900941b6e.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1774283747; x=1774888547; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=au/DBt4TsnTCso1YPGCkQuN+bqByYyQKJLWa66VyrXc=;
        b=Pb2YyXQ7KzzbGddXRjdbocQiub5QdqFxEWheQezfUIhuzIn8l4q2o70RoQVfigTTVL
         kX0MNk8sGIUZhxuhcCEhAt2toGVOfjiqpSN2ZheXccTcYJpVmoqcwBBCZTABlCxahngF
         HQc73qqMamHabbDrOsemjCXB4aCRDOCS9y8mqa3qRy56j/54uceSlhwLspMTwOdx7Il3
         i5HSVDcThWxGX8U6CAHHOGulpXm7uXDgM1NAWtXvRhMeDQMM1/S8BiGekPPDlKrC9sZ9
         TXsHzgoyEm2Vq9yUudKRLzsCuUzOnT/1nzs5xQynlLc4xsjtcUqI0L/8/0QPRXseQQz2
         LwZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774283747; x=1774888547;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=au/DBt4TsnTCso1YPGCkQuN+bqByYyQKJLWa66VyrXc=;
        b=lx/9VCZSpOpa1Lssue9jq7oofYrPh/u3Sbw+uQn3XexOX4SFM1t/HmJyvl9xWLORWG
         /oBa+D0D8MyKgt/W1aYPQ7NlqV2izABqnq4sFKsspD/Q3oBDlxtO82H4EA3UBJtXAd0/
         JomiQgFLHfIS98HsPeYtY03XZXKFiWblgyecuCIRJ0nZvE4HIOFj03GTytvSc1Gwd6Ea
         w+mefTL9x+KbTw9ROZ64TmtepSreomXOZfLc9vH2sN04BmnfeEFzB4U0egSgDsGdgG1T
         D2dIbVd5yhXQZeGdCbEEF37R556+ukh16+CkFmW9GhdnKrbHAlky/2t8fZcssl7lD++c
         uj5g==
X-Forwarded-Encrypted: i=1; AJvYcCVpkwSEaQRhuXyFAcSGx6cRMqGz1KNqU1OUZ58M/Fr0Lg+KDSPk2UWRBLBGqqVWIR8Il2ozbiUT0w==@kvack.org
X-Gm-Message-State: AOJu0YyCCsBmBjWxZE3+fLbte+88oXZwLiPbyzZaVb8c+IRrcVhF7OZd
	sZpcXnNxv6suViHyBBZrJbKUPxpAe+nZcRqP8C/iCquxxJRBrbzu0/WPGHNn7GCNCi8=
X-Gm-Gg: ATEYQzxsaYGyItfuMqtSR0WWoCGUaUEmF69d97uRdQkNp/lNNSn0VEm5uqyay9J0Rf8
	BhusW2Jm6WUNgbHOwirS7/U4IkzdgBkDzExfxXqf5pw6eyUnpeEYsgyVOJexkUZdBT1/20KU4he
	5BFpoO0valC3gx4UCqt4iPsp5zfGpXF8CQRysKLHmHz/3VPa7AvYkjOsJMrT5u7doR1sSYLfDY7
	evPGd8TGSiymRtmp1DEwGzPGupekA080ugLl1x3u0crX+U4Ow5P0ohmhRyQz/8kpV0cbFSPXlgW
	BMmQoN9miMtjgabZXI269P4dcVJMOGl6OHSH//5maN0B50Ro6mMl9QyHVAP/XmB9shDJ6MUzei3
	kFgphJHzu/He8n7h0EF2dFgKsHKl7NusVKuQqsr6ruUtQL/wIKeKStwdKO7SFNQ6jwXx/HveQ3p
	n0VmPLLQ==
X-Received: by 2002:a05:6808:669a:20b0:463:8fba:5e00 with SMTP id 5614622812f47-467e5eebfe8mr5354383b6e.30.1774283747596;
        Mon, 23 Mar 2026 09:35:47 -0700 (PDT)
Received: from 20HS2G4 ([2a09:bac6:bf21:2632::3ce:1])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46811e5164esm3658248b6e.0.2026.03.23.09.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 09:35:46 -0700 (PDT)
Date: Mon, 23 Mar 2026 11:35:44 -0500
From: Chris Arges <carges@cloudflare.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <acFr4JJgaXsD9gtQ@20HS2G4>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
 <aas06mfCrJuzZd0-@20HS2G4>
 <aas3E9P0BP03O8ma@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aas3E9P0BP03O8ma@thinkstation>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA98640012
X-Stat-Signature: jioi9b9o6y57zq4rmn97xsho8d9zj5re
X-HE-Tag: 1774283748-838184
X-HE-Meta: U2FsdGVkX18Me+T0RIyey0mS1eakJ5eLRvV91GvlkhIfyg8pOsqYUQBYnBydm43DEM19z6dj0t2BFSDrm/iN8bXfGOjNt9eQFTpgx2XnOBrMMwdIYeDjbVn3wty4sdhV5mGwI96i91BmnoEiEN7W2HtSsJuQ/OGFX3H8omRdfehdX3rizUuit4s9s5dl32rfAo6M8oFF6QvWmtrpTbTr+K/JrNulBGYv/xg0OwEoWBBBZUI/EjLHK/a5lTm8ixIqbLyFtIjZBdO8G0upSWWJr5FKoOhUIkI3EL8Pk2J9XXT0t7usf6eOgJoZ+f6WNk/ewxy5MKl/AG3YaXeFm2BvvYkYkYdp8ZHUfvOQpHgQcn/DI4gcmzmxtuD2T1oXtal3vO0fmlUEdxhsSp2SX6phesLd5rp6GKZAQRixMlNy9KxxhYmMpq6tNHi60JUV3/5kZw9nYWxxX+YUiJ7WTqlk4Ss1kWvzs53jaBi6szuZHJR+SLkmosrBUEC5f2WyU81ffm/5kUt2gXrk1KrGCxY7uca/Q7HQwOp4DPiGjgpUi30BQO5bi7HRilbEBT+z4hNonkDjY9EFVYiLsfXGcvNgsTziS0EX3+6YT1Bh2SGt4C9YI+SPbrXHsi9oBVJGhIBqSSPC1UI2HcF0vTNHK5SiL4g4UK/Eww2wyiO1rARhK0+x0mU7bSoP6B45gB+EChMjXKjCGpg08S2exUnPksvTjX41zhDlTMxYm1IM5RKW99ksugr+IjZDI2NlDMLM7O/Y1qv0EP9uG1N3Rvf/COhpIQA1Btymh+9r+/68TtjTbBuMfXsmDa9N9cgdDr+LsD5gVb/qaKHKDOrH7FEbpLW0HAr5j0llIKoWjkbVZsImmYaIKpH8UKunICR7JoQBpxLF7b7YGHqm4ilwz8HImMN8h869AjAEihN1tI92QdgZmG0TUOougkbBJ4RCs5rsJCDRZtGZTFkdJ0+1OEEgotH
 Rg+9hoOR
 FFxxw8tOg9Bry7kE3n5Cohy0EnFE629zcYpBnaj/4ZCtYCDklZPtr8cGO/hOxT2oO4Z9De9DxMr/TeFi9tYBiYbeD1SQqOINqWua1auFdlX2JKxYZ2f4uwd9wvc8MZvPfVcRMcvBDfJX/4qNzUMo0ntrRDiM/YWBUMOuASezx6Wnt8tpW/MInA93USsXlV20W06giqg1m79jbR/t7BztQapHG36bsgTRkqNUIb4CP0Eve2vB5yDpRt2w0VxGmtjnLXIgKa/MzjvwFmOyccIwtrFzte9a4iV2FaPhen+V5GGCL3QYftIxRFE3lif2EBf0w+8eXMsFAle0a+SjPslpX3XsKg2AXQ4sSjj2/U1vVrTMflxQQTOSZDxsL4dSOLa0z6qjq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-06 20:21:59, Kiryl Shutsemau wrote:
> On Fri, Mar 06, 2026 at 02:11:22PM -0600, Chris Arges wrote:
> > On 2026-03-06 16:28:19, Matthew Wilcox wrote:
> > > On Fri, Mar 06, 2026 at 02:13:26PM +0000, Kiryl Shutsemau wrote:
> > > > On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> > > > > folio_split() needs to be sure that it's the only one holding a reference
> > > > > to the folio.  To that end, it calculates the expected refcount of the
> > > > > folio, and freezes it (sets the refcount to 0 if the refcount is the
> > > > > expected value).  Once filemap_get_entry() has incremented the refcount,
> > > > > freezing will fail.
> > > > > 
> > > > > But of course, we can race.  filemap_get_entry() can load a folio first,
> > > > > the entire folio_split can happen, then it calls folio_try_get() and
> > > > > succeeds, but it no longer covers the index we were looking for.  That's
> > > > > what the xas_reload() is trying to prevent -- if the index is for a
> > > > > folio which has changed, then the xas_reload() should come back with a
> > > > > different folio and we goto repeat.
> > > > > 
> > > > > So how did we get through this with a reference to the wrong folio?
> > > > 
> > > > What would xas_reload() return if we raced with split and index pointed
> > > > to a tail page before the split?
> > > > 
> > > > Wouldn't it return the folio that was a head and check will pass?
> > > 
> > > It's not supposed to return the head in this case.  But, check the code:
> > > 
> > >         if (!node)
> > >                 return xa_head(xas->xa);
> > >         if (IS_ENABLED(CONFIG_XARRAY_MULTI)) {
> > >                 offset = (xas->xa_index >> node->shift) & XA_CHUNK_MASK;
> > >                 entry = xa_entry(xas->xa, node, offset);
> > >                 if (!xa_is_sibling(entry))
> > >                         return entry;
> > >                 offset = xa_to_sibling(entry);
> > >         }
> > >         return xa_entry(xas->xa, node, offset);
> > > 
> > > (obviously CONFIG_XARRAY_MULTI is enabled)
> > >
> > Yes we have this CONFIG enabled.
> > 
> > Also FWIW, happy to run some additional experiments or more debugging. We _can_
> > reproduce this, as a machine hits this about every day on a sample of ~128
> > machines. We also do get crashdumps so we can poke around there as needed.
> > 
> > I was going to deploy this patch onto a subset of machines, but reading through
> > this thread I'm a bit concerned if a retry doesn't actually fix the problem,
> > then we will just loop on this condition and hang.
> 
> I would be useful to know if the condition is persistent or if retry
> "fixes" the problem.

I was able to deploy my patch into a set of machines and test from March 11th
until now. So far it seems like this patch addresses this issue. While removing
the BUG_ON means that we will no longer see the call trace messages, I looked
for any lockups that would be related folio/filesystem activities and did not
find any.

Let me know what else would be useful here, I am happy to re-propose my patch
without the RFC, unless more verification/analysis is needed.

--chris

