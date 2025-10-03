Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78634CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 23:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67838E0007; Fri,  3 Oct 2025 19:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18838E0002; Fri,  3 Oct 2025 19:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D9D8E0007; Fri,  3 Oct 2025 19:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0F298E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 19:03:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37C3113BE7A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:03:53 +0000 (UTC)
X-FDA: 83958332346.02.89CD8B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 094CB140005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 23:03:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UT2k8STZ;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759532631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1mX9q0HUhuGjJ3qeJeAHuR8jHU0sH234HBoduGwjp8=;
	b=KOagI389Phx0C6OFHinewb1zWoKmL4NcGcEJBCaCxhFOPs8bGIvskMo7dHuo1NnnuO5HZt
	pGxfHiWSCLzbnPqHp4MpN5lEDD0FGli8YfN/r9upd9FN31svKz5C95hwtx4InJH6y4ZjBi
	5p8gzlaCF4YHapBFVYteTY9CqzJ34Sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759532631; a=rsa-sha256;
	cv=none;
	b=OH5s08PgkkoB141LXfODBTR4SCROqBaZsaBz8YV2uckeGqKrZdg8GqGJmY/KVr1cHyRuRo
	XR97krc3RG77ZZJAkwwwa8Hj3jMTwr4IB9rwQNTONnJY19I/St5j5coQwc4QwFirbVwzE/
	aYVOvsEy+QK5Nyca88bqPzgEUto/pqg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UT2k8STZ;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759532630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J1mX9q0HUhuGjJ3qeJeAHuR8jHU0sH234HBoduGwjp8=;
	b=UT2k8STZI7MijQzPa5r8ImLliGnm9lkY4qKve1T84TPiyE8FUE1ZWXGU/Ek6OYIyrZYFpe
	05A2SGYZWpB0eo1Hw19awY1qmR51/a6fLDjGJE/E+y2vq7PzqbaWYVlZK/8UZjQ+3erwM0
	k174Eef/32qqzQkWB8AJ2W4x89J+x0k=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-BUEQBWilMSadBprgjR1LUw-1; Fri, 03 Oct 2025 19:03:48 -0400
X-MC-Unique: BUEQBWilMSadBprgjR1LUw-1
X-Mimecast-MFC-AGG-ID: BUEQBWilMSadBprgjR1LUw_1759532628
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4df7cdf22cbso98831801cf.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 16:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759532627; x=1760137427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1mX9q0HUhuGjJ3qeJeAHuR8jHU0sH234HBoduGwjp8=;
        b=DsIWfuleiM7y1uQYGTjyUJc49tHxjmgDdz8kMjt90DpxK1FmLVmRvuGJiHxLXqd3cU
         uy4yvOjTfDRelru9omkBdPXJlcrepTj0kI2BlbkxT7ivZZ4BqkSA+WtahBGzNA0im8WK
         GE1i7CIN35DwmkBKrWugEDGgwQ1puwT6vHhTwH3e5h23mU9GxeasDyidFqhbNgRNLrqT
         nKPJWmS7QX+Nbesuycnxv9zoxuAoqwUYlHi4Re2slpyJWXF857N/SA2/Pg1oebJ5wXaM
         HZNZFerH+Q5qqO2LdxO0rzXQFxS1T0tOKpK74hzZM3I3xWGEeuBpLS+mGIDpEo1ry3Td
         Jq0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZC4hjDh0qXq5VvyjfiARs+nxDe4iWIETa/1vAJ95KCiQcaGDDCzy1xRHMk7FuY8t/PsI0t1DYTQ==@kvack.org
X-Gm-Message-State: AOJu0YzH0eW105ZJjKbLIthfKRnyvHKKPv6TDxVorTKVg24jnHvdmynu
	oFurXuWn7tLCLGgiXkpEfpjMZzP7M/T2VBr6tNaanab6pK6XlMviHmPPzPTWXopLUKCy22FyW2O
	g3EZQu1tYW2CMwsnqE1AqkqdFuSIQGHI8nnGwEupFuG+WHB3k2Fdr
