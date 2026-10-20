Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64472606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CMpw07/1
Received: by kanga.kvack.org (Postfix)
	id 111646B0549; Tue, 20 Oct 2026 14:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2D76B054A; Tue, 20 Oct 2026 14:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C616B054B; Tue, 20 Oct 2026 14:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB7B16B0549
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:13:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25BBD16031C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:13:35 +0000 (UTC)
X-FDA: 85343802390.22.6E4F99D
Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80DBDC000D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:13:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CMpw07/1";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792520013;
	b=5C+y+tIa8HclFXwI4glo2PdyEqYBlPAKCShoEXAMI65Iwp+sB/OSAmsVcTZElmmADALrFO
	5DpMrbRMwiVxtKS3cnd6UI688CO0t+xbD3YogYUG4qNzW+4YY80ekbkFK2QV0bPZRrosZx
	QnQM+o1FF9jpdG1GlTv3E/g3QaUdUhg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CMpw07/1";
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792520013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvgrH+6ZI3PmOmzd8t/UFo/rFzWXLLMI1rZ7t41rPsI=;
	b=S6BGaV9AZT/gXhXd/LaLx0qNHhvDPZpN+UQ7OWFNxmkKq/PvM6s/VIOxyAihLoDRU7Poiy
	mx7ywTmzzRzkZB7pFxhqBbv1jdTfafL/oeWs4F+CKSAjtzIBk2s6kdElDYXRnFTf5yeUBe
	43XitJgmzv1oaPoRAGHHqPbg8an1gBE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4vHXAYHH5hEm7cUcKU4ec1l2m6WXSXPscNO/va3EpP8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792520009; v=1; x=1793124809;
 b=CMpw07/1podgMC2L5t4ik81Y/a8gR1uhzmVANrSaEX1AsyCWMdTWhLQeLWShazHYIdXC2iOb
 IAuqdF8jtibg1khDUKIeWlDvsFGXhl/6P+Wlwhguydl0fT9kmV6i3bZnBrHIdlFjdWTJ5W3EBzp
 pIE31al9KVcnufM4iDTHAY6U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3b0c82d051bbe280;
	Tue, 20 Oct 2026 18:13:29 +0000
X-Mizu-Trace-ID: 3b0c82d051bbe280
X-Migadu-Flow: FLOW_OUT
Date: Tue, 20 Oct 2026 11:13:27 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: publish null pointer before dropping css
 reference
