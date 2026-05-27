Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76EA7CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 16:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3716B012B; Wed, 27 May 2026 12:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0736B012C; Wed, 27 May 2026 12:02:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1306B012D; Wed, 27 May 2026 12:02:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB2226B012B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 12:02:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8799E1C1DD1
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:02:40 +0000 (UTC)
X-FDA: 84813667680.12.B024CB3
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7B09F20003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 16:02:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EwTxFLDJ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779897758; a=rsa-sha256;
	cv=pass;
	b=VC9d3Wf6APNuEDtfwk5Vdqoxw+5DNmnazoBoIBpKhPzz4JtnB8wJX5sbzis1yEgu+Wul9j
	K+geLRxsNdWMPiR7DbEaYaDkVPt37OnKbWmcvh3H1FlwqoxdSI3HE5QJrBlRizdzaDWD3F
	88J1qVj1Sw0uREnzW8p6rhKCvlVkL9A=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EwTxFLDJ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779897758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
	b=HXE44LXIbcBEIPygD2h1+xjE8M6lO+f7DpsaG37zLuK6QIBr/nN7Bgm/amb8+n7K+obGd+
	ZH60BYr36whT2X/orRKMNYbR27xvT4PULXynwbv0y9CGOI6d1BJXS6/tXByffljE4Hs0Vv
	f/2bm7QK0KBFEYn4lxi6+F9lnpUK2bU=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aa2c25c632so6949491e87.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 09:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779897756; cv=none;
        d=google.com; s=arc-20240605;
        b=gXs+MFEofcDNGLcuaefDmV778QtQJpPuPvlYZ+qv+so/CND+LVYnK6ocL17YOsayah
         fbutYc5DCTvli4yorPqmcGiskXulyjAsStBxF7uMvEfA4kheqvfFemS5PC/nch6SCUkH
         RmyONLztJYdmouKEo2zvEJ630ZpTNwi348EbLFTsn4deSYLmIioYV6c3OvfwweQuDpiq
         4TMXs+NA5uoHKAtfKuss7+CXARccGdArqe3MtDfjgOVFwSq/joYZl+QnNLMXm7AHbqho
         7DhAmCBGZrpKArAXqmEILkOH9HnwqyPCYN8N4k493RDyXqBxxTMKt07w6pKl3GioyaVp
         Y3hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        fh=YJ7KS/a30wp8jfii/aR5u6LrwA5Rk0U6YJOrPJ5rto4=;
        b=XfsNOks/fMEe3fTj7Ee4uGSCkw5VlGS8/GoO7ulUsS7MEk9sTTg6yE1htHzEC/qzCg
         TBv/BFuKngDroxugL+ZCabupEN5pOx2F3VmtMm776AyRV/dBH6+pgRLSqsWCVdAyMt2F
         HZB4sqiTaCnaiGo0PfvZi2aHzqEzbuXlvEVcnfevPBEG/WYEcF+sz0A8rXF/KCHoovBn
         rRqn6UMRmWRLkUi+2fGYBdQwX2EMmOU1ofAbhNqgnOakMsWLR5t0LijsxcsPzAq9VsoL
         oN9Z7B3iWUCOC41d4HZGO3qi2au7xqluBQE3FRPCQQHZQ35I2Zk8JETFgXCS+wLWbvYE
         E9Ig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897756; x=1780502556; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=EwTxFLDJegjFZu5FpEtZSE3JAzq9mgJM38n6PzPOIy+UhKUBKswIF6CewRUM4dRj7x
         NNwgg1caGmFLpMeIQXgMI7P0fIksPZZLcOtSq8hzQUhHd1Lj8M/CR3ge4ptz/YkgGC85
         qrtoHz2feEqTuWad36nVk/NvJZN2HQ5uUpNHB5Vd+KSbWdB1FEiflUkIoLw4oIArsEYT
         xwJOeRuwkGwpE9IeZlK0TCXsXQqTHkd9X0fu9na6WhbHp5g3m83yZuFHixiwfitgRV1u
         u9+WM6fxpPeVto/ET0BS6hoK7KGMkOhF3Bn9NP9InGxFHFtqv38gbm3eN8VvmBf+CH5R
         OipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897756; x=1780502556;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z2Cy0T5Ytizh+1Br6nvrDriJnRVK9iMYXygh/HS+xaY=;
        b=NbNaGESXNCOFKFuqtcTmMp3QjYPUzaB+y9TYy/LeY3Zri1GpZc6IbD3ZyiPJqn1xUu
         NWFvCT4b0SpJzWaT/gChYQSkomVW/Rjbvldnq/RxDqHqeWXsjvQJXxOtS0pLXa3sgsr7
         wsSwvwr6fjPSjytSs+xF5uPlYN0pIwGf7o0CsLCGZRGIt/bDbz4EiK7wB9/nbv3kAQfi
         Uw5ArNU2sAus0EvGSo+uDDcXVXyqlV9zZzHSFeHVipOLriioRmM5tmnpZNQ6aFuZUyzK
         4yPgtWa3RpZMnUleTScDYwNC0f7c75oy6sOe9/aHe7Dc8y1UezyOVsjdF5VX0MC2/WNr
         3q+g==
