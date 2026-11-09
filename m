Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB3F606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=LGccKbP2
Received: by kanga.kvack.org (Postfix)
	id 6DFBB6B00EF; Mon,  9 Nov 2026 10:20:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6904D6B05B1; Mon,  9 Nov 2026 10:20:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F1A6B05B2; Mon,  9 Nov 2026 10:20:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3CC6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:20:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7894D1206CE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:20:36 +0000 (UTC)
X-FDA: 85415942472.23.258FC63
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C0308000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 15:20:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LGccKbP2;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794237634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I07lJrgFsxm3E13lAXBgVpKwF3TGQ2q83seC4rcxvKY=;
	b=a1vInitZoK3vN43uGDcyzFr1ZDSklOL9w+Frz5MTp3gSXcDPGAZKXkSHX9h1bORRsmQDiR
	x3YhuuT8t1Q/kIXc4pTKZQKD9PPP0ReUyk+cZ0RrL86Up6gAgmiFf3p3haac2v1TzvZHqz
	CVZGDFnNPuiNXbGOzViDcS8zXGURATo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794237634;
	b=fN5rPexRzgaPT7nAkeDEZWo84F9AtK0FgQ+WBCTpfBMz0M15SMk7jdzhg03Zk4gNVbbJQf
	MBIZQpOAKwnU9dnjzX2bHJsF5+6IMeieNdqvOMixuRhpk8IIJL7B4Wa8dECS044DTjMXQs
	SwLcPT0B2aPYxNKRI4vmJorNYipk1F8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LGccKbP2;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-492690dd5daso687943f8f.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 07:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794237633; x=1794842433; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I07lJrgFsxm3E13lAXBgVpKwF3TGQ2q83seC4rcxvKY=;
        b=LGccKbP2ZRTptnareBsE8K3QPmEkmYXeTooFFgJsxiWcHFpQrl6sdu1NaaAbtS0VrO
         0skHiP1wYW72Y+H49nib/kDlg7iGEi0EwyRi/kOdEKfJ1mIOhwDb8iPFFtgOOvNMl6ix
         0K6u8Qutn5NhLKdg8S1tjzsrEPX/qdUWaU/GI1RdUrk2reUxsF2A4hxMV9TiSjT/lueA
         PU6LYJV6KOqpm//bWLb+t3O6F2TbcRFp9s2U5j8o1fAHH3h5VKSA5wmmRpxxChkL/F+2
         fTqZnZHu47faIbHz3hMK+7fBGirC1U2QSRH2rOGLz9bnB/+enk+EYIH6CK05NJQ9456Z
         +IKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794237633; x=1794842433;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I07lJrgFsxm3E13lAXBgVpKwF3TGQ2q83seC4rcxvKY=;
        b=S54XDW/bgsgrESsRxxFbhnzrjItH6S1QWlLT6rccESG1mYk8CQxdxn95IXvpw9C8Pz
         fvsS42fO3nm9KAfoZY7fDEkD1kn8h5lDzBRigw7f/91iAZqWbRlciDHj8eAzg511pQRD
         MSaTDViMtLKqL2MAsKsbsx4n5FystW3gbrq8ha5QpzUKyadtgfpm48iuBO4B4G1v9cL3
         rvNCTzxrW6uQeYpRfSdaEMYc1oxB4aP3LPneU3RVbQfZwPaOMEeDL2pK1N7tns79xwoD
         QKhXbBDjPKI6AGABpgkBz4V0reVmX264xhWpPsx9znC2xVN/xHqPSm4A0rRNKhx3iXWD
         BeFQ==
X-Forwarded-Encrypted: i=1; AL+hErGxEGfeeTwUyUPfbnX6DMFijeoEfwt+S5WIA/3L3qzMdmjOkIYgdiBO9cSYV4o6HhI2iIQ5pzV8uQ==@kvack.org
X-Gm-Message-State: APuU4Z9woODKUUXsdiUOOeUag7GqTpnXY3RwKFAuXIuhmb9YkcplKqJI
	yChpUA37iuK56JT/TqpF2Uu1kxvVJ3Z7Vuog4hgFDYRJxo4tIRmtKjNhnj5KEExZPTU=
