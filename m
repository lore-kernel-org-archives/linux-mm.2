Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 298C1C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 829A06B0095; Tue, 22 Sep 2026 14:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB946B0096; Tue, 22 Sep 2026 14:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9356B0098; Tue, 22 Sep 2026 14:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41A5F6B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:28:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE2991605FD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:28:38 +0000 (UTC)
X-FDA: 85242233916.16.073DE06
Received: from mail-ed2-f35.google.com (mail-ed2-f35.google.com [74.125.228.99])
	by imf27.hostedemail.com (Postfix) with ESMTP id C316340006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:28:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=elct02y9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jthoughton@google.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRC2VTeDk6B+04vgm9l4c1DOdHjdjNak1zZlGW8XWG0=;
	b=RYM9Es2uW2fQ47JF/HHIi5Ddh+VHarN+4s9aCcndyeJqsaqDJ4FzgmjJQnFtmDkisXydbC
	b79HFJhlru/IhbFgGxPag2mvwCXxAHIUY+BuCJgoeKaDBN+oA9rfzencbW1X56HBn5o6/A
	0fJWvdrdq117Dq46xPLw1pu/Qq8ym9E=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=elct02y9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jthoughton@google.com designates 74.125.228.99 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790101716;
	b=uAhT8eynov/Ven6Em4HIZTBMlmiFB0lnV+1IKqkL3cAR758Ole1rS21sX/D4C49AHjdpZl
	ppRAMDId125Y4mkqmCrejsF7gZhG6hRw0dgPeGukgKCKtp6guCcKt9G7xJuiI2sj6rUIrP
	82ySCg/gl44nCCcVCAhQTJeoKDB7eok=
Received: by mail-ed2-f35.google.com with SMTP id 4fb4d7f45d1cf-6a60591ae54so246125a12.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790101715; cv=none;
        d=google.com; s=arc-20260327;
        b=HbGOpliUhzC6aLWj7RJtIU+zdAiPuEBOKjfRqgTY+U6UN3mlvUn5krBJrdosURQa5o
         Bctex9uAjS5/uHHpoarLLEbB/KVc5A5u4Dk9pezz2RcjO2WJKo7OkgDccLcJKC+XAsKx
         +wn/D8kV+cq+LgXEXnRGw5AWQKy1xCs9CVI9fhWWiuDtSiTqrRSKM28ONxQwFouqQtoG
         3YvNcAIGLY42w52TilxzrMPiuIdYYh6vHOdf0n2htI3WEXkCsaA7azkW1TrHRcarJGT0
         AWmlLskV/AwG6XLgC+gwRg/63p7BPwno6Ye/sR1BFABSrhmWodCQlFU+JvkUq3cD9GbC
         +y+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZRC2VTeDk6B+04vgm9l4c1DOdHjdjNak1zZlGW8XWG0=;
        fh=eqmz8yJoozLwggLVvWiDX/prCVtuyJVNvn2bXe8mOKY=;
        b=nYorGOyhd+QG6ODBaF0tZnt8MhFuhDPRjp8jYnaHJZQ0R7WbD5+COA+5ALEs3FVcht
         LSn5O9OSWbkO2QPV0N2N0COxTIJy3NB9AzYfzAsUyOnL5Ac34h7ncGhAKiz0WAhCujNh
         1EmNz6y+Qdu3qJoCP1i5IYc2BWLonuP1KBEGi6vUuA28u8vSg+sWHELhCaCuoFghdQeK
         oRCqCr+Q5gCwSB+pfQ4ybdViuGDa8uEZLypUhwWn7w3ab20jBCHnxw1RHnJVQZVw9y06
         xZTeAJ/LlQ2T79J0T1Euzu7o0vI545TmdsNjURkzK/Ey8gEqgsmji9/gVCcc0KPSmYA4
         H9ow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790101715; x=1790706515; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZRC2VTeDk6B+04vgm9l4c1DOdHjdjNak1zZlGW8XWG0=;
        b=elct02y9AJT3JagbTU5WtBpUvPo7W2Q2y7AAzURpTGyeKJlD8lNlhjhfHo1iHoNcX6
         Pwo4ETa93hPjp3NOo+uU+4WWLbLAmbnsWOfmbxpBLZhS4fmfguasM4tSgAtc5W52cHTq
         jelOlij869CEiwUEL21bZi7JQeagRfA7Qe9tSssqzN37V8eIH1JGFY4PVIwTQyZmjlb9
         ANzmpD+y3gFebonPr17YlMcf+ULHc8/7hxVQ/J39MjcZpBSMpkVOD+NDI4DoDQgflqcD
         tKRq1cbBFO+byxrXe98Xh94N0s+NRE4ElhLY/db8ZEbwHdBsCUItNfSyBdMK1A61fadj
         RC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101715; x=1790706515;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZRC2VTeDk6B+04vgm9l4c1DOdHjdjNak1zZlGW8XWG0=;
        b=DtTx6H4JcZqrTEQoo8O2ooASsqlhLdvasOefWPkGTgCKpExQk7WetSmreRCH2JjHx/
         yL75Tp1icsTaDqkK8IeXOtc6MNFvo+qbr7ypLG/lOypIRz6dcS/KXMfrDhQXMaalnlgY
         UkbmxZKRvNEZli8WSgdTmJ3ubEsu6ZrCjEbFe2eglGfIgCWRuNt6EAAJBNn1tY+WN0dJ
         2gyXxjiAPE1oU5/yura0KN50+9Co2FXzw5xb6IiEfE/DvQQnJ74SRt6Sit1sNlELieuw
         8+fk9LyFT8pDh0liv1vomngQlsLMekh980FJ6xozalmi3nSO6ycPJXRyLC0HpPfvYlWQ
         NcMQ==
