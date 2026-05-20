Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C1ACD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:40:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3368F6B0005; Wed, 20 May 2026 08:40:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E76F6B0088; Wed, 20 May 2026 08:40:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE316B008A; Wed, 20 May 2026 08:40:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC0D6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:40:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD8151202E4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:40:53 +0000 (UTC)
X-FDA: 84787757586.17.78ACEF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B8F1C0006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:40:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZboSrCun;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779280852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hou5QTX3dwLHumKpx/wVE2F2xH1oiDUIvPBcY1JpWeo=;
	b=IlWFQ/wgGESYL0DHki6zMFYJt6gQbXq9NWmXCjMjjuo12aJVgmtMum5SMyERz6chqQixac
	K9t/uLWpxYD9kA9Tijv0qdEA8JEtTOPGLfzhjuGKCS7hKf29cvceEzZdxSKB5jsEmXaAnM
	m9FZYyu5wbghQSFOhw2xCnwT5+aJAAE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZboSrCun;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779280852; a=rsa-sha256;
	cv=none;
	b=hVj5WCY/3J2XzZc49i4pYvzaxRljD1Og8Mm1j1kqtIJZZeEYaiVyjlLuF3iV27sdwamILv
	CbLgnfXf7JXnX2lmN5/U4rnuhdIrTSjixbBieRYVW7pAvLBaFnC4VQ4CxmxcMprmPrpHxF
	dhUWZBAgdmWT0GUgTque/aTwZummEY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D9A2403AC;
	Wed, 20 May 2026 12:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DD41F000E9;
	Wed, 20 May 2026 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779280850;
	bh=hou5QTX3dwLHumKpx/wVE2F2xH1oiDUIvPBcY1JpWeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZboSrCunn6ZXJ4pnoJ+lf2A4PAQiOxiVvNcJ0iW/cVtmgV1vX2wHYVBcQedEmEB7+
	 9G6pEas/WpUDb/DGppSiP0NSyg69d+sDGDZdWWW+Cfw3ARVwjpoenOOIApSZrVZnel
	 RpwJAF93aulEoIZpP3FwvYb5zLGIFwJBHGWzlvooyoIUorLQ5/6esXGn3+sggTSOrF
	 a8as6JlViBG9ukmVqdjsMrQ5QnRmfpRvzBrENluhdoNy35EsqnsieY8UJFIjMSoYGD
	 fKIZOOtddbLWk7+D/S7x5B3hx6+9GqbBxKrS+VhbGxTlXALXYSnUfs1uha5ZmNOKS4
	 oI8oGtDASo6kw==
Date: Wed, 20 May 2026 15:40:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David CARLIER <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <ag2rzAGnETIECZ1K@kernel.org>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <CA+XhMqxPFy0GotRrggfo+WbrCe4qyy5CFUZJM1fVnY+iEucsHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+XhMqxPFy0GotRrggfo+WbrCe4qyy5CFUZJM1fVnY+iEucsHw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B8F1C0006
X-Stat-Signature: ey5mo7gf7mh87tkuknjbtnnuxwo6pzuu
X-HE-Tag: 1779280851-305503
X-HE-Meta: U2FsdGVkX18Eo+tzbN8Pxgc9rQF9WuTrCPXIiepKFus83TdNhJwqF9EerZZm8A+f1zj5YPIfMsyWxNJWRW00uDzIfuxCdXDD2Vn6sKQ7RJJ6a4j0nimzjsJ/In9WxuTWYgVpDCUvaIdkVxZvjNfSAgCqxOUAYLcYNOSgz0sOHR6LNc6U7swPNlG3j6Eg8Z2daD4zYntkauY7GfnUEBSW7YPsWisvgHkf9aHUDNMes7LAdtpT7CYBplZQbtdrUN3w3RdHvkRYGQNHcIIb0lsLNpxEkrmZm8C5wX2QH1OQRg2IQjS2bGyVQ86q0srM/Znh+xZVHJeIUQLAz3eO4VymvheAfgWn+iouw1xvxplCtZ8MiL5FI7gKdVGYCL/BO4+TX6U9sS0TRVa02kljYSSMOp+926HEvKHk89xyIAfHSAH2huPH8iVqaIm3Zo9gl1g3l1x+y7/4fk7QJ2OVuLUGgnfPq912S3XUeoYnqXC+zR9oerXMiq6WEl8LN4DA4z/CA5LdZCPs5ezJpjhFyI0mDR0rVwaHOaUF5QcGxRPobfNbUsZrRdm70BG4oj6hfLizNdQqlW865uKb+8sLx22P77mwEsgbINatfGX3NAxvgm2SeBoUvNQkkHtKrBlebLLC65VR5qVGH87nr3vcDr+kABNbIiQk25trmp+Qtyw37aAS8sJKxFwNSrAy+cqquqsuYEXCROkTJ0LnkJTcCDQtFUAi/SiAFK/ycuNIys5l/qeU2MX0052Q4kf1HESH11rDO2HwCwGjBcxDTzfZcxV70VhZMJrryo//DxKJtAEYQBPMeaPAUVDVFcRR/+mi8dgrkgF/jztlNJVbJ8B0VgzHD1qUjiLL7fA4wcLH6Cr8VW2k58/gtcK+Gi1QOlJ0yVE5VqlJDSZEWGwrpbOBsiwWGN19VXanZTo2xij1okSiH/uD1JE7SUeDv/ZXejMAjzSdONqICr5TMCqbp6KihEa
 QR3MWr/K
 vrBUMH1M/aBHQCMlrNamjQJFnwOh+lRGgsrXVSHC6wainlNMCs5j206kfeHa2bWy+xJ4ztB+m+7KEXWlKFa5tdtHcEyMpDeIybgDuqZM1s6aipH001K9A1pooNOvkmC/HJGAXEGTACvb25gH5WJt/6ixgAXh/W0/loLEMvU30etb69WkJMn3p8j32J8Sv3GziejlPuRMAJsqtEMAcmrxoVVELew3zKgLDS4/mgDXnQ6kP8ORMrSZx0FUc1V8ZXOOy3v+8+OkHF3fEVX9GfkjvUVABOIyqy8qedkcxn6I8d4y3aET10Ah3ocIcV0whu86PB8inaDX7ELZMOjUNv+a8/p8dmuikIEs2UfWOdEG2l6lDUBeTdqaEBjF4rwYXUiTXFneXlt3H0aREbwc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Tue, May 19, 2026 at 06:36:23AM +0100, David CARLIER wrote:
> On Tue, 19 May 2026 at 06:25, Mike Rapoport <rppt@kernel.org> wrote:
>
> > @@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
> >         return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
> >  }
> >
> > +static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
> 
> 
> My only 2 cent, I would name it vma_uffd_effective_copy_ops() instead or
> a comment to highlight it is about "UFFDIO_COPY into a MAP_PRIVATE file-backed"
 
Too long for my taste :)
And comment is useful anyway as it explains why we override the ops at all.
 
> > +{
> > +       const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
> > +
> > +       if (!ops)
> > +               return NULL;
> > +
> > +       /*
> > +        * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
> > +        * memory. This is an effective ops override, so retry validation must
> > +        * compare the override result, not just vma->vm_ops->uffd_ops.
> > +        */
> > +       if (!(vma->vm_flags & VM_SHARED))
> > +               return &anon_uffd_ops;
> > +
> > +       return ops;
> > +}

-- 
Sincerely yours,
Mike.

