Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E25760A3822
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kfbWYC5e
Received: by kanga.kvack.org (Postfix)
	id 92FA96B05B2; Thu,  5 Nov 2026 15:07:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907876B05B3; Thu,  5 Nov 2026 15:07:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CB26B05B4; Thu,  5 Nov 2026 15:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5006B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:07:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6F41140BF8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:07:28 +0000 (UTC)
X-FDA: 85402150176.10.25872D4
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id D9CBA40006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:07:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kfbWYC5e;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793909247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
	b=k2bqpmjGTK67m8kNTEitxTNNw3JeX9hssrSUN1JG+7/+z3cZnaG0fSOhefYF3+ZSyZbhrF
	Au3u6HrFj1eykNB/za7vmIp8vVK5yPWM7oR65YP0d9+EFyhB6nsh6XrU95lZtWvaMXl8YK
	LEM3beuz3jXxH+IAx/WiGLjSLilMMNg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793909247;
	b=TvRMDiFc5GIQg6gbeLXRHt8/rWOAG0pnASWBz0xU4ovRoLQoLYrsjFlwX2F0+QdoHRL5xp
	YFkrDT8DJGn8Em3+U2l+lbmsLBPm7C1qilejzPvx11jLW2ZfWDCXCbzKM9/7zj3S/ssZzv
	V5z9DSToCEbW9tM9CActSAsQGWBVJmU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kfbWYC5e;
	spf=pass (imf12.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48afbd2c386so1604889f8f.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 12:07:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793909245; cv=none;
        d=google.com; s=arc-20260327;
        b=gbdLKSz3SYT/JsYLkOHloMJux7hCjDgCq+sSm9FuVG8OeKHFOk9h2/3L3IgadNUQQ9
         AUHY5dxTO9JJJxlJ1XbHI5mYx2bTa9SFSSdBVthi+HfGvuOW2Vki7O8g+CZUxYAae2yB
         c9M0NcitUxI97qPw35I0cx6sk86Vc0NU6qLpX3LKJQscRiKT8snBxd1hWRN3944Yv4ha
         GwDmFCwG0Qthq7FoHd6fJwhsaPqKqLwuIQyoVI8Z6D04NN7+28hkW0k9oUNuBT+TIGVN
         KWolrQdTxk/nQoium9kbDqJEzowE1FcdAk3GVN3LoKfh2bEntEGJ9VFMZ8NrSnAWJMC5
         TI+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
        fh=y3KVZ3FyDqmdXDYU7D2wr52Zj9wccMQDTlsEJmK0KY8=;
        b=blJ/Y/fmf6RGn31RkW6VgEIej0FRwSdd12i3/EspmkNhH+8QP0+ed8cWbgy2/pYXAg
         CQOBpmclPzGsvlHdgddOcTlplOl/ttb0Ns3W5k0PLrjvD/mU85c9+k7jwX6O5W/GLiAQ
         XsFdZvitXqAH2EkKvPZas6zhVdhEfHvFowlygV+JcG/lUgCASdFRA0KTw1KB8JiOvwNo
         JRQNJxxLBqRQRdZaBx30AVqDmramln4k5cHb+kl0PKi0Sgbo3eY5KiK1zmqwJY14RvSc
         tkQxTIcC2rBwGNxEpcMPR3ioKX5tXcjU9ota4NXCQ6LvRFeDNOg+NQHU68aMOnz9pgOk
         O9FA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793909245; x=1794514045; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
        b=kfbWYC5em9Vn1ZM+xEcCd4myk3GZbLQzPduyfupyUeOpNSVBT986fnjXG9ENHqnKc9
         As7lXyxxegqnrdYFkZS/Q7DrYnjykvhBAa899YnfzU2DdH0PlAlg8Ba7chuxnj9VHAEf
         pLCYlr+SxHcw3PtluOz5EyHSQ3wQA+4EHNKYsq83N8eC0LBnUnItOrC5tV77mSE4gVkJ
         ITBG+0ArCc/QMSkJwTAKeR64i2O4NLhfSjQ+7dSeKHyFjx8EejSZWQvNbHV+zVXVeYxk
         xQaURdPzC+hZww+5VFTVEJUK1UsGU/XJx1uuKjARacZ9bQm1A3LMvSjXpXMNXPUCwYFu
         gTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793909245; x=1794514045;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5FFU0lXt9gPsOFHwEdIEfTqWQmdPAxfxsOegzXYLoHk=;
        b=zJAl78URPbD7TeZv+EMBwR5jVnQyjQJKhqVXnyDe8/k6Fi6xepWJRtwCswyXQ00SFx
         DFvjoDd/QOdZDFGjqWaF1oQgUhS5kcLBA8WQBTWyeHeGYGZH8xdQrRxmf3aFc22JwIFX
         eHu7rcavA+aF9OHS2SzULap/0wbivZTZeajrT1sXUB1x5tcgEb1onDsBZ69mr+GeVMb5
         ZFxpHXd7zDpr/xsMvg2+tKZNBERW3TSAHCFY7A07DO2YV9b4C7qCef/R/5eBkx/6dpiC
         KIfxLz+lljEAWcM3dVUcHZCTNxKYBsmYxVoxcFBY8BkgEMkoTjUEzQjAopLO9X/jM9+N
         71Jw==
X-Forwarded-Encrypted: i=1; AKwUvBwbFcxULaCjwM4RtT/vnE0GdaNzSRvoB0n0oW6KvbR69HNle8gJG2NIMDlN+ybPSkd8YJ7Wyul4gQ==@kvack.org
X-Gm-Message-State: APuU4Z8qaQhJJCOdvdkZtH3aUvatp5opWnVHPN7441ahTMHnoR48wp4i
	iZeMEtKudP2+5uzYx4121DtBhipCUxgW4UbVcYRXJ69b/LhT05aTOani4sRctW/k4zcAkdTYZrq
	SMrqcWptH9SHTI1vgus77LM9EcSA68rA=
X-Gm-Gg: AYBFou0ccUV6S/0UO1GG0dKwCplZVNFddxdWGck7tKLF7yTvTgNuM7XF9l1UsMOv4Pj
	EkU+YW5Dkel4IY5K5jHcw9mfvljBeAG2gsZ6lGCpw3qEBCph2LnfXXV+2svonBCK6Srg52Yl8my
	UyOGiUjmzkFg0MfsgZMNOx/NPfR3M1e+hnbYyajHzPqfmWJ5ddLAvqHa1o5sYRBk7uLkWN+glrQ
	VoDIrfkE/xqTA7nlU+zPi7wdIS72prtdmnk4DSxKpGWzmKuxFFf0Vrr3RR9qMlj0bCSXCwSc2le
	kBjL/7nPf+MVzS7ygDMkcr4xbal7soU0Qpi4SA4Ws5YJ2WUaDqaPO6Jb78anUs9vj1T93AhvtWH
	5U01mqc25qgdz2NXE8TmEokyzpjuPVljFqXGMTFrxZABwibrDj6BTQ5BHNKcP0SgqeyL6fRA9Sc
	oT0Yufdj+X2HDwFHSpLg==
X-Received: by 2002:a5d:6f0f:0:b0:48d:ecba:3cf8 with SMTP id
 ffacd0b85a97d-49277e91e8dmr1303438f8f.43.1793909245094; Thu, 05 Nov 2026
 12:07:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029204157.117879-1-joannelkoong@gmail.com>
 <auPhT70GU-Zqe9Qy@linux.dev> <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
 <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
In-Reply-To: <CAJnrk1ZF7FminyCYORxysXW0zA=fuUtBe5YXkabsSTOmXt_vdA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 5 Nov 2026 12:07:13 -0800
X-Gm-Features: AclHuK-YXRVVfKGyxrAmqyLZlV1c129Tk-TiSLsOR0T2GgkWlVaz7555ZN3P6b8
Message-ID: <CAJnrk1acAiHB06DKAJhuSZBNHn0dkRYJ5RU54sSz+xGXhwwnwA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, yosry@kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: db3n54fxwa3epubsetqg7gyszrdo7jjw
X-Rspamd-Queue-Id: D9CBA40006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793909246-751948
X-HE-Meta: U2FsdGVkX1/VHh9pp+F6nocLiBsygohj13yOsIaqdbdX8buD/hvS6KvA0aRvuaiz3y6nuT+nXaKhrDq0rdz1TZOMqGMREynOBR9PXdxDh5pBTYHtdx9knni9MCrLtCRMgFaNag/uDX+uJoAa03jbcHQkMZXcFaecQ+wpB0qf86ZdY7Lht22YgTznzfAAl8djfsaJau+eny0if9q9W0y35Wam1s5p2SAKh4amV8tVqPCSqUHFjE0tdfaPrOqUv2AaxpZO6EIsQ0pcVdq+NLH0i+n1YnyMif6HsasDCGCltcaGuPM0Sk68cXA9xyAZwmDvtd2cLmJviObgnFjef/i4KB5jzG0aW1MRYh1BUCBDXplkOOhGoy/iRXz5GkV12QjQLkBgbdQ0IvaUMYNhRgaeS2bh2p3m+873VLsqZxdn+XTUSUCwkBkN61HdamHXHDefMtB7T5NY+Z/BrKcMtgCD7EHuq3LN+QhZABS66PvjGrQiFMldWb6Fbuz/SjqqAHWRd6HG3QOjGaAMl4txoNqW/wxsZl3aj8V5fF7uvVOyu4pWDofpu3McP6N6vYrpmuxRP5inkt7nwHWiL7sBPrxnrfJelwko0lu+Jqtv8fGP1w+NjNLyqrhZxuOY7Un30kir4EWEVnLQeRcx8WprsZj2x8nDMsbck9dJByMQvT/F3Hyh6WHGknZKUeKgwikI5Sqbw6oE0bPWWW81AhNWWEvznABzJjVPCbvIgk4KDZKv+AWJgRLGClYALa+yEtrCQ6aEQZlj5STAs0CpA1E5Gh80aJ7XPsz20lzm1lK4Ckr+wly00y75sIMBvNakxlHFm5zhbuQ+nVpy1iwb0Ydsq2MnVq/joSgkz4Qq3Hj07ZCKed3Blsi5Dp1urMXMQErW49Pr4th9+iIHc2oj6x/V+ZbR/vQuPSvmvT6+oLg2B4IjVTKe81P3Q5QPFJ1ScJ7Cb5eUc8nSc+kMy1jPhsH8KXE
 ldQI281D
 0oShSLjK6UjR+cehc5cHA9KMoFMgBi2Srw2HXRaBZJDIeSCLqUkw809SKIDMAn16KVeQSF+NbwpOohVZQstwl0enIFhigkuLNmnUwIjvMUJGtQc7IAypCyUIFv7G4NXUjPtCahXXN2wNqfMxVEnspqkIiFrjRNyIlkrL4s7lGX8amhGE5qqXHGruN2oQg5/uRsDHCenhPRTx+JdvjMq2v1NRW4D8VKF3gAcQ2sINteg7Ci2YqTVmdBJO+gVkcLKiCGml3ikZwfouosn6gwSFIAql4kc/4p/qsXYMaound/hXaTBtF8kLX43jIy0ratyTzluWRPIBUQX9+6RBZmCt8PQJUYEIoOy0rNvIYJ+iACgk6k/4h7YJmQePgcJefaEiHPnKLmR1otKD+F6gjp/LB6G8u84Q15DWv9i8nuRA2N9e/Gi2MhDMnUxdzygw3m/V9cfkY3A2yd9dtWDE6R1VqqGEVeA58qhjgaSNg4My6Z9XTX25n1f4f9jYfAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 11:53=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Thu, Nov 5, 2026 at 11:37=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/30/26 01:19, Shakeel Butt wrote:
> > > On Thu, Oct 29, 2026 at 01:41:57PM -0700, Joanne Koong wrote:
> > >> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_l=
ock
> > >> once per batch, but they update the node and memcg lruvec stats for
> > >> every folio in the batch while holding the lock. Only the LRU lists =
and
> > >> the memcg lru_zone_size need lru_lock. Updating the stats while hold=
ing
> > >> the lru_lock is unnecessary, and they make up a large part of the
> > >> critical section, as seen in [1] where a change that added just a fe=
w
> > >> instructions to the memcg stat update path cost about 2% throughput
> > >> because the LRU stat updates run under lru_lock, and the overhead we=
nt
> > >> away once they were moved outside of the lock.
> > >>
> > >> With many threads faulting and freeing memory in a single memcg, abo=
ut
> > >> half of all cycles are spent waiting for lru_lock, and the hold time=
 of
> > >> the lru_lock directly limits throughput. A perf profile with 80 thre=
ads
> > >> faulting in and freeing shmem in a single memcg shows 52.8% of all
> > >> cycles spent spinning on lru_lock, split evenly between
> > >> folio_batch_move_lru() and folios_put_refs(). About 25% of the time
> > >> spent holding lru_lock in those two paths goes to the LRU stat updat=
es,
> > >> mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and t=
he
> > >> per-cpu counters. The stat updates are only 0.7% of all cycles, but =
they
> > >> lengthen the critical section that the other threads are waiting on.
> > >>
> > >> Accumulate the stat changes per LRU list while holding the lock inst=
ead,
> > >> and only apply them after dropping the lock (while still inside
> > >> the RCU read section that keeps the lruvec's memcg alive). This move=
s
> > >> the stat updates out of the lru_lock critical section and turns the
> > >> per-folio updates into at most one update per LRU list per batch.
> > >
> > > This updating of stats after dropping the lru lock does introduce one=
 behavior
> > > change i.e. race between reparenting on offlining and stats update. I=
 think it
> > > is safe and correct though. Better to document it.
> > >
> > >>
> > >> The batch is attached to the lruvec while lru_lock is held so that t=
he
> > >> LRU add/del helpers don't need to pass it down. To keep struct lruve=
c
> > >> from growing, cost_lock is moved into the hole after lru_lock, which
> > >> leaves room for the batch pointer in the same cacheline as lru_lock.
> > >>
> > >> The stats can now lag behind the LRU lists by one batch, which is we=
ll
> > >> within the per-cpu batching they already have.
> > >>
> > >> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned t=
o
> > >> CPUs repeatedly faulting in and freeing memory in a single memcg,
> > >> average pages per second over 7 freshly created memcgs per run, 2 bo=
ots
> > >> each:
> > >>
> > >>                      before    after
> > >>   shmem, 20 threads  4.74M     5.47M   (+15%)
> > >>   shmem, 80 threads  7.94M    10.33M   (+30%)
> > >>   anon,  20 threads  3.04M     3.35M   (+10%)
> > >>   anon,  80 threads  3.23M     3.41M   (+5%)
> > >>
> > >> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_=
a76izMS=3DqGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
> > >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > >
> > > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > >
> >
> > Thanks, I'm planning on queue this.
> >
>
> I'll send out a v3 today that adds the documentation Shakeel suggested
> about the race between reparenting on offlining and stats update.
>

I'm seeing that the patch was picked up yesterday into mm-new. Could
you or Andrew add this paragraph to the commit message after the
"Accumulate the stats changes..." paragraph?:

"Applying the stats after dropping lru_lock means a batched update can
race with reparenting when the memcg is being offlined. This is ok
because updates to a dying memcg are redirected to its nearest
non-dying ancestor, which is where its folios end up after
reparenting."

Apologies for any inconveniences.

Thanks,
Joanne

