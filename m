Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF062C79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 06:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2046B0092; Wed,  9 Sep 2026 02:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CC36B0093; Wed,  9 Sep 2026 02:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95D6A6B0095; Wed,  9 Sep 2026 02:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD3F6B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:40:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5C231A00EC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:40:23 +0000 (UTC)
X-FDA: 85193274726.19.1818CEA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2744A0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:40:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kVHaqXLd;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788936021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUIpC49PUmusVJC7vwQlTM5YfwPWfFaooGvwBV89sWs=;
	b=1+7s90kR/jKv2wWgM2SxKSblWDoyllABu4Y/lT0MtZZfNzLh90VzB/X21SP/VEYAcmlUhK
	RU7vWDdH5tw6A9b+12o67+cet/fM3fb9g9ODThx+DE8WamIPQyMsREPLCKe0GfQkwtSt5B
	fudBLpWlkLyYkNaNPi3vBGSM+lNUpis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788936021;
	b=OS4VSUWJ89G+V1oj2juzBuZBVAxIImCWcDJnoP5PEOikFh/35zwkwsViXqV6Pz3LHOCptK
	rO0a4yXyrPfFml5BiPz40KKDKhJsPJXgQH9e55jvhIpnMe1IbWAphoLTLu/5ESXXonQLqx
	25kzC2ruDfnvnX9JVFupqINjrqu6vh0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kVHaqXLd;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4629160214
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0121F0155B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788936021;
	bh=DUIpC49PUmusVJC7vwQlTM5YfwPWfFaooGvwBV89sWs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kVHaqXLdNh1pWSRvnWeYdjAvn1xp9g+a9Xl3QZ02PKRnj6PWvpa49/L1tmuwZ5hyx
	 FDdwRtA3893Bl35MWF0aT4BsdPxizB/uV5kpgpurt3+aVVki7Z8itlBm5V5E978Uas
	 WaFdSw4tKUOT9IU26xle1shTB+lnI5CsCVgE4X2qPCWfsX5h1D+6kPtHUUSpybsQ3G
	 cy3j8e5lNy5yLsnT2WqEo8yVW6iBcvNscbZ+pUTwg3+DQUnVkhmL7qX7EIeNf4s81Y
	 Zxsf1BWCAboPGnDibMtAEG8jZZSXwjuvkFhZfsV0Kx+NSSEc9pghTXLEPsE/izwXqf
	 nWEXRZI/nRojg==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-939b8a5584eso195551885a.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 23:40:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxDb86ZymXLxEJgs/0q+8FdberRCcBIfj27Hl2IAvN9y5FbC+ekAN1W3S7WYJ5HXckcuVZshis9VA==@kvack.org
X-Gm-Message-State: AFuF++m+TKQKj3rOk8o5L7f0CXJKh62qHoVXVwXjl30rWAcs3ayd70+3
	ZoHXxL+hHoBj6sxv5K0eDI6/6+i+D7Y/COJMYKSfb5wVsvR34LRr9nKVUruW8quXHs7B5cQKwkX
	+/9ne7qkfXXLO6MPDdCQGiueAsb0CyKo=
X-Received: by 2002:a05:620a:9502:b0:939:6de8:43d8 with SMTP id
 af79cd13be357-9398048ebcdmr2825220685a.44.1788936020200; Tue, 08 Sep 2026
 23:40:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260907042447.2450663-1-ridong.chen@linux.dev> <20260907042447.2450663-2-ridong.chen@linux.dev>
