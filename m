Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69758CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A98D36B024C; Sun, 31 May 2026 23:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49756B024D; Sun, 31 May 2026 23:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9385B6B024E; Sun, 31 May 2026 23:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 830666B024C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:59:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37C021C0884
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:59:04 +0000 (UTC)
X-FDA: 84829988208.19.FC9E78F
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 38AA82000D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:59:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OcNdESgc;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780286342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNudWB04Wpw+ZJC/nF3aN5jO9/6RuxUwPuu638+/KJo=;
	b=F6kSrRSmTq2bw4egoymsfMxQcX2yxNa5cehAbYj09Wn3DRNcX4QNaywvVVyb5967yBDmYn
	m6gBqCin5N9qQOPLjI6o7DPpkyUBbcUpoGni57QtvBfbHdyKfeT0966hcDcu6GAPDl3nkc
	J0FeTszl/JEdAbbq/kfu5PZiEeb8MG4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OcNdESgc;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780286342; a=rsa-sha256;
	cv=pass;
	b=bNjPCzs+WxfZ314cQ/LkNUF1FhvrJxAodBQ3nJOhgMFJ5jJ8IU+ftL614SRw6DPngziNbJ
	LRTTZXOA95BldPuf1O1OPzjeAvhLcuQGIxuiDOmD7FLHUPspLvqbI1khK84fqWfLpx0Kwu
	pQQ3DWGKLWnQLflzbnuf01YiqC0VmO4=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45eec22fab7so1806171f8f.3
        for <linux-mm@kvack.org>; Sun, 31 May 2026 20:59:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780286341; cv=none;
        d=google.com; s=arc-20240605;
        b=DfPPUSG6cAbqHHtBU+GRa2+aUJv4CcXeEi3bF+Tx6JbfusYCLnjN2xymQlFDAvRtOd
         cBbij0DjKVhoBLe6RVD26MbTB/k5UHuPRMJ8lIKijc6hmHBkKjHEuRsrBHg1vdtgji7S
         eorxOy6h1gpOv26cvF0RoKoFDAf5VfuAQ7Q70+mX3XZJdBvJE6nVpofHJuOQELlc0hJ0
         T21g7B685XTKCHPN5uMFxxrXWzEvDltSr6UX2JxH/PGwpSC/iVQV3txWuTmbI5I1Oe1q
         S1GxPwCKCYnHFotquaVDBMUK8XvgBHaijdCGvDr2jnUiHDDOuDBFInoIj+Eg6ts665Qn
         xnxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jNudWB04Wpw+ZJC/nF3aN5jO9/6RuxUwPuu638+/KJo=;
        fh=QvsseaeCyAaOKv5SAomz7C+VVdAB96rUl1FQXaquPGg=;
        b=TOPn/HAsK9Z3h76dJxC/fup//awht2pIJ3LY1wDGaEKn0j9vaIWV2OdZ2NCuSipLnL
         qKqVL/UssDBUxBcpgroF2OYpNUDqPapeaZuUmeRbv8aWjzooIVfDactbvH7P9U1+Yw03
         9QwMw+38ihfqB+dHHwNhUC9Qom3SrU32VPoEuJbW7wye+VFRfgR6rAJR73MwevfsAOb2
         8qqfHsN4wZDOOhCp7DYJAt5DC4YmYyj+tJq5aufH4U8fvWgsJb+IRPitN79T5QxQc7N/
         mW7v9WaXSr2jkJ2EJWOYRdkMp3g9XaIMmsL1O1dzenUYwzN0/2UwqcmHfIencLhtJO/n
         vOMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780286341; x=1780891141; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNudWB04Wpw+ZJC/nF3aN5jO9/6RuxUwPuu638+/KJo=;
        b=OcNdESgcIJAeddsnu03mRfiNzf+qXQphliqHcDFLMsleiUz4iyBuWVIze6gbAc+FVm
         6ooTaDkEwfqT82UAL8yW0QC5RC52ACvY2vu5NMm7SryxV6LIkylD7AzKCbvbRRGDS9dk
         2wbFtXpAD6I8y+Pg1ppx8FVoTZRBY52XAiQE2G6M3sV2+L6TkVHv7W5l/kiKxVgJUjjo
         roFGlvYQDu1RnmjtN3tqSnsDyGho09EHH3qbPsAH7f8Ho1CV9OQrJgDkOVeipqjUfX5X
         QtHqln3YPTZ6jjIOaMJsGg0fKYAMoQCAWD6qQqV/9mjr+rfuh9fqfbekLyVA2zbTXu3h
         bwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780286341; x=1780891141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jNudWB04Wpw+ZJC/nF3aN5jO9/6RuxUwPuu638+/KJo=;
        b=O/zY3Jv0iFJOwDf24yJWdRqhfRyU9CKi+EWuvldiO2LZd73xYX66vTb9E0XwiXCzaG
         vsScDxYLDL1v4S3eK4ZWvHS0jAOfdJ0H1sId6qcMum7k83aWHV0DAwGGIR3Pe1bYR8Rl
         WtIQZeumCIp4btpENtHaWiCR4IaGO4vy+6ctA4MNKd0A7Osq4K/X5q+bMl/5XYWa7ZNm
         PhyBA1ns7C8BVpaNaDPs+IHxMdb3QbYQQeaO2PirnzjVXZAvrig8iO47s1l7pIa/se9s
         mZSRFDU8baM8frhHeivlfTetNiUh7nGNbu6fn0LS0jrS1tLDH5j/95PDTjU5Bn7AzbjZ
         JuPg==
