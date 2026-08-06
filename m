Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65F2C5AC7A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6E646B0096; Thu,  6 Aug 2026 18:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46206B0098; Thu,  6 Aug 2026 18:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A357A6B0099; Thu,  6 Aug 2026 18:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63A716B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:57:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C08FD1A05DA
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:46 +0000 (UTC)
X-FDA: 85072358532.10.1F31B6B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 34FD540004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:57:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=bD8PqeYy;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786057064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BtNeIIgUixsl8uOBsAzvqupdbY7xnj71en9gJPKtw0=;
	b=Orl+7mHxlL04ODwkjyuPPAlsZwvz1p3L6Xf9x51kKSgupaFhUXJdepiUVqJ4s0LI9TeMQc
	dEGH6DRHRIHG5iO36C2sENA+GTaWDmE7LDNR6ZaYMoGfDnTanAoy0E/wR/TBPO2gFEqQHL
	NJoMH7XmTLAipoFX+6NdJ1FjCIznYg8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=bD8PqeYy;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786057064;
	b=qTRTB8ByqqzXQyfpd9DbHuAv/9BD/vBghrLapOCT+Ml+o9ZbrDO5pdZWEDRavkzcstmZt5
	QcC4sZSlmTGX6XbXR9BOzsrZrG9TwC2bgYHobXSbcBLUswEFCrYporhr59A0jJ7ZeozeGC
	j7l7kNXjwH6ysYEgkm11DWXnEznDoUY=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Mc8VA3887561
	for <linux-mm@kvack.org>; Thu, 6 Aug 2026 18:57:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=+BtN
	eIIgUixsl8uOBsAzvqupdbY7xnj71en9gJPKtw0=; b=bD8PqeYylzEeXGydh/+l
	msgQ/toa/SeeX5brb3jszJBSON4O4SpZ1OnEl2NsNdYi8nubMf8NeL3u4AtAgel7
	0bKmlEsZp0TSh9DLgU0JcK0hzH+zDGLvwe/PyxgJLgQrGGZj7s0Ms9x2oXyt263z
	QRdP5Cq5gvYGNoYSaDfoWHdE+A2TcTJKsVk5rGzAQz8XTprom5/Zq6QRIDrMKJ8W
	xqhcN/r0FwI3zre8srpOd+bao18A5BcpcUDEDlqZAgrObcrP6lfhKmf3ygvUINMC
	nXXBhkGjHZHZ2gIQq2fmIVtRGJ228xVKN4Fo0YWjwDrhXT5qQudvTyfggC4LtPJX
	hQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fvy2xj18m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 06 Aug 2026 18:57:42 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52ce3c7cb2eso41233001cf.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 15:57:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786057062; x=1786661862;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+BtNeIIgUixsl8uOBsAzvqupdbY7xnj71en9gJPKtw0=;
        b=ZnpgADPW0CxzqNZuN79taII7OLlY5e/hj069Embw1xOujzv55gm2yzSm1lL/tduCHo
         vgdnj7yOVh5YS6ovAUtcQTPJ6PiJsnnztM21fhg0Ats/vw3Y6FV2d5EXb8CL4zEWgLLW
         BofPctRwiZ7cKgjnMIGMMUX/kgOZ6sQPZ96QzLxxwHvo+LIUqW0HpPAUX3TMgKCwy/qW
         ZTwkJY+gqB4oqDp5vDxNBkWcwkpjxngcLAuHtHYYpC7m7ZCU9PKsb1vMZaclktxtq5E/
         bdOTT7QiMhau0fd2Hp7LYRkLfgN7Iizvo1DAJyeKU/XfWDPfBFwY+P44jzUkKN5WUPJq
         gbtg==
X-Gm-Message-State: AOJu0YzpmKveeOLbRzTIB6oZwRtawlRNl05B580TIN/GZ9LnfijXLjAt
	CrIh6QrhpVNYk5ewbsG567h4uPhNFBL7GgTukg/CGdsypDJN+C94n9GAmuUg0lri3/lvzXUD3MO
	zu+Mg662JkxtEafGeamqYmcVLl0zUouuz1MLVHmIzSTfOWLGk
