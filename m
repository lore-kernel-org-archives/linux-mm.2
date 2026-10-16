Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F59CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 11:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C756B0088; Fri, 16 Oct 2026 07:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3A26B008A; Fri, 16 Oct 2026 07:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA936B008C; Fri, 16 Oct 2026 07:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16C6E6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:44:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E1E640412
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:44:00 +0000 (UTC)
X-FDA: 85328305440.17.BC54314
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88CE4A000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:43:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=npTVVLAk;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792151038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NKuM+jtVFLfZVcVKg6kbrg0atkxIvcUrEpQMeeRVJXQ=;
	b=TWW3CbD8/Psz9IBZ5X92j9eVu0t8Rm15+uArVXkdZpmZTewA0ahbQspJVGNHPhcAt4j2ys
	/tvMJUBfLMjVTGN68bVNQcKR+sNIPv7gCXSwltvKyf31JZJllFQi4zodnaO4J2cF6nTjM/
	oYaqBxswIPmOYlHOwrlv2EMyNuoQStA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792151038;
	b=zp6r7CD4xuKFFIJx02jQy15rYVlhKdP08ONthsGK29STsMKLnyvZJ8jYkw7XHygHIJ3lXY
	/lsQTHFNdR2c5358j/vcyKEd34TwoTss5H9qaFfWtC5x82kkF55tVxxkDszmzJvnlqrq2N
	u9uvV1vd721xHL4uT3LV3w7tarxYU6c=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=npTVVLAk;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c40e02b2ebaso64555066b.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:43:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792151037; cv=none;
        d=google.com; s=arc-20260327;
        b=jZxngIqUvEFaMVDtT2ajFz3BiNkUeX/4zeHhDKw1z/+CTf7FQmwpAR2X4E5gTkiQqE
         pFjiXurGV+Tp3GIWyJoTSRFN4BLqP1AXgd3CEYBtcSUaHRgRSwkarDwlImimNNwu1Q0w
         OFqjm+f4rhovDbEbwdFf+FwbF/uvy7I6GALwDqgZ3hBIrNTMtYA6j3bURAI7kPjh1zvx
         6hY5v9KaYDCbma4QOV05DKmwAcffIHdRlOMxRsSBxBsVQiXDiU0HT6l5CsiqyRhCvWrL
         50BaALRN8tGUfRUzEboDpi9ZE4d8Y+epQji30gaMLqmSMtBC1D4fxeOQFvKp5o4NW3OS
         oMxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NKuM+jtVFLfZVcVKg6kbrg0atkxIvcUrEpQMeeRVJXQ=;
        fh=p5bYFpW+Nb/fGsUD/fJJZRYgSSAf2K4Yr8peHbQz72k=;
        b=CA6PvfvcbsejTMmYOfTtj8+46caVI0rOpUXpcjpKgR4UI0C5+ZDeihcVpTvwU3g5x/
         A/h7mMfHr+yWvMxiNvaQnn/JriP+KwdMwszV+WNLi1185olgo4qEDBKJOd5lPM/BIUAM
         dXiyhMQNhSlRGwdsJnfDhGfJ3nIhMBozj9RmDTsoj+tfBZzMdoED7Vq7z5p74o21dlzp
         z4qSlNtgHGaNBHyqYQ1Nk2Zz06LZH/7Igfi0huwY017DwN+767/n0JycHGWTAkgJ3xlZ
         tJ3xuaqRTKmtlywNB9FJgLzFT6Ki+oXu+Tw6Sc8QTJEJggQym1jXFp1FH5s1Iy8r5+08
         fKmg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792151037; x=1792755837; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NKuM+jtVFLfZVcVKg6kbrg0atkxIvcUrEpQMeeRVJXQ=;
        b=npTVVLAku8LwzvfJM8MtRiYNOAOa1IZ1AdyIiYUsedjDK9R9IyGuZqbCUfMz2qRWRs
         enhml3o2FOBydEZvSoJUJVDqWjsUEEaR62k3wgOU46Uzj9VjqY4vntQ7yv2Tz+2h99yA
         jKr8gzdxdpmT8WHHLMa7WxP3mGVd1TlI7FCHbA0yrFwLEJlse05tFAwQYEYHPAxRhmB1
         pLlBKmBDN/ZD0Np30OySLKkoPgK59s/PAliKJnHsseaYNZT7c9fzh1qgKnw+3ZK+M/Ie
         4DiaTZmJFUZ/FV46gNXao3PldrCAYFoAPrba8qEae1KM6yFKWLuz8OFSCnzDWgezk9xY
         Ewig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792151037; x=1792755837;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NKuM+jtVFLfZVcVKg6kbrg0atkxIvcUrEpQMeeRVJXQ=;
        b=Zv1NILTQJA/0l0mw20wMomRtDG+guRLK+iFWZfOXRy4ov49Db++p335tOL5zZksoyu
         UAt0Im6SOt8DK+fl/JTAV5FqpHhVwWQJsvQESvQATNLAtF3kh2Ghi5aITqUun+Gdo7LJ
         AX7PZH96ohDSX0AaOj3uwNd3reBtt3yocWddaL5x7HaYdME+AMsHSZ7FftBJ6ZipkYoZ
         qFjxIQXWUM7dLh2cxKQ3kmCh2ERtILhElJJwBQCQSBpWrgXAY2i33lVRtNflqHi81HI4
         iSkH6yWoEctc3PtvQmvYiNepLZyBbCXdzIcMzJJq8a/m80hWzRQ6h3JhDb+Cha3iFaDR
         LcRw==
