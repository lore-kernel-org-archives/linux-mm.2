Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88B65CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 03:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E636D8E000C; Thu,  6 Nov 2025 22:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E130A8E0002; Thu,  6 Nov 2025 22:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D509C8E000C; Thu,  6 Nov 2025 22:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C21CD8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 22:07:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 57754C0297
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:07:52 +0000 (UTC)
X-FDA: 84082326384.07.CD370E3
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B7F740005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:07:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B7IG78W9;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762484870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBCUg/9XCUiNk2sm5BPZW1kXc1XAzZmmErC9z5fdCQI=;
	b=zqDJRT7+AOcNvSdC/3xN2IpLrPq7nWz/FEX91OfMoRwNzGbd+H17LiB2TlbWNnjnUI4wz2
	5bwiqCqExlbZAJ49cF5QulJhIrnW34y12s7w79lLasxLA6aIQiIi3/LTDb7/PVQTtZHMrC
	QLeqBjjgmODfgK7lhUBwlJDgVO/ZTQs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B7IG78W9;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762484870; a=rsa-sha256;
	cv=none;
	b=DzwB+SMIKuLmwFrrH4I/Ug59aYAbTr3pKexU+0HT/upnQ0W0pDTR3pIuSzN9Ong8bB7iW7
	Y+oEWrWE/Y/D5J4XL1gllwjjDg/WlPbYS1zwtlf9SRs2FoF+UMnfqlE+P511LNiX1q95yr
	d06G3UtXYYcloSvIjAoWWcTqbkOtEho=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-795be3a3644so1930886d6.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 19:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762484869; x=1763089669; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mBCUg/9XCUiNk2sm5BPZW1kXc1XAzZmmErC9z5fdCQI=;
        b=B7IG78W9HI4yXi9cDU5zguQEmhi0WyDwOIvMd7XxC1kayvd5f7GhGX3M8/gHHcx8Q3
         Nl4UXiOGws09Y9VhxAFZvyOGpocHAVmfZltxHwSZEFgD1NqjBDTII4lGLUYThaxXNsbs
         QTdXADjXNvW89PQwL17KQLjAGmZuSGQXS5OueLry2VuPtXyv6sVBL58BF2Mo+xif1MRg
         R9AfZoBQ0iXszOEejqB2gPuNvfj6Mi42whmwP6NPDq60oqjlehiBLf4eHG9fDE5w00bX
         +yfPEsDVtq62TUhL0GvUh6lGG7VuSuBF8iyaVFj7ocWbrcwHzUmD/FjmYM3xizepodFw
         I6DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762484869; x=1763089669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mBCUg/9XCUiNk2sm5BPZW1kXc1XAzZmmErC9z5fdCQI=;
        b=fvDvpYH9TXYzc6k6CA/SuTlUsQLHmqs2RdwUr4yZu/nhFDVcTXEBSedYZeJoEnUPLg
         lfZWFkvnqzNCA3XDDg+XPIKbnLJ0gNjTRkl8RhHpnw9kF3GTY36fSZALK+HHvUSBoMF4
         vrExRdSegLovsfHXwqVezFgTz5/dH353+llodUzGtJ3ytu4LdKc+nlq3MbMQzpv3li+7
         46XLxJIzYWqcg+UZt/dhCCxE3DkTZaM6wto68ZGcfpLBOjbP0/qqSK3FEaq5iXljKhLj
         GgKmm0kCAvIHK6gRudU0rJTEbh13Hxt7yxjeyPeTPZdj0lbn+qo3EoSEiNERMvcVYhP5
         dApQ==
X-Gm-Message-State: AOJu0Yz8/MX63iKEwR5eavE7et7t/OHj9G5UKjsabs0yi/yCQv3N0CCH
	kBBUEjs4LEz24lrFEslIU8tKs1lowdXPAUbleYC/AmQBjZZ7Zbwik7kl7TyowTx39OU1yOTu3Dj
	heY8qVPICIFxQvwHTCR2WL3djWU+5dEY=
X-Gm-Gg: ASbGnctztZ4FaeYsN2hthvjNKNEh0xBSaOUjjEftv/gXuK1Da0Jwt4URMmUYH2WfqC5
	XBc9MPZkbEifMBN5SK8VuU01mnZG55Yyn+J0MF2vDWKAe2O+uXQZzf+VnldJDKTBW0Ymu0sGkET
	qtAOIA10H2ChGqB4HVQBevvacM7MgkISHqH1ito6tqGKswzR4j2OTsiJxV/6b5Z2r9cUhyO1prJ
	+7k8W+jX00bQsS9FQqAsJ/rNI41RWlmHzk7sW5mCMLTloQD2d+eDAG7tCnVDULzJwtp0Pnvyv69
	KyIdOPuoQnOyZPa4jZhOLZgX3VA=
X-Google-Smtp-Source: AGHT+IGAVK/as/fsnQC6Rzqp5n8giqY9RSCAVH0zLL61+rGwA+Bbr+alJLMG/WG+f+kye53EtjwheHwxoumU1v/Fn0M=
X-Received: by 2002:a05:6214:240b:b0:880:4c73:9e3b with SMTP id
 6a1803df08f44-88167b08793mr23624806d6.15.1762484869338; Thu, 06 Nov 2025
 19:07:49 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com> <20251029-swap-table-p2-v1-13-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-13-3d43f3b6ec32@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 7 Nov 2025 11:07:38 +0800
