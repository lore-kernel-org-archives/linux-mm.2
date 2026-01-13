Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67899D2D108
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0E06B0005; Tue, 13 Jan 2026 09:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BC06B0089; Tue, 13 Jan 2026 09:11:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E366B0093; Tue, 13 Jan 2026 09:11:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A8E0F6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:11:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 750FE5648B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:11:57 +0000 (UTC)
X-FDA: 84327129474.27.CA65E8D
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BD44100004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:11:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KouDXRNh;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768313515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQeUllddCLGPs0eraWtlh6AK1o1Gp8YJboZb0KWOg4s=;
	b=PNM/Izh5eUnPG03X7N3kzk0ZC6StnQgE8a5tHv43lL7drw7axK1XCOPlRSEeT6cCzyxCh8
	Ppk55KXH9raSi09gBNAv3P/8o2Kw4s4RkRuMf07yCRgamb9m8MswckIoS5ceowDg+XjSnf
	7tatGGslqBsWpcudhptChc/of3tV1Ms=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KouDXRNh;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768313515; a=rsa-sha256;
	cv=none;
	b=2JrD5SFf31+NicVQUDfBRaOYO2rbtZM2cysxdsKYy+RF/5vG7w+z7e8rkXwBm6b2Dk12Gl
	TWfFyLDmQhSFV7TxfWzpudzL2mj6Wunv/Mibh+Dx7dLCSTGeE+HaB2Qp5Fl+nMGGDr832c
	vTLmDZ4TpCgsLaSwyE86k/GhUbLM1k8=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so83423885e9.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768313514; x=1768918314; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tQeUllddCLGPs0eraWtlh6AK1o1Gp8YJboZb0KWOg4s=;
        b=KouDXRNhb3yPP0kMystX8XTZaSOcjuAKP2F+qxCTAgy9uVsldICk0oaCdlBbkb3+gG
         zQv2QCcRbKpGN9irYONxmTLIPk+CqEFa/kZehwQpBSAJMO+BghWkEtLNgmVJgHU3ha2p
         zuLQv7cg3xfLUZssSNpknXm2DB9GYe3wm4utVS1X1c6yi6PN5CAYRaSp1cSX1S+6maLG
         a9cfIlz8E/HKJqPF3JUZb8SJWTA8WUz3fC8BSJk+uQMwnS5ETsEsZofBecw1wmiSlVSF
         7BEd7rQTTHkgNI9PibxPx6/ruSh1SQCy/RsTy8V7PM79ecxuErnIX6WZ+zgF83o2L9X7
         cB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768313514; x=1768918314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQeUllddCLGPs0eraWtlh6AK1o1Gp8YJboZb0KWOg4s=;
        b=H4AdXWtCTsNdhSbP2N7YyCsd7JQfVBa6B908CPSgDWZNhlhllZ4+/jI8l1OP9dh+5g
         jjOgJOpMh+BUpmOPHI12URbEafMU/DVxRamQnTAT21dGlh5POFc3MEd35ZpG+wzZ3DVq
         Wx1exWrEJm7kT6MXWgDCMZVHXa4OvQBhLIr06TjQgAGer3bSzNwn1fJegCTXxPlXGQID
         k4VjusogfyAVfE4hxiTL1sPFkjVLEFyjej0Bapb2G1DAq8OiyIFcdLASmUqy9QWToK68
         nuXfDFN+lyaccu5KUeJ08r09IGw4wQjwSl1OD2r2hemeyPUwMTChTRzvWMiZCQuCInDT
         8akA==
X-Forwarded-Encrypted: i=1; AJvYcCXkqqpchEpBcr8dp3CB1+Ss/cYruY400rTVpC+YKgfGHiL7AvdphLIvAYQzJFJLgAsNeRESlMsgNg==@kvack.org
X-Gm-Message-State: AOJu0Yyp7QT6uySuSx77bTqlSLDqSwW7RqAsUV2hQAriCxPoypEjyiUW
	gw6Z8qvroC0G/NcmU62rZ6FoZMubKvDgcR7Px7BXjixd2ocHUToEKxFVMR7R0M+CAic=
