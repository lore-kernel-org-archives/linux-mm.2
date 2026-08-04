Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3FC7C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E597A6B00DD; Tue,  4 Aug 2026 14:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30C36B00E0; Tue,  4 Aug 2026 14:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1686B00E3; Tue,  4 Aug 2026 14:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4B066B00DD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:52:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E1DBC015F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:37 +0000 (UTC)
X-FDA: 85064483154.16.BC74D18
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id BE3B9140010
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:52:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Ltf+xSeG;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785869554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0np+Mh4g6FbtGTotF1tdHYY92zqeAhsY3aQwW/2FAQ4=;
	b=z1TE6nv8n5s4kg9sb08b7VbKFfDuts4xFhzaQRSaefFkBUijbknH8vwuK0y2nEIhCtP8/P
	LCn6j43Hl187sssE08OIVzpsbXiFb9Tr4Sm+G/1W862QeT5iGf19AAh1CIykWv57RJ0X9I
	oa5v489v+rdaHrQfJI9Jr/ZUK/EVDCE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Ltf+xSeG;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785869554;
	b=rnl3UEkg0JN3fhLCERkpjazdmRw6oAwsxPb9RwaWBMesB/snUdEtfUVIN94CK7nGUa5aC9
	OtFhdESsEhQStBmOrtCTiv+5HEtviEUgYrN4k5rH/Qvvowd1sSkw9q19T+nP/5WFMDNmeC
	DlUmFmTfEacRSlS61WX2KJ6vZNFpV5U=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674IY8pd2119045
	for <linux-mm@kvack.org>; Tue, 4 Aug 2026 14:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0np+
	Mh4g6FbtGTotF1tdHYY92zqeAhsY3aQwW/2FAQ4=; b=Ltf+xSeGzv0AQkYnla7e
	HMlda09qU+ceQAezbuwSwfpQ+s98hfRrxCrojTw200tDHO0KPJWtipa+mOndoYa2
	0faFNVbhALn0z4heQK6KRc5vqT+Zw91vYGijd+tQ/ZVzSziPHadAUv6hDXtU/i/L
	ynUN9BIQu2IK1g6uWXu4Mw7IZZ8V+TVEcfQWsxChodpUetUwIq3LZnyfE3QsqIFG
	vJgQe4bLMhOxd1rU5LOMm87Bc4ADLQATL+mW4RUie+BXWiilIjbe7wLzh9I5LX83
	evGCAdsnquSjRtxOwQG8Sj711pJ9EjNLgEJAZm/YC6jjB5BEeffKc1Rd2FDNTbTN
	ZA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4fugvdjp7s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 04 Aug 2026 14:52:33 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52ce64c41efso1579861cf.3
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 11:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785869553; x=1786474353;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0np+Mh4g6FbtGTotF1tdHYY92zqeAhsY3aQwW/2FAQ4=;
        b=MqLC/6Z+Wbzv5wX5AbHj6gWSy3xAdZuOLQ8N2DOrpOwbUFbC4RSlRStq24rB3qBzDz
         m5g8N+Ow8ZdbDXDFWXKRV9CXBzuGt+vPrk16dYMMEJ8I6MaXyVhk6+lZO/SPKkESkKU1
         0Y0LLnsIgiVgZ4xLX54mbXwLbjSr3SPknfDJM1u+VX1Dv0iRVFFMUWUoiYW6HOTdRbsd
         4u+kOqtRCQzsQTO0sE+aeDKU8h4SHqJdXVyd/2qcB/ktPmk+PXW0RwwiU7jfN+9gS3hl
         EdrMfmZSdfXTTfUjFTFSZSNas2kNEtf+346WeSAYwHkeSZuh3VEdN84Cm0Lm6HbTh8Yx
         Yi/A==
X-Forwarded-Encrypted: i=1; AHgh+RprN/oy9KF7HTBGjyxWTk/yMoJstP4V30GfC0ONM+5xravG+No3mlPSo5RnkF8pqllNBlWFF61F/Q==@kvack.org
X-Gm-Message-State: AOJu0YxOqUd7BGBjqJZsfE8nT7oG8xPqR2NKuv3o4PGh+B/tm4Dzd8Bv
	NDHxioXMP0sm2GlXndNsihOuFuYGutRY7WnqDl2UA0z/zh247mPyrSTahxnRBUfMVt01PoY+TC3
	EYTV62/L9eyZBy4OUl199Jb8RbZKlqVDo88+pVw+bnLsr6+yxMF57RB8k
