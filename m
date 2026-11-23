Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A161606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=idW5ymU6
Received: by kanga.kvack.org (Postfix)
	id 1E6736B05B0; Mon, 23 Nov 2026 15:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6A46B05B2; Mon, 23 Nov 2026 15:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5CE6B05B5; Mon, 23 Nov 2026 15:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB6816B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:49:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BC531A09C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:49:36 +0000 (UTC)
X-FDA: 85467574752.12.4AEF249
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 618F9C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:49:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=idW5ymU6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795466974;
	b=2mEyFJvFP2xobq9SShAC1/WZ4AtyC02mdkmoewLx//3fhQkVp7ZDzbUNBKI91YgPdI4+68
	i4afwZrzsMtdspBH14aBaWgD01tGXZl0ls1yqPvAuYgo3erFY3VfzDCE3NbgjZyqyoAooq
	8kumCt8xwKaiinKLN9pPM66nIpMvnpQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795466974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwAkFqLrDZuJNQfsb1QIWJWTzXXHyVshwDglsm6PKrE=;
	b=3aXn4JL4r/1ispu2jPiuKdJe26UIxhEh4di9PnKve9ILaqyDp99rTUyx6DM7Jtvh14y7kQ
	gkHm1dqkRk8vJiIZ3iKz9wYsC2427iQqCwhew3XltRJCU33Arw8suuE+c8CAKUujChsRhb
	xGCd6knrojDfOa5TvxkghVNn6bCY6vA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=idW5ymU6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=jthoughton@google.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4d2b741ed9so615540666b.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:49:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795466973; cv=none;
        d=google.com; s=arc-20260327;
        b=FAujiddRkZI4CjBaCUgc4of2KRbEdbGCsSh11mAdMkt+/do3O5Ed/IB2g/+jotrKdH
         H4NjrGA5YkIpqKw8OF24itiH6All7nZW3OtyGss3Dgz2CTTHlPMbEnltdp35xPoSi4/s
         5jNF8F7qJHw2rpnfox42mfMiF6P9JxNv7t9MlRQVzWbWJ4hQrs+YvWANLI2FS9VP0GAM
         g3oAAy8BGb4CmB1WGj1jnBWfTQztlu/ed3PMl8zNGrP7bt0smHs4e+JCLDHAEiojH9Ej
         5oONpm5N5cIBhJ1Am9FColGtAHOjM79S1PTU8BcIKwAPDUlElz+c8pR02gI4Jm8svSoU
         YzTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BwAkFqLrDZuJNQfsb1QIWJWTzXXHyVshwDglsm6PKrE=;
        fh=MUq8gBePzcBtRmdikf0KSSJxsipjUkQyvB8H0ykvoVc=;
        b=poIZz5JuFOpKaOfwWkpha0emtHc/uxFTozdS9PiTrzu2VAXCbixEv0tlxmTNwB0AQS
         edWRW09LBx8LHUbSp01e5vmEP6bxbI0Yx5IXcHxjovKRVGUviz0sLqtvWP23WSv4S8Yo
         kVfbNwxRSqq37Ak0CUdLjZOxNAo+c8JhvHe8wA1Hf+WO6OKckd2WZQd5rpnT5Iirvnn5
         N5RE4vjPnDB03Xy1cVI0NXkcP3nrNURLDdAdyIGQKu1nsLMQuEGbxDWwNk/rciXwwYSu
         oAekgbkQaBU+Pr32POLaymsiQq5W/kns0tVQJ/A4bsAUEeSYJrRpl7Ql2BbRIzAm7F8j
         eoig==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795466973; x=1796071773; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BwAkFqLrDZuJNQfsb1QIWJWTzXXHyVshwDglsm6PKrE=;
        b=idW5ymU6+9F0qlLJAnSlYqxJXpCvzYg5YTx+w637OzwViYiPlVyH6iHgyQCR8Ia4hu
         4j/Nq/Eaoj183oESfipGpuNgqSD/3meo0kH8LWufT42N0i3m3kZCDJbbm4PDLz9fgRO9
         HkDbI7p5bvmwg2iNzoppvr+OJgt4urhCazY0IRBY2K9VDFM7jgV8RBFDb+ufKDK/gK3X
         MsJ9S26/rbgvINzjgazcBz/nuI//vF29rExr4zYnUAwmPuVe/kLeZT5o+Hvk9Qwm4Ta+
         NVcKNqOYMVoQDgtqbQaoXJ5/vIkN3FSTPqznK6Oh4qm0h7Sd4qCLsf2m8hX0cl/HAtUk
         qRxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795466973; x=1796071773;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BwAkFqLrDZuJNQfsb1QIWJWTzXXHyVshwDglsm6PKrE=;
        b=Qh4QOnwqQI9Tjo7eXOgz5oeyRz7Pm/WxpsOIxeJdHAJDt+gqdd25F8t3xose4bvVhZ
         P2O+iP1tw0g3rRq8EJFjzuHaNqelSYipZSvWlMHkej5AEopifPLypY4f8bmWNZB7bjKq
         PHLNmwJ/d/y2QGAJK3PLcm5goUUtbOL+UoA+dF2yphfH9ech/EGWj0WU9IHey52lQqX8
         5sSv3K2+eFlUOZrH3z1MxMhmcVpO+bz1WwO6uwoY18H7WCM2KqdiWQ2M/TOPD8ixScXM
         zqdz/G3ZguffYKxy8k90z+Eye/piNoLAxhtWry4Xl6l73NuS/MYIfNeNa1nGrvNlOqSG
         UeAg==