X-Gm-Gg: AY/fxX5BVJ22li5EcsTtResSJy4xzu7TptOPc2ZoCUtZk3bNBTFtLFqn14oCMnr+r2l
	Lt0Z8yIzTI3fCaQQA0w8ueB2/BrCYgsgNvNKqy1bF74+/HIk6Hf15ANe+g4nTOHhGmSyR5H7tGh
	sZkp2qAjT1vpJs8aiz2G9KNclJnRqWV75Cw9ky6KBwsgoPJrszCEoHA+Aguic7WxxclwQkqiUYY
	U3b+1RY4NysS3AOIRQw89ReDgjnFnuqsSh/LplLDSfivFsW8jQWtBiIKqqfjYPa3JD97jEIe9vF
	GCw35NZD0UXtxU4infv9NxXmEc4coO3/QisY5gyVgmIAz2knltnPtJ8T/V4WOS/XooyxTwIynvj
	qLOeLqB3dJKgS5R/c/tqZw3QJbIyWe96mO+NYhfSPgq1IFPJlVqe5cYnubNYNUWCWys3Kv8VVcj
	iLaXmVB1nYDGqdEw3XctaQiUeK
X-Google-Smtp-Source: AGHT+IHyggS3qEwURO+dzayczEUAIkKcmNZxfMg4n0ab7f0L4Lj6EymBbmGapVEZIooJxC8xoc27vQ==
X-Received: by 2002:a05:600c:820f:b0:477:aed0:f40a with SMTP id 5b1f17b1804b1-47d84b31525mr225996635e9.19.1768313513736;
        Tue, 13 Jan 2026 06:11:53 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5df96asm43642097f8f.28.2026.01.13.06.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:11:53 -0800 (PST)
Date: Tue, 13 Jan 2026 15:11:52 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v13 2/3] mm: Fix OOM killer inaccuracy on large many-core
 systems
Message-ID: <aWZSqIrbJW9q824H@tiehlicka>
References: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
 <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
 <aWSz5OHBwtfYrruu@tiehlicka>
 <f2c04264-17ca-418f-bc43-e8aa6fa6cd0d@efficios.com>
 <aWVP9sPqG8VC8Oq_@tiehlicka>
 <b779c646-64c7-49f8-8847-8819227e3f1f@efficios.com>
 <aWYPWNIv4lR2FpUZ@tiehlicka>
 <c99778c3-6ef0-48de-98ac-10913419ec90@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c99778c3-6ef0-48de-98ac-10913419ec90@efficios.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4BD44100004
