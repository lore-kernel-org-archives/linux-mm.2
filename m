Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20FAB606A333
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 08:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O3/snmKj
Received: by kanga.kvack.org (Postfix)
	id 394116B05B2; Wed,  4 Nov 2026 03:19:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344FF6B05B3; Wed,  4 Nov 2026 03:19:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B146B05B4; Wed,  4 Nov 2026 03:19:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3916B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:19:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DC5E8028A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:19:17 +0000 (UTC)
X-FDA: 85396736754.16.30E6447
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D4CAF180004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:19:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O3/snmKj";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793780356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xc7V+QdXVVO/sqjZeREmJmMcVmU9QYnc9ONRFJK1OpE=;
	b=pidQIABc1/O+34EnV8KW6LdQxQBAkgScSRpOH6ebzcEnue6Y6qGSurgwytJWN8nOrvQCH0
	w2nTE+H+g7UEmob70LGajkL90kfENvg05LCivlyGkk9Yq7a2+ETU8RJRxC2S5/0TsUZlem
	0rrQ0Xupt1h/iYF86DTsnHbWASkq678=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O3/snmKj";
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793780356;
	b=hAyx84+FAS9eJ7gHdRTkp3hoJgMKMjXHFJL9YAYxldqIDYBP6bTZifwYFqYw1xJvbYDGUv
	xboUO4u2SwdUX6wZ3V5KWXU3+CyAkS2uVRSFCdMZQZnlEt15cjYihJ/PlmYEete7TC0zrM
	iOUQdDVcGGG9UkI3f5+DM2/jMwjSMsI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45DC243544;
	Wed,  4 Nov 2026 08:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D9A1F0093A;
	Wed,  4 Nov 2026 08:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793780354;
	bh=Xc7V+QdXVVO/sqjZeREmJmMcVmU9QYnc9ONRFJK1OpE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O3/snmKj+Oq77n3PttxztnuIcIFYN0EpcanrM6a2w6qax1v2/dRhnuLA3toFV34K/
	 RNs5POBA8fBvDsg3p8XPozQad0dKkQz2UHF8RzJkXPzm6e71H/u8U+nNZtcu1dm7tw
	 IU9xCcMQfRmxLcMHfUWkNMYcWggc+r5lj1zuBRMnIPDLukGt5tuu4+SqzzGVBxggNz
	 SbFXmnKaF1qJeIA2lSQcrg01vtQ8uuE3mi9ypgm+zxJUWP7O5WGxetbbhSbGaj/YiA
	 dYbkX1+We1DsmnHCKotFbMMOMMByTSVOlLGzxVykQGkoKp71qJsIS8Q5I/NyKf7Ojl
	 cLFxy1Ooy022w==
Message-ID: <e4951dae-e010-4d75-a4c1-397e7c5cd05e@kernel.org>
Date: Wed, 4 Nov 2026 09:19:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: urezki@gmail.com, paulmck@kernel.org, qiang.zhang@linux.dev,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 rcu@vger.kernel.org, linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
 <auifTNDwbBTJeu81@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <auifTNDwbBTJeu81@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y4knmipyxotep36tq1zrx7efq8yfpqiy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: D4CAF180004