X-Forwarded-Encrypted: i=1; AKwUvBwMdOS9RTMtx2YvbfLgQysArc2yeYC5yAkZ/gXh0Jiohp87xkqhG9QjnvsisUjfrUzXLnXTINJAaw==@kvack.org
X-Gm-Message-State: AFuF++nrzfs+uIO7ZQVu/MLnslAOHmyvUs4Z85TQ5YqY+aO7XmLMVtq8
	TzHwWyBJHwI325qW05uLmqTxO5XWyOpLWiNiN9B5oUo3ny28eHYmK4HKBaE50P9Li10DA9bqdsV
	fa7Q+dQHqT1TLSdqx3cRczoI/7t9MNcHi6LzupAj2
X-Gm-Gg: AYBFou3mZjsbu8f5HCHJaQJkdV2WbIujTXZ3Hel/KStSDzaR4ya5SPzoerCW+QaYpkT
	4aIdKKuwJrHoB5x0UA9bIjWMWWvWtCLggXcMIVhAtiT6rBAmbOJRa4b9IfgOGV7TkDsksXtnh7t
	nms7TTv1dGn+bIW2s/VtUe9n17I2U4f0XB1Wj/CBVnSjS/ulPKDTCAyzxZstKbOzNXEohu8FrkH
	5ymRctGhkKfyU7say4byMFDISZ691YIlzdNxHESVx00Czwm62FMSUGBlb9jzxHlHa6/bJHR6pFy
	7gW5lwsj0cWFVPq0y0XYOatkvrLibWzbPedkKk5L8bfqrS+9xhlUs1i4KobB2tM8/SqYv0+tnNA
	8XA8FmYrNWd7qj7mwW7i9RpqD/0cDL+eFth91FjuV2Wolvi4p5lGVuY/OaVXRtnv9gcCea4orkr
	Rdf/MKP7EZqa3Q7BxTb5DakXtYXJyLIS7DJYOfY16ihWEE
X-Received: by 2002:a17:907:972a:b0:c29:f5d8:9c7b with SMTP id
 a640c23a62f3a-c2aadcc89c2mr10085266b.42.1790101714707; Tue, 22 Sep 2026
 11:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com> <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
