Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A0E606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ViQoS90X
Received: by kanga.kvack.org (Postfix)
	id 25BA66B06C8; Tue, 27 Oct 2026 07:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C686B06CF; Tue, 27 Oct 2026 07:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA966B06D1; Tue, 27 Oct 2026 07:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAB296B06C8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:51:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 696F51A096B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:51:20 +0000 (UTC)
X-FDA: 85368240720.30.9D9B5A5
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7ADF4120004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:51:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ViQoS90X;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUmrBECpx6IYHNhYlc5fazHVSIOYBwywuUSfjizohv8=;
	b=P+TFw5IJdhJ/t56bXN/r72XgfgmGUjY/FdmHSYuT9pmadoqWDsByVilhsQNyfc+0RaCVoy
	08kZ+PSNm+JcKp7YpF+LOuV3XBJjthWaE4z1d/4tEa6E4s3hdahe1OzcHWQtjlbP8WiLFm
	v6SRmCcNqIGyTZ+JaC2LW2S4Bxg/HgA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793101878;
	b=zUuD5LTrE5ID0q0BWlv3HFLC6/8HYNCOpToUwVd93lN8J05juTxOeeIh/Z6gEaxnfqgdK1
	q1xRcXaDwNXQ8+aqgxlycxIESzdKEOMctGWnQ7QC36wMBcjEVDlU8Yl8CPSxY0zJng7UOB
	OG9gDPca1wX4eKhodgFAl4zT1QwgORM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ViQoS90X;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a60f90a924so156822b3a.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:51:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793101877; cv=none;
        d=google.com; s=arc-20260327;
        b=Wcx3DNQAYNgxHpodB4vX5Uv4tplQYxradkXROTDb5rYm8JpnspWeASBr6dRgVtTKNJ
         fRS0FTi0XU+XJZBobtlG+72Qzjlqy5JgoO/mIgUYtFbX2kCWPM+OG+HYpX3XDUyVnri5
         0cc8mcFnWfeYzd5buROTo0rtC7jWRylLd+W/XLLAFWxeDIQzak3KxthhUTmXyPB6BU4Z
         9Hk4d0KtpwCDq9Hk3VlpvLYSw736GnrqjJkRLk0cuUf30EBDNXAPDQQ16zWK4kps0S3n
         29ITqSB4Keba0i42heBCiOdQ9ygd8DSbefeUP3IFHBHyuA6Q3sbczSdBAxIq5cL4qhzP
         Qi/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bUmrBECpx6IYHNhYlc5fazHVSIOYBwywuUSfjizohv8=;
        fh=hdT9VR5KPKcG8v267dyzXBAh9oA6G5uclddGb6VhEpI=;
        b=KcXBYu+pxa+0VryT1OpSkWTlryPkaO0okZTnPUpYunpn0f9IduxUitlPKSLy56TdvC
         aoM7H64yzDVHD3uHcnx8UWAnlAgG5RkoDzAIPe95YARghtPEusQSWqXgID5tPXi4y1r9
         V63L92v7VVbEa8wh+XM8qHfNOyQgECU4HBeNz4C0MlcoE86CO6g7CegGoHZPD2T7Plf6
         N9x9d3jN3ob50Fk4rbEiYC+fON698qHC27I0YwmW/OMMqgSwHQDlnMpQIhe+I9557Npk
         CHmzL+lc4GKr+Dzddn646ROPeOWdPh9nSTZBZqDxZIB8M9lEuNRdwLfs+Gffe3QNTjCE
         eEaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793101877; x=1793706677; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bUmrBECpx6IYHNhYlc5fazHVSIOYBwywuUSfjizohv8=;
        b=ViQoS90Xeda6QiSvL3LVq5lbnWA1GKRjPQYHIdn6ZUnh6mGaZAJyAgeKd2xLbU5S3D
         sajHlU/AGw4VnXV1PMdcFKTewqV+EMWupZ7mIaBh9amDitmBGt5L/9QkjJt4LMf5OklI
         ETK18N+KYGc0S9OcZ66VjKe7w45rlqS3ADzN2XM1N0/hLgOUbOjF9KtXY0qbBZQgJm8U
         /DzInHL7DvCB2LEcTdVZ44EY6XHzZ/riuaH2Hy+cNstR41M36XMJyIhJS1tdg+kZSfDI
         vUfs1Ku1V40Vq5VRcF8WavpkQsiX+2PwL7mrpVC3uDYEvRaUCufVxueiXOEsmssVBeyT
         U0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101877; x=1793706677;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bUmrBECpx6IYHNhYlc5fazHVSIOYBwywuUSfjizohv8=;
        b=kvWecv2BfmAhgpn9K9wMhbFs6BIwRboFaM6pGBfFb5MQPO+RvbRkZ/ORYG/bMv1ofd
         GaI+psnef6nolNPf9RfCR3KxP/0F0m5p97kj0XC5KKnD7x58YUi/NYDtA12Z3unQevjG
         VQSu4JZI4XghpF9DX+jMAov0wIGE71f1Vzai4Ap8819XtqUGZ245payqZs49a8f8VRjX
         jb1KxunmUAWCQOuQsnWbr6uSdTyr+i5pY2xadVN5T+Rg++FsJPdcMQQCXczOSzBrmt5w
         Si/yKsUkVg67/EtV0swIOrh8UprpnWWiFQ+0Qnwcm0aVUOaQmqInzs3qEyYY5TcB7O8a
         OmVQ==
