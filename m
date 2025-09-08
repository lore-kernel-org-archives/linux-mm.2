Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2021CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 05:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408C16B000C; Mon,  8 Sep 2025 01:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFEB6B000E; Mon,  8 Sep 2025 01:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F64E8E0001; Mon,  8 Sep 2025 01:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBDC6B000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:23:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D414FC09A8
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:23:34 +0000 (UTC)
X-FDA: 83864940348.08.AAD3B5F
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id F17581C000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:23:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mjqffgwg;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757309013; a=rsa-sha256;
	cv=none;
	b=5BqyoRYfA3DX0ArHriRIMKQ3sSDstBWt1qx/CU3eWw7WwDMNoHqv6lG+sXkjMjnXUSBCAU
	DhQguCSqHW4CjSUHfmje2SqmLEpuC8CthrmBxPx5v8R157w+7dvYl5mPBrrCsLoIYS6j0F
	0vNRxkaYKSjG2hg76xr/59nkwJ3h04A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mjqffgwg;
	spf=pass (imf18.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757309013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWu2XYOMOTFu9B0WNwW06nL3LV01SW2Lw7noABGOmtw=;
	b=RxxZTlH5JBiOG9cpWmOq4hLItWQLARAS2tteybFPkcGJ5neNAcwgMWZr0uvzjutFGIjlQc
	9s6nMTEwdg/cq+2ZNG4KLWUHjhzW5pDqY+vGhp8XF8PNwm0hW4U+qUCv2tlYgqVtvvoNo5
	Qb153pSWVkW4wIjQAFWxcSCnAwvdi84=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77287fb79d3so3177195b3a.1
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 22:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757309012; x=1757913812; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWu2XYOMOTFu9B0WNwW06nL3LV01SW2Lw7noABGOmtw=;
        b=Mjqffgwg0W0HlMIfYr50/CC21UFf+8n5+Yk6nHq50FeSZXJPDV8y6/3+uT3MMtOTe5
         cNH86CPM9HF6Rub+uS+MYjLapUpzV38qobnFU5G+ZIr09gOtV8feOowuBKNaj1cnSouW
         aNmBomS2u2dFy4W+75PeM3X0tksGsBciNWVhL22383DVidlcFFvLTefHqQSxwOatiZMV
         u26vgjEZywuMhTAfxH4Q7WrYqot0vFE1W+0rWO/dtt7ICAtt0mrDiKqH9vW2T7mUcrQ5
         tg7s2yjl/4CPggr0bHO7abtsZsU6hUUJh1kPiaieZqOTc0zDu4iUH+cfmHV6Kdoq3Gn9
         eP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757309012; x=1757913812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWu2XYOMOTFu9B0WNwW06nL3LV01SW2Lw7noABGOmtw=;
        b=OTA0wOTRxeN4wW5s1Sy+M1MbV1EqMBmDTw7hS7PlQLNvkponcfEu9JGzqTm+0kMBGo
         Rwg39DlO0va968MPppwzuNtjxDWapzgCqJi40b78Ty9pRNWaYWoFho/nF8gpv6XNv+Ml
         jYa6d4nQM6jDJvMwMXPMGk1v9s9YvabRJ/mNHxS1fg2tangsCnl6F/bj0/JZRVE0GzXX
         cJ859aH1Ruv2cMz+QSWsnntwGTzdxeIeR+RzYV9TjdACrVCAWoQdhK9e/OnNz+LNmnLf
         C/RgL94Z/Zug3IRQbf6XoUcoI1v5WIh19IV+PTnWWoQTncGDcj9RxdmibCyLPqSUss3b
         bgqQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0BWkhQtTTanXuojLFbIH5u4Im+JGKsVki+xKZmGmpwiR7O+HQdpTLGUg7zNUz73Hdd76abFJI2Q==@kvack.org
X-Gm-Message-State: AOJu0Yyq6Hs7f+JzkT0Xds7rOCroh4Clem5r82hkFbwgRWHNHQzjfWHM
	tbZbZCsbHzIA5gtuchhxLj2hJzQoZ2EXLqiXlv3+hHkk86NMwak1NgrZ
X-Gm-Gg: ASbGncteqRNNYHEuEIj0huocg0b/bxbZNp+CCkjDJVFRFL3Al3B5f4ZARfrd1uomn2z
	z/9kfKYw7rGTXCRCFF+rQNs3llwg4Fnx43zrDO8HfKYJiJIYRCSWC9hElRZEhHVq7QXn3tqTCUu
	U2gmbvTfCCQg7As+X2cyJMrJ9qmu9yLTLexU7PzumbYU/5E3Al0n8qNL4/pdwqEpNY/5Vjjoe8B
	qYU32lflhPlBrIH+4P/XRT5CZk51CU1XCoQtLCnYOG8SlEzUIC6KZFpI1qMOm+ywhmexxSVa/b7
	ARJaVjIvpI2hJ0O5O8lk9FOkhz1eLYCImk1TN+wqDwVMq1/YgE3DksgQArZuupUHJDi7cYEraL0
	5+jN8d/qPkDLBYbwqQS6SSv7W0DOU8CZRIenCnQufV0CojP9I
X-Google-Smtp-Source: AGHT+IHhHv4Iu58ATI59YbrWBaYVLbKFXM/ClLr8aEJoJiAWuzKMQN7cVpbbtrr/dTshWaOeTRjAbw==
X-Received: by 2002:a05:6a20:7344:b0:24b:3b75:b059 with SMTP id adf61e73a8af0-25344130942mr10522566637.55.1757309011718;
        Sun, 07 Sep 2025 22:23:31 -0700 (PDT)
Received: from localhost ([103.121.208.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b4f992d3de9sm14051191a12.14.2025.09.07.22.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 22:23:31 -0700 (PDT)
Date: Mon, 8 Sep 2025 13:23:28 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <aL5oUJEWSuRpH5S-@mdev>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-8-wangjinchao600@gmail.com>
 <20250904064659.GV4067720@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904064659.GV4067720@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F17581C000B
X-Stat-Signature: ebhfmazm1muhyo4q36ztsqqetaigr834
X-Rspam-User: 
X-HE-Tag: 1757309012-757066
X-HE-Meta: U2FsdGVkX18A+pYQCiYpiqH8wjmlr/SIqokLKNP4vYXlQ/oWIoO0hVTA70Dd8hHJqIpqwp9WseOzrEIMVPzyeNv9X/B778ShXk+4RLvzOKhdIDDOYHqzW1+GBKIxqc/MSSnpNro71Z75xhl+lpCWZzgxIxu6NudJfrp3ltrssFZ5fNkxBLFRa94TF7Tdzk9+XurR4KTDhYswlxCcczrppOo8yAu2GPBVQUINWLh95kOe7Ra+ytry70srkjqHCQcqj65EEhYXclJDjZSmcSZdfZwEnrQ5VBinZ7EZtccNfd9IPPeJYHM/fp6MqBlz+MGxEdQdE2O1DOSvCmLOFFK8/Q4YByJOxKGTpy2VYIYb2XCJA0p+o9RoPKaEg5BMfvyVS4qlRdT7aNvQQZ3L7v2ZN2vfbmSUbiazjiWc+k3fvNth4h86AB7IG9LopUlkYT12tXgH0GsIfo+Gyj9qHW1bM1fhOrAdzH8g7Sd8+muPLxo2J32kruANZWSAclUWgjmti6kXrqfuRcXLkMN8h5jcCHB7Dd0qUPQ9nQ8+70Z9HsT0NTH7oiwzuxlAw+6lBInwCgGuxSGMM9gpXy04mNP0cal5L9uLY/OnZX0JdINk/xwD10ZpTcPkyT/ykNkB9y8vFsduaQEHcpZAeUFrLxeRTi70TpAsiIPoPNmuAwHoQKgLleIo4US75XBQ9Sila9WI5S/l5ysHNICe+uHqV79zaTWKisohlFzux4qAZHTkHhYfQkT+lRyzlpXYRXrKZWYizPFV/aVhtvbJUmAOQ/mkYYKpqgppobVHfdZ4ZDeWPfiNDkDDO49lQeeip+1N0ZV8XdEmpuNx9BU6MR8m+PJXHapjRTJn+1PseNcu2ATXJZ+/CNOL2WjwkMetYILxXqo1BXGnMK29UceO5vHZh2FNcDyan3kilqhEk0azVOjVqOL+4sJv4yCmG5qn2KND8J/7VkfKWZzaILnYvBgYx4i
 USGCYX/m
 D3lAIptLis0r+VLSybzXfUCHcNn+5/kEbig0adWxGU18MliZwnul74g7fXlyw4VCqVcPP4azwn/9kq2I9tEb6aiE1dSLCo6gkxsJnWl2BSFo/kUyZEvb+15etnp6WJpnXjoGxDDV/skTuzHuXFX1dH2hGTxHk37aRM4c8ks6hWAQrhAT+Si50TUXd4/0dQvtOcTjBc1rzc3LNa6bE2AYlFrLgNsqrtHWyQ/Opxs7+4p565+XJ50qTq2nQBfiTkMns4bExNheBkrJZoQaN2RZ4qTsY6zWEQMrG3v7Ik8D8btm9Q4c8F69ILgDVJkJ/EF+iLVoaNHsMaueNg4cYB2igKkD90o3trKZJtVzb0skj0YpkmUwpvg3nFM6ktol4TkeXdP+9mN9WUs12bU4k3dH27zgkMk6PmXto/KPMbFzGYt40ZfiC8UJwinNLXAAKp6dY6SsOa9+z9nYR43C6/ySL9gJJaMM6qxL9K2mk8XgkkM6tlgRxSX/OACVwG8nS9yp2uOd5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:46:59AM +0200, Peter Zijlstra wrote:
> On Thu, Sep 04, 2025 at 08:21:04AM +0800, Jinchao Wang wrote:
> 
> > +static DEFINE_PER_CPU(call_single_data_t,
> > +		      watch_csd) = CSD_INIT(ksw_watch_on_local_cpu,
> > +					    &watch_info);
> > +
> 
> > +int ksw_watch_on(u64 watch_addr, u64 watch_len)
> > +{
> > +	unsigned long flags;
> > +	int cpu;
> > +
> > +	if (!watch_addr) {
> > +		pr_err("KSW: watch with invalid address\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	spin_lock_irqsave(&watch_lock, flags);
> > +
> > +	/*
> > +	 * check if already watched
> > +	 */
> > +	if (watch_info.addr != 0 && // not uninit
> > +	    watch_info.addr != (unsigned long)&watch_holder && // installed
> > +	    watch_addr != (unsigned long)&watch_holder) { //not restore
> > +		spin_unlock_irqrestore(&watch_lock, flags);
> > +		return -EBUSY;
> > +	}
> > +
> > +	watch_info.addr = watch_addr;
> > +	watch_info.len = watch_len;
> > +
> > +	spin_unlock_irqrestore(&watch_lock, flags);
> > +
> > +	if (watch_addr == (unsigned long)&watch_holder)
> > +		pr_debug("KSW: watch off starting\n");
> > +	else
> > +		pr_debug("KSW: watch on starting\n");
> > +
> > +	for_each_online_cpu(cpu) {
> > +		if (cpu == raw_smp_processor_id()) {
> > +			ksw_watch_on_local_cpu(&watch_info);
> > +		} else {
> > +			call_single_data_t *csd = &per_cpu(watch_csd, cpu);
> > +
> > +			smp_call_function_single_async(cpu, csd);
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> 
> What do you think happens when two ksw_watch_on() instances run
> concurrently?
> 
> What happens if a CPU comes online/offline concurrently with
> ksw_watch_on()?
Thanks for pointing that out. I did not think much about it.
I will think more and address it in the next series.

