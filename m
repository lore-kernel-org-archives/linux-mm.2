Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4756CA5FAD
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 02:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A707E6B0088; Tue, 29 Sep 2026 22:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A480D6B008A; Tue, 29 Sep 2026 22:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9365F6B0096; Tue, 29 Sep 2026 22:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6343A6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 22:09:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65C1C14066A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:09:44 +0000 (UTC)
X-FDA: 85268797488.07.8314ACA
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6E510A0006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:09:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=boaLE0mv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790734182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bnXc90n36ZIr4au7lhU3XU/h1VRC1NVUGpl8Sh2Wm8=;
	b=akN4FTVcX780qtMmpMIKucJD+vb+oGZW0KbtFFUu7eQkupvH9AKFaAygh7XoiMk6VdvAJk
	VSxp1QejwJcPIn//GXxwXH7CnPaODDLXFOJfmmEz00pZCwPw7BqcmBSxVQxpnAUojhkbY3
	+GBdKURWjKnUosSRNL5T8v+88X95KNo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=boaLE0mv;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790734182;
	b=NjAnrvbtUnQAv75gAZzLc/PUq9ygEKynSoy3TELVTRkFTjL75ZRZabZBt6O3BZ7BXpcj++
	XzGqN/NfJ1ubX2D3v7T0xdrlc9eRG6NPvZRbqL0x/iRPkZeU1zIY/l0UsjiaHCjRhCAnS7
	Wt9MOpuMW0o1n1quTFYmgOrB22tluY0=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-53328262efbso132781cf.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:09:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790734181; cv=none;
        d=google.com; s=arc-20260327;
        b=Jx8v+mjojLDLe0b5co7iGqgfTZEh3bDJwKuSzU8wx5wso2FgV4uEzSzfOlcpwTYYlA
         S5wEKCMPSnBXl5baXxUaJkIJXxia1bXoo9jpqWz5HuA8LP7aiIYvRjzjghVnPL8qzYJO
         vhM4G81AxdIIRWaavrx6xLJk8qO/vNtEHPe3anM/EhlhKkcHpQmNUZ3IO1j22O0SVkWT
         iyo6NCTvzszEX0IFLGv6OSpSTb8HrSpeq9wnZ5kQ2a9z0VLGHSb7BPB7zTv2W+7SBK40
         Z/p2zLUaKR6iKlzo4oYv7Uk4j12lmbVoU187eWr3ytb2u7afzvh0AkR1V6C/GdAsDtSh
         2u/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4bnXc90n36ZIr4au7lhU3XU/h1VRC1NVUGpl8Sh2Wm8=;
        fh=Y78GnzcFasePis4smnnEHbogB3qNoUyDXUSQXyLcykA=;
        b=PqcfCfH7sYUr2O5v2nxp49crrpRceitWfFAjdSR8ndyxldj+2BrHiLqpF4u8u5CnLj
         84p2WxcxdHatBEO61TI5SfK0+xPpDNAB1+BrXmcRv+u547iR1NP/494yxCkik3eSzkGt
         zStoKEOIGht/yGHnG+QRuSdQNqntsIqYXBJw/9fJqZQHSanjHfCFWY1n8zBIw8iNJur9
         6B2L3gqDc9MgRwotuxx4cjDYthC4V42ojgMwJaTzyI+hcKbxX5AeiYtc5JRB1lmvs5fT
         es/GYEM8D+nfAZyhPfVTHp7yINn9p5vth+koSwudz40nH3JV1ND88b0p8tKt87QJtguz
         GiEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790734181; x=1791338981; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4bnXc90n36ZIr4au7lhU3XU/h1VRC1NVUGpl8Sh2Wm8=;
        b=boaLE0mv0T4egO4f0K39v9xQB5LxcL9WzObh6VYmyZvWxHiWvP1fvQJzTbg/9hiZDu
         NCuRGapLCKbdBK3gv35O8GfCotsanHvd7pBz5UIC1LVpXfr9vE3qou+LNo31xu74iHHe
         m0r38P3MveGWbeJVInHl7XRiWIzBV8wFrhoFGNksOlniXq8qFjYK7reuUaAOGBZcBAKI
         LxcHbrSMl+bsH80idto8EGyQY8ADtFSVV508eunsjHZexGmA7cxygmNe4/yu9EVDHP8g
         GKA+JIRNI2qspHcGr2yfpCqTnx3AbrtlvNNY1WqIJedmWYXRuWUy8D/TtKCetGcW9luL
         EYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790734181; x=1791338981;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4bnXc90n36ZIr4au7lhU3XU/h1VRC1NVUGpl8Sh2Wm8=;
        b=iV0Auc4pHEWY7tXIZzlq4VJpmsS6fN+PPVJ/PvTiw3TIJpzPdgAxw6s5V++aQ1zS8Z
         0G/zKwJqLA5P+12KBtweetd6FLJxE/pe7lg/E9y0qxrEXpP2NCCqF9IbX0ZcYIhIPrZB
         x/llqeTY/YMVVrS+MfHKDLlS+fQvAn8dEKu1qP9ttEld1y8HWurxaixrohFk2eesMY5W
         iQRRHkSBs3irwJkQyFbYT6yxUt6ce9MJste47Ju608fVYSCtlhvjd266DVXQkk7EU0t/
         ygSIo1g1zRZOfq8+HiFyLZGC3qPcS9YIGZdLhyu6f/gEB0yAQsBFH1rSozkTib4HIEnj
         loLQ==
