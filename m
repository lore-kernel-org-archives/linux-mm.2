Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88669CD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77C386B0005; Mon, 18 May 2026 06:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72D796B0088; Mon, 18 May 2026 06:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643756B008C; Mon, 18 May 2026 06:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 53A016B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:23:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01F451208C7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:23:30 +0000 (UTC)
X-FDA: 84780153822.24.797BDBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B47D40007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:23:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QzrPwq+b;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779099809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsVdV2tJCwVihdpXcnb07BjZ4rZbs+BF2ObSo0uhDEY=;
	b=NZAm7texf0Hzf/+PrFDHp7ruf6Pj4DPTLET1zI7Yj3KdmjQzVac4UFvjree4tTGkBP4QAp
	7ZlQo1cRKE3StgAM0YQedArJFG2bEu13jxF6pAM+9b7yBad4sWebJ58wO+v/jLGwM/0TU+
	ZepDXWi+zlUHB58t6CoRtAWQFLv550M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QzrPwq+b;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779099809; a=rsa-sha256;
	cv=none;
	b=EIgbZfQJa80XnWY/XBcYZG6bildMfGDM1Ym9T3/PP2VhYQpJJuu33O8G2RuciY+XUDqPvU
	RdqhmQhKDgj6pHvL3LPXcasQ33hyDQX1N2+vJ/Qu0O0Y8WbRozhzeGjVuvoOfo8waCHksu
	Q5nPTYLEzEel0xCE9wCunH4j1y8p2MU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25ECB41988;
	Mon, 18 May 2026 10:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE45C2BCB7;
	Mon, 18 May 2026 10:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779099808;
	bh=EsVdV2tJCwVihdpXcnb07BjZ4rZbs+BF2ObSo0uhDEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QzrPwq+bQXxoFDgypZZeAFR6sw6ElgJ362xv4NLqAGdtw+SjvH+EK2h3mR2kUO/oY
	 xisUGPBlFV2/f8lwjySsMyf1IknxqNVxQvsMsxDbPxpX/3xYSDmZtkFoO73jMY6zYP
	 ZTJEiBAWPg9ALNU+xIBXMr9MwAenK7PdqIntFjdcP0ZOPh/JxL1tLETAjQXwD2Q0Mh
	 7CvLYs99a+dYkqSpWLrdeylP6Ygdx7Cgqw9MIiuAwxsIJ/KfLGgCWfBwSmF/AFcduR
	 P4KaC2+nntURHBprav/RGfHcDlW5crItdRm7VqKESy2cwHpoe5DAE3bGPvi09rW1Nw
	 8QswG2F4JWAMg==
Date: Mon, 18 May 2026 11:23:21 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Yury Norov <ynorov@nvidia.com>, 
	Thorsten Blum <thorsten.blum@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Message-ID: <agrmeROd6Xu9m680@lucifer>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-5-thorsten.blum@linux.dev>
 <agnehRPd6SeoO9ie@yury>
 <agq2QNwd0n6OK6fN@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agq2QNwd0n6OK6fN@ashevche-desk.local>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B47D40007
