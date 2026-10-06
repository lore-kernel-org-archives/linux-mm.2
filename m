Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F76CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 12:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61DC66B0088; Tue,  6 Oct 2026 08:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE646B008C; Tue,  6 Oct 2026 08:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCFF6B0092; Tue,  6 Oct 2026 08:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7FF6B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 08:32:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99BD91C01BB
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 12:32:31 +0000 (UTC)
X-FDA: 85292139702.01.8C60B9F
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id C2AEE20007
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 12:32:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dUR/cxl/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791289949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HKRIiBlfoiGul+mMoQpEEjIcPaSF4T8zm8QS66XhNQ=;
	b=fv3nzGErJv6jUxShDFORVszgb9ZkZcXGjTSmMFJcLbRcc6Ml2siKxMBofgNlI42ta2/JcP
	nGn9YyDGgRh2moLnIOgC+mW84V4RFvl6FQSV1C7mjQpvGGkz2NYCdMoU+79vrkEXftPc7S
	8bEHJmVmct5v/5TFAtpvBkKDoFdBGV4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="dUR/cxl/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791289949;
	b=iOix1BnGgWf+yiBce6uVSmrcIe9Bcw9Rxtkh4+xSLpV0GuVYf1+B7CwEQjmlA7pEGv6f5B
	SH1KvSDeFT7eTMAXfchzOg47LCys7HOXBqNuRwlT+bpTonxN9uJQslenYWE7USwR9VCUrH
	oNImFnP7tIYPzPfnzbKzibIfHYuTHNQ=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3a886d6ad51so88948a91.1
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 05:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791289948; x=1791894748; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1HKRIiBlfoiGul+mMoQpEEjIcPaSF4T8zm8QS66XhNQ=;
        b=dUR/cxl/R+S2IeaALDZgwcHG35jg6raN1v5zZ00oSlq9xEcfQDdMcKCQhAwqeu3thU
         50V9wXS/S3R9Jp/IIBYwAytjI6wGC/zX6LP9fHG9GIIED15jjYRg1DAJpIfyIEr8eTN9
         z+hgBzZWKhOdB2U96kDUCs3jAZCTW2l+qdeNoyOYXjUeCKcTgp8064IFRZ3lJqQthSqw
         UOk4tlOdR/nP/u+bFdhwY1N7P+gWRiF6dWZQO8ttBqaO9hlKK4sXsf4XmXiekUzUbaZ0
         iWAi0Bq1LJVCeR7Ff4+xGRoN7fGuyRtpcVf/nYAv4BHn7JF7fKjH41j+Nym3YWZM3Zqn
         4L1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791289948; x=1791894748;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1HKRIiBlfoiGul+mMoQpEEjIcPaSF4T8zm8QS66XhNQ=;
        b=onCLFPD06Xm7AeYUiexJ4KQVY9dgzm75ILUXKEJsRnpNQxIYDkmFHPyFcUL8QpaL7N
         5vOoOSUFdIdtHB1zY8dcwEr+A7oR8q2OkP+8PTqducAlF+rqk8zKrkBsFDB7YeKk2kCn
         g2qX+1iNOxSc9r4+aPFoBMvZOZcFJ6tL+HA2Wmf7hK+W0FzFJUY+p3iW5hg/Tt68ipjd
         FbwodbGWy5Eg7sKJHwfrvB8MEeQ/+Ig4VM47wbuvOkaOGK0Igt9t/8Rntw6bsVzTq02n
         mWl4dttBeGfKjj+3b1w0YJzMUTw11eJ32kHVse/axUI6bDgjmRXGU991uu6ihnfZa4ia
         J/xA==
X-Forwarded-Encrypted: i=1; AKwUvBzLnsUhhwpCPlhAcMHEgMHRJL/2+P6Psqg3wPcMym4dP/DnT/UFJ6m/pPQkYbJ5nnsdaYnegHRa7Q==@kvack.org
X-Gm-Message-State: AFq9FYIQWFNCuigtCfOxz8BAOC84ntO61IOOwXB2cUiFnDVRo3wT+ANU
	SuNyADSa+V4urXuWHI392g0HLq6WKTZiQJV3rfdp2QCJxFQ0fRSL+1/S
