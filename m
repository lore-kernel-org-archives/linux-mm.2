Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C2F1094481
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 03:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A776B00B6; Sat, 21 Mar 2026 23:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B8E6B00BA; Sat, 21 Mar 2026 23:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6CE46B00C0; Sat, 21 Mar 2026 23:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D38486B00B6
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 23:08:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75E4C1E4F4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 03:08:30 +0000 (UTC)
X-FDA: 84572215980.24.9AE2917
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 35CAF40009
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 03:08:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iq4aSW1B;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774148908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=to1VE5KCZRkEhvhMb90xNxfk6LIxqdvQwXLJtGlmLy0=;
	b=mfDakZ1PM8GgXVAuE4KIpsZFkPjKiZQFcQ9EGmPwE1IUj7HvwlLTrC5sva1gw3sIHNDtCo
	yGy25Z9fNJCu21KAVkvsWEYKKlgdnrQmAtatFm2lX+U7f5Y3dXgIwJGqjls2usc3R6FPWI
	2QWdi+YxwkZKFDT8Ye9RkJ+Pu3hKI2o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774148908; a=rsa-sha256;
	cv=none;
	b=hYMFs7wfcdAL/HZBsAQJidbEo/vRq8+vb+UsEJfTg0QxcyAuyOVVnOMSs24wT/i5e3Gad1
	8R/P+/pxGGzWc4wWOafhsvz/W6dsDQoacc5iyVoKvOQueg2Oty3Xrfq7iGlChQGQD4yj73
	OBYU65Bxu2+vKANrS+KCOBGvw1JPSwU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iq4aSW1B;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774148907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=to1VE5KCZRkEhvhMb90xNxfk6LIxqdvQwXLJtGlmLy0=;
	b=iq4aSW1Bcq5kKLi/n4Ttyv0cwSS133Ewc7yTfbCylq+4/Br8wppZvS8GTcJBvr1jql4uZ8
	faF1BbxZEDZEvDy8ls777aQ3NO2YNJd4RWm+vH7o9pWLxKKf/GGPIVjO667pjYOlRXgddV
	iETWdJUDTZ7EUK2DI71U4NO8tp4Iq84=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-2ZQj_haQNliRONde-2TOuA-1; Sat, 21 Mar 2026 23:08:24 -0400
X-MC-Unique: 2ZQj_haQNliRONde-2TOuA-1
X-Mimecast-MFC-AGG-ID: 2ZQj_haQNliRONde-2TOuA_1774148903
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35b9894f9ceso3711060a91.2
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774148903; x=1774753703;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=to1VE5KCZRkEhvhMb90xNxfk6LIxqdvQwXLJtGlmLy0=;
        b=nEIzLa1xMYgks63tHpb5L2YsDde/LbVzY6Be+khd/sfBpxUS7OknPiEaOH6GYgQPO4
         dExRe2rPkRRtRTyXCdlt1Qh+Od8/JU1d/fgKxuK7mOU7ESAHJRA5f8kNE/cSkmDLXeqm
         X7jJU5yUsE7KHF8/i47GDJCJLJsFZx5yrOiCrr3jZkOOSyzRz7MslaFRaqRbwbnjADlP
         GzVwn4EDGnYweMxYtYQZ4ETYKqq7uOw5b9LQ8uqTzlzHBtaMpnawtEq3SxbZtk5FA7Yc
         n1o/PN7yF8jNx5VWEZK7YX8VMLiYa1zfR9DVf/TlUflc3SuYxy9IQmIqzUbiXg+mUSFh
         hpcw==
X-Forwarded-Encrypted: i=1; AJvYcCWdNADOomPS17GTYBoYbiCMJX6z/Lc5Xlefk4t7+oA0KDA61v9Gs6elI3XWAyYccxrhCcRRk8W59w==@kvack.org
X-Gm-Message-State: AOJu0YyUB7VCNa/y3xxf5EnooFf/ROOlRZgp+oRXF1Cq7K8Q6UtISyYj
	/FxE3SuL0ekQuO+MkGZpQNH5VL2kJYgMF69ZHBwnyZShO44AElCFDrQMkZOJ/SFzgArS4NKDykX
	eci3JEB+APGm3fdFyI1qdfCEWE1aMYxAtYJyyKfADr677S1x3azKV
X-Gm-Gg: ATEYQzxdRhA3SuWg7usve9MAQRf+F8NcGQ2j0vBeT9MgHdhGF6ixTwIZcxhWLyZbVBm
	aZFc0p4oXzdHTYIQIcpYEq+1IEbebTMWO2m/xPD0Aq3t4J84USWoR3ApaNdWJbO9jq7tNAgxdbK
	dUE+bO6B3w/Qn0UgDses/KbU82ydimnIjVqNn98GQnjjGFAhRrXzmlQFIDk4xvALJgE5UVuN2qr
	wFuvuaUgtvXgdsk5AbEdsjxFi/WfMi7P0W7vO7KwKe7MT62sIz7MZLCfSpaBpVnQiq8EhrVs5VF
	iZhUT2VUT76Z2dZ6oaxN5JFfJn8K6CtBXHTs4x7ZtQPzCb23EhZ2QdjKmsAAAB8CtymGLwOEYVG
	zScTsvjCVJScOJeDgxw==
