Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BFEC54F57
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398076B00A2; Tue, 28 Jul 2026 11:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348856B00A3; Tue, 28 Jul 2026 11:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25F516B00A4; Tue, 28 Jul 2026 11:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9E266B00A2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:53:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FFA91C0B73
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:53:43 +0000 (UTC)
X-FDA: 85038630726.04.D1CE7A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A729100007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:53:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fy/5mDHO";
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785254021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVWKWXWp2o5oguf9HQN9RBLTt3LptAl4yCTE8p8gHSI=;
	b=hWTYLt+9fkCmpDp7d2mqtwIMhYlqJfSPj06fzQBZTTFtdMIC7pOoCBKnDraMoQKXvAeVnI
	rIoN2qkLbfyvqmJVRBXz01vASuikJtfpXdowzmtMCUwRcGexqugLd6ISSRC9GsG5Ee/imC
	YM7za2g7fHrfPuged3m7w2BKQ6OGjoY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785254021;
	b=6y7P/Yqs+GP8IFIRlRDl5oWvqKCnkEm6gTozsr4mS3IXWeci2skV0IWXHo5fthIRbnD1to
	ODer/MfWo5INHykKe4q/1GsSaMd3A3BRuxwVRJHcL3UguAv9cVcIm0iKmYPTGDQrUwbc+Q
	OlH39q7Mbw2IOPGDUiMoAuMEnfDZDv0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fy/5mDHO";
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C23A960A8C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E891F00AC4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785254020;
	bh=iVWKWXWp2o5oguf9HQN9RBLTt3LptAl4yCTE8p8gHSI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Fy/5mDHO4xjwvtptQQIrg3rcpbEvXl0bMZtldcBXePysyTwuqvePmK3S9auaC0OhG
	 LWEDDurQH1PZIoZYlyGP6B3MVkJC9+vXu1eHr8gpLMQ5Em2vVSY/hA7zzujuUtVvbD
	 V+KJZ5mYw5ihuODbz9Pq6rZvnT34KZSSv6ZGd5kL6Xu3l6AsK9BGM/EzB9EeRdFvBB
	 WcoJQ9AjPtoI8HFo3/43uTPvBij5Fm1pFJVaxAkgCSu8bNl8sES8o1drRAqGfGpqQR
	 1rNEqwnZaJrk8yfH2d1qIp9fjvoYWkoPxKqX4+0tFWbJfVDTua8t2iOY9RDJJ1n4kG
	 pj6Xz5M6IIy8A==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c1712a04ddaso646753166b.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:53:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro6ArvwtISUcd7ZZNCOHlhSRat233ObPVL4xLpsRYMGMP+jHFglamXrVmDRSBPmyXyqRee8lAk/Gw==@kvack.org
X-Gm-Message-State: AOJu0YxDozJsvqV0UufORjfAT2BpHWK+Mvz0yEYnHdBKN36n6Xdei9fR
	hsrvBuSiMU24HtmRrp2wKOvnSb63+saqcFD6QiZJagSL23w10ITR5nUWTJtRbsI/6uyUfPFMRSN
	Xf6tE8H0eEgfclpbJf3DK4VHYzvqoON8=
X-Received: by 2002:a17:906:6a1e:b0:c16:4df6:176b with SMTP id
 a640c23a62f3a-c1f71daeeb9mr146358666b.20.1785254019295; Tue, 28 Jul 2026
 08:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org> <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com> <CAO9r8zNq3bRN+mumA5tcdizStpgoqTc++FYuGjvL8spbv4Q8YQ@mail.gmail.com>
 <CAKEwX=MG0F1+my1krUiOrHCn-Lypq2gq-g8Rv07Mz7sC=YEKaw@mail.gmail.com>
 <CAO9r8zOH93mfdjHq+Ljm7X+ykZS_rjzAvp9OBCzo+uyTbM1fDQ@mail.gmail.com>
 <amO-hwo8OGV5Goz0@cmpxchg.org> <CAO9r8zMgVmgQET+PUGexAgNqCZavA2YoTTXKSbWWoUv=A=ytSQ@mail.gmail.com>
 <f60fe501-7605-64dd-0572-77f7f3060f35@gmail.com> <CAO9r8zMBWA7nxM24VXQT00CVEZwFpMFNe73FFdPSZw2y=J-0HA@mail.gmail.com>
 <7bf9384b-2999-f14e-f23c-0df93168c20b@gmail.com> <CAKEwX=MObv_nCfRUTwa1HDxZEdoYLWgkp2K1s7+P+REB+v41RQ@mail.gmail.com>