Message-ID: <ateuS_d6hRKFFeZW@linux.dev>
References: <20261020165627.1599959-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020165627.1599959-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 80DBDC000D
X-Stat-Signature: pjku5gxokatpsnrphpwzkpy99c3gr6md
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792520011-943706
X-HE-Meta: U2FsdGVkX19TfP0zSTBdApCBlyN90C0yQLQ+gQ+UIMSirZE/a+NhNJFHGkrMR9gB+/uDuQC93/h4kdWgeldiXMZ/vIxn4CF3zsap28CLFMfiQ2gb4uX5hGXSBKv3cRHzLnSB3KwvaxMDuN14gq6BcSRPmZaXkItShg5mV0XhCybg2au+7ugEk8eUpMZcMrAf+hxp6uOoFrbVDsuMoEnyMnEKvwXye6wIK+e4nf/55DY3YZcSEQvThwm86LbyBYq72OMLCo2fAyeIls7f6K7o52/LZk8Zls+STQtHNrFLvvf/7RoJ8Jq0NKuy9V/WXu6sWYev5sWDWkJPxaLdemxHNkZ7mpwvQBHEaWZTePyaI8pRUN/hV7dsvSPbuu0cgR4ZOZTU2tDRVzU5OwydVRd1Y1kKI8mUey4gFp5LF/bIgizOFry5SEur2glLqNDUl5WkuRl6vkBY6XzQIKY4++rv/EwZnacT/41oqkcqLyhmiaPoupGIFnW0UAoIpX7dGrcgpnm07LHjGfj9mvOU0T9eNk5twwhNTdR/jfvw1QfGdoGh9BghOo5CIhfc5YRRnLxFQIqardqQXNQ4qUeBJSUsTviz3Xgz7mXvZd+NhRpczYVL5bg5Kyb3CPDz+Ys2xLh3K/t5R/8CXayu+1TOG6tgTGY19o+KlSW8EkbmrajK4fFIZtquuPddTyuSfkeUKEX0H7Qn4QTTVGYmypJRqwFnAlMKkj2MmWgDInYLvVPZBXzhs5GNuVlPp+Z8VkD0b/mEQdx+Z0SuDAmPGL+LTTpId3tvdGpPbKKYQ0DzWMM2gyZAcNYlPyWJ0lEeaZ434RcKvwKZfRoifpRA6/yqljY3LD3CVRGugoFPq7WnDkNVyDYEDFUZQ6vFCbYDFlgrADi42RhCIzo1QpY/T3eErMKSDETujfypnS8joF8Ogxdz0l9WNYTNY6959wuADhi1OMt68+NwX4mFCWK6CZN8vBG
 QYL9q88i
 OTgGb3JowN6ArNzbYVTm0bKQQ8+AHcd17ePJd6TbOUD0pP73qFqeBb/wDSRrSfbQ6GLv6J3TnPQevgn2guqrytlfWmuwUR07iM+BugCcBFG6tXNuzy/cc7hrWgRmnIbyMTMELJnQqXFxhxW3RRl7oztb3vQOXjok796T2bGU56KRrPBNhY865YFt1ab+cXgzAo4YhOpFRu/LfpxuDSQLAUjVBSeOnihFGw33tdltNfQ/HLcSCEn9IVLSltGt5L9WAD1N+cwVRaOvwN4krc1QpjBXCFwPSF2elfjghq6G+CPFyfv+qgWMLyivUkWG2W2oG3utOSkJr2awJeiWF68iprUohGhb3tYdHqgh6oufRMU5S77R/9+LAKUKXTJRXr+K7Jiht3lOuiIja8VcDPnZ/BIhpVkNYO6lYfdrtJcJWBgwL2vI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 09:56:26AM -0700, Joshua Hahn wrote:
> struct memcg_stock_pcp hold references to cgroups that it tracks to make
> sure that the memcg never gets freed with unaccounted charges still
> living in the stock. The cached stock can be cleared either via
> drain_stock() or consume_stock(), which drop the reference if the
> stock goes to 0, and then clears the pointer from the stock.
> 
> If that was the last reference, the memcg is freed after an RCU grace
> period, but this can happen while the pointer still points to the
> to-be-freed memcg. Then a reader that enters its read-side critical
> section after the grace period has started is not waited for, and then
> can dereference it after the memcg gets freed.

These are per-cpu fields and are accessed within local_lock. How can there be a
reader where a cpu is still between css_put and WRITE_ONCE and within
local_lock?

> 
> In practice, this is very rare and I have not been able to reproduce
> the issue in my own testing.
> 
> Switch the order of the reference drop and the publishing so that
> we first publish the NULL pointer, then drop the reference.
> 
> This is based on a report from Sashiko, who found this pre-existing
> issue in my page_counter_stock series [1].
> 
> [1] https://sashiko.dev/#/patchset/20260928192349.3432886-1-joshua.hahnjy%40gmail.com
> 
> Fixes: e1a366be5cb4 ("mm: memcontrol: switch to rcu protection in drain_all_stock()")
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e7d7db5718f9a..a05d9a8baa1b6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2172,8 +2172,8 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  			stock_pages -= nr_pages;
>  			WRITE_ONCE(stock->nr_pages[i], stock_pages);
>  			if (!stock_pages) {
> -				css_put(&memcg->css);
>  				WRITE_ONCE(stock->cached[i], NULL);
> +				css_put(&memcg->css);

This css_put can not be the last reference for the memcg from this path as the
caller of consume_stock() (above the stack) should be holding a reference to the
memcg.

>  			}
>  			ret = true;
>  		}
> @@ -2209,8 +2209,8 @@ static void drain_stock(struct memcg_stock_pcp *stock, int i)
>  		WRITE_ONCE(stock->nr_pages[i], 0);
>  	}
>  
> -	css_put(&old->css);
>  	WRITE_ONCE(stock->cached[i], NULL);
> +	css_put(&old->css);

Here this can be last reference but I don't see any concurrent readers of stock.


