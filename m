Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D4EECD6E6B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:52:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3886B0005; Wed,  3 Jun 2026 14:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95386B00AC; Wed,  3 Jun 2026 14:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9836A6B00B1; Wed,  3 Jun 2026 14:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87E6F6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:52:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B39212055B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:52:03 +0000 (UTC)
X-FDA: 84839496126.25.A3CCB18
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 385A320005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:52:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mFO4Niec;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780512721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5vL3r211abayjz91d4jpb2IiE8lVazmF4WtAPu6R18=;
	b=XnzGv/BjyxzLAWct4HXlTtlf+fTULQJKl+HPBR3+LOEhaPB5mIqrFTbjcqsGMxxniDwsUL
	ZWI2ICYUarLpzeYMynvO9zAM6bjQ0hWq4fof/tn74bJbsYs3YIGBGY6TqwtT3r9hvuxL37
	wWAq46QLqhcSJkjycb4kZxzCZh9O5ZI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mFO4Niec;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780512721;
	b=8MbL29brG6SDu87R5iDjMJdsB+FPmQeHZhCP1kqqqD6j4j8QDil0n3T9OFGlzx6i0lqKJT
	iayujMYlPRwKU8snwVc3SHDSgWbBV/S6CJYMp6Rwu9/2DKGVr+nunAcqhwlBV7YiROpLaX
	9MoBCLEkoKhk2n3Xgcu1L/f+tnRQVgI=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45fe59255beso2460675f8f.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:52:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780512720; cv=none;
        d=google.com; s=arc-20240605;
        b=FDEROJt4ugc1f61wm+v86RmrblR8y4bw4B+20KmENhy332DM7v9mg8m8y6+TNtoXwX
         k+NyQAtjdkueEmX2VzdNAoPH+bZqeQITCM4U1MhshVt/EqqDWkFx2k3pIKI0bVNQs0I7
         ETW4RqaG+kFpeG1MEFc9G/pppdM0PMpFabV0bCdgLl0d4q+PklG09ZHQ4r5/6m+w3Bqv
         h6BGGiTVAA2YUaXbH0i9l0RGV+uiZ4FvqjrOVYfHrNNZ4j7F/WZww2azM3cs431gx85l
         1z+NAdoQ+1ocOJawGkJM1pT76Kjyllakjr7nRLYwNaATNEgwXvbt0uG90/AIcb1pGMi1
         i7sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e5vL3r211abayjz91d4jpb2IiE8lVazmF4WtAPu6R18=;
        fh=Zj5tQaXY1lFhLtwyztZkPn13ohVCcf7AVdSFKPGqLkI=;
        b=NzVKYArrm/eqk3cjRMydcuNikuTugArZZLXszqTfS6Uw5HDaea59e2TiPJYiwcHgpL
         AuZjuHPbpBL1oaKbWk5kfASmhgR/hn9tdvttPC95xK/fuhrpZ/bi5nVT3gtQSn8GzHAv
         q6EmhgPANZST/xyqWuzz4nlAJ4ER2lYGvMAlh0SgrQtV9ELl3RskcMcq/ZcWmQ/7W2ij
         cA3Zzp0hMhmMZsLP1de1r/WFTntXU1NrdfOkPcqadn7/plFuWfnGr90LBcQqRWTUdZpP
         RfH9EjNe7Ksl6evP50rBVDL1YQrLUSjdHqIgc/4yNVUtchQBMlpY25s0ZOGdBd7e0o4Y
         fxiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780512720; x=1781117520; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5vL3r211abayjz91d4jpb2IiE8lVazmF4WtAPu6R18=;
        b=mFO4Niec3hp0JKHOLjLbsq6Y4YCEIUYqyGrrE5NC6DNyQLtga8AnK+j4JioIK/enpF
         oKOIu/s+6IIMYhKLn6IaakGz9pllapJDitvTN2Rc/OADou8dnrpVsk1v3LcL9Xhw39Tf
         3eF95EvQ21N2JUUs4zWg8X5nTd94GR8f43Ylmw8VkbedJnVKohPSOMco4BmohnccdQW4
         ZVFKK/35CmmI9T+axoDtpZ1kZPd+P4Y8srghO5gjC4GAOk5kB0+BMnx7ejxgka3Qcc5o
         cYq9fw7EI1bK9NOFNllRCbb7cLRRCRJeaCmUsEbrg8A8fa2x4XtaDk/Lvwh7J+zFflzy
         oi2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780512720; x=1781117520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e5vL3r211abayjz91d4jpb2IiE8lVazmF4WtAPu6R18=;
        b=LidSNvQfdVcmYghMu0rDXCw7lpSy3EbzraRK5Gz4T1s/NNtbnSuoY+lcdSSpOvbZri
         mMTgl4nrTmqny7LXjo/dhC/9T4O9emizCX8RfABvYLX9TwO7FXnLhjCARDwc2HUyPPBj
         xfE5wTcg/K6O1q0BdlYqL8pGIanAlU9Jwly+4ipi9NjHlek64/oPjxul8yHMkrtMI5Vw
         3Lb+/c2TfVBu3agAlGpIOxaZF9Y7j5PfyjT/DpMY/5mOXcE/Ypol7V/45tO2PRnkAK9O
         rnrvBDrvJr3Ke4Wb1BpK7q76iYZbOW/NXpC7vsYIXa3y1giuExdH5FNj9qO5KxMwiuDf
         5fMw==
