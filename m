Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274E8606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 12:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=pWCrJsIR
Received: by kanga.kvack.org (Postfix)
	id 473F56B05B1; Fri, 20 Nov 2026 07:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BF56B05B2; Fri, 20 Nov 2026 07:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3887A6B05BC; Fri, 20 Nov 2026 07:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3B46B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 07:08:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABD28A0F04
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:08:07 +0000 (UTC)
X-FDA: 85455374214.30.16CB974
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf31.hostedemail.com (Postfix) with ESMTP id 65D632000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:08:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=pWCrJsIR;
	spf=pass (imf31.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795176486;
	b=JHXqN7KJ1XKvR/JNuZHLSST1VS7vSJlfSSSoSgNlRSzYt63P1IuK9dGYP7J69KK9BwZdM1
	F/L3pWmA6PPYg+vnQ/+mb/9+9ZPol0nVUDy8O7QBtfANUe01Xxqf+A8McwjlqNqXD+T+V3
	Vb6NC4S3IMa1TlLWRuMiQA0Gznn7eVU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795176486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leH4vKCDxg4Q4mbVrfWpHJbzOjqXkPLFQadbncRScqc=;
	b=rhK+/zvUXwufyJV86eyAoHKxDcc/i/AUPKsfKCGjf8lGghtZPfMqhrrimWHWagqfRjLDiX
	DzfqZraRVpSGmJmzIG5dcNgec8VCCFQcsxBaqkP/oHJgWDhcnjsah0dWY2xEmCJ4UAsnIo
	fnBnYsUrK0/CzIz4HvwVx4HVk/jbR6g=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=pWCrJsIR;
	spf=pass (imf31.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=leH4vKCDxg4Q4mbVrfWpHJbzOjqXkPLFQadbncRScqc=; b=pWCrJsIRg/rUdUJopFL+uSchfV
	nugUPTlQygkizPNxLXYFxjlmGwnLzbHKSFC/47HVx4xP77V6KMmxZxOccb3ZwpdAnS0LZQPL9mB7s
	+E1YR+Y/Q5vC9GG4cjhqsa2g2w7a518WjpaxGZsfqph2/q7PYpgpesYG7Z0Pa8y/bwboPbGHvSC6v
	UWRG+A9jH9xbs+dmi75BE/glBjXgPTUVCdN7PFBUB979TQ9iE5UpRdvufdvxDyZp2szsSmIX5mRpS
	DEizgSnjvu6AWq293mFWR0AMSk5zGBAQG3RhUTPyUjcuyhh3uBHC7j927LyvBrjS6fn9SawVAyDnf
	HvnsRXfg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUNPK-00000000jzH-255A;
	Fri, 20 Nov 2026 12:07:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C8379301185; Fri, 20 Nov 2026 13:07:56 +0100 (CET)
Date: Fri, 20 Nov 2026 13:07:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
	Ingo Molnar <mingo@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Chris Mason <mason@kernel.org>, Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] fork: clear p->mm when copy_process() fails
Message-ID: <20261120120756.GS2668564@noisy.programming.kicks-ass.net>
References: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-mm_failed_fork-v1-1-b3019f43d197@kernel.org>
X-Stat-Signature: rkhau4ioy7yhnf4pxxiibwy1ykp91kcg
X-Rspam-User:
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65D632000C
X-HE-Tag: 1795176485-638213
X-HE-Meta: U2FsdGVkX18IlZsN/gWlJBsFc2oRUImRvCq1NJAGgaRUFZi8EEi80Ylps6VylswNXOpcxCBDEYfcg+C8TOI5jHB7tkzw+gNpEHvu8nhA/38DpnhkebrQXS5mq/h+9ML18u564YbLn9w9p/CcLJKypeavnGZVPKX6navazFZSQAoeUNcl52LR/13X/DsJLYqJdXa2uI9VjaLQcB8hQvJnMt55sIQyF1egK3+auD0t3/juz7N5l0lc+MU7Q9EI7idktR/4XPu8he42bKOuKVGRH/ho/CdD7huI0Aq/CkSnLaEYpcsZObSE0cuPT6qstmFIGOmFpO9hhd4NDf8vP/i/1l9yBLxyEa9oiTgN5fWHSMWFgqoLhkFzNdRuTJ/BLUwRE0i54WXnqyOQTTs17hUCJnfoZDDoKKIXCpSFg/YiZ68zpk2mN9+OIj4z64RK09XxPleTJT/SYlKa95sMzWj+gD1AgrssOJgI3L2Xl6k8eT3yBlxCx4IxoIENDCH0bBZifSA3ORFX11y+ZRgEjaIqiVcnizXmlQTYf5bLdrVjtRtW+eoGoPyLtCmAQQby/Qeb4KMsAHRYv8EzY63NOpdpdDha10kbqfi3W1GqExYsYY8dET/cVQVVOCjZ88AmimAPbG9Qq62VRhsZYLT3l2iBGfhfy8bXpwowtavKCEDqqUNFCifPJyw/SQCFGA7AnvCQUV4zSYYK0NCF9AQPNp4NQw/FtEg4EuOe6sF/vt3mkEyS3xboMt+Knj/I97hgQRB2hNwAWRLRxCOlSbV36xFTYZsrJ6EYAUyVPO5zDAv+voCh6chc5JTTikU3wD7CLsZTwb84fEt/xkbW8tuMvmAHsjJUpwyAbT52ASO3UhsACv0BfiPl+y2VKyOwPb2wuHda47g04e2K1Rhkrrj1PbnJu5n4elJiG12IwmnHpB4mYao1loTg6bRCvS2aM6bpMkqOObmK4oXs8Gg3n26qiSK
 Jhj9Jkxj
 CxI1h829DYPhdGB35kAxk+zpXbtmX0N36rH6U9NA/HJklZBlrs8L/JiYCsUbci+zZftMJok8B5l8dvUftlwcq8LhKFXEBShVdJuTnQCZj8l9r41EpkeISJb853/tOb7JY9FMCjAhCfOlaVU7r3N33wN/JkfEjdMSgJ3HJqcBGoqh1kjRamS9xRBVBfGS1L/iD80UDeJVaEWS/KHkbZeHGmF46RgECd9Zhd2aVjUtdVXUPLZv2psxtnqRHPVDxueYPQmp2DKlsE0Cg+qUtbEyPUM3lMQPUJq8zFi0Pm+gy9QZMN3c61jfzf1anhnKVl8sfUCjcWZDyjfCHpbkGUjQPXRSFVQzOizwlZ8q7dCPwsJ/6Kp4nrhmgAEJLtVQa+J+1Zrc1upA/O1lDfg1J1iaDnd03H+xSGqYMlGpCgcdTNZpgcFXWPtL/t3jRMk1chDQmbr1NcMh+MXqEyDewfF1wAkL9DsovV0yf8Ks4PbLc+HdhG6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 09:04:58AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> When copy_process() fails after copy_mm(), the error path drops the mm
> reference but leaves p->mm set. Perf and BPF can still reach the
> task, and take a reference on the already freed mm through get_task_mm()
> or bpf_find_vma(), resulting in a use-after-free:
> 
>     copy_process()               PERF_EVENT_IOC_SET_FILTER
>     ==============               =========================
>     perf_event_init_task(p)
>     copy_mm(p)
>     a later step fails
>     mmput(p->mm)
>       /* frees the mm */
>                                  perf_event_addr_filters_apply()
>                                    get_task_mm(p)
>                                      /* use-after-free */
> 
> Similarly, a BPF program on the task_free LSM hook can call bpf_find_vma(p)
> before the task is freed.
> 
> Fix it by clearing p->mm under task_lock() before dropping the reference,
> just like exit_mm() does.
> 
> Further, if copy_process() fails before copy_mm(), p->mm is still the
> parent's mm pointer copied by dup_task_struct(), without having taken a
> reference. While nobody can access it concurrently, there is the
> chance that it might get accessed later when a BPF program is attached
> to free_task().
> 
> With CONFIG_MEMCG the task is freed after an RCU grace period, so the
> parent might already be gone and p->mm in the child points at something
> that was already freed. So let's just clear p->mm before freeing the
> task. No lock is required as there cannot be concurrent access (and we
> might not even have the lock initialized yet).
> 
> This has medium urgency.
> 
> Fixes: 375637bc5249 ("perf/core: Introduce address range filtering")
> Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-180866@kernel.org/
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description and comments ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> I can take this through my tree (rather soonish) unless someone else
> wants to pick this up.

Have at.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

