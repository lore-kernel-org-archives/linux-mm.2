Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1D0F3D329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:12:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2426B0005; Thu,  5 Mar 2026 11:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36EBD6B0088; Thu,  5 Mar 2026 11:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 247566B0089; Thu,  5 Mar 2026 11:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F32B6B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:12:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA74B563A0
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:12:31 +0000 (UTC)
X-FDA: 84512502102.03.28C9712
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id B57EE40016
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:12:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K8gO8SQj;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772727149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9xcduMaGwL9FwPMCpELebLrVqeCBmti/yDZTZzj9fY=;
	b=SSwjwWFLZpS7QWjrejOksHJFo+tWtLBmXzNqKPZGToeB/be2b/c2hGO0B3htAXHpfPmMSH
	9cHQBcFzHchwE8McBHjTZFkoPB4O6LFvsZiCdA4Imtp6TEm9sIKY4ONVu+GMGAoJ6RtD5+
	E7PUVaXziL/+xsBcEReFDcP5MfwbSvE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K8gO8SQj;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772727149; a=rsa-sha256;
	cv=pass;
	b=oSyPt5HJTeELg1fQLciVRsc3KutwNJfPVSJYFemD+Qdb7jBvaTJJPJlzOPmnePhlhu/zKO
	fStkABhFFdFro2D322gKl81Ap9SRpjjWdjSeyr/Fn32E1IPEXmq7ZlxCpVPxA10eu2r3sB
	hSiyDGMK4Qr+17Oeoyge0Q6p/5VBAUw=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506a355aedfso599871cf.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 08:12:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772727149; cv=none;
        d=google.com; s=arc-20240605;
        b=BxASyfAlgRAW2CIvUVJpJu/bMU8gqyf9VrzhXD69SZ48WbarWRoo71KZytsZD/TcaM
         I0ht0W+00M9S9YZkoK/sR2yuh13Lb8CZL+VZBXxAJfQ78hfQdMOGuy7qykQi4jkIlHPT
         CMGGxcgEpvIggz8xmIT+zFnXiqCxZCSAiFUqakA7hEWgpvhZ3gXUS7U7DN4Rk+wgXULm
         yKswJdGo+w7IFhVj9D18T/MVcdc2Jalw/jS3ifZ6cyIfkQT9G7EXWqcxeQ6FDKmgvv5e
         kS+PX6d94aeYspfAlheAAD3CfrmxfSGianRnfOyJkK4Gf0PNSgg5Di7wQ6afAmmOzJcU
         xgYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D9xcduMaGwL9FwPMCpELebLrVqeCBmti/yDZTZzj9fY=;
        fh=4TeefgMwcuFOUcfW+ZeYExaqd0nBZrwUtrLYWGLTBRk=;
        b=HBv2Vy8h16aYceSmqkSUdv6Svn1uXICABBzbENAMSxjttcCzwKcw3xEeXG8wP5fwOU
         +ndzbqsF+NdZY1dtkwsVC6UQp65pP8DzCn+WsBWrWvQd3MLwYivMJwD9Y7rs8uwAj6Iu
         tTzSjWmhwgMUvNNvyeQHktDtmlUB4IrkXcmOfvPHaQpwGWbHcj2WLASVhsx7CEXgp2M6
         /pYrbQJFyV9HvkSXUz2sRoyxuKfkz4NMZQxkMq2+ifTalyOCML0ItjvFrRzvg1XzMr6b
         Zy6b8HDVa222eKVAT4Q18XpisYOYwldYujdOi+z4yUkpZ/Ru0O8VO2/6ff3IrwzQSxM/
         NxOQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772727149; x=1773331949; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9xcduMaGwL9FwPMCpELebLrVqeCBmti/yDZTZzj9fY=;
        b=K8gO8SQjhW8hWMQIS5IgRqXzv7pxj9txc1jgnTNyEBYbu6L4QryTOs0OtkeLHbmqt6
         Cyq7DeDhfq9DY26K83E6oA5IXnY5NBLy1Si5AwuFgwlY7sVUAQnTXjlGO7FJbgHhFRrt
         HA7D1789dehiFIG9EW8EFhSDOA9Tb1hsYLiq8cYRQt6Za3ZWrxxHBU26A30ztVt2vbLP
         Sr3Jq7hWvpL23QO7vV725kXQFbzr6uN5i1utCJrsWH5OOUt/eruGDfT2pPf5l2DjLWNS
         BOwcTiLPm305M61oJpcYDq/GsJisyVfm3xNDx2x7vcZJuFgZ0fOBOOlD76hGVDby3054
         eGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772727149; x=1773331949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D9xcduMaGwL9FwPMCpELebLrVqeCBmti/yDZTZzj9fY=;
        b=hN0bIvXdwawqRlbLLlZYJ+psDIf/SuRbdKX5n0H5sVhKrC1Aq3Dxo8U5d/HpzL83Ew
         2UM4sCzARi8Dr9XpMVO0XjZWkER18mWLJtWBJoDzEvLTqOzokMvlYta5E5lFukuJv29K
         npLMs9RkeY0D8Kvjvi8iBt6b8cMyZe681FY1kJrFTBwTtxlGh4bKTKFQb4ilC/f1ZyYa
         nKAOWuwCwjTaMP6v2raNosCS/VVfnfQmPjf/VpcvgkXdtrG30DeDbFBbduYTJ6s41VMZ
         7SFeyXx2tz2rVWGLXW4duMMCqw0u3kAFvxpDFIRucTNjmgaBe/zbsAOh9ur+xTvWexJi
         csyg==
