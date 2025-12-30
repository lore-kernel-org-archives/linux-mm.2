Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9192EE01F6
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4185D6B0088; Tue, 30 Dec 2025 16:22:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5986B0089; Tue, 30 Dec 2025 16:22:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A5F6B008A; Tue, 30 Dec 2025 16:22:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 134726B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:22:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B30921AF0B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:22:04 +0000 (UTC)
X-FDA: 84277410168.05.7436F7D
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id C24131A0004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:22:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PlJ3KxBQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767129722; a=rsa-sha256;
	cv=pass;
	b=2BiWr29EVSTJHyBKIzccjFqYvVwGVoVQyCvXkXntdQOnjt4eowXcSHzgrFcpwgtE2wVpL/
	+hgR1kN/TG+H23I9WKpaPkXmpU6AyYwjgLH6PMwx00XY+Aw7UQDpQH79KQQ5iGxoYS3kgt
	/eAxcmqm0IedwS0otI9BewgDnMV/t28=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PlJ3KxBQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767129722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQrN+2rB3cWiVGcIG4F54rzpIEXG5AUtmz8WZOEiK4k=;
	b=XeO5pT9+4VOwbcAvc6FdS/xZRbPRR1Foa4Ndy1Z5w1avmnk197F2zluxK8eSrp8IlOQ0X9
	kZZTPgosjbk4RkUGw/dxdiJun+Jq/GmMuvNp8cyYypYsF3dxbmn17FyLqaNGlOV5znQl2j
	sIL9CuGmackhUdNF8xarlUWC8IrhVqA=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4f34f257a1bso59571cf.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:22:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767129722; cv=none;
        d=google.com; s=arc-20240605;
        b=WxPa3thUnWLk7ADGet/Ob6I9QH9PMjZdSObCfF7GtL0V0l/yXxml1++TRcLltc+7aN
         PpaTy52fyDXy7ywK2m/5iSEz8C72kQghaRB+EME33XaSIdksp1TTqzfhQgWYcekGP9h0
         vmOVdgz7npc3gv+xP4iOn+9I3+GNAkd8jYGrsv8fAejNeuxKSwJiEMi4s9QC1x2BNf8M
         Rav/LGZ3o5SEiyIuM417MV7itopNRwg7PZ4KBZLLjkgUwJ/ENwqtdFO3oEv0pKx92QAk
         Uu2VNlGpjbjTEGGANdfBzO+7fdfGhVfXW1+9Y8jqUZuvRWgBfW9M4+PDliNF2vvEc/4j
         89JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IQrN+2rB3cWiVGcIG4F54rzpIEXG5AUtmz8WZOEiK4k=;
        fh=zeK9ktROIFftn8qmyL1rZuxTTqZ5AfF0QvPnhTO9PTE=;
        b=bnaRmrg1ub1gHrOpz5B+tFGBfSC/KagyrIBpN5TvzvWQxBHXJ9wolqPSDQFU3Ug7iX
         mIcEUeGF+EKCBPTek7aCT0H4N1oZ2gtc+F5T16pDqt4FICNhlXkEDZWtK4XAv7YARw3k
         7ureI/+JMIgtxogKoDUxObguFc+sGj36q63d1doqW5ts1jovafgyNUTBNAbld2LxaM1j
         yGjc4CO/C+3mde/S4/UyHLAjLznVP5m7sJWuVYAXKrxouo1PONrzKU5CT+BbuBg+6h5T
         Fhw1N7zK43QKv/35JswZjbzWeFqqnfaIOC5Y83Rvv+3jo67IfeIl4NWV7OoJzGNDSuqE
         gfnA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767129722; x=1767734522; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQrN+2rB3cWiVGcIG4F54rzpIEXG5AUtmz8WZOEiK4k=;
        b=PlJ3KxBQ+PE41py8H5M8mgaYg9Wmvo7nJUdXEzCYGH8Yvl3GMSVGcl2RyR8sGgpUF3
         WrZWCYrTUEvsEZKL8i+mljINwU4WKqdNrQACG7fy/9xvE6rrixJUZ4ntOZL8cnyz1XmZ
         aCZzOaDD/XC8sPc1b2m5RXW0GlB8KRVoYdF1a8upHwKFbVG1f+a7QN+wF+MLe1U7YNoh
         xkl97aOj/QoOtAJaXbLev3IX9KaBPL7sDGA6pry1KjhiWUxTsMD/zNlOJHTMCYNj5BRh
         wG2gEcfXbMbwww6K8ccx4hJ+ThFvSI4E97B9tgGymMWBZ3egQKAytIFveUtgGNhMrni5
         zYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767129722; x=1767734522;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQrN+2rB3cWiVGcIG4F54rzpIEXG5AUtmz8WZOEiK4k=;
        b=gh/359BeKL342NQwTJtnf2bsjWoqdyh6rXsIAVsn5aWPuRnwh7wnakGpQdWInUn80m
         DEV9rQjODFVfMhFBLH76JtcaxONZewwDSMIUGn6dLpjba/McrcUGG3u2thUVwOvdU+ty
         4XdbL44XEPcgPZv6fVcejRJBVFg0FI+MnaOuwLKa4Ys2AXA8efcp3ZhjjZNPWFo2gUXG
         R4WFN2B/SeVwZ9Ma8vsniFSqBU52Ud5tBARSDcKxqTb3Kk76d+/fIKHDrCOnKo6sw1hD
         xgSktjwM/i+7p3YyeWunsvoDXKPPh9w7cBV/Z7uHrbRenjS/Yf9hsLuKHEGVO93buJKn
         3m1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWs/aA81T/xWJbaTvBMR1OCdoKdVMwkoYuKVuCMtEbIgV5z0LTD8c7KP9z6KQhH8rPZC7smDJMr8w==@kvack.org
