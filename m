Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC23FEA839
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6E76B0096; Wed, 25 Mar 2026 05:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD9F6B0098; Wed, 25 Mar 2026 05:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF926B0099; Wed, 25 Mar 2026 05:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAD4B6B0096
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:48:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 938AA16083E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:48:21 +0000 (UTC)
X-FDA: 84584110002.17.A503426
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9DCEC140008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:48:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FoWmc6Tj;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774432099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q42hLuNnyE/SONvYBPSd1qNaKVxpDDOLa5+gI5Lz+Cs=;
	b=PRlTDshjJs93Yy9N0nac5rbw9BL9PHJO3XbWXgXVhozCvjrHvzTBaqE3Y5CHJFiNaI/7sc
	xNVg2d7iTyQeZekSMtRGhgoBryDP1DyjKL8zihFTr/J0kx0lrcC+f38J7xTSjgVDwqTJ5m
	XTzP16kxGZ92EJZxBYMnhQu6JFvClqw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FoWmc6Tj;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774432099; a=rsa-sha256;
	cv=pass;
	b=FBM6K9Jq8lxeRtZAQTBHewxHPmWBwz4IxeJrjIb3O3BAH0owP6i3XqWpiylU9kRiyH6ohf
	eT6+Q/j4mTRhSsR23Uh0sIhgrtvIeEWgcBT/8hmWAzKpZJRoRTzV1jRVN+FLbvBBdnyCkl
	Iq2W3K4H6wpydh5syxvgglv1q1lHLnc=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6676d55d01dso6636346a12.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:48:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774432098; cv=none;
        d=google.com; s=arc-20240605;
        b=MOQONGl/GhNgXCdLpauf657sRPPI3hbcJK7EsVNxCweEt1T+dV9TQDy20ZiMSPwjHc
         0Pr1v80HdRnRd32x/gCXCBYsrN3K83bUtcY3zLHORulSYmk3zXA3+49USFgOQG0gccmH
         R+6++sxumT5bg8qpIDmkgTK1suV0GROkzAJ0ATPL1FNrCoWN0e5rJD7mRouP9wPfeIVe
         1eaRy2ok34Livz4P1+NvGpdNkpdOxKvxa8rL/DnxEdp27vRaXbz5s3I+fcXH6+iBvQ6Y
         L1fiixREDz1k/JnfVcsIZmYPO/NWbU+Y6CXavKToaSkVnnlh2LzTm3IgNB0IfKxZgcLv
         ohXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q42hLuNnyE/SONvYBPSd1qNaKVxpDDOLa5+gI5Lz+Cs=;
        fh=s29UgilmMNtDP+2rxfUvIikeOr8PFIf+kjvPE3KCX+w=;
        b=EcEMxT6BthmpbKPdsieZG/lEomKdLrcw/BL6rubobsPwN0z6XZ7IbOFYtuMxo+25Ea
         Wvj2YZNR6Ue6H+qUDVrFAXzDF8HDFoNcqdnZAR/XC9YsXZOfjmium5vlYEIAmkqDjkQN
         34/NQe6EI2AuYZFqxG+sIWRhowF+xF9vPXAAxKs0UKX7h1vjoAjofxab0q+G7efTNWGh
         N1fEnK93hpKP7RO4zEk95sR5qVJaPU5A5RolTVb76FPKD7F1/tL3vYRQUM2uEe1qF6c1
         TMswOMg6kv1QX0atmDzvb7ZivOzsmxC6VH9YIDNaD9D8uDZkoyV4yzDubv0yIFTyunGg
         42Cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774432098; x=1775036898; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q42hLuNnyE/SONvYBPSd1qNaKVxpDDOLa5+gI5Lz+Cs=;
        b=FoWmc6TjB8EvCIePGoRf6Ypsz8JnhMID5FPe7rspNfQy+IzxvaPdXS6zVDOwVx9djA
         v/oCmVbXg31WLutg7imNfWs/Y9uBrzllDiB8bsgFmogKfbLyupWBpPrcA5l4XBZMEglj
         b5tvbl6E9hG3nBxiOurPxb1Kp87LLMJhV3NCkyL/gEUyvE7Dx1GmqbecWU5EIAOKdtQS
         uGwYMNPSh+5rQT0Mf609ksVKYm9XKXqioEuBvR1tWBtAUoWLFgKrOxq5HmnlFCLV71mB
         nCs0BtKH1RZBKHL0Izy/VdhbF9Bfy3lcfObfsg8EeWp5CII1qU5DNTgrp7QoD4NwFx5y
         lPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774432098; x=1775036898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q42hLuNnyE/SONvYBPSd1qNaKVxpDDOLa5+gI5Lz+Cs=;
        b=QWBl+p8fdOjvUPDOOZqvGI0K6AjnlBHe6nwi6u+cHY36lgrxrxJ1WT8dEAlmxIqtEr
         uzZaXAKSEOVZyqB4/kry9hlWnamC7qnGtL9vpiKpEYmT5TDkuYbrwCruhRNEe1U/dbS1
         I3NyZmLOzmg87vp8z2P599aZamfqYcLCiigRSiywQ/3DIXrnWmgBK+W5PXWFlgyctjOj
         gi6c0MDj7262ABw2xPabf1DbwwKZLcjsokUUyVznuCi9oIdZGh28GxifqmGatRjc7WXS
         UQ2t9/kOKjFPfFQTOB7OtpCzTDuK+b2wpRis8GqbuDVyjhRJaT16h2GcjDJ9tDeGaXZ9
         QTMA==
