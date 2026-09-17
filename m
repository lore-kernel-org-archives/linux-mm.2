Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE4EC982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404D46B008C; Thu, 17 Sep 2026 19:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC126B0092; Thu, 17 Sep 2026 19:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BAD6B0096; Thu, 17 Sep 2026 19:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C00C6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:28:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CAB6C04CF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:28:32 +0000 (UTC)
X-FDA: 85224845664.16.36B4724
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 775DC80006
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:28:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMRG6GJ+;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789687710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWJGRC9xwxNiRy963FgpQnyOwKOSfdYPf5s+6GKenIQ=;
	b=BiebZ7uk649AcyEQdxrBNQNW69CiL0dF3ZCVG+bmvDdjKZGoliwN/AHo7EoCnVOzIjHyRD
	ipwaKswfnjSVFwhCWfv/9KQdWQMhS/1lzjXeATFj8scU++ObaP+ls/yPDwpAP1pe+wPpDJ
	6FM2xhJT700oA0wAncjQpRi6txK7TqE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMRG6GJ+;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789687710;
	b=Mg4QvgST/RVKEI06LM7MjjXDKo8W8WeNnMLDJiL8fukf9P7k5jezZpnTIKmFsjND6LFiYX
	lIjpZqBtpuK/UkXwst696Wqzb2uisNuj66TWHucBI6d0OD2uMQ2de78ohy+7FhdILUalf5
	JWjjzefMBaFg0WKRBVEi0On6muJyi9Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 760E644049
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:28:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD9E1F008BC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789687709;
	bh=IWJGRC9xwxNiRy963FgpQnyOwKOSfdYPf5s+6GKenIQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jMRG6GJ+jPVZWQcib59ikf8sCh9LM7ZZPeIKXq2t1Qa616NOpa2A9yZE8zyfkQsNp
	 XDywILAj2dBZCJHat9rjUD9SXiyT+FIR/P9rULMIOVe6G7mThYpyxf/+gwakDJDQ0p
	 JX+pek5ZzlealjcCSM5DFo3m1D7sEjNa0T+wq8ngURIp9C5stDPdLxz2oxFn+dftXx
	 wj0/JQU+Tdox291aHVZBLSA+nZPmtbE9wAtJqIrz+LX0DcIZUZqN7dHtBM74cZwTAl
	 YOE6AvLK3Mngyu68jQSlXiPocReBiKW2XwB/no1ZLubp2CR+4ZLiALYzxrr1ZKXypZ
	 +lcif3Qk/CfWA==
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530de452c33so1203091cf.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:28:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxIgNy9OhFWBFCU+0QI+/W+il//0cRsYEKT6WwAgz4QVA3ePxa6ho/rX83TrRzpr6JKZ/FDAIwjjg==@kvack.org
X-Gm-Message-State: AFuF++kAhpTdGovTArJgQTwwerjf6S8d2hBGmqDP8PzbYqaCkD667rFR
	V9JLhKRMKhiWrjNcB5dEO4IJKB1MsGlmLsaGSLxQh3IAyIzrMQfV3rLTPfNA87b2VTlEgTNqEaq
	leoc4vA+CXM+uU3B5KqGgepnLgiqOzL0=
X-Received: by 2002:a05:620a:280b:b0:93b:d79e:1907 with SMTP id
 af79cd13be357-93bdc9fdcc8mr86080885a.74.1789687708536; Thu, 17 Sep 2026
 16:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com> <20260917052933.188679-3-jiangwenxiaomi@gmail.com>
In-Reply-To: <20260917052933.188679-3-jiangwenxiaomi@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 18 Sep 2026 07:28:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wDbDLv5mxfNiyraOS6tKCSV+g8xL5+SsRCyqLnN2ON7A@mail.gmail.com>
X-Gm-Features: AcwNN1W3AgFfdfDDbqU2CtZG2lqgv5Z_JbQps_-ItFYT5oYqTIYjvyQ2wpW_oIg
Message-ID: <CAGsJ_4wDbDLv5mxfNiyraOS6tKCSV+g8xL5+SsRCyqLnN2ON7A@mail.gmail.com>
Subject: Re: [PATCH v8 02/10] powerpc/8xx: add pte_set_huge()
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, chleroy@kernel.org, 
	david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 775DC80006
