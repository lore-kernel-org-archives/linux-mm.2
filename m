Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44EDECD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 21:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3E56B0088; Wed, 17 Jun 2026 17:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154AA6B008A; Wed, 17 Jun 2026 17:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042F26B008C; Wed, 17 Jun 2026 17:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7DE06B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:06:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36A70140486
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:06:47 +0000 (UTC)
X-FDA: 84890638854.15.DCEA463
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31528120002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:06:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVXYCzrQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781730405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=np4Ad6HoqJslb4MIdJr2xIiKOz1hID1M1Fyl3DqqXZ0=;
	b=YKwS8oYHrIoev3S2rdgmDBVL9t+q+r5aSkwFKXx/V/B5Q1flKwuSi4T0y2dIJzpYcv59Re
	pnCGK/mfiZJJ2YAZswz1ulmnzBdpoJD8tOSGIIUWeUl7cDTsfXGH5zIkRq0VP75jCqdI8y
	vIbWVnYUPOGBSigZ62NInFnHOy/DSIY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IVXYCzrQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781730405;
	b=NpUnefxjUELZLYkknIwZ2wAb2G9q4aT+V0GJqZMtzJyWOBFkRxecrQaIVJFLIOqJCdzHd6
	vzl/f6MefLzMI/mds8Qkk1rTVjvELL55UYZFk2NPRySnSGj/XUABkwBnYKZJ9gTV7nv6bE
	0kb/wnglQYzjCBd9dFmqoY4+MDdv4Ag=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so100178a91.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:06:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781730404; cv=none;
        d=google.com; s=arc-20240605;
        b=Kzp6/OqAefyk4ttUVrxY8o+KGJmWi3HbsqmjfDlSK9uXun47+leLjZ6TWikQC3oKv9
         APjquomXf22Rtb5Hds7Sx14FXEGdmEF7qhkXWeF2W/QcIPckrEF5gsjXFJ1j8OBkqgh3
         608LnGN3QWLsXjuBdnOl2ln8eZIDURh2yMFelA+Cvd08xARKFIt4cbXn/F5z58i8UZXt
         rhuQhAx+n/AtI+zdfpaqBgRafBpoyjfZzS3eoISUfFzc9eGa6NikLpKv9vgkm+TZfa58
         Lc32isJQEIS24mzgigfsQG9CgxsiQm76kA+m23JsHdIM08fXzSs1C/KOeu9vNV5ikH+B
         mUxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=np4Ad6HoqJslb4MIdJr2xIiKOz1hID1M1Fyl3DqqXZ0=;
        fh=Ib+G9wnVWL/tUtaoq/+Jw8lZ7Jr3ps8xM70g+rlvcP0=;
        b=Q9TUGUfWI6Sp99xOhTcSrxzYTJht9/6hW18ZDNlnf+R+xKJN+mY/smopG78foyLN1q
         oyA5ttRu6mnLUNsfq5XU44nn5YnP4VNwIh5+KkjvQ9LWQ6lDfptUzOaXY6Rv5s3gbdJR
         pCD7KUlwzhRLuP6fqnqexlknfwUxwqajTk9VCbN68RBA823H8zoyFt6zQZXEKCmJ3LOa
         KDQR8LVQbF1P2lDFxPf265ruNzg2V1TcSKILfIoT4MdTfZSvQrOnVv6u+MkWqz1Xo3QA
         9MgcPfIQ/HvFgkXfjgp0jXRAMrqXbG8dFa7B5q5Dp/oieolW1C28IT4w1H14GW3Sw3TW
         JD7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781730404; x=1782335204; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=np4Ad6HoqJslb4MIdJr2xIiKOz1hID1M1Fyl3DqqXZ0=;
        b=IVXYCzrQFqO7KJGdaZoOIM5lSxBl/JO3XJCmr1rqwKZb7mFLYeEquDM9CgYugpbNbJ
         uOZCBCHZnzxLROPDx2BaqLQqbBtd945oK0AjI7Z6IaXXZopBPee8EuzVpSan6YlZw4oD
         kKo4+P6ZdPwvZqYNqtxJMZM6gNA0yblFBuubzyoxJKRb5r36BJfleDiLKKOo74cbyDYA
         7QP0Dij/WAXPHQS73UX4BYNIIDlWGT1U3llr6bFLeUn9+jRqUZ5TOki56QkQnW0NnpEF
         JVF7Ff0yPnXvjTzDVmVOiSf0rK/tG48JIz1Rd9cBorjpw/+mTJ1AbShgCHwntmvCRGOd
         Q9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781730404; x=1782335204;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=np4Ad6HoqJslb4MIdJr2xIiKOz1hID1M1Fyl3DqqXZ0=;
        b=bbdigchb3L55ZuH/O+IByttpmlgdxwOHpgzMp+0ouYyntEVWJYKcdDgEGbuXD4eeJz
         Z3yJ9wh4Wk5Uv4JsYdfDokZoscGVxLDrKdx1ufM3ucFWaxW6rfT2HLJmsQ1NuYX0gHig
         TrnGCOF8qzlZAcxvGzBTznwMw/g0LoYH+aqf9FJiNH4klo5C9VlgdKYi+sYM+nF8bvVz
         k1AUh0LRNCZWUTmT308wRFxXUqA+zpWENln7wVpOj4Bx3J+oMRiQ7oEiexkyWe2QRv+E
         wBtfkjZdfps6nf8rcqA2CvtDDi36s1CS8U0eVfR79+QmcLECnI1aNfkriTn4Ob96IBhj
         UhvA==
