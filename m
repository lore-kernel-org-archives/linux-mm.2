Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BACCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB9B8E0084; Wed, 29 Oct 2025 11:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BEF8E0045; Wed, 29 Oct 2025 11:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499258E0084; Wed, 29 Oct 2025 11:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BA2A8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:07:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E377F12AF20
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:07:13 +0000 (UTC)
X-FDA: 84051479946.21.C9E3B13
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 09F68C0002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:07:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X2kvdFki;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761750432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IfYIDKxJGGNldyfSmZN9xBlg4Ge86/H8w7OAL6l3zA=;
	b=PBgKRk55fIQ81uj+hFAL3bdNV7iz+FWGdNCPUwe9YuuMZuWqMjJgm6leYNcMzv0KLJlIJT
	fdDC0FwUvnTevbUT/vKf/VGBQN0i0A7lU9NgQkVxxOUmCwblwGieWAv70pofn9Z+f67GQq
	LBeY1HcG0NT7DnVwD3Zrg6IKrLxYAi8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761750432; a=rsa-sha256;
	cv=none;
	b=Be2B5CDzVOI9HrnBJoy+Avf2kd40okLPPjJE8dhEonv/EaK0gaT92+ehTNNcA0rjO9xX99
	nDP04vaSV50J+sur2xErNPyyYRNNVovNagW5DoedechYeAFsENv0VDqCr/aGKIRM534maJ
	rpE0EYgv6oB5zmziI19gl6DpzWUf+xk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X2kvdFki;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-33d896debe5so40247a91.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761750431; x=1762355231; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+IfYIDKxJGGNldyfSmZN9xBlg4Ge86/H8w7OAL6l3zA=;
        b=X2kvdFki6LBMjOkipeeCWN/PeQAVuKOmQLxE7BG9rd31SGiwv+vgDAYnCqe3CakuOQ
         /kF3gGDKfu7AQ2qAMLTYZdM9TJKAOmPVIjOdsLW9v/Mtkad61Y+ThibR2Z+ntYUYGvlx
         Ua5PLdIM73AnGzCfu/P+K1OFTAaiXPScGQlDdTQuhVSEC//QxUxfiExhREw3dYqP8m9T
         /9Ie7plvfpq5EXda3ioAYDFoslFd9dZh/hiZLEaLNt3978Y7oNtAqOmvlEjChKs0KGa/
         6bpwdYik9S4S92FQx4qjkjWpUqqyAfAf/kiJzCBZqtBk0q/c6QqzJ18y/EFSnVYRt9mB
         hErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761750431; x=1762355231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+IfYIDKxJGGNldyfSmZN9xBlg4Ge86/H8w7OAL6l3zA=;
        b=EFU7isPZ8ZULYiq3z8DD1dcP06SBOq9q8myesMleYGd9gWrLhUy0fOglZsu/mGqnot
         uHG2hauwZFgxIZNh5rjwKfF4XdBqcv5utMKxNE70lvPbpimCkXFcftP7oauJpP8EgLO9
         lWRMeUCqXfh5is2TM0lnKGEiH/EdX5x9aw4SbFMZ2nk0AhL2a0hmJDIHpbldpiB7gFpv
         KtUCgRWjdoWqScI/f4/1Y6NkTsjUJnkKh/wipXqxq8P6AaMQUwBhdaSViEnOb0q/KvjZ
         A4gYCRbgvUTSV2S/Ced/XHhK25KEKzBipTMgUn96qabx2SxJkQNhFIPiD7qF2Mqy+BIA
         4icw==
X-Forwarded-Encrypted: i=1; AJvYcCVdvawkYAkf9azTFoZzEfG0BOpDs0OZoN9dzU5DyTR38bRBqUmLPZVnFY2vfXocBYf6TZ/yObKZGA==@kvack.org
X-Gm-Message-State: AOJu0YwDwjrVJuWYZH4KyEv/j/tSjyfMO3neFapjqTI5AJDiI42olXOw
	dRF51LjAaE2azzE+tBJYCIM4V3Q3rDhn0MiCDLQ+PfvYyFkCkzxr10JTb41k6cUXQFu6a9FIl8/
	W98HqnAI3zv36Ht4aTX2pz+KEUB5+sdg=
