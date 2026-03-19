Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F65108E1F2
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF396B048A; Thu, 19 Mar 2026 07:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6D66B048C; Thu, 19 Mar 2026 07:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2138F6B048D; Thu, 19 Mar 2026 07:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 100976B048A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:45:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A94561A04DC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:45:05 +0000 (UTC)
X-FDA: 84562631370.06.7418B5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A0B5180009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:45:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rXoUS2Xw;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773920704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5e9XFCd5ImwXBWwomYkPmq94lsC3l3My7EwUDdyUXJc=;
	b=s4m3RU7JUqJqJeFTgxfuYzTSp/R9DgXkibYxjoCp0n8zJXc9B47jkS6eW/fpwAtA7B4Xjb
	8Cxp5MW/NgBxTixm2No4SEvbjvtRcAzGikkMPr+P5spVzNtyssuEXxpztvtqyrnOMGzpyE
	vk9FBC65OzY68mej2TD06l8KjG9YpYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rXoUS2Xw;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773920704; a=rsa-sha256;
	cv=none;
	b=8qxSUeaEHiSj51abwZccXlW8+QDqQ/mrdg+VKJ5BN55Qj03dVShjpt6b8K37BVkYiHt3Nr
	K30PuM0oRZ3iEUAHWzwKPZ31e6mPaqRAZNBk7VpfmEo0tTbvZqTiLsuwRhM2XirPKZW2KB
	y1d7zY6T+E3NA6nld4POkkvbEVkydX0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D262438C6;
	Thu, 19 Mar 2026 11:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683D1C2BCB1;
	Thu, 19 Mar 2026 11:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773920703;
	bh=5e9XFCd5ImwXBWwomYkPmq94lsC3l3My7EwUDdyUXJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rXoUS2Xw1yrPEOjf6RGyNIJLwNHJZ0/pT5DtANOSAXxXtMFwb9ZxbOHIOSSKBA1CF
	 hWuKVDoxn8rzrNcVydXHoWmidAgzrmfFTqUJ9+740yX7N3oO6gRLP7DDciDR6xMdC+
	 4zmxeKYab5rYVVZ0H+zruS6f1o1gYPkhpChZ3Ta7tDNQUkHa6SS8gYVQRJimRBgAXc
	 HLfPUs9z9+UqpUOVo7vEDh1+wDAGRakThnlweXOu5iKBM3FQthVaFLnVVi3xDNxoxx
	 GeLlFSFH79SBEUI5VIIiS7z4wtc9U7tz6eKBWnoaZWzmKMryKwwwz3EHf6xkpL51GB
	 S/MiJ+7R5Ay1A==
Date: Thu, 19 Mar 2026 11:45:00 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/7] mm: switch THP shrinker to list_lru
Message-ID: <da5e76db-4cb6-416c-9c35-34b2926a11c1@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <dc95cd21-8e7e-4903-b337-03f2a39e256e@lucifer.local>
 <absnshL4E4iXSC1y@cmpxchg.org>
 <06625acf-ee08-45ee-bdbf-5a3157df0468@lucifer.local>
 <502c7928-5d60-41e3-b93d-37244d4b2443@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502c7928-5d60-41e3-b93d-37244d4b2443@kernel.org>
X-Rspamd-Queue-Id: 0A0B5180009
X-Stat-Signature: rufbnja5yndx33jsoxjan4y5sko347w1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773920703-120784
X-HE-Meta: U2FsdGVkX18L97vdPJil23VRE9htUhdhQSkVj1soJ9572rCgKtxryipxnfnjV5h0IgQmMcHefagTW+dPH20jcbXxxSaCW14XaFbFdhOcFRQs8As25pi/IAReG/g4ySVFoNUhNMkmAnSW8SMUk4jzPy2kFNS7jar6HdgAl/yyMrcehmX0EaLZ2xvARTLIhzVXxO+0n/mbV7ATE/f07Q4ZoUPddBeMvdJEEEoZMZ2MkdnA8FncdbOunqHc/2v7+iOaWlYExukh2xMuNO2Q9oLU1lSwnuP+/tCk3zejhgSVEREjY5ru8t634eCuVnO+V2b3mSlLfcFHsP2jlyS3OZ7jxFwXJ5rgoyo/KAzXiTsjAd7wqHK2Yhf/RU2q2u8wueI0eeG+0YM4nmmBblRavN1Eqb/ta4O0taKhvpvM61pXcd+AaoiHIwNoabe6xMf2wKe70A/JhWp9U/Iex9hv1dp4f2Q8H59DN4eWqBmHMpZ59rCwp/slC+8YvVxvKTbbgVisfrxtgcdUQ3Oc1demBQ4idC0S1ZOlFXSIbXqtpKJOelcvZA5WAPnLBX+vpf0FnjGX7D/REKMreQ9NAFOVeHb/foMG33pl1bCe+zh81NZVVMN8B+vn9g7DDBmp25G1QUFcS4KGTtQ32SLXt0DvNpTMr6dCqGb6T/X1l8/5CHau3QaQTdp81fN341ftIMZDWcrfOteYgzQOGClGi7isimbItu7981Vw+NlFiA8oouQir8C5PShz7U04OlNBO3PtLqvbBt4M7cDHfE+Lcvcl+gASLLljNMiWtFGdfOzG0yUkgmI6DoPl05ljBJjUZ0I0z14zedc8i0s81HsbhRCg4eTNTVF/Cm+bG8jPzbb2J25LrgD4BPFWFAe5yCIPuAtbeYQNET6uPVVp0kIgTbKXPr6E/b5fq/Ihlns/Z8KeP5jzprfiZT14+8reljva7YKPHmDeGUG+M9mUdXRWTYdnu9F
 jYc8XIwC
 ifAXcr6jHxn9FbGLpWJbY3exzFlI9lqj7V+M0lEJ3cUciMQV9P40Wr+n6ZwOtfpLxFm5/psBAdxESMATYOBd/eKMJot+MtkFIINgnYcuR78WeZJK/mY+fhjEnno8Fb0R2kcFRLh+QXeIUONN+ohWqQTxGMiJAELvG3lRcttJ3tKQ/mo5TV7rsJTTPDkBXI5eaAp25tcMxIbqmM0E3pNWJK9EGeYMt4PRC8BqYh8k80JGwHMwU1xphn1nWX2DnZnIREs0l986+Qc+UrEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:52:14AM +0100, David Hildenbrand (Arm) wrote:
> > TL;DR - anyway, I think get_maintainer.pl --nogit (and trim anyone who
> > isn't listed as a maintainer or reviewer) is the right balance to take -
> > maintainers with screwed up email set ups (*cough* naming no names
> > beginning with L and ending with orenzo) and reviewers who have signed up
> > for lots of mail I think are totally fine to always send to.
>
> On some simplistic changes (e.g., simple function rename) I sometimes
> drop the Reviewers of subsystems because the simplistic changes are
> mostly just as information to maintainers that there might be conflicts.

Yeah makes sense!

>
> That helped in the past to reduce the CC lists on series that touch many
> archs / subsystems.

It'd be nice if get_maintainer.pl could have some functionality to make all this
easier. But that sounds like self-volunteering a bit too much :P *cough*

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

