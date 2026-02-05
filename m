Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4099EA794C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCF96B0093; Wed,  4 Feb 2026 20:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D7F6B0096; Wed,  4 Feb 2026 20:35:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43A1E6B0098; Wed,  4 Feb 2026 20:35:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28A446B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:35:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE8421A0335
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:52 +0000 (UTC)
X-FDA: 84408686544.09.2A209D7
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id E63E5180008
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KKH+rkEh;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770255351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jB+pKLVdpa0bbqVI1xb7HhQNNAElviybHSqCegf2x4=;
	b=nTn3dpT3U4DcEzHFIZ5Y5kcvW02gLBJT4R1maHCc+8bdDLL1Zpg7/bFxqGYynGDghexIyy
	N44uwLzZoPRmibaLsOQOctA0VUvPQUIq29MrNvuQSIXabpa3lpnznNWEGyzgDNqRKrEt4Z
	bQvvbsiZkuk2HU3oG1ByVK9fR3kY4Fs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KKH+rkEh;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770255351; a=rsa-sha256;
	cv=none;
	b=cYEqEYxdGLy2ccAa/M5zcvr0ppyW44c5tMYbwCi2ul7fCIJKEak7yM4QsnEbrz7R2Ku2Iy
	quaSD4kZWHv6kieeNCgpNblRQTuHiskrKDxIAtlpg73W4x8IA1TE/hAT79Vowg1qPawGC2
	tr8uH1QAeFqHqlsfpylOV8CRUePdu8M=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-124a1b4dd40so1036204c88.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 17:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770255350; x=1770860150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jB+pKLVdpa0bbqVI1xb7HhQNNAElviybHSqCegf2x4=;
        b=KKH+rkEhZwv9+1Iz9yBv2s+smFRpLele4G4xaL1EoDFouOTlb7irg1m6QAgMUXyhyu
         m3A6aN90PyPn8RFS+Rc/KYkcf5nAbBk9np0BVDnAsfvs+hBnT4DtbK91ELwV4/DF/efj
         RDiPmluT0DKSYr02BqgWSN6Xcjl6DPPHe/pASlJis41qeMD53dmM2pGA5pSDF5vgv6ll
         zc9gGY9ewcR4sHLpHkZYzbvkpeIudLiqpX9nMe168H4YMaOko0eQa2NZTNqSgkLKN13o
         CNVzorePJ6H2TMcz1iZ8lItQh7wRbASWfBosTmh5vECxrBPhECC5ZkFGj7UtkP1LLp0H
         wmWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770255350; x=1770860150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4jB+pKLVdpa0bbqVI1xb7HhQNNAElviybHSqCegf2x4=;
        b=HCKyqJfkQl2lGF36phzEP2Lt/onU+jesui0U5XKynLkRJA05tqFDE4IPizrLkly7OB
         s0H4qEezpkkD4gJytH9XYd/Rgx7rICHl4z1m7CHBlfnfe04b7g5njsRaKbaDteFt/DcK
         Uv7bmvaD7DR6R0N4Hblwqjaa7PGD9KAA4iAwDmhnvXz5FW/ug0FvGYp944By4rh6DX1Q
         quZkwkMAS+a2e1bBblKN1Qfmwn6vPInux8u4asCX1FunZv8ntTqkQocvnQmuafHkqwgH
         Prq4EEQXvjL1ZK+oSpc/EIbNBWHz7o+MnxJDEmx0T6GaIUNA/jjq1tPBVEcvarWvquHC
         DSzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYbQ3VbgWLA5jJOZTdeX8EB4p9pfzvo7qW18p8eZ1VHqohoQ/olbI/5fnT3k1k81MXiqNBs7QEGg==@kvack.org
X-Gm-Message-State: AOJu0Yyu2eKvmMf+Na579BQ7MGHP+Q92tw1jHhedf7aq6z8sdT2IkEUC
	4P3cHHIcan4y+qjxtJ0X7qHjIn0EN9DNUbQIefRN2wlSvtcEjDVW7KVl
