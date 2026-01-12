Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1466CD25051
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 08:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF4F6B0088; Mon, 12 Jan 2026 03:42:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32B66B0089; Mon, 12 Jan 2026 03:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06EE6B008A; Mon, 12 Jan 2026 03:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDD086B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:42:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D54B1B9F5
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:42:18 +0000 (UTC)
X-FDA: 84322669956.27.0FACFD7
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0F05A40002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:42:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VNKzHbev;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768207336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDfFNoiSuTKA5KfAUoXISxuSK51bp7lujfs6vADIdxE=;
	b=0A+nTCNM4oflBzSyDUciP9CUfR6eMvlxYTVanJXel1EoWjHeJkvf+eGe7HcUSP4kWhaD6v
	ngoZFV7KSI8nd1DynVkB9+yARmyRK0qBDaWF4wOXK0nsyTUbgPzXYWIJOV4gPqiM0OIZpk
	Mz7ZLvhA8B+XRM+SkINco/9PesJOTyU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VNKzHbev;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768207336; a=rsa-sha256;
	cv=none;
	b=IrJ48MrThR8Z8/v80ALDjORILk+GyAKmHda6pnJhE/wIn95AYU+EzCZo9YPQNpKIObNUYw
	TMS6qSUA4L1znBSvfCbU9Ii36kveRG7pEfvACiOVeE/RMUA54h9/6jQhUvOFIM4z5khxHq
	czYFY3/tIFqDQSXYrJMySb8Gwtf9GvU=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47774d3536dso42608985e9.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768207334; x=1768812134; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CDfFNoiSuTKA5KfAUoXISxuSK51bp7lujfs6vADIdxE=;
        b=VNKzHbevup3Xstomf0sXlylRg15ZHuiUd5tM+kK7RlgMrTkMrHKGIYHVtS4YQ0daCY
         +bNnoAbt3toyyJwAXfNRy2/tT3rTQrYjZG3HsvO56PVdQe0BmNtjOsB2CXh6xDtSrxuH
         IIniRHR+A+K0Tdi9eumot8Ds/3Vz02W+10KqbzAtgiALI/v9AFFyq0MuF8ikMHeGAGhe
         pvyYUnymtk+HRRFvMi/LjaHY1T93iwVcnl6z7IsUFzR+llyjfcjXMdix6YoTv2WXZppL
         Y2M6+DhVJ1DJNSFZc3FhXyto0fMACMYZ5HXIcYyxnLIuY8IqRSZoLrCyBLsoEuz2yke5
         xRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768207334; x=1768812134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CDfFNoiSuTKA5KfAUoXISxuSK51bp7lujfs6vADIdxE=;
        b=jFWqGKMOxhmkpng8XKnLpYPMVk/6DMTCelE5uxtDz5sINl+kJx5wW+ti6H6prZtlXz
         nQcgEzw660CLU/ItGArRbrQVLbQlRnGd4rJrGmYxvsZWnEVR+aulfJm7GNltNXNNOOlK
         BS9D70mNPbFgPqRYelMjdSG7QOqaGiUHoAo/kq9RVJcZr9z3hq2iwtNc5zvRTz/xgZ0I
         0RQXC+bSDJ9XlnoBtIJ+0TWxaZLbxY/cFgzVylgx+PO3MVaNTjdRpeBSqYqnNFMOqA0e
         wPDHAvM4o8IOor7/kJoIS7j26yAwo355AJvuLEsBytFn2+PfTdX440NRZIrVEEslDToH
         Ls8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWpYzanRedJXFThzM9y6nxe2q8O03tEV8P3ud9Jw8e+ckRax0M4BEdgIsSnJU/Xx9Fm4u/MpO/TbA==@kvack.org
X-Gm-Message-State: AOJu0Yy7Aj/fWTB/UFzM1BCu5TFHPWSb9+YBN4aJ9d701fm6X4xjVOIp
	AenZ+PJc+Rb0Hk9S6yieErFR4KSmksUAj7rKvKWnZ+WJN1X/c1I584CGU8dg4aaQxOw=
X-Gm-Gg: AY/fxX45xcBFwQ9M9sZq4l7ra1MM41A94y1sq0WnryVxTWGTIHbpzXzyFjlemTScxz6
	/b1+2DGv/P7FVLZAT8LMSNdsseXjB6tHbiAXf+5eXh8YIriTUDTM4S8C2LxWlovBybHPkK/UDJA
	o0yqeFO1JyTRTQfepTPN1DvY/3j8IOTt8CvKH5PQjrXwFm+dUEdMFKkfR1LwHGYC4l/Ltlk6o8d
	MYbSXXB84/0G0ZcYzehOzEjaFdH4ZYz32QTEHH9VRt1ZDNV1smV0wxVsx7ngHh3jie9Ck02Vfpm
	Sr1Eplh83iTXMJy17N4LtXslL9hOTGoeSw3v9SNOgq6ecSChVQAqjD8iQ0oB7XFpsxxvTIujv/l
	A7aL9kx2/oh1PzlIUQqtnPM6/wGuYYEujWtqom+rVI0MjP8rhQNRdVEtM/ftzuTimoQraQGK8MN
	0W4kZrgi1FmT1+Qnh5ZUEHYcCGUFWYQ+9p7/I=
