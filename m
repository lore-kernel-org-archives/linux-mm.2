Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E136CFEA806
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 05:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0F56B0005; Wed, 25 Mar 2026 01:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1526D6B0089; Wed, 25 Mar 2026 01:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040F86B008A; Wed, 25 Mar 2026 01:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E79146B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:48:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 868B9BAA39
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:48:35 +0000 (UTC)
X-FDA: 84583505790.07.49566B2
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98BE4A0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:48:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ADNRAHyT;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774417713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5Fgm1cniuA0K/QxLV9pcnPjcR4YXOVuqckwt4/TbJU=;
	b=u6FQma0DFdHg6Jl9jcxSycWOe9lGcfspD9vN2pJ/14jvCkweu0yitsYin/wu8rKP9OZQBT
	cRT8NMvAoXnilHICWpPdMOmHQDn+DWQ5qCMJ0Dt5xo3a/Ainwd41TY9GeFix9vTCjAdeax
	Znnz5WNKlLDDSAz5JFtWh4mZeI9oBBY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ADNRAHyT;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774417713; a=rsa-sha256;
	cv=pass;
	b=nuKIsl/5NO7htJtcFuf3hdRRmBPSHwr/AR7A7IUwxSExw1yzhNF5exS4nWTU9e+o2TtsY1
	yeByjIFLdWmneyWUZFCocOHqtl0DKs1vOW8KC2fA0cAhFESWN4MEedix2AgTi6HOFnob0p
	5qfhSU4zu2TR8cWsJK+eGUBIqLfJOUw=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-668d9dba217so3609796a12.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:48:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774417712; cv=none;
        d=google.com; s=arc-20240605;
        b=SsVTU3NHtD3uBLCYKUhNdrmtznXYSPq2mrCbBE/bb4+Hia+x2tOBsVj641C86CIe4p
         wBCyFrA5saxjtpUFwMVt45xsERSALV9s0biYvJhSmgdsqItCXL7o1WpFP1e5eAvD11wW
         PVxWK+dxuz0IvgBHEddhteFYk/5JVEYM8pEwivMpzpjVyD2BkpfXrufUgSvxi/yKOLcU
         Z7AV+jz0Sf5toBSUdSlWCfkher8Fb5BVlbQ2oVPL2t7isdHoh3lZZo19nGW+UM1ElBqs
         cnZF0b+P8F6sYFiOvnR6fF+CY0L3IZTo+OGox80QuRWgylDa7/WXr6RvqwADBIhayu4X
         LUiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n5Fgm1cniuA0K/QxLV9pcnPjcR4YXOVuqckwt4/TbJU=;
        fh=s29UgilmMNtDP+2rxfUvIikeOr8PFIf+kjvPE3KCX+w=;
        b=jUGVwilnXROnan6JLXcRWgWx9CAhW1A2joxzVddoqNR8ZRymTqiiRaODHtNefuhjgk
         ERiLlE03KzG4EcAUEOs76BZOu2UlwEpBN1ZRL/h13aF0vl6ZBdqnOcK3p3EJ0W1MLS80
         uOorjjKvzyAmU7TFfFnOhscgoRanCVx/pVR9SUOJFwrJWoewbBwhgKwhpAXQRnbsXy1G
         qGM6SN3rwr+8CSxlbVkFY/LByiDSZEQKLF3osclGyy/uRnh/9Y1AbDklXHPtc2mZ5d+m
         pgi1dPFPnT9gF7sokmIHQBAR9xIe6dvjh8iZKvX7N7ybofyYmU15ejW3PWvdFGteoP/T
         4dRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774417712; x=1775022512; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n5Fgm1cniuA0K/QxLV9pcnPjcR4YXOVuqckwt4/TbJU=;
        b=ADNRAHyTqFTubGbJO1GRcjFTzJuefEuIv7fGMmfVzzN6E7IzLBd8oO3nlo7z1e/0Ug
         81fD/JW/cSD97ZkA19Hyh2Te4ZpqaUheoWjqewCy/0Z3+0x9E7HEfxPysXzRVzYGyV17
         J5nqHUxkJvdYEOCrh6wMOP6S6//kBkWGRJIGpt1c9SkSB7asUOw5HtaB4XBSddX7FE9g
         PUbtvlhXGCRb9GPOdHmYDUjQLjTEKiWkFVh68UZ5ppOht3TMli+auW+vfM0CebKX2ADk
         +QT2RhdMDM4ZBKUvUh8Qgyvsgil7BDD3WefWDWNv/G6imIiWj279nrtoHuknaDnmTaRY
         k22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774417712; x=1775022512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n5Fgm1cniuA0K/QxLV9pcnPjcR4YXOVuqckwt4/TbJU=;
        b=asKSNLPM4FnsZc6YhJqd8i35ES0+2NfM/oX0CHNkOfrSoViqVAZFOohrMyAqsVAKmI
         mBQcGvUUWmbVMUY5/g/dPqjDmUlQmEV377x418CC5rklwqeC21UhMo6lPG9F+L8aCcip
         pXI8HuqifNF9GrPJH1GVzOKxDAkG2rDlsWfUu51eMoxpCHqx2s+yDMWa6Wtrq+2INeXI
         +uJhc14xa5koUbgkGITZYVh8lC31DI3Uv9AyccnJ4k2QSgrCGRVObAnfK7pekngFxr37
         gnr0UlDvwt0XDbKVUYO1Yi4T7sX2N2jFMS7a+u7RmMgkaY6W31D69UF7vE+9p/DtPDkC
         +sMg==
