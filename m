Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3380A606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X1ektPkr
Received: by kanga.kvack.org (Postfix)
	id 2AC2D6B08C7; Tue, 27 Oct 2026 15:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2647C6B08C9; Tue, 27 Oct 2026 15:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D7A6B08CA; Tue, 27 Oct 2026 15:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7A4D6B08C7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:48:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65FCAA8874
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:48:23 +0000 (UTC)
X-FDA: 85369442886.07.8A8F89B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 88DD180006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:48:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1ektPkr;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793130501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBXyCpRHgO+MYx+nOUuoDTL78tUn9LIeQ2aFxfEucBY=;
	b=CzE2+KoTNfbUmy8DbW4sBdK0yswqMawHL7Yh7jos6IT3ezp8F6ya24qwF4ddRJBG6JRRHR
	mJTdM+546NRj9k+EtB4ifOtw/OGL4cNmMsU1x8Tw5/eAe+WS8qu+Te9phbzoRxK5YqOXOn
	YjPUuIf8CPjQlAwmEqbYyT/KwNjOyms=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X1ektPkr;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793130501;
	b=kpw0k1kN2MTqhpPDmdtMwHrwTgh3srndRo5tyL7useXJnd/E6ZQ9hahAeGaQihJvfCnB1F
	uYmicMyU2hP1ZnPBEqXng9bMrQAMU6BKL8B/sqxKWOjcLuR1X+5BE7Liwf7Q59Nq4IMe1u
	oWgrprke83sYM+kOf8FfVH/UcwqrWcA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D884F6025F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E41B1F031E6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793130500;
	bh=dBXyCpRHgO+MYx+nOUuoDTL78tUn9LIeQ2aFxfEucBY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=X1ektPkr07/Laf4mhxGMYACp9EUSpX9DhVF1/tTXmR8R3XJLK/ig9jlr5MNsopi6V
	 JXYaaZS4Ka/elkmjbJrVLj6hijeKuf4QN82dz5bxl8JMRYZES6pWFYL4LcNRV97ZOg
	 30nkS6WxaeT5i9Y3h0Qx9ngL/znS/aDemcg2PGM/o4P3ucWR1i25zowTWWrQrK+FJY
	 jOeXt+P0QWk2sWEf6svV5gj6s1S9b3wJVh8jSa6YxX1LC/nmhQeIffDpIU2q694IRl
	 Yl9+/FsVZi0pSIShvD0DD6xRjE0byx72bsDp3J7k+jPh8yWCvohBZQShVXxaoXrYez
	 q7nUtfNlrno2A==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-93f1e5d7450so12552185a.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:48:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwSCR08hYzbOzpND7e2CHTYCLOUu39G05rvu922T4qHEHcre8NFq9rxaHnvKFIZcDE7haZ6utGFHw==@kvack.org
X-Gm-Message-State: AFq9FYIS10aLfvksPVkk8GLyZKoytSFMnLLM7IvQGm31t/IR6sCSnwQi
	VP27Uk/5SHzqCOd/ctgIug2s+MoLAf8S2EzTyB6SRZtzNWBDQ7hyJwCScSJg2t1QkdZs4ALfduI
	d+JEV9Mj0upmo5W992ZDp/ZH0Eu8KaaM=
X-Received: by 2002:a05:620a:171e:b0:93e:c12c:4409 with SMTP id
 af79cd13be357-940ef99a3dbmr1852566585a.69.1793130499936; Tue, 27 Oct 2026
 12:48:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org> <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
 <22b819a2-631d-468e-b724-770caf9f94e4@kernel.org>
