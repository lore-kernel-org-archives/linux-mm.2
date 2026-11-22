Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E615606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RMmlsde+
Received: by kanga.kvack.org (Postfix)
	id 8957E6B00EF; Sat, 21 Nov 2026 22:24:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846526B05B0; Sat, 21 Nov 2026 22:24:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735A26B05B3; Sat, 21 Nov 2026 22:24:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4741E6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:24:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4077A06A7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:24:08 +0000 (UTC)
X-FDA: 85461311376.06.29CE3D8
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id C920E80002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:24:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RMmlsde+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795317846;
	b=HKZVY1chlwc9XbyHG1MoWfLCSB+Zi+exdFJeK4JItBHndbZTNUuStVD0BPj/ElFiTsj+HB
	W/lff0M8ey9iy0lxKnONsRvge5ptIJvtjdpzcO8cSSsjsTKS2d/b4vavFB3RLF9ugfzp3o
	tGI1SKh1dPR2VaOAJUsz+M16Wnm53SY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795317846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGKxFPn5xySqoyCRzT5dIDYsGVRKkWI39lN3gH5sSKw=;
	b=6csVVZRcvbzkzVeJOUc5s8vIoMYqZ9yHQmUU0zlN0i2au2bRmuLYSHTF4PXQBc8ItE5Y8m
	E5AelOC0xSE/UB5ofPxlDJsrWcGIcAVFPs8d93i2gV4trykpdEkjmhfzMhFtKDUrX0xAR1
	/vebyc/9wiRjJzTedjbFDlBqMgeA/IE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RMmlsde+;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-55be673e029so152041cf.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:24:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795317846; cv=none;
        d=google.com; s=arc-20260327;
        b=p4zCdmZ+0v5nWCA95znhK/xUmycIberZ2og6pQ+uC4Uw7X82SFscLAwKiIwDeKzZaz
         hkdqXucQs5l2IAqFX4l4LCVRZhqMNgMpVIeGZn2fU51EtDj8zex7eNPeTHB3gswpdO0V
         skU+0Mduwb+aYiyjDvmuLfUEjP3WjQF5Sq/8pFkUkrHeiPeEY2KVs+BOEf4PITJVzL9d
         pVNIRJpP9UhSFAQHXYIL5k9BbUaAPxeYQm4odLSKOmHvdpXVCaN+EG80IWzOHXS2ghdn
         tx9kGIbsie8tB0Gp5jeNOBAw6Qsfwo2/rj5iFHS/5vJjaF+Fq/mUrsFxfZNwNCQsO2VO
         ZxKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FGKxFPn5xySqoyCRzT5dIDYsGVRKkWI39lN3gH5sSKw=;
        fh=vyJ+BUMb9EkdDlo3NP961NPCSDRODCtjioN6BmhFXJ4=;
        b=oUXUPVrKX7QH55pPiOr0sk+0wV4EPSIdUAKp/ZmcrjtL9F7icx8kqLcYLSD42ILgYb
         i0rWNz93am5rj3/LXMxukl8hG0h1Z8ibWQJRvLONJFMJj3sMVxCIuL6R99+wUi0LADbU
         EL2SPsKkPE5eXZ0pAmYH5IzlJRHSwguidtgDD1eBed3yw1eXeo9gbyAavCPYo5N60tZB
         aSQHx0Xh92S18XgjirPqW9HaJJ+FMzW70nwuzlV4973ygx5ha7mRPv1MMOZHY3kzunKT
         BHBm67u8zBFN+nN/PV4Qx4Uc6Vm2vkRnS5X+f7sRZTuAbDtJI4tsH5Q1fwku6+r42e70
         bpig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795317846; x=1795922646; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FGKxFPn5xySqoyCRzT5dIDYsGVRKkWI39lN3gH5sSKw=;
        b=RMmlsde+Jd2bugjUyEQ/mYD7RX39OAyTmug1VPfLYpqgpdTsffWfV0hh+3KHZYbnY1
         AfXw1gEVOGapby/BdOZUJEvA3hfPQEXlvKjnXisgcHwurfG9tNQab04V0jGzmnvFhMxl
         PogwIK6+KByB1v9cdAzUjFwzCwh5pSey8R3xD1VuzAFQY3LrANk5ZP58XJWsEZmMBnwt
         fTn46SpjiIpvpwHLWZqgDl1/FoQy7b2yJh1ekqb4Lda7DYq3JPZ3iX4EJumImZ5EQTsp
         JEAo3oHEjjzBfEDsQ8Cm/ZvvbUapO0rczaDNLHNaj2sa7F4YNLeXj1gi85MEZlyZajWs
         zRqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795317846; x=1795922646;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FGKxFPn5xySqoyCRzT5dIDYsGVRKkWI39lN3gH5sSKw=;
        b=BfNiBUMtQ1iOL8nQsqVJN0t7kxioN6o1Jx11q851NBkCKAE19BmVvZnGNZzMJZL8Nd
         DiJ8TpXdsgy+EnHBL0BHicF1iahbyozInD2s3V/Td4d/MjLdwpB1VVNqTOl2z5ySwlQ9
         A3UG+tWYPfYBXhUmbneQITVyKszyCN1u8i3ndwlXGBt07f21m0w4NnaFXUtAOcG94TiD
         VOUYkRDBzJqdBM/CfH/mva1iwhbavTM+UeH3UFN/6S6uWGruApsCJh+dnUbR56DnDYFE
         /uCo0JF+JSzBPTsqZk12uju7aZOdNNwaP+DcR/JIxJ5UARD8QdXt3Zf0mRad2JT31FI4
         uBCw==
