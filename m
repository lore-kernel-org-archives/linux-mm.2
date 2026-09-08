Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 341D0C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC66A6B00A4; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F576B00A5; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D657B6B00A6; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC8246B00A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CE23120684
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:55 +0000 (UTC)
X-FDA: 85190947590.11.C060211
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9285D180011
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PB+XrZxP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=UkiC5HX6;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/juGQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=;
	b=jxR7SdqnCJnmoc8uUQf+G+qr3nD/HI+xzv28+mBdWhLVLuxCPIUqB+V4OpjqI/ViMl1VGG
	kvg6xYIQ91A+XrEWogHkcbxsU+tgn7Nmu80sc7ANCjBdxZILpG7ceeKyVaENmFyP8hcaj9
	mDuux/VyBbVyeBPX8tgf6osRXF0acVU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PB+XrZxP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=UkiC5HX6;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880612;
	b=2KVDSUYlZRSUjyH8T3IvyhWgptVLp0J8Y1BPweFPsJ6qnOOYEVUbozBIl0k/SGrOtCpLA1
	DPOEr6KJnLX9WVJaKvQbyz+Jy/zTyXzpvmaXojuJ+YIBOOxYP7572FIBU/THAyZQyt6iOZ
	NUCWqdAtNWBh8sR99AonnrNOD9JdQ68=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYllN1082081
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=d/ju
	GQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=; b=PB+XrZxPTwrkXbTyYVYd
	lumHQ20EoJN0qSaX0iS4gdwRdgCm0ih1QdVMcHCfxMyxoeBesUAwedtVTF0Jn1Rf
	jwD8hGuisXzAiFVARxfvQKG+jr5u2hvkKdechYgQE4CBe6hCBfDkYf9Kq/g4WGEh
	sDjVp39yDqviUY9iyHs7d3HzHYME+KHUbElN87zOQwdhnAIgZmMCl0BLYovoJxrB
	AeZzl68wQ34cCgR+BxZdmJ3uIpXtogr9+A0ljJmO5mMqi0L4Qk4UxZnkD+0e4BsY
	3DS9Kc9SEDVtaj8C0R6dUKbMLGvVED40s4NWh91cEozh2jxEAyIZMffO1UBdh/x7
	yw==
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com [74.125.224.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gjhqktayb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:51 -0400 (EDT)
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66ce3040ea9so6017405d50.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880610; x=1789485410; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d/juGQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=;
        b=UkiC5HX6TlVDH/IDczaBy6lPeeKSzJRkMQ4YGOklppfbMecXZuu2vyYFZbKwQbbPax
         ilpsKGFfgnvejb5ufiwIkeoS/qIHU+pHVKKZ3Ckv7ku1/tyybXPgcgc5sbduZtQVa+xO
         6OiUCaR8vPLKFqjBVyNkSosrBizpKnzZr3olC9yNpd7mTl0ATb/M3bcpE0y7EpeL+qdi
         GGydc0dItpxzvVYwMeIV0ATtkGAmheorXYUtY9AJviCQ1aEQfagJxzs/n3QEbYz/pQg4
         Z64JLCLfxbgmpqNToAIYktQVeuGjcO8JmjSll+VIB030Y9fSTpbRdwAeOh86OrUYr2QD
         cu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880610; x=1789485410;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d/juGQBpeXjCCGF/Jvctg7hi+/3D3O4YYez7MG8kxSg=;
        b=ZUsdnbJRy0LY32oINy7t6Nc/VdwH5lUr6IWXvvF9KhrMFDbmm6//1yc30U5qJFrzLB
         pBHIgKN+EE6k3JZSeh0zuCLw8ZlBnv9+STmukuU52Oh2F1H5SsW+m8CRcXtiYEQmBM4e
         HaQk8S3KS/l7KBPnn3vSdIvRWVlIuzDFzhtZIF90zYthmjAUv0B4LDZtcSjirs0S4mnz
         LtNYzzC6jvttcKzNx+bH66tXXeN58zauBdBMYIyhK39UByU8rHjhPBXJxs0tTh+/dprY
         e3wOehdkpApzn3JWDtUQFQv4wPFskdBGaisVfoKFm7YnjoQbHQOoJGsnvRMONbzbh/Jp
         EEig==
X-Gm-Message-State: AFuF++nsIIQMSASGM50KLdL+MRvTxUKDaQKzn/3vyhPrZmJdOBnxmLLd
	2s34R30NF7QRQIBzuP+oz0D6dh5v/nIutuBZV88yH/THa9RuFzwqzKtvR5gldjiA4BTS88S0drO
	Gbqf4R8CceHwmqzrQ60JNKi/HNOpf4XqhIcURZ3JlmLGaCmEr
X-Gm-Gg: AYBFou0a7ZKMlBSdNKB8o8LmcTy9nHNTNydrOp9ACboyT7r7CisphqgMINwNKtfs2kk
	3o7DIifyZMKEnEd2YEMaq7rolqbiBTMng1Q39sNOhAl3Y5XLzPhBaelPFU714OrQVHbcL3xyl2E
	DNX8pu6gjVxKp0HquPMpPafZ9QcNMfHFIaMbzqyeRKSU+8VmBQghyy5ZK/MqfoPp1K2r1oeSzXR
	rMMq7nQgyYTJPlTXu6DiIvFBAkweGx2JVcN2DLG6QLBm3gVr1IowmETeSXKL9kb82iQtO7b2iw9
	S2oi4DiZlRsfv3/828HTgDyH1M0cwKz8pqw6Q3LrMx6wdj7kLYs2pzCvXkernlXktNmeUWly09B
	L1ZpSUaNN3cwyyjChZNHBu0Du2Z8QqUFgGHotZ7aVSGv93s3BVx2f0w==
X-Received: by 2002:a05:690e:4513:20b0:66f:c8e4:f013 with SMTP id 956f58d0204a3-66fc8e4f18dmr4249086d50.50.1788880610229;
        Tue, 08 Sep 2026 08:16:50 -0700 (PDT)
X-Received: by 2002:a05:690e:4513:20b0:66f:c8e4:f013 with SMTP id 956f58d0204a3-66fc8e4f18dmr4249033d50.50.1788880609732;
        Tue, 08 Sep 2026 08:16:49 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:49 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:36 -0400
Subject: [PATCH v2 6/8] arm64: mte: make mte_save_tags() and
 mte_restore_tags() static
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-6-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=1787;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=JMnLiPjPeuQ8XHbUf4RdPN6u8wF8V4jepqQl+nANMew=;
 b=gGrVpzINCdcX9e9UtB7ydxsckIe/46z/TwXW94oeS12x2L3iuyn2uigTEvuOZbHdpQe5OV2Um
 +P1oxTLmtU0CwWIE5zTT16WQtchDHj8G1SYst8releCqJFl2APeIPvs
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfXxYTBmPR6k1kD
 GF27Ob6qPjimTMikgDWRy3neLWgVsMZucWUvKT/dI45OzJ7PIKt0k9n3GRlpZHW4jGE6zkJJMJV
 pZEq48nqRkW/vqXpwlgepsBPexYVewbjITd4ZvncFj/OcDvke1F0HLgJM56avuSnqBn+GDcMK24
 P/c0ZLMeZkQZyJ+Zh+F0p39CmsAkg0hbPKE+ZuxFsp4rtyw54LM3yahaVeJ9BiJRyXmuA1hC56a
 SHGCW9PtR7pdNGhm45yqQ76NzUV5yG4sLVugGiLEFiYO9RW/Rt7+aKFVuJHXqZI4oSU6IMD3GfV
 N+u6pSR12A9jU4PSVM8Dww4fbW3/hrtbjugUkDGlYBFQkVlDc3dwScVy8aVaGg+kM2RENl/gdL/
 OCGK+tfH2JBhOTYfQfk7uyMvfbRoSSkiAaFcjOfDEiJGxsC52LPzGGcH1lVd+XW7rbX4v2sp60x
 OLyMWFEowLpTkC6UtkQ==
X-Proofpoint-ORIG-GUID: fxz5IIiru2KMw7bFxy3aR4f5QN4WJ3DQ
X-Authority-Analysis: v=2.4 cv=CuOPtH4D c=1 sm=1 tr=0 ts=6aa026e3 cx=c_pps
 a=S/uc88zpIJVNbziUnJ6G4Q==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=f-bboeSTcrnmky8UUdsA:9 a=QEXdDO2ut3YA:10 a=nd2WpGr1bMy9NW-iytEl:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX2XCAU+cBDRp8
 7jGiDFCvH/jHRJSgcGKmEao2324luo8UAy39li7D/gKjWwqMdbsMgarbmpsmcQvErG/faB5PZiI
 3Tt8C3V00NqRu+1AINrsEqVmtqt2TuB25NPLAIkxjcrJlZRxG4EY
X-Proofpoint-GUID: fxz5IIiru2KMw7bFxy3aR4f5QN4WJ3DQ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=10 spamscore=0 bulkscore=10
 clxscore=1015 impostorscore=10 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080165
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9285D180011
X-Stat-Signature: axdzoib8hztruz6x5si1435arzfoxay5
X-Rspam-User: 
X-HE-Tag: 1788880612-264161
X-HE-Meta: U2FsdGVkX1+EfpZT7TZ7P7So0XlaLNm35CX6l4PLWN9PBL87qK+8QZGqrZNY0+wyvAdL+v0DARQDaJIz43LYwE0XZhxSvNXUTKgrHKEOaR6z7mMUpi7x5JvkYBjxkfxpFgvIBP6QaV38tKjmWznEpBl15a8OPT/fHWeM5yqoLlQecleXPiOQiIsBNpVSnRHrtPnsNHC9yY8jVf3fmyVmX/lf2wrTcrFb15Q32QkSBS9F2Z7slAJfnQoJTak1w4oiXqgQKWO7rFzFdhLJ1vbtQO3x4OGJt/yt/scWmyhW5CqqX/MokdoEh5s6dFLL94YfzZZAo54n/rSzmcO5yN6bZTrbtzpv5Sqvo5JKkbR/jnY195l7sFP13VzN+e5LeqGIr9Xs4J8cB/4rGLZqkax+xUNZ0n4jeIYDgb+O2u9+OuruxfpmIZ/Kg8r+NQuYzIirxe4TTmMvMdMqnUTUtEmYRvPLqfsov6QRQppih4EWwkjLCWMcTjjaQkTyr8yclXSmKOUqpXLAg9bM5BgIn8TcwIudPDfW5bQ5EaXPOk/3RzCap+cz66fOU/4uzs0xORfTLMhfhgTMV4mtnYr9plsmY8HPK8ivYpO0n+7PPeNbzTfix+NQuRp3ktoRjGWDKCJ1iAvYkGaOQnLIA3CkWKgbzxElCi7EP2pEW8cqMEFhCKzrlp3WfG9zS5H4APYA8iU1cApJDS3Xd/D3UD42RCln2+3I9G14SPTdndblE3BbQRh7Du8ppqo4VCUCZMtXPsjG+V7nvcMSSw7wkVk2mHsZWchnXwtrN78S5CyyIf/q136UWhu/sPqqadSKsBknnJjszeekUT0VZiI10orP7EydEqNdlFD0CXk53ZSRoxfGIUd0k4tyKvb7iHrlWgfnNjW8jE6QVKOxGECoBH/f5wt1bCcBDLu9D2/tJqZBB/PCOXGc/see6OHm96Q1yNaAV6BysnhMoYV96P+PS2LWH+f
 W2rqcNkp
 S4PZ2i9hk4SVxauvl4FHoFk/pMZw2c611mIZONUp8n3xAO380p/Nyde1NFFZA1g3T3fDbyRjRRfxBe8AcG4nx04McVkpdJd75SBrYoP2YOQQQ/RBqHXcJ5ACiISMYW1I7c2iG0jYKmz8KBQF+mLXa+6KC4uO0WaAfbB/Ao4gX0MubSXHOBh06EUPwcHBoPmfAYciW+dTwY8ytQxrLsLRhYMRKWh4fMiIKCqqZArHEW8dMMrWCNAccGqcVWV+fTlfwKwXscYPmXW3FqC1BlPdvYlUxB+lY4cCuxQ2f03KILWWxIyKmyzC6Nv8ioABhvYjB3pYiaTjAZC62y8/IcmFf26NKDEIIMX9KQk7/E67hsAVwcMUWWlfH0lEzifolaKVfr5zFKVIrWpjTuobmEfaARBrEzNMc9t0JzQ7OmgrNJ+SeSE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mte_save_tags() and mte_restore_tags() are only used by
arch_prepare_to_swap() and arch_swap_restore() in mteswap.c. Make them
static and remove their declarations from mte.h.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 arch/arm64/include/asm/mte.h | 2 --
 arch/arm64/mm/mteswap.c      | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 7f7b97e09996..83f3b05fc784 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -23,9 +23,7 @@ unsigned long mte_copy_tags_from_user(void *to, const void __user *from,
 				      unsigned long n);
 unsigned long mte_copy_tags_to_user(void __user *to, void *from,
 				    unsigned long n);
-int mte_save_tags(struct page *page);
 void mte_save_page_tags(const void *page_addr, void *tag_storage);
-void mte_restore_tags(swp_entry_t entry, struct page *page);
 void mte_restore_page_tags(void *page_addr, const void *tag_storage);
 void mte_invalidate_tags(int type, pgoff_t offset);
 void mte_invalidate_tags_area(int type);
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index 63e8d72f202a..3c54afc8b758 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -20,7 +20,7 @@ void mte_free_tag_storage(char *storage)
 	kfree(storage);
 }
 
-int mte_save_tags(struct page *page)
+static int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
@@ -47,7 +47,7 @@ int mte_save_tags(struct page *page)
 	return 0;
 }
 
-void mte_restore_tags(swp_entry_t entry, struct page *page)
+static void mte_restore_tags(swp_entry_t entry, struct page *page)
 {
 	void *tags = xa_load(&mte_pages, entry.val);
 

-- 
2.39.5