X-Forwarded-Encrypted: i=1; AKwUvBzo7R2vbiTFR+ZiWZQCAgTHxpmuUrk9HD1j0LhE486ZO8AL9CPAewCxqqJPG+pLpQkvNkVPOaNl8Q==@kvack.org
X-Gm-Message-State: AFq9FYLNaSvniGDqlaqWkUmHSwD0D0PYIKs54Uayko+LnvN/qkxEoM6X
	Z9uz96sug2qqfD8ftOaexFD7X8yK8njewMk8jAlA+6yaYVTn6Lzp31Xv3+rvKgkCPqeOPG7etYD
	ay/CqOHLl8aJKq7i24eRNDt/8Lt0RwRE=
X-Gm-Gg: AYBFou1nMUSm//YZKAOKVl6pL6jIDD2mImrXvNX19DSGXXBLU7EWQaBGmXT0FhMqT7m
	QLLjqiYMFDWrnWyzoGlRA+M/R+P7IV6ND1knOmTb6B3nRUWLaupp/ARsnrwuvTMC0+WhFlBC1Iw
	GWf3rXw7v0u4l4yO0gtOox/iP2BKwUylMQ3iih7CQizWP8VPFXvZELZP1NzDR54Gki+akXwlB6X
	1bJCvXjKQvAW95dHAe0MKHpHfyW/MfIz8/cdZKREIUvHRG6b5RUrqxIPMU1vSDFRPWsjigw/Nt7
	+TuY+Bv75JByG1TeL2+Qo3SWfRujmkQfspd4nbDVru4X5vTyxF0r1GpnhcXEV4+cAj7QObUJ1+K
	sbIpgF+GcJDfB
X-Received: by 2002:a17:906:4790:b0:c25:5faf:b207 with SMTP id
 a640c23a62f3a-c31a9a10e7fmr2051644866b.3.1792151036607; Fri, 16 Oct 2026
 04:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com> <20261016084256.12955-1-baohua@kernel.org>
In-Reply-To: <20261016084256.12955-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 19:43:19 +0800
X-Gm-Features: AclHuK_vD7Q6cJy-PpEfQtWOtckePrdQvkfJvtJJCDIcYrRZMuAvFqbDO7Y_PeA
Message-ID: <CAMgjq7AtuK22FsuqvGRLVZ2eWrp-N4qQ_MHoXsXDkVBprekdDA@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: devnull+kasong.tencent.com@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, chenridong@xiaomi.com, chrisl@kernel.org, 
	damon@lists.linux.dev, david@kernel.org, dev.jain@arm.com, 
	ehab.ababneh@intel.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, kunwu.chan@gmail.com, lance.yang@linux.dev, 
	liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liuxiang.277@bytedance.com, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nico.pache@linux.dev, 
	nphamcs@gmail.com, qi.zheng@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, sj@kernel.org, surenb@google.com, 
	tz2294@columbia.edu, usama.arif@linux.dev, vbabka@kernel.org, 
	vernon2gm@gmail.com, wangzicheng@honor.com, weixugc@google.com, 
	willy@infradead.org, ying.huang@linux.alibaba.com, youngjun.park@lge.com, 
	yuanchu@google.com, yuzhao@google.com, zhaozhengzhuo@uniontech.com, 
	ziy@nvidia.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 88CE4A000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: y9x3tathrbwrjsqbz96eypee79egmwb4