X-Gm-Message-State: AOJu0YxpMInxpQyRpJPXSHWoZiskVAF2Oi8VHX/a3sAkwqA4VxRikEz+
	IUOuvMGMGPuCZzJB2VM58fPJb7mlvGorLTVx87waW7ojakdUlJe6SWERUb40yYTnnLEw9SSDtns
	Bs8e0qjkY/v4AzCPriFrdFxLQ8eWmu6fmg9Y3H3Ku
X-Gm-Gg: AY/fxX4vvYKisgDyMMYUQv40mHkz2IARBby72tOL3b+wPbT/stQkWerPgAyBGjHKgyd
	BgusoOqkmpe9AIW5CvpqR194VXfTW/wSFl0jUOPCFSfKFnaqa2cKUjOUg/g1WjvBKvpz5VQskCh
	sKacUwpz3xPWnbmm38YDWt402rci5POO2VXx8z+7U3f4tlxwfydF0tQW0U70GlmPmCvET8cAliJ
	THVkjQxJjoscx8TklXOLSgX7fvYt9ORg4AXKDmCyxEopWurkkhVsVqMMOIosTIt9ivYkopKZAWl
	unaKDfjZl0rq9H34h3nnGYDjnQ==
X-Google-Smtp-Source: AGHT+IGHo1RLWSWmLv2BBFK2cH5G1jrblcoFzel3R5Jg+cTq/s6H7omOzURLKmUdNx+rI0F2B1inZ1idc0z6e8SnRl0=
X-Received: by 2002:ac8:57d6:0:b0:4ed:ff79:e679 with SMTP id
 d75a77b69052e-4fbd687b731mr824201cf.19.1767129721485; Tue, 30 Dec 2025
 13:22:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce> <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
