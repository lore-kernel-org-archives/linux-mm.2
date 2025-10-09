Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD88CCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 12:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5428E0092; Thu,  9 Oct 2025 08:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C278E0002; Thu,  9 Oct 2025 08:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9538E0092; Thu,  9 Oct 2025 08:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F04C38E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 08:14:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94A385B94E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:14:16 +0000 (UTC)
X-FDA: 83978468112.24.E593627
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7506B40012
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:14:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g4nK0Y7p;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760012054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CUMZSpWPXzOS4pPPjCA/cHJPYX+kTpvk7j8DvEy4eQ=;
	b=d8Qyip58L7GQB/fmGRicT7JfaGUQwED6njyEYSl+qreXXVrkyB+SvdgE54j+8BlsL2O6Np
	DqeKA13Fz/h04dWLWOvJtEuPKqIKInz1bzKLtiTQNqJIYytn/7h/blaJJQDe7gBS5dZk07
	d69VikHY7Vo/QP8WDSg0gzFlMM2h6lE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g4nK0Y7p;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760012054; a=rsa-sha256;
	cv=none;
	b=wk61vKaJEAsrX0VQ1DhvK/WB74LPx7Vwi/v140NEQVPas4X2Ojx5Jb3AohDjMCc8UYm3W4
	WrxGsv3tHcbX9dKVk32/+zFcJ6TKLgAcAb8M76RyWEjQv/tebCSAbbOrG4dX/bSihRN7PD
	9ts2dHM8mEwrZrtEj/exMDDyPJJpctc=
X-Forwarded-Encrypted: i=1; AJvYcCXbqLR9HebcwAfDpbxJThwHt+3GWL7rlaLCjyQLdk0wioEWhZWI4L7KnXxy6RAfP/nYRkNVbwHXpw==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760012052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4CUMZSpWPXzOS4pPPjCA/cHJPYX+kTpvk7j8DvEy4eQ=;
	b=g4nK0Y7pSGChx42lsav5po4dImPgYgEdEMPK6q9mlZDc9BuifL4yRB2q3UwS6aitsG/1af
	gaC2cRej4Jn7KODT5daf1FS5W6eZLIfrFEuN87WiqpYQ/dLfcwi8KlquZzS7Y2LFNW0Bbl
	t05JoN959EvaBlXX0xNBh33T2wKXLuY=
X-Gm-Message-State: AOJu0YxeuFwmXEg5/LgvqZa8c5Ij7N4vVVb1kqPE3fuOWxv24jYZONQW
	r1rXocbImxY6M31t5Oyfl7DFlJlnkE3V2MmR3px84ZAclZu4qe/CK2JiAaIHEVFxlMZ6BNuBKCM
	NZ4JqQl+V5KQBO/QcOSwEgc0GjnKbnwQ=
X-Google-Smtp-Source: AGHT+IFyFmFwcV7VuN+oua1WO4Y4b9JOuSOx0GHrGSeP3Vz0UaQD1TeBB9STI2EBt42s1mOhK1VYbR5qXSf4vqmGaTU=
X-Received: by 2002:a05:6214:d6b:b0:820:a83:ead4 with SMTP id
 6a1803df08f44-87b20fede09mr87452386d6.1.1760012050318; Thu, 09 Oct 2025
 05:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <20251009070045.2011920-1-xialonglong2025@163.com> <20251009070045.2011920-2-xialonglong2025@163.com>
