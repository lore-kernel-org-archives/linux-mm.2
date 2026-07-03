Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 183A7C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039636B00B4; Fri,  3 Jul 2026 08:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32C86B00B5; Fri,  3 Jul 2026 08:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3A06B00B6; Fri,  3 Jul 2026 08:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB9886B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:27:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F8114051F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:27:00 +0000 (UTC)
X-FDA: 84947389800.30.AA8A580
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60B45A0004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:26:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=g5b80To4;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783081618;
	b=Ixj0caZG4RD89F30hemIfntTHgFwLRESbbFKlAYy13BelC/jtawakPkeD6ErtrmtJtWtKO
	jWzPARmqoJO+Y0u/mOsq2cZas75RdmYBTxEofhFiddncSRnOjqf10vvRcENma2gI0Q0Y3s
	mZaZWxNL19C9nwrjJCrdp5VfptVtaVI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkcwegeSHRA8Rtq4C78mf0gL9tHt8vO0ljYRm2yfd08=;
	b=vocwa0qTPYyOltqypdNWJxoa7oJnV2zo9lUquCAhX0PCQlWngDceMAMevSKsiwYcmRvgNz
	z3XHeaejpw3+6AWNLNiM6Eo2FkOKfGXoyQKsQkHcHr4odh6Nrxr5HT0rv8fFU87TdkTNsC
	BUME377YqjYWKoPLiX+PctlZk3Fh04A=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=g5b80To4;
	spf=pass (imf25.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-448cf99c133so1226504fac.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:26:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783081616; cv=none;
        d=google.com; s=arc-20260327;
        b=iSWyQqbmRknSTLj8jI8liq3Wm1qrYr/rglbxjunbQylkk0B/p2iGAbPd5QdXhcvn/U
         EggPUxx4fHQblfBYnHpbbmhoJoqH0rQMvBnDkfnGEpybbOxOHpOUyFipf6Mx1/i3fGg7
         J0i/WqqWsX3TPQKF8j//zyvWwdpgmfjWq4wzkBn4fPLd2EhYYzJiUzxgn7kO3IRq4ZXf
         6Wnk4H4E7S0LtoMUEH4/zUvuFSLYDSV6uSjkSotZqMkJDHcbUGRl6qPLpEL1ZrCpnvS1
         niobZmF7Gab2YRIUKh8Yvk7UkFUPhfOpcCSdQteyrN4+3vgo2+rOS0I9Gi8Q36LJo2Fo
         ucTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mkcwegeSHRA8Rtq4C78mf0gL9tHt8vO0ljYRm2yfd08=;
        fh=dR7npzASdHEBc+w/pHnfUfa/dFi/RR9LLWnLXm2XaFQ=;
        b=pDmIqFW34c73aHtpMmTKoWGa+jnb8xFXNpgHgr8+PXVzG90aQj1e6UnAvSj4aucrxg
         SiXihLxjRL44EZEhzbnOqCdPfVQbSjLRqKRO3AnEBgRFaCbmrAIS2+lnYH+XJG7Ks3e0
         0Nu6wixNMmfSSC7Q/+YLkWQg3hjG1b4sC3LTEAhWJGxp+/zRayzZWqfV6LdblIrvJpvq
         7+dx40cWXDHqGIHQv9at8hJHwjarE5EXer/nKTi32WMnvJ+glnJm0yn+picIvvl8PSEP
         IM4VQDNuRQa8KB4nff4zYwH9fuBALkJoSmP2G8i/77zzc7XeGvxyHLxuCEU59ez7eUbA
         5qzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1783081616; x=1783686416; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkcwegeSHRA8Rtq4C78mf0gL9tHt8vO0ljYRm2yfd08=;
        b=g5b80To4ZBarPNTxRX3y6tIasS3n1wdmMWEjS0lArTgnGx59+nwikh06qzARscKhPU
         GrDoqLaaMjNmz+HdnYPdmjWq4gAtmbCsWa0UU5M/cwo07cgpWPTQ6brBmBjYp7IeT4f7
         HTPIRavtgyjokIo5DBYmFZzD+rvSD4BriAEruOJtXeFFZKf6l9IsAOX2ZcmSVnkNpdx9
         lo/G1PPfAI7+ROikFI0f6AuzK4w5hNjNIvuEOqA+cYpVMx3nouf753q8yNAngDOm1ii2
         a7JDwv8vZ3NMwLyGfK23dRYhgHPVp8QEpprKfN45R5g8k7zC/D8kXWIiFPcNO51XBKW9
         mqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081616; x=1783686416;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mkcwegeSHRA8Rtq4C78mf0gL9tHt8vO0ljYRm2yfd08=;
        b=hK5ks09xZr8/2gQH2dC0YEl3R9ISvPQes0ilJJ1AFxCv2245Fa/XRmWK2Rolh61t74
         PTSLhrRPYVxlHGbzlRsY45M2QUZAw/v+eCUHPis2Tszye/bIgblNCmadgDyl+ZFhmEtI
         8QXIR58SmkXstbfbBtcJiJmqB/fX8U15UUVRJd2m0COn77MC6+SR4fJ81MjiUHJTVfhC
         RZXJ/oXFx348L+ZgI9RAGe1vAa4qgMYsAgwob+apGPLu5Tub3RAPqkjiInWjfvL737vf
         PFV1EBKoEM5JDYmzdxYqrHs5+tl2XliMrQ3wCcLBeTAnFjFyJzBzTmjYfnuMRI2YXKS1
         Nxrw==
X-Forwarded-Encrypted: i=1; AFNElJ+5+kGe7chy69e+D+Y2W+f+OyZUNcNXyWw8Kbg4vyQl8eycdVkSjwjyQ4MB3SfYs2AvYf4Q1jspFQ==@kvack.org
X-Gm-Message-State: AOJu0YyDQ8SYjZ5BQDMi7lWvJ1RnL/bZoOuydwxPvmFDRj4qdLfEc90E
	Q+mbqnUAbwm79wBoM8YWKef2HNOlgHEXuHGJoL+9ABla/nS9Bqr2LOYAyPDd9+a7RSdXFV/DJMF
	V+q8w8fzxQVHGKx7TP0va4O4x8wkYCQ5aDTYCm6/Fcg==
X-Gm-Gg: AfdE7cmo8JiSX+vtTAZQqaWNNwQl3plDkvFPRM6W7dmgDGMuQpNc26Eqi6dBYKx8IC0
	kH0ThYxvzManR9Ha7Kvm0JTDombc3khYAn5yaLd7sBVtmhLqVVE0uabiNyIfMP+TMNgL/YMXzyk
	Vs+vf8eKYemW5nZq/aMbVCedJJ//LU9pf+J93r/0VRMbEtBKaROJz4XH+P6imgi8uQJGWD36n16
	trIcT4RLjsFpVh82vCZSZ6lt47SyT0Wt6XwLV06hZRnJHEpXCgXkMfjvXDHTNCntVvOkfjBGFc4
	dLS8BEXisxqADg==
X-Received: by 2002:a05:6809:6:20b0:496:100e:35f8 with SMTP id
 5614622812f47-497e1e43cedmr1478072b6e.21.1783081615982; Fri, 03 Jul 2026
 05:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260702025443.83389-4-cuiyunhui@bytedance.com> <cee66b78b5bad62e6107ce7579d7e613ad05a258aef8d0ab279b706543651a13@mail.kernel.org>
In-Reply-To: <cee66b78b5bad62e6107ce7579d7e613ad05a258aef8d0ab279b706543651a13@mail.kernel.org>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Fri, 3 Jul 2026 20:26:44 +0800
X-Gm-Features: AVVi8CcDmMKspGUBCgXqug4CkmXz20IK78kFtcg22LCfN8fJHodpSJeX2_dNFaw
Message-ID: <CAEEQ3wmTJU1-5e81fy0wnv6gCP4n0cdydOW-Hj7pFJxhFj+6MA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v7 3/3] riscv: store percpu offset into thread_info
To: bot+bpf-ci@kernel.org
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev, 
	jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org, 
	thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk, 
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, 
	conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com, 
	seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com, 
	cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com, 
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, 
	morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn, 
	llvm@lists.linux.dev, martin.lau@kernel.org, clm@meta.com, 
	ihor.solodrai@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qfoxb98a85mu4kn9719umd5rk3ty8jmr
