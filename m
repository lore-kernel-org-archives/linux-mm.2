Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10F8ACCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E498E0007; Tue, 11 Nov 2025 03:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635AA8E0002; Tue, 11 Nov 2025 03:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572748E0007; Tue, 11 Nov 2025 03:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 456F38E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:10:44 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D49C6160495
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:10:43 +0000 (UTC)
X-FDA: 84097604766.05.9661B4D
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id B6A6720007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:10:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NWlgOimx;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762848642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQbue78pKwkHXp+W4v6uPbf6iMxcJPuiWhAhoJWq+ek=;
	b=LDGJt4h+KdB0Ypx/gjTM9l1+W2aQ3f6jcM1zbpS5FnxlVqvGDhFaC8nKLWqiwZP/NE0MR4
	kstxkkpycOEv4e4/vsVQ5jYtwy64FJamzV5vxSaxfUtCNJUumWqvXv482XRWc2wy1EvYnW
	4rW4kp2g1mizoEZ/aD32EBRHlYlm8xo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NWlgOimx;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762848642; a=rsa-sha256;
	cv=none;
	b=o7b0Ij0GpJ65GWCJmH4jAxv2DUd6s19yvrWapXegArNqkLkyTACDzT1cWetCKxJNsA8c66
	IW7DqS7hr+qePPA8gcSGUQM2fR0lTnx/vtNn1Hq6PdPQlEn50zGlsCFB65Ja3MKdcdFmS1
	suvBIJDZ8wpVj6H9bNM4Jlivseqr1Zc=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso3942845a12.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762848640; x=1763453440; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TQbue78pKwkHXp+W4v6uPbf6iMxcJPuiWhAhoJWq+ek=;
        b=NWlgOimx0FVxOv4jkurGcuZ30Sil25r1xcwqHiSLESgfK4w95TsI+shuT//y/7GZh+
         vXx8cLbDzoGWEWLKmDytuLjsTVXUWzei0cEXVTha3q/4qWJTQ9aD5jFoqKHQIDYFmNXx
         3cscyr+5hz7TzXFxVwj/my0xnRjHOiUqAD/qlN2DFRtoEktjy5Z4UPIkUrvRvIRmCOs4
         WY/NaIqY/2lTHk07LzGEKT1hMNr9NTOMaVut0Rq2cIl3jrk+54c0OcWm0RQM3Dw0cRBu
         f44ohh/bD8XVbyM/T2lyg9mKKKYc20vZHcviO/cHB89WOgk0HLIa3vvfjDWJOSv5xduj
         Ilqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762848640; x=1763453440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQbue78pKwkHXp+W4v6uPbf6iMxcJPuiWhAhoJWq+ek=;
        b=wL2PCnKB3i0uTAnm9Snrmf6x4nuPCuBQOwomlmV1EBifcs1YfTSX5abfgdvkgm9J9t
         W+oyqYB2UUIpjFgLiVcaJGg2jMIQ8WNhmes91Dds/0/6CbsOkkRBCneTwzCu6Fq3v4MM
         CGZCZeZwPWbdKPBhZuRuL+wU7foZzsILEsLQTkVwRIU35fTVXVAds0vj9WDNT4dPjicp
         zIgYWpbhGfRjLS5i3YNPCWSzHVhNv8B5B66xqTyvpah4jfXraZdVrJ4icI6TTYDrbzSR
         /CGax8bdJhywJt4NAPJh158vCxh1mx31uQZlHo7QT6dQMb8ubFUVqkmQUhFRnPZh6Jnf
         FcVw==
X-Forwarded-Encrypted: i=1; AJvYcCXrdEw2L1Ub+4uZ2mzC7DPtWp6IWWUv8wyCgfmPP4IOD52NtT1okqZgK5sOls+rl5pm8EX/ji6rJA==@kvack.org
X-Gm-Message-State: AOJu0YxGgxBhpR4feMZwLNwsqjfHholOXouJGWXiuZKAMCkOEHc7j6Mb
	u+GX0rT0SdHbb3bJT0PaFgdG4MLQxseaKDpExMhjYLf8s7qmqtNneLp/ERz5mGsj4to=
