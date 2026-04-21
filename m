Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CE3F94CA3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 18:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E84F6B0005; Tue, 21 Apr 2026 14:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9990C6B0088; Tue, 21 Apr 2026 14:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887B36B008A; Tue, 21 Apr 2026 14:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 772776B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:08:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A40A8D8A2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:08:13 +0000 (UTC)
X-FDA: 84683347266.30.4C2F7DE
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id C7820100007
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:08:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lq4xeCbD;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776794890; a=rsa-sha256;
	cv=pass;
	b=f/w7GQ3Mprm2iI7VnDnf55gU7U+vmWT+D23/guMHplY3DHmnQ0z0bvV7vokd2OObWVUiXl
	Vc4dXxcCBhQVzoxSm17XnmdHAmWjFccmsNhLhLF6VHDRdK9ihfeLcjid3Y/B4LHfFa4C7A
	qNnYQwasvKkOVBs0XpT5CpAfF1T0oBk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lq4xeCbD;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776794890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsgX9m6C8CxQkQ37nZ4Tnr3XLVgFk8OeqKDAsOzJgs4=;
	b=57Cb87YTqRN7vikz3x4HlQsKrO/qRsSjIAkzj2plhFmzMFik/CgZhsxA6Rl+3jgdJL0a5Q
	OImUw3g4JMdX6QO+kco4EX4RHdTQTKpGW864DwpDx1XI59ak+6NDWj6s7UCILzfoj2970d
	Y9ThQJanHqz4SnHkNNTrdgFYlclv4y8=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488a9033b2cso52235095e9.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:08:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776794889; cv=none;
        d=google.com; s=arc-20240605;
        b=I2j3tzZXOOV7poyNzoAiKTNr64eOTdWolu9dSO0gRi/fohVocvPWZ0sZr9mLpFy6Yr
         AxSKnBLYre/a7aDZ/1h7RJhA7oXud72nfOSr77cckuPO/T3nhibMAxUdvK1/kr3Tdp/0
         CI87Vu6ukNE5VYE/OhwxO7HJC4scoGPonBc4KTM/6Fb+IGnaSYr10imCG0+AGicFFaFx
         OGor/Z/0fvQMrwbv0J52gftO5klO1ffSoKutg71pU+WWFQy/zbCcQ3fKrm31LWseoBo1
         r6uUOhO6QtT8SaH8TQwNOod5ZrgFJsZfoZkpIlenKqlPLwSPXUn6ecLIODAFJQRYPNED
         DBjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KsgX9m6C8CxQkQ37nZ4Tnr3XLVgFk8OeqKDAsOzJgs4=;
        fh=L4jnk9d6xMzsGUolQ3CbSGKJvhCgYfmO4wKdCBN5E8A=;
        b=Q9hNW06ZS6uJlC5U2/ovyByRdMMOhnTZLV3MzsvlujLK7h/zgFzukdP/uPDpNfbVpb
         4a2ebASn9GmdRANC/htez4/m+5DwJ4+bswQUvHPsPTHKPlTsWYeBHEV0b/2pXozxdykX
         R9/5pRQ3SvWjORbxU+K3ZROD5g1DscElNuETw2i7nv/khoO0qLOyLyv/Tas0pRIdnsVX
         3Y8uxv1P+MBDs21BFzFM2ddkqRyjIijnZew9GyYcOIoSfgw1mjkONn8nECXCSEdv+lb4
         LtnVi/Az70X4Zu0M5lNYWm5cmvdJ6uBrauhKsbNk8ohsmJCAxq/AA4Ycb+PKiyKMsopt
         8eMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776794889; x=1777399689; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KsgX9m6C8CxQkQ37nZ4Tnr3XLVgFk8OeqKDAsOzJgs4=;
        b=lq4xeCbDvJ9eR7qtSxcUl5e6vYOcql5W9AhKdvbhesWjJnGzfL56Cm7Dd/02JX+oPN
         WbfegK7ZMuUHAYA033qrdHX5mhZjVAf9x6BZ/FJuLfyjcZcCklUrqsjODGJczbULZs8D
         OAurbDudL1mS/mxr2T0twQgXyhPsn9mwVM7egU/E7XJXjp4eCsvDDmr5L9Nt7EqOr8Ur
         wi5P2KdB5qa4ZM+9e86SCPN2zBiT3WXFiHf1JCvTdRmm/XV0M2b2a8BodHK1dn9hZt1O
         RNUYbjQt/W6mTlsNYyBtd87d8ckz73zZwUTFCqmPDbKzNh3LfbGBG6O413iF1NgGVR27
         f4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776794889; x=1777399689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KsgX9m6C8CxQkQ37nZ4Tnr3XLVgFk8OeqKDAsOzJgs4=;
        b=IDiiz0eTV67Xr+pRuJyf1kImNJIN98E9X0K48VefC3FeuNn005M3EqCO+N9YD1DFv9
         OFcofdIZ5ISNnVBZ+9JGNUgvgJAqIAsUKyJYEy5r6VhDOziJCxXGq6OQjtRaM6YJfc7V
         Axw9FoGeVvDhNm4qPkcA+1nKl2zMY8DX2FguBXbQx28b4a/gE3fGtmRnnAm5qa9oI+Gd
         q7B90SIfbg9hLlpcCklvA+Hr7d6wle2Iop0GVxhknkkYuv93jE1USSatK0JEIrYCWUJJ
         CPLjsJjx7o5ZeZImP99/xs9QMAoCBMnPpDCs+8rdO6L44Eqie67DA7ZNsJbuJX2EUzCb
         9b0g==