X-Rspam-User: 
X-Rspamd-Queue-Id: 60B45A0004
X-Rspamd-Server: rspam05
X-HE-Tag: 1783081617-385002
X-HE-Meta: U2FsdGVkX1+ukoKUwDHpJ36mZN5OY1lQ+Af3dHZqmAn4wXcxReXkIigfXCaDgci1MKrkAD0lfIfXUuSgnroLBVI6IEuzoYPCBDfgkToNK9C6IIi5yTd+QUNXiWDdh4o8GnoC0+YdcJhOy3+edB+hpehjpOdKvloS/NG7SFWmlHKOx6K/F0xJnNJW9JsE3DZFZpOQFb4poYwKKqsiZ9YSgZKdj8b0IV0FkSjj36O2iGQAw24pv3IliqHx5NjQdWijezx8TvI/6Os3z+829Y+A3Jo/4H56bdvOkbGCWgU1wk0mwitIFoECziOz/FX18JTTzesVI8La0RktDZJat73WGoYB2EJnWn4x3ZIt+sJqumZjJftDVlWqJSFoQtCnCIsHYsHJahq4yVbSPs/ZZl8FZ/GUHWOg1Hc7yV4QC/04F2gKh25hpLp98q9icdHztYmHLhDjVyDb1fwuJxuiTQ/EruKArZ/VPlQ2Two1437slcFPI8+n2l6nZR2BBCqFt04aen5Kdyd+ZbCttMQzTgfva4k1hMWe/rZTSwX0PZ4vbgNTD4d9nEMAlGbYBndRehHWIwYd/H8+eE3BSZZgUp3ycdH5LaQlSmNEalY0AA9hoWMj0ske7+pCb3QqSO3Ck4bMFYstwVKLOv4sM35eeaTZOdpf7CrxQRlZCUSIhNIT5I3YtmhfCnRO5En7s3BZfanK6+NTCjiC6AwIXtEPcNqD8ej+wgbkiiPoAm6jYOjB8Jxu2IrO56/5OQDJsHimishCjdJYSFmuJm8oUwoOsF0BJsSC7j4ILSpcLUmV0z4X5OCr3mbAIUN+WIjzxGON1p1V1R50DeTcqrN1OaZaba6IpEOL6a+REOEZi4y9r9AuORMgFnvPcbRoi4ROOwMduAdb0e8i9bZJKUxVNeipSvQ7rBpd+TqDpyzSWkskK/z6uQZ9235Ru7zmfOEj1+04/ALy5Trq4vjuNPkQQ2VFr3w
 KI5x+yM+
 C6pX9OABwNipESPiZMLa1EawFzyBWG3oaPoRxAOmlpQ7+78wHkV0EqL+yrugnKcAAJBjw8xsGMSwmU/i5nbNZ/wdffdo+DvUPgqEmRlDpNJoecTyeIxHE7gj5FuXkxG+ovW2wDJMtid3QZo7BsWna+WvyTaDGskWW8XEkp31HyZv+8Jxj7041KfhewhhqjbBt5S/YGjKPrim+OzZ3hoEEW6ZC+oXF1mvK41SxCOhr+MbtQH0RhmkmWw/zur2IKOIMe58lzFr5R0zPvNJ1O0RgWaAh/YB/lGm0sCzAv9l7+vcqWP3nA+a8yESRcNk4l/Iu9jnUtY1aKFyuGNhEw+DPhwYXKktg+arVqv3aT9zNEFA3s9qy9MxcbHTCL1+ep1zBtBwcfCgcQ8VUVJx7o8Q02xeqP7NEaOlBnJiSzq+QHSu+SgV3f6V9fx2rNjNhjq86WrzZLBDg+VqGV+brBXMp/fK0pjSBM+mDm2SbSe78lLb5e6wSILxYnN80ruyUiN9V9+D3kY6iMuAzcVDdaxYm7wLv9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi bot+bpf-ci,

