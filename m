Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F3F606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ja71SZz5
Received: by kanga.kvack.org (Postfix)
	id 584D96B05B5; Sun,  1 Nov 2026 13:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BCF6B05B6; Sun,  1 Nov 2026 13:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471AF6B05B7; Sun,  1 Nov 2026 13:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 156EA6B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:03:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F9181A0AF5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:03:15 +0000 (UTC)
X-FDA: 85387321950.26.B060896
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id A632340007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:03:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ja71SZz5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793556193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2KNNLNC1SGWQPktfWAC0fctv/qW21YYnE3QrHE9Xgw=;
	b=oJl9VBpMnKv8JWucTTFBWgEpTfnDoXbP3Zv2IgyVUj1fXM0mXUBjo6tPeQ/pARSQwSMZpu
	1lV7km2XIyVR7DfRhQoOKa7S8aO8g5frru+cCbuKLGosV9pMoXNzypt7QUaD0f4EbBPzlt
	KN2Y3K90cST0vpRNVR26G1wZ63tpIXQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ja71SZz5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793556193;
	b=3gSDyrQEyRVHqtdRDtSr5lrFnz9RynuEMA03aVXVINZIP4h0tql67KLsP9oqSn2qals5le
	I9z3Va2fWfG/t2Y3B5uR5grt2P4pFsIDb3at3M5eXcpLXuvPe8MvxHGTmMp7oIW+8+aZhY
	uhUzIEZJl7iNz2oWzICNNgj6aB3kqxs=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso4599295a12.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 10:03:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793556192; cv=none;
        d=google.com; s=arc-20260327;
        b=pwvdeot+UvW2QZOQ6U7gfK37vloRSu6feBdJrDJ81Kxg193nCKp6Jzmajc5QzQ5br+
         /PFx2TYTKtAlsLmFOlHINVwIe0EnOcdCKpa0egFxHVGCQf2rHO/RcqZJRi/4qC6Cnw5r
         RjjyRcMN5SaT9G6/9B7TxrHSMuTjKR1tIo+Ch4U7FzSmuZpbQnkzTU6z14UR0mxHsZhp
         O4p48/G9OO5KKDm8n3JOhTzuJy0q+GdqzVqJFacXBtgYT6ZbEIFbVwUMOzUBql+hGT6T
         Q5tEY5D5veZ/dWyp7opshWF7/USCbRT7g4VMvmymjd1JyQ+JCv/6sRdNJVJ5uDI6p+4N
         iuWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E2KNNLNC1SGWQPktfWAC0fctv/qW21YYnE3QrHE9Xgw=;
        fh=ZMj1z+T6xNUAEKGFDwOyCvz85RZxwkFShQgq487KNHY=;
        b=m7Y/UVCAG6wgYfwAusI3j2tANGiHWSoYwO2ADsRbCr90pto7qXMxLmRIM2EzvqXUAd
         vO5yzZV1dzARNK4+o0RbcPb/SkkK5i6ufzIR/wDhOnVllRtNkoASXlKhFUxFGj/wYY94
         GJ+47kkV6lVh8w10bhuXup5fYNSTunkVYULRj6tPfg9Pd5G2jmEXPIk2hVVv7VjhGg7T
         ynMYLbuyjUbTi2DBHCJnthmyt4v0VdVhyxXo8qQv6bvWxtkpneY9roFtPl2LUQiCxluh
         zP+GAULcXQx4sxIobJNiU2tsyrh/TVbLfcMkcjtpeS/JvK7Lt8L+RJ49nx1UCLqC4Lud
         PwYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793556192; x=1794160992; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E2KNNLNC1SGWQPktfWAC0fctv/qW21YYnE3QrHE9Xgw=;
        b=ja71SZz5K4utEZj3gLnCxD+8AgQqlC4l/x05pU/2ncBNFaFkIxbbZYRcVNRibcoWQi
         64QPHcvoowXHhaR+l/GorYBMAGZrjU7JdhbkQwVYioD0S9TKBnsVasPMkwXlcEqm0iaA
         0X/74Z204oiQDYlZSKGZFZoB6psasxu56p1Huq+rM8KJkFwJvfAmP2PMEMlflyMqEZND
         oXNn0qH3rdN1FCkmSEXQL7Y3ZPOC/9x6yeQ1uHfyEhyZ90UTBAOpnAA77qn6+HFLP2Tr
         TvYQQVicbi7C3zW9Fj33Tdkmi9HnzQcaZpXs1RcDJRSsTmqbVlQijLgjkdYk6RMfPspO
         Lupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793556192; x=1794160992;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E2KNNLNC1SGWQPktfWAC0fctv/qW21YYnE3QrHE9Xgw=;
        b=HPnc2f4MseISfXQK0Z9k4+mYmDBMc6RZ8xEXaX4CmLHxNX0mNMBLiFAHGPq7Pxhhk+
         eugqwAhmvICbRh4ycK+xTvwvk8QfztlVoBj185yi1lGbKmIAiJLl+vmnfL+bfdZvgCsI
         uURMtiDkHIgIUI8bddK/eaE2TEcpLA07THnUae+SrlDcH0u6cqOJ71wX6Km3NfFTdwvK
         QTGyA+dM9u1mejA7bs+4NsJOHNaJu/EkB862dqiCq7n2aBk5nWjT0MVxzlz7qeHdX6og
         cDvKGiKQHNOkJHFHiHgqearnSirE2qMnwOqzFIhlhteJd5a0KIzIXAaTU8l68ct+qM0E
         UZLw==
