Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12736C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6006B009E; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D2E6B009F; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C656B00A1; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86AF76B009E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:34:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E80D21A021C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:34:02 +0000 (UTC)
X-FDA: 85157575524.09.374858E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F349140008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:34:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IXoUJkw9;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=qmAN9YE2;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086040;
	b=MIpq0x6uXMMQuedRuXJJIfxIyqC+0Y12t7riuHBKBnUp/uKwXKYgfM4tVVG73Qmv2qs2jf
	jWOnIQzACdbwh31jbdBMetDs6EaXc6sBBWSFmi3xsG7WX5Y9QMyX0CHnMulmWKcAXpoIHz
	xx/tRsScDiPUXqD14WjT/3SEXcvjIIo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IXoUJkw9;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=qmAN9YE2;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4LuS1cAhpHN/002NExYW8l/WUkJ7AVF4N4va/1EdeIs=;
	b=Ot5qW82UAYTp1VekgDqgX8NQQCYn7Qt64k6U+NnU6o9tFqLT7HW8OISIrvfqcD+5m8rHxs
	R8YkoIu/6+oEH224xuwrpTQhDPc3A2IygoiRWUUdiQHaqEMvBHGnGcJ2OznRonz8ecLSf/
	czk565GZUnoe1sldSY/UvyGo8LJNqX8=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9xdUh3703560
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=4LuS
	1cAhpHN/002NExYW8l/WUkJ7AVF4N4va/1EdeIs=; b=IXoUJkw96fCN/XyjcqpD
	491pbwuYBSKoPTLPSK88jTx3wDc5f/avjj6UkJfc2RY+eAXpwwyQuVm/CNMHtJdt
	I3SGbEttZPJWlVAnQWpY8RBO1G/772+Ed/ktdidamMf2U2YuNV3v0kbAutlecFIu
	yV8AtPLAInDKxKKEMzKIOOeDNBNK7ebrtoPtSTWSYh4POq4ZQLtWI41ynENlkyQ7
	dMv3OQiPLdifw0uCkTh3pu3fjZHNkKI0nHzp+Nola8S3JI3V6OUphApb6lrpoNyu
	o6WA83hKxfObfo6DkAA0GfmTq6W87hHfksB9szLRudRNySij2TovNephxdQ9gyAc
	fQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gcgdtg995-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:59 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52d827597fbso27427991cf.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086039; x=1788690839; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4LuS1cAhpHN/002NExYW8l/WUkJ7AVF4N4va/1EdeIs=;
        b=qmAN9YE2UVm91+lbYKFNw/2K0a9+zTheim7rnVwV8Pq2kpSANythbGjrkV39E3YPKW
         LXndLuOkv7nNWWEpVCMwaHk2dxrQc1QbUmhU2njChZOdAaty6pPDFboTFWBhzpIsq/At
         aSnSmUYnPQJKT9j3tDkHdkloKpX/bPKbeZmJsmGY6B7BS8oKKJqPJpiH4B8////U/fsw
         trWv9O8G7Wg4cJPKIFwmKEXgqm9NA6v0n0vYtMQ5o8BVvXJRhMc8LV9oBf/Oqt3cgVoN
         e6BH6cbRjQM7VNLgLAIq38uHFcs7gS+zh8L0DnzcTK+pNMLVSdwqsUr5+5omK1t6etjl
         X/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086039; x=1788690839;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4LuS1cAhpHN/002NExYW8l/WUkJ7AVF4N4va/1EdeIs=;
        b=qy87iM+ZqqVFeEFww5XTOrmOT4h2lQ0CubI/6XhpARW26jOPCwGaEIqHa4MgrVYaVn
         mSG9IWQzbA4kkGbtVm78c2Crotxcpn871FcFkGlO4LHt9WQVlkCiVQWTK8VEYSBAGtD3
         RoxM5MWJg5szcFKeEpfad3a37pOT8ANd1Q/Muk8vuTUT74E8HzhEU9enPaFjHFH88sxG
         +V1754GNsf3ULAKjvJGLMMl+WnatMn2FurdoJED3s1FfKRqXyJltDE1vqCTM5YLyVzES
         lGi6R7sDlg+oD9hbXBGd4fG8yZgkGuu44pOFnKJxZCmlGdRTa9h+y45vQbcmGdZP4oW9
         Gqgw==
