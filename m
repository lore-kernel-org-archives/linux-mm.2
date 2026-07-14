Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A20C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43EA26B0092; Tue, 14 Jul 2026 06:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416796B0093; Tue, 14 Jul 2026 06:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355DA6B0095; Tue, 14 Jul 2026 06:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09B026B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:00:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7401B1402F7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:00:16 +0000 (UTC)
X-FDA: 84986936832.23.556485D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4858D180013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:00:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bkl3kYSs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784023214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUPSX3E//W0AeV47HSxp4Kotadz3oWkmsbNwC7CKH3M=;
	b=dj+DuT7eMUVo7vf1vRM9zNc/sA6CdVmxPOKiNXOc2JimP9w1zM9oKVx9Z2MomqrBk/7I7o
	v1Wkyaj4jt+Sm4DSyqN1qb1B5PUgNs3Uhh5P7dsXlJPz26wEbgPVl6/aGlDGJywMhe0F5y
	v5E8ok0tHkKyqZjKj9EVn76gb0No9i0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bkl3kYSs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784023214;
	b=KqG+sXZbmblXaaFHOP6iYzazv99bR9tXzlsVdC8MmOehRF2p6M05GJCZf33dweCaoBRh80
	lWt83292YdhQe2DHkqnUCbvcuwjQK5K7gE2eBkm1eoIvY72/Tgvka7t/xxUjo/4yOYQEio
	vZBI9OrHk6dYb3fPqxX/2w4xl+bPZjU=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784023212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NUPSX3E//W0AeV47HSxp4Kotadz3oWkmsbNwC7CKH3M=;
	b=bkl3kYSsZsZgtlbsRJie/vYiUcqpiiAwW8MCWKzmGVHbETWoW37cqDPc8+pNOw9B+doh+V
	YGZ8pI0v8PvVLrfI2RCbusZIbxrNvlwCFiTU5qX+XgbDOMQGVUs7GFk5mydNVB4W/PqqMz
	dn7Vgg+ePbQY/swE3bofW8pauXZpvWs=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 09:59:57 +0000
Message-Id: <DJY7FYRG6QAO.2WG6GBYXUKGSV@linux.dev>
To: "Brendan Jackman" <brendan.jackman@linux.dev>, "Harry Yoo"
 <harry@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Brendan
 Jackman" <jackmanb@google.com>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <sashiko-bot@kernel.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
 <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
 <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
 <4c969202-a8ed-41a8-9e9a-281a12f6dde3@kernel.org>
 <DJY7A190TSH2.B1XHHIACRSYW@linux.dev>
In-Reply-To: <DJY7A190TSH2.B1XHHIACRSYW@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: yqtzga3w5dzqbtior759by4mgkc89ctd
X-Rspamd-Queue-Id: 4858D180013
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784023214-503083
X-HE-Meta: U2FsdGVkX1/xnJKWKd+Ks6qti79Ym4yCh+1HUBZqM6qSE86emE/KN978gPTlNGxX7OUTywybdhJsX1tyPNwZYuQblkdfdH6fIotuA/D9LEjfvto59JN135EyUxjhT+u5PJ0gjHVZXni2I9DolITVLjRxeJrOhlc2JOwbXuTNHFT16e3lfQm1rqDYPYfhoY+n+RQILRGVVjWYP8hEzJwgOpP3rdwVHLsa4VJNq1xcxB+yrFzqiLNYm7e8VdUvsqjwTqAau6KDAorEGOMPtLTpZKza4WK9EjPxkqNPTy/p1s3ioYB74BMOPiIpTjG8moMX/ufvOaellLKQqhRiVOl9PlCYO66+atI8zLjnl3UPyMTYiE1b4+2BlP4kGlqO3qnX2Rn68HSvGv0IPAJLr6jk5W9rFbTT/0LdimXlXwK4tOTmpfEcfGM53md/QzlSHsEu10ej8x99KyHpQyMDjbFckS3pe+OdnQIW+Tq75VMswjxKdlbuT5de/2/KoaBn5WymJO3pk4dF+jG84IIL/rSQLjb+vyeFVeYEId5zkrpTqoVUpCTMy+YQBx0JCBMEy7vSofHAjw7ny++GsBEnrgbb0V6zufuzd8reR2k91YaN9/M9apLeryE19YDGCSXNScd6yrnhQOH/68eT4J8nlB15h4VRc9O/qq3u2lPA1I54c7vNk58b6I+IOMOHOQvtsC1xdi9odsUQYo2POthn6ipKMg5B5wuD4wEV4SEzerTiTVOrLbWFoBYxx/Oc5sFUPz9JAKEzBRaR+lxz583nJj+XRelC3gaIUOsbfoS9j3hDWFn4sW1VXCqJC37Qn/oYiEH3OfPlTQa5FM3+v1tBTUTDqHCKDWl0pk7jQTKR3faK7YWGqP1kjJkKVNk2wb1HsAILT6nzgmogTCPBEET6jZHA38TqbqHyh8owCkVtXzLZqUs1ewvhYiujLTCInrU4scx+ug7TkJNhCjFt8A5NXqY
 iLVBrm2h
 tEpv6gN2g7WRnnbbggVTOYufwLOck6OkK/09VP3m8+ckRkLujT271RBRCcRRKbJ+9mUktCuZo3260nqwp1JjtUlNn4cMj9D7tEaRbEZHDfoBacRgmIzlFTDSIfinDFyGZk5/3voZY6VY2Hfp9ZZaL9E6CQZXheKBvmzx/edBLjA5hOzjRo8kuzwkqtJWgFYLFyaRNF7HQ8+2AwkNzd4jeohv26PDLmPS3tzh89fSKGhXtLrfMD2vpd0pxVnjOF/7IzaiZOjxS7HL4pqHHldrm1gBZ8G9/Cya/UafVARFohC2sRnxTL4+9gnVdE2/w+SKDP95MOAxac5r6wIZXpgE1wQHjvW21+7w6Q0ANmiphG105La00DNfzji0vww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 14, 2026 at 9:52 AM UTC, Brendan Jackman wrote:
> On Mon Jul 13, 2026 at 4:15 PM UTC, Harry Yoo wrote:
>>
>>
>> On 7/13/26 11:31 PM, Brendan Jackman wrote:
>>> On Sat Jul 11, 2026 at 12:03 AM UTC, Andrew Morton wrote:
>>>> On Fri, 10 Jul 2026 10:42:20 +0000 Brendan Jackman <jackmanb@google.co=
m> wrote:
>>>>
>>>>> As noted in can_spin_trylock(), using this is unsafe in this context.
>>>>> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
>>>>> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc si=
de
>>>>> but missed the free side.
>>
>> Ouch, do we allow alloc_pages() -> free_pages_nolock()?
>> Didn't notice.
>
> We don't explicitly disallow that but I'd say it's "forbidden by
> default"...

Oh, the BPF arena code does it.

>>>> Also, Sashiko might have found yet more pre-existing issues:
>>>> 	https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-af=
fb5fe5ed00@google.com
>>>=20
>>> There are 2 cases here:
>>>=20
>>> 1: !pcp_allowed_order() -> This is forbidden by alloc_order_allowed(),
>>>    quite a bad miss from Sashiko IMO.
>>
>> Hmm but alloc_order_allowed() would return true for !pcp_allowed_order()
>> when spinning is allowed, then pages can be freed via
>> free_pages_nolock()?

So yeah Sashiko was right after all.


