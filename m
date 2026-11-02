Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D1260A2605
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ZmAo0GC3
Received: by kanga.kvack.org (Postfix)
	id 9F93E6B05B6; Mon,  2 Nov 2026 05:12:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFD36B05B7; Mon,  2 Nov 2026 05:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0026B05B8; Mon,  2 Nov 2026 05:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1126B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:12:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60CEBA0C49
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:12:49 +0000 (UTC)
X-FDA: 85389765258.20.CE5182F
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 70E3B8000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:12:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZmAo0GC3;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614367;
	b=fTJ6HulxsmP4430V88Y45QH+TDiQ+Ix0LqFoSf26osdMu7flMJbyqX2Ppmuh2RdeeWseS+
	wPr78WbMP1xjmsWiZpvD/zyMHKdFVfwBqvcJWFR9qHFZQriW9qGzc1wrLXFvRfcqvywMra
	f+xY582uPZqX3h0s32Y/ICcLjiFTrd4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZmAo0GC3;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhAJG7RoUXOoz7M+qXiobMg1MbFShww69uh/kTjgH68=;
	b=sxbN6c8gcQ8FIbya/SCK3zv8Gk0WeZOPoRarur1Kv3iuqDshYvWOOP2wamIAcoAbboJ7vh
	H2qi5naLR3UALpEQ8w6Aan7DJIPiVuDym5f7ceUJufYjPPyW4obwYQC/c+b6S1lvJ3u0h/
	J69k9FyhmRqHjGeE6hbhHfryyztGEJc=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so21859765e9.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 02:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793614366; x=1794219166; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zhAJG7RoUXOoz7M+qXiobMg1MbFShww69uh/kTjgH68=;
        b=ZmAo0GC326QM4z7FpIaE1QQWV+8zuVU5Nk7sT5f4P6CoO/dfqa6zAa4DEoH+NVpwOR
         pOybT04tVYngx3bYFVpf3i9DqxDC78deBppMTERL29qfxAyY5EJAr26WZmxVckULiqR4
         s6e5yeyqFTWvA9OWbM1DyT+lvk9S6MblzmM1LpqMHXmzaSeGPWRNkYSUDUyLvWFXWEO2
         KuNVwJZTqBmWZKAr5xwdtSZaRrpj3VATWB0uuUE1n8ZcKNXlfT00eTbsjhK1VF4t6Xx7
         a1qIGZvuoKRWTtQuPEI7bypGibkZmnHMpqMZEApIct6/EbvsATJziB/iKNbX4tLmRk8d
         qZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793614366; x=1794219166;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zhAJG7RoUXOoz7M+qXiobMg1MbFShww69uh/kTjgH68=;
        b=wbPVYNxPstH5iWaaRsNkOaFCDo4v3OXsL5idYAEnehc7LccKoKEc4MUN92p/9twgQP
         I3lKF1AG189kgRhoi9GFZQRqJcvYdv+PGApFqqtcnJm5iyGP8VPXkbW10aS00jAymPA2
         cVKmHJcOB7nvG89V0tjypjl1hDVrI89pHLW7vTrO84/d2NMkEJ359qHMyWxPhRpQVVe9
         BrOYXeBFxH2ftRPqgbgj3LcZSAUZ1ULtXNOP1dmKiC6uzPv5YjFbp69iF4y67xKj6PBV
         myThLWTpVwPL6E3XtRu+yVRHsv+xbmbAlPDaZOUZY2BmS+CYy3nBowFW5zEcvySi+ezl
         KRCg==
X-Forwarded-Encrypted: i=1; AKwUvBzV+IEf5qYduEqOgIv6YIUmUXSUr3UnlbAYpp2EbDw2hJfgRetLxXOx5baF5QRcSYCuPCeTjQx1qA==@kvack.org
X-Gm-Message-State: AFq9FYJRKXlI0TtMLAWm/UTbXdZYzXlnsn6wVe+4TI3YtVQcptahwCj4
	oF6bPQeZmTNmrmJyqWTb5cxuhPfHLzqnEbNwdOR9q1DiLeuq/XH3Pa73VMN+EVjmm2M=
X-Gm-Gg: AYBFou0OIEsRIyFrlTus5fqLp6Supz3vx6PPabE4h4I0wQJ6WTA/r+sPhXRfLHQ2bTJ
	O7eXyTiBFfIdYGHmtAI7lxghlFr3ES3/RA1hi3QIE5xVVToODVj4u6T4eDFj9/+6S3EcdE/cyPd
	Lcq0nkClIB2z4Bq+KhZMzT/bS9oRIZyySnfP8s/vlVCM6YJiXJy5ZIyw9+AkWXoeH70QcoGII5m
	fO53nxz88q5/jiu7y9k0ZYvNUqC7gDmky3CUQTr4ZESoNktgoCWwfWQqYawcq091nGnSJOyYzjD
	KDWuksQrHOrX2REBci7UV69gDxB8liJXI8gSHvL9At5G56x3guUmxHCRmljWmG4HVMrvAbD7sDl
	i4u7c5LJ71gIVrNMArA6qfULQGA96GjHm13WIn9Ts5kPNxwRsHyUYPYQZOr2gAHpSPtvZ/XGnDU
	6OF8mh//RJnyo7TM6PKnIW5Lkxz8k+iA8DC80QootvTSMdw9FiuqJV2ptfuXRGM6WLj/bXtUGv5
	ua+gyHpQwTwCtI3d+ZkJqdlzHKEK/BBOTdkxi1q7067L6/WP5CumH4xojlOpn/Fa1ZVVgrUac03
	i6dUwU04RPJXgIesKUoGNqpKgvn3Zz/qyC9tYng=
