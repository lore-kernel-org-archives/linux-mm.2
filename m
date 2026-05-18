Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518C3CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F926B0005; Mon, 18 May 2026 14:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9571A6B0088; Mon, 18 May 2026 14:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8470F6B0095; Mon, 18 May 2026 14:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7756B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:12:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1599BC324F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:12:16 +0000 (UTC)
X-FDA: 84781335072.29.06EDDDF
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1A68A2000C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:12:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cjRX8A6z;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779127934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZHpu577JJ1NeIVxaJiVGE/6LzdYayI5qTGrF3i8FQs=;
	b=UUjdpssPT/GitUeTqXrLxmibVNV2AXpt9CYwcZIoZD9DshXOW8cmo4kRfbF6rZKReYvCM7
	kfRVXTPE1L26Sc+KgrVQZ/4j/Qw8ZKDyBnbdyu211K/kmp3nA+8JLsQ1TG7m5dacH2p0gN
	8Ky40V+VH8SfqqzkVGA43kx9BZ040mE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cjRX8A6z;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779127934; a=rsa-sha256;
	cv=pass;
	b=AhrqdlERwZtgnBhVZyVw78AfPYX2FoXU4xLBvvwcQG3N+sL3ugWp/J7Bj1m/o6rsTdmM/D
	QL6EpIsEPWSrBmKAtZzaZE/2pwLb07FpFePMobe2m7/QHxKgYx0zbFiuCF2+36sSVr3FmA
	JZ+N29C4MjkOwnWGCJux4neq/HTgIAk=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bd22b2abaa4so461055166b.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:12:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779127932; cv=none;
        d=google.com; s=arc-20240605;
        b=bWuqI6/Aqd1NkjBB8g4Mjo4MI9YAoD0eRuXCoyuYoKshZjjatquipCKnmo1cZ7oWBY
         AkAL2tfVCWNZcZPqMpA4lpq/0Ls6CUXkzfuM7vmDfQtr7lZG7CGm1w0WCprE4EDQzIs7
         hiIYhECJkITreXQmk/Q3woSyT92GDCx+O0gJrcvpNIzCTKXIa1pFI78rD8puGPjw3ABO
         6YTP7pnKh4q0nJKGMCCD/Z2slovwUK3IqgygKGhtcca1iVTOO52+w3TL08rm2XaBXN6K
         WYXOQWnJTeCPiNSO/KAuoX3GQvLN8woQiL6utX31NlEydH3/XaPwC5S9pCLyv8RgOZDA
         OCFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KZHpu577JJ1NeIVxaJiVGE/6LzdYayI5qTGrF3i8FQs=;
        fh=F4Cq+uUuHH0iOvzptNHJmsa4AyPsCdkeabnrq+m76Kk=;
        b=QMRq/QlIW2IEMKR8zH1pKb3x+2prGEtDr45/PO1XHCJ309sCMCLRn9BXc0PQRBce5j
         K+20AYwWh9CPCvqj8us1xZ+f+ALyy6Fij5utAwiwXHPE4AGwsKtEXD1eDPAvFcp+X06J
         oDnYt2K/xySSGf6uqH3YeK4vWTzsyVgjk0/OKrHTZsRrapNXcl9MbEOPQGjAtHfGRhFo
         RfZ5+9wNh/JXM9gcuho9XU4lSlXz/B4szAnZc1idYZjZ9n7RkIyj/QAxYptsljzBf883
         pYwZ4YI7dcMGpHKKwTiI8+gteZEU7BlF4ZiNJMQa3DukhnXWv2+EbHKQ3ip3+IIcUV6T
         R9cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779127932; x=1779732732; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZHpu577JJ1NeIVxaJiVGE/6LzdYayI5qTGrF3i8FQs=;
        b=cjRX8A6zhffELlvWso2XIEEwgFNlJczTngOL6NO/JsbydUWAAjhcTYWHt/jxHcZo4Z
         PafDLDFqgniA3Ue/xXKVLwBAEj084WnrTML/7eDOmh4mCyGJJzjB72gLhNQALyWKxNoM
         N7Vj7h+ctaq8Ya3azbJo7IGQlyc8SJou+alQAAjKjE3KPT5StVoxQK9u0KdY09kNuZuU
         Uzi0K9HGMJ+f2lJ6JClEdMG3ML17EQmKsT8dMcajybDQKX8061FuzbpOyv6r2ssJx8H+
         pI5u+t0y6H+MSkUalUixGNxng4tcbSN5mz/CXQflMSTRNxVU6GrvZ5SP93DxP3xzRiA6
         yX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779127932; x=1779732732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KZHpu577JJ1NeIVxaJiVGE/6LzdYayI5qTGrF3i8FQs=;
        b=D2CONRSzsi18xsnYxXEJqqNdzm1f+3wBVqBTDiHZcjWMRHS4T85Qu9MzdGPHsPqO9k
         1AFMdJqvQdclDKauRrPJIIlyaVCQB7TAIiXt8ldacx5Upj0qp5r1Mjk3BqjNBuxLfzw7
         oxwPQV+gA3IeUTMhx4BwSFf34qoh5brVMAlzb0poEiB5mzKHof4X4J6cc7nMQ4gwVsln
         PmK+0RcgOF1VXtzSpSniA+A+vkfIJF2HMLh2TYJg+Uj7HTGUFR77k0vzaltS0i0WrgMW
         BErd+ypExdl9n2XBnW1ihOmXdUBcS9B8vo+8A/0p571o9uGEIORPg6rovcMEGoaVUz8y
         0yzg==
