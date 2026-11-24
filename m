Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8762D606A685
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 10:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.a=rsa-sha256 header.s=google header.b=j2pscP0x
Received: by kanga.kvack.org (Postfix)
	id 943636B066F; Tue, 24 Nov 2026 05:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4226B0671; Tue, 24 Nov 2026 05:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3786B0672; Tue, 24 Nov 2026 05:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A26D6B066F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:17:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F63714060E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:17:52 +0000 (UTC)
X-FDA: 85469611584.23.C917AF8
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 60BA140002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:17:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=mojatatu.com header.s=google header.b=j2pscP0x;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.215.181) smtp.mailfrom=jhs@mojatatu.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795515470;
	b=vAH5UZHiUSBI3AZSQH8RmIswVh4m2DoTQ5wZk+UJ4qC1NZRjlWWDvdxpsUrrKyD7EV3sxg
	CZ13ndNIwUYx2Mo633PWH+qjxOUQEOmaXbta5o2gWZE4JcO7bHKAHO4XXaCG/75nJ2A2wc
	6R8vSDcLm05hTzLvp7elehft3+ijT74=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795515470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDR7cjV4IRioJgp9xWXyZAeSRy7CXHNvvQiffZPND/Q=;
	b=njNIFUFbhgCNnNZJT75fAmtSFIf5uCDte4KowuHELc+wyezLanKmkcducLKfGfKX/Sl6Zn
	afAyrcENlLif/8ISUZwUs/1fC/mZSBjKu3Ey8FC6UYs3/oA7FZhAqQVVcUrWnoGzBLwKV9
	ExY+fmZvIHeAOlGymNh5KJLEy/+I/Hw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=mojatatu.com header.s=google header.b=j2pscP0x;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.215.181) smtp.mailfrom=jhs@mojatatu.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so1819402a12.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:17:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795515469; cv=none;
        d=google.com; s=arc-20260327;
        b=CU2SLkatvRQtIbWaFBf9gY/MNFh+L5BUS5kzcl1lHIVi7vUU/h96wbLPqM11FTwxz5
         GXvm6jDs5UeFFNhRzvyZk2OWud3ijVo+siIq9rngwJ+VragI4EBlX2G+KqOMs5AuzUEi
         i4XRypXMZrfYfcH+KPvYlCwqgVGPb+c7xARJz6HmbYojX4V/uE+8Lc4BD3rUCTWSPHMS
         M99JEelrXZ7lBAmN4bhOHrJJ4OjoyLecinBiucM/0RMndlNCNpDlEMDvDfkYpRfVpQCv
         3qangichUroKKMHKlzVhvpizSiMc/SB6GWq/EPII4Gev+G5rvPeTqQpIw3Gg6mtbvR7N
         05kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cDR7cjV4IRioJgp9xWXyZAeSRy7CXHNvvQiffZPND/Q=;
        fh=S1EouJNwPqhN5Rsi7ge5/9zOy91hZ95U3J3ZJ5G9qE8=;
        b=d0V2duPYWbwDBPR/JtfFknT7XbV9tMSoebxeA+FwEev+TwTunSUStcaSwfJEha+v7G
         r0fVlP0kCXwMEYhO6tE0jzaAXsUq0drCbUM/bCA6Q4ctUn9qQ9rRAMOAcsCptJK4KH53
         Iqn4rwzF8AYp+sQ3WD6cVR1NJCmDXeydQhWPVShQIHFfoyDyYTBsbS4PUrX6u4WPcBen
         IrNY9Zg7WPgQp39mFg7LVFaLPbu5y0PZ3GdDvhawIeAvJSWCiEtGhhR6fkiLMFP7X0aI
         XfZcORG3r0TCnPwZov2n/zdE210p4VpR/YyaPNUxWl5zW981+Bzgu4LcB4+YTZCessy6
         eB4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1795515469; x=1796120269; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cDR7cjV4IRioJgp9xWXyZAeSRy7CXHNvvQiffZPND/Q=;
        b=j2pscP0x6YbJAklxkn6Wry+g6DVpP+uNO5pKNX9vlwQNpjaKktbyGS5HeP3EnsOk/x
         +XgcyPhkljNDgt8If4HRYfn+UhKUqSFr+de0veX2he44K71Cot+8cACNA8x7JMBkiByH
         88Y6+ZcyiixhzIcv33Ryg2aH/7MxijP7OFpy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795515469; x=1796120269;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cDR7cjV4IRioJgp9xWXyZAeSRy7CXHNvvQiffZPND/Q=;
        b=btaUbc9XXIBg1jWUCLeOxXSQThRKKGQjV3o+ZQA/+UTbKzfyNF6uQiuC1b2Z8m84V9
         nFXCVfBljBc8zuIzLMQt6ykdyq5xWLSAib3xYlg94ekQsrRAL02POOW4eAE2Le86nQ00
         6NGfgy6l68+zQvql1gTCPE0PKs/iZSOcl6pNVXR2km3itDcXaJ223pJ2swKQStr+Lggz
         N9dwThMydjXGXX2o1H065kvpG2heaNc+x8unHK5PHu4olicjbGIwb5LlE6bzZaUQKpOp
         +Q0umxB+528SYQpVNMHEeA5h2w56zZW+yG/B1LSWSIzGlRuHREz0ksoCh9Lw5aMwQOjU
         nH+Q==
