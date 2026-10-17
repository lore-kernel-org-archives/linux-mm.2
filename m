Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7A4CCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 07:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780BA6B0088; Sat, 17 Oct 2026 03:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731D66B008A; Sat, 17 Oct 2026 03:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620416B008C; Sat, 17 Oct 2026 03:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB696B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:12:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9661EA6C88
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:12:49 +0000 (UTC)
X-FDA: 85331250858.30.4E01B5D
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id C19EC40008
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:12:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gvK54lRG;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792221167;
	b=zjGm1zOYm5XSvgJ21XAoK+WoPk8OvRAQYTE7TGx71KT2i0UlGxa2RqlKv8SCY2Z7Gk6qlq
	Zjzc1WJsUzKgQ8B3f2gLH7/14XE+owoAgws3lmM0u2fPfjhx0Q6tgL07zeGoVBSmVhEe4y
	xh8ngfkzoaP2f4F+Aw9SedyrrwWEB2o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gvK54lRG;
	spf=pass (imf04.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792221167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJH8UNyjh46J8FjQdq/QYU7fitJ1+CWgYhgsIWlIMTo=;
	b=Lm5SpIbNCwNROeUvF9cMjSCcSq/3soyB5fCDTfCTGQXvFpfxcpTmb7GfZWiPd7CW0suIi7
	z3xLxUmXtTG5XUmaIAs7jtNH/TxeB6vLp6FweziYWrBzDekRS8T7T+mpKNx6e0tM8SDhv7
	T0Q+bSyB8asRDRLEkMtIEoL+hHwpuJU=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso440733a91.0
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792221167; x=1792825967; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cJH8UNyjh46J8FjQdq/QYU7fitJ1+CWgYhgsIWlIMTo=;
        b=gvK54lRGe1MaSJOBPR9A7alu9zqkvn3dXI222C4zp0kG8VhU62+JzWrrT2rJoNx29F
         T2PnXBYvs2WDYHvqz4sUQ4JfzMLWFnfHQZTIRARcKF43hDRfW3tjMWhEh28f3zvsAhyq
         9/NAhOUApWo31YCpNToMcKhJOmhySVEKTtai2Inblb8kuAaZDhJc+MycM/whyB5H5NbM
         ckOWnJ4CNltufZPzaZfpmW2jMOea3BmLAD2cWBAiAiiMHeTIgi9DUBILSEEdZeIH7/om
         CsroypTbdRs79Dp7dkN5/iz3yxKdUzEkmt/As1qEC8NQE4oSp2kzqXTDlVR8vfYz/WSW
         qYVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792221167; x=1792825967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cJH8UNyjh46J8FjQdq/QYU7fitJ1+CWgYhgsIWlIMTo=;
        b=YAMEHWn7oy5dy8rhEklOw/twRNzkp4EBP357QJHNVHEJBRWNB5DVDR+TblfqjCrDK2
         w3qzifb4srRPLNi27CpT+96AbUb0lSq8lC6shdhmfHBiAyQLQDkcvKKi9I8l9L1OpKO/
         wRO1JfsS26twVTTY8I5wQPpTG9fNk50fcS76LSMnM1Tv41/9eVpt0BQhmj+sm3qiamVt
         gJxO0sPlXmtgcgV+8Zsk85QX+H3zTDB9h/N/AN5Sv4Gryp0IZmWhCu3AgT1GUPh6ON4O
         nKZ57IjeFnyc+mAlP/EVk+J14K77r69VnUzxl19WwiLW6jIyfmzrnp7sPS1PGqTDqscc
         qlyw==
X-Forwarded-Encrypted: i=1; AKwUvByQkqUGqxinNnkEJX+sUu7zwF5KG6/+pQt/URAKXAhAmX95pyxmHMDlDutbIL0eEwBeUEVxvUHX2g==@kvack.org
X-Gm-Message-State: AFq9FYLsmx69ZuiEJYH8M/g0CNGNSGO/P4EtPUOKtm1EZtbvteysVlKR
	/TGr45aHUfckucaLaK6jyTQ1zkwMVVjfPc9UqQzCP4x9KbMik2haFmA8
X-Gm-Gg: AYBFou2ytJeOh/wtbOCdd04V0f2kzaoYyQRtRsxv3eqJTt0oBEDt9U28PHjb80gQQ7+
	Hx9Tgbm+bZG5m0yGLWyEr904ROl27JMIc1GY5gB6E8hI3Dgk/WDFy2jXIPCbee6VDWXP05NRLZc
	9z+MCAqtylbuGNhv93S0mvT8aGC+o4IhWkMpfsNM4OQb7sxuc8dJd9b/pSFOX48M/tQZivMVtnB
	r2Jar7VJeMZmInPNOB5SvpxGBEMd+cyCL7eaLQHyeX7QOCjLTgQFhKcJ7C7p36GQZZPjDF14r5T
	Sn3vi6zH4K+l/bfLBqQsDYWUNTqV9XPYZSeIIfEyi5F2KPFSmkydHeoFFtap06lFkBKJcV+1kiH
	2m73h3nkan1CVSNxbU7BF370D2PmmprTrOHgOn0I/lL5l2slqFXRGxxOfCOFL7o/7N4K9wquNbG
	CFUxlDU2YgdQY2Z0rLteOPgUgIKlv2FBtgHiGStR3A6NVYAcb/tcm/DGMP84TJb5Dz1cpMjlfWJ
	LFsgK/fY/lCmupVFETvylVhqQ==
X-Received: by 2002:a17:90b:28c5:b0:3a7:9e3d:b3 with SMTP id 98e67ed59e1d1-3acef667162mr1425497a91.66.1792221166557;
        Sat, 17 Oct 2026 00:12:46 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8954:498:18c1:c1ef:4268:7168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd0aa3c24sm3788644a91.4.2026.10.17.00.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 00:12:46 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
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
Date: Sat, 17 Oct 2026 15:11:18 +0800
Message-ID: <20261017071120.4628-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
References: <20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C19EC40008
X-Stat-Signature: mpirqgymejyftqxyyacgeokxt9dxqk4n
X-Rspam-User: 
X-HE-Tag: 1792221167-395944
X-HE-Meta: U2FsdGVkX19dpdWAcbrTCMf7J8lOqJ0eAQkeplE7I9u9h9nv+2hjdUFLjKVrfTqT09IphQXpRBFKxS66qPkcprlKcV2wZbUoQoXZFrqmWtHKSQADITZtVx+6SnTQcFA1psxCMppbX0DC+qFmEqZ8g0ZLEpnjkB/5+LE1IqIT7icAYODleo1Nk21YOPnTHfcJQ2kn+3a8Z/IDtNNmtJOMKwPX33jEgGARRlqgCD3gXAzxFT0kG9d2lodsgR7wT70FzJP+HrPZtiFrAcKjMEingE3C0yzRgcYVOaLJ4x5fUSv2sgzwOfBfukNm8ZoIKN4fD7B4qanFmCsuGIbEQBcLX9gd2wsIy/ZPMOlaBBXM80Nh/iRELLfqYscq4EQIFv8nO+S1sFL3sdvg8X+SeOD9/ro+JOj1heRU5DycFCVFFgJgP+xnxyU7Bm76TQ2QBOh7P6FSQmeWchyzV8UhQwT2CLrowiojXSoBRKZTk15HLILnrTd+sBlOWyOOW+UXw0LoZnSlRT8u//mtLIkkgw7YqZIfP5+cC1PG/30WNuE/UGawfvGsb2m7Pyr+Ht2lhzERUb4numvtXZJWunRHn6e2EaBear9AgTatYYOwclourQa5rvHLakykiKiTYQ1MlufIZX0To9s+tmPO5K4m57bqLEO7rfgORePLCpIdWiDzWkRJBmsJSfTmfapoNLAaqMgty2ZdXFWmuu2syvSvtik4qPsU/aXqUhKseVJj+7TKPMjfx7TcWsTcBgARi36r+SpceCBfG9B/fLiR4YYMs8KkfWqxtLwkGUhO9WliKTE9kf6QuOc72qDG6x0RP9T8jhGTDtHsmIC6YDcRdCF50YCRGBNKEOqDf3KOSZ9hbaXAU+gmBtngLQYa/pVjCcWHoKWydSb05qxxfXx2QZ7ieBx8ZEXmagdTYqNUzjPKOUorFy/FbTd1l09UE/LbZJropSBhwIhj5FB7+MvZchXWnFE
 3PfHXIuB
 dFhaveSicNzplr7TkUKR6WtLsw/cWQ/6aTQ0ndAQBKj8we2arM/a9BtQHM0kXO0uExi3REMT8Pepxw/ZFceJK853XPnXwuLloB8SEzoOcHPo86ap4+tEI9IBKaojbOVF/nvJilDVZOQYv2AejDqzF68XB5q24ngddDGxp9jrvFPKjT1l6Zf6P5IZsEPK6VSgpB207etzxRc7M9IC286gOk4v8QEwTQmRx/UA7B4dt7RYfDerHf8WgBz7RrFh4snq4vtn4HODUjGgPkVxUesypyzEknqwn6QhB6xQE7Rj9IvvKORlIXnkNEKJAJOwUJNVu5860XQR6iWg5KIcCYnKvoKk01Wu4/JesDMRed5GMqKwyDazNrsy+EMEe7CMirRJFJtuTl5RRywRe0VElJaJSCAkjc4A6OoILKo7J1GNsslJH2AsQtElsjOOnaPErW3lDsIfg9DA4QcB76c96ozTX7NtpEfVr9xyeRg/sKaFYV6UyHmZnOt1HpGuJqHtLJG3K0iKuugNNagxARKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ravi,


TLDR
====

I have noticed that there might have an issue with this patch or my CPU.
I am not sure.  I have provided some details below.

On Mon, 05 Oct 2026 01:46:44 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This series lets DAMON monitor a hardware-sampled data attribute -- the
> addresses a PMU saw accessed -- through the data attributes monitoring
> (probe) interface, and run DAMOS schemes on it in data attributes-only
> mode.  Patches 3, 5, and 6 are co-developed with Akinobu Mita, building
> on his earlier perf-event proposal [3].
> 

I expected it to monitor regions in the same way as PTE sampling, that
is, if the system has hot memory, DAMON should be able to detect it, or
at least with some probability.  However, it is not always work like
that.  After I starting DAMON about 10 minutes, the DAMON cannot found
any hot page, even when I am running 'stress-ng --vm 6 --vm-bytes 6G':

    snapshot time: [0 ns, 100 ms] (100 ms)
    |0000000000000000000000000000000000000000| size 1.461 GiB   access 0      age 3 m 3.200 s  
                                   |000000000| size 1.465 GiB   access 0      age 3 m 1 s      
                                          |00| size 2.922 GiB   access 0      age 3 m 0.500 s  
                         |0000000000000000000| size 1.471 GiB   access 0      age 3 m 1.700 s  
                    |000000000000000000000000| size 1.462 GiB   access 0      age 3 m 2.100 s  
                                          |00| size 1.470 GiB   access 0      age 3 m 0.500 s  
                                           |0| size 2.926 GiB   access 0      age 3 m 0.400 s  
                                          |00| size 1.544 GiB   access 0      age 3 m 0.500 s  
    memory bw estimate: 0 B per second
    total size: 14.722 GiB
    record DAMON intervals: sample 5 ms, aggr 100 ms

    Note that this is my own fork of damo [1].

To ensure this was not a bug in my damo fork [1], I adding a tracing
statistic [2] to DAMON to confirm whether this was indeed a DAMON issue.

TLDR for new tracing statsistic: 'seen' means how many times
damon_perf_overflow() was called.

Later, I noticed that about 10 minutes after starting DAMON, the 'seen'
stopped increasing:

    I am running 'stress-ng --vm 6 --vm-bytes 6G' during recording this
    statistic.

    Start Time: 19:25:42 | End Time: 19:42:18
    Time Unit: 1 step = 1.81 minutes

       Seen (Delta)
            ^
            |
      100k  |  *
      36k   |      *
      18k   |                      *           *
      17k   |          *
      15k   |                  *
      4k    |                          *
      453   |                              *
      106   |              *
        0   |                                      *
            +--+---+---+---+---+---+---+---+---+---+---> Step
               1   2   3   4   5   6   7   8   9   10

    Note: Zero delta from 19:42:18 (step 10) till 20:00:00 (I close my
    machine after that).

My DAMON Perf Config
====================

    K=/sys/kernel/mm/damon/admin/kdamonds/0
    C=$K/contexts/0
    P=$C/monitoring_attrs/probes

    echo 1 > $P/0/preps/nr_preps
    echo perf_event > $P/0/preps/0/prep_action
    cat /sys/bus/event_source/devices/ibs_op/type > $P/0/preps/0/type
    echo 0 > $P/0/preps/0/config
    echo 0 > $P/0/preps/0/config2
    echo 0 > $P/0/preps/0/sample_freq
    echo 100000 > $P/0/preps/0/sample_period
    echo 1 > $P/0/preps/0/sample_phys_addr
    echo 0 > $P/0/preps/0/exclude_kernel
    echo 0 > $P/0/preps/0/exclude_hv
    echo 1 > $P/0/weight

    Note that this issue can also reproduce even when
    'kernel.perf_cpu_time_max_percent=100'.

My CPU Specification
====================

    CPU(s):                                  12
    On-line CPU(s) list:                     0-11
    Vendor ID:                               AuthenticAMD
    Model name:                              AMD Ryzen 5 5600H with Radeon Graphics
    CPU family:                              25
    Model:                                   80
    Thread(s) per core:                      2
    Core(s) per socket:                      6
    Socket(s):                               1
    Stepping:                                0
    Microcode version:                       0xa500012
    Frequency boost:                         enabled
    CPU(s) scaling MHz:                      48%
    CPU max MHz:                             4280.9849
    CPU min MHz:                             412.6250
    BogoMIPS:                                6587.34

I am trying to figure out if this is a CPU issue, or if there is an
issue with this patch.  I would be happy to provide more information.

[...]

[1] https://github.com/aethernet65535/damo/tree/probe
[2] Trace patch diff
'''
diff --git a/include/trace/events/damon.h b/include/trace/events/damon.h
index 4dfc9467ea4b..290d3ee2d836 100644
--- a/include/trace/events/damon.h
+++ b/include/trace/events/damon.h
@@ -199,6 +199,23 @@ TRACE_EVENT(damon_aggregated,
 			__entry->nr_accesses, __entry->age)
 );
 
+TRACE_EVENT(damon_perf_source_stats,
+
+	TP_PROTO(unsigned long seen),
+
+	TP_ARGS(seen),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, seen)
+	),
+
+	TP_fast_assign(
+		__entry->seen = seen;
+	),
+
+	TP_printk("seen=%lu", __entry->seen)
+)
+
 #endif /* _TRACE_DAMON_H */
 
 /* This part must be outside protection */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index bae4569f0ab3..73988ce82b1a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -4927,6 +4927,8 @@ static void kdamond_check_reported_accesses(struct damon_ctx *ctx)
 	if (damon_drains_ring_perf(ctx))
 		__kdamond_drain_ring(ctx, tbl, ctx->perf_rings,
 				&ctx->perf_pending);
+
+	trace_damon_perf_source_stats(damon_get_perf_seen());
 }
 
 /*
diff --git a/mm/damon/perf_source.c b/mm/damon/perf_source.c
index 4baa8aebcfa8..e8365dbe1744 100644
--- a/mm/damon/perf_source.c
+++ b/mm/damon/perf_source.c
@@ -27,6 +27,8 @@ struct damon_perf_probe_state {
 	struct perf_event *single_event;
 };
 
+static DEFINE_PER_CPU(unsigned long, damon_perf_seen);
+
 static void damon_perf_overflow(struct perf_event *perf_event,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
@@ -40,6 +42,8 @@ static void damon_perf_overflow(struct perf_event *perf_event,
 		.cpu = smp_processor_id(),
 	};
 
+	this_cpu_inc(damon_perf_seen);
+
 	/*
 	 * Teardown NULLs event->ctx (with a release barrier) before releasing
 	 * the per-CPU perf events, so an in-flight overflow racing the
@@ -84,6 +88,16 @@ static void damon_perf_overflow(struct perf_event *perf_event,
 	damon_report_access(&report);
 }
 
+unsigned long damon_get_perf_seen(void)
+{
+	unsigned long sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		sum += per_cpu(damon_perf_seen, cpu);
+	return sum;
+}
+
 static enum cpuhp_state damon_perf_cpuhp_state;
 
 /*
diff --git a/mm/damon/perf_source.h b/mm/damon/perf_source.h
index 12ca61be7243..49beca6e3189 100644
--- a/mm/damon/perf_source.h
+++ b/mm/damon/perf_source.h
@@ -50,6 +50,7 @@ int damon_perf_probe_setup(struct damon_ctx *ctx,
 			   struct damon_perf_probe_event *event);
 void damon_perf_probe_teardown(struct damon_ctx *ctx,
 			       struct damon_perf_probe_event *event);
+unsigned long damon_get_perf_seen(void);
 
 #endif /* CONFIG_DAMON_PERF_SOURCE */
 #endif /* _DAMON_PERF_SOURCE_H */
'''

Best regards,
Rui Yan

