Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459E8F588E3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DD36B0088; Mon, 20 Apr 2026 12:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE5A6B0089; Mon, 20 Apr 2026 12:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DCBD6B008A; Mon, 20 Apr 2026 12:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA686B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:03:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 032041B8FC8
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:03:07 +0000 (UTC)
X-FDA: 84679403256.15.849D21D
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4A931A0013
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:03:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oAzowg3c;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776700985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBF/huw+jCdmavak8Kfcjpi9kTHcjyw4uzaIxzF9jcE=;
	b=l13m++y2IT8MspdRR0owU9amOOEBjp9iUXChvFMMC0miXbBZhmtacrjX7sGwMGAbLvNNHD
	iOAUpS5V5oy1+KSQHi87nrQRNYzi5j6C2ipxCf/ifcsj5AhsQ5uSLVDajjR5EM0GrssMVS
	P+SJ3EMBIPGevH86tLGwi12KJIW2TRE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776700985; a=rsa-sha256;
	cv=pass;
	b=PIlw0/NUDNhSDDe5I8HpYzkIXDcd7IGLHPSQFBVV0uyacSsJR2JgFc+3K3ZdvxttYeKIoV
	kUGMaSxV3EqcXkNZyj5V1zRXG5jC+jW+9LJ2qzu//kxQytvXo8OfivY8ajSveFUmouQa8Y
	VZeazng7IpU7Ecuzx4RbmcZ/jelVDK0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oAzowg3c;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so46755615e9.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:03:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776700984; cv=none;
        d=google.com; s=arc-20240605;
        b=cu5avwWrm1iT0gHrKw4Ct377VMspQRhsVh/Io8c3L1ysUgkG/Ej4pJ0pEWJ14I6v1i
         ddpj836oy9Ppa9r8GykBO9TZGawzxZJ+amt4HhzdaF3IkOZc/XQKjYZ7c/jZoahZvgr9
         uIlE0EFOhEU6yRlRhzpuz4JW4odM8Cm5mizrUIpkPMkgj0+eZbpfWOm6XJWGCFYOIfo0
         4xMEHGmIDibSzPdpZYxhXks49s4ZJHNUuqSKufazfPOxwADxoA6kJpZ66bG6Nv6EcmCn
         bDMkkrW/aygAcKH5ezUgtmcyz5aslyvkWRG9E54Vukymk8xGNzn1+AmnIPcjiscEEYOm
         zdkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iBF/huw+jCdmavak8Kfcjpi9kTHcjyw4uzaIxzF9jcE=;
        fh=4Ti/4ImbEowQRD4Jiy51oBw2tHOk8aUOlYhjhrOORBw=;
        b=WD5slx8twVY+heLGAQLalnyw36TWskQkWRWlIyX8LSKBas9CJ7S6iZhvJR1k4Tw93G
         vEBWdATXvZU7Yt4v+7h7hyGh8XOuj/CRAUuf8sjsGMQxLfIF66qkjkMmvcLzMl7LNSGz
         TbSRFNItap0yfz7xrZ9zI1lTwo0LK4w0QRR8LN1ICsSzEhz03mqJghOwAjH0bSJYda2d
         5OBO4MGv2eQPWPVgdu8UdIJbtcxkambby/3rzWg8QYIVOHr1JngiwUSkfYoCUMiuDUrX
         9U8Q0UfFPoWFHQrGUobx0QNpCvTPZZmcdpbXvhDph60JioxnJQtdTC6/BaykEy9nHz43
         hy4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776700984; x=1777305784; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iBF/huw+jCdmavak8Kfcjpi9kTHcjyw4uzaIxzF9jcE=;
        b=oAzowg3cbyRT30Hu8Ga3mXmXCqC+bUq+BOoaZls24ngHhHYgn+95A3LDoWISoJJeI8
         /cIr/hPpqZKDHXd6AP1gnFeCtp6PWKku9eOyIwwIEGVW2iRvJQLyqOpRDoFN5TbieC8r
         LGC0+ZsiFs3XnuefHXPGSZzpDtoVbq7IqMbhbkXmI661NzDNd3oNBkl6GqRo1WdoDz1u
         RMp1ivQ1+Mfc+sn3Z//cBzN+qcnfqScGUpJFn31mgxtBQnjkG5oTQoXI6y23UvJGKnhd
         PihAhwENrwxZKlra5/9ztfA4pfbt9fujsWZRywY9HiiIiS3JQIAe7NPQztlp5JjZIy3m
         /x8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776700984; x=1777305784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iBF/huw+jCdmavak8Kfcjpi9kTHcjyw4uzaIxzF9jcE=;
        b=ltZensveHQhQBDXAHPfQsiRYJsXngEb1owbCASWh25Ev7NymQm0XmGi5nuO82kG2tC
         o4m9Q0kX8ey4XRK/fO2CDyKL+MZIFSnJOnRTfaSTd0oInkHfJCd2qwTXLIK74udR6rId
         mx/s3YOoAFCRlpDW8tjuncBQUUMnDjwMHPEzQawFyttGMyJ41ex7OOloAfyrgAjCAptW
         GlfMWZIfXUzfJU+e69RDmOFTvwYxFq5KrGzwde/GBdu+13ZxlsMEEyqW1lo5b3kWX48D
         KOhPTUuv1d9uedhnq5vkpMUozTgsWEY2FRUghsxYmvyVAJ9gvvGUpN1v++45xhuH9Y2Y
         4mBQ==