X-Stat-Signature: 5tsrpmssutw9hfxdzznisbrasee41era
X-HE-Tag: 1779099809-94215
X-HE-Meta: U2FsdGVkX1/+bogThZ1A/q8jNzUS3bQNouEL2nw3WOL9DnaO5M/3O/DKW6qpu3XqvhU/xGYF8DZWWsTdqeoSnC1Mq/4B67AD/MrlPVoLfZYWbz6q+kgdKYsb0ksGoLQH/f8Ztgq22Sh/OUxsJga31Nn/Wee+btvVOWs3nOiW3eG6mL8vRGHK/ZJxEqE+wfiA5w3MxOjqeY/XDM9IxdxlZjMo2sPKFeGkn7bAuo3AhAljooPyVKcwDWUS2FCrPdhycIvzORyFtbYSyMhhwhQTiU74IcnwxGWM+/svWv7TIFy0o5JG+C9ZzZ+luT+4XwuSZm6ShmX/P0RIwfndGi53bI9We0avnSzSuQzZEsfOSZ9JyzpTtvl4xBg9z4EEGQLzvNSRgFwL3qkaq6nrztMlWUG47QUUiZ2AAy4YRXYh9/MPw4levh5mPGIGG8Uhk0gM2NpBwSEfW6mvCnCeqKnhAw3Wemsfm+J0Esfr64l8gXY7jh5qu8aJkfq9NXP/0ffwu6ONgSnzH/mFMVMMNNyuZGqe240GjtFnZDZgF7KiRO6coscrB8bpEvH7TJSeuiJ+Q6ebL1v6iHr5sDlTAxWCppvAazJRjXKIOzugWDGpLP+cZbC6TKio/bzLAI7nz6UjhrxaT0l9NPuSCFPaPIQBLJliagdy/fD0cDU0U2Se1xV/7EC1gTttkXeX5P400AG4bEHS1z8pBRWN3NXPYm2BO6V0yGpK0uc9DilSh8GcPI6si5NuJWe6QfK2Wp69v8ycHbjF/DWPC/BrLAQm6Q7tIn3dDZbazlZpWSrrh27tiKeG/N8KQVpOn3Bq6EcBBTRf5zSOgWmEjAKvrv05tRzcQwCYcV77jhzCMH+UP55wUzPJaZweXbGW99X3MWp2b4OJ90szPN1VLSnJBEq8gFf74hQ5zZhXp/zMy6F4ladCq8xwXIK0QeAkzjym1lesVNELTOzuYr1944XsVff8mOX
 Va7ZD1Gu
 jsAZCsnlh2/qRTC1aWlwaR+2Ynm9JZ7DVJz3BTl6HD1Bpmg+GEZJ3/tCAu09jdYbaVjPiYrwrdhlQiWBu1AXgByaG2Ml7mKwMhR5q8tAECmSpVw+MEsHfADTzGSh2dc+e8RJRxX/KQGnBqvjLdXfZAdJIj6GFa4XNO1anZC+yYTuAJ/m2JuHH/HL+/cmwNriunOfn9U2A5O6iTv7UvDFYRuHrBJcBrQaP12dNmITV3hQJgjZYNmONW6Dgn5vEMpk8ePUX2tzbvgwdBEIMbDlvfI+xC0V63LyBNfxr05M0kwTQQ7/DTH4RpksODpYlPaWdW8TbuVOp00l1l78RizGuo1aaAnIPfnloNk2eVwxwoqQe5OSeT0in6yzU5FrBjsrDOLaLQvRNF9POllQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 09:48:32AM +0300, Andy Shevchenko wrote:
> On Sun, May 17, 2026 at 11:28:05AM -0400, Yury Norov wrote:
> > On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
>
> ...
>
> > I've got a series for this
> >
> > https://lore.kernel.org/all/20260303182845.250bb2de@kernel.org/
> >
> > The feedback is surprisingly negative. Please add people from that
> > thread. Maybe you'll be more successful convincing them.

There's a cost to adding yet more super-specific headers where stuff gets hidden
and people don't know where to put what, things quickly become a mess and header
dependencies are already a nightmare.

Also in the case of this helper, I don't see the value in adding a vague,
untyped, confusingly-named macro when PAGE_SIZE - offset_in_page() is perfectly
cromulent and clear in what it's doing?

>
> We always can simply fork, but I truly do not understand the pushback.

Well, be my guest? This isn't a hugely helpful or friendly comment.

> These are simple macros that are way spread in the kernel, "include everything"
> kinda linux/mm.h is not needed in vast majority of the users, hence the
> split is logical step.

Right but that's completely orthogonal to adding this macro?

I'm fine with moving offset_in_page() to e.g. mm_types.h.

But a series that doesn't even give any actual motivation for the change is not
convicing, and we aren't required to just accept any change.

>
> I'm in favour of this series.

OK, I'm not :)

>
> --
> With Best Regards,
> Andy Shevchenko
>
>

Thanks, Lorenzo

