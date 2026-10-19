Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4103CCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFC556B025D; Mon, 19 Oct 2026 09:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DAA6B025E; Mon, 19 Oct 2026 09:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29946B025F; Mon, 19 Oct 2026 09:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF2B6B025D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:37:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13BC21C3FE7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:37:55 +0000 (UTC)
X-FDA: 85339478910.11.1EAED23
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf19.hostedemail.com (Postfix) with ESMTP id E439E1A0006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:37:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IwouMnhI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792417073;
	b=6k/Bnyx/Am1S/USCuxmx8FyLvsZOl2uP9uyhBHrTCJ40vIA7+MsQyTFlL0mlTSTVvPX363
	Xw4r5ZMS2bbYNPeckGMPi7oeyH2p/5efTx2ro8ckRvlOfnYD49Yko4SH1do41uhkzk+xz/
	oE/lwDKFDPPzlZqMvs/0VSb1eK0Qnvk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IwouMnhI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792417073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wk/L+CiGgNrpNtoLYjDLvtAPgSr8HQ4tlkfHoLuLjPk=;
	b=BsPq98NOQskVsctxrhyICmqTb6uzJ1SHFgibkaYORQXYDbsNBWOLaBTBX1zeqaQnj2Ic/j
	FYG199/1fDVqXLU1On3HQVCs8JMWBw9gGKbp/BZAJ/yrND0fl5SPnGSNGZwYdfNAaATF2O
	THj4VlECpt1ifX8DekyRBlWMw77kURI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=65IJJFbhths20avgZNJD2q94gK8PBA8MJtV9YGwO3DA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792417071; v=1; x=1793021871;
 b=IwouMnhIvsMfHWhsHXue94krguhPeVLrmzGYjJyBT2cWHCjJeZbj/E5oGSdcME3NYL4RzWwg
 eEHBExmPatj0OQT2KeVdPtYzc0zOU1FM7Z7qane7XElA8QJtbKqzWB0zHCSjt4qWGEIQsH9AHtS
 vlC0EZSvazGVr/sXKA9OJc28=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 78fcc01bb5219cf8;
	Mon, 19 Oct 2026 13:37:51 +0000
X-Mizu-Trace-ID: 78fcc01bb5219cf8
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] MAINTAINERS: add an entry for MEMORY MANAGEMENT - MEMORY MAP
Date: Mon, 19 Oct 2026 21:37:32 +0800
Message-Id: <E0A71C12-C69D-46D5-8F9E-3DEF4097424D@linux.dev>
References: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>
In-Reply-To: <20261019-memmap-maint-v1-1-80850871d0cc@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: iPad Mail (24A446)
X-Rspamd-Queue-Id: E439E1A0006
X-Stat-Signature: dwwqm8khjs75j4cthtkob6qgwg8ote81
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792417072-594884
X-HE-Meta: U2FsdGVkX18SswlWcWeX24dqTvhkpB2eh7w9qVs2mA96otKHTrKnH73KOtiQpixST08BckqMVEnlebA2pm1nBCl5VzUlHz81+qvzLFm8uaOVftU7JOmdSjiMi2uRBZ9wslXssGbI4tNp9Hts3u3Tohz5XjCyfpRwW4qV7/gAQtRdXnZKhlQrBcBa6n/gtoD/Kt+dPRlFi0gI6jYGCmCXe+7RrVRKOssxKqDB98WjinjRcwzL6EovdeKQP9ujNNo/+VhBK1oyADnhVUBHlN79hQLMZzPenbZZTt7dac0ypejYaijsH48QfDei3IAxAMniO8HqCco6pwuruO7cHxl31ISNa5N2zSz7xSEmUHTGaQaZ+aoeBCNUnxfr7crl0ssrpWDSLy52k+qfGicv6WZR/pFOiV78GYbtoELfrDcxfrHxUi19+G+TQza09s7f03qkkEgnURheG6YYm8THAOE+CSdeOUBMnYGWrULVPJMaGPZbNbOPLTcnLGUbttG6tVXhVbae7szV91H04toqQkC79Jh6NirgZ0hFpH3Ivu3QEf89WecCO1q55Rg39VnY+fn793VvUskmOsPR38m12wWVRYBPGfxjrHdpJlNf9/DjsI51tJplhhoBR1F7kIE9zR9DEY5c9TXq8EttXa7TftPRJ0Nw1oB7YjbZO/q/tBYKxvb1jy+wHerUqbIN5lpEN2J25ig5tAf4d4/YOYdKYAQnBB4mI3zxt5UIDkNL31soZIZUWiYO8VWvQbnocuxxRePmOudP3vE8vu0TvbdIToQ60DjWHCKJo+JeYBPeU5dU+9LahOMiUKlbbVUD+wmXaCXhcwe0dsY6si08gVcWQXXWo/IvdayWPKV6SfpmMJXkBhkoZ4lQautfTJdJFFjE2pD9buUn/rlXL004UWgONcmbY4sRx8P9nNWF/XTeIuoChCUJlF1+3oT0lldECoQgWGIYiK8+inNzKOQ1b9t2hko
 nB2qUF6v
 aXWlDpRQyFBeEvO7I6qMYO4YihWtw57+kdoonlWoyrQqarvh2tuNNbB+5a2V0wHfAcBnMw67iRPOpt9lD73s1QIJApqQiGKzSueacl9ThJP2dDK8D8FymD79OYFK88c1ooyOWfKinV+HRNWNUxd1BYAMxhzzu3PvS8c+JMot3JoZ/DwRlrHgdnnupfBh79RTiJ00lLxFIQRAGtAheFAjA69YtiIsx6le8pupslomXbWJ5YAxnqjHk6ZTKxICfVjr0+32pg1TjGha0AzY140q0obvAC433tdTYkJCeWrwT7zoj5oea4yZYj/NB5SpWbpCrJsEN2GE2gBL+LXlOS0NX7aG3cn3I+245+myBrSq+Xo07YUd0qAkzqRCvX24PmK2V3O43uvLsrIMoY50Y6VljpdoQ3qTye3p2dlS4P+b8nlkK2eElkHjMgmakpdqnayhAh2iP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 19, 2026, at 19:34, Mike Rapoport (Microsoft) <rppt@kernel.org> wro=
