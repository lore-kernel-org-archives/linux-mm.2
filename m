Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0AE0606A32F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=prb5BBLD
Received: by kanga.kvack.org (Postfix)
	id E51476B05B0; Fri,  6 Nov 2026 04:45:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03CC6B05B2; Fri,  6 Nov 2026 04:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18396B05B4; Fri,  6 Nov 2026 04:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3CB26B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:45:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 116BD160CC0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:45:46 +0000 (UTC)
X-FDA: 85404212292.16.D6678D9
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id E66971C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:45:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=prb5BBLD;
	spf=pass (imf20.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfPzSFcW+pZH2QIPZRbefoHN3/d9BoE116jyqEDVh6Y=;
	b=DfoTF1VAQycms0euoEbaxZOP7dOjuyqkq44uYCWc8ES06haTdS6MnnE6o38MPhUU+VsSe2
	fxhwPScKMU685T/WZBpEdldpHlCotuN1ghmuk6DeHEfWwQ9cQwuXwHL7tR3EepPWWLaSuk
	j5LWafFAi7f00q46zjWqVuuCsCqNd/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958344;
	b=5jn9JlhB26ULk6m7Wt/HL78p+JDvW3pSZS//J2VrzhntEZ2YqT48vygkVk9yuuEh/SeVUq
	kNDmfdObO/vkO/SCbGl0anJ9EORL/mCoKCvOpI8bGki+NyJ0n0mAphisZ8dRsk1qMty5GU
	KTqAxPbgWWtEhEeh7jt/VUQNv8/kJeA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=prb5BBLD;
	spf=pass (imf20.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yMrWApyqMY/NnNDcpTl9xLlqLBpfLw5OYLGgqZXQ1tU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793958342; v=1; x=1794563142;
 b=prb5BBLDzBRhDL1dFgS1P9R5uf5nZMEpJiPJBpQZdVdr7tYQdfZaQl7dXQdIPuujdVBUI9SH
 0IPy8H/s6R/2hutUvkJ1qSlk75e+LGkBRWULDzv5CSZ0l8O+yUvxkayJhn5SsAWoa2ugbJnBdDq
 F20apksvpJr/Z+iR8g3FCjPU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 2f2b68f79f65d7c9;
	Fri, 06 Nov 2026 09:45:25 +0000
X-Mizu-Trace-ID: 2f2b68f79f65d7c9
X-Migadu-Flow: FLOW_OUT
Date: Fri, 6 Nov 2026 17:45:15 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Qiliang Yuan <odys.yuan@gmail.com>, david@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Stefan Roesch <shr@devkernel.io>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/ksm: align smart scan skips with the scan
 number
Message-ID: <au2hqxeIz0l/DusZ@dgvxl46587.localhost.localdomain>
References: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
 <20261105-bug-mm-ksm-smart-scan-align-skips-v2-1-8a9780b6844e@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-1-8a9780b6844e@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: i6hs37ejwnhxzaar6r7k9jqoofy497x7
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E66971C0006
X-Rspam-User: 
X-HE-Tag: 1793958343-866649
X-HE-Meta: U2FsdGVkX18ca3Gf6ogdoPG3qGWW2hd+NXaAACgg394We1LBUp/2UKwDVaCVObE92Yl2RQYnlW3rP7NsqZhJBAGcJvqmOL/4UL0t2Jwxuc2zIUGIARU8cevehTK28aP2YiEkD2VAMSNZg+syj356aD85JBqXKDNZEaPkuPKC2lgQYjdNTByZSrwAUCwR4D4wodTuA7Ai2OGjUpeei/EJYIWrs8qurA3ugvl39QVAe38A6VyLhbseK+6ksFjd44Xxw9segTgvTd3AqccSo9fwpAPAKIsyMsuuYcGS85onj5BlEs+6UbyzTQOYUWVyc1/nEi6OJcWCsxRzHIk8xYOf0Xa9y6Bg2cKtHVFG2Roxrsm+1voNpPBSc5dqj1LDNuRvRIQgmsZsyyEH1a9PDkAPB0kiCI9P0fCgfIR7j/Sba+G9OR2vHME+RDENi/yj1VELDVoCtzP7ZFMI8FG2rvkJZ4DUgKVa0wohtZEc1XaE2lWTXLoU/TUh9dDquqZDreH4me3GAMSQ4JDz8oRli3ZXTJIT3vMikK8+cuMXEQfRTZnoteZPl0nx9z5kaWrAbrGu5BzNx3koXObLMIdkxTr/ppvA3Xi+oI4omQmR1xgPHPfvUH59VqQqv7OkEYJFxbZ44ZhEqHgW7Xf3Lcpvrrh1X1RUblGUsoJrd9JScnUdc8JGowbuSNSEzmFAAZdQF+U4HCGnaoL2a+p4eexgjL58gW4J21eNmj6aQc/4cGMbz6m/MVcWjkMzM5siKAmPNknx86rrW4ptHvNLZt2ASPwjTdCpqRZY6Zc17GWsWH4zlrP8nchuvEcM5oflxBPlqtBvvnmOJwKEFndQ3WZU91NQJblG8ZfNHfTh/eeGiTKJUbERm59fNJfd97jzHbcFk/NCuHqXPCBQ/i27C858KIIem7dJ4O2Hh6ODDwl01xgt1443dV26uLANZxVT/+nIxnwR4up5uo8RdXHu8MWOd3A
 7F22+PSF
 Vo4jcfRCgJqUQSCKf7DhlJbvgqUVpDXUrnQOAx81rtItTo/GPfucPRkMyahjKZJmQGDb7Nfhsx6hOSMzeKOZaIM9ubxf+SwvGS5CxqpdK32CHU94pT/no03X0cbwPhqwof5xplC8AHR90zgt5VVSZFBdXEZpHaVjsg5XponcY3R8fr+hA+gpO2BQ4w6y7nWV+mChDgDjrID4zazrm5eZWU1HMS+mCU3h6rJ7Vcf+MQQ5B8j+8dXGwFzaYa0yPR2QVMehu952EmxCJnWgeXWfNQ948Kj27kLDYb300VX/uy6Fmpdyc1Y5Ld/OLOJ5gNwFY0K+UtWkTE8/Cy4Cc1aJYnDPh9HEb8PUiSXB9mr6hTw/s9M0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 04:36:14AM -0500, Qiliang Yuan wrote:
> Smart scan skips pages that KSM has failed to de-duplicate for a while.
> Once a page is three scans old, its rmap_item counts down its own number
> of scans to skip, 1, 2, 4 and then 8 as it ages, so an old page is looked
> at every ninth scan.
> 
> The unstable tree is rebuilt on every scan, so two identical pages that
> are not in the stable tree yet can only be merged in a scan that looks
> at both. Each countdown runs from when its own page became mergeable, so
> two pages that became mergeable at different times end up on different
> phases and, once both are old, may never be looked at in the same scan
> again. They then stay unmerged for as long as they live. Making a page
> mergeable, waiting for 0 to 20 full scans before doing the same with an
> identical page, 20 times for each wait, and checking the pair after
> another 64 full scans shows this, on two boots per kernel:
> 
>                                 before            after
>   pairs merged (of 420)         329 / 317         420 / 420
>   64M of unique pages skipped   89.0% / 89.1%     87.5% / 87.5%
>   ksmd CPU time per scan        6.25 / 6.25 ms    6.88 / 7.03 ms
> 
> Pick the skipped scans by the global scan number instead, with periods
> of 2, 4 and 8 scans. The periods being powers of two, every old page is
> looked at on each scan that is a multiple of 8, whatever its age, so any
> two pages meet at least every eighth scan. The longest period goes from
> nine scans to eight, which costs 10-12% more ksmd time on memory that
> never merges.
> 
> Fixes: 5e924ff54d08 ("mm/ksm: add "smart" page scanning mode")
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  mm/ksm.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

Brilliant design.
By using the global ksm_scan.seqnr as a unified time base, this patch eliminates
the out-of-sync problem of the original per-page skip counters.

It guarantees that any two pages will be processed in the same scan at least once
every 8 scans — the least common multiple of all scan periods — which completely
resolves the permanent de-duplication failure.

Admittedly, this comes at the cost of shrinking the longest scan interval from 9
to 8 scans, raising the scan frequency for aged pages by roughly 12.5%. But I
believe this is a very reasonable trade-off for correctness. So

Reviewed-by: Xu Xin (vivo) <xu.xin@linux.dev>


Besides, can we add a extra description about new smart_scan algorithm that we
missed in Documentation/mm/ksm.rst?

> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b1892..a97d7563c2124 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -196,7 +196,6 @@ struct ksm_stable_node {
>   * @head: pointer to stable_node heading this list in the stable tree
>   * @hlist: link into hlist of rmap_items hanging off that stable_node
>   * @age: number of scan iterations since creation (unstable node)
> - * @remaining_skips: how many scans to skip (unstable node)
>   * @linear_page_index: the original page's index before merged by KSM (stable node)
>   */
>  struct ksm_rmap_item {
> @@ -213,7 +212,6 @@ struct ksm_rmap_item {
>  		struct {
>  			unsigned int oldchecksum;
>  			rmap_age_t age;
> -			rmap_age_t remaining_skips;
>  		};			/* when unstable */
>  		unsigned long linear_page_index;    /* for reverse mapping, when stable */
>  	};
> @@ -2446,16 +2444,14 @@ static struct ksm_rmap_item *get_next_rmap_item(struct ksm_mm_slot *mm_slot,
>  }
>  
>  /*
> - * Calculate skip age for the ksm page age. The age determines how often
> - * de-duplicating has already been tried unsuccessfully. If the age is
> - * smaller, the scanning of this page is skipped for less scans.
> + * Calculate how often a page of the given ksm page age is scanned. The age
> + * determines how often de-duplicating has already been tried
> + * unsuccessfully. The older the page, the fewer scans look at it.
>   *
>   * @age: rmap_item age of page
>   */
> -static unsigned int skip_age(rmap_age_t age)
> +static unsigned int scan_period(rmap_age_t age)
>  {
> -	if (age <= 3)
> -		return 1;
>  	if (age <= 5)
>  		return 2;
>  	if (age <= 8)
> @@ -2505,17 +2501,17 @@ static bool should_skip_rmap_item(struct folio *folio,
>  		return false;
>  
>  	/*
> -	 * Are we still allowed to skip? If not, then don't skip it
> -	 * and determine how much more often we are allowed to skip next.
> +	 * The unstable tree is rebuilt on every scan, so two identical pages
> +	 * can only be merged if both are looked at in the same scan. Pick the
> +	 * scans by the global scan number rather than per page: the periods
> +	 * are powers of two, so pages of any age meet on every scan that is a
> +	 * multiple of the longest one.
>  	 */
> -	if (!rmap_item->remaining_skips) {
> -		rmap_item->remaining_skips = skip_age(age);
> +	if (!(ksm_scan.seqnr & (scan_period(age) - 1)))
>  		return false;
> -	}
>  
>  	/* Skip this page */
>  	ksm_pages_skipped++;
> -	rmap_item->remaining_skips--;
>  	remove_rmap_item_from_tree(rmap_item);
>  	return true;
>  }
> 
> -- 
> 2.43.0
> 

