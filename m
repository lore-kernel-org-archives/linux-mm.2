Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6DBCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C746B0088; Mon, 13 Jul 2026 07:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC936B008A; Mon, 13 Jul 2026 07:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB516B008C; Mon, 13 Jul 2026 07:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 726896B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:47:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CD4086CDF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:47:44 +0000 (UTC)
X-FDA: 84983578848.04.1BFE7F0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id A2370180005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:47:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jNaqlJHH;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783943261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKbDN/EInfIse5H8NhMFX3Wyxnpwkw7NAZOqOtgi1Hc=;
	b=pPEsDAw1Qj4Zc+Fwk+E44PTYUyHV/0nsdrYN67KQUcatzEugawq8zJwwpfhFv/ESLFcjdk
	cxB9m2qbSSOsFwn44k/fsEfPKDmy6sgrQi0nKxvteAU6E/YaUGqpP7haUST2i/AoidMbIm
	x7vFtwsZPUS1VNUA6Vcm1KXxEyhuy/g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jNaqlJHH;
	spf=pass (imf16.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783943261;
	b=HRgRAzFF3F6UO/3KIoKiKlaMJy3TBDBvWYI/SpAKGcGLtfWC22h6f6islubA9xjE68lK5N
	62oUuug4E5gdSLtgQ3ivLYdeBzjh3gryBtBl5gDT5ewYAsWqAtxD1XQUc05WCRag8gUDZW
	XV7hpS2D5Bt4gELhtG3TdlGSP0wKR8I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783943261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aKbDN/EInfIse5H8NhMFX3Wyxnpwkw7NAZOqOtgi1Hc=;
	b=jNaqlJHHY+r+NFsx3SjphBVPCJOZA6GDiMZg5IsEw9MibxD07dQokNQ5rzTauyC54d8dIC
	RSo6bzc+jMFSp9wPpEC7w1U4mEImZ1t0q95gxFwpWeNV10hkvpeQrP9Q/qtM7Kqb37kfYh
	keNy+3wgDtwRvimprvs/Gm5L4nQgyj0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-lDqNSsCQPbaNwpTBxnB3iQ-1; Mon, 13 Jul 2026 07:47:37 -0400
X-MC-Unique: lDqNSsCQPbaNwpTBxnB3iQ-1
X-Mimecast-MFC-AGG-ID: lDqNSsCQPbaNwpTBxnB3iQ_1783943256
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5aec6240ddbso1738463e87.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:47:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783943256; x=1784548056;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aKbDN/EInfIse5H8NhMFX3Wyxnpwkw7NAZOqOtgi1Hc=;
        b=YquhBDMV/yoKgVWcWWjaefK7AwfRCpgO9lCydISeA8aaCUjEU1ilXbJ7JWukqEvyR9
         9McGrsXPJILkLjtvQiZLttl1gMDmOW071KcZQqsyxqTwihfhKp38HZeyebGt6/fzlQQt
         UvB2/dC0w/jFd43bFij6//JwmcQvxWrvA5KStV/I7fBgcscB8SPsFElXrbv+uE0kHhun
         vYIlMEQSHQY/JrMtb+DiZGuq5aYWywmInLmW/8fmHdqvh37t//hfDGB1ojwE6a/jydB5
         FokiTiyX3+XwXZ6ipLEo12QvdkW1FfDSbYX5Orjkpr4YnHloo/BYmDia2l3bHCEPAYsb
         HudA==
X-Forwarded-Encrypted: i=1; AHgh+Ro6wXF98MqYNwVfHLzfs+N4UhgNOxs+ZcXw6KLrfdFRRk0lCt6lWCd3FBWUtM1pJ9bsaLv4wzv6zw==@kvack.org
X-Gm-Message-State: AOJu0YzhEEF6BOvH8fxt/WSevVcjMwhTYozp25wnr1LzruWlPHEgwaXP
	BUlGl0shgNTDmwkHx58w5fMlMIpaSJbXDXcwCuqS/nJ0Z9aEVytaK+uqz6Yq4FIIrRE1Io+sG9E
	WDpbQNDk6P218RAjk6FFgi84Q0ITU0yr5PeEmzVAFNCr0D2agYOwpw9OBMN2GpeELoHxc23N2gF
	fJS+7Th3gegOQ7V55SInuTyU58DuE=
X-Gm-Gg: AfdE7clZ0XoLM3Vghh83+7epdVUZYECZ49h1JbbSLsXwaFl3OJJngpJLWLmkquRUosJ
	8uSXPWMZdFvPbXtE7lvyjLixViw7f0lxPDTjf6ehF7x9ibidNWTalOwNbvN/AF8JyohcpIUF6yL
	Rd0E5TYAUael695oir4IIKOotyx/XRNCYwyihze+8fwU9qipfwMWlDuQCjST2VG7oD
X-Received: by 2002:a05:6512:3986:b0:5b1:121e:56c2 with SMTP id 2adb3069b0e04-5b1121e5b3dmr1742695e87.0.1783943256262;
        Mon, 13 Jul 2026 04:47:36 -0700 (PDT)
X-Received: by 2002:a05:6512:3986:b0:5b1:121e:56c2 with SMTP id
 2adb3069b0e04-5b1121e5b3dmr1742674e87.0.1783943255801; Mon, 13 Jul 2026
 04:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn> <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
In-Reply-To: <20260713143707966lCkTinO0i9zYAc1K2ZmqZ@zte.com.cn>
From: Nico Pache <npache@redhat.com>
Date: Mon, 13 Jul 2026 05:48:54 -0600
X-Gm-Features: AUfX_mwrBp4ld_acLJa82rvEOqlZRM93ghqOGkbAmWLxGYELjfup9HaqEmDSH64
Message-ID: <CAA1CXcA=WezZPJBL=fbWv_EzKjJVfP23Mt=O_rpB4N5G+fFHZA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/mm_slot.h: add a helper function mm_slot_remove
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, chengming.zhou@linux.dev, 
	qi.zheng@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ryan.roberts@arm.com, dev.jain@arm.com, wang.yaxin@zte.com.cn
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: S5aGX0NJqyNAV8RPIQ_SRK_sghjRZsiD0ZxMh9tGq7o_1783943256
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2370180005
X-Stat-Signature: didm8f4h4r9t5okg3rawc4z11ee8xfhz
X-HE-Tag: 1783943261-359970
X-HE-Meta: U2FsdGVkX1/oMvZJuIKGg+ZdlGy2RaL1slxTIq4O6bMvYcx2irKSYnPC2LAMU73hsPPwkFA8iHXQGjxKOOioMFxU+aFW+Hq/59lITkqOCyMwiPcie3cI4ggbTkNzERoB36hc+teXdQhH6tMZPOM9lZ8snRrOZfzXxojDXv2chgv+eWqFIqjhgy3N2USHNDuY6rdIl/MxE5jF2E735OKR+HoSnsmQl5MwUX+UMO2tGRkZMJbMNS+s5jwK3mOwKd97tDRSvwdk3US7Y1UtkLyfdwche9dppd06g/kHbEQoadIrw5er0XzfJF08p+r6JPviSB9y7eaWas4QRSwgYdJnyftpC2RIAXnDwjDM8ArQGhZ/12RquNsISSQyrYQTdkEtkdqDEGosk+E2P1lh5aue5140u2v9icBRUZE2+UBFq3p/qcQzdZvgztAEkW0nq/roQB5iIgbNsX47gnxB/gy3XVV4iJQiPUdfuxOtNCaKh1kHHYZD51p4atZOBTEjvRtyemndbDczaqsKStQH2H7RSwOMLEvBYg6rDgdMTXLBSeWwC22tkYFJL+X1K7H4QQMTNrXEJfH57hvp9gBP8S9iXwgzs+7YUBHjx+c4o54DjPnl1C27YkesWMsHxnnxzUc0U4wNmBG0caq2TURPZNCsr6p6czy9JfsPB24qbpIeU3gZ1g0Dc3eHrJO0oHI5HuHqwrwbaQzlNhYz2RBlfyDFEJFKtOG9+UuAL+zK3czWIPEbl60juV9q9CMn9X3eAcsXEPO35G0bjQY90YgN4uE+Pv7A7lGbvy+yv2LoJTGVSGRRoBQZhxcuG6ZDG6Hz+GSuwBLCeSGDxJbX1sxtB++M48aaDMP8eBpDwgFS8QnwLJK8uydcDL9vchKRb3UcAXYFm7gVFG63Q6p7OHp7pgnQGs/mSihVmGxr81RMGhCWOPkiUSTPvayPkFiRabLRSclgSHS5LeZ1+zstQn9qfaX
 qijIoJQr
 F0eZMzPCWsOWDVI2iUhRNkvJgOqKYxv2NaPDl9YIUSWg1pU+fQuTsX+yOplsHjSSiHHf55ClMxrqYqp0XZn5V4gXDCvhB/BfuwgOHtgnMpueyDbJLvlG4/ag7K3gbz5gwTKhKZHDsbhVkDsJEy+8Nm5rJS8EpxKXqE8P3hN4RdxSpjTY1w7JmZ1SJZZI6rL37EV6+QBmDtAa/oQafz5tszcn4VeQOJjXo2xW/XDlUw4b3dw5e5xtZajeAhUCioNZL6Gho6JxO6LYClERj7axfO3qfv4Wc9L8o97McwqiykUZrc2uSMpBl0DpgnSYaUWlW5jFgSp956GwLG9ij4j5c9yw6XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 12:37=E2=80=AFAM <xu.xin16@zte.com.cn> wrote:
>
> From: xu xin <xu.xin16@zte.com.cn>
>
> Both THP and KSM manage per-mm scanning slots using the mm_slot
> structure. The slot is kept in a hash table and a list, and removal from
> both containers requires the same two operations: hash_del() and
> list_del().
>
> Introduce mm_slot_remove() to abstract the common hash_del() + list_del()
> sequence used in both khugepaged and KSM.
>
> No functional change is intended.
>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>

LGTM!

Reviewed-by: Nico Pache <npache@redhat.com>

> ---
>  mm/khugepaged.c | 6 ++----
>  mm/ksm.c        | 9 +++------
>  mm/mm_slot.h    | 5 +++++
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 58e14d1543ec..5f6eb1bd9a67 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -606,8 +606,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>         spin_lock(&khugepaged_mm_lock);
>         slot =3D mm_slot_lookup(mm_slots_hash, mm);
>         if (slot && khugepaged_scan.mm_slot !=3D slot) {
> -               hash_del(&slot->hash);
> -               list_del(&slot->mm_node);
> +               mm_slot_remove(slot);
>                 free =3D 1;
>         }
>         spin_unlock(&khugepaged_mm_lock);
> @@ -1802,8 +1801,7 @@ static void collect_mm_slot(struct mm_slot *slot)
>
>         if (collapse_test_exit(mm)) {
>                 /* free mm_slot */
> -               hash_del(&slot->hash);
> -               list_del(&slot->mm_node);
> +               mm_slot_remove(slot);
>
>                 /*
>                  * Not strictly needed because the mm exited already.
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2791ce5bd44b..443dab513da6 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1257,8 +1257,7 @@ static int unmerge_and_remove_all_rmap_items(void)
>                                   struct mm_slot, mm_node);
>                 ksm_scan.mm_slot =3D mm_slot_entry(slot, struct ksm_mm_sl=
ot, slot);
>                 if (ksm_test_exit(mm)) {
> -                       hash_del(&mm_slot->slot.hash);
> -                       list_del(&mm_slot->slot.mm_node);
> +                       mm_slot_remove(&mm_slot->slot);
>                         spin_unlock(&ksm_mmlist_lock);
>
>                         mm_slot_free(mm_slot_cache, mm_slot);
> @@ -2772,8 +2771,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_ite=
m(struct page **page)
>                  * or when all VM_MERGEABLE areas have been unmapped (and
>                  * mmap_lock then protects against race with MADV_MERGEAB=
LE).
>                  */
> -               hash_del(&mm_slot->slot.hash);
> -               list_del(&mm_slot->slot.mm_node);
> +               mm_slot_remove(&mm_slot->slot);
>                 spin_unlock(&ksm_mmlist_lock);
>
>                 mm_slot_free(mm_slot_cache, mm_slot);
> @@ -3116,8 +3114,7 @@ void __ksm_exit(struct mm_struct *mm)
>         if (ksm_scan.mm_slot =3D=3D mm_slot)
>                 goto unlock;
>         if (!mm_slot->rmap_list) {
> -               hash_del(&slot->hash);
> -               list_del(&slot->mm_node);
> +               mm_slot_remove(slot);
>                 easy_to_free =3D 1;
>         } else {
>                 list_move(&slot->mm_node,
> diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> index 83f18ed1c4bd..5de3e91d86b4 100644
> --- a/mm/mm_slot.h
> +++ b/mm/mm_slot.h
> @@ -52,4 +52,9 @@ static inline void mm_slot_free(struct kmem_cache *cach=
e, void *objp)
>         hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);       =
      \
>  })
>
> +static inline void mm_slot_remove(struct mm_slot *slot)
> +{
> +       hash_del(&slot->hash);
> +       list_del(&slot->mm_node);
> +}
>  #endif /* _LINUX_MM_SLOT_H */
> --
> 2.25.1
>


