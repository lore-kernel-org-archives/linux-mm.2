Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB317C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 09:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F446B02F9; Fri, 14 Aug 2026 05:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7F86B02FB; Fri, 14 Aug 2026 05:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E8E6B02FC; Fri, 14 Aug 2026 05:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 812356B02F9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:30:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16CB71C1575
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:30:02 +0000 (UTC)
X-FDA: 85099353444.14.BC8F088
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 79D3640008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:30:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnMCXQUy;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786699800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pR+WbG5AZxnbq3/8UA85wA3JdOFTvne7kZZjVo/Xlg0=;
	b=T9VT92hay0FsLB+Eqiju0vyxEi/ndg2NNFVJ+FsMLuASGJr3aNjqvt0+FpSFYU61mUJG/n
	BJFm3P5ewbxQcg3RZyJsdyba8VO8jRxvuigVRUXVG9Ty1jdhYamDYWVB9VRRMjg+xtxsxM
	VW7YdRG5/qBkQybjl/m34tNtFGEqEOU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bnMCXQUy;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786699800;
	b=OtCJQ5DJeMQ89QCb+dlwLFtTPMiIBKtT+xhDVCfkm6VJdt1LvMb1jdqObI1wXbDqm20b2K
	3gMQF8JfXY+PY5Mu2gz37q2OKUgp9dlnWIy7RWzL+5Vd6WCP0CRLiU4QGuCGHY6WhBt3SJ
	zY8VwbM9WgiuBtBUoot01DF56oMh3TU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC19D60A77;
	Fri, 14 Aug 2026 09:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B93B1F000E9;
	Fri, 14 Aug 2026 09:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786699799;
	bh=pR+WbG5AZxnbq3/8UA85wA3JdOFTvne7kZZjVo/Xlg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bnMCXQUylHNat1G2X/LJDp7I9cE2lm1aNs8Yo8h6MZOcjOaQTRYaohoOipPc8YLzp
	 Y7JbwJ3e+V6j9xRMZNj3bdF+5fJFIwICK7FkX2QvoLw7WyK+HytseJ+i0LDL/BT22y
	 YsMdiJPywOZ5KuNyvJ5uS6jk97Qt8DJWBdk3vCMQyauHEpmauMEDWpcgW6H/DPxbmz
	 6aJTMbguYtX1vm0j2jnoVF6WD+DSFu1qLphQj9YchEwUMYSNOToaIoJ8qBchj8k3xC
	 Fzp65OdRIcW/EYDvOGUzPPJbgQuZYiQ2NMeV8cZtkUcRIa7vxzqPhKEkNF/UwGN+V8
	 cIMrocxDL0rqw==
Date: Fri, 14 Aug 2026 10:29:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: fixing sashiko failure to apply (was Re: [PATCH v5 00/16] mm/rmap:
 index MAP_PRIVATE file-backed folios by anonymous pgoff)
Message-ID: <an7ewWbMwN20xklN@lucifer>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
 <20260813115346.2aaad419a351341a4f5f3ae0@linux-foundation.org>
 <an7SkamROquJ7If0@lucifer>
 <an7cT4KomGatNOB0@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an7cT4KomGatNOB0@gsse-cloud1.jf.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 79D3640008
