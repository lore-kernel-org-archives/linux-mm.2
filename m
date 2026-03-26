Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35D9109E556
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60CF6B0005; Thu, 26 Mar 2026 03:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38C16B0088; Thu, 26 Mar 2026 03:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EF96B0089; Thu, 26 Mar 2026 03:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1A856B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:12:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22BB3BCDEF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:12:16 +0000 (UTC)
X-FDA: 84587345472.05.04DBC1C
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A9D3140003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:12:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Zs3Dclls;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774509134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGB0D2sZA54TniG5EwCWeLwF5KVbzKrKiN8v1Y36amY=;
	b=Nff2+LoSaXTW6p5F3xypgPnLJutjHGS+pVS+QyagSmlcfNKOcK8O4r1ZdbuNOrUcpLaKFD
	jjXPLA+iJmglpndzs9n16czcpZKp76Brl4p88dKkCErDkX1yVRZ5DPnis7bEU+ofI0Eq4X
	H1Csx/RYW/K9iJvQYQ/yaQ20F7q0Me8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Zs3Dclls;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774509134; a=rsa-sha256;
	cv=none;
	b=JX/6rFa3wSeOSqyvu1zBGv9F4htVGTUEWifWrbe5RtmwBlkEVHDycV8lX8iw3CeDVvzK0h
	W7eyH1owOhvmH6Gj1s2wAs3qjkaxytEBp/juGIZOILBMeCWBFz2TbPOPX852AlejnbqY5q
	9PHXiZ3Fusnj/gpEW+YUAat1V4zSW1E=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486b96760easo6377575e9.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774509132; x=1775113932; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eGB0D2sZA54TniG5EwCWeLwF5KVbzKrKiN8v1Y36amY=;
        b=Zs3DcllsnCyvIrIZdik/wXsUX+dtBYJfuGSQeD1PpczbRicgeG4jaop2sLSkFr3HT3
         7ERKjUGo65PXIcdkOhUjfHfZH3SilnddYzYY/7nefIB0QZX2jN4H0IxZXKhkYdG+7/63
         E+F2bbEqwJgzsK7zHO4JqSmfpsYeOGyHTWLWtpixklmbqZIBItxlZYrYtTuQxKTSBAta
         Uyy5q4TY01NFaQujJ6UzCvFujA5Wvic/K1ScuQgabfm9ZbPDq5wi/LALFcaXHVsO+C1A
         nwHQ9YLpZqTqi4ZV/Uon6UiT9C0e+e8CQhyhPCt05XC9IHC4ExSlEeXPLIT07GTe0LQQ
         HrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774509132; x=1775113932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGB0D2sZA54TniG5EwCWeLwF5KVbzKrKiN8v1Y36amY=;
        b=XkqKpU5WfmXpVPfTNH0RZLon7OCXjaZfZvFlQmwAQc2ted2h46npqMYJRWpqm+oIra
         K0bwSgvWLunvJ8H8TZ3BfzsZMDto9UB67L8AOessqDLQ8ZaliO0Ct6TURTrSPqpGOqhH
         8RiPzKVcbhO0Umlis1ReI+SPO9rGfC9m2LvTX89GmKwyFRi0RoB/hpZr0eKdvoa6vhaW
         5zhgwlhqCjSjZmIVkHiRDUyp6ZZ/DYHhgMNoQZOOSYyH5UDQeKF2NvMKJiHw4YmA/ivQ
         OE/e25aCispZmkK9eoj40dFC6zx49JfbO+tICn1jC42LLqakiqwjXssq55tGo78LySBH
         S9uA==
X-Forwarded-Encrypted: i=1; AJvYcCWL3mJS+FSHiIprS4W22/I4spdeU1Zgt3Q/glNxi9sSAKIz28JcCgDmH4Tf0xKmqEZEquMCzk4dSg==@kvack.org
X-Gm-Message-State: AOJu0Yyad9VE9cAHGq4EVlBOoP2Trefoja9qTsPy0k9ZhF8UqPBOFUzS
	2bghS445/z6OTGE0Fh9S5AMhyUnW0Rjf3HgKLmOPtbU2Giny2rqAGxXLeTJf67p1HLE=
