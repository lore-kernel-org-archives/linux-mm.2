Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB685D637A5
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 20:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28F16B0088; Tue, 16 Dec 2025 15:32:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6156B0089; Tue, 16 Dec 2025 15:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7A36B008A; Tue, 16 Dec 2025 15:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6B066B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:32:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7ECF6C07F2
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:32:50 +0000 (UTC)
X-FDA: 84226482900.09.37169BE
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 53988140010
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:32:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Mja/L99b";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765917168; a=rsa-sha256;
	cv=none;
	b=7oOMHoG9yyGoSObVy4/JyZmZvfphso0n4epI03bT/K0ivM95n+GqdU7CqSdlRBZahZvjpZ
	jx5vrnyUELnw6Hr7zXTKxa7usH4cfOJAnccMbf8/o07DgUXfGDQibZWJ7u0D8Ft8QBZhI8
	2sAtTZCnZfQLwN3n/WLaIIUfNnCwVbg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Mja/L99b";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765917168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EEEAw7QGb6K7ygmrXSsnTABuvaPxMsNIWBZepu4CMA=;
	b=3IhSdb32Deovn0jzOW4h33U/zJjDBaesZTud4s+/hV+vbaloiUJKGNO0wlLz239Tavmg+y
	r60+bg3RcVeiBqO+IQSUrG0HCzXHI693mRyhoNUhte1y7uZXe5+anIRNRsssKo+RbSLlM7
	TEYVhPYAewbOw0zV4toHUovh2W9AdNc=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8888a1c50e8so48835946d6.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:32:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1765917167; x=1766521967; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EEEAw7QGb6K7ygmrXSsnTABuvaPxMsNIWBZepu4CMA=;
        b=Mja/L99bd0Q++QLFJKW11I+a0CN2Y8K/3z/um9gkbh6EiFMQYx2UVLVZT6w6Hea5KZ
         ZfY1rny2kvU0UuXb5RF150uA7HIvc5xHsP2w9UBcWHtm1afWx+KmAvt7/U9jQ4HDS0bj
         +pXX26XlIhHD9LK53K7mNPt6t+w/ikY279RCHNYuG8j/Y+wS46n4r6RF6IWxwrTaajz3
         FOE2kzVT3tVEYcfNUc17rD/1XJLAdXco3AKHb35s9iPFoBKaSnF8zWiygdDj8hrrPbAo
         nYkFEW4Bq1odcfwaj2SF38lNPDrc31S5q32d2cHB7gZhv3TM1g/d6dz8jHhXuFpzb52C
         ofYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765917167; x=1766521967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EEEAw7QGb6K7ygmrXSsnTABuvaPxMsNIWBZepu4CMA=;
        b=p1YgKjXXRNRhw+9cI8RiJ+ElUw9jGYLDNyfeODDImdrXsBh+TkLZ7fn642//n5NSzS
         T2D2+FrZ8QhqDgI1hKETLy2MKGQc4WVuX9mJWq4mkkaM4hJfn9f/CSRDRR+yn0QAf4JU
         6co5jz9ZAdoaKreLJrA4wFbKAaheCKc2o5p8gFwTdXWsLtLugVq/FvctxkkYo0V8tTk9
         R+dvoTUGwBGWrkV62SCdlZlmRTq29cewuW3H6FXjriq/kfziuWcAmiP5IVOfur9SE0DJ
         Mn7Az7QPAkP467OSv9amgYm0+8lkkIGSKVkMQbhq+Af92Nn6fnCLbRBJjR82kHhou+tw
         LOxg==
X-Forwarded-Encrypted: i=1; AJvYcCXVWrQA6+OJMIJGmhhA3szbJCuD/M2nFZncAm9tGgbhEtoNRrwXaFeoAL6s3yW2xZqgUfObYimOhw==@kvack.org
X-Gm-Message-State: AOJu0Yzzux92fly8pb/GfxOiTin6W0OeUEQ6ne3HLEKXvJmKAJ2erRMA
	HWspcYjWDJ3B6PBNR6xjCNZSyuOpqyRNenrCleky3ByyFnWp9NIWgh5IJ8o6A5Cvv6s=
X-Gm-Gg: AY/fxX5wh9HCY8iJAHPmy7AMQPeIAP5Y7wgG+WdhxDPRQRJqenuQ4qTM+LhWxWWtx+g
	oScx3DUNUOdGdKNIao+asrNTL88DgKEK6wB9l+FKwIftoLiS4cppwb9h+uMWdlzHwctn+/4swLA
	p/9fm/RUZQUyMSSmb9hJBEWY1dX2UX0Vc4RXQbLCUhHQIe/lHT7A0K7AUTtuMV5UqOQIJzBptf3
	siSpsz2oIuf1qstpXsY9ofC8eZFCPUTuJb4kfbG0pQPLa2oBuQOj9S33Wybquv2URe8whCEE/9u
	e5qDMw+YPcsjzAwdJDenuv8RYE5uoLgMNMTRE1O0lwgs+3IyN33pg7PvF4nQdnpcTW27dv+qDBC
	vVquLjNrGQGXv2sGh0uk5PReqRMa5Wbjlo9gnhYdfmUYgkq+4soKQd1lDuGcXmKTCeu11VmG0WD
	cYx3iItIlPuw==
X-Google-Smtp-Source: AGHT+IFdGelOVz+UYJ+Zlbf6DDZRtAQBIiUfqvoKveiGqHlfzqDdluud9sUFL7EVOn1Fn1H1gZX9vQ==
X-Received: by 2002:ad4:5b8a:0:b0:797:1a0d:cdd3 with SMTP id 6a1803df08f44-8887e01da69mr266937806d6.19.1765917167250;
        Tue, 16 Dec 2025 12:32:47 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-889a860a083sm78737596d6.52.2025.12.16.12.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 12:32:46 -0800 (PST)
