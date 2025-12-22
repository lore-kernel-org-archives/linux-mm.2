Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84500D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 07:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5086B0089; Mon, 22 Dec 2025 02:41:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7C5E6B008A; Mon, 22 Dec 2025 02:41:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7C036B008C; Mon, 22 Dec 2025 02:41:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7BAD6B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 02:41:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 768121A03E2
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:41:01 +0000 (UTC)
X-FDA: 84246310722.12.E135287
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id A0C971C0002
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 07:40:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bn7GPT4T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766389259; a=rsa-sha256;
	cv=none;
	b=2J4whZuhl1nHFQ3W47U3wdymUC+OGutK+BYrh6EeGR18H9uCysHq3tU96j29ulJXaBnYfA
	eFpSLuKhKovczFZ0dl+Y6NWD2T2nsGnenObY0A8OwQDbKONJepVVPBf2yoiaKyVODZilyk
	3YbseryQr7d1xteb8c4fD+JyPWZWtzM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bn7GPT4T;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766389259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8s9VTdOnPQzZ6XjtjKZ846Ransc2bFfZ11jc5LmUyBY=;
	b=6FvRcub4sFbGL64mwz0/mf55UZ2m0sr6DiTmMXbcQhOrXN3sm8meANnhbB58djRTKjOTSH
	NbqcmzNLSswzEH93o8Uh515wPZD5HaUgxsHcOO51m5fj1q7er8StnKd9Mq5hTCwSnF3UT2
	r4OUVEikOUV4pPoY687jiwggpua3JCA=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6455a60c11fso2705648d50.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766389258; x=1766994058; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8s9VTdOnPQzZ6XjtjKZ846Ransc2bFfZ11jc5LmUyBY=;
        b=Bn7GPT4TxKRIFB/+xltcRUyGMZkcqYfp5pkmEPUDLpelPLlfHCNm0PGv3actDrupgj
         l16jEo+57ZfjGogc/9n+BGqXuZBJH4M9U3D1oHTzE/aBGgyQyLirp1RJV8cVfp4P0sZs
         A6u5Jkqbzqfh642EGyOfwaQ+idrpuXvQwrlJMrb9awDtifZws+Oe0cMxFHcfRJ6bA2ZJ
         DPbPJRogn3uwVO0bVbgJUFQu4NIC1mq1wS6cJLOB7EVJiQGw9sgZEf9WwyyKicLAlmyl
         MlyjtF/XllqwkUl+rt8S8yAgnfG7lUGV0b2Fr9Ud9yHt0kjUZT1dyPyA06rtFgc5LEUo
         MlZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766389258; x=1766994058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8s9VTdOnPQzZ6XjtjKZ846Ransc2bFfZ11jc5LmUyBY=;
        b=jbmvux0wwbLPZVQlxNauHRP7d33QN9m7HEdbbZX77DQTrcei0ofIKrH8JoNRCZAhPm
         2t21X+OGEixD+ChQlR/TXxApKLgbVPlx+4gfgz1E1CdMYfUqVIjZ4dZqfHdKfcntqA3r
         YubXTSRckvrfkYdw2ywnT0mEdCYCEM9nMRHLkg+N6wM9oxZrHRXko2zzNVjnqcMTna5z
         iAmGIyXsLYb1G5eR255NDTu/FEEL4unzBhg3mxO4ERudd8AM4fEK9dGHgwNBXh/KLuHR
         zcKxH2D1Rz/8c5nKeeDjlmoZ0sxCnLkMox6YtJ4lRuHVmtnF3kW1kAOU9HewdFIeAgOz
         U7Zw==
X-Forwarded-Encrypted: i=1; AJvYcCU31+uLUsf6/YcXp5vTPZlIaZF1ZOlkZK/69O8GwH5zZwSeQUmeNRqF/XAqjsNE50LpFJG7q1hLQg==@kvack.org
X-Gm-Message-State: AOJu0YzhYllDNLfEYsC7R6WT2g17N0fvdhkRKd+xRbKV5/JkvhGCW6r2
	GrpWjxxXTopdHW7CPFJRRQ1SNY71SmZTLQb9Us3Nf96FwIv8hG1QI0hj
