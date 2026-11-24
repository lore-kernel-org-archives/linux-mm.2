Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 152E8606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ik5ynCzs
Received: by kanga.kvack.org (Postfix)
	id 139406B0835; Tue, 24 Nov 2026 13:45:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111676B0837; Tue, 24 Nov 2026 13:45:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026EF6B0838; Tue, 24 Nov 2026 13:45:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6A006B0835
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:45:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DE25120B78
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:45:25 +0000 (UTC)
X-FDA: 85470890610.29.1FFBCFD
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4254DC000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:45:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ik5ynCzs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795545923;
	b=MBOaADtqjX6C1Ik5JFO+qHsAHONkUrnmIYK6xCKM378ukbWZV5eFl6jr50qvU2dE+g89D5
	5NuMpkTAW3NnIQZE21n/srqeiC2Xf1ntVld7J0NK1aG5eSHU0+XTyubjqKcwChcK2gOVbw
	+PVngtWaiWi6UcG2m7PTexDGZy+CFhQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795545923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTtmFC9qSzyqzhkMZ+nRiaHuo2O22TiUVuXKFLL5NIQ=;
	b=vTdN1nqqL5TZGwAH6nuxluv5UjLPVSPS0x7ZJ4OsBaRUKlNumQGPybd4KW2dTskjICRrpm
	rRu3Rvl98W2j1qfnsJI94QdnEJJg2EBNXTp2bwZInUZDdyd20nvB5G0q495hiGv5QBtE3P
	H/BBrHu+NosgKUrTDJuP33sNS56huDc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ik5ynCzs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a018493d57so194085e9.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:45:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795545922; cv=none;
        d=google.com; s=arc-20260327;
        b=nnCYjbeCVGpZLXFlfLAPUhoTpw8hv9kEnRRwc8Ml79tyceD60C//9Xc4sqYSLPbYpC
         7GuiO8G79I0zaBIjEfHdOmIhsg+iy605p34KdTzYXS1PoogE2qLQlNXKbVsEe04Dh+Th
         AqfsBUxiohPE+WEuCxQcEBs5st3RMw789uPFz2ylG64LXVCWvO/EJJfXHmYwCcvNpqMK
         Rr4BCaiajn2zat3BVB7RrkPJCHyCreczpOoohaqstnPu2cY3V4CKyEhDC2m2zeNeYAPX
         jvp8uCPGPqP1Je3RfBk8CJE3fvoOjPidKTpZNqjD4ktUQOOpCDAADaqd0QcbBWpB3e6O
         Jnxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yTtmFC9qSzyqzhkMZ+nRiaHuo2O22TiUVuXKFLL5NIQ=;
        fh=pKS0hC/uvw6ED1HUUyhdrF/k676EU2GEDdIba8etAoc=;
        b=hyNf7wATHC0YXP7uhkZycsXLmW+2JCWXCK/SlcxHOmQdqyWg8yf/oQZjZLfZC6pitW
         sate+z5Zb5Pbd/owH0r7msbEn5e6R6YFkr/WaUn+PAMTjK8V6IuihZwL621sEPyk57YT
         PaAzJAPciEpazlvI6NgoV9TdoQyQQB1Cwv0eISoFzDgXrwdGAD4p15YTh+oitiPF6UAq
         jPzg3gvcPNavXa9vMDzBDII7P+Xdz9mf+NwIBXtl8aDIoY5NMyEvwiBrAD/jkb6nOInJ
         b5J9M5ArMyR8hefwmAknop2hIRB9qWsc9LzWYk9tB/3boZusdKHC8xS1OAISleRchSN4
         UBeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795545922; x=1796150722; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yTtmFC9qSzyqzhkMZ+nRiaHuo2O22TiUVuXKFLL5NIQ=;
        b=ik5ynCzsxmsWU5qeof80/+tpSqYPq2Tbon2ztosclGBMjyx46/hfbCo3/mkYKSJTzv
         Ueuw9tqUUgTHKuwH+PNlZHNwUyivGtauElxRkOnZkvebJw5CmJs8mOEI6kIxItSQq2HP
         gbWh1EYp0zu0GhmiyltpA7p34plPuT/QH2/NTykfuQB4sEtqwfC5r5ZWnzJ0iVkKCLiZ
         GAThoF5mDrdOiiv5KfgzbhyNdpHYPMDTYyGe6rXnhkez3+Ar7+Nclk9uj8cORiNOVb4B
         l7RbdAYq4FqqOxcDwgZhM0G/6ntyGTSgrunozKjEtVQxgOChwuwowTL+t7xy75rfGfLr
         SnUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795545922; x=1796150722;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yTtmFC9qSzyqzhkMZ+nRiaHuo2O22TiUVuXKFLL5NIQ=;
        b=eRrgdU1kGNV6Vo+yaTY6aWG+ysfKAqEps79Ea0u14/fuwV4X9YOTLGE0lVYw37R2PR
         5fKDacxFEemwEGletPdtThfn3YGxB0y2uztw5fIXHQCaZhn3M/KdK+GtDjGYdWtBFfdk
         JqXAgDvTlWnmZAUU5VmkkcfTmteGvkrJNn1fhqL2Dkheyb+YkxQXNAER1cMfhfhdnD8K
         yeBfzQzKnZOzgTdgdaVtnZ91h9AyFTdygTWn+wS4XlCEewJ2z2ZJHcScf8/vtUs6iuPE
         9mxgNUnHNP/riUROea/OtWluwX4aifl41IdyWg5l/v8xavd/uIoL94AuXr2+xUnLXyEA
         jGCw==