X-Gm-Message-State: APuU4Z9mwTJL9xBCuBj4gqNxBLS0UH8nlBzdhkPjiH+5/HxVHIxsrR3Z
	rtAQUzzN73cgroaRTZFIDsrQ8bSs8AxsY6/3CuN5Gg/z7sOUVaajckWrcx10OxF4YiATL/5uF/C
	xSjsLWqgty+Y2uQGXh506PgrXgDTomkk=
X-Gm-Gg: AYBFou0kMA/rGcbVdgliNDPsnUUPXYvaMxo/uU+X5UbbsjXiN78qqfX3Rn1v6YlEM/q
	e3DWlkdTRNVtVGHIbivAJPgJoPVraX6sQTKB7UTacksVpWGCCrsvQrg3inlJ/ufRImHuZaUHvtY
	tq5WHjGmrFgF+962xFAgbeBozbwLMw7cPU8PVvHRfxiHv5Y/QRq/tL4qBb3MWYWcHNdVz+azwJQ
	pB4sLIK/bEk2rrK/lu67ffEUQkR/TBTJo3c6272GEqXNU5PsxZ58zIiM0jfZhrT0ni+EWoSPs4D
	lrv5BG98Tk2bEaLJ4fbkoC9DPXmu2b70Vk3oivuq3n5NEaRBKafyB9MwEYISs/YdTtmL2SadBs3
	BNH0F8rpyfQW64+z5x4yVs6fuPItHhH1LMitnZHXuuYLrEQhTk/otjkd7g2fKQjJH/a0mLHA=
X-Received: by 2002:a05:6402:a50b:10b0:6b4:27a:38f7 with SMTP id
 4fb4d7f45d1cf-6b4d46841c0mr3680555a12.22.1793556191678; Sun, 01 Nov 2026
 10:03:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261101160427.85701-1-maxmuzaf@gmail.com>
In-Reply-To: <20261101160427.85701-1-maxmuzaf@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Nov 2026 02:02:33 +0800
X-Gm-Features: AclHuK-mBCMSO3NX7Gmc3L4MrGwIlRmJA-dre9im5G-WapDPHEKVriJE5cMlVMk
Message-ID: <CAMgjq7AEf_cJsLw4fxs7m5ntYPW9mjCOC_-w5j6ihk8F=xLRWA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/1] mm/mglru: MADV_RANDOM page cache never ages and
 thrashes the oldest generation
To: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Yu Zhao <yuzhao@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A632340007
X-Stat-Signature: e3tu5y8hq6sweih3dbnkdimwu4hbifmh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793556193-936815
X-HE-Meta: U2FsdGVkX1/3Y7hl+QyPWbGT00kn8J5XobNEe0o99Gu6ISa0+cahHv72s3/Ixbh6BGhs2GP1HwzuaRQ/uB9YOoHYnvtal9LvBqdE3fhDuvRyvBoPpWiRRpSMMTjrEmym5NiWCKqW5MOlJ0ipdHgfAouSsvUISA33uijpzKCtRagei38/hMXFGY8oPXw1lrQFH6eo2oDsEYLTmmt9FG5o0T1O48m5a5KEX/zHfedAg0lLIdHwOZN7mmxMlCU2G8EUMMB5b1fPWLadlYx61+GeJ3/0+48g+9pI+K1WjnUq4min1QkldkiLeKCRQX4GkYbRVNN7f1qHKTXHfneDsHrxMigkhyC4AGOokQZL0wkybxA3m3Z83nXSe8FnBUZCFMi4/gMtZKKWem1mIZcgMz8yLaHm5EvVTnK8+QFItnSqujXK1LUPBc5WDFZcQvRD67/2LDuG1sl+o1HmijrYFNsgFsijaPnXjAGq7UDvyXuRzofD2ZUtMcfv4OhNATPlYTZVN71lz84qZi03Z86ec2KX1SeV5NrE5u4HaVhzJjSvlVutKH4OQQ15PyxSiiKWGbAdI0iugqLF4kQEzbxev1a4zzbJQoGNaWTNLTEbaBpEpqnsD+5CyRFAMP40bRdbyrHig8UBJ51+0WbZbuK7tE8Iw/5OSYXdhQ3Q2+/XZa+Px5QeTiDPTiq87OtP+q7xI0KYqDl/jkPRIxVcJGtqFualXvBsqgQ903DJEYDC+W/6K3+8Pk/mq6Ak5PN3WL9P0LQ5J3X3F9SRKQMnKTlBUlI8hYpruDSUfngRHclcg468+agGcJZQhFx4MNlAlbKhdm/kdA7gPq8LNc00xbqALqwrWnN8/r66/XjikO3zGR/vwvhddbYfUmd3VinqurN/gDrzaxpHXnzeukjefoRQkycOD6QfB8arFXPL3EOu8aOvYOHBI9cNse0fKOU6TXRjwzpU2bxQB80/04XuqMozHuL
 lB15lJj4
 tI9nyKu32mnskrq6adlGYKfgpuHfZbBAk3XuO2O++9Z1W31Kcm2yV2jBn2XMdPeAIDGIZzaHampYfkcLsB3dqCB8eA6XIZwivMMrxDcpd8wF8aHNiQZzj4DnyCSt4q3kg9/5Ka9e876CeFAzu8UU2lN/b9WUqjgrHOhrxtojxDBVNH06mfPDJz9hWWHn7sw31Rxcq0HRyDJPzonvWqe4Ufk8K51swom/NP6t90srmthjDIrCxv0IyJvphNWIkGakVw1QJ+pDu17+kFDkE9I2M+2nuK1N27rUDLpQb96qlkbtieAX5kkiXJp4H+KwrkH28esf4wvSwaexIhoK+6cX5URCU0sPfjzoBnjlWugwJXNfVPJCB0zzfz1i2zPSARBCFGIOTi7mpJw+vWbaJ6/RmyhMa8YyCxIN8ISYYfWvhQf/duDKnbA/zQLra2c7/rHk5PNfSavnRl7TEaNXXXF2CQVpjEsc+PVqd83NoNGhmtamMYx82yLYKPmfDFd2klYbs1DqFw3FxSqueFlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 12:04=E2=80=AFAM Maxim Muzafarov <maxmuzaf@gmail.com=