X-Forwarded-Encrypted: i=1; AL+hErHdgFXEMeHIfKBAN0n8xR0gIAjN0cwcKSo1OC7CqnDZrp18OkBl8xjn2b59tai+RryhlACsqcbDGA==@kvack.org
X-Gm-Message-State: APuU4Z/EKhcokj0ZUeIfGxbX3CafXDWXxVleEAgfY4gaN/Suws7IZqgb
	4XKIqXQTaKYDUjabLEVJqHX9zrUvZk+P05QF1M1+AmmTqe5i2iQ69+lQjRO79vfLTCwQq/lEUnx
	w/9j4nUnR0oKj5Cy/NKnDwczNaCsn/9lhVw3+YN+T
X-Gm-Gg: AZFdTZdFMhG6KUR4vlo0KqqBKE+OE//8R9udQlYRSfXtjZVzBHHEYqqfVCSdou7/F1c
	luBoTdL8TltQYt1sMnmks8NF9oEJEMfwsmRWxvJ31Kf7IAuw6EJU9gBXr3Sx2RZMl8EXseH4bhJ
	4C2XrdmwO/zTxLKMBAPN1D7m3NE0D9zNpujLXiZZ7s89uBOrEP/6bXJLJqn8LoE1syWACqZH6ml
	B6E6OmI7QFDU2vuYOwHygSZja2utwpOndiMqyVVHVRDsDLpfG7SEz8XEr/hewZk4KHE8k9YopQU
	UZsHI0k49C0gMBjgKLsNKdTxowATq/mC0XLdWcqFrHnKh3va9KjLS31bpKyQ8VPRU5At3y8rUw1
	ESKGupdV3/YjLuJnkij/9Wryd6v+VJoYEmnXQuP02yFuYO5V1FhMJRdGjyspVwDRUpqlBQfg=
X-Received: by 2002:a05:622a:2598:b0:533:9731:f0f1 with SMTP id
 d75a77b69052e-55d890363c8mr16483081cf.10.1795317845380; Sat, 21 Nov 2026
 19:24:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org> <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:23:54 -0800
