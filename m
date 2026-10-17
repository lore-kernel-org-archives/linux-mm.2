Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B463CCF2CC
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 21:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17376B0088; Sat, 17 Oct 2026 17:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8C86B008A; Sat, 17 Oct 2026 17:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB66B6B008C; Sat, 17 Oct 2026 17:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 870546B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 17:16:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F6B214027B
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:16:34 +0000 (UTC)
X-FDA: 85333377108.26.906E9A0
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80175180004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:16:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ipAjdVtE;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792271792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qguhYArQk/KW+dhlWzdBW+K99B5MVDRdS3H3exN/DQM=;
	b=IEIQBHEW7qGEMX4X4vh0K5GFL5/YOSWxYYtXijUy2BYkHnn44nE6warxHtN5jPv2KsgyLo
	HKHw4WtVOMYcbEEHXiyG8FxIFm1NoaSINsDjPUtXoWtfQeZsMxiLBNTaVSsQw0MUDH+SNW
	IRiSOA1uHOPM2owuahkv91ypx2VWaWw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792271792;
	b=iSyjzv8fle+07ZLaIqJHzv3aVZJbW0ahX66Wh6ycqbtMHcdQCzBRPnmzGERRdOACnglRYP
	/a9TwdNsZcM9U5eCWTvdogy0hlMdMHhpWPRnG14XHj2FxA8/St4RaP/0gFFbKx6gyEEPu+
	c/e3UJTzDUsqPHEKTorZmycoSt9TgGA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ipAjdVtE;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-89f28c3ac7bso303906b3a.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792271791; x=1792876591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qguhYArQk/KW+dhlWzdBW+K99B5MVDRdS3H3exN/DQM=;
        b=ipAjdVtEsyhJZax3feaem6WLz3ESgdm+gpmVVWFe6q8wswhlwW687JjD9/Z+w/2Y/E
         31bZsRUsEHJL2+8RXfKZ5hkKrgANF4evfFm5gUdPIsrmVTv8CBp66zNFaWHeDq9L6OOa
         eaMm1YiCHutg/M1kItIUHkLk27j02X5gOhCbynebno2DafHFhUZv9CjasQN0YSEMKDTj
         f9ESXyjbk/NFUk5593x6cr0fOYHp8uHErzzUXXM8zVEcR3EXZpF1HPlQtR6aREi1IIEA
         p/DL4zQuxQH5H4uiPxx/M1y3lSvVm+JXYAsZbUio6VcMhHB6SKVvWiGXqerZbFaOgywD
         oQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792271791; x=1792876591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qguhYArQk/KW+dhlWzdBW+K99B5MVDRdS3H3exN/DQM=;
        b=lEQ1uRQSyivaxNqaCxn9J2hKDY3/s5QOoDqFH2fk7Ogfh7wO2dVBwEnAZg9CVB5Y+k
         6nF8A1mx2/WyD5b4Hy/eEgVfAOmnS2yCIqYMlHQdApaAc8UvnwReidmuSlhmYcnkpLOq
         DibyAZqed+wQnoJBHORttMYZ4MEimF/W6nah3061P5t+p8lO2Op68vNSikv5zb0yA4dP
         RprvkoSVF4x8JlfG5S6m04jLo7/dGMtGhjbibGNxJRY3bESi7fznYw+Hq8EBKYy2HQSc
         Wf7wg/dyqpNiScb5d6iMSABXd3uyOKRP3R4ZzrfLQOrWlQfYNDO7Wv34d1Gx2tZdZf0L
         p1Lw==
X-Forwarded-Encrypted: i=1; AKwUvBzJs2uY44rIwvMZC9QlsWq78WsaFNsWs2u+QVUdV3LxV2pufOlN4+JwJSMbFbbKxhEdnk6oNGlu1w==@kvack.org
X-Gm-Message-State: AFq9FYJBMXUwD67IV+N0vihv05sb/mgLclH2MU0scOBWW5d/g7RHIko1
	HrzaViNwFJCMyaTPIhUceJUM7igVZ9IffDw1gfYwY0VvuNlb+CBn41qV
