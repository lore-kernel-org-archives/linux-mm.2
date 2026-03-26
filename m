Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D48E10A88C4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B687F6B009F; Thu, 26 Mar 2026 11:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3146B00A0; Thu, 26 Mar 2026 11:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1BA6B00A1; Thu, 26 Mar 2026 11:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB1C6B009F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:17:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5040BBBAEB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:17:00 +0000 (UTC)
X-FDA: 84588567000.03.FCCC5F1
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0018C80010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:16:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Lt2mh4XM;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774538218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQdnRxJuJ5yHGcAApglVRt5YekVdD3xOtgzSydlym/0=;
	b=ZLRGTK0XhjrzqWQBXlnZl1uqxIn/gcEmJj2k+eL7mT3HbUhudrWdB9CxhVbO9XVhQQs8l2
	pLW6bSd8q/gEwIGTYOC9urrS7Jzn8zGdxeI3LKZmVdMDaV8BKNsffBafzeXjJG6qxVruPm
	wOSiK9dm1vAAamZSBlo0jNFivkXGc38=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Lt2mh4XM;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774538218; a=rsa-sha256;
	cv=pass;
	b=tDOf9hS2UrCfz/M/5k+S0QZQDkZoP14n+RUsbqHC1Y1PA5y0FL8v6qg4icC6tRlhfOcj0w
	zSbCAlQOxZbmMSTUqMTFZq1hQVrni3lGgndkS6XD+ItuITa6xDC6/MZKcezGfMFDS8Y4ls
	4uvD/wKwVaZAbdOtHaVWh6rjihhcIL0=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6674cba2c50so3385226a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774538216; cv=none;
        d=google.com; s=arc-20240605;
        b=O0OaqzQee/VzX+Y/Y6CtkBg75crLojBOuoFd9YkGibIdpXDn/raJECjRlbsFRjt5Zk
         4QZKjs2XP/I9bcAY88C1v/hr2k1/hN+AziToZrbemOrrSEPZx20NfaREwEblvGUfjW/j
         mNN3XNVDlGnAMRsvbWAb7t9/6xrzKtwt2VnGSYM+5KeR/ecUPzliT4UX011/VGlhaC25
         prKjw3P4Y29D96UXKJPJfOAXiwsBYPYKdbUUf1vM1sTdK7lqQ83WsWnIdDgocHnby4Dy
         3kRSl2qlNTrQ8RBF4/mZOisQIBasDKCJnhCZqblQ78nvs+ZmHuaA9M1FdBVt4QaHlqoU
         MJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SQdnRxJuJ5yHGcAApglVRt5YekVdD3xOtgzSydlym/0=;
        fh=pewte+rkhtd196mO3rZ6nB/FEEST1KYu+pl0vQ3J7OY=;
        b=gxv8DKytapIMmkpD63wpfCrjO/uTLslQurGZ0+x2si4ymyt0cNHs0YZhsKVdCzSFzE
         LkGcrmo9B+ALzdXiq4r5bz680EVPGTsvztIOw18ix/Iy0Lf6JWmRGNDy6kztRYM4aKP6
         By/M2wymxxipI5saqhGr0jtB/scDQVRnlrGQlB96OA/CDmdN2MD/STD8K+9vttLkqbjb
         xD99hqCU9h9vPev5GBl8geEh/sdiEUvwJe3uVI/jRfVm2NxgZlzH3lzQeX07QC1bXejS
         iBmsiPNwgTO6DyuR3Cdv6C/xguIhRUkpuvk8jqRI1sT7TNUZcZM0y5189qrFOYNgP8XV
         apQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774538216; x=1775143016; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SQdnRxJuJ5yHGcAApglVRt5YekVdD3xOtgzSydlym/0=;
        b=Lt2mh4XMsCi1Ap0fAbUm6nLD4mteOEMLDWUKBScFIy56zZdptCyGS0yXnMrr4mfgB/
         Fl/sNCv4AazH9+/Wz7sGLzN7KdDKa4CjULYItLdj4IVy93IDt94y/2+0A1njb09+x15k
         b05UQvQ3V+wCkAR3f5Y6Q2cG0n+Vtj5Vh0sMKQ5ADgRt2q0A3Di7dLNU5DIT9o6n+4qB
         QFbG6NxUyLp7mFNLoNZCT7SMYCti04AgheFMekUBAIc8mrqMTyVmbNwwbsto79keYFb7
         J6+wi+/IEFeUG8nq7m4Qh+nv61WQorbZgSCTfruywlOeVSRc6oQ7mXSyLo0CbjTEB0m2
         7i8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774538216; x=1775143016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SQdnRxJuJ5yHGcAApglVRt5YekVdD3xOtgzSydlym/0=;
        b=PURLksiYcWTUlEkmhRM9Oplvzd2Q6WRwdWFYh5s+nzB83ci+FkX9anL/8ck9rlVE4x
         fBtrGkAUVLBcp1pEESQMJjSbXnRV50KXJxZXjOC63hLn24ayeorT/j78V42wjFeFNZC+
         Dk2+iq+UexFR2AwOfQrqgDPBwmltr+j2RKFIrlpksbc16pBMDQgNkykCXNRwpedGty1T
         NNViUjZkOtSI4WJj5IB/L0toy05K8vWcJ5aVd3DZckL0W/Gq3jyZpQ23ZpWCIrSzZbzO
         qM6sUcHvMUp1qbm4r6J/jwPNOo/BD/tr6AF+LvybQ2uiS0ehsg4R5VdpPeWKRSs0mP9c
         URRw==
