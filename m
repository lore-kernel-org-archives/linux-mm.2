Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A39E7BDA7
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 11:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C496B0005; Mon, 16 Feb 2026 06:58:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9AE6B0088; Mon, 16 Feb 2026 06:58:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB676B0089; Mon, 16 Feb 2026 06:58:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35D7C6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:58:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCE0E5D00A
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:58:53 +0000 (UTC)
X-FDA: 84450173346.09.2B93928
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf06.hostedemail.com (Postfix) with ESMTP id D559B180010
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:58:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R Wlwbz6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eXfAqcJv;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771243131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Txb1GlfaNj6QsBkGXL0Y8LX/T2eZ3egoSe8EqeDF3Kw=;
	b=6qlAZAtpbAOC5/xwwrzoV8ROT5RTm56lNsnQQaA6D4QLrlCatHjdBq1o37QzedvV2F5eVq
	mZAbob18vhCWVlZo9tC5vvP3CIuLkif8rdyhJbACkS8gjSbPX1XrFVqTyyrLp2k74AwXvY
	QxRDsUD+3z1+/VoFoRyRKGipgEfKooY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="R Wlwbz6";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=eXfAqcJv;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771243131; a=rsa-sha256;
	cv=none;
	b=6Bm+aIVHtwOZ4hQp10sn4wD3y1IdEqM53ZNrIs9CAvnYA+OQ8aLSe1RaL0Nmojbp0SugoJ
	hmSo53ecG/CyTFXKolm3ldlKyHjLaLS0NQ0Vcanqh6gSPx8JLrmYbBGJpkkAmJnAE63JFR
	lAMHWVUiNVMIVs9gicMRqu/ROyh3CCE=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 5B6331300FB5;
	Mon, 16 Feb 2026 06:58:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 16 Feb 2026 06:58:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1771243130; x=
	1771250330; bh=Txb1GlfaNj6QsBkGXL0Y8LX/T2eZ3egoSe8EqeDF3Kw=; b=R
	Wlwbz6Q5IXK7qBQ3q0uMQFp+RRNtCL9XxXVLL4kRsNl49e3B/58+p/cTIFYu+A90
	sEzjim3C7EvJewipYCGqeINLRR3hg65jCFxZHU1/3OrPlNTG5G2FVhmoj/FDco3g
	bFP9k04Js0dMWAgUPqV+Cb+60CzgAvSYhtjWu68Hz1nJ3t+gwcCaWr9lBV0U93QD
	G/6Gd8ZguxguxonJvklK1kZMHhylmtlrGpQvb8Z7gEASzgeZtePmk5ui0Xfxqtv4
	2EEcmbYwNRm5UJNXca1jwv9O4XOOkk/hmU420xvIrMA54L8iF4Yk9Ps/OVM1lyiH
	5gYgTAtTjq2DLP3sO0FNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1771243130; x=1771250330; bh=Txb1GlfaNj6QsBkGXL0Y8LX/T2eZ3egoSe8
	EqeDF3Kw=; b=eXfAqcJv2jMzeyA+pUwXx6/kyaCkwJmH5aqap0KrfTwpB/wZ4rN
	4Fm39bR4GjYG1UtdiYeVx0RTkwAALGgJtWOSWqY5tRiOXw7sGW6wRGBVo8AphS47
	Re6Lm2hCR/AJXkwOx/swSR4PVBOLV+hCrYsQRECS5xMOVAQZxEr48k4Ih7Cw2JLh
	8gi/gHYlVId0Nq7KNxsmoAmDK72mJDm3jEqxegleUUbdFxt6O39XBfk9l8gJV0aA
	Vpl+pf5EBXyDQ+oNhCe24pNyy+4JfqFVgvv+MWYLbG4zgNwAgYcR0GvALNZP/D50
	DVhZF/ob3hDf3rYqSsHf09StfNV0D0aoJ5g==
X-ME-Sender: <xms:eQaTaVv5D8gzRkLxymvr8DybLARyMSvzBtimi9zI8Lg46DBaihVGqg>
    <xme:eQaTaUny5-1Gr2KeFPbuzXhh8qK9wPO5d-aCm4glyScU7EX9JJN_hOxNRJVVOmisx
    lrfTZVwySjrekSyq0RrsAYIK-LZm33H_B3LuRCd1VtAHe3dJ6DytMHD>
X-ME-Received: <xmr:eQaTaeVmdwPSpuDP_KgSOiFBrvpFWv_NA6HWw9ZGuAeEfy9Qt7VdrUY7cCo05w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudeikeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtohephhgrohifvghntghhrghovddvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtph
    htthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphht
    thhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepvh
    gsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepmh
    hhohgtkhhosehsuhhsvgdrtghomh
X-ME-Proxy: <xmx:eQaTafkqindjml57pRzcx-lrEjSyqEvRcY526Xyblks3LhKNlV3L2A>
    <xmx:eQaTaTTJaK-14ZTbel3tlSBCPavTnDw48qY7X1RT6XLJxAcFxJdWTA>
    <xmx:eQaTabGmED2b5KfgsC7bH5V7OiucZAS3Pb4du7uKQ5dwn0lyHELAFA>
    <xmx:eQaTaVhWPjVlqrvmvYWjbI4a5fRxsOUUchRdk-FFKRBg1sH0nzHtOw>
    <xmx:egaTaQXSDrQ5dFtaN23rpncsxNALDkL1YTF9u1wvQo_piyZxOzrDov64>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Feb 2026 06:58:47 -0500 (EST)
