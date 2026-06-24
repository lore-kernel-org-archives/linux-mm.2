Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F353CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56AD56B0005; Wed, 24 Jun 2026 12:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B226B00A0; Wed, 24 Jun 2026 12:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4099B6B00A1; Wed, 24 Jun 2026 12:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7DD6B0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:13:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E3E2A02FC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:13:33 +0000 (UTC)
X-FDA: 84915301506.26.0C55D0B
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id A64AB20007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:13:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fa3J2SOh;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782317612;
	b=zPEIQTy7SJQOnWK+bMDQhJBxkSL/3JD8tjjZ4HhhtaQ/xadcoiFrNMWarYK1z3n/yRNwCZ
	dLJ4v5KWcl6AB7pJ452yCWTxh+UbCtp1PiexLzdQa7wJMDfGeRxbNraMq8X+7tcstsyz18
	TraA+0GSWyb5+BBVZUSFy9E7C2ZmV7g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782317612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9aVF+G3OXPyZ/vcAkXPeyAs2FuDRWvwGyzee9qXB9c=;
	b=fDhXLwOVh74szOiGAeOdnmCCmuq2pwfzvHeqCBKQbmUpAWR1doLEArkdEW14eiTw+TeHBO
	ORCyIhA28A8kjKzHEsJkhcezVkE3+Qyw89KIXdnab2caWOXUGismHsZJv3aJQl/lc6Vuur
	B+70s7mItXmkqfCvi5xvVoA/RKUcM/0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fa3J2SOh;
	spf=pass (imf03.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782317609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m9aVF+G3OXPyZ/vcAkXPeyAs2FuDRWvwGyzee9qXB9c=;
	b=fa3J2SOhvillti8Liv5ZP1niw3sCiypVHde+AiPnhIfoN4KtMBponRsJ4fCdvD4pujO0m2
	ebvOAK1vccQyOHILjsjOpsvJAhyrY7vw5BUfQ9hzM5FDRyqDH4v4Cj0zl+XPIrcg7yjeF5
	jTaznLi8uMLZFrFPe/3m2rvQr5i7Yvs=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Jun 2026 16:13:13 +0000
Message-Id: <DJHEUV09YHKE.1YVJWE38NM8U5@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, "Hao Li" <hao.li@linux.dev>, "Christoph
 Lameter" <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>,
 "Gregory Price" <gourry@gourry.net>, "Alexei Starovoitov" <ast@kernel.org>,
 "Matthew Wilcox" <willy@infradead.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH v2 02/13] mm/page_alloc: some renames to clarify
 alloc_flags scopes
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Suren Baghdasaryan" <surenb@google.com>, "Brendan Jackman"
 <jackmanb@google.com>
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-2-31f31367d420@google.com>
 <CAJuCfpGagFf4RaCNJqu4Y1oqOXXOWSkP1UGuT9LA-9EbDN4Njw@mail.gmail.com>
