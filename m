Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB57E9A762
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01D406B0089; Tue, 24 Mar 2026 07:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10D56B008A; Tue, 24 Mar 2026 07:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF5A6B008C; Tue, 24 Mar 2026 07:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1C476B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:10:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7159CE0EED
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:10:39 +0000 (UTC)
X-FDA: 84580688598.14.732A895
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6973D12000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:10:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pqtq4lRv;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774350637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FYZhCGRri9obbGcLyqavMzNMu7EztYClpF7RkkjC8E=;
	b=ANzUDhfv/N6EQSG9wycRMdV5g4Mt6NlkcNgggbv+vXYiD5p5GhVdNE+mZ16CB9EgUk2lt/
	W4SfhGevi/SR2yRYLFhm5+iMecjgo9eVWChD5Em8NGL3Sfhq8XKSZJTHZMVYaaq6iCmbPY
	6qqFdbkZT8IDfjThRBJYfRX7/iMeoJo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Pqtq4lRv;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774350637; a=rsa-sha256;
	cv=pass;
	b=qsz4LNLR8pBJW793S3z6k4x1LfSd+v4QW8Yn24M+1B/u3qDBuSJC7ZXM2NpWzMmULKqayC
	4NZpCwTHGVu/ZNR/wnRPD22S8HOMBSyUdencuQFsmRXy2Pcxzf0zt9K/CeoEzujrTrvcDB
	ed8AGWV0VRYS/UKDhZQrcxWWONLADpw=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9358dd7f79so627728066b.1
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774350636; cv=none;
        d=google.com; s=arc-20240605;
        b=QyXYi0tI3hSc5EmqHxkz5OhP397xtcWnz1vTAghpaXq2hmgiJWGARjEVbklObihg/B
         VOJ7XWXRkavUm3xgwhR2Nzvh0RsGe1YmUshS1WiKjron7Qthuk4Ka4jxkhfkr5yp3t53
         PuAGUFfh5WkCKX7Pq3d4TglOyJvbhukJut/ogi2TDFdVdjwTULcrBTVCAsbzlIUbQLUj
         rxPOX+jeYaG18LC7ezLMGY9qvjoKZRBGByE9xcl0mhj/TD4s6S/QxJvT0Zb5L0fbbBNy
         hlBs1WtOL9G8kzbSRMEuo541AuBKcHmP/Q37E8ZQ3wNq2aM2I2j6rQRAfoBQ9hqtr+DT
         cd3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3FYZhCGRri9obbGcLyqavMzNMu7EztYClpF7RkkjC8E=;
        fh=GQQxm9mw5zpOVyA3t4CVNbi8itAKnQtZqEwirkITo2w=;
        b=i/mbI1odrTlQBDbn7Sso8juskD/FC5YVsnONer0r8WPuqu9oSUW4G/bro34/0bA6dI
         /XesDZo0EsGMdsmJBJpifxN15cwm1715TchXPcUVKMou4YvXJh7+wYhisYyHTaiIWlg3
         LVq9gbgEBKO0h03PhjvaixSmelzywyCiSu+CusTFpJ79xy7xPA1uX/0QEWw2d5JrV1Zs
         cjMOXiIhSsoCRb4Mu5fPPwqpfqa+ExMkBDqFtl/IIzyw4sflaqCtnkMjWnXYaLJpPx2E
         7yLmtKk0yVG88XK8xGpYGDEu3AAZW3DtK9x2BbKVP+2hva1fQ/GWBOWog4JaNSnb9AB5
         HxgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774350636; x=1774955436; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FYZhCGRri9obbGcLyqavMzNMu7EztYClpF7RkkjC8E=;
        b=Pqtq4lRv8I/STGlSiZA7k4xw73pWRs02fIloQyC4uQlJj+9wykWvFJhhI4LMe3LqrU
         LHBKZ+cfuixoW3sPePEUiTYMaWxGPN0dFtO+cW1He0eHE0r/SdfQSg9X151daoanXbPv
         RIq41QxMqKyLCwXkCTlcd4Kh23+MNq6XRzJPsw63Im9YtownWJ7JWyIkDAoo0hdwN0EC
         eRyr1j5xMYy52VWDWtDZ8ow97qar3Bo2B64jEr8N+VZ6+fiaI1zO3oiL5xPwQUoFhjzM
         NLBxs7t0rUAuNfmWEhgRUadkgyB33ueTgsWcNpENLOhNBs6sxCR0/GI8s/Z4WZuLDnVd
         wLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774350636; x=1774955436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3FYZhCGRri9obbGcLyqavMzNMu7EztYClpF7RkkjC8E=;
        b=EXfTK/Lwi84OwB+VpeKjlXARgVZVdNxXNdtyleqLRmRjUlU2GqvTElNALZXX9B86aU
         9ENRi+q5HE972SJf9Y4CPipvw71CfufakT32a7d9SLAgzOr+cf3sty/8h3STzhdqgPTu
         RxZEz6jmwBaU2DyDuir6gqhNxBNJZHXnucslZh3fvJVLTKXBDSBCbKlBxizEIFTT6RwQ
         Tu9vWQRXk/8EOP3H6FOL6u4je0RHhre6mZ1WPRxi2XTKYenz5CwVgSdlgsmH4KtRWKAq
         lGlbUFtfWJLf63s8z/hK1i4awLaHlAV4siaMXUdZ52V/cuz0rUm+oJIyI+0OtHjBasIj
         Mx8Q==
