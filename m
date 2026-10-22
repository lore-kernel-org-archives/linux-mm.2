Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A47A7606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dhnQjrhd
Received: by kanga.kvack.org (Postfix)
	id B68E16B0A1B; Thu, 22 Oct 2026 19:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A716B0A1E; Thu, 22 Oct 2026 19:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09BE6B0A1F; Thu, 22 Oct 2026 19:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7596A6B0A1B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:11:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F416C160349
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:11:38 +0000 (UTC)
X-FDA: 85351811118.15.55EF14B
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 13ACC40004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:11:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dhnQjrhd;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792710697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9FF5OWfzsi4DyrpW60LLUMz1VcIwydXpbxb65LGd/A=;
	b=BK8QLXTy3xlzGkDpoy8k9fzdhyV6S7K6Kb+J2/MSGuSoMlk1t+Ili6D2hdncsBEXil54Ep
	cdc2jAAdnGR2kkKF74Ow48m1SknFn5wB8X9hpBYDLiaeFOlYfCwD1s/VS41AobhTh0PRux
	GkdBjGR2Qn+Az4vsFrYswcLlcJF4oXY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dhnQjrhd;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792710697;
	b=Vq5zSIHk9yp73RrmzLfUhXjjDVNutgVTQe6zhMdS/Q0R18f4Hv3u9/hd01b4SQPxNTXSrU
	uaePdnn3/bPlPtPWVFZQCOyMjFK4rGhvl5SqqVvt5KvBVqD8Hbf9fxSiDKKcAN+qCgOQ13
	0XnWKpu9Ej09tg1zPrGTkFDUSi3IZWs=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc758830601so196787a12.2
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:11:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792710696; cv=none;
        d=google.com; s=arc-20260327;
        b=iVIUTbuof0o5Yi+8ssbO4WLGipQByFwdF5sXzbB51bPaqTOmdWFj1EAXyT8ruwYZj1
         Bq+a2FhSdbFipXuAYRPxWLTKDxhdG5spbbjtoWy61lb78h5pwsRCZWN8bH44LpuP8AFz
         O+LbxQxTlSvzgyL8XIuwgidTbi1yZ8c0/F1MXD72DZA7wsU2RuNsuleT4l5gBLUTiK+S
         gYfTbU5rsNVdXnScCHHa7aXJD/LyqoGXixO7t1pUfkk7iu8Z14+v3gAfnE+BlDIPYVPv
         QAdo1JaIpn8dAHewlOU31wSNCkus1JnOBH0z3t4VILsNkXjRkJDGipvg3L18+hs1Uy6c
         ZiHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=u9FF5OWfzsi4DyrpW60LLUMz1VcIwydXpbxb65LGd/A=;
        fh=yr+fMFpetNY1/3LFmgD2XM0GR6Wd0fszn0eTuZMNqBg=;
        b=JHXhyK80KcRmVzEUV1AOT9gjifalEcxjFmtMRdl0sVcT+quuIg7Pxpw6E6bOuaPngZ
         a8VXd8ZVUGg4goeZpX2korrEgIHFlXWrRJYGWR77J0pEiPdhJxhCAwBT+XiujSZoeCPX
         raH0x3j6qV47k0kZvvIuzPnagRCak08Jsvj1ipKDcNpNCrP8c+2TIVWGbmmnkwPToig/
         bINQ3OEk+prZwVIP5d1ubxQrXMjZkAt0BuMkmC3SoTGK1/F4jZzFhWSg3UgU3lzmMp7M
         15KDkNrpmnDJpGUeIhTqipIyOZ07ctPsxK5lGbckA3WgZQ6HFp0KIqd+l4wMENgcXBxG
         cplw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792710696; x=1793315496; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u9FF5OWfzsi4DyrpW60LLUMz1VcIwydXpbxb65LGd/A=;
        b=dhnQjrhdJb5Clc1TDBybilsFp0/PvzfqIXYK6Q6GZRIWrSCh5bT01MHcmA7dg7Fedo
         03RbxXZZ2DB6Nifi8BBEHn156ia9r9f5+qn/ev2GZ6jE4OivEPEFWO2ii+SPmuZjNR57
         hy4byqj6tP3IJ2mhblNtDLeVaRHAG6UhkRXT+EGfYxebfILrJerXlh2O5KPOfldC6gzG
         Ym230JCfT3OhTcSQF1iwu8odGu+OXlOODbZxjpS4dVmhcuken8oDqgm9pY0Voa3Pt782
         q82MTNWk7F7ZiIsxVz3MM1u02VMo7hPHIlACvjMgE5ZXRMb8Frjpo/e8R88UiyGgaFJK
         pq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792710696; x=1793315496;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u9FF5OWfzsi4DyrpW60LLUMz1VcIwydXpbxb65LGd/A=;
        b=zNcAukWk49IpGOSUhYdeyGTALxvzt6Q3cGs9j+NL/gdx/YNkEDMRsFBqKHtAZndRRL
         VkZFeizaVDlXT2OXvJUqv/bo9zXOpZ1ghYgDodLZhh2M5cT8nK1l7wfno0cm3GWduyya
         leJzYLe7656mEql9CnYkizZFoZt/K5+XZx0GlKjCaSkScUSzW2Jgeu5U5JY8Nm51oMUF
         09zabVxUxowsVep0nQfLBJpgoDejhpdjXROfN6+zeQ/1DME+zb88Elaz+IB+Jz/l3B9V
         ZebWI5i4qto3eKHvk5hl9qJiOrTMpDPk7hB49qfn2nwDmqnECT77tyWrJmcTTLxmY+1o
         pwbg==
