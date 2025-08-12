Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E5AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 14:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EDB8E014B; Tue, 12 Aug 2025 10:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E166D8E00B0; Tue, 12 Aug 2025 10:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05658E014B; Tue, 12 Aug 2025 10:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0708E00B0
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:44:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 40BF8116A37
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:44:33 +0000 (UTC)
X-FDA: 83768376426.02.1AF1DD5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1607180005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:44:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f3RaPM4D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755009871; a=rsa-sha256;
	cv=none;
	b=Tdx/Olp4a9v8bUY+59ykuTr/83V7hcWxilPDIp5QC+S0QXgOFkgtFicE5qG4U2Qj0HLg/g
	IFwE/mtiShpW2N64AntJQmwTlxPUPyZnbnBo25J0VoaAI1OlS+lvJJAijwDXc1YI3VS9TX
	/esYzsOMNA/ZpnUAwXLD11UijQAB3Pc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f3RaPM4D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755009871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLLcNx5rUVjSB6a5QhKP843kVJWKb0b8D2KnjHFIuZE=;
	b=1Bc7Oy0XLG8yNIsKq7aSju/YgSeP27A0ICFanKAIXsZq+dW3GRY3k1yFLjaG7xKjl4DUU8
	dUfvey/isUayv+FHt6PYwSQ1bL1+PQ+hEgL52qcJyWEea7Wro2BDXvhpUenQZ9zbr1tUdQ
	7ATlXLXR8yaa3YOsy5axvW48taXqf0Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755009870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZLLcNx5rUVjSB6a5QhKP843kVJWKb0b8D2KnjHFIuZE=;
	b=f3RaPM4DZc13mbj06ZPP4TAFCaDyEmggec0ER4q/QUHFOHUfgt1uk3mxcXXitTX52VcRi6
	8IQBAQFk3w+PheDFm0bpaOHTIdHVUhXN7+Qh6TAg/7qCe5g5ibu5vvOahYRy2gXFF0oXie
	W63YhI2f2nxZOxdxERAYE7cjnsatb1E=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-w2iK3NA3OWiK62VHmzVHeA-1; Tue, 12 Aug 2025 10:44:28 -0400
X-MC-Unique: w2iK3NA3OWiK62VHmzVHeA-1
X-Mimecast-MFC-AGG-ID: w2iK3NA3OWiK62VHmzVHeA_1755009868
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7e82b8ea647so1164769085a.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 07:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755009868; x=1755614668;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLLcNx5rUVjSB6a5QhKP843kVJWKb0b8D2KnjHFIuZE=;
        b=ofONTgXskRAzmEKtlkqqzRdxLK3uDShBEwH837FnkR2JxaN06gH6hmrPuI+uwa6C2n
         /ABd+dVowxyNNalGZy+6358Ea44EkSKaR4Yx+4RQ1Bi8NKVYy79/3Rljg6kGMX9mfyuk
         v/G64RgrFrmaRCMTnErK21QfnSPPNaElwfAqvODf7WnPzWbwV79aNDf+6gcV4kaA+Q2s
         Hc5Fqg6Dv7f20O3rYUfIuUlh0JN4f1XOnYAJ9u0vY8NJniOZDkI6EaLLL3xHeUHydb4k
         wmQdhVqxasvvzCEE6hQx+DMySk2QyugFQSjBiSluqULtWydyDZKA/tuTTRiu4Rlt20RX
         HuLg==
X-Forwarded-Encrypted: i=1; AJvYcCVm4KdaoUccf7GHSOYkSjoqy2pnb6NgvJApDIO6W5YByhHgAxQW65go7K6bPHLSdkraDciVbkFxCA==@kvack.org
X-Gm-Message-State: AOJu0YxQyStWzQHg4hY18ydk6Td/R3Zc+tJKNx6QiIEpHgjcuwKWsyG/
	m5boFYck40/oWT0lZQ8E+anKaDNrIx4TsHyKhO4+W94aJolljKuM46HQ2ylHknR62wzNGP9y2bf
	EUfaOurruqZesf3LHiIF7U2zNx5Hc/vHvH0gbWVJiwpiVrluj7IMq
