Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2D5CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 04:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 804A06B00E0; Fri,  8 May 2026 00:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5A16B00E1; Fri,  8 May 2026 00:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5226B00E3; Fri,  8 May 2026 00:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0EF6B00E0
	for <linux-mm@kvack.org>; Fri,  8 May 2026 00:01:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0075F16070C
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:01:43 +0000 (UTC)
X-FDA: 84742903686.03.ADCED87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0120E40009
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:01:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNE+jU+4;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778212902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nuslCB4BDS5PrSmAnaGILwfKm1W4U520xu5mOiWdqI=;
	b=EYj16VqLF2f/qabsIJPK9tDiYlun1c5YiZlFwiaqwtm4JwD+1MyMFuOtlYPuG/Vzf2kpVp
	zgQHc48eL4izl8/9yxv3JGv7fLASEVBFZGs5Y5ZmX1xJFLXpMC3T5IQ5uUWvYtxo4VbBaB
	2CyC1FlMCz4carSG1wI7tGAGCuyn4M4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HNE+jU+4;
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778212902; a=rsa-sha256;
	cv=none;
	b=LwIsR7PD1lrYnP2uR4XlZP0fUvq6m7X39EvqulHIxDLTAw1huDRWHa0lVTpR19+fPe6WMd
	1d9t9hFKB7LaUgX5uz3Wure/HR9g1fXa6QIq4T9qnXKlSiUr2U+oa6rYZ89lI4LcKhJ4hT
	AEf+v147q2ju4V4i+8foBf6S/fWEDPk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6D7D43EE2
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EE0C2BCFA
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778212900;
	bh=bFtvUB3+z2oLu1yX9g4cDCufT+/WzAyRWXWCk2y77O4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HNE+jU+4f7ZjUHuzs/LtFn+kz9B6ZexM0fMeVnArOOBkJ7r4M3ez98EbtQPEcy1vS
	 dGN9RBYVGCnq1o44btwZNk+3VMJBfGNUgmELC4nvJkxj3k7uXbPs4PH8onuLZ94wli
	 DnPd/VJupyTrAKWxUJgdkpJGqJAC0SLapSD77KcAE/ntDlZH8WjExQY3GPtN8DUZyL
	 NiKu3WknUWIUKyn8g06N1l3KcxKci1lkEQ2cZrg2TfniKKqn4A4JNSGByOfBAem+Us
	 im2rkdb/eaHJhRPOWAJi4Vt7ay5xvUgizuQeww4k0RzQ816tAOjYVhBbZ/3j3PvUnH
	 Z30EczN0L911A==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64eb84d1e37so1291654d50.2
        for <linux-mm@kvack.org>; Thu, 07 May 2026 21:01:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YzUH2VW61SONOmiDkLOkWmxIt7ETPAYlSUxj4ORjjfCJiwDaPhy
	RNi7OsTScez3aLduyCLIXBR30QF86A0Vv/LBuzoTVFa8ckrL8rl5IqEkz1wl1Ax6w+A4pVK2291
	CoEOEHxztjMIITAIUi+IrTOFHjF/MSjdU8Ag4vwfcVA==
X-Received: by 2002:a53:cf08:0:b0:651:c782:6a8 with SMTP id
 956f58d0204a3-65c798f12abmr8129362d50.15.1778212899788; Thu, 07 May 2026
 21:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-7-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-7-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 8 May 2026 06:01:27 +0200
