Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4DE606A325
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FzDseVK9
Received: by kanga.kvack.org (Postfix)
	id 16C2B6B05FE; Tue, 27 Oct 2026 16:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CA66B0600; Tue, 27 Oct 2026 16:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032426B0601; Tue, 27 Oct 2026 16:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4FE26B05FE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:24:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3929E40B23
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:24:41 +0000 (UTC)
X-FDA: 85369534362.08.45BC70B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 46F9F180003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:24:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzDseVK9;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793132679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDrzL4ldTnZQIT/GAoRY8qgOJKT6dHcsc7F2wuy5Kmk=;
	b=JxTpxkgbue9d/B69J5Mki3V6IcwxUjCt7j2ZMOSp+XXSVyuz8fYHkRat7s1rQAYRmEK6rR
	pnQTbWvFHXN0oyxslv3KbRWLP7ufiu0R3CzamKSBheOUc/jt05f+v/lpdwwC2LGYCFo1jt
	JauyY6saYpcESQ0ooDjEm0j1QqJfj5Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FzDseVK9;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793132679;
	b=oAOfFeihS3nwCjjS4KRo6A4Y5dvW94GGs8tk6TLuKFxCBwNJshr+Llub68NTAVH0Ednny+
	5fvzD4CifQz31moOYIOGmr1cbt6xJX6GiZoeO7sW1Wqk0wkOq+MbRwCIthZ+UfRhS5hiKO
	O95GZ9Z1hKTsTux4L45FUyVdyVrI3jI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AC6D44084
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC031F0135A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793132678;
	bh=pDrzL4ldTnZQIT/GAoRY8qgOJKT6dHcsc7F2wuy5Kmk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FzDseVK9Ysko91Rkuq+QlEaFb2aAO095E8N7yIyvvONeohFAvEsNuXL/t50nDF4QA
	 dB5RS0qSQDyYKaQaQWzOLKiy8bN7OzmckzsSTJ0jnH1Qw/2x2YaVSN6GxSjIbbxDx8
	 6YPifMscpbIXjfoVMUUATqDBadzckblpHh5eoBXFbwrjvTULXKrPFYypotdKpK58DR
	 T3W5/x+BLgYO/uqSgOwbx0psff5ZkS+yXOS1sCDyFfPieQMn9gqqd1jDYw169JcsjM
	 H4Tthi6yhRiV7WxwtKCJQJaKm6v8skUAG5+0ZkEJfKUFputM9fxnc7vdLjTMxWwDOl
	 m4R1HwtIFSlZg==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93f269e335eso18238385a.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:24:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwID64CJjSTwKJCaf2TmW79UYtXU3A5/Lyil8h4T3TGGqkist6O7X5+PO1bhJkohzLIqKKSRK5MwA==@kvack.org
X-Gm-Message-State: AFq9FYKtonZm7gaE5/cxcqSXWpftGTQAZ77TqMIWJIq0hWhkJWYjMo5O
	RkJ0DK9d42kJYGRdMeaq6M7L0fmyPtyukpsYwOt7EOj5r+8mE0ud36pUx4m5Kx37h5tDLggHSK4
	bsfGcWyGPE2mOx3h1FbVRV+lceZqGrEY=
X-Received: by 2002:a05:620a:2a03:b0:93f:611d:a18e with SMTP id
 af79cd13be357-94408cfc2b6mr7042985a.55.1793132677465; Tue, 27 Oct 2026
 13:24:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org> <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 28 Oct 2026 04:24:25 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ytMqpLJ7wQe_gUz6Fo+BBK6ym-T6kjwgrHi7HNM0LiZQ@mail.gmail.com>