X-Gm-Gg: ASbGncvXwTYGlYw7Ivg+w499PWG5iWMASoons7BDd0gaWDO96vKDOlAT0QeQyD7KzUK
	cxyHsaw4NlxUCw1593a7M25a/DeLL37SO+uG7O7pazWuiskq3BomMaVccyK2jqhdumoUiXiEWZe
	jY9CG+PvEfyhL0lbo2WvboTO1cc7FulwfP5xXEjRAN1RsKshkMHoTCLc6HWN2ynMd5DVJ6arEzG
	zmPJxahzS+IGNKG516t7hnrzZ7Nktou6vBPHf0RWwhwZlNvceeUfdwg+hV+T5sFwTZhu5g=
X-Google-Smtp-Source: AGHT+IFVqO8ewpIAf0wvRQFGIOOwuq6fD8Gg5dHkMSFcg7AR9XFXs/odOiaOENp+NesUqtIMC2BHNrgVUxHGzL0/CTY=
X-Received: by 2002:a17:90b:134b:b0:32d:db5b:7636 with SMTP id
 98e67ed59e1d1-3403a28efb0mr3676582a91.27.1761750430698; Wed, 29 Oct 2025
 08:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-36-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-36-viro@zeniv.linux.org.uk>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 29 Oct 2025 11:06:58 -0400
X-Gm-Features: AWmQ_blCWCRSlgnSUoNEZRYW0rUX4EVkF7hJCMWu9E3EunP63rWoSyVWbO7_enY
Message-ID: <CAEjxPJ53wJEK4bzt0VMbY=G9gkzuZZA_XtrT+acwPys3p0byBA@mail.gmail.com>
Subject: Re: [PATCH v2 35/50] convert selinuxfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: zximdmgres5s3r5qir1jkzxa6wqprijt
X-Rspam-User: 
X-Rspamd-Queue-Id: 09F68C0002
X-HE-Tag: 1761750431-580877
X-HE-Meta: U2FsdGVkX18vnsLk1wTo0mBF42ezjAtjMwLkLXaWdcMwkPAOhCtgRSgTh2VjJaRb9PwtrdmX7+ThDvSTcGXTh06xbpxRmBKtm5uyM7PEGQSuMe5BFFguGhLVYA1gtv305Gjxkvu8R3+2MzMbijuI1kfAfVRhcj0UOhlrxUOZ6aYnHd9ePGXhrdSb+jkCwndsJSZJHnA2XsYFSg0R7C8Nb/TrCcTcprjIi0WuNI57Cq5UIMWQJU8kMUYnmL9lRdaHiM/sf6MncXC9ArsX2Ttu0oCgHQtPEQwECLdpfIDaWZiYWSSlARrX5/t+JAcHihojHUeAINtBkCQuAwgagjDVV8pKZcMn1KjnzlFHyiyXKDgTWzIxiQyOrpu8iDRuuSCKAqiIAZRhY7JVy+uai8lUaUnU/cvPcb+E+7u3eB6nRsnt6+Ho6PAInr3QlGPhESNjjIyJj7vtoRtj7DiXKXgN34p2WZBaVGFIorTQcScX3UQHWJmW9sh4bzszeT55/qnzNWi2shq438NDFsqcjxX8EDHjvyue0VFIWFby6g2efjIfxen4e07tKoj441yYE80RJ97oPE50mqRh7IoZxF+9QSwq3sa7SdXD48SRRTTD2h8RWvXsiWz/91aEpG8swDT64pfcgqqrh5/a3H9iONqiPmM+38oBWNcpMyewUysr8vn2bMG6hRN8L1hpqiJ34IAhZ5i+sNW2uzmQOQuJpYUD7TSZ80FtP7e9ZsfmU9RFPp9LLUDKEqHSMZ12cTIR/qOwfjPHZwoPqlasVWnXQoptNP8yAJgQHRflrucHONPxMwgj+E/voDRtkaPd8ncs1iGyoH6NiBfLEaIEHJvoJTxl6cDS3yQC0uKct1EXjTT4h4GM0V1KkzKrM2QXJ3I4TONSa+fzz93QC5WVgnfhuefDkNy8TnUuRsAy4EX1XbBh66uuUkigOc1IE32xskHoGxd4tUnROpieAY+a+v3Tl0o
 G/8LrVLA
 Z0/BKxJr8BBJf5+qfQH4TVFjqcXzAcmkcecBrP6bWo2yeSyLIubW+dnCNeRyUzyVDlLzu8QlzLmgWHR57bvQA4oWzhxXlN4VcLLJbNibOjXyXzxfQ00hJQYNX7aZk/TBKANk2vvYWZws4W1WyuW5QZJ2/n2Z8x1lwo9+gGMpAe1FHJXoOvNbnVkUNNjVytvVR4z3hLAr2prkDUji4WQyJflSuk7QlRUeD4F9k+6M8ebO34GT1LS2Oi3VSCmGgoLcHxkAKG36DvbqRUPHLL5WOvomtl3Luv0OK/2fRQSfdtA/3g8NOMRadt63OSyfpyfPagkT2V/OY92a6o+43lJpxxzb0/mvOGUwdhPkS9u95dm21y6yD6bOFXFUyEbKBn1y0C+btY2jLPjyD29KUgTq9VZfOZRrm8glTWP/rmfj0bxTFD6tbMPnSQctqLs1n2ahB9LXYwI5hW1dW2sPX4ZfaOtJ5iGUFqk286nPwNy6H9piopVFx4qdicGcK6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 2:00=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Tree has invariant part + two subtrees that get replaced upon each
