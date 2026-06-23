Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A4D7CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 16:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2996B008C; Tue, 23 Jun 2026 12:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672C96B0092; Tue, 23 Jun 2026 12:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B2A6B0093; Tue, 23 Jun 2026 12:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 229356B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:01:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FD5E1C3251
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:01:32 +0000 (UTC)
X-FDA: 84911642424.08.CEC1C83
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A7D81C002E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:01:22 +0000 (UTC)
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782230482;
	b=flDEpN0Nf4hyP3cZySKdlKmZ7P8Y2YsaojxhkveNG1smy2rn0d5MnOfLmU+ae8SoiL26FP
	ZwA1OO8OlRLXjGlaOQK1hasfOI7WKfgEdyOXjQ89TDCvBKCVbp0p3xEdQFF3PvRdE6Ej+z
	fBy6ahT5C1gD4wUZFtdtaq7x4p7GITk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782230482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/dOweBfHSKsBXHjB0p74I+BF7H4VxwvcYuFUhDSwpQ=;
	b=tqbVYzoOVr1Ith858tuH6vxJlyGtIbGkiaBJrZu5qEvpSlY9yYxS+UfnWrOF21PKZGH1yq
	61fSfLDngaSZZd1PqtCHQ6H4rBQteBNjSPTYrlBna6clS9lCk+CycFNXqYZpBQ9YbzuTjJ
	N2tkMzUEYOXif/KGU/FoYFvdUoLtXis=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZWb+Ve+L;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso11968945e9.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:01:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782230481; cv=none;
        d=google.com; s=arc-20260327;
        b=ez1zU9pOvlZDgtIxam9dkichBEMvvXv9z01RlzvNqdZZ9FX3YaIdzn1te9go3dTR6i
         RiTPKE02Vj/K/6Vy+hvz2QF6rodtPCUQAss3+kUKOh15uQ90l5p8hi7fmoZ/eWDyDylR
         Upqs2P+61zT4z0pEMPwWUbD+79ZHucyL63oFzQuhqWsLDkoq3dvWIVzZKBq2dizS5aUS
         x/NmHCE9/5WVDF+33mSupGlhA86zJhYo5F7zBKBhiIJQsT9BV4qcg4PBxsEobka/Hkme
         w4X1VLFWAuG3rmqcPjgaSC+FOrqVNBCOBicDzmnkbrKLYxU87U+MO59gbt5zUd8MU6nh
         BYfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s/dOweBfHSKsBXHjB0p74I+BF7H4VxwvcYuFUhDSwpQ=;
        fh=i7w/2WzzgeRx/ckkQeyTgfwNGSqe8VRk8FGR6pXd3Fk=;
        b=OMsxjaDtu6amvutHfLdhmRAz23zdFikiTkVnsmHge4rBnWLUpFh7ExZXE3U68msgsB
         XoZG530y9FzL7QCH7Hi9oLzBDyUmUWxNkgy/mUUFNJd2u/czJCA9ZSpe9DGx4XZTovd4
         a9seQ3YVaQB0xCneMvEeNJ7R1N47WCcfAhLPDwh/B6tL6LimbV0VXvS/vXktSjPp0B1z
         Zkh4SJqv4EBDglEK+2EQZShUf62bW7eFogfZ1y8xUFBzNl6R+LO6JflUHRnBG7lCkeQS
         CYQozm4lKSJrLEfIX8tXWsgr3p1mdOarlc8YJvrY/UpAz690St/8Q7a5Tkf7wjPXIFrt
         rkQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782230481; x=1782835281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s/dOweBfHSKsBXHjB0p74I+BF7H4VxwvcYuFUhDSwpQ=;
        b=ZWb+Ve+LXeSPVJ4+EZhqlkC5U1ZT0Z9ZXS/Sr4/sAImv1feaXxU7yL+DMxEkzqdsMi
         sh6t0cBCF98Vy0iuYcqfOLCfh1DX7xWZ4c7TnZQBKWNmO7Bh8PL2vm9QOlTh6WFgF9yk
         Cvek4M0KAE5SQ/kJ69Q0B6gKTto0yYlyVlR7kK+KzsOl7OTPOfoz8SL4b4/xSDc4VzS2
         6EVpoMuOGv/OFtxmCSZXEI63VGXv+BsovBo7SoBzI6T8M8Cd31RkfvLknUyAjdUaZBrE
         Enj/XMfazM6ED3eMTSvDbqXAzYtyYtafktKLzNyhIFvUGnxb+y/mVF+tH1bHbBTpO63C
         gtiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782230481; x=1782835281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s/dOweBfHSKsBXHjB0p74I+BF7H4VxwvcYuFUhDSwpQ=;
        b=UdNK9/fTKgGzqk97bke9+bqAKQpOmw6jG7JBdPSrdc3THs+28qxOpc11D3QC7z/89A
         Wtw0J2Uxpo+T3mNWU2Ym/EWl9DH4rymn5ST1TleiF0ZpgiBy3im3A6IBiCr70quhOuk3
         WPvGE08/w43QCMj7xYOcmIkUaNKaj+c1ry3+CEhn/NoyDOUJbT07teImrNbt3VB44VlP
         ViW/rrSu11ogr9IK5XGDYhoP4k710kcuNM+IAE4kDlNmb0EfOraEmmudYs7czpgI677+
         mRNgBvssBpNmcb0jg+5QS4LzYdbXCQDu9No1PxfCoL1r5wR5lVr2sXXAAILIDK4XI2Oh
         1TQg==
