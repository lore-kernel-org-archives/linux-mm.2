Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE7DCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D791C6B0005; Tue, 12 May 2026 16:46:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D29D86B008A; Tue, 12 May 2026 16:46:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C184D6B008C; Tue, 12 May 2026 16:46:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B16A26B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:46:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66EB31C13A3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:46:13 +0000 (UTC)
X-FDA: 84759950226.07.ECEC40D
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 777C720005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:46:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Pk8dx9tV;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778618771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oYr1O3U6/SXVN5rudFYRAdAuWOpaLoIuDsz1B8w0T78=;
	b=NkH2+qgZsEUPERqUaa7rLqHbbhRVq0EM4Hp8MFRXO7ySIb4WtxPhuI37WTYtILD/mB/d+u
	bhis39y8L3KGevaQm2d0kItZZv7RZNTOCwLKRZQF0k/ELsYSiHM6YK/8Hej+Tj2u5AOwKc
	nq47mouDD6FavwExi087FFys8NTC2UA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778618771; a=rsa-sha256;
	cv=none;
	b=PvJADnr9tauLB7zWRYvLwHcwJIT6WmBbmUbQ/plvpPjlX6LrRpycEIrp6wZMqoIyFoN7zz
	ym99uo60ASJZSnHUFaS2gkkNO+1PoQecZ/Y24PqgtADLhDNa5EVNUWno80S1sl/UMojwli
	sD96qzD0MWM7uscIs1kDEY7pYB5/Yt8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Pk8dx9tV;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64CKjxcS095296
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=oYr1O3U6/SXVN5rudFYRAdAuWO
	paLoIuDsz1B8w0T78=; b=Pk8dx9tVmrD/akIDvKQ1+od69ZPWbp3kgH5UZcm6nz
	8tt6kga349LKljWsRoDFOPUMZp8jsrqL5zhzGk/SgbfOxe5//Ls7qLRKRYtF36Ow
	VsnkmR1ffrTr5lZ8FsMfQYE7FfPs5nnadc2qCXneVS+fNnELtpVga5jrXnDfYQCm
	DeLPqMVXJyrXh5BvKN3d48KanEWTlMKhm3aXspXKyGPJGyLRxdY3rd+F4WFvB8VS
	mjPYCUxGELPw2o3bYD2Zbe2amGp6q2IKEwFYXOVJSjiIHH+EsSWGjI8KByMPpNc9
	a1dXV0G+ywH5aXAIMpGrzTASAP5snIzHnNCfUD7dtWfA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e46fs316a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:46:08 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8eaaf673eb4so1297614085a.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:46:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778618768; x=1779223568;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYr1O3U6/SXVN5rudFYRAdAuWOpaLoIuDsz1B8w0T78=;
        b=szq3OoK1opHTEEFGScwLdjx4Ds+CFCS+P2j4Ul6dOAcIHKPI1ubwR0S1i7hHitvlON
         fzn7sMPl8vV0X3v5ZNdormrDYKk5CaX15gwd1LJGmLQFt63c8QgvU5iEziqJNPRozoDM
         uJoDf78y2mVKyInOl5IRv+3TT5oUTpBqNXB2b6HZVxVXR6bOEqmZxPt/G0gsfPsu8C82
         T2lCkxZvjKUSFSQErvmPcS/W68sgaWbB1khM6iU4y01TI9RkLR70xCNxSRbmxeQbx9XW
         aNv14x314+pmEMX3iaw3f9XrsjRp+GIKMutASi+QLrcQrb460qIV9gwLfsGkiBewOrRX
         Tn+Q==
X-Forwarded-Encrypted: i=1; AFNElJ9qeIZUi+TYszcb2u6FrBUhmVv9YX5WdKVByXUjKgcxij5gQl3f8JQ1SEUlicdmfcKyKi9O53i85g==@kvack.org
X-Gm-Message-State: AOJu0Yx31T0mk/JtoPqaufsI0Os+0k/VofcjyFp/9f0D2iUugZkWQdA7
	XJCEVLAWz6gI4QYPVB0eTi3BY/bypNzPmtGfmdkpHPbAWViwZR1TNvAF6NVL+hGGSZIupMRdbfI
	AOu/R0IEaxUR3mB2OZAUJ+mAaMx4Oa7O96IkxZU5FJd+E7pkZ
X-Gm-Gg: Acq92OFBOwyIqHUMY8xXzyIYxmeMtDJF1JvkMkc6j6xqThdJptrQ8k1SVtztE32yDBg
	kQGs7khCkLRGCP8BOW8R1EVnwEN3kWw4eVSxvNRgf9ma0RAPTeoyllrzEuDI72N5wdefL4Acg62
	JDMvw2kClSl6K9y3QbbP9pxDc0vyy8nYnuVtxjsxzZkgVPBwwdlk47a4Ascljwif5zkW2AbbMi+
	bM/JeN66LZuUi1tUENcU0jwAIoLB5QhE9n4GpG5Q/VRPRXckbyp5U17CUcgruZai5GBJQM3ZS9Q
	3weok0c0AbHPswOEFB1Z3MnsYiTFqAMEdFdIDbnU7vKLHx7jxl/bavqj/f0wx4dXJZUajc3kQ2A
	g4o+0jLxaxKR8+wVkXfIsAMBR3XTPnKpaZ7UDW/2qnkjJdNFDimeVPVliV0GCtD1KeEY=
