Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E74A10854BE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0221F6B013D; Wed, 18 Mar 2026 04:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15246B013F; Wed, 18 Mar 2026 04:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52506B0140; Wed, 18 Mar 2026 04:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D807C6B013D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:58:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86DFE1405E3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:58:04 +0000 (UTC)
X-FDA: 84558581688.05.D33E4DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1615D40005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:58:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eakVPsLY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773824283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JYtHqNRYRARxZTvcmHu6lVxoPHL08OHbMd1jnOm7wQ=;
	b=6Tezu1U+xZQSSyCQeiqAD4Sq4S6IIVdh6Ze+42MV/+UX7P/igjOaU7+sdVnM/Q2A+m+Mzi
	vkYtwB/qJ7K3CCwLt+QeXpJWZxxw2eCmRZhuODkvkwwTShLfN7odhnj/VBXLkcYBbygGBS
	SSll+JHw6QTxBuu4p7Wr/lrROqoAkUs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eakVPsLY;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773824283; a=rsa-sha256;
	cv=none;
	b=wcPSsLNArYUXT68VpLpCSRtfYHSdd6VdubnunEpskzqfITjWeLMzht1keCu2w/0kSKEKus
	TsGFlKkpCXGxs8QvKSnDa2oi6zRSRCFxbolhGfj2OPtKGSjYyVn6uB6l1Esc3D3qwIkCG8
	78ak4c6tiGBNVsUXbBQfwiYt/8bEv2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05C7243493;
	Wed, 18 Mar 2026 08:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEDDC19421;
	Wed, 18 Mar 2026 08:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773824281;
	bh=cqTfs9ElgfRveSlxZtaNdRLx2AsMn35zzyPDr2hcR/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eakVPsLYp5el2mWPyBvzY0WUc83/+uOe/m/8v548qC21LkZWapg7XgSypswYJI8Hh
	 CHbCh1t281ADJsSgnCsC9+I00J6O/pTfcBDBl9ChRl5QmvUT60a4i0nJmX9xN5Sn2/
	 7kOcojkNOnyt1Ico9ukYkw59zKbx/ImeJGeekNOSmEm9JSYNFkc4JGVpoXsU0carqR
	 lDWJqBnVxxdpNjCowh3sa6J2nwt3tEOQuJ/jQMHJKeW6VfQEhT4vTBGzOUjVeWTAas
	 /0IQcgVnjsb4uM2bEMIU9ruagatDrVdaJJhiPYm4/uPgLnDhYRt1hkO/YxBW93buIg
	 FtPQWCzULrf8Q==
Date: Wed, 18 Mar 2026 10:57:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 14/14] mm/sparse: move memory hotplug bits to
 sparse-vmemmap.c
Message-ID: <abppEiCJN_432O6w@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-15-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-15-david@kernel.org>
X-Rspamd-Queue-Id: 1615D40005
X-Stat-Signature: fra6hua97463syht3megou5m8nrm7fc5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773824282-646084
X-HE-Meta: U2FsdGVkX1/RMPRD58DF74PiUrEMBn80CVWowTK6a2+yXQ6P9D26mcvXU5WA3j2cZTrfZqFCQ4xdt4dS8aZES7aTupGlCS3AhwvC1fgTiqyTCd3tXcISwQB7VaH0kZT5bdWnFth5ZNuk0BlxZUt3stPArknKUyMiEfb6vQqFQFi44zDlF2A0XDPENAz//WsBovQEzWo8hpUQeF+ux2JwQf2HWkcvuPJTeLLJErhq37MXFuGU4yo4gduRWYE2hGSo30OiO+Wi+1qY/iVyoqOpppiyGvASYQtK9w1BJZiiGad6GIlJhrns46vWhU2FEa+xeFz/HEnWvslQfn00+RA4H2upEaWla2TAAblYF8sM2xcVbeENUi0hSQfk5MOdeYaH3Eb9K8Ceaw5n/ncZSl4wcynXm+fZ7X7CiG+cGdR2Lb60EbSuGZOLJtRAG3MRUwTK1MUBYnkJgYABg/AYRq8oMlqWz0SH8UmS8fC81K1jfsQfUcEyOzjZG0Wfm9HXGPc6QKfH2qCQUOUrqIAzNUOwJDX2LK22N5IzrpoOnkIFh5R/5jl7PsfWztfoZPTaOkuDBXHLfLnP1qn4v0UydLs/ytwaKM5KYKgXMcletm5JN/GhUQsp+atTo+uyMs0A2ji403HWs7jqjeuJTm46J6l0x/AiBjksyDTN0zcQASneg+zES3BNCcUow5DVBaJCgwgsFL3sVKAIa1eONYB773PNBsaWQaUXc9YIm8vYmzT3ThazgbR1BBxAnv2s99Z88O0mKKqG9BwF+fhs4KKwYBVD2YOPXTT75MaYYAwHC0lxrZatJ4wOaJN3UorRVTmkj5MeJCLxpMlfqWpqLvsrJmhgcw3n9urhp3yhZF4Y08biho+r4xNamV68hhb2EnCSF4O9auUTX+w4SwDG9LBiJFcHRLhU5gSkEOQZnbwfqSYopDUsc/KLk9SBUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:52PM +0100, David Hildenbrand (Arm) wrote:
> Let's move all memory hoptplug related code to sparse-vmemmap.c.
> 
> We only have to expose sparse_index_init(). While at it, drop the
> definition of sparse_index_init() for !CONFIG_SPARSEMEM, which is unused,
> and place the declaration in internal.h.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mmzone.h |   1 -
>  mm/internal.h          |   4 +
>  mm/sparse-vmemmap.c    | 308 ++++++++++++++++++++++++++++++++++++++++
>  mm/sparse.c            | 314 +----------------------------------------
>  4 files changed, 314 insertions(+), 313 deletions(-)

-- 
Sincerely yours,
Mike.

