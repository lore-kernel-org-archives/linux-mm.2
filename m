Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAAA4C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 10:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A705C6B008A; Sun, 30 Aug 2026 06:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48536B008C; Sun, 30 Aug 2026 06:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9375F6B0092; Sun, 30 Aug 2026 06:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 619906B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD9D01C01A7
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:32 +0000 (UTC)
X-FDA: 85157574264.18.BD9F7AA
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4705A100005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:33:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JfFX8hjA;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=o6HJ71Vg;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788086010;
	b=bDGu9EJDJPAjeY0w9+jxvxNPnDcBd4ZkfotEt03VrFEhmW+pJ5+98ixmEfjbgi74fUPGyV
	VDG/EEV0KRj/oKPFWFkkUeqHX8uxVUvwsxnG6N5KDDKFHScwRdotUZ5Xx8/dffHHyWrtdK
	9DKr+jC7hsBKlSfVCsNLTXrQK41qeFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788086010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIf6mQ5jieSfsR95OPMrcqML+UpgXiaHxu+WpaiXhhc=;
	b=xGbRNMxZZNdtxSVzkDYl8wS1y/8gZzhkggyjrEKqvHWXrp0C6n0GklPYm3SBUG066ouAme
	EL5IWKO7oKdFwouhMvzapTqp8+cLaMfnd3+FC+US5EnE8us/pcQnKbB5mDrl6E5ZD1B1o7
	IYMT38L8ZkcIu8zbUAS2jedTVmKdKKY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=JfFX8hjA;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=o6HJ71Vg;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U9hcP53314905
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=DIf6
	mQ5jieSfsR95OPMrcqML+UpgXiaHxu+WpaiXhhc=; b=JfFX8hjA6sQeEQXVtvti
	qnAfnWQsEs219hHrOd1/v7ObcfRTKu71Um7EpMgtShSNfWiTyXtudW0PGmRmAuK4
	UuF22g+V0C1TnGy6dLpcIyZ5n9gsqlCagIz3B3vHfg7uq+Yz1e6d7c4kRRgR12mq
	Req+NB22JNLGSsTVp4+l/CeOR1InYFXxWSrcqezZrSLdK5M5dxtCgdV6q01LHIOO
	7+pjZmjffLiZWwTnig2OryPwCjYCSJpPYvOyN1yySfVaZV1ScK840Ubrn1nLm7xH
	hEUF5kf8ls6QDE7bLcSwjVbkJHIO/N1Ykfbejnln7XfsB8dyMBu1udurkTxB8y9e
	0Q==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbuaa4n49-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:33:29 -0400 (EDT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52dcf1bb6e9so51263391cf.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788086008; x=1788690808; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DIf6mQ5jieSfsR95OPMrcqML+UpgXiaHxu+WpaiXhhc=;
        b=o6HJ71VgIphzLfDu9747hKD19WPBmKC///lOSSiLdsemAGKSM/m1IHWSGkL9NlVQC2
         UpHy+HZg4VVQBihtrLDYG8NzkCJsljpIxI1pz3eT6IQ3XkwxL8wkcoDEsw9JsdEjeFSk
         iZZSzK4pCIAEca2DEvL37ctquJTgZBifNZY60f5Fk9GxCoF6iCwe3gblWu3pu1ysr4FL
         7boXwZItfZecFfCLbPtJbx0Vo8+0T647les7+PCN122zTLk6WXYxwQxjAaAcICi99iJM
         OE2ueKoSTnCTmPqCNK3HQPqJqwyGvTFYDsvoLk2LQnVHmj6jRkFuumaatnd0MkUF4KPe
         Amaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788086008; x=1788690808;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DIf6mQ5jieSfsR95OPMrcqML+UpgXiaHxu+WpaiXhhc=;
        b=qbJUfcZWQXzzEoxrDNkh7KpEPabNWiZAVMAqG3NZHo23Cz2ZMzfSZ41UTqo0Fbay+y
         niZ3jmZlVLHPj/88fwqlmM52MHobwDOs9PPB/Gc8yD/8GFjfykTg2z7OkR+oGZIdzJnQ
         QzyVHGKKTp0P1pl8SSDTTUj6ae9IqTZEJc8LnAtVwFWTDvxGe694QAOWq0gHRbamkd4k
         le7d5OHZ5UEQYgkX8F3IcQYZNBtxZMBiKF+WU4qCDpk1eyIu3iW1Iy3iNFwe2W0BKDiu
         I/NND1Bbr5uzbPWCqKkeJltwctiZwMqfjo+G074QaahPIfhK0NQg5qsWxljzJN/fpNEE
         7nbg==
X-Gm-Message-State: AFuF++njypG1gzRDWlyj4u8BvmrDqChTotXNALGqzNfECjgK/iaimNxH
	VzChuQUdimzTt6OCsu3tzclEq8MHl3YJ4Sbw/RnioLHTg1LTbocdzKyt8LS7++5kAId0v7wrwqn
	KbmMWOwhG8/D75NjwMvKAPtw/AtNEOFJqjCpoZ6+zxdeO7iY3
X-Gm-Gg: AR+sD10Wn9kDWwkywdbEqKCJxsdQcsMgg4KIno+0T37uPLQD6KGI8e6vkBVxmZkLFfH
	Y0/HHlb8j3zdTqTTgu3hXPpTn/11lJ0SUxwoPjnQfnDG5HezJLrSFWiUTMz/p80ES0Wo4t7fz8V
	YYG8BauJlCqG6s481ZlL0e4+wnaAgifJy3cKaDneiFM8JzjfFtTOxY4ybN7TMjJw6MHE4n9W7tK
	YIApBFO2MNZ5LNwMXQxhGtrU2IbjrCE+EJyZHQY/6tardOoSaq+z/1sNuIP0AgliUb8ziThLXgo
	38blvWO14PV0shedg3GaA9Uq56K4AWh3u5zMKHpF7D0pAxtCXrdy/n99M7Li7NsE2fVgLbquooP
	3wVes0jNCcLBcnt1tbyL1YxRpwdNnBZmDdMeEmYo6JQ==
X-Received: by 2002:ac8:58ca:0:b0:517:c582:9161 with SMTP id d75a77b69052e-5300b777e98mr17168861cf.7.1788086008588;
        Sun, 30 Aug 2026 03:33:28 -0700 (PDT)
X-Received: by 2002:ac8:58ca:0:b0:517:c582:9161 with SMTP id d75a77b69052e-5300b777e98mr17168361cf.7.1788086008153;
        Sun, 30 Aug 2026 03:33:28 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ccf5a580esm69304005e9.3.2026.08.30.03.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 03:33:27 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sun, 30 Aug 2026 06:32:23 -0400
Subject: [PATCH 1/8] mm/swap: add folio_swap_entry() and
 folio_page_swap_entry()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-folio_swap_entry-v1-1-7786b52acbc8@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788085997; l=2036;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=il7UMsRwFpzsLvluAxhowLr70Y3ODPga+2MhlPhEB3w=;
 b=740giHW+JUpfeL6BrdRfZ53BORRJ9DwBndjIt8Y9Znr21EeDOFcOZuhC9z/byBObIyBHeFQGI
 IjGTGV0AMNCDMktbmt2wy/syZZ5NwzV/2uTptcpt9hVzAKxCLlfl40u
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=EZv4hvmC c=1 sm=1 tr=0 ts=6a9406f9 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=wCX1QjJdxvQAooojgaYA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX5fqeBP2T/J0j
 5eCNh+/tu4SPOdMiOkLSYLrmCVXnISiFPeM3uOx8UyCUKHMWkoOrfrcV7ONf87VrNZdnBdeVCTb
 ANt4cdJtCLFjyxzYQCdWLJSsFjraZzybR/9S2vzL1K79xf09k2Zr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA4OCBTYWx0ZWRfX2bh8k0slUqWH
 iyRqS9BHOKngUofMVKjwvE7qQLv4Pj9DuUSiWF3qZm7x3B+YjYidHOaCsMzvVVlEqQ4frbX4aOj
 3MVNdJGpj6nv8bQGkHSg/aVv+j1fDCiPM/R3D/2NC479LMXYK819DCAbOpGJAbjTmsq4nJ4bp2+
 iOpQc0bp/1+/4Naf6tiU+SyHk23PjgyQdrwsqIYljAhcYeGuOmy0SpfZXLAeIabkzguoYjTAl/w
 SmysIrxO1RKc5BafBaY5B9bFBsk9V6K9xihsZiKWlQT6JLsxlyIHHL3Hfvxnd9GrydB64rhsxFW
 18zIfCK+TPtVyHiDIaGSo8TvjWzj1v9Hk2rvDH0ey5s6nTM1ANXuFZpeGY0NMHBZ9awlsR/xcf8
 LTp/kNXfhqXJpqPNnmvh4XFP7slT33R5YF2fICfRn+ZhzQtGTbBBIXc/yARdZOmMKIO2wVRjynR
 /ua3jV8JKGDbGw4dixQ==
X-Proofpoint-GUID: CII-z6TWVTKzyZ7KKlAA1M_nn_7pjY6b
X-Proofpoint-ORIG-GUID: CII-z6TWVTKzyZ7KKlAA1M_nn_7pjY6b
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 clxscore=1015 phishscore=0 suspectscore=0
 lowpriorityscore=10 adultscore=0 malwarescore=0 priorityscore=1501
 bulkscore=10 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608300088
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4705A100005
X-Stat-Signature: tau9oxmd9tf561gbwdxpx4njojwidfik
X-HE-Tag: 1788086010-270067
X-HE-Meta: U2FsdGVkX18gYMoKdg0mqA/yDd55I/yClSqzcVdWi5NdfkONKUVjADJXChbq7pVcdblNLUBSNZdr7tFBqQK+RD6kHKBCxMkMq/l52Pq8qswzU38yF9uCOU59veuu+GzHoqyW3wcF9DaL2joH5+X+borz1mglfTSVCJeDXASHJrvxqDWZlT+U8DQwIIWghoneNzhbVp5vQ3qhGjhRyfo85BbvzlR/bZcl4FbGj0j2f/tv9BM+H7P+uyOw35ywrOvuuIu1PlhzQHLO+tr/ltuKSt/LtA1TuQsqyVqycN2R5WVVSpz2ivRTCWjOKAcPELqsKIOxP/yHWsqvrkAfYvGZZ4ZJsH31AcjskzHYYgX3VL5IX3jmDKHc36ciqbDI4flGUZDPcxm0L/LQKXdvbiTnOAnsOFXjSCYZbo/34Razhd0zN+LjJYvbnvu1b0NcwelNUD2Gd2jm9/JnAXL9DujmIm+QsVl3C45v/3L/itVNmtAb6yvQd7s9clke1bTvD8uUmOgQB2r8mpn2fzfcboBWPnVsPuWjIu0gwITfpkz0/yDfOf2sZcZHjx3Mvdo8RFWPxGrQTPwP/AA/KCiFCxzodTHbCXLqfYjOfchcomaSi53JYTJ0lXm0AiDqA32k5Jo9VzJYUWLPdmzdtD/eAntUYEnY48z/ovG/ckP+z8rN6BhSRgJaHokrfnK85mpziKEEMK97SS0KD8wcXSMl5fpq10lDfC1MAH/LyFmJvdMJXL7gW4sDYQHmuV7Ueio+b3y3E86AglSjjHl7py48yOpNmbxhuEic+AmmQ9kzbJ9onI0iGQFzzeCew7H3Ohx8FwIl+HjcQbz/66fps1N89sFQhe2edxgNf29hbVcGjTq8ux/REN9RLYKp3mMWUtpSGA5wi1YSF+pGeSLGlyBUTGpNbapwxE7B0q0XyYPylVwfAyhbP+8eqaAJbUBXxWl6t0qg4jpQ52Prj74SznZF8Q5
 cm0lyCYH
 0JrFzWaGs0x+QfdvBGqytSQIDnmjRMQUpuW6N0HjQEecEsFXwICzfskzQNblaPA7McXgGoWsY4hjFjJekTTg7aHeADpRjgfBXUj2IzUcYLb/vYpl8/eyRUBPt/zcjxEYLQfR67TQFlH0HzHZXw5nU95vE6fRp/VpQ8XZ2a3sIPD3CzCyDBlA70jdVB+jKIlTet4rt2JYb4AtjpwgtnnpSRe6qHlwjohR9zHYZf6idvIodt4ruQXMMzzuRcvhXaKYGnOl+0D5eT4N/E4tyPRIjMPkNVU3KX5NFcXoq1Gv7J9n+lybtnc+De4kgQRpJ+hG8+3RR03o70teCJhoRrI6UqsyE9OTgQdiPrzQHsqLu9SbP76oiaUbwe5qrnJM0tBYN+1tdvui9VEHp8391xLYMq3GmZ9LjS4MW+fG4dhKKffRJ1Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A folio in the swap cache occupies folio_nr_pages() contiguous swap
entries starting at folio->swap, so a page's swap entry is just
folio->swap plus the page's index in the folio. page_swap_entry() hides
this behind a compound_head() call, and callers that already have the
folio sometimes open-code the arithmetic instead.

Add folio_swap_entry(), which takes a folio and a page index, and
folio_page_swap_entry() for callers that have the page.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/swap.h | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0f953ed9c863..48632aacbc2a 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -278,6 +278,39 @@ struct swap_info_struct {
 	const struct swap_ops *ops;
 };
 
+/**
+ * folio_swap_entry - Return the swap entry for a page within a folio.
+ * @folio: The folio.
+ * @idx: The index of the page within the folio.
+ *
+ * A folio in the swap cache occupies folio_nr_pages() contiguous swap
+ * entries starting at folio->swap. The caller must ensure the folio is
+ * in the swap cache and that @idx is within the folio.
+ */
+static inline
+swp_entry_t folio_swap_entry(const struct folio *folio, unsigned long idx)
+{
+	swp_entry_t entry = folio->swap;
+
+	VM_WARN_ON_ONCE_FOLIO(idx >= folio_nr_pages(folio), folio);
+	entry.val += idx;
+	return entry;
+}
+
+/**
+ * folio_page_swap_entry - Return the swap entry of a page in a folio.
+ * @folio: The folio containing @page.
+ * @page: A page within @folio.
+ *
+ * The caller must ensure the folio is in the swap cache and that @page
+ * is part of @folio.
+ */
+static inline swp_entry_t folio_page_swap_entry(const struct folio *folio,
+		const struct page *page)
+{
+	return folio_swap_entry(folio, folio_page_idx(folio, page));
+}
+
 static inline swp_entry_t page_swap_entry(struct page *page)
 {
 	struct folio *folio = page_folio(page);

-- 
2.39.5