X-Gm-Gg: AY/fxX4K9VyecI5B0dmYv2LKxJxJYIhIzP/stq8kgbJTdblsPyA0PcG90zT6yFB2aCM
	wcWVgpCMJHyLocVIGf8VMEwZRInH3eMQqeVEOalxNo9MnboY5WVVcsO6Dc0Usc9zgrPhfotrO7x
	qFwraxEnGdPfO5YJF16gais1UALNuQmZ4dgnQAgzeaHC8Yv14iDHQ+siMaDoQotgGZFvQMdKJ2F
	OGf/dIw4iCgPNV8ga4D6HPld7V+LIRE7xmJQvms9+BSYkiGGl73ZH/SNEHYDUNhXMBvbvtByWl7
	W7Nn5JJOiLJjvH98AlW19ue24e8pduCCUAHxNLjunFWrHB8CF7OuXkmhOYis7q2hAizuDkV/TQp
	It86Uy9PTbi44tfd/vkohdiUGHsQL0tdAHvpNQX85KQ9ejHkhHzaF/rnNvmHJopNkrxZnZlMYJE
	uaEQZ4ePX4VyJPHXFBxEybeN8axyGXnZ4O
X-Google-Smtp-Source: AGHT+IF0kVZd0e5+x+GIT1QyifG02SxHGcMriy7BlBzMK5qLzfkrgVOl+g7Sr3qloTHpKRpjotxdZA==
X-Received: by 2002:a05:690e:1519:b0:63f:b18a:7819 with SMTP id 956f58d0204a3-6466a85a952mr7381558d50.23.1766389258596;
        Sun, 21 Dec 2025 23:40:58 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:42::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64678d8d40asm3064976d50.1.2025.12.21.23.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 23:40:57 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/3] mm/page_alloc: refactor the initial compaction handling
Date: Sun, 21 Dec 2025 23:40:55 -0800
Message-ID: <20251222074055.74545-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251219-thp-thisnode-tweak-v2-2-0c01f231fd1c@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A0C971C0002
X-Stat-Signature: iqd5q3t5hj1abwu7j1rc59zxwajtnfiz
X-Rspam-User: 
X-HE-Tag: 1766389259-633300
X-HE-Meta: U2FsdGVkX1/ZKVOgC3KFczsLoSOswxdG7VOzaCae6Tsj8D1hnOG90zG+YdQoKpbgWpJyIlIIarkMBh7ArC3XheVGe2Y1qtwXt1TUSDhQqcibUvXp/KsmBTtDRgemG7T7oQky5Y8RhtPyJ5IpIHloGt9a5cVTDEWglzesHedsGprtvljPQ2oXL4pa/74+v3/XNyT8eWXGUuGTDfqifWzArzVszdlnJmAh/C84Mf3F85UzKN6vun6XuRU4SZy7ORcvUd9hvtW3OSUaL0Lnnwjk+sD6eeq0rW4fg1qXiZwErtPOkxk+FRVI76x8lvcI+CDegZv+NbkxuBZc+3CxZ6S2uyxMgysOKuxrcVJudMO2r9beNqquwfVh7PFWuxAzdK1c5oW2s/q9X+G5eSrvJsqHqBZ2KhyrILjlBA3BRilSf+i5eU9+lzSHfw+3+yF3PO96P+E6cLtvL2GmW7Lxj/52xGMs+hm0Pi1zqflAWiAccKrgYq47xEm3B5fK8Ulr07NUpyXqKAyFZPWVvNuKEhlr/UUWfmjDu2TAFZBdd5QP5GwTDNg1NfvcvvNm5NfM9cUQX8FPh4ilnWk8Wsetcl3B4tN3OVpVo5FXWF97tdrgI/69TvHdF2FFK7SFQ9tx3GMQOCzGdNWOtrV6qC5reMN4EPtGh13upykAfc4tYr1a/o9JguMi0SCN8anRi6ZOWrnMXnv30sCpu5mu2Fmjz9D9XQEMeCvlHJKRl8e+wRKxpeV2O1D3UXWWzXYXh26VVjAk2eIlMKAnF1+fdFy9bklxB2ff7cUV8k7ztxThvMBt7iG5szF1lIUWU3PHLpepdVJSeOv6rGWBMbcLVlEFOB9UJzzAhNbpwu+ncz1rwMQcNr1OZvqghEP22QZCsr8rOVi35R2FhxnsH6zRPKh/btiikd8BBe4UPHy6gF4fjSzOwNTP3c4WejWp2tA0QXZlotHZB+HyHXIO+REzGl76aX6
 kV9SU0e4
 uzj9G2+S4QR4GgYAaq3nhC0+t61Yfcp7WLSs+X3n8bKILGjUW3LnwKu3GGAo9ygOb+IstOuOwtUVUe23ZlfTsfQEYAhxWvo56MYoZfXJcUcMR4qYc53nd0w+OXGztavukxpX/ScmSLKR5WE+Ync1W0EBXWpYCveGDYWEYuKP1UFTlgBDJI5ZewEd8DuvgJrdufVtd6UprVqz2nbtYOfU6utPodPLQ9QyDn9SN/Gmw85QerUOyVSVIP67v2WY84/4zJ/QTu4xonJnTU7Luf2QIJWUmIlepeSvBc+Xxh1e6ddRk4u/zcV6j96tS4euXMcZmaFAEPC7m4QzXdvVVz8k4SHjl0MApta3PzcCSn0psYuGEjgC4ZUDoGEOEWTceRfYL/NYkWyqa5o4lpnK8k94uyqXNdlj9/cHnwr6Jl6AZP0tG/31zHfIxwqdBOkb8L/koAlHeOk+NECgXldbJHYPTQq7VxANcf+pmlHjSionkLzYK461K/8DgBAmfMZJoxH3CTc9uiuUGD97ZTHlsTbNyJkrjlmyYKP/XMkUurdTE+VrB/zTb4lqLMFH3hVUwRX7+LJXnxjucvLg9YpCG8wnRLiK+UGKPfNRV8oiL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Dec 2025 18:38:52 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

