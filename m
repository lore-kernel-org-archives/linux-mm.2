Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8166EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 21:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F17A6B0005; Sun, 12 Jul 2026 17:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9786B0088; Sun, 12 Jul 2026 17:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E176B008A; Sun, 12 Jul 2026 17:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F413F6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 17:32:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68CDC1C9346
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:32:07 +0000 (UTC)
X-FDA: 84981422694.29.EE97FCD
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 820A8180004
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 21:32:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GMsy2TbD;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783891925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZTw5ebndj59SW60Cuk+CY+pvjsLxjMDKRujQQgs+Vk=;
	b=g/RV0ZRhsWDSbE3sTJeJBwlukK+r1Ko9SGk+OxjNzyW6Sa3TJwrfLf8UvdP66AK5+Fix/O
	d5mQDeqqwGWBEn3Mk0kz+mpL/+4iWCL9WqeYnX4Ez5TKcODFlxr5orXuVpyCWIE4UUo1CQ
	t7VIQgH7n+cA3oxlAJAAFmIcfAkHl98=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783891925;
	b=7KrnO5ogRyy/hmy0MzGDY+OIsZ7GH3kjk3vE5noIo5tT/KrO5EDXuexYMLaKXyc7FaGNK3
	nQy5YVbtugTaptYjfWwG9sLsAhVdL1ZBEJPXehHYqc5j4D8u5XzTHPVYKHf72SU/7uk4iG
	FZ2ZlcjxPTgZOcVzhHSZBdp2Gm1bsxA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GMsy2TbD;
	spf=pass (imf16.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493b27c7451so43018035e9.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 14:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783891924; x=1784496724; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kZTw5ebndj59SW60Cuk+CY+pvjsLxjMDKRujQQgs+Vk=;
        b=GMsy2TbDx150fC0hRMtVVKGuFaaHYKaNVe76r86waThp3JhIrxBdYzqpm8SvxC4IJp
         ec+yOgL2JUdu9vovCtmZkG1s/0gnyMRY9FrqdoL81+qsrpmmnFlO7xwGilQxR6hWTqcx
         YPylZjG9g4sTRyf2B2zOAKGcLz6JdlYQyIED0CBEa9Dg+CfeGxpHVXJNcV1mpBxuWbsO
         YLf9ADeEE+IOi+V3BWWH0B0IVODJMwVtZSsUO5ZOVCreD09K56QtNeqgj0chokLmRiAv
         SXLvI6XMbYEsnIExbvZk4OMSyiUeH9hfZ6ukjkv7mlQMryPKk/gqMMgCqmuO4k0CH09w
         nrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783891924; x=1784496724;
        h=content-transfer-encoding:content-disposition:content-type
         :mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kZTw5ebndj59SW60Cuk+CY+pvjsLxjMDKRujQQgs+Vk=;
        b=Y9Oq66MCEuzf37ozXOKoWpSj3SqIyxoZiaUVzOoX319Ngmr2208sA37Hr6eusjmbqm
         2NlYaNVeu8L7M69mvgf4UPyNBhHrMrQ07OJRVVH/f6FDOiDXgEPTr2FIdUdhL/Xwsznh
         xLLJ8qmxM1wDqN03m7TbUTmc2kp99GTt2hF66c0yWE3Mw7fm5UaDkDvwhs4DLrwJAaxi
         4ozpvXCm2hT/9XOMao7HoeANFQpsvx+hVQwvjXx9uFR0/M2aJIk0BZfBMTTbqq0+V4gt
         ZIbKl5L/7s4rL3rQOyfTobzYcL5+H1JudN1JtwQGi79NK6WMgVIG6o4gpn4qBtorjYJ7
         WcTQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqf2MJ8cTntObSVBYR30mF/HkGcvXGaJrd3a2pkvRWKcc2UEGpMcfTisStJZD3XjzsJmv2SRanI4w==@kvack.org
X-Gm-Message-State: AOJu0Yyfvx898v/izpQAHdxP+0ivu/TVIi+ysUMUyFI/dxhLIBTRI9XP
	nwuJ46E2Jq6fd8VPy5e5Ah/2nVGd3EHUDl9bYHf3+1N70Rer8ddR+Q0F
X-Gm-Gg: AfdE7cmSn6o8kQ7WgNaxhEdvDcqbWL2uKbKCE5/7cNPSO7fEb7lvpVOq64bINVGcI4Y
	09Fl2PODm6A3GxN5K7lRa5YyQchZR3OdkdsrjRzUBM19gc/OuqRP3l59CIU5XWL2QLD1lb2fZDo
	k3ldXkMc8J4dFd7FmWwMfbnrMXCD7rofSy4nDoCBm74wZXqkMoUf4UgdtA2do4uIiF2nd+yRRvW
	IaucXTsS/u/yK4cSBUfNyVwUPUHpTLjE87U+ZRoRbORi/BTNmv8LQTIjuB0/HGeqkwAWrcg3UDh
	VrxnOvdewT6dLdKxSgsb90bTJWYUkf9MRuGkJ/Z1o5gU54n4EJJ/Qa0ETMtH0G57js7SPNoTpXE
	RtoM/7sjmAG+0ZibYZockcm4WN6n//KjGSzLzewG5oJLoYOjzEl7iDpT0IRIoK0I5gcMgoezINr
	4rEj+KWSxaSlGpvD/V2xJuaikeAbcp5E1J
X-Received: by 2002:a05:600c:1c27:b0:492:3fb5:3a17 with SMTP id 5b1f17b1804b1-493f887ab70mr70822705e9.2.1783891923923;
        Sun, 12 Jul 2026 14:32:03 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f61:3b01:d08a:833b:756:8fce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6df417sm332803075e9.8.2026.07.12.14.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 14:32:03 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush work
Date: Sun, 12 Jul 2026 18:32:01 -0300
Message-ID: <alQH0VK2X2smhaWQ@WindFlash>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <87tsruvv6z.fsf@trenco.lwn.net>
References: <20260519012754.240804-1-leobras.c@gmail.com> <20260519012754.240804-2-leobras.c@gmail.com> <87tsruvv6z.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 820A8180004
X-Stat-Signature: nj8x6yjsh76q5z6rhja6y1gxwepm9hqz
X-HE-Tag: 1783891925-762373
X-HE-Meta: U2FsdGVkX19hunqu11jGWcAbUX+eTeuPZSSDdf8uex9oDvR9VeVTQNHxkxT9NuDCWrvZngAMOcfy/XFbXRsR+6eG3OkxRZJDjhVhJqsnXE7Pr75MhXzxbnn+m5utemWVMzrSTVLdjkqd4eBhVDPG6B3aWEjAHkIyhM9fozYWYX8dZoA9ZxBusIdzhqaXyUcw0UNikZoNSF7efqzb05xJFXauh4mQWktwox6rwbSuU9hdcLUXRuoCtDLlkRBKwqkbJplV98KcxBIKnJy8aC9+f4yFXiyVkqLJJMuAOjbnHLsVBMG3xy7dqhrnyCtkYprFzDvPUswcfupgjn8Ueot1FqT2fWtrlOzKIlp2YRY1bh/cD7uSbTzyQctqPOgxxfTuxLhX1SpuKWzLfOI9mf5D8FirPfTOoslYCQ+WPX/crEmV6FqHw7emhlS+i1yxnE0k7VtHomvjsCedSSvOlYQr8nqsDbbDrszQL1hzgLxkcihgWOcUuyuIGE3F8++cHfN2CoOlAQNiDDumnYE0QqVeIX5hFbd4vmq/0j8SnDFQ5F0fgCzs9/y1p+0IM4pP5DwZ6bDu99wn0gVhSa4x7pat4GB/NKRpLebife92TTeo4GGATaL5VD+NtyCKpEcmEAAVCwrZGS2XcEEOROM5fBNFJEkmARVZ2gryeCAxW00atzR0+5aX18DVUZzNYcLrX+sbRO8sPGvrdubnv+Hrfq1KW5iZIDfAKLirCpMiCu7zRS35eLelRSoAFuR60PREdOeI53rZIAn2g4DyowX6Tn7OQqZFXixVjFW0j8TD98mGKM5x161tc4Z/RXtrLO+kxFD8fITMj4jSL2vMSGfHbHvZ0N+gd1UXc0hWuQ/8bjZIeK4HR2URw3h5fpcECQN6ZznwCVq4du6xds7DA4ygHsyXgyQC3vBHJRuzYbVsZB0QSYBL0kEulL2ugzzT0tOjWI01irHJIy9uPJNxpa0azlR
 6pstarkE
 wjjem6XeuFr7KKtAyLU6O9kmOwccATqWooKfzyEijeJhQi+GvTsmgos5Y2i5byF/po9nBGt2BFzLYto3Tzu0pOSlcDuSvRJYXWfB7f0asYmdOyhF6QqsNGQ9LamfjodoPh7nPsmRPq7Qcr60KEI7XwTve1MC2o2bgjbYuM8zxmQbtXDSiUQZOfTqoj/L+aRQFENb3stkFhKyrzFmIABhmJGbTLT6dcXAA7U9ubA3XnqWLxts7q2VyGLksVhP+Yb7rRxxLgz9PVo9ffPzYilSNPs9eQAoxIR1w31ZLX+p0yQ1QV8uQAjtw6NTG9AGWoJLEAukkzq1G7/HUoZtJKLy38s4XGikuYipXqYS/S+vSk51tt4LXyUsMy4rfnvRFzFg+4cY0EpNwLaprPFMhGu4HtgkclqOaac2NW8AYLos/gcQMcrr+DomW2xy4F5LvfTbg3wKPc6gDJMlZIH+SfyMfHKy5ckjuuHMmVvp++Ht8Y2xEFIdFP26ZMb4p15+r5TO5kyne1KsvjcpWbPmDq0r6MSNdvocXxs0ipotoDtvGbq2/R3PG7LAH0eupT7X7q725mD9IV0AxqG/jy41Js3bA9FMiSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:15:32PM -0600, Jonathan Corbet wrote:
> Leonardo Bras <leobras.c@gmail.com> writes:
> 
> > Some places in the kernel implement a parallel programming strategy
> > consisting on local_locks() for most of the work, and some rare remote
> > operations are scheduled on target cpu. This keeps cache bouncing low since
> > cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > kernels, even though the very few remote operations will be expensive due
> > to scheduling overhead.

Hi Jonathan, thanks for reviewing!

> 
> A couple of documentation-related nits:
> 
> > ---
> >  MAINTAINERS                                   |   7 +
> >  .../admin-guide/kernel-parameters.txt         |  10 +
> >  Documentation/locking/pwlocks.rst             |  76 +++++
> 
> You have added a new RST file here, but haven't added it to the table of
> contents in index.rst.  So it won't be part of the docs build.

Ooops, will find a place to add it then :)

