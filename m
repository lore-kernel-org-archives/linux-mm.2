Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1106CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D43E8E0018; Mon,  6 Oct 2025 10:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB818E0002; Mon,  6 Oct 2025 10:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03898E0018; Mon,  6 Oct 2025 10:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7EDA8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:46:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 803CD14064E
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:46:09 +0000 (UTC)
X-FDA: 83967964458.03.B0AABCA
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id A522240011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:46:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759761967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MtaiocTtP0D1d6fsZBlllxYLh2dMPWNbD897f/VONZw=;
	b=hRtbuvnU9liQyLieLP6r/XPwEUaE/FB9uf0ss7vynVkZNWcRFU1RnuObLp6Z2H7Q/o86o8
	nuHA+QjHId262IGLpBTqB4G0O9iiC1MNivQZW18z2yVnNlnnU1gBG6VsZm4R5TSJ1ijDBZ
	z7he3rbumL621PGwzysqO/gWRmcFx+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759761967; a=rsa-sha256;
	cv=none;
	b=eAd+TvsA/bL1wh+m2iskutdgLQMcKGm5RyZZVJJw1ov5168sR2sZH2pVq+Tl6K6QHo9WMr
	3MWAztSKP/lf2lbuFdRaYRCExEwYVf0P9b+ZhxGH4O4VNWp1X0NMjf1EycBpToblbv3piV
	B+IudRXEBioJ9Aijdj8I4Jn0rDLdGeQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf12.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4060b4b1200so4446627f8f.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759761966; x=1760366766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MtaiocTtP0D1d6fsZBlllxYLh2dMPWNbD897f/VONZw=;
        b=Tw7RDyhmGpC/VTouIDn46laYcyRitPoj7tpMLOO5LCUiWtINv1+PTfLTCNqXgjra+r
         GI7SfWJRo4cb2byUJ9IFNphgbs7+z5xmMqybuxympWewjiJBWruQCKhZl2QrHy+gghw5
         cXWsVRf5ekDjw1gsN5AtHmWNHM91m8RhF10B3gs0UQmtTK39Uo8hWYFzionbg8qv41Gz
         +wko//sRHs9+VFnsWPYRpaZwXCAQ9wHelrxw44F/JO4cMw5BXWk2ADjcZdNl5tMCsC3H
         NJL2yca6vVltnBqQc60beAZ6rJuNLTeiq7h8NibJYoenHKaZvaAkJ97zX0KPVn7B+1Ip
         073A==
X-Forwarded-Encrypted: i=1; AJvYcCWJneWxQ8kKajfEDFVDRM5GBv0sGG0hz2j2L/4HOzWALGmqzeaKduB21OBKpIrNoeooqHkO0owb1A==@kvack.org
X-Gm-Message-State: AOJu0YyjxyGqatOFq3fQcDp6he1V6SsfwdoSaVQPtL5qmyY1X2iWB8dL
	/FvqNmq/YnARX0nENJBexq3U8Ztua0f5DXsB6CqpuJJpoJnNxD65EFIF
X-Gm-Gg: ASbGncvLuBsT0PKtWKw7Rs/geodBO9bNNOyHSLW0nkOJ+rxyKdRCWz80+rcxdPN8JpM
	ZBVm014lKoAwqYqgIw6x+VJt9vtZ0IZmZO2CE+dXoo8oODiufbSjW/hynHA12ZgViVUOtDxwARt
	Nq2FwHFVXzU7y4Nk6pOR5GIDJqo5XNIQ8+f3r1e++T3ZuDRllRJLKyyu/810dLxyKW5zTsbWRou
	BSgaGt0IIdUUg3JGsOlUGSx5LA6N5ngtbkNRaFBDrbUs/GzC9DeqUNAWj8L6WY96TCieGpv5/ux
	LL9jHHaHHjr11ZM3LnPvabMOe29+MG5tbPIoDcK84MvbByQl7XI7l77RMtk3Ds1m5L8MHjrb5z1
	mvc1k2LHmZMfaa8/T8sFLfo7XOD0EeD+BKFrYBnbomfJ8/WPRwA==
X-Google-Smtp-Source: AGHT+IF5uSZFkd92taI4AFZxuPXGqPv0vhx+0DNW9NrjZaWgfPJ++05mIEV+P/lyyp+2PlV1EUb0qQ==
X-Received: by 2002:a05:6000:2dc3:b0:3f7:b7ac:f3d2 with SMTP id ffacd0b85a97d-425671ab145mr8359436f8f.43.1759761965933;
        Mon, 06 Oct 2025 07:46:05 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8ab8b0sm21242624f8f.18.2025.10.06.07.46.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Oct 2025 07:46:05 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	richard.weiyang@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v2 1/3] mm/khugepaged: optimize PTE scanning with if-else-if-else-if chain
