Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77F8CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 00:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B238E001A; Tue, 28 Oct 2025 20:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142638E0015; Tue, 28 Oct 2025 20:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080BE8E001A; Tue, 28 Oct 2025 20:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E980A8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:02:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D11E88C5A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:02:55 +0000 (UTC)
X-FDA: 84049201110.20.DC68A9D
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0520C0005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:02:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=C53X0V8n;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf28.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761696172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xF6B/bGLrhNZetGrqx7q4mvUW1pHQ5FZufaW6F5zkk4=;
	b=Z5ZtISXOzFk0JFkrwThic3V9HkkwXWXNFlZpDoroXwA+aqeV2bKF9IQjuCgkGU4myFthhq
	B0Mw326cQurCQSrYKrB1gfxNO5cVZalFcnPLqvSpPiLL9cPlV2nfWCYsa0pSmDw9fnhHrr
	Y0OG7RJl09z9cQalSt6NbSMDrxcU8vE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761696172; a=rsa-sha256;
	cv=none;
	b=WcVFwq3kPE8WYMZ3bQh9gdbZSiyw6M8pvkFWDyEi7e9FYeH5Xyq5e0rNP9jKAgDcsDRpZy
	axa/cLI9YYknp4FAgGafqodncZ2iIGzthDME0Egz39pHqSEqrFDhQViTCjOtkg+uSp3WoU
	jo0VHwVALzqUypbUaaRcZihmYTJU5tI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=C53X0V8n;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf28.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=paul@paul-moore.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-33bc2178d6aso4842164a91.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696171; x=1762300971; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xF6B/bGLrhNZetGrqx7q4mvUW1pHQ5FZufaW6F5zkk4=;
        b=C53X0V8nbUFy9QxQCw/k0By1DD83hC9pV5IUfolKzGEhsHKDbnxxwnYWxaQjZ4pUkR
         s0lIonQhIYehFpyqdsY8bGC6MUKTBvjGfVttIk3GhCEIarTTqSPZfm/BHax2fnvMBC2+
         WcgecflEJenU8LojGqTDHAokICH803F/dvvynCPQe/aXcp8AWvCx2hJkIpi0aOD84Y+R
         +aSI2XctWnSNc1c09Xe4NmoVHodmkN5s/Z73XXSjxRhivEVw3ekp2BNcXx7g0R4ffluJ
         vQ3DSRicul/md2Qg2HNdPKTiSvd3lt3PW3waH7n+bKp9LhkMHd4FJ2Z+HcUGNnpVd4Jw
         0wQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696171; x=1762300971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xF6B/bGLrhNZetGrqx7q4mvUW1pHQ5FZufaW6F5zkk4=;
        b=JhmTo7ZDv+Uh7JUVJ0RNJ9/qYqakuLV4OScfnncKwuZZ49ZJ00i2EOcl3Yfxn793st
         1uKdii/NjLbUXk0+hOg7PJ+mXiCSIg53c4Aydd3lh78ifzjhBSEUDCkTZre1ktfVIpO9
         4TtUryxDZqvJSn1nNdUi4CGO1grde24zxuHV+2EZxeKW6P1DPsWhZTo8/txkCgnntbO6
         xSmkBukQYDfDjb2PBkaVe294ZohchZs0Xc/fO3H1/7l94R3QQbAhGZgHDpWMZgu6vvLw
         t69n8F+9CNAwQd8b1O6vsLwshoaeOymHdvkWoI1DPjRp2/C8JT8W24EzWPhsA6CzpvUW
         H5xg==
X-Forwarded-Encrypted: i=1; AJvYcCXdfCxg9hLesHAbsEL12aaqDHI8qLEbYBJGSzwY6XTljgJiFnBFLqJcC54UNL8eSVGU9AANWefXxQ==@kvack.org
X-Gm-Message-State: AOJu0YxYl1/g6kYkwjWIeqz02KjQi6U1PAbpaLP1TQXmRG1p5QcDm9Dn
	exL1P73QSZdgRDBItgOLUhu665FhNeOZSeJ5VksoUGK9avgi052rVI2uqrgiAssxGgg9IWMgGu3
	IcMgoJjEbrkZHaqJ94xiHD3VEQh6bkb5A+xQYJkB/
X-Gm-Gg: ASbGncvC1+Zjm3QDHBTbDwBxPLBmZJx9fjH6ZfqnW1lCpp2Q68dG35H8FkYMPumuTLV
	Dzuz1rZTZPqf96YWHpv7nZKNNcuhHjdLDoIZ/bCiUJquTtz3O1Nl2AWHjg+m01bTzXwTRE8FMlH
	K/IgGbKkOeN6CIwFDCYX7kXWBF1or2Y38ei5ddrcMP03lpJKRzLVWlRUhbnzw/5Y/xgzsUNRvE9
	a4XYVe0OC+8t1sRKrqKxLWyufX6VcV5mIwJfpCB0rCPJcxDja2aPR74TLdK