X-Forwarded-Encrypted: i=1; AJvYcCUcpzuhwE4ybWRJmXvvbKmEOcJK+XFOI9e14FnAbqRSzmd9wLp5rD0olbZN1VBAGmio+uS48yxpQw==@kvack.org
X-Gm-Message-State: AOJu0YzXY4gMvwpvV3d0j3fN0+RE36CXmBwRVG651h8GiJ8jVhDFNrdB
	9OGGiD4OYvXWNR6IXl1mzLLlcm8uSL8wWsvD5Zcc1dZFaiaD9/1Vy/UXADvvPLQBiI8rt7hRQ6G
	8x3CNY7pPd4BqagTPh+ugWt5ySvbccLsgzVoTk8SD
X-Gm-Gg: ATEYQzzm9W7HbFv8OqPwD2HOT6ZSlgmA6QlmqS1nsV9QFwCqK3hxuQ4jZ4ZRusUk1Qq
	pEyJmNZPLYTLVUj9aSlYo/JDIn0P+4XtN7drSTwZkloUE+3HbwqVTExdabsEoPFDE8HrWYBwbat
	okT1pX6mXayMoKueGfFq3AVmDfv3UFYGqtBPC9JfrppfkLHa0sq0H1428Serw90SFly0O28X4Iw
	bhGkdF9Uk4R2i28sdS3mUprRUdcBu7g/BvLbC/okR9r3s+Xn/k27WssFv2udQ30FKdp11v8KMS0
	gxG4AA6uMUvQ9ifboiAuN+MmadJApGe4DTPvzFPTuvz2LByr
X-Received: by 2002:ac8:5710:0:b0:503:2d8f:4cd9 with SMTP id
 d75a77b69052e-508e5e5db04mr11948791cf.16.1772727147711; Thu, 05 Mar 2026
 08:12:27 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-4-surenb@google.com>
 <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local> <CAJuCfpG_bekxrHd49qyUBR2K7V8o7DrOvc-ZR7M8dAC-Hyp5ng@mail.gmail.com>
 <50987b7f-39ec-479d-9700-317cb0b95e6e@lucifer.local>
In-Reply-To: <50987b7f-39ec-479d-9700-317cb0b95e6e@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 5 Mar 2026 08:12:16 -0800
X-Gm-Features: AaiRm50LWno2c0MkglZEwe8geA6lFAl2tQxTaGHqUvTWhHATMXzeTZ4TnJgkQRQ
Message-ID: <CAJuCfpGEqjGZcMiY7RommSzO7tOrW8Zz-Web0o16zd+HX9JU3g@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, 
	willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B57EE40016