X-Received: by 2002:a17:90b:4cc9:b0:35a:329:73c6 with SMTP id 98e67ed59e1d1-35bd2b97774mr6439630a91.3.1774148903271;
        Sat, 21 Mar 2026 20:08:23 -0700 (PDT)
X-Received: by 2002:a17:90b:4cc9:b0:35a:329:73c6 with SMTP id 98e67ed59e1d1-35bd2b97774mr6439609a91.3.1774148902855;
        Sat, 21 Mar 2026 20:08:22 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc610c232sm8435153a91.13.2026.03.21.20.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 20:08:22 -0700 (PDT)
Date: Sun, 22 Mar 2026 11:08:19 +0800
From: Li Wang <liwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry@kernel.org>, yosryahmed@google.com,
	nphamcs@gmail.com, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v3 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
Message-ID: <ab9dIzALKPQLb-SX@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
 <CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
 <abPEALhYmtBnEULi@redhat.com>
 <CAO9r8zMciNGa1ei-pSvx+ndrCJtZguGj12R3sa8PkDHYwsvGzw@mail.gmail.com>
 <CAEemH2cQSoTEVb+8NxZpc=qQVrd5DBhj7HmJA5o9GZFke3zj0Q@mail.gmail.com>
 <20260320123520.616900ef63996ba448bcd91f@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260320123520.616900ef63996ba448bcd91f@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ATo5GtF34kfVUtWsVVLLOOxLnV0ZGW34dB5vtO3aYJ4_1774148903
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35CAF40009
X-Stat-Signature: 71fhod837uwbuufocjeih5h5peeeu5w7
X-Rspam-User: 
X-HE-Tag: 1774148908-650888
X-HE-Meta: U2FsdGVkX1+HObo7e0tzdGz56GBiNfjWER3SSI2s0GlBf1LSBjxLy3fGNzzcNWDVAAYLQpAWM3Ekhor5f3JDlyJPa21cSIZgqCuxZKjYi6jaXHCw/wpbryskRCyvNRLw8SyjPBp4jdYgg+P1VghSl1+bMV9wSKFUU2uYSZJ7deR2ew3bzmuOs9KcA3VSdj4fVteQSMGKgBEpv+H3Zg6j7FE0dTtlyR84mlinE5WtEDni4VLVYoYr+Q0dqibyvIxgUdy8FmbipDf7lmFnT9XQgJVjwS2r4htiI7STqudLNFqkADjZVytfObIsl0aMuCGF18z2lqV5aBw+GzK0LOkW/OZTak9QhSJnYeNmNwx0uxw32kqRJ7JrkmyX3YlLp/h0UPLpY3RyHRjUV8GwOPRhykLw+KC1LIhIDiBkaI8epo/odDgzSyfMWqpR3Gal6ABv8uaAupvPajVz5fvTJX5xZ9/fvgIqKsIc850tU45QUbxBRappQ7jmu2oOu/dVdPOq9tMMYiUPZfqPy+gIs5Rp+qNWo/yqiYpt7UvWCftt/tjPGb1LEaBW8M2ded0490YaPsFJsiRwXLUr6xGrYNNt5KgNJGoEZI5KEbwMOzJMLD0LYv51OJ0R8A3YiPriQvCMnFEld9KePtyBpB5CVqV4FghcaxrVijXEt5H87QRuBI2EioW91XneWzv0+7BehtXwEWcNJePjDD0WS49xkKxr4bKmiuBVh1JAL9bXNQ6XvW6E0HPZQjVOpIqYnhrC6rZXaY1/MsdBKhfg1yHN92FskCezpiv/yqgCBgfyRdSCIGUHAw5RNCH9y4NDUIC7QiYdOQkz1i2KHjAa8253BILkBMk8zE5VMTxBnSy2R5od2mWhCXaM2hiQpcCny+hBAqxzWNPrxCcX6Q7t/bEGGi9MSeDBwUGaRUW7/2DUE/JtCWU/oSLsXD20hzqp5oXgTYvPoZf/p62UNgy8n8sv4e1
 MSZEF8XF
 2exyfiUaCTGkIJ+M375q1PrhEOnBPtvSs95zuw9TtKyhTxc8ibqZaRvImzfLzXRC+1Na9K3+ZTQd+NuMAkXCaJv9aDMmEeIFj9/mpl5zdore+ECksmhSgdcqNxWw5g6fs9IAE639u8eRCaxc7CkG3LPv3HQQDNLl8TBQUlWFVcNUZNd3PJHzgBZnhtaBsMLciqknctHjVmmIRRzt9byqAUPFiDwB4p1joOPpAE7eNeAp7XzSS4QBY+ZQc1WxxeGn4xD7VMsMWvZEDVq9Ld1DEgjgBo5K7hjjBJRgqBVDyhvw1eOpWrhOYV/EEN8Dv4qTxWgWwu73kyLEaAWBvE/WHU/hA7DTTqblBAYyqkR6HmsnrIoDh3SN2P8nczEYH4jqW2zFHhW+sAkinNGKGZW3BpHDZRUIsMwkYwFWQuRWwUGLNQyeu4OeECBxprjkOpQl3++cWJc/FQISIgQaZ4qUPGLThkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton wrote:

> Meanwhile, AI review has a lot of things to say:
> 	https://sashiko.dev/#/patchset/20260313043532.103987-1-liwang@redhat.com

> [Sashiko comment in patch 2/7]
> ...
> Could this diagnostic message be updated to print the expected swap amount
> in KB or bytes to avoid confusion?

Yes, good point, will modify it in v4.

> [Sashiko comments in patch 4/7]
> ...
> Is this description accurate?
> Looking at tools/testing/selftests/cgroup/test_memcontrol.c, the macro is
> also used as a memory stride to trigger page faults:
>     for (ptr = buf; ptr < buf + size; ptr += BUF_SIZE)
>         *ptr = 0;
> Could renaming this to BUF_SIZE obscure the original intent of touching
> each memory page once to force it to be resident?

Well, maybe yes, we can use page_size for this one.

> Could this lead to truncation of /proc/self/mounts on architectures like
> arm64?
> Since BUF_SIZE is strictly 4096, this reduces the buffer size from 640KB
> (when PAGE_SIZE was 64K from system headers) to 40KB. If the mounts file
> exceeds this limit, the buffer is cleanly null-terminated but the last line
> is truncated.
> Later in this function, strtok() extracts tokens without checking for NULL:
>     type = strtok(NULL, delim);
>     options = strtok(NULL, delim);
>     ...
>     if (strcmp(type, "cgroup") == 0) {
>         if (!controller || !strstr(options, controller))
> Will passing a NULL type or options pointer directly to string comparison
> functions cause a segmentation fault?

Theoretically, you're right. But in real situation we haven't observe such
failure so we can just add NULL checks on the strtok() return values.

    options = strtok(NULL, delim);
    if (!type || !options)
        continue;

> Does this code evaluate its exit condition correctly when waiting for a
> cgroup to become empty?
> When test code wants to wait for a cgroup to become empty by passing count
> = 0 (e.g., in test_cgfreezer_forkbomb()), the loop exit condition is:
>     if (nr >= count)
>         return 0;
> Doesn't nr >= 0 evaluate to true on the very first iteration, returning
> immediately and bypassing the intended wait intervals? Could this cause
> subsequent cg_destroy() calls to fail with EBUSY because the processes have
> not yet fully terminated?

Okay, this smeems a problem, but not blong to this patchset.
I would sugguest fixing it in another series.

> Is it safe to ignore the return value of read() here?
> If the read() fails, the loop will continue incrementing the offset without
> instantiating the data into the page cache:
>     for (i = 0; i < size; i += sizeof(buf))
>         read(fd, buf, sizeof(buf));
> Can this silently fail to establish the required memory conditions for the
> tests?

This also can be improved in another series. Shouldn't resolve in
this one.

> Can this dereference a NULL pointer under memory pressure?

Theoretically, you're right. But I think NULL pointer checks can
be added in another series.

> [Sashiko comments in patch 5/7]
> ...
> If malloc() fails and returns NULL, does this loop dereference a NULL pointer
> when writing to control_allocation[i]? Other allocations in this file seem to
> check for NULL before proceeding.

Theoretically, you're right. But I think NULL pointer checks can
be added in another series.

> [Sashiko comment in patch 6/7]
> ...
> Does this larger allocation size require a NULL check on the malloc return
> value later in this function?

Theoretically, you're right. But I think NULL pointer checks can
be added in another series.

>> +	snprintf(zswap_max_buf, sizeof(zswap_max_buf), "%ld", pagesize);
> This isn't a bug, but since pagesize is a size_t, should this use the %zu
> format specifier instead of %ld to avoid compiler warnings on 32-bit
> platforms where size_t is an unsigned int?

Good point, let's use %zu in patch v4.

> Will this new limit consistently trigger zswap writeback on systems with
> efficient memory compression?

At least based on my testing, (whether on 4k or 64k systems), everything
runs smoothly; this change has indeed reduced instances of false failures
in real-world.

-- 
Regards,
Li Wang


