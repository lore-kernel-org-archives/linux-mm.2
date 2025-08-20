Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B7ECA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A1B8E0002; Wed, 20 Aug 2025 05:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249E26B0118; Wed, 20 Aug 2025 05:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139578E0002; Wed, 20 Aug 2025 05:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 00CE56B0117
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:34:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B13414038E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:34:23 +0000 (UTC)
X-FDA: 83796625206.25.74B6273
Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	by imf08.hostedemail.com (Postfix) with ESMTP id A4FB3160007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:34:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=laTtueep;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.67 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755682461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z79weBAoziwk7d5gCcPuETF5kep03u8b8tRTqrPor8s=;
	b=XsYspkQkCy7VarnNAVX3cyaBGVOukEgcmzkBPTG896d9UxdCEOCOeWVskHhfeNVtd9eBPm
	+ZE1bBCRRjQxPS1l4AoCuSvM1zYnZvHXtGXswbFSUMDam+ydeDGliCnropS04JIsvzXfGs
	9MlqWUtMtHM/TULtv6DN+wWGbbB7kUI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=laTtueep;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.67 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755682461; a=rsa-sha256;
	cv=none;
	b=Zv0JWot83J2lx+8hMgh78rvhGUWR4bkDXJXKiKA7u9S63A3v6idktJ30ny54YfPPRHUpa0
	TH/UbhpljPjar+BnFImE8sv2MkwYQIQA1MovYR/BdNcUTGbTft/WXCt++cd7fjYJLeMUmm
	o99sbg0Tur/kdTJbbHGm8C+CFFIFBh4=
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-6188b5be5deso8200974a12.0
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755682460; x=1756287260; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z79weBAoziwk7d5gCcPuETF5kep03u8b8tRTqrPor8s=;
        b=laTtueepA3s6nZT4B1/gJgsEKy0oMxezqTqHmvHfeCcA/uFXC5uXgA4hh23196VUUf
         3C5uqdvYrdpVg87VW9tz8xNLKquyUfSPZ6zMtXChMqZZovM03qMlwXKbhF9qD9GLS1rm
         P4BUhYAxoO28Mq5Ukd/aLGOpfQTTQSzOv8NbF8IgOlZPCQHmxREzl7FORoPIDEIM4GQL
         6LijBOkzGbG/3GCZh8PFBoGi3hwv2BaKx/vW7rZHkL7PQvxW0idj7KGwYgqQiZoEIkjJ
         KM2Dd1mWscspOAZe4HVj/15UhDcpDSkjcPp08zmII8vwAD5rEYKDyENJ17Hr9gATc+6L
         UnSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755682460; x=1756287260;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z79weBAoziwk7d5gCcPuETF5kep03u8b8tRTqrPor8s=;
        b=S7uZlxB8U77LDoA3V1XDHeiiaXVGODN9SOOReF65yllyp5UX6C5klVCrgZIaGzmfO3
         EL64xR4NFdVGwvTdh+erPH0QrXEnk5z3LdvGazUk+98HP1M1T774kxvKZVU+p377yMfL
         fSISgnE2hrdOAvGPLljlXG9D7i12xYHSt+7IoGL15QoM49o8DrabGG7YO/asz0QBxuuc
         GmAakk01+PvrLG0BBJ9weDV/tDddrhVsFDKVTkYPe/C4f3QsmBHdzLMjGKcFGPOEzH/5
         VXRJuUaXvddTP3iYO7X5TtLsbVFSABYVuS1l2VWVAPHYTi8j7cuBnS2ltAfUViT8ZCVO
         D1AA==
X-Gm-Message-State: AOJu0Yz2J8sO7DoBV8EixMQ9J6NivF5wanS0KutWF0bmbVW+bFyH9aph
	8pceXLL8HxkjBnZy0HrYg63egbpxgTUPpu4OCabRXW1wMa5QSXmC9/4zTD0UcLy/uiJ6J556zdp
	6II7SkEXAaWb7gz4K3bF9C3lhn6eoqZg=
