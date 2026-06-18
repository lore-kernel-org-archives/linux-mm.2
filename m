Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BE1ACD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007246B008C; Thu, 18 Jun 2026 09:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F202B6B0092; Thu, 18 Jun 2026 09:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DBF6B009B; Thu, 18 Jun 2026 09:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC2BD6B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:13:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4086AC282D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:13:30 +0000 (UTC)
X-FDA: 84893074980.27.EA89B28
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id F0D59180003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:13:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lVng+zrv;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781788408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8cvdO2YcTEhKFshWpWpsBiKwfTB4eMtDGGkrOnGgUc=;
	b=vdAg/87On+E9/zeJSFJ+RcQkbq6bAyQSNhMK5nSiDbPUlRQcJ5M0CqQXkldANKFUGKfD3H
	tVKm/Vaxevs/XhY0C4BYUhk5ldfEcahWpQ05FjLelniXF+QY8sLl4z3LbfVdMxZ30D846F
	osOReg4zP0yMYtx6mMCGO5sBXTYRHtc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781788408;
	b=HQCphOfq9aiK5O1hzocryg66Wz9wq/QBtr7pCNC/pFCYYksyM9Nn+RZMpTxC6FKzlbnwli
	d1FSbLhwIKn1hRKaLaqmtCBq0UzGH0/hON0NvC7lI0n4UBEcm67YuucmmNyAcId552bBoR
	FJATiu4IYVHbXJxMe7jxmGVE+rM8aQY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lVng+zrv;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-13988680a69so2306303c88.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781788407; x=1782393207; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=K8cvdO2YcTEhKFshWpWpsBiKwfTB4eMtDGGkrOnGgUc=;
        b=lVng+zrvBWQNxOyia0dEsIdtW+Q9wOKt25ik5f6vub7JQLgahw8wOlyElfX3hKslpC
         oM4rmSZcNfn5HByVVrhtzpE8LDklULWfwlOcRSxrVbcNs5kJeG4EPEA2XiYdbWTIveb9
         MB71RW0niOHmp2lZX+FCW2dZu1urb+keY+VE/5IoLnmK+JC/PxTNZ8Qdz9Oea16SQuHj
         v1icyl+7emjjHI8GA53TY5bQwIwa0Zo6szohcNXGpXiwKGjaz1ECvHYqoZXtmIUagwpI
         SrSqc+kIbPdpeHsjUsm9NtrcTmoNUxNWYoe4pYKBZOPZPjIqQfpegz7t08C9oSSijOM+
         H0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781788407; x=1782393207;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K8cvdO2YcTEhKFshWpWpsBiKwfTB4eMtDGGkrOnGgUc=;
        b=kC829SkrtN0ATDU+nbdmcwocz4sN7QmT5mXTGOfkJZX274in6Og10snpXlBxf+kWIR
         w1GunyYOOA+qxWr7/fe4jkZ4rS/FcOeUcyVxqGWBiQHMjlSj2jtsUUtdN5vzAXhD9no0
         NddHDHD0UEn2YC2Vfr2NeTI4YvGZfuZC2QXu6U5LXepTV1quRlNvEY/iLdLF5MT1NI37
         VIMqzDdf72Nf6rV/7S6OwJIwD08y5h7DJoTxcS9JwxLOxe6tOge7/rlG0B7qtjP5d9JE
         +k0mGDNejfPPI5IPPqFd2aQFn/h98L9JC2SsJZgM57Xfcf6YZ2XELgSuPOtNrbi+a/bQ
         xdYg==
X-Forwarded-Encrypted: i=1; AFNElJ9YHI/zRAz60sdnVLo9q7IngM2OM/2xO2pfShAeZox6F9SrEoNoWl121X2Cs4hAGh2vO+kaga8/Zw==@kvack.org
X-Gm-Message-State: AOJu0Yw6SwVHY2bTZ6NPjjVvPtg9sK+aiKMC7Oszw0Ch6wX3B0saAvqB
	0YyZn7BsHsEyGIr65p1zmj4Fq00971s909qR/NFByMW7iMEA42GkejBQ
