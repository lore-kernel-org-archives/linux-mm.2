Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02291C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174766B00A4; Mon, 28 Sep 2026 05:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14AF56B00A5; Mon, 28 Sep 2026 05:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0136C6B00A6; Mon, 28 Sep 2026 05:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA6CA6B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:35:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E21A3C012C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:35:08 +0000 (UTC)
X-FDA: 85262662296.22.22E58A0
Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0CCA920004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:35:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VMSob60v;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790588107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7NixjEGofgkN3CS5IP+1OrrpCKUq/nSVKpFmSD6AB0=;
	b=HttwqlIfM/Bwm6gmBzteVdbVmAG9xH0GH4wMsqkXSxyt+9mRytimWzxdZbpy9stYWQtXLi
	LsYtd0XC4vEuHlSkuLSIPoBwh6LMqEkAALl5BGbzJmUVU2EBqc3iamdqKDN3lu0EyGbj80
	0WyqP8bqfntn9pC9o92O7LxgZ+oE8mg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VMSob60v;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790588107;
	b=RPzq+D+NgC5xTyrgXJQo/YIE6hseagB6hcHfEVsTNHN5enAlH05fAsWwFHH12iQODHy6Gw
	fi7/I8aWrVwSaxPCGjfD5lzWTs5oPC2UzZvkX1lA5C8XaAdV7WfNSmMALVEjGadG717lsM
	BRvW3ws/5tk6+0mz1JeaE+JiWya59Vg=
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2db9cc3b45so167159566b.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 02:35:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790588106; cv=none;
        d=google.com; s=arc-20260327;
        b=VPMYMh7D3/HuDX4sY43GwjmcQwkXyf2+Mbn9S4HbwkOrq3v791CDM0xj/+lJCTENNA
         kJAq0A0jtgUbCzS8N1UYnHTCNoGR5wI+GJtm0CLNR6DUapR6lC7yZeQfPdDrfJs4rhD8
         6Jb2e/LHqi9W/ZJGC5XvYKMMtKmDDEz12xV3TURxFyLp5tpGPlNsSwRYSGmbrE/QykzO
         sLaaNxY7+4IMntvdIv1iZUPxYEdRDjw9vZdrHqUZ8paQxs6dB9gxFIyhwwZajPa3VMkP
         RZcuN6WRUxzZj0iObwbGvH5qx8wWO91Iel13J6bSzMs2ngRwOiCUc95pkrhhYGVgtg0S
         HSrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J7NixjEGofgkN3CS5IP+1OrrpCKUq/nSVKpFmSD6AB0=;
        fh=ctgwL9ShqoxzD/fzs8d25fMUvP5sS5DKG/5RdOsaRg0=;
        b=QxifxvtR9NOf3iWJskrnJdtOLFb4Seg7MYIwC51li3FQ308EbNp2mXFcSpm5YWpWGR
         SSoXj5HqX3JPkE98kaKBlHcm+odIzxkvrW2EXJCs4GWoMX7HRI7dnsc9Km3IwT5IwPbK
         7S42r8YtksJwy5YqR+r9yZtDY51e3R+Pd+R3Dtnr/y158iOXquWAxR8ZUSvxTRHTmGYP
         Kg9WTd8Imoz4kemvxjq6Rg4+lmyz4yuQ/zJiUwqmDI3G+ckVcirN9lZhhoKCqcz5xCzE
         AhbOQVEN1llobkiZS5Iqx0zZKt945h0fKR4vrnPu1YVryYiLMzObVo5NGyzZ4Z4en/M5
         Qs6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790588105; x=1791192905; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J7NixjEGofgkN3CS5IP+1OrrpCKUq/nSVKpFmSD6AB0=;
        b=VMSob60vCd7uqF3U9WvxTrvuy0P1Y8jXbJIgI/1B+2EaQoARgGcq5gFWr7E+RMg9Se
         fJPCvLrDfzqjZIrf9PRIlG7v0MKheuStINyXTiF8K159NBvguJQN0pzT84a6fBn9jh/1
         BV1k1n+PQyJPW0PolF5pBc2z1+/UlVG2CCTfK6PpJopKJYT/PrlEMTjh0H+pGF5o/ukh
         7DmPM3H/SU8MyKliSlvziPu5ou5enwvf1oiTq5Qu2gsxS0f/iQ6QQ0sIboOsug5Whw8l
         EJMhZiEwcp7adELEmBv2ji/Lj27oT0PKW70q6BH7l2z0HS2PYIGdpGuS7WsDtR6wQuQU
         R6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790588106; x=1791192906;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J7NixjEGofgkN3CS5IP+1OrrpCKUq/nSVKpFmSD6AB0=;
        b=XEeec/9pAU9cRvZkfM4n1ssUKKueE1+Z6KqF9MBD/hn4uTi0Rg2DyjDuViwv3n76Kb
         4icE7PIhjMZCemowr0i5FFyu0UCO1Gw3Gsv1pDWUfEaSCsoHfixobupQaFah1fEEVDYA
         2pmy35GDKZzpoSoxKV7HwIn2p7Qbm8alduvV3x3tE0uww0B5MNvnzT3nlGXt2m994rsW
         hbE+vXOdXsYrRT135yzRu6wVkxHmvj/MTNwBcEO7XLN+HnoIujntLGM3MeWfjCw4iP2v
         eLDnRj6opqn3W8UTgagKwlyeXUQINdNMmpeOaepz2iL1ahN5fhS2gNUyjWDi6c1wCceJ
         cdNQ==
