Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D5B7C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 03:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692036B0088; Wed, 29 Jul 2026 23:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642646B008A; Wed, 29 Jul 2026 23:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B4F6B008C; Wed, 29 Jul 2026 23:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE2A16B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 23:01:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C30A408C8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:01:55 +0000 (UTC)
X-FDA: 85043943390.22.EE29879
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9475FA0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:01:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=GN2PHLWj;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of zhilinz@nebusec.ai designates 209.85.167.48 as permitted sender) smtp.mailfrom=zhilinz@nebusec.ai
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785380513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oln1KlxmEYSmQC2IapnIHAQQ+nSDuYE06j7DA750/6k=;
	b=ETd5gRvi2+8nQdVIjSjyDMJpeR7B9W1JSDUC9DHzT86UiC/e1PJoHJQ9xRmXYH+78y4gmf
	bAwpVPugxXS1aOdo9fFVhyY/FM8LOjLEYDGtgeOQGaxjT9nUB+MP+MQjp7Gd/4heWeqDZa
	wlHoj8Dek8sKuLEzAmFbYAmw0uBvTmA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=GN2PHLWj;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of zhilinz@nebusec.ai designates 209.85.167.48 as permitted sender) smtp.mailfrom=zhilinz@nebusec.ai
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785380513;
	b=LZntqcBkODxIQAvbBSiz8TtrG9YC95lIUP1iRrav+RxzPvW0ngI/8Zz+EdU4bVqv5cfRZT
	ZZznYA7EJ+oe+x9iTpuG+Z70/F5C8fjPa7XGyU9Dv4/TLGrRIU4tOA8FeRpvMhZRHMD47V
	VgG2Vqm7HRo0OWITD7JVO9W+rt0lTj8=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b015532f7bso1514072e87.0
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 20:01:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785380512; cv=none;
        d=google.com; s=arc-20260327;
        b=m0kXLCEheIkfVrYvw1+r5DS5AYkRJybeMzhZ2VGlNKdLW2tWWDX8+cr3C43KIU6joX
         XKVi6/i3NVs3YMRcsVogog+JDpVavp2eW0NELNUmqzcFFRyaqtFzRcWuYaKUu127kKOH
         rz/jkzMnYpvFv0MbGDEemvXGtsLRYNZ8Y96/mh1MXfMpBDDCGfXTb6SsfLalA5PtyYfK
         pToGkIxklt4Jupwmb68RbOLgDZmPZeo320+mGhjIoGYMB1USCHurIkZbGxcjj46qeJwf
         avZOfCG2R2ZDqmvvP+XfqeBYD2fzNrOkSPc03Wppd0guthi3YM9HC02uVy31uF7YEWS5
         72YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oln1KlxmEYSmQC2IapnIHAQQ+nSDuYE06j7DA750/6k=;
        fh=58u5RjKnIl+qiXUsGio0TtO6FU0lZef0VKND1nYmwjs=;
        b=nSqbptX/+DoV8Qs4pA9nobww8xiSxhJ9OUEJsT+IrK5gePm9HBV04I/+0MHn8e3OVU
         iFXmyR33CO7zx4jdfPrmxFKcpLKKt6liwN0h9S0VSWP2k0GL7bcA2QTGMgFVHX6lcqTR
         Y2ySf3/uS9arkNhU04BJEIZs4EIpV7X4kDQAZl30Z6zRyug8XtVe/+87YKF4Ckst88VY
         jr3QXcDJu2ogE9xdyR+K/Me3m/AmfW1nXlDLGBOUh4PPKPtN/NdMv+f5975HHmTq5xuE
         RPtdovWXe51lSld+T5LQHy32V8IU9vweAGg6/CGtOLlTGjnYDa9zMvamUz2TaJrXRNOc
         xM/A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785380512; x=1785985312; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oln1KlxmEYSmQC2IapnIHAQQ+nSDuYE06j7DA750/6k=;
        b=GN2PHLWjyjDlV01JfVgCn9Ki+BZgU7El97NSdcBBvvgwMwl5R0+zFaNWEt2xHjE0/7
         QUm38mdf1l3qEDsJnFUD6ZjrinrvG9jcfFX2MGPe3O8XeX9YXoL732BAfB7UgM6FdJ2E
         3InC//4dc6TOQ28/ZczUXWRWdMCMoLj7EO6viZDNdNPtKjp0qFPwjpYL++DtxGzXYT2W
         8hdYnyh+iXqyuMtKTn+NrnEbHMhU8n0nYC7uWdDkT3XShIW4E3lYNrttPhl3aijQ1tgM
         XTlfxD1nnC1p40TtAsxzLCzBFc5R2QWB3veZkl0vakBs+F5EuDaRFYLC3uLsGxwq0Cx2
         NSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785380512; x=1785985312;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oln1KlxmEYSmQC2IapnIHAQQ+nSDuYE06j7DA750/6k=;
        b=EvOU9FVLvK/rdQaKyF1g9LynqcVCv9HdyM14RjIQs9qrQzWj/I+7FJRG++VEwuVH8s
         bEIgNu/DUAxIeKF2g7a/yWNoyiIEljoK+1imE54G8JJgE9rwnFQK8rwlTz09gtNUJvfv
         JfNYH8mtBlZPmG8VGooLJkfD15khmpzYr6vYjMdRR+DDC2vdCnNgFHV9TUC0EpeHkXc1
         1jHDeb5D1Z0W1Ax3IMiBOXEurCw+ByvYUHe5UD06Tx7dK/moWOj1HC3jAdAAt7GmJj/Y
         uxWU3W9WWK70CoLOfbHFVTbZcQ9qYOVb+yPAPo5wz/G9SuE1VbDLF3rN0k7tcnekf8h0
         HAjA==
