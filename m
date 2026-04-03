Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A31F0D730AC
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 06:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48736B0005; Fri,  3 Apr 2026 02:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAD36B0089; Fri,  3 Apr 2026 02:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9EF6B008A; Fri,  3 Apr 2026 02:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 897186B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:56:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24F7614033F
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:56:53 +0000 (UTC)
X-FDA: 84616337106.11.0CDC78E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 46CA51C0009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:56:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmBByyGj;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775199411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQWZ2un6zfAy4D7nIqTfdH6WVphAsSTyBmaCAbtWt/4=;
	b=CUJ3ALbJWKE8sdW6k5NoCWP9W5IrxwOmSw7BSkoxZRbIVRUd2bWfFXWf+mZY6j/j2QDexc
	7/yJHcE2frKE7g6z7yURMAaulSyp04NTVVCKmTDcb+O5kGXkY0IvO13wiCjLHYia4PclsQ
	TEGpl6tF/UX0HAF4To9ylU+/VYalGW0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dmBByyGj;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775199411; a=rsa-sha256;
	cv=none;
	b=trEjuS5P53Umae5epD3xlWb76m5eeW+KoYrBMXCtXVJbCNC+zSb85M7S3H381J890ydH/p
	TKyy0vKR7lzJfcVfREdUdzJC6yU2UxPK5zxf6ANjtrRucCil7Y/dUC0kSDckLTxB/FjYwA
	yHaE5S8NjxUSseetX+Cs8+horIvhjUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD57360123
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5831EC2BCB1
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775199410;
	bh=xXBoK+/mqI2NA4x77B69ou1njhSdjwKabCVayeemK70=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dmBByyGjD8PxpUqTAQEuj/XktSauo5vIYdb3h4EDsSorGqF+JpU70/29pJQvT2Z9w
	 5LxXqAF4oeHqZhHoWcXWPHvDjxxzauA+VmwPJSyKQqgC6625NJzCMlv6YagD5p6ZmD
	 MV2vlIcH9Z8fltYbA/ftFRIMxaN+lEhrcmzqflp3WORRaohJfyP+qiGTbtJtz5iuE3
	 m48/w8PfgS5JL/aPoQ0QWRUbnPUH7O/XJIInea2aPDSVZ43FDkt7rrKUazwRIcxgGZ
	 UxoW5RxUnh7eiOSvpVLHOFJ9irHvdmlz6amgxu7HW6VsWWBKRL79vc+E8OUbuNVSLL
	 +VjfeleLRyhVQ==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-506bcb23a78so14272091cf.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 23:56:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV+EyjRG+rGvMNhZDplCvGEXyYnJSJ5X0aNPc8XIJI5/Rvj22tLqDn9nmXrwWs0aHVGLrP+YUii3g==@kvack.org
X-Gm-Message-State: AOJu0YzxRaSH1S6x82FUA4rebD3YlokvdFFKyN5woIwpXPnNvTJDEHk1
	eynfWNk98NuUYhBN+jkj8Hgwdx4HNU8HQxaigWDjDAXYimRQ4u3ywO3ro4q+78hYlw0V+EddgzA
	Q2LBDXr9L5HwV3KK/n1ojqwrcZ84/DmY=
X-Received: by 2002:ac8:58d3:0:b0:509:1579:7c3b with SMTP id
 d75a77b69052e-50d62aff00emr28898791cf.51.1775199409601; Thu, 02 Apr 2026
 23:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org> <20260320-thp_defrag-v1-2-6ab15d0d26eb@debian.org>