X-Forwarded-Encrypted: i=1; AL+hErGCjBTZUugxOiyDkGAZBPVv0O8rxo5OFDe9MNB7GHmpAxF5+8xdG36vfHaHhrCPbcptK1uCqaQXlA==@kvack.org
X-Gm-Message-State: APuU4Z9NrMRxVbn87xIGljS2uSg96glNbEMcf7RasLUl7rgkd0vWKbcn
	f0S5FLDaPi5NN6t+nDQUC01Er1fv3ZGPBZtCqyfaDpg/idDWn8yKZX6cK3SKqCBYw3DZRGivKKh
	160x7cU4SKH3bjUoSR/c8CREcfS19Bpb2tDVqgfBD
X-Gm-Gg: AZFdTZfd+zxUDtbEPZBAh+EP1xOYPBnKSC1A5XBM6M6JRL3Uy0U4YH6ehL/8gGc6OR7
	oNvXviF2ES4nTnoluNmCqj3Zfbug1yrG37Rs2g44NP/nW0IknF4aJyLrCKTbsnO2So6QO99mn+t
	Q7thPXSkWYRejeqleX+KG51Fr9eVG3CJdX3i3aNC3exip6rAd7MTGKcyb3OK2fNsHXzRjJEKgGK
	NiomfoFVphGvuKfFmr2/DcGbH4GlDLpOSpris3IVgYZGmWCeTffxgcjMC2heLHogNNaR9w+IZIX
	4Cg4lJla3PvYeqq/90Crl7HyY0W0rYMMM55cnczBqGGDx3aLWW3mdE1hBdfPWWUqGwfOqCyOmcn
	5ok7QmL5VY5KxU1Qo7VCN0+WpowqJLeuIYp/BleDUX2/cQ1LFrzoZnqbs1xQnstwDlKl1BfIjpD
	U7rFmSrNFOmr4EXdelSBWOA1mb2A/zVa2Mvd6Eg3BZXDB5
X-Received: by 2002:a05:600c:470d:b0:4b6:24ca:8848 with SMTP id
 5b1f17b1804b1-4bb9169c773mr3294835e9.11.1795545921491; Tue, 24 Nov 2026
 10:45:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org> <20261117-huge-pfnmap-fault-races-v2-2-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-2-276007e73bcb@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 24 Nov 2026 10:45:08 -0800