X-Forwarded-Encrypted: i=1; AFNElJ9rfH4iMiMgiKKdExIYzwzSRkuQSZMm0h//ykBbhGzInwhTn2Co1OGdYtTK1hFpXkykDDvfHcnuQg==@kvack.org
X-Gm-Message-State: AOJu0YwJH3HRLGbCGwoAZJil/4KBf/D00fPsCJ0jVJXvkO0Wv559Qauc
	qBCMRSf2PBsjuU9VqRHK9ZkjpuVxT0Z6V+XDYV815l67tHSlA/qnPyiCiTqzNkW8V57J3FEbcq3
	c7xSPwTbFJCFpW41e6XfnYa6c01328DA=
X-Gm-Gg: AfdE7cn4EAlOzgrTOXa+eEFjxzws2IgIrulM0ZVd7Px9FsPiyZwwfEP4Hm3PTM5CFxg
	AUm9D75Vck5lHTpWfH2WOLAiDzcBsSQdq5eyhbZ8KmbrS7thPaS55XF0Hu3QQpcXLvkQQQIyH3B
	FODtuZR5CFxE0UGhAcWVk2LlcfrCaP77iHn13OuHn+Y5nE0DhEInZcGFpE91yc9Fo2H6RVh1t7K
	Btk4s9QVMt3RUuKuKoX+EqUr+gETlTYeQOGHPsBar+i20hBbWWBFuAat2L1BiR4Q76I40z035xJ
	hrSiNNx7QK1D3rXzGnckngqK/MULqp2AVEzCwp0GoBXOtU+t4PzYESoY9RpoDV0rOlNhg1QFWI6
	RldcZecgsPle362x2YN0/PeFF
X-Received: by 2002:a17:90b:164e:b0:37c:6505:e7c3 with SMTP id
 98e67ed59e1d1-37c9ecff3aemr5523695a91.22.1781730403938; Wed, 17 Jun 2026
 14:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260617202147.78347-1-jp.kobryn@linux.dev>
