Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2016E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QnXDe1Br
Received: by kanga.kvack.org (Postfix)
	id 4813D6B00EF; Wed, 18 Nov 2026 08:39:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431D36B05B0; Wed, 18 Nov 2026 08:39:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F8C6B05B4; Wed, 18 Nov 2026 08:39:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA9D6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:39:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A275F120742
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:39:45 +0000 (UTC)
X-FDA: 85448347530.28.F0A813B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10026180009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:39:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnXDe1Br;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795009184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H16wPM7V43qGhOUqYIC9Lq66inZTiW4pkuJdkCDBv0k=;
	b=0PUVjMJzPxKkiNKyViqfVRvh95SjgvIkHy3flTdGRniO4nQ0/vcEouPxArzr/nCCKYxR3S
	wiqsbm6lklzeBP3IT0mP6PAgweijBslRNqLLQoPJ+2azRfxQjLBADAHnykBCy2iFtLEEQS
	eIhIcFMudiBADqmZcuUaAHGCw8lfFac=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnXDe1Br;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795009184;
	b=Q+JODUA2KAY9jv7+feKV8MnQ3nDxNm7yTKYaJF1f/j5YqadnbOgTfWwWefCtcYHiLannmc
	Iv56KTgJGpnfBU5VrPrdwB756l7UHBqtL5TugFptMN/d5VUDnn6rdkM4tAJnIFqx2d68Vu
	AR64GIZeyii6bLc9t6GK3tNdSc49E3Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C75961CA8;
	Wed, 18 Nov 2026 13:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57A61F000C4;
	Wed, 18 Nov 2026 13:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795009183;
	bh=H16wPM7V43qGhOUqYIC9Lq66inZTiW4pkuJdkCDBv0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QnXDe1Brr0lrrc+WoVXWDQAuB6mqEFMBO+0+D9laEIhooYb5UkBJwdxFGdNoFKZ8o
	 WsN/4VSJX8Ukxv40UAWQeosgaBpENKCEoKAhEJU/n0HJDVG7RFGt5Tf+O6Qqk0oOjB
	 tUWVsP80MgMO5zLwbQe5JOvapb4ltLtoalyxyxnqfxQKI2Ncsk0gfqz5wwMgWAyR0R
	 wSEiN0O+h+OsCr45zE/AVP0h9V7vjw+iklvGxntQ/cwEjQ668fX+q7ZNvsAWAuCnbX
	 ByuKEzWtSQ71KctGcmmul6ypubbhZDF4k5uirUtO+pJuonoIRG+0CxaBJLCwoUTHn7
	 9DPdbMnx3vQEw==
Date: Wed, 18 Nov 2026 15:39:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shivank Garg <shivankg@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Luiz Capitulino <luizcap@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_ext: remove unused page_ext_iter_get()
Message-ID: <av2qmOfuu9QMny5o@kernel.org>
References: <20261117-unused-sym-page-ext-v2-1-900f4c3c6856@amd.com>
 <e745f91b-3312-47b9-965c-510bf0a0b7f7@kernel.org>
 <20261117111336.ee49c0d4722a042c071c68b0@linux-foundation.org>
 <5541ef01-f9c0-4ce1-b77a-5bb81c6cfdd4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5541ef01-f9c0-4ce1-b77a-5bb81c6cfdd4@kernel.org>