X-Forwarded-Encrypted: i=1; AKwUvByd+sTFEf/cl5Qn2M6b6lfPQXt83u2xmKpW8TYphtn16lEGzJosmRZAbLYXhndL+2orf0T2woWVlA==@kvack.org
X-Gm-Message-State: AFq9FYILK9tPBgAmUdRBQI6gVQigODkTVJGNQ9mgwMSQhlrNkCbju6Qy
	R8xFVQXdjgdx/aW8I0nNXpnH/NbLvs6xq2XWfMrqKkNDLZfNJkih14jbsas+XyX5j9KoTyB6ILI
	KMZHbFjU0U6TdJRqYAJlRx3lmk09nVQ4=
X-Gm-Gg: AYBFou3J8xxweS0I8dZoiut5eDYhXeSc3++4+zWX7Il5fs9q3PGzflj7dZ3Y7kPyniD
	re2x8Ury0Hvsf/E0yeSzDXzQiKDFWPfEEYCh9wHSGClqaQwN2VqtRlUaBqcUu1ieeeGRIA7eRH6
	lMWmjVdDv/mV3+oGhZGB60K9+agx36blzVSdFgZ7ITrnIVt1WAqj4WACfLngS8NMNPYSYq/uBxJ
	IPjlJx8c6+EjlYbZ0p0zba8pgHkalyXRDdnukRg0f4npXIqv2E6myRRI3jRPnmi8D1z2DUJFQhA
	ka0VGkCZHKS/OVkA1LMh2EVb925YsYmVxRjaQA8l0EqtWjIEavErmcUaQiRQmVrBlrseWyzSxGg
	X7QvnPV++RGOHJODJVujYgD4h0FUke8AP41XPBcSrrMLciT1zeuBny+a3u7OJqLSm8rKv8c4Yoi
	dMFyvZMhaUlOn8CqHA7NPj2IjnpB2HLT7NHQ==
X-Received: by 2002:a17:90b:3fcc:b0:3ac:7377:fd48 with SMTP id
 98e67ed59e1d1-3adce14f242mr304117a91.56.1792710695710; Thu, 22 Oct 2026
 16:11:35 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com> <20261022015712.1297331-6-alexei.starovoitov@gmail.com>
In-Reply-To: <20261022015712.1297331-6-alexei.starovoitov@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 22 Oct 2026 16:11:20 -0700
X-Gm-Features: AclHuK8s6DwZCvueetumGiOa-ygE3J-xVZ2OzdSVggL1R0XHASR0IqYhKSbBJKQ
Message-ID: <CAEf4BzYs_Kis9ghhwnM3qWSCWRBwEtaZy5Xk+CJjYH3q0E9bNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/9] uprobes: Don't sleep on mmap_lock under dup_mmap_sem
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, peterz@infradead.org, 
	mhiramat@kernel.org, jolsa@kernel.org, akpm@linux-foundation.org, 
	liam@infradead.org, ljs@kernel.org, surenb@google.com, david@kernel.org, 
	vbabka@kernel.org, jannh@google.com, hughd@google.com, kees@kernel.org, 
	mingo@redhat.com, tglx@kernel.org, x86@kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 13ACC40004
