Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFABF8E4A1
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 03:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22BE6B0089; Thu, 16 Apr 2026 23:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9F66B008A; Thu, 16 Apr 2026 23:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FD86B008C; Thu, 16 Apr 2026 23:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C34066B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 23:19:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C94E8CA4B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:19:50 +0000 (UTC)
X-FDA: 84666593340.17.A7809DE
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7832E140004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:19:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dXfDuESW;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776395988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yM18Ak5+kMBmVuDR0UbI8yoR0xCl6Hm9vDklobqY31M=;
	b=qvlYQi5nTNtctH6R2nJ2gBneO9kD/JMAfezqWzfvg4GNBQR3oXxt6QdQX2UPNQivwwRQgS
	BThK1NVLwkqlO1YmLgZd69bH/fdJqTrDhjlPu7FCYWXNNpvrsPL3UtJ7LlTzvMHNJBAMIH
	biMcpY3VoQa6PvJ0T/7GkMb1zmyJybc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776395988; a=rsa-sha256;
	cv=pass;
	b=6aL8tU3oalx621Tu2lr8v1ELU6k+CkmdMeMD/floJtVHZYS6FbuCQMc22SuQB/5RC9L2iE
	FI5+Gs8CknhdBInzrXdFNKDzgywqGtFOosAJtejUo8Y9cl0PdDYFR9BiwfKHHdHw0ptCYV
	S6P1wdgGIMosWcrrwivVr4GoHbFHy68=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dXfDuESW;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-671c24f23b1so318482a12.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:19:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776395987; cv=none;
        d=google.com; s=arc-20240605;
        b=IhVa8F94HuXJ9nKlOg1JD5EOgAfpk0JiDW8n6gWmRuz9AqKgC65BYltilZve0HHO6H
         RKHjjTJOD5R+AnlOrC7hENkpH8DObYxozt5cTGJekBw/BttQO3NaxSgaGoXQE9n+lQcg
         oaodNVAbMgzZEatdDjf/HB0dF+LT82zU0LSF7Li9S8UwKyvIyseRNl428EvUctzTaRrs
         NCooE2XI560QF6tzaWaHzFkOUY3zy2L0DUaMbyBdNuLlnQAPz5sl6tlJPQUAaA2HKRw3
         ZPABtbEpFChpcVmAiG6x6Fkqf5mBwl9ObGpqWlwkmCNz+/kJdoTXBUorUcpPjL05s7wF
         MsLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yM18Ak5+kMBmVuDR0UbI8yoR0xCl6Hm9vDklobqY31M=;
        fh=gH/N5PzQOG/ThuUsuz7+WdhoOrzQW3jI8VRtJYkVEO0=;
        b=M8NXTl9MoyVxxW9f7fVQzwB/MFli/aUGYWxYC9o94t2n5+CVWLJoLpa8Tex5Kx3Im3
         4ozhEy5XhDomsztGVreS6QpLLA0KCbR2dYlim2MSaTrTgPSuIoEcLZUFB5sCKydVxnfj
         u0AcRLdVCrovIkZ31+qgsb7u4h9HwrlekFddXRKGcUfzsF+peMqHGP1xS0RKuK+oR558
         CuuGZnK3is9k3KEDdmV1B+V6+IVeMlVple3yrWFgh/xTRQTnNRyDBOUwgHU2TpgN9SCW
         nOJSWbm4b96UjnGB5IgWUsd5R1Qg51MNFEb4lAYtpHaj88pwI8e7zz7PpVtGBGm8u0CB
         J4PQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776395987; x=1777000787; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yM18Ak5+kMBmVuDR0UbI8yoR0xCl6Hm9vDklobqY31M=;
        b=dXfDuESWMOx9ZyvxaE7bxoXhYAsu48FGorXiGQS4LsKsPhy77ZEM2bSlfQYo9RgaRG
         0FnKVtcCtCyvgK5wWVLtn5devEh+Sof6Vs+ne7C9Uh9RZiX+4SXeWLcfGNHKHsqPbUxB
         KvefqKD2ixd8saJpDQuVHH0cAYnpGhbvqFZYfJTgmMYmjdUW4IbdkbeG5ppTD+q2Koga
         Bq5vdxl4Eo3Ccc7n+Nssv77wh/L3hitWw2bQyjk1EYVkmrATVvac1xGTGrLsFfMBVpRT
         L9lArH6+8HDdqbnyTqIoJcSWRDJWN9eOmpsT5ArugXLe3peuiTkS7tctpLlvEXKxdvZQ
         V0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776395987; x=1777000787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yM18Ak5+kMBmVuDR0UbI8yoR0xCl6Hm9vDklobqY31M=;
        b=pyoH4/EWhXJNBmUKSKGK4TaBumnAGVsQ9rLMbT5kYEiMyYRIT30xgtuG6nsYVw9nN4
         3LAnwuyMv0FpuvCt2iH9K5k5dPlCWT6B5PNs6EUHGOrQcPg/gCcAK68oom4cWBK/dxm2
         XXWsGRU4vWDbCAwTVmwydbjfwBtvxFCMxH715zmh0u7i9YEf1/pDiLGN8aS0PJ49ycZO
         swdLbhv5rAxR9yR4AKdPU/vJ3/XohhAGvL1ptnIuI0EZWoxrJ3EFsb8+OCoRhpOXpjtd
         X4vF5mQLXNagfS3IUvjzPpvPpYtJAmJ2OkL14WRTdyDJOD0r5+dCm0BCtvw8+Zad3HyG
         ndnQ==