X-Forwarded-Encrypted: i=1; AFNElJ/AGKaYPtzMInfKPft2L14gwKxnU//wMIfiftR4F6UU3M6E9YFIH80lyyxsbgJzlTuuOFT6lQj3fQ==@kvack.org
X-Gm-Message-State: AOJu0YyrkxxsLnEvvzn9omte1jCT+JoRSPQJ4N2ixxi2LhuAicafMSoi
	baKof96y/9JMmc6WGOwzWb1Eux+FtgJSNcBzFtINVBE/SQeydDyuJ3aw6fS9KUmTPg5y1hprTy+
	56Rq8T4cK8p4P2/MloJzUyjgyIa40gN0=
X-Gm-Gg: Acq92OH3B7jgBBjYQJPUnzfEiAZs7Wm52+Rpq3+dWXe43t+/w/fZSBKp/ZEyXk0kfvY
	vJlWOM0GEUWwY5SRYrvNNV4vVMCVs8H5M4YsHU4LPOZuHnFEM7BOJlPsVLQqhlv5/7A+fN0Wp1N
	Bp6YYKBOoh5XPN+M8bjIIThdijNcf/Mao5ea1mHR/MSBy8JjKdHeeW/d4RdnmoxPOW/CcA3sV6v
	aolKrFOhLrLsRfi88Gke0eMmoZCHufbpqhzvVKI8M5KSbCvFBM73nbzHQzOpuEEO+bkKx/U00D0
	LSLdOfimrtJevFAKyGZBsK3dB2WJTCHfHv/r+mmgCsWD9y0JKg==
X-Received: by 2002:adf:f8c4:0:b0:460:e0f:8d19 with SMTP id
 ffacd0b85a97d-4602179121cmr5600969f8f.9.1780512719668; Wed, 03 Jun 2026
 11:51:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
 <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
 <CAKEwX=NQUqqrM9vdYE2KhWEZx-YwPc7YPhfz7xaBrGVDf824bA@mail.gmail.com> <CAO9r8zO0GjTeY2+j_AjfTQ8qYOmHezZAV44f=aPgrjJcdtO9rQ@mail.gmail.com>
In-Reply-To: <CAO9r8zO0GjTeY2+j_AjfTQ8qYOmHezZAV44f=aPgrjJcdtO9rQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 11:51:48 -0700
X-Gm-Features: AVHnY4KKCfMou4Ez8iKWPLzU7z8Pcq_wTI6Zo3Ilq6vW5_DwwK6THGlhJPcI_cw
Message-ID: <CAKEwX=OeFsFPdazWFf0tsKTOi3DneX3fCcreEkzwb=BOR_37hA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: hf3oj76wcqdgzpdjz9myz6n6fbe3c8yq
X-Rspamd-Queue-Id: 385A320005
X-HE-Tag: 1780512720-533057
X-HE-Meta: U2FsdGVkX1/jP4ptOSsKHpZYM1DOauKc9KyPyChCJ+Ne/31sWa8MfsnYa/m/91nmr2wd660RwgNOvVntTKHzeb+pnenLwZk4GNcvCwHgbMDF9LgY7HIQPheVOuv78LK+6ioAAB8pgmypjMF08C8E/E/RlSQ4KQOSGYxTyVVFXdfKgKzSHU1lXaqzaJs7OJTx29FY3GfYgCGkzrppjrO8jTXKDNZI+nJFNSHU5fgVmv7VS/07rIPS4qWbBY92sYdcDGrzxeBJ5603Gf5+VSwPlbcLMD1OnELfXDxrJ0q734CY9CJ1QriHRkp9qDtk6BF3bbSw9rnjcf7AiRGxgKfKoB5gzbT8xPWXplqdYAlZPlojdIi19PvY9pa6nDUGEbyCPVqLhk4P9CTvvG8LHRnCVPkVUXHgK/lM2VQIE2LJMHuRp7Lf5jsD5FsKTmoBeG7/GNzrPZSCCT6QDrQTGnoYOekyUklhPzhGCnNEbgDE+8IWnSRwF9gxYoTqEmTf93M0CZXdTPpHZx7IOXMwER9ffYYFsrJlWV7CIjzER7fL3n4XPzJops+MPUu0tUlSPX6+JpIxFR5hxnwuPF0EW4ViS3I71tm6pP8RVo1BADDzo2BggV1CjO0CDr41JEjPwVANLywpcVtLABSvDB6nZl6CZx6n1ztv0qTKsCFirdodMD4VxmjZTjSmCF1zPqgp4seX5AC1Y/ezXd5fEtw3IZgEsP6MgKs4Oh6NgE/lV/wjqdTrbct2CKgGKusM9DZme8mJfINxijLJkaanu6+AnfO3GW866bk9QzV71Sf05A7CXm7ModhbxTcdCAzlch6akZydSfPR5B1D1ev/qfQpUVzHWdRZ6D5//Q6Ge5BH5xb/+lfWGGLWorspOM5ZyzPBaw0FKK/LOVDk27u/OzCD7+bcVAUncmEtbpvWZ+aQCszAE2HvwANM/DwHbILB3JvkjlsGmWhWeQoNt/DjlX35IMa
 g6uJGXh5
 xs369eJK/nUc6Rtce3yKoyKomonp+F/1SJtSLV5dVQpsNu+HYCoSqaJqvYbmsJmogxrg0n/HGk2sUkJ4rT8K1otV20Phxzde5/OBre0/wFAHlii28uGIA1wfUWja+pT0WVelNXxEjduT7+DZRz0+fFw0dWkebfQd3PNJy7Hs50z8gABxYr6w7vsmE07bKSwJx8WoY0h9O3wWjp+aNUisrSoJGAoL/XzeUKiuZ/lkQUAWr2O0aeDrQ0/hQ0Afba2rjcRu4teAJwyNJySHSoyqtz55WTaBVxucBCFfeNm496juF5iW2b4sC7huKU4wA1gTNlBBIvjzK45n94HzuyUF7MzsvJNnNvpdARq4vCvNELTVIBrHeyfjpG6HSxKD0eaGvan+jCEYggeAfjMHw8r4Ie4U+yeuhbFS4SB7UhwOA4ig5Bh2ihPxV9mNEHeWTynSERClYUMZ/MnNyDI3LeOKHQjv0J/13UdU467zt9TNg14FKkTue1rLkgVUY/psV3kYvexwTeRpmd+pvF+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 11:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Wed, Jun 3, 2026 at 11:34=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Wed, Jun 3, 2026 at 11:26=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > > > > Is the main difference that we are scanning in batches here? I =