X-Gm-Gg: AYBFou3ebcWCDNcNP0qD844fLSWtK7gY409JMEfSuSmGFvK37Bfcgc18tCJDeWXZ8I8
	r0UyOoN8L0o7GpW4LIyJamy2LSKkQ1ge/oxoPGRrL16ZqNuBfBplFwN1/6rkFPTECQlXQoyHiWQ
	2JtJqPk2jBcUOjdL+iXL2aLSm+KfkudwxrYHclSAc9ilFSkks6b+EGBHoFou2dL3f47iNwUrX5O
	IZfsY2tHjasqbWqPUYNoH2wVocFYsvyZ4ZEGuFNCHlBwaFeO5QEZ6p9m9CEiXIC6jaKiJodxqrW
	GP0q+aZ0YHHmRwnBGm8JHMI0B2z4+xPrFSDpve5oSvZsozICSWOosyhgX4Z+5KefAbovXb30KWy
	l7eyLHYs9NrdNIp1ECdjSpxnGaDfmrsk02Offb/y0y+x5kTxtmKxhqqMv8Bn5qa+IQV0lEh1pvH
	PpoQY1Stj82nVwOI0On7sDT+b/rYDMD+j/6zM4ziLCR8AQtOXspcKDWvp1o1RYDlG/JVXPfxvQT
	Q5hPrj/60keefQUslHVZXVpUA==
X-Received: by 2002:a05:6a00:1394:b0:898:9b2:605b with SMTP id d2e1a72fcca58-8a04d23d89amr2331468b3a.56.1792271791111;
        Sat, 17 Oct 2026 14:16:31 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8954:498:18c1:c1ef:4268:7168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c8b922sm2460239b3a.11.2026.10.17.14.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 14:16:30 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: Liew Rui Yan <aethernet65535@gmail.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Ajay Joshi <ajayjoshi@micron.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	damon@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Lian Wang <lianux.mm@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Rientjes <rientjes@google.com>,
	SJ Park <sj@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>
Subject: [RFC PATCH v4 0/9] mm/damon: hardware-sampled access reports
Date: Sun, 18 Oct 2026 05:16:13 +0800
Message-ID: <20261017211613.16456-2-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017071120.4628-1-aethernet65535@gmail.com>
References: <20261017071120.4628-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 80175180004
X-Stat-Signature: 6erzzdquyjtxrmedmeksrnrkejtpupyj
X-Rspamd-Server: rspam05
X-HE-Tag: 1792271792-593777
X-HE-Meta: U2FsdGVkX1/d8R/Fn9eJZjSC60RdPFMc594qBFmQVz9Xqto/dHabUfQWrVQIhCohEexGJkz6QmdbY7mebNhy33ayrw+2os4aFvkGrnYMK0fVa0/xY/ruXpeBAtucRqcLSSu6+JHFYrTvGYxjuds7jAIoIYFk6ozOwDK1wG7YfgV2aPAx0zlcSRaMjYEphSkeuTbS8qblNM1Uop83NagGrIy4QFxByKQXdt60kjDpofMOImokG3aIdmikEPalPzKkZZmahRVjBCugPaXGeNBDkIcy91NkOaxsXtsRO38USWRhge292f3gSggKQvsizRWWajUvAR/DmQDvTql8SvvZImIP1OYTpdIcXhR2/dls0QmPynDkQkfpL53VvxJ+cGa8FYibOhXXA16X6Hl4aqpJpNPxc3MaoLyyzFRmpJnBN1vSEisXTLzSlq5fm4E7nYq8TygB8FUS7bRBvqcJB2nzX0xmAY/rGja0aL8n1S5xnmZcT26NFe0x5MREqsLzcUGhB62T6i5C82djwO5SYfV/9WO14zw+a6OiJfcoIGf2ni5Adg9/j3+0Y94DY3PjnAreaNp5X5csGWke77U2FNnFuSnI6IWYPUxTcYmUbKrMNIAUxgqZwdIrRvKJjO6lyJ+2zxoJYP0neoaXmfjP8q8bLqyUPVLT7Tz4y5e5zTRltE+pvVd4dJznBGnjhfaVoMeo9tTdnxz3h6uwmcB/QwQI/iw7neQMWS2aM+WE4ucOalB8i3Lh/OTBbnCRR8aGplCN0ENyuuV8187JZ3+e2KHSasBej/ISwE4bcpp0QTLYSqcFsafkPojJD+qzjAVZvf7d/3J57IHaPcCAeOLMHPWrQlUNaOs7be40xvIb6ul7ENDSdAGZfAGxm4ct5NDGkP2TFNI60sY5Z6lYTy8cqbnQU3ecvFApyFywN5vCE1vuHk7A5LZ3ZDAokNyfMhnhmJkhZJ3JxiwNWh6P88g0jsZ
 INu8F/87
 9ZrAuZWVwc75bhgWhndc4O6a1g1D5K5Pn6WNGYK2+93qUIuTyn5ftk0mcg0Us2YKD5Ei6q0xEWp5IIykgYUSv9H6Dbu+GzDXHwVDlq/Kgunlnvqzd4/IxcGMAIX56ISJ6TZBQuODlByw/+hO2eG14nfzUtWkeNlyVlT4JyBkAKFNX8Ir1eFHtSKuRpNkBL9V2aNfbte+R1cHTDCKW/jdFKHjK1E5Oo2KT4ucX21wYU84kwpS2QuolmV88Tb7TYrf5L0N91a31MdYGvMm09es0bNO+Xh6Gq7g9TelXOYa271Jpfu46gFIg/BdDKVTin0lV+zzAb/BA9HiUtT7Bg4AQVoNJZomx6fouIYjsxJp8EeUDBjXWrLdb9k8X5HG9pFZ6o9qzqzutw45f1+t2FBzTCdavW6WryhYtC/7f6fJj/lrublO21PcYuqcwNnfTxH9gAKVk3YJyNvCPY7S/F89AX9cJ40zBZKpfMsO54NCHLfT5/uISalCZQOFUjM+v0IDAcqHsNPuwk7k0vFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 17 Oct 2026 15:11:18 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi Ravi,
