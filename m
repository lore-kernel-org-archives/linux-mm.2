Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700D3D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 04:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B2D56B0006; Sun, 14 Dec 2025 23:39:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964646B0007; Sun, 14 Dec 2025 23:39:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852E26B0008; Sun, 14 Dec 2025 23:39:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 720F16B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:39:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 052B28B5D3
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:39:19 +0000 (UTC)
X-FDA: 84220451280.26.165C702
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1DA8D1A000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:39:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SD/cGUbx";
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765773558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQRj70BL6HQRPreuofgc3v+2d1xacOZWICz358lnnGI=;
	b=LY1daEZe2AWY1ljFjfV5p7/cJnlkTGFLf7Twu/Tg6TlscSrT5ORA7Io3H54TyFOYx5Kb0R
	VVVf0xtr7qau1vS7CTpZ6SRSpjR7z1iDLWhNwfDahF8cGXFhN5ru344zpIE0ZqaSFMayXT
	UvIWq948q+LHA9rAeUtdCkzoeMi2G7s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765773558; a=rsa-sha256;
	cv=none;
	b=nIzhElFraSRNrqyauQ16ClCqJEjZnXp2/vF3cl7dWvBUJIHb30HrgwuCU4sxSAMs+972D+
	H+EudASn6QWeghPW+2sc8DehlKvpDB98OTxpmr7uTrfUEj0NH+KJXVPxpYIy9/P/FXYIPW
	JDRuiiVAFpGxPRGPbyaJygaNImgoqgs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SD/cGUbx";
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6492e25cd7eso418095a12.0
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 20:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765773556; x=1766378356; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQRj70BL6HQRPreuofgc3v+2d1xacOZWICz358lnnGI=;
        b=SD/cGUbxO2isghFeJ3HX4NUFQ38OVxv4x/zThkikYrEeyGqqxQVk/BumTg0I5dc16h
         IDfzrtsx0z1NXd2TLS6JHRShAyxyUK2vWv5Wd/NYC4embleg7rtlmuImMLDKFI4Z6WN3
         joswxUtD0jn2ff1niCEgfEKfgOo5vE3P70a8nQRaNDSBpNC1uLdOzTVjV9h9xxK1Wp6K
         APQBDV3LVQ2Eji8iATEH/vJHf69ROzYUVFgzcrrBc+P/EiIkq29tzSzL2C1t42xh8XHi
         AWx4DhaSnZlsHDx0W8IJfXA6v6JsJlJefVIwQn/LpqAKxvb40NZh+nfeeIQ8pwduQ8/O
         mzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765773556; x=1766378356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eQRj70BL6HQRPreuofgc3v+2d1xacOZWICz358lnnGI=;
        b=eeHBjJO1F0LNTEDnBrpIssC69KGsM/IKu+XtzW84X5eSi4/ru2EyuxmcRbiULktA8s
         X0skSxxzP2huS6gPYrb87Qz5VXM3NtjViccDpkm2ciN7CJzZsBU5MpkmZZ38dYgIlbwY
         xO/5NQfVghj5AaEa5vj37GdUAX8u39EzcvEPz/PUIN1eLPSEnnFeLgFssDP5bY7reFPk
         hRvu/RWUsRU3R08yhZlz8zI+fNwRdVcPv1pI3lMDEQg3DEfEVrjpKkHNTKGfrh4+Sic+
         Zvd5tUNsZsJK0uoxPGIHjyEdcWDoJC9+Lza3TKwIWbwicQR5wDYYd5QOxX7vhWL/S7Kq
         IlLQ==
X-Gm-Message-State: AOJu0YxKEHBZ3zMEa9k8e57W9F9QvSJKcKJWI/JgACnWMBIy68MG88BW
	A6Qnq8PpCuSdkUdSUlWxKxL1HceZk8oKVk78GnQoKgUg7cb+3yutux+6Hg9JHCst4bT6Nxy7ReG
	CuWP+YA0A0AeVUHvgXONmWGbmjOlSBl4=