X-Stat-Signature: xxcxdfn83eemumuw1dej7pundwwj7r6u
X-HE-Tag: 1768313515-673051
X-HE-Meta: U2FsdGVkX19rfgJT/HWz6H0rqMF0d0vRm1AaTre/H15BxcxCr5anoL4pT8D94+tti7nXvjSgAlH1W89zz4+Uz7Bh07Z7DMwtetHx7MlhLl7zLZXI4eBVFKywwdLPm+ZYHRxAto79Hu3TrXvGv2RRob3IFqk8NQ0XermivKG6ZFgWuNuPGysGE6EquLZHC4Dv562pRBscpcsujkQU7QStVKbd50v6Ke61kjDmNO+g5CG1x8OFOI1y2+AaiR0N5oQ9eH758NiN+K1mTr/D+I3837XV19Mxu3HGsPIUmjXqXxwTrxJRBi4fNcWAfeOJal2k5VIumrXIjYmz43r3twzQPi/4uN69M8hOlwTWVdEiM5RQAEEPDed1FSmmoRaqD/s1ZXkkiJWzC+bjMQC0n7HsnEKyPxTKqaIxvJclxS/7O5SqpjxaQl4wnsiWUgwpOw8VxqOtjZAQDVFo3B5QmdcQNLNmyiWJYxNcAa2I8kuCyQd2R8nGqnHaNOrGwaprv0tED4PbUfj1QW0fStc4WFSNTvLLG0QgtOjPqX8TML+KbHNN4k/fEfPJXFNLUm2bZkY2Coqj1qohoK++aCQ51Atcib1nl6Gitug561xfcMR8vE33wfY1Hk9XWrZZSXT4c3zDda4BODzvrOyEEe3XZzQTMDZzhBjK7iAdXSV5BBataWSYA0H396gmoXmSyz3Ldq+FeL4tasFdTfSunCxi9Bl05gwAl+eyWGLDIcUGyIE1v0Se5LKqFcYwki972mv9H89dW81og/GKC/Tz6OGIC+WXIwrWRuGUs8WVqy+lZWCwPpzPFNi1lfI2bWlTgjJf+WVfiCxewfRbA9EemngoEYKl8iDn294siN4RfJqqkYvorKQ1d6B6MDHsxDC4SikgmzEkH+p5/2pjlIdMz3fEmPZdZuJudW17S6UUXmXD2pPZxAu3d21b3egZ1gmUzzyPaP7w7/UvklAPk8QaSZWtTJy
 tIRy/mPE
 brdkoeO67eQYOVcMKyLnJVpvI1MHmb1RAeziH3qtV3LijEFoeIX4BAgCVq4SDbkd9QOMyF+bn0oas/1lmBms53jPy9nk8hl9xPEhlRYjScFSHWgvFK5kbvz0lUrNNq8UQ2G5/5D+/H56sPM1DThxGO04ZOseh7jmo0RU1e9Ae2f7etI1+q+Q8eL+OJ5jRqbw6eAV1UNGNrYZw6ni2jaX/ZcSDNGUpMeLdiGDpV73Fx4A+EV2z084ylHDckyzilNgHm8qgphgt9K7iR94cWTwlLP5uVD6chJBYfhlo4Q1JZHftCtUIFFHRF+3CDtYN0dvjQDKrfjeEmNHb3/9v1Vbb8XNr7vrDofACw5adSlesNOA/7RlUEtyBd1hZvXlwscmBekBmgSAWau5UNuuHo5wRWQIKT38h9ZHaAoK6vL2yKHN+XOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 13-01-26 08:51:45, Mathieu Desnoyers wrote:
> On 2026-01-13 04:24, Michal Hocko wrote:
[...]
> - Introduce new proc files, e.g.
> 
>   /proc/<pid>/rss/approximate
>   /proc/<pid>/rss/precise
> 
> Where the "approximate" file would export the following lines for each
> page type (MM_FILEPAGES, MM_ANONPAGES, MM_SWAPENTS, MM_SHMPAGES,
> allowing future additions):
> 
> <page type> <approximate> <precise_sum_min> <precise_sum_max>
> 
> And "precise" would export lines for each page type:
> 
> <page type> <precise_sum>
> 
> The key thing here is to have different files to query approximated
> vs precise values, so we don't have the overhead of the precise sum
> when all we need is an approximation.
> 
> This would expose all the bits and pieces needed to allow userspace to
> implement something similar to the 2-pass algorithm I'm proposing for
> the OOM killer, but tweaked for other use-cases.
> 
> This proposed ABI is purely hypothetical at this stage. Please let me
> know if you have something different in mind.

TBH, I am not convinced this is really needed. I would simply use the
new more-precise interface for /proc/<pid>/stat with numbers of
potential overhead payed by an increased precision. If we need to revert
to low precision then we can do that based on a specific report.

> When you mention "highlevel doc", which document do you have in mind ?
> Something related to lib/percpu_counter_tree.c or to the /proc ABI ?

Documentation/core-api/percpu_counter_tree.rst

-- 
Michal Hocko
SUSE Labs