X-Forwarded-Encrypted: i=1; AKwUvBxBTFbAWKawYpiupWlDt3ek0cG+XS28GxSAwrEKC05KX5nwDPRxJfAGWVhv8G0AIyFMOLq9simjpQ==@kvack.org
X-Gm-Message-State: AFq9FYLSPSL01pIcm7XLkHqdqRyyQHtSc9I4Uqmd2qEH8DWWDhEAQ6mM
	uFTwzcmP4zOGxlpnDPgFiHZC1yb0rXNm9maURP/aCfSiiqfi5zeJDNBRkls5yzoDvyl67dONY+v
	AlSvOnQXKKQxf6NVImIXZ/85Dc3j2gTQ=
X-Gm-Gg: AYBFou3ceoa5DLnPbDcP4ScWxpCTMDpmKcO0RAhvoss+JtFRr69MRp58YDL6fvfyYfq
	8NB7PLlvlUCfqV/AnrKjqftXF9pSHrTXx+JClzQnU7wpKJbjSsBB148UKjRVwYY02ftD/pVwDut
	EMLmJGADikWUSC2ZTfL6/s5rYv0nLMljHurYTyRcDtzMV0WxCDyjLR/8pINq2gBXnDXftyjoMKv
	NXh2zOq81mYYR/d8Egy56HWX9Kbv1Pl58XbUz+Zkw8oOUwBORenkzOBynffh3uNHicpjaASrNWS
	awi4t4cUZagjLGy9wdzn9qDKqixp3UYDnY9da2GA1oUMoNmtswPXQ9TwiFY18zoxiUNL1YkXzix
	LDx2vYAVHrV+hQfh7ndXZcyTxq6qVZnCFxAUfRLvRf/lDyli0c4wa3Y223pax8hGro1Vz4Q==
X-Received: by 2002:a05:6a00:3a1c:b0:8a2:753f:678c with SMTP id
 d2e1a72fcca58-8a367a36c76mr7405483b3a.16.1793101876780; Tue, 27 Oct 2026
 04:51:16 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <ar2YlFYjYUZ49ZA5@chrisdown.name> <at9kJwdGkHPsWwgG@chrisdown.name>
