Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 596F0CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E43900006; Thu, 11 Sep 2025 07:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91EFC900003; Thu, 11 Sep 2025 07:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CDC900006; Thu, 11 Sep 2025 07:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 667CC900003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:56:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AF0916047C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:56:59 +0000 (UTC)
X-FDA: 83876818158.25.C525269
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9A917C000A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:56:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GohG3hsw;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757591817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5JDZiUNGKCBItJIYOpf475ci/DywIm3cZjVabYjTYa8=;
	b=1x6GkQIS271+VyY8D8MHgLdqwQ88RS3dr29ZCRXCFFf/AeRR7TxEkpWLhnGTvcIl/+y5PE
	a16t4/Ko29z2xcJQOvz0cH9CLzaOBemkNoKFMcd1fUfNebQA8ZvNTvsJ1BKgGcc1+YeC6E
	gOc4aSmHwimRrL/Q5TiiKFJwYbAjKM0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GohG3hsw;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757591817; a=rsa-sha256;
	cv=none;
	b=2Xg1rrsLf0WqLCsow1zMrYnyFz1MJpFiadzloSrmBzAMSxggqqrpOD7R6sKwW4G0ogZ/D1
	pDTrSiVdsCK0CgbOkRuwGoerwy2IZW8UwSk7SzOWOIJko6iC1LLll8JZj8L7Pos7YSaI1f
	VCF3fY63JREyK6Um03hjjdLHetOeq4Q=
X-Gm-Message-State: AOJu0YwtUTiYrGSzg6GFpgHz9MA167ifAVTKYTpoBsbMpVdjTgMP4NMp
	O0z66F5VcCCG9kj7Ntj8QpNDtvv2raPrfloyKDfEo0XlW+C2YuEdeUqLlLCUlf8nJl6GyP+tpKx
	YxocSCr2XI20/tGrxS2iCqW06XgX7g5Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757591814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5JDZiUNGKCBItJIYOpf475ci/DywIm3cZjVabYjTYa8=;
	b=GohG3hsw6x4Khe09U/hSMvHIOzVTaAhOrX5tWDhY/W1XyN105cMyAL1VsIQW8g1vd2UeCQ
	IktS8yweer+sPo72/HDy+Mt0NXqfGUDns9UX6Ip14e1n6n9Xd0rVbT1rzibqsy6HJn9jmC
	6hnvME3REAxrrJ2J6VzCWH7uMf7fb6U=
X-Google-Smtp-Source: AGHT+IEXApRUSGqzTdz8LGQ3sqqidsvXMOn/52e45zYqOErA4zB6eInbCEGzZYysFWdiqEJmirz6NYhi3f460w6jZ4A=
X-Received: by 2002:a05:6214:b6a:b0:70d:b15e:e8ea with SMTP id
 6a1803df08f44-739494b62c2mr224021166d6.66.1757591808697; Thu, 11 Sep 2025
 04:56:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819134205.622806-2-npache@redhat.com>