X-Gm-Features: Aa3M54pkUi88VYe-fpktO26ba_xgIBRMnt9i_jgdkEnyzZZvFIfmSEN7jCPiH-0
Message-ID: <CABdmKX3ZihvsJfPGDhg+tmjn+xVfhKkZUshr8NbO5T1BmVcOPA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm/memory: remove racy huge PMD assertion from walk_to_pmd()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
	Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "Gregory Price (Meta)" <gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4254DC000D
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ar71kfnbae417h1geiyhdj95c8f3xc61
X-HE-Tag: 1795545923-666740
X-HE-Meta: U2FsdGVkX1+ebLgmYC3PU3pVIVxuWd+gBFACx1PIBZaDw9/12PTIouwqKYp2TncOUYaFf/zYWLCU+aJTdRsyT23mHiboynKVo15qmhJK9NuYQoGcA5V2iacO6fHCmyqiBQyRbGMRWQfOlfE7fWW8MPojRERyCYK6Q0Eu2ZT1eF/LqG5smxcHIEA+O3xDcFwP+t+Qih1j3lmeKmZMU63QpROruR1ZKgRlzmqpmfP4Rx/Ur9dtUo0euzrXvgOySYV9izQiEZbGUI/nvX/xMLPXGNvNV0Mpk1pc2udOUnE7hwAAShEFLdIFQ/f2s37LEced0pOH4hESQkE7N+zlEc/3FjIGfHVd+lnu9G3V9Sm0wqVHk3AoZyO+quKlIsbdfGpCs61i4/DUQE+ujVckQd8rUfVWkqUaCYUH2izob9oOx4v38RaGgAkN04eGPg8bhieUGkiOjyCDm/CTXs1L1K9gpHeunWm5nYriEhz7qSPOiQz95Qgq1sy85X+D1KcsoaMWt8xCptmfqKUW8vB5mtlS1ziJapAFuAURDIVARt4+m//UZWxjBPkJEKQm/BccpCtoiZez5rYOudWacnOK7yNDTczYQfcJu27uH6uaJqLPUu5EmjjiyHA/YhjeLJ1JFiWEhdWTkkLDbXiZVUAJLXLpC+79D/vQqZGtLpRJAqo9dbvwTkNGa4miBsNO/M2qnECt+NaK1Aanm5JGydzGWxFxiKApG2VJAEtagkbdfsVGw6AvIkGuNNpxa2WmyCaCyIc4WNFfqcn8a9Ot/cTn0/B0eKPSp1IvlZ73iUZdn74plSjtW1KJ/M0e1FMUMzJwZURlC1RaB5yg+RiUNc2qNA5UHcIC5tzZ3QqG92tVKv2fjq/QS3goBUXxR2P5ml5F2wBSYhn8U5Nv80CVxkhEJuxsOGrfu6vXk0TaN/1wuyuEja8/vmUwfZkedxmet2Y90Bu8dZLcAa7psByDlEnGC9S
 DDA4hTzx
 9UjcFbraN2vyCZI7JCkF7xR4tWV2RWaaM/2nwPuI/GryZdt9LxerO8LE6rwhWzV4qYiwWu3BRdj7F5dYc2ljqnvpBUITn/AJG6Sf1GeuhH4Oj55Pj4W3gWqDL3HajT5ya3ifvOch3Op4JlUugcxeykj/eKeMONhCiHc43t1Tbt7Tb/+3iob66OWa1BsZ/4U/wZqiHaDvueLR0isRpcAQun2QWGuxz8LLTE9RBCHJpr7h4WtmZxp5aJIJWiNWLlXhEa4ShEjWBguJqJIbRfqnPN8sRX20dZW/Gdv1FiuG8GMq8EQPBXjD2EFiD2GlpYONEZhH0TKq20psIAafiBPGZd2Dn555McwbAfMsAIS+OBBp5xTrJtGF3kQYD3mQavF1Bg/NXJfM7Qsppf6aNwkLPyBBqXs5b8dXjBXfBeK/FZTPfPVpiOuylRB+YSZFG+oN68CDDXKgkpvCEGiF42bykZPTvYmxMha0b9r/5tBKUvj6Pp58pixj40w7S9Ic3VKGAi5KhINpoPAjJUWkTdoKdCgQ0EprJP6U/1TR3XsTV6M1WIGMy5wKDIauy4hUdMhRrkUC1d6KpMe+4XPHqVDhXAoNiYMHcZH0CZueTQsbnX+829u25ZwGYu4gryJ5UvgDV8DyW6IavigSZ0lifTRLRk+khJ8a++gncZ4gLThcO/ElsgWg37/PER2FXsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:32=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> From: Eliav Farber <farbere@amazon.com>
>
> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> so without holding the PMD lock, so the assertion is only valid if nothin=
g
> can concurrently install a huge PMD entry in the range.
>
> This is not the case for a VMA whose driver implements both ->fault and
> ->huge_fault and which invokes vmf_insert_pfn() from the former.
>
> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it onl=
y
> takes the mmap write lock and faults taken under the VMA lock are
> unaffected by this.
>
> This can result in two concurrent threads faulting the same thing
> disagreeing as to whether to attempt a huge fault and thus ->fault and
> ->huge_fault running at the same time and triggering this assertion.
>
> So just remove the assert.
>
> Target the commit which introduced the first driver able to do this for t=
he
> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> them using its own mapping entry lock.
>
> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.c=
om/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eliav Farber <farbere@amazon.com>
> [ ljs: rewrote commit message ]
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