X-Forwarded-Encrypted: i=1; AFNElJ8IKsTJjXEbMsmSllMk3oIpBP7NOnHMH1HmrQw7ZmyDGLa16HFIQDLkRI9JDDmN27JPHBgTxB4BgA==@kvack.org
X-Gm-Message-State: AOJu0YzQoStI/9VQK4ikAPZiyuaJgp0nA+9QJwyutXcglPFs0yzSR10T
	lDoo1WxiM+FfNwTK/ZpmLCtzKpnFtAWSn5N+6faDcUrHeDk0ip+p3IiVZ4fNS3cKtLs8QGI7qCC
	vlWH4RWsXON10L6/HrbPCUQZpK9KVrWA=
X-Gm-Gg: AeBDieud9xaTVBbK5KAGVqYnuwPnXim7AXmKkTM+U2LAzgPOxrmvHuIuKibiaEB/7Ug
	eoWvF8FUmamb7hRUgg5S4eqZkiSQqJYnr0ruCo2JSvE7SK4eZQSw0qNZdFOcivgMyHLdX8uEJhf
	IvoD2cHewGblLXG8o5kqnUQrHhHO7s0jV+J5wWai7UwqyPz+snjVoclO6ZRfLPma4gu6e/6A/Av
	A5MjndkdCeURBkp/YB4xsajh8r0ZUuImgLcengkw4/PHl/4fSilwdn5g53Xvt+akuqPMjJI1PQr
	AiQSsXzPhi+otg+2xf28PbO0lIdZocFYanQQmU4dRisNAEApkbtJxOinTSjkTG8HVQ==
X-Received: by 2002:a05:600d:8449:b0:488:a894:b27a with SMTP id
 5b1f17b1804b1-488fb74a8c2mr175647735e9.8.1776700983794; Mon, 20 Apr 2026
 09:03:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
