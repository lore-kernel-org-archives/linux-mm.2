Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61048C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6F56B00A9; Mon, 24 Aug 2026 12:09:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197B26B00AA; Mon, 24 Aug 2026 12:09:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086E96B00AB; Mon, 24 Aug 2026 12:09:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C06CC6B00A9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:09:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D4331C009E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:09:00 +0000 (UTC)
X-FDA: 85136646840.18.4CA9E53
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FE34180002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:08:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XweOYh+1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0W5q9JFccKIuoTxyIlvb1CNjf7arEqYMbmUndz72Edg=;
	b=U266/pz4eIaSz9djXFysEqrgQ8MZ4L9hFOCUPJJ1YpL5ewhKlKnQ6j9mT/glQYHwaMwd3s
	bWG14Y3xWrvIuThKRtJzQKApvb32Locm6IBPU0erh0Ksv6XfRnBY+U1CU5+OMLucjipOKW
	FdGtws0dDEVsPB5+vp3iQC6scmSLbKw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XweOYh+1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787587738;
	b=3GNx1uJvpbgyxkq31VCt7Zsq/W/4sDA+D71ZRDzl0pXhQzY9zUGCuhMhiB4gR87g/DFjJC
	/0U4Re07h0HcukKxxP0Qh137O/eVTbpy94OXfr8dzAOKKTEFaLxwsbQjuJQtJVWaT28eLD
	BLnWJfW2w9D9anxqiG07mCBwjToBa2U=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a17211b9ecso9172718a12.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787587737; cv=none;
        d=google.com; s=arc-20260327;
        b=VLclTVOySi+KP8GOwF8C0yk7th0HovFaSPgsfq9UFe9pMAnVHcSlJFGsQ1Ya/gDBXq
         YAsvfEZEUDijBA4ZPPhaBMLxrQM347rHTEJ76D6cFUhxtDjuAiDl2y1QojMDBtGuXuRR
         4WZul/9fwmSTrPtAZ17fa6YaiJemrjfMLZaPq44VMnVx8m4zal6vAb5w9QQ4Z1MsCxB9
         GYEbZLyqYyFHQZQV2Z3w1mfVaHf5Lf3lVDcqXFbkcXArRz1Pm5eJ09t7lsoVJ9CGWanq
         N/UM/yNNa/xIJYIV8ip6IZrI/LS47IhD37U1yJG4aJm2wc8GV2wQv/sq4CYKcNFFN6ZS
         eBOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0W5q9JFccKIuoTxyIlvb1CNjf7arEqYMbmUndz72Edg=;
        fh=t41BUnKVWHoZT11klZKEDHtWY/jwH4rIUjtcvl+Ye38=;
        b=ccJnArg9QT7niz8nfYjzjqcGK5NMFu1dyDY6FSZlT6Jeh7q85WzN06uRVtB7RfIkVy
         k5gvKJPpEbUBMT+nCsf9/lK3naIGH6c7IVVIAw1KtVn4vI4wNQnocfzvy6QJy4VZ5JRB
         x076g3TaATlXap5uL/iPAXHzwNEkhOUAr6QSP9E05rq3rf6Tjl7LN2WGwHPhTmRUjSur
         yzbCs3JS7VUsX8HauFmuAiBt9tnjseGFAd2Xl3K/WlJreOq4hu2mf0BZ8CDDG8jb3YQr
         ukf0AHxfSD9Tj/yF+zyEpPQRXQVerKnDScrbNlDJ5bKm1rmy6Z+Dj/z8eYEXkBsc+p3O
         EyTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787587737; x=1788192537; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0W5q9JFccKIuoTxyIlvb1CNjf7arEqYMbmUndz72Edg=;
        b=XweOYh+1tNeAa84xWxCLUXicMtgtsMu6SopgTzKYyJpT5sCxLr+GuZGw+dhDEfmYWU
         9o6tBzHr7t6bnDnefPbJlIKdSYmDeUaYTWHpuIi0UNL3VSLQaJzmDUVjSTHtXS16LeVw
         t9YwBPx5Z/E4T/4MnOIgPA8xsBY3xtgzGbNGHqsomZ+xXWutGIYw+w/X23yTHhLgBoyZ
         aWA9gTxsroj52bDqQRsV3xCKpCKkDEca+dyWbswyHMqxQmEYZu6gPqxk83/M39G2E+BA
         Z58Zj/auH7XUf3b8oBXBLIFCb15SxTOcwuFmbdaFkdxC4AfHVgbqIDg8wEE05ogROuTo
         /V+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787587737; x=1788192537;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0W5q9JFccKIuoTxyIlvb1CNjf7arEqYMbmUndz72Edg=;
        b=jKPSYw1FTX9Xb99cqDQBnSvtNRoG7T3IQ77v5ozfFc4MM4DhNTzBkmP5AtgY3IU5my
         HOvm91x2j5iSF/qw+3/2rVFf6DknqPjSRcHIc/5O4QDIok674+ioIfgYtbbg1EnF5i8P
         Atra2Zekx7+l2H5jcqQVvkmEmWHQIW5tDHRatfgwS1rSNSZb25YGjRhe04MobuAJLoU0
         6vZDYF8xmkM+T089eJaviWjxB/dD9My10wNO7d4WbsDVPxjo0c2KpRmpzzd9Y5W5bfod
         TWXbJYi3IOcC8QCbu5Rw4AKC0fqNHXUMrFIKlnSSLUxm6zRBkSZqh1SFruyBlHiV7rQH
         RHUQ==