In-Reply-To: <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 22 Sep 2026 11:27:57 -0700
X-Gm-Features: AcwNN1WpiJdEAyZo6q7FQIWGi9kaSoG7fR0e7eS1eUfch-3DP7u_DkgKHF6LhzE
Message-ID: <CADrL8HUdzE_ve49msaHksAYGoKmdr+kcTK0otG9wvsFY9WsywQ@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bryxw3wxzfak6hnag6gwzfc7nhxec3gq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C316340006
X-HE-Tag: 1790101716-41634
X-HE-Meta: U2FsdGVkX18GpLMZ/lASxczP/XmFVFyDK7ISN4O4Agsky/aPtMNaBKewYsS/24huJnL/roCiQfm5VmiLlDvzh1+uB6OvuN3IqD0BGCRGBf3Z5CH4W3FjMgC41NhcV04qI6DgUJCHAc4sR2xqlZ+AEY2KtZcn4KvtCHgyJ6GfMlJGg3550e8VBRvHRx9/T6O6L4cU6ypYP03LltUzIBrSzIriHsn/wzNkUrcrWtVapPYKGrp/z/h79pCpVboBldxwvMNVaQJ2K69MOFfJaIWz/VA/RbdwpoEZMoLWjcK04a6cLNL/6hgZldlPa9Ic8cQFhyDVZw0NLCRq00mqT8pC7yOPK3IsVTt1g1T+OPywt0KGIy5AaqLW/pby7hOk0XI8NM1HFqGYtp5wYqPlpMTRLEn5HPf/+f511cLMj49yKgS85tFWLOiyxis8y1jJKOTwtF5X5XZthZoaTWVjgBSw/axNApVbMX3olBGZ42Jx2kkP/BYAi0WzkQihgbvJK7PHgTvPmL40iHufIYMjrgIh1HMgQZQRjsM2YcMLvRysQnIyuRaJi47pQ8ZEgI8eQZsjXC5cmn1zPCPt8zf+DgVDjevQZzHhH5fYevpsf2w4Uh0ONf6gJAcisuvLt92MY32iYwV1yXSReyNddflL05kBj14WENahPwaC1ogMAQIwq80x150YSSnVrApLY4g68we4XpfrjWH8KF4R5iGyEfjSLcxkjjFpdEPQedyhDzHwlW5UroKfod5ENRZMjtQwpuYDWIpK5bhacw4nlQ6lbJ0ohcJUbkdzZUw8ouI6n4XGC4ITmkcmkbsp87lHXpuAsZg4XzHmPSiY/SPsbz9G2Sn05AIAz8VxkgvvLhB2sw2RkFluuO8273zxw+8QQjbYCiH1HnHeZClABeN9+8soLryimYuaftv9U1WqGw5Cp35aGI4zFn8XA7rzHUKsAjn75JCPDe5MTp2rvLdeX5nD597
 O761lTGC
 8xPmTRJgRyyxW3ESy57I/KaZutmIh8i5iFpdat79jHMqY8A4XFjf/l7CruuekE8ypbOx1t10LbhgtqzH/0OWOJH/G3WdrWZkiWth0NJ5LDj78f8ugeJHOHO4vZQuyzZ5PxiPEyOSd7tMF67Pdq1lQgTevO1E9AKEEmuhVF8ZVz8p3lIggnSmDOMYHIIxrdGxz0PDftuBFLHsIpdlQ69RtZ0LgdOdtClQ7BlImunlZVmtuQqqOgt5vOZGf3WOhOB/vA1O0yR7NKS/X/LDP87wTB/llRddvt4ulGIjq64LdF4zLfoqyJwtO5GO+qQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 12:01=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
