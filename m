Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B32CD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 05:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3386B0088; Tue, 23 Jun 2026 01:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64726B008A; Tue, 23 Jun 2026 01:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952AD6B008C; Tue, 23 Jun 2026 01:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6923D6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:11:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D14EB12039E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:11:17 +0000 (UTC)
X-FDA: 84910003794.27.96FFC27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id ED0A118000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:11:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+kehgXJ;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782191476;
	b=NulpzyxIShdteNsDXRKZUimlzNN8X01BqKRO/2zmev7gHpGzoFa9YqgowxpxBbaSeI/B3G
	bqL9OizltQ8+wE26xhSe8n9yB6GaE+e3ApfLLgULVg0myTKdqmkxbPBqNNnqzWPyz5For1
	cF1K9ztAv6mIwIcuY4cht99XKK4Srhc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782191476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5Sf1Z9xRL9LWcd2ZET1VjKqMFRzCniZR0mElMq/Kvc=;
	b=l84HjABaxwPNWYkmBisgrEGyDNkt8MymBmlohhdUYi4rZhY8jsQISrADK1OIaryFFGqltl
	PwtmY5ZLKwpJtJNoaxZH7o526nuMAdY0hr9fBM9yBkcPbqV3ptBPK4OFfX2L3Z3e/wJ1Gc
	4gmow3/fgWOfeXiZZG0ryZUlXL0pYmU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+kehgXJ;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC3A644129
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9FB1F00A3E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782191474;
	bh=q5Sf1Z9xRL9LWcd2ZET1VjKqMFRzCniZR0mElMq/Kvc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m+kehgXJ7IJ9wyrAyKxGHr8VzJe07qU/W8OBvjpMn/5iEYqb/+5sfphIj3lZS702Y
	 hiGkYLpSsPCndvRe6S8QWWieAf3MLKGo+JvP6M5nIfz1p1BepTYGAptEVwJZ5PxIeP
	 dtHkl8kcPP9tzWpK0FL6XP1p6hMwCsikohm8IWVxrXr6uxzrMqEwOsbDlR81Ef9cLF
	 5BWf8DM7KZs66eDqzxX6aj4QM6+mQq1eR7/Sb+VNDoolkty8odjYiGXmw5fokKorCL
	 k0CWqjXiRcUCWugG8id9MEGY/MoM1Tw8o5TCTKAEtTLQxlBfr2kVHQld8BKG2aY0QV
	 0nM5lDNwTusVA==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92213351918so339958185a.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:11:14 -0700 (PDT)
X-Gm-Message-State: AOJu0YzEkpG83v6uoyrVITj320c+d2+etETqcFX9jWrMTr8GFwA2Y4bq
	9bIuoY8sGxeUqv+S0MGY3IRTgcEh+REqJbgs0pd6LtZk7QUN7LCllPfgK2qhyXNIPAutqZGoxPs
	T4vs6ZZWPtIgYVQ3Q8P1uL3cO/3QPcfk=
X-Received: by 2002:a05:620a:261a:b0:911:9a7a:8076 with SMTP id
 af79cd13be357-9266b97e8eamr160228885a.8.1782191474145; Mon, 22 Jun 2026
 22:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781843449.git.ritesh.list@gmail.com> <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com>