This part was added by Marcelo, I have no experience on adding docs to the 
kernel tree. Your suggestions will be really useful :)


> 
> >  init/Kconfig                                  |  35 +++
> >  kernel/Makefile                               |   2 +
> >  include/linux/pwlocks.h                       | 265 ++++++++++++++++++
> >  kernel/pwlocks.c                              |  47 ++++
> >  7 files changed, 442 insertions(+)
> >  create mode 100644 Documentation/locking/pwlocks.rst
> >  create mode 100644 include/linux/pwlocks.h
> >  create mode 100644 kernel/pwlocks.c
> 
> [...]
> 
> > diff --git a/Documentation/locking/pwlocks.rst b/Documentation/locking/pwlocks.rst
> > new file mode 100644
> > index 000000000000..09f4a5417bc1
> > --- /dev/null
> > +++ b/Documentation/locking/pwlocks.rst
> > @@ -0,0 +1,76 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=========
> > +PW (Per-CPU Work) locks
> > +=========
> 
> The over/underlines should match the text in length.
> 

Will change!

> > +Some places in the kernel implement a parallel programming strategy
> > +consisting on local_locks() for most of the work, and some rare remote
> > +operations are scheduled on target cpu. This keeps cache bouncing low since
> > +cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> > +kernels, even though the very few remote operations will be expensive due
> > +to scheduling overhead.
> > +
> > +On the other hand, for RT workloads this can represent a problem:
> > +scheduling work on remote cpu that are executing low latency tasks
> > +is undesired and can introduce unexpected deadline misses.
> > +
> > +PW locks help to convert sites that use local_locks (for cpu local operations)
> > +and queue_work_on (for queueing work remotely, to be executed
> > +locally on the owner cpu of the lock) to a spinlocks.
> > +
> > +The lock is declared pw_lock_t type.
> > +The lock is initialized with pw_lock_init.
> > +The lock is locked with pw_lock (takes a lock and cpu as a parameter).
> > +The lock is unlocked with pw_unlock (takes a lock and cpu as a parameter).
> 
> Did you want that to be an itemized list?  If so, put "- " in front of
> each line.