X-Forwarded-Encrypted: i=1; AHgh+RpFj0g0Kb/j+10+aDn2DKPFNtrhXttxTshIRIeY40Z5l2t0M6McsVU6wlziuYbauR3yl0I0/sRDmA==@kvack.org
X-Gm-Message-State: AFuF++k7mF5muC0Ah0lgWtFXVLqfNTF9/JGNHnsD04vNiLpi49HJjnsg
	CuulLC1ajqRj2uNFNFaSO/2IYiDjQKAwDBLuy2Gf3r7zeY7Ja3z6Do89KmRHaMsSujUT0Er+5Ie
	unbqC1Ia0XdChsGJLCDC+qosP6tTSQ+I=
X-Gm-Gg: AR+sD12K4O6iM0rgehCP28bD8VgzD6D2NKK2vF9yFike5krG0wGgacLjZj7ST632zYb
	ujYtF01iHAz2xOhof55KhvXVG/M/Gs2d6/GjWdKhmTARZhMTMOzqDbGIrfyDma3yhTE/C+K1fmL
	FuhuAZ7W8LqhQ6QxgoTCdo2blQpG28wPJv5z5e5UgSDNP1CKIdDR1haKGirl40dRn7aWuvK/o1c
	674AwaZAXtodM2Oc0PQ8zkJBnohV6iFOyM2cviZNSec7dYCv1UAoKaQqMJYnsiUJ8bP+1P5iSDn
	MNSawKFKBhEKwHSpKFLiIjq+x08yePqR96ED7KIIqnLiDA==
X-Received: by 2002:a05:6402:e93:b0:6a0:584f:454c with SMTP id
 4fb4d7f45d1cf-6a42f28ebaemr31545775a12.16.1787587736646; Mon, 24 Aug 2026
 09:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-3-nphamcs@gmail.com> <20260820041940.443214-1-kunwu.chan@linux.dev>
 <CAKEwX=Mj7QVArjKVvKOKnuQoTmN1Wu=vXe4jkLshnzKoYF4XkA@mail.gmail.com>
In-Reply-To: <CAKEwX=Mj7QVArjKVvKOKnuQoTmN1Wu=vXe4jkLshnzKoYF4XkA@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 25 Aug 2026 00:08:44 +0800
X-Gm-Features: AcwNN1UwGPQAC4xmpw6qspF5xlvAI6xHm0KWte_rbifou6WEZwEBSX5eypRKXJ4
Message-ID: <CAN_Opa_o6y7LnRNF0Ow66E99QKkvdo1iV3fbgk5YCqtcoFa66Q@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, 
	david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com, corbet@lwn.net, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8FE34180002
