Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 502FF109C036
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B779A6B0005; Wed, 25 Mar 2026 12:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28346B0089; Wed, 25 Mar 2026 12:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D9D6B008A; Wed, 25 Mar 2026 12:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92D706B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:26:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 263AE160A0B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:26:21 +0000 (UTC)
X-FDA: 84585112962.19.C24D0D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7218912001B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:26:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQY8Glx3;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774455979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JbI4k1d0yYL+Cl5kXTP26QN+1RQBKOBdoCEWXgtPZP8=;
	b=rIstzK50HVfMDw65/g2oZj8S01Mf9ekJ5G08dstqiXQwoulugzadYzJwdZgygYTU84BIRF
	k7+tIls7Q1OfKDT3xDbZg4U6hyrJ+uDfa/hOjUaSh8LSjgX2etXmtxtoAoDYq3655pLknW
	AMTbafLxzjbFb+oHlfm3xXeuShKsuBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774455979; a=rsa-sha256;
	cv=none;
	b=ufRGnCFBZoxXFZcHPn+l1Q+tSOYDM+TAd1+zd0XiaOeh7l59q+dRoEiNVLaO5iJG7aI4Rj
	qWxzI+0gPWIv7obOBQh6VdusK2DMkdWSlvyPabdntvLqWOe6g3swi5u8xUig0g2V26VQPK
	Kwg6mgFEEPUkmV95a/WU+62YqST1ByY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PQY8Glx3;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8946F43ED7;
	Wed, 25 Mar 2026 16:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66847C4CEF7;
	Wed, 25 Mar 2026 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774455978;
	bh=A53eXc1wKqhkXLFR8RFAyruE51u9fpUJf8NFVVelxRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PQY8Glx3Ab/gAmdDUlBBYg+cdJxT4kK8rgIfGTW3p3uNWAesqThnHfTJC0puKQj9q
	 aeIS6EM2QHtjk12s6+SaYiWaBAUmbchesJgM+CXqDQm4qCf29LfeNQaF8Jj2TWH5NK
	 UFdwdInCCYaa18UHHazaqdkNSIFmHolUN2x/yx30n1IiKNPzTHau6RtV+qAPNiWkuV
	 xmPJfwlbIbop92oUUmnHna51LXQEvRtNps4uXuvvCkSgb7e9fhRLY1WmKQHOax5G+c
	 CySZHodmGv5zVdEbxzWUZ5Qk97PS1NvmBue0I/Z+VmLgHGPJD1nwhBLq3yEYfqEh4G
	 Jx7S/V/vOlrzw==
Date: Wed, 25 Mar 2026 16:26:12 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Vernon Yang <vernon2gm@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <06c83e1b-d7ee-48d5-a5c4-faad39db2f53@lucifer.local>
References: <1da56bbb-9211-42d7-9b08-3ee56d2b538d@kernel.org>
 <hbftflvdmnranprul4zkq3d2iymqm7ta2a7fwiphggsmt36gt7@bihvv5jg2ko5>
 <8a5277e0-d70e-4849-9763-ed90e350a118@kernel.org>
 <CACZaFFPfx=y5Fy+nwT8o8TA=W0QBfOvTqbJnhVPn8B95SFxijg@mail.gmail.com>
 <22dccc17-787c-448e-a571-23c7a9afeaff@lucifer.local>
 <20260325080930.a205fca9e7e61c4a793f5228@linux-foundation.org>
 <3cf94628-3c6a-43ed-9fc1-29bd5a911497@kernel.org>
 <8d2e809c-e4c8-4d35-a2ae-62777b6dfbcc@lucifer.local>
 <0437ad42-612e-461f-906d-6757eb19a8de@kernel.org>
 <20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325091735.bf440358cf83c5d0369e0674@linux-foundation.org>
