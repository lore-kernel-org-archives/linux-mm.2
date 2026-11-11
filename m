Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CC660A380F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=H2OoK787
Received: by kanga.kvack.org (Postfix)
	id CBD266B05E1; Wed, 11 Nov 2026 18:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94FF6B05E2; Wed, 11 Nov 2026 18:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2D86B05E3; Wed, 11 Nov 2026 18:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EDAE6B05E1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:26:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A58E140476
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:48 +0000 (UTC)
X-FDA: 85424425296.01.240CD4B
Received: from mta0.migadu.com (out-6.mta0.migadu.com [91.218.175.6])
	by imf29.hostedemail.com (Postfix) with ESMTP id DC5EE120009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:26:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2OoK787;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794439606;
	b=IXBgnNKtGw8KADT8YJeaZEZEhjaU1Ia/TWy7GRQkNFlJ2IbcJDGgfa3y98KqO0e+JXv8FB
	AFbfBumiKaQmVWYGxRlYxkQhQ40MDLAIgjKXGxmGt8wBVAcCedu5yMPhbBGTzxPBSiiCbf
	XqnIx07UHPE7ptAIYHaY0td+MizwmVw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794439606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1Go9nJGbfGTucdmGG94RDyCyz/Xl64hJ2C69Ad2Aag=;
	b=s/2D3KYWJJ8YPKz9r5qmxwhtJxtunXQ66NTC0CJoug1FKOVONPxbqYrJDiAj4r23CG/+ID
	8aPzee9mBmpYot1lE+8EyApxHzUaV2vqvuj/9eKOMVvwLv+9v9Fg314acUtfyfx3Yjj126
	t5oNNL13UK49FWXIVp4jk2gWsytME2U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H2OoK787;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.6 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1Tgc5aGENKoDFgK3qnx6o5GIsN/BgWLTJWU9rerjYc8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794439604; v=1; x=1795044404;
 b=H2OoK787rAwaaBJrJ8I0ZJj20RiTkWqSW05o2UUZBtr3ne4Qw4fn8GdliKKIQ1/mOxjnEmgF
 5ZS91Rgp3rzHgdtwqS7v2lllrzl8xcktQ71vPN0tDqfh5F38ObO2NyTTb3/lE3pbgfAqQgr15g9
 qBm9Rq8gmERgCYafqqR14U7c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2d26b6111cf784ab;
	Wed, 11 Nov 2026 23:26:44 +0000
X-Mizu-Trace-ID: 2d26b6111cf784ab
X-Migadu-Flow: FLOW_OUT
Message-ID: <5586b128-4402-4fb4-a535-f3766d807042@linux.dev>
Date: Wed, 11 Nov 2026 23:26:38 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] mm: cachestat: count each page only once
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-2-3d2454362e8d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DC5EE120009
X-Rspamd-Server: rspam12
X-Stat-Signature: z3s6cg4oqenzfibxfc1perozzqzpaxds
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794439605-774361
X-HE-Meta: U2FsdGVkX1+/Wa0Lqm/ivCzXrBqT1rY3abOFWL1GgbjukQjsipjyKv130iI72wtX9XOz3KXFBYZv6IMby1lLRDE71ZyATDxIpANQ8/VhCQTczmRWTNQ0VxLFusLRNvMBhLsZERSHpQ4yyJtIWJBftYfvkyyYsYJdS1gXvntw9Q7RUbE2Q2FD70Lz/oARPH+cor2WskeNkEfQLR7H41TvzjyBDJWd07s1n1FEwnBVievqKla8sbJ2Nm/fcP7utwOf9RzuaMlKiF529YhYoLEpOWj/qcIqG4L1+RgKUpFyURi/f37iDREXCrXPVHqm/u8HHHWPQbAF345LHWChew4zqmgQg8iNrcE2S/9DGqyxph746YVnTkEZ/l8FG+aQ39Zs2eiC3UoinXRVShCv6NAsWXKIGLnVg8twUBi77Du0oZBwN8enU/kZSSCZAUVGseH2HT4Z+7N+0TgAjfpGrdi0bERn0v5O6Lr70myoen2VdKmY2/AuwjyVF0pptN8Iq7cT7ANHVYAtEnsZ/4rHC5eh51D3w1kc7JExWJp4sD0Ls3Kic9naobCqv9nnTs0pIctjjrn4jO0pBtGehS0ipOKz4wekiXZ7z2ihGhN0wgVYnUD/XLyEGMn8Qz4R065PgSlDFNboyjIe9uaW0vz9Ic7nTjBJRqr2p88zy0d56DKeSRDchnK5RB2XK0DlE8dQhuEUodKJhKhmETP6puHlwceu7zzHCRvP4l+UjjBrRc+/Rqqbsv75dMJ5cv4avBQ5vKFqF4sow7Wr32J2wCAeL+7ceUVrlknYISSZWrIllp4Hr++qJMaj2YWM3tArgwc9IrOTQwNrjEW4oeuV1pH5pYGnumY6s2EqpxoYKr1AtvDMfK1099oBznspjXIXEx0gous2wJ+5dxC7GZmyRpKtHTNmFPOGOFeBPc/KcgrShDqUvO817suCQ5NKMGri9FMBipHcxJj1NBBrtYFqqXTZECT
 tWcJDbs8
 T15mEYiovwb7oWEBwAQSf4F8TVOKcvA8h+DJDv8U7qMRDV+bwX1dCJGvZnYn5+Ye0U+1rdIfekYU+02udIAlZcj9Qix8N/iSQGhYSTGBar/oCFyHVh+15k6z7BD/5lPpa3hVGcYAOVORPkJ5atQkgvIUL8ktB2CbklUt9rywyHq3DG+Z625txLIcxuVc6NbKC8F+LIrQkiNZ/nzk5kZE/fywj7/w+bXinVjeub/Xf9sX0BZrAu21wonv0qGkk/WqlvX0AyCc+fAAUiA49udqEAv0S/l+oU12gO3W5BkSkfL8gCuDu2+svSQu6wZUzL4JmjsSyeSWrWB027RcGUYWA/wFqsKMOrMz8kUn1zD2qDsFyPCwCSSs181k5iXEaOrcbf59X/2QTzD4D+UwVeELY9aXdGRPL51ddOZuOofF/75tyZz3Pibo9yNMyoDMCztXVSBWegKavPyfGsBm4KvWk+/3+fBMFtdtxMG2y92KuS444CmEJlmG2KLRJtyhKYvPZujoJVW0nyatCSsdEDaMZAnSTFGQ5svn5WjHXGtt3VlE07OBWgCt3ibeIjs7VPQnRHkZNHjw2Mx3cO1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/2026 18:13, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> It turns out that filemap_cachestat() can unwittingly return incorrect