X-Stat-Signature: 84afaqyujcurtf4nucp6frk8mwnsw3pc
X-Rspam-User: 
X-HE-Tag: 1772727149-521845
X-HE-Meta: U2FsdGVkX1/d36PR8JXMhtBvilBp2X6rfPdGkw+m5gmPhzsVHzN3MzQC0zNzYKRAho5fvdtl2RaXE3NiXXTfCD703omATD+2XfkJgxPFje1P9H2JZy/NxwK+MVEiZMRWNNR1mDpnHyC3cp+opqliqMDMYhrQpynUS2C7yXDhMbGTClczeB2ji7OBCsMfZ0PLYMSHr4M8UbXWntbx+vwfywIS136QKZjZvTU8pTwkkmIcmtj5+xSLXuGYw6EaOd9Ee8mfTJC/wlMZuRhNhj6pwp9y/jtlbuXRPeB6gqaqZKkneW+XHyHalf33wjlo8XGHtzGTzDkm1GVYnPT2cN0bBWm9H8SQT0moeQFltXlFgkL2V9x717z27d5tAB2Qot14Ae5LT4H6MwrsZhRZNY6TRVuHzrmzlu5M6vQouswBUGOv7WjyqXlWSzq+OFIEpdlNF+XrzGkYBVtrJyYrGRBcFitf3TZF1wW6g0qOjlPED7rzeTXvyXOWujakYMFr+86iOegLhiokZKxcMIgOEj1EbmccAhaL7dh1pGe98oa3Dtttdd2kdh4ZIalLqPOeDKBEUNEvVnLwebOVky3TiRzOSWr98MDIF4uUZRtyo1ann6LRazhPByrgLggcfy354UDVz34r/L34jkD+ou70pLv4NOe6t0fmatVozkdGBr6MZxfqlpm/qY/5geyUkWSQPEH6AuCEcJVNFYtbnej2MfgH3gOBGv+fUAN2hWWO8Cqux6H0Xc0ddSvAlA9fTe3KXUOhQ0ymBZ7BS3xpgvKTMawVglaaOlyeGQ0nAd2cbNo0j+1MdQic1QLsb7VyQw3R8X/pTnQvwq2mKEy/R0lgpfwC/xa/o6hr3jCv5x7SOjaapAMtLRHp0cFEHh9Ji2e7w3ky4dcirjVg3e2wTHLl0WQTyZCpx1URr6rJnH+mM5zNXMRoaAK7LOt1DCiHR9+7IozaL/NghxDTASItzKM8NnW
 IfWvGUGO
 DP0yzt1ccMQrs3KZ37Etrsm6+wGid/MyrXhCbWqTLJFoOfasuFc4g7W4REkrvFqFKMg3gHp0gQu+h3Lij79XOxkeScdXMx9mS3DxpOli/czXKVve0u9ZeGBsE93ICD1VbiLKPP0ZsMImNzk2O4vYBdD4qX50LML9waleFZGEh8dJ0eLOa0i+6XN+ZjbJJgekk23bkHQqdGJ18bPgCq9PykIJ1kv3d6Z5A4xo43Eho6UosIGL061flkGbgOlHOUaTAH3ue8GJ0R7e0tJ9rxk7eLdWn93wUnTVXqA+/yGxqGxs8Asb7fSk4BgECmFRGEHJa/JmSOG//hHHCYTJgJx/bTs90i+xdPpiaBLysOUTiWtgRhlf++PSXR6HB+oxzZAUK0jDQR1dXfj2XAkYRpIepXAXrMHrVem22SP2gbNCu5Y/elyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 8:58=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kernel=
.org> wrote:
>
> On Tue, Mar 03, 2026 at 03:59:17PM -0800, Suren Baghdasaryan wrote:
> > On Mon, Mar 2, 2026 at 7:25=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Feb 25, 2026 at 11:06:09PM -0800, Suren Baghdasaryan wrote:
> > > > Replace vma_start_write() with vma_start_write_killable() when
> > > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > > Adjust its direct and indirect users to check for a possible error
> > > > and handle it. Ensure users handle EINTR correctly and do not ignor=
e
> > > > it.
> > > >
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > >
> > > Have raised concerns below but also this feels like you're trying to =
do a bit
> > > too much in one patch here, probably worth splitting out based on the=
 different
