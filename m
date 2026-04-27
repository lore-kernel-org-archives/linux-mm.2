Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EECC5FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FFF16B0095; Mon, 27 Apr 2026 16:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D81A6B0098; Mon, 27 Apr 2026 16:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE6E6B0099; Mon, 27 Apr 2026 16:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 402116B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:34:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD6D6C159F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:34:52 +0000 (UTC)
X-FDA: 84705489624.14.89FEA82
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id B30CB40007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:34:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WDnQIBBd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777322090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DhWqUuRS27TshBWv94CX8/aDWOniyA7iNM1Yxs8Y1bU=;
	b=xcPVR3WWrJVrKpaqW/O7HfAhy6yvQ5tHy3MeZQhLQdjY3ha+4Eg8aQv03j2ylDz8i2lEh1
	EOZQG+OMK63g98fZ/JgAsLv38cvFWj6h1exDdyf6QjkFtdLGteC/kqST19CsGSxq6/AbVe
	9KSoTJlkuPuEQUcnBvP3FH/eGJWfH4E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777322090; a=rsa-sha256;
	cv=pass;
	b=JfgJb+HE0rEwvSTcQwzDE2U1kL8tDEEMDcRwN0ETGduQ5h8Y5rZKzhqMqtagJUwZCpwiOZ
	sIhnePl7rKsDXVwX6UdzcgJ7kPpzeBubM/GCaWeTercQQIPpG4nYq29v6/K9z9EBDgkknr
	Y0ea9iFVv8xy3SPpB5KPqnCTHiPpzP4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WDnQIBBd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50d6b393d60so166381cf.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:34:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777322090; cv=none;
        d=google.com; s=arc-20240605;
        b=bqrli2oQJBSora4s5eKVJ2eamBsWKU6Ck7ve0wbjn/2DKroYOBkTacNXq6yh7F9j/o
         3IZh1jvia6l09FVHZikmKSVEnxwlgqTRFN1HsOulflQa8L9j4HCtLnqlyW6445sLVwVL
         67x7YE7+MRJZF4bJ10NY6iPHpt9HlAiyBiB1iQeQEBr/HqTHBf2HymWplxlomQT9R4YT
         OZvYVTn1qMAGY6DB4JfP/3W6P/FnDTQQnHNOk2CKNsjaQUeCMTIf+C7HKh4o9NH6BpjI
         u6p5hpEVA232MsbnCjugUP7Kj0uq8UH2OSzGM2CMuklrqAg9tMRPmGRCtGOA2wJypoHg
         lTgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DhWqUuRS27TshBWv94CX8/aDWOniyA7iNM1Yxs8Y1bU=;
        fh=P0qAIsnOc8Swxlkcq968SOD0bhy1lT8Qjw/d23wJSMc=;
        b=YcrRm3K/6t8ZarRj7VhaV9TLwRjJuD7Kaa0zAtEzF3rS5qqqZ3i/JWUfjEzKt3Pnvm
         ldu2D/qZTLDJrqtsLK7YPbQt/zXGgz0N7gbTPtM086TRZ/znrgYPHkh8x6giKfTa25gK
         oYx9MKIDk18bAMBBMDYqcg/zFJV8ZRTuz6/eDpRQWPG/YA+l5pSR1PhGQHJKgBnBZD4k
         m07vRtVwFzVqPvVeonNKw6bjsU87FQ6on8EB/036XOwsGv4c3UPRRH3rdzJiViEndnQQ
         0gZ6m9ViI1ANzKAaUIvT0EqRJZ1Y6tFYs6Lq8XS8UvTIZWU7Qj8rAR9bU39+6hn9DRrP
         Y4RA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777322090; x=1777926890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DhWqUuRS27TshBWv94CX8/aDWOniyA7iNM1Yxs8Y1bU=;
        b=WDnQIBBdYZOCcyT0qeJINdKipqCacGggyBzjeQ9vPmdFDZOZ7NpvaIXd25TO4UOegz
         R1Qs1LIgf+lfy8MxY+x/NKzwsdicICnUsVeKqwVMA0w33mAtiVs/cIkN4I+VVjJf6OAQ
         zbn9DQvLn8PnlKjcT1v9IVNVHiYgihZnzXxQEPIp60L6WA2znzofHdtNRUqnMuRNUygr
         Hq2cVUbHKowLclBTOWSYtCRlGEMMao7OnioshNK9Ls3fE8AJi73nnR9CZjfTZYHSrbjZ
         wVLXGiCJJjy4SCY+o+7D+DLgSaQXYOmj+R8VaW7O+HGSYooJsEgfzRizFCARA1f5Fusm
         36Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777322090; x=1777926890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DhWqUuRS27TshBWv94CX8/aDWOniyA7iNM1Yxs8Y1bU=;
        b=KN2TTXZfsJlZRYW+3c27j/dpE/rRQiStgXQAK9Q1Cu3PlBm0wVuxBjHNod30qdQEsh
         BwNdkFgnE2885PtRnR7sG2apAjn+4lnfuEUz6eTDiMVbJuhu1pqRT++ILy+XOkHwvQ/w
         hEjzqQigamsZvKbgcV+ltCagOvOK37nRDC+xgCB5rWoiJN2feDyWcQ3Qj1eGyQWRBHKr
         Og6FWoJMb1Mdocb/rVVxgqRqGQ/ftVE0g3Et9/gvBX1NY4Lbj8hncsbhCPCeD183mSIg
         2T2VrG+HvrlIFVBgj/j6PcgttApKrhJ9NXMfmjxaw4pj2SsaE1XrbYq3cLqyLpXEvcKr
         afhw==