> 
> 
> TLDR
> ====
> 
> I have noticed that there might have an issue with this patch or my CPU.
> I am not sure.  I have provided some details below.
> 
> On Mon, 05 Oct 2026 01:46:44 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> 
> > This series lets DAMON monitor a hardware-sampled data attribute -- the
> > addresses a PMU saw accessed -- through the data attributes monitoring
> > (probe) interface, and run DAMOS schemes on it in data attributes-only
> > mode.  Patches 3, 5, and 6 are co-developed with Akinobu Mita, building
> > on his earlier perf-event proposal [3].
> > 
> 
> I expected it to monitor regions in the same way as PTE sampling, that
> is, if the system has hot memory, DAMON should be able to detect it, or
> at least with some probability.  However, it is not always work like
> that.  After I starting DAMON about 10 minutes, the DAMON cannot found
> any hot page, even when I am running 'stress-ng --vm 6 --vm-bytes 6G':
> 
>     snapshot time: [0 ns, 100 ms] (100 ms)
>     |0000000000000000000000000000000000000000| size 1.461 GiB   access 0      age 3 m 3.200 s  
>                                    |000000000| size 1.465 GiB   access 0      age 3 m 1 s      
>                                           |00| size 2.922 GiB   access 0      age 3 m 0.500 s  
>                          |0000000000000000000| size 1.471 GiB   access 0      age 3 m 1.700 s  
>                     |000000000000000000000000| size 1.462 GiB   access 0      age 3 m 2.100 s  
>                                           |00| size 1.470 GiB   access 0      age 3 m 0.500 s  
>                                            |0| size 2.926 GiB   access 0      age 3 m 0.400 s  
>                                           |00| size 1.544 GiB   access 0      age 3 m 0.500 s  
>     memory bw estimate: 0 B per second
>     total size: 14.722 GiB
>     record DAMON intervals: sample 5 ms, aggr 100 ms
> 
>     Note that this is my own fork of damo [1].
> 
> To ensure this was not a bug in my damo fork [1], I adding a tracing
> statistic [2] to DAMON to confirm whether this was indeed a DAMON issue.
> 
> TLDR for new tracing statsistic: 'seen' means how many times
> damon_perf_overflow() was called.
> 
> Later, I noticed that about 10 minutes after starting DAMON, the 'seen'
> stopped increasing:
> 
>     I am running 'stress-ng --vm 6 --vm-bytes 6G' during recording this
>     statistic.
> 
>     Start Time: 19:25:42 | End Time: 19:42:18
>     Time Unit: 1 step = 1.81 minutes
> 
>        Seen (Delta)
>             ^
>             |
>       100k  |  *
>       36k   |      *
>       18k   |                      *           *
>       17k   |          *
>       15k   |                  *
>       4k    |                          *
>       453   |                              *
>       106   |              *
>         0   |                                      *
>             +--+---+---+---+---+---+---+---+---+---+---> Step
>                1   2   3   4   5   6   7   8   9   10
> 
>     Note: Zero delta from 19:42:18 (step 10) till 20:00:00 (I close my
>     machine after that).
> 
> My DAMON Perf Config
> ====================
> 
>     K=/sys/kernel/mm/damon/admin/kdamonds/0
>     C=$K/contexts/0
>     P=$C/monitoring_attrs/probes
> 
>     echo 1 > $P/0/preps/nr_preps
>     echo perf_event > $P/0/preps/0/prep_action
>     cat /sys/bus/event_source/devices/ibs_op/type > $P/0/preps/0/type
>     echo 0 > $P/0/preps/0/config
>     echo 0 > $P/0/preps/0/config2
>     echo 0 > $P/0/preps/0/sample_freq
>     echo 100000 > $P/0/preps/0/sample_period
>     echo 1 > $P/0/preps/0/sample_phys_addr
>     echo 0 > $P/0/preps/0/exclude_kernel
>     echo 0 > $P/0/preps/0/exclude_hv
>     echo 1 > $P/0/weight
> 
>     Note that this issue can also reproduce even when
>     'kernel.perf_cpu_time_max_percent=100'.
> 
> My CPU Specification
> ====================
> 
>     CPU(s):                                  12
>     On-line CPU(s) list:                     0-11
>     Vendor ID:                               AuthenticAMD
>     Model name:                              AMD Ryzen 5 5600H with Radeon Graphics
>     CPU family:                              25
>     Model:                                   80
>     Thread(s) per core:                      2
>     Core(s) per socket:                      6
>     Socket(s):                               1
>     Stepping:                                0
>     Microcode version:                       0xa500012
>     Frequency boost:                         enabled
>     CPU(s) scaling MHz:                      48%
>     CPU max MHz:                             4280.9849
>     CPU min MHz:                             412.6250
>     BogoMIPS:                                6587.34
> 
> I am trying to figure out if this is a CPU issue, or if there is an
> issue with this patch.  I would be happy to provide more information.
> 
> [...]
> 
> [1] https://github.com/aethernet65535/damo/tree/probe
> [2] Trace patch diff
> '''
> diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
> index 4dfc9467ea4b..290d3ee2d836 100644
> --- a/include/trace/events/damon.h
> +++ b/include/trace/events/damon.h
> @@ -199,6 +199,23 @@ TRACE_EVENT(damon_aggregated,
>  			__entry->nr_accesses, __entry->age)
>  );
>  
> +TRACE_EVENT(damon_perf_source_stats,
> +
> +	TP_PROTO(unsigned long seen),
> +
> +	TP_ARGS(seen),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, seen)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->seen = seen;
> +	),
> +
> +	TP_printk("seen=%lu", __entry->seen)
> +)
> +
>  #endif /* _TRACE_DAMON_H */
>  
>  /* This part must be outside protection */
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index bae4569f0ab3..73988ce82b1a 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -4927,6 +4927,8 @@ static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
>  	if (damon_drains_ring_perf(ctx))
>  		__kdamond_drain_ring(ctx, tbl, ctx->perf_rings,
>  				&ctx->perf_pending);
> +
> +	trace_damon_perf_source_stats(damon_get_perf_seen());
>  }
>  
>  /*
> diff --git a/mm/damon/perf_source.c b/mm/damon/perf_source.c
> index 4baa8aebcfa8..e8365dbe1744 100644
> --- a/mm/damon/perf_source.c
> +++ b/mm/damon/perf_source.c
> @@ -27,6 +27,8 @@ struct damon_perf_probe_state {
>  	struct perf_event *single_event;
>  };
>  
> +static DEFINE_PER_CPU(unsigned long, damon_perf_seen);
> +
>  static void damon_perf_overflow(struct perf_event *perf_event,
>  				struct perf_sample_data *data,
>  				struct pt_regs *regs)
> @@ -40,6 +42,8 @@ static void damon_perf_overflow(struct perf_event *perf_event,
>  		.cpu = smp_processor_id(),
>  	};
>  
> +	this_cpu_inc(damon_perf_seen);
> +
>  	/*
>  	 * Teardown NULLs event->ctx (with a release barrier) before releasing
>  	 * the per-CPU perf events, so an in-flight overflow racing the
> @@ -84,6 +88,16 @@ static void damon_perf_overflow(struct perf_event *perf_event,
>  	damon_report_access(&report);
>  }
>  
> +unsigned long damon_get_perf_seen(void)
> +{
> +	unsigned long sum = 0;
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		sum += per_cpu(damon_perf_seen, cpu);
> +	return sum;
> +}
> +
>  static enum cpuhp_state damon_perf_cpuhp_state;
>  
>  /*
> diff --git a/mm/damon/perf_source.h b/mm/damon/perf_source.h
> index 12ca61be7243..49beca6e3189 100644
> --- a/mm/damon/perf_source.h
> +++ b/mm/damon/perf_source.h
> @@ -50,6 +50,7 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
>  			   struct damon_perf_probe_event *event);
>  void damon_perf_probe_teardown(struct damon_ctx *ctx,
>  			       struct damon_perf_probe_event *event);
> +unsigned long damon_get_perf_seen(void);
>  
>  #endif /* CONFIG_DAMON_PERF_SOURCE */
>  #endif /* _DAMON_PERF_SOURCE_H */
> '''

I found that if I enable the kernel NMI watchdog, this issue can be
fixed.  So I think this is not issue of this patch.  What do you think?

[...]

Best regards,
Rui Yan

