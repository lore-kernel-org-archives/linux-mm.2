Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47226606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q4Pbfu00
Received: by kanga.kvack.org (Postfix)
	id 6549E6B05B4; Tue,  3 Nov 2026 12:32:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6055D6B05B5; Tue,  3 Nov 2026 12:32:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3B06B05B6; Tue,  3 Nov 2026 12:32:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2611D6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:32:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9343C1604FA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:32:32 +0000 (UTC)
X-FDA: 85394502144.30.E2309AF
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E8EC10000F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:32:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q4Pbfu00;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793727150;
	b=i+qFq0WgJ9cQ6e7FswdKX8k3SHU1HbsFD289GKveSQ82MKR8U2ytJcYkc9vStMNC/dyIHu
	sAcJi5PaJ29wtYhMOeck0VWPKej0aLYfvps6cCjeKTZ04MOq/ltPkI0GJxzU29y3LIJwnp
	5nHiw5DqDpisWpR73qsdf5c/U0IAf14=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=q4Pbfu00;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793727150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
	b=dLLtM3neCIugusi9wD5mquafMKazYJ8kw+zftxs01yk6+mytyYSjny3M9i1shMGb1jUcNF
	ntlFwSmZX/jsd6+51CD4UysjsdN0TriOCr4Bi5PABIIefhqiSeqbpgsCy0YjAkNhiKjjOt
	xsP0gNftZtQx5NO6C8k2RCMZMUUtZXU=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e4831c028so3917372f8f.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 09:32:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793727149; cv=none;
        d=google.com; s=arc-20260327;
        b=JIBSDAOEGnvjqr1XMGd/CGT2uvCXqmwmZhn8WEXok300eADS8SQsrgD8xQLGGas8S2
         UMuZ69M2HuIW8DvnA7+RjumKEZYMt2if0QaTKD/M7uH91mylxl4NxEJvKLJFKBg1MZFt
         62BW5ORxQXGclOx5DqEsMujCEc8l3xd1ndaDXVpQ9JdLgmJIgMKOvcXvw8C9eU2bnumU
         bnXzu4s4Moqv0ffoCShKI1kK4NheDM5hLhVefdBVnux3dG/2n69E0cbktCcRhPwirHRg
         76ER5FwYhUSLF00Ydn9HK77+uM+AW7cSx3anH3CzPwaoQaSLU5UHMHETgR1SmpUes+ku
         gDmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
        fh=TK05GVE7TWl0oAhRU0haPwa3KAYge+cKGdmhg+qzHnU=;
        b=MBjBQFC7kV/StmATIPcbxSA/hzjqQlugCYaQ82/gUCt5Au22Az93c7yef/qvt8/5AW
         fbqXOAjU3vag/0uLhFJ4hPoi21ydKpxB6KtNtIF27y1gyz6pQw2mTXb1Jt29mHBr2BOj
         prsAG5hq3tu19PvmcUpEayfeUgddKopAt1wDdJx/XHU+4u6M9pyiDcB3wljMHznDzwTS
         ZyjOBjWfh7/SJHgH224EBsUYgc3K6d063ftEy8+pv5gqf1BzmT/CUBXeP4cfQ+4aC4Er
         oBiFOynfBVKy6CntdLRlneZy7BiS7kmaGr9srLlnTcmcPio5cETlVMiplOpEVuA76P+6
         cUHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793727149; x=1794331949; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
        b=q4Pbfu00+4PrJ1LRaagPTwNb83uiTXyWK6JtB8Bmy+4QT02mXcfOrEmSymEbl/O6AN
         H8k8zdAp9CUxnBYCKFlqbXetOHsmCOC9QYkmzyB+A5cuqkym1xxU6DztEzQzqPkU4JiK
         kKyCK+6yA+jF3ytgOPweiqr+bCchorpP3QuN9stewiqnSsOmS8JdV18z8GxCeYcf14pY
         Jzmhz+2r81PgWonnSr+EW7IaR43aWZnF2vV2JIQtEV1tJuWOEBNk86OTbMebvHzCX2bQ
         D6RsSbQ9BBanFihwSg2E8ucVTpiEtKM0f6VRohAWQtpofwRH1xdjxmK21BSQmOsdSIOW
         yUAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793727149; x=1794331949;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BjAvXl9t7a/JdDo3zmQDUheOgn/OssmLnxGDAWna7Kc=;
        b=y+JX0NU/JP3/UC70ruEOj8aBvivj6kxcOby7vBVtbKSJjIaYMPz5Uc9tQ9TmHwSHcR
         RjPuyJTTkzuLeOVQauHz/TWQw2sLa+CNcBa3T36/NvpFZqEFdA+jof1bOhfFZn0fhw+D
         nwoIuH9eYd9NbD4YsO71ex54lmVZb4J1CzenZfOigIdsQMefjjLymjZFZ5OJg37qLOs/
         WqaJTT+Ag5AhWTvMrz0F1rrJKJSf2E56wH7bJaICXOGwWZwUZpsaiTXGABUEuQhxkZG5
         mbyhQ1mFysSZHRBme/JdXr+iySflvt4pPqwUIuisuQK9jdqnEIPBwJjB9RMn3zs+oIXS
         u8Jg==
