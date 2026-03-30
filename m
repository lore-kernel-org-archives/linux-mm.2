Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1709DFB3D15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C1B6B0099; Mon, 30 Mar 2026 07:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC886B009B; Mon, 30 Mar 2026 07:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBD66B009D; Mon, 30 Mar 2026 07:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2148E6B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:02:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB0F1160730
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:02:38 +0000 (UTC)
X-FDA: 84602441196.01.68AF9F6
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf13.hostedemail.com (Postfix) with ESMTP id B869C20018
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:02:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="B /8uwKI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=GW7cqoMA;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774868557; a=rsa-sha256;
	cv=none;
	b=6uvDIT3zgEBWU1lYOx1LuJPFZZLdrpZfrkvh/s8UskY80Qb26Z8Xj74ef6uYns0q4/4BmD
	LmeFaHBwk0JRGXJVKlc1A4m8wTjuFKOceMB7rp+2Kn0r3xvwQ178zr8OMaL8i8xhQyfz4i
	AcHO5WMCLcfwB+LP3h4bMVo6KrvfgDY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774868557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/67MWgGUdmljuD5f6QhqYFY+e0sYT43Y1m/UXREOxU=;
	b=auDSQZsz3WILKEDyb7Sv+54rm9Rp/YFXZcdhiYomffF5tYsbOq66iEK9UeNbahlq7sGOX6
	IAb8AxEPizN86Yp/+XMxSNXCHYaFdM19glKEjTcdpXAHheB7s2HZVZ8gb3ZV8q2kyiw43h
	phhl3ZwGad0Qomn0sUqDfA2F24r1Ghw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="B /8uwKI";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=GW7cqoMA;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5A1057A0373;
	Mon, 30 Mar 2026 07:02:35 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 30 Mar 2026 07:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1774868555; x=
	1774954955; bh=g/67MWgGUdmljuD5f6QhqYFY+e0sYT43Y1m/UXREOxU=; b=B
	/8uwKIFVNngeNbOXk+XF89ixBFS+d4ZMeiPtTs226X1iogvmPMpKxQJnlfQy0CW9
	E+GjAPbjpOVc24bRdldwDe0rgudDErEQ+JSfX9p8OkUEPw0fDv9ZdnOh9U2XWn2L
	9jHxyaJ8UosG4nnVJleUOIpA5aPpMvCN8vIp18gXVfstGW2k6MihmUxqPK/z9pvK
	pvTOhd6DO0rOkH2TCKB3J1mZVDI/qFjAnMD64QKxXQD02kggrWOTyHMXLutCOXcy
	DDR9nu9eHcC0gN67PJvcoKhgyeg2dCLds/4xlXGCckQihkgP4fqjmtVB4liDoaF4
	CavXSmlQ+EX5fOH9MHYQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1774868555; x=1774954955; bh=g/67MWgGUdmljuD5f6QhqYFY+e0sYT43Y1m
	/UXREOxU=; b=GW7cqoMAoAOvE8FIV5i068p6BVR65CPHidEdAr6Brfl+F0p7Lbo
	fAlTFdxqhqAy+OGfSzPXdlIlwXlmDZROaJZNdVSB/X3X0vHr3qmZozRBe6yJZ7xv
	JEMXQYN6fT3UG/HHojFNlVlAUEUIV0RtW4bIPxkpFvvOGrayCCMMtxwH2vb9Dmjp
	gtjw8M/BZDF6rCfRzFUS/UQqD44BhaqMuBKiV9fkZuBfaIl+OGcHeNqKCacEPb+r
	o01bsBSf7FPj3oHOjrM9a8M47Gca5nNAEREkqPb4H5Mx/qXseYwv+oMlI+DRP+Nf
	ddJsbQBYUqvFlCxVqHf1skQf38YqQFE+aPA==
X-ME-Sender: <xms:SljKaXqkn5lN0T-bEP-BiyPpjZkC_-6v1Ov47hPcjrkWZT3pWWMPxQ>
    <xme:SljKaQLivCKu2H3oTp8j8I6B7BfH1CEo_b7xecEhoTA5AAv2pzVqH5vJsUQYISwOq
    Yf1-Iv-lCtjzrP08h9J89KYPXkKbHtsPt33jXd8-XtjuGDL-zrPEQ>
