Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B4DC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 07:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369E76B009D; Fri, 21 Aug 2026 03:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3408B6B009F; Fri, 21 Aug 2026 03:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256E16B00A0; Fri, 21 Aug 2026 03:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F00566B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:50:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 635D1A294B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:50:38 +0000 (UTC)
X-FDA: 85124504556.18.0FBBE35
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 65F4340003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:50:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="QsnDFf//";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787298636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RWA+HUT3W6AsRkOLp09q1KyYn/E9QflCE9F4xeuhlo=;
	b=pmKZSmCJUhwNQsJgwuvuII8jrTu0ihNFB7UOvEztcuj0937JUUyiW1TRZ3kns9GGC+APU0
	tAA1WJ0YFYof+zy7qmrhZt/wvAzWC+z2AtfaxPv9TxNVIhW9Ytfq+xDDjB8owHZAnNafmD
	zaumbsV9Yjcsr7zjgwueBchRJ1biY/M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="QsnDFf//";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787298636;
	b=DvKrPnR7Mp99D7xbxvsIDI0lMZJ4QLioO7J1yNA5UX7owuSHysIYWWHixj+GXISc8y7UJY
	WRmJqq7hOIj6XdTvdBQtdZnMH4OSRRaLuBs3NqyZX74bmJtQAjIZXYceuzXGQjaYQAFnmN
	ZLb9xYUvflbAX3Y3SlmgagKqOT3cBNU=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69c600f76ccso1323753a12.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 00:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787298635; x=1787903435; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9RWA+HUT3W6AsRkOLp09q1KyYn/E9QflCE9F4xeuhlo=;
        b=QsnDFf//YpOB8oSnPF6FDXM1JmWOg2M0Qzj9WsAo/3H+kDEPHoH5xzvbBwgyfbVajc
         fsi00wCLHZmYuB0RW6/xFvXNDJBYIdeNWkimni/y38SXXGC0PUwYJH0oV5olSm/dlIxs
         CZjyFZU2YzYFV5d/nfsY48J9AGKJAtpfY2o4JiTsrxb807RVB0TJvU5LuAunPLTmUr0z
         UH4jbatKWyaLzFAFtMLZ8QIwJiWYK0stZVY9w2MjgWqLcqaFENV6JlTC9tI+nt2sMWcR
         K8wk1wpe14/WUm/bJkJu2KhBxrTCOj5nhNsa/DjU+4vQqd5qlXuqJcLwKEhPnFmOl/Xn
         GTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787298635; x=1787903435;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9RWA+HUT3W6AsRkOLp09q1KyYn/E9QflCE9F4xeuhlo=;
        b=OmQ1mo9lxDxz2dIX7zzBSvBsqljsCTGN1oI5bMFfE8XaSlbRP0Lr6DTmd1iZtFwwIT
         6Kf6z3xJCOV7yVQSb1MxEK+AQNjPE+E3ApFLf09mF7Pkb9xKioQ4sqW5irGCowyfzWbc
         JZz6kkqQs5MdztrGMEiVVHtsuoihkik9lv3T/YZ5E5C5WzuZ4yL4dYeW+gPoHtjlH7Do
         +bx//CGfCSolI1eSmKubhtyXtaQFgJMmRaH8uTcuigH7IDgp4sHQk84SiE3FckVzMk71
         NEJZvIhEubDTQcqEFuxGdKoPAwwi9J3PmClO5pkl6IJB54f6zAw9gDV+U0pyVsFvH+rZ
         DxqQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzHes2E86U7FE9pCrXmZpvZrfqdKovGe8e+imMtR4OhNJ9SITQtx0u+zcGVh0hWsN+tTO6dkjTXA==@kvack.org
X-Gm-Message-State: AFuF++m3SQ+w0Fqx7DLSfj+Iak6//q55dQLBHJS+eBUx8iwM5FVBKoTE
	NeLSYZNW7DySGCu8pIyhq1s9GpaSWt7FOUzNgJAF9nMaITJuz574cZF8ppsWMyR/SWU=