X-Gm-Features: Aa3M54oyWvj3bs4F65WF6fcW7Mb0TWr88KUK43PO30yLTmdl38G6gNGWPlfj7T8
Message-ID: <CAJuCfpF4fxuAkuqrhkT_Rp3qaUo7+oiC_CrkYMGJcReeJzo1rg@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm/vma: lock VMAs before taking mm_all_locks_mutex
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ollie Wild <aaw@google.com>, 
	Adrian Bunk <bunk@stusta.de>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xiyn9j4g9daahbe8jafz6n3hjscfec85
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C920E80002
X-HE-Tag: 1795317846-844189
X-HE-Meta: U2FsdGVkX1/8+3Q7o2N5DebCYu0DhQRtfYuVAmf4u7ZDZvlgCxZUq3yjY4LE2bAAUkYYV8zaZtTY+USQcXJzYUGHVcKZ+2C1sRMA+Tl5THY3ZqJhUOsFPNmtpAgW/ENP4xQ3bfJNdQLBW7Y1oXxlYOyv63dQkdpskJALJd99Si3f6KucDbATRtwS/ZVqCU17f0w+hIq9Pil01pinJA2k83E+oESwDRMIG5O4Ue3s03VoISrHHs/Nw++40yMjpQZgalc+g8+sSQ69xwUL/CyyjDctHSMxtcaCWHIcLZotOEj4QS0GC+tRfED1YtPpTtT9cuuz9FUh/3f4tIxnGANC/Ve7Plmq4aCPlPeydrDdS0xnSnQgnBiUpmsIIxlYXcxKUxpeTqe5i361ubSMfUWieOqmViWg0eCYWvKn6q1EGLblhbCT5+BOMKELUgVcHjwinFi1Vo5kYI6cP7EqmFiwxSTkiZLh3CMs7SZLbx7PILJK6TdNYlk7t3jIbt6HY7VETyCtSZJj5PagDKeW9jKDpQjycgR0VJspgFliRVYxk4WHe550fSJH2aX25miRUL47qrsZhbHigcU6tC6kPgk5bZN/C+TrfAUMTCNz/Onb7LuM2aDJ3/v6LCv0Um66V7UwSnwURvRBd7En8FQrMyDWLph3gQjk2vsduCL/I02UYCVtBnAG9c9GsrNu8KOow58yQz4Of+eRU8o9OD7lFp847cbMhOpZQRLVahKBFsIH6CcBHa5QkCLLCU8zpVJD0wjq6R8rbJhayrz1p3vvn7ek/zSxpDWz+lrwomy0IJtlkrxBo1ou0YnYZcl7rk66r23es0ez5JgksWnVi/JACO8wXBodg5/I4zKVhuvgLUY6vPkEr99XIs8cmBktRMsEw9986l7LgtCugNcUOGRWngntsx/pUfVeWzVm72akDBDq8Ls9Y197UJ/eL4Jk5m6jk5Om6HWoFDkCx20pL8iTOUi
 1ad4Yexv
 7F09OgjZJ9leW+orKF/wVNJqXoquDY9Y3UgH59ht2zAG5+1u05TBrcssg6+j/WDEjxMyKu9OwT81ecFfrcxM+6pkAIITABY+uM2OCo0adnDRhEKcvuf/WNI9fiOlBQctRozcrdxHNGOv13lnRYU+FhSVDoapaMsncSNUu2hYNeYiL2v7bAZr7sP9VGvQkR+J+FGmgD6GzSnG2klNrevhlQKIQcLcvE+Qh2yYzCtwQQhYEjd3BqRXque/x17ExA50WhoIk8zM1HYBFGilSqZbN5joHUSwtCT2oVb1XbgLxluSoKb6IlvHowBaMD44v0GhQTcpNZf9mb0TMWnbVWi4rpBgLMW+x4GXOF5sEELrkPmCN5vKHMQzYKVjfWJpSx8D7E4y5RzCKoMO4oHudxw7oK7NaFmJonAHRXNhDgNi/CyzffN5mSrBblQSTaHIho4J5RR1GyIbMR+Mz+zdPt/HW5tyKEZgl0Ws8fCORpP1z7IlRh+fGCtLPqIob4naIw18OOBiWBvZ7P+DmUxX2FY4lDgVBsB4aRRCiFXUenrC2t3OXHJYue3kijn+mwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> If an mmu notifier is registered for an mm while one of its page faults