X-Forwarded-Encrypted: i=1; AFNElJ8NXKRul839Q7/pJqq+HHXukPDBmX5AEjGel0/X5nHURX4pGHRM/qVy7QRWVuNP6xI83ovUolB8lQ==@kvack.org
X-Gm-Message-State: AOJu0Yye5u/XFWtCgIDYsqsHkkOIFVSjOr1sjVptolBVN4h71W2K8vW0
	PRNOUpO3TVO8/wxP0MFxFHECp4NIBI0Eb41pB6LliLjLzPOnE8fo05fkcx+X10FLUJkJVv7zLH4
	kdrA7T2kTFrGDVBbGBrPY7gnXfWs/fSo=
X-Gm-Gg: AeBDiesTQaMCqbig0NMJ/+gQgEf8CqSf2dTJQNh4FoA1XKy58Jzt0nj8Z8v8SbWJgnr
	9xSE5nociMbw08dWjoNB/4klij/V9Bl4XKoKLh0e6/JpvPMr0gPSNS15EvXurc1Zyzgl7q641sw
	k7WPzzG8BQxZ8hFsKVE5fMGHh2r/1uiWg0i58vwKFArRU11rj2EW4fXe52zPpwHGbX5efGQdGZl
	9LMvxCycFq7AlnA/0TXhD5MgDIWiTE/adBBtybVe4/eZbiZR07NJCx7L4GpAaEi9nhWnODEQ2Q8
	8a1Lk4z/2ikdfbF2nMYmBnnjxtxv7OQFUBsvrQYYyFB0+qxcBp9PesMuiHG9KlzvhApNmEMLrP7
	W
X-Received: by 2002:a5d:4b81:0:b0:43f:e721:76ca with SMTP id
 ffacd0b85a97d-43fe7217864mr16856624f8f.45.1776794888852; Tue, 21 Apr 2026
 11:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAKEwX=M5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodwbf1Fe=gzew@mail.gmail.com> <CAMgjq7Ae_VH6mLQito5MFnxmp7ScZvF9xw4P-yU-yUBkPZ9_YQ@mail.gmail.com>
