Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40743CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB286B0088; Fri, 19 Jun 2026 15:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CAA6B008A; Fri, 19 Jun 2026 15:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7AE6B008C; Fri, 19 Jun 2026 15:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8F76B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:18:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBAA94053C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:18:17 +0000 (UTC)
X-FDA: 84897623034.05.F8C37B3
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id B431E40009
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:18:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFSdqtWG;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781896695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqW7q3u7togbRFKtEuGGNBcC6+oDdJ41gZLx5smHWAg=;
	b=BR1GdyzQSBArc5GlQ4fUDKzj66YrK2A672NPj44DfzAxRD1hj7d9IlDrKGU74ntdR2yIGG
	MjzZlOoeAzOiwkWdK3QmLQCHHxfAsnjefXSwRn5s9IrLVziIDe55QTjrTO/FSO1e/nTX7F
	M3hSflaLEExUjuqKm0TCn8eqEFh0td4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IFSdqtWG;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781896695;
	b=syqjHssTkvxbZKOkXIV8V16jxDUU3Crd5dr6nZYWKt/ic2rlAehteGt8ZJHLyTtETZE8oE
	O8soFlqzJvRZ8ZnD564bMElK//iFY8hLVwfd29OzdLv4jGbk+Gd+acZ2pRBmhAyrc4rVEF
	lOeksDsBvqd4etuZbLzb7V4FIDwHFbo=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c07a6527453so287335566b.0
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:18:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781896694; cv=none;
        d=google.com; s=arc-20240605;
        b=XfdF1Y2A2wjB7jKAc84A29VkQI4RolZWQrpvrwI4wBYtU0Gn5hSlQ+n35x6q+GXKbV
         lCCXRQWEHZkfMHMD+pV/4QAgQW7sJfC0tOsLizez3jJwD72Fxy55RzfVg/uRvIAafvYs
         K/UxD5O3bChNZAPK/Ng4Aw1smMqbTTK9VYmLKxBLwQ/uLbOEUU6zpO6mDMPcAA04ydZW
         43RCm5KBq46yanBr/JWWbvV6oQvPuzobPrwg3C3iLN/kwn11LBxh3q0DwzgQsNeM8cw7
         l9BcKw9YHtbiuTnv5oFmdia7+6G+FPsHYtrw4H0uh38c9XVqWud7yUz0yuzQusueVg1K
         89OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iqW7q3u7togbRFKtEuGGNBcC6+oDdJ41gZLx5smHWAg=;
        fh=63eJSByyfPXUWEd5qXerlQHGwdBtfvcnn5NOHgA/+kg=;
        b=R95843Xbi6Qs56qJx6EKu9SKhUtScWpoUM5yqoIhVs8xJB09enw0afNvTV8ZRSn1nr
         ucANbBklhteoK3dBpwj6/Jym0Zbbv20m0Ttt4+7Va0aIQqhzC/GBQhk8n0S6+ggxzFCF
         x0zH9stKAQ7lTCiu3/OYCE3dngZ3VPw1iV+Ks2x4pqcAEJievOz7ByGtOamIWrHmw/+j
         hDNQpCdF5XOOqBmAIzKcGaMPJOMOerGH1AMhGxgoqJU2nJipM39+8Af+G0NR3VZsJBk7
         uVmnWwUhUvhoc6PVXfKfEEOa73rHUjy0D/Q+65vEX0D0+D6MRmXR6Gj7tRfWdg1tpQo5
         BKQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896694; x=1782501494; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqW7q3u7togbRFKtEuGGNBcC6+oDdJ41gZLx5smHWAg=;
        b=IFSdqtWGNbl83CXrIFegTcSkFeRkvfchOswdWXF4XsNC8HnCAG09QlTstqu7P6WJe5
         rxKh2GvYrWrm5qZf9AceD7PFeeSM15QY/HnaOKsZb2F30fECXnSPixESh4h5lT1V+uBq
         cFoV1DOvQ4/um6o0NrqDmxAdz1Srj9b71EJuF2ck98HM/RjTa+UpKcEENTEvz5w9UE41
         C1qXm7ZoKRPCS7VB0ynRm/JBSn49StfzYQtfyBYmGRTaWEatFH5u8bKCCV2PkD4trH4u
         e/MPPqM5zASn611lty768FedZr3WHp7UVnOlsUl5b6y42R8sKBS32x4/hhqOybl0FaAs
         6ZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896694; x=1782501494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iqW7q3u7togbRFKtEuGGNBcC6+oDdJ41gZLx5smHWAg=;
        b=EwSmg1prdRncwhPjgY3acR2NRyjtNXzE63lGQ5Wwz8GlNwxrCN1t1qlZy8xUB4QSIy
         KexEq2gP9iegR6ZC9TPhC3cV98JWd8dGkKat4+m1jRia66hjsxVu6ksKEHvofCAxc99d
         LOngP8pzOeSXU1TflHvIpFl7JfLlLHrurYjq7SJvQc12vaMhNQZXlAyCadNi3t4Fg+Z9
         YkQTxmgVM1JYu1n0EupIi4OM3G0WtT2EJ6atYpA+ONTa8htU8OcatUfaFWJD7lw4+7EB
         5jSBicCV5r0zfBsHGBcEXif8Bg+lXJwQOftJ4KV2RL023IomsF9tNMQNreYnGRjmBwVo
         Agig==