X-Gm-Message-State: AFuF++kfFCirMNFstfYnovmCoRfLcCq8tFeDBd/KDU01XGWlIYRWs8TX
	+Y1KsVH5P29EuKbDgrFCt34/P5oBRv9eEN39QIrq/vknCp0sZQlIxO/lbC5MsBSSXW98SRhO550
	r1wXEpU3AJn5zwH6IGdWJu7oWP7c74bc=
X-Gm-Gg: AYBFou105c/quLBG6eGI79bqVUhdUl4FBmLfF4U0N8R3GqBGWCKCzTc76oRWd8hS5MJ
	EmEdTcxcRW45ySWVD7k8mPggO/YUEVRfSLLdFYobaPydBT/d7AeGw6syyCHFnIFy90FgnXJT2Oh
	FUPKHrZ+6wG6/YPtPjLSEu8MajTSSNhmgpHgE2p7DLKdUXy2kdpMbbDBeZE2R1lH7C2T4TLhYE3
	08Vtgfa+iUtLZpVefUQcanhhgvDCjdwwSrT5lbvxqLVT5bwzgBZ2pKTwACh+x2ZdNJx6/5RUerD
	SieF718XmNRkvSFCwdN0iFq1MNJXd/ZHxNcdnVDpC9Bw+1ScQ74c1ivsOibNCkqPQihhQIzGQTz
	btPVURfiJPGQ=
X-Received: by 2002:a17:907:9445:b0:c26:19de:9adb with SMTP id
 a640c23a62f3a-c2ac259cee2mr1036666866b.26.1790588105420; Mon, 28 Sep 2026
 02:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com> <20260928091144.818739-1-liuxiang.277@bytedance.com>
In-Reply-To: <20260928091144.818739-1-liuxiang.277@bytedance.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 28 Sep 2026 17:34:27 +0800
X-Gm-Features: AclHuK-2Am0IrJwrtO2WIF-9sUUaEeJonX73QRQrUzGpc-JcUfmwQN43Q37uOAk
Message-ID: <CAMgjq7Agqr1FLcG3HqT_M_1s8cHc21qQKTM-JS67-3gfQ6azPQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/15] mm/mglru: frequency guided promotion
 (MGLRU-FG) and flag cleanup