In-Reply-To: <20251009070045.2011920-2-xialonglong2025@163.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Thu, 9 Oct 2025 20:13:33 +0800
X-Gmail-Original-Message-ID: <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
X-Gm-Features: AS18NWBIS184i6Kf0xw-Zy5px1Iv8SQwsppEhVOgel2w0XXUt5odRjDwHcgQWGE
Message-ID: <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory failures
To: Longlong Xia <xialonglong2025@163.com>
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	david@redhat.com, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Longlong Xia <xialonglong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7506B40012
X-Stat-Signature: yp35tnc71rdqbf4fz9azfgdkzqtmes8u
X-Rspam-User: 
X-HE-Tag: 1760012054-699714
X-HE-Meta: U2FsdGVkX19VRRCpThtkhh2LBtQNBSX9R2oxeWRrDaY2a5oOLsWxT+UElcz+iDP7y7C6q6BXlakrTE5jg+UGVi2olwkD3LBhlMoLMFD7kyux0AwGTS0Sv54VYbK95b2asHM2pNigDTpcMLz5ROl9N9Vm0rU2rXc4rqJx9Mzo4F46lrLbthbjYIV4yu0UUQkLqbMcOymfZEQEb6oBD+65HyfTeVyDvhjqhARHjO9M1EndXJgHDqRLvbeme+PXgZTBerjwHu6sFFcchdBOdbJzvHMX3nloOLFi2Ti/tCzZSQiTQ/+HXPsnQOPQaUw6mdtInvtEnGf1nGaM+3WOYEXn5gaxKRCHNnTen4IDUGUTJlVNdh78UMRIc2TDsK8tzQqEXIxi9VVJ7Kq2f1ARApWaHQHymTut+1hKC1iS0e7lKIegC9ts0WdakCD4P2Bv2+wfvTxqaQFsM9qyyKjPxUNHL6/HppwjFTB0Lu1aGFaqCNaeCfX4G+5a+jvXKzjn7abPLOV+9i21PMXCWVV9ROuOr3thepHhUT85KM76C/J3KKomtbB3/jqbqmTubePyGlRRyzznhUHsU89h5gQ04I7mziEdfVNoWzqV2+fmRMHDusjpyasLu9+PKZfjTGiMmBMtKS09b+hSX75D2waRw7gv2n++sU3bcX1vKdBZfz3OiXQhfv+Kr7c5/NhQNqPuMKmYnWvUmGE7goOGKUjsyTdOqWh+SgJy6IgCasGJyWiFXp01IKArKFtoAoXpSrp703Y9452EMOVrsaE+jp/+zhGeY7YpxiAxFgNofclrMYnKHAYQCSHoumXN0f8S70jCbFEkdOeLbD78z6/FxycyVNGJNNOdU9TSmBs0O6EX9dT0oQBv3nebfre206iA5n/XDriWTO8SJiO+mlyu/9JSNYTrP2wiwAHDFBcbuNU3zaB0seza0xIeZ1HzkElxqs8iMasrfAgXNye3ML5tG8pyU43
 KVBmXpOp
 spaszV0JGMR4ePx7lds2pzKpW/8lH0Ahz2+NzqdkTEvEjiPbNbCIknDcY9hxLSiHxIk7bhH/LLC8ibLj30I7BezfYwIURaE06Zyyi8vXA9lS0R8b2oXw5TT8fW/xE0O95lFZFuq+lWpkotGzts2kWzv1LCqEALKMAAqxNEtJ+vUEAnTOZHCQDLfllz443MwiP4u9yXfcpCtQ5NMIhI4lHoAGehtowsZforcJFsqwBHrgYLRfg1QR4wlkCJtJCrqYKDIPRKlAYXs45ZVs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 3:56=E2=80=AFPM Longlong Xia <xialonglong2025@163.co=
m> wrote:
>
> From: Longlong Xia <xialonglong@kylinos.cn>
>
> When a hardware memory error occurs on a KSM page, the current
> behavior is to kill all processes mapping that page. This can
> be overly aggressive when KSM has multiple duplicate pages in
> a chain where other duplicates are still healthy.
>
> This patch introduces a recovery mechanism that attempts to migrate
> mappings from the failing KSM page to another healthy KSM page within
> the same chain before resorting to killing processes.

Interesting, thanks for the patch! One question below.