X-Gm-Gg: ASbGncs3z725IhTEE0l/GhQ82iYJpioJmF+WgdKo58BV9R+lMioCyTY9l+XLYP2V+0M
	AWAvamQoblrzlNDXsPQOWDKUoy1BJFz58BjD2IhPfPLIOMT/7W+i9qnje0XPJa9FfDz3AdohgZG
	cSDibfpp5OhF1lmsMEUq/3WTY/prfGlCGnUtO4qQhlhcLKnJhO+1bNz9dlLq5w3uRCvmPYi8426
	H2B9E89AecQp49sUlNB/MPLcgkPJsywKVFnipOC6exnn9IJumIlTHjWu/MJwA9z4rTbLQTknApN
	WB15Svr/IslitkH17zMay276irZVGiPIQ/d1QJsNGdhKY89XP1FP6I78zPc8mYqKTBBzd2xSAPT
	M7el4rASBEur04Chr89hwJijz+U8P8udOj3T/g0gJhymiO7iU79PkUl8/d14fLttKaWHSZ0DAQd
	INmwP+gKLYR7Nv8UlcOp+7tTTT
X-Google-Smtp-Source: AGHT+IEZYvAe437RcYeslkObkmRF/TXOLhs0HzqzcY6BdpIa2QVGfreM/sajryoPs6lMwNHAyeu0Pg==
X-Received: by 2002:a17:907:3d44:b0:b6d:8da0:9a35 with SMTP id a640c23a62f3a-b72e028d598mr1171710366b.13.1762848639974;
        Tue, 11 Nov 2025 00:10:39 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf40768fsm1292308366b.23.2025.11.11.00.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 00:10:39 -0800 (PST)
Date: Tue, 11 Nov 2025 09:10:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org,
	tj@kernel.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz,
	laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com,
	corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <aRLvfoMKcVEZGSym@tiehlicka>
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
 <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