In-Reply-To: <CAJuCfpGagFf4RaCNJqu4Y1oqOXXOWSkP1UGuT9LA-9EbDN4Njw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A64AB20007
X-Stat-Signature: 5qacssz4h5rf4998zxetq89kdbheor8d
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782317611-747663
X-HE-Meta: U2FsdGVkX18J/lXkDCXAX6OzhJf+fP5hvecccHBKZyLK5vTsNezJAwf8xja3vW+2oNerhHOrCbaVBxz8uwHMZo7w2+2KitBh6POxNRYDrJtjG8MY2ijSyJG9rfjBBdaoekiVh9MojnXhLE9AimKlfb8723pZLwrIYJXrDv8e1pXrjlCtiBJkZghYOzIDTiGzJ2U7Y1YIB7wZ8fX7vEXnwfyxiowsrqonvyzrQSiARaaduJFTXM9eEeSaf2B/48S58IEj0KpXWOGuEfjA30xypdwRCE6bLUxmz+6yqan/rlQ7dXIhwswFQcadWejaRNa7hXWsJMw61j6PW2Kq0Pa3KndBz3pUtrAhs+s0ZsO1j2b9BPheTKT8MMl9uT7RNUpgiAfuSR6IYi+pHSfwlqZwoI0r4EMek8SsAhOW1smLZJQrBd2nJKLrlOcuyd6sBQdC25KC9ThEhGhHadQXTbHoN5zBVGhSSnc2juxyZxf7rhMhLmouKNAvDVZlSt+4CEWtMZ2h2QphIuYnaiSZaDxbMxDUuf6Ft1vGMouT6qryr6oa6WeILxUawDglTLy6q9cyrZxnHuoHiDahOwOeEylw2t3P+czrSFOQQ2m24BQ3j0gU0ftE9SdWiISzurfk+7uzCcanTP0vTHGF64Pb8udCR9tMkTbiTr1lmYadf6d3kxq7Qx4N3UQIqpRXQD00DggNcvFrwH+zg4B9jVJL84F9eLReYGrKBkRUqjasV0EFIkXXr2ER1roWscswc2BtzerjhVKotEgY6wGtbmGKPbmji+icZuBUYgkhmoXXBRAAKHPhhkyoCPNQEXGxvCfJVqoZlpTbKS7XD+fxKqBNK6b92qtomg6AdzqH9ZIiEF4KFZUD1eafhWjVE8MWjtKnTRnqBERNWmJ2ch97zYfI4EZqIEE22emwpL+83K8Qc04qEDOSPqALFdjWQGerBQMqN7a4CtKDScMxpVH1jNG1npy
 0wOdSo+n
 OFNNdO7P7T7vv5NgVNPHnbSAPyPy/T6fPhVlpb9o7ksRxLN9WtRoYqr4dQBSQPoHFXeABxRXY2llKFa1SAm9v6gpmz0vxUxybPYRcnD9icj3h5w85obA2SBlraMC6tmWgG9FYyyRmhIEQyNimC4Kjtd/FMW9Fy4miATY6RgDokoCytCwh796akTskkYkTekQWyQAmuHUYWFEG7b5nWgLOs8/uDInxZGXUh1WT60mm55XGA4T5qJEbHnxyV/baNO/Ddt4pRDCQzXQkV5+xLtjdtKLHx0ZHsNlrOPk8D4gY2eS2wnaEiD+wLp0trCxIbDkyGD8qBR1IzYsbjhNXJw1WfuD1V2pE+7nJnadE1PL04k4u2Xtb5bIuO5JWCKwuyIrxBhuv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 24, 2026 at 3:03 PM UTC, Suren Baghdasaryan wrote:
> On Mon, Jun 22, 2026 at 3:01=E2=80=AFAM Brendan Jackman <jackmanb@google.=
com> wrote:
>>
>> It's pretty confusing that:
>>
>> - The slowpath and fastpath have a totally distinct set of alloc_flags.
>>
>> - gfp_to_alloc_flags() sounds generic but it only influences the
>>   slowpath.
>>
>> - prepare_alloc_pages() is generic in that it sets up the
>>   alloc_context, but the alloc_flags it generates are only used for the
>>   fastpath.
>
> I understand you want to clarify the usage but this particular point
> seems to be an implementation detail. IOW, if tomorrow
> __alloc_frozen_pages_noprof() is changed to use alloc_flags when
> calling __alloc_pages_slowpath(), would we be renaming it back? So, I
> would suggest keeping alloc_flags as is in prepare_alloc_pages()=20

I would say yes, we should rename it even though it might mean having to
rename it back later. IMO it's very useful to make it clear to the
reader that they also need to look elsewhere to find the slowpath flag
logic, without them having to notice this rather odd detail of
__alloc_frozen_pages_noprof().

But, yeah I guess prepare_alloc_pages() doesn't really care that its
caller is only using the result for the fastpath so I could see the
rationale for keeping the arg as alloc_flags...

> and its callers.=20

...  but for it's caller I really do think the rename is necessary and
doesn't really have any downside? Especially once alloc_context gets an
alloc_flags field as it does later in the series.

> The rest LGTM.

Thanks as always, I appreciate the review.