X-Forwarded-Encrypted: i=1; AFNElJ+EKtX4Itd8fW+cwSP6eRBdh1CSWaLW+XJMcWxzXFzLuJu5LVijlu9D31Awi/m4FNXdN06J//tSrg==@kvack.org
X-Gm-Message-State: AOJu0Yz+dcJOEiFBbGosR+iEKtutiBg4+bMDPxA9Pc9RQBaW7zEqqY9V
	IvVRrKJQpEEMF12jqqWy70cDpqOX9naGMnn6GLn0JaCJdgA8tsnIMHe9obcg0lXOLvNLFxen2Wf
	vyTz19QRKo4J3c5DLmL33ftUxsH7LPDblk9BcQZTz
X-Gm-Gg: AeBDietZW4JF4DnTCugnCphD8oUyB19Qiy0Dsf5L493QkchpkZkRsR1JbbArTqOQFXk
	c5XxNXNV+rLm6GO2EBu5fH7z+8ZrFzEw73yWHqBLzXkyHIgAAisAIaRN959jOx9Np0ZdNH5bxvc
	QzOMSVxtRo5TuLQczBPyRBRrR+Yt0T+2YxY18626n9rYpAgavEHJ9F3uscS6I7+zYpvX/YVI8HR
	1ZvLSd5R9sUdMUquwoJpRH8V3+/BDRcZs7u96i8KiG9eUtI28ih6uAQYXCABNoYRC62yY6ep2AM
	oyTTRcnv7NHiNTsZBoyXPq6566s=
X-Received: by 2002:a05:622a:8d0e:b0:50e:595d:164 with SMTP id
 d75a77b69052e-5100cbeb145mr3380701cf.8.1777322089076; Mon, 27 Apr 2026
 13:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260421230239.172582-1-minchan@kernel.org> <20260421230239.172582-4-minchan@kernel.org>
In-Reply-To: <20260421230239.172582-4-minchan@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Apr 2026 13:34:37 -0700
X-Gm-Features: AVHnY4I5Wx2UawYOebex5DxQ-pCvX_szKcR7n0x14TYqFsbSSMINsoQ03bpahTg
Message-ID: <CAJuCfpFK+qatN_vHArEKOYe+LRHQG0e3inJrzVdz-mABi-BSTg@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org, 
	david@kernel.org, mhocko@suse.com, brauner@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, timmurray@google.com, 
	Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B30CB40007
