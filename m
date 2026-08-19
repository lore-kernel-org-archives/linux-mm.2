Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D22FC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098386B0093; Wed, 19 Aug 2026 05:30:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F1F6B0095; Wed, 19 Aug 2026 05:30:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7EC6B0098; Wed, 19 Aug 2026 05:30:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3E5B6B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:30:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BF361A04F7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:30:06 +0000 (UTC)
X-FDA: 85117497612.11.DA6D547
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 106242000F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:30:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iMkxWfh9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787131804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8v1isZnzdMHObJSBQ0e6xW1KHsZYy0o9YOF8Wf0ENU=;
	b=5OGtVrVoHQVs1v+5hHvo/ylHjQMq9Ffnq77QGVZ9sv0fKcc7GWYv3WYNCAZnlsk4ZEaOQ8
	bmHI+db7NTQ6/XTLezvTaiLSbf0ahGkR/QOV5weDpAeqNuBRx8rIjv1d6qE0SUQTclioJ6
	oztDh5xHKL2kBdqv1kJjW767i2c5K48=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iMkxWfh9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787131804;
	b=jvhhSg0lcCML53rSSin0cDaZhodyn6D/ZHjz38uR+7xejGeYUSxrRohTKkSX4umKbswxSJ
	5LoopzykEt9G965G079Vzpuzmx0NlhNQK6zL2r/m7gxvJ2mQ/o2NyeHMfW+2CjHY4TOLuR
	s9WQt4dSNoAjOIiOl9IaBlgZxq/sqX0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a156627e22so3115778a12.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:30:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787131802; cv=none;
        d=google.com; s=arc-20260327;
        b=d+aDvLbLtBBMW+Fvgg3cH8IkV/bsdsP2lsEVFB8bm7Ye8SMohJ4owwJn0r1w4gx9DE
         BGLZIaotPbO62gjHxVVC+ycYfG2W+hHv9yOR2AbDkUrU2MfSvcttDK2Tq1IiljGbr1XJ
         rPodC/rmIBJJm4p/GbFmPxViiYgIyCX1d60lVvZvtEvbHzcGUwvNnHh1lWXGvXfm17KN
         juDZ0Z5B7I7dKJZu336heKtAILmm/9rq5D/WfSPx5AeIfu/RjOzhiwurMwQ4Yvhq78Gu
         MpFtekWLTSryyzPJnPfy4i/t/uOCpa6/SMBbzwv3JwLc2qbZtOImWlPenM5xi0YYz4WZ
         VJfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I8v1isZnzdMHObJSBQ0e6xW1KHsZYy0o9YOF8Wf0ENU=;
        fh=0P+RS5NazurDBmQiawDZJ5jsRZCD//+q82HFGBUkrko=;
        b=h28lne1VkFzyD2FwlU+ggqHuQJmU1YmQAB8Dq4QhIZWN6VaKPsa+n96ANERFP625Us
         ktDkjGGBZ2zEDzjHDdH1Ay9ZyOnrQKijrmVcIA3di6OpwZ/5xBGF3qoforcc0qdUu82A
         9MULNk9fLyacIv3JYWnwV6okHF8HkXe220JauC8Y2Y/aXlvWxIFRn7IZoqd1eF2LtYzB
         C6Fp9QWyFRZsRelwLm/TcmVtZ+w8d97sv8lxyH5tFj6FQBrT1JwDSvIVAlAEK9Yp0RMN
         CjDzkl4kbsUSg7EqPSnFCBfl+DypbzojTkVgG+HUqOMVdOnTXCF4DZgWljS6WJ/a4dfL
         SKEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787131802; x=1787736602; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I8v1isZnzdMHObJSBQ0e6xW1KHsZYy0o9YOF8Wf0ENU=;
        b=iMkxWfh9D/mAHFV0gZdDjrpVrxghiD8XmKJCJbzFOP8vlZXS5nR3mBeVj+Ev0lg+pK
         kiIPrS9STBYP4R2JjOALvHxNgalW6xDJz+7kBD20babI0RJlulr5Ghl5QYuKf9rHCs7P
         Tagwzs4VQxGX+m4/1Z5wkqNDcguas9KY4/T1BNu/DeHVmUKVc4GOKYjZD51Fjt940gcu
         XW8qMbU6GtoExS+5dhVq8ZBRsrOuwxjlSyRh7UCITPGp5NIvOMB8hTEvadXNpQpwmeHW
         IjgEn8pORPDa5pTBqudymeCqwKP49hMbNuNMfzP55N2nADTmZqTbqqhmrHre4o0k0bpg
         U9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787131802; x=1787736602;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I8v1isZnzdMHObJSBQ0e6xW1KHsZYy0o9YOF8Wf0ENU=;
        b=kD8wQwfodNdlTYM7haiq6rAbvY/16u+e4LFEkWSv5A6W950ziC4+hAdi2Rb4hN918F
         8jvX1tiSwLRXE0qWglssiV9ehRg8L888pQs2FpbgzVWNLpPBexW10/4X4sSi2LbxgN4c
         ZYV1nu65RPs1YRGTnireLUwwTPmmtFY/gI/Ik2tJMng6qaxwzjzlQp5bRMvye7S2hmGD
         hOOjxkQ/6ol8F8qo8mirRiHEIwPb7XjJKqSvikiEuMMK0h+vPZ3MumBHSZwh0+j2NSEj
         MTAWL+lx/iwvXE/PLMk9S+3f5k2MQIaVHO/zltYReUTCK7k/IDSj9bk0x7WAPpuyjz7O
         QDLw==
