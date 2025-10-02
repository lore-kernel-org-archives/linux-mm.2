Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAB3CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 16:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359A58E0003; Thu,  2 Oct 2025 12:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330F18E0002; Thu,  2 Oct 2025 12:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246EB8E0003; Thu,  2 Oct 2025 12:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10F418E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:32:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9F4611A603
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:32:32 +0000 (UTC)
X-FDA: 83953717344.14.9A4E80A
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0E81A40007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:32:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EjMywUQP;
	spf=pass (imf17.hostedemail.com: domain of chaosesqueteam@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=chaosesqueteam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759422751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J82hEbppU5PpCA3ET4b2HIdeaLxw8NSSqjpat9l2Btg=;
	b=jS61s3/tcnD5+I+nVzU717wfo6pHz7byivz0qpZfVQSaU/kOWPlFICIPGR09VG2f6k35g3
	/QlBPM9ufCRnt2U56HY97h+EtLvnsaj7C4Es3586uXnONBctH1J8HQuuFBR8GxBa9oMEFr
	T3krkhqOFP4rIv+aLozMCKYu7bspdl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759422751; a=rsa-sha256;
	cv=none;
	b=Nhd8jqpWDClwJbZxT1xfwlSk3csJie+uqR2FhyMUu5eHUbTjdxjl2ljVEnzevEZ/DgmR7F
	+vHsWC8VOsGXqVML59NswskLup761ED/xi9WciSsYbekCVByE1XTPLapxVMWOcg89xZTAA
	vcoooN5Xo7Co3R3frhOZnO3U/OdKjq4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EjMywUQP;
	spf=pass (imf17.hostedemail.com: domain of chaosesqueteam@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=chaosesqueteam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3306b83ebdaso1269547a91.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 09:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759422750; x=1760027550; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J82hEbppU5PpCA3ET4b2HIdeaLxw8NSSqjpat9l2Btg=;
        b=EjMywUQPLHSyv4cy2pMJpCEaC8H5fcqpveiOpnnYOKnYSnHLivSAIbKEWPy8LmBa5F
         GpuStzYo2plmYHVyf2QrHOJ7do8YS1XZ34jpXtMuS67/qllBkwk4U7A0heR/KwJyNm/5
         JkhVGC6Bkm400ylhRpWBSqnkhJoVAOCQ019I1wzi9rcOQUWiwoh5eLa/JgSOWsxFbgqK
         dXwCJ8/NUJlFtHSToKd1VLt+c8ktOL1/VbxRG+kTSic+XlW+hIiy+pI9v36w6j3voL2S
         S634GmQX7iQkrVEJKLJ1raTxQyqlUqtR/PGHgn+F9EA+LNVHG5wsnBpVO7uqUtCbWbR9
         kVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759422750; x=1760027550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J82hEbppU5PpCA3ET4b2HIdeaLxw8NSSqjpat9l2Btg=;
        b=lrh3eVmikC9qgYYUOxKWSCLAcCAOfmdxCTTgFmttyggK0JgIz5CrkSBQicYLaVoaVd
         YVdskMgKVZVBbEElx5EaUCbpKkM1XkTNp/XW2rrJCBAgklhy/fpKVG0x6aAystcAzfoz
         Q5MRuLirenox3/EL116XPV9JyaJIH8rjMCiccReWdVsi3BZEbF+ZjCqvLTWzd4RZKaFX
         g78wt15gcv7jqaTpWAN1ccJrJoAfvrjA6vo3+zzPnyT52+dlbuZgjTql/3lZeyZrwqqO
         bBY70PErfil/Ox7UQcwJOlYd8vgJzRmfLfs29lSErnuc4hkIaXwpwAd9xNgAKPP4hiTb
         LoGw==
X-Gm-Message-State: AOJu0Yz/okUNbZgoryt4+AVnXfWOi7hR1B70HVAzT9zEzYV0NpsQFf29
	Vwz0UXG5t52GCG76i9+CbaxuUyLYi88onS3suI7LTBRWoF3a//jkwIjiZmz2WJvm/fQGAESgzTH
	uqF7kyYMhNWKbLgRqz1kEoM8Rqt1tMW8=
X-Gm-Gg: ASbGncvSA2YMWNiH0kKt4o8t+XF8IJSXgbKfZ+u6s1OUzzj63AcqgyL0kjVzuw0atIu
	BW7fohrpWEoYMeCPMBUoJFE5WnXJNWlmRTiO/bsoRmRTzraVgxYIcYOew2kWotYOvvNgncGXSUf
	KRLze1cs59IAe9bfWAsXSlQGWeovo1Y7z8WrcehHaNxXV0X3yKRaj1NrspCSk3OpneCOSfrSIQ6
	TPRWNLf/1YWDcHlmK8iPwUQxXd56sQ=
X-Google-Smtp-Source: AGHT+IH1kqYprFVu+gRwT9ksEvkx2IZae2hfvbLLg7njU+1lezqfM8necgEFjx5pebciFSKMYMvp+Z1vh9PYQgWKCRA=
X-Received: by 2002:a17:90b:1b49:b0:335:228c:6f24 with SMTP id
 98e67ed59e1d1-339a6f314bamr9388726a91.25.1759422749743; Thu, 02 Oct 2025
 09:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-8-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-8-roman.gushchin@linux.dev>
From: ChaosEsque Team <chaosesqueteam@gmail.com>
Date: Thu, 2 Oct 2025 12:37:25 -0400
X-Gm-Features: AS18NWDbe-kMSZ7SJAYFEu7SK7fkTQUsM14-iqOYEo7iaeFy2DxQ3izBL6FI7Mg
Message-ID: <CALC8CXfcJjoHyZAiHm1meGtKf9CAbgnmhy4fxMqaa5Gb_ZHvwQ@mail.gmail.com>
Subject: Re: [PATCH v1 07/14] mm: allow specifying custom oom constraint for
 bpf triggers
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: duxb4wyxib9aw3cd9gyri8x7j7uhr67s
X-Rspamd-Queue-Id: 0E81A40007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759422750-525338
X-HE-Meta: U2FsdGVkX1/7W03QHKFpFjnYsoqjgqOCIuhx0Xp14kJkNbzb5CrHebmRnXuFvGOGedidDr45pimo6X95s4Nlw3gkQKvEbIrQMKmAt19vllFw4jG9KzimcrOkiM7RdcVEtQSMS4PQihDhWjzQvwdVs1v5cKRgIezYL7/eYOn9Raa/2aAZCnDJOfnidqMGN4vSJJjru5GkQOwmBNYkC+vCLbvs3ZdgdX772FyUzgAVwagZprilroTKuO54aSMX9mJ/N4/kSTp3PdffF50rFgy4dFoAqk9CzfpKW4coui3O215XEvN5dbzdyzepnNSYOCkx4rrRhYyB9kxdGOHr90dVtmlglNbLRlwCq3tpj5nM84ynA3D1Xqo4fewyTrBFwhPemQo6+F3CUo70GEF4d9seWShQhwExM4uAz8lVZ1TNpqnb++OrXSPB6JCywguOBaGaLW09ESm5gG6qDqPMcHDuCYczOS8elJFlm2OZ2AfxrMbWQ2q6Tm236DrlV437DzqGeNFAV1+V0OOzmz/IurwoQsty5QK41BAcx1o1f+RMdxVrRaiiEy8tqLG6RY8mbCIIQf5LT9UQWbkZs0wifGBmrS4fMgquLCx+TWYvihgHw5fVMPOM522BYZLRzJ/FGt3QRcASJTF3Fgqnf+sqZJE7Y8XVUpKYjtnotG3o288jq84Ij6vrL19mh8FWw/gl9kBhafmwrdqmh/0X8gR3R+U87ELr8ksH4D0uK4I/GB+TWWfCAtxdgjfQR+enxQsP65etBRT6M+FEoLpAA2fabmjhjYYs5gfBFvr9P3BpWc0f9rXuVxDf6ntLTfVB5WoOOjy46fnWvn+zjGscGjiZd4Zp3ga3YzUvqVX4ShjLWg28Fiu5ZeFDVIKceGGFqrm5es6Y4bcE8pbQNl/g2VyPIsPy3FEdyWhp3ghNce2BT0nMqyIgq6cLCfVqg63Ar3BcXlLfta992XrL1Ypv/1SCa/h
 CcyCiNPK
 ky+MNv7DYnpnYoxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Roman Gushchin...
RUSSKIEEEEEE

On Mon, Aug 18, 2025 at 1:05=E2=80=AFPM Roman Gushchin <roman.gushchin@linu=
x.dev> wrote:
>
> Currently there is a hard-coded list of possible oom constraints:
> NONE, CPUSET, MEMORY_POLICY & MEMCG. Add a new one: CONSTRAINT_BPF.
> Also, add an ability to specify a custom constraint name
> when calling bpf_out_of_memory(). If an empty string is passed
> as an argument, CONSTRAINT_BPF is displayed.
>
> The resulting output in dmesg will look like this:
>
> [  315.224875] kworker/u17:0 invoked oom-killer: gfp_mask=3D0x0(), order=
=3D0, oom_score_adj=3D0
>                oom_policy=3Ddefault
> [  315.226532] CPU: 1 UID: 0 PID: 74 Comm: kworker/u17:0 Not tainted 6.16=
.0-00015-gf09eb0d6badc #102 PREEMPT(full)
> [  315.226534] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.17.0-5.fc42 04/01/2014
> [  315.226536] Workqueue: bpf_psi_wq bpf_psi_handle_event_fn
> [  315.226542] Call Trace:
> [  315.226545]  <TASK>
> [  315.226548]  dump_stack_lvl+0x4d/0x70
> [  315.226555]  dump_header+0x59/0x1c6
> [  315.226561]  oom_kill_process.cold+0x8/0xef
> [  315.226565]  out_of_memory+0x111/0x5c0
> [  315.226577]  bpf_out_of_memory+0x6f/0xd0
> [  315.226580]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  315.226589]  bpf_prog_3018b0cf55d2c6bb_handle_psi_event+0x5d/0x76
> [  315.226594]  bpf__bpf_psi_ops_handle_psi_event+0x47/0xa7
> [  315.226599]  bpf_psi_handle_event_fn+0x63/0xb0
> [  315.226604]  process_one_work+0x1fc/0x580
> [  315.226616]  ? srso_alias_return_thunk+0x5/0xfbef5
> [  315.226624]  worker_thread+0x1d9/0x3b0
> [  315.226629]  ? __pfx_worker_thread+0x10/0x10
> [  315.226632]  kthread+0x128/0x270
> [  315.226637]  ? lock_release+0xd4/0x2d0
> [  315.226645]  ? __pfx_kthread+0x10/0x10
> [  315.226649]  ret_from_fork+0x81/0xd0
> [  315.226652]  ? __pfx_kthread+0x10/0x10
> [  315.226655]  ret_from_fork_asm+0x1a/0x30
> [  315.226667]  </TASK>
> [  315.239745] memory: usage 42240kB, limit 9007199254740988kB, failcnt 0
> [  315.240231] swap: usage 0kB, limit 0kB, failcnt 0
> [  315.240585] Memory cgroup stats for /cgroup-test-work-dir673/oom_test/=
cg2:
> [  315.240603] anon 42897408
> [  315.241317] file 0
> [  315.241493] kernel 98304
> ...
> [  315.255946] Tasks state (memory values in pages):
> [  315.256292] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file =
rss_shmem pgtables_bytes swapents oom_score_adj name
> [  315.257107] [    675]     0   675   162013    10969    10712      257 =
        0   155648        0             0 test_progs
> [  315.257927] oom-kill:constraint=3DCONSTRAINT_BPF_PSI_MEM,nodemask=3D(n=
ull),cpuset=3D/,mems_allowed=3D0,oom_memcg=3D/cgroup-test-work-dir673/oom_t=
est/cg2,task_memcg=3D/cgroup-test-work-dir673/oom_test/cg2,task=3Dtest_prog=
s,pid=3D675,uid=3D0
> [  315.259371] Memory cgroup out of memory: Killed process 675 (test_prog=
s) total-vm:648052kB, anon-rss:42848kB, file-rss:1028kB, shmem-rss:0kB, UID=
:0 pgtables:152kB oom_score_adj:0
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/oom.h |  4 ++++
>  mm/oom_kill.c       | 38 +++++++++++++++++++++++++++++---------
>  2 files changed, 33 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index ef453309b7ea..4b04944b42de 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -19,6 +19,7 @@ enum oom_constraint {
>         CONSTRAINT_CPUSET,
>         CONSTRAINT_MEMORY_POLICY,
>         CONSTRAINT_MEMCG,
> +       CONSTRAINT_BPF,
>  };
>
>  /*
> @@ -58,6 +59,9 @@ struct oom_control {
>
>         /* Policy name */
>         const char *bpf_policy_name;
> +
> +       /* BPF-specific constraint name */
> +       const char *bpf_constraint;
>  #endif
>  };
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index df409f0fac45..67afcd43a5f7 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -240,13 +240,6 @@ long oom_badness(struct task_struct *p, unsigned lon=
g totalpages)
>         return points;
>  }
>
> -static const char * const oom_constraint_text[] =3D {
> -       [CONSTRAINT_NONE] =3D "CONSTRAINT_NONE",
> -       [CONSTRAINT_CPUSET] =3D "CONSTRAINT_CPUSET",
> -       [CONSTRAINT_MEMORY_POLICY] =3D "CONSTRAINT_MEMORY_POLICY",
> -       [CONSTRAINT_MEMCG] =3D "CONSTRAINT_MEMCG",
> -};
> -
>  static const char *oom_policy_name(struct oom_control *oc)
>  {
>  #ifdef CONFIG_BPF_SYSCALL
> @@ -256,6 +249,27 @@ static const char *oom_policy_name(struct oom_contro=
l *oc)
>         return "default";
>  }
>
> +static const char *oom_constraint_text(struct oom_control *oc)
> +{
> +       switch (oc->constraint) {
> +       case CONSTRAINT_NONE:
> +               return "CONSTRAINT_NONE";
> +       case CONSTRAINT_CPUSET:
> +               return "CONSTRAINT_CPUSET";
> +       case CONSTRAINT_MEMORY_POLICY:
> +               return "CONSTRAINT_MEMORY_POLICY";
> +       case CONSTRAINT_MEMCG:
> +               return "CONSTRAINT_MEMCG";
> +#ifdef CONFIG_BPF_SYSCALL
> +       case CONSTRAINT_BPF:
> +               return oc->bpf_constraint ? : "CONSTRAINT_BPF";
> +#endif
> +       default:
> +               WARN_ON_ONCE(1);
> +               return "";
> +       }
> +}
> +
>  /*
>   * Determine the type of allocation constraint.
>   */
> @@ -267,6 +281,9 @@ static enum oom_constraint constrained_alloc(struct o=
om_control *oc)
>         bool cpuset_limited =3D false;
>         int nid;
>
> +       if (oc->constraint =3D=3D CONSTRAINT_BPF)
> +               return CONSTRAINT_BPF;
> +
>         if (is_memcg_oom(oc)) {
>                 oc->totalpages =3D mem_cgroup_get_max(oc->memcg) ?: 1;
>                 return CONSTRAINT_MEMCG;
> @@ -458,7 +475,7 @@ static void dump_oom_victim(struct oom_control *oc, s=
truct task_struct *victim)
>  {
>         /* one line summary of the oom killer context. */
>         pr_info("oom-kill:constraint=3D%s,nodemask=3D%*pbl",
> -                       oom_constraint_text[oc->constraint],
> +                       oom_constraint_text(oc),
>                         nodemask_pr_args(oc->nodemask));
>         cpuset_print_current_mems_allowed();
>         mem_cgroup_print_oom_context(oc->memcg, victim);
> @@ -1344,11 +1361,14 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_c=
ontrol *oc,
>   * Returns a negative value if an error has been occurred.
>   */
>  __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
> -                                 int order, bool wait_on_oom_lock)
> +                                 int order, bool wait_on_oom_lock,
> +                                 const char *constraint_text__nullable)
>  {
>         struct oom_control oc =3D {
>                 .memcg =3D memcg__nullable,
>                 .order =3D order,
> +               .constraint =3D CONSTRAINT_BPF,
> +               .bpf_constraint =3D constraint_text__nullable,
>         };
>         int ret;
>
> --
> 2.50.1
>
>