To: Xiang Liu <liuxiang.277@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yu Zhao <yuzhao@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0CCA920004
X-Stat-Signature: ex931yxdj4fp8ty1unek7nmq18hqia71
X-Rspam-User: 
X-HE-Tag: 1790588106-317735
X-HE-Meta: U2FsdGVkX1/aVqPF5joTPDy3XSZsfQNLs2HcCOEdFdokuL7r5hlAt4Fr3pNlNCii+TghdYwqaloSl+icesO9v/XKo8w/B4TqJk3bkcoD8lLhRsqK4FBGKQAAW1fIgcHgx5a6x/9GjpkcYd8swtKQR0GjtaAdA5PcEOqmHq9nnDUYm/AJ8m/WcITq0peWsLcmLgNaUu9+Efbkml6IDKenQA+mkUej4dJ0IqxJuVzQgAW7MhsuEhTZ1fO7G/cdqYKx0tyShOytB4KBNA15l/CYLI0MdJqzevGXgHudRc3ncp438iwuvkEsXp4XBT8GCDpQiIH20Hv3BFkn2utZPIukjJLOJn1ckv5vvXyCgGKSFO4zfnMVcdDz91EPX40MgId9IVIx58fC1z/zua6syTUUdBRHUwKdufLQAforhN2IXCGYI+QHgB7NIgEYd+V8RRi9BFvMOSrn09dkeLS7AXEgBLCN8PYLZ06AxcT3WAP+sMoKn647TcypUjOJeICfe+abwRHF5EihkjHB9D/6/ZqZ+NEdDZIDu+sIWQsWbCl4IKghMXMt8mrcQ3xi5+Cia+Zczhg6BloXMD8ogTUhoHKBtx02CztXdK1ttSPPXY6IftgjzcrbFoG0yGoE2Jk9GupQISLP/OB/ySdcejYXEx9IyYKjAg3CEtVn/tEME4pkTkRWlNzB+TFANx9sP4VPOqjUxwEJ5HdMtGUFdaGPDRJ+3LulSQC2LlwfQ5aEOCVH3Zr2rI6B3JdnGempGqOBpt8Xht+yurRUpVOHZUCirZEEm1m9/O25XRjLhKgZABMeriv1a/BFIeFbuypBgvy8bsVvb2Rlu6rDOGav5UAby550wP74XY6nqv2tTNso96EifLvNoxLAvYJsyO2nviB5FWW7ofs5C/4nNWJtHDTq3B64JM73NeCLt1bABRkjK0Cmmr4mbg/TtQuh80w+fFyZI2wp6hS3DsbeS3YlWt+PJoc
 gQyOQ9gJ
 WksC/c2MtIhuQhGUlSG+Xspgvwv2BkRxSFnSR0KNjwEZApSjw/BZx8+GjQ17wnxEejFP2f2gLvv7YQh7Yh2J63ytzPBLyhPEmjPjQaWa86LBaYno3FXbjLcIn3A2Mn62Q78Elr1vTXVYkRgHM55mwZadppczVVyQTcNfe53GLJ9qaJcVd3REumNlVsIo6FOWlAwbzZy5tl0c47Eo55GbtUttWS5iMF9v94GYJ2SY20gOfkO9pBu/tlrhg5ia6NsxVSkbSqi51jPgYcPoigg7aluz7QDJ5si+PHossVPC7HfJjYf19QvopJMdcmiLn5wi1il1tRz8oFr7s6JM8hlrrCTxwVxrcm1sIucbPb/4R2BeAeY7uZFQtNhc6MJFyZfI8xKPc0j3acGc+mAeaMVvPTUvZqtJHS1dUxVeivV/Zx9zLW6rcWRugJGJ44P7BzMX9+qFcOLQqNie/Lf0wfpfpkGR3aKkbsjnfABXWndSGN3KVp5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 5:12=E2=80=AFPM Xiang Liu <liuxiang.277@bytedance.c=
