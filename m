Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13E1EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2256B008A; Mon,  7 Sep 2026 22:32:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3B156B0095; Mon,  7 Sep 2026 22:32:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC6E6B0096; Mon,  7 Sep 2026 22:32:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9740D6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:32:36 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D9A61C1F90
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:32:36 +0000 (UTC)
X-FDA: 85189021512.11.C983B56
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF7E540005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:32:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=sIr1Rcy5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.175 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788834754;
	b=LGYNHW1tVVwt6v2fg2RGvDY5Gq728zrk8LhWalPT4d16jvTExhK0uyCVK9FLebxh0Xg23F
	ED9O/wcLa0NpMEOLdMY6/gtNMjzW6rZJ7PzA7RZQ5JW0p3btRnYDpFf7ExPnXrQ4NlYXV0
	YlXQrLgdSmVtSzNlMiBgjhdFaLA20Wg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=sIr1Rcy5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.175 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788834754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQFakzH5ezRHmdy66K1wxZ0Prtbhmc8e0YvL+1cXyNI=;
	b=IUESfTG5hjY/3B5yIMocio2UTj12VcJH76H4OP3MzPXtaQ8G6DQE0yHxD8kqtvI2CyRLsr
	VF0Mlhb4PqwvVIljoU5ZFYbUeoxE3i94FnUNen364udB9zPJ4JIjP6fcK3QoP++Hq2WFuC
	beiy6RL2GVYPxkO/F/ApniLmUZTkpco=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d91ff7d9acso34208075ad.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 19:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788834753; cv=none;
        d=google.com; s=arc-20260327;
        b=obkTauzK1selX1xl9J321G1RkrbLKONt0tEqwPinO+pTwDfceRVnnu/JpWK6ZmF7+n
         kuRhu6TzWUDXqylKl0XrpViCzqFgSzzxIofcTpTGwYxVpZcSCgZzZuwr364ELNpcZbmB
         J92TkVDY6m1u2J4l0Eq7uBLJuhd+1ZZTnfV1a+zAKiokLAvuBctL4b9xfOFB0VuPLJlD
         iDE2cei89GdV8p9/WSBu9MHZaRWV8W2haFcWff+YUo5x82FBqr9rcjACB5nTsXCP0MVc
         +JOHh6q4M7w7pfamGpWqW17sBsIGYNZGVRydlatdv8Cd2DdBWXfDf9o0SqUd64RLioDu
         FpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QQFakzH5ezRHmdy66K1wxZ0Prtbhmc8e0YvL+1cXyNI=;
        fh=Yc6aFrVueIicO/RDg/wURMli1mhjtMBZCnTXYRSPpt0=;
        b=d6Akb5ahB3Px6KnUQNiGb4H5DHM48F7gM3HRXVwzSJG3juwaiz2dYXVnJs0ZOkzd6+
         4QeN0OQnIpaAZNbxGRUCWOK105dT3u9P0TLsb+2T+djYZCeVZiGsxYljVCP7FjOzYEiv
         swK6W/7MfM88b4aUTZQuI+En66ef8LU/+knC3nHtGq+wqpNjPbRAPBqmkvw1NPTp7zbJ
         VizNWuD4IYMnHd2v3gonp9WJVv4i6n3sBrWpmcFGQ95lg0TlnNFMj0uEYD2vcdzlWYph
         kKaaw+MberWEF2iRIkRWyoTI+0pyuz7AigAbpNGkkcaKjyReo+8JoHWhdKDvIcyd60sK
         c9lA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1788834753; x=1789439553; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QQFakzH5ezRHmdy66K1wxZ0Prtbhmc8e0YvL+1cXyNI=;
        b=sIr1Rcy5MPjNNj6RkXMAXp2iyWzAeBhps1GzrV97Xn5PboCYCusyK76+mVx+otkCqd
         l26XPd5/i0xqa7HWmpqldBHVrnEhM4it/Vw9qLCdrPjcK2bnUeGs1T+gDTuhG0W+aGHu
         NtUJJtBES+FrptG7QMsXrHv8bFEww8Z7GPktFDwDt/ZmOM6AYXmheXAOkG5QgtvaaRXr
         UgILJkWqo8OFM6JWnSz72y7ZUqrefj5BMAOdf3AP9/xe4Cdde4JUG+ZkT9+LqiB0oNGZ
         /eaWCXjswzHAencg4dctNXJrtLb41t1QHmiUUDoFcnJGFMrRdp6Ww4gMO3XIVQOK82H8
         sYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788834753; x=1789439553;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QQFakzH5ezRHmdy66K1wxZ0Prtbhmc8e0YvL+1cXyNI=;
        b=Bkv0rTULlX0JntHnU7EKmu3vGb3Smmbo6AZSb6HdaKDiRWliWGSjmc4N5UKoHkaeOd
         IH/sPAzRoH3hJLYHbbLMVKPFO+DQzvPM4m2PCgOCP5czC1qJQCPqZ+76Frows/6MKdiy
         ioTVKFy97pmUg/mvvEfs6Ife+3cRZztg2ObHibCvhiwo4aoQjuf8Joet6dGW5yT3xFbP
         7Rg93pojUR8D+Afle7J04+uM1RASzQAUkjSELf4JSBrnGYBtmpFZOwjjae43nOalXbf0
         oh/1Sxeme++SsloswUDGOu6pZFojGOdvRnav+5VawyyOpPpynrx4dzg+ia78DpDuBJOA
         KOUg==