In-Reply-To: <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Dec 2025 13:21:49 -0800
X-Gm-Features: AQt7F2qbFtKydtQ52uNm8uz2mDtojpMSCpcNV9YoryPz7xCcMe1Hsus75yD7G9U
Message-ID: <CAJuCfpEsGcLikHyXeqG5NnRLy9+A66--=3XPbhR1qMxUY5kywQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(), unlink_anon_vmas()
 comments, add asserts
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C24131A0004
X-Stat-Signature: fowu4iya5a197nteik1mapmzt5g1wsr3
X-HE-Tag: 1767129722-190643
X-HE-Meta: U2FsdGVkX1/DTtyoUC9a90v91F0AQR5VvHoIdhkaUfm+penDL6iq1YiKFSCQYfIZUeP5NW8+1hxdSiA60dYhYnrj/3WKbzqM9NEpq+nyQyc6JYPqWvHknIGHeoFHcb5uVOBL998nE8IEv4+WuJsEqqY4lcaR+BRLnSF6Gpg/p5WJApemuar6/YcJuSxVgixzQ+JkIxXyaBPt8gyLPTyAyPL3pANey/xx30IDFjD7NqbCc0ow+tXPCPwBeMXSDHhEbxyhigumQ2tX6zNRR4dQa12olwjq5G6l7MMcfFma6nylU0GKi5gyznITAE1iuTv9eqKt5mRznR41cIEOK12bMo8BmVazgXJBgwtPxi5MdEyVou2/K7ui06oNFyCB+YufbQ5AxrRizCE21z5wY+Rkyk+ii9nDaWZhcd6zWbaG+3KqfmfefJG9+4GV8rOJzGlZzdqU4g4SuLQNsBP2aY5wmrZT2ZuzfPDg+DBG86bWfCosSAt1qmtJB4TOoLsRxahf4vakwpyXYzxNKJfgE7IkafXsdPmytZHf4L3N7eIEFsA6t0//fQEfIkUGZtVMC2LoUqAWRELCL3UQk/P+dSbrhlf6j7+AL184fGZsMCzDW0+4VjvF6mWetwLF2/i8T+08ViYLB9bF8sztHpSEw4RamBvo5zwHbj09+zN0s+6pkqRBqIJOYNHduzFw96clqOlOM2OvUNPGA0BESZ0crJp5M8mrA/3QMpq5fpVVozskVmPeEXGkJ0hCklWxqep2ARgfBetu9vpFBRV07TMy0w2Ymt/U0ptRy68jDxzJ6jW6nILCi3++Oa6XtSGevoGGMS4Ot7t7BF2DEriwRtKCtJVFppsGDyLfLrES5wsAxjLRvuRubpq9t4akiSFAL6FfsPRerxBvdsAWxI3OtvwhZmFQw46azsZaQw8E9N/xQtDokiZkiEOmN/KuWUxpMXnHrMHxY8fpfxfWwYoiPYz/2iT
 7cxEcl+r
 MLwkL0W2rTkDbGY7CJtYCwFzds2PnMgaSdW65lGbmckiJboouB2bOcKHjdw8eTxrqAeSdSkbG6y5qmUWTxHNgC0rWzLKhqBQuO0SLtKMJSKd6ArNWqDWcxMpk2C8EIRrt++x72zYBmnK5yUCT9x0Z/pIhA0tWBOqJKO1LwsYAZGZXcURsOikJejLJLfriiy+QVfbpzPqENRJKOyA6buwJDBgaCmOhHvoyA87HEIuu2Wa/RNj66cfYsUcL8vGq1OvKRxnomjJdkSYGwZZiwoPoxHYIO1wrer4Y5k8vGwEdy3WQmCHoEMgkN/u6mP2gtg79GfwfOZJHXL6TPVugqxQRHyizeKqI/cTFNW35Gj7szsBZfxy0pZmMtvV3kkKqsqXf4aq8Q0dlWvase7o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 1:18=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Fri, Dec 19, 2025 at 10:22=E2=80=AFAM Liam R. Howlett
> <Liam.Howlett@oracle.com> wrote:
> >
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > > Add kdoc comments, describe exactly what these functinos are used for=
 in
