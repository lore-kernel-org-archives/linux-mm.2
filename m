Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EDEAC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 19:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F43E6B008A; Tue,  1 Sep 2026 15:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5196B008C; Tue,  1 Sep 2026 15:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAEA96B0092; Tue,  1 Sep 2026 15:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC6BF6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:38:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1703B1204DA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:38:25 +0000 (UTC)
X-FDA: 85166204970.02.7A4B16E
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 815B2A0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:38:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=II7G0btz;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VWL7Ju8S;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788291502;
	b=jaYBS292RgfEghpCtJWP9QYIkYkKpx3q/vyBO0od1SMdLd5UmFNAwiB6IXvkdODfGmGgkw
	14HPkH0Iine/4LZl56X4WSKvpgeTm8KnKkkZVpqaHR5V7GlWlcAjGMCfSoXJqOp2L/Ctcs
	IufBOlak+U5W98CKA61FRkQ1px34aS0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=II7G0btz;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=VWL7Ju8S;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788291502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inu9Y2OY7s1kFVSsMrfPa+VL6lXN/UgSbvSwwsaLivc=;
	b=QnIl5D56C1eK38+Jkq0MQ7xcW+mAp7El8/XRuijOpB4g6CWwK8jnAs7/GRRViHw2xdbs9M
	86OKgd42mKe6M9KRt+oL3egrCPczYlgevTC02blYGT8OfkVtSGjWV+6TQqDtrWviRdxWkG
	V2DmwCgDCVUX1ylUIK+wic/456EA5M8=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681IggSa1211470
	for <linux-mm@kvack.org>; Tue, 1 Sep 2026 15:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=inu9
	Y2OY7s1kFVSsMrfPa+VL6lXN/UgSbvSwwsaLivc=; b=II7G0btztj+CpLnk77+n
	ioxS4+EDLgHCmVHwD+hsnxy8aqgBZoBcYxfNxglHYy8Q2ShqKfX2RanfDr3Iuoom
	FFdyVrAnaee4EwRMSElDKdhRTNrzZui/0OZsSY9Ef2Y5l7vb+6N+uwgx9OOzwNmy
	/Qb+lVDPA7dQDevYq1LTfv+SPx49T7aCvhv8cQk+i4nvXXmDci2eXABybcrghWvx
	ervSlgeLglP8QGUhmbOToRHAMKRBJxGEDKDTcZ42Vlgv7073EITgKM/x2QbSYl5r
	lFuxnlZyDv/niFScvSSnGinA23XgcOOqc+A2/qDgfmIigWQ86beUOBy3cRTxF+tV
	gQ==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ge0643e0g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 01 Sep 2026 15:38:21 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90e853561c5so3704726d6.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 12:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788291500; x=1788896300; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=inu9Y2OY7s1kFVSsMrfPa+VL6lXN/UgSbvSwwsaLivc=;
        b=VWL7Ju8SWUQ+poAq1pvAbXglx0puJ5I2Exrb9El18J07ZpABzdOC8xNDRK7tmRmrsM
         xDg8BLTVCaZbmoeOX5NvTMWHangDh8uwGbsxly7ZCf9tM9K2YiT0krO3mH9vahe72aM5
         eEsxK3iMTpNfExZcL0RLIPbG2p3dfp4vtQSGEvFRdVZuRSm5MnVVl2gSAw3Bmy/X2l1e
         td34GJQIjr7cRhN63t1FhBmkLMJQyG8sCktLwq4xYA56+3QP84lXtr+fBRBKELSDU051
         lz+DdZLkQTwi6vd2GmcqXW1568AAoMbo155Z19iSTLOhweWopM2Mrjpq8R78YKhlmz9k
         3S1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788291500; x=1788896300;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=inu9Y2OY7s1kFVSsMrfPa+VL6lXN/UgSbvSwwsaLivc=;
        b=kgwyk+SovnlMlyJJtWqzA/TuSS8Wjtuge0IT8WsXIkKqBVGxcaNsY+8G2JZQQO/6rW
         hW0idl7NwBvCBzyh9DlZDFfvfMLpQJghGEGgS1jbfGsYUCCGfacdxw7dbn+XkiZDfPH6
         YR7DrkNHw9jkxOVM7rJghaxIs6yVp5AX883VP8xtme4zNrEZeBsUiEEkJ15O7dPoMAyz
         ToP6XrnckduI8h/edUFWg+8SXmGdNbXiotVYbQIFGTWNHsdUlkuZScVPpzxKXocTaPd+
         EcamIsFcIzreabfjHiy+34Tj5UeGEmf42X0FGzS0SJmEOSGlCUVNo+oGqQ+KLYowExd+
         w33g==
