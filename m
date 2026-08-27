Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE584C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE95B6B0092; Thu, 27 Aug 2026 13:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC73D6B0098; Thu, 27 Aug 2026 13:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD466B0099; Thu, 27 Aug 2026 13:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 919F66B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:15:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04F4680139
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:15:06 +0000 (UTC)
X-FDA: 85147699854.05.D68037D
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id D0235A000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:15:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="tXwcPGZ/";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787850905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQnMu3iWvpGPN+g3IV0k0ZH3wDq8ERD9nTW8XM39tKI=;
	b=oXH01xabH4MPn5lD9qG3KboMBm/Mvjb5nmd9Kmvs1hQAp9aFJaOa/sp3m2zKJMG0rwHhmv
	h69sAJjrjiqMMntJR1d1K696eFjfOR9dIL3N3loeiZxGB2gIhlIwX5DvEQegma0ku6pRgd
	+XXP8O4rYHjPt+TDI4cWjrTtUb8qmHI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="tXwcPGZ/";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787850905;
	b=XDVggw+iuR9kl3JNk0rlo4O3dD9OUBotdrN1xwq+J1aGXaSSwEoxw4Q1lIMeO2CEIvdSsc
	EfpspPLMcOO/tzESsC6fgyb35XkV/2RL9kaHojMaox9LhMXmI9SdZzVO3stgefGw9+Cpok
	/qQiO9LEbROn3oPletyIhPVoKMKNl+A=
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-836cb2fa1bcso950527b3.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787850904; x=1788455704; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uQnMu3iWvpGPN+g3IV0k0ZH3wDq8ERD9nTW8XM39tKI=;
        b=tXwcPGZ/bOss56xEs8yd74YCGdNBNCzAqEsBYK2Mtk/5oVC/zViGlFh9mVoNoFYCCD
         H77sG2Vh5egRRuT+QXqZDjvw8JNJdL7JKcEERY3/KQsVUu+KsvMIGbU5WoAr57auHIQt
         otFZkfIy2fFXCDmIq9SrTAd0jAD2yk9TS3HLQ/U2HxAljUVbEhF0ow6AZv7a22/daw8g
         La99qDG/6b68Ll1M95+rejXiLTGv3+Q6PbjLNgoOb2djp0uC4DbRSLpmqj1pnJomL9Pd
         Ilv6wfw+MEEPMT7QH8nED+nQJeKkGQciPcyOtbR2j8dcp5eIu3Cj70w15hOLjT3yrGuR
         +L5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787850904; x=1788455704;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uQnMu3iWvpGPN+g3IV0k0ZH3wDq8ERD9nTW8XM39tKI=;
        b=Kei7EMNYXi/0ZY3QsCG/ckd0rGEEseGGYg+mKp7DagCRMaT4z/+iR6eEmsMmpYhTUv
         RMN5cvHkmuW2cYqY5YOx3YTSm121PaO4Pq9CopG//YhBuFKAPNWs5fbl6KkeCTQXEqE7
         VNweVW7O/zEE48MkC64doFbL8Wp2KrpAeJ+R8iHMyz1pXp6htahBZp1g0yV+qjHegHAK
         kAf03grg1LqSx+Ve5+3eO1ORT2skmyFDVa2cjhrCjzYgYSYS5u/bDWOkeYOO31E7ku9y
         kZdzKSdHbn0UpLNRjLK5fQX2z01mmzf9i7qjIfXa++B0IwAeoE3aDHSyfsEclMHOknUJ
         Dd1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqC7SvUAIxqwYC/v0VqPUHFyRxEpZIVoawgAZ5udfdPX3Ob03qpXkYnFtq+2rzIvcrZNr7wD6wTZA==@kvack.org
X-Gm-Message-State: AFuF++k54tNYPykI3U34rK7CPAMQ2fk5kVAefbY4adwSRfbuPYxtoFV5
	i1hffe9Ij3Jd3s/g16uMJhh8SyHanOuVJA7ltEyvM/D74/lqyk7Rgc8BBjy1mQtJQDU=
