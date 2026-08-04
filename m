Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27D8C55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D205B6B0088; Mon,  3 Aug 2026 23:09:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1336B008A; Mon,  3 Aug 2026 23:09:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC00E6B0092; Mon,  3 Aug 2026 23:09:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87E2F6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:09:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11244408A9
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:09:52 +0000 (UTC)
X-FDA: 85062107424.09.F9D511A
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 25C0180002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:09:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ik0Wte0f;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785812990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lD7EshW+wqvTAIy0+vw88oURzXcR3MWC7k5l35qTt4=;
	b=8okP+AncR0v4pySvBukHOCnUl3Xbw4K0vJpaMYA8k69FWtOi2NgUwllg14z/yR7LYM1E/A
	TBpZT1C3NFsulR7GAMfdI9cAwxY7EDk84PiL9/+MrRbmUdXU8PJEz7jsYXONyesA2Dre3r
	ua4AgrXtC0jZpbGkGYzLEpYQJ32Lgao=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785812990;
	b=rK5QH1x4V74p/ttXJHtRg8xeEtGiKkRoRwx2Lm8LHYbnNMTlOx+RfhC3pbtZkWNMTTt1qK
	EK2dGuC23IJ+ovvXBwBAtKAV9a+T5V+Pm2+Tfk7majc8hPwqT8X4qc20EDd8CpeMw1AHUk
	fdYD4giSenDmANYWGOp2C0l/n9pg01c=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ik0Wte0f;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c1c52d920b8so586240066b.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:09:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785812988; cv=none;
        d=google.com; s=arc-20260327;
        b=JzEFeiMce7OCDoeBHO6V5xmkq6ZIS8DheEb8Xw0Sid5mi1p9j77DldF71ZnhTITjXT
         QAvBJvmaMY+qQaCxJynlS/UKIgLosYmrfIWY9szkRdDBgEI7YxJi6LbiynASupsR6UuR
         wqIpsiypRaH6wFCZOe32/0YlGo+QyOPCyHIhCmo3re9dgpgWWd4bhH3BSvmKG5ITxA5F
         seGZuWcepJ35S2V9C6sOp34xsxZFuSwvTXHv8pDZoLzyQw/zHgMPLUA7Gc/wvCqUYSAD
         3/jFDcVGYQuJfWrjqQjWX/A+8jC47pp6o6QxLzufbcgUMDPb1YYS5hmdo1HG157+Yy0P
         KJMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+lD7EshW+wqvTAIy0+vw88oURzXcR3MWC7k5l35qTt4=;
        fh=yIRPvH3ANGOwiB85tCeEXB63Ave+xy42bYlQyAS9rnk=;
        b=rj8y8pLdQ/+/ExZrl9Iueiy4DE2BjFZj/wiCADD21RzstLxvTTuKY95XQe7kny6bsv
         gRxW064d+l3CvDWp1lVYnNmVTSC/FKSX56BJmLSLCzewA+eRkyCBsggGfvMxwoAQ7QYI
         Ndqzg/ZE22eUuk3hN47BvlgV8nsQAcJQv/vZlZjksog71Q7xf9OtOiG46fXryIRkz0tl
         6xlA/KRQprQTchcLK0Id6Gi1khv610AlVe/h0lL6/wF+a3KgAnVFCW5wIetUdREC1xcM
         QWjizOwstPtCRWAzK/Z7M4dKpy7ZOUmurLUdUM+b9hjMj7CexPIrnWKr414GeTgVzM0G
         96FQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785812988; x=1786417788; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+lD7EshW+wqvTAIy0+vw88oURzXcR3MWC7k5l35qTt4=;
        b=ik0Wte0f5hZQygHRS5uhtdypE8Zkzcai9VUf7+H0PM4KnIp1N+4PpGYPZNpwlbiVHd
         P0TP3eFOJcQykMJB0Q3ZHRA2W5pk6A2UrPwNt8B9tbrg0AUtRkpYMFyaZjVUr8D0BohU
         IFl3YxT+j6b1yPmXN58daAtlAchnwz2GQNyNwpDZ1kjd2wVXrAHMwZFdqBb9H9nimeGe
         WfjOVUCVWTZ9wEHZaRjv4cvJEa4k1jVN/khFhgGF3x6DQnK0oeriT97nq4vmLa6Q0RoX
         l9ZK0jKB6A+xIUdOAUTUDhwhq6/2m9z9S1yFybea2rZXSISTXa+yMO1onpXD+IVKEWQ3
         UEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785812988; x=1786417788;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+lD7EshW+wqvTAIy0+vw88oURzXcR3MWC7k5l35qTt4=;
        b=GDf/EfVJ614AvPn5GCRrkX6QJodhrCwteVcZ7XhKip6f5zlYxGg2Anc2XAvpsMLtU2
         tSalfai26UH7iPlibVTw702Noj2xo0ke+uOqswecEU4Q8R0QAMMGvMWcIPCIrgWAMM/O
         le98aotBmPAmvOMYIw/uZbwasO2glZKwZYUmA23eE9xcufWGKhz5fcnNDQFyyNJnxxA3
         COw8UHFCRFtFpfmaILzft5MS+ETnYBeDg758Bk6RPDZOx/u4okn31kPJ1NbBX6TcK2ik
         5NK9fKUhL9KfCMEidL5yPPgvM4q4VvGdQf0KiqIMFcB9MRo3b+8brig05U9HEfNJAc53
         3RCA==
