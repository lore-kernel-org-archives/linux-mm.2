Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C52C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 21:28:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97D66B008C; Fri, 25 Sep 2026 17:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48E36B0092; Fri, 25 Sep 2026 17:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10E26B0093; Fri, 25 Sep 2026 17:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE656B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 17:28:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 141CAC074C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:28:55 +0000 (UTC)
X-FDA: 85253574630.08.2BEE0C0
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1559640005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:28:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KKzlE4Uu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790371733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbMRl28CfB9DT6gF9ur53jbkl2XPiQfbSX+1iQMn930=;
	b=RskOzikOMFAhk1qv3JgBKzS5JSyidfLoUoW7ndxhPm3M868Q6t74Mg6nFWXgDbDKUmvdk4
	xcH2zdmSp+MJI96HmhS9vRy1VUVmtx1ZRSrk4TmG3IvyTzy7rGbW6jGuUlyMJNuWUOBSar
	v/Gp8ZLMiWBkr5XJncuOm25mspoYieU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KKzlE4Uu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf01.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790371733;
	b=5GaPKJ0Gl116msY8JvkkDsF3YVLX/VsmWt8nsV/OhOJiy8gCsDFfrpCZDhNmbmwr31k2i7
	eiN+BDyKfRAYOFhOlquS3WybLp5OKh3XVYf0N7T+m53dhPCLY9WpTpIIdz3OQc1cepP/jt
	Kohe6wEEI3mPr9SUxUf/e0vKhYdkabc=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d3b445a84fso10325ad.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:28:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790371732; cv=none;
        d=google.com; s=arc-20260327;
        b=V6XULcKquClpu+9f7A2GV3PP9gwL31IMm/6l83JktDO8KjFew9qgPV3Ob0ZQcvDIX6
         uTEHDV7IyX3NG6fA3lnL3llLJwJrXZs27N6kaXNaEFZtSZ+e603wrFn/Vc0PrfT8ZfS4
         x7QktQwzNxa2luE1zBipo59rt7LFUVh2J2VmLZI60IT0VW083VzxzYkhAwCR9vMQ94Rc
         smZDP99vM0uUXeOM8ETwjJHdOaJRmIHko6n+0Xa3Yh9zvfqTkK63i2RRK03Gtx+kUUKe
         mbHsiTdSSMwkINg6fSi40XKHH9DOfu4fZKCY1SwBoc+g+bOWD0Z2YQYPbGewq0M6kY1c
         cfwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NbMRl28CfB9DT6gF9ur53jbkl2XPiQfbSX+1iQMn930=;
        fh=wQ18G6eGT0benJNP/vAHGhk150PzvoITwmxL9D0iMbM=;
        b=WrogZOscG2m97ENYdTMwg86mD4EVcwsvBhR6WfR1Q7ClWGNpdF+cDjzPLrlQieWT1c
         B+3vIWCiwFSlzL00oI3cn/H1LQwwHu/Ld7Owu93HU+B52IlMCXS/q5Y6zSIiA60NEdXn
         ZtYC3Xro51IzYsQzSR6Y1ZFLvlbhdeNRIjrmG5mea/svJavDfdQpmciryfI8KhJ4dwwB
         oGdqQ2jA4tu1+gXx6qMLkHejp9v5Kt4q8zJm5Hyz+n2kezzahkROT2R5Mv0RaWqt30TY
         aEpXnAAN8P1FKxvkWNsi4zfWjp4SZMaD2iY+LhuAaXMbk5Oc2G8JJpZ4Md9iPD7f4L4I
         3qiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790371732; x=1790976532; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NbMRl28CfB9DT6gF9ur53jbkl2XPiQfbSX+1iQMn930=;
        b=KKzlE4UuITHO/+LgQpt5xKCpULP8GvdN11dzYiasfhc3rSYvxK4GitKMJuijmQssnP
         g78CQ6re4fW+jlf6cFa3lld0hj6tTIzZQVNuGfM+EzAuaTej4qyOC03QYDS+PibQ9BC/
         DB69vNKqnbnLW8rz3aOQ3j2nflvFbYZyGHfOiQPmAFSyjaUeNNKETvBAjcEp1HpThwGJ
         7CsGybNoKbjZCPaZq6uweM5Qy2fR49nX99q313jDjlL0jfvNbPN7v4FXBDphuSiWJuJZ
         ec0T0XmPL8OGf6C//0IGobgkSLOuSTsStwEOzyoSGejWSV4JPTSHMP1aokr2ENUUIUT8
         +fcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790371732; x=1790976532;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NbMRl28CfB9DT6gF9ur53jbkl2XPiQfbSX+1iQMn930=;
        b=B+3j9EeYhR2eZje6bysxmE1nPElQE4gY9TnuUXefouGeqXsKk0wxbbVvzqOD4gJ/Q1
         9YciKnhz2S2WeNJf+/eg42Tb9LAXkPlsyS6UERKxgzMubZtV/s2rachdTZ/HqHmj3OGu
         lDlujk2yDeRzKyW+eoVaGdv88Vro0XrfiB6LBoBwhN/+OmTyYs5pkFLObO0y1TKJoPr0
         kGdYw8JstsKDUk4/H1mhQu357cKlgphD8ejKT7L2MsQ25VfVWAK3O2He7WssVo679IkB
         EUEQLtgSHSYVbRUwu07EVQ4cL5r95xlde9uQHzQYgPDhUimBpweECzIKlTp1sGo/F9JP
         kHwg==