X-Gm-Gg: AfdE7clJvFk/BO3eRyQuWbX93kZG0zb633rCQAb7AGsxZxd56o699yKnqQ+wWc773Ev
	n4A624Iux+8hEbmzl1eDtRNNAwTzddX3sSQTstspI69jCEZetJq4y9Wdb6DQULuaimUABt6N0kq
	1EUyn7bSWyosQ8vKUWcuA6N8azvHGH+8AKMTz3G2ACh3I4tyNR7KA6x1UUHf5hJJuE4tNqyWqvw
	w2JP3rYZpmi6xAul5KDdeLTWqA4CUafm6aYrWmaZ1aAEyrKrrI3zd86NVDSw+loeVjfwaqXFILH
	AOC0WYR7yexmHcB67ggnsiNoKe92iJtWcpirfqy82f/2WEpDdpiiUVWy82lY3ztoFalEiDvZm80
	4viB0meEZ1e9OhR8y3hgDBGbAnCwHzEncAMgOQ7o/YZ7HKNHprevV5h9Gm4MKtILVZC/nOf4brt
	rdlDMbkFcCOUsU97XPlw==
X-Received: by 2002:a05:7300:cc0e:b0:30b:bae1:aec7 with SMTP id 5a478bee46e88-30bf09e12bfmr2409656eec.30.1781788406310;
        Thu, 18 Jun 2026 06:13:26 -0700 (PDT)
Received: from smtpclient.apple ([104.28.158.224])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30bcbb684absm5793153eec.1.2026.06.18.06.13.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2026 06:13:25 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
Message-Id: <459C0876-AC37-4A52-BF11-6436FF33CA90@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_B80FC59B-64C7-4D35-A821-A517B7EC0C55"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [RFC PATCH 0/6] mm/damon: Add mTHP-aware collapse/split with ARM
 SPE feedback
Date: Thu, 18 Jun 2026 21:13:07 +0800
In-Reply-To: <552e1d3a-3c60-4110-8601-00cd9bc7998a@huawei-partners.com>
Cc: sj@kernel.org,
 akpm@linux-foundation.org,
 npache@redhat.com,
 daichaobing@sangfor.com.cn,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 kunwu.chan@gmail.com
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
References: <20260618094838.32805-1-lianux.mm@gmail.com>
 <552e1d3a-3c60-4110-8601-00cd9bc7998a@huawei-partners.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-Rspamd-Queue-Id: F0D59180003