X-Forwarded-Encrypted: i=1; AKwUvBxGz7BZob2TN6UCMjpYUt4VEkLW5HoMm2aLQVqKgyhkiCa1ROQNokv3naSqBLk3rwiTyd+gHZvgxw==@kvack.org
X-Gm-Message-State: APuU4Z+ktyoQZl05QHASFfYwUpBlQMSEtmJrnSREB1s6Xk7Gc0di7nbF
	33K8gc4v8j6jb3vLbRoFJ2l9n2Nt8Yweah4tq5f2TJS7fI18kRpmhzjJpK41UwPxjpSHxRyn7iG
	AC6vAErJlqjVR+UoqQLFWIGCvmiC95BY=
X-Gm-Gg: AYBFou2jPj0TBEb56usDEKrgzIPswR56o4t7G4mvKcQKK/cQ96l9awUOLGy12vF/VtZ
	tIPDE8HWUb5kZnWeGYOl1KQ0lUPBBngf1ZK2YqXYGdNVR6WoYeo4kRMhi7g52mIOZ/FVLuqjKq3
	Y0Zgzr+vW38vUDYONkkLzfLtkbJ80/zUMfSArvh5f0gQyHTVXX/8J4Hr8y+uUwTnDlAtrEXnJTx
	TDo5HUS7j3qt/6xEj7K6ajkKvlLNen8LYV6trn6QWT4yx2uP1lmbXiWmmLaGan62ucpR7W251Ol
	4ms2LvY8ferBxhuZV/zpzuBufvFCIWKjfKwajo606NCOwvoNHX4AkdpYfxJ0Mrlvbv1U99d2HG8
	2bd1gURe01S1TS26gJMfGAHWie4R2GN66s9HL
X-Received: by 2002:a05:6000:2c03:b0:48c:6cdd:ba89 with SMTP id
 ffacd0b85a97d-48e6e4ff80emr28595835f8f.36.1793727148868; Tue, 03 Nov 2026
 09:32:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-6-2f44f64f0b66@kernel.org> <sashiko-outbox-191225@kernel.org>