X-Stat-Signature: rohd5f4piqapie9mhei4j4u9o7nwuwii
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792710696-200380
X-HE-Meta: U2FsdGVkX1+MyFdEs6ZffFFB1NR1GJcxWV9KLi+BrxYRMQHk7ehVhLcy8CjO8W2XQ4k4iX4v54NdiwOtX669Xljy91K34WU0WAdtsySR7zqiDWrmihYzpueNcmhwhznTNa/31BmGOPOkFNP+or9TRNl36708YA7BQ+AmSkHfoL701a4hc6RHCFVVwXmuD3FjCgzaX+7ntoIlW0cFvRjlNnISdh2YBmamDbjzy4qLs+sSLReL3hTnU0XZmJlFsZkQhUl9O+sP0Nqi4o6IKKF6KH3UnmP+LccwEvmWH+cDYDc90YFdOur4PleFl+/08WqMs0DOIGQmQbrWOq1b43SynYOOrdDps+T+LliYHDMG/knJRcj6rs9w26Av0Y3mT9rDuvw1gyGaxANPERsDdtViYsUnbHnq8Or67Dp9DtBbkCX229FSf4nwTAPqrtc2HYCAJ21Q2wkSCkCYyyVs8yxlDil038mp4pMUKs3IZ7shIBmUZacBirYthoOB6CLl5+DAyUWo7rfWXFW64fVr8kLPFdOUYQF9nvL0mzT0/TSQBUH8YlGUdQi2cGgaU/poWn+0wyABhcb3iz0M7DuRJZmTu0ET1dbOGGPLOyJ7/ACboT75ZPHawUeqdvZIXTANcHO6+/tpGGmfKKC0AVuON6vUgJ9i/wuGtaG/Qx6NtafHKG8cIRMaK+1ipggplOGNio0K5L2aXGzMXKnkAzNy76/u4F/aFT3JCGyN1gVdJQ//AzexBVkW8IGrk04cdnmzKlk3oH/U2iUlSXwKcInF2fu+eWDtrr7sWqunNN/9qbaICHIT6dTLTOUUthCqxrGa2D2qb18htZmSaNIpbzf2+7fkNvP83p7dzgcf61EjKSqZ6neR2uEFKqpmb2nrKGQFTriH+iylsg/X8sOv10zH32OdJqD9SyUPFHtHCRPqygxPIOso0SFOyqo9fQhM/qeyDosbOTJBb/TEuiDA+WoRWNR
 aTsLfjIC
 32q8yxRD8IgzCBIigJEndCVwSbhFgyRQ8GP6WiDS5SmhX96fLmefrGMIXrkdgsxCGvaLMxihVhHDxnvfEMNUyM9soaE9gTWr3ZLZSECHiOPHGHUbfxP10mqGe28s1jwEH9w7fyqQB8auE5srNtu89LUNlrCCrrGehhr7UwFQCwQut+/5WwE/53G+DtPMbeIpoeagRkCQGIRwWCO6lmuDerVIYm22TPFjpn9VUveY/smA5kcs/llByjMfdF/cvj+gSQPEvpIJGL03dPLAsEb/zxuKwwu7j+b5yICOBNAV4VwLAYhLhpWWSxIJh3698kQp4IO5ACnl8n9WmtiOljkMD0vpTtUb4kfsa36WSktGLfe/jeI9pBaglLWsAv5XWIkh71lG47S01A/8c4tWEo0bw5qhxByQX+j+wVw7cbXdJRAZyCB1jUXnkxCXYDIFdFRWwc3c8aJywdofh/0BZC/rUiod28gc3U9W1qQwrDvnftiXOX4mufBXUZERB7hj25tWUltJySF294nP77d45EjQ3BBiCW+e4l7/CaTZCqCRExgozpHnzWuEAUKvPzus9YcnGgkh9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 6:57=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> register_for_each_vma() takes dup_mmap_sem for writing, collects mms that