X-Gm-Gg: AR+sD13qH3WmZcpl3SDDtTFGelqBnthY7e6DTPPHlR6oXOL9WDGTBORx9DORipQYpnd
	7BSxYPzaksu7lC5S9LWoOz+eeW+kpAB4GHR9YZTmstLkyWA0Gy6xyP5w8PoK2r86VJiooVtYVDN
	FF2KClpNis+GMkYITxIBqKIY7B84lu9AqRtytsCpxdhYnKDMsML+urAbZczmz5hH6vUFpl7WLdS
	PdHLD5QxY9DP2xNIVuQrbdGiKDJ8v2ag5vrq7ZM8d9h7abnMtpy5nT2/eVsKOjmqVgR0kwn4RNN
	820OrNSvVp5A6PLkgvpLbF+ZVryb+lWfUBkhyw8HJT+efIE51b5LmaAvs2cMKJlMxAn1b1XUXwN
	nttyEk2lN7AT4W+e3ZFivHGSISCMDPjwWLo1BP3w6luSb02GGKtUChUxjlMugPktFR15jIj7A6b
	q8NQPKl0Gcxm3CKWSmD1lgaNIVvp09azdNamCX6jVhsyUd0UeQLLpS0DmIMwfKjg==
X-Received: by 2002:a05:690c:c017:b0:845:a433:c337 with SMTP id 00721157ae682-85d632603a2mr3858517b3.0.1787850903708;
        Thu, 27 Aug 2026 10:15:03 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85b5c7f08d6sm13933737b3.11.2026.08.27.10.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 10:15:03 -0700 (PDT)
Date: Thu, 27 Aug 2026 13:14:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Rik van Riel <riel@surriel.com>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/memcg: fix UAF in drain_all_stock() async work during
 offline
Message-ID: <20260827171459.GE3004@cmpxchg.org>
References: <20260827124211.3b94b103@fangorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827124211.3b94b103@fangorn>
X-Stat-Signature: 9utkqi4cxak657qac5bnd89ywqcge9uw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0235A000A
X-Rspam-User: 
X-HE-Tag: 1787850904-747366
X-HE-Meta: U2FsdGVkX1+NW7Q5O0w+jXH8F6bsxVG56IQdWQiyDT1ML07YAjmTnXoasOsgFESK7WFzFZxWxg4bTm1cGNIfmofAVYz9TWHRxbMcc+TZO1fS+fDjsZTcs9Wkre/IbvpfGfYmWzViBIvKUOn7KaBBHrrT+obL5t7XQD/q7TRMvkD4O7PxwPO/NrR/njRu8KINMgPh06CX2zb7Ib5bRJSYoCPk6HXvvRreGYEdcMz+TVwvnctABdxGfAx2VAFqj3RXUYxZg2WW0NvCMk3pwH2a7kiFirPlFo6lZm9KUHsaCCIWv7Qi+IidQb53D97cZAaD23BCKZEc2ilBVoi9bLoZbCSvz5jZQsYokYMojPRIEyMP6cKKovU38xsHoigwH7cy0TaQJw9c/SUZ6CSBORPj2q0alQN2F05jyJJ/XlY8hYDrj6AH7BZtj3rWfNWV/LU4STVSRmyIt+re59bJmDhYEN0EcQfApEVU+71Pmuo9ljTHgY8+Fjs9bzoDbUgVQq/W0XGek70EJC7cqv0N1MSMNJ7ohNkTiOlu+XsI1vUEnWnl5JJlQNB9UBAgX7/qtAXqg5JpRKeSi59bxZ/8SYQGMTlW6JVtOvvnOYVPZ2N9EQ2gwoM/N8fwL5JUo0hJNUtxgIwPWIpCGE8AHlqKv99/1tyXZ/pcGuKTvy5nIxqvt/9mRXSNJpdTTwzw/5b0sbDk7vEV7vSkFl+oI6j3e6P8kdF8ibZNS4H6SJv1RKOO9Axw7IonkjUJShXOYHYwk0VzMqHJ+YJgrESd1hhKbfSNKv3tNjF1br57x7vexN8BdneWM2+QtWoQT69FRVXmR3sqcjlmi6aFaKBZUG5GGORF5KPUZRk8Xnjh9GnMEyvf0q18AlfgJ2kosvGSk0ELLgS7mBAOJ4Dn13Sj1d55sWnH4TvvMfYWxRQ/8w0wCTLwyYjaXU2j0eL+dQQBv/k0BJA512OglzUgtRJcgvq86TY
 egtNFuZT
 MC2qTMRnJkNlb2ML2PEpjc4btsXHNEaZvaBZTgYVUWLmn9+MphBEFmhQTz7qFtZWuPQv3wJP0wXlj2rgvB77m5AbDRYRrfRO/LkexJFHrhJdng/zMXqY3S0W567s6MRj2kGORuCJnA78QsqXvqXW36N4HEmgp4g1bIk9k2DcK4MagxfyZ85MiIJTrI1QrKToTRuTjCM75TTqIhloHJqU5u4XEmR2ZMpvCRT0rGvuMhqHEcpdUGMZWIGzdTNFkLql+pv993YvUg6uAtxLFAQz2fuufFixmdZsMJg6664C/WoyVsdN/w21N/MMFlLtc+RhUQCUstS3TM2f2pU3IPIqnjIx1jkHLPDNs4F14/bvTzcB7zC1RoyuC7USwPtwulk3XB/iPTRbERFpHYHn/gVo1gnXAzm/lufbSMA3aGF2TJLHdLZHUcyhaJwIo8f5U8KqS6Dstp43W+AZJmBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 12:42:11PM -0400, Rik van Riel wrote:
> drain_all_stock() queues drain work on remote CPUs via
> schedule_drain_work() -> queue_work_on(memcg_wq) and returns
> immediately without waiting. The worker, drain_local_memcg_stock()
> / drain_local_obj_stock(), dereferences per-CPU stock caches with
> READ_ONCE(stock->cached[i]) and does css_put() / obj_cgroup_put().
> 
> mem_cgroup_css_offline() calls drain_all_stock(memcg) to
> optimize reclamation latency, but never flushes memcg_wq. If
> that races with cgroup removal, free can happen while workers
> are still pending, causing UAF. The drain work could also have
> been queued by somebody else before offline started (e.g. high
> throttling), not just by the offline path itself.
> 
> Timeline illustrating the race:
> 
>   CPU0 (rmdir + offline)                CPU1 (charge cache holder)
>   -------------------------             ----------------------------
>   cgroup_rmdir()
>     cgroup_destroy_locked()
>       kill_css_sync()
>       ...
> 
>                                       refill_stock(victim)
>                                         css_get(victim)
>                                         WRITE_ONCE(cached[i]=victim)

I'm really confused. CPU1 acquires a ref for the cached[i] pointer ^

>   percpu_ref kill confirmed, css_killed_ref_fn() called
> 
>   css_killed_work_fn() [offline_wq]
>     mem_cgroup_css_offline(victim)
>       drain_all_stock(victim)
>         is_memcg_drain_needed()
>           READ_ONCE(cached) -> victim
>         queue_work_on(CPU1, memcg_wq, work)
>         // no flush!
>       mem_cgroup_private_id_put()
>     css_put() -> refcnt may hit 0

So how can it hit 0 here?

>   [RCU GP]
>   css_free_rwork_fn()
>     mem_cgroup_free(victim)
>     // victim struct freed

This won't run until we hit zero...

> 
>                                         // worker delayed by scheduler/
>                                         // WQ concurrency
>                                         drain_local_memcg_stock()
>                                           old = READ_ONCE(cached[i])
>                                           // UAF: old == freed victim
>                                           memcg_uncharge(old)
>                                           css_put(&old->css)

...which is here.