te:
>=20
> =EF=BB=BFSplit out files related to SPARSE and SPARSE_VMEMMAP management f=
rom
> MEMORY MANAGEMENT - CORE into a dedicated entry.
>=20
> Also include architecture specific sparsemem.h headers, pfn_to_page() and
> page_to_pfn() conversions and Documentation/mm/memory-model.rst.
>=20
> Muchun, who did a lot of work cleaning up SPARSE_VMEMMAP and extending
> vmemmap optimization, volunteered to help with the maintenance.

Thanks for your trust. Happy to help maintain this.

>=20
> David and I will continue to look after that part of the mm subsystem.
>=20
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

> ---
> MAINTAINERS | 18 +++++++++++++++---
> 1 file changed, 15 insertions(+), 3 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f53047aa8d3c..b468ecdf8c65 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17161,9 +17161,6 @@ F:    mm/mmzone.c
> F:    mm/pagewalk.c
> F:    mm/pgtable-generic.c
> F:    mm/ptdump.c
> -F:    mm/sparse-vmemmap.c
> -F:    mm/sparse.c
> -F:    mm/sparse.h
> F:    mm/util.c
> F:    mm/vmpressure.c
> F:    mm/vmstat.c
> @@ -17210,6 +17207,21 @@ F:    include/trace/events/ksm.h
> F:    mm/ksm.c
> F:    mm/mm_slot.h
>=20
> +MEMORY MANAGEMENT - MEMORY MAP
> +M:    Muchun Song <muchun.song@linux.dev>
> +M:    Mike Rapoport <rppt@kernel.org>
> +M:    David Hildenbrand <david@kernel.org>
> +L:    linux-mm@kvack.org
> +S:    Maintained
> +T:    git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git memma=
p
> +F:    Documentation/mm/memory-model.rst
> +F:    arch/*/include/asm/sparsemem.h
> +F:    include/asm-generic/memory_model.h
> +F:    mm/sparse-vmemmap.c
> +F:    mm/sparse.c
> +F:    mm/sparse.h
> +K:    (?i:vmemmap)
> +
> MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> M:    Andrew Morton <akpm@linux-foundation.org>
> R:    Kairui Song <kasong@tencent.com>
>=20
> ---
> base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> change-id: 20261019-memmap-maint-72fec54e6752
>=20
> --
> Sincerely yours,
> Mike.
>=20