X-Forwarded-Encrypted: i=1; AKwUvByCDL6rFKik7pmvgNIrWzTFiqDdyDM+s0y9FFM2zuFGJ6iAgx61wQ9A9QgVw6A3JCURYpqRRbb2fQ==@kvack.org
X-Gm-Message-State: AFuF++npXMLVjUWcAY11V/9wo5G+nwguxqGwEu2AC2TEbX+oHqafvOR5
	cU4h0zBjqCs7hFselDHQPUCcwQODBFbZgtgSrlBDeCJRkZ06Dv6M9CtC7Sofuetxfs68N+5mtbn
	FVW/8CpjZv2rWBkqZfHAG5NyNOiWE8N2KfAbl2fb2
X-Gm-Gg: AYBFou1OaH8NHhCiU2mZSmNU07PMvQH79ZL56+Uir5aG9e1n7RDrX5jmBZEzDtD918B
	hXVE4pKiMEXs3H2ZFyFyQFH4lUU2Fq0y6IKPXX1BPpwQH7C+6ETopxvz8FbPR6Pc93IywKRd+V+
	UhGu9/VvVbtDcNdMXs+xGRq6AbE/36EsJoaJG80F2MRI0S/D4UfJTXo8nF8eTrt3SQtBD4+Sipc
	HWrZvPDMgAHD2p7DnaX6j7xXh49MgMp8PXaupZqc0OndS7N/dfZewraM8gSx5xcmCIr31uSogrD
	VRtQfVw4aJGQ7ffLYVoEIzsxeKuCaSkCj8YfWP1thANVi2hskqEm0pRtMQbP7xuI7inBaQgAxeU
	PYCN/Cbc=
X-Received: by 2002:a05:622a:1b8e:b0:532:858d:e791 with SMTP id
 d75a77b69052e-533741135dbmr679911cf.8.1790734180537; Tue, 29 Sep 2026
 19:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
 <95bf63d2b9ef14f6610d6543b6892d266e4dc5c6.1790025465.git.abhishekbapat@google.com>
 <0e2db0a0-663e-45fc-b073-126b8e80b625@linux.dev> <CAJuCfpFXky7Rj5ghPXGuL59PtG-cmXQywK3ttOHWx_v-pSSN9w@mail.gmail.com>
 <CAL41Mv5REKRLUwSZ9ViTKpBwtEEaE-A3VOK-A0pDTORVNQjeVg@mail.gmail.com> <CAL41Mv6aGMHPyATA9h1dY_cThXW9PyKQsVdLCaNXOBsQKv9_Qw@mail.gmail.com>