X-Forwarded-Encrypted: i=1; AKwUvBypMDgNl1mWw7Rc2WZQ+wg7IW4SETiuYFAbHF4cWMRyhuiOqlFH/Vuj388WnzeBaAo13O0cU9N/bA==@kvack.org
X-Gm-Message-State: AFuF++kpXbmNdx1QkDQetPn154UOCB5/kGda/6UmynqnrQbFBXX/ahoX
	y6L9+WueS9DaBHfJD1/SBmVSceCB1+VurSnp9GUJAgpWC7Tc8rUxpV4ZlzlGbDGp1YeRuhjGDJV
	ujjsFGzdOLOGAw9jYakVWtFLQvqBC7v/F5hYePJRt
X-Gm-Gg: AYBFou0C1kntGDwRPpSrlXXGY/xWkb3JV72SNfXsfPKJBL1U1GeLiYKEXau0gaRj9Zd
	FexkdgWQilbgqnZaGqMVAoEC/ohGT+bUGFeYhTyjTQl4OKo6vblia2eron4owhY1D1iPKqk4xNI
	LY0q1U5fvdn+l0f0HIyf6IW63xzoVJASU9UXRffidCSIcq94eNCtWO2kD8jn9AXa0jNsYk8SmEJ
	61Yi7+DAE57PIaUyxKOqWrwsVlzD7TZylVffjEhIPGZRpCDx2yIdu3y96tMIbxS/8pVOaNFzZyv
	Kmav8xVyIZB7X531RkEVqRQXg+Sky62Q0tzFC/TVDySmLVBLHb5EhKtr4l40fvcA6mLs/ZhAUV2
	W6Ez9XOkLCBZtYN7WU86inz4hGa3A/BA=
X-Received: by 2002:a17:903:3c24:b0:2db:479a:5127 with SMTP id
 d9443c01a7336-2db479a55c8mr167277835ad.19.1788834751616; Mon, 07 Sep 2026
 19:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260903090053.13120-1-jack@suse.cz> <20260903090508.1360863-4-jack@suse.cz>
 <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