X-Gm-Gg: AR+sD12/AkyuWKpDbwG6RxyfEGujSLrQfr2uUMBW+FtD61EIOBNvj9ldVpEBn6QfqZP
	TAIdSmIdG8VrWSKkTY7m5tOfHMhQ6zJ6SPHd+6R8dasywT7BH7DPHgJBGZ26tv5KIMQrrATe/U/
	FNjk7ohpD2xE75bZmR1h0jML07Vp3iuacogL3l+mdvBHpW8UGMT9DNYcZhx8AUAK5WRCg+x1wf+
	jg1ZgD9fpfEpsRAlCfb2YbyxjsiMdwWDmEIvv9oa9a1UMjgGSMe2tJanSdfihGDdBuXKRbT//sM
	8DAHePABduRoHjQ+2OMYfRKk7c9aPq3UEOO7N/5CJRHTmrXs2SK5m8TOHapQEMcIGkS1DKpZ7O3
	fBG7TUKqmdE6Irt5mmAW3F8muFlUtQvVUICi+BqYPfbEHe8cyGpvisDTcz8faYvFGdHS4s3y2Xt
	UIzVKLgr7MIdql+oHI8J+n/kcJruh/2mgZ9vqS7QUL1CHumwEjgD3+X/AYrT0/d4hjyrwwEq7LE
	Q==
X-Received: by 2002:a05:6402:27d0:b0:6a0:9c84:ce0e with SMTP id 4fb4d7f45d1cf-6a42f20af9bmr4666831a12.14.1787298634871;
        Fri, 21 Aug 2026 00:50:34 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff156811sm5060563a12.19.2026.08.21.00.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 00:50:34 -0700 (PDT)
Date: Fri, 21 Aug 2026 09:50:32 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: add per-order allocation slow path statistics
Message-ID: <aogDSG8a68CrMQpL@tiehlicka>
References: <20260820133659.712111-1-d-tatianin@yandex-team.ru>
 <20260820154913.3d6a821f6ba5c1f81d134a0a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820154913.3d6a821f6ba5c1f81d134a0a@linux-foundation.org>
X-Stat-Signature: knqbonqq15b7d9pppe5aysp3nt1epbdx
X-Rspamd-Queue-Id: 65F4340003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787298636-844386
X-HE-Meta: U2FsdGVkX18q8Nm0cU/q71Bizfjw87A0Z+zTyDy15TjPkKR59lzbiD0jhdkMBm2Dhr0vCpZ0NMkMuX0K9B1c54/gxL55N7bjmdnomgu4tQp5csW9VJpJcSyHZEPwOET/uu18IFS+R9cPL3uczzztR0IasfKO+unAmguxAd0sss6lhHf96ZGK+tMEC8m2OYL0b2uwYxX4M2RMth8PvviMG36iba6yWKM6IEAxI3OrPBb4xxk62BX9b/xWoseYO7NUT1N9Fpie484+GeSEXfr1KKdnOdRitFBMfcGJieYQaLHcRvSBKGsb8qZ8rkGcD7BflKmA2JMdLH3OPt/LM7ydzpS4EFVAuirCrvKQ4yQpf8BH2ZqNtz7LsqpmBndBi6gYYe4+pntJ19eUvOkyLHz4Hs/8q3vY+zusPzIHILgRzpt3ifSAUCB06AutFNq3Nq5ZFN1S4qyaZrxRECZug5FbotEemt+nrIVgd5FOcO4bCobqr6ieqHteYnjv0JTSxfyZ5mUqOMEqn96ZQczMca+ZpDHuZGzNQrUkzLZS3994stXH6qGjmJ0fQQA2DmhnKbCxJX+O7O14bK6D49JI5JTf/4rlMARgn8uiKaW0nN58yETuVYZK1YXeDyy/+w1VsfMf3zIsuO+kNVRKVr0zRmO4M6iNntWRoqCyeNs36QnWQH7Pl4w5lVeE+/gfJeiSyzuS4/OaeKz02WwTG6uAGH+2rHYNT5G0S4Ybzo8R0jucucUke1ekhVx3ZGDwZoD5Ins+2xwMbJGyB49MffxDOlc5NZnlEm+TPUNOyeE4VuZcuJdkfTJWwzgNrY1uCpjqXrqq2jbvBXhzeDNhOFfgrlW9LoSTqII6pGU1SVUn1yk12okcHTF11oPL4iB6KUCNNHHFKXeYuYkfj3PUHOYspUkMILIufF4RpS8v78DQqg2Y4+4CYjBj1T/VnjLlKmRejL3sxYb779GmK8Y4jJRbGzm
 AYyLwHuc
 7uKZhWHbBIvkeXTCcLmtAAbammpRs0R4LCI1Q21GOPxwT3AYI189FxI70zlOJNVfbu0fCgkiOoJvr1FZPYD+aAHui2yrseL7qo1fYLAbL3iA0w04U0zlAk/ZJ5Be/owgqOAgRGUZD9yT1gG13i3lRVtvjBnApeO9Ccs1lCQGhWkgP4gjdOT+1vA3+7a+ZC76y7XTtrsH8/M8fb1akIrVMKmX3Vxo0YvUsQpXMh4mLq6Ei9p2z1/ZnVosuQQ7myioDpRQTZh/dNcnFcTWdSobr6WcG6vqd54GRgsn5IMj3mTHvHYRXErii2j9db4kqyW45+QoE+t2yLzz/DnbObTwoX83pDI52Gp05im1YdLTvhCzHYk48hR+YszQ7IPpae1AyQQWwiq2E+k7cvugrbkyvkU9ljaTEwy/CFMKU5z+q41SM3J1WijDFwyyD7nZkTGBC7RL14rK8ctM/qEqkFJ6bcVX9WdM7wA4z1wV6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 20-08-26 15:49:13, Andrew Morton wrote:
> On Thu, 20 Aug 2026 16:36:58 +0300 Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:
> 
> > Production incidents caused by bursts of high-order allocations all
> > entering direct compaction are currently hard to attribute from
> > /proc/vmstat: pgalloc_* has no order breakdown, and compact_stall does
> > not say which order stalled. Tracepoints can recover this on a single
> > machine, but they are impractical as an always-on fleet-wide monitoring
> > source, which is what is needed to correlate latency regressions with
> > allocation behavior after the fact.
> > 
> > Add per-order event counters to /proc/vmstat, covering only the
> > allocation slow path, so the page allocator fast path is not touched
> > at all:
> > 
> >  - pgalloc_slowpath_orderN: entries into __alloc_pages_slowpath(),
> >    counted once per allocation, before the restart loop
> >  - pgalloc_fail_orderN: allocations that returned NULL to the caller
> >    (including a successful allocation freed by memcg charge failure)
> >  - compact_stall_orderN / compact_success_orderN: per-order split of
> >    the existing direct compaction counters, order 0 is omitted since
> >    direct compaction is never entered for it
> > 
> > All new counters are purely additive: the existing keys are untouched
> > and compact_stall == sum of compact_stall_orderN.
> > 
> > alloc_pages_nolock() is deliberately not counted: it is opportunistic,
> > never enters the slow path, and its NULL returns are expected rather
> > than failures.
> > 
> > Counter names are generated for any MAX_PAGE_ORDER the arch Kconfig
> > ranges allow (10..13), a static_assert catches larger values.
> 
> AI review got upset about this:
> 	https://sashiko.dev/#/patchset/20260820133659.712111-1-d-tatianin@yandex-team.ru
> 
> > A per-order split of PGALLOC itself was proposed in 2017 but stalled
> > over fast path overhead concerns, restricting the counters to the slow
> > path avoids that overhead entirely while still capturing the
> > allocations that cause latency.
> 
> Seems useful, thanks.

I would rather not put that into ever growing vmstat and bloat it even
more. Most users simply do not care about that level of details. What do
we expect next, per migrate target/order stats because somebody might be
interested to debug fragmentation better?

Would it be sufficient to have a dedicated debugfs interface? The
argument about tracepoints scalability is also rather weak. There are
examples of successfull bpf, tracing deployments at large scales so this
certainly is not a new problem to tackle.

-- 
Michal Hocko
SUSE Labs

