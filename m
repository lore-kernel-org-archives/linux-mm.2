Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E87CC5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 11:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33776B0095; Thu, 20 Aug 2026 07:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE0A6B009B; Thu, 20 Aug 2026 07:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85B26B009D; Thu, 20 Aug 2026 07:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90C486B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:36:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06B9F1C006D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:36:57 +0000 (UTC)
X-FDA: 85121446074.17.6A0B52A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 21ED7A0004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:36:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SB5RDxXv;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787225815;
	b=TjJERMRWUs7uSKQeiZNpHQYYuLSiHWopgRGlKC0qxPxHvJ6BW8x6BM7es1q7J4g9uQRVLX
	iy5p+/Vsvmm6imzs++9qDCyIgQWquw3nF3aaBt5Pg9fZHUizkcSdEwgCZsVRbiIMlFjUAx
	mH36AayooyQ48XrjKRuWP7U1oVm8OgE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SB5RDxXv;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787225815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rvWP69jNYCLEMQnHPvdNYBrNQ/dPw0juu10J6Hhu5g=;
	b=vXiDeswkmyNkM+jEiNld5LZUzKje1dRNmCYPFD320OdBkQ6FX0/m8EJFh253GJwNi+3YYh
	yk09AXbdS6ymdqFIhgddJKUu85Ak8BKggJc3+jwf9Yx5d26rheBn2jKdbJDnYvSWfiW81a
	J+v6KhNpIIInt06Uwl+DIJrMNwxnmbY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E5EE60A9E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA821F0156F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787225814;
	bh=1rvWP69jNYCLEMQnHPvdNYBrNQ/dPw0juu10J6Hhu5g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SB5RDxXvl/ioN4+C0+m6YIiRbM3zfhIQb1E+HC/YzVqhU6PxHRd0x0a6YmL5joNdo
	 4e3l72tD2ncq5FK1Tr565oP3K0w/Nb/tTny0pdykkWXo8Prmmwx8YVmI0dDvzwWuUZ
	 CmuIf3KJsbN8mHpAU53cWTy1WVEgyhrsU2VeJtQ/+fwhW6bSPI/GtetqzoOCuqEyzT
	 9kAw3o0uXLdqeU3k8hu9+qSZhUat8YAr4I+/Zr17Ctrnm78JMwHvSosecb6qujzA2K
	 GgSHBJp2/3vm1UjMTwJ8gbq55YX5N4Ykw2B8L6cBHwIAgnY+L7L6WVx1+RFp0DL4gE
	 bybgl27AZtBRg==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e6391b114so179181385a.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:36:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrTujg9Cq5ynwZvIiTWizzdQjvsQEmwBNJdEKUdvuQcBrq3LnKM1D+SangsDrN+taktBOAmcHyNtg==@kvack.org
X-Gm-Message-State: AOJu0YxpEzWW3Mc//4WOxp6HRAeyG2KmICQiqMIW8pb0kJSIURcTxivx
	ZzoazXOsE4Reoa/rQpRQz/iG/+E93rmuD2xyMSVa//cPKPTzzjM43YS47sTka5mB483yRb8A2tk
	TrTuNQU92FpG021JhkPCJvcQ2u/O+V+A=
X-Received: by 2002:a05:620a:2847:b0:936:75ba:7c5a with SMTP id
 af79cd13be357-9371e6f65damr960131585a.31.1787225813422; Thu, 20 Aug 2026
 04:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260818163221.589352-1-alex@ghiti.fr> <20260818163221.589352-3-alex@ghiti.fr>
In-Reply-To: <20260818163221.589352-3-alex@ghiti.fr>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 19:36:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com>
X-Gm-Features: AcwNN1Wdmpc747x_Oxp0xjcXXBYq4rS8x3lyA5XuxyF0aRDk0ej77W6gNxw8_XQ
Message-ID: <CAGsJ_4zC+wAuevG+i5y23rLPGXn0P=D7JpMECnZ1OuP1BsyYkw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: swap: drop dropbehind swap cache folios on
 writeback completion
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21ED7A0004
X-Stat-Signature: w7m8m1cunffdq5d9y365wysohioih6d8
X-HE-Tag: 1787225814-283835
X-HE-Meta: U2FsdGVkX1/uJ0Cf6livY1pI8M93ylvLt6hZk0CIusEWQr0WBw2M4BVmOo6iZfbcsTa/loWTIZMcQnA2cscPn9qW7oh5oLC1lRQ+6nrGA4DsUjQ2xxtM60ZddUhRzfiY7qz2CPxOP35JrO3aF4xVJFu9L85GkfBbWfOAac0OG7iRC6NTbJSH6Fk5oUKlCt8YJavolsHyG5/BaCmBXsKaPF+owl14jd6ZE3Ksa6eUhjhENdFrEkZJ3cySeCJWQEsjdw1shfIVcaomZ6yaDyxLOHCV5Xj9bm2Q76VJ9yq+6QnHztuYuSq8TYZZUHruSg3cgeHcHUErg6vrqDGSIcoI/d20y4XlEDRGyNWkY6z0lQX8yacHwmNkUqChzP6ud3/0TKN6f8QL4l3dLrLlk71uLlecNHtkJOliq7RLTvctskIEK/UhzDUty5n+hjZkdO8YqCb9RE7I432kaX+8SxvO18AZGkfKC/7urI/5x6hSikCsutwo+e7nIks7TYfbxVfXZS0E0AZtcFUYIOJ0RtqLBdwVk9/1h8uRpverz6G5GTByaXGZH1JC3/X+/11e8885CReBfrAUpNzWVwSewL/21K1x+S3sfVz3pItAGe4N6nHdtLeZld1xxwzCYAGi+6lE+XGeKNQXc/CYP1Z8Vk3mOy/pNd1896DmI+wv8Vh729fE1GEcdNDZHkFfGmRBwJIKmWo85ukVDcIeZhPLzZ4yOPxMC/LvhiIkSJo0JjJsqt1or3qqgcVYSgS3xgFIBlEN3kFGDrknb6io5NEDGl7hFi08dmmLm7O7OTg9i0kv6F9aymZOVD3KY2HL0hw95nycdceA5lz7pJzwcdWhwR1+0BHs2FRvZiPPFzeLkdXPd5dbgEoEUYb/Z0VYp9U/50RLIxidtEreuE/SSRNm6Y16zqL2VGMueJWTvcmnVTtM1VHqFsh7OTqioyMxQsWOFmzh/zfTWd8kKXwV1Kie59u
 qiAN5jZX
 UFa/H2KcAVYxwTKhBbzcIiArUD4XCEZX3fJOqus9mQymXVQ8Zj7HLULI2y1EgUkETnfcs9axzXPwOpTDP6lAAMAmmlg7jTFeWMAMnQI7ivtjVP7NpwQyn8odPycpyMmc3cGIfIcRwKvq9ORUxAWOzX/mKbJOnGFqFi6zI+doiRwTyInvW/saLAXgSskb/gIiO0RG3BTnMtCUsyPqqmpfkVOOdo0CJiFU5NuMrI0HBcBsMjRwss1fiIH53JhBRw7n4UBJf3ye9tcWX6nIrdBqoPLz2zzFh72ZOFHQACO3S1HtBRcj19ie18L0wULF7thYPdIzRZS5lL/Zpg08HN6c++8PS6PbHlFr83BKezJUFWYUcCRxV70ZyWd0Sr3VaUi8iiHNY69QrffPnyxRH3DecEirvj6M8+QwKhIPy5vX8i9q/HHtn3Hy9UbQP2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 12:34=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
