Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE34C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EAEE6B008C; Thu, 10 Sep 2026 02:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C276B0092; Thu, 10 Sep 2026 02:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58DD36B0093; Thu, 10 Sep 2026 02:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300916B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:22:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B4FBA48D1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:22:42 +0000 (UTC)
X-FDA: 85196858964.28.F8CEE32
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf12.hostedemail.com (Postfix) with ESMTP id A7A0E40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:22:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="EYP/et+i";
	spf=pass (imf12.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789021360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXrMG36LL80IPDG1moLhJVFD+uNkGq7OI7LXnw5lOsI=;
	b=GhKyqoLXQM2D1ivzw8/xX2O6oVhISbvIK3PDvU+yPLfZyL3nEjMUuNpLSLev4aCaSBJlQ3
	Nke8hJqszProiuQcB+Goe+QEt3ytf9xyqu+5X1sC08HHJNeLc9A+JsdAHhQBZ7EoQCLiZ1
	7YZKfK5PK/Eh0A1+RQqYLI3QbObYA9E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789021360;
	b=at5SHmQ1wiZr4H8m+kNk7JnahTPGuO46PjhVWleNO4HC1P76xWW7/5RSEh8tPUlnHU+crf
	TbLtxIsOAN34Y3N/RiEhajRqbm66/Hj3mxU2BuVXZt+HOI255LYxwFMI9Nyp5QaPvmDZur
	0+OisNPcMFQQxzAuicecL8JdPjMNj5Y=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="EYP/et+i";
	spf=pass (imf12.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cfbdac7a1so3099385e9.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:22:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789021359; cv=none;
        d=google.com; s=arc-20260327;
        b=DlyrmpDN7B0GMs22GcSK+vifCI6rBoOb+1wlEhAosiQ+VDx7PL8slKVZ8QJgt4yqr4
         lkpNfyfkxrq3cpZOLi0M5IpEWnHpTtV/+CAVxB1vBk56SQPDK7yN8qu/EXfSmG777YEZ
         gNuGaEhmw9qWJ+rdY66bWmas2BPjuy4Wqzo4jD7htYImhDmfHn00v3WzYl3GtRk85Z4/
         VqKTQvF7CGHayRcdekDAPkCbtOvfDgy8vt42eKp4bdvJI6BbENAfQXF5gI6l2fhvMOBw
         4PRuKE9IUWP1lJMbpPKM4upuwS8MDvAfgC2rQDk4L+IUsQQd/yz8oG/ZoyIwRFqStcV+
         rjMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VXrMG36LL80IPDG1moLhJVFD+uNkGq7OI7LXnw5lOsI=;
        fh=pWCQN5fUkvxzVfcHTIQV6UazzFY3W0kS39b4eiIw3Zg=;
        b=Izjt7BtlAms7V24M+uyq80RjuHfyJJTTaFvfPcT0gGkKci+U6JkD+/lAP2+0k/KoGH
         yI/NOXaUWqLf37PnguyLYmnQQ1W9/4FUHuerjgvTDl2/+qettXhg4ew6Wo3MzA1v/CBH
         9x+Nmju9XCLUQO+WMJgq+uwMFq0oEtebkiVu1gDfvNsCNik6fGqDxzp0aCGJ4yCN3fs7
         zm9XQRKkPKsooG8DigOV7Dn7/TBwIzn7Hu+uGZUiLLpe1cit0MATPuztEtmrfxLZA/Gq
         e5JZIBvTvSCbEfCEpNGRy+WD6ItNKmYLNZoGBBUlz7WBLnf01pV82NN2ZzPJmNtwiQzn
         irHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789021359; x=1789626159; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VXrMG36LL80IPDG1moLhJVFD+uNkGq7OI7LXnw5lOsI=;
        b=EYP/et+i7sjdAd6yF2tbEV8yDrXKCmx0vXaBa273l5hQT6wo7aooAgopkP5+4TDWUw
         IH6K7cIGtRkulFIVCRg2zAN4FFRRImo4pMrfWDUrDsl8GyzvsGn4fsE2N4OlIXzBK3BL
         5Q5r+Td1+H3nxoWwwfqSD9uJgIcFOR//aGwR1qiKGMQA3tnhLZ9BljKoPvrDjdCGfHR0
         S9GehGUaFSoOXFFmSOO+He2/Fb+FoeGAPXGMMcLZOQE6QsFZSLOnxjfx+Eb942O1A1D8
         dLIeaADWe1WnPIBx/cdVJk0wHAL8FrQIju1toN7mCbUZ2Dl0d4uv3vL0KthzL65rkCEj
         ieMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789021359; x=1789626159;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VXrMG36LL80IPDG1moLhJVFD+uNkGq7OI7LXnw5lOsI=;
        b=KRn1+Iql0Q/XLwpDXwcDyRmj6EEJZ+7nFr8Nax1Szwjl8Ekdhfp13Vuhd0qI0O7eob
         mcmumRaznKAT8GffIR+0tGbWplpPPR7TLQSifEa8fr7AORQpgQr9SN3vYPD3zt7VaW8K
         6IivZZCXauFPjve9PF8IdPJEEnq2RF+c9EUKr1ET8AKgd/yzRE2Pl74WDUHfDvnV6ejy
         ajjmq/omLWDKkAvejYWYUkNcEdVUfu0Pok8nBvjVlaszJ2QOV+nPVIDVtKZF538KaVwv
         Gw66+O/Mh891n1S/oM6nTJZGhKkYKThNSf3v8TnyM95Hl+4vNmmH6rxt4/EPJfb7cteJ
         8Qiw==
X-Forwarded-Encrypted: i=1; AKwUvByPX0+gOuIJ8z8WpBLD7mPrhI09afaOpvZudRUhw7e2Fpmw9bHkWPj+Xe6I5XVQ0VBVe5TaAThXzA==@kvack.org
X-Gm-Message-State: AFuF++kz1LKsZdF2WAC3lX2l+czIis+OhMavuGT1wJtnyuY7x7afDyxC
	MlHtmWuowuUYMbQiiRyiOkq13I0eh+ODRHmhRsP0FFCcl56xjnZM7KavvCr5U0OmTgJKPSAYRgp
	pD3ZX7sVdgiFdawJjImDdHfsPUKf1aZ8=
X-Gm-Gg: AYBFou2hoylpGUfKrLZsArZ1N2LJft52Dl9u8uyks9Ma+mLq37MtJPRSRRjEEn4dNtE
	SRKndgsOhfUfn3yeNhqrudDdaa7Gx4qGT8rdO4tyY1/hLdfC0evtGDiDUEuOuEdpZyP0VryB87l
	jwiYtNq7NMWupdH9QACeb3azFkK+AnvT7U2QN0LQWaIzX08LDPGaQMCxMHl26OG9TFnmgnEP88i
	Tyrkjd/RVD9pCKaZFTicjCcSjRBSzWPR1ifNbikHmwXg4Jfi/dDMOJVE6TD6wJcBs8dJ6vIzvkI
	zioMa8MBOiqP4BYZ5ZlkQDGmWoXVJyB693deP7VTl8ryiNKNIVTWG5Q4JAwv0H1VdLxuOgq7aEj
	pH3u92y09NU2DRhUhPHCFVjPxozibhZtJF4VYTclr
X-Received: by 2002:a05:600c:c48f:b0:49b:9241:7ff0 with SMTP id
 5b1f17b1804b1-49d010c4f64mr283813775e9.0.1789021358682; Wed, 09 Sep 2026
 23:22:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <1d5ac9d7-48ce-4fee-b893-f646bade4a86@kernel.org>
 <CA+qSx6yjiXJkQm=hi=F8=_=DU0x_usSuXnL_1yuy0fUU9UU-Zg@mail.gmail.com> <d3723be0-46f4-4025-b526-e1bb3cc2cad6@kernel.org>
In-Reply-To: <d3723be0-46f4-4025-b526-e1bb3cc2cad6@kernel.org>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Thu, 10 Sep 2026 14:22:25 +0800
X-Gm-Features: AcwNN1UCOqtjDA1IEA-_iwUx-h9ia6X61kVWP5KJZ4OCo5OwMJqwEZfSFHyzJMA
Message-ID: <CA+qSx6x2-Md9uVZo+HV0z5CfmGPDzhL482eJNnM2VYVtn_e72w@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, rppt@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7A0E40006
X-Stat-Signature: 7y6oazi6h4dn3fx984yapmoksfyx9r3s
X-Rspam-User: 
X-HE-Tag: 1789021360-461732
X-HE-Meta: U2FsdGVkX1/H70W/x7o1RDOik3Y04SHwBr5Z71vZsHT6jHXavw7cf9Bw7mOqjxJmsIv9nb6fmMv7VODp38tKjouPXKUYVp+h0sLEQUybUSma1L0y/ks32PNI8n0MD+kJCQUH8RwA/QSZ+TZDzeI9YiQ6NzUq/183g82KFxiCfTFm8ZL5vK3VOhQChDAYW/s3Hbm/v4CTddb4cX4YcDASZyuSXeE2IBTQKoVmjJqJsTouerTggbk3Sd9RNzPvXwlBEMhUcj26jHuGk9o63Cmoiqpgtx6pXrZxescDKkH7vPh8eBz1/wGaqypAs6GwzuX8cUtFgHzqf+axRHMAbOXx2GuJslNlDsvY7O6YX9AWdXqfU3gtGhgCGlgBxHhhwGqF8gRQJERANhytNrl3fRzJDZh5Pid8YCTKaLotSMdlZ2rasLUW96d+as533tFbbpGbhx4+/aGejoSGb5OrgICWDHUgjor6ArQ+A8ROZ7zHuxsqh7AKafx8WbjgDyGAUIKRQNhspn/9UYzHf/U8hoR7+0Q0Ma6kjDEW/McSjBKyKLL3yVhgNh4qSAj928ZyjPiwZJL9RNvlxZh49milBSzsJ16NB8upfc/in/kJQiVtffYD03iyKoI7KBbiuM3jXOpRHLlp4zv5nN+yzweg8o2qD35ZPOYGghMFm5nD/swnsy7NSaF4iPyaN4kUW9lApomQem5PN62h1YtHM36RVUeztLTItoEg/ZDCxYx9id3XmFFdwCxE7lnQNOhzGpW4Sc9JijddHEfjUq+HWeZ74yf5+5UNNpVefyk9jlV32ySI81hvfxmtz6tLoAc3VaQaNJqR06As2l4H+MFqFa/L5LS+U2f31fsy7A39tqrX/54pNEu96Wdn5/cH5kK6KjIgxSIdlhYOjtv0aRIlX0jJYOgPo864Mk6Ti4coE4juXpD1SL70o2biQm1fbpZfwKDCwY2997WsM+QvP62lBLCwTxh
 05AkvS4K
 kc0hc8VoJG2N2reMk68WoqaNGC5bzdKz8opX+cm1P3WbRESRB+pEvs9CrBqYRVa5hf9LDsuDtODZZtaj2wmMa6ZRvjiG6Gu13HUkaOtsmIvBR5CtR5riBsTO2Gh3bpnzYMSULpIIG4HZnCiCfgiDJMFuM9Jkeff6QNUijJ0bhWl7sABqWNkzqAPmd0BwI5TDnFpYess60ueiTETJLXTMbwaVEW+V+sLAr8AnNk9bFY7qE56Ucn7j0+JXFVha47pf0QgpFHcvZyEzotmWThkl05uyYJFnS+eDWCuQQuMnZl/lkVspukOOOuAwE91EzbXpI5FLAdZwZgmrNt8IuBRN9owodO0140oxWFsFWfK7R+GswME4zDsA3HO/bM9syjthqAg2fyaOjRUTfS+ji4j0cjgLCHJTq+6oSWfK9N7uLq80gAjI35mjDSJhlX5Zp4uZrnD/BzcOO881KH8sHECeH2RWMTWUwkajUJJxQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 11:18=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/8/26 16:48, Xueyuan Chen wrote:
> > On Tue, Sep 8, 2026 at 4:30=E2=80=AFPM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 9/1/26 17:18, Xueyuan Chen wrote:
> >>> The persistent huge zero folio is shared globally and should stay zer=
o
> >>> after initialization. As Jann Horn pointed out [1], kernel bugs have
> >>> ended up writing to pages that were meant to be read-only, including =
in
> >>> security-sensitive cases. Making the folio read-only in the direct ma=
p
> >>> turns such writes into faults instead of silent zero-page corruption.
> >>>
> >>> Add a page-based helper consistent with the existing direct-map inter=
faces.
> >>> Handle TLB invalidation in the architecture implementation; unsupport=
ed
> >>> architectures retain their current behavior.
> >>>
> >>> Protect the folio after initialization. Skip highmem folios, which ha=
ve no
> >>> permanent direct-map mapping.
> >>>
> >>> Inspired by Jann Horn's read-only zero page work [1] and follow-up
> >>> discussion [3] with Yang Shi.
> >>>
> >>> Link: https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b4=
9@google.com [1]
> >>> Link: https://lore.kernel.org/r/0e5b23a6-4895-454a-9dfa-6dc21adc2991@=
kernel.org [2]
> >>> Link: https://lore.kernel.org/r/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=3DjDx9E6=
dLOULohnhBguvi9A@mail.gmail.com [3]
> >>>
> >>> Suggested-by: David Hildenbrand <david@kernel.org>
> >>> Suggested-by: Usama Arif <usama.arif@linux.dev>
> >>> Co-developed-by: Lance Yang <lance.yang@linux.dev>
> >>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> >>> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> >>> ---
> >>>  include/linux/set_memory.h | 17 +++++++++++++++++
> >>>  mm/huge_memory.c           | 13 ++++++++++---
> >>>  2 files changed, 27 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> >>> index 3fe293cfed8c..ed9ce04b18a1 100644
> >>> --- a/include/linux/set_memory.h
> >>> +++ b/include/linux/set_memory.h
> >>> @@ -54,6 +54,23 @@ static inline bool can_set_direct_map(void)
> >>>  #endif
> >>>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> >>>
> >>> +#ifndef set_direct_map_ro
> >>> +/**
> >>> + * set_direct_map_ro - make a direct-map range read-only
> >>> + * @page: first page in the direct-map range
> >>> + * @nr: number of pages in the range
> >>> + *
> >>> + * Make the direct-map range starting at @page read-only and invalid=
ate stale
> >>> + * writable translations before returning.
> >>> + *
> >>> + * Return: 0 on success, or a negative error code on failure.
> >>> + */
> >>> +static inline int set_direct_map_ro(struct page *page, unsigned int =
nr)
> >>> +{
> >>> +     return 0;
> >>> +}
> >>> +#endif
> >>> +
> >>>  #ifdef CONFIG_X86_64
> >>>  int set_mce_nospec(unsigned long pfn);
> >>>  int clear_mce_nospec(unsigned long pfn);
> >>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>> index 54494c3fa983..742283b36d74 100644
> >>> --- a/mm/huge_memory.c
> >>> +++ b/mm/huge_memory.c
> >>> @@ -42,6 +42,7 @@
> >>>  #include <linux/pgalloc_tag.h>
> >>>  #include <linux/pagewalk.h>
> >>>  #include <linux/cleanup.h>
> >>> +#include <linux/set_memory.h>
> >>>
> >>>  #include <asm/tlb.h>
> >>>  #include "internal.h"
> >>> @@ -291,10 +292,16 @@ static int __init huge_zero_init(void)
> >>>       huge_zero_folio =3D alloc_huge_zero_folio();
> >>>       if (!huge_zero_folio) {
> >>>               pr_warn("Allocating persistent huge zero folio failed\n=
");
> >>> -     } else {
> >>> -             huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> >>> -             count_vm_event(THP_ZERO_PAGE_ALLOC);
> >>> +             return 0;
> >>>       }
> >>> +
> >>> +     huge_zero_pfn =3D folio_pfn(huge_zero_folio);
> >>> +     count_vm_event(THP_ZERO_PAGE_ALLOC);
> >>> +
> >>> +     /* Highmem folios have no permanent direct-map mapping to prote=
ct. */
> >>> +     if (!folio_test_highmem(huge_zero_folio))
> >>> +             set_direct_map_ro(folio_page(huge_zero_folio, 0), HPAGE=
_PMD_NR);
> >>
> >> Assuming we keep the page-based approach, can't we just move the highm=
em test in
> >> there?
> >
> > Hi David,
> >
> > We can move the check into set_direct_map_ro(). However, on x86,
> > set_direct_map_invalid_noflush() and set_direct_map_default_noflush()
> > also expect callers to exclude highmem pages.
> >
> > Would it make sense to make highmem a documented no-op for those
> > helpers as well, so the direct-map APIs handle it consistently?
>
> I think getting something consistent for now is the most important thing.=
 :)
>
Hi David,

OK, I'll move the highmem check into set_direct_map_ro().

Should I also update the x86 set_direct_map_invalid_noflush() and
set_direct_map_default_noflush() helpers in this series to skip
highmem pages?

Thanks,
Xueyuan
> --
> Cheers,
>
> David

