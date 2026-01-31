Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E30A8D73EBB
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 19:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26AA06B0005; Sat, 31 Jan 2026 14:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218366B0088; Sat, 31 Jan 2026 14:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11AAF6B008A; Sat, 31 Jan 2026 14:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F387B6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:49:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96BE6140478
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:49:04 +0000 (UTC)
X-FDA: 84393297408.20.2EA21B2
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F90F40008
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:49:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gdf06WrB;
	spf=pass (imf07.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769888942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvJH79c3ek4UlgvkC3XFusrRWLJlCUgDtsKCKKtm5AI=;
	b=SDEc/zinq7hyZDIvOp+mcGkX4lT/WhPGvndvfg/6I7Xa1fvToFKIx2kugj6b39RCMR4VuL
	CbUrkkzSVzHAv/LtTaoqhaBSe4DdTq4EvNRrOEm01Xkrda8xmP5s6+NWmGNVZ6gE6mv7+2
	lopyI8VJLR06QIKJVg6O8uPzx+/T1eU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gdf06WrB;
	spf=pass (imf07.hostedemail.com: domain of wusamuel@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769888942; a=rsa-sha256;
	cv=pass;
	b=ieXGuGHtPhdCkgbCEl65uFZarfexvqQ5Y2yuw+AL87PDsJw+QMB3+KhcslKsoSaUgI7xFg
	m88ypC3Q+Uz6VPxzr8sA9kT6/DZB2GSm0FkDZRK9zE7KmBbLTJFOLip/XzBZt5n5mWIFl8
	wih/6BWTu5aOxyNSvgKL4gff3rn1w9c=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b8870ac4c4eso492508266b.2
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 11:49:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769888941; cv=none;
        d=google.com; s=arc-20240605;
        b=ARsSEiXYCTpHjh8Uk30X2aN6bUlOT+n0A8igzDfi4B6WRxlemk7WQzSKTrbmZZAxCM
         K5Mh6UVbnPDgw93dIyhqxiiVxHs3wYytJBE/2xEUFo114G4oJ75N4Zmqp058I/gVUmev
         vf0U9mVlaUS21mcUQSE6F6j0vHgrukQmVoKYKxGMAItz1CkqfXHyZ53m3cAOS4/ldqSX
         99qRCWnwZmFznPExDMiMhBegc0hJ+fjcl4MOSzfRqt6mbuLcfBCGoqDhGWoC2Divf9L7
         5IOk6G4qO5pb46RDWak4BvYYWcvlmP9k/9tje6xk6gTU0rUdJIFP2CM7gSU6++/scPoB
         02pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pvJH79c3ek4UlgvkC3XFusrRWLJlCUgDtsKCKKtm5AI=;
        fh=9Uf5hfRH8TdEaOz8lSHpbiXiSpza26EtPln+HAbKNuk=;
        b=c7pvYTsS6dmnrzkRO56k7YoMbKZVxzy1Rj5uCLJD1K9BgHmlh7patcPGcfvNwgoIP+
         9IXR+MLffTxcoWAWeuP+VYT150NPkiT1HnryoP0xT6f9KJKEvj4/MpLK0fBZTlT/avFp
         Rdgp5JFmUKb5lx8Y1sEuK7o/oksudb2/6lZyShVO28GrGDd8wkfKTVo+VemIPlfBm+Ob
         kHbZQtF3O8bqKbIWN7GpoP4F/GTN/+G8+6E+hLqVdbS7a3Rc3OUiJZcmfdyV3hWRQRrr
         WsvVsldGKTPer20Tn+AtqITNQraUP7/VpxPENtkhgA76clS57ivVSB0Mf6v/YPz349aY
         Q/ig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769888941; x=1770493741; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pvJH79c3ek4UlgvkC3XFusrRWLJlCUgDtsKCKKtm5AI=;
        b=gdf06WrBthBSlW8IZat7LHbfaxDBDKGp7iG3DMvAXcMa8/J6oilx4NYc3D2XzlO8zM
         9XV+5QKou/wswI5eCW1593PWnLjKbDWyR0MRNhbH2nCDkYN8L7yuBX7anLcMB53LhY3X
         1XWjiMbbczLXiMdlYnyXkilVu1V/t59q+hEu8jfcwGFD/TYSoTU7fP/gsxoRMeD4B3Bc
         Y6bawNSSmcCGtwozZihKIZmr2DgDnBQJ2zSWoMn4Y+2ZDyLQIL1u5sy+1KaOthwW26A9
         9arSrCNW2W0TEBV7xLQylpOOThjfT+WMv7L7hYwIdVIAqQjoCoXG5M+RLey54I4Epu1E
         FVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769888941; x=1770493741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pvJH79c3ek4UlgvkC3XFusrRWLJlCUgDtsKCKKtm5AI=;
        b=ZQb461ije6pPoDIGzxhUIU9/rZdHc8wy2FLKO9SMLI8fUIDPnrSqzSWrbqxj8YkPnU
         LaFQORHlaPZ19LFimLFGoscPMIuzKpazq6CoED1v8mpsWodPqcj2cxWWuPf3zIA02HCa
         1h8oIt0pp/tgWvn/zxgJ0G++tL+zqm0UjsXOFtA282wh9ghUGCW9NITdKQ8ExnzYBblU
         kVD/bWWE+vYo3VYxgbHSHmjcKrX+qOReDeXF9gf/QegWse7ZS8VoSwFaxMMDgSc+EKB9
         Ht5m78FqXYrsnEeCNNMcSrBcoYU8D3stDGVaVDBdIbrB4/5YBoZXqvDmu2PrIlWvcyCZ
         D1iw==
X-Forwarded-Encrypted: i=1; AJvYcCWqMz8/wQ39uzYAdM/mT7uZ2NKjTL337DaOsb+dn5V5YaERlXztAZWHDv/YR6tx9u25WYWRCznGBQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5Il4+lxLfs3mQo/mT/ohFwPTHGaymy5QPvU+VGJLLJ2tUakjN
	YdU0P2NhEmRSr+NGcdj5MRU5p8dehSThvaY4Bayua6motg+N6sX/ID7DX3oW89qLxWXmD5FyirB
	53EzSFo63T4MDQ3VqMfLo3HzCniDU1eHJW75W25Qv
X-Gm-Gg: AZuq6aKavtQp56hOZ8yGwmNn53g1vroclUNfo9f93oQ/g6HLPeH2FGkWXsCDJN5+0Ci
	fW6FaUXO3sQOo4QqnQjkheVAkxU0wx3KTiLB0hwMXN0NMRTnVdCkRljyOB9TAWuf7yLEugjrcR7
	I/nJfNdxSeDIDh5oS/4fVE59Zr7tX67Nvv8yfcgLpgy+l7bS4qzGiB86vTDhvtzSOUyZ+lNAR7I
	Oiq52Uol06Gj6renccYz0YUY+LoCdGpPVRa0IIFFOseHJttDKXSDx02g57LQ0zcWJz3
X-Received: by 2002:a17:906:794b:b0:b73:6d56:7332 with SMTP id
 a640c23a62f3a-b8dff5288a2mr467832866b.13.1769888940424; Sat, 31 Jan 2026
 11:49:00 -0800 (PST)
MIME-Version: 1.0
References: <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV> <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV> <CAG2KctotL+tpHQMWWAFOQEy=3NX-7fa9YroqsjnxKmTuunJ2AQ@mail.gmail.com>
 <20260131011831.GZ3183987@ZenIV> <CAG2KctoKDsfbyopQYq3-nJBg3fG+7Nrer17S6HqQ+nCWEcHeWQ@mail.gmail.com>
 <20260131024324.GA3183987@ZenIV>
In-Reply-To: <20260131024324.GA3183987@ZenIV>
From: Samuel Wu <wusamuel@google.com>
Date: Sat, 31 Jan 2026 11:48:49 -0800
X-Gm-Features: AZwV_Qix7s2zR2ubTIU666aQNHaAYNz5LepZwEs2cPS3Y4RZWye8TClZc5UBZ0c
Message-ID: <CAG2KctoJoBevAM=2F=dNnM3VUUcHX9VV-vhKDx5ydOwa4a6zUA@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel@vger.kernel.org, 
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qgqnsm3xuptwnktybn9wm6hbw3hosdsa
X-Rspamd-Queue-Id: 6F90F40008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769888942-588343
X-HE-Meta: U2FsdGVkX1/ojOuD0cJQyreIjDLxAygZNMoW+10/LeoMkq8VB/U0p6PMbD81bO/fYXdEpRMvccwqduxsq/2rP1bKWihywIK3MtE7lWnbA64BDiSTB92XGkIQtzwhxRaN2x3QeQzNN/ca+4j1oDGbGa+ApApnbxTRIycAjVwQTxW8gU4g7cSkC040ZboN2ehQgFw6x0NjBrC6zxVOBOLPM0PuETGe1N/MCuuT1wdseGFf5BobePzpTdRUZ1SVsgd8ohXd6bPzja5Iwocx5yFlzR+T/n+ikbICpiFYZk3Au3VfWfcpp0lI6J67bnYoLR82rN6HXL+tZDq+BaCALS17RMao8Yqwag7dM/gksO29RxZqiA0I9O0pR2kEtBODRJdJi6MuOGTfz3hOgm/TJDKHnY82/sh3tevgni1CMyE9RtNxMdaIucsU1EMOc1dJG6vEEQV8jtxEmjtz3N1zrnaVU7ekfEV9M3T3KYHEYc9gExVHa9tQEfQe424WIi9urJMVoPyTi4++KNmw4n4N1xsSxmVyCvc0fAckgVgFzsOJ4qcYHC2TMAeVIEbdJ8WiK5q26OJDTgSNceMOLnQ5hRfhqx+swno74P4GF6m4Pt+5coSAUeOK8Z7bA1SdPaR5BaOG7Sb4q4bKGINxnlAaHPDp7Kyt54+nlM68dRlvFtJxuP/Em883IYdBq66pAwddqfHDG/hX915AEjl/YjsC7Flci9NQjxCuA+P/B5vvxknAT7CwbFfVreJ0hd/AGjmC64Q+eAASrs7kdNF4iubFOYnKUavtsZ5TQQNttSFz5RsLs7pehKZjkyEVRsUFzY+omaI5htF8hfoiMNHEwDqYb0D4ULK08UAjvQN453jN3EOQRjD4E3EhvmwCY3Dk9+krGKIv0B8TQUA+Ms02MIyR5FVs9x3GanIt0m5vyt+pzcbcspu0C/yp5wM2/tn51vn5zuckaHilJCko2byPW3ZVTYc
 0FDXH6l7
 HwmiTxkjrRkzfPx82Hn93WlUAfS0ytKYVi/uIHCBET5td1R+6ZtJ9heiqwPfZuP7e9k/9F7wMkpDezid5cwBwJJy0ZhWaFxLHqpoTXzJ0g2z+6Mz+TxneXTI1gxQ7C/aHijPJOW1hPw5+c2QAk7/l02Z0aPf3xWcC+FqHyjirB+VCD6h9LtcIdhvxyMfM5+sCUjCQ0B5CA47gQPGinsa4nFA8sf7a8N5CVolSQcHG453qraW/8wNGlNQgpAUz7OnixHur/S0qomo9+Gx3hjwuBhbVRYyv0A1VwMJIi5ISfN0KCDlfn3FmcJh80IywatsNZbTBA53xrFfW/HuFFFQ0zTH9PN6I9OD9c0SZW2m8CrVfX9eix7c8Q3gLlImwTh4OB68TVlb0Q0PPxsFTL+pPuuzOUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 6:41=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> On Fri, Jan 30, 2026 at 06:09:00PM -0800, Samuel Wu wrote:
> > On Fri, Jan 30, 2026 at 5:16=E2=80=AFPM Al Viro <viro@zeniv.linux.org.u=
k> wrote:
> > >
> > > On Fri, Jan 30, 2026 at 05:05:34PM -0800, Samuel Wu wrote:
> > >
> > > > > How lovely...  Could you slap
> > > > >         WARN_ON(ret =3D=3D -EAGAIN);
> > > > > right before that
> > > > >         if (ret < 0)
> > > > >                 return ret;
> > > >
> > > > Surprisingly ret =3D=3D 0 every time, so no difference in dmesg log=
s with
> > > > this addition.
> > >
> > > What the hell?  Other than that mutex_lock(), the only change in ther=
e
> > > is the order of store to file->private_data and call of ffs_data_open=
ed();
> > > that struct file pointer is not visible to anyone at that point...
> >
> > Agree, 09e88dc22ea2 (serialize ffs_ep0_open() on ffs->mutex) in itself
> > is quite straightforward. Not familiar with this code path so just
> > speculating, but is there any interaction with previous patches (e.g.
> > refcounting)?
> >
> > > Wait, it also brings ffs_data_reset() on that transition under ffs->m=
utex...
> > > For a quick check: does
> > > git fetch git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git =
for-wsamuel2
> > > git switch --detach FETCH_HEAD
> > > demonstrate the same breakage?
> >
> > Had to adjust forward declaration of ffs_data_reset() to build, but
> > unfortunately same breakage.
>
> That really looks like a badly racy userland on top of everything else...
> I mean, it smells like userland open() from one process while another
> is in the middle of configuring that stuff getting delayed too much
> for the entire thing to work.  Bloody wonderful...
>
> OK, let's see if a variant with serialization on spinlock works - how doe=
s
> the following do on top of mainline?

Excellent, this is working consistently for me on the latest 6.19-rc7.

>
> diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/func=
tion/f_fs.c
> index 05c6750702b6..fa467a40949d 100644
> --- a/drivers/usb/gadget/function/f_fs.c
> +++ b/drivers/usb/gadget/function/f_fs.c
> @@ -59,7 +59,6 @@ static struct ffs_data *__must_check ffs_data_new(const=
 char *dev_name)
>         __attribute__((malloc));
>
>  /* Opened counter handling. */
> -static void ffs_data_opened(struct ffs_data *ffs);
>  static void ffs_data_closed(struct ffs_data *ffs);
>
>  /* Called with ffs->mutex held; take over ownership of data. */
> @@ -636,23 +635,25 @@ static ssize_t ffs_ep0_read(struct file *file, char=
 __user *buf,
>         return ret;
>  }
>
> +
> +static void ffs_data_reset(struct ffs_data *ffs);
> +
>  static int ffs_ep0_open(struct inode *inode, struct file *file)
>  {
>         struct ffs_data *ffs =3D inode->i_sb->s_fs_info;
> -       int ret;
>
> -       /* Acquire mutex */
> -       ret =3D ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
> -       if (ret < 0)
> -               return ret;
> -
> -       ffs_data_opened(ffs);
> +       spin_lock_irq(&ffs->eps_lock);
>         if (ffs->state =3D=3D FFS_CLOSING) {
> -               ffs_data_closed(ffs);
> -               mutex_unlock(&ffs->mutex);
> +               spin_unlock_irq(&ffs->eps_lock);
>                 return -EBUSY;
>         }
> -       mutex_unlock(&ffs->mutex);
> +       if (!ffs->opened++ && ffs->state =3D=3D FFS_DEACTIVATED) {
> +               ffs->state =3D FFS_CLOSING;
> +               spin_unlock_irq(&ffs->eps_lock);
> +               ffs_data_reset(ffs);
> +       } else {
> +               spin_unlock_irq(&ffs->eps_lock);
> +       }
>         file->private_data =3D ffs;
>
>         return stream_open(inode, file);
> @@ -1202,15 +1203,10 @@ ffs_epfile_open(struct inode *inode, struct file =
*file)
>  {
>         struct ffs_data *ffs =3D inode->i_sb->s_fs_info;
>         struct ffs_epfile *epfile;
> -       int ret;
> -
> -       /* Acquire mutex */
> -       ret =3D ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
> -       if (ret < 0)
> -               return ret;
>
> -       if (!atomic_inc_not_zero(&ffs->opened)) {
> -               mutex_unlock(&ffs->mutex);
> +       spin_lock_irq(&ffs->eps_lock);
> +       if (!ffs->opened) {
> +               spin_unlock_irq(&ffs->eps_lock);
>                 return -ENODEV;
>         }
>         /*
> @@ -1220,11 +1216,11 @@ ffs_epfile_open(struct inode *inode, struct file =
*file)
>          */
>         epfile =3D smp_load_acquire(&inode->i_private);
>         if (unlikely(ffs->state !=3D FFS_ACTIVE || !epfile)) {
> -               mutex_unlock(&ffs->mutex);
> -               ffs_data_closed(ffs);
> +               spin_unlock_irq(&ffs->eps_lock);
>                 return -ENODEV;
>         }
> -       mutex_unlock(&ffs->mutex);
> +       ffs->opened++;
> +       spin_unlock_irq(&ffs->eps_lock);
>
>         file->private_data =3D epfile;
>         return stream_open(inode, file);
> @@ -2092,8 +2088,6 @@ static int ffs_fs_init_fs_context(struct fs_context=
 *fc)
>         return 0;
>  }
>
> -static void ffs_data_reset(struct ffs_data *ffs);
> -
>  static void
>  ffs_fs_kill_sb(struct super_block *sb)
>  {
> @@ -2150,15 +2144,6 @@ static void ffs_data_get(struct ffs_data *ffs)
>         refcount_inc(&ffs->ref);
>  }
>
> -static void ffs_data_opened(struct ffs_data *ffs)
> -{
> -       if (atomic_add_return(1, &ffs->opened) =3D=3D 1 &&
> -                       ffs->state =3D=3D FFS_DEACTIVATED) {
> -               ffs->state =3D FFS_CLOSING;
> -               ffs_data_reset(ffs);
> -       }
> -}
> -
>  static void ffs_data_put(struct ffs_data *ffs)
>  {
>         if (refcount_dec_and_test(&ffs->ref)) {
> @@ -2176,28 +2161,29 @@ static void ffs_data_put(struct ffs_data *ffs)
>
>  static void ffs_data_closed(struct ffs_data *ffs)
>  {
> -       if (atomic_dec_and_test(&ffs->opened)) {
> -               if (ffs->no_disconnect) {
> -                       struct ffs_epfile *epfiles;
> -                       unsigned long flags;
> -
> -                       ffs->state =3D FFS_DEACTIVATED;
> -                       spin_lock_irqsave(&ffs->eps_lock, flags);
> -                       epfiles =3D ffs->epfiles;
> -                       ffs->epfiles =3D NULL;
> -                       spin_unlock_irqrestore(&ffs->eps_lock,
> -                                                       flags);
> -
> -                       if (epfiles)
> -                               ffs_epfiles_destroy(ffs->sb, epfiles,
> -                                                ffs->eps_count);
> -
> -                       if (ffs->setup_state =3D=3D FFS_SETUP_PENDING)
> -                               __ffs_ep0_stall(ffs);
> -               } else {
> -                       ffs->state =3D FFS_CLOSING;
> -                       ffs_data_reset(ffs);
> -               }
> +       spin_lock_irq(&ffs->eps_lock);
> +       if (--ffs->opened) {    // not the last opener?
> +               spin_unlock_irq(&ffs->eps_lock);
> +               return;
> +       }
> +       if (ffs->no_disconnect) {
> +               struct ffs_epfile *epfiles;
> +
> +               ffs->state =3D FFS_DEACTIVATED;
> +               epfiles =3D ffs->epfiles;
> +               ffs->epfiles =3D NULL;
> +               spin_unlock_irq(&ffs->eps_lock);
> +
> +               if (epfiles)
> +                       ffs_epfiles_destroy(ffs->sb, epfiles,
> +                                        ffs->eps_count);
> +
> +               if (ffs->setup_state =3D=3D FFS_SETUP_PENDING)
> +                       __ffs_ep0_stall(ffs);
> +       } else {
> +               ffs->state =3D FFS_CLOSING;
> +               spin_unlock_irq(&ffs->eps_lock);
> +               ffs_data_reset(ffs);
>         }
>  }
>
> @@ -2214,7 +2200,7 @@ static struct ffs_data *ffs_data_new(const char *de=
v_name)
>         }
>
>         refcount_set(&ffs->ref, 1);
> -       atomic_set(&ffs->opened, 0);
> +       ffs->opened =3D 0;
>         ffs->state =3D FFS_READ_DESCRIPTORS;
>         mutex_init(&ffs->mutex);
>         spin_lock_init(&ffs->eps_lock);
> @@ -2266,6 +2252,7 @@ static void ffs_data_reset(struct ffs_data *ffs)
>  {
>         ffs_data_clear(ffs);
>
> +       spin_lock_irq(&ffs->eps_lock);
>         ffs->raw_descs_data =3D NULL;
>         ffs->raw_descs =3D NULL;
>         ffs->raw_strings =3D NULL;
> @@ -2289,6 +2276,7 @@ static void ffs_data_reset(struct ffs_data *ffs)
>         ffs->ms_os_descs_ext_prop_count =3D 0;
>         ffs->ms_os_descs_ext_prop_name_len =3D 0;
>         ffs->ms_os_descs_ext_prop_data_len =3D 0;
> +       spin_unlock_irq(&ffs->eps_lock);
>  }
>
>
> @@ -3756,6 +3744,7 @@ static int ffs_func_set_alt(struct usb_function *f,
>  {
>         struct ffs_function *func =3D ffs_func_from_usb(f);
>         struct ffs_data *ffs =3D func->ffs;
> +       unsigned long flags;
>         int ret =3D 0, intf;
>
>         if (alt > MAX_ALT_SETTINGS)
> @@ -3768,12 +3757,15 @@ static int ffs_func_set_alt(struct usb_function *=
f,
>         if (ffs->func)
>                 ffs_func_eps_disable(ffs->func);
>
> +       spin_lock_irqsave(&ffs->eps_lock, flags);
>         if (ffs->state =3D=3D FFS_DEACTIVATED) {
>                 ffs->state =3D FFS_CLOSING;
> +               spin_unlock_irqrestore(&ffs->eps_lock, flags);
>                 INIT_WORK(&ffs->reset_work, ffs_reset_work);
>                 schedule_work(&ffs->reset_work);
>                 return -ENODEV;
>         }
> +       spin_unlock_irqrestore(&ffs->eps_lock, flags);
>
>         if (ffs->state !=3D FFS_ACTIVE)
>                 return -ENODEV;
> @@ -3791,16 +3783,20 @@ static void ffs_func_disable(struct usb_function =
*f)
>  {
>         struct ffs_function *func =3D ffs_func_from_usb(f);
>         struct ffs_data *ffs =3D func->ffs;
> +       unsigned long flags;
>
>         if (ffs->func)
>                 ffs_func_eps_disable(ffs->func);
>
> +       spin_lock_irqsave(&ffs->eps_lock, flags);
>         if (ffs->state =3D=3D FFS_DEACTIVATED) {
>                 ffs->state =3D FFS_CLOSING;
> +               spin_unlock_irqrestore(&ffs->eps_lock, flags);
>                 INIT_WORK(&ffs->reset_work, ffs_reset_work);
>                 schedule_work(&ffs->reset_work);
>                 return;
>         }
> +       spin_unlock_irqrestore(&ffs->eps_lock, flags);
>
>         if (ffs->state =3D=3D FFS_ACTIVE) {
>                 ffs->func =3D NULL;
> diff --git a/drivers/usb/gadget/function/u_fs.h b/drivers/usb/gadget/func=
tion/u_fs.h
> index 4b3365f23fd7..6a80182aadd7 100644
> --- a/drivers/usb/gadget/function/u_fs.h
> +++ b/drivers/usb/gadget/function/u_fs.h
> @@ -176,7 +176,7 @@ struct ffs_data {
>         /* reference counter */
>         refcount_t                      ref;
>         /* how many files are opened (EP0 and others) */
> -       atomic_t                        opened;
> +       int                             opened;
>
>         /* EP0 state */
>         enum ffs_state                  state;