> > > detail, pointing out importantly that the anon_vma_clone() !dst->anon=
_vma
> > > && src->anon_vma dance is ONLY for fork.
> > >
> > > Both are confusing functions that will be refactored in a subsequent =
patch
> > > but the first stage is establishing documentation and some invariatns=
.
> > >
> > > Add some basic CONFIG_DEBUG_VM asserts that help document expected st=
ate,
> > > specifically:
> > >
> > > anon_vma_clone()
> > > - mmap write lock held.
> > > - We do nothing if src VMA is not faulted.
> > > - The destination VMA has no anon_vma_chain yet.
> > > - We are always operating on the same active VMA (i.e. vma->anon-vma)=
.
>
> nit: s/vma->anon-vma/vma->anon_vma
>
> > > - If not forking, must operate on the same mm_struct.
> > >
> > > unlink_anon_vmas()
> > > - mmap lock held (read on unmap downgraded).
>
> Out of curiosity I looked for the place where unlink_anon_vmas() is
> called with mmap_lock downgraded to read but could not find it. Could
> you please point me to it?
>
> > > - That unfaulted VMAs are no-ops.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >
> > > ---
> > >  mm/rmap.c | 82 +++++++++++++++++++++++++++++++++++++++++++----------=
--
> > >  1 file changed, 64 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/mm/rmap.c b/mm/rmap.c
> > > index d6799afe1114..0e34c0a69fbc 100644
> > > --- a/mm/rmap.c
> > > +++ b/mm/rmap.c
> > > @@ -257,30 +257,60 @@ static inline void unlock_anon_vma_root(struct =
anon_vma *root)
> > >               up_write(&root->rwsem);
> > >  }
> > >
> > > -/*
> > > - * Attach the anon_vmas from src to dst.
> > > - * Returns 0 on success, -ENOMEM on failure.
> > > - *
> > > - * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_=
vma(),
> > > - * copy_vma() and anon_vma_fork(). The first four want an exact copy=
 of src,
> > > - * while the last one, anon_vma_fork(), may try to reuse an existing=
 anon_vma to
> > > - * prevent endless growth of anon_vma. Since dst->anon_vma is set to=
 NULL before
> > > - * call, we can identify this case by checking (!dst->anon_vma &&
> > > - * src->anon_vma).
> > > - *
> > > - * If (!dst->anon_vma && src->anon_vma) is true, this function tries=
 to find
> > > - * and reuse existing anon_vma which has no vmas and only one child =
anon_vma.
> > > - * This prevents degradation of anon_vma hierarchy to endless linear=
 chain in
> > > - * case of constantly forking task. On the other hand, an anon_vma w=
ith more
> > > - * than one child isn't reused even if there was no alive vma, thus =
rmap
> > > - * walker has a good chance of avoiding scanning the whole hierarchy=
 when it
> > > - * searches where page is mapped.
> > > +static void check_anon_vma_clone(struct vm_area_struct *dst,
> > > +                              struct vm_area_struct *src)
> > > +{
> > > +     /* The write lock must be held. */
> > > +     mmap_assert_write_locked(src->vm_mm);

As a side-note, I think we might be able to claim
vma_assert_locked(src) here if we move vma_start_write(vma) at
https://elixir.bootlin.com/linux/v6.19-rc3/source/mm/vma.c#L538 to
line 527. I looked over other places where we call anon_vma_clone()
and they seem to write-lock src VMA before cloning anon_vma.
mmap_assert_write_locked() is sufficient here because we do not change
anon_vma under VMA lock (see __vmf_anon_prepare() upgrading to mmap
lock if a new anon_vma has to be established during page fault) but I
think we can be more strict here.