In-Reply-To: <sashiko-outbox-191225@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Wed, 4 Nov 2026 02:32:10 +0900
X-Gm-Features: AclHuK_xchRwxsZ5xCgnuvGf3QgoTbZDme23pAKWici3-nvdFpdRQtDLUtkXtDM
Message-ID: <CAKFNMombDWkJ=m+CjMy7qnd_yy-vZ9c-EE7R95HKKkcy-M0+SQ@mail.gmail.com>
Subject: Re: [PATCH v2 06/34] nilfs2: don't set SB_RDONLY after filesystem errors
To: sashiko-reviews@lists.linux.dev, Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
	Karl Mehltretter <kmehltretter@gmail.com>, dsterba@suse.cz, tytso@mit.edu, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 746qsiqrzgz6i73okmxfne1ojtzy6it8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E8EC10000F
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793727150-483639
X-HE-Meta: U2FsdGVkX19Ce00nawWNl12oTDdk/k/wDOTA0Vg6uX+riI+tQTdgGSnKk8efSjTD20wnmpv0Z1nAx0f0I1JN5u0cxl/HskNPXp4bZ1UR5rA+30HVO87dhCgMXb0oeXJ1AHevkgl/ErTwJGkS16CbYqTDoN/JCFAfYacR6IygMlY/8BSYJ7iJf6LrZ/RkCinwQds+hL4mK/DFH7Qvl/kp3DGX6NJ89+XM/G7D1YeWdHAODRcfSXdC+2k0RChVOTkcXt1Q+m9eP3sWkesDf25F+q36zVZ9nMp9HqbAxiuVpERTfjteUYJQuAcQFEvIwlz/77OzUZRUQANW11LrXPBgW+RTsheP1V6KTd9Jfzzuli+Iyaomzz8P2wWqOXT6UtXf4i7iEzgDKz5I25nRFpeU5xEnQTDIGs1o9RHVTeQCX60wBTlyFAu5PImUkzX0G7IgNIqxfbqubY/0JEsUrIlOYzQa3d12u4eamlt6raTqPc8+nO+pNMcH6smNNN/ZP4X8ZJAvSE+U9Pv4L8d8POhjWILAYvyyOmOi4ZqYsJkns8+IF41kgbJYPE0DRtgN8pRFvDgZC7WuhscSMjjtqFK+dJq3Z9Sg2WUOOytw5l8xpHml3hBAPgLqbiKL/5MljI+3rWEog/IV9Dqj0QICthi0+p/oVBsulmxERbdlM2Pn4+54msA1z/+KB5B980jf55P6A91R6UQtMKaXdaiWg8CbJWtdbr9A4yQ3LzKrrW/7HNyA9ZT3TLtck87i7SWdOQUwuLWjkg0HnarkkAOuj98FZiZjwBNGj59cCWIAzWsjRiVAZ3JIwg8B/W0K0afPZN/5zIrangEWN0B/xV38sEYJMzSY6S8hIdLKOzV6k3b/YiGIxDB45k+u/cckbQa3M989b6s2S9NbEv8iXsxCj0IyGPwt81RAYeAD++LclYtsGcIHy4KxyLT8Wz2FSbpbFgnIzVie5OU3/koLt2Q8ClT
 2Xs7gTLG
 6wNRHxej5CstYHg7QVsKu6Iuf7wpBd6NxbeZWIiUzFVyXt9/DLqdabVRc1YTNiZuyqBPeOrPNYnptxYiP7yNgAN2q15I2CLMV6WwJp++eZyFFG4jBSj9/EJIStyOIknnUQxu7w3EjwvGdA2aSTdLwHgmLiIxEukWdL4LyzWGFsveZ4e73cXtYat+kPpcNVaIIW3X8E5rph2DLH9nhMay4GCVMoVtXPbjc1mssrMBDJfgehUOdcUmPETT3dkImL3fvMW8Vpg/nAbr/+HPzFbAX8RvUeRwLfcigK+jleeiVdIN+AVYz8nEbOcCz5YkoQ6WIt23C5ANh/scDfGmifh0IsPG8D3Eqxz75Dh0jk0CM6SL5r/dy1D5KoFiBTK8c0In45QI38nANzpzzN64kw47+4JBdm1AEkWB5CCnS7sSX9tOaRygeoQ1q2ckBIbhCbDL7LQGfeLf19+dsF4N+eT/k7z2eSh+SQkyEthPLw71NYOESY7bV29yESvzTiQ6L05VWxGxJxKH1z5zlyXVxvXXEo9so9+nKmCkfOOZ7H5VpAgKk1ZINIwJ3XHu4dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 1:09=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] nilfs2: nilfs_reconfigure() and nilfs_get_tree() bypass sb_eme=
