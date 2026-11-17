Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103D4606A881
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EE5y8BbO
Received: by kanga.kvack.org (Postfix)
	id 34C6A6B05B1; Tue, 17 Nov 2026 06:19:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3242D6B05B6; Tue, 17 Nov 2026 06:19:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261C86B05B7; Tue, 17 Nov 2026 06:19:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01F766B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:19:29 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C5908021F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:19:29 +0000 (UTC)
X-FDA: 85444365258.28.BF3ED4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D08220004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:19:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE5y8BbO;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794914367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmRxQPVUK3jeDTIVGHnBZg9JSxo3fE9mQz3Nh8K4I5U=;
	b=O3rmfqTNfU8/Xq2gAdcFi7Go/4JoofPKDtli5uKE1B/+0yeYFDFP1FN7VTH8PnANMzMffN
	nYDW2b1BkNxBAEB5u0H6zn80nhqlwqJXRZ1KXZkX5QbOBzT/hWMBI7xEr9PD526IAj030y
	kKyo3nX0HntlkpDwBviiXErb5fELb+8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794914367;
	b=ExxHQ4aEW/pRT99+UE8C+H+P1r5LAMR/dLoxZROSl8GWTQ1HeJPc7M9IIjNiQgpC6Bm0oP
	UdEPG/NPGV7y1YVQ7g9SzeYgByKczPxgKuwwbVvKvPf2WUyC6JucP+akryBvQMZ3VuftfS
	rJaSV9P8QrlE9frxC5V2Ll3lAjtJG3U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EE5y8BbO;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 961A24580F;
	Tue, 17 Nov 2026 11:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633921F000C4;
	Tue, 17 Nov 2026 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794914366;
	bh=jmRxQPVUK3jeDTIVGHnBZg9JSxo3fE9mQz3Nh8K4I5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EE5y8BbOm8OvZCB0Dah2qA1gwILUqNYMmrizrbU1YH9mbsRr8Tluhiz3XAfeVEpfl
	 TC+VkLiFOOftBWtpkiJylymZkbg8zMJXjdvrgXVmJu5NAZ2CwVTIfbHQ/E9dH03rR8
	 heYzjpTRv4lcel0NgF0Y66YhPt+0dp3LevYRHVMZ+HujsjwFez7YARUziMXHOpRwa1
	 YHuhdm+rUPHZ669DeNRLezXZOs3mfux53dWjtxwn2ssxWZo/gXbUaDqmlMKUwu/f3P
	 6sWcKYaWp+eZGub8XNsfsKzsRVbjxSAlc2zQ2eSMp8jIjG7BpTxihF2Wvt85vvDGvw
	 GwdISJ6ylbWvA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7DE3D198004A;
	Tue, 17 Nov 2026 06:19:21 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 17 Nov 2026 06:19:23 -0500
X-ME-Sender: <xms:ODj8asmjZARLlX3WpTJJuVqsPob6BMBBoFDeyMr_4vl6iQXvaDClBA>
    <xme:ODj8ajlG0kRVxiXQZPQ590s70WvKtqzqusjwyZz96ZUMU2A741QhbqFBrgaD7Px1G
    jcdVJNDxNP09I9EcWql0uEajLj7TiI32bb-IPYigLq0XMpLwmjms4fy>