> > > +     /* If not a fork (implied by dst->anon_vma) then must be on sam=
e mm. */
> > > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm !=3D src->vm_mm);
> > > +
> > > +     /* No source anon_vma is a no-op. */
>
> I'm confused about the above comment. Do you mean that if
> !src->anon_vma then it's a no-op and therefore this function shouldn't
> be called? If so, we could simply have VM_WARN_ON_ONCE(!src->anon_vma)
> but checks below have more conditions. Can this comment be perhaps
> expanded please so that the reader clearly understands what is allowed
> and what is not. For example, combination (!src->anon_vma &&
> !dst->anon_vma) is allowed and we correctly not triggering a warning
> here, however that's still a no-op IIUC.
>
> > > +     VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_ch=
ain));
> > > +     VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
> > > +     /* We are establishing a new anon_vma_chain. */
> > > +     VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
> > > +     /*
> > > +      * On fork, dst->anon_vma is set NULL (temporarily). Otherwise,=
 anon_vma
> > > +      * must be the same across dst and src.
>
> This is the second time in this small function where we have to remind
> that dst->anon_vma=3D=3DNULL means that we are forking. Maybe it's better
> to introduce a `bool forking =3D dst->anon_vma=3D=3DNULL;` variable at th=
e
> beginning and use it in all these checks?
>
> I know, I'm nitpicking but as you said, anon_vma code is very
> compicated, so the more clarity we can bring to it the better.
>
> > > +      */
> > > +     VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma !=3D src->anon_v=
ma);
> > > +}
> > > +
> > > +/**
> > > + * anon_vma_clone - Establishes new anon_vma_chain objects in @dst l=
inking to
> > > + * all of the anon_vma objects contained within @src anon_vma_chain'=
s.
> > > + * @dst: The destination VMA with an empty anon_vma_chain.
> > > + * @src: The source VMA we wish to duplicate.
> > > + *
> > > + * This is the heart of the VMA side of the anon_vma implementation =
- we invoke
> > > + * this function whenever we need to set up a new VMA's anon_vma sta=
te.
> > > + *
> > > + * This is invoked for:
> > > + *
> > > + * - VMA Merge, but only when @dst is unfaulted and @src is faulted =
- meaning we
> > > + *   clone @src into @dst.
> > > + * - VMA split.
> > > + * - VMA (m)remap.
> > > + * - Fork of faulted VMA.
> > > + *
> > > + * In all cases other than fork this is simply a duplication. Fork a=
dditionally
> > > + * adds a new active anon_vma.
> > > + *
> > > + * ONLY in the case of fork do we try to 'reuse' existing anon_vma's=
 in an
> > > + * anon_vma hierarchy, reusing anon_vma's which have no VMA associat=
ed with them
> > > + * but do have a single child. This is to avoid waste of memory when=
 repeatedly
> > > + * forking.
> > > + *
> > > + * Returns: 0 on success, -ENOMEM on failure.
> > >   */
> > >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct=
 *src)
> > >  {
> > >       struct anon_vma_chain *avc, *pavc;
> > >       struct anon_vma *root =3D NULL;
> > >
> > > +     check_anon_vma_clone(dst, src);
> > > +
> > >       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vm=
a) {
> > >               struct anon_vma *anon_vma;
> > >
> > > @@ -392,11 +422,27 @@ int anon_vma_fork(struct vm_area_struct *vma, s=
truct vm_area_struct *pvma)
> > >       return -ENOMEM;
> > >  }
> > >
> > > +/**
> > > + * unlink_anon_vmas() - remove all links between a VMA and anon_vma'=
s, freeing
> > > + * anon_vma_chain objects.
> > > + * @vma: The VMA whose links to anon_vma objects is to be severed.
> > > + *
> > > + * As part of the process anon_vma_chain's are freed,
> > > + * anon_vma->num_children,num_active_vmas is updated as required and=
, if the
> > > + * relevant anon_vma references no further VMAs, its reference count=
 is
> > > + * decremented.
> > > + */
> > >  void unlink_anon_vmas(struct vm_area_struct *vma)
> > >  {
> > >       struct anon_vma_chain *avc, *next;
> > >       struct anon_vma *root =3D NULL;
> > >
> > > +     /* Always hold mmap lock, read-lock on unmap possibly. */
> > > +     mmap_assert_locked(vma->vm_mm);
> > > +
> > > +     /* Unfaulted is a no-op. */
> > > +     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_ch=
ain));
>
> Hmm. anon_vma_clone() calls unlink_anon_vmas() after setting
> dst->anon_vma=3DNULL in the enomem_failure path. This warning would
> imply that in such case dst->anon_vma_chain is always non-empty. But I
> don't think we can always expect that... What if the very first call
> to anon_vma_chain_alloc() in anon_vma_clone()'s loop failed, I think
> this would result in dst->anon_vma_chain being empty, no?
>
> > > +
> > >       /*
> > >        * Unlink each anon_vma chained to the VMA.  This list is order=
ed
> > >        * from newest to oldest, ensuring the root anon_vma gets freed=
 last.
> > > --
> > > 2.52.0
> > >

