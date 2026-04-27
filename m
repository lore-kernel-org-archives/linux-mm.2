Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3BB4FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74916B0098; Mon, 27 Apr 2026 11:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4BD06B00A0; Mon, 27 Apr 2026 11:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62FE6B00A1; Mon, 27 Apr 2026 11:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C37106B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:27:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7ABEF12169D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:11:58 +0000 (UTC)
X-FDA: 84704675916.01.F91B2F2
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 466694001A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:11:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kT0F6Dhi;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64F0YnLb4HojWEGkjdb+tg09M6nzYeUGvBR151P6gwc=;
	b=Jugj0SL7xVoLFNkaDBpR+8h9fWqPXJu3p5kUv0ZFIZFZmzYMlfiHXusiirxONzUt9jOApP
	6i5J2cx5H+VodFVEUBtW1MmnZsqmff5szh7wGKU7KkIr7JFEPEqMk4boDuHUwc9YaEpIP2
	rZqB00x/Ai5XnojFU8UwNXNziq2f4Bg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777302716; a=rsa-sha256;
	cv=pass;
	b=L1AK0g+m5vwKaFGbnkm+EqgbHsm15juYkDjKrkQYMDaq4Dkz0BDp0ONwk2QpEoioxN9v7m
	pibclHegv95e7Uj+H/umNOfZ48iasnUbfQNhBQrEX9ZUyQA62TZZdETXaZ5KgxAGdKdJ5A
	0iO11C/XwwImr3wisCr1dA8hDMZo+UY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kT0F6Dhi;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d73352cf2so8730871f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777302715; cv=none;
        d=google.com; s=arc-20240605;
        b=bDBHfQHGb8TGjmthOmjrxV/FQvoFH6iyKo7+fTHjiTeiXtPiU+xdVOKDwoDwI8BShJ
         Vdbl1gGLiEy1znwjhaKbuN5AvqAVdcTwO9+iM2lhbkB22QLqudE3Rjdn55rRCy9VkfF4
         sJd8mO5J8LGCDST7AqzgUqpHqw1ETq5ZzH7CTP21aKhO7+qsNweLHiILIJHPWHzddiRS
         VqFZQF2NwCHiK/vyojVFSVjIK3Rx63xgVe5sAJi+ognQl6tGCzRA2JqOEQUA/E5fJubY
         uZMnNMBuy5H8xbubdMuU/X6Ti75xvPx3IaxhT+9MITk/yMzZig33rZ6uBr8ewUgaFb+X
         tnag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=64F0YnLb4HojWEGkjdb+tg09M6nzYeUGvBR151P6gwc=;
        fh=ZsVvspyxJ2HYo7TCGBo7QqhezM43ZwslPJpjWCLfPrI=;
        b=hPhD6nX1FuP1eu+HboSRdKXUvCTaC8hQ3x5VE+HmtLoYybKYTawgdGNSqj8QAWe/D7
         1uJ4cTYVHnQX+JhrVMtDAO/ZsC0pHMNXXCqoMdPN6K3KfwZSdffuXW/0x7WhYyR+zjNN
         9jeofvfXk5mJ2aV1871ijuLPKB2aDi3bk0AmFfwZs62cS9H+whu7456zqJ1r79h1WPY7
         I87w6G3dof1aZZ6SV4GGHEr4ASARYPfcURQMVDSC8DM1GwW2V1kjjKFKss44abv71C1u
         DbwUuWu0eqx93k0Rpuk/FhuyLjX2UvvKBDsoSDh5pE/6DJIdnFMQrcnQuxgta00QDoBq
         s82w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777302715; x=1777907515; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=64F0YnLb4HojWEGkjdb+tg09M6nzYeUGvBR151P6gwc=;
        b=kT0F6Dhi24REVU6fjA+21IbNUV9w7tHtpJu7TdgoI7gFTzIlhDoyFe2g3vx95sNc95
         qrxxGqUlW8qyiSAe2ZmgVrVTPA1bNu7/S/02hPyPX9anpodidQfM51T9nZ8sWTW00gKE
         Qz3Mn/2yVl/uZZibucsl+CT31d7/5RfnhGbBmDYhykcWAdx5WGpXbF03GRnA7+7HqUe/
         ArdnvFz0KID33oYAbnv2yO3Qpkl9uM7K2XCCx1WANbsggHXJiZA+UVUy1Rvj+peYU+hA
         w1T5jZ+XPH4cIM2VAQUcEs0yFG6PpdMA36djhyh/mLWT0SVSMRi8bbWrI5XBGIJXDOUv
         6c1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777302715; x=1777907515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=64F0YnLb4HojWEGkjdb+tg09M6nzYeUGvBR151P6gwc=;
        b=R200V2eQGKd86DUBTBjhWmZWjYMlDuJo+/27uzmiEv3TN7MbU5eLLog6fMD7CevqPq
         PXq0McDg7yxTi9a6Bf89E8MDNJjCul1QNx/yOr9rqjB6qnuoGvYVcoxcFufT1Zcs42B3
         Z9Su+LidNqC1WpUMjoSMTxpWlXh2SsvcUXAxtlFNkL892mgMnX6waBOENXXNRQoQHmdk
         8EUSiRx/TE5Mj1mPPluFmBGZiMrY4U7mDIZ2v9Wc5qPK0GlCnpkCti2TWuo092J8cu4W
         2qC66+JHSd5R76jcRf4tXKDfDoSNW5G3GYuzGN/d/z93YlZ6zZuVt0UioayziR6vtMKm
         f94A==
