Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA41CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 16:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003B36B0022; Mon,  8 Sep 2025 12:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6A96B0023; Mon,  8 Sep 2025 12:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C2B6B0024; Mon,  8 Sep 2025 12:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC4746B0022
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:32:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 981E6C01F2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:32:42 +0000 (UTC)
X-FDA: 83866626564.17.BD87C05
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id 62205C000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:32:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bN66nQ+8;
	spf=pass (imf28.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757349160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w+0WKcZRkSZVexNJkaEUVOZobbDOUey9tRoQsX6OtrY=;
	b=If+V/MFabCnOu2/3wBCQN2n7oILQpH0vPv2z1Vbl89DKgfqYy5N97RpfH78Sa00/yGjxGs
	8YAzkVJPMkx47mPEETISccRZ5akRd4IqF+iBwADHB035+gk2BdHJzv5DxBtGJOXUPvDHPO
	fbW3VjcBRSaN0ccc8KeiqvcreYP6MmM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bN66nQ+8;
	spf=pass (imf28.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757349160; a=rsa-sha256;
	cv=none;
	b=As2MRAtalfq/3kf8w/uQq6I9+z0oeoXUgUjslXpTVeyiqH4N+MJ0en6TQPvf5lYjWeAfwH
	YQm9n59yoqe5ebg+GFRTDjejrHNyH4O4tJ5ub69UFIdfi88SBmv8o+4n6KmoGcJM4edeha
	S7Eg+oefTGTWaNGh2dj9jqVnqBISuZo=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24b21006804so48557385ad.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 09:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757349159; x=1757953959; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w+0WKcZRkSZVexNJkaEUVOZobbDOUey9tRoQsX6OtrY=;
        b=bN66nQ+8ZTfpm7lav3DQxr1xkomqqccpGpU+Sg+yxMVGQvocxDBbbfBDDd5sxzq3Sf
         wg0szcedSlYJdOXVddAqqtsrU5piEwJmhdIQmSpH+2hlr9b+JOsPSsyi0quLEu2k2HwZ
         wHFL6ChmtbX98dQGvNYs4czDzcvR6U7DoQTSkWFOd8XX5SWLxnVW2eWMRHo+O00iihJP
         x0omUznAwEiJo4zfem2eAC4CV5NbOpSlmEiWP24gUsOqymNJAFNBwUPVyGoAkG5qguej
         Hn9thGd1pJuILPghJsLgdpbF2M30TeSdL2bbfIXKf98jD8fDSpB8/62O0yekWykIft/B
         Mgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757349159; x=1757953959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w+0WKcZRkSZVexNJkaEUVOZobbDOUey9tRoQsX6OtrY=;
        b=GWvGQjXVbmnXgvQ6tjXzawA6vk2LLHsKr/pnCtLU1sGk59UT/+R95q4EwDOZmu3rLU
         gO8cGyeDbEDt3rrZPopL/Q6L/N2EAqYBcJu8z0vGqTqS8QvhDOHdgHmhD3YB7ab2ZU0W
         lMNazuDqGvg3XyPJZFpGMlGFI/Cv8IRDHEc6uPaAQTIB8Nm084aB00OQyAu9TnX12XKL
         nTTvFcEVdy1eCcEYaBinLg5Jl2yEh323m4xxlkBfiJSAzkN8f5Vt6V2F1TrBS8/UCw0B
         jj5vSnkCPmBdcM7tdxOVq02gkPrC0bF71Zf8B0JayyKDV8ya04plxpR3T8qq1mM8hE05
         Ugyg==
X-Forwarded-Encrypted: i=1; AJvYcCW49ItL0e8SI3A174GbTyMaojwS4mYpIOR3EpRJOvekIelj1KpLDj75PuUbY6aM0J3NPJ4DuNyQeQ==@kvack.org
X-Gm-Message-State: AOJu0Yx64/32aHHB1WvcIcfyRo1jHVq3Cas/a6aqyOO5OCF8jeOBy/9Q
	BxCdiVJU7OKA4q8xFixG7XiBXQ7O8bKe4fhH/AwJfeRp6bky4Jzg8D6yCLNyObNQf1p3dsEj0p3
	sfmmGlStYSDFjKcUtYDJJlie0/yxC92M=
X-Gm-Gg: ASbGnctuAAGTFxxcHV+IqAlAoS7iyzfM7RYw1bDyLTldhi5Zo4QeeKsVueg0VPGPC/I
	JT2O9/aezacAhZHHdr+a9wDO4be7rHGIrkK3jsYFejGazxnHyF3q4GGpNolT0ld0vA+h7QsQ1mm
	GrJrGyy5O7V2SXoYmYo0deiarD0MTGdfK6grsUdG9RCCHyCYmVQD9KcmDNbLilH03v033jfNIVx
	zGAf/ltsxlPNWpHPQ==
X-Google-Smtp-Source: AGHT+IETc3c3cLRTFof5BKTTblzeGAw5qubihFCD5fgwYnPWwAqzknEw27hmimwnbjSTr9fXTHNyB/WBEs118AnTKKw=
X-Received: by 2002:a17:902:fc8e:b0:23f:f96d:7579 with SMTP id
 d9443c01a7336-2517330a5e7mr103859335ad.37.1757349159078; Mon, 08 Sep 2025
 09:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250908013419.4186627-1-tweek@google.com>
In-Reply-To: <20250908013419.4186627-1-tweek@google.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Mon, 8 Sep 2025 12:32:28 -0400
X-Gm-Features: Ac12FXxJdxahVvmzM4YiQBodWGcP75VV7B_u38XfqggRVTZSjI_XSg54VA1OJx0
Message-ID: <CAEjxPJ5q0eriGjo1tdfN+pzBBN5OeyfMaYp_sNQcOg-rDaXVCA@mail.gmail.com>
Subject: Re: [PATCH v2] memfd,selinux: call security_inode_init_security_anon
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	Hugh Dickins <hughd@google.com>, Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, 
	Jeff Xu <jeffxu@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62205C000C
X-Stat-Signature: xiayomc4ia7n54yasspcpnmg1wyoiob1
X-HE-Tag: 1757349160-498344
X-HE-Meta: U2FsdGVkX18vxJajWhuSixw40g3xWHHd5vHH7SosN7oYMCgwql8bCPKKhLpP64++A0vpPEOV34YNX5jGoK3gRfS+bR1yiAKnmfH6NO5eWxbxhK2h71eIeWGfASkS/QKBabS9Tqefomu3/UQXRPu6gQ0F7+JbPQbvoCElTmanM2KjLNkQ2yAW2+fe/kCDN4TKsRqCbSSWLEIl1dLwpKsD5NnhEkz0GRH7aX7K5VQhxtxvrzSo5CuH0CIvhDbpOiEp4c36KghjJ6xXseOWOyivfGyGCvxTh98shEWBfmSlu78ljxq86kwgGdQ2EwzlPzm6klGccXJJgUK+OEw98CofkQmrkzeZjpCFnbZAC54EEhqFITo4bC6mgyozg7c3Ju1hbF+HXoRIxFOiy85qUWAC1WI1VGY0Wf+HNVn3z4+jDY/59//lRvz1lzByD3CNJMzt/5LWVifruVT2dzFl0kpUJyCFZ4GalRVRZ/qQ19Jeaix8Q65ttw2LgXHL//5kiGLm3g5O6IBEMPrfD+q+UJXPGJmCc6L2W6VVRW9XHVtNW2x4zLgZKysix09SmtWzCrArEcaAn7bNuVIkoXfpeoSdzUEp3aMye/iHoJOmNxA+tUT7rp32PbvPbwgILN7L8hgfzzq+BMPCxn0doNWIz+TXJ30O5K+UC0FM/1hhQ3UF+5jQpKykvSU3yWG/VE+LXn93AjyxHCM2LcE/hJFR88aoIwALG9i7FbGHLhEx9HeFEa83C6TiW1vzx7N9TViNf/b10v2f2dNv9PuB9M+YSGR9FzKy8g5gzLfPBFFtLCuMGG6szufySMsLqwHRv1gYt1ztGt1v2iN+KhDF4WU2w2cx/mmilpLki0wncoGDyI0HQT+AXuGWiPN6HSEqLbYxWK31wC8UmFEt9GyaDYR4W60iLf78a8kvckrIbts6hGZRUw3SW5KY2G6QjLvrnuuytvKroYENWXX8HuGeteIBqYB
 PD/e8xid
 Ly00SQyWciEkJzCzvMqX4O5Kla5hHAmS+9OgR/TuuO1hLv8fGdUCv8Ta7wE2piFKoOSQcfDXJu9To1qFTaJJMLWvBXdUHraUaVkWADseMoKgfTdnlFghkrw0cElf7EwX/VpxKZngihm8JmCODQW+7rkNqJKfjKZKA3QOZVhFI1eqEUr4H8Y8XuNLZ1Bnf5vA8QV5Tu4LVb77ASG4oe+pIet5CaIYfD5jZtUGQpfFvoMxnnW+LW1n4yahTgTQVcbHPX8wsOBNFQbGVJTkxyqF1eEjIBiDoamiaAKWPBcjIw6dHij34/ul+u5m91ZpFIaeWD9jWKzNTd0BDvcLKMif93sd33FncmsdoFztD/is2InJCT6X50RKNWS26XKg3INs7WNc+OUJBjmerhWPKtMjmo+AWmcI2zMXKjyQcXoP1LnpcOUowxUtp+TnuYJWcyyVdjyhyZtuiqlB4k9nU0KhsU51Whv1YpypaBmjf4S4I+TzqIYZI1ysLNRGQsE/rUwFurl0wQych8MR/wE7JjvqobBZ0IQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 7, 2025 at 9:34=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@google=
.com> wrote:
>
> Prior to this change, no security hooks were called at the creation of a
> memfd file. It means that, for SELinux as an example, it will receive
> the default type of the filesystem that backs the in-memory inode. In
> most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> be hugetlbfs. Both can be considered implementation details of memfd.
>
> It also means that it is not possible to differentiate between a file
> coming from memfd_create and a file coming from a standard tmpfs mount
> point.
>
> Additionally, no permission is validated at creation, which differs from
> the similar memfd_secret syscall.
>
> Call security_inode_init_security_anon during creation. This ensures
> that the file is setup similarly to other anonymous inodes. On SELinux,
> it means that the file will receive the security context of its task.
>
> The ability to limit fexecve on memfd has been of interest to avoid
> potential pitfalls where /proc/self/exe or similar would be executed
> [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> similarly to the file class. These access vectors may not make sense for
> the existing "anon_inode" class. Therefore, define and assign a new
> class "memfd_file" to support such access vectors.
>
> Guard these changes behind a new policy capability named "memfd_class".
>
> [1] https://crbug.com/1305267
> [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.com=
/
>
> Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> ---
> Changes since v1:
> - Move test of class earlier in selinux_bprm_creds_for_exec
> - Remove duplicate call to security_transition_sid
>
> Changes since RFC:
> - Remove enum argument, simply compare the anon inode name
> - Introduce a policy capability for compatility
> - Add validation of class in selinux_bprm_creds_for_exec
>
>  include/linux/memfd.h                      |  2 ++
>  mm/memfd.c                                 | 14 ++++++++++--
>  security/selinux/hooks.c                   | 26 +++++++++++++++++-----
>  security/selinux/include/classmap.h        |  2 ++
>  security/selinux/include/policycap.h       |  1 +
>  security/selinux/include/policycap_names.h |  1 +
>  security/selinux/include/security.h        |  5 +++++
>  7 files changed, 44 insertions(+), 7 deletions(-)
>

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c95a5874bf7d..6adf2f393ed9 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2315,6 +2316,9 @@ static int selinux_bprm_creds_for_exec(struct linux=
_binprm *bprm)
>         new_tsec =3D selinux_cred(bprm->cred);
>         isec =3D inode_security(inode);
>
> +       if (isec->sclass !=3D SECCLASS_FILE && isec->sclass !=3D SECCLASS=
_MEMFD_FILE)
> +               return -EPERM;
> +

Sorry, I should have mentioned this earlier, but usually we try to
avoid triggering silent denials from SELinux since it provides no hint
to the user as to what went wrong or how to resolve.
Arguably reaching this code would be suggestive of a kernel bug but I
know that BUG_ON() is frowned upon these days.
Maybe we should WARN_ON_ONCE() here or similar? We also rarely return
-EPERM from SELinux outside of capability checks since usually EPERM
means a failed capability check
(vs -EACCES). Defer to Paul on how/if he wants to handle this and
whether it requires re-spinning this patch or just a follow-on one.

>         /* Default to the current task SID. */
>         new_tsec->sid =3D old_tsec->sid;
>         new_tsec->osid =3D old_tsec->sid;

