Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6634DFB5188
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 03:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDA06B0088; Mon,  6 Apr 2026 23:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8DE36B0089; Mon,  6 Apr 2026 23:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB236B008A; Mon,  6 Apr 2026 23:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98F476B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:45:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39EA0B6A2C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:45:58 +0000 (UTC)
X-FDA: 84630371196.07.8D93DEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 44D0840004
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:45:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmYBTemM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775533556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A4V46j4qnY0nZWO/p087SBW2+54Wa3vS+/J7/XjQR5o=;
	b=W0iJcxNQ9DB1u6i0OTmX4hykTIO1Y673nKbksMhwvYyiO7RHOSW9jHPtorrDu20JwkxcTE
	/aul63XZe9XXMWfmr4ohdm90iIKcxV0LzvvKtel2ZIxx6DFtkD1JEV9TuuOUXOOngu+1au
	Zcw7R1wXh0xtlCIYEL6VqdmVn8NG8jM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775533556; a=rsa-sha256;
	cv=none;
	b=VC2mU8C320ga7RTzCJj3JNEilWbsbAiZIoHj4t2UP/7HGY4B3sgDS5KGQ8ko4w4Uts4DAW
	ShjCQxSCNp6QvhQPgfUlvLMciFQU7xs1WH0F7uQLiZjeKaemknBfAtRsHKc0roVL9V11cF
	8wUlOs+MrVdPfw6h8J/AnmyG1if07XY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KmYBTemM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 371D944470
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AEFC2BCB2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775533555;
	bh=A4V46j4qnY0nZWO/p087SBW2+54Wa3vS+/J7/XjQR5o=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KmYBTemMInqzicG3qKPpJqxk2wDREwqi/7txHFg8l79s2oUoMU7jIPC7sH0QXctFP
	 +ALFkBoPlQyO853J8XwwVbTUC82CColQADk75zhYk2r923Rr16cJYEQiuhWA3P0hbT
	 23OELLFB4xHXM/p2Vfp/7irUpZMtzE9Cz662RstakCxbMcw60btsLkM7uCbMwtDJ8k
	 OsuKXlfW1I+R+nmE4dynl+Hj11PB0dSJJQe+bGpdu1iEK09XxaHT89FLluu9Inoipf
	 su44eERrAfVVMeWrLG0unqHWApyjVU3auTUlVKSGEqf6Oq+6HB3dY/q5GJENf+gquD
	 pwqn18n/wAK6Q==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8a48deebe95so47802156d6.0
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 20:45:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUzvcBhrtPLE1h78+UDVhK4/fKpm1GkEHw36bqq5yJJEZ8lJJD29Q5WS48ptQDV4AYNwLCQSJRhtg==@kvack.org
X-Gm-Message-State: AOJu0YzYgRxJb2L6MZfCOcbtIJdvNK9OSsn9Vbk4WjoEQ+59jzWsoxuf
	VvuP2Mq/jcAnTfOm/ePvOFXVoCssOabyOFqucqmxOKR+uQV8HTI6y1rTWQnQOHXnMS02FlnYV76
	4c/U6OQ7JfJfz8WFwI5MZfrbWakAHaiU=
X-Received: by 2002:a05:6214:4e1b:b0:8a3:d463:da96 with SMTP id
 6a1803df08f44-8a7046daafcmr241091946d6.43.1775533554354; Mon, 06 Apr 2026
 20:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260318011558.1696310-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4x15neqzYW1qruNUSeFjJuQokkPxrCJ_D55VSYZ6-bYNQ@mail.gmail.com> <CAGWkznHc56x8REsLPJsnK2t8ZHwu3CK8fTd-Gb=sBW3X+EXD8Q@mail.gmail.com>
