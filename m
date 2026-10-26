Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91346072CF3
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PTdOyNkT
Received: by kanga.kvack.org (Postfix)
	id D861B6B05B5; Mon, 26 Oct 2026 09:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D816B05C0; Mon, 26 Oct 2026 09:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C126B05C1; Mon, 26 Oct 2026 09:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A14CE6B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:39:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 217B7C0720
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:39:00 +0000 (UTC)
X-FDA: 85364883240.11.D47DF7B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2973E100009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:38:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTdOyNkT;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ia3WxArLDuCPrww14fZWiIGW/gcvNKfDorKU73bhn0w=;
	b=6l3B4L4Zn9Gh4neYFF5Za+UiQZ2o0c/EQr7CxJXcoZP4QYPYIcbCvkJHkG7nAoZR2z6zVj
	rlp1Q9PYYkXSr4QHKxxy3xiahOFR4hnoz8iiZa2rvcGZj1FMzorq+hwQEDAInSdz2lzENn
	FaNAc4P1JCmDabGToK3+nfuIUblqxM4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PTdOyNkT;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793021938;
	b=m5fUunbAJXiPUv8f9iAvU9XaivFiWBUya/HbqGvTLEhUSx53z88Nm+k0iH5C3kPtNRy3hE
	zbsTGY98oGqK01MgT7g6znc/eMFALGdE7V11G46HFcI/OHRxk6qGZt7vxfwq/Hz5w0xPMh
	7bXbWP3p01jpprOuvA1tBlZhOOBdL7s=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c247f6687dcso452372166b.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793021937; cv=none;
        d=google.com; s=arc-20260327;
        b=SEPN5rDiDiDkr6AWa/zGlLeGBVi0PG9MMzRYltq/DcFFOckRgsh7DRPXYFlXZGpbUL
         I6dWlm8y2nO/jNETT237e/1mB4j7s7FlYiBeT1Qw4Gf3BxLEAwDfMSuLFTEEiFr9/bRr
         OOr8k9rBa4pn4x9IQ+wpciftPQdpontG6uAnwvtSZ7lAGmbSFaDUCbub9DpQ29vNghRr
         5ucGGvEK2fw0j1MzVsD2aVFMFwxpVfb2YHxY+i+75vZGnl3nJaQLcpgli9IXRfwoDVnh
         dLA3AS2v4ZYyiHSIH6GKfUMD81Am8rXkh/rID01MBisIS8PZYCPZ6APcREBWoypOdibF
         BK2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ia3WxArLDuCPrww14fZWiIGW/gcvNKfDorKU73bhn0w=;
        fh=7Ze8Qtfzo8TaL0khuWwPxzXYQJNQxzcigQASsBu97yA=;
        b=PGYmMUYQ85FuWYvLkaIwwl/561PJwoeR00Hk0S79QkyEb+29V0c246dK6uZdoD3Oz7
         eHRmckQMSDENvZnvML5Zzsna3xMryiJ8/sVeWsM5W1k+NEG/yqrxh54PGpgX1nS+HaYT
         K0pEQcsZjCmLOPEtowbjUD71aznmt9kk0bxfmxW8IUK6UYlqU8grb93vg+p4UAJnfhkw
         JJf2oyA+KfapYwREfd8cVrVbnihqsgat7zpmBS6XCseD7e5XWaPv2Srs3n798LflMBPs
         ymK3XEhcYSvFS6ymy9JZv218sMml0pJDHjq62SM3uOQRuP4Yv2u12r5Kthxf2pf67JSX
         MQwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793021937; x=1793626737; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ia3WxArLDuCPrww14fZWiIGW/gcvNKfDorKU73bhn0w=;
        b=PTdOyNkTO6IrNlI4AhMv8IRLVRbZjW8iQv4agZcn2iK9u+2UuMPiF7X9FjFJHgBc9q
         ijODZmI3Kzl3DLXtaFvkZhwHhQOdGuzFrnGAIWlBCITH3xii2Vrwkd+THqr9uo+QcCF+
         +hhs4NQ6xCzMx4IJJOjvX3UdTfb4ibVRj3/JOGpo4uz0cxytLE31NqSBUYDvTBFjkdUA
         3SZydWbe+XWNoqKCrJwcozz3kBIHv7UF0WzMH2MUuJ0rb885n6T5jMwrh2J5bTybs3Sr
         UlYSNM1scCTyCeXx0D4jEJlyc7gJ6FJjSY8VRsZUcJ40KZdGr0fWrp8eF7Gm00xJAXlz
         AiNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793021937; x=1793626737;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ia3WxArLDuCPrww14fZWiIGW/gcvNKfDorKU73bhn0w=;
        b=h83ecsIJs8PgSzJ/kym5gJ8U3TBTBCBbIfdMhA9Mu96xqCAltFo5iW5AxkEZ61ocCD
         zop+TBimjxYXcf0rH5sdv7tkyhTrAsphU0BgAHda8Hr9TDiz+zdmXgzqzGltloodYSid
         G7QJULzyN19o0oxaJvAvJcyp7V8T7ESFiJ6aQ5S3TIqhW/or1dmN0r/Rb9C/U+rCemDe
         4DoG3jQVM45nnT3BVTh+T/dVqr0eFHI+d3G0VJqSv7dNGnX1SYv/zuvCC/94OnFgy7mu
         Kgh53KKMo5oJ9+Tb1ljlxiGxG+untqbyv4Lfsi8VfBcaQElAG6c9lF6pL8+1mThhX6jc
         T6Dg==
