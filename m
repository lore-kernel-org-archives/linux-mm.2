Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C7E1FA3752
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 16:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0911B6B0088; Fri,  2 Jan 2026 11:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EFF6B0089; Fri,  2 Jan 2026 11:21:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83376B008A; Fri,  2 Jan 2026 11:21:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D67B46B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 11:21:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F3C01B89E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:21:31 +0000 (UTC)
X-FDA: 84287539182.28.0C48C3B
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 802161C0009
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:21:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cDYW+Bhy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767370889; a=rsa-sha256;
	cv=none;
	b=ZxUmu0B8cCsAa9Yx/TuqZvstmCiwnVQ0K3+wZQaVtA6FBfo/OcJ2kLKC3M14qdqv3JAIqT
	3gCuoL0NGvU+HUoL3/aJNLOrtdlnj55rFi3UPbZrxe7lp8oIkGDYwHV4KWzD2DrfCSIkhw
	qnjgRL047/hpxmDQz9HmQYVEFi+nVoU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cDYW+Bhy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767370889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeZaCTR83z0zU9PAa5SGiNPoY7YhOVNF5fZwh0fGq9E=;
	b=veTrLNBKYpTC7opBk+rI8AC+Tk2605NaCCbDYeZ4ojJr4bO2q0lwlekcep1SJ3cJTH+TZl
	xkuujCkwcAk4LQihnu0mGJcfVOtcHuIMMAqFUD7CxthRuuGUSBnBMM1E/+RxbVWM3hpdmL
	EjSbMM1L3mrjrlZJcFefDOatIoYlaCY=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9d01e473so17527018a12.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 08:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1767370888; x=1767975688; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FeZaCTR83z0zU9PAa5SGiNPoY7YhOVNF5fZwh0fGq9E=;
        b=cDYW+BhyBeO9dvbjwYQTGi1qd/TJL5nI2TMaLycQk7O1T1QQ04U5YqWjbLFU+sLvVU
         HyU27FL2XayZcXl3d6C5JdIhg2RbYwNK+w976mtGohYNeG5SU06Zqh3P3qh4OKvCwZ8f
         FhMI5olvlM3uj1g7qRxSh/FBWrTwoR6XfmYH/0Q+T/2Rq0649LIsCd89vu2McS031XUL
         zd26yL6AkjmdrBY8XfS6m1qBReKvTtTNMVTakDZVNW2GLcETDV1SiHaWoLPQoLYEBfBv
         qmPb1O2LpypZE6aAr63//oMVotdBPDwhe8oIf840HR2ScY3OJ67cL7pxaOxEoGian8fw
         eYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767370888; x=1767975688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FeZaCTR83z0zU9PAa5SGiNPoY7YhOVNF5fZwh0fGq9E=;
        b=WF15bFw8z3vERoc4Jl+hH4K4ekRlublTbHxXgtJ7LErQgQtx3G2tngi6Zmo895TffK
         mPGSEOYWPjUZnG0W0Ng5Vxn0Qxdl6p5HTUoP1A62YKDUHHxnpNqghGQcgCKCf2ymlg7e
         dXEupau/mzRrciP+pxfP66kRrpX8zocbQd6QRcO1x8cqHkcNEluLgUT4hsbGMlTPhLA2
         SL0yOypk2Edg89fKJaIJ+da9rXgO73SmLKVpbyar1Sx03xR7Xa+r4D4R1hgPLhCOm4+O
         w3JWkeAtxmZPqltyg5xULQx/KXU08bS6E3jsg3UOcAuP4UKg9Prfv34Q82QkpceBx+DT
         u6ag==
X-Forwarded-Encrypted: i=1; AJvYcCWqRSZkLqOl6HZMlafKmiqpxmsHWJPCFG3zKGrPzJ+JRbq49uK+pmbp1xcKYGOg/zQfKTp1r8eQhg==@kvack.org
X-Gm-Message-State: AOJu0Yy9Fc2SsnovVj01qg5bJd5wfQY3leLuBW16UwDEJIL9TgKw1QgP
	R8d2Cf/+yRUFcF++DOtACkraE0VM9BmtolX/ifr966GYhAy52qQqMgu7xjoUtydPrmIlLE0g90o
	q9lb/bgoxNflKuIrTNLKAClaTo85c63q4I5ciJ1hZtA==
