Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED18D26D97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1976B0088; Mon, 12 Jan 2026 04:55:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14FED6B0089; Mon, 12 Jan 2026 04:55:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0306C6B008A; Mon, 12 Jan 2026 04:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E65286B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:55:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B09431607CE
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:55:47 +0000 (UTC)
X-FDA: 84322855134.20.553E94D
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id CE9F320003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:55:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jdFNX+VQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768211746; a=rsa-sha256;
	cv=none;
	b=FbjYUrXpmme1OGXaqW0A8SKuW1RI3FL/ukzYFcOThKE/OagBD9k23HN1KiH0ioAd3krLh8
	fgtvDt3NJ1y++dFosHz5Ze6j+TRMH1SnQO+0/M9tznnAvFx/XCi2hqquCp0kn2evoGKpzU
	1Qulc+ws07SugQBVo5PqB0zvscIRL8g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jdFNX+VQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768211745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hK8RvD0wg0cx8lVS3kyXyRfv713Ea0iYheTw/LCOhM0=;
	b=Me0f5lD+l0agxVyguTGO7RFrj9y6tdNOepcp6F31SG1zoy2ABaQxv9iuFcReE23ALLge61
	m0apsGSBEfNgFbWVgjJlVawNyRxZOfW7E/pd0oRIXLAu3NDUcx1IT9yM0zEMnzdwmcd/S/
	+7ESewgz0zQtNNHGz64y4L/nJ2ETLB4=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b9d01e473so10282236a12.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 01:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768211744; x=1768816544; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hK8RvD0wg0cx8lVS3kyXyRfv713Ea0iYheTw/LCOhM0=;
        b=jdFNX+VQqmkYQ6dBjVYJMcisiZPzgpU/4Ox8ATlfUK+x6da26Phr2L7pOOZJ4QSM8r
         cY5dnqKu4RYUR+NWj9piqlQz+Aei6LEDAm018qGqH7pMYNBixG+ZE1a08uuUaEoBzrN3
         RqbwWh2U/ExwyMN0S/OdFuEHPxQGDXRUrFxYS5CL4hxjb9ZkASYatuv3yAC6nA7e3CmE
         rEm0qvPiA+MEipuoPap4UA4f6u8rQwEACGcc1FbyN4HFtkDNcMCkMWwy0H1JyF2K4Jyr
         qLmTWhga/NS6VX9gSJTsTOvBf+50s/0swilHFXbLrKqcKtamw9mDTyt0mhZR+EL+hGQe
         og1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768211744; x=1768816544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hK8RvD0wg0cx8lVS3kyXyRfv713Ea0iYheTw/LCOhM0=;
        b=LV71FJarmRrecoB01sZ0dIuOrD2IHiHtmxeeBPpAaYWFeazNOMYvazRet7SsGprOsY
         fTMGDYMyWjQKYsx6fAizKKBfYXSDx2UC4lglxrtVhzEZrn9ocDBV7cIcWKFq1KhZLzmS
         r99SlhKSFH+AEIOV6GivLcYuT43EQ0VnybYHvldbrXX8jovcEO8itjic9lkEuB78BOaf
         GOP9MYa9F+LVdrufChGBsGMA1sMWghy6TT2W19L3dBAqm65RWX4jPkSt/PuEyZI88Ccl
         qBeOnb3HmVUVimpZhdarbqBBvCldrFfSznJEmQny2iB8PeOLDmhL5DjcxZF3A3wLL6ia
         PSgg==
X-Gm-Message-State: AOJu0YzXZuHbs3C1BsozkEUiz8pVi0jXUMjFOo9oY26QeRcmLGvNQEcF
	RosqD+Pds9mULzUEf8OYB1S9/aFg+sDZCQC6UQdV+9d0T9WAsbi6rOytiiQpAhs07/uhTYuWV7r
	KYyNN6CVygtlzK7kYMSdj+CBxGBvTvQg=