X-Forwarded-Encrypted: i=1; AL+hErGebyoG/cqn2lmiQ/21xSYfvp095lGyfE6maG98UOfbnSWchoBxfIs8ErZ0g9fu4WkyZ8ge1nSeXw==@kvack.org
X-Gm-Message-State: APuU4Z9NFVCZhX+jjv17qbByXpc4yGiLjSHJ4kwK05G9z2nfJtGnm1+u
	9Wld/2pbE+NVgXUpWDAmyLTTh6odWYoR29kg8CyVJHOB3IetpPEiVMoFY7aybVXF9Op55FKX4HK
	bzmsfay8Nb7BDkE66rqT1snCzQZyp3D//GVUYPo+R
X-Gm-Gg: AZFdTZfJM3ANqKqF5goUB0hVeeooj4pLlP3rpl3YjYq479qyBY42+0Xto+hs8NzVB8v
	WV1MW5ZkG24CtAlZcthuhsfTanZrRRenrqJxoEyQORcNEn+4L2Sgt5sL9PXAeARu91h51/hDNxW
	0pqaDogzKBl01DfCUzNV248DedgpaFlwZdq/jV7oPqQ9Sd1CdkUZvLYEsrfT7tOJLAOcRBdMLSY
	uLRvLCfokjtNZ+gTBb7jlLGPMPbEWndDCR6C2KHt5NINKVp6uV8AzRoNWaPuGCcUb9dgQ6NUnL1
	3Oe4soF6kM/XMq9xZCkn4pvWYEttCmE+8L+9ZaXdtNGmtiUzbKP9ZWOe/q0N+lB9iaZ+0VIcmjV
	HbY2I8QJjslFBFWy4AC6f3zZmu1XMmsxa00caPoYrgAIdMB4BklRXRDF1sZbdu1li8fc13CoZwR
	07Fh5C/bq2kcdfSkwkYla0Djgg1CqNNHso/Ty+7VxVJuiRX9reBTc=
X-Received: by 2002:a17:906:da0e:b0:c41:731c:534 with SMTP id
 a640c23a62f3a-c513a8590b8mr737596766b.24.1795466972524; Mon, 23 Nov 2026
 12:49:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-5-jthoughton@google.com> <4508589C-2E30-4DAB-9465-73121835D0D8@linux.dev>