X-Received: by 2002:a05:620a:2a0b:b0:90e:5b62:ea07 with SMTP id af79cd13be357-90f8b2d998dmr99074085a.56.1778618767935;
        Tue, 12 May 2026 13:46:07 -0700 (PDT)
X-Received: by 2002:a05:620a:2a0b:b0:90e:5b62:ea07 with SMTP id af79cd13be357-90f8b2d998dmr99068485a.56.1778618767456;
        Tue, 12 May 2026 13:46:07 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-90ccb338844sm374224485a.22.2026.05.12.13.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 13:46:06 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 12 May 2026 16:45:59 -0400
Subject: [PATCH v2] mm/filemap: fix page_cache_prev_miss() when no hole is
 found
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260512-prev_miss_fix-v2-1-4af8e5c1ae62@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAIaRA2oC/3WMTQ6CMBBGr0JmbU2npWJceQ9DSFuKTCJgWmk0p
 Hd3ZO/yfT9vgxQihQSXaoMYMiVaZgZ1qMCPdr4HQT0zKKlO0qAUT151E6XUDfQWg3danutGoUb
 gD7cc775byzxSei3xs+sz/tJ/powCRWOMc6g01sZe/fJYJ0f2GPoV2lLKF0C55NWtAAAA
X-Change-ID: 20260510-prev_miss_fix-fcb308472131
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vishal Moola <vishal.moola@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778618766; l=3136;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=EKfXg3Kedd/2DkHbNXwGJTPidd7Pkdr/1XwXuXKdOsY=;
 b=XtPXuvkoCm1dLlbLMYm8YnPBn5FHXiqvrKn66Ff+O/0gAOrwSIpFbZ4yjNJznwjCnTf+2djQV
 pdORZT40uA/CCnyUGfFOCNYhfjqQxp4soMcu2D6CbBB5SZVlZnkmFn8
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: v_SXX-BW0WQtC3AeMPrpSLYymMJw2a_m
X-Proofpoint-GUID: v_SXX-BW0WQtC3AeMPrpSLYymMJw2a_m
X-Authority-Analysis: v=2.4 cv=GcMnWwXL c=1 sm=1 tr=0 ts=6a039191 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=MarPr37N4K3uxDc3k44A:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDIxMiBTYWx0ZWRfX+kyHYJDmE/Ix
 vlDYKDj73qsHM+Fsb+mdpgkLZnlvMqAnCTt+qWrK+iMGNUpR48kFUGGUiMXbaU6kvLUXMlhYrWW
 jCw7V1MCWMdvrGT+w+Q9yM+ZVy1Kk77xas4ixXWCLLhbebzp6bW+8LNjpUu0z8HrS5VEEuxM/yM
 0SHNlBtYBGP6vshuO8bM1toq2sRVgQaGjtOifL6oogUgPTaIHbZE9LqOAy9634vrCMHLL2Wj5/M
 vp+PADW4Pc/Ytr/phlh1eXOz/z9O3zjIXqS4wKvvHTK1PYQpVgw2udVopgA2p6jp39jFfcuvl8x
 dFfS70IRaJagl9S9jM90lemD7FxuJkWYF2WosZMVKzlFUL4k++Pdp2Uzdrep16mGcV5sjCPYZMU
 /Heqpq+hlVJWC7s29Z0x31QoxlCWA4Ih8O/B19atE3agDDUdSFpTmb+G2jXYHaHSJiv3Bbql/MN
 fP+Og2JbbWx9inoYCFA==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11784
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 impostorscore=10 priorityscore=1501 adultscore=0
 suspectscore=0 phishscore=0 bulkscore=10 lowpriorityscore=10 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605050000 definitions=main-2605120212
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 777C720005
X-Stat-Signature: 1wrj65etmswdqq6qup1e693nod4t4eiu
X-Rspam-User: 
X-HE-Tag: 1778618770-223871
X-HE-Meta: U2FsdGVkX18K3t8nLVKBDigeBMJfdnUd/PlZgyKFD1JKfhUrWup+vFoKf4baq54SV+uC61iSBQnNLWNaqeGiNoyJlfUHIP42N7IhqP8WbhHXPHTK3bP3yz/1eD2FzO2NH2cmIRg1y/TPm/+lK8zuaKUdTPvyGfezjBQIFSDNxifawh/7+6z4RfWl0QbyM8EeEOxUnsJaPb4lJC/tN9r3dOQT4c3gA4DFeqIcnHKhyZpI607NuU8t9xUr7g6ES1mZcqKwte8f5CtR4RKFSImjWLTlQOhrFG0RQZz5lkhY+UTJ04qEwr0GAk++Hq0PM/vQWCTt0hB2LTWrQ2nhvYUaP4sWXq4DaAElKf3DeiRCMZ8iOrrvA66/INX7EG/IPO7Z6ZjDio6qDjHJqpCblmK8FMeliBwzI5SlNboxLMpFUUjcBxjjLW1G+ifxV/p2Q5gi8nQpYT+5ZSTBv/GobZvM3PigCT3POCwlHvanxYbYQorrytkZqt62/y470dV0QTJrhrnaQH1E9CXkhrhmmoLKZ2ogwmPQ4E6sW5yrhgyFehDJb/UnzWfTzi+Bc8ctIyIj7SV2nZSM3ofgDawbQA9OHZIfbjN6gztDiiFCtaOaHv7OQf9JnTKuJMHXB26+BeybUoMSbyTkH+PHyYuHrs3/VWs91wmtDZWAiKIrEXYZZIiA/1Iyx50/1jW4VbJOOqkK+7zf9GS/muFq4ki/QLNpmkcO5kLto/AVG5OpBlJzYy41vHw6KJ36lpqZrwL51GLpSwGKQx/qC76nRun1B0yQuZBVH3dJU9K39/XJkCVHRy89V8dgk8NLQDioRDRC7WSKJcDPuqboyHUMPcS2tLgOfDSJUcfBARYpqeRBo6HMHnR77NPAs1bFSJ21ocM4rz/1LrlVJbpSlHNpT4bIpJ5kE4ipXV634PpGjRUCCHKX+KoKBhjTVycJKHrbQFLQoTeQ+uxXOBfYEZsnK1VUbcq
 nuTavF8l
 YrOsdm9xwdcHch6qeUdpdjYnOphayrOUtaDv/ttdmhxa2dmrlufTwyhoBd866EkdltoXd+6F0mmMDd9LjQHjmHJ7kv2aYb3PwHd7IlXh/jbpyzUVNwKZKEzBOtQAGf4/eBUOAmJDQWlVIc+SkiKhqzQkaFT6gUUj5Bumr1L4crvLVaMtY1kkpRkSOjhkjcgZfoRuCslu0Mtyu8Z50i2Mqbdz1ZD3VL7e85DY6aHAqmU8ury1R0ZtZrmXs/ipqvAMF3GJwJMp83HomZN92rv89reTz+/2RYz9dyz3KYks4VgJMmTQzmtOM+jgRVCJ1RtD6eWLqp1Icb4q9bfT7fsFDafFM25J8tmT9mz7drNT7bTSC4sd0Rm5WLzz8WrzM/94RU7m0pXG6RzqnSsGIUpT4/kobh5xwu8sWBWJ+sTMPVEQUID2V3gO0LJM0qtZqWlDtgc79tIfahkUFj/3o6nFSRbI9zOPquXpaYtaopr0cUSizVx/4dq2fff27AWmWLgOdyQgE2fDesAjmzR7h1OSusWjz6r0OPkxG2B+BafO8nMh9Gh4ocvp+aNuB+Nx6xcn+N8R4o+u/cjHFStc=
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

