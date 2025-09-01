Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6938CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22C1D8E001B; Mon,  1 Sep 2025 04:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC7D8E0014; Mon,  1 Sep 2025 04:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBD78E001B; Mon,  1 Sep 2025 04:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5DF58E0014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:23:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A361811A194
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:23:12 +0000 (UTC)
X-FDA: 83839991424.21.FAEF750
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD050C0004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:23:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dxj37rLh;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756714989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYz/kK/xIJysV1rcVmsQV1lLcWHsMQMTfdhuPz4R6Xw=;
	b=Lml9wQdb1kvSUCE29Qq9tfELQ9aERwhqgutctzncxoxcFqsZrSehnBA9CvtZ198xE60NoY
	pmPzZHtBK/czjsG3xpfoZ/m7SxMnEF6zTfAXwGmOHNMFl46YH6O9OyJPL1H0B5m48UdjPm
	eMNOCiMNWcVVNP91Vw3V6DdewBJRVFY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dxj37rLh;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756714989; a=rsa-sha256;
	cv=none;
	b=SGz9SRkYRcouGWpoQLkefMrQdEKzYqYvrrrP7ttIL8qvGG5i8jeBypDlQuo0+Cnl+08Hv1
	zBiQ9mg9Aw9IY1iTNOaSi385afrnmvv139bOJ41KDLXXVvXPMjzmZqosy/UPtCy28HXJ3y
	JbOUvCBkYrugs6259aHoELIbWw16Mqg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8211C4038A;
	Mon,  1 Sep 2025 08:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B64C4AF0B;
	Mon,  1 Sep 2025 08:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756714988;
	bh=slg/knugYfdID3fSA+rgt5Womt4WwMw1yB4SjgeL3Lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dxj37rLhvkC1zDOhXYNisORhyQGv8KEshR5FUM4G8we2Wq934pICLmZoAbgNW3MKN
	 K69badD1GR0FpB/Yv2PeQI8Sa40PR0+2IDBpeGZgYZCd7PD1Z/grD5LyMz1DJYdFvr
	 ZaNY1tE5lX7DKsSBDuwRo4Q3e6KM6ah9wWHvN1EMxW4gbVB9sLLKAfoA2w7Td48czK
	 JuELGCIhSHd9bRuHV7KhedQnAY4A4i7DLf9GLg9r05JiWIMlmUUm9bHPQca/WNDprd
	 5eO2hhZBlN7kUlkwAT4bTg2tYb/V2PzUe9+XIpiNK2qlrHQ+L/F4SSqTywjetKjb6i
	 DchCOkDcO/xbw==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0BBB1F40066;
	Mon,  1 Sep 2025 04:23:07 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 01 Sep 2025 04:23:07 -0400
X-ME-Sender: <xms:6le1aC3C6O3w4wscLelV5FRNUN98JnVzyF37UdzHb1_8y4q3p_1S9w>
    <xme:6le1aKMxr_vSuVTnjMx71F0_3ihB_l65DvrSU-DFG6wgCdQNkSIUfqUzQ_OpcXEg6
    a526rkN5xCN_7f9Muk>
X-ME-Received: <xmr:6le1aCKeJfzS4YNCiGPsWQoy5qOT-mkms3JrBcXST3Q88FD_fVk_BycmE1Ah>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduleduieeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfeikeetleeludeghfffkeffgfejtdevvefggfejfeefgedvkeettedugeeggfek
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkh
    gvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggvvhdrjhgrihhnsegrrhhmrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeifih
    hllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohephhhughhhugesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epsggrohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphht
    thhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphhtth
    hopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhm
X-ME-Proxy: <xmx:6le1aLbBHGmQXTl4i9SIr_G0bFii48MMgLzngIF7t7YHNigJdJmlfQ>
    <xmx:6le1aLlRMzxMlwoaxF_4ibpRe989Bcsi5wdx2uT9hoDRaHSsCCb6wg>
    <xmx:6le1aObrjGa7fnU0xlUiafoph_NQdHTKlxwPGazN3BrT0DcbddI1aw>
    <xmx:6le1aLCYRK6PVuUQRD5KCJ7P2kdaGWeuSOGiKi_V5LrYTu8CkN8HKA>
    <xmx:61e1aMaKCGPQt0qMRld9Jff5YzArem6dX8bzFb6XOIfel4ak_BTGGGHK>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Sep 2025 04:23:06 -0400 (EDT)