X-HE-Tag: 1793780355-188576
X-HE-Meta: U2FsdGVkX1+KgpdZA7VLamKiq+kxAG2wu+5FSmyrhAmt5AAzky1PTahMsi0k63Yy+jnyvR0Z4gg9VUBotGsWzxVWidaqWV8nEpwInKT5trth+y5/wmx5OGmcNQG4dbTkeQJ5NXzuZUC7mWUJulQgO6sfUaGBUKzwpqh91hahU3BNnJt/rahG5pPBLeke+YwsekbgLVS+f445zMKaBFuEN3Jf7ET+f0+4kFI9mshh8ySa8DY722zdtYBoyGesQ8/GoFVVvpDT5i6HyHtHDdnnZxie/TX3W+D/lsfEuNOBvTaO4nc3bZHD+zWktiR5/T1Q/RjxaJtFYmcTZsPcgIrVsLOgPWv0igbOVnnZB16WGqq7UyLg9oq+Ks31VA3zD5H9uh+CUifnxue39ULdWHK9JJH+w8vY+Z4SF5peop1pDBCJIwrzULFWAFsxe5gBdIYoB34hlZHt3hylO7UFdQeDKjmA7Q6BCb5fCyA7IB2aiC+++HYjaG96MuJlncT+LYFBv9dcqY8ci4kCsmF/LvkCFiFCHE5HUa+AE08BK6+gHZ/raGpDvEoTBoTNUOkk5VUCKbFqPaMod1DZsOHRbf/xfMHcw07DA2WQ8OoxsB75+Xlpx+950XESVADVQfS2rutlbauKh66kNQlQN1JiGzSRndflfyCHJqu20KP7qw4kBgB6N7iDbkBWurlSAh3Ewv7oJA+DBCTajDEOrg71ifN73vk2SNJIHqE5UYKsU7fQlz36oqzuXDHot4V5W17O2svGE4gJvk1n1Cl8JrMDDDHg/RY3HjEu3mdkRxDeHdbixcfnPB4xZoJOaWshmhh9CrD/LtGeNAFt53AsjltHF/Kjy0P77xK/mm9oZ9kqfXkEtUH+uN/DG4JcSpsDCfRCvY6S+vMY0fDfQuWMipCI6I/OukRP/QMm3+PCc6cX2WU4L4EnH3SJg4zyYL2OIJ19lnF+Ts5ncBGp8iyoNdWBYP9
 /P7xFdqw
 kJbMinecSZi9G9v2zAfLcBnD7r1ALl3wbxGS+/Mu66jmx9rv4tzvY6Y1Tmw1pynv9ySn9tmrkJaLI3mmck0V5a7dCjGpSneaCxVWsxylhcJLsi6F/1qaT31g/RqkIJ6DSQtirEi1A3+ZQBpnlwMDWUQDjR24rPVpjE6gJIKMrL5opPJVN7kxROmW+EV3qgCLl536QHiuOPPp49KLSr91w5Ug4IWSNR8ac5XUeRNo/noFCmg6DkJJ0ExLddtZzNgy31JAyaLheqnxjy8VrjsJJH7SzmWb7ByCjoY59zHRTyYOh3dbgBXwwQJAnsgftmUHhMPeqQ898rnVYIe6UP7uNJpQSUE6nuHoYfQW6OZH7JH060xcKk0JNSupBHhb9+LafcD1QepzEPybk/QmfYf0kucaXp2QWo7DS3xM5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 15:35, Harry Yoo wrote:
> Here I added bit more context and adjusted comment. End result:
> 
> mm/slab: don't queue the page cache work under krcp->lock
> 
> Commit 56292e8609e3 ("rcu/tree: Defer kvfree_rcu() allocation to a
> clean context") deferred page allocations to a workqueue. To avoid
> deadlocks with the scheduler, it used hrtimer to queue the work instead
> of queueing it directly.
> 
> Commit d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory
> pressure") later added a backoff mechanism under memory pressure, but
> did not consider that queue_delayed_work() with delay = 0 immediately
> queues the work and introduced the deadlock commit 56292e8609e3 tried to
> avoid.
> 
> run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> callers that may hold more, such as set_cpus_allowed_force() under
> pi_lock, so it kicks the refill work from an hrtimer. Under memory
> pressure it instead queues the work with a delay of
> rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> queues it at once, taking pool->lock under krcp->lock.
> 
> With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> pi_lock after a drop_caches makes lockdep report:
> 
>   Chain exists of:
>     &pool->lock --> &p->pi_lock --> krc.lock
> 
> Use the hrtimer when the delay is 0.
> 
> Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Link: https://patch.msgid.link/20261028134647.3176080-2-zhanxusheng1024@gmail.com
> [ harry@kernel.org: add more context to changelog and adjust comment ]
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/slab_common.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 41dea01a8c1f..051ca63c0b67 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1987,7 +1987,15 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
>  
>  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
>  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> +		/*
> +		 * Use the hrtimer to avoid a deadlock with the scheduler
> +		 * by waking up the worker directly. queue_delayed_work()
> +		 * uses a timer to queue the work, so it's fine.
> +		 * But with delay = 0 it queues the work immediately.
> +		 * Fall back to the hrtimer in that case.
> +		 */
> +		if (atomic_read(&krcp->backoff_page_cache_fill) &&
> +		    rcu_delay_page_cache_fill_msec) {
>  			queue_delayed_work(rcu_reclaim_wq,
>  				&krcp->page_cache_work,
>  					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));


