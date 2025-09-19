Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DCD3CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 20:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660278E0006; Fri, 19 Sep 2025 16:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610AD8E0001; Fri, 19 Sep 2025 16:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF8A8E0006; Fri, 19 Sep 2025 16:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 388588E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 16:06:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D0BB61407E8
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:06:48 +0000 (UTC)
X-FDA: 83907082896.28.95203CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1F296A0010
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 20:06:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wchAFv1v;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758312407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oU6IPcrhdCatbty9M1JygZaaWUYhUxIhORgdHeVOnGI=;
	b=LcnsA5izAO0iDxYEn4szuiRRqV4qa3/xKDFV11qpYhrAReNC887sHU3Ea84BNW0JxrhlWF
	LgpPMu7GLvR9cbOfWJxy2tORI48y0a3+gKpW3WgNF/YJb+x7UsMSwthD1mzqpW7xs9YtHc
	5B55pXJ0HaTP6uLgbjOH+KVZFALmnLs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wchAFv1v;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758312407; a=rsa-sha256;
	cv=none;
	b=TmZoQpb0BswPRN7KvPyH8oAT6COPGJ0bSeGHSOSnOYN5mVZMLsQXvv0fMUeCJzZOWQd3GP
	l0R6N21XTJsbOosx9nQnO6veTAoNbXfRZG2Hd42O5D6+ShhjcQl3uner6d1N/vQO3d9H3M
	2OPMVaKhRIgTtUSGaZDo/Eq8n5fCLYg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1211B6013A;
	Fri, 19 Sep 2025 20:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FE7C4CEF0;
	Fri, 19 Sep 2025 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758312405;
	bh=oU6IPcrhdCatbty9M1JygZaaWUYhUxIhORgdHeVOnGI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wchAFv1vt+vhyzhItwupGq5aAmioJFZOe/0Zmxv1rki1kUWHXg5byUVLtajCkTXqV
	 FFhvI35l7xkd5V0xk5e922SIgSo1jHmwwuZhp3BL9Kong4YYq5baiutPIMUcptEuri
	 KJMdlDmGad89OkoV8v1l5RhnXnTm0OAki1Uh29ac=
Date: Fri, 19 Sep 2025 13:06:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>, Kiryl
 Shutsemau <kirill@shutemov.name>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Brendan Jackman <jackmanb@google.com>, David
 Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka
 <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH 0/4] mm/page_alloc: Batch callers of free_pcppages_bulk
Message-Id: <20250919130644.f3a4afdf0c2e51bbec59b6e0@linux-foundation.org>
In-Reply-To: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
References: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sdyy9dk17haqexku6atihq9zsri8khts
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F296A0010
X-Rspamd-Server: rspam04
X-HE-Tag: 1758312406-344833
X-HE-Meta: U2FsdGVkX18k/LeZKJePVrbwYPbnXBbWI8KuWHaQ3aTwHU6TdgRfOq3JWoxE+82e4GUX4nulTmP8MopCEBS00E1IAU//TAj4XIP3V+1xhJQ/M+pzAud9XqlSiL7tUq5cTgLOQwnriCiee0dO53mGdsXy/LVSvMLWk7YhHJcO22o16xeuzfEG3KJr45U8l/6clKD6hpMMS3abti4qYddvsq5elBoAJBVLaw4PEpq5nb5nSlo7BsBreTdEuUEpO3Jogrbimq5qI6RnIyh9ZnjmqQCbkbNC+hT1xvoCY7oQyVwTL3GElSBC72R195uRnDhJbUM/yac5Hpv2m4kDqehKjJxyN7IBVFTVmLj/ANxHGOiVwm2b8Dz2btadoOc7JcMxOpQnPVSiqX/J38maCS7EF+zmJEmKnkdGsxmHF3wezS1lUQQ/UUx5brcGoj+KXbJjYf1tuDs4OXU4nwQN6bgPc91M7N27ZlNJcO48Tbi+Hu8OtDXd7Bx7KRGFnnwrR4otI80oWnfJHVuZ/2EySkLBiuVqQarvk1BefT1nQjzAqCjZx41zVDLUVafns+2gMN6biyvUegeqBkqoMCVwYRvmslQTOiAT5v80r4CZPV4E/RWk/4ibSMSMW5d0a6m8XiEDGe5T8WJrTb1/dZWpaB4ROslppwpUObO5rQYURWm3gd6/XJC+eawEzK3XN42tsmghziBaGm7B3B04PE8bW6G7Z0DjF7I1pRh3DTblFHXCATEZlpyGQ/M9XwRHgineT8wp6RWdw9snCMWQkVMKqYIsot7w7EQ58gcZfYxTHmuyLlgRQN85UqhYSSa4yqVC3ujxVZrfqAUKHsHq68eqjFL9HV15ylPgaCUNmw9hfMHEYGIc13u3hFLC6tUOltGkjpy6hZg3Jt9xyubXtBrnrJy1yBVIjVZYBy+peQStcU4C1IRncUKeXGNdllh2xUlA7ovtwqaDNTxyBdDoZV6JLFA
 WvSB47q2
 M9wLB3eVJAXclKlemJgPKRb73IcIMGvd3wdxssmHX01TgUQUUADDlDS72u+SXj/1zN6UsK/DP3LerxKxCMLJ0apq7fzB2thoHCx1TSAIgIlwicgZ95bq6DHGK1Ay+rwb2dh1z16wn0nMqsU0EUMCTMmcNkCEEMbo872+xYDEKHqkea5ml89EeAvUR4Iyo2MtbfR9y96bSx/CUeJHzccc2eQe7fzAs0OWZPNgL1ha2k6oV6dHjQffYVxdLuCuNAmABjPj06TvCep2/pk1bx5xLjP29tq3k+HlbSPT2hayGu96LU4Z5X2l/cTnoWO4S57Z/GAi73PAsE70cZCdH0MD+XRMmumm3Y5tiq/kj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Sep 2025 12:52:18 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> While testing workloads with high sustained memory pressure on large machines
> (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> Further investigation showed that the lock in free_pcppages_bulk was being held
> for a long time, even being held while 2k+ pages were being freed [1].

What problems are caused by this, apart from a warning which can
presumably be suppressed in some fashion?

> This causes starvation in other processes for both the pcp and zone locks,
> which can lead to softlockups that cause the system to stall [2].

[2] doesn't describe such stalls.

>
> ...
>
> In our fleet, we have seen that performing batched lock freeing has led to
> significantly lower rates of softlockups, while incurring relatively small
> regressions (relative to the workload and relative to the variation).

"our" == Meta?



