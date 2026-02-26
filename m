Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A918FD9E0C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A66B6B0202; Thu, 26 Feb 2026 15:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683666B0203; Thu, 26 Feb 2026 15:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588DE6B0204; Thu, 26 Feb 2026 15:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 428706B0202
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:21:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FA1DB50FD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:21:30 +0000 (UTC)
X-FDA: 84487727940.09.A5E869A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id E1C0E40013
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:21:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AONXE8Kj;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772137288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuUT6ttU4JUu+7YnbkAm0OY0100H8afFpF1ksWTWIMQ=;
	b=uFeEUD3PNl67kEdLfiOMX3d/nFTkcUXI6zDOcMajqO+2zCqEplr7wyj0byJBjgOCBkNBXA
	17+iBJClqw4nyeZYjQUv0Q+/6vyggC699dMGDZrUrihNmNg+uibBMMhipxbB+mT4jqR4Ak
	EpLTNuWG5OsK792dO0faji7Yuu7yPsI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AONXE8Kj;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772137288; a=rsa-sha256;
	cv=none;
	b=Q50ar2ii40gYgZYgnKZIuNqTRmiEpbDjMJSehnGmQQ2uJhwYtWfj1ozwkr+t8VWc0LNLQf
	DVWP1ZESoUpNI30W8/pKnOtXtHj552Ze2zKbMEY4C2OAK53+STe2KaK3OLNt6kweRj/iIt
	nL5vXHRpQ0CppUc+icC1zkiM1BOA408=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772137287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuUT6ttU4JUu+7YnbkAm0OY0100H8afFpF1ksWTWIMQ=;
	b=AONXE8KjATvp1LGXlRZS7Bi5wg6DUnVY5yReXB7uckyXg1wBUyrRcv41YBSwzY90GY7GgO
	zCDw6fRBp8Cq+Gq5HInJOlsyKyjLnH4h9Skcx0JwbUhPglgwwtpXx0MVVibTpzBGpIUbOS
	FWRkZtRniKOoBZuTdVi4dN9pBmlDx5M=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-Rvu-H0s0N2mTx5okWL-JFg-1; Thu, 26 Feb 2026 15:21:26 -0500
X-MC-Unique: Rvu-H0s0N2mTx5okWL-JFg-1
X-Mimecast-MFC-AGG-ID: Rvu-H0s0N2mTx5okWL-JFg_1772137284
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-64caa85b132so1785797d50.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:21:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772137284; x=1772742084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OuUT6ttU4JUu+7YnbkAm0OY0100H8afFpF1ksWTWIMQ=;
        b=v7/R8woJRlxYFp2edZHKAvtVsawIo7qEbdcGviS57wgPkmecd+KZGSz8ugVKLnoBva
         KH7g00XX4m0AFvsnI/zbHctJqOMSUV1QskWQvu6tYgjnr9ns+iLsOffkWVKpgFQHxhmB
         hB12vJEdNc0X9FLAMLjUZywtSc6Jgo6gmkw1+bciAZkBy/o8LiXxlioKA3OhOVC09O4M
         byCBSe9e+cTYi7wOvElz/Qjb/m4Y2TpqyARjJmTpEp7G/Bwv9jvLCB49H2r1SpApUPs/
         g0Wc7hT/KbDEIZBVBB3wWi2lntkvZppY8/3L193DNg+5auqeKG1HZ9cgBYRSg/K8um//
         PK4w==
X-Forwarded-Encrypted: i=1; AJvYcCWYREExBkd9Trgi9r3r+EBAEXKXT8C4Dg+Fja5lfqmdClaJcUDK21TIpYtua+VCjRwQc2BA9LC0Iw==@kvack.org
X-Gm-Message-State: AOJu0YyAXwHuZQZ6N7y6PULAU/8hw1Ab2m66LeFTMrN0WBNRcE2fK9s0
	+AAILM9HaAfn1nsmC9yRNsOB4w9lT8TbqMsk8q25qPCEQ5MkeiX95zvkU4aYJLU8JptDcPLqT0G
	ethefsPGA3lYCIHdOwsf0g0feIkjGw5RgNVMLyR9BFBXI6l7UzP+GgKGpyqlI2aTNQVoOUq7v7V
	QM6AckkOdO+sMlGgQzZxT6m//yUZY=
X-Gm-Gg: ATEYQzw+3mroYeeu54hgPJ4kg8mPSZgQEVKeQ6BnPvbNNVRn8WuDQrphkp0LtAJWvKi
	uRfSedJrXyofqYWMhsGKImJRZPJCg2XMPTThzyorcz+jZeb8mPGPKJZt0VLBIUXtren386VouNm
	U8kV0+FLSYRIZq5VV90Xcm62dL2oWm5ALOedI3fkw+j9QvL2+c0mquu56fpv48KlfEeSyibGSxb
	ss1