X-Forwarded-Encrypted: i=1; AL+hErExj0BwUQGqUlCeBmWkO69AzKZFnnjL/WpXZ/WtOCkJNu0LF84QCtb6SbeLGcfzwgBqbt6lIUrdaQ==@kvack.org
X-Gm-Message-State: APuU4Z8h7VofanOH+mcKxjSYcG0DKk6NUHSo1HPp/sSMMOX44r9QA5Sk
	USgFvs5j9mF9QS+Y+1nAvfsse0H+rjuGZLpSO32Zb5+xZvi8QxH7nsavxjl4M2zOrm+kG/JV3O/
	aHKpDccgJEOrtXNXbnco+Nf+lOiRRdKFnZR4sAeQ1
X-Gm-Gg: AZFdTZftawgSCa5Kn4xaFzB1XDxb3qQ/CZlu+jZ2VXiyJrv9JrSDHGRlf2j90H5nE46
	zxFXmb5g47P09HEQmtaR9DmJ8EBJURLMIck6A7DSFp+ndYvg3sDka4JPsPIQ+6GAQu5Rt62c2Ev
	HtL3jIJTEubjhBeDEn6cNfZ70sZk2UTsaLxbLjliKaCe6QKmH5xwqjhzuUgLqv8NYRrhuz+paW+
	KSOkzJBN4WE/UckjGTveCqlpjmDnQO+i8OiQheVTM/5k9fdmndil69rLVhLZgV9Bj0bcYxecquS
	x8DsUX+WWR+Vyd6KhC9O57eB3aqtTIaQXX+QBJr6BlPQMC2Fu8RJdZ4UR1ThAOQ6UIklqosQTSV
	dSbOGprSIZS5p6WWi/TZDy/xr33hJvgv/ExpR4dxbpy5oRGj5rdJ3wvWbIf1Q7D98vu9dOh3HwZ
	OdEXBCb2Yw+RuO4q/ijDGD
X-Received: by 2002:a05:6a21:4a8c:b0:3f2:acd9:132e with SMTP id
 adf61e73a8af0-4014db57e24mr12442219637.61.1795515469040; Tue, 24 Nov 2026
 02:17:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6b051681.58b41460.7037.0590.GAE@google.com> <DN37NBGPJJG9.2DSVDCKS3UYTV@gmail.com>
 <CAM0EoMnVa=xGD3uiZKuzMfFL6oZNd=Umb0U7+_QUrTK7Ej-BYg@mail.gmail.com>
