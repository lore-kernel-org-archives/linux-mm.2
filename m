Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7247C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 02:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DAC6B0092; Tue, 14 Jul 2026 22:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945316B0093; Tue, 14 Jul 2026 22:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B966B0095; Tue, 14 Jul 2026 22:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F34D6B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:32:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B73A21A05A5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:32:20 +0000 (UTC)
X-FDA: 84989436840.15.BB365FB
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf31.hostedemail.com (Postfix) with ESMTP id D075520007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 02:32:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ssCbbNwP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784082738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5U2gsxnaRQCx3xPWXfZ0gp4p5vb1WRNZrSU0lgt8z4=;
	b=QkPI0ymw0I6Zxto372P14cmasn/PpnH16l0KQZMb0Sa2A/tlIvx8fEYDibfHjBPW9gzgLv
	3SsguHcKBkW4KXX/QvmhE9AyGPDMDG3WJvuv9Ivb9WDUsdZzI4qdw/SKfTZbyxAqCKzLpV
	aqmKhKMAOH6fa8LB1HegfXv/bXoCMhk=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ssCbbNwP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784082738;
	b=aBl/bnIUJwBunYP4MjnMHt7n6FgAL1NKxRYdI8CvBiEUbo5j1MFM3P5o2lTR53k/LLJ3ef
	vyW6T530hcqGpswXZiNSc3dYrjm+Rkfid4aXfFdz+nsohdZuhfty6ypMH7BxT2Zuc2mMDl
	llN+M7+IAO0RZItrkSOknE0uuR+MtHs=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-80dc4a68e4aso40351047b3.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:32:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784082738; cv=none;
        d=google.com; s=arc-20260327;
        b=XVU9JlIn5rqZo6Tw35hYY/PPt1uACVL65qHJo/4BVLyJgT+p1KqmtwL8vVWY7x8bN8
         J0IQttQyhstg2XU9SoQxlz+ar0JAIhAk65Qu/c9+fulRfGmSMkSUwt4x9viMPLwvN8+h
         6BB6ubricCR2T1MgvhIuZ0X7G3/59AaBoJNiTnkNqo4Vv5PM9Z8tZkjE/f7d6dEGO7TX
         KYCQm/fxzhJ53kjjprD7ful38EUmv1LA2BSKXiQsBmbQHsHv4FRdsE/GDQ2xvCSAZFk2
         S1PquaqYdAx/QD+MjN0PpcGm11RigW2BSHtBJOF3uCSCHYiCEUgUveTygfK0wUFyMGWa
         SN9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v5U2gsxnaRQCx3xPWXfZ0gp4p5vb1WRNZrSU0lgt8z4=;
        fh=2KRFbCULtgCJVJkHl4yB7xdnsB5q0t9t5cnwYIc/aqM=;
        b=cRGNXFz2sNKSyJKcrtMmHka4+2dorfUii+cImY1iaVEo4RAvFgH9b2BSJMO3NNVisO
         7khpXrkzPgopVQwhnrEKgh9ZQiLqidPYGO+AIqj7hIW3jg8+K+P1lcu+oktY2rh5lI75
         YQuWWtwg8t7EEfWH5HJ1TjYRSue6CJnTw7QS/uJwc3t6LobPE9Uwq47+2szGxcWKd/uZ
         l9D1W4lY23Xs+zNZoBVIBpx0yYJjZaex6OdG6cCY+eBnYZVvS39xEBhqDo8my5rDKZrn
         5fsvtiLRUg+hrrTbfc3bbEPxyBUw/IPfT/+ZXlhjaIlpmpnnKOnbJ8eUFbQtds3A9vPu
         2cvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784082738; x=1784687538; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v5U2gsxnaRQCx3xPWXfZ0gp4p5vb1WRNZrSU0lgt8z4=;
        b=ssCbbNwPR3+D7+RbFfRbBc3luR9CCfoz/j8ETGwqmbZerj6PBZlhMIjTXqSJY3lpUl
         ut6qawoyS0ca3TBWMXL9wasp+qoCxJii0DbFKFkrCGP0QxjVG4kWssco6RAJfryCEJMn
         wfnqOrF7jcSEu6fhCTh89ArWR6OIMcrtSFSGGZPH4vSttHG3zPcKzR8jf5iCQeh4IVbo
         OoHST47X95amO1QY3DRs7kM0Rz2G59MdhJnAmgeUvp/AkI0T6N/VtBZo4KsIZvA9kUZH
         niwumMqP3at0gOvGj4rFTHNgr5MjG1GK76mdQZIK0qZGLnjF7zVAbEj0HMvMgAgBlHll
         MvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784082738; x=1784687538;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v5U2gsxnaRQCx3xPWXfZ0gp4p5vb1WRNZrSU0lgt8z4=;
        b=TXePMp5z3SvS3cb058zVj9YUOsPT9qHz1dUoJKFo3oMvW033V2o9eV7rqaAqZ2efv8
         lfxRvGoZm/EtxoGD9i73EnwggZahRL7RTxlsEDV3rF5++b1To5ytvq97qUOcWPNAdg0u
         H/8+/A65rM4t/tbjv63ZatGUf73wvO2lXGeEpE3ep1WOaseOh746Mw5BPDdrAa5z/ryU
         Xpo6lFKANtHcDRziLBAF5T57bo+aiCx9DPrHRByZrthRTkC1vORPP61hbo33EdQda8qj
         9xtuZyPfXdOuiulJaHQ0gASHhDKCKQSi8shZZOURnkWXSrZZL5XZOVtYLrshVbelKsZH
         EgSA==
