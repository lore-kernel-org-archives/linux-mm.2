Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1748ACCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 06:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BE18E001C; Mon, 10 Nov 2025 01:38:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713278E0002; Mon, 10 Nov 2025 01:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650228E001C; Mon, 10 Nov 2025 01:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5195C8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:38:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BAF6140C36
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:38:07 +0000 (UTC)
X-FDA: 84093742614.16.B5C84E4
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2E703140006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:38:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="RruGrH/3";
	spf=pass (imf23.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762756685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmBVMknsz67ut23E5K5rufi/vJYxx4RPQjR4CpqkZ2E=;
	b=HE/pDHgZNk2rfaa4K1C4O/W3gpImxUFbmewhz6vcUqEHjww7m5/6H+vEz6zN37QC2nTfdV
	TvEwlRKf0LnJoF4DGlX5QcmjQuK5Z0t0MSdf5nyJWF02yTQSEd89diZNE8yDGYuwGZzY80
	vl+c+Mg+YHLjIG6DQuSi8ePNir1JsWA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="RruGrH/3";
	spf=pass (imf23.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762756685; a=rsa-sha256;
	cv=none;
	b=D0ev/i9waOAosBlT0vC1btzbE9MabD3PMvNH0wKhhC+FDTGAsiE5byWMDFPi2IEt9JCz5a
	xHG8rMnUtiWzQ5fy2IHemR9xA/PTvI9xua7MvIRkDJ7tfq4x3wrk4XHtpLYDgwZ7uaHf+t
	5l8W4pvKDtjxz2NnVFgqboWo9FzwqPM=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7af603c06easo2366313b3a.0
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 22:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762756684; x=1763361484; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wmBVMknsz67ut23E5K5rufi/vJYxx4RPQjR4CpqkZ2E=;
        b=RruGrH/32UawlT1mPIC8FTNx1ZFuPaeQCdzOYCdxMeFidKuGs0iqYMewvExzWMySHs
         CfwXvzaX95AMEwtK0e2yfmNj/+sPcsJ2JtOIpIU61bB5woR08LKLNIdJ5D1Bj9DK1MXt
         j9h4trma9VAl5+bWoXb6OgtPEbqwL6ZZSorm56NhABnzhlK0FnFbMSVlHPW2cou4657Y
         MijrjCaEfeWPj8KbvVGlwfHgiXCLx5WbNpNR4AG/g5OM85/rXCyFkXgRicDSKNN/XrQ0
         nooB9iH78erX/nucXMUBG5KPxgc6srCA8MspVvbjjuseZ7kUrIFJe6Tw43xdeqEwKLt/
         rOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762756684; x=1763361484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wmBVMknsz67ut23E5K5rufi/vJYxx4RPQjR4CpqkZ2E=;
        b=XdRhUT7kyq4nz38DUmXS3sYOEJyTlc36xjrippnW9hfWbpyG6y/vr2/S3trrByVSEi
         kPqNmjvs73vvPHPkgNgTjGQO1N/8NURplZA2WKpWk/P5WV5hlneK7navt/6s4h3xj68o
         I29dex5vI7Ve7RQNzulfq0fEIuqZAufvTqwC+YWj4NAy9E4IQxN9Fu5LgzH6aal2x34k
         7hcdFr4Plu8ndykjH58ACbeGE0+neYphxfnvldrwXrfcHzQ4nnBW+vaBTIOl9L1opvL7
         ZRiP/VnIEH8PyfLAaAMad3hCwR3e8XqT6hJr01AkLScietK/PRNgJ41DP0GaP3p0ki/a
         /YWw==
X-Forwarded-Encrypted: i=1; AJvYcCV/T/vlZLK/2gphDAxgnFwpL5ywxJlxZ7h3rB8MP/o2c9BmRCAgNZg4flavHjnZj+TwK291b2OhIw==@kvack.org
X-Gm-Message-State: AOJu0Yzdr+VnEdHvtHM13cVUypn5f57v+L0yaQyrW2/6PIZHcBu9sAQQ
	vk8uweNNCwHYVrsFcJSjpoAja93REjFmJK2rAhqgJIR8BN6IwvyJl4PrEKpYEN59NTI=
X-Gm-Gg: ASbGncsUlGEImkwGQl58ZMujbJIsUtNFTVe/Ta35GwESZX+xBttinRH4Aa+LfKjQ+ks
	xWv2XnxOQi3LSQtMmcdmoNlr2Ld8LVCc8lrpvcwQ/p5B5R7DmIflFpkgb22qL/kA0yRyaZW7cQP
	cbGQgrjeNGSKZTe7jKv/5QrdyFR4PnAb0AUCUKZ/dfQddKWknWFCVg45dRsnOyXjiGVuQ+1vILY
	ZRavicHYoOefQ50iDs6E2sDua7XNIihQtJRMlJ5+sJtPaRcV6y39nwdMsD35HW6QffW4XYnLbgZ
	/BQjOSQIqhzWNIdlzyBAh5VADrX5fOuJmXAeRWkXMfcq0NTRf22JiuAXLM5I4h0arnNT8E6aoNz
	fTGLU/rfP+dqFOLBS3ftVnyyFuFAbOvHKgNT3gRUvGTXmDGYGSEu3VTlnqfVgdUZ3RpGX3U0Hd2
	Sa7wnEbtsOVCZKrQ==
X-Google-Smtp-Source: AGHT+IGpM2iMSrs4WgXitoPVDoGbl0s8jdXiEXMRW0CSHSXbsOrMNjve/Ihdvic39TubC73LXbxmTQ==
X-Received: by 2002:a05:6a00:1a8e:b0:78a:f6be:74f2 with SMTP id d2e1a72fcca58-7b218103464mr9344608b3a.5.1762756683995;
        Sun, 09 Nov 2025 22:38:03 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc17a688sm10609451b3a.40.2025.11.09.22.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 22:38:03 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	inwardvessel@gmail.com,
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
	yosry.ahmed@linux.dev
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Date: Mon, 10 Nov 2025 14:37:57 +0800
Message-ID: <20251110063757.86725-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <blygjeudtqyxk7bhw5ycveofo4e322nycxyvupdnzq3eg7qtpo@cya4bifb2dlk>
References: <blygjeudtqyxk7bhw5ycveofo4e322nycxyvupdnzq3eg7qtpo@cya4bifb2dlk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E703140006
X-Stat-Signature: 1yx1d14c78i7dns5jzyd46wzrbspp4h3
X-Rspam-User: 
X-HE-Tag: 1762756684-890346
X-HE-Meta: U2FsdGVkX1+soZxGJV6s9vDBmx1HKLWfg+aXzNjKS7wCnfHMRqMTJpu4/TqYSP443XxzTxcQ1BJ6tfkN2fjt0S1QT3/C6NHTMnvYSGFD5Q0NcMV6EZvvrLrpGCApvKnKX52eZPpTw+YWjCjS8xGyirDWWbi/miYvQ2ELxVf2DCbmB6CIo/SP537UxlIDdlaQ/hHZ3W7xYr8yhtWEHS1l5yNlXG1s+SJMxJV0994VLTbg2YSJRZYYCn9+WOvfoxsMzk1g4W+o/qLf8KJDKq6aoBcec+l8ngaqpaqNd8my+tFIxGfYwC+tHJc8AQXNNGYOXya7XMA7bxel4rX3LWFEvim210eTCOa+1hSC4sco5yZX8XOy6NoWcczQSzd2hYCJPB8YQkz52oh1ma+4Wz/EzSrpO5rmg+N65MyWVDERaQU+HGay1MfE0SWInCiqgsvkEnazMMIdinzaw1POMq/OpiiI5rj3ZhLAnpWJ4Rn/bOBuWXCS/sW/tWIABYgiAyIUhfyboXxQMvlQTVkyCr+BYpS7eIj5RPdrc4ZafvKeI7/5vdYRKlOo1xeZuP4ddnwqVHLsibcCYZ65CNWp49GVOFNDVOU0KKzPLeWzOIJlgBcaPyoboF/Oc9oRDXgjX0cd4oEv+NpiWN3V8an1hSU8o1c9OMC1sgeePU2y9zckrtvU/YkdrQQPpWwfjrD4vDbvjSSKldP/bILEvCs0o/a+7nlFrVUkv8gpjt7RQmw422gMQrnulxqePobyzGuP1MArFU0xvqi9HdH/Y/oB1FxfA5Rs3yA/+1J7sdAA7ROOo/s1MbspA/fzntiGiXJd7b4Za5q5bNAYUatObGr/ubPvVI4+fAqlzbFEWNWGQHF0edKeqqpq7SlCphOybqZBsr3Ni+Zvfn1/CsNqBz4uDdM2PJjmT6JQTSB2M1FD5I0MQX8j6fx5GpiLOajgsU/n75FwnVxQTtIAFyp04VqfkSf
 Ap6NEGRS
 dlCECSlUtE00gUce2TlxG30XzFmuRVWGqoGOqHx4glTnkabs4tWl/nkpYxkgDHLwhZ2qbPa5CmRZ+E4ed+H6OLdAzbULXt0RnhSSOd2KhoW6X+i9RHzyjHelh9zSiYyV3OBw4N/eYy42By71OtDLOu4AyT6yiVKhtwBxY7wxj+hvgfBLuj1wOwLRxTK9TKxkP4O8Yk7HXG/kxbk+Pq8gSh+gScFUt2lyB5KbM/QIX2LY5nZcK4Q0leT3RAVnupvNjIOcQZs4Q8duWPZO0MvX/I41RIe4nqkdDX9XaVQRE+iHfnimZizE//aLMomVwsPFxBbwsRdCI8rZwpKnEfpr/P2Weyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 7:56 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>
> On Thu, Nov 06, 2025 at 11:30:45AM +0800, Leon Huang Fu wrote:
> > On Thu, Nov 6, 2025 at 9:19 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > >
> > > +Yosry, JP
> > >
> > > On Wed, Nov 05, 2025 at 03:49:16PM +0800, Leon Huang Fu wrote:
> > > > On high-core count systems, memory cgroup statistics can become stale
> > > > due to per-CPU caching and deferred aggregation. Monitoring tools and
> > > > management applications sometimes need guaranteed up-to-date statistics
> > > > at specific points in time to make accurate decisions.
> > >
> > > Can you explain a bit more on your environment where you are seeing
> > > stale stats? More specifically, how often the management applications
> > > are reading the memcg stats and if these applications are reading memcg
> > > stats for each nodes of the cgroup tree.
> > >
> > > We force flush all the memcg stats at root level every 2 seconds but it
> > > seems like that is not enough for your case. I am fine with an explicit
> > > way for users to flush the memcg stats. In that way only users who want
> > > to has to pay for the flush cost.
> > >
> >
> > Thanks for the feedback. I encountered this issue while running the LTP
> > memcontrol02 test case [1] on a 256-core server with the 6.6.y kernel on XFS,
> > where it consistently failed.
> >
> > I was aware that Yosry had improved the memory statistics refresh mechanism
> > in "mm: memcg: subtree stats flushing and thresholds" [2], so I attempted to
> > backport that patchset to 6.6.y [3]. However, even on the 6.15.0-061500-generic
> > kernel with those improvements, the test still fails intermittently on XFS.
> >
> > I've created a simplified reproducer that mirrors the LTP test behavior. The
> > test allocates 50 MiB of page cache and then verifies that memory.current and
> > memory.stat's "file" field are approximately equal (within 5% tolerance).
> >
> > The failure pattern looks like:
> >
> >   After alloc: memory.current=52690944, memory.stat.file=48496640, size=52428800
> >   Checks: current>=size=OK, file>0=OK, current~=file(5%)=FAIL
> >
> > Here's the reproducer code and test script (attached below for reference).
> >
> > To reproduce on XFS:
> >   sudo ./run.sh --xfs
> >   for i in {1..100}; do sudo ./run.sh --run; echo "==="; sleep 0.1; done
> >   sudo ./run.sh --cleanup
> >
> > The test fails sporadically, typically a few times out of 100 runs, confirming
> > that the improved flush isn't sufficient for this workload pattern.
>
> I was hoping that you have a real world workload/scenario which is
> facing this issue. For the test a simple 'sleep 2' would be enough.
> Anyways that is not an argument against adding an inteface for flushing.
>

Fair point. I haven't encountered a production issue yet - this came up during
our kernel testing phase on high-core count servers (224-256 cores) before
deploying to production.

The LTP test failure was the indicator that prompted investigation. While
adding 'sleep 2' would fix the test, it highlights a broader concern: on these
high-core systems, the batching threshold (MEMCG_CHARGE_BATCH * num_online_cpus)
can accumulate 14K-16K events before auto-flush, potentially causing significant
staleness for workloads that need timely statistics.

We're planning to deploy container workloads on these servers where memory
statistics drive placement and resource management decisions. Having an explicit
flush interface would give us confidence that when precision matters (e.g.,
admission control, OOM decisions), we can get accurate stats on demand rather
than relying on timing or hoping the 2-second periodic flush happens when needed.

I understand this is more of a "preparing for future needs" rather than "fixing
current production breakage" situation. However, given the interface provides
opt-in control with no cost to users who don't need it, I believe it's a
reasonable addition. I'll prepare a v3 with the dedicated memory.stat_refresh
file as suggested.

Thanks,
Leon