X-Forwarded-Encrypted: i=1; AKwUvBxIqkpDdH/Z3ECUbSmzMq4yPYuzeDkkPnfqmV+8z5W622rG/OqnStSOkbFyAXHKE5taSPPYSkV2kw==@kvack.org
X-Gm-Message-State: AFq9FYLBcqFbW+RPLyKz9VUdUNk3plm9K+roLlJl1UNyZ7wdKkFRNmyy
	342XKgRD1Mi2x6sRjszKSwnaCxCcTjzudARWJlv2Ni/X8i55QaVHDP8xgee2EO5px/xcSwTZa4z
	ImILgbIEvIK6to+GDcMpPb4KFcN+VnlA=
X-Gm-Gg: AYBFou1QYhzrgfPDS+HAE/7V3RhoAdH2l3G/MxaJVkf0zNReGbCfMm6l6aa9LGyh1Ot
	R3fqecwGRcWYpC1iO1R4zVDemUJsIHg8L63819H1yqrTMo7WYtSX2oTtsAjD1DwrCjMllEfQvtU
	BQZ4xGxID42tCEgGVsM5ITuIo8VFq8VQBHW68MqxowNL/NfXwgdCRDavUFt3gycuWLyff4sg8KO
	1CZIgr1V1RmVufq8R4+Q171LReeIol94ulLMt6HoEEoPX3qauIY0c6KNHSrUG6h8haFXPIiyiKl
	p66mYx/0HTfmH3UOG3NBrJJ3OVKIBOJvV8aKvhzw+MNrajnt3NNLl3h7gybsE1K/KDpUX36cwQM
	jbNR6Y5F7bQ2K0FmpFCRCexih8719QM5g3pocH8oMBe9Jw31wuR4/n7+uwah0ehdJf8j19g==
X-Received: by 2002:a17:907:3ea3:b0:c42:4750:8d33 with SMTP id
 a640c23a62f3a-c46bdc5a852mr799429366b.28.1793021936432; Mon, 26 Oct 2026
 06:38:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <CAMgjq7AB4wUzmugV3n4mhWcYqMKmhoZJCDV2uUagFjZXjUUi3A@mail.gmail.com>
 <CAEmasaXz2GGoy4dyhbo9Em95Cnz6QL3u2fcnAa2=8pJOOJyH8g@mail.gmail.com>
