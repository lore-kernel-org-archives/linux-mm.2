Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D17CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993A48E00A2; Fri, 17 Oct 2025 10:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9447C8E003B; Fri, 17 Oct 2025 10:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833208E00A2; Fri, 17 Oct 2025 10:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F75F8E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:52:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00E48139C51
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:52:30 +0000 (UTC)
X-FDA: 84007897302.29.5B55B76
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0F9C5A0007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:52:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TtBjoiCR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of bijan311@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=bijan311@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40nyfgQShmFtY4cCrB122dpcbOTCXgM1IQYT54zJSJI=;
	b=PMB+8w7prpoHzhS3f+8h1lIsv5m7UcNP7OsdNWhV0Mu4gItMDAB1elJWRsLSlkfHEJ0Yll
	//N7KrbBlkRXIUoJo1lTH5eyJMrblzPnsvLY1wB0Qk0eSvxBVVhjWKC4EE/+L/pc5U2Ivo
	lBNPVQrIhclIdrK9TOPJVlv9L8q3tFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760712749; a=rsa-sha256;
	cv=none;
	b=dnzsDW08IoqA9xcqw0hZvqvHUp/zPlueTe5Vffvsuo4v+whbW79Clzd/B057KoLSY5jMho
	Se2//o6HjR+w7XMxOnLsX+HnTa98EIP8Z7dSu8vf6eThwXUyec96pafsGvFrUK4aSdvLwj
	+RJnZ//Blvuovq64wGBM/VUBYOyGUlU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TtBjoiCR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of bijan311@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=bijan311@gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b4f323cf89bso403463766b.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 07:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760712747; x=1761317547; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40nyfgQShmFtY4cCrB122dpcbOTCXgM1IQYT54zJSJI=;
        b=TtBjoiCR4mKnD4QPJ8XsSD4iKFI+qCUFIdu1K2d0VRSn9GvRJsD4qaWUfL0Q/w3spK
         R9++005azhbNX0yPbVFbUwRuL0kYg99R8VIV49O6Nb4gnA7nZKO1uHb+UDZzAbT9Bc73
         ifYpXtYFxktTjryLnYNcYZnVUnsS22/Xzf183olOObP2+PeCU0OrcxoIne6Tv7Vnij0x
         qI0B6UUoyH340LYNc2SdwtSgGGhF58vbKxTxDU7wm36sMgJCrrULYhf5etuzd3QQfe7O
         0Mwa3K89SicuPQB4HEIi82fU/VXaWI1WNH41n7cI3YNRGB7UGGMxs1uLLaV25SVvS+70
         tALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760712747; x=1761317547;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40nyfgQShmFtY4cCrB122dpcbOTCXgM1IQYT54zJSJI=;
        b=UVpLwivZHekDr6kVwePbdVnCINApcXXB+PzUbWhFc1b5trGA08HmfKAk0dqwxK3RrI
         WjBWDNvEa3hL9i4gIbRoWnQNhiNYzRILNX/Xf0rHe7SzFZZNbfESgtT7LgpA9Zmgxt3r
         Uw8vsARSLJHAvLI2Uy4jR/MfNiBB4j9gQUneIyUI7HDuKJIPwSItb2c3bdaAZR6sMgm3
         Y+5h+wXoOpEXgGoDfyyAZSXBeDQ2U4kXCqtuuP2EHR151uavdJdcD2WiR+CKDpKnaJ8f
         OV32GP6dYUEtuxsX063EYBR0iJlfvaP1ItKE+hc5Sz0TSqF6ifcR+Wrx2a6ya1rFxats
         yYSg==
X-Forwarded-Encrypted: i=1; AJvYcCVpTLaU4go3x0T19t4e9a7oowhT9csh4O60a1+wb+Os9NU2NvMyz98S3ZfJinkdl0TEf98GyJwKNg==@kvack.org
X-Gm-Message-State: AOJu0YyQZjfZIrbPos0vtVljY1a80FaJ3G5Dho9Vadt2gk0fqJiGDyvs
	dDtaOSuuR/V1T+7KOA5TKb5r0d0TWl+ormv0o82JWCmd78EiVi6xMj/JjOjtq3jN15h8QCbh4Ye
	8O2phHE4EixsxM95cV9/gwaqFxNNDniI=