X-Gm-Message-State: AFuF++k4Z2GvWwIhtnNQa875DJsf2JCZUBkMp6719pD1QJz3oGON3irc
	4x43QWjAbGallBkbFputA7aS2nmAN2qvoDsLq8EU2lA1Lpw6DewRlAzwlgeJKMVjfdH3i/9hAR0
	ZxCc28e/W5YmqS0pKaItofuCKkvQLR6QD7TD4jflGGm1V48F7NhhXZv2iyOQ=
X-Gm-Gg: AR+sD11GcujkyS0KHLKE68FsSuKvKapOObfOfq/TLygOS95iLOSPHwO2FbH2G7EGgIo
	TJTLV9iE4rTywCD9M9I+5Yca+81YFbBwhUcAlEIHsSqPsSBCPnSY7YuTvUxGoWk5BPXXmVZDhEI
	Iiz0E+FHpVxUexyGRcGILE7tUyelZea1BCFjiXIvEeYKn+3P9QoH3Hu4VvuhFXm6/4qbD1YtTif
	UskCUF03aZn2MXXATt685Ls/pYKpH1t4jfFYcLrVs1o3wwW7kiAyBNoGewiUow72hzbMFjevmLB
	1UYTVEPY5zrzX7r7/2fqvVyYJmYCRRTez8miVM5f/RNglYxcbXADck3YPTEh6YlZ7FsEnGjdw1j
	g1QeVcZwMEoApaFUIIbu56DPSM6m2fEwEYS1gXA1R3WJWZGWJBVigyA==
X-Received: by 2002:a05:6214:2269:b0:90e:9bc4:b5ef with SMTP id 6a1803df08f44-90e9f204053mr2918426d6.2.1788291500124;
        Tue, 01 Sep 2026 12:38:20 -0700 (PDT)
X-Received: by 2002:a05:6214:2269:b0:90e:9bc4:b5ef with SMTP id 6a1803df08f44-90e9f204053mr2917856d6.2.1788291499545;
        Tue, 01 Sep 2026 12:38:19 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-192.net.columbia.edu. [128.59.177.192])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eee72f8sm1201866d6.36.2026.09.01.12.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 12:38:19 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 01 Sep 2026 15:38:04 -0400
Subject: [PATCH v2 1/2] mm: remove unused mark_page_reserved()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-mm-remove-unused-helpers-v2-1-f6474e169c23@columbia.edu>
References: <20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu>
In-Reply-To: <20260901-mm-remove-unused-helpers-v2-0-f6474e169c23@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788291497; l=880;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=nMKup8aAHqde2/HRWYyidhf/taH83kuQ10G5lwoQHJc=;
 b=l0C/rfJ2tL6vp/XnScWPBe+E55WdXYIZZtur0v7sUT8j79A2O0ZPKk9YSmL0B0vuTGM8WxIDe
 SL1m4UoW3LpD/GtGHDUgs9vGQHxSk2vrti0OnLzrV+fFAJUxTv4pT9t
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=ObSoyBTY c=1 sm=1 tr=0 ts=6a9729ad cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=l2kTeM/jHJEfm+IcnTWp2g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=Lf-Zv48p-cCuowO2M18A:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDE3MiBTYWx0ZWRfX9K/5viFy0H6o
 jk0dLxYnriUdV8iTd59tN8ZFdHLKSPegoPmyxGxuub+/oWgij0OBZtueSO/V9vctfx3wVZnWRWY
 HAVXUhxYLphNLDygilCDhtFTU2o2XTvOyN5o61WncBhmWifNzTN0Kg0k4yf0Jk+bB0s7x3BpDup
 H6hM7ShcLdYw0WF6Mj3utN5BIXWTti6WZe6vyuUkqgJihjetBJROvlqRDRycFgJEudLmNKkAS4u
 fHJyUhXjmiGB7Z0l6HYzlqqvkLYBq2F0BGVXmXf+u0tnvjfhCJl2A5PvgPzkNRs5/3kqlnqGnDH
 YPixyEtpKEOyzvKDizpxEQIl4qFDScUB3Orwx9/jRscLHKHpWKDexWIY+1KyxlyMeBDYikRaktD
 fARqVuM1yGz9RoYaTu+SoIKAbBi/YPadTkg0DcHQRtxxffQhmQaiXxorJYiJXoWidjsdrmPbL+H
 KwNOVS0kteXvfWr12UA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDE3MiBTYWx0ZWRfX5IcDIffgN270
 8/WMumyxeBFlZnYv5AuhzjC088ajwPWOIk2SKIssGVTpAkHxYNwaTCJMgjWFS4mKhjjX+eE7rOA
 WR4XzVztXhdP5lzk7s0mo73pOoVdOy7ys91Zli1t6M9THevDIQPX