> sleeps indefinitely under the VMA lock, the registration of mmu
> notifiers for every other mm can hang un-killably.
>
> mm_all_locks_mutex is shared by all mms, so its holder must not wait for
> something that has no bound.
>
> However, mm_take_all_locks() calls vma_start_write() on each VMA with the
> mutex held, and thus waits for the readers of the VMA.
>
> Since commit 4ed4379881aa ("mm: handle shared faults under the VMA lock")=
,
> such a reader can sleep in ->page_mkwrite().
>
> Consider fuse_page_mkwrite(), which sleeps until the FUSE server replies =
to
> a write request:
>
>     mm A, thread 1          mm A, thread 2         mm B
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D          =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D         =3D=3D=3D=3D
>     lock_vma_under_rcu()
>     fuse_page_mkwrite()
>       folio_wait_writeback()
>                             mm_take_all_locks()
>                               mutex_lock()
>                               vma_start_write()
>                                                    mm_take_all_locks()
>                                                      mutex_lock()
>
> Fix the issue by locking the VMAs before the mutex is taken.
>
> Additionally, make the VMA write lock killable so a fatal signal returns =
as
> quickly as possible.
>
> Finally, update the comments to reflect the change, dropping the lock
> ordering list which begs for bitrot.
>
> Note that the lock order at the top of mm/rmap.c doesn't appear to be rig=
ht
> - the hugetlb locks are taken after the VMA write locks. However, this wa=
s
> already the case, and can be addressed in a follow-up in any case.
>
> Target commit 4ed4379881aa ("mm: handle shared faults under the VMA lock"=
)
> as this is where it became possible for VMA lock readers to sleep in
> ->page_mkwrite().
>
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 4ed4379881aa ("mm: handle shared faults under the VMA lock")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/vma.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 09bbcdb4971b..f8cf319ff9cf 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2375,15 +2375,10 @@ static void vm_lock_mapping(struct mm_struct *mm,=
 struct address_space *mapping)
>   * mapping->flags avoid to take the same lock twice, if more than one
>   * vma in this mm is backed by the same anon rmap or address_space.
>   *
> - * We take locks in following order, accordingly to comment at beginning
> - * of mm/rmap.c:
> - *   - all hugetlbfs_i_mmap_rwsem_key locks (aka mapping->i_mmap_rwsem f=
or
> - *     hugetlb mapping);
> - *   - all vmas marked locked
> - *   - all i_mmap_rwsem locks;
> - *   - all anon_vma->rwseml
> - *
> - * We can take all locks within these types randomly because the VM code
> + * Mark all vmas locked, before taking mm_all_locks_mutex. Then take rem=
aining
> + * locks in the order mandated by the comment at the top of mm/rmap.c.
> + *
> + * We can take locks of the same type in arbitrary order because the VM =
code
>   * doesn't nest them and we protected from parallel mm_take_all_locks() =
by
>   * mm_all_locks_mutex.
>   *
> @@ -2400,20 +2395,24 @@ int mm_take_all_locks(struct mm_struct *mm)
>
>         mmap_assert_write_locked(mm);
>
> -       mutex_lock(&mm_all_locks_mutex);
> -
>         /*
> -        * vma_start_write() does not have a complement in mm_drop_all_lo=
cks()
> -        * because vma_start_write() is always asymmetrical; it marks a V=
MA as
> +        * VMA write locks do not have a complement in mm_drop_all_locks(=
),
> +        * because VMA write locking is always asymmetrical; it marks a V=
MA as
>          * being written to until mmap_write_unlock() or mmap_write_downg=
rade()
>          * is reached.
>          */
>         for_each_vma(vmi, vma) {
> +               int err;
> +
>                 if (signal_pending(current))
> -                       goto out_unlock;
> -               vma_start_write(vma);
> +                       return -EINTR;
> +               err =3D vma_start_write_killable(vma);
> +               if (err)
> +                       return err;
>         }
>
> +       mutex_lock(&mm_all_locks_mutex);
> +
>         vma_iter_init(&vmi, mm, 0);
>         for_each_vma(vmi, vma) {
>                 if (signal_pending(current))
>
> --
> 2.56.0
>

