Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DE8C606B262
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Jn83UePD
Received: by kanga.kvack.org (Postfix)
	id 9BC5F6B05B2; Thu, 12 Nov 2026 03:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993436B05B4; Thu, 12 Nov 2026 03:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C3E6B05B5; Thu, 12 Nov 2026 03:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4136B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:51:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3A05140449
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:51:25 +0000 (UTC)
X-FDA: 85425848130.21.1210E55
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id E73D4160002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:51:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jn83UePD;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+51He1s6aoyuRv7Pl8PGTmRqyfPdZQfGYOE/8zFV1Dk=;
	b=sW10R+Iw4beCIMnC6oBwNTZlu1wkoWCVnhNufeYCDbBcKNgs9YjVses0WDZYNvIgUzid0b
	VAaNmiOZkVpEKugPNWbjvCYPhCJ7g9+SHntkjh9Vl7bQJgUFrAOKHdJoBcag9bOgfAIFCs
	CqWS6OBQP6tAb+cuBc6OwTDoNmaoUsw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794473484;
	b=pu/AIbtH7ys6GrrHkm5NIwQWCfqB1yZsfLM86Ldoi3VfbcKRtdJhxoRebw4BZa7iJlqR/8
	EfxrPd2hvFnVIwN3wy5Z9BGiAmBHJJTkNV007Sq1/XoNcLS9g92mhEfyxRmTYxUWOhWQnx
	pe2Nyyy1fk0Ff5ojbtiiQGqg1Un4+0g=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Jn83UePD;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso3901386a12.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:51:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794473482; cv=none;
        d=google.com; s=arc-20260327;
        b=hpCyyQQJeDOu364m9PhdPGqWILPcT/6OBdzwOKJHPx9DZQNMX0Z18fjAiUTwyBJDr5
         93Hq9AuG9sIKgqTQTd0Y3mcYLyN8D6qgBzMwmXHoqFULB6B01tIQAU1kiSbSJGZBQY8j
         mp5/w2XmKP6Xi5c4AqONKAr89fQ7YalmYh3kFxzTSxaFGiVNsEFye3kWEt6X6oLh/cub
         MeW33Zj5/GpA5T6kr6P8cdcmg1YVRZlhXgHDszZTmpS7cYmWR0ev8eDTavLnV9EN50kB
         D+IFSVsUK8cslq3Nto7xgdP9iumL9XT3gziOG2sEOMu7p5nCve6aCZnOhkEFF8/pGjGS
         7KPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+51He1s6aoyuRv7Pl8PGTmRqyfPdZQfGYOE/8zFV1Dk=;
        fh=2cTlrgtO11jdBRByJl9UIO+gPgtZRUwiIDUL65+ful4=;
        b=FIJHKbVDFRWNDPmBKMmao111nTUmg2FmXGpQN8q78MVwZoRi7HYC3WwiTtc5+h5Wtp
         VWxj0kEpCvVjFnMn6AHXzMRqfQeEOuYF2YyowPYuZ6i51STovU0TqNPN4YmSNTbhDAa7
         Xug1CHEnZRZvcsk/NS2hqxtbtc3fBvST/kf0QDhsM8Rh8uLjMioNxqRveFmVk1hnfB1O
         vTkJcPQxR6ONtsBFi+nItV4ulTMqwinu7wsnzcH59BkRrSJDAntUfgHwu2dnIzNqFa+L
         f0k8kRS95EcKmX4yxfiDd+YfsLMK83YEICK9rgWe5oZ9Nvu/DJOu+1v4ATXDV1gxhpk4
         lCtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794473482; x=1795078282; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+51He1s6aoyuRv7Pl8PGTmRqyfPdZQfGYOE/8zFV1Dk=;
        b=Jn83UePDZenvOWK20loRJiKDbbftg7CXZGZWiLzwystFOjsvVnCRqa/vVOY6W5X+mT
         VR/FU8e7bABK6wx/noC+OWSZS99ESkUhddr88DzMrqDV2tU3l5vBWDuZRvTUkxP494D0
         LpJStfydLqY718Rovozqf+tY6HvrYr+9H3CZZGZZ7O6kptnF2zvzb3DZMTVO+BiusXRD
         NSZ7WHabeka2hubemi2bUZD5lbsFvDyS3IYSHTQqvLpxyHniCwknIngP8IeSEN+UQEIu
         g2qpnFZzHQJGt3a9TTQFRT6sWcrShfSLjQ6SOzPL89vKoxAyv06zB3Cu83jLxbOdpJ1k
         4rkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794473482; x=1795078282;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+51He1s6aoyuRv7Pl8PGTmRqyfPdZQfGYOE/8zFV1Dk=;
        b=RSi039Y2ejThdZ3uVKbj5aHYuOlbU0GOITIqCTdH5KC/kQbM5Hasct4Hmj8L8caYZw
         I23QV+apbpwMLyWiY3J50C6iikJ02NLjUvaLeK24epO4Ef2SXlkGeCn2MPFg7icC6w87
         Gvnb3m8i3S+S0K6I5+aKRoOLTM5y1dT0s0rGO0kKe22ZVOTOCh5fmky1/SMz4lVvFUUb
         GD5Lc+ICFM4sV7212+1zN/AxcmWEsD1xFz4ZYPmsU06WBwrmEo5/gkv9nYM8dMjM7ziw
         m3eMl05A6oqUUgZruSA8/7T7Mjg26C7++QeDnsMkU05e386vdAxpoSA8jta7fJSDcENk
         5MeA==