Oh, good idea!

> 
> > +The pw_lock_irqsave function disables interrupts and saves current interrupt state,
> > +cpu as a parameter.
> > +
> > +For trylock variant, there is the pw_trylock_t type, initialized with
> > +pw_trylock_init. Then the corresponding pw_trylock and pw_trylock_irqsave.
> > +
> > +work_struct should be replaced by pw_struct, which contains a cpu parameter
> > +(owner cpu of the lock), initialized by INIT_PW.
> > +
> > +The queue work related functions (analogous to queue_work_on and flush_work) are:
> > +pw_queue_on and pw_flush.
> > +
> > +The behaviour of the PW lock functions is as follows:
> > +
> > +* !CONFIG_PWLOCKS (or CONFIG_PWLOCKS and pwlocks=off kernel boot parameter):
> > +        - pw_lock:			local_lock
> > +        - pw_lock_irqsave:		local_lock_irqsave
> > +        - pw_trylock:			local_trylock
> > +        - pw_trylock_irqsave:		local_trylock_irqsave
> > +        - pw_unlock:			local_unlock
> > +        - pw_lock_local:		local_lock
> > +        - pw_trylock_local:		local_trylock
> > +        - pw_unlock_local:		local_unlock
> > +        - pw_queue_on:         		queue_work_on
> > +        - pw_flush:	            	flush_work
> 
> This will not render the way you expect it to.  You want a literal block
> ere.  So end the text with "...is as follows::"  and indent the entire
> literal block.