In-Reply-To: <3b119174-7b10-6eb6-7aff-462949fcb49a@google.com>
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Mon, 7 Sep 2026 19:32:20 -0700
X-Gm-Features: AcwNN1WQDihV66cQ-OHH0AQpq0YHKUYC6t3qZ2Ny2_gI23ZREwXcpRRBLjG5-dg
Message-ID: <CA+0ovCgQaS0mAJPDz=qMQkRgMQ0Tco5PRFHPtQo+ForkqdgC3w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] shmem: Refuse to enable tmpfs format for another filesystem
To: Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	ocfs2-devel@lists.linux.dev, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: multipart/mixed; boundary="000000000000ef6e9d065aef8b9a"
X-Rspam-User: 
X-Stat-Signature: cfoxj7kddyqzcsrxhzxck8rbyt43bwrw
X-Rspamd-Queue-Id: EF7E540005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788834753-302665
X-HE-Meta: U2FsdGVkX19BC4IwpbYOf3IQRIDJL4BaXrcG/EejymdypmR66KIOXRAQUbVF4mLonIpbKRuUlYx1nwNbVeQzWHyw3PWclVrIv6kK9KLQmrnvPUEr/WByfTNYlyqjIndFkJ2jMT5PJ8eSrwZgdm+QVCas8HQPmHTKooLEw93tDsbnqkeJXAmWbHa5NF37Oo1GdrIgdRI61bQZy8Ly+yQJHv94cQ3b9HMuhGGrkU9vu2kvaL6QRY0MFQwp/3ot+dMBsQWyoFpOWlTseP+1K7FwLoP8Fks2inpHsBeS5P9nLXe6R/g/h9IY7gpqKM7PHTysrVx7LJUWqODXWK2AyXhKzLfPYi6YVr/IhIKKVB3fr9WPm6n8fHQ69XCqpSGZ9ehv/7UYb1VETzcEv/8xqWCIudseYHlnSHeCq/FOFx/6UqEeQ1Z35oxEBkVc2attHBYv8KDBYKl3LrVgxlalkY0XrpcZp7u5sVlktnvqbcdF7htLId7gfsKM0/aj+NZ8V19RmyUsdqmmvCRdxQO4i+kFxdvVANsWGoorAMX2fnjWULsjwpQscd4yajoQxft2NnZThUi1Lch5kyoswWqpHt0WsiUvUsFQwYGWJP1yHYSgUkc+Vevcyqqf2ztUyH6Lzqcg7l3wHiD/jd3Xhub8r03Jh6nnlgHIBe16EOoU6BfIK4LWFiBdHxmQQQjU8K9uC/WxQVs8q2DhrF1EbkHcwi7YchQDgPPVXSBtOhyfoMQjMdGMQRpTo40rqQXvkbqAQGG4s3wNKfUJWqDWsmWxQKrHRmTgf1OaoRMM6hZioEfb65r1J2b6pTRebAXqK6LPDGYgcBF3ke61aVsRKN12LUsd2P+nvcV+MOfj78g5Md5EqKnnrrja+c4rgvbZM+XQiIftTjy0jrCk9HN3Osb3sH3d1pvk1imL515zCuFbSH8/W9e1hCLsNBrahZrFn9I8MlBFGc0Ut/DTFA7RlbyVLeQ
 I2WlD9LN
 UHcrZE+NzTr7T0a1cAWinQJNy1J6BoVxD2d2aSWPVT5Iw0hUcyPcte6B4Q/vrxEGCvAtYDRq6YgT6nOdFCI8vQyHqd5vRV7XtYwGAYCS7DTkKcz/BBsWlcGFlR+19cS3j5YAo1dR/3+EsWRpqVEtR1JJVgkiFBqJYYoHYNGf4tczZXu7toeCnTQXo9i3DaB7Q6Zk6rRaSpH0y6sd9wcbPXIr3Xr0kMCR3/Lyr5L7khSgt9Z5xE4oyL3QWBZmQhUYpQNyBsbm75OVIyCF4MXG7S6J3V4l/3M07P1GJqxrAirKmDFfpmDGaKpApUz/noite9ZkEspkM17zBSmpYMwuUMFp39D7+ta9QaIpsk4CNpE3SAZ4ZtuBJ8+upVN7+EzAhh+THqrFb8zWBh/gMbG7wyHQBM7bofhs2sHhtyol+aDxZqX0zyym8DvD7sGwVpPxse1iOJEew4iX9BhggZEzLVMm/t6MyFzCtTo2mygrMXpTJCpDD7foYgoewYXQrjmGGCmEorUEUSr65neMF8Ug0xZzzfje9+rW8dBefdXDtVILJYx4gNBgzpzoBRapG+sY7sVm8FCb6xmi7R/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000ef6e9d065aef8b9a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies for the delay in response. Upon our run, the patched kernel
(this patch on 28924df2a08f) no longer panics on the attached
reproducer.

Thanks!


