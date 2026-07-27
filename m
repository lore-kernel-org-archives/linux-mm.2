Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2503C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5756B008A; Mon, 27 Jul 2026 12:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866226B0093; Mon, 27 Jul 2026 12:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730ED6B0095; Mon, 27 Jul 2026 12:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8B346B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:24:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AC318012C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:24:54 +0000 (UTC)
X-FDA: 85035080508.14.A312888
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FA5CC0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:24:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DmOkLUxi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785169492;
	b=ABAdf2+kPs5K9Oc7kK6zcSsJ1rVI+rEKmPZwbYEZ3UtKbojRJeKNHHKiJZwNPd0CbN2Bk8
	fTKE/7Xpc7JTQqufenWiSFhdu+aGHRNARJzga89bVFimx9BrHIqa+t0TNF2LSdRzzlZtIa
	EBs/sNPbpX2Gd+b+qeSYAgBhr8n6bi0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DmOkLUxi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785169492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsod/qLuXRWdrxs9+mmL1NzASv99z6ZREmVzFIyc/Gg=;
	b=eFESkn730WbUcOsKgMhPWW6r4gjkVkAYB5fyLViVRgJG3tax9QO6Mwr9ru3Dh67rYpw086
	o02ZxvIqsc7HMO9x43UIABdxZPyyB+J8uqrS/G8aJx9I17SDDwCF1fxcGqHCAm6cxlctPt
	Bz90NLOQL9Ry7OA/Je9W9ZeNIaoDQuM=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4728c12ba97so1771438f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:24:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785169491; cv=none;
        d=google.com; s=arc-20260327;
        b=JBf25YkzzR3S0tcgA8/8mAIxqVefE+1nuSD2wcpdoty9fUOXVt2cZ+7QqSjTDaa+GN
         JpMJxCRl0o6KllH5MLnKqstTLEceyHDKy5a/9NjnSknnw6l2h8ifO9gI4oX5BZ/QgzSP
         icVvzcMHi2uvh50H7XTnMJ4xedj2PwV0WVSd5rDLOJcoUdRV7F85yUfdoQgi5+GKs9Zt
         BtB6re6pVpGV/Gqvz0MCN1DSqJt/Qxh7csefaw8Sw4HBhjWEg/qLzSk5P6h6eTAOu/mU
         zw4Kop+9BT6KOYcv/ekfnffgocj1cXhfA+LJppL9r5dQX3BiOHvXNVn4oQlXbD/G/ubS
         njew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zsod/qLuXRWdrxs9+mmL1NzASv99z6ZREmVzFIyc/Gg=;
        fh=FQAjT4esPnCAChFDIoVMzqU+2JEp2+83Fw7XyFbS6yU=;
        b=pNpD/idzteQ8rjmKXBAIHnGYBd/lzbNoFEWgr8nRfmYGNGJe+7IVEvd4bcOEVQMCYK
         eB6ZFTvYp5VhJD9hhWmN6UUw6JdF9TRuOHqSMfGVd1gcMWOWoTdq6+wnuWfw18pfksEi
         Ws/Cz/bIX6b8R2zbDN84HCp3sorrAweRe1I34hXBCkXu8+iYp1RNHTDAyX1nC95kMzRU
         vqIx+0wVYgNRfNVvYkqHPsN+roF2Nxwuk28JzxpHhK6HMdwqXAvs4hHfl5eTf2a6692y
         NqMtb3+ZiOH4GnYiwR7ADgdJbUcO4wAzuDJ67ymj9Ph3E/vAGHue7F8Fo4gW5kg3my7t
         0oyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785169491; x=1785774291; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zsod/qLuXRWdrxs9+mmL1NzASv99z6ZREmVzFIyc/Gg=;
        b=DmOkLUxiBXF38GN/0+p+tAiFBco1ekTr/DK/LGbDNcoC3yJSCiCJlmgfLWqFpELH7p
         PXtZOxQv4m+bj5BkEzvzCs6BxIcR++O8p7D9QYCk+BRldXlG5PaENhI0oYH+m3Y4s1CE
         Rz8ckY7y9XFVPcklHddvzyqZIrPIdaAJ8F3cE78k/FswvsCTm/E50PyHU640OM2tlDbu
         cJD7lWMx2f7lbkqciOm5f8g+VZlOTLAOiOyse4TedHR+wqswrvvSmKxuMedaNOEXmvQs
         HplH15RF3flTjvDUS1gjUr4JGL9aXmY9HSUZJZwh/54XcPMlrFY3JD68HOjUInjXJIYa
         EsUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785169491; x=1785774291;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zsod/qLuXRWdrxs9+mmL1NzASv99z6ZREmVzFIyc/Gg=;
        b=Av1W0XlkIuAUNdcLUeBEKbeoiMWyq80yOjRnlcMEme+ky5W2T5gydemRhPwwAChTPU
         zA3LX1x+GiE5nDAOBKjjOENXkV6je0HjJcUqeHUKkZrGu4rWcj8WkVJX1XUXrByK1/0w
         E2CTygKGw5bI0vRFYblXaB6LcrDjL7ias6OMLtcH4hm+LoqGWTBTbf/k3eH/FQqzeDF3
         hPgSxTpYqSctz8WNATtjSc5UxrSdiPOTXr6ge1lN6W3snRzsDmNrpva737x0csWi6vOD
         bgaIoCEANtN5+8s222l0S75skvYQyH5TSgNep7t1IxTuZG6Y9EpqK7VRIrdxHujecrX+
         K1Ew==