In-Reply-To: <20260320-thp_defrag-v1-2-6ab15d0d26eb@debian.org>
From: Barry Song <baohua@kernel.org>
Date: Fri, 3 Apr 2026 14:56:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y2+R-LRXi7SomEtXWoN7JVH3jhHFmAx5G_8TH3Q5D55w@mail.gmail.com>
X-Gm-Features: AQROBzCTheckhOlUiyxVuDlHWa3vlGFe_03nR_cYgptMJLpy2PS_dbfFDnGDVRI
Message-ID: <CAGsJ_4y2+R-LRXi7SomEtXWoN7JVH3jhHFmAx5G_8TH3Q5D55w@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: huge_memory: refactor defrag_show() to use defrag_flags[]
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 46CA51C0009
X-Stat-Signature: w1bxoceeopxzzcfs6ar3c1op7qkstrhr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775199411-931808
X-HE-Meta: U2FsdGVkX1+T9rDYi0Cvms2vfsYDZbTYB0/NOyV7hMm7FjM/6pLNQwCG5EieLPDy2RSbFONn/Oo6iEZN0xWtN4r7UAE7CxwI6l7Eh2hxfDJ/qKjZDKGefT7YAIzaD2rXe9cmGz95HVP0cQWXKavRzSxmHzUolsHmfEkFkfz3vwoTarFoTSLmO80Ba3poi9UbODGqj4vDHNxR+/P5vSI3+KY4MKjLeWik8YKqrJh/doxwxvzJIlFCJT9iMjhThO2KNoBbV0R25c0fkDAipE189tWhSGpiGmKNLIO/6swjSJZldlC1zw1desRSb/3kuAV+hUjPpLIsBOQrgPsmKBkfIk6ZRcie+h4Bs16Da9Q0q/hnS9uDAvgMxHjnF4mxx4FgoqJ2d4Yiz0NWHXMaVTJP0wjoheWZFXxxWU+dXG/vc3La+8yxziSQQokr1KWetsgUZHyrIyiUUC/tYHPB+N/SQW6DTEjP+v7DLUkB92VRGgDHesGZSFONwT7MeUCCWdRdhMEpzJf6wo0pRGEeh7s1ZZMJIeRS6QVKupnfNDMcsOnynv/Mcx5FdusYIRhqShd63cjFAfdqsE85c1kUI5RSy7pR10ZkWes9QNbBEWmz3dQWvuMd2/6WnQN7ymd/QKidlv2QNh1mVzTlSulRWR0P08GnVtkEqlUVnCGPLAyVymCe8GAVwT4fiRqQuwqXEiYw7qKN9BIBrxDwcvW+wNhTIVOwd8/d0w8LQlpINg8c+7kDz5gAzZrbskt4PbJykDnXimDjW5Gu+qQaNDB0Ws6kmpgulhfbZBXQVQOyWZavIXcCvJv95AVP0qXn1J0ns8wWuHB5RKbR9ylABzqiyiqUpTwi4Nv8EeJ0Iqk9TZvjOQg6Imww4U2mKZjYMz2ttFx76M264VkBGo4cMMBjuVlFsb8mnYSw9030GYXOuM+MT8KQj2ToP+2PJYh5GkXOz9viMyPh6x1AelMA+S0HPpa
 N5zl1WAE
 eaPYxwQ55Vob3UtKdNw1ElLau1sJV8qDJnmfp4mz6mrqx2txCRX+aN3dES7ghiw2+AbQR8j7Ah71qIFQ4v4ESKEfKOB3FLQJqj6pNw3xkj9SjX3GgA1OASSIvDUpNgDViMMJcpk/QxO8SBiACuigy/TUVwIO4q9JIfsxqVUG5nUtPXGSExLIyUNjI68NUK+sgAOxhOgIJ1LwqeY2VAtmIPdOC8r1GRmeLF3FzgocKEPnNBSznrJYg/PT143G6NgWiXgncG3fyzRP+LktK2Nf1L0134IqFOGH6NwwOvlYK0dXm6j+oyaVmMbAgXIPkwmI5XgF8nWEFCuXKqnHhABn6G9Fcr8sbU9itXBxBqm1fWPN3RPZfWBXSc5bdwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 12:06=E2=80=AFAM Breno Leitao <leitao@debian.org> w=
rote:
>
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in defrag_show() with a loop over defrag_flags[] and
> defrag_mode_strings[] arrays introduced in the previous commit.
>
> This makes defrag_show() consistent with defrag_store() and eliminates
> the duplicated mode name strings.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/huge_memory.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4843e2154038f..eaa6623fa49e2 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -447,24 +447,30 @@ static const enum transparent_hugepage_flag defrag_=
flags[] =3D {
>  static ssize_t defrag_show(struct kobject *kobj,
>                            struct kobj_attribute *attr, char *buf)
>  {
> -       const char *output;
> +       int active =3D DEFRAG_NEVER;
> +       int len =3D 0;
> +       int i;
>
> -       if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
> -                    &transparent_hugepage_flags))
> -               output =3D "[always] defer defer+madvise madvise never";
> -       else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
> -                         &transparent_hugepage_flags))
> -               output =3D "always [defer] defer+madvise madvise never";
> -       else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG=
,
> -                         &transparent_hugepage_flags))
> -               output =3D "always defer [defer+madvise] madvise never";
> -       else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> -                         &transparent_hugepage_flags))
> -               output =3D "always defer defer+madvise [madvise] never";
> -       else
> -               output =3D "always defer defer+madvise madvise [never]";
> +       for (i =3D 0; i < ARRAY_SIZE(defrag_flags); i++) {
> +               if (test_bit(defrag_flags[i], &transparent_hugepage_flags=
)) {
> +                       active =3D i;
> +                       break;
> +               }
> +       }
>
> -       return sysfs_emit(buf, "%s\n", output);
> +       for (i =3D 0; i < ARRAY_SIZE(defrag_mode_strings); i++) {
> +               if (i =3D=3D active)
> +                       len +=3D sysfs_emit_at(buf, len, "[%s] ",
> +                                            defrag_mode_strings[i]);
> +               else
> +                       len +=3D sysfs_emit_at(buf, len, "%s ",
> +                                            defrag_mode_strings[i]);
> +       }
> +
> +       /* Replace trailing space with newline */
> +       buf[len - 1] =3D '\n';
> +

Interesting. We used to use sysfs_emit(buf, "%s\n", output),
which appends a newline automatically. Now you=E2=80=99re replacing
the final ' ' with '\n'.

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

