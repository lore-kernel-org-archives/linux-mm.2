Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E735B606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kIvE1Av/
Received: by kanga.kvack.org (Postfix)
	id 042D76B05B6; Wed, 28 Oct 2026 17:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A216B05B7; Wed, 28 Oct 2026 17:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E727E6B05B8; Wed, 28 Oct 2026 17:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C39EE6B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:11:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C70E16010E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:11:30 +0000 (UTC)
X-FDA: 85373281140.07.C4D2C9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4D5D4160006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:11:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kIvE1Av/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793221888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2T2ryu8CYGBb/tgqfVT9uEsdD2RyXJuHuC2cnmKBcaE=;
	b=DT1lJ3E19b6NFgSsshRjZIi8WYCm+vlW5Or2SftQwAzm+FBJsPBvQ6i27yqpoDPeagJURs
	qWqcjrIbNQcs3HFmkPzxSvsyEz1gZBFm0Mg1rGwg1bhhs8YrWRJVdvVucUN9rlqeZiPhqb
	ctkUUon87nxSX3Z7mHLsU5DxSw5GvYg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kIvE1Av/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793221888;
	b=q+mtIoJ008VR6iskDj0heE42UrBrvooziDVkaNSlf6NIRUMlffknSr+EYACvSR5TDb348a
	YX68m2wU/Olbb+j3SUSOstFr9QnKTU8zUw6UqIoauF1wmykIwuTzfMaF9KqBpfkYdCGZPy
	AUvgc8Rza9nZjuMMvzY8K36IGDPLcVY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E1DA4424A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD301F031F3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793221887;
	bh=2T2ryu8CYGBb/tgqfVT9uEsdD2RyXJuHuC2cnmKBcaE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kIvE1Av/NonADig4ues3OMWwzmxsWyNeBhYPhdsQL5Yc5BL1YXObcZTr1qaF3e5ga
	 dszFsqLr0ZRvrDM1FuSyNUyoV71ayuuKa3+vu2X5iasPuSZrzMyirfRIfuayvnhBF/
	 NMoE2sNALjgYz+YqfbqEiZ+gLdBOk35crImYyNQ9bkRu9KZhv7hFFtEOZyTUnWVYDh
	 37gsGkGUTMWclDWhNrbCjPF0V2u0TwpumujohEzJyZE+CpZMOVJRLnX4vMbsQ2Iz8g
	 gKWPFlP4nqLmSSFIvwhUyZ6/5awb5oYMOgvY5W14PBNquzH4csFPyZaMDQ3MnIgecS
	 rEIPPcuuD6+Tg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93e6eb77f0bso122177685a.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:11:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzGuiU9ZKGJPeTkOHlmm9NFGsdPd5yhObInotdo22rwaBCw3ZEGQQ6BFanLbSNYD52YSiQGlTHX4Q==@kvack.org
X-Gm-Message-State: AFq9FYK71BnB4St503y41Dy4HiQ22VM6h7Clet6TDNSJtPWrKVnJIP0m
	p83clVxKsl3c8fhke4Ls9VlosXpdzX7njZFoInPWDBXDbFVky8ylixnFZ/IrND3LRVyq8S9xL1M
	Rt63Hs+mlfssxr/0Nd0DrhmQJ+bOIWM8=
X-Received: by 2002:a05:620a:2a12:b0:93f:43a4:a48c with SMTP id
 af79cd13be357-94408cb191dmr541635185a.45.1793221886373; Wed, 28 Oct 2026
 14:11:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org> <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
 <22b819a2-631d-468e-b724-770caf9f94e4@kernel.org> <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
 <auHve-G8bboW77IZ@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <auHve-G8bboW77IZ@pedro-suse.tail5790ac.ts.net>
