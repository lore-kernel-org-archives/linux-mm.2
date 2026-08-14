Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 353DEC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 16:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8DBA6B06EC; Fri, 14 Aug 2026 12:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20556B06ED; Fri, 14 Aug 2026 12:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2DB46B06EE; Fri, 14 Aug 2026 12:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 991136B06EC
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:45:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E733120187
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:45:14 +0000 (UTC)
X-FDA: 85100450148.17.0189365
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 73B60160005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 16:45:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0hSnIgz;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786725912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJm0B5AioEhSF+ctzUWfmzPpAYDyCiCnhoBthc1Au8U=;
	b=Ya2Tb4BI/Qi/fC34M5lqapdG/+YCcuzGzF9cOGe8bIo4n6K9oHiSQ/+0MrKzA2GfqOOgG3
	z20V6eWHdb89/MZkOa2jOCH3F9sQaj2Fu9QyiJxZOMoUqncdgIsyxKe8LJu65R+8ovIL3w
	QWQGWiWKeCU4+/uWotfVZ6aasDa4k4E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0hSnIgz;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786725912;
	b=26eTK4wb2wmj5khAo9smbptThuyzaM4u2iNoXxPLHSziZSrnVGcKxjJECMTvMiPiW4GGC3
	APMOcj2mU1qiJGArBw6cvMueSpFpPrIU3zmrjJYnCBMUs9xuWTzGfNe2LSi1FTe+uZB/0O
	nW/5zOtOMcaERkLYQU4HZ+2/BfwuZ/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7908C600C3;
	Fri, 14 Aug 2026 16:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D9C1F000E9;
	Fri, 14 Aug 2026 16:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786725911;
	bh=CJm0B5AioEhSF+ctzUWfmzPpAYDyCiCnhoBthc1Au8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i0hSnIgzyNGPLsNxdfAq/LKMyj0vxSr/aSDp8Aynw4bPBv0slzfs3cOI4TB8FEw2I
	 LVHygeeFYB3SCQzTyph4FHL9udZKx3al49q8VH+IjlazbKVPC0+eX7wSQcR/MO42uJ
	 ejOB67hg91GXvjbqU0a51jw+Tuz7vkbMYNXHrZ1d+u1eBxdoJrYd1K8LtzC3CLRG/h
	 B3j2xC1l3MN3zDhnCFIlUC56bVsytFqwN1JvobJH/jwqEvtr7Ecp9s12Eh2Jf+OPTf
	 L9K13WCCvfsmVr5n+F1daxzZQ8wIvGY8xSIlCHgWUZtr5AakMltuqEjpENVLPV6y4T
	 fYlMpPPO4J/4A==
Date: Fri, 14 Aug 2026 17:44:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: fixing sashiko failure to apply (was Re: [PATCH v5 00/16]
 mm/rmap: index MAP_PRIVATE file-backed folios by anonymous pgoff)
Message-ID: <an9FhK3wSJHkEi3j@lucifer>
References: <an7ewWbMwN20xklN@lucifer>
 <F700B4F3-2068-4DFD-975A-6324DAAB384F@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F700B4F3-2068-4DFD-975A-6324DAAB384F@linux.dev>
X-Stat-Signature: dyc7xi3nec4g8hck97qppqcs37hoq6p4
X-Rspamd-Queue-Id: 73B60160005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786725912-359918
X-HE-Meta: U2FsdGVkX1+oHkx5jwAilxjfnJeJhTs1Je/YldZ1FTMjJQb8SUymyBLYeKl0UCjmnbAn3HLA8wzOqChDn5W8NUwBXmmMGxbcow6m6o3A0yvxwgGS8IRlWgHHOpDTti5yyVzPUPlMec0OzXfWkSK8L1ChjMB0wkuiJj1QZ5NCMkS6iDCX11rvKR0FKu15sJZBVuaZU9mAqHx49AfU4M6bTX9IpgQy9bXa6DzEYM2uJWyriHP1Z0l244EhEOuLn5qEg5ejcLFSqdUxTm21QRzCy9Stz4QxB7IfO3izpiOVpLExOxzFzOXUneOil0XZB92ZtSJlaJgDHdt7dNRdapIgYRww0dVKTJ/IQVRq53pls5bh2TvaTZ0lMcTgRnPQSSCLG0eOMQwZnN0YNjN15WjxyW8c7hToyVsc/QkcR4LgTO8086aVZNm7tZTu46GXtVunPXPg67/99TJQXZhWDZsimq4bk28jmQwRVvKKwmlPWcEfk/iTs3gYkJMBaRi8RvjogJYtQaPkaXCsVc+K/Ml2EFYm4GZPPJBFwx3SXPbz5HsSssGJKtMSzLGzUSMJgDch+v4GsimspbVlVqtIPu+25W6BCMWE4Wv+Gby+taHW40xUMOH8pOfggqxSQiOnZESWT6bWdFfmMb02ZkSKvOTaG5hVBJydcMNFChngBZ0mx5PxPoqCmOlslhZRP869p5aOnenfz32g3LJxtjZpTlfjhkf2yoL6rohWafZAjpolhUQudnKCN2gkZZiQWRcdw+daZz4/fQZM4PC+6BUrNxOC/RXWzMJu7EbHZEjuNl5K0HvjtbpS0cNE6JpTvDheDLuQ1E834X+zZvPmdbzQ3SqHZdPLKTn0I5wH4eGXAhi/TRe44E7m7alJf65gJVQNis3WJ40B7LfCN6s+629/ldo8QVWHL92JQVNLgFIuWEEviT0dVyLxUlGBMwGQNQCy3qhCOsurrIeROrW/Jm5Rr2x
 gpzbNQ+V
 PE0l6Z54cX/7YUmXa69DXvggthBGLHXrZN0ZYPcM4WNYo98IwXVOU+FZO9O4KydFRig79RiNLGB/z3EExJ4Wqg9PkEU+he6pi4jiIauC5ez56HMp85BtVVkdovmACeGQG9u1k47cz/QDzqjF4SyoqEI8nG9mZB+QXtSnjzZDT41wMkmybIg1eYvooG1+k8Ytjpcu0rMnlPlhetA6WEDzP/E1zGGqH5unKJh1CGY3Lc4lC83zSpM5VO+3cfjjf1gdQ21U83VTqbULldFMZ0G9bAikv5nz8fQoWig2CS6lWM/dSuDHo3Tw5fZzgLnCafur7Cn+r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 03:53:36PM +0200, Roman Gushchin wrote:
> >> On Fri, Aug 14, 2026 at 02:13:51AM -0700, Matthew Brost wrote:
> >>> On Fri, Aug 14, 2026 at 10:01:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> >>> On Thu, Aug 13, 2026 at 11:53:46AM -0700, Andrew Morton wrote:
> >>>> You'll be mortified to hear that Sashiko wasn't able to find anything
> >>>> to which to apply this.
> >>>
> >>> :))
> >>>
> >>> Well, when it's right it's useful, when it's wrong or suggesting unrelated
> >>> what-nots it's less useful :>)
> >>>
> >>
> >> Questioning your assumptions is useful, even when they turn out to be wrong.
> >> Show more lines
> >>
> >>> I do locally put things through claude + Chris Mason's prompts a lot, I
> >>> don't always invoke local sashiko as it's very slow and token-heavy or has
> >>> been so far, but am planning to do that more also in future.
> >>>
> >>
> >> Yes, it's kind of odd that Sashiko burns more tokens than a full day of
> >> breakfast, lunch, and dinner service. Running Sashiko is a bottleneck in
> >> my workflow, so I'll defer to others on this list.
> >
> > Yup, not sure if there are recommended configs for something saner :)
> >
> > Maybe Roman has some advice on that?
>
> Sorry, no magic way to save tokens without hurting the quality. But I am curious what are your numbers?
> Can be model-dependent too. In prod on average it burns 3-4M tokens per patch with Gemini 3.1 Pro,
> but maybe mm patches are more complex than average, Idk.
>
> One option is to run only some discovery stages (—stages), but this unlikely will save you that much.
> I’d say use a cheaper and faster model for the development, but it has it’s downsides too.
>
> If you have an example of a patch(set) which is particularly token-hungry, I can take a look.

Oh well damn, no 3-4M per patch sounds about right actually. I guess that just
is what it is then!

> >
> >>
> >>>>
> >>>> Sashiko can be guided with a base-commit: tag but I'm not sure how to
> >>>> tell it what tree/branch to try, or even if that's necessary.  Perhaps
> >>>> someone can figure this out sometime.
> >>>
> >>> b4 gives a base commit, but I think because the trees are rebased it ends
> >>> up being the incorrect one.
> >>>
> >>> Not sure what the solution is!
> >>>
> >>
> >> We have seen this on the Xe list (our list is based on drm-tip),
> >> typically with cross-subsystem patches. Some cross-subsystem patches
> >> apply and run correctly, while others do not but public CI flows run
> >> based on drm-tip. I do not have a bisect or a clear understanding of
> >> what works and what doesn't, but I think it would be very useful if the
> >> community could better understand the root cause.
> >
> > As Mike said, mm-unstable/mm-new is heavily rebased and also carries the old
> > version of the series before the new one is applied, so it's super unclear what
> > the base commit should be there.
> >
> > But in general, I wonder if it's possible that we could tell sashiko
> > after-the-fact what base commit to look at once the series is in, or re-trigger
> > it somehow once it's in-tree?
> >
> > Roman - any suggestions on what we could do to help sashiko find things?
> >
> > (Once mm-next is in place everything with change again, but can address that
> > then :)
>
> I can implement any reasonable logic here, the problem is that my understanding is
> the current mm process is a bit vague here. Which likely will be also an issue for the mm ci.
> I’ll merge a support for b4-like dependencies specification soon.

Yeah I suspect things might be tricky with mm given the rebases honestly.

>
> Re re-starting with manual selection it’s on my todo list, but maybe a bit lfurther away, as it requires
> an authorization, etc.

Yeah that's the fly in the ointment I guess for many things like giving instant
feedback on accuracy, well you want to make sure the person giving it is who you
think they are :)

Probably an email -> author with magic link or something but thinking through
how to avoid abuse/spam/rate limiting everything etc. is surely all a pain :)

Good to hear it's the TODO list though!

>
> Thanks

--
Cheers, Lorenzo

