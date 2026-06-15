Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24011CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 00:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6985C6B008C; Sun, 14 Jun 2026 20:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6490F6B0092; Sun, 14 Jun 2026 20:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5384D6B0093; Sun, 14 Jun 2026 20:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 401E96B008C
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 20:17:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF325166058
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:17:07 +0000 (UTC)
X-FDA: 84880232094.21.2E726EE
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id BCA7F1A0008
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:17:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DtJ84Zgu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781482625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awOdsbsIEZc57bkKzdkPUZvahTMIYcJWaYYTCMIQHTU=;
	b=yVgA4EiZxKjii+rsHxOQfz4/bvLXnaNdJNoXvf5ddghsB8xTuB/Z1oLCVSXD3Fxhynzg7l
	8MYU/cl+Ej3EzFkBZLbI+VX/pBWL+yzISWqi9ZoywAiAztBQ1DyZVBDzBepgF22ssZJBbI
	ZlA3DJZ3Lus8DwObAjq5F5J9rdm1jNk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DtJ84Zgu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781482625;
	b=yndp31Qqvn7co/wm+ILPXPf+C+pZp5oX4M+4B3HXWPC1EBJYdXOSPAfAIznhJ+pplJltS1
	SJVthh4gtMk11SnnXlsZT4A/vQnxEHAZRo4E/T8gM8Cu3KNXXLnvlJTNMDeo79tcd4Y+Wa
	YYEz9WzSVSJC/5JyI/94n6r48mDxhcA=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891b4934ffso72935e9.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 17:17:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781482624; cv=none;
        d=google.com; s=arc-20240605;
        b=bKlkuCbj1NCi6VYUGhIi1tKHl0RBn6cC6yzNZwW5pfkyKc8tryoFxUF5qYUnp4sRLo
         BaH8uQ+K60gqOk1kX69Hnhqc9Z6ARRvqUvO+5+Xq8WpyWPMJzZtTYfokLwaF8k71obmx
         mbt/+O3JkEP6MInJSNzmkF1TuvnHaZ/Y15RX7WdsrpNj9aUkYLOQmI8plvx4XOYc85mX
         v8plMC8HILGBROVxLvUFoAezUJaHcqTwnr7LHUsduaRl3Oqw/dPQZ0l3QJS7Ly4JuxcJ
         Pa5MqJO6RWSqoR5vhCYdAYYcEe6SYpfGpLdGZL4rw1ZuNEGMAVJRrRiQ2sBrS5hPTNMl
         IPqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=awOdsbsIEZc57bkKzdkPUZvahTMIYcJWaYYTCMIQHTU=;
        fh=G24FSzBM2n7EX5quxe795aaRNl+BFD0Vq8ahxhoA3WI=;
        b=CN/dlBmBBjkcMY4Lgz0P3m9wlzoGilo1FDfcNAs9z3JojCoIDCoyaB8e4G0j+gZAb7
         /Hc9ke6ClvjeDZOA7AdDpz+dzUPBBLQB5tNLG+Hhe4vtvqUGBSV84bsLgj2zWQ7bEEZV
         17EVK2WABKcSeQ7UbgLBl0iePSVTKgqF77+990IJ2KKTvdJzCQY12m+qNHMcgEleYXI4
         /gmsTbi6M+p1vuxtnQkhLaIjLdpd43WKc0EtYWehefDgTRSrzrnlOx/8oMbGS1WFkf05
         8vF9cfLkj2Jojovqys8HKu4hqQy54YwQ4CCdZ1qrBwbtVciSDkQcqvOIvRphbzDSXKpu
         F+4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781482624; x=1782087424; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=awOdsbsIEZc57bkKzdkPUZvahTMIYcJWaYYTCMIQHTU=;
        b=DtJ84Zgu6i2FIgdIklsFjQoCDKxQ4+eEnfUgzm1qJFs6a235R/exGsO0Ipm+6+1+LJ
         jtnqzaOM/P/EEHYvAajHk+89Yqepw7R0k7Wlj5WUZhWhC5bdxcBhPiNDRIRRehfhz2Lc
         Gy+d7YA4VhzBRe4nLAMv/rhO2+V3rGqaB+hr/hh15jaGAEvLH8T18Kg6fvAu1gYgNVEI
         YTpjaycuNAdum4h4xWj+uYpcbP2fhIMs3NfiI1mRYDEV0B9keDRGoum8nAv9fSWhzlUU
         PcftiucsIbyUSoDAtbvj+Kc/whWQlCWOAE5A6mh1axPsEMezHpdRdwuKCblvGyUYpSsI
         a5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781482624; x=1782087424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=awOdsbsIEZc57bkKzdkPUZvahTMIYcJWaYYTCMIQHTU=;
        b=leD4bEtQSQf8ZsJVKZeat18z6o6Wdl/ImfgIqibGv0dqtiQNCJThexxRXNIbf23Qzr
         0rqgzd1RdAABy520Nu9ZSshVNparM3B4JCCzhV93oxAp7vefgLNVgkIUARbDxEfQ+eUp
         128jPhu0cIp5as5W8s8CKCBVsh8gGk2fSOnxbCq7eDywZeqNycY9AoFVIlHndWsSZq/K
         Farq7F5MmBQVuZs1jb+itMHMvUiHqgNfdg8UGghhhC0C34TQfvKyKPj+o1TzDdK8Vf32
         fZ3/TD8qN/odDvuGQrNNEKRgcaCX/IdjwFD1yi9RfzVRHzta7uB56c5cLFCxEjX3PLF+
         P1aw==
