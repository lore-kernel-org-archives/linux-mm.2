Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E6CC982DB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989EC6B008C; Fri, 16 Jan 2026 12:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9495D6B0092; Fri, 16 Jan 2026 12:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8565B6B0093; Fri, 16 Jan 2026 12:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 750816B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:00:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 272681ADAAA
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:00:08 +0000 (UTC)
X-FDA: 84338439696.29.0029885
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A7D620008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:00:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Cp6amGb0;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768582806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39r+L65CbocMKJ2hSULIQG9yHS2j8i36ygEvkdqqJZE=;
	b=disOB0OQ2cDaRlW8xz7bMRmU0JERfL+CuM5LjRi3AcTOOIk3povAp4OQiibSwurRwPfLNk
	McmN5cOLfUCN+cvc79dDTcN51+c7yhVyas23seOT6TW4sSlTHwNC+WCK6So9WR8AlYo6yt
	zxWha7tqQlNLyLrmXHShByz+GwgdtfY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Cp6amGb0;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768582806; a=rsa-sha256;
	cv=none;
	b=qRopCF/cfL6V3pPMdx0VOnw0b+m4dCt91xcSBON3nORan2kOv9ww1vrfiOSUVR6/2NVpQV
	WBPqUIt54Fb1lqZOwaP6TjWCZ11PVBhPWDmihrefb2JZDKJn7SVVFtxpiZhiHhVyTtjvPm
	D04LULyK5rvBTix6wNZhR0eOl1Xh4Kk=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c6af798a83so22325785a.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1768582805; x=1769187605; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=39r+L65CbocMKJ2hSULIQG9yHS2j8i36ygEvkdqqJZE=;
        b=Cp6amGb0mK7WJYDY+DoM/Zw32vR+GWPKO1Vfys5hd56rxFOMUP2tegplPxMIZJOC2t
         AxHkRDkG4e3aTS9K9VuWX/DAAMprfxSGmGQ7/nWsyKYMBoDWLOYCeImDn/QndcwtkV3H
         1wMUlBNWy46Tvr8WxoPehA3XENX3ObTVWdBeQq+GGc9X0rLyQH58F90JikpNQR3cUat+
         THstMIQmCvlIWF+AtjaLY2F/HvLmaaOYvJ8hCNmBhpHfID1mYDxMPl3a8ajVA0lyqMrz
         mszHkm7pAO5kUtiROTClf8V9osuz1Wi3fP89eSPVVH4XNBUbVbH84wV6xj+W4wLyw90e
         D8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768582805; x=1769187605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=39r+L65CbocMKJ2hSULIQG9yHS2j8i36ygEvkdqqJZE=;
        b=PFv8Z67qrmfsoG47Sij6YSUJ7n8wgmvECuab+LwmsCtOn7nTrr038FelQhy4sM5Y5s
         LYOl9k3sbcF6XmwUi2cFs2sTG7vqYF1WbEYMTRaKPUWrlfoY+xw57CVTVEIdYtR8/JL5
         v7MPloLK0HVEQ6oAH9kxHgp/zxS2b+WMw+zid0sg2V4l+5YgzVtj4J6cGlI+eTG0MkXP
         zzw90Y23g7Ey4ZVJULskXfhk2D5JFRMMOuz5b3zCPker5ilxEhFKBW9exjXLIvf8xmvV
         Wa/73q2rEwcTboFGlKKSwnhqugEJZViTfivJLfwQXS3JH7i0gu7BQHDXWPlm2OQmSxzv
         4Ypw==
X-Gm-Message-State: AOJu0Yxgisl+5wWBmx0JGaskUqeJAr8RjbJbilPfJze/Ow28rekREJFR
	dsz7sSjQ9TjBZpGEapUtsH0tB4i4Mgyx41JaAOh5p/wBZ97nSXVhNDlKlaLwPTt2eVE=
X-Gm-Gg: AY/fxX5WcGBI0IlThvhADpcx6OxZoupkA9fz7Mgmvo7dkCWX/o84xkE3oua+TAh0qca
	e0O1yPKBWSgzl+BjDjFT6kUt7O43DXtcn9bPyvDI6YlLX8Dv95GCgvMd22gA+GVWHqSbaWZ4/rr
	iOx49C60pcG8Moh0YfUh9H3USJDOMmFC6S0UTRSxD5ypXQCqNRC3CfWBtFRXRkWXaa2mMMJMu8y
	wXZxb2dMSjfes9Y2Wpz4QNAJTlCI1DynUEsqA5Vnn2ldmeJc+HmOiZAeqc9SnNtaXHO/HYQzytz
	vEzqaU6x4MbBygfF1vzn4NjEAdJpl8yuzdIBbHEh88cAz2/8oF5FHc8gtewK34qMSbACf7VTacP
	3CzF9wlAbiGPz56mihcjo5q7KMghL0cCrg1uW2ctB2B0C83InIQgPAEMfxHdy87wWQV9+cvFn+3
	YgKJfan4Vh1g==
