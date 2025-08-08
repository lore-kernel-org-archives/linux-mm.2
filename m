Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B2B8C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 08:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D605D6B0088; Fri,  8 Aug 2025 04:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11A16B0089; Fri,  8 Aug 2025 04:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00656B008A; Fri,  8 Aug 2025 04:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFBD26B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 04:58:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6067C117BEA
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:58:33 +0000 (UTC)
X-FDA: 83752989306.30.FDD71B7
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A1634000C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:58:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IFkVvUHs;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754643511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOQVbhQSKupTIDYGcHNIv/5EXRTeGhpJxZzqsjXmSWw=;
	b=6Z+T5h9JwNRLjlvsZckVtcTOJ1CIkd3mLXV1A4pLHhBKOa3BIae+6IHd0VbepYXrcQ3X1r
	kx/BeX0RT6wyj91NOiLgNQ2aY4JLrlrlHBA5CIjOv47LDqjcnxRqRErJI+pxEjGXB0GHul
	MU1OQfjJxf2UpTcjwzMh91gCzx/w2p4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754643511; a=rsa-sha256;
	cv=none;
	b=Kuay125Qx1xFPSsb3EvX4NFAplqPjxKykgNt4UAapx7lAegLZMjAKGa7JsTR81PZkFvd6I
	zeWhkdAO8T5Qd8gge9kp/29yO04APtX89RUNJPkSaRvsRSACXQyVUsLrliuN3gRWlqfwAr
	1+/4kFnXSOM2iHfJ2Pez1dBOxUkRDww=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IFkVvUHs;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-459e20ec1d9so18153265e9.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 01:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754643510; x=1755248310; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lOQVbhQSKupTIDYGcHNIv/5EXRTeGhpJxZzqsjXmSWw=;
        b=IFkVvUHsujHOSyN7gLJkivUs9vXCXtoBCmytuBPnIB/ZYwgqVQDfOHf5yul0qGx6C4
         WtDfhZc1jKpneTKyMU50sEtNWpHf3i5nD4uLvHsd+JAhLA8Wo3c+PBI9ux2VDcMDeaQd
         0cgl3GGP/9l/QAWvBiQj3fx1sCp9lzR6FjSRqZYj+S4CeuGju34iGwO+5Wl+L7b/QcMv
         XqbkBndsPqkUS5WzLNzCCvC9gwSV64hlYjbWr1syf2mmdfw1q/J8va/pFSaD5csqRs9G
         khb8JmFIazkgI48ToO+XmIqyDMxMrIx6AiKzjVyKXV9VtIZQxcDAtoXK7skVW2m8+agM
         q/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754643510; x=1755248310;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lOQVbhQSKupTIDYGcHNIv/5EXRTeGhpJxZzqsjXmSWw=;
        b=HGNMY00kXCOiLQ8wkYFngNyMQ+5xSDFVnyrHuVIhKRJ7+0+730DdWEUSQ7aNyjvFlB
         VlmKgIjhPVfOwmpdtATLPAGrMN0HTIqB7/AP69CNnvHvZGayz0X162vvd/Y14nmW7Ldy
         VccxmWiwVGfN7TH+JQeNbWsFXMaaXPQb/bUsyPGvhgjPwoTEHlHh51goguNwfaspNcg/
         T4ghRffF2pYimTl9rsVRlTI4X5WUoR6cQ7v+7YSKtxx4esYjJs3G8VWL47kUgTjUXkAz
         ugIwXeo5C1Yoyl81JOgjQ1vJZpTG5A+ankA1Y7y1q7HMggJYJbqij7L0FU/YL22p0SmM
         EzMw==
X-Forwarded-Encrypted: i=1; AJvYcCWuOGw1hDvh0vqWZ6zjmHAdZ/TvxZZna87EXSvLtw2XpwWUtBiDy0vTT9Irc+BnLkvIZOMR/9fRAw==@kvack.org
X-Gm-Message-State: AOJu0Yw/1M9mwlAfM6Z0nBpVPFfunI6fy17D0sy8WnfImDkzxpzqLXh8
	6AA20qvI5evPMc//2zXGhIrBcFFdAedhyInoCrjzxSUN9ljumnF2xqTgVrKGUHvp/bc=