X-Stat-Signature: b7mzrp9n8tk8kzkuahwq1winuhb8phzg
X-Rspam-User: 
X-HE-Tag: 1789687710-153004
X-HE-Meta: U2FsdGVkX18uYcSxgvXQaF5WKvlmwRQNk0xKEH3MF/ZHvucoWzjSFXKFDQVVi59oT1zrVgcwakcX+88udH/bWL0+FpEJLi6M9nmhKDvNpQOY6WPzIQjHHpzGYRzF1n9klkLOgaKgRZY3EkePKXMidxyXDGXiy/a9u8Js/tc6MQcQw+o0rsgt5Y+k1wvpIuZ8blnfKVqdMoNYY70aWBZC7UVrBtN7fojUeMcW0HFYcgKFClzKp8suO29isC6x1jUNlIJYwU4j4C5/iZD3uvVCCzS5LwgIPcrpdrowcgFiCmUx8ZDABVbYv3F/PHL8gjdFQc3BNQVs4SqdHaToJUc6hQfPvo+3ZN3CXxLsyKkdMvnm3nqWB5om7rrZ8FKlVy0KKYDChRwEmWTpBDu/pPEO788Cjg2MblmolU0ovNwkBYrkqhRzkc5InS+6MZTb0FFFvxhBXxVE7aIQdeMzD1p5prAp8VjMN6vW1InhbPXXq+kJOtvJIq5oqaIUjVr/t2dHmoT+Bj8pNNjg2O1DtzHmxitIOv0lk2SCGhRpDHkdAO9wrYRgc1//3TyQEV5Ic7YMuZRstHWrgNsWux7Y6Cg2sPHMeOFT1bRhAtg3T8VHurhoYpdrgbvZ2QXa1siWSiw4NlEF5X6kcRpTT4NN+Gd7JH2D5WIOUtWLJUfLKEVTgVsi/vBpd6pxWK5gStSRqSjsUOq6khkBSgzNw2BqWuQmpvr/11K+HbP343sdulDcNTlFOIjlm2ZIzJmznUWi6aL9lc3QW+bLRKP/hbgWsg4DRmutleebFAZhL11bQCKoOqmYY7xgCNoWHQv1JYEtXN3rbjkvHWo9lwu1wTgPRZHFsNTW443w1kcZWXsmG0/dFAbmHp7Wg0VholcUynx9Oc8uzAeIe6bR9NIBKg/kC/Hb1bfxacykbkSanfP81mc4gqgpt4GqR1jk5HtJ7aF1UKYxDLfQxodbST2AOOAg5BD
 r3lLLbSf
 9SsLZMhRqUDTTV+BdTPJstp5FNQjam9GrHISpXsaVTJXgcARPjeyWtHiKuilffrEX+a328I9uG6Hfe4YfDV4K87hk36ppksZXegYDTAT1pRUJV8vEq1cr0NkLdiVN7cscZjBtqZBC3j+beSCvW5lD0W9ald4G1ypu1Tb+R8RjYPrajSWLzDYrwG72SXWSpQyZorYvNPVB7pA1Qm9slhLCFnOgdKwlLY91A7VF+4me6v3c8ClKBTb9C7s3+eoup736ohMDhkq4Vrei2EAGLXvVJEXNn/KaN5K3gOmmoP577Bly3duTgwk6r6WtHCuDphxZpNxuHIJF9k138jpZ3ZdhLAFZT89np55OfiPmbrgSnS3csfh26pfcK60l462j3BCgtgf6/Xa2xY/Xzg+oCJr9KzC0msrUki26ZA9soxZpqTqGCuIkzm3rTn2ZbtpHHXbw0GwTwoBNDThbEjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 1:30=E2=80=AFPM Wen Jiang <jiangwenxiaomi@gmail.com=
> wrote:
>
> From: Wen Jiang <jiangwen6@xiaomi.com>
>
> vmap installs PTE-level block mappings (SZ_16K/SZ_512K on powerpc/8xx)
> by reusing set_huge_pte_at(), a HugeTLB helper gated by
> CONFIG_HUGETLB_PAGE. This makes the feature silently unavailable on
> CONFIG_HUGETLB_PAGE=3Dn kernels and couples mm/vmalloc.c to HugeTLB
> internals it does not otherwise need.
>
> Add pte_set_huge() to powerpc/8xx, next to the existing
> pmd_clear_huge()/pud_clear_huge() in mm/nohash/8xx.c. It builds the huge
> PTE and writes it into the backing cells directly, without going through
> set_huge_pte_at(), so it does not depend on CONFIG_HUGETLB_PAGE.
>
> No pte_clear_huge() is needed: 8xx does not implement
> arch_vmap_pte_range_unmap_size(), so the vmap unmap path never takes the
> block-mapping branch.

I assume you mean the block-unmapping (or PTE-clearing) branch.
Please make this clear in the changelog.

>
> In practice PPC_8xx selects HUGETLBFS unconditionally, so
> CONFIG_HUGETLB_PAGE=3Dn does not occur there today; this is a decoupling
> cleanup rather than a new configuration.
>
> There is no caller yet: mm/vmalloc.c is converted later in this series,
> once the generic fallbacks are in place.
>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> ---

BTW, this patch applies cleanly to the mm-new branch.

Best Regards
Barry

