Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E9DCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322736B0088; Wed, 14 Oct 2026 09:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACCB6B008A; Wed, 14 Oct 2026 09:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1751B6B008C; Wed, 14 Oct 2026 09:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E32316B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:02:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65919140504
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:02:52 +0000 (UTC)
X-FDA: 85321246584.27.99CDECE
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 600A040003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:02:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IzTh7nAf;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791982970;
	b=VkbVccd2EZbL6dQcnQHp9YmyqSZQEVhwzE5hUQ9HF+SMucH8PyCT21P371Z1gfnSWOT+Zl
	R6/6tr8kIAWxtDqcLEV09VfLfQFltPqACEhWKzur7fUtaXXYSgg56bR9F7lJNNdaQ1TzjR
	/iWrFaFg5gS9Tz8Bhwghj3PyDHTl4Ec=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IzTh7nAf;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791982970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+g+JcQ9fBuosfYzKHFrjP1VpW5rAUzuZgfEvkBjq+A=;
	b=IigiXGn5Lum4RxQ+ncYsqs1jPvVgYV/BWVSGPxdPrIttPr/yXcGsgSVDGODAo/wCB7DU6e
	nzv+Z8QMbggOgd7TzpXWD5E17bpiGvEX0pBchuo7E1i3Wj3HnwfewZ/fL3nA6b+8/L0M2H
	7ta2EYlDfH8N5D2OzIF6Q6SS01hOWV4=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53504882980so49477511cf.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791982969; x=1792587769; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c+g+JcQ9fBuosfYzKHFrjP1VpW5rAUzuZgfEvkBjq+A=;
        b=IzTh7nAfmDxP1C2Al8wmAuPzTgW8InxMz0cn+9eux/V7n8uWUA8xXP5/W24V2Ve/VZ
         WNgUk8A28NaWh/x9ZUmOlKLP9JdTuLb3fKaScWpNymOZVz5aeRjsTvo+Zp6ZQP0p1j7l
         1EIfFx4Hqn7q+iwtde/cudAyOU0Z4D0OLrkpczN9POmZjSO2cqu2eGEEgUASULLjFxxx
         LcJlU8hllY9aHNWWl4J+3zkgKHwhXVT+6Mg3NR8ZsVFzNZ2j3NCfTfkHfjfOX61m8NBk
         uG+s0FJvssQAcl5X3QtCVlzTzxCsrA4Z8lYIa7mLyUD85LGU1zEm0ZvnWvOLybCOgw/Y
         WbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791982969; x=1792587769;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c+g+JcQ9fBuosfYzKHFrjP1VpW5rAUzuZgfEvkBjq+A=;
        b=oZgMOJZjJ3FCM5TIcakkFY9OfAwVAh9q+7wp6aiJDSvHVQ/jjbNkqudoMp3pIPqICk
         v/u3Q5ILKfYm9s4mm4jHR3IiOuoApR4rOOeYXtEyb7OGqCg/U/vhGynefAt3RsKPeIM7
         tNkLghCPRirW0KI4ba5vdkaip4+bpVK8F4lxnpaucdpu7cFmS1wfYxNh6lq3zEalSoar
         VI7uw5vReVuFHL8hCMuPyvPYcGaoOvxpp6UNLWiPvby+1g+ph+NblMfZq4Eeb3PQmPrr
         Rlw/c49r3LEimqXurChilZM+5wirxyj9WxYfMsbvTkPVdqK9+hKhIj4xWGUcZwrEkxZ4
         eFMg==
X-Forwarded-Encrypted: i=1; AKwUvByXB+4twFUkXtM1JvfNhgpOMzKp0L7Q3SiJYrpVvaPqye6Bjp9wQ55YsgT9owH2zg6rt02yaKFpLg==@kvack.org
X-Gm-Message-State: AFq9FYL0K9NOFBz/hTSPlIVVkzb/wnAZRVOpOwzML6ezE/OarX284k7Q
	Ck/0JynUkY/Fli4dt+WNdAev0k2HRCUofFse1pA6jnpARvZhkjKvoCx34tUT4FfyizM=
X-Gm-Gg: AYBFou21QtEKI/sT0GzA//2iy2tQpNObT6t/KmLd2i13Wcmii2wq4a0ExQBg9u4NcfH
	Fbl44RqlussESFJAWXERzdip9fkTyiiMT/N+5o66IhkMLQBZ+cpZ4GhQvXqSQKcClvrz+khmKLU
	RvHCO8hOFcd7xhzCHc14K62bQl1rQY2xdxWiFzQkiiZY3tYNKnGrYaRVUmh8ARuWluESk5/PiZh
	VZzN+ieUJcsHOKIf+bWFnKU2sLaIe1fr4GvVl6GV+X3IKNy2w2MKy7Zakh+mzJpChqmwcZexLLi
	hju1IGLci+3h48oow2yc1OC05svxqH7+QcokOMMxrFqJEDSmSkzI8J2JSloC/POHk1RP7uoZKDl
	zWHpCYchLbIgpbO6r3SmX6Twe7ny0IjKEVG7fjWxfdLyUr28mmtAOGEsLvok+xDtzfIcp6CH7Yx
	eLrF97hEle1DdtlZdECw8viT2PZwNpkrPn/2xzjWI85fHC/8WV/yTOhvgcUaAr1BogNhvGU88hY
	V+JQdCa0dOlilROd1NsVqLQ20lMz4Mx7ezc6HVEPvrQsatde3DELP0=
X-Received: by 2002:a05:622a:e14e:20b0:535:b506:11c8 with SMTP id d75a77b69052e-535b5062ea3mr142869471cf.46.1791982969440;
        Wed, 14 Oct 2026 06:02:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b76b030sm124693521cf.17.2026.10.14.06.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:02:47 -0700 (PDT)