X-Forwarded-Encrypted: i=1; AFNElJ+EMrRUAzjmFZKNcBpUWa3WIfeVYGm21Hm3BUuELu2daAJgIWFqp10af39J/fFTLA3wy/v50Oj5ew==@kvack.org
X-Gm-Message-State: AOJu0Yx0dPq28nbymRApmUTbl9uuykOh14JToy8EFX7sRP7txS/9RVLT
	tPa9M+KNo4Nml0qltnUJy4dRAL2pIGCZPIIvSGxzU/poXPn8RLUi4kE1f/CKmFuECYYdqyhl3Wz
	LUfjjyHStBuwG5S4Puz/1WBaXITTkHuE=
X-Gm-Gg: AeBDiesQJZMUjZR0DlBEYDX0MDyKED+A8EjpwrnQF2iHzTgMNSCu8hWwBo1YgfIhegv
	Q1oez3989lccRyeDh7/A1IFaUsmqx3C6rv0r7LcA+k/YDqj/qcZGwXD9MORz5guPtqTssCVVspv
	s55uhq8kn4O1DH2S8qfCviTo5eHoKgP0/N3ge6/HO5TZXH7BZgjZlPsDRzSX8YpQiTKcSSsZ6Qn
	E/6FAxOORww3/SB2E9CtVwaXxWF4888x9NESoxHu1jsi+I1XcbGIYPMBPrZocC5slGErVUTQIKp
	YNjb9Me4mMOKtqx7cHmG346/HNqsVu8F1DKe4801OBMYWvRPqAB9+Tgqlmfq1THwr15zjogjLQq
	1XDE=
X-Received: by 2002:a05:6000:1889:b0:43d:7508:c9c6 with SMTP id
 ffacd0b85a97d-43fe3e0b305mr66814525f8f.28.1777302714370; Mon, 27 Apr 2026
 08:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260416091022.36823-1-harry@kernel.org> <20260416091022.36823-6-harry@kernel.org>
 <56381493-214b-406d-9121-f80be7658445@kernel.org> <7101d55e-ba43-4df9-a345-2af579f8e940@kernel.org>
 <CAADnVQL6iajm6L+VzqRB4b-u8OPhQSnUASnfciKGeRR4EDOutA@mail.gmail.com> <6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org>
In-Reply-To: <6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 27 Apr 2026 16:11:42 +0100
X-Gm-Features: AVHnY4KWrDsFBq2kyftO3HGnQXYhzZBBgffaQkMzD3NuOqLTN8McEDAm5pDHVOE
Message-ID: <CAADnVQLLp0bdsu0xOcR+ZPsfq3M_sB4bB8LBq1op0wr+D+yRgA@mail.gmail.com>
Subject: Re: [PATCH 5/8] mm/slab: make kfree_rcu_nolock() work with sheaves
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>, 
	Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 466694001A
