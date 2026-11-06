Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFD39606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OkYMi/fF
Received: by kanga.kvack.org (Postfix)
	id E8DD96B05BA; Fri,  6 Nov 2026 04:56:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DA16B05BB; Fri,  6 Nov 2026 04:56:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D4B6B05BC; Fri,  6 Nov 2026 04:56:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A9BC76B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:56:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F236120CE5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:56:27 +0000 (UTC)
X-FDA: 85404239214.12.E59D503
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 465DB1A000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:56:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OkYMi/fF";
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793958985;
	b=jtMLXEmNH1d8KR09h45tSCQxUi8knGkZYurH7B6uZwcUADoi9BpQCqDbNUaIP3WEO74P+B
	DO7GyNUvesu5g8HOEvoqFuQd3pITTaGtSRelRkVLT3wfuGsIbAgiiK7PuxOVxko+ysUrD5
	KDaF4fV2IHi79LAIuOp9vkQfgO7ItIQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OkYMi/fF";
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793958985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8OzRqDZQKjlnkKE6E4d5qASDSC6RPN4pLC36VUFGsI=;
	b=3xOfyMrw+i3oJU2C6zAMau4c6WDD58GXg5ro3Kt/SoyrafKR/OjvGVoiKx1y0HtVGvTR+M
	zB8tw8I4vBh5eVMjXCsFJyZ4XMecWngYpuWnR7jb3I9XTCkmC94t66FWJzSccX9Cg0V4lg
	A+b/XUbgkLugSTH9P5MsS2Hc2Ar8Sj0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8555B605F9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540DF1F00902
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793958984;
	bh=w8OzRqDZQKjlnkKE6E4d5qASDSC6RPN4pLC36VUFGsI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OkYMi/fFnOE55CJ7cd/1YEvR4T/qaVbna+FxAJ0RGz1BJOMNCz7nXthukL33Izh8v
	 Jts1gbVEXev5YDKBCendBcjZiYEO8zOcciVzOh1dc08wQlkc+hQ2Gc3LnvH7Jb1oo/
	 16/SM/BsnS4jYHVaOusWKsOTxhqbQX08f24PrL8bcCajSyn0BIF5enyZ6+Jaf5edx+
	 Q5u3ieOdb5821sqEgQ4b6L6rO9swJUiY9bN1gOkrfC4V+/3a/Tph9db/aWHHlrMtkT
	 Ges8bTP8Kn/rjXd4j7CV+Dh6BkqbGseQEJ1QIDSwOuK8m+GHPPuZKe0DsUQFT9QGa5
	 8glYSFl5V38ug==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-945ae2daa3eso59167085a.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 01:56:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwP41Qcfdomr85MZ3kWIRfwXGqmImx/x2J7nNA3sztivEXCKAHB42otq2f2JIRBhoNqjj1QTY9i/A==@kvack.org
X-Gm-Message-State: APuU4Z+n1fd7+3y0v/37wSEPviHxvOGhXM1QneUVFjWLgKTYlF4+bX7R
	eiekzF6asTWF+qjWi511JlxAnbPnIadKVGAHqtu5zRVgeHCDGmBa1cwC8X3aEbrPeuh7tjKbZJ2
	ae84Y8PwDQe39OzlZSNi5xtpzUVJe35E=
X-Received: by 2002:a05:620a:294a:b0:93e:ce12:aadd with SMTP id
 af79cd13be357-945f34ef78bmr296469885a.58.1793958983724; Fri, 06 Nov 2026
 01:56:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <20261105045406.39871-1-lance.yang@linux.dev> <0ddaf336-7cb7-4e83-af2c-f60d23f7aafd@linux.dev>
 <f7bd740e-1328-473e-96f5-89658a08d514@linux.alibaba.com> <CAGsJ_4zHtv7hBCaW=wdfiM7yA4OJS7pcFomSo22bEzWHizYAXQ@mail.gmail.com>
 <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
In-Reply-To: <453e2c18-4e79-4db2-b565-1af881925f08@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 6 Nov 2026 17:56:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zLiwYf6LM_BWoZyiYWxvW2H_siZ0QC7FmEHazF_fLa6g@mail.gmail.com>
X-Gm-Features: AclHuK95LDvF5ZiNBpoPTxiS2rEhGEEMq1D27yisdsMbvX4nhwqVupPOIZSeW-w
Message-ID: <CAGsJ_4zLiwYf6LM_BWoZyiYWxvW2H_siZ0QC7FmEHazF_fLa6g@mail.gmail.com>
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, 
	ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mcpks4s99i75dz83u9o13qjfnyt9ugmw