X-Gm-Gg: AZuq6aKmk9lFuklOjqEkc165EDsJFcokOrciEQyOGh5QzeHLEOm3VBKnA8RZv9A4Cwi
	RkmQY1lyNUTeP+WbuYRqf0U/OXy+dgm86iMacX0E2Jw2HVmqwKiKJ+/5HwfMrzY5b0NepgpKmJ1
	NQAlBE81IpU4IyN3NnjDlM420m2Um+PBKb8my76yyH3lI63EVi/J33l3p/U8R62oMrevDkwfAME
	W88Lpit1tigKPpN2ykJ9v+kVUVi9dX0tFjYsZSnceom5xUoQF4xAk1M4j48EMkpjHFwy3GNCCkW
	GGW7sWlhFxUvp/U2rvsF25Hc+2b2j/6/n9K3EL+1mhSCkg+zia0M5MTfI/ZPbZMxuCF7xkvmB+E
	wUD+rT8LRMQZH4Fspy7Vj8bLsib0Mgb1va7tRvBgOPXTEFqoCDbbs7DFD4an6gb0Wjqq0+u+qBV
	5FOkKFly6E7G6i6jKAAnYNTS+KmquhpvuRE9rTtbmMpOo=
X-Received: by 2002:a05:7022:10f:b0:119:e56b:9581 with SMTP id a92af1059eb24-126f4771da3mr1937601c88.6.1770255349537;
        Wed, 04 Feb 2026 17:35:49 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-126f4e0f98asm3424982c88.5.2026.02.04.17.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 17:35:49 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v4 2/4] x86/mm/pat: Convert pte code to use ptdescs
Date: Wed,  4 Feb 2026 17:35:25 -0800
Message-ID: <20260205013527.322157-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205013527.322157-1-vishal.moola@gmail.com>
References: <20260205013527.322157-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u78esdms51qzn6bwmuf97ufb71b35xko
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E63E5180008
X-HE-Tag: 1770255350-528568
X-HE-Meta: U2FsdGVkX1+t4kRjUgoQHoSvYkNDbcH0wSajltSLaAwsQqrPKybjrg/trVn/hZ0p3REWGQ6qe3mMcTDvIYoVOKoYRAhhIFJv6lCUYDBXqLxY4aq9VpLw2llt3wPeQdD7g+154Wtc9VVglfLisOAjRHSW32/cc1fW7i70/97uvKU/z++inkMjWTeb8+QZriiGMvr1aDPPfW7Ju+cFI1cdvgZ3jqqTVi1qBdV5hH2X8ePYNX44ywEKiuGDpxIhx8GTbUWD4nuBYdrkP6eQt9bzDvdDMniwayGkY8klXh1T6Gkms37qoNe95KFRlZ1gZurLCltmtJWqCNl5NN8oWk2WSi19P7lkHVx3Sl6LqMXp4VE0mIilGuMdiU3bFFX101Ga5OZnwLpfiRp6Uv27PuvW+VjvGxGEEkAMKeeRyDJ3Oj2amRLXxSRmQAwErQzQUnGzRiFEDganwn5C84iAxLd3HpQf7JAZh0gQgdSd4IBb6IDmScWPsplj2ImpqfbGGK3AgWq/xhnTS40YPY7F7TbZKPLduvnnsFejDZrS2L5PUNXLqKQmc4SHWZwuR7JvOhQ0x66epjhZIuXAjflXktR8SRn3iF4akXR1j3rXkxqD03srcsAVOHZ2vv9BdUKPWEZhgpjj/YDJQVJcKlUSNwphqJdG83qVDM/lzpBjeCLX/G8Z349TZFhSrHywDuOrmnlUmi1PSkfY3Oi+kDKD6zE96Kp26JJ4RZaY1D4EVLHZi8R5puQzC26eiMDX1IFhJNR5EVlkmiFh8xjs1kWxKeFfPhYx9qNmNQ0glStAyri2lvskBYYjnQoxzAvbXu9P/tIQwc1SY193pAMVJExjTiBwtT9yyG2ASWyu/SXjSOTiRCadr3zvnVm2NaiAiLodZEelnpUC4PW3q++k2XMsZPjWvgoUNU2j6iLX5P3xnJYr/BR4EtrULM+2AmdqxD8NNS1GMuAXTB8+eJ3JHn3rJVS
 4fxYt7F6
 TlbyQxFeCfhO2IwZoAKTVXcjUWkQb+/NplqZmrp5ZT6+Rj+mrHKqgZ8ri8D0EFBQyG3Jz6+P5d1ZtK5UTGZAzwWnc+y9JTnCMi8gHqFmsyRRHH6T1oVjs8naJWVx66cI9KxS/8oWxftUqLOxYNPx+M13Yi3qJ9zMtAtvcTVj+UblYmklKOrmSRkWlLZ2aHm7f1ixiflG9230HRmnhCdVz11Js3S/DsJ5mknu3kHw2NFaK4Dpb5HPcq7nI6GYDbao0oeYfRfueFHlMoGJY2Z6iW4cmJ8eKBPwW7cOO6RudUHvjVQbTMXL6k+CFXr5eRIPp0zFrOcHjyTerGoIrJAUHnPWtJfa5qD42pFb0++u6rX9t/lc8EY1U6ZS6ZIX7FZg/dbngNtolK81pQu5bfhIdNOqIkj5MQdUv5Q6OSO8GtU2V5Gu19vaVaR8ASAZ8e3/imJT/krdrgplVLHjJ3Om0JITn6ir9vevsu71zvNt5eDWQgdKE2XYlKjZEF+U9UbIasmcV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need all allocation and free sites to use the ptdesc APIs in order to