X-Gm-Gg: ATEYQzwTkSV0Lr8OoWcByobrIUoMbkndiuggIbOfg6JuEdm7u0QQlemG+NuvEeAU2Gy
	t/OotLeaXdJD02/oQtrAzzNPMLTtoaG8sEsWBbq35ImZ6GCVxUylRQasPAFerI7x5UvPY55Be8a
	iMRrZBwOIgYJmupphiyBdWnGpMSOvhWGRK3mv6qyogOfYINN00+L8gw2lhsFCXoUMkeeAeyC0Pm
	RUVfaB7MRXcOZN6N/H6zwGEhn/LvWNmGfdSj6Py4Aew7/XCOMEhs0Ej92cG6o8ubkzSxkZ8O2cb
	cEZwqriCD8c4rg7p8kOBrGTevMRXLMqSrly1y64wFyp4ukJlF4LNfCgh//kLEgWCoYEhmePazHx
	n/WDhcajVAfO1/69euNHB9CPZPEU2b30uSmCWPsZkfd3i1axqOyMoA+MJCjxpAzHji9RU6A5v7h
	/EcweONe0E0vMmNhuHg2FytTW1q5dpgikY81VfIfuJTOPpjBg=
X-Received: by 2002:a05:600c:6308:b0:487:169:9f64 with SMTP id 5b1f17b1804b1-48715fea9afmr90965615e9.12.1774509132376;
        Thu, 26 Mar 2026 00:12:12 -0700 (PDT)
Received: from localhost (109-81-31-149.rct.o2.cz. [109.81.31.149])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4871fb7f45fsm11137625e9.2.2026.03.26.00.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 00:12:11 -0700 (PDT)
Date: Thu, 26 Mar 2026 08:12:10 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>,
	David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acTcStxrTCWAN6Dt@tiehlicka>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325210637.3704220-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A9D3140003