X-Gm-Gg: ASbGncvai8qR566dAZwZf6laC6c4ju9Ma7iN76G+zlBjQ1KPRMNKwg6SJmhPM9OAVXR
	4lvzWp+FDqfes3ogQEWZMPhMwRJcQnr7+9nTk0eOkDD4RQW81/0hMKIqRY7xhNbenjJqnIm/AEC
	BFsvI7xTElYY3bu6V5MpN42uxMpMpX/9+PeLy5eww+r2fK1GS6suKPVCsBsaVEsN1WoJUh8uRNp
	ZMzBi+4amw8VqoC1mukx3o+6QuAlTuIcgnP33/HK52Jf9/7Aq700FGAa8KFKE0CasRY38+H9XuU
	KuzEnXnZlc2t4vHtiO3GhzFF38BfHseIGUfZ0Q==
X-Received: by 2002:a05:622a:104:b0:4ca:eda6:2692 with SMTP id d75a77b69052e-4e5617c2e0emr113265071cf.10.1759532627490;
        Fri, 03 Oct 2025 16:03:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFto6BLSW0ZwDSLjpU1b5D46QlGKRDpOtiwnWIzY/nDppmekSLAsTTZxxUHp42FlkcKjeDlTg==
X-Received: by 2002:a05:622a:104:b0:4ca:eda6:2692 with SMTP id d75a77b69052e-4e5617c2e0emr113264461cf.10.1759532626946;
        Fri, 03 Oct 2025 16:03:46 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-87771129478sm527876585a.1.2025.10.03.16.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 16:03:46 -0700 (PDT)
Date: Fri, 3 Oct 2025 19:03:45 -0400
From: Peter Xu <peterx@redhat.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
	ngeoffray@google.com, jannh@google.com,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v2 0/2] Improve UFFDIO_MOVE scalability by removing
 anon_vma lock
Message-ID: <aOBWUcubhJH9hedJ@x1.local>
References: <20250923071019.775806-1-lokeshgidra@google.com>
MIME-Version: 1.0
In-Reply-To: <20250923071019.775806-1-lokeshgidra@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B-E991gTh0feCLr-hfiBhoJyvx9Oj8HZEOzWWmA_s7E_1759532628
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 094CB140005
X-Stat-Signature: bkdcjcb7e3w8wmq3aptxdfi9cxrzs1tt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759532630-225887
X-HE-Meta: U2FsdGVkX19wAN2Zwwlz2f+nZVqgaR6DRszipqSuXTz47xWjaNiuRyfCeHonaxgS1sw3zlnILn1qbFYagG9br9lBP6o21EbBjrlXcIxUefONzgpFQbdMHgv5nrjxy5sQYsN4RrZflxCl/ZOglAgI1vPOvy4EMxVEhaM3v0djPwpgLNjrqAH3eQEfl0Gsldn9r1Yxjfvo7GllE7ni34p/ooeAPfobl6POYz9wMHPucx8cL9l5ReKdUiTyKvic0HD1pWsvvgCbFihwTCW+Klkd/JnK7C1QgoW2eJh4vKJhze1bVe5OwhG+iBsx1MdJOfhslqqPDfvPhAEGK8hXKI+TxSDy321uRkbpjl5jKq63RtWQCTxO0oroUyanG3pnUh2+6nO5sDgK8kDX9wzkAItfBZ63tpUYRDGRUN+qBSsudPFMATHIx/ZXbkhXBySduPo+M7kiVZyO653f8gstzK3U5XzuXR0fCRcsMaj3h41Vhil6R4HUbHFOncp0Kh1MP6CaWCyURAWgDZodCURlUAxjp8ybQ89AR6RYQT6ZebmIi9An6WmfW6OKmW5om+aQAentxL3tXIRKAcw3ZAb0fsiVDNwcjjNCb1WaIDGvd16+/6ECcfHbKpQC8DMwu2Aj51GtOKINTAKpQ/dcmThQRamOqLFq0y2gZZypT8o4mXmlLOtUg3wCB9EzxR1yh2o6soKy5h4sqX6aBBDvi6GvhQypa7HVxrdN+hdL9qidvBp+68L+5iOayvq1c+yABEHyEfgPggYKyQkXkkigiwW1uD9HPgdSrdyM/r2NDcuTZBuVvwczD/z5fDaAiCs4+nwCg2w+w1iRBIUrecYkpCNXu92gPrLYYTzBcuvp9lo23eVv0Sade/mBdj3B+qpXxebaye7+BkRCYik8P0nui286Yby/7zJgGHhKmLzO01LEpUipDxHdF72fOjJLWjY0l8G15ofKN5+gFhFeKciZx9HED0x
 qr7D9c1d
 DKAKIBCYs2ws8EoSOEquGaBdYNFP2DyPAKNb3thfWUcCXQ80Y2dgwjmNU8fIJY2g4y3sbS2VP+oqBm2Rn1gDr/3hUhA8GNcT+jCWp9FcRNOk2dk/ipv6fl8MrAPkCO+OgKifxGDprsz3bmoJaX7GtUXrq1FNdNARExGoSe57iuAkoCbZwqHXxxOwgU2COhhcghOxDMsVgzysHYiYgWkJrfaLVyrY2SyLEDuH4zpyXCm7xR9vCGA+VucNUahdRu2Yt8hYY63kKbbe26iIeh6vDIwgE4xCJxSnsdlDb7Sx27dRIR9goP5EmI/67EGrCJpNK49mZT7JGlsbCpUYy5I1m6m6MA5+6UTauV9JWhiBdHbHw7J5tk+rztjCGtRg/TPeJWlOZpjX5vyEFNv1ZC/+nqwuj0aLRu5q9WiYQap0tDQHpbcEgZhnhP1iKXIVvr/O5T1qkZyhpvzYRbl3N2fZWXYYIKPSeVJPWRk32uBQAs8hJnFgSvyF5/TSbKsLUmk8EBwdIJ0s/aDReb49C55FBzD/ZLnIFTBBmUthFhAx1YWOxoEoJDURNTYq9o5hV0fCudQegSzuloyrFvCYcv8Lva35/M6GxWX4ZHgHB1R+oOtxlGRReHzYmBdde5dKlY00cOlRx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 12:10:17AM -0700, Lokesh Gidra wrote:
> Userfaultfd has a scalability issue in its UFFDIO_MOVE ioctl, which is
> heavily used in Android as its java garbage collector uses it for
> concurrent heap compaction.
> 
> The issue arises because UFFDIO_MOVE updates folio->mapping to an
> anon_vma with a different root, in order to move the folio from a src
> VMA to dst VMA. It performs the operation with the folio locked, but
> this is insufficient, because rmap_walk() can be performed on non-KSM
> anonymous folios without folio lock.
> 
> This means that UFFDIO_MOVE has to acquire the anon_vma write lock
> of the root anon_vma belonging to the folio it wishes to move.
> 
> This causes scalability bottleneck when multiple threads perform
> UFFDIO_MOVE simultanously on distinct pages of the same src VMA. In
> field traces of arm64 android devices, we have observed janky user
> interactions due to long (sometimes over ~50ms) uninterruptible
> sleeps on main UI thread caused by anon_vma lock contention in
> UFFDIO_MOVE. This is particularly severe during the beginning of
> GC's compaction phase when it is likely to have multiple threads
> involved.
> 
> This patch resolves the issue by removing the exception in rmap_walk()
> for non-KSM anon folios by ensuring that all folios are locked during
> rmap walk. This is less problematic than it might seem, as the only
> major caller which utilises this mode is shrink_active_list(), which is
> covered in detail in the first patch of this series.
> 
> As a result of changing our approach to locking, we can remove all
> the code that took steps to acquire an anon_vma write lock instead
> of a folio lock. This results in a significant simplification and
> scalability improvement of the code (currently only in UFFDIO_MOVE).
> Furthermore, as a side-effect, folio_lock_anon_vma_read() gets simpler
> as we don't need to worry that folio->mapping may have changed under us.
> 
> Prior discussions on this can be found at [1, 2].
> 
> Changes since v1 [3]:
> 1. Move relevant parts of cover letter description to first patch, per
> David Hildenbrand.
> 2. Enumerate all callers of rmap_walk(), folio_lock_anon_vma_read(), and
> folio_get_anon_vma(), per Lorenzo Stoakes.
> 3. Make other corrections/improvements to commit message, per Lorenzo
> Stoakes.
> 
> [1] https://lore.kernel.org/all/CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com/
> [2] https://lore.kernel.org/all/20250908044950.311548-1-lokeshgidra@google.com/
> [3] https://lore.kernel.org/all/20250918055135.2881413-1-lokeshgidra@google.com/
> 
> Lokesh Gidra (2):
>   mm: always call rmap_walk() on locked folios
>   mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE
> 
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Harry Yoo <harry.yoo@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> CC: SeongJae Park <sj@kernel.org>

FWIW:

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


