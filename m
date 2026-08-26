Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F9E1C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 02:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B2E6B0092; Tue, 25 Aug 2026 22:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2021C6B0095; Tue, 25 Aug 2026 22:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119306B0096; Tue, 25 Aug 2026 22:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D22BC6B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 22:46:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B2E81A0162
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:46:20 +0000 (UTC)
X-FDA: 85141881720.17.FAEACDD
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BD19C0009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:46:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kZnnwiI2;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787712378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oz5icm8sYWRIKXUihXBHXUV2LJ3XHQzaAaHTPUPLgHA=;
	b=hhqDZ7tXJhKzJ3LV0U+Pp/YeANPHjEGoc7H40goq6fkxGn7qfEphyWlkSEU4oZOUv5JQqb
	pWIf7uQHNeYs4N6CVq2zIUPitLInGICltbOytDjz31WRyYJKZYXY50LWN/Tdkyn1iYcl3t
	O7Bya0aI5y6hX2MzNuji2L260OqOLn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787712378;
	b=ahhqLI4VnrrUtFEbpZp7OSve4eri/yJ9pEnJx9Odzr4xANG4omrF6PmQs4d+o1volh37q1
	WlyI7AeT+isL181yJ3l7ciB1o6bsQXhhkqflThR+WHN+7CRRxAsPf5IyyIBAJAdD/9erDk
	gFD956MzAuu/uMla3OctxBurWwIto78=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kZnnwiI2;
	spf=pass (imf22.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d6d28aa26cso4210405ad.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787712377; x=1788317177; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Oz5icm8sYWRIKXUihXBHXUV2LJ3XHQzaAaHTPUPLgHA=;
        b=kZnnwiI2Ud5PRQ6AyC/eJsY9OhmnhJSyLU+MkwEDpdIFVQi0+MPP7W78Bo4vUvKUkc
         WFE0GQo9z+IWRABnFrNAvCMQZnp/9wqAoO+gspP2JD1ezhirGxCsIKbEZySlNpIHwa2J
         pQxG/3yeNsobpelYn2foVqg6pKM40DK38MOoLZwq65aiHM8bNdR5Zi2TIXU3/PyxeOto
         o4bZulXrpadhpUivM1gMxrIVtWAnzrE35RsKL63nzUuaXHc1D65lzbc35dNDOm6clLk7
         zEzhXgfNrK5XN9o8T340EiBYD7OgD7mrd1eWsPi6hKuNdpmPrkValP/ly1mYbsXJaa3h
         P6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787712377; x=1788317177;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oz5icm8sYWRIKXUihXBHXUV2LJ3XHQzaAaHTPUPLgHA=;
        b=MtsEuB8E5RJNEjJcaeOoXTgORXjBJqWJ8a4XQowe/t0S3fkV+ep5m3eaugA6ZioAPq
         BxAvlpMs8nTtTRi8Zt+twrtURpmtWO6/0HvEYFkh7NqaUL9gRID7vMDa1PTbaZ5actj8
         SG3dJfemstA+fQMYqiVIqy+f4ZtSL3jU74ACOVrUN7NYvKkwHeMG3f+E6ucEBUnk6HpQ
         ieupxMLBxgduua0dIdQlAoI4pb3IbdjAiH0Vj02KhU8vyx/0bhFoQCs9wuGuP6AvIkXK
         C1VdPoAz54CyQtpgqd6Y4mKTpEZorQX6Gt37QqlvpDhr4QDKo4Eqrp5Af/TBW0T9h5nX
         J4aw==
X-Forwarded-Encrypted: i=1; AHgh+Rqc41fdOlQYT6XHN7kkAMztm2Qduj+1I5n6HD71isc4MOC4nJvIVRIXMvkNVwAixSXKhpWbIBsgyw==@kvack.org
X-Gm-Message-State: AFuF++nM4iHlm77fFMPqdtQHxW23XF2ppYxruQNnL9WrZsrjwmeNqUo6
	kc56dCEWb2qBIIqoAakGvD8ubFNEXtPZZLCqj53bI9BVdpABD3Jjc4c8
X-Gm-Gg: AR+sD126nsT5hoTO078RUQQn5vrC0suTqO1rHpcUlL0ZSQGKcnEWK74G+cMR7n2wLJ3
	UIheksKSgCkYIeDG+n31jLSoUPqoxPam31yvMDkxiIOrOzPyPc1JGsViQqBGt48M7XI+nYuqVqv
	b+QKye7LnCGwZL1h7JrEprJQ5ye06wR+Vs4KuqNhxJgSzD1AuWkVPFL3en2I7ganACKJDrxpo85
	kntilsemFyo9JNu2/xNi3A2dyMR5QGOpuS0pP360ipT3mK5WTiRkTvb5ZW+YPwfdJBuaEdkaF0N
	3K4pXVjb5oIoU+coPEoPtLUGxpOT7v7aWqRbdl4dVFzNaVE74/gMHm3d/ylwAC/lcu5w6406fWz
	ssUCnCP5IOWZe9YeEkHGASLZ/DsZyx4HfmX5CqlK2wSnOF3QPopsteKEsQbcHif3yJOfztUc/3V
	SasHQOnqY6wRv8z/SXde/QVO1wRha7KBahnNsURk68aWuoXzj9SAvFu3rniIXUWRuczRMVECuAk
	5A=
X-Received: by 2002:a17:903:1a0d:b0:2d0:8b28:51ab with SMTP id d9443c01a7336-2d707ad0d63mr52827945ad.7.1787712377408;
        Tue, 25 Aug 2026 19:46:17 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d70493d127sm3388825ad.17.2026.08.25.19.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 19:46:16 -0700 (PDT)
Date: Wed, 26 Aug 2026 10:46:11 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, zokeefe@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v3 2/3] mm: khugepaged: fix folio is used after
 pte_unmap_unlock()
