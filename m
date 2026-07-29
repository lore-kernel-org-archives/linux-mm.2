Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8B0C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1C66B00E8; Tue, 28 Jul 2026 20:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AB326B00E9; Tue, 28 Jul 2026 20:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899986B00EA; Tue, 28 Jul 2026 20:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B71C6B00E8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:36:19 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC247403E7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:36:18 +0000 (UTC)
X-FDA: 85039947636.12.63C5BC4
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id E9B45C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:36:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nw5zj6Au;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of jyescas@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4+ZKchlNYOyVx1ec4Z7hkgzRosN8uCqlqN3+MCAunc=;
	b=t/+NiE6dB5Gel4FBJ+nvQMSqsGZpowBKszTQ7X9WzDXU834qpGvvwYtSldrDfQbzwcT9oA
	1PbXTG2+rMLTVYxmtMgOM4HjBB5dMAhCuffpAfI5CqJiZTDhWRS6rQuMG58kCLITDtJzil
	hbEQwAg/apNGuaiAwo5reHBI9wRKxXE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nw5zj6Au;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of jyescas@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785285376;
	b=hNSQxT0GZgIV1ojaYYpr7ELrN+bwin24e2Q4g+t+nGbNDGSnV87ZyieNxClSDUCwkzMDte
	l0EFXVEEOYGUSMF4YbcWLRttq+cKr0+eOEYBrQkWQaxEx9JdK4ek1IgtrW9DCrFMppHgWJ
	RxKIqb/gFv1u9yCIaozzTIHuY8cd54o=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so1856e87.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:36:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785285375; cv=none;
        d=google.com; s=arc-20260327;
        b=gZOE+4AXdp+aFgq3rA6g26MXGKPOxGDfG42u8A155SE6/C1FKUp5US1LbKk38DNEf5
         q9dB5sry+msg7naPp+2/37vqs82hS1ZkHV6NHnfhKdZrcdH7/jlK6e00n5Ne5MKCIG2k
         JwQwgyahV/wu6dnog3p54cz3/a/aHdok637HzrL/Sxh+5FBdMvIL6RaGmwf+8xxg8q3d
         As8eJM24AGNAgoFtxtDFHlxXCymwTbixez48valMVaF9zlikxY7O8jfw7JeHAj7slLQu
         Gxjf4Sj1cDau6/GKhKkhJp3QLltRVxRYu+Krd3Kjcg1JjuJ+Qh22//mIJobat7JzVg9/
         kUOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O4+ZKchlNYOyVx1ec4Z7hkgzRosN8uCqlqN3+MCAunc=;
        fh=U85sBaxXH+qpBBGzIjRVwnsgRN3qsEWh1RMrf/Iy3+k=;
        b=kgHSXaO1c76BKSghDoY/1KdYxunWXh7bcpHfNemNqIhBWDVSMi86rgIGicdhQdVTL1
         kVDaSpPEA0ut73txGi/CsViVLPyBHS2xe8AnSfq4G3iVtIEqQUqYMXhKvArxVn4OTEzw
         nJsaQpL7h6Aiq1na633JFC3S9WIrOlVtoGpFJw3e4CEczTg/256GEJgVAUJ/x+gOFf7G
         we0ncGWHMs3RLka4K3ChuaoIIll43fNyM7Pnxl0VPIQNJ2dsfetiUqJh4x6imH5/o8ID
         T2S2KZvJRxTGY4KdelyEgkDAL375RoPVkvf8jWjPE4F//k2F3VetcDnSgPTb9HKVb78R
         jo7A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785285375; x=1785890175; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O4+ZKchlNYOyVx1ec4Z7hkgzRosN8uCqlqN3+MCAunc=;
        b=Nw5zj6AusSnbs/xiOsB8i6QWpCGAH4RfroC7CbphEo8dAW0cVYFRhnBWSxE4I2pRNy
         3wswt0FOQxXrFYYxuF7zJHwurXzy8YOsgvIWsmQfpRbx5csSzyvK1/18mwjddZeLaJ2Y
         R0WL5oGC8WUd2ZeV4XqfEt0gf/b+e7LeY3rF5ny/wkUDeQS4RZWoEy4oYtsBmmf+s89e
         YkFtXavqIxnn9DY9IaPN2x1z/NRwulKV43vFEaCD1B4XlhSO5ee4hDVgPDZRdT1fRbo4
         dXFMLLflI+rai0WwVR78ZentkT9ou2dQhdSGf055eCpX+LOAUY/q3c4XUmawCyatNPYc
         5ldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785285375; x=1785890175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O4+ZKchlNYOyVx1ec4Z7hkgzRosN8uCqlqN3+MCAunc=;
        b=Pk1vtzoWL7vJoT0PXHyBeYkr0VqiBy8HDc1OxQrNjG3t4zDhsAuuCzBK6fNXTm+pNW
         NTfWVb+zLNrT0HgouZxD5gHlm43kMqSwvDE/JZXWERHFtg2oSyJ9YbGS7xews9cPmFwi
         aGBNhyUd+jIphc7VIp0Zb/f5i0U9kqsx90j/MNsVFbRu3cq8+1Z0C8gEevb5yRjpokI5
         IPyUvyNLukmLrThlgDYQITQ5e5IKtklphOalxKzu/OuaY1X92pGgzUzau8A6EgPIDpuh
         wnz3P9O3o269Gb/xGEdp0F7FU+BzpKA01wJoP9nOoZ6fXJFCllT9s4Dz/AcMbc6ZJanS
         y/tQ==
