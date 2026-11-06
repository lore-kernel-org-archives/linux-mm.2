Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF239606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eKlv0PJ4
Received: by kanga.kvack.org (Postfix)
	id A24636B05B0; Thu,  5 Nov 2026 20:08:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE936B05B1; Thu,  5 Nov 2026 20:08:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8762C6B05B2; Thu,  5 Nov 2026 20:08:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB296B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:08:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57EA7140CA3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:08:28 +0000 (UTC)
X-FDA: 85402908696.30.8648E15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E335340009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:08:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKlv0PJ4;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793927305;
	b=s73CdvQyudgFrm0GJazTM7MZgfCSMxwo2iRxRxiKrXoGjp/tLghlqLrMf6z9SueLKBFzkE
	iN9dmr97YdnsaPoYxY7MRnqnDe6v4bx0fir/y6yigcan1rlPoNDk23kqN7KxuprcG6Mvlz
	Jqd/6hvo80JdaXz+hTCnMrfoRahoTX8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eKlv0PJ4;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793927305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o15vljGBPrSpL6tMsJUEx5VdBCBrFc3GWWO7AUCavZk=;
	b=5C+fRzRvZ3GlYg32b8RZgsxp5GHsZEfjM0vh2sQhUeUca3/AoyXcloIo2EKd5rVrnYRMEw
	vdhNGYswYlOCcG9b4gM9A82fnH4WxW9rCP7noRuI+PxdaIH4oc5cc32LEG4jd5R3EOlc6E
	HUNEMKd2z3+z+r+u3VkX1/rCxhh7Z+o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F254601E3;
	Fri,  6 Nov 2026 01:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4861F0089F;
	Fri,  6 Nov 2026 01:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927303;
	bh=o15vljGBPrSpL6tMsJUEx5VdBCBrFc3GWWO7AUCavZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKlv0PJ4nSS4qNLgELPDMzv0j+nfNuim5X8z1T9q39haF7J6fKy0LDjwoQY4hKCpf
	 fG5ozCC1vmpXNzqHinwk3z1P5OEX3Aq8IHwpy8ooneik6e+xd8An2RRUmeyiyMDSUv
	 QJdtwY7eogm5qP11enkOnLaIkiXmFGG+Oi22Xa5otOOrVjy8LBQxfo6dINM4HFZfJ0
	 Th5hXodoj0PbDNFQveDNgj9HjI/h6lZ1PafW0JxjZ4qfFTAudhUNUuvXQ3esZ3p1wl
	 c4YVRiRuC3g3oatsyXM5h19dUzKi0fE7HqWOrjZHgz2GpyXCQeoaCJ24wsQzzT+usT
	 L10FfxLsfqhmw==
From: SJ Park <sj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Zach O'Keefe <zokeefe@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: don't map folios that are not uptodate in MADV_COLLAPSE
Date: Thu,  5 Nov 2026 17:08:15 -0800
Message-ID: <20261106010815.96125-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105-set_huge_pmd_uptodate-v1-1-a78d8a1b7117@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x3g3nakko9qjpjzowezbnejangaanpbh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E335340009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793927304-593556
X-HE-Meta: U2FsdGVkX1+NvHrlZR1SXIqkAp2j8ssHkVMepSFDZ+NaeM2hQ7S8TWEzNAThGRllgGEbQ1LGN9ZQCKD+62syZGpqB3h2BMAvQ+znuO1GwxHgSx8rRlkxdjR8shFLg2zmrMe4wR3mW1TZ0jGPAKIBQYBPcXXpe2L735GvVxPBlNVBejLEjKLP8gfLw/lm5fcGb3TtTchhHomFahCjFDwxcbMEUq8LiiLTGxqQY7RPtKvtTv9rdJtcQulTB7FsVjHF/mAUofzSkDIGX0ic70bNqXDDJJk7/cqf4VJPLSlKsrlzhZ2wCPGK4gM7IgT9gkJreJUv6DXDaWmyi+FY6h3T/Iff1tomG7pEEmRNZ2S6xdZUw+bU1w0xF+j9htIL7HF1D2k6mtm1xDGFKqPp7gKq7+Ply24YUPdAAslf2jrvj5qg2W6XIz94EUZX7EoE4gi4SW2fN2ZXUZKHxEwDAkfREcytOYvczbA1/Hd+6eZZ6jMbKaHajZoOZLlH2FFzmnEjDSz2PS1xldbeM6LHX6ZnweevJBYdI1HOg6gjz8T+vJbxeqeQPAxMIUNIUbE2TK1N3/fUz+0Fi++kQ/donmriSFaBwXwde2vp16KucD8PxmDRwvc9Kv7aOJnKcunS7zNtw7MsHnJtJOlT9Wau0Nzju253L78DGwvLdQUbmf4gnjsuYYqNrG39b0mDcpgt9C372fBolgkmocg+KFXlxTKIYyiBJk2pRgp2zYvhzt1RnCDMzDMDydeQyMh98KniNyWRMqEM5sP4OE0eD3wMmSoDkejag/RwWKX2X8ZS/DyxOLekFRX3XSM3Uuc4uNakHTKqr5/4mhSVJBFTVJ66RrR5xA/yLbdsGPhfjOzNqUnR6wPL0oRk0Heb3UWLzEdVUQBHc8V07EY5Au9B83hzWp/goNRBmHo3zESVXEc+wWuC3G2+bGSDeNWOGrMZugxiXbID5ZWAQXZxqyANIqJM0yx
 fAmP58Wf
 ObMohH2OPg1LuBiWqcJyYAJLrjeRHrHlurf+UwSAG/M6J51WAmC4tO2yYpl89wXMAOyFN22m6uACrRSgjdTncpzsYBGcQnRY3I5J0BX4ohs2RI27M8MvcMmK27+b55L8jnOd0nhbnM2lW5EJdHvdjYpT1GpFPVouyWvkgwj/GOUW1Km8OaQViycB9dxyYnhgyikIjbIX4b6BkrfKIqawXFCpHJ+CpZyflOiF2gAc8q0AICrWoruc9sOOJA0Y20UFzD/r9QltaLYiAXgJzy9cTAhIQXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 19:16:44 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> madvise(MADV_COLLAPSE) can map PMD-sized pagecache folios that are not
> uptodate. For example, shmem fallocate() can put such folios into the
> page cache.
> 
> collapse_file() already refuses to proceed with folios that are not
> uptodate. Let's just do the same in try_collapse_pte_mapped_thp() and skip
> such folios, leaving handling to the page faults.
> 
> Note that collapse_file() effectively clears shmem folios through
> shmem_get_folio(); let's keep this fix simple and simply let the page
> fault path deal with that.

Makes sense to me.

> 
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