In-Reply-To: <20250819134205.622806-2-npache@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Thu, 11 Sep 2025 19:56:11 +0800
X-Gmail-Original-Message-ID: <CABzRoyZCYRURSupw+XQJDmD7bpOLa7CUD9n6tzU=8A=ip=bwNw@mail.gmail.com>
X-Gm-Features: AS18NWBtFn7leMsBPpqgaxe_Sgl_E59_0tprYdbM9-D6lm5caZCPd91EJN0l5lY
Message-ID: <CABzRoyZCYRURSupw+XQJDmD7bpOLa7CUD9n6tzU=8A=ip=bwNw@mail.gmail.com>
Subject: Re: [PATCH v10 01/13] khugepaged: rename hpage_collapse_* to collapse_*
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9A917C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qpq88ff1n564hbiy416zsc7mfmtotaer
X-HE-Tag: 1757591816-475775
X-HE-Meta: U2FsdGVkX18mWjGJ/EYfH4Q8vp9b5uQxaFTsYCpEYvrnfU3yOA8x2THpsqbjzVYBBeER4oi+FGPd8IW7ygg/AqBXxnggRDyVtoKFsxFpmU1ZnVYDJnK8Z9DsTUuXrCLxVmmMFV2WPL58bLy3CU+lnbCFD3t7Igrf0F0nDXgZ+o0MntjbWOOtUS4srCAMtePT1vQVGgxtDbMjD9OGHGGKlUXzlYMdigU6v6DpuiV8gsNwjY3fIOLu0bbztjWSJ5/Hkoqz2ILIPCKxnZg91Fh+IL0DWq53brnOPIueWGGzEoz8Q4zXiapYz1x5qi2BwscFDmFiiW0JfsI12sMjOZ7bTOsl1YHPesTlMJj50rW7DP5Sh7vkKpHnvCOhGXo7Rx5EN/ihgG1g47VsGz1mneNYHzSwy16UPg9sEvO1QYr293qZ66q/ZZXNdFA710F/1GdeQo5D2m+LWrDQf8w3adx/bumm/zFwZgUHo0GbnaaoBjXoO7cuz63tQ+4yrRdzYjzsCDNB4xNrrr8SvAJ+StoS2N5q+PZ3kRKRpykwhuSqQZ4kBJKzNLTP871FjNY7x2ad3MqcAaMHZYJe/5xrxBcCrrBkqUh0DaSUIy2KTKeyXOXpocAnAnp6PfkIbXpHka9wYB4wZ8U8r/842uWaI9m8vqZOTp5u9r8SLyl3YwLC3kAy6FXp3b1inKM8WTAs4pufiUIoYQWiKAgHd7tDSLvSpBpfngYGjtXp02UQ/ACNVkZ7gwlsogGPBca8H54W+98r5Fiq+eteb2krA0QrQdflqJDEXIKhHvvGhunQFT/CJes2EPXw5JR3eIrwradpaQn/HfAzh8tjcSuIV2k258BIv0MacE7JDTQ8WIuqktfJFwBaeamg/T/hQJ7p5qhjiMqlAc+FSczaflolwTIt4/fDH7ZJz9cjDFGq6YktdbuDCGw8peCEWhixOrSksQDdUItUSKS5ojmxNXU8ahCn53S
 Gzu8K0eU
 z3yy3isdvV8GW93Ff8sCJxRjsdYyBdn6bemZP61afGPygimh34BXdp/iEJ7BIZ3zvHGURdRRh1RXWPtc4YrHIh930B9k0AzthUkwZAFVBRn3Uze5eEDGbKIePJgoH/dipbiPvOn/6/PrqHtfbzU3bYLCBDilJZrQBLSmDSWATOfhzbWaIVgRchTxB9kJRoht07OY+pL0/rD4bU/Uy2Idqn9S2vbXrWayT6IMwRPICqk+8tZil9w1oNv0cOx9j7e3bvHACnKbJMEO9Y7Mjqvnxnk5lp6QfJZbE0fPXYYC5/8+6nUt2BM7oP6UcPx4Gk2vTkt+OUd5jtAfMpNoUbcpPhYB1loICW5iFTQ+dTq+IotQzeXcah+73Sqex7Sl5PmEketm6qYm83WWJIT5jP/OeeLnQApd/NkBD8ogR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 9:43=E2=80=AFPM Nico Pache <npache@redhat.com> wrot=
e:
>
> The hpage_collapse functions describe functions used by madvise_collapse
> and khugepaged. remove the unnecessary hpage prefix to shorten the
> function name.
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers,
Lance

