Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45E7606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 21:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iaL8/2dm
Received: by kanga.kvack.org (Postfix)
	id 0DD8A6B00EF; Sat, 31 Oct 2026 17:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067C96B05B2; Sat, 31 Oct 2026 17:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71486B05B3; Sat, 31 Oct 2026 17:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B01446B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:02:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25BBD801F3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:02:54 +0000 (UTC)
X-FDA: 85384145868.16.F2369B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C452180003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:02:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iaL8/2dm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793480572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JovmbRKKM9xZ3bzkOvnYz4tRy1n03KhMCiMLiQXxNrY=;
	b=wLAclHTMXJaJVLq1Jr6nDFhxw+yrMmoervDA7HsKlFBQi8T8/beXJEX5pg8eJh2z6j5wCw
	2Q1EEctMPMfgjRGf2/Vp+bWCHDlPTcy9X09+43AgydYUkcWr+BcPt0+Z/W4OUCc00NNYfw
	5leolxTcECdFXEnpVDZ7/Lmg+nN2oA0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iaL8/2dm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793480572;
	b=FtAO69WAaLSPMpzBVZHvN/vC85oABkYwnLnhpzlxVoxP4dXT7+691Wdcwk2X5+yWk+3zUj
	e5UqpYTBPXtg1rAEs0efi3DkoE8tlmE9p7cz8M2nCwZcbfOzXy+9cA/9Myuc+0r+WRa5hZ
	qVNTrtKmynCfYD3csxvbVVNHzS+RyP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4980A439F4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E6E1F00A02
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793480571;
	bh=JovmbRKKM9xZ3bzkOvnYz4tRy1n03KhMCiMLiQXxNrY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=iaL8/2dma4L2E5r6CldXJPvKqp8fRpEetqR8UoiqvMhoMOwGzo04tlrKZ3hw8EDxx
	 cm57XH3+C30FHetLJsF+AU5ydcWWignbnOVFSCy0PIfJwSsEVfg3skS30rwWyifbPv
	 U2DodA5o6IN77nFMpvde1QBph7M3eFFfIV+uZR5G+3JWsajtB3rmlGcjGU5bJFvyro
	 wJBN8iIVuhoZKq9Sw6xHp2MABjFjNgMzgfQxODk65Rq7NP58URXO4T3qf/UqfXlamp
	 MNCknK2zE8IQ2p5CWIYCBUDbnrUU7S4noc9BOPlq+4B1pL2x3E6pFx0OyAuy/R6Qht
	 ielu/hDoaTKCw==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f1e5d7450so170745885a.2
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:02:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByfpUzdu2qVQDh4QVY2I1H8b+E5a5TpGg0HU0+nwFvJm2hQiLPvgUQMGJJMYlaLektSF1ILFCXy4w==@kvack.org
X-Gm-Message-State: AFq9FYIW2cD+tLKVjXTkVLGsdppLq7TtwlNl3bD2hS+HLWWYbL1C30Mg
	XQrhQYdYy0bA3pzPptTRF33K1KbrPHP6iLqJb2AdYQCMjbF3tFMcMXkgxyoL07peAto2CRsgbOg
	9dGYGNRxrnmrW14zTO9zC/UJUwBjR2Zw=
X-Received: by 2002:a05:620a:8393:b0:93e:c12c:4416 with SMTP id
 af79cd13be357-94421805919mr873994685a.82.1793480570337; Sat, 31 Oct 2026
 14:02:50 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261031090041.58574-1-ridong.chen@linux.dev> <20261031090041.58574-6-ridong.chen@linux.dev>
