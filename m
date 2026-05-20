Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769ECCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 19:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B26B6B0005; Wed, 20 May 2026 15:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964356B0088; Wed, 20 May 2026 15:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8519F6B008A; Wed, 20 May 2026 15:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73F3B6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09A1AC1ABB
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:22:00 +0000 (UTC)
X-FDA: 84788768400.08.CA52307
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B256A000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:21:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ePXFC9Zx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779304918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=07btqzkqRIEqwSF0P3Vs3bCxau/VDoFNLaTjIo9tyus=;
	b=2ArMDbeTUGMlwOInfHujMbUrY8Ym4NqrcbUbKewvN2JEFQi0IwDsdlvBlOGXlUA4jPnyGe
	oQArLjK4O03kaF3xo9bMQ8z+br+M7grlpBbv2nkpksu59KDPH5NejjjrKQ27HKWNm1++Y+
	Wxqsq/G0R7xkZRVRKXVUD20N/6P/1EE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779304918; a=rsa-sha256;
	cv=pass;
	b=1W/v7T8piI0PNOBOYEG1nrz0f4pX9inh0h+BiFZiEHwlmFvAUn5AMhW/w2/NSi44N5G0BO
	qjcWYvQwPfr5Q4eJW0ZwXO+idvnGF1He2wPRB4lymNAzeXpL5Ctf1amtP3DsjOsYMQjx/Z
	WWs6Ivk3CEtma9LQUrICWhoe8fzHy8E=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ePXFC9Zx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-671f1a0d0c5so72a12.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 12:21:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779304916; cv=none;
        d=google.com; s=arc-20240605;
        b=DWjjbl8Gse1UwyD6KCaZJkqlIov7h2IGkgEM+Yttev06wHf4FHicGB33F5nleXdcSz
         24XQyt6AexdM7BnG42HVGlDBebJdjnpA3H95biX1onnJ0Ov7R+vqBujIKp7jI0iZpSoY
         gPIsBDG9nQw3KKUXqeG2VbTI28VYHkxW1zM0udKQQ+AVW2Q8ZmRbR1knThvdt+mXSr/l
         2QOGF+PfJX14CIYpP6RA2nSbeFuL7V2AQsQueP3mGjxSnfK0X1uok3jacbMEjZYPl7UI
         t6TtfgsvqnxP2oVvNtTFM3lrQ698SS78lM7nxe4iZwBptdKFRwwCL3MLYfxWDkFDcKt3
         aqwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=07btqzkqRIEqwSF0P3Vs3bCxau/VDoFNLaTjIo9tyus=;
        fh=Cm7qOFj/QxxO7R6wWC9uDEryAUGCVIyXN3AB25+D2XE=;
        b=NlD5mFsl78k/kmFuLtmlMabq1Xz85B4RMK2skB1hop1+Tm64kZJVz20Wa1/Qi0pdcm
         gO9YKnNMfM/pJ3BYyKNsukmRn3InsA26N25ComN55Egxo8yYtiCG5lub4fbeIrn0SAdx
         Saw6r/0VCj8WUjEHWzusuB35sLuwraHADbiCS49kBZOacQQUXYbOJcmj4HtL8jRIbydt
         ZwKntP+Y4MO08L+JHlsAJ6UFoJoLB0lAGkbl8cRqeEfnWsQM5CGQpTlOh95KLPWLc+F/
         69wqTwlmzoEqpy1+1Sgu7CNOr7nRXB8vCNSUUvPQFD1HmEWqQK2p7mqr4y2Obbj3J4V0
         nayA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779304916; x=1779909716; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=07btqzkqRIEqwSF0P3Vs3bCxau/VDoFNLaTjIo9tyus=;
        b=ePXFC9ZxeBz7RFgdDOszbbu1UxGifJCrDCgGrl6ztxEMJdwcnpS8JcHRDLXO76jKOm
         6j6rFjOWSkyQ536X8CT4LRZlIUBpoIL3f0OR+77lLBNfPrUXouPy6MD6BvcQ4K2aIcKD
         BGrNenaX4S0Q80xgmRirAwuxVJ5wHsemYRnWjYjD77hGFz3QuOxIIgM1Xro1z/a8fY79
         Ua2/DNd4cfUqyZdC3CPc2g/nozHrXZ48KndWlNVE+Cb7hTkfnNMecdfuya9RXZQbxDcE
         lumVV6g9DouadR3mMyIvHaRH8JR14zkzDZV2SJZoWs5AV3Pkqmt/Jhq+mm6Y9bZTWjDu
         a1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779304916; x=1779909716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=07btqzkqRIEqwSF0P3Vs3bCxau/VDoFNLaTjIo9tyus=;
        b=JFpCQDc80/sGVlnjuc5tVT1WsWHDNvwzRSIMaUyqe0vm+Jftr+zHlQ3f8cINLlV9wS
         gkgSH3K/y3nMu+qaYNUStET5rGtmhgoy8SNjgpHFBpgKusgFIBwyRmNVmkfVS5JqOFCV
         Crfb6IDatwZAnkvXaEgyXl7PaKTh6726u6iSfiM11IDAYHVgitj5Ukg04crIIOX/HPTm
         wgU900mnHAzOcQWj9BlExNdTJk9L33Lp/tokPsSLltIqzOhUjmxshBz38frr7Fnrudk4
         1MnUGF+xGtD3YaM/WhLyW1PEHJ7FcSt799ae7SKkGZWwuS2PFiTv0UDe5VgUEM9qhjIH
         P/lA==