X-Forwarded-Encrypted: i=1; AL+hErH3GNUCatKZPwp6LBTOMCSRkqM0o/7omMlWe9LUM/5FEI7dFvoy8UkeqZWE9Zx0dviMQ0iK4Ei+5g==@kvack.org
X-Gm-Message-State: APuU4Z96Gbu82PkaMPsSBg6rvqTtJh46xnzkhAgwHiDFrLNBl0z6Sxu0
	U9HZsU1jdVUssVGl27MXI43LxUwU8qIi19vdLWc7JV8qzs4Y7YDFJBsIZPRSxm/Z42ULUsFnwUC
	Uc3GkM70S/nB4rgTl22ZE1qApD1aUWRE=
X-Gm-Gg: AYBFou1eSlCP24NrF5FHVDObF4WRL2d7OKi9zlkoSYQmZ/5M45DErFY4NDAJtLaWxLi
	sAXBoPOcS0C47kyaSqVeZ00e6aJGDeFXbokQbW2Xqz8yolTwhYDiFy2IbPFY9FUqgHNNlrxVVi0
	GyuI2ihzmIWLY91oRvHtnIMOBxeVpgK4AFc/sK6a5/afvGJog5bXJ3OQqQwn9PUoZ6wXs2Xm2dM
	6BNmpqoMuSydXR2N1KQrVswU2dYljBjUORjtAm8lWwcySzZ+Te/02O6Fcg42xc4GZmbH3RxKq0p
	MNhfaACsHVGkxg5+Dsk3CtxLxAFTc+S9ILp/yZfxbB+b86ZVeRpagb173xHna63DMOSxm6SMDpB
	Lpb6DNeDeTAhA0RMVgsP4oRXMF2mSORd4VF+H8E3Si65sK2nwxHVrou6fZ6ePysSabMl9zQ==
X-Received: by 2002:a17:907:96a5:b0:c40:9e84:942a with SMTP id
 a640c23a62f3a-c5066dbc955mr389476766b.48.1794473482370; Thu, 12 Nov 2026
 00:51:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261112075827.255602-1-hui.zhu@linux.dev> <avVx_1BEP7fIzGDK@KASONG-MC4>