X-Google-Smtp-Source: AGHT+IGOZ9lkMoCzrUzWNxChXoAXhL7/lCG+k3HeWbbjlLCJz2d0Tg02k9SjW7Z9t8X4D9e1/0CcXQ==
X-Received: by 2002:a05:600c:3b05:b0:475:ddad:c3a9 with SMTP id 5b1f17b1804b1-47d84877e51mr207488795e9.13.1768207334460;
        Mon, 12 Jan 2026 00:42:14 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d865f84besm132725385e9.1.2026.01.12.00.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 00:42:13 -0800 (PST)
Date: Mon, 12 Jan 2026 09:42:12 +0100
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
Message-ID: <aWSz5OHBwtfYrruu@tiehlicka>
References: <20260111194958.1231477-1-mathieu.desnoyers@efficios.com>
 <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111194958.1231477-3-mathieu.desnoyers@efficios.com>
X-Rspam-User: 
X-Stat-Signature: 6aq6ahwqi3ijf6pxqjb6tjwwt3syk33c
X-Rspamd-Queue-Id: 0F05A40002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768207335-655560
X-HE-Meta: U2FsdGVkX1/Gk5ZtXqo5tPFi0eFGjocxnsuMa/pFGYiWrVTq7vux+dO06hAvu4bS8Li8C3YByQi97nkHQH3G+cTZ/UouAk5+3md8qaTJ3S+oOfBIagPYDKEcLYxWzi7Lr7bRJ0mSqXZj1EtKhWLd4cQeeGcD0jLLOfd3WgaVb9XXTfp9KU443eQp5ElEkTX4PkGJ/p2vnM2mVrmdZqAz0DETBy6Rb6v5w9D9jx/YiF3+nhEgUAFEvfKpe4zqR2Qvp3WwbDdlNNHXYTtCBz6zZXhFyr7StPtD3wvqQbJwnSm4yN+QrOKiMDPAQaeRywqJq6kTAMb6yHzu0eJ0Xk74URDOOiY9cCcnF5sgp8h/l0sGRXF192ccxXd/Qx2XApORlGJ61LqkSjZjNCD5nqQ35Io8Y+DHK2foYXo8OTVBLNCkKIz0SuIOl6CG8NBBB1WjFKjTWFplqvIkR/T+vuPFkmsTUsl+yyij74sAQ4gmoWXoMv6FqjqPVKKnlmy2nUQ6DLayvKby4y71/vDGvuLCKIJariASQq+fQDCmXK7FJPhLuhwnIWITYgnTcSHTg8z9sr7cnTipwqqJK33eQ/ywuoMZEXV/scKc9/8C1s7r/F4otp7aDpNdMtFygr6jvSKmiVvgcPIOZMS5HZJldmjVW0mCGY7zA1sSJ2gZuN3zBTVtbnPB0KfpVluwrhLBDdbjygQIfTDF/51BFyQd0rwtRj5I3LhyPUvE2d7Z2vkD6Lk+pcdZAcAWgfffu/Wn0Ol1U7Ei6zCRC34JJJS7DmE48oVm6Nam6qzQd08jkGO6PHcxAdpcLregribvzWI4ZnHI3DUo/lKYSLCerLGg0vhR576m+lyAyUVLYoDYX+1aPJXqvWQ8+H9A0RXBdoHGNUrpC9y/oeUUM4Q7joKGqaSNfTtPs2AhPjfmTyC6hp9FZrVSKnyYkZ5UCHqaNFpcUcgQwY6kXa8k7qlllc+syjJ
 BWjimXS/
 bgzwf0T6GbQGmdDjHZIUavht/glE81qpmuOjR8Wad0FPKhtg9UVVxMJTBhCglFB1d6511czPZ6miThuSoRnN+A+1xe9i9SVE2wjTc2zghGY6OHiNlwKdksgeLfPmUfQQu6WSFaDnsDiSFwSd10NAL7FXFKHjVla7RShCeys/uOZUDA4dBjUSsHoQPuOnNDi9nehC9Z0io4GWGOfs0rDlRuCtnwvLGgJXhZSJJEvaFd7c8JeaSz85HRF4vvR52gphW4V3CK8HNImwYtALqAF8VicrG+TXT5sWkVLbqMPNO8wGlf8axNQsPP2+WhFucm1jd8mGCGPaFX5ITXW6n3NumXO2uehlFNZhrS4DKf5nUNrnA7BCYV6XpvHun9F+W5jzKgecqk1rl3y1zahJcNSgK3GrMQGoSGX/jkRz1bI0ZmN03eL8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,
sorry to jump in this late but the timing of previous versions didn't
really work well for me.

On Sun 11-01-26 14:49:57, Mathieu Desnoyers wrote:
[...]
> Here is a (possibly incomplete) list of the prior approaches that were
> used or proposed, along with their downside:
> 
> 1) Per-thread rss tracking: large error on many-thread processes.
> 
> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>    increased system time in make test workloads [1]. Moreover, the
>    inaccuracy increases with O(n^2) with the number of CPUs.
> 
> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>    error is high with systems that have lots of NUMA nodes (32 times
>    the number of NUMA nodes).
> 
> The approach proposed here is to replace this by the hierarchical
> per-cpu counters, which bounds the inaccuracy based on the system
> topology with O(N*logN).

The concept of hierarchical pcp counter is interesting and I am
definitely not opposed if there are more users that would benefit.

From the OOM POV, IIUC the primary problem is that get_mm_counter
(percpu_counter_read_positive) is too imprecise on systems when the task
is moving around a large number of cpus. In the list of alternative
solutions I do not see percpu_counter_sum_positive to be mentioned.
oom_badness() is a really slow path and taking the slow path to
calculate a much more precise value seems acceptable. Have you
considered that option?

-- 
Michal Hocko
SUSE Labs

