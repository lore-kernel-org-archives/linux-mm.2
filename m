Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB52BEB270B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 19:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C8F6B0005; Tue, 10 Feb 2026 14:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E7D6B0089; Tue, 10 Feb 2026 14:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFFF6B008A; Tue, 10 Feb 2026 14:59:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB0476B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:59:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D5F3C2666
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:59:24 +0000 (UTC)
X-FDA: 84429611448.29.FFA5515
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 53566180010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:59:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b=AMtRj761;
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com;
	spf=pass (imf24.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770753562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nzw5m+4TgH1BqV3b1iIXSxKPoOg4yWtxz+G3n6SK2Gc=;
	b=307vZsXTuZWVoXXuzI9T7gjmhRKEsghh6WRHmZ8Rb7R9OElMXiJI8KNDOT/54XR+OfLvDO
	DtkEYP0pTfJqDIaKvx2O+xlIEsgnC498fvaBEr3NAkSn3UJ7xVSbeNkeIOtt8fUNEPjM9Q
	MyNsUz3zhS62igIwY3QhFp7SQ/4zvSQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770753562; a=rsa-sha256;
	cv=pass;
	b=PjfQBg1qfNdsNMmuQlMVCfM8QZzUhx9j4OeTEYzNQlMprxoXKYElqoejHXvtzU1rBERsU9
	F8G2cZo+5WVQGkZ5zWye1gVNsgyv8erTtT4TyzXnx23RWW8g9UiaMFWE8TCfGUslhkvJKx
	4PFY/YOKOLp0VbdM7d3DbwaWvc8K1MM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=mihalicyn.com header.s=mihalicyn header.b=AMtRj761;
	dmarc=pass (policy=quarantine) header.from=mihalicyn.com;
	spf=pass (imf24.hostedemail.com: domain of alexander@mihalicyn.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=alexander@mihalicyn.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-387032e855eso158101fa.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:59:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770753560; cv=none;
        d=google.com; s=arc-20240605;
        b=SS1LAdy6UrI/JKESp3pOIlpsQmGv8xOrkvqF9GEkYiT7+6U282AdYTB37gtOaaFdiH
         eROlpm8i2kKHB+aLobxHSmYBjjA/CZZYd+DMNYGmQqzoI1QqT/1bZMgjUrkGs7J6CqEG
         lcvCFYR5/kHO3H7c69x/58Zba/a+7zVBwy8t5dFKX2zB15N0yTTeTmPZq/H/DeHS/213
         q6KdppguljxQ14B1IbArd+F8etGY2e9PHUBBSeby2CDdjWCGi7ev3cWi7h421qqWMHWh
         CAbmMucJRFyC2hoFuYLcMzs7uegAup7AulaEASM8Eb/A0FHsBCo0BRPCF9ewW2oQ7z7W
         JGyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Nzw5m+4TgH1BqV3b1iIXSxKPoOg4yWtxz+G3n6SK2Gc=;
        fh=AFx0yhSu/YL2XoMWSmx8AVq5SmWUpudwgt2UhjPM5l0=;
        b=XWvkbbdQQ5ukeyg+irynPTEopVRYYKIAziVz1AHG2BCsWoBakYPGaTiOMEqW4AC9MB
         Qnx4F7iyOv+uQJVWCHMUY6FmzC45VMW00WGsV+oEcI8V94dHXJhoGs0ENMXu8+1lUqjb
         8LJN60PoBrBpQrVwSqZHjRIIqsxvlcffR51ZBJJtlzQckSwt2SmS50Pdskh+QiGALY+r
         NolUVAk6buk4GAGOz/PcY0E2MqAoWRUAYVOInPj0KPp45YB9o2BCamcY7U2LWEx8Kyn8
         jyMGAggiQKsAhmIkkaWwUHgD6/Jq9R0TMqakm4IzDQLnLUgiXlOIawC4NfwilJHFqiJc
         qu1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn; t=1770753560; x=1771358360; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nzw5m+4TgH1BqV3b1iIXSxKPoOg4yWtxz+G3n6SK2Gc=;
        b=AMtRj761ucMxn5gK8od07tkzg6RxauDJJ3AzJ6kSpE53T4m/rEl1cYZ6poxV3NfN3A
         z+vzHrSn10+w0IYo++SwbM4CejbU2ykVqpXe1gSpTLHlMnnlYNUqzEUiSWKbwu575r93
         25RZ3LIVIJp36NNGJly4/F0nRBgOI5ta8Xz3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770753560; x=1771358360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Nzw5m+4TgH1BqV3b1iIXSxKPoOg4yWtxz+G3n6SK2Gc=;
        b=pJ7ZyMDC33GP6tUeWg0j/MEcEMx0KtEdR/su0WhIeUKnm9q9Q68IGOJMU5XOGRA7HV
         RgOAGk56CbXs8kfaX33buWC+v17UI3xha/0ydRDcXjkufUgpccvm5GL4G++J+z1AlMoK
         nE0qC6xZS1Fxkn3E1xOAKlKS6kQ7B4qr1waxaRRDRFyUmEPpV9bZfsCDpOzWW/9YjuBF
         PYZa965fEDPzMO2ChEHDaDYGCTTGZUKHNI/RmDY826w8bbUjIUrRnyvKJEf02qIpUeRZ
         1kljkhRr/rHsQlu8TDfTiwjHpBu4VTfInGnOXbtoOxW2KlQjhF6+Olau+s1H1UWRH7XP
         nP8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWu/ZmHJk7qOJcyruCn9o4Mz5IvByoXegBdqjj5uLs26TpuWN8eS0TX39rf1JT62UrSZ2yk7NydZQ==@kvack.org
X-Gm-Message-State: AOJu0YwekYrvuL3vAwSbUHSM8TWNfuVmhX8cfvVpTeqi7wcyyE/KJXkc
	r3xkH8rx5gRqDy8QoGvbXmiOeMPlGUWQ+zDpBNQ/LS8zYWYR8za1H3ZTk3v5RQsqgK3D2oVfaMQ
	0BQ8O0+IUr2bEOfhkymQN4HgqJDpd3sww04qyPsNdqg==
X-Gm-Gg: AZuq6aLyWWX2zlKuzGvjLygIGacSrU9QnOBbBMmwjiQK/LVq3iA098atS1P+1kfhOyk
	WZhNKVIbDAv5VfNpFscGXGErUIKe+cS/b6k2kDRmFGa5jIn41h/TALitpVxIuwTziBYq0Z0tZ0g
	Kv5d8f9Z47rPaPYmluHn+ElqiDUPLZ295rL6kxPG9rV/e31ba3VY3KT2rjV+8rZQdA0hmuz6Xt2
	4+7DqRfm4Mg4iacSQ+fC5DjlvstkSuiLyF7glAMtKnqyJC2U67smcNhucNB4PzvxRwyNCrJriCp
	gTEQ1K51p5BS56VwGH1s3gFRgNyeEYJP5NnSpZA=
X-Received: by 2002:a05:6512:2c85:b0:59e:38cb:2e2d with SMTP id
 2adb3069b0e04-59e5c2db507mr140749e87.30.1770753559975; Tue, 10 Feb 2026
 11:59:19 -0800 (PST)
MIME-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com> <20260209190605.1564597-2-avagin@google.com>
In-Reply-To: <20260209190605.1564597-2-avagin@google.com>
From: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date: Tue, 10 Feb 2026 20:59:07 +0100
X-Gm-Features: AZwV_QiUHp5Yt5UEwEQebOt4h2-FRofwh-qxLXTSMIijW9tK4Y_5N6CUeGnnSQU
Message-ID: <CAJqdLrpjW2TLKkhbQ-pG4tP=TFiJDcLGtGDrBqcxJnD+e1dZ9w@mail.gmail.com>
Subject: Re: [PATCH 1/4] binfmt_elf_fdpic: fix AUXV size calculation for
 ELF_HWCAP3 and ELF_HWCAP4
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Mark Brown <broonie@kernel.org>, Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 53566180010
X-Stat-Signature: oszbq6tb1mqn3574tib6t3qniqnrww46
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770753562-466301
X-HE-Meta: U2FsdGVkX195Djb1cjIzLYfad4aOwtr+IWExAK2rkMoWjbiqahweIbaBTgR9NePCuiw7wbTyugVHSC5YirZftOwqN8pOZP2HB9P3kc1SkvljcCfNCeWZ0XRgAoL5Kz96sOjHvdtfqaOLTf5JG9YdfyV30twJRkT6i4Wy3KVTfxaMxvu8Z/mcyVGqQOGvZiijmo9VKBKRxYBh8ubrsB6W9Q0z/SyzEwXNsPc/hFiF8NXk1ND/0B0XnF2rlbbiFoZ1pVX0ky+Nnsh5VMzocKrbEJ9LhNJttmUhSD061N7eeG8AMolUtNBrf78A8vnDebjqd27AzsZACMeQ5QyH5oYZT1DgBQmdNA4KLY+y+u46p1B14QE19Dufs7tqpNoWUSNZK1/d/YLhHQspZSkwwHU5NS82mJ3wIg1j47WJiH21oSd+zW7qWF+hVhT3uPD7GtA6rtloRcOSbL2rqdAUT6b1vG4Z1v6cwT8/9RkXsZJLYNwAJhukZjB4bxrvrFGRxPkpeV1LWkh/icD2b2zhQz6CtEC1RKmwhZFn08C/5+3Jv+++sLuuQcxLHfZHQx5Y7OjKD6tNb2UFeZ736zP66RiX/E3wc5vPhv9NYYdOciL+IWeVRjOfMypPpvELbsNUj8/8q1h5bT7SNUNZM8vqceVdmiOGRSjZKgmKNBC2KMKvLx/XOauZvE+yiRuMKAHozpFHT/l4qimPlCSt2J9XoJMVUJ93LT9/l9SGV03YCo2tdI3SiclayXcBj9+Gk5EvYhOtXmhkHXm1nI5pgZ1dq4QzbMnzWSI7y2nC34uTjATCyDwPywNuTUEr+ddGhB81wZHhPJvFdVlx5lTaB45RXRcJvc2dy04UCvvSeRic5aT0EdH6g6h+S7Tgs47Y7RYzf1Htl/t0cKchDbk5aUGSgzY+ft7950A1QoZXo+MP1aAOKiUryRMnMsRsr5Ij2BzfAjHdqeZwDQtQtPUb9KKyrr7
 UzbcZ89H
 GeuW7DHz8a9ko7jijQvcOeStg0yQN3MlvoG/8WqYnHnU3prVuSdzDVFoVx9tO2jhMjqKO6ubu9buFDLRta3/tDmo7mgzGcLi5t1Yb64ie3euwllMW/sgxn3spZGjuGttcjShyprPeBScXrrS6aLslfvMHtnIqNlRyR3sDOirj2Zn8wSPeP1kd+Nllbyh3QX0N+9c320RFxx5f7LtaNEdoaWOmFzVcFXaa6wkmcPgAL17QM7wZq7aBxp4SzbeSuqVdtY/itkgWmqmWOHNzcl3emWUUQOhplpnDNWdVp6X3vteqTMkBgXPA7w5rWZcJAXQJH8dGqL7XM8W49wO4mPWjwUAutSJzzyG+tYz0ur8gtevJmKr09EEO7DvnX3pXYxpXkp7+NmH8U3QIoKKrzrWpwyjmrb8iACrGJsqwkjAISP3ilwyVC8ULcvt40ByZHkYrGP5OA9/0uNHyaPIclUK57WX7ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Am Mo., 9. Feb. 2026 um 20:06 Uhr schrieb Andrei Vagin <avagin@google.com>:
>
> Commit 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4") added
> support for AT_HWCAP3 and AT_HWCAP4, but it missed updating the AUX
> vector size calculation in create_elf_fdpic_tables() and
> AT_VECTOR_SIZE_BASE in include/linux/auxvec.h.
>
> Similar to the fix for AT_HWCAP2 in commit c6a09e342f8e ("binfmt_elf_fdpi=
c:
> fix AUXV size calculation when ELF_HWCAP2 is defined"), this omission
> leads to a mismatch between the reserved space and the actual number of
> AUX entries, eventually triggering a kernel BUG_ON(csp !=3D sp).
>
> Fix this by incrementing nitems when ELF_HWCAP3 or ELF_HWCAP4 are
> defined and updating AT_VECTOR_SIZE_BASE.
>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>

> Fixes: 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4")
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/binfmt_elf_fdpic.c  | 6 ++++++
>  include/linux/auxvec.h | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index 48fd2de3bca0..a3d4e6973b29 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -595,6 +595,12 @@ static int create_elf_fdpic_tables(struct linux_binp=
rm *bprm,
>  #ifdef ELF_HWCAP2
>         nitems++;
>  #endif
> +#ifdef ELF_HWCAP3
> +       nitems++;
> +#endif
> +#ifdef ELF_HWCAP4
> +       nitems++;
> +#endif
>
>         csp =3D sp;
>         sp -=3D nitems * 2 * sizeof(unsigned long);
> diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
> index 407f7005e6d6..8bcb9b726262 100644
> --- a/include/linux/auxvec.h
> +++ b/include/linux/auxvec.h
> @@ -4,6 +4,6 @@
>
>  #include <uapi/linux/auxvec.h>
>
> -#define AT_VECTOR_SIZE_BASE 22 /* NEW_AUX_ENT entries in auxiliary table=
 */
> +#define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table=
 */
>    /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTE=
LF} */
>  #endif /* _LINUX_AUXVEC_H */
> --
> 2.53.0.239.g8d8fc8a987-goog
>