X-Gm-Message-State: AFuF++maAQj1LankPzgC4/UO/obdSFZPHVyFPgQjw2nOYPJK2AvyMxC4
	go7d3KCazYmH/bpHaUJQWcj/eb43CitR7eqSPCnuLANcH5m3vbG4Q02rdeGC/tOfIx/ZL32hq7X
	SZH/wp2UEn7xa6YLstg6VmGS/0sf0mS3HUDZ04O8MLt3wQXvQ
X-Gm-Gg: AR+sD11EfWyVaBObR9iNe73ZAcnj0pw+EGgMEo4meV2hWgpFg1Gl+NPcRwbdgPlOfpG
	u+xCqIFuwiheRetvi9RUdo0lApNKeYfQDo9lQa8IONZomKvxlQRHGk6O5FhIEpmZcwWmEdxfR6i
	/xA5YhydEXjWbq/9Wa11qVykXu31V0TaZFlmd6Bccse3vR6S8HWlrByBQfJA97fU1NUhS+kg8TW
	aEelawR7G13aPX7qmQAZp0P2RRXGY6TTC/EpL0WONae7HRKBVlhgCl1RDcDq6MM4j6d/tib+vHi
	HcYaoqYY+wDBguQF74TjgntG6LkapOl0685lwZF7sK1HVp5bSEx3EupR193BkMrQRtwUyp+r02F
	mVM9/t9c84XR5TymQWoyOj1HWGyfwLE+3CfmHgqaTRw==
X-Received: by 2002:a05:622a:1f95:b0:52d:ea18:a9c with SMTP id d75a77b69052e-52fb96ae584mr248428321cf.34.1788086039175;
        Sun, 30 Aug 2026 03:33:59 -0700 (PDT)
X-Received: by 2002:a05:622a:1f95:b0:52d:ea18:a9c with SMTP id d75a77b69052e-52fb96ae584mr248427871cf.34.1788086038722;
        Sun, 30 Aug 2026 03:33:58 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:57 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:30 -0400
Subject: [PATCH 8/8] mm/swap: remove page_swap_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-8-7786b52acbc8@columbia.edu>
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=860;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=I6pqPB1rjj1dnKeDegsZzTB+MKdm/VicYFt2MhO9II4=;
 b=c1jy1sFkrBpeZiQjHJklG3Cc9bw220ASIOw8htXuLhr6GFpKtinuTg02ps2C0CsMWWqMiNTgv
 qRxm8iGyx/jCCuJf20TtrXph9N7ANFUH4+EmKzwECevAXN+hQ/31BDF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX//OsaBfWAmd6
 lRPHTDnsn33aczrM+/I/E3zzOQYTXZQ5lfUrLG3Hj7iMkdI2Sp0/7nlE5LG8h4c0cN3K7lArCwp
 EJwQE71nHPqQk9f4BAvHQiR41w7YwglHdbTQI1zh7/1+MMLHUxw3y9NKN38mH7MKfwkoOiUy7f6
 4G5Hhtjc///e7n4Zx7NWu5zTLff11Rf3m6czruoAIaePELPyPnNHgmAwsa7QR6Fmub+dkxsbWxV
 q2xrebfcpF8V6VBWJG3Dr6K77J4ATdyUu9yz9E8NMYBir98QErTembydgqTHTKDRxqGYqkZHV+B
 +/P2hbUw1hGK+RG7tLz9raT1yy3qccCRUR1m5CWvhcllu7S36LuO+pVjSrZwg7enCQcoUDYWF/s
 z5aSw7clDOwYCiJkBpx84S+MlHQLYv6xUEBl+0zlwDCnZj8owm+AsEkmRrdaZGfDWyMebZZMfdo
 46mkV/bd4wQbQo+C3rA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX/FvjrQqUGpou
 4aTEZCOAnUAJeh7F4vrKBR3BUXdSyrQSsbLsfsN0b2KkVav0LPBpTxzys8CJiNLIF64P7xZSz4B
 ntblkpUpM44PVFGXYuIGX/A0B8nTEuEXmKO3AUFffH/eF/IgNFZZ