X-Gm-Gg: ASbGnct8J1cDu3aSAJjM79JsUZZ0T4JZ8l+wxdPdkSqVFFgRPytAwiC9nO/IyoLy52e
	nCaA62OORPqXpPnyTF0ihi7mIMvlFE897gs+6XYSGuSTUpccnbaVTwBDwRTtd+44Tdy+REvq+nu
	EA3+xYOuuOjAz0NuTCTNFj4/E5ey9P8Z4Uv0SV1ZmZhKD1ozJxi5Yc9SqU5aPHlwhxxOo8r9o30
	by1R7+6+Q==
X-Google-Smtp-Source: AGHT+IF7Z5HBgUuHRtZlDrk58pIlZKtqCG8u6CXuofJUTADQqbgEbDss+NhRKT3L0lSiXhbMysoUuPReH3dWOu/K2ZQ=
X-Received: by 2002:a05:6402:28cd:b0:615:5cc1:3453 with SMTP id
 4fb4d7f45d1cf-61a97557064mr1873977a12.9.1755682459448; Wed, 20 Aug 2025
 02:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-11-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-11-roman.gushchin@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Wed, 20 Aug 2025 11:33:42 +0200
X-Gm-Features: Ac12FXxwG_eiUHr_rNpX2v397tG-VV8CGyGn-PqOmB_AUl8RqPT5ZQXR7dMaoo0
Message-ID: <CAP01T75_ArZiy9AB6TwNZCxKJKw+2yg58xz1ubTGZr4ynVt+Mg@mail.gmail.com>
Subject: Re: [PATCH v1 10/14] bpf: selftests: bpf OOM handler test
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A4FB3160007
X-Stat-Signature: ok8eprnok95prd64xuecbtz7a5fumsp4
X-Rspam-User: 
X-HE-Tag: 1755682461-292650
X-HE-Meta: U2FsdGVkX1+9qwfnCTQHYlgVhWQKABtaZJliXTPWYfNwxxKIc+VcaSffO1j0sDYZAIaf2iNt1Mmpi59wt5az6XgaPHDSAztFRgOinhLSUXzV9dCW9T0jYJqXirjfJF2AkymTVfbXynWRhZnz+pZNs80c9R1+fNBKlX89EgwX6ZqBIy5FA0SLcpMVmQ2b9kMay/QPvRq8h+PVjIA52WUaokFIzvI1GqEUbHBS2zd9s1W3YU7jkaFJ1CWjklgrb6pxzrtQgcdL+ZVGldkaLC6F9nq0xSpmcbZa+HokruMFExIeg7hZP2yfXMKy+EKlR/WwBg/7M6/hVq72CYfAy2Vqmw5wvml22FcaWFmk+mv8ImnzpE74jATnr+fQejok7PMuv8F6VBa76k7+YSDUPqBp21wAvRXut7T/N4HavQ1EK0Bh24wg9ioXANFuAb4lNpIFcAQyqOMxIQjhOcFB8AmGBbqvTi9U0ij8CEpVDB8z8z7Lyp8ZyD95AGCKnImIedTfSav00Q0qtLCGdCEQs3Kohts8h/LwSZlZHrkhaRPs/hdW+1+mMcDvlrwcRWOWecs+9WfKejx6LFPqoV93pDc/RhLXXy4PtyKG7jojiFhlEsZNT++47d2C8Ooy2gy6/V1TL40hYOkKTRPAHekxDmWAgluQAQC35OhhrzRQrZQkw9dT2vMdZsnpcz9u6nGluZYBlU3ouaW7nhhkqrlhV51sni3yzwLQbm/PgZL9WCi0vVpk+p0ck+jwyfhsxuBH29at00QkPeXEkX+kspVJIWTcJAMSdYpOw1zAWvYLgfgi0+AIcwjpxdP3/Ud4ETEPMTk4QlbKQMP0X/lvYagRGOq4sP4SDuQmi30XtlHaIcakoJ1jqAF+ejXskxXWGqSiKt2o3nwwhJdcJUoOghuYL7JOo56/uXL1Hh4QOKe+Ce07adaQNJg+X9eK6XyhmzUsXKQ4spOZ5KvbS7ibimPmzue
 LNt4FAAw
 dXAbkV2OBSQ0PwZTuEZ9k+Q+hfhZDyteAxAWV1OqxwdRwHZ9wVdkp16uqUxbnRIqm5Xphkcn/Zb5gVMCH8H3o9etmpGtF4TvN3QHI5swBJJur5XmidZnPTv28IwCx10ZbxVry5jQH7Pqv4fyfkfdcuDXJGc6xvgALIzuA77JEVH4VgqiCsFlUj3JEvS6tT7aVi+G/HJ9mV8duUVo4B7NGeZ9TZR2LY0c9EwDK4CCcD/9AkR6rTit8oJDfjDllkhNdB0AURE5vL7bDxg4Vlc12G2n63xqz0IqO5wxfC0xwoTSd5Moxrgxc75ifs7xykAgV4ym5e0k90gN4ukiSSyT4BqtFmsSCFb6UCvfLQgYDyppYk6qJPKqgC0PVkNastEFez5BiHK7FvVkQQkYgyUg9N8tsl1dVCkhvmCPeuvt23uaUBgGzgT2GDESmqER59UzdnLub
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Implement a pseudo-realistic test for the OOM handling
> functionality.
>
> The OOM handling policy which is implemented in bpf is to
> kill all tasks belonging to the biggest leaf cgroup, which
> doesn't contain unkillable tasks (tasks with oom_score_adj
> set to -1000). Pagecache size is excluded from the accounting.
>
> The test creates a hierarchy of memory cgroups, causes an
> OOM at the top level, checks that the expected process will be
> killed and checks memcg's oom statistics.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  [...]
> +
> +/*
> + * Find the largest leaf cgroup (ignoring page cache) without unkillable tasks
> + * and kill all belonging tasks.
> + */
> +SEC("struct_ops.s/handle_out_of_memory")
> +int BPF_PROG(test_out_of_memory, struct oom_control *oc)
> +{
> +       struct task_struct *task;
> +       struct mem_cgroup *root_memcg = oc->memcg;
> +       struct mem_cgroup *memcg, *victim = NULL;
> +       struct cgroup_subsys_state *css_pos;
> +       unsigned long usage, max_usage = 0;
> +       unsigned long pagecache = 0;
> +       int ret = 0;
> +
> +       if (root_memcg)
> +               root_memcg = bpf_get_mem_cgroup(&root_memcg->css);
> +       else
> +               root_memcg = bpf_get_root_mem_cgroup();
> +
> +       if (!root_memcg)
> +               return 0;
> +
> +       bpf_rcu_read_lock();
> +       bpf_for_each(css, css_pos, &root_memcg->css, BPF_CGROUP_ITER_DESCENDANTS_POST) {
> +               if (css_pos->cgroup->nr_descendants + css_pos->cgroup->nr_dying_descendants)
> +                       continue;
> +
> +               memcg = bpf_get_mem_cgroup(css_pos);
> +               if (!memcg)
> +                       continue;
> +
> +               usage = bpf_mem_cgroup_usage(memcg);
> +               pagecache = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
> +
> +               if (usage > pagecache)
> +                       usage -= pagecache;
> +               else
> +                       usage = 0;
> +
> +               if ((usage > max_usage) && mem_cgroup_killable(memcg)) {
> +                       max_usage = usage;
> +                       if (victim)
> +                               bpf_put_mem_cgroup(victim);
> +                       victim = bpf_get_mem_cgroup(&memcg->css);
> +               }
> +
> +               bpf_put_mem_cgroup(memcg);
> +       }
> +       bpf_rcu_read_unlock();
> +
> +       if (!victim)
> +               goto exit;
> +
> +       bpf_for_each(css_task, task, &victim->css, CSS_TASK_ITER_PROCS) {
> +               struct task_struct *t = bpf_task_acquire(task);
> +
> +               if (t) {
> +                       if (!bpf_task_is_oom_victim(task))
> +                               bpf_oom_kill_process(oc, task, "bpf oom test");

Is there a scenario where we want to invoke bpf_oom_kill_process when
the task is not an oom victim?
Would it be better to subsume this check in the kfunc itself?

> +                       bpf_task_release(t);
> +                       ret = 1;
> +               }
> +       }
> +
> +       bpf_put_mem_cgroup(victim);
> +exit:
> +       bpf_put_mem_cgroup(root_memcg);
> +
> +       return ret;
> +}
> +
> +SEC(".struct_ops.link")
> +struct bpf_oom_ops test_bpf_oom = {
> +       .name = "bpf_test_policy",
> +       .handle_out_of_memory = (void *)test_out_of_memory,
> +};
> --
> 2.50.1
>

