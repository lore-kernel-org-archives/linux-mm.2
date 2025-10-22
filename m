Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63016CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B753D8E0003; Wed, 22 Oct 2025 14:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CCD8E0002; Wed, 22 Oct 2025 14:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62B28E0003; Wed, 22 Oct 2025 14:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 960828E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:08:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49DBC1408AB
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:08:18 +0000 (UTC)
X-FDA: 84026534676.27.AFEF26A
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5001240015
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:08:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gPbH2/kH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761156496; a=rsa-sha256;
	cv=none;
	b=Z7nKzefjHgzTC2zwLr2Uu8B1DEfPoJctLeCCjJ4qoLGLc8+LFwC9lg1m9gHsJ0xG38ufzr
	IhT1eKKkL/DKgtZC9OL7Qi5EDWeJ9tULsNoQ52YMuZuvnWzWnhlh4JcGdiQ99g4Bs7P5fS
	ptXRtEoeCCa61DPae9370DTJz0RV5H4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="gPbH2/kH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=shy828301@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761156496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMQtFFxEEsqRDxbkrZxdDgeMxhSRyhXbpWRw8AN98fY=;
	b=m1L8igL7JBWWLA9gHg3vJXuh+hVeNQW948SCwbS8Dp1cG5nVTwExMsCBA/h2NmjKtfMgdI
	ggtPNdw4q+PpcIvNt7XEV9x7yd/lX7+Nx+pfEJ6J2cgIOSEwSsLMNvk43p1pqjlrRmApH6
	KAzoEMunSUuuTbRxkb5tmL5ZulG/Uzc=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b64cdbb949cso1212103666b.1
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 11:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761156495; x=1761761295; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMQtFFxEEsqRDxbkrZxdDgeMxhSRyhXbpWRw8AN98fY=;
        b=gPbH2/kHGX/LjDLmPv68Xs6MezdA7cqw/kvtLaXUkcXyWhem47oVIRdJsGHrh+O081
         nzM4x2rjIoNWEAmmDNGurLBznPAg5uhV6JittitoGoP11lM6YKq7fUYmfvMhoHs5s0Pi
         ocBJ8h437Dxl4QAFJkM/bZVXpVV0NXMTlK2G0sg3ii751TPT5Ezcyz+BFEJeROjZRA+E
         a4ilMT1R+cPFumKsdKf9iWLP2EwZSw+Zqp0bij0KV0eKSOiMyI36GzR5rMgibJh1y39v
         1Edkk9ra9Xx7Zaer+TPfcUPaWZemt+bzbmKgDN02vb1PudpGUhD7X3n3uX6pgPVfeTfm
         NPag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761156495; x=1761761295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMQtFFxEEsqRDxbkrZxdDgeMxhSRyhXbpWRw8AN98fY=;
        b=mrNgipgJtKHRP2KsVZXqQosQi9R8CICIiOEBvUNXLL7UmekE/UDoMPq2SdCXMxlfH4
         b+n5cxkZyDTTAf1sbYMDKMT/3/3HY2En59LJ28zGDVr+uQT0pdVBHFs9y0aibybOVxMd
         KFLuQyNp7FEWMW5cA4GCXTljjJxf11PBfvab5Tb/eqGkhF316FUJx6xMtbrraIeZjexz
         Zug8toUzmXHrb5nsmi/YJt53LdJBuafammpV5gVQKSEC/pIYXnARD+w8WVtSPhXv2djY
         JE/QhpHdZmhHVVuWg07WuB6yFdzpOv/8ZPtyIU629kaLsy+qT9NmYvetmcuNxvuAJoKg
         74pw==
X-Forwarded-Encrypted: i=1; AJvYcCUNwgScSPWmrq07K0nO6mxsYVhL/nNrQg85//3G76fSKp6QFnNoDJfOXs6pmJcNKV1XQ1Jt4e4M8Q==@kvack.org
X-Gm-Message-State: AOJu0YzvzulGHgZ0wCnbLvm3fbL1LdkKVOHC+RlSjrQMElIXl9Khwt7r
	bBE97rrkqdLrsGLTEq4LCohM+rlOOu+bwnDYG1TGzew3vnxM33rNIBoMd/wlFR9lZlQHYVR1vru
	VWNfSLvoqJqIErrcoJEY6RXc5zohpFWk=
