Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E66C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFCF26B009E; Mon,  6 Jul 2026 02:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAEB76B009F; Mon,  6 Jul 2026 02:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75956B00A0; Mon,  6 Jul 2026 02:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A755F6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:00:15 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C75E8CF8E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:00:15 +0000 (UTC)
X-FDA: 84957301590.12.89CAA5A
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C2F718000F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:00:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qa0c9v96;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783317613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Md2Swp5Fs6VEhfUnYJXkmbFWYzZQ1C9WWb9GsSoCCA=;
	b=Gah14wpxUEuu+efWW0xvEnT2WXxoXGQTrVRktlhAlG1hQZGasC4giVwcV48n7vxp9uxE9g
	yaOexJ4KWt0qCs5QXohT2tz2unWY0VVfE2tl0Po/rts9iAckBWKxQEYdQoAyszi6uvJQqn
	wPt5p7bW2m/axCgfqNsbvZCgIfxal0Q=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qa0c9v96;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783317613;
	b=Dddv6pemryxg5Mg8tyG35uATfx5NN4mJTWiUwCB07jYc9n+6ew/0gXJN8ngpHjearuqQXK
	p3YbhH0A9Z+gGCt7KR4e+iwpvW9b0VSIqRumCSpNC/gGFfAg6JRITjEyh7vhZOmQeXJhFw
	F4lLK29FfUr2vP4DAJAEmeYvVfdP6aU=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c125bce2294so275030466b.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 23:00:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783317611; cv=none;
        d=google.com; s=arc-20260327;
        b=qBJ/Zv48wPUctN4MZ0w6s8ZvtUJOs323e8yD7jC0WkkN/xVpb9o9WgvtiL8hs9//1v
         OUfEO+e8IjzLZ0P8kVbSXLh7XHxKvklE/S0kyU6mpb2aYJFE85XXXAg2OHk4nUTYXmpL
         285zQYG2jcyz/Y60GoPugWYdSju2Z8bQZeNnXAwkkr2Tb7wARon6wGF2KAEHbdjm7irU
         qlL6Po+SYshRyYtUzhMx79w2zfshJaal69kX43wI80NpOXG29II5ON6TwZjzREpph9k8
         Vu+ANcXYfkeiPYr4pg9/gZYDvnOgS65QUVdu+IccJZM1oa5pj4Q5lWh/Vd9/QCKjnKxW
         jKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Md2Swp5Fs6VEhfUnYJXkmbFWYzZQ1C9WWb9GsSoCCA=;
        fh=/yp8qoSRWMcTVHk8EbE03KEIp+BcqivnZZlF38OEyuM=;
        b=rvL25BnM5cOJATbWO+Q/GllCzuKFsbFKe1BuiskhjyHKgTfZRofGcpR9GYbU2r0VTC
         MqvC/Xn+NxZUoQ4efKDK61qmHx2Ptz1ggy13Hfl/98COfVCFxbcTvMXJ2/woDotpwWP/
         1yXHRk3I8VNcqRgBXIMvPPFioIKDswiho/z9u1XDLZBsqAF+NCF4pTx4oRTX1Nu12VOW
         lDjDjEdjo9j4CRCldqqjTmEZtupBp5Yl6utgJ0yvhNoQ8OqG3YAl+Ih1KKOE0nsWlMT7
         pmE0vfv5sd1Xs9SRu5m6mX2xnd39epkfc6p9lDbTzW+pC3DObT2aftNAi7wyyQKonLEa
         gOXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783317611; x=1783922411; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Md2Swp5Fs6VEhfUnYJXkmbFWYzZQ1C9WWb9GsSoCCA=;
        b=qa0c9v96rm1UTjL8cCl81h8go6XePXH+fR8ktegRjXkY7BdcAvF1nLh9lijPdGd2kM
         JNP1RnPD7WoLXl9Q87vqjaryc9JPnPxlnEGUNl+84NzJNgL16jB37215oEbq6ACLaJwv
         dxi2acS8RO3opaPEQoRXe3zJnHFFf4wcKAxUimhtYVeyhUoQ0zzzLKP3+SwykKuvZdF2
         tNZaom8Jbh8WWyj35ekrpdgQdZOz5VG+/N45EmEKyERL34SzRfKDwXpYGoDkWyJV+6hk
         oUuwnEVAC0yYB7r9jpZwNKZcZBy+IFTfidTeQejee/iKLlgbKtrb9n32bPsKWcZA7WDy
         8VJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783317611; x=1783922411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Md2Swp5Fs6VEhfUnYJXkmbFWYzZQ1C9WWb9GsSoCCA=;
        b=OIa0W4PHMmtcqHsz1mmjtWzPpEijp5ADq/Rcl1bllFkioxWHoLHMzRr5J8A8mLKSEM
         YfSQPluFbQi4CY2GpFVv/BYYbXeUx2OyNlu0801kRHFTBfd2DYJhYisOZHkYpYlGgUAi
         DmuaNbYT0B27y9r/iuCLeTl0CKyN2aXuqBShkXE+JyeqeDAJfnQR49SdPoU6/W6ies65
         C9yAcD1G++jZf402PQ79so2uPbYwmnHsZ808YUR0qXhMyhVFEPt+N1mhUVYIalSTwSr9
         vlTLv6Ky2PTY0Az9G74p6StmyB9M+UwhzT7g/zs0TEqsoBT7S4uetgm8mWAwT22Q8URo
         44rQ==