Date: Mon,  6 Oct 2025 22:43:36 +0800
Message-ID: <20251006144338.96519-2-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251006144338.96519-1-lance.yang@linux.dev>
References: <20251006144338.96519-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 8ikudskkzznkzrt8pqwzdxhh5dajz3e9
X-Rspam-User: 
X-Rspamd-Queue-Id: A522240011
X-HE-Tag: 1759761967-79161
X-HE-Meta: U2FsdGVkX18zd5YarBcXBY/vR1SHS1vn7lXA3BraNMRI0tZZSlQmTN0P/bMUYdvhg8rfrd/dhcNSJqkeyhZYyZSG9InWIm0duIDgH5jc+2fwHsrh4Cdh6wHmpiBv66niyXM8uUuY6Lv8nEWlEgTm+eUX0+MRl49zePyUKTPNm3YMePlHgWORCo+095JildVdTZPgjsKm6Aotgr+dC73yYm163CiZrGHvgSbFfea3BCMEHYDmcII6ilcF/g9RVlliERjS4oUv1IZ/WMsGzhwn93IAdslQC0BOs3/vhmraPz4ZC5nYjhBU8XVmjgXW3B+LcEp2eLpHGzdwXwVVDWUjXA1aYUSZJqBwmw3S0Cogzie7X9WsWKVUyycPf7/hNjAotooAaTYt0z/asroUhOx6MwXmaDjIi1nufXcdFM4uQkD5nMePOCZdlrxEcIlVdelgzGedrzBWVBuUokXS1dwIn78Ngshb0wDqd0hCVNSBbi5G2rtEVqDSXEZrLtuASKBjpoxxCJemkZ7UDlblMd6sKHr2DC+qkUPZ/82aHPWcL1aIZizM4kaDw6vRWuutkIzfEPFIp8vxgP8cuPUT00tm3G9OE3nCObj9vG0xbuBRkd8f74YaIDIgW5tagk+aFRK0MvJWAijLeux4fP+2EOyRur55SqBoR8g5G6QJEnmC7qbidnNpJk/NZJaXCBvNrTo9KrVRU6LC3wMzTvbJOBTrE54e9gUX3CRP7byXndV4N1oi9sCptp4F+1zEFCzPBgxSiKimjIJ5u0UI+6yb4+/lK//+7747UiT07yb/XZr5GdzVTnAsW0sV7oTthCqpWC4PoUJUddtQT10epk1CcBCwyK1l+6c+AB6p+IzPe7nYnTPNGOvqXI0NujKLbuxJPiZpWPzHsMGNe6NPGRtRCijP+uwqte7MxLES+SkovDVUuaxkS/7cMD9/NoZ9xlMvSuxlGbhG/iPO2PBA20h9i50
 4z0Jdy9T
 zfwv/Y924/FodphdPHtvGekKfnMYkTha901ZJcyyTQsratha7RuBcN9GemoaOqj/dUnsYPjG46kbRXWjnTyai0XAY4mlPDK0MKTQUpahkTzOgV1b8P+/s8vOKx/tXEzXuqh+mu77+qj4kTVf0ieb6UxWjlvbLSYyLuo81X/fkfE7DpvyC5Z4kaK1N7roaIc2HyvPdx2Q3G02im/LNilaJH5OMd2rThU9vHAr4sYrjdvpCDw5MOYvb1A5VM8olkdlnXaT4+woUxmgYIW2aAZS+P2/17k1DPo6I/qtleSvTMzQ5ohl3rOAo1UThstt6Ad6hNGWtZkf47kuUk0gu8Y1b3ZQUSqAlfIfwQup1l2/RV0gXeaKO0C27vGIsMGTUGlQnm5HdOWL/t6Y36vbMjMwwVnlrvnWqjWDAveXpPA+4Om+wVMMZ4Pne5Rv1xTjQmQPh/Hl7X9BworBx754u19kTKWr5yrfJzuvR2JRkmS5ilr1XchibpYPwWdlbRfQHkp1o4V4Sr+c9cJrUOpr5X0tN6iwjGYqsQlVm8KJbbfamZqII4CeBRJP8yyWePcBGEyw/fVQBEm0VmlfC9B90SDBfyHmR6Se9Q3Pvq8LXbAaF9ND6z5sDfo/8D29v2StZ9DYVl4h7/7/34Ew2feMXwjmXKEda0S6RIOKHsIGbUSauAS+sUaY3FDH2u/ePWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

As pointed out by Dev, the PTE checks for disjoint conditions in the
scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
and pte_uffd_wp are mutually exclusive.

This patch refactors the loops in both __collapse_huge_page_isolate() and
hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
instead of separate if blocks. While at it, the redundant pte_present()
check before is_zero_pfn() is also removed.

Also, this is a preparatory step to make it easier to merge the
almost-duplicated scanning logic in these two functions, as suggested
by David.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/khugepaged.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f4f57ba69d72..808523f92c7b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -548,8 +548,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (pte_none(pteval) || (pte_present(pteval) &&
-				is_zero_pfn(pte_pfn(pteval)))) {
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
@@ -560,12 +559,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
 				goto out;
 			}
-		}
-		if (!pte_present(pteval)) {
+		} else if (!pte_present(pteval)) {
 			result = SCAN_PTE_NON_PRESENT;
 			goto out;
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			result = SCAN_PTE_UFFD_WP;
 			goto out;
 		}
@@ -1316,8 +1313,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				goto out_unmap;
 			}
-		}
-		if (pte_uffd_wp(pteval)) {
+		} else if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
 			 * PTEs are armed with uffd write protection.
-- 
2.49.0


