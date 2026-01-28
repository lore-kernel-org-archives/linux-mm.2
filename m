Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D40D35662
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 08:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB0F6B0088; Wed, 28 Jan 2026 03:00:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6593A6B0089; Wed, 28 Jan 2026 03:00:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558016B008A; Wed, 28 Jan 2026 03:00:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 441706B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:00:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD133D39A3
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:00:50 +0000 (UTC)
X-FDA: 84380626260.22.8CF96D2
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id C684E40007
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:00:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UVbqIt+p;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769587249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOz/mJtzptjbG9UgUIfZqgEEjdmwSn5lnDfZqyL3N2M=;
	b=SWg6AYReLhpqzRSUW+e9StiD8oMjiJzri8u0u9PDSHBbv8AvIIEN8mvDOAUxA0MxBMIPwO
	hWnhubA3b/DFZGx91PCtl48n5+0ZNzv48a3OZtzrmalKw59o3BJd7weoaEyg97j+gP5acI
	sJOaN7nJe0Ij5eCq3a/pWQNcFTPAse4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UVbqIt+p;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769587249; a=rsa-sha256;
	cv=none;
	b=iJVW8oBsLJmdsEofNFU85N1kHswa12KFCx5aanLoy/IxmPLtKfDu9COeYXxTy4elbnMuVu
	VSKg8t3oNqgE4RWY5QfEzqjdBo18nqrcM+ovbEA6c2jHc5UqTTnS4dH4p2RDLPgdc181rk
	YiBoM2+s1jgpavJFG61ATqQfQAhHbw8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso3588825e9.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769587247; x=1770192047; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aOz/mJtzptjbG9UgUIfZqgEEjdmwSn5lnDfZqyL3N2M=;
        b=UVbqIt+pp+kSX25eIx0zedDrjpZCHceOuIE+v77Ouj0GS3oW3l9ivyqnmnlXnO5TZk
         OBtVI89lNk1RlmPuT6uNTf44qCTd13fsCBny1pKmiq6irVW7ogNqCTwPp1xF0uBBgTJ6
         wxqmgw4M3qB+9a5u8DGguVPP5TYmHABe8Wdflll0zTiWEsjzgCOUvgd8PvxF6IW3VTnT
         Y+ULUc5L7RUAIXAaV9k5Qwc2sHcUWn1Z+UzUEddP/un8hJi+Jy/S1qXtExQSORT6DTGl
         igB3Nw/i6m/R9rBsNGQ49croFFO+S/B3Z++UsOxYkvHMJX/UKBYY97pTHuhpNrO36A/2
         IZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769587247; x=1770192047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOz/mJtzptjbG9UgUIfZqgEEjdmwSn5lnDfZqyL3N2M=;
        b=qiOni2soIAsnu0UuchCuTShgawq5HxS2w37fKlqZmQ6w7jcNdYD7k+AFUoJt7E2M45
         RzLnDZwKrVa498+E6LMUYHNu/Lw8CRyGqhMcK/QAFlT6xJG2/bu3W5YtOt7lJNvLawcP
         AKyfu2j0kz52tg9tSivFiGQ9VoGvHd63gtMc9h/KGysNE/RqZKGKnGcIPObsOAgRx6Fx
         q5J1WcsjFCZVRng2aUCuLTicGYFrPWM/Rgqm9To83qaRdsEYBWsdAP+qujZVWmZeiF4P
         KVLJ03ylMSlmBQ1mYujBXc9W7rcfO4x1NME2V29IbuBAA9vM+Uv9/BX/PXXCgBmLVQqj
         Mt4A==
X-Forwarded-Encrypted: i=1; AJvYcCWYHbuEORxdYkbO6lWJeqepsgI08I3AjkhJ/g1EX/YXGhlf/jJ6NFUUeZ5wheUTOahAGzZhj8rX6Q==@kvack.org
X-Gm-Message-State: AOJu0YxC9I0N57MwKfo0/uFKXlfaxP9aKHZdgtgTh6sc6qnu5hGIdNzr
	D4G8FC+nNe8WP/T15hfE2fU6pHaihqHIkzcoZ3zilci0uYtEUQfjr1N4yO3tzEPYJFw=