X-Rspamd-Queue-Id: B6A6720007
X-Stat-Signature: e7yw4m89hnw436ka7k1fpzywco1syste
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762848641-701489
X-HE-Meta: U2FsdGVkX18q1rKe5YfHoaNabhqYorQ4hhoXyh6di84byvC2zjpVr1StA0FbpmhQAWma47gpMpRdCSHWv4kFnz5npiZOLq3nP+VI7DD4/g48PlmlLbR/ineA0iRqPurWPq8sUmkkADtBtZPTWWJ9YXmLQfDgWQ4NSq97pJzb7OTiHznUVHrgkb28mN+yELYp76KqqKTo8UISiBxbTOy0g+1FgRj2aPdMlOWnQow7sIegycRLMQcKdSLRQpUYi/B0SFavqclRjMTkt5JqN+l3hwD5ueVKgar0eMqBoY5ZtJvuTw0oqDZQHxcST4Uodw6BbkT+A1xmd831pL6DjGGtuVW1UgeYv0A+AiajQN8wxUcqoGVJZSAyQblPc+RMBn5Umhhf6O3clbuwLMEibzIecKDxbtR4P3gdR1x2lo6cNzFhWzThChRLEcZ5jbPaiO8j1X6MP/0zXZV4K0ndfVfRk2ftLnRSEXaNjfJ43k78/Nz8D35GUGiuCAPYrLCE8OzouTeBRFzNzmjzG9kAcCGyDrB9Vk4nPMywIxfg5l5sXXWW8YDipo1aI6OUYmh1dpyt8nUUZFXfmRbLAl1VISC/v9sMbfeHxpYuQ3OVd4JXHeIttqL1XM3TitUWxA5F2plZhK0WgHuyhLi5oXZgbfUbUT1kdjyEWMwBs34sCQlRUoe5mi4LExpMbHui8UGxL6O+3f9anhh4Jydh9veQLpr61BQlMnT3w05IMxkZSqIUw1uhQJdBPtbX4s3biv/F1Qd4YRHawUDGE49dzmIampaKyY1X5DecI7ptg2YYaIDqP/mCzIxdbCimSseyNYJZTdSyUvbBrUzez2WMxTPvzo4w9NaBLHAtDSqZ11fIwAqlP5lR1Nw3zXEW9eS3TXyOxlXsVoisqUAGE0x++NIURUze624OTEZW9D8NSsleGE4TE1sBYK8sVNARbv69TpzeLcA+Z+p34CWGAz1ESkvzC8i
 FiNVtWtX
 rJOuM3RtJhNeXcmg3Ri/PdZA1ESY6MaAknf4Yv5x/7ZFrb6T74N+EQ3zZ6OyJOowlslyTl2RlsTCjpDxBHtS1IBiAdtcbeWs2DvE0Z8EMVmPTPslmxc/tgoWqE779I5QsPSk5cfXIYy2NgUDvpWPTJqokqwt7rHz1Xmgh6RKxCDLmKsVxvpvYEpTNT/Bmph2EoLq5Wod3vRm4PHnMcIcLNTbvmNUyO1fTP+Heo3X/eTEtL62YN8oanwBsze2IsU0GFt6fZk4CcnIyeW00HJuqNAo1Kyj6XH/9D6AG6/GdcxnZ+R5d2u4hQPEfpa4LrRJAduBE9CF3JoQOy+RIa85H3OsWfTKzWoVP/2eqBAbvKBSLBKz2ySbnjmAWaMERqy8bfD6LkxKIQT1SFa9SSz7Gi5bg+PhvqTG5kxm0Ablm3OBx2r97eCF7y2jhDgVocr3wT0xEiHmFnb8YJBvW6eHM5+FyE60coYi8fsPG7QfZ690H3Nasn8xz9A66h7oPEPP1YyqFBsmIZPnWhONIR828uMrG6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 10-11-25 14:50:11, Michal Koutny wrote:
> Hello Leon.
> 
> On Mon, Nov 10, 2025 at 06:19:48PM +0800, Leon Huang Fu <leon.huangfu@shopee.com> wrote:
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
> 
> I think it's worth thinking twice when introducing a new file like
> this...
> 
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
> >   echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
> >   cat /sys/fs/cgroup/mygroup/memory.stat
> > 
> > The feature is available in both cgroup v1 and v2 for consistency.
> 
> First, I find the motivation by the testcase (not real world) weak when
> considering such an API change (e.g. real world would be confined to
> fewer CPUs or there'd be other "traffic" causing flushes making this a
> non-issue, we don't know here).

I do agree that the current justification is rather weak.

> Second, this is open to everyone (non-root) who mkdir's their cgroups.
> Then why not make it the default memory.stat behavior? (Tongue-in-cheek,
> but [*].)
> 
> With this change, we admit the implementation (async flushing) and leak
> it to the users which is hard to take back. Why should we continue doing
> any implicit in-kernel flushing afterwards?

In theory you are correct but I think it is also good to recognize the
reality. Keeping accurate stats is _expensive_ and we are always
struggling to keep a balance between accurace and runtime overhead. Yet
there will always be those couple special cases that would like to have
precision we do not want to pay for in general case.

We have recognized that in /proc/vmstat casee already without much added
maintenance burden. This seem a very similar case. If there is a general
consensus that we want to outsource all those special cases into BPF
then fine (I guess) but I believe BPF approach is figting a completely
different problem (data formating overhead rather than accuracy).

All that being said I do agree that we should have a more real usecase
than LTP test to justify a new interface. I am personally not convinced
about BPF-only way to address this fundamental precision-vs-overhead
battle.
-- 
Michal Hocko
SUSE Labs

