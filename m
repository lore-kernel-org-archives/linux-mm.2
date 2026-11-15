Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AA6606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 13:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rh7ng2gX
Received: by kanga.kvack.org (Postfix)
	id 1EE9A6B05B0; Sun, 15 Nov 2026 08:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FAD6B05B1; Sun, 15 Nov 2026 08:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5A66B05B2; Sun, 15 Nov 2026 08:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D76A36B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:29:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D85140729
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:29:24 +0000 (UTC)
X-FDA: 85437435048.06.32F1F36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B66D040003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:29:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rh7ng2gX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794749362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haKBzBVUyeOg2UlQIK/o1YREIWI7nnzJdfaBt7YGCHc=;
	b=7yOdL5VxVB1TuryV2x6ka+IsCnsM3WF/Nh8lb+3Hu6zdfs5zTU5VSygMXdj8YcM97FozbR
	IOqUmWgtpvKqICz5UyyEJoMANN3Qmf/MBbpMu8g5fZv6ag3IZ4cTin2KRpdKdPrEGh1aYj
	1C60U9ylUR9q89BQpJCNOQK0zvYQelE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794749362;
	b=bpw+8sJJUIgrj/cT0XUhh+BfS+JxJC/VuVrOyVfuQJ03VJa9e8KLdnOhVOgFUfQNpxv1r8
	n1RbiT9vE5hvnbOn2pVOS2MUfoYwGUbBmUSKuW73a2/DIDHYBk2x+UdBMUAoN7OfEac2WW
	Gzh9JqaxlByk7mqk24evOV5yc/7si24=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rh7ng2gX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6CDE613F3;
	Sun, 15 Nov 2026 13:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DA81F000C4;
	Sun, 15 Nov 2026 13:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794749361;
	bh=haKBzBVUyeOg2UlQIK/o1YREIWI7nnzJdfaBt7YGCHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rh7ng2gX6LGpoL4B/eKnAUvR9+Qv1MJLctQkDigGNoNU5XZnIkVlhmWoJnBq9GiYj
	 rb3CkFCe1w7gNhzayJsmuSxkMrtkzWcytamvMuKwOvLx98sxzcSO/5VWGTYRrEy0mq
	 +a22u9vhD+cvawrYoEH+Bjm9p3+5bK3AAytIxCN5h793gIJpVUiHF+wiqwIX2HUPny
	 wjoag71LTkhTcaj6jPZrVW/cBMaacW2D8TeOYX/NvIvc48eGd6KIGI5VG/o8Tb3Mr8
	 HfcmhVfQSohjeEISG2VM+bJuFKpFOcvCSyURQ71UC34SBtCBi9gMjFZE9N2+4scqeB
	 QRC7Op36HeMAQ==
Date: Sun, 15 Nov 2026 13:29:12 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	Dennis Zhou <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 10/13] mm/migrate_device: refuse to migrate shadow stacks
Message-ID: <avmzn53l8fdCQsAP@lucifer>
References: <avYJ-CxBEpdO1Wmu@gremlin>
 <816E22E2-C7DD-4DD1-AAC9-F51F4D1ED71C@linux.dev>
 <avdveCV9uW1zwXXd@gremlin>
 <87jymg5nw4.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jymg5nw4.fsf@kernel.org>