om> wrote:
>
> Hi Kairui,
>
> I tested the complete MGLRU-FG RFC v2 series on an x86_64 machine with
> a SATA SSD. I found that the LevelDB Scan/Get result changes with the
> relative intensity of GET and SCAN.
>
> Setup: base commit 9958290885035431e2494159f555e332c3c14906, about
> 28 GiB LevelDB, 2.5 GiB memcg, swap off, Zipf 0.99, SCAN length 10000,
> 240 seconds warm-up plus 240 seconds measurement. Each untraced ABBA
> sample used a fresh database copy, page-cache drop, reboot and cooldown.
>
> Untraced ABBA results
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Workload                  GET/SCAN   Baseline       FG     Delta
> 1 SCAN + 3 GET                92.5    4688.62  4425.82    -5.61%
> 4 mixed workers, 99.5/0.5    195.2    6200.60  6385.57    +2.98%
> 1 SCAN + 7 GET               237.2    9574.97  9831.70    +2.68%
>
> The first workload is the original four-thread layout: one continuous
> SCAN thread and three GET threads. The second is a custom workload in
> which every worker chooses 99.5% GET or 0.5% SCAN per request. The third
> keeps one continuous SCAN thread and increases GET threads to seven.
>
> In the original workload, FG changed GET throughput by -5.74% and SCAN
> throughput by +6.91%. The two ABBA position pairs were -6.21% and
> -5.00%. A separate 5 GiB memcg repeat was also negative: -9.07% and
> -7.67%.
>
> Traced results
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> I ran one fresh-boot baseline/FG pair for each workload. To limit probe
> overhead, I selected about 1/1024 of file offsets using a stable hash of
> inode and page index.
>
> Initial placement of newly loaded GET folios
> --------------------------------------------
>
> We tracked new file pages loaded by GET requests and recorded where
> MGLRU initially placed each page: the oldest generation or the
> second-oldest generation.
>
> Workload / kernel       Sampled   Oldest        Second-oldest
> 1S+3G / baseline           1452    186 (12.8%)   1266 (87.2%)
> 1S+3G / FG                 1371   1052 (76.7%)    319 (23.3%)
> Mixed / baseline           1782    199 (11.2%)   1583 (88.8%)
> Mixed / FG                 1662   1312 (78.9%)    350 (21.1%)
> 1S+7G / baseline           2719    469 (17.2%)   2250 (82.8%)
> 1S+7G / FG                 2677   2107 (78.7%)    570 (21.3%)
>
> For example, the original 1-SCAN/3-GET baseline run sampled 1452 newly
> loaded GET folios. Of these, 1266 entered the second-oldest generation
> and 186 entered the oldest. With FG, 1052 of 1371 sampled folios entered
> the oldest generation.
>
> The same change appears in all three workloads: mainline places most
> new GET folios in the second-oldest generation, whereas FG places most
> of them in the oldest generation.
>
> FG promotion was active in all three workloads:
>
> Workload              Later GET       Moved to the promoted generation
>                       changed gen     during reclaim scan
> 1 SCAN + 3 GET              38              548
> 4 mixed workers             32              558
> 1 SCAN + 7 GET              70              936
>
> However, FG also removed more sampled GET folios before another GET
> reused the same in-memory folio:
>
>                          Removed after one GET      Later reloaded
> 1 SCAN + 3 GET            81.5% -> 88.4%           44.7% -> 48.6%
> 4 mixed workers           73.4% -> 90.2%           48.3% -> 52.7%
> 1 SCAN + 7 GET            84.5% -> 88.2%           56.2% -> 61.1%
>
> The arrows show baseline -> FG. "Later reloaded" means a later GET
> demanded the same file offset after it had been removed from page cache.
>
> The request-level counters explain why the final results differ:
>
> FG change per request       GET cache miss   GET I/O wait   SCAN cache mi=
ss
> 1 SCAN + 3 GET                    +2.29%          +6.87%           -15.97=
%
> 4 mixed workers                   -5.68%          -4.19%            -6.93=
%
> 1 SCAN + 7 GET                    -2.89%          -0.32%            -8.26=
%
>
> FG improved the SCAN side in every workload. In the original workload,
> the GET miss and I/O increases were larger than the SCAN gain, producing
> the 5.61% total regression. When GET was denser relative to SCAN, GET
> misses also decreased and FG became a net win.
>
> My interpretation is that FG introduces a cold-start window for a new
> GET folio:
>
>   first GET -> oldest generation
>             -> a later GET promotes it, if it is still present
>             -> otherwise reclaim removes it first
>
> The outcome depends on whether GET reuse arrives before the continuous
> SCAN stream consumes the oldest generation. The trace shows that both
> promotion and early removal occur in practice.
>
> This machine uses SATA, while the positive results in the cover letter
> used NVMe. Storage latency may also change the timing among page-cache
> insertion, LRU drain, the next GET and reclaim.
>
> Is this cold-start window an expected trade-off of the current design?
> Would limited initial protection for refs=3D1 folios, or a decision based
> on observed refault/reuse distance, be worth testing?

