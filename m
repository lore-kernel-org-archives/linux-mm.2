Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2E5CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74E96B011B; Fri, 26 Jun 2026 06:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E267B6B011C; Fri, 26 Jun 2026 06:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15636B011D; Fri, 26 Jun 2026 06:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9AF46B011B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:59:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3666B1A03F6
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:59:36 +0000 (UTC)
X-FDA: 84921767952.07.53EDD1C
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 45DE180008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:59:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fUvQAT/G";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782471574;
	b=6jnTstdgKFfqFuw1+eWKJ+xsxR+IanBBLLvMvj30vn9+TkKwIr2uOMwDuRs0wgQ6Z7WZ/r
	30VZC5pwfjN0WaqT6KajYaptkU2wQv4qbEhmDJELg7eno4U3fvwJ+M5o5gilRtBRJUjOPu
	SGMR59j7DqNvEKDKbQ2vvBi20wfle5A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782471574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5D+Arq0OSsap3F+LvB7ekAuzrcd4vf6SH4pb1GLsatI=;
	b=y0b/sy+9c4kJuaEHu+1+e9p/EIo+Eu1M3KsT+T0IuS8tiKy/iPJGngCmaOmBfHDFGQbw2o
	bm5s6MJ18KfGTLM2cN1AkKAI1PnW4Wb6rglLpXomDXuu1q1msbxeAV7sr0FYjLKFde0doz
	pQ2hMXP9vFCyQ+OvR9TWsMKgIRdxDjk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="fUvQAT/G";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-66490aba02aso1013521d50.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 03:59:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782471573; cv=none;
        d=google.com; s=arc-20260327;
        b=ZkrX8Bzqe5ZERSKgFpED5f5/VijK5TOa/Smzsscui4lbkIW77WWMQH+7I7ky8c8/F8
         szeLs7hB761pZ7sSi6UDdNDvLf2z2AoIGgkZCBntGQEtwTzQOdzbkCBwvv6Lzz0FoBI7
         8WS9+1uOH3XXFLqRi/XcaLq+sS+CT9S9Jql35XbKUjxJEXu7jXylOdF1FY9l6C9kJjGh
         kL+H2OLHNsCU3D0oIA0J+Jq6c0T9h6zk6MtJWMmX6fh0b2cRS/YPFJNgE+AQJaeaGBEm
         kvHFzfzwg3cdvm6qnr38C75LR8xMAQiDOdB+Hc3OJ3m5o7l/wfhQtmGiTSOqe6RlCRF1
         ga7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5D+Arq0OSsap3F+LvB7ekAuzrcd4vf6SH4pb1GLsatI=;
        fh=6M1TEuOQ5S8SZFwlbujVEvZQBXjBlPp/2Uj7DDqapDE=;
        b=arKLfRk5wY1n3Ac7mRS2rVVCjjDx7bo1Z45VQC5o4Ayp5oajqdlSy+b0j+jAekZiSD
         pmuVDAYNLbYqoSfenMdM8UT+L/NMhUqKlOOSviXlE8cxZ9xu9aM3hX3nLn6nPyVRzOO7
         KGnAac1mWlD8Na/NiSUqI76ZmmTK9oCWDAIb1uHIpuBD/q8e9wf0ny53J24uVmNnG40b
         OJiS0iSdfsT0OLXz4xYaBFFw4nHb+UcmuTaD1L5CmfeSEkkdxMkHQgxo0y2Q25goHweZ
         /ZFaEeXGTtLn1/E2vUDBrfUQVRqipxNbXlhBOYSQGu5DSPUEMrgcIMMXKDUXSKo5BT0Z
         +68Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782471573; x=1783076373; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5D+Arq0OSsap3F+LvB7ekAuzrcd4vf6SH4pb1GLsatI=;
        b=fUvQAT/GUhGNcau9XZW/YFHyQYvXpvh8dXevhEaXAEktDtwlc1w+V63ECRWDoepQC4
         53PGiGphatP9RubWQBAhMv2yiGwHoVvD5M8Deh0rgGTSA0Xx8XCjo/7hNxg7ozeQkSvo
         mgvDEAnUztu/qGTdaGHftG/Lx1wN37mo/+sVvA9LBRCYri+38F6LD+uSipA1nQmxMwVi
         RJ69q24AFOX/41TeYFttBQZfJXkSb32Mk66mF8eIHXRJACVfv8NnrOKg0WSueDebKDh6
         MNqfAcznVoFeD3gdDu44yjCdWjwINPcmkoTliW1j7PFqXosbYWTnQNLSbvhN2wfz1teq
         w1zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782471573; x=1783076373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5D+Arq0OSsap3F+LvB7ekAuzrcd4vf6SH4pb1GLsatI=;
        b=W29s6cHzslHpth0I2Dha3FHZvBLEShXhndFDDnEbNAQd3RRRw7HwE13WzAObfdISX/
         dLjPsjKFlg/2ojCV9CBPIdDolA4glM9mjtDw1+k8OxRM0qvlML7q+cevS0Uba/lgplbE
         Kzz34elXACpeOLb1gvnR0893/N5an80hzaACAsTUpSMH7aIzB34OihcIivuGpTbn38WJ
         NXDPr9+lXCH/hZnMSska6l9XkQIF+6jfHUKKyzvsAXc73pxCXfojGRPY2iP+kr6Mx+mg
         6SQDyRRlqvoaTCdVmAayshP5qtRUUmuOdbvxsuDepvM0BsuEKs3Q9nabdEjamWSE6yuP
         E1LA==
