Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AD6CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC058E0008; Wed,  1 Oct 2025 10:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383928E0002; Wed,  1 Oct 2025 10:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2728E8E0008; Wed,  1 Oct 2025 10:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 12E428E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:35:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9E99160AB8
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:35:44 +0000 (UTC)
X-FDA: 83949794208.27.33390EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 802CC20011
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:35:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fLksBjcL;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759329342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BoSJ/UNITIMkV6E4NWf6uVIJcLK8gRuM5n7XzbDfFos=;
	b=s0mXBKmTpmr7Q46kGwIhUGT3EA/iL+uq1SpEmEuHoSYPddH6ZVAXmv4Db8cFXe/jRuhS55
	Cg5xdsfExr0GIYZKbylJaK6GBBYWR4HH2YpDWqReTW7h3ZlPVPpPGnHOwOcP9DHlqRcQP5
	JlXc7aZ59cZLiNElXHBBumIALbWMMbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759329342; a=rsa-sha256;
	cv=none;
	b=PAzIdYf+73jUQdsSjDTeacuM61U5YR9svWVcCYTAjAOKjPzyL5v8jAqgLkK/i+LI2FuyLu
	6nDPNCfW/HJaUE/EXeTXlUCRZgvKvxZOXcwdk/5lVmtqC24/kPmdXHK+SEmjg9KMXSz/SF
	olwXehHemPMfFiKrNjs9Un4lK3wWnkI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fLksBjcL;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759329341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BoSJ/UNITIMkV6E4NWf6uVIJcLK8gRuM5n7XzbDfFos=;
	b=fLksBjcLPYkBfxzcNBBilGEVn33Ol5VaLRyvBojz9OUsscS64R/3DPoPVwUxZ6RkXMl3b8
	K/Gv6VH6lXguST3N3WKoPTEkwGA6pQQO5ykaFwGhk8pvyJUznpqojq4nQLFqLoORpvYCQ1
	R4Jm06l2mJr8JyoGtGP4ONsGyrwnc8I=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-tvgPdT_tO8aAagS3_dp4uQ-1; Wed, 01 Oct 2025 10:35:39 -0400
X-MC-Unique: tvgPdT_tO8aAagS3_dp4uQ-1
X-Mimecast-MFC-AGG-ID: tvgPdT_tO8aAagS3_dp4uQ_1759329338
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4de35879e7dso122262431cf.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 07:35:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759329338; x=1759934138;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoSJ/UNITIMkV6E4NWf6uVIJcLK8gRuM5n7XzbDfFos=;
        b=PC8tinvg5K/2EVH7Fs9/8SgHNhViWVBpTnlvZmwIiTGTqHKY/gCvzAEL7Yu1p36Efq
         Acep/6DeDcK4Mug1I+rQkSTRvbb5SaM6uhizMTOviTyZwEmWl4xEJ3rNCAI23Epopbd9
         56pzc2i3OVtwA9ePqHKkfMm80pvsiCWuq5atkai+4b5Wcidjw0J0LuTv7rxLoQZT/rCm
         GhV83U4rS6WhFJBs9HjTbcCLfen9JHGhDzigDeOj9hvSncByBnc6TxyVfP4yYsyM43fw
         N7l3lglcc2CV0rs27QdbxvbcUVBkd69hDMJWUsFQ+OeElJv8xZ72fQP7uDnalR2Je/+k
         ujmA==
X-Gm-Message-State: AOJu0YwwKz7BzLinsRzvXPZsqpjhtRgnVq2Oum6C7jlXK81g5Qh1bxeq
	nvUBJs3m3ZYZK2zXMC4foP5hAlAJDkprH1m+gCGBKd29oKjMH2aU1+UeaSS5Uqu5uR9tQj3MB4J
	ITEvmYCjN37OLbFz5fhZ9EoLJqlIrsFCvt98F00uTyPjwLMUic/eN
X-Gm-Gg: ASbGncslxk6XFFFChXG+KtmLBJWNxZVCBAlcJJVaGuzMmolc4w5FQIvJ0L0m7QBk1iA
	86B5rdU/cXo1aZ5AKXHtgBib95EhpmEV5EtrVR0qCAt0sjoN3jIA2uBUrwIpzIvOmXqc4PS7zvc
	qyNreqifiaTVkGGc2McpbE/IaeFRlwSbbgw+Hn8LQF2oyN9riBvXBiUyTfdVBrSaZm7LxXk54qu
	t51cgzguhNtttmtdTVulJum81eRiqAtTKCX+dsoGwdMTm53vCAETn8tknt6TuxSuOYkNjIGGDCM
	5OM2OiLF//mYVabfoToldsTPmNoheTvsm8BTCQ==
