Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C23A606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IOFZUt03
Received: by kanga.kvack.org (Postfix)
	id 6ABB26B05B2; Thu, 12 Nov 2026 03:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65CA36B05C1; Thu, 12 Nov 2026 03:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599FD6B05C2; Thu, 12 Nov 2026 03:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 336AA6B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:28:13 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 195B8A0515
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:28:12 +0000 (UTC)
X-FDA: 85425789624.22.E9B02D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 711FF20007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:28:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOFZUt03;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsqACPeqlnYxJmJXczgM3wCIFdBzchwFSrFPzfCm5aw=;
	b=HqTObJZq2LNlcPFpiPTv5TqIqJurxpZ45FA5xcOz1aJDE2QvQYwr6DpgOSZzpZpyJkxodB
	MoMs1oaKzQHCfwcC3xfBridlh68MrITrPd3Cw8LVfq53Bq0ri9UeI7Jo7XLPiOa3b3dWUy
	fSfbmrCZKTef20+8/FfffrMvd2d0oaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472090;
	b=cQOi8CTqNA8tEfHjHBcak2DDT6ZDSKKRd38qbIQL4WCidKfGp4RzsRI5QT4YbaCpWrEOIM
	CIn5XKHs4Q3EoGOWGYTmm6Z6FhVwAhgB8EERS7/kVmOp83C6rm14VgCJqBb+5g9XBlvtdp
	9eWjjWg3mfhICKBpE8TxWg2b0h64fBk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IOFZUt03;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2B9F436FD;
	Thu, 12 Nov 2026 08:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF60F1F00A05;
	Thu, 12 Nov 2026 08:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472089;
	bh=FsqACPeqlnYxJmJXczgM3wCIFdBzchwFSrFPzfCm5aw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IOFZUt03oPnkjnJPRCMWT3B+CaPwZlBB5078IQqwnu/QLUXwXwTihx5clXDHJtQUa
	 hoA/5fQXlDZX6O/s9GDI3PHHWNGaXzHnA2A9L501+edpTxIxL/FTplCkNJxjGOUWk3
	 oSF4Gmkst/VgOygG8dGVSUKIDd7ebx6FIu9gvwPaD0qfZ4dZFU9k8SjV8HhuQXtYem
	 TYKKZ2U7HtFD/6LVVr1UiF9UgeZUhChRiR9aujYWnadKRJyzSt3VxFgpviyJzX5UMW
	 usgFDU7oSyYh17z5pHwZKS0OY2XbZpemqKmNVJMoiK3t+ENj7nlQlzKZ0FheOj8GJG
	 syCIE+/DGy3iw==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
References: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
Subject: Re: [PATCH v4] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Message-Id: <179447208361.3070.1557607226599858764.b4-ty@b4>
Date: Thu, 12 Nov 2026 09:28:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 711FF20007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: m9eyf4tp9m76f1upz5tw9aousc6jxbhf
X-Rspam-User: 
X-HE-Tag: 1794472090-366036
X-HE-Meta: U2FsdGVkX18YhGu3+lXWxirLgqf26UH4cZcXqwUqzksWmfJpLtfD5/OjpTkmLAwUiHfwX+Wj+vwDZKkhotyDbjW9Hp3d3IIQtaTjPsm/nwUdjx+5NQUx8tfN1pkQq7Nx/FOcgLQyT/gmbAcvcN15Kwq6wfCWtC3qxl3ITGaL+xLGqNzUkVh9nhokLPChfTQZ6URUBzWXa8bOmrbe5KhPOhVts61b4qMFhz3ReSjDgofbgzpLkTI8pNpE33wr2S9KQUZs6UE/nw2vUeJI7S/4Ep8GiaXqXRiKFWrY5UFwDtNen4RCya+s1KIfHszK311d2oDSPnKor2XHpexTVLDb5bXhYP2A7KmugSfzVW/sgMPg8GDpJFSFFT8JFWCz09TtE58MfXEezcOzCrxW0nz3u7lCrHaYOTaxnIpNMI79ktAm422jU9/I8yALWFE1/JWv4ABU42/I4NZpNtWyRIlW5wphRG+Mtb7K5+PsObENTnJRS4c+m2Mu/LAI+SR3XhwG6ZGTNyF6LN/dRnxfUkoX6FT8JBdvpK+5MyaT7c1/spMt0NWbTgxtK+UtDeTGA+58TrBizcjslL5EnvbUfDMLEfFz8cYvCFiHSKlaOrewZmpgY7an2eHUIaPNgC1ltQicb0kZl6I2F3Bfy2oG+urARUePqUd9kfjry4EmBWjBiNGgkHIBmddJiVcTt5WJNszboonHi7mJwEhzOdX4N92xBuxQGDkJkaWdBkSun4YQQACU6AprKzoDeJ6LSh0cNBneSfYvkOH67ALCCIj1/+HqEAjAPd+p9IjFujTNAq2l4qDvDlcQoNaUfpae4vqFWJZ285ggebilFpDImCW+KHTunQWTkIIVSNf0q53P8pM0JNCUOK0w4wtOoCLn0odzxnZAzOKuudLLijiUPSshJfWyf1giwAyAdVducD/iW18lRY5U0JZ3cpPVX6j4xfOgqCMvtaBI8/9DRYbht20nLO4
 Vgdh7Nx3
 Hw82Hc68GSzI6k4Vb4Iz5mlOBMB8fkef9g1R9WjRWBjDPkA6UnriiBZ2agU7OkuyGxK/Cj19pgzNjASgqDvYi31EuMzDE56lsT2uKMzhcDR+B6XHlml+oDJ10XWM7qgbq5CRxyLBlD7C0QKOJM/gAdnFFjbq9S5QYaZvhGnKAqF83QszIqdRvMkf6gwDiT14BR4sEu+1in3aM61HkGfafziFXrVnM4FoFyXnT12JJ4mJbS/DNQ0sUN/w85SmGb8+4lP608So+oz/WySUapgLbNbGNU/r0dFQpqf1H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 22:19:25 -0500, Zi Yan wrote:
> __split_folio_to_order() calls prep_compound_page() on each new head page
> to create a compound page after clear_compound_head(). prep_compound_page()
> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
> and frozen and no one else is supposed to modify the folio's flags.
> 
> However, code calling migration_entry_wait() can reach the folio by PFN,
> then access its flags. It is because softleaf_entry_wait_on_locked() used
> by migration_entry_wait() sets PG_waiters concurrently without taking a
> reference and the frozen refcount during split cannot block it. Meanwhile,
> __SetPageHead() does a plain read and write, so PG_waiters atomically set
> by softleaf_entry_wait_on_locked() will be lost if the set happens after
> __SetPageHead()'s read and before its write.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/huge_memory: prevent losing PG_waiters in __split_folio_to_order()
      https://git.kernel.org/mm/core/c/0cedfa01

-- 
Cheers,

David