X-Gm-Message-State: AOJu0YyXFt3RUk+7/w/5KiUEGL4GCA/oCY2fb1KtwWXqfgIbl4g5LNQ0
	idD+7qIlRKsqrD6fdRPDy7SyVx9/o475T5NfSnOmDb1YsHMKGFzv8R2qi6jEz9naAtZzSjU3gQM
	sJ3sf1QfArbq46XSwilrT0oY7PIPY34M=
X-Gm-Gg: Acq92OGyR2rWgmyrvDEz9d8CSBOKMIvscnjZlMP1z2ag25v6PUbeIRhEGHVNJZSEYlc
	oGRlS9jn2ChknV++NrYk2SvYgXvNBBW46I65ZrV+Nxde4jJOdyAx8jEG9uEsRHq3I6c+A7HxQlp
	WYdUN09y7m2QPSavmqnzlS+rHzZwomwIshAWKu9Bgpp60/1+bBTCXmaUL4JC3DUnohZvy+N+kWc
	XxnVlyJVj1eNKmKVbGegdg6wxFz1GL2aobqGsikujUGgL41FTl61ndsxQcpt5Cx86W4BgoE97Sa
	IF6t0lt83gR8yn4sxy4YIn5pDz257aGYEMJUVmej
X-Received: by 2002:a17:907:3ea1:b0:bd4:8b66:334f with SMTP id
 a640c23a62f3a-bd517970cf2mr899520566b.33.1779127932053; Mon, 18 May 2026
 11:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
