Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585CBFED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46DA6B00A6; Fri, 24 Apr 2026 09:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F0F6B00A7; Fri, 24 Apr 2026 09:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D296B00A9; Fri, 24 Apr 2026 09:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6976B00A6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:37:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B45C140195
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:37:09 +0000 (UTC)
X-FDA: 84693550578.14.1538B05
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 848191A0014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:37:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FvSWv3st;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWWbj/VPS78zqXVF7C00n2rbNCSFE3WHczyNV5IMoNo=;
	b=cX7uRQjWYiIqkYlBay8wOD6QQ/CU7k1WTzTUnNz3gAdsAwDPzKd2F/d12MZ3/9yZVS8XI0
	6VNY9KAnHxH0x7eDT39I9Httl/PBqOjAZ4n1HgU33GcMlLNjb6ZydEyMo14HBHOW9JkFAX
	najDd+I1TGzXQXgbhRyfsIVsppJxbxM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037827; a=rsa-sha256;
	cv=none;
	b=VIsGPVwWzFWU3Gv9y7hvC1mjx7yixKmhTOQIMJZ054uiSjZPclG773OGkD02bgFLEUhidM
	dh3osc1AMTKElyw7bTXsmcia9qCqPsJJ0VP4tlrydMzc5B7kdFRtIcpYJrXt4Fy3Xt6238
	CiRDd9Ry+Kp8IKQtkUsSNLx5M+o2VvA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FvSWv3st;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8f231f3b130so88746085a.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777037827; x=1777642627; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uWWbj/VPS78zqXVF7C00n2rbNCSFE3WHczyNV5IMoNo=;
        b=FvSWv3sttOhquhwO+I/7XjDvKEjp6szkD+qOgRN9zI5ep5UlCqWoKv2QVauCuVkmwO
         8jLhZdwTNwZzcg88+w/5g7xzcX898YPLhvFcQai7lckB6cVZOMVd01/1Bf/vWR/KKezs
         DUndxMGiQFurWWXe/Ws5+/htMCeET/vVokEpsECmMRmDynSHcWHW4L85f0uwYXCb7x8c
         oilVf4/atwwE3HRNLlhdV3Bb+uuXGL632jxrr4NT+0oamAURu9Qkd8SX2OxFLyumRVHB
         gMJNQF8lbUifiel0cym2RYBi6mN3ioi1/izzatHqEPFzUfN/uOyAY2D5j9bfWVHqhymJ
         0Fiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777037827; x=1777642627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uWWbj/VPS78zqXVF7C00n2rbNCSFE3WHczyNV5IMoNo=;
        b=csXNWfIOsErwbvxwc8id3kJXNz7ej3e2APp0mp/z80+BRh+MYtKDw60xAb/4iwXwNN
         f/Iqg6ryK2SVdpCw/AOq5lTOL6ElmxQz3jLxJVjNkALsWEgCc88xKdngcbj62hGbRQnX
         uhiOVW4dW/anvXWGf3SK4bAAJKJNRGrBLc3JPrs2Y28U7XszSc3bcJC/hpQm2EmyY9pM
         krAH3k1XPkGBPPbOndMLfw8YDauiKp+MPmWlQLpvazGICwfmU7lmtf54NWfH44mCJDuN
         FGqo4iNEXsoEBrCtt5SsbrSDDa0q34TnB3hwdneW7+E32rhWypg3qSng+Dv+q15l5VYL
         v+SQ==
X-Forwarded-Encrypted: i=1; AFNElJ8wQdZ/eC/HEs+XwD+1r0Jz7PyTSBHa0j832+H+iBqxevVHOlTbgd6Lktmkf1QYLZAB93YC69JApQ==@kvack.org
X-Gm-Message-State: AOJu0YyMxrPgDef1qv92PHHEfKuwR9DR+f68BWQwbJKVJ0sUijKbh1Pg
	UbwFUjxSnfedaRCkq32bGcA3nnQaalgVwI2ioPYFXF/YZlbRPWuR4jdcnYh4XPmkg2o=
X-Gm-Gg: AeBDiet7krLl26CGN29k8TxFs0J/ufEhEABOM40wLHrs/dhuiATGKcCJ+AlcIbcTlVl
	plmsE8K57e26caioMId1oIRoi7ENqUk02l4+PJvw3igXmnefwQG3OtdvP1PTGAfliFhhUhKKPwV
	VGIDtkldHDfOpHd1Tk2yb63r6Q1BzwkcVMC8jDwg0G59dd1DajHLyNVUAr7hfoU8UmF23rsRmKB
	pH4MH3PhQ9NZSfu+VZdYM6B2+Z/KrCa7mhdoKidLf/ZMIeoUiZxGBznsAlz9vESIivlEtkTcdgH
	cpBfAbJTzsYqnD+Lx1O/ht1MWAG+aPxxC+BKYG2MZ6d2xBHn1PVOMWeEpm4WOeuytSP1Iyyv7RU
	pO1PNkuwBWITADSuzUTMTZszzGeUASngprTawLI4qIRI46xoTq3P7iJIc9Ug7OJ04xt3odeBuak
	n5+XZORO+oMmI9m152Tq4k25J23viVhHOLRdtlmVUo2+i4wd6GgvkFZAvwdM+iZQ==
X-Received: by 2002:a05:620a:17a3:b0:8d0:27b8:fb7 with SMTP id af79cd13be357-8e79246cd79mr4470598685a.46.1777037826446;
        Fri, 24 Apr 2026 06:37:06 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe98dcsm1992846185a.7.2026.04.24.06.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 06:37:06 -0700 (PDT)
