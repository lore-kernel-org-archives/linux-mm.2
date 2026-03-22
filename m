Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F3AD58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13BB96B0005; Sun, 22 Mar 2026 17:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1136A6B0088; Sun, 22 Mar 2026 17:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028E16B0089; Sun, 22 Mar 2026 17:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E44326B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:35:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CD2D8C706
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:35:14 +0000 (UTC)
X-FDA: 84575004948.02.C529AE9
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf06.hostedemail.com (Postfix) with ESMTP id B601018000B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:35:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rDmMjqnh;
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774215312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTIWcKBW9Y8RO9y4afCKJvIbF+a9wcxS5pN6QSrPCVs=;
	b=NB5moXYmawnSac6VDxeKHD7/o8uQTHhMo/9ur5ACBf+lO1QyyP9Q3nnG26sHcpa6pO3//m
	nZI+y0UWEuo2kHeCl+LLKJBCjNe71ZCx1jbyGZJl7wHfagdre9/dPAGIcXk3gP0wm+YJ8E
	thEtuvosTVMCuaVzJamaMeaZjNepx28=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rDmMjqnh;
	spf=pass (imf06.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774215312; a=rsa-sha256;
	cv=pass;
	b=GllRA9rkInJWqpRGv+HGpEf2BgZ5QGqQ6QpkYCwoYDRnAJ8Jsnm7pnbnxlyqMk22H8DaKk
	Z9nUyb32fFRUlZNBgwgmcdjfONCOWGTCo+1p2sAloaOqR3TwpmpUrvmGo275KzOc6Xcw3D
	Cc+oI08IXcmRFyHE4ROj+BPVFO25sno=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486fb990b9eso105485e9.0
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:35:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774215311; cv=none;
        d=google.com; s=arc-20240605;
        b=d4l5dv2gk5S8Br804g1HkAhi7KdYhJb7qP/DO56eVgBmMB1IX4FuLMkACk8ivU4Ssc
         XBfJGIBSAmnB4/YTi7U6UA7in/1gv7Jhlt9wsl6MUcG3MxYYZAKyAh6YjehpsoapxxLZ
         ANmq+sEUo7LYuA6cX9S4zZ+dq8XeMpYx3l09VCIHhKl+iyhUMiNfGigJRc3+k4RMCTOC
         MB4JxOvCQx2ngL4PB5fpTnA9Opci2oawRZ+5ZYToXIuEc6PicN5p5fVlg1o+L/MScEvq
         6lrABi9D/CbN1RfWy/BwL61Crvx/Ti1AUTA63NwH531XARMY9g/KtaLn7V+o5ncxHPCm
         9/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QTIWcKBW9Y8RO9y4afCKJvIbF+a9wcxS5pN6QSrPCVs=;
        fh=fP5FAL79T4C9iDo4heB9KLOna2N/5zwSpT9HpN7+nwQ=;
        b=RLGJhJnNGqQErGDdu4Td12TOBxkdJWpwvRAc0E44e/bxkSCJdLYTYtXmpvreLFhuWH
         RN5pQLv7FXQmmPICLAbLe42CuZAmNGE2VRDIvCet9rkVFmXqZANn9XgyKQaNVwuSau08
         ijgRvJYZ91POYW5g/VoF811q3VpMCZG86KskYSeon5BSX6RZfq8tm8Uh+F5hn3+ZOFkk
         j6NljpM7LNzwnmIA2P2lbGAT9gozvtzgZ0jhgaqzQzquFzavi2MtTsIYymGe62db56O7
         XmwbKRPNIEPWkfbH/C7lyCX1BGdWKeEHdgjYZzm4at0wS+sFheaLs17EHN5BGoSrTQOG
         W+sg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774215311; x=1774820111; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTIWcKBW9Y8RO9y4afCKJvIbF+a9wcxS5pN6QSrPCVs=;
        b=rDmMjqnh6EOUznQ2H8DblCooHGAQKpEoHZUXS1pxoDd4MJFrI1eykn5Zr4YUUk92RI
         W8fr2Q76j/5VhbgU7EAkVPLDchF4btT2hJLXcElWC8pS2766FSquIyKshRC0gb8QPDYT
         1IOMNcevnVPstqHFh+5UAzztew8k7bb3wzqoJ8fWYMA1qvJ/lVLlkoYmBtN0Kloeqg7v
         X+kH+EWKqzrpT6OMtndFSPcc5dIdSqPhyxqpDBdUs8uqzCII7rz5vM9FWVrPLmK/0gwl
         8LflDtob1vWVGWGsI4BX10DLShbr1vu/EsyftV9hCclkjy/Y5TCxT2B/04M9YcvGdBwm
         TMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774215311; x=1774820111;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QTIWcKBW9Y8RO9y4afCKJvIbF+a9wcxS5pN6QSrPCVs=;
        b=smvTjsx06NtmoFnSIB8NuVsxiTZfgfJSj2cgCnBIjI6nOSi4ZkvxlcTtlNLGZfwJ/O
         Dnt0XuoYmKzAqL3JJo+CCpdJ80ml8tBsgLbI8uOfj2d1iGnQW7l3/qYWGWuHs9qzezrI
         ctrNbsdlZJSGKTXiwy2lzyOlIpP1bjzZVAmpSA+Tc+uF7td3lFjniI9ADaL77E5yQfrz
         uSMLNgqT5EK48SUy47OkWwi6KfFzTju04M9i3Zx0y6JBFHcmeqe7eNyzaP4mVp3VKigQ
         UinGFpzAI3pNVwPdUnv/JfYMjYZjd7P5cJDq/gYzP5YmuiHr9LUuIT7SEo1PnrhU4pwB
         djeg==
X-Forwarded-Encrypted: i=1; AJvYcCVRq8AmoPgQ+NT0dJW2rWRHMxPD1RTEzQQHp1Zav7P3C9OVRARe9LSZ80wcX8QAffjLFOtSL/c8qw==@kvack.org
X-Gm-Message-State: AOJu0YwIEgE1fubCEz8lTg8iZDLjlKY8l7OYJSLxPqM4w4xass/zQhv/
	Z1d1GGWgiY65zhVqjU0bxlfrL5J6iQcERPsQ2nwR8j1EG+X3UP65Q/08lb8U8PULWx6lW7cl23i
	907kVPLv6Zya5Wtr97ZjG4GX5zZgiFbuMb0+6rLkn
X-Gm-Gg: ATEYQzw22HLthcsdSXEAxq9EafZPOPknqsqxQ13DjCcwQCXDSUdxVEkPAz7E+0OKUaL
	dzUxLNvBbX6WNlvfZbimq6f7Vyyxfz6AVOwfb2R6Gy+Z3sMgqCO6w40Hb5BXnCDQjWglS4ROvxH
	4OVKQPZAj/h0Q6ddyu97aLQcMZecMErKsKA8A3KDpR+L6KFUjLFYBd7WrSLWaUexpwG81yP4/lC
	W5uaOez4Kc3F2pf+KHLUewa1tvFJb5fUeBDesYULLhFUkHd17uIK7qsmT8zw1pQsqVhlh+z57m8
	Efls1Bz19Ir/LcyknlKMz6JDrocuMRN+GWUvtsd1
X-Received: by 2002:a05:600c:a215:b0:477:c5b3:7a9b with SMTP id
 5b1f17b1804b1-48703466f53mr1053425e9.10.1774215310721; Sun, 22 Mar 2026
 14:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
 <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-1-92c596402a7a@google.com>
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-1-92c596402a7a@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 22 Mar 2026 14:34:59 -0700
X-Gm-Features: AQROBzD6br59NzV_GjGVBt5AZrKUozD0iHX3HE9KQlgwQBNQ-oe36lFLzYaFGVs
Message-ID: <CACw3F50mVpnS7TQy_pD-KV=_Ekepjq00zZzdGxwLnF_vYT_M0g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
To: Lisa Wang <wyihan@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	tabba@google.com, dave.hansen@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B601018000B
X-Stat-Signature: fc8ead6c5ix9t1qixfyzkcqmn9twb7bb
X-Rspam-User: 
X-HE-Tag: 1774215312-508943
X-HE-Meta: U2FsdGVkX1/bYXA6QvFok/XuIRXxJGihOqozyB2QmNqbZDrCW1kK9wY+eVxWlmvdVEM3onyJtO4d0oIwCxxTn6FaKFxokYEuTeTj8zK4yjKKsTQhxAZ6ucV1un+lirmRJlnhTDiMsK/+HdRmUofReyJ/UGQWZFpoernblIgDvzboA2UkfLNBDeElcpOcM31RI+t6J/3gPrcqs9dK/1E0Q28U4MGnD4Lt0nqWr/W0amC2v2tcrFVaL3LXVs/wBSHOd+xzzGJd65o19kZaq0FR2H2t0Hj6X+AOD6dPDkkSuOX5s7GgGyHgSZlT65kDOVPef9V9zPN/5+mRZZGHTR4EyE35gRx/E/hzbrWG7wNQnTwGQJyc9cJ/NWzBtQyZvojzGCwtXa0JEAdUgmpVBumZLZCbw34+1cwrnX6/GtW4wweLqsU8620szMu+6a4KrA4OpdTBHQzATzYmC1EUAyFUa9q3XV7G8GPpJce2sE4ED9XEoX+QEKVY7tzXIznnd/LJK5mhPRVSViIg6VGeGyGpvWlMfMN4wJk4+ZuR6IHAb8CuKE7BvZ4nHDT0RIiinCtIvy2XNXC0e2559GOtl/gFXMYrEk5UFsJ/rE504JX9Yn1v/eZ6H3uMoNNeIRk5CmrW10mYSSSF5t+i56pFdi1CSoCPyPtI0XK4OYYw+16qDtLeV9ls2rQTIIeC6TdiktZop7vTWcQ0i2aMtxizlwejvk4mYqRUi+QNV13Af7zhpuF7lVVkTxNkl7JH2BWiCfXQV/DJaRk3njX+R4lNhJ496bbGfjNt/89az+1S5cnOxFhJHJEGFN1LDKvtaBsRo2+pVkgLiYhR37WiMnJW3fEDItzgIU/MarkCDxjp7KtBxcsZ0X3BN2x94Hc7cJrYS/a1SvjN0QSRwzHqFs7T8sF2DuDUPQ2QrulWRPUkPgpPKTODOF+yMsCE7eghhHe4Ziqy+B2ojrW/uBVKDDryUxi
 1CBlaA2W
 j6tSPrAUa7oKa4I5JFx3ed/7SroIiuQVjAEesOpp8fBg6Us7nNw8Wiq710WQOsESTIlwkumt4hdwfhor0o5dHqesD69IcEl4FbhFC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 4:30=E2=80=AFPM Lisa Wang <wyihan@google.com> wrote=
:
>
> This patch clarifies the definition of MF_DELAYED to represent cases
> where a folio's removal is initiated but not immediately completed
> (e.g., due to remaining metadata references).
>
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---
>  mm/memory-failure.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ee42d4361309..4f143334d5a1 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -862,9 +862,10 @@ static int kill_accessing_process(struct task_struct=
 *p, unsigned long pfn,
>   * by the m-f() handler immediately.
>   *
>   * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.

nit: would it be worth correcting PG_hwpoisoned to PG_hwpoison'ed? as
there is really no "PG_hwpoisoned" page flag.

> - * The page is unmapped, and is removed from the LRU or file mapping.
> - * An attempt to access the page again will trigger page fault and the
> - * PF handler will kill the process.
> + * It means the page was partially isolated (e.g. removed from file mapp=
ing

nit: what about "unmapped"?

> + * or the LRU) but full cleanup is deferred (e.g. the metadata for the
> + * memory, as in struct page/folio, is still referenced). Any further
> + * access to the page will result in the process being killed.
>   *
>   * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
>   * The page has been completely isolated, that is, unmapped, taken out o=
f
>
> --
> 2.53.0.959.g497ff81fa9-goog
>

Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>