> page counts, if large folios are present.
> 
> This can occur due to underflow - nr_cache is nearly 2^64 on a 64-bit
> kernel if the input range starts more than 64 pages into a folio that is
> split during the call.
> 
> It can also occur due to pages after a large folio being skipped if the
> range starts in its second or later XArray slot and the call reschedules at
> that folio.
> 
> Finally it can be caused by pages being counted twice due to folios in the
> range being split or collapsed during the call.
> 
> filemap_cachestat() walks the page cache under the RCU read lock only,
> and for each entry it counts the pages that lie in the range. It does
> not track how far it has counted, so the counts are only right if the
> walk returns each index once.
> 
> But a large folio can be split during the walk, or small folios can be
> collapsed into a large one, and the next entries then cover indices that
> were already counted.
> 
> Resolve the issue by tracking the current index as one past the last index
> in the folio, and explicitly using xas_set() to set the current position in
> the XArray.
> 
> Additionally, add a check for folio_last_index reaching or exceeding
> last_index and break out of the loop if so.
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: updated to use curr_index, fixed comments, updated commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---


First time I have looked at cachestat, but it makes sense. Tracking curr_index
makes cachestat skip already counted entries, preventing duplicate counts 
during folio splits or collapses.

Acked-by: Usama Arif <usama.arif@linux.dev>


>  mm/filemap.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b04be64a5069..7c05e4fad081 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4638,6 +4638,7 @@ static void filemap_cachestat(struct address_space *mapping,
>  {
>  	XA_STATE(xas, &mapping->i_pages, first_index);
>  	struct folio *folio;
> +	pgoff_t curr_index = first_index;
>  
>  	/* Flush stats (and potentially sleep) outside the RCU read section. */
>  	mem_cgroup_flush_stats_ratelimited(NULL);
> @@ -4667,13 +4668,19 @@ static void filemap_cachestat(struct address_space *mapping,
>  		folio_first_index = round_down(xas.xa_index, 1 << order);
>  		folio_last_index = folio_first_index + nr_pages - 1;
>  
> +		/* Skip already counted entries, e.g. after a split/collapse. */
> +		if (folio_last_index < curr_index)
> +			goto resched;
> +
>  		/* Folios might straddle the range boundaries, only count covered pages */
> -		if (folio_first_index < first_index)
> -			nr_pages -= first_index - folio_first_index;
> +		if (folio_first_index < curr_index)
> +			nr_pages -= curr_index - folio_first_index;
>  
>  		if (folio_last_index > last_index)
>  			nr_pages -= folio_last_index - last_index;
>  
> +		curr_index = folio_last_index + 1;
> +
>  		if (xa_is_value(folio)) {
>  			/* page is evicted */
>  			void *shadow = (void *)folio;
> @@ -4721,8 +4728,11 @@ static void filemap_cachestat(struct address_space *mapping,
>  			cs->nr_writeback += nr_pages;
>  
>  resched:
> +		if (folio_last_index >= last_index)
> +			break;
> +
>  		if (need_resched()) {
> -			xas_pause(&xas);
> +			xas_set(&xas, curr_index);
>  			cond_resched_rcu();
>  		}
>  	}
> 


