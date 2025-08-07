Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59195C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 13:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7DE6B00BF; Thu,  7 Aug 2025 09:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF6F6B00C0; Thu,  7 Aug 2025 09:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5AA6B00C1; Thu,  7 Aug 2025 09:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B82906B00BF
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 09:25:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 533E482728
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:25:39 +0000 (UTC)
X-FDA: 83750033598.17.EB0C187
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 40C684000B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:25:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AtQmu1Np;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754573137; a=rsa-sha256;
	cv=none;
	b=l2DZ3DqyZ0d/zy4Dvd3zcp2O2j/CEDW671L+Seyf+E3JbKSayqYMNI9H14VrGL85q0fLH+
	W/Vc3KsEDfNJT4sFPne3IaW07RowSLDO0/+z0IrAlm6CKVamzusHEVS26tMP2m8xXfLZAk
	lWKoKwFtgXlpA54PMZXwFktyQsV/6+8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AtQmu1Np;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754573137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkK/h5wyW78slTbM7rfscexueduuSs96e2Qc2RW5gY8=;
	b=cuvHjdxwxPuutY+FxDGgrqx8NaxttpdkO4C97ldJU7cIBGTdCCvlIEmfWyRR0U1duxj4q8
	UUEj91uhrz9UhxAvnGSxaFrvTjkFKIAI8ec/fLq4FPgkl3b1XbNe/xTjyI304t6ua+I0VA
	22ZkmlZTYA+DY8fTR7OLxKdhZbm6Lac=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b7910123a0so845797f8f.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 06:25:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754573135; x=1755177935; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QkK/h5wyW78slTbM7rfscexueduuSs96e2Qc2RW5gY8=;
        b=AtQmu1NpzlGcylks5PJBAubyL0T2dAyIsws3TsXI9i1mwpbG2n46GcVhqYtMsjtJZV
         AYY9AGBC6WF8YXRGeaLlPrn30TBRFpdxUKamRoSMQ4TJ9zWg+dwUX45ri0Fgb+AEaemd
         Wy7WRplBfTyb52uhvgkzzRZKYx+7H9Cqx7ok4v0/ksQ90X2ryyctBnAWhx0/9GzuTbHm
         /q01UnebvMvXLz+zjkykVTJ53ZPsNGXiCzw9Cvm4N/zY/VGSD2VVtQG2lEHlX5oa7lmG
         sHjkGR2eZvQJtabDQQwErG8u+CqlBBqvl16LFucBIuvA0B6qLfNLLvHO2h5yDrhI/ocY
         yAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754573135; x=1755177935;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QkK/h5wyW78slTbM7rfscexueduuSs96e2Qc2RW5gY8=;
        b=do8rW0S1IRJbS1xUi3XTJLoAamdC1MQsRR4TPOKHOiaJezzK+AZdd36b/8FmVWayJO
         3XTlW4v2yI5nWfHX9t8ngCn8mibRnt2HzN1Ngva3odVPT2AJm5fbDfguBC4/pdibMBU5
         VLRxCzSWZQqw1T7ptd8KDVCimiwQEXd9jUTXzEpWFMDl22Amd9IXDbmX5fH8f7A3zi8E
         9B2Cq4L0cjRgzrnKkkJn2/9aRFk2GeNR5eOCwrbfEY+DDQiFckVA+Pec3ReLIdLA6g6n
         HAwvySjn/V1nuzDNkxFxCkMKnkbBb5RaviTX2jD77+hhPArNW7Pqd6hsF1PsxlZe7I21
         bFfw==
X-Forwarded-Encrypted: i=1; AJvYcCXOsMS4/BX9TYCmfvQLhLUfPoTPTHIvSNSdzUrqxaW4HFWzeF48qATlmgEeo1IRgi8o7owwDels3A==@kvack.org
X-Gm-Message-State: AOJu0Yz2LWqKfzzb8nCMYYAEc77Gwx1r0gug0pC5NSco/aAe+znsmrIg
	oel35iyHWZ9ZwfMS6hAVxv7hYJnomGmGoMd3MXqx+suWiock3Qeal8nYutf+fSzLdUY=