>
> On Fri, Aug 21, 2026 at 6:39=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > On Fri, Aug 21, 2026 at 12:41=E2=80=AFPM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > >
> > > On Thu, Aug 20, 2026 at 4:39=E2=80=AFPM Joanne Koong <joannelkoong@gm=
ail.com> wrote:
> > > > Would you be able to share the test you're using? I've been trying =
to
> > > > repro it locally without much luck.
> > >
> > > The exact test uses some internal testing libraries, we're looking
> > > into whether we can translate it to a standalone C repro.
> > >
> > > From a high-level, the test:
> > > - Creates a VM with 260 MB (256 MB for testing + 4 MB margin) in a
> > > cgroup, backed by shmem THPs. The VM is not a fully fledged VM, just =
a
> > > KVM VM running bare metal code (so 4 MB is enough margin).
> > > - Enables zswap in the cgroup.
> > > - Tells the VM to write to 256 MB of its memory.
> > > - Checks the cgroup shmem usage and that no swap occurred (no limit).
> > > - Sets the cgroup limit to half the VM memory.
> > > - Checks the cgroup shmem usage and swap again, usage should be ~half
> > > and so is swap.
> > > - Tells the VM to read the 256 MB of memory again. This should cause =
a
> > > lot of thrashing and reclaim, but no OOM kills as all guest memory is
> > > reclaimable.
> > >
> > > With the ratelimited flushing, the test started flaking 5-10% of the
> > > time due to OOM kills.
> >
> > Hi Joanne, Yosry,
> >
> > I've attached a reproducer for you (as a patch that should apply to
> > Linus's tree).
> >
> > In tools/testing/selftests/kvm, `make` should build it. Instructions
> > for running it (like setting up swap/etc.) are in the comment at the
> > top of the file.
> >
> > As part of the patch, I've also included a sysctl to dynamically tune
> > whether or not the memcg stats flush is rate-limited. You should find
> > that when it is rate-limited, OOMs occur, and when it is not, OOMs do
> > not occur.
> >
> > This reproducer behaves slightly differently than our internal
> > version. This version, when run with `-b 512M` anyway, seems to OOM
> > simply by setting memory.max, whereas our internal version would OOM
> > upon re-accessing the memory. Not really a meaningful difference, but
> > just wanted to point it out.
>
> Thanks again for the repro, James.
>
> I added some instrumentation to prepare_scan_control() and have been
> seeing that the OOM gets triggered in this pathway:
> a) the memcg is created with memory.max set to unlimited. 512 M gets
> faulted in. The new anon folios get put on the inactive list. Nothing
> reclaims them yet
> b) userspace then sets memory.max to half of memory.current (~271M
> from ~542 M currently used). This causes memory_max_write() to trigger
> reclaim logic
> c) the folios have already moved to the active list (my
> instrumentation shows 122684 active vs. 179 inactive) when reclaim
> does the scanning, which means the only way for pages to be reclaimed
> is for pages to get deactivated from the active list back to the
> inactive list.
> d) prepare_scan_control() (which decides if the pages get deactivated)
> reads the LRU sizes from rstat. This memcg hasn't been flushed yet
> (the 2s flusher hasn't yet triggered since when the memcg was
> created), so the NR_INACTIVE_ANON and NR_ACTIVE_ANON stats are all
> still zero. The real values are all still sitting in per-cpu buffers
> that haven't yet been flushed. My instrumentation shows:
>         inactive_anon       rstat: 0    actual: 179
>         active_anon          rstat: 0    actual: 122684  (~479 MB)
> e) the deactivation logic in prepare_scan_control() is:
>
>                 refaults =3D lruvec_page_state(target_lruvec,
>                                 WORKINGSET_ACTIVATE_ANON);
>                 if (refaults !=3D target_lruvec->refaults[WORKINGSET_ANON=
] ||
>                         inactive_is_low(target_lruvec, LRU_INACTIVE_ANON)=
)
>                         sc->may_deactivate |=3D DEACTIVATE_ANON;
>                 else
>                         sc->may_deactivate &=3D ~DEACTIVATE_ANON;
>
> The if check fails:
>      refaults !=3D prev refaults: 0 !=3D 0      (false)
>      inactive_is_low(): both LRU inactive and active values are 0: 0 *
> inactive_ratio < 0     ( false)
>
> DEACTIVATE_ANON gets cleared
>
> f) pages don't get moved from the active list to the inactive list, so
> reclaim ends up freeing nothing. memory_max_write() goes through all
> MAX_RECLAIM_RETRIES and OOMs, even though there's 479 MB reclaimable
> (but it's all on the active list).
>
> I saw that the skipped_deactivate retry did fire (on 858 of 4264
> scans), but not enough to get the memory.current back under the halved
> memory.max, so memory_max_write() still exhausted MAX_RECLAIM_RETRIES
> and OOMed.

Great! Thanks for figuring that out.

>
> imo I think the best fix would be
> a) for non-root memcgs, revert back to the non-ratelimited version
> (mem_cgroup_flush_stats())
> b) for root-memcgs (which if flushed will flush every cgroup on the
> machine), don't use rstat at all and use the existing node counters
> instead (which is what the non-memcg case already uses).
> mod_lruvec_state() always updates the node vmstat and the memcg lruvec
> stat in the same call. For the root lruvec, the node counter reflects
> the same value and doesn't need any flushing. It has an error bound of
> 125 pages/cpu at most, but this is tighter than what we currently have
> with the ratelimited version.
>
> commit 90a6f2a8f442 ("memcg: use ratelimited stats flush in the
> reclaim") was what switched vmscan to using ratelimited flushing. The
> reason for this was to fix the stalls from concurrent reclaimers
> contending on the rstat lock. For the Cloudflare case, kswapd threads
> were contending on the rstat lock on 8 numa-node machines. That's the
> global path (eg sc->target_mem_cgroup is NULL,
> mem_cgroup_flush_stats() turns it into root, so this flush essentially
> ends up flushing every cgroup on the machine), which gets addressed by
> adding the fix in b), which takes kswapd and global direct reclaim off
> rstat entirely. For the non-root memcg case, the flushing is bounded
> by the MEMCG_CHARGE_BATCH * num_online_cpus() threshold (a non-root
> memcg's stats_updates only accumulates its own subtree's updates, so
> it takes a lot longer for it to be exceeded than the root's does).
>
> I ran some benchmarks to get a rough idea of what a) costs. I set up a
> workload that allocates 512M of anon memory in a memcg with memory.max
> set to half of that to trigger reclaim continuously. I varied the
> number of threads touching the memory, so that N of them hit
> memory.max and enter direct reclaim on the same memcg at once. I used
> bpftrace to measure the time spent inside css_rstat_flush() and
> shrink_node() and used those two numbers to get a percentage for how
> much of reclaim is spent in flushing. These are the numbers I saw:
>
> # threads      flush as % of shrink_node()
> 1                ratelimited: 1.10%       non-ratelimited: 2.22%
> 16              ratelimited: 0.36%       non-ratelimited: 2.87%
> 64              ratelimited: 0.16%       non-ratelimited: 2.52%
>
> Between the ratelimited and the non-ratelimited runs, walltime and
> pgsteal were pretty much indistinguishable (42.7s vs 43.6s at 16
> threads and 41.7 s vs 42.4s at 64, with the ranges overlapping, and
> pgsteal within 0.2%).
>
> I also measured the lock contention. At 16 and 64 threads, 15-20% of
> __css_rstat_lock() acquisitions hit a contended trylock with the
> non-ratelimited version. At 16 threads, the mean flush time rises
> about 8% and at 64 it roughly triples from the single-thread case
> (26us at 1 thread, 42 us at 16, 87us at 64)  but I didn't see any
> effect of this on wall time or pgsteal between the non-ratelimited and
> the ratelimited version, and the percentage of reclaim time spent
> flushing stayed at 2-3%. I think that's because css_rstat_flush()
> takes and drops the lock once per cpu rather than holding it across
> the walk.
>
> I also ran it with 32 actively churning sub-cgroups under the reclaim
> target, since css_rstat_flush() walks the descendants that have
> pending updates. I saw that per-flush cost rises slightly (~24 us to
> 27 us) but the share of reclaim time spent flushing went down rather
> than up (4.1% to 3.2%), because reclaim gets more expensive faster
> than flushing does. I don't have a ratelimited baseline at 32 children
> though, because with the ratelimited version, all the runs I tried
> OOMed. I think this is an alternative repro to the OOM issue but
> doesn't need/have KVM dependencies, so if this would be useful to
> clean up and send as a standalone C repro, please let me know.