X-Gm-Message-State: AOJu0YzqVG7Nojj8UEWL9YG8qsz8q+Jz2LUJTCLkRPxcC/l4ogkUW6PB
	szktmk6kEPxDGNIX3z7bmAKYGAYMGgNMeLVfZcvpQNDuPPb+k+XkWlNh/u2El4HgkvRKu9HPJm6
	xymHSwRIWWfvTFwwielwai1NOCPqvJX4=
X-Gm-Gg: ATEYQzxYgucWWdVUlcCSwUGRA5dTuR7IUmyuG8vdm/SrY1I91e3LlOMVyge4tWJYhjj
	BgIUBykvdEZ5OepLVKmPOeXmLYBr1E0bnXKXqhiwDYZOjeTlCjCXFOiDijcpBs7gjri1FCjQMm4
	GuXZSFpqpwmeVBcB0Askomfb9FQ3XEtRDY98D02fjVDwjOqQUsEbyng6o2pHtlQ/paXwAGyubkw
	RsOvyJKsyqtfyXK+erx7xhWcqSbl++50lYAsVguFN1P7bY5gNgN+B9W5nkIRMb6wLhPH+hwoLKS
	iqT/SsMpGCfBJ5bSz2xQDjbhbADSVhBmi5XY1xfF
X-Received: by 2002:a05:6402:3593:b0:660:f1a1:e8dc with SMTP id
 4fb4d7f45d1cf-66a826d3415mr1336499a12.25.1774417711647; Tue, 24 Mar 2026
 22:48:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com> <7ab8edd7-381f-4db2-9560-b58718669208@cachyos.org>
In-Reply-To: <7ab8edd7-381f-4db2-9560-b58718669208@cachyos.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 25 Mar 2026 13:47:55 +0800
X-Gm-Features: AQROBzA-QnYG05Et-WDmzb86Qr9I6viiZelbYKgGYpfDZeQlxlxNUTVN2LFb-Qw
Message-ID: <CAMgjq7CuEYAzZFmS2T7N6je6VHffVkH1hh64YUuShFBnrJJvqA@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: weaf8xxhrxqjuxrefa85tfdhw1jpwm6r
X-Rspamd-Queue-Id: 98BE4A0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774417713-719431
X-HE-Meta: U2FsdGVkX1/JrhEoPSk6JishL72aKLyT86HAbp+Sq35NEJrTXHLtVWmQbXYMltv+HS0iNGp3fDb+3Uk77YTKEq5iWbDlBMgTZcZQob9JvGyP3CiAT5bx3ADUxdE1IfNl3TlVtpD9ChN9Xqx740tj2izPYolgppQS9s23ti9DeDeoAxdSgUzuSNWKxYqFipaFUhJKTpsomROjs5jquMTHH+7Y3hUVzMGQTns5i0cQoMOsXVeP48dUpJWp5enRbVA8FAOWVCGFE4yCbjjOotn3X0aMzBXk5h/bK64Aqi0wXhINmCKIXcf5FWVTtcTx3NAHp3YH1WIxFvK1vah2dozhKLh2HoH67A0H84sDmULldQ3r+MKmAV6TNcGhJ/qN/9uS8O6r3OgSX+myEUx96ZZ7rX4cZHUmLwMF/52g/d7iLD9Xozv/oeF184YBhOp/A4L4KGtr01UZa7bp0Eos3BgilgQxmuQBmAQSGiNhsVsuPJiuQoFyAZktqDZm0wWUaGDemo+OY9G/JQd+ed/9yNIiXaQbvsgbYWY+YRkHwjfJCa4M7sDyKd68D3tJ74dsNC2Q8NtoDqO7GkQ2QJH71ZGXXJ62yhVitOPxeWVLPU3wfFkRFh13VCrXzE8xmdSCWMeZjMlo3XmMqrKAPBPmK8e+Ueac9Z9chbokDuFDJTt4ngJVVjEjppRVQszvrhTkX4WabjbBYWUhH6rpYZQdglKTpwueb3tlO2yqher6qs9sNbfauHzB6gVfmISo26fzPz7U3gW+JVzqcBb8o90YOnlXBxTBxv+Fu00904A1zeR3pNXVtRVjFI7exAHaJGbUlTkX7ZKX7PvELIgC+Jf5+F3QgjKWydvHoDoAhHUsMwZ8LDaBDQlNTzxe0UaZNudLEQ8pn4WEPV3WX194NDhNivzw0FKgdtjp2MaDiXu6GY33lCM1gG3jl0T+Sv3vYyo9dqB0gfODnuuzeqtHYs0ri7Q
 ISudFBgi
 Xy4sdqLY/r+DA9MTQaCmVPb6xRbNCM3vs0oG1dOCFrMGpRA4FLhuw7LOvFHRLU4wH9P4bC6Cl0umZBK4gSlaKbXro8utTDdSoPKdJpV1FajZru/klSwOKS+Z5IG+6pYRwezuyP3JsFR8vH+oH/zpjXPGIzGipzAI1vtXWlXEv9/BWw0sfcjaER/EYFnsROIdAvWeWGGwSU0TsyI+f/ldVoRoAcxPiMONWK+y8fhD/7534Z0w+TRGG+uoFDoLIvoWbxTh9UD9ZCg6PevYBkLMXhmCqtWn+Mqw9LL0ARgp+u6TtSY0VePiIj23DN/aPMRl1bR4X5/bMlaBz0reZgbahkZgXRK0rzTy7357XMpDHHEOrDvIE6JshmnF/Y75GOYiDhrDBPb+1+Q4NPSlxsQc0umUMhZxfTGZbxGuU6buSdSK1MgRomPgU9v6fflg6iFcBM2DvSoZG+NCDu3XZLpuIOM027UPL2JXIzUdbuRNgRrbta//ASBWrYM9NCMTit40nzMeO3tDq3RSYZunHiirky5RNG+Uj1s5W9s/513+PDPGwrx73KdJR/Cq9gNO27YxQFDVfOTz4wC0I1uEPD46KeIg3YqNr+wUdIYR58qMQAHuUfa6KxnQwwbJpyhlCMJUdwv2fn4trqWpEOWPnDBUVIrYPNktooAtg55OYJemVGlc8GNgGtdN5UJ0ihYicmPoMUfWSlIr7+jbsHSFGLRoT4f8KT6WY6+kXTqCZaRdF0pd8ekH/ndl6VIWUCsvUaYmBVJBU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 1:04=E2=80=AFPM Eric Naim <dnaim@cachyos.org> wrote=
