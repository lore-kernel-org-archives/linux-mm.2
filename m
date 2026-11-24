Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A978606A336
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 10:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=R42wJ0ks
Received: by kanga.kvack.org (Postfix)
	id 7774E6B0668; Tue, 24 Nov 2026 05:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727B76B0669; Tue, 24 Nov 2026 05:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616E76B066A; Tue, 24 Nov 2026 05:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2872A6B0668
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:03:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90381C0860
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:03:43 +0000 (UTC)
X-FDA: 85469575926.23.26A10AD
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 93E4240005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:03:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=mojatatu.com header.s=google header.b=R42wJ0ks;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.210.178) smtp.mailfrom=jhs@mojatatu.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795514621;
	b=IQJVyY4N5f16KkpUOBgptLIE1iJleSgQfIB/Pzxkb66erOeAClE/lwQoIjerxaQQr6xS1p
	1ra7mQZ0Tl2BnLITqjDpOa/GvTJyLZgX2f3mIZECnpAw8VD7hU/mOQPlpa7N17XfS4x+UX
	1R5NzYetBz91eUZJYed0IZ7SC6l8AQ4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795514621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGN5g9PtUGCG+wcdSVJumY3ZUtFUe8Es3+mlikmGYwY=;
	b=ldmbURrSMsQ7ha/b2uvo2kMCsVP30CHfsbN5kzMVPx8k2Ovi7+7zT+gFgCofjSUPVB4hY1
	NlzIMrxjrs0L8Yr3cziX/WUb5gChlD5ujd3iHVZKVKFZEssujVd2DgKnpPIaaURB1qVvXX
	hEr3wyehbM5Fi5Bn3QVr0f+IztLLXxc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=mojatatu.com header.s=google header.b=R42wJ0ks;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.210.178) smtp.mailfrom=jhs@mojatatu.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a07078200fso2167562b3a.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:03:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795514620; cv=none;
        d=google.com; s=arc-20260327;
        b=kJx1gwthhqB5el+h54aEcrwQbhmc+rLUzrRfR+nPSI59qzfdRsoHFPNKM80OlMQ8h+
         jMTJh/EEwDjmBvYxQvkJ1JG0qmiVXX1j6pFv3251e9s2elQ5qbcqPZUL4FwCN9tUb8MK
         oZt9y9OizzYnuNTRp2LbTdUgQ2A/hfYsI8AmYb3GPVroSAZlBje007AU5kPU8DLdGsud
         tg6Lvuk6mxRCl3agbQck2q45CQI0tl73HIWJTXduYurl5lsVoFhG5/KBMFtgyhYqACGS
         VjCVjx8MJ4o8QFrJAeKupAB3fRNgw4C2k2O77eC4pKH7C6hDzWWPM0K5eUyV5ORQPKD9
         3jVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cGN5g9PtUGCG+wcdSVJumY3ZUtFUe8Es3+mlikmGYwY=;
        fh=uS5EbfcCaylg8jbqPGh1s+DAkD8qyG7eQNqMWHMRzuI=;
        b=Vqp9c4W4QLS6oUhXXoojc+11WFnxuSwec0HnRr0H4oksNZJv1q0VEpgfjxZfaZzfRZ
         XRXm2YUOGjjLsFfvJPpyTDAJT1r3ax5AhZ8hXX67Qm2KR6H4N/Mo6FqTJSjB7TZieCBu
         cisbLWayYR4DGyv9CBMQB25/9ufzti/VqJPRl6x7WAqYWnVILpD0leJrcWaPOTpn5Iyr
         UnA38SgCZeU8/GySmCDazhb/RLlg+hVQgmHouLcoPeDyaYwmTNMhJ+pHqHz96i13BqxP
         YpjRgLw+etI5/E9C5tF4NdSgsqIv5tT2MHwoA2sOeyWnm1oJwoqo0yaIprFVfI1iDsFA
         JD9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1795514620; x=1796119420; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cGN5g9PtUGCG+wcdSVJumY3ZUtFUe8Es3+mlikmGYwY=;
        b=R42wJ0ksADbTU2Phx964AdnE+8GHT/yktoJeOsd/Ffe7m9T0C3acY9EPXujFqtAKzz
         6gq8UtS3zXOjY6Id1fv7BFUl51nsEZNKL1Oydx+gsGcDXseioaye18K2LaxlzoEytOZZ
         7eNiBNI38YykWKzG2acI62oNgGB3GODMgkM6c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795514620; x=1796119420;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cGN5g9PtUGCG+wcdSVJumY3ZUtFUe8Es3+mlikmGYwY=;
        b=rXqGf+RyLzXVxHeJMUHaLjg59S8s7dDxL7wixV05TX+hOh3rmqR1FPmeYQiGCCoDzY
         b9uA4rmn5/9s7OT4UTdTtydgWZ/ET3CLxfIViC9dXQ/2DbyxnBdU4KT1yAAXfmRFatv4
         K8ybjr1mQ/X6lKS6mzpNwqJXamOFmu/DkKK9PaBHmmeTi8+ecQV/h9E7tVEgaehV+O+K
         xv7RjcMWCBovhEsmOd3vJJMnk8//7zFKbDeDZ2YdfuR/Yqe1xryRwRramNIYIAFh4EEc
         9pFoyiZ3G5iSjQyH7RmrumknC3X6WYlMAJW5JGCmqsFQ6a43x9Nxl/+jGnSg0xHGWKch
         PCAQ==