X-Forwarded-Encrypted: i=1; AFNElJ/S2/i3kOKyNRM9HPU3e95PHImpqtar9vdV5Vu1VW07r/6LVrPWhbJ9Q8ADUmfdVrfc8xomlwSJxQ==@kvack.org
X-Gm-Message-State: AOJu0YwNI41yT/YsGfPzSi/QK0sgTGaxuNpr930ebpWMEG6zci+mMlrn
	6+ZimoBB81zOaHFSAR4Cktcn4fS7hYgRhtDoFPAwkaiOaGdS3hyLX5GBhoZ8KeakPEizalFxFB7
	oxL8zaM59UolHmnceEuQtlhF7Bym2hoM=
X-Gm-Gg: AfdE7clcUyxid3FsFvjQ1dGWOQoskc0Yqb7ldk7O/EA9nYX+n03p8LsWuF9kUobx91q
	zTRU0ceVkU20htcSqUiUKPkJgfS24teyH9glAz5cr+zfbg/nPj/fk0eI2MEshs24Tv2kzR3xrVw
	to46bSEYgM7p9fbgV5iKgSNI/RD2BsqFl9LXw/sWU2OuvnV/EauiLLUvGvYbTZ7vtLIBLScPZQm
	XUoTJrHTipUiDWe6YCFQe1Tj7nEz1NiYGXgQ5MM5OXEACDQ3X0O+ILZGUeL4QU1ioof3/nCMuiM
	CZWh/jICrL+aHqzxMunDL7Qdv/yF
X-Received: by 2002:a05:600c:c099:b0:48a:5f32:62c6 with SMTP id
 5b1f17b1804b1-4925a0ea8b4mr54371835e9.11.1782230480787; Tue, 23 Jun 2026
 09:01:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com> <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 23 Jun 2026 09:01:09 -0700
X-Gm-Features: AVVi8CexJwF1YIejddCZO0Cw6M7tITGeNOUnTTqz8Z9zx_6aZedVwaVA3e5pkZk
Message-ID: <CAKEwX=Omr29YZ+ZtDXtVLKQVoinGo3y9xWBJojRCBpewgswycg@mail.gmail.com>
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1782230482-897427
X-HE-Meta: U2FsdGVkX1/tUAMu3wd665lmFIMUpvn6BdAvDzhQI9W74dxuFdbHhxpFJbH4mMutZzrkdKPkJ0ynBcYpSVCZ+d6uC/OaYNWJyC+0rN4WBisumxZa8ZPrILSuShO+gZOakdDtSV/ojBYQj8+Kq+3TgzAQmH4sT4sVOJ8Hv59vIGPkFjwtk+f5whC1Hh2Yq4QDoZbDeg1Peir2GFz0pQQsW8KTXezRG5bDKAhwuM6LXRZ3C3RTVkTxvIwaIYNeYdmAj6n4xAKno+9wsPwqr2N4h2ZoLPjTLioJrtVk7YaGw3RQsgCb0DznuXcB9oEsr5vBDgeqiQ0HcQMZ23Qv0MMUO4zFDZSa68Vy8KdIu4RPn74F99Fcd9BYAOAt+1eEPIBgJJT9sOMzCZtUGIHbAVim7RCnWTj7Q2JdneDlKQ2p/YmiQVI4dVlm7sWLxtPK22l2jlMeKih+n0eBz7Efvrr7tsH8iujfSiN86Dp+ppz5do/9kIvpsryX5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 4:15=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> The cachestat() syscall reads page cache statistics straight from the
> file's f_mapping. Stackable filesystems such as overlayfs keep the data
> pages in an underlying inode's mapping rather than in the overlay
> inode's, so cachestat() reports all zeroes for them.
>
> Add a ->cachestat() file operation and route the syscall through a new
> vfs_cachestat() helper that calls it when present, falling back to
> file's f_mapping otherwise. This lets stackable filesystems forward the
> query to the file that actually owns the page cache. No behaviour change
> for regular files.
>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
> Note: Memset change might be a bit tricky, I moved it to no
> ->cachestat() path to avoid multiple memset on nested overlayfs, that
> means that ->cachestat() is expected to be able to handle unitialized
> cs.

nit: maybe a comment somewhere to document this?

> ---
>  include/linux/fs.h | 10 ++++++++++
>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
>  2 files changed, 45 insertions(+), 8 deletions(-)
>

LGTM otherwise. With Amir's suggestions incorporated:

Acked-by: Nhat Pham <nphamcs@gmail.com>