X-Forwarded-Encrypted: i=1; AFNElJ/4sHw0/Uo3v8sfn6AtCMnhB5jUCWjGQgPdNf3d7Tb694ZdBIHejln+WsrMFeCER0PiNLfpTD6lhw==@kvack.org
X-Gm-Message-State: AOJu0YygIVS8L4xzJ9Smi/Kgph9yMm3H8+LhmbOFC7nWQ5gyHuoYT/tO
	z7086DQ04yLLTtE6kZfjEiezQRr7JpvhtGjFtKaSzQykIUxiCp1cbRheRWOnYSWGCOSmFjelSRm
	9ySs1sSLiRSRaHxP4Tzwy10v+cd8BDrs=
X-Gm-Gg: Acq92OH88ToEvwYHhdktbd+qj+sfpDiLQVo3Zg26/2qeFeOyOeXTbKIyPOX5wnR4Hij
	uYzyzKMmxXBXSgyh/ZIC4LX6sxia++++xYgscahARzGfFu49nTxC6BOr/qcZQJCEA2/KeIGE4j6
	+0ILVHf/3BB5cejzOTcSGcbb0MLJjNBhfqnCZLtPz4Opoc6UsYams4rcjk8d7PKvLGhYJDdWfqg
	XyvLy/Wuh7ZGcuPxALC+1Nh/vJcRMQkg9mrO42go6L1jR6pq4r3PRdGi4VBIUBVLk+RYZvxfdpE
	TPLgodug
X-Received: by 2002:a05:6512:1082:b0:5a8:96cf:c8c4 with SMTP id
 2adb3069b0e04-5aa3232a140mr8148267e87.15.1779897755653; Wed, 27 May 2026
 09:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-4-275e36a83f0e@kernel.org>
 <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
