Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3645B10A3D9E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DFD6B00BC; Thu, 26 Mar 2026 22:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EEE6B00BE; Thu, 26 Mar 2026 22:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D1C6B00C0; Thu, 26 Mar 2026 22:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50D996B00BC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:33:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8879140D42
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:33:43 +0000 (UTC)
X-FDA: 84590272326.28.5EFF26F
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id 02F5E100010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:33:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UkaFW0JH;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774578822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/j2LL2fzZ3HqKnkSg4Q11VeHoSjD2aRYX2gqfSMp8c=;
	b=6HrQeYpc5lZovJpaygNvOW+3XLyrfyNBeRLxPiAQ0yfXdY2K54Pz9S5Ak8Kz2NegjLW8nA
	nMzlT/4vMAIeCvLBsNUZGcEVGbrnIY7hCvlJKqf0PfhUwIPV9Z2BPR8SxJ7ByH5akKhh8V
	MkPvLR5ISdO6xh4BmI40lFOlUFgyO6Y=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UkaFW0JH;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774578822; a=rsa-sha256;
	cv=pass;
	b=8A5r4JsmPkDE93vu2PTnPP45tz33rhLqSAUixXd0+G3wil87ulpMwIAYME8bhUHtm7ofhA
	JVRX4jZq8cQjHsxztf00s0xt2r9JQAE3tj2oFdqsdu8OXlm9DzJSIDw2KaBO1dVHeEgBOX
	rD7Ce8b62BJxNml8vumuqiIpMFpldu8=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b97a06d7629so233137866b.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774578820; cv=none;
        d=google.com; s=arc-20240605;
        b=fiH84GhZMYZu3MqA8dgnWN0vrB4MHOCat3iF/DtiZRHq0YJGbTy+nUrc/uzHuDdfTn
         iUASM4Oog3T5PAIf7fenwZmlDenlJ49X2XiXXD3FjEf1YLOmzZZd97hmKW17LGNqWYUz
         dBDzL2mzFar+iwCV9h9PR3GIg/3NaBOctZf98wf44XvZZrFacaasKJYgqRHnz9XPEjkx
         LddXq8RlNDvYXiGpytzGcCoQQiXM8Rxehr4RBILcmowclC2o9XEBWd7L038EuRp/maDL
         qPB9RSJD6mlB/cO1AHbSqyx4QbzERzb4qMcNSVDjgFfm1g81av+c27WBnXRu2F0ufH2N
         DJ7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J/j2LL2fzZ3HqKnkSg4Q11VeHoSjD2aRYX2gqfSMp8c=;
        fh=fvQK+i0sFxOP22kFPjTJ4Y5YubkBZnDVd2x89Jacvpc=;
        b=izHV0h8X606n/1Q/mqdLbH4SjHhmB0nC3np/wcSUXheis7jrmAkzj5eVUC/JkwEo5F
         5ad54O2Bwi8BAcGgQu0k3krog0EA51QkenKwe80Mufgm+LTLwLRtLtqgsapHRI6Ep6T9
         L6Z5OpAenQ7UfNIon6x7oebfoPJqivo425Hflfuy9QfSgdLbKFbofwyLUFoI/cYo6D8u
         PoJwdX6ZGDg5SKFhmQUzJa9v84vhj9wKBLgEhJTDaM/bzJs/T/dEdyQWRx/3j9uNP0ur
         HRuoZMZvMDNMOXl4qqlXDwdU/Yiej8rlgKF4LBoMM77mCSqS7QNdX8P2zGczyIrAlGE7
         X2dA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774578820; x=1775183620; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/j2LL2fzZ3HqKnkSg4Q11VeHoSjD2aRYX2gqfSMp8c=;
        b=UkaFW0JH8Ah4Ca8t8Ooft4tA/D7/RqVvsTWV7rJMLlFYS/7hAIsUISQHGBmBZLA3et
         Sy7i/c9a9ZqalrOg45ZiOYPe1+xwA4+x9xrGl7KSBkN6RNqlYB6K78nNMsZ5h9yDKdFP
         gxOstT7EX6prNg1zqLJVLlwooWtH4SI2VhMEtolyXt80rTOg2JP8X5v7gFDAKEQcuXTX
         KogtVRwcQmEbe6XVHTtHY6oPznIAYcrao0TSCrHaSDLz3fO6M9DiwYax3Rq9Gc2clzuo
         0w2Msa2SSwNAVoOukerqfdstZdAIJDNXIc4p08POvfuyd4/5IKYhdEUJKGWhrbVrAfW/
         2KiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774578820; x=1775183620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J/j2LL2fzZ3HqKnkSg4Q11VeHoSjD2aRYX2gqfSMp8c=;
        b=qPgZs7MrgzEV6SB+5KRzaH8G+4V/oy7ajpDHmiWSSIVzx8gh/C8QOt8mbfVLFAASSY
         0K3+gGx1arFCVn7HL02AsjX7Lmwo0ZUpeBz5DFwQp7992BLk6l7ybuSMnxeOYs9dOp9L
         NHg5GbX5Cn+06HCjvXRPjo+pL2c2mYUnmD1jdppcpZSnHdNdDQLRfeachvVA3pgW9oUH
         94Qd3oPVIDu9i5OtCwUtkbgQ78auNUhSRDAqstv6DZMDbqOVjlPhxyycluHVcSRNfX6L
         4tLeulKlnrVkt/xld0ijQz3t1ZvOuEvx2oLEKl25OCWvaeIMscSvc+DTXCfI4ML3/bB2
         Lr5Q==