>
> The recovery process works as follows:
> 1. When a memory failure is detected on a KSM page, identify if the
> failing node is part of a chain (has duplicates)
> 2. Search for another healthy KSM page within the same chain
> 3. For each process mapping the failing page:
> - Update the PTE to point to the healthy KSM page
> - Migrate the rmap_item to the new stable node
> 4. If all migrations succeed, remove the failing node from the chain
> 5. Only kill processes if recovery is impossible or fails
>
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/ksm.c | 183 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 183 insertions(+)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 160787bb121c..590d30cfe800 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3084,6 +3084,183 @@ void rmap_walk_ksm(struct folio *folio, struct rm=
ap_walk_control *rwc)
>  }
>
>  #ifdef CONFIG_MEMORY_FAILURE
> +static struct ksm_stable_node *find_chain_head(struct ksm_stable_node *d=
up_node)
> +{
> +       struct ksm_stable_node *stable_node, *dup;
> +       struct rb_node *node;
> +       int nid;
> +
> +       if (!is_stable_node_dup(dup_node))
> +               return NULL;
> +
> +       for (nid =3D 0; nid < ksm_nr_node_ids; nid++) {
> +               node =3D rb_first(root_stable_tree + nid);
> +               for (; node; node =3D rb_next(node)) {
> +                       stable_node =3D rb_entry(node,
> +                                              struct ksm_stable_node,
> +                                              node);
> +
> +                       if (!is_stable_node_chain(stable_node))
> +                               continue;
> +
> +                       hlist_for_each_entry(dup, &stable_node->hlist,
> +                                            hlist_dup) {
> +                               if (dup =3D=3D dup_node)
> +                                       return stable_node;
> +                       }
> +               }
> +       }
> +
> +       return NULL;
> +}
> +
> +static struct folio *
> +find_target_folio(struct ksm_stable_node *failing_node, struct ksm_stabl=
e_node **target_dup)
> +{
> +       struct ksm_stable_node *chain_head, *dup;
> +       struct hlist_node *hlist_safe;
> +       struct folio *target_folio;
> +
> +       if (!is_stable_node_dup(failing_node))
> +               return NULL;
> +
> +       chain_head =3D find_chain_head(failing_node);
> +       if (!chain_head)
> +               return NULL;
> +
> +       hlist_for_each_entry_safe(dup, hlist_safe, &chain_head->hlist, hl=
ist_dup) {
> +               if (dup =3D=3D failing_node)
> +                       continue;
> +
> +               target_folio =3D ksm_get_folio(dup, KSM_GET_FOLIO_TRYLOCK=
);
> +               if (target_folio) {
> +                       *target_dup =3D dup;
> +                       return target_folio;
> +               }
> +       }
> +
> +       return NULL;
> +}
> +
> +static int replace_failing_page(struct vm_area_struct *vma, struct page =
*page,
> +                       struct page *kpage, unsigned long addr)
> +{
> +       struct folio *kfolio =3D page_folio(kpage);
> +       struct mm_struct *mm =3D vma->vm_mm;
> +       struct folio *folio =3D page_folio(page);
> +       pmd_t *pmd;
> +       pte_t *ptep;
> +       pte_t newpte;
> +       spinlock_t *ptl;
> +       int err =3D -EFAULT;
> +       struct mmu_notifier_range range;
> +
> +       pmd =3D mm_find_pmd(mm, addr);
> +       if (!pmd)
> +               goto out;
> +
> +       mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
> +                               addr + PAGE_SIZE);
> +       mmu_notifier_invalidate_range_start(&range);
> +
> +       ptep =3D pte_offset_map_lock(mm, pmd, addr, &ptl);
> +       if (!ptep)
> +               goto out_mn;
> +
> +       if (!is_zero_pfn(page_to_pfn(kpage))) {
> +               folio_get(kfolio);
> +               folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NO=
NE);
> +               newpte =3D mk_pte(kpage, vma->vm_page_prot);
> +       } else {
> +               newpte =3D pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(=
kpage), vma->vm_page_prot)));
> +               ksm_map_zero_page(mm);
> +               dec_mm_counter(mm, MM_ANONPAGES);
> +       }