In-Reply-To: <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 23 Jun 2026 13:11:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yTY8g3M7qmpM7HeUq=E05e7v_QFTzk=2D5Mv3Vj3Usqg@mail.gmail.com>
X-Gm-Features: AVVi8CebkszW_dJseo4N-w7zaazQK_GJnKVeR7lxEzBiOpulB3NIjYM7MC4L4Kw
Message-ID: <CAGsJ_4yTY8g3M7qmpM7HeUq=E05e7v_QFTzk=2D5Mv3Vj3Usqg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS
 via ARCH_MAX_PMD_ORDER
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ED0A118000A
X-Rspam-User: 
X-Stat-Signature: u7bndaufkjosnetxyixz5tzgqf68tzix
X-HE-Tag: 1782191475-565798
X-HE-Meta: U2FsdGVkX19twVj+cj6/FicudLNgtCClZL3n1D9t2b8T/e8GgiiFOq1p0R43/Iq/CJTmFmYyW32y2UXo07luT2NfGYoM7GNyhydH9TC0GrHIGWWUlp9fjHCxDr3Ex6II/OamPl8fGZrlY6TFu1gJEE9doKh0kwxeFu3j9kNEc78xWXs8jrLL6DTzfJzH9B24WlHvbPw/ffZFMpZ7olqyw73H6RMSbpUdWBrCJXfW4F+aCIxSSNLbf6I911fa3MhlF/Xlr9bowOli2HmsNITXZdD1hif+Op62yjl8324msMdKfWWpAkoXWCe+JqJfMi0LgOa82KF30GyoOdlZF141jBaKxgWPwp8Cx1WjDZmdAANcF/XOruYn9GF22IH+lMX+vHXKtRmKu26QRONXEY3gw0dxIVB5HkVJABWAii8k6nipKq2WyX/icgrFFQqCNsTrxEJuoaUpgfjw5A7EHapAAsN+dm4p+bPt5UcI6Dbw5Dd5yX5hmgew1wx3VIUFaTI63H7uv8M00FPrncnoOZQGdsxn42W1Z+H+Sb9GeZHdsJLtejS3n5Eo20Rtqj/33ywUwbAl/7oE+dCBuzKr2hQimXf3wRx8ajtD4PeOAlK3H+HG0Povlb7bMJxcrweFS0ogVxRFhFbm5TOqG/q0V6P788iODm3KNrikZowzkpLk8jLvAfE3ruacE+LK5N5XyseLlp9GcAlSioRo2IfQKYaDdfOCoYNFjuVo9dAGklBjnh9be8yLbNTRGpOnnj5cTKQZfBW1MMnkDRu7YZRXvN4qlxSTfrQLgpX9T0mj6Cefkd0WAHEJWoj3edqOYSJUmgXqW/Vr99Whb0yckaAwCCaUDJFkY7hQPzDeWWJxeitG6R80tePhHI4rKFbxScpIQbtsjBBEMMUCTLEKtJAKluXCCIFGteNpLrL11d2MJttmgV8VoXncJPq/JJ6LVBgeznLd0LfLw2GVBQbZQs9YB/a
 iH7r1CsE
 nLr8vXE+npnAbnNIfYsZqRxOepWAlavRiQCWjqB+zE66lX8I0tZ26MsDMI5LMVWSOopyXI2QPzaPbzY7TUFNS64nRyh1GYg1YvVSCi1hOATpMKV4IWdY+X55MpmJyl0j/4Gu8ZxrbQedefOJGZ0pZ4j1ZMQutvvkhYfSdi/sGqlw8kDoZLohxvSpJYANJzPuV+honYGnP9GSnzvTg4Amy6RvAnhEzXmmXjaHI83XW96f4S7lNPMDfUsRZN1iKlAhcZTHOBjrKIKZERpReJlEzJU0+6HqmUogqYf++Gnguf8LyK+v11rgFBVlflQefvHI4Nr9a8tGEOhdYeS7Yp/LwV6+dA3kmWHSTSSSV6nLy8Xk75rQWjy5eiBWxd5MJSQ6EHFK66zevEVGe+7FHN4mb+3uXJliF0pbi8Zxi7/F7zEKbIUByO4YZ+v8qd+SOH5LaUe1F4BMgHnCz66jVisMVUdm0tx0u+3sCKjdw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:41=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> SWAP_NR_ORDERS sizes a few small bounded arrays inside THP swap
> allocator code (nofull/frag cluster lists, percpu_swap_cluster's
> si/offset arrays, next array for rotational device). This currently
> expands to PMD_ORDER+1, which only works when PMD_ORDER is a compile
> time constant.
>
> However on architecture like PowerPC Book3S64, PMD_ORDER is a runtime
> variable which depends upon which MMU is selected (Radix / Hash), so in
> that case, PMD_ORDER cannot be used to size the static arrays.
>
> This patch provides an optional ARCH_MAX_PMD_ORDER (upper-bound)
> override for such architectures. The memory overhead on enabling this
> override is negligible. Even if we make SWAP_NR_ORDERS runtime alloc,
> default slab padding could cause some memory waste. Also we lose the
> per-cpu cacheline benefits (for percpu_swap_cluster) because it might
> cost an extra cacheline indirection overhead in swap_alloc_fast() for
> fetching si[order]/offset[order]. Note that a fully runtime
> SWAP_NR_ORDERS was considered in previous version but was dropped for
> this reason [1]

Do we know the maximum PMD size? On arm64 with a 64 KB base page,
a PMD can be as large as 512 MB:
https://docs.kernel.org/arch/arm64/hugetlbpage.html

One concern we have is that performing I/O on such a large folio could
incur significant latency before reclaiming any memory. For this
reason, on arm64 we initially enabled THP_SWAPOUT only for 4 KB base
pages:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dd0637c505f

>
> [1]: https://lore.kernel.org/linuxppc-dev/pl1zdksc.ritesh.list@gmail.com/
>

Best Regards
Barry