In-Reply-To: <CAGWkznHc56x8REsLPJsnK2t8ZHwu3CK8fTd-Gb=sBW3X+EXD8Q@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 7 Apr 2026 11:45:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zkiDCjPnRJ4LbFakpX3LiL-F6X_BSju3iHS-d5iugVSg@mail.gmail.com>
X-Gm-Features: AQROBzAYC4s4FxU8UkS5I0q7eSg2KX4ZLeFxBq8kGa0dOMaXwJF5avhn8JJx85U
Message-ID: <CAGsJ_4zkiDCjPnRJ4LbFakpX3LiL-F6X_BSju3iHS-d5iugVSg@mail.gmail.com>
Subject: Re: [PATCHv3] mm: remove '!root_reclaim' checking in should_abort_scan()
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, "T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 44D0840004
X-Stat-Signature: k73kgcb4bft9z9xqenzu5gfgbgxrdcfo
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775533556-842734
X-HE-Meta: U2FsdGVkX1/0Az7UH4xuzXt7g2Ck4HogMTtEODWWWCiOt9N3u7CHPmE+FxIR80/ZZ4pCJjRNE1525OznG6uBwft6C7nnft3xxy8J75y+2gS7H4JyusHepy7Id3pWxEOdtV4oGC0H5I/MOmKCGN0CFyP3hkDKhWCWjdlAGYRcYPfwAODmgV5vrHwdCgDWF1sae3pBy7ReJta+BPG5SNi3kN3FT6w1XShPMWZ1by4Vu/PmrlT4AF69ZopFjuQXVgTEe70H94tg/VoEiOGwURkcXdFc4tyWJ/Bw9t4pHol9f8T4O6OBa56W5P8FKJk8H4H0gXcF6zkN/QlzvQOfPk1+UNEG0Lo/+gIIcy3Wz7FG/tJdmq3M6Sebte5o2f36ryTvMILDZec/VuhZwHlGT9dyMrw7UOq8hwFFKs/Qna2otwdzkgBEG9BS27ONjbGDWfW8GAoibYITMyLcqsoZhinOQ52l3MV9TOM4q6OEZGql1nzFm9rHPNRy6xKCOk3eJfq1k8CDRFgvZxHfGo82/LpOajbEhkO/FpGQlS5lhxtLgCXCUlz2msjkGlRxh5gLIwl+/mSPIPZDh2Wp9G8YJmKZic2KZFcdKJr/2Yat9pBWIBWGdeuQiCF2THWtoVMlB5O0Ft9/7lfX7hhVFRVq0m1uoqCEGmzEA5RxqppnrHybMScBLh08QKveCJt+ppjrzCx+xX28+fobKLDxmKCFgA5LD5gmkaQE0dCZLupUv1FNx1ctHBsY3qkjZe8tGWM/XNhJFIxBPOYq8XNsuek/5nhAkXwIEz28C4KLQC5jwQOOQnAR1qrcm19UE7xOV3w/p6rtdfrFLenAPktL/UL1D5O5DU/5Wz79fqmst11b6qf28s+2nMCohcTdcIvM+Q/VH4tFpZEH03pFuRuME/S/3GBS8Hq8zJDoTUH5XnAOnFRPO/JCVogJpqTMXYfhiuiUkSEIo8p/JfspJZToacM4TyK
 VgaEr6bP
 2/fkunPTjTfkd7hjcH+N6663MMLrVZ6UGYKGkcRVF2f0q8jvndUSunsrMRSVKxYmqyaDbJrxxBJsd07KbSFSy3ZeR2JJthsn94GRN05/GJxKomzHcGUce6SrQ74QkprvAkLWu6/gJLwyTNAEFGhatA71A6LWRzQV7aw73IO0rbunYl+rwOfiSa/SHnItwgstvpqMJcV+0fBbZkl5uKU2RkBQ+OB0zr20HLfIqSabw7tt4k4Zgbx2SP8uPHWeRkX1eP/FDR9B/gdquOOtcAPg10iPgaVSIvxNgwWjNZYnfnlCHy/bjyAtlFX/BChW7L/AVCaSyMfxPgjhs4Z5aCigsL64bisu93CK2OPLf/6yCfcJgwTUz7i6xn71GPRh51HXroddQZM+kccHz1PNJoRLX8qW1N2RUVMNLkpliVR8HuyOoayNxtqbVKax98AlmByqBlj1QLGJx94tB7xuRE/GgKE6kkR9yrHMLKb7m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 3, 2026 at 3:05=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail.=
com> wrote:
>
> On Fri, Apr 3, 2026 at 6:59=E2=80=AFAM Barry Song <baohua@kernel.org> wro=
te:
> >
> > On Wed, Mar 18, 2026 at 9:18=E2=80=AFAM zhaoyang.huang
> > <zhaoyang.huang@unisoc.com> wrote:
> > >
> > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > >
> > > Android systems usually use memory.reclaim interface to implement use=
r
> > > space memory management which expects that the requested reclaim targ=
et
> > > and actually reclaimed amount memory are not diverging by too much. W=
ith
> > > the current MGRLU implementation there is, however, no bail out when =
the
> > > reclaim target is reached and this could lead to an excessive reclaim
> > > that scales with the reclaim hierarchy size.For example, we can get a
> > > nr_reclaimed=3D394/nr_to_reclaim=3D32 proactive reclaim under a commo=
n 1-N
> > > cgroup hierarchy.
> > > This defect arised from the goal of keeping fairness among memcgs tha=
t
> > > is, for try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> > > shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> > > !root_reclaim(sc) check was there for reclaim fairness, which was
> > > necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> > > incremental cgroup iteration") because the fairness depended on
> > > attempted proportional reclaim from every memcg under the target
> > > memcg. However after commit 'b82b530740b9' there is no longer a need
> > > to visit every memcg to ensure fairness. Let's have try_to_shrink_lru=
vec
> > > bail out when the nr_reclaimed achieved.
> >
> > I think we need some clarification here. Does the code
> >
> > nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_scan);
> >
> > still serve a purpose, or has it become less useful after your patch?
> proportional protection is still useful for calculating the nr_to_scan
> when 'memory.min/low' is configured in the hierarchy.
>

Right, thanks! Also, the patch looks sensible to me,

Reviewed-by: Barry Song <baohua@kernel.org>

