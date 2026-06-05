Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B087BCD6E6E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 00:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42416B0005; Thu,  4 Jun 2026 20:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3716B0088; Thu,  4 Jun 2026 20:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9091A6B008A; Thu,  4 Jun 2026 20:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83B836B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:44:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF8A9120563
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 00:44:30 +0000 (UTC)
X-FDA: 84844013100.27.F753FC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3E84F140003
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 00:44:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evSrm9Fc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780620269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6q2i0FownRA3YZDzx7XlKDNjZ1os0IoGmvW0lPidl0Y=;
	b=Lco8kMHli15nhoYUSLKk/ctbVYTz01e2Wdvx1EXyFmLBGOmip/miyuVWXgF56dYcr88M/v
	sCSsc+3V63A7ZgTqKKs58X2q+y9GEBwneH8C4yMv33oEsfrA75rir1VZAVKiSxbjQKWFW6
	M8fR0LQ3LHDMviV+CeydftlxYnu/8OQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=evSrm9Fc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780620269;
	b=Up7f/wh+i7MM4tGzAsEaMfeKtIGwQZLlBNrsGpKfG0mO3CNLxbAWlsaWqTLrtvmhPgQniM
	T1AzEyR7KgrOa8hn9HJgtEpGo6vJpJwdvoVnKVoV4fcEtGTJ6HPJvpIOgA5UjG0HwpbaE7
	BBpXZ5Tn3Z9UXb6uUrhctQMrJl8tIv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FACA43F97;
	Fri,  5 Jun 2026 00:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8A41F00893;
	Fri,  5 Jun 2026 00:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780620268;
	bh=6q2i0FownRA3YZDzx7XlKDNjZ1os0IoGmvW0lPidl0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evSrm9FcuKl26K4DQgLNCuVj0BGkyeskpZqhPt+rGdj2hEX78hB/S+maA9XDn9w7H
	 eB/9UvWVhr1vC8htSeE+oxgVjQpIEIJ8ryqaCvNcqVTmQaWozEQysDKevfJvTubzzD
	 xRazdqK6U+9QrLjDopCbUxU2mpOfBsIwdN8//vuwx8CQMvG2jwb7BBhr6SwSfBkaGN
	 3ibx6nn1KujOWLQsd2L+X/PLf3lYTEo7+IjTrczhFxAKC0mMyQvll4zNXc5G61cfGJ
	 XyLPtblkPCq0+tmePgdkbpqnNnR4AmOo4HghrlcniKPnfIWCUelqASA47Pc4PmAxXm
	 m/46vt3uDbGvw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Thu,  4 Jun 2026 17:44:22 -0700