X-Gm-Features: AclHuK-1Qeuu3Mu9aA1DkXbl4G55KJdsUzpEs7vpxIgxIJbJWhUve_AqW65AwOY
Message-ID: <CAGsJ_4ytMqpLJ7wQe_gUz6Fo+BBK6ym-T6kjwgrHi7HNM0LiZQ@mail.gmail.com>
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46F9F180003
X-Stat-Signature: gzqm38rkrfgxw37t94djmd5fphridmst
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793132679-378529
X-HE-Meta: U2FsdGVkX18mhdyvi8jz6Q+7iO27PDwtwcYHV2LiweIw7pnie/FDWHKfCWO6MqrxP+ILP4tch6V/nVwV/hYDBFheMOJocZSB9NT+Z5w0i8P5cXgabKBDApR+va9xcqN5uZHGumF38kzyUUbabP2wmihJdrpSCCGVLGjL/MO5nsTnBBQoinznv9muBbxpeMCgc1ADbRBsDnGtwuYGZK8zZbN+7igHEMATDyJzkqR23TK+wqMsD9eAyb047Q5uweCr39Lfk10Gmkjby+AGoiZJzx0nvWrUd4TZWHIhB36udlz58XoEXvvaM7luPpYBIFbjioPRdaQEescnJEVisC/+He0yU5pbmMwiH8C3QkeiCx58dJDwlITt82qfchnv93ryFimyYQKMKu5NaIq1xX4ZOqfxVSEpCkPPgeOvwiirFfNbEH4wsYPwR6O1FvnevD9gKI7CQwq6ciZVnuPlRT7qVZ0O2QB3qup93n3a9qTYwW5hlcbN9tQ5i7lieBxkcMWNZoUvnTHuEaA3knJxQvzNt5d4E/nq/82T4tsyoq8lpkInOYrS/KxcNsPdNKEoZgWVyFuiCiRhEkvPMFGd6ZY5JXwNl4I0hRFLJr/mxuCs+jr8zJZB8f99xZIXmLb2GxpTv4krwrzcerlmzzF3u/l1wShREIAmUBDv9zAE18HY8isHAqKtrXaYCrxzr9FUD+qiZZXe82EQmt5hw+YvujF5raWcfjIY+wNrPIwuJ4EIlzIz29A/IOp5ndFablNh9uhQfpZgfSXh9ejjbWmMO/ftyDB+hGP18nImvcGZbBNG9dq24SZaqYAwJkhq9pSgiHNexJCFnLW1s6FKMtFXkCIBF7IFjVB74tllNT/Nsp1I7UyWLqeCVC14dA1uNwaBJqx2Vd/0THvR9/P3HvbwPTN7NQ/lGuui7FYVR2gKalK5+trz0+NbCISsob4hBhCz7XvaBkQaF1CTHsYctA4ceii
 lOsgmR50
 oYlD42azbp41Nsd5StYS7RobHj4EANJU5U13qtM2tre8JmndsVJ5fD88Aews6Z6ko4JbLwU27Er7isk1MYYG4K28axWKdv1OtuXL2pSnchpLBDAYh/Gnssqo0MaFekZnHaBeFlmGhjvPT92ozdmPx9ZYuvCd8BcTozrpm4s3q4gRUXxWssBJ/rKcGa+IBwkExEyAut0cy+LEtTjRH46GlQptSpectCHd/45LVlLkHKTGEwMHpIkMc4h+ACydX8tZpwFxo6ocfYMnyfcrIZ7lBKff0YLkGS4ZiwKlpa+5ddyhbgsedowljAxNA80HsMquWyfgCEoctgEVdVo9Lq3eBA36Y41gRS8TUrtBZqY6k2ZX0sCosPiefdwPKF3CLRoSIhMcNZ1kPYB86ver0EBQ/WcPRk+iPLe8qS0HLnXj+335vUHz9F7WE9zc5VaxDtaB4LTbQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 7:18=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> MGLRU passes stack copies of page-table entries in walk_pud_range() and
> walk_pmd_range() when walking to the next level. These copies can become
> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
> table concurrently.
>
> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
> support page table walks"). Likely, earlier locking masked the latent
> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
> retract_page_tables() without mmap or vma lock") allowed concurrent
> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
> for MGLRU") dropped the walker's outer RCU protection.
>
> The fix is simple, so just fix the original commit so we don't have to
> speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
> RCU-protected lookup and validation against the live PMD. Note that the P=
UD
> handling is required as well to handle folded page tables correctly in al=
l
> cases.
>
> Fix generated by an LLM and sent by Josef Bacik in private.
>
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: handle walk_pud_range() as well, clarify+simplify description,
>          adjust Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

