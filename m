Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C0DCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B058E0021; Mon, 17 Nov 2025 13:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBBF8E0002; Mon, 17 Nov 2025 13:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11A88E0021; Mon, 17 Nov 2025 13:45:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC2878E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:45:47 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83ED287A08
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:45:47 +0000 (UTC)
X-FDA: 84120977934.22.46DE5A1
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id A308C80017
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:45:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=THTZv7Xm;
	spf=pass (imf30.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763405145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wucYSeQ2nsQ8Jk+wJRdH9jEs+0g/nJs2i4hQi0un/g=;
	b=4btEdj7e90wUp194nfVdwtNGSFxZFQopA/PUOJAFQQPXZyh/graVCEnkfcNft/tLH+U72c
	a2KRbEbyy35upIA69OVJk5g0qNDsJJoAtOILE3GGUf4RKb9wBleHxj9iRDWFXiRTIDQOvy
	E+ajvhG8Ud2RlFgkJ5GA4gsZgyXc9Hc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763405145; a=rsa-sha256;
	cv=none;
	b=VgXPmL7vZAT0nPFEV4vC9tvsaoJWYr+e3ypnBhN3a4R6USKoQQ6vprF4okF+Ep/suv7jts
	i43lWlVD/se81zaZRcWiGLo3FF/NldrxbdVty7er0DdhltbgjCgRCjDrfR/VBlutGC/3yF
	8fNqZNU9F3cb2RWuixjMyPYU6Se6xAk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=THTZv7Xm;
	spf=pass (imf30.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29808a9a96aso48020415ad.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763405144; x=1764009944; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7wucYSeQ2nsQ8Jk+wJRdH9jEs+0g/nJs2i4hQi0un/g=;
        b=THTZv7XmSir5tIrcALJbUyn77wfBhHFY3uPVuziOQ/YjeIl6d0TXlMak0DRCy8e40F
         F1U5eghAs7SvWpeC2lOIZgm0G+Gms9OKX+YsDB1OMN5ajZ6K+rQcVZLkpyLcaj22eImv
         JeSMFJtv1idAesm49vjP2ybodHH6qa7g2Qgbko2mwKTtKyF+CiAXuvrXNfkXTQml93IV
         Bs/CDzYrEghptlzrXh4nIal4ftjOqleWj+12hCosaE8bHupMQh4qT+VlfR1DydNSvA6t
         cvVyFUmuGZlhjIK3mYpyuhuIO2cnsdiz+mRKVIUpEeBjtaiZT/UPuPC0zYrpzvNHBh0G
         5Z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405144; x=1764009944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7wucYSeQ2nsQ8Jk+wJRdH9jEs+0g/nJs2i4hQi0un/g=;
        b=iioOZvYQCbxanD00f51ppIemSfLoUTSCI4m/n32OZRoN+6G7SdYkWvLdY/7NoQDr5y
         KXmmTZX573O9C8GwQZt0Xo5UDp5P1IP0DZA/qiD7n4oajPDzxPvmhCbCCdDuRFwr8xCa
         2L8DFtFtBOARzI88XIp7pnVFa+wiiQtsE1p5RnmcZt2MGFjV2pDt3PFPJVGuDeYtqnnX
         o0TQlKF/+G99lFZrmQdlbvPVtpKHelSbhMJB8Y3fAMI67u5JOk0mdvRXtb5HV5M+qqHa
         0zyIBEslZHfSvvt+6hSqOg09nzpjpeUrDM4MF5LmNQWxsODBJKPpqN1XB7Gh5xFvhKLQ
         tRog==
X-Forwarded-Encrypted: i=1; AJvYcCVO1sb6jApiKO3YAtgHXJeVVVS3pPOgMAA4DSMIZAaKSDk8q0hOgH0aKS6qmSmdm/A3kGdhh8SE6A==@kvack.org
X-Gm-Message-State: AOJu0Yw+e5PjO0AI5CaL9e76gvz2cpPZRiqR1tnGCZGg3acBCUXrHb9I
	qFHK5Egvfwwgy5WmsvgdxZ8Lt9v9HWmrp+FvTVY5SQeT6ljodHAWlaPDWYqFxGf0lk1ffxiuJsQ
	25jsrsMwdo3eaLC5CHa1LSkrYIrqBzxM=
X-Gm-Gg: ASbGnct12Kw6ASgT2p4JLBbLmCzbCElNrwnpTCc/AIuUgvuAeqMxg9Ga9jaxJQEXAcv
	ij9nYANtoY52+j5wlED3H1KMMxmTsgBo2NlVHMQzwb6ruwurdkNaPfKvV5ZlaqOg7Pd7iMmnhgV
	rzIQyA4xW/VbCj0LV1zf8158PP9QRVApTCj/Khf/hAhjWpTDssQvSmX+pjknHUmRsAJh9GGHdYS
	9E6mHUo6kbYYBLiVZc/FMZZfWgRIC9DAj5CNYDSIur2RspKOYR3QUyUUVqnFBOXtTfi0NPcNbVx
X-Google-Smtp-Source: AGHT+IHaGw3phEOQw4Qpur0eLmyhxso8M4IG4GnZLwbf/2toORgNJUKXRKe/uLp0l71+D3q3BCbIbJuZDTs9RGbD+0c=
X-Received: by 2002:a17:90b:510c:b0:343:b610:901c with SMTP id
 98e67ed59e1d1-343fa74be77mr14049811a91.26.1763405144456; Mon, 17 Nov 2025
 10:45:44 -0800 (PST)
MIME-Version: 1.0
References: <20251114193729.251892-1-ssranevjti@gmail.com> <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org> <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
In-Reply-To: <aRtjfN7sC6_Bv4bx@casper.infradead.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 17 Nov 2025 10:45:31 -0800
X-Gm-Features: AWmQ_bnuhsyqplW3EwmS5X2rilTR8nQ_4xwujfWlx5dY8gU3dMEgLDCj7uI7O6I
Message-ID: <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
To: Matthew Wilcox <willy@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, 
	akpm@linux-foundation.org, shakeel.butt@linux.dev, eddyz87@gmail.com, 
	andrii@kernel.org, ast@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, khalid@kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, 
	bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ckym1rfrnxdem1kj7tqeq7npxmjx3pyy
X-Rspam-User: 
X-Rspamd-Queue-Id: A308C80017
X-Rspamd-Server: rspam01
X-HE-Tag: 1763405145-739068
X-HE-Meta: U2FsdGVkX1/uqsyOrBKIcb10j9R1V9rrzW4tnWH/SNUauBDCVc0TeSJDbmQPb15bE7tT5/iaj2p7suldTC4Nw/E0muRBjfo4W0W26wSyNu9WxVLmqV3MX7DtwgfVEQzu6HVRuXkqw/FUvrRsef9A7Q3dOp9Pw/A9Ish+ZfW4fHhnVroR63R8HZvAeqstF44r4lu+9WhIbTD7vITYmwZwQm1fC3cqwhO3nUyNfRhgwcZ7uVjRl4M0MhVdT7vPbcj2keC0oK8iaFCMyVwp75+HDTrVIM7yCM+kAvxbSFWX0ejnILOojtpHYfFhiSSRm44YXBhXiKQYW5H63ugvP7Z2zDehScN5VqL2FKM7uxYUGN1tGO/To7Fm4R5Y1ck/zN5XYZVNv6KuYFHp+cTyg6mt+lGAU2Fk+F4w+F8Sh1fLv+WnW+g70pWoTpO7PbI9xKoInhs6tk7mRkrbowzGO+9FWsX9jRZlASnoWgU8m3/Y4XvVvTo+A0j66GV5n9PYU4q1RN5Rs9WwXHZR3815qvjycPHZ9N1tjA8ZQ8ChRZ5NY+2ERTAlp9lsA3jMgbD3aesX0U/wv7gg/Xc6TQFvBNNW5gn4Tk0JMlVZ3R0wXY91lJN8M/ydDC16ZIxr/ELbqvdLrawI4WwSvqyzEjV54IAb6gB8FY+jZwKKGiHTjbc7kXBS5q+66T4MmqvRn5FbLPGYzskJyu9TJ2y45Dj6RQbHWwz/U8GfWlGMkpgddRE7B8lPyKp1F38fdRSAaTOgJqCMHEc8W0WBPhxHyhu0vInAFoYzqgm4qWRLFB4YriuGVQw8NESw8X9O9B64RpgkymCEpKgZZCudOAYneu2KnjVQGbfRGSfeNGH+EMzsmdrEQCSW7yDVIBBsh0bSqv4oUjCXpAYPDvYOJoXKt1iQwmIKQ8c4jAX890HtnNoxVclLGhLemAHolirJadIA6na6rYNgaNimPyNK6oq93D25us3
 fpClXsf0
 8m1LoI9VCzriSJ56IkE8zihKV3GGBjG/T2OCa5f4k0dsewBv4G87mn7+/usaeLqw+2C7cu/Cw5HsiFhFCCh1Kriu8h90MiQqqsgeKfD8tdGqjhxrBRBbXyLJylgWR4vVKFdqZmzuw4abSw1IfaDMg+4qJUrro6g/81Qo/gieRlsIV0ZtTBWIxyFZpAkIpaDExQwB5JeUttuWvV8djDWBxUyg7zn0SqT39Ym3GxqRI0UfC5hiE1GfbqOifYqPAOZsL6N0P81X+FQA7GWS5Z+VwCnHZHOJu6trCChfz50YRlyzflz0WSMo/Xc+tftyyTBt6f9uJVlCwSvgnyJbD9M6VMBq3dFJ04VUVSYwRprt8rqYy7FMJRczYhgcv1GE5t4tm4lOR+GSr+CDUQLJujP4ukxej3mvvA22wO9gnQ9rITZMsZupiA+gJIwOC66wmbyTTAzawSmPCZxrOGOhK/H5Dz6X1kO5ejWzk7/DkdN/kQKtylhYkyKBBDVLiSWoeamIgXwhIxMfx22dEIR01p+39yne0ut+Kukzg9e4bLqdioTTwUuBwBy8VLBqJWkwd7LV1vYkgsTj81UzhwsvaL00p2+35bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+ bpf@

On Mon, Nov 17, 2025 at 10:03=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Mon, Nov 17, 2025 at 08:41:55AM -0800, Darrick J. Wong wrote:
> > I wondered why this whole thing opencodes kernel_read, but then I
> > noticed zero fstests for it and decid*******************************
> > *****.
>
> I wondered the same thing!  And the answer is that it's special BPF
> stuff:
>
>         /* if sleeping is allowed, wait for the page, if necessary */
>         if (r->may_fault && (IS_ERR(r->folio) || !folio_test_uptodate(r->=
folio))) {
>                 filemap_invalidate_lock_shared(r->file->f_mapping);
>                 r->folio =3D read_cache_folio(r->file->f_mapping, file_of=
f >> PAGE_SHIFT,
>                                             NULL, r->file);
>                 filemap_invalidate_unlock_shared(r->file->f_mapping);
>         }
>
> if 'may_fault' (a misnomer since it really means "may sleep"), then we
> essentially do kernel_read().
>
> Now, maybe the right thing to do here is rip out almost all of
> lib/buildid.c and replace it with an iocb with IOCB_NOWAIT set (or not).
> I was hesitant to suggest this earlier as it's a bit of a big ask of
> someone who was just trying to submit a one-line change.  But now that
> "it's also shmem" has entered the picture, I'm leaning more towards this
> approach anyway.

As I replied on another email, ideally we'd have some low-level file
reading interface where we wouldn't have to know about secretmem, or
XFS+DAX, or whatever other unusual combination of conditions where
exposed internal APIs like filemap_get_folio() + read_cache_folio()
can crash.

The only real limitation is that we'd like to be able to control
whether we are ok sleeping or not, as this code can be called from
pretty much anywhere BPF might run, which includes NMI context.

Would this kiocb_read() approach work under those circumstances?

>
> Looking at it though, it's a bit weird that we don't have a
> kiocb_read().  It feels like __kernel_read() needs to be split into
> half like:
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 833bae068770..a3bf962836a7 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -503,14 +503,29 @@ static int warn_unsupported(struct file *file, cons=
t char *op)
>         return -EINVAL;
>  }
>
> -ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t=
 *pos)
