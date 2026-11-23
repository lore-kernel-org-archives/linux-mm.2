Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A57606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dAzXsZPt
Received: by kanga.kvack.org (Postfix)
	id 772696B05B2; Mon, 23 Nov 2026 12:16:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A016B05B4; Mon, 23 Nov 2026 12:16:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660A76B05B5; Mon, 23 Nov 2026 12:16:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 471456B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:16:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E7B78093C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:16:04 +0000 (UTC)
X-FDA: 85467036648.19.4643F49
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F0A11A000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:16:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dAzXsZPt;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795454163;
	b=G+PM2Su3AA57CHPO5C5tUnIwgpU9lHYOypZBhM9msPKY41kvJT2guOkcRo/HSGCFeQVTBt
	+XF1zXpcMEtnwu0iNwMB786sA1nqZT+yJaENAUyZCOTLA9BPP7Syl+naf07+odDvLBqpff
	zIAnKzvithbexB3QE1NDaDXXPzkQxOc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795454163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/JPbpSB/rGyKRm4viwHoAGzFC9uuzP6EhjwxOibHe4=;
	b=tG+X/M2Xb0VsnNBCJr6i8TWsfvb3zrUHUgYhiQvAuwe+Jwzj7L3LMPzrRsM9CKqz+TPJ+K
	qnUmSxhKCSq4dTn6o3PGRzbPcgMxi6Zf1+jqGMHom41YNm0SGCZXVn31290QgZnzau2BZQ
	OIs77T9J6pIUv1yObV49dh2yvy1ldF0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dAzXsZPt;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ztivkPdMY2ApJwl6+OnSKU5R/Tv0oGqQG0kTiaequ14=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795454161; v=1; x=1796058961;
 b=dAzXsZPtFyCIYWUsqoCezQ0CddW80Mvv3GX54eJH8BkTHSf72EfqYVbiFBZbUfy8vMShFnqs
 rJoRzxo7v33cgFdthE3ew6zrCo4wIkGw9SR5HVLe5Sr35bIZ/4vlSbqodlFarC4/qA3Urzut4Zf
 +QrC1LTMsxmyEzLlm+kTpL5Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 21b22ad1ae60e129;
	Mon, 23 Nov 2026 17:16:00 +0000
X-Mizu-Trace-ID: 21b22ad1ae60e129
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 09:15:59 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: sashiko-reviews@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Christian Brauner <brauner@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, dsterba@suse.cz
Subject: Re: [RFC PATCH 6/7] memcg: remove synchronous memory.high enforcement
Message-ID: <awR0p0hSJWt9MlIg@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
 <20261122024737.2741569-7-shakeel.butt@linux.dev>
 <sashiko-outbox-227661@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-227661@kernel.org>
X-Stat-Signature: zmpbfw4pbnfpgkep7hdnk99z1s14yamb
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8F0A11A000A
X-HE-Tag: 1795454162-623900
X-HE-Meta: U2FsdGVkX187kt5+yu9ybwWrHzhZaWAe3gUX38cBPNbwz1g0zjKecrg7vo5F7vTs3UgQ2iXfHkpTWqyC7psez3a18xe5jBLqAyOqJP+BRmYSgJvX/nXw/33fqsSCkvGNlVzHAcbwZEAQKE6W0RSyO1dqZ3J0+3Ss86K7QHWW/nN+tQ5TK1ZQsmZkfbnUeHmxLS2X3+htpfoT5BnhykWjOySPGN70NZsb0CxvCPaf/t7zwzIzpqYk890xjXJJ50tLBS1Psb+ELDjQKKm4ZRXK39bF5NWSpk67NLW1gmqlRKaRsDWGn4AjjrWwm3surTkVOyZeZq2TChJS9IUY728fdvyLbBPTOOi1TrxtmvfoAFlQlMXSYS6zht4CZmdPmaVZWtZlhSCZkTXoEpBDXZ6Wb5YxRijUjDZ3rd2BS/FcguaRZM3LqWfoiJaGG55vwMGg+NeEIwuPTaiW2XzLJHcsMpuLZryRKC4ZdrpWHMZNQ0HouJjAIbftzb+iYQO7/L3fSj43BuDXnDj+2qoFURvhhFNf89WhYn9JlfLSis0LeZ9g3nGr0bxt6UPtWjZKYF1vdNMP46K0Wp7r0UsZiSvRpRUtQr5fQFBl7yhqFNd0rtPLfQjcxOHfcYAi8VKNrCTj2D/+kJlh7v0S7zZKRpinBUd9BHpkJZ+uVp2HP8/+zlD8riLUWfMNuc9tk0LBcE15KIlaXdxmRJYGyYHPt2c7lhW8eB3wHZp7vQElvSW9mC/uWxtH8Ymzfytj/nxtu/NUQypSXv+9ZV07x56Ey3SXaIMwWi/V0oFWS3iwSmA6NmZQc0yrKimBcB6qgql4PlIRi+dfwTkfeOpiEHXsV2QWUofqiAASn42h9L3gsv4GRWO+LCioTaU2nS74H5F/GgHYUrI/j8LLOrFgAj5LL7RZk7mkjOTdUFXBlb2jvJPcNB9zt7g+fldXUaJ0OQE/q7uoP0jdqmG7ZpLF+aaixfv
 jseeI8TO
 eTOeBGHrQsShUfQ72xA+FkWaqWup8Zeb+9PKM60XosKiqPdWrv5MsV5BW2urtJt0GVs1AyaVWWLEmYsn4Lnhvw8jSUmM7yTgxY8QDsY3yfq0HR3QhxGQhqeq9gBVgOyMkb3LAKPoMhhQzMyuZqk04SPY4xeCqJcgeojLuOeD+54sB1zovr7RsZ3oeFAGoITxijZBMdc2sYhaN8xVGp66xKN59m7b0iRkJM5u0aOIKZyew5b32ER2SLMs0uNknK5cBO66pol+hfO/aLbwKI/H6Elgq9jafKdDJZcGelfWAB+po9/88IYh2TFCGJTs5BbC2LqgUmx+b+uj6HmpPfi2EoVDWQUIICmhs+txO+66585u65YH8IxB5x7zzQoVCnaOLYK64Ady54amJHBb5ypZ4GrB3O4QvYQLLfHZDndVBb8Vyo+xnpySC5dV2rTyc7XsunLJSbvwNnq6Gs/z+ac+Yv+5WQ3d5USCFGohDolyV/pE8HpTl2Qj8q9/Tz1hImGSJdrEI7Y05cUmOFdMJcxG1GKVPqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 03:06:06AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] memcg: memcg_enforce_high() leaves vhost_task PF_USER_WORKER
>   threads unthrottled

Real fix already in flight. 

https://lore.kernel.org/all/AS8P251MB0001F1EACBED6E7A2AFA8A96C8692@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM/