X-Forwarded-Encrypted: i=1; AL+hErGG+FoJ0FnSYR646NKO007uzYChq14/j69zyP4r/LVRrubbinA955gM67OV5go50XNHhU14WJOmGA==@kvack.org
X-Gm-Message-State: APuU4Z/ILxrSSm2wZSArt0Wo890SMmclmAFQnK3VlaaGCuvnK5tfOjk2
	bahUgub/AgQGJuHkW8Nd6ovsP4y3N6j0GHa0SlvOOG1p0OEIkoNob3EcaVQLa/hY0h+ehCEief7
	T1slAzw+pxlhLsPn1cJeV4LA0yNfgabOe02HSoyi7
X-Gm-Gg: AZFdTZe+wwasicgdEWlxANRUkOITXCD4qKtviywnA/hQiN68kRvyJxcW7m/sVaIzJ46
	tGfPYpCJ4U8lZp2fF+ogKmMiLhDkjmsPLgmj0C46/FLTM8QhlSYPgzH5RnSow2HC5+FnXwV4uaJ
	VZD4B7v2v+eqSXVxreaOAMFwnQwEJNQbRvUUaE+MivK9KYZ2lD4XTT4VmL6B47h7XuOFIQTL4WL
	fTk58a/PTaPJdULu+i1+pdzI0wth7tRntHQMXtnu4ecI4fuHh5SpxTZyM6UOV3Qd54AO8BdejVP
	92RDWkNl3jOrNApJDwGH7WTbwIcKlfALyrf6sx/1EpPCZ1avyBhy3Ne1D0BSau1a45H2d2uLzRV
	/UEMRZNee7CL00BJ7cZMSugczed7gBWBxWKHKW1S1otmXTSidI1nJL4qk+m/y25nzAu6QN9RIIP
	vTIS7HAPf0fhCi6kBcn1v1
X-Received: by 2002:a05:6a00:3c84:b0:89e:ba55:119a with SMTP id
 d2e1a72fcca58-8c87d123bd5mr13499490b3a.47.1795514620227; Tue, 24 Nov 2026
 02:03:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6b051681.58b41460.7037.0590.GAE@google.com> <DN37NBGPJJG9.2DSVDCKS3UYTV@gmail.com>
In-Reply-To: <DN37NBGPJJG9.2DSVDCKS3UYTV@gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 24 Nov 2026 05:03:29 -0500
X-Gm-Features: Aa3M54qvcfjcRlRGJK01N9tkR68vSDtEhX-HABSVQSN3K_q0am-4DoB8x5iA1ls
Message-ID: <CAM0EoMnVa=xGD3uiZKuzMfFL6oZNd=Umb0U7+_QUrTK7Ej-BYg@mail.gmail.com>
Subject: Re: net: act_gate bug. was: [syzbot] [tomoyo?] [mm?] INFO: rcu
 detected stall in security_file_ioctl (9)
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: syzbot <syzbot+b6f8640465bdf47ca708@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, andrii@kernel.org, bpf@vger.kernel.org, 
	brauner@kernel.org, daniel@iogearbox.net, jack@suse.cz, jmorris@namei.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	netdev@vger.kernel.org, paul@paul-moore.com, 
	penguin-kernel@i-love.sakura.ne.jp, serge@hallyn.com, 
	syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp, 
	tomoyo-users_en@lists.sourceforge.net, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 93E4240005