X-Gm-Features: AWmQ_bl9OdAJp-MTk2PhcU5P1TAkG1rr8LH-PKPTp8sGVlXRVHPN5AzCsOi4VdA
Message-ID: <CAGsJ_4xquj2Kbc2qu0vtY6Q+-q3sg56BgKEdPs8eHtKxLBk0gQ@mail.gmail.com>
Subject: Re: [PATCH 13/19] mm, swap: remove workaround for unsynchronized swap
 map cache state
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
X-Rspamd-Queue-Id: 8B7F740005
X-Stat-Signature: qxnaudq5gpqsq46zp45axg49nj9az9wd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762484870-656519
X-HE-Meta: U2FsdGVkX19R+PqnRRaHzFZVNAnr2jg1boBy4Egw5TpU57PxvpMn/KkTc4F9jJKAGYm7LfbRI3RqWvf3eXpsWUgsztgIMX8I7M/BxpTTrUiKlQcCQvOkzWV3RlU4wolXmgQQWQPtyGkdYHMbrsat3haNFV/AIj8DlSUIbczCMnyXDOc3vqWGtdEd5uK4DoYr5HoYMKsJ0LEwaZIPvftF7dU/kBzGMPobt9UJf4fX0kCDM8RmXJvSt2jrKKUchdiD5g2NePfrNNTmDhdPfl9PM1fhztUz6hll6UWIkEx5p1uLGt7vtmtInV2dxgFnPQGfai2+/WdMGbpv/bTLmfyhyHOauP+33EKbaWUgwfXXJ4HnGO9sZOelFGn0eGjL2RbLm0WCtKmwpYkJNs0Cv7lC/YgR6V2dBywV+wbp2rvcH8pnCy2QsP/J6BCnN3ZrbBpJ8qGKrv/7gG0TRqtobzbhY/GH3OjOpCKrgA9ZYfNuZ/+4cqVJ92oaUJyb23rYRCDqjuM8kVgXxv/pWRnt8slzBO2UcgFUKWXSu1aDKdWib56+QQ91uIm4OW40wUbTLVPl+8c87+k3Nih0cfOD4WPteEeRg1DMyVALI/ZRY/5mBaLcbjm56k0dOlof+FrKNdJtPXWkiDURh2mphR3oYpU6b4SCPgaGkypnFi7+3z2ivYGPP5A2SN3bnWPzJ1kHoc8LKl2TF5f1/GYIaGZ7p08Q66LOeyZc9dwoVhMoTfbj8twhJDrjJPX9NzF8QzbhTRqhAzPCYmabyclkaTG3LehGJ9ag4qcWp1Y2o5q6Bu4Mli2W2Idlk0R6Ez7SF/JtXid8o3OgI3tA9KUYDgHfOkQBfayrGPdMnEjkgqdifKHLQnFuv/aHf9l3f24GRenlXJbRjf9+SoyJrCFJlsRL4PRxkU+MOilBdPOft9zLM0tPpRnE3v5WDoVVhXOP32l8iWK767z89k2AAH9uJ9eSrag
 g9/gGqKV
 zF11cxck1JloT0RemhNr+4HRQWsQUVaExqOWENTdpWTNNgM+sJ3h0mgItaf8bL6/a8NGwyh9O0R3L+eYp3CVe5sV5a+Dma/p+IRVM6gW9TqYSlUcsf0p+RIk7j2pUaCg/cIRjb8lsR1eVCFrvmeh4z8V1GDhEWNYVPyDfvVy5yEjIPX5w0VXXd5UZPeYlWfFfBt5Qoaxdtc1PuwfqGGmODGVUlV2DQnhNxtWmhbict0uHgNbYGDsNVs879RFhrHJWa2Uvn+IeUibwOcm9L4M+zXkxLFzkAhikxZYrDTBobaFLiX4G9hedgDxJRTXbjAK7X5aROmh8qWkQ6N2f53EzubZ2Hf1PVIpR3u8/JEK2HPHIWBc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  struct folio *swap_cache_alloc_folio(swp_entry_t entry, gfp_t gfp_mask,
>                                      struct mempolicy *mpol, pgoff_t ilx,
> -                                    bool *new_page_allocated,
> -                                    bool skip_if_exists)
> +                                    bool *new_page_allocated)
>  {
>         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         struct folio *folio;
> @@ -548,8 +542,7 @@ struct folio *swap_cache_alloc_folio(swp_entry_t entr=
y, gfp_t gfp_mask,
>         if (!folio)
>                 return NULL;
>         /* Try add the new folio, returns existing folio or NULL on failu=
re. */
> -       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_mask,
> -                                             false, skip_if_exists);
> +       result =3D __swap_cache_prepare_and_add(entry, folio, gfp_mask, f=
alse);
>         if (result =3D=3D folio)
>                 *new_page_allocated =3D true;
>         else
> @@ -578,7 +571,7 @@ struct folio *swapin_folio(swp_entry_t entry, struct =
folio *folio)
>         unsigned long nr_pages =3D folio_nr_pages(folio);
>
>         entry =3D swp_entry(swp_type(entry), round_down(offset, nr_pages)=
);
> -       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, true,=
 false);
> +       swapcache =3D __swap_cache_prepare_and_add(entry, folio, 0, true)=
;
>         if (swapcache =3D=3D folio)
>                 swap_read_folio(folio, NULL);
>         return swapcache;

I wonder if we could also drop the "charged" =E2=80=94 it doesn=E2=80=99t s=
eem
difficult to move the charging step before
__swap_cache_prepare_and_add(), even for swap_cache_alloc_folio()?

Thanks
Barry