> wrote:
>
> Hi,

Hello Maxim!

> It looks like I've stumbled upon an awkward behaviour. When MGLRU is

You are not alone, I encountered same issue too :)

> enabled, page cache faulted in through an MADV_RANDOM mapping goes into
> the oldest generation, and the refaults land there at the same rate as
> well. In my tests bpftrace shows the generations stay at seq 0-3, with
> no aging attempts and no new generations during the workload run, and
> /sys/kernel/debug/lru_gen_full shows for generation seq 0 15758245
> pages evicted and 15580028 pages refaulted, which is 98.87%.
>
> At the same time, a file read through a normal mmap lands one
> generation higher and none of its pages are evicted. It stays cached
> until the end of the workload, and the randomly read working set
> shrinks. With lru_gen disabled, the CLRU evicts the file
> instead, and throughput recovers 20-30 seconds after the file was read.
> I would expect the same behaviour for MGLRU.
>
> I first saw this slowdown on a single-node OpenSearch 3.6 (Lucene 10.4)
> HNSW vector search workload [1]. The node had about 2.8 GiB of page
> cache for a 2.9 GiB index, and Lucene maps the .vec and .vex files with
> MADV_RANDOM. Kernel 7.2.10-200.fc44.aarch64.
>
> Search latency and throughput on a single-node OpenSearch:
>
>                          MGLRU on   MGLRU off
>   p50, ms                   286.0        73.6
>   p90, ms                   512.1       135.6
>   p99, ms                   687.0       191.0
>   queries/s                  27.4        87.1
>
> Disk reads, same runs:
>
>                          MGLRU on   MGLRU off
>   major faults/query         1484         325
>   disk reads/query           1484         325
>   read size, KiB              4.0         4.0
>   disk read, GiB/run        509.6       111.5
>
> This is clearly visible on the page cache chart [2], where "blue" are
> page cache pages mapped into at least one process's address space and
> "orange" the rest of the page cache.
>
> Then I reproduced it with a synthetic HNSW-like query script in python,
> and later with fio alone, on 7.2.10-200.fc44.aarch64, 7.2.14, 7.2.14
> with the MGLRU-FG v4 series [3][4], and on mainline v7.3-rc7.

The missing piece here is refault distance. Both MGLRU and CLRU ignore
hotness on eviction for vma_has_recency() =3D=3D false case, however, CLRU
still has refault distance protection, while MGLRU doesn't.

I observed a similar issue, which disappeared after we added refault
distance for MGLRU.

There is an early version of FG that have it:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencen=
t.com/

See this patch, it too long so I have to split it out and dropped it
for later version:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-30-913619b014d9@tence=
nt.com/

This code snip:
+ /* Set refault as active. */
+ if (distance < total / 2) {
+ folio_set_active(folio);

I may change it to something like
folio_set_lru_refs(LRU_REFS_WORKINGSET) later for non in-fault case
cause this kind of break FG for other cases.

That way, even a random folio will be put to the head directly instead
of keep thrasing on tail. And placing on head or newer gen will trigger agi=
ng.

I think I got the problem right? I'll run your benchmark too a bit
later, still tweaking it for some other issues. The refault distance
part needs some rebasing and tweaking as it will have chemical
reactions with many other MGLRU components and it may not work as
expected yet (I also need to use it for an MRU fallback, because, in
theory a pure random case may benifit more from fallback to MRU
stragegy, but your case is a hybrid of hot random and cold non-random,
so a bit tricky to get it right)...

(And we may also loose lru_gen_in_fault for refault case? Not sure...)

But I think we are getting there :), and your report is a really nice case!