X-Gm-Message-State: AOJu0YyuIQ5+Z0fFxz3VpqMf0nPm7T8Qw4KA75daCHCVn+li6rW3wfbd
	Zv/wTBNrtut2nDIZVzxsR0xG+0/8COCWet9JbecYlr5q94wZk+PKWazaEG4rDdKbGN73FjRLHdo
	K/2v0iClVb1YdP3yamhDL0c3F7NWFf/zmBvzGk9QUf/M=
X-Gm-Gg: AR+sD13DG1QO74DqPcLFYsU3EuVIWAr1k6Ch5WNl/lEE0X2N/l00iji95/sJMyWfhmh
	5Ef+BLFoqR3EFMhi0JPTo8a+1DCYt0ayeOwcdsJC/E48beoXDIn71YWazcSJA68s6bAOzbeKvJp
	6oYblXI33mZDx9SV3rhJsOHPGQ4kj98/s8qmMPJDCfOugh3BQt5Y+A7kWCtR6mpPB5nyq+rEtAM
	xFlsUOCHU5nHiEWqUbKqow5gJrmOIgp9JV5XI8nHZ/MPvdNeYvj3rt9pWqJXP3FSAI6YCexIBoM
	9wrzyxr7DNv5KxRbsAzdXr8YQ9iCvyehdehofeKDGXZJ
X-Received: by 2002:a05:6512:12c8:b0:5ae:be69:49f7 with SMTP id
 2adb3069b0e04-5b2db361dabmr122796e87.23.1785380511404; Wed, 29 Jul 2026
 20:01:51 -0700 (PDT)
MIME-Version: 1.0
References: <87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai>
 <21cc294a-9bff-4ae1-8f7a-f51b91579dcd@linux.alibaba.com>
In-Reply-To: <21cc294a-9bff-4ae1-8f7a-f51b91579dcd@linux.alibaba.com>
From: zhilin zou <zhilinz@nebusec.ai>
Date: Thu, 30 Jul 2026 11:01:38 +0800
X-Gm-Features: AUfX_mxbTN7NexnhASmnrH99XDq9EPe8NbrjbXrZTJhx1sRfP790rHyIf3Ldpik
Message-ID: <CANB6i5x30y5CaB3mrmS2Fp6+3vt1h4bNZ_hGmJAAPHTTP-=A6A@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm: shmem: reject page-aligned fallocate end overflow
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, hughd@google.com, akpm@linux-foundation.org, 
	vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9475FA0006