X-Received: by 2002:a05:690e:1a85:b0:64a:cee0:fa8 with SMTP id 956f58d0204a3-64cc23434b1mr419309d50.88.1772137284566;
        Thu, 26 Feb 2026 12:21:24 -0800 (PST)
X-Received: by 2002:a05:690e:1a85:b0:64a:cee0:fa8 with SMTP id
 956f58d0204a3-64cc23434b1mr419253d50.88.1772137283976; Thu, 26 Feb 2026
 12:21:23 -0800 (PST)
MIME-Version: 1.0
References: <20260226012929.169479-1-npache@redhat.com> <20260226012929.169479-6-npache@redhat.com>
 <60e44957-b816-4f7e-b004-4e957a67fe12@linux.alibaba.com>
In-Reply-To: <60e44957-b816-4f7e-b004-4e957a67fe12@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
Date: Thu, 26 Feb 2026 13:20:57 -0700
X-Gm-Features: AaiRm53Me-8fM5QXkOAdd9G9REAo0qDWjRpQ1RLCmd1oOD2Zvo593rtgeJ1DgoI
Message-ID: <CAA1CXcBD6paPH30_Tcsa5mvFxRQetZhAAh+3kX99zbN8KYXrSw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6umhsh9rhnfXWDB0h69KXlrYZxArF5gyUZPY9m_R7eY_1772137284
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E1C0E40013
X-Stat-Signature: igm5hbphiyfgp113ydi7eehjcz3knjqe
X-Rspam-User: 
X-HE-Tag: 1772137287-903050
X-HE-Meta: U2FsdGVkX19EpHUZ6s9wHrXgdVYOJ7/eS99IBGYYhW5wkoxvKdRdYFKoqNFCPTsC1RnPEeQ+HGka0+EjUg1GlOIT5qb+Is9N7AiRxKIuLvbYG+8JqQXEiHX+ZrOwXLLlRfvvZ2ZI9XUXQuMSe9J7TxelXoz5w0fXloE5+5Lpu50nKaLOr8pwQoHj60sOiFtRURJ5CgZDls/ROtBbo5GRoPYjxnIPq7/THqmPRcuMHc9IucZKc1w8rGass5RAG6Ofb8MOVTVZNiPs7+MZIkNRFqcI11z9voTDVuCvVc/khGj+1OQekWOmiK2EZSULus6abz61Y7RAdDXXRSSFNeLJ0+Qe6YfHNiDI5OEvXVo3sS9yUhd/KPw5Wx+laCNCvXHFA0xmPYTTtSM/j5R9p7egsKEsoUzSa92hR3BCX+zkHbiail/ZXzgKHtPNi2H9MiJ7WCnmvLQ3pYX59d5m6cTDlMW9YpN4ZhxJiVcGwj6vd4I0ZdQH9XZBqAclZpOIoAKQs3my5qvvFOeNXuDvs/pMZS+BO4r/oK0C0eu84/UUN/ldUulmEBAUP1fSs40Km/B2nw4V52YlMGBJOTn3+OsXGEti9CAgJY9aVx0NH5szeBacw9Mr8cHVH7v1AWCGIbNGw83a+KYgclxRIl0P8D6TqHSGQUCUcjwxuzoyZIUyNzANZWQmz2taf4mjXQOtxYD18lq6O4y10gDMMECbOi4UYrDqESfdG7YQHl0ss9dV1NvCUIBEeduRg/rEnfEw9FJFp7w1u9aygxaz/YVVQeObSAjrcpemlspBS2RKesioW+8IQeSc7i/0ef6b8zlEvxAX6KI0YzSAyW8DgPCYuTggU1CG3CsNUhd8MSDcncE+Octe5g9DPCKxiPGWtUhoaM9Da6cgCr/g3Hg/VT6HTLGlU7SM3EO8K1G1kQcnLI7wtMwPywwHWKWkPoPeLieAqJUfNj26hgyFWSQfjxaWKKV
 sDFsNjoU
 IwCTnSSIXddKMm9dyUZ8ljqN43/jpX/xUtqRtfkNhontVMpeM21ie+gtJIK1UKdOuWDEnAf8uodDA6HJe500mecNkeZl1rXkD22o9kizWhvlIsK4BA/CmyTGNyJwkZUwtj88pLZ3qGCjIxoXCeb/rL1Rdwen3Z64V/4ind3JjQxzpBX4Pgwg2aT7vKU7/mhxquxRXkAvHtqy0FT3/2AwNQm/kDhvG3kOVpZut2202ctZ3qS6Lf2yQFYaLXYKKvftNQE9Jo9UNMiztp9KiRzkUR/4KxyoVH7hCOjF9Y7UW9wFVTgzJvWsq+Rfinop7sw5pdwgRppFO/KCFpWp72etQiMiLU7bU+dapAWpssDtqNzOfgXoNuCJn3qAP9SQvqaxYHGMyvMngvp7hPC9MmA3HDqJyhbsOHCUAgf1P+3WwyvPMUh/jozhLw+6l7lJaI/Qm4GT49NFLR2gclvTPk6qQh+/DletnHWr+EhSANxQ+uc1EEyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 2:24=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 2/26/26 9:29 AM, Nico Pache wrote:
> > The khugepaged daemon and madvise_collapse have two different
> > implementations that do almost the same thing.
> >
> > Create collapse_single_pmd to increase code reuse and create an entry
> > point to these two users.
> >
> > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > collapse_single_pmd function. This introduces a minor behavioral change
> > that is most likely an undiscovered bug. The current implementation of
> > khugepaged tests collapse_test_exit_or_disable before calling
> > collapse_pte_mapped_thp, but we weren't doing it in the madvise_collaps=
e
> > case. By unifying these two callers madvise_collapse now also performs
> > this check. We also modify the return value to be SCAN_ANY_PROCESS whic=
h
> > properly indicates that this process is no longer valid to operate on.
> >
> > We also guard the khugepaged_pages_collapsed variable to ensure its onl=
y
> > incremented for khugepaged.
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
>
> [snip]
>
> >       for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
> >               enum scan_result result =3D SCAN_FAIL;
> > -             bool triggered_wb =3D false;
> >
> > -retry:
> >               if (!mmap_locked) {
> >                       cond_resched();
> >                       mmap_read_lock(mm);
> >                       mmap_locked =3D true;
> > +                     *lock_dropped =3D true;
> IIUC, this should be '*lock_dropped =3D false', right?

Yes! Thanks for catching that :) As David and others have pointed out,
this lock handling here might be unnecessary and better placed in
collapse_single_pmd(). I meant to look into that before posting this
but it slipped my mind.

>
> >                       result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
> >                                                        cc);
> >                       if (result  !=3D SCAN_SUCCEED) {
> > @@ -2836,46 +2872,20 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >                       hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
> >               }
> >               mmap_assert_locked(mm);
> > -             if (!vma_is_anonymous(vma)) {
> > -                     struct file *file =3D get_file(vma->vm_file);
> > -                     pgoff_t pgoff =3D linear_page_index(vma, addr);
> > -
> > -                     mmap_read_unlock(mm);
> > -                     mmap_locked =3D false;
> > -                     *lock_dropped =3D true;
> > -                     result =3D collapse_scan_file(mm, addr, file, pgo=
ff, NULL, cc);
> >
> > -                     if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &&=
 !triggered_wb &&
> > -                         mapping_can_writeback(file->f_mapping)) {
> > -                             loff_t lstart =3D (loff_t)pgoff << PAGE_S=
HIFT;
> > -                             loff_t lend =3D lstart + HPAGE_PMD_SIZE -=
 1;
> > +             result =3D collapse_single_pmd(addr, vma, &mmap_locked, N=
ULL, cc);
> >
> > -                             filemap_write_and_wait_range(file->f_mapp=
ing, lstart, lend);
> > -                             triggered_wb =3D true;
> > -                             fput(file);
> > -                             goto retry;
> > -                     }
> > -                     fput(file);
> > -             } else {
> > -                     result =3D collapse_scan_pmd(mm, vma, addr, &mmap=
_locked, NULL, cc);
> > -             }
> >               if (!mmap_locked)
> >                       *lock_dropped =3D true;
> >
> > -handle_result:
> >               switch (result) {
> >               case SCAN_SUCCEED:
> >               case SCAN_PMD_MAPPED:
> >                       ++thps;
> >                       break;
> > -             case SCAN_PTE_MAPPED_HUGEPAGE:
> > -                     BUG_ON(mmap_locked);
> > -                     mmap_read_lock(mm);
> > -                     result =3D try_collapse_pte_mapped_thp(mm, addr, =
true);
> > -                     mmap_read_unlock(mm);
> > -                     goto handle_result;
> >               /* Whitelisted set of results where continuing OK */
> >               case SCAN_NO_PTE_TABLE:
> > +             case SCAN_PTE_MAPPED_HUGEPAGE:
> >               case SCAN_PTE_NON_PRESENT:
> >               case SCAN_PTE_UFFD_WP:
> >               case SCAN_LACK_REFERENCED_PAGE:
>