X-Stat-Signature: uit6j3ay4qwbqttndb69wiptqjdwun6w
X-Rspam-User: 
X-HE-Tag: 1786699800-996785
X-HE-Meta: U2FsdGVkX1+DaHK9XL4LsFhFqrwQ86LROArTi2KqvKEP3LzWFjOJQzFO9dd0cFsGKr4HeTnWxrcs8pAnq8Ed9tuc30KNK2aZunFQ3iepIZuHdmETUGbMUjVuliak982spKh8imsCn24FgLWzyKTlaU8ut8Fx9V1QTe1QXkeivTeizUliqBnNQub/rx7bouCW8+piifl6ItqDFFOcJoT4aWeDtuJHmZBpPeshsJQjjFSKg9G2aSqc9Rz7HrlyvtiZzPKZnTIemjESofhKDePhmSt3STjWvDPCjqL3P8g18FbwVgM/wBe/b1FtUT+XVbX9HAD1n20X6UV6ptRAqi3rXKGg7+sRkn5ll424u3UhDopNshmye7kPR4TmbhweOZSf+RV8fpoB24kKTv7lQkS/1ZW9uJ1MGMx5lqbjNEtU2hIvxcZ7EqXczXbg/lZ+ZWiIDahtMk8UAsZB2FFjsh+KhaoN/555pfjJyO6cdXI0DOx2ZSJU/lv7/erUUGUWfroNQJeDoHKsMYEsj9bkZryjc5ADOZnroBBZZLDyFBCgVM2xLMBNBIFodzB/IliqLuBzZC83oRl7rfiWsR2qIhSgIU9LjTR3dSjlM//Lya6P0lI4Mbhva1BXIeDwV21g1dV1zt9qWLiEAEBhEsHGrkHSeWFLr0TXZkDYRUpxaNcy5DWxZRptRxAmiOcWA093eW0ShuFkImKvkSCDux3YVrifYKLFMwT1IfhTploDD+/vgqIFTvtPWiBdHhiBkvkMjFyyWy4GGpHPB4Ki5pJU/fcVOT/UPmKLNSnXLMcR5ZMRQke80kX4/b6V3kIVilh9zTvN0ZO13Ttzvx9OWwBbxA16FpsA3RyiN/Jmdem24Ij2f1kvBJOmlAQvNbcele+UIrA+i0kLVoqb/fDA8rtYVMibYMkiZcWg9UEbeLgDAuXw11TvPakiX9k6sZHv7VNw7lvbdjsohqswSXHJDxmWlVd
 ybcTrte9
 7eETCSoY5b4yo5TRpPpB/Cp5U71N/kC8d7CydWFvRghV+HTNRo+mx4c+iMmlEavSjBHHRXn9fMJh59R7ARZSrj7zjUAxqUtBnNA93mc13/azeAajqYUYzsjVy/Un3yQkwpJa0t4yvJ6Y7G0P7DyHkRo0wx72nQNE8SSN4NVPwXmzB//gJMBk2jPwMx9DdDTKbHDQjSUKGQ+h74bxHd36RC0vLc2NlciKP88TQINrs1gKyMyblw3K8tQDMpcxhmzLGccBm4F4XQnwbNMepmcLimivJ/0yeITFQrODY2ttJIkehvPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ trim cc list ]

+cc Roman

On Fri, Aug 14, 2026 at 02:13:51AM -0700, Matthew Brost wrote:
> On Fri, Aug 14, 2026 at 10:01:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 13, 2026 at 11:53:46AM -0700, Andrew Morton wrote:
> > > You'll be mortified to hear that Sashiko wasn't able to find anything
> > > to which to apply this.
> >
> > :))
> >
> > Well, when it's right it's useful, when it's wrong or suggesting unrelated
> > what-nots it's less useful :>)
> >
>
> Questioning your assumptions is useful, even when they turn out to be wrong.
> Show more lines
>
> > I do locally put things through claude + Chris Mason's prompts a lot, I
> > don't always invoke local sashiko as it's very slow and token-heavy or has
> > been so far, but am planning to do that more also in future.
> >
>
> Yes, it's kind of odd that Sashiko burns more tokens than a full day of
> breakfast, lunch, and dinner service. Running Sashiko is a bottleneck in
> my workflow, so I'll defer to others on this list.

Yup, not sure if there are recommended configs for something saner :)

Maybe Roman has some advice on that?

>
> > >
> > > Sashiko can be guided with a base-commit: tag but I'm not sure how to
> > > tell it what tree/branch to try, or even if that's necessary.  Perhaps
> > > someone can figure this out sometime.
> >
> > b4 gives a base commit, but I think because the trees are rebased it ends
> > up being the incorrect one.
> >
> > Not sure what the solution is!
> >
>
> We have seen this on the Xe list (our list is based on drm-tip),
> typically with cross-subsystem patches. Some cross-subsystem patches
> apply and run correctly, while others do not but public CI flows run
> based on drm-tip. I do not have a bisect or a clear understanding of
> what works and what doesn't, but I think it would be very useful if the
> community could better understand the root cause.

As Mike said, mm-unstable/mm-new is heavily rebased and also carries the old
version of the series before the new one is applied, so it's super unclear what
the base commit should be there.

But in general, I wonder if it's possible that we could tell sashiko
after-the-fact what base commit to look at once the series is in, or re-trigger
it somehow once it's in-tree?

Roman - any suggestions on what we could do to help sashiko find things?

(Once mm-next is in place everything with change again, but can address that
then :)

>
> Matt
>

--
Cheers, Lorenzo

