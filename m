Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3546CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3964F8E011D; Tue,  4 Nov 2025 04:15:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DD38E0118; Tue,  4 Nov 2025 04:15:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283C08E011D; Tue,  4 Nov 2025 04:15:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 138728E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:15:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B78858FE6
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:15:12 +0000 (UTC)
X-FDA: 84072365664.05.371DAC6
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7B698A0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:15:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b6rwVpH7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762247710; a=rsa-sha256;
	cv=none;
	b=soPGMOxmDthV+Ifu216AiEPZd/7kDtcRuNocwuQYHkWRGeFxzYK3P1uRpurcNcJzqynjtJ
	fC/rsQ1HJPvFPiqzKlRpWBfDrsYSc4GAwHou/tu89uZqP0jSfAk7Yq0za7v5bUpBrLkzya
	Hq9f7wxc1xVVYUpJH/7G8Se2rc4Sbug=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b6rwVpH7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762247710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7o3OoWVf3VwmhIykzAVGSS+Z6xkTROuk1L23o0STyY=;
	b=O1h29/uyvR78kUd/bQIprrfJeva9JuBngOu1nFot+Io2/NQocS3Ei0emdjzSgkkiZtSPIN
	NJ/YDObrmxb8NC0nWZ1ilqG5oYcYeN22WjAEBAat02OD2S7/iQN0uqJJ0MrFXa75mPhOiv
	lFOC2A7lgjF26rSdW4qns17VZWiH7dw=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-81efcad9c90so62253496d6.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 01:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762247710; x=1762852510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7o3OoWVf3VwmhIykzAVGSS+Z6xkTROuk1L23o0STyY=;
        b=b6rwVpH7+p1Pt/GRb7jmTzHK4wawEvbPELUnEjciV1dbbNnZtIGYsnSBoieaJg96uD
         HSaocNWsQpiXiDpD7hfy1gkK5g3FXjq4W0g6zp8am2mBvyt4WyimW08KBb1PxogEeMqR
         E5K+pU5zizyu7ap23xYw9jHRF/vypO9ZsuIPHwe1sIi9CWyxkqzeyEzClrVfxb8bZfP1
         gaOiBku3mp9wfYYi9n5QYVB1QY7OuV1WeGzZMqTKYgCx+nPhUEde3OG5fCakU1VGX16/
         DmSO5Pf/VEX0hEjDzT14JkafgCwbQSjqREZAvvK6d2uE2bv7ki5U9YBtJTQldRoh3ySM
         IlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762247710; x=1762852510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7o3OoWVf3VwmhIykzAVGSS+Z6xkTROuk1L23o0STyY=;
        b=EDeJY7UUg+T2KuS+mLbK8KB9DFrFYnhc7KvIeX/SjU/pTUvwdlEI1cM3GAW+6qyIeV
         psMxK2nBsuYfQOqtkhZlpBOhnDX9rEyVKUbfeQ4BeVXpf/cayz+0opZBX2bzjt109uJ0
         vDAsfgSaDacP7Yi/11kTYNCXDlaHPfsM7qjE1kRGT+UGERcnSx4pqLMXr+5poaM0Hv8w
         EKvuPsJbkp41f66ZQxjZl6C9/T5QRTLN1McmsBZ/4wNYNxMExcJPPGMGEa1u4UjGosYs
         bd0fqrigi9yiz4yQmo/s6nQt+1OBFv45f1Emsi1f2TFfWPluo0dESHoOARx/f4NDYjGu
         19UQ==
X-Gm-Message-State: AOJu0Yx1dLTloh8V/qbHvk/dV8D+t9ce19ewh9M127WLjYVzwsdCspS4
	VYrmmI7BbLEQ9AZlLqLLx9d+BymNK27BQsPt4XpotJ7K0Pv64VMMcBAss50ZdfvOj0jKPcACYl6
	7w0cJPr1NGAbhG4MgrzG3JEBZY9carffMShtx
