Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46DDC83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 07:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58F936B0095; Wed, 23 Jul 2025 03:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519D96B0096; Wed, 23 Jul 2025 03:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E22D6B0098; Wed, 23 Jul 2025 03:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29ED46B0095
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:31:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC5BD80611
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:31:31 +0000 (UTC)
X-FDA: 83694709182.21.93B5A79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13C2D10000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:31:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qylPVJnd;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753255890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0pwS/0qwO3mUHXOuArQekwiv6Gr4ejvt921/Tg54XA=;
	b=nkYwZ6fl27iEhdwq2pklxU29qWUxhu7BY8YvxQyfvA/E+261aV8Zcy9MiI1ldOIxwlhxbJ
	zYqvR/hHz9JMCazdo8oLHOicKJ3k7/2ogMAY8mzr5KiI5OMcGn/n1YlxhzsgqFfDEqqotA
	zpBvBwHjUuOhU/NFPHbYMGjr1KoErFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753255890; a=rsa-sha256;
	cv=none;
	b=oiYcjf1Uw8Nz9ldqsvcd8T4QjbyzqZlTLt8v7MRhsNd6w9iz4JCMp05ConkkMKGva9W4jL
	FwsXLfAybHMlEzFJNWxdINTJv08xGCsmmrKXZOAs4BZ/khE6olXz03Bi8pqCvRC0lrXUrU
	Ja4ilyTVBwdzlxTlww79JlNgDz5PZm0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qylPVJnd;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5446E6691E;
	Wed, 23 Jul 2025 07:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67BBC4CEE7;
	Wed, 23 Jul 2025 07:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753255889;
	bh=MPGvewvNycI1DIvPEIiTbeqHEpcxVhIqLFJUB/m7jWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qylPVJndUKKL8DwoPy3gYpl9fmvTooHAbAQ1daxBPDeDKDCk8SWUMFU1Ti/jVnKyl
	 mAc74zgzYpJ3AwTa63E7zdNXA6xzOXajAlcIXeaxxm3FkvCWW1Kmff5APHgxYHA+68
	 kN5yu//7bzB9iZ8GeUCBFaUoGt/gCR23jQa7ofrrOQUuc4UYCBl1Xszn9B3bbEskcT
	 1H3Q24WJFyTgc6R8GumQq8Pe726lZgf0noazkhGqNA5NfoWBAqNZeSIibXN8vjXnvn
	 6aZCpI3OSBpx5loAUugrwM/2SoyPhkTjbhB/dtPmousTLLeCm8Mu1pJP9q9fakK4H4
	 ICSGWIrApgkIw==
Date: Wed, 23 Jul 2025 00:31:28 -0700
From: Kees Cook <kees@kernel.org>
To: Xuanye Liu <liuqiye2025@163.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
Message-ID: <202507230031.52B5C2B53@keescook>
References: <20250723072350.1742071-1-liuqiye2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723072350.1742071-1-liuqiye2025@163.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 13C2D10000A
X-Stat-Signature: ynh55ixjgp1pprgf61tffs7phbhmj1a1
X-Rspam-User: 
X-HE-Tag: 1753255889-626461
X-HE-Meta: U2FsdGVkX18NjwLBg2J8QnDDMMa+YxXP56WLt2aM9RMFnwAY7+kywBk7vd2O/A2hDoz9ikJdx85dEoqf2GRdevUWCXnaBTbAHp+FZHlbT4oGtAnhXLcH57TJfkimlE1cks2Btj7iPiCM64JM2zilX785zsbK8N3zMfNLoStEPA5JcohE+K2R+M1odjklUO0aQAUmztWH43EYKP/sb7YsshS3Rorzt1NZx9HQW6Msigdm3JvfHNw8bUTEcumiXao5makuAZWaWxNycfZ7EuzwiM9bhs5VIY3CZ0EjZx2lX3/WHMaHucgBjh5aOy3DRwsc1enWsWkN60+B435b+TJKfurEvVDsti/wbohEJJzyWUjhHxeHsFTrph+YNldIO7hxB+cVmeHOVbbPNR9fQbHe5WYg2h95sRuSVcoZi/c8XPmNRpiRdy09C6Ih9rqqyAKnNdzNQU318Z7FxemADrxpn6QbE7KPojVpshO9vcNr8mRXuH3GA8F92v1s7wVzhJqfzmpaaQ0ieGrZl5hNFd7kqCcb+iu8BC4sMllGxPOT9hDMrlgkYsGC2XxF6ysP6uHkJxk8dQToJoDAv0eLMmHQoHOFuSKGxdMMqo+2QPHLfJNF5wkxRSyPU7SPj1ckplxF83KwiHJFnRzUovFWqxUglbZWG5/XunEdxKQ5d9+tl8oc6W1o27t6qQGeP14+b0gRmDertW/am9cyryyl0ZiJVGxD/abGzIX0wRbBHQ1g3EGC1EegO2utzlsf+WVkTGK3pDusvOX4cRgXxeMTzy5HaOji1dF5PdeEhIt+ymIKQGoqHdBf9qR1nVm0ewO+rNbYO2uoT3zkz3vEREc2TiUePGS8O60taEPunDiLzkvNe2bRg+LoIHQUMeFsYKmxoft81wVRuhsdJO73EOSoaoREyaDGDbu/xhXyw6aVhQckXmJkjt3BZx2OZ9R1woFGjtapnGXnBFtI6kLo3kxEFfI
 JXJ7cOj5
 UdJ75xyN3FVRU7NbayJEq3EtAJS4zl66HcMg4qrxKAIB0OL7mxDUL7EwMRVmqgkQloTCdhIy1ILdWsa/nB+avBcsA9YIHPVFWBXMCPO7AuPqhOtnPchS4Yiyx6aJqsbMwbxQlyyfCBOQThQSnXZ9U7hkOQ9PjlXHa2Qo8+I4JA/qE3+GkWRMVLPwhz8jMzo4Xb9qkxv7rnQx1hvG1kL1FgBYjxMnD82Rt08K/cERvMxaozCgrurJtvPLoJCE7C7HlF+YY5I+6GmVXcY+ameUAknDjXIiIxGS44SnrwbKJkF0y/h+ZT8oq67qyjTkhe4e61dtzBQ2kVSwM6GzImapLIXu39wuH8cW/EkNLhlTcdBYoa8s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
> The check_mm() function verifies the correctness of rss counters in
> struct mm_struct. Currently, it only prints an alert when a bad
> rss-counter state is detected, but lacks sufficient context for
> debugging.
> 
> This patch adds a dump_stack() call to provide a stack trace when
> the rss-counter state is invalid. This helps developers identify
> where the corrupted mm_struct is being checked and trace the
> underlying cause of the inconsistency.

Why not just convert the pr_alert to a WARN?

-Kees

> 
> Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
> ---
>  kernel/fork.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index cfe2f1df5f27..d38f1c5270ea 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -584,9 +584,11 @@ static void check_mm(struct mm_struct *mm)
>  	for (i = 0; i < NR_MM_COUNTERS; i++) {
>  		long x = percpu_counter_sum(&mm->rss_stat[i]);
>  
> -		if (unlikely(x))
> +		if (unlikely(x)) {
>  			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
>  				 mm, resident_page_types[i], x);
> +			dump_stack();
> +		}
>  	}
>  
>  	if (mm_pgtables_bytes(mm))
> -- 
> 2.43.0
> 

-- 
Kees Cook