X-Gm-Gg: AY/fxX5/uNzshraJbqjZCKdI3nGjEnKTiR7gozq0NEVbw+LHtfQ0Rjh0uW0icT5NlvH
	JcsUQrw0UhQKBqZvYDF9HICIQs1jkI+I2sVyvYOkXXkcSblGozYAhz+n88ME61UVfmtyLn55CRz
	Mj8yy+SAe0UdGnFycBeL4pnaVnycwjXYONHnI9YQCZn7ksi3PAyRdLQMDrxoQko5eVMJ+RtdUoP
	qcTd89QneUTqZcKMasuyIjJreA8LNmk46zneQHOZS74V8AEWKUfjnXYllKVbyWanxBke1vyjIvR
	33Fn4VJzvXfx51faJSjw+dKIi9c=
X-Google-Smtp-Source: AGHT+IEtZZfn2FvmMY0KSmTUyyjHm5HxrjH9Mb8u3k1V1sCumY6po2lm7h6LyGvYreJJH+u5rAm3LlvCjbvUv/IoBCE=
X-Received: by 2002:a17:907:3f87:b0:b71:ea7c:e501 with SMTP id
 a640c23a62f3a-b7d21664a0fmr1227141066b.4.1765773556185; Sun, 14 Dec 2025
 20:39:16 -0800 (PST)
MIME-Version: 1.0
References: <20251205-swap-table-p2-v4-0-cb7e28a26a40@tencent.com>
 <20251205-swap-table-p2-v4-10-cb7e28a26a40@tencent.com> <aT+KvZplFPimgStY@MiWiFi-R3L-srv>
In-Reply-To: <aT+KvZplFPimgStY@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 15 Dec 2025 12:38:39 +0800
X-Gm-Features: AQt7F2rnzM7yovkjmHUWcIaJBeoPNUVPI-QXKuByg08lLH0L3hhjvqo-9B-3SgE
Message-ID: <CAMgjq7AKe09wKEeD9uf5_EuLBLMRoV=Rt+Vp0PU9-b5Jmp+1TQ@mail.gmail.com>
Subject: Re: [PATCH v4 10/19] mm, swap: consolidate cluster reclaim and
 usability check
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ridx7iiond6sc5fagrdqcwzkkxe7yusd
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1DA8D1A000C
X-Rspam-User: 
X-HE-Tag: 1765773557-630652
X-HE-Meta: U2FsdGVkX1/MlQ3sP3C6+H+/5Mt+G8osajJ2V3EyFwc4l7wsTI8vCuliVh7jdBjtzZk23HJJCQCrRRGmQq3bu5EEaXrKL6Rry4OFkvwieRztbEE1GnNhfjLackGox6BsrATtUeLFHw797ybkLXF7VoIWy9m2ELz4DT4Irtod0C2jem04pznzhRpg0Etem7va913BCSxAWNjbTu5K1ya0/GjiOLztbJcqTOiSrJHktCea+1fedlg9cDJAkBnqImCo7dsbkq/AgXOpj2HVgoyGsPcwE2VX8txoEYFHEMLJDlyIAmtlNDWfAS29rn+04DGwEijF4phnmxTGhK1wqFEgVaHnK8bdW40Hdc9XtelndpkzZ9KJkM4mPqNMCnE87K/YUlIG7U0eCPrUibZ5s5ljE1so0Oz/ErLU0D30u43bJnmD9U+CkYV0e9J4UzLd6yHjOFBwVG0/qacYZwF/koIyqqPBOgxAFhZpt5LowGp5lZrfJzZy6a+HdzQDfQCTYX64/hPxOkw9Ka3ZO/SrTHhHVRiHvwpOWMxFGkB2KjZswQ9xhbNimX1cXCQazPnW8YinkbJabGtKk+zRH7FVH0DcAJTeAY/72VUNES8qxS7V3USYarAbt4ZRX584EX5BJ/qQ1Xyrvb/d2s/pJTEhMuMeL02J4yTKuMlHaACoCFEnSH/Z5PxDh1pxbJwlA2I3lmHIPbVED514vxvFwubecVstcnAIVowfPpAxfl2Bk/dEXu0MavpbZl16OvKPurotKUrFwh67gjkOkVpFSRTx0LrtYoI9wZcl2Lgw1w8b1QlT3577L++93rU5+VHNzhPpHVn9lPNSjTo2BBFp5ad/gJE+msarDVTebpQ49IDkUDGz2R6/2SGExWpIATT3v4iyWU1ZuNmOF6ILGXE+6K8TXj8GzIbh4bAgTgQXjJomdaEvWp7ErmDEQnMq0Vt0n2Z1SrDB0bZjlP43L4Jh9DUpzjr
 v71Q0jE4
 XNRD4wQS7U1z+AveO41oFjdghgscLAYD7YSvsZ/mzVN0qDxR2oVyy1Edw81Wxdm9sxxR1qbCWHU8e6NsCirT48Lc7jktssNjmjwlkxPDmsNxIslYBU9r5DH1RKe76TRBCPwSEdZKcUn7CcCRa8qPInshLduajAAqvi+CfbPrPa5XFTGkMtrBrvBh7XAFba8GeIgApCxGz2hQu24JlmsguMQVrliwicj515DE6aFef2o7JwrBm6XbFJ3YfhXzOoL8CVYD1OMBoNO0W5AG3hmYc7fUWkOAFON6xau5soVKc4rcPze/HfXwDPKKV6lvH8gbbFdczTSurKFFIAp8tbikLHfsXe3Au6mQfRTz6gaVaGR0mGLTfsrFTdmWroKMc/6ay3AYqQbSi7Br0sP0NUXbbqTtJOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 12:13=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 12/05/25 at 03:29am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Swap cluster cache reclaim requires releasing the lock, so the cluster
