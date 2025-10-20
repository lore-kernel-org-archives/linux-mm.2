Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A268DCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060118E0005; Mon, 20 Oct 2025 15:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038368E0002; Mon, 20 Oct 2025 15:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90628E0005; Mon, 20 Oct 2025 15:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6DDC8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:40:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 719FFB7BC2
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:40:42 +0000 (UTC)
X-FDA: 84019509924.14.1132ED1
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 862A1A000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:40:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WASu2e4E;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760989240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZnmEnPP8bfaJAvDeM1NTDj1+/Fjxn0k170ygaThNRUs=;
	b=1oHy4h9TJoinHGXpZj168OJzegPKsv5BGw58NNKkCg+yt5nb2ZKrWQzG+HWD0KdJcxq3+C
	yXwuOeFwgQssUkJkMXucMtx6lPuTwGe+lMglRGodFBCfdrjBkcnBkkeOO8Chwubt8Xghai
	fmLT+E8ZpoOvpRlMrmWHIoInykApS68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760989240; a=rsa-sha256;
	cv=none;
	b=zUIXjeBCoevDdh7s2JA+A5MYU0d3klz0Zx9koCiRrEfBhLfWUHCgvm2zqWC/dF8wegSlEZ
	fB+2rYqgH2bWZyZXhgp4zamcJNOUMAE/1V+XQxaDGti2Qu5xr2d65/g3Yg5MB3L/Lnxnz7
	IMGtL1t8+RPs3ZnrggY806Or7VkExJY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WASu2e4E;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-88f26db50b4so652109285a.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760989240; x=1761594040; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZnmEnPP8bfaJAvDeM1NTDj1+/Fjxn0k170ygaThNRUs=;
        b=WASu2e4Emk0qMCSi8TytYQ9T/X8LLRKNsPQDewp2ZE00AiURRbjNwe71+twKf+GP3Q
         eVYjcP97w30dTfJG9q34agTvvI1gy0DYuz9ov/tN6Tro1oEFmhT1XxPQUgzaYrhny5sH
         YnbUEkNR3AtmGi3sm6xzEC1fdkLDdj5yGaQfYFV07oNCcaEFN9maLffcHSrwurTP6P8A
         WpX+5njB1Hr60riunsUdgd8KOeqfvpS/oqvgM1Ect6VlixoCCvKP2SzVo4cqtDGt5vm2
         4mYBtB0hDxYHAc/YWYVIogjrzyw6Pk3PmxPBTGThF0npjGx0cWQ+2SPjIWoemkH8CVQL
         CbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760989240; x=1761594040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZnmEnPP8bfaJAvDeM1NTDj1+/Fjxn0k170ygaThNRUs=;
        b=j3u42uQEz8UwlUXhA3aY7+YPOF4oC2wAv7bJN9Z62tBi8uYE2HM3EX3ntCDoxWFTCl
         mEFsh6RRqQU6v3skaNcPB3y6GSicFw51eKQ+yJHnNir8BwZk5vSjEm+/AZrgBenz8a65
         k6nCaakRagibSUtGGcKAJ0EbXGABfrTp/9oLVRTJ7cR0ub1Xse0x0VGfr7s3wF5nvpWk
         eVAhN539/keeHpSLzsKF8ezzn3r9HJRExGM6aM6KllZy0PNB+xaD1auPUMHb83M6zZBn
         N3ucgrXsO7gBJPPFgfXb5DKCvmeYNp45wIf+h6SPLQOxb4+5SgB08eEbt9sI472Uvsii
         aN0w==
X-Forwarded-Encrypted: i=1; AJvYcCVN+LJg0xGiFxTBQ/WbPkrCINAU5iG3p+n8Dn1WQczeUSoml0T2+LGDukqFenrWyTt+qjHvEs78DA==@kvack.org
X-Gm-Message-State: AOJu0YzgchEIhTZCBWOvCapPZH25YQGyTFCgGj2eFSo36NTrlALcHTVw
	kAamUZ5Zwb99HHMh9FHK1JXk5Tzdtjy9sYjKXq/5mK8u9TSn2FJKYPdP+oP95dIFN/c=
X-Gm-Gg: ASbGnctvnoLBRl3OmbE9kmJOg2Y+3xS0nc/NC6Fke/KzobmbWVxL7hv5xl7pLg+Gfua
	kym0kjvUpyVCd4kq3LCN2S1ZKqWhfdpGnbZ62PA6GKKMwdJKI9O/c6kX24jCmQaVuMsgNgO3oL0
	8RNYOjxtwYG9zSHCWj2gnEji+rJ/JSVW3UPlDhMhBtWKkWbx6zqO/9Fc+K98sPLrfpN6ak0hxe4
	ObyV7T8pyJHfaxjxtBZU5c0jJED37Qt6HdTj+wekagAD1MCMt9dbwDDAu4t9tPrxTFJWP3IgHNm
	gYCrBe4i0lYcqCA0CXDZ2YO9j4RwQ7WAPSjGjIKvgLY8dN2VDH209RJuyulNsu1M4Ar+YvNz1lT
	MaDEsBLUDD/OYzQKCkRUDdCYeioMr7S6rbp8uiI9lVFkvgOtWrPon9ysP+0er4jFYzdCFD40efx
	DuCsvEtl6hJqy3zCM2UihrRj6PaoE8d04ZTFxhzUXtBOGdDGoUxEtoEkKxgBI9WKxpFhELcw==