Date: Mon, 1 Sep 2025 09:23:03 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, willy@infradead.org, 
	hughd@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: Enable khugepaged to operate on non-writable VMAs
Message-ID: <7towtl2pjubgdil4csn5rg3usbai5xvzz73wqkwj5b5awh2iim@wfvahykzjrlo>
References: <20250901074817.73012-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250901074817.73012-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: AD050C0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qqrr75k9x3bb7phtwtwrxk74p7etcmew
X-HE-Tag: 1756714989-858543
X-HE-Meta: U2FsdGVkX18BlvaNF5JtNMVJgrkiZyxXc03lftXhQ3kfy2NRbOqrDzFXo859+PxvTnLszNKB7vo1GTQTzY8dNXBZbRj1NFrSM+GnKp2RkgXhw/WiA3FtZEZbWXVfYMMbQyBtJHASrhtDR6hwrioyH4g8/OgSG4cxUhCL5jEgxurfUtY7B1MEdbPqoMCMmw5yTrawmskXhgiI25UK3wQySesJp726FVJ2iXUjU2egM787fETiY/OQT9gwBCUk4AMIpaVnDGDHIKyMZ85h8u8cJKiK21Fr+XidTv2ahyoeWoT1a2BofY6J0V8bPV8rG8lxcxD0iorlb1j9jhyaVWRa3GT/Zy/sGG6y84zBAHO5bTvygH5DFzOjHFVNfdmgO3MgCjIDI4aaK07gEF+L3BssYi6kTebe0m70FIwmwCVYIm7EaTRWzrWvEFf48hhKQ2JGWeQUsdze2mtDeIcyDJiYuwK8gi2W4I57+pO+ttzfbcWxN1OfYX+QtZAX30HYBOh8u1bDfpDXNuvhQKxXssKWa99e8NzSCDbB2Jipw6zwT2So1692mtbeOZsX34W4PD0Rpwa4AYS95E93NXm3pku9bIJMmMpCgyEZpSbDExRe2PjPkxDKd9AWdDCo+vrJZc5fNJcpeDTpqlsCX8PTOU00KNu3GBgiT4/WwupXubR22kr3E07gBEFq9SiwtBOCp2B3NKrQ7MMfmyQQHat/13hCSEu8QPZooBEKCkktsHpoBXHUSmw1gIaQ/wFJdX9ayNynFQqIhkWYmXUzxJ3AKP1Ym+a5v8z3X1nnKDyS2tFKsQpPPIt6Zy6z+82wAiaD4h2yhdUs1pCHG8+lJn891ZDE4adD4TsgvItBC/dANRNCrTKhZ8EXI2l6X7MZxUJAMYxhTWtyTbbnFuk5xEE7m8CHRyYTFzd9j5HqlGaC2PESKGQOtUQSVqABxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 01, 2025 at 01:18:17PM +0530, Dev Jain wrote:
> Currently khugepaged does not collapse a region which does not have a
> single writable page. This is wasteful since, apart from any non-writable
> memory mapped by the application, there are a lot of non-writable VMAs
> which will benefit from collapsing - the VMAs of the executable, those
> of the glibc, vvar and vdso, which won't be unmapped during the lifetime
> of the process, as opposed to other VMAs which maybe unmapped. Therefore,
> remove this restriction and allow khugepaged to collapse a VMA with
> arbitrary protections.
> 
> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
> non-writable VMA, and this restriction is nowhere to be found on the
> manpage - the restriction itself sounds wrong to me since the user knows
> the protection of the memory it has mapped, so collapsing read-only
> memory via madvise() should be a choice of the user which shouldn't
> be overriden by the kernel.
> 
> I dug into the history of this and couldn't find any concrete reason of
> the current behaviour - [1] is the v1 of the original khugepaged patch
> which required all ptes to be writable. [2] is the v1 of the patch which
> changed this behaviour to require at least one pte to be writable. The
> closest thing I could find was: in response to [2], Kirill says in [3] -
> "As a side effect it will effectively allow collapse in PROT_READ vmas,
> right? I'm not convinced it's a good idea." (Although Kirill realizes in
> [4] that this was not the intention of the patch).

Hm. I don't see a justification for only collapsing writable pages.

> I can see performance improvements on mmtests run on an arm64 machine
> comparing with 6.17-rc2. (I) denotes statistically significant improvement,
> (R) denotes statistically significant regression (Please ignore the
> numbers in the middle column):

