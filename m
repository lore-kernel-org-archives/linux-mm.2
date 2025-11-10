Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB1AECCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 06:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51E88E0013; Mon, 10 Nov 2025 01:21:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29968E0002; Mon, 10 Nov 2025 01:21:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F338E0013; Mon, 10 Nov 2025 01:21:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9E6A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:21:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CA784C991
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:21:04 +0000 (UTC)
X-FDA: 84093699648.12.777AA22
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2712D180010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:21:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=BU7JeblG;
	spf=pass (imf24.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762755662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bvd5Yl5uTKxCTPtToTZFSJR27j/IrzDu4M4hsZnd7A=;
	b=RqZbXw4aMEZfDYhNFJbYmsisXUtYan+0WIHSN5KJFDnMC21H923ovo77XyeHjPEejAIytz
	86G80jsC55zenr7tjRKNf50mZuwSdGl8lmwxBCnE5mWM5q7zLoH2EZL3zPnAbxmPzGFp40
	BKOxHDgiBMEvRgldJR5q0ilPLsdEZFg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=BU7JeblG;
	spf=pass (imf24.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762755662; a=rsa-sha256;
	cv=none;
	b=ABa4LyL3tvROpv5jao1SuW3okr6UO2ytOptO8oTptj9V57Yj113EOxrdjernxpcNYbRP/F
	h2rbEODCavk4QgkYpgCtiL21UIley8XiEjJyz2rZaUqER+TS989LJkvrcU6l7MfSF4cVZN
	HKgvJH03w64eeVNQ4+MD4CtiZcXpuMc=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7a9c64dfa6eso1997024b3a.3
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 22:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762755661; x=1763360461; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2bvd5Yl5uTKxCTPtToTZFSJR27j/IrzDu4M4hsZnd7A=;
        b=BU7JeblGqYoCw1ZcloZH698+ulFMOhKrtvT5UyhzgOif1sNcmM/jI3bPEIsFt7iRJQ
         nGANmXp0Bnognyj5UTgsnjtcEfoB083HrVaMRIP6/aG+mwhxR4SJ/U9RgxUrKGGbox72
         oxTGwTl8sY3yLAkmVIBdhbJSeqdf8zQ92xRudVdFIV1dZxftFxhp4hKMIGrkug41CaWS
         u1gPN4ZRzytwtiLETNb5VqjRCBYJgRpcDR0bnuuDGBzoO0HxlmedwkGus7gvwMqOm3UI
         Kk5WWigd8054z72xYHZ8v2G3HGQeh1x12srh9YpmsweJcOvSrkNKY2Q8iLERhCYRozlq
         D7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762755661; x=1763360461;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2bvd5Yl5uTKxCTPtToTZFSJR27j/IrzDu4M4hsZnd7A=;
        b=cLPoGVpPvhRzunMJLBwN4ByOPICndm9lgOAF8ChrWMmNXwa3qLGS/D5WCUOdp1uUO0
         82BQ6iOBLfwCy0S+5nXy2OTyMZoM8r/c+eAVuVxh2IrpLszXswQhJA4Cqx0i8tuBHTNe
         uXjA6Xt5ZeyBIMprgjDUr106EAWiU5BEQf7DZuBv849ILMkmtFmDIJmQPG5U/kAkFuP6
         /dUpM9yZ2Ilo8AM2BEIjjaSjdjuB4scI82+lpYty9zVrY4K4A8BApPEGQoQ9bWipFJH9
         tjl7Hqet32mtgDtZCxCRc+oCxixl7FBEBEBSJhH6YWFCNBOFC53kqX36fGPjAN+dYZ6l
         4gdw==
X-Forwarded-Encrypted: i=1; AJvYcCVsLo9TzwnGFITGG52EzDfS/a0jH5H1zaha20awnnvU9fhcMPAcTNKkuvp4Rm71PxIS2pchOXImZA==@kvack.org
X-Gm-Message-State: AOJu0Yw8A6kLZL8kxMJbYsWvA+8yJf0R4Watz5bT3U8bN5gvnB1YwFXx
	qra5BdQGppzgBnamPursULS2Cm3p19Pm7BCrue9wxTZUd52l6bHEZMDwjRsMMtfoozQ=
X-Gm-Gg: ASbGncvcMbEDz9C3KG4rEH1NFdm41e1F5yyYMQxqpksgexGsqd0Gl16bGe8Lp0oxDOQ
	hJY3Ap4p0vVvbx8FE3gJtkSTF89Sh/xNfTyIhpNS/mE7CMt9Y35Q4mPzIhjEAJdjbamgeqRQOMT
	n2ZW4QsFTAytWAFpkyo4X66trRLLWgXvh+lEOdRXkGagz3u/xYfhLlYSM1IYjx+hCrSQdxDh7Dk
	lHaiEypbGoE5BMEGosOhwJ0WNRnp9+QgukcNXe8BApV0pEXqNHUA+HzAMrNdxnndA3d0dYpsPso
	kQAgqNIen6R6Xew5NfHdF8gptWdkgpWPgFpySrclP0u3D+7QR9jNZ4oL2brJuRKJGBA3/U+r5Xr
	14ynzGcyFNhvaxbeoWAt49CM7jD3/j0eyb6RYLrOy5mvfKrGGl4laogk7PYbW8jLbdQ7F5f+M2J
	X0LhtAurRhGs/U8w==
X-Google-Smtp-Source: AGHT+IHJe19Wgu6Lk1i0m6uGDAjX1Z5fu+nfTMxhKeWaemOIoa7wCp8aZhGxugUb/8NNh1qJMMkGNw==
X-Received: by 2002:a05:6a20:7f9f:b0:343:72ff:af9b with SMTP id adf61e73a8af0-353a33532d9mr10298637637.41.1762755660784;
        Sun, 09 Nov 2025 22:21:00 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc179f77sm10274534b3a.34.2025.11.09.22.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 22:21:00 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: inwardvessel@gmail.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	jack@suse.cz,
	joel.granados@kernel.org,
	kyle.meyer@hpe.com,
	lance.yang@linux.dev,
	laoar.shao@gmail.com,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mclapinski@google.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Date: Mon, 10 Nov 2025 14:20:53 +0800
Message-ID: <20251110062053.83754-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <37aa86c5-2659-4626-a80b-b3d07c2512c9@gmail.com>
References: <37aa86c5-2659-4626-a80b-b3d07c2512c9@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2712D180010
X-Stat-Signature: ao8dpymhoszhr7u3gd9k4j6mgxowa46f
X-Rspam-User: 
X-HE-Tag: 1762755661-112031
X-HE-Meta: U2FsdGVkX1/VrEKwz04xhPC3Nm+1YmLUdOfp9BCIiPLP/nPIdH4vqTMyspjaipKj+S7u3MXkzg8ti3fZ4hGKTMxyXA9Np8jo5e0hVbs3650ZY83Md97PHjYLXnZZTGv8sMf8SNDtRpN2aIOi9KA7E2hTOujgisp8v9TtLYw1ri+yUvWagOx+rG2of1EClBIwVVgFWgbK/C9XlIxU0xTrsEYt8sWxlMSz6FMCih1KNXMZz+kP9yVGVUucN7Dea7wKQrQZi4Q/uJZBn7IPDvK6Z/IOrX9BYnyNkIxCWqGsOb3VTlalruAjfmCID7g383e6JXiSY3ROJ/skdPf/3MsKACw8i7mSLQuYngsiouYoJiXX80CrLN4V7VlMQgujQvG/pvy5rotKwqlWKfOUg0DhINAfk3iR0BEaJZ6BTKGXgdDBPXB2wuCXiDd4E1MVvv2IHX7BXAd21hUB2xIK0CtxTYAgV6L6MZX01VL8IY/ufwpL2e9bVIZl4Tm/FyVJ/UhFb3GPdl70q6rHv4uS2IuibUIo6dChCBytOgGp0fBr2Qs6tjyPN6YNfyAuaZ2pFzp2eAL1q8zpi5yGyAqVcTk2UB1i1k50yQAHyDTKpawTZUl2t99NQtKI+1QWWMNtop4Qy86QDBOeujXmAmPnQIa/A+DdzDuqW0idsPrkp88mtyPYyWOzr/YUFCj3pnDyFe+dSmLtUsT2g/k7J3FJBwtfxeKGgKGu0nqUtAeCl8t2AuMGtsdBTTTID5jwjiFpJ8mT1trMoY+SrvMl+LxPM/sPavPRATmxAKlZ1yQqcMPWQUJlEbOOOs1yctIstd2doJ7UUsUICL75EuDYEWH502jAdxxMJoJVuCKQz/tONkC8AvNl3C8nndGZtE3/smLXk6zvmDew853STQzD67gE5lC2IvdyUw2pOGX/6DwQg5QuZ+7VZMJOpwERG1h7UcGdLLeEgMKMtae3Z3gcs3T56v/
 mXAwZtyp
 DLCFLfSvdWHDtPzbxF+GE8tyJ2oF8TZb9f6480UUCjk6E+1tHhkmCHOCEvQvpaGh0S0rtzdPvQqh2cY1rIH8i71h9ipGBoIL1HHTM6ZWXUqPwR4oa4q+U7eHsu1rKlTJRAdLk2eZvr6sclZcgvS2HM1C4P98UU9ACzDqOSGQaWAW0wWieOoaq6awdru7YoZjJu4CUPZ86tt0JLlmrigjpvZ+cvfMpSNRKF/pn/JUfaMR4atUDzZmi25s8AGmcqfEmABHHTt/ATbbEguYd8nJn4rqNsgBbDx+Fr4HXFuxBKNoNQFXRN7+PxekL0UmVIDesY3yG396BeKaJqe3hlgkhE8QKxbUEbkswmKYsVreYmZUSBhWRRhGG3t4h9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 1:02 AM JP Kobryn <inwardvessel@gmail.com> wrote:
>
> On 11/4/25 11:49 PM, Leon Huang Fu wrote:
> > On high-core count systems, memory cgroup statistics can become stale
> > due to per-CPU caching and deferred aggregation. Monitoring tools and
> > management applications sometimes need guaranteed up-to-date statistics
> > at specific points in time to make accurate decisions.
> >
> > This patch adds write handlers to both memory.stat and memory.numa_stat
> > files to allow userspace to explicitly force an immediate flush of
> > memory statistics. When "1" is written to either file, it triggers
> > __mem_cgroup_flush_stats(memcg, true), which unconditionally flushes
> > all pending statistics for the cgroup and its descendants.
> >
> > The write operation validates the input and only accepts the value "1",
> > returning -EINVAL for any other input.
> >
> > Usage example:
> >    # Force immediate flush before reading critical statistics
> >    echo 1 > /sys/fs/cgroup/mygroup/memory.stat
> >    cat /sys/fs/cgroup/mygroup/memory.stat
> >
> > This provides several benefits:
> >
> > 1. On-demand accuracy: Tools can flush only when needed, avoiding
> >     continuous overhead
> >
> > 2. Targeted flushing: Allows flushing specific cgroups when precision
> >     is required for particular workloads
>
> I'm curious about your use case. Since you mention required precision,
> are you planning on manually flushing before every read?
>

Yes, for our use case, manual flushing before critical reads is necessary.
We're going to run on high-core count servers (224-256 cores), where the
per-CPU batching threshold (MEMCG_CHARGE_BATCH * num_online_cpus) can
accumulate up to 16,384 events (on 256 cores) before an automatic flush is
triggered. This means memory statistics can be likely stale, often exceeding
acceptable tolerance for critical memory management decisions.

Our monitoring tools don't need to flush on every read - only when making
critical decisions like OOM adjustments, container placement, or resource
limit enforcement. The opt-in nature of this mechanism allows us to pay the
flush cost only when precision is truly required.

> >
> > 3. Integration flexibility: Monitoring scripts can decide when to pay
> >     the flush cost based on their specific accuracy requirements
>
> [...]
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index c34029e92bab..d6a5d872fbcb 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4531,6 +4531,17 @@ int memory_stat_show(struct seq_file *m, void *v)
> >       return 0;
> >   }
> >
> > +int memory_stat_write(struct cgroup_subsys_state *css, struct cftype *cft, u64 val)
> > +{
> > +     if (val != 1)
> > +             return -EINVAL;
> > +
> > +     if (css)
> > +             css_rstat_flush(css);
>
> This is a kfunc. You can do this right now from a bpf program without
> any kernel changes.
>

While css_rstat_flush() is indeed available as a BPF kfunc, the practical
challenge is determining when to call it. The natural hook point would be
memory_stat_show() using fentry, but this runs into a BPF verifier
limitation: the function's 'struct seq_file *' argument doesn't provide a
trusted path to obtain the 'struct cgroup_subsys_state *css' pointer
required by css_rstat_flush().

I attempted to implement this via BPF (code below), but it fails
verification because deriving the css pointer through
seq->private->kn->parent->priv results in an untrusted scalar that the
verifier rejects for the kfunc call:

    R1 invalid mem access 'scalar'

The verifier error occurs because:
1. seq->private is rdonly_untrusted_mem
2. Dereferencing through kernfs_node internals produces untracked pointers
3. css_rstat_flush() requires a trusted css pointer per its kfunc definition

A direct userspace interface (memory.stat_refresh) avoids these verifier
limitations and provides a cleaner, more maintainable solution that doesn't
require BPF expertise or complex workarounds.

Thanks,
Leon

---


#include "vmlinux.h"

#include "bpf_helpers.h"
#include "bpf_tracing.h"

char _license[] SEC("license") = "GPL";

extern void css_rstat_flush(struct cgroup_subsys_state *css) __weak __ksym;

static inline struct cftype *of_cft(struct kernfs_open_file *of)
{
	return of->kn->priv;
}

struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
{
	struct cgroup *cgrp = of->kn->parent->priv;
	struct cftype *cft = of_cft(of);

	/*
	 * This is open and unprotected implementation of cgroup_css().
	 * seq_css() is only called from a kernfs file operation which has
	 * an active reference on the file.  Because all the subsystem
	 * files are drained before a css is disassociated with a cgroup,
	 * the matching css from the cgroup's subsys table is guaranteed to
	 * be and stay valid until the enclosing operation is complete.
	 */
	if (cft->ss)
		return cgrp->subsys[cft->ss->id];
	else
		return &cgrp->self;
}

static inline struct cgroup_subsys_state *seq_css(struct seq_file *seq)
{
	return of_css(seq->private);
}

SEC("fentry/memory_stat_show")
int BPF_PROG(memory_stat_show, struct seq_file *seq, void *v)
{
	struct cgroup_subsys_state *css = seq_css(seq);

	if (css)
		css_rstat_flush(css);

	return 0;
}