X-Stat-Signature: gbyamqmy5qynatr3pjheebm9m3m77xyi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787587738-795776
X-HE-Meta: U2FsdGVkX1+PrZmLRiZ/xLEJW1tLhSXvMV34VQiw2PceCe7e0MPXzr3NChRvim1JkCHf/HN9fo0wIoKCDDMUSh9cObhgaN5kOb7cdEl7QJG59qjs+/4jTRhzLu8zzBK7Rqj5YBHTgn6YBZGBXrOnoKS4+x9r1BMxvgr0Bc6awulOL25WVeoS2PfZHhDiuXqzcvcbfmNcP2+UuUGto60Rthtd2G4PzHHYrZ+/obNB0ebrk7Tns5CX2nuWoLv8M1xm80zWgljUIYxbIxJSkKpiOWp1buHNGMAZiBYRtw0x0cGyoh+Uv/WLC+BZ7+4yFJTuuBEFGd25k65FZH2Zc3oBllD349FVcgKIWYqM9/bH7Qb7XM5hDmYsaxDVUPYQFL1VELH0UrEOCE5TFFtnOThf32HE6pWvaG/SvxNcY4KJI3MsNMT4UCu/tqbGZoVjTY31r2VZCzAi3RCrzCNBGVMizCeAiwfwAPKehpQ/pjSzEUUy3K69msrTXX9oI64LPYKaj3n/d1JuKzFLoRR3SiT8Wq+vHMh1RPU5bZSa7SlM8aM2J+vCHp+PmK+Uml7mt6etCtne2I3NgM4/Ml2BFTTx8ukhKPpLJhSQv/WZ4mCqOJaRWqLugNVj2nZJVvu4wOTcbE6pOZzDxkU4npm+OshGpjeNVR3yq5/+c+2BuebiKaXoF+icD40ZVy/tnZwQ3THzjoZ1NSDVBz1L4BGCk4TXuokwhWy7Tz0D+xbHfXqPPamCuBkRm2Fxvp68GDLfzdUWXCo0w5jR6rf1VIrZ98UFrK9I9xY7I5fxybsXkBcTx1DCrX78VR2yizhEWotU/8fU5AyOCSsQhYhjhXTLk486yoqzLCn1WH5H8vXoTNen0YidDMA+6CfL+4qOHL6lZdbVER4w3qk7HLc1NZudUlclL55GaH/V286mPwCsHzDUXFT3XU3G5rlDoW2z/IR0By95rA+HfEudWn3OrdaolcP
 B2CDfXOe
 +oTsHy86r38D3uPmlW+PO8ZiYbdaR2Gm48dgl8VcAhFa68oLXuluLd5QrZnPi35HvBE13KDhc+V/dJ8QkMfiwKCqYK6gSX8jEEUcS2BGvg/HsyZ+lZwENLO0i4/rQQPHvEsoWofOQAVLT1T+lyzkLLfFrRHhgJiUCMKmn5gEy7Er4PIlXMzj7F10p9BM+kRMQe0QzdlMhi0mF9s0UTZsJUi0iip3TVmQKkO4RGzEsDZvWzkq/DMxkrvvaWYXd+MBQqPOK3Wd/Pqbzj52a3qQYdP4+iw9he0D3qsT5RGpH7Ub2g/P5ZyoyYD8B8sem6I4zoK0cMGGfFOLP6JUOzmgcwqfqwInBoEcrjnZXkb/QBRFOd4TfqWPHduYFHAcUxBY7tRiA8rQ/f0gqigNQHz62bfsbsUEGE3j/u4nOFvRgWiubU5EkNv+fpQsz2s6haiqUfBRuhX7Z1V9v8UU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 1:09=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Aug 19, 2026 at 9:21=E2=80=AFPM Kunwu Chan <kunwu.chan@gmail.com>=
 wrote:
> >
> > On Thu,  6 Aug 2026 11:42:45 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > Hi Nhat,
> > [...]
> > syzbot reported a NULL dereference in the v3 series:
> >
> >   __vtable_get()
> >     vswap_to_phys()
> >       swap_entry_backend_has_flag()
> >
> > Seems like the underlying issue is introduced by this patch's
> > `virtual_table` lifetime management.
> >
> > This patch adds:
> >
> > > @@ -70,6 +70,7 @@ struct swap_cluster_info_dynamic {
> > >       struct swap_cluster_info ci;
> > >       unsigned int index;             /* for cluster_index() */
> > >       struct rcu_head rcu;
> > > +     atomic_long_t *virtual_table;   /* Backing pointers for vswap s=
lots */
> > >  };
> >
> > [...]
> >
> > while the read side does:
> >
> > > +static inline unsigned long __vtable_get(struct swap_cluster_info_dy=
namic *ci_dyn,
> > > +                                      unsigned int off)
> > > +{
> > > +     VM_WARN_ON_ONCE(off >=3D SWAPFILE_CLUSTER);
> > > +     return atomic_long_read(&ci_dyn->virtual_table[off]);
> > > +}
> > > +
> >
> > `atomic_long_read()` only makes the access atomic; it does not protect
> > the lifetime of the allocation being accessed.
> >
> > [...]
> >
> > > +static inline void vswap_cluster_free_vtable(struct swap_cluster_inf=
o *ci)
> > > +{
> > > +     struct swap_cluster_info_dynamic *ci_dyn;
> > > +
> >
> > and frees it synchronously:
> >
> > > +     ci_dyn =3D container_of(ci, struct swap_cluster_info_dynamic, c=
i);
> > > +     kfree(ci_dyn->virtual_table);
> > > +     ci_dyn->virtual_table =3D NULL;
> > > +}
> > > +
> >
> > The existing `ci->table` already has an RCU-aware lifetime: readers use
> > the corresponding RCU access rules, and the storage is not freed until
> > after the appropriate grace period. `virtual_table` introduced here doe=
s
> > not have an equivalent lifetime rule.
> >
> > The syzbot crash shows that the current teardown/read-side synchronizat=
ion
> > is insufficient: `__vtable_get()` can observe a torn-down
> > `virtual_table` and dereference NULL.
> >
> > I don't think a NULL check in `__vtable_get()` alone would be the right
> > fix. The NULL dereference is a symptom of the missing lifetime guarante=
e.
> > `virtual_table` needs to remain valid for as long as a reader can reach
> > and access the corresponding dynamic cluster.
>
> Thanks for taking a look, Kunwu.
>
> Null-check by itself is not sufficient, correct. But I think a full
> dance of: rcu read section + spin_lock + checking for
> CLUSTER_FLAG_DEAD should suffice. As long as cluster is valid inside
> this rcu read section, we can get the lock. Once we have the lock, no
> one can free the cluster under us. and as long as the
> "CLUSTER_FLAG_DEAD" flag checks out under the lock, we can exit the
> rcu_read_section(), and proceed with reading the vtable. I already
> fixed this in (to-be-sent) v4.
>

Hi Nhat,
Thanks for the clarification. That makes sense.

I agree that the NULL check alone would only mask the underlying lifetime
issue. I see the lifetime dependency now: virtual_table is protected by the
lifetime of the containing cluster, rather than by an independent RCU lifet=
ime.

> Note that this is actually only required where we don't have any
> reference pin. One example is the one syzbot detected phys swap device
> backend flag check, because at do_swap_time() we don't actually have
> any reference pins. The PTE is not locked, so swap entry can gets
> released underneath us. But if we have a pin - for e.g if we own the
> swap cache folio, then we don't really need this dance.

I also understand the distinction between the unpinned path, such as
the syzbot-reported physical-swap backend flag check, and paths where
we already have a reference pin, such as owning the swap cache folio.

I'll take a closer look at the v4 implementation once it is posted,
particularly the lock/CLUSTER_FLAG_DEAD ordering and the teardown
path.

Thanks,
KunWu

