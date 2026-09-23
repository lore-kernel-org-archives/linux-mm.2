Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E675C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E24A6B008C; Wed, 23 Sep 2026 17:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9926B0092; Wed, 23 Sep 2026 17:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEF56B0098; Wed, 23 Sep 2026 17:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 150166B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:25:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97C581C0860
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:25:05 +0000 (UTC)
X-FDA: 85246307370.15.8B2168C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 112E6180005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:25:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZnJR/GQ0";
	spf=pass (imf24.hostedemail.com: domain of agruenba@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790198703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FamOGz2XlQ4xC0lCyRvFWnDAClLJ38P0+XqqK7f7PF0=;
	b=pjiRZL60JIyXhNXGCKWI9Q35LtCxzHuVTJTznMTRG/lJvtBGxaOg7glr0jYo9pb3cNuOck
	xjWZutGgWfTPFZkS82UBgIekdd8WfeKvL/CKOyGkuzUa5+F0aQ6Y+Pmio/u8wWldi+MD9x
	g2n2Tq1t9At0BdiB/mHwwOTDUp7LuPw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZnJR/GQ0";
	spf=pass (imf24.hostedemail.com: domain of agruenba@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790198703;
	b=NUCGrmUrZYuRytGhlCcyStB1Du9Yzx6eR7wXFDDrazlnjgfZIKZ3nDAb+22JEERMlaUDOW
	VFQPE8jTMPDGs9x/RmYz5OSrOC77KgMMsAlKeFItO9Z+3PV09W49Nz6eripPwW2IiWwFKK
	OYa+tY/tCu2XGrVAyt1UBqdVbdTXJc4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790198702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FamOGz2XlQ4xC0lCyRvFWnDAClLJ38P0+XqqK7f7PF0=;
	b=ZnJR/GQ00PNkDw3WLyUCnIdVAt3vR/cB5XisAXYJH859akKhiqHpffjOjOPyjz5LtU0QBO
	D+dMC/7XZK8I/Uw2fVF4WD301VvBQwTfqoo2V2MBXUf5fB0yp1qAg6cohleA0Jupds90YR
	nyXWXCULGhwBb0ED4q35BR9/PuaBZ/c=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-kIB1QOJnN029MDoj7UUz4g-1; Wed, 23 Sep 2026 17:25:01 -0400
X-MC-Unique: kIB1QOJnN029MDoj7UUz4g-1
X-Mimecast-MFC-AGG-ID: kIB1QOJnN029MDoj7UUz4g_1790198700
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-671163d46bcso1890458d50.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790198700; x=1790803500;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FamOGz2XlQ4xC0lCyRvFWnDAClLJ38P0+XqqK7f7PF0=;
        b=Q6O8Vg0i0wmqOZZsyF6mwI5cmE7SCumaITE1W9dAx7j5WhEWCv5+YX+aA1WC7M02OO
         TVl9brM/qK9mxKiJly80hpH96Uxf8937zOrUg4saPpPo8ye/eqQMGah9A4w4ZxQjU1bN
         oGgnvXZ1AGdCF0F0gWIfBdruqRKNLF4/uYtGR0CtFp/wRwVs4KhGSKYFXR6qUx+NPl+0
         S26XS2L5Qfo7rMlhHIfZt6HoceIv4pDRZjlGZC1F5Th858/Lh2MvAwe4+NRGQEpQNb67
         h3FnMPBuuSFqijk177V/vYbsCRbnbkgBxMB9ebmCwYXJSVqCKDQXgAmnrlG2haad4+gl
         LMOw==
X-Forwarded-Encrypted: i=1; AKwUvBwHFvAxJnTcGcu2KDEXvv/go1RmxDGzvaY7SX7FtbUFffzakkj5iyg+q9zVMAuAk/iZPt1Y+oyeNQ==@kvack.org
X-Gm-Message-State: AFuF++nzYiJJ5/wXYbuMrF3rirrOhL8MjvwrT5dkRlIpaRTCLe9fw92l
	4NGWzicMMJrTYd6sr9IudCn4TowaM0VsxkmugDCgoEXpdXw4tr3qNGiaEpmYg5kZTHp1NGdoPz0
	rfnzENVnezohx6Mnm1YE0X99DLfJx+dkflMCA+oIWVh+9cTXAcqhkFsGRtkZ8c5ziC+QMO3o+jr
	bp3P8D+wlSrKBdA2h3zhMPMALsiJ0=
X-Gm-Gg: AYBFou1KuIdjhpQgYoAWE2NH9E+3Diqxq0ZYJ9Im7STchE8u6qi3coUlHdgnYi0Hbvb
	AQWUQtIBH/le4mIjH2OOv/j0eX0MgTfC8QBKZwfmvFwkiOMbB5iRBO63TYSCMOoPjjEtyVG9yaJ
	L7qTZPtdst83gxSMw27iNsi4O45oxmk+quUCIfhaeJYHYC4/qAVvOdRU2LdjxZNnSbBEHDkjr4F
	OLXHIiRHb5klgPM2H2XzVvWZjdfWdXFtw4pvwQY5SGaMA==
X-Received: by 2002:a05:690e:1486:b0:671:4cca:b8ce with SMTP id 956f58d0204a3-672ed341c62mr456309d50.61.1790198700223;
        Wed, 23 Sep 2026 14:25:00 -0700 (PDT)
X-Received: by 2002:a05:690e:1486:b0:671:4cca:b8ce with SMTP id
 956f58d0204a3-672ed341c62mr456294d50.61.1790198699257; Wed, 23 Sep 2026
 14:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260911081309.14137-1-jack@suse.cz> <20260911085142.1774803-9-jack@suse.cz>
In-Reply-To: <20260911085142.1774803-9-jack@suse.cz>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Wed, 23 Sep 2026 23:24:48 +0200
X-Gm-Features: AcwNN1UUNn7Z0AbdqvvAesVcD7LzQJPt6i69kIPsPcPyFL4ciR1XZGgS4-FnymY
Message-ID: <CAHc6FU6YT4EzM8VDX8V0+dhfRJtSrtWxbuwht+b8HG5yzyq7Lw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] fs: Add throttling to deferred inode reclaim
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Mikhail Rudenko <xyzzy@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7VjszRjly0kD199JrsCYMhh7Kesw3QzDKSYH_zwdPbU_1790198700
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 112E6180005
X-Stat-Signature: 75fmffmrt7spet71hgr4rbrd785ro7z1
X-Rspam-User: 
X-HE-Tag: 1790198702-625710
X-HE-Meta: U2FsdGVkX18fVESFiqm1C5Z7M/pviqbTNG9VSKXrBtqiy7c9DJOPv1egCVwoBAxzKe2/XM2no6DwYX0NjFXpdObqkvtoyltMEG3MxheALR0VIOX3wq8ZzQ74WuDnnVFyKGMLE8aC3XPdu7oNBrEpQXsKcWNF/0ftZzz+4LLgnpjS5jrItrBx2X1nFUhWINVNi84k9COf/bk5ALkIgONiT64rWzcoK4JNEAyGH5ZrFDgQdn+hdduZQVIRkf62jJW6yze9B3v60VyqUFKkK/cY2imtvOZQ3GnUKHH2PP2mhxLJhlacPx06tuDKJ7ZBZ7mmAjHXNFAsgMH37fBd5izOMnohKEXkwPEa/QRFmni1svHD98p6F02qeBS34+ZgcQ7HCxNv0KhQ3ka3HU0QiS8m3oue2z/LhxyUUFqo3N8nwYLxSA4l6ASPCrE4LU58Lbd2tCfHBoEbQv7dxMoRHDxXya1iDom0W3NzZoG4XdukRwuvR2PB66Z8cFqfj4X0zXpqALTIN1o0S1VieIDxMVk8vGTeFRbWxpjFvcKpyWrOxljMMF6sprHuRgdfasNZNwuLSW49QxKphV9EqvjW+Sw4eAmIXSxCs2MsSYweJn62WKIbmuXYZLquKNlV5JHXqGlBN5cxjQ5Nh3WbURy8J9f6gUZ5jrmrxh+gDLiFrgYhL2Bg+OW/U7cQ/5cK9tVfTuJ8QIpUHVhcoS/GANCNjSowxmub1yvMs0KQwrzvkjvpN165+Q/6Vd6n3r+oIk5IocecneLklpP/IJKotfl1PRKAAEiCUeBNXqY/ngLaMRXLX1YPQ973ClQVX+es2TYOuqIAa3ui2Sbw7fskdSpPoy1e3C8UQNMLQU+UepsBgl8Mi9GhOvf6k9DFBEgFrng0GkvQ4UGKTsqSSBGkT80rg+0wvteYGfhAXDrhQKEYF+VSYtvKGJlneWTlxcmNp2cubWLQQqrOw8kwKjkoJLsanDk
 uHRnCDvN
 lqQUOZ5/HC5fBn06569C+RMGe+xKf3nfAlNxMgROjmP1TUlnrBfm5sZjdO/gX3vv/Mn7EdkJs9fSIAO7OEwknl5zec3Dr5U6lWAS3j8xLhfvR3bAIiLG+Bo8UR4XytsXzhAkPCuYsiI/Q1warFXSZ8gSGp9XYQ0+HI9oS8X4YjpBdjugNNdI7Elsu0YjS69H0FNVCRD0AC5b1MJu3gHDvtXt7chg6QrE5B9Dwnw6WqfgoomS/jJzs/Tm2hUTpD3SW5Glt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:51=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
> Deferring difficult inode reclaim from prune_icache_sb() to a workqueue
> removes the natural feedback loop of blocking tasks in direct reclaim
> until they make space for new allocations. This can result in the list
> of deferred inodes to grow beyond any bounds and possibly push the
> machine to a reclaim storm or OOM.
>
> Add a throttling mechanism slowing down tasks in
> mark_inode_reclaim_deferred() if the number of deferred inodes to
> reclaim for a superblock grows over limit. We measure average time it
> takes to reclaim inode on deferred list for a superblock and block tasks
> proportionally to that.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/inode.c                       | 102 +++++++++++++++++++++++++++----
>  include/linux/fs/super_types.h   |   2 +
>  include/trace/events/writeback.h |  51 ++++++++++++++++
>  3 files changed, 144 insertions(+), 11 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index e902095cf39b..0491300c5ccb 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1113,23 +1113,53 @@ static int get_inode_reclaim_batch(int *id, struc=
t list_head *list)
>         return count;
>  }
>
> +static void inode_reclaim_update_stat(struct super_block *sb, unsigned i=
nt n,
> +                                     u64 start)
> +{
> +       u64 delay;
> +
> +       if (!sb)
> +               return;
> +
> +       delay =3D div_u64(ktime_get_ns() - start, n);
> +       /*
> +        * Smooth delay updates with exponential moving average. Updates =
can
> +        * get lost if workers race but we don't really care.
> +        */
> +       WRITE_ONCE(sb->s_deferred_reclaim_delay,
> +                  (63 * READ_ONCE(sb->s_deferred_reclaim_delay) + delay)=
 / 64);
> +
> +       trace_inode_reclaim_update_stat(sb, n, delay,
> +                               READ_ONCE(sb->s_deferred_reclaim_delay));
> +
> +       /*
> +        * The elevated s_deferred_reclaim_count keeps sb alive until we =
drop
> +        * it
> +        */
> +       if (!atomic_sub_return(n, &sb->s_deferred_reclaim_count))
> +               wake_up_var(&sb->s_deferred_reclaim_count);
> +}
>
>  static void inode_reclaim_deferred(struct work_struct *work)
>  {
>         struct inode *inode;
>         LIST_HEAD(inode_batch);
> +       u64 start;
> +       int id, count;
> +       struct super_block *sb;
> +
>         /*
>          * We start with the list corresponding to the work but rolling a=
 dice
>          * would work as well
>          */
> -       int id =3D work - deferred_reclaim.work;
> +       id =3D work - deferred_reclaim.work;
>
>         while (1) {
>                 if (!get_inode_reclaim_batch(&id, &inode_batch))
>                         break;
> -               while (!list_empty(&inode_batch)) {
> -                       struct super_block *sb;
> +               sb =3D NULL;
>
> +               while (!list_empty(&inode_batch)) {
>                         /*
>                          * inode_batch list is private and I_FREEING flag=
s
>                          * protect us from anybody else trying to remove =
the
> @@ -1137,17 +1167,20 @@ static void inode_reclaim_deferred(struct work_st=
ruct *work)
>                          */
>                         inode =3D list_first_entry(&inode_batch, struct i=
node,
>                                                  i_lru);
> +                       if (inode->i_sb !=3D sb) {
> +                               inode_reclaim_update_stat(sb, count, star=
t);
> +
> +                               sb =3D inode->i_sb;
> +                               count =3D 0;
> +                               start =3D ktime_get_ns();
> +                       }
> +                       count++;
>                         list_del_init(&inode->i_lru);
> -                       sb =3D inode->i_sb;
>                         evict(inode);
> -                       /*
> -                        * The elevated s_deferred_reclaim_count keeps sb=
 alive
> -                        * until we drop it
> -                        */
> -                       if (atomic_dec_and_test(&sb->s_deferred_reclaim_c=
ount))
> -                               wake_up_var(&sb->s_deferred_reclaim_count=
);
>                         cond_resched();
>                 }
> +
> +               inode_reclaim_update_stat(sb, count, start);
>         }
>  }
>
> @@ -1183,14 +1216,61 @@ static void __init deferred_reclaim_init(void)
>         }
>  }
>
> +/*
> + * Size of deferred reclaim list from which we start throttling tasks cr=
eating
> + * inodes marked for deferred reclaim.
> + */
> +#define INODE_DEFERRED_RECLAIM_LIMIT 8192
> +
> +static void throttle_inode_deferred_reclaim(struct inode *inode)
> +{
> +       struct super_block *sb =3D inode->i_sb;
> +       unsigned int len;
> +
> +       /*
> +        * If inodes with deferred reclaim are accumulating too much, slo=
w down
> +        * tasks creating them. This doesn't provide any kind of guarante=
e on
> +        * the length of the deferred list since lots of inodes with
> +        * I_DEFER_RECLAIM can be already present in the inode cache and =
we
> +        * have no control when they reach the deferred list. But if the
> +        * pressure on the deferred list is sustained, the balance should
> +        * eventually be established.
> +        */
> +       len =3D atomic_read(&sb->s_deferred_reclaim_count);
> +       if (len > INODE_DEFERRED_RECLAIM_LIMIT) {
> +               u64 delay =3D READ_ONCE(sb->s_deferred_reclaim_delay);
> +
> +               if (!delay)
> +                       return;
> +               /*
> +                * Scale the delay based on how much we exceed the limit.=
 Wait
> +                * at most 4x as long as estimated time to reclaim the in=
ode.
> +                */
> +               len =3D min(len, 5 * INODE_DEFERRED_RECLAIM_LIMIT);
> +               delay =3D div_u64(delay * (len - INODE_DEFERRED_RECLAIM_L=
IMIT),
> +                               INODE_DEFERRED_RECLAIM_LIMIT);
> +               trace_mark_inode_reclaim_deferred_throttle(inode, len, de=
lay);
> +
> +               schedule_timeout_killable(nsecs_to_jiffies(delay));
> +       }
> +}
> +
>  void mark_inode_reclaim_deferred(struct inode *inode)
>  {
> +       bool throttle =3D false;
> +
>         if (inode_state_read_once(inode) & I_DEFER_RECLAIM)
>                 return;
>
>         spin_lock(&inode->i_lock);
> -       inode_state_set(inode, I_DEFER_RECLAIM);
> +       if (!(inode_state_read(inode) & I_DEFER_RECLAIM)) {
> +               inode_state_set(inode, I_DEFER_RECLAIM);
> +               throttle =3D true;
> +       }
>         spin_unlock(&inode->i_lock);
> +
> +       if (throttle)
> +               throttle_inode_deferred_reclaim(inode);

I would expect the throttling to happen when too many inodes marked
I_DEFER_RECLAIM are evicted, but not here. In my use case [*], inodes
would only require deferred reclaim intermittently, while they have
outstanding revokes. Once there are no more outstanding revokes, those
inodes can just be evicted directly.

[*] https://lore.kernel.org/linux-fsdevel/CAHc6FU4Rf9-r8m8SSb=3De0k0zyoFhQA=
djupHMWvT6rStBshntug@mail.gmail.com/T/#t

>  }
>  EXPORT_SYMBOL_GPL(mark_inode_reclaim_deferred);
>
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_type=
s.h
> index a41bd57fc2e6..6db5df6fd35f 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -234,6 +234,8 @@ struct super_block {
>
>         /* Number of inodes queued for deferred reclaim */
>         atomic_t                                s_deferred_reclaim_count;
> +       /* Average time to reclaim one deferred inode */
> +       u64                                     s_deferred_reclaim_delay;
>
>         /* Number of inodes with nlink =3D=3D 0 but still referenced */
>         atomic_long_t                           s_remove_count;
> diff --git a/include/trace/events/writeback.h b/include/trace/events/writ=
eback.h
> index 4a9cfe458820..aec38eaeb10e 100644
> --- a/include/trace/events/writeback.h
> +++ b/include/trace/events/writeback.h
> @@ -881,6 +881,57 @@ DEFINE_EVENT(writeback_inode_template, sb_clear_inod=
e_writeback,
>         TP_ARGS(inode)
>  );
>
> +TRACE_EVENT(inode_reclaim_update_stat,
> +       TP_PROTO(
> +               struct super_block *sb,
> +               unsigned int n,
> +               u64 batch_delay,
> +               u64 avg_delay
> +       ),
> +       TP_ARGS(sb, n, batch_delay, avg_delay),
> +
> +       TP_STRUCT__entry(
> +               __field(dev_t,          dev)
> +               __field(unsigned int,   n)
> +               __field(u64,            batch_delay)
> +               __field(u64,            avg_delay)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->dev =3D sb->s_dev;
> +               __entry->n =3D n;
> +               __entry->batch_delay =3D batch_delay;
> +               __entry->avg_delay =3D avg_delay;
> +       ),
> +
> +       TP_printk("dev %d,%d batch size %u batch delay %llu ns avg delay =
%llu ns",
> +                 MAJOR(__entry->dev), MINOR(__entry->dev), __entry->n,
> +                 __entry->batch_delay, __entry->avg_delay)
> +);
> +
> +TRACE_EVENT(mark_inode_reclaim_deferred_throttle,
> +       TP_PROTO(struct inode *inode, unsigned int len, u64 delay),
> +       TP_ARGS(inode, len, delay),
> +
> +       TP_STRUCT__entry(
> +               __field(u64,            ino)
> +               __field(dev_t,          dev)
> +               __field(unsigned int,   len)
> +               __field(u64,            delay)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->ino =3D inode->i_ino;
> +               __entry->dev =3D inode->i_sb->s_dev;
> +               __entry->len =3D len;
> +               __entry->delay =3D delay;
> +       ),
> +
> +       TP_printk("dev %d,%d ino %llu deferred list len %u delay %llu ns"=
,
> +                 MAJOR(__entry->dev), MINOR(__entry->dev),
> +                 __entry->ino, __entry->len, __entry->delay)
> +);
> +
>  #endif /* _TRACE_WRITEBACK_H */
>
>  /* This part must be outside protection */
> --
> 2.51.0
>
>

Thanks,
Andreas