In-Reply-To: <CAM0EoMnVa=xGD3uiZKuzMfFL6oZNd=Umb0U7+_QUrTK7Ej-BYg@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Tue, 24 Nov 2026 05:17:38 -0500
X-Gm-Features: Aa3M54oAhgDu4a3QN-cUvm8ntTPorq0ToGdV6xzEFC1H8I-IekXAnPLMj4fFDqA
Message-ID: <CAM0EoMn=ZghG5KFu2Nc=W-=KjDv=epspFHZVDY4ww5a9GBUaHQ@mail.gmail.com>
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
X-Rspamd-Queue-Id: 60BA140002
X-Stat-Signature: zuxkw3g5ac4afbjbdh6bdb1kiejrzscp
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795515470-267305
X-HE-Meta: U2FsdGVkX186s4mwyxk41hA+49KJG+DtdvZ2A6ZdE4OXx9d0JinVOLht/xKVTPMOKO32vKk82M9VUuxe/o6m0ae+SDGTZWWJb/cPUYRP275rvNKqCnBvCNP4c0FclqygN2WX9cwSupMZMcazm6yGxLZKoE8jkgkPkNy1rENdU+A/mwQFjTa3z7GQNieDPV7YmSUwB8ghGd0U+OJ6DIrnBkCqa3lDihdMZAx/mAY1XWjxwIRmQgcVqmXeYHkw5W9VtXPj0GMvkeLO05EGWyeFROc1olnaDiau3easpYx8lYOMdbgByn5gKNEAKPBx3kfrU5vwVNnuY/m6RIg6VvMeVZ/xmjJ69ilEfrSFnWTcBerifHRyvGnritTI83YEtQGJzceQ36WLJYylU62+pLof4zjhbozcF79c4t5Tpblg5Uq0PSEiKo8C9wBy9Csfvn1yMowEojEHizAoWGqzE8McBleB+8sdsQtQD6tnxTtvme5dQuexKfPhvlkdRYO8O2CEaNZl/9rKYAWiBpbX82Eq28yAuh3MRwt4cJDNu0G70fS8fcZn93G/j71Q8e14WwdXP85AYoUTv1MphCFwFsspOZi6p8HDPRMUa/8VHydYq9t1J9ApE3oydvR27sZgGF5gTEYJmXGWNX6ONaBLHEFoz5n1oSMvMmA/0+XrO5xoCXDQTCAJrnaXZO3r6FGajkgXLFACNKXu9Zwzs/FYNS5a8ynegScIt6526hWjHAaK8rdPRx2jxoPhCwCIkqiqIAhrJUNUG82lVhMMvJwzw6aNGfi8iEMjwE6ZYgfW3Ew9mlzyoB8PhC5NPzd6/kpfKZRHvSV3XK4n/otb8fyk0nJvchKh9AK0pEMum5f9kgwau7x5rkzGr67ntKz7Az6LY/gE39Jj5ShPTLXuYbNEafvrQjF/GgDtZYafiKMjvLHCko7pKm9HPZq53p63PW4BKjyJaBvYsTZNhhGndJy3d+x
 3sesSD2i
 S0r9W9lDFSBvcF9cjDlraZBDTHuk1dZCMKhz6rPCrVQt8aoZmONPc8DTNVretzLn2cKPVvCcM5/FJ4EmzYdztZufSFDgGLGHsSHVtbPxunJH8m0uIAGI90orKFMgl0yzzSsu0eikHu7+hv8lfJknyMUM+uoZTs6p4T/J/YwPpstVVeA85mNua1b3mxfztJNtjDyvrb3eKm4hGeUu516WtzuKHBoAq1VrNF7Xpcval1qniKC3+vbDtaK4+GPleOfI8vNfNvWSRDfe2eV3Q8sL5fM20y5aUfzeOsvFKk6hUqNt9vHXiwaSFGfK6DWO3WjYCTNvwc+vRWL1arvWvN8lmm/b7Oz96a67eFgk3udTlqjowtdfdE9Eq7lWGsh3YHuzGnvASuliqE6MaQyfdz1+VDkCJOwasOBMYpnQLE7slC8Da2qslTjLhQxrU5xP47vfK1zwqFwHZM9L5SlCoB6LukGHb/O1M5zuE0Rd0nzCIXTSysVqTgTHCoOe3tOAPdI3HkS86NKRIGEYAJrVVIc47/jAOT1ZKI97bYJ0CpWt4uP0HqgWQgtSHY62kq8m1tlaUe97h11f2V7xFNPOzD7s62/q/27m028Iasbo7g3xZWWAubQQCsz94IzFGMw5sxElMKI4VmV8Pe84eHiYpub5+r18mcVm9t9ROFMMV6K95Nlk1xVFrUNojEvQ7JIGY5xouYBF8xFhP9LZOZDE+QbMpR0u23V0dfOphnj/WBWDBsAHC9VTbIEAw2qFRKylQY9lR3xM65emKxbVaHbpjIJ1aTjS1y6K5PRrm+iP7IV7sVjvpYRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 5:03=E2=80=AFAM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> On Tue, Nov 24, 2026 at 1:00=E2=80=AFAM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Nov 23, 2026 at 08:45 PM syzbot <syzbot+b6f8640465bdf47ca708@sy=