In-Reply-To: <CAKEwX=MObv_nCfRUTwa1HDxZEdoYLWgkp2K1s7+P+REB+v41RQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 28 Jul 2026 08:53:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPHpm5JUfqPTCUmfCrOEXQ0_pdRtnjyeprHTQs1v42JPg@mail.gmail.com>
X-Gm-Features: AUfX_mzrHy756kSPKSZdq7uRWifdFcXmJv-8lTaL4BDwb7PDfFzhTlAXBZozxjw
Message-ID: <CAO9r8zPHpm5JUfqPTCUmfCrOEXQ0_pdRtnjyeprHTQs1v42JPg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	akpm@linux-foundation.org, tj@kernel.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A729100007
X-Stat-Signature: 7qmh3bw4msrykedbkmg1c6imsjeqihc5
X-Rspam-User: 
X-HE-Tag: 1785254021-897757
X-HE-Meta: U2FsdGVkX19lFxASr/pJUQd+JLf7zXJcUEI3h0msPtFmDgbdoYvthAJNTJDk2plE6gNt6wd1DNEtKior3+2+2BQ7cPz8wnnkxLKopaR73wPI5kUAJpB8jrIxhvHpzAL5x7pf0g3cqS3VaEG/s8dDDWQAkdacc/nMGoXZ5Go5acPTbTAVMpGXMT2c6PCMawJwV6Nm6lFAAnk+fYWRi98u2tjkyu4Uq9AIkWjz6Ye5lCdOewceJKFICM/WqaewBAUyeIwK0a1nBqcurILxFyrctDeAn0Cv91hD4NK/OAP9yHh3yteEy92q+dsoRp6Wclkwihb7roQ75uXbVWXU/Iq1kz8sV86WdlcgvGJQ4emBYqLHVwUTqv+2OV/GqsFtOf509+mviqwUy28QfOBLpmROKjvH/7kCJ4StS1oxzEUl+7hMeGH864JLPRliFdtXF1OKAJxdlZOCtEXtN9W2qhalyfqJ9EnLlNxniyeWme3bAJDTWRd7axF0eCf0a17KU829s+CHJY45fxY38qIzhYc4HdxKCNC3pbMsZCBxjv45KbilLvZoSwBxEQ4DU4f81eMDmdN3hXKA4bXD9mhI2z9TBzPb5KsgNUoH1WUL2GOF9/x24UITFXlzlC3zQp+6v1hV2MkIkBRfZMhGJyI7dfl0B+ckNNmRJDzGpblxna3wS7MXDNYJYJQa22LSxN+j8LQ8AEsQ0nQvyoSCJI5m83SUIDTde8cRAlvcxFmnvc2sKzVyZhVBI80EBOQiJUZCvFeFZ3EZuATkW9iq4t/BWVWm9CWJzMbu12QHcDcME9gxkeaQ7KQhZwRjEXwp/p24S+kmCORBpd9pKAKe6AV+xLaaWHOhI57b0DeDLfSgCYx9S9cCTrrCMUm/UD4PFOGdiwNV7e1ZpP/ZP6moGhoDRI3feKc5nGYeu+mbDjNC1ar1tKMhAw4Dq5Z6J46oIXKXJTpChON/rmZUMTNCR2mc8eu
 DRHDYGyu
 7sNTmejE4rgSLVJV920iAkGpCeQzG8uihLMHWsPvnY1pJ13m6moFuJcbEvtg9/nZDUQBgo1GWaRTzEusMU1VcE6Ms97PFMcDY85ZhFUdP6bwkNJAkIBQZhbFWR2vvBuINPVrFtB5p//2DGJ0oBYtbi1LJWYOZHjEMOzaRILwhai4JiXaBMV+IfjbfvobvPAD/FuRvAxeoKpvZ5q6qqkO8qlGyPxXU/km9wzIJ/O8NzqvjZJ5U1FWxHUxqcbYV5b+AjKXE3dVN4j99IHaY8vr3fOVLbJh3CFJjBw1C8ZZ+rHT48kCRB3c7uwuX5jxSsHEur+cEDNlQWADs7kr6VxtfeZkuFmDGDEa1LDwLx1Wbnd5NJrG/BL3wO/5R8Voj7w+wEqXhjF5HMRpDmSjsWg3R84mNLeItRVGEh+6mMTrUXzCp6HHqWv0zUdjyGuAPvuGwJVwWubohmSUUvn4nzRde7GIL+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 8:52=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jul 28, 2026 at 4:22=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com>=
 wrote:
> >
> >
> > On 2026/7/28 00:18, Yosry Ahmed wrote:
> > Apologies=E2=80=94there was a flaw in my previous test setup. I had con=
figured
> > zswap.max=3D320M alongside max_pool_percent=3D1. Since the global zswap=
 pool
> > capacity was roughly 314M (< 320M), the global pool limit was actually
> > being hit before the cgroup zswap.max limit. Both limits were likely
> > interleaving throughout the run, making the results difficult to analyz=
e.

Thanks for running the numbers again, these do look better!

> >
> > Re-running with **zswap.max=3D280M** yields results that align with
> > expectations:
> >
> > Test Case: zmax280 stress-4 pool1%
> >                              baseline        batch-all32      batch-all=
64
> >    shrink_worker wakeups            0                0                0
> >    shrink_memcg calls         698,990           57,187           29,649
> >    written_back               655,570          865,131          883,508
> >    store succeeded          1,054,928        1,124,990        1,190,608
> >    store rejected             229,722           22,642           11,659
> >    store reject rate             ~17%              ~1%              ~0%
> >    reject_reclaim_fail            110           15,454           12,985
> >    pswpout                    885,437          888,027          895,478
> >    pswpin                   2,035,415        1,305,341        1,384,751
> >    zswpout                  1,054,928        1,124,990        1,190,608
> >    zswpin                     280,675          162,684          158,556
> >
> > To isolate the cgroup zswap limit, I also tested with
> > max_pool_percent=3D50 (which should behave similarly to the zswap.max=
=3D280M
> > case above, bounded strictly by cgroup zswap.max):
> >
> > Test Case: zmax320 stress-4 pool50%
> >                             baseline        batch-all32      batch-all6=
4
> >    shrink_worker wakeups            0                0                0
> >    shrink_memcg calls         687,608           54,002           28,116
> >    written_back               639,176          846,663          862,347
> >    store succeeded            992,816        1,208,123        1,213,286
> >    store rejected             231,431           20,425           10,915
> >    store reject rate             ~18%              ~1%              ~0%
> >    pswpout                    870,745          867,360          873,553
> >    pswpin                   1,707,823        1,216,814        1,378,381
> >    zswpout                    992,816        1,208,123        1,213,286
> >    zswpin                     250,220          210,791          185,716
> >
> >
> > Finally, here is the dataset for zswap.max=3D320M and max_pool_percent=
=3D1
> > with a single stress-ng worker (stress-1), which also looks consistent
> > with your expectations:
> >
> > Test Case: zmax320 stress-1 pool1%
> >                            baseline        batch-all32      batch-all64
> >    shrink_worker wakeups        9,279              980              557
> >    shrink_memcg calls      14,247,647        2,638,751        1,465,915
> >    written_back                 7,702          439,809          482,809
> >    store succeeded            329,603          531,224          566,150
> >    store rejected             883,945          517,578          482,644
> >    store reject rate             ~73%             ~49%             ~46%
> >    pswpout                    891,647          957,388          965,453
> >    pswpin                     692,255          628,246          582,781
> >    zswpout                    329,603          531,224          566,150
> >    zswpin                     248,871                3            7,872
>
> Shall we just go with SWAP_CLUSTER_MAX per Johannes' suggestion then?
> 32 works the best here FWIW, but seems like it's all relatively good
> (as long as it's not 1).

Yeah I think so, the less magic macros the better.

>
> (I wonder if this works well with your proactive reclaimer too but we
> shall see).

