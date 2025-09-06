Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1E6CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 11:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF338E0002; Sat,  6 Sep 2025 07:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DB08E0001; Sat,  6 Sep 2025 07:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D288E0002; Sat,  6 Sep 2025 07:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B72B8E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 07:14:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A46058677
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:14:13 +0000 (UTC)
X-FDA: 83858566386.17.C02E284
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 222211C0006
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 11:14:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=haFRKDNz;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757157251; a=rsa-sha256;
	cv=none;
	b=cWFpi+qYsgU0utZ5NUvs0q364JEJ67LOrbKRF1OGl04y/EelJKbUX4RGC87XE5IQzudzV5
	WSPqfwcNMpiE1YJKDmeRnYTSc7saZaQCXHjLaKRzPU8rogXqZEoN95K76BC4VI15xj1r2W
	xN3nnCtaIKoTkWzROKwoZaW1p4jnrHE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=haFRKDNz;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757157251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WK+GAzkyID6tHGg5RxAC2Li9CcM3O7oCVmbbRYNKra8=;
	b=k3Rk+TpYQpPpwPoOKF7Zyu9KzTJwcRwohpQkEqk0bjRhAfQgNJyPbtO0K2ITJSaefgQDIh
	8vC2ELDsCuHtQbrVNenbt4V1YjPBp4Wl+j7aEwZpCmwOd9v7tUvAyyPSYYukd4ypt6J/pt
	I9Viu+lPRsa3GqmZSTPG2upnwCabfy0=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45dde0c8254so3904195e9.3
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 04:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757157249; x=1757762049; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WK+GAzkyID6tHGg5RxAC2Li9CcM3O7oCVmbbRYNKra8=;
        b=haFRKDNzw3lS7kmZqhXXEtWBADilAGfV9Ntx0RKsSMVcZBMyJnTi5QJiJ3StSgkzrX
         RxHiwakLu5JWcYYo4ZY80Ng0D0c+HU59v4dj0Dl1YhfGyq+z9SKFisiJMfsnvxUPFZ9c
         24pkEQ5w6+9sY9hC9IjpI39pYyXWGiC5/GXjPZZnY+Mz8n708chmCyjQECN2NLvn3wgP
         YsmgAOPDAH1TF74A+DTuRAAF4xgvQ0xmfF3H+GbPVfZDlc0UI74nr5dKaZMTdeTIQP4V
         9VGgfkCUeo7ceGvUYjf6UyMowplW15m67WeHddYaFysKFdv439P5wcj5fAvzXYKGgw58
         GrlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757157249; x=1757762049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WK+GAzkyID6tHGg5RxAC2Li9CcM3O7oCVmbbRYNKra8=;
        b=VwT0ww0KFMwtrZusjwohKHvngMwVrbQKNdIdlPNwe9MR033SxGfHjTqGRH/OzRJABd
         AVvDmH+RZ6sPb3Nom19PjcMQAxctGlNuKHq2DVe6D8BZQ9DCDX6OJoNABGITY7vdQqRy
         QkAq0KzOz193DoziknYayFR5D+CZS6QoBWKk2OMJnvxqFAbSTT6DNkIoHZsTNUhgvCT/
         lCHcWj/YBD7s1gyqYRH2LYFF/hnRf90VgJh0PdpKHtNBhDxKTDAR/K7ALfw9SyWK7E6F
         MjF0oIgagah+GlU5fIcAjJVmuQtigS1d6MWn9erOS0x7PZ+MNAF+R1rDePSG/jNmaHby
         QbWw==
X-Forwarded-Encrypted: i=1; AJvYcCU1Lp8LgFxEhvBNMg6YKA9sd0xBnO5Llq1dRRhgwOlytFpvVzI+TAjseDHnonkIO2QJLkjRSumyNA==@kvack.org
X-Gm-Message-State: AOJu0Yz/pwGyWOVAeTYK/6/PoeMqMksXGRVYjDzpEFq+fN+h9YI+GTBE
	TqwIK7VHret27zAVCXtB2+Nbif+CB3qaLkN2a2WxJdvtEy7jQKUVdfLb