In-Reply-To: <avVx_1BEP7fIzGDK@KASONG-MC4>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 12 Nov 2026 16:50:46 +0800
X-Gm-Features: AclHuK_p7j4nmA7-jgNf_VxE-Yc5HVRQkRr2Wm-N0NDC1S35NcjsDx4EdkkkDeQ
Message-ID: <CAMgjq7BgNCVwxmiXj72V=Grn_Q72jKCT1NGrv1zS349xcBoPNw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: check need_resched() in fill/drain_evictable()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E73D4160002
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bro61rq1ksn3meh1wc16h1deresterp3
X-Rspam-User: 
X-HE-Tag: 1794473483-444198
X-HE-Meta: U2FsdGVkX1/Gxk0z2+vjXe7JMFcp/L0Sxjzpurj7an09ueY6c1dW7xP9f8qblH/DuUJlMDH7UXjGz/oQJjPTtn6dfNlXOw5mypFYxN9s8+HNjywA9zTwEvRL1FHNJrPVv5lQFQz7b6BtC1ktlsAKcmGgVt4teFdUofdJQCYjRfQVWsPKjdDk5QZEDYKd3j9SSW3FD2kXWWLy6/q/HMkCOTQTWzVnnFUgdjEY9z+SK3t0I9+2VSik0tfmACPV0U8VFCeOS6FIrs/FOUeRQGeBFk2wLN8mabPIl9wnV73R0E3F8rRL/DdOdl5c2HsnLCbNTdqPxvHLZqBBnd1ZCrG0mP5kKmjZnux0G5UdcFquDdtR2ihNAFdpatFPlrcncYJDzF1WQJH19zhSJdcpg6ZjbzN71FSFoHcU+zJ3DCR8uTKPoUE7s5ZDh9SRm0bK7AMzgjSiB59CZMFU6nTieD8rkS0mntsbSAisSrXsNv2R5sfr3D89IDorPMX3jVsOXbh3L7YizWL/teskwZemmMFOOv5BAQ/6QaIfF/o2D+X0l9WY/4xMJzZzz7VfHih1KvcEUHPtz1HtxMGGvv4v9XlSB1HjQQpNtf5T9v/qtopitL5oJC4igMtgSKUn+tUsJdmXCshI4lLKuN1lZuZsb/6VbM/Avg55T0JXZ95niL83R7vxHUw3Jb2HNhUZ5a+BK7lYF68eH+IUX4cNGe7uqH1JSPP29WFxnSNutlmw7fbJNAiWBtMfBjLaA+Rnn3CQrswnxY3SXs7yHFG1Orj2S5F1VXBvMnM4LuqvTbLfnE7DNLaYGHxyMkLQapB77Hf7d9wA4I871KwHl72cWYZbOdU/wUQze0o4ueTvqARTRhPe47aDdvH90gTAKyF1NPykgv9RLjpFupSNk1traA1fyV+omPVIHY+jXljtptOWPuVwTKX1rX3LH93HLRJdYiMwkZdOB/VmpzJEsnkmakNPCQn
 nGjBewmN
 8wjCLJXjv0Sm/n5EcxHL4eAl69qa+AgVwl2S5cjklgcjCskaW8dugluAgdc0rM1ZmPzO3cmdb9D57JbCoZDjyYuv2HqetQ0D5Wh7AK/rq8hM7Dw4cR6eCoycGGEiFz6qf0rWf61hQ0+Tjgj+UOjAyW7PhOzoVZUTR8w934L7jt20+boz5hQ5wDjgV8XaHMPMTVMkdZ/hm9gWVPh4eTMcxx3X/Gjj0gIA1q7fsOhy4eeB28/RCkJ/+9lnowQt6U2yO61Q4qOjVN8RsKZK3KZB5BO7T/uR1g4Y7BIJtIGzdHBff9WRDQoAFUale4N/lLXbksbk3jzg0YF5Uwp4WHUgo+aBS8/WRPGW4JJjc5xIJcaah0GwsfeJfH0mdW4ACvXjNSWF5Lb+ZVdTw+dn5IBKB3xIb9YemBwnecvzgl8++Ot8HUSpJHX4W6/mfo21t3I+2dqA0Qn6pi3ZNwAukJDqaXjcA+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 4:04=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Nov 12, 2026 at 03:58:27PM +0800, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > lru_gen_change_state() migrates folios in batches of up to
> > MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
> > keeps local interrupts off for up to about a millisecond, and CPUs
> > contending for the same lru_lock spin with interrupts disabled for
> > that long.
> >
> > The caller already reschedules between batches, but a batch itself
> > only ends after 4096 folios.  Stop it early when a resched is
> > pending; the caller restarts the migration where it left off.  A
> > remote resched_curr() sets TIF_NEED_RESCHED directly in the target's
> > thread_info, so the flag can still be set with interrupts off.
> >
> > This follows walk_pud_range(), which already pairs need_resched()
> > with a MAX_LRU_BATCH cap, and commit 6e9be217a3ce ("mm/mglru: use a
> > smaller batch for reclaim").
> >
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > ---
> >  mm/vmscan.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 6a1af9b92349..47f2cb25eb46 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -5533,7 +5533,8 @@ static bool fill_evictable(struct lruvec *lruvec)
> >                       success =3D lru_gen_add_folio(lruvec, folio, !act=
ive);
> >                       VM_WARN_ON_ONCE(!success);
> >
> > -                     if (!--remaining)
> > +                     /* stop early to shorten the irq-off section */
> > +                     if (!--remaining || need_resched())
>
> Hi Hui,
>
> I've been thinking about a different design, what if we just
> delete the `--remaining` check completely, and check
> spin_is_contended on the lruvec and need_resched()?
>
> In the optimal case we don't need to keep lock/unlock the lruvec
> at all so this is faster. And it still avoids lock contention or
> blocked schedule, and it might be even more responsive as we are
> release the lock earlier on contention.

Hmm, nevermind, I just realized we have irq off here so it's
definitely a bad idea to drop batch limit. But maybe we can check the
lock too besides need_resched()?