X-Forwarded-Encrypted: i=1; AHgh+Ro7JXVfzdEfh3zqizqHQBWIvXj/3Mkr0Cr5dLPEwkZ6XlFcCJZcPwZkVB+SGvhzY9G/fPhLE6p/Ug==@kvack.org
X-Gm-Message-State: AOJu0Ywv+9+ab4QQ3661FTdjkiKa9qZDoQm/jVabd/wusvuKnmPJpbZH
	GrwOExUXx6zhyP7QfE8MLH0oPNn12XYnHH6Vv4PfjIbHRDaa5hSmQGx2H65RQTckbIp0PNY/G7q
	NEMTXIt8PtBnZ2dQ8FKKgO0fQGbntmBE=
X-Gm-Gg: AR+sD13VYZmrdoaxvBuLTSfZkGT94HZulU25m4XZocdAb/Pf7XsJikuXXt4hf5pr8ee
	vEjGTCGOeZ6dzCBE3BaU3vleWVqYGZfi0iR3vvJCqSBuV/piOazNWtzwNA/hHyPodJmZi9EUg8Q
	iRdAwYlv8GeKrujatkx854Bi5YtiMj5gce2GnBP0CpslhFJRDhftckmBFzu+C6zZO6Ye+x3+Isl
	Z/EqfBRANJgBg3LB2/vy4Ut+JyjnrWjs2aS5EfQ536yOz/02ZsmFVWY8bbFl/tPfsXjQTaQ0M//
	AewSlFsuIP+k/L14z0f11mLp8JY/TaycrfPVX9Ao9MHzqhLkQVKpX56fXhbDC6MYBRYv8yrfgqH
	h6w==
X-Received: by 2002:a17:907:c18:b0:c15:a1e8:c141 with SMTP id
 a640c23a62f3a-c1fe8205b11mr1194078366b.30.1785812988580; Mon, 03 Aug 2026
 20:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
 <am28pV2PEfHsi4p-@lucifer> <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
 <anCtxQE5hDUH5N6a@lucifer> <DKFEUPDED2AF.22PKCFTWTG6G5@nvidia.com>
 <CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756BvxMQC_MCn2eTyA@mail.gmail.com> <D6EE6133-8B15-438C-8616-4639710F8973@nvidia.com>