X-Gm-Gg: ASbGncvap3mdgbJyHV8F7bJDD4KsWy1qgIIoE0OrLboUd3390NnIpNJ1hCxF3/ZS7Ob
	/YfhShpKVziuXVkoPe4J4m223Gorvrk6BHoq+NGtQMw64Bq1x+tfOwb+iD1bL/y8/o9KqwSFRi9
	Ghdib20fGqR4VBCwx3jl4z0mL1wDpsnywDqQnzEYsddx1W8jS2/nBjuedtz+FJQmO1ju0/WMnD3
	dme/s0fv3R0w+Zsx2zrgo+5gltZX8MlwsqSrv53ZOHUrhorTxdpJ6YhV79LPyfaIaLfif9wCQ==
X-Google-Smtp-Source: AGHT+IH7M+imCkUPIEM0gojaqd/rG3Zx43O7A6mvp4uWZ0+fXegjfowMFGF2jPMC9fA+q+PtLYZiTxzhKO7/x560Dos=
X-Received: by 2002:a17:907:25cc:b0:b40:c49b:710 with SMTP id
 a640c23a62f3a-b6475129316mr2333654966b.47.1761156494265; Wed, 22 Oct 2025
 11:08:14 -0700 (PDT)
MIME-Version: 1.0
References: <20251022101704.4015055-1-catalin.marinas@arm.com>
In-Reply-To: <20251022101704.4015055-1-catalin.marinas@arm.com>
From: Yang Shi <shy828301@gmail.com>
Date: Wed, 22 Oct 2025 11:08:02 -0700
X-Gm-Features: AS18NWC2FvbWTzA8C7rrkZW5hEdgmLMERlEUwWO1avl88qM2ea0eHvXPjFT8k2c
Message-ID: <CAHbLzkoG7zXHubYoh3gSWkdmsLEsMDrBzdAuViRzTEwQNHkpNw@mail.gmail.com>
Subject: Re: [PATCH v2] arm64: mte: Do not warn if the page is already tagged
 in copy_highpage()
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com, 
	David Hildenbrand <david@redhat.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6ifg65qk4oc3fgdx91adug78nnrs3yzc
X-Rspamd-Queue-Id: 5001240015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761156496-841116
X-HE-Meta: U2FsdGVkX1/LQiczwtCdwZTziM7EJY0+/duzK5/notc/dSFwbA/SUaOXpAxy3osVEGiOkDFoi7jxHgnurKWa6n5MQKqx2VhrnahqNQZzMTTkTjnBgVFoSTjojZhlCBhSqqgAmCkuRyI4mRAx28+/2auoJwLzk/VMhJVIsYCZVaalE8oZU3gH6GQmH0hEWnlXsiNe6XPAvFGAEKfZa0b0pfEusmYjVtYMSBJy8ZVK9zbacWdTfZO1uHRO8sQPIVZQ1JT0J/qOa7dTMC11+a3GWG7U7x5D23LmJOmK15KW0UCYtG3Tpx64NSujKcBuaLPswKFkm1tYpCYquFNCBXnaMsXthfntUh9gjo5e9xd7yMfuX5jVPu87f8tHEeVaw4mYJuGz/AdBnO39Xal+IawRodpU3Ip9vWGEbxQeg8ZC9p0ZGGyPTsUffcl/gy/1GdbZY29NN7XkIGrL7ysixUpu6B2wWDf27UKq9a8VuYP5hWVljbbRL4HZ0xxNXPYarDx33/EPZsAFSRCLIjG4qh8gVe97ALKURAMZGQSk/LqhGKJtIwprWJndWffzjsAF6vqE4wH0eTibTdDaKfnEyqEPkmouhASX+p/pUkFUIQz2MTbFDQv8Jp/q1jBju1vrpUQH+OmsP/snmuwC9fZQJDI9z8+pEhEsvGCKBGTgAzblt+bIuxF+PJ681nqUsadkTWK4aHGygYUBJAcYpzx8QN9TH6e7ULuIU7sqNOfCpIU0o/BfSUzEvp2rut5+vdexj5lZDCuoXCgrnYwRlktbC4OPsZpNrqwbjguE4frgqJQIXwsgci/08rLEyn7KL+73iKccHiijjAZCyC+5iexThCNuho+EndWYSknC7NXfXsJY/68E/b0qZpDMVV5yMoE+WEhLnjx0B48897bCPMfgq2J/bHbIpBtYKNAOc9Yap6MRConZPt6zK6NQ9zZBm/bpzaArJyHYJK6Yj3DyyYnXpT0
 hgGaXXyj
 uXhCR4bl3RvscaybIU6cOgcbsTrK+Oitl7MTNLbo4Z/fAhyX3mA2gZ0xyy2P8Vnb7UTjGZQP6iQATAhDsMS9qUt9cE7C4zn2sMiWxO9D+Y8zhH+Rm9n2h0sUaE6x70SogXanoR8kVisQ9e2mFWuv7WBsp+cAHqkv3J9HTHpXROwtfK571Duc7kMdrPmgdeXXl/Qe+BiAwIbvekfOaAxhCLOOtpgvK7PTowJoAAWPfXUv6W5qJbZj8gAakqK6VrPUk0bfAG/kTimM3uXyLiQffvGW3F+xWS8V6pPK3uE6iMpn2ndclwTX2BSLkhL9C6iN38DA21w3azfBzYJwJh24UtV5J8wcnuVg/ToDDeBCDDi0rMdKtip5A+w1C8pl9wKZm5wd7A2O8XI/b4/ouiMCFxi9ZM/hoXfW2vSaJGAl6z/AoFL58tBldUxLxbK21KE03xPJjSvH2Tm5V7c3Cjd/OxSNDTpj3U0l6ldX6sFquyIqfXP+B69i7pzI0j7MzAkLd7Mn4J/oWMkL9zUJqnGepoNJRmjfg4z4wQC5BYUD55xVmEsCNknThZW8/lux6TAJfwyduEt7GvcpEqyZaJHqQl8bBLnOypp0rZei93hDBPpPCZ4XANdxXdavFcBWqlI0Z4UtGLLeQ9vm+jEw0V89X/A/9UiV9vOyRmdWXRhRUWXEX7E8BWcsDTXBzORzUYa8Yms8Q96PZgsg7hpcmJELXDX5aqZ4+UMirsfCND7R3qPL1Ut6DIvK9cqTXWdFfte0nPMOQznWXgEhfNELi14bb5+hI7CMZKzPqteIdpA4T+a2S0ak=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 3:20=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> The arm64 copy_highpage() assumes that the destination page is newly