In-Reply-To: <4508589C-2E30-4DAB-9465-73121835D0D8@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Mon, 23 Nov 2026 15:48:54 -0500
X-Gm-Features: Aa3M54q05It1n2eRJ6pQdCziUJwvWp3TC8VwynDcMWXjuCwyJF5MV-bvGGuFHUc
Message-ID: <CADrL8HUstWR2pajfYYzRqL7HziVfzZAXJas6MqJkK6pVxSzXEg@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
To: Muchun Song <muchun.song@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 618F9C0005
X-Stat-Signature: kk89uehyyaeu697hswi9cs6kts3rqrkb
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795466974-484602
X-HE-Meta: U2FsdGVkX1/sErW4lGNRbTtBSPhdjWT+tP8fljHDqJYSHoFdjConlhREcbsP0Z4BlthmjOwMI4gIuNrVAtzNtUPG7dHFJ2gnHCuNKlXBxu51lHqQ4Pnaejrv+uY0nYVCGZztv4a9TOSefPYW49Oz18QugkvW1297LmaOa/Z9cnnReY0438d5xHxPFRiHPtOUiqt9AasKypM69xsCl6dP/mm5lNi9rf+7pmULr5RWVDE/GVTS5HbUWC113GcHofmxvOIRVIvcDO8j3Ie74+50r/bnoUCsbK5QU4VQ+oVLifuH8ImOtm+uJ7i1a75YVDKnCN4bz6i/quowEqFCn2Qg18QuqR1QW6nt1aAc9LDeOnqVNnZMjAbGwdJsozpfZQyAnEmWB9aKQDkg3rEyRrHHSdU3zobdhF4VeRvXzqwB4J+eYLO9x3Ry2MUdBIxH0mZ2xA5S2w6t1XhY5uzEy0ABtm33P3xmbSD99nVlgLcDRTc3kqIy8PtTW5R6CMEc+V2eFd6WuycXjCFIkHyRMC5kXNfglTNBSxnjFP4HIGPHV+LtZJd48TWT7kkO6USbLYjcmjCeKLs0+VCZ9SgWHar7HmaMPDDQZmcdR+vw3f8K5NRPexgS072qIyCzKuQH7n+YomP8/b5dxwsUBD8K9rpciS44OAByfaIpAYMff94b+zf/vGPcsNxWTCHvEkOkSeb4+wcbYz1aZRS3cSSzCYCtHM2UvU0CXuuO+ZApo/yp41jAv7vvOVqGhqNx1/wLkRvXrc7rFvqQ+hQ+vyJwtWA76+DrBjgV7keJk5ZVYIeARUYqfvob0IMjamZIaW4VF/o5LUAvSapr0IHiAKYuc5Y5kNtnMSwJqYbGQsiAI+/zq9nivXZb2tzC8vdMwzVasb8G4v55TJ6G10i2M31uc8czPiwEcwFKz7LeCpj3gj3kk57zemEnNpTc8wmQj0PXOmlsCyITx8F/YG3/2KXuj18
 RVWp6Ic7
 gSFxps9ihN8c5IcAVAgbu2pRSri4pxSaJuySqRLGTMVWLEgSCu4zij9iYTudG1B6dHbHIgdlRx9zBDHdYxyKY3wSZvQZJG6FnG+ZIvsauUkMTLGmZLzKp8MjmGEpY2LIGr2lbp9p4rDBdwVYra3D5mYUY+QzUO0XbVqKrvcCfWoPvqaeX4t87qwm/NW5BgQmU4TvUtQJDfe1dzYUCCmMAxAr9/pcwAwWoMJ3IDKlSkKn/oVC3ilZ6VemmzsFyei6f8283lDPUwcV1b4366CUuxslJifOPsI0lfHGHVYl9FUYnqNmCnYxpcOxdOt/BcC9tonjT+i6x3AtaARaZE4u+4CNFpq0Sur0USbd/0htEoClqVU+8HvW9MvMsNgM2AE6+Fwh72/03KXD5rLXJkpyKFgMNy45xCRB2sYGnLVoOa2MM3K5nXOb50sfm73HqONDnCHuE1fTFk9Nj4JYRL7tA9+AWybc9GcaQqWYKj8Q4UHgMmMge2uJLFRtd8aetaCJvIzLISE9gkehbq2VMnZn1vjYqiGlAgO+NSLyuF0CMgLKXVAiRfA8T80QJaH4/LWYF87FD/0ylnTrpa2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 9:47=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wrote=
