Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E31E2CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 02:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22738E0009; Tue,  7 Oct 2025 22:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD39A8E0002; Tue,  7 Oct 2025 22:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7DB8E0009; Tue,  7 Oct 2025 22:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 99C558E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:07:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22257B8F81
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:07:46 +0000 (UTC)
X-FDA: 83973310932.29.D068850
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50F64C0007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 02:07:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK+v+Ryg;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759889264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcPmPhUz1c0vqDGf/BJJjPlQYYOjd9QFCOfmGvu2dws=;
	b=a7Brp3mgoDHVNGllZSYSmO+5egpJB+4JoSmpAPTi4tk31R2RxFtC0XBtCMBUisNffDnDKr
	q/mBMRoYKR9VPcJzF7EvxVNquk50do7f0OkSX9kh8+5dXIWZlgUlu4Iw8FSdzCpakzguON
	pyAtlniA+UdzIyWk/FDzFJI1M1etvxU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iK+v+Ryg;
	spf=pass (imf28.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759889264; a=rsa-sha256;
	cv=none;
	b=6OMI03BDqSHnQMyRrJV6cMMPtkAd/z4hWV/fMAh/EP9Wur7KYEV92d+q1tUf5Dlx6/9JdG
	hNvOIQ/Ie7k1V4aNTBagNSUbVAgRTZZE7cMV/+aJ3ty7Ha1v7gSBaeHligyY0w/+PMgMWs
	F9XKRO36ybXZ1X8A5T3C6FtZQcUTNks=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759889261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HcPmPhUz1c0vqDGf/BJJjPlQYYOjd9QFCOfmGvu2dws=;
	b=iK+v+RygeTMZeXcVkOCn1vhtTEahSVmwSjRGVt0bfdG7/2y20M9tDnQb7Yt9aiZcZAhODk
	Amo7BEuRGY8OSiRi/6WdXsWEpjwtocI/nnkYPeYMy8OKc+IWRNdoyvV3cSftItvQgeCG9Z
	feLWm8udWPWo1H90xp22KmHSU0kc1fM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Jan Kara <jack@suse.cz>,  Dev Jain
 <dev.jain@arm.com>,  linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: readahead: make thp readahead conditional to
 mmap_miss logic
In-Reply-To: <20251007175343.107b17191734cddd7bbdeb54@linux-foundation.org>
	(Andrew Morton's message of "Tue, 7 Oct 2025 17:53:43 -0700")
References: <20251006175106.377411-1-roman.gushchin@linux.dev>
	<20251007153424.1b46a4018e17d5dafd7fb126@linux-foundation.org>
	<87play1fzy.fsf@linux.dev>
	<20251007175343.107b17191734cddd7bbdeb54@linux-foundation.org>
Date: Tue, 07 Oct 2025 19:07:36 -0700
Message-ID: <875xcqi1sn.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: n5gtt9m8qzyg91xjifex4gqkn1ew1bgu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 50F64C0007
X-HE-Tag: 1759889264-694403
X-HE-Meta: U2FsdGVkX19Y9X59kxccNP68HEYjLiBa7V2Tc2Piz2huxnIDHbEIZnpM/lPrVrj568qZE9tL3RikSvdrqoNwcB/dl31u5jVIYkxLZnpMFGkF94FjF6mUald6sKo1FrWuClz0jEsOStBqUbMxHqwLitiwiU+BHfo9bCEmSAwJqAGpaWSwN/aw2aXANB8DUhUVbbuJwUQRUhFfeUObyTHMtbcZ5QZLrARP+fC9AoPNYH5UG9jXWJD7l8RtR8/Bi/Bn64l6mICOnHQA40zYJrAAiWCdKeyHTmHtD/jlY1tXPXQW2l0ptWlFvOZys5/bG5a/Ik2qGywt2CZ81TFL7eWvFKSZ2SdliDsGf8saoXyov9+ii39ZpCNCwnmz5ZZ3JCkwm/ZB+m7ZZmGWm+4YSPQkHvQF2tu1xeoroxcWBZ4jXH1g1F3TGQwiZIZxGnjsEBvI0zNUol9i0HyJ+gc6MvRBU4gEOjvAA9bmDENvz1DiRtA3KT08VmVVLHQrB1NPjQtDQfSlNeFN/1gIr7SRSphShfUvwRmgUVWF3T4u9kT45q0S0je0lzezx5aWkXqMycOwyOYcxJW/hPaIglBfHDK83D0vh3ZdFgNRkNPoSoEujoizR8oEBdulzkJWIthGPPi68DJ5zxeTY+lYP9ftOXQkWC3QzwURpEtyQR4UCpwrqimjmynZsWsX/n5jv6mj3rlZVjLtNzJZcibKatvY4+wr22618IygcANS0lpYSWDfcD04dA28JDyKJQson2X05us4bcxki891kvtjB8zjg/yiYsh8EtIu5lsXAtTEi1wH5AHnK2RCEH7oNUEZU7S8zaolmrjvf/0Qkw4/+PNs+T5OetkcbxrIqelf5J96L0WZ8dED86XTbgXyWFvlhJlCqzwEhoTzPC15d3pmOOSEp+7vf3GYowliheEINKkAQeLINvSxlg0wMBkQECEK5be2thuBzPHAKj6IrxtK1tiZiGl
 lGTfaGSI
 YRsG0DhFv5yvz8ze9EVFjHek//tUJI13Xk7/mTVszKTNtyI0nwWnyf8NuSp2Dsmg2hcb4Qb1TfM8YN1oGL8BD9yD1ZNxeriNuyDMABJefCkZPjnNTORnwL9nsgrPTXVBJR8PGTeC3nSWK1Sku/JP377WyLd3Kl5QGQBcvYkuCpXVxK39eWT1iOg/2FAqLaK7a1Xp/0k+2yADJ4ai/TL/1lQdfe5UI347rHHgzlUvQzcDz63q4wwDsoYaVc2GH3M/za+rWSnW025S0bpLJwv1zbv85YCE1o5A8LE1XG0eQRfAV5QUrMKmzHsRLGDiABpo6sujc70ZGwt+eVGx0xjxk6a2WnJoR1gpv2ggPpoE7bnT1OFj7FZRLwDWbpu8CxOW3Dg8E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Tue, 07 Oct 2025 15:52:49 -0700 Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
>> >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> >> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> >> Cc: Jan Kara <jack@suse.cz>
>> >> Cc: Dev Jain <dev.jain@arm.com>
>> >
>> > But I'll slap the Fixes: in there, it might help someone.
>> 
>> I'd do exactly what you suggested: Fixes + no stable backport.
>> 
>> But I guess it still might end up in the LTS tree thanks to
>> the automation picking up all fixes. Should be ok too.
>
> They've been asked not to override the MM developers' decisions (ie, mm
> is special).
>
> I'm not sure how reliable this is...  And I'm not sure how they
> identify the dont-do-that patches.  Maybe mm/*, maybe mm.git, maybe
> s-o-b:akpm.  But I haven't seen any transgressions in a year or three.

Nice! I didn't know this.