X-Gm-Gg: ASbGnctALRMrx5jAowWn3tUEqELVvc2voe2+/mvC0PTxRJFThAd/o76OzBFTj18266b
	U5FVS1WNddg7Mw3mH7Fk+bpyKS7u+ddtGo7HnhWCDDSYMDtBKc7zzNzIrn2rzJ2GtZfPxHGfXi5
	vUrcn3uWEv9+TDGjxj/Mzz86zs7rg2TCvLrFtnLpfCsu0i0DFD5gRxjr4BqZ5jv+KR+PGhlp3Hl
	LsV7M87e635OZKzckxONC6uuMrOFWS5EPrawVy8Ve02vqJbWSFwwz+2Ad76bB/tXvhLj4AqQH7v
	v/8i2B2VR8OmQZr99Yy5Rva+wfGlm7WHps8lj7a4
X-Google-Smtp-Source: AGHT+IHPzDupjD0Il6mQHY689RSKcqmRwHuLVog9TXEikEgPhZiar0EVjUFWzMXKGPxBV3Id5cUnWwGA2ivTsIhmnlU=
X-Received: by 2002:a17:906:6a0a:b0:b4b:e419:9af9 with SMTP id
 a640c23a62f3a-b647314722dmr428460066b.23.1760712747066; Fri, 17 Oct 2025
 07:52:27 -0700 (PDT)
MIME-Version: 1.0
References: <20251016214736.84286-1-sj@kernel.org> <20251016214736.84286-2-sj@kernel.org>
In-Reply-To: <20251016214736.84286-2-sj@kernel.org>
From: Bijan Tabatabai <bijan311@gmail.com>
Date: Fri, 17 Oct 2025 09:52:16 -0500
X-Gm-Features: AS18NWA4XEij6yrkeDg-VPpESDp_j8R5n_TLSBbuEV9pdxP1CdAdhVV-XNND_i0
Message-ID: <CAMvvPS5gjn6J1dF1O+Hj3CmVcPTQG__zRwqqdBMoRNtptQeOyg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] mm/damon/core: add damon_target->obsolete for
 pin-point removal
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: 915ruqoo6fjr3umo4nbid863dgfksids
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F9C5A0007
X-HE-Tag: 1760712748-13197
X-HE-Meta: U2FsdGVkX183fM7qbZ3dyyTre+UO0qG5z4CAw/3G4M3xbojxFobE/7betmNZ6laUAlBNizA8fEuFMs0VqgfMw8RMqTsA/Y6F49W32qGX9DTFRUH843C10WpBibsolXpk7TgP39EAbWxNKdBrxuOky6dNE7aq2LWzwe43ESZ/f3sKSxK3HzHqyn6BjPAGKQ2nLBASi4+hE4jeRx30aEMHBupXVcllYy7ibB5auRQ67FU7LNdJKcjCZZnVO6Podq++UQvK3j73avfmxwh55BHbM4mQCbSH5GO7pETqKbDB97H5u9BDbL08kPnDpBlAATzOUogugqB8nUhm7P6hDMAPhyybregHO3vgb95qewKUCCLjhZTmq+U0xBvFt6BY2sLUVoGS6OM3sLgD0qO4086gDNVqntuA+l8+lvd3aatHDE8yT72XVGu4f4iaDhec/IGOUyiEYnxIL6nbM9y4L6DIl6HLL98j+fcjOShuGGlLt0QFWLi+Tbf/5usKHpOZJWnqmSUx5sV2JYQKYAMS3nvb/NdA00ZTu1pfaXzpXPVecKJ7+RshbIITzJ/hcNVbIXSRde7NUTnIenMb+2r3mSlLBHwutbWNS5fp6Su4zO773KJhbGTiV9lfpIUnQ9SELWudEkFuRGmkxuPi5b/BqhJVkM4ciDVw5zMUCOpfjS15AANJv9IaFCPJxuw3FDoB526mM2etrj6MzOxCPsBobYRlpmi4xszGqhweTn8avHzg+/9UighAHR4381UulR8F4XNSeSVnDg5R3tdlhjIF/s1QetnSMONkAtq1ttas4w0UxXzy/OrsUGvGjd781wNpwJa/i31hwSvW4Ia/Z4IN/bYvXZEiAkh3crZjA+IZ/hauhiMw2450+U+AzNs120xzc9XjghI6BuOm8uZn6bk/K3FikFdZzukk7lRpAc2OdVgi3GcU9yT/0d1z2tyE8rButPbeIHvG7WaShFOTSJTtQOU
 1/N6LrTq
 sXyJ9Pp0Qq7ZpLyP7j9BFt4PPtkB+h6OAnUjTLuZzGjC/TfzkIhCBkVEu8LotxRGdEOT+mOKH3dLLtNAm9i0oIHAVS6Pu2z19LGhCeHGga1jLvLrSRWA+bM6vyXjrdf49baZzH57KxrIILGJl5WlbJywbGl3h1IM194rRflj8KIrV33UN2ltokL52ImU+r9X/JFO7O2WMhXtAxQQjtkiX2pk0wj6a7kOoYW7BE5QNSU3Z1X6U94QohJNrMIEaUEPZCqAxrcjnV9V4qkccKgJaVmi8EzhBgl+w/UPknm7j8HoUrfuJ58v3PNBgOOw2nbwWrvuGWwxLY/2/9b1bBcPG9WIvg+0gtHoezqx8uJU+UK1WyjNrXjgSiUjzmAssFIzcDeIIQ38fb0ZW6pTOo1Y8p9mS2tiUXndlgbcJGs+7Np68yhZjS9AmVA2xJ9lTCbDgLEhd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for working on this SJ!

