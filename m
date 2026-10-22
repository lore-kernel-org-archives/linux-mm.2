Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EFAD606A320
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L9pS2y+j
Received: by kanga.kvack.org (Postfix)
	id 145EA6B02D9; Thu, 22 Oct 2026 10:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CF26B02DB; Thu, 22 Oct 2026 10:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033B86B02DF; Thu, 22 Oct 2026 10:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBC7B6B02D9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:23:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70C8D16014E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:23:56 +0000 (UTC)
X-FDA: 85350481272.21.EBFEF25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BFB1D40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:23:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9pS2y+j;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792679034;
	b=u5JRSeS+yw9GwuNB82Dg/NxpJdso53oNSaU6JtWcabOwfFwS1aZTfT6SWXQ0zLXfSX1Vau
	OGXf/t43S+tZelYJOrteaBR1uiM2sir99xpIArw011xY3ha3R4nUkD16yT/mowH4a04zoU
	4xlZA8p7EGdqaW3QeJV4cz6oIeoOgqE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9pS2y+j;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792679034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dIZsXz2SbVsKkEiL1g551QShsK3q3XWlF8skIiToku8=;
	b=tpaU22SSc0cWEuBzt+JudlTknBYN2oCMjbFA8I6ubCbt1x0HIaeAh0RzjTeBuXWmE3z3ZL
	QCW3rKrxbu2l/ldhknO/eLdMGiHIWpcPAX3sIe7TTjhrnr8oezA6QMNzR7i6CCaiGeIoa2
	4ejTVerVKHxeufew4ilJHYyNi7ZD6j4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9546401D0;
	Thu, 22 Oct 2026 14:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C7E1F000C1;
	Thu, 22 Oct 2026 14:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792679033;
	bh=dIZsXz2SbVsKkEiL1g551QShsK3q3XWlF8skIiToku8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L9pS2y+jsI0ppns07ZzBoky914S4ByJRvmHjmNVGAwMUGSDeQ0F7tj49DSSU8rkEK
	 JsHKgZluABjraGPaWiiCOog2+3d/6KCUjf3izwTQnUy1GMevKXpm1irQj8NVq1EdEC
	 UCj4lah7akanJMtD6Vknb6eGKwP+fgLAdPdYMnBOvOjTUm7x6cLsfhj9x5r8Fo+I3u
	 4JKDwZEYH2jIv10fYdpTKD0YP2lhGbT6LXbSt6p0WV7imYDvoKpCW6hrIrMhfo1n0Q
	 HNW1NZo9Em+beu57l7lGtLucrPpDOhX9QsBBzXdKtevTcISPRvHglPZFfLdFAGMjTr
	 kGkVs7o1468cg==
Date: Thu, 22 Oct 2026 15:23:51 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	LKML <linux-kernel@vger.kernel.org>, Imre Kaloz <kaloz@kernel.org>, 
	Karl Mehltretter <kmehltretter@gmail.com>, Kees Cook <kees@kernel.org>, 
	Longlong Xia <xialonglong@kylinos.cn>, Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [GIT PULL] slab updates for 7.4
Message-ID: <atob5qNd70YPJqJa@thinkstation>
References: <atoJsKNb5KiE44jl@thinkstation>
 <d5fe8a82-8195-4e18-94e8-2980e8c83674@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5fe8a82-8195-4e18-94e8-2980e8c83674@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BFB1D40002
X-Stat-Signature: btxn9d78pceruu5euxnqsayshhu78w39
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792679034-599390
X-HE-Meta: U2FsdGVkX19Q1x1uEPrE7GolCpY+FWiRxbrMMlQS2gtKMLA0F/AQdiHeEpFAKAEyQ4UoaNz4BHmT46WQxD/GWrgi7iQZ3gqFoBYpx+J7lHnR6M4swjlwS2+y1zrgWuLBldL7fhDNX78bNBJfTusg963k/igDk+6W9rwpTxaxWrfCm2Hz1ma4TEqp1KMwrio4OC0NcBXnXds6S4O2u+qi/zYXKgAq6qHC78TU2GOwGhiH2nfY0hTOUw/la13+5ubuleUoSWsgFZOklLIEtK+EPJix9Sto/qlmo3QFxNjj3tGdI65qYznYoVCWJ5gJpHQnKdcNHTT2FxtZ7amzP1ymiH8olTBmIeDnkec4qOsha2suyH/DdYBxSPGzdoi6YU3uOqeJ4Jq4D2OEMW/XTydQetfEetSUP8uXOEtiMXvatpwXUo2UWncH04yIeSR2p+HXwOyM5MekOQUC3ZAmvzRTEJdh6Z+9cB3e25Xa+4iftIxus/TYJGhk3pEMCJez93sbjioo6052PTO2foHFDv+WyuIi0wunQDHqr5ODrEOezVLgvHdk16+NhPuv8vDjezdT1lqnn34yyaq4N/fQ4dubUr7tarmiDM2bJQtFaf+tI8UCO86xZnUGQT/vhlZ3SQPLouW7dyXE+zDKZAryWxLp6Kv86O5N4O/HkA+nmiz32ZMYlwEmXP96cnnkawxMCdpMo5MIh8g1HNoIG4x3xSOPFVHr4obbwDkdG1QgsK0t3PUWUtgKk1+LM45WPJO0gwA5AsoqjplKHBRLiN5PSwbzEiCKp63Vg9G3rQobFJ2SspFt7y3sjPbkvpZD4fuYCGzudwNygkgHzBZ2dEfIkgaJnt8efRvK1xlLvAhCSho0964F4OGWyzU3pxUb3anOpEYvkzZvlmCXh2t94XUnC0+PHXKfjGT2Y3MpCr4yE6qj8mJUE5Q73zmxCX1QhfKlh8J7r2sf0m8XAaFz+Gjem2S
 rKu46HGr
 tIhZS1lFDC4TJRxhX2c/plfoudssJfJVEEcn9BXfKafdNdRuLLeocI6lNt6s+TZTNOGP01RjtjEV9SPDjlkxHvVLP2RodDrJPwxPZBEhmsGFeJ7ica2W4YMuLdeLyQAba/eloukY2I6SSXnEtSawmpQjCIUcQACiVUEWQ8nYBhfOoNLUHZgGU8yPML0IBYBCDYslfhXPM2qmtM09hJj+U6CoP0B1A5eg1Ikn2Xd/ATKtEUwtQHtsZ41TNoH521NFgU8B/gGNG0gSFHzV/eO1WtdVmiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 03:37:19PM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/22/26 15:10, Harry Yoo wrote:
> > Hi Linus,
> > 
> > please pull the latest slab updates from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.4
> > 
> > There are no known conflicts with other trees.
> 
> Thanks, Harry!

No problem ;)
You've been doing the hard work alone for years... now time to help.

> I felt I should endorse this as it's the first time Harry sends the PR as
> the co-maintainer and not myself.

Thank you for the endorsement, Vlastimil!

> I looked into cross-signing the tag but seems like git doesn't support that.

Yeah, apparently not a thing in git.
I see you signed the email instead! :)

> Vlastimil

-- 
Cheers,
Harry / Hyeonggon