think we
> > > > > > can have shrink_memcg() do that too. If anything, it might make=
 the
> > > > > > shrinker more efficient. Over-reclaim is ofc a concern, and esp=
ecially
> > > > > > in the zswap_store() path as the overhead can be noticeable. Ma=
ybe we
> > > > > > can parameterize the batch size based on the code path.
> > > > > >
> > > > > > Nhat, what do you think?
> > > > >
> > > > > Nhat, since we now have the referenced-based second chance algori=
thm,
> > > > > should we consider doing batch writeback for shrink_memcg() as we=
ll?
> > > >
> > > > I just take a look at shrink_memcg() and realized it's reclaiming o=
ne
> > > > page at a time. Thanks for the reminder - I hated it.
> > > >
> > > > Please batchify it if it makes your life easier :) We don't reclaim
> > > > "just one page/object" anywhere else in the reclaim path, Sure, it
> > > > adds a bit of latency to zswap_store() if we reached cgroup limit, =
but
> > > > IMHO if we hit zswap.max limit at zswap_store() time, that is alrea=
dy
> > > > the slowest of slow path that you should have avoided with proactiv=
e
> > > > reclaim/zswap shrinker in the first place. And, setting zswap.max d=
oes
> > > > not make sense to me in the first place (I can write a whole essay
> > > > about it).
> > >
> > > Should we batchify shrink_memcg() from the shrinker and background
> > > writeback, but leave the synchronous zswap_store() path to reclaim on=
e
> > > page for this series at least to avoid potential regressions?
> > >
> > > I think this change specifically needs more intensive testing (vs the
> > > other code paths).
> >
> > I'm fine with having shrink_memcg() takes a batch_size argument for now=
 :)
> >
> > I suspect not a lot of people invokes the shrink_memcg() synchronous
> > path in zswap store though. Setting zswap.max is hard (as it involves
> > guessing compression ratio ahead of time) and induces quite a bit of
> > overhead (obj_cgroup_may_zswap() does a force flush for every store if
> > you set zswap.max to a value other than 0 and max).
>
> Yeah I agree, but I just wanna make sure we don't completely kill
> performance in case anyone is actually doing that.
>
> Regarding the force flush, it's unfortunate that we need to rely on a
> stat for internal limit checking. It might make sense to use page
> counters here, which already support hierarchical charging and
> whatnot. We'll need something similar to the objcg approach to charge
> sub-pages (or maybe just reuse that somehow?).

Conceptually, I've moved towards not capping zswap.max, and using it
only as a binary knob for enablement/disablement  :)

It's consuming the same resources it saves, so if we cap memory.max
(and swap.max until we have vswap), then we already have isolation.
The split between uncompressed/compressed should then be dynamically
determined by workload characteristics (working set size, access
pattern, compressibility) and service's SLO, and reclaimers
(preferably proactive reclaimers) will drive us towards the optimal
split/equilibrium.