In-Reply-To: <20260617202147.78347-1-jp.kobryn@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 17 Jun 2026 14:06:31 -0700
X-Gm-Features: AVVi8Cd260eIQwhzGPEZLA2uVsQtbeQyANVfuu2LDFQ8_RZ7E4bOAvVo27OLPZo
Message-ID: <CAADnVQJ=q7hJkt=ekLD_a5KjJ_+icdwgsY61rujjLMKAKByvWw@mail.gmail.com>
Subject: Re: [PATCH] mm/bpf_memcontrol: mark BPF memcg kfuncs static
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 31528120002
X-Rspam-User: 
X-Stat-Signature: zjbbrdee61fqfejoi61jmc71hq5zaddb
X-Rspamd-Server: rspam09
X-HE-Tag: 1781730404-797817
X-HE-Meta: U2FsdGVkX1+lsKL/bjtLAkVh63bKMs0bwsAvVU0lb7hd0WsqDakm1x4FDZkGwQFNxbWnmkKeMYiuE8tLnDPIU05KHuq+XG2EOTsduZtZ78jbnuERWKC2aEGBc+uTJ04fVMBekuHSgtvlVQ+uOYnd3+8DasaBfcRmuSI2QsJeuFd4SrxwUFKBwQuUSMrUwdkOCUeX1wUUACdGw+QcAC7s8YMWmqhMQF/sdhh05xBViyARgnBx8dMdViXy0JuC/A7uL1roDFKRslGDHV2nhcKDDq/FcsndkX8meGUwS0XKATJf7VVDwy7WEfMhuSzIlAsnpifd+LM7j3Tfbp+XE3Iq/D87iyIW7LvtL2PIapZ+a0/MvKdtqf38glAU15ymnOJ1m8c82RrDtVFIqzqwoparnlMuKdTMZ+txX+dociUHUcByHxuLhEi6IPN30r3K6w4XaJy80EYQm/VFH7R8IHsIaQMsWm0lAHBeb4wjsTHQqjbejjgRZEfIKrI4ABKAG7TfU7LPShTfmFGXAIF79iloDtNW/OtyEeGBRBJGMBuqmHKE4XsU7IowPzHWBCxl+V9R8rTA4F2FTahXFjDNXAK3n70ctb/waaLpxGZpD7VTOODoDPtiESDZj80nS9XSNAHbwJFitn6eprIx8NyFBqaBxDCxS2paEr3FNjWy+o/gnJAD3g6O7Z9tRoHKfEHkiDD7eHGsSYwbiBBJTrbgqf3cg3+QOP8QX4XWr7oxhKczVz38O19kY2T7jJUPzzE9bJRhTINROxUw8pm0gOg1PaE+dlVeCwZATO7YuIae9iQwyV35UIT5G46MkTXB6BdM5QUdYaji9dwPyqeDP8oJ0Gq4uqBWv+pPv73D/ntcvI7WIRv1T0h/0V3tIx9xVD2mg8b7zNO5VTpavLMmPIRXiSZNoMj+9SdRSSOnhQ3+fkzZ57ErOwNRyVrPKgguezxGFUdvWyoPtXPPlEzoghLkCYl
 EZ7wECP3
 EM+jeP1q+ohMXTfGGEIsBD4C0ByoCp02fTvUf0nl9kadZpxm4/q9gmCetxYkeV8IgtdKWQ8SENnMsbcIAMOI3bOHIycyePg0sQ28NKavfW68POHarTdcbKEWBFxKUJY34oJZaw9VtXoiNcKXjgUojY1BSc13QZV/5ccdQ28bUQukqeQ4Bh+3O5vr4XHUF3rkaRhwlypooBQOZx+4xAHmvTr3GBp8iJjWKR0vDgLU9I4ITQVI+xmg2+Vfq1b1yVVxylzqLTCeNTQjtx5o5UXBXSbfDV28sz4ZFs2HiAXUoZ8aneKUCM5hgEAv1RsDpFizUVHB6r2IXF5LpXhbVfeHztD9u29ItvRGUPJ3HfvwnrueOh2ZXx8ZcYPdG6dVUpPsbXyFnNoXmO4+XIMlmnEXnFn7LjS/ySCgwoVAhBu2b8hx9DsBGx+RnVv70R3ZYpUwHfIz5MQVrrL84tQ0yxis+nxkPnOYTvxlnlH1xTPgeYEYesWWTeY9zoUlZcwsZHKraAYJPNlpIqdg+oswUjS7c7cFqNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 1:22=E2=80=AFPM JP Kobryn <jp.kobryn@linux.dev> wro=
te:
>
> The kfuncs in bpf_memcontrol.c are not called by in-kernel C code. They a=
re
> only referenced by BPF programs and resolved through BTF.
>
> Since no external linkage is needed, mark these functions static.
>
> Fixes: 5904db9891f8 ("mm: introduce BPF kfuncs to deal with memcg pointer=
s")
> Fixes: 5c7db3239c9f ("mm: introduce bpf_get_root_mem_cgroup() BPF kfunc")
> Fixes: 99430ab8b804 ("mm: introduce BPF kfuncs to access memcg statistics=
 and events")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202606150332.Xy4Egd9s-lkp@i=
ntel.com/
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> ---
>  mm/bpf_memcontrol.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..eff79bb2c758 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -20,7 +20,7 @@ __bpf_kfunc_start_defs();
>   *
>   * Return: A pointer to the root memory cgroup.
>   */
> -__bpf_kfunc struct mem_cgroup *bpf_get_root_mem_cgroup(void)
> +__bpf_kfunc static struct mem_cgroup *bpf_get_root_mem_cgroup(void)

sashiko disappoints. It couldn't notice that kfuncs should not be static.
We have few "__bpf_kfunc static" in net/ipv4/
that work by sort-of "luck", since their addresses are taken.

In general kfuncs cannot be declared static.

pw-bot: cr

