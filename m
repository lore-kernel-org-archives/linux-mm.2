Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4867E85399
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 18:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6016B0005; Fri,  3 Apr 2026 14:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86E36B0088; Fri,  3 Apr 2026 14:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B758E6B008A; Fri,  3 Apr 2026 14:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A47A36B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:41:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29A1257F3F
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:41:25 +0000 (UTC)
X-FDA: 84618112530.03.BCFF5D0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id CD929140013
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:41:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KvPv3BAq;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775241683; a=rsa-sha256;
	cv=none;
	b=KTsObUn8zY/hRGGQRg+3j5RJSfObeHjW7f0kRqfRCIWSnZWNNYflsRPMuPWuIsoADmAcvW
	jl2qskC+tAXcP4ETDb/BO+0m8XQK/YGxx1YiViq6Byn44BYpeW9aSJSFmEnyxVspy1p2Ft
	IlSYtrZ/eB4lR6mltI/ghGhlemqOTj0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775241683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pkxQv8Zx0QU1qKF94RTpNcNIriqGqgTPjn5xnCC+lY=;
	b=48Q5u/4n/BLo7CllSJPHCflbkcw5id60+XBtuUacIURB3a93m8A5mlaqADhGtPQBBGU6To
	4MnDHtbaJTrcnvOGU+9jvqAEWeV420nieg+mT9ALqAHf8diRfyPLQLkw8ZC7HKZM6tv6jW
	E6GIjk0G0ABlYJT/3k3oCopd1sikfPg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KvPv3BAq;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775241682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/pkxQv8Zx0QU1qKF94RTpNcNIriqGqgTPjn5xnCC+lY=;
	b=KvPv3BAq3tXwS5YqVyyPD+CEngy1OOB3Y2yqh3H7gBRW2i46zBgKICqIrm8vwoDsBwkOnZ
	VGFcibZBEn2rdgEJWPY3vJOD3VY0JQfvxwpB05VBhhJ+XcCZceCe41mr2BKg1wzsyKmCT4
	VajkaxtLgUxEY0rRNRhVNR423XXb5Sw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-etgQwqdIMwCG6Swb_eKUKA-1; Fri, 03 Apr 2026 14:41:21 -0400
X-MC-Unique: etgQwqdIMwCG6Swb_eKUKA-1
X-Mimecast-MFC-AGG-ID: etgQwqdIMwCG6Swb_eKUKA_1775241680
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50917996cfaso69615561cf.0
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 11:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775241680; x=1775846480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pkxQv8Zx0QU1qKF94RTpNcNIriqGqgTPjn5xnCC+lY=;
        b=gTYT4x0VLue8OamN1mSI5fRCc+OHrJEQIwijCY/95wFYO7QaVeX73PtciQjKYO4Tve
         YKbz11GrKiMRo8Dv1vpc538qBTQxFLtWZt4LSDRdOWF9KorhUMCteAYYMxZHuGvUb65I
         /9YYnPNVO3h5zHjnEnrT413A/jgGcApCjhw6hXu90bcbNAxDEOJ7I1R/iuS6TLWypINK
         v7Lap+wtnvFNowW5N51TsBR+E6UuAa6PTpEAC1xI32XXAcqZAwONb19X8+m3/+SBubg5
         T2svIpqZsAO60f0pvYCYgphm6pOXZZsnZ1/GLQORk0y2/J40D8IkpNFOAZClEq/P1wpo
         FIKA==
X-Forwarded-Encrypted: i=1; AJvYcCXw2w+sCdZqa5zb4iwR0AZSsar+V5/b3+iveHLe/+lX2e3hLwi0hmzRdFdMZuYiK1DtkV9x4X3EjA==@kvack.org
X-Gm-Message-State: AOJu0Yyfi51OaF8wQbc/LiWGHrtvTKhy0jNq/jW3oCYVf7FPYixq0+Uo
	XblWn9cctXGXw8KfPrSJ56OnjNHeiTknkuUZju4r3g/jGidI1Ua3qBBNe4UZyw5faAYVx5u05va
	yKikcgpfasLLxUMxs4NFnLXuaEPFSSCkD2wRN3luYXkUP9gfq4/RR