Date: Tue, 16 Dec 2025 15:32:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] mm, page_alloc: fail costly __GFP_NORETRY
 allocations faster
Message-ID: <20251216203243.GJ905277@cmpxchg.org>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-2-0e499d13d2eb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216-thp-thisnode-tweak-v1-2-0e499d13d2eb@suse.cz>
X-Rspamd-Queue-Id: 53988140010
X-Stat-Signature: tjqdd6wwb8qn6egk961r5rg715cz9nfu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765917168-224511
X-HE-Meta: U2FsdGVkX1+mlQew8myu9uM4xAAvRDGZggsrKfB1zRYUla4YLxPR/QJuLAgSW/qvkXILGAh9NtBZ0MD61npSHwYinHnvsxMuym62sX9omrxZ604mgk5+LtQ5Fn5S/G71M8l3/N7c7+7y5a8SmWQUgRPlMkLM7iv9pejDsk9w4LA+jCA+MG6sKsINBRr6W2h5baDkdO5Tp3kS2ePvaJitKYDorXWAlYjV6nOv2OEP10uuc81FR8WHPMPy1YG1cuq+s78gjCeitNwnDfCeA0l3Phd5U2v1vzB0sfr70w40Vtre8IwsR8JEpUg9WW9MdCCVupJ8TaYKCNIAqupKn2BeYZnE6SzzpWzFPV65VPGMG4JiY3bfZh0odpbaq6rxr3R/AwXw+vt2OI1TrTi5tFF3tzUBYs3pugq32NyiDyPrSjHVsifetnkpOzeANRfNFFzX5WefJeMHbbj2rbNeMLUSwJ9bor2fGwI5zkVPHdzCA8TSBhTOmWW+WrH/cBOO6R6J4qBwpBc1abPq0rOlvtF30Y4djEgsWlTnGykspmv6Qos8OCCZ8hkB8Rs99AzKJZAlr+wa2AIFAHbFsDn+c7iQHroUuZ7tGgd0phR7dTCMHnEx+ThvmaRMhxrqDz5Z3WE+eEvdMIAs7HxqTY0mKK6XKoqEpRR9a+Llk7od1Q60CMYF1qOZs+wbP/8kyKwkpl1WMwN9nQoAGWIAHzNTp7e19HDSZP93mDgBFgsJdJ61w2gWqfeUSCdDKM+MzXLvHMjsPW7GINuQi5gRM8TdwdKxAiHVLTAZbIoXdzmvZ+AyajQo6+czis/Kl+/QUflhXyCiPqlqBnZ/zRl+2FRJeeKVnGVzcyuSn9mAYKpwkfPyIk7yBXYlyziTXngoi5Oz8JI05YokFbCg467IS+D/mTjBZRYNMilDOADZwLe1r4U6S6H9wHWm7NskjI8DDUnReNfbWFQJUuFxWNc0cvOcHb0
 YqeY9rvS
 2eGMxo1uQ487TCYjQlopJ+3EDRQzsvb18DbMGpLxgoPqnuRiCQ3xYw4jt9NuyqMWPkylH14yuVRyQ+AOUu6NBalWT1C14fUlXoMoPQvlrYifMEhl3YO+rS2GIOIfHN03fbjwPDrgjig0VIhjDey440VM8NSHw06hAFGbCvVpFCwwotAOpcuBSECiPaH2oNfVwW4go79npmJ1P42H170wcx7pZNAFLWiTZTVUiSevTe8GDlOqTxNcMKXoq+qWZ78HVDRpQIu2CPGCXVHwf8TY7Kram72mp15SDViuRDX+AfT+yY65UQ1doLUD600uXIlWwSKcO3QG6AtRGuU5mdKr4C9cYT/h7TJ+0iio4EYnwIX1EryhR05hx5YAicDj0Nkdrvrm17Z/ykqcSWKoLbGzgczpCdZqYbyFsmq1ujM4cvjo1518CLziJP9Keo/gXR5ibGssDYnte1BMgaERvLYgGwqfO8FcO+DIoge4uXmfxc0cjVfG7akzhud7mEkYZhm0IqjojW3s5ED8MPkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 04:54:22PM +0100, Vlastimil Babka wrote:
> It might make therefore more sense to just fail unconditionally after
> the initial compaction attempt, so do that instead. Costly allocations
> that do want the reclaim/compaction to happen at least once can omit
> __GFP_NORETRY, or even specify __GFP_RETRY_MAYFAIL for more than one
> attempt.
>
> There is a slight potential unfairness in that costly __GFP_NORETRY
> allocations that can't perform direct compaction (i.e. lack __GFP_IO)
> will still be allowed to direct reclaim, while those that can direct
> compact will now never attempt direct reclaim. However, in cases of
> memory pressure causing compaction to be skipped due to insufficient
> base pages, direct reclaim was already not done before, so there should
> be no functional regressions from this change.

Hm, kind of. There could be enough basepages for compaction_suitable()
but compaction odds are still higher with more free pages. So there
might be cases it regresses.

__GFP_NORETRY semantics say it'll try reclaim at least once. We should
be able to keep that and still simplify, no?

>  		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
> -			if (gfp_mask & __GFP_THISNODE)
> -				goto nopage;
> +			goto nopage;

IOW, maybe directly select for the NUMA-THP special case here?

		/* Optimistic node-local huge page - only compact once */
		if (costly_order &&
                    ((gfp_mask & (__GFP_NORETRY|__GFP_THISNODE)) ==
                     (__GFP_NORETRY|__GFP_THISNODE)))
			goto nopage;

and then let other __GFP_NORETRY fall through.