> ---
>  mm/khugepaged.c | 73 ++++++++++++++++++++++++-------------------------
>  1 file changed, 36 insertions(+), 37 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d3d4f116e14b..0e7bbadf03ee 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -402,14 +402,14 @@ void __init khugepaged_destroy(void)
>         kmem_cache_destroy(mm_slot_cache);
>  }
>
> -static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> +static inline int collapse_test_exit(struct mm_struct *mm)
>  {
>         return atomic_read(&mm->mm_users) =3D=3D 0;
>  }
>
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *=
mm)
> +static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  {
> -       return hpage_collapse_test_exit(mm) ||
> +       return collapse_test_exit(mm) ||
>                 mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>
> @@ -444,7 +444,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>         int wakeup;
>
>         /* __khugepaged_exit() must not run from under us */
> -       VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +       VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>         if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>                 return;
>
> @@ -502,7 +502,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>         } else if (mm_slot) {
>                 /*
>                  * This is required to serialize against
> -                * hpage_collapse_test_exit() (which is guaranteed to run
> +                * collapse_test_exit() (which is guaranteed to run
>                  * under mmap sem read mode). Stop here (after we return =
all
>                  * pagetables will be destroyed) until khugepaged has fin=
ished
>                  * working on the pagetables under the mmap_lock.
> @@ -592,7 +592,7 @@ static int __collapse_huge_page_isolate(struct vm_are=
a_struct *vma,
>                 folio =3D page_folio(page);
>                 VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>
> -               /* See hpage_collapse_scan_pmd(). */
> +               /* See collapse_scan_pmd(). */
>                 if (folio_maybe_mapped_shared(folio)) {
>                         ++shared;
>                         if (cc->is_khugepaged &&
> @@ -848,7 +848,7 @@ struct collapse_control khugepaged_collapse_control =
=3D {
>         .is_khugepaged =3D true,
>  };
>
> -static bool hpage_collapse_scan_abort(int nid, struct collapse_control *=
cc)
> +static bool collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>         int i;
>
> @@ -883,7 +883,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask=
(void)
>  }
>
>  #ifdef CONFIG_NUMA
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>         int nid, target_node =3D 0, max_value =3D 0;
>
> @@ -902,7 +902,7 @@ static int hpage_collapse_find_target_node(struct col=
lapse_control *cc)
>         return target_node;
>  }
>  #else
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>         return 0;
>  }
> @@ -923,7 +923,7 @@ static int hugepage_vma_revalidate(struct mm_struct *=
mm, unsigned long address,
>         enum tva_type type =3D cc->is_khugepaged ? TVA_KHUGEPAGED :
>                                  TVA_FORCED_COLLAPSE;
>
> -       if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +       if (unlikely(collapse_test_exit_or_disable(mm)))
>                 return SCAN_ANY_PROCESS;
>
>         *vmap =3D vma =3D find_vma(mm, address);
> @@ -996,7 +996,7 @@ static int check_pmd_still_valid(struct mm_struct *mm=
,
>
>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
> + * Only done if khugepaged_scan_pmd believes it is worthwhile.
>   *
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> @@ -1082,7 +1082,7 @@ static int alloc_charge_folio(struct folio **foliop=
, struct mm_struct *mm,
>  {
>         gfp_t gfp =3D (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpm=
ask() :
>                      GFP_TRANSHUGE);
> -       int node =3D hpage_collapse_find_target_node(cc);
> +       int node =3D collapse_find_target_node(cc);
>         struct folio *folio;
>
>         folio =3D __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nm=
ask);
> @@ -1268,10 +1268,10 @@ static int collapse_huge_page(struct mm_struct *m=
m, unsigned long address,
>         return result;
>  }
>
> -static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> -                                  struct vm_area_struct *vma,
> -                                  unsigned long address, bool *mmap_lock=
ed,
> -                                  struct collapse_control *cc)
> +static int collapse_scan_pmd(struct mm_struct *mm,
> +                            struct vm_area_struct *vma,
> +                            unsigned long address, bool *mmap_locked,
> +                            struct collapse_control *cc)
>  {
>         pmd_t *pmd;
>         pte_t *pte, *_pte;
> @@ -1382,7 +1382,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>                  * hit record.
>                  */
>                 node =3D folio_nid(folio);
> -               if (hpage_collapse_scan_abort(node, cc)) {
> +               if (collapse_scan_abort(node, cc)) {
>                         result =3D SCAN_SCAN_ABORT;
>                         goto out_unmap;
>                 }
> @@ -1451,7 +1451,7 @@ static void collect_mm_slot(struct khugepaged_mm_sl=
ot *mm_slot)
>
>         lockdep_assert_held(&khugepaged_mm_lock);
>
> -       if (hpage_collapse_test_exit(mm)) {
> +       if (collapse_test_exit(mm)) {
>                 /* free mm_slot */
>                 hash_del(&slot->hash);
>                 list_del(&slot->mm_node);
> @@ -1753,7 +1753,7 @@ static void retract_page_tables(struct address_spac=
e *mapping, pgoff_t pgoff)
>                 if (find_pmd_or_thp_or_none(mm, addr, &pmd) !=3D SCAN_SUC=
CEED)
>                         continue;
>
> -               if (hpage_collapse_test_exit(mm))
> +               if (collapse_test_exit(mm))
>                         continue;
>                 /*
>                  * When a vma is registered with uffd-wp, we cannot recyc=
le
> @@ -2275,9 +2275,9 @@ static int collapse_file(struct mm_struct *mm, unsi=
gned long addr,
>         return result;
>  }
>
> -static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long =
addr,
> -                                   struct file *file, pgoff_t start,
> -                                   struct collapse_control *cc)
> +static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> +                             struct file *file, pgoff_t start,
> +                             struct collapse_control *cc)
>  {
>         struct folio *folio =3D NULL;
>         struct address_space *mapping =3D file->f_mapping;
> @@ -2332,7 +2332,7 @@ static int hpage_collapse_scan_file(struct mm_struc=
t *mm, unsigned long addr,
>                 }
>
>                 node =3D folio_nid(folio);
> -               if (hpage_collapse_scan_abort(node, cc)) {
> +               if (collapse_scan_abort(node, cc)) {
>                         result =3D SCAN_SCAN_ABORT;
>                         folio_put(folio);
>                         break;
> @@ -2382,7 +2382,7 @@ static int hpage_collapse_scan_file(struct mm_struc=
t *mm, unsigned long addr,
>         return result;
>  }
>
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *res=
ult,
> +static unsigned int collapse_scan_mm_slot(unsigned int pages, int *resul=
t,
>                                             struct collapse_control *cc)
>         __releases(&khugepaged_mm_lock)
>         __acquires(&khugepaged_mm_lock)
> @@ -2420,7 +2420,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>                 goto breakouterloop_mmap_lock;
>
>         progress++;
> -       if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +       if (unlikely(collapse_test_exit_or_disable(mm)))
>                 goto breakouterloop;
>
>         vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2428,7 +2428,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>                 unsigned long hstart, hend;
>
>                 cond_resched();
> -               if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +               if (unlikely(collapse_test_exit_or_disable(mm))) {
>                         progress++;
>                         break;
>                 }
> @@ -2449,7 +2449,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>                         bool mmap_locked =3D true;
>
>                         cond_resched();
> -                       if (unlikely(hpage_collapse_test_exit_or_disable(=
mm)))
> +                       if (unlikely(collapse_test_exit_or_disable(mm)))
>                                 goto breakouterloop;
>
>                         VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2462,12 +2462,12 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
>
>                                 mmap_read_unlock(mm);
>                                 mmap_locked =3D false;
> -                               *result =3D hpage_collapse_scan_file(mm,
> +                               *result =3D collapse_scan_file(mm,
>                                         khugepaged_scan.address, file, pg=
off, cc);
>                                 fput(file);
>                                 if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
>                                         mmap_read_lock(mm);
> -                                       if (hpage_collapse_test_exit_or_d=
isable(mm))
> +                                       if (collapse_test_exit_or_disable=
(mm))
>                                                 goto breakouterloop;
>                                         *result =3D collapse_pte_mapped_t=
hp(mm,
>                                                 khugepaged_scan.address, =
false);
> @@ -2476,7 +2476,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>                                         mmap_read_unlock(mm);
>                                 }
>                         } else {
> -                               *result =3D hpage_collapse_scan_pmd(mm, v=
ma,
> +                               *result =3D collapse_scan_pmd(mm, vma,
>                                         khugepaged_scan.address, &mmap_lo=
cked, cc);
>                         }
>
> @@ -2509,7 +2509,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>          * Release the current mm_slot if this mm is about to die, or
>          * if we scanned all vmas of this mm.
>          */
> -       if (hpage_collapse_test_exit(mm) || !vma) {
> +       if (collapse_test_exit(mm) || !vma) {
>                 /*
>                  * Make sure that if mm_users is reaching zero while
>                  * khugepaged runs here, khugepaged_exit will find
> @@ -2563,8 +2563,8 @@ static void khugepaged_do_scan(struct collapse_cont=
rol *cc)
>                         pass_through_head++;
>                 if (khugepaged_has_work() &&
>                     pass_through_head < 2)
> -                       progress +=3D khugepaged_scan_mm_slot(pages - pro=
gress,
> -                                                           &result, cc);
> +                       progress +=3D collapse_scan_mm_slot(pages - progr=
ess,
> +                                                         &result, cc);
>                 else
>                         progress =3D pages;
>                 spin_unlock(&khugepaged_mm_lock);
> @@ -2805,12 +2805,11 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
>
>                         mmap_read_unlock(mm);
>                         mmap_locked =3D false;
> -                       result =3D hpage_collapse_scan_file(mm, addr, fil=
e, pgoff,
> -                                                         cc);
> +                       result =3D collapse_scan_file(mm, addr, file, pgo=
ff, cc);
>                         fput(file);
>                 } else {
> -                       result =3D hpage_collapse_scan_pmd(mm, vma, addr,
> -                                                        &mmap_locked, cc=
);
> +                       result =3D collapse_scan_pmd(mm, vma, addr,
> +                                                  &mmap_locked, cc);
>                 }
>                 if (!mmap_locked)
>                         *lock_dropped =3D true;
> --
> 2.50.1
>
>