X-Google-Smtp-Source: AGHT+IF4NZKo/CMR1Xvo4aqvxCL2dK2Kp/y68pib/yspEfnhKPr97BsNeUO4lrcXad0luDAxu81WWX06Cn/QvKa01OM=
X-Received: by 2002:a17:90b:54c6:b0:33f:ebeb:d7ef with SMTP id
 98e67ed59e1d1-3403a2a420cmr1024634a91.35.1761696171255; Tue, 28 Oct 2025
 17:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-36-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-36-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:02:39 -0400
X-Gm-Features: AWmQ_bmmcbrTxQbk2K0S9dnAz964E4djBpHBaC2BLyDDdj2u6ZdL3nJ0xadT9U0
Message-ID: <CAHC9VhRQNmPZ3Sz496WPgQp-OkijiF7GgmHuR+=Kn3qBE6nj6Q@mail.gmail.com>
Subject: Re: [PATCH v2 35/50] convert selinuxfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B0520C0005
X-Rspamd-Server: rspam02
X-Stat-Signature: k7arc7jheay98ob4asrzaqoker753cqx
X-HE-Tag: 1761696172-500390
X-HE-Meta: U2FsdGVkX19ya98llt71aXGPsBH58mHGvNijSbiJMd9quOfQEExFYwvvOALdAhbcap4cvQ1wxiRJwJoMRTLANjWAmcQvDskFDkOl/zM7/TX+jUiT43dpFlBd97AcGCLunNehFKAX7w8NdRiRxD/sCpuZA24swx5XJ7NY40reWV4/3LfaPZBZofw0EsjimkNNcmir5SwA5L/p/2IGdKC1ByVXXwC4XTbQ4gkUZsin+HA/yjTRZkzC0Vixd4mtD6xC8o9sGjjCByUbUagDrp0W/DKTQwZPBHyYiT1RfF+Iw5YTrlDg8enc6COJpM/t585gHgsWsEA7OUhyq7QWSc3h9W5QEdaSOxpVx2OznCnFZoi7PD1CU10lAC3oaBjTfoo5rQ+w01kw464DKKl+8LBrOBQ8TjGrYa1hg3VzjKQeNQxy5TCNhzEcZpJ7sp4nLdPoYHPC3rASHi2VqNVUJb/q9Arg/7o+nKuRvBqcKFQKaWLjbBQWCHT6w1ItyZ7+ByMFlJdC7IOPJ2hsCVKxpWtwzMN8yxNqColdT+j6HTMEP8anU1OLG3REa8Vi+nykgPVoSQVHPp7rdGHKiY93wdNULgapMrebhKajSZTJdcVL3uK7ro5t6oPhFVQNA/zkjbkLoQ40eHB8NmVFNO6PswA3kJy8q/Y0MTVy/DUJhyIY2O1nVdfp6decd45ZkSebAzA/i66utTVFddRRozyGU3FyDg/pftkuK5ovuUNhw/ulozP/O0DytJH9XXCSd1VWCzKxXoOPhck83VXCaZOkWO9G8sN7c1FC8GgyF6lvum7qXWjty4ZcMCMEAUtG/lzzF2wcQ0jwB+BoT5xrrE/nBL8nS1UtXE89ojrmrAjCpJ4AoG7CYn8q7biyBgJ1Pjwq1Ua+Po3EOAdDKxz9dR4B0WDVNEkfrn9VsAEgKcNSLkja07jyCW8XYT/I3xmDNRi9uRt/ldXt7RERLbysUyAHEQz
 p7D7UEpE
 /Ugw1vxC1ZhQ05GBA/SOmkx6xsJ+N61yrSkPws3/Piupyp5HuQwpawQ4ashuuGDDPm3QotUcCx01p9hsjbaYeJJy3hkeC/zxrzlc7HMFnlzS8bOJu5WcnGw4Pw8R/acQYg0SdmOxL/i/e/+B/TluhJ6Wj0DYzndxcdFCJWTzw58VL8GSLcc7mTjftCsC6VRlF6HnRXUASQJPbRtd96BOmD4FtqErZv3QjUQJ2QKg+RnSB/UZwO9IVH0wSikGn7S6fOn+E17SEnosybF06GaasIPWayPmLpzatPPlgAO+0wF0Y14x9dvj7/GeqyDz05gTkSrLjrnxO86RGzww=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
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

I suppose the kill_litter_super()->kill_anon_super() should probably
be pulled out into another patch as it's not really related to the
d_make_persistent() change, but otherwise this looks okay to me
(assuming I followed the DCACHE_PERSISTENT changes correctly).

Acked-by: Paul Moore <paul@paul-moore.com>

--
paul-moore.com

