Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2336EFB3CEB
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D41E6B0096; Mon, 30 Mar 2026 05:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784FE6B0098; Mon, 30 Mar 2026 05:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2616B0099; Mon, 30 Mar 2026 05:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7286B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:48:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EED741B8A1B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:48:09 +0000 (UTC)
X-FDA: 84602253498.14.D9F6AD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5DEB71C0004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:48:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMReKoLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774864088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5n3+vvPmzkZ+LKtOf+BXy0xsByrxP32ZMmrPyB31pwM=;
	b=N9RPa2aX1KUnNvPAaJ776zDEsz7kIbX09eJn3d4w4ypCarOJR9mTfx4WRT5ZhIOPDAWguE
	+O+ygHt28LeR+cJ9Ph+UMWYLmSXC+JNXIJT70WxPpVpqjEJ9ixvCNuqcSeqM0mEPythwmz
	6EjZX2mWWtujGYkT3LVlTHv6Wx7M3Ws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774864088; a=rsa-sha256;
	cv=none;
	b=jFlvPZ68iZLhUNngPc5wLdaqpO8FFCIfKRYbZ9hp0xEaBWxPeHuuY9ge+WniwXRBZhX4pb
	w4G9uG0JRa9yBONYGTfGicd+r+YoN31vBJjIOL5xwKpjVKMCk1JCpj/0DlhV4tMCW+XOtJ
	Zoj0Ogw4+TGLxRJkuh+zvz4G+Un9Z2U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OMReKoLU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D694860054;
	Mon, 30 Mar 2026 09:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AD2C4CEF7;
	Mon, 30 Mar 2026 09:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774864087;
	bh=L7TKWn2Q+ImhzxbGenUlYPf7P2gJHg98JdI2bl3bESY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OMReKoLUngDh1GvdLGC2cMwqAfgTJSZlKrJ2vhmNvrtwgynF43AQNXWWTBYG86brb
	 wfwvLo8+0+TnB5qHCt1ArY2icGvw64fU9M2THJJfev8FL3J1cGfvhIVr2e1XIV7rzn
	 Y1Ltz3syL1ZWE8n+sWIiyre0sa6L4CoQ3RmfM6ovO19RBpFDUL4V/xWxY5bMNSYKYd
	 2HZNASNSb8dh6TUMUA2Iy3RZOizWVlbZMt/czBp7VfC2DaskMsv/rN+nPbouofs+IK
	 ND2cT2TT/KVdoDEE+MrbACTJKeNywx3wCsP8u38VPv5c7TKi1uRqvk9eEBoYbIocEB
	 BP0UhrqPucwfw==
Date: Mon, 30 Mar 2026 10:48:01 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 12/13] mm/huge_memory: add and use
 normal_or_softleaf_folio_pmd()
Message-ID: <6ad6c2a6-463f-4e2c-824c-1c9cd02a6355@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
 <c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org>
 <CAJuCfpGDWLtUHpXLyB7UA9wva9q7RjG7coOiFaL-Os_x8BNr-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGDWLtUHpXLyB7UA9wva9q7RjG7coOiFaL-Os_x8BNr-g@mail.gmail.com>
X-Rspamd-Queue-Id: 5DEB71C0004
X-Stat-Signature: egs4rmtic6fzpboz5u8yz69btdk8j97o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774864088-221681
X-HE-Meta: U2FsdGVkX18YVswejBxSRRyM4tPjBE8oHCCgXMS0aYrjw2U4fuVu3WpdNwquvMSZ/tIVWA+eW27ePJhU0SlqgittM2ubygSZkf/uHvmxaaV0Z44BiOh+baPMeH9DqJ5WJfDTK3Zmdsp5rNmy8fFpC4yLL8xRC02aa5a1yROJiveB4Yy+Mp2rPrS6Jv6fk9caqZXoSl1yIiYcLj17aEGDuxWb1YjDrn8vrnFxOrUifmcgYN7UzKpJVJN2qYxKDcgSxzDw3Q1KQPgZA2yWEIB/C4eI78YnrlDY92zT2zrLul7VNtdg0xh1WhIqDyGTJMCzxJ9YNMQ8hnYm3RcFPgT2zH8MnKccdGuvzrJ0ZJBXz4D4BwHQ3lTByMIe0BETflclEQm97t5fxt/1s9YyRStVsPSEcY+Qbo0ncTnmMydhcaoRsmtMe0PuzHAG/3dnPFQVoxBsrSsyYamnfHwudbRIcCmYt3fylsUgXvguJFqBzpTJAngK/QX7fpGEFgCc4Xp0dRpMwjM4Z8vX4RWFnR30DqwH8XKiU039EEVWCfYe8K+4hHuoJhyYO64DVRosFJFVRWTHvvDNN8LHcxsLKglplhbttabBJeMpHpr5qoAVa/4syc5hR97cWthFnwqWafX5qxcwKxLTTNaD6ZJYc+eAun/HQQhVWotGLWcnfM88Kg+Nq2eAOXznlApn1WGSRErPKUf7o+AbdK0JrD+42S+ERhes2ZwLatX1rTvzaS8npKiwErRRS51jeh+78kejiz7mFxvemVW3/u3FX4wbIEUDo4sbosBSu7kKdArxLKeXGvRs1GPV0JTmm0hT3KiIjYGyuJDoqnZgaeodEju467tLrSByfrInJrNbq1qlIGa3lj34R5cmsmYCmV2ew8IJcyHF7w/SWfAorqc45IsL0SYlIZTKlTkP+K/xuRi1eKhoUH+aUa5EfC6byWOyi5+LdGGcezPN7Q2losJ3BP+H8Ct
 ih5DJVt+
 5MAbI2gfWDjCIuIXG/pQf48IuT+AFnO4cVWlEu/VpNatd28/z95CoWZrYyDYqu4zNiiZKhNE5i3ujL0CJ86e+4XIm5mbt1V136asTpNDkRJJPDPks/QlkHF159uND/kemI8W3j/vyyjiq0hZES4XLnX0IZBea5eMs5F2uu9krR0XU/6ZzXBt3NNrf7vDzRvR3Ren81yVlrb6gV8gnckIddv8GdT4JsUEZdxWaNOdh+/IM5kBLD2DNAuOteuGyay1cUMv7sksg20a1yDWafrwUIYgh+drptRCWtv44x3Uj9utpobT76yT07i8QDNPIpsQQokYqR/OKZBf7lkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 28, 2026 at 12:45:08PM -0700, Suren Baghdasaryan wrote:
> On Fri, Mar 20, 2026 at 11:08 AM Lorenzo Stoakes (Oracle)
> <ljs@kernel.org> wrote:
> >
> > Now we have pmd_to_softleaf_folio() available to us which also raises a
> > CONFIG_DEBUG_VM warning if unexpectedly an invalid softleaf entry, we can
> > now abstract folio handling altogether.
> >
> > vm_normal_folio() deals with the huge zero page (which is present), as well
> > as PFN map/mixed map mappings in both cases returning NULL.
> >
> > Otherwise, we try to obtain the softleaf folio.
> >
> > This makes the logic far easier to comprehend and has it use the standard
> > vm_normal_folio_pmd() path for decoding of present entries.
> >
> > Finally, we have to update the flushing logic to only do so if a folio is
> > established.
> >
> > This patch also makes the 'is_present' value more accurate - because PFN
> > map, mixed map and zero huge pages are present, just not present and
> > 'normal'.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Thanks!

>
> One clarifying question below but I think I know the answer, just want
> to double-check.
>
> > ---
> >  mm/huge_memory.c | 47 +++++++++++++++++++----------------------------
> >  1 file changed, 19 insertions(+), 28 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 9ddf38d68406..5831966391bd 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2342,10 +2342,6 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> >                 add_mm_counter(mm, mm_counter_file(folio),
> >                                -HPAGE_PMD_NR);
> >
> > -               /*
> > -                * Use flush_needed to indicate whether the PMD entry
> > -                * is present, instead of checking pmd_present() again.
> > -                */
> >                 if (is_present && pmd_young(pmdval) &&
> >                     likely(vma_has_recency(vma)))
> >                         folio_mark_accessed(folio);
> > @@ -2356,6 +2352,17 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> >                 folio_put(folio);
> >  }
> >
> > +static struct folio *normal_or_softleaf_folio_pmd(struct vm_area_struct *vma,
> > +               unsigned long addr, pmd_t pmdval, bool is_present)
> > +{
> > +       if (is_present)
> > +               return vm_normal_folio_pmd(vma, addr, pmdval);
> > +
> > +       if (!thp_migration_supported())
> > +               WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> > +       return pmd_to_softleaf_folio(pmdval);
> > +}
> > +
> >  /**
> >   * zap_huge_pmd - Zap a huge THP which is of PMD size.
> >   * @tlb: The MMU gather TLB state associated with the operation.
> > @@ -2390,36 +2397,20 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >                                                 tlb->fullmm);
> >         arch_check_zapped_pmd(vma, orig_pmd);
> >         tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> > -       if (vma_is_special_huge(vma))
> > -               goto out;
> > -       if (is_huge_zero_pmd(orig_pmd)) {
> > -               if (!vma_is_dax(vma))
> > -                       has_deposit = true;
> > -               goto out;
> > -       }
> >
> > -       if (pmd_present(orig_pmd)) {
> > -               folio = pmd_folio(orig_pmd);
> > -               is_present = true;
> > -       } else if (pmd_is_valid_softleaf(orig_pmd)) {
> > -               const softleaf_t entry = softleaf_from_pmd(orig_pmd);
> > +       is_present = pmd_present(orig_pmd);
>
> nit: With this you don't need to initialize is_present anymore when
> you define it.

Ah I think that's sorted out later.

>
> > +       folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
> > +       if (folio)
> > +               zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present,
> > +                                  &has_deposit);
> > +       else if (is_huge_zero_pmd(orig_pmd))
> > +               has_deposit = !vma_is_dax(vma);
> >
> > -               folio = softleaf_to_folio(entry);
> > -               if (!thp_migration_supported())
> > -                       WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> > -       } else {
> > -               WARN_ON_ONCE(true);
> > -               goto out;
> > -       }
> > -
> > -       zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present, &has_deposit);
> > -
> > -out:
> >         if (has_deposit)
> >                 zap_deposited_table(mm, pmd);
> >
> >         spin_unlock(ptl);
> > -       if (is_present)
> > +       if (is_present && folio)
>
> In which case would you have a valid folio and !is_present? Is that
> the softleaf case?

Yes, as pmd_present() will return false for a softleaf entry. This is an easy
way of figuring that out, kind of expressed a bit differently 'it's present so
maybe we have to do a TLB operation, but make sure we have a folio to operate
on'.

>
> >                 tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> >         return true;
> >  }
> > --
> > 2.53.0
> >

Cheers, Lorenzo