X-Gm-Gg: AYBFou3e4ppGBsviaP7dxuCRiE0myfHaIxx9QZwmQI6+67YkEOApKj3AZhXNzq6r6EE
	IsSgl//lMLsgZnACEsbx7Mk/SPFD8LmE/17+nX2FUDZDLE7YSPMJOZFZg1Uj4z81/DaiQv4vXj8
	Ry4DMyjvPH/M5V/T5iUIAYPWCTNajFAveqmMebDAMLB2iljNgoMbDZnbHRCitCk8BSx5q2UYmp+
	Jufph/boB/kUUBxXhTwvMwzLhm9okRzPkpDC4m96vWVeKVGLSxtGbrdqeuhB2U5+VuDV5OUX5A0
	2xKWLvYRxrHI1YF37q8W7D0L22o/I2vvfoVwWGNd5aeMe1WqpVDziFKGyhFFh9NcM5hLW8pdDUX
	QRM8sH+uOcA4bPkzho0pnUfMKlr1YCnaqMCMQ7D6KG0312Jw17VTNRrZHh9exvT3mzlfmH3Alrf
	SXe07kxXAn9ku0wn9pFxTalDUg90uGHxE1fglE+pTdmnTtLm3t00e/BRAK7+bsCJFiassnsN9Lz
	lOZ2mz2+KfK8PP7oRZyMvbIhcMLlVVDgkWNWXz/4GrOuor18p/hIBofUT2DO5xkzZRykKWcY7mk
	1R77A0csv0lX6JE0Z/hMtvE/fnH17ldMWP0l842bJA==
X-Received: by 2002:a05:6000:230d:b0:48b:9ed:b81f with SMTP id ffacd0b85a97d-4958a10a3bcmr8781666f8f.10.1794237632787;
        Mon, 09 Nov 2026 07:20:32 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49592f39899sm9626204f8f.3.2026.11.09.07.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 07:20:31 -0800 (PST)
Date: Mon, 9 Nov 2026 16:20:30 +0100
From: Michal Hocko <mhocko@suse.com>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM
 victims
Message-ID: <avHkvtojxFyuH5mb@tiehlicka>
References: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: e6mocahx1dtemrejk7oy8tdrwzb3ifbp
X-Rspamd-Queue-Id: 6C0308000E
X-Rspam-User: 
X-HE-Tag: 1794237634-770911
X-HE-Meta: U2FsdGVkX18UK8u2R7r0yzOL2YgcdpqBlsjZFxMRoulX1FrRN4UhmHBSEodZS8wGYF4nDY2vEjnvZKz3azK7ro0cGmSDNMJi+rt6rUcPrPHd5ocL4pHwigHO7/b7DdDaghKwmY2PFNESbLWDy4VAs3B+rHAxoMX2UeeF2gB8K2MPvlVSRP8OtoPcZUMBOIQnVDugEHTu/6XoAD0wZhiYhLZfhVJIlbrdPUMBBYmMWz3qI4qjv0BaVpNSvlyiqXIvbZYwbOiu2/ydGlF4fvl7L+bhy2sTbRNYZ5Futxxq1r1rfbc9i0cgK7C70gyujBqOMnMhFl0Hw/zaabiOIW46Z8sqGMAOcE5++cKoZT6xogGdu/aKGPPdBpyMXBOO9RU/vCd0Iy+58sy9hshHUbmSRj7V40QLzU6LjmlcC008FlVxb7OoDkyvbBiIr0KrTGT1OWDqZZ+WWKoTzdQJX59Igk2t8HM1TujADMT+rfhN+2YA7GCehOr4VgyWZfd4XgppbbSzz/KaXx5PwuPzt/6jijK62GMpxrah0+gsMYtUNVd81TIYTwBx8bL4zNozUQRnIJ0elHb2pwPHuDkJIu4fhz9ewMpUW/bg958p/JnnaJGsMyiqpbnUjvA4sJCHuAK4kdt10iv93z8HYcZvcRL6hvbx7R3uWbTiIE2+V+1r5yUKMQtoB8gLNeHuB6YE/vvlaX0CETDJgmbaaeWYjEUAp6GT29d6zJxuCPYYJKbxcZLSWkPtK1SHkCxzMtB42YYthfaGlpax8GEqPt7xcc2lrH1Yow7U77uvskF5jg6axC9rbx/Mh/GtBOp6Z0xHtb34Yy6MF9YV5SnV4wCD1ahfZ/YAoaJv9h54Ck/0XADwkD7bt3PHIBIFsX17jHIkdsfKvIoTXh1KHVvkn2cWzm8P+yDUgrXNhBY6LdA+Lald1f5oKd1N9yMt8V01VFDaN99KPas5uD6IvQ/HeT/gnT0
 ervadJap
 8ZEsD6nF83fOPNAYP1FH1+v4BYXq7tYXdEYB2CeXLe9r3835m6BojmqeHSFOobLqna/ASUDXA6GuxZ8/aLsONmQee2KTmRXdkJYdlge1aMJgLtWRs5i4WOpX+tUVtGbcIk0uv8Ti0/qZSAtQOI6WkJidbXMilzZspiskL34FsjaDLXDKZAjttN5CBqMOtrS26+bSA8HWFsIktVZLRSfsJrsBfOsYrqZUtkxM7Z3eIa4xHCVJ0ru3KAg0uMo6PQcz3MFwlu3n5FqQjOuz1qq5x9pwnztDna4K/5/EuH+V5eLsTD7VCSczrzB+6eJEzog1yNlFSPTMsMLugupdYY4lC1yx2yguf2You/eBSA/ZKwnWneUIgs1o6symvZx66TCE3nFltAHZ23/BXMu9tqA+/VVJiYG8jdiAbm8a8nOd6qN+Bobn9Bs4ILpdMm39DF7dqTVCo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun 08-11-26 00:41:37, Chris Down wrote:
> When oom_evaluate_task() comes across a victim we've already killed, it
> backs off until the victim's mm has MMF_OOM_SKIP. This gives the victim
> a chance to free some memory before we kill anything else. However,
> since commit a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup"),
> css_task_iter skips exiting tasks once signal->live reaches zero. That
> happens before exit_mm(), so a single-threaded victim can disappear
> from the memcg scan while it still has all its memory.
> 
> This can kill another process when the first kill would have been
> enough to recover, and we've seen it happen in production. If the
> second victim is in a cgroup with memory.oom.group enabled, the extra
> kill can take down the whole workload.
> 
> In tests I used a 64 MiB memcg with swap disabled. I started a process
> that faults in 44 MiB of anonymous memory, submits a 4 KiB direct AIO
> read to null_blk, and goes to sleep. I set null_blk to take 10 seconds
> to complete the read so the victim would have to wait for it in
> exit_aio(). Two seconds after starting the first process, I started a
> second one that tries to fault in 40 MiB.
> 
> The 40 MiB allocation hits memory.max partway through and triggers an
> OOM kill. The OOM killer picks the first process, which has more
> resident memory. With the read still pending, the victim blocks in
> exit_aio() before it can tear down its address space.
> 
> memory.events showed oom_kill 2 in three runs. In one of them the first
> process hadn't submitted the read yet when it was killed. The slow read
> just makes the window easier to hit.
> 
> The cgroup iterator hides these tasks so that cgroup.procs doesn't
> show processes that waitpid() may already have reaped. That's fine for
> cgroup.procs, but the OOM scan needs to see a victim even after its last
> thread has started exiting. We already have CSS_TASK_ITER_WITH_DEAD
> for sched_ext, so use it for mem_cgroup_scan_tasks() as well.
> 
> With this applied, OOM selection backs off while the first victim still
> has memory to free. The 40 MiB allocation completes and memory.events
> shows oom_kill 1 in three test runs.
> 
> Fixes: a72f73c4dd9b ("cgroup: Don't expose dead tasks in cgroup")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> v2: Give more concrete details in changelog (akpm)
> 
>  mm/memcontrol.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 84f4a8fd4d16..cb7cfae9ce5a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1451,7 +1451,13 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  		struct css_task_iter it;
>  		struct task_struct *task;
>  
> -		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
> +		/*
> +		 * An OOM victim can start exiting well before its mm is
> +		 * torn down. Keep it visible so oom_evaluate_task() can
> +		 * back off while there's still memory to free.
> +		 */
> +		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS |
> +				    CSS_TASK_ITER_WITH_DEAD, &it);
>  		while (!ret && (task = css_task_iter_next(&it))) {
>  			ret = fn(task, arg);
>  			/* Avoid potential softlockup warning */
> 
> base-commit: fa4ad798f6f681031775266044ba1b0cf3c670bd

-- 
Michal Hocko
SUSE Labs