In-Reply-To: <20260907042447.2450663-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 9 Sep 2026 14:40:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zT0HcbkQjdPFPBeaqbGcYp4WE6sghDzz=0evhhupCs3g@mail.gmail.com>
X-Gm-Features: AcwNN1XF81pARNfV8NupKBE8bmsecrn-XPHu6HZ3n4QG9cW4OnnnSsqVFmMC4Qw
Message-ID: <CAGsJ_4zT0HcbkQjdPFPBeaqbGcYp4WE6sghDzz=0evhhupCs3g@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] mm/mglru: add tracepoint for folio isolation
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jbc5gi7tttbo8e5bptkgbz67jgc4z4rd
X-Rspam-User: 
X-Rspamd-Queue-Id: E2744A0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1788936021-751254
X-HE-Meta: U2FsdGVkX1/Q7/8tnW8MCBoyYtFXpiMOilkJIDQLKDUgdmkiGZ/j+YKZytn+4yYqGj1uWPpnDfHC8HiOgOqB/NLZD7oCpTxRrZnZhdiLKWt2GfcMLt3IMWA5RIhBjnNmpmp0bf5QmUi5LFn0JwzpFRCgfZFfUjr4wMhNsCFOg5OdCVMtk2AKyuC6hWRuU65gImYvneTgUuXLbn4Kv0lkIFLoMphPZpWvVADb2XJ7dtPoNfhNRjKRkw6k0LzlNqT0Qv+PTomCRYdc9VdREypxwO/HeB182sNprxJO6FG03daBg9n6epHDykFSxAd5tn/Myk859dCvPAAG90I7Bq5vzk4sDHTLYJCOpw++sq3pzGyUFQXbk0pKMqtuoIjydrga9H0u2QOtrcVfZ3ZzkRk5Xwko+JLK1zOK8vb3khHoG8sRRu7uOFZgEzS0g/kv+tbNhb+RQf8FClDU/dsGRxIxXLWtRFPBj1PBE9ph0ROwfl8uxzY5Re5vqZP75Q4Ymn+uQ4/DHaIp1V/Se9JVrYtjK6pXRQlnBSwax8HjHRgfJuJlfSLlTnFhqcQ/CpKyTXakE3u+fj4e5YW8BgC7n7CTSSrrZksrP84pdoTbyWK8zBjjvXEbw4KiVzCMjPUuKZ7WQEcjYKx569/7fFtDw4BBNnjtbRPyypuh5Ee1bJb8IrBOwfsC/2SBpm8YqHw3ut7Xu1TuVaCglbX/PZ/KlfoxiiwXiV50MJn5dDJ+j0+4WU8JS8xwPWXWI/OeKPBoMU1APCn+OistF5nyrIYJL2/r1oXGGKFOSxPXtp6X953GqoST1U39NOT7oKbY4pPeTNMhGx8Kly8lAhEP99KHscY2y0G+U36oUQDWOmnd0/czefoiKcOAsx63pz1ouBPezl5yWH41xCJahiFgVeOOUsnYdP2/wi2hTIGM7Eh8T6WNFJYp75eHtHKsRMc4otUJ3+L2VIkwQnetkxipuqEUs8f
 6PtVKeJD
 GwanbWZqhDpMzoCUe65ICNUQCwc+j5eMuXCusM8IEehrQyRNJU72wlpJ8PSrewcrtmmdjR9Hx+Ht34VvTVCgJ/+6WVL6BVrTXY01aOg6kAmfrE8JVu9+MSOPoWa7BW/GR0eT97T6CkhDp1vehd1cz/wm7eO7mIC74NxypB5qcCmMUs+xCx/MUsx0H7NXGhSDGasHEUZRj5tWmsyg1QpNpUfk3Xc1C/2aB3cYnn4MgUSG4jPeuxWnnSHGcBi34IJ61XEfkCPysVcoAWPAC0wPOy+p5jLEP7Euigmz3sMuwKGC4nMwI2CEiQC11GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 12:25=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> MGLRU's scan_folios() and evict_folios() emit the classic-LRU
> tracepoints trace_mm_vmscan_lru_isolate() and
> trace_mm_vmscan_lru_shrink_inactive(). Those predate MGLRU and are
> indistinguishable from the classic-LRU path: they carry no generation,
> sequence, memcg or swappiness context, so a trace of an MGLRU run cannot
> tell which memcg a given scan/evict belongs to, nor how far reclaim has
> progressed through the generations.
>
> Add mm_mglru_isolate_folios, emitted once per isolate_folios() call with
> the memcg id, the type actually scanned, the effective swappiness, the
> scanned/isolated counts, and the anon/file min_seq and max_seq. The
> min_seq/max_seq triplet ties each isolation to the generation layout it
> ran against, which the classic-LRU tracepoints cannot express.
>
> This is emitted at the isolate_folios() layer, which is MGLRU-specific
> and has no classic-LRU counterpart, so it neither changes nor duplicates
> the existing scan/evict tracepoints.
>

I have no objection to MGLRU having some tracepoints. However, one
major concern is that the code is changing rapidly, so the tracepoints
may not be stable. We would need to maintain them as the code evolves.

> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/trace/events/vmscan.h | 47 +++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                   |  9 ++++++-
>  2 files changed, 55 insertions(+), 1 deletion(-)
>
[...]
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8409ea4bbf37..771fe6827939 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
[...]
> @@ -4876,6 +4877,12 @@ static int isolate_folios(unsigned long nr_to_scan=
, struct lruvec *lruvec,
>                 goto retry;
>         }
>
> +done:
> +       trace_mm_mglru_isolate_folios(mem_cgroup_id(lruvec_memcg(lruvec))=
,
> +                                     type, swappiness, total_scanned, *i=
solated,
> +                                     lrugen->min_seq[LRU_GEN_ANON],
> +                                     lrugen->min_seq[LRU_GEN_FILE],
> +                                     lrugen->max_seq);

Maybe `scan_folios()` would be a better place for this, as it can more
directly reflect what we're doing for each type.


>         return total_scanned;
>  }
>

Best Regards
Barry