X-Forwarded-Encrypted: i=1; AFNElJ/NJ4vQK3t2ksmAyZp76R6BnuvOJ5EGkcwM2VY+D4vsfikBkQoG/D3OO7YZ1qSXYm15dZEtl6Un0A==@kvack.org
X-Gm-Message-State: AOJu0Yw5enB9wtgs/trsinbI/Xh1PNeg3CWha19B8RqLlgIAjX+qmt9G
	mrw9PwWkOONqPfzDHKfPv3XfKV9YI39bQpG+HjsKlsmS9RV1GK3DcMyq/bFC65YIY32vaHxGo8U
	NLPSteOVq+19qqt/R2iAqz6WiNP2p7DxMtC/wFzaA
X-Gm-Gg: Acq92OFfPjRFS6B0hRkp4cGnZfe79k20X0dmVIZkHMzHHcJ2lZEbbgWsndrrDP644fy
	OmJNxXFNIkyThZHf2YiSs9HsLOEhvesOIMez19h4cfKT6pos2KQ78ij/RBl66gUfTJ2RcMMTwJ/
	qKS/2gxaxlrMs6SxBl49NibN0aemn/BestCsdAxmyKUm4oDlV6pTNR3k1emqgVsTEcbOOBibzWr
	7rAICSmBpTXaXJEGkC5BYP01eLs1JBwGi3dqD+tQxTKHDaWP6XRCklU8hblixVBpUAB672ubW6X
	moOtP+J8Kr/ybiOPzxZrBQFf5WwBzlsO+wVNrvsWdcZ0FfeQ
X-Received: by 2002:aa7:c6d0:0:b0:687:ada:817c with SMTP id
 4fb4d7f45d1cf-68806457f1amr7656a12.9.1779304915857; Wed, 20 May 2026 12:21:55
 -0700 (PDT)
MIME-Version: 1.0
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org> <20260520-work-task_exec_state-v2-4-9ea88ceb09e6@kernel.org>
In-Reply-To: <20260520-work-task_exec_state-v2-4-9ea88ceb09e6@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 20 May 2026 21:21:19 +0200
X-Gm-Features: AVHnY4JqLbKoIDFM-ZHDnEa_NdOlZp8dpOZAWdbJwt_kHlMcpZgPBliIOjb7pcY
Message-ID: <CAG48ez3QGgSuAfXxF9C9qH-PoUDwBEJ8adTRHw10cs0tqdp8Pg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 4/5] exec_state: relocate dumpable information
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B256A000C
X-Stat-Signature: 7qoifycjht4eqyo13kiq4mz35xexgtkm
X-Rspam-User: 
X-HE-Tag: 1779304917-674551
X-HE-Meta: U2FsdGVkX19lQLpYVO4aoQxCAhzinvmasPyW/AArhezmYrywzLj2kUOTizWCo6kHHukCU/9h+DQfYEN9AjHIpNAi7/t+c3MKP0jvZSo9TA49T8Euu11fP7SOe5Gqjk6hL6IR3bxIfwUzhJ80yLzoGCxzgl3RjRQl573KcJNL5BfSLILF4EsdhqTnu4aiwHkM+cwGEhjibZXm1aq3dhHnQG8X+dbyIrsqS5tWUzjUkhHXjXipCsJURN+ItMA+HvV+oJduZfDA1aOmOxNIR2UjUmWJo8dIq68kuvre80LqVI2nqIx9q5TN1SQ4f3QY+MxtG4EXc58KpqSkYD8vhc5AIPzrOY2VwXvkNxVhUTQd8e7MQ5h/BpVDjqVM2MsjvX0LCw4KcN0TYuEayJnchWJT08Nu0eCIhAXoUWzfh74vdcHQ3iNnsJgAn5FT2A1EEz7oO9oytB3/jiC3xF5xy8+5TV2IXJAHC88XusXooWNBd7RRoUY3hH2xpR+p6XEamDnK8a2DHwSCXCm3RzRv/YRPDx6yhK3LxmlDAhvwqk0QzL79RbcVic3WD39bQPhVOPB3OcqugBqSAPgTA5xImIdMzmHb6Hvc41io77MbKZiyA5WX79uswOnTKL8sp6/3eWGTX+vGLkuuYuVzZJMZeZ2W4nRQWrcpsFu5uGEJK51IP4yR9qFV6IMTumfBBvnQYZ+2fDCfd92AvD+EzS74UwM7zpSocsLZsQju6OwBpOC1qS1PIo9b12ncHSNk/d3074SWDu2AZBjvX5WJ17Qi06uwwgT+w0i608x/+fAIpkc2auFlsvvfCP/y6+rhrxDjF3/Ju19gKRhkoU/IyFvno6XWN293w9kf3iOrgK/MmUlEeei5VRxrr5l3rHaetzgliQFZHRCnRF2k559WfUW7Mmk1TZoZBbvve/yOJEHurexwyYt0vl1UCZDEDi8kwl/3s7mEyiMES0PLAZJB0rPe9Wf
 CDYCOoiV
 besCekrVNtVCUXMR0TQgOslxoNOx7wQTlEDOsDYch9WJ0yZAq38x4ZcGh81rj7yZgHE0nfzggnmLlBBbjS4OmnJ7oRBQjPv9G4qsGQ78/O+qnmHUuMMVimj86UAuVuKN/vML/KizzPjdShHHjL0aB2+MNYLXe5EfAjCf8qNnupeuJTsY1bVO6OgE2Z0dR6PipK8RsmAxk2z9q5KIJnYRdAvlWPpnSK7TR5Rrb0J08mM/K/JqLE3My1jJD/UPNLRDNdVGrIuxMuCk3Lmm8cWeptgmE+ooiKnh+vcp8QQTNkPN/lr1YdMG1/FGnNXKfNWItxqf2NSL8W5yW25Nej16BCpvP6ORtN4/PTuwodYT9ngWpZd4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 4:43=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> The dumpable flag captured at execve() is consulted by