X-Received: by 2002:a05:620a:710c:b0:8c5:2e1b:7913 with SMTP id af79cd13be357-8c6a66ef7fbmr529344385a.25.1768582804795;
        Fri, 16 Jan 2026 09:00:04 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a71d5b93sm262341185a.23.2026.01.16.09.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 09:00:03 -0800 (PST)
Date: Fri, 16 Jan 2026 12:00:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, shakeel.butt@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/vmscan: mitigate spurious kswapd_failures
 reset from direct reclaim
Message-ID: <aWpukFnKRoeSrcEZ@cmpxchg.org>
References: <20260114074049.229935-1-jiayuan.chen@linux.dev>
 <20260114074049.229935-2-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114074049.229935-2-jiayuan.chen@linux.dev>
X-Stat-Signature: p48po5c4xumm81csuwbigjzbee1huwto
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A7D620008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768582805-109346
X-HE-Meta: U2FsdGVkX19meXsoNuKvGq3VA/d69Foi8vvv3yv7L1Kk/iHpHOchZr52NXIHZLrK+/64UadOPYrWQMhLfbJZ7fFgm1sn6ilbVGKjVRuD0BuU9NWeQdshAB/6jR8IvSo9P7ybDLmhOrIn5WK0uyTEzgp1+Ax2jPE0gjv7O7VuqRRIXZiTkxd0ABcxjbZhB/COv/8nTYQDdd4T207oeQg7KQVBAkHhd6jLPFPS0o2R1SfGqxG/Am9vJOyK58azfd3vH3Qnu8HeXOyfttDOqJzqVzUZpsRickDaR8SJBL3K2scBsYr8gVi4i3d8EX8OgrCcGAECZFs9M4TJB0hO7Pz6iYSEv2xyQxn6GoWrF0m/8DPWUtk2fQKb1hVc3AenVSfFWqELqaAhmq1dYPncFvy7ErZiUbHK1q6zj4Hi4GcysMRrf71PHranSolwf5g8rTybtj8PwWTv/PbdRZ7u7n+ATl7jBh4XE+5qwu6nRbc2HAVidzifG8jQP9+IP7oYGy+0UhwiV3DS4K3YHQqIovEYTPQK5rWpSAuSU6pjLIWQllUEq1u2cm3brIRhUsLYyLtNuGUM3ToNuMcOjP1hYgRuIAXpdhWyF7bX3ESULGz2FVlkLGbheiYpD3rGmN6sUSAHveBTd9J5RBg7j2wDVi7Qe973TjvjztMBhg3XtPHuHUJWycwBOv1SQpZzGNkG1JCO8B4KaaFZW5z9/qpPeTDOSDA+iYrxJ4MuuXq5nSdu+tCL76JyF49FGEtK2M7Kun1FN8nHm62cQ4j+2YEkxf7zpAidTtpowaRltCzSe6A6ssiBMqbI8TmFvvL5JIRU2dZOK+fDYNEVvdnZPgMDEzCAueEndpD7VXj9SlQ3cpJ1qJ3PwkD3gAt1+wvXDl9PtWODyjNGZLpbfXPo1Cf1it7/gMJR3drylezn4SZDNjRqEI1SxEz7pNeTo3p3WCGFM1pDTBFQ18JH+D9wI+Y+csY
 z8UMTTnh
 HJjNMZONfp9SZL9edOcT9ranZgh9+JJ+7V3eiuWtJri4amzp58rsRA5Dknr2xY6aNQCKiEoiFax0TX/C21pPLEXwqYmnwrZ8QWh7iy6qtwAPaEG1GUggiwkNEPEpbPS/jcng7kIDJNDRvXHtiq2o+Y8WOFrH7I3a+yzv37KItejfIg3kL+QeZQ1jWvvbPtJzngqMjHZg98wjn2jmuLMqV+33j5+M4co2MdOzWVVPJMhDSoxl1678D3zGwyKOambZ3mmFwMT21ri86SLtV3bQsMnP/x5XgNBHWqJR/tyk6ktU2sIpBQJJYqGb3UvFsxpzjyxs1pr1Sr48CMoqVvprVRkj51vkDpJUa1NO5gbc8+ATTIsgOWHMbNlUmXzDeANLU+3nYknKNj0gcLctF5eZ+cO5k9QbXME2TLA0Bz3f9hYzFWYpVcHVm9z7+0nT9KBRw2+SH9JXQFiDs8svERkJTQsQ2WzurCn3ggQR4YSFkJLDhzqL1CLwzTVz8MIh4wdyBtLjKM3UFkZ8XHIo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 03:40:35PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> When kswapd fails to reclaim memory, kswapd_failures is incremented.
> Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
> futile reclaim attempts. However, any successful direct reclaim
> unconditionally resets kswapd_failures to 0, which can cause problems.
> 
> We observed an issue in production on a multi-NUMA system where a
> process allocated large amounts of anonymous pages on a single NUMA
> node, causing its watermark to drop below high and evicting most file
> pages:
> 
> $ numastat -m
> Per-node system memory usage (in MBs):
>                           Node 0          Node 1           Total
>                  --------------- --------------- ---------------
> MemTotal               128222.19       127983.91       256206.11
> MemFree                  1414.48         1432.80         2847.29
> MemUsed                126807.71       126551.11       252358.82
> SwapCached                  0.00            0.00            0.00
> Active                  29017.91        25554.57        54572.48
> Inactive                92749.06        95377.00       188126.06
> Active(anon)            28998.96        23356.47        52355.43
> Inactive(anon)          92685.27        87466.11       180151.39
> Active(file)               18.95         2198.10         2217.05
> Inactive(file)             63.79         7910.89         7974.68
> 
> With swap disabled, only file pages can be reclaimed. When kswapd is
> woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
> raise free memory above the high watermark since reclaimable file pages
> are insufficient. Normally, kswapd would eventually stop after
> kswapd_failures reaches MAX_RECLAIM_RETRIES.
> 
> However, containers on this machine have memory.high set in their
> cgroup. Business processes continuously trigger the high limit, causing
> frequent direct reclaim that keeps resetting kswapd_failures to 0. This
> prevents kswapd from ever stopping.
> 
> The key insight is that direct reclaim triggered by cgroup memory.high
> performs aggressive scanning to throttle the allocating process. With
> sufficiently aggressive scanning, even hot pages will eventually be
> reclaimed, making direct reclaim "successful" at freeing some memory.
> However, this success does not mean the node has reached a balanced
> state - the freed memory may still be insufficient to bring free pages
> above the high watermark. Unconditionally resetting kswapd_failures in
> this case keeps kswapd alive indefinitely.
> 
> The result is that kswapd runs endlessly. Unlike direct reclaim which
> only reclaims from the allocating cgroup, kswapd scans the entire node's
> memory. This causes hot file pages from all workloads on the node to be
> evicted, not just those from the cgroup triggering memory.high. These
> pages constantly refault, generating sustained heavy IO READ pressure
> across the entire system.
> 
> Fix this by only resetting kswapd_failures when the node is actually
> balanced. This allows both kswapd and direct reclaim to clear
> kswapd_failures upon successful reclaim, but only when the reclaim
> actually resolves the memory pressure (i.e., the node becomes balanced).
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Great analysis, and I agree with both the fix and adding tracepoints.

Two minor nits:

> @@ -2650,6 +2650,25 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
>  			  lruvec_memcg(lruvec));
>  }
>  
> +static void pgdat_reset_kswapd_failures(pg_data_t *pgdat)
> +{
> +	atomic_set(&pgdat->kswapd_failures, 0);
> +/*
> + * Reset kswapd_failures only when the node is balanced. Without this
> + * check, successful direct reclaim (e.g., from cgroup memory.high
> + * throttling) can keep resetting kswapd_failures even when the node
> + * cannot be balanced, causing kswapd to run endlessly.
> + */
> +static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx);
> +static inline void pgdat_try_reset_kswapd_failures(struct pglist_data *pgdat,

Please remove the inline, the compiler will figure it out.

> +						   struct scan_control *sc)
> +{
> +	if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
> +		pgdat_reset_kswapd_failures(pgdat);
> +}

As this is kswapd API, please move these down to after wakeup_kswapd().

I think we can streamline the names a bit. We already use "hopeless"
for that state in the comments; can you please rename the functions
kswapd_clear_hopeless() and kswapd_try_clear_hopeless()?

We should then also replace the open-coded kswapd_failure checks with
kswapd_test_hopeless(). But I can send a follow-up patch if you don't
want to, just let me know.