X-Forwarded-Encrypted: i=1; AJvYcCV2HGV2n708yivwtYv6uKoaZJeKmJHLP7kTZKSi7ib/YS1oF3RG3a3uHyaI9ghSc3/s2I1D0Bx/6g==@kvack.org
X-Gm-Message-State: AOJu0YzADlrcD5OMgDGvxf2sps7c1cF2omA5NsY3FIOhpMK1OzRTOtD9
	U6ksRyNnap6oWItayHabQvRRQrf0H6i7oJ1QaIfCb2fkrgoiG7cacelyl+7LbZPLyZFS248PeW6
	WsS7/trwsFr6lSrOPn1LmkN/8vefk1Ck7+Pb9jT5Ypw==
X-Gm-Gg: ATEYQzzz2wutONdm5tF3nlpSuDC3jiLpkzEYtf1qC2/hBkoEcZgGG+eYWRQcMRnHSSL
	iBSzw+n26G6fyZFxNBWwG3hCyW259nDCDWiLHVgrlshXmXUCAPmdX5SgBUJo9SBuBWPd78j7M05
	8DaJnVHw/x7we7V2vMQbHG/8ivJiVTTTslyGqJHBOWYH4EPzzTGR6tsrqKz3lo0PZkYP+oaIoXi
	lh77nH0s/nrIvkY2I+F1fdVivt4GRKC6zmCxMacbsVQ7+NjcFLgcTwAFdMzKq7/IgVfEco6jNG8
	q5v6qMuRShXr8x6WBvIKuj9r90jNi8Mm0ETqGg==
X-Received: by 2002:a17:907:1c1e:b0:b96:f02b:3d5a with SMTP id
 a640c23a62f3a-b9b2e9b5216mr156822466b.16.1774538215766; Thu, 26 Mar 2026
 08:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
 <20260325182026.467307-2-pasha.tatashin@soleen.com> <2vxzikajacgc.fsf@kernel.org>
 <CALzav=eybgJwMQEtvSi2bUv8u7cic6d45r4wFZdZiKFFrrLJfQ@mail.gmail.com>
 <CA+CK2bBpa8ZnxPdsPCRCAiPeHUbqQ3TNjHTGU2eN_BGqqX2Y1Q@mail.gmail.com> <acT2lYJKdyXXzNPZ@kernel.org>
In-Reply-To: <acT2lYJKdyXXzNPZ@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 26 Mar 2026 11:16:18 -0400
X-Gm-Features: AQROBzAaQwWi1mw7VLq4yJOSwB5PsmUGIPySwFNBSoNSp2gOncmmJQuI5qB8fRQ
Message-ID: <CA+CK2bA7=XBFVy1iS6y50v_TUxQPFbL182DgprkxeAh4JHZRoQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] liveupdate: prevent double management of files
To: Mike Rapoport <rppt@kernel.org>
Cc: David Matlack <dmatlack@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7awsptt3rhifeyd6d866dntthyzh17bz
X-Rspamd-Queue-Id: 0018C80010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774538217-690016
X-HE-Meta: U2FsdGVkX1+G0LPrQoz2P+9kGtPIuvIjIbxFJnhwdJ1cPCpbhYhYA7+Xbtumi0JwvX8qLwCJ1H38wguarU1l/ftRFdkdbEMICZ7fWXlT46JnJFOl9YgE5/naBn7tgOWJhWTshl15YVwUku1+JUgOD3UImEyuESRiT5ZCAg8L8kh09Ko2GlxdrKh4hBsBJFWxoA8l2P8ag0ifki7eZfiIZRuQgFGJ3ucS+AmiU+oOqZV8IPMmXQXueGCSBVMYQhrKLenJvhlKSTB1hStZiFtp4fCwBgTsfWYnxikIZzs4CxaZ/3hw1vADpPz3JK1LIssHIS3cwb7V0D2YVCGcxE6+cE+Gn4+NuZtMc2B0nEaDC/TMT/ppA98umahwQWkTHdQX+I21hj73+YPNUUVXsVkgS6gurZmf1iqk1XYNqf3KKO7WN3HDRpESRwtcptcsSLoleQchSd5D93rG18XqkHfjl2cqapmcOOUH7xUMNDESY9l+lBN4y/wOzzjG6aXZmKg/SHn+eBpTsgF8IQ+Vy7CSg+M/wtY/zqgFD9w//aND2a20BJKtWVnqEms7P2xSmesHnsS7vtPAmAWmUcoenYrMvf6Nk/AIPUtLygjXSs0B49L4oC5hnaxrmebjH5sodlgLXyQdQAmf7l1sY6jHzaJCP/2oHU8Li7/JzsaKKrHf9WCyzjs0LjS02EQ05TqUdCWaH+B2989x/Cd+kp/657fxfYQzQO4/opg5z0I9R8L1pBFXsp5CGuHie8tmjYZamka8zrcspn/YPLtY3utzTKsCJ5CM/Tudsu1HAuV1909iQoyjhEUPnFjWim5Za1YcD5AMNa98KT0tjHEIeO9lgPjIc1MArs0tcy8Up2Sz8PqyiRlj3C72pMDNt9shA7t6BvaSWyQ7Ih6zn61d2vXVNevZqZseHDhWJMZHcxCHhK4Jal74D+/on3k0vXKcFM52hHCFVc+gz1gJsZjYuiQyLOb
 ZmKEQYiF
 wWymgIVbJFWPmYYORwD5mQSHUugyAt86dUoHm1YB88IOwWvVJlLziflyZPs6ZiKR+Nnz26zwXILoRyOA9mrUT1i/bnzsI/rYZfZ6YfG4YU5BNUEaoldIKEe+U88pvzEkF/3HNiaNMrtdqQt7NhZXFlVJigGJasKP9YDACkcIo949SumG+80Zk3Dh+OA1dXyONVutQ2L9Nhu75qHboPgKxEM1et5opbEPTrPmv91xfhvWec4sjXqJb0jAvn+jJakmDx92jy1pbM6xlQgEe8OU/wd5I9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 5:04=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Wed, Mar 25, 2026 at 05:08:57PM -0400, Pasha Tatashin wrote:
> > On Wed, Mar 25, 2026 at 4:34=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On Wed, Mar 25, 2026 at 1:20=E2=80=AFPM Pratyush Yadav <pratyush@kern=
el.org> wrote:
> > >
> > > > For memfd and hugetlb at least, we serialize the _inode_ not the fi=
le.
> > > > The inode has the contents that we care to preserve.
> > > >
> > > > So if two FDs point to the same inode, this will break. You can do =
this
> > > > by first creating a memfd and then by opening "/proc/self/fd/<fd>".=
 Then
> > > > you would be able to trigger the preservation twice, causing all so=
rts
> > > > of problems. Same on the retrieve side.
> >
> > Hm.
> >
> > >
> > > > So unless I am missing something, I don't think this approach will =
work.
> > > > As much as I hate to suggest it, I think we need to move this check=
 to
> > > > each caller so they can find out the object they need to serialize =
and
> > > > check if it already is.
> > >
> > > I think LUO can still enforce that the file is not preserved twice.
> > > HugeTLB and memfd's preserve() functions just need to also check that
> > > the associated inode has not already been preserved?
> >
> > For memfd/hugetlbs the true state is in inode
> > For vfio/kvm the shared anonymous inode is just a dummy wrapper, and
> > the true state is in file->private_data.
> >
> > I wonder if we could use the XArray to track inodes for standard
> > files, but track the struct file itself for anonymous files (we would
> > need a new function from FS that allows us to determine if "struct
> > file" has anonymous inode or not).
>
> Don't all files we preserve use anon inodes?

No for memfd_create(), the inode allocation path depends on the
presence of the MFD_HUGETLB flag:

1. Regular memfd (shmem):
memfd_alloc_file() calls shmem_file_setup(), which leads to:
shmem_get_inode() -> __shmem_get_inode() -> new_inode().
The allocated inode is a struct shmem_inode_info.

2. HugeTLB memfd (hugetlbfs):
memfd_alloc_file() calls hugetlb_file_setup(), which leads to:
hugetlbfs_get_inode() -> new_inode().
The allocated inode is a struct hugetlbfs_inode_info.

> How about we extend the fh->ops with a method that will return "unique"
> object?

Yeap, this is exactly what I am proposing. Adding an optional
get_id(struct file *file) to fh->ops allows each handler to define
what constitutes a "unique" identity for its supported file types.

luo_file.c will have a helper like this:

static inline unsigned long luo_get_id(struct liveupdate_file_handler
*fh, struct file *file)
{
     return (fh->ops->get_id) ? fh->ops->get_id(file) : (unsigned long)file=
;
}

For memfd, the get_id implementation will return the inode pointer.

Pasha


>
>         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
>                 if (fh->ops->can_preserve(fh, file)) {
>                         unique_handle =3D fh->ops->unique_handle(fh, file=
);
>                         err =3D 0;
>                         break;
>                 }
>         }
>
>         xa_insert(&luo_preserved_objects, unique_handle,
>                   (unsigned long)unique_handle, GFP_KERNEL);
>
> > Pasha
>
> --
> Sincerely yours,
> Mike.
>