In-Reply-To: <CAEmasaXz2GGoy4dyhbo9Em95Cnz6QL3u2fcnAa2=8pJOOJyH8g@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Oct 2026 21:38:18 +0800
X-Gm-Features: AclHuK-mv42vSP0j_QUAw9kHH-YjfqEHToFq35eWyV0ENcI-qXQus23q6x1_16E
Message-ID: <CAMgjq7BjOeboPMP64PfGDoY4yMGq0xR4E4Wa66U0+gsd2tnu+g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/swap: keep reclaim batches contiguous on swap
To: Alexandre Ghiti <alexghiti@meta.com>, Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2973E100009
X-Stat-Signature: 78hybfj68gzj6u496g3pexdxjq6rweqg
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793021937-833643
X-HE-Meta: U2FsdGVkX181dJMN+DG9r4uQBvX2pVTM6lz1mdIDoIX+fcbY+kf2lX8ioeexIxIl+C2/f+hwcLc6RPl7cIK0eXZSRddaa/ReqzzpGg5N/GnRKYENxXWt/c7KZDv9lp8sAbWnxgezkaopuKwkdCBZ+roJvVVtP1AhBqxN1npweFDMxSvs0yFyC7CIUX9iLimp5pApjf3Kpt3oQFntVXzhdh4bmrvLI1A4EQg8DH83RkrzC4tJtyF0yQ+Y2eG5sGkl2QMdqdbjy2ORmtaQbA9mM0TPg+I//6zvuvSV6Pqj+ucALX7r7h9hTgcOPqCmSaU4pL700g85WeiFKXV20hm3awb1BUPOTWAifPDgZTM+ddqrNADYy4HH4tA3K+T9Ki3W+3DJjOcgc5+y1ifu5wrtzSaUfR7z3TyqEGMS/os/OXmPY2iEOMIUHDHU+8BEZv/uCaE6oTxuqAobhjU9qzHX0glOqVJici3Ax/JCecTcR4seJNIJg9nViKqsKGWanuqsBVHcDaYayZ6euOvCgnTOM3fMmkOM/KgdQ4Ejd9560wGpyfGqWIH7w16Az7lltA0judNOo3vHuu8mqp+OgxtO2gw30TQODYx0QTKCO6wY1x3xQZEYKA5mmjsSuV0c8SH4VGHPH7sA/60QEP8+/hfV4juIc4eBZuvdWaaIGJxwUaksvu9FdgKp0HCvfY9kibpkzijbfsKNKTd+lW6wtdX1f47BOmFZFfhIrdWva1+TF5OBN6dYpj8cQLxFu1pKVxiyRgcVq5qVsP8TiIyhwis5sVFoMRrnUOT4UTRkLkV0dlPOWoRRpqKpYrFCDT93XxJMrrHFRbySJ0Y0RIEp1nyplfU1OZL0IspSDoCk8/fAMuQNIHzZGxJLNOPn+s7fkBD5Wu4SUe/t8td/sNXUMe6UbmoehL0BX8f7SzCy1OIj5nXpcuNedzfNUIPlkFJDRxWyBqF1O9h//BOA5P33axm
 ttX2hQMy
 l1e5cWtcsfpcGwtY1Zzw0DQa8CBUfw5IL+2jjLRLRCtzbzkZCRqzOWfx86Mi5pTNgANrygs5zNVmUPIfXEtTOU2uR3qeJ4H3nB6+BuDDUmbUB3/qkJ7HUwOeCNs/TnOWdhtCws5ha+4Dkcsl5HPjrgwc7oNbFU5Oz7+U4X9sxMp+/dRNio17UDruf9CFmCh7tmMV/dLdxQsPySTX72YRlnn18LWYwskZFM4KAf/gKuW2YH3/7gXd/xoQmVkssFJ08A7VtAGBjYJwyoLsF2/dVeHpqNoLs/M8PBpVW+uKO8/I34omYWAV3w7y8O46T7VEIpFugBbt8lbZI3Nuqw4lpzWBij7RawN1SCXkTDtzwl87MjsprnnLtVha6wINrcNrKDxn4YL+4VIIdXzHzpyjuHSGigsdwfPprFdYX5aTM5ukRDjoibQjfnWP2ga76FsByVe6SCzhu3dAgU7sSncIoxu3OIY03HTYC/82M+RyGeIlkWTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 12:17=E2=80=AFAM Alexandre Ghiti <alexghiti@meta.co=