X-Received: by 2002:a05:622a:488a:b0:4dd:e207:fe4 with SMTP id d75a77b69052e-4e41eb17812mr47774571cf.59.1759329337762;
        Wed, 01 Oct 2025 07:35:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhLIp5lzdVDeFvG81gfpmp2z3qIn9O0rp5mce0smNOD1AJWGIvivjhG4Il9kTcoZYm63Jv2w==
X-Received: by 2002:a05:622a:488a:b0:4dd:e207:fe4 with SMTP id d75a77b69052e-4e41eb17812mr47773831cf.59.1759329337136;
        Wed, 01 Oct 2025 07:35:37 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db09f19dbesm121035751cf.4.2025.10.01.07.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 07:35:36 -0700 (PDT)
Date: Wed, 1 Oct 2025 10:35:35 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aN08NxRLz7Wx0Qh4@x1.local>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
 <aNwmE11LirPtEuGW@x1.local>
 <f409cbe7-7865-45ab-af9a-6d5108bc5ad4@redhat.com>
 <aNw_GrZsql_M04T0@x1.local>
 <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
MIME-Version: 1.0
In-Reply-To: <43d78ba7-8829-4a19-bdf3-d192a62cdac4@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RP2imeXtpNvoooy4X3xxtTEP3OFpDqAB0o-KxF-qcsI_1759329338
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 802CC20011
X-Stat-Signature: tq4ixyxntdifri3744draug7a54wbenk
X-Rspam-User: 
X-HE-Tag: 1759329342-866417
X-HE-Meta: U2FsdGVkX18d5ClxL1ktx6ENuoL6PfXz/3sumEJu7VIFouLnbNxu2tssWh/K4byp+/+eVusTnTQ3Sb8OOzkqvVRJ80QDjwlRMAQjegDxZYE1PgOm5hogxAjHJh2TV5L5n0MjQm1xcE5jKmFs+ge8IJrIwNhYCD0U4H7jCfdyRgiPW6C9VAIQL+EKZESULOxKsqWhnTOPOOsWazEaLSOjQYkHgdyIyN6ApfzG7d3zQrKlygFuRF0wcPXhBc99ifg0iPlcZIVrTFRDymDBRP1ZTF3sEbWfKH5UzZa7/3gAxnEu6+xV6oO0gjh4JVdxlEBiANLYjl3kBfy1xUunx+gQgMn6IBtJwTSxMDxJhoAPGhvoKtkLsqwHySAo7m4q0u/HQ12bt928lS1CgYBsS60tY+gf1J5qEK2bvsxPlSMB0OFWAWmkDDqh7RGxztaiNa87pqUGLBVytiCEcqaYiAtKsyRKLF7ZNf5E25bn8UOsHhDRr41ZCFZTODkWGVuoQXQWDWcJamd3AlZ4KYt1/9a2IME3D7lu08HkDQW6f6S4Hbx73iG/aGsMC3xWKDxhgbHtk3ZZvOhsfnntKKWqfbdNa2ZU3UkcEEmjJS+6Rn5KaBYTpbaRxZ3Ive2L9dXK6p8engIkWxdroKB2O8zfHocFRPrQzRfYEOcfbSmsKxaIVje7OHUcaw8A9Ie58JvdjLJmeDhXR/RNQ1gfJLtBdAZsjiBEsPls1HB1tyxxGRUu7pUUIOYUAJBh4DuFk7Mg5/WywafFV2pf9QITCeF86vbREqZeLpLCt4MEoja/IT58GQkKUUfSNxVflkWecMovDxBRNBfsLYm1ZqjOo86hZdJl3QpCgg2fuPUkfo37J/mARBYuEfTeScumtJc6TEBvgpqMbWBe2nzvEJZ/7pn/4rQZ9shqulOcJ94SHiS/4nfwRpapFOssd9VMfmgIQ+qcD0zvbQ/prwZEg14++Q43Zza
 VKfHknKg
 S3/S9/KAbn51tel8W06WY32vHOuDgaHQfuufquk4WD5BwF3XLETjEoe5BBp9wRw0mBCPnYRd2D405BzwuooiU+kC9QZKjNpfJa0Ni+YNCXmuSqR5pcBit4+IOtRDEb0sa21Vpi0o5KoxgjI2GpJAso+Frpfc/sDJK5SzL/02XDthjFARA1OaPp9/XRTiyiL6ys87PqjGpxbnASxj7MxAWuZOgzdnUpqbX3JTC+K8DsG6/nMlDQtCfihyQeqlCViDu5qDPPyEoZE14O5vO8NTwXLMfPVc6RPASRVxlF0fPgrz1Zf8tZ8IbIzHotWs1kG/TFs+JAx00w9dWJNL64+RTFVSmdYbOGIcV2/JLQYA4PgOh0geKXGY9/yZ8cSNm4BeeSUVNePSobVT39reQxqdcIwbhKSc6x1CrsNr7n12wMC1HnHfuYUgiIrK3MLmf+W2copQTPG+Emv/JNe6gBz3pvAZBn+nQDCXMKlwO/pq1oxNTTEP/jlAsDAW9fJKjWv22iHO+JH90+e7O0fO1OKdKY4ba1n5gMxDYl1zp1ancBG10Ya96dzTLjGXWv2fEDlyWRG21QsqbVR0oXxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 03:58:14PM +0200, David Hildenbrand wrote:
> > > > > I briefly wondered whether we could use actual UFFD_FEATURE_* here, but they
> > > > > are rather unsuited for this case here (e.g., different feature flags for
> > > > > hugetlb support/shmem support etc).
> > > > > 
> > > > > But reading "uffd_ioctls" below, can't we derive the suitable vma flags from
> > > > > the supported ioctls?
> > > > > 
> > > > > _UFFDIO_COPY | _UFDIO_ZEROPAGE -> VM_UFFD_MISSING
> > > > > _UFFDIO_WRITEPROTECT -> VM_UFFD_WP
> > > > > _UFFDIO_CONTINUE -> VM_UFFD_MINOR
> > > > 
> > > > Yes we can deduce that, but it'll be unclear then when one stares at a
> > > > bunch of ioctls and cannot easily digest the modes the memory type
> > > > supports.  Here, the modes should be the most straightforward way to
> > > > describe the capability of a memory type.
> > > 
> > > I rather dislike the current split approach between vm-flags and ioctls.
> > > 
> > > I briefly thought about abstracting it for internal purposes further and
> > > just have some internal backend ("memory type") flags.
> > > 
> > > UFFD_BACKEND_FEAT_MISSING -> _UFFDIO_COPY and VM_UFFD_MISSING
> > > UFFD_BACKEND_FEAT_ZEROPAGE -> _UFDIO_ZEROPAGE
> > > UFFD_BACKEND_FEAT_WP -> _UFFDIO_WRITEPROTECT and VM_UFFD_WP
> > > UFFD_BACKEND_FEAT_MINOR -> _UFFDIO_CONTINUE and VM_UFFD_MINOR
> > > UFFD_BACKEND_FEAT_POISON -> _UFFDIO_POISON
> > 
> > This layer of mapping can be helpful to some, but maybe confusing to
> > others.. who is familiar with existing userfaultfd definitions.
> > 
> 
> Just wondering, is this confusing to you, and if so, which part?
> 
> To me it makes perfect sense and cleans up this API and not have to sets of
> flags that are somehow interlinked.

It adds the extra layer of mapping that will only be used in vm_uffd_ops
and the helper that will consume it.

But I confess this might be subjective.

> 
> > > > 
> > > > If hugetlbfs supported ZEROPAGE, then we can deduce the ioctls the other
> > > > way round, and we can drop the uffd_ioctls.  However we need the ioctls now
> > > > for hugetlbfs to make everything generic.
> > > 
> > > POISON is not a VM_ flag, so that wouldn't work completely, right?
> > 
> > Logically speaking, POISON should be meaningful if MISSING|MINOR is
> > supported.  However, in reality, POISON should always be supported across
> > all types..
> 
> Do you know what the plans are with guest_memfd?

I am not aware of anyone discussing this yet, but IMHO we need to support
it at least for the !CoCo use cases.

I do not know how CoCo manages poisoned pages, e.g. if they are kept being
encrypted or not even if corrupted.

Thanks,

-- 
Peter Xu