Could you give a summary instead of raw data? It is too much for commit
message. Raw data can be put under "---" for reference.

BTW, why did you pick hackbench as a benchmark? Seems random.

> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> | mmtests/hackbench                  | process-pipes-1 (seconds)                                |                 0.145 |                   -0.06% |
> |                                    | process-pipes-4 (seconds)                                |                0.4335 |                   -0.27% |
> |                                    | process-pipes-7 (seconds)                                |                 0.823 |              (I) -12.13% |
> |                                    | process-pipes-12 (seconds)                               |    1.3538333333333334 |               (I) -5.32% |
> |                                    | process-pipes-21 (seconds)                               |    1.8971666666666664 |               (I) -2.87% |
> |                                    | process-pipes-30 (seconds)                               |    2.5023333333333335 |               (I) -3.39% |
> |                                    | process-pipes-48 (seconds)                               |                3.4305 |               (I) -5.65% |
> |                                    | process-pipes-79 (seconds)                               |     4.245833333333334 |               (I) -6.74% |
> |                                    | process-pipes-110 (seconds)                              |     5.114833333333333 |               (I) -6.26% |
> |                                    | process-pipes-141 (seconds)                              |                6.1885 |               (I) -4.99% |
> |                                    | process-pipes-172 (seconds)                              |     7.231833333333334 |               (I) -4.45% |
> |                                    | process-pipes-203 (seconds)                              |     8.393166666666668 |               (I) -3.65% |
> |                                    | process-pipes-234 (seconds)                              |     9.487499999999999 |               (I) -3.45% |
> |                                    | process-pipes-256 (seconds)                              |    10.316166666666666 |               (I) -3.47% |
> |                                    | process-sockets-1 (seconds)                              |                 0.289 |                    2.13% |
> |                                    | process-sockets-4 (seconds)                              |    0.7596666666666666 |                    1.02% |
> |                                    | process-sockets-7 (seconds)                              |    1.1663333333333334 |                   -0.26% |
> |                                    | process-sockets-12 (seconds)                             |    1.8641666666666665 |                   -1.24% |
> |                                    | process-sockets-21 (seconds)                             |    3.0773333333333333 |                    0.01% |
> |                                    | process-sockets-30 (seconds)                             |                4.2405 |                   -0.15% |
> |                                    | process-sockets-48 (seconds)                             |     6.459666666666666 |                    0.15% |
> |                                    | process-sockets-79 (seconds)                             |    10.156833333333333 |                    1.45% |
> |                                    | process-sockets-110 (seconds)                            |    14.317833333333333 |                   -1.64% |
> |                                    | process-sockets-141 (seconds)                            |               20.8735 |               (I) -4.27% |
> |                                    | process-sockets-172 (seconds)                            |    26.205333333333332 |                    0.30% |
> |                                    | process-sockets-203 (seconds)                            |    31.298000000000002 |                   -1.71% |
> |                                    | process-sockets-234 (seconds)                            |    36.104000000000006 |                   -1.94% |
> |                                    | process-sockets-256 (seconds)                            |     39.44016666666667 |                   -0.71% |
> |                                    | thread-pipes-1 (seconds)                                 |   0.17550000000000002 |                    0.66% |
> |                                    | thread-pipes-4 (seconds)                                 |   0.44716666666666666 |                    1.66% |
> |                                    | thread-pipes-7 (seconds)                                 |                0.7345 |                   -0.17% |
> |                                    | thread-pipes-12 (seconds)                                |     1.405833333333333 |               (I) -4.12% |
> |                                    | thread-pipes-21 (seconds)                                |    2.0113333333333334 |               (I) -2.13% |
> |                                    | thread-pipes-30 (seconds)                                |    2.6648333333333336 |               (I) -3.78% |
> |                                    | thread-pipes-48 (seconds)                                |    3.6341666666666668 |               (I) -5.77% |
> |                                    | thread-pipes-79 (seconds)                                |                4.4085 |               (I) -5.31% |
> |                                    | thread-pipes-110 (seconds)                               |     5.374666666666666 |               (I) -6.12% |
> |                                    | thread-pipes-141 (seconds)                               |     6.385666666666666 |               (I) -4.00% |
> |                                    | thread-pipes-172 (seconds)                               |     7.403000000000001 |               (I) -3.01% |
> |                                    | thread-pipes-203 (seconds)                               |     8.570333333333332 |               (I) -2.62% |
> |                                    | thread-pipes-234 (seconds)                               |     9.719166666666666 |               (I) -2.00% |
> |                                    | thread-pipes-256 (seconds)                               |    10.552833333333334 |               (I) -2.30% |
> |                                    | thread-sockets-1 (seconds)                               |                0.3065 |                (R) 2.39% |
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> 
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> | mmtests/sysbench-mutex             | sysbenchmutex-1 (usec)                                   |    194.38333333333333 |                   -0.02% |
> |                                    | sysbenchmutex-4 (usec)                                   |               200.875 |                   -0.02% |
> |                                    | sysbenchmutex-7 (usec)                                   |    201.23000000000002 |                    0.00% |
> |                                    | sysbenchmutex-12 (usec)                                  |    201.77666666666664 |                    0.12% |
> |                                    | sysbenchmutex-21 (usec)                                  |                203.03 |                   -0.40% |
> |                                    | sysbenchmutex-30 (usec)                                  |               203.285 |                    0.08% |
> |                                    | sysbenchmutex-48 (usec)                                  |    231.30000000000004 |                    2.59% |
> |                                    | sysbenchmutex-79 (usec)                                  |               362.075 |                   -0.80% |
> |                                    | sysbenchmutex-110 (usec)                                 |     516.8233333333334 |                   -3.87% |
> |                                    | sysbenchmutex-128 (usec)                                 |     593.3533333333334 |               (I) -4.46% |
> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> 
> No regressions were observed with mm-selftests.
> 
> [1] https://lore.kernel.org/all/679861e2e81b32a0ae08.1264054854@v2.random/
> [2] https://lore.kernel.org/all/1421999256-3881-1-git-send-email-ebru.akagunduz@gmail.com/
> [3] https://lore.kernel.org/all/20150123113701.GB5975@node.dhcp.inet.fi/
> [4] https://lore.kernel.org/all/20150123155802.GA7011@node.dhcp.inet.fi/
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Based on mm-new.
> 
> Not very sure of the tracing parts which this patch changes. I have kept
> the writable portion for the tracing to maintain backward compat, just
> dropped it as a collapse condition.
> 
>  include/trace/events/huge_memory.h |  2 +-
>  mm/khugepaged.c                    | 11 +++--------
>  2 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 2305df6cb485..f2472c1c132a 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -19,7 +19,7 @@
>  	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
>  	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
>  	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
> -	EM( SCAN_PAGE_RO,		"no_writable_page")		\
> +	EM( SCAN_PAGE_RO,		"no_writable_page") /* deprecated */	\