X-Gm-Gg: ASbGncvCQmAmBsND8yJ7dCCmA5mfRGt3EeQyVD4/AYEWkxK0QN9Bni3GfcHEXjtHFOk
	NLX2cCpb9w6vsezPLYL0ONsBVvaPLT0wBu78oRoZ4ZBscn7b7JX/BKNUQCn28ipaKXzu1FKOUKA
	G8XnNgNryJVNNkbDywcXcnJNR9sZRBr9P0gTJH7mQaltQ+5POgqItWt9dwZy2lsid35AhkTKj4Z
	L2+WYNsywY5Rq0eBYctd07WN/SF0xWW5dWUtX7NNyENSB1kRC8NY46dLp4RMez97oUqq5vBUkC+
	l5RXV7eaR3Xgj2tcs0Z1Rw+KTg7dB5X0
X-Received: by 2002:a05:622a:447:b0:4b0:7327:1bed with SMTP id d75a77b69052e-4b0ec98cb3cmr36006271cf.1.1755009868107;
        Tue, 12 Aug 2025 07:44:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEW+Q4suIFY7HXceW95xp4YuQL9IQHdbxyoR0crEXcoT6UOm7JtlKpI2ViaCfT/cx+pZ6nmiw==
X-Received: by 2002:a05:622a:447:b0:4b0:7327:1bed with SMTP id d75a77b69052e-4b0ec98cb3cmr36005911cf.1.1755009867642;
        Tue, 12 Aug 2025 07:44:27 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b085586307sm105898441cf.56.2025.08.12.07.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 07:44:26 -0700 (PDT)
Date: Tue, 12 Aug 2025 10:44:14 -0400
From: Peter Xu <peterx@redhat.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>, akpm@linux-foundation.org,
	aarcange@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ngeoffray@google.com,
	Suren Baghdasaryan <surenb@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