X-Forwarded-Encrypted: i=1; AFNElJ++8AX1HkbLc5sCSo5Phhn1dpJnwwF+IQbzX8+XceB+t9Qi+ihKKw/wHq9bg4UPiH7qqSbNGfOf6w==@kvack.org
X-Gm-Message-State: AOJu0YxBjXHuHXRGOyD05GMjeLW6a0gqa45PKYSzXDQxC/y/hzdojuNC
	yC9iLcnuYUz7ScbAjHDhtyincA1DBj8SNO70VJkvAzMWZWqWDgrMStpn174gNPhDHCbc9VXyB9m
	PI/cDZRefMdqRyM1AGK1PALciLRz4SHqq5eDJv4Gz
X-Gm-Gg: Acq92OEvKTjfuw0mdciPS237jX/XrawJfLkdFIZc6+zqfNPDeo65CWsoK2yjjCs3tZQ
	574kH56YyezBrF24JWSwoNq+9A6c/rFFZZXx+oNrRQUD25uaA1hIpMSfuJWVdIVaGsRlD8WaIsJ
	bZRYETNTOrfA5eIhfq3ZKO3kbaVz9r/vnmK6n5iII0c0wg0n0Z9eRfbHvSxN9VIhwFhnH8OCqLz
	qtE/yAB34sigpuuKuUK++8QnCT+VujqfpfgYLGw7ZlZBvtNYcTn+WkcQqrso8WHsye4Cr4LYcds
	lVoVj5uHTun0XxNANt1Xfdc6HJARGTKpvjizK1aUBPRWOrbkjw==
X-Received: by 2002:a05:600c:e556:20b0:490:c2b7:5550 with SMTP id
 5b1f17b1804b1-492207b5927mr1423665e9.12.1781482623757; Sun, 14 Jun 2026
 17:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-4-jiaqiyan@google.com>
 <d9621684-6300-457b-d0ad-9bbbdd576b9a@huawei.com>
In-Reply-To: <d9621684-6300-457b-d0ad-9bbbdd576b9a@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 14 Jun 2026 17:16:51 -0700
X-Gm-Features: AVVi8CewS_hGKjbD0JrY5YMrXaH9cHdz_Fj-2QDUaPh40lO0bphmLKfcvFkub8A
Message-ID: <CACw3F518+xY7xbkW+4QxQYyV_CfLnSS40u4J=2Px0qfDtk+YrA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] mm/memory-failure: skip take_page_off_buddy after
 dissolving HWPoison HugeTLB page
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org, 
	osalvador@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BCA7F1A0008
X-Stat-Signature: db7wrnfp5z4s7o96xxs4wapiqadc4jre
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781482625-534346
X-HE-Meta: U2FsdGVkX19GTZ7m/LGYNTOJjsTMtoXHukAqwznQR4ABAR6mLqiuWW4y30/dw+VcDqRavG7+xtka/qcmw71jjEtLRZs0CQ2tZM4V8HuZ5lcIjgJvTX7UjAefrEiwqceSRshSNvTKRhGQjE4/9Ql3oMHVJ0X/QUJzonUsEmiOoLv4b3pY7Rumi4Nxn93XIkeycUkB45ruNQqeeWpnxzPBCwLeViBrtSjZ6yb0BO9mWaTj0ToQRCO8WRs92fkGPxMKKcQfKLaUarvlGjEi3k9skBNTBEZYNu2O72hw9YkX5xU8HLYBREdt7ShcWp4Fc0OlswSzaad8fGagxU6GrfEYYJ+DE9E2zbT/6CMlBpodX0wVDDdbq/HRPt71bRtrBbbOXnFepnNBvNMztwYR3hwudo9PgEulTiuIjCPSp+rB+rRseOs9R99zGKQ3BNFsp1aWl3pJBOyclo3EaOrpPmUeenUr63Y3askbnwNfXVrk4r2+RAA2EOP5Cc5MuX2rqA5wTFCCmRVVoLT2OEWBD7Whd2DK30RziOxyjgOD+Rcv46DMgaDuVE20SSd1g8mPUx1QmAV6LXPt/OHH9G/B9hDeOfsQSWwiKn8Xb9/rDbHMaevAZseQYGeLxmatGcZPo53gE2ueQ2G8yw9mo/VLvjmeC/En/3whhBpc/KDvCLqVLdQjhdDzqTysMX6E8IcI5LvSnijQ6H+/utF8bMhkXfHLLGwXajCm3c5AuhJHwQo/D7W0eogbyKoaVuKLvR1L4JrD8db+jj3OjRGFrWoaNqXk0XWZQiQXtall6GUwTFuGFoMqA7LRmqpeA+vjzUPnV8sj+SdTA+E+LoMwIp43xWZyF2M06vfeAH+9/Ibrp/N4USdMZWj2b+y41vauy1XQVUiT70929Gk7c93vrju/YuHfIDC7XLKPPbpM4C/rGJ1ZnrXBsVDj4Idcxm3VRe6jSPuZSqTnQVlRCTMJhprm8fn
 z7rfWdZ9
 /6P632Q2gNHCg55vZ/4TAtD98u7albItQ4V8SjJ3ONSJTIJJoHpGw5Gr3mwJpKaBMTt2s8zBM/Fxn20V4XNODQC88IQ+HjeDuazsVNWq2ee38sCKt8DGHReSB2R6HeQl0yjYGTSQHCO7GkW2EPMDn7lD7Uo9QtBkosqj7qfa4cVnuXbSL+EzAybn5PG3bJXjUqwPB6T8zvjCeCdTagTGF15TxNrZkL7iY9ez0ilyfrKtnGyC78bZkLBczm5ATD7ebYa7K7e2tm2yraoC6ZKpcrTd77hmSpe3QzH7iMiKTwwEFQ/tfymfAVPdXnSD6FzcPD2h/wHzzB0PagICOBujXUK1KlrB5bXLcvtP2yvcczoCz7PUsSR2MO6+RDjJyfwqwVeOEfpxsf4FPXZwu7dLtn6OdHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 12:21=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> w=
