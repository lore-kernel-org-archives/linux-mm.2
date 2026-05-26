Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70CD5CD5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 10:14:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5370A6B0005; Tue, 26 May 2026 06:14:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DEF6B0088; Tue, 26 May 2026 06:14:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424066B008A; Tue, 26 May 2026 06:14:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 312426B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:14:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7B5EA03CD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:14:21 +0000 (UTC)
X-FDA: 84809161122.23.29B5D69
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id C507B40017
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:14:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jWIRiwdb;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779790460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5EPf91GvJGPsVarqCBeWWTgMarT2/Tha9nPfnXcEBs=;
	b=Toi6QKpXH+ymzmAltS5LJEy55zCqSMMAeC6S5V6qy49/BT9nd9c93QdZvjhTjpGcv1QPAw
	LHUemAkFJD7G1jUb8Yi/uMDEJNF6xXJ0hTYGTT6VMrDqzlv+wZ+Q/pzJ3WAGqe0jxoBOXB
	x0/JHuf7cxtH2aRkEcu9Fycbtu367xQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jWIRiwdb;
	spf=pass (imf01.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779790460; a=rsa-sha256;
	cv=none;
	b=ylo/Zsy9LZBI5EybplmjUvm04ix7s0wybkLR4kYzbfJULTzagyL6lybicnhu109kdkpMez
	V9v4eCHJU2JC9n90qByi5PQLWQezVoEi+Q8VtG7abXL2BD6KoUHiMj46pMI+FXY0sIdioU
	zYChdJdlceH09LvJI+nGiu/taPy+Bjc=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779790457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r5EPf91GvJGPsVarqCBeWWTgMarT2/Tha9nPfnXcEBs=;
	b=jWIRiwdbj/t0ezNDh2LuQtzAMDVrnAfYEFkhIktVPbe1TImIo17G6r0s/ZzDpY6oIQU6qs
	UMF1yPBDocJzOe1jscoEIM+nO0D1tjnqHW5wPfQ2lrz2KumfP0W0+JmaeIrOYHoMct95AH
	8SMOcmf4yJqyjzUswo3l3PzsKkarTgk=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 May 2026 12:14:02 +0200
Message-Id: <DISJ221L3QED.5TA2KTWHG9CY@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Harry Yoo" <harry@kernel.org>, "Brendan Jackman" <jackmanb@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>
Cc: "Alexei Starovoitov" <ast@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/page_alloc: document that alloc_pages_nolock() uses
 RCU
References: <20260519-nolock-rcu-comment-v1-1-4a630c8794e5@google.com>
 <6c089de3-34d9-4dd9-9646-f51328c77497@kernel.org>
In-Reply-To: <6c089de3-34d9-4dd9-9646-f51328c77497@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ixkgi4frhbj5xkw48sjonm88pipchsur
X-Rspamd-Queue-Id: C507B40017
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779790459-584983
X-HE-Meta: U2FsdGVkX1+xYiqlNkIyDt+QL1z+YyzztcFeATxuOGzEeElMwmzKtIL+LEoXRdtqJorRALvasSVBCOtbiUu4swlGJOeRKUj6u0q1gtm6i/P4LF8f82Ume3ZZwo9fW45GE/vkZoCYjKXpBdMWoWow0vHEoN1ciD1pUJB5cMLlmr1pvAyIjxZWB+8vVQKTfJc6GtJwY7B1xQERegaJF+BaxEZrRrYrEQaehPAatLt580tzRkvTYTtC7Gg33Ln9FEgMCythnYhzkIDV6MJvjb5Jn0bJtQyYmS9JCtoRsUZGxLXoZ8pbC5jkRCHXehuEKyA94ibWtWIKo4qp7V8PKszK0ubk/1Ncza2Qfap3ljyB7qaPmQd77QDusVOLZX52BsZWH4L2NL6zROtM4vhpBp7I5TsdwG7AuSR1OeYfv0q9Ncvea902ak4Ge+0wTITy8qeJbZqe/Jr+9s6/oA5RaLqKQ16IqhSsKVY+dXztRLsdOTAFWSAWmVn0lffne72jJ9EcuS2eMozWDHn9A6X/1lTuxvS88RkvtA9rtD6xnaaQ/nqgGcbfivkzGEw2pAJUeIvYxvrxL9eEDNf8NckPbELHEsPGmDJnLtJIR7jp7yV/vhY6UgJFL2mP4fgKTyV5phiXG0+7JbIB8snNGtCflSF/fS0VabIZSRWrP/Xg5nJ4RLKXpWn1Qx5ACtxznNcDkQJ+i+PZMCgdbNtV1qDD9QX79v9YT1XRtwxe990jWSH6sUfF6t4MvB1fBzS0gQX8xOY9A3eva9nnkoTgu0tvH3UEugkBTNsuZDsGeEagsnfjVOqAzvKxPn+4N76oWgFb33sHH3wTdU4CN7BM9YtthSuMbpxJYtJ4fZPQOZjAHUCdMyWtOEo8tPWX78YQSo79LPXi5fHxfS+rU8vxuhcZlbQKrALYl0ZdVitmckwecrjnEWsPTfRGu2UdLHX/aQ/F0RSSibs4On97avIQo/NadZk
 N730ZXKK
 WfMN1w0n6v6wwLG3z2DaTP+EGn4eLXRigcC6+Ahxqo4hl8dJambWGSGoohHsic65pr9KUDE6MmFR5LxWFJq2vzKHBMNq1HyHL5dwos5lVqzJ8bGKCcQPzjc/gIqeC/uQAFsQg9qF6mrHAZiVIhg+a5+5DXMuJJvq8tKwKUJQaskaAJUMR2Kq7wmvzbH/Y8+qMsCJTOxCXIsXJN4b8BwNNSGuZEnLN9pi5jxlwO2OOD63DXZw9ieO2mtKnZNjwdQQs1MAyaBEm1VKJCbIsWlh8yBbqN8SNsB4lROOkLEvkJ80RqT2nk7pD0uQ7/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 20, 2026 at 5:16 AM CEST, Harry Yoo wrote:
>  > (I don't think there is even> any documentation of what noinstr means=
=20
> at all, let alone the connection
>> with RCU).
>
> *flips through the documentation*
> Oh, perhaps Documentation/core-api/entry.rst?

Oh, you're right. The situation is way better than I thought, and now
I realise I have read this and it's probably where I learned about
this in the first place (I thought I learned it all from Junaid). I
apologise to the Documentation/ tree for my slander.

>> Note this is not claiming that any cgroup code called from the allocator
>> would actually break if this restriction was violated, it could very
>> well be that there's no real way for the allocator to act on a cgroup
>> that can disappear concurrently. But, since it's likely nobody has
>> verified this one way or another, better to just be safe and declare
>> that RCU is required. Allocating from an RCU-unsafe context seems a bit
>> crazy anyway.
>>=20
>> Suggested-by: Junaid Shahid <jackmanb@google.com>
>
> The email should be junaids@google.com, not jackmanb@google.com? ;)

Damn. It looks like this already went into mm-unstable but I guess
it's not a huge deal.