X-Gm-Message-State: AOJu0YyAzsn+2G05ou8cxousMggKSJaZKBNZhRjph/t8T67ZbctJK5iR
	SEeK6ExlVtfsEYSDqjN6qKn5//sUaH807W3KvIhCqfsKjMZ4zQJ+a4RuqevsadwcCGtD50d88Wk
	77q9mn0kbFPu0XD4Iv4vstYCnkbJQB1c=
X-Gm-Gg: AeBDieuZ2p9MpyJ2aH+dXu6hOMNZims2kVm767KMx5uLkmn8zxr2aVVEqIduYE0iFio
	q52YpXWdbJMaCyMzd4Xas3Dk8ucJYGmM0cryvNPDGUyE/yTEIC44pupmAFsa8C0emKbOsp8MULN
	pgE+EJzZ5qpN0YvlMRtAYNVXTjbKElPMLddMGXEl03yWrbvNBOS1eyCD92khxG6wPyXsnUbpxfD
	LDhSocsvzwqbX0HKEIXPdnrzoZSAU3KJIeXK45C5yy8n2ai5fBa0lPr3h0nazA/f1T/N9TrpVw4
	KbGWEo77FDymyMZk/W58OPu8b3/UoA63V/XARFM794fZnH81W5w=
X-Received: by 2002:a05:6402:530e:b0:670:a2a9:fe59 with SMTP id
 4fb4d7f45d1cf-672bfed7667mr512994a12.25.1776395986572; Thu, 16 Apr 2026
 20:19:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260417-swap-table-p4-v2-0-17f5d1015428@tencent.com> <20260417-swap-table-p4-v2-4-17f5d1015428@tencent.com>