X-Forwarded-Encrypted: i=1; AHgh+RpgDsPOpJ0SKwj5ld9n8a8BMHI17CZ2VY0SBafz74LJZlTUZcDggMpCCxmV1hY+q5MR2BFuLHr30A==@kvack.org
X-Gm-Message-State: AOJu0YwX3pI4xoSHZ+DXjZmdwhludcw2DWaIjdSUP4Hg5cJSyh5SxtNr
	Omsn9BLalUhyDVOt4dQRN6qPw3aZYNavGN/yDve9JSXmB628FHIHwx/qj69tIX7rbqIy7jwsR4O
	Tnu7vciVd5Q77zfPwTgdQTKdjtBwEpO8=
X-Gm-Gg: AfdE7cmYiu76FvX2c2naJPeMpF3uq+wJxEDwK0pidsRbU4ywzaibY8gNyv41Wa64jr+
	Z7KUEFaG5e7mF/H50KS3RIqjIlHCiQeFr8Ut1XjU1zltpY6b8BGvuKtqFd9X1Iqv4M7AvpXesfM
	hB4PxqzrpKwuqvjaPTYWttf1h2No0PzL8vObliCusR11MbGjNsglFV/4rPjoRXsbA5+wK0I9jDv
	hMfz5dD6Sgd3mMe4oUcJXqTcr3/4N9cYiugCjnnUYv+MGq7GUt+M05vL/lqvFCnr6Zarg==
X-Received: by 2002:a05:690e:1686:b0:660:48b1:50fc with SMTP id
 956f58d0204a3-66487e2f1b4mr5328375d50.29.1782471573329; Fri, 26 Jun 2026
 03:59:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260621145919.1453-1-ekffu200098@gmail.com> <aj426bA-YiOKt06m@kernel.org>
In-Reply-To: <aj426bA-YiOKt06m@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 26 Jun 2026 19:59:22 +0900
X-Gm-Features: AVVi8CeTYWPFnSIqmIZ3cUOMnriJoMgLi6dkY_72NuzlW0NxE1cDivKv2fvqfq8
Message-ID: <CABFDxME8wej3m8T5gn8y4dmpOLZutm=tDTa7ZcfhbWwScTu_5Q@mail.gmail.com>
Subject: Re: [PATCH 0/6] treewide: remove unnecessary invalid range checks in
 memblock iteration loops