> __ptrace_may_access() and several /proc owner / visibility checks.
> It lives on mm_struct today, which exit_mm() clears from the task
> long before the task itself is reaped.
>
> exec_state is anchored to the execve() that established the current
> privilege domain. Every clone() variant refcount-shares the parent's
> exec_state via copy_exec_state(); only execve() allocates a fresh
> instance (via alloc_task_exec_state() in begin_new_exec()) and
> installs it under task_lock + exec_update_lock with
> task_exec_state_replace(). init_task uses a static instance.
>
> The dumpable mode now lives on task->exec_state->dumpable.
> task->mm->flags no longer carries dumpability; MMF_DUMPABLE_MASK is
> removed, but MMF_DUMPABLE_BITS is reserved so MMF_DUMP_FILTER_* bit
> positions remain stable for the /proc/<pid>/coredump_filter ABI. The
> task->user_dumpable cache bit and its assignment in exit_mm() are
> removed; readers go through get_dumpable(task) directly.
>
> coredump_params gains a snapshot field cprm.dumpable, populated from
> get_dumpable(current) at vfs_coredump() entry, replacing the previous
> __get_dumpable(cprm->mm_flags) consumers in fs/coredump.c and
> fs/pidfs.c.
>
> The user namespace recorded at execve() is consulted by
> __ptrace_may_access() and by /proc/PID/* owner derivation. Move the
> captured user_ns onto task_exec_state, which stays attached to the task
> past exit_mm() and across exit_files().
>
> bprm grows a user_ns field staged in bprm_mm_init() with the caller's
> user_ns, narrowed by would_dump() to the closest privileged ancestor,
> and consumed by exec_mmap() via alloc_task_exec_state(bprm->user_ns).
> free_bprm() releases the staging reference.
>
> mm_struct loses ->user_ns entirely.  Initializers in init-mm, efi_mm,
> and the implicit one in mm_init()/dup_mm()/mm_alloc() are removed;
> __mmdrop() drops the matching put_user_ns(). The kthread_use_mm()
> WARN_ON_ONCE(!mm->user_ns) is no longer meaningful and goes too.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Except for the discussion on the cover letter about whether to unshare
on fork():

Reviewed-by: Jann Horn <jannh@google.com>

> @@ -434,13 +434,9 @@ static long pidfd_info(struct file *file, unsigned i=
nt cmd, unsigned long arg)
>
>         if ((mask & PIDFD_INFO_COREDUMP) && !kinfo.coredump_mask) {
>                 guard(task_lock)(task);

nit: this can become guard(rcu)() now?

> -               if (task->mm) {
> -                       unsigned long flags =3D __mm_flags_get_dumpable(t=
ask->mm);
> -
> -                       kinfo.coredump_mask =3D pidfs_coredump_mask(flags=
);
> -                       kinfo.mask |=3D PIDFD_INFO_COREDUMP;
> -                       /* No coredump actually took place, so no coredum=
p signal. */
> -               }
> +               kinfo.coredump_mask =3D pidfs_coredump_mask(task_exec_sta=
te_get_dumpable(task));
> +               kinfo.mask |=3D PIDFD_INFO_COREDUMP;
> +               /* No coredump actually took place, so no coredump signal=
. */
>         }

