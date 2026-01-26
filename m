Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DC9D1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 20:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51626B0088; Mon, 26 Jan 2026 15:04:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF396B0089; Mon, 26 Jan 2026 15:04:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B0C6B008A; Mon, 26 Jan 2026 15:04:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0C66B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 15:04:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFC9DBBC2B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:04:54 +0000 (UTC)
X-FDA: 84375193308.03.4B86C4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 276CC14000E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 20:04:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hu6UvO5x;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769457893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9/XfxEbKxo6jfBMokoUrz0wkeQKzvvz9k65eKTKgPw=;
	b=m67ag/6HIeYHmrqZ9DW1FqKeJti7M7pr0DiLEsuQuJ3daTWfRtTeryRpPR5kgDpb2uQkNH
	nEvnrlKYfxsv/XPWtV42Tvy+7dQmcjdfWvhFRITAxgSYnxwtWEAGSW03KOQgmzDctR7bn4
	SjCjf9Qfbl2ZzwI3OIjAIwVK/bPxHOE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hu6UvO5x;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769457893; a=rsa-sha256;
	cv=none;
	b=Njbl9X1VJyvI2FXx7omnHUk6xx8vX5TflqHWuVpkUpL8b5y0ztPcYhCZgn5KrQ9xVVOWT3
	nB2S0oDfKhKKCnVU1E6uDea3GjkbXsvSPXyk2fwyHN85XKQqaTRDMqLNGwszdroa0hauhP
	dgOIdKDbNGf3x+z0kmVd9Ykk4JRwjH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2488F441A1;
	Mon, 26 Jan 2026 20:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FE5C19422;
	Mon, 26 Jan 2026 20:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769457892;
	bh=Qgitda7HeemsJndbjdX5t1c7WSfPT3w4xoT/j8RNL44=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hu6UvO5xnqQiH3CnmvkFr/5tCKZy2ceKq0jxtcpi559Chj5lkWBPtWjnW19p3MWQV
	 6InR5lpiDQaQBKzN0eQbX5GAAcHMnXNdbsZRmtsH6vHgNPcpGxQu2d0nGAbSJQ7FIp
	 dxN7nzl45vL1Yoj24Tx89+XNVu2RCmvl/mXP84Bk=
Date: Mon, 26 Jan 2026 12:04:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shardul B <shardul.b@mpiricsoftware.com>
Cc: <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <dev.jain@arm.com>, <david@kernel.org>, <janak@mpiricsoftware.com>,
 <tujinjiang@huawei.com>, <shardulsb08@gmail.com>
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
Message-Id: <20260126120451.0c28a6deb3ab532dfae40a24@linux-foundation.org>
In-Reply-To: <19bf8d68cdb.ae2c0d37126486.8380742359510867201@mpiricsoftware.com>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
	<b2b99877afef36d9c79777846d19beeb14c81159.camel@mpiricsoftware.com>
	<19bf8d68cdb.ae2c0d37126486.8380742359510867201@mpiricsoftware.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 84u5csrn8pp4oa4i5sr5s9o8ecskc9r4
X-Rspam-User: 
X-Rspamd-Queue-Id: 276CC14000E
X-HE-Tag: 1769457892-433586
X-HE-Meta: U2FsdGVkX1+BjZ8ZThuY53QFN4dvmK9Kg/fRpV8O9vSui5Sba1nAFiCNWLPgIRpK772/oMlcTGvXXKD72iu1NIJpVf1ljQKvrHHCvY+xvFnD3Z6k/hCZg4M8i0HqcdeOLbmNJLJD16lTTByZahqEYkogh4n8vWYTfwkdUzAT6a8/9ysoYcMffEBErC27vbeMutRxuTdB7/mtzlujxCZe5wHKzp4Rsaz+ol7Lh5hlSvgQMcgTWPbGFr+UDhH6tTGgec3jRRsa5GAUa+kEsS5tMOO1+Fq4DMLtaXr8V9xCfCwW4cPXBGsfYot+KIojkhj+XYqh5T6zzBJeT4ikRhXbyKZg6NbB3ZC653/YE6zC75KKhDHG46CQ9DRvIvYrD5889ac6Aj7Usc/pc3OHYcx3VXjxdxfPcjx81LoPmAA0TzzuAq6s4AHDxSObs6O7BJUufj105+a2RofjMMfUa1qiq6+8GzKzI8csDGEjVp3dGVfVtnJJVJVpcWo64Na5pFPHbFSFkmsE8QjmGdA9W2Cpwo44ZssoC/T9EZtoxa2kzkXS6Dx+HsnZt/ZP9wCVV63QLEs/KDGoI2MhMW6+XvDuGyhFypBWt6xzw331yX91in5Y6lM5V2VpgHo2zQ/Yen3fUSQoxR6oTE31U3d5vg14CaJoOjw3km64aBAaoaZazaW8XGZZhsX5We/hrJZkLgVx/A0K1ZCuSan8Nlo7SW2upvwj+g3q3OzNlXUM2k1N0zogDOveSsmOlzfHWdSznQrz2WTgdnnBus39d7/x6eSreT64Box2mAHZdSej2cXbAx3h4LuF1I5SWI4ClKqZ3atsDlV5FUjMnfVjDE06gZVFuSwn4+IWRsRvfP2OWAUXIa9AzPDijkHUZscb7l5oQzbLHy25lBtQ7o7bFnSwGuqjiv7KotnHRhH0kzxkcri2EPwBGaPqQHzds2pst6GAf/U+1WrooT3wbiPioEXVnlf
 yiCjJGAq
 78I1Vab2e6TbJUgCC+TBwmJ+hTLr2/yqI+mKPROR6+5iJ/hdH02MAkblp4DnLL1/GDk9oKlzGEXhBzh/X/UEWxD2DqfzrBkXwHmu99yicxa6kWZcDrVVztkeCzWnY6gCaGpCIeZ9Fhoo2PbABL3TzZcJxEms/7Due1of8FBCoNybH2HcRd0/KxIzZzjC0PIMdGaFyAcC4P5MI99jB5e6bv5e/pn83Bx917GsqFULhmsBFN3XnmckkE2Un//UeOtljGQa1oG0Ga/Mde/sqWo0kOQu0EXUPDhsbjHLELhmMhbJNxJrzmywXCQimZDxr4mJ0gN2uoOLUg9/oSye8ZYxRlcQAzQT/3tmYR0JUQzlt4Nn5QHVCqYssiqQGy1H92KhR0S8oT3TqiVvGMzi8e1lXqeTwxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 11:16:08 +0530 Shardul B <shardul.b@mpiricsoftware.com> wrote:

> Hi Matthew, Andrew,
> 
> 
> Gently pinging this patch. I’ve checked the latest linux-next (next-20260123) and the akpm-unstable branches, and it doesn't appear to have been picked up yet.
> 
> 
> The patch has a Reviewed-by from David Hildenbrand and fixes a memory leak in the XArray library identified by syzbot.
> 
> 
> If there are no further concerns, could you please let me know if this is queued for the next cycle?

There are comments from Jinjiang Tu and Dev Jain which remain
unaddressed, please.

The leak is a rare and this is a minor problem, I believe?

I'll queue the patch for some exposure and testing but it appears that
some additional consideration is needed before it should be progressed
further.