X-HE-Tag: 1792151038-872884
X-HE-Meta: U2FsdGVkX18I7PUQrN4yXKYansLEFzsaxkWIYr3ZvLs+/hcf/I8wdidTohSt2aUl3wsXCjTcqd6eqV8cz57JVWPoVGy8uBx6FGfJ5938NcJfRl0kWKNGVn1lejpAQHRBBUoZzUYRA5P1f+pCpDEnfgC4ZQ1QxWxRTchp0g1ci3K3KNATF5mVg1wuyLxJ/RMiOxluwaYKmvrNLdBG5+VGum/Enufv/JW0DkCXO9wGqkMAlqyF81f28sqGQMD41pPODO0yTxf/sQQK5CX09c6VljqSfmHTHammvum22DYUO2rsqPXu/5zbyeunt4dswLnxam7/WMmdXiPfqmrin1l9AXNBadE5hPRrGYtMjt4IrRWSe0FfTxfjcHN/LUmkUm6sPQ9fvRNbKSOTkO1A1jcwXUzD1PzmTfB4BzGP/RQgSQoHTnwpbomn7s0b1q069Qh5e37CDtLr0tGYPsCcTmmj4Gdpq4DrSxc7xWML3M+NbtfmDoXAhNuK5iEmCVxW6O9ttlTwMYnIS85woPjAmEeQNQbkeTTqyJtHxUZzIAcSeeuubb28k1xxNRIezGxUyMPkQ2o5ztiithpgZgTbSnLG3VingCOl4NvG1457+LWpwook/gxOVpQFjeyifHox228xBnGvNzJvbxRmb5z5gX9C+lOk+JUiMA1oR6SIz7801VGAhnS6XQkq/kK7yBjY0gL2S+Pbw8duzUd76HKBSoAVL8IYmqnQtHwIF8YQNywo6i5ieIXsOoulKdU1C0/bxsBc9vg0bfGGgLJhp3MqQMzX27WE/4Nsgdn7EQ/tLYe0qK6stDVPUoy37C4/+8sK82nAw9el/1Z8rrP36XQX3+B6WlZ8Bb4L9Vske/KRfkOWCSEweFjjMevWeoq5Ufw1ZIL02tUcBl1pqZGHTZ3KEdop4sCTsc2UcofBcaDsfHAymxhNGTnuKqpSwU38w29wu2cG+GXZ2lJ2uvZ6SEKkhxd
 MSKYZY5q
 8IGi0EnrFHWSUzwPyU8OfWh6oLZFf3aq3jiw0fs0AUj/iWpbWwH9DrAUClmyplh2TVgFvWVLIUmfoLGa1Wz48/fsAsFaS8ePPu3f2APIGOceBwtRrFVkVmP/pkztmr04xAG/5oGlfR4G3ehX+fvGtjuCgjnT6ep2f5uQ8FITHu/FmRHp6abMzo4teQEn1Rj0mPZtmUX8za6pLnuuu+NbIG1GL2gDfs8a83z3IIIm+4jbhanPnpeLrFz/q0+4CS9hmz+35M/uTDv1krTXsCP5eci4v/L5FQLeARSCbliWtENLfUauANXoL7tAAvJyVrPRB3W/kqzNaKA/+vDIqs6QXP4HccnamAU9p/7oYHoGpKvFOJslw/EyNHZMa7VymZl3OBnq59MHLGBw8o+Wn5ULOZmdZcQB0f98zQYmbp7ACQHuC3zYBv3zwZxYnBVzs2o0K0SP502M72+ACCkgTJktGxnaB1O5BN/llks3d1UivBe30s1gxn88zJJgIdqaHcMhyXEt0TsVfrAeNySJjm/DJ+os7mRZvg/gSd7KujOm/rE7dfXW4Cy1wqRPZI/Z9nqEw5jJnXwXP8oLLwV/BVgg1Ds8hd36fbBrJuzs2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 4:43=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay <devnull=