X-Stat-Signature: 3tfgsks6ub43gpmogfxtw5tcsddz58ct
X-Rspam-User: 
X-HE-Tag: 1777302716-321918
X-HE-Meta: U2FsdGVkX1+k9m6Ul3Wbgve+dXXzsawvHk8eNItnelOE/1uvkr7SKtb4V7diZNtnhKfSyWOcCdT1B1sCrgg/GCx1cozAaoEOOePRtMYCBbApRtXoCY68+knX1VTl7MIE7iFUFxTX1dcc+V86DC2v28uqrzVWpI7d+0TdD6L+4QQmwsV4BOebHOij8MLplRVBGiQu5fi8snTiIo9fpDSrVxgyDwosGen+uftHti/JYJpFiMLeG65xtVHmhkCOpoZ6OMxTjCigdC8SBhoT7a6t3J63Ahiic23kl7Iplqkca+XguXprMb/yengxsOjWXxu2oB/8TyaxtcSNRtBtREU3AL53yPEbw2fuaMYnL24U6y3OD1LNpu8G3RmCffeE0pif6gUB6Ctsa3UhZ+r6aECkOrqxfyJcpdm2xqlEnttrx2eQ2YU4cQo+iQQVS/aX6kVEcAOHsLhn4sN0h5w4bXXSy7zHWN7w90MdV6YeSxxiLtgNowY5WjN7PcYIS1FzOJYtKa2DQ1fxWegdOpSIs3tQzSOy9G3cFeATbnkRt/4GIRlVUhh9ipTm0IMLd4esqPMQqrTtnbwULDTJhYSbkEIJdy2u7D8ymo0l3CQ7UjERNa4z8OorGFlWNZckOlyPd2PCrVVHgopiYytmmpszRIMMUbbwX4tkbiri+8MGDUsp8Gvohar1I/m1DOPCFDUMBuB41bljZhYPGkXyqTUoG9TMZHCdKP546usaFaDowdlR8dUwY+ue40b4LWPAM5U3lRcOw2Ds41qD+HxU3l/L5voZoE+TC1OIofH97CB64XZ6VKwn25RBIk7EC/BMZagL8bFLhmcIeGkHsgHOENeVbc5YGhdkkGO/VSQgFr/Tv52US4AzBv5q+rwI+1q9syR/QBv7A4k0Iefo2Q1z7ng6cSluFAITW+0Yi93mIEq6cu+tzQNndI7WHMmOJM/fXCJgseSB2PFUIO+z9r2hispv2vj
 Xe2AuNVq
 4GyModu2H+8x7QJ1g1jxhgV1ywTe8amBFoxpmNXKV8yEjcIJJRfWQpq1eWVuZf43fMPDODDzY5R5b5cBbjPSvs9GvzCu6Rw8opHuafv/4L2Mhep4YFQYEaViim5vx5U8W1dFrGFqrd5vLTHsnv5earKe+2B2XzOFrkYRteB3M3sn/Ta/gfZIXqxatm/TlufGeTNIqMZjo4Xf1o8xXE96RBaK82Nc118ezqrKddAi+eVSg7jK1RKy6BYjCu+SQ9kDKcJrhVGb1DL6EJbdaSSikERcqwOaLFBhVd1eql0R1G1f6q5gqanM522mEXFh/nkCBmswrEKjlg2hUuB9VI9hfhzNOzpl26IZYED9uaEfZCW+LskX6V01s9r7F6/ujkbR09jz4UbQiWhO9KQu4mmrkZ2jSyJrD7jjxOMl1cIjFlqweHGxqiszOmkqfSgaBU1YoduSwsprz5l+OmtcH6xbXB/vBT/jhCKLNWY1nX9pKWOGjVwI7beVBq74qn3GBCjrrmJWsluD/WNPYkyMAp40/zaGtUisnfZ9I47OcW/eYZioK03dpUoUoWYKWqepJE99985nzHlv+6vK4Mr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 4:08=E2=80=AFPM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 4/27/26 16:45, Alexei Starovoitov wrote:
> > On Mon, Apr 27, 2026 at 2:53=E2=80=AFPM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >> >> @@ -5973,6 +5977,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s,=
 void *obj)
> >> >>      if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
> >> >>              rcu_sheaf =3D NULL;
> >> >>      } else {
> >> >> +            if (unlikely(!allow_spin)) {
> >> >> +                    /* call_rcu() cannot be called in an unknown c=
ontext */
> >> >> +                    rcu_sheaf->size--;
> >> >> +                    local_unlock(&s->cpu_sheaves->lock);
> >> >> +                    goto fail;
> >> >> +            }
> >>
> >> ... this part, so an unconditional allow_spin=3Dfalse on RT would only=
 fill
> >> the rcu_sheaf once and then stop working.
> >>
> >> However, can we condition this on in_nmi() or something, and pretend t=
he
> >> other cases of "unknown context" exist? Installing BPF hooks
> >> allocating/freeing memory into call_rcu() internals sounds crazy, no?
> >
> > Unfortunately no. People attach to tracepoint lock contention
> > which can be inside call_rcu.
> > As discussed call_rcu_nolock() is only way forward.
>
> Alright. But we assume those tracepoint-attached callers know to use
> kfree_rcu_nolock(), while kfree_rcu() callers under PREEMPT_RT can still
> assume it's not called in NMI or tracepoint-attached context, right?

right. I see what you mean.

> So I think what __kfree_rcu_sheaf() could do is
> - with CONFIG_PREEMPT_RT, treat allow_spin =3D=3D true as allow_spin =3D=
=3D false
> for purposes of barn_get_empty_sheaf() and to bail out before trying
> alloc_empty_sheaf() - this is to avoid any lock activity that's not a try=
lock.
> - allow_spin controls ability to do call_rcu() as above, regardless of
> PREEMPT_RT, to avoid it from kfree_rcu_nolock()

makes sense.