Date: Fri, 24 Apr 2026 13:37:04 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>, peterz@infradead.org, 
	david@kernel.org, dave.hansen@intel.com, dave.hansen@linux.intel.com, 
	ypodemsk@redhat.com, hughd@google.com, will@kernel.org, aneesh.kumar@kernel.org, 
	npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com, riel@surriel.com, 
	jannh@google.com, jgross@suse.com, seanjc@google.com, pbonzini@redhat.com, 
	boris.ostrovsky@oracle.com, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ioworker0@gmail.com, roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-ID: <aetw4aoABYj3keMh@plex>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
X-Stat-Signature: zm6p7g5g74pqd1xio6u6mec4cru3tf8q
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 848191A0014
X-Rspam-User: 
X-HE-Tag: 1777037827-849475
X-HE-Meta: U2FsdGVkX1/o/aDmvRb/TWf03u09OLq/8l9CaYUDlwakwGrb4Z0RX6q30IDyF2ND7UsBv3Yw2HvYj8vNJ6bIq8KFwmWGb03GYSe978ThmutxI86AfMrU/hCSVUC+0joO+7g3A2qgkxAbkg0Jl9FOu3YMo+Ol1BHZ/CKoWce5t2z7AGzP5dH//tHUvrQNXiQJsyCnDgeJ1f+6xl3Zz2tZi+c8Erqy6SUPJNHGDoY8e3JKx8sG2KmPj0UaNxhltqNGBpOr5IQ/RRAu9zg9DfgJLbr3a2seX8+AHk+0YMyShGmme95KtsOsazkR90HdIdba2K0m+KqZBtyqBVApqpb1pFQwR6WYhuo0hG5A3ZLF+H70+I3sG5P63z42tWl8uXHMH0Uh734adCpLQLpAijU/9NaRsCPnJgawoxpctJwaN+EqUfLG7vMnyEN9rtSXrQ98JZNcevGwaReXuAg5V1rcJIBwmDoQb35ue1w7Asg8fJJ2e81IdtaYBmfxKE6AFqmoLm0yEscX6wb51CGl8obJsRraMX8qMi2IwTnuqTaLCyxX7K2xSZd+Jk/mX7JfrTLE3qa39tTxj5P03LbpxCGaEFUmemPyTMiRpa5bivtUeeywvwZoa/ZQpgPcvzt4pOf5OzMPQxJpXp9clFe7h7/eEM830V+qVFjoIaMUZHuy18ncISjlQBMjuffv2fkbNJRYRhRDnKsM/l1QmlGpR1CliSfOxvpdJQXIqQ15m+UAmllv8XJdSdSwCvgVWtqx3qS0d1md/QD1BRrUETabLA72ztRvjeCmAswHzlom7SiQeI0myOkoaptn3M7nKB2kOn2O+yw5zouGSQHv225gdhEAp9h9ltwgCA6H8QWszKYULPej0MBQNHMerIyvwbZvFN1dzDnuwaejIysUbL7pBTonzn1MZDuweBegSVCcjgoVmVa4NZJKZO0o8PU5nhL0HPeRQaibGzaQF1RUCVXRNEC
 Y3FdvHb2
 WzPI/YsB55yedF7q2aCpZAoFFni2MJadju56hnMF7+QUNDtSIQrFf0noBYm4SWPBsKsYdd5oLthWUniNqcmv7klNVWKr/0srWwKRQ1UYlaQJaiaSZd4aCSqan/FjzE44p1jR/QClF52QBuh27XD8s3CcnQbnSkl0oov9RbsndEr7k9Q1yOTQJzsFxm5R54/Tm8/IF1TNMXVnf+XHdkd+cLf+Xgl16PKjLTYV3uGzPOVyKM2qGKYu4nxHoPNUuQNrubbmUZIR27cH0IgV7vncz2ieziJ8yH+yFQEvSV6Gv1dJjZ7K/L0/PLaSyXhZpuLyKdk+044oyMvttz1w+X/MkVh7U9MB2+y9NSscSXzd5tHSwKpNjrJZ46pye2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-24 06:30, Andrew Morton wrote:
> On Fri, 24 Apr 2026 14:25:26 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
> > When page table operations require synchronization with software/lockless
> > walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
> > TLB (tlb->freed_tables or tlb->unshared_tables).
> > 
> > On architectures where the TLB flush already sends IPIs to all target CPUs,
> > the subsequent sync IPI broadcast is redundant. This is not only costly on
> > large systems where it disrupts all CPUs even for single-process page table
> > operations, but has also been reported to hurt RT workloads[1].
> > 
> > This series introduces tlb_table_flush_implies_ipi_broadcast() to check if
> > the prior TLB flush already provided the necessary synchronization. When
> > true, the sync calls can early-return.
> > 
> > A few cases rely on this synchronization:
> > 
> > 1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
> >    of the PMD table for other purposes in the last remaining user after
> >    unsharing.
> > 
> > 2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
> >    and (possibly) freeing the page table / re-depositing it.
> 
> Sashiko questions:
> 	https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev
> 
> (I never know if my Sashiko emails are welcome/useful.  Maybe Sashiko
> said the same stuff about v9 and it's all wrong.  But better safe than
> sorry!)

These emails are helpful; but, I do not believe you should have to 
manually follow up with a link to every new patch series.

Perhaps  Sashiko could automatically send a summary email in response to 
the cover letter, or provide a link once the reviews are complete. For 
the kexec ML, we opted-in with Roman to receive automated emails from 
sashiko.

+Cc: Roman.

> 
> 