Message-ID: <f285e26a-b790-4afb-91e9-a2b404df018f@gmail.com>
References: <20260824092935.73892-1-vernon2gm@gmail.com>
 <20260824092935.73892-3-vernon2gm@gmail.com>
 <0bc399df-2555-4378-bee4-eacbff434bdd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bc399df-2555-4378-bee4-eacbff434bdd@kernel.org>
X-Stat-Signature: 9eg8hme47rz3x9hs6f3xtfgjeqacsrfm
X-Rspamd-Queue-Id: 9BD19C0009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787712378-429553
X-HE-Meta: U2FsdGVkX1+ccfLqXyDLhMRHP/kyDM/sZDTTva/svQAHcDKTDpmjnFYuhSRpW1fxRYgKLGLAXRlRQm6EdxEajDEQdhTIm2+ght4N+MkxSuLA8ygeSYR4W4tnLZrh85wZP/2O0jNWF8scCsfdHm5h3aLX4e6eHj6yWAYvOWVK+3J3S8wwBDzsHmTe4Mf9Pw+SnjD4OVFWLb1BzY1w/M5sHct8TZaBcoHaVC/D4HxsZLDFFw4LLqkbnkFpkBgYVq1PLxZEtlyUDDtAYtHpQrKB+4GMmAJjh+w3e1tHxOe7jfDY9Tsszw5JYL/m8netYo4vNHUeKcPC/kkLdE+Gz+/dqNKZqLWV7fE2TKLkJ4tAUE/UMRwbWeeGUCGQzKRQm6XZsYvUrpOw2T3Fik+Bj8TPobSAKlLF9UqfvUXRl+bT8duvev1zVENAbcNYxuCafVqOmxENKCU/1P7jvup+1gYcaEv8cqPWGCXPeQjgJdvdeCw7rObj4uy2sjnNbSpI/UhFvAuW4XHV0ZQm+jwlK5JOPvd4F5aXK1r3i1azsZiqMAJJdusxP5J2SCPr5e+sWfEnX3cTg/XRMOGELUWVDDsc9fdbmZuzcg3ObIU25eEnR3XAVo5Ccyf5Gh2KHcRUZNUg10b9nFjMcNruWhx6fxIlZA0KkWcEEpgm+/Inz6lhrEvPhXsq4ELZULfwM6ykAc3leUHrAFpNlk3yqS5i+t0LhscDXkHPQcq3apG7z89Ix1/ORiHEUA93Ar8LvSu1bR5yMJ0EJlGxb935pCS78uewKYQl8uu0sneBRawQZkg4IcMWSI2enj5ECqyTCNAOCjeTRbG1fCAlFr1qsloEtimU6lfVaRE+XI8U/dpzKkXETc3LiD7sX7mO8LU0joLkbnCAk0d6QPoKru1luu/SjT7df72JP6DootfaGsg+MklSmP2JXAGhyZ17xlRnhIgwosSttIk3jQDv5xzrZOn9Tw9
 U2TI2+xS
 NgEejkt6FGgC5D6k8RFdbzL8xi4CGtsVNEFUsnoe9RUM4zIaJd6gLjdvXtdDX7+5yLimiZRIIRqp/7+gOW8dOk83CtyfIBV5BhpgFkVgOJ6v2khB6GYRmdkHSRpimf5FVzjZEKXMPXlOi004uLHtCXcG4SYxAv2qLbCx8DaHMTDpKolOK36MFKZ9P5ThSz7nEgpfnFOMq3D5pAnWKVYlgRFVXLAn645qbiq+Lftoe7/wAPE09PYh7/LS0d+s1cCo1yk01KwH0+2diFErcO/Ysd+pFi2Y515ycKJxajBPGG9tG/2xb96/hfEbz8nW6AXh678neyLQ+OCUfpuYjBs9D3A6D+na9GKSIfIf51fIpc3cjRBVMF4kOVPGzOuZcrQKlAubxHCDtFHSUmPE2LbRRASZli8ususBETXv/XuceuGAEJ4ECnw5rUbruzSk0PB4rn6eWkZ4S+vEIq+dOU5M703wgbue69BGlAgunWLwuNyJUjMARvIrTuOmF6QBTGP40iJ7Emut2TwJuwYM4hBvuboB3IHr/3lww38KE1Q1MzHCS628=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 01:57:15PM +0200, David Hildenbrand (Arm) wrote:
> On 8/24/26 11:29, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > After the page table lock has dropped, the folio can be freed
> > concurrently. The trace_mm_khugepaged_scan_pmd() is left with
> > a dangling folio pointer.
> >
> > So using the folio_pfn() before dropping the page table lock,
> > closing use-after-free window.
> >
> > Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  include/trace/events/huge_memory.h | 6 +++---
> >  mm/khugepaged.c                    | 5 ++++-
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index 7b526528f85b..fa828967e1fb 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -55,10 +55,10 @@ SCAN_STATUS
> >
> >  TRACE_EVENT(mm_khugepaged_scan_pmd,
> >
> > -	TP_PROTO(struct mm_struct *mm, struct folio *folio,
> > +	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
> >  		 int referenced, int none_or_zero, int status, int unmapped),
> >
> > -	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
> > +	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
> >
> >  	TP_STRUCT__entry(
> >  		__field(struct mm_struct *, mm)
> > @@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
> >
> >  	TP_fast_assign(
> >  		__entry->mm = mm;
> > -		__entry->pfn = folio ? folio_pfn(folio) : -1;
> > +		__entry->pfn = pfn;
> >  		__entry->referenced = referenced;
> >  		__entry->none_or_zero = none_or_zero;
> >  		__entry->status = status;
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 00337405c0e0..4e0fca5942dd 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1618,6 +1618,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  	enum scan_result result = SCAN_FAIL;
> >  	struct page *page = NULL;
> >  	struct folio *folio = NULL;
> > +	unsigned long pfn = -1;
> >  	unsigned long addr;
> >  	unsigned long enabled_orders;
> >  	spinlock_t *ptl;
> > @@ -1780,6 +1781,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >  		result = SCAN_SUCCEED;
> >  	}
> >  out_unmap:
> > +	if (folio)
> > +		pfn = folio_pfn(folio);
>
> Should we reset the folio to NULL at the beginning of the loop? Then we really
> only trace the PFN if it really was problematic.

Yes, this is a pre-existing bug, and I'll fix it together. Thanks!

But it is not at the beginning of the loop, it is at the __ending__ of
the loop, for the same reason as PATCH#1.

--
Cheers,
Vernon