To: Mike Rapoport <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Will Deacon <will@kernel.org>, Alexander Potapenko <glider@google.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrey Konovalov <andreyknvl@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 45DE180008
X-Rspam-User: 
X-Stat-Signature: zyd7r1p4nz1krmfe39cq4fnos5aofo3u
X-HE-Tag: 1782471574-351442
X-HE-Meta: U2FsdGVkX197Un2LhZaPtxZBIiAzg2jmyHYgtRxmIOhnd4caBbK8hymj9DsG0ynBbEKPV4rL9EODOXeXE4DZGxx2VrHfzGJlpPxTviF5jNflbUjy/FR1+o5DkdaPr/6RPg9A50jWc7ofFHM5jy4R0eqkVf+73LY/v1EvLr/sFyEpx9O+122STev2dqBDePCATMLrUoSYodjbeqvBy3QJ/Rl+c3xpBUCpOKXxYOlEYa85x8fQB7mPqXMT4gYrrbKFltnsupuFvF2+XJ2A1VIjc8hYTNn68nsdeqMB4xNW9zIPUAKtDBgQ9wxJ9nRMsIcx23HATPLHwleBNBAENUqkXNwHeILNqAWOAZypdze1VweLLDgILfW4zULZCG1nA4m8o+FcK4baB3hyi3FcDypGUMTx+97S0Tt1VMH2MHtIqra/m7TfhV8Dt+qQtrjI1eVefF6vbpWBDJcA93ASh7Qc7u94nV5kOLri80N4XkQ29yf4OWzQ6pXMgBo8S7qXBqtHXl+ObEDyG24jFqeJZ0N6xrPQJGSJuwOvEG568Rbcsk7zHUqETUBaE29cDd/H1FCijWvFGJN+QQAtDcnOeaoQ4v2+TEtYM8zFnWbJN5xpeO4xDIuA1qS65OrPcsOdUuruXN3tAvehy+PMbPp0g0IYcS60H4atVsna9echt650k3viBmOnugnSHg1JLbRU8SSE62SOg4l1gDxOlY87i8olbOFMQ3mRq2zBtaYrExfLG+kt5A2RyCxv1d0wr2qEVqaeadZUMgqoRvcKKNLu3ojMprepX3ADqO1wy3YKOWpSq1KfPFBLdc1gLO0ZW/Ylt/05AXX0AgUUHY/G2v3CkbSac7NEMMa95g7RphxlZkLXErM7C4i4p1K9uvjDpprtUjhTqiRISWB2CaSKCCqfjJz4ITTSQeCnr9yX/yloKxNE54A2F6GxyPkCBIvv3lgZmMoAaTxE9DnBNHWCsipQfTx
 AlMZMxKB
 ILKu5x7ahlDc30z9UWqziysjgrJOiZQZa8J+SIgCCf9BE+lnXFRDhvbYcikdQp8jItr492PZUxfr8mA3RDW1SaXlxZ099cXWkBrYITiv2uqqPjE1ce1XQUxI1WDIkCcZRq/YmuuEIojrcpBUq52AOcq2RY7fP5Q1yQBPF1fQZ8u0/3Yvqb4zntZTdnh9bWZtNvxMSXWzm78vLWkudSL1loAgQ3fYQOKIqNaCm6S2rz3+eHOFhFqJ7vfHYYtLdWj/hZXBBWD6timQ+nGXbaAMzoAwuajlw7FZfIwsl9VtJkZOP8ZLaaDvpbSCk9W1LVp7jGq9Alt9p3Z3dNv3COtsuU8mZt/G2G09B1uI32tn2dVNMGeFz42qFFqNVcbupZhpuaf/siGHD9XyOx+i2mgTHhCsykI7fOTtYqnevzViBUEhRqWcTAY9hLti7Yx3d/ldbqy3Y2hMI+ZpGflLk5lvWopv9WzEh9YorRkgPoRHwCwkf03x2o4YlwNsTyVsIDkCVJpZGinDAwcn+JhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 5:23=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sun, Jun 21, 2026 at 11:59:10PM +0900, Sang-Heon Jeon wrote:
> > The memblock API guarantees that for_each_mem_range() and
> > for_each_mem_pfn_range() never return an invalid range, meaning start i=
s
> > always less than end.
> >
> > Several memblock callers still have unnecessary invalid range checks in
> > their loop bodies, so remove them.
> >
> > Sang-Heon Jeon (6):
> >   arm64: mm: remove unreachable invalid range check in
> >     kasan_init_shadow()
> >   LoongArch: remove unreachable invalid range check in kasan_init()
> >   riscv: remove unreachable invalid range check in
> >     create_linear_mapping_page_table()
> >   riscv: remove unreachable invalid range check in kasan_init()
> >   mm: remove unnecessary empty range check in
> >     early_calculate_totalpages()
> >   mm/hugetlb: remove unnecessary empty range check in
> >     hugetlb_bootmem_set_nodes()
>
> I queued this for inclusion into memblock tree.

Thank you, Mike.

Could you please review and queue this patch [1] as well? It does the
same kind of clean up, I just missed it at the time.

[1] https://lore.kernel.org/all/20260626032902.703944-1-ekffu200098@gmail.c=
om/

> >  arch/arm64/mm/kasan_init.c     | 3 ---
> >  arch/loongarch/mm/kasan_init.c | 3 ---
> >  arch/riscv/mm/init.c           | 2 --
> >  arch/riscv/mm/kasan_init.c     | 3 ---
> >  mm/hugetlb.c                   | 3 +--
> >  mm/mm_init.c                   | 3 +--
> >  6 files changed, 2 insertions(+), 15 deletions(-)
> >
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