X-Forwarded-Encrypted: i=1; AJvYcCX1UdCQ8wFIDif9tU2Euu0LAu51B6IFuq2udc3MTuqHKxpCZaP/w+6bHo8vpvVjgSBtzlmzWv5suA==@kvack.org
X-Gm-Message-State: AOJu0Yw9JJ9SgTSo9ogcXPJJreKxRQ2U1TvQmv1bmIUExSTbUCXaWzbe
	lOojfjrokpEVj9jXFb1V9oXtS3i48n7St/fkFasNNZGPYUIgjkxjav7eYtc0RlsqMcwit8Zn0nd
	kLUd5Ci2vdZkhiEmeS++GwzhQ1uNJcpcF7/aTrKDf
X-Gm-Gg: ATEYQzwGun3uRMwZwQtKujItUvQfoNnsIsBVL031tbDaZ4vvLsROZukpoBBuX2S4IpU
	MuH2rCaeIlCOVnqASPOBTb2rDz0hHmZZtE67o6egLgP2A1beKiMtgaXSJsTHRnrQrtuqTIJ2TuW
	aelcpFNOzWg3Tlu+r2WFbL1/8VoDal2R8luSk/E+3EuVxmYgTefs5QOz/JgG00E4d/S/5Q21Z3x
	Tsyt0VB0AAuBB6zOts4n3DBNB5omy3nQiQW9Tidqact2Dw78twIx6RwU4LrBSPxTRyLbFLhikVp
	gWhtDoa7YpLBbSeFCOHM0FkkfI0EmG5dYLG8T//k/R5zz+GTh/141eU3rVKwIFHxazQIuA==
X-Received: by 2002:a17:907:7207:b0:b97:cebd:8273 with SMTP id
 a640c23a62f3a-b9b5032239amr41546366b.24.1774578819995; Thu, 26 Mar 2026
 19:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260306171815.3160826-1-rppt@kernel.org> <20260306171815.3160826-14-rppt@kernel.org>