X-Gm-Gg: ASbGnctw5Y9RRDe2qVHyUTxwMO5D0RtOGoHu/8CtCXe+NC/jJbn1sb2c8rEFNjzeqAB
	2VTwLXo5rPd2iDFypyHBWjY++/CS4NzA0t5cZyXt/DHZ+zc2NUAZXrXlvV0WEDgRvW8TLarn71O
	6P3KUTJj+lzm0+nkNKZR+kZraTKY3NieBszVdKoVufh/Q3pPrMehlXssacESVW72N+sJFgsO1I0
	nqmh6G6O1SRpQAT30POH+T6J4VVxlQ5iMC2/f+gZ+WDMkAvqQiH4FCtWPYk7zR0R0Tt7wGRjZyO
	rB/z2ggmYBkV8RpsU27unyKdjcPSUj4Mtc1vDPDd8n9pRvDjguDNocpjQW6F6r0Sy62zRaj+4yi
	O+ki0v1I/YTH511/CZA6zMkfJzpx7lgjfppmomeaiSaW7tw==
X-Google-Smtp-Source: AGHT+IHQ9dMmpvwSG0LG+OsU60Voye7P7DJOnU5DCYn4cofMlrbc+GKVT9M1/0FDZpZM67dPsg7qAw==
X-Received: by 2002:a05:6000:1a85:b0:3b7:78c8:9392 with SMTP id ffacd0b85a97d-3b8f4166f4emr5537116f8f.19.1754573135392;
        Thu, 07 Aug 2025 06:25:35 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c453ab0sm27171452f8f.44.2025.08.07.06.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 06:25:35 -0700 (PDT)
Date: Thu, 7 Aug 2025 15:25:34 +0200
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
Message-ID: <aJSpTpB9_jijiO6m@tiehlicka>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
X-Rspamd-Queue-Id: 40C684000B
X-Stat-Signature: sq7zn8o9gj36ju169ku1ocrajhb8pxj7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754573137-726811
X-HE-Meta: U2FsdGVkX18A3gap2p/jHynaTCNrBMmMaI6iLYROloZ/Qd24HOsQwiyC8h481KvrAibDLa3mMRSnOYQ+E2mHnv7ZXczeRZVsKUtOTHHx2ravzUDSewjLZwgFnwZaH94bXPEX1YZHfqTeiPX7cttFwHabzRq0M6enCfThiVp9/CWet+Rcm14ABzS12NdgJawEwwTRMEktQ2IjXSsFQuT9UHRaNWWxvHvJk1UzFGcEMa2vIajVLurlAYyYxOwYMfDkZxncEdNtQCjbDK4plyzs1wgjUrknPjpDjwl5Da5t6oX23Kas5kPybvd01Eywdk6ihf05bu4MErwam3RDpa3pr3Jd20vqcC33kBF5YcMO4y2Gt7+esWC9Yw6nX6zS12r7uNvGIyzFA2WaCxQfWlClnTrXEDTNw51chIvAQ02he1Tt01j6eqtYtsZcX3SmCpH2An+fIHLU1jN0VB62NGU8ZPnID9Pm0Zg/9FxmVabDmxdDAEbJWp9+Olk84AvrZ9e73OvJ9dJyjBEYfSwwYZFsf/OrHIVZ3ls6yoEmh0tzW9qVvtiDyyO48d4OnfSVzMalEBUlvWOKEVqtHrI1zwRlk+wHPp79SuwflMJA+BfKEG8V0Xke2SS4/QaDw1K/nvZXJRVPZC5Yt2mui3HuUIcjletV6SoYCOOP841wjLlK+e/9a0m70ko/84P2/BmbKcDX2UM+cydXiYWh6VIqxXmQVyFCPhhc9cHqtTnnDkzCNmc4D0E87CrW/B9rs2x+BUOo9ZMPDzZuvXEOjW3ow+QCEbAnLV62YX3ArH8bQ+MpeX1eTlLMqtcZNdQfuXY3sTQ+7nQeVgDBL0+xJbAUbvgTR9l0lTc9MImxOWMs1idWmWmBT3MCygLopV0xX30phZ11duKqc9SDqBeWxp6unhmxgLjc5JdwwZXCi3JlYBlMKaiQayyRzgXlnOkIDRUBJKks2Wio7/BSeFuYIrCdYSs
 8TD9C3r+
 Oc8tGO8E+VeHWkqrEr+uLWGUtzNQ0KsHonk7S/oTBKYQVE7AAQAccPfGqbu0JdpoySSXiaKIpOs8dIi88NFYELpVYZ+RhJbgigYoPyiR+bSc+5OfJZBWJI1Rx/ezgyfZsFOzucZvZeoUgMNA7Uw6OsyZvj4Co879j/zMw7mPVmEL9ruJqrCi2MWdiexfV9QKyhGrhIfaug/GL2DVfUbOg79nsfNb+x56saieb8HxxrzM0Y4pEizzYFuK2MyrhbWcptPWSgskjChOhTTU93NmBSxotgtS+iDhLGeyerqusvv/zpzIYIWtXKIDYfpr68CqXRpzudeVFvs4uObw2weXySOgJrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 07-08-25 20:14:09, Zihuan Zhang wrote:
> The Linux task freezer was designed in a much earlier era, when userspace was relatively simple and flat.
> Over the years, as modern desktop and mobile systems have become increasingly complex—with intricate IPC,
> asynchronous I/O, and deep event loops—the original freezer model has shown its age.

A modern userspace might be more complex or convoluted but I do not
think the above statement is accurate or even correct.

> ## Background
> 
> Currently, the freezer traverses the task list linearly and attempts to freeze all tasks equally.
> It sends a signal and waits for `freezing()` to become true. While this model works well in many cases, it has several inherent limitations:
> 
> - Signal-based logic cannot freeze uninterruptible (D-state) tasks
> - Dependencies between processes can cause freeze retries 
> - Retry-based recovery introduces unpredictable suspend latency
> 
> ## Real-world problem illustration
> 
> Consider the following scenario during suspend:
> 
> Freeze Window Begins
> 
>     [process A] - epoll_wait()
>         │
>         ▼
>     [process B] - event source (already frozen)
> 
> → A enters D-state because of waiting for B

I thought opoll_wait was waiting in interruptible sleep.

> → Cannot respond to freezing signal
> → Freezer retries in a loop
> → Suspend latency spikes
> 
> In such cases, we observed that a normal 1–2ms freezer cycle could balloon to **tens of milliseconds**. 
> Worse, the kernel has no insight into the root cause and simply retries blindly.
> 
> ## Proposed solution: Freeze priority model
> 
> To address this, we propose a **layered freeze model** based on per-task freeze priorities.
> 
> ### Design
> 
> We introduce 4 levels of freeze priority:
> 
> 
> | Priority | Level             | Description                       |
> |----------|-------------------|-----------------------------------|
> | 0        | HIGH              | D-state TASKs                     |
> | 1        | NORMAL            | regular  use space TASKS          |
> | 2        | LOW               | not yet used                      |
> | 4        | NEVER_FREEZE      | zombie TASKs , PF_SUSPNED_TASK    |
> 
> 
> The kernel will freeze processes **in priority order**, ensuring that higher-priority tasks are frozen first.
> This avoids dependency inversion scenarios and provides a deterministic path forward for tricky cases.
> By freezing control or event-source threads first, we prevent dependent tasks from entering D-state prematurely — effectively avoiding dependency inversion.

I really fail to see how that is supposed to work to be honest. If a
process is running in the userspace then the priority shouldn't really
matter much. Tasks will get a signal, freeze themselves and you are
done. If they are running in the userspace and e.g. sleeping while not
TASK_FREEZABLE then priority simply makes no difference. And if they are
TASK_FREEZABLE then the priority doens't matter either.

What am I missing?
-- 
Michal Hocko
SUSE Labs