X-Rspamd-Queue-Id: 10026180009
X-Rspam-User: 
X-Stat-Signature: fc6a33btytb4m3yrq19bdt64a9wbea6o
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795009183-407142
X-HE-Meta: U2FsdGVkX1+3WiU0rYblnvq54juxYZRwP7fM0yIJZN75emTHFbB27xZqlb6BHmW+XbOcl54OJDmJkqzPVZJlj4JtXHPN36uptVr2MGXlKB/CHWqGTRAEoVVHvtPFLEWNRRaKaHDo1PVge9pKJDDq5t3miFBQqG+Acwvv/ghdEX9lBuV6AG9+gz7rlco8C7GIfMkbeWxK+u7Jb/XUyMcj+TiOEE+03eDzbgdzJWn2uavxVYgpWij+fccpFkfVPdcKxOL/BsOnUtF5Ihi+NF6q4680DjXfo3WwxWgXN2fh5swASwyGv2ppie4trHY06SB708wr+eJY4Y17EUPEvBz9jSDYWpCDEu06T4KvlCkS3bQ4BSFIcoIo6lSHKFqlJ5+9xZa0tnHpNQXuk+DdjSh9B0Tmq0X6nxZjMyfJuL1KgrG8xlvbzwtCzkgknD8amCiwTPg+y4xzSMkPgfvKNm4MquTx3vMQuAZCDdcXPtdXQfu4L2lvAiIE5UWqR0az6hTqM/r0k2bgDz8Hw+0PtF5eq+KCd4jR/Eu4yTLJQOSwv6FjU2tpJJU0scykWg2kxM1XAm41PbRAMuhVrExJPvVFsvraZTS+9kbk8quGDRg67vH4pcZ7oaWfhjkKqkOsPagZ5ArGwnOeaR1Ri8zL+bV6rSONt8NZ2mdznIxSV78K5I65IAYY3mrzpvXnUaK+cubjmD+kMc9zbiyr6QsNj/yRg3C/2mqX5UnyruOW+zXjbBN6THg2AvDWj/Ewwp3W6ycNpNmj/WfqUimgciBnLbtw1++n7D7ijlITE3gBKZNJF+cvkNJ5EuOXqvj+pXMxoYGgQageQqDZn1iWZEO/cSAg7rWSxcuNVQPOS8njZCB91GwIylT/DgOjovHCK+XVx98s63Ndj9Z5m3JawUOgn/706VfLIxWzrkAxuETR0retpn/YFrFko3LQxpVjuV8+i4m7x0WfKUiX3KI7yNH6+iS
 FO4BT4WM
 zQ56o6r69kmvxQpd7NSYv7oGO9amM6a4/JVfGlG/jD7vaPhkq/OdoKCaY+0DWhbmlfxVmnaDzQKD1jH77VRkN35Jjeot+AF+fxXNuSzNiwj4bIXYUnuYessiEsWSQVOWtjXoOdOLDMYMz3ch0Irv8yPyHfaHgEbzrfL8lbHr3s/NA55UObZvpob7ODjBZVoulezzKvZ5dGKwllLJQ0j3guuV4a0PFhxC+p9K7eiB531/DWbxhZkwTtDLZ31Tp1gBLJfNJ/9vdRJTXAcatZ7iryHQM6mAwuEMDtfwLvOZL5SPJvvYhGzybtAqio6t+5hKd0t0tdLRVeHtLYrNhmrpFInnwbfxBf7fn86EG/fBtX2sVFl7qJqpVJINwKCBbUt2TlxvRpOJPxJBdcqwtv2FfOWQQ6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:10:45AM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/17/26 20:13, Andrew Morton wrote:
> > On Tue, 17 Nov 2026 19:50:09 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> > 
> >> On 11/17/26 17:26, Shivank Garg wrote:
> >> > It was added in commit 9039b9096ea2 ("mm: page_ext: add an iteration API
> >> > for page extensions") but has never had a caller.
> >> > 
> >> > Signed-off-by: Shivank Garg <shivankg@amd.com>
> >> 
> >> Added to page_alloc.git for-next, thanks!
> > 
> > Thanks.  Helps.
> > 
> >> Hm page_ext.h should be added to the PAGE ALLOCATOR section. Wonder if
> >> Andrew's patches adding various missing bits included that too.
> > 
> > Nope.  I'll add the below.
> > 
> > A few things under mm/ include page_ext.h so perhaps more mentions are
> > needed.
> 
> Thanks! Stuff that includes it are its users and not necessarily page
> allocator itself. Nothing jumped at me.

The whole initialization part is in a way mm_init ;-)
 
> > I'm presently carrying no patches which alter page_ext.h or page_ext.c
> > 
> > 
> > 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Subject: MAINTAINERS: add page_ext.h to MEMORY MANAGEMENT - PAGE ALLOCATOR
> > Date: Tue Nov 17 11:05:44 AM PST 2026
> > 
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> > 
> >  MAINTAINERS |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > --- a/MAINTAINERS~a
> > +++ a/MAINTAINERS
> > @@ -17779,6 +17779,7 @@ F:	include/linux/compaction.h
> >  F:	include/linux/gfp.h
> >  F:	include/linux/page-isolation.h
> >  F:	include/linux/pageblock-flags.h
> > +F:	include/linux/page_ext.h
> >  F:	include/trace/events/compaction.h
> >  F:	include/trace/events/page_isolation.h
> >  F:	include/trace/events/page_ref.h
> > _
> > 
> 

-- 
Sincerely yours,
Mike.