In-Reply-To: <20260306171815.3160826-14-rppt@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 26 Mar 2026 19:33:03 -0700
X-Gm-Features: AQROBzBsDaVhxDLiM-NXiOxOeLuYc-OBfbNaKVq7AIOmeniABMQbpvif4NJ_3-8
Message-ID: <CADrL8HViJ_GaRUd-k9MyM0S8b7sz3whGJHNwvFfCk+pw0+kRgA@mail.gmail.com>
Subject: Re: [PATCH v2 13/15] KVM: guest_memfd: implement userfaultfd operations
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: u17qjbi685h9nw1ujcc4kw3qfou1regs
X-Rspamd-Queue-Id: 02F5E100010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774578821-473718
X-HE-Meta: U2FsdGVkX1+i4kPbWGG5FlBF+BGZGucZXCv+vcWMVimeiI36F4mni10A2ejEzq3AUOMkBqfJMbre3XyeYCd+ojBubEQeymqYapUCaQ5P8hqp+PIG4m0cuBbpXYVHsI1ukiWI8f8BH6kYhEixSKeVZfWq0Z3dgHNzZme6sRxB8oYMOdurLrYN4onUqwRDbceS6Uljr/AubNzhG001XbMGP9QrZ1SqINR8W6LZDzgnSYAA0631+PiAq9Z/vnuzjL2u8ygo1eHcpIGDibxALDTH8t0g9TQdpfEn6Jz/CAN3uiRBoJYcgxoi613vDOXmUl0YJ9c5OW9Ywl4zH4ThrbvsDtfo0iOypTPBnewVoBtpH9FzRE7AJHqGuir7Vz8CancghIIMZnQF1KBKjM44MmOzCB5Kl0f3oBOClBhKu5vGkrKACkMQvHGfMfPaEPrMw1YXC9gkJYalZ7otdNuLI7w1k9nZqyy72b9iwFLUmK4Vw7hMqpprQjIAletfypMDML85IwyvnaeeyHTFBgj5vNtn5SkJan3d1jBypOLGWUnI4x7n/luDwTB9AO34QSWqHzGzoj6NgQXbD5UjW7G4kNCZqazHj2SfyVGa+ACmYPAmCnvz3nL/YcUVNm6F8HgGoIxxlLbIfno1wN7fs8XSsURdKYu/WF1Sfyzo6OWuHoWS7VWnbGwZEvI47XUTJ7+Qtw4xyfhtLaypWizumGf/Whj3YHlNedyIYwd3azMyD5FxrsvuwNR4ytppGpry7bH/F79OAozYRc4qotXYU75n9UzM9EBD79+aNubM98veiSNk5HuMeHHUkZEgV+wDUhd2++Q4G2JcNB5v+FzH636q+uCYsVsvRvlKcXx0AzUQ9wwjk8DF6aUKqKjDUyMEQpffsebsP13fxeVEPLMaSbnS/SHV0UiNFyCGhbNXNVmiOjzaEficcx+uyHwKTwtEoFSrAjwy3MSu9pbD4gw9K1lho0E
 CsUmMz9T
 SbK1hSQNBE4BX6MJPdz36rA7eU5saRFKO/Gme
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 9:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> userfaultfd notifications about page faults used for live migration
> and snapshotting of VMs.
>
> MISSING mode allows post-copy live migration and MINOR mode allows
> optimization for post-copy live migration for VMs backed with shared
> hugetlbfs or tmpfs mappings as described in detail in commit
> 7677f7fd8be7 ("userfaultfd: add minor fault registration mode").
>
> To use the same mechanisms for VMs that use guest_memfd to map their
> memory, guest_memfd should support userfaultfd operations.
>
> Add implementation of vm_uffd_ops to guest_memfd.
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Overall looks fine to me, but I am slightly concerned about in-place
conversion[1], and I think you're going to want to implement a
kvm_gmem_folio_present() op or something (like I was saying on the
previous patch[2]).

[1]: https://lore.kernel.org/kvm/20260326-gmem-inplace-conversion-v4-0-e202=
fe950ffd@google.com/
[2]: https://lore.kernel.org/linux-mm/CADrL8HVUJ5FL97d9ytxp2WXos6HS+U+ycpsi=
5VxffsW9vacr9Q@mail.gmail.com/

Some in-line comments below.