X-ME-Received: <xmr:ODj8apNCnUYvlo-8rdzb5No25ufJ_nmNlfUCIvbretlYp1zmfopiQTdPSSM>
X-ME-Proxy-Cause: dmFkZTFUPiINActD0mDIlZFNb+WeDPVf8Y0W59PjGpKdeovC1oExoWyA7gCtP4JbTeIA1q
    +22xWFGwJcPngXKrCApIQ2f8vk3rGH9HSFNq4esX30kP89EjM27GtzUYiW1B3kU3Y1fyuG
    X9qiWQH9BmDOSudlhjd9tPIRZYCBXG2Rh/l09ZqHR7gz6sJv9eg4j4KMMXUDrJQaPdDpj1
    +JTsoTCvbnfwodM5GhfGE0jEUfvdcNmLHB6euiUvH07IObIDhPq8MOYCYfHrUDEBFjxLZs
    /uy9Yo3FaoZN1mopb9H1+8QNWXHtZUurIGBbMwOmjwAvyIT87LF0X7jBEDiQwTgisY1fmT
    5gUswFuCj1QdGKf+AarXgZnFTVchUh5I6J9xbPswT4c8f1HE7EvbmJeEjjs+Y4O7rL3iZN
    wFu4LLr5G672SSV49Tfke4Z2lyE8wdFSttiGeHj6GVlnolnwjV3dGal8Rricmtx8+uMc3P
    AKabHWZTxt6BtWMp+rUN8dxqW1Gnp15VxHT2QmfpauEKENl/7Ka6ePGarayix6VrVHs12i
    gWjRst9LVYotb4FpOriAyCaLpAUy74KEO2iq5pm3HTD15otJzrVIeVudAG0OKySi8b6Ayi
    Ykc/zdHeHUYs6gx6wU5gP7zDwVg6Oh50mbvQJObQkMp3cOmC2frM3+h9hnVQ
X-ME-Proxy: <xmx:ODj8ai5s3C1EvoiVSPnRF_dzviMywBC6wuPhpvk1bCbKxYmeqomtfw>
    <xmx:OTj8ausONLptqI0PNztWPZDRBSwyXfG6RfEZVXuIxbQHbUecl2dzpw>
    <xmx:OTj8akOFqNm3O7GRfCu56cEQxlIQRSWoms3BjSJ1HfbPv8a8tKt3oQ>
    <xmx:OTj8aiofBDZ6Y7EgzpJFz98dYo6InaP3PFWg5ISTFIzPPBDoTeekJA>
    <xmx:OTj8ahGXFyAkbGMD2MRtCEHEFa1bnGHoyYVGREuF1MaCRcM9ja-pUT-u>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 06:19:20 -0500 (EST)
Date: Tue, 17 Nov 2026 11:19:19 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Nico Pache <nico.pache@linux.dev>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	Daniel Wade <danjwade95@gmail.com>
Subject: Re: [PATCH] mm/khugepaged: mark ptes dirty and soft-dirty on mTHP
 collapse
