Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B72F71075270
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C412F6B0552; Thu, 19 Mar 2026 13:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18146B0553; Thu, 19 Mar 2026 13:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55B66B0557; Thu, 19 Mar 2026 13:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A3D976B0552
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:16:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69A1FBA70C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:16:09 +0000 (UTC)
X-FDA: 84563465658.10.F8C330F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2826B2000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:16:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HW19/v6y";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773940567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xCg/OffoEfICoj08/DXMO73GhT2xooMHXbNaCjEseE=;
	b=QWSvrzK90arc19IAspR71/LdmHgy1+T48VUEyj0zN0K3bB0GOE0lXrEUrCWPXPBt3r6Pqi
	WiO3FFmfbchXE2icJLWUSSO0yRVsn7VgeWYJDtCMWsIeEWRfXf5rK00VlZ+0adsx1yqMes
	KlYKiVKWTDb5r3seWqsttw+lR5WQt1Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="HW19/v6y";
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773940567; a=rsa-sha256;
	cv=none;
	b=ORjZMN9hJqr+5H+dVl/pBFD/nsNg0lvtCCVrjh/8MLK25jRxug/cOq3xaMCA4kcA0rMcZk
	PvqQDFJnsydOMX39CunJ7xn5ZP/KgsXuJdv8uUj6aajEk3z3YiCR0wxW4FAIgk28tS7iLO
	HnHpYZ6wI02hF5Kue97m7hISjCrTVTI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84BC260097;
	Thu, 19 Mar 2026 17:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B266C19424;
	Thu, 19 Mar 2026 17:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940566;
	bh=kddz7Lr4KV800cJ5ixeD7N4MIGzmX7aClz+fV4i7T+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HW19/v6ypMVaXRu8g6Dai96+eN+7cHup6p6AKDjpoUtyc6dWHd5A5/93LVEpALWkr
	 QvEbbyXKp1v+8GpCtH3FDJJhBH5INDh3o85CMilGM0Lof/ZxhYuLy2j0o18XXXAqAM
	 jsldXmKEEwZDAV9Rpfoukzab8sIXV7BtNtGGNxfPr1lQfFRh2I8W9jks0ClorshK17
	 RUxF76pfNaHJdu4tbdl2x73dBFRwm2MxpFuQ1coaI5ItgLgiFtQMtoo/fBAn6CN6SZ
	 1JeruWtlbDQqOfbNU82bx88iNRV7FwYvvOvAmuudnNivMqJvaNzXYf7PNbcl69ci4G
	 kif5qhb2U4l8w==
Date: Thu, 19 Mar 2026 17:16:00 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] mm/huge_memory: simplify vma_is_specal_huge()
Message-ID: <4eb64482-1a9e-4797-ba59-9dd3551189ee@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <613669b1b2082d34f5632907003ae3874eff2ed9.1773924928.git.ljs@kernel.org>
 <abwpKc6PbHiqQRg3@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abwpKc6PbHiqQRg3@thinkstation>
X-Rspamd-Queue-Id: 2826B2000E
X-Rspamd-Server: rspam07
X-Stat-Signature: f81673tnusmzh38nee6ui3mypprmqz5c
X-Rspam-User: 
X-HE-Tag: 1773940567-823918
X-HE-Meta: U2FsdGVkX1+uedVS/QM2XJ9EjOswbpPdTJSUOfzIHgb5CAX0h80wzRtWDuhK9JwL/hB9Ks1rgFtJVk3K10yg7P0Yj1kBGJNZjEZjf4t7U4aCwu2BcwwFPVm+tZyLEnGVbiBXFTfMniFpczu0Rk5WHcrLH/IvjeujYdHxi1vF3W+VoRW/+CMUZ6mAEQynehMIHF65jPMR/8r6lPx6L6WL72HRSZyvnu2a9WveruA96x1GR6nVKQRdM37l6N/ifJmiekCCwCop2BcSF5T3un/skfKjqoOxWjLedOvngdnNOLnJ4xtBQtcVBlggAcfRTyYmjoLiC4F2+IFoObtX8VUu9czfCpV01GB+Cj6vphaBeZDGd65YzR1pphr5IppLAoFGmHnY+KMtjqprnMwlb16QIBwZ9IOOeVMcRaBqWf736HVfUVtfx8c651UpwblucpS+9auDoY9LcaffCc2VMCVESnYjEpitrWiuQnUEYfz5elsL8pVaun1ucV/hi9h8eujAWb8YjVlVutEpfEBMJ83jE/JuSmilffMZb66eNNp2gQVSkgOe2353dx9oGHbMImwS5UPJuFodMOU3M1ijdB8pz0jFkccBw5cZ7Sfk4X+M+DOWlKcHqmUqvAsPZtv0CuYYzuftHIoFnv2dFf3lReQ4M16A3mobn5w02Ptrprndpyw98b1p/izarQEV1EjraAodZ7U4XUwkZMyJaOwLoo2gkdVQ4yEcYoNRknQYj+js8D9y3XaPaJ86ZqkaDDjHDfCY+h5VfB8aLvnWUTp1xEiHEhkybG60ZWGxuxapBijUJqytzzAQ7LFPonfh88TvNhmD74gmnRb5V/NGBEdIygwlPpJg2BpPyxVFEK75JF8beIaBmfWlb/JtXetXmi94g7V2aI0WKP5DNRKzXTkBY9f/NEZ8GgEIoHjsr+Hiht7Iz6La6Zh1d/UxukHbOOdi/2x2YTAbkDV756dV91uh8kG
 RFsuKgu1
 /qqp+QCrqo8k336hto//n1WeSCEI6wDvCpan7eKjYZgQUQ00XCOqv+qXXiIFVVnP+yunhWI5Pa6lstmhWXiEVGUoe9GMxTGfCMUruJkZ3qIxoFEOA0PdDIkFl/JwA10oHoQPBGBN+firdGmdjnqKusIoO7jYZ0kfjavcVO44VFbzVMB68b35daFS5eSWRAcJIbfSjRQEVLdS5NDZnq3qfyZ8dwx57/fWItkC5sY7lgEx0D2DXDWKkrN/2I+FQNadBS0OEya5X6tULM+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 04:52:31PM +0000, Kiryl Shutsemau wrote:
> On Thu, Mar 19, 2026 at 01:00:07PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > This function is confused - it overloads the term 'special' yet again,
> > checks for DAX but in many cases the code explicitly excludes DAX before
> > invoking the predicate.
> >
> > It also unnecessarily checks for vma->vm_file - this has to be present for
> > a driver to have set VMA_MIXEDMAP_BIT or VMA_PFNMAP_BIT.
>
> What enforces this?

f_op->mmap() or ->mmap_prepare() would have to have been called for these
to be set, requiring a file to have file operations to be able to do so.

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