+kasong.tencent.com@kernel.org> wrote:
> [...]
> >
> > LevelDB Scan/Get
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > I also retested the LevelDB benchmark from the cache_ext paper [5].
> > Interestingly, mainline MGLRU already beats CLRU on this one after a
> > recent change in lru_gen_folio_seq that bumps new folios with refs =3D=
=3D 1
> > to the second-oldest generation as discussed. That change accidentally
> > gave random reads a higher hotness level while making sequential reads
> > much colder as described before [14]. However it's unreliable and
> > incorrect because it depends on LRU drain timing, and hurts some worklo=
ads
> > as reported, or where the sequential part is actually hotter (any workl=
oad
> > involving hotter large file and many small cold files will be affected)
> > which is reproduced below.
> >
> > This series improves it while covering ordinary workloads too and shoul=
d
> > fix regressions:
> >
> > LevelDB Scan / Get, Throughput Total:
> > CLRU:         4708.3 ops/s
> > MGLRU:        5026.9 ops/s (faster than CLRU, but hurts other workloads=
)
> > MGLRU After:  5179.2 ops/s (even better in all cases, and no regression=
)
> >
> > The hot-sequential and cold-random workload can be easily reproduced wi=
th
> > SQLite and grep. SQLite continuously scans and looks up a small hot
> > portion of a DB file, while grep iterates over a set of small files muc=
h
> > larger than RAM [6]:
> >
> >          SQLite scan & lookup time:       Grep iterate time:
> > CLRU:                       14.51ms               13281.37ms
> > MGLRU mainline:            567.05ms               13694.47ms
> > MGLRU After this series:    10.58ms               12930.43ms
> >
>
> Thanks, Kairui. I'll do a thorough review of the whole patchset over
> the next two weeks.
>
> BTW, do you think we need a quick fix patch like the one below
> for the above problem before this patchset, so that it can be
> backported to stable? I assume your patchset is too large to
> backport?

Hi Barry,

Good question, I think we can patch it first.

> From f9683205d2ab6e3b185022d7d5af3496dfe5f35f Mon Sep 17 00:00:00 2001
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Date: Fri, 16 Oct 2026 11:48:06 +0800
> Subject: [PATCH] mm/mglru: fix using folio_mark_accessed to replace
>  folio_set_active
>
> Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
> replace folio_set_active") tried to avoid over-protecting
> fault-around read-ahead file folios by placing them in the
> second-oldest generation instead of the youngest generations.
>
> However, it abuses `PG_referenced` on read-ahead file folios
> for this purpose, potentially coupling their handling with
> normal syscall-based file accesses that also use
> `PG_referenced`.
>
> This could regress some workloads, as reported by Kairui Song[1]
> and Ehab Ababneh[2]. Many thanks to both for reporting these
> issues!
>
> The long-term fix is Kairui's MGLRU-FG, but in the meantime,
> we also need a quick fix that can be backported to stable.
>
> This patch reverts all of the original commit's behavior that
> abuses `PG_referenced`, while preserving the semantics of
> avoiding over-protection of fault-around read-ahead file
> folios by adjusting only `lru_gen_folio_seq()`.
> Specifically, fault-around read-ahead file folios with
> `PG_active` set but `PG_workingset` clear are placed in the
> second-oldest generation.
> Activated file folios and refaulted workingset file folios
> are still placed in the youngest generations.
>
> Build kernel cases in a memcg shows it not only perserve
> the benefit of original patch, but also even improve
> performance further.
>
> w/o fix:
>
> real    1m49.094s
> user    25m31.484s
> sys     3m40.959s
> pswpin: 662112
> pswpout: 2504415
> pgpgin: 4424336
> pgpgout: 10355273
> refault_file: 359626
> refault_anon: 670724
>
> w/ fix:
>
> real    1m48.913s
> user    25m31.639s
> sys     3m30.875s
> pswpin: 689815
> pswpout: 2689894
> pgpgin: 4422659
> pgpgout: 11043464
> refault_file: 326566
> refault_anon: 697138
>
> Revert original patch:
>
> real    1m50.044s
> user    25m37.137s
> sys     4m4.493s
> pswpin: 1349087
> pswpout: 4317933
> pgpgin: 7083597
> pgpgout: 17602735
> refault_file: 337676
> refault_anon: 1368542
>
> [1] https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-0-cbd4546a5bd9@=
tencent.com/
> [2] https://lore.kernel.org/linux-mm/20260901180704.168106-1-ehab.ababneh=
@intel.com/
> Fixes: 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace folio_=
set_active")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  include/linux/mm_inline.h |  8 +++++---
>  mm/folio.c                | 16 +++-------------
>  mm/vmscan.c               |  9 ++-------
>  mm/workingset.c           | 10 ++++------
>  4 files changed, 14 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index ab69b9930893..7aaff4e06e80 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -311,7 +311,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>          * | Accessed through page tables and  | Accessed through file de=
scriptors |
>          * | promoted by folio_update_gen()    | and protected by folio_i=
nc_gen()  |
>          * +-----------------------------------+-------------------------=
----------+
> -        * | PG_active (set while isolated)    |                         =
          |
