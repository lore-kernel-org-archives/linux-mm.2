Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77B1CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 20:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62EF6B008A; Thu, 28 May 2026 16:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13916B008C; Thu, 28 May 2026 16:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29B46B0092; Thu, 28 May 2026 16:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3D456B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:11:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 644231621E2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:11:19 +0000 (UTC)
X-FDA: 84817923078.16.072C3D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A9E99140006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:11:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ekq60DDN;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779999077; a=rsa-sha256;
	cv=none;
	b=forvTg+i+bcf4tH3zZpZOqtgZpHUbShUx1bOXQc40v+vl/fHQBZl+0QF/xQ2GO3AE9gDzE
	a09oVCjeIqRqguzz25Fn+Qorr6bUe3Ul2jNJ8kY6OXMEbSxL2ECEce8n81setJj2BDkcoS
	plOYon83ylsgkukSrSJKjljxF1kdads=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ekq60DDN;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779999077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUpZENdsRQQGhSTXMjyju/sJ1S/GlspTzkqqk0lo4CY=;
	b=JVyjK6YnnqNF65J7xdDVgYPZleO00/C4OEArKDB/9OWko39dgEA3yJr1VwZUOWyVMYLI0N
	g0Wd/zkYF7+jWxnLgJQMBkQCwprF4VHZ+DJFQY1WRdLkxEMpqA52IU/ov2MwWzE25jOpdQ
	I5JTZORm50kxH19xPLyqwHFbYgjYzNE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3AA443477;
	Thu, 28 May 2026 20:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5A01F000E9;
	Thu, 28 May 2026 20:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779999076;
	bh=RUpZENdsRQQGhSTXMjyju/sJ1S/GlspTzkqqk0lo4CY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ekq60DDN0/EfqbYTRZfD1WiirUXWxQTPTxY16rdb4/7wMAOQIUWk323IYixJjRiPk
	 jkmhpvi9QLv+pmc6Yu7hQnEn5mwLQcrYWkOPOryXldXhd3rlh3reJtix4vap6bVGE2
	 Jewn63vowTVwVLGqclVBqi7ztiwbv7FXpQC6FQNo=
Date: Thu, 28 May 2026 13:11:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Liam.Howlett@oracle.com, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260528131115.184c178d03d516e11248a1ae@linux-foundation.org>
In-Reply-To: <ahidV_iSq3E-FtMI@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
	<20260521163309.c5cc5d3f6cf16bac212cf90b@linux-foundation.org>
	<ahidV_iSq3E-FtMI@skinsburskii>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A9E99140006
X-Stat-Signature: p5tw41mfguqqpi7wgaw9xptg8gr5dy4s
X-HE-Tag: 1779999077-852224
X-HE-Meta: U2FsdGVkX1/r4/cDciSa62+EHsRzmbQypjxU2AwpJJUIzkSDGnGHzFe+jcHXECLwZ/qNbyb54MTXVFQqk52WaJ6IWbf0uj+vHECwn5R1B831MB1HbjhZYXMGllGz1zMfKcUqoc8fEFffCDVVWcBr0lbR7Z6UhLjmDl99YJd30PRrVsKZXiZZjxr1MwDW3xlQMOP0x6wGi2MGgCtsk+GzNaG1R8bTGiriqemKKO1wEvlYHlZRkXp4OxBKKLPs8DnrEfe/WWJ4g0WiL1TTGKecKflxwSffloHuA3cqSho8bYqFe4uWaA8hJa6qMmQwUch9uJipltUUV4UGxneDQX2PLOmfLcYSrNFS+UcYjYFSJZzny3SD7voZXGc/LIzeMToVxkRrg0KBCPYDHOWdyaFNaPMCon+IILjF1av+lrR9gEZ7A6WGf1ccTDMyVJdptbX5zUayl8o4uoUj7GnuYAdxvS1aqoP79ESdQNnHBltdoVq+beUus7MeAWrku+sAtejbfrCu2gXlHpje1tNNSc0CBsiHK2Ia4ecqXPi9IkCZTJBixGRinf7bx7dVAufiPPXoW+hcvOFU0QCAFEsSIfBS5o3qsB81XqYPfK9uMPd/Ww9y4Bl2ddwJp/FEzF7dMfis8vuqcNP+SD8H8DNCocjOfyGYkMGp8NnKVVX1S0VMJNIHQdSog8YePC2dgkOpjkDTrJ6cQY0I4bocmCR49HfLw6S9en44RRRWmWoC1DggrFYqxdj1qIUe10qabmyOTLdFUCxgIZ2aGd0+M6SOsxnoHTMB8hPThsXHzFa3KvZk2r4bpCN4wYgPKsMCr8UZ/tBwmqWDGeVzmIkfIzobdmnYzHaLozSKk/57Q6o433HM/RhCe9wXtZXQ+Of8Xd6L1Q54TFiHEZnsElsTQfN09BboiHvF82CAdfry389H7aDjlGiJqjiAWWFJsYjocvQSD99n8qTDb345Z6IHpRWKLri
 siOWFhtP
 s+a/vIxkvwmrLklSnQdJGCoBjqNF53UiLkcq7VQ8Lg7B/DpE4bhLyFD3/NjOF+1ErSkELJT7oeS72DN3M8JsGP+XVdDkzzGj4jfg3apxpz5C2naLd0IWpO/KmUO7lG7U/8dyXy/UImrqZRWb3eLJ/laDjJly2cdvnhYa/Adu0GivGXrbhs00WY3QAaa/NzyJFrkuOxvJwZaiTbTJBjxN3W/O3OEJzZAVZOeyjOfotIM/KMCo25cRH73v8ELkA2/Kk4fYOW3wgt+hwCwFM0eRFNVNZRoEhm+ju/0GXaiMiyTPpu3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 12:53:59 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> A gentle reminder as requested: do you think this change could be taken into
> the mm tree?
> It's beneficial not only for the MSHV driver, but can be used for
> post-copy live migration of GPU states in future.

Still no review, alas.  It's not a trivial thing, affecting both hmm
and userfaultfd.  And we're closing in on -rc6.

I'd prefer that we revisit in the next cycle, please.  Refresh retest
and resend after -rc1?


