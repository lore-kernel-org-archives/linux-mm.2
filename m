Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14E3606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FhZQrkbz
Received: by kanga.kvack.org (Postfix)
	id EB3A86B05C3; Thu, 26 Nov 2026 06:15:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64246B05C4; Thu, 26 Nov 2026 06:15:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D524B6B05C5; Thu, 26 Nov 2026 06:15:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF92B6B05C3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:15:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D376403CF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:53 +0000 (UTC)
X-FDA: 85477015386.29.CFAF301
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 89D0C4000D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FhZQrkbz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691751;
	b=6UDjWbA9bLWo9mhf4jd/+ptF6jm7nuIoJPPqzTMkZBVRXrotnQC5Z259jadZARaqTe/Asl
	AWD/5wtyto36Y8lp7+mVyEar/d8Qww1Okw9o4PWuTg9cQMHPiRHMAujNpqV37aocyznmZt
	MCFAaRdZZspDeA41prIXz95z/0cQy30=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6atE1eiwuCb7s2iVfEQ/DOpR2uoMH4CREq7+ID+nSU=;
	b=gLOXBvRYTpvjpLdJPjqRB50VWFnjTBMmv8xXnquzx4mzqdSnMtAphFgl9S13uAugFicu+/
	9eSBme0FG3rEkwYzYMMHO3PxUQafHF92oCgwTwRbwaR116NKcHH9T9vpAR2Y6dQm5QlqXQ
	eaGtvfBJWFAH/87Yo4Yuak7NYxCGCaY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FhZQrkbz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27EDB6287A;
	Thu, 26 Nov 2026 11:15:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D505E1F000EC;
	Thu, 26 Nov 2026 11:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691750;
	bh=h6atE1eiwuCb7s2iVfEQ/DOpR2uoMH4CREq7+ID+nSU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FhZQrkbz9fLLnez5g+K/QukESaIZIWw4BT9B08hF5j5QN2u6tKoJzJ/Yb/7cnqB06
	 xmLy3Wcd/+Voi2G+cmzi7XjISmA4zNa9ThOqO0aFQw+C5bMuBQj1Lk6itrFCWHRYPP
	 Jka7N3AyNFtHwsawLaetbg6iFvshEsmLB1RYhXPtDlqBqvtLqZEYicW5T9i7jVez//
	 Ax6uVcl6ftm7I1WlpQ0rhuZRHvzUYiXOnWeMhJuREHnMcCgscaqFCcPFebtk3I2of/
	 JYgnQXacJLJciJaZNGT+pTjMR4p1+op/86rB8u49OUkdSz7jnoVEY2tWzEh+RXgIaH
	 6eNcuB/DKwnaA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:21 +0200
Subject: [PATCH RFC v2 08/54] x86/mm/pat: fail a split at an unexpected
 level with -EINVAL
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-8-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Stat-Signature: y6t9gusjzhmbbehtkwap448hg7xjakzr
X-Rspamd-Queue-Id: 89D0C4000D
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691751-68411
X-HE-Meta: U2FsdGVkX1+uDamhA/0j7NL4mdB/tPy9f8bZm9GUykuPw4QnPtzlbemnaA6MIlpdyUskugkclpC1HzyTTUgd2OQUb6d3LjRhrgJ8zUu6m+nnKvScz6jhFglh5VZL0rQZ67FVsl251T0z9hLEeuA0OrtssB/+riN6iNHtiVVuHTM7WOp1lRRY9h15VGYmUMVvoTvpb2IwdT8VJukLoltQ8waQiwcAhFiA/kuXJav8Ic1q+nuImjX+oq5V2srxE3enWUVuegNYmvjoVk7DHpBzhC7z4bT9h5paM8YZSvz6F0Fks0JHgwLCfbhf/qhoQjG/KcYgnHSjHD8+IiLBLx10S+5Blo0A9AkI2vTESCBU6Se8yg+kGZbExa71E7ve8kZPGMxeierK4QvxrkBV6KcE90BJ/chpQ5CCdwAUdsOqQKE7fKafmZRpZI7NLzhbMZNV2oCpXrNeSkMU3CluAj7nI6bDKnyij65L48ctv4uTPUWbSdWrvshFccHm4cHRAFhcZBtc2qJnP0Wipe9qWOZ7ZCMNHlyFalUHbw819j2DSH6LSmxXtoz7prPjKp75ei+3cq133mtBndWnH3PnrAsryH7ovwKA5h8F+1ejJ2Kn5n5yTJaSXV2JgK2FF/gFm3da7CK5Gm70E4IOMyY/ut+5U1Gh2nBozhk5EFOHy/1i4KMh2gb5PdgO6xwp0BRFqJlquDu5G2XGvzPNnzGtvgCi4FDcVXBIurR47egGPNbBnmTs71qElwDv6XXUBDr/LKEnHrHwn3i80UyMJDCOqH84iAaDxLZbgbQ68Tj1aIyGhNqev7Wb0B04N6XRKonqCobkCOgbzW93KUlwmWW6p1NGLXZ1y8QKgysym0LRJ1/8YwuMgVC+yHQq6uE6StRmuyOh5280yB+O+Nbg/GBY59aBuIDTxwiNPY9AqIrfUf9cpYb0nwi32WYpah0Xbi7PUz/KDKf6APZH7TAAFjVhu3J
 AJC0daoo
 CvEGkNhm8B/+Kx5NCt64/N35Z1KRywYzE1k8lOyM/d82XwPwje1k/2BMPz5IC+Ae2OswvKxP0JVxMa/8zZayxenRmU42jOd1WoEEe3YyjpH/R9lsUWC5EkgWBtQ0fZLvVVClAzDLmg3RhsINrhWVEfjugHBqG87sAEgFSFcOU4Jh+7AOoVBmtSze+GwuSVByi5o8GMKHWG2pn0QzQwia/o+gQr+T3MMCMAR4lyf97opHXtHbwNUgreBckPk2krWEmzLA/PBNfsx3IvIzoYv0a6slWRkFG3egYLxEk2rQncMhTFJPP+uIMkdLfcjDs2WMeyE4kw7fG52AMbE2chIK/nx6QsPaNM4oVdHA9BreU4+Jyxte5HYGwhUFjPS6Sj7cDTVd+ynIM2aA2fcgLGIKwmxUTkXCuyG5P3c/FaFHJSzi4YVo1J054EFZiuEO2dbYYt9no//kI/+LVpPqWYFcin6JuCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__split_large_page() returns 1 when it encounters an unexpected level, or
when another CPU split the large page first.

split_large_page() frees the page table and returns 0 in both cases, and
__change_page_attr() looks the address up and tries again. For an
unexpected level it tries forever.

Getting there would be a bug, because no mappings ever use P4D leaves.
Still, a level CPA cannot split should fail the request rather than loop.

Return -EINVAL for an unexpected level and pass it up to the caller.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index db41f94f2355..217c739371ee 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1178,7 +1178,7 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 		break;
 
 	default:
-		return 1;
+		return -EINVAL;
 	}
 
 	ref_prot = pgprot_clear_protnone_bits(ref_prot);
@@ -1230,6 +1230,7 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
 	pte_t *pte;
+	int ret;
 
 	spin_unlock(&cpa_lock);
 	if (cpa->init_mm_read_locked)
@@ -1241,8 +1242,11 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 	if (!pte)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, pte))
+	ret = __split_large_page(cpa, kpte, address, pte);
+	if (ret)
 		pte_free_kernel(&init_mm, pte);
+	if (ret < 0)
+		return ret;
 
 	return 0;
 }

-- 
2.53.0