X-Gm-Gg: AY/fxX4aTT508ruvQ/6lL1uL+XRvBDA4u1UvSpIPGUQ421qDpT88koCkUVShogy/Q1P
	kbzY4dowA0G6r5iUXK6aYNoxsOcZlDfcvT+fMPMHSgUwM5GAHT+v6UAjplsJaxZCovDe6aIA38S
	Hxm2xeu3vDZJkKP/8llfg8CJX3ISageykDhYj8NYxuxW+O+CDlyKok9JqAm4b55ejrGBYNzY83m
	l82P/U2B6IlRdktskM3Lb6dzpnw7dNOZvoB9NWJoL7sVF4mQYrc5VIBNeaQxcA9gaEn1exDf9LB
	pPrWuiWdPMXl25F8BU26o58MIBbc
X-Google-Smtp-Source: AGHT+IHL4tD/eA41YzB9jltvfCK39D5lYU0R/uXdXlmYGdDlSTlXcrJ/8VqcjD71w0d57VLK7uMQoI2FDyF+f0gkQSM=
X-Received: by 2002:a05:6402:1ecf:b0:640:f2cd:831 with SMTP id
 4fb4d7f45d1cf-65097ddd11cmr16678648a12.10.1768211743873; Mon, 12 Jan 2026
 01:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com>
 <d20f536c-edc1-42a0-9978-13918d39ecba@linux.alibaba.com> <CAMgjq7ASxBdAakd_3J3O-nPysArLruGO-j4rCHg6OFvvNq7f0g@mail.gmail.com>
 <1dffe6b1-7a89-4468-8101-35922231f3a6@linux.alibaba.com>
In-Reply-To: <1dffe6b1-7a89-4468-8101-35922231f3a6@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 12 Jan 2026 17:55:07 +0800
X-Gm-Features: AZwV_QhXBjzBmhSsBlEr9V_cMtomZ7AHf_ABUPMfh__jgYGB1Qr8yYkPUcXksXo
Message-ID: <CAMgjq7Biq9nB_waZeWW+iJUa9Pj+paSSrke-tmnB=-3uY8k2VA@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem, swap: fix race of truncate and swap entry split
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE9F320003
X-Stat-Signature: 4m84mkpa8bew9jo11n36hc6czt9u8jko
X-Rspam-User: 
X-HE-Tag: 1768211745-263404
X-HE-Meta: U2FsdGVkX1/BVacpGhCBOBQ6cjS28tz5341YXGl2IKCsE+09cZcrlZyPZeJG4Bf20QXpm55Om/i4CCG4CePcZ2hu/E7Kk7q2nl7/++KWMEZi5bFTKUwyUaHonJcRM5EZcIcBV1expBt6IeWbDOb6nSeT0MYCGLnNkvxAyDvycFX5Mi6UC7BABWKtdTyDo3wXhdNQjl1mI0FjCZ67xydbxweMace6VP97bgSi0kvgShduvTecbN0ehLp98OrcXXBKiCTdmCnaUf8LfA0MYUT06bE5tHYw8nzArmKbGyL7+89JUlk1JeBWCnMc4zH2BJWaPWsJSRzPQWQZbWVP1uc5EKx8618MiOQ0yuVrY/4PSW25FhBzw5JJzsPooeOCEu3LzipDIzMIsrs8ViaPC8HsfvIX7SFUl28hDoZ/zh0RRYPiqJCAsV0XC/gPXYfECGpAAliG0gU6iTo3dS/jgQtcVlYvQ/Vv2/siftAScSO9oKglDvTJBQjbSLt+wia2o51U+JO5P0t1l/PSdNLMinB48wTl2qEEskBOJuwoIA2H33OHtWhG8CPft3koicRKZC/6vtUCnKcvxhi7M0+7C+hVFeMnHU6sDi9nRemtJY75P6kQZtc1S4w/OIoGRfeZLDRdr9cYWT5pAo4OBwaQALMTlu3boZbNq8fXy0vKy0s632jagMHpr0l4y3pEYmAMH4HYqTQal/8VO7mWQ8TZzqmMhGxqy67kQmX6oKjiy2g1vgDo24ajeQQsUV37FJAoUHqXZM7j26W5E2XZruQ9JrMjGbhGYBpu+zM5GCR/FA/4X96cUUEA/u3WsGkcbyL2LG/5iEJH3+LSHAeVkTgmpLBG803oexYJtguTAqn5ItGdHP42Z5J/SpBKoRg/k1GWhm2/77V03o4D207kkoLwiHxqe/gDzCyTNJKK3MSdTu7u4FL5fPM9VlVsvICB+diQ0GzRCjtxVwwpUZwxsTE6HxM
 8JX3k0zR
 gjhU3qhktt3mI5XhYtZ9DdJ1eIF5CKY822XtXNnSq7tpx/OUsPC4TX/JRefrkJaToWgXunOCVMFz26qIvcLC5cV7/4N4vfmvtf7mSc7Iqte2kGmURbZbwwyt3pgHf2BkPuqJh6NEMdT+Yb6oQWClalxXE68DBffissBQI/ty2g1eE4jFGXdxSkkwqTroL9dQaDxFeAhCbGj9T8Ehav7N+qDQrD+1msMrt+MuJ4IwFR1aantEpESGPIRwXnBBrcMj2ln/8qTD1i3gFdU3xYd3LwPVHd8d8/d7Ql6pXCr3YCwCJAYMIP6wAqLfNDwuJ1nGhLb+IE6MTaa15ZxPWU0cnvT9ghLIN3PaSgT8GFuahAkzYCL7N9lQAeDJkpGAe4sEPyK2juYeyAna66OsFKtnB8gQcHJ9BN4G90BozcUxO8gIgJrNor78mzOAFRFIP9PkFgW4fF4PZSnpGXJd1GzrjV4EncnkZQazW7mtiQKtCeqPwnctiHvpjKq2T4SwQhqBHF/wb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 4:22=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 1/12/26 1:56 PM, Kairui Song wrote:
> > On Mon, Jan 12, 2026 at 12:00=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >> On 1/12/26 1:53 AM, Kairui Song wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> The helper for shmem swap freeing is not handling the order of swap
> >>> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry,
> >>> but it gets the entry order before that using xa_get_order
> >>> without lock protection. As a result the order could be a stalled val=
ue
> >>> if the entry is split after the xa_get_order and before the
> >>> xa_cmpxchg_irq. In fact that are more way for other races to occur
> >>> during the time window.
> >>>
> >>> To fix that, open code the Xarray cmpxchg and put the order retrivial=
 and
> >>> value checking in the same critical section. Also ensure the order wo=
n't
> >>> exceed the truncate border.
> >>>
> >>> I observed random swapoff hangs and swap entry leaks when stress
> >>> testing ZSWAP with shmem. After applying this patch, the problem is r=
esolved.
> >>>
> >>> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Kairui Song <kasong@tencent.com>
> >>> ---
> >>>    mm/shmem.c | 35 +++++++++++++++++++++++------------
> >>>    1 file changed, 23 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/mm/shmem.c b/mm/shmem.c
> >>> index 0b4c8c70d017..e160da0cd30f 100644
> >>> --- a/mm/shmem.c
> >>> +++ b/mm/shmem.c
> >>> @@ -961,18 +961,28 @@ static void shmem_delete_from_page_cache(struct=
 folio *folio, void *radswap)
> >>>     * the number of pages being freed. 0 means entry not found in XAr=
ray (0 pages
> >>>     * being freed).
> >>>     */
> >>> -static long shmem_free_swap(struct address_space *mapping,
> >>> -                         pgoff_t index, void *radswap)
> >>> +static long shmem_free_swap(struct address_space *mapping, pgoff_t i=
ndex,
> >>> +                         unsigned int max_nr, void *radswap)
> >>>    {
> >>> -     int order =3D xa_get_order(&mapping->i_pages, index);
> >>> -     void *old;
> >>> +     XA_STATE(xas, &mapping->i_pages, index);
> >>> +     unsigned int nr_pages =3D 0;
> >>> +     void *entry;
> >>>
> >>> -     old =3D xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL,=
 0);