X-Forwarded-Encrypted: i=1; AHgh+Rpam37J0mBDZQCHfNn+LybhuFqkCLKc4AKE6qtGrL340BKOWMIxdEY8kGz1iMUt/HNMWPnZCJ2p+A==@kvack.org
X-Gm-Message-State: AOJu0YzTpyXmlMqXaapzzPWjnN2yusubvVRPaHdtTFfVBk9V4UT7a272
	Y8TEJdj7eAc2izPU8fJlN7nWDpQT0G1/QXzNJ0EYipGmPK6+uKaIWU7Ygz14/7jEtfnQgDX1mmr
	JByLShzkTw3pS92g83O8/7LGxpjjen0g=
X-Gm-Gg: AR+sD12/ky4sl+vttPD7hqB7FrV25EwWe022cNhUpnwvksGDUhCJRSuJZfbLbebd2CK
	0a3/hBh53iAK6Cd1E/mecW1spVqoKMX+jVmgudSMNQKrMveIde36rrYCtQKQRGMyej4Yzqz4g+8
	Olbe5YwE9n7heQBQZkPt3djUDiBI9tPOTvani3ZEs7nwmUkB6P7IawA0chBXviQC6YsmjOJXbtq
	aeUaFaTe+KJbjyoMItGTpRsVkCaMzNpO6FndrQs4epLZgae9qxP3/yeqs+ylO1DxJRa3eTiVQJb
	y1MWSI0Yr5Kzu/8qrg==
X-Received: by 2002:adf:e19d:0:b0:47f:90cb:630c with SMTP id
 ffacd0b85a97d-47f9fc9d3f5mr12546589f8f.8.1785169490768; Mon, 27 Jul 2026
 09:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-5-usama.arif@linux.dev> <amFZmtGHEZjXEw5R@google.com>
 <ee172b01-54c3-47ef-9040-1342a1566796@linux.dev> <CAO9r8zMzjCf620EHwzfosngc94fu=vAb=ukrtOi9Qf3rA3vv7w@mail.gmail.com>
 <c40f4a8b-1f60-45ea-962d-0597c413ec3d@linux.dev>