In-Reply-To: <20261031090041.58574-6-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 1 Nov 2026 05:02:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yarkUMWjuJ+MVw3EkNDHanDU8_LKk0Td2tO9DJUe2cyw@mail.gmail.com>
X-Gm-Features: AclHuK_IJBi8BwrNBY8KWJ9NBHd1SSJ62zreD3OjXulz7n9Nc2RkMxdC4i3O-Xc
Message-ID: <CAGsJ_4yarkUMWjuJ+MVw3EkNDHanDU8_LKk0Td2tO9DJUe2cyw@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] mm/mglru: add tracepoint for scan_folios()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1C452180003
X-Stat-Signature: xpp97bdn65s4dn5uxtgokk3w85aqmwp5
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793480571-969201
X-HE-Meta: U2FsdGVkX191X3301KevdAunDBOUIfdc12MvsZzKiCXmlrUheik4iPPFJv4QonrAWCZT4lrr2CxZEiFCw5a+3CXc4Ji+jbJ5VI0RCKJ6/O2NMzHuTZyJd7pKJtEPUOkP5aQ4LpbEOXe1YVniAHYXz72QYXpeZybm+CgFSi0/4RLqRv1Fz9LWSzg4ZreKi5p1286Z90mjlP2QpWsaGyFpKJuktgJ1S9zxb7A9XIHReDpzuXpF04djqM+eOt6MKvp4AxnSYJdFg9zgjHI+jN/v6wnnfNiR6i9uF5zqdAvXKZsmzf7PHpUQEUtcwM1lSFCJC/4KNURbV1xxl5wN0kUuanrtPKvt46NdJq/G8VBufF5b1lZJHNUOHHnAGykGJRgPBt1llDgph20W0gDrqwJQRnXjLhSuf/FE1/kTer1F8PoX5jxbTsnEszlSmU1YnAUhfkMn590wGkm3YlvNF8kiTlB6LHL9Nk18g6vKq/8uuZNKYfYkNIHfv1CCarLC6d4WUEoW4JipzEuO/STULbwGJQ5fF0HYWNLwb3Jp7CTlnz/yfMahbWLjognOKUL7ndEE+ororrlqIIYPELsQGV1J9N+B81aU5ItyIbivzUQxaMf2TGWjnuWmbC0w52NuVJBy+42QeMSU5kD9L3pDzOf4nWGYmOIgNwqoyXJ3yL9avYb6W1EtJjXx0DaqQFapucuAoxkTUXNr1tyC5YiShectz+uWVqg1AKR/VWB/L0/invc9ao6atgw1FnV54wc8P4blRrT95CMDeCIK5CuWY3rWutv3FCD4VuuecpOMXKxQCPSrcZN0mtmn7JOo4VKnQYUNU/Qsf/eA08+C1Uo3TvyJ8GNxofwXElPDrSo4no7Ie39ji5kVuA1B/cSVx7g+xNd/9iyR0KyVZQmnRBGk+INpQmXN+k5zGjuBIFC7gXjcaMWUvQqP0Y9v3XIyxeYU2mWIXwtO1Qd56wAzjp2AsML
 69RJVGRb
 J/d5/gwZPvlmhh7OO0p4XXLSlGgoXdj4EcpsxVgjqs+idBIsG76ZK+JuoiXAFedDhzfU5es403T21GRc4Y31t87cDuF+PxqtLs6ems4iY66V35/JxRuQBGEv5zTB0MCrtAR6VwnjnS8HvZQGmOQgBtWcwsBr4l3bfeYZTl+1zvkbHiT+7L/5W4Exuyut2CnMhP+g7S/YAU8bSMRAXDKeUOSiBCMvLVLCp1+RL9UCI4isZjOmjMvkVJvEGNU0EJ1R0AQFjzCflCbS/hYPEdTfI3l51xpkShlTJKgmdNC7wt0VZJ477cJnyLiqsidgyW1YhSVAHMBuSUJVE1R7xuV7nwfnCfrqEjbM88ZjbDHDa9Rk0Kj4kny1No4sd9IpPPzzGlvV2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 5:01=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> MGLRU's scan_folios() emits the classic-LRU tracepoint