X-Gm-Message-State: AOJu0YxDCAwz6IAmvnlc94OV1wxHkpyzbK613AAd0/NfJIx4nYuU1wSg
	UKh1SbXu51SYuqTj7B+XNASiyIIvh+5XweHr92c9esV8H3F1Tq4n1g0rGWswizttl5O+FokwVq7
	GZLS+BfeSG2FLNUG2oeG5HMOdQEFGeyA=
X-Gm-Gg: ATEYQzxG8JukojtROOhPbfG94OKiclO82ovNIAiXhi8DLY7inJUFTLTizFPeUg6NlIK
	LFrW+OjbUmrkVjPM9xwCALMQhrGBMhWje8fZDnLGoakRghbcZaEW4MNYi0mNigL1iEDxlAyfZop
	lyK5js3SJ1snyQCr4alrVusJiw5W0QR1lnRtDnlgysqIhkWFEX2Ls8DIByQ5uEW3W0WZSRLsYKE
	okivEOyr5pJVfmhPhmwW3OtVpjPz260/FJVF2QNm0sBW0LBJAsaSnH88QT3DqUgDchQQI3Vw54+
	5h88zqA3GXmlWv7OcZvKsAWIcURVm9Hc/1g1mn8O
X-Received: by 2002:a05:6402:34c8:b0:65c:cf5:193b with SMTP id
 4fb4d7f45d1cf-66a826c90admr1575170a12.24.1774432097703; Wed, 25 Mar 2026
 02:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <7ab8edd7-381f-4db2-9560-b58718669208@cachyos.org> <CAMgjq7CuEYAzZFmS2T7N6je6VHffVkH1hh64YUuShFBnrJJvqA@mail.gmail.com>
 <85b4be3c-09a3-4a28-924d-71a20db3fd62@cachyos.org>
In-Reply-To: <85b4be3c-09a3-4a28-924d-71a20db3fd62@cachyos.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Mar 2026 17:47:41 +0800
X-Gm-Features: AQROBzAKre_lagO9AmBYBRDKe5AeR3BiM1-e80RZ1iTw0IYy9x9Ii-Cn8O4XbKw
Message-ID: <CAMgjq7AQeP8maeMWNun=60oyq_KDu18MwXfGEyK4bwj_k92NgQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] mm/mglru: improve reclaim loop and dirty folio handling
To: Eric Naim <dnaim@cachyos.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9DCEC140008
X-Stat-Signature: 6335cg6tuuxox7i571ce4kagjtiofrsh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774432099-918109
X-HE-Meta: U2FsdGVkX1+3DRBitG/Tr2xOIwd1GIT9kLz41IjW8Yv4jsgjVvnpfewjgiCmpPWqewl9JwgJmaYuatE1ydsZY/+sUpou11bP07vnqSc0hm0hJAWVBG0Ppi6XXfu7xeeFADpuavYLk2S6nEVSir0E2YNIKs5389xrMn1bpv6iLXj8dDn8weO1NH85veWy9ZtSnDvAXwUpm8Onj0DnJuX4Eiezm8suu6FdeuOlN0nTiCQbeR02kxV61z2RuT2Go5l1SrHtZen1Pq4w9uL+5oGsA3HshCXsRsiph/NNV3EwFjDaZM4ZORqd48mbxmkGJ1Hxt+bGqGdJ3htKUoS50AXk36BqVQXfOHDvzKMiaRuvLZDxAwHnTMvA2P1Ohlke2fU/IOI75xdvboR7BqX8f2VkVEBj/AEg0+Hx+Nim+j3CHErxj1+0IbSBvxnIG7QfkdWIaopvePCrNMVd7DaR8LlRxSBMkr0DYVebVnAnErPHHw3l5YxbZGiEPzH8lAdFUSGziBJsglWONoWQliXA641g/8lPM8YChsyo/glBhc4QnkZE6YnHPylHrxpE/Kr9m1P2Rp2pDMmisTt/V9f6+lvPti5W8rWPSBbv1zzhWgXtMQpv+XkJA3FnmbaBQ4j0HNMvB3Xu71oSSZzIlWeYujPlNMLAezMItQRdStpi1hnQtk3IVaxKKL2+m1GyZfd1sztgk/rd/dNicz8o6N1TeSkws2OXBLzK4i55f4LnCBN5iDVEj6BgQxEb+9AL2vFJoVjmC6TfkIu6pGOgr0hQ4ZcLTbKsh8dRiA8p7jG6xsHp02TQdS3DeQt2vfsP1VIHTxs5U2PpvCRENz0ACc0UdUBl0zQOG76+qMUyIm1Fldzw+Ysf/PwO/mUajxDZ2mQoTAQaMWIxDkjvAfTMmqsnhWoGi2f0RxZ+XMk40xbqgwr2DB4x4WN38kzGzs8DX3yRVBQT0S2CFjr9oNLTTAslLX/
 LWUDNWVz
 bRCZcif3Y6iK2IdG3JVt9m4Cu2YwXqBU+vzjc6hI/8+ksezeqAo9khKaJ+2ZyhEmvjymczX+g/3zSO/sCESyi7DH6Gp6n7NB6QHn7PZgUUWr4yNgIiIoie2q2zLHCw3LSjCKYoYRr7bdzcprSeJVzl7dUlwA0RRUxXhlRRXZlREWeryziiDHHBTuJR8FbrUDG9lBxtZXZZby9DcPF5M6YIYFY/rNxvo96Xy9+mxQ7WiD4rg4I6WPpCXO4ZT02yMUsBigBgyu+LWeMnQKDWqxQ6uS43qN8bFF6Wqn6UTg9hNAztowVsUXdA9yAcGM2sWMBchTAfm9uL+eCSCeSZxxpzm7CopWtRC494ZNVlaz6Ot5/tpwKXhvq/w0lFOvcI4VY+EIPppZEI0xnc5BDVtwgwy3bJXl/VX9jYL/obuA9ZGtzBynV+Rby5eeueDoFQcGZQgklsqo7QiU6iu2ZHyz/hUOFonkNMtm/V3ex+kW1kM7/mq+X/Bs4r/jqLtrd3vIl6sQuAfGoPdBPXZqQJPRfz9ZDOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 5:27=E2=80=AFPM Eric Naim <dnaim@cachyos.org> wrote=