> > > parts you changed.
> > >
> > > > ---
> > > >  arch/s390/kvm/kvm-s390.c |  2 +-
> > > >  fs/proc/task_mmu.c       |  5 ++++-
> > > >  mm/mempolicy.c           | 14 +++++++++++---
> > > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > > >  mm/vma.c                 | 22 ++++++++++++++--------
> > > >  mm/vma.h                 |  6 ++++++
> > > >  6 files changed, 50 insertions(+), 19 deletions(-)
> > > >
> > > > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > > > index 7a175d86cef0..337e4f7db63a 100644
> > > > --- a/arch/s390/kvm/kvm-s390.c
> > > > +++ b/arch/s390/kvm/kvm-s390.c
> > > > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsi=
gned int ioctl, unsigned long arg)
> > > >               }
> > > >               /* must be called without kvm->lock */
> > > >               r =3D kvm_s390_handle_pv(kvm, &args);
> > > > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > > > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof=
(args))) {
> > >
> > > This is horribly ugly, and if we were already filtering any other ins=
tance of
> > > -EINTR (if they're even possible from copy_to_user()) why is -EINTR b=
eing
> > > treated in a special way?
> > >
> > > I honestly _hate_ this if (errcode !=3D -EINTR) { ... } pattern in ge=
neral, I'd
> > > really rather we didn't.
> > >
> > > It's going to bitrot and people are going to assume it's for some _ve=
ry good
> > > reason_ and nobody will understand why it's getting special treatment=
...
> > >
> > > Surely a fatal signal would have previously resulted in -EFAULT befor=
e which is
> > > a similar situation so most consistent would be to keep filtering no?
> >
> > Current code ignores any error coming from kvm_s390_handle_pv() and
> > proceeds with copy_to_user(), possibly overriding the former error. I
> > don't really know if this is an oversight or an intentional behavior,
> > so I wanted to minimize possible side effects. I guess I should try to
> > fix it properly (or learn why this was done this way). I'll post a
> > separate patch to error out immediately if kvm_s390_handle_pv() fails
> > and will ask s390 experts for review.
>
> Thanks!
>
> >
> > >
> > > >                       r =3D -EFAULT;
> > > >                       break;
> > > >               }
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index e091931d7ca1..1238a2988eb6 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *=
file, const char __user *buf,
> > > >               struct clear_refs_private cp =3D {
> > > >                       .type =3D type,
> > > >               };
> > > > +             int err;
> > > >
> > > >               if (mmap_write_lock_killable(mm)) {
> > > >                       count =3D -EINTR;
> > > > @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *=
file, const char __user *buf,
> > > >                                               0, mm, 0, -1UL);
> > > >                       mmu_notifier_invalidate_range_start(&range);
> > > >               }
> > > > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp)=
;
> > > > +             err =3D walk_page_range(mm, 0, -1, &clear_refs_walk_o=
ps, &cp);
> > > > +             if (err < 0)
> > >
> > > Again with this < 0 :) let's be consistent, if (err).
> >
> > Ack.
>
> Thanks!
>
> >
> > >
> > > > +                     count =3D err;
> > > >               if (type =3D=3D CLEAR_REFS_SOFT_DIRTY) {
> > > >                       mmu_notifier_invalidate_range_end(&range);
> > > >                       flush_tlb_mm(mm);
> > > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > > index 90939f5bde02..3c8b3dfc9c56 100644
> > > > --- a/mm/mempolicy.c
> > > > +++ b/mm/mempolicy.c
> > > > @@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigne=
d long start, unsigned long end,
> > > >                       &queue_pages_lock_vma_walk_ops : &queue_pages=
_walk_ops;
> > >
> > > There's a comment above:
> > >
> > >  * queue_pages_range() may return:
> > >  * 0 - all pages already on the right node, or successfully queued fo=
r moving
> > >  *     (or neither strict checking nor moving requested: only range c=
hecking).
> > >  * >0 - this number of misplaced folios could not be queued for movin=
g
> > >  *      (a hugetlbfs page or a transparent huge page being counted as=
 1).
> > >  * -EIO - a misplaced page found, when MPOL_MF_STRICT specified witho=
ut MOVEs.
> > >  * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK un=
specified.
> > >  */
> > >
> > > You should add the -EINTR to it.
> >
> > Ack.
>
> Thanks!
>
> >
> > >
> > > >
> > > >       err =3D walk_page_range(mm, start, end, ops, &qp);
> > > > +     if (err =3D=3D -EINTR)
> > > > +             return err;
> > >
> > > Again, you're special casing without really any justification here. L=
et's please
> > > not special case -EINTR unless you have a _really good_ reason to.
> > >
> > > And also - if we fail to walk the page range because we couldn't get =
a VMA write
> > > lock, that's ok. The walk failed. There's nothing to unlock, because =
we didn't
> > > even get the write lock in the first place, so there's no broken stat=
e, it's as
> > > if we failed at some other point right?
> > >
> > > So I don't see why we're special casing this _at all_.
> >
> > I want to avoid possible -EINTR code override with -EFAULT in the code =
below.
> > walk_page_range() can return -EINVAL and any other error that
> > ops->pte_hole or ops->test_walk might return. We might be fine
> > treating all of them as -EFAULT but masking -EINTR seems wrong to me.
> > I don't really know a better way to deal with this but if you have a
> > good alternative I would really appreciate it.
>
> As per Matthew we needn't worry, and in any case if we want to check for =
fatal
> signal early exit we can do if (fatal_signal_pending(current)) {} I think=
?

Ok, fatal_signal_pending() seems like a better alternative. Thanks!

>
> >
> > >
> > > >
> > > >       if (!qp.first)
> > > >               /* whole range in hole */
> > > > @@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct=
 *mm, int source, int dest,
> > > >                                     flags | MPOL_MF_DISCONTIG_OK, &=
pagelist);
> > > >       mmap_read_unlock(mm);
> > >
> > >
> > > >
> > > > +     if (nr_failed =3D=3D -EINTR)
> > > > +             err =3D nr_failed;
> > >
> > > Ugh please don't, that's REALLY horrible.
> > >
> > > Actually the only way you'd get a write lock happening in the walk_pa=
ge_range()
> > > is if flags & MPOL_MF_WRLOCK, menaing queue_pages_lock_vma_walk_ops a=
re used
> > > which specifies .walk_lock =3D PGWALK_WRLOCK.
> > >
> > > And this flag is only set in do_mbind(), not in migrate_to_node().
> > >
> > > So this check is actually totally unnecessary. You'll never get -EINT=
R here.
> >
> > Ah, good point. I'll drop this part.
>
> Thanks!
>
> >
> > >
> > > Maybe this code needs some refactoring though in general... yikes.
> >
> > Right.
> >
> > >
> > > > +
> > > >       if (!list_empty(&pagelist)) {
> > > > -             err =3D migrate_pages(&pagelist, alloc_migration_targ=
et, NULL,
> > > > -                     (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL=
, NULL);
> > > > +             if (!err)
> > > > +                     err =3D migrate_pages(&pagelist, alloc_migrat=
ion_target,
> > > > +                                         NULL, (unsigned long)&mtc=
,
> > > > +                                         MIGRATE_SYNC, MR_SYSCALL,=
 NULL);
> > >
> > > Given the above, this is unnecessary too.
> >
> > Ack. Will drop.
>
> Thanks!
>
> >
> > >
> > > >               if (err)
> > > >                       putback_movable_pages(&pagelist);
> > > >       }
> > > > @@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, uns=
igned long len,
> > > >                               MR_MEMPOLICY_MBIND, NULL);
> > > >       }
> > > >
> > > > -     if (nr_failed && (flags & MPOL_MF_STRICT))
> > > > +     /* Do not mask EINTR */
> > >
> > > Useless comment... You're not explaining why, and it's obvious what y=
ou're doing.
> > >
> > > > +     if ((err !=3D -EINTR) && (nr_failed && (flags & MPOL_MF_STRIC=
T)))
> > >
> > > Weird use of parens...
> > >
> > > And again why are we treating -EINTR in a special way?
> >
> > Ah, actually I don't think I need this here. If queue_pages_range()
> > fails nr_failed gets reset to 0, so the original error won't be masked
> > as -EIO. I'll drop this part.
>
> Thanks!
>
> >
> > >
> > > >               err =3D -EIO;
> > > >       if (!list_empty(&pagelist))
> > > >               putback_movable_pages(&pagelist);
> > > > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > > > index a94c401ab2cf..dc9f7a7709c6 100644
> > > > --- a/mm/pagewalk.c
> > > > +++ b/mm/pagewalk.c
> > > > @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struc=
t mm_struct *mm,
> > > >               mmap_assert_write_locked(mm);
> > > >  }
> > > >
> > > > -static inline void process_vma_walk_lock(struct vm_area_struct *vm=
a,
> > > > +static inline int process_vma_walk_lock(struct vm_area_struct *vma=
,
> > > >                                        enum page_walk_lock walk_loc=
k)
> > > >  {
> > > >  #ifdef CONFIG_PER_VMA_LOCK
> > > >       switch (walk_lock) {
> > > >       case PGWALK_WRLOCK:
> > > > -             vma_start_write(vma);
> > > > -             break;
> > > > +             return vma_start_write_killable(vma);
> > > >       case PGWALK_WRLOCK_VERIFY:
> > > >               vma_assert_write_locked(vma);
> > > >               break;
> > > > @@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct=
 vm_area_struct *vma,
> > > >               break;
> > > >       }
> > > >  #endif
> > > > +     return 0;
> > > >  }
> > > >
> > > >  /*
> > > > @@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct =
*mm, unsigned long start,
> > > >                       if (ops->pte_hole)
> > > >                               err =3D ops->pte_hole(start, next, -1=
, &walk);
> > > >               } else { /* inside vma */
> > > > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > > > +                     err =3D process_vma_walk_lock(vma, ops->walk_=
lock);
> > > > +                     if (err)
> > > > +                             break;
> > > >                       walk.vma =3D vma;
> > > >                       next =3D min(end, vma->vm_end);
> > > >                       vma =3D find_vma(mm, vma->vm_end);
> > > > @@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_s=
truct *vma, unsigned long start,
> > > >               .vma            =3D vma,
> > > >               .private        =3D private,
> > > >       };
> > > > +     int err;
> > > >
> > > >       if (start >=3D end || !walk.mm)
> > > >               return -EINVAL;
> > > > @@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_s=
truct *vma, unsigned long start,
> > > >               return -EINVAL;
> > > >
> > > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     if (err)
> > > > +             return err;
> > > >       return __walk_page_range(start, end, &walk);
> > > >  }
> > > >
> > > > @@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, c=
onst struct mm_walk_ops *ops,
> > > >               .vma            =3D vma,
> > > >               .private        =3D private,
> > > >       };
> > > > +     int err;
> > > >
> > > >       if (!walk.mm)
> > > >               return -EINVAL;
> > > > @@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, c=
onst struct mm_walk_ops *ops,
> > > >               return -EINVAL;
> > > >
> > > >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > > > -     process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > > > +     if (err)
> > > > +             return err;
> > > >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> > > >  }
> > > >
> > > > diff --git a/mm/vma.c b/mm/vma.c
> > > > index 9f2664f1d078..46bbad6e64a4 100644
> > > > --- a/mm/vma.c
> > > > +++ b/mm/vma.c
> > > > @@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vm=
a_merge_existing_range(
> > > >       if (anon_dup)
> > > >               unlink_anon_vmas(anon_dup);
> > > >
> > > > -     /*
> > > > -      * This means we have failed to clone anon_vma's correctly, b=
ut no
> > > > -      * actual changes to VMAs have occurred, so no harm no foul -=
 if the
> > > > -      * user doesn't want this reported and instead just wants to =
give up on
> > > > -      * the merge, allow it.
> > > > -      */
> > > > -     if (!vmg->give_up_on_oom)
> > > > -             vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > > > +     if (err =3D=3D -EINTR) {
> > > > +             vmg->state =3D VMA_MERGE_ERROR_INTR;
> > >
> > > Yeah this is incorrect. You seem adament in passing through -EINTR _n=
o
> > > matter what_ :)
> >
> > You got me figured out ;)
> >
> > >
> > > There are callers that don't care at all if the merge failed, whether=
 through