X-Stat-Signature: fs9ytqfn7dcuk393dtcki7xh7urny1m5
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795514621-241509
X-HE-Meta: U2FsdGVkX19OOuARQ9tjUPk6MK4daDXZWTBA3VL21v4CtcKI/mzqdIGogsOHZGQ8EtRFwEmQU0mSEVH+uzp45jIxp1YJ4FBUNXzfTmPHOmy2CinjCJMAUmry3olMvdJLi0pnxNjng+PXQm1cgNchWUM0uvmRpnyvQaS8aa2mIMW6AWDD+X37/H/WzCNUg42LrVrKScw9AkvDsHm+izSG6AicMoNpst5cYYZOBcO1AtA3J6MK4mYNN2m6o2zEIoC+9Zn/sj3AY/qVwm4wg+NU4jdHgGPunzPP1VLKE3zZ0ETvtoTIvHOKgfif6Yu7nNdnWCn+l8vyeEmajpBrMOiZWBzrHOCbnbyUHmaYCq3TNDE4fqKjPC/St9FdhLo3cgKrTcc5jRycyZHnTq50KtlgYJvv5S6yztMloLU4OaSUsSlcGjdHbvq3cwx15HUPAhB5kcO2QL0ng2iu2lcjRLG0H3nyukbyFx/CKYdZGtAZLda71Ivcim8cGH2hQdEws4Q8Pqk2dfQUx8v5mx37P7qnqSwAsgUu9R56dx2BEXuQeWCd1C3BSf+aMrJBckkxtWRk9UewGPgCwN0CrBVgqHTrbifvlJ7JVdpxKrnIhiHk2pHb7DAylg2XrWAZDxrz7c0WIvkDcI/dh/mGAazv/Sz16CT/qfYaU/n1kjVEryvmbOBeTRqiIZAw/XQsvhDXe08fQnz05RryRNnKWnGtdz9fbzMJC3mjUwr0uKEjKsZfnU/DWlLduL1vt/tcGsXWOKywlvpIHCdd9KdTEXGYxz/JDnyPkzBBIk4YlvvDqNFPYx1gAs7aFPNZzRd3ykI6qMGt+Dt0GcPL7Z8EoXUJ5cLRw+2BZbZy//YLswc/a6jiJyJRSTDadY9jx+k2CeTQjbXJ6Nk5HNM4LZOy1ioB5HNmKhDs6hgQJxIOUO0f3p1xItxxrI70LzfQoTw+yY6dlCMyaako8W2SaC4spIdxP/b
 K7sXF/zJ
 oHcNZvWLcEDmw25B1rXt7bvIBajppDkqLTz2WXrrOCpTG/XjxL92+xgmuQrYNOdQGs2FNn+1HSgEJmtdleYxI5TQ1eVumoAUK3glqu/kltoINKLQDwqc/xwwj2ccfBla6KAzm2XWO8gurOox4+HLKHKEANY1nxW6Uy2MCAqggVas/qGzMg8RiDTp6jo7R5Yhw78Ss2hBKwM+2mWQ2KmNN2GuGXtT7kpuWh2EOz5hvjXcsNBHLQpSuU9/onoUqqYYAduEcGAgc++B36ezz6F/soipbPK1xT3YsXnJ0y/LmLk1JVhB8CYrClC7YQ16Dx31BpoCCWrXRBvTYaegf/aKx25UHGCuENt7vunOHsQUCa7DahpGljy+BGEHu0qaV20GPuMqmM4mA2N9SE06/ohgAS+/FeKGPlPxbRJ2X3AmU5hodD+KSS2XGN6yq+ayJWnkuo2y+E+Iw3/KpEfASlMcuA6sfXF8zgF/VJiUbXlOHJoCQtpeLi46Gpx+912Abc4nBIpdA4qwZDXLtthYYHOgRQivPhxDWYihxEYQQs0PkL3RjtE0AInpEtwY6teREa9d3HmfPUEmnY7CqdvNxtiXedpjZJyyuuxriMxYZA8JhKRlWjgkTb9TaToy5zdlOoe6VXqnxFP1sUokpQ0T3smbUQIzipsZlvy9hHsuQy58YBYO7Q1ka25qDW28hEJD6LId/ohPY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 1:00=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Nov 23, 2026 at 08:45 PM syzbot <syzbot+b6f8640465bdf47ca708@syzk=