:
> >
> > set_pte_at() cannot be used to replace in-use vmemmap PTEs on arm64, so
> > replace it with a more specific routine, try_update_vmemmap_pte().
> >
> > try_update_vmemmap_pte() is used for modifying page table entries such
> > that there is a guarantee that no fault will be taken.
> >
> > For the generic implementation, please note one difference: set_pte()
> > does not invoke page_table_check_ptes_set(), but set_pte_at(), the call
> > we are about to replace, does. However, this is a functional no-op
> > because page_table_check_ptes_set() does nothing for init_mm PTEs, whic=
h
> > vmemmap PTEs are.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > arch/loongarch/include/asm/pgtable.h |  2 ++
> > arch/riscv/include/asm/pgtable.h     |  2 ++
> > arch/x86/include/asm/pgtable.h       |  2 ++
> > include/linux/pgtable.h              | 22 +++++++++++++++++++
> > mm/hugetlb_vmemmap.c                 | 32 +++++++++++++++++++++++-----
> > 5 files changed, 55 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/incl=
ude/asm/pgtable.h
> > index f87603135131..123eda3f6035 100644
> > --- a/arch/loongarch/include/asm/pgtable.h
> > +++ b/arch/loongarch/include/asm/pgtable.h
> > @@ -633,6 +633,8 @@ static inline long pmd_protnone(pmd_t pmd)
> > #define pmd_leaf(pmd)         ((pmd_val(pmd) & _PAGE_HUGE) !=3D 0)
> > #define pud_leaf(pud)         ((pud_val(pud) & _PAGE_HUGE) !=3D 0)
> >
> > +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
> > +
> > /*
> >  * We provide our own get_unmapped area to cope with the virtual aliasi=
ng
> >  * constraints placed on us by the cache architecture.
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/=
pgtable.h
> > index 2ebd5fa5adc5..c8d05bc12cc8 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -1172,6 +1172,8 @@ static inline pud_t pud_modify(pud_t pud, pgprot_=
t newprot)
> >
> > #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> >
> > +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
> > +
> > /*
> >  * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs tha=
t
> >  * are !pte_none() && !pte_present().
> > diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgta=
ble.h
> > index 000fc6c1ca37..271cdc61de3a 100644
> > --- a/arch/x86/include/asm/pgtable.h
> > +++ b/arch/x86/include/asm/pgtable.h
> > @@ -1372,6 +1372,8 @@ static inline pmd_t pmdp_establish(struct vm_area=
_struct *vma,
> > }
> > #endif
> >
> > +#define ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
> > +
> > #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> > static inline pud_t pudp_establish(struct vm_area_struct *vma,
> >               unsigned long address, pud_t *pudp, pud_t pud)
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index bc1353f03b08..ab33df268955 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -458,6 +458,28 @@ static inline void set_ptes(struct mm_struct *mm, =
unsigned long addr,
> > #endif
> > #define set_pte_at(mm, addr, ptep, pte) set_ptes(mm, addr, ptep, pte, 1=
)
> >
> > +#ifdef ARCH_WANTS_GENERIC_POPULATE_VMEMMAP_PTE
>
> Why not ARCH_WANTS_VMEMMAP_UPDATE_PTE? Then x86, loogarch and RISC-V do n=
ot need define
> this macro in their ptable.h.

You're basically asking to make this opt-out instead of opt-in, right?

I like making the different architectures explicitly opt in to the
generic implementation; it forces any new architecture to decide if
the generic implementation is correct for them. But I don't feel
strongly.

I'll switch it to opt-out in v4 unless you or someone else tells me otherwi=
se.

>
> > +/*
> > + * try_update_vmemmap_pte - Remap PTEs used by the vmemmap.
> > + * @addr: Base address of the remapped PTE.
> > + * @ptep: Page table pointer to be overwritten.
> > + * @pte: Page table entry to write.
> > + *
> > + * This function is only to be used to update PTEs that map the vmemma=
p. The
> > + * only valid transitions supported by this function are: leaf-level
> > + * (PAGE_SIZE), valid-to-valid. The pfn and prot bits may be changed.
> > + *
> > + * Implementations of this function must ensure that, while the update=
 is taking
> > + * place, CPUs will not fault on the remapped virtual address.
> > + */
> > +static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *pt=
ep,
> > +                                      pte_t pte)
>
> Please rename it to vmemmap_update_pte, all HVO-related helpers will be p=
refixed
> with vmemmap.

Okay, will do.

>
> Again, I still recommend having this function return void. That will make=
 the
> overall code simpler. If we actually run into related issues in the futur=
e, we
> can add support for it then. I don't want to introduce unnecessary code
> maintenance now.