rgency_ro()
> --
>
> commit ff163f1297bca8964f03776869c3a8bc9e3c38ba
> Author: Christian Brauner <brauner@kernel.org>
>
> nilfs2: don't set SB_RDONLY after filesystem errors
>
> This commit replaces setting SB_RDONLY in __nilfs_error() with
> sb_set_emergency_ro() and introduces nilfs_sb_rdonly() to guard write pat=
hs
> after filesystem errors without taking s_umount.
>
> Link: https://lore.kernel.org/r/20260903060855.4610-1-kmehltretter@gmail.=
com
>
> > diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> > index 2e3b591c117c9..edb7d379ecbdf 100644
> > --- a/fs/nilfs2/super.c
> > +++ b/fs/nilfs2/super.c
> > @@ -137,12 +137,13 @@ void __nilfs_error(struct super_block *sb, const =
char *function,
> >
> >       va_end(args);
> >
> > -     if (!sb_rdonly(sb)) {
> > +     if (!nilfs_sb_rdonly(sb)) {
> >               nilfs_set_error(sb);
> >
> >               if (nilfs_test_opt(nilfs, ERRORS_RO)) {
> >                       printk(KERN_CRIT "Remounting filesystem read-only=
\n");
> > -                     sb->s_flags |=3D SB_RDONLY;
> > +                     /* SB_RDONLY needs s_umount, see sb_set_emergency=
_ro(). */
> > +                     sb_set_emergency_ro(sb);
> >               }
> >       }
>
> [ ... ]
>
> > @@ -1141,6 +1146,10 @@ static int nilfs_reconfigure(struct fs_context *=
fc)
> >       if (fc->sb_flags & SB_RDONLY) {
> >               sb->s_flags |=3D SB_RDONLY;
> >
> > +             /* After an error nothing may be written, just go read-on=
ly. */
> > +             if (sb_emergency_ro(sb))
> > +                     goto out;
> > +
> >               /*
> >                * Remounting a valid RW partition RDONLY, so set
> >                * the RDONLY flag and then mark the partition as valid a=
gain.
> > @@ -1152,6 +1161,12 @@ static int nilfs_reconfigure(struct fs_context *=
fc)
> >               __u64 features;
> >               struct nilfs_root *root;
> >
> > +             /* The VFS doesn't refuse this when nilfs_get_tree() call=
s us. */
> > +             if (sb_emergency_ro(sb)) {
> > +                     err =3D -EROFS;
> > +                     goto ignore_opts;
> > +             }
> > +
>
> [Severity: Medium]
> Can this sb_emergency_ro(sb) check in the else branch of nilfs_reconfigur=
e()
> be bypassed after an error on a read-write mount?
>
> When __nilfs_error() calls sb_set_emergency_ro(sb) on a read-write mount,
> SB_RDONLY is not set in sb->s_flags, so sb_rdonly(sb) remains false.
>
> In nilfs_reconfigure(), right before the if (fc->sb_flags & SB_RDONLY) bl=
ock:
>
>         if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
>                 goto out;
>
> When a read-write mount or remount is requested (!(fc->sb_flags & SB_RDON=
LY))
> on a superblock where sb_emergency_ro(sb) is true and sb_rdonly(sb) is st=
ill
> false (for example, via nilfs_get_tree() -> nilfs_reconfigure() when the
> superblock was kept alive by a snapshot after the corrupted read-write mo=
unt
> was unmounted, or via reconfigure_super() -> nilfs_reconfigure() on a dir=
ect
> remount,rw without an intermediate remount,ro), this comparison evaluates
> false =3D=3D false and jumps straight to out, overwriting nilfs->ns_mount=
_opt and
> returning 0 instead of -EROFS.

I have reviewed the related code paths across all patterns regarding
Sashiko's concerns.  Regarding this first point, there is no need for
concern.

Skip check in nilfs_reconfigure():
   if ((bool)(fc->sb_flags & SB_RDONLY) =3D=3D sb_rdonly(sb))
           goto out;

Skipping this block when the requested state matches the current state
is valid because no RO/RW transition is being requested.  In particular,
with the workaround patch ("super: keep the read-only state if a
reconfiguration doesn't change it") queued in the vfs-7.5.super branch,
reconfigure_super() ensures that fc->sb_flags inherits SB_RDONLY bit
from sb->s_flags even when "rw" or "ro" option is not specified.

When called via nilfs_get_tree() -> nilfs_reconfigure():

  - If only a read-only snapshot mount exists and a read-only current
    mount is added, skipping via this check is correct.
  - If a read-write current mount is requested instead, this skip check
    is bypassed (since sb_rdonly(s) is true for snapshot mounts while
    fc->sb_flags does not have SB_RDONLY), and the downstream
    sb_emergency_ro() check safely rejects it with -EROFS if the
    superblock has entered the emergency RO state.

> Also, in nilfs_get_tree(), when nilfs_tree_is_busy(s->s_root) is true:
>
>         } else if (!ctx->cno) {
>                 if (nilfs_tree_is_busy(s->s_root)) {
>                         if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY) {
>                                 nilfs_err(s,
>                                           "the device already has a %s mo=
unt.",
>                                           sb_rdonly(s) ? "read-only" : "r=
ead/write");
>                                 err =3D -EBUSY;
>                                 goto failed_super;
>                         }
>
> Because s->s_flags does not have SB_RDONLY set after sb_set_emergency_ro(=
s),
> doesn't this treat the emergency read-only superblock as read/write, reje=
cting
> a secondary read-only mount with -EBUSY while allowing a secondary read-w=
rite
> mount?

Sashiko's point here has a valid aspect.

This inconsistency can be resolved by inserting the following handling
logic if sb_emergency_ro(s) is true:

       } else if (!ctx->cno) {
                if (nilfs_tree_is_busy(s->s_root)) {
                        if (sb_emergency_ro(s)) {
                                if (!(fc->sb_flags & SB_RDONLY)) {
                                        err =3D -EROFS;
                                        goto failed_super;
                                } else {
                                        s->s_flags |=3D SB_RDONLY;
                                }
                        } else if ((fc->sb_flags ^ s->s_flags) & SB_RDONLY)=
 {
                                nilfs_err(s,
                                          "the device already has a %s moun=
t.",
                                          sb_rdonly(s) ? "read-only" :
"read/write");
                                err =3D -EBUSY;
                                goto failed_super;
                        }
                } else {
                     =E2=80=A6
                }
     }

This makes all transitions behave consistently under emergency RO:

* RW (degraded) --- RW mount request --> Rejected with -EROFS
                 |
                 `- RO mount request --> RO (degraded)

* RO (degraded) --- RW mount request --> Rejected with -EROFS
                 |
                 `- RO mount request --> RO (degraded)

* Snapshot-only RO --- RW mount request --> Rejected with -EROFS
  (degraded)        |                  [Blocked by emergency_ro check
                    |                   in nilfs_reconfigure()]
                    `- RO mount request --> RO (degraded)
                                       [Reused via nilfs_reconfigure()]

The current v2 patch is safe as-is since write paths are fully
protected by nilfs_sb_rdonly()
even if a degraded RW-mount is reused, but including this change
handles secondary
mounts under emergency RO much more cleanly.

Thanks,
Ryusuke Konishi

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-work-fs-=
sb_rdonly-v2-0-2f44f64f0b66@kernel.org?part=3D6