X-Gm-Message-State: AOJu0Yw+B/KmBhmkV3z7ua2lytTkJMnMm2I2PI645/asFHPSd4nC3/Pz
	hrukPB/eRW3EM67mpPeMLpVy4y63LWW6jUGZf3yBU9+t++K1sCsY2LMRkkce9D0IsaGEDG7ccxp
	jt9YD76kQhT65Zf4Lk/4js3kEfH/7//3sc2oaNckngA==
X-Gm-Gg: ATEYQzzo6Qv0+YwFYuO142z/MbLYvrCm/cCBRvGtrLRkxVkrKMZuXPfDaN4ev0QBOD/
	dfmhOSD0mj0L6w36GblPoYsI9gJpva3yaii7hBi+mJgbOJA5IFIAvcL0SYudPZvPdnaQA+uKZJm
	25wK51Ccu3O4jWMPbhGqfKiGygS35mz7m2gPRkR+/lI1Grk92i7w4q4iWRyFr6UpHUhJZU6k0Yv
	7wscMpmGFx26IpHSfS9CNQlWYpfSTaSsIQlr5zE2o1j/ETSdDhC+VBT4/GavQj3a64RVrKPrLbK
	s5d+zKBE+5akm3rOfdiJex1wtxe/2h67IBhIVFyD
X-Received: by 2002:a17:907:6c10:b0:b97:bc6b:7f21 with SMTP id
 a640c23a62f3a-b982eeec4b0mr1086285366b.0.1774350635473; Tue, 24 Mar 2026
 04:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-7-2c46f9eb0508@tencent.com> <8b9e5300-c95f-40a6-bd8e-7c131a158281@huaweicloud.com>
In-Reply-To: <8b9e5300-c95f-40a6-bd8e-7c131a158281@huaweicloud.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 24 Mar 2026 19:09:59 +0800
X-Gm-Features: AQROBzC0pp5mXNNRD5sfldBpcIBsaS3Zi-wZIkOT2OC6Wgn6YzbKQ_WcUdDo6dk
Message-ID: <CAMgjq7B_478ThcWswraBd2xJoBK-6EUY3=RmrXr0ELe826H4Ug@mail.gmail.com>
Subject: Re: [PATCH 7/8] mm/mglru: simplify and improve dirty writeback handling
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6973D12000C
X-Stat-Signature: e41hoctew6nisbjmtns8y4cm6rwwn494
X-Rspam-User: 
X-HE-Tag: 1774350637-170110
X-HE-Meta: U2FsdGVkX19gBh1IUtqapiewRc6d1ONE6qmOs7NlqW8JcrcYzhu6otQmoTIpi+BUuO9hMsXcsahWtQvn98og1KhF0Her951vdf2uU8sxm0sazn1ldQAwdFDrRzKO45NKgFwdeOTHQ2YtvhODgI5hm6lKLGbVSrDRVfnW9OyhE3fNDtePO/nQNi60u4fsnM25rmpNKplM8JWE4/APcfjsUaerfLnjjLuAb1YSB2yuJChLmMCrwfPgDbWv+FWMCnGSmU/clD8sDBxqSPptD54/WHUnn9NVYdWKgR5C/9PfNfsws04eGio/wdCLkaUro9Q6VHrsG0ToUuXWhHTu5OgjlL/bfIK6cpWDeRjJfq8B3fMaGz+FLzxmVGeY4qdy2u+E65HUD8elodURJVLJfVIYSrl0KkO8krYf6vG4KpmSF2Yn4BpqyZ26eniml73yu4+86WT3yMFeZsQ3JHRGLQ7ior0k6LSXR3OuLM8AcNQhdJpaO4ZIJRNmFqxDI/fYqAef+CODnIWKWKKMTO9WAmPcHlvnfG3rRK0Nxgfhw2f04VLru4qBjKAlGei02r7MYmz75kNwQauOSzDp4Lrw+S1Dy86/7G5qlxN1mOBAUrpHL8csPGyZ//BanZpP8Ch5ju7OJ5dXOyezRmSSkub2z2PieKUTpaRspSHItba5GfYq5gV29+izbQj14dlj1rMEo6cH6KEECagdwaJ2JamsjOhLl5HpdDzLcAKvcsjDiT0k6BHgUxEV7SxCHOgkN6//ei+KuNbbGcACa7JkBuvyaJgSwOkBKrkr/NEL8Kvqr70bz2B8mRsmiFyxLKCudQhZvYVIGqe2Xt5+FuQu5VdNst6VPHkcetsTnwAkvVg94EwvdV9K+Bth1xFyx80WDdNfLMjaxTYnpyW7umP0NTY86nDOYmTMlgo4oKMakxORYgTUylKXTCxlN6GZQycRt3db6DvmEu2ecRtwL84H0UhKthm
 QGS5zroP
 d0Z3JSGwaiuP1a5uGmJ1s6lcQkvLFztj8YE2+oO/DsOWhvVFKVrWEK6EM1bdjASilUE500BhmguFhZyuFycLBtWALDyPgPcK1ZtLn6AyX+aG6lzuVoyC5M/UUnYVCyk0gcJoOiYdV4avqwjWA499gE9UD2H1P7yPa3yW0uUzMxRK7+zy7+6U8TvNf6KjDn0QWIBdKzkJgOO/KpePRlC1beiV4KIYKvWxjWznWgKqMcCV39lZJBN0DAcEIdMw/QWsWTI+enRdFS4TdSo+DVBqU4aUIibR1iLTCGG4mBoQGtCRtj2yfpiB01n5hyl+SgpwZ06TufAfeKOaCxAR+Z1BG76+LfaBZpJMLpxW7wmdPV2iVc+7Y5UGlqyCk1VqYIxbcH+qbxsh0d2J35pVqto/EvqhmqW376aTUB0uMj3LOcHvBmLZPOXVLorlMx+iYaenmHH1A1TzgjlrhLWDJLsu70T7FCtJkdJhrpnnFMGP0xwMcXBfhzOCsj3i/YbKKq297P4x4xcx1q4Q9gpX3NEDqcO3GubmxfRyuvoQNrw2olyy3y0k5n7s0LG/bug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 5:10=E2=80=AFPM Chen Ridong <chenridong@huaweicloud=