X-Forwarded-Encrypted: i=1; AKwUvBwlbG1sbMHPVS+K8MD/vXFal8AapkxvnJylzNvaVNCYFp4nH60VWJZOQdzCZo+ArOHlxKUKQBrPCw==@kvack.org
X-Gm-Message-State: AFuF++lZbECJ93cBHFqwMgj8T4kmuTNmqZ4aoloAxu5OCUQgrfnxg5/w
	9ddUtTutuTurwrgje3a18CYeT9uZ9J4Jp9H3aV1F+uECWY+xPQVhGCBeupgD9lCMG1Kzyn8oZtL
	nja3jDMZOSxi0Bn2rUm118Jl2/rVPYg8F1jtxqyvx
X-Gm-Gg: AYBFou1qpSL6huBWS4whb7s216fu07TKckJCynUC6Z0IYoX2lomcFuHIJTgPh1SSeIA
	qVC+M/rldDVB65cko9cx3iuexa+aHoMQClnr9mlb3PK4lxhGIPBzuZgKozxf11x1sl1vGZBVTG3
	APPQOcPeg6hDG5rwXGZS3aLaeCib5ls85VakBKLuUM1o7wyD8FhJ2ai2qp8R+P9T6L93MVWoS2j
	ZvCsigyW6o4WupynXRzfdJ0ghGUR+5S2iSoo6h5hIzu+iFav3VomQK6OnT6RFNR7kXgPfVCfdh/
	+EcyJlmvT1LEqKF675dvwdjLUxWNku8EEOqSaDEPl50LBXlMlCseI8AThfKdPDIMoBXEsUWdIrx
	Vm5TEPp9kOg==
X-Received: by 2002:a17:902:db02:b0:2df:8e28:661a with SMTP id
 d9443c01a7336-2dfa6263bc5mr1212555ad.16.1790371731056; Fri, 25 Sep 2026
 14:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
 <95bf63d2b9ef14f6610d6543b6892d266e4dc5c6.1790025465.git.abhishekbapat@google.com>
 <0e2db0a0-663e-45fc-b073-126b8e80b625@linux.dev> <CAJuCfpFXky7Rj5ghPXGuL59PtG-cmXQywK3ttOHWx_v-pSSN9w@mail.gmail.com>
 <CAL41Mv5REKRLUwSZ9ViTKpBwtEEaE-A3VOK-A0pDTORVNQjeVg@mail.gmail.com>