X-Rspamd-Queue-Id: 465DB1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793958985-395341
X-HE-Meta: U2FsdGVkX1+RxMR9RAe3zNCxv1+29d1m8+mBaeku9Hg6vLK9vxdu1bFo3mzH8C5xXl7ArkiQyESAFxD9A/cAa9bz4HmAiA8W73KoBq2WvU4f5a9rMOXbxf1/Ob7HW/3YtK7MwjWOMhl2JwxTX36/vvED/PBQA5xHho9VQiA6KyVa0WbuMmiqM9titP1vWzoRgPXz2aeHEpeyvp0k0KtEGJRnWXtxtNfwDC8j5SospPXYUrrYJTf42LlS539hiFh/2T8GvjEVZEXAnwOzC1en87ZpO9DPpSr+zjZGhany1x6MnqiYnadI+HHpNYaz5AeiUm85q5gLoU18Li3/GJ58pAi/qYJ4MdTKdvWlctuBCJaHIb9Pp3lnFh3YX/TaUUiog/djn2dz3Q3SVlqNYj4BL1WS9nLUyZOh+oqbuKhHPdnQKU1/zomXfInQrloAr4YRcgqYmbb1TuFEYm+cNZNIQuoEsfBq3R2flLB8a6HRaSY0FZUcUhati1eogRZKw2lgMeFmvtqYo9wpX9/nAqptSmA0DzWR4g8kLe8iDbmnbvtUtM/R4+TpmqV1bg4lGtCpr2q70E72C1suYH9mo5atBYGwBcqkmJ3eHaQvsr3emWR+k9R/UIhIz03TW5DxtGM1rOrY0qflxV2GeMc6gOefAabNbYNCvXoQHEwErhMbj2Ntbnx9riTR4ieM3OL5SSzQObK8Zt3nlnT5dnBG7dEvObvOxXs+wcfCS9ls6qZ1pOw8d8p75oxzXO3Yiwwkd+ECC7UMmRGMcXE0QI7cdNjN0VSho29ByjIG+9GUUhSx2e9jh5kPXt16HAD2GiHnWhXqfl6zCQ44NeBNw0CnpWpVKoO/SBGUAA7nW4eCvH7Ty8oJFSGQHQbWwbuy2uVSSzeJcfszCzb2qjhXcHuhW40io5liSXaeWYS0BrlaCCwjUQ3Fudbq6c7RSGauRmHzRwLr3ojTzR7vhbGG+PsdMVR
 mBYtEm1q
 f25VvnWvkOOk8yBbE2wGejIUIdxNAp+a4xzWTa1bUMIr9hicw07tibke0xfh60Ae/gw+sPPPsiX3y1FNAkGuC0f5AQKYmpxouULgT7MhwnCBEhFApZ33Vhw8mznYrDmBRkJ7wJHtTA9xPoBTGvjiNPudaofiMUORCHn9yH+zFJrUXGq6FGvsCbF+7jnzgN3VBQnkq9KEsV1ZGYJNfI6h3S5KdwF+OFR2HjMUHjfPtLp87K55TN02wiaRQPBWjITB0p4o1Xc5IVBh50mwMw0rftFHvbaQe/v4g3ZcBkS0E+Prn1ctSBwUIxBiEsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 4:55=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
[...]
> >>> Ouch ... one thing I missed ... what about order-0 reclaim?
> >>>
> >>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we s=
till
> >>> hit the same race there?
> >>
> >> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which
> >> is used to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is se=
t,
> >> it means the caller can tolerate some racy checks.
> >>
> >> For this case, I think we should set TTU_SYNC unconditionally in
> >> shrink_folio_list(). Barry, what do you think?
> >
> > Baolin, thanks for reaching out to me. I added that flag
> > mainly for large folios.
> >
> > I observed cases where PTEs for large folios are partially
> > cleared during certain transition states, for example, when
> > PTEs are cleared before being modified:
> >
> > pte =3D ptep_get_and_clear();
> > pte modification;
> > set_pte_at();
> >
> > In such cases, page_vma_mapped_walk() skips the empty
> > entries and starts from the next valid one.
> >
> > This may result in partially unmapping PTEs for large folios
> > and trigger unexpected folio splits. At the time, I was
> > particularly concerned about unnecessary folio splitting,
> > so my focus was mainly on large folios.
>
> Thanks for the information.
>
> > However, I also noticed that a similar race can occur with
> > small folios. In that case, the folio may simply remain
> > unreclaimed by the reclamation path.
> >
> > However, my main concern at the time was avoiding
> > unnecessary folio splits.
> >
> > Your new race also seems to amplify the same situation.
> > However, I don't think this problem necessarily depends on
> > the commit you mentioned. It has been around for a long time.
>
> Agree.
>
> > If the concern is reclaim failure, I agree that there is no
> > fundamental difference between large folios and small folios.
>
> OK. And I did a quick measurement to reclaim anon and file folios via
> the memory.reclaim interface.
>
>  From test results, reclaiming 1G small anonymous folios (using zram as
> swap) shows no significant performance change. However, reclaiming 1G
> mapped clean small file folios does show an observable regression if the
> TTU_SYNC flag is set.
>
> Without TTU_SYNC for small folios:
> time echo 1G > /sys/fs/cgroup/test/memory.reclaim
> real    0m0.178s
> user    0m0.000s
> sys     0m0.178s
>
> With TTU_SYNC for small folios:
> real    0m0.315s
> user    0m0.000s
> sys     0m0.314s
>
> So for the current patch, I'd prefer to keep things as is: only sync
> when TTU_SYNC is set. Without setting the TTU_SYNC flag, keep the
> original logic, meaning the caller can tolerate some racy checks.
>
> Any other thoughts?

I'm still struggling to understand where the regression comes
from. You're doing echo 1G > /sys/fs/cgroup/test/memory.reclaim
without the concurrent CPU 1 (MADV_DONTNEED) operation that
causes the race.

so the regression actually comes from other places, maybe here?

static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
                    spinlock_t **ptlp)
{
        bool is_migration;
        pte_t ptent;

        if (pvmw->flags & PVMW_SYNC) {
                /* Use the stricter lookup */
                pvmw->pte =3D pte_offset_map_lock(pvmw->vma->vm_mm, pvmw->p=
md,
                                                pvmw->address, &pvmw->ptl);
                *ptlp =3D pvmw->ptl;
                return !!pvmw->pte;
        }
       ...
}

Am I missing something?

Best,
Barry