In-Reply-To: <CAL41Mv6aGMHPyATA9h1dY_cThXW9PyKQsVdLCaNXOBsQKv9_Qw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 30 Sep 2026 02:09:29 +0000
X-Gm-Features: AclHuK-H5IaGn1Jz87Ij4Vf-NWvu4hsgwRsxJg7vN0btxVQq4HPUJqSYakTiQ8I
Message-ID: <CAJuCfpGZoCz1c29hM6puPVtVmkypcPL97dmGyQoLpP4yN_aegw@mail.gmail.com>
Subject: Re: [PATCH 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ofoezw37er6j7nm87xatrfxfk18yd8ph
X-Rspamd-Queue-Id: 6E510A0006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790734182-896363
X-HE-Meta: U2FsdGVkX184TCiZIlVpkEqCRx7pmwbR6yeYKb5GpkRJqWhPl5BLUQlAjqSUyWteqX7LbtCQ5mw1iE2rkIflJnqaZrvTKfIj7a736xtaXzXr1jtzwqrGo+aDprfFa+hdxJmkg5oVdqurSxiZCIhHNcMu2zVvUnWNNfoH6hj5CZpTDQEEFfeqKtJ652JccqUNVFsOpPhFncTnpH1RDAA3lN5KiTjfkSMk5mgfZ2TJBpo1Gp4ifI5QryJuzF24DxCNBaXGM4NBefRfM5XVIgDRZfC9LROy9a7juy/1jvCO1zZjPwCofXY6Cxj2W8AXvz0uLiAYmEXEIV/pY+nAkPB7GovK3Nx6RtaGlYoMyGYjiDKcwe0GGKhwFFEWc+/QBmKl1kbCVoi4+iltYgqXQCk9vKq98G33/RTrmbiY/YDv/e8nM3C6zwpSCDUb6X+1mB1/QTaGdkr0C/fZquPEtovpYy7zFrw8sgQ2aSn7HcghkDT/XUSFw8n6ub6ROIN3MZA0i1ggR6bJZdRJarwCdY+QZBTzH4+gIqaXuj2BqwbnYAvpeUzY/uP1edR/fkSbQa9LmL0IJuLveNC4Sy2Bru1cMTnnqcMJz5FmkgpqiFqcqAYXAAI/Zegs3hGljZX9+ZoeOlCpb3rS0ybAQ7F10BdvpZ1Hn1a64gb/QWZEdgfWjoom0oUYKP6C28St7vvG/ExAwojE8J4NMdRGAzqWrJwTEtBtmZ+2zPB3/3LzMO5cDpHRPH0uO7mv8oVfNHnwO7NR5psz+ptaDSFxRs3rIQoZshOlA5cY7O0NCmttkxR6sG5xb0Pu73Kc21lgjK6YFrUxqsk1iw+ah2deuMLaBgXh2ZhGwlU6Ya4vhYMxW/U9xToDV3CD2BrbcMjQYEiZCXU9Z1AUB1Q/iykNS+7uGT7Sswng/cAg1GREe7wRJnJL5IwtKLWfewUYiM/nyUBwJ5AVUR6HyJpzixzad3V3o6t
 +twd4LXm
 iV0BRGSkBiWrPbWa/DUSttqFAXc4mjdWltagBAODMZNJi3MxZP0KuIHGHdCeVUgUTayxfvkUAZaVsMT8nEFyThCT0YnUN3gz0UAKTWOGHQ/8S89M1oXTPnUnVEEksH+bGuhIlDP14S0CwvgulgzYvEwLtovn8quPUzsv501kS5MQfY/+pQ+yv5x2m1fAmYBu1WgoSNVKMJajVW87jyImglzi93D+UXm1F5Q3DLhH4MAm2qmz9BUKy2xuAplWp0v5SO85WCh0WL+lFUVrh3kFm1zoQD+0sY9oFJX7eLDXQjvoTzCCX1sCMAc4Qew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 9:28=E2=80=AFPM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> On Fri, Sep 25, 2026 at 2:25=E2=80=AFPM Abhishek Bapat <abhishekbapat@goo=
gle.com> wrote:
> >
> > On Thu, Sep 24, 2026 at 11:18=E2=80=AFPM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> > >
> > > On Thu, Sep 24, 2026 at 1:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wro=
te:
> > > >
> > > > Hi Abhishek
> > > >
> > > > On 2026/9/22 05:26, Abhishek Bapat wrote:
> > > > > Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selective=
ly
> > > > > toggle tracing on exact allocation call sites. Userspace tools ca=
n
> > > > > use the existing filtering mechanism to specify the set of tags t=
o
> > > > > toggle tracing for.
> > > > >
> > > > > To facilitate low overhead execution for non-targeted call sites,=
 add a
> > > > > new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per=
-site
> > > > > activation. Protect these conditional branch evaluations using a =
global
> > > > > `alloc_tag_trace_key` static branch and an inline static key chec=
k
> > > > > pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`,=
 etc).
> > > > > This ensures that the trace events are entirely skipped when no
> > > > > allocation call sites are being actively traced, leaving only a N=
OP on
> > > > > the allocation fast path.
> > > > >
> > > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > > ---
> > > > >  include/linux/alloc_tag.h      |  39 ++++++++----
> > > > >  include/linux/codetag.h        |   5 +-
> > > > >  include/uapi/linux/alloc_tag.h |   9 +++
> > > > >  mm/alloc_tag.c                 | 110 +++++++++++++++++++++++++++=
+++++-
> > > > >  4 files changed, 147 insertions(+), 16 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.=
h
> > > > > index 2994934cf44a..dc86f8997476 100644
> > > > > --- a/include/linux/alloc_tag.h
> > > > > +++ b/include/linux/alloc_tag.h
> > > > > @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabl=
ed(void)
> > > > >                                  &mem_alloc_profiling_key);
> > > > >  }
> > > > >
> > > > > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *ta=
g)
> > > > > +{
> > > > > +     atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
> > > > > +}
> > > > > +
> > > > > +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag=
)
> > > > > +{
> > > > > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCU=
RATE);
> > > > > +}
> > > > > +
> > > > > +static inline void alloc_tag_set_traced(struct alloc_tag *tag)
> > > > > +{
> > > > > +     atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > > > > +}
> > > > > +
> > > > > +static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
> > > > > +{
> > > > > +     atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > > > > +}
> > > > > +
> > > > > +static inline bool alloc_tag_is_traced(const struct alloc_tag *t=
ag)
> > > > > +{
> > > > > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_=
ON);
> > > > > +}
> > > > > +
> > > > >  static inline bool alloc_tag_trace_enabled(const struct alloc_ta=
g *tag)
> > > > >  {
> > > > > -     return static_branch_unlikely(&alloc_tag_trace_key);
> > > > > +     if (static_branch_unlikely(&alloc_tag_trace_key))
> > > > > +             return tag && alloc_tag_is_traced(tag);
> > > > > +     return false;
> > > > >  }
> > > > >
> > > > >  void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct al=
loc_tag *tag,
> > > > > @@ -255,16 +282,6 @@ static inline void alloc_tag_sub(union codet=
ag_ref *ref, size_t bytes)
> > > > >       ref->ct =3D NULL;
> > > > >  }
> > > > >
> > > > > -static inline void alloc_tag_set_inaccurate(struct alloc_tag *ta=
g)
> > > > > -{
> > > > > -     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> > > > > -}
> > > > > -
> > > > > -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag=
)
> > > > > -{
> > > > > -     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> > > > > -}
> > > > > -
> > > > >  #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> > > > >
> > > > >  #else /* CONFIG_MEM_ALLOC_PROFILING */
> > > > > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > > > > index a25a085c2df1..f728295d50c0 100644
> > > > > --- a/include/linux/codetag.h
> > > > > +++ b/include/linux/codetag.h
> > > > > @@ -18,6 +18,7 @@ struct module;
> > > > >
> > > > >  /* codetag flags */
> > > > >  #define CODETAG_FLAG_INACCURATE      (1 << 0)
> > > > > +#define CODETAG_FLAG_TRACE_ON        (1 << 1)
> > > > >
> > > > >  /*
> > > > >   * An instance of this structure is created in a special ELF sec=
tion at every
> > > > > @@ -25,7 +26,7 @@ struct module;
> > > > >   * an array of these.
> > > > >   */
> > > > >  struct codetag {
> > > > > -     unsigned int flags;
> > > > > +     atomic_t flags;
> > > > >       unsigned int lineno;
> > > > >       const char *modname;
> > > > >       const char *function;
> > > > > @@ -71,7 +72,7 @@ struct codetag_iterator {
> > > > >       .function       =3D __func__,                     \
> > > > >       .filename       =3D __FILE__,                     \
> > > > >       .lineno         =3D __LINE__,                     \
> > > > > -     .flags          =3D 0,                            \
> > > > > +     .flags          =3D ATOMIC_INIT(0),               \
> > > > >  }
> > > > >
> > > > >  void codetag_lock_module_list(struct codetag_type *cttype);
> > > > > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/=
alloc_tag.h
> > > > > index 7d4618bea043..069ab8341e87 100644
> > > > > --- a/include/uapi/linux/alloc_tag.h
> > > > > +++ b/include/uapi/linux/alloc_tag.h
> > > > > @@ -85,9 +85,16 @@ struct allocinfo_get_at {
> > > > >       struct allocinfo_tag_data data;
> > > > >  };
> > > > >
> > > > > +struct allocinfo_toggle_traces {
> > > > > +     /* inputs */
> > > > > +     struct allocinfo_tag fields;
> > > > > +     __u64 enable;
> > > > > +};
> > > > > +
> > > > >  #define _ALLOCINFO_IOC_CONTENT_ID    0
> > > > >  #define _ALLOCINFO_IOC_GET_AT                1
> > > > >  #define _ALLOCINFO_IOC_GET_NEXT              2
> > > > > +#define _ALLOCINFO_IOC_TOGGLE_TRACE  3
> > > > >
> > > > >  #define ALLOCINFO_IOC_BASE           0xA6
> > > > >  #define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _A=
LLOCINFO_IOC_CONTENT_ID,     \
> > > > > @@ -96,5 +103,7 @@ struct allocinfo_get_at {
> > > > >                                             struct allocinfo_get_=
at)
> > > > >  #define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_=
BASE, _ALLOCINFO_IOC_GET_NEXT,       \
> > > > >                                            struct allocinfo_tag_d=
ata)
> > > > > +#define ALLOCINFO_IOC_TOGGLE_TRACE   _IOW(ALLOCINFO_IOC_BASE, _A=
LLOCINFO_IOC_TOGGLE_TRACE,   \
> > > > > +                                         struct allocinfo_toggle=
_traces)
> > > > >
> > > > >  #endif /* _UAPI_ALLOC_TAG_H */
> > > > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > > > index a5339767efd5..fb179321a2a1 100644
> > > > > --- a/mm/alloc_tag.c
> > > > > +++ b/mm/alloc_tag.c
> > > > > @@ -61,6 +61,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compress=
ed);
> > > > >  DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > > > >  EXPORT_SYMBOL(alloc_tag_trace_key);
> > > > >
> > > > > +static atomic_t alloc_tag_trace_cnt =3D ATOMIC_INIT(0);
> > > > > +
> > > > > +/*
> > > > > + * As `codetag_lock_module_list` is a read lock, we need an addi=
tional mutex
> > > > > + * to protect against the race conditions involved in the alloc =
tag trace
> > > > > + * toggle path.
> > > > > + */
> > > > > +static DEFINE_MUTEX(alloc_tag_trace_mutex);
> > > > > +
> > > > >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> > > > >  unsigned long alloc_tag_ref_mask;
> > > > >  int alloc_tag_ref_offs;
> > > > > @@ -297,7 +306,7 @@ static bool matches_filter(struct codetag *ct=
, struct allocinfo_filter *filter,
> > > > >               return false;
> > > > >
> > > > >       if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > > > > -             inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURA=
TE);
> > > > > +             inaccurate =3D alloc_tag_is_inaccurate(ct_to_alloc_=
tag(ct));
> > > > >               if (inaccurate !=3D !!(filter->inaccurate))
> > > > >                       return false;
> > > > >       }
> > > > > @@ -444,6 +453,81 @@ static int allocinfo_ioctl_get_next(struct s=
eq_file *m, void __user *arg)
> > > > >       return ret;
> > > > >  }
> > > > >
> > > > > +static bool alloc_tag_trace_toggle(struct alloc_tag *tag, bool e=
nable)
> > > > > +{
> > > > > +     if (enable) {
> > > > > +             if (alloc_tag_is_traced(tag))
> > > > > +                     return false;
> > > > > +
> > > > > +             alloc_tag_set_traced(tag);
> > > > > +             if (atomic_fetch_inc(&alloc_tag_trace_cnt) =3D=3D 0=
)
> > > > > +                     static_branch_enable(&alloc_tag_trace_key);
> > > > > +     } else {
> > > > > +             if (!alloc_tag_is_traced(tag))
> > > > > +                     return false;
> > > > > +
> > > > > +             alloc_tag_clear_traced(tag);
> > > > > +             if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> > > > > +                     static_branch_disable(&alloc_tag_trace_key)=
;
> > > > > +     }
> > > > > +
> > > > > +     return true;
> > > > > +}
> > > > > +
> > > > > +/*
> > > > > + * Toggles context capture for a specified allocation.
> > > > > + */
> > > > > +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void=
 __user *arg)
> > > > > +{
> > > > > +     struct allocinfo_toggle_traces params;
> > > > > +     struct codetag_iterator iter;
> > > > > +     struct codetag *ct;
> > > > > +     int matches =3D 0, successes =3D 0, ret;
> > > > > +
> > > > > +     if (!capable(CAP_SYS_ADMIN))
> > > > > +             return -EPERM;
> > > > > +
> > > > > +     if (copy_from_user(&params, arg, sizeof(params)))
> > > > > +             return -EFAULT;
> > > > > +
> > > > > +     codetag_lock_module_list(alloc_tag_cttype);
> > > > > +
> > > > > +     struct allocinfo_filter filter =3D {
> > > > > +             .mask =3D ALLOCINFO_FILTER_MASK_MODNAME |
> > > > > +                    ALLOCINFO_FILTER_MASK_FUNCTION |
> > > > > +                    ALLOCINFO_FILTER_MASK_FILENAME |
> > > > > +                    ALLOCINFO_FILTER_MASK_LINENO,
> > > > > +             .fields =3D params.fields,
> > > > > +     };
>
> Also Suren, I wanted to get your thoughts on this filter. Here, these
> filters ensure that only one allocation site matches the user's
> request. Should I remove the masks here so the user can choose to
> toggle tracing on multiple allocation sites in one IOCTL?

Absolutely. I see no reason why we should not support enabling tracing
for multiple tags.

>
> > > > > +
> > > > > +     iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > > > > +
> > > > > +     /* Toggle tracing on all codetags that match */
> > > > > +     while ((ct =3D codetag_next_ct(&iter))) {
> > > > > +             if (matches_filter(ct, &filter, NULL, NULL)) {
> > > > > +                     matches++;
> > > > > +
> > > > > +                     mutex_lock(&alloc_tag_trace_mutex);
> > > > > +                     if (alloc_tag_trace_toggle(ct_to_alloc_tag(=
ct), !!params.enable))
> > > > > +                             successes++;
> > > > > +                     mutex_unlock(&alloc_tag_trace_mutex);
> > > > > +             }
> > > > > +     }
> > > > > +
> > > > > +     if (matches =3D=3D 0)
> > > > > +             /* Nothing matched the filter */
> > > > > +             ret =3D -ENOENT;
> > > > > +     else if (successes =3D=3D 0)
> > > > > +             /* Items matched, but were already in the requested=
 state */
> > > > > +             ret =3D -EINVAL;
> > > >
> > > > Why do we return -EINVAL in this path?
> > > > -EINVAL can mislead users into thinking their arguments are wrong.
> > > > That's not the case; the trace request they want is already active.
> > > > Maybe -EEXIST ?
> > >
> > > Or even 0 since the configuration already matches what the user reque=
sted.
> > >
> > Ack, will modify in v2.
> > > >
> > > > Thanks
> > > > Best Regards
> > > > Hao
> > > >
> > > > > +     else
> > > > > +             ret =3D 0;
> > > > > +
> > > > > +     codetag_unlock_module_list(alloc_tag_cttype);
> > > > > +
> > > > > +     return ret;
> > > > > +}
> > > > > +
> > > > >  /*
> > > > >   * Entry point ioctl function for /proc/allocinfo routing reques=
ts to fetch the
> > > > >   * layout content ID, seek to a specific tag, or read sequential=
 tags.
> > > > > @@ -464,6 +548,9 @@ static long allocinfo_ioctl(struct file *file=
, unsigned int cmd,
> > > > >       case ALLOCINFO_IOC_GET_NEXT:
> > > > >               ret =3D allocinfo_ioctl_get_next(file->private_data=
, arg);
> > > > >               break;
> > > > > +     case ALLOCINFO_IOC_TOGGLE_TRACE:
> > > > > +             ret =3D allocinfo_ioctl_toggle_trace(file->private_=
data, arg);
> > > > > +             break;
> > > > >       default:
> > > > >               ret =3D -ENOIOCTLCMD;
> > > > >               break;
> > > > > @@ -493,8 +580,6 @@ static const struct proc_ops allocinfo_proc_o=
ps =3D {
> > > > >
> > > > >  void __alloc_tag_trace_hit(struct alloc_tag *tag)
> > > > >  {
> > > > > -     if (unlikely(!tag))
> > > > > -             return;
> > > > >       trace_alloc_tag_hit(tag);
> > > > >  }
> > > > >  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > > > > @@ -1043,6 +1128,24 @@ static int load_module(struct module *mod,=
 struct codetag *start, struct codetag
> > > > >       return 0;
> > > > >  }
> > > > >
> > > > > +static void unload_module(struct module *mod, struct codetag *st=
art, struct codetag *stop)
> > > > > +{
> > > > > +     struct alloc_tag *start_tag =3D ct_to_alloc_tag(start);
> > > > > +     struct alloc_tag *stop_tag =3D ct_to_alloc_tag(stop);
> > > > > +     struct alloc_tag *tag;
> > > > > +
> > > > > +     /*
> > > > > +      * Turn tracing off for the tags of the module being unload=
ed. Without
> > > > > +      * this, `alloc_tag_trace_cnt` would never reach zero and t=
racing would
> > > > > +      * stay enabled forever.
> > > > > +      *
> > > > > +      * `alloc_tag_trace_mutex` is not needed here as this code =
path is
> > > > > +      * protected by a `down_write(&cttype->mod_lock)`.
> > > > > +      */
> > > > > +     for (tag =3D start_tag; tag < stop_tag; tag++)
> > > > > +             alloc_tag_trace_toggle(tag, false);
> > > > > +}
> > > > > +
> > > > >  static void replace_module(struct module *mod, struct module *ne=
w_mod)
> > > > >  {
> > > > >       MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
> > > > > @@ -1369,6 +1472,7 @@ static int __init alloc_tag_init(void)
> > > > >               .alloc_section_mem      =3D reserve_module_tags,
> > > > >               .free_section_mem       =3D release_module_tags,
> > > > >               .module_load            =3D load_module,
> > > > > +             .module_unload          =3D unload_module,
> > > > >               .module_replaced        =3D replace_module,
> > > > >  #endif
> > > > >       };