In-Reply-To: <CAL41Mv5REKRLUwSZ9ViTKpBwtEEaE-A3VOK-A0pDTORVNQjeVg@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Fri, 25 Sep 2026 14:28:38 -0700
X-Gm-Features: AclHuK-rlu7lCPpgcOe11vshDOR2IoynhR9zVT0TuUEQB2hYbYOMSEF_McF7A2Y
Message-ID: <CAL41Mv6aGMHPyATA9h1dY_cThXW9PyKQsVdLCaNXOBsQKv9_Qw@mail.gmail.com>
Subject: Re: [PATCH 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1559640005
X-Stat-Signature: gxu1hmo59urtxqqtrke9rzgtgraqc9km
X-HE-Tag: 1790371732-866572
X-HE-Meta: U2FsdGVkX19MpUMnmPwIZyz3S4nWfDxE5VvwlCcUQ7R19vHHiAbTbs1ivdfgKHqVN4pV1g86Junnx/vjrgSRH+V2AyZxmHui2bvdLow8EEEydQ5Dk9BfhMUwg9F8FXAviRPcdfIYHX70/jUNR6daPwP2KxEKE0r2oHQPagGWPuYEUnhw+uJSRUj3w7zLdKu6wDFd2beJoIRlC+wexjsUISxsiab5c4Y3tGfWu6HBAVQAV/fIEQFcaANNI4Wltyy77HiQtq5bY35J+qqFroc9RL/7ShGz3Sj2wf0/Jv/cjYq3/tWWNQj6DJEG05GYhf5ZOXp25xE4eFtALWlsYQ4xUaXaJ9TjIQsnsCGBHYYf/nFYZLVm+ND3UByiwT1hgD+/0bh4sCMkm8YJc1VFFJEbp4wqygxcRkFiMWz5+WF2ukQOZ5FD4gd98DZUksL+1qaEQ18K0XiZzQPcEXRwhWGQIkDov6M2wdJtlklh+83jP5uzS4uuBVh7dE+JyzT3CnHhJ5YrAAdn7aScL2LOsiBzXIwBmjL06ysU162sPVrDuzoARQz0qwtpINp+c/nPk78BdwQyxr9B5AR9YCsXy68mBRQQAAMzwoMbdrNBsSQ3P+wTLTeU/2w7FuyJggfthQUhcCYlXangNueeAhKD54n2u7iy07NthI+W6GtM7rOFQLcTtJNrdFI1ALHjFRBFOaEaRM9JhF0VY0i+EtdqRZce8U7B/5y+E5Z/P7XQEXH+cWCmAEzd4eBV75BcY38FBJ1ASjgXlEM1xtsu4HSRaqlFdpVl+qo4LR+5BpgZvMRqJiPOIq3yaEwObTxqenO0x11JPMEU08jCaTVtADf01E8JLHuktxiI03U7xCwEZQpI3DjWncyadHAw125OflmUAfVscvf46/R25x3AeNKHXVRCYBVbwaXOIf87YBASY81tOLMKcSJYqXlRt6mTDkUByKcUXAk3v9RLzT6aJ0WZZPf
 AGfqRj/E
 7WfxRoz84a0xvODOnocwm1amnQWlMdtv9Zk6MG06GR2RK5oRN+C3pM+BaLZ9YES6PhFGl+UfqvbCtNr4fkcoARECAR4lifvX2FVc/pSykTsER3i/OtFRS/wuQn2wUqWOstKrgxOi8+FpGD8N81lLuPBspCm2wDWfcOH0dghg2c2+TDeojh3s7xAhofegq8uOfNSIatvVKWKzcVCWl6s3EgU8y+6IbcAmXcUEsHo39alkefBukv3XlEoZOSg5NZMBWceihCElLiYyPz4Cgo1g9jHCbgnR36g9WSSr1JTm77SRojVs1icWR9aVLiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 2:25=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Thu, Sep 24, 2026 at 11:18=E2=80=AFPM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> >
> > On Thu, Sep 24, 2026 at 1:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote=
:
> > >
> > > Hi Abhishek
> > >
> > > On 2026/9/22 05:26, Abhishek Bapat wrote:
> > > > Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> > > > toggle tracing on exact allocation call sites. Userspace tools can
> > > > use the existing filtering mechanism to specify the set of tags to
> > > > toggle tracing for.
> > > >
> > > > To facilitate low overhead execution for non-targeted call sites, a=
dd a
> > > > new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-s=
ite
> > > > activation. Protect these conditional branch evaluations using a gl=
obal
> > > > `alloc_tag_trace_key` static branch and an inline static key check
> > > > pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, e=
tc).
> > > > This ensures that the trace events are entirely skipped when no
> > > > allocation call sites are being actively traced, leaving only a NOP=
 on
