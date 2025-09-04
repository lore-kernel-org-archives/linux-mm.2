Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6369DCA1017
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0F48E0012; Thu,  4 Sep 2025 02:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87108E0002; Thu,  4 Sep 2025 02:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CE48E0012; Thu,  4 Sep 2025 02:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97D578E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:47:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42A0C11ACE9
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:47:07 +0000 (UTC)
X-FDA: 83850635694.12.B4DF85E
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9010BC000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:47:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=WzA82SHo
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756968425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efyhR8wHhw8uesblYSnLgPQBPUNCW7rCVpcxJ83V5M0=;
	b=QCTfblU+i0gAa1Ix4B02lMc0PdpmL2cI+l99YY0NWmjhjbse2t0nrrtw6390XJjcvigmMR
	1OJSPMMswCfHQNKR2zb63fSO/Xt0zUa8WqvNmyUY+8m88UKMVbkT6KTDzVDF+xxYuVGDt8
	1ueJkaGuWMDk8okbx42MYHPul4b9E/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756968425; a=rsa-sha256;
	cv=none;
	b=arx3uMrfuACQ16/SDMWboj0b1PxQOfwGPkuAPZF5TMJNUOLD5CDJ3Hxxxmqs6LFzAI8L6s
	zgAQPYd55Ts1JGjJBUPxqHM7333mOhRRfL64ur1VIn/2RTsyK7oRbt1lFHGT2C/NI0E9Cu
	0VPjSFCMHNg43x3lko/sxSifnhZCf0I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=WzA82SHo;
	spf=none (imf22.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=efyhR8wHhw8uesblYSnLgPQBPUNCW7rCVpcxJ83V5M0=; b=WzA82SHoMRi9yVKB7fE7LAuc1c
	jsspskezLL1ajqArYYKzI6cX4WAwNcIkBBMtuGNUrV7io6kKfesya8FJMYYysXDzhT5ImjOLY6LFV
	248MTKZQHUNmlfu2GDFS/rdAZg0ZwzLMpkBnhkCCu548qhVx0yqSkFrCciRhTe05ZA4D36cQAIgAF
	uSGincVkuMSsYe6AEzciEecgQynn8iCwaWTJrIk4o8qLMnj04bDec49lcxdEb4sUGgOY8xHaRUya2
	SrO/LvCDU13jdZ3xoZf3iSRb8Uw1HdzRWYccGJKRwrny/suwG+mF2+B1WfIwU77Mz+0C+q3L0/MR+
	dw+7hO0w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uu3kK-00000004IX4-0HP9;
	Thu, 04 Sep 2025 06:47:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 91B3F3002BF; Thu, 04 Sep 2025 08:46:59 +0200 (CEST)
Date: Thu, 4 Sep 2025 08:46:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/18] mm/ksw: add atomic watch on/off operations
Message-ID: <20250904064659.GV4067720@noisy.programming.kicks-ass.net>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-8-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-8-wangjinchao600@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9010BC000B
X-Stat-Signature: fsxku78ha44qjo8pxuumrqztsaq31njz
X-Rspam-User: 
X-HE-Tag: 1756968425-10770
X-HE-Meta: U2FsdGVkX18gBv4UbZVFSr7yD9DxlLPD2KzIdmYxRkSCxsBGMy1mXis+/AeW/kKhiur1qOZFnmwCD5FNrakWSPmVQ7wz6hqQZ46OFA2PI0KAt27QEOG0iy0yJGf7gSoqSXZ2XrHADpfRcEZSR2YvfdasEDpKRG02HDIO1yyOM1zlQb4XoALT8Q92dgM8JCxxxN+VlZCZDUbE7G91CDWp8xp/RBI292bePJVF9Mf+CapRe05DuDDQu06qV2PAkFhkZQI8GNTXgP3P0RmfvsmiWSFLkfGTT3uddo4CmXibzro2MlXXVAPTtLbPjuWI53muA/k47+C4gPvkVV8GIUwYCFf8z17RFeik4w1QvyHhoayLsK4lFZHz4irIPfBu0CON5KFqVJlYKwlYrd9A5IJXAcduZNOPpvQRB76CsINlvaeizdIOy4hdZ/tlKFuKsaJ8scv/qyMVkCT3IxFq3M7J9Hp9brsm9NVLFFyyzUPbW1kcknvOcZ6ThE3TN41BmeKz23i8HJKfQsTdAUzREGwZR1uiHXzr1M+cLv5Dn+Rr7ekOzJvgBnn2NfVOlZnCKRLbwncsxEy/2NNitu13+5LD7ZzleG7bLnsMu72a4Pdga7rw9C0/cCzmWkUyXjVPB6bfLN0QrWz1tm4FnziYByf3sx8/NFcx7UFgYT1M/s9VduZOWuU23u7eVDGYdCfydh9s/zRPfv2NJLMMj+VsMENQORDlSJPYDKfsKICvosD4e5ZK+pHpblFnsY/2X6lxG6pPFl2V+rFxY2pPqe+1uIW9WYdmNakZ9Vt7KNpCFko2k02baSPqZknKKivFfP8kKAaEcVHwbNxnndRIPTM+vgyzVg5FKGEQ5JddMxuBlzxxP0DpReX+nNUBdqlOjL+dHArOZONX1vDNZVQkf/GoVu4NncSQYwpZCWZEpHTDly5Y5Z8MdD4m+wnEQRRbfSs+NFTHJ/P+H/fPtJwbFtDSTJN
 uman4xOK
 3gdnAW+mvHv8RWudiOAqqtKcqkIiLvTMJQT7XcgUnm09/40SxbaBFPSSp2CL25vMpuVqoSARfJqcI2xUfpVMvaCDbSPFHi1Hx9pVYDoNz2aYjgtJ5S0pjGN4v9pkmDSPsdiCVhIaXnEne3ao=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:21:04AM +0800, Jinchao Wang wrote:

> +static DEFINE_PER_CPU(call_single_data_t,
> +		      watch_csd) = CSD_INIT(ksw_watch_on_local_cpu,
> +					    &watch_info);
> +

> +int ksw_watch_on(u64 watch_addr, u64 watch_len)
> +{
> +	unsigned long flags;
> +	int cpu;
> +
> +	if (!watch_addr) {
> +		pr_err("KSW: watch with invalid address\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_irqsave(&watch_lock, flags);
> +
> +	/*
> +	 * check if already watched
> +	 */
> +	if (watch_info.addr != 0 && // not uninit
> +	    watch_info.addr != (unsigned long)&watch_holder && // installed
> +	    watch_addr != (unsigned long)&watch_holder) { //not restore
> +		spin_unlock_irqrestore(&watch_lock, flags);
> +		return -EBUSY;
> +	}
> +
> +	watch_info.addr = watch_addr;
> +	watch_info.len = watch_len;
> +
> +	spin_unlock_irqrestore(&watch_lock, flags);
> +
> +	if (watch_addr == (unsigned long)&watch_holder)
> +		pr_debug("KSW: watch off starting\n");
> +	else
> +		pr_debug("KSW: watch on starting\n");
> +
> +	for_each_online_cpu(cpu) {
> +		if (cpu == raw_smp_processor_id()) {
> +			ksw_watch_on_local_cpu(&watch_info);
> +		} else {
> +			call_single_data_t *csd = &per_cpu(watch_csd, cpu);
> +
> +			smp_call_function_single_async(cpu, csd);
> +		}
> +	}
> +
> +	return 0;
> +}

What do you think happens when two ksw_watch_on() instances run
concurrently?

What happens if a CPU comes online/offline concurrently with
ksw_watch_on()?