X-Stat-Signature: tcpa4ixxdjepbnq5spbuqt6uubh87bdn
X-Rspam-User: 
X-HE-Tag: 1777322090-960824
X-HE-Meta: U2FsdGVkX18hacGR2Z5NcaUkvzd2umVlE5W6FHHGPgjKGm35qkOzWnJkDwcmur37jpl2durFlpZxnbMECjik/1t8Fr+f1pix+3M5qVSMh3JJPeDwGmAtivO+wB7v1x7wNu77woV4jzyZDbIG7tWZ3cCdnF9IVMlUI5V5zV48NhtHwvYsT9PBVzPtrFmQTIg9QumxVj8BjrXXQ5kuoaSpM1iiMDaO4za0tlCWlXitoWYlFcD15BfG1Nb9p//psvHI35whAk1hoFfGk4C0mV8fAGTxuV1L3JPsF3Q7Bclv5FMD9FqPUbU3ldW0HVZ4Fs5EQtn4GM6xMAPCnrLe24QXM8wQoajsuD+91BaEYa73qBQtZAGZm5HaFyGs6G0qrLuQjYkKYoH5aSDXdQ8zyK1lPdqNRFtNlSfSl3R2YzaI1IR50rCBV4pkchqO1BIW+Yy48eFA0bQxPDLM7g1eC46prub76awa31qnTI6Gqt8+GdJce3b2AKIcw0ESrxs5Fj1ABPu4P5Yj4eiycmHfezXnIEN28pNXFCW/COCFx+590mwtSRyS0D5O5SeM7bA305Z6jCi+w7WbzvLa/+m2TgB/e4SICojNUTdiFirHxlc9AUmkUEno2peh5GqqDp/VgLBPKohC2x7MKRFpKkKKmlp5xFCZBJi6ucpoaLPk4PzVOYd4kS7NZmnEQE4cYW/Zv/em5r2z/URplYVqEdR7ANJLU9XZvtvSv5G0Wun6xwPIG1wdWEMbToeSM5b2oDz7gN1HM5jY+8hxTeYP3/hW+y9TbIseLnqZTlf8+vXbn+bZFceHPjyMdZzFo6qtKIzeIEs8rOBp45WdYj9jEvxFsSjB6Mk7zXjS/IN7cdFkYoV/mESFWBrYXHaRm0ka8XYvc+T0ffpfevpVJStvWxwEGe/ic4DX3STvwT/ACV96oI3lJcBjqPD/0tHjJ49vUUeacqUxTfBes7mpsGPYCUM1N32
 bYCwfczt
 HDL0dldIWJTNsUGwa5fIf+24zM1ReHyPPnpblO2NcRVw+VyUL5X8QPN2IdSdBZ5y0sw1DpXrpEDsmfEKWva8I6/HRCXfv9nfT1K96sku+X/f4ogqmklg0ykiwceOLkebQ9jq92IE6zRE32qVn4eIVISh0epi8zkJFhqHrAWd90rYubIqZJz+OROWfrXTbgpbgvRGk9ciOVTpslP5oXzTpw6OqT6V1Pj+W5TMXXMRHtuJQsMP0lQr5usTSo2JWQ58hU/E47dPP9TuGFk0thXjqE/NSx0FH7nxsEXo0o/7ARNIXgK+Ov2shZZnHOU73T/NDpWhS9ywryiZkNnjr+psx713gzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 4:03=E2=80=AFPM Minchan Kim <minchan@kernel.org> wr=