Why not remove SCAN_PAGE_RO?

>  	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
>  	EM( SCAN_PAGE_NULL,		"page_null")			\
>  	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4ec324a4c1fe..5ef8482597a9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -39,7 +39,7 @@ enum scan_result {
>  	SCAN_PTE_NON_PRESENT,
>  	SCAN_PTE_UFFD_WP,
>  	SCAN_PTE_MAPPED_HUGEPAGE,
> -	SCAN_PAGE_RO,
> +	SCAN_PAGE_RO,	/* deprecated */
>  	SCAN_LACK_REFERENCED_PAGE,
>  	SCAN_PAGE_NULL,
>  	SCAN_SCAN_ABORT,
> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			writable = true;
>  	}
>  
> -	if (unlikely(!writable)) {
> -		result = SCAN_PAGE_RO;
> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>  		result = SCAN_LACK_REFERENCED_PAGE;
>  	} else {
>  		result = SCAN_SUCCEED;
> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		     mmu_notifier_test_young(vma->vm_mm, _address)))
>  			referenced++;
>  	}
> -	if (!writable) {
> -		result = SCAN_PAGE_RO;
> -	} else if (cc->is_khugepaged &&
> +	if (cc->is_khugepaged &&

The only practical use of the writable is gone. The only other usage is
tracing which can be dropped to as it is not actionable anymore.

Could you drop writable? Maybe as a separate commit.

>  		   (!referenced ||
>  		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>  		result = SCAN_LACK_REFERENCED_PAGE;
> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  		case SCAN_PMD_NULL:
>  		case SCAN_PTE_NON_PRESENT:
>  		case SCAN_PTE_UFFD_WP:
> -		case SCAN_PAGE_RO:
>  		case SCAN_LACK_REFERENCED_PAGE:
>  		case SCAN_PAGE_NULL:
>  		case SCAN_PAGE_COUNT:
> -- 
> 2.30.2
> 

-- 

Kiryl Shutsemau / Kirill A. Shutemov