X-Gm-Gg: AZuq6aLfhCFeOOVMA/BF9CkpDYd5yvGPVWAU7yDFQasq4SooW+0EmMlheru2jF1K5Yr
	2V7nv8oX3bkQ4z8f0TMlDTdv3nWy8nTffLy+oG3awWD36RJvXtKUTF4iIKv3haNFbJvT+vrmnbp
	WyIyUbkx4ucbzcWpX1TnpG7xO0EfP6plMap38zGpNxu2xy8kFmK2oBUU6pcU3CJYG9a9D8jNkqB
	h4wEFCMLbTfk84bwM3d3TYgGqNrjo7rr9eMwXNg/M9EiwRjZnClUIbmokzNGxxoTs+RuQHu/5Pp
	dCNeSfPMpfH6s+tkZ8kGGs8satNOxm743U8KL4SAODS+J0vCFgUf1yjPhgbL3Ct/ZlfeED2ZP1P
	slLN0jnN6ZuavH0YKhUM5G8iXbGYnuhJelOG9a9dwy5sBfFuez9u14nOn1N9JaPbcoBTmpraMmV
	y68kPypn3EjR0lxaiS94aWqYYt
X-Received: by 2002:a05:600c:450b:b0:47e:e946:3a72 with SMTP id 5b1f17b1804b1-48069c5fed2mr44222975e9.27.1769587246995;
        Wed, 28 Jan 2026 00:00:46 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48066bee7d0sm118235395e9.4.2026.01.28.00.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:00:46 -0800 (PST)
Date: Wed, 28 Jan 2026 09:00:45 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
Message-ID: <aXnCLWYbQ8xZ2IyO@tiehlicka>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-8-roman.gushchin@linux.dev>
 <aXiHok-3SKqLncCf@tiehlicka>
 <7ia4tsw6hi93.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ia4tsw6hi93.fsf@castle.c.googlers.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C684E40007
X-Stat-Signature: y9p786hgsye96n9c19yd1mq7bupi4uzd
X-Rspam-User: 
X-HE-Tag: 1769587248-362058
X-HE-Meta: U2FsdGVkX19WzkBIsGH3tjbNvYxtS6zk5eii3hyFiV1WyoZsE8h40jZC0gTwVSyTY+P9asFvXvlVNSDnf7JKjv1ErmaejiMQZnLSoirGTnJiFBtl7p2xCxVp+p/JewITbsIptdpN3O8R1fSbCgKu+XykIbokI+SyRipdHSc+bvAc1xebE9FiODo2TYNNb2y8usteFdYt+faXmh0nlQeov/G3Xd7bCuVx6uW8GBiogCIT3ugbu6TGx9NIuFhoprCUdRExcqJhm6HMv6Wte8HoJGZ91C5wZpEbyICZu2eQjNeTl7sZAYW/ClkDnaIGBFjakTTDslyKS5GPhwn1AjluIU9b+RJBjSNEHzyIUgoJBHEtKgEm4Q8n5Y668zY8Mv/NzvyrrsHUxP9U5nFL7kdCdcM9TsDCQaLDIuyzJkyxfYx60Chw0UmZu1cb2ad/7yMZyry+QjterpOIFzH0GIZc7XwZ2HGdj/sq4DZ4ZKw9RgvXkPHNcwY9mNrvB/avtmaZ9qbUIdxQ3HaqsuQ9BRtccy477vCtvcIJEmgNDB8UeXdUbpN+6+9w2jNEy7DJw6fa1RtS0Lrju4F/yg9V+5QzrliQGmQpPvchjuE9v8YCMcDOXmUf4ObDXYO0fxWgJh8KTCra9+2lgdrWwpXgpOuMSzR1BbpIMbTQjBsfX5XjE+ZtImsXDPPMNm6O8vYELiRwpFDqNUKbNeggmd+z7HQUocWrrkE1NJOMdiaowAt/wADghbaYTuOCXHaJKfBA3ZlnD5OjB1nU+ADj7zCDWYLQ98GT37E3d9DD3jMtqhrli2IOk+6bICWYgbClAHftq8xNCwx7k8eahWSgMoVrQKMVGQ0osG8sXF0WtDOchGcPq/7hkMRn6ItmwO9n4tuBoJSMKRqdcebx0tiMGnr2yWcHM9ZC7GxmKMO+XVuCl6E/g7/jESNxawwHcF50yzIMuDyn8BPwtcxhKqDyCEP0jU0
 Sfev9TT6
 ZAwi2erJtmJiJXbrxRf0nF+e3s32m0NmAZoRE5QgNtj5s6Gn06JGhFwrkDFc8YR33t4b7vJWHOyqZBck7Fk7IGz084M0TYpiWeRulCPf++xFepGH1rboFImBbp4DfUaUTUE+/qaK73tm04/rlxeovS9nxpR4jdJ6AiMZE9T7Y8Nf1YZ6Xy2SNBNFhjvRkb/MmRAol5jfu/fAujuZMuEchUgXUqT1KXl2sZOL7tnZoOeYGr4cDCFiMyXeKabYDEql/BkokjxFE3RNEQizWPFmkGWXcW1U9gpoJMTvE/stGr/PcjfUkrjFLhgTJpD99VyHApXX6uDoCO/nnFkEhREAZEzXyxl4Dqo4QKXI1lOgINqFfTiMDGQXIlnFuV1OylnhvrCrFwYUBYQmhcHKQ4pwOALGisKrKQLqclZ81
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 27-01-26 21:12:56, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 26-01-26 18:44:10, Roman Gushchin wrote:
> >> Introduce a bpf struct ops for implementing custom OOM handling
> >> policies.
> >> 
> >> It's possible to load one bpf_oom_ops for the system and one
> >> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
> >> cgroup tree is traversed from the OOM'ing memcg up to the root and
> >> corresponding BPF OOM handlers are executed until some memory is
> >> freed. If no memory is freed, the kernel OOM killer is invoked.
> >> 
> >> The struct ops provides the bpf_handle_out_of_memory() callback,
> >> which expected to return 1 if it was able to free some memory and 0
> >> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
> >> field of the oom_control structure, which is expected to be set by
> >> kfuncs suitable for releasing memory (which will be introduced later
> >> in the patch series). If both are set, OOM is considered handled,
> >> otherwise the next OOM handler in the chain is executed: e.g. BPF OOM
> >> attached to the parent cgroup or the kernel OOM killer.
> >
> > I still find this dual reporting a bit confusing. I can see your
> > intention in having a pre-defined "releasers" of the memory to trust BPF
> > handlers more but they do have access to oc->bpf_memory_freed so they
> > can manipulate it. Therefore an additional level of protection is rather
> > weak.
> 
> No, they can't. They have only a read-only access.

