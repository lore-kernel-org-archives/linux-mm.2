Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC87CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 21:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566568E014D; Tue, 14 Oct 2025 17:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E2E8E0090; Tue, 14 Oct 2025 17:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47AF48E014D; Tue, 14 Oct 2025 17:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3343B8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:13:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD48811ABB6
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:13:37 +0000 (UTC)
X-FDA: 83997971274.26.719C634
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA975180003
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:13:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P9hWH24o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760476416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axJZtnDZWi6vaVYeCAyW3be+cBc21q2dMi5KM6Ov1x0=;
	b=Fa6jrWu5MmN6WBXu+hjFEM9Nd69KYRFkskAqR6T1VnEMRwM5uW6XAiPiUuqZlIeyKTkHlS
	uX3mRyXrw4jgmZ0OfdKNKJmLnlzUAzhw1LkShp1+twB49/9IgzAKjyyjbYC9YFzVO0JFDw
	iFUeYxvX/7FMnTtFhtLNh0if7DF00cE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760476416; a=rsa-sha256;
	cv=none;
	b=2xyLlNZw8c7pMMp9c6/4zMHaR0VJ4YUkPGiZ4c9XkM+4WwDOlKZ53ipFs1UDBIIf5brsU0
	F0fs5jSQMfPCuDBtIkRY0Z7c12SGdQfvVB4tI77JsBVNlsik/UeEdT1rHZ2K0AcMhqFGlM
	7Srw5cZIzIHnV1DvIwcZwtvmLdL/WbI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P9hWH24o;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760476412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=axJZtnDZWi6vaVYeCAyW3be+cBc21q2dMi5KM6Ov1x0=;
	b=P9hWH24o8Wx6LHWvdKijhu1xCOvFjsaC/PBwLdkkPa6OAx9qiRsTFFedEOfwaQYzfpWQNq
	mXgym1dK/eMLi9IhC3iu2ILRPW0CBHu0KtGL8WoNaQZ9DupifEEUhWcsd0AxnOzDoYbHp9
	y0qWQHLvNacRjJtYwdmWQjXSaR4Oa1Y=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,  Alexei Starovoitov <ast@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Michal
 Hocko <mhocko@kernel.org>,  Muchun Song <muchun.song@linux.dev>,  Suren
 Baghdasaryan <surenb@google.com>,  Harry Yoo <harry.yoo@oracle.com>,
  cgroups@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Hao Ge <gehao@kylinos.cn>
Subject: Re: [PATCH v3] slab: Add check for memcg_data != OBJEXTS_ALLOC_FAIL
 in folio_memcg_kmem
In-Reply-To: <20251014152751.499376-1-hao.ge@linux.dev> (Hao Ge's message of
	"Tue, 14 Oct 2025 23:27:51 +0800")
References: <20251014152751.499376-1-hao.ge@linux.dev>
Date: Tue, 14 Oct 2025 14:13:25 -0700
Message-ID: <87y0pddw5m.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: scgufwe6huzhurxiziktsifhaceijxie
X-Rspam-User: 
X-Rspamd-Queue-Id: DA975180003
X-HE-Tag: 1760476415-825443
X-HE-Meta: U2FsdGVkX19jzuT+y9Q59ef1czjfBU8O/VF7KbjHJvQd7PyZGhJqDHq6wDgLyn6kqTB/ghKnVibd5EQIij/Hlsrfrwk9T1PwvC6GR76QWoVA6XvD07rBvU4f4Nz8EUHaBeozHWDfOWf0wn0xChERNjjUhe+DaelVUB/hDTQaNgXJCsnGm5jXTgT77iAZC9T592EKbmZpyDHpn77bmcS7YWd+AYV31naJl0gHmgy+mBJOh9cyAImCrFfGMqrH3KFLQobu/iiRZsZoG5Ca/byoxzmfwuKLFeX44fTDfEYogVr+J796Xcp3JZq/thK8Yg6zTkzghEgZrO76Y5+O6A7f7WZG3aaXEhaRQlJDGbKZybCL5Ym3g6ik7Ku4OAnibJKGggVfvrf0RPP1GqtqfU6Kn8Oo8wUIS7EdvNUDjLMScmgvIUBnEJZEb2nu4ro4H1rYRMoabGGGTfgsjzBAVOq64wJEbLMFsXJreqqOYLiGEZFUpeKkMBAzfg02OSClLu3Z2X6MfSy7QmQSvZrCipk5suAsLDQ7aziXgZKTgWn+GjDbrx/OVgcsqMNccpsP4Bb7cFnxQwRJlfKWJyQ02Th8d3/O+k1Wi6LfiqU4gfLoWpgWqwC2aGac26WPiyrOPDLpElfbDnkKeEPs+cHeNq+um7grPLUJG7JpLI0t6aZjvw2RFWuVTeSpSO6o3WQa5EaIKSEHOkBN2uIkqWHYYX1T+A+9DPkHwW3bHaIQVDVI2rB5Zvi9US9hVqBKOiIzRvm8brd8iHYzMnAdHiPIvqkg2VX/eCsgIpWNd1a9/YppOi1GdmPSUvNHoqTpKFUCdYrrTxJZBYUFNFSERflWFF/84dLhB++EPJwetBoZ5hQx4uT722TPJGExRggGGYvWUzu2o16RGalaIBkga5hyF4ZIMfyt4eVkuLG5T+3mnvyySxKMUi/Q1Rbmsk4uP1mnJC5fmFVJH0Ig9na1oNoVubN
 4Y+fB/8Y
 zqDOjkUvmkGFSl4BN1i30zBpfXbJ6kem/nl24WRx9WXvdhJhp7yp6h5zjIzsVtTGtwIfZnvads/PYYqn0hxfqTmWPb0gVzos4SIzKYSTJw+e5AcbmfU9lDsI3oNenHjqX3YYu4rZsdVxdVnHyDSM5MoFK28LJqMaqahEu+0q7c9biy3n5hrmHiAidVT+z31oORN4SRXZFlSgJ9iEH8WlEnBnnOKQjk0+28GlWRaqQ2LbxICcYghN+zAwZh3P8KNJ9Ze3F2Xj26Nod80vmDyQLfPVggmpOnIQ2E53OW8unw/6iDpsraj5eRyNPFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hao Ge <hao.ge@linux.dev> writes:

> From: Hao Ge <gehao@kylinos.cn>
>
> Since OBJEXTS_ALLOC_FAIL and MEMCG_DATA_OBJEXTS currently share
> the same bit position, we cannot determine whether memcg_data still
> points to the slabobj_ext vector simply by checking
> folio->memcg_data & MEMCG_DATA_OBJEXTS.
>
> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> and during the release of the associated folio, the BUG check is triggered
> because it was mistakenly assumed that a valid folio->memcg_data
> was not cleared before freeing the folio.
>
> So let's check for memcg_data != OBJEXTS_ALLOC_FAIL in folio_memcg_kmem.
>
> Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
> v3: Simplify the solution, per Harry's suggestion in the v1 comments
>     Add Suggested-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