Will do like this!

> 
> > +* CONFIG_PWLOCKS (and CONFIG_PWLOCKS_DEFAULT=y or pwlocks=on kernel boot parameter),
> > +        - pw_lock:			spin_lock
> > +        - pw_lock_irqsave:		spin_lock_irqsave
> > +        - pw_trylock:			spin_trylock
> > +        - pw_trylock_irqsave:		spin_trylock_irqsave
> > +        - pw_unlock:			spin_unlock
> > +        - pw_lock_local:		preempt_disable OR migrate_disable + spin_lock
> > +        - pw_trylock_local:		preempt_disable OR migrate_disable + spin_trylock
> > +        - pw_unlock_local:		preempt_enable OR migrate_enable + spin_unlock
> > +        - pw_queue_on:         		executes work function on caller cpu
> > +        - pw_flush:            		empty
> > +
> > +pw_get_cpu(work_struct), to be called from within per-cpu work function,
> > +returns the target cpu.
> > +
> > +On the locking functions above, there are the local locking functions
> > +(pw_lock_local, pw_trylock_local and pw_unlock_local) that must only
> 
> If you write functions like pw_lock_local(), you'll get automatic cross
> links to the kerneldoc documentation ... which I'm sure must exist ...

They will be added at this patch, so I will add the () so the link works :)

> 
> > +be used to access per-CPU data from the CPU that owns that data,
> > +and never remotely. They disable preemption/migration and don't require
> > +a cpu parameter, making them a replacement for local_lock functions that
> > +does not introduce overhead.
> > +
> > +These should only be used when accessing per-CPU data of the local CPU.
> > +
> 
> [...]
> 
> > +#else /* CONFIG_PWLOCKS */
> > +
> > +DECLARE_STATIC_KEY_MAYBE(CONFIG_PWLOCKS_DEFAULT, pw_sl);
> > +
> > +typedef union {
> > +	spinlock_t sl;
> > +	local_lock_t ll;
> > +} pw_lock_t;
> > +
> > +typedef union {
> > +	spinlock_t sl;
> > +	local_trylock_t ll;
> > +} pw_trylock_t;
> > +
> > +struct pw_struct {
> > +	struct work_struct work;
> > +	int cpu;
> > +};
> > +
> > +#ifdef CONFIG_PREEMPT_RT
> > +#define preempt_or_migrate_disable migrate_disable
> > +#define preempt_or_migrate_enable migrate_enable
> > +#else
> > +#define preempt_or_migrate_disable preempt_disable
> > +#define preempt_or_migrate_enable preempt_enable
> > +#endif
> > +
> > +#define pw_lock_init(lock)							\
> > +do {										\
> > +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> > +		spin_lock_init(lock.sl);					\
> > +	else									\
> > +		local_lock_init(lock.ll);					\
> > +} while (0)
> 
> Sigh, I guess I was over-optimistic about kerneldoc comments.
> 
> Is there a reason why these aren't inline functions?
> 

I could not find a way of making *_irqsave() an inline function, so ended 
up using macros as they looked simple enough (and the underlying functions 
would take care of type check). Already working on converting as many of 
the above as possible. 

Thanks again for reviewing!

Leo

