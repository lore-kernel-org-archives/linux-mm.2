Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17AF7CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 21:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB078E0013; Thu, 23 Oct 2025 17:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B3B8E0002; Thu, 23 Oct 2025 17:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198148E0013; Thu, 23 Oct 2025 17:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 083CF8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:26:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F577BDEFD
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:26:15 +0000 (UTC)
X-FDA: 84030662310.24.4D1DAE8
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 823FD4000B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:26:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYV2zcmB;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761254773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVbxmFxkl5Gkpe0F49DlJZc2pZ5lmn7pCYA6JciiN2A=;
	b=RhgaMLFs+D5v7Aev4SBHrMFuMjpVg0NWYOBj7u7XIcS6cq8Xt/UMzCna+fDvch6JddRL3m
	fWKreFQbtdrTHlnKtc9/NULgECW9OrUhcXf9VRyIRc+QmdrB1etq4TtABoeBuGSPkDuuAr
	oqNQ+RV0lOWXv75/wwcv/qwIFVci740=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYV2zcmB;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761254773; a=rsa-sha256;
	cv=none;
	b=FiYuQYuJEpM9cs1m6eMMUKyxXO4CnET4UgEhqP9elBMM3chjmnIqVOjotJB6FtfMdbJ6Qe
	u0Sa5WpWMxwlnZBtFL8YEllkckfdJBLzZ6yaDMkHFVfVH95RdNbbqni7IcvIDEop7tP0+q
	SZ5KmLqySFpIHDeZsqAw+/I9ZOkwnRs=
Date: Thu, 23 Oct 2025 14:26:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761254771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CVbxmFxkl5Gkpe0F49DlJZc2pZ5lmn7pCYA6JciiN2A=;
	b=wYV2zcmBHINwgvFe5hylpssfqut5+tSqdMSSDkNybl3VoXsDgkxkxs1ry9cBMJxmIycOsl
	qKxv/pCm6HltrpbLM7Pj/D0LJWRiRYTmuZeKMiqgs692fHvXuG5g7+rxYWOPRP70H5az0j
	TIVT3vVLFcGjo4sdBN6Lnw+dY2ztErE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <qjqtaukb3yw36eiwktayyv4zhihgz32yy2yolpqvxn5yaeuo3i@fvznetjxhker>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 823FD4000B
X-Stat-Signature: r8hi1p81po6mtq1qzhd1x5dxfsahbhqp
X-Rspam-User: 
X-HE-Tag: 1761254773-39142
X-HE-Meta: U2FsdGVkX1+AimibAG9k7jL6O8MvdHsaxpBvGKztlKlGuq8+IXvAFeQZQBYz5QpQh39wzifsiiRAy8P9DDTJnZIWyCpWYYoFl3tTpcB3KP9w99B12MnRfmlfqqXbXQYMZ81uobMMQ7NYz9vKEnq6H1+QAz4zs8dqbitgqMCCnoC0RUtlu1B74j8XwV87W4fXefmiXK6CHMc1DMHYLXQ8QKFyYo0g8dHTMj65Hdk0BUT14Ne7CR1vMJN3pnlWyEdIp8itqjBtw3LU0o2G2/4dwvlSKOkTnzGmxh2VxUV6lWmNqdSTDy/94nK7HJI/HX7sj6LMmxc7LVAllR0pGw3s1CQdlgzkCJQiljMKUcn3M7Kd6SsjAGBUqGfl1GKEOaXp+gyvRAzwAq0dNLI2hi4IsRe3+aJ0H1//DaZ5amNWUMTWUCYfwXxdFhviUO4dMdHJsKi2WpjZIHVJKFCP69We4eWeCq5c8tSpAjoko0xY1rQOFVvWnNzQ09TwtgYH9Ah0FcJvnGd+XcWyo4xLuGytIt2/sts+2pI1uVBaGaCwVIx/LzoHil9saXuucJXO/DkrmDKavw9Y8hj2w9jla1mFxzbIB6rPScq7P2fhbBpcw/9sTjfp3nWkUoYhER1EbxXA4fpZxuztNDfeS1whd8TvqwfDnrL/SY7Aqxhr/TQKTUAxMAu8YKpPSLiuVnXe5NWSZ4fEDY+miseV6n0cNa3BpThmZGcvOBkxKLsPbhEejtwY2s/05zKAk4D0A4KP+Qb1cMkZP12No9LRHWOdF6X6G36rQB1XdkubaZsPWcTPU/Gmh3RFbDoESx3guy0N7mQnpU6PFIAV3JDZqFHIImW11Yt80aGF+6Gt0iGqPVKJ6bKMLmaLd8RKdf5mjxu7j0s3eFhO3W2NDvfWvZtq4E0bZlQH7ixR3IwtHFdGDmAVGwuy994dZo2mmayLdjj3CvFXfdpk5kAA2Ccuty3ZlNW
 RTScQ2oJ
 jAFq8h68JgWV18UTzYAqdHqevRWcFV1axPJjw1aM0sgYHaWkmrbuYkI1p/wA93PF/8FlX7r1bplb1nPdCB1kyxPa+ClKFnt7sxlaE30FmLV9v99zSwxKSy3UtvA+wtFXhU9Ep97//E7zDTnE0sFbRRSq49Y9gA5CZFDXgf/fsFqwqmV+lGX+sPsfxWQ2uWOcWKP+f88hXRoKciSGHNSrJocFpMG9RcpVZc68Dm9B7YUivqzFMmcP1yBMC6wTBMZbWN5IOtvsnrlJW2aU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 06:12:02PM +0000, Dmitry Ilvokhin wrote:
> Allow to override defaults for shemem and tmpfs at config time. This is
> consistent with how transparent hugepages can be configured.
> 
> Same results can be achieved with the existing
> 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> in the kernel command line, but it is more convenient to define basic
> settings at config time instead of changing kernel command line later.
> 
> Defaults for shmem and tmpfs were not changed. They are remained the
> same as before: 'never' for both cases. Options 'deny' and 'force' are
> omitted intentionally since these are special values and supposed to be
> used for emergencies or testing and are not expected to be permanent
> ones.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

This looks good. I would recommend to also update
Documentation/admin-guide/mm/transhuge.rst with this build config
information.