In-Reply-To: <CAMgjq7AiUr_Ntj51qoqvV+=XbEATjr7S4MH+rgD32T5pHfF7mg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 20 Apr 2026 09:02:52 -0700
X-Gm-Features: AQROBzDxid6PXLYOtsvRL4lA7x1zRB3nMTMN0giu6Su7fE6kLvWGH4GcqL7x9i4
Message-ID: <CAKEwX=M4nWeAw1-geCwABuv-0okz3-x9SwNswL-1Ks9KEAS6Mw@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Kairui Song <ryncsn@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mij6ygpmzgo593k1hsygj6f8pqq63yqd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C4A931A0013
X-Rspam-User: 
X-HE-Tag: 1776700985-691617
X-HE-Meta: U2FsdGVkX193HECRoaxwIg+ee5X1jAPecSbu7Q6DPKI+cCadVvBaVRAaq1a54IqlMbaEWxAXOYyf09o9DVbr6BGUsUVBlgosDZ7cx/ErmuV6J+q5K+9+iQ4u7I6m4NDrnocLHGa5ubwNZSxk9/7QEvSc9r9m4JSmgU+pVp7nanR3aPOZWQ7uIQlRySIVujwc6E+K55G7uexYmSnZq9V08fu2wAGkCm+KOMhQ0bW568K2WdqTl4MbDiP7Hc/xBGUaWciaUOz9fJE4EB/rSzRVh8ZvoQBGd8Eaogk7/4JKR1Sw3krCxehPkUgK27ZexrnsSMKPKS88tphwllj9avr5MaYgwMd+rjqy4ga6Ul9IuTehKwMrMRysP/lguNDM42mCSpnXWSUpuUNf5CPOFp5EcNINDogldHCK6+csYEJyYD7Me0254UajQl7nN31ZWPpjARAELQsUi69Z2W6tEckLkGv7GCzrY+BdRvMC3Vk+hisl4N8onkTxAyPSi2PAr/kve3p/dtWaRi7r31EAOuAL2l8r7+aF6oG/ThxEtcgVMqh2LLGHSqmxQy3DuHZizSbJv2I2N+9m/1WYSJedqwCMzkuZ3OOkd/uvqp+CmMwAquPg7MnK2qXKOYzjVDgQSHvNgXqLyvO103CaYFwkkM9TMdyDfR17qcgJa8M5aPH9JqSSVCGaKJgnhGq1+xS3/DvJ69vjPcrFAuB6/taLo89I39Ez57YRAzZCWFG+UmloFOWPxnsYSufhYrqYF5BxFFSW27c7/b5aIn333xJHrHn+itAhgTC+4ivQsBwlqnov2Idz4X9S3Gg/phVHNgKVlMJPLqYwA8okhsYHZPEint64txbuFQ3VqhecwRORbRQ3LZKXABMHBvRtEhzg9qrsyMnlf6FU5KosbMhrLmQJ2ihkp59aW+163Cwlu9J0ekYBh2TxA97NLGkV84p3p0R4FVsGqunMXREQL0WHiGKJdKl
 keq2+HUK
 Mf3i5/C+goHeUrxcyq0uIrTS+nQDIRGJ5CKbI/bpRCrZ1uZ0tRw/Z7kuQwWa+7y1h0L45m2E2gnbSi64Z9GQNNzyxnmTbwQvGAADgH9D+Ez93Bpyg4nR1tO5SCMSyvahIGUBU6epRBEjzo9JoFDxOSraLHlt96g1EbtTNupRAwu3aFujLV0L10CXaIVeTU4AK+uvwvx55BnzFqWka3O/pF6Iw+dfEQEtHK1C3UV9Tt+lZhb/2J2YMtMXPjadjYeEnS2XGk8jmwy/MdcxkV1d+1o8Q3/ziN2n//JQZzJqxmdQyOkNS0RY7N5aIlEHK6l3kuFXtbDwciXUDOdGBXmVSN7ShBrBIBl+5fTvubGJtsUAXwEjk8iQijvOgaWpX9fWubym2FWsqwHrd0bryn4HQnCjF7s9GHciDVl62cCdQ6pZUJaqa2v7zv+PBcks0VW+2zRT3NYVRSoPaz0UAAHLvl9efcsoM3OpxqDtY3Fp+c3bRjESn3NBK+FHkbyWuDibu2uKuWj7xVPNskTXhzUDr6Oiu1UHAHv8VGDttrOVPebTCbBdhkXckEW2lvNFtnNd6Uhdn8Yo42uAJDIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 3:09=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Mar 21, 2026 at 3:29=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> > This patch series is based on 6.19. There are a couple more