X-Gm-Gg: ASbGncscxHniMns8QbhwaBSsUbNGKSG+7AafCiAhT1Y37vmAZkr5CzcrNcFmIbMbPvY
	t+NWvGMADoigMS2fuABmqgm3kJajG8H68f83kqZW71IjvcMPU/BnScC0VarmRhtPmyqUVEVgWxM
	Tze/KuIHzy2y2DZq9HGM+8m+B2WgjJgLbuDlkpUIV6/X0CciQPcTqnmxNRSInkAaGae36r0FfU0
	u8oyRnuutoA9tZ+jCFLAi/RsDEcjmIvH/osMSBqdjOJo3Aut03G/MkrIi9C1QiAiSmdGsC7pHTh
	VrspVEFjud43rDqyB6bitTB/5VhI4BMAJio+KN6KeW7Vt7f278pmARxhX48LzOVwhXcA2lGtpGn
	yyeTGrbYWEVEhcz+3gopBWXkPFzBsd4lHkHk5YJTG/bkAjxHtAHVVwTrfbl1U43Qx
X-Google-Smtp-Source: AGHT+IFW/5FOxyFqj1+gS4iZbWkrMnNm7SEPeZdXIRSlHu3qHTX/3ekqpxHZW/pRpI0qkbfG1hNoJg==
X-Received: by 2002:a05:600c:4fc9:b0:45b:7aae:7a92 with SMTP id 5b1f17b1804b1-45ddded75e1mr12963215e9.21.1757157249223;
        Sat, 06 Sep 2025 04:14:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm361608935e9.19.2025.09.06.04.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Sep 2025 04:14:08 -0700 (PDT)
Date: Sat, 6 Sep 2025 12:13:46 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Bhupesh Sharma <bhsharma@igalia.com>
Cc: Kees Cook <kees@kernel.org>, Bhupesh <bhupesh@igalia.com>,
 akpm@linux-foundation.org, kernel-dev@igalia.com,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, oliver.sang@intel.com, lkp@intel.com,
 laoar.shao@gmail.com, pmladek@suse.com, rostedt@goodmis.org,
 mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
 alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
 mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
 david@redhat.com, viro@zeniv.linux.org.uk, ebiederm@xmission.com,
 brauner@kernel.org, jack@suse.cz, mingo@redhat.com, juri.lelli@redhat.com,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v8 4/5] treewide: Switch memcpy() users of 'task->comm'
 to a more safer implementation
Message-ID: <20250906121346.3fa6ea16@pumpkin>
In-Reply-To: <d48f66cf-9843-1575-bcf0-5117a5527004@igalia.com>
References: <20250821102152.323367-1-bhupesh@igalia.com>
	<20250821102152.323367-5-bhupesh@igalia.com>
	<202508250656.9D56526@keescook>
	<d48f66cf-9843-1575-bcf0-5117a5527004@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 222211C0006