Could you explain this a bit more. This must be some BPF magic because
they are getting a standard pointer to oom_control.
 
> > It is also not really clear to me how this works while there is OOM
> > victim on the way out. (i.e. tsk_is_oom_victim() -> abort case). This
> > will result in no killing therefore no bpf_memory_freed, right? Handler
> > itself should consider its work done. How exactly is this handled.
> 
> It's a good question, I see your point...
> Basically we want to give a handler an option to exit with "I promise,
> some memory will be freed soon" without doing anything destructive.
> But keeping it save at the same time.

Yes, something like OOM_BACKOFF, OOM_PROCESSED, OOM_FAILED.

> I don't have a perfect answer out of my head, maybe some sort of a
> rate-limiter/counter might work? E.g. a handler can promise this N times
> before the kernel kicks in? Any ideas?

Counters usually do not work very well for async operations. In this
case there is oom_repaer and/or task exit to finish the oom operation.
The former is bound and guaranteed to make a forward progress but there
is no time frame to assume when that happens as it depends on how many
tasks might be queued (usually a single one but this is not something to
rely on because of concurrent ooms in memcgs and also multiple tasks
could be killed at the same time).

Another complication is that there are multiple levels of OOM to track
(global, NUMA, memcg) so any watchdog would have to be aware of that as
well. I am really wondering whether we really need to be so careful with
handlers. It is not like you would allow any random oom handler to be
loaded, right? Would it make sense to start without this protection and
converge to something as we see how this evolves? Maybe this will raise
the bar for oom handlers as the price for bugs is going to be really
high.

> > Also is there any way to handle the oom by increasing the memcg limit?
> > I do not see a callback for that.
> 
> There is no kfunc yet, but it's a good idea (which we accidentally
> discussed few days ago). I'll implement it.

Cool!
-- 
Michal Hocko
SUSE Labs