X-Gm-Gg: AR+sD10VIF8T/g7CFuZaF94IlWZduKpZH/TmLzSeFLJvwNqdN7CPY8o4tkyLpyYCVLd
	TbozDoMLGOtTKJGMnf1+//BI6M+nb4RoGH13wQ4TYEhVUJ+tHcCXahtN5s4f59bPUtWsaEXYk8u
	PHhjlHoNDUNxRvzCB2LiudlzmED3i1WhAHObR2DCmu/kXH7FWORfbWWcZM1v9bgkN+HeelmGfZH
	EUusLr1etwA/Z6B6xx8q1uK5FJqvXEBPSJyvOZUrPy8WW8s+KTErh0La5DBBXSEchB2O4PPkRi0
	93Av9Kvjosu2+Wy7Qxpz4SGmFOHiLlsRx8uVFONkCBmtB6MWKh9s1298AwJ5nF4drC8NppON6Qo
	EO+ahkCUM
X-Received: by 2002:a05:622a:2615:b0:51b:fb82:67d1 with SMTP id d75a77b69052e-52ce6112cd9mr13729491cf.20.1785869553257;
        Tue, 04 Aug 2026 11:52:33 -0700 (PDT)
X-Received: by 2002:a05:622a:2615:b0:51b:fb82:67d1 with SMTP id d75a77b69052e-52ce6112cd9mr13728971cf.20.1785869552803;
        Tue, 04 Aug 2026 11:52:32 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fec232d7fsm2313275f8f.20.2026.08.04.11.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:52:32 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 04 Aug 2026 14:52:11 -0400
Subject: [PATCH v2 03/10] mm: remove wait_on_page_writeback()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-remove-wait-on-page-writeback-v2-3-81f0ab065284@columbia.edu>
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785869541; l=1451;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=6dxbAtDCmrnDYkfOuWrS6UKuWVd+lmgUjReNrbBmSH4=;
 b=ZZvU1M4pLXeTAriOtmeOSI0mHfXaaquENtCXvCsHWefyUHy7xTa8qlvMhdOavhouCXtH/NY/9
 QkGdKcRbTsJBwgWtf4Ig/DUGBu4bGeMxHWQm7D+6O8sOhgz7BM0DOKW
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX0L3u2NAhtvm2
 giUj0kmSmg4uNAb7FdaBRAOrlU8TICZ21/nwo/25aGECvfEc9elN2n+WWrlIuWFE0uJXG2mmzEF
 FrFLMrrcfCMLCMvYQzLBkWthVY70CoQz92+68WluSYK0/V5oZx9x