Date: Mon, 16 Feb 2026 11:58:42 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wenchao Hao <haowenchao22@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZMEvl7WUKyxmgIh@thinkstation>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D559B180010
X-Rspamd-Server: rspam07
X-Stat-Signature: rm6srrhnjsr7cm9ru3u5nwj493kkuddc
X-HE-Tag: 1771243131-386374
X-HE-Meta: U2FsdGVkX1/9UDQ+wakJaQn3TKQgtW2odZBIDCHhRbU4DOpMhMt7tbHh4hvLfGHKO1u8DpAzJr9U09XpGuPpLQJJJQtcjC0rrcsGPfuyTB9RnZIBMBS1/4vL2zPpuEMEcq6LF5uF6GEFOyTdRtdFUBteMvZxS9AfED2eg5mBBcNwhikUmgO/LNilZxpeudWTCPERB9LHnF/wiYyLfzNgd+oqb6In4OApS2BcqJnbE2A2AKqNJPOB51cPSKokKsxNBkHa4FTManAu8ZzuWzAdLIUGCMvvA9uYnxjMH/6/M9fjfXshuoOmTVYPZXty3w2jYoNgDD3V3Qkiznq6FkxLdR5t8GAcw3kvrsGpfLodgQ/Axz7rpRzYV0pjkhKTL6TFZ6c9LFrylW+YD2ZVxlQNmDiwwMNx4PVhhur44vvkjp0glmIceqAit+sjx3XKenIZfGPxXbXzxaj00Yc90yaqXMETu6MQAoGi7rlOeftgeBzZuL7kvzxhz6Lw0uyDyWl2IxDAkKY3LT9IHbEjrHOuQ1DIWbFWaBXOBM6qR5hjCCcHHoG3f41SXhIL6HM+bUxuOfNy6lj/OJVMBWshcStXpDj5TK6NqmlsWMR96wvOFjMm4EK/D+iQ5QOz2NFlQnreUc7Ey1zUZm/6T3w/kQTNVCc4RDvz53qOiWXcWiwF64jQTYAGHZnAb+H+D4nJ1c+NBvO2Cg8eVffK6ogKXtQuM0d8smRJYpPcYPNkfcU69lffVNoM/mvlOgNuMKlToNGeVKhvoVQTnZNahe8P0HEEza/xEJsObitpLskWrSrfTqkSEYqdZtSNL/t3PwQ9dEP1p76dRS5IA07fG0jO2f3yCCKa2NJt0GlATPUDqCPtiP8N+13M9wbb9Qqs+AaFm12sJPMPOZ1EQeUH3krQEEi5ULLk5jXFHqRRHo7pVSb9VYWp6gV7bIXRwXYpzYiD2l5J+OioJNdrFh5meTTnB/L
 L1pFAp0f
 W2ELBwVoXifpXvYMo8PDQWEiPJrUogIfDWBm0TBuBu7gx8VYD78dqRpTXOdkaNLq74QsigXEEjzHpKWSjbkTIhCZKoFjOYsJDoxJC+ImmeVLmuYYinp7tT4lHJfkMRkwO3QHSlb3AMFTQt2tvXrWqFnN3Qigrv7LXvRqNT836/O0Aa0S2S4/RpmjsXwpBBuFJX2jAyO75CfM43Y+x9k21+l9m7KdHVf/Mp8HZpwr6RHy1gbhaMgEwrnZAAK/hwO5daE4Fmm9o3Yq7sb2FZeOxmAYeAy+cYbfyao0Z4jewGfh4Z5IIo2unXWxuIV0TE7w7yHFiGYbLO6epe8hNZ432vS7as7GS7+oDNj0HPWcFQZt4h6AWgXBWUrc3kU7czHOXkxs+mvzWuYT375RI/ArzkUITbLlwuSQPOYVyt4OUY30s57U3z7MqAwEhqrOR2mllUDkp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:45:13PM +0100, David Hildenbrand (Arm) wrote:
> On 2/16/26 12:34, Kiryl Shutsemau wrote:
> > On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> > > Add kernel command line option "count_zero_page" to track anonymous pages
> > > have been allocated and mapped to userspace but zero-filled.
> > > 
> > > This feature is mainly used to debug large folio mechanism, which
> > > pre-allocates and map more pages than actually needed, leading to memory
> > > waste from unaccessed pages.
> > > 
> > > Export the result in /proc/pid/smaps as "AnonZero" field.
> > 
> > I expect it to slowdown /proc/pid/smaps read substantially. I don't
> > think this line in smaps worth it.
> > 
> 
> That's why it's enabled through a command line parameter.

One users want the stat and all users on the machine pay the price?
That's a poor trade off.

In general, smaps scales poorly. It collects a lot of stats and most of
them are ignored by user. We need something like statx(2) where user can
declare what he is interested in, so kernel won't waste cycles.

Kernel cmdline parameter is the wrong place to declare what stats you
want to see.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