X-Forwarded-Encrypted: i=1; AFNElJ8b5Rizr0mrkQxbkz/74UFipJk56/4FvjZunkE46/MGoLWhC9cBOFjt8P7+BqHNbKbhV71i5Eb22g==@kvack.org
X-Gm-Message-State: AOJu0YzDzaftscFXw1YDq5ehsW6bWrwsSjNs6d7rNPIBx/Gq8IHY8DXC
	1DCX9b4TczmcENOJSw3XviI2i/luzIvJQiQqBt4ceVt0f3XNqsLdk+4JTxHt9JvZ0Fpjf53e2D5
	e2hOSli+4IrMFenzvppJweBvcjAr434U=
X-Gm-Gg: Acq92OFUJObbJLixJ81UevR78jFQOWLXviOLLDa8zrdw8IoF4zOaGIKXoZyOGc0z0Sw
	IHRargJbJ5EEUntaB+qGKCZj09NMsm2vAwcxing82Obcf1hMYQUTibEevvK7aKWXcvuSdwykeb8
	WhVQzyv+fIYEplCAKxqREQ57acMkf/+DM5Hlxio5Sd+Ef6Ppdp//pysAlBOU5EmVv2+ib+POyZ/
	DL4IeWSkbgrVrqLLqHmfnMDLG5evbxnaoY5qppWTyAJfP8Uo+tzPvxYSnt51BhC6YjJbx/0i6I3
	P1RPB3RR20319tdKWhCKxvrzoIa7ossHhjzNCAuhhHEX3JpXk0MipYQvLCeH+ZPitcOpRQKXMpq
	MPA==
X-Received: by 2002:adf:f78d:0:b0:45e:ed7e:f8f8 with SMTP id
 ffacd0b85a97d-45ef6b0231bmr12455650f8f.8.1780286340409; Sun, 31 May 2026
 20:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260601030649.2513937-1-hushijia1@uniontech.com>
In-Reply-To: <20260601030649.2513937-1-hushijia1@uniontech.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 31 May 2026 20:58:49 -0700
X-Gm-Features: AVHnY4K4C1soJyFxmMVHHhTiOD884427RYesf2FVX6XxkT8y6UJ_fmjeCZLuc_U
Message-ID: <CAADnVQ+=-UM-JC4eM=vqvgK2tLt6PwmDjOcrrDG9kz8BV6n49Q@mail.gmail.com>
Subject: Re: [PATCH] fork: Ensure copy_process() returns a valid error pointer
 on failure
To: Shijia Hu <hushijia1@uniontech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Kees Cook <kees@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, LSM List <linux-security-module@vger.kernel.org>, 
	bpf <bpf@vger.kernel.org>, stable <stable@vger.kernel.org>, kernel@uniontech.com, 
	Quan Sun <2022090917019@std.uestc.edu.cn>, Yinhao Hu <dddddd@hust.edu.cn>, 
	Kaiyan Mei <M202472210@hust.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ro1osiuukgc7d74di8ohia8c6qsd13bu
