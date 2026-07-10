Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48FA6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 23:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB676B00A3; Fri, 10 Jul 2026 19:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C866B00A4; Fri, 10 Jul 2026 19:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B92B6B00A6; Fri, 10 Jul 2026 19:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02C366B00A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:27:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DB75C3EB7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:27:33 +0000 (UTC)
X-FDA: 84974455986.02.7F0C127
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AE85F160003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:27:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Atl/XXzr";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783726051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WW3ZS6ffce0sFRQ3Pe5X7FcCWqUZEchChIpBrhH1dk4=;
	b=cdi3D1WmNvUSHZMDUH/JvhnnDazvxxwKB5J/DLLFH9rI1EfXncHkEel+s/xhzp3+30X4rL
	UhVlsqMWkFftUFCoq+qINQQgg0KUpt7qRZ7/BFdRTSTQA8w1674VBnbESoqptpQRFGYNwd
	UPttCGyKI7Dn0Tg8oXJGvBT3l4Ssgr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783726051;
	b=qFZy12aaGMV5H1ALtffhi0tIArSz2xo6Ou08V9HteyNbjh9B8vNyrhu+eCbLBi8XUi9Z0T
	Z2mbaMKnVCMKCqXzZGEvqx7APeooEJljwmxaGucFJcsjgwFq3ZF0JmYn20UCvX5fz3zjU1
	3eGNOHwM+4+4tl/LBE6deLSfo9v9MYs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Atl/XXzr";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54969405FB;
	Fri, 10 Jul 2026 23:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD63C1F000E9;
	Fri, 10 Jul 2026 23:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783726050;
	bh=WW3ZS6ffce0sFRQ3Pe5X7FcCWqUZEchChIpBrhH1dk4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Atl/XXzr294k8x5ztlMu+IFnzM/22TJJazOY92sXMG0+TnASZdphKkHjgJg2yzedF
	 NooFvYwx5HXEcqz86HfeKdptMe9FrfbWysVhYdQGCYLr4TAWA/1D5TXbkdrWfo/qYN
	 Dr0dZhI+jkbGU+0HhWw+kqBEIX6qtVldq83H7GtA=
Date: Fri, 10 Jul 2026 16:27:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Petr Tesarik <ptesarik@suse.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] mm: let node_reclaim() return the number of
 pages reclaimed
Message-Id: <20260710162729.b340eac3c83d4c3e0369558b@linux-foundation.org>
In-Reply-To: <20260710152320.2024283-1-ptesarik@suse.com>
References: <20260710152320.2024283-1-ptesarik@suse.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE85F160003
X-Stat-Signature: bjo3iajf1deezj7wis4hht14rqcjd1s1
X-HE-Tag: 1783726051-464371
X-HE-Meta: U2FsdGVkX18iENTTnkzJWmk9WBvwZodIKELDxQ9WsPkj8GbIsF5TKLwZiNMJtk6z8lVaxrosOkKWrWBnbJjak8XlmHmQMWXD40+Xek5rY2MUzM81awqanEl0+sFJ2GmtBA2GSS+OESQJeJ9tHmgCJzkgfnAKhkve6VLDtfrb9qXpyAtapzM6EEJQ8ZfjU7VIeNc3jumPMS/m2Fui+ZT1JJDmG3cnEGgDdWakxwaE/377RmQL+X/lEd1OKAKuxO4GT+ouUYwzEwa28YOW9VBssr2NPH7sNM95joUmAH/hZEZQyGwphqpmxJaAV6yMDIkQc5MQHnvZv74t0v6c7c6W0rKRFq3gWM2Tjm9z18FXg5RVEHpJZxMF8pJhklr7qEakb0zvwhsiodcXCgbMEyL4rzDMGpOXfN8uDiHC4b8na5frotdYMy2t1PfQmykp6sp6pDp3m2cLXOJS9vMucHL7CQ5G1a4yDqj/iUgArKA6KVCVS1Pq22XMEvksEsQH5svkPck+SdERzX++hTuhlFFgmQrzV9MTEVfaNKL9F4j+qJQvTqPLD8Wqw4PSKzIfauIEb5G+LgMzh2fTZqT6b8YJf3AfxpdwDpXJAz+A3+Bmtowl9zzbZvTBUMtYTfFsRGVnU2V0zECcQzylj2FoqXXYj9mJ8K3y5UhcOVwTLUvoCsqsia5wB6BiAkTTezQGeaxmGqS45IN/NJZ7tVPqzjdrZsNIo6v9TmNkYCEqBng8LdOwWoYfLKe0jJ8h2L6qlgQOMiuQ2FuFxXAMHRvf+h5gF0VPIO8SoxSk73i78BiA69fIlC8l4Ut2DWamfXkEwfk4xthNsGWjkflkvliE33wRX+/6Qk1vu6DGTb0+GoplRnueUQgCIgT65YpI2juftoSMm3r3DL8MA53DUPhJFgpbDwTDqY8oWwyihvQx7OmAGsnfnqsQLTWTMqwTO9AqiJ8kFvfzD3NtFRcSBXiyMnA
 4lz0ilHk
 mIIzf6xk7XeKcJLZh4lRvbnq2ciqdvO85mkhHovFW8LEIV3gYZzQDaIx3HR7+5SDaE5i3F7bdFjTRfxVvm+jmAvedZsBwoBvbkLl/BxzaqpmzafB4YcYMidKk2JQzQ8t3Co98bNO4oH1uiV8phXgPbwu27SSxr1kPFaTG6auSpBhSwnQjJ1L/n77PsVRHmG8u2f+LpAv2tI6Y9Mis1WOJw62uLa46BrQOCRSv2m1yvMYi5G7/ZFrRfPOcUB0kwrxgSps6vZn5j0HSq4DhHCghHDifmAyeo3yJO6QCZ/0H9MR6awlfP54h/srbpEcesKVgBM2V+UpCidUd59DVnyC6dRc94o8qPEBk8V5CVBuzGK61fVYPkk7jD4OKoymcCqaab2632Mm780laBpfF75ojamVZ+XCSx63/IIQ/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 17:23:20 +0200 Petr Tesarik <ptesarik@suse.com> wrote:

> There is only one caller, get_page_from_freelist(), and it does not make
> any use of the reason for skipping the reclaim, nor does it make any
> distinction between a full and partially successful reclaim.
> 
> Therefore, node_reclaim() can simply return the number of pages that have
> been reclaimed, same as __node_reclaim(), and the NODE_RECLAIM_xxx macros
> can be removed.

AI review
(https://sashiko.dev/#/patchset/20260710152320.2024283-1-ptesarik@suse.com)
points out that the macros weren't actually removed.  Perhaps you meant
"use of the macros can be removed" or similar.  But it does seem they
can indeed be removed:

hp2:/usr/src/25> grep NODE_RECLAIM_ mm/*.[ch] include/linux/*.h
mm/internal.h:#define NODE_RECLAIM_NOSCAN	-2
mm/internal.h:#define NODE_RECLAIM_FULL	-1
mm/internal.h:#define NODE_RECLAIM_SOME	0
mm/internal.h:#define NODE_RECLAIM_SUCCESS	1
mm/vmscan.c:#define NODE_RECLAIM_PRIORITY 4
mm/vmscan.c:		.priority = NODE_RECLAIM_PRIORITY,

(NODE_RECLAIM_PRIORITY looks like it belongs, but it's an unrelated
thing).

Let's not do an immediate resend to address this please - let's give
reviewers a week or so to do their thing.


