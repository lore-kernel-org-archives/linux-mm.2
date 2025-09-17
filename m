Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B39ACAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 09:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946C78E0011; Wed, 17 Sep 2025 05:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E608E0001; Wed, 17 Sep 2025 05:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B378E0011; Wed, 17 Sep 2025 05:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 741EA8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:25:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25BC31A047B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:25:50 +0000 (UTC)
X-FDA: 83898210060.01.B043E02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A54F6120008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:25:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UpbyHRlj;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758101148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwccyQR0rU/LkW0cKwc9wrhgdLBQ0OFTOXYqtcmBuK8=;
	b=Y8W9EWidptjoicptoVCFqiRP7BehPZux6lStgvEWy0f30rkGjedJS6/JBR8SNUwx+D+knA
	SmbZ+cYVRSr+BEBSljepnpFcYP774mT+bOFwyIhPn73+Xj3qmu7sGwWgDe58rvyiT/rxWK
	AWV5MZQLzhjMWU8+CyyimU1gz0BekWw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UpbyHRlj;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758101148; a=rsa-sha256;
	cv=none;
	b=rcZXZNUV2gBrTYjHvXSYrmIQ25axfqzl9wQNHMlQE7ygpaq0U86VtMBVsxIsE/7DOkWlHl
	cyvjPj9eN0hRKzcNFNoBcat4b6E+U8G29SEaMf/0W/6jb7d45sxurzTo4j4qirBb6nwntI
	LT++Wl1wDNFq6RVdE8PzR/uBiN9cfnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CB049601DE;
	Wed, 17 Sep 2025 09:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A34C4CEF0;
	Wed, 17 Sep 2025 09:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758101147;
	bh=mi+c+o3FWmHPaLJiT7Mnmm6sTZe4R8F+gNG7LUzeQcM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=UpbyHRlj6I92I8jYO8q8IHg9KFI/uWkocCl/yZZihL+Pu5p5cNv9/3GUZM17ZnTEL
	 55OySOMRo/VxAf3J394PdGoWX6PnbU604tDshBIp4JnADYGd/Pkg31p/3oS9TTje5M
	 7XfdTlfu+IC1/Km3+dylN2uadA4ih0TYYSHUze4cbDLE16OZqf4/SRXFT7EkFTZb4J
	 gH3rkjwmWpvOwW12ngJ60mDM2ggbYPEiueaZ6Bn9U9mvtgUlJrFrGEpHajgaa9UoZP
	 ZMlPKuJYultxRbn5+7KKJOHkKr9t6sXPHiG2v0BXspJrgKTFHMr7j3ktzLyJEJoz06
	 rPPyl6Or7FIGA==
Date: Wed, 17 Sep 2025 12:25:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMp-kW3OLqtZs8sh@kernel.org>
References: <982f4f94-f0bf-45dd-9003-081b76e57027@lucifer.local>
 <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
X-Stat-Signature: fjeh48xa1efyxtr1b87gjsicronb8p9h
X-Rspam-User: 
X-Rspamd-Queue-Id: A54F6120008
X-Rspamd-Server: rspam04
X-HE-Tag: 1758101148-624701
X-HE-Meta: U2FsdGVkX194PvamG9hQJNEKXmtwY1+oK+YHcxtKvZLD7op770ocX/BkcbRSYkIrVfdFPUnHikhuoaDHl9fcM3mrzBQU7U5+Qt4m1NjtIINu6bAmqywMq94SQ1i8x/glsafLTvuUDy0u9MJU5lR19Vgh51OdX5VLnTa4BCxRXSkRJ9Bc+LZ6dyb2UyNP4FHAhU4zZrpHl0tzL+OFwM9zj80JBc7TdRZTLECAGmVnQhUEzpjSVKgGNUFMRfs6/hgQ36S+ms4V+MvTcoljwyzi4adI0+VhxSqSnIXT0nPWF5EHsIjwsOUdfRrDNXoKb40dLoN0GldbucMSX4+bSVehuYFCk8GSZzItExwVMDOFPslj0xOSvf18+6+VkD0WjkcVwdWa3PyCqTY+g0b5sFYhEk4dMhBNgNEYvA6tmZvrHw8zFZYmB/xmlNHYdKBTmrYQyewvj3jNN05LjDqprd/c0mkwo7scV79ucVBOjSu8IVkKdCQTcbzTIHYNqfBo2CfYDBthzwGsJAzYzr1Hubcq4leD4t7aUgenHmGEYDAcUSXOIp7shlJ4Ck+Y8TjW9fo8G+aBO1opRr9dQEaEG4vZ2X9IKBDY/auttOu8a2E6cSyTolvWZyaSoNmkz5vWDdoYO+xBWRU9IPp4nQfUu41q2vSRLCF7SIZjTRsMMksKqOX+HlqlshWW7lIo0ut7MV173V5lSY4vFc2SSZWG7f84MEZcFVVoVPQEIxPOzlqCQWow768uQP5TmQLeJbyWqPW4hbW6nHgGlKptqce2yphc20axIIsmVimk7ZWDdaakNyhAECpnF1wwlGQf749P7togKJ37CJx19zY3gxAMEdklphv8WyXtbTUEzs/Mfr+cYKsf4/Du2PSSW4tC9iuG18OAe+pUrZAP+UtyQuEA2nbVAHn6PTKYLCTqllJswMbm9191CioAAujOiu4E1pKOXCTEeHeDyd9WjYVVkwG58nj
 jBC02kLl
 /Gj2XsoYj7F+eWMy+IdVjnz81zugZB1eEuzAlaLNS1yuKouOq/9wvSQsIp/NayAEbC7ED2hkVeI0I/jgzLyLu3gf/RiPMwjKqfGr4Dh5cWgHm8V0Kb9bGIbjh2HAm4WZniE5Xcs7mAjVkPlniefYe2Rf/hiSG7cCEvNad+eQrYqKR82EPvl3pj/JRoPQ2KPkMPlhigGsMRg9uSJ1Hx7PkSujG2KBNctJkasPpXMtudUZawGYn+gkgyvH9OiNknrfi5053rlPMQzoMO8A7KLlMhtj2/DzOD6Plbg2qkv6Nr6BJRmPxcvpsq+RPR/vHYBrMSERhgFNqWO3agtlEAnSQHmU861bQi7neEz1lF8AMC2g1sqq2KJiPUdHUcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

On Mon, Sep 08, 2025 at 12:53:37PM -0400, Liam R. Howlett wrote:
> 
> Reading through the patches, I'm not entirely sure what you are
> proposing.
> 
> What I was hoping to see by a generalization of the memory types is a
> much simpler shared code base until the code hit memory type specific
> areas where a function pointer could be used to keep things from getting
> complicated (or, I guess a switch statement..).
> 
> What we don't want is non-mm code specifying values for the function
> pointer and doing what they want, or a function pointer that returns a
> core mm resource (in the old example this was a vma, here it is a
> folio).
> 
> From this patch set:
> +        * Return: zero if succeeded, negative for errors.
> +        */
> +       int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
> +                             struct folio **folio);
> 
> This is one of the contention points in the current scenario as the
> folio would be returned.

I don't see a problem with it. It's not any different from
vma_ops->fault(): a callback for a filesystem to get a folio that will be
mapped afterwards by the mm code.

-- 
Sincerely yours,
Mike.

