Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573CBCCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0B28E000C; Tue, 11 Nov 2025 01:13:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A511C8E0002; Tue, 11 Nov 2025 01:13:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919868E000C; Tue, 11 Nov 2025 01:13:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CB838E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:13:01 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23F51B9613
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:13:01 +0000 (UTC)
X-FDA: 84097308162.01.1CE6DDF
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DC2DC000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:12:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=hfpeJ7xJ;
	spf=pass (imf22.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762841579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rhcgK/uhFz5i+qhvU5QkcxFYGJ70HuDlKM0CIE/z1s=;
	b=BiCNICaEdRm0IPdbHktU0TS/Qyl6vnyetFuBpo4VWGtv5OWuIAw6iTVItokz9gUiEghH3E
	ErO4IluzAnewsPBWV+ocU3rllsbmKGPcCExX+MBZRAWXsBEXiQXv/kkIJkES5276sFuSFz
	D9Gu8ri4SYpmmx4s+pJc7g3hkFvHFpc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=hfpeJ7xJ;
	spf=pass (imf22.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762841579; a=rsa-sha256;
	cv=none;
	b=fEjYZCkOxCzOzeo37DS06Veo7Jk7vr13fZ9qye1UyzJvJsTCkp2x9jgiTf1Fkxkz2CWhYU
	axI8klR8HexEiP5alPVBfJSFTvIQDH+J6Hjzz7bQteQTSdOegquyDo3R2BLm41xNiAgSHy
	Pn6p3yvA9Sim20rOinIE8m7qjd1hijY=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-295ceaf8dacso39551775ad.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762841578; x=1763446378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8rhcgK/uhFz5i+qhvU5QkcxFYGJ70HuDlKM0CIE/z1s=;
        b=hfpeJ7xJsgHbv7SBVyy8/psEVGN744Z48GoyovJUBKjvBRGo6MUaeLHXzu8NRmMppS
         OJej4M/Px76dGrWMyfC9jzWUf69UV2IQeUuzcSC9llcGmb7Fpr+Kh2tF1ariDa+9nQkA
         AXEamVcdWpzBTvVsGSzL7lom4EZQ5ct5hsXGSyAz5NFFaFASMJN5gDxr9tpS0s9wQXYK
         eGXYbopQ2JRRITABGmdt9GluCLQrz2kKJzJMwujBFVy3Xg94r+izoe5MjLkh/JMdsCmk
         3XMNUOEzwB/bT0mQS9LzCUW4/xQUm9JEn7u5Ji2Y1vlKuF1mK5nuGCMCprNykcDjznSP
         qTtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762841578; x=1763446378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8rhcgK/uhFz5i+qhvU5QkcxFYGJ70HuDlKM0CIE/z1s=;
        b=jbEx4CW7bZ4zViOGypRcuapGkYbn4g61G4EF/GV5nLy0+YoDCGD/46TzVXW559xzB7
         E/m1OZgiJQgvWvwazzFVw1e2yXxvSh6iGgnK6eE8NUct4RgSBnF2EYRKakiPE/7YFEfJ
         m928KeRdG1oeOFfpAoHbGI/9w91TmvUTphiSjfib09ThX+8b26HidD3YP+aeaJ5AEEbh
         85FF/JzrRIrONZKDno0CqP5qzM0PEfhDrVvml4SQ8latm7fxkqo4EgoqdIRadHkaT5P2
         oUCveZ2ZdXjozZ+KylgZljSHVKfpkxnxvXP7vo0oYtRCCyFgsIQ/2lSCPs/JDAfbroKy
         aYEw==
X-Forwarded-Encrypted: i=1; AJvYcCWnzXbslEITTjGBeq4ogqiaqyZoyy8cDECexF1tfXl8ALmSWagzF2TZKUXbfvFSm+3uDGpNLI+Rhw==@kvack.org
X-Gm-Message-State: AOJu0YyEyk8KIca4L8S8tKI/tDqap6Xq2fBwjH2op6j9OgfEGFPT0pn2
	iZnEOyEp+XSqUAcclRZout8Y8kNZaGYOTWgtLCb5z35wt3YeewF9nRbupcqIKzwF+hY=
X-Gm-Gg: ASbGncsVTVerOsUnmQCwYuvTyXecLyYxRmu5DQgatVBeECTmRZ/DVbr4JFrE5WC6Rn0
	ltuLkmAdF4Vl6iYre3bCOSTZwKPP0gSP8dcxu9OfSR6/pNcU96yvn58ntjEJS2s9pz7VXTNUAiR
	BYmX8id5HCArLVOokoi+rLEDqUvLlfpV4VtJlfLVmVy5Wf/NaxKBXsIo8gWqVFaG1rhQBIuPUui
	nfZejU+ck9KTVb4blA8jtuzTt1HoisIXhsrHnkLv/UeqvklUIAU9vUaf/5JOkG7qpP1BWMpzhvZ
	aeL36dQ7iviQmFq4CqLjAMcc7eLgzlyvDqOfs0BVklWBU5EaF5KO2ASiTqEn0G1D+gs5ePpjBXV
	yfoZ4M6cat0yJipzwySk31GUwMwbFjiqVZonhXMqDjm2embKRmov1v+XOH5x+92l/ep+9Jdhcn6
	02XFDMjbqY/jXVyEp52M5I9+4h
X-Google-Smtp-Source: AGHT+IELhVS7nb73OxbKeEmwDpZqhH0jCXP0hL6eUPlcCMaV+4//v9rB3bD5Gbbb7H8J9XLzDYxOIQ==
X-Received: by 2002:a17:902:cf42:b0:295:bedb:8d7 with SMTP id d9443c01a7336-297e56f6f5amr132204345ad.48.1762841577982;
        Mon, 10 Nov 2025 22:12:57 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343c4f6f78bsm650216a91.3.2025.11.10.22.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 22:12:57 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: harry.yoo@oracle.com
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
	mkoutny@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	tj@kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for on-demand stats flushing
Date: Tue, 11 Nov 2025 14:12:49 +0800
Message-ID: <20251111061251.70906-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <aRHR_zAx1HgyQJqR@hyeyoo>
References: <aRHR_zAx1HgyQJqR@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DC2DC000A
X-Stat-Signature: zc7wkywd1dor88yswawgnmphx8mjkdw4
X-Rspam-User: 
X-HE-Tag: 1762841578-250041
X-HE-Meta: U2FsdGVkX1++86XgwJjdewpFkOj9DMa6ziz2DLiHF1bYSqo619G7MGfo+QunO/J6Nqgu/K78RDopfizZW4vO4C1OiJjHbdnGGGzmgD2bm/aubuhiE3Fu8AJjHQgFwa5aVQQ+Vj3jYmiCjT1otxMvtvi5Yj0rjnT56lNOXOTXL/kG+0wPepDSgLAGWKXNXbmjU+lAw5fdMvpcS6iAn6Znc3IArl0V0hfQVCEt/SKI4vspyXeuFGYt9jFUq0/6uEGvHWwl3gfpv0DcOTZs19Cxg59sKrZyHaW5sgoYj/uwMppuoewaJXUeHZyL5mBt97riOeHlPBDMFyJ9LJwmwDZlvE3C8bOTAtTvChsE1YUCaU6iwMQIqrs+bh6N9w+cevOUz1yAFK6BqdTsSI3v8FGGmhVUBjSB35rg1/o8ch8V3nZC/mlj+lg6SaQF5QYZ4JSYYBCIAu5NvGdYHrJ6shOEaEqIibbBdIFi/LxhmTlTrl218zRIJpaXLvprkgdu/8+6N4NDSY7HQLs22LSX/E0w5B9UcQ3Hp6vU5nO7ZzOd9i5lVpYTzDPXqERH2tnc6IwDL3jP4feuvXZtunx3JcmeBVHQPBCqHOSNB6MvGAC6pJUITvGoSy7SRaFLFGYBrs08UyEzVDNacJhaXMvywawLVvAtGFt+4iR5jSZsKva9IFMTlIM0GI9ObM4PKxI34jRMEujztg6QIfgHHVs7xvbm/7cLl6pkKAWGoPEOg26sZ7Mfh42htgoOID3PguWyfe4eOiMn6m6fBLYD1cAInLwzfgJ0RGlVGoUekiCuwzuW76X+GbUUq9xONgpconRaSW80Q9DdlEIfyoCqov/R9hWAUEcYr1nMkA1OXLK8KlMglz9z9CpfmnVmSETRHXRFtGj+reEFGgArMRasj9Vdq/4FOgpcM1WfBnBVBijFg4IQchdPlWHp4aoGsdZ/8M4Tq46j95ukACOcWm46IOPF/us
 7NrEQTfI
 /ntZVHgeC1cVVYq2usDQLXddkorUpJodv2ipis/KG1paZJ8+5Vs9RPuKnZkrR+fKEnH2BavAe89j/H6GJ16N+2U9vNl6euJxWY3G6JUqpqYNoXChnTQGevDMbaabM18l+jVB0kvSBOw6Bqp+Th9jEHGk9DLwGyz95Jn4rmgUXRKqKxrGq5XWy+AVfEUfrNPqagl03r3iYyt81YlZiE8UxsNzdUtdsdMqKdjVjodsPMoMSanmRUg+hyiO2F5Wu4TvOJCPZqPdsN3b/ju0Hp0D8bsM+CBEoh2ejNLvQboCb7erGXLaKE6l3EVwnmk3vt5hDeHNMn10FtokO+9BPhZ5v2OzjfUzOhdW8m7+o7AVqpSwkf5+TAtwJwJMvj6scrsVKyQ4RwRIpxn7xCqCq0JmaAIbfnXR++Y8xl92flBEaPm7CDqdq2GmCGRht5nnDHR6uouJVZsB+sW/uewmXJBwSv5ft1UGP1c2o1g0hgVFxTrQUqIzCYA1z18PGuOp14lRcUzri3Qz9FFmZc+jgTWmt5M7XNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Mon, Nov 10, 2025 at 7:52 PM Harry Yoo <harry.yoo@oracle.com> wrote:
>
> On Mon, Nov 10, 2025 at 06:19:48PM +0800, Leon Huang Fu wrote:
> > Memory cgroup statistics are updated asynchronously with periodic
> > flushing to reduce overhead. The current implementation uses a flush
> > threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
> > determining when to aggregate per-CPU memory cgroup statistics. On
> > systems with high core counts, this threshold can become very large
> > (e.g., 64 * 256 = 16,384 on a 256-core system), leading to stale
> > statistics when userspace reads memory.stat files.
> >
> > This is particularly problematic for monitoring and management tools
> > that rely on reasonably fresh statistics, as they may observe data
> > that is thousands of updates out of date.
> >
> > Introduce a new write-only file, memory.stat_refresh, that allows
> > userspace to explicitly trigger an immediate flush of memory statistics.
> >
> > Writing any value to this file forces a synchronous flush via
> > __mem_cgroup_flush_stats(memcg, true) for the cgroup and all its
> > descendants, ensuring that subsequent reads of memory.stat and
> > memory.numa_stat reflect current data.
> >
> > This approach follows the pattern established by /proc/sys/vm/stat_refresh
> > and memory.peak, where the written value is ignored, keeping the
> > interface simple and consistent with existing kernel APIs.
> >
> > Usage example:
> >   echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
> >   cat /sys/fs/cgroup/mygroup/memory.stat
> >
> > The feature is available in both cgroup v1 and v2 for consistency.
> >
> > Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
> > ---
> > v2 -> v3:
> >   - Flush stats by memory.stat_refresh (per Michal)
> >   - https://lore.kernel.org/linux-mm/20251105074917.94531-1-leon.huangfu@shopee.com/
> >
> > v1 -> v2:
> >   - Flush stats when write the file (per Michal).
> >   - https://lore.kernel.org/linux-mm/20251104031908.77313-1-leon.huangfu@shopee.com/
> >
> >  Documentation/admin-guide/cgroup-v2.rst | 21 +++++++++++++++++--
> >  mm/memcontrol-v1.c                      |  4 ++++
> >  mm/memcontrol-v1.h                      |  2 ++
> >  mm/memcontrol.c                         | 27 ++++++++++++++++++-------
> >  4 files changed, 45 insertions(+), 9 deletions(-)
>
> Hi Leon, I have a few questions on the patch.
>
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 3345961c30ac..ca079932f957 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1337,7 +1337,7 @@ PAGE_SIZE multiple when read back.
> >       cgroup is within its effective low boundary, the cgroup's
> >       memory won't be reclaimed unless there is no reclaimable
> >       memory available in unprotected cgroups.
> > -     Above the effective low boundary (or
> > +     Above the effective low boundary (or
>
> Is this whitespace change? it looks the same as before.
>

Yes, that hunk just trims the trailing whitespace.

If you'd prefer to avoid the churn, I'm happy to drop it from the series.

> >       effective min boundary if it is higher), pages are reclaimed
> >       proportionally to the overage, reducing reclaim pressure for
> >       smaller overages.
> > @@ -1785,6 +1785,23 @@ The following nested keys are defined.
> >               up if hugetlb usage is accounted for in memory.current (i.e.
> >               cgroup is mounted with the memory_hugetlb_accounting option).
> >
> > +  memory.stat_refresh
> > +     A write-only file which exists on non-root cgroups.
>
> Why don't we create the file for the root cgroup?
>

Thanks for pointing that out—I copied the wording from the memory.stat section without double-checking.

All three files, memory.{stat,numa_stat,stat_refresh}, are created for the root cgroup.

> > +     Writing any value to this file forces an immediate flush of
> > +     memory statistics for this cgroup and its descendants. This
> > +     ensures subsequent reads of memory.stat and memory.numa_stat
> > +     reflect the most current data.
> > +
> > +     This is useful on high-core count systems where per-CPU caching
> > +     can lead to stale statistics, or when precise memory usage
> > +     information is needed for monitoring or debugging purposes.
> > +
> > +     Example::
> > +
> > +       echo 1 > memory.stat_refresh
> > +       cat memory.stat
> > +
> >    memory.numa_stat
> >       A read-only nested-keyed file which exists on non-root cgroups.
> >
> > @@ -2173,7 +2190,7 @@ of the two is enforced.
> >
> >  cgroup writeback requires explicit support from the underlying
> >  filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
> > -btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
> > +btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are
> >  attributed to the root cgroup.
>
> Same here, not sure what's changed...

That's just trimming the trailing whitespace.

>
> >  There are inherent differences in memory and writeback management
> > diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> > index 6358464bb416..a14d4d74c9aa 100644
> > --- a/mm/memcontrol-v1.h
> > +++ b/mm/memcontrol-v1.h
> > @@ -4666,6 +4675,10 @@ static struct cftype memory_files[] = {
> >               .name = "stat",
> >               .seq_show = memory_stat_show,
> >       },
> > +     {
> > +             .name = "stat_refresh",
> > +             .write = memory_stat_refresh_write,
>
> I think we should use the CFTYPE_NOT_ON_ROOT flag to avoid creating
> the file for the root cgroup if that's intended?
>

I kept memory.stat_refresh aligned with the existing memory.stat entry, so
I left CFTYPE_NOT_ON_ROOT unset.

That said, the documentation is behind the current behavior; I'll update
it to spell out that the files exist on the root cgroup too.

Thanks,
Leon