:
>
> Hi Kairui,
>
> On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
> > This series cleans up and slightly improves MGLRU's reclaim loop and
> > dirty flush logic. As a result, we can see an up to ~50% reduce of file
> > faults and 30% increase in MongoDB throughput with YCSB and no swap
> > involved, other common benchmarks have no regression, and LOC is
> > reduced, with less unexpected OOM in our production environment.
> >

...

> > Before:        2881.41s
> > After patch 3: 2894.09s
> > After patch 4: 2846.73s
> > After patch 5: 2847.91s
> > After patch 6: 2835.17s
> > After patch 7: 2842.90s
> >
> > Also seem only noise level changes, no regression or very slightly bett=
er.
> >
> > Link: https://lore.kernel.org/linux-mm/CAMgjq7BoekNjg-Ra3C8M7=3D8=3D75s=
u38w=3DHD782T5E_cxyeCeH_g@mail.gmail.com/ [1]
> > Link: https://github.com/brianfrankcooper/YCSB/blob/master/workloads/wo=
rkloadb [2]
> > Link: https://lore.kernel.org/all/20221220214923.1229538-1-yuzhao@googl=
e.com/ [3]
> > Link: https://github.com/ryncsn/emm-test-project/tree/master/file-anon-=
mix-pressure [4]
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> I applied this patch set to 7.0-rc5 and noticed the system locking up whe=
n performing the below test.
>
> fallocate -l 5G 5G
> while true; do tail /dev/zero; done
> while true; do time cat 5G > /dev/null; sleep $(($(cat /sys/kernel/mm/lru=
_gen/min_ttl_ms)/1000+1)); done
>
> After reading [1], I suspect that this was because the system was using z=
ram as swap, and yes if zram is disabled then the lock up does not occur.

Hi Eric,

Thanks for the report, I was about to send V2 but noticing your report
I'll try to reproduce your issue first.

So far I didn't notice any regression, is this an issue caused by this
patch or is it an existing issue? I don't have any context about how
you are doing the test. BTW the calculation in patch "mm/mglru:
restructure the reclaim loop" needs to have a lowest bar
"max(nr_to_scan, SWAP_CLUSTER_MAX)" for small machines, not sure if
related but will add to V2.

And about the test you posted:
while true; do tail /dev/zero; done

I believe this will just consume all memory with zero pages and then
get OOM killed, that's exactly what the test is meant to do. By lockup
I'm not sure you mean since you mentioned OOM kill. The system
actually hung or the desktop is dead?

I just ran that with or without ZRAM on two machines and my laptop,
everything looks good here with this series.

> zram as swap seems to be unsupported by upstream.

That's simply not true, other distros like Fedora even have ZRAM as
swap by default:
https://fedoraproject.org/wiki/Changes/SwapOnZRAM

And systemd have a widely used ZRAM swap support:
https://github.com/systemd/zram-generator

Android also uses that, and we are using ZRAM by default in our fleet
which runs fine.

> the user that tested this wasn't able to get a
> good kernel trace, the only thing left was
> a trace of the OOM killer firing.

No worry, that's fine, just send me the OOM trace or log, the more
detailed context I get the better.