In-Reply-To: <1bb537f6dc36b00788b613fb8f71579478418457.camel@redhat.com>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 28 May 2026 01:02:19 +0900
X-Gm-Features: AVHnY4KetSSI45sZ2YEgAEZTRsUQAA2DaTD5AcJyh7fDYB4FmiHhDhxOxGAj9DM
Message-ID: <CAKFNMokr_mk8xhMQ7u8RGRd1XPQSSd_uVKXR=-ui5Zjk8AhfTw@mail.gmail.com>
Subject: Re: [PATCH 04/17] nilfs2: replace get_zeroed_page() with kzalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7B09F20003
X-Stat-Signature: smaac8yr5bej3rw4qbi1p9mnc7das9gw
X-HE-Tag: 1779897758-796559
X-HE-Meta: U2FsdGVkX1/kHn0b7hE2nCdjes+IhncW76xgBwaGIuzG0+wOIYaFnMvcrHwP5t8on2h9IkjhbfRGjUOeeyMnt1nc28Zhs6e98BIEWXSd/zkOu6lOGs7JlwokElYM3DQ++V0AX8sV5s1/BDDCpYYiH7nut29OEVn+JPlpXOiekL2btyITXsbcKB4pBz/m2H7htZl1XKSY8sYojd4yrzk7PVdV3ywsamr/k3sNnqe68ncyufJct53dzgZ4LnVhYT4zETn3dxDUgtAbDg/TEHZoQ+jE8tJbkqs4QejA5Eg2qyQDufH5RG+DKrXUT0fbc+SjZvlny4PjDktVYPzMVnvJFPP/2SSkK4/Jm/6qdckYOrf4MbzPaSFD2w95a+Sv9S9vS6Vxzz5Cv4lro5pezdVktslC9vafXObgfL1Ss1p5LCWForHgq9l9Q2pWNFd6mzFLU47wwSqOJI4eDfjAYE0hh5y4LJoXO83Z8rrssJfBoQqu1awlAlMl0cOjTkIB/InfqZm0UZGA/NF0nG7MAVk7nlxlinez8D/uKT+4Xok8IbtSLimT98ohRDxeqgFTvZHyoBxlb6x1FNsjSkWe2V2aVwupvBfHMCYn1RyvdoG5ClYhCygxuLQ2fIgsU+z2L3A515naXKGsbmoKJlWIWZO3fd3jJAQkMf76syIu9OEouBnKYhbdNaVkf7x3Pb8gsQi6e5VNRYyVdsjrCLLbEdDpw1LEeHpsbNhbP+J4B1AcpfDmYNUWWu3NA4hc4bc/M9ctbanyet2I9ns5/+O6uJdSXGITF/N1C1iInj0yUUcF6HHhMvLwCHq5oI09hXAAnEgrM8jHcTONsPNKEUNKT40KmJkHvQPyxHxOM4PUyz2SJ8JWM0XWe2vKfFist9SCz1If3tzSUcY30RbkXwLT6liyp2+AZeGsuAKrLXodQ3VavW7JUNsGCgRTcb1UQqlYgNIGw30FbZDSiHgYQt3C+YO
 4SPK0H4q
 WTooTrhxiRGWQ7B2ABKNmRGIa9KMuhZMgiLMvtvnNI2/RgN2klVsMyrTvMsaj2jCSHkC/k0U0V6516XDCAz69CWMzLHOC8LliaVdV9ouwpXybwFp+zA76P2n1tIKABzS7Eoeseg12x2BSrEK+u8Y39gIK1GcdYQAaLIGbo2n+nTqOMuqUalMvRWzUzWDk4jTja1kazR/uEXim+mHp1GIYHOQUjfGNg8h6Uu6F9wKCRLptd8APci3DCkvuZzcKmLM+Vzb0sdts+0+PAlS11d9tvDGo0w+vWh2pPAThEMiXrqmGalIdi7WyD11tftlIqHKoMvWF9jw5a7dupkW5RNrQkoeh1oSfUSuiG2DCM25agMAK7yLyJRKKpUFtVfT7xd7FudKOSM6simFrR9tVMeyG7h1EPrvHoZKWJYv1wtcK8Y/9HC3MjkZNqkTZoVHCwwecC/HUeqz2W+xoMKV+xxoedLzW9k0ZyR5ohpdO8CAh/65RC9SZ/zNfQDadH+4vG1wwNIjww/aAZOFjjgDNv3wrMA8OkP3+5/usHhe+Cj2lzohJ8mTnJn98BpPeF20XXjV/lK1hU/htHQ1bfd2eHj02noqYIrrtiy9fqc34OdZ7XIeKjhYN+lvwp/bEC7htRPul20bA6OGc6NmKbX+L+uf1QPJn3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 2:07=E2=80=AFAM Viacheslav Dubeyko wrote:
>
> On Sat, 2026-05-23 at 20:54 +0300, Mike Rapoport (Microsoft) wrote:
> > nilfs_ioctl_wrap_copy() allocates a temporary buffer with
> > get_zeroed_page().
> >
> > kzalloc() is a better API for such use and it also provides better
> > scalability and more debugging possibilities.
> >
> > Replace use of get_zeroed_page() with kzalloc().
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  fs/nilfs2/ioctl.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
> > index e0a606643e87..b73f2c5d10f0 100644
> > --- a/fs/nilfs2/ioctl.c
> > +++ b/fs/nilfs2/ioctl.c
> > @@ -69,7 +69,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *ni=
lfs,
> >       if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
> >               return -EINVAL;
> >
> > -     buf =3D (void *)get_zeroed_page(GFP_NOFS);
> > +     buf =3D kzalloc(PAGE_SIZE, GFP_NOFS);
> >       if (unlikely(!buf))
> >               return -ENOMEM;
> >       maxmembs =3D PAGE_SIZE / argv->v_size;
> > @@ -107,7 +107,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *=
nilfs,
> >       }
> >       argv->v_nmembs =3D total;
> >
> > -     free_pages((unsigned long)buf, 0);
> > +     kfree(buf);
> >       return ret;
> >  }
> >
>
> Makes sense to me.
>
> Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
>
> Thanks,
> Slava.

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

This conversion looks reasonable and won't affect the behavior of the
ioctls that use the modified function.

Thanks,
Ryusuke Konishi