> map the file and takes mmap_lock of every mm. fork() takes dup_mmap_sem f=
or
> reading. When mmap_lock of one mm is busy every fork() in the system wait=
s
> for it:
>
>   A:       mmap(MAP_POPULATE) -> mmap_read_lock(A)
>   tracer:  percpu_down_write(&dup_mmap_sem), mmap_write_lock(A) sleeps
>   others:  fork() -> percpu_down_read(&dup_mmap_sem) sleeps
>
> Only trylock mmap_lock under dup_mmap_sem. Leave mms with busy mmap_lock =
in
> the list, drop dup_mmap_sem and then wait for them.
>
> dup_mmap_sem makes sure that mm doesn't fork between build_map_info() and
> install_breakpoint() or remove_breakpoint(). Otherwise the child misses
> the breakpoint, or inherits the breakpoint of uprobe that is gone and get=
s
> SIGTRAP. Now mm in the list can fork. dup_mmap() holds mmap_lock of
> the parent, so uprobe_dup_mmap() does what the walk is going to do to thi=
s
> mm before vmas are copied. The walk sees info->done and skips it.
>
> The error in uprobe_dup_mmap() is the error of the walk, unless fork() is
> being killed. Such fork() fails in copy_process() and there is no child, =
so
> leave mm to the walk. With ref_ctr_offset the walk can update the counter
> twice in this case.
>

fwiw, none of the above blurb was really helpful, I had to read code
to actually get the high level idea of the patch. If anything, commit
message would be more helpful if it had less technicaly precise
description of what is being done, but rather a more high-level idea
to get the reviewer started. I don't know how much persuasion you'd
need to make your AI do this, but I think it would be helpful going
forward, especially for some dense stuff like this uprobe
registration/unregistration piece.

But as for the fix itself, it feels like the real problem is global
dup_mmap_sem lock, no? What if instead of one fancy (per-cpu) global
rwsem, we just have a per-mm rwsem. register_for_each_vma() will take
each mm's uprobe dup per-mm rwsem first, and keep it for the duration
of uprobe registration. In dup_mm() we only ever take mm-specific
rwsem, while register_for_each_vma() does a more heavy multiple lock
taking. But other than that we don't have a global uprobe walk list,
we don't have to handle registration/unregistration in two places,
etc.

I might be missing some remaining races, but I thought I'll propose
this and see if this idea has legs?