In-Reply-To: <c40f4a8b-1f60-45ea-962d-0597c413ec3d@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 27 Jul 2026 09:24:39 -0700
X-Gm-Features: AUfX_mxjjRfJV8Uv-XQAVKUtz2NYGeR15CAkgiMb0FuDakVSIrHnyNqp3Jg_2yY
Message-ID: <CAKEwX=P=cFqojHPCp1oGqZCOVVGi9pyrgLtaSH3qrEwVppmxdQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio swapin
To: Usama Arif <usama.arif@linux.dev>
Cc: Yosry Ahmed <yosry@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	shikemeng@huaweicloud.com, kernel-team@meta.com, 
	Alexandre Ghiti <alexghiti@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6FA5CC0009
X-Stat-Signature: i3wbzapenw6krk7hiiuio4p715huw13e
X-Rspam-User: 
X-HE-Tag: 1785169492-522381
X-HE-Meta: U2FsdGVkX19lSVW8sMO2AevGY7cZFfvEZmYQFH1gUjNYc/EStAozuz2VuuhV8/RESQeQf0gK6mtAA+LdGf8QJTNqweAl0nTLrgNBw1IqFVMr07jcQbT2LfC7wvqRKo07BQFf/fOn/QzpWzyvhdM8M8zWzM9+dLhgbgCZnTcLpxApaNe8SoN4Uyf6wq3fBkKMiMoIq2kxt5kQBY+5de5gKBXXOVo5Agg8LVRQayglWZ81ZN3ACzeZtQOn9wYBTrTu8n0Vsx/fTJZKE70m61hiJU6VzFI3OSkIDgiNEOgyDn5FRmPxf5Xsr0aKmSpX7eUwiVSHdkbHMMdrwIz6b72wa55xmsEblfMvAzTC3AcaU/ytWSXwKBBbRzg++fHTQ7gLd9njcXVX9DjrEnkHsNqTqyQ3BsmqEyxzjXB7pnY6WOe7BlRwwGj6CP1JJFWZyTlnWNeHB2xlTRUwZNKuzgfCZ2PxetT+8fQtZKQ9hl/6qwEJwGNvWYcOqkP6mWeissbl8FaJ3r/yZmN0TN2Mra+CQgXfrx7dbCz27uSiXdAXZPouu7YKsUmZkYDMlCz1xuIvPwJh3VwG3bPqM9ynUuP5Nh4CFCrF2XxMh+BUTi5R2g2YVlEAcBbdT/lqLuMdnpBfp4JfaYh+aCvP17gJzcPEgQEa+KxR7V6aEo23quV7AYi4kP3LEJ2o/Y7rzLfXUbihJDVLPlRJyxYnA6Tb692Wqyv3eWd6KmXaQXWRTjUp/iuv6ls3VkZ21mi5+nWhVA9z8IlYfXU05J54vjsWq7J/DymknlzklavvQom/YVg8qH1OyXQP67wbczzLD1RhYw25ucswnDOUyhkWx8jQp071zxwzkIitXpKWiEkg6pK/qWIgoEWoKODegR6VZEDm0Mq1DZskAkoNiGcszLmZz6d5DzJmzC3ViUi+ElMo0RikFBYyH1oEFsGvQ83f2qcxjhOtiewShXAvZ4jcnXNdSJm
 6Go6Nr4o
 AmzocvLlfpylah/VHK59FccMkvurjLwVsU4UbOHzDzO2VxG1wYCelznWDmqqAzPe8AN0jQQPdXy6dB8UQeTjZkFEzy/GFyfzarpaB6126tAkrHGhuQcGhmEdCVQd5qLTtyzO7h6xA5K1awXDWSDBlOA+IF6Yg5Wu4hXkLi1uixfzt2Re3WD1DCe1OUjPPvcJhNZsShC/YskhdiysBhvRH5b9C/KRgvrO4bnQ5EAgHMAek8cbSBS97h8blpbTgCbXI5+VoZKLX+dXxnViVkk8bxvpLLFLUWaYxEh5LfumtmvrS9Lywuim669Qa+mrwEqXN4chIjeY2O/6YduY0SWmbx3IF8ORZXiLtv6vmE9nQwdlC9emTOXLig4xFsKvMgcHgF83s79GhFax6MCzyfblYxOmN6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 2:59=E2=80=AFAM Usama Arif <usama.arif@linux.dev> w=