X-Stat-Signature: n7zj5obk5of8djw7jiiae1saz4dp8skn
X-Rspamd-Server: rspam06
X-HE-Tag: 1774509133-369045
X-HE-Meta: U2FsdGVkX19iKH+YCqwDzo48rUbsWZo5d2ybtv74wJSviPNUvS8VETQMu5Gf7YQG+bzEaM4ak4/0osUhye6aykxy++4dFeE3M9eDraYRZXebt3dBfjiFKe5BwV8AQPEk6zdaZGeWlJuWA3dnGAAdcb/iW5EfY+DiClbMkdgRJ+S3J4mk+8Ir+gQvKtTqwUUCU0KUDPA9DTqeSvrsNR3veX41UUHuxfbfDZDUCpOgccUM0IZvPIBOKIyS9agfOfWRd8ZIx0im8rz+g1caywB2TkTNw3WBIQoFDW4Kz+OkfmaYji9YuWPdqmy+fDlS7rMkTH6zVf4fs5JYIMp7LcCqqpp789sbOEW30KdizLbyPfhL75MkVYipO0jBgrdx2dKceuAt2TcXOEQ/pRRijsMqGej5NvTyGPiLcrFH824vVRuZS162Z+JHCciYXfTHqQIuJKNsCu1M0qG+NV4IyfAcDYBHpPefM9AuOdpzQOSOGlwrFdRtBQeAGND2X3izOoS+87b9os3uzofGaXwVzen7wvktjUeBtpDbiTUZUAUHIGa3jGI7nir/+ymFZnkyD7HFjWC0pX1wV3LOriEom5oAXbYMEZvaRGqqh4Qb3liNFp9M4Yj1fgyxK14YWJVWrhqNbbLleYbnO3qY3YvedtJ34aQvhbOF/LYuRvD1a8RAbl25R95b5yJYptsgeHAOrUyKPxJUBNZ+CmEC5l1qm8IGvVIUIQdxQ0mcO9mttR5wgImPk5HKcDpWO0rWX5f0qPVRRFf7vPjNBtkomVPwCUYe0m93+jVSQs+93Fl8LeQS3Z5i77EG0WAWx1VnKhIOdCZXljowaylptQArIpFDdUq3qHyZyCba4LMai4Y7rjmMm0BFMkewC34EYDY9nQjkUTkkR1NF3sSE6ZqFiuUrKH9Z3CCCZdWxesxF75QGy9Cej4XJtdSR5Ax6SUPnxB1dm3vxV94i88nbu87QVk+mZbu
 sSwbxZYi
 MXAadQvpMZuNbdkfYNsVMj3MMlDWHOfrAmxjAhr56nWmclzW+JxJbTfIJ4cDsdz1F3eetWBjOREa1Q1lKhIYzZRPoQLVPOZ2CoFjqlyhWjY07g1dHKo2PxLAs31Fg/h+eIQ/SKQovllyyhz8zTrxMWV/7WVeQoU3vwpFN6KC/S3G34VNgmw2fGuLaeGzCsPyDsZNHRhN1p1r5ZAgrguoj43bAiRYhzH0ZKnBgmodIAuU1HjMcKnqKTtNeVnHnNpBD6gJ2fbx9ecR6UQ8qwlXZse9EX9vUCZbLLJSH4bPP5qhZMYkijF5nqqkn1+uEruqg+ZUKeU4Q3Yejw5CLf476L+CEWLY5siTiKJUeqxV8v0PwuJNpRnVwY/CSDcZ/UasgecCwSl054CI/uWSi6iuj1gLv5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-03-26 14:06:37, Shakeel Butt wrote:
> The Problem
> -----------
> 
> Memory reclaim in the kernel is a mess. We ship two completely separate
> eviction algorithms -- traditional LRU and MGLRU -- in the same file.
> mm/vmscan.c is over 8,000 lines. 40% of it is MGLRU-specific code that
> duplicates functionality already present in the traditional path. Every
> bug fix, every optimization, every feature has to be done twice or it
> only works for half the users. This is not sustainable. It has to stop.

While I do agree that having 2 implementations available and to maintain
them is not long term sustainable I would disagree with your above line
of argumentation. We are not aiming to have the two in feature parity
nor they are overlapping in bug space all that much.

> We should unify both algorithms into a single code path. In this path,
> both algorithms are a set of hooks called from that path.

Isn't this the case from a large part? MGRLU tends to have couple of
entry points in the shared code base (node/memcg scanning code).

> Everyone
> maintains, understands, and evolves a single codebase. Optimizations are
> now evaluated against -- and available to -- both algorithms. And the
> next time someone develops a new LRU algorithm, they can do so in a way
> that does not add churn to existing code.

I think we should focus to make a single canonical reclaim
implementation work well. I.e. we deal with most (or ideally all) known
regressions of MGLRU. In the initial presentation of the MGRLU framework
we were told that the implemenation should be extensible to provide more
creative aging algorithms etc.

> The Fix: One Reclaim, Pluggable and Extensible
> -----------------------------------------------
> 
> We need one reclaim system, not two. One code path that everyone
> maintains, everyone tests, and everyone benefits from. But it needs to
> be pluggable as there will always be cases where someone wants some
> customization for their specialized workload or wants to explore some
> new techniques/ideas, and we do not want to get into the current mess
> again.

I would go that way only if/after we are done with MGLRU unification and
after we will have depleted the potential of that approach and hit cases
where we cannot implement new extensions without going $foo_ext way. TBH
I am not convinced "make it pluginable to solve hard problems" is the
best way forward.

-- 
Michal Hocko
SUSE Labs