> trace_mm_vmscan_lru_isolate(), which predates MGLRU. It reports the
> scan/isolate counts and the LRU type, but carries no generation or
> memcg context, so a trace of an MGLRU run cannot tell which memcg a
> given scan belongs to, nor how far reclaim has progressed through the
> generations.
>
> Add mm_mglru_scan_folios next to it, reporting the same counters plus
> nr_sorted (folios moved to a younger generation by sort_folio()) and
> the context the classic tracepoint lacks: the node id and memcg id of
> the lruvec, and the max_seq, tier and min_seq of the type being
> scanned.
>
> Now that struct scan_control is visible to the trace header, pass sc,
> lruvec, type and tier straight in and derive everything else in
> TP_fast_assign(), so nothing is computed at the call site when the
> event is disabled. The int fields are grouped at the end of the entry
> to avoid padding on 64-bit.
>
> scan_folios() is the MGLRU-specific layer where folios are actually
> scanned, so it has no classic-LRU counterpart. The existing tracepoint
> is left unchanged.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

Ran a test on this:

/sys/kernel/tracing/events/vmscan/mm_mglru_scan_folios # cat format
name: mm_mglru_scan_folios
ID: 491
format:
field:unsigned short common_type; offset:0; size:2; signed:0;
field:unsigned char common_flags; offset:2; size:1; signed:0;
field:unsigned char common_preempt_count; offset:3; size:1; signed:0;
field:int common_pid; offset:4; size:4; signed:1;

field:u64 memcg_id; offset:8; size:8; signed:0;
field:unsigned long nr_requested; offset:16; size:8; signed:0;
field:unsigned long nr_scanned; offset:24; size:8; signed:0;
field:unsigned long nr_sorted; offset:32; size:8; signed:0;
field:unsigned long nr_skipped; offset:40; size:8; signed:0;
field:unsigned long nr_taken; offset:48; size:8; signed:0;
field:unsigned long max_seq; offset:56; size:8; signed:0;
field:unsigned long min_seq; offset:64; size:8; signed:0;
field:int nid; offset:72; size:4; signed:1;
field:int highest_zoneidx; offset:76; size:4; signed:1;
field:int order; offset:80; size:4; signed:1;
field:int lru; offset:84; size:4; signed:1;
field:int tier; offset:88; size:4; signed:1;

print fmt: "nid=3D%d memcg_id=3D%llu classzone=3D%d order=3D%d
nr_requested=3D%lu nr_scanned=3D%lu nr_sorted=3D%lu nr_skipped=3D%lu
nr_taken=3D%lu lru=3D%s max_seq=3D%lu tier=3D%d min_seq=3D%lu", REC->nid,
REC->memcg_id, REC->highest_zoneidx, REC->order, REC->nr_requested,
REC->nr_scanned, REC->nr_sorted, REC->nr_skipped, REC->nr_taken,
__print_symbolic(REC->lru, {0, "inactive_anon"}, {1, "active_anon"},
{2, "inactive_file"}, {3, "active_file"}, {4, "unevictable"}),
REC->max_seq, REC->tier, REC->min_seq



~ # echo 1 > /sys/kernel/tracing/events/vmscan/mm_mglru_scan_folios/enable
~ # ./a.out
[+] mapped 500 MB at 0xffff9f000000 (128000 pages)
[+] duration: 60 seconds
[+] first pass done, start looping writes
^C
~ # cat /sys/kernel/tracing/trace | grep mglru_scan_folios | head
         kswapd0-50      [000] d..1.   650.877105:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.877686:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
4
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.907558:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.907729:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
4
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.909040:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.909198:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
4
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.910520:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.910710:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D64 nr_sorted=3D4 nr_skipped=3D0 nr_taken=3D6=
0
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0
         kswapd0-50      [000] d..1.   650.911866:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D0 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D0
lru=3Dinactive_anon max_seq=3D3 tier=3D3 min_seq=3D1
         kswapd0-50      [000] d..1.   650.911988:
mm_mglru_scan_folios: nid=3D0 memcg_id=3D1 classzone=3D2 order=3D0
nr_requested=3D64 nr_scanned=3D66 nr_sorted=3D0 nr_skipped=3D0 nr_taken=3D6=
6
lru=3Dinactive_file max_seq=3D3 tier=3D3 min_seq=3D0

The LRU naming feels a bit weird to me. We have
"inactive_file" and "inactive_anon", but MGLRU doesn't
have active/inactive lists. I guess it's not a big issue,
though, since we also use the same names in
trace_mm_vmscan_lru_isolate() in scan_folios().

For the patch:

Tested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>