In-Reply-To: <CAMgjq7Ae_VH6mLQito5MFnxmp7ScZvF9xw4P-yU-yUBkPZ9_YQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Apr 2026 11:07:56 -0700
X-Gm-Features: AQROBzDE8Aq5HdmW60NHS0U7vvLQGFi9pUSjLXorhoU341mxwA5GKtAt9XQb5K0
Message-ID: <CAKEwX=PkFiP+u+ThrzjTKBi+usQf2uuhTZcfB2BNNA8RboOFDQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Kairui Song <ryncsn@gmail.com>
Cc: Wenchao Hao <haowenchao22@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C7820100007
X-Stat-Signature: hjzyb79frh7ufdob4sj1eig8wqcoe9rh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776794890-16427
X-HE-Meta: U2FsdGVkX182FDmlDWbvE0x9Cq+c3MXgIjzHrtYOHZzWBOAD3X6xgkO+P9lcgYCuruKhhfMAeb91J/m7Foxl9tuc0KBLQ0Q5XiK8ZFrw4bl0fHwjGSBmZzPMqDsks+dPzChBcqfGbOyflEH0X2na0R57dX1qCNRcd8/u7MbT5hrsRgag44IvIuI+GD6ZHb0ixKk0oeklZ33Ys4B7hTYnAiLUxe07O72J9MapIfRF2lvjGVLBffnQeMcWII2TKfI8ltzo09ZAbq1GzPzKIJGqKNBm9UJ+QeiZ6zBmv/XLoM95Yg4lLh0DutvOGEkNqBBvVh/sPVr0SBUtlGrygPAjBR2qY3NGjxbjKIa1X4CP4/NhcqBODKLYOl6yN0qt3yBFMdJ1yE/v6OQzzQdypeYIAO8SKJ8HTtIOrbKMMHKs/IlJ0DlRsYEnDawjteN2EbcQMT3IKsrPlgHK7srQCRCbienaTYWGnodlBU/QYl3IGTkStpwHZHidf+H+e94nu9GrhPrT1pvWsfP1drdBYJdsCx7ecUktpULezyCVJ3jw2Zac5qUN/4ehbMWR3IVYoLUI5KwxNgLFExYXqn8KlzQvxNjEl8iWy7r5C/q0/E7900SmkwHs9BUy5UOt/U5ZcR47QIHZurqXws7TLKqBoUxwObS0Xd31dVXK1KDQAoDbUJSseVTgFMAQoWsgoVP84kq89C/mygbKhi+E3AzQL3hBAI0ojEKDUqpZcedj4+QFWJK83GxVQZZJHWYKKodqJFd0GP83UC/rz7nrQlUtzGKRQRb5NqXmP7KAcVIxzy2Ux0/TCTO6XEHR8WI1vWpZozr1qbQhAG6lK0qwwuMsKs0FoKeuAgqcQ856C3Emev7DcglKB0dxkEKt41ko4JF1ylUI3PHdgU/HNMfkOM4Ktg9FNWdJd7ICLTUSjROqjI3w/s423DZ6zIJlUK3Q4g3cAN542J667Uxc7mPOI9WvWns
 K35YHVmw
 jHUkhrvZ9NU6a0AAfgW6VxDFP/2CIuzFCNWdIkD13D1EUjzIwfVeojKaLopooaIcApoNCOtqJCqIESIVQL9h6r8BGkq8m2J1o3a2N6xbi90ZcKc65wqcA9Ep8gpy++PxmOb9zpWVfnRRHgem9ktsH1D8sySDb1ikmWVgofHEut1DFM5+JZATEI3kzZAjULZDgkFUDeESuLT2sx+trBiseq2RWD6GUdHZL+N2Y59EzfK8SYlHysja/Uf6rgfyvhjSJT7JT/Q/UOhYYXKGG5k3x0YsYq4PwUyvJ5w3Jscse1w5TAiRgPPpWtfxm6WxpS7l47SIF7pNWEecv0MLZSn66Io5QTUB0xnDdG1lHiv+4z/gSS/P56phbGC0qUeVEcTQMeHAQJMpE/npJyWuY7kx97SbMHowWHXRWASmY7CoG18dLExEQpPsCBOgiHOZEC65PdS+SJFrtyMfPYKO51vpCbikTSWpzQjITNavUYyqE81L8EVjn/GZu1qNRHCrOUhKAlX5WVfqQVMP4BmIAIlOLf2Fyytz6NtdDuxQ3tex7Zh41RVQAsj2naDG0UQ4bXxFqvOhF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 10:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Tue, Apr 21, 2026 at 11:55=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