X-Forwarded-Encrypted: i=1; AHgh+RqdHzgde8q7SBzfdlQmqmnp7t1MYsl+LOx/BklrX8TEY6K/JIQmq7t/gE2EPY31w4GdnWWclaeCMQ==@kvack.org
X-Gm-Message-State: AOJu0Yyu5ZpiBrZV9sZurJQ6lv/TZ/VIdyh14U7myuaBGkYhw61N7QwO
	4n/RX8mtPU3aCgxDme+AQEs0KoOu0lvWjnY5huqVPqwZY1geh6ZxOD/ThjNUQVz+kY9I9zCk92n
	D58pbfpT3R4Q9RZJlh8jn2bo5Sh8kPOxAAqvdV673
X-Gm-Gg: AR+sD10KnZzZr69ZKHaLto+H08n4mo9pdLkGqwk8N2Oj9D+CalvrXMuLA3bD87zW6uv
	jGJL59dkc+uvNna7RecbdD7pMTSv8rgolp7SjSyWI6FjIYUCYQMW0ePsWryup66TdcpOlEr5fhx
	jiJtthBu9hXKDvLUBAf8FXIjGmG1vARnfJfES87qdU5vBiP68Bi6SOi/RWH6wb9DdccMzmO9aDc
	9pXeGXpWWL7hzWw5JOjGvpPVNVaupbzRJLw9SdxnMagLrqfaGddjidWfOUJEvCsA/fRXSB5G9Ty
	1zoawuykSV/cxFibVTT7Gzv6P4T4gLzKmYwy3hluNUfa/uTFXftl52W44t6OT7aPcosTR+exlw=
	=
X-Received: by 2002:a05:6512:3f0c:b0:5ae:b1b3:145a with SMTP id
 2adb3069b0e04-5b2d82772b5mr5655e87.6.1785285374685; Tue, 28 Jul 2026 17:36:14
 -0700 (PDT)
MIME-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com> <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
In-Reply-To: <97605949-82c5-49e0-84b6-b42e8078b55d@kernel.org>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 28 Jul 2026 17:36:03 -0700
X-Gm-Features: AUfX_mxcXP550gyHsDpzZinI7XOmRkCcTIAAYZxgEXkbnfwqJOQ_c39OoLMlWM0
Message-ID: <CAJDx_rjNhiS+J9eDkQxPF6B=jJ-Evr-M7NNeS_QcG7XWNDoEYQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] Page Alloc Hogger
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9B45C0002
X-Rspam-User: 
X-Stat-Signature: fhwa4dsne1xdkipzia16wh56m43yy18c
X-HE-Tag: 1785285376-97193
X-HE-Meta: U2FsdGVkX19dr4SACOxj11LaVUzqbzn7FmY66ViH7g7vu3ZhWvTxbhZ+bDVNEBlg9drHuUpN5OkTU1DVVvIzU7/WYYV1u2CH7RpdoLFTqZxMu5TYoIm6MbsS9mISEx7O4raQcxhjoy6F3yoFkUAj089RQc1jeyLRf3L5z0AxqpSt0KRlppE49khb05a82Pf5szONaxef+cA2EiE0u7TumPTLryJswhJ3i5ng6Poq7Xhd0IlOmgyRs7LOsVkyPJbXQPYWBrZQ5anRvTfHhFcP5XH/lYutleXo6s2KOHrf3TTAN8i/r9Unz6JQheudhi0/EvSBXBD6aKBdW3cVjkhm/A5AgcZzesVwQZMYj9ZVmrwCGw42oRz0bCxWvo5ovxG2aOOiZbHEWtChE55/3qDLoYK88H7gzbNVPFkm7snAgHPzdVxUiJEOJOKG1AP9AZ3wpi0SjB5m73ALq6R7gGOZ+V/7oTdQzMBrSPgMTjgNdoF94ZhDyjHHWn44vIMExu0Z1irPM/C+kbMKQxQKCFkl9/ksZBrv3JOJIbSqsW2KdcbCqifOR9DPeiKz20WbhUniXsifHyG42/IkouhPldpgjOnSPIoxvMYSRe0wNvhCrk3+1nEAp/WrmI6f0CrxQNLwsbDyIWfIoDLtY0eHAqqLe73OCZbK1JfTXWnXWpJII7PC9NsaPjDHbdrtzku72SE4KtzKd2r258Ked34K94stmpgfXKYyi0WsWYDRuLwiFxYMDnBZuZ+TSCAWPgQTC0x/iMM226x/bdGdZ3XB5vgH3jB2liV7qTWDRWadQBns+UgSv0qKyh74Ocyy178aTZByUEuFWz1zVPhWj9wCbjx03hlrFUanh26ztl1JSo9ApwqFt/otwjkIgAmymgdqJCFDz0CewwI84bYm0LZBH/Y5lR4gr3A3Z5Ypyn495tajkMKK8WginA/wTTH6JvqRM9r+gcA/4QplfGza5g6Kh7O
 25MHtvzO
 TOQBNUMJKrFwTeJ2Hvn5mY7J+Liu3qtZG97XV/G/6ebKspY9PgUXv0I1ZrGA7bcJKzFncPgqYyLyKryKUZRxThbKd/hYI4+oUikvhWA45oUOX38vaxpLbZRF3CbaQ6KKMRMD5t8h5lRdR513SnKa1AskO8lJt5LG8OO1FGlTIwvLejMK6CI5+pzqJDcZ+/hAq7YEDEXG5shNvuxHC9+aBbLy5wjUWTgnwRqOxJZb9Q/YgBafQWvGYR66waFtoED6v2YroY02vDA37S/NdKsWEV3OWQ2a9s6N3xkKRlwuxLYMLv3oHacRdcCzKzIX8SM90TUi6msya77uCateZRChUojm23w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 12:29=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/23/26 09:47, Juan Yescas wrote:
> > This patch series introduces the Page Alloc Hogger. The Page Alloc Hogg=
er
> > allows you to allocate memory pages from specific nodes, zones, migrati=
on
> > types, and orders directly via debugfs. This provides key benefits for
> > testing and debugging:
>
> Would it be feasible to carry this as an OOT debugging module? Would a lo=
t of
> symbols be missing to achieve that?
>

Thanks David for the comment.

The only symbol that would be needed to have this module as OOT is
"migratetype_names".

However, although this module was originally designed to debug CMA
issues, it can be
easily used to debug issues in kswapd, direct reclaims, OOM killer,
etc. We could even
use this module to add kunit test cases.

Let's take for example this case. We want to allocate Unmovable memory and =
check
that the allocation came from Movable, as per the buddy allocator
fallback mechanism.
How can we do that in user space?

$ cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order 0  1  2  3  4  5  6  7  8  9   1=
0
Node 0, zone    DMA, type   Unmovable      0  0  0  0  0  0  0  0  0  0    =
0
Node 0, zone    DMA, type     Movable      1  1  1  0  1  1  2  2  1  3  73=
2
Node 0, zone    DMA, type Reclaimable      0  0  0  0  0  0  0  0  0  0    =
0
Node 0, zone    DMA, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    =
0
Node 0, zone    DMA, type         CMA      0  0  0  0  0  0  0  0  0  1    =
7
Node 0, zone    DMA, type     Isolate      0  0  0  0  0  0  0  0  0  0    =
0
Node 0, zone Normal, type   Unmovable     13  7  0  1  0  0  1  0  1  0    =
0
Node 0, zone Normal, type     Movable      1  1  1  1  1  1  1  0  1  1 122=
1
Node 0, zone Normal, type Reclaimable      1  0  0  0  0  0  1  0  0  1    =
0
Node 0, zone Normal, type  HighAtomic      0  0  0  0  0  0  0  0  0  0    =
0
Node 0, zone Normal, type         CMA      0  0  0  0  0  0  0  0  0  1    =
7
Node 0, zone Normal, type     Isolate      0  0  0  0  0  0  0  0  0  0    =
0

// Allocate Unmovable memory (note that there are NO Unmovable pages,
so the allocation will fall back from Movable)
$ echo 1221 > /sys/kernel/debug/mm/node-0/zone-Normal/order-10/migrate-Unmo=
vable/nr_pages_allocs

$ cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order       0      1      2
3      4      5      6      7      8      9     10
Node    0, zone      DMA, type    Unmovable      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone      DMA, type      Movable      1      1      1
0      1      1      2      2      1      3    701
Node    0, zone      DMA, type  Reclaimable      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone      DMA, type   HighAtomic      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone      DMA, type          CMA      0      0      0
0      0      0      0      0      0      1     31
Node    0, zone      DMA, type      Isolate      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone   Normal, type    Unmovable      1      0      0
1      1      1      1      1      1      0      0
Node    0, zone   Normal, type      Movable      1      0      1
1      1      1      1      1      1      1      7
Node    0, zone   Normal, type  Reclaimable      0      1      0
0      1      0      0      0      1      0      0
Node    0, zone   Normal, type   HighAtomic      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone   Normal, type          CMA      0      0      0
0      0      0      0      0      0      1      7
Node    0, zone   Normal, type      Isolate      0      0      0
0      0      0      0      0      0      0      0

Number of blocks type     Unmovable      Movable  Reclaimable
HighAtomic          CMA      Isolate
Node 0, zone      DMA           14         1458            0
 0           64            0
Node 0, zone   Normal         2440          102            2
 0           16            0

// Now we want to test that Reclaimable memory allocations fall back
from ZONE_DMA and Migrate Movable

$ echo 600 > /sys/kernel/debug/mm/node-0/zone-Normal/order-10/migrate-Recla=
imable/nr_pages_allocs
# cat /proc/pagetypeinfo
Page block order: 9
Pages per block:  512

Free pages count per migrate type at order       0      1      2
3      4      5      6      7      8      9     10
Node    0, zone      DMA, type    Unmovable      0      0      0
0      0      1      1      0      0      1      0
Node    0, zone      DMA, type      Movable      1      1      1
0      1      1      2      2      1      3     99
Node    0, zone      DMA, type  Reclaimable      1      0      0
1      0      0      1      0      1      1      0
Node    0, zone      DMA, type   HighAtomic      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone      DMA, type          CMA      0      0      0
0      0      0      0      0      0      1     31
Node    0, zone      DMA, type      Isolate      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone   Normal, type    Unmovable      1      0      0
1      1      1      1      1      1      0      0
Node    0, zone   Normal, type      Movable      0      0      0
1      0      0      1      0      1      0      7
Node    0, zone   Normal, type  Reclaimable      0      1      0
0      1      0      0      0      1      0      0
Node    0, zone   Normal, type   HighAtomic      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone   Normal, type          CMA      0      0      0
0      0      0      0      0      0      1      7
Node    0, zone   Normal, type      Isolate      0      0      0
0      0      0      0      0      0      0      0

Number of blocks type     Unmovable      Movable  Reclaimable
HighAtomic          CMA      Isolate
Node 0, zone      DMA           16          254         1202
 0           64            0
Node 0, zone   Normal         2440          102            2
 0           16            0

// Now, we want to free all the MIGRATE_UNMOVABLE allocations and
sleep 1 second for every
// allocation and see how the pages return to the MIGRATE_UNMOVABLE bucket:

for i in `seq 1 1221`; do echo $i > /sys/kernel/debug/mm/free; sleep 10; do=
ne

// in another console

watch cat /proc/pagetypeinfo
                            2026-07-29 00:28:49

Page block order: 9
Pages per block:  512

Free pages count per migrate type at order       0      1      2
3      4      5      6      7      8      9     10
Node    0, zone      DMA, type    Unmovable      0      0      0
0      0      1      1      0      0      1      0
Node    0, zone      DMA, type      Movable      1      1      1
0      1      1      2      2      1      3     99
Node    0, zone      DMA, type  Reclaimable      1      0      0
1      0      0      1      0      1      1      0
Node    0, zone      DMA, type   HighAtomic      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone      DMA, type          CMA      0      0      0
0      0      0      0      0      0      1     31
Node    0, zone      DMA, type      Isolate      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone   Normal, type    Unmovable      1      0      0
1      1      1      1      1      1      0    698
Node    0, zone   Normal, type      Movable      1      0      0
1      0      0      0      0      1      0      7
Node    0, zone   Normal, type  Reclaimable      0      1      0
0      1      0      0      0      1      0      0
Node    0, zone   Normal, type   HighAtomic      0      0      0
0      0      0      0      0      0      0      0
Node    0, zone   Normal, type          CMA      0      0      0
0      0      0      0      0      0      1      7
Node    0, zone   Normal, type      Isolate      0      0      0
0      0      0      0      0      0      0      0

Number of blocks type     Unmovable      Movable  Reclaimable
HighAtomic          CMA      Isolate
Node 0, zone      DMA           16          254         1202
 0           64            0
Node 0, zone   Normal         2440          102            2
 0           16            0

Achieving the same result in a user program is not as straightforward.

The Page Alloc Hogger gives us the flexibility to allocate from any
valid memory we desire.

As I mentioned before, it allows us to test/check/analyze/generate:

- kwapd triggers
- direct reclaims
- OOM killer
- generate page fragmentation using simple scripts instead of complex progr=
ams

Greetigns

Juan


> --
> Cheers,
>
> David