> > may become unusable after the reclaim. To prepare for checking swap
> > cache using the swap table directly, consolidate the swap cluster
> > reclaim and the check logic.
> >
> > We will want to avoid touching the cluster's data completely with the
>      ~~~~~~~~
>     'want to' means 'will'?

Sorry about my english, I mean in the following commit, we need to
avoid accessing the cluster's table (ci->table)  when the cluster is
empty, so the reclaim helper need to check cluster status before
accessing it.

>
> > swap table, to avoid RCU overhead here. And by moving the cluster usabl=
e
> > check into the reclaim helper, it will also help avoid a redundant scan=
 of
> > the slots if the cluster is no longer usable, and we will want to avoid
>                                                        ~~~~~~~~~~~~
>                                                         this place too.
> > touching the cluster.
> >
> > Also, adjust it very slightly while at it: always scan the whole region
> > during reclaim, don't skip slots covered by a reclaimed folio. Because
> > the reclaim is lockless, it's possible that new cache lands at any time=
.
> > And for allocation, we want all caches to be reclaimed to avoid
> > fragmentation. Besides, if the scan offset is not aligned with the size
> > of the reclaimed folio, we might skip some existing cache and fail the
> > reclaim unexpectedly.
> >
> > There should be no observable behavior change. It might slightly improv=
e
> > the fragmentation issue or performance.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/swapfile.c | 45 +++++++++++++++++++++++++++++----------------
> >  1 file changed, 29 insertions(+), 16 deletions(-)
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 5a766d4fcaa5..2703dfafc632 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -777,33 +777,51 @@ static int swap_cluster_setup_bad_slot(struct swa=
p_cluster_info *cluster_info,
> >       return 0;
> >  }
> >
> > +/*
> > + * Reclaim drops the ci lock, so the cluster may become unusable (free=
d or
> > + * stolen by a lower order). @usable will be set to false if that happ=
ens.
> > + */
> >  static bool cluster_reclaim_range(struct swap_info_struct *si,
> >                                 struct swap_cluster_info *ci,
> > -                               unsigned long start, unsigned long end)
> > +                               unsigned long start, unsigned int order=
,
> > +                               bool *usable)
> >  {
> > +     unsigned int nr_pages =3D 1 << order;
> > +     unsigned long offset =3D start, end =3D start + nr_pages;
> >       unsigned char *map =3D si->swap_map;
> > -     unsigned long offset =3D start;
> >       int nr_reclaim;
> >
> >       spin_unlock(&ci->lock);
> >       do {
> >               switch (READ_ONCE(map[offset])) {
> >               case 0:
> > -                     offset++;
> >                       break;
> >               case SWAP_HAS_CACHE:
> >                       nr_reclaim =3D __try_to_reclaim_swap(si, offset, =
TTRS_ANYWAY);
> > -                     if (nr_reclaim > 0)
> > -                             offset +=3D nr_reclaim;
> > -                     else
> > +                     if (nr_reclaim < 0)
> >                               goto out;
> >                       break;
> >               default:
> >                       goto out;
> >               }
> > -     } while (offset < end);
> > +     } while (++offset < end);
>                  ~~~~~ '++offset' is conflicting with nr_reclaim
>                  returned from __try_to_reclaim_swap(). can you explain?