> ---
>  mm/filemap.c           |  1 +
>  virt/kvm/guest_memfd.c | 84 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 83 insertions(+), 2 deletions(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4ada..19dfcebcd23f 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -262,6 +262,7 @@ void filemap_remove_folio(struct folio *folio)
>
>         filemap_free_folio(mapping, folio);
>  }
> +EXPORT_SYMBOL_FOR_MODULES(filemap_remove_folio, "kvm");
>
>  /*
>   * page_cache_delete_batch - delete several folios from page cache
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 017d84a7adf3..46582feeed75 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -7,6 +7,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/pagemap.h>
> +#include <linux/userfaultfd_k.h>
>
>  #include "kvm_mm.h"
>
> @@ -107,6 +108,12 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, s=
truct kvm_memory_slot *slot,
>         return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>
> +static struct folio *kvm_gmem_get_folio_noalloc(struct inode *inode, pgo=
ff_t pgoff)
> +{
> +       return __filemap_get_folio(inode->i_mapping, pgoff,
> +                                  FGP_LOCK | FGP_ACCESSED, 0);
> +}

When in-place conversion is supported, I wonder what the semantics
should be for when we get userfaults.

Upon a userspace access to a file offset that is populated but
private, should we get a userfault or a SIGBUS?

I guess getting a userfault is strictly more useful for userspace, but
I'm not sure which choice is more correct.

> +
>  /*
>   * Returns a locked folio on success.  The caller is responsible for
>   * setting the up-to-date flag before the memory is mapped into the gues=
t.
> @@ -126,8 +133,7 @@ static struct folio *kvm_gmem_get_folio(struct inode =
*inode, pgoff_t index)
>          * Fast-path: See if folio is already present in mapping to avoid
>          * policy_lookup.
>          */
> -       folio =3D __filemap_get_folio(inode->i_mapping, index,
> -                                   FGP_LOCK | FGP_ACCESSED, 0);
> +       folio =3D kvm_gmem_get_folio_noalloc(inode, index);
>         if (!IS_ERR(folio))
>                 return folio;
>
> @@ -457,12 +463,86 @@ static struct mempolicy *kvm_gmem_get_policy(struct=
 vm_area_struct *vma,
>  }
>  #endif /* CONFIG_NUMA */
>
> +#ifdef CONFIG_USERFAULTFD
> +static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_=
t vm_flags)
> +{
> +       struct inode *inode =3D file_inode(vma->vm_file);
> +
> +       /*
> +        * Only support userfaultfd for guest_memfd with INIT_SHARED flag=
.
> +        * This ensures the memory can be mapped to userspace.
> +        */
> +       if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
> +               return false;
> +
> +       return true;
> +}
> +
> +static struct folio *kvm_gmem_folio_alloc(struct vm_area_struct *vma,
> +                                         unsigned long addr)
> +{
> +       struct inode *inode =3D file_inode(vma->vm_file);
> +       pgoff_t pgoff =3D linear_page_index(vma, addr);
> +       struct mempolicy *mpol;
> +       struct folio *folio;
> +       gfp_t gfp;
> +
> +       if (unlikely(pgoff >=3D (i_size_read(inode) >> PAGE_SHIFT)))
> +               return NULL;
> +
> +       gfp =3D mapping_gfp_mask(inode->i_mapping);
> +       mpol =3D mpol_shared_policy_lookup(&GMEM_I(inode)->policy, pgoff)=
;
> +       mpol =3D mpol ?: get_task_policy(current);
> +       folio =3D filemap_alloc_folio(gfp, 0, mpol);
> +       mpol_cond_put(mpol);
> +
> +       return folio;
> +}
> +
> +static int kvm_gmem_filemap_add(struct folio *folio,
> +                               struct vm_area_struct *vma,
> +                               unsigned long addr)
> +{
> +       struct inode *inode =3D file_inode(vma->vm_file);
> +       struct address_space *mapping =3D inode->i_mapping;
> +       pgoff_t pgoff =3D linear_page_index(vma, addr);
> +       int err;
> +
> +       __folio_set_locked(folio);
> +       err =3D filemap_add_folio(mapping, folio, pgoff, GFP_KERNEL);

This is going to get more interesting with in-place conversion. I'm
not really sure how to synchronize with it, but we'll probably need to
take the invalidate lock for reading. And then we'll need a separate
uffd_op to drop it after we install the PTE... I think.

> +       if (err) {
> +               folio_unlock(folio);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static void kvm_gmem_filemap_remove(struct folio *folio,
> +                                   struct vm_area_struct *vma)
> +{
> +       filemap_remove_folio(folio);
> +       folio_unlock(folio);
> +}
> +
> +static const struct vm_uffd_ops kvm_gmem_uffd_ops =3D {
> +       .can_userfault     =3D kvm_gmem_can_userfault,
> +       .get_folio_noalloc =3D kvm_gmem_get_folio_noalloc,
> +       .alloc_folio       =3D kvm_gmem_folio_alloc,
> +       .filemap_add       =3D kvm_gmem_filemap_add,
> +       .filemap_remove    =3D kvm_gmem_filemap_remove,
> +};
> +#endif /* CONFIG_USERFAULTFD */
> +
>  static const struct vm_operations_struct kvm_gmem_vm_ops =3D {
>         .fault          =3D kvm_gmem_fault_user_mapping,
>  #ifdef CONFIG_NUMA
>         .get_policy     =3D kvm_gmem_get_policy,
>         .set_policy     =3D kvm_gmem_set_policy,
>  #endif
> +#ifdef CONFIG_USERFAULTFD
> +       .uffd_ops       =3D &kvm_gmem_uffd_ops,
> +#endif
>  };
>
>  static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> --
> 2.51.0
>