X-Gm-Gg: AYBFou3yMVDx63C3MlBzCns3GixvergSQoVz0sf0059dWzY6uO0euNq5aGgb57jCtGh
	TSguxANo9D8sjUbX1MVx0SIawQzWktLw4A984wyRqlD/0FjMsG78IFcVSf9C9Z9TQF0l+ITqEkM
	IoKhLV+I6DNojc1vTyWy0yAWYe/0QrVp1KDTKVKNUBSlJQSBcSS5HJmxuneYbINRwCgiKtWln2a
	Nr7G4GBv4gefpU09wgRq9/598cn/qmIJe95AaN9XtGrKStbMb/QXk4yQv11eG3Aawn4hPLKdW95
	tcIqV4yDZgELOl/VpzBpB0D/xQnxdn0E3dLh04nF3FLtJTYXq84WtBGTlisbBTVJjWTp4W0j2xp
	aACNeKBrcTQ/+Qx6O+omlNsxRmi9NrCOnZS0tpk7broy73cDf1C6Z88+VYpXur7J2FkkHCPbg0j
	KpDvGVs78hJ0pi12W+a62vUeIT0QczpwYfL3GK7fCVpE/aWrh5OD5LBEp+ZHX0XZ9VKZCwvvAhL
	SezRMcDOAfqXA==
X-Received: by 2002:a17:90b:17ca:b0:3a8:748e:c422 with SMTP id 98e67ed59e1d1-3a8748efef9mr1039769a91.8.1791289948330;
        Tue, 06 Oct 2026 05:32:28 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a853d00fc5sm4898516a91.16.2026.10.06.05.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 05:32:27 -0700 (PDT)
Date: Tue, 6 Oct 2026 20:32:13 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, ljs@kernel.org, roman.gushchin@linux.dev, dave@stgolabs.net, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
Message-ID: <87a35a80-07fd-4915-82f4-447c61d1b6bd@gmail.com>
References: <20261005062236.564210-1-vernon2gm@gmail.com>
 <CAGsJ_4yKSoCwcEDhtd=biKoUjUX9eTJJhFJGFAZWc=WsAyXycg@mail.gmail.com>
 <4cdb95f5-4140-4116-8247-c04f4b2a5c4c@gmail.com>
 <CAGsJ_4x3n1g1tqxFnnLj8mS46fyYNWQq6goqop+_2QoKO09eeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x3n1g1tqxFnnLj8mS46fyYNWQq6goqop+_2QoKO09eeA@mail.gmail.com>
X-Rspamd-Queue-Id: C2AEE20007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: jc61o6iggs6h3fb9tik4nyryk9madnuq
X-HE-Tag: 1791289949-563963
X-HE-Meta: U2FsdGVkX19xy9OVMX7cNFdgoLPnbz2ZTEbl1DTLcazzQtGw3HJ1JgL1GW2TWSSFXk/ceeHKb7O7/5e0SV/Edf/cjZzw9LuJopY1gmo5z9d0K91RntuJ7pSLxNBWPofOGHqcERWNNmpXTiPUoFy4dJWco2TIJINRAzk3voGPXB3YYrQYcWKrT5G1nJaEc2EBoChTCMAhD1XMviN9o7SVhRvJk9IIh0AKm8+37zkMKrMvs3mX+NOerQaY21EwKA8SMHcLnMDByGnzWYMiZQ2uBsAcs2QOAhq26J38WH2hToS5Yi9CIF6n/ysK3WMtQejheNDmwQDmmVGBPL6iG2NKUdsDyKfpMZ5jGPsTTrYwBBkTKXHkTX017BqpMK2n4bpobzV3WZV/SSIDBWC3oA3AuRMYDVgk7S5D7PJC+bjLfk32gF72xvLe0DNiqeMP76O5cTo74kfXIw0QNeR4fSDdFFNTmXRHXeETk97ZA9peca/6jwqdI83EDl0yRXsSZWmkHpxQwEq3RA3XBxgsuZyzbEW/DG7QNXXMeYqf4YMKn3oElc1KvBPjwC+AKZF6XhgUaxaheOt4ezoAYx5IqoodI2bjYLDs0XaBAnA2UEPkGekqBOUumiIV4V1sfcnbV+oTbmwPc1nsAw7ZiZNn4OMoL6O9g9mQwoSyivL6bFk2Tt0xN8zTam396v/ywnGJqtNLIt7Y8src70n8QOC5dzsIJb7sQcZ29xSRtHx00pbYNfPZhjqUjLBhozAzXKWVPROOMqAV5MB11r2sGx7FEJyLlhHrdXCBggqJYx88dp8YU3P/YFRNrIc8s+KNzK4XboQu/z2vZmxi+sNdsBhOYklT+MyH3WYWCgRSZzcPghqPRtNp7JB00t3lZhwbc2mlnvpuWrfT+MvONerGKWji9fOkEO4Xv03EEYe0+aZUOMgYRT7dvCahVj1YR+6A2F1t2fU4jkMSzCGy0VCv76Y7CsD
 Nv2yWS25
 wC4VsTLaudpRPe+90cTYRQJBv8yWVHnln913M3gFRLsjuGn7CIK6u/vN7F/PgvSd8T8zRWD/64UIN0z+ddQP0dftpWGUZmCQJU+RkHsK9r60rHitFWN1YEfN2dMWHDoBk8UR+hyuFyAfnkD7L+vPKgZ9TW3JgWpAh+RFkk0/XqUSqFH90+32BMHn+PwSNRwcCe7TEY8r09KvdvfOVtR7xPSryM+Ac3t9C+vJME9yAb8u5NFaFShai0UlAWeI6dof22LSSlCS1SPrpV/cwJg4KY2uX0DkVC6Pfk07s6ejy63wfz0jdFP5LPp9xjYP8TDbsoXFH1VA9dud5d7pFb5Su9liMRTd5sTIqVgJ/hUOkoWvlSpkFShRX2TtiAVMVabMmCGQkEXTXWvilUPUAVBWU3fCbegAHjf9Q3DT/m9mwwdR/RFzNMUdZjlvwY3OX9Xg5/fmGSmesEF2xgqSR5/FJRAg3bbsHMA0VpVui/hfyICwczDWd2KVU8gzggNJK5W0VZSeKT3YLisioHdqUBgA/2aCrxBpfPX6zPyf3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 06:17:02PM +0800, Barry Song wrote:
> On Mon, Oct 5, 2026 at 6:21 PM Vernon Yang <vernon2gm@gmail.com> wrote:
> >
> > On Mon, Oct 05, 2026 at 02:30:36PM +0800, Barry Song wrote:
> > > On Mon, Oct 5, 2026 at 2:23 PM Vernon Yang <vernon2gm@gmail.com> wrote:
> > > >
> > > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > > >
> > > > When the cgroup has no memory pressure at all, writing to
> > > > /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> > > > NUMA node, causing increase in the writer cgroup's memory PSI.
> > > >
> > > > Due to this reclaim is performed in the context of the write(),
> > > > accounted as memory pressure on the writer, like
> > > > commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> > > > as memory pressure"). This is unexpected, the phenomenon resembling
> > > > senpai will appear again.
> > > >
> > > > The Documentation/ABI/stable/sysfs-devices-node documentation also
> > > > notes that "This interface is equivalent to the memcg variant."
> > > >
> > > > This patch unifies the semantics of the memcg and node interfaces:
> > > > per-node proactive reclaim is no longer counted as memory pressure,
> > > > and the per-node proactive reclaim interface no longer produces
> > > > phantom pressure.
> > > >
> > > > I ran demo[1] that performs per-node proactive reclaim 10000 times
> > > > in qemu, writer cgroup memory.pressure as follows:
> > > >
> > > > without patch:
> > > >
> > > > some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> > > > full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> > > >
> > > > with patch:
> > > >
> > > > some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> > > > full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> > > >
> > > > [1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi
> > > >
> > > > Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > > ---
> > >
> > > This seems to be a valid concern. Personally, I don't like
> > > having the code depend on whether `__node_reclaim()` and
> > > `node_reclaim()` are called from proactive reclaim or page
> > > allocation.
> > >
> > > Can't we check whether `sc->proactive` is true? Am I missing
> > > something?
> >
> > It is also fine to directly check `sc->proactive` in __node_reclaim().
> >
> > I chose the current coding because a previous similar fix commit
> > e22c6ed90aa9 was written this way, and it is also very clear.
> >
> > Of course, it depends on everyone's preference. If everyone prefers to
> > directly check `sc->proactive`, please let me know clearly. Thanks!
>
> I personally think the following is much more explicit than the
> current implicit code based on path dependency. no?

Yes, both implementations are fine with me.

I usually wait 1~2 weeks to give all maintainer/reviewer to review.
As long as no one raises objections during that period, all suggestions
will be accepted in the next version, don't worry. Thanks for your
suggestions!

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a931b576b7d..048ba11852fe 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7997,7 +7997,8 @@ static unsigned long __node_reclaim(struct
> pglist_data *pgdat,
>                                            sc->gfp_mask);
>
>         cond_resched();
> -       psi_memstall_enter(&pflags);
> +       if (!sc->proactive)
> +               psi_memstall_enter(&pflags);
>         delayacct_freepages_start();
>         fs_reclaim_acquire(sc->gfp_mask);
>         /*
> @@ -8014,7 +8015,8 @@ static unsigned long __node_reclaim(struct
> pglist_data *pgdat,
>         memalloc_noreclaim_restore(noreclaim_flag);
>         fs_reclaim_release(sc->gfp_mask);
>         delayacct_freepages_end();
> -       psi_memstall_leave(&pflags);
> +       if (!sc->proactive)
> +               psi_memstall_leave(&pflags);
>
>         trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);
>