In-Reply-To: <at9kJwdGkHPsWwgG@chrisdown.name>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 27 Oct 2026 19:50:37 +0800
X-Gm-Features: AclHuK9w3cu477cLAvN2jZ5u1J4X0qRFiJaPiVLgSpXQ2zVF3SsFLR12fIJNRmM
Message-ID: <CAMgjq7BG-hM84bS4yRs1Bpo8=vhq1yoJPxkNpkvUhX7xCit5Pw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Make swapoff interruptible when unusing mms/shmem
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Vineeth Pillai <vineeth@bitbyteword.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Ying Huang <huang.ying.caritas@gmail.com>, 
	Kelley Nielsen <kelleynnn@gmail.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7ADF4120004
X-Stat-Signature: bjasmdnrembwmt5q944p6byhoe7645bo
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793101878-219930
X-HE-Meta: U2FsdGVkX1/XJf9r4HKDIAlU2FvDC8CVp/zHCKPNTIxELt4JHkyo1qgmXq6kZXBUUybfeUO2PUVXCrdJmwv9Yhg2n/jOWKAlEBnsM2+yLQejDDQi057aME+IvXxxVjwJGMtKqCFHYHDdOorEylzr/q+4btxFNfaf4SHZopSEkUiAVKoByX0x7unzfC9oSY4IUuW8E//wMpGqVkuJFYVDhy2NzUq8D0iPnJaOybxKqaYdxWGASqH5CrDgAjZBWvNBaG5h1bfTQWqMf3YL7xR7tZYEKoB8s70SzxUWhO3LKmvyuudbwejVNPndPo1WOCIrLE85DdS5yGn1fXx7VCHei48Q1bMfZSRoD5TtnuQy0lef6WrELxKJ20DFyTX3tAscxk6Mj/qRzN57zAv8VK3ZTPZ+Kcv+5njXKT3Fh8arHUj2m4wj/3ua5Ait5dhc6ZheoWnLzvgXWpgn7n3LQIfkTZpCg9tw9JDBbZRdtAc918z0Fukrbe6JC5Z7Co9MdnBjBT5eENnXNVUQyppQSWhIMcWC7ApZ3/Adj0gKA+hzgkxF1nviYNr7SBy4veHgPx+dQRAknEXkp808N2y9Qlq6FdYZyl8SHsLGOgNLowY3/pu/dfCAw5ObPR/9jEcvvFjlQnGIhGASgn/GRWLbvON4BHnVFBl9OS4PWT/2Ys9YkOlDLSpXYXPGBJqlk5S4fhuY7ARWp8j8FXoEWI/EyQpOE7WO7ngBjfevf988YT6OKfLw1sMH6UhNJntWlTtJsYy/LZxVKAwuwECI7j2xNs7X+Ma0GISNp5mEVRtxJ7wetHOY5thzFlUzwlkbQhnQz6tBv8cjFsxxslwG6OANWVx4bOhaXvSDTfzRWPCL0h411fZxj9YgihA+KW4H+Bj7a+XOLf5MaM3L0u7C5CvcUa3kC5e5beBlSjIGKVM1qBvPMQkq0ejM+1h2gPwpUSkrXj20uWacDoViZyLuFwh5lCt
 JXDlaSUx
 OsSZilwvSbQ9/YuHlD3GjqLFt6igsxWQvFXK9ejgBAHx0RPGRlXUoYwLBf2mNQZmIwu8nBkggWJo2K92q6/K5e8M17DfwL+OEnywYFyhs24NH9ql6SRECL0hhpIJ86xsFhp2m06GBVbEt+1QFZSxp0lS1Vr74LCH9SrNt2D3346HUZ0OpeLltPmjm8Ze6b9N1R0XoTo5Z3Y+mw+MEF1D3NwppsOc3fL+k6KsQT2KVBOZ0lfF1RgnViZU0fyboAbbpAnsAQ9OinsA1ONYHrw97UwUkMuGsbELGHs3sAdUR1UsGKqPvwoh2I1NrdN/yySRw5Ru54A8ST/nhgf2bg9VGWIkFKzz8gME3PgcxvulLopNmns1Ea3FLz8HQmLSwg6mkStbP/tZalMzPI7NTQJ2xMhyrcWKSwjk0RLDqkCTW293TnPUvdfiBPVzNbubkOJe8OVGJSqHj2FbnbJHh1mOQe62y3BgGoWJI8Aej/f+M1QU0R+3FHLRSQVssf3BeNbGHWjMVhbQyalCPxH7cJkt8+L8l649o1F9toBDKPFBYGCdHrbWoh6q9iU7QHKMaU0NCUVeOf57mcxJxD78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:35=E2=80=AFPM Chris Down <chris@chrisdown.name> =