Message-ID: <avw4J0mBLJQMzdMc@shutemov.name>
References: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-khugepaged_mthp_dirty-v1-1-024e4a12c2fa@kernel.org>
X-Stat-Signature: meos46p3ws5q4sp99ofwkkac9fwxx5k3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D08220004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794914367-766252
X-HE-Meta: U2FsdGVkX18jYtxdMK5huGrY8vXg3MqYba/6S4jDD7mmA8T87AlgiNY7YhuoUUSCpHBlEpkpvo7kErjtFq6ju2qngHbNLgWWTFSpINDrohKl+RVdXUg3IcJbCWb6lGXaLNg+2yXyfIjpCNvCivpyEnexs5kjgK6k9s5CxTTboYXm77c+TM602yxjo/rnbDAhIN6xDaNiIoXXf7sneafrPozxsTMuUFOe++rMM9MJU1Jvl+IfJqD4OJB3TXKIGCc7Ro6anYR/0J3RbfctItK2jqVUpj0Q5chcJYlEAGQ6UW0C6i83m1LK8hhCbp52QK5uEVO/qrBcJ+emnHsC5XGAmrdHUsC1inB6rP6RMujPwR8uveq4E0+w1t2K7+Zgjl2b/oPPYQeQdmNihIwsbazEAh8+hh7717h+AYYB7gW1UuNn79ICbSaWXRdri3r54KovvcFs3tZltMSgeBfy6CNeM7XVa3PH9F/FnoiI3XjzLyhS1AgCOj6qb5GIfRt8OaqbVrGV2+cRmzyiHX2e5lTq55Cy77xJBZTW4U8o9diF4FUUQAbgk/Tv0n/Eu9EvQOcpBMl3T7VA2ZX/MHcbBCa7yBPuCe5OSuoKtati9Kl4Q3GXLpX8RWeCkn7lf/JotqJ/hAiRBY28Wou8+eJntk7ZcM+72andNFFMy03c7rFLcyX0NWWIFMz0gtTVAzmflRKo6Xj6+oGnbtxIqdK2q2mbJNbIxW0EstlH2t05Pq3p1mQ+cP6zWKzcZsP4QTfzbq05E92qim9bY2OD/u6ubuQW7r0mZPViuiAoVLG7xdi2eNOYJyb8RPC/It0BZ8GAMKUQ0twuQ7Tc16/0hODtZcojPAZVNnpTES+dO4Xd7Lp9wthS50x+mHB+YR63DBtqpVUPRHskVaGbCdcx5+IMEYaIcLKJG9HN/w19Zxn/OJzUEPwuQCg4uuk8F9QZLahRjYUpUHZQURpkpnk0LPRNAhh
 QOIRGtU8
 GePwxX6OEM6nqESW6qoo6Dq+MLhhOCyKbU+M3O6ApUVL+moCZzllDlfo7U90Oma1Te+4jGm0Mdnz5zXnG7Dii28GaECwzHa86Xti68NjVtpq+om72No9WQBHlBmXt00LrZEr0Bqx6t4ZI1DhQ+8FhemoZVjw6yFOeDB17Z0oOi8/XYoeCx0EzvutJDkf8ZRAjAH/KJHOhC9DBFEyesFAyGYlocl8wc4y9LOW6GQFF0Pa2vAY+lSMKgdDGYqPug01T5D/XMMU+gXAs+RMZbq6rOe6YQGBnA4ZLcjalhYQVj5cINpVRbMaBdj6ouw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:28:18AM +0100, David Hildenbrand (Arm) wrote:
> An mTHP collapse can lose soft-dirty PTE bits if pages were written and
> the VMA was then made read-only, and not setting the PTE dirty in
> VMAs without VM_WRITE can interact with a later MADV_FREE on a COW-shared
> page such that all processes lose the data even though a single process
> MADV_FREE'ed it.
> 
> Collapse does not preserve the soft-dirty bits of the old PTEs, so the
> new entries must be marked soft-dirty. map_anon_folio_pte_nopf() relies
> on pte_mkdirty() to do that, but only calls it if the VMA has VM_WRITE.
> 
> Further, after CoW-sharing such collapsed folios later, all PTEs will be
> clean and the folios will be clean. One process doing a MADV_FREE can mark
> the folios as lazyfree and result in all processes sharing it losing the
> data once memory reclaim zaps it.
> 
> In map_anon_folio_pte_nopf(), call pte_mkdirty() unconditionally, just
> like map_anon_folio_pmd_nopf() already does with pmd_mkdirty().
> 
> Consequently, we always mark these PTEs dirty (including soft-dirty) but
> only set them writable if the VMA has VM_WRITE.
> 
> This essentially reverts Hugh's commit 1ac0cb5d0e22 ("mm: fix anonymous
> dirtying") that back then touched do_anonymous_page() to avoid forcing
> clean anonymous pages through swap instead of discarding them. This no
> longer applies as shrink_folio_list() allocates swap for ordinary
> anonymous folios and unconditionally marks them dirty before unmapping,
> regardless of PTE dirty state. Keeping their PTEs clean does not make
> them discardable.
> 
> This now also marks fresh anonymous PTEs dirty and soft-dirty in read-only
> VMAs when page faults allocate real pages.
> 
> This has low urgency.
> 
> Fixes: e22f2fe72c74 ("mm/khugepaged: generalize collapse_huge_page for mTHP collapse")
> Cc: stable@vger.kernel.org
> Reported-by: Chris Mason <mason@kernel.org>
> Reported-by: Daniel Wade <danjwade95@gmail.com>
> Closes: https://lore.kernel.org/all/20261117075246.61336-1-danjwade95@gmail.com/
> Reviewed-by: Daniel Wade <danjwade95@gmail.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