X-Gm-Gg: ASbGncta33B/qKn65t8+GnQWhpkGzwe6tEiUCrACVbeRYEzK275oTniL49V6uhdtKOF
	2GldtEnJIHoLvXDSqs3bRqOqMyotw8aIjDyndodwWGrHuK4xFY/9UhwLRf+g0zNVXHTkp/SGNz0
	paqi7LlF21b9sbY7GTEtDdV20PffeaCPRXIYKNMF6WGasKSj/gvl/ttQWjicWITXimTRc/BUJco
	46wSnFIv5nnEsebIPk3WxR0fWHRGI7QgV9FmwkrP+QpFKcMMAQM4MV8UPfAn/9+QLsl+vFu8gWa
	A1tq8WghiGfWav6/WSPBoOkBrNM=
X-Google-Smtp-Source: AGHT+IHdxvd6RkK9PSEXxbjF2WAu6QKHnoL49XnAdQLn9meZGPGDr1UTcOTG4ZvbS/kJNMhGKSxyiXfzIeif8M0V8so=
X-Received: by 2002:a05:6214:268d:b0:880:627c:fe12 with SMTP id
 6a1803df08f44-880627d093emr27581196d6.4.1762247709375; Tue, 04 Nov 2025
 01:15:09 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com> <20251029-swap-table-p2-v1-6-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-6-3d43f3b6ec32@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 4 Nov 2025 17:14:58 +0800
X-Gm-Features: AWmQ_blp6dnewniw6fnHSgucGMfj2_C3pvALLTtnVEZclPTP67n_dTPWemRXR3c
Message-ID: <CAGsJ_4z1gB8x7GNUL4THdC7G9ZGMqbM3UtWM2LXPoT0xcLAQ3A@mail.gmail.com>
Subject: Re: [PATCH 06/19] mm, swap: free the swap cache after folio is mapped
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7B698A0002
X-Stat-Signature: xnzx51wdrwjazwagd6yicrnoo1no4zeq
X-Rspam-User: 
X-HE-Tag: 1762247710-601842
X-HE-Meta: U2FsdGVkX1+/J1GRIHNgcbmh1GrsoKRjwy71bCgnmGTSOii+Vphb3SBtyYryhrEQK2dJPI8ruWdhxCC14iagbx8d6cMyiKQRrqkHxJXKmqewt2vQwAKIWIoHvrgQsgzJTMpgV13Uf18ReZN+1JMoprrLj7PaK3SqyehQ06CQbY57C8t4pRu6DoTcomP1Gb68GUkKWP6w/kCQjDcq3FI2w4djOlMHYi/jI/JopWTwmTGDz1LzpseuS6P6wbsS7FhUGm95BxbTjs1HE2bwFJWKrsl5cBenTAjIDZni1SQMRonjqRO4a1F0y4mfteBn3NaY7lmu3Sya3L6SyAdMbPOEtPlY8g932XOzQ1cvS6aVhw4sxyEJL0Riw0gn68o2tRL21IRf+W4SfbuzqRSShXi0hZbiBMEnghB7LVcAHbNUVZhN+BNgjXww1a9bbY6c/ZVzhaQFp/xqlFkjqj/OCo5S1dzNm//VOm5X8XP3CxcldDelndJCKKDJSATMlHkKccKYpbo6BfQumiT9pDoWzkNc65P1ttaljTig1HK7DUPi6wjpwFMHwtWhrqTNN7e0GyNvjvaWpLD9pT6tqIPJN2hT3JVrhxTK5Y4/jBZ0NBmf+VYL/jIh+pXzxlxAeBMvmQMrFJfc9hB636KKcaTstklTz/SfmIobNMNJzigWpc9udfaULiGjBpNRwnOXZjRMN3OUzo48TIYFx8+J9edKzwgtYZZ8iEBhBIPiYxlZ+ABgpy8f7qOMATwN+0928ogoCu3/8xqbiZAQHrgDk7gm1Cf9JrXzkktl5at3VK1XsIg/lx/Su+F/vZKPZ8WRJfigVkLUIyYB/mYrCOCZFsiqsodj0bgCnwKJ1Z0dcCbcghHMgfx1cGp7wO7JN9zFEKynrTTw/WrTBjrrrLontYLjoHaf1nItuTa0QovQwcp90L+TLWjHA0yIVKKyjFViBhJ1jtRLzWm7qNnQylC6PiXCET/
 dKOPkNHa
 iBrbAlC6lRoJTUnaaQHbIrC2oFudupVr19P33K1wLut2dO0/m9UTL0q/ZvADNEBodNdxaaB/YO6tirpgdVHfc41iy72yY/iCj38vqLbTMwkM1UYzDqdyXfN1k581yw1y6FDeghqGr4ZsYbRccY/ki9WVmSYsaSiaqm78mKB7rJgCylZWtZfMLAQjv1p1hVzJF2gziprBqPrRzqm0FAfT3dtZcqCq7621nIMgGcjLAkFcs437nwp13i8O7dh2Jkc9cK9YMF0j589XlokH0LKoheu6XuLhjmI/UAb0mUWR4a72HFE02UniMc5M3P4VlAJxAtvc67cWRWaO5J8OoIKduQxB9rXJ7kmMLm9MK+6JBQ83X+S2J2jlZEhwdBgRYZXu+p+/Ix2trhjDsxxUNr7VrmcO78g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> To prevent repeated faults of parallel swapin of the same PTE, remove