X-Rspamd-Queue-Id: 38AA82000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780286342-188591
X-HE-Meta: U2FsdGVkX1/JyUwXJbcmChSQhkSXhLbCH4LgyMiAJ+EZ5HTn2cQ9G3h2rN6sJLTRvDwy5Y4m9p6Ib94gE/MuCeSACgiXyR9dsHA+h8qf9wB6W9as1gCZV5xODUWhYYalrrvnFKpMkt32zSgimJTXgsaTUZ1WXvD19spzjMQKk0jPszNoBgrDYSs4vU5CYahCJfwmAXXjJgiKXRW2IYGLr9EfmicnHvd0nb9IARbNt3Yh24fSHo0btXPRG6mDil0siayeicCl6NnMjTJACpzqEnLTg/EwfZmOla4R+SZegkIkVQwV1JRkTIFJYIff2MkbgJx4qT4gVQc8BmoNd0rkALmULK/O9e/RZxYURnBxQZy/IEVyWLe7wRMmX6npNdjnta6XKiYGu+HQFmGNygGUyV2KWxQe9vXoSsVdJrJRkYMF3SfnogwPfYT/GVoixE2AXe5yMcQwsX9iKtGgF2I4B24EZRNtnE7i+OR9DfjrOOclXEwEK4xHlKbHFKqLHlZNDoqK9kBg4/ieXzIhuPMUrEJVuqILRKmFV87ebF5CCDu9+bMSseULxK+REAq2HOiHx9aa63amgc7Au4PyfWfXthj3In1BJL/dbCm5z4Egwj2MrN0HdavU8bhehzZMQDzBeIQvN5//3pFej0mMa4nL46FBHhTIw9VwNqwJFHGIQHnwdOGlfhWSvzkXct0yKy3XPTrMnmiRgEVulmpPHm//DEac0PKDdFtK2oQPdri0EBzWgbz4Uq7XAbpX1Iq0TxQpaZhgFzlU+DuDMV6AK5QJNfTlxsd5SMlZrFj2fAafHh/wr3AKOxAJmu4uTqz4mzzt95nXFu2CSNQH3LSoAfGKl9fB6vjFfkaGDF/R0KuaipmKRJPRUJEYxYms/8Wq1Ydu+ju5xGuNQby8AFzSgekJvNtf4kiKBa/e3CFeVgdkQGc4Cz3mTGhfnDZ9KAHMLTIcnx4/Eq8P/Fda2VthglU
 0FYnyUwT
 hQlZCF8/nbreQHx4ufuuCXF9TG5Njb2EKjyOaTP/l7C/AysC9H8ymcsaov3tgcWtbjDvjpTIyOXnBXU2ViQVKArH5FCtidI+GSZNphZZaFfdKO2tJv9127wJ+/qOm9WY3qP7whSw2FmVyfaoJUP8sGYWv8MHrCpJqaj+PcuHhME4k0xhsZj0S5IJxGP0w5wJvj6wlu+KSUf02hYi9bSuuqrmiI+SteBn1N+LU7KFYj51es4t+z5HcT4eDt/5O2VE1/Feag8FMCiYdQWT6rk83jmq2ozqJlC8b7TLT2XS5H1BOx10e/yIfS9GwI7VReQfNJ8zxXJw90cR1qGFS8sRYQ3yb6cRFBErFdTbyjfBkgt4M7hBT8lbm4+/a4aOlacV9n8syFkrTQldE2fs+eY/XcaEx5isyLsnaCnb9IDja2nCK4DJ+yKxfLYMDk/YO7dz1pKNh8qV0Gp8nP1OUPE/nMej4VBPpVax/0WM6eevWmd8N2pDKnjCNnc09IxOz6TytubXDLflSzdoejQKuklB7JDrgWiJZDFlfQP/wz5/xQrU57tr/PlN4W2eMm9ubW0PP+VCec/dhn5W8iIo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 8:08=E2=80=AFPM Shijia Hu <hushijia1@uniontech.com>=
 wrote:
>
> copy_process() returns ERR_PTR(retval) from its error path, so retval
> must be a negative errno in the range [-MAX_ERRNO, -1]. Values outside
> that range produce a pointer which is not caught by IS_ERR() in
> kernel_clone().
>
> This can be triggered by attaching a BPF_MODIFY_RETURN program to
> security_task_alloc() and returning an invalid value. copy_process()
> treats the non-zero return as a failure, but ERR_PTR(1) or
> ERR_PTR(-MAX_ERRNO - 1) does not produce an error pointer recognized by
> IS_ERR(). kernel_clone() may then dereference the returned pointer.
>
> Normalize unexpected values before returning ERR_PTR() from the
> copy_process() error path. This keeps the fix local to the fork error
> handling contract and does not change BPF_MODIFY_RETURN verifier behavior=
.
>
> Fixes: 6ba43b761c41 ("bpf: Attachment verification for BPF_MODIFY_RETURN"=
)
> Reported-by: Quan Sun <2022090917019@std.uestc.edu.cn>
> Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
> Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
> Closes: https://lore.kernel.org/bpf/973a1b7b-8ee7-407a-890a-11455d9cc5bf@=
std.uestc.edu.cn/
> Link: https://lore.kernel.org/all/20260411163556.8567-1-yangfeng59949@163=
.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Shijia Hu <hushijia1@uniontech.com>
> ---
>  kernel/fork.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 8ac38beae360..40bfbdfffbdc 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2599,6 +2599,13 @@ __latent_entropy struct task_struct *copy_process(
>         spin_lock_irq(&current->sighand->siglock);
>         hlist_del_init(&delayed.node);
>         spin_unlock_irq(&current->sighand->siglock);
> +       /*
> +        * The error path returns ERR_PTR(retval), which requires retval =
to be a
> +        * negative errno in the range [-MAX_ERRNO, -1]. Normalize unexpe=
cted
> +        * values to avoid returning non-error pointers to callers.
> +        */
> +       if (unlikely(retval >=3D 0 || retval < -MAX_ERRNO))
> +               retval =3D -EINVAL;

This was reported earlier and there is a fix in the works.
This approach is incorrect.
You have to fix the root cause, not the symptom.

pw-bot: cr