> allocated and not MTE-tagged (PG_mte_tagged unset) and warns
> accordingly. However, following commit 060913999d7a ("mm: migrate:
> support poisoned recover from migrate folio"), folio_mc_copy() is called
> before __folio_migrate_mapping(). If the latter fails (-EAGAIN), the
> copy will be done again to the same destination page. Since
> copy_highpage() already set the PG_mte_tagged flag, this second copy
> will warn.
>
> Replace the WARN_ON_ONCE(page already tagged) in the arm64
> copy_highpage() with a comment.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.c=
om
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: <stable@vger.kernel.org> # 6.12.x
> ---
>
> v2:
> - Also remove the WARN_ON_ONCE for hugetlb pages
> - Drop a double-underscore in the commit log

Reviewed-by: Yang Shi <yang@os.amperecomputing.com>

>
>  arch/arm64/mm/copypage.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> index a86c897017df..cd5912ba617b 100644
> --- a/arch/arm64/mm/copypage.c
> +++ b/arch/arm64/mm/copypage.c
> @@ -35,7 +35,7 @@ void copy_highpage(struct page *to, struct page *from)
>                     from !=3D folio_page(src, 0))
>                         return;
>
> -               WARN_ON_ONCE(!folio_try_hugetlb_mte_tagging(dst));
> +               folio_try_hugetlb_mte_tagging(dst);
>
>                 /*
>                  * Populate tags for all subpages.
> @@ -51,8 +51,13 @@ void copy_highpage(struct page *to, struct page *from)
>                 }
>                 folio_set_hugetlb_mte_tagged(dst);
>         } else if (page_mte_tagged(from)) {
> -               /* It's a new page, shouldn't have been tagged yet */
> -               WARN_ON_ONCE(!try_page_mte_tagging(to));
> +               /*
> +                * Most of the time it's a new page that shouldn't have b=
een
> +                * tagged yet. However, folio migration can end up reusin=
g the
> +                * same page without untagging it. Ignore the warning if =
the
> +                * page is already tagged.
> +                */
> +               try_page_mte_tagging(to);
>
>                 mte_copy_page_tags(kto, kfrom);
>                 set_page_mte_tagged(to);
>