X-ME-Received: <xmr:SljKabAiTgk7BSKaiZ8MxV7gPzLl3lT0un_TSG0UqD6cxGfpZfyX5G4UTO2NzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeekkeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptggrrhhgvghssegtlhhouhgufh
    hlrghrvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopeifihhllhhirghmrdhkuhgthhgrrhhskhhisehorhgrtghlvgdrtghomhdp
    rhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epkhgvrhhnvghlqdhtvggrmhestghlohhuughflhgrrhgvrdgtohhm
X-ME-Proxy: <xmx:SljKaa4wFZV91l0PWEXN7tbF_OlkNNk_iFQqnmbX-F_jJs2L0UBZig>
    <xmx:SljKafFLKRjRD5o-5Ps6-VkKMA5Jk8qiCSFPx5f4GtdC2btsDo8FRA>
    <xmx:SljKadRZNKCeqSUbAQM9O81Z86DFmb_8Gb3RgmwlaQMMf7wLuiFgtQ>
    <xmx:SljKaRe9G8Wos7j3YSupnHQH9M0zLZtLFenj_3n_FjPBdpRj2u3BCQ>
    <xmx:S1jKaVIq5Sqk1U1NujGtHNPT7s8ys_eaRUqGBxgg9VZJ-DWvv6ye0_aw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Mar 2026 07:02:33 -0400 (EDT)
Date: Mon, 30 Mar 2026 11:02:31 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Chris Arges <carges@cloudflare.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <acpX8iUEjNT6Kz25@thinkstation>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
 <aas06mfCrJuzZd0-@20HS2G4>
 <aas3E9P0BP03O8ma@thinkstation>
 <acFr4JJgaXsD9gtQ@20HS2G4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acFr4JJgaXsD9gtQ@20HS2G4>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B869C20018
X-Stat-Signature: euhytyiz4t17n3daetje8nhtrxw7ziy6
X-HE-Tag: 1774868556-575544
X-HE-Meta: U2FsdGVkX18lf0peI6kV2JLyDuoH7XfJfnBj96MUxR4Hsp95isHDYGLERLFI3MfyFEf3KCSXXmsf7sZhxOtA/HYIUmJVCwFLWGlU2hUS2kGKHJyQzHFEFyiUo5VhXM5odmKRl7+TG1b7D/H+vDM1iMb+8vI/avuBwcxBNLj/dICko+vNDBahIxo5uDye36rQusmpthFFmbRKoz5KBXnXh0hAoy7PJo+iWee5cQoLiM1Sc/AYDZ4IVVGySNjIc9ydoXjE4kAcw1WI9s3lxMCft1Ba6y5sn1ohCAzt9HBBiVGOl5qAzEyaSd4KApTrK5vytRt0Jwte0pYha4YofIOsQyPPj1MsRIbQ9Ut9qS7EJBSjQ7e/sc4zGMjjP6ZMqkLsBTZIjaHI5CKuHbC9q2Ci8AhWJAb8AIrnOsorpaC1OeJ7a8wJBeTUb+CDbTeY9/vGh001SLYGbGcOQFm3U9h/KHwncYRLQ05iTfssUDvD6ZUQlUcKyETmXHxerUZ6HYYBwbxeo5I594tmmPiXaZPI7MfOnXZH1Wj8bqCTvSU2tJdqdcQNirmS62YNED1v3gTpfOKYemUu53LurcYzAclYa8lUTouvk+2HNNNA9jqY/KVP+sP0+42/5P9Fe8OOhhLryETrHdBZaKaQbtAcgfhJNBO39SngFgKRu5tYs/k5wQWr2lKqKWyfDq5IdXJb7u/C4pMFnTAuxut/NTGQevSQS4VoHjZP7XXhlb6E4hcXVHWkQaYYMmU+StkoWITHeZmUjib97u3CDAcA3MMQMc7ScxQNLeFQ3lUC75Dp3ukKSwzbWnotXzd3WzAQC1YQIK0ft3kMZ7dQ1sNek0IcJnMFnKd3s6Ilix5PuXk/ENwcOeD/jJCwFnfbV/XmbVCrLOHBIkHSGsXo/FmIP0F6Tlosgp/8hhHYYKSGuizkyX/bU8h0H79rX8qRNsSxVJbA8xO10jtpcoVQAxUuGoFDaTm
 wCukhiS/
 AH1q0YmyT5QtkUXt0vHYRPM6AMX92XsVj27C+HIH7ic0gLdk+S13S1jha0WnoJu19UISzPtu2jWn00z6TkkHvvTLi4m9JOdWlJj9yDOiUCnLWJGE7a9qURvqeu9EyoJXCIGq9fbR/Xl6RkfKL6bvqaiyEAo4Yp6KKEx4mcY5aQdL6gHaadyCI+Iz/wooKv6HPf+ID8cnYUnsiUD/0MrBpCdY5outQFwN4m3s4VbmodnkGFbPTV42oRvuTbZUEVRWeQrMyCQZe6SbPvS4qFtjuTUvEQq/XXdlL03M5MDUGs285sYttFDH6LsKbnpdDW0R8Rggn2r2aTNsLBPwEcaDtCW6VVDbTq85wiVKugSBWDfnUBqIw6XDZr0TjjXAjWmbopDBN/bStayrMhGbT/eHnzzieIsRlwoDe2EkN0zomgHS9UOGUXJDIGtgDpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 11:35:44AM -0500, Chris Arges wrote:
> On 2026-03-06 20:21:59, Kiryl Shutsemau wrote:
> > On Fri, Mar 06, 2026 at 02:11:22PM -0600, Chris Arges wrote:
> > > On 2026-03-06 16:28:19, Matthew Wilcox wrote:
> > > > On Fri, Mar 06, 2026 at 02:13:26PM +0000, Kiryl Shutsemau wrote:
> > > > > On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> > > > > > folio_split() needs to be sure that it's the only one holding a reference
> > > > > > to the folio.  To that end, it calculates the expected refcount of the
> > > > > > folio, and freezes it (sets the refcount to 0 if the refcount is the
> > > > > > expected value).  Once filemap_get_entry() has incremented the refcount,
> > > > > > freezing will fail.
> > > > > > 
> > > > > > But of course, we can race.  filemap_get_entry() can load a folio first,
> > > > > > the entire folio_split can happen, then it calls folio_try_get() and
> > > > > > succeeds, but it no longer covers the index we were looking for.  That's
> > > > > > what the xas_reload() is trying to prevent -- if the index is for a
> > > > > > folio which has changed, then the xas_reload() should come back with a
> > > > > > different folio and we goto repeat.
> > > > > > 
> > > > > > So how did we get through this with a reference to the wrong folio?
> > > > > 
> > > > > What would xas_reload() return if we raced with split and index pointed
> > > > > to a tail page before the split?
> > > > > 
> > > > > Wouldn't it return the folio that was a head and check will pass?
> > > > 
> > > > It's not supposed to return the head in this case.  But, check the code:
> > > > 
> > > >         if (!node)
> > > >                 return xa_head(xas->xa);
> > > >         if (IS_ENABLED(CONFIG_XARRAY_MULTI)) {
> > > >                 offset = (xas->xa_index >> node->shift) & XA_CHUNK_MASK;
> > > >                 entry = xa_entry(xas->xa, node, offset);
> > > >                 if (!xa_is_sibling(entry))
> > > >                         return entry;
> > > >                 offset = xa_to_sibling(entry);
> > > >         }
> > > >         return xa_entry(xas->xa, node, offset);
> > > > 
> > > > (obviously CONFIG_XARRAY_MULTI is enabled)
> > > >
> > > Yes we have this CONFIG enabled.
> > > 
> > > Also FWIW, happy to run some additional experiments or more debugging. We _can_
> > > reproduce this, as a machine hits this about every day on a sample of ~128
> > > machines. We also do get crashdumps so we can poke around there as needed.
> > > 
> > > I was going to deploy this patch onto a subset of machines, but reading through
> > > this thread I'm a bit concerned if a retry doesn't actually fix the problem,
> > > then we will just loop on this condition and hang.
> > 
> > I would be useful to know if the condition is persistent or if retry
> > "fixes" the problem.
> 
> I was able to deploy my patch into a set of machines and test from March 11th
> until now. So far it seems like this patch addresses this issue. While removing
> the BUG_ON means that we will no longer see the call trace messages, I looked
> for any lockups that would be related folio/filesystem activities and did not
> find any.
> 
> Let me know what else would be useful here, I am happy to re-propose my patch
> without the RFC, unless more verification/analysis is needed.

I wounder if 577a1f495fd7 ("mm/huge_memory: fix a folio_split() race
condition with folio_try_get()") is relevant here.

Do you have it applied on the tree where the problem triggers?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

