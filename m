Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B005CCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF746B03AC; Tue,  2 Jun 2026 06:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B969F6B03AE; Tue,  2 Jun 2026 06:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3B36B03B0; Tue,  2 Jun 2026 06:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E52C6B03AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:07:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02B0C1A082D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:07:21 +0000 (UTC)
X-FDA: 84834545124.06.B75F16A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6635780017
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:07:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIyTRGcy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780394840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvrEZ1Qm2WHazRtzBNjRpgbPwHmCJyBaEkTLJd2RyNk=;
	b=WwXQGUhM0rIO5m7wZXG7toLVPZCMc8EATsaAby+I08Rbyi37rokWgHhU7FtIir8kNi7q4/
	dXuapm9ny2yAq/YU9NPa8trZJn2aK840yBQ5g+QlWUtb4BtDS3sWlXhnBec/GONhYeoh3q
	R/K23ZYijJ5WcRW017g8gKgNFCzR2pc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CIyTRGcy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780394840;
	b=2PKJCazsT3zwIvJx6u/RD4NFDLiv7NoHzlZfgZoy9NFBtanvTVZy+5gHiIABRgMH8SDX/7
	tgat4DVBko3tpFBKwerIbeGGq3WdWqIZ9Om1jHy5JYgG6Kz/k5n/eexYUZVQcT5XhhUPqJ
	ZihoXEj88CG+GA/9R/sN/zckmNxjg+A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82F1E4082E;
	Tue,  2 Jun 2026 10:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9D61F00893;
	Tue,  2 Jun 2026 10:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780394839;
	bh=LvrEZ1Qm2WHazRtzBNjRpgbPwHmCJyBaEkTLJd2RyNk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CIyTRGcyakzpJQ8a1U1Cwq8KCq/OgooEP9IRvPAnkF40u4bL9OK3S8KuxPkJc1no1
	 A7IEdSBBTak6WEjQTFOYo6q6N0v7ySUSbCu/3WK/7+ur4BaJRbkT2+yPgrfdU6vhCL
	 sUrbrmikRM/sbhk/mKVpEA3SZHSLov4e6urc/cjBB5G2tTzhAir6LxKRpOTVMerqk/
	 LQMDf5HQkFBCRbCj6L1rcYKTm4rWXbQBzzpkNYL25u3ZIfC5BTYwqPk8M4Htux3q4f
	 +UtbG3xuJiTYNsIdmSM0urePQhSgNR07EzTK2/0sw14vGJ8wVsjkQsYj1KD2lGsC1V
	 Q566RBjJ35s9A==
Date: Tue, 2 Jun 2026 11:07:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] mm/vma: eliminate mmap_action->error_hook,
 introduce error_filter
Message-ID: <ah6qt-JQaSPwGTfi@lucifer>
References: <cover.1779462249.git.ljs@kernel.org>
 <e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org>
 <88aa89e7-aa7e-4abf-babb-a2855bcb3fee@kernel.org>
 <ah2oasz6oz4TgEiD@lucifer>
 <192ad271-13f0-4e8d-b5c2-feb65392bc6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <192ad271-13f0-4e8d-b5c2-feb65392bc6b@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6635780017
X-Stat-Signature: memsnkptgt4kcwqe1fda75t58meqfy7f
X-Rspam-User: 
X-HE-Tag: 1780394840-516311
X-HE-Meta: U2FsdGVkX1+89dlL+wx6pCjPXtBqNyI1YzW6Nt55GU0Wu/z14gVeytHxLpepCY5FPevLJBS0q78/1PW+YSZcRtreyWD94MVZR2rxWUpzCVb6L2beJ5aW60mYtaKBTaqZCHnzmq2QB7npsZETwsAElGdkat2Rv2KWuRquZbKH9PFmmCj46dTSUCNs84UdNZR47FK5nguAPp4Zft0GXwpgHspGTcV7DNt8C08DHnh3GXrrnXW4ugqW6UEoR8PiQXJ2ojU5xcVhbxrUotjpWKuizJnI658NMskkCz96QT0ZpCRsIYYB3ZVPnsDBfuqZtYPcxVfa8FhrkuzbOb+w1NEg4KEpLMKRE7AfL9hezd1TCUdkvynMgmIBgfYEX2PJwqML23RJ1aNvqFxwsFO5XzSOR6cfeZItbW6YosXCUJHvbiWxJo+peOa1hhbV7XB+1S7uokwaFHjWJel0Sp3JIQxxPcCwIn5kCNyIohTBpQMB/amkr/zTyH3+dWVn4znAViAQ1mMAp4s/74jsJzasl6oMjj8NJQeXmyzv8w4pHAvuFL4ToT3JDysaIDGULU4QMqSsQ21us68OjXJUdzPJ48jdBq/8X2+2bvJ+qK8FuLn1rj38RNO6O+RC63grWJFOf/RPFKElIKtQdyu1Y0Qv3gH8AgKDQx2JOVaXujvGXlf7MNHTxTvePsKfFAJ3bN791qpejT+fJwIA0mloBEKoNmmVpT2d75oBTI230IQHIXJSNpIrmLq2WhEJrJCL/0MPuW3ZxB/3I2wqZawoGhZGP5XPeVzFbDKMMOpfovLqfgHNRRHdojaz4BOasRnq58NhqSFuA2xh8PbJkx82Sl3Dd9d2a5TgZYXStJXURbcfCjtWPfgmajIfsY+V7u8QtrhwC/Mzi11QY6VfEf2L023JBNV6ZZXX+1cEAUj1UcKA7wH78xqlzL1U4woNf4ldHKjO8ww217ktl4luxzG4hcT09p5
 hnfQXQBD
 3D/+jPmm16qAVeNgZ7SJJBQ9Tt/rwSWGu2JTaAMmj1vRw+r5gXQNWJDW4KKxpSBD7/4+JDQ5cOx/yfsZbrVOgIsPXnyg6fzCO8uGLiZ3meO+pii+aig/Rqd0abng7dZlTZByG0uuC+gJ3MV2Cec3zaNZc15++G++uS8KQKQrO6Ro1JF0vaOr2Hq2hvrS2iSpvxJTch+xZEpUYaV0GQEzz4pBSOksoCYZy8xDwNpdtdhpwk25qMgFK/aYRH54IMFzEhqaf/hbCo4Fm2BYnIiu6f2stSGT7GsimcxDVWnGOkt34FUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 11:16:03AM +0200, David Hildenbrand (Arm) wrote:
>
> >>>  	/*
> >>> -	 * If specified, this hook is invoked when an error occurred when
> >>> -	 * attempting the selected action.
> >>> -	 *
> >>> -	 * The hook can return an error code in order to filter the error, but
> >>> -	 * it is not valid to clear the error here.
> >>> +	 * If non-zero, filter errors that arise from mmap actions such that we
> >>> +	 * return error_filter instead. Only valid error codes may be specified.
> >>
> >> Is that really a filter or rather an "error conversion" / "error override".
> >>
> >> "Filter" to my German brain implies that we would ... filter selected error
> >> codes, not convert them to something else?
> >
> > I thik it's what people tend to call this, it's what I've seen it called anyway!
>
> You mean for this monstrosity or for a mechanism that translates one value to
> another one?

In general, but a quick search on lore suggests this might not be as common as I
thought.

>
> > I mean your German brain is being logical :) but by convention going with this
> > terminology.
>
> Sorry, but which convention?

Of calling this error 'filtering'.

I'll send a quick respin and rename this to error_override then!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

