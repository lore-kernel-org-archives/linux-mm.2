Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D22CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB168E00BA; Fri, 24 Oct 2025 11:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3268E0042; Fri, 24 Oct 2025 11:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68BE18E00BA; Fri, 24 Oct 2025 11:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 544A68E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:33:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED7305CBFC
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:33:00 +0000 (UTC)
X-FDA: 84033400920.22.AEBAE94
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E884160016
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:32:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f+SzmS2h;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761319978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFb+WOeWRjNA4xYaoA738u6I2as3i8020Ro6oXjpffQ=;
	b=A99FDMWEs3q+P9lk8iEcKtDR2pSkPH7wdSIyismaIcG+Tme6zNFGwZnVrsmhQv53Ai8og0
	JIiwc1sJe5HCJ4aX7EEQT84J8953LXaCj6V46zMHDYoJ3364Z/O+So4Ge+WnWZT1/1y5ZS
	HGO9eF7RxjhyYX81w89GbOobVy0XlTE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f+SzmS2h;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761319978; a=rsa-sha256;
	cv=none;
	b=Sg+2L38ixlJlilhdPwYwVfhQ5HMc/VLkILh4umA8Y7R5h0C/2xXQeBeegq2EGVf+zsg8FO
	njRw+RmQNoAWYfNMl6ohmh/1iLVx6pymyVKiXuc9yjASOURyauaNLCLAcBzUx75cxIz0+I
	dpW5iLWfmZxK0b50YjTf/5/fi/L2vXY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761319977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qFb+WOeWRjNA4xYaoA738u6I2as3i8020Ro6oXjpffQ=;
	b=f+SzmS2hLcsXi3DXKyXx17gLf1gchs0q4TA0LXGhve7/I/EgX2j5l/sxay1BbUyieq38ID
	cqi5nw7uYi2J9RRm24CvDtHElNIvuojkqWO8JyWipOaABmgKD01ro9+yTDeqmqnRdP8R1m
	T+PaIidl0l5tlfzpJbqaPnNeLtAyYe8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-5q0t_v1APCevzCPhFbZdZg-1; Fri, 24 Oct 2025 11:32:56 -0400
X-MC-Unique: 5q0t_v1APCevzCPhFbZdZg-1
X-Mimecast-MFC-AGG-ID: 5q0t_v1APCevzCPhFbZdZg_1761319975
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-470fd59d325so10094895e9.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761319975; x=1761924775;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qFb+WOeWRjNA4xYaoA738u6I2as3i8020Ro6oXjpffQ=;
        b=NPYLoQn7xNFvEdGSIq/j2L5pchHsAhdp+j7dqE6Jpm0F1bN6At9aIjAU3k9t9H0pSx
         VcEfKvvRUtQupR468nvwP6v/Zz+RNYViTRqogYYC0pmKENQXSJ8DEh/r8h/oUksD9g6A
         8pdqQaFlKaM4bsfxeWSxW1puJOOqXE/96D6lNL+kUdsc8F9U3OtwVXcywjpVjY5TilRY
         +TDhgtK/OR8nuSnTxyrAEKj/dQkovfya0guue6L3mpi6X5q66HyKcJRUQoefU5MOvAxY
         c2qSVDKgPlCMoRf5Bl5se14SGO5aeja5HTSKRVzQJuLQItabx4EGI82NyjAFWnGYyMq2
         tpAA==
X-Forwarded-Encrypted: i=1; AJvYcCXfEI24poJobirFcdGMDOF9XtHnGUauBkI2ZSf7sf3NvaKEuCUP9ArC768w1cdsSUisDFvzfmE7nw==@kvack.org
X-Gm-Message-State: AOJu0Yzw/taevO8uLUIuUR8HwqrRcYeo1WQy/xjtDA0RUQ89rmHMJLVg
	gaHLu8VlN7pahy7/iuzZWpwoa5Q9fNW7OT1WjoqySKGdRiUUHNgiYV8/hABzb7AdYE1QX+6abAX
	teV/pTYJYkPSRgiTG6uTFfsX0pozBAauTXjY0Dw0Gt/thiqJdS1Jj