Can find_target_folio() return the shared zeropage? If not, the else block
looks like dead code and can be removed.

And, a real hardware failure on the shared zeropage would be
non-recoverable, I guess.

Cheers,
Lance

> +
> +       flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
> +       ptep_clear_flush(vma, addr, ptep);
> +       set_pte_at(mm, addr, ptep, newpte);
> +
> +       folio_remove_rmap_pte(folio, page, vma);
> +       if (!folio_mapped(folio))
> +               folio_free_swap(folio);
> +       folio_put(folio);
> +
> +       pte_unmap_unlock(ptep, ptl);
> +       err =3D 0;
> +out_mn:
> +       mmu_notifier_invalidate_range_end(&range);
> +out:
> +       return err;
> +}
> +
> +static bool ksm_recover_within_chain(struct ksm_stable_node *failing_nod=
e)
> +{
> +       struct ksm_rmap_item *rmap_item;
> +       struct hlist_node *hlist_safe;
> +       struct folio *failing_folio =3D NULL;
> +       struct folio *target_folio =3D NULL;
> +       struct ksm_stable_node *target_dup =3D NULL;
> +       int err;
> +
> +       if (!is_stable_node_dup(failing_node))
> +               return false;
> +
> +       failing_folio =3D ksm_get_folio(failing_node, KSM_GET_FOLIO_NOLOC=
K);
> +       if (!failing_folio)
> +               return false;
> +
> +       target_folio =3D find_target_folio(failing_node, &target_dup);
> +       if (!target_folio) {
> +               folio_put(failing_folio);
> +               return false;
> +       }
> +
> +       hlist_for_each_entry_safe(rmap_item, hlist_safe, &failing_node->h=
list, hlist) {
> +               struct mm_struct *mm =3D rmap_item->mm;
> +               unsigned long addr =3D rmap_item->address & PAGE_MASK;
> +               struct vm_area_struct *vma;
> +
> +               mmap_read_lock(mm);
> +               if (ksm_test_exit(mm)) {
> +                       mmap_read_unlock(mm);
> +                       continue;
> +               }
> +
> +               vma =3D vma_lookup(mm, addr);
> +               if (!vma) {
> +                       mmap_read_unlock(mm);
> +                       continue;
> +               }
> +
> +               /* Update PTE to point to target_folio's page */
> +               err =3D replace_failing_page(vma, &failing_folio->page,
> +                                            &target_folio->page, addr);
> +               if (!err) {
> +                       hlist_del(&rmap_item->hlist);
> +                       rmap_item->head =3D target_dup;
> +                       hlist_add_head(&rmap_item->hlist, &target_dup->hl=
ist);
> +                       target_dup->rmap_hlist_len++;
> +                       failing_node->rmap_hlist_len--;
> +
> +               }
> +
> +               mmap_read_unlock(mm);
> +       }
> +
> +       folio_unlock(target_folio);
> +       folio_put(target_folio);
> +       folio_put(failing_folio);
> +
> +       if (failing_node->rmap_hlist_len =3D=3D 0) {
> +               __stable_node_dup_del(failing_node);
> +               free_stable_node(failing_node);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
>  /*
>   * Collect processes when the error hit an ksm page.
>   */
> @@ -3098,6 +3275,12 @@ void collect_procs_ksm(const struct folio *folio, =
const struct page *page,
>         stable_node =3D folio_stable_node(folio);
>         if (!stable_node)
>                 return;
> +
> +       if (ksm_recover_within_chain(stable_node)) {
> +               pr_debug("recovery within chain successful, no need to ki=
ll processes\n");
> +               return;
> +       }
> +
>         hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>                 struct anon_vma *av =3D rmap_item->anon_vma;
>
> --
> 2.43.0
>
>