X-Forwarded-Encrypted: i=1; AHgh+RoFDl98lwoWHghoiP0q8tjn5WQgMcjszmSdl7x+isNUMBc3dbZjJj5g/e8M+by57RwtXuu3o+PePQ==@kvack.org
X-Gm-Message-State: AOJu0YzkLzPMoHLl22W7FKr06u4t2cuxDl+VX2ec3UGVXwFRcrjlWdgb
	eCoc0hXIo2mgRNLs3214vGTwe1RHlkUCMbstEqhlnIDTgWDZbdBFRelPUyA6sJpblBfz8OPiWOy
	uUd71vGSzOyP96qJdlAC00JLZ4iVMYj8=
X-Gm-Gg: AfdE7ckQBAB6lVmQuhl+gIcZL03jVXcH8pPVR6yXrkFS7VxWE1oy82Tt5S1+nyUOLnZ
	cT7jy9z16/enYzxA7KFpk/cighgcr8cLF/0JdUNb3BhZ94fK+FHP6DjHiuVTG1V7BNhKAGRQhsh
	GVziKMCtcVhax3pML07R1VJzhF5rbW7j44wZm//+ms2Kh3rpItfCDb4Kl9lB4QZ8jRbNkqkHNVl
	8zPxaReVc/grdrFEVNT3Y7698M1V3NTad+gLmI2IVBF1MhnDO8gL5xUBSyqunTaHfh1rmFu0NwT
	XA84b4Bbx2rAm3QrcfurSydJqfpO
X-Received: by 2002:a17:906:6290:b0:c12:e178:9e84 with SMTP id
 a640c23a62f3a-c12e6c5ece8mr301352066b.49.1783317611266; Sun, 05 Jul 2026
 23:00:11 -0700 (PDT)
MIME-Version: 1.0
References: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 6 Jul 2026 13:59:34 +0800
X-Gm-Features: AVVi8CeDS7jwf4J3Nj3CLOia27um2hs0j7p6dhEkBGx6Lck3Udi6yttVyiSYd9k
Message-ID: <CAMgjq7AQcyypJ-VhJ_CxY6fdEph64fxjOzzYU-=EkMrHemkpzA@mail.gmail.com>
Subject: Re: [PATCH 6.18.y] mm: shmem: fix potential livelock issue for shmem
 direct swapin
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, stable@vger.kernel.org, 
	baohua@kernel.org, machao26@xiaomi.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C2F718000F