X-Rspam-User: 
X-Stat-Signature: qjo7in71fnti1hzyexfh7yjq8cwco543
X-Rspamd-Server: rspam08
X-HE-Tag: 1781788407-302002
X-HE-Meta: U2FsdGVkX1975OChcsK6VfHyED7U1JDEDZYCUpaiS54T1p2GSPTgIbJzxbJ2SzVo/UyXiGfX5Z4eCq+yxOHQtS0MTOsOoXw1ufJ4806u5hR5zP5AL81kYO9KbaT24CMZHqcjCoisFviWbrCAsBbIaJmnCsOFF9eKM6PDTgeYOD01TRcFUM0/42bu8TnZQkKP6eq7Y9UxEl4axCKp3PeuGxKMr94JVTURvVpO64pR0HY8C3S74u4nw1EMk5u+dWZSjNf6bdqrx0Dw7WC7qx/P8jk/mh9AgD+TME4xM8PNOEHQu7LakgFKSSJnffnmh/hCnkQQnV+nJVgn6vJbyaCL7eUz+Jm4eKLnsalhyxHTtFWgkyHGWWIUV+XOiGXAOMimZOx6gfVzJOOApnqglERQ49KlsA2voEktsR9YEUTpJyR1ncdHRQiRBVbxIgAikx+XBF470wqDyGDXlMVs36Bzr5tEyJ3HdIv3rrgJTnuk7F4SnJ7PFlALB8ZdjfopUulw51bFq1d/oFO5gBVZGToVf6zZfusPnX0uyZH+oobnSSzG2lP3aHxQtQb+wB+SgNWDvWDzydiHO9d3o8ubJOJBd3zrwETAatopUxs7Vntff4c0yFvtxGVN63cwGmH571RGXsvgUg/d2CwI6mclghA3oTGxu5bZWbZiWL+8Srj9jevK5EC1c6X1/nNORA3apLh4bAMtyBi3jp83NSSCJd8d46HxsNfKmezTb73ooIFoBVppwAwufTW8PSteLD6FRgkTt0FreYSQtkYQmstEZWC8FQ6pT4cjlj7iFWBS/bkEZRzH4nDjU/7lGbrtEceOIHbzsgRTEv+Gz5NBOeimtaDAP/zYJ9QYs/gp1Ly9Tvoo7CNiXWeAoGYDFEELXMZ5ypPKLPEiXdeEmKIc2+5X1Qvn7LdzYsiNw0/dQLtm/BVzYLnuE0Zc9lr0dfvPWZzk3teCHUsTYObGjsgl0Zct21q
 w4vcW/dc
 m5qrDlnMFiHyKTk+RgalowpsY12n6QKO+UAkfiw6lANQsicoAwcdUmdYC9bT9t37myHGmPDh5yAzhHui0VVRY1nb4ZoOU/dKHljsQzFE3l9+DHCVTaIk2lKyC8VeHDZl9k06hXfBUfXijEzXhxVUdSGP4Iw0tBUROeTMQA+BlYuH5MUlnzd9rTcWatgDIEJBwmg+H+l2EB2o4761YgOUCRP+uH8JYkSKvn9EYGl5pvnGWV1imvPMH7RRBumg5gfloostv6cHxtaspDuEst5F3qyOOnW4EXLk0pFB+NQvdv9QA2pRvmQPf7PXk0rX+uNQKMSYzQOaF3DQt9aCdQbcp9ohSruJ7Ng3dl80MgN5/05WfVDh3Yut2IocBbXEU/HMTXRxBVNIVovKEXD9Juhsv0k3OEG0LpUbIZUKW5YAb8hTW0sFGAZ5mieaXA/vHa3vxlxdm1+n2ar/bOlBeHZlE2U2ZLkHRebSTzwXsWQ927WkSW1oqWj+rBG8XSIJkwkwOjBEsxqc7lcEbw7rCVeaKIwq3aUtBGqSN235sne3yBSp2tnEwSsBFbPXgxstMBml3tmEuIR8CnhBH7WWXxr/0l11+Dhy+MI5GxfvApItquUlLIe9BcNNULP7jmauFhmP695ML7/fjUW47Qmk0ZnqBlpCu+6TimXUSOMs96CzSXici75MsRbz/W8m/wP+leawZZV4GsI+O6Pdah1DswE9cphZHk8bDz75/n/9TAnsrOgNc8RtoPq98I8x2Cy9SIwFeFNfUSiM9jE1JMbtLaC3s1tmktZZVORGRcTvS9IEPWmP+72bX1V5YwTcwD3XtEC+RPhJm1XTPpThLxCFhCE2W7MLe45DAo8X9RoPcXEV3UADNNuEfWx13eGvD0OqQL7m10b/hlvcJdxLdoktHKwQKgTELab8OVdzjjzgyaTft1U19BPaphxEMfa/c0W7rpWCgRU0tda7m4RLILXfjBmuY+3kVz2Ge
 Uhd+1Ujs
 MW4FqliGxSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_B80FC59B-64C7-4D35-A821-A517B7EC0C55
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Jun 18, 2026, at 19:03, Gutierrez Asier =
<gutierrez.asier@huawei-partners.com> wrote:
>=20
> Hi Wang,
>=20
> On 6/18/2026 12:48 PM, Wang Lian wrote:
>> Received an off-list report that DAMON significantly overestimates
>> hot memory in KVM/QEMU deployments with THP-backed tmpfs guest memory
>> running Oracle workloads.
>>=20
>> The root cause is structural: a PMD entry covers 512 4KB subpages =
with
>> a single Access Flag (AF) bit. When any one subpage is accessed, the =
entire
>> 2MB region appears "hot" to DAMON. On ARM64, this is compounded by =
the
>> hardware AF mechanism -- the AF is only set on a TLB miss. =
Consequently, when the
>> working set fits entirely within the L2 TLB (e.g., a 16MB working set =
with 2MB THP
>> running on a Kunpeng 920's 2048-entry L2 TLB), DAMON becomes =
completely blind to
>> subsequent accesses. x86 is not subject to this specific blindness =
under similar
>> conditions.
>=20
> Have you tried setting the minimum region size to 2MB?
>=20
>> We reproduced this memory inflation on a Kunpeng 920 platform using a =
synthetic
>> workload (8GB mmap with a 0.2% sparse hotspot, i.e. 16MB actually =
hot):
>> THP=3Dalways causes DAMON to report the entire 8GB as hot, while =
THP=3Dnever
>> reports only a few hundred MB -- a 512x overestimate relative to the =
actual
>> 16MB hotspot under THP, and a ~33x gap between the two THP modes. ARM =
SPE hardware profiling
>> independently confirms this asymmetry: out of 2,005 THPs sampled =
system-wide
>> over 10 seconds, 97% had fewer than 10% of their 4KB subpages =
actually accessed.
>=20
> THP always will just collapse the entire PID into huge pages anyway. =
This
> is outside DAMON's control.
>=20
> Have you tried setting THP to never and running DAMON with =
DAMON_COLLAPSE
> action?
>=20
>> To mitigate this, this series extends the existing DAMOS_COLLAPSE =
action to be
>> mTHP-aware via a new target_order field, and introduces a new
>> DAMOS_MTHP_SPLIT action. This enables DAMON to proactively split PMD =
THPs
>> into smaller mTHPs when most subpages are probed as cold, and =
collapse them
>> back when beneficial. To resolve the sub-PMD monitoring blindness, =
the split
>> path can incorporate fine-grained hardware feedback from ARM SPE.
>> The hardware feedback loop (damon_spe_folio_heatmap) implements a =
two-pass
>> signal filter: it first identifies the peak chunk access count, and =
then marks
>> sub-chunks with >=3D 1/10 of the peak count as hot, effectively =
filtering out
>> SPE sampling noise. A configurable hot_threshold (default 30%) =
controls the
>> split decision: only folios with a hot fraction below this threshold =
are
>> eligible for splitting. When no SPE data is available, the =
infrastructure
>> gracefully falls back to explicit PTE-level scanning via folio_walk.
>>=20
>> Currently, SPE data is fed from userspace via debugfs (e.g., perf =
script piped
>> through a histogram builder into /sys/kernel/debug/damon/spe_feed).
>>=20
>> Collapse path (patches 1-3):
>>  DAMON scheme action=3DCOLLAPSE, target_order=3DN
>>  -> damos_va_collapse() -> damon_collapse_folio_range()
>>  -> collapse_huge_page()
>>=20
>> Split path (patches 4-5):
>>  DAMON scheme action=3DMTHP_SPLIT, target_order=3DN, hot_threshold=3DM
>>  -> damos_va_mthp_split() -> damon_spe_hot_fraction()
>>  -> split_folio_to_order()
>>=20
>> SPE feedback infrastructure (patch 6):
>>  perf script -> spe_hist -> debugfs spe_feed
>>  -> per-folio rbtree {THP-aligned PFN -> access_count[512]}
>>  -> damon_spe_folio_heatmap() -> hot_bitmap -> split decision
>>=20
>> The userspace helper tools (including the spe_hist histogram builder =
and
>> validation scripts) are archived at:
>>  https://github.com/lianux-mm/damon_spe
>>=20
>> Testing was performed on a Kunpeng 920 system (256 cores, 249GB RAM, =
base kernel
>> 7.1.0-rc5+):
>>=20
>>  T1 ARM64 blind spot: A 16MB THP workload (where 8 PMDs fit entirely =
within the
>>     L2 TLB) resulted in DAMON detecting 0 regions. Conversely, using =
512MB
>>     with 4KB base pages, or a 16GB THP layout (exceeding L2 TLB =
reach), allowed
>>     DAMON to function normally.
>>=20
>>  T2 THP inflation: With an 8GB mmap and 16MB actually hot (0.2%),
>>     THP=3Dalways: DAMON reported 8GB hot (512x vs ground truth);
>>     THP=3Dnever: ~245MB (15x vs ground truth).  The THP-induced gap
>>     between the two modes was ~33x.
>>=20
>>  T3 RocksDB: Fragmented malloc allocation prevented THP formation, =
and DAMON
>>     behaved normally. We could not reproduce THP inflation with =
RocksDB.
>>     The workloads fundamentally vulnerable to this structural issue =
remain KVM
>>     guests, JVM large heaps, and PostgreSQL shared_buffers.
>>=20
>>  T4 min=3D0 deadlock break: A 256MB THP induced the DAMON blind spot.
>>     Triggering an unconditional mthp_split (via nr_accesses/min=3D0) =
successfully
>>     shattered the space into 16384x16KB folios, allowing DAMON to =
fully recover.
>>=20
>>  T5 ARM SPE histogram: Out of 2005 sampled THPs, 97% exhibited <10% =
hot subpages.
>>     A typical trace showed PFN 0x820db800 accumulated 39,794 hardware =
accesses
>>     concentrated across only 3 out of 512 subpages.
> The SPE stuff fits SeongJae's goals for DAMON-X, I think. Maybe this =
is something
> we should keep in the user space and let the kernel provide only the =
API to add
> different metrics, including PMU and SPE.

Hi Asier,

Thanks for your prompt and constructive reply. I really appreciate your=20=

detailed analysis of the mTHP and SPE interaction.

Your point regarding the design boundary=E2=80=94whether this fits =
better in=20
user space or aligned with DAMON-X=E2=80=94is highly valuable.=20

Since SeongJae (SJ) will look into this thread tomorrow, let us sync up=20=

then. I look forward to cooperating with both of you to refine this=20
design and find the best architectural fit for the subsystem.

Thanks,
Wang Lian
>>  End-to-end: Verified hot/cold discrimination. The SPE feed preserved =
a 90%
>>     hot THP intact, while successfully splitting a 25% cold THP into =
128x16KB folios.
>>=20
>> Known limitations:
>> - The full KVM + Oracle production chain has not yet been benchmarked =
end-to-end.
>>  While individual component verification is complete, full =
integration testing
>>  is planned in collaboration with Sangfor.
>> - khugepaged may aggressively re-collapse the mTHPs that DAMON =
splits. A
>>  coordination/back-off mechanism is required to avoid ping-pong =
effects.
>> - SPE data is currently funneled via a userspace daemon and debugfs. =
Direct
>>  kernel-side perf_event sampling integration is planned as a =
follow-up.
>> - The rbtree entry TTL (30s) and signal threshold (1/10 of peak) are =
empirical
>>  defaults subject to further tuning.
>> - The ARM64 DAMON blind spot (WSS < L2 TLB reach) is a pre-existing =
hardware-MMU
>>  characteristic, not introduced by this series. Setting =
nr_accesses/min=3D0
>>  serves as an effective workaround for the split path.
>>=20
>> Reported-by: Chaobing Dai <daichaobing@sangfor.com.cn>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Wang Lian <lianux.mm@gmail.com>
>>=20
>> Wang Lian (6):
>>  mm/damon: add target_order field for DAMOS_COLLAPSE
>>  mm/khugepaged: add damon_collapse_folio_range() for external callers
>>  mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
>>  mm/damon: introduce DAMOS_MTHP_SPLIT action and hot_threshold
>>  mm/damon/vaddr: implement DAMOS_MTHP_SPLIT handler
>>  mm/damon: add SPE feedback for sub-THP split decisions
>>=20
>> include/linux/damon.h      |  18 ++
>> include/linux/khugepaged.h |   3 +
>> mm/damon/Kconfig           |  12 +
>> mm/damon/Makefile          |   1 +
>> mm/damon/core.c            |   3 +
>> mm/damon/spe.c             | 505 =
+++++++++++++++++++++++++++++++++++++
>> mm/damon/spe.h             |  62 +++++
>> mm/damon/sysfs-schemes.c   |  96 +++++++
>> mm/damon/vaddr.c           | 118 +++++++++
>> mm/khugepaged.c            |  39 +++
>> 10 files changed, 857 insertions(+)
>> create mode 100644 mm/damon/spe.c
>> create mode 100644 mm/damon/spe.h
>>=20
>> --
>> 2.50.1 (Apple Git-155)
>>=20
>=20
> --=20
> Asier Gutierrez
> Huawei


--Apple-Mail=_B80FC59B-64C7-4D35-A821-A517B7EC0C55
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Jun 18, 2026, at 19:03, Gutierrez Asier =
&lt;gutierrez.asier@huawei-partners.com&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Hi Wang,</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">On 6/18/2026 12:48 PM, Wang Lian =
wrote:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;">Received =
an off-list report that DAMON significantly overestimates<br>hot memory =
in KVM/QEMU deployments with THP-backed tmpfs guest memory<br>running =
Oracle workloads.<br><br>The root cause is structural: a PMD entry =
covers 512 4KB subpages with<br>a single Access Flag (AF) bit. When any =
one subpage is accessed, the entire<br>2MB region appears "hot" to =
DAMON. On ARM64, this is compounded by the<br>hardware AF mechanism -- =
the AF is only set on a TLB miss. Consequently, when the<br>working set =
fits entirely within the L2 TLB (e.g., a 16MB working set with 2MB =
THP<br>running on a Kunpeng 920's 2048-entry L2 TLB), DAMON becomes =
completely blind to<br>subsequent accesses. x86 is not subject to this =
specific blindness under similar<br>conditions.<br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Have you tried setting the minimum region =
size to 2MB?</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: solid;">We =
reproduced this memory inflation on a Kunpeng 920 platform using a =
synthetic<br>workload (8GB mmap with a 0.2% sparse hotspot, i.e. 16MB =
actually hot):<br>THP=3Dalways causes DAMON to report the entire 8GB as =
hot, while THP=3Dnever<br>reports only a few hundred MB -- a 512x =
overestimate relative to the actual<br>16MB hotspot under THP, and a =
~33x gap between the two THP modes. ARM SPE hardware =
profiling<br>independently confirms this asymmetry: out of 2,005 THPs =
sampled system-wide<br>over 10 seconds, 97% had fewer than 10% of their =
4KB subpages actually accessed.<br></blockquote><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">THP always will just collapse the entire =
PID into huge pages anyway. This</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">is outside DAMON's control.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Have you tried setting THP to never and =
running DAMON with DAMON_COLLAPSE</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">action?</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; widows: 2; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration-line: =
none; text-decoration-thickness: auto; text-decoration-style: solid;">To =
mitigate this, this series extends the existing DAMOS_COLLAPSE action to =
be<br>mTHP-aware via a new target_order field, and introduces a =
new<br>DAMOS_MTHP_SPLIT action. This enables DAMON to proactively split =
PMD THPs<br>into smaller mTHPs when most subpages are probed as cold, =
and collapse them<br>back when beneficial. To resolve the sub-PMD =
monitoring blindness, the split<br>path can incorporate fine-grained =
hardware feedback from ARM SPE.<br>The hardware feedback loop =
(damon_spe_folio_heatmap) implements a two-pass<br>signal filter: it =
first identifies the peak chunk access count, and then =
marks<br>sub-chunks with &gt;=3D 1/10 of the peak count as hot, =
effectively filtering out<br>SPE sampling noise. A configurable =
hot_threshold (default 30%) controls the<br>split decision: only folios =
with a hot fraction below this threshold are<br>eligible for splitting. =
When no SPE data is available, the infrastructure<br>gracefully falls =
back to explicit PTE-level scanning via folio_walk.<br><br>Currently, =
SPE data is fed from userspace via debugfs (e.g., perf script =
piped<br>through a histogram builder into =
/sys/kernel/debug/damon/spe_feed).<br><br>Collapse path (patches =
1-3):<br>&nbsp;DAMON scheme action=3DCOLLAPSE, =
target_order=3DN<br>&nbsp;-&gt; damos_va_collapse() -&gt; =
damon_collapse_folio_range()<br>&nbsp;-&gt; =
collapse_huge_page()<br><br>Split path (patches 4-5):<br>&nbsp;DAMON =
scheme action=3DMTHP_SPLIT, target_order=3DN, =
hot_threshold=3DM<br>&nbsp;-&gt; damos_va_mthp_split() -&gt; =
damon_spe_hot_fraction()<br>&nbsp;-&gt; =
split_folio_to_order()<br><br>SPE feedback infrastructure (patch =
6):<br>&nbsp;perf script -&gt; spe_hist -&gt; debugfs =
spe_feed<br>&nbsp;-&gt; per-folio rbtree {THP-aligned PFN -&gt; =
access_count[512]}<br>&nbsp;-&gt; damon_spe_folio_heatmap() -&gt; =
hot_bitmap -&gt; split decision<br><br>The userspace helper tools =
(including the spe_hist histogram builder and<br>validation scripts) are =
archived =
at:<br>&nbsp;https://github.com/lianux-mm/damon_spe<br><br>Testing was =
performed on a Kunpeng 920 system (256 cores, 249GB RAM, base =
kernel<br>7.1.0-rc5+):<br><br>&nbsp;T1 ARM64 blind spot: A 16MB THP =
workload (where 8 PMDs fit entirely within =
the<br>&nbsp;&nbsp;&nbsp;&nbsp;L2 TLB) resulted in DAMON detecting 0 =
regions. Conversely, using 512MB<br>&nbsp;&nbsp;&nbsp;&nbsp;with 4KB =
base pages, or a 16GB THP layout (exceeding L2 TLB reach), =
allowed<br>&nbsp;&nbsp;&nbsp;&nbsp;DAMON to function =
normally.<br><br>&nbsp;T2 THP inflation: With an 8GB mmap and 16MB =
actually hot (0.2%),<br>&nbsp;&nbsp;&nbsp;&nbsp;THP=3Dalways: DAMON =
reported 8GB hot (512x vs ground =
truth);<br>&nbsp;&nbsp;&nbsp;&nbsp;THP=3Dnever: ~245MB (15x vs ground =
truth). &nbsp;The THP-induced gap<br>&nbsp;&nbsp;&nbsp;&nbsp;between the =
two modes was ~33x.<br><br>&nbsp;T3 RocksDB: Fragmented malloc =
allocation prevented THP formation, and =
DAMON<br>&nbsp;&nbsp;&nbsp;&nbsp;behaved normally. We could not =
reproduce THP inflation with RocksDB.<br>&nbsp;&nbsp;&nbsp;&nbsp;The =
workloads fundamentally vulnerable to this structural issue remain =
KVM<br>&nbsp;&nbsp;&nbsp;&nbsp;guests, JVM large heaps, and PostgreSQL =
shared_buffers.<br><br>&nbsp;T4 min=3D0 deadlock break: A 256MB THP =
induced the DAMON blind spot.<br>&nbsp;&nbsp;&nbsp;&nbsp;Triggering an =
unconditional mthp_split (via nr_accesses/min=3D0) =
successfully<br>&nbsp;&nbsp;&nbsp;&nbsp;shattered the space into =
16384x16KB folios, allowing DAMON to fully recover.<br><br>&nbsp;T5 ARM =
SPE histogram: Out of 2005 sampled THPs, 97% exhibited &lt;10% hot =
subpages.<br>&nbsp;&nbsp;&nbsp;&nbsp;A typical trace showed PFN =
0x820db800 accumulated 39,794 hardware =
accesses<br>&nbsp;&nbsp;&nbsp;&nbsp;concentrated across only 3 out of =
512 subpages.<br></blockquote><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">The SPE stuff fits SeongJae's goals for =
DAMON-X, I think. Maybe this is something</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">we should keep in the user space and let =
the kernel provide only the API to add</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">different metrics, including PMU and =
SPE.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: 2; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration-line: none; text-decoration-thickness: auto; =
text-decoration-style: solid;"></div></blockquote><div><br></div><div>Hi =
Asier,</div><div><br></div><div>Thanks for your prompt and constructive =
reply. I really appreciate your&nbsp;</div><div>detailed analysis of the =
mTHP and SPE interaction.</div><div><br></div><div>Your point regarding =
the design boundary=E2=80=94whether this fits better =
in&nbsp;</div><div>user space or aligned with DAMON-X=E2=80=94is highly =
valuable.&nbsp;</div><div><br></div><div>Since SeongJae (SJ) will look =
into this thread tomorrow, let us sync up&nbsp;</div><div>then. I look =
forward to cooperating with both of you to refine =
this&nbsp;</div><div>design and find the best architectural fit for the =
subsystem.</div><div><br></div><div>Thanks,</div><div>Wang =
Lian</div><blockquote type=3D"cite"><div><blockquote type=3D"cite" =
style=3D"font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: =
solid;">&nbsp;End-to-end: Verified hot/cold discrimination. The SPE feed =
preserved a 90%<br>&nbsp;&nbsp;&nbsp;&nbsp;hot THP intact, while =
successfully splitting a 25% cold THP into 128x16KB folios.<br><br>Known =
limitations:<br>- The full KVM + Oracle production chain has not yet =
been benchmarked end-to-end.<br>&nbsp;While individual component =
verification is complete, full integration testing<br>&nbsp;is planned =
in collaboration with Sangfor.<br>- khugepaged may aggressively =
re-collapse the mTHPs that DAMON splits. =
A<br>&nbsp;coordination/back-off mechanism is required to avoid =
ping-pong effects.<br>- SPE data is currently funneled via a userspace =
daemon and debugfs. Direct<br>&nbsp;kernel-side perf_event sampling =
integration is planned as a follow-up.<br>- The rbtree entry TTL (30s) =
and signal threshold (1/10 of peak) are empirical<br>&nbsp;defaults =
subject to further tuning.<br>- The ARM64 DAMON blind spot (WSS &lt; L2 =
TLB reach) is a pre-existing hardware-MMU<br>&nbsp;characteristic, not =
introduced by this series. Setting nr_accesses/min=3D0<br>&nbsp;serves =
as an effective workaround for the split path.<br><br>Reported-by: =
Chaobing Dai &lt;daichaobing@sangfor.com.cn&gt;<br>Cc: SeongJae Park =
&lt;sj@kernel.org&gt;<br>Cc: Andrew Morton =
&lt;akpm@linux-foundation.org&gt;<br>Cc: Nico Pache =
&lt;npache@redhat.com&gt;<br>Cc: Asier Gutierrez =
&lt;gutierrez.asier@huawei-partners.com&gt;<br>Cc: =
linux-mm@kvack.org<br>Cc: linux-kernel@vger.kernel.org<br>Signed-off-by: =
Wang Lian &lt;lianux.mm@gmail.com&gt;<br><br>Wang Lian =
(6):<br>&nbsp;mm/damon: add target_order field for =
DAMOS_COLLAPSE<br>&nbsp;mm/khugepaged: add damon_collapse_folio_range() =
for external callers<br>&nbsp;mm/damon/vaddr: implement mTHP-aware =
DAMOS_COLLAPSE handler<br>&nbsp;mm/damon: introduce DAMOS_MTHP_SPLIT =
action and hot_threshold<br>&nbsp;mm/damon/vaddr: implement =
DAMOS_MTHP_SPLIT handler<br>&nbsp;mm/damon: add SPE feedback for sub-THP =
split decisions<br><br>include/linux/damon.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;18 =
++<br>include/linux/khugepaged.h | &nbsp;&nbsp;3 +<br>mm/damon/Kconfig =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;12 =
+<br>mm/damon/Makefile =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;1 =
+<br>mm/damon/core.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;3 +<br>mm/damon/spe.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
505 +++++++++++++++++++++++++++++++++++++<br>mm/damon/spe.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;62 +++++<br>mm/damon/sysfs-schemes.c &nbsp;&nbsp;| &nbsp;96 =
+++++++<br>mm/damon/vaddr.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 118 =
+++++++++<br>mm/khugepaged.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;39 +++<br>10 files changed, 857 insertions(+)<br>create mode =
100644 mm/damon/spe.c<br>create mode 100644 =
mm/damon/spe.h<br><br>--<br>2.50.1 (Apple =
Git-155)<br><br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">--<span =
class=3D"Apple-converted-space">&nbsp;</span></span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Asier Gutierrez</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration-line: none; =
text-decoration-thickness: auto; text-decoration-style: solid;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline =
!important;">Huawei</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_B80FC59B-64C7-4D35-A821-A517B7EC0C55--