Message-ID: <20260605004422.82568-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260604150338.501128-2-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rnrwtaognjnyf1b1kh1oa66uwj6jpof3
X-Rspamd-Queue-Id: 3E84F140003
X-HE-Tag: 1780620269-426237
X-HE-Meta: U2FsdGVkX18qd+Y7Zdax6AYXSGjrKIvfUHfLslL/AJRLhiikWFHg0OMxAug627KIx8ha6GYH6A6hGkecb80NP1eTM3vCfNARgo79GnghK7wF94ZTKWNmFrqDDz+3eUxy5qw8gl1JZHcZGOB/VAJiZCdzgV5x/N9sysmR87t6RoZ8ZAhl5nY8Ek95q97ZSEQhmXm2aySbgQPgyW6h3PdkH+dMs24QyA3W/6QqOQuOU16ctkP7oCQ/iMcnAGdNKAer6TUWR7Vo75EAaq0rGJhAloed/OfMsedhicmf4m7ma1SUnFWbyaPRkqRhIUB86/1ngtTkkGgTTt7XU1babp6DmSwXujCPSqaeDkvVZsbtIRG3MrYIk0/xxq/5/kGz1080+joyJ39y57f0u++2tl/wLcE0XHcxzWGx5mlw0jsBS+KyusjXcZnish7yNq9f5fBgCe88+ruSKgfW630Tv/EvqYRp1E5LV/P7vlcm6rCBd0deYdDH+0N+Eoa3Q/yN4U1Xp0uNjCksjlIlasBbNtOzKkAdOQt0siu7y6tg8qG7On4iO+dFuTAKEPEhOO+lxlBhq2cOzXk/GTdvf/tOtd/knaydpM84m1wSWbFgwJLMGCbJwCH0MB0/JLBdMm8c7/3qZ0rwn8VsiJTIb9HfSKjsQj00tJj0sKy7eRCgsb2GaQvbvx262/riffZlgL1sRoio8EdLp/zE3yAPwAUDjKhAg0hmBFdVbqXUb7/8H9a4O3zVqVmmctNAoksLQJ++ok2R9xnfLUD+z3Sr0l4MJGmTX7mXiIH7VyEePNh/z8VjQbh0BnCtxRxilblpincGdt4zQSUi4RDHK2SMkBZFefDaPuEjvXkOhX0Qhwag01T5XujhBj5xf+pyYXTRhq5AgpJO8GNEALsdyQfya3MJ3NQNdgxtZmL+74kYq6Fke2A4MXzdSncFbBPNO2EmGiFoqgdoTVk4fxgo3tSr23ZahDc
 BFjfkX/N
 J4kjJJCkn9GG/gQ6UWWMl1X0gTCk+wqHbrQUdjc1b8f0Kn94rtY6YXczVJmA5vprtpTeCZsDzupG+3L9vOZ8IbznAMISZvDidAGVXuMiN/xl5ESOe2uinHOMHtkAQKz2YC60cty3qurWpGtDGREL8uzDdZgVo8/90YDlOW1uqpcfSGtSDQQFodpafKspQCNj6sXWVLlh0SZxhZxZCjMucS7U2DvZujtJ/gI8QSpL8/UX6WlfYyYe6tUzk0auUV71jeYGDAEDbQuMpHo6xgXIAUEzcwdZ+F/69Mu7G0QJg2vLypXmn+tuoOQIGEbm0jJgAl5XtC71sJKq4GEKR7Sfcn2nRFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 15:03:34 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a
> new DAMOS quota goal metric to measure the amount of huge
> page consumption to total anonymous memory consumption
> ratio.

s/anonymous// ?

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  include/linux/damon.h |  1 +
>  mm/damon/core.c       | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index c7a31572689b..8e15a674e893 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -177,6 +177,7 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
>  	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> +	DAMOS_QUOTA_HUGEPAGE,

On the previous revision, I suggested renaming this to
DAMOS_QUOTA_HUGEPAGE_MEM_BP for consistency, but it didn't got your reply.
Could I ask your opinion?

Also, I asked you to add the kernel-doc comment before dropping RFC.  I know
you didn't drop RFC tag yet, but could you consider adding it from the next
revision?

>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>  };
>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 9f38deddcb30..7fc7477a353a 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2536,6 +2536,17 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>  	return mult_frac(inactive, 10000, total);
>  }
>  
> +static unsigned int damos_hugepage_mem_bp(void)
> +{
> +	unsigned long thp, total;
> +
> +	thp = global_node_page_state(NR_ANON_THPS) +
> +				global_node_page_state(NR_SHMEM_THPS) +
> +				global_node_page_state(NR_FILE_THPS);
> +	total = totalram_pages() - global_zone_page_state(NR_FREE_PAGES);
> +	return mult_frac(thp, 10000, total);
> +}

As Sashiko also [1] commented, let's avoid divide by zero by checking if total
is zero, before calling mult_frac().

I wouldn't mind ignoring Sashiko's 32-bit concern, but do you have any opinion?

> +
>  static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>  		struct damos *s, struct damos_quota_goal *goal)
>  {
> @@ -2567,6 +2578,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>  		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
>  				goal->nid);
>  		break;
> +	case DAMOS_QUOTA_HUGEPAGE:
> +		goal->current_value = damos_hugepage_mem_bp();
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.43.0

Other than the above comments, looks good to me overall.

[1] https://lore.kernel.org/20260604151932.93C431F00893@smtp.kernel.org


Thanks,
SJ