Fix this by returning the start of the range - 1 when no hole is found.
Update page_cache_next_miss() for clarity as well.

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
Changes in v2:
- Change return value for clarity, per Vishal and Jan.
- Update page_cache_next_miss() for consistency and get rid of nr variable.
- Link to v1: https://lore.kernel.org/r/20260510-prev_miss_fix-v1-1-755bb123145a@columbia.edu
---
 mm/filemap.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ab34cab2416a..4263d9775998 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1808,9 +1808,8 @@ pgoff_t page_cache_next_miss(struct address_space *mapping,
 			     pgoff_t index, unsigned long max_scan)
 {
 	XA_STATE(xas, &mapping->i_pages, index);
-	unsigned long nr = max_scan;
 
-	while (nr--) {
+	while (max_scan--) {
 		void *entry = xas_next(&xas);
 		if (!entry || xa_is_value(entry))
 			return xas.xa_index;
@@ -1818,7 +1817,8 @@ pgoff_t page_cache_next_miss(struct address_space *mapping,
 			return 0;
 	}
 
-	return index + max_scan;
+	/* Return end of the range + 1 when no hole is found */
+	return xas.xa_index + 1;
 }
 EXPORT_SYMBOL(page_cache_next_miss);
 
@@ -1849,12 +1849,13 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
 	while (max_scan--) {
 		void *entry = xas_prev(&xas);
 		if (!entry || xa_is_value(entry))
-			break;
+			return xas.xa_index;
 		if (xas.xa_index == ULONG_MAX)
-			break;
+			return ULONG_MAX;
 	}
 
-	return xas.xa_index;
+	/* Return start of the range - 1 when no hole is found */
+	return xas.xa_index - 1;
 }
 EXPORT_SYMBOL(page_cache_prev_miss);
 

---
base-commit: e9dd96806dbc2d50a66770b6a86962bd5d601153
change-id: 20260510-prev_miss_fix-fcb308472131

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


