Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ABCBCCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 14:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566598E000F; Tue, 30 Sep 2025 10:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D978E0002; Tue, 30 Sep 2025 10:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A7B8E000F; Tue, 30 Sep 2025 10:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35DB48E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:03:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E193ABB241
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:02:59 +0000 (UTC)
X-FDA: 83946082878.23.90B8AD0
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id C65484000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:02:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dCkBO07L;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759240978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=db4oB+dnmVLJdBFQUKkZOAMclZ3E72AB5HReZPRQbFY=;
	b=m8xyhbsT5J8E5j2qjEfQziFm72beFeixY7KhAqZ8ELylZIAEQgJBdOAWTqWWKXxeCqn9ZR
	3Gn8n0ZjDVsedkSLrMYFAEdoHGT8goAyZLM4u//LdDAjOrbm7LizbLZ4YxyqN1Ii2hI8x7
	/8p1QFicm/q81NL9zO7jYqi7TjDAXWI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dCkBO07L;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759240978; a=rsa-sha256;
	cv=none;
	b=bT3nQvnf5gpwAaQ7ByV/9PhW2Z4gkNRJ7V/ImyWqSKxgptzbVcZbxOAczasDcQ8zCBeOw0
	DsR5mMII/mtv/w+mKuqrR/iJ3kWrYuLWqLwQfIBODvc3AhXsc57ckL+791WMadn6x0LsVM
	AWXLfPS9O8FbAdkviMZokyOpzGfoWvw=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-634a3327ff7so11030772a12.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1759240976; x=1759845776; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=db4oB+dnmVLJdBFQUKkZOAMclZ3E72AB5HReZPRQbFY=;
        b=dCkBO07L9DQE+dfZw48Qjs5I14DHR611ipj56IduVSo72lq8AZT4qBeyHpgDbFZQVT
         KyTFT40zR7EsljStrnfV1tOtu8N/jUvbq0f2bAJrgz8l+d5bXCNlYEHO4v0PARvgkTyd
         /CJug6HhtRkLJmJIGgoKavg21sX82Rgfybp3OY4bWM0rh24i6b3kJPzWe7lc2YcOR+Me
         YVKg+H8fBlj19lBZdmrBbTsZvYwp+vM0OFkWmTcbtzYIDD9TjP6TKUec6kd9BjUsKooh
         tsbzqazBB5/MIHmiMe0jbH02MCnO51QbYO9E6QOcpT5tvnwU84Z4LKvlPjNEIWJYn4PU
         b4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759240976; x=1759845776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=db4oB+dnmVLJdBFQUKkZOAMclZ3E72AB5HReZPRQbFY=;
        b=LZnPJC76LJivgPdP/gmFdKJBvSsLol+Re9PPbqLrnVVbp5y/5Z796sGsfrrvYZlsXo
         JvvQ53zojCVeaPkY7/UpfTTU3FE3IKdbHyELElnXwyP5yscccLLbJ2xRnq8kHaQPF0Ig
         VXbA4ASrq6RJ3ANi3Id+yPHHNKgLPRkcFQVSzayWocMMTVP+M/a0QzGWAoK3HiCRrgU2
         mSZ57YbBWrBrmAoLCev5LJ8walSSYl/ca+YX7vX+U2okKojkUi8Xq0GvsLlbYcdxdzhf
         VkwpJ+sdWOCfg7fsKSri0IJcLWJj+KKCgCosDXIJAGTrPX9gQTdO5xGzSbD4A09O+IH2
         Lrsw==
X-Forwarded-Encrypted: i=1; AJvYcCWvw8MaffTOMAd2JtvXqlJruOejE1F5dWlQ/tj9FhDqw6j8YoXO8W2dsGl3YwgHevWCocXlBM7OyA==@kvack.org
X-Gm-Message-State: AOJu0YyOqGAlW44PjjZCNs2SdbNwbH1/NR1eREJ3xFpl3BwOiF1xjh7b
	D1ErYXZFu6YPXPwxlGwWft74X0pHuxzS5wtm8Cp7Sk7oEFNpvnKYA+tnRoalYIx1YhQ=