On Thu, Jul 2, 2026 at 12:08=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.=
h
> > index e9e8ba83e632..137a49488325 100644
> > --- a/arch/riscv/include/asm/asm.h
> > +++ b/arch/riscv/include/asm/asm.h
> > @@ -91,11 +91,7 @@
> >
> >  #ifdef CONFIG_SMP
> >  .macro asm_per_cpu dst sym tmp
> > -     lw    \tmp, TASK_TI_CPU_NUM(tp)
> > -     slli  \tmp, \tmp, RISCV_LGPTR
> > -     la    \dst, __per_cpu_offset
> > -     add   \dst, \dst, \tmp
> > -     REG_L \tmp, 0(\dst)
> > +     REG_L \tmp, TASK_TI_PCPU_OFFSET(tp)
> >       la    \dst, \sym
> >       add   \dst, \dst, \tmp
> >  .endm
>
> This isn't a bug, but asm_per_cpu was the only reader of TASK_TI_CPU_NUM,
> and it now loads TASK_TI_PCPU_OFFSET(tp) instead.
>
> > diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-of=
fsets.c
> > index af827448a609..fbf53b66b0e0 100644
> > --- a/arch/riscv/kernel/asm-offsets.c
> > +++ b/arch/riscv/kernel/asm-offsets.c
> > @@ -38,6 +38,7 @@ void asm_offsets(void)
> >       OFFSET(TASK_THREAD_SUM, task_struct, thread.sum);
> >
> >       OFFSET(TASK_TI_CPU, task_struct, thread_info.cpu);
> > +     OFFSET(TASK_TI_PCPU_OFFSET, task_struct, thread_info.pcpu_offset)=
;
> >       OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_co=
unt);
> >       OFFSET(TASK_TI_KERNEL_SP, task_struct, thread_info.kernel_sp);
> >       OFFSET(TASK_TI_USER_SP, task_struct, thread_info.user_sp);
>
> A tree-wide search now finds TASK_TI_CPU_NUM only at its definition in
> asm_offsets():
>
>         OFFSET(TASK_TI_CPU_NUM, task_struct, thread_info.cpu);
>
> with no remaining users (TASK_TI_CPU is a separate symbol still reference=
d
> by entry.S).  Could this OFFSET() line be dropped as well?

 Thanks, will fix in v8.

>
>
> ---
> AI reviewed your patch. Please fix the bug or email reply why it's not a =
bug.
> See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/READM=
E.md
>
> CI run summary: https://github.com/kernel-patches/bpf/actions/runs/285624=
50933

Thanks,
Yunhui