X-Forwarded-Encrypted: i=1; AFNElJ+MJqfZ1KKGQMKmNAJuVe7U/Y3snmyARM5t/H3BsiRAI4VXDEyUlXgLKNYgPB4liVw/gHIRk/Amew==@kvack.org
X-Gm-Message-State: AOJu0Yz9xIJRzexDxyJKDC409Y+9lkkv49bYSL9xDfDSfzlPEZIWUFuk
	ra5LbIwhBmQuRPjIwGW38Fgw5j8uOZTn8m0aRPSYxI4ft5WI3RZ/Z+Twa73Cp0M5l523r/Kj2Bv
	B0lxOW+R/Z2fQdHEUef8jcFTLTe2Ly/c=
X-Gm-Gg: AfdE7cnbsk2O42jl0Y/38xJyUmXUT7Dzfhum7tVXY4JThP9Em/id8e/G0UThZG4178H
	+ZMwRAS36bn47FRawwn9OXo5Gbq9qRhw28IjpzwSORP1PirdfGlvb3Vs2EPKAWLxBbJEgqHPUwc
	0T2FuMI4DW2xUmHNQhQr9pw15nZhMSBwIq4rXBqBEyqr/8HYU0AEvCUWGEAjlvFnkh81PB+pNMv
	XmfFSpE25tgWusbtmBakeGmpVhub9nQijdfMtWoKIEJbzMDhcHRwYbyiohbV65QmdULmkNhddGm
	2b3ilWc55SEvzbeM88ftQCVJlL0PGg==
X-Received: by 2002:a17:906:7949:b0:c08:68aa:9163 with SMTP id
 a640c23a62f3a-c094ac0ab41mr274030066b.0.1781896693763; Fri, 19 Jun 2026
 12:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260618221720.71768-1-baohua@kernel.org>
In-Reply-To: <20260618221720.71768-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Jun 2026 03:17:37 +0800
X-Gm-Features: AVVi8CeYwyMkE34LRTo0tet_Ba3jwddNMb4bHejuJYFiE1m91hWtZvdShWVRKnU
Message-ID: <CAMgjq7Bmi2XYxPc4tVO8KTWSuj8jpt-c-JueqYRK1kLC_nmBqA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nanzhe Zhao <zhaonanzhe@xiaomi.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B431E40009
X-Stat-Signature: ee39o6m67c995i5u7juczs64bfjfiy4i
X-HE-Tag: 1781896695-48169
X-HE-Meta: U2FsdGVkX1+gLNEUgZ46QCX3ryDb8GLiYN7r7hUmYG/Bt/M1ukaZMRvR0ckAzS0WpZBtbmLX+n4cylYKFZKFRCQAKrLoBpIAqtj6D1yZzsg2e06XwuhHPLPAg8341w9krQPNb5Ho2U/25rCoH1DvQTB/qrQlEmdSUebaCEL04r2dOrq7Df1my2SyoYV95FXpo3UOgFMHwd759byPevlKZHM95PhDXEGSXzWwiRjjB8vHZ+9piDuAcBqhhogMV2OddbjhVqFBasbRRf2ukZlo9NIh9RSHbMzMsmYBYlFi2kTmmw+5pBDbs4+zfKHuSiwGXluzlgw2S4n92uJ7vjCmuEJd+FnUx6Fs5mzc9qKpVy6yMSWHdBbHvjcrIhd1FDI4HG92LrAarfHZr1dxUzRkxRXOA/bhP/vc4oOWEb3TbZtPYibDqlPEAQ5vWWWa5+RrZW2A8nvwZj4j3fa0Uh7XhNHnd7xVId2e+9veQjunDPw4y8iQ+uoukrg1WP5MT66lMvrq0v7qFhI83ghAY+wzGY/IuVtks95/aVAq7bu5+8p145vZ6YLI0EezCmm1b2deTmMdw5eGoajLcGwRWUWVPn4G+lTAsngYJEILxLc0il3+sZSpKdC6ew+40HkaFh+HvjRPB/qf4EPepr1g/iQWRymMXl2WAKY2HMhoqHNPNC5ZEB3XxUFKKHRb9CMtrkkY45wmGPYQUpSDfRgtCtWRG6/JADCboIWc2IwK5XEv0YLx5+kcG4ExgAAzeHZbfqggRHsEeRZBEETAaybkswWCc47myV8V5Zmp2Tgps2gw+2nRFBBKP1WiwhZ/PkY4xwuLcaAeCMkeF9nt5zP3ByW96sQdLw5Ocq5qVLFA4No7efYlWrUcr5vFI/eXHMrOGZmN92rjbQSilezk61L6seZ3ejnTywssIM8xwtSPMdtA9qGNxffULwMU3hs7ObhQoI8C825VXK1nmGEqGhJ5az0
 mq9CnxxG
 QND9G7keR153L1jkrfKMVZYL9FxJLWmUYkLCZVndb7JIy8g3w40iCjdkSzIS7+KDAjE4ryj7INouNyYstUtz6hJRQD9Nl9Wdg+q+9AKD+uN4HH7pFWEjyoc+D+PsuFbYYNeVjcpAyseiPtvUUWThuhSvOXFQFp1U8KTyHYYZ/r1hLyjlZVkZ78AwltdIfIaAr52KOE7Jgogx0HVjqgowdC47I4p4FooQnDyYgstmNso8rSTqcRfDmxnZ1dWbhL3alxW/WqFkqqwhU71VF6dKDlN/AwLvIjmlfHg2mGq5EWMKTyBpiZ3sNGOvbaAePSO7O/vPZO9FQrCAeR5nErSo/ntXDETLM1l8zFy0HO7m60ZYJ7zQIjXuw4q1aJOLFIGb23s5hF33793yabUVkLu194ZougNXfjhKd4rIdymmfdhvDmcZg/i7RnnLdot+OJ9s6yIxkME3g5uatlZhMGYDuEJQiVQW1VwuEiGfSlBwLS4i0OBlAlOfUrcev8pnYg+vveN3LbUaNSQTeR7BKOMxcq7isHzfslvyfU3eRkkLKDmaiWIKJFKqbcAQTJF5HSfcvT4AgO1ZUtHaU3gIwI12A/ElIcQA0YtU5jyW6CpO9mbaqoquvPl/r0dHQzfTIXPHX69QDA56yuxVKdirBNAO+YJKZDB6XfSAKw0wq8wQ+VgcFzp4ABajdT6iUMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 6:17=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> When swap is disabled or exhausted, swap slot allocation