allocate them separately from regular pages. Convert these pte
allocation/free sites to use ptdescs.

Also, rename *_pte_page() functions to *_pte(). Rename them now to avoid
any confusion later. Eventually these allocations will be backed by a
ptdesc not a page, but that's not important to callers either.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 6c6eb486f7a6..c6c68fbbb046 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1400,7 +1400,7 @@ static int collapse_large_pages(unsigned long addr, struct list_head *pgtables)
 	return collapsed;
 }
 
-static bool try_to_free_pte_page(pte_t *pte)
+static bool try_to_free_pte(pte_t *pte)
 {
 	int i;
 
@@ -1408,7 +1408,7 @@ static bool try_to_free_pte_page(pte_t *pte)
 		if (!pte_none(pte[i]))
 			return false;
 
-	free_page((unsigned long)pte);
+	pgtable_free_addr(pte);
 	return true;
 }
 
@@ -1435,7 +1435,7 @@ static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
 		pte++;
 	}
 
-	if (try_to_free_pte_page((pte_t *)pmd_page_vaddr(*pmd))) {
+	if (try_to_free_pte((pte_t *)pmd_page_vaddr(*pmd))) {
 		pmd_clear(pmd);
 		return true;
 	}
@@ -1537,9 +1537,9 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
 	 */
 }
 
-static int alloc_pte_page(pmd_t *pmd)
+static int alloc_pte(pmd_t *pmd)
 {
-	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	pte_t *pte = (pte_t *) pgtable_alloc_addr(GFP_KERNEL, 0);
 	if (!pte)
 		return -1;
 
@@ -1600,7 +1600,7 @@ static long populate_pmd(struct cpa_data *cpa,
 		 */
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte(pmd))
 				return -1;
 
 		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
@@ -1641,7 +1641,7 @@ static long populate_pmd(struct cpa_data *cpa,
 	if (start < end) {
 		pmd = pmd_offset(pud, start);
 		if (pmd_none(*pmd))
-			if (alloc_pte_page(pmd))
+			if (alloc_pte(pmd))
 				return -1;
 
 		populate_pte(cpa, start, end, num_pages - cur_pages,
-- 
2.52.0