Hi Xiang, thanks for testing:

Well I mentioned this in the cover letter:

=3D=3D=3D

Interestingly, mainline MGLRU already beats CLRU on this one after a
recent change in lru_gen_folio_seq that bumps new folios with refs =3D=3D 1
to the second-oldest generation. That change accidentally gave random
reads a higher hotness level while making sequential reads much colder:
sequential reads involve many readahead hits, and readahead folios start
with refs =3D=3D 0, so they're already in the oldest generation, and
folio_mark_accessed() on a readahead hit has almost no effect on generation=
s
in mainline MGLRU. Meanwhile, all direct-hit (random read) folios start
with refs =3D=3D 1 in the second-oldest generation. As a result, the scan-g=
et
test natively protects the "get" part and sacrifices the "scan" part.
That's not the best solution though. It's unreliable because it depends
on LRU drain timing, and it hurts workloads where the sequential part is
actually hotter (any workload involving a hotter large file and many
small cold files will be affected).

=3D=3D=3D

That actually mentions commit 6cbdd9726fb50. Before that commit, as I
mentioned in an earlier RFC, the LevelDB test is doing a lot worse in
mainline, which also matches what Tal tested in that cache_ext paper:
https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-0-913619b014d9@tencen=
t.com/

It was like this:
GET/SCAN LevelDB [2]:
Classical LRU: throughput_avg: 993.64 Ops/s
MGLRU before:  throughput_avg: 951.12 Ops/s
MGLRU after:   throughput_avg: 1344.72 Ops/s (+41% faster)

After that commit, MGLRU beats CLRU for this test, but that's a side
effect. (And also I made the test run much longer to let both CLRU /
MGLRU to learn the hotness info more so in V2 RFC the ops/s is higher,
also reduced the RA window as RA window dramatically effects the
result).

6cbdd9726fb50 strongly favors the GET part, because of scan readahead:
non-readahead random folios (GET) will not use too many RA so they
mostly start with refs =3D=3D 1 before landing in LRU (stay in percpu
folio batch, so also due to a time window and unstable) so they are
put in 2nd oldest gen. Sequential reads, however, use RA heavily and
start with refs =3D=3D 0, landing in the oldest part. This creates a
strong bias toward reclaiming the scan part, which coincidentally
suits that benchmark. But it is just not right, assuming sequential
read is colder than non-sequential reads makes no sense. And it does
caused regressions for many other tests, e.g. some data base like
SQLite, and for example a recent report for other people:
https://lore.kernel.org/all/20260901180704.168106-1-ehab.ababneh@intel.com/

With FG, however, it will actually learn the hotness. If you check
Tal's paper and code there is also warmup phase for any algorithm to
take effect, so I'm already glad that with NVMe, where the warmup
window is shorter, FG is already doing great, and even if the window
is long, there isn't significant regression, and more like a balance
issue. I believe this way will lead to better long-term performance.