> may fail during swapout, causing large folios to be split
> into small folios. The splitting is reasonable when we
> truly fail to obtain contiguous swap slots, but it is
> pointless in the no-space case.
>
> A simple way to reproduce this is to invoke MADV_PAGEOUT on
> a system with mTHP enabled but without swap configured.
>
>  #define SIZE (16 * 1024 * 1024)
>  int main(void)
>  {
>          char *buf =3D mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
>                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>          memset(buf, 1, SIZE);
>          madvise(buf, SIZE, MADV_PAGEOUT);
>          munmap(buf, SIZE);
>          return 0;
>  }
>
> With 16KB mTHP enabled, we observe:
> ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> 1024
>
> This patch checks swap space before splitting. If there is
> no available space, it skips splitting. After the patch, we
> observe:
> ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> 0
>
> Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 299b5d9e8836..33f84a5fe7ee 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -339,8 +339,7 @@ static bool can_demote(int nid, struct scan_control *=
sc,
>         return !nodes_empty(allowed_mask);
>  }
>
> -static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> -                                         int nid,
> +static inline bool __can_reclaim_anon_pages(struct mem_cgroup *memcg,
>                                           struct scan_control *sc)
>  {
>         if (memcg =3D=3D NULL) {
> @@ -356,6 +355,16 @@ static inline bool can_reclaim_anon_pages(struct mem=
_cgroup *memcg,
>                         return true;
>         }
>
> +       return false;
> +}
> +
> +static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> +                                         int nid,
> +                                         struct scan_control *sc)
> +{
> +       if (__can_reclaim_anon_pages(memcg, sc))
> +               return true;
> +
>         /*
>          * The page can not be swapped.
>          *
> @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>
>                                 if (!folio_test_large(folio))
>                                         goto activate_locked_split;
> +                               if (!__can_reclaim_anon_pages(memcg, sc))
> +                                       goto activate_locked_split;
>                                 /* Fallback to swap normal pages */
>                                 if (split_folio_to_list(folio, folio_list=
))
>                                         goto activate_locked;

Hello Barry,

Thanks for raising this issue. I saw a similar issue report in the
mail list before and was thinking that, perhaps another approach is to
let folio_alloc_swap return a more detailed error code, for example:

- 1. the mem_cgroup_try_charge_swap in it failed
- 2. allocation failed but nr_swap_pages > folio size
- 3. allocation failed because all devices are full or unusable
(roughly nr_swap_pages < folio size)

Only case 2 requires splitting. __can_reclaim_anon_pages also checks
demote which is not related to swap.