m> wrote:
>
> Hi Kairui,
>
> On Thu, Oct 22, 2026 at 5:27=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > >
> > On Thu, Oct 22, 2026 at 11:00=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr=
> wrote:
> > >
> > > 7.3 regressed swap I/O: for the same swap volume, a workload that
> > > rewrites swapped out memory sends many more requests to the device.
> > > mysql/sysbench in a 256M memcg swapping to an NVMe partition, 7.3
> > > compared to the previous version:
> > >
> > >   device read requests per transaction        +59%
> > >   device write requests per transaction       +27%
> > >   throughput, iocost off                      no change
> > >   throughput, iocost on                       -19%
> > >
> > > Two commits interact:
> > >
> > > - Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")=
,
> > >   in 6.18, makes order-0 allocations fill nonfull clusters before
> > >   taking a free one.
> > >
> > > - Commit 3cedb745d354 ("mm: clarify the folio_free_swap() for
> > >   do_swap_page()"), in 7.3, frees the swap slot on an exclusive write
> > >   fault. 7.0 to 7.2 kept the slot, but only as a side effect of commi=
t
> > >   4b34f1d82c65 ("mm, swap: free the swap cache after folio is
> > >   mapped").
> > >
> > > The freed slots leave holes in full clusters, which then go back on
> > > the nonfull list. Reclaim allocates slots one folio at a time and
> > > merges the writes afterwards, so a batch of LRU-adjacent folios gets
> > > scattered over those holes and is written with many small requests.
> > > Readahead later finds those pages scattered as well, and needs more
> > > read requests to bring them back.
> > >
> > > I tried three fixes, which perform similarly:
> > >
> > > A. Revert 3cedb745d354. This keeps the slot on write fault, but undoe=
s
> > >    the intent of that commit and keeps swap space pinned under dirty
> > >    pages.
> > >
> > > B. Below 50% swap usage, make order-0 allocations take a free cluster
> > >    before a nonfull one. This is what the allocator already does, at
> > >    any usage, on swap devices with discard enabled (swapon
> > >    --discard=3Dpages). It is about five lines, but the threshold is
> > >    arbitrary, it stops working as swap fills up, and it applies to
> > >    every order-0 allocation, using up the free clusters that
> > >    nonfull-first keeps for mTHP.
> >
> > Hi Alexandre,
> >
> > That's a interesting problem. I think the real problem is with commit
> > 9a42aed48421 ("mm, swap: prefer nonfull over free clusters"), right?
> >
> > It's more like a balance between fragmentation and contiguity of small
> > order allocation issue.
> >
> > Perhaps we should instead always scan the full clusters and revert
> > that one commit? That commit was only following the idea of keeping
> > the allocation more compacted for that series, it looked good at that
> > time. Since fragmentation issues can be solved in other ways,
> > contiguity seems to matter more for large physical swap devices.
> >
>

Hi,

> Oh, okay. I thought reverting it wasn't an option given the good
> numbers the patch provides.

That patch is 1/3 of a series, that series yields really nice
results, but that one patch plays only a small part in them. Or
perhaps we can limit that to SYNC devices? I hope there are simpler
ways to avoid the problem you encountered. I think the ~4% reduction
of 64k mTHP failure is kind of trivial compared to the problem you
encountered, and 2M swapout is still not easily doable, as the
main blocker is from the page allocator.

>
> What are the other fragmentation solutions you are referring to?

Right, nothing has landed in upstream for that yet, but with larger
swap space the fragmentation issue will be largely solved. And before
that we might be able to sort the clusters by the continues size of
slots on it instead just blindly move then back to nonfull on any
freeing.

