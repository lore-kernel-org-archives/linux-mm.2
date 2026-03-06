Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA160F01829
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3A86B0092; Fri,  6 Mar 2026 06:33:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF136B0093; Fri,  6 Mar 2026 06:33:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBA46B0095; Fri,  6 Mar 2026 06:33:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F29E96B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:33:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 933241C6C5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:33:30 +0000 (UTC)
X-FDA: 84515427780.25.15449FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1EE47100011
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:33:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=No69KQPL;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772796809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePoBefWpdU+wgQoavMwDDxFLe0y8Dii7F1HFodxXOe8=;
	b=0bOi0eqHGZr+JuGkprGeoGEs5MNwdJD7EQRcBIDU1sqOdnVAsfxmZbAlJ9l006asaheoaQ
	m861/wAMyzJmrm977HCyueWIc/ihF6NFUTYWP8lJKsmfZMeT8hKGSPMZu+bVRcKkk08ELt
	FZ1md6HM8Mv0Busv5avZFeCY7z/Hr8s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=No69KQPL;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772796809; a=rsa-sha256;
	cv=none;
	b=W69qAi+k48gSs85bVksU5P6cnF43UxafsFS929eL3lhkOOkAgwE2fqRPLaltweZIMzW0I6
	KP2SqFAzWx7N6im0h7eH48Xina5nV41gZAAMeeUuiFCAJCMgi0LB+nlbhW1SPYsWQTiF03
	kk5M/k9SCYb/95E0FMocOAJ4gkZN1U4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2CCB444F7;
	Fri,  6 Mar 2026 11:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F806C2BC87;
	Fri,  6 Mar 2026 11:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772796807;
	bh=RBbtaeJIVRam9A0+0nEw15ZQ/vsFL4LW5MRLADGKFcY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=No69KQPLwYkjO7WvUawTvr+cGDC9dvQUHAODxK1fvdChKkJg0ByANlrCS3moc9wJx
	 zxDxk3btlwmpztOa/LgOuCV8pxelUcKyyi/4NjIfaZssSYNfE3upqZ8Mv1rPcxidf4
	 bsrkdZjpT8TvNa0+voc/8Y7UzgrWnDHZ3PPKtQMlq1+x+JaJHgLECqaSLROwOG5dw4
	 n798AW/y38bP+bRv7K4VNnHQMGm2/QXLEbeTLGzrqNCOuA04W5n/hGQrgzI0V4PjXv
	 yOvKFS7J/FrayJJBKVc0+jpzUp80k+BK6YPrZAo/QDmwcudV/xB/kgftokNnChnWQE
	 r9i3y6MirgAog==
Date: Fri, 6 Mar 2026 11:33:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm: khugepaged: export
 set_recommended_min_free_kbytes()
Message-ID: <140d8a35-8c29-42ad-aa8f-e048bdf59f03@lucifer.local>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-1-96b3ad795894@debian.org>
 <043071c6-08d0-4618-9a9d-196ccf1caab1@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <043071c6-08d0-4618-9a9d-196ccf1caab1@lucifer.local>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1EE47100011
X-Stat-Signature: 647z3z3q9hnp8qosw8fznuakw3kir8aw
X-Rspam-User: 
X-HE-Tag: 1772796808-371884
X-HE-Meta: U2FsdGVkX18QfFT8FerYIWAYthCKjMEPSd7O7AKQk6J6C6qEUQpDyuzZa/q8bADi7iEpUs5rQXR/kA6u/Lb0/dImmpqoIB2IhP/QMZyCvr9Xa3NjIxGFZYGK/KwE2oz5/u2yPB1hFSV48TAJEJH5xzZijzMlj+6bgPjPqze2R1y8BtHeubZULR6ibyDqfcpKqGh9lWtL7wH8RWrrEIxaVjpbHTTbnm89CLuQsf12jq6sjkx8fBeQ82e8gSMjfdw53wBnC17cTH8CPTz3Qy+vuRlNBc35G0yo+VdtyspF3G1ejoZbUazTR851mEcXOAi6J5RwZkXVZNfpvmHbDkkthrJsXbc17vkUb3mnmGEEJ+yjPBODTpu6cTvzp95Vb+xYBBR7RgofAd8MDLXU0s1do7LWNSJqRBvXOC5PjRZ1IVjTi85/CDfqGrfdSzdKq/nS2BKVT6MD1Vnpfv/KCriGPdVGzrnlOd3BKm0JhDMJIG/sPoEtuyleRy8dIvu2FZXJxtlP893B04RwJjcAT/8nqBvNfBgPDLYv+ePc+zP8h9OXxGh6gnCLMU4+rIaXdzlbi8iJ8+OgpbB6S8y3cNpHNer3I62uKCB5baqjEdqlbxusp8N+hqRw/2JAedXhPHmeGWRl5BsfCGm8W/XQVpRxLbtQ6s6S+a/Dd5pdKK+F5crPJ0mCc0ueX14IUbvg3oehCQdvowIhvfKbeNMEFHLbFwGsTDWQyX/Ubp90qBs/fWYK6qYyF5eg9Bxjyz6O0rb1Kpy/oupwPMCR7F7lkrQwN28+rY/nQBaKsbBlBv1l3ikHw8RXFtJ1AF1QUS7pBW1AfOZhYIonqFDZ9wFwHVGvWFNGgpIjXGZFTAANDNNkmCpfDO2QojC34BhLNkajzJjpV/dy4pJzfK+g99TkJXD4ROpeZuuJDQ9JIS6+Jc5QGEBpoEJllaUMHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:20:57AM +0000, Lorenzo Stoakes (Oracle) wrote:
> >  include/linux/khugepaged.h | 1 +
> >  mm/khugepaged.c            | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> > index d7a9053ff4fed..76252865fca4b 100644
> > --- a/include/linux/khugepaged.h
> > +++ b/include/linux/khugepaged.h
> > @@ -16,6 +16,7 @@ extern void __khugepaged_exit(struct mm_struct *mm);
> >  extern void khugepaged_enter_vma(struct vm_area_struct *vma,
> >  				 vm_flags_t vm_flags);
> >  extern void khugepaged_min_free_kbytes_update(void);
> > +extern void set_recommended_min_free_kbytes(void);
>
> Please drop the extern, it's a historic artifact that we clean up when we add
> new entries (I don't blame you for including it, it's a sort of 'unwritten'
> convention :P)

Oh, and with that fixed, feel free to add:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

To this patch on respin.

Cheers, Lorenzo