X-Proofpoint-GUID: 5bCnHr1CUw9Ad0tgrnfYfX09gjXisGrS
X-Authority-Analysis: v=2.4 cv=ZKXnX37b c=1 sm=1 tr=0 ts=6a940717 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=t2YXVXqu3yB8mPBWm3YA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: 5bCnHr1CUw9Ad0tgrnfYfX09gjXisGrS
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=10 priorityscore=1501 malwarescore=0
 suspectscore=0 clxscore=1015 phishscore=0 lowpriorityscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608300088
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F349140008
X-Stat-Signature: 7be5fqqggdzxnmcjm55xh3jx69sez5ap
X-HE-Tag: 1788086040-158763
X-HE-Meta: U2FsdGVkX1/zSCDQ2MfzU6+DTuMFUkFutwagqiJvF+0Op4DjdXEb0qSEF8798h8WWmc4SoQSDeDkXXPfSNDhMadtdUAj9qr9kePeIp+CEw4Vt1wXhBcVRenr7cU2B2taHHq9JJ1WI4SLf5hzOo7dq3ACpHJFwbK+8epQhRy1xbqLAhbdUaO4cs+nn7XcNy/u+TfSAmP9/vDKLEaCbRfU1p5QupQbSh4aJdlkj+sq+FdiyKzRV6uDZW8ZekWFdSS7OzIGz0mea3nsTj5UCzO6vjEPEH4CM5blNHAUrK0rCWm6x+nnB76ERRLkmppCmH1cmB2Bz4Yi96ueXVvMmMzTL6KNcpmDAidgES7314D4R3FzMpqRHZaS6WKuF2Kg+UYWnSUEDSIBRZWqOvWOr4HcM1dZpAwvQWJAbV3ovY+ZcWJCFb5dW+ixEsIS86pqV+EfvX7DPTdsIOoXrhdlf18y9vdZGoFR6hXyHEqlPzw3joTA5iNbsk4eVC1yz7zOEhSNRi6vjgOOVlSLzCR7at0Wt4znDKxLO9PYKXuMpkoAd+8kH4dpKVy4qXkP5cbYSWaG1YftDIZrMFdBnsTKJrWqi7Xg3mfSHDswtH3GmzJEVbRQtGKdggYlACD9Sp4NrUAhwvYxk23qOmCJG8VZcZXuJFU5rIge43SxVbnB6g8tZ4yWgxCL+91b2/H2NbDJGc8Kzy2DENnBAMIrQIlxMe/aKKxnaShSofjEaFBBobjQpGqdPJvtiTspJ/SB8OFGhlKq6IWb7UboXTOUNhZ04z7TuvVudMBj2+PjkKarR3YQjD64h3wxQxlPR3BI8y72OqEuzezLJWuRSFApaIkUuLWUXdqcg1SdrabvhjUpeRvs4xqIfuI+AE2c9Itfw6A4i9fXVz/ZD4CsjICet8Q90JL/mSZE2ohccACpsE0cS/kYitvdFWq8Fyqru6G8PzTwY9RR02ae+FNg0Z7/aHmH1g/
 ucDi/33e
 FlLfFYgjmsDi9gh3i+hyP+o3BSpwbF90j69OLqSFjCKVdatkNwCg/xuVW7V64jcM2pziyslfS4O5yjSQyT3ghdJs2plmVABxt0MBsnRTeewdfYuHvBFMI9EfOKnIJf/eVTA3wox9bkU803LIWvQkXdz/tnmdGsqoUGmyE19ed2HbYdQKvr5wBKcyLImoN4tvtzv5NVv7WnI0keW6NmYLYOqO5mWzMcYZh6KajFQDgcF1D6xhy72cNUD3ZcYwn7KIK1q1tD4wpyxoGy0aGh47aFRuMN5ENsdyzabc7zyslFw7/2rdSlUa0tBWUxXn7bWs0AJFetzq7iYJBq+HyFSTU51XgRp/QXSWihJacnKCQs/odJzSZrSEqk+uYfF5jqK9uzd6vZHu9fVTdZid28tNm3fI6w4d740VZj6iX85LFSF31IX4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers have been converted to folio_swap_entry() and
folio_page_swap_entry(), so remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 48632aacbc2a..2fa436958fdb 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -311,15 +311,6 @@ static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
 	return folio_swap_entry(folio, folio_page_idx(folio, page));
 }
 
-static inline swp_entry_t page_swap_entry(struct page *page)
-{
-	struct folio *folio = page_folio(page);
-	swp_entry_t entry = folio->swap;
-
-	entry.val += folio_page_idx(folio, page);
-	return entry;
-}
-
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 

-- 
2.39.5