X-Gm-Gg: ASbGncuvfrWcWxiiz3O491uTs6Q9UFa58QgYhs8m1j2AX49NDDRBWMLZs3VhSzZa246
	hhNIHkTFrW4//61ntfb6X5ZpMIqqcpsD2l/wMmIZkfcg2nJSfQHLIgz6Ov/0K4DuhZwF0i9Br+V
	3LksUtQBSvmFmnQB2HZER19f+ltvf2GeqGad4I2NEVcRxS2CkFVkfF76uSgwC+O4VnE8eVGHwel
	/jlStN1tDhr9pN0Sn/+IMTWxyLXb5FcI4Nwfh+6llvSNUVe2Q+xUlD8JbayjlQDNxEmkge2TQtg
	RWX5NuCwOzFFQLZpMJIlGmfEBcXTJfUbTucufcmWOx8VNxDGMLBSn0zKINAItr86gI6GVJKXKWw
	bacjxyl9ublGB1abH/GsixEUp34pR0z8b83zoO/OEIP7kKt2sooiDPZJJXNrrfbCQ8fT8WfpOw8
	jRQjlME6a2v1jBUj5sE8/53izLgbM=
X-Received: by 2002:a05:600c:5026:b0:470:bcc4:b07c with SMTP id 5b1f17b1804b1-47117925d38mr228933365e9.37.1761319975217;
        Fri, 24 Oct 2025 08:32:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEk3FLSarboUuhSt9mQ9AgqM+55zrUrrCCjoH7Es1EmB3qSUYkMO5a7UnFUEL85UmUL54f5qQ==
X-Received: by 2002:a05:600c:5026:b0:470:bcc4:b07c with SMTP id 5b1f17b1804b1-47117925d38mr228932985e9.37.1761319974703;
        Fri, 24 Oct 2025 08:32:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf2ef9fsm97056175e9.13.2025.10.24.08.32.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 08:32:54 -0700 (PDT)
Message-ID: <94d62ba4-e203-408e-9200-b153ce97555d@redhat.com>
Date: Fri, 24 Oct 2025 17:32:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph
 consumer
To: Alex Markuze <amarkuze@redhat.com>, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com,
 dietmar.eggemann@arm.com, idryomov@gmail.com, mingo@redhat.com,
 juri.lelli@redhat.com, kees@kernel.org, lorenzo.stoakes@oracle.com,
 mgorman@suse.de, mhocko@suse.com, rppt@kernel.org, peterz@infradead.org,
 rostedt@goodmis.org, surenb@google.com, vschneid@redhat.com,
 vincent.guittot@linaro.org, vbabka@suse.cz, xiubli@redhat.com,
 Slava.Dubeyko@ibm.com
References: <20251024084259.2359693-1-amarkuze@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251024084259.2359693-1-amarkuze@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sm_f65pV3itP-ZJXscYGLdoHYZnVM9Ps-S-4974RIkY_1761319975
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5E884160016
X-Stat-Signature: 7rjnprf9pb77jpgfqee1iuikxmuzfdw5
X-Rspam-User: 
X-HE-Tag: 1761319978-165832
X-HE-Meta: U2FsdGVkX19rVByl0654j4ivr2QAiBO2tUBJT0bYc54AwoDi6BDQTHU0HPPW7TzU5Zwb4q+Mq5+qgSVsQ9UeYHF8KaHlxoqbZEVZpTO12t9Svd/uYygyeqZKzSTobOLmufE51UscLaTZuc8Hzfl9lgY4me1xsZVGUXxQDTvMJ+n5warXIu4wKg5UUxeUtF9/krJVFWrtQsbnmn58OIddHrF9mlhiVDoputmTumJRN+orIynsptvK53QnLqFjq+kt74bkBJXY0iw/kBEN0tnUsTW4SAR5++5nnfztcfWplqj7ZUGxFd4j8meQsOG8hW6hSR6wcOvb1LpLstg81l1MIoO4rDxf7hlkjETwObEKKMVIgQjCFEHJprC9ZV40i3xQjvoMltL+WY/Oj4/g488NDA85p8pw8TQ6BN/j2yqs89qs9Jhlmt+RPBfiYhLmkFkG0lloWBwRXJJS5jCDAGeObFipFiWzHhnAKKTrr0AvKbK49ElSP2XPH7p3H5UtQlK/Ge4NrvJS+f2DaIX4nxcpPSUOhupRxKKs0Qnm499Eqje9QilpUAsLx6qhMnxrkA/0/BQjmmHc3bmc5F74YxA5NdzTP0stcStffYFulueE/ID6sxa2Ih/9btE1RbTE6kP0MhfC+hs9kuW3TyUa5leAvo3cGW9tgJ4mh7sNTjjVC7xNQpD7DhvZjUPwyoU/GYJVFn8kUYLixqfi05W4i192rTUGUnKqeWc8eZyhJTRlaEDMwGgL+ufcnG+fKbvxWBzRGZK78u/xFFG+deFyQO4/yJROTHGta25+zrZO/WNNfyRXOLwI1Mrd45aix5iZVJh23jcH53Plwc2t8yMvKsLYEtrfLPs80C0VAE343IJI3k6nQktLHsbVyOPq8bk0FJ/r4COZRtOP5sHn5wqR8c1Qkm2jStr6628d58tJNTqWqnRDEcsXfuOzwaquyWU+Uh3fRxeJejgIQI9NVqFYRdg
 E4zoHTS0
 w8xZRbUly6Dgm8pmTLloDp/q6mmXW6pcHplup7DI21FPnzYD669cBw+Scu2WN97TyZ4wdmqRidsxI/j8rLc6HT6Z9wu04pI5TUuSRdR90plNKIUzsZJHoUdo5fBvB91iK8qHOrLwY8AMiOZRPTmQNukzLTgK8JR/yRKxcHO1shREIArIlR1rqR3sSY75Qrl9AG15fdnAKVuI6NMqj18m/71DVYfwnrp0Z0fKGEgq7FOK3bIu1RUB2X2ypYmeRrB4rr/E+ZHqhq5sD6TXivfMDWpDF0vNF5Et2BNwdosp6MzFK0T56At+jkFHD2QPt2FpieAsqoV8i5kzJYiIIGlkAsLETR/JuCxDcmkfsQ2iS6IfVruO8jOBZKal9h++wd/3zxisSHPSX/eop7Q8gEn2QICbyu+JwhfeHDN0xATpXsO0XkQyquitvar9bEom1UHkl9PQajuK/EN3RyAE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 10:42, Alex Markuze wrote:
> Motivation: improve observability in production by providing subsystemsawith
> a logger that keeps up with their verbouse unstructured logs and aggregating
> logs at the process context level, akin to userspace TLS.
> 
> Binary LOGging (BLOG) introduces a task-local logging context: each context
> owns a single 512 KiB fragment that cycles through “ready → in use → queued for
> readers → reset → ready” without re-entering the allocator. Writers copy the
> raw parameters they already have; readers format them later when the log is
> inspected.
> 
> BLOG borrows ideas from ftrace (captureabinary  data now, format later) but
> unlike ftrace there is no global ring. Each module registers its own logger,
> manages its own buffers, and keeps the state small enough for production use.
> 
> To host the per-module pointers we extend `struct task_struct` with one
> additional `void *`, in line with other task extensions already in the kernel.
> Each module keeps independent batches: `alloc_batch` for contexts with
> refcount 0 and `log_batch` for contexts that have been filled and are waiting
> for readers. The batching layer and buffer management were migrated from the
> existing Ceph SAN logging code, so the behaviour is battle-tested; we simply
> made the buffer inline so every composite stays within a single 512 KiB
> allocation.
> 
> The patch series lands the BLOG library first, then wires the task lifecycle,
> and finally switches Ceph’s `bout*` logging macros to BLOG so we exercise the
> new path.
> 
> Patch summary:
>    1. sched, fork: wire BLOG contexts into task lifecycle
>       - Adds `struct blog_tls_ctx *blog_contexts[BLOG_MAX_MODULES]` to
>         `struct task_struct`.
>       - Fork/exit paths initialise and recycle contexts automatically.
> 
>    2. lib: introduce BLOG (Binary LOGging) subsystem
>       - Adds `lib/blog/` sources and headers under `include/linux/blog/`.
>       - Each composite (`struct blog_tls_pagefrag`) consists of the TLS
>         metadata, the pagefrag state, and an inline buffer sized at
>         `BLOG_PAGEFRAG_SIZE - sizeof(struct blog_tls_pagefrag)`.
> 
>    3. ceph: add BLOG scaffolding
>       - Introduces `include/linux/ceph/ceph_blog.h` and `fs/ceph/blog_client.c`.
>       - Ceph registers a logger and maintains a client-ID map for the reader
>         callback.
> 
>    4. ceph: add BLOG debugfs support
>       - Adds `fs/ceph/blog_debugfs.c` so filled contexts can be drained.
> 
>    5. ceph: activate BLOG logging
>       - Switches `bout*` macros to BLOG, making Ceph the first consumer.

Hi!

You CCed plenty of MM folks, and I am sure most of them observe "this 
doesn't seem to touch any core-mm files" and wonder "what's hiding in 
there that requires a pair of MM eyes".

Is there anything specific we should be looking at (and if so, in which 
patch)?

-- 
Cheers

David / dhildenb