In-Reply-To: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 19 May 2026 02:11:35 +0800
X-Gm-Features: AVHnY4JLUOvMrdWhKo7VoEAUHwrjl00yvvDBzd0qqIXKzU2hB02sehpGkoppkGQ
Message-ID: <CAMgjq7DryNOmJbJ38tiwFadVT3oaMTTtQ3=BxD70s5AVjG8pbw@mail.gmail.com>
Subject: Re: [PATCH v5 00/12] mm, swap: swap table phase IV: unify allocation
 and reduce static metadata
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A68A2000C
X-Rspamd-Server: rspam06
X-Stat-Signature: mtnrzp78qzwfai3intrcotedbepcw5cw
X-HE-Tag: 1779127933-481388
X-HE-Meta: U2FsdGVkX1+hw+RBUR2kUeWzEATU96i/t6RpUEIfcD3itdNCa1CltYw5rxqzf+zlTNiIUSyQq1HjGKUh/WuqxGedtHeFjoxFJMIwAJ83OYbnxbVUsT/lTQkr6EQOeAa3ntncKffHP9BMZLY/BeSX4fEOYoq7TLPrJrkNuD8ETHcmJljwuNsg9pJuXT22sgwNL5utLV8JuJiL2XFVMiXu04VlWSvdMXlmwEvYJc6Kd2hG7pMJdG0G+xwST7j+HBtnjN+eMeCPtDbodgJQIoW8XEe4ZZFNO6Mohd3jrIg6JX7BjKxi5YcYV3oSvQ9uPzqWJ1VgVTQPy9v0l8qCKfWJY21LzjPHBWGW1mgCe0IH2GT7CbnYIFpeyEOtjpCbvznY6682rEdQLwyOWAfX58Mn3X2VKvGKssTCJowdyrR1tmWyZcHdopOCXpxXYN9Q35UVNlQ7gOUiu6hXI6uIJaycFa0P4MJbANsad7F0EstGVc1duhRpiHMldW+4/KRk1K0EWgyk9bmk8ohsYf4yKs+lbqFYyKhsHFGosZMsA7dvSCtqBKAZjtWuCwKmPES23pCRQjdAtaEjmyUFgfu2kBOQ/WWOI1umLEaysTDKiwBg1I55FBDiIUp3VYcu8MQX90omDwNDc7eAQnKAfcpZ7ETjKEsfgM4Z5S7fRKl3I082jwCXAlXcTR1ItuwLymxxGxNfvSvq4OokbgqIwNFd20b1F+QnNrE1E977+7R8yXumYkla34Yua3I76gVmpYStPc569RnZTrlI92sn8SgvzZCrxUYE5Y5haoKdwj/RquiMy/oyvXiDHPLLE9ARVJIdWP3XI34JaQfQRRjCFXZuLrHKjKT0j/7Fc6ExlYfmMIIMF9S+MmMwpRGQV2knMNHd90TZaLSiAzvuE/xYI5wMsxBS4cD4cLVH4KtCYfMiw8184a6pKss910WywQUZnwuWTj+2KxlPrOGyGnawaZjUTiT
 7zl6D7x/
 d/6uEVAXx1MOFiq+a3amzpaP5tVKReWg5mbSIRupdRAYKflOmhDgmRKTUYUzQGT42rgWjMUVrwTiyhsnGTUBh9NdtpP0wUDntIY0vIbqkAx0FU063nHbfw3T3F6oJdPHoLYZPe4JE1st62FV/OWMuxZ4ig+LUCkf+25f9KzLi0JukQ6gaxtWxDezE6n92POeyRbRfxO82zR/npaJIzY9QOzQIVIwXveMZz0vxd29uJVVwowFZwnHQl/3JQyg7QxFaMtZT6lsAUhPZWzjKcPI8C2hxFXbFDqQCA4qn8vGLFdndqZI1yYzQKvtpNnyEEPKPgWi+ZlWSYl2+nBJ4ph2IlmLE3yH6A2HkYQWEM7OOyG8TLUjqW/O/mbplezteIq+G8pv6voKVq1xjlHVJdBEeZZ2IoZ3PGFCuYoIKWxhCuTa3d6/AboRDYX+oqg+Fj2Wb37XI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 11:40=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> This series unifies the allocation and charging of anon and shmem swap
> in folios, provides better synchronization, consolidates the metadata
> management, hence dropping the static array and map, and improves the
> performance. The static metadata overhead is now close to zero, and
> workload performance is slightly improved.
>

Sashiko only gave a warning this time (and it's false positive):

> For devices using the swap cache, __swap_cache_add_check() enforces
> uniform zero flags. If the flags are mixed, it rejects the insertion with
> -EBUSY. Could the readahead and swapin fault paths then treat this as a
> transient race and unconditionally retry in an infinite loop, causing a
> kernel livelock?
> For devices that support synchronous IO and bypass the swap cache,
> swap_read_folio_zeromap() detects the mixed status, triggers a warning,
> and returns true without marking the folio uptodate. Would this cause
> do_swap_page() to abort with a SIGBUS?
> Should can_swapin_thp() retain a check to verify the uniformity of the
> zeromap status across the batch before allowing the swapin?

And no we don't need that, __swap_cache_add_check already unifed the
check. There is no device bypassing swap cache now.
swap_cache_alloc_folio now handles the fallback or returns the proper
error code.

