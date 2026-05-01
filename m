Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C0BFFF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 08:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4E16B0088; Fri,  1 May 2026 04:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875596B008A; Fri,  1 May 2026 04:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 764196B008C; Fri,  1 May 2026 04:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65DC66B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 04:18:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73CF01C0C4A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:18:29 +0000 (UTC)
X-FDA: 84718149138.16.D18DB9F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89FFB4000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 08:18:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uFyo2M8s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777623507; a=rsa-sha256;
	cv=none;
	b=EBMjLKRFZwdsQnYt2jp3GnXxrU1G/HX3a9CSXh16wCLaevX+JhAsDUcrO/lOEwHMmOQCyW
	rHgFXMKPOMToYLyYi6BnoN0oX2TAIBpSHwy2fe5HlCtQQ13sYuWbbbEjcVJTC4bTVQla54
	rUx/8MvjhBHKl0mckeNrXMNAuPL9I2I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uFyo2M8s;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of li.wang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777623507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVXwRxoZk3ouF0zgeZbTnbTmmQKuuK/h66J4DI491pQ=;
	b=TtLhB4TzG9Kd7ywSCO1CfktJ+k3ved7WFFhm2S/svN3hzvHHkuuehC29KwsF2zhT+9+dUL
	6OVaXGSymlyNEQGcqzzoMdx9WZTgsjTFhdN2FXG0m6nS7C7roar8ChxPNohJ86MATTacza
	lw4jnTea9xtnLPSXq6nl8UqtUnOHbls=
Date: Fri, 1 May 2026 16:18:15 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777623505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iVXwRxoZk3ouF0zgeZbTnbTmmQKuuK/h66J4DI491pQ=;
	b=uFyo2M8s1Sp/f/c5/b5vKsH/6+VI6f7IMDun00qu/QKUPEUanqieSnQytlqG8qGuM/rn0t
	iUIGLhvIqhDKLL8WCOa7AkXDl0aB0PU7/UHpNRSCWyWVUscuKMjxatCDcZZQmU1DzsxVSV
	h7XtdLeO2GbPGEJssV5HASwAcXTrI2U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Li Wang <li.wang@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 07/54] selftests/mm: rename hugepage-* tests to
 hugetlb-*
Message-ID: <afRhx6-lEe5bxkMD@linux.dev>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-8-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428204240.1924129-8-rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zib1jk8sswb5cnow5i16m54os8zp4sni
X-Rspam-User: 
X-Rspamd-Queue-Id: 89FFB4000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777623507-231264
X-HE-Meta: U2FsdGVkX19f2X4AmSMh4lE6JXFG44xQV03raKyMyE1QM9OY9C8p89ZrItjsWjCiRoO5vPLGgctcbr8HfsaBRJO6XhD97CldwTmQHwWlHI8s9oiV6HWmwjgLy48Hp1QsYrwlt2PGYkkeSP5hdR1qGBkZpSvleHqQtektILZcv4pmoCz2lRnx6CVbsfGNWxR4Q8bsLiJLJTWUlTcP57XhfHvVw6bh/Loe/1sPUL8aXDlb2CvbxlMi1pZbYOIH/z4l1rsFp9/LOMYOzqIapbIPu60TZfOc9aAz9x/oQ6jVA7VhZLengHkb+oRz2i83KG8gyNfxk5gOIfh7TrhETjbVSoR/1jWJ9z73Z/q2eXFxyQ5AG3EYDulz/zWW3uWBdMMlWATHAC+c01G+UTlR2QvOM8kMMVDh2kbLXW2jHF83aZ0I23W04q7ZGmbq0YuCWMT9rfL6kHizzR4TVg9e9Sjh0mSWDgK78dug/yjTuc49c3jrLHJJajIDqk6EEfQWaW67tWUbfc20FaiZXkGrPUtBx3V4H0VfBAX2G3e2fskf+aoQZc3MyaT0imh1D2f/I0IXxRHTIQZ4EfDLHSkxALlMR7/+KKGVyDwNC6dPAtpUxkNG/kgn0folJWMcJ7cY1DHoOEgw3fk+kRnrGU2eoU+oth2RPBQf/CXfgTwhOf/NIRA9HoRZ5IoybcCK25Ri7Mkd198dAoFl7fAnh2e2z1Qi9Sea8SzWLOMu8wmLW3i6zTr2Yo9YXW2QCVkfw6gCC13+1tKWK/t6oegbGFAykkTDLr7kEMmILps1nmE0H7w9dSW3JlPmAdM9/koPith326cFj8Porf+xROgffIHRIfmv6ZH4blMKFQr0QIh/wywn7gCuYO7H3Ya8I7tj+XM6fW4a+15nWWxl8/oq67Y0IAVSVtZAVq+ZAT6GCsIdLrGqJ+XTjXKl0a0XG26YL4AgKYj6TudK434zcj4qt8nzsRl
 E3vqC5TI
 9BYkncLfepocyYL5E/kGEz5QDRgYIZyJJVdGyRc3iyiuWJhsNAODS7YVTwcoMLTahlVFHygktYp73erIRPnZtVg6oh4yCUuBRj0pP/zG8d6WPLVCeWWAxhUv9SRgEccTqKYEswHhfpRM21HJE98eIwU3NK70LjaH1WEu+55i6mRfvDKxMi/Hlsu1PIYZKs36wK2PBz8bPlOc4RAE9hKtrMHaKLdKM70cQselNpAg02vRXoUtiSlkRdAF+Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport wrote:

> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -4,6 +4,10 @@ hugepage-mmap

>  hugepage-mremap
>  hugepage-shm
>  hugepage-vmemmap

Maybe we'd better remove those old files from .gitignore as well.
Otherwise, looks good.

Reviewed-by: Li Wang <li.wang@linux.dev>

-- 
Regards,
Li Wang

