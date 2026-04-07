Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB66DFB518E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 03:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437AD6B0088; Mon,  6 Apr 2026 23:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8A26B0089; Mon,  6 Apr 2026 23:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE106B008A; Mon,  6 Apr 2026 23:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD176B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:43:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9359C8C089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:42:59 +0000 (UTC)
X-FDA: 84630363678.26.1244976
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A00CA40015
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:42:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VUuSvAL6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775533377; a=rsa-sha256;
	cv=none;
	b=uXphL1b6Sx6K+fp3JXDHkQKt1k7ex5kAC+QXdoOw6ZApBdobZyFWnNjx0zwHYVZcygOUlm
	EdhZSBd4LEJKHPqyk7OY5RXcBaAJDYKHIGA2MUkU3+zenQNqO/hpegZcizgbiB7OmYvY1z
	7egHWXJ/gAZHc6Qsqp7B+r2DIvtX/Gk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VUuSvAL6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775533377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpH84K9M/Hugold3gW68cxgP33cFPKsQLO/3cFF6+nI=;
	b=ORgdnZyRHNoPjW0T8Iwb9drn4EhQOEUPD3dsVxx6NN7H3e3Acim96RsBdqTLDAAPVxLRdc
	xGCF3SUv7dB3jlvFbrL87WlAbXIDNa/BPjBtCXzS/rrqRjkqqVqBlYfGgLcEF5X5G0vx1h
	yTXXNP+VKnCeiUhsYY4s2p3gTH8hH4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A181944427
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB39C2BCB6
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775533376;
	bh=PY5ILjxCJ5TPuG6N0E7dhyIq1ZD+5631r/TnZxOEGqs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VUuSvAL6MmfiGvHoOHm1xPJTU1DpfVTVCk887C9HA01fbUJW6Tn4Fv5E1Z0skVC+y
	 tw9NfzwKG518J0Cy3ragAO9/m1rCZPVNl6niPRDV6KGeu7Riv7qn4vWPieLAko20YA
	 oBTlrTZAzHKo0FyLxQqUY5YWyG7wC3rSK+g1Xrm6CkY2hZC03LD8YOYDDgHTJLPo21
	 /keuIjDMez7M5VOmT8AuEWU8quzzgnYmoNW1tOTAWyZQkTSP7itfIz8azH/EHnY1P4
	 cLOJ+2Ts7dwqkaf60zoiaL4BK3sJz8QfoUMx212SquwTnyJqCMFDNvntBeGdooqfkQ
	 8WzkHTXYJFM3Q==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-89fc4147f2eso60170026d6.3
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 20:42:56 -0700 (PDT)
X-Gm-Message-State: AOJu0YxedOjyPP8JPUN0QFakPpNI8hxXG2EU0nedmCk8oqRJJU2+VYCz
	079mEhAmL47MV+sbOrF12KbIXkXDG7FXdZFlmVIwgzCm3Qcpq7t0B1rTUz+DKmPsbVkRW9hmTa2
	+UY/+eCFHqfjyyOe1mwHnw9itJA6P+dI=
X-Received: by 2002:a05:6214:20aa:b0:8a9:9cdc:9ab9 with SMTP id
 6a1803df08f44-8a99cdc9b7fmr142559486d6.24.1775533375703; Mon, 06 Apr 2026
 20:42:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260406195014.112521-1-jp.kobryn@linux.dev>