> policy load.  Invariant parts stay for the lifetime of filesystem,
> these two subdirs - from policy load to policy load (serialized
> on lock_rename(root, ...)).
>
> All object creations are via d_alloc_name()+d_add() inside selinuxfs,
> all removals are via simple_recursive_removal().
>
> Turn those d_add() into d_make_persistent()+dput() and that's mostly it.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

I took this series for a spin and didn't see any problems with the
selinux-testsuite.
Also re-based my WIP selinux namespaces patch series [1] on top, which
introduces multiple selinuxfs instances (one per selinux namespace),
and didn't see any problems.

Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>

[1] https://lore.kernel.org/selinux/20250814132637.1659-1-stephen.smalley.w=
ork@gmail.com/

> ---
>  security/selinux/selinuxfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index f088776dbbd3..eae565358db4 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -1205,7 +1205,8 @@ static struct dentry *sel_attach(struct dentry *par=
ent, const char *name,
>                 iput(inode);
>                 return ERR_PTR(-ENOMEM);
>         }
> -       d_add(dentry, inode);
> +       d_make_persistent(dentry, inode);
> +       dput(dentry);
>         return dentry;
>  }
>
> @@ -1934,10 +1935,11 @@ static struct dentry *sel_make_swapover_dir(struc=
t super_block *sb,
>         /* directory inodes start off with i_nlink =3D=3D 2 (for "." entr=
y) */
>         inc_nlink(inode);
>         inode_lock(sb->s_root->d_inode);
> -       d_add(dentry, inode);
> +       d_make_persistent(dentry, inode);
>         inc_nlink(sb->s_root->d_inode);
>         inode_unlock(sb->s_root->d_inode);
> -       return dentry;
> +       dput(dentry);
> +       return dentry;  // borrowed
>  }
>
>  #define NULL_FILE_NAME "null"
> @@ -2080,7 +2082,7 @@ static int sel_init_fs_context(struct fs_context *f=
c)
>  static void sel_kill_sb(struct super_block *sb)
>  {
>         selinux_fs_info_free(sb);
> -       kill_litter_super(sb);
> +       kill_anon_super(sb);
>  }
>
>  static struct file_system_type sel_fs_type =3D {
> --
> 2.47.3
>
>