X-Rspamd-Queue-Id: 7218912001B
X-Stat-Signature: arkq9xjm9gd7i3ayomjzxsypesmhziya
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774455979-542275
X-HE-Meta: U2FsdGVkX1+urUU9g6YnRPhi8+uLmtcDRoRrixOl0KFpnyeBiYLFeWZWr+qDOp4mrqcZW0QpnvPIvasZyjtEdhgX+rH0/NRpxhXMb+wjd5FY2XEVI2QJ79+YPjsHgJVkCco79agBr9ee1EhGlybiDrV1fQ31snac2zPzOzAij/PaLYb0zpAdpgI3PVvWyJAUoOPPHRJ7IVIa0hr6BqHNHxMfJeI1hm9MmNNK+jcDLxOgMAmcwCNMfiWyqRwQ2eHDflsJAp3rKZfcu0RvKnUE4yV1HRN0Vktd7UFPimKcN3Mtwyk6GGl0ZYBDNIWDVIImeA46/6Chl499tzCaf7wxdK2Tb885HILCM7SHVZWO1Ia5HhQKQ98OC30+BteR+5IYns/Av53hR3FBnK1SkMg6tDZFOCnaZCNKT26GFp3XcOpAfueqwvWo3XSt3Y+f3fonLqOZ3fE2roQ51hNVTJHjoUR5H90Uc/O+AASiElS9HaeSPjy3Lqd2TGrKRvS+ALRuxCNTD4gcCLJu6XKeSs3hSfdepvsBDWgPp7oyCSXmd/UL1qKHykBfhEWb60V4+sp4T3WmbewQJ/FGyDhoAbB/OaUKoIn5KEid4bCFImBieaNorWMBTuGRJwwDdjqEhnnXBnA6O2CW7/2iXUx2FkbOPOUZHMERjQ32LQ8GYl5W3q6a7p+fM1pbuPgYc3lUevN6So3Kh9g8nxVVy2bTCIYDosReA22G7iHNN7UJCub/pIGhQfY5WJbo8vC/HPd1RDmgWckssW9M21dgCCKUdVbA7Qdo98gUoGBuO4vnHXU0YTYvWg9jhMjvmAPWsdVrLQL7Wm0//CLT0gN9iCjbJrRJzMZf2hwANxNfFiwAXMnhd3N1LJJ1LAgqIiAUdfuoK3Jc6csjlUuT2JasuwquZAzQgCzvHPZe8lEYFy+1GjNplOKlDI8ysDYUHgm5d0nhZLqYg/XrrzPsAxBKBORjFcr
 +GpWjVnn
 XPSxwnSCgMuIzpr5tenTBDUdwjmDMpDSXBYma+UbbAvqHj3GaU85bUBZzG6VIL6cdjMQgnhh7rDcOSjNXVEW5jCnKPo9RBhTPifd0so6NKnnYBo9NJ0j03CmFpDkQjzqaZmzj9rE4pINEFsjboCieSgscbx2UZoMewuM09iBSZa1H3MfMrYeDRD36GcsVES1kR/VJeXRL+ryagWCOMBJotC//kpRw+sxRtpMdswB8tK+krA6ULJUsiQ1XAhEICBaP3XuthaSTC5AId8U1ayPTqYo9ioawcPJKvNxE3LwV6PLlE3+DHuCJHzK6FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 09:17:35AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 16:22:55 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>
> > >
> > > Really larger stuff should be resent I think, esp. if there's multiple
> > > fixes in the series.
> > >
> > > A reply with the same-patch-but-with-fix-applied would definitely be
> > > useful!
> >
> > Right, for completeness, this is what we had in an off-list thread:
> >
> > "
> > Not sure if that's a problem for others, but I got the feeling that this
> > escalated a bit lately.
> >
> > I know, that we prefer fixups to sort out smaller stuff. So far so good.
> > In the last time there were some series where I was seriously completely
> > lost which state of the patches would go upstream, or what I should even
> > review, because there were just fixups over fixups.
> >
> > Fixups are nice, but for someone reviewing a series, too many fixups
> > (either as inline patch or even worse, as independent patches) just
> > causes a mess.
> >
> > It also gives the impression of "this is mostly done, so don't waste
> > your time reviewing it anymore." --- "just the finishing touches" ---
> > "don't jump in late and cause trouble".
> > "
>
> hm OK, so what to do.  We're OK with teeny -fixes but anything more
> substantial we ask for a full resend and I do the heres-what-changed
> reply?
>

Yeah that works for me.

> I presently don't fold the -fixes until the very last moment.  Could do
> that much earlier if it helps anything?  Possibly useful to people who
> are looking at the series in the mm.git tree.

It'd generally be easier imo to have those changes folded, but with something
added to the commit message to indicate this so I can know whether or not that
was folded in.

Maybe just directly squash the commits?

Thanks, Lorenzo