In-Reply-To: <20260406195014.112521-1-jp.kobryn@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 7 Apr 2026 11:42:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xqmXGon8d9bwD_6QnRvpa+4uXDw4vGrv_C1BZC59DOQQ@mail.gmail.com>
X-Gm-Features: AQROBzCUXfyDhGLk2aQzGMeYjrCKkTpaMIsiEwO5P_TRgb51gwzU8_3avOm2lko
Message-ID: <CAGsJ_4xqmXGon8d9bwD_6QnRvpa+4uXDw4vGrv_C1BZC59DOQQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/vmpressure: skip socket pressure for costly order reclaim
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, kuba@kernel.org, edumazet@google.com, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	wanglian@kylinos.cn, chentao@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A00CA40015
X-Stat-Signature: zdj91zfd68xpdawnsrjmzggku4jamx6h
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775533377-208003
X-HE-Meta: U2FsdGVkX1/cYGBKSy7X21IcnHywuZEQJOUAI/bMvhFNMpyR7Pugo2P6KBFGf5rZnNSSipuT9I0mNZaVzM+k6kesOP6KU9hywbTf3GcJt4HHKWsO3MnSIra2EHaefY5wV2WD0VFkMZl7blOCs6fJDkxDXc1Tjx4WzE07ujK5RWXUJ+msTH93G491EAUSDiARviWmZ+ZKtgkumPJKU8MBNTdQx287erd+RytfD8CO2tHVVwEhc1mcEsS3X5SL21faJKaunmB7B5Rgc9bhMnSVQrzxqG3/geQ3BLxF7pY0oyjxOsoWridGzNBHTAnRuha149gKrzfQN2Yrj3dzlMfj+CwnVhV1mNKo6RavHwgSO2M2eAHmU4jZUwp7NlCfNv3FW31WeRGfzFEkeVf79UAA6Wu3FO4B8/QnT2K76cSXhiFs0MroWdNbayYxUJoUJBZ37Je4ilA94XqNlcbG6EMv6kAFLYmlzHL5eZ/IbJFpwS4/xvB0uNsveloswL9hPa2DH6YiDpou0h8FN7+HKEpjCIHP0h2AFbviuDg4APFC1WvmYUXlpkpYwNSD7RYK3eZ2wTtF0jMkGGZXHrqG2sJRc8IzFOjDjZpHb66UsUnxe0tl5YSwR5ZeQf2XJti6N0VKjpQtf4jwxO2ALWM3DH8BOK5UMq6Pd2exOGrqTvMW8PBfyCmSHKrzjP7m1oE//ASEXt4Rs2Aofjfro5Ot93yD3rVM8aMV1EAMZjxEzfB5jsCRWf6Z7PAI9o3Cs3nCsaOTvN5d0FGZ5hhUqLtaM8Xh/YBIEvUrN/tQhbyA6SiKMQcrsZs1PDWaCwtYViOuTQ15U/5SKfNtHF/n4XTcuqkNCuyhVDGiIcgRW4wd6Xwq8deNAfWL6stdGoAZdhY1j4ZDcsnXcVwTcMOv9hXF1rgK6JMBZYBojZOBSfANS/DT8uHh1jZHFxGExhP1fP6N2BqiOleDurqg8N6raKD1bC9
 ZYz/8Y6e
 pX5cUX/hMG5giqgvbyHNDVtCzM2BPXfSeGXGsR3svIwQZDzPq0G6vCwgn7mhghwvxo4TvMWs07fjQoqPttJJs2QA/jSkjKluTOYZistH1kLFAwDcqFZrEHCD1uINFqoVjVZ+6VsZZyDTEX/o/eALdQqnVyHbYLPK62jX2zrwxQfYLBtpU6SmGNsptqrEqBE0Ced9clOIZ4hPPFyJNhaIQMPiRt2XKmDV52pck27aP19ej2DP27hhvrarC4eAKJfbZ20IYY2Q2zz6WHamOIgPech3aIimzjkOt5C2nhz0ieBWbQZ7ejQCKSRZkVa0R6J7gwORbX+2miPLjvNK4hmE52gAjKKFpAprvzJ9jg8elXvNBvZsCUJUxBJWANev/UAu4pbevwZHPSY4YL5BlVoeqeL5ICZXtcPwp3JAcMcKUw+DtKvBF2zjGxzbe8ZR8UmN+0A1a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 3:50=E2=80=AFAM JP Kobryn (Meta) <jp.kobryn@linux.de=
v> wrote:
>
> When reclaim is triggered by high order allocations on a fragmented syste=
m,
> vmpressure() can report poor reclaim efficiency even though the system ha=
s
> plenty of free memory. This is because many pages are scanned, but few ar=
e
> found to actually reclaim - the pages are actively in use and don't need =
to
> be freed. The resulting scan:reclaim ratio causes vmpressure() to assert
> socket pressure, throttling TCP throughput unnecessarily.
>
> Costly order allocations (above PAGE_ALLOC_COSTLY_ORDER) rely heavily on
> compaction to succeed, so poor reclaim efficiency at these orders does no=
t
> necessarily indicate memory pressure. The kernel already treats this orde=
r
> as the boundary where reclaim is no longer expected to succeed and
> compaction may take over.
>
> Make vmpressure() order-aware through an additional parameter sourced fro=
m
> scan_control at existing call sites. Socket pressure is now only asserted
> when order <=3D PAGE_ALLOC_COSTLY_ORDER.
>
> Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
> uses order 0, which passes the filter unconditionally. Similarly,
> vmpressure_prio() now passes order 0 internally when calling vmpressure()=
,
> ensuring critical pressure from low reclaim priority is not suppressed by
> the order filter.
>
> The patch was motivated by a case of impacted net throughput in productio=
n.
> On one affected host, the memory state at the time showed ~15GB available=
,
> zero cgroup pressure, and the following buddyinfo state:
>
> Order FreePages
> 0:    133,970
> 1:    29,230
> 2:    17,351
> 3:    18,984
> 7+:   0
>
> Using bpf, it was found that 94% of vmpressure calls on this host were fr=
om
> order-7 kswapd reclaim.
>
> TCP minimum recv window is rcv_ssthresh:19712.
>
> Before patch:
> 723 out of 3,843 (19%) TCP connections stuck at minimum recv window
>
> After live-patching and ~30min elapsed:
> 0 out of 3,470 TCP connections stuck at minimum recv window
>
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> Reviewed-by: Rik van Riel <riel@surriel.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

This patch looks sensible to me

Reviewed-by: Barry Song <baohua@kernel.org>

This is a one-sided costly order and should be treated as costly for
reclamation. On the other hand, nominally non-costly orders (e.g.,
order-3) can also become costly. I previously raised this issue here:

https://lore.kernel.org/linux-mm/20251013101636.69220-1-21cnbao@gmail.com/

Burst network traffic can make phones heat up.

More recently, with help from Wang Lian and Kunwu Chan (Cc'ed),
we developed a simple model that reliably reproduces this
behavior, where we observe significant CPU utilization by
kswapd due to 3-order burst allocation from the network.

I may revisit this discussion soon.

Best Regards
Barry