X-Gm-Gg: ASbGnct7jASD+ZAYGtjkmBNT0oi+bdMgBEDjL1N8V5waKfrnr9hpy3XG2TKQPJKEjkq
	jDc4vsFEn4LmLBqVU9H5LOP8SltfuPcoSaPIlvdXOf3emecvadXJpBEDm89slp+UNLtNKj+FUVC
	iG6l4tQI6V5xmlYjn0gxCeNOE/cBJcUXBE0lmTJdjxSMN8DEgzJ4zydcerw6MHI4XVFOTYGIHC3
	ABSu+kXUyFWeNpBBbHueqCCNeKhPTH0WUfMjOrbVhA+vRhrM/cJ3mHz8pgN2eOXT2lH9tCBg+51
	PdpLxlSRyxaYirawdVNZ4vYtNsWh3tDp64voYXhODamIuLgWLLcJUeA/OVNrKoEujmSHElPkANN
	36hwNLaJ14LP/WScuvAsLVAn/NpZbLCN+HPyEiZRTB0U4iU5bjoam/SXyT1CaXSYZnchblik=
X-Google-Smtp-Source: AGHT+IEeAKRVJFWvUX+ebo0ADsGSIRuTxkgSHEm/uyOzRMG2ulX2Iq/k1vfZ2HZ/NayCWmtejwwsrg==
X-Received: by 2002:aa7:d9cd:0:b0:632:9110:c012 with SMTP id 4fb4d7f45d1cf-6349fa8a537mr14218078a12.25.1759240975900;
        Tue, 30 Sep 2025 07:02:55 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-634a365093asm9741048a12.18.2025.09.30.07.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 07:02:55 -0700 (PDT)
Date: Tue, 30 Sep 2025 16:02:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Mauricio Faria de Oliveira <mfo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
Message-ID: <aNvjDsBuw3hqwy31@tiehlicka>
References: <20250924174023.261125-1-mfo@igalia.com>
 <aNVpFn9W0jYYr9vs@tiehlicka>
 <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
 <aNY49sdoFVe03m_Y@tiehlicka>
 <d9af42d5cb9d427632087c5f51e50501@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9af42d5cb9d427632087c5f51e50501@igalia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C65484000B
X-Stat-Signature: xoo1ywe8zas86bgusf8kw6qkxk3cxbtu
X-HE-Tag: 1759240977-869194
X-HE-Meta: U2FsdGVkX1+vDoivwbDNgoA7Lm2XkFmihiso2CMcRtRSCwjNHDtaB110P26yOWX/mb3cqU8Px5e2eONfwRpKWZPX6Su4RhW6eqwPCmk9PGnZyHusSbptb21bipgm8idjQVcIMoTAvssWqRLjOGIg/TIGjWLlx6YEJP1lSXvOP2pLkej80rbVTQj2mTkPKXiMQj3ZNMrClVSuymPQWGqcz1jpgiOGkUpMq53+mbsKr0vV8/g+3OMeNNMbkGneb7P7fYoSZ6SVUn2NhcH2PkeqQm0RZDfzlEoaEDSd0aFSsD78j3lJSnRhSHuIPLSE96C5r0tZ3rpyFIxSWcbyr6AaT5Yvjitt7s76HTm57iTexl/vkoqfMC62uBKGY/PNBhiQ3eP2eHfSDqFxc7mHWAE9IXwHUU490ozGtB1zmBf2iWXNsUX9tekE/iIvVG3u66f05aIqNGS/i4Ll61O/e4AN/onUn9SSGA7VRQtEB5oXugxmOxalmCGU8O+3v3qccXUrcd7u8opZ4aFookiUf2jMQSERoq550PEnJLRKWgz74KSe3L9kxteJIKRA/0Qi133MLxqLxmNEN4UGe08hK4HHnLW5NZBn0meycRoTfRujaLsItsaG8r4ZMdcHJvEKA00wLErv+fMh6ko7YlxXU0g2I6TDfjbWM6OGe+pF/QIjzIpyqjyXWU6NGSzYw19y4wgSHI7qA2Fpevm00BZ0C6x+goERdEgi4U/LfETYZFO/zqL/pxat1ASjm3UzttSeB1gyzcuedSjrcPHNwVJmyUXNAefUEMcUFmDYAzE3Ca5SD3Rv2WJkth1DdyYlfc6/WiwJwdd5aJfUY+r4LpYqiFf820rGR5PRKx+jrQpgplPTtLjbfI5dmM7G+x6uNCklGs6pI0akisOBVbOu6HLcXgfDhkpPUDkPZDyAVMb2l95R8lypwkVmMAfPSkgEdTsiQQpLWfTgRGU1WciBFjE+DcF
 U941BKXT
 cieAqI6bIMlh02327nfvDmVKhG0pEWb6+OM3jHqJkvAACOodaQ2WC1retYNt5QKMvuGuxE/ALiTJxZCvEAPOAGQk7t9FdTGwxSBZyIOryYpi53NMUYSop2IDyyx5VcKeUWa9kXCJ3dW/S7/4oDvupDsoBl/6lidKd6LNE8TJhMOCZZp4mWiCW7Ej0m2w1r4ANbEL7Mj1d7dEmS6fSA20mpvBYmPgCA5ubDPm+uz9G/PBbjptQKhTB6lfsP/owIf1/O2nlxyaHDGp56ntgNE3tvdkAVjOafIosBhilGg6m1aCJGycBtzC39Hl1wTuUwSQN/TKktJgbh7ZkNT/Zgrbl7WoKg9hx+I4r3cjeMxOy1Lj+Cj8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 26-09-25 13:47:15, Mauricio Faria de Oliveira wrote:
> On 2025-09-26 03:55, Michal Hocko wrote:
> > On Thu 25-09-25 16:38:46, Mauricio Faria de Oliveira wrote:
> >> On 2025-09-25 13:08, Michal Hocko wrote:
> > [...]
> >> > Could you elaborate some more on why the performance really matters here?
> >> 
> >> Sure.
> >> 
> >> One reason is optimizing data processing.
> >> 
> >> Currently, the step to obtain the key of a strack trace (e.g., hashing)
> >> incurs
> >> a considerable work (done for all stack traces, on every sample) that
> >> actually
> >> is duplicated work (the same result for each stack trace, on every
> >> sample).
> > 
> > OK, that was not really clear to me but the above seems to suggest that
> > by hashing you really mean hashing in the userspace when trying to
> > create a key so that you can watch memory consumption trends per stack
> > trace (hash in this case) without post processing.
> 
> Yes.
> 
> > Stating that more explicitly in the changelog along with an example on
> > how you are using this would be really helpful. 
> 
> Sure. Thanks for pointing that out, and making the effort to understand.
> 
> > When the interface was originally introduced the primary usecase was to
> > examine biggest memory consumers - e.g. when memory counters do not add
> > up to counters that track most common users (e.g. userspace memory, slab
> > caches etc.). In those case you need to see those stack traces as those
> > are giving you the most valuable information.
> > 
> > I can see you are coming from a different direction and you want to
> > collect data repeatedly and watch for trends rather than analyzing a
> > particular situation. This seems like a useful usecase in itself.
> 
> Precisely. I can make that more explicit in the changelog as well.
> 
> > My main question is whether this should squashed into the existing file
> > with a rather strange semantic of controling the file content depending
> > on a different file content. Instead, would it make more sense to add
> > two more files, one to display your requested key:value data and another
> > to resolve key -> stack trace?
> 
> I see your point. Either way works for me, honestly.
> Let me justify the current way, but it's certainly OK to change it, if
> that is preferred.
> 
> The use of option files has precedents in page_owner itself
> (count_threshould) and ftrace (/sys/kernel/debug/trace/options/*).
> 
> The use of output files needs more code/complexity for a similar result,
> AFAICT (I actually started it this way, but changed it to minimize
> changes). 
> The reason is debugfs_create_bool() is more specialized/simpler to
> handle than debugfs_create_file().
> 
> It ends up with a similar pattern in a common "__stack_print()" to avoid
> duplicate code (conditions on parameters to configure the output), and
> it adds:
> - 2 ops structs per file (file_operations and seq_operations, as in
> 'show_stacks'), for plumbing different behaviors down to different
> functions, to call the common function with different parameters.
> - It should be possible to reduce it with private fields (from
> debugfs_create_file(data) to seq_file.private), however, since
> seq_file.private is used (iterator in stack_start|next()), this needs
> more code: a new struct for the private field (to store the current
> iterator and add the new parameters).
> 
> So, I went for the (IMHO) simpler and smaller implementation with option
> files instead of output files.
> 
> Please let me know which way is preferred, and I'll send v2 with that
> (in addition to the changelog suggestions).

Sure, I see. The main problem with the option file is that it is
inherently suited for a single consumer which is a hard assumption to
make at this stage. So I think it is worth having a separate 2 files
which provide the missing functionality.

Thanks!
-- 
Michal Hocko
SUSE Labs