rote:
>
> On 2026/5/31 13:58, Jiaqi Yan wrote:
> > Now that HWPoison subpage(s) within HugeTLB page will be rejected by
> > buddy allocator during dissolve_free_hugetlb_folio(), there is no
> > need to drain_all_pages() and take_page_off_buddy() anymore. In fact,
> > calling take_page_off_buddy() after dissolve_free_hugetlb_folio()
> > succeeded returns false, making caller think __page_handle_poison()
> > failed.
> >
> > Add __hugepage_handle_poison() and replace __page_handle_poison() at
> > HugeTLB specific call sites. The being handled HugeTLB page either
> > is free at the moment of try_memory_failure_hugetlb(), or becomes
> > free at the moment of me_huge_page().
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  mm/memory-failure.c | 36 ++++++++++++++++++++++++++++++------
> >  1 file changed, 30 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 95979b7995c1..098c4407e818 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -163,6 +163,30 @@ static struct rb_root_cached pfn_space_itree =3D R=
B_ROOT_CACHED;
> >  static DEFINE_MUTEX(pfn_space_lock);
> >
> >  /*
> > + * Only for a HugeTLB page being handled by memory_failure(). The key
> > + * difference to soft_offline() is that, no HWPoison subpage will make
> > + * into buddy allocator after a successful dissolve_free_hugetlb_folio=
(),
> > + * so take_page_off_buddy() is unnecessary.
> > + */
> > +static int __hugepage_handle_poison(struct page *page)
> > +{
> > +     struct folio *folio =3D page_folio(page);
> > +
> > +     VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
> > +
> > +     /*
> > +      * Can't use dissolve_free_hugetlb_folio() without a reliable
> > +      * raw_hwp_list telling which subpage is HWPoison.
>
> This reminds me that hugetlb_raw_hwp_unreliable folios can be freed into =
buddy yet?
> Should we handle them too?

I think we can (very likely already?) handle such
hugetlb_raw_hwp_unreliable folios by "leaking" them: neither freeing
them to the buddy allocator nor allocating them in
dequeue_hugetlb_folio_node_exact().

>
> > +      */
> > +     if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> > +             /* raw_hwp_list becomes unreliable when kmalloc() fails. =
*/
> > +             return -ENOMEM;
>
> If folios have hugetlb_raw_hwp_unreliable set, hugetlb_update_hwpoison wi=
ll return
> MF_HUGETLB_FOLIO_PRE_POISONED thus these folios cannot reach here, e.g. m=
e_huge_page.
> The only way these folios can reach here is that they are hwpoisoned firs=
t time so
> hugetlb_update_hwpoison returns 0 even if hugetlb_raw_hwp_unreliable is s=
et at the same

For first time HWPoison-ed hugetlb folio, hugetlb_update_hwpoison()
still returns rc=3D0 when kmalloc_obj() fails. So
get_huge_page_for_hwpoison() won't override ret with rc. IOW, ret will
be MF_HUGETLB_IN_USED or MF_HUGETLB_FREED. I believe
MF_HUGETLB_IN_USED can still get into me_huge_page(). MF_HUGETLB_FREED
goes directly to __hugepage_handle_poison().

So my intent is to block both places from dissolve_free_hugetlb_folio().

> time. In that case, we can simply dissolve the hugetlb folios and then ta=
ke the sole hwpoisoned
> @page off buddy? But this might not be a good idea as it is really fragil=
e...

I think it is fragile too, and would prefer the leaking approach.
What's your thoughts?

>
> Thanks.
> .

