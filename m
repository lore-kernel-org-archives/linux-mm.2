Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A673FCD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EAE6B00A3; Thu, 18 Jun 2026 11:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 845D56B00A6; Thu, 18 Jun 2026 11:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C046B00A7; Thu, 18 Jun 2026 11:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 510C16B00A3
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:28:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C440AA0121
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:28:09 +0000 (UTC)
X-FDA: 84893414298.23.7AAFFF6
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id DFC9A20002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:28:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=i2PHogbq;
	spf=pass (imf31.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781796488;
	b=0PBZkxQhnh+DG7JVqR6UAw8xmMmIdD9KN+roNNJElXaU9yfBdLZ2b7Hg1MAs1RLMxmqZBe
	9ytov/cxHaDby/c/CtJIbAujjW5bCygA9SBvD9FiqA3wEcSfjJXs/nq8wK3d+9gS/eVi16
	OuDy1akE88MJZ2W075IHL+cLWqdWgbc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=i2PHogbq;
	spf=pass (imf31.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.182 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781796488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P63dWZztD1Zc0WqIHW+0U1XALCCx2pgBRGQ79zLsHtM=;
	b=GvCWJKgQSRo3UyQ3fhAwqW8OAMcDMYL4TARhSit9sY4lBtEEYlIjYcKLqQTBfSgWyMjEyv
	zSQkxtHm6h8RiKjrHi76lnJNk9BtCfTTHL2RCKF4IEYv8O9gqCCAgFsXsCsarFcS7s2BGD
	QVrSiHeRUIZfemyBgnem0U1ugvUqLh4=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5177945a22eso7943081cf.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781796487; x=1782401287; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P63dWZztD1Zc0WqIHW+0U1XALCCx2pgBRGQ79zLsHtM=;
        b=i2PHogbqX9/JsNk4oh4qDnN0ffj7OSXwyPGP9/3KLCoWEQNgGblCtTDUvjPPiLrkRv
         JfAvqqW/wRDOITTlS85gRHQesEEJCeBje6ehSl1aU9mxVXERAePaMWh9BnV4bD/ARnlz
         K4q11MNngLY4qecCi3WIrshteBhhGhd6xbGN852EQlCVymZIO1yTyLpRk/vf5xgVQeIS
         hf8c4sT7lXNNVAzCi6+JpUWXVHe6tVgSgKx2Bdr3bev/w/FvCmMfard1AITQa96P0qVW
         nzactZNGtJ22iD7LJDGYgS7oxErWCceOSV6xouKZo2OtN5ettC57/EyGzJGSYflsF0Mg
         r02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781796487; x=1782401287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P63dWZztD1Zc0WqIHW+0U1XALCCx2pgBRGQ79zLsHtM=;
        b=sSgKNg8QULHP/mrMHT5JEEyikS8//5sldH79GZy5iSM/QR1OtDoW6TGNuKboVB5Xca
         1WMd1nZn2oK1X1PPuzszDCihSf3ZLJk4qg/PnoQq7fnrSz1+Pf5YLWV8MsVNxDf/ZwuI
         CaAW3cB7WXBg4n5+c/GTm0/q7PG5khFqwlU11tDc8x4DOPEFJt+4RKovBOHNhUhXmMHY
         t/qAqrf7zR57uSXcvp1GGEh2+rIE/LcBcHPIW7pDlHGx1/bz/pEdx0aBAeHBKj2cnOw1
         H3stfoj3DGCmthVU4SQibvWyv3+Mvbts4V0+iC87b7cW3sZhevD6O8/WovM/BMCqbU0T
         xKmA==
X-Forwarded-Encrypted: i=1; AFNElJ+BFpNXAUdUqQmgUr8hPAov4hNQ2jO9n/whqjgnr09LR498kc+qtm+gzrrXXY5ofCi81wESxn0Mdg==@kvack.org
X-Gm-Message-State: AOJu0Yzs3J5nTeTz3hLT+h5PK709ATLpx8yAM4NUsmIrb1mdLvcmaeyo
	5d7rd72HQHTQnukXUqM8dd7EusDgUaerHYY8yccSOoHoNmR+hhvE7IxodK2xQDAEQtY=
X-Gm-Gg: AfdE7cleEJka04FzrV0n0xvbQndHIUq8lZ2Yypx8Zj72DbPWar+IfKZ6Oeel8Xu5JFZ
	lpByYsyZty3IWfNs+NjS380cNLXi/N3aBMPRGHUbCC9/LghI4HJ6gSflUqQHn90uVL7Lyu/t0Hl
	NLBAjbF87WAdeQdv2m3Cx9je+8nauxrK+TYZmUdTuF2yNwYKtboDoue/yO7yVOtwIaHlK5TKkBW
	tnWXIbxXUk59gBNnqogu4j+biC3e++g3bC6b16Pf2rbD0OBeQj1fn6tBJoVBId72T/tDHRYfM/x
	S9ssjlOb/SHKYvZDoTl6gA0gQlf6rVHtn+ONk8J86Dzp9biZ4vrmFcKteJHFNX+1lF0iELufFo7
	oo3dWEVklInmTeQV82z3bcM0clhsQ38B7rdnZBeGrzMsI1Kb3sutPhluBFmoEpeZVJhu7MgHdS7
	NJKQpAPSTqHeWEdOG6c0bzlbU5JEQ1X/WMV2wxxsgqTYzl/MGnmGf0KrOUSRmJLQrSIzU=
X-Received: by 2002:ac8:58c9:0:b0:517:6fa5:94ef with SMTP id d75a77b69052e-519a90253edmr135623381cf.50.1781796486476;
        Thu, 18 Jun 2026 08:28:06 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb84188asm213419051cf.29.2026.06.18.08.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 08:28:06 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1waEez-00000002sf4-1fkX;
	Thu, 18 Jun 2026 12:28:05 -0300
Date: Thu, 18 Jun 2026 12:28:05 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <20260618152805.GF231643@ziepe.ca>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQDVAu9b-LX8gUQ@lucifer>
X-Stat-Signature: 8uw8ogzize54g9pyybtbd3cmy3mt8rno
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DFC9A20002
X-Rspam-User: 
X-HE-Tag: 1781796487-194324
X-HE-Meta: U2FsdGVkX1/1ha+X0yqJX0aNNiSf1RthFhzTIu0vr/yz63JQwBlJhMJCG7qrM0oL/oeyofrgujPHGdVLRWUZFoLNZs1zxEm/SlVUXn2uKGHQNJVHIUOQAItP78iLPOfna5lLNKcQwllmvQIqkMeXptQ830TSbKiTpdB2xyxiQ3qVIqVW7CSvH+I4a0hmuOAr6zMDc7O8PgQevXlZyk1/4GlyfonJILtEsiO9wBnUxuOGB+7/4Oea8kZyThe2aKeS7a3Z1L1bF801ISNTymdzuj2KxmPuTNB6ktDTfZbA+5u73HyY9yDJF/uYHmT2hxLHmjuvIVmayxYdIyFurgbVJS0sHIzrAzpKz2L1UDkbPKLcdHy806yJllhgUp4yBq5AG+XPIe7RKswLA3b6+rRV7VLJZcgKIuzt3rCPYv3DURMw1AjiA5PWvIcp4JW6HTjAou0CL2DlysaU8VH7D4zUggmb6fQaNZlvJZehzwJ4uNvRwb8PyIMFUtLuyHF+yPeUCMUT5N1fgy4QyazchaJoW4Q730/qujmSvzb+UnhuAGBluFZiKHagWxGYIP2GNomRRBhpo27ZcU5O3XcWoIm1paa795GzI7dnRCWexiNtXQBQ00ymBWJ3kkuTpCa2vFtsTCdlLz0t1Tdq0gS6cFgrgTKawk3jvkQ7jwYPSQqyfG+741kFZ+GFo71FP6us961BlLT6gqF+8UJhMyg4WWt84j7W3wrabZ9dFZN8nPqhR24jr7Tobd8SrAFRlx9MFOZiNJJtZVc7jNyipRCxK90P3KusDSQAnVxg3R6z4Waqr0ir4i8smX6Apd+sSQbYXoz1DKn/Knv3kK94Q/1yrKSKUDnPUqGiTAL+w3AFkqwILRI2hulNhcW6RsJeC2xBDwYsxvlw9Ld1l56mC4NLznvazLW0xCP7+TjrAihRoeXoG84DPOW3nQ9CQfB8ST+H/Kv4PFSLt49S2HpEkgV6BQD
 IWDoW0X6
 qFLP4fRNL6ja1aMHIhyrZLihdDbAKr2d/EHYGwzQHAwsbrcVf3yUJocwGWyWxnGFktGzwj60vwracpu09zSRY/jzbjwwn6eKJJnScbq5ij/aqzmyv9lGHmmtDFSwI6SgaeaxLfRlsHWVZI31xW55/7kulFfl1GL0qBAzu9WuY31OV2x2/1D1h6ohBFRe3NHV0YWpi3kpX4Y15Xy0YjFZkSuVC3m440xpF6vbRti6g6PWyUqQJO7Mu4PRjoBXt2XyUHH3t1UKS9qnbNpqHyvnh3DzMrTjSJp24F8tH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > A pfn driver often has a single already known physical range that it
> > will use for the VMA and that range should drive the alignment
> > decision of the VMA.
> >
> > vfio in particular has common use cases where you want to mmap from
> > weird offsets, but we still want to achieve a VMA starting point that
> > has pa % PUD_SIZE == va % PUD_SIZE. It is impossible to do this if the
> > thing building info does not know pa.
> >
> > I do think it makes sense that no file provider should be computing
> > the VA area itself, I think I made that case when Peter was last
> > working on this. Now that we have Lorenzo's mmap changes maybe we
> > should be talking about supporting VFIO by having a callback to obtain
> > the starting pfn for the VMA. Usable only by drivers like VFIO that
> > are working with the pfn functions.
> 
> Can't we figure this out from what the driver tells us when it invokes an
> mmap_prepare action?

VFIO installs the pages via fault handler so there is not a naturally
existing way to pass in the pfn?

> Can't we figure it out from the PFN the driver tells mmap_prepare about?

Maybe it can pass the pfn anyhow and not have the mmap logic map
anything?

> > Maybe other users would prefer a 'max order' callback and then the mm
> > would assume the VMA will be popoulated with pgoff aligned folios up
> > to that highest order?
> 
> Not in favour of that, fear it'll be seen as a new go-faster stripe.  Ask
> somebody how many free pints they want and they may veer rather towards the
> upper bound :)

I think you need something, otherwise we will be aligning VMAs that
never have anything larger than a 2M THP to 1GB boundaries, doesn't
seem good.

Jason