X-Google-Smtp-Source: AGHT+IGuWZHEavHisVU9mk6gRIHhpdyd/lI8SERMr7lwjiSLbTWdMYvofhTVk+g9pKS5DS+eGwkHMQ==
X-Received: by 2002:a05:620a:1710:b0:892:93df:3bdb with SMTP id af79cd13be357-89293df3e88mr974477885a.31.1760989239691;
        Mon, 20 Oct 2025 12:40:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cefba77asm621032185a.33.2025.10.20.12.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 12:40:39 -0700 (PDT)
Date: Mon, 20 Oct 2025 15:40:37 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <aPaQNYsN_YPDOwQG@gourry-fedora-PF4VCD3F>
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
 <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
 <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 862A1A000C
X-Rspamd-Server: rspam02
X-Stat-Signature: yig3tuuj31mebjczjq888iephz6xggca
X-HE-Tag: 1760989240-466236
X-HE-Meta: U2FsdGVkX1/1/Q2iyllnPbBdjX87fwhkZ+rriKMrk6jV2L/R8ch1frBcaGCuNuRCO798qfLrLNPZkVmUThn18AS7eA5stKr6mlqYAhtfxpECFnqKtQTrlZiSgAzKC79gXItvpoJWG5RmV2XJ2iMLK+PWIHzkird0JDj0NCQZzyDvpwq3U+CVSpztkAm9yXXT8TYWrINQN+rA96OGf2dK3xwyPkuoratWqHoLbba00JSbFSJZ7sjcV98s3QSP0+cNb0axR4/ynQFSihFVfTtGeFj+8baS2Jra3dDI0R53i9MHa8Ohv2v70HtN+TUNPGpKBseyvLh1IyihDgCWpI6nYEm0RcQFQOMfiNy7G5n7c6K3PkfmkYTHN6btF0alxKuBBfv6nMMuog5cMSB3coMohgSd7kfvEQaFTjT2MCzhDmL6/iSkgQE7cyu1XlSaDUADHfI1u5IqC3D+GfHsW9ghrMlcwbICLrTqSwwzetqfbNzoN9ICNKO9T/QQwt7z0yUJ9MDlns4kzDrbsEbVjn47SpB3aJ+UB+Qt84rUFJndYv8lCuz+5hGsFD6uJE8YCWve8lIfp58Tja9pAF1KvTi0MdSc9a+GEuab46ckwhA70QA6Lc7gMwoPaMVRgewXrj5Vag1IvRwHYkBGZ6t2jZAtUHowNKQrRVAfrJwODDvd8Ju7CFDqrSSMEauGDctQAbiSu56TZlYn7SF0kUEaYSBw7ey2gnn2k83BVhB3PObFWaWeHWYysRDreUxvkSN8i9TyX/BORfVD7Dj55UrkdES2BwIJcFxkMGar5YdGDf3v3KdcI9rRjuZTDFpvZKX+VxjpQTwuqCCM3D1jC48I18n6GqIKCR8UPjzFTHo4TDH0tAfwfy/JtyB3pnnELVUfjE3ugw7XwSagJTA9iqody/s07QogzvpzavS682TYHBZ0LsM/HxD17jf8LUvnkSdkmpCLDmDSf2Em544WcJeRaI8
 NynhNZHq
 AqrbCkHd20iXwTSIgFi6d6bmq4KWH217Kbww6e1GecPQkKe6wwWB6eAC/htbXFuw3Y7w/i//YPTZryA4yTnCg3aI7Scvb2PAWYACwFLxiead+zx1co09dDHwKDMslTLw/cgiO8mxy1/bbwJFIW2r+S76ZO/6MvJ5XRBUX/KY4I5iwaU21bqPd0/ycrsnh6GU0pIUBKGSZRQfcJvE5j57qrmIgRGw3829tnEKydnP2eL1JASxtk4Ddo1jCTaZF3L3392OU5l741drDisJ7ZnK8u7rO5TXkEmpGE4rC1IMpZiY/F6vW0o+x4PMG9bMG+cqq3hFr7All/EBKEmAQ82IZojQWz8rxaxfWUhagvxUUi46RjyNMORp/x3cFcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 09:18:36PM +0200, David Hildenbrand wrote:
> > 
> > Basically, what is the right way of checking a folio order without lock?
> > Should we have a standardized helper function for that?
> 
> As raised, snapshot_page() tries to stabilize the folio best it can.

is snapshot_page() even worth it if we're already racing on flag checks?

i.e. there's already a race condition between

	pfn_range_valid_contig(range) -> compaction(range)

on some bogus value the worst that happens is either compaction gets
called when it can't compact, or compaction doesn't get called when it
could compact - either way, compaction still handles it if called.

We may just skip some blocks (which is still better than now).

--

on compound_order - from mm.h:

/*
 * compound_order() can be called without holding a reference, which means
 * that niceties like page_folio() don't work.  These callers should be
 * prepared to handle wild return values.  For example, PG_head may be
 * set before the order is initialised, or this may be a tail page.
 * See compaction.c for some good examples.
 */

Seems like the correct interface given the scenario. I'll poke around.

~Gregory