In-Reply-To: <22b819a2-631d-468e-b724-770caf9f94e4@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 28 Oct 2026 03:48:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
X-Gm-Features: AclHuK-TztIwEQBE6javSaaaoybdbPKwOAcVqEYuGwGbjltsm1heJMFfzyWkRwA
Message-ID: <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
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
	linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88DD180006
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: agdpya1i59zoyppze7fqfsscbgr9r7gz
X-HE-Tag: 1793130501-670937
X-HE-Meta: U2FsdGVkX1/k2DOFibqBW9lYaXnTu6X45S886A3SC36bz6xiORPQmhDEVeCpCZsVdWRoYjiBwA1OZZj4jlDlOaGw/pddriVEghV0CwG3PvgLX8j7tewHjmAqTQIPlfJDgp8VJOuELHX3aO6ZjGUtmjfFMVmL3JEdiAzDJ108Ix9zYuK0yB9jqMvVnLTLG5QLuQpdkdzspha3nqdoWWc07QgiIWV/pukWlgKvYxVxx2+xmKeTYLHzvfjsUL75H9XpHXPctJH1pKVjnpjzELjIFeu1o2Beat6+bbAdnRyCWzKAUUSd949LmZ160GjlTT7bhuo9loNhCZSN72u7yPNNW+D8LsMFsiQlBdTx6cnbUnsihTIqWwZZjYCv1DfPgfYEjPq0oEIW+WCMEtxYen99ZxpUaQIr7RrhjqcYOEiIgUBmnbRqLpOqPQ7OOJS+IegERsE/FfuldWwArozArzZiGfk/IIkYO7ztMEDI1qUFbATFdEyqC0wlzlt8zPPYgotB7hOUFZALG4dRMi8kY3af2SZkognfCxLtxW6EKwbQ+TF4tBDtH8jRzmBQ7nAdz73VBUwTi/ka1PF1/0a4gjEnT077cGUJNm5OrM/AN+pEFgy+JazQBEWA4SN6jyf/2ErZs7gqVZnAZeLbtBuebCcMnzfvayNTrVvPbkFKlZnPVhFfCqhxZf0ebH/kbr2fNXINxmfEdovconhdtg03QiwuJDLVSbg+4vER+0VUqZwRcRO22xL19nl34m2kWNCcoL4xa9N2hJ3hRWcq3zZSBE/NMfIo6KtCiMk9ZR9goTTmxC734rbshe4ZfFZTJd44c+1V3RjtSG8MyKXX55dodGM38c0vudodIg1DN2q2ahqRdJMh2rO6W0OkO8rZ9RJ3bJyPo+MmFAzoridDWNLtf1KIEAFoBKx52/AIUpWQtw4ZvUEzx9ySWU8aZu2WgyPv8Y7NR61REBzqLa0DN1h9Rif
 bxBbJbIH
 NMDLYsD0sapjORExV+Zln7Vetbcsr3aF3IYPASRwvSh7BLdcHdLXMxB6yM6b/JEIbv8egqEprjfhvQEZwdmczhnBrEH8pFrFHERoZR8IO/0ULRl8X0WcutfS36nmyeVqK+TcS10XQ01i/JiqdMi03TDPdYxA/Z76Y7f3bI3E2o0/AXYbNjCxpTHIZL0O59kJzpXFJBfdt7bhMiv/aI+Xs8P1dnyp89a6ZnKktT/aFSmiZFcuvgnMZiw5fWkW3fhr0dNhNnj7v7A+tcVR8GWWAijZvKs+Th/PQUN47ml0sF6EV6y5cwfxS/1i9QNqxWl4y0Dmneh2NRJPbGl5pO+7RnUP03zT8Y8zZL08lfoY4o8T+Ome1SmnxsC5gqj2e+r19y6G9qOQt/I1uN/8vnIt364H/iDHME+2rr7P8/7XBwNxMjJ776O3Hso4q1ptHD2WOly/3v8RjFKEv7lzisSLJXXgrPuBfU5wOQkwqSLoIOIlGNBMdIH3GanrCNjy6X16BjEol
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 3:07=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 10/27/26 11:38, Pedro Falcato wrote:
> > On Tue, Oct 27, 2026 at 12:17:22AM +0100, David Hildenbrand (Arm) wrote=
:
> >> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> >> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> >> and newer heap mappings, causing later brk() requests to fail.
> >>
> >> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can simil=
arly
> >> cause inconsistencies.
> >>
> >> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> >> way we don't need to update individual mm fields in dup_mmap() and
> >> keep missing ones. Stop updating the 4 existing members (total_vm, dat=
a_vm,
> >> exec_vm, stack_vm), as that is now no longer required.
> >>
> >> Keep releasing the parent's mmap_lock in dup_mmap(), before
> >> userfaultfd completion, to avoid moving the userfaultfd handling into =
the
> >> caller. This should get cleaned up later.
> >>
> >> Move uprobe_start_dup_mmap() to preserve the lock ordering.
> >>
> >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >> Cc: stable@vger.kernel.org
> >> Reported-by: Josef Bacik <josef@toxicpanda.com>
> >> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> >
> > FWIW, strictly speaking malloc() isn't usable in a forked
> > (multi-threaded) child, but glibc/musl provide this in a best-effort wa=
y.
>
> Yeah, I'm more concerned about other things that can race ... :)

Regarding the race with memcpy(mm, oldmm, sizeof(*mm)), we
still have one [1] even after this patch.

That is, copying mm_struct can happen concurrently with
lru_gen_del_mm(). However, this race doesn't seem harmful.
I might be missing something here though.

[1] https://lore.kernel.org/linux-mm/6ab08265.71f81b7d.15fa6d.001d.GAE@goog=
le.com/

Thanks
Barry