Thanks. I will just point back to my reply from v2[1]. I hope Catalin
or Will have thoughts on this.

[1] https://lore.kernel.org/linux-mm/CADrL8HWNaurYHGnpvC9qwr6bVU74YhhucCuho=
VYcvqmSX+R6+Q@mail.gmail.com/

>
> Thanks,
> Muchun
>
> > +{
> > +     set_pte(ptep, pte);
> > +     return 0;
> > +}
> > +#endif
> > +
> > #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
> > extern int ptep_set_access_flags(struct vm_area_struct *vma,
> >                                unsigned long address, pte_t *ptep,
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index 2e9cf8d39c89..b4d0311bcc4a 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -218,15 +218,19 @@ static int alloc_vmemmap_page_list(struct list_he=
ad *head,
> >       return -ENOMEM;
> > }
> >
> > +/*
> > + * Copy @src into the first page on @vmemmap_pages and return it. The =
page is
> > + * left on the list; the caller must remove it only once it has succes=
sfully
> > + * been installed in the vmemmap.
> > + */
> > static struct page *vmemmap_dup_page_from_list(const struct page *src,
> >               struct list_head *vmemmap_pages)
> > {
> >       struct page *dst =3D list_first_entry(vmemmap_pages, struct page,=
 lru);
> >
> > -     list_del(&dst->lru);
> >       copy_page(page_address(dst), page_address(src));
> >
> > -     /* Ensure updates to @dst page are visible before set_pte_at(). *=
/
> > +     /* Ensure updates to @dst page are visible before try_update_vmem=
map_pte(). */
> >       smp_wmb();
> >
> >       return dst;
> > @@ -248,6 +252,8 @@ static int vmemmap_optimize_pte(pte_t *pte, unsigne=
d long addr,
> >       const struct page *page =3D (const struct page *)addr;
> >       const struct folio *folio =3D page_folio(page);
> >       struct page *src =3D pte_page(ptep_get(pte)), *dst;
> > +     bool dup =3D false;
> > +     int ret;
> >
> >       if (likely(vmemmap_optimizable_pfn(page_to_pfn(page), folio_order=
(folio)))) {
> >               dst =3D folio_vmemmap_shared_tail_page(folio);
> > @@ -255,16 +261,27 @@ static int vmemmap_optimize_pte(pte_t *pte, unsig=
ned long addr,
> >                       return -ENOMEM;
> >       } else {
> >               dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pag=
es);
> > +             dup =3D true;
> >       }
> >
> > -     list_add(&src->lru, walk->vmemmap_pages);
> >       /*
> >        * Map the shared tail page writable intentionally. A lockless ge=
t that
> >        * read a non-zero refcount before the remap can still do its cmp=
xchg
> >        * after it. The refcount is zero, so the cmpxchg fails and leave=
s the
> >        * page unchanged.
> >        */
> > -     set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
> > +     ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL=
));
> > +     if (ret)
> > +             return ret;
> > +
> > +     /*
> > +      * We successfully overwrote the vmemmap PTE, so the page that wa=
s just
> > +      * unmapped can be freed, and if we mapped a duplicated page, rem=
ove it
> > +      * from the list so that it doesn't get freed later.
> > +      */
> > +     if (dup)
> > +             list_del(&dst->lru);
> > +     list_add(&src->lru, walk->vmemmap_pages);
> >
> >       return 0;
> > }
> > @@ -275,6 +292,7 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned=
 long addr,
> >       const struct page *page =3D (const struct page *)addr;
> >       const struct folio *folio =3D page_folio(page);
> >       struct page *src =3D pte_page(ptep_get(pte)), *dst, *tail;
> > +     int ret;
> >
> >       if (unlikely(!vmemmap_optimizable_pfn(page_to_pfn(page), folio_or=
der(folio))))
> >               return 0;
> > @@ -291,7 +309,11 @@ static int vmemmap_restore_pte(pte_t *pte, unsigne=
d long addr,
> >               return 0;
> >
> >       dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
> > -     set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
> > +     ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL=
));
> > +     if (ret)
> > +             return ret;
> > +
> > +     list_del(&dst->lru);
> >
> >       return 0;
> > }
> > --
> > 2.56.1.809.ga0b61035b5-goog
> >
>