In-Reply-To: <20260417-swap-table-p4-v2-4-17f5d1015428@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 17 Apr 2026 11:19:09 +0800
X-Gm-Features: AQROBzDC1qIzgjTfCrL0QSfj2b-Fvn7EnI1uFbve34YiphupQbw1nZbSmw9Wqt4
Message-ID: <CAMgjq7ANih7u7SJB8uWcQHS8XRJySNRc3ti9V-SVey0nGE3gLQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] mm, swap: add support for stable large
 allocation in swap cache directly
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1cadr9u3imiikywtixsqgr9izwj4zrxt
X-Rspam-User: 
X-Rspamd-Queue-Id: 7832E140004
X-Rspamd-Server: rspam05
X-HE-Tag: 1776395988-718991
X-HE-Meta: U2FsdGVkX18sjgXfGk2dKYFDBrofSoDwrfmgS6t+A80lHr0RbyMpoM7YtpTYPdmr92xoif8lrLJw9CoGv0yaXVO6fOA6aCLghi46hnNkbzF0OOk4arOVA69FJQG1QLkaeh3MoEwkjhU3fwfwGKVNQpQOT0BP5eo79BHmow9REK08ZSuR7LG2INMJObaL+Cfb5KvO4MouDK9MmxVMftbiyY4J9hn3HqQjTj3M51ZH8hTFIn0zSCEG7TiY4yuotVS7oJlmvEjvlop8J77kvsJbTDFRczObIafttMy7J6637KTgM84i5RYDqlFgFJgg6HrZ73RjlyLv9GKB8//oiLl1yctdSQeygM3PIvLzxKMStGzGyuM+CmN5a+z11HWJvceSg3a1E3XxOOXdNd7fT29/t6Ieem7zw83QGhTUxKQ3KpTN1TR6lnXVAh6iCfrg31oLJKkhsfNiZo8p5T6KV+zIkKLoGujbQm8PngmQVLhu1fpkic7dqW7L0t5YBAFJPl3SExi+r5bxX+wY5ztz1SVq5i4qCbMzwSttFY6hrHMO9AaeCuORbT5ky9sn39Y2QpRq8/1sCLPJ6EVG8sTJxJaE+XQspM37wyy32c8JJDXgfwUpbvscnoJ7vzsWrYFeqcOwgfY83gr15Ec2N+zCgIhexiL94NJ27rPA3ZFD/uwYF0xlTo/W8DCZumaGsx3UkBpGRBH8Y98YvZi5ZGNh3SaixhZCOnnyc0T2shuF6x2Np7GDsA8X+zaile7yxiWZlRmF4lrjFXvzEa5eZ0ZEimuy/Wkqj9GXNqn3D8iDvumRNRrR1WC4HSMbgRTU01dXH+HJXmqvttAHXtc3vW8uCxq00tRhbDqO4xK6rr3q6+G9tXZDM5cgjsnQMqRah3gKhwLvt7f89bBf5uBZR7DUPGKa+8MVi+E5LCwwF1wMH7drnpDYrX3AbyJ6KvOg/0bdm5v+Nz6XoTRvLPM1uppNbFY
 A7Q+9PoO
 mIFMuOVDhIkJ/yEQnvJ4rip4Ho/quExOFvxiWDpFQaNZv2CfxPxbswSXrGlibqvfZvVrmOMyq0KkSerec0pKgloFkfuwV9Vh3A7VdkSqUk1JKw3Pap/vfF7edJEm9nVmxaFxxa3eL27mpPThSUz9xkUWcq1+mNjF8cn5rrsKe9Spsy3b56nCYsFGohfDro4UPb5XONAJ38cDC/TnRQMHNey8dROknPTO8WkBWfhgb7kYlSuwVeIz5xc93FTEkyYTebJfui6dXE3X0k1H0iope6ytwUUBJI2CuWtFakvkLWq98rSW+9Kaf4SZ+WN1q9MeeO5wagya34bVk/aA3HfoNpuoh98rY5y0iPlTz5Vxx0QVaS8sm+aKJ0nuxOZLmuZe9lF4PN6cBUGoGq3+V86cJkTB+qH61CxVkF9Z+lFn7QPNLq90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 2:38=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
> +/*
> + * Try to allocate a folio of given order in the swap cache.
> + *
> + * This helper resolves the potential races of swap allocation
> + * and prepares a folio to be used for swap IO. May return following
> + * value:
> + *
> + * -ENOMEM / -EBUSY: Order is too large or in conflict with sub slot,
> + *                   caller should shrink the order and retry.
> + * -ENOENT / -EEXIST: Target swap entry is unavailable or already cached=
,
> + *                    caller should abort or try use that folio instead.
> + */
> +static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
> +                                       swp_entry_t targ_entry, gfp_t gfp=
,
> +                                       unsigned int order, struct vm_fau=
lt *vmf,
> +                                       struct mempolicy *mpol, pgoff_t i=
lx)
> +{
> +       int err;
> +       swp_entry_t entry;
> +       struct folio *folio;
> +       void *shadow =3D NULL;
> +       unsigned long address, nr_pages =3D 1 << order;
> +       struct vm_area_struct *vma =3D vmf ? vmf->vma : NULL;
> +
> +       entry.val =3D round_down(targ_entry.val, nr_pages);
> +
> +       /* Check if the slot and range are available, skip allocation if =
not */
> +       spin_lock(&ci->lock);
> +       err =3D __swap_cache_add_check(ci, targ_entry, nr_pages, NULL);
> +       spin_unlock(&ci->lock);
> +       if (unlikely(err))
> +               return ERR_PTR(err);
> +
> +       /*
> +        * Limit THP gfp. The limitation is a no-op for typical
> +        * GFP_HIGHUSER_MOVABLE but matters for shmem.
> +        */
> +       if (order)
> +               gfp =3D thp_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
> +
> +       if (mpol) {
> +               folio =3D folio_alloc_mpol(gfp, order, mpol, ilx, numa_no=
de_id());
> +       } else if (vmf) {
> +               address =3D round_down(vmf->address, PAGE_SIZE << order);
> +               folio =3D vma_alloc_folio(gfp, order, vmf->vma, address);
> +       } else {
> +               WARN_ON_ONCE(1);
> +               return ERR_PTR(-EINVAL);
> +       }

Checking sashiko's review, most are false positives but this part need
an update indeed, this part should be:

if (mpol || !vmf) {
        folio =3D folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
} else {
        address =3D round_down(vmf->address, PAGE_SIZE << order);
        folio =3D vma_alloc_folio(gfp, order, vmf->vma, address);
}