:
>
> On 3/25/26 1:47 PM, Kairui Song wrote:
> > On Wed, Mar 25, 2026 at 1:04=E2=80=AFPM Eric Naim <dnaim@cachyos.org> w=
rote:
> >>
> >> Hi Kairui,
> >>
> >> On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
> >>> This series cleans up and slightly improves MGLRU's reclaim loop and
> >>> dirty flush logic. As a result, we can see an up to ~50% reduce of fi=
le
> >>> faults and 30% increase in MongoDB throughput with YCSB and no swap
> >>> involved, other common benchmarks have no regression, and LOC is
> >>> reduced, with less unexpected OOM in our production environment.
> >>>
> >
> > ...
> >
> >>
> >> I applied this patch set to 7.0-rc5 and noticed the system locking up =
when performing the below test.
> >>
> >> fallocate -l 5G 5G
> >> while true; do tail /dev/zero; done
> >> while true; do time cat 5G > /dev/null; sleep $(($(cat /sys/kernel/mm/=
lru_gen/min_ttl_ms)/1000+1)); done
> >>
> >> After reading [1], I suspect that this was because the system was usin=
g zram as swap, and yes if zram is disabled then the lock up does not occur=
.
> >
> > Hi Eric,
> >
> > Thanks for the report, I was about to send V2 but noticing your report
> > I'll try to reproduce your issue first.
> >
> > So far I didn't notice any regression, is this an issue caused by this
> > patch or is it an existing issue? I don't have any context about how
> > you are doing the test. BTW the calculation in patch "mm/mglru:
> > restructure the reclaim loop" needs to have a lowest bar
> > "max(nr_to_scan, SWAP_CLUSTER_MAX)" for small machines, not sure if
> > related but will add to V2.
> >
>
> As of writing this, I got some new information that makes this a bit more=
 confusing. The kernel that doesn't have the issue was patched with [1] as =
a means of protecting the working set (similar to lru_gen_min_ttl_ms).
>
> So this time on an unpatched kernel, the system still freezes but quickly=
 recovers itself after about 2 seconds. With this patchset applied, the sys=
tem freezes but it doesn't quickly recover (if at all).
>
> Curiously, I had the user test again but this time with lru_gen_min_ttl_m=
s =3D 100. With this set, the system doesn't freeze at all with or without =
this patchset.

Ah thanks, that makes sense now, the downstream patch you mentioned
limits the reclaim of file pages to avoid thrashing, and your test
cases exhaust the memory on purpose which forces the kernel to reclaim
all reclaimable folios including page cache.

A thrashing page cache causes desktop hangs easily, using TTL is an
effective way to avoid thrashing and trigger OOM early. That's why the
problem is gone with lru_gen_min_ttl_ms =3D 100 or le9.

> > And about the test you posted:
> > while true; do tail /dev/zero; done
> >
> > I believe this will just consume all memory with zero pages and then
> > get OOM killed, that's exactly what the test is meant to do. By lockup
> > I'm not sure you mean since you mentioned OOM kill. The system
> > actually hung or the desktop is dead?
>
> The system actually hung. They needed a hard reset to recover the system.=
 (pure speculation: given a few minutes the system would likely recover its=
elf as this seems to be a common scenario)

Yeah I believe so.

Thrashing prevention is why MGLRU's TTL is introduced, so I do suggest
using that. It can be further improved too.

Will keep that in mind and try to make some test cases to cover your
case too and make some adjustments.

BTW how does the kernel behave with MGLRU disabled for your case?