On Thu, Sep 3, 2026 at 8:15=E2=80=AFAM Hugh Dickins <hughd@google.com> wrot=
e:
>
> On Thu, 3 Sep 2026, Jan Kara wrote:
>
> > It is possible to issue Q_QUOTAON quotactl(2) e.g. for ext4 filesystem
> > requesting to enable quota using tmpfs quota format. With suitable
> > passed arguments this can actually succeed in enabling tmpfs quota
> > format on top of ext4 filesystem which leads to crashes later in
> > dquot_acquire().  As tmpfs quota format is intended for tmpfs
> > filesystems only, verify we are indeed enabling quotas there.
> >
> > Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> > Signed-off-by: Jan Kara <jack@suse.cz>
>
> Acked-by: Hugh Dickins <hughd@google.com>
>
> Thanks: yes, please do route it through your tree.
>
> > ---
> >  mm/shmem_quota.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> > index d0b92d6da50f..a3fa4bd93e75 100644
> > --- a/mm/shmem_quota.c
> > +++ b/mm/shmem_quota.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/rbtree.h>
> >  #include <linux/shmem_fs.h>
> > +#include <linux/magic.h>
> >
> >  #include <linux/quotaops.h>
> >  #include <linux/quota.h>
> > @@ -54,6 +55,10 @@ struct quota_id {
> >
> >  static int shmem_check_quota_file(struct super_block *sb, int type)
> >  {
> > +     /* Verify enabling happens on tmpfs superblock */
> > +     if (sb->s_magic !=3D TMPFS_MAGIC)
> > +             return 0;
> > +
> >       /* There is no real quota file, nothing to do */
> >       return 1;
> >  }
> > --
> > 2.51.0

--000000000000ef6e9d065aef8b9a
Content-Type: text/x-c-code; charset="US-ASCII"; name="reproducer.c"
Content-Disposition: attachment; filename="reproducer.c"
Content-Transfer-Encoding: base64
Content-ID: <f_mts1yf5c0>
X-Attachment-Id: f_mts1yf5c0

LyoKICogUmVwcm9kdWNlciBmb3IgMTAzLXF1b3RhLW51bGwtZnVuYy1wdHItZHF1b3RfYWNxdWly
ZQogKi8KI2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1ZGUgPHN0
ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN5cy9pb2N0bC5oPgojaW5jbHVk
ZSA8c3lzL21vdW50Lmg+CiNpbmNsdWRlIDxzeXMvcXVvdGEuaD4KI2luY2x1ZGUgPHN5cy9zdGF0
Lmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KI2luY2x1ZGUgPGxpbnV4L2xvb3AuaD4KCiNkZWZpbmUg
UUZNVF9TSE1FTSA1CgppbnQgbWFpbih2b2lkKQp7CgljaGFyIGRldlszMl07CglpbnQgZmQsIGxm
ZCwgbjsKCglmZCA9IG9wZW4oIi90bXAvaSIsIE9fUkRXUiB8IE9fQ1JFQVQgfCBPX1RSVU5DLCAw
NjAwKTsKCWZ0cnVuY2F0ZShmZCwgNjQgPDwgMjApOwoJY2xvc2UoZmQpOwoJc3lzdGVtKCJta2Zz
LmV4dDQgLXFGIC1PIF5xdW90YSAvdG1wL2kiKTsKCglmZCA9IG9wZW4oIi9kZXYvbG9vcC1jb250
cm9sIiwgT19SRFdSKTsKCW4gPSBpb2N0bChmZCwgTE9PUF9DVExfR0VUX0ZSRUUpOwoJY2xvc2Uo
ZmQpOwoJc3ByaW50ZihkZXYsICIvZGV2L2xvb3AlZCIsIG4pOwoJbGZkID0gb3BlbihkZXYsIE9f
UkRXUik7CglmZCA9IG9wZW4oIi90bXAvaSIsIE9fUkRXUik7Cglpb2N0bChsZmQsIExPT1BfU0VU
X0ZELCBmZCk7CgljbG9zZShsZmQpOwkJLyogZXh0NCBtb3VudHMgdGhlIGJsb2NrZGV2IGV4Y2x1
c2l2ZWx5ICovCgljbG9zZShmZCk7CgoJbWtkaXIoIi9tbnQvcSIsIDA3NTUpOwoJbW91bnQoZGV2
LCAiL21udC9xIiwgImV4dDQiLCAwLCAidXNycXVvdGEiKTsKCgkvKiB0aGUgcXVvdGEgZmlsZTog
c2htZW1fY2hlY2tfcXVvdGFfZmlsZSgpIHdhdmVzIGFueSBmaWxlIHRocm91Z2ggKi8KCWNsb3Nl
KG9wZW4oIi9tbnQvcS9hcXVvdGEudXNlciIsIE9fUkRXUiB8IE9fQ1JFQVQsIDA2MDApKTsKCS8q
IGEgdmljdGltIGlub2RlIGhlbGQgb3BlbiBmb3Igd3JpdGU6IGFkZF9kcXVvdF9yZWYoKSBvbmx5
IHZpc2l0cwoJICogaW5vZGVzIHdpdGggYSBub24temVybyBpX3dyaXRlY291bnQgKi8KCW9wZW4o
Ii9tbnQvcS92aWN0aW0iLCBPX1JEV1IgfCBPX0NSRUFULCAwNjAwKTsKCglxdW90YWN0bChRQ01E
KFFfUVVPVEFPTiwgVVNSUVVPVEEpLCBkZXYsIFFGTVRfU0hNRU0sCgkJIChjYWRkcl90KSIvbW50
L3EvYXF1b3RhLnVzZXIiKTsKCXJldHVybiAwOwp9Cg==
--000000000000ef6e9d065aef8b9a--