X-Received: by 2002:a05:600c:19d1:b0:4a2:677:ad8e with SMTP id 5b1f17b1804b1-4ac1970b9f7mr217205325e9.34.1793614365911;
        Mon, 02 Nov 2026 02:12:45 -0800 (PST)
Received: from localhost (109-81-32-81.rct.o2.cz. [109.81.32.81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9a3b1sm20935867f8f.44.2026.11.02.02.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 02:12:45 -0800 (PST)
Date: Mon, 2 Nov 2026 11:12:42 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhanxusheng@xiaomi.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <auhiGqKJeukk7t3P@tiehlicka>
References: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026120248.2188024-1-zhanxusheng1024@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 70E3B8000A
X-Stat-Signature: ufbkoq97thiszdmxz3693gw8xmr9ujyf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793614367-660770
X-HE-Meta: U2FsdGVkX1/tH+U0S0oETDuPzlFAWeWdOx+okgv7jki/Hn80VXC/j6eeMssSUQEEdq8HrXp64jt6y4eFcKur33p5ffMhtIPKka6uCATiR7sNi955QofYbqywhZxufMByUlcsVJoS9Fvqjkdr3N2qwzsP0lQ4gRLaj0dr2uw2l4U0YUgWAn62vWGg0nDXNF4JfowxEKabglaAVxWl0nXqQMR5MmgPn3YbZCdElZ00EMLvbqDLUgYSGZOrlCfOoALCitmZQSc+G9ryWPoOP2qem/is4uAfMz26rvWWlvCIkci8Lem9414N+h6cT+0hr+bEjuAN6alqF4061gkhJiJXfJxnD7oV4OXyIiR4jRz8YYmki9+BEf9usyojS2HnW9oi0IWYV99BR4RIgFmtRDWRbaLH8sn0AOIU2wi3h/IhFGwu1btS7yYQlxkVw+kdHqfYehyXNjFYC+O0fio2JAoMRbaLZvljkLStI96c3pt0xsDluxGfT7zAiwRv2tTpn+HCdzmJFLfICy5ZbK+3o7U41HUpJmC92BfoLIyLRUsyR4XQfBNqBjUs4B9dBNW2yldsY4uAXXLp3X6uhekzN2yz37UtF3zNJc459mN4wPYViymQuUbCFRUc7y6lx2+GGbMKntjeAIrmOVMbso+TWItLYUhKDbTfHEyLZBqrDSUSQipHouKE0IyX6Xcx+vAHm5mLCQVdwfQXKAhDE8Zp11Dsp+qFr1MNEofzqtHjj5o4TZq8Y/oMfqkJVYHYEfFfepUGiDL0l1LjepzS09fzqdi1vZCG89yFZRmZ/UzgmIVEq6MuGE1M7TdVnzSYKqBNBCUl9v1JV9um9bx1V8utQgV3CanU0r0QyHmPK+rYcoplLkfRDGDjCE6We4Giz50NZ4S7Bc481avfwDM+nG7FjEMjOHll6gdmoQsPvLeyeJDte0tqZy152aS2j/P7z2aRQPx2Z17NfL5gfGxrSuN9b/q
 0FHz6Lzc
 995kkqNVTvDDQu3yxmauiBuRIUMgtGwixLHizvSaPtzc8Tuu8zClNnC8GlpJfrtGRTkF13GqSMHl16Udj0tf8zHAjqr8GVhf3w+gOeKe0JXhKt3jbxEohSiooBoY9FXoiIHgCVc8V1mSdkm9G1fVOa6j5uoc/N9nde4lViFe4OwfB1VXDui6Duu7TS83npD1znz7+wiqy8g3ldcnixfWpwlRly+r0tqmSSPczlxobqwFRDx8LyvMcEOjsRhn9KfIu/qCRDU7NC49hX3jLEkNu//17xrFfm0yXBinydBDuz3ddZfvPk9rzVP226y5Ay1d5PwAnbKK2Xm/UnohSfxzA+0y+D6trYPJRsJDzM+nUWD5CDiEfmEo6j1OUpj8AJjmEZdp+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 20:02:48, Zhan Xusheng wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> mem_cgroup_scan_tasks() walks with CSS_TASK_ITER_PROCS, so it sees only
> thread group leaders, plus a dying leader that still has live threads.
> Moving a process whose leader has exited, by writing its PID to
> cgroup.procs, moves the live threads but leaves the leader behind, as
> cgroup_migrate_add_task() skips exiting tasks.

Is this a desirable/intended behavior? Shouldn't we move the dead leader
along with the rest?

> The destination's OOM killer then cannot see the process.  If it is
> alone there, every attempt ends with "Out of memory and no killable
> processes..." and the charge is retried indefinitely, and
> memory.oom.group kills nothing; otherwise another process is killed in
> its place.  The source's OOM killer still finds the leader, reaches the
> moved threads' mm through find_lock_task_mm(), and kills a process that
> has left the memcg.

While you patch works around this seems like something to address in the
cgroup core. Should CSS_TASK_ITER_PROCS iteration see all processes
regardless leader being alive after or prior the migration? AFAIU the
thread group belongs to the new cgroup in both cases.

> 
> @@ -1452,9 +1482,10 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  		struct css_task_iter it;
>  		struct task_struct *task;
>  
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		css_task_iter_start(&iter->css, 0, &it);

Shouldn't this be CSS_TASK_ITER_THREADED instead of 0?

>  		while (!ret && (task = css_task_iter_next(&it))) {
> -			ret = fn(task, arg);
> +			if (!mem_cgroup_scan_skip(task))
> +				ret = fn(task, arg);
>  			/* Avoid potential softlockup warning */
>  			cond_resched();
>  		}
> 
> base-commit: 6b4b543fa18757297ac756a6fe6e64f506b7844a
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