What do you mean conflicting? If (nr_reclaim < 0), reclaim failed,
this loop ends. If (nr_reclaim =3D=3D 0), the slot is likely concurrently
freed so the loop should just continue to iterate & reclaim to ensure
all slots are freed. If nr_reclaim > 0, the reclaim just freed a folio
of nr_reclaim pages. We can round up by nr_reclaim to skip the slots
that were occupied by the folio, but note here we are not locking the
ci so there could be new folios landing in that range. Just keep
iterating the reclaim seems still a good option and that makes the
code simpler, and in practice maybe faster as there are less branches
and calculations involved.

I mentioned `always scan the whole region during reclaim, don't skip
slots covered by a reclaimed folio` in the commit message, I can add a
few more comments too.

> >  out:
> >       spin_lock(&ci->lock);
> > +
> > +     /*
> > +      * We just dropped ci->lock so cluster could be used by another
> > +      * order or got freed, check if it's still usable or empty.
> > +      */
> > +     if (!cluster_is_usable(ci, order)) {
> > +             *usable =3D false;
> > +             return false;
> > +     }
> > +     *usable =3D true;
> > +
> > +     /* Fast path, no need to scan if the whole cluster is empty */
> > +     if (cluster_is_empty(ci))
> > +             return true;
> > +
> >       /*
> >        * Recheck the range no matter reclaim succeeded or not, the slot
> >        * could have been be freed while we are not holding the lock.
> > @@ -900,9 +918,10 @@ static unsigned int alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
> >       unsigned long start =3D ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
> >       unsigned long end =3D min(start + SWAPFILE_CLUSTER, si->max);
> >       unsigned int nr_pages =3D 1 << order;
> > -     bool need_reclaim, ret;
> > +     bool need_reclaim, ret, usable;
> >
> >       lockdep_assert_held(&ci->lock);
> > +     VM_WARN_ON(!cluster_is_usable(ci, order));
> >
> >       if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
> >               goto out;
> > @@ -912,14 +931,8 @@ static unsigned int alloc_swap_scan_cluster(struct=
 swap_info_struct *si,
> >               if (!cluster_scan_range(si, ci, offset, nr_pages, &need_r=
eclaim))
> >                       continue;
> >               if (need_reclaim) {
> > -                     ret =3D cluster_reclaim_range(si, ci, offset, off=
set + nr_pages);
> > -                     /*
> > -                      * Reclaim drops ci->lock and cluster could be us=
ed
> > -                      * by another order. Not checking flag as off-lis=
t
> > -                      * cluster has no flag set, and change of list
> > -                      * won't cause fragmentation.
> > -                      */
> > -                     if (!cluster_is_usable(ci, order))
> > +                     ret =3D cluster_reclaim_range(si, ci, offset, ord=
er, &usable);
> > +                     if (!usable)
> >                               goto out;
> >                       if (cluster_is_empty(ci))
> >                               offset =3D start;
> >
> > --
> > 2.52.0
> >
>