X-Rspam-User: 
X-Stat-Signature: 889tb6yppxipk5n9dt44qsf7yk7ty7hh
X-HE-Tag: 1785380513-655541
X-HE-Meta: U2FsdGVkX18GaPHkMc57wCpOwcy4D2eK5suzfGWkwdRkeH9gvU8y3pyybz1wURS5IMJde3wqtW23CmdofKhaoJKrqywn8Ecm1qP/+8BtDgcM0uJpMHcAa5yCPJc+yAdfGEEa3p1XDeyhPxZa9CU8Xfd17Xaz7gA3sKEq3VXyWM7n7sV9ZnrnibRYCq4AlFhi7jUvWlRtuRELYLpTYNv9qL7GzZvaavRBBJZoxsD98oeRy54Bkk7a0l7pQSm7pepWUihnP7lenNgPE4iwljjc5e27Ehcg34F6tvtfp4JLR/rDiVjk3TMpxw+EVrzN0Qa81tdNUB5xXUcUctAyNXq+hLyLnrS1hXTqKr31+W40JNMnwSyFxNyHoHqqBnFCPWW+nS5NqLYdTHP21kp1M6Kd57YBPBMDS4QIrz3tYOBO9c468hWqFzAtr8cVc9/mZBB/W3IwSoO4MEUIPLGnqSeEYmf3znmzq/Ka3xGog0eZ0hvsK1XXV7vk64WC1WgazbvOpi0XPGBD3pZ6GUpkbin8I+cdiyVxP8t2jOU2G/jZ93eOi4u2l7oIq1oDx2FFn8dDvqDEA+veFMpdZUIod6XCQoThj1HfqNPjNVS6vwddQ5O5DYGlNO/P8zpIClIGc//5IEJmFw5tDTGVZP/l1fxWyn9W9Utx7qm8eHeWp2psxaQdk+3UI4/XfLYth5JGzgB3zeM7/UHjCbWCyE2jXQCnALRYaQGr0F2RuXug4sl7BdQhGc4B242K33zSBbKsJzLZKSUNz3c2S8wqNNOus8E6h5W3UGudSvnFIz/fw/KjiX5/PMCdNYSQAfUX5YQ5bkyX4/Jz98e8OrjXfxMLsWMfQWpfvRyMKcpMX2u54/V1CChmw62tvBwNrHPSTRgMmQtChTr9q+RYSuie/sv75cizmJoovA2XL4ni4f2K6kurnGHPAwktFV8m/EnSuOtn1K818EN3GSJ4hKNzFBxcXkW
 3l7ATxTJ
 slLAyX1kCXgzNxNBVC5LNam97qFE527zdPG1mq6DrHV/uIRlcUm717N8AEsIsbBfYRTjXSzP174279iAIro1gsp3gfRLSHcH1eX0XsFk7AOQ1zeizR+hAJ5jFA/AC1TiWOSlCOUvZ9QI+H4EotoGzZ7QV0gKfYl2K6GxAWIaVU0TC9sn7Cnzl7LDuP3b9RyMsYGCRRvj/sAeg80XRwb3SCfoyof6BMUSK4VFy16W/6kS2xegmCC66o8bMlZzHOdZyBYFXwQoCMmk5dzBCS4bvL07Zdoo8V0nwIFt/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:02=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 7/29/26 10:07 PM, Zhiling Zou wrote:
> > shmem_fallocate() validates offset + len with inode_newsize_ok(), but
> > then rounds that end offset up to a page boundary before entering the
> > preallocation loop.
> >
> > For a valid request ending at MAX_LFS_FILESIZE, such as offset =3D 0 an=
d
> > len =3D LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overfl=
ow
> > the signed loff_t used for the rounded end calculation. If that wrapped
> > value is then converted into a page index, shmem_fallocate() can enter
> > the folio allocation loop with an invalid range.
> >
> > Cache the already validated end position, use check_add_overflow() when
> > rounding it up to a page-aligned byte offset, and reuse the cached end
> > for the later seal, shmem_get_folio(), and i_size checks.
> >
> > Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
> > Cc: stable@vger.kernel.org
>
> I don't think this needs CC stable, since this is not a common case. We
> never hit this issue in products
>
> > Reported-by: Vega <vega@nebusec.ai>
> > Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> > ---
> > changes in v2:
> > - drop the RAM/swap-based range rejection
> > - drop the NORESERVE full-range accounting probe
> > - use check_add_overflow() on a signed loff_t rounded end
> > - v1 Link: https://lore.kernel.org/all/adcf644e780706c220809b7a41e6e496=
d2181806.1784947149.git.zhilinz@nebusec.ai/
> >
> >   mm/shmem.c | 21 ++++++++++++++-------
> >   1 file changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index b51f83c970bb3..f4648545e7ae7 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -3602,6 +3602,8 @@ static long shmem_fallocate(struct file *file, in=
t mode, loff_t offset,
> >       struct shmem_inode_info *info =3D SHMEM_I(inode);
> >       struct shmem_falloc shmem_falloc;
> >       pgoff_t start, index, end, undo_fallocend;
> > +     loff_t end_byte;
> > +     loff_t end_pos;
> >       int error;
>
> Too many unnecessary changes. I'd expect something like:
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6641823bed16..cc7b17d0111e 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3624,6 +3624,7 @@ static long shmem_fallocate(struct file *file, int
> mode, loff_t offset,
>          struct shmem_inode_info *info =3D SHMEM_I(inode);
>          struct shmem_falloc shmem_falloc;
>          pgoff_t start, index, end, undo_fallocend;
> +       loff_t aligned_end;
>          int error;
>
>          if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> @@ -3680,8 +3681,14 @@ static long shmem_fallocate(struct file *file,
> int mode, loff_t offset,
>                  goto out;
>          }
>
> +       /* Check for wraparound */
> +       if (check_add_overflow(offset + len, (loff_t)PAGE_SIZE - 1,
> &aligned_end)) {
> +               error =3D -EFBIG;
> +               goto out;
> +       }
> +
>          start =3D offset >> PAGE_SHIFT;
> -       end =3D (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +       end =3D aligned_end >> PAGE_SHIFT;
>          /* Try to avoid a swapstorm if len is impossible to satisfy */
>          if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
>                  error =3D -ENOSPC;
>
> >
> >       if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> > @@ -3649,23 +3651,28 @@ static long shmem_fallocate(struct file *file, =
int mode, loff_t offset,
> >       }
> >
> >       /* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
> > -     error =3D inode_newsize_ok(inode, offset + len);
> > +     end_pos =3D offset + len;
> > +     error =3D inode_newsize_ok(inode, end_pos);
> >       if (error)
> >               goto out;
> >
> > -     if ((info->seals & F_SEAL_GROW) && offset + len > inode->i_size) =
{
> > +     if ((info->seals & F_SEAL_GROW) && end_pos > inode->i_size) {
> >               error =3D -EPERM;
> >               goto out;
> >       }
> >
> > +     if (check_add_overflow(end_pos, (loff_t)PAGE_SIZE - 1, &end_byte)=
) {
> > +             error =3D -EFBIG;
> > +             goto out;
> > +     }
> > +
> >       start =3D offset >> PAGE_SHIFT;
> > -     end =3D (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +     end =3D (u64)end_byte >> PAGE_SHIFT;
> >       /* Try to avoid a swapstorm if len is impossible to satisfy */
> >       if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
> >               error =3D -ENOSPC;
> >               goto out;
> >       }
> > -
> >       shmem_falloc.waitq =3D NULL;
> >       shmem_falloc.start =3D start;
> >       shmem_falloc.next  =3D start;
> > @@ -3699,7 +3706,7 @@ static long shmem_fallocate(struct file *file, in=
t mode, loff_t offset,
> >               else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_fall=
oced)
> >                       error =3D -ENOMEM;
> >               else
> > -                     error =3D shmem_get_folio(inode, index, offset + =
len,
> > +                     error =3D shmem_get_folio(inode, index, end_pos,
> >                                               &folio, SGP_FALLOC);
> >               if (error) {
> >                       info->fallocend =3D undo_fallocend;
> > @@ -3743,8 +3750,8 @@ static long shmem_fallocate(struct file *file, in=
t mode, loff_t offset,
> >               cond_resched();
> >       }
> >
> > -     if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size=
)
> > -             i_size_write(inode, offset + len);
> > +     if (!(mode & FALLOC_FL_KEEP_SIZE) && end_pos > inode->i_size)
> > +             i_size_write(inode, end_pos);
> >   undone:
> >       spin_lock(&inode->i_lock);
> >       inode->i_private =3D NULL;
>

Thanks Andrew and Baolin.

Baolin, agreed. I will drop the stable Cc and simplify the patch to only
guard the page-aligned end calculation, as suggested.

Andrew, I checked the Sashiko report. The concern about this patch
affecting punch-hole requests does not apply, since the punch-hole path
returns before the new check. The small-range punch-hole unmap case looks
like a separate pre-existing issue, so I will keep it separate from this
minimal overflow fix.

I will send v3 shortly.