X-Forwarded-Encrypted: i=1; AHgh+RoBlkFhuNtlp6RIORizMXjGhsQ46mFM7JcaR9LIv2nKPh2IXdISDGPniQYUm2Kzmw4hUBGy2IbCOw==@kvack.org
X-Gm-Message-State: AOJu0Yycfc3Up44hkqpQhxgToZc+MKJe8Ywv0Jzb0oPHEPb6jEMKSP+E
	Rs4BG0z1+0/ISRsnXiAlNh6JOtLXvb32l+ZRS4FXKMDGo5qTxYJN0YYm7LknClRHxtfrjF/guXA
	/eGUKZ4tR8pmPdpYdz55OGiy/3p3PcNQ=
X-Gm-Gg: AfdE7cnNUHFiVDHVtITh91rrUrBWfHeQbrxCOmGQxpKWtuJ3tA+fpPALu1lMhlyUMoc
	tw6lbk/Nwvhnx+mEuZhzvELqxYzVGGR3Z+rAt0eeUWDkrPucFHAKO8dex2FZHQo7nobhXCOSVtY
	yTQOlmIg+c4zBwWv6ApmOIa8V5lY9ga5GCDI8T8lvNzbw9s2FRHZyhLU261Od0kkzmMdO89bNRT
	RZsolHFMMfqisziz/RRQ6AtOG3JIga/2kd9MN5nTgzbbu6MNoWw8JQqDSo+aHI7bxKCAjCJ8PG/
	fn6bu0ZHox/OFjpxreamj6QM31rEwhq6/43zEJA=
X-Received: by 2002:a05:690c:998e:b0:81e:51aa:ff79 with SMTP id
 00721157ae682-81ecf7eeef9mr8412307b3.18.1784082737844; Tue, 14 Jul 2026
 19:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260710024429.70923-1-ahacigu.linux@gmail.com> <alYesAbH_i-v9mPh@tiehlicka>