On Thu, Oct 16, 2025 at 4:47=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> DAMON's monitoring targets parameters update function,
> damon_commit_targets(), is not providing a way to remove a target in the
> middle of existing targets list.  Extend the API by adding a field to
> struct damon_target.  If the field of a damon_commit_targets() source
> target is set, it indicates the matcing target on the existing targets
> list is obsolete.  damon_commit_targets() understands that and remove
> those from the list, while respecting the index based matching for other
> non-obsolete targets.
>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h |  6 ++++++
>  mm/damon/core.c       | 10 +++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 524dea87cac7..8a7b45b9e40d 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -92,17 +92,23 @@ struct damon_region {
>   * @nr_regions:                Number of monitoring target regions of th=
is target.
>   * @regions_list:      Head of the monitoring target regions of this tar=
get.
>   * @list:              List head for siblings.
> + * @obsolete:          Whether the commit destination target is obsolete=
.
>   *
>   * Each monitoring context could have multiple targets.  For example, a =
context
>   * for virtual memory address spaces could have multiple target processe=
s.  The
>   * @pid should be set for appropriate &struct damon_operations including=
 the
>   * virtual address spaces monitoring operations.
> + *
> + * @obsolte is used only for damon_commit_targets() source targets, to s=
pecify
> + * the matching destination targets are obsolte.  Read damon_commit_targ=
ets()
> + * to see how it is handled.
>   */
Nit: Twice in the above comment you've written "obsolte" instead of "obsole=
te."

With that fixed
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
for the entire series.

Thanks,
Bijan

>  struct damon_target {
>         struct pid *pid;
>         unsigned int nr_regions;
>         struct list_head regions_list;
>         struct list_head list;
> +       bool obsolete;
>  };
>
>  /**
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 70e66562a1b3..3242a9573db0 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -492,6 +492,7 @@ struct damon_target *damon_new_target(void)
>         t->nr_regions =3D 0;
>         INIT_LIST_HEAD(&t->regions_list);
>         INIT_LIST_HEAD(&t->list);
> +       t->obsolete =3D false;
>
>         return t;
>  }
> @@ -1213,7 +1214,11 @@ static int damon_commit_targets(
>
>         damon_for_each_target_safe(dst_target, next, dst) {
>                 src_target =3D damon_nth_target(i++, src);
> -               if (src_target) {
> +               /*
> +                * If src target is obsolete, do not commit the parameter=
s to
> +                * the dst target, and further remove the dst target.
> +                */
> +               if (src_target && !src_target->obsolete) {
>                         err =3D damon_commit_target(
>                                         dst_target, damon_target_has_pid(=
dst),
>                                         src_target, damon_target_has_pid(=
src),
> @@ -1236,6 +1241,9 @@ static int damon_commit_targets(
>         damon_for_each_target_safe(src_target, next, src) {
>                 if (j++ < i)
>                         continue;
> +               /* target to remove has no matching dst */
> +               if (src_target->obsolete)
> +                       return -EINVAL;
>                 new_target =3D damon_new_target();
>                 if (!new_target)
>                         return -ENOMEM;
> --
> 2.47.3