X-Stat-Signature: ktj9bjmkebmytq9ax7f138r9fr3fzthx
X-Rspam-User: 
X-HE-Tag: 1757157250-106778
X-HE-Meta: U2FsdGVkX18PYw8obgloSVx8ZQEu3oe9w2dat0kQLr4vjrJRSNVbnPc8aSnIPAIYfrqXtNYB9CEK+NLtQBV7IrJVabguQj3HU4lQKshZkSOj6XqOerB3afFEIsyAO8W2HBRsm8Kc0+WSMg07FL5UldZ+Ww7/aWfRztLQFKaqwqcwhyhZ211C6HhyjHYEqgEMzde1zUQOYWvUlzcJPSnWbl2WKE1aJ55Awwn1DePwb2EBq+98LQ1+gsMNuJUJ4Qnf/p5/MnvrER29oxQdazW/ZdGee64Sy4KCHqo/P4S+RXTYmWA4WGTSe6U9Dwwch+o2TNWAeHYw9Q0B3GKAsQPW3C0PdTviwfCfME7uCNMC64An9KESM2m/Cifm6Te30Bd/xpX7aTu+Ez8kT05KqC56f3F/iB7O7T61gO/caBrpB9LUAFHAbutjsDOPWD5wsk0vzA//W4m8l5tzaZfMtA67bfkPY2fE5pphMiBfkJKLA7yMEdWaZWiDGPvtDYEJJVrWznJvhTP0rSkP2NYET/BRMHVR1FxiVoVAOGJyAOo3VSpcAEUH+OouScKp2ltd4eHXdxQYDOanxiEZymLowFGreiW7yhRHgAURnINcdpMMleKhdUVWElA+kj8PoGsgKq8zhkWDzxXoLX7pLb4Fy0stZ4krk4HZI3rI0O6Sf6hUmLDadrMmjs3k6H8XWfY8LcYf2+WoWzcA/NtKcn7LOojh2xPkU3E6F4hgeQBYY/3q+Ye4SE56CQi5XGYqC7gqerpMyLBQAYmz4ccKcDoNqUXKqxHl/EHOD67CT8oDFPuvYmPYdtuWKyiqxoqrT9vwft+7HUaRvDLUA84Ta8PiyWNfLLUv5pMqn8C4YTZ8mscKvw97BG+nN+HlHwP5biOO24eyKcOU1RPtZc3K+KikVTE5cOHTQVeziIqU9desjV8E0JEKqvMCeC7xBEclzlGzQxtGsBXNdkwkcOoieHinmqO
 EfL7O3lp
 9LbxGTetFam6ONpYUcF3KGCJp5pHQhH5ASwaIZFvzqAwKugsyBz0vXpSQS5PblWXZFuSXJL6JonzJi2Sm+1BX9oLDWVQ7roSsfnsNQcJbUdp8dqPF1nsGccUcvji7vQfq2Sn4IA6NrSnX/89m/5kY/ZWeXA8PASlTGAdMZ8+fLsj1fRnmoyeFp+OG0QEGgFq60x512ggbmiGsT96tMsYsyAjjXquTvm9WVWdyqDUlPsy+W22PTpF8nrWJlrWep0u4J9ka/PlReJASXDCevc9sDl/685IiFYfIJjVLR6A8mrdd/Y9IxLE2AGJPgk4+GWKjYpOYazLICD/BuN2KbVzRVKtppZsGUiapOk4v79u3wwS0W8TIIOS3bEtURWj8IxVKmA4FgGR4tRGD8WFBrn9d4zLK1d00RkZqLYoC2PbWQ19nShnXNS1CzMX+wIuqHgn7eAZ9TyHBr4L6Z6XqAAPAFRj3XCS5cQRphImB+fBzREfBiuESyLL3DYwyIi6l3DsthcoFClGVjMHXsPuMFlOSKRX4Nmbbu0eLysT+6t4cfpzI9EAhomGaqxwcKWhMkuJKpOg+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025 10:58:17 +0530
Bhupesh Sharma <bhsharma@igalia.com> wrote:

> Hi Kees,
> 
> On 8/25/25 7:31 PM, Kees Cook wrote:
> > On Thu, Aug 21, 2025 at 03:51:51PM +0530, Bhupesh wrote:  
> >> As Linus mentioned in [1], currently we have several memcpy() use-cases
> >> which use 'current->comm' to copy the task name over to local copies.
> >> For an example:
> >>
> >>   ...
> >>   char comm[TASK_COMM_LEN];
> >>   memcpy(comm, current->comm, TASK_COMM_LEN);
> >>   ...
> >>
> >> These should be rather calling a wrappper like "get_task_array()",
> >> which is implemented as:
> >>
> >>     static __always_inline void
> >>         __cstr_array_copy(char *dst,
> >>              const char *src, __kernel_size_t size)
> >>     {
> >>          memcpy(dst, src, size);
> >>          dst[size] = 0;
> >>     }
> >>
> >>     #define get_task_array(dst,src) \
> >>        __cstr_array_copy(dst, src, __must_be_array(dst))
> >>
> >> The relevant 'memcpy()' users were identified using the following search
> >> pattern:
> >>   $ git grep 'memcpy.*->comm\>'
> >>
> >> Link:https://lore.kernel.org/all/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/  #1
> >>
> >> Signed-off-by: Bhupesh<bhupesh@igalia.com>
> >> ---
> >>   include/linux/coredump.h                      |  2 +-
> >>   include/linux/sched.h                         | 32 +++++++++++++++++++
> >>   include/linux/tracepoint.h                    |  4 +--
> >>   include/trace/events/block.h                  | 10 +++---
> >>   include/trace/events/oom.h                    |  2 +-
> >>   include/trace/events/osnoise.h                |  2 +-
> >>   include/trace/events/sched.h                  | 13 ++++----
> >>   include/trace/events/signal.h                 |  2 +-
> >>   include/trace/events/task.h                   |  4 +--
> >>   tools/bpf/bpftool/pids.c                      |  6 ++--
> >>   .../bpf/test_kmods/bpf_testmod-events.h       |  2 +-
> >>   11 files changed, 54 insertions(+), 25 deletions(-)
> >>
> >> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> >> index 68861da4cf7c..bcee0afc5eaf 100644
> >> --- a/include/linux/coredump.h
> >> +++ b/include/linux/coredump.h
> >> @@ -54,7 +54,7 @@ extern void vfs_coredump(const kernel_siginfo_t *siginfo);
> >>   	do {	\
> >>   		char comm[TASK_COMM_LEN];	\
> >>   		/* This will always be NUL terminated. */ \
> >> -		memcpy(comm, current->comm, sizeof(comm)); \
> >> +		get_task_array(comm, current->comm); \
> >>   		printk_ratelimited(Level "coredump: %d(%*pE): " Format "\n",	\
> >>   			task_tgid_vnr(current), (int)strlen(comm), comm, ##__VA_ARGS__);	\
> >>   	} while (0)	\
> >> diff --git a/include/linux/sched.h b/include/linux/sched.h
> >> index 5a58c1270474..d26d1dfb9904 100644
> >> --- a/include/linux/sched.h
> >> +++ b/include/linux/sched.h
> >> @@ -1960,12 +1960,44 @@ extern void wake_up_new_task(struct task_struct *tsk);
> >>   
> >>   extern void kick_process(struct task_struct *tsk);
> >>   
> >> +/*
> >> + * - Why not use task_lock()?
> >> + *   User space can randomly change their names anyway, so locking for readers
> >> + *   doesn't make sense. For writers, locking is probably necessary, as a race
> >> + *   condition could lead to long-term mixed results.
> >> + *   The logic inside __set_task_comm() should ensure that the task comm is
> >> + *   always NUL-terminated and zero-padded. Therefore the race condition between
> >> + *   reader and writer is not an issue.
> >> + */
> >> +
> >>   extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec);
> >>   #define set_task_comm(tsk, from) ({			\
> >>   	BUILD_BUG_ON(sizeof(from) < TASK_COMM_LEN);	\
> >>   	__set_task_comm(tsk, from, false);		\
> >>   })
> >>   
> >> +/*
> >> + * 'get_task_array' can be 'data-racy' in the destination and
> >> + * should not be used for cases where a 'stable NUL at the end'
> >> + * is needed. Its better to use strscpy and friends for such
> >> + * use-cases.
> >> + *
> >> + * It is suited mainly for a 'just copy comm to a constant-sized
> >> + * array' case - especially in performance sensitive use-cases,
> >> + * like tracing.
> >> + */
> >> +
> >> +static __always_inline void
> >> +	__cstr_array_copy(char *dst, const char *src,
> >> +			  __kernel_size_t size)
> >> +{
> >> +	memcpy(dst, src, size);
> >> +	dst[size] = 0;
> >> +}  
> > Please don't reinvent the wheel. :) We already have memtostr, please use
> > that (or memtostr_pad).  
> 
> Sure, but wouldn't we get a static assertion failure: "must be array" 
> for memtostr() usage, because of the following:
> 
> #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + 
> __must_be_array(arr))
> 
> I think it would be easier just to set:
> 
>    memcpy(dst, src, size);
>    dst[size -1] = 0;
> 
> instead as Linus and Steven suggested.

The compiler is still likely to make a mess of it.
You really want:
	*(u64 *)dst = *(u64 *)src;
	*(u64 *)(dst + 8) = *(u64 *)(src + 8) & ~htobe64(0xff);
That may need something to force 8 byte alignment.
Or force 4 byte alignment and use a u64 type with 4 byte alignment.

	David

> 
> Thanks,
> Bhupesh
> 
> >> +
> >> +#define get_task_array(dst, src) \
> >> +	__cstr_array_copy(dst, src, __must_be_array(dst))  
> > Uh, __must_be_array(dst) returns 0 on success. :P Are you sure you
> > tested this?
> >  
> 
> 