.com> wrote:
> On 2026/3/18 3:09, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The current handling of dirty writeback folios is not working well for
> > file page heavy workloads: Dirty folios are protected and move to next
> > gen upon isolation of getting throttled or reactivated upon pageout
> > (shrink_folio_list).
> >
> > This might help to reduce the LRU lock contention slightly, but as a
> > result, the ping-pong effect of folios between head and tail of last tw=
o
> > gens is serious as the shrinker will run into protected dirty writeback
> > folios more frequently compared to activation. The dirty flush wakeup
> > condition is also much more passive compared to active/inactive LRU.
> > Active / inactve LRU wakes the flusher if one batch of folios passed to
> > shrink_folio_list is unevictable due to under writeback, but MGLRU
> > instead has to check this after the whole reclaim loop is done, and the=
n
> > count the isolation protection number compared to the total reclaim
> > number.
> >
> > And we previously saw OOM problems with it, too, which were fixed but
> > still not perfect [1].
> >
> > So instead, just drop the special handling for dirty writeback, just
> > re-activate it like active / inactive LRU. And also move the dirty flus=
h
> > wake up check right after shrink_folio_list. This should improve both
> > throttling and performance.
> >
> > Test with YCSB workloadb showed a major performance improvement:
> >
> > Before this series:
> > Throughput(ops/sec): 61642.78008938203
> > AverageLatency(us):  507.11127774145166
> > pgpgin 158190589
> > pgpgout 5880616
> > workingset_refault 7262988
> >
> > After this commit:
> > Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> > AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> > pgpgin 101871227                        (-35.6%, lower is better)
> > pgpgout 5770028
> > workingset_refault 3418186              (-52.9%, lower is better)
> >
> > The refault rate is 50% lower, and throughput is 30% higher, which is a
> > huge gain. We also observed significant performance gain for other
> > real-world workloads.
> >
> > We were concerned that the dirty flush could cause more wear for SSD:
> > that should not be the problem here, since the wakeup condition is when
> > the dirty folios have been pushed to the tail of LRU, which indicates
> > that memory pressure is so high that writeback is blocking the workload
> > already.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxia=
ngzeng.cas@gmail.com/ [1]
> > ---
> >  mm/vmscan.c | 44 +++++++++++++-------------------------------
> >  1 file changed, 13 insertions(+), 31 deletions(-)
> >

...

>
> I may be missing something, but I think this change moves dirty/writeback
> folios into `shrink_folio_list()` without moving the corresponding reclai=
m
> feedback as well.
>
> Before this patch, MGLRU mostly filtered dirty/writeback folios in
> `sort_folio()`. After this patch they can be isolated and processed by
> `shrink_folio_list()`, but the new code seems to only keep the flusher wa=
keup
> and no longer feeds the resulting state back into `sc->nr.*` (`dirty`,
> `congested`, `writeback`, `immediate`, `taken`).
>
> Those counters are consumed later by reclaim/throttling logic, so shouldn=
't
> MGLRU update them here too, similar to the classic inactive-LRU path?
>

Yeah, how about we make better use of them in a seperate patch? MGLRU
pretty much just ignored these counters and never populated some
sc->nr.* so far. It's still not an issue introduced by this patch,
could be an existing issue, if that's a valid issue.

This patch only changed sc->nr.unqueued_dirty/file_taken, combined
with tweaks to dirty handling, the result is pretty good.

How about a seperate patch after cleaning up the counters? The next
patch will remove unused ones, I think another patch can be
separately tested and reviewed for things like throttling.

