Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BF6606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=QwrQFl/i
Received: by kanga.kvack.org (Postfix)
	id 106FF6B00EF; Thu, 12 Nov 2026 12:12:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7356B05B0; Thu, 12 Nov 2026 12:12:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7DF6B05B3; Thu, 12 Nov 2026 12:11:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C47D66B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:11:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67C2C1C3F0A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:11:59 +0000 (UTC)
X-FDA: 85427109558.03.15FB182
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F8B74000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:11:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="QwrQFl/i";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794503517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3KCRPd7UwqaiMFRIx4N7MG3QRVArn5qzACfVK+4/t80=;
	b=KVOxvSyie76NfJLYQmyRs+BRbvKoENWyyrke4ZAm1rFtvFSEXXYrn4kj6gOpT+afFTZWva
	cv7tv3ibh9kXbdIwD+Z6Wnlsk2zA6netdfn1DqdLX3L9vnDr1u7TyrhPEXhBAGgpzUP0tJ
	ksHq9RjMKw+A/LNPx+4Aj3kOM1Pbvog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794503517;
	b=InXtGIUJs80TaKIXRkg0nvadf5+MvoGl7maXfkQZUUuM7a2Ilv2a/WFGbJBkpSHzxomXk9
	IYRO3BOCQmSfXstuF+KwXVQf7WMuOALqUwe3eyDz1FTcy422eGX557yEbaZYGecYfDy3Df
	fewTYJndp1mCKopp3FN7lZinb+97zW4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="QwrQFl/i";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b309147589so1110857b3.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:11:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794503516; x=1795108316; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3KCRPd7UwqaiMFRIx4N7MG3QRVArn5qzACfVK+4/t80=;
        b=QwrQFl/iOuXHTTw/uSJerm3wiIFUZbJhzBiCosYUEc8t9ZmSCFEGB1UU2RcFcKAIQU
         /Ww1ABgH70TOABxc1FJFd4xaUTkBHekBG4JG9sJlsuHHywc9el4OlVru2yMl4CVl55Bi
         x9Fh1nb52jJMov81rJbl3yva4gOx0d3X2rmSVkqeeo8Kf2Ml21k0qpcOzNdb/f6YJ0pI
         y4ygydbmIEqn4DMVLYnXs1K3uwWTXoky0bNXk87iJsO4EzisrIxAAIdrHnLk1zS4FXp6
         pna2G1fGXTjfgqTca31n9WnoLkF1QxPNo5s6lJluJrvhNc9B3uuEEePU+ImQznSsn2CC
         RlEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794503516; x=1795108316;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3KCRPd7UwqaiMFRIx4N7MG3QRVArn5qzACfVK+4/t80=;
        b=KquZkJbLdXdCk+OkrTwgPPiOByvM6VjmowEhi85Cia7zuAxYTaGzb/5/rMnyqSYOkV
         /AdE6Zz4FSlW+2hdDIPwm2QxP18UMPpGlYoI47D1fE8llc0pjb6o7VzYb5YSbrUoN4Km
         EEwbqpMk/4N3mFWL3ulDVoQM867hVpaGThoz+aj6ldCQmoy1ypsYebJF3cz8A2k3vbk2
         b3GD7HyVnZzVqkO388GO2QN490f9I/rS/zT/OtHPGY8Xf4ki3DTLClKETwgOAC3KL9vh
         5Kuz6PmjQ9+glgoRYjJYGQmKVpFXOBXUB/popvmEr2nBiDbOAGh46d24ejUigucQS+s2
         sa1A==
X-Forwarded-Encrypted: i=1; AL+hErG186jKbIKPvXHJPPOWHDQEds7b6vzUw8bAjcZhalUFbzwCzF0PcSlaqEmrKODbk2Tltz4zx0EKSA==@kvack.org
X-Gm-Message-State: APuU4Z8w7nQZEukT+Z15kV3L4oMn7gDxoFYiHkkPb5rhSbnekNTRMa6N
	fCvookxwH2xHnmR0NXsQvKun4Hvi6Gzen6W5I7etMYgR5th1cyrFRuFL7PNdPVB5oAUfc/pS1nV
	Lt8qcgXk=
X-Gm-Gg: AYBFou3yJpJoYVffKb1pLpyEfz2UND2fkfeDzCOHzOJf8uu4nyqMykdKfC9mWm0/eEI
	dJAKXiAPKyMZxyutBCTijgd/BLxCZWSJkJvlHt2Nx0eKzA1aEzJLu4O1wLIJOTBss409vZ4Jm2c
	vgZPB99Z7JimNpuE+Xj2rdMjM9oAnCwor2weFBmFsIjUAhD8nFdPcuaDF/7yDz0+rvPgIRO6UpA
	RDrUwrkS2c+Ap45mCKqcIZnl5oTpEZU4BO/WWWiBImKzZj/Jb/lG3aelr2lW7mT+uKHuu1IBObZ
	iKbePrYZNeeZy7xio/QkapuGEL7SUG4LSV/aCyHDcdaxLgBDW6BLfftVgL/8RYTwZabCbuD3Ixi
	U+sdwQ2oBHxfkVfTWA4tUnozr08S/Ghb+Vgvfw5HGXYzsUDW2m/3xHDy3p+Romtx9XOyfRFLXTN
	3gv7n0KO0Kj6CRAYTzZ3dRpqo3dlC/pSogXxwqzaXvHFknbjzfFHQc843cIQJvH+UtJs1NHa4iL
	v6VVBdVvfM2cl7SxDz+1WyuWtq02ebqWrozTmYMgepyTRbzY5jSDSZsKUWN9ZrIa8NuFUWVKSFw
	0xd37cMqRZw8MBlJ1ErwmFMvHjO7