Hi Vlastimil,

I hope you are doing well, sorry for the late reply. The patch overall looks
good to me, but I have a few very small nits.

> The initial direct compaction done in some cases in
> __alloc_pages_slowpath() stands out from the main retry loop of
> reclaim + compaction.
> 
> We can simplify this by instead skipping the initial reclaim attempt via
> a new local variable compact_first, and handle the compact_prority to
> match the original behavior.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/page_alloc.c | 106 +++++++++++++++++++++++++++++---------------------------
>  1 file changed, 54 insertions(+), 52 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 9e7b0967f1b5..cb8965fd5e20 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4512,6 +4512,11 @@ static bool oom_reserves_allowed(struct task_struct *tsk)
>  	return true;
>  }
>  
> +static inline bool gfp_thisnode_noretry(gfp_t gfp_mask)
> +{
> +	return (gfp_mask & __GFP_NORETRY) && (gfp_mask & __GFP_THISNODE);
> +}

NIT: Is there a reason why this was turned into its own function? The checks
seem short enough to open-code and it seems like there's only one caller as
far as I can tell. Actually I think there are some better candidates of
turning boolean checks into functions, like the one below:

[...snip...]

> +	/*
> +	 * For costly allocations, try direct compaction first, as it's likely
> +	 * that we have enough base pages and don't need to reclaim. For non-
> +	 * movable high-order allocations, do that as well, as compaction will
> +	 * try prevent permanent fragmentation by migrating from blocks of the
> +	 * same migratetype.
> +	 */
> +	if (can_compact && (costly_order || (order > 0 &&
> +					ac->migratetype != MIGRATE_MOVABLE))) {
> +		compact_first = true;
> +		compact_priority = INIT_COMPACT_PRIORITY;
> +	}
> +

It has indeed become shorter thanks to this patch, but I think if we want to
make the code more "readable" we can stay consistent and move these into thier
own boolean checks, or just leave them open-coded. No strong preference here,
just wanted to offer my 2c and hear what you think.

[...snip...]

> +		/*
> +		 * For the initial compaction attempt we have lowered its
> +		 * priority. Restore it for further retries. With __GFP_NORETRY
> +		 * there will be a single round of reclaim+compaction with the
> +		 * lowered priority.
> +		 */
> +		if (!(gfp_mask & __GFP_NORETRY)) {
> +			compact_priority = DEF_COMPACT_PRIORITY;
> +		}

NIT: I think these braces are unecessary : -)

Otherwise, LGTM! Thank you for your work, it looks a lot cleaner.

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