X-Gm-Gg: AR+sD12gieo7wnPdo772lkYgNk+BLJcMQokEZrnsMBCnkvWJgolqpAFQs5O448gnXIl
	uPPX4uppwWS7bVt1GcvlHeueaRPGcq7eEf6fOKBP3EZRTofSGS4Xt+mor8761ybAL6ap/roFyJT
	+ittCEVKV1eci+ZiEOOjFZ4Sxe4xCx3aFsfbDKl8UTI7zZHE1U8hxDW5Tc48cgKOym8vTHDXmBs
	9JWVnCHduSzk44NcFpaPM5oaJyXS5V5Z98XBAPH32P/FG23GGTC85kncs/X+mwo3tHlrjM3ItLQ
	XPcKCitlKZsBYDEgq1Jxtk/gjNm9eMcmP0Kg/HDRENz+dvr/JH1igAUnFfWwD96VW8uF/tmnsWh
	UkSadBCk5k5WG
X-Received: by 2002:ac8:5d53:0:b0:526:d595:c7fa with SMTP id d75a77b69052e-52d0b21b43amr56213091cf.31.1786057061771;
        Thu, 06 Aug 2026 15:57:41 -0700 (PDT)
X-Received: by 2002:ac8:5d53:0:b0:526:d595:c7fa with SMTP id d75a77b69052e-52d0b21b43amr56212861cf.31.1786057061387;
        Thu, 06 Aug 2026 15:57:41 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.78.43])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm8751344f8f.33.2026.08.06.15.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 15:57:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 06 Aug 2026 18:55:35 -0400
Subject: [PATCH 3/6] mm/page_io: use swap entries directly in zeromap
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-page_io-folios-v1-3-0899bac3b826@columbia.edu>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
In-Reply-To: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786057045; l=1819;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=sJKkFgQDnw4D+7fvAxACkB8gllBi2zXD16xuRSf5TpA=;
 b=Z5eVKtKpEu1msICJUvHhk2JVpPnjNPEGPZt57+DcEU4eZ4aX7BlwsiyIQJYbee8h7x4KicOS8
 eCBeTzh3AA3DUcKXER89FNnkFhP89hv7n47RmkN5VeHZkgWD5d4g6lV
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfXz3J68VfkUZWR
 OfL2GpR666n6QDlGZ9queX69EHAUc1t/POYjeqOL4K12yLlPOaB3z+aOZUhcgLfEzRbpJs4YV7d
 6iqZL4zTLGPYAUpXHG94DVKyqbF+LyeLXRTBI/S9ArO7TJdSF2L62r8SDkJUdYbyedPOl4ZWi8B
 KRo9Phc8RkuVMCs4DWB9HaLYvBD6IeJ1FAFgt2NoX96X4wlRVqrv6JDi7CU71Phk192iNYI+gQs
 iQakVxKQjd5NoZRWDGlqrnPJN7HXuxnJCSuYIbA+wpGSWM2Ruw964wbohlc2ZzpkRsCPKk+nV74
 Rywm8xS0f+W+tqJTQTg4fH0sib8fZEq5YKMWwThhBnYO8aYzlDjNGpACe2n4An8lqfJ6ESwFLus
 gwNObKU53l4QlSrsUzMVr0DJIkYCoJXeVkPzrXwBjzxfR6tKfInZCA3Hvk32H+6mxAKrLKzVcGo
 F/41z/o5hVgDYe13e/A==