rote:
>
>
>
> On 23/07/2026 17:42, Yosry Ahmed wrote:
> >>>> @@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
> >>>>              return -ENOENT;
> >>>>
> >>>>      /*
> >>>> -     * Large folios should not be swapped in while zswap is being u=
sed, as
> >>>> -     * they are not properly handled. Zswap does not properly load =
large
> >>>> -     * folios, and a large folio may only be partially in zswap.
> >>>> +     * A large folio reaches zswap_load() only when its whole range=
 is
> >>>> +     * expected to be on disk: PMD swap-entry consumers split befor=
e
> >>>> +     * calling into PMD-order swapin whenever any slot is still in =
zswap.
> >>>> +     * Confirm the range is entirely absent from zswap and return -=
ENOENT
> >>>> +     * so the caller reads it from disk; if a slot is unexpectedly =
still in
> >>>> +     * zswap, fail the read rather than return partially-initialize=
d data.
> >>>>       */
> >>>> -    if (WARN_ON_ONCE(folio_test_large(folio))) {
> >>>> -            folio_unlock(folio);
> >>>> -            return -EINVAL;
> >>>> +    if (folio_test_large(folio)) {
> >>>> +            if (zswap_is_present(swp, folio_nr_pages(folio))) {
> >>>
> >>> Is dropping the warning here intentional (for the folio_test_large() =
&&
> >>> zswap_is_present() case)?
> >>>
> >>
> >>
> >> Yes, so we can end up in a race, which should be handled gracefully.
> >>
> >> For example, lets say we have zswap writeback enabled, which means we
> >> can end up in a state where we have a PMD swap entry and 511 of the 51=
2
> >> slots have been written to disk, but 1 slot (slot X) is still in zswap=
.
> >>
> >> We can then have the following race:
> >>
> >>
> >>   CPU A: PMD swap-in                  CPU B: split-PTE swap-in
> >>   ------------------                 ------------------------
> >>
> >>   Checks swap cache: empty
> >>
> >>                                        Faults slot X
> >>                                        Adds order-0 folio F
> >>                                        zswap_load(F):
> >>                                          removes X from zswap
> >>                                          marks F dirty
> >>
> >>   Checks zswap range: empty
> >>   A is preempted
> >>
> >>                                        Unmaps/reclaims F
> >>                                        zswap_store(F):
> >>                                          puts X back in zswap
> >>                                        Removes F from swap cache
> >>
> >>   A resumes
> >>   Allocates large swap-cache folio G
> >>   zswap_load(G) finds X in zswap
> >
> > Why don't we check the zswap range after allocating a folio in the
> > swap cache? I am assuming at this point we have the folio locked and
> > the result should be stable?
> >
>
> Yes that makes sense. The folio is locked and the result will be stable.
> How about something like below?
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 1f08fb522036..41f168377cb1 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mempolicy.h>
>  #include <linux/swap.h>
> +#include <linux/zswap.h>
>  #include <linux/leafops.h>
>  #include <linux/init.h>
>  #include <linux/pagemap.h>
> @@ -500,6 +501,17 @@ static struct folio *__swap_cache_alloc(struct swap_=
cluster_info *ci,
>         __folio_set_locked(folio);
>         __folio_set_swapbacked(folio);
>         __swap_cache_do_add_folio(ci, folio, entry);
> +       /*
> +        * Reject mixed zswap/disk backing before starting the read.
> +        */
> +       if (order && zswap_is_present(entry, nr_pages)) {
> +               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> +               spin_unlock(&ci->lock);
> +               folio_unlock(folio);
> +               /* nr_pages refs from swap cache, 1 from allocation */
> +               folio_put_refs(folio, nr_pages + 1);
> +               return ERR_PTR(-EBUSY);
> +       }

If you move it to __swap_cache_add_check(), you can potentially
backoff even before the folio allocation? :)