> >>> -     if (old !=3D radswap)
> >>> -             return 0;
> >>> -     swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order=
);
> >>> +     xas_lock_irq(&xas);
> >>> +     entry =3D xas_load(&xas);
> >>> +     if (entry =3D=3D radswap) {
> >>> +             nr_pages =3D 1 << xas_get_order(&xas);
> >>> +             if (index =3D=3D round_down(xas.xa_index, nr_pages) && =
nr_pages < max_nr)
> >>> +                     xas_store(&xas, NULL);
> >>> +             else
> >>> +                     nr_pages =3D 0;
> >>> +     }
> >>> +     xas_unlock_irq(&xas);
> >>> +
> >>> +     if (nr_pages)
> >>> +             swap_put_entries_direct(radix_to_swp_entry(radswap), nr=
_pages);
> >>>
> >>> -     return 1 << order;
> >>> +     return nr_pages;
> >>>    }
> >>
> >> Thanks for the analysis, and it makes sense to me. Would the following
> >> implementation be simpler and also address your issue (we will not
> >> release the lock in __xa_cmpxchg() since gfp =3D 0)?
> >
> > Hi Baolin,
> >
> >>
> >> static long shmem_free_swap(struct address_space *mapping,
> >>                               pgoff_t index, void *radswap)
> >> {
> >>           XA_STATE(xas, &mapping->i_pages, index);
> >>           int order;
> >>           void *old;
> >>
> >>           xas_lock_irq(&xas);
> >>           order =3D xas_get_order(&xas);
> >
> > Thanks for the suggestion. I did consider implementing it this way,
> > but I was worried that the order could grow upwards. For example
> > shmem_undo_range is trying to free 0-95 and there is an entry at 64
> > with order 5 (64 - 95). Before shmem_free_swap is called, the entry
> > was swapped in, then the folio was freed, then an order 6 folio was
> > allocated there and swapped out again using the same entry.
> >
> > Then here it will free the whole order 6 entry (64 - 127), while
> > shmem_undo_range is only supposed to erase (0-96).
>
> Good point. However, this cannot happen during swapoff, because the
> 'end' is set to -1 in shmem_evict_inode().

That's not only for swapff, shmem_truncate_range / falloc can also use it r=
ight?

>
> Actually, the real question is how to handle the case where a large swap
> entry happens to cross the 'end' when calling shmem_truncate_range(). If
> the shmem mapping stores a folio, we would split that large folio by
> truncate_inode_partial_folio(). If the shmem mapping stores a large swap
> entry, then as you noted, the truncation range can indeed exceed the 'end=
'.
>
> But with your change, that large swap entry would not be truncated, and
> I=E2=80=99m not sure whether that might cause other issues. Perhaps the b=
est
> approach is to first split the large swap entry and only truncate the
> swap entries within the 'end' boundary like the
> truncate_inode_partial_folio() does.

Right... I was thinking that the shmem_undo_range iterates the undo
range twice IIUC, in the second try it will retry if shmem_free_swap
returns 0:

swaps_freed =3D shmem_free_swap(mapping, indices[i], end - indices[i], foli=
o);
if (!swaps_freed) {
    /* Swap was replaced by page: retry */
    index =3D indices[i];
    break;
}

So I thought shmem_free_swap returning 0 is good enough. Which is not,
it may cause the second loop to retry forever.

>
> Alternatively, this patch could only focus on the race on the order,
> which seems uncontested. As for handling large swap entries that go
> beyond the 'end', should we address that in a follow-up, for example by
> splitting? What do you think?
>

I think a partial fix is still wrong, How about we just handle the
split here, like this?

static int shmem_free_swap(struct address_space *mapping, pgoff_t index,
                unsigned int max_nr, void *radswap)
{
    XA_STATE(xas, &mapping->i_pages, index);
    int nr_pages =3D 0, ret;
    void *entry;
    bool split;

retry:
    xas_lock_irq(&xas);
    entry =3D xas_load(&xas);
    if (entry =3D=3D radswap) {
        nr_pages =3D 1 << xas_get_order(&xas);
        /*
         * Check if the order growed upwards and a larger entry is
         * now covering the target entry. In this case caller may need to
         * restart the iteration.
         */
        if (index !=3D round_down(xas.xa_index, nr_pages)) {
            xas_unlock_irq(&xas);
            return 0;
        }

        /* Check if we are freeing part of a large entry. */
        if (nr_pages > max_nr) {
            xas_unlock_irq(&xas);
            /* Let the caller decide what to do by returning 0 if
split failed. */
            if (shmem_split_large_entry(mapping, index + max_nr,
radswap, mapping_gfp(mapping)))
                return 0;
            goto retry;
        }

        xas_store(&xas, NULL);
        xas_unlock_irq(&xas);

        swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
        return nr_pages;
    }

    xas_unlock_irq(&xas);
    return 0;
}