X-Proofpoint-ORIG-GUID: ywv1GBxesfRLi2OwpmIpH17yUJuKR9t4
X-Authority-Analysis: v=2.4 cv=bP8m5v+Z c=1 sm=1 tr=0 ts=6a751166 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=z9N5oyD7lR4RENIpbqURcg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=HViwNVsgdNRDn9LUnL8A:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: ywv1GBxesfRLi2OwpmIpH17yUJuKR9t4
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE4MCBTYWx0ZWRfX6sOI/z2rAN+F
 rN+SbgMzdSCTpgef7GDZEP1+d9Eesizu/NEAo/7lK7cqfBz6DA7iZDczsAM6bZpjn2cCfTBDGpA
 rCmpi+qiXu59ivB6nkDklO0JromC1MyrorANHMWww2c/pkSjp+jT
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11867
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 bulkscore=10 impostorscore=10 spamscore=0 lowpriorityscore=10 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060180
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 34FD540004
X-Stat-Signature: zmmamguiedgqcz5q96xucm8oyrpa7zir
X-Rspam-User: 
X-HE-Tag: 1786057063-908602
X-HE-Meta: U2FsdGVkX19ocyQAUbdC7kODznnKQPmM8HpRK2n34W97aaRuLMfBXfH7XnjqQGK5cCrNKDhB4b1BAGcglNzypQeMAZ4EGwWuu/4NPQepyC0ZHplj38fAGYBcGX60uPCF/c5AT9AOJU7PbV1peV29cJAvuLTQmLwt5AfBVQ6e53GlpAc7lz0Tw1PHmtrldraJqS4Uiq+Zk5zfXppM5wPwqyUXjtlyDyOyVyFUeZkG3n+fy+CcZqbfdnah/nyit5xSw3P2bquxOPaX1jXfTmwD2B6a/ApLXBEgJL/PP9CDy9fQAXVbVXEizcQmo90G6VqSB2yNtIsAqVIa9EtMVMR5dC5TgZsCDvu4n7XAGZpc+F3QTk8epfqaaq4krcy2XIvCE66Z6tTjRk5cfaOO9/G+dGQPRwweZ+JOcSQRHfkvd95zyfiV8vJMQ5sBfFClC82KhSn2NMbxYaVLH4XYtPijkKrj2LF24oTgfYmcpqZONCHBvhLKYPoCl3jKjn8PIeOF5zbKg4b/D1ppPKHaiA45N+1BKFNYK6Tmj8VhUP8/iH2qnDOT0Rapr9J+tVYZqb2XvBFsGblp+GXOrX1ux05U+zYKss6ngZbid1WSKUK8C1aBHFn7S+jZNeE+YYhDeQe29l7/HCBZWAnmw2mwOrsNE3ilUv5h+CP6rVVR1iRddG0t54KX/FcOnmAzYr/C14ExJy0CnuFX4pJZE31RGT1zOw9Zk7i6ALRdRNgV5G7igy9mYpgDWw82edHyaJdcngBctEcrzOog1x8SBKqw1PCkwlwV22w7ZR3tfIyU6pVQIwVnBATqkcnicKNp3vFSUki4WKbPZN+DF7F5UaV+H/jeoHv5vF7DEykFYLrdpv4phBfn22w3T3LuNUh0N9OnKQ8Ae90qYlBPsjnHm+bfrgms0BN8670XRNjTsT/9E9cl3IbhSP6e5QI7hGRG3kmIqa0OA301ggJ36SSNPxoS6nV
 E1J19imv
 NwuKZkLnfEjRhelpPXP9ZIizqNm/C0Dhl/+OKHD9b4pTnbQWiWg6Cfr9Eh67zG3IMjnyfURWX9b3WBOyrVoLdw2cuzliI25MumO+BCTntp9+BI3aLmwL6IfeLS30aFJXHLjaLZGBoOo3K15Q+N0Md+s8hGRG9agXpu92eXGMe3txeuxJFnCUIerr7VRdZUwOvcXtFpPiroSCGUuibB3ZPuJjQK162UGqcrkekuizuz5UWlZPIp+BBvMZf9Nd4BPlIMGYyEoqTWyJprNxga0ITJP5wgmxOGymVF5Q9ll3KE+IHsUmjR1OHAKEJ7kzeUTAWqHq6lPRilpV0v9b7TmbpXG/b7IPEcviZ233lPxUsofzKa+fBnfAATSyh6X3K2VxVDfKYOmQ/J2UUX78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Increment swp_entry_t::val directly instead of recomputing each entry
with page_swap_entry(). This removes the last struct page usage in
page_io.c and saves one call to compound_head() per page.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 43b4383a4729..c6d0949b3f1e 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -159,7 +159,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 	struct obj_cgroup *objcg = get_obj_cgroup_from_folio(folio);
 	int nr_pages = folio_nr_pages(folio);
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -167,8 +167,8 @@ static void swap_zeromap_folio_set(struct folio *folio)
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_set_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 
@@ -182,7 +182,7 @@ static void swap_zeromap_folio_set(struct folio *folio)
 static void swap_zeromap_folio_clear(struct folio *folio)
 {
 	struct swap_cluster_info *ci;
-	swp_entry_t entry;
+	swp_entry_t entry = folio->swap;
 	unsigned int i;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -190,8 +190,8 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 
 	ci = swap_cluster_get_and_lock(folio);
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		entry = page_swap_entry(folio_page(folio, i));
 		__swap_table_clear_zero(ci, swp_cluster_offset(entry));
+		entry.val++;
 	}
 	swap_cluster_unlock(ci);
 }

-- 
2.39.5