>
> A PG_dropbehind folio is dropped from its cache once writeback completes
> rather than left for reclaim to find later; this is implemented for file
> folios in folio_end_dropbehind(). Extend it to swap cache folios.
>
> The drop needs the folio and swap cluster locks and may sleep, but
> writeback can complete in interrupt context, so defer the work to a
> workqueue that runs once writeback has completed and frees the folios in
> batches.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
[...]
>
> +static DEFINE_PER_CPU(struct llist_head, swap_dropbehind_llist);
> +
> +static bool swap_dropbehind_drop_folio(struct folio *folio)
> +{
> +       struct mem_cgroup *memcg;
> +       bool dropped =3D false;
> +
> +       folio_lock(folio);
> +
> +       /* The folio was allocated off the LRU and nothing re-adds it her=
e. */
> +       VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);

Hi Alexandre,
Thanks very much for your patch!

I don't quite understand why we only support NON-LRU folios. Does this
restriction prevent potential optimizations for madv_pageout?

Also, zram might benefit from your patch in the future with
asynchronous hardware compression and software compression such as
kcompressd[1].

[1] https://lore.kernel.org/linux-mm/20250430082651.3152444-1-qun-wei.lin@m=
ediatek.com/

[...]
> +
> +/**
> + * swap_dropbehind_free_batch_folio - free a dropbehind swap cache folio=
 into a batch
> + * @folio: the off-LRU folio whose writeback has completed
> + * @fbatch: batch of folios to free, flushed when full
> + */
> +static void swap_dropbehind_free_batch_folio(struct folio *folio,
> +                                            struct folio_batch *fbatch)
> +{
> +       if (swap_dropbehind_drop_folio(folio) && !folio_batch_add(fbatch,=
 folio))
> +               folios_put(fbatch);
> +}
> +
> +static void swap_dropbehind_workfn(struct work_struct *work)
> +{
> +       struct folio_batch fbatch;
> +       struct llist_node *pos, *next;
> +       int cpu;
> +
> +       folio_batch_init(&fbatch);
> +       for_each_possible_cpu(cpu) {
> +               pos =3D llist_del_all(per_cpu_ptr(&swap_dropbehind_llist,=
 cpu));
> +               llist_for_each_safe(pos, next, pos) {
> +                       struct folio *folio =3D container_of((struct list=
_head *)pos,
> +                                                          struct folio, =
lru);
> +                       swap_dropbehind_free_batch_folio(folio, &fbatch);
> +               }
> +       }
> +       if (fbatch.nr)
> +               folios_put(&fbatch);
> +}
> +
> +static DECLARE_WORK(swap_dropbehind_work, swap_dropbehind_workfn);
> +static struct workqueue_struct *swap_dropbehind_wq;
> +
> +void swap_writeback_dropbehind_folio(struct folio *folio)
> +{
> +       llist_add((struct llist_node *)&folio->lru,
> +                 raw_cpu_ptr(&swap_dropbehind_llist));
> +       queue_work(swap_dropbehind_wq, &swap_dropbehind_work);
> +}
> +

This is good. For file dropbehind, I see both F2FS [1] and block
devices [2] reinventing workqueues in their own filesystems or
drivers, while folio_end_dropbehind() simply benefits from its safe,
sleepable context. This seems a bit odd.

So I'm really curious whether this could be extended to file-backed
folios as well, so that those filesystems and device drivers don't
have to deal with this themselves.

[1] https://lore.kernel.org/all/20260820071438.695893-1-qiwenjie@xiaomi.com=
/
[2] https://lore.kernel.org/all/20260730-blk-dontcache-v7-2-3e8e6850068d@co=
lumbia.edu/

Thanks
Barry