X-Forwarded-Encrypted: i=1; AHgh+RqXmXvB/M72YZztvWoWUcibRy/pDzfNKwAPSEMAgtpfy9vfSpUFtw3sol4MFImBuBGWM4Ud/R1ouA==@kvack.org
X-Gm-Message-State: AOJu0YwA0i2WSkwjZQjQ15yE6XmIu2Dr/2H7AvSb2yokPrDLrLWVZrts
	G5Km/j3agSB9fU7UOkqwvqohxgi3r4cRF3Z2KY5oN7kJGpTYVE5dATXiyr9i4Apppl3uRwLi0Um
	+WuyvaScunxv7oBxQHm7Q1gvUEdBaSRs=
X-Gm-Gg: AR+sD13T94T0PhGGE+PzrqLAhGoScNw7VzPVN+luqY/yZ8aooIZwXdvfzK3Kv5TLqTb
	3ez4DoQth/ppVEW64JPqd4lgPpsGMSz8J+XR8Jr9NWIqZToOXjoowb7J2qXMtv5GAN+hFy0pRkv
	lqQSE/ZFuSVJEEiI8YRA/kj83h9ClSjiY/3Is2AXotgJeOqVi7ktnvFCTeoN/Dut2g1DmAdO9wN
	jDL44fC+rZ1skbcWhqJC+SpEbh1JrP2heUK961f7P65KAqSaPMo1tqT0UnJtVmloZ1E10RavI7z
	/1gAQAAIZRVK62fYoRmucDxlxYDwAyLl4lQiLRGwxKRKtJy0PVYyg7NFUsv91jQocYnzFTWmCx3
	hIQ==
X-Received: by 2002:a17:907:160f:b0:c1f:2cb2:c448 with SMTP id
 a640c23a62f3a-c237e183a79mr207074866b.7.1787131802171; Wed, 19 Aug 2026
 02:30:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1787056208.git.zhuhui@kylinos.cn> <4b4d4e3065e36f1b60dd69e8276cb92082f393a6.1787056208.git.zhuhui@kylinos.cn>
 <CAGsJ_4xKM1R95TEpKoicGYQB8Qafez6hKJF=Z98A_2j43X5GAA@mail.gmail.com> <39871dbf-25e3-4518-9942-a733dbb6acf5@linux.alibaba.com>
In-Reply-To: <39871dbf-25e3-4518-9942-a733dbb6acf5@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 19 Aug 2026 17:29:25 +0800
X-Gm-Features: AcwNN1VSEPfcy-uADUET0p5pZYZzFSYZ1aVc2M74piZQKya_Yf88ezGHA2PbGRQ
Message-ID: <CAMgjq7D0KMdg0fKMx=i90b=F-ZEW8+UziiE12fCGxKOtiMn1Ww@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v3 2/2] mm/vmscan: apply too_many_isolated()
 throttling to MGLRU eviction