X-Gm-Gg: ATEYQzyozz9MrVoLRBwqMojFLIMEPyaJ1dxG7OkSW+9ivIJEJWfPIJ3fCTeIOVDgmpd
	/r5jHpwnOd7PcFcbia64NYp+RJUGJIlgVnxcUrNExwUp6rM3hTtMrZ735kaIneqNqbQ7C2Np+EG
	b3vxfWnGCQDH3egFUmUmtpSOQq8h++k6kG8Ll8mS8TuSM4IdB+nCcYAY82O78YYrK41N8M8zkVm
	fEZT9D2SrAWyidiq3NDIytmTP0SNvPH4O8p8FWTFql3aL+6ORojdOkigLewsoxoEoxNkomzHBK+
	fpJsHuECztgwvy7G9k46XLvTNwNCVGgmynxVXeGbnLANyZO016b2Fc5naOCUj+iXx6dGdRrgg2i
	oOZ4SZR1n37/OPviIxNsPzXmNr4I8uWX07VKIX7AR/XH+COA=
X-Received: by 2002:a05:622a:5e8f:b0:50b:567a:e915 with SMTP id d75a77b69052e-50d62b7069emr52453641cf.64.1775241680330;
        Fri, 03 Apr 2026 11:41:20 -0700 (PDT)
X-Received: by 2002:a05:622a:5e8f:b0:50b:567a:e915 with SMTP id d75a77b69052e-50d62b7069emr52453311cf.64.1775241679789;
        Fri, 03 Apr 2026 11:41:19 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8a593908b47sm62337136d6.11.2026.04.03.11.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 11:41:19 -0700 (PDT)
Date: Fri, 3 Apr 2026 14:41:18 -0400
From: Peter Xu <peterx@redhat.com>
To: "Denis M. Karpov" <komlomal@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [BUG] userfaultfd: UFFDIO_REGISTER fails on low addresses
 despite CAP_SYS_RAWIO