> > > > the allocation fast path.
> > > >
> > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > ---
> > > >  include/linux/alloc_tag.h      |  39 ++++++++----
> > > >  include/linux/codetag.h        |   5 +-
> > > >  include/uapi/linux/alloc_tag.h |   9 +++
> > > >  mm/alloc_tag.c                 | 110 +++++++++++++++++++++++++++++=
+++-
> > > >  4 files changed, 147 insertions(+), 16 deletions(-)
> > > >
> > > > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > > > index 2994934cf44a..dc86f8997476 100644
> > > > --- a/include/linux/alloc_tag.h
> > > > +++ b/include/linux/alloc_tag.h
> > > > @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled=
(void)
> > > >                                  &mem_alloc_profiling_key);
> > > >  }
> > > >
> > > > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > > > +{
> > > > +     atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
> > > > +}
> > > > +
> > > > +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > > > +{
> > > > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURA=
TE);
> > > > +}
> > > > +
> > > > +static inline void alloc_tag_set_traced(struct alloc_tag *tag)
> > > > +{
> > > > +     atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > > > +}
> > > > +
> > > > +static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
> > > > +{
> > > > +     atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > > > +}
> > > > +
> > > > +static inline bool alloc_tag_is_traced(const struct alloc_tag *tag=
)
> > > > +{
> > > > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON=
);
> > > > +}
> > > > +
> > > >  static inline bool alloc_tag_trace_enabled(const struct alloc_tag =
*tag)
> > > >  {
> > > > -     return static_branch_unlikely(&alloc_tag_trace_key);
> > > > +     if (static_branch_unlikely(&alloc_tag_trace_key))
> > > > +             return tag && alloc_tag_is_traced(tag);
> > > > +     return false;
> > > >  }
> > > >
> > > >  void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct allo=
c_tag *tag,
> > > > @@ -255,16 +282,6 @@ static inline void alloc_tag_sub(union codetag=
_ref *ref, size_t bytes)
> > > >       ref->ct =3D NULL;
> > > >  }
> > > >
> > > > -static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > > > -{
> > > > -     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> > > > -}
> > > > -
> > > > -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > > > -{
> > > > -     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> > > > -}
> > > > -
> > > >  #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> > > >
> > > >  #else /* CONFIG_MEM_ALLOC_PROFILING */
> > > > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > > > index a25a085c2df1..f728295d50c0 100644
> > > > --- a/include/linux/codetag.h
> > > > +++ b/include/linux/codetag.h
> > > > @@ -18,6 +18,7 @@ struct module;
> > > >
> > > >  /* codetag flags */
> > > >  #define CODETAG_FLAG_INACCURATE      (1 << 0)
> > > > +#define CODETAG_FLAG_TRACE_ON        (1 << 1)
> > > >
> > > >  /*
> > > >   * An instance of this structure is created in a special ELF secti=
on at every
> > > > @@ -25,7 +26,7 @@ struct module;
> > > >   * an array of these.
> > > >   */
> > > >  struct codetag {
> > > > -     unsigned int flags;
> > > > +     atomic_t flags;
> > > >       unsigned int lineno;
> > > >       const char *modname;
> > > >       const char *function;
> > > > @@ -71,7 +72,7 @@ struct codetag_iterator {
> > > >       .function       =3D __func__,                     \
> > > >       .filename       =3D __FILE__,                     \
> > > >       .lineno         =3D __LINE__,                     \
> > > > -     .flags          =3D 0,                            \
> > > > +     .flags          =3D ATOMIC_INIT(0),               \
> > > >  }
> > > >
> > > >  void codetag_lock_module_list(struct codetag_type *cttype);
> > > > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/al=
loc_tag.h
> > > > index 7d4618bea043..069ab8341e87 100644
> > > > --- a/include/uapi/linux/alloc_tag.h
> > > > +++ b/include/uapi/linux/alloc_tag.h
> > > > @@ -85,9 +85,16 @@ struct allocinfo_get_at {
> > > >       struct allocinfo_tag_data data;
> > > >  };
> > > >
> > > > +struct allocinfo_toggle_traces {
> > > > +     /* inputs */
> > > > +     struct allocinfo_tag fields;
> > > > +     __u64 enable;
> > > > +};
> > > > +
> > > >  #define _ALLOCINFO_IOC_CONTENT_ID    0
> > > >  #define _ALLOCINFO_IOC_GET_AT                1
> > > >  #define _ALLOCINFO_IOC_GET_NEXT              2
> > > > +#define _ALLOCINFO_IOC_TOGGLE_TRACE  3
> > > >
> > > >  #define ALLOCINFO_IOC_BASE           0xA6
> > > >  #define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALL=
OCINFO_IOC_CONTENT_ID,     \
> > > > @@ -96,5 +103,7 @@ struct allocinfo_get_at {
> > > >                                             struct allocinfo_get_at=
)
> > > >  #define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BA=
SE, _ALLOCINFO_IOC_GET_NEXT,       \
> > > >                                            struct allocinfo_tag_dat=
a)
> > > > +#define ALLOCINFO_IOC_TOGGLE_TRACE   _IOW(ALLOCINFO_IOC_BASE, _ALL=
OCINFO_IOC_TOGGLE_TRACE,   \
> > > > +                                         struct allocinfo_toggle_t=
races)
> > > >
> > > >  #endif /* _UAPI_ALLOC_TAG_H */
> > > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > index a5339767efd5..fb179321a2a1 100644
> > > > --- a/mm/alloc_tag.c
> > > > +++ b/mm/alloc_tag.c
> > > > @@ -61,6 +61,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed=
);
> > > >  DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > > >  EXPORT_SYMBOL(alloc_tag_trace_key);
> > > >
> > > > +static atomic_t alloc_tag_trace_cnt =3D ATOMIC_INIT(0);
> > > > +
> > > > +/*
> > > > + * As `codetag_lock_module_list` is a read lock, we need an additi=
onal mutex
> > > > + * to protect against the race conditions involved in the alloc ta=
g trace
> > > > + * toggle path.
> > > > + */
> > > > +static DEFINE_MUTEX(alloc_tag_trace_mutex);
> > > > +
> > > >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> > > >  unsigned long alloc_tag_ref_mask;
> > > >  int alloc_tag_ref_offs;
> > > > @@ -297,7 +306,7 @@ static bool matches_filter(struct codetag *ct, =
struct allocinfo_filter *filter,
> > > >               return false;
> > > >
> > > >       if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > > > -             inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE=
);
> > > > +             inaccurate =3D alloc_tag_is_inaccurate(ct_to_alloc_ta=
g(ct));
> > > >               if (inaccurate !=3D !!(filter->inaccurate))
> > > >                       return false;
> > > >       }
> > > > @@ -444,6 +453,81 @@ static int allocinfo_ioctl_get_next(struct seq=
_file *m, void __user *arg)
> > > >       return ret;
> > > >  }
> > > >
> > > > +static bool alloc_tag_trace_toggle(struct alloc_tag *tag, bool ena=
ble)
> > > > +{
> > > > +     if (enable) {
> > > > +             if (alloc_tag_is_traced(tag))
> > > > +                     return false;
> > > > +
> > > > +             alloc_tag_set_traced(tag);
> > > > +             if (atomic_fetch_inc(&alloc_tag_trace_cnt) =3D=3D 0)
> > > > +                     static_branch_enable(&alloc_tag_trace_key);
> > > > +     } else {
> > > > +             if (!alloc_tag_is_traced(tag))
> > > > +                     return false;
> > > > +
> > > > +             alloc_tag_clear_traced(tag);
> > > > +             if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> > > > +                     static_branch_disable(&alloc_tag_trace_key);
> > > > +     }
> > > > +
> > > > +     return true;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Toggles context capture for a specified allocation.
> > > > + */
> > > > +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void _=
_user *arg)
> > > > +{
> > > > +     struct allocinfo_toggle_traces params;
> > > > +     struct codetag_iterator iter;
> > > > +     struct codetag *ct;
> > > > +     int matches =3D 0, successes =3D 0, ret;
> > > > +
> > > > +     if (!capable(CAP_SYS_ADMIN))
> > > > +             return -EPERM;
> > > > +
> > > > +     if (copy_from_user(&params, arg, sizeof(params)))
> > > > +             return -EFAULT;
> > > > +
> > > > +     codetag_lock_module_list(alloc_tag_cttype);
> > > > +
> > > > +     struct allocinfo_filter filter =3D {
> > > > +             .mask =3D ALLOCINFO_FILTER_MASK_MODNAME |
> > > > +                    ALLOCINFO_FILTER_MASK_FUNCTION |
> > > > +                    ALLOCINFO_FILTER_MASK_FILENAME |
> > > > +                    ALLOCINFO_FILTER_MASK_LINENO,
> > > > +             .fields =3D params.fields,
> > > > +     };

Also Suren, I wanted to get your thoughts on this filter. Here, these
filters ensure that only one allocation site matches the user's
request. Should I remove the masks here so the user can choose to
toggle tracing on multiple allocation sites in one IOCTL?

> > > > +
> > > > +     iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > > > +
> > > > +     /* Toggle tracing on all codetags that match */
> > > > +     while ((ct =3D codetag_next_ct(&iter))) {
> > > > +             if (matches_filter(ct, &filter, NULL, NULL)) {
> > > > +                     matches++;
> > > > +
> > > > +                     mutex_lock(&alloc_tag_trace_mutex);
> > > > +                     if (alloc_tag_trace_toggle(ct_to_alloc_tag(ct=
), !!params.enable))
> > > > +                             successes++;
> > > > +                     mutex_unlock(&alloc_tag_trace_mutex);
> > > > +             }
> > > > +     }
> > > > +
> > > > +     if (matches =3D=3D 0)
> > > > +             /* Nothing matched the filter */
> > > > +             ret =3D -ENOENT;
> > > > +     else if (successes =3D=3D 0)
> > > > +             /* Items matched, but were already in the requested s=
tate */
> > > > +             ret =3D -EINVAL;
> > >
> > > Why do we return -EINVAL in this path?
> > > -EINVAL can mislead users into thinking their arguments are wrong.
> > > That's not the case; the trace request they want is already active.
> > > Maybe -EEXIST ?
> >
> > Or even 0 since the configuration already matches what the user request=
ed.
> >
> Ack, will modify in v2.
> > >
> > > Thanks
> > > Best Regards
> > > Hao
> > >
> > > > +     else
> > > > +             ret =3D 0;
> > > > +
> > > > +     codetag_unlock_module_list(alloc_tag_cttype);
> > > > +
> > > > +     return ret;
> > > > +}
> > > > +
> > > >  /*
> > > >   * Entry point ioctl function for /proc/allocinfo routing requests=
 to fetch the
> > > >   * layout content ID, seek to a specific tag, or read sequential t=
ags.
> > > > @@ -464,6 +548,9 @@ static long allocinfo_ioctl(struct file *file, =
unsigned int cmd,
> > > >       case ALLOCINFO_IOC_GET_NEXT:
> > > >               ret =3D allocinfo_ioctl_get_next(file->private_data, =
arg);
> > > >               break;
> > > > +     case ALLOCINFO_IOC_TOGGLE_TRACE:
> > > > +             ret =3D allocinfo_ioctl_toggle_trace(file->private_da=
ta, arg);
> > > > +             break;
> > > >       default:
> > > >               ret =3D -ENOIOCTLCMD;
> > > >               break;
> > > > @@ -493,8 +580,6 @@ static const struct proc_ops allocinfo_proc_ops=
 =3D {
> > > >
> > > >  void __alloc_tag_trace_hit(struct alloc_tag *tag)
> > > >  {
> > > > -     if (unlikely(!tag))
> > > > -             return;
> > > >       trace_alloc_tag_hit(tag);
> > > >  }
> > > >  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > > > @@ -1043,6 +1128,24 @@ static int load_module(struct module *mod, s=
truct codetag *start, struct codetag
> > > >       return 0;
> > > >  }
> > > >
> > > > +static void unload_module(struct module *mod, struct codetag *star=
t, struct codetag *stop)
> > > > +{
> > > > +     struct alloc_tag *start_tag =3D ct_to_alloc_tag(start);
> > > > +     struct alloc_tag *stop_tag =3D ct_to_alloc_tag(stop);
> > > > +     struct alloc_tag *tag;
> > > > +
> > > > +     /*
> > > > +      * Turn tracing off for the tags of the module being unloaded=
. Without
> > > > +      * this, `alloc_tag_trace_cnt` would never reach zero and tra=
cing would
> > > > +      * stay enabled forever.
> > > > +      *
> > > > +      * `alloc_tag_trace_mutex` is not needed here as this code pa=
th is
> > > > +      * protected by a `down_write(&cttype->mod_lock)`.
> > > > +      */
> > > > +     for (tag =3D start_tag; tag < stop_tag; tag++)
> > > > +             alloc_tag_trace_toggle(tag, false);
> > > > +}
> > > > +
> > > >  static void replace_module(struct module *mod, struct module *new_=
mod)
> > > >  {
> > > >       MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
> > > > @@ -1369,6 +1472,7 @@ static int __init alloc_tag_init(void)
> > > >               .alloc_section_mem      =3D reserve_module_tags,
> > > >               .free_section_mem       =3D release_module_tags,
> > > >               .module_load            =3D load_module,
> > > > +             .module_unload          =3D unload_module,
> > > >               .module_replaced        =3D replace_module,
> > > >  #endif
> > > >       };

