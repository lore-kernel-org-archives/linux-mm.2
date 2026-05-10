Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3FDCD37B2
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 21:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8F06B0088; Sun, 10 May 2026 17:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA056B008A; Sun, 10 May 2026 17:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB5D6B008C; Sun, 10 May 2026 17:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC6CE6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 17:56:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D355A048D
	for <linux-mm@kvack.org>; Sun, 10 May 2026 21:56:50 +0000 (UTC)
X-FDA: 84752870580.27.4AC543E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5769E80003
	for <linux-mm@kvack.org>; Sun, 10 May 2026 21:56:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fAaUJTUb;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778450208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jKIH04EBx4jQOhPZmlThKGkQBfxOj/8qm7n8vOuVizM=;
	b=56nJ59YFQXsBzyyFsHosd8JjWCvSa+nk2tafk7hnU+2cPPPLvTWw8jABxUBU4u9QG8mUmY
	pIN9ijAz+M59TMPLkhiDhj3zj3FDqsfzXknQOPwyj4GKMXeLIe6zy5cTqi975Eego1Brig
	Zj0KhxQLSeG6DdYBwtKvEE8bTSQM2yo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=fAaUJTUb;
	spf=pass (imf02.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778450208; a=rsa-sha256;
	cv=none;
	b=1AW7CmfgNwD9LZKfLt3Szhjo+uLq3F0mGOjgyLdKZfgCA+LTGPPVPfSzb/JgAbSgQFulbo
	CLsx90XlxVjkQC8PGm3Q5oxdQLsSMhsmEMlPBPaRU7OjpwDJCCiMiM922I5acd084MM/pl
	JUkcat1np3HOtV0u6O5mtAM6FPKOzn0=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64AHZ50C1132603
	for <linux-mm@kvack.org>; Sun, 10 May 2026 17:56:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=jKIH04EBx4jQOhPZmlThKGkQBf
	xOj/8qm7n8vOuVizM=; b=fAaUJTUbaDBW2iznlyx6Vm8sXgjlJH5i+JAkG3UUOm
	Qz0ypTsyTuKuf6/PPsuWLbBVbN7LAiM8sAfJESDCWRX3iNPVhlcxbNpsMQi9VPUS
	7MzCUrnUN51R1k7I99YgSNOGiCc4whpEycBAVe67iADCnpQTPRs73YXMyaAu+NzW
	lU0Z456X1YjzBhMK19LYkSNNvzY/jMNpPNyXk4Ex8EUTs+kuzbGcjZ/K1t/pcwwg
	7f/W1p8/iNluGOZZmgwZPRRgA/4JtLU7zTbygEAdoZ1U/+4LLyMdAYzEcx2pbMjG
	j6CK33PhfrcQ6tNNVHltK92PfxKWVFTxDfuEEFNAxzCg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e2xhq0t1v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 10 May 2026 17:56:45 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50fbc70cfbdso88699441cf.2
        for <linux-mm@kvack.org>; Sun, 10 May 2026 14:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778450204; x=1779055004;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKIH04EBx4jQOhPZmlThKGkQBfxOj/8qm7n8vOuVizM=;
        b=VYHtwA0BVVSFScDGuQ9C1/1+y8gvMK8dbjWbMIqHS9MklD3vZyA+QV4A1k/R7vI0b3
         uiJPYA1DksRLbOY61BrId6QcNDCQG1C/BXkfGvySKNiqoSPrkCFMQRcuYSzhdc738a3x
         gibIjcNQXESrSNayxpTwlqQYZX8KT70G4rkI/rKxjWvFrL/X1QjyNEHzaRVVPfTIwRSe
         k/8CfjkbOXtYAPpUPFvaw805UmKrkoJ9PcCe/KOjqOQGNhkyMK7nFL84Y2UccTGfFdBu
         9I/YFu5jj753MTeUFq7AMLIQ7pUj9W1tiMNPFsVed/Je2p60429mpTILy1lf14Zh+CAV
         9UfA==
X-Forwarded-Encrypted: i=1; AFNElJ/LLWnMo1ac2ZE1zuzNNjmHNKW+KDDo+MAX/dKEfJ8R/NeR39UvzCKdFSG9l9hpLjq3BkBT4a3fQA==@kvack.org
X-Gm-Message-State: AOJu0YxPOwp2YQou69SG2vmA5dMj5CB7mfrq3sjSxPyHXAT1P/m9NhTQ
	GrS9ngXAiy+WQeioDBaLXxaQX6CVPWZreQA8egYdlNhssrEIT+iwWin0Pt0EygOINAlfTSUHmk2
	tmgl2SLvXFkJ77u8qXUNdI5PBkGEfBe7wLQq+QdvmR4p/7ihBdCTvQRdL
X-Gm-Gg: Acq92OETQBwFOITmsygi98lpL764BK3N+pC2mmZ/dA7Bqitzo8RyJP5qq8pkNwYkSOu
	xKPdi+WJHHvnpL49buFI/9SKvD7CohnbOfgqC4PUQvwbKpHpCh444osUBOU60v5V7ceAtkWfZeF
	bOiHTeoY7Iqxfw5ZosKQgdwX9opNHWyijlDzgJpBpcPKSFcjbijA4Bf0BkrKS4ITzhRxhQx/emq
	bRRkHIJX4cXcEp62oSl38jeUqpqFesL+Wy0RlTTsqutS9MhC+BtrDZ0vBSlODNiT6I2r9UgY9Ym
	n4Qq2wx8W3ZcYUCZlbfMiuwyYJD/Os5As2XBFKcTX1bYY6+CZPId8WJjmagUOkAFXEofD28WGAR
	lfihzlRbieAk4VlFS/ZxCp4gKMQrVa34meelm60gf0XK83clxF1nb6IQZHazmEqU4TRI=
X-Received: by 2002:a05:622a:4a05:b0:50f:b2e4:ebb with SMTP id d75a77b69052e-51461be0195mr329587121cf.10.1778450204580;
        Sun, 10 May 2026 14:56:44 -0700 (PDT)
X-Received: by 2002:a05:622a:4a05:b0:50f:b2e4:ebb with SMTP id d75a77b69052e-51461be0195mr329586971cf.10.1778450204171;
        Sun, 10 May 2026 14:56:44 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e7bf34asm77435591cf.14.2026.05.10.14.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 14:56:43 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 10 May 2026 17:54:17 -0400
Subject: [PATCH] mm/filemap: fix page_cache_prev_miss() when no hole is
 found
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAIj+AGoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0MD3QKgqvjczOLi+LTMCt205CRjAwsTcyNDY0MloB6gLFAYbF50bG0
 tAH0Y+thfAAAA
X-Change-ID: 20260510-prev_miss_fix-fcb308472131
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778450203; l=2462;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=YxgrvZR3kH+gqOp0C/o4cUtDxnd5s1ZrRJGL8qXBbYc=;
 b=zuLTzWpUjYMr/4//I6PYJbD7PvfLdjx3DXr5QmAfuqXINNrNXe1pK9UaYL5e09CsQeAr98oBT
 sokA9lNXDL3AdYSyKB6hATmOVyudprxle0XPxjA/aDJ3KX0zzWQEK3g
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEwMDI0MCBTYWx0ZWRfX87XlsBkdltGC
 3zewm7JJXVFX5SyJt5Slc69mqh81M428q0XCthhgyMUq15Hy+q//KfPY5vIgwK1lA7p0UIJnS4D
 Sdfa6WeXFKH3SqtoNKwxObucRfp3Y3YZY0COZcTIgWSzkbq0wzxOg+yyhUUYPn1qtRcpugVJ3kT
 7GaZyJaZABu7MVt32D0fOJKgZBPCiaGqnxt897ym7psDkufVLSWiT6TaUrL59ezKZBDYkjUbr5v
 FUANzR4vSIodq/9v3ZQ0yfrliRS93sJd3U5T4YM50CLeG5W0jedsNNnGAW0fY2Q/cAzAmqab1L3
 blgpCzBmc1eOMIKhHigAOw7rKXeqlDMl+mCQxG4oWOwYgyozOZi1I3xxwFF0LDq72FMHiN8f6gl
 GhNDgVwbBsw4S/JhS/Wl3NDGAjTly+yKrmVv2gjdqM3cJpralV1nsZDg23zc5pyKVFP3eY8+1Of
 0uesEBCLGnnsOJWTBFw==
X-Proofpoint-GUID: ngpve6DVsuCU78JmrHM4nKAkDmcMgOa6
X-Proofpoint-ORIG-GUID: ngpve6DVsuCU78JmrHM4nKAkDmcMgOa6
X-Authority-Analysis: v=2.4 cv=QoZuG1yd c=1 sm=1 tr=0 ts=6a00ff1d cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=ILz1Z2p9l7wduT6Ju-UA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11782
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=10 clxscore=1015 bulkscore=10 phishscore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605100240
X-Rspam-User: 
X-Rspamd-Queue-Id: 5769E80003
X-Rspamd-Server: rspam06
X-Stat-Signature: ezfo5p4de9a3gnegeotdwcg359q4t6dt
X-HE-Tag: 1778450207-164917
X-HE-Meta: U2FsdGVkX1/QLBJB4kEr1OdHSBBw6FjYQiNDaS216X78GUBDulVlMCGZIIyhyGTQezJIu9FZX6vogHv4We8Ec7oh/rtnA8X61tJnDhAG9mT9gTh5jspKHLptQhvh1ErT4ZOwECdNoz/RncOlESxsZ8MpVy6pUeT+Lq6sXHM2tbWd6WGzPIvRmej0EOQU6LZ6lCLX2zX0Nd2D2DxnKwiPs2O1kTMORU6nsyQz2vH8dFX1G5D7nQ+a4lCOEgmH34lBXOUti95J8JFw4rXT2wSyrqulYUXzvwSxjSmKfRYDpAF3iiNHQAurp2k8RCZhKlS5yNREHqUiRjruw7t+n/cX7B+TLI3wjuW9ebL/0IyPpNpru5K4B8wh9URmf0EduDpSKWKp4i1XLnC09vz1EagekB3NYYxPWgAmGCo0BrqBFeXXyPb8N/3uK/N0r5sbekIAD1l6pwEZfHw03+ifYBWmm64ZXwrXk/L7N8pjf1I4VbjDYZ+utiibnZsfM5gmVNhnSybzMf2mob6VQiOFJIr6mynT6eLu/vliufGc9gyk7O+H9AmG1KUaBGJ1fngsn4JDPHC5THwad0L893TDa1HfUz7FEl/AHao0c0wb94nOM+4ro8QDlWOMIhk8jVKkVvdWLgOxbJa/gwjUteiv/fIkkiULahWeeSGVuBtfxfB7EnhmzvYzVJ3zbMxG0jkdB89SIf0qTBkxWz6AD0Nl1GboKsgrnR94aioGFDEhLfZcG1uThuavdVIE1Bqk07tvZKwXcTyev6q54bx4+mVRc9U7kaAoJ02+sCvD03rqeFNZUmx6nq3Wtt8qMTcHso7yTsVkGG+ImNA4gtP7dl6U6cBFoalb3h1C7V9e+2rToytjdrAFRNcZqID//XQWdUpIqbLtDzQgBF2tcckqXG2YM8eh4ev+JJdYEnCG5yWFYKF2NXZZnlg76wWtyhhJFXZC21lAzBmliTNYCdPbjWGoyKW
 YAp2uwMj
 /di5Alq/N6rdSRtzfHa3KAbGHgJlIzK5+rFV7ijy8OuIlGKs0VUFd/5AnhOXQ4vKvUd1YRrrVX26eqfXGwbnqHppxi3n+kADs8vzprNcu9nny3yQm+ymCGFVTg9JIzjVLr8rVCGH3/aExP06pInI9n4zx/Nlm4GAz7IjigimNOHkRRlP7KBu8ilr1xePogiWpI+aPT5GJEJ2V2q7GcdQpEwX4/1bJD01bd1L8JpNAxWUEwB2UliF0zq/FhPS4/zhAzYzLETtrXdJyCRlIvOErwb/IPsjQiCdFTWS4e5fdScde3p24hx0HOfs9cQ95od99p2uqE/txpFTSMkcdaSuIu4slYENTplJUkcfwZBFRrLEBBtDX7UVPHGYDEnhQIEqBWSb3eQb5JI78uD/48w85dHyOcPrWD+TV6/VKzwUKgpTcS6y2ORNldnmbkgol3tuyrQ47lAcXySYV/ONREDb6vLOUa9J4C+jADKeU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_cache_prev_miss() is documented to return a value outside the
searched range when no gap is found. However, the no-gap-found path
returns xas.xa_index, which after a successful loop is the first index
in the range. As such, that index is misreported as a gap.

The sole caller, page_cache_sync_ra(), uses the return value to estimate
the cached run preceding a sequential read. In some cases, the buggy
return value can undercount the contiguous range by one, shrinking the
readahead window or pushing borderline requests into the
small-random-read branch.

Mirror the fix in commit bbcaee20e03e ("readahead: fix return value of
page_cache_next_miss() when no hole is found"): preserve max_scan in a
separate variable across the loop and return `index - max_scan` from the
no-gap-found path.

Both helpers were previously fixed together in commit 9425c591e06a
("page cache: fix page_cache_next/prev_miss off by one"), but the fix
was reverted because it caused a hugetlb performance regression. hugetlb
no longer uses these functions and next_miss was subsequently refixed
in commit 901a269ff3d5 ("filemap: fix page_cache_next_miss() when no
hole found") and commit bbcaee20e03e ("readahead: fix return value of
page_cache_next_miss() when no hole is found"), but prev_miss was not
addressed.

This was found by pointing Claude Opus 4.7 at mm/filemap.c.

Fixes: 0d3f92966629 ("page cache: Convert hole search to XArray")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/filemap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ab34cab2416a..545ccd59777d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1845,16 +1845,17 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
+	unsigned long nr = max_scan;
 
-	while (max_scan--) {
+	while (nr--) {
 		void *entry = xas_prev(&xas);
 		if (!entry || xa_is_value(entry))
-			break;
+			return xas.xa_index;
 		if (xas.xa_index == ULONG_MAX)
-			break;
+			return ULONG_MAX;
 	}
 
-	return xas.xa_index;
+	return index - max_scan;
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 

---
base-commit: e9dd96806dbc2d50a66770b6a86962bd5d601153
change-id: 20260510-prev_miss_fix-fcb308472131

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