X-Gmail-Original-Message-ID: <CACePvbVnDrR6e7wvpF-nf1CWgoMdX4MTf7RSv2bCr28W6d8b2A@mail.gmail.com>
X-Gm-Features: AVHnY4K3mMy-e35GzbuzGDUDWwNv7K0aRs6FbOSf6WoJUyBYy6_6WeUzQb6RfJ4
Message-ID: <CACePvbVnDrR6e7wvpF-nf1CWgoMdX4MTf7RSv2bCr28W6d8b2A@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] mm, swap: support flexible batch freeing of
 slots in different memcgs
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oo9yk6xhanz6gajoijythpg1mjjabxi7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0120E40009
X-Rspam-User: 
X-HE-Tag: 1778212901-650324
X-HE-Meta: U2FsdGVkX18ysP2wtdMusq36X0+gwUNA6Mp+GQa+ZSdEHecf5kkSLn4V36HfHEvFcS/IVf4T1L4jNCDGh4oNRvoBePtPEEwb+Yb9sSsYqdaobWSdF1Do72iu7munvawCQcyC3s7gSN0RePJCTp5qbbA4O5Gs38rV6vzqK0mShG05WmtxoMSzX61GbAWkPPuH4HvNuR8n61Dbbo72tSc0tNPdHKwtJJErDztWqzMNuWzgtuyUQ6oSI9tsHqvfxwLM9YkSftMo/2fuuqm8RR3w+dKTjcBui1iyjATypSEnYgKKBQxdyELS3rj4PichaqinWq7CP/hOWQoAsE2iOySHZYI01k3je1hoDe+5Un1btYvDPjw+HVyvhm33D2pWDqaLr+IFJQRKfs1WFXeYT/CW9ijue1E2t8EAaFC9HJbSgNWWTeqHLyCg/zdr6dKGRRiB/bdx6CvUr+SFc7ql+3ViZMo0e/gYJCxl1qi+uf6yqMGtvk7sAeNVL0HuQwgP0O/SY8Vv8AJVEuUYgYKw3C6wOyET6FsKFZJNn1JDh29KwjykmruhTNC50yyTFevq7HkUP+BIyszT5a0Zcly32xmYg3b/DjhDq0rvjhyCFjlXw2j8WAt/8x/acMSK83x258zezoWinJxnNvzK6CIniv13VN8qL38kL5XmoRmCuYXvGAUF7SD/mmI8EJCNANx7q5ZkZ+BWelPmdMbqpTwU3dJT2KzFofC8LnVGxMN94wCIDxxaoFmAXsi2KdjVeiaV8iZx4u0fhOi0iHMXgtNmTfWc3OMcqkW2lUJPlBCn0UYD6TQGGvVLJdiEnBrSI4QqvFS+jfZGAhXI5B3WiXuJ8kKRLKxP44/f/FCo8nsa3JDYSlWAO6igVszteZhVMjxCp5rObLGIFpJoHKz0xXv2IvkZ4/HK559MmUPmOx8L82bP10kcxclXX6WlHE7H0Ur82134K/lQV+QV9fpGRPWREUx
 k0PSXUt2
 sMEr5XJiI9Xnt/Z7xZvjXKUeXESI5UwINQzbXKtupe7K3+v/sl+13xbkO3q9+/W5HdUJBDrsyBnqy5grcenPfY7S48Ju/EqJ/AmE/hEpOnwz9uEtmcfU8nVaB7Wmwjml9stlGIGXFIoL9gV0et4PmiPHtmT1JGhVHxCSVGkTeNDtGexpGsHdMKQSKR+gFzgRqejYwsEOKI8NyFxxTZ3I0VzMPl9alkqQR6inzv+8UtOg/t33Iy7HCtqNfbERYXBR7DrYly4ajCqnIpntYNQTwQ5qFL4vA6bLGOyzeLQotNf1hO09wS+D8Q/9EFP4az0BWmdvrZjKc3irym7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 7:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Instead of requiring the caller to ensure all slots are in the same
> memcg, make the function handle different memcgs at once.
>
> This is both a micro optimization and required for removing the memcg
> lookup in the page table layer, so it can be unified at the swap layer.
>
> We are not removing the memcg lookup in the page table in this commit.
> It has to be done after the memcg lookup is deferred to the swap layer.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Overall, it looks good. Some nitpicks follow.

Acked-by: Chris Li <chrisl@kernel.org>

> ---
>  mm/swapfile.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index e1ad77a69e54..8d3d22c463f3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1872,21 +1872,46 @@ void __swap_cluster_free_entries(struct swap_info=
_struct *si,
>                                  unsigned int ci_start, unsigned int nr_p=
ages)
>  {
>         unsigned long old_tb;
> +       unsigned int type =3D si->type;
> +       unsigned short id =3D 0, id_cur;

Nitpick: I'm tempted to rename a few variables to improve my
understanding. Feel free to keep it as it is.

id -> batch_id

>         unsigned int ci_off =3D ci_start, ci_end =3D ci_start + nr_pages;
> -       unsigned long offset =3D cluster_offset(si, ci) + ci_start;
> +       unsigned long offset =3D cluster_offset(si, ci);

Nitpick: offset -> ci_offset. This is the fixed offset of the ci which
is a fixed in the loop.

> +       unsigned int ci_batch =3D ci_off;

Nitpick: ci_batch -> batch_off, this one go with the batch_id.

> +       swp_entry_t entry;
>
>         VM_WARN_ON(ci->count < nr_pages);
>
>         ci->count -=3D nr_pages;
>         do {
>                 old_tb =3D __swap_table_get(ci, ci_off);
> -               /* Release the last ref, or after swap cache is dropped *=
/
> +               /*
> +                * Freeing is done after release of the last swap count
> +                * ref, or after swap cache is dropped
> +                */
>                 VM_WARN_ON(!swp_tb_is_shadow(old_tb) || __swp_tb_get_coun=
t(old_tb) > 1);
>                 __swap_table_set(ci, ci_off, null_to_swp_tb());
> +
> +               /*
> +                * Uncharge swap slots by memcg in batches. Consecutive
> +                * slots with the same cgroup id are uncharged together.
> +                */
> +               entry =3D swp_entry(type, offset + ci_off);

Nitpick: This line confused me a bit. Two offsets are mentioned here:
"offset + ci_offset". One would assume that ci_offset is the offset of
the ci, and the offset is the incremental one. It is the other way
around.

> +               id_cur =3D lookup_swap_cgroup_id(entry);
> +               if (id !=3D id_cur) {
> +                       if (id)
> +                               mem_cgroup_uncharge_swap(swp_entry(type, =
offset + ci_batch),
> +                                                        ci_off - ci_batc=
h);

With the above rename, this become:
"... swp_entry(type, ci_offset + batch_off)," ; This combined the
offset turn into the swap entry.
"ci_off - batch_off". That is the running length from the beginning of batc=
h.

> +                       id =3D id_cur;
> +                       ci_batch =3D ci_off;
> +               }
>         } while (++ci_off < ci_end);
>
> -       mem_cgroup_uncharge_swap(swp_entry(si->type, offset), nr_pages);
> -       swap_range_free(si, offset, nr_pages);
> +       if (id) {

This becomes `if (batch_id)`, meaning if we have pending batching, we
flush the current batch.

Chris