> the folio from the swap cache after the folio is mapped. So any user
> faulting from the swap PTE should see the folio in the swap cache and
> wait on it.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 6c5cd86c4a66..589d6fc3d424 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusive_entry(str=
uct vm_fault *vmf)
>  static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>                                            struct folio *folio,
>                                            struct vm_area_struct *vma,
> +                                          unsigned int extra_refs,
>                                            unsigned int fault_flags)
>  {
>         if (!folio_test_swapcache(folio))
> @@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_swap(struct s=
wap_info_struct *si,
>          * reference only in case it's likely that we'll be the exclusive=
 user.
>          */
>         return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio)=
 &&
> -               folio_ref_count(folio) =3D=3D (1 + folio_nr_pages(folio))=
;
> +               folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_page=
s(folio));
>  }
>
>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
> @@ -4935,15 +4936,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>          */
>         arch_swap_restore(folio_swap(entry, folio), folio);
>
> -       /*
> -        * Remove the swap entry and conditionally try to free up the swa=
pcache.
> -        * We're already holding a reference on the page but haven't mapp=
ed it
> -        * yet.
> -        */
> -       swap_free_nr(entry, nr_pages);
> -       if (should_try_to_free_swap(si, folio, vma, vmf->flags))
> -               folio_free_swap(folio);
> -
>         add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
>         add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
>         pte =3D mk_pte(page, vma->vm_page_prot);
> @@ -4997,6 +4989,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         arch_do_swap_page_nr(vma->vm_mm, vma, address,
>                         pte, pte, nr_pages);
>
> +       /*
> +        * Remove the swap entry and conditionally try to free up the
> +        * swapcache. Do it after mapping so any raced page fault will
> +        * see the folio in swap cache and wait for us.

This seems like the right optimization=E2=80=94it reduces the race window w=
here we might
allocate a folio, perform the read, and then attempt to map it, only
to find after
taking the PTL that the PTE has already changed.

Although I am not entirely sure that =E2=80=9Cany raced page fault will see=
 the folio in
swapcache,=E2=80=9D it seems there could still be cases where a fault occur=
s after
folio_free_swap(), and thus can=E2=80=99t see the swapcache entry.

T1:
swap in PF, allocate and add swapcache, map PTE, delete swapcache

T2:
swap in PF before PTE is changed;
...........................................................;
check swapcache after T1 deletes swapcache -> no swapcache found.


> +        */
> +       swap_free_nr(entry, nr_pages);
> +       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags)=
)
> +               folio_free_swap(folio);
> +
>         folio_unlock(folio);
>         if (unlikely(folio !=3D swapcache)) {
>                 /*
>
> --
> 2.51.1
>

Thanks
Barry