> dup_mmap_sem protects the list of walks. mm in the list is kept by
> mm_count. The walk takes mm_users only for the visit, so the process that
> exits meanwhile frees its memory.
>
> Busy mms are visited last. The tracer that is killed while it waits for o=
ne
> of them has installed the breakpoint in all other mms and cannot remove i=
t.
> "uprobes: Don't leak the breakpoints if the unregistering task is killed"
> fixes that.
>
> Process A loops over mmap(4G, MAP_POPULATE) and munmap(). A and 10 idle
> processes map the file. Process B calls fork() in a loop. 32 cpu VM.
> Median (max) of 15-25 runs, msec:
>
>                          the longest fork() in B    attach
>                          before      after          before  after
>  uprobe_multi, 1 uprobe  197 (209)   0.33 (0.70)       210    233
>  uprobe_multi, 4 uprobes 421 (429)   0.38 (0.60)      1467   1532
>  perf_event, 4 uprobes   422 (439)   0.43 (0.59)      3135   3289
>
> During detach: 264-423 -> 0.35-0.47. Attach and detach still wait for
> mmap_lock of A. B doesn't.
>
> The tracer pays when traced processes fork all the time. mm that forks
> holds its mmap_lock, so the walk sleeps on many mms in turn. Fork storms =
of
> 1200, 2000 and 5000 processes, 6 cpu VM, msec, without and with the serie=
s:
>
>  enable uprobe event    105 -> 205   201 -> 481   207 -> 784
>  disable uprobe event   225 -> 294   354 -> 579   407 -> 893
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/events/uprobes.c | 178 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 143 insertions(+), 35 deletions(-)
>
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 6792004be6fa..a9274016c55d 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1192,8 +1192,29 @@ struct map_info {
>         struct map_info *next;
>         struct mm_struct *mm;
>         unsigned long vaddr;
> +       bool done;
>  };
>
> +/*
> + * Every fork() waits for dup_mmap_sem, so register_for_each_vma() must =
not
> + * sleep on mmap_lock while it holds dup_mmap_sem. It leaves mms with bu=
sy
> + * mmap_lock in ->busy, drops dup_mmap_sem, and only then waits for them=
.
> + *
> + * Such mm can fork before its turn comes. dup_mmap() holds its mmap_loc=
k, so
> + * uprobe_dup_mmap() does what the walk is going to do to this mm, and
> + * the child has the same breakpoints as the child of mm that wasn't bus=
y.
> + */
> +struct uprobe_walk {
> +       struct list_head list;
> +       struct uprobe *uprobe;
> +       struct uprobe_consumer *new;
> +       struct map_info *busy;
> +       int err;
> +};
> +
> +/* dup_mmap_sem protects the list and ->busy of every walk in it */
> +static LIST_HEAD(uprobe_walks);
> +
>  static inline struct map_info *free_map_info(struct map_info *info)
>  {
>         struct map_info *next =3D info->next;
> @@ -1242,6 +1263,7 @@ build_map_info(struct address_space *mapping, loff_=
t offset, bool is_register)
>
>                 info->mm =3D vma->vm_mm;
>                 info->vaddr =3D offset_to_vaddr(vma, offset);
> +               info->done =3D false;
>         }
>         i_mmap_unlock_read(mapping);
>
> @@ -1271,26 +1293,79 @@ build_map_info(struct address_space *mapping, lof=
f_t offset, bool is_register)
>         return curr;
>  }
>
> -static int
> -register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new=
)
> +/*
> + * mmap_lock of info->mm is held for writing. info->done is set under it=
.
> + * The walk also tests it without mmap_lock, to skip mm.
> + */
> +static void register_one_mm(struct uprobe_walk *walk, struct map_info *i=
nfo,
> +                           bool in_fork)
>  {
> +       struct uprobe_consumer *new =3D walk->new;
> +       struct uprobe *uprobe =3D walk->uprobe;
> +       struct mm_struct *mm =3D info->mm;
> +       struct vm_area_struct *vma;
>         bool is_register =3D !!new;
> -       struct map_info *info;
>         int err =3D 0;
>
> +       if (info->done)
> +               return;
> +
> +       if (is_register && READ_ONCE(walk->err))
> +               goto done;
> +
> +       if (check_stable_address_space(mm))
> +               goto done;
> +
> +       vma =3D find_vma(mm, info->vaddr);
> +       if (!vma || !valid_vma(vma, is_register) ||
> +           file_inode(vma->vm_file) !=3D uprobe->inode)
> +               goto done;
> +
> +       if (vma->vm_start > info->vaddr ||
> +           vaddr_to_offset(vma, info->vaddr) !=3D uprobe->offset)
> +               goto done;
> +
> +       if (is_register) {
> +               /* consult only the "caller", new consumer. */
> +               if (consumer_filter(new, mm))
> +                       err =3D install_breakpoint(uprobe, vma, info->vad=
dr);
> +       } else if (mm_flags_test(MMF_HAS_UPROBES, mm)) {
> +               if (!filter_chain(uprobe, mm))
> +                       err =3D remove_breakpoint(uprobe, vma, info->vadd=
r);
> +       }
> +
> +       if (err) {
> +               /*
> +                * fork() was killed meanwhile. This is not the error of
> +                * the walk. See uprobe_dup_mmap().
> +                */
> +               if (in_fork && fatal_signal_pending(current))
> +                       return;
> +               WRITE_ONCE(walk->err, err);
> +       }
> + done:
> +       WRITE_ONCE(info->done, true);
> +}
> +
> +static int
> +register_for_each_vma(struct uprobe *uprobe, struct uprobe_consumer *new=
)
> +{
> +       struct uprobe_walk walk =3D { .uprobe =3D uprobe, .new =3D new };
> +       struct map_info *info, *next;
> +
>         percpu_down_write(&dup_mmap_sem);
> -       info =3D build_map_info(uprobe->inode->i_mapping,
> -                                       uprobe->offset, is_register);
> +       info =3D build_map_info(uprobe->inode->i_mapping, uprobe->offset,=
 !!new);
>         if (IS_ERR(info)) {
> -               err =3D PTR_ERR(info);
> -               goto out;
> +               percpu_up_write(&dup_mmap_sem);
> +               return PTR_ERR(info);
>         }
>
> -       while (info) {
> +       for (; info; info =3D next) {
>                 struct mm_struct *mm =3D info->mm;
> -               struct vm_area_struct *vma;
>
> -               if (err && is_register)
> +               next =3D info->next;
> +               /* If install failed the caller is going to undo it */
> +               if (new && walk.err)
>                         goto free;
>                 /*
>                  * We take mmap_lock for writing to avoid the race with
> @@ -1299,38 +1374,56 @@ register_for_each_vma(struct uprobe *uprobe, stru=
ct uprobe_consumer *new)
>                  * is_trap_at_addr() true right after find_uprobe_rcu()
>                  * returns NULL in find_active_uprobe_rcu().
>                  */
> -               mmap_write_lock(mm);
> -               if (check_stable_address_space(mm))
> -                       goto unlock;
> -
> -               vma =3D find_vma(mm, info->vaddr);
> -               if (!vma || !valid_vma(vma, is_register) ||
> -                   file_inode(vma->vm_file) !=3D uprobe->inode)
> -                       goto unlock;
> -
> -               if (vma->vm_start > info->vaddr ||
> -                   vaddr_to_offset(vma, info->vaddr) !=3D uprobe->offset=
)
> -                       goto unlock;
> -
> -               if (is_register) {
> -                       /* consult only the "caller", new consumer. */
> -                       if (consumer_filter(new, mm))
> -                               err =3D install_breakpoint(uprobe, vma, i=
nfo->vaddr);
> -               } else if (mm_flags_test(MMF_HAS_UPROBES, mm)) {
> -                       if (!filter_chain(uprobe, mm))
> -                               err |=3D remove_breakpoint(uprobe, vma, i=
nfo->vaddr);
> +               if (!mmap_write_trylock(mm)) {
> +                       /*
> +                        * uprobe_dup_mmap() compares info->mm until list=
_del().
> +                        * Keep mm_struct, but not the memory of the proc=
ess.
> +                        */
> +                       mmgrab(mm);
> +                       mmput_async(mm);
> +                       info->next =3D walk.busy;
> +                       walk.busy =3D info;
> +                       continue;
>                 }
> -
> - unlock:
> +               register_one_mm(&walk, info, false);
>                 mmap_write_unlock(mm);
>   free:
>                 /* exit_mmap() of the last user must not run under dup_mm=
ap_sem */
>                 mmput_async(mm);
> -               info =3D free_map_info(info);
> +               kfree(info);
>         }
> - out:
> +
> +       if (!walk.busy) {
> +               percpu_up_write(&dup_mmap_sem);
> +               return walk.err;
> +       }
> +
> +       list_add(&walk.list, &uprobe_walks);
>         percpu_up_write(&dup_mmap_sem);
> -       return err;
> +
> +       for (info =3D walk.busy; info; info =3D info->next) {
> +               struct mm_struct *mm =3D info->mm;
> +
> +               /* Don't wait for mm if its fork() did it or if install f=
ailed */
> +               if (READ_ONCE(info->done) || (new && READ_ONCE(walk.err))=
)
> +                       continue;
> +               /* All users are gone, like in build_map_info() */
> +               if (!mmget_not_zero(mm))
> +                       continue;
> +               mmap_write_lock(mm);
> +               register_one_mm(&walk, info, false);
> +               mmap_write_unlock(mm);
> +               mmput(mm);
> +       }
> +
> +       percpu_down_write(&dup_mmap_sem);
> +       list_del(&walk.list);
> +       percpu_up_write(&dup_mmap_sem);
> +
> +       for (info =3D walk.busy; info; info =3D free_map_info(info))
> +               mmdrop(info->mm);
> +
> +       return walk.err;
>  }
>
>  /**
> @@ -1841,6 +1934,21 @@ void uprobe_end_dup_mmap(void)
>
>  void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm)
>  {
> +       struct uprobe_walk *walk;
> +       struct map_info *info;
> +
> +       list_for_each_entry(walk, &uprobe_walks, list) {
> +               /*
> +                * fork() that is being killed fails in copy_process().
> +                * There will be no child. Leave oldmm to the walk.
> +                */
> +               if (fatal_signal_pending(current))
> +                       break;
> +               for (info =3D walk->busy; info; info =3D info->next)
> +                       if (info->mm =3D=3D oldmm)
> +                               register_one_mm(walk, info, true);
> +       }
> +
>         if (mm_flags_test(MMF_HAS_UPROBES, oldmm)) {
>                 mm_flags_set(MMF_HAS_UPROBES, newmm);
>                 /* unconditionally, dup_mmap() skips VM_DONTCOPY vmas */
> --
> 2.55.0
>