> > > oom or VMA write lock not being acquired.
> >
> > Ah, I see. I was a bit puzzled by this vmg->give_up_on_oom flag. I
> > think what you are saying is that errors from
> > vma_merge_existing_range() are ignored unless this flag is set and
> > even then the only possible error is ENOMEM.
> >
> > >
> > > There's really no benefit in exiting early here I don't think, the su=
bsequent
> > > split will call vma_start_write_killable() anyway.
> >
> > But are we always calling split after the merge?
>
> We wouldn't if start =3D=3D vma->vm_start and end =3D=3D vma->vm_end but =
that'd be a nop
> anyway :) [in vma_modify(), the only caller].

I see. Ok, then this is indeed an unnecessary complexity with no
benefit. I'll drop this part.

>
> >
> > >
> > > So I think this adds a lot of complexity and mess for nothing.
> > >
> > > So can we drop all this change to the merge logic please?
> >
> > Ok but is there a good reason for this unusual error handling logic in
> > vma_merge_existing_range()?
>
> It's specifically so we can indicate _why_ the merge didn't succeed, beca=
use the
> function returns NULL. Is checked in vma_modify().
>
> Better this way than an ERR_PTR().

I think ERR_PTR() would be a more usual pattern for such cases but I
guess either way works fine.
Thanks!