To: Hui Zhu <hui.zhu@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: maogw4449uwzs77y1kf6dznjuxcty8ha
X-Rspamd-Queue-Id: 106242000F
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787131803-371231
X-HE-Meta: U2FsdGVkX19ga/NdhBkAbj++Fxa1RSy+NRCQUUXSCSRswjA0axjfLu0DL3Di9nB7iTlHrYydZIi1QQ/eskG6ccBnI9vRtVglUjvv7YnCXBx05shqO9NB1P4ymfW6vrVy300qSkqKKfbmSElAaIj5yocl3SGJrDHr38WECjbGeOWKhqxy6iv9BejKrMX4cNAapmm4Nt6Kw6ZILEGLb6viLKSmnLeIuIz3H+6Jvjsd8wqyPlmKLaRjUEfwbyw8xvq6eNruysK6h1cG0zyIidf+T6fJL7uZxIsfDwsXdo+PESnsMwhsLoq7Zo02BKjrj+TTlgEe5NUJIpJoiwzPIZFH5vR9UJL70JfXr2U5BcHbn29SBnUmCfM2ooeaSmW3SPnKv+Di+yck0G8bSD9QPTSpl8hAifI1sNDys3wywIpvsGVyU107zw9TU4VN9vQeB9lOQdb6u2kGwEehCDpztMb2/d2NjUOe2BzUWF2WmMgN9yeu3hLNCyI0mTEe1T3SiTFiRftjLRqVroQu3WDEuGxtDNP6rMdZG0HIsDJlt9HWIBSmOFjHR44UOnG735V6k+9M4y8oeY536clpmi81ZiUeme5U1RTtXQLU+6aN+NZsw6saLRGYBAMARycARzbMulAGJlEgHo0YseqeSBot+fS3e7c/eN5jeig0RYs9CLjSBQt8931yQCxssIQbaRkd5lvjJW3w5uaUjAkuHgkpRCjuwOIsSIdGgGRGNQGwvgoQVx+wKXDHpGv9ea0gUIMID+584pQwr8OjUSspV7zBQleeiQKjVuw4TMnJTVnDwK3o9oG/NFcX4ZobRoKwQ6rTHce76rq/6T3GGnU6vORPZieY4yMk8a+gl8jOTxscpxi/gtinSH5EvqRM5h4ygZdt1xsXUXsm6ccwF9ZlWKZG781Sx2qMo33jhGhfFfINPyyw+b9cr2pkFcTWJujho97y8Lg4DFldBRPRzBZvb5SDDwQ
 jkVAbl6g
 ys8OkfH6rw8lDHTPhzsBjxb/WrX7HCtYV7V3MfyU1I3yhskcvCscFwUHVusx+bWDAORr+1ikKDk7G4+Et8bzQPMciVQyI0j4XVhxKOrjLOzG3rp6+fJ14y0mLW+/nmwNblyQdAr8PmenO9Pr8Q9PDYKbcO+r77z8NrMXPTQLJSRO3Nf6qsQpSr6FWU0UdBHWJRvQ6ZaOd45R02qmPKYU1vwd+JWV9M21FKfLbXTijP7mRElFavWMr/ZjoMNBRq7n/jjxb6OWA9s+2UiB1hd0a2quRTfxnPsDNVBYiqAYxR5ZzwABNw/o3BqA7knnWtAs0HgPssvug8jvFMr4HQ17HNs6U74yaVwls140ArTEuQoIg90MkVp8XIy8BTG+OPpt0+uQ1wK7cUG6MNhrn5nt9REiZCPqkeF/e8TGiiTBkIktJpo9ThNUrAMvWOmm9+09ipPN/ip18AdtPFdmTJoNAttSUykxPoKFxzvjb73R/fpaxnrg2NKPlY2COOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 10:15=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/19/26 6:06 AM, Barry Song wrote:
> > On Tue, Aug 18, 2026 at 8:49=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wro=
te:
> >>
> >> From: Hui Zhu <zhuhui@kylinos.cn>
> >>
> >> The legacy path throttles direct reclaim in shrink_inactive_list()
> >> when too many isolated folios pile up, but MGLRU's evict_folios()
> >> isolates folios without this check, which can lead to unnecessary
> >> swapping, thrashing and OOM.
> >>
> >> With the NR_ISOLATED counters now updated in evict_folios(), extract
> >> the throttling loop from shrink_inactive_list() into
> >> throttle_is_throttled() and reuse it in evict_folios(). Since the
> >> type to isolate is unknown until isolation and isolate_folios() may
> >> fall back to the other type, check all evictable types with
> >> for_each_evictable_type() and throttle if any of them has too many
> >> isolated folios.
> >>
> >
> > I feel this is unlikely to work. MGLRU behaves quite differently from t=
he
> > active/inactive LRU, and its `NR_INACTIVE_FILE` accounting is also very
> > different.
> >
> > With the active/inactive LRU, shrink_inactive_list() ensures that we
> > always have an inactive list with pages available for reclaim. With MGL=
RU,
> > however, a generation can legitimately point to an empty list, so this
> > assumption does not hold.
> >
> > try_to_inc_min_seq:
> >
> >          /* see the comment on lru_gen_folio */
> >          if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
> >                  unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;
> >
> >                  if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FIL=
E] < seq)
> >                          min_seq[LRU_GEN_ANON] =3D seq;
> >                  else if (min_seq[LRU_GEN_FILE] > seq &&
> > min_seq[LRU_GEN_ANON] < seq)
> >                          min_seq[LRU_GEN_FILE] =3D seq;
> >          }
> >
> > At that point, we have no inactive pages for the type, so the
> > throttle will take effect when the following condition is true:
> >
> > too_many =3D isolated > inactive;
> >
> > With MGLRU, however, we can still fall back to the other type even
> > when there are no inactive pages for the current type.

Hi All, that's a very insightful concern.

But on a higher level, you can fall back to the other type regardless
of the LRU? That's not something limited to MGLRU I think? I mean
throttling on one type seems like a good idea if the other type is
very reclaimable.

>
> Yes, that's a valid concern. So I think we can check the isolation of
> both types for MGLRU to avoid this case:

...

>
> The typical 'isolated > inactive' case is that we've tried our best with
> aging, but cold pages production can't keep up with isolation speed,
> especially under concurrent reclaim from multiple processes. In this
> case, I think throttling is reasonable.

Just an idea... How about we simplify this: just check the isolated vs
total memory size? At least for MGLRU. MGLRU maintains NR_INACTIVE_*
only as a compatibility shim for reporting meminfo, so it does not
track the immediately reclaimable set the way the active/inactive LRU
does, so the inactive value is a poor trigger for MGLRU: Aging moves
the folios in batches so anonymous reading can be very jumpy. For file
folios, PID can only promote unmapped page cache to the second oldest
generation, meaning most file folios are considered inactive. This has
been causing trouble for our dashboards for a long time and I think we
can fix this by using the tier number intead of gen number as the
inactive / active reading, that 's a different topic though.

And in fact I don't quite get why classical LRU only compares that
isolated number to the inactive count only. The reclamer can move
active folios to the inactive part anytime, so throttling when we are
low on inactive doesn't always seem like a good idea?

I remember this was discussed sometime ago that in the long term we
might better throttle it in a different way, it was once mentioned by
Shakeel:
https://lore.kernel.org/linux-mm/ahncWUAJlPZhNGr8@linux.dev/

So perhaps we can throttle MGLRU more gently? e.g. just compare to the
total number / MIN_NR_GENS, which means half of the memory is isolated
for MGLRU? This doesn't look too pretty but I think it's better than
using the inactive count for MGLRU. And if we introduce some
gen-balance-based aging (whether that is a good idea is also another
topic), the ideal goal of MGLRU will be evenly ditribute folios among
gens so the current inactive reading will always target half of the
total memory.

Another thing btw is that the function name throttle_is_throttled
reads a bit strange to me :)