> > swap-related changes in mainline that I would need to coordinate
> > with, but I still want to send this out as an update for the
> > regressions reported by Kairui Song in [15]. It's probably easier
> > to just build this thing rather than dig through that series of
> > emails to get the fix patch :)
> >
> > Changelog:
> > * v4 -> v5:
> >     * Fix a deadlock in memcg1_swapout (reported by syzbot [16]).
> >     * Replace VM_WARN_ON(!spin_is_locked()) with lockdep_assert_held(),
> >       and use guard(rcu) in vswap_cpu_dead
> >       (reported by Peter Zijlstra [17]).
> > * v3 -> v4:
> >     * Fix poor swap free batching behavior to alleviate a regression
> >       (reported by Kairui Song).
>
> I tested the v5 (including the batched-free hotfix) and am still
> seeing significant regressions in both sequential and concurrent swap
> workloads
>
> Thanks for the update as I can see It's a lot of thoughtful work.
> Actually I did run some tests already with your previously posted
> hotfix based on v3. I didn't update the result because very
> unfortunately, I still see a major performance regression even with a
> very simple setup.
>
> BTW there seems a simpler way to reproduce that, just use memhog:
> sudo mkswap /dev/pmem0; sudo swapon /dev/pmem0; time memhog 48G; sudo swa=
poff -a
>
> Before:
> (I'm using fish shell on that test machine so this is fish time format):
> ________________________________________________________
> Executed in   20.80 secs    fish           external
>    usr time    5.14 secs    0.00 millis    5.14 secs
>    sys time   15.65 secs    1.17 millis   15.65 secs
> ________________________________________________________
> Executed in   21.69 secs    fish           external
>    usr time    5.31 secs  725.00 micros    5.31 secs
>    sys time   16.36 secs  579.00 micros   16.36 secs
> ________________________________________________________
> Executed in   21.86 secs    fish           external
>    usr time    5.39 secs    1.02 millis    5.39 secs
>    sys time   16.46 secs    0.27 millis   16.46 secs
>
> After:
> ________________________________________________________
> Executed in   30.77 secs    fish           external
>    usr time    5.16 secs  767.00 micros    5.16 secs
>    sys time   25.59 secs  580.00 micros   25.59 secs
> ________________________________________________________
> Executed in   37.47 secs    fish           external
>    usr time    5.48 secs    0.00 micros    5.48 secs
>    sys time   31.98 secs  674.00 micros   31.98 secs
> ________________________________________________________
> Executed in   31.34 secs    fish           external
>    usr time    5.22 secs    0.00 millis    5.22 secs
>    sys time   26.09 secs    1.30 millis   26.09 secs
>
> It's obviously a lot slower.
>
> pmem may seem rare but SSDs are good at sequential, and memhog uses
> the same filled page and backend like ZRAM has extremely low overhead
> for same filled pages. Results with ZRAM are very similar, and many
> production workloads have massive amounts of samefill memory.
>
> For example on the Android phone I'm using right now at this moment:
> # cat /sys/block/zram0/mm_stat
> 4283899904 1317373036 1370259456        0 1475977216   116457  1991851
>    87273  1793760
> ~450M of samefill page in ZRAM, we may see more on some server
> workload. And I'm seeing similar memhog results with ZRAM, pmem is
> just easier to setup and less noisy. also simulates high speed
> storage.
>
> I also ran the previous usemem matrix, which seems better than V3 but
> still pretty bad:
> Test: usemem --init-time -O -n 1 56G, 16G mem, 48G swap, avgs of 8 run.
> Before:
> Throughput (Sum): 528.98 MB/s Throughput (Mean): 526.113333 MB/s Free
> Latency: 3037932.888889
> After:
> Throughput (Sum): 453.74 MB/s Throughput (Mean): 454.875000 MB/s Free
> Latency: 5001144.500000 (~10%, 64% slower)
>
> I'm not sure why our results differ so much =E2=80=94 perhaps different L=
RU
> settings, memory pressure ratios, or THP/mTHP configs? Here's my exact
> config in the attachment. Also includes the full log and info, with
> all debug options disabled for close to production. I ran it 8 times
> and just attached the first result log, it's all similar anyway, my
> test framework reboot the machine after each test run to reduce any
> potential noise.
>
> And the above tests are only about sequential performance, concurrent
> ones seem worse:
> Test: usemem --init-time -O -R -n 32 622M, 16G mem, 48G swap, avgs of 8 r=
un.
> Before:
> Throughput (Sum): 5467.51 MB/s Throughput (Mean): 170.04 MB/s Free
> Latency: 28648.65
> After:
> Throughput (Sum): 4914.86 MB/s Throughput (Mean): 152.74 MB/s Free
> Latency: 67789.81 (~10%, 230% slower)

For this test case, I took my 16G (a bit less than that technically)
52 cores host, using zram as the backend and MGLRU, for a spin.

Keeping the same parameters as your usemem command, unfortunately, led
to massive thrashing (even with baseline kernel) - unfortunately zram
still used physical memory so the overcommit level is too large
(especially with random access pattern, i.e the -R flag).

I then tried reducing the 622M part to 480M, but the problem with that
is VSS5 did not show any regression - probably because the
overcommitting is too low, or not enough concurrency. I had to push
the concurrency up to 52 workers, allocating 300M each (which is
slightly more memory allocated overall than the 480 x 32 case), to
finally show the regression you reported. Variance was very big with 8
runs though (what I normally use for usemem these days), so I had to
do 20 runs per kernel - fortunately these runs are fast:


Metric      baseline       vss_v5         new_opt_v2     cc_v2
real (s)    15.0 +/- 0.8   18.3 +/- 1.8   15.1 +/- 1.0   14.7 +/- 1.0
sys (s)     396.4 +/- 31.1 511.9 +/- 60.3 404.1 +/- 34.5 392.4 +/- 39.9
tput (KB/s) 28188 +/- 6996 23287 +/- 6629 27999 +/- 6623 28744 +/- 7015
free (ms)   101.1 +/- 52.4 91.4 +/- 41.5  93.1 +/- 43.8  97.6 +/- 49.5
% real      n/a            +22.4%         +0.7%          -1.7%
% sys       n/a            +29.1%         +1.9%          -1.0%
% tput      n/a            -17.4%         -0.7%          +2.0%
% free      n/a            -9.6%          -7.9%          -3.5%


(I realized I mangled the output last time of the "memory reclaim
metrics table" table due to auto line break. Let's hope this is
better).

Strangely, no free regression. Hmmm.

But real, sys, and throughput regression are real. The optimizations
do close the gap to within noise level here too.