In-Reply-To: <alYesAbH_i-v9mPh@tiehlicka>
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Date: Tue, 14 Jul 2026 19:32:04 -0700
X-Gm-Features: AUfX_mwromrIYUtPbGDJ3O4kMNWU0ZZkGo_BE4_LEtN1pvjlRRYFY7TWHN0BRV8
Message-ID: <CALjTKDmw3OYecPUO3EKOLfHUxShM9NdngfOh1V8OOKyHbUgbdA@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan: clear hopeless kswapd when global direct
 reclaim makes progress
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Jiayuan Chen <jiayuan.chen@shopee.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1s3wumjjgrknht1roqmywodd11qua6mu
X-Rspamd-Queue-Id: D075520007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784082738-596089
X-HE-Meta: U2FsdGVkX1/5RHVHlWD9jaH4ySxmz7f2fxlnQedZHcJmINucYqXkLYnCZoq1gl+IwfE4itdMw5RcacSB/vmalYDmr9nvt0OpuJAfo43gZ0C5Zy8Ok7EHKYMyabnQRabmZ/qQFe514Wlhs5H9xhZ6Hy/5oONbqP/ZoYar5SMjTiUkEjzPG3MmjvJ+jP29lTQwy4XAzwhGvKflRFhgS9CRdtBI8zynYTYmGvpAdiOmQZtuzJCZ9e1e1q8KO+XAmXzakbOBlQGcTUk4dM2i0jV95eA0JYVlTv6dX7SC9JxOXUUGDs+CcryLoB3ENuPWbNVAkjvhK0rLszA6lzEjxh5XEdSaFR7tV8VY/IzudGTc4t7AAhI7m1xDrNIQP0aX5hDSYzQBY5Bfu8A+Nr0vDxUv5u/P2y5ChAWaprRmY0nZxtRPaKYYjnIj/ijNulTY+06gbyyayRCQTRdDLsL/azRQAJwLXzs38l6ZnP7j1drASgNto9PwJkzhBN4qfj+yzb5kZUYAgsTQGcrqR4vKW04C/EOm8DN6Q2eqCG3gb8hHipbz3jM7MvWrA0YsKnpkpUunfooujF1tUWrUjCQolTUXI8VCmXsnpXNFakfY46/F/wNhtTuw5Vxspt3u2oBBaemtyKgXJRjNsihPzANnmC9TMAaqZcxpJ1UR4bOORw9ZMqblA7hXPElAPbVdL60/IRUTzYTtYqNZ1lU4TA/whI5ERUWAbj1TnyXdwB5hPaz7lJxUb2NOfwVv8Q3qAkPrjwFQp+zUtJZQKc2a2xyzhg0Z+rN2xfMs6x6yOv0n502fntNpp7pVt8f8qleo/ZlxQ6Q6E0hIPfGw5uMMpL0ADb8Oo6avrs+gn6kvTUVfsK6KXVwsEX4gGb2Tn2pePVNPDueGPYSkjdLOMPpxtiiolD7sgC+87y8TWOALUY3hajscpB4s4GoFNj0BcQ+3Crrri5RjMNhZu+gIesitLH0BLBV
 tf9hOZx3
 n0/WE7pnZlNTvVb8uWZvjxCh2Z2sMYX+z/7bMluMoY3gcm5/ljIZIv3y54ybE8HJeUPvSboxQrO2AXN1/r6jNe5o+PBplQbR9xv3Lk/uA5YKSksbIXjt/L2R6Z7CqY2SdA3wWy0oV0hFAlBtz3j4IqynUZr5fX5gvl52Co+dFJ/G59M9dIPxwaI4um0VKBziJQIufCpnVXXgUmNHQ/AJg2kMnt3dAo9tHCrCoBoF96/0wJMmji7apKHjLB3e3S0+yGeu9u9rIbt2an4TI/edkYI2ea4dujhPfBqVFsILo/RABS0DCKwHFNwHoix4Au9Z22NXAeT6O6Tr2wU9Tlm+Nq7eklijKieV+nQFfW0r84lD8gZ0thoae1XVqXhlGYB4VdoM+O7RKyEVSOOCn5r26w0aNvEeyRsKz4aoTHM+lyAIPqxhgo3Cbo0wmqeqoQ4ViMAcF4ZDZ6c3AT02BoDzGGTqgQIEfyfCu8dFHcObu2nPsWcE+m9tD00Pda0TkDvy2TyYKu+WZezg2QtY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 4:34=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 09-07-26 19:44:29, Altan Hacigumus wrote:
> > Direct reclaim clears the hopeless kswapd state only once the node
> > becomes balanced. This avoids cgroup memory.high reclaim repeatedly
> > reviving a kswapd that cannot balance the node.
> >
> > However, it also prevents global direct reclaim from reviving kswapd.
> > Under sustained memory pressure, global direct reclaim may continue
> > making progress without the node ever reaching the high watermark,
> > leaving reclaim to allocating tasks.
> >
> > Unlike memcg reclaim, global direct reclaim follows the same node-wide
> > reclaim path as kswapd. Clear the hopeless state when global direct
> > reclaim makes progress, while continuing to require a balanced node for
> > memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
> > scan_control is private to vmscan.c.
> >
> > On a workload with most memory mlocked and the remainder under sustaine=
d
> > churn, with swap enabled, comparing the same 60s window:
> >                               base       patched
> >   allocstall (all zones)    413441          6532
> >   pgsteal_direct          15889552        255619
> >   pgsteal_kswapd                 0      26079382
> >   PSI memory full avg60     13.10%         9.37%
> >
> > Direct reclaim was already reclaiming many pages in the baseline;
> > this change lets kswapd resume doing that work asynchronously.
> >
> > Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
> > ---
> >  include/linux/mmzone.h |  2 --
> >  mm/vmscan.c            | 23 ++++++++++++++---------
> >  2 files changed, 14 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index ca2712187147..1db6f8dac927 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1630,8 +1630,6 @@ enum kswapd_clear_hopeless_reason {
> >
> >  void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
> >                  enum zone_type highest_zoneidx);
> > -void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> > -                            unsigned int order, int highest_zoneidx);
> >  void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeles=
s_reason reason);
> >  bool kswapd_test_hopeless(pg_data_t *pgdat);
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35c3bb15ae96..78fd35a11eee 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -198,6 +198,9 @@ struct scan_control {
> >   */
> >  int vm_swappiness =3D 60;
> >
> > +static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> > +                                   struct scan_control *sc);
> > +
> >  #ifdef CONFIG_MEMCG
> >
> >  /* Returns true for reclaim through cgroup limits or cgroup interfaces=
. */
> > @@ -5172,7 +5175,7 @@ static void lru_gen_shrink_node(struct pglist_dat=
a *pgdat, struct scan_control *
> >       blk_finish_plug(&plug);
> >  done:
> >       if (sc->nr_reclaimed > reclaimed)
> > -             kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_i=
dx);
> > +             kswapd_try_clear_hopeless(pgdat, sc);
> >  }
> >
> >  /*********************************************************************=
*********
> > @@ -6251,7 +6254,7 @@ static void shrink_node(pg_data_t *pgdat, struct =
scan_control *sc)
> >        * successful direct reclaim run will revive a dormant kswapd.
> >        */
> >       if (reclaimable)
> > -             kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_i=
dx);
> > +             kswapd_try_clear_hopeless(pgdat, sc);
> >       else if (sc->cache_trim_mode)
> >               sc->cache_trim_mode_failed =3D 1;
> >  }
> > @@ -7530,15 +7533,17 @@ void kswapd_clear_hopeless(pg_data_t *pgdat, en=
um kswapd_clear_hopeless_reason r
> >  }
> >
> >  /*
> > - * Reset kswapd_failures only when the node is balanced. Without this
> > - * check, successful direct reclaim (e.g., from cgroup memory.high
> > - * throttling) can keep resetting kswapd_failures even when the node
> > - * cannot be balanced, causing kswapd to run endlessly.
> > + * Reset kswapd_failures when the node is balanced, or when global
> > + * direct reclaim makes progress - then kswapd can make progress too.
> > + * Memcg reclaim can succeed where kswapd cannot (memcg protection is
> > + * not enforced against the reclaim target), so its progress resets
> > + * kswapd_failures only when the node is balanced.
> >   */
> > -void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> > -                            unsigned int order, int highest_zoneidx)
> > +static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
> > +                                   struct scan_control *sc)
> >  {
> > -     if (pgdat_balanced(pgdat, order, highest_zoneidx))
> > +     if ((!current_is_kswapd() && !cgroup_reclaim(sc)) ||
> > +         pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
> >               kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
> >                       KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPEL=
ESS_DIRECT);
>
> Is there any particular reason why pgdat_balanced is evaluated for
> cgroup_reclaim? Shouldn't this be global reclaim logic only?
> I.e.
>         if (cgroup_reclaim(sc))
>                 return;
>         if (!current_is_kswapd() || pgdat_balanced(pgdat, sc->order, sc->=
reclaim_idx))
>                 kswapd_clear_hopeless(pgdat, current_is_kswapd() ? KSWAPD=
_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);

[1] Only to keep the diff to one behavior change. Agreed, the early
return is stricter and cleaner, and reason=3DDIRECT then means strictly
global direct reclaim.

[2] Also, there is one more condition I've been looking at, from the
Sashiko review (a theoretical corner): skip the reset while tasks are
throttled on pfmemalloc_wait, so that it cannot defer the hopeless
escape hatch in allow_direct_reclaim().


[1] and [2] combined, it would look like:
static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
      struct scan_control *sc)
{
if (cgroup_reclaim(sc))
return;

/*
* Don't reset while tasks are throttled on pfmemalloc_wait -
* kswapd turning hopeless is their escape hatch.
*/
if ((!waitqueue_active(&pgdat->pfmemalloc_wait) &&
     !current_is_kswapd()) ||
    pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);
}


>
>
> >  }
> > --
> > 2.55.0
>
> --
> Michal Hocko
> SUSE Labs

Thanks,
  Altan

