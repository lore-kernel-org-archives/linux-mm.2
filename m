Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07536FCC06C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB386B0089; Fri,  6 Mar 2026 15:11:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5655F6B008A; Fri,  6 Mar 2026 15:11:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467E06B008C; Fri,  6 Mar 2026 15:11:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 327246B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:11:29 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 077AF160690
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:11:29 +0000 (UTC)
X-FDA: 84516733098.03.4D2FC9B
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2691620007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:11:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Ntt1aO8h;
	spf=pass (imf13.hostedemail.com: domain of carges@cloudflare.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772827887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiOnenw1jcYxE+BclNNPW1TPwN0VcI9bkCDAzXXwTsc=;
	b=6yfjUDFtlLEjcaO2wDXej1pkoJ/eBmBjmFdbNrZP7BeSD/L0/cYGNtuYCQEdkABBNDBgO4
	uZ2VL76hJVq6plmAWZFPlQOk3vpoLsEjozov47n6ioUIHzmbNFLicw2AWLlHGLt7TPJlIJ
	5JB+5Q2ZjNjV7L3+D4dzKOjpXoHbAcQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=Ntt1aO8h;
	spf=pass (imf13.hostedemail.com: domain of carges@cloudflare.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=carges@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772827887; a=rsa-sha256;
	cv=none;
	b=C55BoWf4YXnzvbNFJDs2wmwc1/RupI7RCB/eDmXv/xhad7s3G1mY+73hIoGRtbqFh4LXQh
	lJE2bH04OzWSIR8GqJ37cdYYwgNiCSPSum6MOQrVrqxQU/eTr/vz1DAPqJMcBNcizTEx/2
	QMnnhuI2D6PaXm+rEB/k4IMCyt0EYY8=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d4c65d772cso8349129a34.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 12:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1772827886; x=1773432686; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FiOnenw1jcYxE+BclNNPW1TPwN0VcI9bkCDAzXXwTsc=;
        b=Ntt1aO8h8ITzYYyy0RKBjjzXhYxL/D934z76Xe3Z7tYaGn0iGOGF8vJ4LUTLJXYtLg
         1cNq6igxeFZzkX+O6jjcyLEdOrNmcrXhLCKyA2AVG6zX0eLKgclh0MdM0WQM1/O1YUcF
         x5FqcluHkkcn7TTW67gC3PrHLttMDphdeyKHRczLF+Pbt+WsG0Zp7GaaIvL9+zj099q8
         wPMVTxN6+TmSda/4jB59iMaQmb0EbhUlxwkRZ35VvpBGVIWJKnO0PCaP39UbBZCO+CCF
         jWWQvFzxq+jH86zfGjnLNdX05gatSJFIRH/VqTW8qEf3Y3UPOsM1na4YP4TJcWFF1Dvu
         DiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772827886; x=1773432686;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FiOnenw1jcYxE+BclNNPW1TPwN0VcI9bkCDAzXXwTsc=;
        b=ktCHqRAYwxLzJP0yHTXmfL+NyNkS3G6GvkwBSJ73vrRPTmdK1vMjMcvsnjrP2T7GLz
         Ixm24F7MRaLDvSHou3iiDQ8QU5vpPYAEhem/PUOi6hiA5IY47PUD/1VesPXHukHFmxS2
         iee/jqCak3uv8HCdKh/qoicWMH/BieLOtcH0iNQSzp0nOlg0rW8SKFpYaNEO/4xZdjJj
         LHkx+WSZyJ3+H1T0cnDIV+YQrbOzwD9WKGo7a62KSOMULjhV+nGHgXpr5ZOU/BAElqON
         CNPAllfwS0gmiWhUWuIb1LmxjvdSsHI0aXqUC73gkDs/Ty31wrD0Z/ExS0uZcGWXghYq
         tylw==
X-Forwarded-Encrypted: i=1; AJvYcCXG9otOHBKBsGQIIdSeY0mDVsx9ndjbNKcDyW3du+GZt95SvtudSwGSWGfH3C75jZ4Ez3euhGY/ag==@kvack.org
X-Gm-Message-State: AOJu0YxihMk34JnF9+w7RLbrgyphCriqqeO0vGX8Yg0cLCCbNiZMvraT
	PrrcKazVUUwA4Pv8JlFAO27XPoEBHv9yd2GOhgUH9T0WJ6SvYjJ4QDVvlTFtNUFTdxg=
X-Gm-Gg: ATEYQzyySKxjFWkbglRK/RbX8O1/1tpmlhW3NBliSg/0SF/oL39GDHHcFzfRjulIVP3
	40NXV4oh+dxdUU2n2+5LIvkdK/TP+F8/2OWMVA7zvNu2gNlCVPygAY3fDyt93+d/5kwWLFkWjEF
	hJ0AORmWYXgcktjUO6CGTvqvtZwAGPV3QGsS28LYan2qlDV/rlxhewzodGQPL4/m0cn6NIERXBq
	7OknU3hLI/cBF6AK1frA2exjf0fY0RulEtAdu92Jv4pcSecQTVy/mzZ5PG/aiOG+pnQTNgfNBpy
	1xEtVH0vjhfhlvNXOl7Ykd+uGJ3FZvmGK8SMf8CQAJ8hFfeGPKPkB5FfW6mKh2pjntm73YHmanY
	in2t53dl050rgLykr5kXUFhrnHQ4YmCrUodTlQ1sQwxswKn/qN8+qgh1wD5SfzAxk2BdM5ir4zy
	jwGb4UYqIdAIQ2rg6Y
X-Received: by 2002:a05:6830:8384:b0:7c7:5f79:40ca with SMTP id 46e09a7af769-7d726ff8ecdmr2318481a34.29.1772827885967;
        Fri, 06 Mar 2026 12:11:25 -0800 (PST)
Received: from 20HS2G4 ([2a09:bac1:76c0:540::3ce:23])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d728d2e9dcsm1552615a34.23.2026.03.06.12.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 12:11:24 -0800 (PST)
Date: Fri, 6 Mar 2026 14:11:22 -0600
From: Chris Arges <carges@cloudflare.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aas06mfCrJuzZd0-@20HS2G4>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aasAo8qRCV9XSuax@casper.infradead.org>
X-Stat-Signature: p81ghxjcua9cnzorbe7qd3ahu1zyptbj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2691620007
X-HE-Tag: 1772827886-234918
X-HE-Meta: U2FsdGVkX18+0D5tsFOZO0VivVBL4pcAAC+6bb4xrOXmLMKK67OyCZO9CNN6VdaWg/Dc56iKyzHaJIVgrV9PxM5unUOtqQWpAqymvhbVOWVIa8m7xCuZAQnKLav13P9vxb0GpfnKCjQsvq7CHT3w4opVxB7K/ApFnOqivnz3BInD+U39Vsr4mcZv/DUAAzkYg/+8wzZ3sAwmlAGhVLmjA8hr8QCUcaniyAgOKtlnGTykTV1669P6bE+Lr8vYd/F8Nv8UZVqgnb0dklhtCRvH88tonH9UVBXHgH1KvEF66vyTSo7yjavPMy4SBkUf7Ejw+2DrK51roiFCTWRH4IEVVEUnRTU2wAgx7eP91ZXkKWeHPah8rYJc/prJ7KAX8B6KRZn/84IB4S+ul/kNXLznGbX3mfmQwBIW53fo7vT6d34YeFKDenSz8VKylOdVdG0VZcef84zFH5too6b9KcmPVXlYGEGGKoAYvWkKBiEioI2LAEH9eiSCrgbfBUa9Gg7lYc63w5Dgh2I1n6KaBugA7DWMS6paAo85lKpSNCf0QEf8NUa6vfkrxjlR/ZbSQnTykP53YyWTuVhWwS3xtokCLW/AKn7qgXnh7+tlAs/yZPxhdbIy8ydetJfzY8kaoU8LEgjDm3fa08wPa5aEh3DDunMh9QHMW3bLrsRaxL7OqKwAPg4aS8u6OIl1uYJpSFqHoHt0gOPGLul9o/xjmqXDcCGqro1LH27Ozl46Cf3W29lPRco3kGTOY1FGG959UMrU3XalzeFWCo7Nt6Q53y7l+cIB7IHkCi3Jy2zum11d8qHphoioO1gHN7H0de3nxZItkhdYand6So23Wd4ySr0KXZBAH+Ep5LxjTkC8z7BCkYxiOS5fjV+E4+lx8F91DDVD8KokPHOmdMwHUspRU/TPZE4XX219UaxZU2rNUJ4AwBBQeGlgBknnvd2HKFaKjcEFjfyN2jp+P1BnaLbFX/1
 lMGmSMAi
 lNz+fEfwcdMWdwvnFLNoGoVfolWYldaqya9aJDM7pcY1Uje4WEAY97ZiLGpWHwexXi6ITkAYmlyDseNE8TVWFUzvx3r1SvXm9PiyvRT1uCRr7bsLfS3SHfJaqjoq79g9ybDnfJkuw6RBco6Ec790AFGO0hF+7727wirsED5pt6Tp21qjE+VUx2zGGa8IEscy38TRRte9h0o7e+DmF45IYLOASym6sfr4RJJEbgQX6cQyYsdTlgv1vnRdEttD0JukeDVoyI/GAQNCs8lPRKl5if4C6edA1Mcw6kddMamV/Tr8DeheN4Qwf7QfwhAcYvbALo1Eq/pzdP6qc+s0TE+rF6fkbndev1eTNBr0jrMggpQDswl6d6veuzEa4CPu+LLoy8VkM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-06 16:28:19, Matthew Wilcox wrote:
> On Fri, Mar 06, 2026 at 02:13:26PM +0000, Kiryl Shutsemau wrote:
> > On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> > > folio_split() needs to be sure that it's the only one holding a reference
> > > to the folio.  To that end, it calculates the expected refcount of the
> > > folio, and freezes it (sets the refcount to 0 if the refcount is the
> > > expected value).  Once filemap_get_entry() has incremented the refcount,
> > > freezing will fail.
> > > 
> > > But of course, we can race.  filemap_get_entry() can load a folio first,
> > > the entire folio_split can happen, then it calls folio_try_get() and
> > > succeeds, but it no longer covers the index we were looking for.  That's
> > > what the xas_reload() is trying to prevent -- if the index is for a
> > > folio which has changed, then the xas_reload() should come back with a
> > > different folio and we goto repeat.
> > > 
> > > So how did we get through this with a reference to the wrong folio?
> > 
> > What would xas_reload() return if we raced with split and index pointed
> > to a tail page before the split?
> > 
> > Wouldn't it return the folio that was a head and check will pass?
> 
> It's not supposed to return the head in this case.  But, check the code:
> 
>         if (!node)
>                 return xa_head(xas->xa);
>         if (IS_ENABLED(CONFIG_XARRAY_MULTI)) {
>                 offset = (xas->xa_index >> node->shift) & XA_CHUNK_MASK;
>                 entry = xa_entry(xas->xa, node, offset);
>                 if (!xa_is_sibling(entry))
>                         return entry;
>                 offset = xa_to_sibling(entry);
>         }
>         return xa_entry(xas->xa, node, offset);
> 
> (obviously CONFIG_XARRAY_MULTI is enabled)
>
Yes we have this CONFIG enabled.

Also FWIW, happy to run some additional experiments or more debugging. We _can_
reproduce this, as a machine hits this about every day on a sample of ~128
machines. We also do get crashdumps so we can poke around there as needed.

I was going to deploy this patch onto a subset of machines, but reading through
this thread I'm a bit concerned if a retry doesn't actually fix the problem,
then we will just loop on this condition and hang.

--chris

> !node is almost certainly not true -- that's only the case if there's a
> single entry at offset 0, and we're talking about a situation where we
> have a large folio.
> 
> I think we have two cases to consider; one where we've allocated a new
> node because we split an entry from order >=6 to order <6, and one where
> we just split an entry that stays at the same level in the tree.
> 
> So let's say we're looking up an entry at index 1499 and first we got
> a folio that is at index 1024 order 9.  So first, let's look at what
> happens if it's split into two order-8 folios.  We get a reference on the
> first one, then we calculate offset as ((1499 >> 6) & 63) which is 23.
> Unless folio splitting is buggy, the original folio is in slot 16 and
> has sibling entries in 17,18,19 and the new folio is in slot 20 and has
> sibling entries in 21,22,23.  So we should find a sibling entry in slot
> 23 that points to 20, then return the new folio in slot 20 which would
> mismatch the old folio that we got a refcount on.
> 
> Then let's consider what happens if we split the index at 1499 into an
> order-0 folio.  folio split allocated a new node and put it at offset 23
> (and populated the new node, but we don't need to be concerned with that
> here).  This time the lookup finds the new node and actually returns the
> node instead of a folio.  But that's OK, because we'ree just checking
> for pointer equality, and there's no way this node compares equal to
> any folio we found (not least because it has a low bit set to indicate
> this is a node and not a pointer).  So again the pointer equality check
> fails and we drop the speculative refcount we obtained and retry the loop.
> 
> Have I missed something?  Maybe a memory ordering problem?