X-Gm-Gg: AY/fxX69fs3ixAf04wnuHFe0BAbmVzCEfiMA1/49G8dmv17STlhtneO6MMIkOm8NzM6
	MNc/GjRow5VO6q+6ZG7+BAYiJ3YmU0GBOGvHTJIhud2WNzZcnF7vjzpzzUS7uCeGJWIFu8b6EFq
	UA3VOF0BoGp0EZVkDcr7o9HY/CmFeIi/3ngPkm3749tZN7r3BSLRNNF61eAjhAF5CnZ95vfYM4M
	JyoM5u8I1X2jJyptU1HW7Ec22WLp1zXbfi9kDYdqKKGlKL4oAY1fNzMME9NYuZIjCcdz+SM4Syb
	6Mf70ownLUNYvhJT0Gn86fAh9w==
X-Google-Smtp-Source: AGHT+IG7pmsPoAofQfznQM6e2Gh/kun3kkcPtsdi4WWJd7drsOJjX7U23lVDS62/R4Qi/xosq4n1IxN1VMCakePPrbw=
X-Received: by 2002:aa7:c243:0:b0:64b:60e4:f898 with SMTP id
 4fb4d7f45d1cf-64b8ea51482mr31916241a12.15.1767370887834; Fri, 02 Jan 2026
 08:21:27 -0800 (PST)
MIME-Version: 1.0
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org> <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
In-Reply-To: <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 2 Jan 2026 11:20:49 -0500
X-Gm-Features: AQt7F2oOU_yPnIxT4iWmDlamG3MPvPG4XuJIPEA1lsvAsNmoyAWk5nXnBh5YsIA
Message-ID: <CA+CK2bCnBD6afWcbdmqPFBmybeH8BKLo8YSbSCUEJEY+hOij4w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kexec: history: track kexec boot counter
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, usamaarif642@gmail.com, 
	rmikey@meta.com, clm@fb.com, riel@surriel.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 802161C0009
X-Stat-Signature: atax49pfwd3ggtnx7xmd3brzoy1gszcg
X-HE-Tag: 1767370889-619911
X-HE-Meta: U2FsdGVkX19n+AdXeHsRS1YZg+Aiw96pJlRiH7YJdXiUs55xtYE1aphiQ6aLhTq1YqJbKZ6X05lfJ+MByoyDnVvRgTM0/Ua/Effty4HRvRPIpf5+rjkb/FbKMAbKWeUt0lkqoWyUhzSbGL7UygOcfhJN0jZWJLhvVeGxXPGLNZoCPDndTAaoVsjX9UzMnf3uJD6R5slSbOfkcbLIEyKr4O1Z73KeSl8zOg0rYhzdC7PwSwKHxiuYHcmZGvYhiX3lr2uEw3HOGK26/6wxSfsZV+3b2b/AyotGSdzkanzLI71zkioLTuUS+WowDnJy4WY7AjPjYkAYwwgJWaBrRGT3i096LUkcxwpmf9WNfMJATddRrRdmnXxGEs97tzMzXjiBy7ghLmfFVZb/OSn/Pu8xFYrWZ2CjDfsPNwVt+WSxuFKqlpznA2VhO9cSCeab1zdsBxRi2MIrAOzAvS7tRlzbCG4JyS3nVP+057a/ak4mdW9Q18JUhOKxwNlVcGVl40CORY2owkWdOjBuovZIYtHgvQzCJO7HEUt4/ASvhtRC+F9yADpMfS2UjF1mgVw3WR0XDeqlF3Y7Cz10QYglZj7/ysnYmqDQ1XCyoyNnXQXnl2xJZeaJq9JTjEreeooN09yU1GHLdSn0GVqkLZq0Yna+gTjDGIDb30br0PHdUu9Uy4EwtPJkVu4nTzwQunizFxGMAQznu7b1BkjUGNSKAx7CyN2UJoqCdZFFTvR2oS3oTMKCyyFbvhZEQtl253FKu0K3q+IBLwKyIDG1JPPpinNFnzAqYgrDn/WGEgIfbOht+kx5MMHuGbmMlr5cMgBK//ypdJwdqrLcmPuIL2fITX2VME39+Hb26Mh3rcTNq3XQbK7b3sX9B8q8BNH0FvdUp0ZRLDLABI74KV5n9TsAyTjvZcc+HjzxCrKLk9aJ6ByxBcGy+OzecqvSIQKFylAreUwp2WfQmTijiRoF5Fbkssi
 PjiKaWxz
 fQrZfFPhEXg7DLa1FCJF6MVfOksJ8c5gco1g9Ax56NQbaEx7lqX4kIXd+n9cyurP8Wc+YOmgDbtJbx+NBOPiRiVPH+M9zDfNfRFqPTbWTJ3w9STp0p0XAEomUeyYQyaIEbvkP6kKakK5YpEuwtQVXqKjreIkFpDxlJXpwWY0CS7GtzqZb8GeHJf7CAHV5uuRRF53mhE7J6+i+s3XF/7xzYSYoXWuaZaa8YmtPCdvKmF5Yx7iuvGFn+xQ6O4riM6OyKUWACdbTUKO+Byqxsurxt/ZcYpxBbRPzr5Qo+xkv7zlkQRAxCG64f/lvbO8xMD0hl8lRK7iSyV8bf8NBN4kSXqVVlvrl2ksy/04iHI4HvkPRcmc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 2, 2026 at 9:53=E2=80=AFAM Breno Leitao <leitao@debian.org> wro=