wrote:
>
> try_to_unuse() only checks for a pending signal between mms, and
> shmem_unuse() doesn't check at all. That means that once swapoff gets to
> a process or a shmem file with a lot swapped out, nothing can interrupt
> it until every last page of it has been read back in.
>
> Just as one example of where this can concretely show up, freezing tasks
> for suspend or hibernation has to wait for swapoff to notice the
> freezer's fake signal, and gives up after freeze_timeout_msecs (20
> seconds by default).
>
> Here's a facetious example where one swaps out 2GiB of one process to a
> swap file on ext4, starts swapoff, and half a second later tries to
> freeze with pm_test=3Dfreezer. Writing to /sys/power/state then fails wit=
h
> EBUSY and this in dmesg:
>
>     Freezing user space processes failed after 20.003 seconds (1 tasks re=
fusing to freeze, wq_busy=3D0):
>     task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:29=
55   task_flags:0x400100 flags:0x00000419
>     Call trace:
>      [...]
>      io_schedule+0x44/0x70
>      folio_wait_bit_common+0x1ec/0x3d0
>      __folio_lock+0x24/0x40
>      unuse_pte_range+0x2d0/0x348
>      unuse_vma+0x158/0x248
>      unuse_mm+0xfc/0x150
>      try_to_unuse+0x104/0x3f8
>      __do_sys_swapoff+0x220/0x5d8
>      [...]
>
> The same goes for anything else that wants swapoff to stop, like an
> admin hitting ^C in a panic, of course.
>
> Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> try_to_unuse() was driven by find_next_to_unuse() which checks for a
> signal before every entry, so let's restore that behaviour.
>
> Just as an example of the improvements, here's how long freezing takes
> in the same test while swapoff is happening on my computer:
>
>                       before                  after
>     400MiB anon       8.925s                  0.028s
>     400MiB shmem      1.639s                  0.003s
>     2GiB anon         failed after 20.003s    0.011s
>
> Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
> Cc: stable@vger.kernel.org
> Acked-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
> Changes in v2:
> - Return -ERESTARTSYS at both new signal checks and at the existing
>   try_to_unuse() signal exit (Baolin).
> - Request stable backporting with Cc: stable@vger.kernel.org (Andrew).
>
>  mm/shmem.c    | 4 ++++
>  mm/swapfile.c | 4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index fadf23f9e21e..13e0786436cd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1742,6 +1742,10 @@ static int shmem_unuse_inode(struct inode *inode, =
unsigned int type)
>                 if (ret < 0)
>                         break;
>
> +               if (signal_pending(current)) {
> +                       ret =3D -ERESTARTSYS;
> +                       break;
> +               }
>                 start =3D indices[folio_batch_count(&fbatch) - 1];
>         } while (true);
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 254ce86fa923..0f72a5b23a3a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2689,6 +2689,8 @@ static inline int unuse_pmd_range(struct vm_area_st=
ruct *vma, pud_t *pud,
>         pmd =3D pmd_offset(pud, addr);
>         do {
>                 cond_resched();
> +               if (signal_pending(current))
> +                       return -ERESTARTSYS;
>                 next =3D pmd_addr_end(addr, end);
>                 ret =3D unuse_pte_range(vma, pmd, addr, next, type);
>                 if (ret)
> @@ -2922,7 +2924,7 @@ static int try_to_unuse(unsigned int type)
>         if (swap_usage_in_pages(si)) {
>                 if (!signal_pending(current))
>                         goto retry;
> -               return -EINTR;
> +               return -ERESTARTSYS;
>         }

Reviewed-by: Kairui Song <kasong@tencent.com>