aller.appspotmail.com> wrote:
> > rcu:           hardirqs   softirqs   csw/system
> > rcu:   number:     5264          0            0
> > rcu:  cputime:      138      52351           25   =3D=3D> 52490(ms)
>
> It's not tomoyo, mm or bpf. Looks like act_gate.
> Zero new softirqs in 52 sec, so one hrtimer_run_softirq() doesn't return.
>
> > RBP: ffff88807ed35538 R08: ffffffff91be1bbf R09: 1ffffffff237c377
> > R10: dffffc0000000000 R11: fffffbfff237c378 R12: ffff8880b8228600
> > R13: ffffffff89fd0480 R14: ffff8880b8228600 R15: 1ffff1101704514a
>
> The registers with lockdep struct sizes:
>
>   reg       value             points to
>   --------  ----------------  --------------------------------------
>   R14       ffff8880b8228600  cpu_base
>   R15 << 3  ffff8880b8228a50  clock_base[HRTIMER_BASE_TAI_SOFT].seq
>   RBP       ffff88807ed35538  kmalloc-512 + 0x138, tcf_gate->hitimer
>
> act_gate has the only soft hrtimer that can be on CLOCK_TAI.
> bpf_timer_init() rejects that clock.
>
> TCA_GATE_CYCLE_TIME is an unchecked u64. In gate_timer_func():
>
>   n =3D div64_u64(ktime_sub_ns(now, base), cycle);
>   close_time =3D ktime_add_ns(base, (n + 1) * cycle);
>
> With base =3D 0 and cycle =3D U64_MAX, n is 0 and close_time is -1.
> The timer restarts in the past and __hrtimer_run_queues() runs it again.
> It's there since
> commit a51c328df310 ("net: qos: introduce a gate control flow action").
>
> Jamal,
> taprio's INT_MAX limit doesn't fit. tdc uses cycle-time of 600 sec.
> The diff saturates the sum instead.

Looks familiar - i will take a look.

cheers,
jamal
> Here is a potential fix:
>
> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> index 711cf24..5422d60 100644
> --- a/net/sched/act_gate.c
> +++ b/net/sched/act_gate.c
> @@ -45,8 +45,9 @@ static void gate_get_start_time(struct tcf_gate *gact,
>                                 const struct tcf_gate_params *param,
>                                 ktime_t *start)
>  {
> -       ktime_t now, base, cycle;
> -       u64 n;
> +       u64 cycle =3D param->tcfg_cycletime;
> +       ktime_t now, base;
> +       u64 rem;
>
>         base =3D ns_to_ktime(param->tcfg_basetime);
>         now =3D gate_get_time(gact);
> @@ -56,10 +57,9 @@ static void gate_get_start_time(struct tcf_gate *gact,
>                 return;
>         }
>
> -       cycle =3D param->tcfg_cycletime;
> -
> -       n =3D div64_u64(ktime_sub_ns(now, base), cycle);
> -       *start =3D ktime_add_ns(base, (n + 1) * cycle);
> +       /* cycle is an unchecked u64, the sum must not wrap into the past=
 */
> +       div64_u64_rem(ktime_sub(now, base), cycle, &rem);
> +       *start =3D ktime_add_safe(now, cycle - rem);
>  }
>
>  static void gate_start_timer(struct tcf_gate *gact, ktime_t start)
> @@ -107,15 +107,8 @@ static enum hrtimer_restart gate_timer_func(struct h=
rtimer *timer)
>
>         now =3D gate_get_time(gact);
>
> -       if (ktime_after(now, close_time)) {
> -               ktime_t cycle, base;
> -               u64 n;
> -
> -               cycle =3D p->tcfg_cycletime;
> -               base =3D ns_to_ktime(p->tcfg_basetime);
> -               n =3D div64_u64(ktime_sub_ns(now, base), cycle);
> -               close_time =3D ktime_add_ns(base, (n + 1) * cycle);
> -       }
> +       if (ktime_after(now, close_time))
> +               gate_get_start_time(gact, p, &close_time);
>
>         gact->next_entry =3D next;
>