Message-ID: <aJtTPkenKeFuFFNQ@x1.local>
References: <20250810062912.1096815-1-lokeshgidra@google.com>
 <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4wbXkfaAn+79g20SfE-0Ak4QACVP+Mw2vAvMnxBCcLAsQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zFQ13SYlVL1S1SS2rFMaNM6ZrA1HZZWC2oSdLJbRmi4_1755009868
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qz46gxjzxbrdb7tqjtbe7tzd4bt8ddgh
X-Rspam-User: 
X-Rspamd-Queue-Id: C1607180005
X-Rspamd-Server: rspam02
X-HE-Tag: 1755009870-383729
X-HE-Meta: U2FsdGVkX18O1WpT5uZhrs3qhDwEtzh32P7h1Qvx6SrwL3h9YWcoD6UAmUOgUdvauj40NWwSgK62H2kcJg8MLmhLCK8G5+OiSSBqMaEeNpsLE+9gFXXYDuBzg6p+0tKmGBHPKBTtzak1buvIPFVfUOnJb2ZzZnkYJ3bSnJ8rTjFFcaZ+2FLaLgzEe+6IJ95Np5PTWIV46vm1nuapS4XCtfCnBPJH7t7FfdIRupP/BI7m2Ifneb8SHMwtlrvoIOBO3BqwP/aP5SGGb75E0ypPxDDt+JE84syJbjQ8BhD7QKk1WXS9QkcLaGHAlEOUBfDhRy4qaWVbo9syL6ycXQPXu+46HyxUEfSi2+USQ0Bf4cGoMZa8wGHnL6uZYjZSvSy0Vi0ALaWJkp7BafPs46sf9wrtAe3m7nrNc0FeCIAmymJAfkTqDT5Q6ZsiLb2lGQ2Kn9aCCkf7AOuTonhyU8MxjZeyKv3nYQFZiFK1UIA8F2v0TMGEwljAyVaZbt1EmHHx5BWjbsDLmaR5yvuL5fGyHDUXxkdNx2jVKyYd3I20iHcVtt0mAylfHFD6p4LQCfWRzBj+CueADHy8wL09QH3+JWRk4gXE8Q5ZTo15fD2KnP7j0jwbe3FhWjckFUbdvO0HrAme3oYSgYoC1ogejFqGwgWtCUl1e8XQR17mFhboaD5m023MCPmNul9AtTCcCzyNXAhKqv3ooNVDwuFHaX/80q7dBitdzGsZJPyoJIDN6qx77G2o+QVKmL//8Wp9M62GVB6fvNIbQFukZhsvk0y2JpVw1GCXXwfofG0DiMfPh3QGmZ21KxM+BYIvXTid9W0feRATjzWo+55E1h5Q+fArR9aBWtu5WtWxH9UfWKTNu/gKuNBqT4+VSYUc2BteN3jT9/werBjhkCpFa5Vbf0cVb2HAQ/k9BdQes3qQZ7yV6cCZCV8aUDF3wGkfq67isvbJOeGzzzFfF6i3FXWlzJE
 5jqUKqg9
 6qhEUkmwEhcvn9qb6edzuNt7q/lZrPWIsM89kv1g5IpkiqTWDEz1UnS9uSN2p2tjYynR/NaSBO+qkqyvBhpXPfk73BLA16q8Z/ngXBmn3omK2c118oItbb+gHlEWECtSIZv5lGRqv1qKv4gBw2ZTwsRamOsqp3Wzaxu8QWPkOVwlxrlBLZnu5WiWdeg+X5GjR2MVuhDI5Ui3k+moAP59e0qWZQFtRz/1UErPCPgDXX72AwmjE5cVytWk+aCURR4Huiq+ahUNV+tuXIQHMNXDA5Uj1dU2dwpTepMK4lt0ilNqR04TA5m+RuQZqfKw+aKvGedOv57v7486MKWCLuXU34fB1HCsqTU4Au0nXkBCaxEilC11/lv9I7T7qtTKpgussP3DdBgX5mDZqjB64rzwhO12n9XgabD+C6G7sJFMToN9Os+YoKOfd949mtgE43K2Mg1SEQPgBREIjjCs2dWqkR1XPA/+FjOyRBdvjcbjC6t6THM640CkEbMIwZDC4GBECTwQy1mPDLAZMBNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:55:36AM +0800, Barry Song wrote:
> Hi Lokesh,
> 
> 
> On Sun, Aug 10, 2025 at 2:29 PM Lokesh Gidra <lokeshgidra@google.com> wrote:
> >
> > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > for moving present pages. Mitigate this cost by opportunistically
> > batching present contiguous pages for TLB flushing.
> >
> > Without batching, in our testing on an arm64 Android device with UFFD GC,
> > which uses MOVE ioctl for compaction, we observed that out of the total
> > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > ~20% in vm_normal_folio().
> >
> > With batching, the proportion of vm_normal_folio() increases to over
> > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > includes TLB-flush overhead.
> >
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Kalesh Singh <kaleshsingh@google.com>
> > Cc: Barry Song <v-songbaohua@oppo.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > ---
> > Changes since v3 [1]
> > - Fix unintialized 'step_size' warning, per Dan Carpenter
> > - Removed pmd_none() from check_ptes_for_batched_move(), per Peter Xu
> > - Removed flush_cache_range() in zero-page case, per Peter Xu
> > - Added comment to explain why folio reference for batched pages is not
> >   required, per Peter Xu
> > - Use MIN() in calculation of largest extent that can be batched under
> >   the same src and dst PTLs, per Peter Xu
> > - Release first folio's reference in move_present_ptes(), per Peter Xu
> >
> > Changes since v2 [2]
> > - Addressed VM_WARN_ON failure, per Lorenzo Stoakes
> > - Added check to ensure all batched pages share the same anon_vma
> >
> > Changes since v1 [3]
> > - Removed flush_tlb_batched_pending(), per Barry Song
> > - Unified single and multi page case, per Barry Song
> >
> > [1] https://lore.kernel.org/all/20250807103902.2242717-1-lokeshgidra@google.com/
> > [2] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@google.com/
> > [3] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@google.com/
> >
> >  mm/userfaultfd.c | 178 +++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 127 insertions(+), 51 deletions(-)
> >
> > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > index cbed91b09640..39d81d2972db 100644
> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
> >                pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
> >  }
> >
> > -static int move_present_pte(struct mm_struct *mm,
> > -                           struct vm_area_struct *dst_vma,
> > -                           struct vm_area_struct *src_vma,
> > -                           unsigned long dst_addr, unsigned long src_addr,
> > -                           pte_t *dst_pte, pte_t *src_pte,
> > -                           pte_t orig_dst_pte, pte_t orig_src_pte,
> > -                           pmd_t *dst_pmd, pmd_t dst_pmdval,
> > -                           spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > -                           struct folio *src_folio)
> > +/*
> > + * Checks if the two ptes and the corresponding folio are eligible for batched
> > + * move. If so, then returns pointer to the locked folio. Otherwise, returns NULL.
> > + *
> > + * NOTE: folio's reference is not required as the whole operation is within
> > + * PTL's critical section.
> > + */
> > +static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
> > +                                                unsigned long src_addr,
> > +                                                pte_t *src_pte, pte_t *dst_pte,
> > +                                                struct anon_vma *src_anon_vma)
> > +{
> > +       pte_t orig_dst_pte, orig_src_pte;
> > +       struct folio *folio;
> > +
> > +       orig_dst_pte = ptep_get(dst_pte);
> > +       if (!pte_none(orig_dst_pte))
> > +               return NULL;
> > +
> > +       orig_src_pte = ptep_get(src_pte);
> > +       if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_pte)))
> > +               return NULL;
> > +
> > +       folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
> > +       if (!folio || !folio_trylock(folio))
> > +               return NULL;
> > +       if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
> > +           folio_anon_vma(folio) != src_anon_vma) {
> > +               folio_unlock(folio);
> > +               return NULL;
> > +       }
> > +       return folio;
> > +}
> > +
> 
> I’m still quite confused by the code. Before move_present_ptes(), we’ve
> already performed all the checks—pte_same(), vm_normal_folio(),
> folio_trylock(), folio_test_large(), folio_get_anon_vma(),
> and anon_vma_lock_write()—at least for the first PTE. Now we’re
> duplicating them again for all PTEs. Does this mean we’re doing those
> operations for the first PTE twice? It feels like the old non-batch check
> code should be removed?

This function should only start to work on the 2nd (or more) continuous
ptes to move within the same pgtable lock held.  We'll still need the
original path because that was sleepable, this one isn't, and it's only
best-effort fast path only. E.g. if trylock() fails above, it would
fallback to the slow path.

> 
> > +static long move_present_ptes(struct mm_struct *mm,
> > +                             struct vm_area_struct *dst_vma,
> > +                             struct vm_area_struct *src_vma,
> > +                             unsigned long dst_addr, unsigned long src_addr,
> > +                             pte_t *dst_pte, pte_t *src_pte,
> > +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > +                             spinlock_t *dst_ptl, spinlock_t *src_ptl,
> > +                             struct folio **first_src_folio, unsigned long len,
> > +                             struct anon_vma *src_anon_vma)
> >  {
> >         int err = 0;
> > +       struct folio *src_folio = *first_src_folio;
> > +       unsigned long src_start = src_addr;
> > +       unsigned long addr_end;
> > +
> > +       if (len > PAGE_SIZE) {
> > +               addr_end = (dst_addr + PMD_SIZE) & PMD_MASK;
> > +               len = MIN(addr_end - dst_addr, len);
> >
> > +               addr_end = (src_addr + PMD_SIZE) & PMD_MASK;
> > +               len = MIN(addr_end - src_addr, len);
> > +       }
> 
> We already have a pmd_addr_end() helper—can we reuse it?

I agree with Barry; I wante to say this version didn't use ALIGN() that I
suggested but pmd_addr_end() looks better.

Other than that this version looks good to me (plus the higher level
performance results updated to the commit message, per requested in v3),
thanks Lokesh.

-- 
Peter Xu