X-Authority-Analysis: v=2.4 cv=G5Ys1dk5 c=1 sm=1 tr=0 ts=6a7234f1 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=j1J1DEHOHTVaJYOjuVnKiw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=qBqFc3eaEPVjc8k8qNUA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: VcNa5EQLH2G76ENIwlQza4Isa77iQcoP
X-Proofpoint-GUID: VcNa5EQLH2G76ENIwlQza4Isa77iQcoP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1MiBTYWx0ZWRfX9LCuLF5h/t+s
 UYjM5pzWqp0PhRN62HFNYs3PYmkMq29xoD2XhRxw5zsCg6FdHuKd/I9PKoMaEfHJQBBtkUPHbJP
 202reZh9nSJUIQe+0MJGyx+BPxmgveakcoiJP2n2mKUO7N826as8z7oeByEUOvpmMHGn3hrSPLX
 zccUDmgRRkNLt4rF8tGheMB53sJCudbKQi3drcsiLOldZ4hiwehYfOvQi5VHpiDsWdTgln1Ey9c
 n6TZpmDgSDKSMjdTP182KZHzz/ieLO3/N34N6ZweCB3D0XqxYgCNRTNZh7uSFw8x303RZf+8caG
 BSDFKiZhjIGyfI+1NEbFl9m8yWWH2bFZ2koxYPQcvZdFIXTv83q7fk8pKsKckpSX7ImvEyWWq7T
 cY9Y3y2NjAZsi6SeqP7mYti9JBtZ++a7tZ2tEgcn1RP3J9pRDvWEqt05+BL0rxjvUzMda3nF1BQ
 I5FnB8DAjQDrlMdHG6Q==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11865
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 spamscore=0 lowpriorityscore=10 bulkscore=10 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040152
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BE3B9140010
X-Stat-Signature: 97w3ejjzfpjdo8qgtgicnwsi5i7imjct
X-Rspam-User: 
X-HE-Tag: 1785869554-605426
X-HE-Meta: U2FsdGVkX187qXLWbds7pXOcIDBSvIpjhJ4lVRfCQRYjOeItsAGzrNBecPpWu/+11UOlh750mfK3Ek2E85YSe+wH0T7NbNvXzid750gMmhyaexgJyLtH6urKRZ63hzDPaBmyU5GucDXdEDediayGV1/vtLBR8Yla7/ZAV+dLtrgOBCP27DOvsylymMf9zPp58Pa9jDq/Nyrn0KdhaFhqREXD59aFSrNYsrUY44g+X6xSIMu8srGIgCw73OQ59zD5xWTeOeEaHMdV96Dhd3xJzXkQ91M0lzjtgYtkvAsZJ3qQ3hIGp+HEgpmpczTzh6ePR0LJMmlNy1TNIxlFyE7tBTUKKxMxBEA0xQLZ122NAxP2YTIK4nTd15KYyFnAeArwofB51idgEAbEwSsKlxN8MYQo3jwymN2NzUq0t/HZKhOFIPVulw0YIUh7C6hEv71/mbwNkAqhsu8OfUThBWSoZqUfskCWnT/kpOycDflvJ4dIgY/KOS7wl8g2zL/DgboPBnMBjx+C5IUcQjMgQ2klWLL4QpPvjpue/Hhzm1msQS1b4W7LKgb0x/x8k36y979eGJOOE7+RhWHOGR1tk+WRlWrSm6XBiE36GRTmsI7qA2m2Y1Jxg7xRlvMEUyXBxM0lo5K39m3cqRrRIHdD1wJy2clGimdhfuXs6Xw8Ym9B1USTeKtf558akCnZKhs/BEL8bG3cwYoWC/leZeIUvO1xpTQigIz39G0bEWN2BpV6bMZvo9eGh4//aES+YaYBd1kymXKooMIzFxDSQZI2hXW5px/9iYdwvupqOPNLxYzRFbfHc4Vek5+rMLM6yLnlUmR8k2u+lw1rFXQKMcp2vVyai7HlsXh3QpyjcHEZO+2jJ14+aSwFxhjG4Z8AEWpy8GHaw1uBSRlS5gr7UF5zpVqK7mafS9fjMa1XWWZQRRbB90/jpu5BjryxBSMr3x2T7AzwldEVI3ZZCI2Ycx8OUKP
 th7ST5eH
 tQCDrQIP3U3hg6kl9ypOwOmd7gFj7Ty83oNU0C7WG4Qf+7ftWPPpFfvcgDDdcdY1Bm3flXQJ8+Ogb4x3eHzsA+QfZH4EBVxUQ32NdsgVHtKN8YQ2Cs8jzffst5ysADU2xqOoE/YpBlyhFSS3ycakMDWkj/YfqP93o0q8gWeF+ri1+GMYMadYAy1gYgX4sULb6Ojt83ygLj9jyxEQueQ2Q+WMkRTbCgtv/aopGDVR+Ghryl5ZPeU71/dtcGVy+4Of4X1xhHEy11fGTT1Kzo995w+bfb743KHHjQKIFawuekfInjmURnlPfbyvN1lUn31o/iTaEdF0eUn+YumuAoLB+HeL5oCHHDUt7zGYxzv2DH9eUnFpxpXNGtY1/psDiwVhPuNe1zXe0fT7AdYsxzh+C8KXfPr8HMeBMe/mRLErN81T2IyrB5RdutwqbI+N09GYfJamuE5ErxyShIkn8Pmk01timBJevihXYqMDx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last caller was converted to folio_wait_writeback(), so drop the
wait_on_page_writeback() compatibility wrapper and its declaration.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 1 -
 mm/folio-compat.c       | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..3748dde2b97e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1240,7 +1240,6 @@ static inline int folio_wait_locked_killable(struct folio *folio)
 }
 
 void folio_end_read(struct folio *folio, bool success);
-void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index a02179a0bded..ae0271591d37 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -23,12 +23,6 @@ void end_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(end_page_writeback);
 
-void wait_on_page_writeback(struct page *page)
-{
-	return folio_wait_writeback(page_folio(page));
-}
-EXPORT_SYMBOL_GPL(wait_on_page_writeback);
-
 void mark_page_accessed(struct page *page)
 {
 	folio_mark_accessed(page_folio(page));

-- 
2.39.5


