Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CB5CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 08:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444A96B0092; Thu,  1 Oct 2026 04:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C1F6B0093; Thu,  1 Oct 2026 04:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3331F6B0099; Thu,  1 Oct 2026 04:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DAAB6B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:10:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8235CA0333
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:10:51 +0000 (UTC)
X-FDA: 85273336302.27.B42978E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E71E020008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 08:10:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqvZRIdr;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790842250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5/phgaGBQwVy6V6BUkCiUN5WmeiYYNNtE9pDVKKLjI=;
	b=Bxy+f657e486haXcApr3gqI3JUgBE2lAYQ1l1G7Sdk3Yx1QzXT8nDYuRG2CU2HDXbTyq61
	Va87y/3YSeZAg1bv8tCsB4/Hu4ckDNidneH6nzaMchBN/MuZMDOLCN5KzqHCUqB90Ql2CV
	nxjfrUeC4Ohso2qup7lZaRk+MxUN9PE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aqvZRIdr;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790842250;
	b=jnQrbzNIerW+RJuIvFSzziS+YNIHQIB8B4FQnhVprXVDGv+MvUrk/RhQYup/mowSwlI/jR
	zkqmHHlfx5C4w0LyvZYX2mirrN1wJRCLqsgrbKOe+zlK8uAW6ADFt2iMx3TbywKny/ohUe
	MJUZPltLenPpNuwA9hJ1cTdkL97uio8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBD6740A0F;
	Thu,  1 Oct 2026 08:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810F11F00898;
	Thu,  1 Oct 2026 08:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790842248;
	bh=d5/phgaGBQwVy6V6BUkCiUN5WmeiYYNNtE9pDVKKLjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aqvZRIdro+8NdHQstHL7gE3OG7dqz2U+WyzsVI8h3r7c0vsi0QBDnSdZLjUzzqYgk
	 2c3/n5Z10vygU+/SCs7KYlMFoYvJ8tnzI/jomGmzM6R8qiDL301Ylbbqi6wffK7LbC
	 c6l2jaWaPxj0CmM2DwtLvk3wvVUNMb+72TMjPWjrH1nAVT3O/T6MjIz2L7HSW1D+qs
	 eA9E2v1TdygeOd1/qYwfp/TyTnEzmbZxFqMSSDx368vIbMXS10j1yYm2n3nHUeUcqM
	 xuaj5dQL3RUErk6WliqUS+3LFfo9vjjx6Ir9SlwR+KyDpXvTEECiUPbyFisBqBpyyP
	 NE3pI1FiXgGKg==
Date: Thu, 1 Oct 2026 09:10:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH v2 0/2] mm/mremap: fix two issues with MREMAP_DONTUNMAP
Message-ID: <ar4VdqHwMRuYdqck@gremlin>
References: <20260930-fix-dontunmap-partial-self-merge-v2-0-f388985a0f0a@kernel.org>
 <CAEev2e8TXNwon=Ro27WYvyn-N5j=CenA8pEgLTPerMQtDh2OWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEev2e8TXNwon=Ro27WYvyn-N5j=CenA8pEgLTPerMQtDh2OWw@mail.gmail.com>
X-Stat-Signature: 7fx7t5yrmhfgd6naant7a33o9xwnh56m
X-Rspamd-Queue-Id: E71E020008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790842249-100930
X-HE-Meta: U2FsdGVkX1/rn81IMBS6/p4c3erbQVFMhnnmqHABgd+XkIwUf/tzrONpF+B2ocG6hpK6pefg8Z+6W7T/udIJ45ZM5sILtDFlAw7jn4uglZoPGidllvsZg+FQgfDNaD+5ZLiIZFiJCTDDm7l+r8R0DDv0gk1OzEsU+ODjXRhXM8pJ5Uq23gzpR0Ug3/1rVUZSAYdJiPvsObR7A5Ic9UURGO3LObKSho5p0RjkvjzPwr6Z70g0Yh428f/dLDLikt7FegBVNvCO2tDk8+oc+IoIts+61zpWizNW12HOeleCNjE+J5ByNRtVRXCpKncYkRCFKcgw185YAwmh0YaMUt1L6yghpeKzp0i1hka2R1PWXo5D/7lQQZpEtPKrFHchSDOs72vPl79+xmnJrhAXJhMWG9J+ChpUTe/eZ2Qs1VrhQAN69T9s+AktrlvV6k0hPA3+rWPWa+G8cLLaGWklgu6uaqeZKzIcKumDjj9kG7Qf7pXzwclIyhUkgZfmFe2tUcZejah+5oEQGZk3JDeVqLxLedFhx8btRMhE3k75JD3/o2P8sfZYox+LLzRiaJz0fBsPZSsHQy1kv4ilaJUSas/eMIk30pudAM2QcaJhe9/j/UTxxG/CircA/HJOe5t4gdAzO3k0/kfOyBqQOwtGvdIuZy2EWJJypEnFNFvpTymz0+tdy3hDceLdO4V6AeoxHZaleuaghTgpL+a7aVgWMCO13BdJ20RxF01xXZ1LSQKm6AmTVZSoqHWcUED6XE5Ka0jmIbF8sIsaN4Qsm4fiEHa5P58Icc6/0AUpFDSNeXPWYqyGtHUgdxN7b5p7bY4TqD0cJg2gkoqsxeTjIiq6/sAGf08+2jCFrvYoG+Cb83CLCJK8a3A7ye0gyP/NIYZ/j3PdBQetqxbk0uOc9+yA07nflz7Lfpy4QjNYACDQz2jo2kU5djygVKdQNXagtnKF2aMZkAzn0vRP6Oqqk1e1z3Q
 BnMC0EQG
 0aEKDgdtjlgetWTVdLvz5Qgb2+NQQaHoTBsiflQQASsmfZ4FLe03lVxGwRJuPkHyF1W8VlVfr0by1zYubDrDzPNeIopwWCu7k8yc5fCyMkvY+gXHd8AvvpWpyQvQIkV1wvdYCEGo5PbU9gtmPypftXVqV5AbpCjR1GtcpMNBEq2BiCZ7CnNza4Ssmw0Izsv4ftJixSU7GJVXTBDaZHf+x1sUeO/aFG2mCM9OhaKnmEHlBjEUF5C6FHcNJhdaKpf8yaoiffg89TICZqMDSselqzU3VLboQBsDNc+XfKryX5rQNq04XaubiZq7S7ELOqDwLvu865tHwIOvY32kc+RwZBcEoZpHtoy+hQGMy9QaVg+qLUfG3nrwSWAEtGNdhoWWDGnRyIHlzh2ys2KlJg69dzgAPng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 02:15:16PM -0500, Anirudh Srinivasan wrote:
> On Wed, Sep 30, 2026 at 1:47 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:

> >  mm/mremap.c                   | 70 ++++++++++++++++++++++++++++++++-----------
> >  mm/vma.c                      | 21 +++++++++++--
> >  mm/vma.h                      |  7 ++++-
> >  tools/testing/vma/tests/vma.c | 10 +++----
> >  4 files changed, 81 insertions(+), 27 deletions(-)
>
> Thanks, the selftests are passing now.
>
> Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

Great, thanks for confirming :)

--
Cheers, Lorenzo