te:
>
> Track and display the number of kexec boots since the last cold reboot
> when CONFIG_KEXEC_HISTORY is enabled.
>
> This extends the previous kernel release tracking feature by adding
> a counter that increments with each kexec boot. The counter provides
> visibility into the kexec chain depth, which is useful for understanding
> boot history in production environments.
>
> Add a new property, "kexec-count" in KHO FDT alongside the existing
> "previous-release" property. The counter is:
>
>  - Initialized to 0 when kho_in is instantiated.
>  - Incremented by 1 on each subsequent kexec.
>  - Printed alongside the previous kernel release version.
>
> The counter is stored as a 32-bit unsigned integer in FDT format and is
> only active when CONFIG_KEXEC_HISTORY is enabled.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 06d99627bb3c..fe5a2c5c4c86 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -38,6 +38,7 @@
>  #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
>  #define PROP_SUB_FDT "fdt"
>  #define PROP_PREVIOUS_RELEASE "previous-release"
> +#define PROP_KEXEC_COUNT "kexec-count"
>
>  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>
> @@ -1257,6 +1258,7 @@ struct kho_in {
>         phys_addr_t scratch_phys;
>  #ifdef CONFIG_KEXEC_HISTORY
>         char previous_release[__NEW_UTS_LEN + 1];
> +       u32 kexec_count;
>  #endif
>         struct kho_debugfs dbg;
>  };
> @@ -1330,6 +1332,9 @@ static __init int kho_out_fdt_setup(void)
>         void *root =3D kho_out.fdt;
>         u64 empty_mem_map =3D 0;
>         int err;
> +#ifdef CONFIG_KEXEC_HISTORY
> +       u32 kexec_count;
> +#endif
>
>         err =3D fdt_create(root, PAGE_SIZE);
>         err |=3D fdt_finish_reservemap(root);
> @@ -1340,6 +1345,10 @@ static __init int kho_out_fdt_setup(void)
>  #ifdef CONFIG_KEXEC_HISTORY
>         err |=3D fdt_property_string(root, PROP_PREVIOUS_RELEASE,
>                                    init_uts_ns.name.release);
> +       /* kho_in.kexec_count is set to 0 on cold boot */
> +       kexec_count =3D cpu_to_fdt32(kho_in.kexec_count + 1);

For KHO preserved data we use native endiness, so do not bother with
cpu_to_fdt32.

> +       err |=3D fdt_property(root, PROP_KEXEC_COUNT, &kexec_count,
> +                           sizeof(kexec_count));
>  #endif
>         err |=3D fdt_end_node(root);
>         err |=3D fdt_finish(root);
> @@ -1468,6 +1477,7 @@ void __init kho_memory_init(void)
>  static void __init kho_print_previous_kernel(const void *fdt)
>  {
>         const char *prev_release;
> +       const u32 *count_ptr;
>         int len;
>
>         prev_release =3D fdt_getprop(fdt, 0, PROP_PREVIOUS_RELEASE, &len)=
;
> @@ -1476,8 +1486,19 @@ static void __init kho_print_previous_kernel(const=
 void *fdt)
>
>         strscpy(kho_in.previous_release, prev_release,
>                 sizeof(kho_in.previous_release));
> -       pr_info("This kernel was kexec'ed from kernel release: %s\n",
> -               kho_in.previous_release);
> +
> +       /* Read the kexec count from the previous kernel */
> +       count_ptr =3D fdt_getprop(fdt, 0, PROP_KEXEC_COUNT, &len);
> +       if (WARN_ON_ONCE(!count_ptr || len <=3D 0))

This function is called only once anway.

> +               /*
> +                * PROP_KEXEC_COUNT should exist if PROP_PREVIOUS_RELEASE
> +                * exists.
> +                */
> +               return;
> +       kho_in.kexec_count =3D fdt32_to_cpu(*count_ptr);
> +
> +       pr_info("This kernel was kexec'ed from kernel release: %s (kexec =
count: %u)\n",
> +               kho_in.previous_release, kho_in.kexec_count);
>  }
>  #else
>  static void __init kho_print_previous_kernel(const void *fdt) { }
>
> --
> 2.47.3
>