> +        * | PG_active (set while isolated)    | PG_active (files|       =
          |
> +        * |                                   | fault-readahead)|       =
          |

This comment is not correct I think, faulting file folios are not
access through fd, we may just better leave it uncommented.

>          * +-----------------+-----------------+-----------------+-------=
----------+
>          * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_R=
EFS_FLAGS |
>          * +-----------------------------------+-------------------------=
----------+
> @@ -319,7 +320,8 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>          * |<---------------------------- MAX_NR_GENS -------------------=
--------->|
>          */
>         if (folio_test_active(folio))
> -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> +               gen =3D MIN_NR_GENS - folio_test_workingset(folio) +
> +                     (type ? !folio_test_workingset(folio) : 0);

This looks a bit hard to follow. Does it mean that for active but
non-workingset files, they are put into the third newest generation?
It creates more divergence of file / anon but if it work for now, I'm
fine with it.

>         else if (reclaiming)
>                 gen =3D MAX_NR_GENS;
>         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(foli=
o)) ||
> @@ -327,7 +329,7 @@ static inline unsigned long lru_gen_folio_seq(const s=
truct lruvec *lruvec,
>                   (folio_test_dirty(folio) || folio_test_writeback(folio)=
)))
>                 gen =3D MIN_NR_GENS;
>         else
> -               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) || fo=
lio_test_referenced(folio));
> +               gen =3D MAX_NR_GENS - folio_test_workingset(folio);

This is a nice change, but meanwhile the LevelDB and cerain workload
gain are gone too, we will again have a ~40% regression for similiar
workloads, I just double checked it. But that's fine, though, it was
never meant to be optimized that way, and the long-term fix can be
done later.

A quick test on another of my test machine using Tal's LevelDB test case:

CLRU: 3098 ops/s
MGLRU mainline: 3035 ops/s
MGLRU-FG: 3233 ops/s
MGLRU with this patch: 2194 ops/sec (should be same result with
reverting 6cbdd9726fb5)

>
>         return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
>  }
> diff --git a/mm/folio.c b/mm/folio.c
> index 35e242b48870..2af724cecb31 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -474,20 +474,10 @@ void folio_add_lru(struct folio *folio)
>                         folio_test_unevictable(folio), folio);
>         VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>
> -       /*
> -        * For refaulted workingset folios, set PG_active so they
> -        * can be added to active generations.
> -        * For prefaulted file folios, folio_mark_accessed() sets
> -        * PG_referenced so lru_gen_folio_seq() places them into
> -        * the second oldest generation.
> -        */
> +       /* see the comment in lru_gen_folio_seq() */
>         if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
> -           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
> -               if (folio_test_workingset(folio))
> -                       folio_set_active(folio);
> -               else if (!folio_test_referenced(folio))
> -                       folio_mark_accessed(folio);
> -       }
> +           lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> +               folio_set_active(folio);
>
>         folio_batch_add_and_move(folio, lru_add);
>  }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index daa7e37c2236..e82ba737c028 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -952,13 +952,8 @@ static bool lru_gen_set_refs(struct folio *folio, co=
nst vma_flags_t *vma_flags)
>                 return false;
>         }
>
> -       /* Promote on second access */
> -       if (folio_lru_refs(folio) > 1) {
> -               folio_set_workingset(folio);
> -               folio_set_lru_refs(folio, 0);
> -       } else {
> -               folio_mark_accessed(folio);
> -       }
> +       folio_set_workingset(folio);
> +       folio_set_lru_refs(folio, 0);
>         return true;
>  }
>  #else
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 1504f91cdca5..10d4ce202cca 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -319,13 +319,11 @@ static void lru_gen_refault(struct folio *folio, vo=
id *shadow)
>
>         atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
>
> +       /* see folio_add_lru() where folio_set_active() will be called */
> +       if (lru_gen_in_fault())
> +               mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type,=
 delta);
> +
>         if (workingset) {
> -               /*
> -                * see folio_add_lru(), where folio_set_active() is
> -                * called for workingset folios
> -                */
> -               if (lru_gen_in_fault())
> -                       mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE=
 + type, delta);
>                 folio_set_workingset(folio);
>                 mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, =
delta);
>         } else
> --
> 2.34.1
>

The rest most looks clean to me.