> +ssize_t kiocb_read(struct kiocb *iocb, void *buf, size_t count)
>  {
> +       struct file *file =3D iocb->ki_filp;
>         struct kvec iov =3D {
>                 .iov_base       =3D buf,
>                 .iov_len        =3D min_t(size_t, count, MAX_RW_COUNT),
>         };
> -       struct kiocb kiocb;
>         struct iov_iter iter;
> +       int ret;
> +
> +       iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
> +       ret =3D file->f_op->read_iter(iocb, &iter);
> +       if (ret > 0) {
> +               fsnotify_access(file);
> +               add_rchar(current, ret);
> +       }
> +       inc_syscr(current);
> +       return ret;
> +}
> +
> +ssize_t __kernel_read(struct file *file, void *buf, size_t count, loff_t=
 *pos)
> +{
> +       struct kiocb kiocb;
>         ssize_t ret;
>
>         if (WARN_ON_ONCE(!(file->f_mode & FMODE_READ)))
> @@ -526,15 +541,9 @@ ssize_t __kernel_read(struct file *file, void *buf, =
size_t count, loff_t *pos)
>
>         init_sync_kiocb(&kiocb, file);
>         kiocb.ki_pos =3D pos ? *pos : 0;
> -       iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
> -       ret =3D file->f_op->read_iter(&kiocb, &iter);
> -       if (ret > 0) {
> -               if (pos)
> -                       *pos =3D kiocb.ki_pos;
> -               fsnotify_access(file);
> -               add_rchar(current, ret);
> -       }
> -       inc_syscr(current);
> +       ret =3D kiocb_read(&kiocb, buf, count);
> +       if (pos && ret > 0)
> +               *pos =3D kiocb.ki_pos;
>         return ret;
>  }
>