X-Proofpoint-GUID: AklfKOvM8ze4U7Q7UkTgF7G4pDH-Y3W0
X-Proofpoint-ORIG-GUID: AklfKOvM8ze4U7Q7UkTgF7G4pDH-Y3W0
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11893
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 phishscore=0 bulkscore=10
 lowpriorityscore=10 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010172
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 815B2A0006
X-Stat-Signature: yg1w4tgwo8fehbdm5dt4o18ffcprb36e
X-Rspam-User: 
X-HE-Tag: 1788291502-775556
X-HE-Meta: U2FsdGVkX1/AdKY1DI9cUND/aHBUuYwjYjZGMkcUP1Jlrqdn3jVBHAmD72YXsTnPjciC+ugr7/Dr3KqUKQzigXPoQiW8Dquc4Ov7zAufvkf1oXZl76/wMKyCZ37xV8QLUc8tGukRAesPxc+lf2w5bexKLSkoQDsqDuiPyLVN9Y9VjoGIhqO+A8z63+5ErOJq21ZeP6N5YarAeAgm53BOjrhWvNirqhQNaDB0UHPekEWb90gKVuQ/9aCb7LW/kO9c8xEFNIkPwxmptpLAcpcW9+7ZgyqIyMxeSVCNi5TUi5nsivJykCgGxSq6i+UU2w7F36BHzDHT8MhnAIwh192aHBiNxAEqQnTo9ETjQbt9pE99GY2HIj1IEUWhcnh9OTNbqrGi03a4beDoLfBANeySbfJUX45t3tsRxd4XWX5z++GZLrJaDbypCmA4d+5iIwxG7YEPQmYEF2Bwt42YdgyzVZpnC3nbqGC2LMtA/EjUT/88I3LXbhwhFG6gLcZA/57uZgk1s/U+VeZKW53GsGM2PlnPNYNlK5G32Q9Gxtsbio+26P0nBmkJVJk8wLZrwfwBUJi+TS2nzSI8q8pK6UTEPK2xG/g/PPhQyG7DUu48CTNROhaoxzl2hSnen19FaGkaH3N4m9COzKxsDQ4fbPuI1bM522AGxnKR7dDFrlSJdIzB3My6R+44uDfcg32Xg63W03QxEnKZmZ757BBAKs8LUr2XxKq1SH1gpvgZdnaXghRnm1byChgbhZWkrJx+BvAvzCh1a6M7w38yAVHt5xL23gf/ob87pIZ4/AYXXlmQNix+n8LQAAePb4Qm5ZquKqoaaGV3/EM7T86pHJkFI5ulCy/jQOWdlmcOVFmLYs/FY3ezJ4ggPWhBfarlICRDbvdZOaDq4i80MXwFeEOy3UjlEULsMOfR1978fjY1tTrHBRVay/4j8YXbsI63AMIl9pQ0ZRKdEGJzjMQm/wzt8KK
 ldWRJsls
 1BmublmFdcIddUe27If+zwIy99X5Dj7jPQ0aVTBl7r3lFh4ZL8+4tx5BbEj9pB9oIxLIb5eDbbpG77OdIAUd+yp96/wA6z4AdDiNp7X5oW48JqRJ/GBpWQcOD+404gzVpG4V1bbNPOy6SwLPIgcIaWPXngL8uEMsI0ARiiMRP+M+ivPb0n0naD5PoFQGVV8+qiJeWZHdFwgwoXtc1AzLIg8Ppkqiloc7WVQUcJKQP3fYc25j6M6h5Rn8qy1aHJ4pHQgHdxXp1JOwZ5NDW8JSgvN+eJ1oWPOu80QQj2z6oCxns8ozw/AduePws0GnVyQSMrWL619T3boDb/dZ0elenkL+CSEcAzGzeNhcJHDr/4tCPVDjLhLhlJPQMzXRFOm4E96VCwvd16+U3yvx9GxBNsrDVQlTNBEDStPnByKPrnOMWce/q8fNnfjMMT3Uk9uAKRheA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mark_page_reserved() lost its last caller in commit 6215d9f4470f ("arch,
mm: consolidate empty_zero_page"). Remove it.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/mm.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1b28e6fc8d5d..e3736c42c4db 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4080,12 +4080,6 @@ static inline void free_reserved_page(struct page *page)
 	free_reserved_pages(page, 0);
 }
 
-static inline void mark_page_reserved(struct page *page)
-{
-	SetPageReserved(page);
-	adjust_managed_page_count(page, -1);
-}
-
 static inline void free_reserved_ptdesc(struct ptdesc *pt)
 {
 	free_reserved_page(ptdesc_page(pt));

-- 
2.39.5