X-Stat-Signature: her1tmbuqzaf6at7o6mt8kgtdztm7pgx
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B66D040003
X-HE-Tag: 1794749362-713501
X-HE-Meta: U2FsdGVkX1+ocN6RYQzz4a+JjR4mzkRc1VdKj+98C+KKmYN5YCh/UXy6L7Uc5JWEiXeCujZn/tJNxiXNRQy+E44qxWihMO0x2zhzhTJt1bq8X3y0RaSnQfeA7SPVaTjt2f3R5pv0H5OCo/XVKI7kWOMrCvBExefwgFeFJwBvVT4qAD98ehMrzMP0o2W7zBngqeIB3lNO5s/TcK75r0eTMRe8jmxc1EF7JtMAVte/y2I5JMa5GVd/X/oM7lMqhyREeMzoO32t26gIrXYHuMJxVRYsmorNWPmLSxvTE7ub+lOSY4xNMW8pBnEPzZZ93O/RNGmRsoLObgIMq8UN9cQB1dlHD7Kz5Y+BvFoDtXJRJwXHrqmJgpgHLSBP61lR6dme2r2tEXkx1/ikNJ6R44k84RtblxaKHnfv2VoovxUbZBnyrpfI8Re3JU9YrS2QQlyoHhWq+QmcRr4uKgadesuf8NQKVSOZLchBUCYbkDUARLJqPFHPx0vUY/RxeDWyhXZ+QNzBasF0Ipi9MIcvm34jK+LBkV7Bbz/6eeUvlOKvoDZhizjCM8pVhthvyzcDLcsMbseSOtFItSSfn3GZjByTFz+Oc3fjciQ4LCJdNA2bqYZsMiUArPD+5OgBTfpJGUEUpsRY7eCLckOU6PaAihwlWxL+Rp6lxwI1zINNhGg3v7ceWd94Z5XwOOxBpMy7nxWv/YQVAqTIKOo87qddcdE7hGPH1Bt3DdFRiYPfAZQ+OTeinoIxJrpsjeu2FDyahrfn79SVfxHeWo2NbnqdFbvVAqSA+A7KwKSkcNRlekFnS8gk1M2NTQ5J3SjO7snLCkBvbe4jrLW9R2tvWOfBMR14uEEid7xkpRyPSKTGWRpjBc6tUCYOEoli/CxM2/sgx2kflBi8uv8HhRb4RHmlDSu4Kpoj3eOAvSxU/v+G8Trx/2rkjhyqoMEyHwWLF54gko7mr28orl7CtqqDUMU2AYS
 r1viPt7i
 5asHdCwvhvGGH34AA/x/s8RQDIGlfL2jHSWoTnin+IpnYlCfsLHtZ8fKrZ36Q4KTKdweNEqA/WY+rYB90hZdcrpY9R7udOstYfFdH9ugjUvVLVP0wmqKqNLksi0GRqBac3tboXQyzD7ZVjk1uxLsZRrInvQiNukSgpHUwjwHSwEZ3KowgZhiFfOT6UR0PY2qU2KvUCJPS+kkeVI8hW5i5NxOnOoP1Pf/K5lcncaHWScXqWxBVxOkNH6mSJi4GxB5iUsgSIlpaT01JW34SAidrMSpse7UM9+EeasozmfiuMqaWpjh478oDkRsEYdaXzeuq5gJg7PIi8/zqsNOxr/09+4wJTVzqpoI5S3EJUWLpDtR19Yyzrge8SWRTvZB3q8ocKcTC04vXU+wn5BUL7M3A7HjnAfp/HhtHPk7h4V8i5JMYA4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 03:10:03PM -0800, Roman Gushchin wrote:
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:
>
> > On Thu, Nov 12, 2026 at 02:53:44PM -0800, Roman Gushchin wrote:
> >> > On Nov 12, 2026, at 11:03 AM, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >> >
> >> > ﻿+cc Roman
> >> >
> >> > Roman - see below - I was under the impression mm was not supposed to receive
> >> > 'unrelated to this patch but' reports? Did something change?
> >>
> >> Yes, sashiko started reporting pre-existing bugs again, but in a better way:
> >> strictly once (per bug)
> >> only for the first non-rfc version
> >> somewhat related to the proposed patch
> >> not more than 1-2 per patch
> >> not exposing security-sensitive stuff this way
> >>
> >> Obviously the goal here it to increase the chances for the problem to be fixed.
> >> It’s global, not mm-specific.
> >
> > (Sorry only just saw this!)
> >
> > Ah, I thought it was an mm opt-out.
> >
> > In general they're spawning a lot of AI sloppers to go off and send ever
> > more fixes and causing ever longer days for us, it's quite a noticeable
> > impact unfortunately.
> >
> > And often they're duplicative of already-sent fixes so you can see the
> > conundrum with this :)
> >
> > So ideally we'd like a way to embargo these or have a maintainers-only view
> > of them etc. so we can figure out a way of reasonably getting to valid
> > cases.
>
> Disabled for mm. Maintainers-only view is available in the database.

Oh great thanks! Much appreciated :)

>
> Thanks

--
Cheers, Lorenzo