>
> Thanks for adding me to the Cc list :), Barry started this idea with
> ZRAM, which looks very interesting to me.
>
> > On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gmail=
.com> wrote:
> > >
> > > Swap freeing can be expensive when unmapping a VMA containing
> > > many swap entries. This has been reported to significantly
> > > delay memory reclamation during Android's low-memory killing,
> > > especially when multiple processes are terminated to free
> > > memory, with slot_free() accounting for more than 80% of
> > > the total cost of freeing swap entries.
> > >
> > > Two earlier attempts by Lei and Zhiguo added a new thread in the mm c=
ore
> > > to asynchronously collect and free swap entries [1][2], but the
> > > design itself is fairly complex.
> > >
> > > When anon folios and swap entries are mixed within a
> > > process, reclaiming anon folios from killed processes
> > > helps return memory to the system as quickly as possible,
> > > so that newly launched applications can satisfy their
> > > memory demands. It is not ideal for swap freeing to block
> > > anon folio freeing. On the other hand, swap freeing can
> > > still return memory to the system, although at a slower
> > > rate due to memory compression.
> >
> > Is this correct? I don't think we do decompression in
> > zswap_invalidate() path. We do decompression in zswap_load(), but as a
> > separate step from zswap_invalidate().
>
> It's not about decompression. I think what Wenchao means here is that:
> freeing the swap entry also releases the backing compression data, but
> compared to freeing an actual folio (which bring back a free folio to
> reduce memory pressure), you may need to free a lot of swap entries to
> free one whole folio, because the compressed data could be much
> smaller than folio and with fragmentation. And swap entry freeing is
> still not fast enough to be ignored.

Ah I see yeah. That's the not "as much bang-for-your-buck" as folio
freeing category. I agree on this point.

>
> >
> > zswap/zsmalloc entry freeing is decoupled from decompression. For
> > example, on process teardown, we free the zsmalloc memory but never
> > decompress (if we do then it's a bug to be fixed lol, but I doubt it).
> >
> > Zsmalloc freeing might not be worth as much bang-for-your-buck wise
> > compared to anon folio freeing, but if it's "expensive", then I think
> > that points to a different root-cause: zsmalloc's poor scalability in
> > the free path.
>
> That's a very nice insight. I had an idea previously that can we have
> something like a zs free bulk? Freeing handles one by one does seem
> expensive.
> https://lore.kernel.org/linux-mm/adt3Q_SRToF6fb3W@KASONG-MC4/
>
> It might be tricky to do so though.
>
> It will be best if we can speed up everything, doing things async
> doesn't reduce the total amount of work, and might cause more trouble
> like worker overhead or delayed freeing causing more memory pressure,
> if the workqueue didn't run in time. Or maybe a process is almost
> completely swapped out, then this won't help at all.
>
> I'm not against the async idea, they might combine well.

Completely agree! I was thinking about batching the free operations
for zsmalloc. Right now seems like even if we have a contiguous range
of swap slots to be freed, we call one
zram_slot_free_notify/zswap_invalidate at a time, which then call
zs_free one at a time? I wonder if there's any batching opportunity
here. Might be complicated with the pool lock and class lock dance in
zs_free() though :)

And yeah the async stuff is orthogonal too.

>
> >
> > I've stared at this code path for a bit, because my other patch series
> > (vswap - see [1]) was reported to display regression on the free path
> > on the usemem benchmark. And one of the issues was the contention
> > between compaction (both systemwide compaction, i.e zs_page_migrate,
> > and zsmalloc's internal compaction, but mostly the former).:
> >
> > * zs_free read-acquires pool->lock, and compaction write-acquires the
> > same lock. So the compaction thread will make all zs free-ers wait for
> > it. I saw this read lock delay when I perfed the free step of usemem.
> >
> > * If this lock has fair queue-ing semantics (I have not checked), then
> > if there a compaction is behind a bunch of zs_free in the queue, then
> > all the subsequent zs_free's ers are blocked :)
> >
> > * I'm also curious about cache-friendliness of this rwlock, bouncing
> > across CPUs, if you have multiple processes being torn down
> > concurrently.
>
> That's interesting, when I mentioned zs free bulk I was thinking that,
> if we have a percpu queue, at least we may try read lock that on every
> enqueue, free the whole queue if successful, then release the lock.
> I'm sure there are more ways to optimize that, just a random idea :)

Yep! Would be nice to have some perf trace to pinpoint where the overhead i=
s.

On my end, I perfed the free phase of usemem. It varies a bit based on
exact build config, kernel version, or even between runs, but the
cheapest I've seen for the pool lock contention overhead is about 3%
of the free phase (this is on baseline, not vswap kernel). That's
pretty big (bigger than vswap overhead even on the kernels with vswap,
which is kinda silly). Obviously the host was very overcommitted, so
compaction was running in the background at the same time, but
still...