X-Gm-Gg: ASbGnctEBqGgL8pCH2ZMgur8nzQ3GXGvzQgvmXiA3E5e8OBx2wAEX2kgfUHwKNiq/0/
	TS6Pyye3R6GLCNeAD8MHmq3PT+Pd38WitG3obe+dEizDQQ/04A8Uatf0Gl4swYZtna3Q5l9Fk9Z
	ouhL2P3zJFh6Uv3FwoBD2F55DSfOZaE4gqGIIpxzgKiFdIOSfyQ7lE4TvA3LaAdL8CiG1EvfVau
	p5LvnQp1kcut3TB524BsF3srHeEffWw9OFfL4XIPPPARiQYU4jzcusjz6oP+Oj/jKSmloLERN0N
	V4S92a56xE7h/0tWd9wtt9pV5aeZ94ZHnJC89gFTTmEEJq7hLUHS/g0LnZYofBBFoo0w1/JUUr/
	UipHduTkh8FuE8PIENufyLqh2TLkd804tGuk=
X-Google-Smtp-Source: AGHT+IFzVmndy14yZFXdn3AITFDDpuqCDmasSizVoBUj53EPQz0livj4I20cGXLIqIwR20S7zVle5Q==
X-Received: by 2002:a05:600c:190b:b0:459:e048:af42 with SMTP id 5b1f17b1804b1-459f4fac94amr17073275e9.24.1754643509756;
        Fri, 08 Aug 2025 01:58:29 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c47ae8esm29556901f8f.61.2025.08.08.01.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 01:58:29 -0700 (PDT)
Date: Fri, 8 Aug 2025 10:58:28 +0200
From: Michal Hocko <mhocko@suse.com>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
Message-ID: <aJW8NLPxGOOkyCfB@tiehlicka>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
 <aJWglTo1xpXXEqEM@tiehlicka>
 <ba9c23c4-cd95-4dba-9359-61565195d7be@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba9c23c4-cd95-4dba-9359-61565195d7be@kylinos.cn>
X-Rspamd-Queue-Id: 5A1634000C
X-Stat-Signature: t3ty89xqoei1ppu97bhwomuicaq1qix9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754643511-701586
X-HE-Meta: U2FsdGVkX19KJ3JEx/pE2dEv8x+G3QxymLOmFkQQW5vgXSCHH9uN8dQk0cKE+W7m1X0YasPdv7iWInD3Yi/U7MvjraGYcPt3Mjx9gQza+MEAs6+2HlvNrq7db2eMG8+S1h20yh9CHvN4eAYINJLIn5pXnKT8W0jvOHQBeYPEBXh3n4rHw8bTPS6xySBzb19WLUNx1h+s2ArHK9UPjRYFqZ67iDKr52jmHpc7bn5ap4QHYhezHDIQw3bVAF8+u1IppauH9T82w/jdP95ZoHeRj3/vrzlO3+JhTMXQhYfxtYAX7aSRHMycaMlnIEcA4VZ8KozO8KSQLjSnECsktEPimhgY+oFTSwhnlY4BtNGAIn81vgY04KHWr9ZuJvnjjPjuWl1rGiQiCTgIGZW2GKtIsaKvg1NicPJOpSNuV7c3ZZ7bk0Ox0aXko0/8UcS7cqu/N61E70zf6m+KH83xuiFX6cE2pbBrgtkr0fryy58on+8D4Or4XHTD4gOPz5udv0MkddK6tXz9LHDJuVJwZTZ7Id/c9BbUWqcrOreWn/TF9Q1izPGP+K0WO7sib6Xg9otBmKsOxMGzn0GKS0KaWX0xyxUE+z43V870f/Zo9qbk91tVG1+yHp3pybwhvKXgbZddnnfbcg0tWwbXJEWpy+CKYiOZxHf6gxZkbWaAs2+VWuOFKr00vbTQjZXHWuegbg9M9fX45A228WUO/gHIGfsgH2nscdMCZCaZB5wp1sc2q6Ab934kDvmp4s5ez3kwIapygxQPtee+EAPPQUxXr9GXaxYToWmWmqeKwsVpxbv+J3RqCAAqk/cXqyIUUUm9Cb549hGcabum7J5I6jSyrTvDXY63r2lwYK75uxvA1Pc1jK2fhk0GxSu8U0PT+Vyz+ADfI6gbB8aLTR4Tzzbv+d3Dg8c8uWK0hVzu/J2Z9iTLDIYP9B5GniB8TXJxEKAKrhaDtQV54ewkgZ3hqubmAtk
 h+phrK6L
 zbPxWbpzYh9tTqRPGeo4D2f/bccYZLas3Z0pOyXA65iawyALXCkiO9M/CjPzon4uw7dzmkH7Y9XUiILJjm/odtnpyoWs3CTQd7cy/KYZ598dp2H7SREFgsuYAPDfpPHfnxrbfbEMgipWc2S1zUAe9KK8UoJpLbsH53pV6hQmuIiq1f/cGNgEzM/Bq5HGpqeoT68AHDcVHz8u3kSzYub343wp7QxdHFMn/XolbS1nTF/LIDtpJerTQ9O59BlxjupSP64+ncKWmItQ/j9aqsRGQ5hvti+M3O5whV86he+D5n5F+ljTIAo2+CxNbby/pcZZiH/vSJzFiKuCimgbR7tOpCdZW/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 08-08-25 15:52:31, Zihuan Zhang wrote:
> 
> 在 2025/8/8 15:00, Michal Hocko 写道:
> > On Fri 08-08-25 09:13:30, Zihuan Zhang wrote:
> > [...]
> > > However, in practice, we’ve observed cases where tasks appear stuck in
> > > uninterruptible sleep (D state) during the freeze phase  — and thus cannot
> > > respond to signals or enter the refrigerator. These tasks are technically
> > > TASK_FREEZABLE, but due to the nature of their sleep state, they don’t
> > > freeze promptly, and may require multiple retry rounds, or cause the entire
> > > suspend to fail.
> > Right, but that is an inherent problem of the freezer implemenatation.
> > It is not really clear to me how priorities or layers improve on that.
> > Could you please elaborate on that?
> 
> Thanks for the follow-up.
> 
> From our observations, we’ve seen processes like Xorg that are in a normal
> state before freezing begins, but enter D state during the freeze window.
> Upon investigation,
> 
> we found that these processes often depend on other user processes (e.g.,
> I/O helpers or system services), and when those dependencies are frozen
> first, the dependent process (like Xorg) gets stuck and can’t be frozen
> itself.

OK, I see.

> This led us to treat such processes as “hard to freeze” tasks — not because
> they’re inherently unfreezable, but because they are more likely to become
> problematic if not frozen early enough.
> 
> So our model works as follows:
>     •    By default, freezer tries to freeze all freezable tasks in each
> round.
>     •    With our approach, we only attempt to freeze tasks whose
> freeze_priority is less than or equal to the current round number.
>     •    This ensures that higher-priority (i.e., harder-to-freeze) tasks
> are attempted earlier, increasing the chance that they freeze before being
> blocked by others.
> 
> Since we cannot know in advance which tasks will be difficult to freeze, we
> use heuristics:
>     •    Any task that causes freeze failure or is found in D state during
> the freeze window is treated as hard-to-freeze in the next attempt and its
> priority is increased.
>     •    Additionally, users can manually raise/reduce the freeze priority
> of known problematic tasks via an exposed sysfs interface, giving them
> fine-grained control.

This would have been a very useful information for the changelog so that
we can understand what you are trying to achieve.

> This doesn’t change the fundamental logic of the freezer — it still retries
> until all tasks are frozen — but by adjusting the traversal order,
> 
>  we’ve observed significantly fewer retries and more reliable success in
> scenarios where these D state transitions occur.
 
OK, I believe I do understand what you are trying to achieve but I am
not conviced this is a robust way to deal with the problem. This all
seems highly timing specific that might work in very specific usecase
but you are essentially trying to fight tiny race windows with a very
probabilitistic interface.

Also the interface seems to be really coarse grained and it can easily
turn out insufficient for other usecases while it is not entirely clear
to me how this could be extended for those.

I believe it would be more useful to find sources of those freezer
blockers and try to address those. Making more blocked tasks
__set_task_frozen compatible sounds like a general improvement in
itself.

Thanks
-- 
Michal Hocko
SUSE Labs