ote:
>
> Currently, process_mrelease() requires userspace to send a SIGKILL signal
> prior to the call. This separation introduces a scheduling race window
> where the victim task may receive the signal and enter the exit path
> before the reaper can invoke process_mrelease().
>
> When the victim enters the exit path (do_exit -> exit_mm), it clears its
> task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> leaving the actual address space teardown (exit_mmap) to be deferred unti=
l
> the mm's reference count drops to zero. In Android, arbitrary reference c=
ounts
> (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> VM accesses) frequently delay this teardown indefinitely, defeating the
> purpose of expedited reclamation.
>
> This delay keeps memory pressure high, forcing the system to unnecessaril=
y
> kill additional innocent background apps before the memory from the first
> victim is recovered.
>
> This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> an integrated auto-kill mode. When specified, process_mrelease() directly
> injects a SIGKILL into the target task.
>
> To solve the race condition deterministically, we grab the mm reference
> via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> victim from calling exit_mmap() in its own exit path. This ensures that
> the memory is reclaimed synchronously and deterministically by the reaper
> in the context of process_mrelease(), avoiding delays caused by
> non-deterministic scheduling of the victim task.
>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  include/uapi/linux/mman.h |  4 +++
>  mm/oom_kill.c             | 56 +++++++++++++++++++++++++++------------
>  2 files changed, 43 insertions(+), 17 deletions(-)
>
> diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> index e89d00528f2f..4266976b45ad 100644
> --- a/include/uapi/linux/mman.h
> +++ b/include/uapi/linux/mman.h
> @@ -56,4 +56,8 @@ struct cachestat {
>         __u64 nr_recently_evicted;
>  };
>
> +/* Flags for process_mrelease */
> +#define PROCESS_MRELEASE_REAP_KILL     (1 << 0)
> +#define PROCESS_MRELEASE_VALID_FLAGS   (PROCESS_MRELEASE_REAP_KILL)
> +
>  #endif /* _UAPI_LINUX_MMAN_H */
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..730ba0d19b53 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -20,6 +20,7 @@
>
>  #include <linux/oom.h>
>  #include <linux/mm.h>
> +#include <uapi/linux/mman.h>
>  #include <linux/err.h>
>  #include <linux/gfp.h>
>  #include <linux/sched.h>
> @@ -850,7 +851,7 @@ bool oom_killer_disable(signed long timeout)
>         return true;
>  }
>
> -static inline bool __task_will_free_mem(struct task_struct *task)
> +static inline bool __task_will_free_mem(struct task_struct *task, bool i=
gnore_exit)
>  {
>         struct signal_struct *sig =3D task->signal;
>
> @@ -862,6 +863,9 @@ static inline bool __task_will_free_mem(struct task_s=
truct *task)
>         if (sig->core_state)
>                 return false;
>
> +       if (ignore_exit)
> +               return true;
> +
>         if (sig->flags & SIGNAL_GROUP_EXIT)
>                 return true;
>
> @@ -878,7 +882,7 @@ static inline bool __task_will_free_mem(struct task_s=
truct *task)
>   * Caller has to make sure that task->mm is stable (hold task_lock or
>   * it operates on the current).
>   */
> -static bool task_will_free_mem(struct task_struct *task)
> +static bool task_will_free_mem(struct task_struct *task, bool ignore_exi=
t)
>  {
>         struct mm_struct *mm =3D task->mm;
>         struct task_struct *p;
> @@ -892,7 +896,7 @@ static bool task_will_free_mem(struct task_struct *ta=
sk)
>         if (!mm)
>                 return false;
>
> -       if (!__task_will_free_mem(task))
> +       if (!__task_will_free_mem(task, ignore_exit))
>                 return false;
>
>         /*
> @@ -916,7 +920,7 @@ static bool task_will_free_mem(struct task_struct *ta=
sk)
>                         continue;
>                 if (same_thread_group(task, p))
>                         continue;
> -               ret =3D __task_will_free_mem(p);
> +               ret =3D __task_will_free_mem(p, false);
>                 if (!ret)
>                         break;
>         }
> @@ -1034,7 +1038,7 @@ static void oom_kill_process(struct oom_control *oc=
, const char *message)
>          * so it can die quickly
>          */
>         task_lock(victim);
> -       if (task_will_free_mem(victim)) {
> +       if (task_will_free_mem(victim, false)) {
>                 mark_oom_victim(victim);
>                 queue_oom_reaper(victim);
>                 task_unlock(victim);
> @@ -1135,7 +1139,7 @@ bool out_of_memory(struct oom_control *oc)
>          * select it.  The goal is to allow it to allocate so that it may
>          * quickly exit and free its memory.
>          */
> -       if (task_will_free_mem(current)) {
> +       if (task_will_free_mem(current, false)) {
>                 mark_oom_victim(current);
>                 queue_oom_reaper(current);
>                 return true;
> @@ -1217,8 +1221,9 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsig=
ned int, flags)
>         unsigned int f_flags;
>         bool reap =3D false;
>         long ret =3D 0;
> +       bool reap_kill;
>
> -       if (flags)
> +       if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
>                 return -EINVAL;
>
>         task =3D pidfd_get_task(pidfd, &f_flags);
> @@ -1236,19 +1241,33 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, uns=
igned int, flags)
>         }
>
>         mm =3D p->mm;
> -       mmgrab(mm);
>
> -       if (task_will_free_mem(p))
> -               reap =3D true;
> -       else {
> -               /* Error only if the work has not been done already */
> -               if (!mm_flags_test(MMF_OOM_SKIP, mm))
> +       reap_kill =3D !!(flags & PROCESS_MRELEASE_REAP_KILL);
> +       reap =3D task_will_free_mem(p, reap_kill);
> +       if (!reap) {
> +               if (reap_kill || !mm_flags_test(MMF_OOM_SKIP, mm))
>                         ret =3D -EINVAL;
> +
> +               task_unlock(p);
> +               goto put_task;
>         }
> -       task_unlock(p);
>
> -       if (!reap)
> -               goto drop_mm;
> +       if (reap_kill) {
> +               /*
> +                * We use mmget() instead of mmgrab() to keep mm_users > =
0,
> +                * preventing the victim from calling exit_mmap() in its
> +                * own exit path. This ensures that the memory is reclaim=
ed
> +                * synchronously and deterministically by the reaper.
> +                */
> +               mmget(mm);

I don't quite understand why you need to mmget() and prevent the
victim from calling exit_mmap() here. As long as we successfully
mmgrab'ed the mm, we can safely proceed with mmap locking and doing
__oom_reap_task_mm(). Victim can execute exit_mmap() in parallel with
__oom_reap_task_mm(). In fact that's even desirable! I remember a
recent patch that used mas_for_each_rev() in __oom_reap_task_mm() to
reclaim memory in reverse order so that exit_mmap() and
__oom_reap_task_mm() can start from opposite ends of the address space
and converge in the middle, working concurrently.

> +               task_unlock(p);
> +               ret =3D kill_pid(task_tgid(task), SIGKILL, 0);
> +               if (ret)
> +                       goto drop_mm;
> +       } else {
> +               mmgrab(mm);
> +               task_unlock(p);
> +       }
>
>         if (mmap_read_lock_killable(mm)) {
>                 ret =3D -EINTR;
> @@ -1263,7 +1282,10 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsi=
gned int, flags)
>         mmap_read_unlock(mm);
>
>  drop_mm:
> -       mmdrop(mm);
> +       if (reap_kill)
> +               mmput(mm);
> +       else
> +               mmdrop(mm);
>  put_task:
>         put_task_struct(task);
>         return ret;
> --
> 2.54.0.rc1.555.g9c883467ad-goog
>
>