From: Barry Song <baohua@kernel.org>
Date: Thu, 29 Oct 2026 05:11:13 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xD_EU9sBZmJRb3ET3zfxnOnXJvZB1p_3pTLV=Y4xHPMw@mail.gmail.com>
X-Gm-Features: AclHuK-GiN_SNdh0TbEQNxyVeAnkfKV91o-Gzvz83ZLTf2wxKLZGDZHJQeX3iwc
Message-ID: <CAGsJ_4xD_EU9sBZmJRb3ET3zfxnOnXJvZB1p_3pTLV=Y4xHPMw@mail.gmail.com>
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
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
X-Rspamd-Queue-Id: 4D5D4160006
X-Stat-Signature: y6hbzwikpp9irupsyyn4d6hrjttrzndf
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793221888-384505
X-HE-Meta: U2FsdGVkX198xoHW7jNLv/ljrVFNhv3bME+ZhvV2xrM7RnBWP1xTdB0MWQzdaAK8ogjAcmrPJvzUmIWB0jmeouz9PeYFAI0/fesOHG1Icf39ZXEI0uZb262WmAecwEWWGkNneFT4ZyRHKl1QWkirWv8KPyY8bWgQ1BPCsJ9uwXegHxDXS4NlRlfJrC3VBVfMfObC2EjvCtwa/fiZidjzxg/iMNg5+LQPX56OYEeiOkIK9aSbbCFrRqa7P6GZ8qzQRaqD2NhCZGfyNTP80G3oJvfuNFUZQvIRAMlFEQFzZOtazLMBXXfYG+iEk3SytaC1ugBKySkDDHbGutdzPqC1BoJfg8wTG7zgwAk977f+vBiLwMgw2PXHfUGjdx1TKksGphMwev9kNX1/U5mAeyQSBXRt+S6fSrwHAZviRqiUBQA8eWG5ry6Kdv6uuTPJCmNxZMf9JU4dYuVlOb0hbLG3gxHARDHwDlblb+rFEmXousjlrq9vdDHpWHxwY6HNcB1/owgP1iaLdF8jF2klICceZ7b65bYCMZ7qxE//KgWaKoa/3K93aBhaJY79+pit0N/ZWWPjfgebje67Yjm8QrAxHk25MgZIxlTxxceqCn+77Ks25c4ubyLA/pJ/5s1UXy2E8olVU1rWHgMx6fx/kNyPV+SQ1mqDBrxTLXgiH38LOHZp4fR0M0q86O4miVymkiP3CvwTeNVVoEaGIwwvWyVUm/vEaAIRz+Ye4eyd4YCzeGtjdf/SYmuZQLYH26fnptsDzY7mnLOJI0IbsUUN9IyEAjP0vkj7mcviigbvZUEby6objAJ03eZRyKOKObTIf1pJLc6zzbtXuYMYT58i/NAHv4l4qpHIUreRucqjdYFG47CBLHNDkJ5zY7EULJMiJy2Y3SXXkVoEo9ZzuIcNyn9GSudcklZXd6dKs+FrcI1H0bKFnGLYrA1ukOOB34Htdoq3aWfGhICYEyWjqZ+AKj+
 QWHDDjeL
 FlCkuArKk/qc/QlwleJnPo7ETaYkc0lp1jjNgmjPQh62gY+MaSNB27y82Uy/QScca4PlXDoxVwgdAGtzXcmxIOUIrehLuZZZK2FOEU+cmX15UWScE1QN9ifQJSSmRat4ACvXw/3DtBSCItywOoZYgTNgbvUBgMJ8fUQ1OOaGMGiWn29PTe7DeQYHfg4TF9I6D8E0Ao2qBeGPYThi9uvTpBgLSzOzJFdZVHK7618WdkVsjGCNiLsd2g9FoJMbsR1bNLq2micFxnnCRux3z6Pb/CNRfmdAT1IHz4BDm2Kw+eYHaH+2AGhEkpSo3LIb+TksmKVhGaqpMjAqwBANMowFxuxNHOKOB2lDiGpY5BfiTGndzbSoPhGUvyzQ4nq5syT5DXiTbg1iZ1IJUr5glhWpuzGmNuhIhEcuTzxdjWsAmTe9zsw/nEuRiGobtDiBtvCNW8Vmj2nj+T3Jcm+QPSbYBCO8kaXGt/HehrHONir7fnVCd+shp4FaI8SDdxr88lVXUDJu4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:55=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Wed, Oct 28, 2026 at 03:48:09AM +0800, Barry Song wrote:
> > On Wed, Oct 28, 2026 at 3:07=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/27/26 11:38, Pedro Falcato wrote:
> > > > On Tue, Oct 27, 2026 at 12:17:22AM +0100, David Hildenbrand (Arm) w=
rote:
> > > >> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> > > >> mmap_lock. A concurrent brk() can leave the child with a stale mm-=
>brk
> > > >> and newer heap mappings, causing later brk() requests to fail.
> > > >>
> > > >> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can s=
imilarly
> > > >> cause inconsistencies.
> > > >>
> > > >> As a simple and robust fix, grab the parent's mmap_lock earlier. T=
his
> > > >> way we don't need to update individual mm fields in dup_mmap() and
> > > >> keep missing ones. Stop updating the 4 existing members (total_vm,=
 data_vm,
> > > >> exec_vm, stack_vm), as that is now no longer required.
> > > >>
> > > >> Keep releasing the parent's mmap_lock in dup_mmap(), before
> > > >> userfaultfd completion, to avoid moving the userfaultfd handling i=
nto the
> > > >> caller. This should get cleaned up later.
> > > >>
> > > >> Move uprobe_start_dup_mmap() to preserve the lock ordering.
> > > >>
> > > >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > >> Cc: stable@vger.kernel.org
> > > >> Reported-by: Josef Bacik <josef@toxicpanda.com>
> > > >> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > > >
> > > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > > >
> > > > FWIW, strictly speaking malloc() isn't usable in a forked
> > > > (multi-threaded) child, but glibc/musl provide this in a best-effor=
t way.
> > >
> > > Yeah, I'm more concerned about other things that can race ... :)
> >
> > Regarding the race with memcpy(mm, oldmm, sizeof(*mm)), we
> > still have one [1] even after this patch.
> >
> > That is, copying mm_struct can happen concurrently with
> > lru_gen_del_mm(). However, this race doesn't seem harmful.
> > I might be missing something here though.
>
> I don't think it's harmful as well. mm_init() reinitializes those fields.
>
> Though I hate that memcpy. I think that ideally we copy by member and
> data_race() benign races, like what is done in vm_area_init_from().

Yes. I was suggesting something like using data_race() to
silence the warning[1], but applying it to memcpy() also
seems a bit too drastic.

Another option is to copy members one by one, skipping those
that don't need to be copied. However, that would make the
code quite lengthy, and the copying might also be slower?

>
> Anyway, KCSAN reports aren't the most serious thing in the world, so this=
 can
> (should?) be cleaned up later.

Yep, I don't think there are any blockers for this patch. I had
actually given my Reviewed-by tag before raising this race.

David discussed races between memcpy() of mm_struct
and other operations. I recalled another related case, so I
posted it here. Hopefully, I'm not just making noise.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4xnM66UZ-n55AHW4UHn+PSCP7G-gGUHU=
fSt6MRZGeRnfw@mail.gmail.com/

Best Regards
Barry