>
>
> >
> > >
> > > > +     } else {
> > > > +             /*
> > > > +              * This means we have failed to clone anon_vma's corr=
ectly,
> > > > +              * but no actual changes to VMAs have occurred, so no=
 harm no
> > > > +              * foul - if the user doesn't want this reported and =
instead
> > > > +              * just wants to give up on the merge, allow it.
> > > > +              */
> > > > +             if (!vmg->give_up_on_oom)
> > > > +                     vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> > > > +     }
> > > >       return NULL;
> > > >  }
> > > >
> > > > @@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(stru=
ct vma_merge_struct *vmg)
> > > >       merged =3D vma_merge_existing_range(vmg);
> > > >       if (merged)
> > > >               return merged;
> > > > +     if (vmg_intr(vmg))
> > > > +             return ERR_PTR(-EINTR);
> > > >       if (vmg_nomem(vmg))
> > > >               return ERR_PTR(-ENOMEM);
> > > >
> > > > diff --git a/mm/vma.h b/mm/vma.h
> > > > index eba388c61ef4..fe4560f81f4f 100644
> > > > --- a/mm/vma.h
> > > > +++ b/mm/vma.h
> > > > @@ -56,6 +56,7 @@ struct vma_munmap_struct {
> > > >  enum vma_merge_state {
> > > >       VMA_MERGE_START,
> > > >       VMA_MERGE_ERROR_NOMEM,
> > > > +     VMA_MERGE_ERROR_INTR,
> > > >       VMA_MERGE_NOMERGE,
> > > >       VMA_MERGE_SUCCESS,
> > > >  };
> > > > @@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_=
struct *vmg)
> > > >       return vmg->state =3D=3D VMA_MERGE_ERROR_NOMEM;
> > > >  }
> > > >
> > > > +static inline bool vmg_intr(struct vma_merge_struct *vmg)
> > > > +{
> > > > +     return vmg->state =3D=3D VMA_MERGE_ERROR_INTR;
> > > > +}
> > > > +
> > > >  /* Assumes addr >=3D vma->vm_start. */
> > > >  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
> > > >                                      unsigned long addr)
> > > > --
> > > > 2.53.0.414.gf7e9f6c205-goog
> > > >
> > >
>
> Cheers, Lorenzo