Date: Wed, 14 Oct 2026 09:02:45 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com, peterz@infradead.org, 
	mgorman@suse.de, riel@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] sched/numa: clear fault locality state on execve
Message-ID: <as98SA5yfBaeI4oj@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
 <20261014094347.99157-2-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-2-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 600A040003
X-Stat-Signature: wpgwtbij79oqm39dsnuqxgoipjdpw4wi
X-HE-Tag: 1791982970-598790
X-HE-Meta: U2FsdGVkX1+IuPck5V5V9r/k0TueZo8KlR6axmv58sLjNYYnc48sRcof+BNf/kX25H9fseNmW/J5r4Z+nMqmePUyiba9WZuNiwp+z+qXvtpsSExDXPDmunbX/OJbOa3idDSm0IA/w9ReUU9Goewf9uilQ1xSr35mZLSwVK4TeL7L/NeeyHgLpC5inaYFE9+pqj6u8TyIOnIMT6BYUXGuPE+E5+1mRF1VEzDMG/3KXQyFq7sK/2ab2P/4wx/D8xN1ocKQYqK5f4QrGx/9w9AN+IHt7NFcOhaClJWRQq49BKfio0he3IFLraz8vF4sXk54K1OqnMt6VmHrM8FFiDhR6GcQQNPZYEXtN6J273pMOCKJQg2900Ran/VLGl6oGfKCPQtsf8RcSCuQQMZZVs0dWfQkr4PgYG38fzbvVG34t0RkNN/40nFvFRz6/kcdzS5OkoQxLngh+25mutC8ODXne8WQw3KVxbqxpid6CWCxGhTmpRdn/QqFbIZigfv2ASCWoxYXrEWK/zK9biMyp9Y9CnPx3+0ANkmRXA7LsbWVJzK1UrK2rNxC54Z4QmB1OKg15A+1Kyj41mDXljb/qXIKmIPURDQv+au1I6OFVugp6z+JWhgVaUZElnlkzGmiHzeDdLKQDL6emWPcOFj3rkBXeSu+HBw7qymi5xbljqM3Q7oPm0sk+14raULQyQ5tdbMSpl1VYgnwAKI3UNeCQaPbcdNraoOXyybcedQPwNj0TOLBJTw6OsNAV020SZkGm7NKVZw/56pKQMKH+EGqwuI52skvRdidaxwopWR2F8M9zcyuoMlJHpYVgJtKU4Cjpj4UlwW0bltr2rOzmnII6LN7VRqdTkh6UvWvMsbVmPO6l47nlKsnWmqcZl3XYnJE54/yRSwRRXsLYPXAvf8W7d4dnRCZwnNHHRAAc6VmYU9uaQp2R+MdXkHc74yyh2CKWk29Ys2a9pEaR2Qn9+rDWJy
 XbxBxINW
 5R6v8M1TZ8hlOOB9zirirG7CiXFpEhpMdVVXj+Ck7b8M6JqxoX+OK9RlB4FZ9RJso/YDweSQdrQMzkVaCEg3hLozBO7JdblXRA6FdP2cvCrFG8v59CQYY2CyqQOvCuihDc93F7z/RFmUFTTanV3zJiqJx/5ezkns34BMKENT5jboOxjy4fcmTWtebeZXnbpmxtqwcMFwFPhgp/T3DDbT+h3opgeNBxmpII8XKKXVW3/v9u0T2MjVPYFLTJa/T2jVFPHXBIzlBGM28V/OaqWgIVDEHVvf1nNCPCQPM3yuAwunRMrTfjYfRxSdW8XD+LJOs8vlw9g9VgFVh0FeFQhsdryk0hHYBjy5TYcHTVWviIrlcin9cqhK16YjSr7ZY4k+bLzFxJRiK4ZBSWO03Lzx0FsxIyIBfkFFkKxOeJfdcuNOgRiPNo6nUfGTcgiUG8PzAQg0YTQtw7sZexDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:43:42PM +0800, Li Zhe wrote:
> task_numa_free(p, false) is used by execve() to reset NUMA balancing
> state without freeing p->numa_faults, because concurrent readers may
> still observe the task.
> 

Is a process that exec()'s going to run long enough to actually collect
any real numa fault data?

> the retained p->numa_faults array, but leaves the current-window buffer
> half and p->numa_faults_locality unchanged. Those are also NUMA fault
> feedback consumed by task_numa_placement() and update_task_scan_period(),
> so a newly executed image can inherit stale fault feedback from the old
> image.

I'm not sure this actually corrects much unless you have a long running
program that eventually exec()'s - and even then it seems like this all
self-corrects within a couple seconds.

Do you have some clear reproduction that makes an obvious wrong effect,
or was this just some static analysis?

It's "not wrong", but I'm trying to understand what impact this actually
has.

> The non-final path clears p->total_numa_faults and the averaged half of
> 
> Clear the whole retained p->numa_faults array and p->numa_faults_locality
> together in the non-final reset path.
> 
> Fixes: 04bb2f947505 ("sched/numa: Adjust scan rate in task_numa_placement")
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  kernel/sched/fair.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 57360f5cdde4..1053437933ee 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4177,8 +4177,9 @@ void task_numa_free(struct task_struct *p, bool final)
>  		kfree(numa_faults);
>  	} else {
>  		p->total_numa_faults = 0;
> -		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
> -			numa_faults[i] = 0;
> +		memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
> +		memset(numa_faults, 0, sizeof(*numa_faults) *
> +		       NR_NUMA_HINT_FAULT_BUCKETS * nr_node_ids);
>  	}
>  }
>  
> -- 
> 2.20.1