Message-ID: <adAJznD2zpA1brmz@x1.local>
References: <CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CADtiZd0tWysx5HMCUnOXfSHB7PXAuXg1Mh4eY_hUmH29S=sejg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 11Zd4Sv64OSByjQvNeqYda3Cqm6krrFMhb9ULVyFrDA_1775241680
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD929140013
X-Stat-Signature: tbg4ogq4zbkpfg4kxithf48omkqoqsrq
X-HE-Tag: 1775241682-968005
X-HE-Meta: U2FsdGVkX18D4Tkn5WTFLmcUos2MOalM0c5lc73HH8NIRZ9AjVxCKpem/RoICA1Tu3Xl//Y2QtwtrFatjYNgpvehZfF8EfmYme8EGDNQamQMhtE71SgDArmkriqM7nSccAd+N1ua5dJwc1kd28mdALiP5//AHuH5E8lx8SnAbZJgKt39wm03LhaV0ZP2Ze4ktc6gNyVQYRVAuAEzenNZPnA5MGdCJzDL/0QK3D3ze/MgZo6+ZOQ6hFbPFd2tC9y8pXjizULA0byT/FIeVx7HEa99l9Prn+QTxY7BBjY7InptcTVYJowxHbi8UiYi+s9n+hwutoSxLtEtlbUPTYAS9juZ3VsXKumOYeiteinXW8gfBpcmzD90p/jNAyAVkAV39FzbRULwGUJwSNWR9Ptrh8kHIWEulokuulr/q8Xujp3Ws9dX6/uuWTLEnhypgGN9tsU/QPMGwH7F+/VeTujx+M9YkPNxWcvW3ClME5ddfclvkf5Jhx8HkXGn73CuG6Rb0Ry6xWtQowv322GJw8/E74oeXFQKdawSjNTKfY+2S8cpvDBMQcaC0bxXjiPzlt690gOVNfGQaDEjtWM8leUMAUiSwk+XTivGiXOTNcy5wMdmPk4PJiRHWvDf25KxgDKhnaevJv5GAH8pgilmIqoylkfR96Y/k435W24qoaPimnDD7dEDv0TeudHCYgn7pGcb6O+U3YlYlLZ6Oe1h4aloxWVvNp9d+Dy/KnqHuvP79/X7keSClgQsPqTOJGQ/jYLeVKu8Hz4lNhyCNhv2ETuw6YZ7xmvD4+V40DUadDeb5Wm2EMocBEyH5GWVO+KnlJTap2qPlrm6mpFmRJtHX9rO/rdw9vEAapJ5G5WSMf/tuy83QElZm/jDMObZ0by1K9ya9vdAHSXT0N5DuFRBYV5qfgTl+AiKkUZxIYHOfJIQKZEhAMBKlsgO7D5aOyVRD7vUNUj5nVM60Tljo7ox9xN
 wkV6MBpg
 6Bkw3QB20VeoV2pqJl/A3pF6UHREiWjJLxgdZfGASh9XMfbkDgHPGczBgvZpZv2yn4QdZB6AqAC9mBxHQJqGtjBZ1fPVUb+ZtVArl4dNQYXVY9qzqP+LtvbaCZWVbMaGK90rbmLxkqYO3QFdV+mkOzFCGhElGpNtjT7O9tNaFNkUNdAc0pIe2dMnV1LUzlHbtVr7D8sxt7yC35zWcE9aylKB+nToaKb31uNPclhvlaq75steplBdySrZPzI1LTDuzP3ya9k04LrD8L6NL3D5MFfKVnd956iuyQAVAWoNvb8VM+6/9tTWnq7IFrpqqAz90SGq2Lf5xzEnaKvuTomsbdJ4gp9upqiNaZuwbGjfsOSj9m3sYYLlCwNbR++fkg0nDLy/cd1kHv+KBcr278V/HuhBxTYSHEzj2ah5GlLl3zf33XxmN1QdMUMuZsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 02:24:05PM +0300, Denis M. Karpov wrote:
> Hello,

Hello, Denis,

> I am seeing an inconsistency between mmap() and userfaultfd's UFFDIO_REGISTER
> logic regarding low memory addresses.
> Kernel: 6.12.63+deb13-amd64 (Debian 6.12.63-1)
> Description:
> As root (or with CAP_SYS_RAWIO), it is possible to mmap() the low-address area
> (below mmap_min_addr). However, UFFDIO_REGISTER fails with -EINVAL for these
> same ranges. The issue appears to be in fs/userfaultfd.c:validate_range():
>     if (start < mmap_min_addr)
>         return -EINVAL;
> 
> While mmap() uses cap_mmap_addr() to allow privileged access to these areas,
> userfaultfd performs a hard check against mmap_min_addr without considering
> capabilities. This prevents binary translators/compilers from using UFFD on
> valid memory areas mapped by the application.

Indeed.  I believe the current behavior existed since Andrea introduced
userfaultfd, and it makes a lot of sense when starting from a stricter
semantics with a new system call like it.

When there's an explicit demand of using it under mmap_min_addr, I don't
see an issue why we can't consider enabling that, as long as we do at least
the same level of security check similarly to mmap() here.  So to me, it
looks all reasonable to replace that check with cap_mmap_addr().  I can't
think of any bad side effect except starting to enable your use case which
seems a valid one.

IMHO you prepare an RFC patch and copy some more people to collect
feedbacks.  I would suggest at least the ones listed in MEMORY MAPPING
section of the maintainers file.  Btw, Mike Rapoport is now the official
maintainer for userfaultfd, please remember to copy him too when sending.

PS: it's holiday window (Good Friday) so please expect delays for replies.

Thanks,

-- 
Peter Xu