X-Received: by 2002:a05:690c:e1d2:20b0:882:b4b2:c49 with SMTP id 00721157ae682-8b4aa23f086mr1270387b3.18.1794503516202;
        Thu, 12 Nov 2026 09:11:56 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa9fae24sm252827b3.41.2026.11.12.09.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:11:50 -0800 (PST)
Date: Thu, 12 Nov 2026 12:11:47 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: memcontrol: Don't lose track of exiting OOM
 victims
Message-ID: <avXzU0coRUkBdPWC@cmpxchg.org>
References: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avA1wXhTMs9eY2NF@chrisdown.name>
X-Stat-Signature: e68oufuqqpwdy7w8qpe8mpiy9djrwstq
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F8B74000A
X-HE-Tag: 1794503517-665427
X-HE-Meta: U2FsdGVkX18tuHILviWEmoS2MTga1Dk9Fyzi7TTbnqkLcVnX0NYAieT0I/BKUkPIeMJVvU8JKNvtFTSmHmId/0xUp4VnfTgyF7DShysjMq1vMRShgwr7TMApkxpfR1dXxlBeFYlR6UsCdNIgc/Qs6N9zk4MWgSrnSNQJvLAaIgXzWnmxiMy4OVBqq5Aj3fQ4JZYNRP428bFwqS2ea9L6r1sr7ekspL9wdmoQMecy0VM+hFLkeAzo9JFuJJJPdn+Jv++puQ7D+88gWzFEuRxIYXBWotn7IF3Evk9N/ag1GYzSk0HzvZ3Lnlf/TVHhqvXUCpGGfwpMyNArmDDqQWx672YYK2Agm/E3/e7u/LkHkg6PIRAnEHpj0s59gz2JMp0M6dRATk2eZsJpEULbwk7UevhihRREedfESTcCvp4BOJp1fSRkjMRuU3dq/mHyuNfo2FtPhkNDcEB2IkYV3SG0rS7lu+29Xb7l3XbYfvyBNJV4XWHMAiipfTM08E0mNS/lhZHV06by0woIJoEysQOQ7kcV0wNScISDHSWI+LzhR/LDJL156dnRCNthL/k0N5ey2JSAkFD6Ia6+E0av2FLGpQpDdu8USmHkdsNE5Rlkpo24STDJu2P2qpm8xLCogMKZRkhorKriF2kQk4/LNgQVr+N11b+qkIhgb/zR4wT7PEissPwKi2mEWNXrnFaFiLosIulilMG2y1vNGQMvxFGri/jW6Mb7w5mRy2tPsgxRmNawtPNS369HWEYTUEMTyiPBrqkT8xL20yN8pZd3kKPIIUmC2qr/lHDJjEfqgkffnWIqmPH4E4Vge2Gv7lFhFvDX6hGoRtr4UGNnpvLx4tuHmoYX2e7uOj5kk1POm/ugECWKII951Ekklfn3geiwMIjSIWuUXrcM8tAZKC+h0RGQJgGzKy/Jr+1gtqw6g3iH5bFmMTxpzbEH97zMse152NY/g+xCzBQDJB4bOY+UWlm
 8Np8q7qL
 kYamnKnHDMIwmPwQpoTIjUrdC4prpEKrRxCxbfRpyBC7N42FtYyd3E7uScm2CBlgpAiyLdUL2Pg5OvRprhr1rJ5TyPCNrDnj4f7JMWOvvG4DRrjZfuJvHrjZ4Gie4nOSofgzAi+03qzvY92eYlWvdM+UFq+TTwDf8Vr7d3qf1u/SU8cp9LxJKiA+lmYnf6ZKi1cSkKVl23x3/zx7JoyKr8moobqM/NB/T4ALOl22FfDTD3H/pTS46njXCQQgoFcH+IVi/HaPGfPzqFIKcTlE+Gb8rENu2raVPft2WSOKMdZII15N8J0yIRliAQvlLXtNMcgkPgrWY+d59om/BICbQ3yQjywIwWeFqy5w+oo2D5wjRy55O3tgN42r5IBmpwM7NjSQG2LnRZjj9Rr92NLB21IurHvULsgF5BKZP/D3Bo+Tl4l93VCqH7xq7jT9In1Fbr522AjKj9TkVyVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 12:41:37AM -0800, Chris Down wrote:
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

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