In-Reply-To: <D6EE6133-8B15-438C-8616-4639710F8973@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Aug 2026 11:09:11 +0800
X-Gm-Features: AUfX_myZp7suhmCghhsEDX845pFAgs6S7SpJWDhswAN7FOhlW09QWQBizRnPBhM
Message-ID: <CAMgjq7DjCVxLLXU15ue6MVrqvWqW6goED_0QZLQ=USNJm9c4TA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside __folio_split()
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: t4kw7suyawang7eeidcqfyape9yp39mb
X-Rspamd-Queue-Id: 25C0180002
X-HE-Tag: 1785812989-16576
X-HE-Meta: U2FsdGVkX1+8ZPSBIlhR7B4BIkmzeUF+p2GIbpPhbC1Jy7ZDl1Yomy9dPnTxNqhWtfRlV/kc6psN/JOx3rgdrululrHUlufKMFIwdDXsAmks0myu5qPSWbx8wD3g3ziD/YPp1kovqMbH2m9dYpak1DsO0umQ7KgoRnsNpJmbcDhGjUfz/HfXUYCIxnBx9NPi1OwHDRv5pU2S9ijc+JbFhhQSFjqjIKHZ1E8/FdWkyssdC2SULc+YJYl2p2yeG5v4T9ye1FANFKz1KAQTS02j4aVMKEhNLKPiuViMeqMinVsjdT3KJfGsOAjc0qDl6jd5vPZ7XsC0bU/xTQAk5dPWfqtW0vkRL54j3XeoWnCHGjsQe6FlgUFrFkUs5X5YQPjtycwvevZODVD1qWv6qi9OZq8Gq+fQ2OmI/nN6KaO4YwTx3aCRqkXfoix01ixyojKdCiabYK23XSMFJYGWSFA2uqZs2BZy9qvBx8FjENCgQJ1EDwgIxhDQBYAAHDOmr7VSe+skNf3vwXiv9vpwWS+vLpkDHGwbuOdt9GSu4J0eISvWY50nH5ytDJ15aULQuh7qLEoVTY9/VS+AG5dbv+Z3MmEssh9Ic1m+bKo609s64UcorG0ip5Wb9+fvF+n6LqRSfRhaNIQNtXP6iamJXc9ElNQLDHyL+kd1vhIILx42G2eOlmtrr5Ozqx+HBhpjOVsMjkxZmxGp/gIUVgqt6tIRwev0m3SRdSTC3NTnVJ9Jo+HOQzwRPo4ocn0buI9eKPCFJ9GuD64sQ/Oq3jL82wCppag16fUgSVh6lU6GxNP8HbVDgyMMIYRvzcrdFR9AUb1FNAKZ65iVxi7uZKYsYOWb4lTUTeV4IMEw7Shx88g5kJyWhan5vqI5aO/HN6qTe1ZhXnc3AYFuzqPaWNMWBhPUX+zTdU88A/br1q7kP9lB5vr/+dpuCoIr89RBsD7rihyrnHXmoKpHy2kMQ9cAIrR
 I8N8WDZ6
 yOJM1xJ78R4YGBYCryA3201u+G4ypV2kD/LQ+KzjLuhUOoyIBH2lLOzZv7RLdewPTsrtv/uKEdJGzrUc0Eb1aTGtoFpxy3hcuWqaQ/lzASWK7WDrVBy0VQ4sTyn3oCUHAAKRFY2Qiv1fuGkXcYtLGFfIBKW4nxajttEqXg6n+Rv4ywFsm8gaZ4EEjV4vRo5CFdMUlxNMdMvmgx8258mJlPfsyPpRhhcuF3RDBKbmEiEvaFEKngai2Y+VuiiIEfNFy5rcH9L/MDkeeOTYay/yM42ketsNo84Ce4Q3z6M7hYoljL+TUMZ+Hjfmdryqg0L5XEDWvLsHeq3kn6CAAEOqxTdegN9xHV2wJnuDcjr+BDUzisCd8yu7nVHqtCnVucB7U+0LIU6JOE0SC7ggp+h1B0UXY1vt/t7mBwmuqs5wuMt9Gfxe9Z3nwgvB5EkkyeGxckAtMZS03fqv8fznTB8KNorrwzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 1:55=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 3 Aug 2026, at 13:25, Kairui Song wrote:
>
> > On Tue, Aug 4, 2026 at 12:53=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On Mon Aug 3, 2026 at 11:07 AM EDT, Lorenzo Stoakes (ARM) wrote:
> >>> No __folio_split().
> >>>
> >>> Comment about cleanup.h really was the whole pattern of goto xxx for =
various
> >>> levels of unwinding things.
> >>>
> >>> But really I mean the folio splitting code in general, there's a lot =
of
> >>> massive-complicated-functions with a million things going on at once,
> >>> __folio_freeze_and_split_unmapped() is another.
> >>>
> >>> Feels like we should really have this stuff in something like mm/foli=
o.c anyway
> >>> too now that's renamed :)
> >>>
> >>
> >> I agree that __folio_split() is handling multiple cases, anon, shmem,
> >> pagecache, all together. Do you prefer:
> >>
> >> 1. split __folio_split() to handle each case in a separate function wi=
th
> >> some code duplication, like xarray for pagecache and shmem,
> >> freeze/unfreeze folio for all;
> >
> > Hi all,
> >
> > Do you like a __folio_freeze_split_unmap /
> > __folio_freeze_split_unmap_file split? :),  I'm asking this as I'm
> > currently trying to sort up the mess about swap cache in huge_memory.c
> > and found it will be much cleaner if we move file related code into
> > __folio_freeze_split_unmap_file, and let __folio_freeze_split_unmap
> > handle anon and swap cache, and then saw the discussion here. (A bit
>
> Sounds good to me.
> Maybe s/__folio_freeze_split_unmap/__folio_freeze_split_unmap_anon/
> to be specific?

We will have to deal with clean (not yet added to anon) swap cache;
I'm not sure if that counts as anon? I'm fine either way about naming
though.

> > more detail on this, I think we ca just assume we just don't need or
> > want shmem swapcache split, because shmem swap cache is meant to be an
> > intermediate state during IO, and shmem drops swap cache once IO
> > compete, and hybrid half-tmpfs-half-swap state is really ugly and
> > should be avoided competely, swap cache lookup is still fine for shmem
> > just make sure the folio is not in shmem's mapping).
>
> The reason looks good to me. Can you remove the shmem in swapcache TODO
> and firmly say shmem in swapcache is not supported due to the above reaso=
n
> when you split the code?

Sure, will do. Thanks!

