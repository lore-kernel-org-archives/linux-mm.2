Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BABCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 01:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF64D8E0007; Tue,  4 Nov 2025 20:13:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6E88E0002; Tue,  4 Nov 2025 20:13:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD498E0007; Tue,  4 Nov 2025 20:13:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A356D8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 20:13:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50FA84B9A3
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:13:38 +0000 (UTC)
X-FDA: 84074780916.05.48485A0
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A3631A0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 01:13:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7+OvMnd;
	spf=pass (imf19.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762305216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87sj/urHj778WRrZXS7UN3zWW0S51mEqs7jth+xOmiY=;
	b=LM6auSVQi4v6QCuxP3MEi+/jPkSrB5RF6OxvdahniiyJtOGGVJzWHIYAGRNEHm9o0C8Ngr
	Q6Ntmkudf8fCG6HV59FcH7e0jO1PjRhQhB53HyCAdk+MDVF2qjAbjFlm5Stf4SDv+01gaS
	bGyJkDpHTrDOhDf/1tY+GKLKLSEq7co=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762305216; a=rsa-sha256;
	cv=none;
	b=Uzs0nhC/f3wLkxRtb7lPoHZcszmd89zzBl0Cm39ENLlAM7wDD6XGneDldmUqonDjEF+fye
	mtQ3swl6byd0He+rbBBoAOSe0JtAwQZRzBo2cHjmhNV+95GP8rbBQcAYN8sS+s/UxgMniL
	HaID4FM4p9222YnwCjNPhssYjepBCS4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7+OvMnd;
	spf=pass (imf19.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ee64bc6b90so4708843f8f.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 17:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762305215; x=1762910015; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=87sj/urHj778WRrZXS7UN3zWW0S51mEqs7jth+xOmiY=;
        b=S7+OvMndpZq5/4m6uaWIvYGgA16Swuv02FuNvUbhjfN+AaMdVR3hKmrttzF0I+KGog
         1NSiWgvgQJAfp0iJKAg76hsUEWwW1zSRstSj9OTu5bb9yZ9P/yUqHWsTmOgTl3zfzAp/
         P0Htob+Ow7sCFINugEc97u168chXKHM+THGiHQEElHCrVP7KgF56SOWO8z/oJ1WhTGHn
         8da6Br4HCE3Y+4cVM78qqejeUl8lwyek+5DpPvWJChbx8y38LiyalexweUi9/RMGc8yj
         wSeE4qV/b2X12vj2KZUuJ45fP393CMAfMp5r/lQMYolP89yXLZJZMzIKPwiHfznbbPwF
         IFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762305215; x=1762910015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=87sj/urHj778WRrZXS7UN3zWW0S51mEqs7jth+xOmiY=;
        b=wX5MvZfwV+OD/mY6nMjbrpohtU8+zEezTqieaeD/lBYmN6CCadl8c+qLbH2wzNr5Sj
         20KkY/G+vuKECDhofEBnMUIzIXjjnXG2WGsIiGu5Yr9g2SGfxET8J0UJojqpTPUmdQ9P
         a1C/Qq2Dv9bvxYT4fYopXGnVA5/htx6pz11PVze6VN+6vJHjGDFfSL97RfZx7HTOcXSF
         PpZ4wht+YXQj/nxCuq141oKDnWHGgFchg6rK/XDIl+oOoWpCOufo1wbK58c6/25yD1fR
         8z2+J2ZMBlJzNAoS0fb1d0etdBIM+aCw351f1Z7pJTF9k9K9GltFLBFsL6d9u+7S5x2g
         7zNA==
X-Forwarded-Encrypted: i=1; AJvYcCXB3tNqRSQE5A7fVb8cFYoYst1bylYztd47TbLWslSIWbdZolZ3xbHWCcpRTyMdpA3E5ko9/DBrBQ==@kvack.org
X-Gm-Message-State: AOJu0YwoEg9YnisfxItitKFZkqVgo+PJ4QH/H9JRGF01B8T1OnxQIwJQ
	N4Zt+v6buMrpxJ1c5xUdH6zby8fgahVGpoTaYQ17p5RmYjD4JN8vggPFw/YB8toIW3p6Q4kv48P
	F7CEpInyHn5UroM6dPXRN+6J/XNLtdLI=
X-Gm-Gg: ASbGncsVcW1ynTgM61PPhNdsChDj7kA/rpssHaFpGLB3ibwV2LuY4SqnI3zGblRnYIK
	3l9Zp3dxsQwM1HlpLsIJe9Sq7uNWQaLOz3AIkIXHkAIWa65Ibo+L7iZKlbM4EcjC0p+JyC81dlN
	1KLwSfLXGUHQjT4ysD19sxXkHdn87aGkZ4pF3w8Ab4q4TBdS15KxkaoJTGsXz7+h29kL9m3QbXm
	yf35cdfs/1hC/GaGie2jny2jHIMhaZyzTa4mxjbWn+x0xaxvrNN8Ztmj6OcL97nG5WPb3yfh0bD
	pw6geSjuxdIVESefyw7WOyAFmpxBFw==
X-Google-Smtp-Source: AGHT+IEXctqZ43eVgXzLv0CJFnyc3Kfy26yvEcBKYGcg4QJgkHctqT2bEMWIDUrAUHBo0KkSYrEo3ePYt/M239opaW8=
X-Received: by 2002:a05:6000:210c:b0:429:b751:792b with SMTP id
 ffacd0b85a97d-429e33064femr697123f8f.32.1762305214961; Tue, 04 Nov 2025
 17:13:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1762267022.git.m.wieczorretman@pm.me> <cf8fe0ffcdbf54e06d9df26c8473b123c4065f02.1762267022.git.m.wieczorretman@pm.me>
In-Reply-To: <cf8fe0ffcdbf54e06d9df26c8473b123c4065f02.1762267022.git.m.wieczorretman@pm.me>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 5 Nov 2025 02:13:22 +0100
X-Gm-Features: AWmQ_bliHxtRFT6WIWfcnl1BDrwXrFHVP_La30Dhwz3XgybJKCGbopAvefwnxWk
Message-ID: <CA+fCnZdUMTQNq=hgn8KbNwv2+LsRqoZ_R0CK0uWnjB41nHzvyg@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] kasan: Unpoison vms[area] addresses with a common tag
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, stable@vger.kernel.org, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Baoquan He <bhe@redhat.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A3631A0005
X-Stat-Signature: fs84ii9ik7si57cxp8xyzjw7pneu857b
X-HE-Tag: 1762305216-548807
X-HE-Meta: U2FsdGVkX1+OCKC5PPuWsvL4QrV1Ex7koNxdjFsaebHZ/8tn+qOBCzoh0aOnqWNlm0J0685yGAW2apb0MThY8yUufy2L2ez3XAwVcaLVyqWDs7CFmljVExXsuxObyoc8rY/GzHppo/Fma3txVjEaLvDZiFar0mb9IPPj7Xlp4Ml6HxShyujgv9UsZvY5BzxZBpkdrCtvZTPZhal9iyqyrkIz5ImSTyhabI/4rkjvdyGfXSnDTrHeLEuwac3APq5qZ+S9WAoe/ho0vXcrWQoeo/pPkKQxSUWw6NmxQoWjKc3Fm0DaKG3TictRzyTPyIKWJ8fV0r7eS+PXaUFeNSiJGlOwBGcT1QMHfoSNEPCXzK2wjjd1aA0/0r/lncfZ4J9tmqcG06LN4FCmcjJ3BABL8UiimojoDz2MNIdK9h6LiGeLEnp9vHNcBoJkfeCWgi7Xc7oHTzdLTDOJOfpaABa5kYgR7bpuPnW7HKZ2wWVqEJGEWWpl/SPSNHWs6tTHP2YRxLqUZ8bCxX1Cb1GwCDnfgwxLpbOPqHY9kPT4TQ343gvA5Fcp+YoiRjQHJjVHFB3Ci627DHCPFg1KS91ImBwAxa3HH4HkO2FKQqJGin0SlezcX95bmvc2Mre3t3mO9ITWBp7e8VvqO/Xh1Q0hw/CKOB6uOZF4dR4ealyI/v4u3CYtJFRtZ9BmSbmYPx5WrPuvr4bEPtZwyeRQ23AnEYS5gCR8ouRPNSEiz/6Lw1wqh5VWMXsWA/fCxCq7cclDBOjTLkZYVhGo4BxM7C9+c2US7MGZ/9ZoSN3oqwO2q+UY3yEtn0iNqp1Wo8q62j8R3C//P5KHuT4vWLBj2YYHVadlTif/G0Ib0aYUdpu5Ag5n8UFBdKFTiESpjElizG18D6s6FtHVBsrFS4Or04YjYw9/BQAcGsdRlCytlshHMmf05/qguwlCAb6fYDHsnWoqBgdP3yw7TyCpYrGXQ+mL5BM
 5g51Z32y
 clhM2rDDjRyPSSDJkjvBncCv5gt5ecNiyU592p7z+yoR9GOfcbtUyQTMeTcIpY3nCUcQNx1EHr9mxB2tBgQBCJiDMlnbtPZ54b7qoxc0Kg0Zx6521uoA9rsmHxkh6SNkSXFsV3zw4cfFJ7iASBjiHaCdC+76V/rDA/IDdELAbTVO057OYXj1Gph1/mXHHFF+0OVy8IzwwvQJMT/whgAfsoVBZBsXYbBIFnldsWYu/q6Rj7vgROMwGYqsQ7gT/YkukOxQy8Q0t+fUbW8bjPPbMNcNmfSIiQin0TYAjAs7G4kCxloLvGtXp+cR4E7nfTsE93ZA3a+8GNm+EUe2BEOfzKQOYFe/pxDN9A6Y3XiaWNrfOHH4CoYpmJZAqEU+Tt9zcwGh0ZfnNFeG3kagAQWYwopEmeBqqMLGHVlYSbMam42Oe824/N1y6/w+eL1DUwDc2bfGo0CO1cqcXPGW+E8ZWTyWSyAXqtjAAzSmR11KHdCgOBXBAX6gUJHOfhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 3:49=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> A KASAN tag mismatch, possibly causing a kernel panic, can be observed
> on systems with a tag-based KASAN enabled and with multiple NUMA nodes.
> It was reported on arm64 and reproduced on x86. It can be explained in
> the following points:
>
>         1. There can be more than one virtual memory chunk.
>         2. Chunk's base address has a tag.
>         3. The base address points at the first chunk and thus inherits
>            the tag of the first chunk.
>         4. The subsequent chunks will be accessed with the tag from the
>            first chunk.
>         5. Thus, the subsequent chunks need to have their tag set to
>            match that of the first chunk.
>
> Unpoison all vm_structs after allocating them for the percpu allocator.
> Use the same tag to resolve the pcpu chunk address mismatch.
>
> Fixes: 1d96320f8d53 ("kasan, vmalloc: add vmalloc tagging for SW_TAGS")
> Cc: <stable@vger.kernel.org> # 6.1+
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Tested-by: Baoquan He <bhe@redhat.com>
> ---
> Changelog v1 (after splitting of from the KASAN series):
> - Rewrite the patch message to point at the user impact of the issue.
> - Move helper to common.c so it can be compiled in all KASAN modes.
>
>  mm/kasan/common.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index c63544a98c24..a6bbc68984cd 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -584,12 +584,20 @@ bool __kasan_check_byte(const void *address, unsign=
ed long ip)
>         return true;
>  }
>
> +/*
> + * A tag mismatch happens when calculating per-cpu chunk addresses, beca=
use
> + * they all inherit the tag from vms[0]->addr, even when nr_vms is bigge=
r
> + * than 1. This is a problem because all the vms[]->addr come from separ=
ate
> + * allocations and have different tags so while the calculated address i=
s
> + * correct the tag isn't.
> + */
>  void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
>  {
>         int area;
>
>         for (area =3D 0 ; area < nr_vms ; area++) {
>                 kasan_poison(vms[area]->addr, vms[area]->size,
> -                            arch_kasan_get_tag(vms[area]->addr), false);
> +                            arch_kasan_get_tag(vms[0]->addr), false);
> +               arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vm=
s[0]->addr));

set_tag() does not set the tag in place, its return value needs to be assig=
ned.

So if this patch fixes the issue, there's something off (is
vms[area]->addr never used for area !=3D 0)?

>         }
>  }

> --
> 2.51.0
>
>

