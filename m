Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F0D0CD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B556B0093; Thu, 11 Jun 2026 02:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3716B0095; Thu, 11 Jun 2026 02:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20E86B0096; Thu, 11 Jun 2026 02:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCBE6B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:20:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F2BB1204B5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:20:02 +0000 (UTC)
X-FDA: 84866631444.13.F187C6F
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id 26C4A1C0003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:19:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RSz5M7+g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781158800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzaS7luShZFVWIou6yNVr0W7N9RPMJYs1Wve8A/vwxo=;
	b=ISZ+MIXTVcgGGrZA2CWnNqiry51hXLOwEtUoPXcOyGu7G2IxKwm5g4GqMxDJ8Hgj+9w8nH
	ys0uq1eRX6GbAREwzDlVLOah6IL0KwCHcHwfe/M0a4JWYlNTz+b0IdzIbMetzAURLW0Lrt
	j7LCKWvgwgv4/zv2bFuJi4XM52h4bnQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RSz5M7+g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781158800;
	b=IJq+3rjMki/8a2FQ0YpsEVf5WPbTmuJ3JGAbGXUeHoAbB6d3dfmpakBAvZGAzlHGEwKb3V
	mc/yiwcEU46LZdd//3Vur/2y8gtYU0DwUtfxTfU4pUw1LKoq+MD2aOmD2sSi7U3NhxVe1j
	Vx8Je/n+epY9arKY8B5QZp4n/b0qN3M=
Message-ID: <f365d458-8f76-442c-828b-8ea8477eefbe@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781158798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hzaS7luShZFVWIou6yNVr0W7N9RPMJYs1Wve8A/vwxo=;
	b=RSz5M7+gLjW12lsa/Oh+YvE/MIQ/eb6xpdv9RIAi+8KDHKehZR63ux+gmwS05doyBxVecz
	SNGmgedzWfCAEbXvNCwGnBr4wWwJEswHTSDuIASeFxKtmhBWb/wtUNx0Nt90Hxnd/pK+6U
	wyV2KOR37JGYGxdWG2XHUlxQQV3JRiY=
Date: Thu, 11 Jun 2026 14:19:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Nhat Pham <nphamcs@gmail.com>
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260610232048.62930-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qwbz1cpoyd7xfawibfbqh48e87oc9ngj
X-Rspamd-Queue-Id: 26C4A1C0003
X-HE-Tag: 1781158799-207767
X-HE-Meta: U2FsdGVkX19KReRkQoJOoEkzKRQlrDfMITnpQC0GMVUxGy7Dk46LchcNovSxsReSyn8O7zaaijI5gIwG9L4Uw3e7Pj7eVD+UQpcqabK3K1GHHT98fAsKQTlj3Zck63Ny5k4fnpjuqTqiPGeBHojDrCkC78ntm21KsErmms+XI4Hl5RLlmq3vEZ+My4WjuveAUe2yUrstk72m/ygJkIKWDTMYHJ2nzZDu50NPf/2rgbvx/uWzzuKwex2uHJEGIXqxIVmeBsaeVOnIGBdK1fR8LWw1Q0ujXUsF2/AQ0DytQt7iL6oPTKlsq6EyDuixDBIQvcoryV4h7lgxGhVCVqiqYgwaLe8qfu1ZBCvQiNsMVuk/6JepHxaWP6dahgKWePyZ1llluEvAQp7qf5IzqAUWYDEn4FfZOJFFlv/6wdi4iYtaB9s4fCylAOZQSt9JrC8vqIq/Cw7a+6kl1IMSm9wK0p0ORTkczbqvQpmekXgB0SpeZAfkGkP3JkDF434T0Dq8meKS2s2d9VXoFlw/x0rohibv7nOOOTIYc1W2EjwJoUA1lg1aTTTYHM6iaSPVtjfCU6R02Z7llOfPIBL+xRPGmI/0ZmRM7uHvg4eDplyLNHhCFivIS99JFXsE2Tfr4bI3DnC1pi8nzFIfSW27JCRqMXx/JYA22b75xZBsniGLnt4FzRLIMarNL6YkV2SJ6nBGMefQpVv4DDR0jRIoZ1fegKbupuEAPHax1C4U4Uq33p0kc1XQHDxPsG3jcfpihBtfw0wCrkBFs0TfPBLvKDJKOHP1LwRClguedxHb4QLsrTTOS+u0wU6nFedZ6Pm1I05Knx5Dd+UYcIUlOf8n1VbYR6VpAYPqWxglKvyuZtS3jAk483XaNYWIoPKvsntsnVXwiA5BG97KHvqeKJF1PNfbAQVOJfl058DPNYqktiqVV3Isay78rloppzRc6zmaWHwSM8lmSqCAauV4T/DoTjA
 ATJxGk8A
 V/ci301k/M0PmSKrNS3iJS9/v6RoSjUWYKFoJT/Ki0se85ktjBGHirbP5FTw1nj0LxHRGpSvA5cFWo5qNs6JGfOKFKHJggovsDRdyt+zaJ3sHzaG6MOMls3OefsNtOKxWjFMGZUvK/zbxVeOAMAtR48nJsuTinEleuru2/NhyebTKycOzCEGgJVCboCgQSqIkaNoSKYgOVsNfQ9bVxFfkA9SkzzIJnX/k9MpSG1Kz5fKVxZwZRPcHS/uchUmwyVdLokh5USXPHXlXOtOnDJbzQUJhFgdPaqWheONdLQE1j0Ob6Sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 7:20 AM, Shakeel Butt wrote:
> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> inside an RCU read-side critical section:
> 
>   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
>   RCU nest depth: 1, expected: 0
>    css_rstat_flush
>    mem_cgroup_flush_stats
>    zswap_shrinker_count
>    shrinker_debugfs_count_show
> 
> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> under rcu_read_lock(). The zswap callback flushes memcg stats via
> css_rstat_flush(), which may sleep, so it must not run under RCU.
> 
> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> and returns a memcg holding a css reference (dropped on the next
> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> without it. The shrinker is kept alive by the open debugfs file:
> shrinker_free() removes the debugfs entries via
> debugfs_remove_recursive(), which waits for in-flight readers to drain,
> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> already invokes the sleeping ->scan_objects() callback with no RCU
> section.
> 
> Drop the rcu_read_lock()/rcu_read_unlock().
> 
> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/shrinker_debug.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
> index affa64437302..cda4e86428c8 100644
> --- a/mm/shrinker_debug.c
> +++ b/mm/shrinker_debug.c
> @@ -57,8 +57,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>  	if (!count_per_node)
>  		return -ENOMEM;
>  
> -	rcu_read_lock();
> -
>  	memcg_aware = shrinker->flags & SHRINKER_MEMCG_AWARE;
>  
>  	memcg = mem_cgroup_iter(NULL, NULL, NULL);
> @@ -88,8 +86,6 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>  		}
>  	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>  
> -	rcu_read_unlock();
> -
>  	kfree(count_per_node);
>  	return ret;
>  }

Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks for the fix!

Zenghui