zkaller.appspotmail.com> wrote:
> > > rcu:           hardirqs   softirqs   csw/system
> > > rcu:   number:     5264          0            0
> > > rcu:  cputime:      138      52351           25   =3D=3D> 52490(ms)
> >
> > It's not tomoyo, mm or bpf. Looks like act_gate.
> > Zero new softirqs in 52 sec, so one hrtimer_run_softirq() doesn't retur=
n.
> >
> > > RBP: ffff88807ed35538 R08: ffffffff91be1bbf R09: 1ffffffff237c377
> > > R10: dffffc0000000000 R11: fffffbfff237c378 R12: ffff8880b8228600
> > > R13: ffffffff89fd0480 R14: ffff8880b8228600 R15: 1ffff1101704514a
> >
> > The registers with lockdep struct sizes:
> >
> >   reg       value             points to
> >   --------  ----------------  --------------------------------------
> >   R14       ffff8880b8228600  cpu_base
> >   R15 << 3  ffff8880b8228a50  clock_base[HRTIMER_BASE_TAI_SOFT].seq
> >   RBP       ffff88807ed35538  kmalloc-512 + 0x138, tcf_gate->hitimer
> >
> > act_gate has the only soft hrtimer that can be on CLOCK_TAI.
> > bpf_timer_init() rejects that clock.
> >
> > TCA_GATE_CYCLE_TIME is an unchecked u64. In gate_timer_func():
> >
> >   n =3D div64_u64(ktime_sub_ns(now, base), cycle);
> >   close_time =3D ktime_add_ns(base, (n + 1) * cycle);
> >
> > With base =3D 0 and cycle =3D U64_MAX, n is 0 and close_time is -1.
> > The timer restarts in the past and __hrtimer_run_queues() runs it again=
.
> > It's there since
> > commit a51c328df310 ("net: qos: introduce a gate control flow action").
> >
> > Jamal,
> > taprio's INT_MAX limit doesn't fit. tdc uses cycle-time of 600 sec.
> > The diff saturates the sum instead.
>
> Looks familiar - i will take a look.

Ok, found an abandoned related thread in my list:
https://lore.kernel.org/netdev/tencent_FAEDEECDD478AE6DFC2DE96D389440E96A0A=
@qq.com/
I will take it from here; it looks like your patch is still needed and
requires a fixup to the abandoned one as well. I need to reproduce
this first.

cheers,
jamal

> cheers,
> jamal
> > Here is a potential fix:
> >
> > diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> > index 711cf24..5422d60 100644
> > --- a/net/sched/act_gate.c
> > +++ b/net/sched/act_gate.c
> > @@ -45,8 +45,9 @@ static void gate_get_start_time(struct tcf_gate *gact=
,
> >                                 const struct tcf_gate_params *param,
> >                                 ktime_t *start)
> >  {
> > -       ktime_t now, base, cycle;
> > -       u64 n;
> > +       u64 cycle =3D param->tcfg_cycletime;
> > +       ktime_t now, base;
> > +       u64 rem;
> >
> >         base =3D ns_to_ktime(param->tcfg_basetime);
> >         now =3D gate_get_time(gact);
> > @@ -56,10 +57,9 @@ static void gate_get_start_time(struct tcf_gate *gac=
t,
> >                 return;
> >         }
> >
> > -       cycle =3D param->tcfg_cycletime;
> > -
> > -       n =3D div64_u64(ktime_sub_ns(now, base), cycle);
> > -       *start =3D ktime_add_ns(base, (n + 1) * cycle);
> > +       /* cycle is an unchecked u64, the sum must not wrap into the pa=
st */
> > +       div64_u64_rem(ktime_sub(now, base), cycle, &rem);
> > +       *start =3D ktime_add_safe(now, cycle - rem);
> >  }
> >
> >  static void gate_start_timer(struct tcf_gate *gact, ktime_t start)
> > @@ -107,15 +107,8 @@ static enum hrtimer_restart gate_timer_func(struct=
 hrtimer *timer)
> >
> >         now =3D gate_get_time(gact);
> >
> > -       if (ktime_after(now, close_time)) {
> > -               ktime_t cycle, base;
> > -               u64 n;
> > -
> > -               cycle =3D p->tcfg_cycletime;
> > -               base =3D ns_to_ktime(p->tcfg_basetime);
> > -               n =3D div64_u64(ktime_sub_ns(now, base), cycle);
> > -               close_time =3D ktime_add_ns(base, (n + 1) * cycle);
> > -       }
> > +       if (ktime_after(now, close_time))
> > +               gate_get_start_time(gact, p, &close_time);
> >
> >         gact->next_entry =3D next;
> >

