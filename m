Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71A0FED3E9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5956B009F; Fri, 24 Apr 2026 11:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CEC6B00A3; Fri, 24 Apr 2026 11:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB36E6B00A4; Fri, 24 Apr 2026 11:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B9BD56B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:39:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D2CBC0D68
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:39:48 +0000 (UTC)
X-FDA: 84693859656.18.DD4E07F
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf02.hostedemail.com (Postfix) with ESMTP id A685480003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:39:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QouSNrZx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777045186; a=rsa-sha256;
	cv=none;
	b=3qqeMP1GlUWECmqs5+cPlp9KwJ1ZAg9nLj1uUkheeg2aU7E//jmunknJ6kFwW8JQIrguze
	1UOgvcb42irdRNzUvqty0a6KJxXPMhhpmJhI4g0dYXpSCfA3eCIu0EKAu5Jb1UJB+ZAlTM
	zxIDOPdC2pVfr2HEcYmi6aSWhXL7Afc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QouSNrZx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777045186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IBUuy/iHD2cVL6NoMiF3zJR5EF0coOtwyWBZktOYkqI=;
	b=KwV2RlCzUqIyAkmTvROFdVaLKlByDArJt5LF0C+i8kQLOd2Qwv16FyBBPirsVTFyZIwgqU
	hTJQ7FSFR1fzDwszPZxFCzthlCF1FpbYkjw84W1lM7pigoSFdvKp287pjRn+keaI4yiy+R
	Wyzdtmewz/fDiNIqMmGGcEdxy1nA9Ps=
Date: Fri, 24 Apr 2026 23:39:38 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777045185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IBUuy/iHD2cVL6NoMiF3zJR5EF0coOtwyWBZktOYkqI=;
	b=QouSNrZxoV2DctjbcrIvV7lZUg3MbyYl79junU3vhVDRgKcq1JKGiApbyr8JxDAdn4OdtZ
	g/z5BCgG4jDGAxdoM/PDa0iU4wjdwx2kiH7U9CEg79rh/DNJjbHoi7c+iBQrs3QejhS3ii
	AXv7/LkneiYIzrIqJQcCJLHXhZX1iPU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: kerayhuang <huangzjsmile@gmail.com>
Cc: kasong@tencent.com, bhe@redhat.com, linux-mm@kvack.org,
	kerayhuang <kerayhuang@tencent.com>,
	Hao Peng <flyingpeng@tencent.com>
Subject: Re: [PATCH] mm/swap: Add cond_resched() in
 swap_reclaim_full_clusters to prevent softlockup
Message-ID: <aeuOuj5rHa6hgLga@MiWiFi-R3L-srv>
References: <20260424123723.1820591-1-kerayhuang@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424123723.1820591-1-kerayhuang@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A685480003
X-Rspamd-Server: rspam12
X-Stat-Signature: oro5wbryscgxid9jpfm333x4m6fs1ter
X-Rspam-User: 
X-HE-Tag: 1777045186-682412
X-HE-Meta: U2FsdGVkX1/lKweeXpn8y+klhFi2OONzugsiM9ruW6r7aZQdVIyTKv1FxuGc84PhBaQROjkxvCV4UIWtEQ1KSAh9AMrpc2WGpx24osEqcdtjYAdXTBFEIXlbW164S2cbLT1QQbnr/V0xfJ+KfytWuLiHLD9m47dknnNFW7GStSuowQ+r/dh9Dy0StyTAf0gvkdBCiSD4Gx71JfJAYO4vWJwJEtgz6Vvpsj4rAf4e9YBJyT2i3doAJCSGCXz0byG5VKMDoNXy+6AQgA+h9vVXXEmMt3sqf4NcYo1naabIYZqPImVwp14VFLkyYLWje6Rrc0BzmOH/eiHPVb89VAI4a49N8ZwG7/Phn1ZZFGlkvqb7VtXAkjDL8H45xb2e2yGZgVJjicp/RFHblbzg+excX/N9WE5I+i8eHmBqcUmhueoD64z/bHQE+qxj8uRO4c57DYgM9KpHELvWArDxD7yA1aLt6Uf88m6o7Hl0e9CLEQbi3wWsgneiWi0lf4kmXte7NHIyW/X7uX+avEkvY9UQBTmz6IhPuErjF0N3czlj1CY1oed7t/qMm1XzXGAWq5LT90hO6QpSNbH/Yj2der3ywKMJLECw17wCIz90sXMfu4aAM8tJiw5FmYVLnJBp6ViYrD/bkMAhJDKGfYMR/P5Oy48xkAp0iP/2ODWy5YwUhtYhwZdg6g/t8cLRg5ifT2klOmq255NQidZqgZG0J+dwQfa+9xf/z6YkocHJV0JwwNvT7Z9KusLhkCQNbfNVwso9ICtItq9KFqvzt7yJphrXNoyZdz4KjI3ceQcCG5zEP8l2auwp8Wl1BHkzCTkd2Sx54RGXC8SzrMxLN7/Evpj8hFzr2qnvLGGB9e6D1t5cClZlKdAhPa6gV4P4Kl5jOINABZ/h2EC3wHKXklPfj9EuSCkoNoF8vDkYCvXnFkDuSafm55tJy+Z7VmCZNLN9yf5W+NUyOxLsaJQP74v/gi4
 oVTZHVOs
 aiUspmala5snR3tJec9QBjjWpNO7QzSE/CB/ZKK+HXEBaP0RI94dlMxZQuAvC0yssYfvH0q+iVl6Faq8jfjlZ8AwvA73uxGqLo0FRT9xKPBVgrI8UhvMwDKTdWKPhcgHVoIB2bLsz39YyT+H+qQybozBTNpcHHduIMOcCxXeE32kUbyB0M8gL5EY0MxUkZKoZ6oHkJfAAXNGHWuATvXIVzsfaMhzyez8nranHa639iQjL2IFdPvksPp9L7NiuV9btIbe4SpiDGQ+k6iVkcpHjeLNokH6fp5HaU6k324JqDIXxkyvKvDRTjElyZqM3nPP3ZuX6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Keray,

On 04/24/26 at 08:37pm, kerayhuang wrote:
> Add periodic cond_resched() calls during large full_clusters
> reclaim operations to prevent softlockup issues.
> 
> Signed-off-by: kerayhuang <kerayhuang@tencent.com>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> ---
>  mm/swapfile.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks for the patch. The change looks good to me, however there are
still small concerns.

For patch log, it might be better to provide more details, e.g did you
observe this issue in a product environment, or just a code exploring?
If observed in a product environment, what does the backtrace look like 
when softlockup happened?

> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..74a1e324449d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
>  		swap_cluster_unlock(ci);
>  		if (to_scan <= 0)
>  			break;
> +		cond_resched();

Besides, is it a little bit too aggressive to call cond_resched() for
each cluster reclaiming compared with the old code? Do you consider to
make it gentle, e.g calling cond_resched() every several clusters, 8, 16
or other number decided based on your testing performance statistics.

Thanks
Baoquan

