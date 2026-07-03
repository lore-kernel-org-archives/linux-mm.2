Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2D2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEAC16B00B6; Fri,  3 Jul 2026 07:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C7E6B00B7; Fri,  3 Jul 2026 07:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8BE06B00B8; Fri,  3 Jul 2026 07:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 822736B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:42:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16CB31A04F6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:38 +0000 (UTC)
X-FDA: 84947277996.24.6589E1C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA1384000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ChmdZguI;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783078956;
	b=aUvMO1FnX8pr7BrV4DHuzvHK2Zwsr4zmHkfY5wH+WUN0K3aXhuG7EYxvnjI4aGGEWqIFwa
	XNM2h+BAYRMKB9AIdYGKBbPfm6M2bSew+a53VjBXdnQaCo4prKheDHPKQSf5+rYOqggyco
	73dz5Fv8jHIS0h/+BOcoKHs6mQho1Ug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783078956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrvD4ysnBUSiqqKfFU24MbUtfA6jQII4JW3QordojR8=;
	b=JU52Gy8Ac68QTBtd81kIH0okMzwsb+jdNiGEboYo7s0gbC7X0xNRx9i4Bn7Y6qmktMuaHw
	LayEwhjPXOjU9RGRYMPGaCwca5wizdeZRuV6dhIcdcAl5tpzCkeDNe2AEP1OvoXOTlvqJq
	h+/EdlMC3PUz96EAmlSObZg6l8xbVoo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ChmdZguI;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE8CA1FC4;
	Fri,  3 Jul 2026 04:42:29 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 746DF3F673;
	Fri,  3 Jul 2026 04:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783078954; bh=AQZap/nO3QOWdmBME1D8S/QnzexpIaKu0FkaoBnYCDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChmdZguIcwq+gbFANUj06T8ixoLKDm7ElI3FTPt3rVY2FhgYf4zdNmCdcx3GXnc09
	 yN1Wyvali5Hcevy9BtFOkUpoEe0FB+kPRvhN1aTyCsK4Sk/BC5ZEc6eLBJGlQSsUO4
	 3lO31Kmy2StVH9amzSTZiDwRvCYmBmM+cKo+ypuY=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned addresses
Date: Fri,  3 Jul 2026 11:41:54 +0000
Message-ID: <20260703114202.365553-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wwt8ur3qhz665ayf6aq4t1bp36bdqrit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA1384000B
X-HE-Tag: 1783078955-681206
X-HE-Meta: U2FsdGVkX1/jDDjNByeY0GAMVJSwz6JCM81LG8eoZaMh7zRRIz3DM93+YzsFW4gQ/B4ydd9j9tKaIvGDSWFgy3+adntY6aaGqZD0iIumx3Ymguhp2YPrhWS/rF2HV2F4x+vpsOGi8WaBCAfBDWr0R0/06HEtSuWWqcTJtyzyD61v8GNhSJ1bJZ+glfrA6btgWcXz8ZhdRL5Lzkux760lQcCR9W+fdPm3jCtrKE6WSJ9S3gOfLpAIYFZeDGSivNZemBwk+WTN2MjFekJt1XFTNMQDbZwErjnq41MpPGr1zgWQ5h9P/Cdxkz+UVrm1c4ft5TK3pchkEENmFZmbeImRb28mGfhTTKHeq55kgVS8hwHwqi5zoAhttpHBm8LQOMRLB6QqDFissopS/wraz5bfliiKNhYSCD4rMJbdgfYN25AidZTphAAcgxPMaEE0gWwRY0S/4smhC6FkcJw6jKCbre2APj0PcZSH48ahTFOAwtFOE7YR3Jag660b3dRYPRDUqZvqMsuhj+zgSMJHi+pH7womzkBnnnoxBZwt1kucfRq/8RiJ3NNHNcXzB80RepmXwa2MK1a3EZbMWvXjeKtL3+rGWfOxsRUVbWuh5uR7uA/6J2BJx+UYI5FkEDGt9ZPkrVUJ8EK4xeENLGs92kp8Tt2uWARoE1twSmZDmc6zagxRPckuDA8L507kRhvjegBTWo2ur/S+7m/tY2+QU8IiBXhloNRCeHa0OGvjPLTxH1QeIvedGvU6DNJm20FSh/rj6o0aFFYISs4zB0hcHOzxYUP+BHIDbDVOnqumOWqtmSPcyA0tXfi15dYGKtw3wFgvXb4M3+jD4dwb+OxwduxPSgHS2sjjhxoJN0EHxoLneAvvZ1ksKDeeEWC/tZInvioXLQZgwp0smmXlh0Vr7yIh7wH6DUosQNQo8+USInZKI2pLrqLqdZly8Li6ReUrlb/89Qn4DUjP2fAN8Pkb3aK
 6fHrluvr
 +siVSblNQUtW03vimH3JAVuu6/hD5yGorYruaJ0ro16zGUPbLEPs7XOT09EB/eufqeDBqpBc8rkUvJ579Kq3i08JBLpKOdlwZJ/4m4svxCu2l2lM9aVKZZ4nYF1jHWhjHYN/22fZCNid+JXchG7nrTFi6go73j1OAPzTee+YH9NTTN8KKR4y27Re4bH0ftXSRgGbBgiWt8GRlRfnQdgLA61+4OTFjKV32EK0gaYnISRGpCbO3sC0AmE6CFpfHO/k3oVOhswKkI2JPmQpRXdeMfKyexuCo7BAxCvHxEEdbij1EyJvl9qQIFQrIqnQYswSudD4ZHYG1ZkwRjBYBMUh3l6opGs/QxX4SJBdoawdDkPN5O0ExJDBJkTLj74UBeW3n8bpXTduojcc/nKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

huge_ptep_get() can be handed a virtual address pointing to the middle of
a contpmd/contpte mapped hugetlb folio (examples of callers are
pagemap_hugetlb_range, page_mapped_in_vma).

The arm64 helper rewalks the pgtables in find_num_contig to answer whether
the huge pte we have maps a contpmd or a contpte hugetlb folio, and
returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over the
contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
if the addr is not aligned.

Fix this by aligning the pmdp pointer down to a contpmd base before
checking equality with the passed huge pte pointer, to correctly answer
whether the huge pte is the base of a contpmd block.

Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 30772a909aea3..8e799c1fe0aa6 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -87,7 +87,7 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
 	p4dp = p4d_offset(pgdp, addr);
 	pudp = pud_offset(p4dp, addr);
 	pmdp = pmd_offset(pudp, addr);
-	if ((pte_t *)pmdp == ptep) {
+	if ((pte_t *)PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS) == ptep) {
 		*pgsize = PMD_SIZE;
 		return CONT_PMDS;
 	}
-- 
2.43.0