It will probably be useful to send with the (a) and (b) patches. If
it's not very clean, just including it for demonstration is probably
fine (doesn't have to be merged).

> (Also btw (this is a bit tangential to this OOM issue, but somewhat
> semi-related), I don't think the WORKINGSET_ACTIVATE_{ANON,FILE} stats
> checking really does anything in practice. On my benchmark runs, the
> "refaults !=3D prev_refaults" check evaluates to false in pretty much
> every scan. Even with flushing working properly, it didn't trigger on
> 1673718 of 1674912 samples, even though the cgroup was thrashing the
> whole time (a separate run of the same workload counted 6371860 anon
> refaults vs 6523 activations). I think it's because reclaim is
> scanning faster than the refaults counter advances, so it'll almost
> always see no change. I'm not sure how much this matters in practice,
> but I think effectively in that check above in prepare_scan_control(),
> deactivation relies entirely on the inactive_is_low() check.)

Interesting finding. Maybe Yosry will have something intelligent to
say about it; I don't. Yosry will be back on Oct 6.

>
> What do you all think about adding a) and b) as the fix for this issue?

It seems like the right thing to do to me, but I'm not really an
expert on reclaim. I'm guessing Shakeel is happy with this too? I'll
remind Yosry about this thread when he gets back on the 6th so he can
give his opinion.

>
> Thanks,
> Joanne

Thank you very much Joanne, sorry for the delay getting back to you.

