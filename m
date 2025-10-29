Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC5BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 21:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D78BA8E010A; Wed, 29 Oct 2025 17:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50CB8E0106; Wed, 29 Oct 2025 17:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D868E010A; Wed, 29 Oct 2025 17:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B94BA8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:45:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77A5012B433
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:45:50 +0000 (UTC)
X-FDA: 84052484460.09.C760CC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D99352000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:45:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F6PhZS4h;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761774348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMf5xaGXNZGIZuQlhNCFNg7pRdYHbw7rIqQzQ7vqHx0=;
	b=57a15GzG2gokwg3UYdlJPcGjp+yexKlPN35OYF8TnU0QOcHhCvNaE5VwEYELA2zdb8biGN
	FF4lmtS4KJlJHCeFevjQJ9d4WHSTd4LKX3OFJZTGrB5uh5Za1ffZ8LjATcyoDZpUYMsYIb
	s2R7PCaYLM3Ty8u4coJuC5W7WdjO96g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F6PhZS4h;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761774348; a=rsa-sha256;
	cv=none;
	b=JVn0SziJWZKaYxjjXok5wXgGtafFbtwgsvDWxoi7NbRe0roKwTN4A9T0vQzyReOf23n09Z
	DLzfToKKIkkyA1Giuv+ieM2z0N8bTiB9aqeq7tDme6Gct/vJ4pN4FtP0UPYLFv/+sd2d0B
	9EJ+cdEoS2ochnYQq72z381siQhpBPE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 348D1601D2;
	Wed, 29 Oct 2025 21:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD00C4CEF7;
	Wed, 29 Oct 2025 21:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761774347;
	bh=6N/PDZDuG63mYbRBd/5edZFLahJKbOcfDaWvIWC0rbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F6PhZS4h4d4Jm70pbTD/Zfvh2zE6PPSle2THnyGlLX/hJnApn3A30pp1+KONryzHU
	 G4vMy07i+dWaiV9Unw3bEjkSfMgDiy7LXqA56qdwBWgka3hIyIVGQSWk2MePRwBx7j
	 by9zJmb6zmYL8BLUqVOcMrzFgDmqwdvyZ1uVttNzM1bmaEqefuWoie+ML0wRMrF2Jp
	 NH/vu3oNwHKj8LWnuB3SzolEAi4kJY1f79MhEFq0AzJWrGWfNysT9A4kxC/XDJa1LL
	 aZiOGqNN/KPM4BvnP8NrgOWRpUngIuHXzBzvQvMMTuCV6W7F+r9DhOSQfDBE3vgeK3
	 BYINY2jsETllQ==
Date: Wed, 29 Oct 2025 11:45:46 -1000
From: Tejun Heo <tj@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
Message-ID: <aQKLCuX5v5aO3fDa@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
 <aQJZgd8-xXpK-Af8@slm.duckdns.org>
 <87ldkte9pr.fsf@linux.dev>
 <aQJ61wC0mvzc7qIU@slm.duckdns.org>
 <CAHzjS_vhk6RM6pkfKNrDNeEC=eObofL=f9FZ51tyqrFFz9tn1w@mail.gmail.com>
 <aQKGrqAf2iKZQD_q@slm.duckdns.org>
 <CAHzjS_tEYA2oboJ-SPq5wJLJTpJDNiA2Fk1wMRgyEpH0gjZRJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHzjS_tEYA2oboJ-SPq5wJLJTpJDNiA2Fk1wMRgyEpH0gjZRJw@mail.gmail.com>
X-Rspamd-Queue-Id: D99352000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8kicc76yxenpaqwxw4fkdsjx6iu7zn18
X-HE-Tag: 1761774348-876078
X-HE-Meta: U2FsdGVkX182/ezQ7AiM/jjpb/HfqWHVlWkXpM0sR50plVYCnbohXGJ5TNJiyeFzBiyOQ3lE80wqb+aeTM6zrnByG5QcZL9xN4010u68Z+pOsElOYoSbf7sWD5bb/eQJC0IWaaS6r0xMgaElx87/j+EerMvbSHSDkApjEZTsOjiUpn+STbbUopOw5sVTh2PPCIPbN/HbmdDAbbLTNrj1yuC7AsjBaYQKCqYmhSMS4XHTMAsobAfCTHGJlVG7d+CMZwMD1AEwa0qq7NYStD7wWsXYS/irL77sqkAGvtXpKsbaYxfO6TaGCY5PTWBubJpiZ7zfgixxJDwznaXgrPd1aeVZ59+EyB445S2yGJRbzgeP11tXFEkrkgi2+WwL97b9lzUYrEOK2O8A69h5pz/ezWTS0wX5mZQgWS4xbD1s4GHBPm/RsNdtdGUFT2oAuglP0n8fTpkgIQAJ4/8Z+hrjzb3lB7XonBvOAIifsXbZf0V4bSCDuuQKedpk+RqGBbLleFuhhGnfUDP9O6KUdKbCu8hhcdGGOmHycDCq5Pj0o0+SiqVoPPlrZ2vQaLg2b3dHvNv7eK0/eEytLPKZJOhE/iYu/gRKWRKNH/Tg/WnDoZbEnA7jVijr+3XNYxAFwarG0eQ9pGnheK5HWj7cPs6lLsQtrFTCLbtsWt+qt3uEdUrVft6M+Hgp5B9Kjv0xC8YFloxdiGUS5UWmvVUnFIMIrVYTFRylHY7Nfe+yWIwaUfEjIaDfxqgS1/UXD0X2XgFMFKrXNybWKAzO/DXvaq2u5JOPg2X2pzdAg1DC7SlvPzqxEjUtJ/QymRZjhdMjIxBaeOPk6tORkDCgJQW90bJoJ3iJOgVM3QePp13sMY44dzgniSFJDv/6tzHsJ8zi2xn7i6nqRDbyToqVmcTAylCKwZHOpfPKYu5+V1UMbYGN4nfWYM6VUSA6MFbE0R+6V9Zgw6fRTk/k+M+3pCCLGvo
 ZYZC4Euq
 YUGAK0g34F4Yz57eOiRNxEn49k7zglzutcBpboC9JfDBE+xoohw8+wWTLCh3M7Fam7A7NcWSwrRvM6zaAR/qUKyS44UGn7dLarxEZG+YQ5leheYNOXiZ/MLCIJRJpf90LCoZev9b+3zEVbvUAxhmsP9RICzwq8DbjWiikLF+OTgomJNjhcuw1FXUiFg6UlA8EpH0tWvalrMIMJm1eeWSO3qWvqrVHoK3pVNWUVvGc4CbYLHsQ8oTOLzTme9ZE44zx0eCg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Oct 29, 2025 at 02:37:38PM -0700, Song Liu wrote:
> On Wed, Oct 29, 2025 at 2:27 PM Tejun Heo <tj@kernel.org> wrote:
> > Doesn't that assume that the programs are more or less stateless? Wouldn't
> > oom handlers want to track historical information, running averages, which
> > process expanded the most and so on?
> 
> Yes, this does mean the program needs to store data in some BPF maps.
> Do we have concern with the performance of BPF maps?

It's just a lot more awkward to do and I have a difficult time thinking up
reasons why one would need to do that. If you attach a single struct_ops
instance to one cgroup, you can use global variables, maps, arena to track
what's happening with the cgroup. If you share the same struct_ops across
multiple cgroups, each operation has to scope per-cgroup states. I can see
how that probably makes sense for sockets but cgroups aren't sockets. There
are a lot fewer cgroups and they are organized in a tree.

Thanks.

-- 
tejun