X-Stat-Signature: tqs4esdidnji6c3pjwkh933z44mbnm94
X-HE-Tag: 1783317612-575016
X-HE-Meta: U2FsdGVkX18z8VB/A4gPVuF13kG8FkuiP0Tvesqdi/UgEUDiZx5WBi9tufbzk045pOZ6Q4ve5lk20rhkDo0BIhlxIOaX96Vxp87EBavC6KHljnOsbrCuCwI46bSI17zCKNRHqH+S6xC+DlRh+x1lOOMx8GT1W9ejNLAuZfhjwoHwxk1/yS4G/bVM3kDk1FrTSGL7dab7IWzX68/VYagoCqAOR9OCHc0MaPZ2HNg9Ce9t4Dtvf6O3mb87Y1mCWEfsqwc+/GaSWGiSlEVzQVIrmrHXdgoBXmdi0RecvczSg+3i3PuXTm3AUCFKez1BD28EOM7/48T4aL2WXF5XXaV7BqMvIREGZxCOuhTfBSFv9jdQJkq3uCxBX33kiiq8AzjmVbG1RzEdpYBOdqQJrSJSpxUk+YUUdI7GXZTgvic0DxU8NYkxo+q/XmDomugh9rFvJLTYaNHrAUx9HeOFwBfWMgZ5Jz8c62GazrFd/Eivz0whx2JZtP25ZFyATGosMqVveW7SXGujH1CcxbhVIshD6dZMw06uwqAkjhDhHPY2dAp4NaWvNlc8llpvQlbH5oJ6Kd1gFROtlyJioSIx4ENkuG00/3RP2WowhSYSlChKXi1BNPl7m4u2VToJPAAAOk7ylBZMMX0un2Ms/HFcIHSOF7NmJYPdQC/4OMAzxJvRnxMNNImrLOc89mhno6j6xcuTYdn5LBOJOOI7rchapaMpMAQjHYEq6GFuvtCO4rBwahfVxbybm2cRHZ2OEFlCboYCtSf6kYcLeLLvcHG7uUHXORCY/QAyqBZAjpSZxNHXU55JreEPn+f8C/6o4W3p71QszPhivyKYa9Wuy/jaVQgybCHFCFQjjX7VrNbvoM6kh36ZOfeNNlZijZvLZprjYm9156M+YLJ1B31966tDUq3w//6enNxlpnnM8DHeLgpRM0MeZlcIsKfxNWogtbHNbTL/vhg1TDdgqMIZ93b/8CM
 TUtqIKJx
 ZLhh9EN/7Iij0HrEcxj52fsUFWZ2RtPCvXfqsm0Q+AL+RhbP9e1R81ktKFNZkGJ+vRZENAcWgqE9rlSuRIAJEVfZw+oJm7kN5jbVApijp5KftZ35/+AY45rB9sOGFULxRKMZbNxr0b3cyNI3OTi8rmB61tEDcU20AI9/JqVrClHycc4TC/gRQziAHMcCfaspPbZWo400ZSrVwwLVVP7O88FjA1cR9BLtn0w/7H7QLT+FzsO7sT+C1LyXoOfgSuQg+NCkiOaRt9F54fFL5Um613ED+eOwG4wSxlTexudCxJeBWw0RmDV1lv2o04vs+oeiWQBbPXQ8Ke64Ltc9pCCOdpUTgBPGvjnKX4k7t+S5nauNLp1OSQi3LgcJPOeh0XcV0B/KuKPynpMDLMJxIgLdZK2zHlhEC4CLOjp6tQ70NqwPUEpv1SMOAdONF7wkESz/y2rG4GsVlSDJU5oIwXy8QuT+Ad1f36pvjn867AwlU60XrMGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 11:25=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> When skipping swapcache for synchronous IO swap devices, swapcache_prepar=
e()
> is used to prevent parallel swapin from proceeding with the swap cache fl=
ag.
> However, on PREEMPT kernels this can lead to a livelock, as reported by C=
hao[1]:
>
> Thread A starts direct swapin of a shmem folio and calls swapcache_prepar=
e()
> to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault=
().
> Meanwhile, a higher priority thread B also attempts direct swapin of the =
same
> shmem swap entry. Since swapcache_prepare() already marks the entry, thre=
ad B
> repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. Bu=
t as
> thread B runs at higher priority, thread A cannot preempt it, resulting i=
n
> starvation and a livelock.
>
> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
> swapcache_prepare() fails, following the same approach used in commits
> 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
> 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
>
> Note that mainline does not have this potential issue, which has already =
been
> resolved by Kairui's swap refactoring work[2].
>
> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.c=
om/
> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@=
tencent.com/
> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous=
 swap device")
> Reported-by: Ma Chao <machao26@xiaomi.com>
> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiao=
mi.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Hi Chao, could you try this patch to check if it fixes your issue? Thanks=
.
> ---
>  mm/shmem.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 94c5b0d78ac3..d4cb57b3b0ef 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2066,6 +2066,8 @@ static struct folio *shmem_swap_alloc_folio(struct =
inode *inode,
>         if (swapcache_prepare(entry, nr_pages)) {
>                 folio_put(new);
>                 new =3D ERR_PTR(-EEXIST);
> +               /* Relax a bit to prevent rapid repeated page faults */
> +               schedule_timeout_uninterruptible(1);
>                 /* Try smaller folio to avoid cache conflict */
>                 goto fallback;
>         }
> --
> 2.47.3
>

Thanks! That's much more simpler than I expected. Do we need a wakeup
queue like the one in commit 01626a1823024? Perhaps the reporter can
help confirm and test? I personally prefer to keep it simple if shmem
users aren't as sensitive as anon users.

